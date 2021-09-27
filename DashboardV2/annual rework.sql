USE SysproCompanyA
GO

DECLARE @SD AS DATETIME, @ED AS DATETIME;
SET @SD = '1950-01-01';
SET @ED = '2050-09-23';

select DATENAME(MONTH, CAST(CAST(year(ActCompleteDate) AS varchar(50))+'-'+RIGHT('00'+CAST(month(ActCompleteDate) AS varchar(50)), 2)+'-01' AS DATETIME)) + ' - ' + CAST(year(ActCompleteDate) AS varchar(30)) AS [Date],
sum(RunTime) as NetReworkTime
from WipLabJnl with (nolock)
inner join BomMachine with (nolock) on WipLabJnl.Machine = BomMachine.Machine
inner join WipMaster with (nolock) on WipLabJnl.Job = WipMaster.Job
where (Description like 'Rework%' or Description like 'REWORK%')
and ActCompleteDate is not null and ActCompleteDate between @SD and @ED
group by year(ActCompleteDate), month(ActCompleteDate)
order by year(ActCompleteDate), month(ActCompleteDate)




select year(ActCompleteDate) as [Date],
sum(RunTime) as NetReworkTime
from WipLabJnl with (nolock)
inner join BomMachine with (nolock) on WipLabJnl.Machine = BomMachine.Machine
inner join WipMaster with (nolock) on WipLabJnl.Job = WipMaster.Job
where (Description like 'Rework%' or Description like 'REWORK%')
and ActCompleteDate is not null and ActCompleteDate between @SD and @ED
group by year(ActCompleteDate)
order by year(ActCompleteDate)