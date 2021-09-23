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

title = 'Monthly Production Budget'


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
    print("Creating graph \"{}\"...".format(title))
    cnxn = pyodbc.connect('DRIVER={SQL Server};SERVER=server3;DATABASE=SysproCompanyA;UID=SRS;PWD=')
    cursor = cnxn.cursor()

    assert end_date > start_date
    start_date = start_date
    # start_date = '2021-04-01'
    end_date = end_date

    net_prod_totals = """
    SELECT
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
    order by YearCompleted, MonthCompleted
    """.format(SD=start_date, ED=end_date)

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
