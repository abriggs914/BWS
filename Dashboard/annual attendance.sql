USE SysproCompanyA
GO

DECLARE @SD AS DATETIME, @ED AS DATETIME;
SET @SD = '1950-01-01';
SET @ED = '2050-09-23';

select DATENAME(MONTH, CAST(CAST(year(DateWorked) AS varchar(50))+'-'+RIGHT('00'+CAST(month(DateWorked) AS varchar(50)), 2)+'-01' AS DATETIME)) + ' - ' + CAST(year(DateWorked) AS varchar(30)) AS [Date],
sum(case [Absent] when 0 then 0 when 1 then 1 end) as Attendance
from BWSdb.dbo.[Hours Worked] with (nolock)
where DateWorked between @SD and @ED
group by year(DateWorked), month(DateWorked)
order by year(DateWorked), month(DateWorked)



select year(DateWorked) as [Date],
sum(case [Absent] when 0 then 0 when 1 then 1 end) as Attendance
from BWSdb.dbo.[Hours Worked] with (nolock)
where DateWorked between @SD and @ED
group by year(DateWorked)
order by year(DateWorked)