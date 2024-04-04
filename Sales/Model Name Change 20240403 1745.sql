USE BWSdb
GO

DECLARE @qs TABLE ([Q] INT);
DECLARE @ms TABLE ([M] NVARCHAR(MAX));

INSERT INTO @ms VALUES ('40HDC'), ('40TDP');
INSERT INTO @qs VALUES (30181), (30184);


SELECT * FROM [Standards] INNER JOIN @ms ON [Standards].[Model No] = [@ms].[M];
SELECT * FROM [Order Standards] INNER JOIN @ms ON [Order Standards].[Model No] = [@ms].[M] INNER JOIN @qs ON [Order Standards].[Quote#] = [@qs].[Q];

SELECT * FROM [Budget Options] INNER JOIN @ms ON [Budget Options].[Model No] = [@ms].[M];
SELECT * FROM [Options] INNER JOIN @ms ON [Options].[Model No] = [@ms].[M];
SELECT * FROM [Options_SpecLines] INNER JOIN @ms ON [Options_SpecLines].[Model No] = [@ms].[M];
SELECT * FROM [Options_FactoryLines] INNER JOIN @ms ON [Options_FactoryLines].[Model No] = [@ms].[M];

SELECT * FROM [Orders] INNER JOIN @qs ON [Orders].[Quote#] = [@qs].[Q];
SELECT * FROM [Order Options] INNER JOIN @qs ON [Order Options].[Quote#] = [@qs].[Q];
SELECT * FROM [Order Options_FactoryLines] INNER JOIN @qs ON [Order Options_FactoryLines].[Quote#] = [@qs].[Q];
SELECT * FROM [Order Options_SpecLines] INNER JOIN @qs ON [Order Options_SpecLines].[Quote#] = [@qs].[Q];