USE Stargatedb
GO


SELECT
	[Prod Date 1]
	, [Prod Date 2]
	, [OrdersV2].*
FROM
	[BWSdb].[dbo].[OrdersV2]
LEFT JOIN 
	[dtProductionSchedule]
ON
	[dtProductionSchedule].[SGQuote] = [OrdersV2].[SGQuote]
WHERE
	ISNULL([dtProductionSchedule].[Prod Complete], [dtProductionSchedule].[Prod2 Complete]) IS NOT NULL
ORDER BY
	ISNULL([dtProductionSchedule].[Prod Date 1], [dtProductionSchedule].[Prod Date 2])
;

SELECT
	[Prod Date 1]
	, [Prod Date 2]
	, [OrdersV2].*
FROM
	[BWSdb].[dbo].[OrdersV2]
LEFT JOIN 
	[dtProductionSchedule]
ON
	[dtProductionSchedule].[SGQuote] = [OrdersV2].[SGQuote]
WHERE
	ISNULL([dtProductionSchedule].[Prod Date 1], [dtProductionSchedule].[Prod Date 2]) IS NOT NULL
ORDER BY
	ISNULL([dtProductionSchedule].[Prod Date 1], [dtProductionSchedule].[Prod Date 2])
;

SELECT
	[JobFinishDate]
	, [OrdersV2].*
FROM
	[BWSdb].[dbo].[OrdersV2]
LEFT JOIN 
	[dtProductionScheduleV2]
ON
	[dtProductionScheduleV2].[SGQuote] = [OrdersV2].[SGQuote]
WHERE
	[dtProductionScheduleV2].[JobFinishDate] IS NOT NULL
ORDER BY
	[dtProductionScheduleV2].[JobFinishDate]
;

SELECT
	[OrdersV2].*
FROM
	[BWSdb].[dbo].[OrdersV2]
LEFT JOIN 
	[dtProductionScheduleV2]
ON
	[dtProductionScheduleV2].[SGQuote] = [OrdersV2].[SGQuote]
WHERE
	[Finish Date] IS NOT NULL
ORDER BY
	[Finish Date]
;
