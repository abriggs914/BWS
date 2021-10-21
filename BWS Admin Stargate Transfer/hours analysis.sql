USE Stargatedb
GO

DECLARE @ED DATETIME;
SET @ED = '2021-10-21'
DECLARE @T TABLE ([Emp#] BIGINT, [TtlHrs] FLOAT, [Overtime] FLOAT)
INSERT INTO @T
exec [sp_Weekly Payroll Summary] '1-1-2021', '10-21-2021'

select [Emp#], [TtlHrs], [Overtime]
from @T

UNION select [v_WeeklyRpt].[Emp#], Sum([Hours Work]) as TtlHrs,
(CASE WHEN Sum([Hours Work])<=44 THEN '0' ELSE Sum([Hours Work]) END) as Overtime
from [v_WeeklyRpt]
left outer join @T
on [v_WeeklyRpt].[Emp#] = [@T].[Emp#]
where EntryDate between DATEADD(day, -6, @ED) AND @ED
and [@T].[Emp#] is null
group by [v_WeeklyRpt].[Emp#];
