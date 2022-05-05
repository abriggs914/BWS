USE SysproCompanyS
GO

SELECT * FROM [ClkTransaction] WHERE [EmployeeNumber] = 300019 OR [EmployeeNumber] = 300090 ORDER BY [EmployeeNumber], [LoggedOn]

DECLARE @sd AS DATETIME;
DECLARE @ed AS DATETIME;
SET @sd = '2022-05-02';
SET @ed = '2022-05-02 23:59:59';

EXEC [sp_ClkLabourOverride] @sd=@sd, @ed=@ed
EXEC [Stargatedb].[dbo].[sp_ClkTallyWeeklyReport] @sd=@sd, @ed=@ed
EXEC [sp_ClkTallyHours] @sd=@sd, @ed=@ed, @by_transaction=0


SELECT
	[EmployeeNumber]
	, [EmployeeName]
	, [ShiftName]
	, [Name]
FROM 
	[ClkTransaction]
LEFT OUTER JOIN
	[ClkShiftEmpAssign]
ON
	[ClkTransaction].[EmployeeNumber] = [ClkShiftEmpAssign].[Emp#]
LEFT JOIN
	[ClkShiftRoundRules V2]
ON
	[ClkShiftEmpAssign].[ShiftID] = [ClkShiftRoundRules V2].[ShiftID]
LEFT JOIN
	[ClkShiftDetail]
ON
	[ClkTransaction].[ShiftID] = [ClkShiftDetail].[ShiftID]
GROUP BY
	[EmployeeNumber]
	, [EmployeeName]
	, [ShiftName]
	, [Name]