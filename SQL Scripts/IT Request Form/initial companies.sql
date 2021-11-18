USE BWSdb
GO

DECLARE @SRC TABLE ([ID] INT PRIMARY KEY IDENTITY(1, 1) NOT NULL, [Emp#] REAL, [NameFromSyspro] NVARCHAR(250), [1st Name] NVARCHAR(250), [2nd Name] NVARCHAR(250), [Email] NVARCHAR(250), [InitCompany] NVARCHAR(250));
INSERT INTO @SRC 
SELECT DISTINCT
	[Emp#] AS [Emp#],
	[AdmOperator].[Name] AS [NameFromSyspro],
	LTRIM(RTRIM([dbo].ToProperCase(CASE WHEN [1st Name] IS NULL THEN (SELECT TOP 1 * FROM [dbo].split_string([Name], ' ')) ELSE [1st Name] END))) AS [1st Name],
	LTRIM(RTRIM((CASE 
		WHEN 
			[dbo].ToProperCase(LTRIM(RTRIM(CASE WHEN [2nd Name] IS NULL THEN (((SELECT TOP 1 [splited_data] FROM [dbo].split_string_idx([Name], ' ') ORDER BY [Idx] DESC))) ELSE [2nd Name] END))) =
			[dbo].ToProperCase(LTRIM(RTRIM(CASE WHEN [1st Name] IS NULL THEN (SELECT TOP 1 * FROM [dbo].split_string([Name], ' ')) ELSE [1st Name] END)))
		THEN 
			NULL 
		ELSE 
			[dbo].ToProperCase(LTRIM(RTRIM(CASE WHEN [2nd Name] IS NULL THEN (SELECT TOP 1 [splited_data] FROM [dbo].split_string_idx([Name], ' ') ORDER BY [Idx] DESC) ELSE [2nd Name] END)))
	END))) AS [2nd Name],
	[Email] COLLATE DATABASE_DEFAULT,
	'BWS' AS [InitCompany]
FROM
	[Sysprodb].[dbo].[AdmOperator]
LEFT JOIN
	[Employees]
ON
	[Sysprodb].[dbo].[AdmOperator].[Name] COLLATE DATABASE_DEFAULT = ([Employees].[1st Name] + ' ' + [Employees].[2nd Name]) COLLATE DATABASE_DEFAULT
WHERE
	[Email] IS NOT NULL AND LTRIM(RTRIM([Email])) != '' AND LEN(LTRIM(RTRIM([Email]))) > 3
;

INSERT INTO @SRC
SELECT DISTINCT
	[Emp#] AS [Emp#],
	[AdmOperator].[Name] AS [NameFromSyspro],
	LTRIM(RTRIM([dbo].ToProperCase(CASE WHEN [1st Name] IS NULL THEN (SELECT TOP 1 * FROM [dbo].split_string([Name], ' ')) ELSE [1st Name] END))) AS [1st Name],
	LTRIM(RTRIM((CASE 
		WHEN 
			[dbo].ToProperCase(LTRIM(RTRIM(CASE WHEN [2nd Name] IS NULL THEN (((SELECT TOP 1 [splited_data] FROM [dbo].split_string_idx([Name], ' ') ORDER BY [Idx] DESC))) ELSE [2nd Name] END))) =
			[dbo].ToProperCase(LTRIM(RTRIM(CASE WHEN [1st Name] IS NULL THEN (SELECT TOP 1 * FROM [dbo].split_string([Name], ' ')) ELSE [1st Name] END)))
		THEN 
			NULL 
		ELSE 
			[dbo].ToProperCase(LTRIM(RTRIM(CASE WHEN [2nd Name] IS NULL THEN (SELECT TOP 1 [splited_data] FROM [dbo].split_string_idx([Name], ' ') ORDER BY [Idx] DESC) ELSE [2nd Name] END)))
	END))) AS [2nd Name],
	[Email] COLLATE DATABASE_DEFAULT,
	'STARGATE' AS [InitCompany]
FROM
	[Sysprodb].[dbo].[AdmOperator]
LEFT JOIN
	[Stargatedb].[dbo].[Employees]
ON
	[Sysprodb].[dbo].[AdmOperator].[Name] COLLATE DATABASE_DEFAULT = ([Employees].[1st Name] + ' ' + [Employees].[2nd Name]) COLLATE DATABASE_DEFAULT
WHERE
	[Email] IS NOT NULL AND LTRIM(RTRIM([Email])) != '' AND LEN(LTRIM(RTRIM([Email]))) > 3
	AND [Email] COLLATE DATABASE_DEFAULT NOT IN (SELECT [Email] COLLATE DATABASE_DEFAULT FROM @SRC)

SELECT * FROM @SRC ORDER BY [InitCompany]

DECLARE @table TABLE
    (ID int PRIMARY KEY
            IDENTITY(1, 1)
            NOT NULL,
     number int NOT NULL)
INSERT @table(number) VALUES(1)
INSERT @table(number) VALUES(2)
INSERT @table(number) VALUES(3)
INSERT @table(number) VALUES(1)
INSERT @table(number) VALUES(2)
INSERT @table(number) VALUES(3)
INSERT @table(number) VALUES(4)
INSERT @table(number) VALUES(2)
INSERT @table(number) VALUES(3)
INSERT @table(number) VALUES(4)
INSERT @table(number) VALUES(8)
INSERT @table(number) VALUES(9)
INSERT @table(number) VALUES(10);