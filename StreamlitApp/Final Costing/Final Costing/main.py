import datetime

import streamlit as st
import altair as alt

from datetime_utility import date_to_datetime
from pyodbc_connection import connect
import pandas as pd

from streamlit_extras.dataframe_explorer import dataframe_explorer
import plotly.figure_factory as ff
import plotly.express as px
from streamlit_extras.add_vertical_space import add_vertical_space
from utility import money, percent

DEF_TODAY_DATE = datetime.datetime.now()
DEF_START_DATE = DEF_TODAY_DATE + datetime.timedelta(days=-200)
DEF_END_DATE = DEF_TODAY_DATE + datetime.timedelta(days=100)
MAX_QUERY_HOLD_TIME = 1000*60*2  # 2 hours
CREDS_BWS = {
    "uid": "user5",
    "pwd": "M@gic456"
}
CREDS_STG = {
    "uid": "SGeu1",
    "pwd": "Pupplies-Hagard->Rio0"
}


for k, v in {
    "multiselect_model_no": list(),
    "toggle_completed_only": True,
    "di_start": DEF_START_DATE,
    "di_end": DEF_END_DATE
}.items():
    st.session_state.setdefault(k, v)


@st.cache_data(show_spinner=False, ttl=MAX_QUERY_HOLD_TIME)
def load_stargate_product_data() -> pd.DataFrame:
    sql = """
SELECT
	[P2].[Grouping]
	,[P2].[Class]
	,[P2].[Model No]
FROM
	[BWSdb].[dbo].[ProductsV2] [P2] WITH (NOLOCK)
WHERE (
	([P2].[Non-Current] = 0)
	AND ([P2].[Proposed] = 0)
	AND ([P2].[CompanyID] = 1)
)
GROUP BY
	[P2].[Grouping]
	,[P2].[Class]
	,[P2].[Model No]
    """
    connection_data = {
        "sql": sql,
        "database": "bwsdb",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect(**connection_data)


@st.cache_data(show_spinner=False, ttl=MAX_QUERY_HOLD_TIME)
def load_stargate_data(where_criteria: str = None) -> pd.DataFrame:
    # if where_criteria is None:
    #     where_criteria = " WHERE 1=1 "
    # if "WHERE" not in where_criteria:
    #     raise ValueError("'WHERE' not in the criteria.")
    sql = """
SELECT
	[Quote Date]
	,[Delivery Date]
	,[WO#]
	,[SGQuote]
	,[Model No]
	,[Dealer]
	,[US Sale]
	,[OrderBasePrice]
	,[SumOfValueIssued_MadeIn]
	,[SumOfValueIssued_BoughtOut]
	,[SumOfValueIssued_SubContract]
	,[SumOfLabourAct]
	,[SumOfLabourBud]
	,[SumOfLabourOverUnder]
	,[SalePrice]
	,[ExchangeRate]
	,[Completed]
	,[ActCompleteDate]
	,[JobStartDate]
	,[SalePriceCDN]
	,[TotalCostSoFar]
	,[SalePriceCDN] - [TotalCostSoFar] AS [MarginCDN$]
	,(CASE WHEN [TotalCostSoFar] = 0 THEN 0 ELSE [SalePriceCDN] / [TotalCostSoFar] END) AS [RatioSaleToCostCDN]
	,(CASE WHEN [TotalCostSoFar] = 0 THEN 0 ELSE (([SalePriceCDN] / [TotalCostSoFar]) - 1) END) AS [MarginCDN%]
FROM (
	SELECT
		[Quote Date]
		,[Delivery Date]
		,[WO#]
		,[SGQuote]
		,[Model No]
		,[Dealer]
		,[US Sale]
		,[OrderBasePrice]
		,[ProductBasePrice]
		,[ProductBasePriceUS]
		,[SumOfValueIssued_MadeIn]
		,[SumOfValueIssued_BoughtOut]
		,[SumOfValueIssued_SubContract]
		,[SumOfLabourAct]
		,[SumOfLabourBud]
		,[SumOfLabourOverUnder]
		,[SalePrice]
		,[ExchangeRate]
		,[Completed]
		,[ActCompleteDate]
		,[JobStartDate]
		,[SalePriceCDN]
		,[SumOfValueIssued_MadeIn] + [SumOfValueIssued_BoughtOut] + [SumOfValueIssued_SubContract] + [SumOfLabourAct] AS [TotalCostSoFar]
	FROM (
		SELECT
			[WL].[Quote Date]
			,[WL].[Delivery Date]
			,[WL].[WO#]
			,[WL].[SGQuote]
			,[WL].[Model No]
			,[WL].[Dealer]
			,[WL].[US Sale]
			,[WL].[OrderPrice] AS [OrderBasePrice]
			,[WL].[ProductPrice] AS [ProductBasePrice]
			,[WL].[ProductPriceUS] AS [ProductBasePriceUS]
			,SUM(CASE WHEN [JP].[PartCategory] = 'M' THEN [JP].[ValueIssued] ELSE 0 END) AS [SumOfValueIssued_MadeIn]
			,SUM(CASE WHEN [JP].[PartCategory] = 'B' THEN [JP].[ValueIssued] ELSE 0 END) AS [SumOfValueIssued_BoughtOut]
			,SUM(CASE WHEN [JP].[PartCategory] = 'G' THEN [JP].[ValueIssued] ELSE 0 END) AS [SumOfValueIssued_SubContract]
			,ISNULL([Lab].[SumOfLabourAct], 0) AS [SumOfLabourAct]
			,ISNULL([Lab].[SumOfLabourBud], 0) AS [SumOfLabourBud]
			,ISNULL([Lab].[SumOfLabourBud], 0) - ISNULL([Lab].[SumOfLabourAct], 0) AS [SumOfLabourOverUnder]
			,ISNULL([OP2].[NetCost], 0) AS [SalePrice]
			,[WL].[ExchangeRate]
			,[WL].[Completed]
			,[WL].[ActCompleteDate]
			,[WL].[JobStartDate]
			,ISNULL([OP2].[NetCostCDN], 0) AS [SalePriceCDN]
		FROM (
			SELECT
				CAST([O2].[WO#] AS NVARCHAR(MAX)) AS [WO#]
				,[O2].[Quote Date]
				,[O2].[Delivery Date]
				,[O2].[US Sale]
				,[O2].[SGQuote]
				,[O2].[Model No]
				,[D2].[COMPANY NAME] AS [Dealer]
				,[O2].[Price] AS [OrderPrice]
				,[P2].[Price] AS [ProductPrice]
				,[P2].[US Price] AS [ProductPriceUS]
				,[SM].[ExchangeRate]
				--,(CASE WHEN [CJ].[Job] IS NOT NULL THEN 1 ELSE 0 END) AS [Completed]
				,[WM].[JobStartDate]
				,[WM].[ActCompleteDate]
				,(CASE WHEN [WM].[ActCompleteDate] IS NOT NULL THEN 1 ELSE 0 END) AS [Completed]
			FROM
				[BWSdb].[dbo].[OrdersV2] [O2] WITH (NOLOCK)
			INNER JOIN
				[BWSdb].[dbo].[ProductsV2] [P2] WITH (NOLOCK)
			ON
				[O2].[ProductID] = [P2].[IDTrailer]
			LEFT JOIN
				[BWSdb].[dbo].[DealersV2] [D2] WITH (NOLOCK)
			ON
				[O2].[DealerID] = [D2].[ID]
			--LEFT JOIN
			--	[SysproCompanyS].[dbo].[v_CompletedJobInfo] [CJ] WITH (NOLOCK)
			--ON
			--	[O2].[Sales Order#] = CAST([CJ].[Sales Order#] AS INT)
			LEFT JOIN
				[SysproCompanyS].[dbo].[SorMaster] [SM] WITH (NOLOCK)
			ON
				[O2].[Sales Order#] = CAST([SM].[SalesOrder] AS INT)
			LEFT JOIN
				[SysproCompanyS].[dbo].[WipMaster] [WM] WITH (NOLOCK)
			ON
				[O2].[WO#] = CAST([WM].[Job] AS INT)
			GROUP BY
				CAST([O2].[WO#] AS NVARCHAR(MAX))
				,[O2].[Quote Date]
				,[O2].[Delivery Date]
				,[O2].[US Sale]
				,[O2].[SGQuote]
				,[O2].[Model No]
				,[D2].[COMPANY NAME]
				,[O2].[Price]
				,[P2].[Price]
				,[P2].[US Price]
				,[SM].[ExchangeRate]
				,[WM].[ActCompleteDate]
				,[WM].[JobStartDate]
		) AS [WL]
		LEFT JOIN
			[SysproCompanyS].[dbo].[v_WorkOrderStatus] [JP]
		ON
			[WL].[WO#] = [JP].[Job]
		LEFT JOIN (
			SELECT
				[Job]
				,ISNULL(SUM([ValueIssued]), 0) AS [SumOfLabourAct]
				,ISNULL(SUM([Lab].[UnitValueReqd]), 0) AS [SumOfLabourBud]
			FROM
				[SysproCompanyS].[dbo].[WipJobAllLab] [Lab]
			GROUP BY
				[Job]
		) AS [Lab]
		ON
			[Lab].[Job] = [JP].[Job]
		LEFT JOIN
			[BWSdb].[dbo].[v_SAL_OrdersPricingV2] [OP2]
		ON
			[WL].[SGQuote] = [OP2].[SGQuote]
		GROUP BY
			[WL].[WO#]
			,[WL].[Quote Date]
			,[WL].[Delivery Date]
			,[WL].[US Sale]
			,[WL].[SGQuote]
			,[WL].[Model No]
			,[Wl].[Dealer]
			,[WL].[OrderPrice]
			,[WL].[ProductPrice]
			,[WL].[ProductPriceUS]
			,[WL].[ExchangeRate]
			,[WL].[Completed]
			,[WL].[ActCompleteDate]
			,[WL].[JobStartDate]
			,[Lab].[SumOfLabourAct]
			,[Lab].[SumOfLabourBud]
			,[OP2].[NetCost]
			,[OP2].[NetCostCDN]
	) AS [Step1]
) AS [Step2]
ORDER BY
	[WO#]
;
    """
    # sql = sql.format(WHERE_CRITERIA=where_criteria)
    connection_data = {
        "sql": sql,
        "database": "bwsdb",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect(**connection_data)


def multiselect_model_no_on_change():
    models_in = st.session_state.get("multiselect_model_no", list())
    print(f"New Models: {models_in}")


def toggle_completed_only_on_change():
    completed_only = st.session_state.get("toggle_completed_only", list())
    print(f"New Completed Only: {completed_only}")


def di_start_on_change():
    start_date = st.session_state.get("di_start", DEF_START_DATE)
    print(f"New Start Date: {start_date:%Y-%m-%d}")


def di_end_on_change():
    end_date = st.session_state.get("di_end", DEF_END_DATE)
    print(f"New End Date: {end_date:%Y-%m-%d}")


st.set_page_config(layout="wide")
df_margin_data_stg = load_stargate_data()
# st.dataframe(df_margin_data_stg)
df_product_data_stg = load_stargate_product_data()

df_margin_data_stg["MarginCDN%_#"] = df_margin_data_stg["MarginCDN%"] * 100

df_margin_data_stg["OrderBasePrice_#"] = df_margin_data_stg["OrderBasePrice"]
df_margin_data_stg["SumOfValueIssued_MadeIn_#"] = df_margin_data_stg["SumOfValueIssued_MadeIn"]
df_margin_data_stg["SumOfValueIssued_BoughtOut_#"] = df_margin_data_stg["SumOfValueIssued_BoughtOut"]
df_margin_data_stg["SumOfValueIssued_SubContract_#"] = df_margin_data_stg["SumOfValueIssued_SubContract"]
df_margin_data_stg["SalePrice_#"] = df_margin_data_stg["SalePrice"]
df_margin_data_stg["SalePriceCDN_#"] = df_margin_data_stg["SalePriceCDN"]
df_margin_data_stg["TotalCostSoFar_#"] = df_margin_data_stg["TotalCostSoFar"]
df_margin_data_stg["MarginCDN$_#"] = df_margin_data_stg["MarginCDN$"]

df_margin_data_stg["Quote Date_d"] = df_margin_data_stg["Quote Date"]
df_margin_data_stg["Delivery Date_d"] = df_margin_data_stg["Delivery Date"]
df_margin_data_stg["ActCompleteDate_d"] = df_margin_data_stg["ActCompleteDate"]
df_margin_data_stg["JobStartDate_d"] = df_margin_data_stg["JobStartDate"]

for col, func in {
    "WO#": lambda w: str(w) if w else "",
    "OrderBasePrice": lambda w: money(w) if w else "",
    "SumOfValueIssued_MadeIn": lambda w: money(w) if w else "",
    "SumOfValueIssued_BoughtOut": lambda w: money(w) if w else "",
    "SumOfValueIssued_SubContract": lambda w: money(w) if w else "",
    "SalePrice": lambda w: money(w) if w else "",
    "SalePriceCDN": lambda w: money(w) if w else "",
    "TotalCostSoFar": lambda w: money(w) if w else "",
    "MarginCDN$": lambda w: money(w) if w else "",
    "Quote Date": lambda d: "" if pd.isna(d) else f"{d:%Y-%m-%d}",
    "Delivery Date": lambda d: "" if pd.isna(d) else f"{d:%Y-%m-%d}",
    "ActCompleteDate": lambda d: "" if pd.isna(d) else f"{d:%Y-%m-%d}",
    "JobStartDate": lambda d: "" if pd.isna(d) else f"{d:%Y-%m-%d}",
    "MarginCDN%": lambda w: percent(w) if w else ""
}.items():
    df_margin_data_stg[col] = df_margin_data_stg[col].apply(func)

df_margin_data_stg["MatCost_#"] = (
    df_margin_data_stg["SumOfValueIssued_MadeIn_#"]
    + df_margin_data_stg["SumOfValueIssued_BoughtOut_#"]
    + df_margin_data_stg["SumOfValueIssued_SubContract_#"]
)
df_margin_data_stg["MatCost"] = df_margin_data_stg["MatCost_#"].apply(lambda c: money(c))
df_margin_data_stg["Completed_b"] = df_margin_data_stg["Completed"].apply(lambda c: bool(c))
show_cols = {
    "WO#": "WO#",
    "SGQuote": "SGQuote",
    "Model No": "Model No",
    "Dealer": "Dealer",
    "US Sale": "US Sale",
    "ExchangeRate": "FX Rate",
    "OrderBasePrice": "OrderBasePrice",
    "SumOfValueIssued_MadeIn": "MI",
    "SumOfValueIssued_BoughtOut": "BO",
    "SumOfValueIssued_SubContract": "SC",
    "MatCost": "Mat Cost",
    "SumOfLabourAct": "Lab. Act",
    "SumOfLabourBud": "Lab. Bud",
    "SumOfLabourOverUnder": "Lab. +/-",
    "Completed_b": "Complete",
    "SalePriceCDN": "Sale Price",
    "TotalCostSoFar": "TotalCost",
    "MarginCDN$": "Mgn. $",
    "MarginCDN%": "Mgn. %",
    "RatioSaleToCostCDN": "Sale : Cost",
    "Quote Date": "Quote Date",
    "Delivery Date": "Delivery Date",
    "JobStartDate": "Start Date",
    "ActCompleteDate": "End Date"
}

# # df_margin_data_stg["WO#"] = df_margin_data_stg["WO#"].apply(lambda w: str(w) if w else "")
# df_margin_data_stg["OrderBasePrice"] = df_margin_data_stg["OrderBasePrice"].apply(lambda w: money(w) if w else "")
# df_margin_data_stg["SumOfValueIssued_MadeIn"] = df_margin_data_stg["SumOfValueIssued_MadeIn"].apply(lambda w: money(w) if w else "")
# # df_margin_data_stg["Quote Date"] = pd.to_datetime(df_margin_data_stg["Quote Date"])
# # df_margin_data_stg["Delivery Date"] = pd.to_datetime(df_margin_data_stg["Delivery Date"])
# # df_margin_data_stg["Quote Date"] = df_margin_data_stg["Quote Date"].fillna("")
# # df_margin_data_stg["Delivery Date"] = df_margin_data_stg["Quote Date"].fillna("")
# df_margin_data_stg["Quote Date"] = df_margin_data_stg["Quote Date"].apply(lambda d: "" if pd.isna(d) else f"{d:%Y-%m-%d}")
# df_margin_data_stg["Delivery Date"] = df_margin_data_stg["Delivery Date"].apply(lambda d: "" if pd.isna(d) else f"{d:%Y-%m-%d}")


ctl_columns = st.columns(3)

with ctl_columns[0]:
    tg_completed = st.toggle(
        label="Completed units Only",
        key="toggle_completed_only",
        on_change=toggle_completed_only_on_change
    )

with ctl_columns[1]:
    di_start = st.date_input(
        label="Start Prod Date",
        key="di_start",
        on_change=di_start_on_change,
        format="YYYY-MM-DD"
    )

with ctl_columns[2]:
    di_end = st.date_input(
        label="End Prod Date",
        key="di_end",
        on_change=di_end_on_change,
        format="YYYY-MM-DD"
    )


ms_models = st.multiselect(
    label="Select Model(s)",
    options=df_product_data_stg["Model No"].unique().tolist(),
    key="multiselect_model_no",
    help="Select some models to view margin path_data.",
    on_change=multiselect_model_no_on_change
)


selected_models = st.session_state.get("multiselect_model_no", list())
if selected_models:
    # filtered = dataframe_explorer(df_margin_data_stg, case=False)
    filtered = df_margin_data_stg[
        (df_margin_data_stg["Model No"].isin(selected_models))
        & (df_margin_data_stg["Completed"] == int(tg_completed))
        & (df_margin_data_stg["JobStartDate_d"] >= date_to_datetime(di_start))
        & (df_margin_data_stg["JobStartDate_d"] <= date_to_datetime(di_end))
    ]
    # print(f"{filtered['JobStartDate'].min()=}")
    # print(f"{filtered['JobStartDate'].max()=}")

    n_records = filtered.shape[0]

    add_vertical_space(4)

    st.write(f"##### {n_records} WO{'' if n_records == 1 else 's'}")
    show_filtered = filtered.rename(columns=show_cols)
    # st.dataframe(show_filtered)
    # st.write(show_cols)
    show_filtered = show_filtered[[sc for sc in show_cols.values()]]
    st.dataframe(
        show_filtered,
        hide_index=True
    )
    # column_config = {}
    # column_config.update({
    #     "Quote Date": st.column_config.DateColumn(
    #         "Quote Date",
    #         format="YYYY-MM-DD",
    #         # step=1,
    #     ),
    #     "Delivery Date": st.column_config.DateColumn(
    #         "Delivery Date",
    #         format="YYYY-MM-DD",
    #         # step=1,
    #     )
    # })
    # st.data_editor(
    #     filtered,
    #     column_config=column_config,
    #     hide_index=True,
    # )

    # chart = alt.Chart(filtered).mark_circle().encode(
    #     x='Quote Date',
    #     y='MarginCDN%_#'
    # ).interactive()
    # st.altair_chart(chart, theme=None, use_container_width=True)
    #
    # # chart = ff.create_distplot(
    # #     filtered["MarginCDN%_#"],
    # #     ["JobStartDate"],
    # #     bin_size=[.1, .25, .5]
    # # )

    filtered["HoverData"] = ""
    for i, row in filtered.iterrows():
        wo = row["WO#"]
        mg = row["MarginCDN%_#"]
        mn = row["Model No"]
        # filtered.loc[i, "HoverData"] = f"WO={wo}, %={mg}, MN={mn}"
        filtered.loc[i, "HoverData"] = f"WO={wo}, MN={mn}"

    chart = px.scatter(
        filtered.rename(columns=show_cols),
        x=show_cols.get("JobStartDate", "JobStartDate"),
        y=show_cols.get("MarginCDN%_#", "MarginCDN%_#"),
        hover_data="HoverData",
        title="% Margin vs Production Start Date"
    )
    st.plotly_chart(chart, theme=None)

else:
    st.write("Please select some models first.")
