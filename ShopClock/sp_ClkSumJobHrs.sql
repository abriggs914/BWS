USE SysproCompanyA
GO

--DECLARE @jobs AS TABLE ([ID] INT IDENTITY(1,1), [Job#] NVARCHAR(MAX))
--INSERT INTO @jobs ([Job#]) VALUES
--	('20049898')
--	,('20049897')
--	,('20050412')
--	,('20049199')
--	,('20049198')
--;

--SELECT 
--	[JobNumber]
--	,[EmployeeNumber]
--	,YEAR([LoggedOn]) AS [Year]
--	,MONTH([LoggedOn]) AS [Month]
--	,DAY([LoggedOn]) AS [Day]
--	,MAX([LoggedOff]) AS [MaxOff]
--	,MIN([LoggedOff]) AS [MinOff]
--	,MAX([LoggedOn]) AS [MaxOn]
--	,MIN([LoggedOn]) AS [MinOn]
--	,DATEDIFF(SECOND, MIN([LoggedOn]), MAX([LoggedOff])) / 60.0 / 60.0 AS [Diff]
--FROM [ClkTransaction] WHERE [ClkTransaction].[JobNumber] IN (SELECT [Job#] FROM @jobs)
--GROUP BY
--	[JobNumber]
--	,[EmployeeNumber]
--	,YEAR([LoggedOn])
--	,MONTH([LoggedOn])
--	,DAY([LoggedOn])
--ORDER BY
--	YEAR([LoggedOn])
--	,MONTH([LoggedOn])
--	,DAY([LoggedOn])

CREATE PROCEDURE [dbo].[sp_ClkSumJobHrs] 
	@wo AS NVARCHAR(MAX)
AS
BEGIN
--DECLARE @wo AS NVARCHAR(MAX);
--SET @wo = '20049898;20049897';

DECLARE @wos AS TABLE([Job#] INT, [Job] NVARCHAR(MAX));
INSERT INTO @wos SELECT * FROM [BWSdb].[dbo].[split_string_idx](@wo, ';');

SELECT
	ROW_NUMBER() OVER(
		ORDER BY 
			[JobNumber]
	) AS [Row#],
	[JobNumber],
	CAST(SUM([TotalHours]) AS DECIMAL(18, 3)) AS [TotalHours]
FROM (
	SELECT [Job] AS [JobNumber], 0 AS [TotalHours] FROM @wos
UNION ALL
	SELECT
		[JobNumber]
		,SUM(ISNULL([Diff], 0)) AS [TotalHours]
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
		FROM [ClkTransaction] WHERE [ClkTransaction].[JobNumber] IN (SELECT [Job] FROM @wos)
		GROUP BY
			[JobNumber]
			,[EmployeeNumber]
			,YEAR([LoggedOn])
			,MONTH([LoggedOn])
			,DAY([LoggedOn])
	) AS [SrcA]
	GROUP BY
		[JobNumber]
) AS [A]
GROUP BY
	[JobNumber]
ORDER BY
	[JobNumber]
END