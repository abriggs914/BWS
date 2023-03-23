USE SysproCompanyA
GO

DECLARE @T TABLE (
				[QueryID] NVARCHAR(1),
				[EmployeeNumber] REAL,
				[EmployeeName] NVARCHAR(200),
				[HrsWorked] FLOAT,
				[StartDate] DATETIME,
				[EndDate] DATETIME);

DECLARE @sd AS DATETIME = '2023-03-22';
DECLARE @ed AS DATETIME = '2023-03-22 23:59:59';
DECLARE @w AS INT = 0;
INSERT INTO @T EXEC [sp_ClkTallyHours] @sd=@sd, @ed=@ed, @by_transaction=0

SELECT
		*
	FROM
		[ClkFrmConfirm]
	WHERE
		[EntryDate] BETWEEN @sd AND @ed
		AND [EmployeeNumber] = 200528
	ORDER BY
		[EmployeeNumber]
;

SELECT
	*
FROM
	@T
WHERE
	LOWER([EmployeeName]) LIKE '%dem%'
ORDER BY
	[EmployeeName]
;
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
		AND [EmployeeNumber] = 200528
	GROUP BY
		[EmployeeNumber]
	ORDER BY
		[EmployeeNumber]

SELECT 
	'CT' AS [Table], *
FROM 
	[ClkTransaction]
WHERE
	(
		[LoggedOn] BETWEEN DATEADD(DAY, -@w, @sd) AND DATEADD(DAY, @W, @ed)
		OR [LoggedOff] BETWEEN DATEADD(DAY, -@w, @sd) AND DATEADD(DAY, @W, @ed)
	)
	AND LOWER([EmployeeName]) LIKE '%dem%'
	AND (
		[InTimeFromShopClk] BETWEEN DATEADD(DAY, -@w, @sd) AND DATEADD(DAY, @W, @ed)
		OR [OutTimeFromShopClk] BETWEEN DATEADD(DAY, -@w, @sd) AND DATEADD(DAY, @W, @ed)
	)
	--AND (
		
	--	([EntryDate] IS NULL OR [EntryDate] BETWEEN @sd AND @ed)
	--	AND
	--	([InTimeFromShopClk] BETWEEN @sd AND @ed OR [OutTimeFromShopClk] BETWEEN @sd AND @ed)
	--	AND [InTimeFromShopClk] IS NOT NULL
	--)
ORDER BY
	[EmployeeName]
	,[LoggedOn]

SELECT 
	*
FROM
	[ClkShiftEmpAssign]
WHERE
	[ClkShiftEmpAssign].[Emp#] = 200528;

select Emp#, Dept.Dept
	from 
		BWSdb.dbo.Employees with (nolock)
	inner join 
		BWSdb.dbo.Dept with (nolock) 
	on 
		Employees.Dept = Dept.DeptID
    WHERE
        (Terminated is NULL
        or Terminated > @ed)
		AND [Emp#] = 200528