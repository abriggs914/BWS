/*
BEGIN TRAN;

UPDATE
	[BWSdb].[dbo].[Orders]
SET
	[Serial Number] = ISNULL([Serial Number], NULL)

ROLLBACK;
COMMIT;
*/

BEGIN TRAN;
INSERT INTO
		[CompanyH].[dbo].[Orders]
	(
		[CompanyID]
        ,[WONumber]
        ,[ProductID]
        ,[SalesPersonID]
        ,[DealerID]
        ,[DealerBranchID]
        ,[DealerSalesPersonID]
        ,[DateQuote]
        ,[DateOrder]
        ,[DateDeclined]
        ,[DateAvailable]
        ,[DateDelivery]
        ,[DateRequestedDelivery]
        ,[DateFinish]
        ,[DatePurchaseOrder]
        ,[DateShipped]
        ,[DateRegistered]
        ,[DateInService]
        ,[DateInvoice]
        ,[PromoDrawing]
        ,[SpecialInstructions]
        ,[SerialNumber]
        ,[PurchaseOrder]
        ,[Notes]
        ,[EngNotes]
        ,[AdditionalPricingInfo]
        ,[InternalSalesComment]
        ,[Price]
        ,[USSale]
        ,[HighRiskUnit]
        ,[Width]
        ,[Spread]
        ,[Tare]
        ,[GVWR]
		,[BWSdbQuoteNumber]
	)
    SELECT
		0
        ,[I].[WO#]
        ,[I].[ProductID]
        ,[I].[Sale PersonID]
        ,[I].[DealerID]
        ,[I].[DealerBranchID]
        ,[I].[DealerSalesPersonID]
        ,[I].[Quote Date]
        ,[I].[Order Date]
        ,[I].[Date Declined]
        ,[I].[Available Date]
        ,[I].[Delivery Date]
        ,[I].[Requested Delivery Date]
        ,[I].[Finish Date]
        ,[I].[PO Date]
        ,[I].[Shipped Date]
        ,[I].[Date Registered]
        ,[I].[Date In Service]
        ,[I].[Invoice Date]
        ,[I].[Prom Drawing]
        ,[I].[Special Instructions]
        ,CAST([I].[Serial Number] AS NVARCHAR(17))
        ,[I].[Purchase Order]
        ,[I].[Notes]
        ,[I].[EngNotes V2]
        ,[I].[AdditionalPricingInfo]
        ,[I].[InternalSalesComment]
        ,[I].[Price]
        ,[I].[US Sale]
        ,[I].[HighRiskUnit]
        ,[I].[Width]
        ,[I].[Spread]
        ,[I].[Tare]
        ,[I].[GVWR]
		,CAST([I].[Quote#] AS NVARCHAR(25))
    FROM 
		[BWSdb].[dbo].[Orders] [I]
	LEFT JOIN
		[CompanyH].[dbo].[Orders] [D]
	ON
		[D].[BWSdbQuoteNumber] = CAST([I].[Quote#] AS NVARCHAR(25))
	WHERE
		[D].[BWSdbQuoteNumber] IS NULL

	UNION ALL
	
    SELECT
		1
        ,[I].[WO#]
        ,[I].[ProductID]
        ,[I].[Sale PersonID]
        ,[I].[DealerID]
        ,[I].[DealerBranchID]
        ,[I].[DealerSalesPersonID]
        ,[I].[Quote Date]
        ,[I].[Order Date]
        ,[I].[Date Declined]
        ,[I].[Available Date]
        ,[I].[Delivery Date]
        ,[I].[Requested Delivery Date]
        ,[I].[Finish Date]
        ,[I].[PO Date]
        ,[I].[Shipped Date]
        ,[I].[Date Registered]
        ,[I].[Date In Service]
        ,[I].[Invoice Date]
        ,[I].[Prom Drawing]
        ,[I].[Special Instructions]
        ,CAST([I].[Serial Number] AS NVARCHAR(17))
        ,[I].[Purchase Order]
        ,[I].[Notes]
        ,[I].[EngNotes V2]
        ,[I].[AdditionalPricingInfo]
        ,NULL AS [InternalSalesComment]
        ,[I].[Price]
        ,[I].[US Sale]
        ,[I].[HighRiskUnit]
        ,[I].[Width]
        ,[I].[Spread]
        ,[I].[Tare]
        ,[I].[GVWR]
		,CAST([I].[SGQuote] AS NVARCHAR(25))
    FROM 
		[BWSdb].[dbo].[OrdersV2] [I]
	LEFT JOIN
		[CompanyH].[dbo].[Orders] [D]
	ON
		[D].[BWSdbQuoteNumber] = CAST([I].[SGQuote] AS NVARCHAR(25))
	WHERE
		[D].[BWSdbQuoteNumber] IS NULL

ROLLBACK;
COMMIT;