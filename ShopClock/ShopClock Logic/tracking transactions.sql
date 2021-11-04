USE SysproCompanyA
GO


SELECT 
	TOP 200 *
FROM
	[ClkTransaction] WITH (NOLOCK)
ORDER BY
	[LoggedOn] DESC

SELECT 
	TOP 200 *
FROM
	[ClkTransaction] WITH (NOLOCK)
ORDER BY
	[LoggedOff] DESC



SELECT
	TOP 200 *
FROM
	[ClkTransaction] WITH (NOLOCK)
WHERE
	[InTimeFromShopClk] IS NOT NULL
	OR [OutTimeFromShopClk] IS NOT NULL
ORDER BY
	[LoggedOn] DESC,
	[LoggedOff] DESC

SELECT 
	[TransactionID],
	[JobNumber],
	[EmployeeNumber],
	[EmployeeName],
	[LoggedOn],
	[InTimeFromShopClk],
	[LoggedOff],
	[OutTimeFromShopClk]
FROM
	[ClkTransaction] WITH (NOLOCK)
WHERE
	[InTimeFromShopClk] IS NOT NULL
	OR [OutTimeFromShopClk] IS NOT NULL
	AND ([LoggedOn] BETWEEN DATEADD(DAY, -7, GETDATE()) AND GETDATE()
		OR [LoggedOff] BETWEEN DATEADD(DAY, -7, GETDATE()) AND GETDATE())

SELECT
	[TransactionID],
	[JobNumber],
	[EmployeeNumber],
	[EmployeeName],
	[StartTime],
	[EndTime],
	[LoggedOn],
	[InTimeFromShopClk],
	[LoggedOff],
	[OutTimeFromShopClk],
	(CASE WHEN [InTimeFromShopClk] < CAST(LEFT(CAST([LoggedOn] AS NVARCHAR), 12) + LEFT(CAST([StartTime] AS NVARCHAR), 12) AS DATETIME) THEN 'In' WHEN ([InTimeFromShopClk] < CAST(LEFT(CAST([LoggedOn] AS NVARCHAR), 12) + LEFT(CAST([StartTime] AS NVARCHAR), 12) AS DATETIME) AND [OutTimeFromShopClk] > CAST(LEFT(CAST([LoggedOff] AS NVARCHAR), 12) + LEFT(CAST([EndTime] AS NVARCHAR), 12) AS DATETIME)) THEN 'In/Out' ELSE 'Out' END) AS [Code],
	CAST(LEFT(CAST([LoggedOn] AS NVARCHAR), 12) + LEFT(CAST([StartTime] AS NVARCHAR), 12) AS DATETIME) AS [Lparam],
	CAST(LEFT(CAST([LoggedOff] AS NVARCHAR), 12) + LEFT(CAST([EndTime] AS NVARCHAR), 12) AS DATETIME) AS [Rparam]
FROM
	[ClkTransaction]
INNER JOIN
	[ClkShiftRoundRules]
ON
	[ClkTransaction].[ShiftID] = [ClkShiftRoundRules].[ShiftID]
WHERE
	[InTimeFromShopClk] < CAST(LEFT(CAST([LoggedOn] AS NVARCHAR), 12) + LEFT(CAST([StartTime] AS NVARCHAR), 12) AS DATETIME)
	OR [OutTimeFromShopClk] > CAST(LEFT(CAST([LoggedOff] AS NVARCHAR), 12) + LEFT(CAST([EndTime] AS NVARCHAR), 12) AS DATETIME)


--SELECT 
--	[TransactionID],
--	[JobNumber],
--	[EmployeeNumber],
--	[EmployeeName],
--	[LoggedOn],
--	[InTimeFromShopClk],
--	[LoggedOff],
--	[OutTimeFromShopClk]
--FROM
--	[ClkTransaction] WITH (NOLOCK)
--WHERE
--	[InTimeFromShopClk] IS NOT NULL
--	OR [OutTimeFromShopClk] IS NOT NULL
--	AND 1 = (CASE WHEN [OutTimeFromShopClk] IS NULL THEN 0 WHEN RIGHT(CAST([OutTimeFromShopClk] AS NVARCHAR(MAX)), 1) = '5' END)