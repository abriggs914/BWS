USE BWSdb
GO

SELECT * FROM [Prod Lines]

DECLARE @d1 AS DATETIME = '2021-01-01';
DECLARE @d2 AS DATETIME = '2023-12-31';

DECLARE @knownWOs AS TABLE ([ID] INT IDENTITY(1, 1), [WO] NVARCHAR(8))
INSERT INTO @knownWOs ([WO]) VALUES
('10015738'),
('10015745'),
('10015799'),
('10015765'),
('10015766'),
('10015767'),
('10015739'),
('10015746'),
('10015762'),
('10015764'),
('10015747'),
('10015768'),
('10015776'),
('10015777'),
('10015769'),
('10015782'),
('10015785'),
('10015830'),
('10015836'),
('10015761'),
('10015837')
;

DECLARE @editedWOs AS TABLE ([ID] INT IDENTITY(1, 1), [WO] NVARCHAR(8))
INSERT INTO @editedWOs ([WO]) VALUES
('10015938'),
('10015937'),
('10015936'),
('10015935'),
('10015916'),
('10015915'),
('10015803'),
('10015823'),
('10015806'),
('10015826'),
('10015877'),
('10015876'),
('10015875'),
('10015874'),
('10015864'),
('10015863'),
('10015846'),
('10015873'),
('10015872'),
('10015844'),
('10015878'),
('10015871'),
('10015870'),
('10015869'),
('10015842'),
('10015841'),
('10015861'),
('10015838'),
('10015800'),
('10015820'),
('10015829'),
('10015770'),
('10015809'),
('10015810')
;

BEGIN TRAN;
SELECT * FROM [dtProductionSchedule] WHERE [Beam Line] IN ('B3', 'B4') ORDER BY [Beam Date]--AND [Beam Date] IS NULL

UPDATE 
	[dtProductionSchedule]
SET
	[Beam Date] = NULL,
	[Beam Line] = NULL
WHERE
	[Beam Line] IN ('B3', 'B4')
	AND [Beam Date] > DATEADD(DAY, -5, DATEADD(MONTH, -1, GETDATE()))
SELECT * FROM [dtProductionSchedule] WHERE [Beam Line] IN ('B3', 'B4') ORDER BY [Beam Date]--AND [Beam Date] IS NULL


SELECT * FROM [Production] WHERE [Beam Line] IN ('B3', 'B4') ORDER BY [Beams]--AND [Beam Date] IS NULL

UPDATE 
	[Production]
SET
	[Beams] = NULL,
	[Beam Line] = NULL
WHERE
	[Beam Line] IN ('B3', 'B4')
	AND [Beams] > DATEADD(DAY, -5, DATEADD(MONTH, -1, GETDATE()))
SELECT * FROM [Production] WHERE [Beam Line] IN ('B3', 'B4') ORDER BY [Beams]--AND [Beam Date] IS NULL

ROLLBACK;
COMMIT;
	


SELECT [WO#], [Quote#], [Model No], [Beams], [Beam Line] FROM [Production] WHERE [Beam Line] IN ('B3', 'B4') ORDER BY [Beams] DESC--AND [Beams] IS NULL
SELECT [WO#], [Quote#], [InputField1], [Beam Date], [Beam Line] FROM [dtProductionSchedule] WHERE [Beam Line] IN ('B3', 'B4') ORDER BY [Beam Date] DESC--AND [Beam Date] IS NULL
SELECT * FROM [Prod Sched Version#] WHERE [Beam] IN ('B3', 'B4') AND [Beams] IS NULL

SELECT * FROM [Prod Sched]
exec [sp_ProductionSchedule V4_Slots] '2022-07-20', '2022-08-25'


BEGIN TRAN;

SELECT * FROM [Production] INNER JOIN @editedWOs ON [Production].[WO#] = [@editedWOs].[WO]

UPDATE
	[Production]
SET
	[Beam Line] = NULL
	, [Beams] = NULL
FROM
	[Production]
INNER JOIN
	@editedWOs
ON
	[Production].[WO#] = [@editedWOs].[WO]


SELECT * FROM [Production] INNER JOIN @editedWOs ON [Production].[WO#] = [@editedWOs].[WO]

ROLLBACK;
COMMIT;





SELECT
	*
FROM (
	SELECT
		[Orders].[WO#]
		, [Beams]
		--, [Prodution].[Delivery Date]
	FROM
		[Production]
	LEFT JOIN
		[Orders]
	ON
		[Production].[WO#] = [Orders].[WO#]
	LEFT JOIN
		[Dealers]
	ON
		[Orders].[DealerID] = [Dealers].[ID]
	WHERE
		[Beam Line] IN ('B3','B4')
		AND ISNULL([Beams], DATEADD(YEAR, 1, GETDATE())) > GETDATE()
		AND ISNULL([Production].[Delivery Date], DATEADD(YEAR, 1, GETDATE())) > GETDATE()
) AS [SrcA]
LEFT JOIN 
	@knownWOs
ON
	[SrcA].[WO#] = [@knownWOs].[WO]
WHERE
	[@knownWOs].[WO] IS NULL



SELECT * FROM [Production] INNER JOIN @knownWOs ON [Production].[WO#] = [@knownWOs].[WO]

BEGIN TRAN;

UPDATE
	[Production]
SET
	[Beam Line] = NULL
	, [Beams] = NULL
FROM
	[Production]
INNER JOIN
	@knownWOs
ON
	[Production].[WO#] = [@knownWOs].[WO]


SELECT * FROM [Production] INNER JOIN @knownWOs ON [Production].[WO#] = [@knownWOs].[WO]

ROLLBACK;
COMMIT;





SELECT
	[dtProductionSchedule].[Quote#]
	,[dtProductionSchedule].[WO#]
	,[Orders].[Model No]
	,[Beam Line]
	,[GN Line]
	,[Other Line]
	,[WO Line 1]
	,[WO Line 2]
	,[Beam Date]
	,[GN Date]
	,[Other Date]
	,[Prod Date 1]
	,[Prod Date 2]
	,[Delivery Date]
FROM
	[dtProductionSchedule]
LEFT JOIN
	[Orders]
ON
	[dtProductionSchedule].[WO#] = [Orders].[WO#]
WHERE
	([Beam Line] IN ('B3','B4')
	OR [GN Line] IN ('B3','B4')
	OR [Other Line] IN ('B3','B4')
	OR [WO Line 1] IN ('B3','B4')
	OR [WO Line 2] IN ('B3','B4'))
	--AND (ISNULL([Beam Date], GETDATE()) BETWEEN @d1 AND @d2
	--OR ISNULL([Prod Date 1], GETDATE()) BETWEEN @d1 AND @d2
	--OR ISNULL([Prod Date 2], GETDATE()) BETWEEN @d1 AND @d2
	--OR ISNULL([GN Date], GETDATE()) BETWEEN @d1 AND @d2
	--OR ISNULL([Other Date], GETDATE()) BETWEEN @d1 AND @d2)
	AND ISNULL([Beam Date], DATEADD(YEAR, 1, GETDATE())) > GETDATE()
	AND ISNULL([Delivery Date], DATEADD(YEAR, 1, GETDATE())) > GETDATE()
ORDER BY [Delivery Date] DESC


SELECT
	[dtProductionSchedule].[Quote#]
	,[dtProductionSchedule].[WO#]
	,[Orders].[Model No]
	,[Beam Line]
	,[GN Line]
	,[Other Line]
	,[WO Line 1]
	,[WO Line 2]
	,[Beam Date]
	,[GN Date]
	,[Other Date]
	,[Prod Date 1]
	,[Prod Date 2]
	,[Delivery Date]
FROM
	[dtProductionSchedule]
LEFT JOIN
	[Orders]
ON
	[dtProductionSchedule].[WO#] = [Orders].[WO#]
INNER JOIN
	@knownWOs
ON
	[dtProductionSchedule].[WO#] = [@knownWOs].[WO]
--WHERE
--	([Beam Line] IN ('B3','B4')
--	OR [GN Line] IN ('B3','B4')
--	OR [Other Line] IN ('B3','B4')
--	OR [WO Line 1] IN ('B3','B4')
--	OR [WO Line 2] IN ('B3','B4'))
--	AND ([Beam Date] BETWEEN @d1 AND @d2
--	OR [Prod Date 1]BETWEEN @d1 AND @d2
--	OR [Prod Date 2] BETWEEN @d1 AND @d2
--	OR [GN Date] BETWEEN @d1 AND @d2
--	OR [Other Date] BETWEEN @d1 AND @d2)
--	--AND ISNULL([Delivery Date], DATEADD(YEAR, 1, GETDATE())) > GETDATE()
ORDER BY [Delivery Date] DESC



SELECT
	[dtProductionSchedule].[Quote#]
	,[dtProductionSchedule].[WO#]
	,[Orders].[Model No]
	,[dealers].[COMPANY NAME]
	,[Beam Line]
	,[Beam Date]
	,[GN Line]
	,[GN Date]
	,[Other Line]
	,[Other Date]
	,[WO Line 1]
	,[Prod Date 1]
	,[WO Line 2]
	,[Prod Date 2]
	,[Delivery Date]
FROM
	[dtProductionSchedule]
LEFT JOIN
	[Orders]
ON
	[dtProductionSchedule].[WO#] = [Orders].[WO#]
LEFT JOIN
	[Dealers]
ON
	[Orders].[DealerID] = [Dealers].[ID]
WHERE
	[Beam Line] IN ('B3','B4')
	AND ISNULL([Beam Date], DATEADD(YEAR, 1, GETDATE())) > GETDATE()
	AND ISNULL([Delivery Date], DATEADD(YEAR, 1, GETDATE())) > GETDATE()
ORDER BY [Delivery Date] DESC


BEGIN TRAN;


SELECT
	[dtProductionSchedule].[Quote#]
	,[dtProductionSchedule].[WO#]
	,[Orders].[Model No]
	,[dealers].[COMPANY NAME]
	,[Beam Line]
	,[Beam Date]
	,[GN Line]
	,[GN Date]
	,[Other Line]
	,[Other Date]
	,[WO Line 1]
	,[Prod Date 1]
	,[WO Line 2]
	,[Prod Date 2]
	,[Delivery Date]
FROM
	[dtProductionSchedule]
LEFT JOIN
	[Orders]
ON
	[dtProductionSchedule].[WO#] = [Orders].[WO#]
LEFT JOIN
	[Dealers]
ON
	[Orders].[DealerID] = [Dealers].[ID]
WHERE
	[Beam Line] IN ('B3','B4')
	AND ISNULL([Beam Date], DATEADD(YEAR, 1, GETDATE())) > GETDATE()
	AND ISNULL([Delivery Date], DATEADD(YEAR, 1, GETDATE())) > GETDATE()
ORDER BY [Delivery Date] DESC

UPDATE
	[dtProductionSchedule]
SET
	[Beam Line] = NULL
FROM 
	[dtProductionSchedule]
LEFT JOIN
	[Orders]
ON
	[dtProductionSchedule].[WO#] = [Orders].[WO#]
WHERE
	[Beam Line] IN ('B3','B4')
	AND ISNULL([Beam Date], DATEADD(YEAR, 1, GETDATE())) > GETDATE()
	AND ISNULL([Delivery Date], DATEADD(YEAR, 1, GETDATE())) > GETDATE()


SELECT
	[dtProductionSchedule].[Quote#]
	,[dtProductionSchedule].[WO#]
	,[Orders].[Model No]
	,[dealers].[COMPANY NAME]
	,[Beam Line]
	,[Beam Date]
	,[GN Line]
	,[GN Date]
	,[Other Line]
	,[Other Date]
	,[WO Line 1]
	,[Prod Date 1]
	,[WO Line 2]
	,[Prod Date 2]
	,[Delivery Date]
FROM
	[dtProductionSchedule]
LEFT JOIN
	[Orders]
ON
	[dtProductionSchedule].[WO#] = [Orders].[WO#]
LEFT JOIN
	[Dealers]
ON
	[Orders].[DealerID] = [Dealers].[ID]
WHERE
	[Beam Line] IN ('B3','B4')
	AND ISNULL([Beam Date], DATEADD(YEAR, 1, GETDATE())) > GETDATE()
	AND ISNULL([Delivery Date], DATEADD(YEAR, 1, GETDATE())) > GETDATE()
ORDER BY [Delivery Date] DESC

ROLLBACK;
COMMIT;
