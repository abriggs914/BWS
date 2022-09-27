USE SysproCompanyA
GO

-- Missing list
SELECT
	*
FROM
	[SysproCompanyA].[dbo].[ClkTransaction]
LEFT JOIN
	[SysproCompanyA].[dbo].[ClkShiftEmpAssign]
ON
	[ClkTransaction].[EmployeeNumber] = [ClkShiftEmpAssign].Emp#
WHERE
	[ClkShiftEmpAssign].[Emp#] IS NULL
;

-- Viewing employees who make transactions, but who hav not been pulled into the access rounding program yet.
-- 2022-03-16

BEGIN TRAN;

-- Missing list
SELECT
	*
FROM
	[SysproCompanyA].[dbo].[ClkTransaction]
LEFT JOIN
	[SysproCompanyA].[dbo].[ClkShiftEmpAssign]
ON
	[ClkTransaction].[EmployeeNumber] = [ClkShiftEmpAssign].Emp#
WHERE
	[ClkShiftEmpAssign].[Emp#] IS NULL
;
SELECT * FROM [SysproCompanyA].[dbo].[ClkShiftEmpAssign] ORDER BY [Emp#] DESC;

INSERT INTO
	[ClkShiftEmpAssign]
([Emp#], [ShiftID])
SELECT
	[EmployeeNumber],
	1
FROM
	[ClkTransaction]
LEFT JOIN
	[ClkShiftEmpAssign]
ON
	[ClkTransaction].[EmployeeNumber] = [ClkShiftEmpAssign].Emp#
WHERE
	[ClkShiftEmpAssign].[Emp#] IS NULL
GROUP BY
	[EmployeeNumber]

-- Missing list - should be empty now
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
;
--SELECT * FROM [ClkShiftEmpAssign] ORDER BY [Emp#] DESC;

ROLLBACK;
COMMIT;