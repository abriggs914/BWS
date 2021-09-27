USE SysproCompanyA
GO

DECLARE @SD AS DATETIME, @ED AS DATETIME;
SET @SD = '1950-01-01';
SET @ED = '2050-09-23';

SELECT
	YearCompleted AS [Date],
	[Budget]
FROM (
select year(ActCompleteDate) as YearCompleted,
sum(IExpUnitRunTim) as Budget, sum(RunTimeIssued) as Actual
from WipMaster with (nolock)
inner join WipJobAllLab with (nolock) on WipMaster.Job = WipJobAllLab.Job
where ActCompleteDate is not null and [JobDeliveryDate] BETWEEN @SD AND @ED
group by year(ActCompleteDate)
) AS [Src]
order by YearCompleted