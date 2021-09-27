from formatters import *


QUERY__annual_labour_costs = {
        "query": """
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
            ;""",
        "output_filename": "Annual Labour Costs",
        "x_axis": "YearCompleted",
        "title": "Annual Labour Costs",
        "x_lbl": "Year Completed",
        "y_lbl": "Cost",
        "formatter": MoneyFormatter
}
