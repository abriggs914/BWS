import pyodbc
import tkinter
import asyncio
import datetime
import pandas as pd
from tkinter import ttk
from pathlib import Path
from PIL import ImageTk, Image
from utility import Rect2, brighten, first_of_month
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

        self.init_splash_menu()

        # Vars specific to Production Scheduling:
        # TODO, these should be real values
        self._calendar_index = 0
        self.tab_data = []
        # Tab_data - stores the loaded calendars

        # print(f"DIMS: w: <{self.width}>, h: <{self.height}>, TM: <{self.top_margin}>, BM: <{self.bottom_margin}>, LM: <{self.left_margin}>, RM: <{self.right_margin}>")
        # calculated values:
        self.update_title()
        self.update_geometry()
        self._drawing_bounds = self.calc_drawing_bounds()  # All drawings are bounded by this Rect.
        self._tile_bounds = self.calc_tile_bounds()

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

    def run(self) -> None:
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
                lines, dates, ordered_df = await self.get_production_data(start_date, end_date, first=False)
            else:
                print("Deadlock error. Please try again later.")
        except pyodbc.OperationalError:
            print("[08001] [Microsoft][ODBC SQL Server Driver][DBNETLIB]SQL Server does not exist or access denied.")
            print("Using default values")

        return lines, dates, ordered_df
        # return df

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

    def do_splash(self, start_date=first_of_month(datetime.datetime.now()), months_ahead=6):
        if self.N_TEST_CALS is not None:
            print(f"Overriding months_ahead ({months_ahead}) with N_TEST_CALS: ({self.N_TEST_CALS})")
            months_ahead = self.N_TEST_CALS


#  PSCalendar
#     - selected
#     - hovering