SELECT
	*
FROM
	[BWSdb].[dbo].[INV_InvDescWord];

TRUNCATE TABLE [BWSdb].[dbo].[INV_InvDescWord];

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
                            REPLACE(ISNULL(ISNULL(IM.Description, '') + ' ' + ISNULL(IM.LongDesc, ''),''), '&', '&amp;'),
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
)
INSERT INTO [BWSdb].[dbo].[INV_InvDescWord] (StockCode, Word)
SELECT DISTINCT StockCode, Word
FROM Clean;