import os
import pyodbc
import pandas as pd
from formatters import *
import matplotlib.pyplot as plt


title = 'Annual Non-Productive Hour Totals'


def create(start_date='1900-01-01', end_date='2100-01-01', path=None):
    print("Creating graph \"{}\"...".format(title))
    cnxn = pyodbc.connect('DRIVER={SQL Server};SERVER=server3;DATABASE=SysproCompanyA;UID=SRS;PWD=')
    cursor = cnxn.cursor()

    assert end_date > start_date
    start_date = start_date
    # start_date = '2021-04-01'
    end_date = end_date

    net_prod_totals = """     

    SELECT
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
        order by NonProdYear
    """.format(SD=start_date, ED=end_date)

    # plt.show()
    if path is not None:
        try:
            if not path[-1] == '/':
                path = path + '/'
            if not os.path.isdir(path):
                os.makedirs(path)
        except NotADirectoryError:
            print("Directory: \"{}\" not found.\nDefaulting to current directory.".format(path))
            path = ''
        except FileNotFoundError:
            print("Directory: \"{}\" not found.\nDefaulting to current directory.".format(path))
            path = ''
    else:
        path = ''

    try:
        table_result = pd.read_sql(net_prod_totals, cnxn)

        # Or create a Excel file with the results
        df = pd.DataFrame(table_result)
        ax = df.plot(kind='bar', x="Date", figsize=(20, 14))
        ax.set_title(title)
        ax.yaxis.set_major_formatter(MoneyFormatter("{:,}"))
        plt.minorticks_on()
        plt.grid(which='major', linestyle='-', linewidth='0.5', color='green')
        plt.grid(which='minor', linestyle=':', linewidth='0.5', color='black')
        ax.set_xlabel("Year")

        path = path + '{}.png'.format(title)
        plt.savefig(path)
    except TypeError:
        path = os.getcwd().replace("\\", "/") + "/" + path + 'EMPTY - {}.jpg'.format(title)
        print("\tNo data returned. -> {}".format(path))

        original = NO_DATA_FILE
        target = path
        shutil.copyfile(original, target)

    return path
