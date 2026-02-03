SELECT
	*
FROM
	[BWSdb].[dbo].[INV_WarehouseLayout_Legend]
;


SELECT * FROM [INV_WarehouseLayout_MontanaShelves];


/*
DECLARE @t TABLE (
	[Key] NVARCHAR(MAX),
	[Value] NVARCHAR(MAX),
	[IsPath] BIT,
	[BG] NVARCHAR(MAX),
	[FG] NVARCHAR(MAX)
)
INSERT INTO @t ([Key], [Value], [IsPath], [BG], [FG]) VALUES
('0', 'Path', '1', 'BFBFBF', '#FFFFFF'),
('BL', 'Blocked', NULL, '#747474', '#FFFFFF'),
('OH', 'Overhead Door', '1', '#C00000', '#000000'),
('MD', 'Man Door', '1', '#C00000', '#000000'),
('WS', 'Workstation', NULL, '#3C7D22', '#FFFFFF'),
('SS', 'Shopstation', NULL, '#002060', '#FFFFFF'),
('TR', 'Tool Room', '1', '#747474', '#FFFFFF'),
('FN', 'Fastenal', NULL, '#215C98', '#FFFFFF'),
('BC', 'Box Crusher', NULL, '#747474', '#FFFFFF'),
('SH', 'Storage Shelf', NULL, '#747474', '#FFFFFF'),
('A', 'Shelf A', NULL, '#F1A983', '#000000'),
('B', 'Shelf B', NULL, '#83E28E', '#000000'),
('C', 'Shelf C', NULL, '#E49EDD', '#000000'),
('D', 'Shelf D', NULL, '#83CCEB', '#000000'),
('E', 'Shelf E', NULL, '#FFFF99', '#000000'),
('F', 'Shelf F', NULL, '#DE8686', '#000000'),
('G', 'Shelf G', NULL, '#AA9FFB', '#000000'),
('H', 'Shelf H', NULL, '#F8AAC2', '#000000'),
('I', 'Shelf I', NULL, '#8ED973', '#000000'),
('J', 'Shelf J', NULL, '#FF8888', '#000000'),
('K', 'Shelf E', NULL, '#EE8899', '#000000'),
('L', 'Shelf L', NULL, '#DD88AA', '#000000'),
('M', 'Shelf M', NULL, '#CC88BB', '#000000'),
('N', 'Shelf N', NULL, '#BB88CC', '#000000'),
('O', 'Shelf O', NULL, '#AA88DD', '#000000'),
('P', 'Shelf P', NULL, '#9988EE', '#000000'),
('Q', 'Shelf Q', NULL, '#8888FF', '#000000'),
('R', 'Shelf R', NULL, '#B9E4FF', '#000000'),
('S', 'Shelf S', NULL, '#32AA26', '#000000'),
('T', 'Shelf T', NULL, '#309B36', '#000000'),
('U', 'Shelf U', NULL, '#2F8C47', '#000000'),
('V', 'Shelf V', NULL, '#2D7D57', '#000000'),
('W', 'Shelf W', NULL, '#2C6E68', '#000000'),
('X', 'Shelf X', NULL, '#2A5F78', '#000000'),
('Y', 'Shelf Y', NULL, '#295089', '#000000'),
('Z', 'Shelf Z', NULL, '#274199', '#000000'),
('TT', 'Shelf TT', NULL, '#2632AA', '#000000')


INSERT INTO [BWSdb].[dbo].[INV_WarehouseLayout_Legend]
([Key], [Value], [IsPath], [BG], [FG])
SELECT
	[T].[Key],
	[T].[Value], 
	[T].[IsPath], 
	[T].[BG],
	[T].[FG]
FROM
	[BWSdb].[dbo].[INV_WarehouseLayout_Legend] [L]
FULL JOIN
	@t [T]
ON
	[L].[Key] = [T].[Key]
WHERE
	[L].[Key] IS NULL
*/