import datetime

import streamlit as st
from st_aggrid import AgGrid, GridOptionsBuilder, GridUpdateMode
import pandas as pd

from pyodbc_connection import connect
from streamlit_utility import display_df

APP_PASSWORD: str = "PRODSCHED25*"
HOLD_TIME_PROD_QUERY: int = 1000 * 60  # 60 minute hold time on prod data

k_stde_schedule: str = "stde_schedule"
k_text_input_username: str = "text_input_username"
k_text_input_password: str = "text_input_password"
k_button_submit_creds: str = "button_submit_creds"

k_available_units: str = "available_units"
k_signed_in: str = "signed_in"
k_user_name: str = ""
st.session_state.setdefault(k_signed_in, False)
st.session_state.setdefault(k_available_units, list(map(lambda x: f"000{x}"[-3:], range(0, 300, 6))))


@st.cache_data(ttl=None, show_spinner=True)
def load_prod_lines() -> pd.DataFrame:
	return connect("SELECT * FROM [BWSdb].[dbo].[Prod Lines] WHERE [Active] = 1;")


@st.cache_data(ttl=HOLD_TIME_PROD_QUERY, show_spinner=True)
def load_units() -> pd.DataFrame:
	return connect("SELECT * FROM [BWSdb].[dbo].[dtProductionSchedule];")


def submit_creds():
	# user: str = st.session_state.get(k_text_input_username, "")
	# pwd: str = st.session_state.get(k_text_input_password, "")
	user: str = text_input_username
	pwd: str = text_input_password

	print(f"{user=}, {pwd=}")
	valid = pwd == APP_PASSWORD

	if valid:
		print(f"valid sign in for '{user}'")
	else:
		with cont_cred_texts:
			st.write(":red[invalid password]")

	st.session_state.update({
		k_signed_in: valid,
		k_user_name: user
	})


def frame(lines: list[str], start_date: datetime.datetime) -> pd.DataFrame:
	n_days = 14
	return pd.DataFrame({d.date(): {line: "" for line in lines} for d in pd.date_range(start_date, periods=n_days)})


# def change_username():
# 	st.session_state.update({
# 		k_text_input_username: text_input_username
# 	})
#
#
# def change_password():
# 	st.session_state.update({
# 		k_text_input_password: text_input_password
# 	})


def update_table(*args):
	print(f"update_table {args=}")
	available_units = st.session_state.get(k_available_units, [])
	print(f"len(au)={len(available_units)}")
	de_d: dict = st.session_state.get(k_stde_schedule)
	de: pd.DataFrame = stde_schedule
	# print(f"{de_d=}")

	if de_d:
		er: dict = de_d.get("edited_rows", {})
		ar: dict = de_d.get("added_rows", {})
		dr: dict = de_d.get("deleted_rows", {})

		print(f"{er=}")

		for idx, data in er.items():
			for col, val in data.items():
				if val:
					try:
						available_units.remove(val)
					except ValueError:
						pass


is_signed_in = st.session_state.get(k_signed_in, False)

if is_signed_in:
	user: str = st.session_state.get(k_text_input_username, "")
	st.write(f"Welcome {user}")

	df_units: pd.DataFrame = load_units()
	df_lines: pd.DataFrame = load_prod_lines()
	df_lines.sort_values(
		by="LO",
		ascending=True,
		inplace=True
	)
	lst_lines: list[str] = df_lines["Prod Line"].values.tolist()
	v_date_start: datetime.datetime = datetime.datetime(2025, 5, 1)
	df_frame: pd.DataFrame = frame(
		lst_lines,
		v_date_start
	)
	lst_v_dates: list[datetime.date] = df_frame.columns.tolist()
	v_date_end: datetime.date = lst_v_dates[-1]
	v_date_end: datetime.datetime = datetime.datetime(v_date_end.year, v_date_end.month, v_date_end.day)

	# units with [Prod Date 1] within view window
	# 	OR
	# units that don't have [Prod Date 1], but do have a [Prod Date 2] in range
	df_units = df_units.loc[
		(
			(v_date_start <= df_units["Prod Date 1"])
			& (df_units["Prod Date 1"] <= v_date_end)
		)
		|
		(
			(df_units["Prod Date 1"].isna())
			& (
				(v_date_start <= df_units["Prod Date 2"])
				& (df_units["Prod Date 2"] <= v_date_end)
			)
		)
	]

	display_df(
		df_units,
		"df_units"
	)
	# display_df(
	# 	df_frame,
	# 	"df_frame"
	# )

	available_units = st.session_state.get(k_available_units, [])

	stde_schedule = st.data_editor(
		df_frame,
		height=900,
		width=1600,
		key=k_stde_schedule,
		num_rows=len(lst_lines),
		column_config={
			f"{d}": st.column_config.SelectboxColumn(
				label=f"{d}",
				options=available_units,
				default=""
			)
			for d in lst_v_dates
		},
		on_change=update_table
	)
	display_df(
		stde_schedule,
		"stde_schedule"
	)

	# # Example schedule
	# lines = ['L1', 'L2', 'L3']
	# dates = pd.date_range("2025-05-01", periods=5)
	# data = {str(date.date()): [""] * len(lines) for date in dates}
	# df = pd.DataFrame(data, index=lines).reset_index().rename(columns={'index': 'Line'})
	#
	# # AgGrid config
	# gb = GridOptionsBuilder.from_dataframe(df)
	# gb.configure_default_column(editable=True)
	# gb.configure_selection("single")
	# grid_options = gb.build()
	#
	# # Show Grid
	# response = AgGrid(
	# 	df,
	# 	gridOptions=grid_options,
	# 	update_mode=GridUpdateMode.VALUE_CHANGED,
	# 	allow_unsafe_jscode=True,
	# 	height=300
	# )
	#
	# # Get updated data
	# updated_df = response["data"]

else:
	cont_cred = st.container(border=True)
	cont_cred_texts = cont_cred.container()
	with cont_cred_texts:
		st.write("please sign in first:")

		text_input_username = st.text_input(
			label="Username:",
			key=f"k_{k_text_input_username}"
			# ,
			# on_change=change_username
		)

		text_input_password = st.text_input(
			label="Password:",
			key=f"k_{k_text_input_password}",
			type="password"
			# ,
			# on_change=change_password
		)

		with cont_cred:
			if text_input_password:
				button_submit_creds = st.button(
					label="login",
					key=f"k_{k_button_submit_creds}",
					on_click=submit_creds
				)
