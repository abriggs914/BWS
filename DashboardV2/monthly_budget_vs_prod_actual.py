import os
import pyodbc
import pandas as pd
from formatters import *
import matplotlib.pyplot as plt

title = 'Monthly Production Hours Actual'


def create(start_date='1900-01-01', end_date='2100-01-01', path=None):
    print("Creating graph \"{}\"...".format(title))
    cnxn = pyodbc.connect('DRIVER={SQL Server};SERVER=server3;DATABASE=SysproCompanyA;UID=SRS;PWD=')

    assert end_date > start_date, "Supplied Start Date \"{}\" is after supplied End Date \"{}\"".format(start_date, end_date)

    net_prod_totals = """
    SELECT
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
    order by YearCompleted, MonthCompleted
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
        ax.yaxis.set_major_formatter(HoursFormatter("{:,}"))
        plt.minorticks_on()
        plt.grid(which='major', linestyle='-', linewidth='0.5', color='green')
        plt.grid(which='minor', linestyle=':', linewidth='0.5', color='black')
        ax.set_xlabel("Year")

        path = path + '{}.png'.format(title)
        plt.savefig(path)
        plt.clf()
    except TypeError:
        path = os.getcwd().replace("\\", "/") + "/" + path + 'EMPTY - {}.jpg'.format(title)
        print("\tNo data returned. -> {}".format(path))

        original = NO_DATA_FILE
        target = path
        shutil.copyfile(original, target)

    return path
