USE BWSdb
GO


SELECT * FROM [Sysprodb].[dbo].[AdmOperator] ORDER BY [Name]
SELECT * FROM [Employees] ORDER BY [2nd Name], [1st Name]
SELECT * FROM [SysproCompanyA].[dbo].[ClkEmployee] ORDER BY [Name]
SELECT * FROM [SysproCompanyA].[dbo].[BomEmployee] ORDER BY [Name]

DECLARE @SRC TABLE ([Emp#] REAL, [1st Name] NVARCHAR(250), [2nd Name] NVARCHAR(250), [Email] NVARCHAR(250));
INSERT INTO @SRC 
SELECT DISTINCT
	[Emp#] AS [Emp#],
	[dbo].ToProperCase(LTRIM(RTRIM(CASE WHEN [1st Name] IS NULL THEN (SELECT TOP 1 * FROM [dbo].split_string([Name], ' ')) ELSE [1st Name] END))) AS [1st Name],
	(CASE 
		WHEN 
			[dbo].ToProperCase(LTRIM(RTRIM(CASE WHEN [2nd Name] IS NULL THEN (SELECT TOP 1 [splited_data] FROM [dbo].split_string_idx([Name], ' ') ORDER BY [Idx] DESC) ELSE [2nd Name] END))) =
			[dbo].ToProperCase(LTRIM(RTRIM(CASE WHEN [1st Name] IS NULL THEN (SELECT TOP 1 * FROM [dbo].split_string([Name], ' ')) ELSE [1st Name] END)))
		THEN 
			NULL 
		ELSE 
			[dbo].ToProperCase(LTRIM(RTRIM(CASE WHEN [2nd Name] IS NULL THEN (SELECT TOP 1 [splited_data] FROM [dbo].split_string_idx([Name], ' ') ORDER BY [Idx] DESC) ELSE [2nd Name] END)))
	END) AS [2nd Name],
	[Email]
FROM
	[Sysprodb].[dbo].[AdmOperator]
LEFT JOIN
	[Employees]
ON
	[Sysprodb].[dbo].[AdmOperator].[Name] COLLATE DATABASE_DEFAULT = ([Employees].[1st Name] + ' ' + [Employees].[2nd Name]) COLLATE DATABASE_DEFAULT
;

SELECT * FROM @SRC

SELECT
	(CASE WHEN [Emp#] IS NULL THEN (
		CASE WHEN CAST(right('000' + [ClkEmployee].[Employee], 3) AS INT) = 0 THEN CAST(right('000' + [BomEmployee].[Employee], 3) AS INT) ELSE CAST(right('000' + [ClkEmployee].[Employee], 3) AS INT) END
	) ELSE [Emp#] END) AS [EMP#],
	[@SRC].[1st Name] + ' ' + [@SRC].[2nd Name] AS [Name],
	[Email],
	([@SRC].[2nd Name] + ', ' + [@SRC].[1st Name]) AS [A],
	[dbo].ToProperCase([SysproCompanyA].[dbo].[ClkEmployee].[Name]) AS [B],
	[SysproCompanyA].[dbo].[ClkEmployee].[Name] AS [C],
	[dbo].ToProperCase([SysproCompanyA].[dbo].[BomEmployee].[Name]) AS [D],
	[SysproCompanyA].[dbo].[BomEmployee].[Name] AS [E],
	[SysproCompanyA].[dbo].[ClkEmployee].[Name] AS [F],
	[SysproCompanyA].[dbo].[BomEmployee].[Name] AS [G]
FROM
	@SRC
LEFT JOIN
	[SysproCompanyA].[dbo].[ClkEmployee]
ON
	[dbo].ToProperCase([SysproCompanyA].[dbo].[ClkEmployee].[Name]) = ([@SRC].[2nd Name] + ', ' + [@SRC].[1st Name])
LEFT JOIN
	[SysproCompanyA].[dbo].[BomEmployee]
ON
	[dbo].ToProperCase([SysproCompanyA].[dbo].[BomEmployee].[Name]) = ([@SRC].[2nd Name] + ', ' + [@SRC].[1st Name])
ORDER BY
	[Email]

	
SELECT [Name] FROM [SysproCompanyA].[dbo].[BomEmployee] ORDER BY [Name]
SELECT [Name] FROM [SysproCompanyA].[dbo].[ClkEmployee] ORDER BY [Name]




	--(CASE WHEN [SysproCompanyA].[dbo].[ClkEmployee].[Name] IS NULL THEN [SysproCompanyA].[dbo].[BomEmployee].[Name] ELSE [SysproCompanyA].[dbo].[ClkEmployee].[Name] END)
--SELECT
--	(CASE WHEN [Emp#] IS NULL THEN (
--		CASE WHEN CAST(right('000' + [ClkEmployee].[Employee], 3) AS INT) = 0 THEN CAST(right('000' + [BomEmployee].[Employee], 3) AS INT) ELSE CAST(right('000' + [ClkEmployee].[Employee], 3) AS INT) END
--	) ELSE [Emp#] END) AS [Emp#],
--	(CASE WHEN (CASE WHEN [ClkEmployee].[Name] IS NULL THEN [BomEmployee].[Name] COLLATE DATABASE_DEFAULT ELSE [ClkEmployee].[Name] END) IS NULL THEN ([Employees].[1st Name] + ' ' + [Employees].[2nd Name]) COLLATE DATABASE_DEFAULT ELSE (CASE WHEN [ClkEmployee].[Name] IS NULL THEN [BomEmployee].[Name] COLLATE DATABASE_DEFAULT ELSE [ClkEmployee].[Name] COLLATE DATABASE_DEFAULT END) END) AS [Name],
--	[Email]
--FROM
--	[Sysprodb].[dbo].[AdmOperator]
--LEFT JOIN
--	[Employees]
--ON
--	[Sysprodb].[dbo].[AdmOperator].[Name] COLLATE DATABASE_DEFAULT = ([Employees].[1st Name] + ' ' + [Employees].[2nd Name]) COLLATE DATABASE_DEFAULT
----LEFT JOIN
----	[SysproCompanyA].[dbo].[ClkEmployee]
----ON
----	CAST(right('000' + [ClkEmployee].[Employee], 3) AS INT) = [Emp#]
----LEFT JOIN
----	[SysproCompanyA].[dbo].[BomEmployee]
----ON
----	CAST(right('000' + [BomEmployee].[Employee], 3) AS INT) = [Emp#]
--ORDER BY
--	[Email]
--	--(CASE WHEN [SysproCompanyA].[dbo].[ClkEmployee].[Name] IS NULL THEN [SysproCompanyA].[dbo].[BomEmployee].[Name] ELSE [SysproCompanyA].[dbo].[ClkEmployee].[Name] END)