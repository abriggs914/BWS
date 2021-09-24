USE SysproCompanyA
GO



DECLARE @SD AS DATETIME, @ED AS DATETIME;
SET @SD = '1950-01-01';
SET @ED = '2050-09-23';

select 
DATENAME(MONTH, CAST(CAST(year(ActCompleteDate) AS varchar(50))+'-'+RIGHT('00'+CAST(month(ActCompleteDate) AS varchar(50)), 2)+'-01' AS DATETIME)) + ' - ' + CAST(year(ActCompleteDate) AS varchar(30)) AS [DateN],
DATEPART(MONTH, CAST(CAST(year(ActCompleteDate) AS varchar(50))+'-'+RIGHT('00'+CAST(month(ActCompleteDate) AS varchar(50)), 2)+'-01' AS DATETIME)) + ' - ' + CAST(year(ActCompleteDate) AS varchar(30)) AS [DateP],
sum(ValueIssued) as Labour, sum(UnitValueReqd) as Budget
from WipMaster
inner join WipJobAllLab on WipMaster.Job = WipJobAllLab.Job
where ActCompleteDate is not null and ActCompleteDate BETWEEN @SD AND @ED
group by year(ActCompleteDate), month(ActCompleteDate)
order by year(ActCompleteDate), month(ActCompleteDate)


select year(ActCompleteDate) as YearCompleted,
sum(ValueIssued) as Labour, sum(UnitValueReqd) as Budget
from WipMaster 
inner join WipJobAllLab on WipMaster.Job = WipJobAllLab.Job
where ActCompleteDate is not null and ActCompleteDate BETWEEN @SD AND @ED
group by year(ActCompleteDate)
order by year(ActCompleteDate)


    --DATENAME(MONTH, ActCompleteDate) + ' - ' + CAST(year(ActCompleteDate) AS varchar(30)) AS [Date],
    --sum(UnitValueReqd) as Budget
    --from WipMaster with (nolock)
    --inner join WipJobAllLab with (nolock) on WipMaster.Job = WipJobAllLab.Job
    --where ActCompleteDate is not null and ActCompleteDate BETWEEN \'{SD}\' AND \'{ED}\'
    --group by year(ActCompleteDate), month(ActCompleteDate)
    --order by year(ActCompleteDate), month(ActCompleteDate)