from streamlit_utility import st, pd, display_df, display_df_paginated, get_selected_rows

import streamlit_auth_sql as auth
from pyodbc_connection import connect

import datetime
import numpy as np
from typing import Optional

from streamlit_pills import pills
import plotly.express as px


@st.cache_data(ttl=60*60, show_spinner=True, show_time=True)
def load_quotes() -> pd.DataFrame:
	sql = """
SELECT
	'BWS' AS [Comp],
	CAST([O].[Quote#] AS NVARCHAR(250)) AS [Quote],
	[O].[WO#] AS [WO],
	[O].[Serial Number] AS [SerialNumber],
	[O].[Decline/Rejected] AS [DeclineRejected],
	[O].[Quote Date] AS [QuoteDate]
FROM
	[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
UNION ALL(
	SELECT
		'STG' AS [Comp],
		CAST([O2].[SGQuote] AS NVARCHAR(250)),
		[O2].[WO#],
		[O2].[Serial Number],
		[O2].[Decline/Rejected],
		[O2].[Quote Date]
	FROM
		[BWSdb].[dbo].[OrdersV2] [O2] WITH (NOLOCK)
)
;
	"""
	df: pd.DataFrame = connect(sql)
	df["WO"] = df["WO"].apply(lambda wo: str(wo).removesuffix(".0") if not pd.isna(wo) else None)
	df["QuoteDate"] = pd.to_datetime(df["QuoteDate"], errors="ignore").dt.date
	return df


@st.cache_data(ttl=60*60, show_spinner=True, show_time=True)
def load_order_data(**kwargs) -> pd.DataFrame:
	k, v = list(kwargs.items())[0]
	k = f"[{k}]"
	# if (not str(v).isnumeric()) or (k.lower().replace(" ", "").removeprefix("[").removesuffix("]").strip() in ["serialnumber"]):
	v = f"'{v}'"
	k_sg = k
	v_sg = v
	if k.lower().replace(" ", "").replace("#", "").removeprefix("[").removesuffix("]").strip() == "quote":
		k_sg = "[SGQuote]"
	st.write(f"{k=}, {v=}, {k_sg=}, {v_sg=}")
	sql = f"""
SELECT
	'BWS' AS [O_Company]
	,CAST([O].[Quote#] AS NVARCHAR(255)) AS [O_Quote]
	,[O].[Quote Date] AS [O_QuoteDate]
	,[O].[Order Date] AS [O_OrderDate]
	,[O].[WO#] AS [O_WO]
	,[O].[Sales Order#] AS [O_SalesOrder]
	,[O].[Model No] AS [O_ModelNo]
	,[O].[Width] AS [O_Width]
	,[O].[Spread] AS [O_Spread]
	,[O].[DealerID] AS [O_DealerID]
	,[O].[Sale PersonID] AS [O_SalePersonID]
	,[O].[Price] AS [O_Price]
	,[O].[Prom Drawing] AS [O_PromDrawing]
	,[O].[Special Instructions] AS [O_SpecialInstructions]
	,[O].[Date Declined] AS [O_DateDeclined]
	,[O].[Decline/Rejected] AS [O_DeclineRejected]
	,[O].[Serial Number] AS [O_SerialNumber]
	,[O].[Available Date] AS [O_AvailableDate]
	,[O].[Delivery Date] AS [O_DeliveryDate]
	,[O].[Requested Delivery Date] AS [O_RequestedDeliveryDate]
	,[O].[Finish Date] AS [O_FinishDate]
	,[O].[Purchase Order] AS [O_PurchaseOrder]
	,[O].[PO Date] AS [O_PODate]
	,[O].[PayID] AS [O_PayID]
	,[O].[Volume Discount] AS [O_VolumeDiscount]
	,[O].[Program Discount] AS [O_ProgramDiscount]
	,[O].[Discount1_Name] AS [O_Discount1_Name]
	,[O].[Discount1_Type] AS [O_Discount1_Type]
	,[O].[Discount1] AS [O_Discount1]
	,[O].[Discount2_Name] AS [O_Discount2_Name]
	,[O].[Discount2_Type] AS [O_Discount2_Type]
	,[O].[Discount2] AS [O_Discount2]
	,[O].[Discount3_Name] AS [O_Discount3_Name]
	,[O].[Discount3_Type] AS [O_Discount3_Type]
	,[O].[Discount3] AS [O_Discount3]
	,[O].[Est Pro Date] AS [O_EstProDate]
	,[O].[Notes] AS [O_Notes]
	,[O].[EngNotes] AS [O_EngNotes]
	,[O].[CarrierID] AS [O_CarrierID]
	,[O].[CustID] AS [O_CustID]
	,[O].[US Sale] AS [O_USSale]
	,[O].[Shipped Date] AS [O_ShippedDate]
	,[O].[GL Override Date] AS [O_GLOverrideDate]
	,[O].[FE Rate] AS [O_FERate]
	,[O].[PDD] AS [O_PDD]
	,[O].[Deck Length] AS [O_DeckLength]
	,[O].[Invoice #] AS [O_Invoice]
	,[O].[Date Registered] AS [O_DateRegistered]
	,[O].[Date In Service] AS [O_DateInService]
	,[O].[Invoice Date] AS [O_InvoiceDate]
	,[O].[Date Requested] AS [O_DateRequested]
	,[O].[GVWR] AS [O_GVWR]
	,[O].[Tare] AS [O_Tare]
	,[O].[Selection] AS [O_Selection]
	,[O].[Warranty] AS [O_Warranty]
	,[O].[BWSPaid] AS [O_BWSPaid]
	,[O].[BWSPaidDate] AS [O_BWSPaidDate]
	,[O].[CommPaid] AS [O_CommPaid]
	,[O].[CommPaidDate] AS [O_CommPaidDate]
	,[O].[ts_timestamp] AS [O_ts_timestamp]
	,[O].[ModifiedBy] AS [O_ModifiedBy]
	,[O].[Lead Date] AS [O_LeadDate]
	,[O].[Lead Source] AS [O_LeadSource]
	,[O].[LeadID] AS [O_LeadID]
	,[O].[DealerBranchID] AS [O_DealerBranchID]
	,[O].[DealerSalesPersonID] AS [O_DealerSalesPersonID]
	,[O].[DataEntryCheck] AS [O_DataEntryCheck]
	,[O].[DataEntryUser] AS [O_DataEntryUser]
	,[O].[FinishedGoodsDealerLocID] AS [O_FinishedGoodsDealerLocID]
	,[O].[WO Reviewed] AS [O_WOReviewed]
	,[O].[WO Review Date] AS [O_WOReviewDate]
	,[O].[Follow Up Date] AS [O_FollowUpDate]
	,[O].[MSOIsDifferent] AS [O_MSOIsDifferent]
	,[O].[MSOLocID] AS [O_MSOLocID]
	,[O].[EstInvDateOverride] AS [O_EstInvDateOverride]
	,[O].[Estimated Invoice Date] AS [O_EstimatedInvoiceDate]
	,[O].[AdditionalPricingInfo] AS [O_AdditionalPricingInfo]
	,[O].[Slot#] AS [O_Slot]
	,[O].[TempModel?] AS [O_TempModel]
	,[O].[HighRiskUnit] AS [O_HighRiskUnit]
	,[O].[EngNotes V2] AS [O_EngNotesV2]
	,[O].[CompanyID] AS [O_CompanyID]
	,[O].[Customer WO#] AS [O_CustomerWO]
	,[O].[Step 2 Slot#] AS [O_Step2Slot]
	,[O].[PriceSecured] AS [O_PriceSecured]
	,[O].[DateSecured] AS [O_DateSecured]
	,[O].[SecuredBy] AS [O_SecuredBy]
	,[O].[InternalSalesComment] AS [O_InternalSalesComment]
	,[O].[InternalSalesCommentDate] AS [O_InternalSalesCommentDate]
	,[O].[InternalSalesCommenter] AS [O_InternalSalesCommenter]
	,[O].[DiscountID] AS [O_DiscountID]
	,[O].[DiscountSetDate] AS [O_DiscountSetDate]
	,[O].[DiscountSetBy] AS [O_DiscountSetBy]
	,[O].[ProductID] AS [O_ProductID]
	,[O].[DateLastQuoteReport] AS [O_DateLastQuoteReport]
	,[O].[JobAvailableLine] AS [O_JobAvailableLine]
	,[O].[JobAvailableScheduled] AS [O_JobAvailableScheduled]
	,[O].[JobAvailableScheduledBy] AS [O_JobAvailableScheduledBy]
	,[O].[LCT_PayID] AS [O_LCT_PayID]
	,[O].[LCT_CustomerID] AS [O_LCT_CustomerID]
	,[O].[Notes_French] AS [O_Notes_French]
	,[O].[PTL_PrimaryTaxID] AS [O_PTL_PrimaryTaxID]
	,[O].[PTL_SecondaryTaxID] AS [O_PTL_SecondaryTaxID]
	,[O].[OriginalDeliveryDate] AS [O_OriginalDeliveryDate]
	,[O].[QuoteAsStargate] AS [O_QuoteAsStargate]
	,[O].[PlantOfManufactureCode] AS [O_PlantOfManufactureCode]
	,[O].[AdditionalCost1_Description] AS [O_AdditionalCost1_Description]
	,[O].[AdditionalCost1_Type] AS [O_AdditionalCost1_Type]
	,[O].[AdditionalCost1_Value] AS [O_AdditionalCost1_Value]
	,[O].[AdditionalCost2_Description] AS [O_AdditionalCost2_Description]
	,[O].[AdditionalCost2_Type] AS [O_AdditionalCost2_Type]
	,[O].[AdditionalCost2_Value] AS [O_AdditionalCost2_Value]
	,[O].[AdditionalCost3_Description] AS [O_AdditionalCost3_Description]
	,[O].[AdditionalCost3_Type] AS [O_AdditionalCost3_Type]
	,[O].[AdditionalCost3_Value] AS [O_AdditionalCost3_Value]
	,[O].[AdditionalCost4_Description] AS [O_AdditionalCost4_Description]
	,[O].[AdditionalCost4_Type] AS [O_AdditionalCost4_Type]
	,[O].[AdditionalCost4_Value] AS [O_AdditionalCost4_Value]
FROM
	[BWSdb].[dbo].[Orders] AS [O] WITH (NOLOCK)
WHERE
	CAST({k} AS NVARCHAR(50)) = {v}

UNION ALL

SELECT
	'STG' AS [Company]
	,[O].[SGQuote] AS [O_Quote]
	,[O].[Quote Date] AS [O_QuoteDate]
	,[O].[Order Date] AS [O_OrderDate]
	,[O].[WO#] AS [O_WO]
	,[O].[Sales Order#] AS [O_SalesOrder]
	,[O].[Model No] AS [O_ModelNo]
	,[O].[Width] AS [O_Width]
	,[O].[Spread] AS [O_Spread]
	,[O].[DealerID] AS [O_DealerID]
	,[O].[Sale PersonID] AS [O_SalePersonID]
	,[O].[Price] AS [O_Price]
	,[O].[Prom Drawing] AS [O_PromDrawing]
	,[O].[Special Instructions] AS [O_SpecialInstructions]
	,[O].[Date Declined] AS [O_DateDeclined]
	,[O].[Decline/Rejected] AS [O_DeclineRejected]
	,[O].[Serial Number] AS [O_SerialNumber]
	,[O].[Available Date] AS [O_AvailableDate]
	,[O].[Delivery Date] AS [O_DeliveryDate]
	,[O].[Requested Delivery Date] AS [O_RequestedDeliveryDate]
	,[O].[Finish Date] AS [O_FinishDate]
	,[O].[Purchase Order] AS [O_PurchaseOrder]
	,[O].[PO Date] AS [O_PODate]
	,[O].[PayID] AS [O_PayID]
	,[O].[Volume Discount] AS [O_VolumeDiscount]
	,[O].[Program Discount] AS [O_ProgramDiscount]
	,[O].[Discount1_Name] AS [O_Discount1_Name]
	,[O].[Discount1_Type] AS [O_Discount1_Type]
	,[O].[Discount1] AS [O_Discount1]
	,[O].[Discount2_Name] AS [O_Discount2_Name]
	,[O].[Discount2_Type] AS [O_Discount2_Type]
	,[O].[Discount2] AS [O_Discount2]
	,[O].[Discount3_Name] AS [O_Discount3_Name]
	,[O].[Discount3_Type] AS [O_Discount3_Type]
	,[O].[Discount3] AS [O_Discount3]
	,[O].[Est Pro Date] AS [O_EstProDate]
	,[O].[Notes] AS [O_Notes]
	,[O].[EngNotes] AS [O_EngNotes]
	,[O].[CarrierID] AS [O_CarrierID]
	,[O].[CustID] AS [O_CustID]
	,[O].[US Sale] AS [O_USSale]
	,[O].[Shipped Date] AS [O_ShippedDate]
	,[O].[GL Override Date] AS [O_GLOverrideDate]
	,[O].[FE Rate] AS [O_FERate]
	,[O].[PDD] AS [O_PDD]
	,[O].[Deck Length] AS [O_DeckLength]
	,[O].[Invoice #] AS [O_Invoice]
	,[O].[Date Registered] AS [O_DateRegistered]
	,[O].[Date In Service] AS [O_DateInService]
	,[O].[Invoice Date] AS [O_InvoiceDate]
	,[O].[Date Requested] AS [O_DateRequested]
	,[O].[GVWR] AS [O_GVWR]
	,[O].[Tare] AS [O_Tare]
	,[O].[Selection] AS [O_Selection]
	,[O].[Warranty] AS [O_Warranty]
	,[O].[BWSPaid] AS [O_BWSPaid]
	,[O].[BWSPaidDate] AS [O_BWSPaidDate]
	,[O].[CommPaid] AS [O_CommPaid]
	,[O].[CommPaidDate] AS [O_CommPaidDate]
	,[O].[ts_timestamp] AS [O_ts_timestamp]
	,[O].[ModifiedBy] AS [O_ModifiedBy]
	,[O].[Lead Date] AS [O_LeadDate]
	,[O].[Lead Source] AS [O_LeadSource]
	,[O].[LeadID] AS [O_LeadID]
	,[O].[DealerBranchID] AS [O_DealerBranchID]
	,[O].[DealerSalesPersonID] AS [O_DealerSalesPersonID]
	,[O].[DataEntryCheck] AS [O_DataEntryCheck]
	,[O].[DataEntryUser] AS [O_DataEntryUser]
	,[O].[FinishedGoodsDealerLocID] AS [O_FinishedGoodsDealerLocID]
	,[O].[WO Reviewed] AS [O_WOReviewed]
	,[O].[WO Review Date] AS [O_WOReviewDate]
	,[O].[Follow Up Date] AS [O_FollowUpDate]
	,[O].[MSOIsDifferent] AS [O_MSOIsDifferent]
	,[O].[MSOLocID] AS [O_MSOLocID]
	,[O].[EstInvDateOverride] AS [O_EstInvDateOverride]
	,[O].[Estimated Invoice Date] AS [O_EstimatedInvoiceDate]
	,[O].[AdditionalPricingInfo] AS [O_AdditionalPricingInfo]
	,[O].[Slot#] AS [O_Slot]
	,[O].[TempModel?] AS [O_TempModel]
	,[O].[HighRiskUnit] AS [O_HighRiskUnit]
	,[O].[EngNotes V2] AS [O_EngNotesV2]
	,[O].[CompanyID] AS [O_CompanyID]
	,[O].[Customer WO#] AS [O_CustomerWO]
	,NULL AS [O_Step2Slot]
	,[O].[PriceSecured] AS [O_PriceSecured]
	,[O].[DateSecured] AS [O_DateSecured]
	,[O].[SecuredBy] AS [O_SecuredBy]
	,NULL AS [O_InternalSalesComment]
	,[O].[InternalSalesCommentDate] AS [O_InternalSalesCommentDate]
	,[O].[InternalSalesCommenter] AS [O_InternalSalesCommenter]
	,[O].[DiscountID] AS [O_DiscountID]
	,[O].[DiscountSetDate] AS [O_DiscountSetDate]
	,[O].[DiscountSetBy] AS [O_DiscountSetBy]
	,[O].[ProductID] AS [O_ProductID]
	,[O].[DateLastQuoteReport] AS [O_DateLastQuoteReport]
	,[O].[JobAvailableLine] AS [O_JobAvailableLine]
	,[O].[JobAvailableScheduled] AS [O_JobAvailableScheduled]
	,[O].[JobAvailableScheduledBy] AS [O_JobAvailableScheduledBy]
	,NULL AS [O_LCT_PayID]
	,NULL AS [O_LCT_CustomerID]
	,NULL AS [O_Notes_French]
	,NULL AS [O_PTL_PrimaryTaxID]
	,NULL AS [O_PTL_SecondaryTaxID]
	,NULL AS [O_OriginalDeliveryDate]
	,NULL AS [O_QuoteAsStargate]
	,NULL AS [O_PlantOfManufactureCode]
	,NULL AS [O_AdditionalCost1_Description]
	,NULL AS [O_AdditionalCost1_Type]
	,NULL AS [O_AdditionalCost1_Value]
	,NULL AS [O_AdditionalCost2_Description]
	,NULL AS [O_AdditionalCost2_Type]
	,NULL AS [O_AdditionalCost2_Value]
	,NULL AS [O_AdditionalCost3_Description]
	,NULL AS [O_AdditionalCost3_Type]
	,NULL AS [O_AdditionalCost3_Value]
	,NULL AS [O_AdditionalCost4_Description]
	,NULL AS [O_AdditionalCost4_Type]
	,NULL AS [O_AdditionalCost4_Value]
FROM
	[BWSdb].[dbo].[OrdersV2] AS [O] WITH (NOLOCK)
WHERE
	{k_sg} = {v_sg}
;
	"""
	df: pd.DataFrame = connect(sql)
	return df


@st.cache_data(ttl=60*60, show_spinner=True, show_log=True)
def load_quote_standards(quote: str) -> pd.DataFrame:
	sql = f"""
SELECT
	'BWS' AS [Cmpany],
	[B_OS].[IDOS],
	CAST([B_OS].[Quote#] AS NVARCHAR(255)) AS [Quote],
    [B_OS].[WO#],
    [B_OS].[Model No],
    [B_OS].[Standard No],
    [B_OS].[Group],
    [B_OS].[Section],
    [B_OS].[Description],
    [B_OS].[Start Date],
    [B_OS].[End Date],
    [B_OS].[SortG],
    [B_OS].[SortSe],
    [B_OS].[SortGv2],
    [B_OS].[SortSev2],
    [B_OS].[os_timestamp],
    [B_OS].[Group_French],
    [B_OS].[Section_French],
    [B_OS].[Description_French]
FROM 
	[BWSdb].[dbo].[Order Standards] [B_OS] WITH (NOLOCK)
WHERE
	CAST([B_OS].[Quote#] AS NVARCHAR(255)) = '{quote}' 

UNION ALL (
	SELECT
		'STG' AS [Cmpany],
		[S_OS].[IDOS],
		[S_OS].[SGQuote],
		[S_OS].[WO#],
		[S_OS].[Model No],
		[S_OS].[Standard No],
		[S_OS].[Group],
		[S_OS].[Section],
		[S_OS].[Description],
		[S_OS].[Start Date],
		[S_OS].[End Date],
		[S_OS].[SortG],
		[S_OS].[SortSe],
		[S_OS].[SortGv2],
		[S_OS].[SortSev2],
		[S_OS].[os_timestamp],
		NULL AS [Group_French],
		NULL AS [Section_French],
		NULL AS [Description_French]
	FROM 
		[BWSdb].[dbo].[Order StandardsV2] [S_OS] WITH (NOLOCK)
	WHERE
		[B_OS].[SGQuote] = '{quote}'
)
"""
	df = connect(sql)
	return df


def calc_discount(base_price: float, disc: Optional[tuple] = None, option_price: float = 0, npo_price: float = 0) -> tuple[float]:
	gross: float = base_price + options + npos
	disc1_v: float = disc1 if disc1_type == "fixed" else (gross * disc1 * -1 / 100 if disc1_type == "percent" else 0)
	disc1_sub: float = gross + disc1_v
	disc2_v: float = disc2 if disc2_type == "fixed" else (
		disc1_sub * disc2 * -1 / 100 if disc2_type == "percent" else 0)
	disc2_sub: float = disc1_sub + disc2_v
	disc3_v: float = disc3 if disc3_type == "fixed" else (
		disc2_sub * disc3 * -1 / 100 if disc3_type == "percent" else 0)
	disc3_sub: float = disc2_sub + disc3_v  # this is the value that shows as 'Payable in ## Funds' on the Quote Reports

	sale_price: float = disc3_sub
	total_cost: float = made_in + bought_out + sub_contract + lab_act  # this is negative
	mgn_dol: float = sale_price - abs(total_cost)
	mgn_per: float = (sale_price / (abs(total_cost) if (total_cost != 0) else 1)) - 1

	sale_price_cdn: float = disc3_sub * fx_rate
	disc1_cdn: float = disc1 * (fx_rate if disc1_type == "percent" else 1)
	disc2_cdn: float = disc2 * (fx_rate if disc2_type == "percent" else 1)
	disc3_cdn: float = disc3 * (fx_rate if disc3_type == "percent" else 1)
	gross_cdn: float = gross * fx_rate
	disc1_v_cdn: float = disc1_cdn if disc1_type == "fixed" else (
		gross_cdn * disc1_cdn * -1 / 100 if disc1_type == "percent" else 0)
	disc1_sub_cdn: float = gross_cdn + disc1_v_cdn
	disc2_v_cdn: float = disc2_cdn if disc2_type == "fixed" else (
		disc1_sub * disc2_cdn * -1 / 100 if disc2_type == "percent" else 0)
	disc2_sub_cdn: float = disc1_sub_cdn + disc2_v_cdn
	disc3_v_cdn: float = disc3_cdn if disc3_type == "fixed" else (
		disc2_sub * disc3_cdn * -1 / 100 if disc3_type == "percent" else 0)
	disc3_sub_cdn: float = disc2_sub_cdn + disc3_v_cdn  # this is the CDN equivalent of the payable line of Quote Reports
	mgn_dol_cdn: float = sale_price_cdn - abs(total_cost)
	mgn_per_cdn: float = (sale_price_cdn / (abs(total_cost) if (total_cost != 0) else 1)) - 1
	
	if disc is None:
		disc = [None] * 3
	d_name, d_type, d_val = disc
	d_name: str = f"{d_name}".replace(" ", "").strip().lower()
	p = base_price
	return p


def quote_card(df: pd.DataFrame):
	ser = df.reset_index().iloc[0]
	company: str = ser["O_Company"]
	us_sale: bool = ser["O_USSale"]
	declined: int = ser["O_DeclineRejected"]
	quote: str = ser["O_Quote"]
	wo: int | None = ser["O_WO"]
	serial: str | None = ser["O_SerialNumber"]
	sales_order: str | None = ser["O_SalesOrder"]
	purchase_order: str | None = ser["O_PurchaseOrder"]
	invoice: str | None = ser["O_Invoice"]
	model: str | None = ser["O_ModelNo"]
	width: int | None = ser["O_Width"]
	spread: int | None = ser["O_Spread"]
	promo_dwg: str | None = ser["O_PromDrawing"]
	special_instructions: str | None = ser["O_SpecialInstructions"]
	notes: str | None = ser["O_Notes"]

	date_quote: datetime.date | None = ser["O_QuoteDate"]
	date_order: datetime.date | None = ser["O_OrderDate"]
	date_declined: datetime.date | None = ser["O_DateDeclined"]
	date_available: datetime.date | None = ser["O_AvailableDate"]
	date_delivery: datetime.date | None = ser["O_DeliveryDate"]
	date_requested_delivery: datetime.date | None = ser["O_RequestedDeliveryDate"]
	date_finish: datetime.date | None = ser["O_FinishDate"]
	date_po: datetime.date | None = ser["O_PODate"]
	date_shipped: datetime.date | None = ser["O_ShippedDate"]
	date_pdd: datetime.date | None = ser["O_PDD"]
	date_register: datetime.date | None = ser["O_DateRegistered"]
	date_service: datetime.date | None = ser["O_DateInService"]
	date_invoiced: datetime.date | None = ser["O_InvoiceDate"]
	date_wo_reviewed: datetime.date | None = ser["O_WOReviewDate"]

	base_price: float = ser["O_Price"]
	option_price: float = 0
	npo_price: float = 0
	fx_rate: float | None = ser.get("O_FERate", 1)
	disc_volume: float | None = ser["O_VolumeDiscount"]
	disc_program: float | None = ser["O_ProgramDiscount"]

	if fx_rate is None:
		fx_rate = 1

	discounts = []
	for i in range(3):
		k_key = f"O_Discount{i+1}_Name"
		k_type = f"O_Discount{i+1}_Type"
		k_val = f"O_Discount{i+1}"
		discounts.append({k: ser[v] for k, v in {"name": k_key, "type": k_type, "value": k_val}.items()})

	id_dealer: int = ser["O_DealerID"]
	id_sales_person: int = ser["O_SalePersonID"]

	declined: bool = declined != 4

	dates = {
		"Quoted": date_quote,
		"Ordered": date_order,
		"Declined": date_declined,
		"Available": date_available,
		"Delivered": date_delivery,
		"Delivery (Requested)": date_requested_delivery,
		"Finish": date_finish,
		"PO": date_po,
		"Shipped": date_shipped,
		"PDD": date_pdd,
		"Registered": date_register,
		"In Service": date_service,
		"Invoiced": date_invoiced,
		"WO Reviewed": date_wo_reviewed
	}

	dates = {k: v for k, v in dates.items() if not pd.isna(v)}

	# d1_val = calc_discount(base_price, discounts[0], option_price, npo_price)
	# d2_val = calc_discount(base_price, discounts[1], option_price, npo_price)
	# d3_val = calc_discount(base_price, discounts[2], option_price, npo_price)
	gross: float = base_price + option_price + npo_price
	disc1_v: float = discounts[0]["value"] if discounts[0]["type"] == "fixed" else (gross * discounts[0]["value"] * -1 / 100 if discounts[0]["type"] == "percent" else 0)
	disc1_sub: float = gross + disc1_v
	disc2_v: float = discounts[1]["value"] if discounts[1]["type"] == "fixed" else (
		disc1_sub * discounts[1]["value"] * -1 / 100 if discounts[1]["type"] == "percent" else 0)
	disc2_sub: float = disc1_sub + disc2_v
	disc3_v: float = discounts[2]["value"] if discounts[2]["type"] == "fixed" else (
		disc2_sub * discounts[2]["value"] * -1 / 100 if discounts[2]["type"] == "percent" else 0)
	disc3_sub: float = disc2_sub + disc3_v  # this is the value that shows as 'Payable in ## Funds' on the Quote Reports

	made_in, bought_out, sub_contract, lab_act = 0, 0, 0, 0

	sale_price: float = disc3_sub
	total_cost: float = made_in + bought_out + sub_contract + lab_act  # this is negative
	mgn_dol: float = sale_price - abs(total_cost)
	mgn_per: float = (sale_price / (abs(total_cost) if (total_cost != 0) else 1)) - 1

	sale_price_cdn: float = disc3_sub * fx_rate
	disc1_cdn: float = discounts[0]["value"] * (fx_rate if discounts[0]["type"] == "percent" else 1)
	disc2_cdn: float = discounts[1]["value"] * (fx_rate if discounts[1]["type"] == "percent" else 1)
	disc3_cdn: float = discounts[2]["value"] * (fx_rate if discounts[2]["type"] == "percent" else 1)
	gross_cdn: float = gross * fx_rate
	disc1_v_cdn: float = disc1_cdn if discounts[0]["type"] == "fixed" else (
		gross_cdn * disc1_cdn * -1 / 100 if discounts[0]["type"] == "percent" else 0)
	disc1_sub_cdn: float = gross_cdn + disc1_v_cdn
	disc2_v_cdn: float = disc2_cdn if discounts[1]["type"] == "fixed" else (
		disc1_sub * disc2_cdn * -1 / 100 if discounts[1]["type"] == "percent" else 0)
	disc2_sub_cdn: float = disc1_sub_cdn + disc2_v_cdn
	disc3_v_cdn: float = disc3_cdn if discounts[2]["type"] == "fixed" else (
		disc2_sub * disc3_cdn * -1 / 100 if discounts[2]["type"] == "percent" else 0)
	disc3_sub_cdn: float = disc2_sub_cdn + disc3_v_cdn  # this is the CDN equivalent of the payable line of Quote Reports
	mgn_dol_cdn: float = sale_price_cdn - abs(total_cost)
	mgn_per_cdn: float = (sale_price_cdn / (abs(total_cost) if (total_cost != 0) else 1)) - 1

	lines = [
		[("Company:", company), ("Declined:", declined), ("US Sale:", us_sale)],
		[("Quote:", quote), ("WO:", wo), ("S/N:", serial)],
		[("Model:", model), ("Base Price: ", f"$ {base_price:,.2f}")],
		[("Dealer:", id_dealer), ("Sales Rep:", id_sales_person)],
		[("SO:", sales_order), ("PO:", purchase_order)],
		[("Width:", width), ("Spread:", spread)],
		[("Promo:", promo_dwg)],
		[("Special Instructions:", special_instructions)],
		[("Notes:", special_instructions)],
		[("Program:", disc_program), ("Volume:", disc_volume)]
	]

	# lines = [line_data for line_data in lines if any([ld[1] for ld in line_data])]

	# grid = [st.columns([0.5/3, 0.5/3, 0.5/3, 0.5]) for _ in lines]
	grid = st.columns([0.5/3, 0.5/3, 0.5/3, 0.5])

	st.write({
		"gross": gross,
		"disc1_v": disc1_v,
		"disc1_sub": disc1_sub,
		"disc2_v": disc2_v,
		"disc2_sub": disc2_sub,
		"disc3_v": disc3_v,
		"disc3_sub": disc3_sub,
		"made_in": made_in,
		"bought_out": bought_out,
		"sub_contract": sub_contract,
		"lab_act": lab_act,

		"sale_price": sale_price,
		"total_cost": total_cost,
		"mgn_dol": mgn_dol,
		"mgn_per": mgn_per,

		"sale_price_cdn": sale_price_cdn,
		"disc1_cdn": disc1_cdn,
		"disc2_cdn": disc2_cdn,
		"disc3_cdn": disc3_cdn,
		"gross_cdn": gross_cdn,
		"disc1_v_cdn": disc1_v_cdn,
		"disc1_sub_cdn": disc1_sub_cdn,
		"disc2_v_cdn": disc2_v_cdn,
		"disc2_sub_cdn": disc2_sub_cdn,
		"disc3_v_cdn": disc3_v_cdn,
		"disc3_sub_cdn": disc3_sub_cdn,
		"mgn_dol_cdn": mgn_dol_cdn,
		mgn_per_cdn: mgn_per_cdn
	})

	for i, line_data in enumerate(lines):
		for j in range(3):
			# st.write(f"{k=}, {v=}, {type(v)=}")
			if j < len(line_data):
				k, v = line_data[j]
				with grid[j]:
					with st.container(horizontal=True, border=True):
						if isinstance(v, (bool, np.bool_)):
							st.checkbox(
								label=k,
								key=f"k_checkbox_{i=}_{j=}_{k=}{akey}",
								value=v,
								disabled=True
							)
						else:
							sv: str = f"{v}"
							if len(sv) > 25:
								st.text_area(
									label=k,
									value=sv,
									disabled=True,
									key=f"k_textarea_{i=}_{j=}_{k=}{akey}"
								)
							else:
								st.write(k)
								st.write(sv)
			else:
				cont = st.container(border=True, height=100)
				with cont:
					st.write("SPACE")
		st.write("discounts")
		st.write(discounts)

	with grid[3]:
		df_dates: pd.DataFrame = pd.DataFrame([{"event": k, "date": v} for k, v in dates.items()])
		df_dates.sort_values(by="date", inplace=True)
		df_dates["DaysBetween"] = df_dates["date"].diff().dt.days

		st.write("df_dates")
		st.write(df_dates)

		timeline_events = []
		seconds = 12 * 60 * 60
		# ed = df_dates["date"].max()
		for i, row in df_dates.iterrows():
			event = row["event"]
			d: datetime.date = row["date"]
			sd = d + datetime.timedelta(seconds=-seconds)
			ed = d + datetime.timedelta(seconds=seconds)
			timeline_events.append({
				"Start Date": sd,
				"End Date": ed,
				"Event": event,
				"State": event
			})

		# # lst_unique_jobs = df_shopclock["JobNumber"].unique()
		# # lst_unique_groups = df_shopclock["GroupName"].unique()
		# # colour_start = Colour("#DD2212")
		# # colour_end = Colour("#22DD12")
		# # colours_for_grad = [
		# # 	colour_start,
		# # 	colour_end
		# # ]
		# # wo_grad = gradient_merge(colours_for_grad.copy(), len(lst_unique_jobs), as_hex=True)
		# # group_grad = gradient_merge(colours_for_grad.copy(), len(lst_unique_groups), as_hex=True)
		# # wo_colour_map = {j: wo_grad[i] for i, j in enumerate(lst_unique_jobs)}
		# # group_colour_map = {g: group_grad[i] for i, g in enumerate(lst_unique_groups)}
		# for i, row in df_dates.iterrows():
		# 	timeline_events.append({
		# 		# "start": game.start_time_atl.strftime(UTC_FMT).removesuffix("Z"),
		# 		"Start Date": row["LoggedOn"],
		# 		# "end": (game.start_time_atl + datetime.timedelta(minutes=165)).strftime(UTC_FMT).removesuffix("Z"),
		# 		"End Date": datetime.datetime.now() if pd.isna(row["LoggedOff"]) else row["LoggedOff"],
		# 		"Event": f"{row['EmployeeName']} {row['EmployeeNumber']}",
		# 		"State": row["GroupName"] if radio_colour_by == options_radio_colour_by[1] else row["JobNumber"]
		# 	})
		#
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
			title='Movements:',
			color='State',
			height=350,
			# color_discrete_map=group_colour_map if radio_colour_by == options_radio_colour_by[1] else wo_colour_map
		)

		# Update layout to make it more readable
		fig_timeline_games.update_layout(xaxis_title="Date", yaxis_title="Movements")

		# Display in Streamlit
		chart_widget = st.plotly_chart(fig_timeline_games)
		t_days = int(df_dates["DaysBetween"].sum())
		st.write(f"Total Days: {t_days}")
		# st.write(chart_widget)



########################################################################
# Begin Auth Boilerplate

VERSION = (1, 0, 0)
VERSION_DATE = datetime.datetime(2026, 2, 17, 9, 12)
version_str: str = f"v{'.'.join(map(str, VERSION))}"
APP_NAME: str = st.secrets["app"]['app_name']
akey: str = "_sales"
PAGE_NAME: str = f"{APP_NAME}{akey}"

st.set_page_config(
	layout="wide",
	page_title=APP_NAME
)

if not auth.st_auth(PAGE_NAME):
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
			key=f"k_clear_cache_rerun{akey}"
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


op_search_mode_simple: str = "Simple"
op_search_mode_advanced: str = "Advanced"
op_search_mode_by_bin: str = "By Bin"
op_search_mode_by_section: str = "By Section"
op_search_mode_by_po: str = "By PO"
op_search_mode_by_so: str = "By SO"
op_search_mode_by_warranty: str = "By Warranty"
op_search_mode_by_pick_list: str = "By Pick List"
op_search_mode_by_supplier: str = "By Supplier"
op_search_mode_by_shopclock: str = "ShopClock",
op_search_mode_syspro: str = "Syspro"
op_search_mode_warehouse: str = "Warehouse"
op_search_mode_by_drawing: str = "By Drawing"
op_search_mode_day_totals: str = "Day Totals"
op_search_mode_day_testing: str = "Testing"
options_pills_mode = [
	op_search_mode_simple
	# ,
	# op_search_mode_advanced,
	# op_search_mode_by_bin,
	# op_search_mode_by_section,
	# op_search_mode_by_po,
	# op_search_mode_by_so,
	# op_search_mode_by_warranty,
	# op_search_mode_by_pick_list,
	# op_search_mode_by_supplier,
	# op_search_mode_by_shopclock,
	# op_search_mode_syspro,
	# op_search_mode_warehouse,
	# op_search_mode_by_drawing
]

# if user in admin_end_users:
# 	options_pills_search_mode.append(
# 		op_search_mode_day_totals
# 	)
# if user in admin_test_users:
# 	options_pills_search_mode.append(
# 		op_search_mode_day_testing
# 	)


df_quotes: pd.DataFrame = load_quotes()

k_checkbox_recent_only: str = f"key_checkbox_recent_only{akey}"
st.session_state.setdefault(k_checkbox_recent_only, True)
checkbox_recent_only = st.checkbox(
	label="Recent Quotes / WOs / Serials Only?",
	key=k_checkbox_recent_only,
	help="View only units quoted within the last 18 months"
)

if checkbox_recent_only:
	n_days: int = 365 + 183
	min_date: datetime.date = datetime.datetime.now().date() + datetime.timedelta(days=-n_days)
	max_date: datetime.date = datetime.datetime.now().date() + datetime.timedelta(days=n_days)
	st.write(f"{min_date=}")
	st.write(f"{max_date=}")
	df_quotes = df_quotes[
		(min_date <= df_quotes["QuoteDate"])
		& (df_quotes["QuoteDate"] <= max_date)
	]

lst_quotes: list[str] = df_quotes["Quote"].dropna().unique().tolist()
lst_wos: list[str] = df_quotes["WO"].dropna().unique().tolist()
lst_serials: list[str] = df_quotes["SerialNumber"].dropna().unique().tolist()

k_pills_mode: str = f"key_pills_mode{akey}"
pills_mode = pills(
	key=k_pills_mode,
	options=options_pills_mode,
	label="Mode:"
)

# if pills_mode == options_pills_mode.index(op_search_mode_advanced):
if pills_mode == -99:
	pass
else:
	# Simple
	with st.container(border=True, horizontal=True):
		k_multiselect_quotes: str = f"k_multiselect_quotes{akey}"
		multiselect_quotes = st.multiselect(
			label="Quote:",
			options=lst_quotes,
			key=k_multiselect_quotes
		)
		k_multiselect_wos: str = f"k_multiselect_wos{akey}"
		multiselect_wos = st.multiselect(
			label="WO:",
			options=lst_wos,
			key=k_multiselect_wos
		)
		k_multiselect_sns: str = f"k_multiselect_sns{akey}"
		multiselect_sns = st.multiselect(
			label="Serial:",
			options=lst_serials,
			key=k_multiselect_sns
		)

if any([multiselect_quotes, multiselect_wos, multiselect_sns]):
	lst_df_orders: list = []
	for k, lst_v in {
		"Quote#": multiselect_quotes,
		"WO#": multiselect_wos,
		"Serial Number": multiselect_sns
	}.items():
		for v in lst_v:
			lst_df_orders.append(load_order_data(**{k:v}))
		if lst_df_orders:
			df_orders_sel = pd.concat(lst_df_orders, ignore_index=True)
		else:
			df_orders_sel = pd.DataFrame(data={"No Data": [None]})

	df_orders_sel["selection"] = False
	k_stdf_selected_orders: str = f"key_stdf_selected_orders{akey}"
	if len(df_orders_sel) == 1:
		df_orders_sel["selection"] = True

	cols = df_orders_sel.columns.tolist()
	cols.remove("selection")
	cols.insert(0, "selection")

	# if len(df_orders_sel) == 1 and k_stdf_selected_orders not in st.session_state:
	# 	# Preselect the first row (index 0)
	# 	st.session_state[k_stdf_selected_orders] = {
	# 		"selection": {"rows": [0], "columns": []}
	# 	}


	stdf_orders_sel = display_df_paginated(
		df_orders_sel[cols],
		"Orders",
		key=k_stdf_selected_orders,
		batch_size_options=(100, 250, 1000),
		# selection_mode="single-row",
		# on_select="rerun",
		column_config={"selection": st.column_config.CheckboxColumn(
			label="Selected"
		)}
	)

	df_selected = get_selected_rows(
		df_orders_sel,
		stdf_orders_sel,
		cols=df_orders_sel.columns,
		n=None
	)

	if not df_selected.empty:
		stdf_selected = display_df_paginated(
			df_selected,
			"Selected Orders",
			key=f"k_stdf_selected{akey}",
			batch_size_options=(100, 250, 1000),
			selection_mode="single-row",
			on_select="rerun"
		)
		quote_card(df_selected)
