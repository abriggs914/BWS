USE SysproCompanyS
GO

SELECT * FROM [ClkTransaction] WHERE [InTimeFromShopClk] IS NULL
SELECT * FROM [ClkTransaction] WHERE [EmployeeNumber] = 300019 ORDER BY [LoggedOn]

EXEC [sp_ClkLabourOverride] @sd='2022-05-02', @ed='2022-05-03 23:59:59'
EXEC [sp_ClkTallyHours] @sd='2022-05-02', @ed='2022-05-03 23:59:59', @by_transaction=0


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