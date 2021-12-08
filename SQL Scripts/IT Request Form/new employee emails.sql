USE BWSdb
GO

EXEC [dbo].[sp_EmployeeEmails]

SELECT DISTINCT [Name], [Location], [Email] FROM [Sysprodb].[dbo].[AdmOperator] WHERE [Email] IS NOT NULL AND [Email] <> ''
SELECT DISTINCT * FROM [Sysprodb].[dbo].[AdmOperator] WHERE [Email] IS NOT NULL AND [Email] <> ''
SELECT DISTINCT [dbo].[ToProperCase]([Name]) FROM [Sysprodb].[dbo].[AdmOperator]

DECLARE @ValidStatus TABLE ([Code] NVARCHAR(MAX));
INSERT INTO @ValidStatus
SELECT [Status Code] FROM [Status] WHERE [Status Code] NOT IN (('L'), ('LD'), ('Q'), ('T'), ('EFR'))


SELECT
	[Company],
	[2nd Name],
	[1st Name],
	[NameConcat],
	[Dept],
	MAX([Emp#]) AS [Emp#],
	[C],
	MAX([Date Hired]) AS [Date Hired],
	[Email]
FROM (
	SELECT 
		ROW_NUMBER() OVER(
			PARTITION BY
				[Company],
				[2nd Name],
				[1st Name],
				[NameConcat],
				[C]
			ORDER BY
				[Date Hired] DESC
		) AS [Row#],
		[Company],
		[2nd Name],
		[1st Name],
		[NameConcat],
		MAX([Emp#]) AS [Emp#],
		[Dept],
		[C],
		[Date Hired]
	FROM (
		SELECT 
			'BWS' AS [Company],
			[dbo].[ToProperCase]([2nd Name]) AS [2nd Name],
			[dbo].[ToProperCase]([1st Name]) AS [1st Name],
			[dbo].[ToProperCase]([2nd Name] + ', ' + [1st Name]) AS [NameConcat],
			MAX([Emp#]) AS [Emp#],
			[Dept],
			[Date Hired],
			[dbo].[ToProperCase]([1st Name] + ' ' + [2nd Name]) AS [C]
		FROM 
			[Employees]
		WHERE
			[Status] NOT IN (SELECT [Code] FROM @ValidStatus)
		GROUP BY
			[2nd Name],
			[1st Name], 
			[Dept],
			[Date Hired]
		UNION
			SELECT 
				'BWS' AS [Company],
				[dbo].[ToProperCase]([2nd Name]) AS [2nd Name],
				[dbo].[ToProperCase]([1st Name]) AS [1st Name],
				[dbo].[ToProperCase]([2nd Name] + ', ' + [1st Name]) AS [NameConcat],
				MAX([Emp#]) AS [Emp#],
				[Dept],
				[Date Hired],
				[dbo].[ToProperCase]([1st Name] + ' ' + [2nd Name]) AS [C]
			FROM 
				[Employees - Salary]
			WHERE
				[Status] NOT IN (SELECT [Code] FROM @ValidStatus)
			GROUP BY
				[2nd Name],
				[1st Name], 
				[Dept],
				[Date Hired]
		UNION
			SELECT 
				'STARGATE' AS [Company],
				[dbo].[ToProperCase]([2nd Name]) AS [2nd Name],
				[dbo].[ToProperCase]([1st Name]) AS [1st Name],
				[dbo].[ToProperCase]([2nd Name] + ', ' + [1st Name]) AS [NameConcat],
				MAX([Emp#]) AS [Emp#],
				[Dept],
				[Date Hired],
				[dbo].[ToProperCase]([1st Name] + ' ' + [2nd Name]) AS [C]
			FROM 
				[Stargatedb].[dbo].[Employees]
			WHERE
				[Status] NOT IN (SELECT [Code] FROM @ValidStatus)
			GROUP BY
				[2nd Name],
				[1st Name], 
				[Dept],
				[Date Hired]
		UNION
			SELECT 
				'STARGATE' AS [Company],
				[dbo].[ToProperCase]([2nd Name]) AS [2nd Name],
				[dbo].[ToProperCase]([1st Name]) AS [1st Name],
				[dbo].[ToProperCase]([2nd Name] + ', ' + [1st Name]) AS [NameConcat],
				MAX([Emp#]) AS [Emp#],
				[Dept],
				[Date Hired],
				[dbo].[ToProperCase]([1st Name] + ' ' + [2nd Name]) AS [C]
			FROM 
				[Stargatedb].[dbo].[Employees - Salary]
			WHERE
				[Status] NOT IN (SELECT [Code] FROM @ValidStatus)
			GROUP BY
				[2nd Name],
				[1st Name], 
				[Dept],
				[Date Hired]
	) AS [SrcA]
	GROUP BY
		[Company],
		[Date Hired],
		[2nd Name],
		[1st Name],
		[NameConcat],
		[Dept],
		[Emp#],
		[C]
) AS [SrcB]
LEFT JOIN
	[Sysprodb].[dbo].[AdmOperator]
ON
	[dbo].[ToProperCase]([Name]) = [SrcB].[C]
WHERE
	[Row#] = 1
GROUP BY
	[Company],
	[2nd Name],
	[1st Name],
	[NameConcat],
	[Dept],
	[C],
	[Email]
UNION
	(SELECT 
		'Syspro' AS [Company],
		'2nd Name' AS [2nd Name],
		'1st Name' AS [1st Name],
		[Name],
		0 AS [Dept],
		0 AS [Emp#],
		'C' AS C,
		'2021-12-08' AS [DateHired],
		[Email]
	FROM [Sysprodb].[dbo].[AdmOperator]
	WHERE [Email] IS NOT NULL AND LTRIM(RTRIM([Email])) <> ''
	)
ORDER BY
	[Company],
	[2nd Name],
	[1st Name]