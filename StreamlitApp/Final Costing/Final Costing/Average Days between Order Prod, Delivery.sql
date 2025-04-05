-- Average Days between Order Prod, Delivery

SELECT
	[P].[Model No] AS [ModelNo]
	, [O].[Order Date] AS [DateOrder]
	, ISNULL([PD].[Prod Date], [PD].[Prod Date2]) AS [DateProd]
	, [O].[Delivery Date] AS [DateDelivery]
	, DATEDIFF(DAY, [O].[Order Date], [O].[Delivery Date]) AS [NDaysOrder2Delivery]
FROM
	[BWSdb].[dbo].[Orders] [O]
INNER JOIN
	[BWSdb].[dbo].[Products] [P]
ON
	[O].[ProductID] = [P].[IDTrailer]
LEFT JOIN
	[BWSdb].[dbo].[Production] [PD]
ON
	[O].[Quote#] = [PD].[Quote#]
WHERE		
	([O].[Decline/Rejected] = 4)
	AND ([O].[Date Declined] IS NULL)
	AND ([P].[Non-Current] = 0)
	AND ([P].[Proposed] = 0)



--------------------------------------------------------

SELECT
	[ModelGroup],
	[ModelClass],
	[ModelNo],
	COUNT(*) AS [NOrders],
	AVG([NDaysOrder2Delivery]) AS [AvgNDaysOrder2Delivery],
	AVG([NDaysOrder2Prod]) AS [AvgNDaysOrder2Prod],
	AVG([NDaysProd2Delivery]) AS [AvgNDaysProd2Delivery],
	MIN([DateOrder]) AS [FirstDateOrder],
	MAX([DateOrder]) AS [LastDateOrder],
	MIN([DateProd]) AS [FirstDateProd],
	MAX([DateProd]) AS [LastDateProd],
	MIN([DateDelivery]) AS [FirstDateDelivery],
	MAX([DateDelivery]) AS [LastDateDelivery]
FROM (
	SELECT
		[P].[Grouping] AS [ModelGroup]
		, [P].[Class] AS [ModelClass]
		, [P].[Model No] AS [ModelNo]
		, [O].[Order Date] AS [DateOrder]
		, ISNULL([PD].[Prod Date], [PD].[Prod Date2]) AS [DateProd]
		, [O].[Delivery Date] AS [DateDelivery]
		, DATEDIFF(DAY, [O].[Order Date], [O].[Delivery Date]) AS [NDaysOrder2Delivery]
		, DATEDIFF(DAY, [O].[Order Date], ISNULL([PD].[Prod Date], [PD].[Prod Date2])) AS [NDaysOrder2Prod]
		, DATEDIFF(DAY, ISNULL([PD].[Prod Date], [PD].[Prod Date2]), [O].[Delivery Date]) AS [NDaysProd2Delivery]
	FROM
		[BWSdb].[dbo].[Orders] [O]
	INNER JOIN
		[BWSdb].[dbo].[Products] [P]
	ON
		[O].[ProductID] = [P].[IDTrailer]
	LEFT JOIN
		[BWSdb].[dbo].[Production] [PD]
	ON
		[O].[Quote#] = [PD].[Quote#]
	WHERE
		([O].[Decline/Rejected] = 4)
		AND ([O].[Date Declined] IS NULL)
		AND ([P].[Non-Current] = 0)
		AND ([P].[Proposed] = 0)
) AS [Src]
GROUP BY
	[ModelGroup],
	[ModelClass],
	[ModelNo]
