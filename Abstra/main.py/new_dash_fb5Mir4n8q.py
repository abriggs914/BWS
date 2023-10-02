import abstra.dashes as ad
import pandas
from abstra.common import get_user
from abstra.forms import display_pandas
from abstra.tables import run
from pyodbc_connection import connect

"""
Abstra dashes are the simplest way to build custom user interfaces for your APIs.
"""

# dataframe = connect("SELECT * FOM [ITRequests]")
# dataframe = run("SELECT * FOM [ITRequests]")
# data_ = pandas.DataFrame({"A": [0, 1], "B": [2, 3], "C": [4, 5]})
# display_pandas(dataframe, label="All Users")

# data_file = r"D:\ITRequests 2023-10-02.xlsx"
# df = pd.read_excel(data_file)

user = get_user()

x = 2
y = 3


def get_sum():
    return x + y


def show_sum():
    ad.alert(str(get_sum()))
