

USE [SysproCompanyS]
GO


SELECT
	0 AS [Code],
	'Not Started' AS [Desc]
UNION ALL
SELECT
	1 AS [Code],
	'In Progress' AS [Desc]
UNION ALL
SELECT
	2 AS [Code],
	'Complete' AS [Desc]

-- ====================================
-- Operation Status values:
-- 0 - Not Started
-- 1 - In Progress ("CURRENT OPERATION" check mark legend from Vishal's "WORKFLOW STARGATE" spreadsheet)
-- 2 - Complete ("COMPLETED OPERATION" check mark legend from Vishal's "WORKFLOW STARGATE" spreadsheet)
-- ====================================

SELECT
	[Job]
    , [JobDescription]
    , [Model No]
    , [COMPANY NAME]
    , [JobDeliveryDate]
	, [Operation1Status]
	, [Operation2Status]
	, [Operation3Status]
	, [Operation4Status]
	, [Operation5Status]
	, [Operation6Status]
	, [Operation7Status]
	, [Operation8Status]
	, [Operation9Status]
	, [Operation10Status]
	, [Operation11Status]
	, [Operation12Status]
	, [Operation13Status]
	, [Operation14Status]
	, [Operation15Status]
	, [Operation16Status]
	, [Operation17Status]
	, [Operation18Status]
	, [Operation19Status]
	, SUM(
		(CASE WHEN ISNULL([Operation1Status], 0) = 2 THEN 1 WHEN [Operation1Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation2Status], 0) = 2 THEN 1 WHEN [Operation2Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation3Status], 0) = 2 THEN 1 WHEN [Operation3Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation4Status], 0) = 2 THEN 1 WHEN [Operation4Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation5Status], 0) = 2 THEN 1 WHEN [Operation5Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation6Status], 0) = 2 THEN 1 WHEN [Operation6Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation7Status], 0) = 2 THEN 1 WHEN [Operation7Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation8Status], 0) = 2 THEN 1 WHEN [Operation8Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation9Status], 0) = 2 THEN 1 WHEN [Operation9Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation10Status], 0) = 2 THEN 1 WHEN [Operation10Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation11Status], 0) = 2 THEN 1 WHEN [Operation11Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation12Status], 0) = 2 THEN 1 WHEN [Operation12Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation13Status], 0) = 2 THEN 1 WHEN [Operation13Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation14Status], 0) = 2 THEN 1 WHEN [Operation14Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation15Status], 0) = 2 THEN 1 WHEN [Operation15Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation16Status], 0) = 2 THEN 1 WHEN [Operation16Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation17Status], 0) = 2 THEN 1 WHEN [Operation17Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation18Status], 0) = 2 THEN 1 WHEN [Operation18Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation19Status], 0) = 2 THEN 1 WHEN [Operation19Status] = 1 THEN 0.5 ELSE 0 END)
	) AS [ProgressOps]
	, 19 AS [TotalOps]
FROM (
	SELECT
		[Job]
		, [JobDescription]
		, [OrdersV2].[Model No]
		, [DealersV2].[COMPANY NAME]
		, [JobDeliveryDate]
		, MAX(CASE WHEN [Operation] = 1 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 1 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 1 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation1Status]
		, MAX(CASE WHEN [Operation] = 2 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 2 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 2 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation2Status]
		, MAX(CASE WHEN [Operation] = 3 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 3 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 3 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation3Status]
		, MAX(CASE WHEN [Operation] = 4 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 4 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 4 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation4Status]
		, MAX(CASE WHEN [Operation] = 5 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 5 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 5 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation5Status]
		, MAX(CASE WHEN [Operation] = 6 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 6 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 6 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation6Status]
		, MAX(CASE WHEN [Operation] = 7 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 7 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 7 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation7Status]
		, MAX(CASE WHEN [Operation] = 8 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 8 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 8 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation8Status]
		, MAX(CASE WHEN [Operation] = 9 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 9 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 9 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation9Status]
		, MAX(CASE WHEN [Operation] = 10 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 10 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 10 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation10Status]
		, MAX(CASE WHEN [Operation] = 11 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 11 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 11 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation11Status]
		, MAX(CASE WHEN [Operation] = 12 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 12 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 12 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation12Status]
		, MAX(CASE WHEN [Operation] = 13 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 13 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 13 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation13Status]
		, MAX(CASE WHEN [Operation] = 14 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 14 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 14 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation14Status]
		, MAX(CASE WHEN [Operation] = 15 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 15 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 15 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation15Status]
		, MAX(CASE WHEN [Operation] = 16 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 16 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 16 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation16Status]
		, MAX(CASE WHEN [Operation] = 17 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 17 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 17 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation17Status]
		, MAX(CASE WHEN [Operation] = 18 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 18 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 18 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation18Status]
		, MAX(CASE WHEN [Operation] = 19 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 19 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 19 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation19Status]
	FROM
		(
			SELECT [WipMaster].[Job]
				, [WipMaster].[JobDescription]
				, [WipMaster].[JobDeliveryDate]
				, [WipJobAllLab].[Operation]
				, [WipJobAllLab].[RunTimeIssued]
				, [subClkTransactionCount].[numInProgressTransaction]
				, [WipJobAllLab].[OperCompleted]
				, [subClkTransactionCount].[numCompleteTransaction]
			FROM
				[WipJobAllLab] WITH (NOLOCK)
			INNER JOIN
				[WipMaster] WITH (NOLOCK)
			ON
				[WipJobAllLab].[Job] = [WipMaster].[Job]
			LEFT OUTER JOIN
				(
					SELECT [JobNumber]
						, [Operation]
						, COUNT(CASE WHEN [OperationComplete] = 0 THEN [TransactionID] END) AS [numInProgressTransaction]
						, COUNT(CASE WHEN [OperationComplete] = 1 THEN [TransactionID] END) AS [numCompleteTransaction]
					FROM
						[ClkTransaction] WITH (NOLOCK)
					WHERE
						[JobNumber] <> ''
					GROUP BY
						[JobNumber]
						, [Operation]
				) AS [subClkTransactionCount]
			ON
				[WipJobAllLab].[Job] = [subClkTransactionCount].[JobNumber]
				AND [WipJobAllLab].[Operation] = [subClkTransactionCount].[Operation]
			WHERE
				[ActCompleteDate] IS NULL
		) AS [mainsub]
	INNER JOIN
		[BWSdb].[dbo].[OrdersV2] WITH (NOLOCK)
	ON
		[mainsub].[Job] = CAST([OrdersV2].[WO#] AS VARCHAR(20))
	INNER JOIN
		[BWSdb].[dbo].[DealersV2] WITH (NOLOCK)
	ON
		[OrdersV2].[DealerID] = [DealersV2].[ID]
	GROUP BY
		[Job]
		, [JobDescription]
		, [OrdersV2].[Model No]
		, [DealersV2].[COMPANY NAME]
		, [JobDeliveryDate]
) AS [Src]
GROUP BY
	[Job]
    , [JobDescription]
    , [Model No]
    , [COMPANY NAME]
    , [JobDeliveryDate]
	, [Operation1Status]
	, [Operation2Status]
	, [Operation3Status]
	, [Operation4Status]
	, [Operation5Status]
	, [Operation6Status]
	, [Operation7Status]
	, [Operation8Status]
	, [Operation9Status]
	, [Operation10Status]
	, [Operation11Status]
	, [Operation12Status]
	, [Operation13Status]
	, [Operation14Status]
	, [Operation15Status]
	, [Operation16Status]
	, [Operation17Status]
	, [Operation18Status]
	, [Operation19Status]