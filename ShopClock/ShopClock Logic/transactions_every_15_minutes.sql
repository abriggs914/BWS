USE SysproCompanyA
GO

DECLARE @today AS DATE;
SET @today = '2021-10-28';

SELECT TOP 200 * FROM [ClkTransaction] WHERE CAST([LoggedOn] AS DATE) = @today ORDER BY [EmployeeNumber], [LoggedOn];

SELECT
	TOP 200
	[EmployeeNumber], [EmployeeName],
	MIN([LoggedOn]) AS [LoggedOn]
FROM
	[ClkTransaction]
WHERE
	DATEPART(YEAR, [LoggedOn]) = DATEPART(YEAR, @today) 
	AND DATEPART(MONTH, [LoggedOn]) = DATEPART(MONTH, @today) 
	AND [EmployeeNumber] IN ((200239), (200572)) 
	--AND (DATEPART(MINUTE, [LoggedOn]) NOT IN ((0), (5)) 
	--	OR DATEPART(MINUTE, [LoggedOff]) NOT IN ((0), (5)))
GROUP BY
	[EmployeeNumber], [EmployeeName], CAST([LoggedOn] AS DATE)
ORDER BY
	[EmployeeNumber], [LoggedOn];


SELECT
	TOP 200
	[EmployeeNumber], [EmployeeName],
	MIN([LoggedOff]) AS [LoggedOff]
FROM
	[ClkTransaction]
WHERE
	DATEPART(YEAR, [LoggedOn]) = DATEPART(YEAR, @today) 
	AND DATEPART(MONTH, [LoggedOn]) = DATEPART(MONTH, @today) 
	AND [EmployeeNumber] IN ((200239), (200572)) 
	--AND (DATEPART(MINUTE, [LoggedOn]) NOT IN ((0), (5)) 
	--	OR DATEPART(MINUTE, [LoggedOff]) NOT IN ((0), (5)))
GROUP BY
	[EmployeeNumber], [EmployeeName], CAST([LoggedOff] AS DATE)
ORDER BY
	[EmployeeNumber], [LoggedOff];