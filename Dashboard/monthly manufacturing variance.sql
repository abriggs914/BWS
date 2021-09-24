
select YearMV, MonthMV,
sum(ManufacturingVariance) as ManufacturingVariance
from 
(
select year(PeriodEndDate) as YearMV,
month(PeriodEndDate) as MonthMV,
case when [ReportIndex1 V2] in ('30-9', '50-8') and [ReportIndex2 V2] = '3-06' then cast(EntryValue * 0.9 as float)
	 else cast(EntryValue as float) end as ManufacturingVariance
from #GLTransactions as GenTransaction with (nolock) 
inner join #PeriodEndDates on GenTransaction.GlYear = #PeriodEndDates.GlYear
							  and GenTransaction.GlPeriod = #PeriodEndDates.GlPeriod
inner join BWSdb.dbo.[dtIncomeStatementGLCodes V2] with (nolock) on GenTransaction.GlCode = [dtIncomeStatementGLCodes V2].GLCode collate Latin1_General_BIN
where ([ReportIndex1 V2] in ('30-9', '50-8') and [ReportIndex2 V2] <> '')
or ([ReportIndex1 V2] = '30-9' and [ReportIndex2 V2] = '')
)
as mainsub
group by YearMV, MonthMV
order by YearMV