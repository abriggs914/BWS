WITH KnownSections AS (
	SELECT 
		0 AS [ID], 'A' AS [Section]
	UNION SELECT 1, 'B'
	UNION SELECT 2, 'C'
	UNION SELECT 3, 'D'
	UNION SELECT 4, 'E'
	UNION SELECT 5, 'F'
	UNION SELECT 6, 'G'
	UNION SELECT 7, 'H'
	UNION SELECT 8, 'I'
	UNION SELECT 9, 'J'
	UNION SELECT 10, 'K'
	UNION SELECT 11, 'L'
	UNION SELECT 12, 'M'
	UNION SELECT 13, 'N'
	UNION SELECT 14, 'O'
	UNION SELECT 15, 'P'
	UNION SELECT 16, 'Q'
	UNION SELECT 17, 'R'
	UNION SELECT 18, 'S'
	UNION SELECT 19, 'T'
	UNION SELECT 20, 'U'
	UNION SELECT 21, 'V'
	UNION SELECT 22, 'W'
	UNION SELECT 23, 'X'
	UNION SELECT 24, 'Y'
	UNION SELECT 25, 'Z'
),
BinCounts AS (
SELECT
	LTRIM(RTRIM([IW].[DefaultBin])) AS [DefaultBin],
	[IW].[Warehouse],
	COUNT(*) AS [NumItems],
	SUM([IW].[QtyOnHand] * [IW].[LastCostEntered]) AS [TtlItemValue],
	(CASE WHEN 
			(LOWER(LTRIM(RTRIM([IW].[DefaultBin]))) = 'vmi')
			OR (LOWER(LTRIM(RTRIM([IW].[DefaultBin]))) LIKE '%vend%')
		THEN -2
		WHEN 
			LOWER(LTRIM(RTRIM([IW].[DefaultBin]))) LIKE '%wh4%'
		THEN
			2 -- Montana Only
		WHEN
			LOWER(LTRIM(RTRIM([IW].[DefaultBin]))) LIKE '%@%'
		THEN 
			0 -- Both
		WHEN 
			(LOWER(LTRIM(RTRIM([IW].[DefaultBin]))) = '/') OR (ISNULL(LTRIM(RTRIM([IW].[DefaultBin])), '') = '')
		THEN
			-99 -- Unknown
		ELSE
			1 -- Hawkins Only
	END) AS [BuildingCode],
	(CASE WHEN 
			(LEN(LTRIM(RTRIM([IW].[DefaultBin]))) > 1) AND (LOWER(LTRIM(RTRIM([IW].[DefaultBin]))) LIKE '%/%')
		THEN
			1 -- Slash divides bins
		WHEN
			LOWER(LTRIM(RTRIM([IW].[DefaultBin]))) LIKE '%@%'
		THEN 
			1 -- @ denotes same bin in another building
		ELSE
			0 -- Only 1 noted
	END) AS [HasMultipleBins],
	[KS].[Section] AS [Section]
FROM
	[SysproCompanyA].[dbo].[InvWarehouse] [IW]
LEFT JOIN
	[KnownSections] [KS]
ON
	(CASE WHEN LOWER(LEFT(LTRIM(RTRIM([IW].[DefaultBin])), 3)) = 'wh4' THEN (
			CASE WHEN LOWER(LEFT(SUBSTRING(LTRIM(RTRIM([IW].[DefaultBin])), 4, LEN(LTRIM(RTRIM([IW].[DefaultBin]))) - 3), 1)) = LOWER([KS].[Section]) THEN 1 ELSE 0 END
		)
		WHEN LOWER(LEFT(LTRIM(RTRIM([IW].[DefaultBin])), 1)) = LOWER([KS].[Section]) THEN 1
		ELSE 0
	END) > 0
GROUP BY
	LTRIM(RTRIM([IW].[DefaultBin])),
	[IW].[Warehouse],
	[KS].[Section]
)
SELECT
	[BC1].[Section],
	[BC1].[DefaultBin],
	[BC2].[DefaultBin] AS [BinLike],
	[BC1].[Warehouse],
	[BC1].[NumItems],
	[BC1].[TtlItemValue],
	[BC1].[BuildingCode],
	[BC1].[HasMultipleBins]
FROM 
	[BinCounts] AS [BC1]
	LEFT JOIN [BinCounts] AS [BC2]
		ON  (REPLACE(REPLACE(REPLACE(LOWER([BC1].[DefaultBin]), ' ', ''), '/', ''), '@', '') =
			REPLACE(REPLACE(REPLACE(LOWER([BC2].[DefaultBin]), ' ', ''), '/', ''), '@', ''))
		AND (LOWER(BC1.DefaultBin) <> LOWER([BC2].[DefaultBin]))
		AND ([BC1].[Warehouse] = [BC2].[Warehouse])
WHERE
	LTRIM(RTRIM(UPPER([BC1].[DefaultBin]))) LIKE '%VMI%'
;