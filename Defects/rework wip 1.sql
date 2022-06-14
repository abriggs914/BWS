
DECLARE @sd AS DATETIME;
DECLARE @ed AS DATETIME;
SET @sd = '2021-06-08'
SET @ed = '2022-06-08'



select WipMaster.Job, WipMaster.JobDescription, 
	BomMachine.Machine as Machine, 
	BomMachine.Description, dbo.ToProperCase(Name) as Name,
	sum(RunTime) as RWHours, JobTtlHours,
	case when JobTtlHours = 0 or JobTtlHours is null then 0 else (sum(RunTime) / JobTtlHours) * 100 end as PercentageofTotal
	from WipLabJnl with (nolock)
	inner join WipMaster with (nolock) on WipLabJnl.Job = WipMaster.Job
	inner join BomMachine with (nolock) on WipLabJnl.Machine = BomMachine.Machine
	inner join BomEmployee with (nolock) on WipLabJnl.Employee = BomEmployee.Employee
	--Job Total Runtime for date range
	inner join (select WipMaster.Job, sum(RunTime) as JobTtlHours from WipLabJnl with (nolock)
					    inner join WipMaster with (nolock) on WipLabJnl.Job = WipMaster.Job
					    where EntryDate between @sd and @ed
					    group by WipMaster.Job) as subA on WipMaster.Job = subA.Job
	where EntryDate between @sd and @ed
	and (BomMachine.Description like '%Rework%' or BomMachine.Description like '%REWORK%')
	group by WipMaster.Job, WipMaster.JobDescription, BomMachine.Machine, BomMachine.Description, Name, JobTtlHours
	having sum(RunTime) <> 0


select [EntryDate], WipMaster.Job, WipMaster.JobDescription, 
	BomMachine.Machine as Machine, 
	BomMachine.Description, dbo.ToProperCase(Name) as Name,
	sum(RunTime) as RWHours, JobTtlHours,
	case when JobTtlHours = 0 or JobTtlHours is null then 0 else (sum(RunTime) / JobTtlHours) * 100 end as PercentageofTotal
	from WipLabJnl with (nolock)
	inner join WipMaster with (nolock) on WipLabJnl.Job = WipMaster.Job
	inner join BomMachine with (nolock) on WipLabJnl.Machine = BomMachine.Machine
	inner join BomEmployee with (nolock) on WipLabJnl.Employee = BomEmployee.Employee
	--Job Total Runtime for date range
	inner join (select WipMaster.Job, sum(RunTime) as JobTtlHours from WipLabJnl with (nolock)
					    inner join WipMaster with (nolock) on WipLabJnl.Job = WipMaster.Job
					    where EntryDate between @sd and @ed
					    group by WipMaster.Job) as subA on WipMaster.Job = subA.Job
	where EntryDate between @sd and @ed
	and (BomMachine.Description like '%Rework%' or BomMachine.Description like '%REWORK%')
	group by [EntryDate], WipMaster.Job, WipMaster.JobDescription, BomMachine.Machine, BomMachine.Description, Name, JobTtlHours
	having sum(RunTime) <> 0
	ORDER BY [EntryDate] DESC