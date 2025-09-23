SELECT
	*
FROM
	[BWSdb].[dbo].[PROD_JobOpIssue] [JOI]
INNER JOIN
	[SysproCompanyA].[dbo].[WipJobAllMat] [WM]
ON
	([JOI].[Job] = [WM].[Job] COLLATE DATABASE_DEFAULT)
	AND ([JOI].[Operation] = [WM].[OperationOffset])
WHERE
	[JOI].[FirstIssued] IS NOT NULL
;

SELECT
	*
FROM
	[BWSdb].[dbo].[PROD_JobOpIssue] [JOI]
WHERE
	[JOI].[FirstIssued] IS NOT NULL
;
SELECT
	*
FROM
	[BWSdb].[dbo].[PROD_JobOpIssue]
;
SELECT
	*
FROM
	[BWSdb].[dbo].[hist_PROD_JobOpIssue]
ORDER BY
	[ID] DESC
;

SELECT
	DATEADD(MINUTE, (LTrnTime % 100), 
                DATEADD(HOUR,  FLOOR(LTrnTime / 100), CAST(TrnDate AS DATETIME))) AS [TrnDatetime],
	[LOperation],
	*
FROM
	[SysproCompanyA].[dbo].[WipJobPost]
WHERE
	(DATEADD(MINUTE, (LTrnTime % 100), 
                DATEADD(HOUR,  FLOOR(LTrnTime / 100), CAST(TrnDate AS DATETIME)))) >= DATEADD(HOUR, -24, GETDATE())
ORDER BY
	[TrnDatetime] DESC
;

-------------------------

SELECT
	*
FROM
	[SysproCompanyA].[dbo].[WipMaster]
WHERE
	[Job] = '00020530'
;

SELECT TOP 500
	[TrnDate],
	[LTrnTime],
	*
FROM
	[SysproCompanyA].[dbo].[WipJobPost]
ORDER BY
	[WipJobPost].[TrnDate] DESC
	, [WipJobPost].[LTrnTime] DESC

SELECT DISTINCT
	1 AS [Active]
	, [WM].[Job]
	, [WM].[OperationOffset] AS [Operation]
	, [Mast].[JobTenderDate]
	, [Mast].[ActCompleteDate]
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