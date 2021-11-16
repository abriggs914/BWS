USE BWSdb
GO

SELECT * FROM [SysproCompanyA].[dbo].[BomEmployee]
SELECT * FROM [SysproCompanyA].[dbo].[ClkEmployee]
SELECT * FROM [Sysprodb].[dbo].[AdmOperator]
SELECT * FROM [Employees]



SELECT 
IIF([SysproCompanyA].[dbo].[ClkEmployee].[Name], [SysproCompanyA].[dbo].[BomEmployee].[Name], [SysproCompanyA].[dbo].[ClkEmployee].[Name]) AS [Name]
FROM [SysproCompanyA].[dbo].[BomEmployee]
INNER JOIN [SysproCompanyA].[dbo].[ClkEmployee]
ON
	[SysproCompanyA].[dbo].[BomEmployee].[Employee] = [SysproCompanyA].[dbo].[ClkEmployee].[Employee]

	
SELECT * FROM [Sysprodb].[dbo].[AdmOperator] ORDER BY [Name]
SELECT * FROM [Employees] ORDER BY [2nd Name], [1st Name]
SELECT * FROM [SysproCompanyA].[dbo].[ClkEmployee] ORDER BY [Name]
SELECT * FROM [SysproCompanyA].[dbo].[BomEmployee] ORDER BY [Name]
SELECT
	(CASE WHEN [Emp#] IS NULL THEN (
		CASE WHEN CAST(right('000' + [ClkEmployee].[Employee], 3) AS INT) = 0 THEN CAST(right('000' + [BomEmployee].[Employee], 3) AS INT) ELSE CAST(right('000' + [ClkEmployee].[Employee], 3) AS INT) END
	) ELSE [Emp#] END) AS [Emp#],
	(CASE WHEN (CASE WHEN [ClkEmployee].[Name] IS NULL THEN [BomEmployee].[Name] COLLATE DATABASE_DEFAULT ELSE [ClkEmployee].[Name] END) IS NULL THEN ([Employees].[1st Name] + ' ' + [Employees].[2nd Name]) COLLATE DATABASE_DEFAULT ELSE (CASE WHEN [ClkEmployee].[Name] IS NULL THEN [BomEmployee].[Name] COLLATE DATABASE_DEFAULT ELSE [ClkEmployee].[Name] COLLATE DATABASE_DEFAULT END) END) AS [Name],
	[Email]
FROM
	[Sysprodb].[dbo].[AdmOperator]
LEFT JOIN
	[Employees]
ON
	[Sysprodb].[dbo].[AdmOperator].[Name] COLLATE DATABASE_DEFAULT = ([Employees].[1st Name] + ' ' + [Employees].[2nd Name]) COLLATE DATABASE_DEFAULT
LEFT JOIN
	[SysproCompanyA].[dbo].[ClkEmployee]
ON
	CAST(right('000' + [ClkEmployee].[Employee], 3) AS INT) = [Emp#]
LEFT JOIN
	[SysproCompanyA].[dbo].[BomEmployee]
ON
	CAST(right('000' + [BomEmployee].[Employee], 3) AS INT) = [Emp#]
GROUP BY
	[Emp#], [Email], [BomEmployee].[Employee], [ClkEmployee].[Employee], [Employees].[1st Name], [Employees].[2nd Name], [ClkEmployee].[Name], [BomEmployee].[Name]
ORDER BY
	[Email]
	--(CASE WHEN [SysproCompanyA].[dbo].[ClkEmployee].[Name] IS NULL THEN [SysproCompanyA].[dbo].[BomEmployee].[Name] ELSE [SysproCompanyA].[dbo].[ClkEmployee].[Name] END)