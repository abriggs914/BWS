USE [SysproCompanyA]
GO
/****** Object:  StoredProcedure [dbo].[sp_ClkLabourOverride]    Script Date: 2022-02-16 10:01:20 AM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO

--ALTER PROCEDURE [dbo].[sp_ClkLabourOverride]
DECLARE
	@sd DATETIME, @ed DATETIME
SET @sd = '2022-02-10'
SET @ed = '2022-02-10 23:59:59'
--AS
--BEGIN



DECLARE @T TABLE ([EmployeeNumber] REAL,
				[EmployeeName] NVARCHAR(200),
				[HrsWorked] FLOAT,
				[StartDate] DATETIME,
				[EndDate] DATETIME);

INSERT INTO @T EXEC [sp_ClkTallyHours] @sd=@sd, @ed=@ed, @by_transaction=0

SELECT 
	[ClkFrmConfirmID#],
	[@T].[EmployeeNumber],
	[@T].[EmployeeName],
	--(CASE WHEN [EntryDate] NOT BETWEEN @sd AND @ed THEN @sd ELSE [EntryDate] END) AS [EntryDate],
	[EntryDate],
	(CASE WHEN [IncludeLunch] = 1 THEN (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) ELSE (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) END) AS [HrsWorked],
	(CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] ELSE [OverrideHoursWorked] END) AS [HrsWorkedNOLUNCH],
	[ConfirmedFlag],
	[OverrideFlag] AS [OverrideFlag_],
	[OverrideHoursWorked],
	[SubmitFlag],
	[SubmittedBy],
	MIN([InTimeFromShopClk]) AS [First Sign-in],
	MAX([OutTimeFromShopClk]) AS [Last Sign-out]
FROM
	@T
LEFT JOIN
	[ClkShiftEmpAssign]
ON
	[@T].[EmployeeNumber] = [ClkShiftEmpAssign].[Emp#]
LEFT JOIN
	[ClkShiftRoundRules]
ON
	[ClkShiftEmpAssign].[ShiftID] = [ClkShiftRoundRules].[ShiftID]
LEFT JOIN (
	SELECT
		*
	FROM
		[ClkFrmConfirm]
	WHERE
		[EntryDate] BETWEEN @sd AND @ed
) AS [Src]
ON
	[Src].[EmployeeNumber] = [@T].[EmployeeNumber]
INNER JOIN
	[ClkTransaction]
ON
	[ClkTransaction].[EmployeeNumber] = [ClkShiftEmpAssign].[Emp#]
WHERE
	([EntryDate] IS NULL OR [EntryDate] BETWEEN @sd AND @ed)
	AND ([InTimeFromShopClk] BETWEEN @sd AND @ed OR [OutTimeFromShopClk] BETWEEN @sd AND @ed)
	AND [InTimeFromShopClk] IS NOT NULL
GROUP BY
	[ClkFrmConfirmID#],
	[@T].[EmployeeNumber],
	[@T].[EmployeeName],
	[EntryDate],
	(CASE WHEN [IncludeLunch] = 1 THEN [HrsWorked] - 0.5 ELSE [HrsWorked] END),
	[HrsWorked],
	[ConfirmedFlag],
	[OverrideFlag],
	[OverrideHoursWorked],
	[SubmitFlag],
	[SubmittedBy],
	[IncludeLunch]
--END