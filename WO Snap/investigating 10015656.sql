USE SysproCompanyA
GO


DECLARE @go_date AS DATETIME
SELECT @go_date = '2022-11-08 10AM';

DECLARE @empInQuestion AS BIGINT;
--SELECT @empInQuestion = 200006;

DECLARE @jobInQuestion AS NVARCHAR(MAX);
SELECT @jobInQuestion = '10015656';


SELECT * FROM [ClkTransaction] WHERE [LoggedOn] > @go_date
SELECT
	* 
FROM
	[ClkTransaction]
LEFT JOIN
	[WipMaster]
ON
	[ClkTransaction].[JobNumber] = [WipMaster].[Job]
LEFT JOIN
	[ClkTransactionNewShifts]
ON	
	[ClkTransaction].[TransactionID] = [ClkTransactionNewShifts].[ClkTransactionIDIn]
LEFT JOIN
	[ClkShiftEmpAssign]
ON
	[ClkTransaction].[EmployeeNumber] = CAST([ClkShiftEmpAssign].[Emp#] AS NVARCHAR(20))
LEFT JOIN
	[ClkShiftRoundRules V2]
ON	
	[ClkShiftEmpAssign].[ShiftID] = [ClkShiftRoundRules V2].[ShiftID]
	
WHERE
	--[LoggedOn] > @go_date
	--AND
	--[IsNewShift] = 1
	--AND 
	(CASE WHEN @empInQuestion IS NULL THEN 1 WHEN [EmployeeNumber] = @empInQuestion THEN 1 ELSE 0 END) > 0
	AND (CASE WHEN @jobInQuestion IS NULL THEN 1 WHEN [Job] = @jobInQuestion THEN 1 ELSE 0 END) > 0
	AND ([Operation] = 4 OR [Operation] = 5)
ORDER BY
	[EmployeeNumber]
	,[ClkTransaction].[TransactionID] DESC