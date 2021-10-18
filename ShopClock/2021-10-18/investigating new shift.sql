USE SysproCompanyS
GO

DECLARE @SD DATETIME, @ED DATETIME;
SET @SD = '2021-10-15';
SET @ED = '2021-10-18';

SELECT 
	DATEDIFF(MINUTE, [LoggedOn], [LoggedOff]) AS [TOD],
	*
FROM [ClkTransaction]
WHERE
	[LoggedOn] BETWEEN @SD and @ED
	AND [LoggedOff] BETWEEN @SD and @ED

USE  SysproCompanyA
GO

DECLARE @SD DATETIME, @ED DATETIME;
SET @SD = '2020-10-10';
SET @ED = '2021-10-18';

SELECT 
	CAST([LoggedOn] AS Date) AS [ON Date],
	CAST([LoggedOff] AS Date) AS [OFF Date],
	CAST([LoggedOn] AS TIME) AS [ON Time],
	CAST([LoggedOff] AS TIME) AS [OFF Time],
	DATEDIFF(MINUTE, [LoggedOn], [LoggedOff]) AS [TOD],
	*
FROM [ClkTransaction]
WHERE
	[LoggedOn] BETWEEN @SD and @ED
	AND [LoggedOff] BETWEEN @SD and @ED
	AND [ShiftID] = 39
ORDER BY [EmployeeName]