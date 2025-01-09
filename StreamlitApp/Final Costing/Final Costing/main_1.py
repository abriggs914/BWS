import datetime
from typing import Any

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


###########
# CONSTANTS
###########


DEF_TODAY_DATE: datetime.datetime = datetime.datetime.now()
DEF_START_DATE: datetime.datetime = DEF_TODAY_DATE + datetime.timedelta(days=-200)
DEF_END_DATE: datetime.datetime = DEF_TODAY_DATE + datetime.timedelta(days=100)
MAX_QUERY_HOLD_TIME: int = 1000*60*2  # 2 hours
SHOW_SPINNERS: bool = True
BWS: int = 0
STG: int = 1
CREDS_BWS: dict[str: Any] = {
    "uid": "user5",
    "pwd": "M@gic456",
    "quote_key": "Quote#"
}
CREDS_STG: dict[str: Any] = {
    "uid": "SGeu1",
    "pwd": "Pupplies-Hagard->Rio0",
    "quote_key": "SGQuote"
}


#######################
# Prep st.session_state
#######################


st.set_page_config(layout="wide")
for k, v in {
    "multiselect_model_no": list(),
    "toggle_completed_only": True,
    "di_start": DEF_START_DATE,
    "di_end": DEF_END_DATE
}.items():
    st.session_state.setdefault(k, v)


######################
# Data Fetch Functions
######################


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
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


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_bws_product_data() -> pd.DataFrame:
    sql = """
SELECT
	[P].[Grouping]
	,[P].[Class]
	,[P].[Model No]
FROM
	[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
WHERE (
	([P].[Non-Current] = 0)
	AND ([P].[Proposed] = 0)
	AND ([P].[CompanyID] = 0)
)
GROUP BY
	[P].[Grouping]
	,[P].[Class]
	,[P].[Model No]
    """
    connection_data = {
        "sql": sql,
        "database": "bwsdb",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect(**connection_data)


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
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


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_bws_data(where_criteria: str = None) -> pd.DataFrame:
    # if where_criteria is None:
    #     where_criteria = " WHERE 1=1 "
    # if "WHERE" not in where_criteria:
    #     raise ValueError("'WHERE' not in the criteria.")
    sql = """
SELECT
	[Quote Date]
	,[Delivery Date]
	,[WO#]
	,[Quote#]
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
		,[Quote#]
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
			,[WL].[Quote#]
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
			,ISNULL([OP].[NetCost], 0) AS [SalePrice]
			,[WL].[ExchangeRate]
			,[WL].[Completed]
			,[WL].[ActCompleteDate]
			,[WL].[JobStartDate]
			,ISNULL([OP].[NetCostCDN], 0) AS [SalePriceCDN]
		FROM (
			SELECT
				CAST([O].[WO#] AS NVARCHAR(MAX)) AS [WO#]
				,[O].[Quote Date]
				,[O].[Delivery Date]
				,[O].[US Sale]
				,[O].[Quote#]
				,[O].[Model No]
				,[D].[COMPANY NAME] AS [Dealer]
				,[O].[Price] AS [OrderPrice]
				,[P].[Price] AS [ProductPrice]
				,[P].[US Price] AS [ProductPriceUS]
				,[SM].[ExchangeRate]
				--,(CASE WHEN [CJ].[Job] IS NOT NULL THEN 1 ELSE 0 END) AS [Completed]
				,[WM].[JobStartDate]
				,[WM].[ActCompleteDate]
				,(CASE WHEN [WM].[ActCompleteDate] IS NULL THEN 0 ELSE 1 END) AS [Completed]
			FROM
				[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
			INNER JOIN
				[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
			ON
				[O].[ProductID] = [P].[IDTrailer]
			LEFT JOIN
				[BWSdb].[dbo].[Dealers] [D] WITH (NOLOCK)
			ON
				[O].[DealerID] = [D].[ID]
			--LEFT JOIN
			--	[SysproCompanyS].[dbo].[v_CompletedJobInfo] [CJ] WITH (NOLOCK)
			--ON
			--	[O2].[Sales Order#] = CAST([CJ].[Sales Order#] AS INT)
			LEFT JOIN
				[SysproCompanyA].[dbo].[SorMaster] [SM] WITH (NOLOCK)
			ON
				CAST([O].[Sales Order#] AS NVARCHAR(MAX)) = [SM].[SalesOrder]
			LEFT JOIN
				[SysproCompanyA].[dbo].[WipMaster] [WM] WITH (NOLOCK)
			ON
				CAST([O].[WO#] AS NVARCHAR(MAX)) = [WM].[Job]
			--WHERE
			--	([P2].[Model No] = 'Frameless End Dump 2X')
			--	OR
			--	([P2].[Model No] = 'Frameless End Dump 3X')
			--	OR
			--	([O2].[WO#] = 10001577)
			GROUP BY
				CAST([O].[WO#] AS NVARCHAR(MAX))
				,[O].[Quote Date]
				,[O].[Delivery Date]
				,[O].[US Sale]
				,[O].[Quote#]
				,[O].[Model No]
				,[D].[COMPANY NAME]
				,[O].[Price]
				,[P].[Price]
				,[P].[US Price]
				,[SM].[ExchangeRate]
				,[WM].[ActCompleteDate]
				,[WM].[JobStartDate]
		) AS [WL]
		LEFT JOIN
			[SysproCompanyA].[dbo].[v_WorkOrderStatus] [JP] WITH (NOLOCK)
		ON
			[WL].[WO#] = [JP].[Job]
		LEFT JOIN (
			SELECT
				[Job]
				,ISNULL(SUM([ValueIssued]), 0) AS [SumOfLabourAct]
				,ISNULL(SUM([Lab].[UnitValueReqd]), 0) AS [SumOfLabourBud]
			FROM
				[SysproCompanyA].[dbo].[WipJobAllLab] [Lab] WITH (NOLOCK)
			GROUP BY
				[Job]
		) AS [Lab]
		ON
			[Lab].[Job] = [JP].[Job]
		LEFT JOIN
			[BWSdb].[dbo].[v_SAL_OrdersPricing] [OP] WITH (NOLOCK)
		ON
			[WL].[Quote#] = [OP].[Quote#]
		GROUP BY
			[WL].[WO#]
			,[WL].[Quote Date]
			,[WL].[Delivery Date]
			,[WL].[US Sale]
			,[WL].[Quote#]
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
			,[OP].[NetCost]
			,[OP].[NetCostCDN]
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


#################
# Event Listeners
#################


def multiselect_model_no_on_change():
    models_in = st.session_state.get("multiselect_model_no", list())
    print(f"New Models: {models_in}")


def multiselect_wo_omit_on_change():
    wos_out = st.session_state.get("multiselect_omit_wo", list())
    print(f"New WOs: {wos_out}")


def toggle_completed_only_on_change():
    completed_only = st.session_state.get("toggle_completed_only", list())
    print(f"New Completed Only: {completed_only}")


def di_start_on_change():
    start_date = st.session_state.get("di_start", DEF_START_DATE)
    print(f"New Start Date: {start_date:%Y-%m-%d}")


def di_end_on_change():
    end_date = st.session_state.get("di_end", DEF_END_DATE)
    print(f"New End Date: {end_date:%Y-%m-%d}")


####################
# Fetch Data SLOW...
####################


df_margin_data_stg = load_stargate_data()
df_margin_data_bws = load_bws_data()
# st.dataframe(df_margin_data_stg)
df_product_data_stg = load_stargate_product_data()
df_product_data_bws = load_bws_product_data()


###################################################
# Company Choice is critical for further processing
###################################################


options_radio_company_choice = [
    ":red[BWS]",
    ":blue[STARGATE]"
]
radio_company_choice = st.radio(
    "Company:",
    options_radio_company_choice,
    key="radio_company_choice",
    horizontal=True
)

COMP = BWS if radio_company_choice == options_radio_company_choice[0] else STG
COLOUR_OPERATIONS: list = list()
QUOTE_KEY = CREDS_STG["quote_key"] if COMP == STG else CREDS_BWS["quote_key"]


###################################
# Prep Data Based on Company Choice
###################################


df_margin_data = df_margin_data_stg if COMP == STG else df_margin_data_bws
df_product_data = df_product_data_stg if COMP == STG else df_product_data_bws


for col, sf_func in {
    "WO#": ("#", lambda w: str(w) if w else ""),
    "OrderBasePrice": ("#", lambda w: money(w) if w else ""),
    "SumOfValueIssued_MadeIn": ("#", lambda w: money(w) if w else ""),
    "SumOfValueIssued_BoughtOut": ("#", lambda w: money(w) if w else ""),
    "SumOfValueIssued_SubContract": ("#", lambda w: money(w) if w else ""),
    "SalePrice": ("#", lambda w: money(w) if w else ""),
    "SalePriceCDN": ("#", lambda w: money(w) if w else ""),
    "TotalCostSoFar": ("#", lambda w: money(w) if w else ""),
    "SumOfLabourAct": ("#", lambda w: money(w) if w else ""),
    "SumOfLabourBud": ("#", lambda w: money(w) if w else ""),
    "SumOfLabourOverUnder": ("#", lambda w: money(w) if w else ""),
    "MarginCDN$": ("#", lambda w: money(w) if w else ""),
    "Quote Date": ("d", lambda d: "" if pd.isna(d) else f"{d:%Y-%m-%d}"),
    "Delivery Date": ("d", lambda d: "" if pd.isna(d) else f"{d:%Y-%m-%d}"),
    "ActCompleteDate": ("d", lambda d: "" if pd.isna(d) else f"{d:%Y-%m-%d}"),
    "JobStartDate": ("d", lambda d: "" if pd.isna(d) else f"{d:%Y-%m-%d}"),
    "MarginCDN%": ("%", lambda w: percent(w) if w else "")
}.items():
    sf, func = sf_func
    if sf == "%":
        # preserve 100x percent format for sorting
        df_margin_data[f"{col}_{sf}"] = df_margin_data[col] * 100
    else:
        df_margin_data[f"{col}_{sf}"] = df_margin_data[col]
    df_margin_data[col] = df_margin_data[col].apply(func)

# df_margin_data["MarginCDN%_#"] = df_margin_data["MarginCDN%"] * 100

df_margin_data["MatCost_#"] = (
    df_margin_data["SumOfValueIssued_MadeIn_#"]
    + df_margin_data["SumOfValueIssued_BoughtOut_#"]
    + df_margin_data["SumOfValueIssued_SubContract_#"]
)
df_margin_data["MatCost"] = df_margin_data["MatCost_#"].apply(lambda c: money(c))
df_margin_data["Completed_b"] = df_margin_data["Completed"].apply(lambda c: bool(c))


show_cols = {
    "WO#": "WO#",
    QUOTE_KEY: QUOTE_KEY,
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


######################################
# Begin Streamlit Widgets & Page Setup
######################################


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
    options=sorted(df_product_data["Model No"].unique().tolist()),
    key="multiselect_model_no",
    help="Select some models to view margin path_data.",
    on_change=multiselect_model_no_on_change
)


selected_models = st.session_state.get("multiselect_model_no", list())
if selected_models:
    # filtered = dataframe_explorer(df_margin_data_stg, case=False)
    filtered: pd.DataFrame = df_margin_data[
        (df_margin_data["Model No"].isin(selected_models))
        & (df_margin_data["Completed"] == int(tg_completed))
        & (df_margin_data["JobStartDate_d"] >= date_to_datetime(di_start))
        & (df_margin_data["JobStartDate_d"] <= date_to_datetime(di_end))
    ]

    list_wos = filtered["WO#"].dropna().unique().tolist()
    ms_models = st.multiselect(
        label="Select WO(s) to omit from graph",
        options=list_wos,
        key="multiselect_omit_wo",
        help="Select some WO numbers that you want to exclude from the dataset.",
        on_change=multiselect_wo_omit_on_change
    )
    wos_to_omit = st.session_state.get("multiselect_omit_wo", list())

    filtered = filtered.loc[~filtered["WO#"].isin(wos_to_omit)]

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
        use_container_width=True,
        hide_index=True
    )

    filtered["HoverData"] = ""
    for i, row in filtered.iterrows():
        wo = row["WO#"]
        mg = row["MarginCDN%_%"]
        mn = row["Model No"]
        # filtered.loc[i, "HoverData"] = f"WO={wo}, %={mg}, MN={mn}"
        filtered.loc[i, "HoverData"] = f"WO={wo}, MN={mn}"

    chart = px.scatter(
        filtered.rename(columns=show_cols),
        x=show_cols.get("JobStartDate", "JobStartDate"),
        y=show_cols.get("MarginCDN%_%", "MarginCDN%_%"),
        hover_data="HoverData",
        title="% Margin vs Production Start Date"
    )
    st.plotly_chart(chart, theme=None, use_container_width=True)

    filtered["WO"] = filtered["WO#"].astype(str)
    # st.dataframe(filtered)
    # Reshape the DataFrame for Plotly Express (melt the monetary totals)
    filtered_melted = filtered.melt(
        id_vars='WO#',
        value_vars=['MatCost', 'SumOfLabourAct', 'OrderBasePrice', 'SalePriceCDN'],
        var_name='Category',
        value_name='Amount'
    )

    # Create a clustered bar chart
    chart = px.bar(
        filtered_melted,
        x='WO#',
        y='Amount',
        color='Category',
        barmode='group',
        labels={'WO#': 'Job Number', 'Amount': 'Monetary Totals'},
        title='Monetary Totals by Job',
    )
    chart.update_xaxes(type='category')
    st.plotly_chart(chart)

else:
    st.write("Please select some models first.")
