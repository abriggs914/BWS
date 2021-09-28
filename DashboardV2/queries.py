from formatters import *


# {"query": '''''',
# "output_filename": "",
# "x_axis": "",
# "title": "",
# "x_lbl": "",
# "y_lbl": "",
# "formatter": Formatter}

QUERY__annual_labour_costs = {
        "query": '''
            select year(ActCompleteDate) as YearCompleted,
            sum(ExpLabCurrent) as [Current Labour Cost]
            from SysproCompanyA.[dbo].WipMaster with (nolock)
            left outer join (select Job, sum(RunTime) as NetProductiveTime
                            from SysproCompanyA.[dbo].WipLabJnl with (nolock)
                            inner join SysproCompanyA.[dbo].BomMachine with (nolock) on WipLabJnl.Machine = BomMachine.Machine
                            where NonProdCode = ''
                            and (Description not like 'Rework%' or Description not like 'REWORK%')
                            group by Job) as subNetProdHours on WipMaster.Job = subNetProdHours.Job
            where ActCompleteDate is not null and ActCompleteDate between \'{SD}\' and \'{ED}\'
            group by year(ActCompleteDate)
            order by year(ActCompleteDate)
            ;''',
        "output_filename": "Annual Labour Costs",
        "x_axis": "YearCompleted",
        "title": "Annual Labour Costs",
        "x_lbl": "Year Completed",
        "y_lbl": "Cost",
        "formatter": MoneyFormatter
}


QUERY__annual_productive_hours = {
        "query": '''select year(ActCompleteDate) as YearCompleted,
    sum(case when NetProductiveTime is null then 0 else NetProductiveTime end) as [Net Productive Hours]
    from SysproCompanyA.[dbo].WipMaster with (nolock)
    left outer join (select Job, sum(RunTime) as NetProductiveTime
                    from SysproCompanyA.[dbo].WipLabJnl with (nolock)
                    inner join SysproCompanyA.[dbo].BomMachine with (nolock) on WipLabJnl.Machine = BomMachine.Machine
                    where NonProdCode = ''
                    and (Description not like 'Rework%' or Description not like 'REWORK%')
                    group by Job) as subNetProdHours on WipMaster.Job = subNetProdHours.Job
    where ActCompleteDate is not null and ActCompleteDate between \'{SD}\' and \'{ED}\'
    group by year(ActCompleteDate)''',
        "output_filename": "Annual Productive Hours",
        "x_axis": "YearCompleted",
        "title": "Annual Productive Hours",
        "x_lbl": "Year",
        "y_lbl": "Hours",
        "formatter": HoursFormatter
}


QUERY__annual_cost_per_productive_hour = {
        "query": '''select year(ActCompleteDate) as YearCompleted,
    sum(ExpLabCurrent) / sum(case when NetProductiveTime is null then 0 else NetProductiveTime end) as [Cost Per Productive Hour]
    from SysproCompanyA.[dbo].WipMaster with (nolock)
    left outer join (select Job, sum(RunTime) as NetProductiveTime
                    from SysproCompanyA.[dbo].WipLabJnl with (nolock)
                    inner join SysproCompanyA.[dbo].BomMachine with (nolock) on WipLabJnl.Machine = BomMachine.Machine
                    where NonProdCode = ''
                    and (Description not like 'Rework%' or Description not like 'REWORK%')
                    group by Job) as subNetProdHours on WipMaster.Job = subNetProdHours.Job
    where ActCompleteDate is not null and ActCompleteDate between \'{SD}\' and \'{ED}\'
    group by year(ActCompleteDate)''',
        "output_filename": "Annual Cost Per Productive Hour",
        "x_axis": "YearCompleted",
        "title": "Annual Cost Per Productive Hour",
        "x_lbl": "Year",
        "y_lbl": "Cost / Hour",
        "formatter": MoneyFormatter
}


QUERY__monthly_labour_costs = {
        "query": '''select 
            DATENAME(MONTH, ActCompleteDate) + ' - ' + CAST(year(ActCompleteDate) AS NVARCHAR(4)) AS [Completed],
            sum(ExpLabCurrent) as [Current Labour Cost]
        from SysproCompanyA.[dbo].WipMaster with (nolock)
        left outer join (select Job, sum(RunTime) as NetProductiveTime
        from SysproCompanyA.[dbo].WipLabJnl with (nolock)
            inner join SysproCompanyA.[dbo].BomMachine with (nolock) on WipLabJnl.Machine = BomMachine.Machine
                where NonProdCode = ''
                    and (Description not like 'Rework%' or Description not like 'REWORK%')
                group by Job) as subNetProdHours on WipMaster.Job = subNetProdHours.Job
        where ActCompleteDate is not null AND [ActCompleteDate] BETWEEN \'{SD}\' AND \'{ED}\'
        group by DATENAME(MONTH, ActCompleteDate) + ' - ' + CAST(year(ActCompleteDate) AS NVARCHAR(4)), YEAR([ActCompleteDate]), MONTH([ActCompleteDate])
        ORDER BY YEAR(ActCompleteDate), MONTH(ActCompleteDate)''',
        "output_filename": "Monthly Labour Costs",
        "x_axis": "Completed",
        "title": "Monthly Labour Costs",
        "x_lbl": "Month",
        "y_lbl": "Cost",
        "formatter": MoneyFormatter
}


QUERY__monthly_productive_hours = {
        "query": '''select 
            DATENAME(MONTH, ActCompleteDate) + ' - ' + CAST(year(ActCompleteDate) AS NVARCHAR(4)) AS [Completed],
            sum(case when NetProductiveTime is null then 0 else NetProductiveTime end) as [Net Productive Hours]
        from SysproCompanyA.[dbo].WipMaster with (nolock)
        left outer join (select Job, sum(RunTime) as NetProductiveTime
        from SysproCompanyA.[dbo].WipLabJnl with (nolock)
            inner join SysproCompanyA.[dbo].BomMachine with (nolock) on WipLabJnl.Machine = BomMachine.Machine
                where NonProdCode = ''
                    and (Description not like 'Rework%' or Description not like 'REWORK%')
                group by Job) as subNetProdHours on WipMaster.Job = subNetProdHours.Job
        where ActCompleteDate is not null AND [ActCompleteDate] BETWEEN \'{SD}\' AND \'{ED}\'
        group by DATENAME(MONTH, ActCompleteDate) + ' - ' + CAST(year(ActCompleteDate) AS NVARCHAR(4)), YEAR([ActCompleteDate]), MONTH([ActCompleteDate])
        ORDER BY YEAR(ActCompleteDate), MONTH(ActCompleteDate)''',
        "output_filename": "Monthly Productive Hours",
        "x_axis": "Completed",
        "title": "Monthly Productive Hours",
        "x_lbl": "Month",
        "y_lbl": "Hours",
        "formatter": HoursFormatter
}


QUERY__monthly_cost_per_productive_hour = {
        "query": '''select 
            DATENAME(MONTH, ActCompleteDate) + ' - ' + CAST(year(ActCompleteDate) AS NVARCHAR(4)) AS [Completed],
            sum(ExpLabCurrent) / sum(case when NetProductiveTime is null then 0 else NetProductiveTime end) as [Cost Per Productive Hour]
        from SysproCompanyA.[dbo].WipMaster with (nolock)
        left outer join (select Job, sum(RunTime) as NetProductiveTime
        from SysproCompanyA.[dbo].WipLabJnl with (nolock)
            inner join SysproCompanyA.[dbo].BomMachine with (nolock) on WipLabJnl.Machine = BomMachine.Machine
                where NonProdCode = ''
                    and (Description not like 'Rework%' or Description not like 'REWORK%')
                group by Job) as subNetProdHours on WipMaster.Job = subNetProdHours.Job
        where ActCompleteDate is not null AND [ActCompleteDate] BETWEEN \'{SD}\' AND \'{ED}\'
        group by DATENAME(MONTH, ActCompleteDate) + ' - ' + CAST(year(ActCompleteDate) AS NVARCHAR(4)), YEAR([ActCompleteDate]), MONTH([ActCompleteDate])
        ORDER BY YEAR(ActCompleteDate), MONTH(ActCompleteDate)''',
        "output_filename": "Monthly Cost Per Productive Hour",
        "x_axis": "Completed",
        "title": "Monthly Cost Per Productive Hour",
        "x_lbl": "Month",
        "y_lbl": "Cost / Hour",
        "formatter": MoneyFormatter
}


QUERY__monthly_non_productive_hour_totals = {
        "query": '''SELECT
        DATENAME(MONTH, CAST(CAST(NonProdYear AS varchar(50))+'-'+RIGHT('00'+CAST(NonProdMonth AS varchar(50)), 2)+'-01' AS DATETIME)) + ' - ' + CAST(NonProdYear AS varchar(30)) AS [Date],
        CAST(ROUND(NonProdHours + 0E0, 0) AS INT) AS [NonProdHours]
    FROM (
        select year(EntryDate) as NonProdYear,
        month(EntryDate) as NonProdMonth,
        sum(RunTime) as NonProdHours,
        NetHours,
        case when NetHours = 0 then sum(RunTime) / 1 else sum(RunTime) / NetHours end as [NP Hour %]
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
        
        as SubProdHours	
        on year(EntryDate) = PostYear
                                                           and month(EntryDate) = PostMonth
        where BomEmployee.WorkCentre not in ('MI', 'WI', 'NP') AND [EntryDate] BETWEEN \'{SD}\' and \'{ED}\'
        group by year(EntryDate), month(EntryDate), NetHours
    ) AS [Src]
    order by NonProdYear, NonProdMonth''',
        "output_filename": "Monthly Non-Productive Hour Totals",
        "x_axis": "Date",
        "title": "Monthly Non-Productive Hour Totals",
        "x_lbl": "Month",
        "y_lbl": "Hours",
        "formatter": HoursFormatter
}


QUERY__monthly_net_productive_hour_totals = {
        "query": '''SELECT
        DATENAME(MONTH, CAST(CAST(NonProdYear AS varchar(50))+'-'+RIGHT('00'+CAST(NonProdMonth AS varchar(50)), 2)+'-01' AS DATETIME)) + ' - ' + CAST(NonProdYear AS varchar(30)) AS [Date],
        CAST(ROUND(NetHours + 0E0, 0) AS INT) AS [NetHours]
    FROM (
        select year(EntryDate) as NonProdYear,
        month(EntryDate) as NonProdMonth,
        sum(RunTime) as NonProdHours,
        NetHours,
        case when NetHours = 0 then sum(RunTime) / 1 else sum(RunTime) / NetHours end as [NP Hour %]
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

        as SubProdHours	
        on year(EntryDate) = PostYear
                                                           and month(EntryDate) = PostMonth
        where BomEmployee.WorkCentre not in ('MI', 'WI', 'NP') AND [EntryDate] BETWEEN \'{SD}\' and \'{ED}\'
        group by year(EntryDate), month(EntryDate), NetHours
    ) AS [Src]
    order by NonProdYear, NonProdMonth''',
        "output_filename": "Monthly Net-Productive Hour Totals",
        "x_axis": "Date",
        "title": "Monthly Net-Productive Hour Totals",
        "x_lbl": "Month",
        "y_lbl": "Hours",
        "formatter": HoursFormatter
}


QUERY__monthly_non_productive_hour_percentages = {
        "query": '''SELECT
        DATENAME(MONTH, CAST(CAST(NonProdYear AS varchar(50))+'-'+RIGHT('00'+CAST(NonProdMonth AS varchar(50)), 2)+'-01' AS DATETIME)) + ' - ' + CAST(NonProdYear AS varchar(30)) AS [Date],
        ROUND([NP Hour %] * 100, 2) AS [NP Hour %]
    FROM (
        select year(EntryDate) as NonProdYear,
        month(EntryDate) as NonProdMonth,
        sum(RunTime) as NonProdHours,
        NetHours,
        case when NetHours = 0 then sum(RunTime) / 1 else sum(RunTime) / NetHours end as [NP Hour %]
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

        as SubProdHours	
        on year(EntryDate) = PostYear
                                                           and month(EntryDate) = PostMonth
        where BomEmployee.WorkCentre not in ('MI', 'WI', 'NP') AND [EntryDate] BETWEEN \'{SD}\' and \'{ED}\'
        group by year(EntryDate), month(EntryDate), NetHours
    ) AS [Src]
    order by NonProdYear, NonProdMonth''',
        "output_filename": "Monthly Non-Productive Hour Percentages",
        "x_axis": "Date",
        "title": "Monthly Non-Productive Hour Percentages",
        "x_lbl": "Month",
        "y_lbl": "%",
        "formatter": PercentFormatter
}


QUERY__annual_non_productive_hour_totals = {
        "query": '''SELECT
            [NonProdYear] AS [Date],
            CAST(ROUND(NonProdHours + 0E0, 0) AS INT) AS [NonProdHours]
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
    where BomEmployee.WorkCentre not in ('MI', 'WI', 'NP') AND [EntryDate] BETWEEN \'{SD}\' and \'{ED}\'
    group by year(EntryDate)
    ) AS [Src]
        order by NonProdYear''',
        "output_filename": "Annual Non-Productive Hour Totals",
        "x_axis": "Date",
        "title": "Annual Non-Productive Hour Totals",
        "x_lbl": "Year",
        "y_lbl": "Hours",
        "formatter": HoursFormatter
}


QUERY__annual_net_productive_hour_totals = {
        "query": '''SELECT
            [NonProdYear] AS [Date],
            CAST(ROUND(NetHours + 0E0, 0) AS INT) AS [NetHours]
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
    where BomEmployee.WorkCentre not in ('MI', 'WI', 'NP') AND [EntryDate] BETWEEN \'{SD}\' and \'{ED}\'
    group by year(EntryDate)
    ) AS [Src]
        order by NonProdYear''',
        "output_filename": "Annual Net-Productive Hour Totals",
        "x_axis": "Date",
        "title": "Annual Net-Productive Hour Totals",
        "x_lbl": "Year",
        "y_lbl": "Hours",
        "formatter": HoursFormatter
}


QUERY__annual_non_productive_hour_percentages = {
        "query": '''SELECT
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
    where BomEmployee.WorkCentre not in ('MI', 'WI', 'NP') AND [EntryDate] BETWEEN \'{SD}\' and \'{ED}\'
    group by year(EntryDate)
    ) AS [Src]
        order by NonProdYear''',
        "output_filename": "Annual Non-Productive Hour Percentages",
        "x_axis": "Date",
        "title": "Annual Non-Productive Hour Percentages",
        "x_lbl": "Year",
        "y_lbl": "%",
        "formatter": PercentFormatter
}


QUERY__monthly_production_hours_budget = {
        "query": '''SELECT
        DATENAME(MONTH, CAST(CAST(YearCompleted AS varchar(50))+'-'+RIGHT('00'+CAST(MonthCompleted AS varchar(50)), 2)+'-01' AS DATETIME)) + ' - ' + CAST(YearCompleted AS varchar(30)) AS [Date],
        [Budget]
    FROM (
    select year(ActCompleteDate) as YearCompleted, month(ActCompleteDate) as MonthCompleted,
    sum(IExpUnitRunTim) as Budget, sum(RunTimeIssued) as Actual
    from WipMaster with (nolock)
    inner join WipJobAllLab with (nolock) on WipMaster.Job = WipJobAllLab.Job
    where ActCompleteDate is not null and [JobDeliveryDate] BETWEEN \'{SD}\' AND \'{ED}\'
    group by year(ActCompleteDate), month(ActCompleteDate)
    ) AS [Src]
    order by YearCompleted, MonthCompleted''',
        "output_filename": "Monthly Production Hours Budget",
        "x_axis": "Date",
        "title": "Monthly Production Hours Budget",
        "x_lbl": "Month",
        "y_lbl": "Budget",
        "formatter": HoursFormatter
}


QUERY__monthly_production_hours_actual = {
        "query": '''SELECT
        DATENAME(MONTH, CAST(CAST(YearCompleted AS varchar(50))+'-'+RIGHT('00'+CAST(MonthCompleted AS varchar(50)), 2)+'-01' AS DATETIME)) + ' - ' + CAST(YearCompleted AS varchar(30)) AS [Date],
        [Actual]
    FROM (
    select year(ActCompleteDate) as YearCompleted, month(ActCompleteDate) as MonthCompleted,
    sum(IExpUnitRunTim) as Budget, sum(RunTimeIssued) as Actual
    from WipMaster with (nolock)
    inner join WipJobAllLab with (nolock) on WipMaster.Job = WipJobAllLab.Job
    where ActCompleteDate is not null and [JobDeliveryDate] BETWEEN \'{SD}\' AND \'{ED}\'
    group by year(ActCompleteDate), month(ActCompleteDate)
    ) AS [Src]
    order by YearCompleted, MonthCompleted''',
        "output_filename": "Monthly Production Hours Actual",
        "x_axis": "Date",
        "title": "Monthly Production Hours Actual",
        "x_lbl": "Month",
        "y_lbl": "Actual",
        "formatter": HoursFormatter
}


QUERY__monthly_production_hours_budget_actual = {
        "query": '''SELECT
        DATENAME(MONTH, CAST(CAST(YearCompleted AS varchar(50))+'-'+RIGHT('00'+CAST(MonthCompleted AS varchar(50)), 2)+'-01' AS DATETIME)) + ' - ' + CAST(YearCompleted AS varchar(30)) AS [Date],
        [Budget],
        [Actual]
    FROM (
    select year(ActCompleteDate) as YearCompleted, month(ActCompleteDate) as MonthCompleted,
    sum(IExpUnitRunTim) as Budget, sum(RunTimeIssued) as Actual
    from WipMaster with (nolock)
    inner join WipJobAllLab with (nolock) on WipMaster.Job = WipJobAllLab.Job
    where ActCompleteDate is not null and [JobDeliveryDate] BETWEEN \'{SD}\' AND \'{ED}\'
    group by year(ActCompleteDate), month(ActCompleteDate)
    ) AS [Src]
    order by YearCompleted, MonthCompleted''',
        "output_filename": "Monthly Production Hours Budget VS. Actual",
        "x_axis": "Date",
        "title": "Monthly Production Hours Budget VS. Actual",
        "x_lbl": "Month",
        "y_lbl": "Hours",
        "formatter": HoursFormatter
}


QUERY__annual_production_hours_budget = {
        "query": '''SELECT
        YearCompleted AS [Date],
        [Budget]
    FROM (
    select year(ActCompleteDate) as YearCompleted,
    sum(IExpUnitRunTim) as Budget, sum(RunTimeIssued) as Actual
    from WipMaster with (nolock)
    inner join WipJobAllLab with (nolock) on WipMaster.Job = WipJobAllLab.Job
    where ActCompleteDate is not null and [JobDeliveryDate] BETWEEN \'{SD}\' AND \'{ED}\'
    group by year(ActCompleteDate)
    ) AS [Src]
    order by YearCompleted''',
        "output_filename": "Annual Production Hours Budget",
        "x_axis": "Date",
        "title": "Annual Production Hours Budget",
        "x_lbl": "Year",
        "y_lbl": "Budget",
        "formatter": HoursFormatter
}


QUERY__annual_production_hours_actual = {
        "query": '''SELECT
        YearCompleted AS [Date],
        [Actual]
    FROM (
    select year(ActCompleteDate) as YearCompleted,
    sum(IExpUnitRunTim) as Budget, sum(RunTimeIssued) as Actual
    from WipMaster with (nolock)
    inner join WipJobAllLab with (nolock) on WipMaster.Job = WipJobAllLab.Job
    where ActCompleteDate is not null and [JobDeliveryDate] BETWEEN \'{SD}\' AND \'{ED}\'
    group by year(ActCompleteDate)
    ) AS [Src]
    order by YearCompleted''',
        "output_filename": "Annual Production Hours Actual",
        "x_axis": "Date",
        "title": "Annual Production Hours Actual",
        "x_lbl": "Year",
        "y_lbl": "Actual",
        "formatter": HoursFormatter
}


QUERY__annual_production_hours_budget_actual = {
        "query": '''SELECT
        YearCompleted AS [Date],
        [Budget],
        [Actual]
    FROM (
    select year(ActCompleteDate) as YearCompleted,
    sum(IExpUnitRunTim) as Budget, sum(RunTimeIssued) as Actual
    from WipMaster with (nolock)
    inner join WipJobAllLab with (nolock) on WipMaster.Job = WipJobAllLab.Job
    where ActCompleteDate is not null and [JobDeliveryDate] BETWEEN \'{SD}\' AND \'{ED}\'
    group by year(ActCompleteDate)
    ) AS [Src]
    order by YearCompleted''',
        "output_filename": "Annual Production Hours Budget VS. Actual",
        "x_axis": "Date",
        "title": "Annual Production Hours Budget VS. Actual",
        "x_lbl": "Year",
        "y_lbl": "Hours",
        "formatter": HoursFormatter
}


QUERY__monthly_manufacturing_hours_variance = {
        "query": '''
    SET NOCOUNT ON;
    EXEC [dbo].[sp_MonthlyManufacturingVariance] @SD=\'{SD}\', @ED=\'{ED}\';''',
        "output_filename": "Monthly Manufacturing Hours Variance",
        "x_axis": "Date",
        "title": "Monthly Manufacturing Hours Variance",
        "x_lbl": "Month",
        "y_lbl": "Hours",
        "formatter": HoursFormatter
}


QUERY__annual_manufacturing_hours_variance = {
        "query": '''
    SET NOCOUNT ON;
    EXEC [dbo].[sp_MonthlyManufacturingVariance] @SD=\'{SD}\', @ED=\'{ED}\';''',
        "output_filename": "Monthly Manufacturing Hours Variance",
        "x_axis": "Date",
        "title": "Monthly Manufacturing Hours Variance",
        "x_lbl": "Year",
        "y_lbl": "Hours",
        "formatter": HoursFormatter
}


QUERY__annual_consumables_budget_budget = {
        "query": '''
    SET NOCOUNT ON;
    EXEC [dbo].[sp_AnnualConsumablesBudget] @SD=\'{SD}\', @ED=\'{ED}\', @COL=\'B\';''',
        "output_filename": "Annual Consumables Budget - Budget",
        "x_axis": "YearConsume",
        "title": "Annual Consumables Budget - Budget",
        "x_lbl": "Year",
        "y_lbl": "Budget",
        "formatter": MoneyFormatter
}


QUERY__annual_consumables_budget_consumables = {
        "query": '''
    SET NOCOUNT ON;
    EXEC [dbo].[sp_AnnualConsumablesBudget] @SD=\'{SD}\', @ED=\'{ED}\', @COL=\'C\';''',
        "output_filename": "Annual Consumables Budget - Consumables",
        "x_axis": "YearConsume",
        "title": "Annual Consumables Budget - Consumables",
        "x_lbl": "Year",
        "y_lbl": "Consumables",
        "formatter": MoneyFormatter
}


QUERY__annual_consumables_budget_budget_consumables = {
        "query": '''
    SET NOCOUNT ON;
    EXEC [dbo].[sp_AnnualConsumablesBudget] @SD=\'{SD}\', @ED=\'{ED}\', @COL=\'A\';''',
        "output_filename": "Annual Consumables VS Budget",
        "x_axis": "YearConsume",
        "title": "Annual Consumables VS Budget",
        "x_lbl": "Year",
        "y_lbl": "$",
        "formatter": MoneyFormatter
}


QUERY__monthly_consumables_budget_budget = {
        "query": '''
    SET NOCOUNT ON;
    EXEC [dbo].[sp_MonthlyConsumablesBudget] @SD=\'{SD}\', @ED=\'{ED}\', @COL=\'B\';''',
        "output_filename": "Monthly Consumables Budget - Budget",
        "x_axis": "Date",
        "title": "Monthly Consumables Budget - Budget",
        "x_lbl": "Month",
        "y_lbl": "Budget",
        "formatter": MoneyFormatter
}


QUERY__monthly_consumables_budget_consumables = {
        "query": '''
    SET NOCOUNT ON;
    EXEC [dbo].[sp_MonthlyConsumablesBudget] @SD=\'{SD}\', @ED=\'{ED}\', @COL=\'C\';''',
        "output_filename": "Monthly Consumables Budget - Consumables",
        "x_axis": "Date",
        "title": "Monthly Consumables Budget - Consumables",
        "x_lbl": "Month",
        "y_lbl": "Consumables",
        "formatter": MoneyFormatter
}


QUERY__monthly_consumables_consumables_budget = {
        "query": '''
    SET NOCOUNT ON;
    EXEC [dbo].[sp_MonthlyConsumablesBudget] @SD=\'{SD}\', @ED=\'{ED}\', @COL=\'A\';''',
        "output_filename": "Monthly Consumables VS Budget",
        "x_axis": "Date",
        "title": "Monthly Consumables VS Budget",
        "x_lbl": "Month",
        "y_lbl": "$",
        "formatter": MoneyFormatter
}


QUERY__annual_labour_budget_budget = {
        "query": '''
    select year(ActCompleteDate) as YearCompleted,
    sum(UnitValueReqd) as Budget
    from WipMaster with (nolock)
    inner join WipJobAllLab with (nolock) on WipMaster.Job = WipJobAllLab.Job
    where ActCompleteDate is not null and ActCompleteDate BETWEEN \'{SD}\' AND \'{ED}\'
    group by year(ActCompleteDate)
    order by year(ActCompleteDate)''',
        "output_filename": "Annual Labour Budget - Budget",
        "x_axis": "YearCompleted",
        "title": "Annual Labour Budget - Budget",
        "x_lbl": "Year",
        "y_lbl": "Budget",
        "formatter": HoursFormatter
}


QUERY__annual_labour_budget_labour = {
        "query": '''
    select year(ActCompleteDate) as YearCompleted,
    sum(ValueIssued) as Labour
    from WipMaster with (nolock)
    inner join WipJobAllLab with (nolock) on WipMaster.Job = WipJobAllLab.Job
    where ActCompleteDate is not null and ActCompleteDate BETWEEN \'{SD}\' AND \'{ED}\'
    group by year(ActCompleteDate)
    order by year(ActCompleteDate)''',
        "output_filename": "Annual Labour Budget - Labour",
        "x_axis": "YearCompleted",
        "title": "Annual Labour Budget - Labour",
        "x_lbl": "Year",
        "y_lbl": "Labour",
        "formatter": HoursFormatter
}


QUERY__annual_labour_labour_budget = {
        "query": '''
    SET NOCOUNT ON;
    EXEC [dbo].[sp_MonthlyLabourBudget] @SD=\'{SD}\', @ED=\'{ED}\', @COL=\'A\'''',
        "output_filename": "Monthly Labour VS. Budget",
        "x_axis": "Date",
        "title": "Monthly Labour VS. Budget",
        "x_lbl": "Year",
        "y_lbl": "Hours",
        "formatter": HoursFormatter
}


QUERY__annual_material_budget_budget = {
        "query": '''
    select year(ActCompleteDate) AS [Date],
    sum(UnitQtyReqd * UnitCost) as Budget
    from WipMaster with (nolock)
    inner join WipJobAllMat with (nolock) on WipMaster.Job = WipJobAllMat.Job
    where ActCompleteDate is not null and ActCompleteDate BETWEEN \'{SD}\' AND \'{ED}\'
    group by year(ActCompleteDate)
    order by year(ActCompleteDate)''',
        "output_filename": "Annual Material Budget - Budget",
        "x_axis": "Date",
        "title": "Annual Material Budget - Budget",
        "x_lbl": "Year",
        "y_lbl": "Budget",
        "formatter": MoneyFormatter
}


QUERY__annual_material_budget_material = {
        "query": '''
    select year(ActCompleteDate) AS [Date],
    sum(ValueIssued) as Material
    from WipMaster with (nolock)
    inner join WipJobAllMat with (nolock) on WipMaster.Job = WipJobAllMat.Job
    where ActCompleteDate is not null and ActCompleteDate BETWEEN \'{SD}\' AND \'{ED}\'
    group by year(ActCompleteDate)
    order by year(ActCompleteDate)''',
        "output_filename": "Annual Material Budget - Material",
        "x_axis": "Date",
        "title": "Annual Material Budget - Material",
        "x_lbl": "Year",
        "y_lbl": "Material",
        "formatter": MoneyFormatter
}


QUERY__annual_material_material_budget = {
        "query": '''
    select year(ActCompleteDate) AS [Date],
    sum(ValueIssued) as Material,
    sum(UnitQtyReqd * UnitCost) as Budget
    from WipMaster with (nolock)
    inner join WipJobAllMat with (nolock) on WipMaster.Job = WipJobAllMat.Job
    where ActCompleteDate is not null and ActCompleteDate BETWEEN \'{SD}\' AND \'{ED}\'
    group by year(ActCompleteDate)
    order by year(ActCompleteDate)''',
        "output_filename": "Annual Material VS Budget",
        "x_axis": "Date",
        "title": "Annual Material VS Budget",
        "x_lbl": "Year",
        "y_lbl": "Hours",
        "formatter": MoneyFormatter
}


QUERY__monthly_material_budget_budget = {
        "query": '''
    SET NOCOUNT ON;
    EXEC [dbo].[sp_MonthlyMaterialBudget] @SD=\'{SD}\', @ED=\'{ED}\', @COL=\'B\'''',
        "output_filename": "Monthly Material Budget - Budget",
        "x_axis": "Date",
        "title": "Monthly Material Budget - Budget",
        "x_lbl": "Month",
        "y_lbl": "Budget",
        "formatter": MoneyFormatter
}


QUERY__monthly_material_budget_material = {
        "query": '''
    SET NOCOUNT ON;
    EXEC [dbo].[sp_MonthlyMaterialBudget] @SD=\'{SD}\', @ED=\'{ED}\', @COL=\'M\'''',
        "output_filename": "Monthly Material Budget - Material",
        "x_axis": "Date",
        "title": "Monthly Material Budget - Material",
        "x_lbl": "Month",
        "y_lbl": "Material",
        "formatter": MoneyFormatter
}


QUERY__monthly_material_material_budget = {
        "query": '''
    SET NOCOUNT ON;
    EXEC [dbo].[sp_MonthlyMaterialBudget] @SD=\'{SD}\', @ED=\'{ED}\', @COL=\'A\'''',
        "output_filename": "Monthly Material VS. Budget",
        "x_axis": "Date",
        "title": "Monthly Material VS. Budget",
        "x_lbl": "Month",
        "y_lbl": "Hours",
        "formatter": MoneyFormatter
}


QUERY__annual_overtime = {
        "query": '''
    select year(OTDate) as [Date],
    sum(Overtime) as Overtime
    from BWSdb.dbo.dtOvertimeYTD with (nolock)
    where [OTDate] BETWEEN \'{SD}\' AND \'{ED}\'
    group by year(OTDate)
    order by year(OTDate)''',
        "output_filename": "Annual Overtime",
        "x_axis": "Date",
        "title": "Annual Overtime",
        "x_lbl": "Year",
        "y_lbl": "Hours",
        "formatter": HoursFormatter
}


QUERY__monthly_overtime = {
        "query": '''
    select 
    DATENAME(MONTH, CAST(CAST(year(OTDate) AS varchar(50))+'-'+RIGHT('00'+CAST(month(OTDate) AS varchar(50)), 2)+'-01' AS DATETIME)) + ' - ' + CAST(year(OTDate) AS varchar(30)) AS [Date],
    sum(Overtime) as Overtime
    from BWSdb.dbo.dtOvertimeYTD with (nolock)
    where [OTDate] BETWEEN \'{SD}\' AND \'{ED}\'
    group by year(OTDate), month(OTDate)
    order by year(OTDate), month(OTDate)''',
        "output_filename": "Monthly Overtime",
        "x_axis": "Date",
        "title": "Monthly Overtime",
        "x_lbl": "Month",
        "y_lbl": "Hours",
        "formatter": HoursFormatter
}


QUERY__annual_rework = {
        "query": '''
    select year(ActCompleteDate) as [Date],
    sum(RunTime) as NetReworkTime
    from WipLabJnl with (nolock)
    inner join BomMachine with (nolock) on WipLabJnl.Machine = BomMachine.Machine
    inner join WipMaster with (nolock) on WipLabJnl.Job = WipMaster.Job
    where (Description like 'Rework%' or Description like 'REWORK%')
    and ActCompleteDate is not null and ActCompleteDate between \'{SD}\' and \'{ED}\'
    group by year(ActCompleteDate)
    order by year(ActCompleteDate)''',
        "output_filename": "Annual Rework",
        "x_axis": "Date",
        "title": "Annual Rework",
        "x_lbl": "Year",
        "y_lbl": "Hours",
        "formatter": HoursFormatter
}


QUERY__monthly_rework = {
        "query": '''
    select DATENAME(MONTH, CAST(CAST(year(ActCompleteDate) AS varchar(50))+'-'+RIGHT('00'+CAST(month(ActCompleteDate) AS varchar(50)), 2)+'-01' AS DATETIME)) + ' - ' + CAST(year(ActCompleteDate) AS varchar(30)) AS [Date],
    sum(RunTime) as NetReworkTime
    from WipLabJnl with (nolock)
    inner join BomMachine with (nolock) on WipLabJnl.Machine = BomMachine.Machine
    inner join WipMaster with (nolock) on WipLabJnl.Job = WipMaster.Job
    where (Description like 'Rework%' or Description like 'REWORK%')
    and ActCompleteDate is not null and ActCompleteDate between \'{SD}\' and \'{ED}\'
    group by year(ActCompleteDate), month(ActCompleteDate)
    order by year(ActCompleteDate), month(ActCompleteDate)''',
        "output_filename": "Monthly Rework",
        "x_axis": "Date",
        "title": "Monthly Rework",
        "x_lbl": "Month",
        "y_lbl": "Hours",
        "formatter": HoursFormatter
}


QUERY__annual_attendance = {
        "query": '''
    select year(DateWorked) as [Date],
    sum(case [Absent] when 0 then 0 when 1 then 1 end) as Attendance
    from BWSdb.dbo.[Hours Worked] with (nolock)
    where DateWorked between \'{SD}\' and \'{ED}\'
    group by year(DateWorked)
    order by year(DateWorked)''',
        "output_filename": "Annual Attendance",
        "x_axis": "Date",
        "title": "Annual Attendance",
        "x_lbl": "Year",
        "y_lbl": "Count",
        "formatter": IntFormatter
}


QUERY__monthly_attendance = {
        "query": '''
    select DATENAME(MONTH, CAST(CAST(year(DateWorked) AS varchar(50))+'-'+RIGHT('00'+CAST(month(DateWorked) AS varchar(50)), 2)+'-01' AS DATETIME)) + ' - ' + CAST(year(DateWorked) AS varchar(30)) AS [Date],
    sum(case [Absent] when 0 then 0 when 1 then 1 end) as Attendance
    from BWSdb.dbo.[Hours Worked] with (nolock)
    where DateWorked between \'{SD}\' and \'{ED}\'
    group by year(DateWorked), month(DateWorked)
    order by year(DateWorked), month(DateWorked)''',
        "output_filename": "Monthly Attendance",
        "x_axis": "Date",
        "title": "Monthly Attendance",
        "x_lbl": "Month",
        "y_lbl": "Count",
        "formatter": IntFormatter
}


QUERY__annual_past_due_wos = {
        "query": '''
    select year(JobDeliveryDate) as [Date],
    count(WipMaster.Job) as NoPastDueWOs
    from WipMaster with (nolock)
    cross join MrpReqCtl with (nolock)
    where JobDeliveryDate < MrpReqCtl.SupplyDemandDate
    and ActCompleteDate is null and JobDeliveryDate between \'{SD}\' and \'{ED}\'
    group by year(JobDeliveryDate)
    order by year(JobDeliveryDate)''',
        "output_filename": "Annual Past Due WOs",
        "x_axis": "Date",
        "title": "Annual Past Due WOs",
        "x_lbl": "Year",
        "y_lbl": "Count",
        "formatter": IntFormatter
}


QUERY__monthly_past_due_wos = {
        "query": '''
    select DATENAME(MONTH, CAST(CAST(year(JobDeliveryDate) AS varchar(50))+'-'+RIGHT('00'+CAST(month(JobDeliveryDate) AS varchar(50)), 2)+'-01' AS DATETIME)) + ' - ' + CAST(year(JobDeliveryDate) AS varchar(30)) AS [Date],
    count(WipMaster.Job) as NoPastDueWOs
    from WipMaster with (nolock)
    cross join MrpReqCtl with (nolock)
    where JobDeliveryDate < MrpReqCtl.SupplyDemandDate
    and ActCompleteDate is null and JobDeliveryDate between \'{SD}\' and \'{ED}\'
    group by year(JobDeliveryDate), month(JobDeliveryDate)
    order by year(JobDeliveryDate), month(JobDeliveryDate)''',
        "output_filename": "Monthly Past Due WOs",
        "x_axis": "Date",
        "title": "Monthly Past Due WOs",
        "x_lbl": "Month",
        "y_lbl": "Count",
        "formatter": IntFormatter
}


QUERY__annual_inventory = {
        "query": '''
    SET NOCOUNT ON;
    EXEC [dbo].[sp_AnnualInventoryValue] @SD=\'{SD}\', @ED=\'{ED}\';''',
        "output_filename": "Annual Inventory",
        "x_axis": "Date",
        "title": "Annual Inventory",
        "x_lbl": "Year",
        "y_lbl": "Count",
        "formatter": IntFormatter
}


QUERY__monthly_inventory = {
        "query": '''
    SET NOCOUNT ON;
    EXEC [dbo].[sp_MonthlyInventoryValue] @SD=\'{SD}\', @ED=\'{ED}\';''',
        "output_filename": "Monthly Inventory",
        "x_axis": "Date",
        "title": "Monthly Inventory",
        "x_lbl": "Month",
        "y_lbl": "Count",
        "formatter": IntFormatter
}
