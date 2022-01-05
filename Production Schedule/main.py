
import tkinter
from tkinter import ttk
import pyodbc
from pscalendar import *
import pandas as pd


def get_production_data(start_date, end_date):
    assert isinstance(start_date, datetime.datetime), "Start date param: \"{}\" must be a datetime.datetime object.".format(start_date)
    assert isinstance(end_date, datetime.datetime), "End date param: \"{}\" must be a datetime.datetime object.".format(end_date)
    assert start_date <= end_date, "Start date param: \"{}\" must be before End date param \"{}\".".format(start_date, end_date)
    try:
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
    except pyodbc.OperationalError as e:
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
        ordered_df = pd.DataFrame()
        print("e: ", e)
    return lines, dates, ordered_df
    # return df


if __name__ == '__main__':

    def get_data(start_date, end_date):
        lines, dates, data = get_production_data(start_date, end_date)

        print("lines:\n\n", lines)
        print("dates:\n\n", dates)
        print("data:\n\n", data)
        print("length:", data.size)
        return lines, dates, data

    # def create_calendar(start_date, end_date, lines, dates, data):
    #     canvas.delete("all")
    #     return PSCalendar(canvas, canvas_header_col, canvas_header_row, can_w, can_h, start_date, end_date, data, lines, dates, BORDER_WIDTH)

    def create_calendar_p(canvas_a, canvas_b, canvas_c, can_w, can_h, start_date, end_date, data, lines, dates, BORDER_WIDTH):
        canvas_a.delete("all")
        return PSCalendar(canvas_a, canvas_b, canvas_c, can_w, can_h, start_date, end_date, data, lines, dates, BORDER_WIDTH)


    ####################################################################################################################
    ##                                                                                                                ##
    ##                                                   Constants                                                    ##
    ##                                                                                                                ##
    ####################################################################################################################

    N_TEST_CALS = 2
    START_DATE = dt.datetime(2021, 10, 1)  # + dt.timedelta(days=-1)
    END_DATE = dt.datetime(2021, 10, 31)
    CAL_IDX = None
    # lines, dates, data = get_data(START_DATE, END_DATE)

    # Use to keep all calendars using the same controls
    SWITCH_CALENDAR_USE_HOVER = True

    BORDER_WIDTH = 3
    WIN_W, WIN_H = 1900, 950
    # can_w, can_h = WIN_W * 0.96, WIN_H * 0.8

    window = tkinter.Tk()
    window.geometry("{}x{}".format(WIN_W, WIN_H))
    WIN_W, WIN_H = window.winfo_screenwidth(), window.winfo_screenheight()
    can_w, can_h = WIN_W * 0.96, WIN_H * 0.76
    window.geometry("%dx%d+0+0" % (WIN_W, WIN_H))
    window.state('zoomed')
    window.title("Production Schedule")

    def dbl_click_tile(event):
        cal = tab_data[CAL_IDX]["Cal"]
        canvas_pop_up = tab_data[CAL_IDX]["PopUp"]
        cal.unbind_for_pop_up()
        cal.dbl_click_tile(event)
        print("Double clicked Cal: {}, and tile: {}".format(cal, cal.dbl_clicked))
        print("PRE BINDINGS {}".format(cal), cal.canvas.bind())
        try:
            print("PRE POP UP")
            canvas_pop_up.tk_popup(event.x_root, event.y_root)
            print("POST POP UP")
        finally:
            print("PRE GRAB RELEASE")
            canvas_pop_up.grab_release()
        print("POST BINDINGS {}".format(cal), cal.canvas.bind())
        print("PRE BIND")
        cal.bind_canvas()

        cal.selected = None
        # cal.hovered = None
        cal.hover_select = None
        # cal.dragging = None
        # cal.current_hover = None
        cal.dbl_clicked = None

    def on_tab_change(event):
        global SWITCH_CALENDAR_USE_HOVER, CAL_IDX
        tab_name = event.widget.tab('current')['text']
        idx = tab_names.index(tab_name)
        # cal = tab_cals[idx]
        cal = tab_data[idx]["Cal"]
        CAL_IDX = idx
        print("idx:", idx, "using hover:", SWITCH_CALENDAR_USE_HOVER)
        for t in tab_data:
            if t != idx:
                if tab_data[t]["Cal"] is not None:
                    tab_data[t]["Cal"].unbind_canvas()

        # btn_calendar_use_hover.config(command=cal.toggle_use_hover)
        btn_calendar_export_pdf_full.config(command=cal.export_to_pdf_full)
        btn_calendar_export_pdf.config(command=cal.export_to_pdf)

        cal.canvas.bind("<Double-Button-1>", dbl_click_tile)
        cal.canvas.bind("<Button-3>", dbl_click_tile)
        cal.bind_canvas()
        print("binding: {} on tab change".format(cal))
        cal.set_user_hover_mode(SWITCH_CALENDAR_USE_HOVER)

    tab_control = ttk.Notebook(window)
    tab_control.bind("<<NotebookTabChanged>>", on_tab_change)

    # frame_calendar = tkinter.Frame(tab_1)
    # canvas = tkinter.Canvas(frame_calendar, height=can_h, width=can_w, bg=rgb_to_hex(GRAY_12))
    # canvas_header_row = tkinter.Canvas(frame_calendar, height=25, width=can_w + 60 + BORDER_WIDTH, bg=rgb_to_hex(BLACK))
    # canvas_header_col = tkinter.Canvas(frame_calendar, height=can_h + BORDER_WIDTH, width=60, bg=rgb_to_hex(BLACK))
    # canvas_pop_up = tkinter.Menu(frame_calendar, tearoff=0)
    # cal = create_calendar(START_DATE, END_DATE, lines, dates, data)
    # tab_cals = []
    # tab_1 = ttk.Frame(tab_control)
    # tab_2 = ttk.Frame(tab_control)
    # tab_3 = ttk.Frame(tab_control)
    # tab_4 = ttk.Frame(tab_control)
    # tab_5 = ttk.Frame(tab_control)
    # tab_6 = ttk.Frame(tab_control)
    # tab_7 = ttk.Frame(tab_control)
    # tabs = [tab_1, tab_2, tab_3, tab_4, tab_5, tab_6, tab_7]
    tabs = [
        ttk.Frame(tab_control),
        ttk.Frame(tab_control),
        ttk.Frame(tab_control),
        ttk.Frame(tab_control),
        ttk.Frame(tab_control),
        ttk.Frame(tab_control),
        ttk.Frame(tab_control)
    ]
    tab_names = ["Current Period", "+1 Month", "+2 Months", "+3 Months", "+4 Months", "+5 Months", "+6 Months"]
    empty_data = {
        "Name": None,
        "Tab": None,
        "Lines": None,
        "Dates": None,
        "Data": None,
        "HeaderRow": None,
        "HeaderCol": None,
        "PopUp": None,
        "Cal": None
    }
    tab_data = dict(zip([i for i in range(len(tabs))], [dict(empty_data) for _ in range(len(tab_names))]))
    # last_date = cal.end_date
    last_date = START_DATE
    for i, tab in enumerate(tabs):
        if CAL_IDX is None:
            CAL_IDX = i
        c_frame_calendar = tkinter.Frame(tab)
        can = tkinter.Canvas(c_frame_calendar, height=can_h, width=can_w, bg=rgb_to_hex(GRAY_12))
        can_h_c = tkinter.Canvas(c_frame_calendar, height=can_h + BORDER_WIDTH, width=60, bg=rgb_to_hex(BLACK))
        can_h_r = tkinter.Canvas(c_frame_calendar, height=25, width=can_w + 60 + BORDER_WIDTH, bg=rgb_to_hex(BLACK))
        can_p_u = tkinter.Menu(c_frame_calendar, tearoff=0)
        last_date = last_date + dt.timedelta(days=1)
        c_end_date = last_date + dt.timedelta(days=31)
        c_lines, c_dates, dat = get_data(last_date, c_end_date)
        print("last_date: {}: {}, c_end_date: {}: {}".format(type(last_date), last_date, type(c_end_date), c_end_date))
        print("c_dates", c_dates)
        psc = create_calendar_p(can, can_h_c, can_h_r, can_w, can_h, last_date, c_end_date, dat, c_lines, c_dates, BORDER_WIDTH)
        c_label_title = tkinter.Label(tab, text="Production Schedule\n{} - {}".format(
            dt.datetime.strftime(last_date, "%Y-%m-%d"), dt.datetime.strftime(c_end_date, "%Y-%m-%d")))
        c_label_title.pack()
        can_h_r.pack()
        can_h_c.pack(side=tkinter.LEFT)
        can.pack()
        c_frame_calendar.pack()
        # tab_cals.append(psc)

        t_dat = tab_data[i]
        t_dat.update({
            "Name": tab_names[i],
            "Tab": tab,
            "Lines": c_lines,
            "Dates": c_dates,
            "Data": dat,
            "HeaderRow": can_h_c,
            "HeaderCol": can_h_r,
            "PopUp": can_p_u,
            "Cal": psc
        })

        last_date += dt.timedelta(days=31)
        if i >= N_TEST_CALS:
            break

    tabs = tabs if len(tabs) <= N_TEST_CALS else tabs[:N_TEST_CALS]
    tab_names = tab_names if len(tab_names) <= N_TEST_CALS else tab_names[:N_TEST_CALS]

    # label_title = tkinter.Label(tab_1, text="Production Schedule\n{} - {}".format(dt.datetime.strftime(START_DATE, "%Y-%m-%d"), dt.datetime.strftime(END_DATE, "%Y-%m-%d")))

    for tab, tab_name in zip(tabs, tab_names):
        tab_control.add(tab, text=tab_name)

    # print(dict_print(tab_data, "Tab Data"))
    print("CALS:\n\t" + "\n\t".join([str(v["Cal"]) for k, v in tab_data.items()]))

    ####################################################################################################################
    ####################################################################################################################
    ####################################################################################################################
    ####################################################################################################################
    ####################################################################################################################

    def switch_calendar_use_hover_gsm(*args):
        # print("HEY!!!!!")
        global SWITCH_CALENDAR_USE_HOVER
        # raise ValueError("WUT IS GOING ON HERE?!?")
        SWITCH_CALENDAR_USE_HOVER = not SWITCH_CALENDAR_USE_HOVER
        print("USING HOVER: <{}>".format(SWITCH_CALENDAR_USE_HOVER))
        cal = tab_data[CAL_IDX]["Cal"]
        cal.set_user_hover_mode(SWITCH_CALENDAR_USE_HOVER)

    def submit_calendar_search(*args):
        print("submit!")
        # global canvas, lines, dates, data
        # sd = stringvar_calendar_search_start_date.get()
        # ed = stringvar_calendar_search_end_date.get()
        # if sd and ed:
        #     if is_date(sd) and is_date(ed):
        #         sd = datetime.datetime.strptime(sd, "%Y-%m-%d")
        #         ed = datetime.datetime.strptime(ed, "%Y-%m-%d")
        #         if sd <= ed:
        #             entry_calendar_search_start_date.config(fg=rgb_to_hex(BLACK))
        #             entry_calendar_search_end_date.config(fg=rgb_to_hex(BLACK))
        #             ed = ed if (ed - sd).days <= 60 else sd + dt.timedelta(days=60)
        #             stringvar_calendar_search_start_date.set(sd.strftime("%Y-%m-%d"))
        #             stringvar_calendar_search_end_date.set(ed.strftime("%Y-%m-%d"))
        #             lines, dates, data = get_data(sd, ed)
        #             cal = create_calendar(sd, ed, lines, dates, data)
        #             # label_title.config(text="Production Schedule\n{} - {}".format(dt.datetime.strftime(sd, "%Y-%m-%d"), dt.datetime.strftime(ed, "%Y-%m-%d")))
        #             btn_calendar_export_pdf.config(command=cal.export_to_pdf)
        #             cal.redraw_legend()
        #         else:
        #             entry_calendar_search_start_date.config(fg=rgb_to_hex(RED))
        #             entry_calendar_search_end_date.config(fg=rgb_to_hex(RED))

    def populate_pop_up_menu():

        canvas_pop_up = tab_data[CAL_IDX]["PopUp"]
        canvas_pop_up.add_command(label="Add 1 Day", command=add_day)
        canvas_pop_up.add_command(label="Subtract 1 Day", command=subtract_day)
        canvas_pop_up.add_separator()
        canvas_pop_up.add_checkbutton(label="Apply to Entire Line")
        canvas_pop_up.add_radiobutton(label="A")
        canvas_pop_up.add_radiobutton(label="B")

    def wipe_pop_up_menu():
        canvas_pop_up = tab_data[CAL_IDX]["PopUp"]
        canvas_pop_up.delete(0, 6)

    def add_day():
        # tab_name = event.widget.tab('current')['text']
        # idx = tab_names.index(tab_name)
        # cal = tab_cals[idx]
        idx = 9
        print("cal index: {}".format(idx))

    def subtract_day():
        pass


    cal = tab_data[CAL_IDX]["Cal"]
    frame_calendar_control = tkinter.Frame(window)
    frame_calendar_search_control = tkinter.Frame(frame_calendar_control)
    frame_calendar_search_entries = tkinter.Frame(frame_calendar_control)
    frame_calendar_control_btns = tkinter.Frame(frame_calendar_control)
    frame_calendar_search_control_a = tkinter.Frame(frame_calendar_search_entries)
    frame_calendar_search_control_b = tkinter.Frame(frame_calendar_search_entries)
    frame_calendar_search_control_c = tkinter.Frame(frame_calendar_search_control)
    btn_calendar_use_hover = tkinter.Button(frame_calendar_control_btns, text="Use Hover", command=switch_calendar_use_hover_gsm)
    btn_calendar_export_pdf_full = tkinter.Button(frame_calendar_control_btns, text="Export pdf (Full)", command=cal.export_to_pdf_full)
    btn_calendar_export_pdf = tkinter.Button(frame_calendar_control_btns, text="Export pdf", command=cal.export_to_pdf)

    stringvar_calendar_search_start_date = tkinter.StringVar(value=START_DATE.strftime("%Y-%m-%d"))
    stringvar_calendar_search_end_date = tkinter.StringVar(value=END_DATE.strftime("%Y-%m-%d"))
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

    # label_title.pack()
    # canvas_header_row.pack()
    # canvas_header_col.pack(side=tkinter.LEFT)
    # canvas.pack()
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
    btn_calendar_export_pdf_full.pack()
    btn_calendar_export_pdf.pack()
    frame_calendar_control_btns.pack(side=tkinter.LEFT)
    # frame_calendar_control_btns.pack()
    # frame_calendar.pack()
    submit_calendar_search()
    tab_control.pack(expand=1, fill="both")
    populate_pop_up_menu()
    window.mainloop()

    # for i, t in enumerate(cal.tiles):
    #     print(dict_print(t.info_dict(), "Tile: #{}".format(i)))
