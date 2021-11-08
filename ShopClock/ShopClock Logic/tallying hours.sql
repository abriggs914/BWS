USE SysproCompanyA
GO

-- select hte min sign in and max sign out.
-- ensure dates fall within shift date params
-- difference the time.
-- subtract 30 mins for lunch (if enough hours)
-- iff end_time < start_time then overnight shift.
-- 9PM -> 10AM

DECLARE @shift_start_time AS TIME;
DECLARE @shift_end_time AS TIME;
DECLARE @shift_start_date AS DATETIME;
DECLARE @shift_end_date AS DATETIME;

--SET @shift_start_date = ;
--SET @shift_end_date = ;

DECLARE @empNum AS BIGINT;
SET @empNum = 200241;
DECLARE @sd AS DATETIME;
SET @sd = '2021-11-04';
DECLARE @ed AS DATETIME;
SET @ed = '2021-11-05';

SELECT [OutTimeFromShopClk] - [InTimeFromShopClk] AS [Diff], * FROM [ClkTransaction] WHERE [EmployeeNumber] = @empNum AND ([InTimeFromShopClk] BETWEEN @sd AND @ed OR [OutTimeFromShopClk] BETWEEN @sd AND @ed) ORDER BY [InTimeFromShopClk], [OutTimeFromShopClk]

DECLARE @clkTransVals TABLE ([ShiftID] INT, [LoggedOn] DATETIME, [InTimeFromShopClk] DATETIME, [LoggedOff] DATETIME, [OutTimeFromShopClk] DATETIME);
INSERT INTO @clkTransVals
SELECT
	[ShiftID],
	[LoggedOn],
	[InTimeFromShopClk],
	[LoggedOff],
	[OutTimeFromShopClk]
FROM 
	[ClkTransaction]
WHERE
	[ClkTransaction].[EmployeeNumber] = @empNum
	AND	([LoggedOn] BETWEEN @sd AND @ed OR [LoggedOff] BETWEEN @sd AND @ed)

DECLARE @clkShiftVals TABLE ([ShiftID] INT, [StartTime] TIME, [EndTime] TIME);
INSERT INTO @clkShiftVals
SELECT
	[ShiftID],
	[StartTime],
	[EndTime]
FROM 
	[ClkShiftRoundRules]
WHERE
	[ClkShiftRoundRules].[ShiftID] IN (SELECT [ShiftID] FROM @clkTransVals)

--CAST((CAST((CAST(DATEPART(YEAR, @transactionDate) AS VARCHAR(4)) + '-' + CAST(DATEPART(MONTH, @transactionDate) AS VARCHAR(2)) + '-' + CAST(DATEPART(DAY, @transactionDate) AS VARCHAR(2))) AS VARCHAR(30)) + ' ' + CAST(DATEPART(HOUR, @st) AS VARCHAR(30)) + ':' + CAST(DATEPART(MINUTE, @st) AS VARCHAR(30))) AS DATETIME)
	
SELECT
	YEAR([LoggedOn]), MONTH([LoggedOn]), DAY([LoggedOn]), YEAR([LoggedOff]), MONTH([LoggedOff]), DAY([LoggedOff]),
	[LoggedOn],
	[LoggedOff],
	CAST((CAST((CAST(DATEPART(YEAR, [LoggedOn]) AS VARCHAR(4)) + '-' + CAST(DATEPART(MONTH, [LoggedOn]) AS VARCHAR(2)) + '-' + CAST(DATEPART(DAY, [LoggedOn]) AS VARCHAR(2))) AS VARCHAR(30)) + ' ' + CAST(DATEPART(HOUR, [StartTime]) AS VARCHAR(30)) + ':' + CAST(DATEPART(MINUTE, [StartTime]) AS VARCHAR(30))) AS DATETIME) AS [StartDate],
	CAST((CAST((CAST(DATEPART(YEAR, [LoggedOn]) AS VARCHAR(4)) + '-' + CAST(DATEPART(MONTH, [LoggedOn]) AS VARCHAR(2)) + '-' + CAST(DATEPART(DAY, [LoggedOn]) AS VARCHAR(2))) AS VARCHAR(30)) + ' ' + CAST(DATEPART(HOUR, [EndTime]) AS VARCHAR(30)) + ':' + CAST(DATEPART(MINUTE, [EndTime]) AS VARCHAR(30))) AS DATETIME) AS [EndDate]
FROM
	@clkTransVals
INNER JOIN @clkShiftVals ON [@clkTransVals].[ShiftID] = [@clkShiftVals].[ShiftID]
GROUP BY
	[StartTime], [EndTime], [LoggedOn], [LoggedOff], [InTimeFromShopClk], [OutTimeFromShopClk]
ORDER BY
	[LoggedOn], [LoggedOff]

--SELECT 
--	[TransactionID],
--	[JobNumber],
--	[EmployeeNumber],
--	[EmployeeName],
--	[LoggedOn],
--	[InTimeFromShopClk],
--	[LoggedOff],
--	[OutTimeFromShopClk],
--	 AS [Wage]
--FROM
--	[ClkTransaction] WITH (NOLOCK)
--INNER JOIN
--	[ClkShiftRoundRules]
--ON
--	[ClkTransaction].[ShiftID] = [ClkShiftRoundRules].[ShiftID]
--WHERE
--	[InTimeFromShopClk] IS NOT NULL
--	OR [OutTimeFromShopClk] IS NOT NULL
--	AND ([LoggedOn] BETWEEN DATEADD(DAY, -7, GETDATE()) AND GETDATE()
--		OR [LoggedOff] BETWEEN DATEADD(DAY, -7, GETDATE()) AND GETDATE())
--GROUP BY
--	[EmployeeNumber], 


SELECT
	@sd AS [StartDate],
	@ed AS [EndDate],
	SUM(DATEPART(HOUR, [OutTimeFromShopClk] - [InTimeFromShopClk])) AS [A],
	SUM(DATEPART(MINUTE, [OutTimeFromShopClk] - [InTimeFromShopClk])) AS [B],
	(60 * (SUM(DATEPART(HOUR, [OutTimeFromShopClk] - [InTimeFromShopClk])))) AS [C],
	(60 * (SUM(DATEPART(HOUR, [OutTimeFromShopClk] - [InTimeFromShopClk])))) + SUM(DATEPART(MINUTE, [OutTimeFromShopClk] - [InTimeFromShopClk])) AS [D],
	ROUND(((60 * (SUM(DATEPART(HOUR, [OutTimeFromShopClk] - [InTimeFromShopClk])))) + SUM(DATEPART(MINUTE, [OutTimeFromShopClk] - [InTimeFromShopClk]))) / 60.0, 2) AS [Pay]
FROM
	[ClkTransaction]
WHERE
	[EmployeeNumber] = @empNum 
	AND	([InTimeFromShopClk] BETWEEN @sd AND @ed OR [OutTimeFromShopClk] BETWEEN @sd AND @ed)


SELECT
	*
FROM
	[ClkTransaction]
WHERE
	[EmployeeNumber] = @empNum 
	AND	([LoggedOn] BETWEEN @sd AND @ed OR [LoggedOff] BETWEEN @sd AND @ed)
	AND [InTimeFromShopClk] IS NOT NULL AND [OutTimeFromShopClk] IS NOT NULL