USE SysproCompanyS
GO

DECLARE @sd AS DATETIME;
DECLARE @ed AS DATETIME;
SET @sd = '2022-04-02';
SET @ed = '2022-04-06 23:59:59';

DECLARE @clkTally AS TABLE (
	[ID] INT IDENTITY(1,1),
	[QueryID] NVARCHAR(1),
	[EmployeeNumber] NVARCHAR(MAX),
	[EmployeeName] NVARCHAR(MAX),
	[HrsWorked] FLOAT,
	[Date] DATETIME
);

INSERT INTO @clkTally
EXEC [SysproCompanyS].[dbo].[sp_ClkTallyHours] @sd=@sd, @ed=@ed, @by_transaction=0, @by_date=1

SELECT
	--[@clkTally].*
	[@clkTally].[EmployeeNumber]
	,[@clkTally].[EmployeeName]
	,[HrsWorked]
	,[ClkShiftEmpAssign].[ShiftID]
	,[ClkShiftRoundRules V2].[Name] AS [Shift Name]
	,[LoggedOn] AS [Login1]
	,[LoggedOff] AS [Logout1]
	,DATEDIFF(SECOND, [LoggedOn], [LoggedOff]) / 60 / 60 AS [Hact]
	,[InTimeFromShopClk] AS [Login2]
	,[OutTimeFromShopClk] AS [Logout2]
	,DATEDIFF(SECOND, [InTimeFromShopClk], [OutTimeFromShopClk]) / 60 / 60 AS [Hclc]
	,[StartTime] AS [Shift Start Time]
	,[EndTime] AS [Shift End Time]
FROM @clkTally
LEFT JOIN
	[ClkTransaction]
ON
	[@clkTally].[EmployeeNumber] = [ClkTransaction].[EmployeeNumber]
	AND YEAR([LoggedOn]) = YEAR([Date])
	AND MONTH([LoggedOn]) = MONTH([Date])
	AND DAY([LoggedOn]) = DAY([Date])
LEFT JOIN
	[ClkShiftEmpAssign]
ON
	[@clkTally].[EmployeeNumber] = [ClkShiftEmpAssign].[Emp#]
LEFT JOIN
	[ClkShiftRoundRules V2]
ON
	[ClkShiftEmpAssign].[ShiftID] = [ClkShiftRoundRules V2].[ShiftID]
WHERE
	[ClkShiftEmpAssign].[ShiftID] IN (2, 4)
ORDER BY
	[EmployeeNumber], [LoggedOn]

SELECT
	[EmployeeNumber],
	[EmployeeName],
	[LoggedOn],
	[LoggedOff],
	[InTimeFromShopClk],
	[OutTimeFromShopClk],
	[ClkShiftEmpAssign].[ShiftID],
	[Name],
	[StartTime],
	[EndTime]
FROM
	[ClkTransaction]
LEFT JOIN
	[ClkShiftEmpAssign]
ON
	[ClkTransaction].[EmployeeNumber] = [ClkShiftEmpAssign].[Emp#]
LEFT JOIN
	[ClkShiftRoundRules V2]
ON
	[ClkShiftEmpAssign].[ShiftID] = [ClkShiftRoundRules V2].[ShiftID]
WHERE
	[LoggedOn] BETWEEN @sd AND @ed
ORDER BY
	[LoggedOn],
	[EmployeeName]