import datetime

import streamlit as st
from st_aggrid import AgGrid, GridOptionsBuilder, GridUpdateMode
import pandas as pd

from pyodbc_connection import connect


APP_PASSWORD: str = "PRODSCHED25*"
HOLD_TIME_PROD_QUERY: int = 1000 * 60  # 60 minute hold time on prod data


k_text_input_username: str = "text_input_username"
k_text_input_password: str = "text_input_password"
k_button_submit_creds: str = "button_submit_creds"

k_signed_in: str = "signed_in"
k_user_name: str = ""
st.session_state.setdefault(k_signed_in, False)


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
	v_date_start = datetime.datetime(2025, 5, 1)
	df_frame: pd.DataFrame = frame(
		lst_lines,
		v_date_start,
	)

	df_units = df_units.loc[
		(v_date_start <= df_units["Prod Date"])
	]

	st.write()

	st.data_editor(
		df_frame,
		height=900,
		width=1600,
		num_rows=len(lst_lines),
		column_config={
			"": st.column_config.SelectboxColumn(
				label="WO",
				options=["A", "B", "C"]
			)
		}
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
