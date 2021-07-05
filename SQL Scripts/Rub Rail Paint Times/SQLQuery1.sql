USE BWSdb
GO

SELECT
	*
FROM
	[Options]
WHERE
	[Description] LIKE '%rub%'
	AND [Description] LIKE '%rail%'
	AND [Description] LIKE '%pockets%'
;

SELECT
	*
FROM
	[Order Options]
WHERE
	[Description] LIKE '%rub%'
	AND [Description] LIKE '%rail%'
	AND [Description] LIKE '%pockets%'
ORDER BY [Quote Date]
;

--1,2,3,4,19,20,29,30,33,34,37,52,53
SELECT
	[Quote Date],
	[Order Date],
	[ID#],
	[oh].[Quote#],
	[oh].[WO#],
	[oh].[Blast] AS [WO Blast],
	[oo].[Blast] AS [OP Blast],
	[oh].[Paint] AS [WO Paint],
	[oo].[Paint] AS [OP Paint],
	[Option No],
	[Description],
	[Price]
FROM
	[Order Hours] as oh
INNER JOIN
	[Order Options] as oo
ON
	[oh].[WO#] = [oo].[WO#]
INNER JOIN
	[Products] AS [pr]
ON
	[]
WHERE
	[Description] LIKE '%rub%'
	AND [Description] LIKE '%rail%'
	AND [Description] LIKE '%pockets%'
ORDER BY
	[Quote Date], [Order Date], [Option No]
;

SELECT * FROM [Products];
SELECT * FROM [Order Options];
SELECT * FROM [Order Hours];
SELECT SUM([Quote#]) FROM [Order Hours];
SELECT SUM([WO#]) FROM [Order Hours];
SELECT * FROM [Work Hours];