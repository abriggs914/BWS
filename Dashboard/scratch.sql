USE BWSdb
GO

-- select (CAST(DATENAME(month, ActCompleteDate) AS CHAR(3)) + ' ' + CAST(year(ActCompleteDate) AS VARCHAR(4))) AS [Completed],

DECLARE @SrcTable AS TABLE ()

select year(ActCompleteDate) as YearCompleted, month(ActCompleteDate) as MonthCompleted,
sum(ExpLabCurrent) as [Current Labour Cost], 
sum(case when NetProductiveTime is null then 0 else NetProductiveTime end) as [Net Productive Hours],
sum(ExpLabCurrent) / sum(case when NetProductiveTime is null then 0 else NetProductiveTime end) as [Cost Per Productive Hour]
from SysproCompanyA.[dbo].WipMaster with (nolock)
left outer join (select Job, sum(RunTime) as NetProductiveTime
				from SysproCompanyA.[dbo].WipLabJnl with (nolock)
				inner join SysproCompanyA.[dbo].BomMachine with (nolock) on WipLabJnl.Machine = BomMachine.Machine
				where NonProdCode = ''
				and (Description not like 'Rework%' or Description not like 'REWORK%')
				group by Job) as subNetProdHours on WipMaster.Job = subNetProdHours.Job
where ActCompleteDate is not null
group by year(ActCompleteDate), month(ActCompleteDate)
order by year(ActCompleteDate), month(ActCompleteDate)


select year(ActCompleteDate) as YearCompleted, month(ActCompleteDate) as MonthCompleted,
sum(ExpLabCurrent) as [Current Labour Cost], 
sum(case when NetProductiveTime is null then 0 else NetProductiveTime end) as [Net Productive Hours],
sum(ExpLabCurrent) / sum(case when NetProductiveTime is null then 0 else NetProductiveTime end) as [Cost Per Productive Hour]
from SysproCompanyA.[dbo].WipMaster with (nolock)
left outer join (select Job, sum(RunTime) as NetProductiveTime
				from SysproCompanyA.[dbo].WipLabJnl with (nolock)
				inner join SysproCompanyA.[dbo].BomMachine with (nolock) on WipLabJnl.Machine = BomMachine.Machine
				where NonProdCode = ''
				and (Description not like 'Rework%' or Description not like 'REWORK%')
				group by Job) as subNetProdHours on WipMaster.Job = subNetProdHours.Job
where ActCompleteDate is not null
group by year(ActCompleteDate), month(ActCompleteDate)
order by year(ActCompleteDate), month(ActCompleteDate)