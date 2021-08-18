USE SysproCompanyA
GO

DECLARE @JOB AS VARCHAR(20);
SET @JOB = '10014877'

SELECT
	CAST([IExpUnitRunTim] AS DECIMAL(7,2)) AS [Budget],
	CAST([RunTimeIssued] AS DECIMAL(7,2)) AS [Actual],
	CAST([RunTimeIssued] / (CASE [IExpUnitRunTim] WHEN 0 THEN 1 ELSE [IExpUnitRunTim] END) AS DECIMAL(7,2)) AS [Percentage]
FROM
	[WipJobAllLab]
WHERE
	[Job] LIKE @JOB
UNION ALL(
SELECT
	CAST(SUM([IExpUnitRunTim]) AS DECIMAL(7,2) ) AS [Budget],
	CAST(SUM([RunTimeIssued]) AS DECIMAL(7,2) ) AS [Actual],
	CAST(SUM([RunTimeIssued]) / (CASE SUM([IExpUnitRunTim]) WHEN 0 THEN 1 ELSE SUM([IExpUnitRunTim]) END) AS DECIMAL(7,2)) AS [Percentage]
FROM
	[WipJobAllLab]
WHERE
	[Job] LIKE @JOB
	AND ([Operation] = 4 OR [Operation] = 5)
)