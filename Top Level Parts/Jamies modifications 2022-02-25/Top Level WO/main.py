import pyodbc
import tkinter
import asyncio
import datetime
import pandas as pd
from utility import *
from colour_utility import *
from PIL import Image, ImageTk
from tkinter import ttk


async def read_sql_async(stmt, con):
    '''
    Helper function to wrap pd.read_sql in an asynchronous call.
    :param stmt: SQL statement to be passed
    :param con: connection string
    :return: The query results in a Pandas Dataframe
    '''
    loop = asyncio.get_event_loop()
    return await loop.run_in_executor(None, pd.read_sql, stmt, con)


async def query_db(start_date, end_date, first=True):
    '''
    Function is called to query BWSdb for production schedule data.
    Called asynchronously while the splash menu is shown.
    :param start_date: beginning of date range
    :param end_date: ending of date range
    :param first: Allows for 1 single re-try due to an unknown / unpredicted errors. If function fails twice, program exits.
    :return:
        lines: list of lines on this schedule (y-axis)
        dates: list of dates over this schedule (x-axis)
        ordered_df: A Pandas dataframe sorted by Line and Date. Each cell of the table represents a Line on the given Date.
    '''
    assert isinstance(start_date, datetime.datetime), "Start date param: \"{}\" must be a datetime.datetime object.".format(start_date)
    assert isinstance(end_date, datetime.datetime), "End date param: \"{}\" must be a datetime.datetime object.".format(end_date)
    assert start_date <= end_date, "Start date param: \"{}\" must be before End date param \"{}\".".format(start_date, end_date)
    # lines = [
    #     "GNK1",
    #     "GNK2",
    #     "TBF",
    #     "PBF",
    #     "B1",
    #     "B2",
    #     "B3",
    #     "B4",
    #     "TS1",
    #     "TS2",
    #     "TS3",
    #     "T1",
    #     "T2",
    #     "T3",
    #     "T4",
    #     "T5",
    #     "T6",
    #     "T7",
    #     "T8",
    #     "T9",
    #     "T10",
    #     "T11"
    # ]
    # dates = []
    ordered_df = pd.DataFrame()
    try:

        query = "EXEC [sp_ProductionSchedule V4_Slots] \'{sd}\', \'{ed}\';".format(sd=start_date, ed=end_date)
        cnxn = pyodbc.connect('DRIVER={SQL Server};SERVER=server3;DATABASE=BWSdb;UID=user5;PWD=M@gic456', timeout=10)
        table_result = await read_sql_async(query, cnxn)


        # splash_query_pb["value"] = 46
        # splash_query_pb.update()
        # splash_query_pb["value"] = 56
        # splash_query_pb.update()
        # splash_query_pb["value"] = 77
        # splash_query_pb.update()
        # df1 = pd.DataFrame(table_result)
        # df2 = pd.DataFrame(table_result)
        # df3 = pd.DataFrame(table_result)
        # pd.to_datetime(df1['Prod Date'], unit='s')
        # pd.to_datetime(df2['Prod Date'], unit='s')
        # pd.to_datetime(df3['Prod Date'], unit='s')
        # ordered_df = df2.sort_values(by="GroupID")
        # lines = ordered_df.drop_duplicates('GroupID')
        # # lines = lines.iloc[:, :1].tolist()
        # lines = lines['Prod Line'].tolist()
        # ordered_df = df3.sort_values(by="Prod Date")
        # dates = ordered_df.drop_duplicates('Prod Date')
        # # dates = dates.iloc[:, 3:4].tolist()
        # dates = dates['Prod Date'].tolist()
        # print("columns:", df1.columns)
        #
        # # TODO can use this as a testing entry
        # # print("df1:", df1)
        # # print(str(df1.to_json()))
        # # df1 = pd.read_json(df1.to_json())
        #
        # ordered_df = df1.sort_values(by=["GroupID", "Prod Date"])
        cnxn.close()
    except pd.io.sql.DatabaseError:
        # # try again ONCE:
        # if first:
        #     print("Trying again...")
        #     lines, dates, ordered_df = await get_production_data(start_date, end_date, first=False)
        # else:
        print("Deadlock error. Please try again later.")
    except pyodbc.OperationalError:
        print("[08001] [Microsoft][ODBC SQL Server Driver][DBNETLIB]SQL Server does not exist or access denied.")
        print("Using default values")

    return "Complete"
    # return df


def exit_program():
    '''
    Function called to quit the application.
    :return: None
    '''
    print("Goodbye!")
    exit()


def clicked_refresh_button():
    print("refresh")
    print(f"StartDate: {SV_START_DATE.get()}")
    print(f"EndDate: {SV_END_DATE.get()}")


WIDTH, HEIGHT = 1500, 1000
WINDOW = tkinter.Tk()
WINDOW.geometry(f"{WIDTH}x{HEIGHT}")
IMAGE_REFRESH = tkinter.PhotoImage(file="Refresh (2).png")
IMAGE_REFRESH.subsample(30, 30)

SV_START_DATE = tkinter.StringVar()
SV_END_DATE = tkinter.StringVar()

# Production Date
# top level WO
# Warehouse
# Operation
# Part Category
#

# Create widgets
button_refresh = ttk.Button(
    WINDOW,
    command=clicked_refresh_button,
    # image=ImageTk.PhotoImage(Image.open("Refresh.png").resize((50, 50))),
    image=IMAGE_REFRESH
)

entry_start_date = tkinter.Entry(
    WINDOW,
    textvariable=SV_START_DATE
)

entry_end_date = tkinter.Entry(
    WINDOW,
    textvariable=SV_END_DATE
)

# Pack widgets
button_refresh.pack(
    ipadx=5,
    ipady=5,
    expand=True
)

# Pack widgets
entry_start_date.pack(
    ipadx=5,
    ipady=5,
    expand=True
)

# Pack widgets
entry_end_date.pack(
    ipadx=5,
    ipady=5,
    expand=True
)


WINDOW.mainloop()
print("Goodbye!")
exit()
