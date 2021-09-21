import os
import random
import pyodbc
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
from matplotlib.ticker import FormatStrFormatter
from matplotlib import font_manager as font_manager
import numpy as np

from utility import *
from colour_utility import *

title = 'Monthly Cost Per Productive Hour'


class MoneyFormatter(FormatStrFormatter):
    def __init__(self, fmt):
        super().__init__(fmt)

    def __call__(self, x, pos=None):
        """
        Return the formatted label string.

        Only the value *x* is formatted. The position is ignored.
        """
        return money(x)


def create(start_date='1900-01-01', end_date='2021-08-09', path=None):
    cnxn = pyodbc.connect('DRIVER={SQL Server};SERVER=server3;DATABASE=BWSdb;UID=user5;PWD=M@gic456')
    cursor = cnxn.cursor()

    assert end_date > start_date
    start_date = start_date
    # start_date = '2021-04-01'
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

    plt.savefig(path + '{}.png'.format(title))
