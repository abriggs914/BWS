USE SysproCompanyA
GO


DECLARE @SD AS DATETIME, @ED AS DATETIME;
SET @SD = '2001-01-01';
SET @ED = '2050-09-23';

IF OBJECT_ID('tempdb..#totalprodhours') IS NOT NULL
	DROP TABLE #totalprodhours

create table #totalprodhours
(
	PostYear int,
	PostMonth int,
	NetHours decimal(18, 6)
)

insert into #totalprodhours
select PostYear, PostMonth, sum(NetHours)
from
(
select year(TrnDate) as PostYear,
month(TrnDate) as PostMonth,
sum(LRunTimeHours) as NetHours
from WipJobPost with (nolock)
inner join WipMaster with (nolock) on WipJobPost.Job = WipMaster.Job
inner join BomEmployee with (nolock) on WipJobPost.LEmployee = BomEmployee.Employee
where JobClassification in ('REP', 'PAR', 'TRA', 'SUB', 'WAR', 'FIX', 'R&D')
or (JobClassification = 'MAIN' and WorkCentre not in ('MI', 'WI', 'NP'))
group by year(TrnDate), month(TrnDate)

union all select year(EntryDate) as JnlYear,
month(EntryDate) as JnlMonth,
sum(RunTime) as NetHours
from WipLabJnl with (nolock)
inner join BomEmployee with (nolock) on WipLabJnl.Employee = BomEmployee.Employee
where BomEmployee.WorkCentre not in ('MI', 'WI', 'NP')
and NonProdCode in (01, 02, 03, 05, 06, 07, 08, 09, 10, 12, 13, 14, 15, 16, 17, 21)
group by year(EntryDate), month(EntryDate)
)
as mainsub
group by PostYear, PostMonth



SELECT
	DATENAME(MONTH, CAST(CAST(NonProdYear AS varchar(50))+'-'+RIGHT('00'+CAST(NonProdMonth AS varchar(50)), 2)+'-01' AS DATETIME)) + ' - ' + CAST(NonProdYear AS varchar(30)) AS [Date],
	NonProdHours,
	NetHours,
	[NP Hour %]
FROM (
	select year(EntryDate) as NonProdYear,
	month(EntryDate) as NonProdMonth,
	sum(RunTime) as NonProdHours,
	NetHours,
	case when NetHours = 0 then sum(RunTime) / 1 else sum(RunTime) / NetHours end as [NP Hour %]
	from WipLabJnl with (nolock)
	inner join WipScrapCode with (nolock) on WipLabJnl.NonProdCode = WipScrapCode.NonProdScrap
	inner join BomEmployee with (nolock) on WipLabJnl.Employee = BomEmployee.Employee
	left outer join #totalprodhours as SubProdHours on year(EntryDate) = PostYear
													   and month(EntryDate) = PostMonth
	where BomEmployee.WorkCentre not in ('MI', 'WI', 'NP') AND [EntryDate] BETWEEN @SD and @ED
	group by year(EntryDate), month(EntryDate), NetHours
) AS [Src]
order by NonProdYear, NonProdMonth