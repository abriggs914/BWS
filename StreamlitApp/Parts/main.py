import random

from streamlit_utility import display_df, load_pdf_binary, display_df_paginated, get_selected_rows
from pyodbc_connection import connect
from streamlit_auth_sql import st_auth, show_change_password, save_user_settings, get_user_settings
from datetime_utility import time_between, datetime_is_tz_aware, is_date
from utility import percent, money, clamp
from colour_utility import Colour, random_colour, gradient_merge
from json_utility import jsonify
import reportlab_utility as rlu
import extract_drawing_parts as edp

from streamlit_pills import pills
from streamlit_plotly_events import plotly_events
from streamlit_calendar import calendar
from typing import Literal, Optional, Any
from collections import defaultdict, OrderedDict

import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D  # noqa: F401
import plotly.express as px
import plotly.graph_objects as go
import streamlit as st
import pandas as pd
import numpy as np
import pdfplumber
import datetime
import asyncio
import json
import math
import io
import os
import re


VERSION = (3, 0, 0)
VERSION_DATE = datetime.datetime(2026, 2, 9, 7, 40)
version_str: str = f"v{'.'.join(map(str, VERSION))}"


st.set_page_config(
	layout="wide",
	page_title=f"Parts {version_str}"
)

CHANGE_REQUEST_FILE: str = "change_requests.json"
PATH_STOCK_PDFS: str = r"J:\VaultWorkspace_BWS\PDFS"
UTC_FMT: str = "%Y-%m-%dT%H:%M:%SZ"
BUILDING_CODE_BOTH: int = 0
BUILDING_CODE_VMI: int = -2
BUILDING_CODE_HAWKINS: int = 1
BUILDING_CODE_MONTANA: int = 2
BUILDING_CODE_UNKNOWN: int = -99
PREFIX_PO_DD_RPT: str = "pos_due_"
PREFIX_PO_RD_RPT: str = "pos_rec_"

VALID_SALES_ORDER_ACTIVE_STATUS_CODES: list[str] = list(map(str, [1, 2]))


# def query(sql, **connection_data) -> pd.DataFrame:
# 	df = connect(sql, **connection_data)
# 	return df


@st.cache_data(ttl=60 * 60, show_spinner=True)
def load_bin_location_data() -> pd.DataFrame:
	#     sql_i = """
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
	SELECT 
		0 AS [ID], 'A' AS [Section]
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
	LTRIM(RTRIM([IW].[DefaultBin])) AS [DefaultBin],
	[IW].[Warehouse],
	COUNT(*) AS [NumItems],
	SUM([IW].[QtyOnHand] * [IW].[LastCostEntered]) AS [TtlItemValue],
	MIN([IW].[DateLastPurchase]) AS  [OldestPurchasedDate],
	MAX([IW].[DateLastPurchase]) AS  [NewestPurchasedDate],
	(CASE WHEN 
			(LOWER(LTRIM(RTRIM([IW].[DefaultBin]))) = 'vmi')
			OR (LOWER(LTRIM(RTRIM([IW].[DefaultBin]))) LIKE '%vend%')
		THEN -2
		WHEN 
			LOWER(LTRIM(RTRIM([IW].[DefaultBin]))) LIKE '%wh4%'
		THEN
			2 -- Montana Only
		WHEN
			LOWER(LTRIM(RTRIM([IW].[DefaultBin]))) LIKE '%@%'
		THEN 
			0 -- Both
		WHEN 
			(LOWER(LTRIM(RTRIM([IW].[DefaultBin]))) = '/') OR (ISNULL(LTRIM(RTRIM([IW].[DefaultBin])), '') = '')
		THEN
			-99 -- Unknown
		ELSE
			1 -- Hawkins Only
	END) AS [BuildingCode],
	(CASE WHEN 
			(LEN(LTRIM(RTRIM([IW].[DefaultBin]))) > 1) AND (LOWER(LTRIM(RTRIM([IW].[DefaultBin]))) LIKE '%/%')
		THEN
			1 -- Slash divides bins
		WHEN
			LOWER(LTRIM(RTRIM([IW].[DefaultBin]))) LIKE '%@%'
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
	(CASE WHEN LOWER(LEFT(LTRIM(RTRIM([IW].[DefaultBin])), 3)) = 'wh4' THEN (
			CASE WHEN LOWER(LEFT(SUBSTRING(LTRIM(RTRIM([IW].[DefaultBin])), 4, LEN(LTRIM(RTRIM([IW].[DefaultBin]))) - 3), 1)) = LOWER([KS].[Section]) THEN 1 ELSE 0 END
		)
		WHEN LOWER(LEFT(LTRIM(RTRIM([IW].[DefaultBin])), 1)) = LOWER([KS].[Section]) THEN 1
		ELSE 0
	END) > 0
GROUP BY
	LTRIM(RTRIM([IW].[DefaultBin])),
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
	[BC1].[HasMultipleBins],
	[BC1].[OldestPurchasedDate],
	[BC1].[NewestPurchasedDate]
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


@st.cache_data(ttl=60 * 15, show_spinner=True)
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
	[AS].[SupShortName],
	[IM].[ProductClass],
	[IM].[CycleCount],
	[IW].[UnitCost]
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


@st.cache_data(ttl=60 * 60, show_spinner=True)
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
	df["TrnType"] = df["TrnType"].apply(lambda mt: "ISSUE" if mt == "I" else (
		"REC" if mt == "R" else ("ADJ" if mt == "A" else ("SALE" if mt == "S" else mt))))
	df["SalesOrder"] = df["SalesOrder"].apply(lambda so: so_fmt(so, "int"))
	# display_df(df, "FETCH MOVEMENTS B")
	return df


@st.cache_data(ttl=60 * 60, show_spinner=True)
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


@st.cache_data(ttl=60 * 60, show_spinner=True)
def load_po_details(stockcode: Optional[str] = None, purchaseorder: Optional[str] = None) -> pd.DataFrame:
	if ((stockcode is None) and (purchaseorder is None)) or ((stockcode is not None) and (purchaseorder is not None)):
		raise ValueError(
			f"Must pass either a PurchaseOrder # or a StockCode #. Got '{stockcode=}', '{purchaseorder=}'.")
	sc_mode: bool = stockcode is not None
	if sc_mode:
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
	
		[PH].[Supplier] AS [PHSupplier],
	
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
	LEFT JOIN
		[SysproCompanyA].[dbo].[PorMasterHdr] [PH] WITH (NOLOCK)
	ON
		[PD].[PurchaseOrder] = [PH].[PurchaseOrder]
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
		[PH].[Supplier] = [AS].[Supplier]
	WHERE
		(
			(ISNULL([MStockCode], '') <> '')
			OR (ISNULL([MOrderQty], 0) <> 0)
		)
		AND (LOWER([PD].[MStockCode]) = LOWER('{stockcode}'))
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
	
		[PH].[Supplier] AS [PHSupplier],
	
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
	LEFT JOIN
		[SysproCompanyA].[dbo].[PorMasterHdr] [PH] WITH (NOLOCK)
	ON
		[PD].[PurchaseOrder] = [PH].[PurchaseOrder]
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
		[PH].[Supplier] = [AS].[Supplier]
	WHERE
		(
			(ISNULL([MStockCode], '') <> '')
			OR (ISNULL([MOrderQty], 0) <> 0)
		)
		AND (LOWER([PD].[PurchaseOrder]) = LOWER('{po_fmt(purchaseorder, "str")}'))
;
	"""
	df = connect(sql)
	df["PurchaseOrder"] = df["PurchaseOrder"].apply(lambda po: po_fmt(po, "int"))
	df["MOrigDueDate"] = pd.to_datetime(df["MOrigDueDate"], errors="ignore").dt.date
	df["MLatestDueDate"] = pd.to_datetime(df["MLatestDueDate"], errors="ignore").dt.date
	return df


@st.cache_data(ttl=60 * 60, show_spinner=True)
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


@st.cache_data(ttl=60 * 60, show_spinner=True)
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


@st.cache_data(ttl=60 * 60, show_spinner=True)
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


@st.cache_data(ttl=60 * 60, show_spinner=True)
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


@st.cache_data(ttl=60 * 60, show_spinner=True)
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


@st.cache_data(ttl=60 * 60, show_spinner=True)
def load_purchase_orders() -> pd.DataFrame:
	"""Load Purchase Order data by header, only 1 record per Purchase Order"""
	sql = """
SELECT
	[PM].[PurchaseOrder],
	[PM].[ExchangeRate],
	[PM].[OrderEntryDate],
	[PM].[OrderDueDate],
	
	[PM].[OrderStatus],
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
	[PS].[Nationality],
	
	[PD].[MStockCode],
	[PD].[MLastReceiptDat],
	[PD].[MLatestDueDate],
	[PD].[MReceivedQty]
FROM
	[SysproCompanyA].[dbo].[PorMasterHdr] [PM] WITH (NOLOCK)
LEFT JOIN
	[SysproCompanyA].[dbo].[PorMasterDetail] [PD] WITH (NOLOCK)
ON
	[PM].[PurchaseOrder] = [PD].[PurchaseOrder]
INNER JOIN
	[SysproCompanyA].[dbo].[ApSupplier] [PS] WITH (NOLOCK)
ON
	[PM].[Supplier] = [PS].[Supplier]
WHERE
	ISNULL([PM].[OrderDueDate], GETDATE()) >= DATEADD(YEAR, -3.5, GETDATE())
	AND ISNULL([PM].[OrderDueDate], GETDATE()) <= DATEADD(YEAR, 3.5, GETDATE())
;
"""
	df = connect(sql)
	df["PurchaseOrder"] = df["PurchaseOrder"].apply(lambda po: po_fmt(po, "int"))
	df["OrderEntryDate"] = pd.to_datetime(df["OrderEntryDate"], errors="ignore").dt.date
	df["OrderDueDate"] = pd.to_datetime(df["OrderDueDate"], errors="ignore").dt.date
	df["MLatestDueDate"] = pd.to_datetime(df["MLatestDueDate"], errors="ignore").dt.date
	return df


@st.cache_data(ttl=60 * 60, show_spinner=True)
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


@st.cache_data(ttl=60 * 60, show_spinner=True)
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


@st.cache_data(ttl=60 * 60, show_spinner=True)
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
		with st.expander(f"sql_i"):
			st.code(
				sql,
				language="sql_i",
				line_numbers=True
			)
	return df


@st.cache_data(ttl=60 * 60, show_spinner=True)
def load_warranty_claims() -> pd.DataFrame:
	sql = """
	SELECT
		[WC].[Claim Number]
	FROM
		[BWSdb].[dbo].[Warranty Claims] [WC]
	GROUP BY
		[WC].[Claim Number]
	;
		"""
	df = connect(sql)
	df["Claim Number"] = df["Claim Number"].apply(lambda cn: int(cn))
	return df


@st.cache_data(ttl=60 * 60, show_spinner=True)
def load_jobs() -> pd.DataFrame:
	sql = """
SELECT
	[WM].[Job]
FROM
	[SysproCompanyA].[dbo].[WipMaster] [WM]
WHERE
	ISNULL([WM].[Complete], 'N') = 'N'
GROUP BY
	[WM].[Job]
;
	"""
	return connect(sql)


@st.cache_data(ttl=60 * 60, show_spinner=True)
def load_warranty_data(job: Optional[int] = None, claim: Optional[int] = None) -> pd.DataFrame:

	if (job is None) and (claim is None):
		raise ValueError("Must specify either job or claim")

	claim_mode: int = 0
	if job is None:
		# use claim
		job = claim
		claim_mode = 1

	sql = f"""
	DECLARE @war_wo NVARCHAR(8) = '{job}';
	DECLARE @claim_mode BIT = {claim_mode};
	
	IF @claim_mode = 0 BEGIN
		IF LEN(@war_wo) <> 8 BEGIN
			SET @war_wo = '3' + RIGHT('00000000' + SUBSTRING(ISNULL(@war_wo, ' '), 1, (CASE WHEN LEN(ISNULL(@war_wo, ' ')) < 5 THEN LEN(ISNULL(@war_wo, ' ')) ELSE 5 END)), 7)
		END
	END
		
	SELECT
	[WM].[Job],
	[WM].[JobDescription],
	--[WM].[StockCode],
	--[WM].[StockDescription],
	--[WM].[QtyToMake],
	[WJM].[StockCode],
	[WJM].[StockDescription],
	[WJM].[QtyIssued],
	[WJM].[QtyToIssue],
	[WC].[Claim Date],
	[WC].[Claim Number],
	[WC].[BWS Invoice #],
	[WC].[WO#],
	[WC].[Customer],
	[WC].[Dealer],
	[WC].[S/N]
	
	--,*
FROM
	[BWSdb].[dbo].[Warranty Claims] [WC]
LEFT JOIN
	[SysproCompanyA].[dbo].[WipMaster] [WM]
ON
	LOWER([WM].[JobDescription]) LIKE '%' + LOWER([WC].[WO#]) + '%'
	--AND LOWER([WM].[JobDescription]) LIKE '%' + LOWER([WC].[Claim Number]) + '%'
LEFT JOIN
	[SysproCompanyA].[dbo].[WipJobAllMat] [WJM]
ON
	--(CAST([WC].[WO#] AS NVARCHAR(MAX)) = [WJM].[Job] COLLATE DATABASE_DEFAULT)
	--AND
	([WM].[Job] = [WJM].[Job])
	"""
	if claim is None:
		sql += """
		WHERE
			[WM].[Job] = @war_wo
		"""
	else:
		sql += """
		WHERE
			[WC].[Claim Number] = @war_wo
		"""
	df = connect(sql)
	return df


@st.cache_data(ttl=60 * 60, show_spinner=True)
def load_pick_list(job: str, from_op: int = 12, to_op: int = 18) -> pd.DataFrame:
	sql = f"""
SELECT 
	[v_NewPickList].[Job],
	[v_NewPickList].[JobDescription],
	[v_NewPickList].[StockCode], 
	[v_NewPickList].[StockDescription], 
	[v_NewPickList].[LongDesc],
	[v_NewPickList].[Warehouse], 
	[v_NewPickList].[UnitQtyReqd], 
	[v_NewPickList].[OperationOffset], 
	[v_NewPickList].[Uom], 
	[v_NewPickList].[Bin], 
	[v_NewPickList].[QtyIssued], 
	[v_NewPickList].[ProductClass], 
	[v_NewPickList].[SubWO], 
	[v_NewPickList].[SubWOJobDescription], 
	[v_NewPickList].[QtyAvailable], 
	(CASE WHEN [UnitQtyReqd]-[QtyIssued] <=0 THEN 0 ELSE [UnitQtyReqd]-[QtyIssued] END) AS [QtyToPick]
FROM 
	[SysproCompanyA].[dbo].[v_NewPickList]
WHERE 
	([v_NewPickList].[Job] = '{job}')
	AND ([v_NewPickList].[OperationOffset] BETWEEN {from_op} AND {to_op})
	--AND ([UnitQtyReqd]-[QtyIssued] <> 0)
;
	"""
	return connect(sql)


@st.cache_data(ttl=60 * 60, show_spinner=True)
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


@st.cache_data(ttl=60 * 60, show_spinner=True)
def load_path_pdf(stockcode: Optional[str] = None, all_stockcodes: bool = False) -> pd.DataFrame:
	s_d = datetime.datetime.now()
	if user in admin_test_users:
		with st.container(border=True, horizontal=True):
			st.write(f"BEGIN load_path_pdf {s_d:%Y-%m-%d %H:%M:%S}")

	if (stockcode is None) and (not all_stockcodes):
		raise ValueError("'stockcode' or 'all_stockcodes' should be specified")
	str_size = 256
	sql = f"""
SELECT
	CAST(LEFT([IM].[DrawOfficeNum], {str_size}) AS NVARCHAR({str_size})) AS [PDF_Listed],
	CAST(LEFT([IM].[StockCode], {str_size}) AS NVARCHAR({str_size})) AS [PDF_Stock]
FROM
	[SysproCompanyA].[dbo].[InvMaster] [IM] WITH (NOLOCK)
"""
	if not all_stockcodes:
		sql += f"""
WHERE
	LOWER([IM].[StockCode]) = LOWER('{stockcode}')
"""
	df = connect(sql, **dict(uid="SRS", pwd=""))
	m_d = datetime.datetime.now()
	if user in admin_test_users:
		with st.container(border=True, horizontal=True):
			e_d = datetime.datetime.now()
			st.write(f"MID load_path_pdf {m_d:%Y-%m-%d %H:%M:%S}")

			dd = (m_d-s_d).total_seconds()
			st.write(f"{dd} seconds past")
	df["StockCode"] = df["PDF_Stock"]
	for col in [
		"PDF_Listed",
		"PDF_Stock"
	]:
		df[col] = df[col].apply(
			lambda p:
			os.path.join(PATH_STOCK_PDFS, f"{str(p).removesuffix('.pdf')}.pdf") if ((not pd.isna(p)) and p) else None
		)
		# df[col] = df[col].apply(lambda p: p if os.path.exists(p) else None)
	df = df[~pd.isna(df["PDF_Listed"]) | ~pd.isna(df["PDF_Stock"])]
	if user in admin_test_users:
		with st.container(border=True, horizontal=True):
			e_d = datetime.datetime.now()
			st.write(f"END load_path_pdf {e_d:%Y-%m-%d %H:%M:%S}")

			dd = (e_d-s_d).total_seconds()
			st.write(f"{dd} total seconds")
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


def prep_inv_by_bin_report(f_name: str, title: str, df: pd.DataFrame):
	date_str = f"{datetime.datetime.now():%Y-%m-%d %H:%M}"
	report_file_name: str = f_name.format(DATE=date_str.replace(":", "").replace("-", "").strip())
	report_subtitle: str = f"Generated: {date_str}"
	report_title: str = title
	report_author: str = f"{user}"

	theme = rlu.PDFTheme(
		page_size=rlu.portrait(rlu.LETTER),
		margin_left=0.35 * rlu.inch,
		margin_right=0.35 * rlu.inch,
		margin_top=0.40 * rlu.inch,
		margin_bottom=0.40 * rlu.inch,
		header_height=0.25 * rlu.inch,
		footer_height=0.25 * rlu.inch,
		table_header_bg=rlu.colors.HexColor("#ADADAD")
	)
	meta = rlu.PDFMeta(
		title=report_title,
		subtitle=report_subtitle,
		author=report_author
	)
	styles = rlu.build_styles(theme)

	out, doc = rlu.build_pdf(
		report_file_name,
		story=None,
		theme=theme,
		meta=meta,
		as_zip=False
	)
	buf = out
	rlu.add_grid_template(
		doc,
		theme,
		template_id="dash",
		height=0.85,
		rows=1,
		cols=1,
		gutter=0.05 * rlu.inch,
		merged_cells=[
			[0, 0, 1, 1]
		]
	)
	doc._firstPageTemplateIndex = next(
		i for i, t in enumerate(doc.pageTemplates) if t.id == "dash"
	)

	story = []


	# # cell 0, 0
	# story += [rlu.FrameBreak()]
	#
	# # cell 0, 1
	# story += [
	# 	rlu.h3(f"{cust_name}", styles),
	# 	rlu.h3(f"{ship_addr_0}", styles),
	# 	rlu.h3(f"{ship_addr_1}", styles),
	# 	rlu.h3(f"{ship_addr_2}", styles),
	# 	rlu.FrameBreak()
	# ]

	# cell 1, 0

	num_cols = [c for c in df.columns if df[c].dtype in ("int64", "float64")]
	num_fmts = dict(zip(num_cols, ["{:,.2f}" for i in range(len(num_cols))]))
	mon_cols = [c for c in df.columns if (df[c].dtype in ("int64", "float64")) and ("$" in c)]
	for c in mon_cols:
		num_fmts[c] = "$ {:,.2f}"

	story += [
		rlu.df_table(df, theme, styles, number_format=num_fmts),
		rlu.FrameBreak()
	]
	# print(f"out:")
	# print(out)
	# print(f"story:")
	# print(story)
	doc.build(story)

	if out is not None:
		f_name = out.resolve()
		print(f"Wrote: {f_name}")
	if buf is not None:
		# return buf.getvalue()
		return buf, report_file_name
	return f_name, report_file_name


def prep_pick_list_report(report_file_name: str, title: str, date_str: str, df: pd.DataFrame):
	report_subtitle: str = f"Generated: {date_str}"
	report_title: str = title
	report_author: str = f"{user}"

	theme = rlu.PDFTheme(
		page_size=rlu.landscape(rlu.LETTER),
		margin_left=0.35 * rlu.inch,
		margin_right=0.35 * rlu.inch,
		margin_top=0.40 * rlu.inch,
		margin_bottom=0.40 * rlu.inch,
		header_height=0.25 * rlu.inch,
		footer_height=0.25 * rlu.inch,
		table_header_bg=rlu.colors.HexColor("#ADADAD")
	)
	meta = rlu.PDFMeta(
		title=report_title,
		subtitle=report_subtitle,
		author=report_author
	)
	styles = rlu.build_styles(theme)

	out, doc = rlu.build_pdf(
		report_file_name,
		story=None,
		theme=theme,
		meta=meta,
		as_zip=False
	)
	buf = out
	rlu.add_grid_template(
		doc,
		theme,
		template_id="dash",
		height=0.85,
		rows=1,
		cols=1,
		gutter=0.05 * rlu.inch,
		merged_cells=[
			[0, 0, 1, 1]
		]
	)
	doc._firstPageTemplateIndex = next(
		i for i, t in enumerate(doc.pageTemplates) if t.id == "dash"
	)

	story = []

	num_cols = [c for c in df.columns if df[c].dtype in ("int64", "float64")]
	num_fmts = dict(zip(num_cols, ["{:,.2f}" for i in range(len(num_cols))]))
	mon_cols = [c for c in df.columns if (df[c].dtype in ("int64", "float64")) and ("$" in c)]
	for c in mon_cols:
		num_fmts[c] = "$ {:,.2f}"

	story += [
		rlu.df_table(
			df,
			theme,
			styles,
			number_format=num_fmts,
			target_width=doc.width
		),
		rlu.FrameBreak()
	]
	# print(f"out:")
	# print(out)
	# print(f"story:")
	# print(story)
	doc.build(story)

	if out is not None:
		f_name = out.resolve()
		print(f"Wrote: {f_name}")
	if buf is not None:
		# return buf.getvalue()
		return buf, report_file_name
	return f_name, report_file_name


@st.cache_data(ttl=60 * 60, show_spinner=True)
def load_layout_data(building: str = "Hawkins") -> dict[str, pd.DataFrame]:
	# pth_layout: str = r"G:\IT\Network Port Layout\BWS\Hawkins Warehouse Layout Rev3 202601050840.xlsx"

	if not building:
		building = "Hawkins"
	if building.lower() == "montana":
		t_data = {
			"Layout": "INV_WarehouseLayout_Montana",
			"Legend": "INV_WarehouseLayout_Legend",
			"Shelves": "INV_WarehouseLayout_MontanaShelves",
			"ShelfSections": "INV_WarehouseShelfSections_Montana",
		}
	else:
		t_data = {
			"Layout": "INV_WarehouseLayout_Hawkins",
			"Legend": "INV_WarehouseLayout_Legend",
			"Shelves": "INV_WarehouseLayout_HawkinsShelves",
			"ShelfSections": "INV_WarehouseShelfSections_Hawkins",
		}

	data = {}
	for name, t_name in t_data.items():
		data[name] = connect(t_name)
		if "Active" in data[name].columns:
			data[name] = data[name].loc[data[name]["Active"] == 1]

	return data


def build_legend_bg_map(df_legend: pd.DataFrame) -> dict[str, str]:
	cols = {c.lower(): c for c in df_legend.columns}
	k_col = cols.get("key")
	bg_col = cols.get("bg")
	if not (k_col and bg_col):
		raise ValueError("Legend must contain columns Key and BG")

	bg_map = {}
	for _, r in df_legend.iterrows():
		k = r.get(k_col)
		bg = r.get(bg_col)
		# if pd.isna(k) or pd.isna(bg):
		# 	continue
		key = str(k).strip().upper() if k is not None else None
		hx = str(bg).strip().upper()
		if not hx.startswith("#"):
			hx = "#" + hx
		if len(hx) == 7:
			bg_map[key] = hx
	return bg_map


def rotate_img(img: np.ndarray, rotation_deg: int) -> np.ndarray:
	rotation_deg = rotation_deg % 360
	if rotation_deg == 0:
		return img
	if rotation_deg == 90:  # clockwise
		return np.rot90(img, k=3)
	if rotation_deg == 180:
		return np.rot90(img, k=2)
	if rotation_deg == 270:  # counter-clockwise
		return np.rot90(img, k=1)
	raise ValueError("rotation_deg must be one of: 0, 90, 180, 270")


def rot_point_xy(x: float, y: float, W: int, H: int, rotation_deg: int) -> tuple[float, float]:
	r = rotation_deg % 360
	if r == 0:
		return x, y
	if r == 90:  # cw
		return (H - 1 - y), x
	if r == 180:
		return (W - 1 - x), (H - 1 - y)
	if r == 270:  # ccw
		return y, (W - 1 - x)
	raise ValueError("rotation_deg must be 0/90/180/270")


def inv_rot_point_xy(xr: float, yr: float, W: int, H: int, rotation_deg: int) -> tuple[float, float]:
	r = rotation_deg % 360
	if r == 0:
		return xr, yr
	if r == 90:  # inverse of cw is ccw
		return yr, (H - 1 - xr)
	if r == 180:
		return (W - 1 - xr), (H - 1 - yr)
	if r == 270:  # inverse of ccw is cw
		return (W - 1 - yr), xr
	raise ValueError("rotation_deg must be 0/90/180/270")


def rot_rect(df_sections: pd.DataFrame, W: int, H: int, rotation_deg: int) -> pd.DataFrame:
	"""
	Returns a copy of df_sections with rotated X0/X1/Y0/Y1 for plotting.
	Assumes df_sections uses X0<X1, Y0<Y1 in original coords.
	"""
	df = df_sections.copy()

	xs0, ys0 = [], []
	xs1, ys1 = [], []

	for _, row in df.iterrows():
		x0, x1, y0, y1 = float(row["X0"]), float(row["X1"]), float(row["Y0"]), float(row["Y1"])
		# after changing to SQL tables, need to offset the indexes to match
		if rotation_deg == 90:
			y0 -= 1
			y1 -= 1
		elif rotation_deg == 180:
			x0 -= 1
			x1 -= 1
			y0 -= 1
			y1 -= 1
		elif rotation_deg == 270:
			x0 -= 1
			x1 -= 1

		# transform the 4 corners and compute new bounds
		corners = [
			(x0, y0),
			(x0, y1),
			(x1, y0),
			(x1, y1),
		]
		rot_c = [rot_point_xy(x, y, W=W, H=H, rotation_deg=rotation_deg) for x, y in corners]
		xs = [p[0] for p in rot_c]
		ys = [p[1] for p in rot_c]

		xs0.append(min(xs))
		xs1.append(max(xs))
		ys0.append(min(ys))
		ys1.append(max(ys))

	df["X0r"] = xs0
	df["X1r"] = xs1
	df["Y0r"] = ys0
	df["Y1r"] = ys1
	return df


def find_section_at_point(df_sections: pd.DataFrame, x: float, y: float) -> pd.Series | None:
	hits = df_sections[
		(df_sections["X0"] <= x) & (x < df_sections["X1"]) &
		(df_sections["Y0"] <= y) & (y < df_sections["Y1"])
		]
	if hits.empty:
		return None
	# If overlaps exist, pick the smallest area match
	hits = hits.copy()
	hits["Area"] = (hits["X1"] - hits["X0"]) * (hits["Y1"] - hits["Y0"])
	hits = hits.sort_values(["Area", "ID"])
	return hits.iloc[0]


def plotly_skyscrapers(df_sec_val, z_log=True, title="Valuation 3D"):
	z = df_sec_val["TtlValue"].to_numpy(float)
	z_plot = np.log10(z + 1) if z_log else z

	fig = go.Figure()

	for _, r in df_sec_val.iterrows():
		z0 = 0
		z1 = np.log10(r["TtlValue"] + 1) if z_log else r["TtlValue"]
		fig.add_trace(go.Scatter3d(
			x=[r["cx"], r["cx"]],
			y=[r["cy"], r["cy"]],
			z=[z0, z1],
			mode="lines",
			hovertemplate=(
				f"Section: <b>{r['Section']}</b><br>"
				f"Value: <b>{r['TtlValue']:,.2f}</b><extra></extra>"
			),
			showlegend=False
		))

	fig.update_layout(
		title=title,
		scene=dict(
			xaxis_title="X",
			yaxis_title="Y",
			zaxis_title="log10(Value+1)" if z_log else "Value",
		),
		margin=dict(l=0, r=0, t=40, b=0),
	)
	return fig


def add_section_floor_outlines(fig: go.Figure, df_sec_geo, *, opacity=0.8, line_width=4):
	for r in df_sec_geo.itertuples(index=False):
		x0, x1, y0, y1 = float(r.X0), float(r.X1), float(r.Y0), float(r.Y1)

		# closed loop rectangle on z=0
		xs = [x0, x1, x1, x0, x0]
		ys = [y0, y0, y1, y1, y0]
		zs = [0, 0, 0, 0, 0]

		fig.add_trace(go.Scatter3d(
			x=xs, y=ys, z=zs,
			mode="lines",
			line=dict(width=line_width),
			opacity=opacity,
			hovertemplate=f"Section: <b>{getattr(r, 'Section', '')}</b><extra></extra>",
			showlegend=False,
		))
	return fig


# def add_compass(fig: go.Figure, *, x_min, x_max, y_min, y_max, z=0, size=8):
# 	# place compass near bottom-left of the floor
# 	base_x = x_min + (x_max - x_min) * 0.08
# 	base_y = y_min + (y_max - y_min) * 0.08
#
# 	# N arrow (+Y)
# 	fig.add_trace(go.Scatter3d(
# 		x=[base_x, base_x],
# 		y=[base_y, base_y + size],
# 		z=[z, z],
# 		mode="lines",
# 		line=dict(width=6),
# 		showlegend=False,
# 		hoverinfo="skip"
# 	))
# 	fig.add_trace(go.Cone(
# 		x=[base_x], y=[base_y + size], z=[z],
# 		u=[0], v=[1], w=[0],  # direction +Y
# 		sizemode="absolute",
# 		sizeref=0.8,
# 		showscale=False,
# 		hoverinfo="skip"
# 	))
# 	fig.add_trace(go.Scatter3d(
# 		x=[base_x],
# 		y=[base_y + size + size * 0.25],
# 		z=[z],
# 		mode="text",
# 		text=["N"],
# 		textfont=dict(size=18),
# 		showlegend=False,
# 		hoverinfo="skip"
# 	))
#
# 	# E arrow (+X)
# 	fig.add_trace(go.Scatter3d(
# 		x=[base_x, base_x + size],
# 		y=[base_y, base_y],
# 		z=[z, z],
# 		mode="lines",
# 		line=dict(width=6),
# 		showlegend=False,
# 		hoverinfo="skip"
# 	))
# 	fig.add_trace(go.Cone(
# 		x=[base_x + size], y=[base_y], z=[z],
# 		u=[1], v=[0], w=[0],  # direction +X
# 		sizemode="absolute",
# 		sizeref=0.8,
# 		showscale=False,
# 		hoverinfo="skip"
# 	))
# 	fig.add_trace(go.Scatter3d(
# 		x=[base_x + size + size * 0.25],
# 		y=[base_y],
# 		z=[z],
# 		mode="text",
# 		text=["E"],
# 		textfont=dict(size=18),
# 		showlegend=False,
# 		hoverinfo="skip"
# 	))
#
# 	return fig

def add_compass_rotated(
		fig: go.Figure,
		*,
		x_min: float,
		x_max: float,
		y_min: float,
		y_max: float,
		z: float = 0.0,
		size: float | None = None,
		rotation_deg: float = 0.0,
		corner: Literal["ne", "nw", "se", "sw"] = "sw",
		pad_frac: float = 0.08,  # fraction of map size used as padding
):
	"""
	Adds a rotated N/E compass to a Plotly 3D figure.

	corner:
		"ne" = top-right
		"nw" = top-left
		"se" = bottom-right
		"sw" = bottom-left
	"""

	# Default compass size
	if size is None:
		size = (x_max - x_min) * 0.08

	# Padding offsets
	pad_x = (x_max - x_min) * pad_frac
	pad_y = (y_max - y_min) * pad_frac

	# Base anchor by corner
	if corner == "sw":
		base_x = x_min + pad_x
		base_y = y_min + pad_y
	elif corner == "se":
		base_x = x_max - pad_x
		base_y = y_min + pad_y
	elif corner == "nw":
		base_x = x_min + pad_x
		base_y = y_max - pad_y
	elif corner == "ne":
		base_x = x_max - pad_x
		base_y = y_max - pad_y
	else:
		raise ValueError(f"Invalid corner: {corner}")

	# Rotation math (Z-axis rotation)
	th = np.deg2rad(rotation_deg)

	# Direction vectors
	ex, ey = np.cos(th), np.sin(th)  # East
	nx, ny = -np.sin(th), np.cos(th)  # North (90° CCW)

	# Endpoints
	ex2, ey2 = base_x + size * ex, base_y + size * ey
	nx2, ny2 = base_x + size * nx, base_y + size * ny

	# East arrow
	fig.add_trace(go.Scatter3d(
		x=[base_x, ex2],
		y=[base_y, ey2],
		z=[z, z],
		mode="lines+text",
		text=["", "E"],
		textposition="top center",
		line=dict(width=6),
		showlegend=False,
		hoverinfo="skip",
		textfont=dict(size=18)
	))

	# North arrow
	fig.add_trace(go.Scatter3d(
		x=[base_x, nx2],
		y=[base_y, ny2],
		z=[z, z],
		mode="lines+text",
		text=["", "N"],
		textposition="top center",
		line=dict(width=6),
		showlegend=False,
		hoverinfo="skip",
		textfont=dict(size=18)
	))

	return fig


def flip_y_value(y: float, y_min: float, y_max: float) -> float:
	return (y_min + y_max) - y


def flip_y_rect_df(df, *, y_min: float, y_max: float, y0c="Y0", y1c="Y1"):
	out = df.copy()
	y0f = out[y0c].astype(float).apply(lambda v: flip_y_value(v, y_min, y_max))
	y1f = out[y1c].astype(float).apply(lambda v: flip_y_value(v, y_min, y_max))
	out[y0c] = np.minimum(y0f, y1f)
	out[y1c] = np.maximum(y0f, y1f)
	return out


def flip_y_points_df(df, *, y_min: float, y_max: float, yc="cy"):
	out = df.copy()
	out[yc] = out[yc].astype(float).apply(lambda v: flip_y_value(v, y_min, y_max))
	return out


def flip_x_value(x: float, x_min: float, x_max: float) -> float:
	return (x_min + x_max) - x


def flip_x_rect_df(df, *, x_min: float, x_max: float, x0c="X0", x1c="X1"):
	out = df.copy()
	x0f = out[x0c].astype(float).apply(lambda v: flip_x_value(v, x_min, x_max))
	x1f = out[x1c].astype(float).apply(lambda v: flip_x_value(v, x_min, x_max))
	out[x0c] = np.minimum(x0f, x1f)
	out[x1c] = np.maximum(x0f, x1f)
	return out


def flip_x_points_df(df, *, x_min: float, x_max: float, xc="cx"):
	out = df.copy()
	out[xc] = out[xc].astype(float).apply(lambda v: flip_x_value(v, x_min, x_max))
	return out


@st.cache_data(ttl=60 * 63, show_spinner=True)
def layout_to_rgb_image(df_layout: pd.DataFrame, bg_map: dict[str, str], default_bg="#FFFFFF") -> np.ndarray:
	default_rgb = Colour(default_bg).rgb_code

	nrows, ncols = df_layout.shape
	img = np.zeros((nrows, ncols, 3), dtype=np.uint8)
	img[:] = default_rgb

	vals = df_layout.to_numpy()
	for r in range(nrows):
		for c in range(ncols):
			v = vals[r, c]
			if v is None or (isinstance(v, float) and np.isnan(v)):
				continue
			key = str(v).strip().upper()
			if not key:
				continue
			hx = bg_map.get(key)
			if hx:
				img[r, c, :] = Colour(hx).rgb_code

	return img


def generate_bin_maps(
		df_stocks: pd.DataFrame,
		col_bin: str = "DefaultBin",
		col_stock: str = "MStockCode",
		building: str = "Hawkins"
):
	bin_maps = []
	df_data = load_layout_data(building=building)
	df_layout = df_data["Layout"]
	df_legend = df_data["Legend"]
	df_sections = df_data["ShelfSections"]
	df_shelves = df_data["Shelves"]

	lst_bins = map(str.lower, df_stocks[col_bin].unique().tolist())
	lst_stockcodes = df_stocks[col_stock].unique().tolist()

	if user in admin_end_users:
		display_df(
			df_stocks,
			"START DF"
		)

	df_bin_shelf = df_shelves.loc[df_shelves["Shelf"].str.lower().str.strip().isin(lst_bins)]
	df_bin_shelf = df_bin_shelf.merge(
		df_sections[["ID", "ParentShelf", "Group", "X0", "X1", "Y0", "Y1"]],
		how="left",
		left_on="ShelfSectionID",
		right_on="ID"
	)
	df_bin_shelf = df_bin_shelf.merge(
		df_stocks[[col_bin, col_stock]],
		how="left",
		left_on="Shelf",
		right_on=col_bin
	)
	if user in admin_end_users:
		display_df(
			df_bin_shelf,
			"df_bin_shelf"
		)
	if not df_bin_shelf.empty:
		ser_bin_section = df_bin_shelf.iloc[0]
		bin_section = ser_bin_section["Section"]
		bin_section_id = ser_bin_section["ShelfSectionID"]
		bin_shelf_row = ser_bin_section["ShelfRow"]

		df_bin_shelf_section = df_sections.loc[df_sections["ID"] == bin_section_id]
		if not df_bin_shelf_section.empty:
			# ser_bin_shelf_section = df_bin_shelf_section.iloc[0]
			# try:
			# 	bsr = int(bin_shelf_row)
			# except (ValueError, TypeError):
			# 	bsr = bin_shelf_row
			for i, row in df_bin_shelf.iterrows():

				df_building_code: pd.DataFrame = df_bins.merge(
					df_parts,
					left_on="DefaultBin",
					right_on="DefaultBin"
				)
				df_building_code = df_building_code[
					df_building_code["StockCode"].str.lower().str.strip() == row[col_stock].lower().strip()
				].reset_index(drop=True)
				# display_df(
				# 	df_building_code,
				# 	f"{i=}"
				# )
				ser_stock_building_code = df_building_code.iloc[0]
				building_code = ser_stock_building_code["BuildingCode"]

				found_map_to_bin = dict(
					p_shelf=row["ParentShelf"],
					group=row["Group"],
					x0=row["X0"],
					x1=row["X1"],
					y0=row["Y0"],
					y1=row["Y1"],
					section=bin_section,
					section_id=bin_section_id,
					shelf_row=int(row["ShelfRow"]) if not pd.isna(row["ShelfRow"]) else None,
					bin_location=row["Shelf"],
					stockcode=row[col_stock],
					building_code=int(building_code)
				)

				x0 = found_map_to_bin["x0"]
				y0 = found_map_to_bin["y0"]
				x1 = found_map_to_bin["x1"]
				y1 = found_map_to_bin["y1"]
				w = x1 - x0
				h = y1 - y0
				found_map_to_bin["w"] = w
				found_map_to_bin["h"] = h
				cx = x0 + w
				cy = y0 + h
				found_map_to_bin["cx"] = cx
				found_map_to_bin["cy"] = cy

				if not st.session_state.get(k_use_full_map_dot_size, False):
					ds = st.session_state.get(k_map_dot_size, 1)
					wd = (ds - w) / 2
					hd = (ds - h) / 2
					x_0 = x0 - wd
					x_1 = x1 + wd
					y_0 = y0 - hd
					y_1 = y1 + hd
					cx = x_0 + (ds / 2)
					cy = y_0 + (ds / 2)

					found_map_to_bin.update({
						"x0": x_0,
						"y0": y_0,
						"x1": x_1,
						"y1": y_1,
						"w": ds,
						"h": ds,
						"cx": cx,
						"cy": cy
					})
				bin_maps.append(found_map_to_bin)

	reported = set()
	for i, sc in enumerate(lst_stockcodes):
		bin = df_stocks.loc[df_stocks[col_stock] == sc].reset_index().loc[0, col_bin]
		if bin_maps:
			found = False
			for data in bin_maps:
				if sc == data["stockcode"]:
					found = True
					break
			if not found:
				if sc not in reported:
					st.warning(f"Could not map {sc} in {bin}")
					reported.add(sc)
		else:
			if sc not in reported:
				st.warning(f"Could not map {sc} in {bin}")
				reported.add(sc)

	if user in admin_end_users:
		with st.container(border=True,horizontal=True):
			st.write("admin_debugging")
			st.write(f"bin_maps")
			st.write(bin_maps)
			display_df(df_stocks, f"df_stocks")

	return bin_maps


def build_plotly_map(
		img: np.ndarray,
		df_sections: pd.DataFrame,
		bg_map: dict[str, str],
		*,
		rotation_deg: int = 0,
		show_sections: bool = True,
		selected_section_id: int | None = None,
		title: str = "Warehouse layout (click a section)",
		opacity: float = 0.3
):
	fig = px.imshow(img, origin="upper")
	fig.update_layout(
		margin=dict(l=0, r=0, t=40, b=0),
		dragmode="pan",
		title=title
	)
	fig.update_xaxes(title="Col", showgrid=True, zeroline=False)
	fig.update_yaxes(title="Row", showgrid=True, zeroline=False)

	if not show_sections or df_sections is None or df_sections.empty:
		return fig

	use_rot = rotation_deg % 360 != 0
	x0c = "X0r" if use_rot else "X0"
	x1c = "X1r" if use_rot else "X1"
	y0c = "Y0r" if use_rot else "Y0"
	y1c = "Y1r" if use_rot else "Y1"

	missing = {x0c, x1c, y0c, y1c} - set(df_sections.columns)
	if missing:
		raise ValueError(f"ShelfSections missing required columns for rotation={rotation_deg}: {missing}")

	if show_sections:

		print("pre show_sections")
		st.write("pre show_sections")
		aisle_count = {}
		# --- draw all sections (base layer) ---
		for _, row in df_sections.iterrows():
			sec = str(row["Section"]).strip().upper()
			grp = row.get("Group", "")
			id_ = row.get("ID", "")
			color = bg_map.get(sec, "#000000")
			p_shelf = row.get("ParentShelf", "")

			x0 = float(row[x0c]);
			x1 = float(row[x1c])
			y0 = float(row[y0c]);
			y1 = float(row[y1c])

			bx_color = Colour(color).inverted().hex_code
			fig.add_shape(
				type="rect",
				x0=x0 - 0.5, x1=x1 - 0.5,
				y0=y0 - 0.5, y1=y1 - 0.5,
				line=dict(width=2, color=bx_color),
				fillcolor=bx_color,
				opacity=opacity,
				layer="above"
			)

			txts = []
			if not pd.isna(p_shelf):
				# txt = f"{p_shelf}-{grp}-{id_}"
				txts.extend([f"{p_shelf}-{sec}", grp, id_])
			else:
				# txt = f"aisle - {len(aisle_count) + 1}"
				txts.extend(["aisle", len(aisle_count) + 1])
				if sec not in aisle_count:
					aisle_count[sec] = 1
			# hd = y1 - y0
			# hpt = hd / len(txts)
			for i, txt in enumerate(txts):
				fig.add_annotation(
					x=(x0 + x1) / 2 - 0.5,
					# y=(y0 + y1) / 2 - 0.5,
					y=(y0 + i) + 0.5 + (1 if len(txts) == 2 else 0),
					text=txt,
					showarrow=False,
					font=dict(size=10, color="black")
				)

		print("post show_sections")
		st.write("post show_sections")

	# --- highlight selected section (top layer) ---
	if selected_section_id is not None and "ID" in df_sections.columns:
		print("pre highlight_sections")
		st.write("pre highlight_sections")
		sel = df_sections[df_sections["ID"] == selected_section_id]
		if not sel.empty:
			row = sel.iloc[0]
			sec = str(row["Section"]).strip().upper()
			color = bg_map.get(sec, "#000000")

			x0 = float(row[x0c]);
			x1 = float(row[x1c])
			y0 = float(row[y0c]);
			y1 = float(row[y1c])

			# 1) glow-ish border (thicker, black)
			fig.add_shape(
				type="rect",
				x0=x0 - 0.5, x1=x1 - 0.5,
				y0=y0 - 0.5, y1=y1 - 0.5,
				line=dict(width=6, color="#000000"),
				fillcolor="rgba(0,0,0,0)",
				opacity=0.9,
				layer="above",
			)

			# 2) inner border (section color)
			fig.add_shape(
				type="rect",
				x0=x0 - 0.5, x1=x1 - 0.5,
				y0=y0 - 0.5, y1=y1 - 0.5,
				line=dict(width=3, color=color),
				fillcolor=color,
				opacity=0.35,  # slightly stronger fill for selected
				layer="above",
			)

		print("post highlight_sections")
		st.write("post highlight_sections")

	return fig


def parse_section_group(key: str) -> tuple[str, str]:
	_key_re = re.compile(r"section='([^']+)'\s*_grp='([^']+)'", re.IGNORECASE)
	m = _key_re.search(key or "")
	if not m:
		return ("?", "?")
	return (m.group(1), m.group(2))


def add_hover_scatter_from_plotted(
		fig,
		plotted: dict[str, list[dict]],
		*,
		name: str = "Pick items",
		marker_size: int = 14,
		max_sc_in_hover: int = 20,  # keep hover manageable
):
	"""
	plotted format:
	  {
		"section='A'_grp='8'": [{"cx": 54.5, "cy": 4, "sc": "401092"}, ...],
		...
	  }

	Adds ONE scatter trace:
	  - one marker per unique (cx,cy)
	  - hover shows section/group and all stockcodes at that point (truncated)
	"""

	# Aggregate by (cx,cy)
	# Keep a set of (section,grp) sources too, because multiple groups could theoretically share coords.
	bins = defaultdict(lambda: {"sc": [], "src": set()})  # (cx,cy) -> {sc:[], src:set()}
	for k, rows in (plotted or {}).items():
		sec, grp = parse_section_group(k)
		for r in rows or []:
			cx = float(r.get("cx"))
			cy = float(r.get("cy"))
			sc = str(r.get("sc", "")).strip()
			rn = r.get("row")
			bin = r.get("bin")
			if not sc:
				continue
			bins[(cx, cy)]["sc"].append(f"{sc} - {bin} ROW#{rn}")
			bins[(cx, cy)]["src"].add((sec, grp))

	if not bins:
		return fig

	xs, ys, customdata = [], [], []

	for (cx, cy), payload in bins.items():
		sc_list = payload["sc"]
		# Stable / helpful ordering
		# sc_list = sorted(set(sc_list))

		# Section/group string
		src = sorted(payload["src"])
		src_str = ", ".join([f"{s}-{g}" for s, g in src])  # e.g. "A-8, A-9"

		# Hover text body (HTML)
		shown = sc_list[:max_sc_in_hover]
		more_n = max(0, len(sc_list) - len(shown))
		sc_lines = "<br>".join([f"• {sc}" for sc in shown])
		if more_n:
			sc_lines += f"<br>… (+{more_n} more)"

		# Store in customdata so hovertemplate is clean
		# [0]=src_str, [1]=count, [2]=sc_lines
		xs.append(cx)
		ys.append(cy)
		customdata.append([src_str, len(sc_list), sc_lines])

	fig.add_trace(
		go.Scatter(
			x=xs,
			y=ys,
			mode="markers",
			marker=dict(size=marker_size, opacity=0.75),
			customdata=customdata,
			hovertemplate=(
				"<b>Section/Group:</b> %{customdata[0]}<br>"
				"<b>Location:</b> (%{x}, %{y})<br>"
				"<b># Items:</b> %{customdata[1]}<br>"
				"<b>Stockcodes:</b><br>%{customdata[2]}"
				"<extra></extra>"
			),
			name=name,
			showlegend=False,
		)
	)

	return fig


def load_hawkins_map(
		building: str,
		found_map_to_bin,
		fig_in=None,
		dot_colour: str = "#FF3313",
		deg_rot: float = 0,
		title: str = "title",
		overlay_sections: bool = False,
		clear_selected: bool = False,
		plotted=None
		# use to prevent overlaying identifying text over other text. Also print only 1 directional arrow per bin
):
	# st.write(f"plotted TOP")
	# st.write(plotted)
	k_selected_section_id = "key_selected_section_id"
	if isinstance(found_map_to_bin, (list, tuple)):
		fig = None
		if not found_map_to_bin:
			fig = load_hawkins_map(
				building=building,
				found_map_to_bin=dict(),
				fig_in=fig,
				deg_rot=deg_rot,
				dot_colour=dot_colour,
				title=title,
				overlay_sections=overlay_sections
			)
		else:
			plotted = {} if plotted is None else plotted
			for i, data in enumerate(found_map_to_bin):
				fig = load_hawkins_map(
					building=building,
					found_map_to_bin=data,
					fig_in=fig,
					deg_rot=deg_rot,
					dot_colour=dot_colour,
					title=title,
					overlay_sections=overlay_sections,
					plotted=plotted
				)
			if user in admin_end_users:
				with st.container(border=True,horizontal=True):
					st.write("admin_debugging")
					st.write(f"plotted ITER BOTTOM")
					st.write(plotted)

		fig = add_hover_scatter_from_plotted(
			fig,
			plotted=plotted
		)

		return fig
	else:
		if clear_selected and (k_selected_section_id in st.session_state):
			st.session_state[k_selected_section_id] = None

		single_fig = plotted is None
		plotted = {} if single_fig else plotted

		df_data = load_layout_data(building=building)
		df_layout = df_data["Layout"]
		df_legend = df_data["Legend"]
		df_sections = df_data["ShelfSections"]
		df_shelves = df_data["Shelves"]
		msg_shelf = f' Shelf #{found_map_to_bin['shelf_row'] if found_map_to_bin else ''}'

		if fig_in is None:
			bg_map = build_legend_bg_map(df_legend)

			img0 = layout_to_rgb_image(df_layout, bg_map)
			H, W = img0.shape[:2]
			st.session_state.update({
				"hawkins_img_w": W,
				"hawkins_img_h": H
			})

			img = rotate_img(img0, deg_rot)
			df_sections_plot = rot_rect(df_sections, W=W, H=H, rotation_deg=deg_rot)

			fig = build_plotly_map(
				img=img,
				df_sections=df_sections_plot,
				bg_map=bg_map,
				rotation_deg=deg_rot,
				show_sections=overlay_sections,
				selected_section_id=st.session_state.get(k_selected_section_id),
				title=title
			)
		else:
			fig = fig_in

			W = st.session_state["hawkins_img_w"]
			H = st.session_state["hawkins_img_h"]

		if found_map_to_bin:

			stockcode = found_map_to_bin["stockcode"]
			row_n = found_map_to_bin["shelf_row"]
			binlocation = found_map_to_bin["bin_location"]
			section = found_map_to_bin["section"]
			grp = found_map_to_bin["group"]

			plot_key = f"{section=}_{grp=}"
			if plot_key not in plotted:
				plotted[plot_key] = []

			if stockcode not in [d["sc"] for d in plotted[plot_key]]:
				x0 = found_map_to_bin["x0"]
				y0 = found_map_to_bin["y0"]
				x1 = found_map_to_bin["x1"]
				y1 = found_map_to_bin["y1"]
				cx = found_map_to_bin["cx"]
				cy = found_map_to_bin["cy"]
				x0, y0 = rot_point_xy(x0, y0, W=W, H=H, rotation_deg=deg_rot)
				x1, y1 = rot_point_xy(x1, y1, W=W, H=H, rotation_deg=deg_rot)
				cx, cy = rot_point_xy(cx, cy, W=W, H=H, rotation_deg=deg_rot)
				found_map_to_bin.update({
					"x0": x0,
					"y0": y0,
					"x1": x1,
					"y1": y1,
					"cx": cx,
					"cy": cy
				})

				fig.add_shape(
					type="circle",
					xref="x", yref="y",
					x0=found_map_to_bin["x0"], x1=found_map_to_bin["x1"],
					y0=found_map_to_bin["y0"], y1=found_map_to_bin["y1"],
					line=dict(width=2, color=Colour(dot_colour).hex_code),
					fillcolor=Colour(dot_colour).hex_code,
					opacity=0.5,
					layer="above",
				)
				x_off = 40
				y_off = 18

				df_plotted = pd.DataFrame(plotted[plot_key])
				if not df_plotted.empty:
					df_plotted_same_bin = df_plotted.loc[
						(df_plotted["cx"] == found_map_to_bin["cx"])
						& (df_plotted["cy"] == found_map_to_bin["cy"])
						]
				else:
					df_plotted_same_bin = pd.DataFrame([])

				t_y = found_map_to_bin["cy"]
				t_x = found_map_to_bin["cx"]

				plotted[plot_key].append(dict(
					cx=t_x,
					cy=t_y,
					sc=stockcode,
					row=row_n,
					bin=binlocation
				))

		# fig.add_annotation(
		# 	x=t_x,
		# 	y=t_y,
		# 	xref="x", yref="y",
		# 	# ax=x_off if ((found_map_to_bin["cx"] + x_off) <= W) else -x_off,
		# 	# ay=y_off if ((found_map_to_bin["cy"] + y_off) <= H) else -y_off,
		# 	ax=-x_off,
		# 	ay=y_off + (10 * len(plotted[plot_key])),
		# 	text=f"{stockcode} located in bin {binlocation} on{msg_shelf.lower()}",
		# 	showarrow=first_of_bin,
		# 	xshift=0 if first_of_bin else -x_off,
		# 	yshift=0 if first_of_bin else -y_off,
		# 	font=dict(size=10, color="black")
		# )

		if single_fig:
			fig = add_hover_scatter_from_plotted(
				fig,
				plotted=plotted
			)
		return fig


def normalize_order(df: pd.DataFrame) -> pd.DataFrame:
	# sort by Order then reset to 1..N (prevents duplicates/gaps)
	df = df.sort_values(["ShelfRow", "Shelf"]).copy()
	df["ShelfRow"] = range(1, len(df) + 1)
	return df


def validate_shelves(df: pd.DataFrame) -> list[str]:
	errs = []
	if df["Shelf"].isna().any() or (df["Shelf"].astype(str).str.strip() == "").any():
		errs.append("Shelf cannot be blank.")
	# enforce uniqueness within section
	dup = df["Shelf"].astype(str).str.upper().str.strip().duplicated().any()
	if dup:
		errs.append("Duplicate Shelf values found in this section.")
	# shelfrow numeric
	bad = pd.to_numeric(df["ShelfRow"], errors="coerce").isna().any()
	if bad:
		errs.append("ShelfRow must be an integer (0 = floor).")
	return errs


def validate_sql_term(val, as_str: bool = True):
	# res = None
	if (val is not None) and (str(val).replace(".", "").isdigit()):
		try:
			if not as_str:
				res = (int(val) if (str(val).endswith(".0") or ("." not in str(val))) else float(val)) if "." in str(
					val) else int(val)
			# print(f"A {val=}, {val}, {str(val).endswith(".0")=}, {int(val)=}, {res=}")
			else:
				res = f"{int(val) if (str(val).endswith(".0") or ("." not in str(val))) else float(val)}"
		# print(f"B {val=}, {val}, {str(val).endswith(".0")=}, {int(val)=}, {res=}")
		except (TypeError, ValueError):
			res = None if (not as_str) else "NULL"
	# print(f"C {val=}, {val}, {res=}")
	else:
		if (not bool(val)) or pd.isna(val):
			res = None if (not as_str) else "NULL"
		# print(f"D {val=}, {val}, {res=}")
		else:
			res = f"'{val}'"
	# print(f"E {val=}, {val}, {res=}")
	return res


def push_shelf_changes(stde_key: str, t_name: str | pd.DataFrame, pk_name: str = "ID", default_insert_cols=None):
	if isinstance(t_name, pd.DataFrame):
		raise NotImplementedError(
			f"Support for DataFrame editing not supported yet. Use a str t_name to modify SQL tables.")

	if not isinstance(default_insert_cols, dict):
		if default_insert_cols is not None:
			raise ValueError(f"Expected default_insert_cols to be a dict, but got {type(default_insert_cols)}")
		default_insert_cols = dict()

	stde_data: dict = st.session_state[stde_key]
	edited_rows = stde_data.get("edited_rows", {})
	added_rows = stde_data.get("added_rows", [])
	deleted_rows = stde_data.get("deleted_rows", [])

	t_name = "[" + t_name.removeprefix("[").removesuffix("]") + "]"

	sql_edit = ""
	sql_edit_t = f"UPDATE\n\t{t_name}\nSET\n\t"
	for id_, edit_data in edited_rows.items():
		sql_edit_r = sql_edit_t
		for col, new_val in edit_data.items():
			sql_edit_r += f"[{col}] = {new_val},\n\t"
		sql_edit_r = sql_edit_r.rstrip().removesuffix(",") + "\n"
		sql_edit += f"{sql_edit_r}WHERE\n\t[ID] = {id_}\n;\n\n"
	sql_edit = sql_edit.rstrip()
	st.code(
		sql_edit,
		language="sql_i",
		line_numbers=True,
	)

	col_names = []
	sql_insert = f"INSERT INTO {t_name}\n\t([{{COL_NAMES}}])\nVALUES\n\t"
	for i, row in enumerate(added_rows):
		if not col_names:
			col_names = list(row.keys())
			col_names += list(default_insert_cols.keys())
		sql_insert_r = "("
		for col, val in row.items():
			sql_insert_r += f"{validate_sql_term(val)},"
		for col, val in default_insert_cols.items():
			sql_insert_r += f"{validate_sql_term(val)},"
		sql_insert += f"{sql_insert_r.rstrip().removesuffix(',')}),\n"

	sql_insert = sql_insert.format(COL_NAMES="], [".join(col_names))
	sql_insert = sql_insert.rstrip().removesuffix(",") + "\n;"
	st.code(
		sql_insert,
		language="sql_i",
		line_numbers=True,
	)

	sql_delete = f"DELETE FROM {t_name}\nWHERE [{pk_name}] IN ({', '.join(map(validate_sql_term, deleted_rows))});"
	st.code(
		sql_delete,
		language="sql_i",
		line_numbers=True,
	)

	sqls = {
		"edit": sql_edit,
		"del": sql_delete,
		"add": sql_insert
	}
	if not edited_rows:
		del sqls["edit"]
	if not deleted_rows:
		del sqls["del"]
	if not added_rows:
		del sqls["add"]

	for mode, sql in sqls.items():
		# df_res = connect(sql_i, do_show=True, do_print=True, do_exec=False)
		st.code(sql, language="sql_i", line_numbers=True)
		df_res = connect(sql, do_show=True, do_print=True, do_exec=True)

	st.toast("Updated saved successfully.")


@st.dialog(title="Prep PO Due Date Report", width="large", dismissible=True)
def input_purchase_order_due_date_report_parameters():
	cont = st.container()
	with st.expander("Adjust dates", expanded=False):
		cols_slider_btns = st.columns(2)
	st.divider()
	cols = st.columns(3)

	min_date = datetime.date.today() + datetime.timedelta(days=-30)
	max_date = datetime.date.today() + datetime.timedelta(days=30)

	k_slider_dates = "key_slider_dates"
	st.session_state.setdefault(k_slider_dates, [
		datetime.date.today(),
		datetime.date.today() + datetime.timedelta(days=1)
	])

	offsets = [1, 2, 3, 5, 7, 10, 14]
	for i, col in enumerate(cols_slider_btns):
		with cols_slider_btns[i]:
			st.write("Start Date" if i == 0 else "End Date")
		cols_slider_btns_sub = cols_slider_btns[i].columns(2)
		for j in range(2):
			for k, offset in enumerate(offsets):
				with cols_slider_btns_sub[j]:
					k_btn = f"key_btn_{i}_{j}_{k}"
					# st.write(f"{i=}, {j=}, {offset=}")
					# st.write(k_btn)
					if st.button(
						# label="Today",
						label=f"{'+' if j == 0 else '-'}{offset}",
						key=k_btn
					):
						d0_, d1_ = st.session_state.get(k_slider_dates, [datetime.date.today(), datetime.date.today()])
						dd_ = (d1_ - d0_).days
						td = d0_ if i == 0 else d1_
						td += datetime.timedelta(days=offset*(1 if j == 0 else -1))
						new_dates = [td, d1_] if i == 0 else [d0_, td]
						if new_dates[1] < new_dates[0]:
							if j == 0:
								new_dates = [new_dates[0], new_dates[0] + datetime.timedelta(days=dd_)]
							else:
								new_dates = [new_dates[1] + datetime.timedelta(days=-dd_), new_dates[1]]

						new_dates = [clamp(min_date, new_dates[0], max_date), clamp(min_date, new_dates[1], max_date)]
						st.session_state.update({
							k_slider_dates: new_dates,
						})

	with cont:
		date_input_po_dd = st.slider(
			label="Between Dates:",
			min_value=min_date,
			max_value=max_date,
			key=k_slider_dates,
		)

	with cols[0]:
		if st.button(
			label="cancel",
			key="k_btn_po_dd_cancel"
		):
			st.rerun()

	with cols[2]:
		if date_input_po_dd:
			if st.button(
				label="submit",
				key="k_btn_po_dd_submit"
			):
				d0, d1 = date_input_po_dd
				df_pos_in_range: pd.DataFrame = df_pos[
					((d0 <= df_pos["OrderDueDate"])
					 & (df_pos["OrderDueDate"] <= d1)
					)
					| ((d0 <= df_pos["MLatestDueDate"])
					   & (df_pos["MLatestDueDate"] <= d1)
					)
				]
				df_pos_in_range["MLatestDueDate"] = df_pos_in_range["MLatestDueDate"].fillna(df_pos_in_range["OrderDueDate"])
				df_test = df_pos_in_range[
					["OrderDueDate", "MLatestDueDate"]
				]
				display_df(
					df_test,
					"df_test"
				)
				df_pos_in_range["Date"] = df_pos_in_range[
					["OrderDueDate", "MLatestDueDate"]
				# ].max().max()
				].max(axis=1, skipna=True)

				df_pos_in_range.sort_values(
					by="OrderDueDate",
					ascending=True,
					inplace=True
				)

				st.session_state.update({
					k_stde_df_pos_in_range: df_pos_in_range
				})
				st.rerun()


def init_po_df_show_cols():
	if k_df_po_show_cols not in st.session_state:
		st.session_state.update({
			k_df_po_show_cols: {
				"Supplier": "Supplier",
				"MOrigDueDate": "Due Date",
				"MLatestDueDate": "New Date",
				"MStockCode": "Part",
				"MOrderQty": "Order Qty",
				"MReceivedQty": "Rec. Qty",
				"TPrice": "$",
				"PurchaseOrder": "PO",
				"QtyOutstanding": "Qty Outstanding"
			}
		})


def prep_po_pdf_report(df_pos_in_range, report_file_name, top_level: bool = True, mode: Literal["due", "received"] = "due"):

	if st.session_state.get(k_df_po_show_cols) is None:
		init_po_df_show_cols()

	show_cols: dict = st.session_state.get(k_df_po_show_cols, {})
	if mode == "received":
		show_cols["MOrigDueDate"] = "Received Date"

	report_title: str = f"Purchase Order Due Date Report"
	if mode == "received":
		report_title = report_title.replace("Due Date", "Received Date")
	report_subtitle: str = f"Generated PDF: {datetime.datetime.now():%Y-%m-%d %H:%M:%S}"
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
		as_zip=False
	)
	buf = out
	story = []
	pdf_header = f"Purchase Orders Due Between {d0:%Y-%m-%d} and {d1:%Y-%m-%d}"
	if mode == "received":
		pdf_header = pdf_header.replace("Due Date", "Received")

	if not top_level:
		rlu.add_grid_template(
			doc,
			theme,
			template_id="dash",
			rows=df_pos_in_range.shape[0] + 1,
			cols=1
			# ,
			# merged_cells=[(0, 0, 1, 2)]
		)
		# doc._firstPageTemplateIndex = next(
		# 	i for i, t in enumerate(doc.pageTemplates) if t.id == "dash"
		# )
		story += [
			rlu.h3(pdf_header, styles)
		]

		lst_dfs_pos = []

		show_cols_ord = list(show_cols.keys())
		if "PurchaseOrder" not in show_cols_ord:
			show_cols_ord.insert(1, "PurchaseOrder")
		if "QtyOutstanding" not in show_cols_ord:
			show_cols_ord.insert(-1, "QtyOutstanding")

		for i, row in df_pos_in_range.iterrows():
			po_num: int = row["PurchaseOrder"]
			df_po_data: pd.DataFrame = load_po_details(purchaseorder=po_num)
			df_po_data["PurchaseOrder"] = po_num
			df_po_data["TPrice"] = df_po_data["MOrderQty"] * df_po_data["MPrice"]
			df_po_data["QtyOutstanding"] = df_po_data["MOrderQty"] - df_po_data["MReceivedQty"]
			df_po_data = df_po_data[[c for c in show_cols_ord if c in df_po_data.columns]]
			lst_dfs_pos.append(df_po_data)
		df_po_datas = pd.concat(lst_dfs_pos, ignore_index=True)
		df_po_datas = df_po_datas[
			(~pd.isna(df_po_datas["MStockCode"]))
			& (df_po_datas["MStockCode"].str.strip() != "")
		]
		print("\n\n\nHERE\n\n\n")
		print(df_po_datas.head(10))
		print(df_po_datas.columns)
		df_po_datas.sort_values(
			by=["MOrigDueDate", "PurchaseOrder", "MStockCode"],
			inplace=True
		)
		df_po_datas_show = df_po_datas.rename(columns=show_cols)
		story += [
			# rlu.df_table(df_pos_in_range[df_pos_in_range["PurchaseOrder"] == po_num], theme, styles),
			# rlu.FrameBreak(),
			rlu.df_table(
				df=df_po_datas_show,
				theme=theme,
				styles=styles,
				target_width=doc.width,
				number_format={
					# show_cols["MPrice"]: "$ {:,.2f}"
					show_cols["TPrice"]: lambda x: money(x)
				},
				header_align="CENTER",
				col_align={
					show_cols["QtyOutstanding"]: "RIGHT",
					show_cols["MOrderQty"]: "RIGHT",
					show_cols["MReceivedQty"]: "RIGHT",
					show_cols["TPrice"]: "RIGHT",
					show_cols["PurchaseOrder"]: "LEFT",
					show_cols["MStockCode"]: "LEFT",
					show_cols["MOrigDueDate"]: "CENTER"
				}
			)
		]
		st.session_state.update({
			k_stde_df_pos_in_range_ord: df_po_datas
		})

	else:
		rlu.add_grid_template(doc, theme, template_id="dash", rows=1, cols=1)

		story += [
			rlu.h3(pdf_header, styles)
		]

		# cell 0, 0
		story += [
			# rlu.df_table(df_pos_in_range, theme, styles, number_format={"Value": "{:,.2f}"})
			rlu.df_table(df_pos_in_range, theme, styles)
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
	f_name = out.resolve()
	print(f"Wrote: {f_name}")
	return f_name


def prep_pdf_report_po_rd(df_pos_in_range, report_file_name, top_level: bool = True):
	return prep_po_pdf_report(
		df_pos_in_range=df_pos_in_range,
		report_file_name=report_file_name,
		top_level=top_level,
		mode="received"
	)


def prep_pdf_report_po_dd(df_pos_in_range, report_file_name, top_level: bool = True):
	return prep_po_pdf_report(
		df_pos_in_range=df_pos_in_range,
		report_file_name=report_file_name,
		top_level=top_level,
		mode="due"
	)


# HEADERS = [
# 	"PARTS LIST", "ITEM QTY", "STOCK", "PART", "DESCRIPTION", "DESC",
# 	"LENGTH", "WIDTH", "AREA", "COMMENTS"
# ]
#
# # Tune to your stockcode formats (examples):
# RE_STOCKCODE = re.compile(r"^[A-Z0-9][A-Z0-9\-]{2,}$")  # generic
# RE_ITEMNO    = re.compile(r"^(ITEM|ITEM NO\.?|ITEM#)\s*$", re.I)
#
# def normalize_cell(x):
# 	if x is None:
# 		return ""
# 	return str(x).strip()
#
# def has_header_tokens_in_data(df: pd.DataFrame) -> bool:
# 	# If any header word appears frequently in the first ~3 rows, extraction likely included header/title junk
# 	if df.empty:
# 		return True
# 	sample = df.head(4).astype(str).apply(lambda s: s.str.upper())
# 	header_hits = 0
# 	for h in HEADERS:
# 		header_hits += sample.apply(lambda col: col.str.contains(re.escape(h))).sum().sum()
# 	return header_hits >= 3
#
# def looks_like_stockcode_col(series: pd.Series) -> bool:
# 	s = series.dropna().astype(str).str.strip()
# 	if s.empty:
# 		return False
# 	# too many spaces => probably description column
# 	space_ratio = (s.str.contains(r"\s").mean())
# 	if space_ratio > 0.30:
# 		return False
# 	# regex match ratio
# 	return (s.str.match(RE_STOCKCODE).mean()) > 0.50
#
# def score_table(df: pd.DataFrame) -> float:
# 	if df is None or df.empty:
# 		return -1e9
# 	# basic shape expectations
# 	nrows, ncols = df.shape
# 	score = 0.0
# 	if ncols >= 3:
# 		score += 2
# 	if ncols >= 5:
# 		score += 1
# 	if nrows >= 3:
# 		score += 1
#
# 	# penalize header junk
# 	if has_header_tokens_in_data(df):
# 		score -= 3
#
# 	# reward if we can identify a likely stockcode column
# 	for c in df.columns[:min(3, ncols)]:
# 		if looks_like_stockcode_col(df[c]):
# 			score += 3
# 			break
#
# 	# penalize if first column is basically ITEM labels only
# 	c0 = df.iloc[:, 0].astype(str).str.upper().str.strip()
# 	if (c0.str.match(RE_ITEMNO).mean()) > 0.3:
# 		score -= 2
#
# 	return score
#
# def tables_pass(page, settings):
# 	tables = page.extract_tables(table_settings=settings) or []
# 	dfs = []
# 	for t in tables:
# 		df = pd.DataFrame(t)
# 		# drop fully empty rows
# 		df = df.replace({None: ""})
# 		df = df.loc[~(df.apply(lambda r: all(normalize_cell(x)=="" for x in r), axis=1))]
# 		# drop fully empty cols
# 		df = df.loc[:, ~(df.apply(lambda c: all(normalize_cell(x)=="" for x in c), axis=0))]
# 		if not df.empty:
# 			dfs.append(df.reset_index(drop=True))
# 	return dfs
#
# def find_header_band_bbox(page):
# 	# find words; if headers occur, estimate a bbox band below them
# 	words = page.extract_words(use_text_flow=True, keep_blank_chars=False) or []
# 	if not words:
# 		return None
#
# 	hits = []
# 	for w in words:
# 		txt = (w.get("text") or "").strip().upper()
# 		if txt in HEADERS or any(h in txt for h in HEADERS if len(h) >= 4):
# 			hits.append(w)
#
# 	if not hits:
# 		return None
#
# 	# pick lowest header y (closest to table start), then crop below it
# 	# pdfplumber coords: top smaller -> higher on page
# 	y_bottom_of_header = max(h["bottom"] for h in hits)
# 	# crop from a bit above that header bottom to near page bottom
# 	top = max(0, y_bottom_of_header - 5)
# 	bottom = page.height
# 	left = 0
# 	right = page.width
# 	return (left, top, right, bottom)
#
# @st.cache_data(show_spinner=False)
# def extract_parts_tables_from_pdf(pdf_bytes: bytes) -> dict:
# 	"""
# 	Returns dict with:
# 	  - 'tables': list[pd.DataFrame]
# 	  - 'best': pd.DataFrame | None
# 	  - 'meta': list of per-table info
# 	Cacheable by pdf_bytes.
# 	"""
# 	out_tables = []
# 	meta = []
#
# 	with pdfplumber.open(io.BytesIO(pdf_bytes)) as pdf:
# 		for pageno, page in enumerate(pdf.pages, start=1):
# 			# optional crop based on header band
# 			# bbox = find_header_band_bbox(page)
# 			# st.write("bbox")
# 			# st.write(bbox)
# 			bbox = (0, 0, page.width, page.height)
# 			work_page = page.crop(bbox) if bbox else page
#
# 			# Pass 1: stricter (good when ruling lines exist)
# 			settings1 = dict(
# 				vertical_strategy="lines",
# 				horizontal_strategy="lines",
# 				intersection_tolerance=5,
# 				snap_tolerance=3,
# 				join_tolerance=3,
# 				edge_min_length=10,
# 				min_words_vertical=2,
# 				min_words_horizontal=1,
# 			)
#
# 			dfs1 = tables_pass(work_page, settings1)
#
# 			# if nothing or sanity fails, Pass 2: stream-ish (text alignment)
# 			settings2 = dict(
# 				vertical_strategy="text",
# 				horizontal_strategy="text",
# 				snap_tolerance=3,
# 				join_tolerance=3,
# 				intersection_tolerance=5,
# 				min_words_vertical=1,
# 				min_words_horizontal=1,
# 				text_tolerance=3,
# 				text_x_tolerance=2,
# 				text_y_tolerance=2,
# 			)
#
# 			dfs2 = []
# 			if not dfs1 or all(score_table(d) < 1 for d in dfs1):
# 				dfs2 = tables_pass(work_page, settings2)
#
# 			dfs = dfs1 if dfs1 else []
# 			if dfs2:
# 				dfs.extend(dfs2)
#
# 			# score, store
# 			for df in dfs:
# 				sc = score_table(df)
# 				out_tables.append(df)
# 				meta.append({"page": pageno, "bbox": bbox, "score": sc, "nrows": df.shape[0], "ncols": df.shape[1]})
#
# 	best = None
# 	if out_tables:
# 		best_idx = max(range(len(out_tables)), key=lambda i: meta[i]["score"])
# 		best = out_tables[best_idx]
#
# 	return {"tables": out_tables, "best": best, "meta": meta}


@st.cache_data(show_spinner=False)
def extract_from_bytes(pdf_bytes: bytes, correction_cols_to_ignore: Optional[list] = None):
	bio = io.BytesIO(pdf_bytes)
	cands = edp.extract_table_candidates(bio)
	parts = edp.pick_best_parts_table(cands, correction_cols_to_ignore=correction_cols_to_ignore)
	rev = edp.pick_best_revision_table(cands)
	return cands, parts, rev


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


def nz(val: Any, length: int):

	def helper(val_: str, length_: int):
		if len(val_) > length_:
			return val_[:length_] + "... "
		return val_

	if isinstance(val, (pd.Series, pd.DataFrame)):
		if val.empty:
			return ""
		else:
			for i, va in enumerate(val):
				val[i] = va[:length]
			return val
	if pd.isna(val):
		return ""
	return helper(str(val))


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
	pb_day.progress(v,
					text=f"{percent(v)} {int(round(t_sec - p_sec, 0))} second(s) left {time_between(datetime.datetime.now(), datetime.datetime.now() + datetime.timedelta(seconds=t_sec - p_sec))}")

	while now < end:
		now = datetime.datetime.now()
		p_sec = max((now - start).total_seconds(), 0)
		await asyncio.sleep(1)
		v = min(1.0, max(0.0, p_sec / t_sec))
		pb_day.progress(v,
						text=f"{percent(v)} {int(round(t_sec - p_sec, 0))} second(s) left {time_between(datetime.datetime.now(), datetime.datetime.now() + datetime.timedelta(seconds=t_sec - p_sec))}")
		pb_week.progress((v / days_of_work) + dp, text=f"Week {percent((v / days_of_work) + dp)}")


# st.write(f"{end}, {p_sec=}, {v=}")
# st.write(f"{start}")
# st.write(f"{end}")


if not st_auth():
	st.info(f"Please contact Avery for further help with registering for this program.")
	# Go no further
	st.stop()


st.header(f"Parts {version_str}")
user = st.session_state.get("user", "??")
st.write(f"welcome {user}")
# if st.button("change password"):
with st.popover("change password"):
	if show_change_password():
		st.rerun()

##
k_use_full_map_dot_size = "key_use_full_map_dot_size"
st.session_state.setdefault(k_use_full_map_dot_size, False)
k_map_dot_size = "key_map_dot_size"
st.session_state.setdefault(k_map_dot_size, 2)
k_df_po_show_cols: str = "key_df_po_show_cols"
##

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
op_search_mode_by_warranty: str = "By Warranty"
op_search_mode_by_pick_list: str = "By Pick List"
op_search_mode_by_shopclock: str = "ShopClock",
op_search_mode_syspro: str = "Syspro"
op_search_mode_warehouse: str = "Warehouse"
op_search_mode_by_drawing: str = "By Drawing"
op_search_mode_day_totals: str = "Day Totals"
op_search_mode_day_testing: str = "Testing"
options_pills_search_mode = [
	op_search_mode_simple,
	op_search_mode_advanced,
	op_search_mode_by_bin,
	op_search_mode_by_section,
	op_search_mode_by_po,
	op_search_mode_by_so,
	op_search_mode_by_warranty,
	op_search_mode_by_pick_list,
	op_search_mode_by_shopclock,
	op_search_mode_syspro,
	op_search_mode_warehouse,
	op_search_mode_by_drawing
]

admin_end_users = ["abriggs"]
admin_test_users = ["rec"] + admin_end_users
if user in admin_end_users:
	options_pills_search_mode.append(
		op_search_mode_day_totals
	)
if user in admin_test_users:
	options_pills_search_mode.append(
		op_search_mode_day_testing
	)


textbox_stockcode = None
k_multiselect_sales_order_search = "key_multiselect_sales_order_search"
k_pills_search_mode: str = "key_pills_search_mode"
k_pills_search_mode_save: str = "key_pills_search_mode_save"

if user in admin_end_users:
	with st.container(border=True, horizontal=True):
		st.write("admin_debugging")
		st.write(f"A")
		st.write(f"{st.session_state.get(k_pills_search_mode)=}")
		st.write(f"{st.session_state.get(k_pills_search_mode_save)=}")
		st.write(f"{textbox_stockcode=}")

if user in admin_test_users:
	with st.sidebar:
		if st.button(
			label="Clear Cache & Rerun",
			key=f"k_clear_cache_rerun"
		):
			st.cache_data.clear()
			st.cache_resource.clear()
			st.rerun()

pills_search_mode = st.session_state.setdefault(k_pills_search_mode, 0)
if st.session_state.get(k_pills_search_mode_save) is not None:
	st.session_state.update({
		k_pills_search_mode: st.session_state.get(k_pills_search_mode_save),
		k_pills_search_mode_save: None
	})

if user in admin_end_users:
	with st.container(border=True, horizontal=True):
		st.write("admin_debugging")
		st.write(f"B")
		st.write(f"{pills_search_mode=}")
		st.write(f"{st.session_state.get(k_pills_search_mode)=}")
		st.write(f"{textbox_stockcode=}")

# pills_search_mode = st.session_state.setdefault(k_pills_search_mode, op_search_mode_simple)
# if pills_search_mode == 0:
#     pills_search_mode = op_search_mode_simple
# pills_search_mode = pills_search_mode if isinstance(pills_search_mode, str) else options_pills_search_mode[pills_search_mode]
# cont_top_control = st.container()

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
					on_change=lambda: st.session_state.update({k_search_text_widgets: None})
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
					on_change=lambda: st.session_state.update({k_search_text_widgets: None})
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

	options_pills_by_bin_mode = ["Single", "Range"]
	pills_by_bin_mode = pills(
		"mode:",
		options=options_pills_by_bin_mode,
		key="k_pills_by_bin_mode"
	)

	if pills_by_bin_mode == "Single":

		k_selectbox_bin_search = "key_selectbox_bin_search"
		st.session_state.setdefault(k_selectbox_bin_search, random.choice(list_filtered_bins))
		selectbox_bin_search = st.selectbox(
			label="Select a Bin:",
			key=k_selectbox_bin_search,
			options=list_filtered_bins
		)

		if selectbox_bin_search:
			df_search_bin = df_parts.loc[
				df_parts["DefaultBin"] == selectbox_bin_search
				]

			with st.container(border=True):
				stdf_search_bin = display_df_paginated(
					df_search_bin,
					title="df_search_bin",
					key=f"key_stdf_search_bin",
					selection_mode="single-row",
					on_select="rerun"
				)
				textbox_stockcode = get_selected_rows(df_search_bin, stdf_search_bin, cols="StockCode", n=1)
	else:
		cols_by_bin_range = st.columns(4)
		with cols_by_bin_range[0]:
			k_textbox_bin_a = "key_textbox_bin_a"
			textbox_bin_a = st.text_input(
				label="Start Bin",
				key=k_textbox_bin_a
			)
		with cols_by_bin_range[1]:
			k_textbox_bin_b = "key_textbox_bin_b"
			textbox_bin_b = st.text_input(
				label="To Bin",
				key=k_textbox_bin_b
			)
		with cols_by_bin_range[2]:
			k_selectbox_by_bin_warehouse = "key_selectbox_by_bin_warehouse"
			st.session_state.setdefault(k_selectbox_by_bin_warehouse, "01")
			selectbox_by_bin_warehouse = st.selectbox(
				label="Warehouse",
				options=["01", "04"],
				key=k_selectbox_by_bin_warehouse
			)
		k_df_by_bin_range = "key_df_by_bin_range"
		k_title_by_bin_range = "key_title_by_bin_range"
		if textbox_bin_a and textbox_bin_b and selectbox_by_bin_warehouse:
			min_prefix = min(len(textbox_bin_a), len(textbox_bin_b))
			with cols_by_bin_range[3]:
				if st.button(
					label="submit",
					key="submit_by_bin_range"
				):
					df_by_bin_range = df_bins[
						(textbox_bin_a.lower().strip() <= df_bins["DefaultBin"].str.lower().str.strip().str[:min_prefix])
						& (df_bins["DefaultBin"].str.lower().str.strip().str[:min_prefix] <= textbox_bin_b.lower().strip())
					]
					st.session_state.update({
						k_df_by_bin_range: df_by_bin_range,
						k_title_by_bin_range: f"Inventory between {textbox_bin_a.upper().strip()} and {textbox_bin_b.upper().strip()} in {selectbox_by_bin_warehouse}"
					})

			if st.session_state.get(k_df_by_bin_range) is not None:
				df_by_bin_range: pd.DataFrame = st.session_state.get(k_df_by_bin_range)
				if df_by_bin_range.empty:
					st.info(f"No data based on criteria. Check filters, if needed.")
				else:
					title = st.session_state.get(k_title_by_bin_range)
					df_by_bin_range = df_by_bin_range.merge(
						df_parts,
						left_on="DefaultBin",
						right_on="DefaultBin",
						how="inner"
					).reset_index(drop=True)
					df_by_bin_range["TotalCost"] = df_by_bin_range["UnitCost"] * df_by_bin_range["QtyOnHand"]
					df_by_bin_range["Part"] = (
							nz(df_by_bin_range["StockCode"], 30)
							+ "\n"
							+ nz(df_by_bin_range["Description"], 30)
							+ "\n"
							+ nz(df_by_bin_range["LongDesc"], 30)
					)
					df_by_bin_range["Count"] = " " * 6
					df_by_bin_range["ReCount"] = " " * 6
					show_cols = {
						"DefaultBin": "Bin",
						"Part": "Part",
						"ProductClass": "Class",
						"CycleCount": "CY/CO",
						"QtyOnOrder": "On Order",
						"QtyOnHand": "On Hand",
						"UnitCost": "Unit $",
						"TotalCost": "Total $",
						"Count": "Count",
						"ReCount": "ReCount"
					}
					df_by_bin_range = df_by_bin_range.rename(columns=show_cols)
					df_by_bin_range = df_by_bin_range.sort_values(
						by=show_cols["DefaultBin"]
					)
					display_df(
						df_by_bin_range[show_cols.values()],
						title
					)
					f_name = "inv_by_bin_{DATE}.pdf"
					if not os.path.exists(f_name):
						file, f_name = prep_inv_by_bin_report(f_name, title, df_by_bin_range[show_cols.values()])
					else:
						f_name = f_name.format(DATE=f"{datetime.datetime.now():%Y%m%d_%H%M}")
						file = f_name
					st.download_button(
						label="download Inventory By Bin Print",
						data=open(file, "rb").read(),
						file_name=f_name,
						mime="application/pdf",
						key=f"{f_name}_drive_0"
					)


	# if stdf_search_bin:
# 	if stdf_search_bin["selection"]:
	# 		if stdf_search_bin["selection"]["rows"]:
	# 			textbox_stockcode = df_search_bin.reset_index().loc[
	# 				stdf_search_bin["selection"]["rows"][0], "StockCode"]

# elif pills_search_mode == op_search_mode_by_section:
elif pills_search_mode == options_pills_search_mode.index(op_search_mode_by_section):
	# By Section
	k_selectbox_section_search = "key_selectbox_section_search"
	selectbox_section_search = st.selectbox(
		label="Select a Section:",
		key=k_selectbox_section_search,
		options=list_filtered_sections
	)

	if selectbox_section_search:
		filt_section_bins = df_bins.loc[
			df_bins["Section"] == selectbox_section_search, "DefaultBin"].dropna().unique().tolist()
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

	k_stde_df_pos_in_range = "key_stde_df_pos_in_range"
	k_stde_df_pos_in_range_ord = "key_stde_df_pos_in_range_ord"

	if user in admin_test_users:
		pdfs = [f for f in os.listdir(os.getcwd()) if f.lower().endswith(".pdf") and (f.lower().startswith(PREFIX_PO_DD_RPT.lower()))]
		if pdfs:
			if st.button(
				label=f"Delete {len(pdfs)} existing reports?",
				key="key_delete_existing_reports"
			):
				for pdf in pdfs:
					os.remove(os.path.join(os.getcwd(), pdf))

	# # display_df_paginated(
	# # 	df_pos,
	# # 	"df_pos",
	# # 	key="df_pos",
	# # )
	# for p in (150769, 150675, 150784, 150796, 150828, 150009):
	# 	display_df_paginated(
	# 		load_po_details(purchaseorder=p),
	# 		f"PO {p}",
	# 		key=f"PO{p}_ddp"
	# 	)

	init_po_df_show_cols()
	show_cols_po_ext = {v: k for k, v in st.session_state.get(k_df_po_show_cols, {}).items()}
	show_cols_po_ext.update(st.session_state.get(k_df_po_show_cols, {}))
	if "Due Date" in show_cols_po_ext:
		show_cols_po_ext["Received Date"] = show_cols_po_ext["Due Date"]
	if "Received Date" in show_cols_po_ext:
		show_cols_po_ext["Due Date"] = show_cols_po_ext["Received Date"]
	show_cols_po_ext.update(st.session_state.get(k_df_po_show_cols, {}))
	cols_test = st.columns(2)
	with cols_test[0]:

		st.subheader("POs Due")

		k_checkbox_due_date_report_top_level = "key_checkbox_due_date_report_top_level"
		st.session_state.setdefault(k_checkbox_due_date_report_top_level, False)
		checkbox_due_date_report_top_level = st.checkbox(
			label="Top Level Report?",
			key=k_checkbox_due_date_report_top_level
		)

		k_btn_due_date_report = "key_btn_due_date_report"
		if st.button(
				label="Due Date Report",
				key=k_btn_due_date_report
		):
			st.session_state.update({
				k_stde_df_pos_in_range: None,
				k_stde_df_pos_in_range_ord: None
			})
			input_purchase_order_due_date_report_parameters()

		if st.session_state.get(k_stde_df_pos_in_range) is not None:
			df_pos_in_range: pd.DataFrame = st.session_state.get(k_stde_df_pos_in_range)
			df_pos_in_range_ord: pd.DataFrame = st.session_state.get(k_stde_df_pos_in_range_ord)

			# for the Due date date report, groupby PO, StockCode, and Dates, Order Qty, Aggregate Rec Quantity, Price, and Outstanding cols
			df_pos_in_range = df_pos_in_range.groupby(

			)

			if not df_pos_in_range.empty or not df_pos_in_range_ord.empty:
				if (df_pos_in_range_ord is not None) and (not df_pos_in_range_ord.empty):
					st.write("show_cols_po_ext")
					st.write(show_cols_po_ext)
					display_df(
						df_pos_in_range_ord,
						"df_pos_in_range_ord"
					)
					d0 = df_pos_in_range_ord["Due Date" if "Due Date" in df_pos_in_range_ord else show_cols_po_ext["Due Date"]].min()
					d1 = df_pos_in_range_ord["Due Date" if "Due Date" in df_pos_in_range_ord else show_cols_po_ext["Due Date"]].max()
					display_df_paginated(
						df_pos_in_range_ord,
						f"POs in Range {d0} - {d1}",
						key="key_ddp_pos_in_range_show",
						batch_size_options=(100, 250, 1000)
					)
				else:
					d0 = df_pos_in_range["OrderDueDate"].min()
					d1 = df_pos_in_range["OrderDueDate"].max()
					display_df_paginated(
						df_pos_in_range,
						f"POs in Range {d0} - {d1}",
						key="key_ddp_pos_in_range_show",
						batch_size_options=(100, 250, 1000)
					)

				f_name = f"{PREFIX_PO_DD_RPT}{d0:%Y-%m-%d}_{d1:%Y-%m-%d}_{datetime.datetime.now():%Y-%m-%d_%H%M}.pdf"
				if checkbox_due_date_report_top_level:
					f_name = f_name.replace(".pdf", "_tl.pdf")
				if not os.path.exists(f_name):
					st.toast("Creating New Report")
					f_name = prep_pdf_report_po_dd(
						df_pos_in_range[["PurchaseOrder", "OrderEntryDate", "OrderDueDate", "Supplier"]],
						report_file_name=f_name,
						top_level=checkbox_due_date_report_top_level
					)
				st.download_button(
					label="Download Purchase Order Due Date Report",
					data=open(f_name, "rb").read(),
					file_name=f"{f_name}",
					mime="application/pdf",
					key=f"{f_name}_po_dd_report"
				)

			else:
				st.info("No Results")
		else:
			st.info("Submit dates via the 'Due Date Report' button.")

	with cols_test[1]:

		st.subheader("POs Received")

		k_checkbox_received_report_top_level = "key_checkbox_received_report_top_level"
		st.session_state.setdefault(k_checkbox_received_report_top_level, False)
		checkbox_received_report_top_level = st.checkbox(
			label="Top Level Report?",
			key=k_checkbox_received_report_top_level
		)

		if st.session_state.get(k_stde_df_pos_in_range) is not None:
			df_pos_in_range: pd.DataFrame = st.session_state.get(k_stde_df_pos_in_range)
			df_pos_in_range_ord: pd.DataFrame = st.session_state.get(k_stde_df_pos_in_range_ord)
			if not df_pos_in_range.empty or not df_pos_in_range_ord.empty:
				if (df_pos_in_range_ord is not None) and (not df_pos_in_range_ord.empty):
					d0 = df_pos_in_range_ord["Received Date" if "Received Date" in df_pos_in_range_ord else show_cols_po_ext["Received Date"]].min()
					d1 = df_pos_in_range_ord["Received Date" if "Received Date" in df_pos_in_range_ord else show_cols_po_ext["Received Date"]].max()
					display_df_paginated(
						df_pos_in_range_ord,
						f"POs in Range {d0} - {d1}",
						key="key_ddp_pos_in_range_rd_show",
						batch_size_options=(100, 250, 1000)
					)
				else:
					d0 = df_pos_in_range["OrderDueDate"].min()
					d1 = df_pos_in_range["OrderDueDate"].max()
					display_df_paginated(
						df_pos_in_range,
						f"POs in Range {d0} - {d1}",
						key="key_ddp_pos_in_range_rd_show",
						batch_size_options=(100, 250, 1000)
					)

				f_name = f"{PREFIX_PO_RD_RPT}{d0:%Y-%m-%d}_{d1:%Y-%m-%d}_{datetime.datetime.now():%Y-%m-%d_%H%M}.pdf"
				if checkbox_received_report_top_level:
					f_name = f_name.replace(".pdf", "_tl.pdf")
				if not os.path.exists(f_name):
					st.toast("Creating New Report")
					f_name = prep_pdf_report_po_rd(
						df_pos_in_range[["PurchaseOrder", "OrderEntryDate", "OrderDueDate", "Supplier"]],
						report_file_name=f_name,
						top_level=checkbox_received_report_top_level
					)
				st.download_button(
					label="Download Purchase Order Received Report",
					data=open(f_name, "rb").read(),
					file_name=f"{f_name}",
					mime="application/pdf",
					key=f"{f_name}_po_rd_report"
				)

			else:
				st.info("No Results")
		else:
			st.info("Submit dates via the 'Received Report' button.")

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
		lst_df_sales_orders: list[pd.DataFrame] = [load_so_details(salesorder=so) for so in
												   multiselect_sales_order_search]
		if len(lst_df_sales_orders) < 2:
			df_sales_orders = lst_df_sales_orders[0]
		else:
			df_sales_orders = pd.concat(lst_df_sales_orders, ignore_index=True).reset_index()

		k_stdf_sales_orders: str = "key_stdf_sales_orders"
		stdf_sales_orders = display_df_paginated(
			df_sales_orders,
			title="Sales Orders:",
			key=k_stdf_sales_orders,
			selection_mode="multi-row",
			on_select="rerun"
		)

		df_selected_sos = get_selected_rows(df_sales_orders, stdf_sales_orders, df_sales_orders.columns, n=None)
		if not df_selected_sos.empty:
			df_selected_sos = df_selected_sos.merge(
				df_parts[["StockCode", "DefaultBin"]],
				how="inner",
				left_on="MStockCode",
				right_on="StockCode"
			)
			display_df(
				df_selected_sos,
				"Sales Orders to Map"
			)
			selected_stockcodes = df_selected_sos["MStockCode"].dropna().unique().tolist()

			#########################################################
			#########################################################
			#########################################################
			#########################################################
			#########################################################

			# found_map_to_bin: dict = {}
			# so_bins = map(lambda v: str(v).strip().lower(), df_selected_sos["DefaultBin"].dropna())
			df_sos_bins = df_selected_sos[["DefaultBin", "MStockCode"]]
			with st.expander("Details"):
				bin_maps = generate_bin_maps(
					df_stocks=df_sos_bins
				)

			bin_maps_hawkins = [val for val in bin_maps if val["building_code"] in (BUILDING_CODE_BOTH, BUILDING_CODE_VMI, BUILDING_CODE_HAWKINS, BUILDING_CODE_UNKNOWN)]
			bin_maps_montana = [val for val in bin_maps if val["building_code"] in (BUILDING_CODE_BOTH, BUILDING_CODE_MONTANA)]

			rotation_deg = 90
			fig = load_hawkins_map(
				building="hawkins",
				found_map_to_bin=bin_maps_hawkins,
				title="Map of Parts in Selected Sales Orders",
				deg_rot=rotation_deg
			)

			fig.update_layout(
				width=1200,
				height=700
			)
			chart = st.plotly_chart(
				fig
			)

		st.divider()

		lst_df_sales_order_pick_sheets: list[pd.DataFrame] = [load_sales_order_pick_sheet(so) for so in
															  multiselect_sales_order_search]
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

		# #################################################
		# # Begin process of creating Sales Order Pick Sheets and exporting them to a zip file.
		#
		# lst_pdfs_bytes = []
		# for so in df_sales_order_pick_sheets["SalesOrder"].dropna().unique():
		# 	f_name = f"SOPickSheet_{so}.pdf"
		# 	lst_pdfs_bytes.append((
		# 		f_name,
		# 		generate_so_pick_sheet(
		# 			df_sales_order_pick_sheets[df_sales_order_pick_sheets["SalesOrder"] == so],
		# 			as_zip=True
		# 		)
		# 	))
		#
		# zip_bytes = rlu.build_zip_bytes(lst_pdfs_bytes)
		#
		# st.download_button(
		# 	"Download Sales Order Pick Sheets",
		# 	data=zip_bytes,
		# 	file_name=f"reports_{datetime.datetime.now():%Y-%m-%d_%H%M%S}.zip",
		# 	mime="application/zip",
		# )
		#
		# #################################################

		_WINDOWS_RESERVED = {
			"CON", "PRN", "AUX", "NUL",
			*{f"COM{i}" for i in range(1, 10)},
			*{f"LPT{i}" for i in range(1, 10)},
		}


		def safe_windows_filename(name: str, *, default="file") -> str:
			# Replace invalid filename characters
			name = re.sub(r'[<>:"/\\|?*\x00-\x1F]', "_", str(name))
			name = name.strip()  # remove leading/trailing whitespace
			name = name.rstrip(". ")  # Windows can't create trailing dot/space
			if not name:
				name = default
			# Avoid reserved device names (case-insensitive)
			base = name.split(".")[0].upper()
			if base in _WINDOWS_RESERVED:
				name = f"_{name}"
			# Optional: cap length (Explorer can choke on very long names)
			if len(name) > 150:
				name = name[:150]
			return name




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
		pdfs_to_zip = []
		for i, row in df_sales_order_pick_sheets.iterrows():
			so = row["SalesOrder"]
			sc = row["MStockCode"]
			df_so_stock_path = load_path_pdf(sc)
			if not df_so_stock_path.empty:
				stock_pdf_listed = df_so_stock_path.loc[0, "PDF_Listed"]
				stock_pdf_stock = df_so_stock_path.loc[0, "PDF_Stock"]
				if stock_pdf_listed or stock_pdf_stock:
					with cols_grid[ii // cols_per_row][ii % cols_per_row]:
						st.write(f"SO# {so}")
						st.write(f"PART# {sc}")
						f_name = f"{sc.replace(' ', '_')}"
						f_bytes = None
						f_bytes_z = None
						if stock_pdf_listed:
							f_bytes = open(stock_pdf_listed, "rb").read()
							f_bytes_z = f_bytes
							st.download_button(
								label="download PDF as listed in Syspro?",
								data=f_bytes,
								file_name=f"{f_name}_syspro.pdf",
								mime="application/pdf",
								key=f"{f_name}_drive_0"
							)
						if stock_pdf_stock:
							f_bytes = open(stock_pdf_stock, "rb").read()
							if f_bytes_z is None:
								# by default use the syspro version, if none, use the matching stock name file
								f_bytes_z = f_bytes
							st.download_button(
								label="Download found PDF from drive?",
								data=f_bytes,
								file_name=f"{f_name}_found.pdf",
								mime="application/pdf",
								key=f"{f_name}_drive_1"
							)

						# zf_name = f"{f_name}.pdf"
						zf_name = safe_windows_filename(f_name) + ".pdf"
						assert isinstance(f_bytes_z, (bytes, bytearray)) and len(f_bytes_z) > 5 and f_bytes_z[:5] == b"%PDF-"
						assert 1 == 2, "THE ZIPPING ISNT WORKING, FIX IT"

						if zf_name not in [tup[0] for tup in pdfs_to_zip]:
							if stock_pdf_listed:
								pdfs_to_zip.append((zf_name, f_bytes_z))
							elif stock_pdf_stock:
								pdfs_to_zip.append((zf_name, f_bytes_z))
					ii += 1

		if pdfs_to_zip:
			zip_bytes = rlu.build_zip_bytes(pdfs_to_zip)
			st.download_button(
				"Download Sales Order Pick Sheets",
				data=zip_bytes,
				file_name=f"reports_{datetime.datetime.now():%Y%m%d_%H%M%S}.zip",
				mime="application/zip",
			)
			import zipfile
			import io
			zf = zipfile.ZipFile(io.BytesIO(zip_bytes))
			bad = zf.testzip()  # returns first bad file name if CRC fails, else None
			st.write("zip testzip():", bad)
			st.write("zip names sample:", zf.namelist()[:20])

		# if stdf_sales_order_pick_sheets:
		# 	if stdf_sales_order_pick_sheets["selection"]:
		# 		if stdf_sales_order_pick_sheets["selection"]["rows"]:
		# 			textbox_stockcode = df_sales_order_pick_sheets.loc[
		# 				stdf_sales_order_pick_sheets["selection"]["rows"][0], "MStockCode"]
		textbox_stockcode = get_selected_rows(df_sales_order_pick_sheets, stdf_sales_order_pick_sheets, "MStockCode", 1)
		if isinstance(textbox_stockcode, pd.DataFrame):
			if textbox_stockcode.empty:
				textbox_stockcode = None
			else:
				textbox_stockcode = textbox_stockcode.iloc[0]


		# here
		# buf = io.BytesIO()

		st.divider()


elif pills_search_mode == options_pills_search_mode.index(op_search_mode_by_warranty):
	# Warranty

	df_jobs: pd.DataFrame = load_jobs()
	df_war_claims: pd.DataFrame = load_warranty_claims()
	df_war_jobs: pd.DataFrame = df_jobs[df_jobs["Job"].str[0] == "3"]
	list_war_jobs = df_war_jobs["Job"].dropna().unique().tolist()
	list_war_claims = df_war_claims["Claim Number"].dropna().unique().tolist()

	k_pills_war_mode: str = "key_pills_war_mode"
	st.session_state.setdefault(k_pills_war_mode, 0)
	pills_war_mode = pills(
		label="Mode:",
		options=["By Claim#", "By WO#"],
		key=k_pills_war_mode,
		index=0
	)

	k_selectbox_war_jobs: str = "key_selectbox_war_jobs"
	by_job: bool = True
	if pills_war_mode == "By Claim#":
		# By Claim#
		by_job = False
		selectbox_war_jobs = st.multiselect(
			label="Select some warranty Claim#s:",
			options=list_war_claims,
			key=k_selectbox_war_jobs
		)
	else:
		# By WO#
		selectbox_war_jobs = st.multiselect(
			label="Select some warranty WO#s:",
			options=list_war_jobs,
			key=k_selectbox_war_jobs
		)

	if selectbox_war_jobs:
		st.write("Warranty Jobs:")
		st.write(selectbox_war_jobs)

		df_s = []
		for i, sel_job in enumerate(selectbox_war_jobs):
			if by_job:
				df_s.append(load_warranty_data(job=sel_job))
			else:
				df_s.append(load_warranty_data(claim=sel_job))
		if len(df_s) > 0:
			df_war_data: pd.DataFrame = pd.concat(df_s)
		else:
			df_war_data: pd.DataFrame = df_s[0]

		stdf_war_data = display_df_paginated(
			df_war_data,
			"Warranty Data for Selected Jobs:",
			key="k_ddp_war_data",
			selection_mode="multi-row",
			on_select="rerun"
		)

		selected = get_selected_rows(df_war_data, stdf_war_data, "StockCode", 1)
		if selected:
			textbox_stockcode = selected

elif pills_search_mode == options_pills_search_mode.index(op_search_mode_by_pick_list):
	# Pick List
	k_df_pick_list: str = "key_df_pick_list"
	cols_controls = st.columns(2)
	df_jobs = load_jobs()
	with cols_controls[0]:
		k_pick_list_ops: str = "key_pick_list_ops"
		st.session_state.setdefault(k_pick_list_ops, [12, 18])
		pick_list_ops = st.slider(
			label="Operations:",
			min_value=1,
			max_value=19,
			key=k_pick_list_ops
		)
	with cols_controls[1]:
		k_pick_list_job: str = "key_pick_list_job"
		st.session_state.setdefault(k_pick_list_job, None)
		pick_list_job = st.selectbox(
			label="Job:",
			options=df_jobs["Job"],
			key=k_pick_list_job,
			on_change=lambda : st.session_state.update({k_df_pick_list: None})
		)

	st.write(f"{pick_list_job=}")
	st.write(f"{pick_list_ops=}")
	if pick_list_ops and pick_list_job:
		if st.button(
				"View Pick List",
				key="btn_pick_list_submit"
		):
			df_pick_list = load_pick_list(pick_list_job, *pick_list_ops)
			st.session_state[k_df_pick_list] = df_pick_list

		if st.session_state.get(k_df_pick_list) is not None:

			k_checkbox_need_to_pick: str = "key_checkbox_need_to_pick"
			st.session_state.setdefault(k_checkbox_need_to_pick, True)
			checkbox_need_to_pick = st.checkbox(
				label="Outstanding Only?",
				key=k_checkbox_need_to_pick
			)

			show_cols = OrderedDict({
				"StockCode": "Part",
				"Bin": "Bin",
				"Desc": "Desc",
				"Uom": "UoM",
				"UnitQtyReqd": "Reqd.",
				"QtyIssued": "Iss.",
				"QtyAvailable": "Avail.",
				"QtyToPick": "To Pick"
			})
			cols_pick_lists = st.columns(2)
			df_pick_list = st.session_state["k_df_pick_list"]

			if checkbox_need_to_pick:
				df_pick_list = df_pick_list[df_pick_list["QtyToPick"] > 0]

			df_pick_list["Desc"] = df_pick_list["StockDescription"] + " || " + df_pick_list["LongDesc"]
			st.header(f"Job# {df_pick_list.reset_index().loc[0, 'Job']}")
			st.subheader(f"{df_pick_list.reset_index().loc[0, 'JobDescription']}")
			with cols_pick_lists[0]:
				stdf_pick_list = display_df_paginated(
					df_pick_list.rename(columns=show_cols)[show_cols.values()],
					title="Pick List",
					key="k_stde_pick_list",
					batch_size_options=(250, 500, 100),
					selection_mode="multi-row",
					on_select="rerun"
				)

			df_possible_0_stock = df_pick_list[
				(df_pick_list["QtyAvailable"] <= 0)
				& (df_pick_list["QtyToPick"] > 0)
			]
			with cols_pick_lists[1]:
				stdf_pick_list_0_stock = display_df_paginated(
					df_possible_0_stock.rename(columns=show_cols)[show_cols.values()],
					title="Possiblly Out of Stock",
					key="k_stde_pick_list_0_stock",
					batch_size_options=(250, 500, 100),
					selection_mode="multi-row",
					on_select="rerun"
				)

			df_selected_pick_list = get_selected_rows(
				df_pick_list,
				stdf_pick_list,
				df_pick_list.columns,
				n=df_pick_list.shape[0]
			)

			# display_df(
			# 	df_selected_pick_list,
			# 	"df_selected_pick_list"
			# )
			if not df_selected_pick_list.empty:

				jobs = list(map(lambda x: str(x)[-4:], df_selected_pick_list["Job"].dropna().unique().tolist()))
				date_str = f"{datetime.datetime.now():%Y-%m-%d %H:%M}"
				pl_f_name: str = "_".join(jobs) + "_pick_list_{DATE}.pdf"
				title: str = ", ".join(jobs) + f" Pick List Report"
				report_file_name: str = pl_f_name.format(
					DATE=date_str.replace(":", "").replace("-", "").replace(" ", "").strip())

				if not os.path.exists(report_file_name):
					prep_pick_list_report(report_file_name, title, date_str,
										  df_selected_pick_list.rename(columns=show_cols)[show_cols.values()])

				st.download_button(
					label="download Pick List Print",
					data=open(report_file_name, "rb").read(),
					file_name=report_file_name,
					mime="application/pdf",
					key=f"{report_file_name}_drive_3"
				)

				bin_maps = generate_bin_maps(
					df_selected_pick_list,
					col_bin="Bin",
					col_stock="StockCode"
				)

				bin_maps_hawkins = [val for val in bin_maps if
									val["building_code"] in (BUILDING_CODE_BOTH, BUILDING_CODE_VMI,
															BUILDING_CODE_HAWKINS, BUILDING_CODE_UNKNOWN)]
				bin_maps_montana = [val for val in bin_maps if
									val["building_code"] in (BUILDING_CODE_BOTH, BUILDING_CODE_MONTANA)]

				rotation_deg = 90
				fig_hawkins = load_hawkins_map(
					building="hawkins",
					found_map_to_bin=bin_maps_hawkins,
					title=f"Hawkins Map of Parts in {pick_list_job}",
					deg_rot=rotation_deg
				)

				fig_hawkins.update_layout(
					width=1200,
					height=700
				)
				chart_hawkins = st.plotly_chart(
					fig_hawkins
				)

				fig_montana = load_hawkins_map(
					building="montana",
					found_map_to_bin=bin_maps_montana,
					title=f"Montana Map of Parts in {pick_list_job}",
					deg_rot=0
				)

				fig_montana.update_layout(
					width=1200,
					height=700
				)
				chart_montana = st.plotly_chart(
					fig_montana
				)

			else:
				st.info(f"Select some parts first.")

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

	keys_checkboxes_include_groups = {f"K_checkbox_include_group_{gi}": gi for gi in
									  sorted(df_shopclock["GroupID"].dropna().unique())}
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

elif pills_search_mode == options_pills_search_mode.index(op_search_mode_warehouse):

	def build_section_valuation_geometry(
			df_sections: pd.DataFrame,
			df_bins: pd.DataFrame,
			map_all_shelves: bool = True
	) -> pd.DataFrame:
		# 1) valuation per section
		val = (
			df_bins.groupby(["ParentShelf", "Section", "Group", "IsPath"], as_index=False)
			.agg({
				"TtlItemValue":"sum",
				"Shelf":lambda x: ', '.join(x),
				"OldestPurchasedDate": "min",
				"NewestPurchasedDate": "max"
			})
			.rename(columns={
				"TtlItemValue": "TtlValue",
				"Shelf": "Shelves"
			})
		)
		val["Section"] = val["Section"].astype(str).str.strip().str.upper()
		val["Group"] = val["Group"].astype(str).str.strip().str.upper()

		# 2) section geometry (combine all rectangles for a Section into one bounding box)
		geo = df_sections.copy()
		geo["Section"] = geo["Section"].astype(str).str.strip().str.upper()
		geo["Group"] = geo["Group"].astype(str).str.strip().str.upper()

		geo2 = (
			geo.groupby(["Section", "Group"], as_index=False)
			.agg(
				X0=("X0", "min"),
				X1=("X1", "max"),
				Y0=("Y0", "min"),
				Y1=("Y1", "max"),
			)
		)

		# 3) join
		out = geo2.merge(val, on=["Section", "Group"], how="left")
		out["TtlValue"] = out["TtlValue"].fillna(0.0)
		out["Shelves"] = out["Shelves"].fillna("")

		if not map_all_shelves:
			out = out[
				(~pd.isna(out["Section"]))
				& (~pd.isna(out["ParentShelf"]))
				& (out["TtlValue"] > 0)
			]

		# if map_all_shelves:
		# 	# out = out[out["TtlValue"] > 0]
		# 	# out = out[
		# 	# 	~pd.isna(out["ParentShelf"])
		# 	# ]
		# 	out = out[
		# 		(~pd.isna(out["Section"]))
		# 		& (~pd.isna(out["ParentShelf"]))
		# 		& (out["TtlValue"] > 0)
		# 	]
		# else:
		# 	out = out[out["IsPath"] == 0]

		# 4) derived geometry for bar placement/sizing
		out["cx"] = (out["X0"] + out["X1"]) / 2.0
		out["cy"] = (out["Y0"] + out["Y1"]) / 2.0
		out["dx"] = (out["X1"] - out["X0"]).clip(lower=0.5)  # avoid zero width
		out["dy"] = (out["Y1"] - out["Y0"]).clip(lower=0.5)

		# display_df_paginated(
		# 	out,
		# 	"out",
		# 	key="out",
		# 	batch_size_options=(250, 750, 1500)
		# )

		return out

	def plot_section_value_3d(df_sec_val: pd.DataFrame, *, elev=25, azim=-55, z_log=False):
		# Place bars by LOWER-LEFT corner
		x = (df_sec_val["cx"] - df_sec_val["dx"] / 2.0).to_numpy()
		y = (df_sec_val["cy"] - df_sec_val["dy"] / 2.0).to_numpy()
		dx = df_sec_val["dx"].to_numpy()
		dy = df_sec_val["dy"].to_numpy()

		z0 = np.zeros(len(df_sec_val), dtype=float)
		dz_raw = df_sec_val["TtlValue"].to_numpy(dtype=float)

		# Optional log scaling for huge value ranges
		if z_log:
			dz = np.log10(dz_raw + 1.0)
			z_label = "log10(Value + 1)"
		else:
			dz = dz_raw
			z_label = "Value"

		fig = plt.figure(figsize=(12, 7))
		ax = fig.add_subplot(111, projection="3d")

		# IMPORTANT: no explicit colors unless you ask; use default
		ax.bar3d(x, y, z0, dx, dy, dz, shade=True)

		ax.set_xlabel("X (grid)")
		ax.set_ylabel("Y (grid)")
		ax.set_zlabel(z_label)
		ax.view_init(elev=elev, azim=azim)

		# Optional: label section names (can clutter)
		# for _, r in df_sec_val.iterrows():
		#     ax.text(r["cx"], r["cy"], (np.log10(r["TtlValue"] + 1) if z_log else r["TtlValue"]) + 0.1, r["Section"], fontsize=8)

		plt.tight_layout()
		return fig

	def add_prism(fig: go.Figure, *, x0, x1, y0, y1, z0, z1, name="", color=None, opacity=0.85, hover=None):
		# 8 vertices of the prism
		verts = np.array([
			[x0, y0, z0], [x1, y0, z0], [x1, y1, z0], [x0, y1, z0],  # bottom
			[x0, y0, z1], [x1, y0, z1], [x1, y1, z1], [x0, y1, z1],  # top
		], dtype=float)

		# Triangulate faces (two triangles per face)
		I = [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5]
		J = [1, 2, 5, 6, 6, 7, 4, 7, 5, 6, 1, 2]
		K = [2, 3, 6, 7, 7, 4, 0, 4, 6, 7, 5, 6]
		# The above is a compact triangulation; if any face looks off, I can give you the explicit face list.

		fig.add_trace(go.Mesh3d(
			x=verts[:, 0], y=verts[:, 1], z=verts[:, 2],
			i=I, j=J, k=K,
			opacity=opacity,
			color=color,  # optional
			name=name,
			hovertext=hover,
			hoverinfo="text" if hover else "skip",
			showscale=False
		))
		return fig


	def plotly_cell_prisms(df_cells, plot_col: str, *, z_log=True, opacity=0.85, pillar_scale: float = 1, show_val_annotations: bool = True):
		fig = go.Figure()

		for r in df_cells.itertuples(index=False):
			x0, x1 = float(r.X0), float(r.X1)
			y0, y1 = float(r.Y0), float(r.Y1)

			try:
				val_raw = getattr(r, plot_col, 0.0)
				val = float(val_raw)
			except:
				show_val_annotations = False
				try:
					min_date = df_cells[plot_col].min()
					max_date = df_cells[plot_col].max()
					date_diff = (max_date - min_date).days
					isdate = is_date(val_raw)
					if isinstance(isdate, bool):
						if isdate:
							isdate = datetime.datetime.strptime(val_raw, "%Y-%m-%d")
						else:
							raise ValueError(f"Problem plotting {plot_col=}: {val_raw=}")
					val = (isdate - min_date).days
				except:
					raise ValueError(f"Problem plotting {plot_col=}: {val_raw=}")

			t_val = val
			val *= pillar_scale
			z1 = np.log10(val + 1.0) if z_log else val

			r_shelves_spl = list(set(r.Shelves.split(", ")))
			df_parts_in_section: pd.DataFrame = df_parts[df_parts["DefaultBin"].isin(r_shelves_spl)]
			avg_per_bin = t_val / len(r.Shelves)
			avg_per_stock = t_val / df_parts_in_section.shape[0]

			bins_per_row = 5
			if r_shelves_spl:
				shelves_br = f"<b> ({len(r_shelves_spl)})</b><br>" + ("<br>".join([", </b><b>".join(r_shelves_spl[bins_per_row*i:bins_per_row*(i+1)]) for i in range(math.ceil(len(r_shelves_spl) // bins_per_row) + 1)]))
			else:
				shelves_br = " None "

			hover = f"Section: <b>{r.ParentShelf}</b><br>"
			hover += f"Group: <b>{r.Group}</b><br>"
			if show_val_annotations:
				hover += f"Value: <b>$ {money(t_val)}</b><br>"
				hover += f"Val / Bin: <b>$ {money(avg_per_bin)}</b><br>"
				hover += f"Val / Part: <b>$ {money(avg_per_stock)}</b><br>"
			hover += f"Shelves: <b>{shelves_br}</b><br>"
			hover += f"Parts: <b>{df_parts_in_section.shape[0]}</b>"

			add_prism(
				fig,
				x0=x0, x1=x1,
				y0=y0, y1=y1,
				z0=0.0, z1=z1,
				opacity=opacity,
				hover=hover
			)

		fig.update_layout(
			margin=dict(l=0, r=0, t=40, b=0),
			scene=dict(
				aspectmode="data",
				xaxis_title="X",
				yaxis_title="Y",
				zaxis_title="log10(Value+1)" if z_log else "Value",
			)
		)
		return fig

	def update_sidebar():
		val = st.session_state.get(k_radio_warehouse_building)
		st.toast(f"{val=}")
		st.write(f"{val=}")
		print(f"{val=}")
		st.session_state.update({
			k_degrees_rot_map: 90 if val == "Hawkins" else 0
		})
		if user in admin_test_users:
			st.session_state.update({
				k_overlay_sections_map: True
			})

	k_radio_warehouse_building = "key_radio_warehouse_building"
	st.session_state.setdefault(k_radio_warehouse_building, "Hawkins")
	radio_warehouse_building = st.radio(
		label="Mode",
		options=["Hawkins", "Montana"],
		key=k_radio_warehouse_building,
		on_change=update_sidebar
	)

	k_pills_warehouse_mode = "key_pills_warehouse_mode"
	pills_warehouse_mode = pills(
		label="Mode",
		options=["Browse", "Valuation", "Days Since Last Order"]
	)

	df_data = load_layout_data(building=radio_warehouse_building)
	df_layout = df_data["Layout"]
	df_legend = df_data["Legend"]
	df_sections = df_data["ShelfSections"]
	df_shelves = df_data["Shelves"]

	if pills_warehouse_mode in ("Valuation", "Days Since Last Order"):
		# df_parts_in_warehouse = df_data["PartsInWarehouse"]

		df_bins_sections: pd.DataFrame = df_bins.merge(
			df_shelves[["Section", "ShelfSectionID", "Shelf", "ShelfRow"]],
			left_on="DefaultBin",
			right_on="Shelf",
			how="outer"
		).merge(
			df_sections[["ID", "ParentShelf", "Section", "Group", "X0", "X1", "Y0", "Y1"]],
			left_on="ShelfSectionID",
			right_on="ID",
			how="outer"
		).merge(
			df_legend[["ID", "Key", "Value", "IsPath", "BG", "FG"]],
			left_on="ParentShelf",
			right_on="Key",
			how="outer"
		)

		df_bins_sections = df_bins_sections[
			~pd.isna(df_bins_sections["TtlItemValue"])
			& (df_bins_sections["TtlItemValue"] > 0)
		]

		display_df_paginated(
			df_bins,
			"df_bins",
			batch_size_options=(750, 2000, 5000),
			key=f"k_ddp_df_bins"
		)

		display_df_paginated(
			df_bins_sections,
			"df_bins_sections",
			batch_size_options=(750, 2000, 5000),
			key=f"k_ddp_df_bins_sections"
		)
		df_bins_by_section: pd.DataFrame = df_bins_sections.groupby(
			by=["ParentShelf", "Section", "Group"]
		).agg({
			"TtlItemValue": "sum",
			"ID_x": "count",
			'Shelf': lambda x: ', '.join(x),
			"OldestPurchasedDate": "min",
			"NewestPurchasedDate": "max"
		}).rename(
			columns={
				"TtlItemValue": "$ Total",
				"ID_x": "Num Bins",
				"Shelf": "Shelves"
			}
		).reset_index()

		# display_df_paginated(
		# 	df_bins_by_section,
		# 	"df_bins_by_section",
		# 	batch_size_options=(250, 500, 1200),
		# 	key=f"k_ddp_df_bins_by_section"
		# )

		k_map_all_shelves = "key_map_all_shelves"
		st.session_state.setdefault(k_map_all_shelves, False)
		map_all_shelves = st.checkbox(
			label="Map all shelves?",
			key=k_map_all_shelves
		)

		# df_bins must be available here
		df_sec_val: pd.DataFrame = build_section_valuation_geometry(df_sections, df_bins_sections, map_all_shelves=map_all_shelves)

		df_sec_val["OldestPurchasedDate"] = pd.to_datetime(df_sec_val["OldestPurchasedDate"], errors="ignore").dt.date
		df_sec_val["NewestPurchasedDate"] = pd.to_datetime(df_sec_val["NewestPurchasedDate"], errors="ignore").dt.date
		df_sec_val["DaysSinceLastPurchase"] = datetime.datetime.today().date() - df_sec_val["NewestPurchasedDate"]
		df_sec_val["DaysSinceLastPurchase"] = df_sec_val["DaysSinceLastPurchase"].apply(lambda x: x.days)

		k_ddp_sec_val = "key_ddp_sec_val"
		display_df_paginated(
			df_sec_val,
			"Results:",
			key=k_ddp_sec_val,
			batch_size_options=(750, 1500, 2500)
		)

		#
		st.subheader(f"Inventory {'valuation' if pills_search_mode == 'Valuation' else 'age'} by section (3D)")

		k_checkbox_valuation_log = "key_checkbox_valuation_log"
		st.session_state.setdefault(k_checkbox_valuation_log, True)
		checkbox_valuation_log = st.checkbox(
			label="Show Valuations as Log10",
			key=k_checkbox_valuation_log
		)

		# z_log = st.checkbox("Log-scale Z (helps big ranges)", value=True)
		# elev = st.slider("Elevation", 5, 85, 25)
		# azim = st.slider("Azimuth", -180, 180, -55)
		#
		# fig = plot_section_value_3d(df_sec_val, elev=elev, azim=azim, z_log=z_log)
		# st.pyplot(fig, clear_figure=True)
		#
		# # Optional: show table
		# st.dataframe(
		# 	df_sec_val[["Section", "TtlValue", "X0", "X1", "Y0", "Y1"]].sort_values("TtlValue", ascending=False))

		# fig = plotly_skyscrapers(df_sec_val, z_log=True)
		# st.plotly_chart(fig, use_container_width=True)

		y_min = float(df_sec_val["Y0"].min())
		y_max = float(df_sec_val["Y1"].max())

		x_min = float(df_sec_val["X0"].min())
		x_max = float(df_sec_val["X1"].max())

		df_plot = df_sec_val.copy()
		# df_plot = build_shelf_cell_df(df_sections, df_shelves, df_legend)

		df_plot = flip_x_rect_df(df_plot, x_min=x_min, x_max=x_max, x0c="X0", x1c="X1")
		df_plot = flip_x_points_df(df_plot, x_min=x_min, x_max=x_max, xc="cx")

		pillar_scale = 1
		if not checkbox_valuation_log:
			# pillars are too large (usually) scale everything down by 1000 to improve appearance
			pillar_scale = 1 / 1000

		# now plot using df_plot instead of df_sec_val
		# fig = plotly_skyscrapers(df_plot, z_log=True)
		fig = plotly_cell_prisms(
			df_plot,
			plot_col="TtlValue" if pills_search_mode == "Valuation" else "DaysSinceLastPurchase",
			z_log=checkbox_valuation_log,
			pillar_scale=pillar_scale,
			show_val_annotations=pills_search_mode == "Valuation"
		)
		fig = add_section_floor_outlines(fig, df_plot)
		compass_rot = 94
		fig = add_compass_rotated(
			fig,
			x_min=float(df_plot["X0"].min()),
			x_max=float(df_plot["X1"].max()),
			y_min=float(df_plot["Y0"].min()),
			y_max=float(df_plot["Y1"].max()),
			size=(float(df_plot["X1"].max()) - float(df_plot["X0"].min())) * 0.08,
			rotation_deg=compass_rot,
			corner="se"
		)

		fig.update_layout(
			scene=dict(
				aspectmode="data",  # preserves real XY proportions
				zaxis=dict(nticks=6),
			),
			margin=dict(l=0, r=0, t=40, b=0),
		)

		st.plotly_chart(fig, use_container_width=True)

	else:
		k_degrees_rot_map: str = "key_degrees_rot_map"
		k_overlay_sections_map: str = "key_overlay_sections_map"

		# Interactive Warehouse
		if "selected_section_id" not in st.session_state:
			st.session_state["selected_section_id"] = None

		bg_map = build_legend_bg_map(df_legend)

		with st.sidebar:
			st.subheader("Map Controls")
			show_sections = False
			default_bg = st.color_picker("Default BG", value="#FFFFFF")
			st.caption("Tip: click a section rectangle to inspect its shelves.")

			rotation_deg = st.selectbox("Rotation", [0, 90, 180, 270], index=1, key=k_degrees_rot_map)

			if st.button("Clear selection"):
				st.session_state["selected_section_id"] = None
				st.rerun()

			overlay_section = st.checkbox("Overlay Sections", value=show_sections, key=k_overlay_sections_map)

		img0 = layout_to_rgb_image(df_layout, bg_map)
		H, W = img0.shape[:2]

		img = rotate_img(img0, rotation_deg)
		df_sections_plot = rot_rect(df_sections, W=W, H=H, rotation_deg=rotation_deg)
		fig = build_plotly_map(
			img=img,
			df_sections=df_sections_plot,
			bg_map=bg_map,
			rotation_deg=rotation_deg,
			show_sections=overlay_section,
			selected_section_id=st.session_state["selected_section_id"]
		)

		k_checkbox_use_plotly_events: str = "k_checkbox_use_plotly_events"
		st.session_state.setdefault(k_checkbox_use_plotly_events, False)
		checkbox_use_plotly_events = st.checkbox(
			label="Use Plotly Events?",
			key=k_checkbox_use_plotly_events,
			help="Using Plotly Events offers interactability with the map, however it runs poorly on low-resource machines."
		)

		if checkbox_use_plotly_events:
			# Click capture
			st.subheader("Interactive Map")
			clicked = plotly_events(fig, click_event=True, hover_event=False, select_event=False, override_height=800)

			# Display selection results
			st.subheader("Selection")

			if clicked:
				xr = float(clicked[0]["x"])
				yr = float(clicked[0]["y"])

				# convert rotated click back to original coords
				x, y = inv_rot_point_xy(xr, yr, W=W, H=H, rotation_deg=rotation_deg)
				st.write({"clicked_col_x": x, "clicked_row_y": y})

				sec_row = find_section_at_point(df_sections, x=x, y=y)  # NOTE: original df_sections

				if sec_row is None:
					st.session_state["selected_section_id"] = None
					st.info("No ShelfSection contains that point.")
				else:
					st.session_state["selected_section_id"] = int(sec_row["ID"])
					sec = str(sec_row["Section"]).strip().upper()
					grp = sec_row["Group"]
					sec_id = sec_row.get("ID", None)

					st.success(f"Clicked Section: {sec}, Group: {grp}, ID: {sec_id}")

					# Filter shelves that belong to this section/group
					# Your Shelves sheet columns: Section, ShelfSection, Shelf, ShelfRow
					cols = {c.lower(): c for c in df_shelves.columns}
					col_section = cols.get("section")
					col_group = cols.get("shelfsectionid")
					st.write(f"{col_section}, {col_group}")
					if not (col_section and col_group):
						st.warning("Shelves sheet must have columns like: Section and ShelfSectionID (group).")
					else:
						display_df_paginated(
							df_shelves,
							f"df_shelves_{radio_warehouse_building}",
							key=f"ddp_df_df_shelves",
							batch_size_options=(500, 2500, 5000)
						)
						df_hit = df_shelves[
							# (df_shelves[col_section].astype(str).str.strip().str.upper() == sec) &
							(df_shelves[col_group] == sec_id)
							].copy()

						# if df_hit.empty:
						# 	st.info("No shelves defined for this section/group yet.")
						# else:
						df_hit = df_hit.sort_values(["ShelfRow", "Shelf"])
						st.write("Shelves in selected section")

						sel_mask = (
								(df_shelves["Section"].astype(str).str.upper().str.strip() == sec) &
								(df_shelves["ShelfSectionID"] == sec_id)
						)
						df_sel = df_shelves.loc[sel_mask].copy()
						df_sel.sort_values(["ShelfRow"], inplace=True)

						df_hit_show = df_hit[["Shelf", "ShelfRow"]].sort_values(["ShelfRow", "Shelf"],
																				ascending=[False, True]).reset_index(drop=True)
						display_df(
							df_hit_show,
							"df_hit_show"
						)
						k_stde_section_shelves: str = "key_stde_section_shelves"
						stde_section_shelves = st.data_editor(
							df_hit_show,
							key=k_stde_section_shelves,
							num_rows="dynamic",
							hide_index=True,
							column_config={
								"Shelf": st.column_config.TextColumn(required=True),
								"ShelfRow": st.column_config.NumberColumn(min_value=1, step=1, max_value=7, required=True),
							}
						)

						st.write(f"st.session_state[{k_stde_section_shelves}]")
						st.write(st.session_state[k_stde_section_shelves])

						if st.button("Apply shelf edits to working copy"):
							# edited2 = stde_section_shelves.copy()
							# display_df(
							# 	edited2,
							# 	"edited2 A"
							# )
							# edited2["Shelf"] = edited2["Shelf"].astype(str).str.strip()
							# edited2["ShelfRow"] = pd.to_numeric(edited2["ShelfRow"], errors="coerce").astype("Int64")
							# display_df(
							# 	edited2,
							# 	"edited2 B"
							# )
							#
							# errs = validate_shelves(edited2)
							# if errs:
							# 	st.error("\n".join(errs))
							# else:
							# 	edited2 = normalize_order(edited2)
							#
							#
							#
							# 	# stamp required IDs
							# 	edited2["Section"] = sec
							# 	edited2["ShelfSectionID"] = sec_id
							# 	edited2["Group"] = grp
							#
							# 	# replace slice in master
							# 	df_master = df_shelves.copy()
							# 	# df_master = df_master.loc[~sel_mask].copy()  # drop old rows
							# 	# df_master = pd.concat([df_master, edited2], ignore_index=True)
							#
							# 	# df_shelves = df_master
							# 	st.toast("Updated saved successfully.")
							# 	push_shelf_changes(df_master, edited2, sel_mask)
							# 	load_layout_data.clear()

							# df_shelves = df_master
							st.toast("Updated saved successfully.")
							default_insert_cols = dict(Section=sec, ShelfSectionID=sec_id)
							push_shelf_changes(k_stde_section_shelves, "[BWSdb].[dbo].[INV_WarehouseLayout_HawkinsShelves]",
											   default_insert_cols=default_insert_cols)
							load_layout_data.clear()
							st.rerun()

						# Floor-level highlights
						if "ShelfRow" in df_hit.columns:
							floor = df_hit[df_hit["ShelfRow"] < 2]
							if not floor.empty:
								st.write("Floor-level shelves (ShelfRow < 2):")
								display_df_paginated(floor, title="Floor level", key="key_shelves_floor")

						df_parts_in_loc = df_parts[
							df_parts["DefaultBin"].str.lower().isin(
								map(lambda v: str(v).lower(), df_hit["Shelf"].dropna().unique()))
						]
						df_parts_in_loc = df_parts_in_loc.merge(
							df_shelves,
							left_on="DefaultBin",
							right_on="Shelf",
							how="left"
						)
						df_parts_in_loc["GroundLvl"] = df_parts_in_loc["ShelfRow"] < 2

						show_cols = [
							"StockCode",
							"DefaultBin",
							"Description",
							"LongDesc",
							"GroundLvl"
						]
						stdf_parts_in_loc = display_df_paginated(
							df_parts_in_loc[show_cols],
							"Parts in this location:",
							key="key_stdf_parts_in_loc"
						)


			else:
				st.info("Click a section overlay to see shelves in that space.")
		else:
			st.subheader(f"{radio_warehouse_building} Map")
			chart = st.plotly_chart(fig)

elif pills_search_mode == options_pills_search_mode.index(op_search_mode_by_drawing):
	# By Drawing
	# Drawings

	df_stock_pdfs: pd.DataFrame = load_path_pdf(all_stockcodes=True)

	path_pdf = r"\\server4\Design\VaultWorkspace_BWS\PDFS\WF-MVL-003.PDF"
	parts_data = []

	# display_df_paginated(
	# 	df_parts,
	# 	"df_parts",
	# 	batch_size_options=(100, 500, 2500),
	# 	key="stdf_parts_by_drawing_a"
	# )
	#
	# display_df_paginated(
	# 	df_stock_pdfs,
	# 	"df_parts",
	# 	batch_size_options=(100, 500, 2500),
	# 	key="stdf_parts_by_drawing_b"
	# )

	df_parts_drawings: pd.DataFrame = df_parts.merge(
		df_stock_pdfs,
		left_on="StockCode",
		right_on="StockCode",
		how="outer",
		suffixes=("_pdf", "_parts")
	)

	cols_by_drawing = st.columns(2)

	with cols_by_drawing[0]:
		stdf_parts = display_df_paginated(
			df_parts_drawings,
			"df_parts",
			batch_size_options=(500, 2000, 5000),
			key="stdf_parts_by_drawing",
			on_select="rerun",
			selection_mode="single-row"
		)

		df_sel_parts: pd.DataFrame = get_selected_rows(df_parts_drawings, stdf_parts, df_parts_drawings.columns, n=None)
		if not df_sel_parts.empty:
			# display_df(
			# 	df_sel_parts,
			# 	"Selected Drawings"
			# )
			if isinstance(df_sel_parts, pd.DataFrame):
				if df_sel_parts.empty:
					textbox_stockcode = None
				else:
					textbox_stockcode = df_sel_parts.iloc[0]

	with cols_by_drawing[1]:
		k_df_sel_drawing: str = "key_df_sel_drawing"
		uploaded_file = st.file_uploader(
			"Upload a drawing PDF",
			type=["pdf"],
			on_change=lambda: st.session_state.update({k_df_sel_drawing: None})
		)

		k_selectbox_drawing_select: str = "key_selectbox_drawing_select"
		st.session_state.setdefault(k_selectbox_drawing_select, None)
		selectbox_drawing_select = st.selectbox(
			label="Or, select a part:",
			options=df_stock_pdfs["StockCode"].dropna().unique().tolist() + [None] ,
			key=k_selectbox_drawing_select
		)

		if selectbox_drawing_select and (not uploaded_file):
			uploaded_file = selectbox_drawing_select

		if uploaded_file:
			st.success("✅ PDF uploaded. Click below to extract parts.")
			if st.button("Yes, Extract Parts"):
				parts_data = []

				# parts_data = extract_parts_tables_from_pdf(uploaded_file.getvalue())
				# st.write("parts_data")
				# st.write(parts_data)
				pdf_bytes = uploaded_file.getvalue()
				# res = extract_parts_tables_from_pdf(pdf_bytes)
				#
				# if res["best"] is None:
				# 	st.warning("No parts list detected.")
				# else:
				# 	st.success("✅ Best table detected:")
				# 	st.dataframe(res["best"])
				#
				# 	with st.expander("All detected tables"):
				# 		for i, (df, m) in enumerate(zip(res["tables"], res["meta"])):
				# 			st.write(f"Table {i} — page {m['page']} — score {m['score']:.2f} — {m['nrows']}x{m['ncols']}")
				# 			st.dataframe(df)

				pdf_bytes = uploaded_file.getvalue()
				cands, parts, rev = extract_from_bytes(pdf_bytes, correction_cols_to_ignore=["itemno"])

				if parts:
					# st.success(f"Parts table found (page {parts.page}, method {parts.method}, score {parts.score:.2f})")
					# st.dataframe(parts.df)
					parts_data = [parts.df]
				else:
					st.warning("No parts table detected.")

				# with st.expander("All table candidates"):
				# 	for c in sorted(cands, key=lambda x: x.score, reverse=True)[:20]:
				# 		st.write(
				# 			f"{c.kind} | page {c.page} | score {c.score:.2f} | bbox {c.bbox} | method {c.method} | shape {c.df.shape}")
				# 		st.dataframe(c.df)

				# st.stop()

				# with pdfplumber.open(uploaded_file) as pdf:
				# 	for i, page in enumerate(pdf.pages):
				# 		st.write(f"🔍 Processing page {i + 1}...")
				# 		e_table = page.extract_table()
				# 		st.write(e_table)
				# 		e_txt = page.extract_text_lines()
				# 		st.write(len(e_txt))
				# 		st.write([d['text'] for d in e_txt[:5]])
				# 		table = pd.DataFrame(e_table).reset_index()
				# 		col = 1
				# 		# if col not in table.columns:
				# 		# 	col = 1
				# 		st.write(f"{table.columns.tolist()=}")
				# 		table = table.loc[
				# 			(~pd.isna(table[col]))
				# 			& (table[col].str.upper() != "ITEM NO.")
				# 			& (table[col].str.upper() != "ITEM")
				# 			]
				# 		parts_data.append(table)

				st.session_state.update({
					k_df_sel_drawing: parts_data
				})
		if st.session_state.get(k_df_sel_drawing, None) is not None:
			parts_data: list[pd.DataFrame] = st.session_state.get(k_df_sel_drawing, [])
			if parts_data:
				for i, df_parts_ in enumerate(parts_data):

					stdf_parts = display_df_paginated(
						df_parts_,
						f"Page #{i+1}",
						batch_size_options=(100, 500, 2500),
						key=f"stdf_parts_p{i}_by_drawing",
						on_select="rerun",
						selection_mode="single-row"
					)


					inv_stockcode = edp.get_stockcode_col(df_parts_)

					df_sel_parts: pd.DataFrame = get_selected_rows(df_parts_, stdf_parts,
																   inv_stockcode, n=1)
					if isinstance(df_sel_parts, pd.DataFrame):
						if not df_sel_parts.empty:
							textbox_stockcode = df_sel_parts.iloc[0]
					else:
						if df_sel_parts:
							textbox_stockcode = df_sel_parts

					st.success(f"✅ Extracted {df_parts_.shape[0]} unique parts.")

					st.write(f"{inv_stockcode=}, {type(inv_stockcode)=}")
					st.write({inv_stockcode: 'StockCode'})

					if st.button(
						"BFS",
						key=f"key_btn_submit_bfs_py_drawing"
					):
						df_p_ = df_parts_.copy()
						df_drawings_to_search: pd.DataFrame = df_p_.merge(
							df_stock_pdfs,
							left_on=inv_stockcode,
							right_on="StockCode",
							suffixes=("_parts", "_pdf"),
							how="inner"
						)

						if df_drawings_to_search.empty:
							cols_without_part = df_parts_.columns.tolist()
							cols_without_part.remove(inv_stockcode)
							inv_stockcode_new = edp.get_stockcode_col(df_parts_[cols_without_part])
							df_drawings_to_search: pd.DataFrame = df_p_.merge(
								df_stock_pdfs,
								left_on=inv_stockcode_new,
								right_on="StockCode",
								suffixes=("_parts", "_pdf"),
								how="inner"
							)

						display_df(
							df_drawings_to_search,
							"dfs_drawings_to_search"
						)
						parent_cols : list = list(df_drawings_to_search.columns)
						dfs_captured_sub_parts: list = []

						# Perform BFS HERE

						for i, row in df_drawings_to_search.iterrows():
							sc = row["StockCode"]
							f_name = row["PDF_Listed"]
							if pd.isna(f_name) or (not f_name):
								f_name = row["PDF_Stock"]
							st.write(f"Row# {i=}, {f_name=}")
							if (not pd.isna(f_name)) and f_name:
								with open(f_name, "rb") as f_bin:
									pdf_bytes = f_bin.read()
									cands, parts, rev = extract_from_bytes(pdf_bytes, correction_cols_to_ignore=["itemno"])

									if parts:
										st.write(f"{parts.score=}")
										st.success(f"Parts table found (page {parts.page}, method {parts.method}, score {parts.score:.2f})")
										st.write(f"{edp.get_stockcode_col(parts.df)=}")
										st.dataframe(parts.df)
										if parts.score > 3:
											col_sc: str  = edp.get_stockcode_col(parts.df)
											df_parts_in_sub = parts.df.merge(
												df_stock_pdfs,
												left_on=col_sc,
												right_on="StockCode",
												suffixes=("_parts", "_pdf"),
												how="left"
											)
											lst_sub_components = df_parts_in_sub[col_sc]
											dfs_captured_sub_parts.append(
												df_parts_in_sub
											)
										else:
											st.info(f"Poor score, omit {i=}")
									else:
										st.warning("No parts detected.")

						if dfs_captured_sub_parts:
							df_cap = pd.concat(dfs_captured_sub_parts, ignore_index=True)
							st.write("parent_cols")
							st.write(parent_cols)
							st.write("df_cap.columns")
							st.write(df_cap.columns)
							display_df(
								df_cap,
								"df_cap"
							)
						else:
							st.info(f"No captured parts")

			else:
				st.warning("⚠️ No parts list could be detected. Try another file or check formatting.")

# elif pills_search_mode == op_search_mode_day_totals:
elif (user in admin_end_users) and (pills_search_mode == options_pills_search_mode.index(op_search_mode_day_totals)):
	pb_day = st.progress(value=0)
	pb_week = st.progress(value=0)
	asyncio.run(run_day())

# elif pills_search_mode == op_search_mode_day_totals:
elif (user in admin_test_users) and (pills_search_mode == options_pills_search_mode.index(op_search_mode_day_testing)):

	cols_testing = pills(
		label="Testing Mode",
		options=["Warehouse Visualization Testing", "Other"],
		key="key_pills_testing_mode"
	)

	if cols_testing == "Warehouse Visualization Testing":

		cols_maps = pills(
			label="Warehouse",
			options=["Hawkins", "Montana"],
			key="key_pills_warehouse_view_testing"
		)

		st.write(f"{cols_maps=}")
		st.write(f"{cols_maps==0}")
		st.write(f"{cols_maps==1}")
		if cols_maps == "Hawkins":
			df_data = load_layout_data(building="hawkins")
			df_layout = df_data["Layout"]
			df_legend = df_data["Legend"]
			df_sections = df_data["ShelfSections"]
			df_shelves = df_data["Shelves"]
			# df_layout = pd.DataFrame({
			# 	"A": [None, "A", None, None, None, None, None, None, None, None],
			# 	"B": [None, None, None, None, None, None, None, None, None, None],
			# 	"C": [None, "A", "A", None, None, None, None, None, None, None],
			# 	"D": [None, None, None, None, None, None, None, None, None, None],
			# 	"E": [None, "A", None, None, None, None, None, None, None, None]
			# })
			deg_rot = 0

			bg_map = build_legend_bg_map(df_legend)

			img0 = layout_to_rgb_image(df_layout, bg_map)
			H, W = img0.shape[:2]
			st.session_state.update({
				"hawkins_img_w": W,
				"hawkins_img_h": H
			})

			img = rotate_img(img0, deg_rot)
			df_sections_plot = rot_rect(df_sections, W=W, H=H, rotation_deg=deg_rot)

			print("pre build_plotly_map")
			st.write("pre build_plotly_map")

			fig_hawkins = build_plotly_map(
				img=img,
				df_sections=df_sections_plot,
				bg_map=bg_map,
				rotation_deg=deg_rot,
				show_sections=True,
				# selected_section_id=st.session_state.get(k_selected_section_id),
				title="Hawkins"
			)
			print("post build_plotly_map")
			st.write("post build_plotly_map")

			st.plotly_chart(fig_hawkins)

		else:
			df_data = load_layout_data(building="montana")
			df_layout = df_data["Layout"]
			df_legend = df_data["Legend"]
			df_sections = df_data["ShelfSections"]
			df_shelves = df_data["Shelves"]
			# df_layout = pd.DataFrame({
			# 	"A": [None, "A", None, None, None, None, None, None, None, None],
			# 	"B": [None, None, None, None, None, None, None, None, None, None],
			# 	"C": [None, "A", "A", None, None, None, None, None, None, None],
			# 	"D": [None, None, None, None, None, None, None, None, None, None],
			# 	"E": [None, "A", None, None, None, None, None, None, None, None]
			# })
			deg_rot = 0

			bg_map = build_legend_bg_map(df_legend)

			img0 = layout_to_rgb_image(df_layout, bg_map)
			H, W = img0.shape[:2]
			st.session_state.update({
				"hawkins_img_w": W,
				"hawkins_img_h": H
			})

			img = rotate_img(img0, deg_rot)
			df_sections_plot = rot_rect(df_sections, W=W, H=H, rotation_deg=deg_rot)

			print("pre build_plotly_map")
			st.write("pre build_plotly_map")

			fig_montana = build_plotly_map(
				img=img,
				df_sections=df_sections_plot,
				bg_map=bg_map,
				rotation_deg=deg_rot,
				show_sections=True,
				# selected_section_id=st.session_state.get(k_selected_section_id),
				title="Montana"
			)
			print("post build_plotly_map")
			st.write("post build_plotly_map")

			st.plotly_chart(fig_montana)

	else:
		from dataframe_utility import random_df
		# from utility import money
		# from typing import Literal
		# import os


		def test_0():

			cols_results = st.columns(2)

			n_rows = 125
			df_jerseys = random_df(
				n_rows=n_rows,
				n_columns={
					"ID": "int",
					"Order Date": "date",
					"Receive Date": "date",
					"Open Date": "date",
					"Jersey": "str",
					"PlayerID": "int",
					"Price": "float"
				},
				index_cols="Jersey",
				auto_number=[0, 2],  # use autonumbering for ID and Receive Date Ensures unique values and sequential ordering
				min_random_float=75,
				max_random_float=500,
				min_random_int=0,
				max_random_int=50,
				min_random_date=(datetime.datetime.now() + datetime.timedelta(days=-n_rows)).date(),
				max_random_date=datetime.datetime.now().date(),
				print_debug=True
			)
			with cols_results[0]:
				display_df(
					df_jerseys,
					f"df_jerseys A"
				)
			df_jerseys_w = df_jerseys.copy()
			df_jerseys_w["Days_Ord_Now"] = datetime.datetime.today().date() - df_jerseys_w["Order Date"]
			df_jerseys_w["Days_Ord_Now"] = df_jerseys_w["Days_Ord_Now"].apply(lambda x: x.days)
			df_jerseys["Price Per Day"] = df_jerseys_w["Price"] / df_jerseys_w["Days_Ord_Now"]
			display_df(
				df_jerseys,
				f"df_jerseys B"
			)

			unique_jerseys: list = df_jerseys["Jersey"].unique().tolist()
			unique_players: list = df_jerseys["Jersey"].unique().tolist()

			# Prepare random Jersey dataframes
			df_player_jerseys = random_df(
				n_rows=len(unique_jerseys),
				n_columns=["ID", "Jersey"],
				defaults={"Jersey": unique_jerseys},
				index_cols=["Jersey"],
				auto_number=["ID"]
			)
			display_df(
				df_player_jerseys,
				"df_player_jerseys"
			)

			df_j_pj = df_jerseys.merge(
				df_player_jerseys,
				left_on="Jersey",
				right_on="Jersey",
				suffixes=("_jersey", "_player_jersey"),
				how="inner",
			)
			with cols_results[1]:
				display_df(
					df_j_pj,
					"df_j_pj"
				)

			datet: datetime.datetime = datetime.datetime.now()
			date_: datetime.date = datet.date()
			datet_str: str = f"{datet:%Y-%m-%d %H:%M:%S}"
			date_str: str = f"{date_:%Y-%m-%d}"
			output_folder: str = r"C:\Users\abrig\Documents\Coding_Practice\Python\Resource\Tests\ReportLab"
			if not os.path.exists(output_folder):
				output_folder = r"C:\Users\abriggs\Documents\Coding_Practice\Python\Resource\Tests\ReportLab"
			output_filename: str = f"reportlab_test{date_str}.pdf"

			# ********************************************************************
			report_file_name: str = os.path.join(output_folder, output_filename)
			report_author: str = "Avery Briggs"
			pdf_header: str = "HEADER"
			# ********************************************************************

			top_level: bool = True
			mode: Literal["due", "received"] = "due"

			show_cols: dict = None
			if mode == "received":
				show_cols["MOrigDueDate"] = "Received Date"

			report_title: str = f"Purchase Order Due Date Report"
			if mode == "received":
				report_title = report_title.replace("Due Date", "Received Date")
			report_subtitle: str = f"Generated PDF: {datetime.datetime.now():%Y-%m-%d %H:%M:%S}"

			st.code(report_file_name)

			if st.button(
				label="Generate PDF",
				key="testing_generate_pdf",
			):
				doc = rlu.SimpleDocTemplate("table_grids.pdf", pagesize=rlu.letter)
				story = []

				data = [['col_{}'.format(x) for x in range(1, 6)],
						[str(x) for x in range(1, 6)],
						['a', 'b', 'c', 'd', 'e']
						]

				tblstyle = rlu.TableStyle([('INNERGRID', (0, 0), (-1, -1), 0.25, rlu.colors.red),
									   ('BOX', (0, 0), (-1, -1), 0.25, rlu.colors.black),
									   ])

				tbl = rlu.Table(data)
				tbl.setStyle(tblstyle)
				story.append(tbl)

				story.append(rlu.Spacer(0, 25))

				tbl = rlu.Table(data, style=[
					('GRID', (0, 0), (-1, -1), 0.5, rlu.colors.blue)
				])
				story.append(tbl)

				doc.build(story)

			# theme = rlu.PDFTheme(
				# 	page_size=rlu.landscape(rlu.LETTER)
				# )
				# meta = rlu.PDFMeta(
				# 	title=report_title,
				# 	subtitle=report_subtitle,
				# 	author=report_author,
				# )
				# styles = rlu.build_styles(theme)
				#
				# out, doc = rlu.build_pdf(
				# 	report_file_name,
				# 	story=None,
				# 	theme=theme,
				# 	meta=meta,
				# 	as_zip=False
				# )
				# buf = out
				# story = []
				# if mode == "received":
				# 	pdf_header = pdf_header.replace("Due Date", "Received")
				#
				# # add_grid_template(
				# #     doc,
				# #     theme,
				# #     template_id="dash",
				# #     rows=df_pos_in_range.shape[0] + 1,
				# #     cols=1
				# #     # ,
				# #     # merged_cells=[(0, 0, 1, 2)]
				# # )
				# rlu.add_grid_template(
				# 	doc,
				# 	theme,
				# 	rows=2,
				# 	cols=2,
				# 	merged_cells=[(0, 0, 1, 2)]
				# )
				#
				# story += [
				# 	rlu.h3(pdf_header, styles)
				# ]
				#
				# # cell 0, 0
				# story += [
				# 	# rlu.df_table(df_pos_in_range[df_pos_in_range["PurchaseOrder"] == po_num], theme, styles),
				# 	# rlu.FrameBreak(),
				# 	rlu.df_table(
				# 		df=df_jerseys,
				# 		theme=theme,
				# 		styles=styles,
				# 		target_width=doc.width,
				# 		number_format={
				# 			# show_cols["MPrice"]: "$ {:,.2f}"
				# 			"Price Per Day": lambda x: money(x),
				# 			"Price": lambda x: money(x)
				# 		},
				# 		header_align="CENTER"
				# 		,
				# 		# col_align={
				# 		#     show_cols["QtyOutstanding"]: "RIGHT",
				# 		#     show_cols["MOrderQty"]: "RIGHT",
				# 		#     show_cols["MReceivedQty"]: "RIGHT",
				# 		#     show_cols["TPrice"]: "RIGHT",
				# 		#     show_cols["PurchaseOrder"]: "LEFT",
				# 		#     show_cols["MStockCode"]: "LEFT",
				# 		#     show_cols["MOrigDueDate"]: "CENTER"
				# 		# }
				# 	)
				# ]
				#
				# # # # TOC (optional) â€” headings added after it will populate it
				# # # story += rlu.toc(styles)
				# #
				# # story += [rlu.h1("Section 1", styles), rlu.p("Some paragraph text.", styles)]
				# # story += [rlu.h2("Sales Order Pick Sheets Combined", styles)]
				# # story += [rlu.df_table(df_sales_order_pick_sheets, theme, styles, number_format={"Value": "{:,.2f}"})]
				# # story += [rlu.vspace(12)]
				# #
				# # # If you have a matplotlib chart saved as PNG:
				# # # plt.savefig("chart.png", dpi=150, bbox_inches="tight")
				# # # story += [h2("A figure", styles)]
				# # # story += figure("chart.png", styles, caption="Figure 1: Example chart", max_width=6.5*inch)
				#
				# # out = rlu.build_pdf(report_file_name, story, theme=theme, meta=meta)
				#
				# doc.build(story)
				# f_name = out.resolve()
				# print(f"Wrote: {f_name}")
				# return f_name

			if os.path.exists(report_file_name):
				from streamlit_pdf_viewer import pdf_viewer
				doc_pdf_viewer = pdf_viewer(
					report_file_name,
					key="testing_doc_generate_pdf",
					pages_to_render=[0]
				)
			else:
				st.info("Generate a PDF first.")

		test_0()

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
	with st.container(border=True, horizontal=True):
		st.write("admin_debugging")
		st.write(f"{pills_search_mode=}")
		st.write(f"{st.session_state.get(k_pills_search_mode)=}")
		st.write(f"{textbox_stockcode=}")

if isinstance(textbox_stockcode, (pd.DataFrame, pd.Series)):
	st.info(f"Select a stock code for more details.")
elif textbox_stockcode:
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

				df_stock_pdf = load_path_pdf(selectbox_stockcode).reset_index(drop=True)
				stock_pdf_listed = df_stock_pdf.loc[0, "PDF_Listed"] if not df_stock_pdf.empty else None
				stock_pdf_stock = df_stock_pdf.loc[0, "PDF_Stock"] if not df_stock_pdf.empty else None
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

				df_stock_change_requests = df_change_requests[
					df_change_requests["stockcode"].str.lower() == selectbox_stockcode.lower()]
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
			# 202601060910 the series looks better as a table
			# df_show_qty = pd.DataFrame(ser_stock[show_cols_qty]).transpose()
			# df_show_qty.columns = [col.replace("Qty", "") for col in df_show_qty.columns]
			# display_df(
			# 	# np.transpose(ser_stock[show_cols_qty]),
			# 	df_show_qty,
			# 	title="Quantity Info",
			# 	width="stretch"
			# )

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
			with st.expander(f"Purchase Orders ({df_stock_purchase_orders.shape[0]}):",
							 expanded=bool(df_stock_purchase_orders.shape[0])):
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
			with st.expander(f"Sales Orders ({df_stock_sales_orders.shape[0]}):",
							 expanded=bool(df_stock_sales_orders.shape[0])):
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
						active = str(row["ActiveFlag"]) == "1"
						if pd.isna(row["ActiveFlag"]) or (not str(row["ActiveFlag"]).strip()):
							active = str(row["OrderStatus"]) in VALID_SALES_ORDER_ACTIVE_STATUS_CODES
							active = active and (qty_reqd > 0)
						if active:
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
			with st.expander(f"Allocations ({df_stock_allocations.shape[0]}):",
							 expanded=bool(df_stock_allocations.shape[0])):
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
						st.success(
							f"Enough on hand to fulfill Yellow Tag #{row['ID']} for WO# {row["WO"]} from {row['DateCreated']:%Y-%m-%d %H:%M:%S}.")
					else:
						st.error(
							f"Short {abs(ttl_on_hand)} to fulfill Yellow Tag #{row['ID']} for WO# {row["WO"]} from {row['DateCreated']:%Y-%m-%d %H:%M:%S}.")
						ttl_on_hand = 0  # reset to 0 for order specific shortage count

			df_data = load_layout_data(building="hawkins")
			df_layout = df_data["Layout"]
			df_legend = df_data["Legend"]
			df_sections = df_data["ShelfSections"]
			df_shelves = df_data["Shelves"]

			found_map_to_bin: dict = {}

			df_bin_shelf = df_shelves.loc[df_shelves["Shelf"].str.lower().str.strip() == bin_location.strip().lower()]
			if not df_bin_shelf.empty:
				ser_bin_section = df_bin_shelf.iloc[0]
				bin_section = ser_bin_section["Section"]
				bin_section_id = ser_bin_section["ShelfSectionID"]
				bin_shelf_row = ser_bin_section["ShelfRow"]

				df_bin_shelf_section = df_sections.loc[df_sections["ID"] == bin_section_id]
				if not df_bin_shelf_section.empty:
					ser_bin_shelf_section = df_bin_shelf_section.iloc[0]
					try:
						bsr = int(bin_shelf_row)
					except (ValueError, TypeError):
						bsr = bin_shelf_row
					found_map_to_bin = dict(
						p_shelf=ser_bin_shelf_section["ParentShelf"],
						group=ser_bin_shelf_section["Group"],
						x0=ser_bin_shelf_section["X0"],
						x1=ser_bin_shelf_section["X1"],
						y0=ser_bin_shelf_section["Y0"],
						y1=ser_bin_shelf_section["Y1"],
						section=bin_section,
						section_id=bin_section_id,
						shelf_row=bsr,
						bin_location=bin_location,
						stockcode=textbox_stockcode
					)

					x0 = found_map_to_bin["x0"]
					y0 = found_map_to_bin["y0"]
					x1 = found_map_to_bin["x1"]
					y1 = found_map_to_bin["y1"]
					w = x1 - x0
					h = y1 - y0
					found_map_to_bin["w"] = w
					found_map_to_bin["h"] = h
					cx = x0 + w
					cy = y0 + h
					found_map_to_bin["cx"] = cx
					found_map_to_bin["cy"] = cy

					if not st.session_state.get(k_use_full_map_dot_size, False):
						ds = st.session_state.get(k_map_dot_size, 1)
						wd = (ds - w) / 2
						hd = (ds - h) / 2
						x_0 = x0 - wd
						x_1 = x1 + wd
						y_0 = y0 - hd
						y_1 = y1 + hd
						cx = x_0 + (ds / 2)
						cy = y_0 + (ds / 2)

						found_map_to_bin.update({
							"x0": x_0,
							"y0": y_0,
							"x1": x_1,
							"y1": y_1,
							"w": ds,
							"h": ds,
							"cx": cx,
							"cy": cy
						})

			with st.expander(f"Map", expanded=bool(found_map_to_bin)):
				if user in admin_end_users:
					with st.container(border=True, horizontal=True):
						st.write("admin_debugging")
						st.write(found_map_to_bin)
				if found_map_to_bin:
					st.subheader("Map Controls")
					show_sections = False
					rotation_deg = 90
					overlay_section = st.checkbox("Overlay Sections", value=show_sections)
					checkbox_use_full_map_dot_size = st.checkbox(
						label="Use full bin size for dot marking",
						key=k_use_full_map_dot_size
					)
					number_input_map_dot_size = st.number_input(
						label="Use full bin size for dot marking",
						key=k_map_dot_size,
						min_value=1,
						max_value=100
					)
					colour_dot = st.color_picker(
						label="Dot Colour:",
						value=Colour("#CC1112").hex_code
					)

					fig = load_hawkins_map(
						building="hawkins",
						found_map_to_bin=found_map_to_bin,
						dot_colour=colour_dot,
						title=f"Bin {bin_location} shown on map:",
						deg_rot=rotation_deg
					)

					fig.update_layout(
						width=1200,
						height=700
					)
					chart = st.plotly_chart(
						fig
					)

				# st.session_state["selected_section_id"] = None
				# bg_map = build_legend_bg_map(df_legend)
				#
				# st.subheader("Map Controls")
				# show_sections = False
				# rotation_deg = 90
				# overlay_section = st.checkbox("Overlay Sections", value=show_sections)
				# checkbox_use_full_map_dot_size = st.checkbox(
				# 	label="Use full bin size for dot marking",
				# 	key=k_use_full_map_dot_size
				# )
				# number_input_map_dot_size = st.number_input(
				# 	label="Use full bin size for dot marking",
				# 	key=k_map_dot_size,
				# 	min_value=1,
				# 	max_value=100
				# )
				# colour_dot = st.color_picker(
				# 	label="Dot Colour:",
				# 	value=Colour("#CC1112").hex_code
				# )
				#
				# img0 = layout_to_rgb_image(df_layout, bg_map)
				# H, W = img0.shape[:2]
				#
				# img = rotate_img(img0, rotation_deg)
				# df_sections_plot = rot_rect(df_sections, W=W, H=H, rotation_deg=rotation_deg)
				# msg_shelf = f' Shelf #{found_map_to_bin['shelf_row'] if found_map_to_bin else ''}'
				# fig = build_plotly_map(
				# 	img=img,
				# 	df_sections=df_sections_plot,
				# 	bg_map=bg_map,
				# 	rotation_deg=rotation_deg,
				# 	show_sections=overlay_section,
				# 	selected_section_id=st.session_state["selected_section_id"],
				# 	title=f"Bin {bin_location} shown on map{msg_shelf}:"
				# )
				# if found_map_to_bin:
				# 	x0 = found_map_to_bin["x0"]
				# 	y0 = found_map_to_bin["y0"]
				# 	x1 = found_map_to_bin["x1"]
				# 	y1 = found_map_to_bin["y1"]
				# 	cx = found_map_to_bin["cx"]
				# 	cy = found_map_to_bin["cy"]
				# 	x0, y0 = rot_point_xy(x0, y0, W=W, H=H, rotation_deg=rotation_deg)
				# 	x1, y1 = rot_point_xy(x1, y1, W=W, H=H, rotation_deg=rotation_deg)
				# 	cx, cy = rot_point_xy(cx, cy, W=W, H=H, rotation_deg=rotation_deg)
				# 	found_map_to_bin.update({
				# 		"x0": x0,
				# 		"y0": y0,
				# 		"x1": x1,
				# 		"y1": y1,
				# 		"cx": cx,
				# 		"cy": cy
				# 	})
				# 	fig.add_shape(
				# 		type="circle",
				# 		xref="x", yref="y",
				# 		x0=found_map_to_bin["x0"], x1=found_map_to_bin["x1"],
				# 		y0=found_map_to_bin["y0"], y1=found_map_to_bin["y1"],
				# 		line=dict(width=2, color=colour_dot),
				# 		fillcolor=colour_dot,
				# 		opacity=0.5,
				# 		layer="above",
				# 	)
				# 	x_off = 40
				# 	y_off = 18
				# 	fig.add_annotation(
				# 		x=found_map_to_bin["cx"],
				# 		y=found_map_to_bin["cy"],
				# 		xref="x", yref="y",
				# 		ax=x_off if ((found_map_to_bin["cx"] + x_off) <= W) else -x_off,
				# 		ay=y_off if ((found_map_to_bin["cy"] + y_off) <= H) else -y_off,
				# 		text=f"StockCode: '{textbox_stockcode}' located in bin '{bin_location}' on{msg_shelf.lower()}",
				# 		showarrow=True,
				# 		font=dict(size=10, color="black")
				# 	)
				# fig.update_layout(
				# 	width=1200,
				# 	height=700
				# )
				# chart = st.plotly_chart(
				# 	fig
				# )
				else:
					st.info(f"Could not locate '{bin_location}' on the map.")

		else:
			st.info(f"No parts found matching search criteria. Check your filters, if needed.")

with cont_top_control:
	# FINALLY create the widget, this will allow for the state to be programmatically changed.

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