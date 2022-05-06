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