WITH KnownSections AS (
	SELECT 0 AS [ID], 'A' AS [Section]
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
ShelvesMap AS (
SELECT
	[SSH].[ParentShelf],
	[SSH].[ID] AS [SSH_ID],
	[HS].[ID] AS [HS_ID],
	[SSH].[Section] AS [SSH_Section],
	[SSH].[Group],
	[SSH].[x0],
	[SSH].[x1],
	[SSH].[y0],
	[SSH].[y1],
	[HS].[Shelf],
	[HS].[ShelfRow],
	[HS].[Section] AS [HS_Section]
FROM
	[BWSdb].[dbo].[INV_WarehouseLayout_HawkinsShelves] [HS]
INNER JOIN
	[BWSdb].[dbo].[INV_WarehouseShelfSections_Hawkins] [SSH]
ON
	[HS].[ShelfSectionID] = [SSH].[ID]
),
BinCounts AS (
SELECT
	[IW].[DefaultBin],
	[IW].[Warehouse],
	COUNT(*) AS [NumItems],
	SUM([IW].[QtyOnHand] * [IW].[LastCostEntered]) AS [TtlItemValue],
	(CASE WHEN 
			(LOWER([IW].[DefaultBin]) = 'vmi')
			OR (LOWER([IW].[DefaultBin]) LIKE '%vend%')
		THEN -2
		WHEN 
			LOWER([IW].[DefaultBin]) LIKE '%wh4%'
		THEN
			2 -- Montana Only
		WHEN
			LOWER([IW].[DefaultBin]) LIKE '%@%'
		THEN 
			0 -- Both
		WHEN 
			(LOWER([IW].[DefaultBin]) = '/') OR (ISNULL([IW].[DefaultBin], '') = '')
		THEN
			-99 -- Unknown
		ELSE
			1 -- Hawkins Only
	END) AS [BuildingCode],
	(CASE WHEN 
			(LEN([IW].[DefaultBin]) > 1) AND (LOWER([IW].[DefaultBin]) LIKE '%/%')
		THEN
			1 -- Slash divides bins
		WHEN
			LOWER([IW].[DefaultBin]) LIKE '%@%'
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
	(CASE WHEN LOWER(LEFT([IW].[DefaultBin], 3)) = 'wh4' THEN (
			CASE WHEN LOWER(LEFT(SUBSTRING([IW].[DefaultBin], 4, LEN([IW].[DefaultBin]) - 3), 1)) = LOWER([KS].[Section]) THEN 1 ELSE 0 END
		)
		WHEN LOWER(LEFT([IW].[DefaultBin], 1)) = LOWER([KS].[Section]) THEN 1
		ELSE 0
	END) > 0
GROUP BY
	[IW].[DefaultBin],
	[IW].[Warehouse],
	[KS].[Section]
)
/*
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
*/
, BinsCompared AS (
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
),
BinCompMap AS (
SELECT
	[BC1].*,
	[H].[SSH_ID],
	[H].[HS_ID],
	[H].[ParentShelf],
	[H].[HS_Section],
	[H].[SSH_Section],
	[H].[Group],
	[H].[x0],
	[H].[x1],
	[H].[y0],
	[H].[y1],
	[H].[Shelf],
	[H].[ShelfRow]
FROM
	[BinsCompared] [BC1]
LEFT JOIN
	[ShelvesMap] [H]
ON
	([BC1].[Section] = [H].[ParentShelf])
	AND (UPPER([BC1].[DefaultBin]) = UPPER([H].[Shelf]) COLLATE DATABASE_DEFAULT)
WHERE
	(([BC1].[BuildingCode] = 0)
	OR ([BC1].[BuildingCode] = 1))
	AND [BC1].[Warehouse] = '01'
)

SELECT * FROM [BinCounts]



--BEGIN TRAN;



/*
SELECT *
FROM
	[BinCompMap]
WHERE
	UPPER(LEFT([DefaultBin], 3)) = 'F36'
	*/

/*
INSERT INTO 
	[BWSdb].[dbo].[INV_WarehouseLayout_HawkinsShelves]
(
	[Section],
	[ShelfSectionID],
	[Shelf],
	[ShelfRow]
)
SELECT
	'I',
	74,
	[DefaultBin],
	(
		CASE 
			WHEN SUBSTRING(UPPER([DefaultBin]), 3, 1) = 'A' THEN 9
			WHEN SUBSTRING(UPPER([DefaultBin]), 3, 1) = 'B' THEN 8
			WHEN SUBSTRING(UPPER([DefaultBin]), 3, 1) = 'C' THEN 7
			WHEN SUBSTRING(UPPER([DefaultBin]), 3, 1) = 'D' THEN 6
			WHEN SUBSTRING(UPPER([DefaultBin]), 3, 1) = 'E' THEN 5
			WHEN SUBSTRING(UPPER([DefaultBin]), 3, 1) = 'F' THEN 4
			WHEN SUBSTRING(UPPER([DefaultBin]), 3, 1) = 'G' THEN 3
			WHEN SUBSTRING(UPPER([DefaultBin]), 3, 1) = 'H' THEN 2
			WHEN SUBSTRING(UPPER([DefaultBin]), 3, 1) = 'I' THEN 1
			WHEN SUBSTRING(UPPER([DefaultBin]), 3, 1) = 'J' THEN 0
			WHEN RIGHT(UPPER([DefaultBin]), 3) = 'TOP' THEN 10
			ELSE NULL
		END
	)
FROM
	[BinCompMap]
WHERE
	UPPER(LEFT([DefaultBin], 3)) = 'F36'


ROLLBACK;
COMMIT;
*/

--SELECT * FROM [BinCompMap]
--SELECT [T].* FROM [BWSdb].[dbo].[INV_WarehouseShelfSections_Hawkins] [T]
/*
SELECT
	*
FROM
	[BinCompMap] [BCM]
LEFT JOIN [ShelvesMap] [H]
ON
	[BCM].[Shelf] = [H].[Shelf]
WHERE
	[BCM].[SSH_ID] IS NULL
*/

/*
SELECT
	[BCM1].*
FROM
	[BinCompMap] [BCM1]
FULL JOIN (
	SELECT
		*
	FROM
		[BinCompMap] [BCM2]
	WHERE
		([BCM2].[SSH_ID] IS NULL)
		AND ([BCM2].[HS_ID] IS NULL)
) AS [BCM2]
ON
	[BCM1].[Section]
ORDER BY
	[BC1].[DefaultBin]

;*/