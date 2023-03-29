USE SysproCompanyA
GO


--ALTER PROCEDURE [sp_ClkLabourTime] 
--	@sd AS DATETIME,
--	@ed AS DATETIME,
--	@w AS INT = 3

--AS 
--BEGIN


DECLARE @sd AS DATETIME;
DECLARE @ed AS DATETIME;
DECLARE @w AS INT;
DECLARE @minLunchThreshold AS INT;
SELECT 
	@sd='2023-03-28'
	, @ed='2023-03-28 23:59:59'
	, @w = 3
	, @minLunchThreshold = 5
;

SELECT
	CAST([SrcD].[A_EmpNum] AS REAL) AS [EmployeeNumber]
	, [SrcD].[A_EmpName] AS [EmployeeName]
	--(CASE WHEN [IncludeLunch] = 1 THEN (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) ELSE (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) END) AS [HrsWorked],
	--(CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] ELSE [OverrideHoursWorked] END) AS [HrsWorkedNOLUNCH],
	, (CASE WHEN [Hours] < @minLunchThreshold THEN [Hours] ELSE
		(CASE WHEN DATEPART(WEEKDAY, [SrcD].[EntryDate]) = 0 THEN (
			(CASE WHEN [IncludeLunchSun] = 1 THEN [Hours] - 0.5 ELSE [Hours] END))
		WHEN DATEPART(WEEKDAY, [SrcD].[EntryDate]) = 1 THEN (
			(CASE WHEN [IncludeLunchMon] = 1 THEN [Hours] - 0.5 ELSE [Hours] END))
		WHEN DATEPART(WEEKDAY, [SrcD].[EntryDate]) = 2 THEN (
			(CASE WHEN [IncludeLunchTue] = 1 THEN [Hours] - 0.5 ELSE [Hours] END))
		WHEN DATEPART(WEEKDAY, [SrcD].[EntryDate]) = 3 THEN (
			(CASE WHEN [IncludeLunchWed] = 1 THEN [Hours] - 0.5 ELSE [Hours] END))
		WHEN DATEPART(WEEKDAY, [SrcD].[EntryDate]) = 4 THEN (
			(CASE WHEN [IncludeLunchThu] = 1 THEN [Hours] - 0.5 ELSE [Hours] END))
		WHEN DATEPART(WEEKDAY, [SrcD].[EntryDate]) = 5 THEN (
			(CASE WHEN [IncludeLunchFri] = 1 THEN [Hours] - 0.5 ELSE [Hours] END))
		WHEN DATEPART(WEEKDAY, [SrcD].[EntryDate]) = 6 THEN (
			(CASE WHEN [IncludeLunchSat] = 1 THEN [Hours] - 0.5 ELSE [Hours] END))
		ELSE [Hours] END)

	END) AS [HrsWorked]
	, [FirstLogOn]
	, [LastLogOff]
	, [PK]
	, [ClkShiftEmpAssign].[ShiftID]
	, [ClkShiftEmpAssign].[Emp#]
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
	, [SrcD].[EntryDate]
	, [OverrideFlag]
	, [HoursWorked]
	, [ConfirmedFlag]
	, [OverrideHoursWorked]
	, [SubmitFlag]
	, [SubmittedBy]
	, [FirstLogOn] AS [InTimeFromShopClk]
	, [LastLogOff] AS [OutTimeFromShopClk]
	, ISNULL([SrcD].[EntryDate], @sd) AS [EntryDate]
	, ApprovedByForeman
	, ForemanApprovalDate
	, ApprovedByPayroll
	, PayrollApprovalDate
	, [ClkShiftRoundRules V2].[Name] as [Shift Name]
	, [SubDept].[Dept] as [Manpower Report Department]
	--, (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] ELSE [OverrideHoursWorked] END) AS [HrsWorkedNOLUNCH]



	
	FROM  (
	SELECT
		[A_EmpName]
		, [A_EmpNum]
		, CAST(DATEDIFF(SECOND, [FirstLogOn], [LastLogOff]) / (60.0 * 60) AS DECIMAL(14, 3)) AS [Hours]
		, [EntryDate]
		, [FirstLogOn]
		, [LastLogOff]
	FROM (
		SELECT
			[A_EmpName]
			, [A_EmpNum]
			, SUM([A_Len]) AS [Hours]
			, CAST([ST] AS DATE) AS [EntryDate]
			, MIN([A_LoggedOn]) AS [FirstLogOn]
			, MAX([A_LoggedOff]) AS [LastLogOff]
		FROM (
			SELECT 
				[A_EmpName]
				, [A_EmpNum]
				, [A_LoggedOn]
				, [A_LoggedOff]
				, [A_Len]
				, [ST]
				, [ET]
				, DATEDIFF(SECOND,
					(CASE WHEN [A_LoggedOn] <= [ST] THEN [ST] ELSE [A_LoggedOn] END),
					(CASE WHEN [A_LoggedOff] >= [ET] THEN [ET] ELSE [A_LoggedOff] END)
				) AS [ToS]
			FROM (
				SELECT
					[ClkTransaction].[EmployeeName] AS [A_EmpName]
					, [ClkTransaction].[EmployeeNumber] AS [A_EmpNum]
					, [ClkTransaction].[InTimeFromShopClk] AS [A_LoggedOn]
					, [ClkTransaction].[OutTimeFromShopClk] AS [A_LoggedOff]
					, DATEDIFF(SECOND, [ClkTransaction].[InTimeFromShopClk], [ClkTransaction].[OutTimeFromShopClk]) / (60.0 * 60) AS [A_Len]
					, DATEADD(HOUR, @w, DATEADD(DAY, DAY(@sd) - 1, DATEADD(MONTH, MONTH(@sd) - 1, (DATEADD(YEAR, YEAR(@sd) - 1900, CAST([StartTime] AS DATETIME)))))) AS [ST]
					, DATEADD(HOUR, @w, DATEADD(DAY, DAY(@ed) - 1, DATEADD(MONTH, MONTH(@ed) - 1, (DATEADD(YEAR, YEAR(@ed) - 1900, CAST([EndTime] AS DATETIME)))))) AS [ET]
				FROM
					[ClkTransaction]
				INNER JOIN
					[ClkShiftEmpAssign]
				ON
					[ClkTransaction].[EmployeeNumber] = [ClkShiftEmpAssign].[Emp#]
				INNER JOIN
					[ClkShiftRoundRules V2]
				ON
					[ClkShiftRoundRules V2].[ShiftID] = [ClkShiftEmpAssign].[ShiftID]
				WHERE
					LEFT([EmployeeNumber], 1) = '2'
					AND
					([InTimeFromShopClk] BETWEEN DATEADD(HOUR, -6, DATEADD(DAY, DAY(@sd) - 1, DATEADD(MONTH, MONTH(@sd) - 1, (DATEADD(YEAR, YEAR(@sd) - 1900, CAST([StartTime] AS DATETIME)))))) AND DATEADD(HOUR, 6, DATEADD(DAY, DAY(@ed) - 1, DATEADD(MONTH, MONTH(@ed) - 1, (DATEADD(YEAR, YEAR(@ed) - 1900, CAST([EndTime] AS DATETIME))))))
					OR [OutTimeFromShopClk] BETWEEN DATEADD(HOUR, -6, DATEADD(DAY, DAY(@sd) - 1, DATEADD(MONTH, MONTH(@sd) - 1, (DATEADD(YEAR, YEAR(@sd) - 1900, CAST([StartTime] AS DATETIME)))))) AND DATEADD(HOUR, 6, DATEADD(DAY, DAY(@ed) - 1, DATEADD(MONTH, MONTH(@ed) - 1, (DATEADD(YEAR, YEAR(@ed) - 1900, CAST([EndTime] AS DATETIME)))))))
			) AS [SrcA]
		) AS [SrcB]
		WHERE
			[ToS] >= 0
		GROUP BY
			[A_EmpName]
			, [A_EmpNum]
			, [ST]
	) AS [SrcC]
) AS [SrcD]
LEFT JOIN
	[ClkShiftEmpAssign]
ON
	[SrcD].[A_EmpNum] = CAST([ClkShiftEmpAssign].[Emp#] AS NVARCHAR(MAX))
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
	[Src].[EmployeeNumber] = [SrcD].[A_EmpNum]
--INNER JOIN (
--	SELECT 
--		[EmployeeNumber],
--		MIN([InTimeFromShopClk]) AS [InTimeFromShopClk],
--		MAX([OutTimeFromShopClk]) AS [OutTimeFromShopClk]
--	FROM
--		[ClkTransaction]
--    CROSS JOIN
--            (
--                select cast(cast(@sd as date) as datetime) + cast(min(StartTime) as time) as FirstInTime,
--                case when min(EndTime) <= min(StartTime)
--					then
--						cast(dateadd(day, 1, cast(@ed as date)) as datetime)
--						+ cast(min(EndTime) as time)
--					else
--						cast(cast(@ed as date) as datetime)
--						+ cast(max(EndTime) as time)
--					end as LastOutTime
--                FROM
--                    [ClkShiftRoundRules V2] with (nolock)
--            ) as subDateRange
--	WHERE
--		([InTimeFromShopClk] BETWEEN FirstInTime AND LastOutTime OR [OutTimeFromShopClk] BETWEEN FirstInTime AND LastOutTime)
--		AND [InTimeFromShopClk] IS NOT NULL
--	GROUP BY
--		[EmployeeNumber]
		
--	) AS [A]
--ON
--	[A].[EmployeeNumber] = [ClkShiftEmpAssign].[Emp#]
LEFT JOIN (
	select Emp#, Dept.Dept
	from 
		BWSdb.dbo.Employees with (nolock)
	inner join 
		BWSdb.dbo.Dept with (nolock) 
	on 
		Employees.Dept = Dept.DeptID
    WHERE
        Terminated is NULL
        or Terminated > @ed

) as [SubDept]
ON
	convert(real, right([ClkShiftEmpAssign].[Emp#], 3)) = [SubDept].[Emp#]
--WHERE
--	([SrcC].[EntryDate] IS NULL OR [SrcC].[EntryDate] BETWEEN @sd AND @ed)
--	AND ([InTimeFromShopClk] BETWEEN @sd AND @ed OR [OutTimeFromShopClk] BETWEEN @sd AND @ed)
--	AND [InTimeFromShopClk] IS NOT NULL



	ORDER BY
		[A_EmpName]
	

--END