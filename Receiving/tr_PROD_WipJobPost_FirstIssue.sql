USE [SysproCompanyA];
GO

-- 2025-09-22 14:40 - Avery Briggs - Ensure that when something is issued, the operation and job are stored in [BWSdb].[dbo].[PROD_JobOpIssue].
--	Using this data, check if another stockcode was missed as part of a kit-issuing. If another stockcode was missed while posting stockcodes to the current Job's operation,
--	create a temporary YellowTag to be approved by purchasing or production before it can enter [BWSdb].[dbo].[PROD_YellowTags].
-- 2025-09-22 15:28 - Avery Briggs - Adjusted for full DATETIME for [TrnDate]
-- 2025-09-22 15:53 - Avery Briggs - Adjusted for material only transactions via [TrnType] <> 'L'

ALTER TRIGGER [tr_PROD_WipJobPost_FirstIssue]
ON [dbo].[WipJobPost]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH Issued AS (
        SELECT 
              [i].[Job]
            , [i].[LOperation] AS [Operation]
            , MIN(DATEADD(MINUTE, ([i].[LTrnTime] % 100), 
                DATEADD(HOUR, FLOOR([i].[LTrnTime] / 100), CAST([i].[TrnDate] AS DATETIME)))) AS [MinTrnDate]
            , MAX(DATEADD(MINUTE, ([i].[LTrnTime] % 100), 
                DATEADD(HOUR, FLOOR([i].[LTrnTime] / 100), CAST([i].[TrnDate] AS DATETIME)))) AS [MaxTrnDate]
        FROM inserted [i]
		WHERE [i].[TrnType] <> 'L'  -- no labour postings
        GROUP BY [i].[Job], [i].[LOperation]
    )
    UPDATE T
    SET 
        [T].[FirstIssued] = ISNULL([T].[FirstIssued], [S].[MinTrnDate]),
        [T].[LastIssued] = [S].[MaxTrnDate]
    FROM [BWSdb].[dbo].[PROD_JobOpIssue] [T]
    INNER JOIN Issued [S]
        ON [T].[Job] COLLATE DATABASE_DEFAULT = [S].[Job] COLLATE DATABASE_DEFAULT
       AND [T].[Operation] = [S].[Operation];
END
GO
