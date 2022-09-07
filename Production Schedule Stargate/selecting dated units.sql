


-- Final Select Query for all STG Prod dates

SELECT
	[dtProductionSchedule].*
	, [dtProductionScheduleV2].*
	, [OrdersV2].*
FROM
	[BWSdb].[dbo].[OrdersV2]
LEFT JOIN 
	[dtProductionSchedule]
ON
	[dtProductionSchedule].[SGQuote] = [OrdersV2].[SGQuote]
LEFT JOIN 
	[dtProductionScheduleV2]
ON
	[dtProductionScheduleV2].[SGQuote] = [OrdersV2].[SGQuote]
WHERE
	[dtProductionScheduleV2].[JobFinishDate] IS NOT NULL
ORDER BY
	[dtProductionScheduleV2].[JobFinishDate]
;

