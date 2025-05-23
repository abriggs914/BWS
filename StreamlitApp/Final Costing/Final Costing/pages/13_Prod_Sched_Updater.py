import datetime

import streamlit as st
# from st_aggrid import AgGrid, GridOptionsBuilder, GridUpdateMode
import pandas as pd
#
# from pyodbc_connection import connect, connect_2
from pyodbc_connection import connect
from streamlit_utility import display_df
from datetime_utility import first_of_month, end_of_month
#
# APP_PASSWORD: str = "PRODSCHED25*"
# HOLD_TIME_PROD_QUERY: int = 1000 * 60  # 60 minute hold time on prod data
#
# k_stde_schedule: str = "stde_schedule"
# k_text_input_username: str = "text_input_username"
# k_text_input_password: str = "text_input_password"
# k_button_submit_creds: str = "button_submit_creds"
#
# k_available_units: str = "available_units"
# k_signed_in: str = "signed_in"
# k_user_name: str = ""
# st.session_state.setdefault(k_signed_in, False)
# st.session_state.setdefault(k_available_units, list(map(lambda x: f"000{x}"[-3:], range(0, 300, 6))))
#
#
# @st.cache_data(ttl=None, show_spinner=True)
# def load_prod_lines() -> pd.DataFrame:
# 	return connect("SELECT * FROM [BWSdb].[dbo].[Prod Lines] WHERE [Active] = 1;")
#
#
# @st.cache_data(ttl=HOLD_TIME_PROD_QUERY, show_spinner=True)
# def load_units() -> pd.DataFrame:
# 	return connect("SELECT * FROM [BWSdb].[dbo].[dtProductionSchedule];")
#
#
# def submit_creds():
# 	# user: str = st.session_state.get(k_text_input_username, "")
# 	# pwd: str = st.session_state.get(k_text_input_password, "")
# 	user: str = text_input_username
# 	pwd: str = text_input_password
#
# 	print(f"{user=}, {pwd=}")
# 	valid = pwd == APP_PASSWORD
#
# 	if valid:
# 		print(f"valid sign in for '{user}'")
# 	else:
# 		with cont_cred_texts:
# 			st.write(":red[invalid password]")
#
# 	st.session_state.update({
# 		k_signed_in: valid,
# 		k_user_name: user
# 	})
#
#
# def frame(lines: list[str], start_date: datetime.datetime) -> pd.DataFrame:
# 	n_days = 14
# 	return pd.DataFrame({d.date(): {line: "" for line in lines} for d in pd.date_range(start_date, periods=n_days)})
#
#
# # def change_username():
# # 	st.session_state.update({
# # 		k_text_input_username: text_input_username
# # 	})
# #
# #
# # def change_password():
# # 	st.session_state.update({
# # 		k_text_input_password: text_input_password
# # 	})
#
#
# def update_table(*args):
# 	print(f"update_table {args=}")
# 	available_units = st.session_state.get(k_available_units, [])
# 	print(f"len(au)={len(available_units)}")
# 	de_d: dict = st.session_state.get(k_stde_schedule)
# 	de: pd.DataFrame = stde_schedule
# 	# print(f"{de_d=}")
#
# 	if de_d:
# 		er: dict = de_d.get("edited_rows", {})
# 		ar: dict = de_d.get("added_rows", {})
# 		dr: dict = de_d.get("deleted_rows", {})
#
# 		print(f"{er=}")
#
# 		for idx, data in er.items():
# 			for col, val in data.items():
# 				if val:
# 					try:
# 						available_units.remove(val)
# 					except ValueError:
# 						pass
#
#
# is_signed_in = st.session_state.get(k_signed_in, False)
#
# if is_signed_in:
# 	user: str = st.session_state.get(k_text_input_username, "")
# 	st.write(f"Welcome {user}")
#
# 	df_units: pd.DataFrame = load_units()
# 	df_lines: pd.DataFrame = load_prod_lines()
# 	df_lines.sort_values(
# 		by="LO",
# 		ascending=True,
# 		inplace=True
# 	)
# 	lst_lines: list[str] = df_lines["Prod Line"].values.tolist()
# 	v_date_start: datetime.datetime = datetime.datetime(2025, 5, 1)
# 	df_frame: pd.DataFrame = frame(
# 		lst_lines,
# 		v_date_start
# 	)
# 	lst_v_dates: list[datetime.date] = df_frame.columns.tolist()
# 	v_date_end: datetime.date = lst_v_dates[-1]
# 	v_date_end: datetime.datetime = datetime.datetime(v_date_end.year, v_date_end.month, v_date_end.day)
#
# 	# units with [Prod Date 1] within view window
# 	# 	OR
# 	# units that don't have [Prod Date 1], but do have a [Prod Date 2] in range
# 	df_units = df_units.loc[
# 		(
# 			(v_date_start <= df_units["Prod Date 1"])
# 			& (df_units["Prod Date 1"] <= v_date_end)
# 		)
# 		|
# 		(
# 			(df_units["Prod Date 1"].isna())
# 			& (
# 				(v_date_start <= df_units["Prod Date 2"])
# 				& (df_units["Prod Date 2"] <= v_date_end)
# 			)
# 		)
# 	]
#
# 	display_df(
# 		df_units,
# 		"df_units"
# 	)
# 	# display_df(
# 	# 	df_frame,
# 	# 	"df_frame"
# 	# )
#
# 	available_units = st.session_state.get(k_available_units, [])
#
# 	stde_schedule = st.data_editor(
# 		df_frame,
# 		height=900,
# 		width=1600,
# 		key=k_stde_schedule,
# 		num_rows=len(lst_lines),
# 		column_config={
# 			f"{d}": st.column_config.SelectboxColumn(
# 				label=f"{d}",
# 				options=available_units,
# 				default=""
# 			)
# 			for d in lst_v_dates
# 		},
# 		on_change=update_table
# 	)
# 	display_df(
# 		stde_schedule,
# 		"stde_schedule"
# 	)
#
# 	# # Example schedule
# 	# lines = ['L1', 'L2', 'L3']
# 	# dates = pd.date_range("2025-05-01", periods=5)
# 	# data = {str(date.date()): [""] * len(lines) for date in dates}
# 	# df = pd.DataFrame(data, index=lines).reset_index().rename(columns={'index': 'Line'})
# 	#
# 	# # AgGrid config
# 	# gb = GridOptionsBuilder.from_dataframe(df)
# 	# gb.configure_default_column(editable=True)
# 	# gb.configure_selection("single")
# 	# grid_options = gb.build()
# 	#
# 	# # Show Grid
# 	# response = AgGrid(
# 	# 	df,
# 	# 	gridOptions=grid_options,
# 	# 	update_mode=GridUpdateMode.VALUE_CHANGED,
# 	# 	allow_unsafe_jscode=True,
# 	# 	height=300
# 	# )
# 	#
# 	# # Get updated data
# 	# updated_df = response["data"]
#
# else:
# 	cont_cred = st.container(border=True)
# 	cont_cred_texts = cont_cred.container()
# 	with cont_cred_texts:
# 		st.write("please sign in first:")
#
# 		text_input_username = st.text_input(
# 			label="Username:",
# 			key=f"k_{k_text_input_username}"
# 			# ,
# 			# on_change=change_username
# 		)
#
# 		text_input_password = st.text_input(
# 			label="Password:",
# 			key=f"k_{k_text_input_password}",
# 			type="password"
# 			# ,
# 			# on_change=change_password
# 		)
#
# 		with cont_cred:
# 			if text_input_password:
# 				button_submit_creds = st.button(
# 					label="login",
# 					key=f"k_{k_button_submit_creds}",
# 					on_click=submit_creds
# 				)


# company
# quote

# orders / Order Standards


MAX_HOLD_TIME: int =  1000 * 60 * 60
st.set_page_config(layout="wide")

kill_time = datetime.datetime(2025, 5, 23, 12)
st.warning(f"DEPRECATED -- Functions moved to Sales page {kill_time:%x%X}")


template_header = """
-- Matching {LST_COLS}
-- on search term = '{STERM}'
-- in {LST_COMPS} company(s)
-- ALLOW_PARTIAL_MATCH={APARTIAL}
"""

template_declares = """
DECLARE @doTest BIT = 0
DECLARE @st NVARCHAR(MAX) = '{STERM}'
DECLARE @delim NVARCHAR(5) = ';'
DECLARE @newDelim NVARCHAR(5) = ';|||;'
DECLARE @allowPartial BIT = {APARTIAL}

DECLARE @checkOS BIT = 1
DECLARE @checkOOFL BIT = 1
DECLARE @checkOOSL BIT = 1
DECLARE @checkCWFL BIT = 1
DECLARE @checkCWSL BIT = 1
"""

# template_sql = """
# SELECT
# 	'{COMP}' AS [Comp],
# 	CAST([{QCOL}] AS NVARCHAR(MAX)) AS [Quote],
# 	'{COL}' AS [MatchColumn],
# 	[Splt].[splited_data] AS [SearchTerm],
# 	CAST([{COL}] AS NVARCHAR(MAX)) AS [Matched],
# 	(CASE WHEN (CAST([O].[{COL}] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 ELSE 0 END) AS [ExactMatch]
# FROM
# 	[BWSdb].[dbo].[{OTABLE}] [O] WITH (NOLOCK)
# LEFT JOIN
# 	[BWSdb].[dbo].[split_string_idx](@st, @delim) [Splt]
# ON
# 	(
# 		CASE
# 		WHEN (@allowPartial = 1) AND (LOWER(CAST([O].[{COL}] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%'))
# 		THEN 1
# 		WHEN (CAST([O].[{COL}] AS NVARCHAR(MAX)) = [Splt].[splited_data])
# 		THEN 1
# 		ELSE 0
# 		END
# 	) = 1
# WHERE
# 	ISNULL([Splt].[splited_data], '') <> ''
# """


template_sql_o = """
SELECT
    '{COMP}' AS [Comp],
    CAST([O].[{QCOL}] AS NVARCHAR(MAX)) AS [Quote],
    '{COL}' AS [MatchColumn],
    [Splt].[splited_data] AS [SearchTerm],
    CAST([O].[{COL}] AS NVARCHAR(MAX)) AS [Matched],
    (CASE WHEN (CAST([O].[{COL}] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 ELSE 0 END) AS [ExactMatch]
FROM 
    [BWSdb].[dbo].[{OTABLE}] [O] WITH (NOLOCK)
CROSS JOIN
    [BWSdb].[dbo].[split_string_idx](@st, @delim) [Splt]
WHERE
    ISNULL([Splt].[splited_data], '') <> ''
    AND (
        (CAST([O].[{COL}] AS NVARCHAR(MAX)) = [Splt].[splited_data])
        OR
        (@allowPartial = 1 AND LOWER(CAST([O].[{COL}] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%'))
    )
	{DFILT}
"""


template_sql_d = """
SELECT
    '{COMP}' AS [Comp],
    CAST([O].[{QCOL}] AS NVARCHAR(MAX)) AS [Quote],
    'Dealer' AS [MatchColumn],
    [Splt].[splited_data] AS [SearchTerm],
    CAST([O].[{COL}] AS NVARCHAR(MAX)) AS [Matched],
    (CASE WHEN (CAST([O].[{COL}] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 ELSE 0 END) AS [ExactMatch]
FROM 
    [BWSdb].[dbo].[{OTABLE}] [O] WITH (NOLOCK)
LEFT JOIN 
    [BWSdb].[dbo].[{DTABLE}] [D] WITH (NOLOCK)
ON
	[O].[DealerID] = [D].[ID]
CROSS JOIN
    [BWSdb].[dbo].[split_string_idx](@st, @delim) [Splt]
WHERE
    ISNULL([Splt].[splited_data], '') <> ''
    AND (
    	(
        	(CAST([O].[{COL}] AS NVARCHAR(MAX)) = [Splt].[splited_data])
        	OR
        	(@allowPartial = 1 AND LOWER(CAST([O].[{COL}] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%'))
    	)
    	OR (
    		(CAST([D].[COMPANY NAME] AS NVARCHAR(MAX)) = [Splt].[splited_data])
        	OR
        	(@allowPartial = 1 AND LOWER(CAST([D].[COMPANY NAME] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%'))
    	)
    )
	{DFILT}
"""


template_sql_s = """
SELECT
    '{COMP}' AS [Comp],
    CAST([O].[{QCOL}] AS NVARCHAR(MAX)) AS [Quote],
    'Standards' AS [MatchColumn],
    [Splt].[splited_data] AS [SearchTerm],
    CAST([O].[{COL}] AS NVARCHAR(MAX)) AS [Matched],
    (CASE WHEN (CAST([O].[{COL}] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 ELSE 0 END) AS [ExactMatch]
FROM 
    [BWSdb].[dbo].[{OTABLE}] [O] WITH (NOLOCK)
LEFT JOIN 
    [BWSdb].[dbo].[{STABLE}] [S] WITH (NOLOCK)
ON
	[O].[Model No] = [S].[Model No]
CROSS JOIN
    [BWSdb].[dbo].[split_string_idx](@st, @delim) [Splt]
WHERE
    ISNULL([Splt].[splited_data], '') <> ''
    AND (
    	(
        	(CAST([O].[{COL}] AS NVARCHAR(MAX)) = [Splt].[splited_data])
        	OR
        	(@allowPartial = 1 AND LOWER(CAST([O].[{COL}] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%'))
    	)
    	OR (
    		(CAST([S].[Description] AS NVARCHAR(MAX)) = [Splt].[splited_data])
        	OR
        	(@allowPartial = 1 AND LOWER(CAST([S].[Description] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%'))
    	)
    )
	{DFILT}
"""


template_sql_oo = """
SELECT
    '{COMP}' AS [Comp],
    CAST([O].[{QCOL}] AS NVARCHAR(MAX)) AS [Quote],
    'Options' AS [MatchColumn],
    [Splt].[splited_data] AS [SearchTerm],
    CAST([O].[{COL}] AS NVARCHAR(MAX)) AS [Matched],
    (CASE WHEN (CAST([O].[{COL}] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 ELSE 0 END) AS [ExactMatch]
FROM 
    [BWSdb].[dbo].[{OTABLE}] [O] WITH (NOLOCK)
LEFT JOIN 
    [BWSdb].[dbo].[{OPTABLE}] [OO] WITH (NOLOCK)
ON
	[O].[{QCOL}] = [OO].[{QCOL}]
CROSS JOIN
    [BWSdb].[dbo].[split_string_idx](@st, @delim) [Splt]
WHERE
    ISNULL([Splt].[splited_data], '') <> ''
    AND (
    	(
        	(CAST([O].[{COL}] AS NVARCHAR(MAX)) = [Splt].[splited_data])
        	OR
        	(@allowPartial = 1 AND LOWER(CAST([O].[{COL}] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%'))
    	)
    	OR (
    		(CAST([OO].[Description] AS NVARCHAR(MAX)) = [Splt].[splited_data])
        	OR
        	(@allowPartial = 1 AND LOWER(CAST([OO].[Description] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%'))
    	)
    )
	{DFILT}
"""


template_sql_cw = """
SELECT
    '{COMP}' AS [Comp],
    CAST([O].[{QCOL}] AS NVARCHAR(MAX)) AS [Quote],
    'NPO' AS [MatchColumn],
    [Splt].[splited_data] AS [SearchTerm],
    CAST([O].[{COL}] AS NVARCHAR(MAX)) AS [Matched],
    (CASE WHEN (CAST([O].[{COL}] AS NVARCHAR(MAX)) = [Splt].[splited_data]) THEN 1 ELSE 0 END) AS [ExactMatch]
FROM 
    [BWSdb].[dbo].[{OTABLE}] [O] WITH (NOLOCK)
LEFT JOIN 
    [BWSdb].[dbo].[{CWTABLE}] [CW] WITH (NOLOCK)
ON
	[O].[{QCOL}] = [CW].[{QCOL}]
CROSS JOIN
    [BWSdb].[dbo].[split_string_idx](@st, @delim) [Splt]
WHERE
    ISNULL([Splt].[splited_data], '') <> ''
    AND (
    	(
        	(CAST([O].[{COL}] AS NVARCHAR(MAX)) = [Splt].[splited_data])
        	OR
        	(@allowPartial = 1 AND LOWER(CAST([O].[{COL}] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%'))
    	)
    	OR (
    		(CAST([CW].[Description] AS NVARCHAR(MAX)) = [Splt].[splited_data])
        	OR
        	(@allowPartial = 1 AND LOWER(CAST([CW].[Description] AS NVARCHAR(MAX))) LIKE LOWER('%' + [Splt].[splited_data] + '%'))
    	)
    )
	{DFILT}
"""


template_sql_date = """AND ([O].[Order Date] BETWEEN '{SD}' AND '{ED}')"""


col_npo = "NPOs"
col_standards = "Standards"
col_options = "Options"
col_dealer = "Dealer"
col_quote_bws = "Quote#"
col_quote_stg = "SGQuote"
o_table_cols = [
	col_quote_bws,
	"WO#",
	"Serial Number",
	"Model No",
	"Special Instructions",
	"Notes",
	"EngNotes",
	"Customer WO#",
	"Sales Order#",
	"Invoice #"
]

# template_fill_ins = {
# 	"BWS": {
# 		"o_table": "Orders",
# 		"q_col": "Quote#",
# 		"cols": o_table_cols
# 	},
# 	"STG": {
# 		"o_table": "OrdersV2",
# 		"q_col": "SGQuote",
# 		"cols": o_table_cols
# 	}
# }
#
# statement = ""
# statements = []
# for company, comp_data in template_fill_ins.items():
# 	q_col = comp_data["q_col"]
# 	o_table = comp_data["o_table"]
# 	cols = comp_data["cols"]
# 	for i, col in enumerate(cols):
# 		statements.append(template_sql.format(
# 			COMP=company,
# 			QCOL=q_col,
# 			COL=col,
# 			OTABLE=o_table
# 		))
#
# statement = "\nUNION\n".join(statements)
#
# st.code(
# 	statement,
# 	language="sql",
# 	line_numbers=True
# )

@st.cache_data(show_spinner=True, ttl=MAX_HOLD_TIME)
def load_sql_data(sql) -> pd.DataFrame:
	return connect(sql)


def load_orders() -> pd.DataFrame:
	return load_sql_data("Orders")


def load_orders2() -> pd.DataFrame:
	return load_sql_data("OrdersV2")


def load_dealers() -> pd.DataFrame:
	return load_sql_data("Dealers")


def load_dealers2() -> pd.DataFrame:
	return load_sql_data("DealersV2")


def load_standards() -> pd.DataFrame:
	return load_sql_data("Standards")


def load_standards2() -> pd.DataFrame:
	return load_sql_data("StandardsV2")


def load_options() -> pd.DataFrame:
	return load_sql_data("Order Options")


def load_options2() -> pd.DataFrame:
	return load_sql_data("Order OptionsV2")


def load_npos() -> pd.DataFrame:
	return load_sql_data("Custom Work")


def load_npos2() -> pd.DataFrame:
	return load_sql_data("Custom WorkV2")


@st.cache_data(show_spinner=True, ttl=MAX_HOLD_TIME)
def get_data(sql) -> pd.DataFrame:
	df = connect(
		sql,
		do_exec=True,
		do_show=True,
		do_print=True
	)
	# print(f"{connect(generate_sql())=}")
	# print("df")
	# print(df)
	return df


def generate_sql():

	s_term = entry_search_term.replace("'", "''").strip()
	a_partial = int(toggle_allow_partial)

	sd = start_date
	ed = end_date
	use_date = (sd is not None) and (ed is not None)

	if use_date:
		d_filt = template_sql_date.format(SD=sd, ED=ed)
	else:
		d_filt = ""

	table_cols = multiselect_cols.copy()
	table_cols_b: list[str] = table_cols.copy()
	table_cols_s: list[str] = table_cols.copy()

	if col_quote_bws in table_cols:
		table_cols.remove(col_quote_bws)
		table_cols_b = [col_quote_bws] + table_cols.copy()
		table_cols_s = [col_quote_stg] + table_cols.copy()

	template_fill_ins = {
		"BWS": {
			"o_table": "Orders",
			"d_table": "Dealers",
			"s_table": "Standards",
			"op_table": "Order Options",
			"cw_table": "Custom Work",
			"q_col": col_quote_bws,
			"cols": table_cols_b
		},
		"STG": {
			"o_table": "OrdersV2",
			"d_table": "DealersV2",
			"s_table": "StandardsV2",
			"op_table": "Order OptionsV2",
			"cw_table": "Custom WorkV2",
			"q_col": col_quote_stg,
			"cols": table_cols_s
		}
	}

	if not toggle_comp_bws:
		template_fill_ins.pop("BWS")
	if not toggle_comp_stg:
		template_fill_ins.pop("STG")

	if not template_fill_ins:
		st.error(f"No companies selected")
		st.stop()

	statements = []
	for company, comp_data in template_fill_ins.items():
		q_col = comp_data["q_col"]
		o_table = comp_data["o_table"]
		d_table = comp_data["d_table"]
		s_table = comp_data["s_table"]
		op_table = comp_data["op_table"]
		cw_table = comp_data["cw_table"]
		cols = comp_data["cols"]
		use_dealer = col_dealer in cols
		use_standards = col_standards in cols
		use_options = col_options in cols
		use_npos = col_npo in cols
		if use_dealer:
			statements.append(template_sql_d.format(
				COMP=company,
				QCOL=q_col,
				COL=q_col,
				OTABLE=o_table,
				DTABLE=d_table,
				DFILT=d_filt
				# ,
				# DTEMPLATE=sql_dealers
			))
			use_dealer = False
			cols.remove(col_dealer)
		if use_standards:
			statements.append(template_sql_s.format(
				COMP=company,
				QCOL=q_col,
				COL=q_col,
				OTABLE=o_table,
				STABLE=s_table,
				DFILT=d_filt
				# ,
				# DTEMPLATE=sql_dealers
			))
			use_standards = False
			cols.remove(col_standards)
		if use_options:
			statements.append(template_sql_oo.format(
				COMP=company,
				QCOL=q_col,
				COL=q_col,
				OTABLE=o_table,
				OPTABLE=op_table,
				DFILT=d_filt
				# ,
				# DTEMPLATE=sql_dealers
			))
			use_options = False
			cols.remove(col_options)
		if use_npos:
			statements.append(template_sql_cw.format(
				COMP=company,
				QCOL=q_col,
				COL=q_col,
				OTABLE=o_table,
				CWTABLE=cw_table,
				DFILT=d_filt
				# ,
				# DTEMPLATE=sql_dealers
			))
			use_npos = False
			cols.remove(col_npo)
		for i, col in enumerate(cols):
			# template_sql_where.format(COL=col)
			statements.append(template_sql_o.format(
				COMP=company,
				QCOL=q_col,
				COL=col,
				OTABLE=o_table,
				DFILT=d_filt
				# ,
				# DTEMPLATE=sql_dealers
			))

	if not statements:
		st.error(f"No statements generated")
		st.stop()

	statements_h = template_header.format(
		LST_COLS=", ".join(table_cols_b),
		LST_COMPS=", ".join(template_fill_ins),
		STERM=s_term,
		APARTIAL=a_partial
	)

	statements_d = template_declares.format(
		STERM=s_term,
		APARTIAL=a_partial
	)

	return f"{statements_h}\n{statements_d}\n" + ("\nUNION\n".join(statements)) + ";"


cols_controls = st.columns([0.3, 0.7])
df_orders: pd.DataFrame = load_orders()
df_orders2: pd.DataFrame = load_orders2()
df_dealers: pd.DataFrame = load_dealers()
df_dealers2: pd.DataFrame = load_dealers2()
df_standards: pd.DataFrame = load_standards()
df_standards2: pd.DataFrame = load_standards2()
df_options: pd.DataFrame = load_options()
df_options2: pd.DataFrame = load_options2()
df_npos: pd.DataFrame = load_npos()
df_npos2: pd.DataFrame = load_npos2()

k_times_blank_rerun: str = "times_blank_rerun"
times_blank_rerun = st.session_state.setdefault(k_times_blank_rerun, 0)

with cols_controls[0]:

	cols_search_tools = st.columns([0.25, 0.3, 0.45])

	with cols_search_tools[0]:
		toggle_comp_bws = st.toggle(
			label=":red[BWS]",
			value=True
		)

		toggle_comp_stg = st.toggle(
			label=":blue[STG]",
			value=True
		)
	with cols_search_tools[2]:
		toggle_allow_partial = st.toggle(
			label="partial match?",
			value=True,
			help="Ignores case and any preceding or succeeding text."
		)
		toggle_extensive_search = st.toggle(
			label="extensive?",
			value=False,
			help="This search method is more in depth and will take a little longer to process."
		)

	table_cols = o_table_cols
	if toggle_extensive_search:
		table_cols += [col_dealer, col_standards, col_options, col_npo]
	

	if toggle_comp_bws or toggle_comp_stg:

		multiselect_cols = st.multiselect(
			label="Fields to Search",
			# options=o_table_cols
			options=table_cols
		)

		if multiselect_cols:

			# if len(multiselect_cols) == len(o_table_cols):
			# 	# if st.button(
			# 	# 	label="remove all"
			# 	# ):
			# 	#

			st.divider()

			st.session_state.setdefault("start_date_input", first_of_month(datetime.datetime.now()))
			st.session_state.setdefault("end_date_input", end_of_month(datetime.datetime.now()))
			with st.container(border=True):
				toggle_date_filter = st.toggle(
					label=f"date filter?",
					value=True
				)
				if toggle_date_filter:
					st.write(f"Filter by order date:")
					start_date = st.date_input(
						label="start",
						key=f"start_date_input"
					)

					end_date = st.date_input(
						label="end",
						key=f"end_date_input"
					)
				else:
					start_date, end_date = None, None

			entry_search_term = st.text_input(
				label="Search Terms delimited by ';'"
			)

			if entry_search_term:

				with cols_controls[1]:
					with st.expander(label="code"):
						st.code(
							generate_sql(),
							language="sql",
							line_numbers=True
						)
					df_data: pd.DataFrame = get_data(generate_sql())
					# st.write(f"Matching Quote Values ({df_data.shape[0]} rows X {df_data.shape[1]} columns):")
					stde_orders = display_df(
						df_data,
						"Matching Quote Values",
						width=1000,
						selection_mode="single-row",
						on_select="rerun",
						key=f"k_stde_matching_quotes"
					)

					if stde_orders["selection"]["rows"]:
						with st.container(border=True):
							sr_selected_order = df_data.iloc[stde_orders["selection"]["rows"][0]]
							q = int(sr_selected_order['Quote'])
							c = sr_selected_order["Comp"]
							if c == "STG":
								col_q = col_quote_stg
								df_o: pd.DataFrame = df_orders2.loc[df_orders2["SGquote"] == q]
								df_d: pd.DataFrame = df_dealers2
								df_s: pd.DataFrame = df_standards2
								df_op: pd.DataFrame = df_options2
								df_cw: pd.DataFrame = df_npos2
							else:
								col_q = col_quote_bws
								df_o: pd.Series = df_orders.loc[df_orders["Quote#"] == q]
								df_d: pd.DataFrame = df_dealers
								df_s: pd.DataFrame = df_standards
								df_op: pd.DataFrame = df_options
								df_cw: pd.DataFrame = df_npos

							# dfdd = pd.DataFrame(df_o.transpose())
							# dfdd.columns = ["Value"]
							# print(dfdd)
							st.write(f"Order Data ({df_o.shape[0]} rows X {df_o.shape[1]} columns):")
							stde_orders = display_df(
								df_o
							)

							if not df_o.empty:
								st.divider()
								sr_o = df_o.iloc[0]
								dealer_id = sr_o["DealerID"]
								df_d = df_d.loc[df_d["ID"] == dealer_id]
								display_df(
									df_d,
									"Dealer Data:"
								)

							if not df_s.empty:
								st.divider()
								sr_s = df_s.iloc[0]
								model_no = sr_o["Model No"]
								df_s = df_s.loc[df_s["Model No"] == model_no]
								display_df(
									df_s,
									"Standards Data:"
								)

							if not df_op.empty:
								st.divider()
								df_op = df_op.loc[df_op[col_q] == q]
								display_df(
									df_op,
									"Ordered Options Data:"
								)

							if not df_cw.empty:
								st.divider()
								df_cw = df_cw.loc[df_cw[col_q] == q]
								display_df(
									df_cw,
									"NPO Data:"
								)
					# st.write("Tell me more:")
					# for i, row in df_data.iterrows():
					# 	q = int(row['Quote'])
					# 	c = row["Comp"]
					# 	if st.button(
					# 		label=f"{q}",
					# 		key=f"btn_tmm_{i}"
					# 	):
					# 		if c == "STG":
					# 			df_o: pd.DataFrame = df_orders2.loc[df_orders2["SGquote"] == q]
					# 			df_d: pd.DataFrame = df_dealers2
					# 		else:
					# 			df_o: pd.Series = df_orders.loc[df_orders["Quote#"] == q]
					# 			df_d: pd.DataFrame = df_dealers

					# 		# dfdd = pd.DataFrame(df_o.transpose())
					# 		# dfdd.columns = ["Value"]
					# 		# print(dfdd)
					# 		st.write(f"Order Data ({df_o.shape[0]} rows X {df_o.shape[1]} columns):")
					# 		stde_orders = display_df(
					# 			df_o
					# 		)

					# 		if not df_o.empty:
					# 			sr_o = df_o.iloc[0]
					# 			dealer_id = sr_o["DealerID"]
					# 			df_d = df_d.loc[df_d["ID"] == dealer_id]
					# 			display_df(
					# 				df_d,
					# 				"Dealer Data:"
					# 			)

					# 		# display_df(
					# 		# 	dfdd,
					# 		# 	"Transposed:"
					# 		# )
		else:
			st.session_state.update({
				k_times_blank_rerun: times_blank_rerun + 1
			})

if st.session_state.get(k_times_blank_rerun, 0) >= 3:
	if not toggle_allow_partial:
		st.info(f"No results found, try re-running after allowing for 'partial match' to widen the search.")
