USE [BWSdb]
GO

BEGIN TRAN;

DECLARE @sd DATETIME = '2025-09-18';
DECLARE @tlo BIT = 1;
DECLARE @op INT = 1;
DECLARE @j NVARCHAR(MAX) = '10017462';
DECLARE @sc NVARCHAR(MAX) = 'TR-MFP-P046';

SELECT
	*
FROM 
	[SysproCompanyA].[dbo].[v_PROD_JobMaterialStatus] [JMS]
WHERE
	([JMS].[Job] = @j)
	AND ([JMS].[StockCode] = @sc)

SELECT * FROM [BWSdb].[dbo].[PROD_JobOpIssue] WHERE [Job] = @j

;WITH inserted AS (
	SELECT
		*
	FROM
		[SysproCompanyA].[dbo].[WipJobPost] [JP]
	WHERE
		([JP].[Job] = @j)
), Ins AS (
        -- New material issues being posted
        SELECT i.Job,
               i.MStockCode,
               i.MWarehouse,
               DATEADD(MINUTE, (i.LTrnTime % 100),
               DATEADD(HOUR, FLOOR(i.LTrnTime / 100), CAST(i.TrnDate AS DATETIME))) AS TrnDateTime
        FROM inserted i
        WHERE i.TrnType <> 'L'  -- non labour
    ),
    OpsWithIssues AS (
        -- Map the stock issues back to operations via v_PROD_JobMaterialStatus
        SELECT v.Job,
               v.Operation,
               MIN(ins.TrnDateTime) AS MinTrnDate,
               MAX(ins.TrnDateTime) AS MaxTrnDate,
			   SUM([SumQtyIssued]) AS [SUMSumQtyIssued]
        FROM Ins ins
        INNER JOIN SysproCompanyA.dbo.v_PROD_JobMaterialStatus v
            ON v.Job = ins.Job COLLATE DATABASE_DEFAULT
           AND v.StockCode = ins.MStockCode COLLATE DATABASE_DEFAULT
           AND v.Warehouse = ins.MWarehouse
        GROUP BY v.Job, v.Operation
		--HAVING SUM([SumQtyIssued]) = 0
    )
	
	--SELECT * FROM [inserted] [i] LEFT JOIN [SysproCompanyA].[dbo].[WipJobAllMat] [JM] ON ([I].[MStockCode] = [JM].[StockCode]) AND ([I].[Job] = [JM].[Job]) ORDER BY [MStockCode]
	SELECT * FROM [OpsWithIssues]

	SELECT 
		ISNULL(T.FirstIssued, S.MinTrnDate) AS [FI]
		,S.MaxTrnDate AS [LI]
	,*
	FROM BWSdb.dbo.PROD_JobOpIssue T
    INNER JOIN OpsWithIssues S
        ON T.Job = S.Job COLLATE DATABASE_DEFAULT
       AND T.Operation = S.Operation;

    UPDATE T
    SET T.FirstIssued = ISNULL(T.FirstIssued, S.MinTrnDate),
        T.LastIssued  = S.MaxTrnDate
    FROM BWSdb.dbo.PROD_JobOpIssue T
    INNER JOIN OpsWithIssues S
        ON T.Job = S.Job COLLATE DATABASE_DEFAULT
       AND T.Operation = S.Operation;
	   
	COMMIT;
	ROLLBACK;


/* -- 2025-09-29 15:32
; WITH T AS (
	SELECT
		'FAIL_MANUAL_ONLY' AS [CorrectlyPredicted],
		YT.WO,
		YT.StockCode,
		YT.DateCreated AS [YTDateCreated],
		(CASE WHEN [Src].[Job] IS NULL THEN 0 ELSE 1 END) AS [BOMCallsFor]
	FROM BWSdb.dbo.PROD_YellowTags YT
	INNER JOIN (
		SELECT DISTINCT Job
		FROM dbo.fn_PartOrNoneIssued(@sd, @tlo)
	) J
	ON YT.WO = J.Job COLLATE DATABASE_DEFAULT
	LEFT JOIN dbo.fn_PartOrNoneIssued(@sd, @tlo) Src
	ON YT.WO        = Src.Job COLLATE DATABASE_DEFAULT
	AND YT.StockCode = Src.StockCode COLLATE DATABASE_DEFAULT
	WHERE Src.Job IS NULL
		  AND YT.DateCreated >= @sd
)
	SELECT
		*
	FROM
		[T]
	LEFT JOIN
		[SysproCompanyA].[dbo].[WipJobAllMat] [JM]
	ON
		([T].[StockCode] = [JM].[StockCode] COLLATE DATABASE_DEFAULT)
		AND ([T].[WO] = [JM].[Job] COLLATE DATABASE_DEFAULT)
*/