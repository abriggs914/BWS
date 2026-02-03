
-- Grouping WH4 bins for plotting

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

SELECT
	[IW].[DefaultBin],
	[IW].[UpHillBin1],
	[IW].[UpHillBin2],
	[IW].[ID],
	[IW].[ParentShelf],
	CAST((CASE WHEN [ShelfRowIsNum] = 1 THEN [ShelfRow] ELSE '0' END) AS INT) AS [ShelfRow],
	(CASE WHEN [ShelfRowIsNum] = 1 THEN SUBSTRING([UpHillBin1], 2, 1) ELSE NULL END) AS [ShelfRowSec],
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
ORDER BY
	[IW].[DefaultBin]


SELECT * FROM [BWSdb].[dbo].[INV_WarehouseLayout_MontanaShelves]; -- insert into
SELECT * FROM [BWSdb].[dbo].[INV_WarehouseShelfSections_Montana]; -- join on to determine the location