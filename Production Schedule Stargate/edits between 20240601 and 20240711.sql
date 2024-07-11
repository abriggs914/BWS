/*
SELECT
	[SGQuote]
	,[WO#]
	,[Available Date]
	,[JobAvailableLine]
	,[JobAvailableScheduled]
	,[JobAvailableScheduledBy]
FROM
	[BWSdb].[dbo].[OrdersV2]
WHERE
	[JobAvailableScheduled] BETWEEN '2024-07-01' AND '2024-07-31'
*/

SELECT
	[A].[SGQuote]
	,[A].[WO#]
	,[A].[JobAvailableLine] AS [NewLine]
	,[B].[JobAvailableLine] AS [OldLine]
	,[A].[Available Date] AS [NewDate]
	,[B].[Available Date] AS [OldDate]
	,[A].[JobAvailableScheduled] AS [Latest Scheduled Date]
	,[B].[JobAvailableScheduled] AS [Old Scheduled Date]
	,[A].[JobAvailableScheduledBy] AS [Latest Scheduled By]
	,[B].[JobAvailableScheduledBy] AS [Old Scheduled By]
FROM (
	SELECT
		[SGQuote]
		,[WO#]
		,[Available Date]
		,[JobAvailableLine]
		,[JobAvailableScheduled]
		,[JobAvailableScheduledBy]
	FROM
		[BWSdb_20240709].[dbo].[OrdersV2]
	WHERE
		[JobAvailableScheduled] BETWEEN '2024-06-01' AND '2024-07-31'
) AS [B]
INNER JOIN (
	SELECT
		[SGQuote]
		,[WO#]
		,[Available Date]
		,[JobAvailableLine]
		,[JobAvailableScheduled]
		,[JobAvailableScheduledBy]
	FROM
		[BWSdb].[dbo].[OrdersV2]
	WHERE
		[JobAvailableScheduled] BETWEEN '2024-06-01' AND '2024-07-31'
) AS [A]
ON
	[A].[SGQuote] = [B].[SGQuote]
WHERE
	([A].[JobAvailableLine] <> [B].[JobAvailableLine])
	OR ([A].[Available Date] <> [B].[Available Date])
	OR ([A].[JobAvailableScheduled] <> [B].[JobAvailableScheduled])
	OR ([A].[JobAvailableScheduledBy] <> [B].[JobAvailableScheduledBy])