USE BWSdb
GO


SELECT
	*
FROM 
	[Orders]
LEFT JOIN
	[Production]
ON
	[Orders].[WO#] = [Production].[WO#]
WHERE
	[Orders].[Order Date] IS NOT NULL
	AND [Date Declined] IS NULL
	AND	[Production].[WO#] IS NULL

