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
SET @sd = '2022-02-15'
SET @ed = '2022-02-15 23:59:59'
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
	[EntryDate],
	--(CASE WHEN [IncludeLunch] = 1 THEN (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) ELSE (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) END) AS [HrsWorked],
	--(CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] ELSE [OverrideHoursWorked] END) AS [HrsWorkedNOLUNCH],
	(CASE
		WHEN DATEPART(WEEKDAY, [EntryDate]) = 1 THEN (CASE WHEN [IncludeLunchSun] = 1 THEN (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) ELSE (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) END)
		WHEN DATEPART(WEEKDAY, [EntryDate]) = 2 THEN (CASE WHEN [IncludeLunchMon] = 1 THEN (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) ELSE (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) END)
		WHEN DATEPART(WEEKDAY, [EntryDate]) = 3 THEN (CASE WHEN [IncludeLunchTue] = 1 THEN (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) ELSE (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) END)
		WHEN DATEPART(WEEKDAY, [EntryDate]) = 4 THEN (CASE WHEN [IncludeLunchWed] = 1 THEN (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) ELSE (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) END)
		WHEN DATEPART(WEEKDAY, [EntryDate]) = 5 THEN (CASE WHEN [IncludeLunchThu] = 1 THEN (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) ELSE (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) END)
		WHEN DATEPART(WEEKDAY, [EntryDate]) = 6 THEN (CASE WHEN [IncludeLunchFri] = 1 THEN (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) ELSE (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) END)
		ELSE (CASE WHEN [IncludeLunchSat] = 1 THEN (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) ELSE (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) END)
	END) AS [HrsWorked],
	(CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] ELSE [OverrideHoursWorked] END) AS [HrsWorkedNOLUNCH],
	[ConfirmedFlag],
	[OverrideFlag] AS [OverrideFlag_],
	[OverrideHoursWorked],
	[SubmitFlag],
	[SubmittedBy],
	MIN([InTimeFromShopClk]) AS [First Sign-in],
	MAX([OutTimeFromShopClk]) AS [Last Sign-out]
FROM @T
LEFT JOIN
	[ClkShiftEmpAssign]
ON
	[@T].[EmployeeNumber] = [ClkShiftEmpAssign].[Emp#]
LEFT JOIN
	[ClkShiftRoundRules V2]
ON
	[ClkShiftEmpAssign].[ShiftID] = [ClkShiftRoundRules V2].[ShiftID]
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
INNER JOIN (
	SELECT 
		[EmployeeNumber],
		MIN([InTimeFromShopClk]) AS [InTimeFromShopClk],
		MIN([InTimeFromShopClk]) AS [OutTimeFromShopClk]
	FROM
		[ClkTransaction]
	WHERE
		([InTimeFromShopClk] BETWEEN @sd AND @ed OR [OutTimeFromShopClk] BETWEEN @sd AND @ed)
		AND [InTimeFromShopClk] IS NOT NULL
	GROUP BY
		[EmployeeNumber]
		
	) AS [A]
ON
	[A].[EmployeeNumber] = [ClkShiftEmpAssign].[Emp#]
WHERE
	([EntryDate] IS NULL OR [EntryDate] BETWEEN @sd AND @ed)
	AND ([InTimeFromShopClk] BETWEEN @sd AND @ed OR [OutTimeFromShopClk] BETWEEN @sd AND @ed)
	AND [InTimeFromShopClk] IS NOT NULL
GROUP BY
	[ClkFrmConfirmID#],
	[@T].[EmployeeNumber],
	[@T].[EmployeeName],
	[EntryDate],
	[HrsWorked],
	[ConfirmedFlag],
	[OverrideFlag],
	[OverrideHoursWorked],
	[SubmitFlag],
	[SubmittedBy],
	[IncludeLunchSun],
	[IncludeLunchMon],
	[IncludeLunchTue],
	[IncludeLunchWed],
	[IncludeLunchThu],
	[IncludeLunchFri],
	[IncludeLunchSat]
--END

--------------------------------------------------------------------------------


SELECT * FROM @T
SELECT * FROM [ClkShiftEmpAssign]

SELECT
	[ClkFrmConfirmID#],
	[@T].[EmployeeNumber],
	[@T].[EmployeeName],
	[EntryDate],
	--(CASE WHEN [IncludeLunch] = 1 THEN (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) ELSE (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) END) AS [HrsWorked],
	--(CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] ELSE [OverrideHoursWorked] END) AS [HrsWorkedNOLUNCH],
	(CASE
		WHEN DATEPART(WEEKDAY, [EntryDate]) = 1 THEN (CASE WHEN [IncludeLunchSun] = 1 THEN (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) ELSE (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) END)
		WHEN DATEPART(WEEKDAY, [EntryDate]) = 2 THEN (CASE WHEN [IncludeLunchMon] = 1 THEN (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) ELSE (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) END)
		WHEN DATEPART(WEEKDAY, [EntryDate]) = 3 THEN (CASE WHEN [IncludeLunchTue] = 1 THEN (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) ELSE (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) END)
		WHEN DATEPART(WEEKDAY, [EntryDate]) = 4 THEN (CASE WHEN [IncludeLunchWed] = 1 THEN (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) ELSE (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) END)
		WHEN DATEPART(WEEKDAY, [EntryDate]) = 5 THEN (CASE WHEN [IncludeLunchThu] = 1 THEN (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) ELSE (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) END)
		WHEN DATEPART(WEEKDAY, [EntryDate]) = 6 THEN (CASE WHEN [IncludeLunchFri] = 1 THEN (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) ELSE (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) END)
		ELSE (CASE WHEN [IncludeLunchSat] = 1 THEN (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) ELSE (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) END)
	END) AS [HrsWorked],
	(CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] ELSE [OverrideHoursWorked] END) AS [HrsWorkedNOLUNCH],
	[ConfirmedFlag],
	[OverrideFlag] AS [OverrideFlag_],
	[OverrideHoursWorked],
	[SubmitFlag],
	[SubmittedBy],
	[InTimeFromShopClk] AS [First Sign-in],
	[OutTimeFromShopClk] AS [Last Sign-out]
	
	FROM @T
LEFT JOIN
	[ClkShiftEmpAssign]
ON
	[@T].[EmployeeNumber] = [ClkShiftEmpAssign].[Emp#]
LEFT JOIN
	[ClkShiftRoundRules V2]
ON
	[ClkShiftEmpAssign].[ShiftID] = [ClkShiftRoundRules V2].[ShiftID]
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
--INNER JOIN (
--	SELECT 
--		[EmployeeNumber],
--		MIN([InTimeFromShopClk]) AS [InTimeFromShopClk],
--		MIN([InTimeFromShopClk]) AS [OutTimeFromShopClk]
--	FROM
--		[ClkTransaction]
--	WHERE
--		([InTimeFromShopClk] BETWEEN @sd AND @ed OR [OutTimeFromShopClk] BETWEEN @sd AND @ed)
--		AND [InTimeFromShopClk] IS NOT NULL
--	GROUP BY
--		[EmployeeNumber]
		
--	) AS [A]
--ON
--	[A].[EmployeeNumber] = [ClkShiftEmpAssign].[Emp#]
WHERE
	([EntryDate] IS NULL OR [EntryDate] BETWEEN @sd AND @ed)
	AND ([InTimeFromShopClk] BETWEEN @sd AND @ed OR [OutTimeFromShopClk] BETWEEN @sd AND @ed)
	AND [InTimeFromShopClk] IS NOT NULL



SELECT
	*
	
	FROM @T
LEFT JOIN
	[ClkShiftEmpAssign]
ON
	[@T].[EmployeeNumber] = [ClkShiftEmpAssign].[Emp#]
LEFT JOIN
	[ClkShiftRoundRules V2]
ON
	[ClkShiftEmpAssign].[ShiftID] = [ClkShiftRoundRules V2].[ShiftID]
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
INNER JOIN (
	SELECT 
		[EmployeeNumber],
		MIN([InTimeFromShopClk]) AS [InTimeFromShopClk],
		MIN([InTimeFromShopClk]) AS [OutTimeFromShopClk]
	FROM
		[ClkTransaction]
	WHERE
		([InTimeFromShopClk] BETWEEN @sd AND @ed OR [OutTimeFromShopClk] BETWEEN @sd AND @ed)
		AND [InTimeFromShopClk] IS NOT NULL
	GROUP BY
		[EmployeeNumber]
		
	) AS [A]
ON
	[A].[EmployeeNumber] = [ClkShiftEmpAssign].[Emp#]
WHERE
	([EntryDate] IS NULL OR [EntryDate] BETWEEN @sd AND @ed)
	AND ([InTimeFromShopClk] BETWEEN @sd AND @ed OR [OutTimeFromShopClk] BETWEEN @sd AND @ed)
	AND [InTimeFromShopClk] IS NOT NULL
--END