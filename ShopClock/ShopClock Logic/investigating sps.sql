DECLARE @sd AS DATETIME;
DECLARE @ed AS DATETIME;
SET @sd = '2021-12-13';
SET @ed = '2021-12-14';

EXEC [dbo].[sp_ClkLabourOverride] @sd=@sd, @ed=@ed
EXEC [sp_ClkTallyHours] @sd=@sd, @ed=@ed, @by_transaction=0

SELECT * FROM [ClkFrmConfirm] ORDER BY [EntryDate] DESC


DECLARE @T TABLE ([EmployeeNumber] REAL,
				[EmployeeName] NVARCHAR(200),
				[HrsWorked] FLOAT,
				[StartDate] DATETIME,
				[EndDate] DATETIME);

INSERT INTO @T EXEC [sp_ClkTallyHours] @sd=@sd, @ed=@ed, @by_transaction=0

SELECT 
	[ClkFrmConfirmID#],
	[@T].[EmployeeNumber],
	[EmployeeName],
	--(CASE WHEN [EntryDate] NOT BETWEEN @sd AND @ed THEN @sd ELSE [EntryDate] END) AS [EntryDate],
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
	[ClkFrmConfirm].[EmployeeNumber] = [@T].[EmployeeNumber]