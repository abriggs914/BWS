import itertools

import pyodbc
import tkinter
import asyncio
import pandas as pd
from tkinter import ttk
from pathlib import Path
from PIL import ImageTk, Image
from datetime_utility import *
from pscalendar import PSCalendar2, CalendarTile2
from utility import Rect2, first_of_month, end_of_month, dict_print, random_date, tkinter_to_rect2, rect2_to_tkinter
from colour_utility import *


class PSCCalendarFrame(tkinter.Tk):

    def __init__(
            self,
            width_p,
            height_p,
            title_p,
            foreground_p=BLACK,
            background_p=WHITE,
            top_margin_p=0,
            bottom_margin_p=0,
            left_margin_p=0,
            right_margin_p=0,
            top_cal_margin_p=0,
            bottom_cal_margin_p=0,
            left_cal_margin_p=0,
            right_cal_margin_p=0,
            font_p=None,
            n_test_cals=None
    ):
        super().__init__()
        self._width = width_p
        self._height = height_p
        self._title_a = title_p
        self._foreground = foreground_p
        self._background = background_p
        self._top_margin = top_margin_p
        self._bottom_margin = bottom_margin_p
        self._left_margin = left_margin_p
        self._right_margin = right_margin_p
        self._top_cal_margin = top_cal_margin_p
        self._bottom_cal_margin = bottom_cal_margin_p
        self._left_cal_margin = left_cal_margin_p
        self._right_cal_margin = right_cal_margin_p
        self._font = font_p

        self.LOADED = tkinter.BooleanVar(value=False)
        self.lb_dealer_1 = tkinter.StringVar()
        self.lb_dealer_2 = tkinter.StringVar()
        self.lb_dealer_3 = tkinter.StringVar()

        # Splash menu vars:
        self.assert_is_employee = False
        self.splash_frame = None
        self.splash_frame_logos = None
        self.bws_logo = None
        self.splash_logo_bws = None
        self.stargate_logo = None
        self.LOGO_WIDTH = None
        self.LOGO_HEIGHT = None
        self.splash_logo_stargate = None
        self.splash_frame_pbs = None
        self.splash_label = None
        self.splash_status_top = None
        self.splash_status_bottom = None
        self.splash_pb = None
        self.splash_query_pb = None
        self.splash_test_indicator = None
        self.splash_version = None

        self.N_TEST_CALS = n_test_cals
        self.BWS_LOGO_FILE_PATH = r"""C:\Access\BWS Chrome Final WO Manufacturing.jpg"""
        self.STARGATE_LOGO_FILE_PATH = r"""C:\Access\Stargate Logo 50%.jpg"""
        self.SPLASH_BG = rgb_to_hex(GRAY_17)
        self.SPLASH_FG = rgb_to_hex(WHITE)
        self.SPLASH_LENGTH = 300
        self.VERSION_NAME = None
        self.LOGO_WIDTH = int((self._width * 0.8) / 2)
        self.LOGO_HEIGHT = int(self._height * 0.3)
        self.TILE_BORDER_WIDTH = 3

        self.HEADER_LEFT_WIDTH = 60
        self.HEADER_LEFT_HEIGHT = self.height + self.TILE_BORDER_WIDTH + 25
        self.HEADER_TOP_WIDTH = 10
        self.HEADER_TOP_HEIGHT = 25

        self.STYLES = {
            "DEFAULT": {
                "TILE_BACKGROUND_STAT": GRAY_17,
                "TILE_FOREGROUND_STAT": WHITE,
                "TILE_OUTLINE_STAT": WHITE,
                "TILE_FONT_STAT": ("Arial", 15),

                "TILE_BACKGROUND_DRAG": BWS_RED,
                "TILE_FOREGROUND_DRAG": WHITE,
                "TILE_OUTLINE_DRAG": WHITE,
                "TILE_FONT_DRAG": ("Arial", 17),

                "TILE_BACKGROUND_HOVER": GRAY_23,
                "TILE_FOREGROUND_HOVER": WHITE,
                "TILE_OUTLINE_HOVER": GRAY_23,
                "TILE_FONT_HOVER": ("Arial", 15),

                "TILE_BACKGROUND_SELECT": BWS_RED,
                "TILE_FOREGROUND_SELECT": BLACK,
                "TILE_OUTLINE_SELECT": BWS_RED,
                "TILE_FONT_SELECT": ("Arial", 17),

                "TILE_BACKGROUND_DBLC": BLACK,
                "TILE_FOREGROUND_DBLC": WHITE,
                "TILE_OUTLINE_DBLC": WHITE,
                "TILE_FONT_DBLC": ("Arial", 17),

                "WEEKEND_DIV": ORANGE_2
            }
        }

        if not Path(self.BWS_LOGO_FILE_PATH).exists():
            if not self.assert_is_employee:
                self.BWS_LOGO_FILE_PATH = r"""./BWS Chrome Final_hr.jpg"""
            else:
                print("You must be an employee to use this program.")
                self.exit_program()

        if not Path(self.STARGATE_LOGO_FILE_PATH).exists():
            if not self.assert_is_employee:
                self.STARGATE_LOGO_FILE_PATH = r"""./Stargate Logo 50%.jpg"""
            else:
                print("You must be an employee to use this program.")
                self.exit_program()

        # Vars specific to Production Scheduling:
        # TODO, these should be real values
        self.TAB_NAMES = ["Current Period", "+1 Month", "+2 Months", "+3 Months", "+4 Months", "+5 Months", "+6 Months"]
        self._calendar_index = 0

        # Tab_data - stores the loaded calendars

        # print(f"DIMS: w: <{self.width}>, h: <{self.height}>, TM: <{self.top_margin}>, BM: <{self.bottom_margin}>, LM: <{self.left_margin}>, RM: <{self.right_margin}>")
        # calculated values:
        self.notebook_tab_control = None
        # self.label_cal_title = None
        # self.frame_calendar = None
        # self.canvas_cal = None  # main drawing canvas
        # self.canvas_header_left = None  # left legend
        # self.can_header_top = None  # top legend
        # self.canvas_pop_up = None  # pop-up

        self.frame_calendar_control = None
        self.frame_calendar_search_control = None
        self.frame_calendar_search_entries = None
        self.frame_calendar_control_btns = None
        self.frame_calendar_control_btns_a = None
        self.frame_calendar_control_btns_b = None
        self.frame_calendar_search_control_a = None
        self.frame_calendar_search_control_b = None
        self.frame_calendar_search_control_c = None
        self.btn_calendar_use_hover = None
        self.btn_calendar_export_pdf_full = None
        self.btn_calendar_export_pdf = None
        self.btn_draw_week_dividers = None

        self.stringvar_calendar_search_start_date = None
        self.stringvar_calendar_search_end_date = None
        self.label_calendar_search_start_date = None
        self.entry_calendar_search_start_date = None
        self.label_calendar_search_end_date = None
        self.entry_calendar_search_end_date = None
        self.btn_calendar_search_submit = None

        self.frame_dealer_colour_select = None
        self.frame_dealer_colour_select_c1 = None
        self.frame_dealer_colour_select_c2 = None
        self.frame_dealer_colour_select_c3 = None
        self.label_dealer_colour_select = None
        self.btn_dealer_colour_1 = None
        self.combo_dealer_1 = None
        self.btn_reset_dealer_1 = None
        self.btn_dealer_colour_2 = None
        self.combo_dealer_2 = None
        self.btn_reset_dealer_2 = None
        self.btn_dealer_colour_3 = None
        self.combo_dealer_3 = None
        self.btn_reset_dealer_3 = None

        self.tab_data = []
        self.TAB_DATA = []
        self.TABS = []
        self.CAL_IDX = None

        self._drawing_bounds = self.calc_drawing_bounds()  # All drawings are bounded by this Rect.
        self._tile_bounds = self.calc_tile_bounds()
        self.init_tabs()
        # self.populate_tab_data()
        self.init_splash_menu()
        self.init_calendar_menu()
        self.update_title()
        self.update_geometry()

    def get_width(self):
        return self._width

    def get_height(self):
        return self._height

    def get_title_a(self):
        return self._title_a

    def get_foreground(self):
        return self._foreground

    def get_background(self):
        return self._background

    def get_top_margin(self):
        return self._top_margin

    def get_bottom_margin(self):
        return self._bottom_margin

    def get_left_margin(self):
        return self._left_margin

    def get_right_margin(self):
        return self._right_margin

    def get_top_cal_margin(self):
        return self._top_cal_margin

    def get_bottom_cal_margin(self):
        return self._bottom_cal_margin

    def get_left_cal_margin(self):
        return self._left_cal_margin

    def get_right_cal_margin(self):
        return self._right_cal_margin

    def get_font(self):
        return self._font

    def set_width(self, value):
        self._width = value
        self.update_geometry()

    def set_height(self, value):
        self._height = value
        self.update_geometry()

    def set_title_a(self, value):
        self._title_a = value

    def set_foreground(self, value):
        self._foreground = value

    def set_background(self, value):
        self._background = value

    def set_top_margin(self, value):
        self._top_margin = value

    def set_bottom_margin(self, value):
        self._bottom_margin = value

    def set_left_margin(self, value):
        self._left_margin = value

    def set_right_margin(self, value):
        self._right_margin = value

    def set_top_cal_margin(self, value):
        self._top_cal_margin = value

    def set_bottom_cal_margin(self, value):
        self._bottom_cal_margin = value

    def set_left_cal_margin(self, value):
        self._left_cal_margin = value

    def set_right_cal_margin(self, value):
        self._right_cal_margin = value

    def set_font(self, value):
        self._font = value

    def del_width(self):
        del self._width

    def del_height(self):
        del self._height

    def del_title_a(self):
        del self._title_a

    def del_foreground(self):
        del self._foreground

    def del_background(self):
        del self._background

    def del_top_margin(self):
        del self._top_margin

    def del_bottom_margin(self):
        del self._bottom_margin

    def del_left_margin(self):
        del self._left_margin

    def del_right_margin(self):
        del self._right_margin

    def del_top_cal_margin(self):
        del self._top_cal_margin

    def del_bottom_cal_margin(self):
        del self._bottom_cal_margin

    def del_left_cal_margin(self):
        del self._left_cal_margin

    def del_right_cal_margin(self):
        del self._right_cal_margin

    def del_font(self):
        del self._font

    def update_title(self):
        self.title(self.title_a)

    def update_geometry(self):
        self.geometry(f"{self.width}x{self.height}")
        self.update_sub_dims()

    def update_sub_dims(self):
        self._drawing_bounds = self.calc_drawing_bounds()
        self._tile_bounds = self.calc_tile_bounds()

    def calc_drawing_bounds(self):
        return Rect2(self.top_margin, self.right_margin, self.width - self.left_margin - self.right_margin,
                     self.height - self.top_margin - self.bottom_margin)

    def calc_tile_bounds(self):
        r = self._drawing_bounds
        return Rect2(r.left + self.left_cal_margin, r.top + self.top_cal_margin, r.width - self.left_cal_margin - self.right_cal_margin, r.height - self.top_cal_margin - self.bottom_cal_margin)

    def open(self, start_date, n_cals):
        self.TABS = self.TABS[:n_cals]
        self.do_splash(start_date, n_cals)
        self.set_full_screen()
        self.hide_splash()
        # psc = self.TAB_DATA[self.CAL_IDX]["Cal"]
        # canvas_cal =  self.TAB_DATA[self.CAL_IDX]["canvas_cal"]
        # self.canvas_header_left = self.TAB_DATA[self.CAL_IDX]["canvas_header_left"]  #{"canvas_pop_up": canvas_pop_up})
        # self.can_header_top = self.TAB_DATA[self.CAL_IDX]["can_header_top"]
        # self.frame_calendar = self.TAB_DATA[self.CAL_IDX]["frame_calendar"]
        # psc.draw_canvas(canvas, canvas_header_left, can_header_top)

        self.pack_calendar()
        self.draw_calendar()
        self.bind_calendar()
        self.mainloop()

    def set_full_screen(self):
        self.state('zoomed')

    def __repr__(self):
        return f"PSCalendarFrame, Name:\"{self.title}\""

    width = property(get_width, set_width, del_width, "Width of entire application")
    height = property(get_height, set_height, del_height, "Height of entire application")
    title_a = property(get_title_a, set_title_a, del_title_a, "Title of the Tkinter window")
    foreground = property(get_foreground, set_foreground, del_foreground, "Foreground colouring.")
    background = property(get_background, set_background, del_background, "Background colouring.")
    top_margin = property(get_top_margin, set_top_margin, del_top_margin, "Top margin")
    bottom_margin = property(get_bottom_margin, set_bottom_margin, del_bottom_margin, "Bottom margin")
    left_margin = property(get_left_margin, set_left_margin, del_left_margin, "Left margin")
    right_margin = property(get_right_margin, set_right_margin, del_right_margin, "Right margin")
    top_cal_margin = property(get_top_cal_margin, set_top_cal_margin, del_top_cal_margin, "Top margin to calendar")
    bottom_cal_margin = property(get_bottom_cal_margin, set_bottom_cal_margin, del_bottom_cal_margin, "Bottom margin to calendar")
    left_cal_margin = property(get_left_cal_margin, set_left_cal_margin, del_left_cal_margin, "Left margin to calendar")
    right_cal_margin = property(get_right_cal_margin, set_right_cal_margin, del_right_cal_margin, "Right margin to calendar")
    font = property(get_font, set_font, del_font, "Default font")

    def on_tab_change(self, event):
        print(f"On Tab Change! <{event}>")
        # tab_name = event.widget.tab('current')['text']
        # tab_name = self.notebook_tab_control.nametowidget(self.notebook_tab_control.select())
        selection = self.notebook_tab_control.select()
        # print(f"SELECTION A: <{selection}>")
        # print(f"SELECTION B: <{event.widget.select()}>")
        # print(f"WIDGET: {self.notebook_tab_control}")
        tab_name = self.notebook_tab_control.tab(selection, "text")
        # raise ValueError(f"WUT {tab_name}")
        idx = self.TAB_NAMES.index(tab_name)
        # cal = tab_cals[idx]
        cal = self.TAB_DATA[idx]["Cal"]
        self.CAL_IDX = idx
        print(f"changed to tab {self.CAL_IDX}")
        # self.canvas_cal =  self.TAB_DATA[self.CAL_IDX]["canvas_cal"]
        # self.canvas_header_left = self.TAB_DATA[self.CAL_IDX]["canvas_header_left"]  #{"canvas_pop_up": canvas_pop_up})
        # self.can_header_top = self.TAB_DATA[self.CAL_IDX]["can_header_top"]
        # self.frame_calendar = self.TAB_DATA[self.CAL_IDX]["frame_calendar"]
        self.draw_calendar()

        # TODO bind the new cal canvas
        self.bind_calendar()
        # TODO unbind the others

    def switch_calendar_use_hover_gsm(self, *events):
        print("Change use hover")

    def switch_calendar_week_divs_gsm(self, *events):
        print("show week dividers")

    def submit_calendar_search(self, *events):
        print("submit search")

    def reset_dealer_1(self, *events):
        print("reset_dealer_1")

    def reset_dealer_2(self, *events):
        print("reset_dealer_2")

    def reset_dealer_3(self, *events):
        print("reset_dealer_3")

    async def read_sql_async(self, stmt, con):
        '''
        Helper function to wrap pd.read_sql in an asynchronous call.
        :param stmt: SQL statement to be passed
        :param con: connection string
        :return: The query results in a Pandas Dataframe
        '''
        loop = asyncio.get_event_loop()
        return await loop.run_in_executor(None, pd.read_sql, stmt, con)

    async def get_production_data(self, start_date, end_date, first=True):
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
        assert isinstance(start_date,
                          datetime.datetime), "Start date param: \"{}\" must be a datetime.datetime object.".format(
            start_date)
        assert isinstance(end_date,
                          datetime.datetime), "End date param: \"{}\" must be a datetime.datetime object.".format(
            end_date)
        assert start_date <= end_date, "Start date param: \"{}\" must be before End date param \"{}\".".format(
            start_date, end_date)
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
        today = datetime.datetime.now()
        dates = [random_date(start_year=today.year, end_year=today.year + 1, start_m=today.month, start_d=today.day) for i in range(15)]
        ordered_df = pd.DataFrame()
        try:
            # Use this as an entry point for test sets
            with open("df1.json", "r") as f:
                ordered_df = pd.read_json(f)
                dates = ordered_df.drop_duplicates('Prod Date')
                # print("LIST:", dates['Prod Date'].tolist())
                # print("LIST[0]:", dates['Prod Date'].tolist()[0])
                # print("type(LIST[0]:)", type(dates['Prod Date'].tolist()[0]))
                dates = [pd.to_datetime(str(dtm), unit='ms') for dtm in dates['Prod Date'].tolist()]
                dates.sort()
        except FileNotFoundError:
            print("File not found.")
        try:
            query = "EXEC [sp_ProductionSchedule V4_Slots] \'{sd}\', \'{ed}\';".format(sd=start_date, ed=end_date)
            self.splash_query_pb["value"] = 46
            self.splash_query_pb.update()
            cnxn = pyodbc.connect('DRIVER={SQL Server};SERVER=server3;DATABASE=BWSdb;UID=user5;PWD=M@gic456',
                                  timeout=10)
            self.splash_query_pb["value"] = 56
            self.splash_query_pb.update()
            table_result = await self.read_sql_async(query, cnxn)
            self.splash_query_pb["value"] = 77
            self.splash_query_pb.update()
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
            # print("columns:", df1.columns)

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
                lines, dates, ordered_df = await self.get_production_data(start_date, end_date, first=False)
            else:
                print("Deadlock error. Please try again later.")
        except pyodbc.OperationalError:
            print("[08001] [Microsoft][ODBC SQL Server Driver][DBNETLIB]SQL Server does not exist or access denied.")
            print("Using default values")

        return lines, dates, ordered_df
        # return df

    async def populate_tab_data(self, month_ranges):
        # global TABS, TAB_NAMES, TAB_DATA, LOADED

        # last_date = cal.end_date
        # last_date = START_DATE
        n = max(len(self.TABS), self.N_TEST_CALS if self.N_TEST_CALS is not None else len(self.TABS))
        # print(f"LT: {len(self.TABS)}, self.N_TEST_CALS: {self.N_TEST_CALS}")
        # print(f"len(MR): {len(month_ranges)}")
        for i, tab in enumerate(self.TABS):
            last_date, c_end_date = month_ranges[i]
            self.splash_query_pb["value"] = 0
            self.splash_query_pb.update()
            c_frame_calendar = tkinter.Frame(tab)
            self.splash_query_pb["value"] = 25
            self.splash_query_pb.update()

            # last_date = last_date + datetime.timedelta(days=1)
            # c_end_date = last_date + datetime.timedelta(days=31)
            fmt = "%Y-%m-%d"
            self.splash_status_top.config(text="Generating Schedule From {start} To {end}".format(start=last_date.strftime(fmt), end=c_end_date.strftime(fmt)))
            self.splash_query_pb["value"] = 35
            self.splash_query_pb.update()
            c_lines, c_dates, dat = await self.get_data(last_date, c_end_date)
            self.splash_query_pb["value"] = 85
            self.splash_query_pb.update()
            # print("last_date: {}: {}, c_end_date: {}: {}".format(type(last_date), last_date, type(c_end_date), c_end_date))
            # print("c_dates", c_dates)
            psc = self.create_calendar_p(last_date, c_end_date, dat, c_lines, c_dates)
            c_label_title = tkinter.Label(tab, text="Production Schedule\n{} - {}".format(
                datetime.datetime.strftime(last_date, "%Y-%m-%d"), datetime.datetime.strftime(c_end_date, "%Y-%m-%d")))
            # tab_cals.append(psc)

            t_dat = self.TAB_DATA[i]
            t_dat.update({
                "Name": self.TAB_NAMES[i],
                "Tab": tab,
                "Lines": c_lines,
                "Dates": c_dates,
                "Data": dat,
                "Cal": psc,
                "c_label_title": c_label_title
            })

            # last_date += relativedelta(month=1)
            p = 1 / n
            # print("p: {}, i: {}, n: {}, x: {}".format(p, i, n, p * 100))
            self.splash_pb.step(p * 100)
            self.splash_status_bottom.config(text="{} % Complete".format(round(self.splash_pb["value"], 2)))
            self.splash_query_pb["value"] = 100
            self.splash_query_pb.update()
            self.update()
            # if i >= N_TEST_CALS:
            #     break

        # TABS = TABS if len(TABS) <= N_TEST_CALS else TABS[:N_TEST_CALS]
        # TAB_NAMES = TAB_NAMES if len(TAB_NAMES) <= N_TEST_CALS else TAB_NAMES[:N_TEST_CALS]

        # label_title = tkinter.Label(tab_1, text="Production Schedule\n{} - {}".format(dt.datetime.strftime(START_DATE, "%Y-%m-%d"), dt.datetime.strftime(END_DATE, "%Y-%m-%d")))

        for tab, tab_name in zip(self.TABS, self.TAB_NAMES):
            self.notebook_tab_control.add(tab, text=tab_name)
        self.LOADED.set(True)
        try:
            print(dict_print(self.TAB_DATA, "TAB_DATA POPULATED"))
        except IndexError:
            print("for running at home")

    def create_calendar_p(self, start_date, end_date, data, lines, dates, style_in=None):
        # canvas_a.delete("all")
        if style_in is None:
            style = self.STYLES["DEFAULT"]
        else:
            style = style_in
        colour_tile = style["TILE_BACKGROUND_STAT"]
        colour_border = style["TILE_OUTLINE_STAT"]
        colour_font = style["TILE_FOREGROUND_STAT"]
        colour_selected = style["TILE_BACKGROUND_SELECT"]
        colour_hovered = style["TILE_BACKGROUND_HOVER"]
        colour_dragging = style["TILE_BACKGROUND_DRAG"]
        colour_weekend_div = style["WEEKEND_DIV"]
        switch_week_divs = True
        return PSCalendar2(start_date, end_date, data, lines, dates, colour_tile=colour_tile, colour_border=colour_border, colour_font=colour_font, colour_selected=colour_selected, colour_hovered=colour_hovered, colour_dragging=colour_dragging, border_width=2, switch_week_divs=switch_week_divs, colour_weekend_div=colour_weekend_div)

    async def get_data(self, start_date, end_date):
        lines, dates, data = await self.get_production_data(start_date, end_date)
        #
        # print("lines:\n\n", lines)
        # print("dates:\n\n", dates)
        # print("data:\n\n", data)
        # print("length:", data.size)
        return lines, dates, data

    def exit_program(self):
        '''
        Function called to quit the application.
        :return: None
        '''
        # if WINDOW is not None and isinstance(WINDOW, tkinter.Tk):
        # TODO THIS FAILS IF YOU CLICK 'X' FIRST.
        # WINDOW.destroy()
        print("Goodbye!")
        exit()

    # Called at beginning to instantiate the Tab frames
    def init_tabs(self):
        # List of tabs as tkinter frames
        self.notebook_tab_control = ttk.Notebook(self)
        self.TABS = [
            ttk.Frame(self.notebook_tab_control),
            ttk.Frame(self.notebook_tab_control),
            ttk.Frame(self.notebook_tab_control),
            ttk.Frame(self.notebook_tab_control),
            ttk.Frame(self.notebook_tab_control),
            ttk.Frame(self.notebook_tab_control),
            ttk.Frame(self.notebook_tab_control)
        ]
        self.CAL_IDX = 0

        # Zipping Tab frames and names. Prepping for Navigation Tabs
        # Capping # TABS and queries based on N_TEST_CALS
        if self.N_TEST_CALS is not None:
            self.TABS = self.TABS if len(self.TABS) <= self.N_TEST_CALS else self.TABS[:self.N_TEST_CALS]
            self.TAB_NAMES = self.TAB_NAMES if len(self.TAB_NAMES) <= self.N_TEST_CALS else self.TAB_NAMES[
                                                                                            :self.N_TEST_CALS]
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
        self.TAB_DATA = dict(zip([i for i in range(len(self.TABS))], [dict(empty_data) for _ in range(len(self.TAB_NAMES))]))
        for i in range(len(self.TAB_DATA)):
            self.TAB_DATA[i]["Tab"] = self.TABS[i]
        print(dict_print(self.TAB_DATA, "TAB_DATA"))

    def init_splash_menu(self):
        self.splash_frame = tkinter.Frame(self, bg=self.SPLASH_BG)
        self.splash_frame_logos = tkinter.Frame(self.splash_frame, bg=self.SPLASH_BG)
        self.bws_logo = ImageTk.PhotoImage(Image.open(self.BWS_LOGO_FILE_PATH).resize((self.LOGO_WIDTH, self.LOGO_HEIGHT)))
        self.splash_logo_bws = tkinter.Label(self.splash_frame_logos, image=self.bws_logo)
        self.stargate_logo = ImageTk.PhotoImage(Image.open(self.STARGATE_LOGO_FILE_PATH).resize((self.LOGO_WIDTH, self.LOGO_HEIGHT)))
        self.splash_logo_stargate = tkinter.Label(self.splash_frame_logos, image=self.stargate_logo)

        self.splash_frame_pbs = tkinter.Frame(self.splash_frame, bg=self.SPLASH_BG)
        self.splash_label = tkinter.Label(self.splash_frame_pbs, text=self.title_a, bg=self.SPLASH_BG, fg=self.SPLASH_FG,
                                     font=("Arial", 16, "bold"))
        self.splash_status_top = tkinter.Label(self.splash_frame_pbs, text="Generating Schedule From {start} To {end}",
                                          bg=self.SPLASH_BG, fg=self.SPLASH_FG)
        self.splash_status_bottom = tkinter.Label(self.splash_frame_pbs, text="0 % Complete", bg=self.SPLASH_BG, fg=self.SPLASH_FG)
        self.splash_pb = ttk.Progressbar(
            self.splash_frame_pbs,
            orient='horizontal',
            mode='determinate',
            length=self.SPLASH_LENGTH
        )
        self.splash_query_pb = ttk.Progressbar(
            self.splash_frame_pbs,
            orient="horizontal",
            mode="determinate",
            length=self.SPLASH_LENGTH
        )
        self.splash_test_indicator = tkinter.Label(self.splash_frame, text="Testing {} calendar{}".format(self.N_TEST_CALS,
                                                                                                "s" if self.N_TEST_CALS != 1 else ""),
                                              bg=rgb_to_hex(brighten(hex_to_rgb(self.SPLASH_BG), 0.25)),
                                              fg=rgb_to_hex(RED_3), font=("Arial", 16))
        self.splash_version = tkinter.Label(self.splash_frame, text=self.VERSION_NAME, bg=self.SPLASH_BG, fg=self.SPLASH_FG)
        self.pack_splash()

    def init_calendar_menu(self):
        self.HEADER_TOP_WIDTH = self.width
        for i, tab in enumerate(self.TABS):
            label_cal_title = tkinter.Label(tab, text="Production Schedule" + str(i) + "\n{} - {}")
            #.format(dt.datetime.strftime(last_date, "%Y-%m-%d"), dt.datetime.strftime(c_end_date, "%Y-%m-%d")))
            frame_calendar = tkinter.Frame(tab)
            canvas_cal = tkinter.Canvas(frame_calendar, height=self._tile_bounds.height, width=self._tile_bounds.width, bg=rgb_to_hex(GRAY_12))
            # canvas_header_left = tkinter.Canvas(frame_calendar, height=self._tile_bounds.height + self.TILE_BORDER_WIDTH, width=60, bg=rgb_to_hex(INDIGO))  # left legend
            # can_header_top = tkinter.Canvas(frame_calendar, height=25, width=self._tile_bounds.height + 60 + self.TILE_BORDER_WIDTH, bg=rgb_to_hex(BLACK))  # top legend
            canvas_header_left = tkinter.Canvas(frame_calendar, height=self.HEADER_LEFT_HEIGHT, width=self.HEADER_LEFT_WIDTH, bg=rgb_to_hex(BLACK))  # left legend
            can_header_top = tkinter.Canvas(frame_calendar, height=self.HEADER_TOP_HEIGHT, width=self.HEADER_TOP_WIDTH, bg=rgb_to_hex(BLACK))  # top legend
            canvas_pop_up = tkinter.Menu(frame_calendar, tearoff=0)
            self.TAB_DATA[i].update({"Name": self.TAB_NAMES[i], "frame_calendar": frame_calendar, "canvas_cal": canvas_cal, "canvas_header_left": canvas_header_left, "canvas_header_top": can_header_top, "canvas_pop_up": canvas_pop_up})

        self.frame_calendar_control = tkinter.Frame(self, height=200, border=1, borderwidth=2, bg=rgb_to_hex(TAN_1))
        self.frame_calendar_search_control = tkinter.Frame(self.frame_calendar_control)
        self.frame_calendar_search_entries = tkinter.Frame(self.frame_calendar_control)
        self.frame_calendar_control_btns = tkinter.Frame(self.frame_calendar_control)
        self.frame_calendar_control_btns_a = tkinter.Frame(self.frame_calendar_control_btns)
        self.frame_calendar_control_btns_b = tkinter.Frame(self.frame_calendar_control_btns)
        self.frame_calendar_search_control_a = tkinter.Frame(self.frame_calendar_search_entries)
        self.frame_calendar_search_control_b = tkinter.Frame(self.frame_calendar_search_entries)
        self.frame_calendar_search_control_c = tkinter.Frame(self.frame_calendar_search_control)
        self.btn_calendar_use_hover = tkinter.Button(self.frame_calendar_control_btns_a, text="Use Hover",
                                                command=self.switch_calendar_use_hover_gsm)
        self.btn_calendar_export_pdf_full = tkinter.Button(self.frame_calendar_control_btns_a, text="Export pdf (Full)")
        self.btn_calendar_export_pdf = tkinter.Button(self.frame_calendar_control_btns_a, text="Export pdf")
        self.btn_draw_week_dividers = tkinter.Button(self.frame_calendar_control_btns_b, text="Draw Week Dividers",
                                                command=self.switch_calendar_week_divs_gsm)

        self.stringvar_calendar_search_start_date = tkinter.StringVar(value="START_DATE.strftime(\"%Y-%m-%d\")")
        self.stringvar_calendar_search_end_date = tkinter.StringVar(value="END_DATE.strftime(\"%Y-%m-%d\")")
        self.label_calendar_search_start_date = tkinter.Label(self.frame_calendar_search_control_a, text="Start Date:")
        self.entry_calendar_search_start_date = tkinter.Entry(self.frame_calendar_search_control_a,
                                                         textvariable=self.stringvar_calendar_search_start_date)
        self.label_calendar_search_end_date = tkinter.Label(self.frame_calendar_search_control_b, text="End Date:")
        self.entry_calendar_search_end_date = tkinter.Entry(self.frame_calendar_search_control_b,
                                                       textvariable=self.stringvar_calendar_search_end_date)
        self.btn_calendar_search_submit = tkinter.Button(self.frame_calendar_search_control_c, text="Submit",
                                                    command=self.submit_calendar_search)

        self.frame_dealer_colour_select = tkinter.Frame(self.frame_calendar_control)
        self.frame_dealer_colour_select_c1 = tkinter.Frame(self.frame_dealer_colour_select)
        self.frame_dealer_colour_select_c2 = tkinter.Frame(self.frame_dealer_colour_select)
        self.frame_dealer_colour_select_c3 = tkinter.Frame(self.frame_dealer_colour_select)
        self.label_dealer_colour_select = tkinter.Label(self.frame_dealer_colour_select, text="Highlight Dealers Below")
        self.btn_dealer_colour_1 = tkinter.Button(self.frame_dealer_colour_select_c1)
        self.combo_dealer_1 = ttk.Combobox(self.frame_dealer_colour_select_c1, textvariable=self.lb_dealer_1)
        self.btn_reset_dealer_1 = tkinter.Button(self.frame_dealer_colour_select_c1, text="Reset", command=self.reset_dealer_1)
        self.btn_dealer_colour_2 = tkinter.Button(self.frame_dealer_colour_select_c2)
        self.combo_dealer_2 = ttk.Combobox(self.frame_dealer_colour_select_c2, textvariable=self.lb_dealer_2)
        self.btn_reset_dealer_2 = tkinter.Button(self.frame_dealer_colour_select_c2, text="Reset", command=self.reset_dealer_2)
        self.btn_dealer_colour_3 = tkinter.Button(self.frame_dealer_colour_select_c3)
        self.combo_dealer_3 = ttk.Combobox(self.frame_dealer_colour_select_c3, textvariable=self.lb_dealer_3)
        self.btn_reset_dealer_3 = tkinter.Button(self.frame_dealer_colour_select_c3, text="Reset", command=self.reset_dealer_3)

    def pack_splash(self):
        self.splash_logo_bws.pack(side=tkinter.LEFT, padx=10, pady=20)
        self.splash_logo_stargate.pack(side=tkinter.RIGHT, padx=10, pady=20)
        self.splash_frame_logos.pack(side=tkinter.TOP)

        self.splash_label.pack(pady=5)  # title
        self.splash_status_top.pack(anchor=tkinter.W)  # individual schedule progress text
        self.splash_query_pb.pack(pady=5)  # individual schedule progress bar
        self.splash_status_bottom.pack(anchor=tkinter.W)  # overall loading progress text
        self.splash_pb.pack(pady=5)  # overall loading progress bar
        self.splash_version.pack(side=tkinter.BOTTOM, anchor=tkinter.SW)
        self.splash_frame_pbs.pack(side=tkinter.BOTTOM, pady=60)  # progress texts and bars go below logos
        if self.N_TEST_CALS is not None:
            self.splash_test_indicator.pack()
        self.splash_frame.pack(expand=True, fill=tkinter.BOTH)

    def pack_calendar(self):
        # self.label_cal_title.pack()
        # self.can_header_top.pack()
        # self.canvas_header_left.pack(side=tkinter.LEFT)
        # self.canvas_cal.pack()
        # self.frame_calendar.pack()

        # Add widgets
        self.label_dealer_colour_select.pack()
        self.label_calendar_search_start_date.pack(side=tkinter.LEFT)
        self.entry_calendar_search_start_date.pack(side=tkinter.LEFT)
        self.label_calendar_search_end_date.pack(side=tkinter.LEFT)
        self.entry_calendar_search_end_date.pack(side=tkinter.LEFT)
        self.btn_calendar_search_submit.pack()
        self.btn_draw_week_dividers.pack()

        self.frame_dealer_colour_select.pack(side=tkinter.RIGHT)

        self.btn_dealer_colour_1.pack(fill="x")
        self.combo_dealer_1.pack()
        self.btn_reset_dealer_1.pack()
        self.frame_dealer_colour_select_c1.pack(side=tkinter.LEFT)

        self.btn_dealer_colour_2.pack(fill="x")
        self.combo_dealer_2.pack()
        self.btn_reset_dealer_2.pack()
        self.frame_dealer_colour_select_c2.pack(side=tkinter.LEFT)

        self.btn_dealer_colour_3.pack(fill="x")
        self.combo_dealer_3.pack()
        self.btn_reset_dealer_3.pack()
        self.frame_dealer_colour_select_c3.pack(side=tkinter.LEFT)

        self.frame_dealer_colour_select_c1.pack()
        self.frame_dealer_colour_select_c2.pack()
        self.frame_dealer_colour_select_c3.pack()
        # label_title.pack()
        # canvas_header_row.pack()
        # canvas_header_col.pack(side=tkinter.LEFT)
        # canvas.pack()
        self.frame_calendar_search_control_a.pack()
        self.frame_calendar_search_control_b.pack()
        self.frame_calendar_search_entries.pack(side=tkinter.LEFT)
        # frame_calendar_search_entries.pack()
        self.frame_calendar_search_control_c.pack(side=tkinter.LEFT)
        # frame_calendar_search_control_c.pack()
        self.frame_calendar_search_control.pack(side=tkinter.LEFT)
        # frame_calendar_control.pack(side=tkinter.LEFT)
        self.frame_calendar_control.pack()
        self.btn_calendar_use_hover.pack()
        self.btn_calendar_export_pdf_full.pack()
        self.btn_calendar_export_pdf.pack()
        self.frame_calendar_control_btns.pack(side=tkinter.LEFT)
        self.frame_calendar_control_btns_a.pack(side=tkinter.LEFT)
        self.frame_calendar_control_btns_b.pack(side=tkinter.LEFT)

        # frame_calendar_control_btns.pack()
        # frame_calendar.pack()
        # submit_calendar_search()
        for i in range(len(self.TAB_DATA)):
        #     # self.TAB_DATA[i]["Tab"].pack()
            self.TAB_DATA[i]["frame_calendar"].pack()
            self.TAB_DATA[i]["canvas_header_left"].pack(side=tkinter.LEFT)  # {"canvas_pop_up": canvas_pop_up})
            self.TAB_DATA[i]["canvas_header_top"].pack()
            self.TAB_DATA[i]["canvas_cal"].pack()
        self.notebook_tab_control.pack(expand=1, fill="x")

    def hide_splash(self):
        self.splash_label.pack_forget()
        self.splash_pb.pack_forget()
        self.splash_query_pb.pack_forget()
        self.splash_status_top.pack_forget()
        self.splash_status_bottom.pack_forget()
        self.splash_frame.pack_forget()
        self.splash_logo_bws.pack_forget()
        self.splash_logo_stargate.pack_forget()
        self.splash_frame_logos.pack_forget()
        self.splash_version.pack_forget()
        if self.N_TEST_CALS is not None:
            self.splash_test_indicator.forget()

    def do_splash(self, start_date=first_of_month(datetime.datetime.now()), months_ahead=8):
        if self.N_TEST_CALS is not None:
            print(f"Overriding months_ahead ({months_ahead}) with N_TEST_CALS: ({self.N_TEST_CALS})")
            months_ahead = self.N_TEST_CALS
        month_ranges = []
        print("MONTHS:", months_ahead)
        td = datetime2(start_date.year, start_date.month, start_date.day, start_date.hour, start_date.minute, start_date.second)
        for mi in range(months_ahead):
            month_ranges.append((first_of_month(td), end_of_month(td)))
            td = td.add_month()
        print("LENGTH MR:", len(month_ranges))
        loop = asyncio.get_event_loop()
        loop.run_until_complete(asyncio.gather(*(self.populate_tab_data(month_ranges) for i in range(1))))
        loop.close()

    def draw_calendar(self):
        print(f"drawing calendar at tab {self.CAL_IDX}, CAL: {self.TAB_DATA[self.CAL_IDX]['Cal']}")

        # def draw_canvas(calendar, canvas, canvas_header_row, canvas_header_col):
        #     canvas.delete("all")
        #
        #     # print("DC\t\t\tdragging: {}, _selected: {}, _hover_select: {}, _current_hover: {}, _dbl_clicked: {}".format(
        #     #     self._dragging, self._selected, self._hover_select, self._current_hover, self._dbl_clicked))
        #
        #     # if self._current_hover is not None:
        #     #     print(self.tiles_to_the_right(self._current_hover))
        #     #     print(self.tiles_to_the_left(self._current_hover, start_date=datetime.datetime(2021, 10, 8), end_date=datetime.datetime(2021, 10, 12)))
        #
        #     # TODO here
        #     # if a tile is _selected then highlight any tiles with matching WO
        #     same_top_level_wos = []
        #     same_dealers = []
        #     same_dealers_n = []
        #     same_dealers_stock = []
        #     colour_override = False
        #     outline_override = False
        #     # if self._selected is not None:
        #     #     wo_1 = self.tiles[self._selected].wo_num
        #     #     for tile in self.tiles:
        #     #         tile_num = self.r_c_to_i(tile.row, tile.col)
        #     #         wo_2 = tile.wo_num
        #     #         if wo_1 is not None and wo_1 == wo_2:
        #     #             same_top_level_wos.append(tile_num)
        #     #
        #     # if self.always_highlight_dealers or self._selected is not None:
        #     #     for tile in self.tiles:
        #     #         tile_num = self.r_c_to_i(tile.row, tile.col)
        #     #         for dcc in self.dealer_highlights:
        #     #             if dcc is not None:
        #     #                 d_name, colour_code, stock_colour = dcc
        #     #                 if tile.dealer == d_name:
        #     #                     # print("\t\td_name:", d_name, "colour_code:", colour_code)
        #     #                     same_dealers.append(colour_code)
        #     #                     same_dealers_stock.append(stock_colour)
        #     #                     same_dealers_n.append(tile_num)
        #     #     # print("same_top_level_wos as <{}>".format(self._selected), same_top_level_wos)
        #     #     # print("same_dealers as <{}>".format(self._selected), same_dealers)
        #     #     # print("same_dealers_n as <{}>".format(self._selected), same_dealers_n)
        #
        #     # loop and draw tiles list
        #     for i, tile in enumerate(calendar.tiles):
        #         # show_txt = not self.hiding_non_selected_tiles # TODO
        #         show_txt = False
        #         # print("tile.rect.tupl:", tile.rect)
        #         # bgc = tile.colour # TODO
        #         bgc = GRAY_15
        #         # r, c = tile.row, tile.col # TODO
        #         r, c = tile.i, tile.j
        #         tile_num = calendar.r_c_to_i(r, c)
        #         if sum(bgc) < 300:
        #             fgc = WHITE
        #             if tile_num in [calendar._dragging, calendar._selected, calendar._hover_select,
        #                             calendar._dbl_clicked]:
        #                 outline = WHITE
        #                 if tile_num == calendar._current_hover:
        #                     show_txt = True
        #                 outline_override = True
        #             else:
        #                 outline = bgc
        #         else:
        #             fgc = BLACK
        #             if tile_num in [calendar._dragging, calendar._selected, calendar._hover_select,
        #                             calendar._dbl_clicked]:
        #                 outline = GRAY_15
        #                 if tile_num == calendar._hover_select:
        #                     show_txt = True
        #                 outline_override = True
        #             else:
        #                 outline = bgc
        #
        #         # Custom colour behaviour
        #
        #         # Highlight all other tiles that have a WO matching the _selected tile
        #         if same_top_level_wos:
        #             if tile_num in same_top_level_wos and tile_num != calendar._selected:
        #                 outline = BWS_RED
        #                 outline_override = True
        #
        #         # Highlight all other tiles that have the same dealer as the _selected.
        #         if same_dealers:
        #             if tile_num in same_dealers_n and tile_num != calendar._selected:
        #                 idx = same_dealers_n.index(tile_num)
        #                 outline = hex_to_rgb(same_dealers[idx])
        #                 bgc = hex_to_rgb(same_dealers_stock[idx])
        #                 outline_override = True
        #
        #         # Outline for _selected tiles while the cursor hovers should be darker than the original outline
        #         if (calendar._selected and calendar._current_hover) and (
        #                 calendar._selected != calendar._current_hover) and tile_num == calendar._selected:
        #             bgc = BWS_RED
        #             outline = darken(outline, 0.4)
        #             colour_override = True
        #             outline_override = True
        #
        #         # When Swapping tiles colour them differently
        #         if calendar._swap_pair and tile_num in calendar._swap_pair:
        #             bgc = BWS_RED
        #             outline = GRAY_26
        #             colour_override = True
        #             outline_override = True
        #
        #         # if not colour_override:
        #         #     bgc = calendar.DEFAULT_TILE_COLOUR_1
        #         # if not outline_override:
        #         #     outline = calendar.DEFAULT_TILE_COLOUR_1
        #         bgc = calendar.tiles[i].colour
        #         bgc = random_colour()
        #         outline = calendar.tiles[i].colour_border
        #
        #         tile_txt = tile.text if tile.text is not None else tile_num
        #         # drawing tile rectangle here
        #         rect = Rect2(0, 0, self.width, self.height)
        #         tile_rect = calendar.get_rect(i, rect)
        #         # tile_rect = tile_rect.tkinter_rect()
        #         print(f"TileRect: <{tile_rect}>")
        #         canvas.create_rectangle(list(tile_rect.tkinter_rect())[:4], fill=rgb_to_hex(bgc), outline=rgb_to_hex(outline),
        #                                 width=calendar.border_width)
        #         tile.colour = bgc
        #         # print("tile_num: {}\ntile_txt: {}".format(tile_num, tile_txt))
        #         if show_txt:
        #             if not calendar.is_tile_enlarged(tile_num):
        #                 # Not using hover zoom, can only display the WO text while hovering.
        #                 wo_num = tile.wo_num if tile.wo_num is not None else ""
        #                 tile_txt = "<{}>".format(wo_num)
        #             if tile_txt:
        #                 #
        #                 can_txt = canvas.create_text(tile_rect.x + ((tile_rect.w - tile_rect.x) / 2),
        #                                              tile_rect.y + ((tile_rect.h - tile_rect.y) / 2),
        #                                              fill=rgb_to_hex(fgc),
        #                                              font="Times 12 italic bold", text=str(tile_txt))
        #                 bounds = canvas.bbox(can_txt)
        #                 can_t_w = bounds[2] - bounds[0]
        #                 if can_t_w > (tile.rect[2] - tile.rect[0]):
        #                     canvas.delete(can_txt)
        #                     wo_num = tile.wo_num if tile.wo_num is not None else ""
        #                     tile_txt = "<{}>".format(str(wo_num)[-4:])
        #                     can_txt = canvas.create_text(tile_rect.x + ((tile_rect.w - tile_rect.x) / 2),
        #                                                 tile_rect.y + ((tile_rect.h - tile_rect.y) / 2),
        #                                                  fill=rgb_to_hex(fgc),
        #                                                  font="Times 12 italic bold", text=str(tile_txt))
        #
        #         else:
        #             # raise ValueError("HEY")
        #             tile_num = "" if tile.wo_num is None else tile.wo_num
        #             can_txt = canvas.create_text(tile_rect.x + ((tile_rect.w - tile_rect.x) / 2),
        #                                              tile_rect.y + ((tile_rect.h - tile_rect.y) / 2),
        #                                          fill=rgb_to_hex(fgc),
        #                                          font="Times 12 italic bold", text=str(tile_num))
        #             bounds = canvas.bbox(can_txt)
        #             can_t_w = bounds[2] - bounds[0]
        #             if can_t_w > (tile_rect.w - tile_rect.x):
        #                 canvas.delete(can_txt)
        #                 wo_num = tile.wo_num if tile.wo_num is not None else ""
        #                 tile_num = str(wo_num)[-4:]
        #                 can_txt = canvas.create_text(tile_rect.x + ((tile_rect.w - tile_rect.x) / 2),
        #                                              tile_rect.y + ((tile_rect.h - tile_rect.y) / 2),
        #                                              fill=rgb_to_hex(fgc),
        #                                              font="Times 12 italic bold", text=str(tile_num))
        #
        #         # By default plot weekend divider to the Right
        #         if calendar.switch_week_divs:
        #             date = tile.date
        #             tomorrow = None if i == len(calendar.tiles) - 1 else calendar.tiles[i + 1].date
        #             diff = None if tomorrow is None else tomorrow - date
        #             # print("date: {}, tomorrow: {}, diff: {}".format(date, tomorrow, diff))
        #             weekend_rect = None
        #             is_monday = date.weekday() == 0  # Monday is 0
        #             if i == 0 and is_monday:
        #                 weekend_rect = (0, 0, calendar.border_width, calendar.height)
        #             elif tomorrow is not None and diff.days > 2:
        #                 weekend_rect = (tile_rect.w, tile_rect.y, tile_rect.w + calendar.border_width, tile_rect.h)
        #
        #             if weekend_rect is not None:
        #                 colour = rgb_to_hex(calendar.weekend_div_colour)
        #                 canvas.create_rectangle(*weekend_rect, fill=colour, outline=colour, width=calendar.border_width)
        #
        #     # self.redraw_legend(canvas_header_row, canvas_header_col)

        cal = self.TAB_DATA[self.CAL_IDX]["Cal"]
        cbw = cal.border_width
        canvas = self.TAB_DATA[self.CAL_IDX]["canvas_cal"]
        canvas_header_top = self.TAB_DATA[self.CAL_IDX]["canvas_header_top"]
        canvas_header_left = self.TAB_DATA[self.CAL_IDX]["canvas_header_left"]
        canvas_header_left = self.TAB_DATA[self.CAL_IDX]["canvas_header_left"]
        canvas_rect = Rect2(cbw, cbw, self.width, self.height)
        # canvas_rect = Rect2(0, 0, self._tile_bounds.height, self._tile_bounds.width)

        canvas.create_rectangle(*rect2_to_tkinter(canvas_rect), fill=rgb_to_hex(DARKGREEN), outline=rgb_to_hex(BROWN_3), width=cbw)
        print("canvas_rect: ", canvas_rect)
        for i, tile in enumerate(cal.tiles):
            assert isinstance(tile, CalendarTile2), "Error value is not a valid CalendarTile."
            tile_rect = cal.get_rect(i, canvas_rect)
            tile_rect = [tile_rect.x, tile_rect.y, tile_rect.w + tile_rect.x, tile_rect.h + tile_rect.y]
            print(f"TR: {tile_rect}")
            bgc = rgb_to_hex(cal.tiles[i].colour)
            # bgc = rgb_to_hex(darken(random_colour(), 0.25))
            outline = rgb_to_hex(cal.tiles[i].colour_border)
            canvas.create_rectangle(*tile_rect, fill=bgc, outline=outline, width=cbw)

        top_row_y = cal.get_rect(0, canvas_rect)
        left_legend_rect = Rect2(cbw, cbw, self.HEADER_LEFT_WIDTH, self.HEADER_LEFT_HEIGHT)
        top_legend_rect = Rect2(cbw, cbw, self.HEADER_TOP_WIDTH, self.HEADER_TOP_HEIGHT)
        canvas_header_top.create_rectangle(*rect2_to_tkinter(top_legend_rect), fill=rgb_to_hex(YELLOW_2), outline=rgb_to_hex(DARKORANGE), width=cbw)
        canvas_header_left.create_rectangle(*rect2_to_tkinter(left_legend_rect), fill=rgb_to_hex(EMERALDGREEN), outline=rgb_to_hex(PLUM), width=cbw)
        for i in range(cal.rows):
            line_rect = Rect2(left_legend_rect.x, top_row_y.y + ((i + 1) * top_row_y.h + (1.5 * cbw)), left_legend_rect.w, top_row_y.h)
            line_rect = rect2_to_tkinter(line_rect)
            # canvas_header_left.create_rectangle(*line_rect, fill=rgb_to_hex(BLACK), outline=rgb_to_hex(WHITE), width=cbw)
            lrx, lry, lrw, lrh = line_rect
            txt = canvas_header_left.create_text(lrx + (lrw / 2), lry + (top_row_y.h / 2), fill=rgb_to_hex(WHITE), font="Times 12 italic bold", text=str(cal.lines[i]))
            print(f"line: {cal.lines[i]}")
            # p / 0

        cal.tiles[0].zoomed = True
        cal.tiles[8].zoomed = True
        cal.tiles[23].zoomed = True
        cal.tiles[24].zoomed = True
        cal.tiles[26].zoomed = True
        print(f"Zoomed rows: {cal.zoomed_rows()}")
        print(f"Zoomed cols: {cal.zoomed_cols()}")

        # draw_canvas(cal, canvas, canvas_header_top, canvas_header_left)

    def hover(self, event):
        x, y = event.x, event.y
        cal = self.TAB_DATA[self.CAL_IDX]["Cal"]
        cbw = cal.border_width
        canvas_rect = Rect2(cbw, cbw, self.width, self.height)
        print(f"x, y : {x}, {y}, tile_N: {cal.r_c_to_i(*cal.x_y_to_r_c(x, y, canvas_rect))}")

    def bind_calendar(self):
        self.notebook_tab_control.bind("<<NotebookTabChanged>>", self.on_tab_change)
        for i, tab in enumerate(self.TABS):
            if i == self.CAL_IDX:
                canvas = self.TAB_DATA[self.CAL_IDX]["canvas_cal"]
                canvas.bind("<Motion>", self.hover)

# def rect2_to_tkinter(rect):
#     assert isinstance(rect, Rect2), "Error value is not a valid Rect2 object."
#     return [rect.x, rect.y, rect.w + rect.x, rect.h + rect.y]

#  PSCalendar
#     - selected
#     - hovering