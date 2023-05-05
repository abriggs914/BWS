USE SysproCompanyA
GO

/****** Script for SelectTopNRows command from SSMS  ******/



DECLARE @day1 AS DATETIME = '2023-05-01';
DECLARE @day2 AS DATETIME = '2023-05-01 23:59:59';
DECLARE @tm AS INTEGER = 1440;

SELECT
	[A].[ShiftID]
	,[B].[ShiftName]
	,[A].[StartRule]
	,[A].[EndRule]

	,(CASE 
		WHEN [A].[StartRule] BETWEEN (1 * @tm) AND ((2 * @tm) - 1) THEN 'Monday'
		WHEN [A].[StartRule] BETWEEN (2 * @tm) AND ((3 * @tm) - 1) THEN 'Tuesday'
		WHEN [A].[StartRule] BETWEEN (3 * @tm) AND ((4 * @tm) - 1) THEN 'Wednesday'
		WHEN [A].[StartRule] BETWEEN (4 * @tm) AND ((5 * @tm) - 1) THEN 'Thursday'
		WHEN [A].[StartRule] BETWEEN (5 * @tm) AND ((6 * @tm) - 1) THEN 'Friday'
		WHEN [A].[StartRule] BETWEEN (6 * @tm) AND ((7 * @tm) - 1) THEN 'Saturday'
		ELSE 'Sunday'
	END) AS [StartRuleDoW]
	,RIGHT('00' + CAST(CAST(([StartRule] % @tm) / 60 AS INTEGER) AS NVARCHAR(MAX)), 2)
	+ ':' +
	RIGHT('00' + CAST(CAST(60 * ((([StartRule] % @tm) / 60) - CAST(([StartRule] % @tm) / 60 AS INTEGER)) AS INTEGER) AS NVARCHAR(MAX)), 2)
	AS [StartRuleTimeS]
	,(CASE 
		WHEN [A].[EndRule] BETWEEN (1 * @tm) AND ((2 * @tm) - 1) THEN 'Monday'
		WHEN [A].[EndRule] BETWEEN (2 * @tm) AND ((3 * @tm) - 1) THEN 'Tuesday'
		WHEN [A].[EndRule] BETWEEN (3 * @tm) AND ((4 * @tm) - 1) THEN 'Wednesday'
		WHEN [A].[EndRule] BETWEEN (4 * @tm) AND ((5 * @tm) - 1) THEN 'Thursday'
		WHEN [A].[EndRule] BETWEEN (5 * @tm) AND ((6 * @tm) - 1) THEN 'Friday'
		WHEN [A].[EndRule] BETWEEN (6 * @tm) AND ((7 * @tm) - 1) THEN 'Saturday'
		ELSE 'Sunday'
	END) AS [EndRuleDoW]
	,RIGHT('00' + CAST(CAST(([EndRule] % @tm) / 60 AS INTEGER) AS NVARCHAR(MAX)), 2)
	+ ':' +
	RIGHT('00' + CAST(CAST(60 * ((([EndRule] % @tm) / 60) - CAST(([EndRule] % @tm) / 60 AS INTEGER)) AS INTEGER) AS NVARCHAR(MAX)), 2)
	AS [EndRuleTimeS]

	--() AS [StartRuleTime]
	
	,[EndRule] - [StartRule] AS [Duration(m)]
	,([EndRule] - [StartRule]) / 60 AS [Duration(h)]

	,[B].[AllowLogon]
	,[B].[IsEnabled]

	,[C].[TransactionID]
	,[C].[JobNumber]
	,[C].[JobName]
	,[C].[Operation]
	,[C].[OperationComplete]
	,[C].[EmployeeNumber]
	,[C].[EmployeeName]
	,[C].[WorkCentreCode]
	,[C].[WorkCentreCodeDescription]
	,[C].[LoggedOn]
	,[C].[LoggedOff]
	,[C].[IsComplete]
	,[C].[GroupID]
	,[C].[GroupName]
	,[C].[IsNonProductive]
	,[C].[NonProductiveCode]
	,[C].[NonProductiveDescription]
	,[C].[MachineCode]
	,[C].[MachineCodeDescription]
	,[C].[OperationDescription]
	,[C].[StockCode]
	,[C].[StockCodeDescription]
	,[C].[InTimeFromShopClk]
	,[C].[OutTimeFromShopClk]

	,[D].[ShiftRuleKey]

	,[E].[IsEnabled]

	,[F].[ShiftID] AS [AccessShiftID]

	,[G].[Name] AS [AccessShiftName]
	,[G].[StartTime]
	,[G].[EndTime]
	,[G].[Interval]
	,[G].[EarlyThreshold]
	,[G].[LateThreshold]
	,[G].[IncludeLunchSun]
	,[G].[IncludeLunchMon]
	,[G].[IncludeLunchTue]
	,[G].[IncludeLunchWed]
	,[G].[IncludeLunchThu]
	,[G].[IncludeLunchFri]
	,[G].[IncludeLunchSat]
	,[G].[Active]
	,[G].[DateActive]
	,[G].[DateInactive]
FROM
	[SysproCompanyA].[dbo].[ClkShiftDetail] AS [A]
INNER JOIN
	[SysproCompanyA].[dbo].[ClkShiftMaster] AS [B]
ON
	[A].[ShiftID] = [B].[ShiftID]
INNER JOIN
	[ClkTransaction] AS [C]
ON
	[A].[ShiftID] = [C].[ShiftID]
INNER JOIN
	[SysproCompanyA].[dbo].[ClkShiftRule] AS [D]
ON
	[A].[ShiftRuleID] = [D].[ShiftRuleID]
INNER JOIN
	[SysproCompanyA].[dbo].[ClkEmployee] AS [E]
ON
	[C].[EmployeeNumber] = [E].[Employee]

INNER JOIN
	[ClkShiftEmpAssign] AS [F]
ON
	CAST([F].[Emp#] AS NVARCHAR(6)) = [C].[EmployeeNumber]

INNER JOIN
	[ClkShiftRoundRules V2] AS [G]
ON
	[F].[ShiftID] = [G].[ShiftID]

WHERE
	([LoggedOn] BETWEEN @day1 AND @day2)
	OR
	([LoggedOn] BETWEEN @day1 AND @day2)
	OR
	[B].[ShiftName] = 'Every 15 Minutes'
ORDER BY
	[D].[ShiftRuleID],
	[E].[Name],
	[A].[StartRule],
	[A].[EndRule],
	[LoggedOn]