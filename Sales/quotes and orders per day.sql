SELECT
	[Cal].[Date]
	,[Cal].[HolidayName]
	,SUM([NumNewQuotesBWS]) AS [NumNewQuotesBWS]
	,SUM([NumNewOrdersBWS]) AS [NumNewOrdersBWS]
	,MIN([FirstQuoteBWS]) AS [FirstQuoteBWS]
	,MAX([LastQuoteBWS]) AS [LastQuoteBWS]
	,SUM([FirstWOBWS]) AS [FirstWOBWS]
	,SUM([LastWOBWS]) AS [LastWOBWS]

	,SUM([NumNewQuotesSTG]) AS [NumNewQuotesSTG]
	,SUM([NumNewOrdersSTG]) AS [NumNewOrdersSTG]
	,MIN([FirstQuoteSTG]) AS [FirstQuoteSTG]
	,MAX([LastQuoteSTG]) AS [LastQuoteSTG]
	,SUM([FirstWOSTG]) AS [FirstWOSTG]
	,SUM([LastWOSTG]) AS [LastWOSTG]
	
	,SUM([NumNewQuotesBWS]) + SUM([NumNewQuotesSTG]) AS [TotalNewQuotes]
	,SUM([NumNewOrdersBWS]) + SUM([NumNewOrdersSTG]) AS [TotalNewOrders]
FROM
	[BWSdb].[dbo].[Calendar] [Cal] WITH (NOLOCK)
LEFT JOIN (
	SELECT
		[Quote Date]
		,COUNT([Quote Date]) AS [NumNewQuotesBWS]
		,COUNT([Order Date]) AS [NumNewOrdersBWS]
		,MIN([Quote#]) AS [FirstQuoteBWS]
		,MAX([Quote#]) AS [LastQuoteBWS]
		,MIN([WO#]) AS [FirstWOBWS]
		,MAX([WO#]) AS [LastWOBWS]

		,NULL AS [NumNewQuotesSTG]
		,NULL AS [NumNewOrdersSTG]
		,NULL AS [FirstQuoteSTG]
		,NULL AS [LastQuoteSTG]
		,NULL AS [FirstWOSTG]
		,NULL AS [LastWOSTG]
	FROM
		[BWSdb].[dbo].[Orders] WITH (NOLOCK)
	GROUP BY
		[Quote Date]

	UNION ALL

	SELECT
		[Quote Date]
		,NULL AS [NumNewQuotesBWS]
		,NULL AS [NumNewOrdersBWS]
		,NULL AS [FirstQuoteBWS]
		,NULL AS [LastQuoteBWS]
		,NULL AS [FirstWOBWS]
		,NULL AS [LastWOBWS]

		,COUNT([Quote Date]) AS [NumNewQuotesSTG]
		,COUNT([Order Date]) AS [NumNewOrdersSTG]
		,MIN(CAST(RIGHT([SGQuote], LEN([SGQuote]) - 2) AS INT)) AS [FirstQuoteSTG]
		,MAX(CAST(RIGHT([SGQuote], LEN([SGQuote]) - 2) AS INT)) AS [LastQuoteSTG]
		,MIN([WO#]) AS [FirstWOSTG]
		,MAX([WO#]) AS [LastWOSTG]
	FROM
		[BWSdb].[dbo].[OrdersV2] WITH (NOLOCK)
	GROUP BY
		[Quote Date]

) AS [OrderSrc]
ON
	[Cal].[Date] = [OrderSrc].[Quote Date]
WHERE
	[Cal].[Date] BETWEEN '2006-01-01' AND DATEADD(YEAR, 2, GETDATE())
GROUP BY
	[Cal].[Date]
	,[Cal].[HolidayName]
ORDER BY
	[Cal].[Date]
;


	SELECT
		[Quote Date]
		,COUNT([Quote Date]) AS [NumNewQuotes]
		,COUNT([Order Date]) AS [NumNewOrders]
		,MIN([Quote#]) AS [FirstQuote]
		,MAX([Quote#]) AS [LastQuote]
		,MIN([WO#]) AS [FirstWO]
		,MAX([WO#]) AS [LastWO]
	FROM
		[BWSdb].[dbo].[Orders]
	GROUP BY
		[Quote Date]
	ORDER BY
		[Quote Date]