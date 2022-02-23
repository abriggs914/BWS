import asyncio
import tkinter
from tkinter import ttk
from tkinter import colorchooser
import pyodbc
import platform
from pscalendar import *
import pandas as pd
from PIL import ImageTk, Image
from pathlib import Path

WINDOW = None

async def read_sql_async(stmt, con):
    '''
    Helper function to wrap pd.read_sql in an asynchronous call.
    :param stmt: SQL statement to be passed
    :param con: connection string
    :return: The query results in a Pandas Dataframe
    '''
    loop = asyncio.get_event_loop()
    return await loop.run_in_executor(None, pd.read_sql, stmt, con)


async def get_production_data(start_date, end_date, first=True):
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
    try:
        # Use this as an entry point for test sets
        with open("df1.json", "r") as f:
            ordered_df = pd.read_json(f)
            dates = ordered_df.drop_duplicates('Prod Date')
            # dates = dates.iloc[:, 3:4].tolist()
            print("LIST:", dates['Prod Date'].tolist())
            print("LIST[0]:", dates['Prod Date'].tolist()[0])
            print("type(LIST[0]:)", type(dates['Prod Date'].tolist()[0]))
            dates = [pd.to_datetime(str(dtm), unit='ms') for dtm in dates['Prod Date'].tolist()]
            dates.sort()
    except FileNotFoundError:
        print("File not found.")
    try:
        query = "EXEC [sp_ProductionSchedule V4_Slots] \'{sd}\', \'{ed}\';".format(sd=start_date, ed=end_date)
        splash_query_pb["value"] = 46
        splash_query_pb.update()
        cnxn = pyodbc.connect('DRIVER={SQL Server};SERVER=server3;DATABASE=BWSdb;UID=user5;PWD=M@gic456', timeout=10)
        splash_query_pb["value"] = 56
        splash_query_pb.update()
        table_result = await read_sql_async(query, cnxn)
        splash_query_pb["value"] = 77
        splash_query_pb.update()
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

        # TODO can use this as a testing entry
        # print("df1:", df1)
        # print(str(df1.to_json()))
        # df1 = pd.read_json(df1.to_json())

        ordered_df = df1.sort_values(by=["GroupID", "Prod Date"])
        cnxn.close()
    except pd.io.sql.DatabaseError:
        # try again ONCE:
        if first:
            print("Trying again...")
            lines, dates, ordered_df = await get_production_data(start_date, end_date, first=False)
        else:
            print("Deadlock error. Please try again later.")
    except pyodbc.OperationalError:
        print("[08001] [Microsoft][ODBC SQL Server Driver][DBNETLIB]SQL Server does not exist or access denied.")
        print("Using default values")

    return lines, dates, ordered_df
    # return df


def exit_program():
    '''
    Function called to quit the application.
    :return: None
    '''
    # if WINDOW is not None and isinstance(WINDOW, tkinter.Tk):
        # TODO THIS FAILS IF YOU CLICK 'X' FIRST.
        # WINDOW.destroy()
    print("Goodbye!")
    exit()


if __name__ == '__main__':

    OPERATING_SYSTEM = platform.system()
    WINDOWS_VERSION = int(platform.release())
    if OPERATING_SYSTEM != "Windows" or WINDOWS_VERSION < 8:
        print("This program can only be used on a computer that has a Windows operating system and who's version number is greater than Windows 7.")
        exit_program()

    async def get_data(start_date, end_date):
        lines, dates, data = await get_production_data(start_date, end_date)

        print("lines:\n\n", lines)
        print("dates:\n\n", dates)
        print("data:\n\n", data)
        print("length:", data.size)
        return lines, dates, data

    def create_calendar_p(canvas_a, canvas_b, canvas_c, can_w, can_h, start_date, end_date, data, lines, dates, BORDER_WIDTH):
        canvas_a.delete("all")
        return PSCalendar(canvas_a, canvas_b, canvas_c, can_w, can_h, start_date, end_date, data, lines, dates, BORDER_WIDTH)


    ####################################################################################################################
    ##                                                                                                                ##
    ##                                                   Constants                                                    ##
    ##                                                                                                                ##
    ####################################################################################################################

    TITLE = "Production Schedule Editor"
    VERSION_NAME = "Version 1.1.0222"
    BWS_LOGO_FILE_PATH = r"""C:\Access\BWS Chrome Final WO Manufacturing.jpg"""
    STARGATE_LOGO_FILE_PATH = r"""C:\Access\Stargate Logo 50%.jpg"""

    # iff T, both logo file paths must be in the C:\Access folder
    # else F, using the copies in the app folder
    assert_is_employee = False

    # N_TEST_CALS = None
    N_TEST_CALS = 1
    START_DATE = dt.datetime(2021, 10, 1)  # + dt.timedelta(days=-1)
    END_DATE = dt.datetime(2021, 10, 31)
    CAL_IDX = None
    TABS = None
    TAB_NAMES = None
    TAB_DATA = None
    # lines, dates, data = get_data(START_DATE, END_DATE)

    # Use to keep all calendars using the same controls
    SWITCH_CALENDAR_USE_HOVER = False
    SWITCH_CALENDAR_DRAW_WEEK_DIVS = True

    BORDER_WIDTH = 3
    # WIN_W, WIN_H = int(1900 * 0.6), int(950 * 0.6)
    WIN_W, WIN_H = 800, 500
    SPLASH_LENGTH = 300
    SPLASH_BG = rgb_to_hex(GRAY_17)
    SPLASH_FG = rgb_to_hex(WHITE)
    LOGO_WIDTH = int((WIN_W * 0.8) / 2)
    LOGO_HEIGHT = int(WIN_H * 0.3)
    # CAN_W, CAN_H = WIN_W * 0.96, WIN_H * 0.8
    dealer_colour_data = None


    ####################################################################################################################
    ##                                                                                                                ##
    ##                                                     BEGIN                                                      ##
    ##                                                                                                                ##
    ####################################################################################################################

    if not Path(BWS_LOGO_FILE_PATH).exists():
        if not assert_is_employee:
            BWS_LOGO_FILE_PATH = r"""./BWS Chrome Final_hr.jpg"""
        else:
            print("You must be an employee to use this program.")
            exit_program()

    if not Path(STARGATE_LOGO_FILE_PATH).exists():
        if not assert_is_employee:
            STARGATE_LOGO_FILE_PATH = r"""./Stargate Logo 50%.jpg"""
        else:
            print("You must be an employee to use this program.")
            exit_program()

    WINDOW = tkinter.Tk()
    DEFAULT_BG = rgb_to_hex(GRAY_93)
    F_WIN_W, F_WIN_H = WINDOW.winfo_screenwidth(), WINDOW.winfo_screenheight()
    CAN_W, CAN_H = F_WIN_W * 0.96, F_WIN_H * 0.72

    SCREEN_WIDTH = WINDOW.winfo_screenwidth()
    SCREEN_HEIGHT = WINDOW.winfo_screenheight()
    x_cordinate = int((SCREEN_WIDTH / 2) - (WIN_W / 2))
    y_cordinate = int((SCREEN_HEIGHT / 2) - (WIN_H / 2))
    WINDOW.geometry("{}x{}+{}+{}".format(WIN_W, WIN_H, x_cordinate, y_cordinate))

    WINDOW.title("Production Schedule")
    LOADED = tkinter.BooleanVar(value=False)
    lb_dealer_1 = tkinter.StringVar()
    lb_dealer_2 = tkinter.StringVar()
    lb_dealer_3 = tkinter.StringVar()

    btn_calendar_export_pdf_full = None
    btn_calendar_export_pdf = None

    def dbl_click_tile_click(event):
        dbl_click_tile(event, True)

    def dbl_click_tile_left(event):
        dbl_click_tile(event)

    def dbl_click_tile(event, resize_click=False):
        cal = TAB_DATA[CAL_IDX]["Cal"]
        canvas_pop_up = TAB_DATA[CAL_IDX]["PopUp"]
        cal.unbind_for_pop_up()
        cal.dbl_click_tile(event)
        print("Double clicked Cal: {}, and tile: {}".format(cal, cal._dbl_clicked))
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

        cal._selected = None
        # cal._hovered = None
        cal._hover_select = None
        # cal._dragging = None
        # cal._current_hover = None
        # print("RESETTING cal._dbl_clicked")
        # cal._dbl_clicked = None


    def colour_chooser_1(event):
        cal = TAB_DATA[CAL_IDX]["Cal"]
        cal.unhighlight_dealer(2)
        rgb_code, colour_code = colorchooser.askcolor(title="Choose color")
        print("colour_code:", colour_code)
        if colour_code is None:
            return
        btn_1, cb_dealer_1, btn_2, cb_dealer_2, btn_3, cb_dealer_3 = dealer_colour_data
        btn_1.config(bg=colour_code, activebackground=colour_code)
        btn_1.config(text=colour_code)
        btn_1.update()
        WINDOW.update()
        d_name = lb_dealer_1.get()
        print("HIERE 1 TN", TAB_NAMES)
        if d_name is not None and d_name:
            print("\t\tHIERE", TAB_DATA.keys())
            for i, t_name in enumerate(TAB_NAMES):
                c = TAB_DATA[i]["Cal"]
                print("Highlighting c: <{}>: {}, {}".format(c, d_name, colour_code))
                c.highlight_dealer(d_name, colour_code, 0)
        cal.canvas.focus_set()
        cal.draw_canvas()


    def colour_chooser_2(event):
        cal = TAB_DATA[CAL_IDX]["Cal"]
        cal.unhighlight_dealer(2)
        rgb_code, colour_code = colorchooser.askcolor(title="Choose color")
        print("colour_code:", colour_code)
        if colour_code is None:
            return
        btn_1, cb_dealer_1, btn_2, cb_dealer_2, btn_3, cb_dealer_3 = dealer_colour_data
        btn_2.config(bg=colour_code, activebackground=colour_code)
        btn_2.config(text=colour_code)
        btn_2.update()
        WINDOW.update()
        d_name = lb_dealer_2.get()
        print("HIERE 1 TN", TAB_NAMES)
        if d_name is not None and d_name:
            print("\t\tHIERE", TAB_DATA.keys())
            for i, t_name in enumerate(TAB_NAMES):
                c = TAB_DATA[i]["Cal"]
                print("Highlighting c: <{}>: {}, {}".format(c, d_name, colour_code))
                c.highlight_dealer(d_name, colour_code, 1)
        cal.canvas.focus_set()
        cal.draw_canvas()


    def colour_chooser_3(event):
        cal = TAB_DATA[CAL_IDX]["Cal"]
        cal.unhighlight_dealer(2)
        rgb_code, colour_code = colorchooser.askcolor(title="Choose color")
        print("colour_code:", colour_code)
        if colour_code is None:
            return
        btn_1, cb_dealer_1, btn_2, cb_dealer_2, btn_3, cb_dealer_3 = dealer_colour_data
        btn_3.config(bg=colour_code, activebackground=colour_code)
        btn_3.config(text=colour_code)
        btn_3.update()
        WINDOW.update()
        d_name = lb_dealer_3.get()
        print("HIERE 1 TN", TAB_NAMES)
        if d_name is not None and d_name:
            print("\t\tHIERE", TAB_DATA.keys())
            for i, t_name in enumerate(TAB_NAMES):
                c = TAB_DATA[i]["Cal"]
                print("Highlighting c: <{}>: {}, {}".format(c, d_name, colour_code))
                c.highlight_dealer(d_name, colour_code, 2)
        cal.canvas.focus_set()
        cal.draw_canvas()


    def update_dealer_1(*args):
        print("updating dealer_1")
        cal = TAB_DATA[CAL_IDX]["Cal"]
        btn_1, cb_dealer_1, btn_2, cb_dealer_2, btn_3, cb_dealer_3 = dealer_colour_data
        colour_code = btn_1["bg"]
        d_name = lb_dealer_1.get()
        if iscolour(colour_code) and d_name:
            for i, t_name in enumerate(TAB_NAMES):
                c = TAB_DATA[i]["Cal"]
                print("Highlighting c: <{}>: {}, {}".format(c, d_name, colour_code))
                c.highlight_dealer(d_name, colour_code, 0)
        cal.draw_canvas()


    def update_dealer_2(*args):
        print("updating dealer_2")
        cal = TAB_DATA[CAL_IDX]["Cal"]
        btn_1, cb_dealer_1, btn_2, cb_dealer_2, btn_3, cb_dealer_3 = dealer_colour_data
        colour_code = btn_2["bg"]
        d_name = lb_dealer_2.get()
        if iscolour(colour_code) and d_name:
            for i, t_name in enumerate(TAB_NAMES):
                c = TAB_DATA[i]["Cal"]
                print("Highlighting c: <{}>: {}, {}".format(c, d_name, colour_code))
                c.highlight_dealer(d_name, colour_code, 1)
        cal.draw_canvas()


    def update_dealer_3(*args):
        print("updating dealer_3")
        cal = TAB_DATA[CAL_IDX]["Cal"]
        btn_1, cb_dealer_1, btn_2, cb_dealer_2, btn_3, cb_dealer_3 = dealer_colour_data
        colour_code = btn_3["bg"]
        d_name = lb_dealer_3.get()
        if iscolour(colour_code) and d_name:
            for i, t_name in enumerate(TAB_NAMES):
                c = TAB_DATA[i]["Cal"]
                print("Highlighting c: <{}>: {}, {}".format(c, d_name, colour_code))
                c.highlight_dealer(d_name, colour_code, 2)
        cal.draw_canvas()


    def reset_dealer_1():
        btn_1, cb_dealer_1, btn_2, cb_dealer_2, btn_3, cb_dealer_3 = dealer_colour_data
        lb_dealer_1.set("")
        btn_1.config(bg=DEFAULT_BG, activebackground=DEFAULT_BG, text="")
        btn_1.update()
        WINDOW.update()
        print("resetting dealer_1")


    def reset_dealer_2():
        btn_1, cb_dealer_1, btn_2, cb_dealer_2, btn_3, cb_dealer_3 = dealer_colour_data
        lb_dealer_2.set("")
        btn_2.config(bg=DEFAULT_BG, activebackground=DEFAULT_BG, text="")
        btn_2.update()
        WINDOW.update()
        print("resetting dealer_2")


    def reset_dealer_3():
        btn_1, cb_dealer_1, btn_2, cb_dealer_2, btn_3, cb_dealer_3 = dealer_colour_data
        lb_dealer_3.set("")
        btn_3.config(bg=DEFAULT_BG, activebackground=DEFAULT_BG, text="")
        btn_3.update()
        WINDOW.update()
        print("resetting dealer_3")


    def on_tab_change(event):
        global SWITCH_CALENDAR_USE_HOVER, CAL_IDX, btn_calendar_export_pdf_full, btn_calendar_export_pdf, dealer_colour_data
        print("dealer_colour_data:", dealer_colour_data)
        print("lb_dealer_1", lb_dealer_1.get())
        print("lb_dealer_2", lb_dealer_2.get())
        print("lb_dealer_3", lb_dealer_3.get())
        tab_name = event.widget.tab('current')['text']
        idx = TAB_NAMES.index(tab_name)
        # cal = tab_cals[idx]
        cal = TAB_DATA[idx]["Cal"]
        CAL_IDX = idx
        print("idx:", idx, "using hover:", SWITCH_CALENDAR_USE_HOVER)
        for t in TAB_DATA:
            if t != idx:
                if TAB_DATA[t]["Cal"] is not None:
                    TAB_DATA[t]["Cal"].unbind_canvas()

        # btn_calendar_use_hover.config(command=cal.toggle_use_hover)
        btn_calendar_export_pdf_full.config(command=cal.export_to_pdf_full)
        btn_calendar_export_pdf.config(command=cal.export_to_pdf)

        cal.canvas.bind("<Double-Button-1>", dbl_click_tile_click)
        cal.canvas.bind("<Button-3>", dbl_click_tile_left)
        cal.bind_canvas()
        print("binding: {} on tab change".format(cal))
        cal.set_user_hover_mode(SWITCH_CALENDAR_USE_HOVER)
        cal.set_drawing_week_divs(SWITCH_CALENDAR_DRAW_WEEK_DIVS)
        # populate_pop_up_menu() # Dont need? 2022-02-22

        WINDOW.bind("<a>", cal.kbd_arrow_left)
        WINDOW.bind("<w>", cal.kbd_arrow_up)
        WINDOW.bind("<s>", cal.kbd_arrow_down)
        WINDOW.bind("<d>", cal.kbd_arrow_right)

        WINDOW.bind("<Left>", cal.kbd_arrow_left)
        WINDOW.bind("<Up>", cal.kbd_arrow_up)
        WINDOW.bind("<Down>", cal.kbd_arrow_down)
        WINDOW.bind("<Right>", cal.kbd_arrow_right)
        dealers = []

        print("LOADED:", LOADED.get(), ", dealers:", dealers, "dealer_colour_data", dealer_colour_data)
        assert dealer_colour_data is not None, "dealer_colour_data is None"

        if LOADED.get() and dealer_colour_data is not None:
            dealers = cal.dealers
            highlights = cal.dealer_highlights

            print("dealers (" + str(len(dealers)) + "):", dealers)
            print("lb1:", lb_dealer_1.get())
            print("lb2:", lb_dealer_2.get())
            print("lb3:", lb_dealer_3.get())
            btn_1, cb_dealer_1, btn_2, cb_dealer_2, btn_3, cb_dealer_3 = dealer_colour_data
            # lb_dealer_1.set("")
            # lb_dealer_2.set("")
            # lb_dealer_3.set("")
            cb_dealer_1["values"] = dealers
            cb_dealer_2["values"] = dealers
            cb_dealer_3["values"] = dealers
            print("SETTING DEALERS")
            raise ValueError(str(dealers))

            btn_1.bind("<Double-Button-1>", colour_chooser_1)
            btn_2.bind("<Double-Button-1>", colour_chooser_2)
            btn_3.bind("<Double-Button-1>", colour_chooser_3)
            lb_dealer_1.trace("w", update_dealer_1)
            lb_dealer_2.trace("w", update_dealer_2)
            lb_dealer_3.trace("w", update_dealer_3)

        print("**lb_dealer_1.get():", lb_dealer_1.get())
        print("**lb_dealer_1.get() in dealers:", lb_dealer_1.get() in dealers)
        if lb_dealer_1.get() and lb_dealer_1.get() in dealers:
            # cb_dealer_1.current(dealers.index(lb_dealer_1.get()))
            cb_dealer_1["value"] = lb_dealer_1.get()
        if lb_dealer_2.get() and lb_dealer_2.get() in dealers:
            cb_dealer_2.current(dealers.index(lb_dealer_2.get()))
        if lb_dealer_3.get() and lb_dealer_3.get() in dealers:
            cb_dealer_3.current(dealers.index(lb_dealer_3.get()))
        # dealers
        # for d in dealer
        # if highlights:
        #     for i in range(3):
        #         pass

        cal.canvas.focus_set()
        cal.draw_canvas()

    notebook_tab_control = ttk.Notebook(WINDOW)
    notebook_tab_control.bind("<<NotebookTabChanged>>", on_tab_change)

    splash_frame = tkinter.Frame(WINDOW, bg=SPLASH_BG)
    splash_frame_logos = tkinter.Frame(splash_frame, bg=SPLASH_BG)
    bws_logo = ImageTk.PhotoImage(Image.open(BWS_LOGO_FILE_PATH).resize((LOGO_WIDTH, LOGO_HEIGHT)))
    splash_logo_bws = tkinter.Label(splash_frame_logos, image=bws_logo)
    stargate_logo = ImageTk.PhotoImage(Image.open(STARGATE_LOGO_FILE_PATH).resize((LOGO_WIDTH, LOGO_HEIGHT)))
    splash_logo_stargate = tkinter.Label(splash_frame_logos, image=stargate_logo)

    splash_frame_pbs = tkinter.Frame(splash_frame, bg=SPLASH_BG)
    splash_label = tkinter.Label(splash_frame_pbs, text=TITLE, bg=SPLASH_BG, fg=SPLASH_FG, font=("Arial", 16, "bold"))
    splash_status_top = tkinter.Label(splash_frame_pbs, text="Generating Schedule From {start} To {end}", bg=SPLASH_BG, fg=SPLASH_FG)
    splash_status_bottom = tkinter.Label(splash_frame_pbs, text="0 % Complete", bg=SPLASH_BG, fg=SPLASH_FG)
    splash_pb = ttk.Progressbar(
        splash_frame_pbs,
        orient='horizontal',
        mode='determinate',
        length=SPLASH_LENGTH
    )
    splash_query_pb = ttk.Progressbar(
        splash_frame_pbs,
        orient="horizontal",
        mode="determinate",
        length=SPLASH_LENGTH
    )
    splash_test_indicator = tkinter.Label(splash_frame, text="Testing {} calendar{}".format(N_TEST_CALS, "s" if N_TEST_CALS != 1 else ""), bg=rgb_to_hex(brighten(hex_to_rgb(SPLASH_BG), 0.25)), fg=rgb_to_hex(RED_3), font=("Arial", 16))
    splash_version = tkinter.Label(splash_frame, text=VERSION_NAME, bg=SPLASH_BG, fg=SPLASH_FG)

    splash_logo_bws.pack(side=tkinter.LEFT, padx=10, pady=20)
    splash_logo_stargate.pack(side=tkinter.RIGHT, padx=10, pady=20)
    splash_frame_logos.pack(side=tkinter.TOP)

    splash_label.pack(pady=5)  # title
    splash_status_top.pack(anchor=tkinter.W)  # individual schedule progress text
    splash_query_pb.pack(pady=5)  # individual schedule progress bar
    splash_status_bottom.pack(anchor=tkinter.W)  # overall loading progress text
    splash_pb.pack(pady=5)  # overall loading progress bar
    splash_version.pack(side=tkinter.BOTTOM, anchor=tkinter.SW)
    splash_frame_pbs.pack(side=tkinter.BOTTOM, pady=60)  # progress texts and bars go below logos
    if N_TEST_CALS is not None:
        splash_test_indicator.pack()
    splash_frame.pack(expand=True, fill=tkinter.BOTH)

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

    def switch_calendar_week_divs_gsm(*args):
        global SWITCH_CALENDAR_DRAW_WEEK_DIVS
        SWITCH_CALENDAR_DRAW_WEEK_DIVS = not SWITCH_CALENDAR_DRAW_WEEK_DIVS
        cal = TAB_DATA[CAL_IDX]["Cal"]
        cal.set_drawing_week_divs(SWITCH_CALENDAR_DRAW_WEEK_DIVS)
        cal.draw_canvas()

    def switch_calendar_use_hover_gsm(*args):
        # print("HEY!!!!!")
        global SWITCH_CALENDAR_USE_HOVER
        # raise ValueError("WUT IS GOING ON HERE?!?")
        SWITCH_CALENDAR_USE_HOVER = not SWITCH_CALENDAR_USE_HOVER
        print("USING HOVER: <{}>".format(SWITCH_CALENDAR_USE_HOVER))
        cal = TAB_DATA[CAL_IDX]["Cal"]
        cal.set_user_hover_mode(SWITCH_CALENDAR_USE_HOVER)

    # frame_calendar = tkinter.Frame(tab_1)
    # canvas = tkinter.Canvas(frame_calendar, height=CAN_H, width=CAN_W, bg=rgb_to_hex(GRAY_12))
    # canvas_header_row = tkinter.Canvas(frame_calendar, height=25, width=CAN_W + 60 + BORDER_WIDTH, bg=rgb_to_hex(BLACK))
    # canvas_header_col = tkinter.Canvas(frame_calendar, height=CAN_H + BORDER_WIDTH, width=60, bg=rgb_to_hex(BLACK))
    # canvas_pop_up = tkinter.Menu(frame_calendar, tearoff=0)
    # cal = create_calendar(START_DATE, END_DATE, lines, dates, data)
    # tab_cals = []
    # tab_1 = ttk.Frame(notebook_tab_control)
    # tab_2 = ttk.Frame(notebook_tab_control)
    # tab_3 = ttk.Frame(notebook_tab_control)
    # tab_4 = ttk.Frame(notebook_tab_control)
    # tab_5 = ttk.Frame(notebook_tab_control)
    # tab_6 = ttk.Frame(notebook_tab_control)
    # tab_7 = ttk.Frame(notebook_tab_control)
    # TABS = [tab_1, tab_2, tab_3, tab_4, tab_5, tab_6, tab_7]


    async def populate_tab_data():
        global TABS, TAB_NAMES, TAB_DATA, LOADED

        # List of tabs as tkinter frames
        TABS = [
            ttk.Frame(notebook_tab_control),
            ttk.Frame(notebook_tab_control),
            ttk.Frame(notebook_tab_control),
            ttk.Frame(notebook_tab_control),
            ttk.Frame(notebook_tab_control),
            ttk.Frame(notebook_tab_control),
            ttk.Frame(notebook_tab_control)
        ]
        TAB_NAMES = ["Current Period", "+1 Month", "+2 Months", "+3 Months", "+4 Months", "+5 Months", "+6 Months"]

        # Zipping Tab frames and names. Prepping for Navigation Tabs
        # Capping # TABS and queries based on N_TEST_CALS
        if N_TEST_CALS is not None:
            TABS = TABS if len(TABS) <= N_TEST_CALS else TABS[:N_TEST_CALS]
            TAB_NAMES = TAB_NAMES if len(TAB_NAMES) <= N_TEST_CALS else TAB_NAMES[:N_TEST_CALS]

        empty_data = {
            "Name": None,
            "Tab": None,
            "Lines": None,
            "Dates": None,
            "Data": None,
            "HeaderRow": None,
            "HeaderCol": None,
            "PopUp": None,
            "PopUpDat": None,
            "Cal": None
        }
        TAB_DATA = dict(zip([i for i in range(len(TABS))], [dict(empty_data) for _ in range(len(TAB_NAMES))]))

        # last_date = cal.end_date
        last_date = START_DATE
        n = len(TABS)
        for i, tab in enumerate(TABS):
            splash_query_pb["value"] = 0
            splash_query_pb.update()
            c_frame_calendar = tkinter.Frame(tab)
            splash_query_pb["value"] = 25
            splash_query_pb.update()
            can = tkinter.Canvas(c_frame_calendar, height=CAN_H, width=CAN_W, bg=rgb_to_hex(GRAY_12))
            can_h_c = tkinter.Canvas(c_frame_calendar, height=CAN_H + BORDER_WIDTH, width=60, bg=rgb_to_hex(BLACK))
            can_h_r = tkinter.Canvas(c_frame_calendar, height=25, width=CAN_W + 60 + BORDER_WIDTH, bg=rgb_to_hex(BLACK))
            can_p_u = tkinter.Menu(c_frame_calendar, tearoff=0)
            last_date = last_date + dt.timedelta(days=1)
            c_end_date = last_date + dt.timedelta(days=31)
            fmt = "%Y-%m-%d"
            splash_status_top.config(text="Generating Schedule From {start} To {end}".format(start=last_date.strftime(fmt), end=c_end_date.strftime(fmt)))
            splash_query_pb["value"] = 35
            splash_query_pb.update()
            c_lines, c_dates, dat = await get_data(last_date, c_end_date)
            splash_query_pb["value"] = 85
            splash_query_pb.update()
            print("last_date: {}: {}, c_end_date: {}: {}".format(type(last_date), last_date, type(c_end_date), c_end_date))
            print("c_dates", c_dates)
            psc = create_calendar_p(can, can_h_c, can_h_r, CAN_W, CAN_H, last_date, c_end_date, dat, c_lines, c_dates, BORDER_WIDTH)
            c_label_title = tkinter.Label(tab, text="Production Schedule\n{} - {}".format(
                dt.datetime.strftime(last_date, "%Y-%m-%d"), dt.datetime.strftime(c_end_date, "%Y-%m-%d")))
            c_label_title.pack()
            can_h_r.pack()
            can_h_c.pack(side=tkinter.LEFT)
            can.pack()
            c_frame_calendar.pack()
            # tab_cals.append(psc)

            t_dat = TAB_DATA[i]
            t_dat.update({
                "Name": TAB_NAMES[i],
                "Tab": tab,
                "Lines": c_lines,
                "Dates": c_dates,
                "Data": dat,
                "HeaderRow": can_h_c,
                "HeaderCol": can_h_r,
                "PopUp": can_p_u,
                "Cal": psc,
                "c_label_title": c_label_title
            })

            last_date += dt.timedelta(days=31)
            p = 1 / n
            print("p: {}, i: {}, n: {}, x: {}".format(p, i, n, p * 100))
            splash_pb.step(p * 100)
            splash_status_bottom.config(text="{} % Complete".format(round(splash_pb["value"], 2)))
            splash_query_pb["value"] = 100
            splash_query_pb.update()
            WINDOW.update()
            # if i >= N_TEST_CALS:
            #     break

        # TABS = TABS if len(TABS) <= N_TEST_CALS else TABS[:N_TEST_CALS]
        # TAB_NAMES = TAB_NAMES if len(TAB_NAMES) <= N_TEST_CALS else TAB_NAMES[:N_TEST_CALS]

        # label_title = tkinter.Label(tab_1, text="Production Schedule\n{} - {}".format(dt.datetime.strftime(START_DATE, "%Y-%m-%d"), dt.datetime.strftime(END_DATE, "%Y-%m-%d")))

        for tab, tab_name in zip(TABS, TAB_NAMES):
            notebook_tab_control.add(tab, text=tab_name)
        LOADED.set(True)


    ####################################################################################################################
    ####################################################################################################################
    ####################################################################################################################
    ####################################################################################################################
    ####################################################################################################################

    def ignore_pop_up():
        canvas_pop_up = TAB_DATA[CAL_IDX]["PopUp"]
        canvas_pop_up.unpost()
        cal = TAB_DATA[CAL_IDX]["Cal"]
        # cal._dbl_clicked = None
        cal.clear_dbl_click()
        cal.draw_canvas()

    def populate_pop_up_menu(pop_up_dat=None, override=False):

        canvas_pop_up = TAB_DATA[CAL_IDX]["PopUp"]
        t_dat = TAB_DATA[CAL_IDX]["PopUpDat"]
        if t_dat and not override:
            # already populated
            return
        if override:
            canvas_pop_up.delete(0, len(t_dat))
        print("Populating calendar #{}'s menu".format(CAL_IDX))
        pop_up_dat = [
            ("CMD", "Add 1 Day", add_day),
            ("CMD", "Subtract 1 Day", subtract_day),
            ("SEP", None, None),
            # ("CMD", "Expand", enlarge_tile),
            # ("CBN", "Apply to Entire Line", None),
            # ("RBN", "A", None),
            # ("RBN", "B", None)
        ] if pop_up_dat is None else pop_up_dat
        for code, lbl, cmd in pop_up_dat:
            if code == "SEP":
                canvas_pop_up.add_separator()
            elif code == "CBN":
                canvas_pop_up.add_checkbutton(label=lbl)
            elif code == "RBN":
                canvas_pop_up.add_radiobutton(label=lbl)
            else:
                canvas_pop_up.add_command(label=lbl, command=cmd)
        TAB_DATA[CAL_IDX]["PopUpDat"] = pop_up_dat
        canvas_pop_up.bind("<FocusOut>", ignore_pop_up)

    def wipe_pop_up_menu():
        canvas_pop_up = TAB_DATA[CAL_IDX]["PopUp"]
        canvas_pop_up.delete(0, 6)

    def add_day():
        cal = TAB_DATA[CAL_IDX]["Cal"]
        line = cal.tiles[cal._dbl_clicked].line
        for i in range(CAL_IDX, len(TAB_DATA)):
            cal = TAB_DATA[i]["Cal"]

            assert isinstance(cal, PSCalendar)

            print("Adjusting cal: {}".format(cal))
            row_idx = cal.lines.index(line)
            r, c = cal.rows, cal.cols
            left_most = row_idx * c
            cal._dbl_clicked = cal._dbl_clicked if i == CAL_IDX else left_most
            cal.add_day()

    def subtract_day():
        cal = TAB_DATA[CAL_IDX]["Cal"]
        line = cal.tiles[cal._dbl_clicked].line
        for i in range(CAL_IDX, -1, -1):
            cal = TAB_DATA[i]["Cal"]

            assert isinstance(cal, PSCalendar)

            print("Adjusting cal: {}".format(cal))
            row_idx = cal.lines.index(line)
            r, c = cal.rows, cal.cols
            right_most = ((row_idx + 1) * c) - 1
            print("right_most:", right_most, "rows:", cal.rows, "cols:", cal.cols)
            cal._dbl_clicked = cal._dbl_clicked if i == CAL_IDX else right_most
            cal.subtract_day()

    def enlarge_tile():
        cal = TAB_DATA[CAL_IDX]["Cal"]
        cal.enlarge_tile(cal._dbl_clicked)
    #     cal.hover()
        cal.draw_canvas()


    def draw_application():
        global btn_calendar_export_pdf_full, btn_calendar_export_pdf, dealer_colour_data, CAL_IDX

        frame_calendar_control = tkinter.Frame(WINDOW, height=200, border=1, borderwidth=2, bg=rgb_to_hex(TAN_1))
        frame_calendar_search_control = tkinter.Frame(frame_calendar_control)
        frame_calendar_search_entries = tkinter.Frame(frame_calendar_control)
        frame_calendar_control_btns = tkinter.Frame(frame_calendar_control)
        frame_calendar_control_btns_a = tkinter.Frame(frame_calendar_control_btns)
        frame_calendar_control_btns_b = tkinter.Frame(frame_calendar_control_btns)
        frame_calendar_search_control_a = tkinter.Frame(frame_calendar_search_entries)
        frame_calendar_search_control_b = tkinter.Frame(frame_calendar_search_entries)
        frame_calendar_search_control_c = tkinter.Frame(frame_calendar_search_control)
        btn_calendar_use_hover = tkinter.Button(frame_calendar_control_btns_a, text="Use Hover", command=switch_calendar_use_hover_gsm)
        btn_calendar_export_pdf_full = tkinter.Button(frame_calendar_control_btns_a, text="Export pdf (Full)")
        btn_calendar_export_pdf = tkinter.Button(frame_calendar_control_btns_a, text="Export pdf")
        btn_draw_week_dividers = tkinter.Button(frame_calendar_control_btns_b, text="Draw Week Dividers", command=switch_calendar_week_divs_gsm)

        stringvar_calendar_search_start_date = tkinter.StringVar(value=START_DATE.strftime("%Y-%m-%d"))
        stringvar_calendar_search_end_date = tkinter.StringVar(value=END_DATE.strftime("%Y-%m-%d"))
        label_calendar_search_start_date = tkinter.Label(frame_calendar_search_control_a, text="Start Date:")
        entry_calendar_search_start_date = tkinter.Entry(frame_calendar_search_control_a, textvariable=stringvar_calendar_search_start_date)
        label_calendar_search_end_date = tkinter.Label(frame_calendar_search_control_b, text="End Date:")
        entry_calendar_search_end_date = tkinter.Entry(frame_calendar_search_control_b, textvariable=stringvar_calendar_search_end_date)
        btn_calendar_search_submit = tkinter.Button(frame_calendar_search_control_c, text="Submit", command=submit_calendar_search)

        frame_dealer_colour_select = tkinter.Frame(frame_calendar_control)
        frame_dealer_colour_select_c1 = tkinter.Frame(frame_dealer_colour_select)
        frame_dealer_colour_select_c2 = tkinter.Frame(frame_dealer_colour_select)
        frame_dealer_colour_select_c3 = tkinter.Frame(frame_dealer_colour_select)
        label_dealer_colour_select = tkinter.Label(frame_dealer_colour_select, text="Highlight Dealers Below")
        btn_dealer_colour_1 = tkinter.Button(frame_dealer_colour_select_c1)
        combo_dealer_1 = ttk.Combobox(frame_dealer_colour_select_c1, textvariable=lb_dealer_1)
        btn_reset_dealer_1 = tkinter.Button(frame_dealer_colour_select_c1, text="Reset", command=reset_dealer_1)
        btn_dealer_colour_2 = tkinter.Button(frame_dealer_colour_select_c2)
        combo_dealer_2 = ttk.Combobox(frame_dealer_colour_select_c2, textvariable=lb_dealer_2)
        btn_reset_dealer_2 = tkinter.Button(frame_dealer_colour_select_c2, text="Reset", command=reset_dealer_2)
        btn_dealer_colour_3 = tkinter.Button(frame_dealer_colour_select_c3)
        combo_dealer_3 = ttk.Combobox(frame_dealer_colour_select_c3, textvariable=lb_dealer_3)
        btn_reset_dealer_3 = tkinter.Button(frame_dealer_colour_select_c3, text="Reset", command=reset_dealer_3)

        # Add widgets
        label_dealer_colour_select.pack()
        label_calendar_search_start_date.pack(side=tkinter.LEFT)
        entry_calendar_search_start_date.pack(side=tkinter.LEFT)
        label_calendar_search_end_date.pack(side=tkinter.LEFT)
        entry_calendar_search_end_date.pack(side=tkinter.LEFT)
        btn_calendar_search_submit.pack()
        btn_draw_week_dividers.pack()

        frame_dealer_colour_select.pack(side=tkinter.RIGHT)

        btn_dealer_colour_1.pack(fill="x")
        combo_dealer_1.pack()
        btn_reset_dealer_1.pack()
        frame_dealer_colour_select_c1.pack(side=tkinter.LEFT)

        btn_dealer_colour_2.pack(fill="x")
        combo_dealer_2.pack()
        btn_reset_dealer_2.pack()
        frame_dealer_colour_select_c2.pack(side=tkinter.LEFT)

        btn_dealer_colour_3.pack(fill="x")
        combo_dealer_3.pack()
        btn_reset_dealer_3.pack()
        frame_dealer_colour_select_c3.pack(side=tkinter.LEFT)

        frame_dealer_colour_select_c1.pack()
        frame_dealer_colour_select_c2.pack()
        frame_dealer_colour_select_c3.pack()
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
        frame_calendar_control_btns_a.pack(side=tkinter.LEFT)
        frame_calendar_control_btns_b.pack(side=tkinter.LEFT)

        # frame_calendar_control_btns.pack()
        # frame_calendar.pack()
        # submit_calendar_search()
        notebook_tab_control.pack(expand=1, fill="x")
        t_h = frame_calendar_control.winfo_screenheight()

        raise ValueError("dealer_colour_data needs to be initalized before calling WINDOW.update() in order for the tab_on_change listener to work properly. THis is the first update to the display since creating the objects.")

        WINDOW.update()
        print(f"1 HOW TALL IS \"frame_calendar_control\": {frame_calendar_control.winfo_height()} px")
        print(f"1 HOW TALL IS \"WINDOW\": {WINDOW.winfo_height()} px")
        print(f"1 HOW TALL IS \"TAB_CONTROL\": {notebook_tab_control.winfo_height()} px")
        print(f"2 HOW TALL IS \"frame_calendar_control\": {frame_calendar_control.winfo_reqheight()} px")
        print(f"2 HOW TALL IS \"WINDOW\": {WINDOW.winfo_reqheight()} px")
        print(f"2 HOW TALL IS \"TAB_CONTROL\": {notebook_tab_control.winfo_reqheight()} px")
        print(f"2 HOW WIDE IS \"TAB_CONTROL\": {notebook_tab_control.winfo_reqwidth()} px")
        print(f"Screen: {WINDOW.winfo_screenwidth()} x {WINDOW.winfo_screenheight()}")
        print(f"Screen: {F_WIN_W} x {F_WIN_H}")
        WINDOW.update()
        legend_height = TAB_DATA[CAL_IDX]["HeaderRow"].winfo_reqheight()
        height_diff = frame_calendar_control.winfo_reqheight() + notebook_tab_control.winfo_reqheight() - (F_WIN_H - 25)
        width_diff = notebook_tab_control.winfo_reqwidth() - (F_WIN_W - 0)

        if height_diff > 0 or width_diff > 0:
            if height_diff > 0:
                print(f"This application is too tall!! Needs to shrink by {height_diff}")
            if width_diff > 0:
                print(f"This application is too wide!! Needs to shrink by {width_diff}")
            # fract = 1 - (height_diff / notebook_tab_control.winfo_reqheight())
            for tab_name, tab in TAB_DATA.items():
                cal = tab["Cal"]
                title_lbl = tab["c_label_title"]
                lbl_height = title_lbl.winfo_reqheight()
                # legend canvases
                print("\t\tcal.canvas_header_col.height:", cal.canvas_header_col.winfo_reqheight())
                print("\t\tcal.canvas_header_col.height * fract:", cal.canvas_header_col.winfo_reqheight() - height_diff)
                cal.height = cal.canvas.winfo_reqheight() - (height_diff + lbl_height)
                cal.width = cal.canvas.winfo_reqwidth() - (width_diff)
                # cal.canvas.config(height=cal.canvas.winfo_reqheight() - (height_diff + lbl_height))
                # cal.canvas_header_col.config(height=cal.canvas_header_col.winfo_reqheight() - (height_diff + lbl_height))
                # cal.canvas_header_row.config(height=cal.canvas_header_row.winfo_reqheight() - height_diff)


        WINDOW.update()


        # raise ValueError("Stop here!")

        # populate_tab_data()
        if not TAB_DATA:
            print("Error No data to display.\nExiting the Program.")
            exit_program()
        # print(dict_print(TAB_DATA, "Tab Data"))
        print("CALS:\n\t" + "\n\t".join([str(v["Cal"]) for k, v in TAB_DATA.items()]))

        # Call once to initialize the first Calendar
        CAL_IDX = 0
        populate_pop_up_menu()
        TAB_DATA[CAL_IDX]["PopUpPop"] = True
        tab_name = TAB_NAMES[CAL_IDX]
        dealer_colour_data = [
            btn_dealer_colour_1,
            combo_dealer_1,
            btn_dealer_colour_2,
            combo_dealer_2,
            btn_dealer_colour_3,
            combo_dealer_3]

        cal = TAB_DATA[CAL_IDX]["Cal"]

    # for i, t in enumerate(cal.tiles):
    #     print(dict_print(t.info_dict(), "Tile: #{}".format(i)))

    # Do Splash Here
    def window_load(*args):
        global WIN_W, WIN_H
        WINDOW.unbind("<Visibility>")
        print("Window Load: {}".format(splash_pb["value"]))
        # splash_pb.start()
        if not LOADED.get():
            loop = asyncio.get_event_loop()
            loop.run_until_complete(populate_tab_data())
            loop.close()

        # Wipe WINDOW and draw application
        splash_label.pack_forget()
        splash_pb.pack_forget()
        splash_query_pb.pack_forget()
        splash_status_top.pack_forget()
        splash_status_bottom.pack_forget()
        splash_frame.pack_forget()
        splash_logo_bws.pack_forget()
        splash_logo_stargate.pack_forget()
        splash_frame_logos.pack_forget()
        splash_version.pack_forget()
        if N_TEST_CALS is not None:
            splash_test_indicator.forget()

        # resize WINDOW coming from splash screen
        WIN_W, WIN_H = F_WIN_W, F_WIN_H
        WINDOW.geometry("{}x{}".format(WIN_W, WIN_H))
        WINDOW.state('zoomed')

        draw_application()

    # if pb['value'] & lt; 100:
    #     pb['value'] += 20
    #     value_label['text'] = update_progress_label()
    # else:
    #     showinfo(message='The progress completed!')

    WINDOW.bind("<Visibility>", window_load)
    WINDOW.mainloop()
    exit_program()
