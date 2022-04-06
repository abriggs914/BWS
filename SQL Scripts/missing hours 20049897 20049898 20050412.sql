USE SysproCompanyA
GO

SELECT 
	[JobNumber]
	,[EmployeeNumber]
	,YEAR([LoggedOn]) AS [Year]
	,MONTH([LoggedOn]) AS [Month]
	,DAY([LoggedOn]) AS [Day]
	,MAX([LoggedOff]) AS [MaxOff]
	,MIN([LoggedOff]) AS [MinOff]
	,MAX([LoggedOn]) AS [MaxOn]
	,MIN([LoggedOn]) AS [MinOn]
	,DATEDIFF(SECOND, MIN([LoggedOn]), MAX([LoggedOff])) / 60.0 / 60.0 AS [Diff]
FROM [ClkTransaction] WHERE [ClkTransaction].[JobNumber] = '20049898' OR [ClkTransaction].[JobNumber] = '20049897' OR [ClkTransaction].[JobNumber] = '20050412'
GROUP BY
	[JobNumber]
	,[EmployeeNumber]
	,YEAR([LoggedOn])
	,MONTH([LoggedOn])
	,DAY([LoggedOn])
ORDER BY
	YEAR([LoggedOn])
	,MONTH([LoggedOn])
	,DAY([LoggedOn])


SELECT
	[JobNumber]
	,SUM([Diff]) AS [TtlHours]
FROM (
	SELECT 
		[JobNumber]
		,[EmployeeNumber]
		,YEAR([LoggedOn]) AS [Year]
		,MONTH([LoggedOn]) AS [Month]
		,DAY([LoggedOn]) AS [Day]
		,MAX([LoggedOff]) AS [MaxOff]
		,MIN([LoggedOff]) AS [MinOff]
		,MAX([LoggedOn]) AS [MaxOn]
		,MIN([LoggedOn]) AS [MinOn]
		,DATEDIFF(SECOND, MIN([LoggedOn]), MAX([LoggedOff])) / 60.0 / 60.0 AS [Diff]
	FROM [ClkTransaction] WHERE [ClkTransaction].[JobNumber] = '20049898' OR [ClkTransaction].[JobNumber] = '20049897' OR [ClkTransaction].[JobNumber] = '20050412'
	GROUP BY
		[JobNumber]
		,[EmployeeNumber]
		,YEAR([LoggedOn])
		,MONTH([LoggedOn])
		,DAY([LoggedOn])
) AS [SrcA]
GROUP BY
	[JobNumber]
ORDER BY
	[JobNumber]