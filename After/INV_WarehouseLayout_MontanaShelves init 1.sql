
-- Grouping WH4 bins for plotting
-- Used to initialize 2026-02-23 12:04

DECLARE @p_WH4 NVARCHAR(50) = 'wh4';

DECLARE @known TABLE (
	[ID] INT IDENTITY(0, 1),
	[ParentShelf] NVARCHAR(250)
)
INSERT INTO @known ([ParentShelf]) VALUES
('A'),
('B'),
('C'),
('D'),
('E'),
('F'),
('G'),
('H'),
('I'),
('J'),
('K'),
('L'),
('M'),
('N'),
('O'),
('P'),
('Q'),
('R'),
('S'),
('T'),
('U'),
('V'),
('W'),
('X'),
('Y'),
('Z'),
('TT')
;

DECLARE @dropBins AS TABLE(
	[ID] INT IDENTITY(0, 1),
	[Section] NVARCHAR(50),
	[Shelf] NVARCHAR(50),
	[ShelfRowID] NVARCHAR(50)
)

INSERT INTO @dropBins (
	[Section],
	[Shelf],
	[ShelfRowID]
) VALUES 
('A', NULL, 92),
('B', NULL, 91),
('C', NULL, 90),
('D', NULL, 89),
('E', NULL, 88),
('F', NULL, 87),
('G', NULL, 86),
('H', NULL, 83),
('I', NULL, 84),
('U', NULL, 289),
('Q', NULL, 152),
('X', NULL, 169),
('TT', NULL, 144),
('R', NULL, 227),

('P', 'P1', 143),
('P', 'P2', 143),
('P', 'P3', 163),
('P', 'P4', 163),
('P', 'P5', 153),
('P', 'P6', 183),
('P', 'P7', 183),
('P', 'P8', 203),
('P', 'P9', 203),
('P', 'P10', 223),
('P', 'P11', 223),
('P', 'P12', 223),
('P', 'P13', 223),
('P', 'P14', 223),
('P', 'P15', 223),
('P', 'P16', 264),
('P', 'P17', 264),
('P', NULL, 143),

('T', 'T1', 186),
('T', 'T2', 186),
('T', 'T4', 186),
('T', 'T5', 186),
('T', 'T3', 226),
('T', NULL, 186)


DECLARE @toInsert TABLE (
	[ID] INT IDENTITY(0, 1),
	[Section] NVARCHAR(50),
	[ShelfSectionID] INT,
	[Shelf] NVARCHAR(50),
	[ShelfRow] NVARCHAR(50),
	[ShelfRowSec] NVARCHAR(50)
)


SELECT
	[IW].[DefaultBin],
	[IW].[UpHillBin1],
	[IW].[UpHillBin2],
	[IW].[ID],
	[IW].[ParentShelf],
	CAST((CASE WHEN [ShelfRowIsNum] = 1 THEN [ShelfRow] ELSE '0' END) AS INT) AS [ShelfRow],
	(CASE WHEN [ShelfRowIsNum] = 1 THEN SUBSTRING([UpHillBin1], 3, 1) ELSE NULL END) AS [ShelfRowSec],
	[SSM].*
FROM (
	SELECT
		[IW].[DefaultBin],
		[IW].[UpHillBin1],
		[IW].[UpHillBin2],
		[IW].[ID],
		[IW].[ParentShelf],
		ISNUMERIC([ShelfRow]) AS [ShelfRowIsNum],
		[ShelfRow]
		--CAST((CASE WHEN ISNUMERIC([ShelfRow]) = 1 THEN [ShelfRow] ELSE '0' END) AS INT) AS [ShelfRow]
	FROM (
		SELECT
			[IW].[DefaultBin],
			[IW].[UpHillBin1],
			[IW].[UpHillBin2],
			[K].[ID],
			[K].[ParentShelf],
			SUBSTRING([IW].[UpHillBin1], 2, 1) AS [ShelfRow],
			SUBSTRING([IW].[UpHillBin1], 3, 1) AS [ShelfRowSec]
		FROM (
			SELECT
				[IW].[DefaultBin]
				, SUBSTRING([IW].[DefaultBin], [IdxWH4] + LEN(@p_WH4), LEN([IW].DefaultBin) - [IdxWH4]) AS [UpHillBin1]
				, (CASE WHEN [IW].[SameBin] = 1 
					THEN [IW].[DefaultBin]
					ELSE SUBSTRING([IW].[DefaultBin], [IdxWH4] + LEN(@p_WH4), LEN([IW].DefaultBin) - [IdxWH4])
				END) AS [UpHillBin2],
				[IdxWH4]
			FROM (
				SELECT
					[IW].[DefaultBin]
					, CHARINDEX(@p_WH4, LOWER([IW].[DefaultBin]),1) AS [IdxWH4]
					, (CASE WHEN CHARINDEX(@p_WH4, LOWER([IW].[DefaultBin]),1) = 0 THEN 1 ELSE 0 END) AS [SameBin]
				FROM
					[SysproCompanyA].[dbo].[InvWarehouse] [IW]
				WHERE
					(LOWER([IW].[DefaultBin]) LIKE '%' + @p_WH4 + '%')
					OR (LOWER([IW].[DefaultBin]) LIKE '%@%')
				GROUP BY
					[IW].[DefaultBin]
			) AS [IW]
		) AS [IW]
		INNER JOIN
			@known [K]
		ON
			LOWER(LEFT([K].[ParentShelf], 1)) = LOWER(LEFT([IW].[UpHillBin1], 1)) COLLATE DATABASE_DEFAULT
	) AS [IW]
) AS [IW]
FULL JOIN
	[BWSdb].[dbo].[INV_WarehouseShelfSections_Montana] [SSM]
ON
	[IW].[ParentShelf] = [SSM].[Section]
WHERE
	LTRIM(RTRIM(ISNULL([IW].[DefaultBin], ''))) <> ''
ORDER BY
	[IW].[DefaultBin]
;

INSERT INTO @toInsert ([Section], [Shelf], [ShelfRow], [ShelfRowSec])
SELECT
	[ParentShelf],
	[IW].[DefaultBin],
	[IW].[ShelfRow],
	(CASE WHEN [ShelfRowIsNum] = 1 THEN SUBSTRING([UpHillBin1], 2 + [NSize], LEN([UpHillBin1]) - (1 + [NSize])) ELSE NULL END) --AS [ShelfRowSec]
	
/*
SELECT
	[IW].[DefaultBin],
	[IW].[UpHillBin1],
	[IW].[UpHillBin2],
	[IW].[ID],
	[IW].[ParentShelf],
	[IW].[NSize],
	CAST((CASE WHEN [ShelfRowIsNum] = 1 THEN [ShelfRow] ELSE '0' END) AS INT) AS [ShelfRow],
	(CASE WHEN [ShelfRowIsNum] = 1 THEN SUBSTRING([UpHillBin1], 2 + [NSize], LEN([UpHillBin1]) - (1 + [NSize])) ELSE NULL END) AS [ShelfRowSec]
*/
FROM (
	SELECT
		[IW].[DefaultBin],
		[IW].[UpHillBin1],
		[IW].[UpHillBin2],
		[IW].[ID],
		[IW].[ParentShelf],
		ISNUMERIC([ShelfRow]) AS [ShelfRowIsNum],
		[ShelfRow],
		[IW].[NSize]
		--CAST((CASE WHEN ISNUMERIC([ShelfRow]) = 1 THEN [ShelfRow] ELSE '0' END) AS INT) AS [ShelfRow]
	FROM (
		SELECT
			[IW].[DefaultBin],
			[IW].[UpHillBin1],
			[IW].[UpHillBin2],
			[K].[ID],
			[K].[ParentShelf],
			[IW].[NSize],
			--SUBSTRING([IW].[UpHillBin1], 2, 1) AS [ShelfRow],
			--SUBSTRING([IW].[UpHillBin1], 3, 1) AS [ShelfRowSec],
			(CASE WHEN [NSize] > 0 THEN SUBSTRING([IW].[UpHillBin1], 2, [NSize]) ELSE '0' END) AS [ShelfRow],
			SUBSTRING([IW].[UpHillBin1], 3, 1) AS [ShelfRowSec]
		FROM (
			SELECT
				[IW].[DefaultBin],
				[IW].[UpHillBin1],
				[IW].[UpHillBin2],
				[IW].[IdxWH4],
				(CASE 
				WHEN ((ISNUMERIC(REPLACE(SUBSTRING([IW].[UpHillBin1], 2, 1), '.', '')) = 1) AND (LEN(REPLACE(SUBSTRING([IW].[UpHillBin1], 2, 1), '.', '')) = 1)) THEN (CASE
					WHEN ((ISNUMERIC(REPLACE(SUBSTRING([IW].[UpHillBin1], 2, 2), '.', '')) = 1) AND (LEN(REPLACE(SUBSTRING([IW].[UpHillBin1], 2, 2), '.', '')) = 2)) THEN (CASE
						WHEN ((ISNUMERIC(REPLACE(SUBSTRING([IW].[UpHillBin1], 2, 3), '.', '')) = 1) AND (LEN(REPLACE(SUBSTRING([IW].[UpHillBin1], 2, 3), '.', '')) = 3)) THEN 3
						ELSE 2 END)
					ELSE 1 END)
				ELSE 0 END) AS [NSize]
			FROM (
				SELECT
					[IW].[DefaultBin]
					, SUBSTRING([IW].[DefaultBin], [IdxWH4] + LEN(@p_WH4), LEN([IW].DefaultBin) - [IdxWH4]) AS [UpHillBin1]
					, (CASE WHEN [IW].[SameBin] = 1 
						THEN [IW].[DefaultBin]
						ELSE SUBSTRING([IW].[DefaultBin], [IdxWH4] + LEN(@p_WH4), LEN([IW].DefaultBin) - [IdxWH4])
					END) AS [UpHillBin2],
					[IdxWH4]
				FROM (
					SELECT
						[IW].[DefaultBin]
						, CHARINDEX(@p_WH4, LOWER([IW].[DefaultBin]),1) AS [IdxWH4]
						, (CASE WHEN CHARINDEX(@p_WH4, LOWER([IW].[DefaultBin]),1) = 0 THEN 1 ELSE 0 END) AS [SameBin]
					FROM
						[SysproCompanyA].[dbo].[InvWarehouse] [IW]
					WHERE
						(LOWER([IW].[DefaultBin]) LIKE '%' + @p_WH4 + '%')
						OR (LOWER([IW].[DefaultBin]) LIKE '%@%')
					GROUP BY
						[IW].[DefaultBin]
				) AS [IW]
			) AS [IW]
		) AS [IW]
		INNER JOIN
			@known [K]
		ON
			LOWER(LEFT([K].[ParentShelf], 1)) = LOWER(LEFT([IW].[UpHillBin1], 1)) COLLATE DATABASE_DEFAULT
	) AS [IW]
) AS [IW]
WHERE
	LTRIM(RTRIM(ISNULL([IW].[DefaultBin], ''))) <> ''
ORDER BY
	[IW].[DefaultBin]

	
SELECT 
	*
FROM
	@toInsert [TI]
;
SELECT
	[Src].[Section],
	[Src].[NShelves],
	[Src].[Lowest],
	[Src].[Highest],
	[Src].[LowestIdx],
	[Src].[HighestIdx],
	1 + ([Src].[HighestIdx] - [Src].[LowestIdx]) AS [NVertShelvesInSec],
	[Src].[LowestSec],
	[Src].[HighestSec],
	[Src].[LowestSecIdx],
	[Src].[HighestSecIdx]
FROM (
	SELECT 
		[TI].[Section],
		[TI].[ShelfRow],
		COUNT(*) AS [NShelves],
		MIN([TI].[ShelfRow]) AS [Lowest],
		MAX([TI].[ShelfRow]) AS [Highest],
		(CASE WHEN LEN(MIN([TI].[ShelfRow])) = 1 THEN ASCII(MIN([TI].[ShelfRow])) ELSE 0 END) AS [LowestIdx],
		(CASE WHEN LEN(MAX([TI].[ShelfRow])) = 1 THEN ASCII(MAX([TI].[ShelfRow])) ELSE 0 END) AS [HighestIdx],
		MIN([TI].[ShelfRowSec]) AS [LowestSec],
		MAX([TI].[ShelfRowSec]) AS [HighestSec],
		(CASE WHEN LEN(MIN([TI].[ShelfRowSec])) = 1 THEN ASCII(MIN([TI].[ShelfRowSec])) ELSE 0 END) AS [LowestSecIdx],
		(CASE WHEN LEN(MAX([TI].[ShelfRowSec])) = 1 THEN ASCII(MAX([TI].[ShelfRowSec])) ELSE 0 END) AS [HighestSecIdx]
	FROM
		@toInsert [TI]
	WHERE
		LTRIM(RTRIM(LOWER([TI].[ShelfRow]))) NOT IN ('', 'wall', 'rack', 'office', 'top', 'floor', 'end', 'shelf', 'racktop', 'all', 'ffice', 'loor', 'hoserack', 'oserack')
	GROUP BY
		[TI].[Section],
		[TI].[ShelfRow]
) AS [Src]
WHERE
	([Src].[LowestIdx] * [Src].[HighestIdx]) <> 0

SELECT
	*
FROM (
	SELECT
		[TI].[Section] AS [TI_Section],
		NULL AS [ShelfSectionID],
		[TI].[Shelf] AS [TI_Shelf],
		[TI].[ShelfRow] AS [TI_ShelfRow],
		[TI].[ShelfRowSec] AS [TI_ShelfRowSec],
		[DB].[ID] AS [DB_ID],
		[DB].[Section] AS [DB_Section],
		[DB].[Shelf] AS [DB_Shelf],
		[DB].[ShelfRowID] AS [ShelfRowID],
		ROW_NUMBER() OVER(
			PARTITION BY
				[TI].[Section],
				[TI].[Shelf],
				[TI].[ShelfRow],
				[TI].[ShelfRowSec]
			ORDER BY
				(CASE WHEN [DB].[Shelf] IS NOT NULL THEN 0 ELSE 1 END)
		) AS [RN]
	FROM
		@toInsert [TI]
	LEFT JOIN (
		SELECT
			[Src].[Section],
			[Src].[ShelfRow],
			[Src].[NShelves],
			[Src].[Lowest],
			[Src].[Highest],
			[Src].[LowestIdx],
			[Src].[HighestIdx],
			1 + ([Src].[HighestIdx] - [Src].[LowestIdx]) AS [NVertShelvesInSec],
			[Src].[LowestSec],
			[Src].[HighestSec],
			[Src].[LowestSecIdx],
			[Src].[HighestSecIdx]
		FROM (
			SELECT 
				[TI].[Section],
				[TI].[ShelfRow],
				COUNT(*) AS [NShelves],
				MIN([TI].[ShelfRow]) AS [Lowest],
				MAX([TI].[ShelfRow]) AS [Highest],
				(CASE WHEN LEN(MIN([TI].[ShelfRow])) = 1 THEN ASCII(MIN([TI].[ShelfRow])) ELSE 0 END) AS [LowestIdx],
				(CASE WHEN LEN(MAX([TI].[ShelfRow])) = 1 THEN ASCII(MAX([TI].[ShelfRow])) ELSE 0 END) AS [HighestIdx],
				MIN([TI].[ShelfRowSec]) AS [LowestSec],
				MAX([TI].[ShelfRowSec]) AS [HighestSec],
				(CASE WHEN LEN(MIN([TI].[ShelfRowSec])) = 1 THEN ASCII(MIN([TI].[ShelfRowSec])) ELSE 0 END) AS [LowestSecIdx],
				(CASE WHEN LEN(MAX([TI].[ShelfRowSec])) = 1 THEN ASCII(MAX([TI].[ShelfRowSec])) ELSE 0 END) AS [HighestSecIdx]
			FROM
				@toInsert [TI]
			WHERE
				LTRIM(RTRIM(LOWER([TI].[ShelfRow]))) NOT IN ('', 'wall', 'rack', 'office', 'top', 'floor', 'end', 'shelf', 'racktop', 'all', 'ffice', 'loor', 'hoserack', 'oserack')
			GROUP BY
				[TI].[Section],
				[TI].[ShelfRow]
		) AS [Src]
		WHERE
			([Src].[LowestIdx] * [Src].[HighestIdx]) <> 0
	) AS [TISrc]
	ON
		([TI].[Section] = [TISrc].[Section])
		AND ([TI].[ShelfRow] = [TISrc].[ShelfRow])
	LEFT JOIN
		@dropBins [DB]
	ON
		([TI].[Section] = [DB].[Section])
		AND ((CASE WHEN [DB].[Shelf] IS NULL THEN 1 ELSE (CASE WHEN (LTRIM(RTRIM(LOWER(ISNULL([TI].[Section], '') + ISNULL([TI].[ShelfRow], ''))))) = LTRIM(RTRIM(LOWER([DB].[Shelf]))) THEN 1 ELSE 0 END) END) = 1)
) AS [Src]
LEFT JOIN
	[BWSdb].[dbo].[INV_WarehouseLayout_MontanaShelves] [MS] -- insert into
ON
	[Src].[TI_Shelf] = [MS].[Shelf]
WHERE
	([Src].[RN] = 1)
	AND ([MS].[Shelf] IS NULL)
ORDER BY
	[Src].[TI_Section],
	[Src].[TI_ShelfRow],
	[Src].[TI_ShelfRowSec],
	[Src].[TI_Shelf]

/*
INSERT INTO [BWSdb].[dbo].[INV_WarehouseLayout_MontanaShelves] ([Section], [ShelfSectionID], [Shelf], [ShelfRow]) VALUES
--('A', 92, 'WH4A1A', 6)
('A', 92, 'WH4A1C', 6)*/

/*
SELECT * FROM [BWSdb].[dbo].[INV_WarehouseLayout_MontanaShelves]; -- insert into
SELECT * FROM [BWSdb].[dbo].[INV_WarehouseShelfSections_Montana]; -- join on to determine the location
*/


BEGIN TRAN;
SELECT * FROM [BWSdb].[dbo].[INV_WarehouseLayout_MontanaShelves]; -- insert into
INSERT INTO [BWSdb].[dbo].[INV_WarehouseLayout_MontanaShelves] ([Section], [ShelfSectionID], [Shelf], [ShelfRow])
SELECT
	[Src].[TI_Section],
	[Src].[ShelfRowID],
	[Src].[TI_Shelf],
	[Src].[TI_ShelfRow]
FROM (
	SELECT
		[TI].[Section] AS [TI_Section],
		NULL AS [ShelfSectionID],
		[TI].[Shelf] AS [TI_Shelf],
		[TI].[ShelfRow] AS [TI_ShelfRow],
		[TI].[ShelfRowSec] AS [TI_ShelfRowSec],
		[DB].[ID] AS [DB_ID],
		[DB].[Section] AS [DB_Section],
		[DB].[Shelf] AS [DB_Shelf],
		[DB].[ShelfRowID] AS [ShelfRowID],
		ROW_NUMBER() OVER(
			PARTITION BY
				[TI].[Section],
				[TI].[Shelf],
				[TI].[ShelfRow],
				[TI].[ShelfRowSec]
			ORDER BY
				(CASE WHEN [DB].[Shelf] IS NOT NULL THEN 0 ELSE 1 END)
		) AS [RN]
	FROM
		@toInsert [TI]
	LEFT JOIN (
		SELECT
			[Src].[Section],
			[Src].[ShelfRow],
			[Src].[NShelves],
			[Src].[Lowest],
			[Src].[Highest],
			[Src].[LowestIdx],
			[Src].[HighestIdx],
			1 + ([Src].[HighestIdx] - [Src].[LowestIdx]) AS [NVertShelvesInSec],
			[Src].[LowestSec],
			[Src].[HighestSec],
			[Src].[LowestSecIdx],
			[Src].[HighestSecIdx]
		FROM (
			SELECT 
				[TI].[Section],
				[TI].[ShelfRow],
				COUNT(*) AS [NShelves],
				MIN([TI].[ShelfRow]) AS [Lowest],
				MAX([TI].[ShelfRow]) AS [Highest],
				(CASE WHEN LEN(MIN([TI].[ShelfRow])) = 1 THEN ASCII(MIN([TI].[ShelfRow])) ELSE 0 END) AS [LowestIdx],
				(CASE WHEN LEN(MAX([TI].[ShelfRow])) = 1 THEN ASCII(MAX([TI].[ShelfRow])) ELSE 0 END) AS [HighestIdx],
				MIN([TI].[ShelfRowSec]) AS [LowestSec],
				MAX([TI].[ShelfRowSec]) AS [HighestSec],
				(CASE WHEN LEN(MIN([TI].[ShelfRowSec])) = 1 THEN ASCII(MIN([TI].[ShelfRowSec])) ELSE 0 END) AS [LowestSecIdx],
				(CASE WHEN LEN(MAX([TI].[ShelfRowSec])) = 1 THEN ASCII(MAX([TI].[ShelfRowSec])) ELSE 0 END) AS [HighestSecIdx]
			FROM
				@toInsert [TI]
			WHERE
				LTRIM(RTRIM(LOWER([TI].[ShelfRow]))) NOT IN ('', 'wall', 'rack', 'office', 'top', 'floor', 'end', 'shelf', 'racktop', 'all', 'ffice', 'loor', 'hoserack', 'oserack')
			GROUP BY
				[TI].[Section],
				[TI].[ShelfRow]
		) AS [Src]
		WHERE
			([Src].[LowestIdx] * [Src].[HighestIdx]) <> 0
	) AS [TISrc]
	ON
		([TI].[Section] = [TISrc].[Section])
		AND ([TI].[ShelfRow] = [TISrc].[ShelfRow])
	LEFT JOIN
		@dropBins [DB]
	ON
		([TI].[Section] = [DB].[Section])
		AND ((CASE WHEN [DB].[Shelf] IS NULL THEN 1 ELSE (CASE WHEN (LTRIM(RTRIM(LOWER(ISNULL([TI].[Section], '') + ISNULL([TI].[ShelfRow], ''))))) = LTRIM(RTRIM(LOWER([DB].[Shelf]))) THEN 1 ELSE 0 END) END) = 1)
) AS [Src]
LEFT JOIN
	[BWSdb].[dbo].[INV_WarehouseLayout_MontanaShelves] [MS] -- insert into
ON
	[Src].[TI_Shelf] = [MS].[Shelf]
WHERE
	([Src].[RN] = 1)
	AND ([MS].[Shelf] IS NULL)
ORDER BY
	[Src].[TI_Section],
	[Src].[TI_ShelfRow],
	[Src].[TI_ShelfRowSec],
	[Src].[TI_Shelf]
;
SELECT * FROM [BWSdb].[dbo].[INV_WarehouseLayout_MontanaShelves]; -- insert into POST



SELECT * FROM [BWSdb].[dbo].[INV_WarehouseShelfSections_Montana]; -- join on to determine the location

ROLLBACK;
COMMIT;
