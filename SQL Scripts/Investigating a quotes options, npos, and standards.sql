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

SELECT * FROM [Orders] INNER JOIN @t ON [Orders].[Quote#] = [@t].[Quote];
SELECT * FROM [Order Options] INNER JOIN @t ON [Order Options].[Quote#] = [@t].[Quote];
SELECT * FROM [Custom Work] INNER JOIN @t ON [Custom Work].[Quote#] = [@t].[Quote];
SELECT * FROM [Custom Work_FactoryLines] INNER JOIN @t ON [Custom Work_FactoryLines].[Quote#] = [@t].[Quote];
SELECT * FROM [Custom Work_SpecLines] INNER JOIN @t ON [Custom Work_SpecLines].[Quote#] = [@t].[Quote];
SELECT * FROM [Standards] INNER JOIN @m ON [Standards].[Model No] = [@m].[ModelName];