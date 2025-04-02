
--BEGIN TRAN;

DECLARE @changes TABLE ([ID] INT IDENTITY(0, 1), [Line] NVARCHAR(MAX), [Order] INT)
INSERT INTO @changes ([Line], [Order]) VALUES
	('T1', 1),
	('T2', 2),
	('T3', 3),
	('T4', 4),
	('T5', 5),
	('T6', 6),
	('T7', 7),
	('T8', 8),
	('T9', 9),
	('T14', 10),
	('T15', 11),
						   
	('AL1', 12),
	('AL2', 13),
	
	('GNK1', 14),
	('GNK2', 15),
	('GNK3', 16),
	('B1', 17),
	('B2', 18),
	('B3', 19),
	('T10', 20),
	('T11', 21),
	('T12', 22),

	--when 'TT1' then 23
	--when 'TT2' then 24
	
	('TS1', 25),
	('TS2', 26),
	('B4' ,27),
	('TBF', 28),
	('PBF', 29),
	('TS3', 30),
	('SCREENERS', 31)


DECLARE @idOffset INT;
SELECT
	@idOffset = MAX([Order]) + 1
FROM
	@changes
GROUP BY
	[Order]

SELECT
	*
	-- This new ID will either be from the @changes table, or it will be offset by the total number of changes.
	, (CASE WHEN [C].[Line] IS NULL THEN @idOffset + [PL].[LO] ELSE [C].[Order] END) AS [NewID]
FROM
	[BWSdb].[dbo].[Prod Lines] [PL]
LEFT JOIN
	@changes [C]
ON
	[PL].[Prod Line] = [C].[Line]
ORDER BY
	ISNULL([C].[Order], 99),
	[C].[Order]
;
/*
UPDATE
	[BWSdb].[dbo].[Prod Lines]
SET 
	[LO] = (CASE WHEN [C].[Line] IS NULL THEN @idOffset + [PL].[LO] ELSE [C].[Order] END)
FROM 
	[BWSdb].[dbo].[Prod Lines] [PL]
LEFT JOIN
	@changes [C]
ON
	[PL].[Prod Line] = [C].[Line]
;
	

SELECT
	*
	-- This new ID will either be from the @changes table, or it will be offset by the total number of changes.
	, (CASE WHEN [C].[Line] IS NULL THEN @idOffset + [PL].[LO] ELSE [C].[Order] END) AS [NewID]
FROM
	[BWSdb].[dbo].[Prod Lines] [PL]
LEFT JOIN
	@changes [C]
ON
	[PL].[Prod Line] = [C].[Line]
ORDER BY
	ISNULL([C].[Order], 99),
	[C].[Order]
;

ROLLBACK;
COMMIT;
*/