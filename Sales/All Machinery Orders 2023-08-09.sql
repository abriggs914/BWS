USE BWSdb
GO


-- All Machinery
-- WO, Dealer, Model NO, Quote#, Serial
-- Not delivered, but ordered


SELECT
	*
FROM
	[Orders] AS [O]
LEFT JOIN
	[Products] AS [P]
ON
	[O].[Model No] = [P].[Model No]
WHERE
	[P].[Class] LIKE '%Machine%'
	AND ISNULL([Delivery Date], GETDATE()) >= GETDATE()
	AND	[Date Declined] IS NULL
	AND [Order Date] IS NOT NULL
	AND [Quote Date] IS NOT NULL
	AND [Sales Order#] IS NOT NULL
	AND [WO#] NOT IN (10011847, 50000158)
ORDER BY
	[Order Date]

	

SELECT
	*
FROM
	[Products] AS [P]
ORDER BY
	[Model No]

SELECT
	*
FROM
	[Orders] AS [O]
WHERE
	[ProductID] IS NULL


SELECT
	[Quote#]
	,[WO#]
	,[O].[Model No]
	,[COMPANY NAME]
	,[Serial Number]
	,[Delivery Date]
	,[Order Date]
FROM
	[Orders] AS [O]
LEFT JOIN
	[Products] AS [P]
ON
	[O].[ProductID] = [P].[IDTrailer]
LEFT JOIN
	[Dealers] AS [D]
ON
	[O].[DealerID] = [D].[ID]
WHERE
	[P].[Class] LIKE '%Machine%'
	AND ISNULL([Delivery Date], GETDATE()) >= GETDATE()
	AND	[Date Declined] IS NULL
	AND [Order Date] IS NOT NULL
	AND [Quote Date] IS NOT NULL
	AND [Sales Order#] IS NOT NULL
	AND [WO#] NOT IN (10011847, 50000158)
ORDER BY
	[Order Date]