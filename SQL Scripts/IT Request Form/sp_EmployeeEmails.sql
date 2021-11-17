USE BWSdb
GO

ALTER PROCEDURE [dbo].[sp_EmployeeEmails]
	
AS
BEGIN
	
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

	SELECT
		(CASE WHEN [Emp#] IS NULL THEN (
			CASE WHEN CAST(right('000' + [ClkEmployee].[Employee], 3) AS INT) = 0 THEN CAST(right('000' + [BomEmployee].[Employee], 3) AS INT) ELSE CAST(right('000' + [ClkEmployee].[Employee], 3) AS INT) END
		) ELSE [Emp#] END) AS [EMP#],
		[@SRC].[1st Name] + ' ' + [@SRC].[2nd Name] AS [Name],
		[Email]
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
	WHERE
		([Emp#] IS NOT NULL AND [Emp#] <> '') OR ([@SRC].[1st Name] + ' ' + [@SRC].[2nd Name] IS NOT NULL AND [@SRC].[1st Name] + ' ' + [@SRC].[2nd Name] <> '') OR ([Email] IS NOT NULL AND [Email] <> '')
	ORDER BY
		(CASE WHEN [@SRC].[1st Name] + ' ' + [@SRC].[2nd Name] IS NULL THEN 1 ELSE 0 END)
END