from streamlit_utility import display_df, load_pdf_binary, display_df_paginated
from pyodbc_connection import connect
from streamlit_auth import st_auth, show_change_password, save_user_settings, get_user_settings
from datetime_utility import time_between, datetime_is_tz_aware
from utility import percent
from colour_utility import Colour, random_colour, gradient_merge
from json_utility import jsonify
import reportlab_utility as rlu

from streamlit_pills import pills
from streamlit_calendar import calendar
from typing import Literal, Optional

import plotly.express as px
import streamlit as st
import pandas as pd
import numpy as np
import datetime
import asyncio
import json
import math
import os

st.set_page_config(
    layout="wide",
    page_title="Parts"
)


CHANGE_REQUEST_FILE: str = "change_requests.json"
PATH_STOCK_PDFS: str = r"J:\VaultWorkspace_BWS\PDFS"
UTC_FMT: str = "%Y-%m-%dT%H:%M:%SZ"
BUILDING_CODE_BOTH: int = 0
BUILDING_CODE_VMI: int = -2
BUILDING_CODE_HAWKINS: int = 2
BUILDING_CODE_MONTANA: int = 1
BUILDING_CODE_UNKNOWN: int = -99


@st.cache_data(ttl=60*60, show_spinner=True)
def load_bin_location_data() -> pd.DataFrame:
#     sql = """
#
# -- Bin Locations in Duplicate
# -- 2025-12-08
#
# WITH KnownSections AS (
# 	SELECT 0 AS [ID], 'A' AS [Section]
# 	UNION SELECT 1, 'B'
# 	UNION SELECT 2, 'C'
# 	UNION SELECT 3, 'D'
# 	UNION SELECT 4, 'E'
# 	UNION SELECT 5, 'F'
# 	UNION SELECT 6, 'G'
# 	UNION SELECT 7, 'H'
# 	UNION SELECT 8, 'I'
# 	UNION SELECT 9, 'J'
# 	UNION SELECT 10, 'K'
# 	UNION SELECT 11, 'L'
# 	UNION SELECT 12, 'M'
# 	UNION SELECT 13, 'N'
# 	UNION SELECT 14, 'O'
# 	UNION SELECT 15, 'P'
# 	UNION SELECT 16, 'Q'
# 	UNION SELECT 17, 'R'
# 	UNION SELECT 18, 'S'
# 	UNION SELECT 19, 'T'
# 	UNION SELECT 20, 'U'
# 	UNION SELECT 21, 'V'
# 	UNION SELECT 22, 'W'
# 	UNION SELECT 23, 'X'
# 	UNION SELECT 24, 'Y'
# 	UNION SELECT 25, 'Z'
# ),
# BinCounts AS (
# SELECT
# 	[IW].[DefaultBin],
# 	[IW].[Warehouse],
# 	COUNT(*) AS [NumItems],
# 	SUM([IW].[QtyOnHand] * [IW].[LastCostEntered]) AS [TtlItemValue],
# 	(CASE WHEN
# 			(LOWER([IW].[DefaultBin]) = 'vmi')
# 			OR (LOWER([IW].[DefaultBin]) LIKE '%vend%')
# 		THEN -2
# 		WHEN
# 			LOWER([IW].[DefaultBin]) LIKE '%wh4%'
# 		THEN
# 			2 -- Montana Only
# 		WHEN
# 			LOWER([IW].[DefaultBin]) LIKE '%@%'
# 		THEN
# 			0 -- Both
# 		ELSE
# 			1 -- Hawkins Only
# 	END) AS [BuildingCode],
# 	(CASE WHEN
# 			LOWER([IW].[DefaultBin]) LIKE '%/%'
# 		THEN
# 			1 -- Slash divides bins
# 		WHEN
# 			LOWER([IW].[DefaultBin]) LIKE '%@%'
# 		THEN
# 			1 -- @ denotes same bin in another building
# 		ELSE
# 			0 -- Only 1 noted
# 	END) AS [HasMultipleBins],
# 	[KS].[Section] AS [Section]
# FROM
# 	[SysproCompanyA].[dbo].[InvWarehouse] [IW]
# LEFT JOIN
# 	[KnownSections] [KS]
# ON
# 	(CASE WHEN LOWER(LEFT([IW].[DefaultBin], 3)) = 'wh4' THEN (
# 			CASE WHEN LOWER(LEFT(SUBSTRING([IW].[DefaultBin], 4, LEN([IW].[DefaultBin]) - 3), 1)) = LOWER([KS].[Section]) THEN 1 ELSE 0 END
# 		)
# 		WHEN LOWER(LEFT([IW].[DefaultBin], 1)) = LOWER([KS].[Section]) THEN 1
# 		ELSE 0
# 	END) > 0
# GROUP BY
# 	[IW].[DefaultBin],
# 	[IW].[Warehouse],
# 	[KS].[Section]
# )
# SELECT
#     [BC1].[Section],
#     [BC1].[DefaultBin],
#     [BC2].[DefaultBin] AS [BinLike],
# 	[BC1].[Warehouse],
#     [BC1].[NumItems],
#     [BC1].[TtlItemValue],
#     [BC1].[BuildingCode],
#     [BC1].[HasMultipleBins]
# FROM
#     [BinCounts] AS [BC1]
#     LEFT JOIN [BinCounts] AS [BC2]
#         ON  (REPLACE(REPLACE(REPLACE(LOWER([BC1].[DefaultBin]), ' ', ''), '/', ''), '@', '') =
#             REPLACE(REPLACE(REPLACE(LOWER([BC2].[DefaultBin]), ' ', ''), '/', ''), '@', ''))
#         AND (LOWER(BC1.DefaultBin) <> LOWER([BC2].[DefaultBin]))
# 		AND ([BC1].[Warehouse] = [BC2].[Warehouse])
# WHERE
# 	ISNULL([BC1].[DefaultBin], '') <> ''
# """
    sql = """
WITH KnownSections AS (
	SELECT 0 AS [ID], 'A' AS [Section]
	UNION SELECT 1, 'B'
	UNION SELECT 2, 'C'
	UNION SELECT 3, 'D'
	UNION SELECT 4, 'E'
	UNION SELECT 5, 'F'
	UNION SELECT 6, 'G'
	UNION SELECT 7, 'H'
	UNION SELECT 8, 'I'
	UNION SELECT 9, 'J'
	UNION SELECT 10, 'K'
	UNION SELECT 11, 'L'
	UNION SELECT 12, 'M'
	UNION SELECT 13, 'N'
	UNION SELECT 14, 'O'
	UNION SELECT 15, 'P'
	UNION SELECT 16, 'Q'
	UNION SELECT 17, 'R'
	UNION SELECT 18, 'S'
	UNION SELECT 19, 'T'
	UNION SELECT 20, 'U'
	UNION SELECT 21, 'V'
	UNION SELECT 22, 'W'
	UNION SELECT 23, 'X'
	UNION SELECT 24, 'Y'
	UNION SELECT 25, 'Z'
),
BinCounts AS (
SELECT
	[IW].[DefaultBin],
	[IW].[Warehouse],
	COUNT(*) AS [NumItems],
	SUM([IW].[QtyOnHand] * [IW].[LastCostEntered]) AS [TtlItemValue],
	(CASE WHEN 
			(LOWER([IW].[DefaultBin]) = 'vmi')
			OR (LOWER([IW].[DefaultBin]) LIKE '%vend%')
		THEN -2
		WHEN 
			LOWER([IW].[DefaultBin]) LIKE '%wh4%'
		THEN
			2 -- Montana Only
		WHEN
			LOWER([IW].[DefaultBin]) LIKE '%@%'
		THEN 
			0 -- Both
		WHEN 
			(LOWER([IW].[DefaultBin]) = '/') OR (ISNULL([IW].[DefaultBin], '') = '')
		THEN
			-99 -- Unknown
		ELSE
			1 -- Hawkins Only
	END) AS [BuildingCode],
	(CASE WHEN 
			(LEN([IW].[DefaultBin]) > 1) AND (LOWER([IW].[DefaultBin]) LIKE '%/%')
		THEN
			1 -- Slash divides bins
		WHEN
			LOWER([IW].[DefaultBin]) LIKE '%@%'
		THEN 
			1 -- @ denotes same bin in another building
		ELSE
			0 -- Only 1 noted
	END) AS [HasMultipleBins],
	[KS].[Section] AS [Section]
FROM
	[SysproCompanyA].[dbo].[InvWarehouse] [IW]
LEFT JOIN
	[KnownSections] [KS]
ON
	(CASE WHEN LOWER(LEFT([IW].[DefaultBin], 3)) = 'wh4' THEN (
			CASE WHEN LOWER(LEFT(SUBSTRING([IW].[DefaultBin], 4, LEN([IW].[DefaultBin]) - 3), 1)) = LOWER([KS].[Section]) THEN 1 ELSE 0 END
		)
		WHEN LOWER(LEFT([IW].[DefaultBin], 1)) = LOWER([KS].[Section]) THEN 1
		ELSE 0
	END) > 0
GROUP BY
	[IW].[DefaultBin],
	[IW].[Warehouse],
	[KS].[Section]
)
SELECT
    [BC1].[Section],
    [BC1].[DefaultBin],
    [BC2].[DefaultBin] AS [BinLike],
	[BC1].[Warehouse],
    [BC1].[NumItems],
    [BC1].[TtlItemValue],
    [BC1].[BuildingCode],
    [BC1].[HasMultipleBins]
FROM 
    [BinCounts] AS [BC1]
    LEFT JOIN [BinCounts] AS [BC2]
        ON  (REPLACE(REPLACE(REPLACE(LOWER([BC1].[DefaultBin]), ' ', ''), '/', ''), '@', '') =
            REPLACE(REPLACE(REPLACE(LOWER([BC2].[DefaultBin]), ' ', ''), '/', ''), '@', ''))
        AND (LOWER(BC1.DefaultBin) <> LOWER([BC2].[DefaultBin]))
		AND ([BC1].[Warehouse] = [BC2].[Warehouse])
;
    """
    df = connect(sql)
    df.sort_values(
        by=["DefaultBin", "BinLike"],
        ascending=[True, True],
        inplace=True
    )
    return df


@st.cache_data(ttl=60*15, show_spinner=True)
def load_parts_data() -> pd.DataFrame:
    sql = """
SELECT
	[IW].[StockCode],
	[IM].[Description],
	[IM].[LongDesc],
	[IW].[DefaultBin],
	[IM].[StockUom],
	[IW].[Warehouse],
	[IW].[LastCostEntered],
	[IW].[QtyAllocatedToPick],
	[IW].[QtyAllocatedWip],
	[IW].[QtyDispatched],
	[IW].[QtyInInspection],
	[IW].[QtyInTransit],
	[IW].[QtyOnBackOrder],
	[IW].[QtyOnHand],
	[IW].[QtyOnOrder],
	[IW].[QtyWipReserved],
	[IW].[QtyAllocated],
	[AS].[SupShortName]
FROM
	[SysproCompanyA].[dbo].[InvWarehouse] [IW] WITH (NOLOCK)
INNER JOIN
	[SysproCompanyA].[dbo].[InvMaster] [IM] WITH (NOLOCK)
ON
	([IW].[StockCode] = [IM].[StockCode])
	AND ([IW].[Warehouse] = [IM].[WarehouseToUse])
INNER JOIN
	[SysproCompanyA].[dbo].[ApSupplier] [AS] WITH (NOLOCK)
ON
	([IM].[Supplier] = [AS].[Supplier])
"""
    return connect(sql)


@st.cache_data(ttl=60*60, show_spinner=True)
def load_stockcode_movements(stockcode: str) -> pd.DataFrame:
    sql = f"""
SELECT
	[IMdt].[TrnDateTime],
	[IM].[EntryDate],
	[IM].[TrnTime],
	[IM].[StockCode],
	[IM].[Warehouse],
	[IM].[Job],
	[IM].[TrnQty],
	--[IM].[MovementType],
	[IM].[TrnType],
	[IM].[Reference],
	[IM].[SalesOrder]
FROM
	[SysproCompanyA].[dbo].[InvMovements] [IM] WITH (NOLOCK)
LEFT JOIN
	[SysproCompanyA].[dbo].[v_PROD_InvMovementsDateTime] [IMdt] WITH (NOLOCK)
ON
	([IM].[StockCode] = [IMdt].[StockCode])
	AND ([IM].[Warehouse] = [IMdt].[Warehouse])
	AND ([IM].[Journal] = [IMdt].[Journal])
	AND ([IM].[JournalEntry] = [IMdt].[JournalEntry])
	AND ([IM].[TrnYear] = [IMdt].[TrnYear])
	AND ([IM].[TrnMonth] = [IMdt].[TrnMonth])
	AND ([IM].[TrnTime] = [IMdt].[TrnTime])
	AND ([IM].[TrnType] = [IMdt].[TrnType])
WHERE
	LOWER([IM].[StockCode]) = LOWER('{stockcode}')
;
"""
    df = connect(sql)
    # display_df(df, "FETCH MOVEMENTS A")
    # df["MovementType"] = df["MovementType"].apply(lambda mt: "ISSUE" if mt == "I" else ("SALE" if mt == "S" else mt))
    df["TrnType"] = df["TrnType"].apply(lambda mt: "ISSUE" if mt == "I" else ("REC" if mt == "R" else ("ADJ" if mt == "A" else ("SALE" if mt == "S" else mt))))
    df["SalesOrder"] = df["SalesOrder"].apply(lambda so: so_fmt(so, "int"))
    # display_df(df, "FETCH MOVEMENTS B")
    return df


@st.cache_data(ttl=60*60, show_spinner=True)
def load_so_details(stockcode: Optional[str] = None, salesorder: Optional[str] = None) -> pd.DataFrame:
    """
        Load more Sales Order data than the Sales Order Pick Sheet version, but mising formatting.
        Ability to search by StockCode or SalesOrder. When querying with salesorder, the data will exclude StockCode data.
    """

    if ((stockcode is None) and (salesorder is None)) or ((stockcode is not None) and (salesorder is not None)):
        raise ValueError(f"Must pass either a SalesOrder # or a StockCode #. Got '{stockcode=}', '{salesorder=}'.")
    sc_mode: bool = stockcode is not None

    if sc_mode:
        sql = f"""
    SELECT
        [SD].[SalesOrder],
        [SD].[MStockCode],
        [SD].[MOrderUom],
        [SD].[MOrderQty],
        [SD].[MShipQty],
        [SD].[MBackOrderQty],
        [SD].[MPrice],
        [SD].[MDiscPct1],
        [SD].[MDiscPct2],
        [SD].[MDiscPct3],
        [SD].[MCustRequestDat],
        [SM].[ExchangeRate],
        [SM].[OrderDate],
        [SM].[OrderStatus],
        [SM].[ActiveFlag],
        [SM].[CancelledFlag],
        [SM].[LastOperator],
        [SM].[LastInvoice],
        [AC].[Name] AS [Customer],
        [AC].[ShortName],
        [AC].[SoldToAddr1],
        [AC].[SoldToAddr2],
        [AC].[SoldToAddr3],
        [SM].[ShipAddress1],
        [SM].[ShipAddress2],
        [SM].[ShipAddress3],
        [AC].[Contact],
        [AC].[Telephone],
        [AC].[Email],
        [AC].[Nationality],
        [AC].[DateCustAdded],
        [AC].[DateLastSale],
        [AC].[DateLastPay]
    FROM
        [SysproCompanyA].[dbo].[SorDetail] [SD] WITH (NOLOCK)
    INNER JOIN
        [SysproCompanyA].[dbo].[SorMaster] [SM] WITH (NOLOCK)
    ON
        [SD].[SalesOrder] = [SM].[SalesOrder]
    INNER JOIN
        [SysproCompanyA].[dbo].[ArCustomer] [AC] WITH (NOLOCK)
    ON
        [SM].[Customer] = [AC].[Customer]
    WHERE
		(LTRIM(RTRIM(ISNULL([SD].[MStockCode], ''))) <> '')
        AND (LOWER([SD].[MStockCode]) = LOWER('{stockcode}'))
    """
    else:
        sql = f"""
    SELECT
        [SD].[SalesOrder],
        [SD].[MStockCode],
        [SD].[MOrderUom],
        [SD].[MOrderQty],
        [SD].[MShipQty],
        [SD].[MBackOrderQty],
        [SD].[MPrice],
        [SD].[MDiscPct1],
        [SD].[MDiscPct2],
        [SD].[MDiscPct3],
        [SD].[MCustRequestDat],
        [SM].[ExchangeRate],
        [SM].[OrderDate],
        [SM].[OrderStatus],
        [SM].[ActiveFlag],
        [SM].[CancelledFlag],
        [SM].[LastOperator],
        [SM].[LastInvoice],
        [AC].[Name] AS [Customer],
        [AC].[ShortName],
        [AC].[SoldToAddr1],
        [AC].[SoldToAddr2],
        [AC].[SoldToAddr3],
        [SM].[ShipAddress1],
        [SM].[ShipAddress2],
        [SM].[ShipAddress3],
        [AC].[Contact],
        [AC].[Telephone],
        [AC].[Email],
        [AC].[Nationality],
        [AC].[DateCustAdded],
        [AC].[DateLastSale],
        [AC].[DateLastPay]
    FROM
        [SysproCompanyA].[dbo].[SorDetail] [SD] WITH (NOLOCK)
    INNER JOIN
        [SysproCompanyA].[dbo].[SorMaster] [SM] WITH (NOLOCK)
    ON
        [SD].[SalesOrder] = [SM].[SalesOrder]
    INNER JOIN
        [SysproCompanyA].[dbo].[ArCustomer] [AC] WITH (NOLOCK)
    ON
        [SM].[Customer] = [AC].[Customer]
    WHERE
		(LTRIM(RTRIM(ISNULL([SD].[MStockCode], ''))) <> '')
        AND (LOWER([SM].[SalesOrder]) = LOWER('{so_fmt(salesorder, out_type='str')}'))
    """
    df = connect(sql)
    df["SalesOrder"] = df["SalesOrder"].apply(lambda so: so_fmt(so, out_type="int"))
    return df


@st.cache_data(ttl=60*60, show_spinner=True)
def load_po_details(stockcode: Optional[str] = None, purchaseorder: Optional[str] = None) -> pd.DataFrame:

    if ((stockcode is None) and (purchaseorder is None)) or ((stockcode is not None) and (purchaseorder is not None)):
        raise ValueError(f"Must pass either a PurchaseOrder # or a StockCode #. Got '{stockcode=}', '{purchaseorder=}'.")
    sc_mode: bool = stockcode is not None
    if sc_mode:
        sql = """
SELECT
        [PD].[PurchaseOrder],
        [PD].[MStockCode],
        [PD].[MWarehouse],
        [MOrderUom],
        [MOrderQty],
        [MReceivedQty],
        [PD].[MOrigDueDate],
        [PD].[MLatestDueDate],
        [PD].[MLastReceiptDat],
        [PD].[MCompleteFlag],
        [PD].[MPrice],
        [PD].[MDiscPct1],
        [PD].[MDiscPct2],
        [PD].[MDiscPct3],
    
        [PR].[PoDate],
        [PR].[QtyReceived],
        [PR].[PriceReceived],
        [PR].[Currency],
        [PR].[ExchangeRate],
    
        [AS].[SupplierName] AS [Supplier],
        [AS].[SupShortName],
        [AS].[Contact],
        [AS].[Telephone],
        [AS].[Email],
        [AS].[Nationality]
    FROM
        [SysproCompanyA].[dbo].[PorMasterDetail] [PD] WITH (NOLOCK)
    LEFT JOIN (
        SELECT
            [PRs].[PurchaseOrder],
            [PRs].[StockCode],
            [PRs].[Warehouse],
            [PRs].[Supplier],
            [PRs].[Currency],
            [PRs].[ExchangeRate],
            MIN([PRs].[DateReceived]) AS [FirstDateReceived],
            MAX([PRs].[DateReceived]) AS [LastDateReceived],
            [PRs].[PoDate],
            SUM([PRs].[QtyReceived]) AS [QtyReceived],
            SUM([PRs].[PriceReceived]) AS [PriceReceived]
        FROM
            [SysproCompanyA].[dbo].[PorHistReceipt] [PRs] WITH (NOLOCK)
        GROUP BY
            [PRs].[PurchaseOrder],
            [PRs].[StockCode],
            [PRs].[Warehouse],
            [PRs].[Supplier],
            [PRs].[Currency],
            [PRs].[ExchangeRate],
            [PRs].[PoDate]
    ) AS [PR]
    ON
        ([PD].[PurchaseOrder] = [PR].[PurchaseOrder])
        AND ([PD].[MStockCode] = [PR].[StockCode])
        AND ([PD].[MWarehouse] = [PR].[Warehouse])
        AND ([PD].[MLastReceiptDat] = [PR].[LastDateReceived])
    
    LEFT JOIN
        [SysproCompanyA].[dbo].[ApSupplier] [AS] WITH (NOLOCK)
    ON
        [PR].[Supplier] = [AS].[Supplier]
    WHERE
        LOWER([PD].[PurchaseOrder]) = LOWER('{purchasecode}')
;
        """
    else:
        sql = f"""
    SELECT
        [PD].[PurchaseOrder],
        [PD].[MStockCode],
        [PD].[MWarehouse],
        [MOrderUom],
        [MOrderQty],
        [MReceivedQty],
        [PD].[MOrigDueDate],
        [PD].[MLatestDueDate],
        [PD].[MLastReceiptDat],
        [PD].[MCompleteFlag],
        [PD].[MPrice],
        [PD].[MDiscPct1],
        [PD].[MDiscPct2],
        [PD].[MDiscPct3],
    
        [PR].[PoDate],
        [PR].[QtyReceived],
        [PR].[PriceReceived],
        [PR].[Currency],
        [PR].[ExchangeRate],
    
        [AS].[SupplierName] AS [Supplier],
        [AS].[SupShortName],
        [AS].[Contact],
        [AS].[Telephone],
        [AS].[Email],
        [AS].[Nationality]
    FROM
        [SysproCompanyA].[dbo].[PorMasterDetail] [PD] WITH (NOLOCK)
    LEFT JOIN (
        SELECT
            [PRs].[PurchaseOrder],
            [PRs].[StockCode],
            [PRs].[Warehouse],
            [PRs].[Supplier],
            [PRs].[Currency],
            [PRs].[ExchangeRate],
            MIN([PRs].[DateReceived]) AS [FirstDateReceived],
            MAX([PRs].[DateReceived]) AS [LastDateReceived],
            [PRs].[PoDate],
            SUM([PRs].[QtyReceived]) AS [QtyReceived],
            SUM([PRs].[PriceReceived]) AS [PriceReceived]
        FROM
            [SysproCompanyA].[dbo].[PorHistReceipt] [PRs] WITH (NOLOCK)
        GROUP BY
            [PRs].[PurchaseOrder],
            [PRs].[StockCode],
            [PRs].[Warehouse],
            [PRs].[Supplier],
            [PRs].[Currency],
            [PRs].[ExchangeRate],
            [PRs].[PoDate]
    ) AS [PR]
    ON
        ([PD].[PurchaseOrder] = [PR].[PurchaseOrder])
        AND ([PD].[MStockCode] = [PR].[StockCode])
        AND ([PD].[MWarehouse] = [PR].[Warehouse])
        AND ([PD].[MLastReceiptDat] = [PR].[LastDateReceived])
    
    LEFT JOIN
        [SysproCompanyA].[dbo].[ApSupplier] [AS] WITH (NOLOCK)
    ON
        [PR].[Supplier] = [AS].[Supplier]
    WHERE
        LOWER([PD].[PurchaseOrder]) = LOWER('{po_fmt(purchaseorder, "str")}')
;
    """
    df = connect(sql)
    df["PurchaseOrder"] = df["PurchaseOrder"].apply(lambda po: po_fmt(po, "int"))
    return df


@st.cache_data(ttl=60*60, show_spinner=True)
def load_allocations(stockcode: str) -> pd.DataFrame:
    sql = f"""
SELECT
	[JP].[TrnDateTime],
	[JL].[FirstPlannedStartDate] AS [DateRequired],
	[JM].[Job],
	[JM].[StockCode],
	[JM].[Warehouse],
	[JM].[UnitQtyReqd],
	[JM].[UnitCost],
	[JM].[OperationOffset],
	[JM].[OpOffsetFlag],
	[JM].[QtyIssued],
	[JM].[ValueIssued],
	[JM].[NetUnitQtyReqd],
	[JM].[QtyToIssue],
    [JM].[AllocCompleted]
FROM
	[SysproCompanyA].[dbo].[WipJobAllMat] [JM] WITH (NOLOCK)
LEFT JOIN (
	SELECT
		[JP].*,
		[JPdt].[TrnDateTime]
	FROM
		[SysproCompanyA].[dbo].[WipJobPost] [JP] WITH (NOLOCK)
	INNER JOIN
		[SysproCompanyA].[dbo].[v_PROD_WipJobPostDateTime] [JPdt] WITH (NOLOCK)
	ON
		([JP].[Job] = [JPdt].[Job])
		AND ([JP].[Line] = [JPdt].[Line])
		AND ([JP].[MStockCode] = [JPdt].[MStockCode])
) AS [JP]
ON
	([JM].[StockCode] = [JP].[MStockCode])
	AND ([JM].[Job] = [JP].[Job])
LEFT JOIN
	[BWSdb].[dbo].[Production] [PD] WITH (NOLOCK)
ON
	([JM].[Job] = CAST([PD].[WO#] AS NVARCHAR(MAX)))
LEFT JOIN (
	SELECT
		[JL].[Job],
		MIN([JL].[PlannedStartDate]) AS [FirstPlannedStartDate]
	FROM
		[SysproCompanyA].[dbo].[WipJobAllLab] [JL] WITH (NOLOCK)
	GROUP BY
		[JL].[Job]
) AS [JL]
ON
	([JM].[Job] = [JL].[Job])
WHERE
	LOWER([JM].[StockCode]) = LOWER('{stockcode}')
	AND ([JM].[QtyIssued] <= [JM].[QtyToIssue])
	--AND ([JM].[AllocCompleted] = 'N'))
;
"""
    df = connect(sql)
    return df


@st.cache_data(ttl=60*60, show_spinner=True)
def search_three_term(*terms) -> pd.DataFrame:
    terms = [("'" + t.removesuffix("'").removeprefix("'") + "'") for t in terms if t]
    if len(terms) == 3:
        st1, st2, st3 = terms
    elif len(terms) == 2:
        st1, st2, st3 = list(terms) + ["NULL"]
    elif len(terms) == 1:
        st1, st2, st3 = list(terms) + ["NULL", "NULL"]
    else:
        return pd.DataFrame(columns=["StockCode", "Description"])
        # st1, st2, st3 = ["NULL", "NULL", "NULL"]
    sql = f"""
EXEC [BWSdb].[dbo].[sp_REC_3TermSearch] @st1={st1},  @st2={st2},  @st3={st3}, @warehouse='01';
"""
    df = connect(sql)
    return df


@st.cache_data(ttl=60*60, show_spinner=True)
def load_shopclock_frame(date_in: Optional[datetime.date] = None) -> pd.DataFrame:
    if date_in is None:
        date_in = datetime.datetime.now().date()
    sql = f"""
SELECT
	[CT].[TransactionID],
	[CT].[JobNumber],
	[CT].[JobName],
	[CT].[Operation],
	[CT].[OperationComplete],
	[CT].[EmployeeNumber],
	[CT].[EmployeeName],
	[CT].[WorkCentreCode],
	[CT].[LoggedOn],
	[CT].[LoggedOff],
	[CT].[IsComplete],
	[CT].[GroupID],
	[CT].[GroupName],
	[CT].[IsNonProductive],
	[CT].[NonProductiveCode],
	[CT].[NonProductiveDescription],
	[CT].[MachineCode],
	[CT].[MachineCodeDescription],
	[CT].[IsLoggedOn]
FROM
	[SysproCompanyA].[dbo].[ClkTransaction] [CT] WITH (NOLOCK)
WHERE
	(CAST([CT].[LoggedOn] AS DATE) = '{date_in:%Y-%m-%d}')
	OR (CAST([CT].[LoggedOff] AS DATE) = '{date_in:%Y-%m-%d}')
"""
    df = connect(sql)
    df["JobNumber"] = df["JobNumber"].apply(lambda jn: "NP" if (pd.isna(jn) or (not bool(str(jn)))) else jn)
    return df


@st.cache_data(ttl=60*60, show_spinner=True)
def load_yellow_tags(stockcode: str) -> pd.DataFrame:
    sql = f"""
SELECT
    [YT].[ID]
    ,[YT].[Active]
    ,[vYT].[DateCreated]
    ,[vYT].[LastModified]
    ,[vYT].[DateActive]
    ,[vYT].[DateInActive]
    ,[vYT].[PO]
    ,[vYT].[WO]
    ,[vYT].[StockCode]
    ,[vYT].[YTDescription]
    ,[vYT].[QtyMissing]
    ,[vYT].[Notes]
    ,[vYT].[QtyOnHand]
    ,[vYT].[Description]
    ,[vYT].[LongDesc]
    ,[vYT].[Supplier]
    ,[vYT].[Warehouse]
    ,[vYT].[LastPurchDate]
    ,[vYT].[POOrigDueDate]
    ,[vYT].[POLatestDueDate]
    ,[vYT].[Bin]
    ,[vYT].[POReceivedQty]
    ,[vYT].[DrawingPath]
FROM
    [BWSdb].[dbo].[PROD_YellowTags] [YT] WITH (NOLOCK)
LEFT JOIN
    [BWSdb].[dbo].[v_PROD_YellowTags] [vYT] WITH (NOLOCK)
ON
	[YT].[ID] = [vYT].[ID]
WHERE
    LOWER([YT].[StockCode]) = LOWER('{stockcode}')
;
"""
    df = connect(sql)
    return df


@st.cache_data(ttl=60*60, show_spinner=True)
def load_sales_orders() -> pd.DataFrame:
    """Load Sales Order data by header, only 1 record per Sales Order"""
    sql = """
SELECT
	[SM].[SalesOrder],
	[SM].[ExchangeRate],
	[SM].[OrderDate],
	[SM].[OrderStatus],
	[SM].[ActiveFlag],
	[SM].[CancelledFlag],
	[SM].[LastOperator],
	[SM].[LastInvoice],
	[AC].[Name] AS [Customer],
	[AC].[ShortName],
	[AC].[SoldToAddr1],
	[AC].[SoldToAddr2],
	[AC].[SoldToAddr3],
	[SM].[ShipAddress1],
	[SM].[ShipAddress2],
	[SM].[ShipAddress3],
	[AC].[Contact],
	[AC].[Telephone],
	[AC].[Email],
	[AC].[Nationality],
	[AC].[DateCustAdded],
	[AC].[DateLastSale],
	[AC].[DateLastPay]
FROM
	[SysproCompanyA].[dbo].[SorMaster] [SM] WITH (NOLOCK)
INNER JOIN
	[SysproCompanyA].[dbo].[ArCustomer] [AC] WITH (NOLOCK)
ON
	[SM].[Customer] = [AC].[Customer]
WHERE
	ISNULL([SM].[OrderDate], GETDATE()) >= DATEADD(YEAR, -5, GETDATE())
	AND ISNULL([SM].[OrderDate], GETDATE()) <= DATEADD(YEAR, 5, GETDATE())
"""
    df = connect(sql)
    df["SalesOrder"] = df["SalesOrder"].apply(lambda so: so_fmt(so, "int"))
    return df


@st.cache_data(ttl=60*60, show_spinner=True)
def load_purchase_orders() -> pd.DataFrame:
    """Load Purchase Order data by header, only 1 record per Purchase Order"""
    sql = """
SELECT
	[PM].[PurchaseOrder],
	[PM].[ExchangeRate],
	[PM].[OrderEntryDate],
	[PM].[OrderDueDate],
	[PM].[OrderStatus],
	[PM].[ActiveFlag],
	[PM].[CancelledFlag],
	[PM].[ActiveFlag],
	[PM].[Buyer],
	[PS].[SupShortName] AS [Supplier],
	[PS].[SupplierName],
	[PS].[City],
	[PS].[Branch],
	[PS].[CountyZip],
	[PS].[Contact],
	[PS].[Telephone],
	[PS].[Email],
	[PS].[Nationality]
FROM
	[SysproCompanyA].[dbo].[PorMasterHdr] [PM] WITH (NOLOCK)
INNER JOIN
	[SysproCompanyA].[dbo].[ApSupplier] [PS] WITH (NOLOCK)
ON
	[PM].[Supplier] = [PS].[Supplier]
WHERE
	ISNULL([PM].[OrderDueDate], GETDATE()) >= DATEADD(YEAR, -5, GETDATE())
	AND ISNULL([PM].[OrderDueDate], GETDATE()) <= DATEADD(YEAR, 5, GETDATE())
;
"""
    df = connect(sql)
    df["PurchaseOrder"] = df["PurchaseOrder"].apply(lambda po: po_fmt(po, "int"))
    return df


@st.cache_data(ttl=60*60, show_spinner=True)
def load_sales_order_pick_sheet(salesorder: str) -> pd.DataFrame:
    """Run the SO pick sheet logic from within Access to get the formatted and focused data on Sales Order StockCode data"""
    sql = f"""
SELECT
    [SO].[SalesOrder],
    [SO].[SalesOrderLine],
    [SO].[MStockCode],
    [SO].[MStockDes],
    [IM].[LongDesc],
    [SO].[MStockingUom],
    [SO].[MWarehouse],
    [IW].[DefaultBin],
    [SO].[MOrderQty],
    [SO].[MShipQty],
    [SO].[MBackOrderQty],
    [SO].[MPrice],
    [IW].[QtyAllocated],
    [IW].[QtyAllocatedToPick],
    [IW].[QtyAllocatedWip],
    [IW].[QtyOnBackOrder],
    [IW].[QtyOnHand],
    [IW].[QtyOnOrder],
    [SM].[Customer],
    [SM].[CustomerName],
    [SM].[ShipAddress1],
    [SM].[ShipAddress2],
    [SM].[ShipAddress3],
    [SM].[ShipAddress3Loc],
    [SM].[ShipAddress4],
    [SM].[ShipAddress5],
    [IW].[QtyOnHand] - (
        [IW].[QtyAllocated] + [IW].[QtyAllocatedToPick] + [IW].[QtyAllocatedWip]
    ) AS Available,
    [SO].[MOrderQty] * (
        [SO].[MPrice] - (
            (([SO].[MPrice] * ([SO].[MDiscPct1] / 100))) + [SO].[MDiscValue]
        )
    ) AS Amount,
    [SO].[MOrderQty] * (
        (
            (([SO].[MPrice] * ([SO].[MDiscPct1] / 100))) + [SO].[MDiscValue]
        )
    ) AS Discount
FROM
    (
        (
            [SysproCompanyA].[dbo].[SorDetail] AS [SO]
            LEFT JOIN [SysproCompanyA].[dbo].[InvWarehouse] AS [IW] ON ([SO].[MWarehouse] = [IW].[Warehouse])
            AND ([SO].[MStockCode] = [IW].[StockCode])
        )
        LEFT JOIN [SysproCompanyA].[dbo].[SorMaster] AS SM ON [SO].[SalesOrder] = [SM].[SalesOrder]
    )
    LEFT JOIN [SysproCompanyA].[dbo].[InvMaster] AS IM ON ([IM].[StockCode] = [IW].[StockCode])
    AND ([IW].[Warehouse] = [IM].[WarehouseToUse])
WHERE
    (
        [SO].[SalesOrder] = RIGHT('000000000000000' + '{so_fmt(salesorder, out_type="str")}', 15)
    )
    AND (ISNULL([SO].[MStockCode], '') <> '')
;
"""
    df = connect(sql)
    df["SalesOrder"] = df["SalesOrder"].apply(lambda so: so_fmt(so, out_type="int"))
    return df


@st.cache_data(ttl=60*60, show_spinner=True)
def load_syspro_issuing_values() -> list[pd.DataFrame]:
    sql_job = """
SELECT
	[JP].[Job]
FROM
	[SysproCompanyA].[dbo].[WipJobPost] [JP] WITH (NOLOCK)
GROUP BY
	[JP].[Job]
"""

    sql_stockcode = """
SELECT
	[JP].[MStockCode]
FROM
	[SysproCompanyA].[dbo].[WipJobPost] [JP] WITH (NOLOCK)
GROUP BY
	[JP].[MStockCode]
"""

    sql_journal = """
SELECT
	[JP].[Journal]
FROM
	[SysproCompanyA].[dbo].[WipJobPost] [JP] WITH (NOLOCK)
GROUP BY
	[JP].[Journal]
"""

    sql_operation = """
SELECT
	[JP].[LOperation]
FROM
	[SysproCompanyA].[dbo].[WipJobPost] [JP] WITH (NOLOCK)
GROUP BY
	[JP].[LOperation]
"""

    sql_operator = """
SELECT
	[IJ].[Operator]
FROM
	[SysproCompanyA].[dbo].[InvJournalCtl] [IJ] WITH (NOLOCK)
GROUP BY
	[IJ].[Operator]
"""

    lst = [connect(sql_) for sql_ in (sql_job, sql_stockcode, sql_journal, sql_operation, sql_operator)]

    for df in lst:
        df = pd.concat([df, pd.DataFrame(data=[{c: None for c in df.columns}])])

    return lst


@st.cache_data(ttl=60*60, show_spinner=True)
def search_syspro_issuing(
    stockcode: str,
    job: str,
    operation: int,
    journal: int,
    operator: str,
    and_or: bool = True,
    year_int: float = 1.5
) -> pd.DataFrame:
    sql = """

SELECT
	[JP].[Job],
	[JP].[MStockCode],
	[JP].[LOperation],
	[JP].[MQtyIssued],
	[JP].[TrnDate],
	[dtJP].[TrnDateTime],
	[IJ].[Operator]
FROM
	[SysproCompanyA].[dbo].[WipJobPost] [JP] WITH (NOLOCK)
INNER JOIN
	[SysproCompanyA].[dbo].[v_PROD_WipJobPostDateTime] [dtJP] WITH (NOLOCK)
ON
	([JP].[Job] = [dtJP].[Job])
	AND ([JP].[Line] = [dtJP].[Line])
	AND ([JP].[MStockCode] = [dtJP].[MStockCode])
INNER JOIN
	[SysproCompanyA].[dbo].[InvJournalCtl] [IJ] WITH (NOLOCK)
ON
	([JP].[Journal] = [IJ].[Journal])
	AND ([JP].[MWarehouse] = [IJ].[Warehouse])
"""
    ao = " AND " if and_or else " OR "
    crit = []
    if any([stockcode, job, operation, journal, operator]):
        if stockcode:
            crit.append(f"(LOWER(LTRIM(RTRIM([JP].[MStockCode]))) = '{stockcode.strip().lower()}')")
        if job:
            crit.append(f"(LOWER(LTRIM(RTRIM([JP].[Job]))) = '{job.strip().lower()}')")
        if operation:
            crit.append(f"([JP].[LOperation] = {int(operation)})")
        if journal:
            crit.append(f"([JP].[Journal] = {int(journal)})")
        if operator:
            crit.append(f"(LOWER(LTRIM(RTRIM([IJ].[Operator]))) = '{operator.strip().lower()}')")
    else:
        crit.append("(1=1)")

    sql += "WHERE\n\t" + (ao.join(crit))
    sql += f"\n\tAND ((DATEADD(YEAR, -{abs(year_int)}, GETDATE()) <= [dtJP].[TrnDateTime]) AND ([dtJP].[TrnDateTime] <= DATEADD(YEAR, {abs(year_int)}, GETDATE())))"
    df = connect(sql, do_show=True, do_print=True)
    if user in admin_end_users:
        with st.expander(f"sql"):
            st.code(
                sql,
                language="sql",
                line_numbers=True
            )
    return df


@st.cache_data(ttl=60*60, show_spinner=True)
def load_change_requests() -> pd.DataFrame:
    path_abs: str = os.path.join(os.getcwd(), CHANGE_REQUEST_FILE)
    if not os.path.exists(path_abs):
        with open(path_abs, "w") as f:
            json.dump([], f)
    with open(path_abs, "r") as f:
        df = pd.DataFrame(json.load(f))
        df["date"] = df["date"].apply(lambda date: eval(date))
        return df


@st.dialog(title="Submit a Change:")
def submit_change(ser_stock: pd.Series) -> tuple[bool, str]:

    k_selectbox_change_field: str = "key_selectbox_change_field"
    options_selectbox_change_field = [
        "DefaultBin"
    ]
    selectbox_change_field = st.selectbox(
        label="Select a field to change:",
        key=k_selectbox_change_field,
        options=options_selectbox_change_field
    )
    if selectbox_change_field:
        k_text_field_current: str = "key_text_field_current"
        curr_val = ser_stock[selectbox_change_field]
        st.session_state.update({k_text_field_current: curr_val})
        text_field_current = st.text_input(
            label="Current:",
            key=k_text_field_current,
            disabled=True
        )
        k_text_field_new: str = "key_text_field_new"
        curr_val = ser_stock[selectbox_change_field]
        text_field_new = st.session_state.setdefault(k_text_field_new, "")
        text_field_new = st.text_input(
            label="New:",
            key=k_text_field_new
        )
        k_text_field_notes: str = "key_text_field_notes"
        curr_val = ser_stock[selectbox_change_field]
        text_field_notes = st.session_state.setdefault(k_text_field_notes, "")
        text_field_notes = st.text_input(
            label="Notes:",
            key=k_text_field_notes
        )
        k_btn_submit_change: str = "key_btn_submit_change"
        if text_field_new:
            if st.button(
                label="submit",
                key=k_btn_submit_change
            ):
                
                path_abs: str = os.path.join(os.getcwd(), CHANGE_REQUEST_FILE)
                if not os.path.exists(path_abs):
                    with open(path_abs, "w") as f:
                        json.dump([], f)
                with open(path_abs, "r") as f:
                    data = json.load(f)
                data.append({
                    "user": st.session_state["user"],
                    "date": jsonify(datetime.datetime.now()),
                    "stockcode": ser_stock["StockCode"],
                    "field": selectbox_change_field,
                    "old": text_field_current,
                    "new": text_field_new,
                    "notes": text_field_notes,
                    "completed": None,
                    "completed_by": None,
                    "completed_date": None
                })

                with open(path_abs, "w") as f:
                    json.dump(data, f)

                st.session_state.update({
                    k_pills_search_mode_save: st.session_state.get(k_pills_search_mode)
                })
                st.toast("Request submitted")
                st.rerun()


def load_path_pdf(stockcode) -> pd.DataFrame:
    sql = f"""
SELECT
	[IM].[DrawOfficeNum] AS [PDF_Listed],
	[IM].[StockCode] AS [PDF_Stock]
FROM
	[SysproCompanyA].[dbo].[InvMaster] [IM] WITH (NOLOCK)
WHERE
	LOWER([IM].[StockCode]) = LOWER('{stockcode}')
"""
    df = connect(sql)
    for col in [
        "PDF_Listed",
        "PDF_Stock"
    ]:
        df[col] = df[col].apply(
            lambda p:
                os.path.join(PATH_STOCK_PDFS, f"{str(p).removesuffix('.pdf')}.pdf") if ((not pd.isna(p)) and p) else None
        )
        df[col] = df[col].apply(lambda p: p if os.path.exists(p) else None)
    return df


def generate_so_pick_sheet(df_so_pick_sheet: pd.DataFrame, as_zip: bool = False):
    df_w = df_so_pick_sheet.copy()

    if len(df_w["SalesOrder"].dropna().unique()) != 1:
        raise ValueError(f"Cannot prepare a Sales Order Pick Sheet with combined orders.")

    so = df_w.loc[0, "SalesOrder"]
    cust_name = df_w.loc[0, "CustomerName"]
    ship_addr_0 = df_w.loc[0, "ShipAddress1"]
    ship_addr_1 = df_w.loc[0, "ShipAddress2"]
    ship_addr_2 = df_w.loc[0, "ShipAddress3"]

    df_w.sort_values("SalesOrderLine", inplace=True)
    table_cols = {
        "MOrderQty": "QTY ORD",
        "MBackOrderQty": "QTY B/O",
        "MShipQty": "QTY SHP",
        "MStockCode": "STOCK",
        "MStockDes": "DESC",
        "LongDesc": "LONG DESC",
        "MStockingUom": "UOM",
        "MPrice": "PRICE",
        "Discount": "DISC",
        "Amount": "TOTAL",
        "QtyOnHand": "ON HAND",
        "QtyOnOrder": "ON ORDER"
    }
    df_part_data = df_w[table_cols.keys()]
    df_part_data.rename(columns=table_cols, inplace=True)

    report_file_name: str = f"so_pick_sheet_{so}_{datetime.datetime.now():%Y-%m-%d_%H%M%S}.pdf"
    report_title: str = f"Sales Order Pick Sheet"
    report_subtitle: str = f"SO# {so}"
    report_author: str = f"{user}"

    theme = rlu.PDFTheme(
        page_size=rlu.landscape(rlu.LETTER)
    )
    meta = rlu.PDFMeta(
        title=report_title,
        subtitle=report_subtitle,
        author=report_author,
    )
    styles = rlu.build_styles(theme)

    out, doc = rlu.build_pdf(
        report_file_name,
        story=None,
        theme=theme,
        meta=meta,
        as_zip=as_zip
    )
    buf = out
    rlu.add_grid_template(doc, theme, template_id="dash", rows=3, cols=2)

    story = []
    story += [
        rlu.h3("Picked By:", styles),
        rlu.h3("Picked Date:", styles),
        rlu.h3("Ship Date:", styles),
    ]

    # cell 0, 0
    story += [rlu.FrameBreak()]

    # cell 0, 1
    story += [
        rlu.h3(f"{cust_name}", styles),
        rlu.h3(f"{ship_addr_0}", styles),
        rlu.h3(f"{ship_addr_1}", styles),
        rlu.h3(f"{ship_addr_2}", styles),
        rlu.FrameBreak()
    ]

    # cell 1, 0
    story += [
        rlu.df_table(df_part_data, theme, styles, number_format={"Value": "{:,.2f}"})
    ]

    # # # TOC (optional) — headings added after it will populate it
    # # story += rlu.toc(styles)
    #
    # story += [rlu.h1("Section 1", styles), rlu.p("Some paragraph text.", styles)]
    # story += [rlu.h2("Sales Order Pick Sheets Combined", styles)]
    # story += [rlu.df_table(df_sales_order_pick_sheets, theme, styles, number_format={"Value": "{:,.2f}"})]
    # story += [rlu.vspace(12)]
    #
    # # If you have a matplotlib chart saved as PNG:
    # # plt.savefig("chart.png", dpi=150, bbox_inches="tight")
    # # story += [h2("A figure", styles)]
    # # story += figure("chart.png", styles, caption="Figure 1: Example chart", max_width=6.5*inch)

    # out = rlu.build_pdf(report_file_name, story, theme=theme, meta=meta)

    doc.build(story)
    if not as_zip:
        f_name = out.resolve()
        print(f"Wrote: {f_name}")
        return f_name

    # Will be io.BytesIO for zipping
    print(f"ZIP generate_so_pick_sheet")
    return buf.getvalue()


def po_fmt(po_num: int | str, out_type: Literal["int", "str"], word_size: int = 15) -> int | str:
    if out_type == "str":
        return str(po_num).rjust(word_size, "0")
    else:
        while po_num and (po_num[0] == "0"):
            po_num = po_num[1:]
        return po_num


def so_fmt(so_num: int | str, out_type: Literal["int", "str"], word_size: int = 15) -> int | str:
    if out_type == "str":
        return str(so_num).rjust(word_size, "0")
    else:
        while so_num and (so_num[0] == "0"):
            so_num = so_num[1:]
        return so_num


async def run_day():
    days_of_work: int = 4
    now = datetime.datetime.now()
    start = now.replace(hour=6, minute=0, second=0, microsecond=0)
    end = datetime.datetime.now()
    end = end.replace(hour=16, minute=30, second=0, microsecond=0)
    t_sec = (end - start).total_seconds()
    dow = now.weekday()
    if 0 <= dow < days_of_work:
        dp = (1 / days_of_work) * dow
    else:
        dp = 1
        pb_week.progress(1, text=f"Week over")
        return

    now = now + datetime.timedelta(minutes=1)
    p_sec = max((now - start).total_seconds(), 0)
    v = min(1.0, max(0.0, p_sec / t_sec))
    pb_day.progress(v, text=f"{percent(v)} {int(round(t_sec - p_sec, 0))} second(s) left {time_between(datetime.datetime.now(), datetime.datetime.now() + datetime.timedelta(seconds=t_sec - p_sec))}")

    while now < end:
        now = datetime.datetime.now()
        p_sec = max((now - start).total_seconds(), 0)
        await asyncio.sleep(1)
        v = min(1.0, max(0.0, p_sec / t_sec))
        pb_day.progress(v, text=f"{percent(v)} {int(round(t_sec - p_sec, 0))} second(s) left {time_between(datetime.datetime.now(), datetime.datetime.now() + datetime.timedelta(seconds=t_sec - p_sec))}")
        pb_week.progress((v / days_of_work) + dp, text=f"Week {percent((v / days_of_work) + dp)}")
        # st.write(f"{end}, {p_sec=}, {v=}")
    # st.write(f"{start}")
    # st.write(f"{end}")


if st_auth():
    
    st.header("Parts")
    user = st.session_state.get("user", "??")
    st.write(f"welcome {user}")
    # if st.button("change password"):
    with st.popover("change password"):
        if show_change_password():
            st.rerun()

    df_parts = load_parts_data()
    df_bins = load_bin_location_data()
    df_change_requests = load_change_requests()

    # list_bins = df_parts["DefaultBin"].unique().tolist()
    list_stockcodes = list(map(str.lower, df_parts["StockCode"].unique()))

    # search for a stockcode
    # view bin and quantities
    # view past movements
    # view open jobs / so / po #s

    # search for all parts in a bin

    list_settings_keys = []
    with st.popover("Filter"):
        k_checkbox_warehouse_1_only = "key_checkbox_warehouse_1_only"
        k_checkbox_hawkins_parts_inc = "key_checkbox_hawkins_parts_inc"
        k_checkbox_montana_parts_inc = "key_checkbox_montana_parts_inc"
        k_checkbox_vmi_parts_inc = "key_checkbox_vmi_parts_inc"
        k_checkbox_unknown_parts_inc = "key_checkbox_unknown_parts_inc"

        list_settings_keys.extend([
            k_checkbox_warehouse_1_only,
            k_checkbox_hawkins_parts_inc,
            k_checkbox_montana_parts_inc,
            k_checkbox_vmi_parts_inc,
            k_checkbox_unknown_parts_inc
        ])

        k_loaded_settings_session = "key_loaded_settings_session"
        loaded_settings = get_user_settings()
        loaded_settings_bd = st.session_state.setdefault(k_loaded_settings_session, loaded_settings)
        loaded_settings_b, loaded_settings_d = loaded_settings_bd
        if loaded_settings_b:
            for k, v in loaded_settings_d.items():
                st.session_state.setdefault(k, v)

        st.session_state.setdefault(k_checkbox_warehouse_1_only, True)
        checkbox_warehouse_1_only = st.checkbox(
            label="Warehouse 01 Stockcodes only?",
            key=k_checkbox_warehouse_1_only
        )

        st.session_state.setdefault(k_checkbox_hawkins_parts_inc, True)
        checkbox_hawkins_parts_inc = st.checkbox(
            label="Include parts @ Hawkins Warehouse?",
            key=k_checkbox_hawkins_parts_inc
        )

        st.session_state.setdefault(k_checkbox_montana_parts_inc, True)
        checkbox_montana_parts_inc = st.checkbox(
            label="Include parts @ Montana Warehouse?",
            key=k_checkbox_montana_parts_inc
        )

        st.session_state.setdefault(k_checkbox_vmi_parts_inc, False)
        checkbox_vmi_parts_inc = st.checkbox(
            label="Include parts in Vending Machines?",
            key=k_checkbox_vmi_parts_inc
        )

        st.session_state.setdefault(k_checkbox_unknown_parts_inc, False)
        checkbox_unknown_parts_inc = st.checkbox(
            label="Include parts in Unknown Bin Locations?",
            key=k_checkbox_unknown_parts_inc
        )

        current_settings = {k: st.session_state[k] for k in list_settings_keys}
        # st.write("loaded_settings")
        # st.write(loaded_settings[1])
        # st.write("current_settings")
        # st.write(current_settings)

        if not loaded_settings[1]:
            save_user_settings(current_settings)
            loaded_settings = (True, current_settings)

        if loaded_settings[1] != current_settings:
            if st.button(
                "Save these settings as your preferred settings?"
            ):
                save_user_settings(current_settings)
        st.session_state.update({k_loaded_settings_session: (True, current_settings)})

    if checkbox_warehouse_1_only:
        df_bins = df_bins[
            df_bins["Warehouse"] == "01"
        ]

    if not checkbox_hawkins_parts_inc:
        df_bins = df_bins[
            ~df_bins["BuildingCode"].isin([BUILDING_CODE_BOTH, BUILDING_CODE_MONTANA])
        ]

    if not checkbox_montana_parts_inc:
        df_bins = df_bins[
            ~df_bins["BuildingCode"].isin([BUILDING_CODE_BOTH, BUILDING_CODE_HAWKINS])
        ]

    if not checkbox_vmi_parts_inc:
        df_bins = df_bins[
            ~df_bins["BuildingCode"].isin([BUILDING_CODE_VMI])
        ]

    if not checkbox_unknown_parts_inc:
        df_bins = df_bins[
            ~df_bins["BuildingCode"].isin([BUILDING_CODE_UNKNOWN])
        ]

    # display_df(
    #     df_bins,
    #     "df_bins"
    # )

    list_filtered_bins = df_bins["DefaultBin"].dropna().unique().tolist()
    list_filtered_sections = df_bins["Section"].dropna().unique().tolist()

    df_parts = df_parts[df_parts["DefaultBin"].isin(list_filtered_bins)]

    # k_selectbox_stockcode = "key_selectbox_stockcode"
    # selectbox_stockcode = st.selectbox(
    #     label="Stockcode:",
    #     key=k_selectbox_stockcode,
    #     options=list_stockcodes
    # )

    op_search_mode_simple: str = "Simple"
    op_search_mode_advanced: str = "Advanced"
    op_search_mode_by_bin: str = "By Bin"
    op_search_mode_by_section: str = "By Section"
    op_search_mode_by_po: str = "By PO"
    op_search_mode_by_so: str = "By SO"
    op_search_mode_by_shopclock: str = "ShopClock",
    op_search_mode_syspro: str = "Syspro"
    op_search_mode_day_totals: str = "Day Totals"
    options_pills_search_mode = [
        op_search_mode_simple, 
        op_search_mode_advanced,
        op_search_mode_by_bin,
        op_search_mode_by_section,
        op_search_mode_by_po,
        op_search_mode_by_so,
        op_search_mode_by_shopclock,
        op_search_mode_syspro
    ]

    admin_end_users = ["abriggs"]
    if user in admin_end_users:
        options_pills_search_mode.append(
            op_search_mode_day_totals
        )

    textbox_stockcode = None
    k_multiselect_sales_order_search = "key_multiselect_sales_order_search"
    k_pills_search_mode: str = "key_pills_search_mode"
    k_pills_search_mode_save: str = "key_pills_search_mode_save"

    if user in admin_end_users:
        with st.container(border=True):
            st.write(f"A")
            st.write(f"{st.session_state.get(k_pills_search_mode)=}")
            st.write(f"{st.session_state.get(k_pills_search_mode_save)=}")
            st.write(f"{textbox_stockcode=}")

    pills_search_mode = st.session_state.setdefault(k_pills_search_mode, 0)
    if st.session_state.get(k_pills_search_mode_save) is not None:
        st.session_state.update({
            k_pills_search_mode: st.session_state.get(k_pills_search_mode_save),
            k_pills_search_mode_save: None
        })

    if user in admin_end_users:
        with st.container(border=True):
            st.write(f"B")
            st.write(f"{pills_search_mode=}")
            st.write(f"{st.session_state.get(k_pills_search_mode)=}")
            st.write(f"{textbox_stockcode=}")

    # pills_search_mode = st.session_state.setdefault(k_pills_search_mode, op_search_mode_simple)
    # if pills_search_mode == 0:
    #     pills_search_mode = op_search_mode_simple
    # pills_search_mode = pills_search_mode if isinstance(pills_search_mode, str) else options_pills_search_mode[pills_search_mode]
    cont_top_control = st.container()

    if pills_search_mode == op_search_mode_advanced:
        # Multi
        k_text_multi_0 = "key_text_multi_0"
        k_text_multi_1 = "key_text_multi_1"
        k_text_multi_2 = "key_text_multi_2"
        t0 = st.session_state.setdefault(k_text_multi_0, "")
        t1 = st.session_state.setdefault(k_text_multi_1, "")
        t2 = st.session_state.setdefault(k_text_multi_2, "")
        # t_texts = max(3, min(1, sum([int(bool(x)) for x in [t0, t1, t2]]) + 1))
        with st.container():
            cols_search_term = st.columns([0.45, 0.55])
            cont_search_result = st.container()

            with cols_search_term[0]:
                if st.button(
                    "clear"
                ):
                    st.session_state.update({
                        k_text_multi_0: "",
                        k_text_multi_1: "",
                        k_text_multi_2: "",
                        k_pills_search_mode_save: st.session_state.get(k_pills_search_mode)
                    })
                    # st.rerun()

            text_widgets = []
            for i, key in enumerate([k_text_multi_0, k_text_multi_1, k_text_multi_2]):
                with cols_search_term[0]:
                    text_widgets.append(st.text_input(
                        label=f"Term {i + 1}",
                        key=key,
                        on_change=lambda : st.session_state.update({k_search_text_widgets: None})
                    ))
                if not st.session_state.get(key):
                    break

            textbox_stockcode = None
            k_search_text_widgets: str = "key_search_text_widgets"
            with cols_search_term[0]:
                if st.button(
                    "submit"
                ):
                    st.session_state.update({k_search_text_widgets: text_widgets})
                    # st.rerun()

            if st.session_state.setdefault(k_search_text_widgets):
                df_searched = search_three_term(*st.session_state.get(k_search_text_widgets, []))
                k_stdf_searched = "key_stdf_searched"
                show_cols = [
                    "StockCode",
                    "DefaultBin",
                    "Description",
                    "LongDesc"
                ]
                with cols_search_term[1]:

                    with st.container(border=True):
                        stdf_searched = display_df_paginated(
                            df=df_searched[show_cols],
                            title="df_searched",
                            on_select="rerun",
                            selection_mode="single-row",
                            key=k_stdf_searched,
                            width=1600
                        )

                    # st.write(stdf_searched)

                if stdf_searched:
                    if stdf_searched["selection"]:
                        if stdf_searched["selection"]["rows"]:
                            textbox_stockcode = df_searched.loc[stdf_searched["selection"]["rows"][0], "StockCode"]
        st.divider()

    # if pills_search_mode == op_search_mode_advanced:
    elif pills_search_mode == options_pills_search_mode.index(op_search_mode_advanced):
        # Multi
        k_text_multi_0 = "key_text_multi_0"
        k_text_multi_1 = "key_text_multi_1"
        k_text_multi_2 = "key_text_multi_2"
        t0 = st.session_state.setdefault(k_text_multi_0, "")
        t1 = st.session_state.setdefault(k_text_multi_1, "")
        t2 = st.session_state.setdefault(k_text_multi_2, "")
        # t_texts = max(3, min(1, sum([int(bool(x)) for x in [t0, t1, t2]]) + 1))
        with st.container():
            cols_search_term = st.columns([0.45, 0.55])
            cont_search_result = st.container()

            with cols_search_term[0]:
                if st.button(
                    "clear"
                ):
                    st.session_state.update({
                        k_text_multi_0: "",
                        k_text_multi_1: "",
                        k_text_multi_2: "",
                        k_pills_search_mode_save: st.session_state.get(k_pills_search_mode)
                    })
                    # st.rerun()

            text_widgets = []
            for i, key in enumerate([k_text_multi_0, k_text_multi_1, k_text_multi_2]):
                with cols_search_term[0]:
                    text_widgets.append(st.text_input(
                        label=f"Term {i + 1}",
                        key=key,
                        on_change=lambda : st.session_state.update({k_search_text_widgets: None})
                    ))

            textbox_stockcode = None
            k_search_text_widgets: str = "key_search_text_widgets"
            with cols_search_term[0]:
                if st.button(
                    "submit"
                ):
                    st.session_state.update({
                        k_search_text_widgets: text_widgets,
                        k_pills_search_mode_save: st.session_state.get(k_pills_search_mode)
                    })
                    # st.rerun()

            if st.session_state.setdefault(k_search_text_widgets):
                df_searched = search_three_term(*st.session_state.get(k_search_text_widgets, []))
                k_stdf_searched = "key_stdf_searched"
                show_cols = [
                    "StockCode",
                    "DefaultBin",
                    "Description",
                    "LongDesc"
                ]
                with cols_search_term[1]:

                    with st.container(border=True):
                        stdf_searched = display_df_paginated(
                            df=df_searched[show_cols],
                            title="df_searched",
                            on_select="rerun",
                            selection_mode="single-row",
                            key=k_stdf_searched
                        )

                    # st.write(stdf_searched)

                if stdf_searched:
                    if stdf_searched["selection"]:
                        if stdf_searched["selection"]["rows"]:
                            textbox_stockcode = df_searched.loc[stdf_searched["selection"]["rows"][0], "StockCode"]
        st.divider()

    # elif pills_search_mode == op_search_mode_by_bin:
    elif pills_search_mode == options_pills_search_mode.index(op_search_mode_by_bin):
        # By Bin
        k_selectbox_bin_search = "key_selectbox_bin_search"
        selectbox_bin_search  = st.selectbox(
            label="Select a Bin:",
            key=k_selectbox_bin_search,
            options=list_filtered_bins
        )

        if selectbox_bin_search:
            df_search_bin = df_parts.loc[
                df_parts["DefaultBin"] == selectbox_bin_search
            ]

            with st.container(border=True):
                display_df_paginated(
                    df_search_bin,
                    title="df_search_bin",
                    key=f"key_stdf_search_bin"

                )
    
    # elif pills_search_mode == op_search_mode_by_section:
    elif pills_search_mode == options_pills_search_mode.index(op_search_mode_by_section):
        # By Section
        k_selectbox_section_search = "key_selectbox_section_search"
        selectbox_section_search  = st.selectbox(
            label="Select a Section:",
            key=k_selectbox_section_search,
            options=list_filtered_sections
        )

        if selectbox_section_search:
            filt_section_bins = df_bins.loc[df_bins["Section"] == selectbox_section_search, "DefaultBin"].dropna().unique().tolist()
            df_search_section = df_parts.loc[
                df_parts["DefaultBin"].isin(filt_section_bins)
            ]

            with st.container(border=True):
                display_df_paginated(
                    df_search_section,
                    title="df_search_section",
                    key=f"key_stdf_search_section"
                )

    # elif pills_search_mode == op_search_mode_by_po:
    elif pills_search_mode == options_pills_search_mode.index(op_search_mode_by_po):
        # By PO
        df_pos: pd.DataFrame = load_purchase_orders()
        lst_pos = df_pos["PurchaseOrder"].dropna().unique().tolist()

        k_multiselect_purchase_order_search: str = "key_multiselect_purchase_order_search"
        multiselect_purchase_order_search = st.session_state.setdefault(k_multiselect_purchase_order_search, [])
        multiselect_purchase_order_search = st.multiselect(
            label="Select a Purchase Order:",
            key=k_multiselect_purchase_order_search,
            options=lst_pos,
            max_selections=10
        )

        if multiselect_purchase_order_search:
            st.divider()
            lst_df_purchase_orders: list[pd.DataFrame] = [load_po_details(purchaseorder=po) for po in
                                                       multiselect_purchase_order_search]
            if len(lst_df_purchase_orders) < 2:
                df_purchase_orders = lst_df_purchase_orders[0]
            else:
                df_purchase_orders = pd.concat(lst_df_purchase_orders, ignore_index=True).reset_index()

            k_stdf_purchase_orders: str = "key_stdf_purchase_orders"
            stdf_purchase_orders = display_df_paginated(
                df_purchase_orders,
                title="Purchase Orders:",
                key=k_stdf_purchase_orders
            )

            st.divider()

            # lst_df_purchase_order_pick_sheets: list[pd.DataFrame] = [load_purchase_order_pick_sheet(so) for so in multiselect_purchase_order_search]
            # if len(lst_df_purchase_orders) < 2:
            #     df_purchase_order_pick_sheets = lst_df_purchase_order_pick_sheets[0]
            # else:
            #     df_purchase_order_pick_sheets = pd.concat(lst_df_purchase_order_pick_sheets).reset_index()
            #
            # df_purchase_order_pick_sheets.sort_values(
            #     by=["PurchaseOrder", "MStockCode"],
            #     inplace=True
            # )

            k_stdf_purchase_order_pick_sheets: str = "key_stdf_purchase_order_pick_sheets"
            stdf_purchase_order_pick_sheets = display_df_paginated(
                df_purchase_orders,
                title="Purchase Order StockCodes:",
                key=k_stdf_purchase_order_pick_sheets,
                selection_mode="single-row",
                on_select="rerun"
            )

        if stdf_purchase_order_pick_sheets:
            if stdf_purchase_order_pick_sheets["selection"]:
                if stdf_purchase_order_pick_sheets["selection"]["rows"]:
                    textbox_stockcode = df_purchase_orders.loc[
                        stdf_purchase_order_pick_sheets["selection"]["rows"][0], "MStockCode"]
    
    # elif pills_search_mode == op_search_mode_by_so:
    elif pills_search_mode == options_pills_search_mode.index(op_search_mode_by_so):
        # By SO
        df_sales_orders = load_sales_orders()
        list_sales_orders: list[str] = df_sales_orders["SalesOrder"].dropna().unique().tolist()

        multiselect_sales_order_search = st.session_state.setdefault(k_multiselect_sales_order_search, [])
        multiselect_sales_order_search = st.multiselect(
            label="Select a Sales Order:",
            key=k_multiselect_sales_order_search,
            options=list_sales_orders,
            max_selections=10
        )

        if multiselect_sales_order_search:
            st.divider()
            lst_df_sales_orders: list[pd.DataFrame] = [load_so_details(salesorder=so) for so in multiselect_sales_order_search]
            if len(lst_df_sales_orders) < 2:
                df_sales_orders = lst_df_sales_orders[0]
            else:
                df_sales_orders = pd.concat(lst_df_sales_orders, ignore_index=True).reset_index()

            k_stdf_sales_orders: str = "key_stdf_sales_orders"
            stdf_sales_orders = display_df_paginated(
                df_sales_orders,
                title="Sales Orders:",
                key=k_stdf_sales_orders
            )

            st.divider()

            lst_df_sales_order_pick_sheets: list[pd.DataFrame] = [load_sales_order_pick_sheet(so) for so in multiselect_sales_order_search]
            if len(lst_df_sales_orders) < 2:
                df_sales_order_pick_sheets = lst_df_sales_order_pick_sheets[0]
            else:
                df_sales_order_pick_sheets = pd.concat(lst_df_sales_order_pick_sheets).reset_index()

            df_sales_order_pick_sheets.sort_values(
                by=["SalesOrder", "MStockCode"],
                inplace=True
            )

            k_stdf_sales_order_pick_sheets: str = "key_stdf_sales_order_pick_sheets"
            stdf_sales_order_pick_sheets = display_df_paginated(
                df_sales_order_pick_sheets,
                title="Sales Order Pick Sheets:",
                key=k_stdf_sales_order_pick_sheets,
                selection_mode="single-row",
                on_select="rerun"
            )

            #################################################

            lst_pdfs_bytes = []
            for so in df_sales_order_pick_sheets["SalesOrder"].dropna().unique():
                f_name = f"SOPickSheet_{so}.pdf"
                lst_pdfs_bytes.append((
                    f_name,
                    generate_so_pick_sheet(
                        df_sales_order_pick_sheets[df_sales_order_pick_sheets["SalesOrder"] == so],
                        as_zip=True
                    )
                ))

            zip_bytes = rlu.build_zip_bytes(lst_pdfs_bytes)

            st.download_button(
                "Download Sales Order Pick Sheets",
                data=zip_bytes,
                file_name=f"reports_{datetime.datetime.now():%Y-%m-%d_%H%M%S}.zip",
                mime="application/zip",
            )

            #################################################




            found = {}
            for i, row in df_sales_order_pick_sheets.iterrows():
                sc = row["MStockCode"]
                df_so_stock_path = load_path_pdf(sc)
                if not df_so_stock_path.empty:
                    stock_pdf_listed = df_so_stock_path.loc[0, "PDF_Listed"]
                    stock_pdf_stock = df_so_stock_path.loc[0, "PDF_Stock"]
                    if stock_pdf_listed or stock_pdf_stock:
                        if i not in found:
                            found[i] = []
                        found[i].append(sc)

            cols_per_row = 3
            cols_grid = [st.columns(cols_per_row, border=True) for i in range(int(math.ceil(len(found) / cols_per_row)))]

            ii = 0
            for i, row in df_sales_order_pick_sheets.iterrows():
                so = row["SalesOrder"]
                sc = row["MStockCode"]
                df_so_stock_path = load_path_pdf(sc)
                if not df_so_stock_path.empty:
                    stock_pdf_listed = df_so_stock_path.loc[0, "PDF_Listed"]
                    stock_pdf_stock = df_so_stock_path.loc[0, "PDF_Stock"]
                    if stock_pdf_listed or stock_pdf_stock:
                        with cols_grid[ii // cols_per_row][ii % cols_per_row]:
                            st.write(f"{so}")
                            st.write(f"{sc}")
                            f_name = f"{sc.replace(' ', '_')}"
                            if stock_pdf_listed:
                                st.download_button(
                                    label="download PDF as listed in Syspro?",
                                    data=open(stock_pdf_listed, "rb").read(),
                                    file_name=f"{f_name}_syspro.pdf",
                                    mime="application/pdf",
                                    key=f"{f_name}_drive_0"
                                )
                            if stock_pdf_stock:
                                f_name = f"{sc.replace(' ', '_')}"
                                st.download_button(
                                    label="Download found PDF from drive?",
                                    data=open(stock_pdf_stock, "rb").read(),
                                    file_name=f"{f_name}_found.pdf",
                                    mime="application/pdf",
                                    key=f"{f_name}_drive_1"
                                )
                        ii += 1

            if stdf_sales_order_pick_sheets:
                if stdf_sales_order_pick_sheets["selection"]:
                    if stdf_sales_order_pick_sheets["selection"]["rows"]:
                        textbox_stockcode = df_sales_order_pick_sheets.loc[stdf_sales_order_pick_sheets["selection"]["rows"][0], "MStockCode"]

            st.divider()
    
    # elif pills_search_mode == op_search_mode_by_shopclock:
    elif pills_search_mode == options_pills_search_mode.index(op_search_mode_by_shopclock):
        # ShopClock
        df_shopclock = load_shopclock_frame()

        stdf_shopclock = display_df_paginated(
            df_shopclock,
            title="ShopClock",
            key="key_stdf_shopclock"
        )

        st.divider()

        k_checkbox_include_machines: str = "key_checkbox_include_machines"
        checkbox_include_machines = st.session_state.setdefault(k_checkbox_include_machines, False)

        k_checkbox_include_np: str = "key_checkbox_include_np"
        checkbox_include_np = st.session_state.setdefault(k_checkbox_include_np, False)

        k_radio_colour_by: str = "key_radio_colour_by"
        options_radio_colour_by = ["Job", "Group"]
        radio_colour_by = st.session_state.setdefault(k_radio_colour_by, options_radio_colour_by[0])

        if not checkbox_include_machines:
            df_shopclock = df_shopclock[
                df_shopclock["EmployeeNumber"].str[0] == "2"
            ]

        if not checkbox_include_np:
            df_shopclock = df_shopclock[
                df_shopclock["JobNumber"] != "NP"
            ]

        keys_checkboxes_include_groups = {f"K_checkbox_include_group_{gi}": gi for gi in sorted(df_shopclock["GroupID"].dropna().unique())}
        checkboxes_include_groups = []
        with st.popover(f"Filter"):
            st.write(f"Groups:")
            cols_checkboxes = st.columns(len(keys_checkboxes_include_groups))
            st.divider()
            st.write(f"Other:")
            checkbox_include_machines = st.checkbox(
                label="Include Machines?",
                key=k_checkbox_include_machines
            )
            checkbox_include_np = st.checkbox(
                label="Include NP?",
                key=k_checkbox_include_np
            )

            st.divider()

            radio_colour_by = st.radio(
                label="Colour By:",
                key=k_radio_colour_by,
                options=options_radio_colour_by,
                index=0
            )

        for i, key in enumerate(keys_checkboxes_include_groups):
            st.session_state.setdefault(key, True)
            gi = keys_checkboxes_include_groups[key]
            with cols_checkboxes[i]:
                checkboxes_include_groups.append(st.checkbox(
                    label=f"{gi}",
                    key=key
                ))
            if not checkboxes_include_groups[-1]:
                df_shopclock = df_shopclock[df_shopclock["GroupID"] != gi]

        # display_df(
        #     df_shopclock,
        #     "df_shopclock"
        # )

        if not df_shopclock.empty:

            timeline_events = []
            lst_unique_jobs = df_shopclock["JobNumber"].unique()
            lst_unique_groups = df_shopclock["GroupName"].unique()
            colour_start = Colour("#DD2212")
            colour_end = Colour("#22DD12")
            colours_for_grad = [
                colour_start,
                colour_end
            ]
            wo_grad = gradient_merge(colours_for_grad.copy(), len(lst_unique_jobs), as_hex=True)
            group_grad = gradient_merge(colours_for_grad.copy(), len(lst_unique_groups), as_hex=True)
            wo_colour_map = {j: wo_grad[i] for i, j in enumerate(lst_unique_jobs)}
            group_colour_map = {g: group_grad[i] for i, g in enumerate(lst_unique_groups)}
            for i, row in df_shopclock.iterrows():
                timeline_events.append({
                    # "start": game.start_time_atl.strftime(UTC_FMT).removesuffix("Z"),
                    "Start Date": row["LoggedOn"],
                    # "end": (game.start_time_atl + datetime.timedelta(minutes=165)).strftime(UTC_FMT).removesuffix("Z"),
                    "End Date": datetime.datetime.now() if pd.isna(row["LoggedOff"]) else row["LoggedOff"],
                    "Event": f"{row['EmployeeName']} {row['EmployeeNumber']}",
                    "State": row["GroupName"] if radio_colour_by == options_radio_colour_by[1] else row["JobNumber"]
                })

            df_timeline_events = pd.DataFrame(timeline_events)
            # display_df(
            #     df_timeline_events,
            #     title="df_timeline_events",
            #     hide_index=False
            # )
            
            fig_timeline_games = px.timeline(
                df_timeline_events,
                x_start='Start Date',
                x_end='End Date',
                y='Event',
                title='ShopClock:',
                color='State',
                height=1200,
                color_discrete_map=group_colour_map if radio_colour_by == options_radio_colour_by[1] else wo_colour_map
            )

            # Update layout to make it more readable
            fig_timeline_games.update_layout(xaxis_title="Date", yaxis_title="ShopClock")

            # Display in Streamlit
            chart_widget = st.plotly_chart(fig_timeline_games)
            st.write(chart_widget)
        else:
            st.info(f"No data based on criteria. Check filters, if needed.")

    elif pills_search_mode == options_pills_search_mode.index(op_search_mode_syspro):
        # stockcode
        # Job
        # Operation
        # Journal
        # Operator

        df_job, df_stockcode, df_journal, df_operation, df_operator = load_syspro_issuing_values()

        k_checkbox_syspro_and_or: str = "key_checkbox_syspro_and_or"
        st.session_state.setdefault(k_checkbox_syspro_and_or, True)

        year_interval = 1.5
        k_combobox_syspro_stockcode: str = "key_combobox_syspro_stockcode"
        k_combobox_syspro_job: str = "key_combobox_syspro_job"
        k_combobox_syspro_operation: str = "key_combobox_syspro_operation"
        k_combobox_syspro_journal: str = "key_combobox_syspro_journal"
        k_combobox_syspro_operator: str = "key_combobox_syspro_operator"
        keys_syspro_searchboxes = [
            k_combobox_syspro_stockcode,
            k_combobox_syspro_job,
            k_combobox_syspro_operation,
            k_combobox_syspro_journal,
            k_combobox_syspro_operator
        ]
        for k in keys_syspro_searchboxes:
            st.session_state.setdefault(k, "")

        cols_syspro_search_boxes = st.columns(len(keys_syspro_searchboxes) + 1)

        with cols_syspro_search_boxes[0]:
            st.metric(
                label="Within +/- years",
                value=year_interval,
                border=True
            )
            checkbox_syspro_and_or = st.checkbox(
                label="And / Or",
                key=k_checkbox_syspro_and_or
            )
            if st.button(
                label="clear",
                key="key_btn_clear_syspro_search"
            ):
                st.session_state.update({k: "" for k in keys_syspro_searchboxes})
            # if st.button(
            #     label="search",
            #     key="key_btn_search_syspro_search"
            # ):
            #     st.rerun()

        with cols_syspro_search_boxes[1]:
            if st.button(
                label="x",
                key=f"{k_combobox_syspro_stockcode}_x",
            ):
                st.session_state.update({k_combobox_syspro_stockcode: ""})
            combobox_syspro_stockcode = st.selectbox(
                label="StockCode:",
                key=k_combobox_syspro_stockcode,
                options=sorted(df_stockcode["MStockCode"].unique(), key=lambda s: s.lower())
            )
        with cols_syspro_search_boxes[2]:
            if st.button(
                label="x",
                key=f"{k_combobox_syspro_job}_x",
            ):
                st.session_state.update({k_combobox_syspro_job: ""})
            combobox_syspro_job = st.selectbox(
                label="Job:",
                key=k_combobox_syspro_job,
                options=sorted(df_job["Job"].unique(), key=lambda s: s.lower())
            )
        with cols_syspro_search_boxes[3]:
            if st.button(
                label="x",
                key=f"{k_combobox_syspro_operation}_x",
            ):
                st.session_state.update({k_combobox_syspro_operation: ""})
            combobox_syspro_operation = st.selectbox(
                label="Operation:",
                key=k_combobox_syspro_operation,
                options=sorted(map(int, df_operation["LOperation"].unique()))
            )
        with cols_syspro_search_boxes[4]:
            if st.button(
                label="x",
                key=f"{k_combobox_syspro_journal}_x",
            ):
                st.session_state.update({k_combobox_syspro_journal: ""})
            combobox_syspro_journal = st.selectbox(
                label="Journal:",
                key=k_combobox_syspro_journal,
                options=sorted(map(int, df_journal["Journal"].unique()))
            )
        with cols_syspro_search_boxes[5]:
            if st.button(
                label="x",
                key=f"{k_combobox_syspro_operator}_x",
            ):
                st.session_state.update({k_combobox_syspro_operator: ""})
            combobox_syspro_operator = st.selectbox(
                label="Operator:",
                key=k_combobox_syspro_operator,
                options=sorted(df_operator["Operator"].unique(), key=lambda s: s.lower())
            )

        st.divider()
            
        if any([
            combobox_syspro_stockcode,
            combobox_syspro_job,
            combobox_syspro_operation,
            combobox_syspro_journal,
            combobox_syspro_operator
        ]):
            df_syspro_search = search_syspro_issuing(
                combobox_syspro_stockcode,
                combobox_syspro_job,
                combobox_syspro_operation,
                combobox_syspro_journal,
                combobox_syspro_operator,
                checkbox_syspro_and_or,
                year_int=year_interval
            )

            display_df_paginated(
                df_syspro_search,
                title="Results:",
                key="stdf_search_syspro_issuing",
                batch_size_options=(50, 100, 250)
            )

    # elif pills_search_mode == op_search_mode_day_totals:
    elif (user in admin_end_users) and (pills_search_mode == options_pills_search_mode.index(op_search_mode_day_totals)):
        pb_day = st.progress(value=0)
        pb_week = st.progress(value=0)
        asyncio.run(run_day())

    else:
        # Single
        k_textbox_stockcode = "key_textbox_stockcode"
        textbox_stockcode = st.text_input(
            label="Stockcode:",
            key=k_textbox_stockcode
        )
    
    ###############################################
    # If a stockcode is selected, then show details
    ###############################################

    if user in admin_end_users:
        with st.container(border=True):
            st.write(f"{pills_search_mode=}")
            st.write(f"{st.session_state.get(k_pills_search_mode)=}")
            st.write(f"{textbox_stockcode=}")

    if pills_search_mode in [
        options_pills_search_mode.index(op_search_mode_simple),
        options_pills_search_mode.index(op_search_mode_advanced),
        options_pills_search_mode.index(op_search_mode_by_so)
    ]:
        # searching for stockcode specific results

        selectbox_stockcode = None
        if textbox_stockcode:
            if textbox_stockcode.lower() in list_stockcodes:
                selectbox_stockcode = textbox_stockcode
            else:
                st.warning(f"Stockcode '{textbox_stockcode}' not found.")

        if selectbox_stockcode:
            df_stock_movements: pd.DataFrame = load_stockcode_movements(selectbox_stockcode)
            df_stock_movements.sort_values(
                by=["EntryDate", "TrnTime"],
                ascending=[False, False],
                inplace=True
            )
            df_stock_sales_orders: pd.DataFrame = load_so_details(stockcode=selectbox_stockcode)
            df_stock_sales_orders.sort_values(
                by="MCustRequestDat",
                ascending=False,
                inplace=True
            )
            df_stock_purchase_orders: pd.DataFrame = load_po_details(selectbox_stockcode)
            df_stock_purchase_orders.sort_values(
                by="MLatestDueDate",
                ascending=False,
                inplace=True
            )
            df_stock_allocations = load_allocations(selectbox_stockcode)
            df_stock_allocations.sort_values(
                by=["DateRequired", "TrnDateTime"],
                ascending=[True, False],
                inplace=True
            )

            if checkbox_warehouse_1_only:
                df_stock_movements = df_stock_movements[df_stock_movements["Warehouse"] == "01"]
                df_stock_allocations = df_stock_allocations[df_stock_allocations["Warehouse"] == "01"]
                # df_stock_sales_orders = df_stock_sales_orders[df_stock_sales_orders["Warehouse"] == "01"]
                # df_stock_purchase_orders = df_stock_purchase_orders[df_stock_purchase_orders["Warehouse"] == "01"]

            df_stock: pd.DataFrame = df_parts[df_parts["StockCode"].str.lower() == selectbox_stockcode.lower()]
            df_yt: pd.DataFrame = load_yellow_tags(selectbox_stockcode)

            if not df_stock.empty:
                ser_stock: pd.Series = df_stock.iloc[0]

                bin_location: str = ser_stock["DefaultBin"]
                qty_on_hand: float = ser_stock["QtyOnHand"]
                
                show_cols_info = [col for col in ser_stock.index if "qty" not in str(col).lower()]
                show_cols_qty = [col for col in ser_stock.index if "qty" in str(col).lower()]
                cols_information = st.columns([0.4, 0.2, 0.4])
                with cols_information[0]:
                    display_df(
                        ser_stock[show_cols_info],
                        title="Info",
                        width="stretch"
                    )

                    df_stock_pdf = load_path_pdf(selectbox_stockcode)
                    stock_pdf_listed = df_stock_pdf.loc[0, "PDF_Listed"]
                    stock_pdf_stock = df_stock_pdf.loc[0, "PDF_Stock"]
                    with st.popover(f"Drawings"):
                        if stock_pdf_listed or stock_pdf_stock:
                            f_name = f"{selectbox_stockcode.replace(' ', '_')}"
                            if stock_pdf_listed:
                                st.download_button(
                                    label="download PDF as listed in Syspro?",
                                    data=open(stock_pdf_listed, "rb").read(),
                                    file_name=f"{f_name}_syspro.pdf",
                                    mime="application/pdf",
                                    key=f"{f_name}_drive_2"
                                )
                            if stock_pdf_stock:
                                f_name = f"{selectbox_stockcode.replace(' ', '_')}"
                                st.download_button(
                                    label="Download found PDF from drive?",
                                    data=open(stock_pdf_stock, "rb").read(),
                                    file_name=f"{f_name}_found.pdf",
                                    mime="application/pdf",
                                    key=f"{f_name}_drive_3"
                                )
                        # else:
                        #     st.info(f"No PDFs found for this stockcode.")
                
                with cols_information[1]:
                    st.metric(
                        "Bin:",
                        value=bin_location
                    )
                    st.metric(
                        "On Hand:",
                        value=qty_on_hand
                    )
                    if st.button(
                        label="Submit a change?"
                    ):
                        submit_change(ser_stock)

                    df_stock_change_requests = df_change_requests[df_change_requests["stockcode"].str.lower() == selectbox_stockcode.lower()]
                    with st.popover("Previously Submitted Change Requests:", width=500):
                        if not df_stock_change_requests.empty:
                            for i, row in df_stock_change_requests.reset_index(drop=True).iterrows():
                                date_ = eval(row["date"])
                                user_ = row["user"]
                                field_ = row["field"]
                                old_ = row["old"].strip().replace("", "_")
                                new_ = row["new"]
                                notes_ = row["notes"]
                                done_ = row["completed"]
                                done_by_ = row["completed_by"]
                                done_date_ = row["completed_date"]
                                msg_0 = f"{date_}, {user_}"
                                msg_1 = f"{field_}: {old_} -> {new_}"
                                st.write(msg_0)
                                st.write(msg_1)
                                if notes_:
                                    st.write(f"{notes_}")
                                if i > 0:
                                    st.divider()
                            # display_df_paginated(
                            #     df_stock_change_requests,
                            #     title="Previously Submitted Change Requests:",
                            #     key="key_df_stock_change_requests"
                            # )

                with cols_information[2]:
                    display_df(
                        ser_stock[show_cols_qty],
                        title="Quantity Info",
                        width="stretch"
                    )
                    df_show_qty = pd.DataFrame(ser_stock[show_cols_qty]).transpose()
                    df_show_qty.columns = [col.replace("Qty", "") for col in df_show_qty.columns]
                    display_df(
                        # np.transpose(ser_stock[show_cols_qty]),
                        df_show_qty,
                        title="Quantity Info",
                        width="stretch"
                    )
                
                k_checkbox_movement_inc_issue = "key_checkbox_movement_inc_issue"
                checkbox_movement_inc_issue = st.session_state.setdefault(k_checkbox_movement_inc_issue, True)
                k_checkbox_movement_inc_sale = "key_checkbox_movement_inc_sale"
                checkbox_movement_inc_sale = st.session_state.setdefault(k_checkbox_movement_inc_sale, True)
                k_checkbox_movement_inc_rec = "key_checkbox_movement_inc_rec"
                checkbox_movement_inc_rec = st.session_state.setdefault(k_checkbox_movement_inc_rec, True)

                if not checkbox_movement_inc_issue:
                    df_stock_movements = df_stock_movements[
                        df_stock_movements["TrnType"] != "ISSUE"
                    ]
                if not checkbox_movement_inc_sale:
                    df_stock_movements = df_stock_movements[
                        df_stock_movements["TrnType"] != "SALE"
                    ]
                if not checkbox_movement_inc_rec:
                    df_stock_movements = df_stock_movements[
                        df_stock_movements["TrnType"] != "REC"
                    ]
                total_records: int = df_stock_movements.shape[0]

                with st.expander(f"Movements ({total_records}):", expanded=False):
                    k_max_records_movements = "key_max_records_movements"
                    st.session_state.setdefault(k_max_records_movements, df_stock_movements.shape[0])
                    if st.button(
                        "Show All?"
                    ):
                        st.session_state.update({
                            k_max_records_movements: total_records,
                            k_checkbox_movement_inc_issue: True,
                            k_checkbox_movement_inc_sale: True,
                            k_checkbox_movement_inc_rec: True
                        })
                        # st.rerun()

                    checkbox_movement_inc_issue = st.checkbox(
                        label="Include 'Issue' movements?",
                        key=k_checkbox_movement_inc_issue
                    )
                    checkbox_movement_inc_sale = st.checkbox(
                        label="Include 'Sale' movements?",
                        key=k_checkbox_movement_inc_sale
                    )
                    checkbox_movement_inc_rec = st.checkbox(
                        label="Include 'Rec' movements?",
                        key=k_checkbox_movement_inc_rec
                    )

                    # max_records_movements = st.number_input(
                    #     label="Max Records:",
                    #     key=k_max_records_movements,
                    #     min_value=0,
                    #     max_value=df_stock_movements.shape[0]
                    # )

                    # df_stock_movements = df_stock_movements.head(max_records_movements)

                    show_cols = df_stock_movements.columns.to_list()
                    cols_to_rem = [
                        "StockCode",
                        "EntryDate",
                        "TrnTime",
                        "Warehouse"
                    ]
                    # if checkbox_warehouse_1_only:
                    #     cols_to_rem.append("Warehouse")
                    for col in cols_to_rem:
                        show_cols.remove(col)

                    # display_df(
                    #     df_stock_movements,
                    #     "df_stock_movements"
                    # )

                    display_df_paginated(
                        df_stock_movements[show_cols],
                        # f"Movements for StockCode: {selectbox_stockcode}"
                        title=f"Total: ({total_records} Rows x {len(show_cols)} Cols) - Showing:",
                        width="stretch",
                        key=f"key_stdf_stock_movements"
                    )

                    # move_events = []
                    # for i, row in df_stock_movements.iterrows():
                    #     sc = row["StockCode"]
                    #     tt = row["TrnType"]
                    #     qty = row["TrnQty"]
                    #     ref = row["SalesOrder"] if ((not pd.isna(row["SalesOrder"])) and (row["SalesOrder"])) else row["Job"]
                    #     date_s = row["TrnDateTime"]
                    #     date_e = date_s + datetime.timedelta(minutes=10)
                    #     move_events.append({
                    #         "id": i,
                    #         "title": f"{tt} {qty} {ref}",
                    #         "start": date_s.strftime(UTC_FMT).removesuffix("Z"),
                    #         "end": date_e.strftime(UTC_FMT).removesuffix("Z")
                    #         # ,
                    #         # "url": NHL_URL.removesuffix("/") + row["game_center_link"]
                    #     })
                    #
                    # # print(move_events)
                    #
                    # k_cal_movements: str = "key_cal_movements"
                    # if k_cal_movements in st.session_state:
                    #     cm = st.session_state[k_cal_movements]
                    #     st.write(f"cm:")
                    #     st.write(cm)
                    #     es = cm.get("eventsSet", {})
                    #     view = es.get("view", {})
                    #     active_start = view.get("activeStart")
                    #     active_end = view.get("activeEnd")
                    #     if active_start is None:
                    #         active_start = datetime.datetime.now().isoformat()
                    #     if active_end is None:
                    #         active_end = datetime.datetime.now().replace(hour=23, minute=59, second=59).isoformat()
                    #     print(f"{active_start=}")
                    #     print(f"{active_end=}")
                    #     ac_s = datetime.datetime.fromisoformat(active_start)
                    #     ac_e = datetime.datetime.fromisoformat(active_end)
                    #     print(f"{ac_s=}")
                    #     print(f"{ac_e=}")
                    #     ac_m = ac_s + datetime.timedelta(seconds=(ac_e - ac_s).total_seconds() / 2)
                    #     if active_start and active_end:
                    #         me = []
                    #         for me in move_events:
                    #             start = datetime.datetime.fromisoformat(me["start"])
                    #             end = datetime.datetime.fromisoformat(me["end"])
                    #             if datetime_is_tz_aware(ac_m) and ((not datetime_is_tz_aware(start)) or (not datetime_is_tz_aware(end))):
                    #                 tz = ac_m.tzinfo
                    #                 start = start.replace(tzinfo=tz)
                    #                 end = end.replace(tzinfo=tz)
                    #             if datetime_is_tz_aware(start) and (not datetime_is_tz_aware(end)):
                    #                 tz = start.tzinfo
                    #                 end = end.replace(tzinfo=tz)
                    #             elif (not datetime_is_tz_aware(start)) and datetime_is_tz_aware(end):
                    #                 tz = end.tzinfo
                    #                 start = start.replace(tzinfo=tz)
                    #             if start <= ac_m <= end:
                    #                 me.append(me)
                    #         move_events = me
                    #
                    # st.write(move_events)
                    #
                    # cal_movements = calendar(
                    #     events=move_events,
                    #     options={
                    #         "multiMonthMaxColumns": 3,
                    #         "height": 1800,
                    #         "contentHeight": 500,
                    #         "expandRows": True,
                    #         "dayMaxEventRows": 10,  # unlimited rows per day (or set an int)
                    #         "eventDisplay": "block",
                    #         "displayEventTime": False,
                    #         "slotMinTime": "05:00:00",
                    #         "slotMaxTime": "17:30:00",
                    #         "initialView": "resourceTimelineDay"
                    #         # ,
                    #         # "moreLinkClick": "popover",  # still works without callbacks
                    #     },
                    #     key=k_cal_movements
                    # )
                    # st.write(cal_movements)
                
                k_checkbox_po_unfulfilled_only = "key_checkbox_po_unfulfilled_only"
                checkbox_po_unfulfilled_only = st.session_state.setdefault(k_checkbox_po_unfulfilled_only, True)
                if checkbox_po_unfulfilled_only:
                    df_stock_purchase_orders = df_stock_purchase_orders[
                        (df_stock_purchase_orders["MCompleteFlag"] != "Y")
                        & (df_stock_purchase_orders["MReceivedQty"] < df_stock_purchase_orders["MOrderQty"])
                    ]
                with st.expander(f"Purchase Orders ({df_stock_purchase_orders.shape[0]}):", expanded=bool(df_stock_purchase_orders.shape[0])):
                    k_checkbox_po_unfulfilled_only = "key_checkbox_po_unfulfilled_only"
                    st.session_state.setdefault(k_checkbox_po_unfulfilled_only, True)
                    checkbox_po_unfulfilled_only = st.checkbox(
                        label="Unfulfilled Purchase Orders Only?",
                        key=k_checkbox_po_unfulfilled_only
                    )

                    display_df(
                        df_stock_purchase_orders,
                        title="Purchase Orders",
                        width="stretch"
                    )
                
                k_checkbox_so_unfulfilled_only = "key_checkbox_so_unfulfilled_only"
                checkbox_so_unfulfilled_only = st.session_state.setdefault(k_checkbox_so_unfulfilled_only, True)
                if checkbox_so_unfulfilled_only:
                    df_stock_sales_orders = df_stock_sales_orders[
                        (df_stock_sales_orders["CancelledFlag"] != "Y")
                        & (df_stock_sales_orders["ActiveFlag"] != "N")
                    ]
                with st.expander(f"Sales Orders ({df_stock_sales_orders.shape[0]}):", expanded=bool(df_stock_sales_orders.shape[0])):
                    checkbox_so_unfulfilled_only = st.checkbox(
                        label="Unfulfilled Sales Orders Only?",
                        key=k_checkbox_so_unfulfilled_only
                    )

                    display_df(
                        df_stock_sales_orders,
                        title="Sales Orders",
                        width="stretch"
                    )

                    ttl_on_hand: float = ser_stock["QtyOnHand"]
                    run_ttl_on_hand: float = ttl_on_hand
                    for i, row in df_stock_sales_orders.iterrows():
                        qty_reqd: float = row["MBackOrderQty"]
                        if qty_on_hand is None:
                            qty_on_hand = row["MOrderQty"] - row["MShipQty"]
                        ttl_on_hand -= qty_reqd
                        run_ttl_on_hand -= qty_reqd
                        if ttl_on_hand >= 0:
                            if row["ActiveFlag"] == "1":
                                st.success(f"Enough on hand to fulfill SO# {row['SalesOrder']}.")
                                if st.button(f"Go To {row['SalesOrder']}"):
                                    st.session_state.update({
                                        k_pills_search_mode: options_pills_search_mode.index(op_search_mode_by_so),
                                        k_multiselect_sales_order_search: [row["SalesOrder"]]
                                        # k_pills_search_mode: options_pills_search_mode.index(op_search_mode_by_so)
                                    })
                                    st.rerun()
                        else:
                            st.error(f"Short {abs(ttl_on_hand)} {row['MOrderUom']} to fulfill SO# {row['SalesOrder']}")
                            ttl_on_hand = 0  # reset to 0 for order specific shortage count

                k_checkbox_alloc_unfulfilled_only: str = "key_checkbox_alloc_unfulfilled_only"
                checkbox_alloc_unfulfilled_only = st.session_state.setdefault(k_checkbox_alloc_unfulfilled_only, True)
                if checkbox_alloc_unfulfilled_only:
                    df_stock_allocations = df_stock_allocations[
                        (df_stock_allocations["AllocCompleted"] != "Y")
                    ]
                with st.expander(f"Allocations ({df_stock_allocations.shape[0]}):", expanded=bool(df_stock_allocations.shape[0])):
                    checkbox_alloc_unfulfilled_only = st.checkbox(
                        label="Unfulfilled Allocations Only?",
                        key=k_checkbox_alloc_unfulfilled_only
                    )

                    show_cols = df_stock_allocations.columns.to_list()
                    if checkbox_alloc_unfulfilled_only:
                        cols_to_drop = [
                            "TrnDateTime",
                            "AllocCompleted",
                        ]
                        if checkbox_warehouse_1_only:
                            cols_to_drop.append("Warehouse")
                        for col in cols_to_drop:
                            show_cols.remove(col)

                    display_df(
                        df_stock_allocations[show_cols],
                        title="Allocations",
                        width="stretch"
                    )

                k_checkbox_yt_unfulfilled_only: str = "key_checkbox_yt_unfulfilled_only"
                checkbox_yt_unfulfilled_only = st.session_state.setdefault(k_checkbox_yt_unfulfilled_only, True)
                if checkbox_yt_unfulfilled_only:
                    df_yt = df_yt[
                        (df_yt["Active"] == 1)
                    ]
                with st.expander(f"Yellow Tags ({df_yt.shape[0]})", expanded=bool(df_yt.shape[0])):
                    checkbox_yt_unfulfilled_only = st.checkbox(
                        label="Unfulfilled Yellow Tags Only?",
                        key=k_checkbox_yt_unfulfilled_only
                    )
                    display_df_paginated(
                        df_yt,
                        title="Yellow Tags",
                        key=f"key_stdf_yellow_tags"
                    )
                    
                    ttl_on_hand: float = ser_stock["QtyOnHand"]
                    run_ttl_on_hand: float = ttl_on_hand
                    for i, row in df_yt.iterrows():
                        qty_reqd: float = row["QtyMissing"]
                        ttl_on_hand -= qty_reqd
                        run_ttl_on_hand -= qty_reqd
                        if ttl_on_hand >= 0:
                            st.success(f"Enough on hand to fulfill Yellow Tag #{row['ID']} for WO# {row["WO"]} from {row['DateCreated']:%Y-%m-%d %H:%M:%S}.")
                        else:
                            st.error(f"Short {abs(ttl_on_hand)} to fulfill Yellow Tag #{row['ID']} for WO# {row["WO"]} from {row['DateCreated']:%Y-%m-%d %H:%M:%S}.")
                            ttl_on_hand = 0  # reset to 0 for order specific shortage count
            else:
                st.info(f"No parts found matching search criteria. Check your filters, if needed.")


    with cont_top_control:
        # FINALLY create the widget, this will allow for the state to be programatically changed.

        # st.write(f"{pills_search_mode=}")
        # st.write(f"{st.session_state.get(k_pills_search_mode)=}")
        #
        # psm = pills_search_mode if isinstance(pills_search_mode, str) else options_pills_search_mode[pills_search_mode]

        pills_search_mode = pills(
            label="Search Mode:",
            key=k_pills_search_mode,
            options=options_pills_search_mode,
            # index=options_pills_search_mode.index(psm)
            # index=pills_search_mode
            index=0
        )