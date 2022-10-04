USE BWSdb
GO

DECLARE @t AS TABLE ([ID] INT IDENTITY(1, 1), [Quote] INT);
INSERT INTO @t	([Quote]) VALUES
(26491)
--,
--(26492)
;
DECLARE @m AS TABLE ([ID] INT IDENTITY(1, 1), [ModelName] NVARCHAR(MAX));
INSERT INTO @m ([ModelName])
SELECT DISTINCT
	[Model No]
FROM
	[Orders]
INNER JOIN
	@t
ON 
	[Orders].[Quote#] = [@t].[Quote];
	
SELECT '@t X @m' AS [Table], * FROM @t CROSS JOIN @m;
SELECT '[Orders] & @t' AS [Table], * FROM [Orders] INNER JOIN @t ON [Orders].[Quote#] = [@t].[Quote];
SELECT '[Order Options] & @t' AS [Table], * FROM [Order Options] INNER JOIN @t ON [Order Options].[Quote#] = [@t].[Quote];
SELECT '[Custom Work] & @t' AS [Table], * FROM [Custom Work] INNER JOIN @t ON [Custom Work].[Quote#] = [@t].[Quote];
SELECT '[Custom Work_FactoryLines] & @t' AS [Table], * FROM [Custom Work_FactoryLines] INNER JOIN @t ON [Custom Work_FactoryLines].[Quote#] = [@t].[Quote];
SELECT '[Custom Work_SpecLines] & @t' AS [Table], * FROM [Custom Work_SpecLines] INNER JOIN @t ON [Custom Work_SpecLines].[Quote#] = [@t].[Quote];
SELECT '[Standards] & @m' AS [Table], * FROM [Standards] INNER JOIN @m ON [Standards].[Model No] = [@m].[ModelName];



----------------------------





DECLARE @u AS TABLE ([ID] INT IDENTITY(1, 1), [WO] NVARCHAR(MAX));
INSERT INTO @u ([WO]) VALUES
('10016045')
--,
--('10016046')
;
DECLARE @n AS TABLE ([ID] INT IDENTITY(1, 1), [ModelName] NVARCHAR(MAX));
INSERT INTO @n ([ModelName])
SELECT DISTINCT
	[Model No]
FROM
	[Orders]
INNER JOIN
	@u
ON 
	[Orders].[WO#] = [@u].[WO]

SELECT '@u X @c' AS [Table], * FROM @u CROSS JOIN @n;
SELECT '[Orders] & @u' AS [Table], * FROM [Orders] INNER JOIN @u ON [Orders].[WO#] = [@u].[WO];
SELECT '[Order Options] & @u' AS [Table], * FROM [Order Options] INNER JOIN @u ON [Order Options].[WO#] = [@u].[WO];
SELECT '[Custom Work] & @u' AS [Table], * FROM [Custom Work] INNER JOIN @u ON [Custom Work].[WO#] = [@u].[WO];
SELECT '[Custom Work_FactoryLines] & @u' AS [Table], * FROM [Custom Work_FactoryLines] INNER JOIN @u ON [Custom Work_FactoryLines].[WO#] = [@u].[WO];
SELECT '[Custom Work_SpecLines] & @u' AS [Table], * FROM [Custom Work_SpecLines] INNER JOIN @u ON [Custom Work_SpecLines].[WO#] = [@u].[WO];
SELECT '[Standards] & @n' AS [Table], * FROM [Standards] INNER JOIN @n ON [Standards].[Model No] = [@n].[ModelName];

SELECT '[Orders] & @t' AS [Table], * FROM Orders INNER JOIN @t ON [Orders].[Quote#] = [@t].[Quote]
--SELECT '[Orders]' AS [Table], * FROM Orders WHERE [Quote#] = 26491 OR [WO#] = 10016045

DECLARE @d1 AS TABLE ([ID] INT IDENTITY(1, 1), [DealerID] INT, [DealerName] NVARCHAR(MAX));
INSERT INTO @d1 ([DealerID], [DealerName])
SELECT DISTINCT
	[DealerID],
	[COMPANY NAME]
FROM
	[Orders]
INNER JOIN
	[Dealers]
ON 
	[Orders].[DealerID] = [Dealers].[ID]
INNER JOIN
	@t
ON
	[Orders].[Quote#] = [@t].[Quote];

SELECT '@d & [Orders] & @t' AS [Table], * FROM @d1;


DECLARE @d2 AS TABLE ([ID] INT IDENTITY(1, 1), [DealerID] INT, [DealerName] NVARCHAR(MAX));
INSERT INTO @d2 ([DealerID], [DealerName])
SELECT DISTINCT
	[DealerID],
	[COMPANY NAME]
FROM
	[Orders]
INNER JOIN
	[Dealers]
ON 
	[Orders].[DealerID] = [Dealers].[ID]
INNER JOIN
	@u
ON
	[Orders].[WO#] = [@u].[WO];

SELECT '@d & [Orders] & @u' AS [Table], * FROM @d2;


SELECT '26491 & 26492 & 26941 & 26942' AS [Table], * FROM [Orders] WHERE [Quote#] IN (26491, 26492, 26941, 26942);

--BEGIN TRAN;

--UPDATE
--	[Orders]
--SET
--	[DealerID] = 259
--WHERE
--	[Quote#] = 26942


--DELETE FROM @d2 WHERE 1=1;


--INSERT INTO @d2 ([DealerID], [DealerName])
--SELECT DISTINCT
--	[DealerID],
--	[COMPANY NAME]
--FROM
--	[Orders]
--INNER JOIN
--	[Dealers]
--ON 
--	[Orders].[DealerID] = [Dealers].[ID]
--INNER JOIN
--	@u
--ON
--	[Orders].[WO#] = [@u].[WO];

--SELECT '@d & [Orders] & @u' AS [Table], * FROM @d2;


--ROLLBACK;
--COMMIT;