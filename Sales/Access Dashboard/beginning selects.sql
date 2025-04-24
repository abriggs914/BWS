-- Sales Dashboard
-- 2025-04-21

-- Invalid Serials
-- Open Quotes
-- Delayed Quotes
-- Sales Figues


--SELECT
--	'Invalid Quotes' AS [Table],
--	NULL AS [Comp],
--	NULL AS [Serial Number]
--UNION
SELECT
	'Invalid Quotes' AS [Table],
	'STG' AS [Comp],
	[O].[Serial Number] AS [Serial Number]
FROM (
	SELECT
		RIGHT([Serial Number], 8) AS [Right8]
	FROM
		[BWSdb].[dbo].[OrdersV2] [O]
	WHERE
		([O].[Serial Number] IS NOT NULL)
		AND ([O].[Decline/Rejected] IS NULL)
	GROUP BY
		RIGHT([Serial Number], 8)
	HAVING 
		COUNT(*) > 1
) AS [Src]
INNER JOIN
	[BWSdb].[dbo].[OrdersV2] [O]
ON
	[Src].[Right8] = RIGHT([O].[Serial Number], 8)
UNION
SELECT
	'Invalid Quotes',
	'BWS',
	[O].[Serial Number]
FROM (
	SELECT
		RIGHT([Serial Number], 8) AS [Right8]
	FROM
		[BWSdb].[dbo].[Orders] [O]
	WHERE
		([O].[Serial Number] IS NOT NULL)
		AND ([O].[Decline/Rejected] IS NULL)
	GROUP BY
		RIGHT([Serial Number], 8)
	HAVING 
		COUNT(*) > 1
) AS [Src]
INNER JOIN
	[BWSdb].[dbo].[Orders] [O]
ON
	[Src].[Right8] = RIGHT([O].[Serial Number], 8)


SELECT
	*
FROM
	[BWSdb].[dbo].[Orders] [O]
WHERE
	([O].[Delivery Date] IS NULL) 
	AND ([O].[Date Declined] IS NULL)