from streamlit_utility import display_df
from pyodbc_connection import connect
from streamlit_auth import st_auth, show_change_password

import streamlit as st
import pandas as pd


st.set_page_config(
    layout="wide"
)


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
    return connect(sql)


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
	[SysproCompanyA].[dbo].[PorMasterDetail] [PD]
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
		[SysproCompanyA].[dbo].[PorHistReceipt] [PRs]
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
	[SysproCompanyA].[dbo].[ApSupplier] [AS]
ON
	[PR].[Supplier] = [AS].[Supplier]
WHERE
	[PD].[MStockCode] = '{stockcode}'
"""
    return connect(sql)

if st_auth():
    
    st.header("Parts")
    user = st.session_state.get("user", "??")
    st.write(f"welcome {user}")
    # if st.button("change password"):
    with st.popover("change password"):
        if show_change_password():
            st.rerun()


    df_parts = load_parts_data()

    # list_bins = df_parts["DefaultBin"].unique().tolist()
    list_stockcodes = df_parts["StockCode"].unique().tolist()

    # search for a stockcode
    # view bin and quantities
    # view past movements
    # view open jobs / so / po #s

    # search for all parts in a bin


    k_checkbox_warehouse_1_only = "key_checkbox_warehouse_1_only"
    st.session_state.setdefault(k_checkbox_warehouse_1_only, True)
    checkbox_warehouse_1_only = st.checkbox(
        label="Warehouse 01 Stockcodes only?",
        key=k_checkbox_warehouse_1_only
    )

    # k_selectbox_stockcode = "key_selectbox_stockcode"
    # selectbox_stockcode = st.selectbox(
    #     label="Stockcode:",
    #     key=k_selectbox_stockcode,
    #     options=list_stockcodes
    # )
    k_textbox_stockcode = "key_textbox_stockcode"
    textbox_stockcode = st.text_input(
        label="Stockcode:",
        key=k_textbox_stockcode
    )

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

        if checkbox_warehouse_1_only:
            df_stock_movements = df_stock_movements[df_stock_movements["Warehouse"] == "01"]

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

        with st.expander("Movements:"):
            k_checkbox_movement_inc_issue = "key_checkbox_movement_inc_issue"
            st.session_state.setdefault(k_checkbox_movement_inc_issue, True)
            checkbox_movement_inc_issue = st.checkbox(
                label="Include 'Issue' movements?",
                key=k_checkbox_movement_inc_issue
            )
            k_checkbox_movement_inc_sale = "key_checkbox_movement_inc_sale"
            st.session_state.setdefault(k_checkbox_movement_inc_sale, True)
            checkbox_movement_inc_sale = st.checkbox(
                label="Include 'Sale' movements?",
                key=k_checkbox_movement_inc_sale
            )

            if not checkbox_movement_inc_issue:
                df_stock_movements = df_stock_movements[
                    df_stock_movements["MovementType"] != "ISSUE"
                ]
            if not checkbox_movement_inc_sale:
                df_stock_movements = df_stock_movements[
                    df_stock_movements["MovementType"] != "SALE"
                ]

            total_records: int = df_stock_movements.shape[0]
            k_max_records_movements = "key_max_records_movements"
            st.session_state.setdefault(k_max_records_movements, 100)
            if st.button(
                "Show All?"
            ):
                st.session_state.update({k_max_records_movements: total_records})
            max_records_movements = st.number_input(
                label="Max Records:",
                key=k_max_records_movements,
                min_value=1,
                max_value=df_stock_movements.shape[0]
            )

            df_stock_movements = df_stock_movements.head(max_records_movements)

            show_cols = df_stock_movements.columns.to_list()
            cols_to_rem = [
                "StockCode",
                "EntryDate",
                "TrnTime",
            ]
            if checkbox_warehouse_1_only:
                cols_to_rem.append("Warehouse")
            for col in cols_to_rem:
                show_cols.remove(col)

            display_df(
                df_stock_movements[show_cols],
                # f"Movements for StockCode: {selectbox_stockcode}"
                title=f"Total: ({total_records} Rows x {len(show_cols)} Cols) - Showing:",
                width="stretch"
            )
        
        with st.expander("Purchase Orders:"):
            k_checkbox_po_unfulfilled_only = "key_checkbox_po_unfulfilled_only"
            st.session_state.setdefault(k_checkbox_po_unfulfilled_only, True)
            checkbox_po_unfulfilled_only = st.checkbox(
                label="Unfulfilled Purchase Orders Only?",
                key=k_checkbox_po_unfulfilled_only
            )
            if checkbox_po_unfulfilled_only:
                df_stock_purchase_orders = df_stock_purchase_orders[
                    (df_stock_purchase_orders["MCompleteFlag"] != "Y")
                    & (df_stock_purchase_orders["MReceivedQty"] < df_stock_purchase_orders["MOrderQty"])
                ]

            display_df(
                df_stock_purchase_orders,
                title="Purchase Orders",
                width="stretch"
            )
        
        with st.expander("Sales Orders:"):
            k_checkbox_so_unfulfilled_only = "key_checkbox_so_unfulfilled_only"
            st.session_state.setdefault(k_checkbox_so_unfulfilled_only, True)
            checkbox_so_unfulfilled_only = st.checkbox(
                label="Unfulfilled Sales Orders Only?",
                key=k_checkbox_so_unfulfilled_only
            )
            if checkbox_so_unfulfilled_only:
                df_stock_sales_orders = df_stock_sales_orders[
                    (df_stock_sales_orders["CancelledFlag"] != "Y")
                    & (df_stock_sales_orders["ActiveFlag"] != "N")
                ]

            display_df(
                df_stock_sales_orders,
                title="Sales Orders",
                width="stretch"
            )

 
# query to select parts allocated and unallocated think 'where used'
#             SELECT
# 	[TrnDateTime],
# 	*
# FROM
# 	[SysproCompanyA].[dbo].[WipJobAllMat] [JM]
# LEFT JOIN (
# 	SELECT
# 		[JP].*,
# 		[JPdt].[TrnDateTime]
# 	FROM
# 		[SysproCompanyA].[dbo].[WipJobPost] [JP]
# 	INNER JOIN
# 		[SysproCompanyA].[dbo].[v_PROD_WipJobPostDateTime] [JPdt]
# 	ON
# 		([JP].[Job] = [JPdt].[Job])
# 		AND ([JP].[Line] = [JPdt].[Line])
# 		AND ([JP].[MStockCode] = [JPdt].[MStockCode])
# ) AS [JP]
# ON
# 	([JM].[StockCode] = [JP].[MStockCode])
# 	AND ([JM].[Job] = [JP].[Job])
# 	--AND ([JM].[OperationOffset] = [JP].[LOperation])
# WHERE
# 	--[SD].[MStockCode] = '2600726'
# 	--[PD].[MStockCode] = '402377'
# 	--[JM].[StockCode] = '03816'
# 	--[JM].[StockCode] = '06914'
# 	[JM].[StockCode] = '06110'
# 	--AND [JM].[Job] = '10017692'
# 	AND (([JM].[QtyIssued] <= [JM].[QtyToIssue])
# 		AND ([JM].[AllocCompleted] = 'N'))

# ORDER BY
# 	[JP].[TrnDateTime] DESC
# ;