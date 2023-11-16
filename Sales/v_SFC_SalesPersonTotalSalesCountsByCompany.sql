USE [BWSdb]
GO

/****** Object:  View [dbo].[v_SFC_SalesPersonIndividualSalesCounts]    Script Date: 2023-11-16 11:18:07 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--SELECT
--	*
--	,[GrandTotalOrders] + [GrandTotalOutQuotes] + [GrandTotalCancellations]
--	,[GrandTotalOrders] + [GrandTotalOutQuotes] + [GrandTotalCancellations]
--FROM (
--	SELECT
--			COUNT(*) AS [GrandTotalQuotes]
--		FROM
--			[v_SFC_OrdersData]
--	) AS [A] 
--	CROSS JOIN (
--		SELECT
--			COUNT(*) AS [GrandTotalOrders]
--		FROM
--			[v_SFC_OrdersData]
--		WHERE
--			[Date Declined] IS NULL
--			AND [v_SFC_OrdersData].[QuoteOrderDate] IS NOT NULL
--	) AS [B] 
--	CROSS JOIN (
--		SELECT
--			COUNT(*) AS [GrandTotalCancellations]
--		FROM
--			[v_SFC_OrdersData]
--		WHERE
--			[Date Declined] IS NOT NULL
--	) AS [C] 
--	CROSS JOIN (
--		SELECT
--			COUNT(*) AS [GrandTotalOutQuotes]
--		FROM
--			[v_SFC_OrdersData]
--		WHERE
--			[Date Declined] IS NOT NULL
--			AND [QuoteOrderDate] IS NULL
--	) AS [D]
--;


--ALTER VIEW [dbo].[v_SFC_SalesPersonIndividualSalesCounts] AS
SELECT
	[TotalModelBasePrice],
	[TotalDiscountsMethod1],
	[TotalDiscountsMethod2],
	[TotalDiscountsMethod3],
	[TotalDiscountsMethod4],
	[TotalModelBasePrice] + [TotalDiscountsMethod1] AS [TotalSalesPricesMethod1],
	[TotalModelBasePrice] + [TotalDiscountsMethod2] AS [TotalSalesPricesMethod2],
	[TotalModelBasePrice] + [TotalDiscountsMethod3] AS [TotalSalesPricesMethod3],
	[TotalModelBasePrice] + [TotalDiscountsMethod4] AS [TotalSalesPricesMethod4],

	*
	,100 * ([NumInvalidQuotes] + 0.0)		/ (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS [PctInvalidQuotes]
	,100 * ([NumSoldDeliveredUnits] + 0.0)	/ (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS [PctSoldDeliveredUnits]
	,100 * ([NumUnitsOnOrder] + 0.0)		/ (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS [PctUnitsOnOrder]
	,100 * ([NumQuotesOutToDealer] + 0.0)	/ (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS [PctQuotesOutToDealer]
	,100 * ([NumCancelledQuotes] + 0.0)		/ (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS [PctCancelledQuotes]
	,100 * ([NumCancelledOrders] + 0.0)		/ (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS [PctCancelledOrders]
	--,SUM([NumQuotesPrepared]) AS [GrandTotalNumQuotesPrepared]
FROM (
	SELECT
		[S].[Sales Person]
		,[O].[IDSalesPerson]
		,[O].[CompanyID]
		,COUNT(*) AS [NumQuotesPrepared]
		,SUM(CASE WHEN ([O].[DateQuote] IS NULL) THEN 1 ELSE 0 END) AS [NumInvalidQuotes]
		,SUM(CASE WHEN ([O].[DateQuote] IS NOT NULL) AND ([O].[DateDeclined] IS NULL) AND ([O].[DateOrder] IS NOT NULL) AND ([O].[DateDelivery] IS NOT NULL) THEN 1 ELSE 0 END) AS [NumSoldDeliveredUnits]
		,SUM(CASE WHEN ([O].[DateQuote] IS NOT NULL) AND ([O].[DateDeclined] IS NULL) AND ([O].[DateOrder] IS NOT NULL) AND ([O].[DateDelivery] IS NULL) THEN 1 ELSE 0 END) AS [NumUnitsOnOrder]
		,SUM(CASE WHEN ([O].[DateQuote] IS NOT NULL) AND ([O].[DateDeclined] IS NULL) AND ([O].[DateOrder] IS NULL) THEN 1 ELSE 0 END) AS [NumQuotesOutToDealer]
		,SUM(CASE WHEN ([O].[DateQuote] IS NOT NULL) AND ([O].[DateDeclined] IS NOT NULL) AND ([O].[DateOrder] IS NULL) THEN 1 ELSE 0 END) AS [NumCancelledQuotes]
		,SUM(CASE WHEN ([O].[DateQuote] IS NOT NULL) AND ([O].[DateDeclined] IS NOT NULL) AND ([O].[DateOrder] IS NOT NULL) THEN 1 ELSE 0 END) AS [NumCancelledOrders]
		,SUM([O].[Price]) AS [TotalModelBasePrice]
		,SUM(CASE 
			WHEN ISNULL([O].[Discount1], 0) = 0 THEN 0
			ELSE (CASE
					WHEN ISNULL([O].[Discount1_Type], '') = 'Percent' THEN (-1 * ([O].[Discount1] * [O].[Price]))
					ELSE [O].[Discount1]
				END)
		END)
		+ SUM(CASE 
			WHEN ISNULL([O].[Discount2], 0) = 0 THEN 0
			ELSE (CASE
					WHEN ISNULL([O].[Discount2_Type], '') = 'Percent' THEN (-1 * ([O].[Discount2] * [O].[Price]))
					ELSE [O].[Discount2]
				END)
		END)
		+ SUM(CASE 
			WHEN ISNULL([O].[Discount3], 0) = 0 THEN 0
			ELSE (CASE
					WHEN ISNULL([O].[Discount3_Type], '') = 'Percent' THEN (-1 * ([O].[Discount3] * [O].[Price]))
					ELSE [O].[Discount3]
				END)
		END) AS [TotalDiscountsMethod1]  --(D1D2D3)
		,SUM(CASE 
			WHEN ISNULL([O].[Discount3], 0) = 0 THEN 0
			ELSE (CASE
					WHEN ISNULL([O].[Discount3_Type], '') = 'Percent' THEN (-1 * ([O].[Discount3] * [O].[Price]))
					ELSE [O].[Discount3]
				END)
		END)
		+ SUM(CASE 
			WHEN ISNULL([O].[Discount2], 0) = 0 THEN 0
			ELSE (CASE
					WHEN ISNULL([O].[Discount2_Type], '') = 'Percent' THEN (-1 * ([O].[Discount2] * [O].[Price]))
					ELSE [O].[Discount2]
				END)
		END)
		+ SUM(CASE 
			WHEN ISNULL([O].[Discount1], 0) = 0 THEN 0
			ELSE (CASE
					WHEN ISNULL([O].[Discount1_Type], '') = 'Percent' THEN (-1 * ([O].[Discount1] * [O].[Price]))
					ELSE [O].[Discount1]
				END)
		END) AS [TotalDiscountsMethod2]  --(D3D2D1)

		,SUM(
			(CASE WHEN ISNULL([O].[Discount1_Type], '') = 'Fixed' THEN [Discount1] ELSE 0 END)
			+ (CASE WHEN ISNULL([O].[Discount2_Type], '') = 'Fixed' THEN [Discount2] ELSE 0 END)
			+ (CASE WHEN ISNULL([O].[Discount3_Type], '') = 'Fixed' THEN [Discount3] ELSE 0 END)
		 + (-([O].[Price] 
			+ (CASE WHEN ISNULL([O].[Discount1_Type], '') = 'Fixed' THEN [Discount1] ELSE 0 END)
			+ (CASE WHEN ISNULL([O].[Discount2_Type], '') = 'Fixed' THEN [Discount2] ELSE 0 END)
			+ (CASE WHEN ISNULL([O].[Discount3_Type], '') = 'Fixed' THEN [Discount3] ELSE 0 END))
			* (CASE WHEN ISNULL([O].[Discount1_Type], '') = 'Percent' THEN [Discount1] ELSE 0 END)
			* (CASE WHEN ISNULL([O].[Discount2_Type], '') = 'Percent' THEN [Discount2] ELSE 0 END)
			* (CASE WHEN ISNULL([O].[Discount3_Type], '') = 'Percent' THEN [Discount3] ELSE 0 END))
		) AS [TotalDiscountsMethod3]  --(Fixed First)

		,SUM(-[O].[Price] * 
			(CASE WHEN ISNULL([O].[Discount1_Type], '') = 'Percent' THEN [Discount1] ELSE 0 END)
			* (CASE WHEN ISNULL([O].[Discount2_Type], '') = 'Percent' THEN [Discount2] ELSE 0 END)
			* (CASE WHEN ISNULL([O].[Discount3_Type], '') = 'Percent' THEN [Discount3] ELSE 0 END)
			+ (CASE WHEN ISNULL([O].[Discount1_Type], '') = 'Fixed' THEN [Discount1] ELSE 0 END)
			+ (CASE WHEN ISNULL([O].[Discount2_Type], '') = 'Fixed' THEN [Discount2] ELSE 0 END)
			+ (CASE WHEN ISNULL([O].[Discount3_Type], '') = 'Fixed' THEN [Discount3] ELSE 0 END)
		) AS [TotalDiscountsMethod4]  --(Percent First)

	FROM
		[v_SFC_BWSUnionSTGOrders] AS [O]
	LEFT JOIN
		[Sales Staff] AS [S]
	ON
		[O].[IDSalesPerson] = [S].[ID-SaleStaff]
	LEFT JOIN
		[Products] AS [P]
	ON
		[O].[ProductID] = [P].[IDTrailer]
	GROUP BY
		[Sales Person]
		,[O].[IDSalesPerson]
		,[O].[CompanyID]
) AS [SrcA]
ORDER BY
	[Sales Person]
	,[CompanyID]
--GO


