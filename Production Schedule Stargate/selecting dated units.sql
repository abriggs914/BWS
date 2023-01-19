


-- Final Select Query for all STG Prod dates

SELECT

	[OrdersV2].[SGQuote]
	, [OrdersV2].[WO#]
	, [Available Date]
	, [Finish Date]
	, [JobFinishDate]
	, [dtProductionSchedule].[WO Line 1]
	, [dtProductionSchedule].[WO Line 2]
	, [dtProductionScheduleV2].[JobStartLine]

	, [dtProductionSchedule].*
	, [dtProductionScheduleV2].*
	, [OrdersV2].*
FROM
	[BWSdb].[dbo].[OrdersV2]
LEFT JOIN 
	[Stargatedb].[dbo].[dtProductionSchedule]
ON
	[dtProductionSchedule].[SGQuote] = [OrdersV2].[SGQuote]
LEFT JOIN 
	[Stargatedb].[dbo].[dtProductionScheduleV2]
ON
	[dtProductionScheduleV2].[SGQuote] = [OrdersV2].[SGQuote]
WHERE
	[dtProductionScheduleV2].[JobFinishDate] IS NOT NULL
ORDER BY
	[dtProductionScheduleV2].[JobFinishDate]
;


-- Final Select Query for all STG Prod dates

SELECT
	
	[OrdersV2].[SGQuote]
	, [OrdersV2].[WO#]
	, [Model No]
	, [Available Date]
	, [Finish Date]
	, [JobFinishDate]
	, [dtProductionSchedule].[WO Line 1]
	, [dtProductionSchedule].[WO Line 2]
	, [dtProductionScheduleV2].[JobStartLine]

	--, [dtProductionSchedule].*
	--, [dtProductionScheduleV2].*
	--, [OrdersV2].*
FROM
	[BWSdb].[dbo].[OrdersV2]
LEFT JOIN 
	[Stargatedb].[dbo].[dtProductionSchedule]
ON
	[dtProductionSchedule].[SGQuote] = [OrdersV2].[SGQuote]
LEFT JOIN 
	[Stargatedb].[dbo].[dtProductionScheduleV2]
ON
	[dtProductionScheduleV2].[SGQuote] = [OrdersV2].[SGQuote]
WHERE
	ISNULL(ISNULL([dtProductionScheduleV2].[JobFinishDate], [Available Date]), [Finish Date]) IS NOT NULL
ORDER BY
	[dtProductionScheduleV2].[JobFinishDate]
;


