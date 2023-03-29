DECLARE @sd AS DATETIME;
DECLARE @ed AS DATETIME;
SELECT 
	@sd='2023-03-28',
	@ed='2023-03-28 23:59:59'
;

DECLARE @t_A AS TABLE (
	
	[A_EmpName] NVARCHAR(MAX)
	, [A_EmpNum] NVARCHAR(6)
	, [Hours] DECIMAL(14, 7)
	, [ST] DATE
	, [FirstLogOn] DATETIME
	, [LastLogOff] DATETIME
)

DECLARE @t_B AS TABLE (
	
	[A_EmpName] NVARCHAR(MAX)
	, [A_EmpNum] NVARCHAR(6)
	, [Hours] DECIMAL(14, 7)
	, [ST] DATE
	, [FirstLogOn] DATETIME
	, [LastLogOff] DATETIME
)

INSERT INTO @t_A
EXEC [sp_ClkLabourTime] @sd=@sd, @ed=@ed;

--DECLARE @sd DATETIME ='2022-03-11';
--DECLARE @ed DATETIME ='2022-03-11 23:59:59';

DECLARE @T TABLE (
				[QueryID] NVARCHAR(1),
				[EmployeeNumber] REAL,
				[EmployeeName] NVARCHAR(200),
				[HrsWorked] FLOAT,
				[StartDate] DATETIME,
				[EndDate] DATETIME);

INSERT INTO @T EXEC [sp_ClkTallyHours] @sd=@sd, @ed=@ed, @by_transaction=0

INSERT INTO @t_B
SELECT
	[EmployeeName]
	, [@T].[EmployeeNumber] AS [EmployeeNumber]
	--(CASE WHEN [IncludeLunch] = 1 THEN (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) ELSE (CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) END) AS [HrsWorked],
	--(CASE WHEN [OverrideFlag] = 0 THEN [HrsWorked] ELSE [OverrideHoursWorked] END) AS [HrsWorkedNOLUNCH],
	, (CASE
		WHEN DATEPART(WEEKDAY, ISNULL([EntryDate], @sd)) = 1 THEN (CASE WHEN [IncludeLunchSun] = 1 THEN (/*CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] ELSE [OverrideHoursWorked] END*/ [HrsWorked]) - 0.5 ELSE (/*CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] ELSE [OverrideHoursWorked] END*/ [HrsWorked]) END)
		WHEN DATEPART(WEEKDAY, ISNULL([EntryDate], @sd)) = 2 THEN (CASE WHEN [IncludeLunchMon] = 1 THEN (/*CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] ELSE [OverrideHoursWorked] END*/ [HrsWorked]) - 0.5 ELSE (/*CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] ELSE [OverrideHoursWorked] END*/ [HrsWorked]) END)
		WHEN DATEPART(WEEKDAY, ISNULL([EntryDate], @sd)) = 3 THEN (CASE WHEN [IncludeLunchTue] = 1 THEN (/*CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] ELSE [OverrideHoursWorked] END*/ [HrsWorked]) - 0.5 ELSE (/*CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] ELSE [OverrideHoursWorked] END*/ [HrsWorked]) END)
		WHEN DATEPART(WEEKDAY, ISNULL([EntryDate], @sd)) = 4 THEN (CASE WHEN [IncludeLunchWed] = 1 THEN (/*CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] ELSE [OverrideHoursWorked] END*/ [HrsWorked]) - 0.5 ELSE (/*CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] ELSE [OverrideHoursWorked] END*/ [HrsWorked]) END)
		WHEN DATEPART(WEEKDAY, ISNULL([EntryDate], @sd)) = 5 THEN (CASE WHEN [IncludeLunchThu] = 1 THEN (/*CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] ELSE [OverrideHoursWorked] END*/ [HrsWorked]) - 0.5 ELSE (/*CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] ELSE [OverrideHoursWorked] END*/ [HrsWorked]) END)
		WHEN DATEPART(WEEKDAY, ISNULL([EntryDate], @sd)) = 6 THEN (CASE WHEN [IncludeLunchFri] = 1 THEN (/*CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] ELSE [OverrideHoursWorked] END*/ [HrsWorked]) - 0.5 ELSE (/*CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] ELSE [OverrideHoursWorked] END*/ [HrsWorked]) END)
		ELSE (CASE WHEN [IncludeLunchSat] = 1 THEN (/*CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] ELSE [OverrideHoursWorked] END*/ [HrsWorked]) - 0.5 ELSE (/*CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] ELSE [OverrideHoursWorked] END*/ [HrsWorked]) END)
	--, (CASE
	--	WHEN DATEPART(WEEKDAY, ISNULL([EntryDate], @sd)) = 1 THEN (CASE WHEN [IncludeLunchSun] = 1 THEN (CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) ELSE (CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) END)
	--	WHEN DATEPART(WEEKDAY, ISNULL([EntryDate], @sd)) = 2 THEN (CASE WHEN [IncludeLunchMon] = 1 THEN (CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) ELSE (CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) END)
	--	WHEN DATEPART(WEEKDAY, ISNULL([EntryDate], @sd)) = 3 THEN (CASE WHEN [IncludeLunchTue] = 1 THEN (CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) ELSE (CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) END)
	--	WHEN DATEPART(WEEKDAY, ISNULL([EntryDate], @sd)) = 4 THEN (CASE WHEN [IncludeLunchWed] = 1 THEN (CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) ELSE (CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) END)
	--	WHEN DATEPART(WEEKDAY, ISNULL([EntryDate], @sd)) = 5 THEN (CASE WHEN [IncludeLunchThu] = 1 THEN (CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) ELSE (CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) END)
	--	WHEN DATEPART(WEEKDAY, ISNULL([EntryDate], @sd)) = 6 THEN (CASE WHEN [IncludeLunchFri] = 1 THEN (CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) ELSE (CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) END)
	--	ELSE (CASE WHEN [IncludeLunchSat] = 1 THEN (CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) ELSE (CASE WHEN ISNULL([OverrideFlag], 0) = 0 THEN [HrsWorked] - 0.5 ELSE [OverrideHoursWorked] END) END)
	END) AS [HrsWorked]
	, [EntryDate]
	, [StartDate]
	, [EndDate]
	
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
    CROSS JOIN
            (
                select cast(cast(@sd as date) as datetime) + cast(min(StartTime) as time) as FirstInTime,
                case when min(EndTime) <= min(StartTime)
					then
						cast(dateadd(day, 1, cast(@ed as date)) as datetime)
						+ cast(min(EndTime) as time)
					else
						cast(cast(@ed as date) as datetime)
						+ cast(max(EndTime) as time)
					end as LastOutTime
                FROM
                    [ClkShiftRoundRules V2] with (nolock)
            ) as subDateRange
	WHERE
		([InTimeFromShopClk] BETWEEN FirstInTime AND LastOutTime OR [OutTimeFromShopClk] BETWEEN FirstInTime AND LastOutTime)
		AND [InTimeFromShopClk] IS NOT NULL
	GROUP BY
		[EmployeeNumber]
		
	) AS [A]
ON
	[A].[EmployeeNumber] = [ClkShiftEmpAssign].[Emp#]
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
WHERE
	([EntryDate] IS NULL OR [EntryDate] BETWEEN @sd AND @ed)
	AND ([InTimeFromShopClk] BETWEEN @sd AND @ed OR [OutTimeFromShopClk] BETWEEN @sd AND @ed)
	AND [InTimeFromShopClk] IS NOT NULL

------------------------------

--SELECT 'A' AS [T], * FROM @t_A ORDER BY [Hours] DESC;
--SELECT 'B' AS [T], * FROM @t_B ORDER BY [Hours] DESC;
SELECT 'A' AS [T], * FROM @t_A ORDER BY [A_EmpName];
SELECT 'B' AS [T], * FROM @t_B ORDER BY [A_EmpName];

-- employees not on the original calculation sheet:
SELECT
	'Missing in B' AS [T]
	, [@t_A].[A_EmpNum]
	, [@t_A].[A_EmpName]
FROM
	@t_A
LEFT JOIN
	@t_B
ON
	[@t_A].[A_EmpName] = [@t_B].[A_EmpName]
WHERE
	[@t_B].[A_EmpName] IS NULL
;
-- employees not on new calculation sheet:
SELECT
	'Missing in A' AS [T]
	, [@t_B].[A_EmpNum]
	, [@t_B].[A_EmpName]
FROM
	@t_B
LEFT JOIN
	@t_A
ON
	[@t_A].[A_EmpName] = [@t_B].[A_EmpName]
WHERE
	[@t_A].[A_EmpName] IS NULL
;

-- Hour Differences:
SELECT
	[@t_A].[A_EmpName]
	, [@t_A].[A_EmpNum]
	, [@t_A].[Hours] AS [A Hours]
	, [@t_B].[Hours] AS [B Hours]
	, CAST(ABS([@t_A].[Hours] - [@t_B].[Hours]) AS DECIMAL(14, 7)) AS [HD]
	, [@t_A].*
	, [@t_B].*
FROM
	@t_A
FULL OUTER JOIN
	@t_B
ON
	[@t_A].[A_EmpName] = [@t_B].[A_EmpName]
ORDER BY
	[HD] DESC
;

select DATEDIFF(SECOND, '2023-03-28 07:26:00.000', '2023-03-28 16:30:00.000') / (60.0 * 60)
select DATEDIFF(SECOND, '2023-03-28 07:15:00.000', '2023-03-28 16:30:00.000') / (60.0 * 60)