USE BWSdb
GO

EXEC [dbo].[sp_EmployeeEmails]

SELECT DISTINCT [Name], [Location], [Email] FROM [Sysprodb].[dbo].[AdmOperator] WHERE [Email] IS NOT NULL AND [Email] <> ''
SELECT DISTINCT * FROM [Sysprodb].[dbo].[AdmOperator] WHERE [Email] IS NOT NULL AND [Email] <> ''
SELECT DISTINCT [dbo].[ToProperCase]([Name]) FROM [Sysprodb].[dbo].[AdmOperator]

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
				[Dept],
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
ORDER BY
	[Company],
	[2nd Name],
	[1st Name]