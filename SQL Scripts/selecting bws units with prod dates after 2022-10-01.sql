USE BWSdb
GO

SELECT 
	[Orders].[Quote#]
	, [Orders].[WO#]
	, [Stargate WO#]
	, [InputField1] AS [Model Name]
	, [InputField2] AS [Dealer Name]
	, ISNULL([Prod Date 1], [Prod Date 2]) AS [Prod Date]
	, [Serial Number]
FROM [dtProductionSchedule]
LEFT OUTER JOIN
	[Orders]
ON
	[dtProductionSchedule].[Quote#] = [Orders].[Quote#]

WHERE ISNULL([Prod Date 1], [Prod Date 2]) IS NOT NULL AND ISNULL([Prod Date 1], [Prod Date 2]) >= '2022-10-01'
ORDER BY
	[Prod Date]
	, [Quote#]