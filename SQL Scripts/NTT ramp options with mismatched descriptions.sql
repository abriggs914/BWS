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
	[Src2].*
	,[WO#] AS [Last WO#]
FROM (
	SELECT
		[Bud No]
		,[Opt No]
		,[Bud Desc]
		,[Opt Desc]
		,[Newer]
		,[Use Description]
		--,[BudgetDate]
		--,[OptionStartDate]
		--,[OptionEndDate]
		,MAX([Order Date]) AS [Max Order Date]
	FROM (
		SELECT
			[Budget Options].[Option No] AS [Bud No] 
			, [Options].[Option No] AS [Opt No]
			, [Budget Options].[Description] AS [Bud Desc]
			, [Options].[Description] AS [Opt Desc]
			, (CASE WHEN [Budget Options].[budopt_timestamp] <= [Options].[Option_timestamp] THEN 'BUD' ELSE 'OPT' END) AS [Newer]
			, (CASE WHEN [Budget Options].[budopt_timestamp] <= [Options].[Option_timestamp] THEN [Budget Options].[Description] ELSE [Options].[Description] END) AS [Use Description]
	
			--, [Budget Options].[Bud_Date_Opt] AS [BudgetDate]
			--, [Options].[Start Date] AS [OptionStartDate]
			--, [Options].[End Date] AS [OptionEndDate]
			, [Order Date]
			--, [WO#]
			--, [Budget Options].[budopt_timestamp] AS [BudTS]
			--, [Options].[Option_timestamp] AS [OptTS]

		FROM [Budget Options]
		FULL OUTER JOIN
			[Options]
		ON
		[Budget Options].[Option No] = [Options].[Option No]
		LEFT JOIN
			[Order Options]
		ON
			[Options].[Option No] = [Order Options].[Option No]
		WHERE
			[Options].[Description] != [Budget Options].[Description]
		--ORDER BY
		--	[Bud Desc], [Opt Desc]
		) AS [Src1]
	GROUP BY
		[Bud No]
		,[Opt No]
		,[Bud Desc]
		,[Opt Desc]
		,[Newer]
		,[Use Description]
	) AS [Src2]
LEFT JOIN
	[Order Options]
ON
	[Src2].[Opt No] = [Order Options].[Option No]
	AND [Src2].[Max Order Date] = [Order Options].[Order Date]
ORDER BY [Src2].[Opt No]
