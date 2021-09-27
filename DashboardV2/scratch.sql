USE BWSdb
GO

-- select (CAST(DATENAME(month, ActCompleteDate) AS CHAR(3)) + ' ' + CAST(year(ActCompleteDate) AS VARCHAR(4))) AS [Completed],

DECLARE @SrcTable AS TABLE (
	[Completed] NVARCHAR(16),
	[YearCompleted] INT,
	[MonthCompleted] INT,
	[Current Labour Cost] DECIMAL,
	[Net Productive Hours] DECIMAL,
	[Cost Per Productive Hour] DECIMAL
)

-- DATENAME(MONTH, ActCompleteDate) + ' ' + CAST(year(ActCompleteDate) AS NVARCHAR(4)) AS [C],

INSERT INTO @SrcTable
		select 
			DATENAME(MONTH, ActCompleteDate) + ' - ' + CAST(year(ActCompleteDate) AS NVARCHAR(4)) AS [C2],
			YEAR([ActCompleteDate]) AS [YearCompleted],
			MONTH([ActCompleteDate]) AS [MonthCompleted],
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
		group by DATENAME(MONTH, ActCompleteDate) + ' - ' + CAST(year(ActCompleteDate) AS NVARCHAR(4)), YEAR([ActCompleteDate]), MONTH([ActCompleteDate])


SELECT
	 [Completed],
	 [Current Labour Cost],
	 [Net Productive Hours],
	 [Cost Per Productive Hour]
FROM
	@SrcTable
ORDER BY
	[YearCompleted],
	[MonthCompleted]
;

----------------------------------------------------------------------------------------------------------------
USE BWSdb
GO

		select 
			DATENAME(MONTH, ActCompleteDate) + ' - ' + CAST(year(ActCompleteDate) AS NVARCHAR(4)) AS [Completed],
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
		group by DATENAME(MONTH, ActCompleteDate) + ' - ' + CAST(year(ActCompleteDate) AS NVARCHAR(4)), YEAR([ActCompleteDate]), MONTH([ActCompleteDate])
		ORDER BY YEAR(ActCompleteDate), MONTH(ActCompleteDate)


SELECT
	 [Completed],
	 [Current Labour Cost],
	 [Net Productive Hours],
	 [Cost Per Productive Hour]
FROM
	@SrcTable
ORDER BY
	[YearCompleted],
	[MonthCompleted]
;










select 
            DATENAME(MONTH, ActCompleteDate) + ' - ' + CAST(year(ActCompleteDate) AS NVARCHAR(4)) AS [Completed],
            sum(ExpLabCurrent) as [Current Labour Cost]
        from SysproCompanyA.[dbo].WipMaster with (nolock)
        left outer join (select Job, sum(RunTime) as NetProductiveTime
        from SysproCompanyA.[dbo].WipLabJnl with (nolock)
            inner join SysproCompanyA.[dbo].BomMachine with (nolock) on WipLabJnl.Machine = BomMachine.Machine
                where NonProdCode = ''
                    and (Description not like 'Rework%' or Description not like 'REWORK%')
                group by Job) as subNetProdHours on WipMaster.Job = subNetProdHours.Job
        where ActCompleteDate is not null AND [ActCompleteDate]
        group by DATENAME(MONTH, ActCompleteDate) + ' - ' + CAST(year(ActCompleteDate) AS NVARCHAR(4)), YEAR([ActCompleteDate]), MONTH([ActCompleteDate])
        ORDER BY YEAR(ActCompleteDate), MONTH(ActCompleteDate)