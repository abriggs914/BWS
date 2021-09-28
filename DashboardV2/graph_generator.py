import os
import pyodbc
import pandas as pd
from formatters import *
import matplotlib.pyplot as plt


def create_graph(query, output_filename, x_axis, title='', start_date='1900-01-01', end_date='2100-01-01', col=None,
                 path=None, draw_title=False, x_lbl=None, y_lbl=None, formatter=IntFormatter):
    print("Creating graph \"{}\"...".format(title))
    cnxn = pyodbc.connect('DRIVER={SQL Server};SERVER=server3;DATABASE=SysproCompanyA;UID=SRS;PWD=')

    assert end_date > start_date, "Supplied Start Date \"{}\" is after supplied End Date \"{}\"".format(start_date,
                                                                                                        end_date)
    assert output_filename is not None, "Output file needs a name."
    assert output_filename != "", "Output file needs a name."

    # print("A parsed_query:", query)
    if col is not None:
        # print("col is not none")
        query.format(SD=start_date, ED=end_date, COL=col)
        query = query.replace("{SD}", start_date)
        query = query.replace("{ED}", end_date)
        query = query.replace("{COL}", col)
    else:
        # print("col is none")
        query = query.replace("{SD}", start_date)
        query = query.replace("{ED}", end_date)

    # print("B parsed_query:", query)
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
        table_result = pd.read_sql(query, cnxn)
        df = pd.DataFrame(table_result)
        ax = df.plot(kind='bar', x=x_axis, figsize=(11, 14))
        if draw_title:
            ax.set_title(title, fontdict={'family': 'Courier New',
                                          'style': 'normal', 'size': 19})
        ax.yaxis.set_major_formatter(formatter("{:,}"))
        plt.minorticks_on()
        plt.grid(which='major', linestyle='-', linewidth='0.5', color='green')
        plt.grid(which='minor', linestyle=':', linewidth='0.5', color='black')
        if x_lbl is not None:
            ax.set_xlabel(x_lbl)
        if y_lbl is not None:
            ax.set_ylabel(y_lbl)

        path = path + '{}.png'.format(output_filename)

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

    cnxn.close()
    return path
