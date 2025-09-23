
-- 2025-09-22 17:40 - Avery Briggs - Script to verify automatically flagged YTs.
-- Convert this into a view to be approved by purchasing / production

DECLARE @StartDate DATETIME = '2025-09-18 08:00';
DECLARE @TopLevelOnly BIT = 0;

SELECT * FROM [BWSdb].[dbo].[PROD_JobOpIssue] [JOI];
SELECT * FROM [BWSdb].[dbo].[hist_PROD_JobOpIssue] [hJOI] ;

SELECT
	'Material Posted Since ' + CAST(@StartDate AS NVARCHAR(MAX)) AS [T],
	*
FROM
	[SysproCompanyA].[dbo].[v_PROD_WipJobPostDateTime] [WJP] 
INNER JOIN
	[SysproCompanyA].[dbo].[WipJobPost] [WJ] 
ON
	([WJP].[Job] = [WJ].[Job])
	AND ([WJP].[MStockCode] = [WJ].[MStockCode])
	AND ([WJP].[Line] = [WJ].[Line])
WHERE
	([WJP].[TrnDateTime] >= @StartDate)
	AND ([WJ].[TrnType] <> 'L')
ORDER BY
	[WJP].[TrnDateTime] DESC
;

/*
SELECT 
	'Material Posted - B' AS [T],
	[JP].[MQtyIssued],
	[WJM].[UnitQtyReqd],
	[JP].[Job],
	[WJM].[Job],
	[JP].[MStockCode],
	[WJM].[StockCode],
	[JP].[LOperation],
	[WJM].[OperationOffset],
	[JP].*
FROM
	[SysproCompanyA].[dbo].[WipJobPost] [JP]
INNER JOIN
	[SysproCompanyA].[dbo].[WipJobAllMat] [WJM]  
ON
	([JP].[Job] = [WJM].[Job])
	AND ([JP].[MStockCode] = [WJM].[StockCode])
	AND ([JP].[LOperation] = [WJM].[OperationOffset])
;

-- Material Issued Today
SELECT 
	'Material Posted' AS [T],
	[WJP].[TrnDateTime],
	[JP].[MQtyIssued],
	[WJM].[UnitQtyReqd],
	[JP].*
FROM
	[SysproCompanyA].[dbo].[WipJobPost] [JP]
INNER JOIN
	[SysproCompanyA].[dbo].[WipJobAllMat] [WJM] 
ON
	([JP].[Job] = [WJM].[Job])
	AND ([JP].[MStockCode] = [WJM].[StockCode])
	AND ([JP].[LOperation] = [WJM].[OperationOffset])
INNER JOIN
	[SysproCompanyA].[dbo].[v_PROD_WipJobPostDateTime] [WJP] 
ON	
	([JP].[Job] = [WJP].[Job])
	AND ([JP].[Line] = [WJP].[Line])
	AND ([JP].[MStockCode] = [WJP].[MStockCode])
WHERE
	/*([WJP].[TrnDateTime] >= @StartDate)
	AND*/
	([JP].[TrnType] <> 'L')
;
*/	

-- Find shortages -> all [WipJobAllMat] rows where QtyIssued < UnitQtyReqd for a Job/Operation that has been started (FirstIssued IS NOT NULL).

DECLARE @partOrNoneIssued AS TABLE 
(
	[ID] INT IDENTITY(0, 1),
	[Job] NVARCHAR(MAX),
	[Operation] INT,
	[FirstIssued] DATETIME,
	[LastIssued] DATETIME,
	[StockCode] NVARCHAR(MAX),
	[QtyIssued] DECIMAL(18, 6),
	[UnitQtyReqd] DECIMAL(18, 6)
)
INSERT INTO @partOrNoneIssued (
	[Job],
	[Operation],
	[FirstIssued],
	[LastIssued],
	[StockCode],
	[QtyIssued],
	[UnitQtyReqd]
)
	SELECT
		[JOI].[Job],
		[JOI].[Operation],
		[JOI].[FirstIssued],
		[JOI].[LastIssued],
		[WM].[StockCode],
		[WM].[QtyIssued],
		[WM].[UnitQtyReqd]
	FROM
		[BWSdb].[dbo].[PROD_JobOpIssue] [JOI]
	INNER JOIN
		[SysproCompanyA].[dbo].[WipJobAllMat] [WM]
	ON
		([JOI].[Job] = [WM].[Job] COLLATE DATABASE_DEFAULT)
		AND ([JOI].[Operation] = [WM].[OperationOffset])
	WHERE
		([JOI].[FirstIssued] IS NOT NULL)
		AND ([WM].[QtyIssued] < [WM].[UnitQtyReqd])
		AND ([JOI].[FirstIssued] >= @StartDate)
		AND ((CASE WHEN ISNULL(@TopLevelOnly, 0) = 1 THEN (CASE WHEN LEFT([WM].[Job], 1) = '1' THEN 1 ELSE 0 END) ELSE 1 END) > 0)
;

SELECT 
	'New StockCodes w/ part or none posting' AS [T],
	*
FROM 
	@partOrNoneIssued
;

-- #####
-- Compare with newely added Yellow Tags via manual entry
-- #####

-- New YTs
SELECT
	'New YTs' AS [T],
	(CASE WHEN (([Src].[Job] IS NOT NULL) AND ([Src].[StockCode] IS NOT NULL)) THEN 1 ELSE 0 END) AS [FoundOnBoth],
	[YT].[LastModified],
	[YT].[WO],
	[YT].[StockCode],
	[YT].[Description],
	[YT].[PO],
	[YT].[QtyMissing],
	[YT].[Notes],
	[YT].[ID] AS [YT_ID],
	[Src].[ID] AS [Src_ID]
FROM
	[BWSdb].[dbo].[PROD_YellowTags] [YT]
LEFT JOIN
	@partOrNoneIssued [Src]
ON
	([YT].[WO] = [Src].[Job])
	AND ([YT].[StockCode] = [Src].[StockCode])
WHERE
	([DateCreated] >= @StartDate)
	AND ((CASE WHEN ISNULL(@TopLevelOnly, 0) = 1 THEN (CASE WHEN LEFT([YT].[WO], 1) = '1' THEN 1 ELSE 0 END) ELSE 1 END) > 0)
ORDER BY
	[DateCreated] DESC
;

-- Cross-referencing
-- Correctly flagged, and entered on the YT list manually.
SELECT
	'SUCCESS!' AS [CorrectlyPredicted],
	[YT].[ID] AS [YT_ID],
	[Src].[ID] AS [JOI_ID],
	[YT].*
FROM
	[BWSdb].[dbo].[PROD_YellowTags] [YT]
INNER JOIN 
	@partOrNoneIssued AS [Src]
ON
	([YT].[WO] = [Src].[Job] COLLATE DATABASE_DEFAULT)
	AND ([YT].[StockCode] = [Src].[StockCode] COLLATE DATABASE_DEFAULT)
WHERE
	([YT].[DateCreated] >= @StartDate)
	AND ((CASE WHEN ISNULL(@TopLevelOnly, 0) = 1 THEN (CASE WHEN LEFT([YT].[WO], 1) = '1' THEN 1 ELSE 0 END) ELSE 1 END) > 0)
ORDER BY
	[DateCreated] DESC
;

-- FAILs

-- Manual YTs that don’t match auto shortages
-- These are bad. If Someone marked something as a YT, but the system didnt pick up on it, then there is a flaw to the logic.
SELECT
    'FAIL_MANUAL_ONLY' AS [CorrectlyPredicted],
    YT.WO,
    YT.StockCode,
    YT.DateCreated AS [YTDateCreated]
FROM BWSdb.dbo.PROD_YellowTags YT
INNER JOIN (SELECT DISTINCT Job FROM @partOrNoneIssued) J
  ON YT.WO = J.Job COLLATE DATABASE_DEFAULT
LEFT JOIN @partOrNoneIssued Src
  ON YT.WO = Src.Job COLLATE DATABASE_DEFAULT
 AND YT.StockCode = Src.StockCode COLLATE DATABASE_DEFAULT
WHERE (Src.Job IS NULL) AND ([YT].[DateCreated] >= @StartDate);

-- Auto shortages that don’t match manual YTs
-- Some room for error on these ones. POTENTIALLY, these YTs are YET-TO-BE made manually.
-- If the record is older, there may be a problem in the logic.
SELECT 'FAIL_AUTO_ONLY' AS [CorrectlyPredicted], Src.*
FROM @partOrNoneIssued Src
LEFT JOIN BWSdb.dbo.PROD_YellowTags YT
  ON YT.WO = Src.Job COLLATE DATABASE_DEFAULT
 AND YT.StockCode = Src.StockCode COLLATE DATABASE_DEFAULT
WHERE (YT.WO IS NULL) AND ([Src].[FirstIssued] >= @StartDate);




/*
-- auto-detected but not manually tagged  -- CHATGPT not working
SELECT WO, StockCode
FROM (
	SELECT
		'SUCCESS!' AS [CorrectlyPredicted],
		[YT].*
	FROM
		[BWSdb].[dbo].[PROD_YellowTags] [YT]
	INNER JOIN (
		SELECT
			[JOI].[Job] AS [JoiJob],
			[JOI].[Operation],
			[JOI].[FirstIssued],
			[JOI].[LastIssued],
			[WM].*
		FROM
			[BWSdb].[dbo].[PROD_JobOpIssue] [JOI]
		INNER JOIN
			[SysproCompanyA].[dbo].[WipJobAllMat] [WM]
		ON
			([JOI].[Job] = [WM].[Job] COLLATE DATABASE_DEFAULT)
			AND ([JOI].[Operation] = [WM].[OperationOffset])
		WHERE
			([JOI].[FirstIssued] IS NOT NULL)
			AND ([WM].[QtyIssued] < [WM].[UnitQtyReqd])
	) AS [Src]
	ON
		([YT].[WO] = [Src].[Job] COLLATE DATABASE_DEFAULT)
		AND ([YT].[StockCode] = [Src].[StockCode] COLLATE DATABASE_DEFAULT)
) AS AutoDetected
EXCEPT
SELECT WO, StockCode
FROM [BWSdb].[dbo].[PROD_YellowTags]
;
*/