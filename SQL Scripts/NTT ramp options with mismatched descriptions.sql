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
FROM [Budget Options]
FULL OUTER JOIN
	[Options]
ON
[Budget Options].[Option No] = [Options].[Option No]
WHERE
	[Options].[Description] != [Budget Options].[Description]
ORDER BY
	[Bud Desc], [Opt Desc]