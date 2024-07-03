USE BWSdb
GO

SELECT
	[Available Date]
	,[JobFinishDate]
	,[JobAvailableLine]
	,[JobStartLine]
	,[JobAvailableScheduled]
	,[JobAvailableScheduledBy]
	,*
FROM
	[OrdersV2] [O2]
FULL OUTER JOIN
	[Stargatedb].[dbo].[dtProductionScheduleV2] [PS2]
ON
	[O2].[SGQuote] = [PS2].[SGQuote]
WHERE
	[O2].[SGQuote] IN (
		'SG101666'
	)
	OR (
		([O2].[Available Date] <> [PS2].[JobFinishDate])
		OR ([O2].[JobAvailableLine] <> [PS2].[JobStartLine])
	)
ORDER BY
	[O2].[Quote Date] DESC
