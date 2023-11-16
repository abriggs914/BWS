USE BWSdb 
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


CREATE VIEW [v_SFC_SalesPersonIndividualSalesCounts] AS
SELECT
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
		,[O].[Sale PersonID]
		,COUNT(*) AS [NumQuotesPrepared]
		,SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS [NumInvalidQuotes]
		,SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS [NumSoldDeliveredUnits]
		,SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS [NumUnitsOnOrder]
		,SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS [NumQuotesOutToDealer]
		,SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS [NumCancelledQuotes]
		,SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS [NumCancelledOrders]
	FROM
		[Orders] AS [O]
	LEFT JOIN
		[Sales Staff] AS [S]
	ON
		[O].[Sale PersonID] = [S].[ID-SaleStaff]
	GROUP BY
		[Sales Person]
		,[O].[Sale PersonID]
) AS [SrcA]