from streamlit_utility import display_df, load_pdf_binary, display_df_paginated
from pyodbc_connection import connect
from streamlit_auth import st_auth, show_change_password, save_user_settings, get_user_settings
from datetime_utility import time_between
from utility import percent
from colour_utility import Colour, random_colour, gradient_merge
from json_utility import jsonify

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


@st.cache_data(ttl=60*60, show_spinner=True)
def load_bin_location_data() -> pd.DataFrame:
    sql = """

-- Bin Locations in Duplicate
-- 2025-12-08

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
		ELSE
			1 -- Hawkins Only
	END) AS [BuildingCode],
	(CASE WHEN 
			LOWER([IW].[DefaultBin]) LIKE '%/%'
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
WHERE
	ISNULL([BC1].[DefaultBin], '') <> ''
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
	[IM].[StockCode] = '{stockcode}'
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
def load_so_details(stockcode: str) -> pd.DataFrame:
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
	[SD].[MStockCode] = '{stockcode}'
"""
    df = connect(sql)
    df["SalesOrder"] = df["SalesOrder"].apply(lambda so: so_fmt(so, "int"))
    return df


@st.cache_data(ttl=60*60, show_spinner=True)
def load_po_details(stockcode: str) -> pd.DataFrame:
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
	[PD].[MStockCode] = '{stockcode}'
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
	([JM].[Job] = [PD].[WO#])
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
	[JM].[StockCode] = '{stockcode}'
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
    [ID]
    ,[DateCreated]
    ,[LastModified]
    ,[Active]
    ,[DateActive]
    ,[DateInActive]
    ,[PO]
    ,[WO]
    ,[StockCode]
    ,[YTDescription]
    ,[QtyMissing]
    ,[Notes]
    ,[QtyOnHand]
    ,[Description]
    ,[LongDesc]
    ,[Supplier]
    ,[Warehouse]
    ,[LastPurchDate]
    ,[POOrigDueDate]
    ,[POLatestDueDate]
    ,[Bin]
    ,[POReceivedQty]
    ,[DrawingPath]
FROM
    [BWSdb].[dbo].[v_PROD_YellowTags] [YT] WITH (NOLOCK)
WHERE
    [YT].[StockCode] = '{stockcode}'
;
"""
    df = connect(sql)
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
                    "notes": text_field_notes
                })

                with open(path_abs, "w") as f:
                    json.dump(data, f)

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
	[IM].[StockCode] = '{stockcode}'
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


def po_fmt(po_num: int | str, out_type: Literal["int", "str"], word_size: int = 16) -> int | str:
    if out_type == "str":
        return str(po_num).rjust(word_size, "0")
    else:
        while po_num and (po_num[0] == "0"):
            po_num = po_num[1:]
        return po_num


def so_fmt(so_num: int | str, out_type: Literal["int", "str"], word_size: int = 16) -> int | str:
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

    # list_bins = df_parts["DefaultBin"].unique().tolist()
    list_stockcodes = df_parts["StockCode"].unique().tolist()

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

        list_settings_keys.extend([
            k_checkbox_warehouse_1_only,
            k_checkbox_hawkins_parts_inc,
            k_checkbox_montana_parts_inc,
            k_checkbox_vmi_parts_inc
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
    op_search_mode_by_shopclock: str = "ShopClock"
    options_pills_search_mode = [
        op_search_mode_simple, 
        op_search_mode_advanced,
        op_search_mode_by_bin,
        op_search_mode_by_section,
        op_search_mode_by_po,
        op_search_mode_by_so,
        op_search_mode_by_shopclock
    ]
    k_pills_search_mode: str = "key_pills_search_mode"
    st.session_state.setdefault(k_pills_search_mode, 0)
    pills_search_mode = pills(
        label="Search Mode:",
        key=k_pills_search_mode,
        options=options_pills_search_mode,
        index=0
    )

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
                        k_text_multi_2: ""
                    })
                    st.rerun()

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
                    st.session_state.update({k_search_text_widgets: text_widgets})
                    st.rerun()
            
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

    elif pills_search_mode == op_search_mode_by_bin:
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
    
    elif pills_search_mode == op_search_mode_by_section:
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

    elif pills_search_mode == op_search_mode_by_po:
        # By PO
        st.info(f"coming soon!")
    
    elif pills_search_mode == op_search_mode_by_so:
        # By SO
        st.info(f"coming soon!")
    
    elif pills_search_mode == op_search_mode_by_shopclock:
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

    if pills_search_mode in [
        op_search_mode_simple,
        op_search_mode_advanced
    ]:
        # searching for stockcode specific results

        selectbox_stockcode = None
        if textbox_stockcode:
            if textbox_stockcode in list_stockcodes:
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
            df_stock_sales_orders: pd.DataFrame = load_so_details(selectbox_stockcode)
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

            df_stock: pd.DataFrame = df_parts[df_parts["StockCode"] == selectbox_stockcode]
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

                    with st.expander(f"Drawings"):
                        df_stock_pdf = load_path_pdf(selectbox_stockcode)
                        stock_pdf_listed = df_stock_pdf.loc[0, "PDF_Listed"]
                        stock_pdf_stock = df_stock_pdf.loc[0, "PDF_Stock"]
                        if stock_pdf_listed or stock_pdf_stock:
                            if stock_pdf_listed:
                                st.download_button(
                                    label="download PDF as listed in Syspro?",
                                    data=open(stock_pdf_listed, "rb").read(),
                                    file_name=f"{selectbox_stockcode.replace(' ', '_')}.pdf",
                                    mime="application/pdf"
                                )
                            if stock_pdf_stock:
                                st.download_button(
                                    label="Download found PDF from drive?",
                                    data=open(stock_pdf_stock, "rb").read(),
                                    file_name=f"{selectbox_stockcode.replace(' ', '_')}.pdf",
                                    mime="application/pdf"
                                )
                        else:
                            st.info(f"No PDFs found for this stockcode.")
                
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
                        st.rerun()

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

                    move_events = []
                    for i, row in df_stock_movements.iterrows():
                        sc = row["StockCode"]
                        tt = row["TrnType"]
                        qty = row["TrnQty"]
                        ref = row["SalesOrder"] if ((not pd.isna(row["SalesOrder"])) and (row["SalesOrder"])) else row["Job"]
                        date_s = row["TrnDateTime"]
                        date_e = date_s + datetime.timedelta(minutes=10)
                        move_events.append({
                            "id": i,    
                            "title": f"{tt} {qty} {ref}",
                            "start": date_s.strftime(UTC_FMT).removesuffix("Z"),
                            "end": date_e.strftime(UTC_FMT).removesuffix("Z")
                            # ,
                            # "url": NHL_URL.removesuffix("/") + row["game_center_link"]
                        })

                    # print(move_events)

                    k_cal_movements: str = "key_cal_movements"
                    if k_cal_movements in st.session_state:
                        cm = st.session_state[k_cal_movements]
                        st.write(f"cm:")
                        st.write(cm)
                        es = cm.get("eventsSet", {})
                        view = es.get("view", {})
                        active_start = view.get("activeStart")
                        active_end = view.get("activeEnd")
                        ac_s = datetime.datetime.fromisoformat(active_start)
                        ac_e = datetime.datetime.fromisoformat(active_end)
                        ac_m = ac_s + datetime.timedelta(seconds=(ac_e - ac_s).total_seconds() / 2)
                        if active_start and active_end:
                            me = []
                            for me in move_events:
                                start = datetime.datetime.fromisoformat(me["start"])
                                end = datetime.datetime.fromisoformat(me["end"])
                                if start <= ac_m <= end:
                                    me.append(me)
                            move_events = me

                    st.write(move_events)
                    
                    cal_movements = calendar(
                        events=move_events,
                        options={
                            "multiMonthMaxColumns": 3,
                            "height": 1800,
                            "contentHeight": 500,
                            "expandRows": True,
                            "dayMaxEventRows": 10,  # unlimited rows per day (or set an int)
                            "eventDisplay": "block",
                            "displayEventTime": False,
                            "slotMinTime": "05:00:00",
                            "slotMaxTime": "17:30:00",
                            "initialView": "resourceTimelineDay"
                            # ,
                            # "moreLinkClick": "popover",  # still works without callbacks
                        },
                        key=k_cal_movements
                    )
                    st.write(cal_movements)
                
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
                            st.success(f"Enough on hand to fulfill SO# {row['SalesOrder']}.")
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


    # if user in ["abriggs", "rec"]:
    if user in ["abriggs"]:
        pb_day = st.progress(value=0)
        pb_week = st.progress(value=0)
        asyncio.run(run_day())

