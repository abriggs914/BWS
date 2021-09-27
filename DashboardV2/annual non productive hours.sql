USE SysproCompanyA
GO


DECLARE @SD AS DATETIME, @ED AS DATETIME;
SET @SD = '2001-01-01';
SET @ED = '2050-09-23';

SELECT
        [NonProdYear] AS [Date],
        ROUND([NP Hour %] * 100, 2) AS [NP Hour %]
    FROM (
select year(EntryDate) as NonProdYear,
sum(RunTime) as NonProdHours,
sum(NetHours) as NetHours,
case when sum(NetHours) = 0 then sum(RunTime) / 1 else sum(RunTime) / sum(NetHours) end as [NP Hour %]
from WipLabJnl with (nolock)
inner join WipScrapCode with (nolock) on WipLabJnl.NonProdCode = WipScrapCode.NonProdScrap
inner join BomEmployee with (nolock) on WipLabJnl.Employee = BomEmployee.Employee
left outer join (
                select PostYear, PostMonth, sum(NetHours) AS [NetHours]
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
            )
	
as SubProdHours on year(EntryDate) = PostYear
where BomEmployee.WorkCentre not in ('MI', 'WI', 'NP') AND [EntryDate] BETWEEN @SD and @ED
group by year(EntryDate)
) AS [Src]
    order by NonProdYear