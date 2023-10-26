USE BWSdb
GO


DECLARE @today AS DATETIME = GETDATE();

SELECT
	[DateGroup]
	,[Model No]
	,[NumOrders]
	,[TtlPrice]
	,[TtlPrice] / (CASE WHEN [NumOrders] = 0 THEN 1 ELSE [NumOrders] END) AS [AveragePerSale]
FROM (
	SELECT 
		[DateGroup]
		,[Model No]
		,COUNT(*) AS [NumOrders]
		,SUM([Price]) AS [TtlPrice]
	FROM (
		SELECT
			CAST(ABS(DATEDIFF(DAY, @today, ISNULL([Order Date], [Quote Date]))) / 365.0 AS INT) AS [DateGroup]
			,[Quote#], [Quote Date], [Order Date]
			,[WO#], [Sales Order#], [Model No]
			,[Width], [Spread], [DealerID]
			,[Sale PersonID], [Price], [Prom Drawing]
			,[Special Instructions], [Date Declined], [Decline/Rejected]
			,[Serial Number], [Available Date], [Delivery Date]
			,[Requested Delivery Date], [Finish Date], [Purchase Order]
			,[PO Date], [PayID], [Volume Discount], [Program Discount]
			,[Discount1_Name], [Discount1_Type], [Discount1]
			,[Discount2_Name], [Discount2_Type], [Discount2]
			,[Discount3_Name], [Discount3_Type], [Discount3]
			,[Est Pro Date], [Notes], [EngNotes]
			,[CarrierID], [CustID], [US Sale]
			,[Shipped Date], [GL Override Date], [FE Rate]
			,[PDD], [Deck Length], [Invoice #]
			,[Date Registered], [Date In Service], [Invoice Date]
			,[Date Requested], [GVWR], [Tare]
			,[Selection], [Warranty], [BWSPaid]
			,[BWSPaidDate], [CommPaid], [CommPaidDate]
			,[ts_timestamp],[ModifiedBy], [Lead Date]
			,[Lead Source], [LeadID], [DealerBranchID]
			,[DealerSalesPersonID], [DataEntryCheck], [DataEntryUser]
			,[FinishedGoodsDealerLocID], [WO Reviewed], [WO Review Date]
			,[Follow Up Date], [MSOIsDifferent], [MSOLocID]
			,[EstInvDateOverride], [Estimated Invoice Date], [AdditionalPricingInfo]
			,[Slot#], [TempModel?], [HighRiskUnit]
			,[EngNotes V2], [CompanyID], [Customer WO#]
			,[Step 2 Slot#], [PriceSecured], [DateSecured]
			,[SecuredBy], [InternalSalesComment], [InternalSalesCommentDate]
			,[InternalSalesCommenter], [DiscountID], [DiscountSetDate]
			,[DiscountSetBy], [ProductID]
		FROM
			[Orders]
		WHERE
			[Order Date] IS NOT NULL
			--[Decline/Rejected] = 4
	--		[Date Declined] IS NULL
	) AS [SubA]
	GROUP BY
		[DateGroup]
		,[Model No]
) AS [SubB]
ORDER BY
	[DateGroup]
	,[Model No]
