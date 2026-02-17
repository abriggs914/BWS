import datetime
import json
import os.path

import pandas as pd

from dataframe_utility import norm_columns
from datetime_utility import date_str_format
from json_utility import jsonify
from pyodbc_connection import connect
from streamlit_utility import *
from streamlit_pills import pills
from utility import money

from colour_utility import RED, GREEN

import streamlit_auth_sql as auth
########################################################################
# Begin Auth Boilerplate

APP_NAME: str = st.secrets["app"]['app_name']
PAGE_NAME: str = f"{APP_NAME}_metrics"

if not auth.st_auth(APP_NAME):
	st.info(f"Please contact Avery for further help with registering for this program.")
	# Go no further
	st.stop()

admin_end_users = ["abriggs"]
admin_test_users = ["rec"] + admin_end_users
user = st.session_state.get("user", "??")

if user in admin_test_users:
	with st.sidebar:
		if st.button(
			label="Clear Cache & Rerun",
			key=f"k_clear_cache_rerun"
		):
			st.cache_data.clear()
			st.cache_resource.clear()
			st.rerun()
		with st.popover("session_state"):
			info_dict = auth.load_session_state_info()
			st.write(info_dict)

# if st.button("change password"):
with st.popover("change password"):
	if auth.show_change_password(APP_NAME):
		st.rerun()

# End Auth Boilerplate
########################################################################


st.set_page_config(layout="wide")

QUERY_HOLD_TIME: int = 60 * 15  # 15 minutes
new_idea_file = r"C:\Access\metric_ideas_20251002.json"


def hour_fmt(val):
	return f'{val:.3f} Hrs'


k_pills_mode: str = "key_pills_mode"
options_pills_mode: list[str] = ["New", "Old (Nov 2025)"]
st.session_state.setdefault(k_pills_mode, 0)
pills_mode = pills(
	label="Mode",
	key=k_pills_mode,
	options=options_pills_mode,
	index=0
)


if pills_mode == options_pills_mode[1]:
	# Old (Nov 2025)


	@st.cache_data(show_spinner=True, ttl=QUERY_HOLD_TIME)
	def load_posted(date_in: datetime.date) -> pd.DataFrame:
		sql = f"""
	SELECT
		[JPD].[TrnDateTime],
		[JP].*
	FROM
		[SysproCompanyA].[dbo].[WipJobPost] [JP]
	INNER JOIN
		[SysproCompanyA].[dbo].[v_PROD_WipJobPostDateTime] [JPD]
	ON
		([JP].[Job] = [JPD].[Job])
		AND ([JP].[Line] = [JPD].[Line])
	WHERE
		CAST([JPD].[TrnDateTime] AS DATE) = '{date_in:%Y-%m-%d}'
		"""
		return connect(sql)


	@st.cache_data(show_spinner=True, ttl=QUERY_HOLD_TIME)
	def load_order_data(date_in: datetime.date) -> pd.DataFrame:
		sql = f"""
	SELECT
		[O].[Quote Date]
		,[O].[Order Date]
		,[O].[Date Registered]
		,[O].[Date Declined]
		,[O].[Decline/Rejected]
		,[O].[Date In Service]
		,[O].[Invoice Date]
	
		,[O].[Quote#]
		,[O].[WO#]
		,[O].[Serial Number]
		,[O].[ProductID]
		,[O].[Model No]
		,[O].[US Sale]
		,[O].[Price]
	
		,ISNULL([P].[Prod Date], [P].[Prod Date2]) AS [ProdDate]
		,ISNULL([P].[Prod Line], [P].[Prod Line2]) AS [ProdLine]
		
		,[C].[Customer]
		,[D].[COMPANY NAME]
	FROM
		[BWSdb].[dbo].[Orders] [O]
	LEFT JOIN
		[BWSdb].[dbo].[Production] [P]
	ON
		[O].[Quote#] = [P].[Quote#]
	LEFT JOIN
		[BWSdb].[dbo].[Customers] [C]
	ON
		[O].[CustID] = [C].[ID#]
	LEFT JOIN
		[BWSdb].[dbo].[Dealers] [D]
	ON
		[O].[DealerID] = [D].[ID]
	WHERE
		([O].[Quote Date] = '{date_in:%Y-%m-%d}')
		OR ([O].[Order Date] = '{date_in:%Y-%m-%d}')
		OR ([O].[Date Registered] = '{date_in:%Y-%m-%d}')
		OR ([O].[Date Declined] = '{date_in:%Y-%m-%d}')
		OR ([O].[Date In Service] = '{date_in:%Y-%m-%d}')
		OR ([O].[Invoice Date] = '{date_in:%Y-%m-%d}')
		
		OR ([P].[Prod Date] = '{date_in:%Y-%m-%d}')
		OR ([P].[Prod Date2] = '{date_in:%Y-%m-%d}')
		"""
		return connect(sql)


	@st.cache_data(show_spinner=True, ttl=QUERY_HOLD_TIME)
	def load_sales_order_data(date_in: datetime.date) -> pd.DataFrame:
		sql = f"""
	SELECT
		[SM].[SalesOrder],
		[AR].[InvoiceDate],
		[SM].[OrderDate],
		[SM].[DateLastDocPrt],
		[SM].[DateLastInvPrt],
		[SM].[EntrySystemDate],
		[SM].[ReqShipDate],
		[SM].[OrderStatus],
		[SM].[Salesperson],
		[SM].[CustomerName],
		[SM].[Email],
		[SM].[ShippingInstrs],
		[SM].[ShipAddress1],
		[SM].[ShipAddress2],
		[SM].[ShipAddress3],
		[SM].[ShipAddress4],
		[SM].[ShipAddress5],
		[SM].[InvoiceCount],
		[SM].[LastInvoice],
		[SM].[Area],
		[SM].[ExchangeRate],
		[SM].[LastOperator],
	
		[SD].[SalesOrderLine],
		[SD].[LineType],
		[SD].[MProductClass],
		[IM].[PartCategory],
		[IM].[Supplier],
		[AS].[SupplierName],
		[AS].[SupShortName],
		[SD].[MStockCode],
		[IM].[Description],
		[IM].[LongDesc],
		[IM].[WarehouseToUse],
		[SD].[MWarehouse],
		[SD].[MBin],
		[IW].[DefaultBin],
		[SD].[MOrderQty],
		[SD].[MShipQty],
		[SD].[MBackOrderQty],
		[SD].[MUnitCost],
		[SD].[MOrderUom],
		[SD].[MPrice],
		[SD].[MDiscPct1],
		[SD].[MDiscPct2],
		[SD].[MDiscPct3],
		[SD].[MLineShipDate],
		[SD].[NComment],
		[AR].[Customer],
		[AR].[Invoice],
		[AS].[LastPurchDate],
	
		[IW].[QtyOnHand],
		[IW].[QtyOnOrder],
		[IW].[QtyOnBackOrder],
		[IW].[QtyAllocated],
		[IW].[QtyAllocatedToPick],
		[IW].[QtyAllocatedWip],
		[IW].[DateLastSale],
		[IW].[DateLastStockMove],
		[IW].[DateLastPurchase]
	FROM
		[SysproCompanyA].[dbo].[SorMaster] [SM] WITH (NOLOCK)
	LEFT JOIN
		[SysproCompanyA].[dbo].[SorDetail] [SD] WITH (NOLOCK)
	ON
		[SM].[SalesOrder] = [SD].[SalesOrder]
	LEFT JOIN
		[SysproCompanyA].[dbo].[InvMaster] [IM] WITH (NOLOCK)
	ON
		[SD].[MStockCode] = [IM].[StockCode]
	LEFT JOIN
		[SysproCompanyA].[dbo].[ArInvoice] [AR]
	ON
		[SM].[LastInvoice] = [AR].[Invoice]
	LEFT JOIN
		[SysproCompanyA].[dbo].[ApSupplier] [AS] WITH (NOLOCK)
	ON
		[IM].[Supplier] = [AS].[Supplier]
	LEFT OUTER JOIN
		[SysproCompanyA].[dbo].[InvWarehouse] [IW] WITH (NOLOCK)
	ON
		[IM].[StockCode] = [IW].[StockCode]
		AND [SD].[MWarehouse] = [IW].[Warehouse]
	WHERE
		([SM].[DateLastDocPrt] = '{date_in:%Y-%m-%d}')
		OR ([SM].[DateLastInvPrt] = '{date_in:%Y-%m-%d}')
		OR ([SM].[EntrySystemDate] = '{date_in:%Y-%m-%d}')
		OR ([SD].[MLineShipDate] = '{date_in:%Y-%m-%d}')
		OR ([SM].[OrderDate] = '{date_in:%Y-%m-%d}')
		OR ([SM].[ReqShipDate] = '{date_in:%Y-%m-%d}')
		OR ([AR].[InvoiceDate] = '{date_in:%Y-%m-%d}')
	;
		"""
		return connect(sql)


	@st.cache_data(show_spinner=True, ttl=QUERY_HOLD_TIME)
	def load_purchase_order_data(date_in: datetime.date) -> pd.DataFrame:
		sql = f"""
	SELECT
		[PM].[MLatestDueDate],
		[HR].[DateReceived],
		[PM].[MOrigDueDate],
		[PH].[OrderEntryDate],
		[PH].[OrderDueDate],
		[PH].[DateLastDocPrt],
		[PH].[MemoDate],
	
		[PM].[PurchaseOrder],
		[PM].[Line],
		[PM].[MStockCode],
		[PM].[MStockDes],
		[PM].[MWarehouse],
		[PM].[MOrderUom],
		[PM].[MOrderQty],
		[PM].[MReceivedQty],
		[PM].[MPrice],
		[PM].[MForeignPrice],
		[PM].[NComment],
		[PH].[Supplier],
		
		[PM].[MPrice] * [PM].[MReceivedQty] AS [PriceRec],
		
		[AS].[SupplierName],
		[AS].[SupShortName]
	FROM
		[SysproCompanyA].[dbo].[PorMasterDetail] [PM]
	LEFT JOIN
		[SysproCompanyA].[dbo].[PorMasterHdr] [PH]
	ON
		[PM].[PurchaseOrder] = [PH].[PurchaseOrder]
	LEFT JOIN
		[SysproCompanyA].[dbo].[PorHistReceipt] [HR]
	ON
		([PM].[PurchaseOrder] = [HR].[PurchaseOrder])
	LEFT JOIN
		[SysproCompanyA].[dbo].[ApSupplier] [AS]
	ON
		[PH].[Supplier] = [AS].[Supplier]
	WHERE
		([PM].[MLatestDueDate] = '{date_in:%Y-%m-%d}')
		OR ([PM].[MOrigDueDate] = '{date_in:%Y-%m-%d}')
		OR ([PH].[OrderEntryDate] = '{date_in:%Y-%m-%d}')
		OR ([PH].[OrderDueDate] = '{date_in:%Y-%m-%d}')
		OR ([PH].[MemoDate] = '{date_in:%Y-%m-%d}')
		OR ([PM].[MLatestDueDate] = '{date_in:%Y-%m-%d}')
		OR ([HR].[DateReceived] = '{date_in:%Y-%m-%d}')
	;
		"""
		return connect(sql)


	k_now: str = "key_now"
	k_today: str = "key_today"
	k_yesterday: str = "key_yesterday"
	k_tomorrow: str = "key_tomorrow"
	now_real: datetime.datetime = datetime.datetime.now()
	today_real: datetime.date = now_real.date()
	yesterday_real: datetime.date = today_real + datetime.timedelta(days=-1)
	tomorrow_real: datetime.date = today_real + datetime.timedelta(days=1)

	now: datetime.datetime = st.session_state.get(k_now, now_real)
	today: datetime.datetime = st.session_state.get(k_today, today_real)
	yesterday: datetime.datetime = st.session_state.get(k_yesterday, yesterday_real)
	tomorrow: datetime.datetime = st.session_state.get(k_tomorrow, tomorrow_real)

	# df_posted_today: pd.DataFrame = load_posted(today)
	# df_posted_yesterday: pd.DataFrame = load_posted(yesterday)

	df_date_data = {}
	list_dates = [today, yesterday]

	for d in list_dates:
		df_posted = load_posted(d)
		df_date_data[d] = {}
		df_date_data[d]["df_posted"] = df_posted
		df_date_data[d]["df_jobs_posted"] = df_posted.groupby(
			by=["Job", "TrnDateTime"]
		).agg({
			"Line": "count",
			"MQtyIssued": "sum",
			"MUnitCost": "sum"
		}).rename(
			columns={
				"Line": "CountOfPosts",
				"MQtyIssued": "TotalQtyIss",
				"MUnitCost": "TotalCostIss"
			}
		).reset_index()
		df_date_data[d]["df_stockcodes_posted"] = df_posted.loc[
			(~pd.isna(df_posted["MStockCode"]))
			& (df_posted["MStockCode"].str.strip() != "")
		].groupby(
			by=["MStockCode", "TrnDateTime"]
		).agg({
			"Line": "count",
			"MQtyIssued": "sum",
			"MUnitCost": "sum"
		}).rename(
			columns={
				"Line": "CountOfPosts",
				"MQtyIssued": "TotalQtyIss",
				"MUnitCost": "TotalCostIss"
			}
		).reset_index()
		df_date_data[d]["df_orders"] = load_order_data(d)
		df_date_data[d]["df_sales_orders"] = load_sales_order_data(d)
		df_date_data[d]["df_purchase_orders"] = load_purchase_order_data(d)

		date_cols = [
			"Order Date",
			"Quote Date",
			"OrderDate",
			"InvoiceDate",
			"OrderEntryDate",
			"TrnDate",
			"TrnDateTime",
			"MLatestDueDate",
			"DateReceived"
		]

		for k, df in df_date_data[d].items():
			for col in date_cols:
				if col in df.columns:
					df[col] = pd.to_datetime(df[col], errors="coerce")

	cont_header = st.container(border=True)
	cols_header = cont_header.columns([0.25, 0.5, 0.25])
	if today == today_real:
		cols_header[1].markdown("# " + f"Today's Metrics")
	else:
		cols_header[1].markdown("# " + f"Metrics For")
	print(f"{date_str_format(today, include_weekday=True)=}")
	cols_header[1].markdown("#### " + date_str_format(today, include_weekday=True))
	with cols_header[0]:
		if st.button(
			label=f"<- {yesterday:%Y-%m-%d}"
		):
			st.session_state.update({
				k_now: now + datetime.timedelta(days=-1),
				k_today: today + datetime.timedelta(days=-1),
				k_yesterday: yesterday + datetime.timedelta(days=-1),
				k_tomorrow: tomorrow + datetime.timedelta(days=-1)
			})
			st.rerun()
	with cols_header[2]:
		if st.button(
			label=f"{tomorrow:%Y-%m-%d} ->"
		):
			st.session_state.update({
				k_now: now + datetime.timedelta(days=1),
				k_today: today + datetime.timedelta(days=1),
				k_yesterday: yesterday + datetime.timedelta(days=1),
				k_tomorrow: tomorrow + datetime.timedelta(days=1)
			})
			st.rerun()

		if today != today_real:
			if st.button(
				label=f"Go To Today"
			):
				st.session_state.update({
					k_now: now_real,
					k_today: today_real,
					k_yesterday: yesterday_real,
					k_tomorrow: tomorrow_real
				})
				st.rerun()


	# n_cols = 4
	# n_rows = 2
	cont_body = st.container(border=True)
	cols_body_0 = [cont_body.columns(4) for i in range(3)]

	st.divider()

	##########
	# Mat Cost
	##########

	df_iss_stock_today: pd.DataFrame = df_date_data[today]["df_stockcodes_posted"]
	df_iss_stock_today = df_iss_stock_today.loc[df_iss_stock_today["TrnDateTime"].dt.date == today]
	ttl_issued_stock_today_v = df_iss_stock_today["TotalCostIss"].sum()
	df_iss_stock_yesterday: pd.DataFrame = df_date_data[yesterday]["df_stockcodes_posted"]
	df_iss_stock_yesterday = df_iss_stock_yesterday.loc[df_iss_stock_yesterday["TrnDateTime"].dt.date == yesterday]
	ttl_issued_stock_yesterday_v = df_iss_stock_yesterday["TotalCostIss"].sum()
	ttl_issued_stock_diff_v = ttl_issued_stock_today_v - ttl_issued_stock_yesterday_v
	with cols_body_0[0][0]:
		with st.container(border=True):
			st.metric(
				label="Total Issued in Material Costs",
				# value=money(df_stockcodes_posted["TotalCostIss"].sum())
				value=money(ttl_issued_stock_today_v),
				delta=money(ttl_issued_stock_diff_v) + f" (yesterday={money(ttl_issued_stock_yesterday_v)})",
				delta_color="normal" if ttl_issued_stock_diff_v < 0 else "inverse"
			)
			with st.popover(
					label="view"
			):
				st.write(df_iss_stock_today["MStockCode"].unique().tolist())

	###########
	# Lab Hours
	###########

	df_lab_today: pd.DataFrame = df_date_data[today]["df_posted"]
	df_lab_today = df_lab_today.loc[
		((df_lab_today["TrnType"] == "L")
		& (df_lab_today["TrnDateTime"].dt.date == today))
	]
	ttl_issued_lab_today_v = df_lab_today["LRunTimeHours"].sum()
	ttl_issued_lab_today_f = f'{ttl_issued_lab_today_v:.3f} Hrs'
	df_lab_yesterday: pd.DataFrame = df_date_data[yesterday]["df_posted"]
	df_lab_yesterday = df_lab_yesterday.loc[
		((df_lab_yesterday["TrnType"] == "L")
		& (df_lab_yesterday["TrnDateTime"].dt.date == yesterday))
	]
	ttl_issued_lab_yesterday_v = df_lab_yesterday["LRunTimeHours"].sum()
	ttl_issued_lab_yesterday_f = hour_fmt(ttl_issued_lab_yesterday_v)
	ttl_issued_lab_diff_v = ttl_issued_lab_today_v - ttl_issued_lab_yesterday_v
	ttl_issued_lab_diff_f = hour_fmt(ttl_issued_lab_diff_v) + f" (yesterday={hour_fmt(ttl_issued_lab_yesterday_v)})"
	with cols_body_0[0][1]:
		with st.container(border=True):
			st.metric(
				label="Total Issued in Labour Hours",
				value=ttl_issued_lab_today_f,
				delta=ttl_issued_lab_diff_f,
				delta_color="normal" if ttl_issued_lab_today_v < ttl_issued_lab_yesterday_v else "inverse"
			)
			with st.popover(
					label="view"
			):
				st.write(df_lab_today["Job"].unique().tolist())

	############
	# New Quotes
	############

	df_quotes_today: pd.DataFrame = df_date_data[today]["df_orders"]
	df_quotes_today = df_quotes_today.loc[df_quotes_today["Quote Date"].dt.date == today]
	ttl_new_quotes_today_v = df_quotes_today["Quote#"].count()
	df_quotes_yesterday: pd.DataFrame = df_date_data[yesterday]["df_orders"]
	ttl_new_quotes_yesterday_v = df_quotes_yesterday.loc[
		df_quotes_yesterday["Quote Date"].dt.date == yesterday,
		"Quote#"
	].count()
	ttl_new_quotes_diff_v = ttl_new_quotes_today_v - ttl_new_quotes_yesterday_v
	with cols_body_0[0][2]:
		with st.container(border=True):
			st.metric(
				label="Number of New Quotes",
				# value=money(df_stockcodes_posted["TotalCostIss"].sum())
				value=ttl_new_quotes_today_v,
				delta=f"{ttl_new_quotes_diff_v} (yesterday={ttl_new_quotes_yesterday_v})",
				delta_color="normal" if ttl_new_quotes_diff_v < 0 else "inverse"
			)
			with st.popover(
				label="view"
			):
				st.write(df_quotes_today["Quote#"].values.tolist())

	############
	# New Orders
	############

	df_new_orders_today: pd.DataFrame = df_date_data[today]["df_orders"]
	df_new_orders_today = df_new_orders_today.loc[
		((df_new_orders_today["Order Date"].dt.date == today)
		& (df_new_orders_today["Decline/Rejected"] == 4))
	]
	ttl_new_orders_today_v = df_new_orders_today["Quote#"].count()
	df_new_orders_yesterday: pd.DataFrame = df_date_data[yesterday]["df_orders"]
	df_new_orders_yesterday = df_new_orders_yesterday.loc[
		((df_new_orders_yesterday["Order Date"].dt.date == yesterday)
		& (df_new_orders_yesterday["Decline/Rejected"] == 4))
	]
	ttl_new_orders_yesterday_v = df_new_orders_yesterday["Quote#"].count()
	ttl_new_orders_diff_v = ttl_new_orders_today_v - ttl_new_orders_yesterday_v
	with cols_body_0[0][3]:
		with st.container(border=True):
			st.metric(
				label="Number of New Orders",
				# value=money(df_stockcodes_posted["TotalCostIss"].sum())
				value=ttl_new_orders_today_v,
				delta=f"{ttl_new_orders_diff_v} (yesterday={ttl_new_orders_yesterday_v})",
				delta_color="normal" if ttl_new_orders_diff_v < 0 else "inverse"
			)
			with st.popover(
				label="view"
			):
				st.write(df_new_orders_today["Quote#"].values.tolist())

	##################
	# New Sales Orders
	##################

	df_sos_today: pd.DataFrame = df_date_data[today]["df_sales_orders"]
	df_sos_today: pd.DataFrame = df_sos_today.loc[
		~pd.isna(df_sos_today["OrderDate"])
	].groupby(
		by=["SalesOrder", "OrderDate"]
	).agg({"MStockCode": "count"}).rename(
		columns={"MStockCode": "CountOfNewSalesOrders"}
	).reset_index()
	df_sos_today = df_sos_today.loc[
		(df_sos_today["OrderDate"].dt.date == today)
	]
	ttl_new_sos_today_v = df_sos_today["SalesOrder"].count()
	df_sos_yesterday: pd.DataFrame = df_date_data[yesterday]["df_sales_orders"]
	df_sos_yesterday: pd.DataFrame = df_sos_yesterday.loc[
		~pd.isna(df_sos_yesterday["OrderDate"])
	].groupby(
		by=["SalesOrder", "OrderDate"]
	).agg({"MStockCode": "count"}).rename(
		columns={"MStockCode": "CountOfNewSalesOrders"}
	).reset_index()
	df_sos_yesterday = df_sos_yesterday.loc[
		(pd.to_datetime(df_sos_yesterday["OrderDate"]).dt.date == yesterday)
	]
	ttl_new_sos_yesterday_v = df_sos_yesterday["SalesOrder"].count()
	ttl_new_sos_diff_v = ttl_new_sos_today_v - ttl_new_sos_yesterday_v
	with cols_body_0[1][0]:
		with st.container(border=True):
			st.metric(
				label="Number of New Sales Orders",
				value=ttl_new_sos_today_v,
				delta=f"{ttl_new_sos_diff_v} (yesterday={ttl_new_sos_yesterday_v})",
				delta_color="normal" if ttl_new_sos_diff_v < 0 else "inverse"
			)
			with st.popover(
				label="view"
			):
				st.write(df_sos_today["SalesOrder"].unique().tolist())

	####################
	# New Sales Invoices
	####################

	df_sos_inv_today: pd.DataFrame = df_date_data[today]["df_sales_orders"].groupby(
		by=["SalesOrder", "InvoiceDate"]
	).agg({"MStockCode": "count"}).rename(
		columns={"MStockCode": "CountOfNewSalesInvoices"}
	).reset_index()
	ttl_new_sos_inv_today_v = df_sos_inv_today.loc[
		(df_sos_inv_today["InvoiceDate"].dt.date == today),
		"SalesOrder"
	].count()
	df_sos_inv_yesterday: pd.DataFrame = df_date_data[yesterday]["df_sales_orders"].groupby(
		by=["SalesOrder", "InvoiceDate"]
	).agg({"MStockCode": "count"}).rename(
		columns={"MStockCode": "CountOfNewSalesInvoices"}
	).reset_index()
	ttl_new_sos_inv_yesterday_v = df_sos_inv_yesterday.loc[
		(df_sos_inv_yesterday["InvoiceDate"].dt.date == yesterday),
		"SalesOrder"
	].count()
	ttl_new_sos_inv_diff_v = ttl_new_sos_inv_today_v - ttl_new_sos_inv_yesterday_v
	with cols_body_0[1][1]:
		with st.container(border=True):
			st.metric(
				label="Number of Sales Order Invoices",
				value=ttl_new_sos_inv_today_v,
				delta=f"{ttl_new_sos_inv_diff_v} (yesterday={ttl_new_sos_inv_yesterday_v})",
				delta_color="normal" if ttl_new_sos_inv_diff_v < 0 else "inverse"
			)
			with st.popover(
				label="view"
			):
				st.write(df_sos_inv_today["SalesOrder"].unique().tolist())

	#################
	# Purchase Orders
	#################

	df_pos_today: pd.DataFrame = df_date_data[today]["df_purchase_orders"].groupby(
		by=["PurchaseOrder", "OrderEntryDate"]
	).agg({"MStockCode": "count"}).rename(
		columns={"MStockCode": "CountOfNewPurchaseOrders"}
	).reset_index()
	df_pos_today = df_pos_today.loc[(df_pos_today["OrderEntryDate"].dt.date == today)]
	ttl_new_pos_today_v = df_pos_today["PurchaseOrder"].count()
	df_pos_yesterday: pd.DataFrame = df_date_data[yesterday]["df_purchase_orders"].groupby(
		by=["PurchaseOrder", "OrderEntryDate"]
	).agg({"MStockCode": "count"}).rename(
		columns={"MStockCode": "CountOfNewPurchaseOrders"}
	).reset_index()
	df_pos_yesterday = df_pos_yesterday.loc[
		(df_pos_yesterday["OrderEntryDate"].dt.date == yesterday)
	]
	ttl_new_pos_yesterday_v = df_pos_yesterday["PurchaseOrder"].count()
	ttl_new_pos_diff_v = ttl_new_pos_today_v - ttl_new_pos_yesterday_v
	with cols_body_0[1][2]:
		with st.container(border=True):
			st.metric(
				label="Number of New Purchase Orders",
				value=ttl_new_pos_today_v,
				delta=f"{ttl_new_pos_diff_v} (yesterday={ttl_new_pos_yesterday_v})",
				delta_color="normal" if ttl_new_pos_diff_v < 0 else "inverse"
			)
			with st.popover(
				label="view"
			):
				st.write(df_pos_today["PurchaseOrder"].values.tolist())

	##########################
	# Purchase Orders Received
	##########################

	df_pos_rec_today: pd.DataFrame = df_date_data[today]["df_purchase_orders"].groupby(
		by=["PurchaseOrder", "DateReceived"]
	).agg({
		"MStockCode": "count",
		"PriceRec": "sum"
	}).rename(
		columns={
			"MStockCode": "CountOfNewPurchaseOrdersReceived",
			"PriceRec": "SumOfPriceRec"
		}
	).reset_index()
	df_pos_rec_today = df_pos_rec_today.loc[(df_pos_rec_today["DateReceived"].dt.date == today)]
	# df_pos_rec_today = df_pos_rec_today.loc[(df_pos_rec_today["DateReceived"].dt.date == today)].groupby(
	# 	by=["PurchaseOrder", "DateReceived"]
	# ).agg({
	# 	"DateReceived": "count"
	# }).rename(
	# 	columns={
	# 		"DateReceived": "CountPOsReceived"
	# 	}
	# )

	display_df(
		df_pos_rec_today,
		"df_pos_rec_today"
	)

	ttl_new_pos_rec_today_v = df_pos_rec_today["PurchaseOrder"].count()
	ttl_price_pos_rec_today_v = df_pos_rec_today["SumOfPriceRec"].sum()
	df_pos_rec_yesterday: pd.DataFrame = df_date_data[yesterday]["df_purchase_orders"].groupby(
		by=["PurchaseOrder", "DateReceived"]
	).agg({
		"MStockCode": "count",
		"PriceRec": "sum"
	}).rename(
		columns={
			"MStockCode": "CountOfNewPurchaseOrders",
			"PriceRec": "SumOfPriceRec"
		}
	).reset_index()
	df_pos_rec_yesterday = df_pos_rec_yesterday.loc[
		(df_pos_rec_yesterday["DateReceived"].dt.date == yesterday)
	]
	ttl_new_pos_rec_yesterday_v = df_pos_rec_yesterday["PurchaseOrder"].count()
	ttl_price_pos_rec_yesterday_v = df_pos_rec_yesterday["SumOfPriceRec"].sum()
	ttl_new_pos_rec_diff_v = ttl_new_pos_rec_today_v - ttl_new_pos_rec_yesterday_v
	ttl_price_pos_rec_diff_v = ttl_price_pos_rec_today_v - ttl_price_pos_rec_yesterday_v
	with cols_body_0[1][3]:
		with st.container(border=True):
			st.metric(
				label="Number of Purchase Orders Received",
				value=ttl_new_pos_rec_today_v,
				delta=f"{ttl_new_pos_rec_diff_v} (yesterday={ttl_new_pos_rec_yesterday_v})",
				delta_color="normal" if ttl_new_pos_rec_diff_v < 0 else "inverse"
			)
			with st.popover(
				label="view"
			):
				st.write(df_pos_rec_today["PurchaseOrder"].unique().tolist())
	with cols_body_0[2][0]:
		with st.container(border=True):
			st.metric(
				label="Total Received in Purchase Orders",
				value=money(ttl_price_pos_rec_today_v),
				delta=f"{money(ttl_price_pos_rec_diff_v)} (yesterday={money(ttl_price_pos_rec_yesterday_v)})",
				delta_color="inverse" if ttl_price_pos_rec_diff_v < 0 else "normal"
			)
			with st.popover(
				label="view"
			):
				st.write(df_pos_rec_today["PurchaseOrder"].unique().tolist())

	st.divider()

	###########
	# New Ideas
	###########

	st.markdown("### :red[Have an idea for another metric or a better method for presenting (ex: graphs)?]")
	with st.expander("##### Expand and leave a comment, and we will follow up with you about your idea."):
		with st.form(
			key="form_new_metric",
			clear_on_submit=True,
			enter_to_submit=False
		):
			k_textbox_name = "key_textbox_name"
			textbox_name = st.text_input(
				key=k_textbox_name,
				label="Name:"
			)
			k_textarea_idea = "key_textarea_idea"
			textarea_idea = st.text_area(
				key=k_textarea_idea,
				label="Describe your idea:",
				height=400
			)
			submitted = st.form_submit_button(
				"Submit"
			)
			if submitted:
				record = [{
					"date": jsonify(now),
					"name": textbox_name.strip(),
					"idea": textarea_idea.strip()
				}]
				if not os.path.exists(new_idea_file):
					with open(new_idea_file, "w") as f:
						json.dump([], f)

				with open(new_idea_file, "r") as f:
					orig_data = eval(str(json.load(f)))

				orig_data.extend(record)

				with open(new_idea_file, "w") as f:
					json.dump(orig_data, f)

				st.toast("Thank you for your idea!")
				# st.rerun()

	st.divider()

	######
	# Data
	######

	st.subheader("Data")

	df_cols = st.columns(len(df_date_data))

	for i, d in enumerate(list_dates[::-1]):
		with df_cols[i]:
			st.subheader(d)
		for k, df in df_date_data[d].items():
			with df_cols[i]:
				with st.container(border=True):
					display_df(df, k)


else:

	DEFAULT_MIN_DATE = datetime.datetime.now().date() + datetime.timedelta(days=-int(365*2.5))
	DEFAULT_MAX_DATE = datetime.datetime.now().date() + datetime.timedelta(days=10)

	def date_cap(
			df: pd.DataFrame,
			starting: Optional[datetime.datetime] = None,
			ending: Optional[datetime.datetime] = None
	) -> pd.DataFrame:

		df, df_col_key = norm_columns(df, date_position="start")
		date_cols = [col for col in df.columns if col.startswith("Date")]
		dfs = []

		if starting is not None and ending is not None:
			# window
			for col in date_cols:
				dfs.append(df[(starting <= df[col]) & (df[col] <= ending)])
		elif starting is not None:
			# since
			for col in date_cols:
				dfs.append(df[starting <= df[col]])
		elif ending is not None:
			# up-to
			for col in date_cols:
				dfs.append(df[df[col] <= ending])
		else:
			return df

		df = pd.concat(dfs)
		df.drop_duplicates(inplace=True)

		return df
	# New

	@st.cache_data(show_spinner=True, ttl=QUERY_HOLD_TIME)
	def query(sql: str) -> pd.DataFrame:
		print(f"Begin Querying...")
		now0 = datetime.datetime.now()
		df = connect(sql)
		now1 = datetime.datetime.now()
		print(f"End Querying {(now1 - now0).total_seconds()} seconds.")
		return df


	# @st.cache_data(show_spinner=True, ttl=QUERY_HOLD_TIME)
	def load_order_data(starting: Optional[datetime.datetime] = None,
						ending: Optional[datetime.datetime] = None) -> pd.DataFrame:
		sql = """
SELECT
	[O].[Quote Date]
	,[O].[Order Date]
	,[O].[Date Registered]
	,[O].[Date Declined]
	,[O].[Decline/Rejected]
	,[O].[Date In Service]
	,[O].[Invoice Date]

	,[O].[Quote#]
	,[O].[WO#]
	,[O].[Serial Number]
	,[O].[ProductID]
	,[O].[Model No]
	,[O].[US Sale]
	,[O].[Price]

	,ISNULL([P].[Prod Date], [P].[Prod Date2]) AS [ProdDate]
	,ISNULL([P].[Prod Line], [P].[Prod Line2]) AS [ProdLine]
	
	,[C].[Customer]
	,[D].[COMPANY NAME]
FROM
	[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
LEFT JOIN
	[BWSdb].[dbo].[Production] [P] WITH (NOLOCK)
ON
	[O].[Quote#] = [P].[Quote#]
LEFT JOIN
	[BWSdb].[dbo].[Customers] [C] WITH (NOLOCK)
ON
	[O].[CustID] = [C].[ID#]
LEFT JOIN
	[BWSdb].[dbo].[Dealers] [D] WITH (NOLOCK)
ON
	[O].[DealerID] = [D].[ID]
;
"""
		df: pd.DataFrame = query(sql)
		df = date_cap(df, starting, ending)
		return df


	# @st.cache_data(show_spinner=True, ttl=QUERY_HOLD_TIME)
	def load_posted(starting: Optional[datetime.datetime] = None,
						ending: Optional[datetime.datetime] = None) -> pd.DataFrame:
		sql = f"""
SELECT
	[JPD].[TrnDateTime],
	[JP].[TrnType],
	[JP].[MStockCode],
	[JP].[MReference],
	[JP].[MQtyIssued],
	[JP].[MUom],
	[JP].[MWarehouse],
	[JP].[MProductClass],
	[JP].[MUnitCost],
	[JP].[LEmployee],
	[JP].[LWorkCentre],
	[JP].[LWorkCentreDesc],
	[JP].[LRunTimeHours],
	[JP].[LOperation],
	[JP].[LMachine]
FROM
	[SysproCompanyA].[dbo].[WipJobPost] [JP] WITH (NOLOCK)
INNER JOIN
	[SysproCompanyA].[dbo].[v_PROD_WipJobPostDateTime] [JPD] WITH (NOLOCK)
ON
	([JP].[Job] = [JPD].[Job])
	AND ([JP].[Line] = [JPD].[Line])
WHERE
	('{DEFAULT_MIN_DATE:%Y-%m-%d}' <= [JPD].[TrnDateTime])
	AND ([JPD].[TrnDateTime] <= '{DEFAULT_MAX_DATE:%Y-%m-%d}')
;
"""
		df: pd.DataFrame = query(sql)
		df = date_cap(df, starting, ending)
		return df


	def load_sales_order_data(starting: Optional[datetime.datetime] = None,
						ending: Optional[datetime.datetime] = None) -> pd.DataFrame:
		sql = f"""
SELECT
	[SM].[SalesOrder],
	[AR].[InvoiceDate],
	[SM].[OrderDate],
	[SM].[DateLastDocPrt],
	[SM].[DateLastInvPrt],
	[SM].[EntrySystemDate],
	[SM].[ReqShipDate],
	[SM].[OrderStatus],
	[SM].[Salesperson],
	[SM].[CustomerName],
	[SM].[Email],
	[SM].[ShippingInstrs],
	[SM].[ShipAddress1],
	[SM].[ShipAddress2],
	[SM].[ShipAddress3],
	[SM].[ShipAddress4],
	[SM].[ShipAddress5],
	[SM].[InvoiceCount],
	[SM].[LastInvoice],
	[SM].[Area],
	[SM].[ExchangeRate],
	[SM].[LastOperator],

	[SD].[SalesOrderLine],
	[SD].[LineType],
	[SD].[MProductClass],
	[IM].[PartCategory],
	[IM].[Supplier],
	[AS].[SupplierName],
	[AS].[SupShortName],
	[SD].[MStockCode],
	[IM].[Description],
	[IM].[LongDesc],
	[IM].[WarehouseToUse],
	[SD].[MWarehouse],
	[SD].[MBin],
	[IW].[DefaultBin],
	[SD].[MOrderQty],
	[SD].[MShipQty],
	[SD].[MBackOrderQty],
	[SD].[MUnitCost],
	[SD].[MOrderUom],
	[SD].[MPrice],
	[SD].[MDiscPct1],
	[SD].[MDiscPct2],
	[SD].[MDiscPct3],
	[SD].[MLineShipDate],
	[SD].[NComment],
	[AR].[Customer],
	[AR].[Invoice],
	[AS].[LastPurchDate],

	[IW].[QtyOnHand],
	[IW].[QtyOnOrder],
	[IW].[QtyOnBackOrder],
	[IW].[QtyAllocated],
	[IW].[QtyAllocatedToPick],
	[IW].[QtyAllocatedWip],
	[IW].[DateLastSale],
	[IW].[DateLastStockMove],
	[IW].[DateLastPurchase]
FROM
	[SysproCompanyA].[dbo].[SorMaster] [SM] WITH (NOLOCK)
LEFT JOIN
	[SysproCompanyA].[dbo].[SorDetail] [SD] WITH (NOLOCK)
ON
	[SM].[SalesOrder] = [SD].[SalesOrder]
LEFT JOIN
	[SysproCompanyA].[dbo].[InvMaster] [IM] WITH (NOLOCK)
ON
	[SD].[MStockCode] = [IM].[StockCode]
LEFT JOIN
	[SysproCompanyA].[dbo].[ArInvoice] [AR]
ON
	[SM].[LastInvoice] = [AR].[Invoice]
LEFT JOIN
	[SysproCompanyA].[dbo].[ApSupplier] [AS] WITH (NOLOCK)
ON
	[IM].[Supplier] = [AS].[Supplier]
LEFT OUTER JOIN
	[SysproCompanyA].[dbo].[InvWarehouse] [IW] WITH (NOLOCK)
ON
	[IM].[StockCode] = [IW].[StockCode]
	AND [SD].[MWarehouse] = [IW].[Warehouse]
;
"""
		df: pd.DataFrame = query(sql)
		df = date_cap(df, starting, ending)
		return df


	df_orders: pd.DataFrame = load_order_data()
	df_posted: pd.DataFrame = load_posted()
	df_sor: pd.DataFrame = load_sales_order_data()

	st.write("DEFAULT_MIN_DATE")
	st.write(DEFAULT_MIN_DATE)
	st.write("DEFAULT_MAX_DATE")
	st.write(DEFAULT_MAX_DATE)

	display_df(
		df_orders,
		"df_orders"
	)
	display_df(
		df_posted,
		"df_posted"
	)
	display_df(
		df_sor,
		"df_sor"
	)