USE BWSdb
GO


CREATE PROCEDURE [sp_QuoteEditMenuData_STG]
	@q AS NVARCHAR(MAX)
AS
BEGIN

--DECLARE @q AS NVARCHAR(MAX) = 'SG101135'

	SELECT 
		BWSdb_OrdersV2.SGQuote,
		BWSdb_OrdersV2.[Quote Date],
		BWSdb_OrdersV2.[Requested Delivery Date],
		BWSdb_OrdersV2.[Finish Date],
		BWSdb_OrdersV2.[Order Date],
		BWSdb_OrdersV2.[WO#],
		BWSdb_OrdersV2.[Sales Order#],
		BWSdb_OrdersV2.[Model No],
		BWSdb_OrdersV2.DealerID,
		BWSdb_OrdersV2.DealerBranchID,
		BWSdb_OrdersV2.DealerSalesPersonID,
		BWSdb_OrdersV2.[Sale PersonID],
		BWSdb_OrdersV2.Price,
		BWSdb_OrdersV2.[Prom Drawing],
		BWSdb_OrdersV2.[Special Instructions],
		BWSdb_OrdersV2.[Date Declined],
		BWSdb_OrdersV2.[Decline/Rejected],
		BWSdb_OrdersV2.[Serial Number],
		BWSdb_OrdersV2.[Available Date],
		BWSdb_OrdersV2.[Delivery Date],
		BWSdb_OrdersV2.[Purchase Order],
		BWSdb_OrdersV2.[PO Date],
		BWSdb_OrdersV2.PayID,
		BWSdb_OrdersV2.[Est Pro Date],
		BWSdb_OrdersV2.[Volume Discount],
		BWSdb_OrdersV2.[Program Discount],
		BWSdb_OrdersV2.Notes,
		BWSdb_OrdersV2.Width,
		BWSdb_OrdersV2.Spread,
		BWSdb_OrdersV2.[US Sale],
		BWSdb_OrdersV2.[FE Rate],
		BWSdb_OrdersV2.PDD,
		BWSdb_ProductsV2.[Promo Drawing],
		BWSdb_DealersV2_SalesPersonBranch.Contact,
		BWSdb_DealersV2.[COMPANY NAME],
		BWSdb_OrdersV2.Discount1_Name,
		BWSdb_OrdersV2.Discount1_Type,
		BWSdb_OrdersV2.Discount1,
		BWSdb_OrdersV2.Discount2_Name,
		BWSdb_OrdersV2.Discount2_Type,
		BWSdb_OrdersV2.Discount2,
		BWSdb_OrdersV2.Discount3_Name,
		BWSdb_OrdersV2.Discount3_Type,
		BWSdb_OrdersV2.Discount3,
		Leads.[LeadID#],
		Leads.[Lead Date],
		BWSdb_OrdersV2.FinishedGoodsDealerLocID,
		BWSdb_OrdersV2.[Follow Up Date],
		BWSdb_OrdersV2.MSOIsDifferent,
		BWSdb_OrdersV2.MSOLocID,
		BWSdb_OrdersV2.EstInvDateOverride,
		BWSdb_OrdersV2.[Estimated Invoice Date],
		BWSdb_OrdersV2.AdditionalPricingInfo,
		BWSdb_OrdersV2.[Slot#],
		BWSdb_OrdersV2.[TempModel?],
		BWSdb_OrdersV2.HighRiskUnit,
		BWSdb_OrdersV2.[Customer WO#],
		BWSdb_OrdersV2.PriceSecured,
		BWSdb_OrdersV2.DateSecured,
		BWSdb_OrdersV2.SecuredBy,
		BWSdb_OrdersV2.InternalSalesComments,
		BWSdb_OrdersV2.InternalSalesCommentDate,
		BWSdb_OrdersV2.InternalSalesCommenter
	FROM 
	((
		[DealersV2] AS BWSdb_DealersV2
		INNER JOIN 
		((
			[OrdersV2] AS BWSdb_OrdersV2
			INNER JOIN 
				[Sales Staff]
			ON
				BWSdb_OrdersV2.[Sale PersonID] = [Sales Staff].[ID-SaleStaff]) 
			LEFT JOIN 
				[ProductsV2] AS BWSdb_ProductsV2
			ON
				BWSdb_OrdersV2.[Model No] = BWSdb_ProductsV2.[Model No])
			ON
				BWSdb_DealersV2.ID = BWSdb_OrdersV2.DealerID) 
			LEFT JOIN 
				[DealersV2_SalesPersonBranch] AS BWSdb_DealersV2_SalesPersonBranch 
			ON 
				(BWSdb_OrdersV2.DealerID = BWSdb_DealersV2_SalesPersonBranch.DealerID) 
				AND (BWSdb_OrdersV2.DealerBranchID = BWSdb_DealersV2_SalesPersonBranch.DealersV2_SPBID)) 
			LEFT JOIN
				Leads
			ON 
				BWSdb_OrdersV2.LeadID = Leads.[LeadID#]
	--WHERE (((CStr([Forms]![Edit Existing Quote/Order Parameters]![TQuote])) In (CStr(IIf(IsNull([BWSdb_OrdersV2].[SGQuote]),"",[BWSdb_OrdersV2].[SGQuote])),CStr(IIf(IsNull([BWSdb_OrdersV2].[WO#]),"",[BWSdb_OrdersV2].[WO#])),CStr(IIf(IsNull([BWSdb_OrdersV2].[Serial Number]),"",[BWSdb_OrdersV2].[Serial Number])))));
	WHERE @q In (
		[BWSdb_OrdersV2].[SGQuote],
		CAST([BWSdb_OrdersV2].[WO#] AS NVARCHAR(MAX)),
		[BWSdb_OrdersV2].[Serial Number]
	);
END