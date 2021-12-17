
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

    def get_data(start_date, end_date):
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
            dates = []
            data = []
        print("lines:\n\n", lines)
        print("dates:\n\n", dates)
        print("data:\n\n", data)
        print("length:", data.size)
        return lines, dates, data

    def create_calendar(start_date, end_date, lines, dates, data):
        canvas.delete("all")
        return PSCalendar(canvas, canvas_header_col, canvas_header_row, can_w, can_h, start_date, end_date, data, lines, dates, border_width)


    # w = 700
    # h = 500
    # Inclusive start and end dates

    start_date_1 = dt.datetime(2021, 10, 1)  # + dt.timedelta(days=-1)
    end_date_1 = dt.datetime(2021, 10, 31)
    lines, dates, data = get_data(start_date_1, end_date_1)

    switch_calendar_use_hover = True

    print("I should see {} rows by {} cols".format(len(lines), len(dates)))

    border_width = 3
    win_w, win_h = 1900, 950
    can_w, can_h = win_w * 0.96, win_h * 0.8
    window = tkinter.Tk()
    window.geometry("{}x{}".format(win_w, win_h))
    window.title("Production Schedule")

    frame_calendar = tkinter.Frame(window)
    canvas = tkinter.Canvas(frame_calendar, height=can_h, width=can_w, bg=rgb_to_hex(GRAY_12))
    print("GEOMETRY:", canvas.winfo_geometry())
    bw = border_width
    canvas_header_row = tkinter.Canvas(frame_calendar, height=25, width=can_w + 60 + bw, bg=rgb_to_hex(BLACK))
    canvas_header_col = tkinter.Canvas(frame_calendar, height=can_h + bw, width=60, bg=rgb_to_hex(BLACK))
    cal = create_calendar(start_date_1, end_date_1, lines, dates, data)

    label_title = tkinter.Label(window, text="Production Schedule\n{} - {}".format(dt.datetime.strftime(start_date_1, "%Y-%m-%d"), dt.datetime.strftime(end_date_1, "%Y-%m-%d")))

    def switch_calendar_use_hover_gsm(*args):
        global switch_calendar_use_hover
        switch_calendar_use_hover = not switch_calendar_use_hover
        cal.set_user_hover_mode(switch_calendar_use_hover)
        print("USING HOVER: <{}>".format(switch_calendar_use_hover))

    def submit_calendar_search(*args):
        global canvas, cal, lines, dates, data
        sd = stringvar_calendar_search_start_date.get()
        ed = stringvar_calendar_search_end_date.get()
        if sd and ed:
            if is_date(sd) and is_date(ed):
                sd = datetime.datetime.strptime(sd, "%Y-%m-%d")
                ed = datetime.datetime.strptime(ed, "%Y-%m-%d")
                if sd <= ed:
                    ed = ed if (ed - sd).days <= 60 else sd + dt.timedelta(days=60)
                    stringvar_calendar_search_start_date.set(sd.strftime("%Y-%m-%d"))
                    stringvar_calendar_search_end_date.set(ed.strftime("%Y-%m-%d"))
                    lines, dates, data = get_data(sd, ed)
                    cal = create_calendar(sd, ed, lines, dates, data)
                    label_title.config(text="Production Schedule\n{} - {}".format(dt.datetime.strftime(sd, "%Y-%m-%d"), dt.datetime.strftime(ed, "%Y-%m-%d")))
                    btn_calendar_export_pdf.config(command=cal.export_to_pdf)
                    cal.redraw_legend()

    frame_calendar_control = tkinter.Frame(window)
    frame_calendar_search_control = tkinter.Frame(frame_calendar_control)
    frame_calendar_search_entries = tkinter.Frame(frame_calendar_control)
    frame_calendar_control_btns = tkinter.Frame(frame_calendar_control)
    frame_calendar_search_control_a = tkinter.Frame(frame_calendar_search_entries)
    frame_calendar_search_control_b = tkinter.Frame(frame_calendar_search_entries)
    frame_calendar_search_control_c = tkinter.Frame(frame_calendar_search_control)
    btn_calendar_use_hover = tkinter.Button(frame_calendar_control_btns, text="Use Hover", command=switch_calendar_use_hover_gsm)
    btn_calendar_export_pdf = tkinter.Button(frame_calendar_control_btns, text="Export pdf", command=cal.export_to_pdf)

    stringvar_calendar_search_start_date = tkinter.StringVar(value=start_date_1.strftime("%Y-%m-%d"))
    stringvar_calendar_search_end_date = tkinter.StringVar(value=end_date_1.strftime("%Y-%m-%d"))
    label_calendar_search_start_date = tkinter.Label(frame_calendar_search_control_a, text="Start Date:")
    entry_calendar_search_start_date = tkinter.Entry(frame_calendar_search_control_a, textvariable=stringvar_calendar_search_start_date)
    label_calendar_search_end_date = tkinter.Label(frame_calendar_search_control_b, text="End Date:")
    entry_calendar_search_end_date = tkinter.Entry(frame_calendar_search_control_b, textvariable=stringvar_calendar_search_end_date)
    btn_calendar_search_submit = tkinter.Button(frame_calendar_search_control_c, text="Submit", command=submit_calendar_search)

    label_calendar_search_start_date.pack(side=tkinter.LEFT)
    entry_calendar_search_start_date.pack(side=tkinter.LEFT)
    label_calendar_search_end_date.pack(side=tkinter.LEFT)
    entry_calendar_search_end_date.pack(side=tkinter.LEFT)
    btn_calendar_search_submit.pack()

    label_title.pack()
    canvas_header_row.pack()
    canvas_header_col.pack(side=tkinter.LEFT)
    canvas.pack()
    frame_calendar_search_control_a.pack()
    frame_calendar_search_control_b.pack()
    frame_calendar_search_entries.pack(side=tkinter.LEFT)
    # frame_calendar_search_entries.pack()
    frame_calendar_search_control_c.pack(side=tkinter.LEFT)
    # frame_calendar_search_control_c.pack()
    frame_calendar_search_control.pack(side=tkinter.LEFT)
    # frame_calendar_control.pack(side=tkinter.LEFT)
    frame_calendar_control.pack()
    btn_calendar_use_hover.pack()
    btn_calendar_export_pdf.pack()
    frame_calendar_control_btns.pack(side=tkinter.LEFT)
    # frame_calendar_control_btns.pack()
    frame_calendar.pack()
    submit_calendar_search()
    window.mainloop()
