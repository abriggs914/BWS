USE [SysproCompanyA]
GO


-- RUN THIS FOR JEN



/****** Object:  StoredProcedure [dbo].[sp_ClkLabourOverride]    Script Date: 2022-03-14 3:35:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_ClkLabourOverride]
--DECLARE
	@sd DATETIME, @ed DATETIME
--SET @sd = '2022-02-10'
--SET @ed = '2022-02-10 23:59:59'
AS
BEGIN


--DECLARE @sd DATETIME ='2022-03-11';
--DECLARE @ed DATETIME ='2022-03-11 23:59:59';

DECLARE @T TABLE ([EmployeeNumber] REAL,
				[EmployeeName] NVARCHAR(200),
				[HrsWorked] FLOAT,
				[StartDate] DATETIME,
				[EndDate] DATETIME);

INSERT INTO @T EXEC [sp_ClkTallyHours] @sd=@sd, @ed=@ed, @by_transaction=0

SELECT
	[@T].[EmployeeNumber]
	, [EmployeeName]
	--(CASE WHEN [IncludeLunch] = 1 THEN (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) ELSE (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) END) AS [HrsWorked],
	--(CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] ELSE [OverrideHoursWorked] END) AS [HrsWorkedNOLUNCH],
	, (CASE
		WHEN DATEPART(WEEKDAY, ISNULL([EntryDate], @sd)) = 1 THEN (CASE WHEN [IncludeLunchSun] = 1 THEN (CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) ELSE (CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) END)
		WHEN DATEPART(WEEKDAY, ISNULL([EntryDate], @sd)) = 2 THEN (CASE WHEN [IncludeLunchMon] = 1 THEN (CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) ELSE (CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) END)
		WHEN DATEPART(WEEKDAY, ISNULL([EntryDate], @sd)) = 3 THEN (CASE WHEN [IncludeLunchTue] = 1 THEN (CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) ELSE (CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) END)
		WHEN DATEPART(WEEKDAY, ISNULL([EntryDate], @sd)) = 4 THEN (CASE WHEN [IncludeLunchWed] = 1 THEN (CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) ELSE (CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) END)
		WHEN DATEPART(WEEKDAY, ISNULL([EntryDate], @sd)) = 5 THEN (CASE WHEN [IncludeLunchThu] = 1 THEN (CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) ELSE (CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) END)
		WHEN DATEPART(WEEKDAY, ISNULL([EntryDate], @sd)) = 6 THEN (CASE WHEN [IncludeLunchFri] = 1 THEN (CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) ELSE (CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) END)
		ELSE (CASE WHEN [IncludeLunchSat] = 1 THEN (CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) ELSE (CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) END)
	END) AS [HrsWorked]
	, [StartDate]
	, [EndDate]
	, [PK]
	, [ClkShiftEmpAssign].[ShiftID]
	, [Emp#]
	, [Name]
	, [StartTime]
	, [EndTime]
	, [Interval]
	, [EarlyThreshold]
	, [LateThreshold]
	, [IncludeLunchSun]
	, [IncludeLunchMon]
	, [IncludeLunchTue]
	, [IncludeLunchWed]
	, [IncludeLunchThu]
	, [IncludeLunchFri]
	, [IncludeLunchSat]
	, [ClkFrmConfirmID#]
	, [@T].[EmployeeNumber]
	, [EntryDate]
	, [HoursWorked]
	, [ConfirmedFlag]
	, [OverrideHoursWorked]
	, [SubmitFlag]
	, [SubmittedBy]
	, [@T].[EmployeeNumber]
	, [InTimeFromShopClk]
	, [OutTimeFromShopClk]
	, ISNULL([EntryDate], @sd) AS [EntryDate]
	--, (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] ELSE [OverrideHoursWorked] END) AS [HrsWorkedNOLUNCH]



	
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
		MAX([OutTimeFromShopClk]) AS [OutTimeFromShopClk]
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

END