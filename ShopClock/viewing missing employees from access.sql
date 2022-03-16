USE SysproCompanyA
GO

-- Viewing employees who make transactions, but who hav not been pulled into the access rounding program yet.
-- 2022-03-16

SELECT
	*
FROM
	[ClkTransaction]
LEFT JOIN
	[ClkShiftEmpAssign]
ON
	[ClkTransaction].[EmployeeNumber] = [ClkShiftEmpAssign].Emp#
WHERE
	[ClkShiftEmpAssign].[Emp#] IS NULL