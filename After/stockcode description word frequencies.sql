
/*
SELECT
	[IW].[StockCode],
	[IM].[Description],
	[IM].[LongDesc],
	[IW].[DefaultBin],
	[IM].[StockUom]
FROM
	[SysproCompanyA].[dbo].[InvWarehouse] [IW] WITH (NOLOCK)
INNER JOIN
	[SysproCompanyA].[dbo].[InvMaster] [IM] WITH (NOLOCK)
ON
	([IW].[StockCode] = [IM].[StockCode])
	AND ([IW].[Warehouse] = [IM].[WarehouseToUse])
INNER JOIN
	[SysproCompanyA].[dbo].[ApSupplier] [AS] WITH (NOLOCK)
ON
	([IM].[Supplier] = [AS].[Supplier])
*/

/*
;WITH Words AS (
    SELECT
        IM.StockCode,
        Word = UPPER(LTRIM(RTRIM(T.C.value('.', 'varchar(100)'))))
    FROM SysproCompanyA.dbo.InvMaster IM WITH (NOLOCK)
    CROSS APPLY (
        SELECT CAST(
            '<x>' +
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                            REPLACE(ISNULL(IM.Description,''), '&', '&amp;'),  -- XML escape
                        '<', '&lt;'),
                    '>', '&gt;'),
                ' ', '</x><x>'),
            CHAR(9), ' ') +
            '</x>' AS xml
        ) AS X
    ) AS A
    CROSS APPLY A.X.nodes('/x') AS T(C)
),
Clean AS (
    SELECT
        StockCode,
        Word = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Word, '.', ''), ',', ''), ';',''), ':',''), '"','')
    FROM Words
    WHERE Word <> ''
)
SELECT TOP 100
    Word,
    Frequency = COUNT(*)
FROM Clean
WHERE LEN(Word) >= 3
  AND Word NOT IN ('THE','AND','FOR','WITH','ASSY','ASSEMBLY','OF','TO','IN')  -- optional stopwords
GROUP BY Word
ORDER BY COUNT(*) DESC, Word;
*/

;WITH Words AS (
    SELECT
        IM.StockCode,
        Word = UPPER(LTRIM(RTRIM(T.C.value('.', 'varchar(100)'))))
    FROM SysproCompanyA.dbo.InvMaster IM WITH (NOLOCK)
    CROSS APPLY (
        SELECT CAST(
            '<x>' +
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                            REPLACE(ISNULL(IM.Description,''), '&', '&amp;'),
                        '<', '&lt;'),
                    '>', '&gt;'),
                ' ', '</x><x>'),
            CHAR(9), ' ') +
            '</x>' AS xml
        ) AS X
    ) AS A
    CROSS APPLY A.X.nodes('/x') AS T(C)
),
Clean AS (
    SELECT
        StockCode,
        Word = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Word, '.', ''), ',', ''), ';',''), ':',''), '"','')
    FROM Words
    WHERE Word <> ''
      AND LEN(Word) >= 3
),
Freq AS (
    SELECT Word, Frequency = COUNT(*)
    FROM Clean
    GROUP BY Word
),
PartWords AS (
    SELECT DISTINCT StockCode, Word
    FROM Clean
)
SELECT
    IM.StockCode,
    IM.Description,
    PW.Word,
    F.Frequency
FROM SysproCompanyA.dbo.InvMaster IM WITH (NOLOCK)
JOIN PartWords PW
    ON PW.StockCode = IM.StockCode
JOIN Freq F
    ON F.Word = PW.Word
-- optional: focus on a subset of parts:
-- WHERE IM.StockCode IN ('ABC', 'DEF')
WHERE LEN(PW.Word) >= 3
  AND PW.Word NOT IN ('THE','AND','FOR','WITH','ASSY','ASSEMBLY','OF','TO','IN')  -- optional stopwords
ORDER BY IM.StockCode, F.Frequency DESC, PW.Word;