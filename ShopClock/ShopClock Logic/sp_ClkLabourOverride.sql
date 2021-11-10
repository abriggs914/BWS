USE SysproCompanyA
GO

ALTER PROCEDURE [dbo].[sp_ClkLabourOverride]
	@sd DATETIME, @ed DATETIME
AS
BEGIN
DECLARE @T TABLE ([EmployeeNumber] REAL,
				[EmployeeName] NVARCHAR(200),
				[HrsWorked] FLOAT);

INSERT INTO @T EXEC [sp_ClkTallyHours] @sd=@sd, @ed=@ed, @by_transaction=0

SELECT 
	[ClkFrmConfirmID#],
	[@T].[EmployeeNumber],
	[EmployeeName],
	[EntryDate],
	[HrsWorked],
	[ConfirmedFlag],
	[OverrideFlag] AS [OverrideFlag_],
	[OverrideHoursWorked],
	[SubmitFlag],
	[SubmittedBy]
FROM
	@T
LEFT JOIN
	[ClkFrmConfirm]
ON
	[ClkFrmConfirm].[EmployeeNumber] = [@T].[EmployeenUMBER]
END