DECLARE @sc NVARCHAR(MAX) = 'TR-CLA-P006';
DECLARE @j NVARCHAR(MAX) = '10017462';
DECLARE @op INT = 13;
DECLARE @TopLevelOnly BIT = 0;
DECLARE @StartDate DATETIME = '2025-09-18 08:00';


SELECT
    [JOI].[Job]
    , [JOI].[Operation]
    , [JOI].[FirstIssued]
    , [JOI].[LastIssued]
    , [WM].[StockCode]
    , ISNULL([WM].[QtyIssued], 0)     AS [QtyIssued]
    , ISNULL([WM].[UnitQtyReqd], 0)   AS [UnitQtyReqd]
FROM [BWSdb].[dbo].[PROD_JobOpIssue] AS [JOI]
INNER JOIN [SysproCompanyA].[dbo].[WipJobAllMat] AS [WM]
    ON [JOI].[Job]       = [WM].[Job] COLLATE DATABASE_DEFAULT
    AND [JOI].[Operation] = [WM].[OperationOffset]
WHERE
    /*([JOI].[FirstIssued] IS NOT NULL)
	AND */
	([JOI].[Job] = @j)
    AND (ISNULL([WM].[QtyIssued], 0) < ISNULL([WM].[UnitQtyReqd], 0))
    --AND ([JOI].[FirstIssued] >= @StartDate)
    AND ((
            CASE WHEN ISNULL(@TopLevelOnly, 0) = 1
                THEN CASE WHEN LEFT([WM].[Job], 1) = '1' THEN 1 ELSE 0 END
                ELSE 1
            END
    ) > 0)



--SELECT * FROM [BWSdb].[dbo].[PROD_JobOpIssue] [JOI] WHERE [JOI].[Job] = @j;
SELECT 'A' AS [T], * FROM [SysproCompanyA].[dbo].[WipJobPost] [JP] WHERE ([JP].[Job] = @j) AND ([JP].[TrnType] <> 'L') ORDER BY [JP].[MStockCode]
SELECT 'B' AS [T], * FROM [SysproCompanyA].[dbo].[WipJobAllMat] [v] WHERE ([v].[Job] = @j) AND ([v].[StockCode] = @sc) ORDER BY [v].[StockCode]
SELECT 'C' AS [T], * FROM [SysproCompanyA].[dbo].[WipJobAllMat] [v] WHERE [v].[Job] = @j AND [v].[OperationOffset] = @op ORDER BY [v].[StockCode]
SELECT 'D' AS [T], * FROM [SysproCompanyA].[dbo].[v_PROD_JobMaterialStatus] [v] WHERE [v].[Job] = @j AND [v].[StockCode] = @sc ORDER BY [v].[StockCode]
SELECT 'E' AS [T], * FROM [BWSdb].[dbo].[fn_PartOrNoneIssued](@StartDate, @TopLevelOnly) [v] WHERE [v].[Job] = @j ORDER BY [v].[StockCode]

;WITH Ins AS (
    -- New material issues being posted
    SELECT i.Job,
            i.MStockCode,
            i.MWarehouse,
            DATEADD(MINUTE, (i.LTrnTime % 100),
            DATEADD(HOUR, FLOOR(i.LTrnTime / 100), CAST(i.TrnDate AS DATETIME))) AS TrnDateTime
    FROM [SysproCompanyA].[dbo].[WipJobPost] i
    WHERE i.TrnType <> 'L'  -- non labour
),
OpsWithIssues AS (
    -- Map the stock issues back to operations via v_PROD_JobMaterialStatus
    SELECT v.Job,
            v.Operation,
            MIN(ins.TrnDateTime) AS MinTrnDate,
            MAX(ins.TrnDateTime) AS MaxTrnDate
    FROM Ins ins
    INNER JOIN SysproCompanyA.dbo.v_PROD_JobMaterialStatus v
        ON v.Job = ins.Job COLLATE DATABASE_DEFAULT
        AND v.StockCode = ins.MStockCode COLLATE DATABASE_DEFAULT
        AND v.Warehouse = ins.MWarehouse
    GROUP BY v.Job, v.Operation
)
SELECT 
	'F' AS [T], *
	
/*UPDATE T
SET T.FirstIssued = ISNULL(T.FirstIssued, S.MinTrnDate),
    T.LastIssued  = S.MaxTrnDate*/
FROM BWSdb.dbo.PROD_JobOpIssue T
INNER JOIN OpsWithIssues S
    ON T.Job = S.Job COLLATE DATABASE_DEFAULT
    AND T.Operation = S.Operation
WHERE
	[T].[Job] = @j
;

--SELECT  
--    1 AS Active
--    , i.Job
--    , i.OperationOffset
--FROM [SysproCompanyA].[dbo].[WipJobAllMat] i
--WHERE NOT EXISTS (
--    SELECT 1
--    FROM [BWSdb].[dbo].[PROD_JobOpIssue] t
--    WHERE 
--		(t.Job COLLATE DATABASE_DEFAULT = i.Job)
--		AND (t.Operation = i.OperationOffset)
--)
--	AND ([Job] = @j)
--;


SELECT
	*
FROM
	[BWSdb].[dbo].[PROD_JobOpIssue] [JOI]
WHERE
	([JOI].[Job] = @j)
	AND ([JOI].[Operation] = @op)
;

SELECT
	*
FROM
	[SysproCompanyA].[dbo].[WipJobAllMat] [JM]
WHERE
	([JM].[Job] = @j)
	AND ([JM].[StockCode] = @sc)
;

SELECT
	*
FROM
	[SysproCompanyA].[dbo].[WipJobAllMat] [JM]
WHERE
	([JM].[Job] = @j)
	AND ([JM].[OperationOffset] = @op)
;

SELECT
	*
FROM
	[BWSdb].[dbo].[fn_PartOrNoneIssued]('2025-09-18 08:00', 0) [PNI]
WHERE
	[PNI].[StockCode] = @sc