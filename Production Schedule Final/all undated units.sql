USE BWSdb
GO

SELECT
	[dtProductionSchedule].[WO#],
	[dtProductionSchedule].[Quote#],
	[Prod Date 1],
	[Prod Date 2],
	[Date Declined]
FROM
	[dtProductionSchedule]
LEFT JOIN
	[Orders]
ON
	[dtProductionSchedule].[Quote#] = [Orders].[Quote#]
WHERE
	[Prod Date 1] IS NULL
	AND [Prod Date 2] IS NULL
	--AND [dtProductionSchedule].[WO#] IS NULL
	AND [Orders].[Date Declined] IS NULL
	--AND [Orders].[Decline/Rejected] IS NULL
	AND [dtProductionSchedule].[Quote#] IS NOT NULL
ORDER BY
	[WO#],
	[Quote#]


	
SELECT
	--(CASE WHEN [WO#] IS NULL THEN ELSE END)
	--ISNULL([dtProductionSchedule].[WO#], [dtProductionSchedule].[Quote#]) AS [WO],
	[dtProductionSchedule].[WO#],
	[dtProductionSchedule].[Quote#]
	--[Prod Date 1],
	--[Prod Date 2],
	--[Date Declined]
FROM
	[dtProductionSchedule]
LEFT JOIN
	[Orders]
ON
	[dtProductionSchedule].[Quote#] = [Orders].[Quote#]
WHERE
	[Prod Date 1] IS NULL
	AND [Prod Date 2] IS NULL
	--AND [dtProductionSchedule].[WO#] IS NULL
	AND [Orders].[Date Declined] IS NULL
	--AND [Orders].[Decline/Rejected] IS NULL
	AND [dtProductionSchedule].[Quote#] IS NOT NULL
ORDER BY
	[Quote#]


SELECT
	--(CASE WHEN [WO#] IS NULL THEN ELSE END)
	--ISNULL([dtProductionSchedule].[WO#], [dtProductionSchedule].[Quote#]) AS [WO],
	--[dtProductionSchedule].[WO#],
	ISNULL([dtProductionSchedule].[WO#], [dtProductionSchedule].[Quote#]) AS [WO/SLOT/QUOTE]
	, [Dealers].[COMPANY NAME]
	, [Model No]
	, (CASE WHEN [Orders].CustID IS NOT NULL AND Customer <> 'stock' THEN 'SOLD' ELSE 'STOCK' END) AS [Stock/Sold]
	, [Beam Date]
	, (CASE WHEN 
		[Prod Date 1] IS NULL AND [Prod Date 2] IS NULL THEN NULL
		WHEN [Prod Date 1] IS NULL THEN [Prod Date 2]
		WHEN [Prod Date 2] IS NULL THEN [Prod Date 1]
		WHEN [Prod Date 1] <= [Prod Date 1] THEN [Prod Date 1] ELSE [Prod Date 2] END) AS [JobStartDate]
	--[Prod Date 1],
	--[Prod Date 2],
	--[Date Declined]
FROM
	[dtProductionSchedule]
LEFT JOIN
	[Orders]
ON
	[dtProductionSchedule].[Quote#] = [Orders].[Quote#]
LEFT JOIN
	[Dealers]
ON
	[Orders].[DealerID] = [Dealers].[ID]
LEFT JOIN
	[Customers]
ON
	[Customers].[ID#] = [Orders].[CustID]
WHERE
	[Prod Date 1] IS NULL
	AND [Prod Date 2] IS NULL
	--AND [dtProductionSchedule].[WO#] IS NULL
	AND [Orders].[Date Declined] IS NULL
	--AND [Orders].[Decline/Rejected] IS NULL
	AND [dtProductionSchedule].[Quote#] IS NOT NULL
ORDER BY
	[dtProductionSchedule].[Quote#]