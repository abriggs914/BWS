import datetime

import pandas as pd

from typing import Any
from pyodbc_connection import connect
from streamlit_utility import display_df, st
from streamlit_pills import pills
import plotly.express as px

MIN_QUERY_HOLD_TIME: int = 1000 * 30  # 30 minutes
MAX_QUERY_HOLD_TIME: int = 1000 * 60 * 2  # 2 hours
SHOW_SPINNERS: bool = True


@st.cache_data(ttl=MIN_QUERY_HOLD_TIME)
def load_yellow_tags() -> pd.DataFrame:
	print(f"LOAD")
	# 	sql = """
	# SELECT
	# 	[YT].*,
	# 	[IW].[QtyOnHand],
	# 	[IM].[Description] AS [Desc],
	# 	[IM].[LongDesc]
	# FROM
	# 	[BWSdb].[dbo].[PROD_YellowTags] [YT]
	# LEFT JOIN
	# 	[SysproCompanyA].[dbo].[InvWarehouse] [IW]
	# ON
	# 	[YT].[StockCode] = [IW].[StockCode] COLLATE DATABASE_DEFAULT
	# LEFT JOIN
	# 	[SysproCompanyA].[dbo].[InvMaster] [IM]
	# ON
	# 	[YT].[StockCode] = [IM].[StockCode] COLLATE DATABASE_DEFAULT
	# WHERE
	# 	[IW].[Warehouse] = '01'
	# ;
	# 	"""
	sql = "v_PROD_YellowTags"
	st.session_state.setdefault(k_df_timeout, datetime.datetime.now())
	return connect(sql)


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_order_counts():
	return connect("""
SELECT
	[C].[Date],
	[O].[Quote#],
	[O].[Model No],
	[O].[Quote Date],
	[O].[Order Date],
	ISNULL([P].[Prod Date], [P].[Prod Date2]) AS [ProdDate],
	ISNULL(DATEDIFF(DAY, [O].[Quote Date], [O].[Order Date]), 0) AS [DaysBtwnQuoteOrder],
	ISNULL(DATEDIFF(DAY, [O].[Quote Date], ISNULL([P].[Prod Date], [P].[Prod Date2])), 0) AS [DaysBtwnQuoteProd],
	ISNULL(DATEDIFF(DAY, [O].[Order Date], ISNULL([P].[Prod Date], [P].[Prod Date2])), 0) AS [DaysBtwnOrderProd]
FROM
	[BWSdb].[dbo].[Calendar] [C]
LEFT JOIN
	[BWSdb].[dbo].[Orders] [O]
ON
	[C].[Date] = [O].[Quote Date]
LEFT JOIN
	[BWSdb].[dbo].[Production] [P]
ON
	[O].[WO#] = [P].[WO#]
WHERE
	[C].[Date] BETWEEN (SELECT MIN([Quote Date]) FROM [BWSdb].[dbo].[Orders]) AND (SELECT MAX([Quote Date]) FROM [BWSdb].[dbo].[Orders])
	--[O].[Decline/Rejected] = 4
ORDER BY
	[C].[Date]
;
		""")


def clear_edited_rows():
	# # if k_de_yts in st.session_state:
	# # 	if "edited_rows" in st.session_state[k_de_yts]:
	# # 		del st.session_state[k_de_yts]["edited_rows"]
	print(f"CLEAR")
	# if k_de_yts in st.session_state:
	del st.session_state[k_de_yts]
	# if k_df_yts in st.session_state:
	del st.session_state[k_df_yts]
	# if k_df_timeout in st.session_state:
	del st.session_state[k_df_timeout]
	st.session_state[k_force_rerun] = True


@st.dialog("YT Update", width="large")
def ask_commit_update(data):
	ids = list(data.keys())
	df_updated = df_yts.loc[ids]

	for id_, id_data in data.items():
		for col, val in id_data.items():
			df_updated.loc[id_, col] = val

	display_df(
		df_updated[vis_cols_short.values()],
		f"Are you sure you want to update {df_updated.shape[0]} row(s)?",
		hide_index=True,
		show_shape=False
	)

	k_btn_ans_no_notes_update: str = "key_btn_ans_no_notes_update"
	k_btn_ans_yes_notes_update: str = "key_btn_ans_yes_notes_update"
	ans_cols = st.columns([0.25, 0.5, 0.25])
	with ans_cols[0]:
		if st.button(
				label="no",
				key=k_btn_ans_no_notes_update
		):
			clear_edited_rows()
			st.rerun()
	with ans_cols[2]:
		if st.button(
				label="yes",
				key=k_btn_ans_yes_notes_update
		):
			if data:
				sql_t = "UPDATE [BWSdb].[dbo].[PROD_YellowTags] SET [Notes] = '{NOTES}' WHERE [ID] = {ID}"
				sql = ""
				for id_, id_data in data.items():
					col = "Notes"
					notes = id_data.get(col)
					sql += sql_t.format(NOTES=notes, ID=df_yts.loc[id_, "ID"]) + "\n"
				sql = sql.strip()
				# print(f"{sql=}")
				connect(sql, do_exec=True, do_show=True, do_print=True)
				st.session_state[k_df_yts] = st.session_state[k_de_yts].copy()
				clear_edited_rows()
				st.rerun()

	covered = df_updated["ID"].tolist()
	stock_codes = df_updated[vis_cols["StockCode"]].unique().tolist()
	wos = df_updated[vis_cols["WO"]].unique().tolist()
	df_stock_codes = df_yts.loc[(df_yts[vis_cols["StockCode"]].isin(stock_codes)) & (~(df_yts["ID"].isin(covered)))]
	df_wos = df_yts.loc[(df_yts[vis_cols["WO"]].isin(wos)) & (~(df_yts["ID"].isin(covered)))]
	df_stock_codes["Include"] = True
	df_wos["Include"] = True
	vis_cols_mass = ["Include"] + df_updated.columns.tolist()
	mass_apply_cols = st.columns(2)
	with mass_apply_cols[0]:
		st.write("Same WO")
		if not df_wos.empty:
			st.write(f"wos")
			stde_mass_wo = st.data_editor(
				df_wos,
				column_order=vis_cols_mass,
				disabled=vis_cols_mass[1:]
			)

			if any(df_wos["Include"].values.tolist()):
				if st.button(
						label="Apply to all YTs for the same Job?"
				):
					print("yes")
		else:
			st.write("no other Yellow Tags require this stockcode")

	with mass_apply_cols[1]:
		st.write("Same Stockcode")
		if not df_stock_codes.empty:
			st.write(f"stockcode")
			stde_mass_stockcode = st.data_editor(
				df_stock_codes,
				column_order=vis_cols_mass,
				disabled=vis_cols_mass[1:]
			)

			if any(df_stock_codes["Include"].values.tolist()):
				if st.button(
						label="Apply to all YTs for the same Part?"
				):
					print("yes")
		else:
			st.write("no other Yellow Tags require this stockcode")


def change_df_yts():
	df_edited: dict[str: dict[int: dict[str: Any]]] = st.session_state.get(k_de_yts, {})
	edited_rows_pre = df_edited.get("edited_rows", {})
	added_rows_pre = df_edited.get("added_rows", {})
	deleted_rows_pre = df_edited.get("deleted_rows", {})
	print(f"{edited_rows_pre=}")
	# print(f"{de_yts=}")
	edited_rows = {}
	de_ids = de_yts.index.tolist()
	for id_, id_data in edited_rows_pre.items():
		edited_rows[de_ids[id_]] = {}
		for col, val in id_data.items():
			edited_rows[de_ids[id_]][col] = val
	print(f"{edited_rows=}")
	ask_commit_update(edited_rows)


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_new_yellow_tags(
		start_date_in: Any = "2025-09-18 08:00",
		top_level_only="1",
		tolerance=0.01
):

	# if not isinstance(start_date_in, (datetime.datetime, datetime.date)):
	# 	start_date_in = datetime.datetime.strptime(start_date_in, "%Y-%m-%d %H:%M")
	if not isinstance(start_date_in, str):
		start_date_in = start_date_in.strftime("%Y-%m-%d %H:%M")

	sql_new_mat = """
	SELECT
		'Material Posted Since ' + CAST('{SD}' AS NVARCHAR(MAX)) AS [T],
		[WJP].[TrnDateTime],
		[WJ].*
	FROM
		[SysproCompanyA].[dbo].[v_PROD_WipJobPostDateTime] [WJP] 
	INNER JOIN
		[SysproCompanyA].[dbo].[WipJobPost] [WJ] 
	ON
		([WJP].[Job] = [WJ].[Job])
		AND ([WJP].[MStockCode] = [WJ].[MStockCode])
		AND ([WJP].[Line] = [WJ].[Line])
	WHERE
		([WJP].[TrnDateTime] >= '{SD}')
		AND ([WJ].[TrnType] <> 'L')
	ORDER BY
		[WJP].[TrnDateTime] DESC
	;
	""".format(SD=start_date_in)

	sql_part_or_none = """
	SELECT
		[JOI].[Job],
		[JOI].[Operation],
		[JOI].[FirstIssued],
		[JOI].[LastIssued],
		[WM].[StockCode],
		[WM].[QtyIssued],
		[WM].[UnitQtyReqd]
	FROM
		[BWSdb].[dbo].[PROD_JobOpIssue] [JOI]
	INNER JOIN
		[SysproCompanyA].[dbo].[WipJobAllMat] [WM]
	ON
		([JOI].[Job] = [WM].[Job] COLLATE DATABASE_DEFAULT)
		AND ([JOI].[Operation] = [WM].[OperationOffset])
	WHERE
		([JOI].[FirstIssued] IS NOT NULL)
		AND ([WM].[QtyIssued] < [WM].[UnitQtyReqd])
		AND ([JOI].[FirstIssued] >= '{SD}')
		AND ((CASE WHEN ISNULL({TLO}, 0) = 1 THEN (CASE WHEN LEFT([WM].[Job], 1) = '1' THEN 1 ELSE 0 END) ELSE 1 END) > 0)
	""".format(SD=start_date_in, TLO=top_level_only)

	sql_new_yts = """
	SELECT
		'New YTs' AS [T],
		CASE WHEN (Src.Job IS NOT NULL AND Src.StockCode IS NOT NULL) THEN 1 ELSE 0 END AS [FoundOnBoth],
		YT.LastModified,
		YT.WO,
		YT.StockCode,
		YT.Description,
		YT.PO,
		YT.QtyMissing,
		YT.Notes,
		YT.ID AS [YT_ID]
	FROM BWSdb.dbo.PROD_YellowTags YT
	LEFT JOIN dbo.fn_PartOrNoneIssued('{SD}', {TLO}, {TOL}) AS Src
		ON YT.WO        = Src.Job
	   AND YT.StockCode = Src.StockCode COLLATE DATABASE_DEFAULT
	WHERE YT.DateCreated >= '{SD}'
	  AND (
			CASE WHEN ISNULL({TLO}, 0) = 1
				 THEN CASE WHEN LEFT(YT.WO, 1) = '1' THEN 1 ELSE 0 END
				 ELSE 1
			END
		  ) > 0
	""".format(SD=start_date_in, TLO=top_level_only, TOL=tolerance)

	sql_success = """
	SELECT
		'SUCCESS!' AS [CorrectlyPredicted],
		YT.ID AS [YT_ID],
		YT.*
	FROM BWSdb.dbo.PROD_YellowTags YT
	INNER JOIN dbo.fn_PartOrNoneIssued('{SD}', {TLO}, {TOL}) AS Src
		ON YT.WO        = Src.Job COLLATE DATABASE_DEFAULT
	   AND YT.StockCode = Src.StockCode COLLATE DATABASE_DEFAULT
	WHERE YT.DateCreated >= '{SD}'
	  AND (
			CASE WHEN ISNULL({TLO}, 0) = 1
				 THEN CASE WHEN LEFT(YT.WO, 1) = '1' THEN 1 ELSE 0 END
				 ELSE 1
			END
		  ) > 0
	""".format(SD=start_date_in, TLO=top_level_only, TOL=tolerance)

	sql_fail_manual = """
	SELECT
		'FAIL_MANUAL_ONLY' AS [CorrectlyPredicted],
		YT.WO,
		YT.StockCode,
		YT.DateCreated AS [YTDateCreated]
	FROM BWSdb.dbo.PROD_YellowTags YT
	INNER JOIN (
		SELECT DISTINCT Job
		FROM dbo.fn_PartOrNoneIssued('{SD}', {TLO}, {TOL})
	) J
		ON YT.WO = J.Job COLLATE DATABASE_DEFAULT
	LEFT JOIN dbo.fn_PartOrNoneIssued('{SD}', {TLO}, {TOL}) Src
		ON YT.WO        = Src.Job COLLATE DATABASE_DEFAULT
	   AND YT.StockCode = Src.StockCode COLLATE DATABASE_DEFAULT
	WHERE Src.Job IS NULL
	  AND YT.DateCreated >= '{SD}';
	""".format(SD=start_date_in, TLO=top_level_only, TOL=tolerance)

	sql_fail_auto = """
	SELECT
		'FAIL_AUTO_ONLY' AS [CorrectlyPredicted],
		Src.*
	FROM dbo.fn_PartOrNoneIssued('{SD}', {TLO}, {TOL}) Src
	LEFT JOIN BWSdb.dbo.PROD_YellowTags YT
		ON YT.WO        = Src.Job COLLATE DATABASE_DEFAULT
	   AND YT.StockCode = Src.StockCode COLLATE DATABASE_DEFAULT
	WHERE YT.WO IS NULL
	  AND Src.FirstIssued >= '{SD}';
	""".format(SD=start_date_in, TLO=top_level_only, TOL=tolerance)

	sql_prod_job_issue_status = """SELECT * FROM [BWSdb].[dbo].[v_PROD_JobIssueStatus]"""

	sql_prod_job_op_issue_status = """SELECT * FROM [BWSdb].[dbo].[v_PROD_JobOpIssueStatus]"""

	sqls = {
		"Material posted since param date [WipJobPost] only": sql_new_mat,
		"Showing the current stockcodes with missing or partial issuing": sql_part_or_none,
		"New YTs since param date": sql_new_yts,
		"These YTs were correctly auto-flagged and manually input": sql_success,
		"Someone marked something as a YT, but the system didn't pick up on it (No records = Good!)": sql_fail_manual,
		"POTENTIALLY, these YTs are YET-TO-BE made manually (No records = Good! some records = maybe okay)": sql_fail_auto,
		"Job Issue Status": sql_prod_job_issue_status,
		"Job Op Issue Status": sql_prod_job_op_issue_status
	}

	returns = {}
	for i, sql_k in enumerate(sqls):
		sql = sqls[sql_k]
		print(f"{i=}")
		print(sql)
		returns[sql_k] = connect(sql)

	return returns


st.set_page_config(layout="wide")

pills_menu_options = [
	"Yellow Tags",
	"New Yellow Tags"
]

k_pills_menu: str = "key_pills_menu"
if k_pills_menu not in st.session_state:
	st.session_state[k_pills_menu] = 1
pills_menu = pills(
	label="Menu",
	options=pills_menu_options,
	key=k_pills_menu,
	label_visibility="hidden"
)

if pills_menu == pills_menu_options[1]:
	# View New Yellow Tags

	# k_start_date = "key_start_date"
	# if k_start_date not in st.session_state:
	# 	st.session_state[k_start_date] = datetime.datetime.strptime()"2025-09-18 08:00"
	# start_date = st.date_input(
	# 	label="Start date:",
	# 	key=k_start_date
	# )
	#
	# if isinstance(start_date, str):
	# 	sd = datetime.datetime.strptime(start_date, "%Y-%m-%d %H:%M").date()
	# else:
	# 	sd = start_date
	dfs = load_new_yellow_tags()

	df_keys = list(dfs.keys())
	list_jobs = sorted(dfs[df_keys[0]]["Job"].dropna().unique().tolist())
	list_ops = sorted(dfs[df_keys[0]]["Job"].dropna().unique().tolist())

	k_toggle_top_level_only = "key_toggle_top_level_only"
	if k_toggle_top_level_only not in st.session_state:
		st.session_state[k_toggle_top_level_only] = True

	cols_search_box = st.columns([0.85, 0.15])

	with cols_search_box[1]:
		toggle_top_level_only = st.toggle(
			label="Top Level Only?",
			key=k_toggle_top_level_only
		)

	k_multiselect_jobs = "key_multiselect_jobs"

	if toggle_top_level_only:
		list_jobs = [j for j in list_jobs if j[0] == "1"]

	k_button_add_all_jobs = "key_button_add_all_jobs"
	with cols_search_box[1]:
		if (button_add_all_jobs := st.button(
				label="Add All Jobs",
				key=k_button_add_all_jobs,
				help=""
		)):
			st.session_state[k_multiselect_jobs] = list_jobs

	k_button_clear_all_jobs = "key_button_clear_all_jobs"
	with cols_search_box[1]:
		if (button_clear_all_jobs := st.button(
				label="Clear All Jobs",
				key=k_button_clear_all_jobs
		)):
			st.session_state[k_multiselect_jobs] = []

	if k_multiselect_jobs not in st.session_state:
		st.session_state[k_multiselect_jobs] = list_jobs
	with cols_search_box[0]:
		multiselect_jobs = st.multiselect(
			label="Select some jobs",
			options=list_jobs,
			key=k_multiselect_jobs
		)

	if multiselect_jobs:
		with st.container():
			st.write("progress:")
			data = dfs[df_keys[-2]]
			data = data[["Job", "PctComplete"]]
			data = data.loc[data["Job"].isin(multiselect_jobs)]
			data.sort_values(
				by="PctComplete",
				inplace=True,
				ascending=False
			)
			chart = px.bar(
				data,
				x="PctComplete",
				y="Job"
			)
			chart.update_yaxes(type="category")
			st.plotly_chart(chart)
		for i, df_k in enumerate(dfs):
			df = dfs[df_k]
			if multiselect_jobs:
				for col in ["Job", "WO"]:
					if col in df.columns:
						df = df.loc[df[col].isin(multiselect_jobs)]
			with st.expander(
					f"{i} - {df_k}"
			):
				n_rows, n_cols = df.shape
				st.write(f"{n_rows} row(s) X {n_cols} col(s)")
				st.write(df)
	else:
		st.warning("Select some jobs first")

else:
	# View the Current Yellow Tags
	k_toggle_active_only: str = "key_toggle_active_only"
	st.session_state.setdefault(k_toggle_active_only, True)
	toggle_active_only = st.toggle(
		label="Active YTs only?",
		key=k_toggle_active_only
	)

	k_df_timeout: str = "key_df_timeout"
	k_df_yts: str = "key_df_yts"
	k_force_rerun: str = "key_rerun"
	st.session_state.setdefault(k_force_rerun, False)
	df_yts: pd.DataFrame = st.session_state.setdefault(k_df_yts, load_yellow_tags())
	query_time = st.session_state.setdefault(k_df_timeout, datetime.datetime.now())
	curr_time = datetime.datetime.now()
	st.write(f"{query_time=}")
	st.write(f"{curr_time=}")

	cont_header = st.container()
	cont_data = st.container()
	if ((curr_time - query_time).total_seconds() / (1000 * MIN_QUERY_HOLD_TIME)) >= 1:
		del st.session_state[k_df_timeout]
		del st.session_state[k_df_yts]

	if (st.session_state.get(k_force_rerun, False)) or (k_df_yts not in st.session_state):
		print("RERUN to requery")

		load_yellow_tags.clear()
		df_fresh = load_yellow_tags()
		st.session_state[k_df_yts] = df_fresh.copy()  # Working copy
		st.session_state[k_df_timeout] = datetime.datetime.now()
		st.session_state[k_force_rerun] = False
		cont_data.empty()
		st.rerun()

	vis_cols = {
		"DateCreated": "Missing Since",
		"WO": "WO",
		"QtyMissing": "# Missing",
		"QtyOnHand": "# on Hand",
		"StockCode": "Part",
		"Desc": "Desc",
		"LongDesc": "Long Desc",
		"Supplier": "Supplier",
		"PO": "PO",
		"Notes": "Notes"
	}
	vis_cols_short = {k: v for k, v in vis_cols.items()}
	del vis_cols_short["QtyMissing"]
	del vis_cols_short["QtyOnHand"]
	del vis_cols_short["LongDesc"]
	del vis_cols_short["PO"]
	df_yts: pd.DataFrame = df_yts.rename(columns=vis_cols)
	if toggle_active_only:
		df_yts = df_yts[df_yts["Active"] == 1]
	df_yts[vis_cols["DateCreated"]] = df_yts[vis_cols["DateCreated"]].apply(lambda x: x.date() if pd.notnull(x) else "")
	df_yts[vis_cols["PO"]] = df_yts[vis_cols["PO"]].apply(lambda x: int(str(x)[-6:]) if not pd.isna(x) else x)
	df_yts[vis_cols["StockCode"]] = df_yts[vis_cols["StockCode"]].apply(lambda x: x.upper() if not pd.isna(x) else x)
	k_df_yts: str = "key_df_yts"
	k_de_yts: str = f"key_de_yts_{query_time:%x %X}"

	title: str = "Production Yellow tags"
	shape = df_yts.shape
	title = f"{title} ({shape[0]} Rows".strip()
	title += f" x {shape[1]} Cols)" if len(shape) > 1 else ")"
	with cont_header:
		st.write(title)

	with cont_data:
		de_yts = st.data_editor(
			df_yts[vis_cols.values()],
			width=1500,
			height=650,
			on_change=change_df_yts,
			key=k_de_yts,
			hide_index=True
		)

#
# rolling_window = 3
# min_periods = 3
# df_order_counts = load_order_counts()
# df_order_counts_2 = df_order_counts[~pd.isna(df_order_counts["Order Date"])]
# df_order_counts_2["AvgDDQO"] = df_order_counts_2["DaysBtwnQuoteOrder"].rolling(
# 	window=rolling_window,
# 	min_periods=min_periods
# ).mean()
# display_df(
# 	df_order_counts,
# 	"df_order_counts - Rolling Avg Datediffs"
# )
# display_df(
# 	df_order_counts_2,
# 	"df_order_counts_2 - Rolling Avg Datediffs"
# )
#
# df_quotes_per_day = df_order_counts.copy()
# df_quotes_per_day["Quote Date"] = df_quotes_per_day["Quote Date"].apply(lambda x: x.date())
# df_quotes_per_day["Date"] = df_quotes_per_day["Date"].apply(lambda x: x.date())
# # df_quotes_per_day["QuotesPerDay"] = df_quotes_per_day.groupby(
# df_quotes_per_day_grouped_0 = df_quotes_per_day.groupby(
# 	by="Quote Date"
# ).agg({
# 	"Quote#": "count"
# }).rename(columns={"Quote#": "CountOfQuotes"})
# df_quotes_per_day["QuotesPerDay"] = df_quotes_per_day.merge(
# 	df_quotes_per_day_grouped_0["CountOfQuotes"],
# 	left_on="Date",
# 	right_on="Quote Date",
# 	how="left"
# )["CountOfQuotes"]
#
# df_quotes_per_day["QPDAvg"] = df_quotes_per_day["QuotesPerDay"].rolling(
# 	window=rolling_window
# ).mean()
#
# display_df(
# 	df_quotes_per_day_grouped_0,
# 	"df_quotes_per_day - Grouped"
# )
# display_df(
# 	df_quotes_per_day,
# 	"df_quotes_per_day - Final"
# )
