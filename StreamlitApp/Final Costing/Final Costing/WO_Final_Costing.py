import datetime
from typing import Any

import pyautogui
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
MAX_QUERY_HOLD_TIME: int = 1000 * 60 * 2  # 2 hours
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
DEFAULT_SESSION_STATE = {
    "multiselect_model_no": list(),
    "toggle_completed_only": True,
    "toggle_include_proposed": False,
    "toggle_include_non_current": False,
    "toggle_prod_year_month": False,
    "di_start": DEF_START_DATE,
    "di_end": DEF_END_DATE
}
for k, v in DEFAULT_SESSION_STATE.items():
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
	,[P2].[Non-Current]
	,[P2].[Proposed]
FROM
	[BWSdb].[dbo].[ProductsV2] [P2] WITH (NOLOCK)
WHERE
    [P2].[CompanyID] = 1
GROUP BY
	[P2].[Grouping]
	,[P2].[Class]
	,[P2].[Model No]
	,[P2].[Non-Current]
	,[P2].[Proposed]
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
	,[P].[Non-Current]
	,[P].[Proposed]
FROM
	[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
WHERE
    [P].[CompanyID] = 0
GROUP BY
	[P].[Grouping]
	,[P].[Class]
	,[P].[Model No]
	,[P].[Non-Current]
	,[P].[Proposed]
    """
    connection_data = {
        "sql": sql,
        "database": "bwsdb",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect(**connection_data)


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_stargate_data_20241106(where_criteria: str = None) -> pd.DataFrame:
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
def load_bws_data_20241106(where_criteria: str = None) -> pd.DataFrame:
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


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_stargate_data() -> pd.DataFrame:
    sql = """
    SELECT
        *
    FROM
        [BWSdb].[dbo].[v_SAL_OrdersMarginV2]
    ;
        """
    connection_data = {
        "sql": sql,
        "database": "bwsdb",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect(**connection_data)


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_bws_data() -> pd.DataFrame:
    sql = """
SELECT
    *
FROM
    [BWSdb].[dbo].[v_SAL_OrdersMargin]
;
    """
    connection_data = {
        "sql": sql,
        "database": "bwsdb",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect(**connection_data)


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_bws_job_counts_in_wip() -> pd.DataFrame:
    sql = """
SELECT
	[Cal].[Date]
	,YEAR([Cal].[Date]) AS [ProdYear]
	,MONTH([Cal].[Date]) AS [ProdMonth]
	,DAY([Cal].[Date]) AS [ProDay]
	,[Cal].[Day]
	,[P].[Grouping]
	,[P].[Class]
	,[P].[Model No]
	--,[Job]
	,COUNT([Job]) AS [AllInWip]
	/*,COUNT(*) AS [All]
	,COUNT([P].[Grouping]) AS [AllGrouping]*/
FROM
	[BWSdb].[dbo].[Calendar] [Cal]
CROSS JOIN
	[BWSdb].[dbo].[Products] [P]
LEFT JOIN (
	SELECT
		*
	FROM
		[SysproCompanyA].[dbo].[WipMaster] [Master]
	INNER JOIN
		[BWSdb].[dbo].[Orders] [O]
	ON
		CAST([Master].[Job] AS INT) = [O].[WO#]
	WHERE
		LEFT(ISNULL([Master].[Job], '1'), 1) = '1'
) AS [OrderSrc]
ON
	--([Cal].[Date] = [OrderSrc].[JobStartDate])
	([Cal].[Date] BETWEEN [OrderSrc].[JobStartDate] AND ISNULL([OrderSrc].[ActCompleteDate], DATEADD(DAY, 21, GETDATE())))
	AND ([P].[IDTrailer] = [OrderSrc].[ProductID])
WHERE
	([Cal].[Date] BETWEEN DATEADD(YEAR, -5, GETDATE()) AND DATEADD(DAY, 14, GETDATE()))
	AND ([P].[Non-Current] = 0)
	AND ([P].[Proposed] = 0)
GROUP BY
	[Cal].[Date]
	,[Cal].[Day]
	,[P].[Grouping]
	,[P].[Class]
	,[P].[Model No]
ORDER BY
	[Cal].[Date]
	,[P].[Grouping]
"""
    connection_data = {
        "sql": sql,
        "database": "bwsdb",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect(**connection_data)


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_bws_jobs_in_wip() -> pd.DataFrame:
    sql = """
SELECT
	[Cal].[Date]
	,YEAR([Cal].[Date]) AS [ProdYear]
	,MONTH([Cal].[Date]) AS [ProdMonth]
	,DAY([Cal].[Date]) AS [ProDay]
	,[Cal].[Day]
	,[P].[Grouping]
	,[P].[Class]
	,[P].[Model No]
	,[OrderSrc].[WO#]
FROM
	[BWSdb].[dbo].[Calendar] [Cal]
CROSS JOIN
	[BWSdb].[dbo].[Products] [P]
LEFT JOIN (
	SELECT
		*
	FROM
		[SysproCompanyA].[dbo].[WipMaster] [Master]
	INNER JOIN
		[BWSdb].[dbo].[Orders] [O]
	ON
		CAST([Master].[Job] AS INT) = [O].[WO#]
	WHERE
		LEFT(ISNULL([Master].[Job], '1'), 1) = '1'
) AS [OrderSrc]
ON
	--([Cal].[Date] = [OrderSrc].[JobStartDate])
	([Cal].[Date] BETWEEN [OrderSrc].[JobStartDate] AND ISNULL([OrderSrc].[ActCompleteDate], DATEADD(DAY, 21, GETDATE())))
	AND ([P].[IDTrailer] = [OrderSrc].[ProductID])
WHERE
	([Cal].[Date] BETWEEN DATEADD(YEAR, -5, GETDATE()) AND DATEADD(DAY, 14, GETDATE()))
	AND ([P].[Non-Current] = 0)
	AND ([P].[Proposed] = 0)
GROUP BY
	[Cal].[Date]
	,[Cal].[Day]
	,[P].[Grouping]
	,[P].[Class]
	,[P].[Model No]
	,[OrderSrc].[WO#]
ORDER BY
	[Cal].[Date]
	,[P].[Grouping]
"""
    connection_data = {
        "sql": sql,
        "database": "bwsdb",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect(**connection_data)


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_stg_job_counts_in_wip() -> pd.DataFrame:
    sql = """
SELECT
	[Cal].[Date]
	,YEAR([Cal].[Date]) AS [ProdYear]
	,MONTH([Cal].[Date]) AS [ProdMonth]
	,DAY([Cal].[Date]) AS [ProDay]
	,[Cal].[Day]
	,[P2].[Grouping]
	,[P2].[Class]
	,[P2].[Model No]
	--,[Job]
	,COUNT([Job]) AS [AllInWip]
	/*,COUNT(*) AS [All]
	,COUNT([P2].[Grouping]) AS [AllGrouping]*/
FROM
	[BWSdb].[dbo].[Calendar] [Cal]
CROSS JOIN
	[BWSdb].[dbo].[ProductsV2] [P2]
LEFT JOIN (
	SELECT
		*
	FROM
		[SysproCompanyS].[dbo].[WipMaster] [Master]
	INNER JOIN
		[BWSdb].[dbo].[OrdersV2] [O2]
	ON
		CAST([Master].[Job] AS INT) = [O2].[WO#]
	WHERE
		LEFT(ISNULL([Master].[Job], '1'), 1) = '1'
) AS [OrderSrc]
ON
	--([Cal].[Date] = [OrderSrc].[JobStartDate])
	([Cal].[Date] BETWEEN [OrderSrc].[JobStartDate] AND ISNULL([OrderSrc].[ActCompleteDate], DATEADD(DAY, 21, GETDATE())))
	AND ([P2].[IDTrailer] = [OrderSrc].[ProductID])
WHERE
	([Cal].[Date] BETWEEN DATEADD(YEAR, -5, GETDATE()) AND DATEADD(DAY, 14, GETDATE()))
	AND ([P2].[Non-Current] = 0)
	AND ([P2].[Proposed] = 0)
GROUP BY
	[Cal].[Date]
	,[Cal].[Day]
	,[P2].[Grouping]
	,[P2].[Class]
	,[P2].[Model No]
ORDER BY
	[Cal].[Date]
	,[P2].[Grouping]
"""
    connection_data = {
        "sql": sql,
        "database": "bwsdb",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect(**connection_data)


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_stg_jobs_in_wip() -> pd.DataFrame:
    sql = """
SELECT
	[Cal].[Date]
	,YEAR([Cal].[Date]) AS [ProdYear]
	,MONTH([Cal].[Date]) AS [ProdMonth]
	,DAY([Cal].[Date]) AS [ProDay]
	,[Cal].[Day]
	,[P2].[Grouping]
	,[P2].[Class]
	,[P2].[Model No]
	,[OrderSrc].[WO#]
FROM
	[BWSdb].[dbo].[Calendar] [Cal]
CROSS JOIN
	[BWSdb].[dbo].[ProductsV2] [P2]
LEFT JOIN (
	SELECT
		*
	FROM
		[SysproCompanyS].[dbo].[WipMaster] [Master]
	INNER JOIN
		[BWSdb].[dbo].[OrdersV2] [O2]
	ON
		CAST([Master].[Job] AS INT) = [O2].[WO#]
	WHERE
		LEFT(ISNULL([Master].[Job], '1'), 1) = '1'
) AS [OrderSrc]
ON
	--([Cal].[Date] = [OrderSrc].[JobStartDate])
	([Cal].[Date] BETWEEN [OrderSrc].[JobStartDate] AND ISNULL([OrderSrc].[ActCompleteDate], DATEADD(DAY, 21, GETDATE())))
	AND ([P2].[IDTrailer] = [OrderSrc].[ProductID])
WHERE
	([Cal].[Date] BETWEEN DATEADD(YEAR, -5, GETDATE()) AND DATEADD(DAY, 14, GETDATE()))
	AND ([P2].[Non-Current] = 0)
	AND ([P2].[Proposed] = 0)
GROUP BY
	[Cal].[Date]
	,[Cal].[Day]
	,[P2].[Grouping]
	,[P2].[Class]
	,[P2].[Model No]
	,[OrderSrc].[WO#]
ORDER BY
	[Cal].[Date]
	,[P2].[Grouping]
"""
    connection_data = {
        "sql": sql,
        "database": "bwsdb",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect(**connection_data)


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_quotes_orders_by_date():
    sql = """
    SELECT
	[Cal].[Date]
	,[Cal].[HolidayName]
	,SUM([NumNewQuotesBWS]) AS [NumNewQuotesBWS]
	,SUM([NumNewOrdersBWS]) AS [NumNewOrdersBWS]
	,MIN([FirstQuoteBWS]) AS [FirstQuoteBWS]
	,MAX([LastQuoteBWS]) AS [LastQuoteBWS]
	,SUM([FirstWOBWS]) AS [FirstWOBWS]
	,SUM([LastWOBWS]) AS [LastWOBWS]

	,SUM([NumNewQuotesSTG]) AS [NumNewQuotesSTG]
	,SUM([NumNewOrdersSTG]) AS [NumNewOrdersSTG]
	,MIN([FirstQuoteSTG]) AS [FirstQuoteSTG]
	,MAX([LastQuoteSTG]) AS [LastQuoteSTG]
	,SUM([FirstWOSTG]) AS [FirstWOSTG]
	,SUM([LastWOSTG]) AS [LastWOSTG]
	
	,SUM([NumNewQuotesBWS]) + SUM([NumNewQuotesSTG]) AS [TotalNewQuotes]
	,SUM([NumNewOrdersBWS]) + SUM([NumNewOrdersSTG]) AS [TotalNewOrders]
FROM
	[BWSdb].[dbo].[Calendar] [Cal] WITH (NOLOCK)
LEFT JOIN (
	SELECT
		[Quote Date]
		,COUNT([Quote Date]) AS [NumNewQuotesBWS]
		,COUNT([Order Date]) AS [NumNewOrdersBWS]
		,MIN([Quote#]) AS [FirstQuoteBWS]
		,MAX([Quote#]) AS [LastQuoteBWS]
		,MIN([WO#]) AS [FirstWOBWS]
		,MAX([WO#]) AS [LastWOBWS]

		,NULL AS [NumNewQuotesSTG]
		,NULL AS [NumNewOrdersSTG]
		,NULL AS [FirstQuoteSTG]
		,NULL AS [LastQuoteSTG]
		,NULL AS [FirstWOSTG]
		,NULL AS [LastWOSTG]
	FROM
		[BWSdb].[dbo].[Orders] WITH (NOLOCK)
	GROUP BY
		[Quote Date]

	UNION ALL

	SELECT
		[Quote Date]
		,NULL AS [NumNewQuotesBWS]
		,NULL AS [NumNewOrdersBWS]
		,NULL AS [FirstQuoteBWS]
		,NULL AS [LastQuoteBWS]
		,NULL AS [FirstWOBWS]
		,NULL AS [LastWOBWS]

		,COUNT([Quote Date]) AS [NumNewQuotesSTG]
		,COUNT([Order Date]) AS [NumNewOrdersSTG]
		,MIN(CAST(RIGHT([SGQuote], LEN([SGQuote]) - 2) AS INT)) AS [FirstQuoteSTG]
		,MAX(CAST(RIGHT([SGQuote], LEN([SGQuote]) - 2) AS INT)) AS [LastQuoteSTG]
		,MIN([WO#]) AS [FirstWOSTG]
		,MAX([WO#]) AS [LastWOSTG]
	FROM
		[BWSdb].[dbo].[OrdersV2] WITH (NOLOCK)
	GROUP BY
		[Quote Date]

) AS [OrderSrc]
ON
	[Cal].[Date] = [OrderSrc].[Quote Date]
WHERE
	[Cal].[Date] BETWEEN '2006-01-01' AND DATEADD(YEAR, 2, GETDATE())
GROUP BY
	[Cal].[Date]
	,[Cal].[HolidayName]
ORDER BY
	[Cal].[Date]
;
"""
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


def multiselect_grouping_omit_on_change():
    groupings_out = st.session_state.get("multiselect_omit_groupings", list())
    print(f"New Groupings: {groupings_out}")


def multiselect_classes_omit_on_change():
    classes_out = st.session_state.get("multiselect_omit_classes", list())
    print(f"New Classes: {classes_out}")


def multiselect_models_omit_on_change():
    models_out = st.session_state.get("multiselect_omit_models", list())
    print(f"New Models: {models_out}")


def toggle_completed_only_on_change():
    completed_only = st.session_state.get("toggle_completed_only", list())
    print(f"New Completed Only: {completed_only}")


def toggle_include_proposed_on_change():
    proposed = st.session_state.get("toggle_include_proposed", list())
    print(f"New Include Proposed: {proposed}")


def toggle_include_non_current_on_change():
    non_current = st.session_state.get("toggle_include_non_current", list())
    print(f"New Exclude Non-Current: {non_current}")


def toggle_prod_year_month_on_change():
    year_month = st.session_state.get("toggle_prod_year_month", list())
    print(f"New Year / Month: {year_month}")


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
df_jobs_in_wip_bws = load_bws_jobs_in_wip()
df_jobs_in_wip_stg = load_stg_jobs_in_wip()
df_job_counts_in_wip_bws = load_bws_job_counts_in_wip()
df_job_counts_in_wip_stg = load_stg_job_counts_in_wip()
df_quotes_orders_by_date_bws = load_quotes_orders_by_date()

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
QUOTE_KEY = CREDS_STG["quote_key"] if COMP == STG else CREDS_BWS["quote_key"]
COLOUR_OPERATIONS: list = list()


###################################
# Prep Data Based on Company Choice
###################################


# st.dataframe(df_product_data_bws)
# st.dataframe(df_product_data_stg)

inc_tg_nc = st.session_state.get("toggle_include_non_current", DEFAULT_SESSION_STATE.get("toggle_include_non_current"))
inc_tg_pp = st.session_state.get("toggle_include_proposed", DEFAULT_SESSION_STATE.get("toggle_include_proposed"))
if inc_tg_nc:
    if inc_tg_pp:
        pass
    else:
        df_product_data_stg = df_product_data_stg.loc[
            df_product_data_stg["Proposed"] == st.session_state.get("toggle_include_proposed", DEFAULT_SESSION_STATE.get("toggle_include_proposed"))
        ]
        df_product_data_bws = df_product_data_bws.loc[
            df_product_data_bws["Proposed"] == st.session_state.get("toggle_include_proposed", DEFAULT_SESSION_STATE.get("toggle_include_proposed"))
        ]
else:
    if inc_tg_pp:
        df_product_data_stg = df_product_data_stg.loc[
            df_product_data_stg["Non-Current"] == st.session_state.get("toggle_include_non_current", DEFAULT_SESSION_STATE.get("toggle_include_non_current"))
        ]
        df_product_data_bws = df_product_data_bws.loc[
            df_product_data_bws["Non-Current"] == st.session_state.get("toggle_include_non_current", DEFAULT_SESSION_STATE.get("toggle_include_non_current"))
        ]
    else:
        df_product_data_stg = df_product_data_stg.loc[
            (df_product_data_stg["Proposed"] == st.session_state.get("toggle_include_proposed", DEFAULT_SESSION_STATE.get("toggle_include_proposed")))
            & (df_product_data_stg["Non-Current"] == st.session_state.get("toggle_include_non_current", DEFAULT_SESSION_STATE.get("toggle_include_non_current")))
        ]
        df_product_data_bws = df_product_data_bws.loc[
            (df_product_data_bws["Proposed"] == st.session_state.get("toggle_include_proposed", DEFAULT_SESSION_STATE.get("toggle_include_proposed")))
            & (df_product_data_bws["Non-Current"] == st.session_state.get("toggle_include_non_current", DEFAULT_SESSION_STATE.get("toggle_include_non_current")))
        ]
# st.write(st.session_state.get("toggle_include_non_current", DEFAULT_SESSION_STATE.get("toggle_include_non_current")))
# st.write(st.session_state.get("toggle_include_proposed", DEFAULT_SESSION_STATE.get("toggle_include_proposed")))
# st.dataframe(df_product_data_bws)
# st.dataframe(df_product_data_stg)

df_margin_data = df_margin_data_stg if COMP == STG else df_margin_data_bws
df_product_data = df_product_data_stg if COMP == STG else df_product_data_bws
df_jobs_in_wip = df_jobs_in_wip_stg if COMP == STG else df_jobs_in_wip_bws
df_job_counts_in_wip = df_job_counts_in_wip_stg if COMP == STG else df_job_counts_in_wip_bws
df_quotes_orders_by_date = df_quotes_orders_by_date_bws.copy()

df_margin_data["WO#"] = df_margin_data["WO#"].apply(lambda wo: "" if pd.isna(wo) else str(int(wo)))
df_jobs_in_wip["WO#"] = df_jobs_in_wip["WO#"].apply(lambda wo: "" if pd.isna(wo) else str(int(wo)))

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


def clear_cache():
    st.cache_data.clear()
    st.cache_resource.clear()


def rerun():
    # st.rerun()  # no op
    pyautogui.hotkey("ctrl", "F5")


def clear_cache_and_rerun():
    clear_cache()
    rerun()


######################################
# Begin Streamlit Widgets & Page Setup
######################################


button_clear_cache_and_rerun = st.sidebar.button(
    label="Clear Cache & Rerun",
    on_click=clear_cache_and_rerun
)


ctl_columns = st.columns(3)

with ctl_columns[0]:
    tg_completed = st.toggle(
        label="Completed units Only",
        key="toggle_completed_only",
        on_change=toggle_completed_only_on_change
    )
    tg_proposed = st.toggle(
        label="Include Proposed",
        key="toggle_include_proposed",
        on_change=toggle_include_proposed_on_change
    )
    tg_non_current = st.toggle(
        label="Include Non-Current",
        key="toggle_include_non_current",
        on_change=toggle_include_non_current_on_change
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
    help="Select some models to view margin data.",
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
    ms_wos_omit = st.multiselect(
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

    filtered["JobStartDate"] = pd.to_datetime(filtered["JobStartDate"])
    chart = px.scatter(
        filtered.rename(columns=show_cols),
        x=show_cols.get("JobStartDate", "JobStartDate"),
        y=show_cols.get("MarginCDN%_%", "MarginCDN%_%"),
        hover_data="HoverData",
        title="% Margin vs Production Start Date",
        trendline="ols"
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
        title='Monetary Totals by Job'
    )
    chart.update_xaxes(type='category')
    st.plotly_chart(chart)

else:
    st.write("Please select some models first.")

add_vertical_space(7)
tg_prod_year_month = st.toggle(
    label="View Annually",
    key="toggle_prod_year_month",
    on_change=toggle_prod_year_month_on_change
)
if tg_prod_year_month:
    df_jobs_in_wip["ProdDate"] = df_jobs_in_wip['ProdYear'].astype(str)
    df_job_counts_in_wip["ProdDate"] = df_job_counts_in_wip['ProdYear'].astype(str)
    prod_date_label = 'Production Year'
else:
    df_jobs_in_wip["ProdDate"] = df_jobs_in_wip['ProdYear'].astype(str) + "-" + df_jobs_in_wip['ProdMonth'].astype(str).str.zfill(2)
    df_job_counts_in_wip["ProdDate"] = df_job_counts_in_wip['ProdYear'].astype(str) + "-" + df_job_counts_in_wip['ProdMonth'].astype(str).str.zfill(2)
    prod_date_label = 'Production Month-Year'

# st.dataframe(df_job_counts_in_wip)

with st.expander(":new: Quotes and Orders By Date"):
    filtered_melted: pd.DataFrame = df_quotes_orders_by_date.loc[
        (df_quotes_orders_by_date["Date"] >= date_to_datetime(di_start))
        & (df_quotes_orders_by_date["Date"] <= date_to_datetime(di_end))
    ]
    filtered_melted["Date"] = filtered_melted["Date"].apply(lambda d: d.date())
    sel_cols = [
        "NumNewQuotes",
        "NumNewOrders",
        "FirstQuote",
        "LastQuote",
        "FirstWO",
        "LastWO",
    ]
    suf: str = 'STG' if COMP == STG else 'BWS'
    sel_cols = [f"{sc}{suf}" for sc in sel_cols]
    sel_cols.insert(0, "Date")
    filtered_melted = filtered_melted[sel_cols]
    st.dataframe(filtered_melted, hide_index=True, use_container_width=True)
    # filtered_melted = filtered_melted.melt(
    #     id_vars="Date",
    #     value_vars=["NumNewQuotesBWS", "NumNewQuotesSTG"],
    #     var_name="Category",
    #     value_name="Count"
    # )
    # chart = px.bar(
    #     filtered_melted,
    #     barmode="stack",
    #     x="Date",
    #     y="Count",
    #     color="Category",
    #     title="Count of new Quotes & WOs for BWS & Stargate",
    #     labels={"Date": "Date", "Count": "Num New Quotes"}
    # )
    filtered_melted: pd.DataFrame = filtered_melted.melt(
        id_vars="Date",
        value_vars=[f"NumNewQuotes{suf}", f"NumNewOrders{suf}"],
        var_name="Category",
        value_name="Count"
    )
    chart = px.bar(
        filtered_melted,
        barmode="stack",
        x="Date",
        y="Count",
        color="Category",
        title=f"Count of new Quotes & WOs {suf}",
        labels={"Date": "Date", "Count": "Count"}
    )

    # filtered_melted: pd.DataFrame = filtered_melted.melt(
    #     id_vars="Date",
    #     value_vars=["NumNewQuotesBWS", "NumNewQuotesSTG", "NumNewOrdersBWS", "NumNewOrdersSTG"],
    #     var_name="CategoryQuotesOrders",
    #     value_name="CountQuotesOrders"
    # )
    # # filtered_melted_o: pd.DataFrame = filtered_melted.melt(
    # #     id_vars="Date",
    # #     value_vars=["NumNewOrdersBWS", "NumNewOrdersSTG"],
    # #     var_name="CategoryOrders",
    # #     value_name="CountOrders"
    # # )
    # # filtered_melted = filtered_melted_q.merge(
    # #     filtered_melted_o,
    # #     how="outer",
    # #     on="Date"
    # # )
    #
    # chart = px.bar(
    #     filtered_melted,
    #     barmode="stack",
    #     x="Date",
    #     y="CountQuotesOrders",
    #     color="CategoryQuotesOrders",
    #     title="Count of new Quotes & WOs for BWS & Stargate",
    #     labels={"Date": "Date", "CountQuotesOrders": "Num New Quotes Orders"}
    # )
    st.plotly_chart(chart, theme=None, use_container_width=True)


# Jobs In Wip -- Grouping
with st.expander("Jobs in Wip By Grouping"):
    filtered_melted = df_job_counts_in_wip.loc[
        (df_job_counts_in_wip["Date"] >= date_to_datetime(di_start))
        & (df_job_counts_in_wip["Date"] <= date_to_datetime(di_end))
    ]
    filtered_melted = filtered_melted.melt(
        id_vars=["Grouping", "ProdDate"],
        value_vars='AllInWip',
        var_name='Category',
        value_name='# in WIP'
    )

    # st.dataframe(filtered_melted)
    filtered_melted = filtered_melted.groupby(['ProdDate', 'Grouping']).agg({'# in WIP': 'max'}).reset_index()
    filtered_melted = filtered_melted.rename(columns={'AllInWip': '# in WIP'})

    list_groupings = df_product_data["Grouping"].dropna().unique().tolist()
    ms_groupings_omit = st.multiselect(
        label="Select Grouping(s) to omit from graph",
        options=list_groupings,
        key="multiselect_omit_groupings",
        help="Select some Groupings that you want to exclude from the dataset.",
        on_change=multiselect_grouping_omit_on_change
    )
    groupings_to_omit = st.session_state.get("multiselect_omit_groupings", list())
    filtered_melted = filtered_melted.loc[~filtered_melted["Grouping"].isin(groupings_to_omit)]

    # st.dataframe(filtered_melted)
    chart = px.bar(
        filtered_melted,
        x="ProdDate",
        y="# in WIP",
        # hover_data="HoverData",
        title="# Units in WIP By Grouping",
        barmode='group',
        color="Grouping",
        labels={
            'ProdDate': prod_date_label
        },
        height=700
        # trendline="ols"
    )
    st.plotly_chart(chart, theme=None, use_container_width=True)

    df_show_jobs_in_wip: pd.DataFrame = df_jobs_in_wip.loc[
        (~df_jobs_in_wip["Grouping"].isin(groupings_to_omit))
        & (df_jobs_in_wip["Date"] >= date_to_datetime(di_start))
        & (df_jobs_in_wip["Date"] <= date_to_datetime(di_end))
    ]
    # st.dataframe(df_show_jobs_in_wip, use_container_width=True)
    # st.dataframe(df_margin_data, use_container_width=True)
    df_show_jobs_in_wip = df_show_jobs_in_wip.merge(
        df_margin_data,
        how="inner",
        left_on=["WO#", "Date"],
        right_on=["WO#", "ActCompleteDate_d"],
        suffixes=("_a", "_b")
    )
    st.dataframe(df_show_jobs_in_wip, use_container_width=True, hide_index=True)

    df_valuation_grouping = df_show_jobs_in_wip[[
        "ProdDate",
        "Grouping",
        "WO#",
        "MatCost_#",
        "OrderBasePrice_#",
        "SumOfLabourAct_#",
        "SalePriceCDN_#",
        "MarginCDN%_%"
    ]]
    df_valuation_grouping["GroupingCount"] = 0
    df_valuation_grouping_counts = df_valuation_grouping.groupby(
        ['ProdDate', 'Grouping']
    ).agg({'GroupingCount': 'count'}).reset_index()
    df_valuation_grouping = df_valuation_grouping.merge(
        df_valuation_grouping_counts[[
            "ProdDate",
            "Grouping",
            "GroupingCount"
        ]],
        on=['ProdDate', 'Grouping'],
        how='left'
    )
    df_valuation_grouping.drop(columns=["GroupingCount_x"], inplace=True)
    df_valuation_grouping.rename(columns={"GroupingCount_y": "GroupingCount"}, inplace=True)
    filtered_melted = df_valuation_grouping.melt(
        id_vars=["Grouping", "ProdDate", "GroupingCount"],
        value_vars=["MatCost_#", "OrderBasePrice_#", "SumOfLabourAct_#", "SalePriceCDN_#"],
        var_name='Category',
        value_name='$ in WIP'
    )
    groupings_to_omit = st.session_state.get("multiselect_omit_groupings", list())
    filtered_melted = filtered_melted.loc[~filtered_melted["Grouping"].isin(groupings_to_omit)]
    # st.dataframe(filtered_melted)
    filtered_melted = filtered_melted.groupby(
        ['ProdDate', 'Grouping', 'Category', "GroupingCount"]
    ).agg({'$ in WIP': 'sum'}).reset_index()
    filtered_melted["HoverData"] = filtered_melted.apply(lambda row: f"{row['GroupingCount']} x {row['Grouping']}", axis=1)

    # st.dataframe(filtered_melted)
    chart = px.bar(
        filtered_melted,
        x="ProdDate",
        y="$ in WIP",
        # hover_data="HoverData",
        title="Valuation $ Units in WIP By Grouping",
        barmode='group',
        color="Category",
        labels={
            'ProdDate': 'Production Date (Month Year)'
        },
        height=700
        # trendline="ols"
        ,hover_data=["HoverData"]
    )
    chart.update_xaxes(type='category')
    st.plotly_chart(chart, theme=None, use_container_width=True)

    # st.write(df_show_jobs_in_wip.loc[
    #     (~df_jobs_in_wip["Grouping"].isin(groupings_to_omit))
    #     & (df_jobs_in_wip["Date"] >= date_to_datetime(di_start))
    #     & (df_jobs_in_wip["Date"] <= date_to_datetime(di_end))
    #     , "WO#"
    # ].dropna().unique().tolist())

# # st.dataframe(filtered_melted)
# chart = px.bar(
#     filtered_melted,
#     x="ProdDate",
#     y="# in WIP",
#     # hover_data="HoverData",
#     title="# Units in WIP By Grouping",
#     barmode='group',
#     color="Grouping",
#     labels={
#         'ProdDate': 'Production Date (Month Year)'
#     },
#     height=700
#     # trendline="ols"
# )
# # st.plotly_chart(chart, theme=None, use_container_width=True)
# chart_json = chart.to_json()
#
# ## HTML and JavaScript to render Plotly and capture click events
# html_code = f"""
#     <div id="plotly-chart" style="height: 100%; width: 100%;"></div>
#     <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>
#     <script>
#         // Parse the Plotly figure JSON and render the chart
#         const fig = {chart_json};
#         Plotly.newPlot('plotly-chart', fig.data, fig.layout);
#
#         // Capture plotly_click event
#         document.getElementById('plotly-chart').on('plotly_click', function(data) {{
#             const point = data.points[0];
#             const clickedData = {{
#                 x: point.x,
#                 y: point.y,
#                 group: point.data.name
#             }};
#             // Send clicked data back to Streamlit using custom event
#             window.parent.postMessage(clickedData, "*");
#         }});
#     </script>
# """
#
# # Use st.components.v1.html to embed the HTML and JavaScript
# # clicked_data = components.html(html_code, height=600, scrolling=True)
# clicked_data = components.html(html_code, height=600, scrolling=True)
#
# # Receive the clicked data from the JavaScript custom event
# clicked_result = st.session_state.get("clicked_data")
#
# # Display information about the clicked bar
# if clicked_result:
#     st.write(f"**Clicked Bar Details:**")
#     st.write(f"- Production Date: {clicked_result['x']}")
#     st.write(f"- # in WIP: {clicked_result['y']}")
#     st.write(f"- Grouping: {clicked_result['group']}")

# Jobs In Wip -- Class
with st.expander("Jobs in Wip By Class"):
    filtered_melted = df_job_counts_in_wip.loc[
        (df_job_counts_in_wip["Date"] >= date_to_datetime(di_start))
        & (df_job_counts_in_wip["Date"] <= date_to_datetime(di_end))
    ]
    filtered_melted = filtered_melted.melt(
        id_vars=["Class", "ProdDate"],
        value_vars='AllInWip',
        var_name='Category',
        value_name='# in WIP'
    )

    # st.dataframe(filtered_melted)
    filtered_melted = filtered_melted.groupby(['ProdDate', 'Class']).agg({'# in WIP': 'max'}).reset_index()
    filtered_melted = filtered_melted.rename(columns={'AllInWip': '# in WIP'})

    list_classes = df_product_data["Class"].dropna().unique().tolist()
    ms_classes_omit = st.multiselect(
        label="Select Class(es) to omit from graph",
        options=list_classes,
        key="multiselect_omit_classes",
        help="Select some Classes that you want to exclude from the dataset.",
        on_change=multiselect_classes_omit_on_change
    )
    classes_to_omit = st.session_state.get("multiselect_omit_classes", list())
    filtered_melted = filtered_melted.loc[~filtered_melted["Class"].isin(classes_to_omit)]

    # st.dataframe(filtered_melted)
    chart = px.bar(
        filtered_melted,
        x="ProdDate",
        y="# in WIP",
        # hover_data="HoverData",
        title="# Units in WIP By Class",
        barmode='group',
        color="Class",
        labels={
            'ProdDate': 'Production Date (Month Year)'
        },
        height=700
        # trendline="ols"
    )
    st.plotly_chart(chart, theme=None, use_container_width=True)

    df_show_jobs_in_wip: pd.DataFrame = df_jobs_in_wip.loc[
        (~df_jobs_in_wip["Class"].isin(classes_to_omit))
        & (df_jobs_in_wip["Date"] >= date_to_datetime(di_start))
        & (df_jobs_in_wip["Date"] <= date_to_datetime(di_end))
    ]
    # st.dataframe(df_show_jobs_in_wip, use_container_width=True)
    # st.dataframe(df_margin_data, use_container_width=True)
    df_show_jobs_in_wip = df_show_jobs_in_wip.merge(
        df_margin_data,
        how="inner",
        left_on=["WO#", "Date"],
        right_on=["WO#", "ActCompleteDate_d"],
        suffixes=("_a", "_b")
    )
    st.dataframe(df_show_jobs_in_wip, use_container_width=True, hide_index=True)

    df_valuation_class = df_show_jobs_in_wip[[
        "ProdDate",
        "Class",
        "WO#",
        "MatCost_#",
        "OrderBasePrice_#",
        "SumOfLabourAct_#",
        "SalePriceCDN_#",
        "MarginCDN%_%"
    ]]
    df_valuation_class["ClassCount"] = 0
    df_valuation_class_counts = df_valuation_class.groupby(
        ['ProdDate', 'Class']
    ).agg({'ClassCount': 'count'}).reset_index()
    df_valuation_class = df_valuation_class.merge(
        df_valuation_class_counts[[
            "ProdDate",
            "Class",
            "ClassCount"
        ]],
        on=['ProdDate', 'Class'],
        how='left'
    )
    df_valuation_class.drop(columns=["ClassCount_x"], inplace=True)
    df_valuation_class.rename(columns={"ClassCount_y": "ClassCount"}, inplace=True)

    # st.write("Here")
    # st.dataframe(df_valuation_class_counts)
    # st.dataframe(df_valuation_class)
    filtered_melted = df_valuation_class.melt(
        id_vars=["Class", "ProdDate", "ClassCount"],
        value_vars=["MatCost_#", "OrderBasePrice_#", "SumOfLabourAct_#", "SalePriceCDN_#"],
        var_name='Category',
        value_name='$ in WIP'
    )
    groupings_to_omit = st.session_state.get("multiselect_omit_classes", list())
    filtered_melted = filtered_melted.loc[~filtered_melted["Class"].isin(classes_to_omit)]
    # st.dataframe(filtered_melted)
    filtered_melted = filtered_melted.groupby(
        ['ProdDate', 'Class', 'Category', "ClassCount"]
    ).agg({'$ in WIP': 'sum'}).reset_index()
    # st.write("A")
    # st.dataframe(filtered_melted)
    filtered_melted["HoverData"] = filtered_melted.apply(lambda row: f"{row['ClassCount']} x {row['Class']}", axis=1)

    # st.write("C")
    # st.dataframe(filtered_melted)
    chart = px.bar(
        filtered_melted,
        x="ProdDate",
        y="$ in WIP",
        # hover_data="HoverData",
        title="Valuation $ Units in WIP By Class",
        barmode='group',
        color="Category",
        labels={
            'ProdDate': 'Production Date (Month Year)'
        },
        height=700
        # trendline="ols"
        ,hover_data=["HoverData"]
    )
    chart.update_xaxes(type='category')
    st.plotly_chart(chart, theme=None, use_container_width=True)

# Jobs In Wip -- Model
with st.expander("Jobs in Wip By Model"):
    filtered_melted = df_job_counts_in_wip.loc[
        (df_job_counts_in_wip["Date"] >= date_to_datetime(di_start))
        & (df_job_counts_in_wip["Date"] <= date_to_datetime(di_end))
    ]
    filtered_melted = filtered_melted.melt(
        id_vars=["Model No", "ProdDate"],
        value_vars='AllInWip',
        var_name='Category',
        value_name='# in WIP'
    )

    # st.dataframe(filtered_melted)
    filtered_melted = filtered_melted.groupby(['ProdDate', 'Model No']).agg({'# in WIP': 'max'}).reset_index()
    filtered_melted = filtered_melted.rename(columns={'AllInWip': '# in WIP'})

    list_models = df_product_data["Model No"].dropna().unique().tolist()
    ms_models_omit = st.multiselect(
        label="Select Model(s) to omit from graph",
        options=list_models,
        key="multiselect_omit_models",
        help="Select some Models that you want to exclude from the dataset.",
        on_change=multiselect_models_omit_on_change
    )
    models_to_omit = st.session_state.get("multiselect_omit_models", list())
    filtered_melted = filtered_melted.loc[~filtered_melted["Model No"].isin(classes_to_omit)]

    # st.dataframe(filtered_melted)
    chart = px.bar(
        filtered_melted,
        x="ProdDate",
        y="# in WIP",
        # hover_data="HoverData",
        title="# Units in WIP By Model",
        barmode='group',
        color="Model No",
        labels={
            'ProdDate': 'Production Date (Month Year)'
        },
        height=700
        # trendline="ols"
    )
    st.plotly_chart(chart, theme=None, use_container_width=True)

    df_show_jobs_in_wip: pd.DataFrame = df_jobs_in_wip.loc[
        (~df_jobs_in_wip["Model No"].isin(classes_to_omit))
        & (df_jobs_in_wip["Date"] >= date_to_datetime(di_start))
        & (df_jobs_in_wip["Date"] <= date_to_datetime(di_end))
        ]
    # st.dataframe(df_show_jobs_in_wip, use_container_width=True)
    # st.dataframe(df_margin_data, use_container_width=True)
    df_show_jobs_in_wip = df_show_jobs_in_wip.merge(
        df_margin_data,
        how="inner",
        left_on=["WO#", "Date"],
        right_on=["WO#", "ActCompleteDate_d"],
        suffixes=("_a", "_b")
    )
    df_show_jobs_in_wip.drop(columns=["Model No_a"], inplace=True)
    df_show_jobs_in_wip.rename(columns={"Model No_b": "Model No"}, inplace=True)
    st.dataframe(df_show_jobs_in_wip, use_container_width=True, hide_index=True)

    df_valuation_model = df_show_jobs_in_wip[[
        "ProdDate",
        "Model No",
        "WO#",
        "MatCost_#",
        "OrderBasePrice_#",
        "SumOfLabourAct_#",
        "SalePriceCDN_#",
        "MarginCDN%_%"
    ]]
    df_valuation_model["ModelCount"] = 0
    df_valuation_model_counts = df_valuation_model.groupby(
        ['ProdDate', 'Model No']
    ).agg({'ModelCount': 'count'}).reset_index()
    df_valuation_model = df_valuation_model.merge(
        df_valuation_model_counts[[
            "ProdDate",
            "Model No",
            "ModelCount"
        ]],
        on=['ProdDate', 'Model No'],
        how='left'
    )
    df_valuation_model.drop(columns=["ModelCount_x"], inplace=True)
    df_valuation_model.rename(columns={"ModelCount_y": "ModelCount"}, inplace=True)

    # st.write("Here")
    # st.dataframe(df_valuation_class_counts)
    # st.dataframe(df_valuation_class)
    filtered_melted = df_valuation_model.melt(
        id_vars=["Model No", "ProdDate", "ModelCount"],
        value_vars=["MatCost_#", "OrderBasePrice_#", "SumOfLabourAct_#", "SalePriceCDN_#"],
        var_name='Category',
        value_name='$ in WIP'
    )
    # models_to_omit = st.session_state.get("multiselect_omit_models", list())
    filtered_melted = filtered_melted.loc[~filtered_melted["Model No"].isin(classes_to_omit)]
    # st.dataframe(filtered_melted)
    filtered_melted = filtered_melted.groupby(
        ['ProdDate', 'Model No', 'Category', "ModelCount"]
    ).agg({'$ in WIP': 'sum'}).reset_index()
    # st.write("A")
    # st.dataframe(filtered_melted)
    filtered_melted["HoverData"] = filtered_melted.apply(lambda row: f"{row['ModelCount']} x {row['Model No']}", axis=1)

    # st.write("C")
    # st.dataframe(filtered_melted)
    chart = px.bar(
        filtered_melted,
        x="ProdDate",
        y="$ in WIP",
        # hover_data="HoverData",
        title="Valuation $ Units in WIP By Model",
        barmode='group',
        color="Category",
        labels={
            'ProdDate': 'Production Date (Month Year)'
        },
        height=700
        # trendline="ols"
        , hover_data=["HoverData"]
    )
    chart.update_xaxes(type='category')
    st.plotly_chart(chart, theme=None, use_container_width=True)
