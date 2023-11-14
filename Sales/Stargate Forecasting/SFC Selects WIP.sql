USE BWSdb
GO

-- SFC Selects
-- All Orders Selects


SELECT
	'v_SFC_OrdersData' AS [T] 
	,*
FROM
	[v_SFC_OrdersData]
;


SELECT
	'v_SFC_OrdersDataOptions' AS [T]
	,*
FROM
	[v_SFC_OrdersDataOptions]
;

SELECT
	*
	,([Total] - [NumCancelled] + 0.0) / (CASE WHEN [Total] <> 0 THEN [Total] ELSE 1.0 END) AS [QuoteOrderRate]
	,([Total] + 0.0) / (CASE WHEN [GrandTotalQuotes] <> 0 THEN [GrandTotalQuotes] ELSE 1 END) AS [PctgShareOfQuotes]
	,([TotalOrders] + 0.0) / (CASE WHEN [GrandTotalOrders] <> 0 THEN [GrandTotalOrders] ELSE 1 END) AS [PctgShareOfOrders]
	,([NumCancelled] + 0.0) / (CASE WHEN [GrandTotalCancellations] <> 0 THEN [GrandTotalCancellations] ELSE 1 END) AS [PctgShareOfCancellations]
FROM (
	SELECT
		'Total Counts for Each Sales Person' AS [T]
		,[Sale PersonID]
		,[Sales Person]
		,COUNT(*) AS [Total]
		,SUM(CASE WHEN [Date Declined] IS NULL AND [QuoteOrderDate] IS NOT NULL THEN 1 ELSE 0 END) AS [TotalOrders]
		,DATEDIFF(YEAR, MIN([Quote Date]), GETDATE()) / 365.0 AS [MinYearsAgo]
		,DATEDIFF(YEAR, MAX([Quote Date]), GETDATE()) / 365.0 AS [MaxYearsAgo]
		,MIN([Quote Date]) AS [FirstQuote]
		,MAX([Quote Date]) AS [LastQuote]
		,SUM(CASE WHEN [Date Declined] IS NULL THEN 0 ELSE 1 END) AS [NumCancelled]
		,SUM([ProductsPrice]) AS [TotalProductsPrice]
		,SUM([OrderPrice]) AS [TotalOrderPrice]
		,SUM(CASE WHEN [Date Declined] IS NULL THEN [OrderPrice] ELSE 0 END) AS [TotalOrderedPrice]
		,[GrandTotalQuotes]
		,[GrandTotalOrders]
		,[GrandTotalCancellations]
		,[GrandTotalOutQuotes]
	FROM
		[v_SFC_OrdersData]
	CROSS JOIN (
		SELECT
			COUNT(*) AS [GrandTotalQuotes]
		FROM
			[v_SFC_OrdersData]
	) AS [A] 
	CROSS JOIN (
		SELECT
			COUNT(*) AS [GrandTotalOrders]
		FROM
			[v_SFC_OrdersData]
		WHERE
			[Date Declined] IS NULL
			AND [v_SFC_OrdersData].[QuoteOrderDate] IS NOT NULL
	) AS [B] 
	CROSS JOIN (
		SELECT
			COUNT(*) AS [GrandTotalCancellations]
		FROM
			[v_SFC_OrdersData]
		WHERE
			[Date Declined] IS NOT NULL
	) AS [C] 
	CROSS JOIN (
		SELECT
			COUNT(*) AS [GrandTotalOutQuotes]
		FROM
			[v_SFC_OrdersData]
		WHERE
			[Date Declined] IS NOT NULL
			AND [QuoteOrderDate] IS NULL
	) AS [D] 
	GROUP BY
		[Sale PersonID]
		,[Sales Person]
		,[GrandTotalQuotes]
		,[GrandTotalOrders]
		,[GrandTotalCancellations]
		,[GrandTotalOutQuotes]
		--,[DateDeclined] IS NULL
) AS [Src]
;

SELECT
	[Sale PersonID]
	,[Sales Person]
	,COUNT(*) AS [Total]
	,DATEDIFF(DAY, [Quote Date], GETDATE()) / 365 AS [YearsAgo]
	--,[Quote Date]
	,MIN([Quote Date]) AS [FirstQuote]
	,MAX([Quote Date]) AS [LastQuote]
	,SUM(CASE WHEN [Date Declined] IS NULL THEN 0 ELSE 1 END) AS [NumCancelled]
	,SUM([ProductsPrice]) AS [TotalProductsPrice]
	,SUM([OrderPrice]) AS [TotalOrderPrice]
	,SUM(CASE WHEN [Date Declined] IS NULL THEN [OrderPrice] ELSE 0 END) AS [TotalOrderedPrice]
FROM
	[v_SFC_OrdersData]
WHERE
	[Sale PersonID] IS NOT NULL
	AND [Quote Date] IS NOT NULL
GROUP BY
	[Sale PersonID]
	,[Sales Person]
	--,[Quote Date]
	,DATEDIFF(DAY, [Quote Date], GETDATE()) / 365
	--,[DateDeclined] IS NULL
ORDER BY
	[Sales Person]
	,[YearsAgo]
;


-- By Model
SELECT
	[Model No]
	--,[Quote]
	--,[WONum]
	,[Sale PersonID]
	,[Sales Person]
	,COUNT(*) AS [Total]
	,DATEDIFF(DAY, [Quote Date], GETDATE()) / 365 AS [YearsAgo]
	--,[Quote Date]
	,MIN([Quote Date]) AS [FirstQuote]
	,MAX([Quote Date]) AS [LastQuote]
	,SUM(CASE WHEN [Date Declined] IS NULL THEN 0 ELSE 1 END) AS [NumCancelled]
	,SUM([ProductsPrice]) AS [TotalProductsPrice]
	,SUM([OrderPrice]) AS [TotalOrderPrice]
	,SUM(CASE WHEN [Date Declined] IS NULL THEN [OrderPrice] ELSE 0 END) AS [TotalOrderedPrice]
FROM
	[v_SFC_OrdersData] AS [S]
--INNER JOIN
--	[v_SFC_OrdersDataOptions] AS [O]
--ON
--	[S].[Quote] = [O].[Quote]
WHERE
	[Sale PersonID] IS NOT NULL
	AND [Quote Date] IS NOT NULL
GROUP BY
	[Sale PersonID]
	,[Sales Person]
	,[Model No]
	--,[Quote]
	--,[WONum]
	--,[Quote Date]
	,DATEDIFF(DAY, [Quote Date], GETDATE()) / 365
	--,[DateDeclined] IS NULL
ORDER BY
	[Sales Person]
	,[YearsAgo]
	,[Model No]
	--,[WONum]
;


-- By Model with Option Counts
SELECT
	[S].[Model No]
	--,[Quote]
	--,[WONum]
	,[S].[Sale PersonID]
	,[S].[Sales Person]
	,COUNT(*) AS [Total]
	,DATEDIFF(DAY, [S].[Quote Date], GETDATE()) / 365 AS [YearsAgo]
	--,[Quote Date]
	,MIN([S].[Quote Date]) AS [FirstQuote]
	,MAX([S].[Quote Date]) AS [LastQuote]
	,SUM(CASE WHEN [S].[Date Declined] IS NULL THEN 0 ELSE 1 END) AS [NumCancelled]
	,SUM([S].[ProductsPrice]) AS [TotalProductsPrice]
	,SUM([S].[OrderPrice]) AS [TotalOrderPrice]
	,SUM(CASE WHEN [S].[Date Declined] IS NULL THEN [S].[OrderPrice] ELSE 0 END) AS [TotalOrderedPrice]
	,SUM([O].[OptionPrice]) AS [TotalOptionPrice]
	,SUM([O].[NPOPrice]) AS [TotalNPOPrice]
FROM
	[v_SFC_OrdersData] AS [S]
INNER JOIN
	[v_SFC_OrdersDataOptions] AS [O]
ON
	[S].[Quote] = [O].[Quote]
WHERE
	[S].[Sale PersonID] IS NOT NULL
	AND [S].[Quote Date] IS NOT NULL
GROUP BY
	[S].[Sale PersonID]
	,[S].[Sales Person]
	,[S].[Model No]
	--,[Quote]
	--,[WONum]
	--,[Quote Date]
	,DATEDIFF(DAY, [S].[Quote Date], GETDATE()) / 365
	--,[DateDeclined] IS NULL
ORDER BY
	[S].[Sales Person]
	,[YearsAgo]
	,[S].[Model No]
	--,[WONum]
;