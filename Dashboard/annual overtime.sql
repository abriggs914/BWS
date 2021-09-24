USE SysproCompanyA
GO


DECLARE @SD AS DATETIME, @ED AS DATETIME;
SET @SD = '1950-01-01';
SET @ED = '2050-09-23';

select 
DATENAME(MONTH, CAST(CAST(year(OTDate) AS varchar(50))+'-'+RIGHT('00'+CAST(month(OTDate) AS varchar(50)), 2)+'-01' AS DATETIME)) + ' - ' + CAST(year(OTDate) AS varchar(30)) AS [Date],
sum(Overtime) as Overtime
from BWSdb.dbo.dtOvertimeYTD with (nolock)
group by year(OTDate), month(OTDate)
order by year(OTDate), month(OTDate)




select year(OTDate) as [Date],
sum(Overtime) as Overtime
from BWSdb.dbo.dtOvertimeYTD with (nolock)
where [OTDate] BETWEEN @SD AND @ED
group by year(OTDate)
order by year(OTDate)