import datetime

import streamlit as st
import plotly.express as px

from pyodbc_connection import connect, pd
from streamlit_utility import display_df
from datetime_utility import end_of_month


st.set_page_config(
	layout="wide",
	page_title="Cost Implosion Export"
)


@st.cache_data(show_spinner=True)
def load_data_orders() -> pd.DataFrame:
	sql = """
SELECT
    [P].[Grouping] AS [ModelGroup]
    , [P].[Class] AS [ModelClass]
    , [P].[Model No] AS [ModelNo]
    , [O].[Quote#] AS [Quote]
    , [O].[Order Date] AS [DateOrder]
    , ISNULL([PD].[Prod Date], [PD].[Prod Date2]) AS [DateProd]
    , [O].[Delivery Date] AS [DateDelivery]
    , DATEDIFF(DAY, [O].[Order Date], [O].[Delivery Date]) AS [NDaysOrder2Delivery]
    , DATEDIFF(DAY, [O].[Order Date], ISNULL([PD].[Prod Date], [PD].[Prod Date2])) AS [NDaysOrder2Prod]
    , DATEDIFF(DAY, ISNULL([PD].[Prod Date], [PD].[Prod Date2]), [O].[Delivery Date]) AS [NDaysProd2Delivery]
FROM
    [BWSdb].[dbo].[Orders] [O]
INNER JOIN
    [BWSdb].[dbo].[Products] [P]
ON
    [O].[ProductID] = [P].[IDTrailer]
LEFT JOIN
    [BWSdb].[dbo].[Production] [PD]
ON
    [O].[Quote#] = [PD].[Quote#]
WHERE
    ([O].[Decline/Rejected] = 4)
    AND ([O].[Date Declined] IS NULL)
    AND ([P].[Non-Current] = 0)
    AND ([P].[Proposed] = 0)
"""
	return connect(sql)


@st.cache_data(show_spinner=True)
def load_data() -> pd.DataFrame:
	sql = """
SELECT
	[ModelGroup],
	[ModelClass],
	[ModelNo],
	COUNT(*) AS [NOrders],
	AVG([NDaysOrder2Delivery]) AS [AvgNDaysOrder2Delivery],
	AVG([NDaysOrder2Prod]) AS [AvgNDaysOrder2Prod],
	AVG([NDaysProd2Delivery]) AS [AvgNDaysProd2Delivery],
	MIN([DateOrder]) AS [FirstDateOrder],
	MAX([DateOrder]) AS [LastDateOrder],
	MIN([DateProd]) AS [FirstDateProd],
	MAX([DateProd]) AS [LastDateProd],
	MIN([DateDelivery]) AS [FirstDateDelivery],
	MAX([DateDelivery]) AS [LastDateDelivery]
FROM (
	SELECT
		[P].[Grouping] AS [ModelGroup]
		, [P].[Class] AS [ModelClass]
		, [P].[Model No] AS [ModelNo]
		, [O].[Order Date] AS [DateOrder]
		, ISNULL([PD].[Prod Date], [PD].[Prod Date2]) AS [DateProd]
		, [O].[Delivery Date] AS [DateDelivery]
		, DATEDIFF(DAY, [O].[Order Date], [O].[Delivery Date]) AS [NDaysOrder2Delivery]
		, DATEDIFF(DAY, [O].[Order Date], ISNULL([PD].[Prod Date], [PD].[Prod Date2])) AS [NDaysOrder2Prod]
		, DATEDIFF(DAY, ISNULL([PD].[Prod Date], [PD].[Prod Date2]), [O].[Delivery Date]) AS [NDaysProd2Delivery]
	FROM
		[BWSdb].[dbo].[Orders] [O]
	INNER JOIN
		[BWSdb].[dbo].[Products] [P]
	ON
		[O].[ProductID] = [P].[IDTrailer]
	LEFT JOIN
		[BWSdb].[dbo].[Production] [PD]
	ON
		[O].[Quote#] = [PD].[Quote#]
	WHERE
		([O].[Decline/Rejected] = 4)
		AND ([O].[Date Declined] IS NULL)
		AND ([P].[Non-Current] = 0)
		AND ([P].[Proposed] = 0)
) AS [Src]
GROUP BY
	[ModelGroup],
	[ModelClass],
	[ModelNo]
;
"""
	return connect(sql)


@st.cache_data(show_spinner=True)
def load_stockcode_data() -> pd.DataFrame:
	sql = """
SELECT 
	[InvMaster].[StockCode],
	[InvMaster].[Description],
	[InvMaster].[LongDesc]
FROM 
	[SysproCompanyA].[dbo].[InvMaster]
GROUP BY
	[InvMaster].[StockCode],
	[InvMaster].[Description],
	[InvMaster].[LongDesc]
; 
"""
	return connect(sql)


@st.cache_data(show_spinner=True)
def load_excel_data(sd: datetime.date, ed: datetime.date, stock_codes: list[str]):
	template = """
SELECT 
    [StockCode],
    [JnlDate],
    [RowID], 
    (CASE WHEN [ColumnName] = 'MaterialCost' THEN CAST([Before] AS DECIMAL(18, 5)) ELSE 0 END) AS [Before Material Cost],
    (CASE WHEN [ColumnName] = 'MaterialCost' THEN CAST([After] AS DECIMAL(18, 5)) ELSE 0 END) AS [After Material Cost],
    (CASE WHEN [ColumnName] = 'LabourCost' THEN CAST([Before] AS DECIMAL(18, 5)) ELSE 0 END) AS [Before Labour Cost],
    (CASE WHEN [ColumnName] = 'LabourCost' THEN CAST([After] AS DECIMAL(18, 5)) ELSE 0 END) AS [After Labour Cost],
    (CASE WHEN [ColumnName] = 'FixedOverhead' THEN CAST([Before] AS DECIMAL(18, 5)) ELSE 0 END) AS [Before Fixed Overhead],
    (CASE WHEN [ColumnName] = 'FixedOverhead' THEN CAST([After] AS DECIMAL(18, 5)) ELSE 0 END) AS [After Fixed Overhead],
	[ColumnName]
FROM (
	SELECT
		ROW_NUMBER() OVER(
			PARTITION BY 
				[StockCode], 
				YEAR([JnlDate]),
				MONTH([JnlDate]),
				[ColumnName]
			ORDER BY
				[StockCode],
				[JnlDate]
		) AS [RowID],
		[JnlDate],
		[StockCode],
		[ColumnName],
		[Before],
		[After]
	FROM 
		[SysproCompanyA].[dbo].[InvMastAmendJnl] WITH (NOLOCK)
	WHERE
		[OperatorCode] = 'ROBOT'
		AND [JnlDate] BETWEEN '{SD}' AND '{ED}'
		AND [StockCode] IN ({LSC})
) AS [mainsub]
WHERE 
	[RowID] = 1
ORDER BY
	[StockCode],
	[JnlDate],
	[RowID]
;
"""
	ssd = f"{sd:%Y-%m-%d}"
	sed = f"{ed:%Y-%m-%d}"
	lsc = "'" + "', '".join(stock_codes) + "'"
	sql = template.format(SD=ssd, ED=sed, LSC=lsc)
	if toggle_show_code:
		st.code(sql, language="sql")
	return connect(sql)


# Load and process data
df_orders: pd.DataFrame = load_data_orders()
list_quotes: list[int] = df_orders["Quote"].unique().tolist()
list_quotes.sort(reverse=True)
cols_dates = [c for c in df_orders if c.lower().startswith("date")]
cols_totals_o = [c for c in df_orders if c.lower().startswith("n") or c.lower().startswith("avgn")]

df_data: pd.DataFrame = load_data()
df_cols: list[str] = list(df_data.columns)
cols_totals = [c for c in df_cols if c.lower().startswith("n") or c.lower().startswith("avgn")]
cols_categories = [c for c in df_cols if c.lower().startswith("model")]

# Layout
cols_containers = st.columns([0.6, 0.2, 0.2])
cont_chart = st.container(border=True)
cols_chart = cont_chart.columns([0.3, 0.7])

# Create widgets within structure
with cols_containers[0]:
	st.header("Average Days Between Order, Production, and Delivery")

cont_y_axis = cols_containers[1].container(border=True)
cont_x_axis = cols_containers[2].container(border=True)

k_selectbox_y_axis = "selectbox_y_axis"
k_selectbox_x_axis = "selectbox_x_axis"

st.session_state.setdefault(k_selectbox_y_axis, "AvgNDaysOrder2Delivery")
st.session_state.setdefault(k_selectbox_x_axis, "ModelClass")

with cont_y_axis:
	selectbox_y_axis = st.selectbox(
		label="y-axis",
		key=k_selectbox_y_axis,
		options=cols_totals
	)
with cont_x_axis:
	selectbox_x_axis = st.selectbox(
		label="x-axis",
		key=k_selectbox_x_axis,
		options=cols_categories
	)

# If valid inputs, begin charting
if selectbox_x_axis and selectbox_y_axis:
	df_chart_data = df_data.groupby(
		by=selectbox_x_axis,
		as_index=False,
		dropna=False
	).agg({
		selectbox_y_axis: "mean"
	})

	for i, by_data in enumerate([
		{"cont": cont_y_axis, "by": selectbox_y_axis},
		{"cont": cont_x_axis, "by": selectbox_x_axis}
	]):
		cols_by_cont = by_data["cont"].columns([0.25, 0.25, 0.5])
		for j, btn_data in enumerate([
			{"lbl": "asc", "asc": True},
			{"lbl": "desc", "asc": False}
		]):
			with cols_by_cont[j]:
				if st.button(
						label=btn_data["lbl"],
						key=f"btn_sort_chart_{by_data['by']}_{btn_data['lbl']}"
				):
					df_chart_data.sort_values(
						by=by_data["by"],
						ascending=btn_data["asc"],
						inplace=True
					)

	chart_data = px.bar(
		df_chart_data,
		x=selectbox_x_axis,
		y=selectbox_y_axis,
		height=625
	)

	with cols_chart[1]:
		chart = st.plotly_chart(
			chart_data
		)

	with cols_chart[0]:
		k_selectbox_sel_quote = "selectbox_sel_quote"
		selectbox_sel_quote = st.selectbox(
			label="View a Quote:",
			key=k_selectbox_sel_quote,
			options=list_quotes
		)

		if selectbox_sel_quote:
			df_quote: pd.DataFrame = pd.DataFrame(
				df_orders.loc[
					df_orders["Quote"] == selectbox_sel_quote
					].iloc[0]
			).reset_index()
			idx = df_quote.columns[-1]
			df_quote = df_quote.rename(
				columns={
					"index": "Column",
					idx: "Value"
				}
			)

			for i, row in df_quote.iterrows():
				col_name = row["Column"]
				val = df_quote.loc[i, "Value"]
				if col_name in cols_dates:
					df_quote.loc[i, "Value"] = f"{val:%Y-%m-%d}" if not pd.isna(val) else "N/A"
				elif col_name in cols_totals_o:
					df_quote.loc[i, "Value"] = int(val) if not pd.isna(val) else "N/A"

			# for col in cols_dates:
			#     val = sr_quote[col]
			#     print(f"{col=}, {val=}")
			#     if not pd.isna(val):
			#         sr_quote[col] = f"{val:%Y-%m-%d}"

			# # date_order = sr_quote["DateOrder"]
			# # date_prod = sr_quote["DateProd"]
			# # date_delivery = sr_quote["DateDelivery"]

			display_df(
				df_quote,
				width=400
			)

		# d_o = f"{date_order:%x}" if not pd.isna(date_order) else "N/A"
		# d_p = f"{date_prod:%x}" if not pd.isna(date_prod) else "N/A"
		# d_d = f"{date_delivery:%x}" if not pd.isna(date_delivery) else "N/A"
		# st.write(f"Order Date: {d_o}")
		# st.write(f"Production Date: {d_p}")
		# st.write(f"Delivery Date: {d_d}")

else:
	st.write(
		"##### Select a 'Totals' value from the 'y-axis' select-box, and a 'Category' value from the 'x-axis' select-box to chart:")

st.divider()

st.header("Access Of Doom Cost Implosion")

df_stockcode_data: pd.DataFrame = load_stockcode_data()
list_stockcodes: list[str] = df_stockcode_data["StockCode"].unique().tolist()
list_stockcodes = [sc for sc in list_stockcodes if (not pd.isna(sc)) and len(str(sc))]

k_date_input_start = "date_input_start"
k_date_input_end = "date_input_end"
st.session_state.setdefault(k_date_input_start, datetime.datetime.now())
st.session_state.setdefault(k_date_input_end, end_of_month(datetime.datetime.now()))
date_input_start = st.date_input(
	label="Start",
	key=k_date_input_start
)
date_input_end = st.date_input(
	label="End",
	key=k_date_input_end
)

multiselect_stockcodes = st.multiselect(
	label="Select up-to 10 StockCodes Below:",
	options=list_stockcodes,
	max_selections=10
)

if date_input_start and date_input_end and multiselect_stockcodes:
	toggle_show_code = st.toggle(
		label="show generated code?",
		value=False
	)
	if st.button(
		label="run"
	):
		df_excel_data = load_excel_data(date_input_start, date_input_end, multiselect_stockcodes)
		display_df(
			df_excel_data,
			"df_excel_data",
			hide_index=False
		)
else:
	st.write("please make some selections first.")
