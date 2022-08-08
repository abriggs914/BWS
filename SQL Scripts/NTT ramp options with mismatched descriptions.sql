USE BWSdb
GO

SELECT
	[Budget Options].[Option No] AS [Bud No] 
	, [Options].[Option No] AS [Opt No]
	, [Budget Options].[Description] AS [Bud Desc]
	, [Options].[Description] AS [Opt Desc]
FROM [Budget Options]
FULL OUTER JOIN
	[Options]
ON
[Budget Options].[Option No] = [Options].[Option No]
WHERE [Options].[Model No] LIKE '%NTT%'
AND [Options].[Description] LIKE '%ramp%'
ORDER BY
	[Bud Desc], [Opt Desc]



SELECT
	[Budget Options].[Option No] AS [Bud No] 
	, [Options].[Option No] AS [Opt No]
	, [Budget Options].[Description] AS [Bud Desc]
	, [Options].[Description] AS [Opt Desc]
	--, [Budget Options].[Bud_Date_Opt] AS [BudgetDate]
	--, [Options].[Start Date] AS [OptionStartDate]
	--, [Options].[End Date] AS [OptionEndDate]
	--, [Budget Options].[budopt_timestamp] AS [BudTS]
	--, [Options].[Option_timestamp] AS [OptTS]
	, (CASE WHEN [Budget Options].[budopt_timestamp] <= [Options].[Option_timestamp] THEN 'BUD' ELSE 'OPT' END) AS [Newer]
	, (CASE WHEN [Budget Options].[budopt_timestamp] <= [Options].[Option_timestamp] THEN [Budget Options].[Description] ELSE [Options].[Description] END) AS [Use Description]
FROM [Budget Options]
FULL OUTER JOIN
	[Options]
ON
[Budget Options].[Option No] = [Options].[Option No]
WHERE
	[Options].[Description] != [Budget Options].[Description]
ORDER BY
	[Bud Desc], [Opt Desc]