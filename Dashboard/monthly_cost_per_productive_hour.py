import os
import pyodbc
import pandas as pd
from formatters import *
import matplotlib.pyplot as plt


title = 'Monthly Cost Per Productive Hour'


def create(start_date='1900-01-01', end_date='2100-01-01', path=None):
    print("Creating graph \"{}\"...".format(title))
    cnxn = pyodbc.connect('DRIVER={SQL Server};SERVER=server3;DATABASE=BWSdb;UID=user5;PWD=M@gic456')

    assert end_date > start_date
    start_date = start_date
    end_date = end_date

    costs_per_year = """
        select 
            DATENAME(MONTH, ActCompleteDate) + ' - ' + CAST(year(ActCompleteDate) AS NVARCHAR(4)) AS [Completed],
            sum(ExpLabCurrent) / sum(case when NetProductiveTime is null then 0 else NetProductiveTime end) as [Cost Per Productive Hour]
        from SysproCompanyA.[dbo].WipMaster with (nolock)
        left outer join (select Job, sum(RunTime) as NetProductiveTime
        from SysproCompanyA.[dbo].WipLabJnl with (nolock)
            inner join SysproCompanyA.[dbo].BomMachine with (nolock) on WipLabJnl.Machine = BomMachine.Machine
                where NonProdCode = ''
                    and (Description not like 'Rework%' or Description not like 'REWORK%')
                group by Job) as subNetProdHours on WipMaster.Job = subNetProdHours.Job
        where ActCompleteDate is not null AND [ActCompleteDate] BETWEEN \'{start_date}\' AND \'{end_date}\'
        group by DATENAME(MONTH, ActCompleteDate) + ' - ' + CAST(year(ActCompleteDate) AS NVARCHAR(4)), YEAR([ActCompleteDate]), MONTH([ActCompleteDate])
        ORDER BY YEAR(ActCompleteDate), MONTH(ActCompleteDate)
    ;
    """.format(start_date=start_date, end_date=end_date)

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
        table_result = pd.read_sql(costs_per_year, cnxn)

        # Or create a Excel file with the results
        df = pd.DataFrame(table_result)
        ax = df.plot(kind='bar', x="Completed", figsize=(20, 14))
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