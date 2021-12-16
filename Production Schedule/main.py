
import tkinter
import pyodbc
from pscalendar import *
import pandas as pd


def get_production_data(start_date, end_date):
    assert isinstance(start_date, datetime.datetime), "Start date param: \"{}\" must be a datetime.datetime object.".format(start_date)
    assert isinstance(end_date, datetime.datetime), "End date param: \"{}\" must be a datetime.datetime object.".format(end_date)
    assert start_date <= end_date, "Start date param: \"{}\" must be before End date param \"{}\".".format(start_date, end_date)
    query = "EXEC [sp_ProductionSchedule V4_Slots] \'{sd}\', \'{ed}\';".format(sd=start_date, ed=end_date)
    cnxn = pyodbc.connect('DRIVER={SQL Server};SERVER=server3;DATABASE=BWSdb;UID=user5;PWD=M@gic456')
    table_result = pd.read_sql(query, cnxn)
    df1 = pd.DataFrame(table_result)
    df2 = pd.DataFrame(table_result)
    df3 = pd.DataFrame(table_result)
    pd.to_datetime(df1['Prod Date'], unit='s')
    pd.to_datetime(df2['Prod Date'], unit='s')
    pd.to_datetime(df3['Prod Date'], unit='s')
    ordered_df = df2.sort_values(by="GroupID")
    lines = ordered_df.drop_duplicates('GroupID')
    # lines = lines.iloc[:, :1].tolist()
    lines = lines['Prod Line'].tolist()
    ordered_df = df3.sort_values(by="Prod Date")
    dates = ordered_df.drop_duplicates('Prod Date')
    # dates = dates.iloc[:, 3:4].tolist()
    dates = dates['Prod Date'].tolist()
    print("columns:", df1.columns)
    ordered_df = df1.sort_values(by=["GroupID", "Prod Date"])
    cnxn.close()
    return lines, dates, ordered_df
    # return df


if __name__ == '__main__':


    # w = 700
    # h = 500
    # Inclusive start and end dates
    start_date = dt.datetime(2021, 10, 1)  # + dt.timedelta(days=-1)
    end_date = dt.datetime(2021, 10, 31)
    try:
        lines, dates, data = get_production_data(start_date, end_date)
    except ValueError:
        lines = [
            "GNK1",
            "GNK2",
            "TBF",
            "PBF",
            "B1",
            "B2",
            "B3",
            "B4",
            "TS1",
            "TS2",
            "TS3",
            "T1",
            "T2",
            "T3",
            "T4",
            "T5",
            "T6",
            "T7",
            "T8",
            "T9",
            "T10",
            "T11"
        ]
    print("lines:\n\n", lines)
    print("dates:\n\n", dates)
    print("data:\n\n", data)
    print("length:", data.size)
    switch_calendar_use_hover = True

    print("I should see {} rows by {} cols".format(len(lines), len(dates)))

    win_w, win_h = 1700, 900
    can_w, can_h = win_w * 0.98, win_h * 0.8
    window = tkinter.Tk()
    window.geometry("{}x{}".format(win_w, win_h))
    window.title("Production Schedule")

    frame_calendar = tkinter.Frame(window)
    canvas = tkinter.Canvas(frame_calendar, height=can_h, width=can_w, bg=rgb_to_hex(GRAY_12))
    print("GEOMETRY:", canvas.winfo_geometry())
    c = PSCalendar(canvas, can_w, can_h, start_date, end_date, data, lines, dates)

    label_title = tkinter.Label(window, text="Production Schedule\n{} - {}".format(dt.datetime.strftime(start_date, "%Y-%m-%d"), dt.datetime.strftime(end_date, "%Y-%m-%d")))

    def switch_calendar_use_hover_gsm(*args):
        global switch_calendar_use_hover
        switch_calendar_use_hover = not switch_calendar_use_hover
        c.set_user_hover_mode(switch_calendar_use_hover)
        print("USING HOVER: <{}>".format(switch_calendar_use_hover))

    frame_calendar_control = tkinter.Frame(window)
    btn_calendar_use_hover = tkinter.Button(frame_calendar_control, text="Use Hover", command=switch_calendar_use_hover_gsm)
    btn_calendar_export_pdf = tkinter.Button(frame_calendar_control, text="Export pdf", command=c.export_to_pdf)

    btn_calendar_use_hover.pack()
    btn_calendar_export_pdf.pack()

    label_title.pack()
    canvas.pack()
    frame_calendar_control.pack()
    frame_calendar.pack()
    window.mainloop()
