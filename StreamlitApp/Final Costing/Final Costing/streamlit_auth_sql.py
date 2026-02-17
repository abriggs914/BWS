import streamlit as st
import pandas as pd
import json
import hashlib
import secrets
import hmac
import pyodbc
from datetime import datetime, timezone, date

VERSION = \
    """
    General Pyodbc connection handler.
    Geared towards BWS connections.
    Improved to use SQL over JSON.
    Version...............1.1
    Date...........2026-02-17
    Author(s)....Avery Briggs
    """


#######################################################################################################################
#######################################################################################################################
#######################################################################################################################


def VERSION_DETAILS():
    return VERSION.lower().split("version")[0].strip()


def VERSION_NUMBER():
    return float(".".join(VERSION.lower().split("version")[-1].split("date")[0].split(".")[-2:]).strip())


def VERSION_DATE():
    return datetime.strptime(VERSION.lower().split("date")[-1].split("author")[0].split(".")[-1].strip(), "%Y-%m-%d")


def VERSION_AUTHORS():
    return [w.removeprefix(".").strip().title() for w in VERSION.lower().split("author(s)")[-1].split("..") if w.strip()]


#######################################################################################################################
#######################################################################################################################
#######################################################################################################################


# -----------------------------------------------------------------------------
# CONFIG
# -----------------------------------------------------------------------------

# Prefer st.secrets; fallback to env var
# Example:
# DRIVER={ODBC Driver 18 for SQL Server};SERVER=YOURSERVER;DATABASE=YOURDB;Trusted_Connection=yes;Encrypt=no;
CONN_STR = (
	st.secrets.get("sql_auth_conn_str", None)
	or st.secrets.get("sqlserver", {}).get("conn_str", None)
)

if CONN_STR is None:
	import os
	CONN_STR = os.getenv("SQL_AUTH_CONN_STR")

PBKDF2_ITERS = 100_000


# -----------------------------------------------------------------------------
# DB CONNECTION (cached per process)
# -----------------------------------------------------------------------------


def build_conn_str() -> str:
	s = st.secrets["sqlserver"]
	parts = [
		f"DRIVER={s['driver']}",
		f"SERVER={s['server']}",
		f"DATABASE={s['database']}",
		f"UID={s['uid']}",
		f"PWD={s['pwd']}",
		f"Encrypt={s.get('encrypt','no')}",
		f"TrustServerCertificate={s.get('trust_cert','yes')}",
	]
	c_str = ";".join(parts)
	return c_str


@st.cache_resource
def get_conn():
	return pyodbc.connect(build_conn_str(), autocommit=False)


def utc_now() -> datetime:
	return datetime.now(timezone.utc)


def utc_iso(dt: datetime) -> str:
	return dt.astimezone(timezone.utc).isoformat()


# -----------------------------------------------------------------------------
# PASSWORD HASHING (same behavior as your current file)
# -----------------------------------------------------------------------------

def hash_password(password: str, salt_hex: str | None = None, iters: int = PBKDF2_ITERS) -> tuple[str, str]:
	"""
	Returns (salt_hex, password_hash_hex) using PBKDF2-HMAC-SHA256.
	"""
	if salt_hex is None:
		salt_hex = secrets.token_hex(16)  # 16 bytes -> 32 hex chars

	pw_bytes = password.encode("utf-8")
	salt_bytes = bytes.fromhex(salt_hex)
	pw_hash = hashlib.pbkdf2_hmac("sha256", pw_bytes, salt_bytes, iters)
	return salt_hex, pw_hash.hex()


def verify_password(password: str, stored_hash_hex: str, salt_hex: str, iters: int) -> bool:
	_, pw_hash_hex = hash_password(password, salt_hex=salt_hex, iters=iters)
	return hmac.compare_digest(pw_hash_hex, stored_hash_hex)


# -----------------------------------------------------------------------------
# LOW-LEVEL QUERIES
# -----------------------------------------------------------------------------

def _get_user_row(username: str):
	"""
	Returns dict or None:
	  { ID, UserName, PasswordHashHex, salt_hex, pbkdf2Iterations,
		FirstAccessUTC, LastAccessUTC, TimesAccessed, Active }
	"""
	username = username.strip().lower()
	conn = get_conn()
	cur = conn.cursor()
	cur.execute(
		"""
		SELECT ID, username, PasswordHashHex, SaltHex, pbkdf2Iterations,
			   FirstAccessUTC, LastAccessUTC, TimesAccessed, Active
		FROM [dbo].[ITSTR_AppUsers]
		WHERE UserName = ?
		""",
		username,
	)
	row = cur.fetchone()
	if not row:
		return None
	cols = [d[0] for d in cur.description]
	return dict(zip(cols, row))


def _log_event(app_name: str, username: str | None, user_id: int | None, success: bool, event_type: str):
	# Keep this best-effort; never block auth on logging failures
	try:
		conn = get_conn()
		cur = conn.cursor()
		cur.execute(
			"""
			INSERT INTO [dbo].[ITSTR_AppUserAccessLog] (ID, UserName, Success, EventType, EventUTC, RemoteIP, UserAgent, AppName)
			VALUES (?, ?, ?, ?, ?, ?, ?, ?)
			""",
			user_id,
			username,
			1 if success else 0,
			event_type,
			utc_now().replace(tzinfo=None),  # DATETIME2 has no tz; store UTC
			st.context.headers.get("X-Forwarded-For") if hasattr(st, "context") else None,
			st.context.headers.get("User-Agent") if hasattr(st, "context") else None,
			app_name
		)
		conn.commit()
	except Exception:
		try:
			get_conn().rollback()
		except Exception:
			pass


# -----------------------------------------------------------------------------
# USER OPERATIONS (SQL-backed)
# -----------------------------------------------------------------------------

def register_user(app_name: str, username: str, password: str) -> tuple[bool, str]:
	username = username.strip().lower()
	if not username:
		return False, "Username cannot be empty."

	salt_hex, pw_hash_hex = hash_password(password)
	now = utc_now().replace(tzinfo=None)  # store UTC naive in DATETIME2

	conn = get_conn()
	cur = conn.cursor()
	try:
		# Transaction: insert user + default settings row (optional)
		args = (
			username,
			pw_hash_hex,
			salt_hex,
			PBKDF2_ITERS,
			now,
			now,
			1,
			1
		)

		cur.execute(
			"""
			INSERT INTO dbo.ITSTR_AppUsers
				(UserName, PasswordHashHex, SaltHex, pbkdf2Iterations,
				 FirstAccessUTC, LastAccessUTC, TimesAccessed, Active)
			OUTPUT INSERTED.ID
			VALUES (?, ?, ?, ?, ?, ?, ?, ?);
			""",
			*args
		)

		row = cur.fetchone()
		if not row:
			raise RuntimeError("Insert succeeded but no ID was returned (unexpected).")

		user_id = int(row[0])

		# create settings row (empty JSON object)
		cur = cur.execute(
			"""
			INSERT INTO [dbo].[ITSTR_AppUserSettings] (ID, SettingsJSON, UpdatedUTC)
			VALUES (?, ?, ?)
			""",
			user_id,
			"{}",
			now,
		)

		conn.commit()
		_log_event(app_name, username, user_id, True, "register")
		return True, f"User '{username}' registered."
	except pyodbc.IntegrityError:
		conn.rollback()
		_log_event(app_name, username, None, False, "register")
		return False, "Username already exists."
	except Exception as e:
		conn.rollback()
		_log_event(app_name, username, None, False, "register")
		return False, f"Registration failed: {e}"


def login_user(app_name: str, username: str, password: str) -> tuple[bool, str]:
	username = username.strip().lower()
	conn = get_conn()
	cur = conn.cursor()

	try:
		# Lock the row while we validate+update to avoid lost updates to TimesAccessed
		cur.execute(
			"""
			SELECT ID, PasswordHashHex, SaltHex, pbkdf2Iterations, Active
			FROM [dbo].[ITSTR_AppUsers] WITH (UPDLOCK, ROWLOCK)
			WHERE UserName = ?
			""",
			username,
		)
		row = cur.fetchone()
		if not row:
			conn.rollback()
			_log_event(app_name, username, None, False, "login")
			return False, "Invalid username or password."

		user_id, stored_hash_hex, salt_hex, iters, is_active = row
		if not is_active:
			conn.rollback()
			_log_event(app_name, username, int(user_id), False, "login")
			return False, "Account is disabled."

		if not verify_password(password, stored_hash_hex, salt_hex, int(iters)):
			conn.rollback()
			_log_event(app_name, username, int(user_id), False, "login")
			return False, "Invalid username or password."

		now = utc_now().replace(tzinfo=None)
		cur.execute(
			"""
			UPDATE [dbo].[ITSTR_AppUsers]
			SET LastAccessUTC = ?,
				TimesAccessed = TimesAccessed + 1
			WHERE ID = ?
			""",
			now,
			int(user_id),
		)
		conn.commit()
		_log_event(app_name, username, int(user_id), True, "login")
		return True, f"Welcome back, {username}!"
	except Exception as e:
		conn.rollback()
		_log_event(app_name, username, None, False, "login")
		return False, f"Login failed: {e}"


def change_user_password(app_name: str, username: str, old_password: str, new_password: str) -> tuple[bool, str]:
	username = username.strip().lower()
	conn = get_conn()
	cur = conn.cursor()

	try:
		# Lock user row during verification+update
		cur.execute(
			"""
			SELECT ID, PasswordHashHex, SaltHex, pbkdf2Iterations
			FROM [dbo].[ITSTR_AppUsers] WITH (UPDLOCK, ROWLOCK)
			WHERE UserName = ?
			""",
			username,
		)
		row = cur.fetchone()
		if not row:
			conn.rollback()
			_log_event(app_name, username, None, False, "pw_change")
			return False, "User not found."

		user_id, stored_hash_hex, salt_hex, iters = row

		if not verify_password(old_password, stored_hash_hex, salt_hex, int(iters)):
			conn.rollback()
			_log_event(app_name, username, int(user_id), False, "pw_change")
			return False, "Old password is incorrect."

		new_salt_hex, new_hash_hex = hash_password(new_password)
		now = utc_now().replace(tzinfo=None)

		cur.execute(
			"""
			UPDATE [dbo].[ITSTR_AppUsers]
			SET SaltHex = ?,
				PasswordHashHex = ?,
				pbkdf2Iterations = ?,
				LastAccessUTC = ?
			WHERE ID = ?
			""",
			new_salt_hex,
			new_hash_hex,
			PBKDF2_ITERS,
			now,
			int(user_id),
		)

		conn.commit()
		_log_event(app_name, username, int(user_id), True, "pw_change")
		return True, "Password updated successfully."
	except Exception as e:
		conn.rollback()
		_log_event(app_name, username, None, False, "pw_change")
		return False, f"Password change failed: {e}"


def get_user_stats(username: str) -> dict | None:
	row = _get_user_row(username)
	if not row:
		return None

	# Match your original keys (stringy display)
	return {
		"FirstAccess": utc_iso(row["FirstAccessUTC"].replace(tzinfo=timezone.utc))
		if row["FirstAccessUTC"] else None,
		"last_access": utc_iso(row["LastAccessUTC"].replace(tzinfo=timezone.utc))
		if row["LastAccessUTC"] else None,
		"TimesAccessed": int(row["TimesAccessed"] or 0),
		"Active": bool(row["Active"]),
		"ID": int(row["ID"]),
	}


def get_user_settings() -> tuple[bool, dict | str]:
	if "user" not in st.session_state:
		msg = "Please log in first."
		st.error(msg)
		return False, msg

	username = st.session_state.get("user")
	row = _get_user_row(username)
	if not row:
		msg = "Please register first."
		st.error(msg)
		return False, msg

	conn = get_conn()
	cur = conn.cursor()
	cur.execute(
		"""
		SELECT SettingsJSON
		FROM [dbo].[ITSTR_AppUserSettings]
		WHERE ID = ?
		""",
		int(row["ID"]),
	)
	srow = cur.fetchone()
	if not srow:
		# If missing, initialize
		try:
			now = utc_now().replace(tzinfo=None)
			cur.execute(
				"""
				INSERT INTO [dbo].[ITSTR_AppUserSettings] (ID, SettingsJSON, UpdatedUTC)
				VALUES (?, ?, ?)
				""",
				int(row["ID"]),
				"{}",
				now,
			)
			conn.commit()
			return True, {}
		except Exception as e:
			conn.rollback()
			msg = f"Settings init failed: {e}"
			st.error(msg)
			return False, msg

	try:
		return True, json.loads(srow[0] or "{}")
	except Exception:
		return True, {}


def save_user_settings(app_name: str, settings_in: dict) -> tuple[bool, str]:
	if "user" not in st.session_state:
		msg = "Please log in first."
		st.error(msg)
		return False, msg

	username = st.session_state.get("user")
	row = _get_user_row(username)
	if not row:
		msg = "Please register first."
		st.error(msg)
		return False, msg

	conn = get_conn()
	cur = conn.cursor()

	try:
		# Read-modify-write (safe because settings are per-user; still transactional)
		cur.execute(
			"SELECT settings_json FROM [dbo].[ITSTR_AppUserSettings] WITH (UPDLOCK, ROWLOCK) WHERE ID = ?",
			int(row["ID"]),
		)
		srow = cur.fetchone()
		existing = {}
		if srow and srow[0]:
			try:
				existing = json.loads(srow[0])
			except Exception:
				existing = {}

		existing.update(settings_in)
		now = utc_now().replace(tzinfo=None)

		if srow:
			cur.execute(
				"""
				UPDATE [dbo].[ITSTR_AppUserSettings]
				SET SettingsJSON = ?, UpdatedUTC = ?
				WHERE ID = ?
				""",
				json.dumps(existing, ensure_ascii=False),
				now,
				int(row["ID"]),
			)
		else:
			cur.execute(
				"""
				INSERT INTO [dbo].[ITSTR_AppUserSettings] (ID, SettingsJSON, UpdatedUTC)
				VALUES (?, ?, ?)
				""",
				int(row["ID"]),
				json.dumps(existing, ensure_ascii=False),
				now,
			)

		_log_event(app_name, username, None, success=True, event_type="settings_change")

		conn.commit()
		return True, "Settings updated successfully."
	except Exception as e:
		conn.rollback()
		st.error(e)
		return False, f"Settings update failed: {e}"


# -----------------------------------------------------------------------------
# UI HELPERS (keep your existing UI, these are identical shapes)
# -----------------------------------------------------------------------------

def show_login_register(app_name: str):
	tab_login, tab_register = st.tabs(["Login", "Register"])

	with tab_login:
		st.subheader("Login")
		with st.form("login_form"):
			username = st.text_input("Username").lower()
			password = st.text_input("Password", type="password")
			submitted = st.form_submit_button("Login")

		if submitted:
			ok, msg = login_user(app_name, username, password)
			if ok:
				st.session_state.user = username
				st.success(msg)
				st.rerun()
			else:
				st.error(msg)

	with tab_register:
		st.subheader("Create an account")
		with st.form("register_form"):
			username = st.text_input("New username").lower()
			password = st.text_input("New password", type="password")
			password2 = st.text_input("Confirm password", type="password")
			submitted = st.form_submit_button("Register")

		if submitted:
			if password != password2:
				st.error("Passwords do not match.")
			elif len(password) < 6:
				st.error("Password should be at least 6 characters.")
			else:
				ok, msg = register_user(app_name, username, password)
				if ok:
					st.success(msg)
					st.info("You can now log in.")
				else:
					st.error(msg)


def show_change_password(app_name: str) -> bool:
	if st.session_state.get("user") is None:
		st.error("You are not logged in.")
		st.stop()

	st.subheader("Change password")
	with st.form("change_password_form"):
		old_pw = st.text_input("Old password", type="password")
		new_pw = st.text_input("New password", type="password")
		new_pw2 = st.text_input("Confirm new password", type="password")
		submitted = st.form_submit_button("Change password")

	if submitted:
		if new_pw != new_pw2:
			st.error("New passwords do not match.")
		elif len(new_pw) < 6:
			st.error("New password should be at least 6 characters.")
		else:
			ok, msg = change_user_password(app_name, st.session_state.user, old_pw, new_pw)
			if ok:
				st.success(msg)
				st.toast(body=msg, duration=8)
				return True
			else:
				st.error(msg)
	return False


def st_auth(app_name: str, title: str = "Login:") -> bool:
	if st.session_state.get("user") is None:
		if "user" not in st.session_state:
			st.session_state.user = None
		st.title(title)
		show_login_register(app_name)
		return False
	return True


def load_session_state_info():
	simple = {
		bool: lambda x: str(x),
		str: lambda x: str(x)[:20] + ("..." if len(x) > 20 else ""),
		int: lambda x: str(x),
		float: lambda x: str(x),
		date: lambda x: f"{x:%Y-%m-%d}",
		datetime: lambda x: f"{x:%Y-%m-%d %H:%M:%S}",
		pd.DataFrame: lambda x: f"DataFrame {x.shape}",
	}
	return {k: simple.get(type(v), lambda x: type(x))(v) for k, v in st.session_state.items()}