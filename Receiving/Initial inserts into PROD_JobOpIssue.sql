USE [BWSdb];
GO

-- 2025-09-23 14:52 - Avery Briggs - Initial inserts into [BWSdb].[dbo].[PROD_JobOpIssue].
--  Ensures that only new records are added.

BEGIN TRAN;

	INSERT INTO [dbo].[PROD_JobOpIssue] (
		Active
		, Job
		, Operation
	)
	SELECT DISTINCT
		1 AS [Active]
		, [WM].[Job]
		, [WM].[OperationOffset] AS [Operation]
	FROM 
		[SysproCompanyA].[dbo].[WipJobAllMat] [WM]
	LEFT JOIN (
		-- Pre-aggregate issues per Job/Op/Stock
		SELECT 
			[Job]
			, [LOperation] AS [OperationOffset]
			, SUM([MQtyIssued]) AS [QtyIssued]
		FROM
			[SysproCompanyA].[dbo].[WipJobPost]
		GROUP BY
			[Job],
			[LOperation]
	) AS [WP]
	ON
		([WM].[Job] = [WP].[Job])
		AND ([WM].[OperationOffset] = [WP].[OperationOffset])
	LEFT JOIN
		[SysproCompanyA].[dbo].[WipMaster] [Mast]
	ON
		[WM].[Job] = [Mast].[Job]
	WHERE
		-- Not completely issued
		(ISNULL([WM].[UnitQtyReqd], 0) > ISNULL([WP].[QtyIssued], 0)
			OR ISNULL([WM].[AllocCompleted], 'N') = 'N')
		AND ([ActCompleteDate] IS NULL)
		-- Prevent duplicates
		AND NOT EXISTS (
			SELECT
				1
			FROM 
				[BWSdb].[dbo].[PROD_JobOpIssue] [T]
			WHERE
				([T].[Job] COLLATE DATABASE_DEFAULT = [WM].[Job] COLLATE DATABASE_DEFAULT)
				AND ([T].[Operation] = [WM].[OperationOffset])
		)
	ORDER BY
		[Job],
		[Operation]

ROLLBACK;
COMMIT;