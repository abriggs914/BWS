USE SysproCompanyA
GO

BEGIN TRAN


SELECT
	*
FROM
	[ClkShiftEmpAssign]
SELECT
	*
FROM
	[ClkShiftRoundRules V2]

UPDATE
	[ClkShiftEmpAssign]
SET
	[ShiftID] = 8
WHERE
	[Emp#] IN (
		SELECT DISTINCT
			[EmployeeNumber]
		FROM
			[ClkTransaction]
		INNER JOIN
			[ClkShiftMaster]
		ON
			[ClkTransaction].[ShiftID] = [ClkShiftMaster].[ShiftID]
		LEFT JOIN
			[ClkShiftEmpAssign]
		ON
			[ClkTransaction].[EmployeeNumber] = [ClkShiftEmpAssign].Emp#
		WHERE
			[ClkTransaction].[ShiftID] = 43
			AND [ClkShiftMaster].[IsEnabled] = 1
	)
	



SELECT
	*
FROM
	[ClkShiftEmpAssign]
SELECT
	*
FROM
	[ClkShiftRoundRules V2]

ROLLBACK;
COMMIT;