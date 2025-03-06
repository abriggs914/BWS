import datetime
import os
from typing import Any

import pdfplumber
import pyautogui
from streamlit_pdf_viewer import pdf_viewer

import streamlit as st
import altair as alt

from colour_utility import Colour
from datetime_utility import date_to_datetime
from pyodbc_connection import connect
import pandas as pd

from streamlit_extras.dataframe_explorer import dataframe_explorer
import plotly.figure_factory as ff
import plotly.express as px
from streamlit_extras.add_vertical_space import add_vertical_space
from streamlit_agraph import agraph, Node, Config, Edge
from utility import money, percent

###########
# CONSTANTS
###########


colour_node_op = Colour("#1277CC")
colour_node_part_needed = Colour("#CC1212")
colour_node_part_complete = Colour("#77CC12")
colour_node_part_subs_needed = Colour("#CC1212").darken(0.35)
colour_node_part_subs_complete = Colour("#FFF712")
size_node_op = 60
size_node_part = 25
size_node_part_sub = 15


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


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_parts_subs_data_bws():
    sql = ("""
SELECT
	[Src].*,
	[JM].[Job],
	[JM].[StockCode] AS [SubStockCode],
	[JM].[StockDescription] AS [SubStockDescription],
	[JM].[Warehouse] AS [SubWareHouse],
	[JM].[QtyIssued] AS [SubQtyIssued],
	[JM].[UnitCost] AS [SubUnitCost],
	[JM].[ValueIssued] AS [SubValueIssued],
	[JM].[ValueBilled] AS [SubValueBilled],
	[JM].[AllocCompleted] AS [SubAllocCompleted],
	[JP].[TrnDate]
FROM (
	SELECT
		ISNULL([PR].[Prod Date], [PR].[Prod Date2]) AS [DateProduction],
		[O].[WO#],
		[O].[Quote#],
		[P].[Model No],
		[D].[COMPANY NAME],
		[JM].[StockCode],
		[JM].[StockDescription],
		[JM].[OperationOffset],
		[JM].[QtyIssued],
		[JM].[UnitCost],
		[JM].[ValueIssued],
		[JM].[ValueBilled],
		(CASE WHEN ISNULL([JM].[AllocCompleted], 'N') = 'Y' THEN 1 ELSE 0 END) AS [Complete]
	FROM
		[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
	INNER JOIN
		[SysproCompanyA].[dbo].[WipJobAllMat] [JM] WITH (NOLOCK)
	ON
		CAST([O].[WO#] AS NVARCHAR(250)) = [JM].[Job]
	INNER JOIN
		[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
	ON
		[O].[ProductID] = [P].[IDTrailer]
	INNER JOIN
		[BWSdb].[dbo].[Dealers] [D] WITH (NOLOCK)
	ON
		[O].[DealerID] = [D].[ID]
	LEFT JOIN
		[BWSdb].[dbo].[Production] [PR] WITH (NOLOCK)
	ON
		[O].[WO#] = [PR].[WO#]
	WHERE
		([O].[WO#] IS NOT NULL)
		AND ([O].[Decline/Rejected] = 4)
) AS [Src]
INNER JOIN
	[SysproCompanyA].[dbo].[WipJobAllMat] [JM]
ON
	([Src].[StockCode] = [JM].[Job])
	AND ([Src].[OperationOffset] = [JM].[OperationOffset])
LEFT JOIN
	[SysproCompanyA].[dbo].[WipJobPost] [JP]
ON
	(CAST([Src].[WO#] AS NVARCHAR(250)) = [JP].[Job])
	AND ([JM].[StockCode] = [JP].[MStockCode])
        """).strip()
    connection_data = {
        "sql": sql,
        "database": "bwsdb",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect(**connection_data)


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_parts_data_bws():
    sql = ("""
SELECT
	ISNULL([PR].[Prod Date], [PR].[Prod Date2]) AS [DateProduction],
	[O].[WO#],
	[O].[Quote#],
	[P].[Model No],
	[D].[COMPANY NAME],
	[JM].[StockCode],
	[JM].[StockDescription],
	[JM].[OperationOffset],
	[JM].[QtyIssued],
	[JM].[UnitCost],
	[JM].[ValueIssued],
	[JM].[ValueBilled],
	(CASE WHEN ISNULL([JM].[AllocCompleted], 'N') = 'Y' THEN 1 ELSE 0 END) AS [Complete],
	[JP].[TrnDate]
FROM
	[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
INNER JOIN
	[SysproCompanyA].[dbo].[WipJobAllMat] [JM] WITH (NOLOCK)
ON
	CAST([O].[WO#] AS NVARCHAR(250)) = [JM].[Job]
INNER JOIN
	[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
ON
	[O].[ProductID] = [P].[IDTrailer]
INNER JOIN
	[BWSdb].[dbo].[Dealers] [D] WITH (NOLOCK)
ON
	[O].[DealerID] = [D].[ID]
LEFT JOIN
	[BWSdb].[dbo].[Production] [PR] WITH (NOLOCK)
ON
	[O].[WO#] = [PR].[WO#]
LEFT JOIN
	[SysproCompanyA].[dbo].[WipJobPost] [JP]
ON
	(CAST([O].[WO#] AS NVARCHAR(250)) = [JP].[Job])
	AND 
	([JM].[StockCode] = [JP].[MStockCode])
WHERE
	([O].[WO#] IS NOT NULL)
	AND ([O].[Decline/Rejected] = 4)
    """).strip()
    connection_data = {
        "sql": sql,
        "database": "bwsdb",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect(**connection_data)


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_access_events():
    sql = ("""
SELECT
    *
FROM
    [BWSdb].[dbo].[ADG Events]
;
""").strip()
    connection_data = {
        "sql": sql,
        "database": "bwsdb",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect(**connection_data)


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_walk_part_standards():
    path = r"\\server4.bwsdomain.local\Design\DRAWINGS\STANDARDS"
    return list(os.walk(path))


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_walk_part_pdfs():
    path = r"\\server4.bwsdomain.local\Design\VaultWorkspace_BWS\PDFS"
    return list(os.walk(path))


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_pdf(path: str):
    with open(path, "rb") as f:
        return f.read()



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


def update_ms(key):
    if key not in st.session_state:
        return
    val = st.session_state.get(key, list())
    print(f"{key=}, {val=}")

    gather_graph_top_forms()


def check_ms_inputs() -> list[list[str]]:

    users = st.session_state.get("ms_user_choice", ms_data["ms_user_choice"]["default"])
    dbs = st.session_state.get("ms_db_choice", ms_data["ms_db_choice"]["default"])
    start_forms = st.session_state.get("ms_start_form_choice", ms_data["ms_start_form_choice"]["default"])
    controls = st.session_state.get("ms_ctl_choice", ms_data["ms_ctl_choice"]["default"])
    dest_forms = st.session_state.get("ms_dest_form_choice", ms_data["ms_dest_form_choice"]["default"])

    # for k, v in st.session_state.items():
    #     print(f"{k=}, {v=}")

    if "All" in users:
        users = [v for v in df_access_events[
            ms_data["ms_user_choice"]["df_key"]
        ].drop_duplicates().dropna().sort_values().values.tolist() if v]
    if "All" in dbs:
        dbs = [v for v in df_access_events[
            ms_data["ms_db_choice"]["df_key"]].drop_duplicates().dropna().sort_values().values.tolist() if v]
    if "All" in start_forms:
        start_forms = [v for v in df_access_events[
            ms_data["ms_start_form_choice"]["df_key"]].drop_duplicates().dropna().sort_values().values.tolist() if v]
    if "All" in controls:
        controls = [v for v in df_access_events[
            ms_data["ms_ctl_choice"]["df_key"]].drop_duplicates().dropna().sort_values().values.tolist() if v]
    if "All" in dest_forms:
        dest_forms = [v for v in df_access_events[
            ms_data["ms_dest_form_choice"]["df_key"]].drop_duplicates().dropna().sort_values().values.tolist() if v]

    return [users, dbs, start_forms, controls, dest_forms]


def gather_graph_top_forms() -> pd.DataFrame:
    global df_graph_top_forms

    lists = check_ms_inputs()
    users, dbs, start_forms, controls, dest_forms = lists
    if not all(lists):
        df_graph_top_forms = pd.DataFrame()
        print(f"EMPTYING")
    else:
        df_graph_top_forms = df_access_events.loc[
            (df_access_events["WindowsUser"].isin(users))
            & (df_access_events["AccessDB"].isin(dbs))
            & (df_access_events["FormAccessed"].isin(start_forms))
            & (df_access_events["CtlCaption"].isin(controls))
            & (df_access_events["DestinationForm"].isin(dest_forms))
        ]
        print(f"FILLING")
        print(f"{df_graph_top_forms}")

        df_graph_top_forms = df_graph_top_forms["DestinationForm"].value_counts().reset_index()
        df_graph_top_forms.columns = ["DestinationForm", "Count"]
        df_graph_top_forms.sort_values(by="Count", ascending=False, inplace=True)
        print(f"{df_graph_top_forms=}")

    return df_graph_top_forms


def gather_graph_top_users():
    global df_graph_top_users

    lists = check_ms_inputs()
    users, dbs, start_forms, controls, dest_forms = lists
    if not all(lists):
        df_graph_top_users = pd.DataFrame()
        print(f"EMPTYING")
    else:
        df_graph_top_users = df_access_events.loc[
            (df_access_events["WindowsUser"].isin(users))
            & (df_access_events["AccessDB"].isin(dbs))
            & (df_access_events["FormAccessed"].isin(start_forms))
            & (df_access_events["CtlCaption"].isin(controls))
            & (df_access_events["DestinationForm"].isin(dest_forms))
        ]
        print(f"FILLING")
        print(f"{df_graph_top_users=}")

        df_graph_top_users = df_graph_top_users["WindowsUser"].value_counts().reset_index()
        df_graph_top_users.columns = ["WindowsUser", "Count"]
        df_graph_top_users.sort_values(by="Count", ascending=False, inplace=True)
        print(f"{df_graph_top_users=}")

    return df_graph_top_users


def update_date_range(start_date=None, end_date=None):
    n = datetime.datetime.now().date()
    dr = st.session_state.get("date_range", (n + datetime.timedelta(days=-365), n))
    dr = list(map(lambda ts: ts.date() if isinstance(ts, pd.Timestamp) else ts, dr))
    # n = pd.Timestamp(datetime.datetime.now())
    # dr = st.session_state.get("date_range", (n + datetime.timedelta(days=-365), n))
    if start_date is None:
        start_date = dr[0]
    if end_date is None:
        end_date = dr[1]

    # start_date, end_date = list(map(lambda ts: ts.date(), [start_date, end_date]))
    start_date, end_date = min(start_date, end_date), max(start_date, end_date)

    # # if start_date + pd.DateOffset(years=1) < max_date:
    # if start_date + datetime.timedelta(days=365) < max_date:
    #     end_date = min(start_date + datetime.timedelta(days=1), max_date)
    #     # end_date = min(start_date + pd.DateOffset(years=1), max_date)
    # else:
    #     end_date = max_date
    # if (end_date - start_date).days > 365:
    #     if
    #     end_date =
    print(f"UPD {start_date=}, {end_date=}, {dr=}")
    print(f"{sl_start_date=}, {sl_end_date=}")
    st.session_state.date_range = (sl_start_date, sl_end_date)
    return start_date, end_date


def load_part_standard(part_num: str | list[str]):
    found_files = []
    ff_n = []
    part_nums = [part_num] if not isinstance(part_num, list) else part_num
    for dir_path, dir_names, file_names in load_walk_part_standards():
        for i, file_ in enumerate(file_names):
            file = file_.upper()
            for j, pn in enumerate(part_nums):
                if pn.upper() in file:
                    if file_ not in ff_n:
                        found_files.append((dir_path, file_))
                        ff_n.append(file_)
    return found_files


def load_part_drawing(part_num: str | list[str]):
    found_files = []
    ff_n = []
    part_nums = [part_num] if not isinstance(part_num, list) else part_num
    for dir_path, dir_names, file_names in load_walk_part_pdfs():
        for i, file_ in enumerate(file_names):
            file = file_.upper()
            for j, pn in enumerate(part_nums):
                if pn.upper() in file:
                    if file_ not in ff_n:
                        found_files.append((dir_path, file_))
                        ff_n.append(file_)
    return found_files


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
#         Plotly.newPlot('plotly-chart', fig.path_data, fig.layout);
#
#         // Capture plotly_click event
#         document.getElementById('plotly-chart').on('plotly_click', function(path_data) {{
#             const point = path_data.points[0];
#             const clickedData = {{
#                 x: point.x,
#                 y: point.y,
#                 group: point.path_data.name
#             }};
#             // Send clicked path_data back to Streamlit using custom event
#             window.parent.postMessage(clickedData, "*");
#         }});
#     </script>
# """
#
# # Use st.components.v1.html to embed the HTML and JavaScript
# # clicked_data = components.html(html_code, height=600, scrolling=True)
# clicked_data = components.html(html_code, height=600, scrolling=True)
#
# # Receive the clicked path_data from the JavaScript custom event
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


with st.expander(
    label=":new: Parts Per Job"
):
    df_parts_data = load_parts_data_bws()
    df_parts_subs = load_parts_subs_data_bws()
    df_parts_data.rename(
        columns={
            "WO#": "WO",
            "OperationOffset": "Operation",
            "MStockCode": "StockCode"
        },
        inplace=True
    )
    df_parts_subs.rename(
        columns={
            "WO#": "WO",
            "OperationOffset": "Operation",
            "MStockCode": "StockCode"
        },
        inplace=True
    )
    df_parts_data.sort_values(by="DateProduction", ascending=False, inplace=True)

    st.write("### Newest 10 Jobs:")
    stdf_parts_data = st.dataframe(
        data=df_parts_data.head(10)
    )
    list_jobs = df_parts_data["WO"].dropna().unique()

    selectbox_job = st.selectbox(
        label="Choose a Job:",
        options=list_jobs
    )

    options_hierarchy = ["Operation", "Date"]
    selectbox_hierarchy = st.selectbox(
        label="Hierarchy Mode:",
        options=options_hierarchy
    )

    toggle_incomplete_jobs_only = st.toggle(
        label="Incomplete Issued Parts Only?"
    )

    toggle_node_size_by_part_cost = st.toggle(
        label="Size Nodes by Part Cost Totals?"
    )

    toggle_agraph_physics = st.toggle(
        label="Physics?"
    )

    edges = []
    op_nodes = []
    part_nodes = []
    part_subs_nodes = []
    if selectbox_job:

        df_job_parts = df_parts_data.loc[df_parts_data["WO"] == selectbox_job]
        df_job_parts_subs = df_parts_subs.loc[
            df_parts_subs["WO"] == selectbox_job
        ]
        list_operations = sorted(list(map(int, df_job_parts["Operation"].dropna().unique())))

        if toggle_incomplete_jobs_only:
            df_job_parts = df_job_parts.loc[
                pd.isna(df_job_parts["Complete"])
                | (df_job_parts["Complete"] == 0)
            ]

        df_job_parts["OpNode"] = None
        df_job_parts["OpPartNode"] = None
        df_job_parts["MinDateOpUse"] = None
        df_job_parts["TotalPartCostOp"] = None
        df_job_parts_subs["TotalPartCostOp"] = None

        # Temporary 'Constants' relevant to this job
        min_date = df_job_parts["TrnDate"].min()  # first transaction date
        max_date = df_job_parts["TrnDate"].max() + datetime.timedelta(days=1)  # last transaction date

        if pd.isna(min_date):
            min_date = pd.Timestamp.now()
        if pd.isna(max_date):
            max_date = pd.Timestamp.now() + pd.Timedelta(days=1)

        total_cost_job_parts = df_job_parts["ValueBilled"].sum()  # total part cost across all operations
        total_cost_job_parts_subs = df_job_parts_subs["ValueBilled"].sum()  # total part cost across all sub jobs

        # st.write(f"{min_date=}, {max_date=}, {(max_date - min_date).days}")
        # st.write("df_job_parts")
        # st.write(df_job_parts)

        # When hierarchy mode in 'Date' mode, use this dict to determine the node's level
        date_2_level = {
            # use 3 levels for each operation needed (Op, Parts, Subs).
            pd.to_datetime(min_date + datetime.timedelta(days=i)): [3 * i, (3 * i) + 1, (3 * i) + 2]
            for i in range((max_date - min_date).days)
        }

        # DF to store the first date an operation had a transaction
        df_min_op_use: pd.DataFrame = df_job_parts.groupby(
            by=["Operation"]
        ).agg({"TrnDate": "min"}).rename(
            columns={"TrnDate": "MinDateOpUse"}
        ).reset_index()
        df_min_op_use["OG_MinDateOpUse"] = df_min_op_use["MinDateOpUse"]
        df_min_op_use["MinDateOpUse"].replace(
            pd.NaT,
            max_date + datetime.timedelta(days=-1),
            inplace=True
        )
        df_min_op_use.sort_values(
            by="Operation",
            inplace=True
        )

        # DF to store the total part cost for each operation.
        df_job_part_cost_by_op: pd.DataFrame = df_job_parts.groupby(
            by="Operation"
        ).agg({"ValueIssued": "sum"}).rename(
            columns={"ValueIssued": "TotalPartCostOp"}
        ).reset_index()
        max_part_cost_op = df_job_part_cost_by_op["TotalPartCostOp"].max()
        if max_part_cost_op == 0:
            # prevent division by 0
            max_part_cost_op = 1

        df_job_part_sub_cost_by_op: pd.DataFrame = df_job_parts_subs.groupby(
            by="Operation"
        ).agg({"ValueIssued": "sum"}).rename(
            columns={"ValueIssued": "TotalPartCostOp"}
        ).reset_index()
        max_part_cost_subs_op = df_job_part_sub_cost_by_op["TotalPartCostOp"].max()
        if max_part_cost_subs_op == 0:
            # prevent division by 0
            max_part_cost_subs_op = 1

        # When using cost-based sizing for nodes, use this DF to determine node size.
        min_node_size = 200
        max_node_size = 1000
        df_job_part_cost_by_op["NodeSize"] = ((df_job_part_cost_by_op["TotalPartCostOp"] / max_part_cost_op) * (max_node_size - min_node_size)) + min_node_size
        df_job_part_sub_cost_by_op["NodeSize"] = ((df_job_part_sub_cost_by_op["TotalPartCostOp"] / max_part_cost_subs_op) * (max_node_size - min_node_size)) + min_node_size

        # Report
        st.subheader(f"WO# {selectbox_job}")
        st.write(f"Total Part Cost: :red[{money(total_cost_job_parts)}]")
        st.write(f"Total Part Subs Cost: :red[{money(total_cost_job_parts_subs)}]")

        # cc = st.columns(2)
        # with cc[0]:
        #     st.write("df_job_part_cost_by_op")
        #     st.write(df_job_part_cost_by_op)
        # with cc[1]:
        #     st.write("df_job_part_sub_cost_by_op")
        #     st.write(df_job_part_sub_cost_by_op)

        if selectbox_hierarchy == options_hierarchy[1]:
            # Date

            config = Config(
                physics=toggle_agraph_physics,
                hierarchical=True,
                direction="LR",
                width=1200,
                height=1600,
                # groups=[1, 2, 3],
                collapsible=True,
                interaction={
                    "selectable": True,
                    "dragNodes": False,
                    "dragView": True,
                    "zoomView": True
                }
            )
            get_level = lambda date_, lvl=0: date_2_level[date_][lvl]

            # # st.write(f"{min_date=}, {max_date=}")
            # # st.write(date_2_level)
            #
            # # st.write("df_min_op_use")
            # # st.write(df_min_op_use)
            #
            # i_c = 0
            # for i, row in df_min_op_use.iterrows():
            #     if pd.isna(row["OG_MinDateOpUse"]):
            #         date_str = "N/A"
            #     else:
            #         date_str = f"{row['MinDateOpUse']:%x}"
            #     op_nodes.append(Node(
            #         id=f"node_part_{i}",
            #         title=f"{int(row['Operation'])} - {date_str}",
            #         size=size_node_op,
            #         level=date_2_level[row["MinDateOpUse"]][0],
            #         color=colour_node_op.hex_code
            #     ))
            #     if i_c > 0:
            #         edges.append(Edge(
            #             source=op_nodes[-2].id,
            #             target=op_nodes[-1].id,
            #             title=f"{i=}"
            #         ))
            #     i_c += 1
            # node_ids = [node.id for node in op_nodes]
            #
            # for i, op_node_id in enumerate(zip(list_operations, node_ids)):
            #     op, node_id = op_node_id
            #     df_op_parts = df_job_parts.loc[df_job_parts["Operation"] == op]
            #     df_op_parts_subs = df_job_parts_subs.loc[
            #         df_job_parts_subs["Operation"] == op
            #     ]
            #     if toggle_incomplete_jobs_only:
            #         df_op_parts_subs = df_op_parts_subs.loc[
            #             pd.isna(df_op_parts_subs["SubAllocCompleted"])
            #             | (df_op_parts_subs["SubAllocCompleted"] == 0)
            #         ]
            #     # st.write(f"#### {i=}, {op=}")
            #     # st.write(df_op_parts)
            #     # st.write(df_op_parts_subs)
            #     for j, row in df_op_parts.iterrows():
            #         complete = row["Complete"]
            #         date = row["TrnDate"]
            #         date = max_date + datetime.timedelta(days=-1) if pd.isna(date) else date
            #         if pd.isna(row["TrnDate"]):
            #             date_str = "N/A"
            #         else:
            #             date_str = f"{row['TrnDate']:%x}"
            #         part_nodes.append(Node(
            #             id=f"node_part_{i}_{j}",
            #             title=f"{row['StockCode']} - {row['StockDescription']} - {date_str}",
            #             size=size_node_part,
            #             color=(colour_node_part_complete if complete else colour_node_part_needed).hex_code
            #             ,
            #             # level=op
            #             # level=max(0, 2*(i-1)) + 1
            #             # level=2*(i-1)
            #             level=date_2_level[date][1]
            #             # group=2 if complete else 1
            #         ))
            #         edges.append(Edge(
            #             source=part_nodes[-1].id,
            #             target=node_id,
            #             title=f"({i=}, {j=})"
            #         ))
            #         df_job_parts.loc[j, "OpNode"] = node_id
            #         df_job_parts.loc[j, "OpPartNode"] = part_nodes[-1].id
            #
            #     for j, row in df_op_parts_subs.iterrows():
            #         complete = row["Complete"]
            #         parent_job = row["Job"]
            #         date = row["TrnDate"]
            #         if pd.isna(row["TrnDate"]):
            #             date_str = "N/A"
            #         else:
            #             date_str = f"{row['MinDateOpUse']:%x}"
            #         df_job_sub_part = df_job_parts.loc[
            #             (df_job_parts["WO"] == selectbox_job)
            #             & (df_job_parts["StockCode"] == parent_job)
            #         ]
            #         # st.write(f"SUBS {i=}, {j=}")
            #         # st.write(df_job_sub_part)
            #         part_node_id = df_job_sub_part.iloc[0]["OpPartNode"]
            #         # st.write(f"{part_node_id=}")
            #         part_subs_nodes.append(Node(
            #             id=f"node_part_sub_{i}_{j}",
            #             title=f"{row['SubStockCode']} - {row['SubStockDescription']} - {date_str}",
            #             size=size_node_part_sub,
            #             color=(colour_node_part_subs_complete if complete else colour_node_part_subs_needed).hex_code
            #             ,
            #             # level=op
            #             # level=max(0, 2*(i-1)) + 1
            #             # level=2*(i-1)
            #             level=date_2_level[date][2]
            #             # group=2 if complete else 1
            #         ))
            #         edges.append(Edge(
            #             source=part_subs_nodes[-1].id,
            #             target=part_node_id,
            #             title=f"({i=}, {j=})"
            #         ))

        else:

            # op_nodes = [
            #     Node(
            #         id=f"node_op_{op}",
            #         title=f"{op}",
            #         size=size_node_op,
            #         color=colour_node_op.hex_code
            #         ,
            #         level=3*i,
            #         # group=0
            #     )
            #     for i, op in enumerate(list_operations)
            # ]
            # node_ids = [node.id for node in op_nodes]
            #
            # edges = [
            #     Edge(
            #         source=op_nodes[i].id,
            #         target=op_nodes[i+1].id
            #     )
            #     for i in range(len(op_nodes) - 1)
            # ]

            config = Config(
                physics=toggle_agraph_physics,
                hierarchical=True,
                # direction="LR",
                width=1200,
                height=1600,
                # groups=[1, 2, 3],
                collapsible=True
            )
            get_level = lambda op_num_, lvl=0: (op_num_ * 3) + lvl

            # # st.write("node_ids")
            # # st.write(node_ids)
            #
            # for i, op_node_id in enumerate(zip(list_operations, node_ids)):
            #     op, node_id = op_node_id
            #     df_op_parts = df_job_parts.loc[df_job_parts["Operation"] == op]
            #     df_op_parts_subs = df_job_parts_subs.loc[
            #         (df_job_parts_subs["WO"] == selectbox_job)
            #         & (df_job_parts_subs["Operation"] == op)
            #     ]
            #     if toggle_incomplete_jobs_only:
            #         df_op_parts_subs = df_op_parts_subs.loc[
            #             pd.isna(df_op_parts_subs["SubAllocCompleted"])
            #             | (df_op_parts_subs["SubAllocCompleted"] == 0)
            #         ]
            #     # st.write(f"#### {i=}, {op=}")
            #     # st.write(df_op_parts)
            #     # st.write(df_op_parts_subs)
            #     for j, row in df_op_parts.iterrows():
            #         complete = row["Complete"]
            #         part_nodes.append(Node(
            #             id=f"node_part_{i}_{j}",
            #             title=f"{row['StockCode']} - {row['StockDescription']}",
            #             size=size_node_part,
            #             color=(colour_node_part_complete if complete else colour_node_part_needed).hex_code
            #             ,
            #             # level=op
            #             # level=max(0, 2*(i-1)) + 1
            #             # level=2*(i-1)
            #             level=(3*i)+1
            #             # group=2 if complete else 1
            #         ))
            #         edges.append(Edge(
            #             source=part_nodes[-1].id,
            #             target=node_id,
            #             title=f"({i=}, {j=})"
            #         ))
            #         df_job_parts.loc[j, "OpNode"] = node_id
            #         df_job_parts.loc[j, "OpPartNode"] = part_nodes[-1].id
            #
            #     for j, row in df_op_parts_subs.iterrows():
            #         complete = row["Complete"]
            #         parent_job = row["Job"]
            #         df_job_sub_part = df_job_parts.loc[
            #             (df_job_parts["WO"] == selectbox_job)
            #             & (df_job_parts["StockCode"] == parent_job)
            #         ]
            #         # st.write(f"SUBS {i=}, {j=}")
            #         # st.write(df_job_sub_part)
            #         part_node_id = df_job_sub_part.iloc[0]["OpPartNode"]
            #         # st.write(f"{part_node_id=}")
            #         part_subs_nodes.append(Node(
            #             id=f"node_part_sub_{i}_{j}",
            #             title=f"{row['SubStockCode']} - {row['SubStockDescription']}",
            #             size=size_node_part_sub,
            #             color=(colour_node_part_subs_complete if complete else colour_node_part_subs_needed).hex_code
            #             ,
            #             # level=op
            #             # level=max(0, 2*(i-1)) + 1
            #             # level=2*(i-1)
            #             level=(3 * i) + 2
            #             # group=2 if complete else 1
            #         ))
            #         edges.append(Edge(
            #             source=part_subs_nodes[-1].id,
            #             target=part_node_id,
            #             title=f"({i=}, {j=})"
            #         ))

        # # if toggle_node_size_by_part_cost:
        # get_size = lambda node_type_id, op_num: \
        #     df_job_part_cost_by_op.loc[
        #         df_job_part_cost_by_op["Operation"] == op_num
        #     ].iloc[0]["NodeSize"] \
        #         if toggle_node_size_by_part_cost else \
        #         [size_node_op, size_node_part, size_node_part_sub][node_type_id]
        # # else:
        # #     get_size = 10

        def get_size(node_type_id, op_num, part_num=None):
            if toggle_node_size_by_part_cost:
                sr_job_part_cost_by_op = df_job_part_cost_by_op.loc[
                    df_job_part_cost_by_op["Operation"] == op_num
                ].iloc[0]
                if node_type_id == 0:
                    # Node
                    return sr_job_part_cost_by_op["NodeSize"]
                else:
                    max_part_cost_op = sr_job_part_cost_by_op["TotalPartCostOp"].max()
                    part_cost = df_job_parts.loc[df_job_parts["StockCode"] == part_num].iloc[0]["ValueIssued"]
                    if max_part_cost_op == 0:
                        max_part_cost_op = 1
                    p_part_cost = part_cost / max_part_cost_op
                    return sr_job_part_cost_by_op["NodeSize"] * p_part_cost
            else:
                return [size_node_op, size_node_part, size_node_part_sub][node_type_id]

        i_c = 0
        for i, row in df_min_op_use.iterrows():
            op_num = row["Operation"]
            if pd.isna(row["OG_MinDateOpUse"]):
                date_str = "N/A"
            else:
                date_str = f"{row['MinDateOpUse']:%x}"
            total_op_cost = df_job_part_cost_by_op.loc[df_job_part_cost_by_op["Operation"] == op_num].iloc[0]["TotalPartCostOp"]
            date_str = f" - {date_str} -- {money(total_op_cost)}".replace(" - N/A ", " ")
            op_nodes.append(Node(
                id=f"node_op_{i}",
                title=f"{int(op_num)}{date_str}",
                # label=f"{int(op_num)}{date_str}",
                # text=f"{int(op_num)}{date_str}",
                # title="MSN BWS 20250219.pdf",
                # size=size_node_op,
                size=get_size(0, op_num),
                # level=date_2_level[row["MinDateOpUse"]][0],
                level=get_level(row["MinDateOpUse"] if (selectbox_hierarchy == options_hierarchy[1]) else i_c, lvl=0),
                color=colour_node_op.hex_code,
                link=r"U:\Quick files\Junk\MSN STG 20250219.pdf",
                data=r"U:\Quick files\Junk\MSN STG 20250219.pdf",
                path=r"U:\Quick files\Junk\MSN STG 20250219.pdf",
                metadata=r"U:\Quick files\Junk\MSN STG 20250219.pdf",
                url=r"U:\Quick files\Junk\MSN STG 20250219.pdf"
                # ,
                # title=r"U:\Quick files\Junk\MSN STG 20250219.pdf"
            ))
            if i_c > 0:
                edges.append(Edge(
                    source=op_nodes[-2].id,
                    target=op_nodes[-1].id,
                    title=f"{i=}"
                ))
            i_c += 1
        node_ids = [node.id for node in op_nodes]

        for i, op_node_id in enumerate(zip(list_operations, node_ids)):
            op, node_id = op_node_id
            df_op_parts = df_job_parts.loc[df_job_parts["Operation"] == op]
            df_op_parts_subs = df_job_parts_subs.loc[
                df_job_parts_subs["Operation"] == op
                ]
            if toggle_incomplete_jobs_only:
                df_op_parts_subs = df_op_parts_subs.loc[
                    pd.isna(df_op_parts_subs["SubAllocCompleted"])
                    | (df_op_parts_subs["SubAllocCompleted"] == 0)
                    ]
            # st.write(f"#### {i=}, {op=}")
            # st.write(df_op_parts)
            # st.write(df_op_parts_subs)
            for j, row in df_op_parts.iterrows():
                complete = row["Complete"]
                date = row["TrnDate"]
                date = max_date + datetime.timedelta(days=-1) if pd.isna(date) else date
                if pd.isna(row["TrnDate"]):
                    date_str = "N/A"
                else:
                    date_str = f"{row['TrnDate']:%x}"
                # if toggle_node_size_by_part_cost:
                #     date_str += f" -- {money(df_job_part_cost_by_op.loc[df_job_part_cost_by_op['Operation'] == op].iloc[0]['TotalPartCostOp'])}"
                date_str += f" -- {money(row['ValueIssued' if complete else 'ValueBilled'])}"
                part_nodes.append(Node(
                    id=f"node_part_{i}_{j}",
                    title=f"{row['StockCode']} - {row['StockDescription']} - {date_str}",
                    # size=size_node_part,
                    size=get_size(1, row["Operation"], part_num=row["StockCode"]),
                    color=(colour_node_part_complete if complete else colour_node_part_needed).hex_code
                    ,
                    # level=op
                    # level=max(0, 2*(i-1)) + 1
                    # level=2*(i-1)
                    # level=date_2_level[date][1]
                    level=get_level(date if (selectbox_hierarchy == options_hierarchy[1]) else i, lvl=1)
                    # group=2 if complete else 1
                ))
                edges.append(Edge(
                    source=part_nodes[-1].id,
                    target=node_id,
                    title=f"({i=}, {j=})"
                ))
                df_job_parts.loc[j, "OpNode"] = node_id
                df_job_parts.loc[j, "OpPartNode"] = part_nodes[-1].id

            for j, row in df_op_parts_subs.iterrows():
                complete = row["Complete"]
                parent_job = row["Job"]
                date = row["TrnDate"]
                if pd.isna(row["TrnDate"]):
                    date_str = "N/A"
                    date = max_date + datetime.timedelta(days=-1)
                else:
                    date_str = f"{row['TrnDate']:%x}"
                # if toggle_node_size_by_part_cost:
                #     # date_str += f" -- {money(df_job_part_cost_by_op.loc[df_job_part_cost_by_op['Operation'] == op].iloc[0]['TotalPartCostOp'])}"
                date_str += f" -- {money(row['ValueIssued' if complete else 'ValueBilled'])}"
                df_job_sub_part = df_job_parts.loc[
                    (df_job_parts["WO"] == selectbox_job)
                    & (df_job_parts["StockCode"] == parent_job)
                    ]
                # st.write(f"SUBS {i=}, {j=}")
                # st.write(df_job_sub_part)
                part_node_id = df_job_sub_part.iloc[0]["OpPartNode"]
                # st.write(f"{part_node_id=}")
                part_subs_nodes.append(Node(
                    id=f"node_part_sub_{i}_{j}",
                    title=f"{row['SubStockCode']} - {row['SubStockDescription']} - {date_str}",
                    # size=size_node_part_sub,
                    size=get_size(2, row["Operation"], part_num=row["StockCode"]),
                    color=(colour_node_part_subs_complete if complete else colour_node_part_subs_needed).hex_code
                    ,
                    # level=op
                    # level=max(0, 2*(i-1)) + 1
                    # level=2*(i-1)
                    # level=date_2_level[date][2]
                    level=get_level(date if (selectbox_hierarchy == options_hierarchy[1]) else i, lvl=2)
                    # group=2 if complete else 1
                ))
                edges.append(Edge(
                    source=part_subs_nodes[-1].id,
                    target=part_node_id,
                    title=f"({i=}, {j=})"
                ))

        with st.container(border=1, height=1200):
            nodes = op_nodes + part_nodes + part_subs_nodes
            columns_graph = st.columns([2/3, 1/3])
            with columns_graph[0]:
                if not nodes:
                    st.write("No Nodes!")
                if not edges:
                    st.write("No Edges!")
                graph = agraph(
                    nodes=nodes,
                    edges=edges,
                    config=config
                )
            with columns_graph[1]:
                # st.write("graph")
                # st.write(graph)
                if graph:
                    df_op_node_sel = df_job_parts.loc[
                        (df_job_parts["OpNode"] == graph)
                        | (df_job_parts["OpPartNode"] == graph)
                    ]
                    st.write("df_op_node_sel:")
                    st.dataframe(
                        df_op_node_sel,
                        selection_mode="single-row",
                        hide_index=True
                    )
                    stock_codes = df_op_node_sel["StockCode"].dropna().unique().tolist()
                    standard_drawings = load_part_standard(stock_codes)
                    pdf_drawings = load_part_drawing(stock_codes)
                    # st.write("standard_drawings")
                    # st.write(standard_drawings)
                    if standard_drawings:
                        selectbox_drawing_sel = st.selectbox(
                            label="Choose a drawing",
                            options=[tup[-1] for tup in standard_drawings]
                        )
                        if selectbox_drawing_sel:
                            st.write("selectbox_drawing_sel")
                            st.write(selectbox_drawing_sel)

                            # dwg_path = os.path.join("temp", selectbox_drawing_sel)
                            # dxf_path = dwg_path.replace(".dwg", ".dxf")
                            # stl_path = dwg_path.replace(".dwg", ".stl")
                            #
                            # # Save uploaded file
                            # with open(dwg_path, "wb") as f:
                            #     f.write(uploaded_file.getbuffer())
                            #
                            # # Convert DWG → DXF
                            # dxf_file = convert_dwg_to_dxf(dwg_path, dxf_path)
                            #
                            # if dxf_file:
                            #     # Convert DXF → STL
                            #     stl_file = convert_dxf_to_stl(dxf_file, stl_path)
                            #
                            #     if stl_file:
                            #         st.success("Conversion successful!")
                            #         stl(stl_file, width=500, height=500)  # Display in Streamlit
                            #     else:
                            #         st.error("STL conversion failed.")
                            # else:
                            #     st.error("DXF conversion failed.")

                    # st.write("pdf_drawings")
                    # st.write(pdf_drawings)
                    pdf_options = [tup[-1] for tup in pdf_drawings]
                    if pdf_drawings:
                        selectbox_pdf_sel = st.selectbox(
                            label="Choose a drawing",
                            options=pdf_options
                        )
                        if selectbox_pdf_sel:
                            st.write("selectbox_pdf_sel")
                            st.write(selectbox_pdf_sel)
                            idx = pdf_options.index(selectbox_pdf_sel)
                            path = os.path.join(*pdf_drawings[idx])
                            st_pdf_viewer = pdf_viewer(
                                input=load_pdf(path)
                            )


                else:
                    st.write("Select a Node first.")


with st.expander(":new: Access DB Logs"):
    ms_data = {
        "ms_user_choice": {
            "lbl": "Select User(s):",
            "df_key": "WindowsUser",
            "default": ["All"]
        },
        "ms_db_choice": {
            "lbl": "Select Database(s):",
            "df_key": "AccessDB",
            "default": ["All"]
        },
        "ms_start_form_choice": {
            "lbl": "Select Form(s):",
            "df_key": "FormAccessed",
            "default": ["All"]
        },
        "ms_ctl_choice": {
            "lbl": "Select Control(s):",
            "df_key": "CtlCaption",
            "default": ["All"]
        },
        "ms_dest_form_choice": {
            "lbl": "Select Destination Form(s):",
            "df_key": "DestinationForm",
            "default": ["All"]
        }
    }

    n = pd.Timestamp(datetime.datetime.now())

    # Init session state values
    for key, def_val in {k: v["default"] for k, v in ms_data.items()}.items():
        if not st.session_state.get(key):
            st.session_state.update({key: def_val})
    if not st.session_state.get("date_range"):
        st.session_state.update({"date_range": (n + datetime.timedelta(days=-365), n)})
        # st.session_state.setdefault("date_range", (n + pd.DateOffset(days=-365), n))

    df_access_events = load_access_events()
    df_access_events["WindowsUser"] = df_access_events["WindowsUser"].fillna("").apply(lambda user: user.lower())
    df_access_events["DateCreated"] = pd.to_datetime(df_access_events["DateCreated"])

    dr = st.session_state.get("date_range", (n + datetime.timedelta(days=-365), n))
    # dr = st.session_state.get("date_range", (n + pd.DateOffset(days=-365), n))
    sd, ed = dr
    if not isinstance(sd, pd.Timestamp):
        sd = pd.Timestamp(sd)
    if not isinstance(ed, pd.Timestamp):
        ed = pd.Timestamp(ed)
    print(f"{sd=}, {ed=}")
    first_last_df = df_access_events.loc[
        (sd <= df_access_events["DateCreated"])
        & (df_access_events["DateCreated"] <= ed)
        ].groupby(
        by=[
            df_access_events['WindowsUser'],
            df_access_events['DateCreated'].dt.year.rename("Year"),
            df_access_events['DateCreated'].dt.month.rename("Month"),
            df_access_events['DateCreated'].dt.day.rename("Day")
        ]).agg(
        TimeStart=('DateCreated', 'min'),  # First (earliest) record for the day
        TimeEnd=('DateCreated', 'max')  # Last (latest) record for the day
    ).reset_index()
    # first_last_df["DateCreated"] = pd.to_datetime(first_last_df["DateCreated"])
    print(f"{first_last_df=}")
    with st.container(border=1):
        st.write("first_last_date")
        st.dataframe(first_last_df)

    df_graph_top_forms = gather_graph_top_forms()
    df_graph_top_users = gather_graph_top_users()

    # widget layout map
    layout = {
        "title_row": st.columns(1),
        "input_row": st.columns(1),
        "graph_row": st.columns(1)
    }

    # begin widget creation
    with layout["title_row"][0]:
        with st.container(border=1):
            st.write("Access Events")
            st.dataframe(df_access_events)

    with layout["input_row"][0]:
        for key, data in ms_data.items():
            options = df_access_events[data["df_key"]].drop_duplicates().dropna().sort_values().values.tolist()
            if "All" not in options:
                options.insert(0, "All")
            st.multiselect(
                data["lbl"],
                options=options,
                key=key,
                on_change=lambda key_=key: update_ms(key_)
            )

    with layout["graph_row"][0]:
        st.divider()
        print(f"ENCOUNTERED {df_graph_top_forms.head()=}")
        if df_graph_top_forms.empty:
            st.write("Please choose some valid inputs")
        else:
            st.write(f"Access history for selected inputs:")
            # st.bar_chart(
            #     df_graph_top_forms.set_index("Count"),
            #     # x="DestinationForm",
            #     # y="Count",
            #     y_label="Forms",
            #     x_label="# Accesses"
            # )
            # st.bar_chart(
            #     df_graph_top_forms.set_index("DestinationForm"),
            #     # x="DestinationForm",
            #     # y="Count",
            #     x_label="Forms",
            #     y_label="# Accesses"
            # )
            fig_top_used_forms = px.bar(
                df_graph_top_forms.head(max(5, int(df_graph_top_forms.shape[0] * 0.1))),
                x="DestinationForm",
                y="Count",
                labels={"DestinationForm": "Forms", "Count": "# Accesses"},
                title="Top 10% Used Forms:"
            )
            st.plotly_chart(fig_top_used_forms)
            fig_top_users = px.bar(
                df_graph_top_users.head(max(5, int(df_graph_top_users.shape[0] * 0.1))),
                x="WindowsUser",
                y="Count",
                labels={"WindowsUser": "User", "Count": "# Accesses"},
                title="Top 10% Users:"
            )
            st.plotly_chart(fig_top_users)

    min_date = df_access_events["DateCreated"].min().date()
    max_date = df_access_events["DateCreated"].max().date()
    print(f"{min_date=}, {type(min_date)=}")
    print(f"{max_date=}, {type(max_date)=}")
    print(f"{st.session_state.date_range=}")
    dr = list(map(lambda ts: ts.date() if isinstance(ts, pd.Timestamp) else ts, st.session_state.date_range))
    print(f"PLOTTING {dr=}")
    sl_start_date, sl_end_date = st.slider(
        "Select Date Range",
        min_value=min_date,
        max_value=max_date,
        # value=,
        # key=st.session_state.date_range,
        # value=st.session_state.date_range,
        value=list(map(lambda ts: ts.date() if isinstance(ts, pd.Timestamp) else ts, st.session_state.date_range)),
        format="YYYY-MM-DD",
        on_change=update_date_range
    )

    # Plot using Plotly Express timeline
    fig = px.timeline(
        first_last_df,
        x_start="TimeStart",
        x_end="TimeEnd",
        y="WindowsUser",
        color="WindowsUser",  # Optional: differentiate users by color
        title="User TimeOn Timeline"
    )

    # Update layout to make the timeline more readable
    fig.update_layout(
        xaxis_title="Time",
        yaxis_title="Windows User",
        showlegend=False,
        height=1600
    )

    # Display in Streamlit
    st.plotly_chart(fig)

