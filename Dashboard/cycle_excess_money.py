import os
import pyodbc
import pandas as pd
from formatters import *
import matplotlib.pyplot as plt
from matplotlib import font_manager as font_manager


title = 'Excess Money'


def create(start_date='1900-01-01', end_date='2100-01-01', path=None):
    print("Creating graph \"{}\"...".format(title))
    cnxn = pyodbc.connect('DRIVER={SQL Server};SERVER=server3;DATABASE=SysproCompanyA;UID=SRS;PWD=')

    assert end_date > start_date, "Supplied Start Date \"{}\" is after supplied End Date \"{}\"".format(start_date, end_date)

    costs_per_year = """
    select CycleCount, sum([Excess Value]) as [Excess$]
    from v_ExcessInventoryPrint
    group by CycleCount
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
        table_result = pd.read_sql(costs_per_year, cnxn)
        df = pd.DataFrame(table_result)
        ax = df.plot(kind='bar', x="CycleCount", figsize=(11, 14))
        ax.set_title(title, fontdict={'family':'Courier New',
                                              'style':'normal', 'size':19})
        ax.yaxis.set_major_formatter(MoneyFormatter("{:,}"))
        plt.minorticks_on()
        plt.grid(which='major', linestyle='-', linewidth='0.5', color='green')
        plt.grid(which='minor', linestyle=':', linewidth='0.5', color='black')
        ax.set_xlabel("Cycle")

        path = path + '{}.png'.format(title)

        plt.savefig(path, transparent=True)

        # plt.savefig(path, bbox_inches='tight', transparent="True", pad_inches=0)

        # plt.tight_layout()
        # plt.savefig(path)

        plt.clf()
    except TypeError:
        path = os.getcwd().replace("\\", "/") + "/" + path + 'EMPTY - {}.jpg'.format(title)
        print("\tNo data returned. -> {}".format(path))

        original = NO_DATA_FILE
        target = path
        shutil.copyfile(original, target)

    return path
