from streamlit_utility import display_df, load_pdf_binary, display_df_paginated
from pyodbc_connection import connect
from streamlit_auth import st_auth, show_change_password
from datetime_utility import time_between
from utility import percent

from streamlit_pills import pills
from typing import Literal

import streamlit as st
import pandas as pd
import datetime
import asyncio
import os


st.set_page_config(
    layout="wide",
    page_title="Parts"
)


PATH_STOCK_PDFS: str = r"J:\VaultWorkspace_BWS\PDFS"
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
	[IM].[MovementType],
	[IM].[Reference],
	[IM].[SalesOrder]
FROM
	[SysproCompanyA].[dbo].[InvMovements] [IM] WITH (NOLOCK)
INNER JOIN
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
    df["MovementType"] = df["MovementType"].apply(lambda mt: "ISSUE" if mt == "I" else ("SALE" if mt == "S" else mt))
    df["SalesOrder"] = df["SalesOrder"].apply(lambda so: so_fmt(so, "int"))
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

INNER JOIN
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

    with st.popover("Filter"):
        k_checkbox_warehouse_1_only = "key_checkbox_warehouse_1_only"
        st.session_state.setdefault(k_checkbox_warehouse_1_only, True)
        checkbox_warehouse_1_only = st.checkbox(
            label="Warehouse 01 Stockcodes only?",
            key=k_checkbox_warehouse_1_only
        )

        k_checkbox_hawkins_parts_inc = "key_checkbox_hawkins_parts_inc"
        st.session_state.setdefault(k_checkbox_hawkins_parts_inc, True)
        checkbox_hawkins_parts_inc = st.checkbox(
            label="Include parts @ Hawkins Warehouse?",
            key=k_checkbox_hawkins_parts_inc
        )

        k_checkbox_montana_parts_inc = "key_checkbox_montana_parts_inc"
        st.session_state.setdefault(k_checkbox_montana_parts_inc, True)
        checkbox_montana_parts_inc = st.checkbox(
            label="Include parts @ Montana Warehouse?",
            key=k_checkbox_montana_parts_inc
        )

        k_checkbox_vmi_parts_inc = "key_checkbox_vmi_parts_inc"
        st.session_state.setdefault(k_checkbox_vmi_parts_inc, False)
        checkbox_vmi_parts_inc = st.checkbox(
            label="Include parts in Vending Machines?",
            key=k_checkbox_vmi_parts_inc
        )

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

    options_pills_search_mode = ["Single", "Multi", "By Bin", "By Section"]
    k_pills_search_mode: str = "key_pills_search_mode"
    st.session_state.setdefault(k_pills_search_mode, 0)
    pills_search_mode = pills(
        label="Search Mode:",
        key=k_pills_search_mode,
        options=options_pills_search_mode,
        index=0
    )

    if pills_search_mode == options_pills_search_mode[1]:
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

    elif pills_search_mode == options_pills_search_mode[2]:
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

            display_df_paginated(
                df_search_bin,
                "df_search_bin"
            )
    
    elif pills_search_mode == options_pills_search_mode[3]:
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

            display_df_paginated(
                df_search_section,
                "df_search_section"
            )

    else:
        # Single
        k_textbox_stockcode = "key_textbox_stockcode"
        textbox_stockcode = st.text_input(
            label="Stockcode:",
            key=k_textbox_stockcode
        )

    if pills_search_mode not in options_pills_search_mode[2:4]:
        # searching for non-bin locations

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

            ser_stock: pd.Series = df_parts[df_parts["StockCode"] == selectbox_stockcode].iloc[0]

            bin_location: str = ser_stock["DefaultBin"]
            qty_on_hand: float = ser_stock["QtyOnHand"]
            
            show_cols_info = [col for col in ser_stock.index if "qty" not in str(col).lower()]
            show_cols_qty = [col for col in ser_stock.index if "qty" in str(col).lower()]
            cols_information = st.columns(3)
            with cols_information[0]:
                display_df(
                    ser_stock[show_cols_info],
                    title="Info",
                    width="stretch"
                )

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
                    st.write(f"No PDFs found for this stockcode.")
            with cols_information[1]:
                st.metric(
                    "Bin:",
                    value=bin_location
                )
                st.metric(
                    "On Hand:",
                    value=qty_on_hand
                )
            with cols_information[2]:
                display_df(
                    ser_stock[show_cols_qty],
                    title="Quantity Info",
                    width="stretch"
                )
            
            k_checkbox_movement_inc_issue = "key_checkbox_movement_inc_issue"
            checkbox_movement_inc_issue = st.session_state.setdefault(k_checkbox_movement_inc_issue, True)
            k_checkbox_movement_inc_sale = "key_checkbox_movement_inc_sale"
            checkbox_movement_inc_sale = st.session_state.setdefault(k_checkbox_movement_inc_sale, True)

            if not checkbox_movement_inc_issue:
                df_stock_movements = df_stock_movements[
                    df_stock_movements["MovementType"] != "ISSUE"
                ]
            if not checkbox_movement_inc_sale:
                df_stock_movements = df_stock_movements[
                    df_stock_movements["MovementType"] != "SALE"
                ]
            total_records: int = df_stock_movements.shape[0]

            with st.expander(f"Movements ({total_records}):"):
                k_max_records_movements = "key_max_records_movements"
                st.session_state.setdefault(k_max_records_movements, df_stock_movements.shape[0])
                if st.button(
                    "Show All?"
                ):
                    st.session_state.update({
                        k_max_records_movements: total_records,
                        k_checkbox_movement_inc_issue: True,
                        k_checkbox_movement_inc_sale: True
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

                max_records_movements = st.number_input(
                    label="Max Records:",
                    key=k_max_records_movements,
                    min_value=0,
                    max_value=df_stock_movements.shape[0]
                )

                df_stock_movements = df_stock_movements.head(max_records_movements)

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

                display_df(
                    df_stock_movements[show_cols],
                    # f"Movements for StockCode: {selectbox_stockcode}"
                    title=f"Total: ({total_records} Rows x {len(show_cols)} Cols) - Showing:",
                    width="stretch"
                )
            
            k_checkbox_po_unfulfilled_only = "key_checkbox_po_unfulfilled_only"
            checkbox_po_unfulfilled_only = st.session_state.setdefault(k_checkbox_po_unfulfilled_only, True)
            if checkbox_po_unfulfilled_only:
                df_stock_purchase_orders = df_stock_purchase_orders[
                    (df_stock_purchase_orders["MCompleteFlag"] != "Y")
                    & (df_stock_purchase_orders["MReceivedQty"] < df_stock_purchase_orders["MOrderQty"])
                ]
            with st.expander(f"Purchase Orders ({df_stock_purchase_orders.shape[0]}):"):
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
            with st.expander(f"Sales Orders ({df_stock_sales_orders.shape[0]}):"):
                checkbox_so_unfulfilled_only = st.checkbox(
                    label="Unfulfilled Sales Orders Only?",
                    key=k_checkbox_so_unfulfilled_only
                )

                display_df(
                    df_stock_sales_orders,
                    title="Sales Orders",
                    width="stretch"
                )

            k_checkbox_alloc_unfulfilled_only: str = "key_checkbox_alloc_unfulfilled_only"
            checkbox_alloc_unfulfilled_only = st.session_state.setdefault(k_checkbox_alloc_unfulfilled_only, True)
            if checkbox_alloc_unfulfilled_only:
                df_stock_allocations = df_stock_allocations[
                    (df_stock_allocations["AllocCompleted"] != "Y")
                ]
            with st.expander(f"Allocations ({df_stock_allocations.shape[0]}):"):
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


    # if user in ["abriggs", "rec"]:
    if user in ["abriggs"]:
        pb_day = st.progress(value=0)
        pb_week = st.progress(value=0)
        asyncio.run(run_day())

