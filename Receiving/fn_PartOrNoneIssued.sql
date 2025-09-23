USE [BWSdb]
GO

-- 2025-09-23 17:44 - Avery Briggs - TVF to show StockCode Issuing to an Operation on a Job.
--		Shows only partially or wholly missing quantites issued to the operation.
--		This is inferred from the [PROD_JobOpIssue].[FirstIssued] value, and the associating trigger on [SysproCompanyA].[dbo].[WipJobPost].

CREATE FUNCTION [dbo].[fn_PartOrNoneIssued]
(
    @StartDate     DATETIME,
    @TopLevelOnly  BIT = 1
)
RETURNS TABLE
AS
RETURN
(
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
        [JOI].[FirstIssued] IS NOT NULL
        AND ISNULL([WM].[QtyIssued], 0) < ISNULL([WM].[UnitQtyReqd], 0)
        AND [JOI].[FirstIssued] >= @StartDate
        AND (
             CASE WHEN ISNULL(@TopLevelOnly, 0) = 1
                  THEN CASE WHEN LEFT([WM].[Job], 1) = '1' THEN 1 ELSE 0 END
                  ELSE 1
             END
        ) > 0
);
