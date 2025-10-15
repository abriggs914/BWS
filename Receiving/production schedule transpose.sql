/*
SELECT
	[dPS].[WO#] AS [WO],
	ISNULL([dPS].[WO Line 1], [WO Line 2]) AS [ProdLine],
	ISNULL([dPS].[Prod Date 1], [dPS].[Prod Date 2]) AS [ProdDate]
FROM
	[BWSdb].[dbo].[dtProductionSchedule] [dPS]
WHERE
	ISNULL([dPS].[Prod Date 1], [dPS].[Prod Date 2]) BETWEEN DATEADD(DAY, -450, GETDATE()) AND DATEADD(DAY, 450, GETDATE())
*/

DECLARE @cols  nvarchar(max);
DECLARE @sql   nvarchar(max);

;WITH S AS (
    -- 1) Normalize to a tidy 3-column set
    SELECT
        WO       = CAST([dPS].[WO#] AS nvarchar(50)),
        ProdLine = ISNULL([dPS].[WO Line 1], [dPS].[WO Line 2]),
        ProdDate = ISNULL([dPS].[Prod Date 1], [dPS].[Prod Date 2])
    FROM [BWSdb].[dbo].[dtProductionSchedule] AS dPS
    WHERE ISNULL([dPS].[Prod Date 1], [dPS].[Prod Date 2])
          BETWEEN DATEADD(DAY, -450, GETDATE()) AND DATEADD(DAY, 450, GETDATE())
),
-- 2) Distinct list of column names as ISO dates (YYYY-MM-DD)
Dates AS (
    SELECT DISTINCT CONVERT(varchar(10), ProdDate, 23) AS ProdDateStr
    FROM S
)
SELECT
    @cols =
    STUFF((
        SELECT ',' + QUOTENAME(ProdDateStr)
        FROM Dates
        ORDER BY ProdDateStr
        FOR XML PATH(''), TYPE
    ).value('.', 'nvarchar(max)'), 1, 1, '');

-- 3) Build dynamic pivot:
--    First, pre-aggregate WOs per (ProdLine, ProdDate) into a comma list,
--    then pivot those lists so each date becomes a column.
SET @sql = N'
;WITH Base AS (
    SELECT
        s.ProdLine,
        ProdDateStr = CONVERT(varchar(10), s.ProdDate, 23),
        s.WO
    FROM S as s
),
Agg AS (
    SELECT
        b1.ProdLine,
        b1.ProdDateStr,
        WOList =
            STUFF((
                SELECT DISTINCT '','' + b2.WO
                FROM Base b2
                WHERE b2.ProdLine   = b1.ProdLine
                  AND b2.ProdDateStr = b1.ProdDateStr
                FOR XML PATH(''''), TYPE
            ).value(''.'', ''nvarchar(max)''), 1, 1, '''')
    FROM Base b1
    GROUP BY b1.ProdLine, b1.ProdDateStr
)
SELECT
    p.ProdLine, ' + @cols + N'
FROM Agg
PIVOT (
    MAX(WOList) FOR ProdDateStr IN (' + @cols + N')
) AS p
ORDER BY p.ProdLine;
';

-- Make the CTE S visible to the dynamic batch
-- (redeclare it in the dynamic scope)
SET @sql = REPLACE(@sql, 'FROM S as s', 
N'FROM (
    SELECT
        WO       = CAST([dPS].[WO#] AS nvarchar(50)),
        ProdLine = ISNULL([dPS].[WO Line 1], [dPS].[WO Line 2]),
        ProdDate = ISNULL([dPS].[Prod Date 1], [dPS].[Prod Date 2])
    FROM [BWSdb].[dbo].[dtProductionSchedule] AS dPS
    WHERE ISNULL([dPS].[Prod Date 1], [dPS].[Prod Date 2])
          BETWEEN DATEADD(DAY, -450, GETDATE()) AND DATEADD(DAY, 450, GETDATE())
) AS s');

EXEC sp_executesql @sql;