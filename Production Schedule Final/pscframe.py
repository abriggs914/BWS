import datetime
import itertools

import easygui
import pandas
import pyodbc
import tkinter
import asyncio
import pandas as pd
from tkinter import ttk
from pathlib import Path
from PIL import ImageTk, Image
from datetime_utility import *
from tkinter import colorchooser
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
            n_test_cals=None,
            max_n_selected=1,
            max_n_zoomed_rows=2,
            max_n_zoomed_cols=2,
            min_tile_w=30,
            min_tile_h=15,
            max_tile_w=100,
            max_tile_h=50,
            ASSERT_SAME_LINE_SWAP=False,
            border_width=2,
            middle_drag_placement_factor=0.3,
            HIGHLIGHT_EDITED_TILES=True,
            EDITED_HIGHLIGHT_PROPORTION=0.15,
            MAX_TABS=20
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
        self.ASSERT_SAME_LINE_SWAP = ASSERT_SAME_LINE_SWAP  # prevents units from swapping between units if T
        self.HIGHLIGHTED_EDITED_TILES = HIGHLIGHT_EDITED_TILES
        self.EDITED_HIGHLIGHT_PROPORTION = EDITED_HIGHLIGHT_PROPORTION
        self.border_width = border_width
        self.middle_drag_placement_factor = middle_drag_placement_factor

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

        self.ERMSG_NO_CROSS_LINE_SWAP = "Error cannot swap units between lines in this mode."

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
        self.DPM_ARROW_WIDTH = 5

        self.tctl_preview_height = 40
        self.tctl_preview_width = 80

        self.STYLES = {
            "DEFAULT": {
                "BEAM_LINE": SLATEGRAY_4,
                "T_LINE": GRAY_17,
                "GNK_LINE": (86, 34, 34),

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

                "DEFAULT_BACKGROUND": WHITE,
                "WEEKEND_DIV": ORANGE_2,
                "FRAME_TOP_CAL_BG": BROWN_4,
                "DRAG_PLACEMENT_MARKER_ARROW_1": YELLOW_2,
                "DRAG_PLACEMENT_MARKER_ARROW_2": EMERALDGREEN,
                "TOP_HEADER_FILL": BLACK,
                "LEFT_HEADER_FILL": BLACK,
                "TOP_HEADER_OUTLINE": WHITE,
                "LEFT_HEADER_OUTLINE": WHITE,
            }
        }

        self.empty_data = {
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
                print("You must be an employee at BWS or Stargate to use this program.")
                self.exit_program()

        # Vars specific to Production Scheduling:
        # TODO, these should be real values
        self.MAX_TABS = MAX_TABS
        self.TAB_NAMES = ["Current Period", "+1 Month", "+2 Months", "+3 Months", "+4 Months", "+5 Months", "+6 Months", "+7 Month", "+8 Months", "+9 Months", "+10 Months", "+11 Months", "+12 Months", "+13 Months", "+14 Months", "+15 Months", "+16 Months", "+17 Months", "+18 Months", "+19 Months", "+20 Months", "+21 Months"]
        self.USE_HOVER = False
        # self._calendar_index = 0

        # Tab_data - stores the loaded calendars

        # print(f"DIMS: w: <{self.width}>, h: <{self.height}>, TM: <{self.top_margin}>, BM: <{self.bottom_margin}>, LM: <{self.left_margin}>, RM: <{self.right_margin}>")
        # calculated values:
        self.notebook_tab_control = None
        self.notebook_tile_control = None
        # self.label_cal_title = None
        # self.frame_calendar = None
        # self.canvas_cal = None  # main drawing canvas
        # self.canvas_header_left = None  # left legend
        # self.can_header_top = None  # top legend
        # self.canvas_pop_up = None  # pop-up

        self.frame_top_calendar = None
        self.frame_tile_action = None
        self.frame_calendar_control = None
        self.frame_menu_controls = None
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

        self.tctl_label_wo_num = None
        self.tctl_entry_wo_num = None
        self.tctl_tv_wo_num = tkinter.StringVar()

        self.tctl_label_serial_num = None
        self.tctl_entry_serial_num = None
        self.tctl_tv_serial = tkinter.StringVar()

        self.tctl_label_quote = None
        self.tctl_entry_quote = None
        self.tctl_tv_quote = tkinter.StringVar()

        self.tctl_label_model = None
        self.tctl_entry_model = None
        self.tctl_tv_model = tkinter.StringVar()

        self.tctl_label_dealer = None
        self.tctl_entry_dealer = None
        self.tctl_tv_dealer = tkinter.StringVar()

        self.tctl_label_status = None
        self.tctl_entry_status = None
        self.tctl_tv_status = tkinter.StringVar()

        self.tctl_label_beam = None
        self.tctl_entry_beam = None
        self.tctl_tv_beam = tkinter.StringVar()

        self.tctl_label_start_date = None
        self.tctl_entry_start_date = None
        self.tctl_tv_start_date = tkinter.StringVar()

        self.tctl_btn_save = None
        # self.tctl_btn_undo = None

        self.combo_available_units_for_date = None
        self.combo_available_cols_for_date = None
        self.combo_available_rows_for_date = None
        self.label_tc_wo = None
        self.label_tc_row = None
        self.label_tc_col = None
        self.lb_chosen_new_unit = tkinter.StringVar()
        self.lb_chosen_new_row = tkinter.StringVar()
        self.lb_chosen_new_col = tkinter.StringVar()
        self.label_tctl_view_tile = None
        self.canvas_tctl_view_tile = None
        self.btn_tctl_add_new_tile = None
        self.btn_tctl_clear_tile_combos = None
        self.tctl_new_unit_obj = None

        self.mctl_btn_update_server = None
        self.mctl_btn_undo = None

        self.tab_data = []
        self.TAB_DATA = {}
        self.TABS = []
        self.TABS_tile_control = []
        self.TCTL_IDX = None
        self.CAL_IDX = None
        self.DRAG_PLACEMENT_MARKER_1 = None  # marks the sides of a tile to indicate that the tiles on either side should be moved to make room
        self.DRAG_PLACEMENT_MARKER_2 = None  # marks the middle of the hovered tile to indicate a replacement should happen

        self.max_n_selected = max_n_selected
        self.max_n_zoomed_rows = max_n_zoomed_rows
        self.max_n_zoomed_cols = max_n_zoomed_cols
        self.min_tile_w = min_tile_w
        self.min_tile_h = min_tile_h
        self.max_tile_w = max_tile_w
        self.max_tile_h = max_tile_h

        self._drawing_bounds = self.calc_drawing_bounds()  # All drawings are bounded by this Rect.
        self._tile_bounds = self.calc_tile_bounds()
        self.init_tabs()

        # self.populate_tab_data()
        self.init_splash_menu()
        self.init_calendar_menu()
        self.init_menu_control()
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

    def open(self, start_date, n_cals=10):
        n_cals = min(n_cals, self.MAX_TABS)
        self.TABS = self.TABS[:n_cals]
        self.TAB_NAMES = self.TAB_NAMES[:n_cals]
        self.TAB_DATA = {k: v for k, v in self.TAB_DATA.items() if k < n_cals}
        self.do_splash(start_date, n_cals)
        self.init_tile_control()
        self.set_full_screen()
        self.hide_splash()
        # psc = self.TAB_DATA[self.CAL_IDX]["Cal"]
        # canvas_cal =  self.TAB_DATA[self.CAL_IDX]["canvas_cal"]
        # self.canvas_header_left = self.TAB_DATA[self.CAL_IDX]["canvas_header_left"]  #{"canvas_pop_up": canvas_pop_up})
        # self.can_header_top = self.TAB_DATA[self.CAL_IDX]["can_header_top"]
        # self.frame_calendar = self.TAB_DATA[self.CAL_IDX]["frame_calendar"]
        # psc.draw_canvas(canvas, canvas_header_left, can_header_top)

        self.pack_calendar()
        self.pack_tile_action()
        self.pack_menu_controls()

        # cal = self.TAB_DATA[self.CAL_IDX]["Cal"]
        cal = self.get_current_calendar()

        # cal.set_zoom(0)
        # cal.tiles[0].zoomed = True
        # cal.tiles[24].zoomed = True

        # cal.tiles[0].zoomed = True
        # cal.tiles[8].zoomed = True
        # cal.tiles[23].zoomed = True
        # cal.tiles[24].zoomed = True
        # cal.tiles[26].zoomed = True
        # cal.tiles[322].zoomed = True

        # cal.tiles[2].zoomed = True
        # cal.tiles[3].zoomed = True
        # cal.tiles[6].zoomed = True
        # cal.tiles[9].zoomed = True
        # cal.tiles[13].zoomed = True
        # cal.tiles[14].zoomed = True
        # cal.tiles[17].zoomed = True
        # cal.tiles[20].zoomed = True
        # cal.tiles[246].zoomed = True
        # cal.tiles[192].zoomed = True
        # cal.tiles[462].zoomed = True
        # cal.tiles[485].zoomed = True

        print(f"Zoomed rows: {cal.zoomed_rows()}")
        print(f"Zoomed cols: {cal.zoomed_cols()}")

        # ensure that only n_cals are being used. Post processing... :(
        self.TABS = self.TABS[:n_cals]
        self.TABS = self.TAB_NAMES[:n_cals]  #TODO not sure this looks right - seems to work 2022-05-12

        self.draw_calendar()
        self.bind_calendar()
        self.populate_dealers_selectors()
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

    def on_tctl_tab_change(self, event):
        selection = self.notebook_tile_control.select()
        # print(f"SELECTION A: <{selection}>")
        # print(f"SELECTION B: <{event.widget.select()}>")
        # print(f"WIDGET: {self.notebook_tab_control}")
        tab_name = self.notebook_tile_control.tab(selection, "text")
        # raise ValueError(f"WUT {tab_name}")
        idx = [tab["name"] for tab in self.TABS_tile_control].index(tab_name)
        self.TCTL_IDX = idx

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
        cal = self.get_current_calendar()
        print(f"{'show' if not cal.switch_week_divs else 'hide'} week dividers")
        cal.switch_week_divs = not cal.switch_week_divs
        self.draw_calendar()

    def submit_calendar_search(self, *events):
        print("submit search")

    def reset_dealer_1(self, *events):
        print("reset_dealer_1")
        self.lb_dealer_1.set("")
        style = self.STYLES["DEFAULT"]
        btn_1 = self.btn_dealer_colour_1
        btn_1.config(bg=rgb_to_hex(style["DEFAULT_BACKGROUND"]), activebackground=rgb_to_hex(style["DEFAULT_BACKGROUND"]), text="")
        btn_1.update()

    def reset_dealer_2(self, *events):
        print("reset_dealer_2")
        self.lb_dealer_2.set("")
        style = self.STYLES["DEFAULT"]
        btn_2 = self.btn_dealer_colour_2
        btn_2.config(bg=rgb_to_hex(style["DEFAULT_BACKGROUND"]), activebackground=rgb_to_hex(style["DEFAULT_BACKGROUND"]), text="")
        btn_2.update()

    def reset_dealer_3(self, *events):
        print("reset_dealer_3")
        self.lb_dealer_3.set("")
        style = self.STYLES["DEFAULT"]
        btn_3 = self.btn_dealer_colour_3
        btn_3.config(bg=rgb_to_hex(style["DEFAULT_BACKGROUND"]), activebackground=rgb_to_hex(style["DEFAULT_BACKGROUND"]), text="")
        btn_3.update()

    def populate_dealers_selectors(self):
        cal = self.get_current_calendar()
        dealers = [dealer for dealer in cal.dealers]
        dealers.sort()
        highlights = cal.dealer_highlights
        self.btn_dealer_colour_1.bind("<Double-Button-1>", self.colour_chooser_1)
        self.btn_dealer_colour_2.bind("<Double-Button-1>", self.colour_chooser_2)
        self.btn_dealer_colour_3.bind("<Double-Button-1>", self.colour_chooser_3)
        self.lb_dealer_1.trace("w", self.update_dealer_1)
        self.lb_dealer_2.trace("w", self.update_dealer_2)
        self.lb_dealer_3.trace("w", self.update_dealer_3)
        self.combo_dealer_1["values"] = dealers
        self.combo_dealer_2["values"] = dealers
        self.combo_dealer_3["values"] = dealers

    def colour_chooser_1(self, event):
        cal = self.get_current_calendar()
        cal.unhighlight_dealer(0)
        rgb_code, colour_code = colorchooser.askcolor(title="Choose color")
        if colour_code is None:
            return

        btn_1 = self.btn_dealer_colour_1
        btn_1.config(bg=colour_code, activebackground=colour_code)
        btn_1.config(text=colour_code)
        btn_1.update()

        d_name = self.lb_dealer_1.get()
        if d_name is not None and d_name:
            for i, tab_dat in enumerate(self.TABS):
                c = self.TAB_DATA[i]["Cal"]
                # print("Highlighting c: <{}>: {}, {}".format(c, d_name, colour_code))
                c.highlight_dealer(d_name, colour_code, 0)
        # cal.canvas.focus_set()
        # cal.draw_canvas()
        self.draw_calendar()

    def colour_chooser_2(self, event):
        cal = self.get_current_calendar()
        cal.unhighlight_dealer(1)
        rgb_code, colour_code = colorchooser.askcolor(title="Choose color")
        if colour_code is None:
            return

        btn_2 = self.btn_dealer_colour_2
        btn_2.config(bg=colour_code, activebackground=colour_code)
        btn_2.config(text=colour_code)
        btn_2.update()

        d_name = self.lb_dealer_2.get()
        if d_name is not None and d_name:
            for i, tab_dat in enumerate(self.TABS):
                c = self.TAB_DATA[i]["Cal"]
                # print("Highlighting c: <{}>: {}, {}".format(c, d_name, colour_code))
                c.highlight_dealer(d_name, colour_code, 1)
        # cal.canvas.focus_set()
        # cal.draw_canvas()
        self.draw_calendar()

    def colour_chooser_3(self, event):
        cal = self.get_current_calendar()
        cal.unhighlight_dealer(2)
        rgb_code, colour_code = colorchooser.askcolor(title="Choose color")
        if colour_code is None:
            return

        btn_3 = self.btn_dealer_colour_3
        btn_3.config(bg=colour_code, activebackground=colour_code)
        btn_3.config(text=colour_code)
        btn_3.update()

        d_name = self.lb_dealer_3.get()
        if d_name is not None and d_name:
            for i, tab_dat in enumerate(self.TABS):
                c = self.TAB_DATA[i]["Cal"]
                # print("Highlighting c: <{}>: {}, {}".format(c, d_name, colour_code))
                c.highlight_dealer(d_name, colour_code, 2)
        # cal.canvas.focus_set()
        # cal.draw_canvas()
        self.draw_calendar()

    def update_dealer_1(self, *args):
        # print("updating dealer_1")
        cal = self.get_current_calendar()
        btn_1 = self.btn_dealer_colour_1
        colour_code = btn_1["bg"]
        d_name = self.lb_dealer_1.get()
        if iscolour(colour_code) and d_name:
            for i, t_name in enumerate(self.TABS):
                c = self.TAB_DATA[i]["Cal"]
                # print("Highlighting c: <{}>: {}, {}".format(c, d_name, colour_code))
                c.highlight_dealer(d_name, colour_code, 0)
        self.draw_calendar()

    def update_dealer_2(self, *args):
        # print("updating dealer_2")
        cal = self.get_current_calendar()
        btn_2 = self.btn_dealer_colour_2
        colour_code = btn_2["bg"]
        d_name = self.lb_dealer_2.get()
        if iscolour(colour_code) and d_name:
            for i, t_name in enumerate(self.TABS):
                c = self.TAB_DATA[i]["Cal"]
                # print("Highlighting c: <{}>: {}, {}".format(c, d_name, colour_code))
                c.highlight_dealer(d_name, colour_code, 1)
        self.draw_calendar()

    def update_dealer_3(self, *args):
        # print("updating dealer_3")
        cal = self.get_current_calendar()
        btn_3 = self.btn_dealer_colour_3
        colour_code = btn_3["bg"]
        d_name = self.lb_dealer_3.get()
        if iscolour(colour_code) and d_name:
            for i, t_name in enumerate(self.TABS):
                c = self.TAB_DATA[i]["Cal"]
                # print("Highlighting c: <{}>: {}, {}".format(c, d_name, colour_code))
                c.highlight_dealer(d_name, colour_code, 2)
        self.draw_calendar()

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
            "T11",
            "T12",
            "T14",
            "T15"
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
            query = "EXEC [sp_ProductionScheduleEdit V4_Slots] \'{sd}\', \'{ed}\';".format(sd=start_date, ed=end_date)
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
            style = self.get_current_style()
        else:
            style = style_in
        colour_tile = style["TILE_BACKGROUND_STAT"]
        colour_border = style["TILE_OUTLINE_STAT"]
        colour_font = style["TILE_FOREGROUND_STAT"]
        colour_selected = style["TILE_BACKGROUND_SELECT"]
        colour_hovered = style["TILE_BACKGROUND_HOVER"]
        colour_dragging = style["TILE_BACKGROUND_DRAG"]
        colour_weekend_div = style["WEEKEND_DIV"]
        colour_beam_line_tile = style["BEAM_LINE"]
        colour_t_line_tile = style["T_LINE"]
        colour_gnk_line_tile = style["GNK_LINE"]
        switch_week_divs = True
        return PSCalendar2(start_date, end_date, data, lines, dates, colour_tile=colour_tile, colour_border=colour_border, colour_font=colour_font, colour_selected=colour_selected, colour_hovered=colour_hovered, colour_dragging=colour_dragging, border_width=self.border_width, switch_week_divs=switch_week_divs, colour_weekend_div=colour_weekend_div, max_n_zoomed_rows=self.max_n_zoomed_rows, max_n_zoomed_cols=self.max_n_zoomed_cols, min_tile_w=self.min_tile_w, min_tile_h=self.min_tile_h, max_tile_w=self.max_tile_w, max_tile_h=self.max_tile_h, max_n_selected=self.max_n_selected, colour_beam_line_tile=colour_beam_line_tile, colour_t_line_tile=colour_t_line_tile, colour_gnk_line_tile=colour_gnk_line_tile)

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

    def new_tab_obj(self):
        return ttk.Frame(self.notebook_tab_control)

    def new_tab_dat_obj(self):
        k = len(self.TABS) + 1
        return {k: dict(self.empty_data)}

    # Called at beginning to instantiate the Tab frames
    def init_tabs(self):
        # List of tabs as tkinter frames
        self.notebook_tab_control = ttk.Notebook(self)
        self.TABS = [self.new_tab_obj() for _ in range(self.MAX_TABS)]
        print(f"self.TABS: len:{len(self.TABS)}")
        self.CAL_IDX = 0

        # Zipping Tab frames and names. Prepping for Navigation Tabs
        # Capping # TABS and queries based on N_TEST_CALS
        if self.N_TEST_CALS is not None:
            self.TABS = self.TABS if len(self.TABS) <= self.N_TEST_CALS else self.TABS[:self.N_TEST_CALS]
            self.TAB_NAMES = self.TAB_NAMES if len(self.TAB_NAMES) <= self.N_TEST_CALS else self.TAB_NAMES[
                                                                                            :self.N_TEST_CALS]
        self.TAB_DATA = dict(zip([i for i in range(len(self.TABS))], [dict(self.empty_data) for _ in range(len(self.TAB_NAMES))]))
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

    async def get_available_units(self):
        query = """SELECT
	--(CASE WHEN [WO#] IS NULL THEN ELSE END)
	--ISNULL([dtProductionSchedule].[WO#], [dtProductionSchedule].[Quote#]) AS [WO],
	--[dtProductionSchedule].[WO#],
	[dtProductionSchedule].[Quote#]
	--[Prod Date 1],
	--[Prod Date 2],
	--[Date Declined]
FROM
	[dtProductionSchedule]
LEFT JOIN
	[Orders]
ON
	[dtProductionSchedule].[Quote#] = [Orders].[Quote#]
WHERE
	[Prod Date 1] IS NULL
	AND [Prod Date 2] IS NULL
	--AND [dtProductionSchedule].[WO#] IS NULL
	AND [Orders].[Date Declined] IS NULL
	--AND [Orders].[Decline/Rejected] IS NULL
	AND [dtProductionSchedule].[Quote#] IS NOT NULL
ORDER BY
	[Quote#]"""
        quotes = []
        try:
            cnxn = pyodbc.connect('DRIVER={SQL Server};SERVER=server3;DATABASE=BWSdb;UID=user5;PWD=M@gic456',
                                  timeout=10)
            table_result = await self.read_sql_async(query, cnxn)
            df1 = pd.DataFrame(table_result)
            ordered_df = df1.sort_values(by="Quote#")
            print(f"ordered_df: {ordered_df}")
            quotes = ordered_df["Quote#"].tolist()
            print(f"QUOTES: {quotes}")
            cnxn.close()
        except pd.io.sql.DatabaseError:
            print("Deadlock error. Please try again later.")
        except pyodbc.OperationalError:
            print("[08001] [Microsoft][ODBC SQL Server Driver][DBNETLIB]SQL Server does not exist or access denied.")
            print("Using default values")
        else:
            print(f"QUOTES: {quotes}")
        finally:
            print(f"QUOTES: {quotes}")
        return quotes

    def init_tile_control(self):
        self.TABS_tile_control = [
            {
                "frame": ttk.Frame(self.notebook_tile_control),
                "name": "+ / -"
            },
            {
                "frame": ttk.Frame(self.notebook_tile_control),
                "name": "Add"
            },
            {
                "frame": ttk.Frame(self.notebook_tile_control),
                "name": "Delete"
            }
        ]

        root_tab_1 = self.TABS_tile_control[0]["frame"]
        root_tab_1.grid()
        entry_width = 125
        self.tctl_label_wo_num = tkinter.Label(root_tab_1, text="WO#:")
        self.tctl_entry_wo_num = tkinter.Entry(root_tab_1, textvariable=self.tctl_tv_wo_num, width=entry_width)

        self.tctl_label_serial_num = tkinter.Label(root_tab_1, text="Serial#:")
        self.tctl_entry_serial_num = tkinter.Entry(root_tab_1, textvariable=self.tctl_tv_serial, width=entry_width)

        self.tctl_label_quote = tkinter.Label(root_tab_1, text="Quote#:")
        self.tctl_entry_quote = tkinter.Entry(root_tab_1, textvariable=self.tctl_tv_quote, width=entry_width)

        self.tctl_label_model = tkinter.Label(root_tab_1, text="Model:")
        self.tctl_entry_model = tkinter.Entry(root_tab_1, textvariable=self.tctl_tv_model, width=entry_width)

        self.tctl_label_dealer = tkinter.Label(root_tab_1, text="Dealer:")
        self.tctl_entry_dealer = tkinter.Entry(root_tab_1, textvariable=self.tctl_tv_dealer, width=entry_width)

        self.tctl_label_status = tkinter.Label(root_tab_1, text="Status:")
        self.tctl_entry_status = tkinter.Entry(root_tab_1, textvariable=self.tctl_tv_status, width=entry_width)

        self.tctl_label_beam = tkinter.Label(root_tab_1, text="Beam:")
        self.tctl_entry_beam = tkinter.Entry(root_tab_1, textvariable=self.tctl_tv_beam, width=entry_width)

        self.tctl_label_start_date = tkinter.Label(root_tab_1, text="Start Date:")
        self.tctl_entry_start_date = tkinter.Entry(root_tab_1, textvariable=self.tctl_tv_start_date, width=entry_width)

        self.tctl_btn_save = tkinter.Button(root_tab_1, command=self.tctl_save_click, text="save", name="save_btn")
        # self.tctl_btn_undo = tkinter.Button(root_tab_1, command=self.tctl_undo_click, text="undo", name="undo_btn")

        self.TABS_tile_control[0].update({
            "widgets": [
                self.tctl_label_wo_num,
                self.tctl_entry_wo_num,

                self.tctl_label_serial_num,
                self.tctl_entry_serial_num,
                self.tctl_label_quote,
                self.tctl_entry_quote,

                self.tctl_label_model,
                self.tctl_entry_model,
                self.tctl_label_dealer,
                self.tctl_entry_dealer,
                self.tctl_label_status,
                self.tctl_entry_status,
                self.tctl_label_beam,
                self.tctl_entry_beam,
                self.tctl_label_start_date,
                self.tctl_entry_start_date,
                self.tctl_btn_save,
                # self.tctl_btn_undo
            ],
            "arguments": [
                {"row": 1, "column": 1},
                {"row": 1, "column": 2},
                {"row": 2, "column": 1},
                {"row": 2, "column": 2},
                {"row": 3, "column": 1},
                {"row": 3, "column": 2},
                {"row": 4, "column": 1},
                {"row": 4, "column": 2},
                {"row": 5, "column": 1},
                {"row": 5, "column": 2},
                {"row": 6, "column": 1},
                {"row": 6, "column": 2},
                {"row": 7, "column": 1},
                {"row": 7, "column": 2},
                {"row": 8, "column": 1},
                {"row": 8, "column": 2},
                {"row": 9, "column": 1},
                # {"row": 7, "column": 2},  # TODO IDK why but it cant go on the same row??
                # {"row": 8, "column": 2},  # Omitting for now
            ]
        })

        root_tab_2 = self.TABS_tile_control[1]["frame"]
        self.label_tc_wo = tkinter.Label(root_tab_2, text="WO")
        self.label_tc_row = tkinter.Label(root_tab_2, text="Row:")
        self.label_tc_col = tkinter.Label(root_tab_2, text="Column:")
        self.combo_available_units_for_date = ttk.Combobox(root_tab_2, textvariable=self.lb_chosen_new_unit, state="readonly")
        self.combo_available_rows_for_date = ttk.Combobox(root_tab_2, textvariable=self.lb_chosen_new_row, state="readonly")
        self.combo_available_cols_for_date = ttk.Combobox(root_tab_2, textvariable=self.lb_chosen_new_col, state="readonly")
        self.lb_chosen_new_unit.trace("w", self.new_unit_change)
        self.lb_chosen_new_row.trace("w", self.new_row_change)
        self.lb_chosen_new_col.trace("w", self.new_col_change)
        self.btn_tctl_add_new_tile = tkinter.Button(root_tab_2, text="create", command=self.date_new_unit)

        self.label_tctl_view_tile = tkinter.Label(root_tab_2, text="Preview")
        self.canvas_tctl_view_tile = tkinter.Canvas(root_tab_2, width=self.tctl_preview_width, height=self.tctl_preview_height, bg=rgb_to_hex(WHITE))
        self.btn_tctl_clear_tile_combos = tkinter.Button(root_tab_2, text="clear", command=self.clear_unit_fields)

        # TODO HARDCODED
        # self.combo_available_units_for_date["values"] = ["A", "B", "C"]
        result = [
            "50",
            "1108",
            "1111",
            "1112",
            "1118",
            "1121",
            "1122",
            "1123",
            "1124",
            "1125",
            "1126",
            "1127",
            "1128",
            "1129",
            "1130",
            "1131",
            "1132",
            "1133",
            "1134",
            "1135",
            "1136",
            "1137",
            "1138",
            "1139",
            "1140",
            "1141",
            "1142",
            "1143",
            "1144",
            "1145",
            "1146",
            "1147",
            "1148",
            "1149",
            "1150",
            "1151",
            "1152",
            "1153",
            "1154",
            "1155",
            "1156",
            "1157",
            "1158",
            "1159",
            "1160",
            "1161",
            "1162",
            "1163",
            "1164",
            "1165",
            "1166",
            "1167",
            "1168",
            "1169",
            "1170",
            "1172",
            "1173",
            "1175",
            "1176",
            "1177",
            "1178",
            "1179",
            "1180",
            "1181",
            "1182",
            "1183",
            "1184",
            "1185",
            "1186",
            "1187",
            "1189",
            "1190",
            "1191",
            "1192",
            "1193",
            "1194",
            "1195",
            "1196",
            "1197",
            "1198",
            "1199",
            "1200",
            "1201",
            "1202",
            "1203",
            "1204",
            "1205",
            "1206",
            "1207",
            "1208",
            "1209",
            "1210",
            "1211",
            "1212",
            "1213",
            "1214",
            "1215",
            "1216",
            "1217",
            "1218",
            "1219",
            "1220",
            "1221",
            "1222",
            "1223",
            "1224",
            "1225",
            "1226",
            "1227",
            "1228",
            "1229",
            "1230",
            "1231",
            "1232",
            "1233",
            "1235",
            "1236",
            "5232",
            "5504",
            "11701",
            "12736",
            "14660",
            "14667",
            "14668",
            "14669",
            "15569",
            "20271",
            "26098",
            "26099",
            "26282",
            "26352",
            "26354",
            "26357",
            "26361",
            "26420",
            "26421",
            "26460",
            "26483",
            "26484",
            "26485",
            "26486",
            "26487",
            "26488",
            "26489",
            "26491",
            "26492",
            "26496",
            "26519",
            "26524",
            "26566",
            "26595",
            "26597",
            "26598",
            "26599",
            "26675",
            "26676",
            "26792",
            "26793",
            "26794",
            "26795",
            "26799",
            "26800",
            "26801",
            "27107",
            "27108",
            "27301",
            "27355",
            "27363",
            "27369",
            "27370",
            "27371",
            "27420",
            "27453",
            "27469",
            "27484",
            "27564",
            "27619",
            "27637"
        ]
        # result = await self.get_available_units()
        # result = run_coroutine_threadsafe(_get(url), bot.loop)
        # print(f"result: {result}")
        cal = self.get_current_calendar()
        self.combo_available_units_for_date["values"] = result
        self.combo_available_rows_for_date["values"] = cal.lines #  list(range(1, cal.rows + 1))
        self.combo_available_cols_for_date["values"] = cal.dates #  list(range(1, cal.cols + 1))

        self.TABS_tile_control[1].update({
            "widgets": [
                self.label_tc_wo,
                self.combo_available_units_for_date,
                self.label_tc_row,
                self.combo_available_rows_for_date,
                self.label_tc_col,
                self.combo_available_cols_for_date,
                self.btn_tctl_clear_tile_combos,
                self.btn_tctl_add_new_tile,
                self.label_tctl_view_tile,
                self.canvas_tctl_view_tile
            ],
            "arguments": [
                {"row": 1, "column": 1},
                {"row": 1, "column": 2, "columnspan": 2},
                {"row": 3, "column": 1},
                {"row": 4, "column": 1},
                {"row": 3, "column": 2},
                {"row": 4, "column": 2},
                {"row": 5, "column": 1},
                {"row": 5, "column": 2},
                {"row": 6, "column": 1, "columnspan": 2},
                {"row": 7, "column": 1, "columnspan": 2}
            ]
        })

        root_tab_3 = self.TABS_tile_control[2]["frame"]
        self.TABS_tile_control[2].update({
            "widgets": [],
            "arguments": []
        })

        self.TCTL_IDX = 0
        for i, tab_dat in enumerate(self.TABS_tile_control):
            tab = tab_dat["frame"]
            tab_name = tab_dat["name"]
            self.notebook_tile_control.add(tab, text=tab_name)

    def init_menu_control(self):
        self.frame_menu_controls = tkinter.Frame(self.frame_top_calendar, height=200, border=1, borderwidth=2, bg=rgb_to_hex(TAN_1))
        self.mctl_btn_update_server = tkinter.Button(self.frame_menu_controls, command=self.save_changes_update_server, text="save changes and update server")
        self.mctl_btn_undo = tkinter.Button(self.frame_menu_controls, command=self.menu_control_undo_click, text="undo")

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

        style = self.get_current_style()
        self.frame_top_calendar = tkinter.Frame(self, height=500, bg=rgb_to_hex(style["FRAME_TOP_CAL_BG"]))
        self.notebook_tile_control = ttk.Notebook(self.frame_top_calendar, width=325)

        self.frame_calendar_control = tkinter.Frame(self.frame_top_calendar, height=200, border=1, borderwidth=2, bg=rgb_to_hex(NAVY))
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
        self.combo_dealer_1 = ttk.Combobox(self.frame_dealer_colour_select_c1, textvariable=self.lb_dealer_1, state="readonly")
        self.btn_reset_dealer_1 = tkinter.Button(self.frame_dealer_colour_select_c1, text="Reset", command=self.reset_dealer_1)
        self.btn_dealer_colour_2 = tkinter.Button(self.frame_dealer_colour_select_c2)
        self.combo_dealer_2 = ttk.Combobox(self.frame_dealer_colour_select_c2, textvariable=self.lb_dealer_2, state="readonly")
        self.btn_reset_dealer_2 = tkinter.Button(self.frame_dealer_colour_select_c2, text="Reset", command=self.reset_dealer_2)
        self.btn_dealer_colour_3 = tkinter.Button(self.frame_dealer_colour_select_c3)
        self.combo_dealer_3 = ttk.Combobox(self.frame_dealer_colour_select_c3, textvariable=self.lb_dealer_3, state="readonly")
        self.btn_reset_dealer_3 = tkinter.Button(self.frame_dealer_colour_select_c3, text="Reset", command=self.reset_dealer_3)

        self.frame_tile_action = tkinter.Frame(self.frame_top_calendar)

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

        # pack top widgets space
        self.frame_top_calendar.pack()

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
        self.frame_calendar_control.pack(side=tkinter.RIGHT)
        self.frame_menu_controls.pack(side=tkinter.RIGHT)
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

    def pack_menu_controls(self):
        self.frame_menu_controls.pack()
        self.mctl_btn_update_server.pack()
        self.mctl_btn_undo.pack()

    def pack_tile_action(self):
        self.notebook_tile_control.pack()
        self.frame_tile_action.pack(side=tkinter.LEFT)

        for i, tab_data in enumerate(self.TABS_tile_control):
            # frame = tab_data["frame"]
            widgets = tab_data["widgets"]
            arguments = tab_data["arguments"]
            for widget, args in zip(widgets, arguments):
                print(f"widget: {widget}, args: {args}")
                widget.grid(**args)

        # do not allow the creat button to be pushed until choices are made
        self.btn_tctl_add_new_tile.config(state="disabled")

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

    def do_splash(self, start_date=first_of_month(datetime.datetime.now()), months_ahead=10):
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
        # print(f"drawing calendar at tab {self.CAL_IDX}, CAL: {self.TAB_DATA[self.CAL_IDX]['Cal']}")

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

        # style = self.STYLES["DEFAULT"]
        style = self.get_current_style()
        cal = self.get_current_calendar()
        dealer_highlights = cal.dealer_highlights
        cbw = cal.border_width
        canvas = self.TAB_DATA[self.CAL_IDX]["canvas_cal"]
        canvas_header_top = self.TAB_DATA[self.CAL_IDX]["canvas_header_top"]
        # canvas_header_left = self.TAB_DATA[self.CAL_IDX]["canvas_header_left"]
        canvas_header_left = self.TAB_DATA[self.CAL_IDX]["canvas_header_left"]
        canvas_rect = Rect2(cbw, cbw, self.width, self.height)
        # canvas_rect = Rect2(0, 0, self._tile_bounds.height, self._tile_bounds.width)

        canvas.delete("all")
        canvas_header_left.delete("all")
        canvas_header_top.delete("all")
        last_swap_pair = cal.swap_pair

        # canvas.create_rectangle(*rect2_to_tkinter(canvas_rect), fill=rgb_to_hex(DARKGREEN), outline=rgb_to_hex(BROWN_3), width=cbw)
        # print("canvas_rect: ", canvas_rect)

        # draw tiles
        for i, tile in enumerate(cal.tiles):
            # if i % 24 != 0:
            #     continue
            # assert isinstance(tile, CalendarTile2), "Error value is not a valid CalendarTile."
            og_rect = cal.get_rect(i, canvas_rect, False)
            cbw = cal.border_width
            tile_rect = [og_rect.x, og_rect.y, og_rect.w + og_rect.x, og_rect.h + og_rect.y]
            # print(f"TR: {tile_rect}")




            # bgc = cal.tiles[i].colour
            # outline = cal.tiles[i].colour_border
            # tt = tile.wo_num if tile.wo_num is not None else ""

            # # highlight selected tile
            # if tile.selected:
            #     bgc = tile.colour_selected
            #
            # # highlight last swapped pair
            # if cal.highlight_last_swapped:
            #     if last_swap_pair:
            #         a, b = last_swap_pair
            #         if tile in last_swap_pair and tile.ser in {a.ser, b.ser}:
            #             bgc = brighten(bgc, 0.15)
            #             outline = darken(outline, 0.15)
            #
            # if self.HIGHLIGHTED_EDITED_TILES:
            #     if tile.is_edited():
            #         print(f"tile: {tile} is edited, tile.OG: {tile.OG}")
            #         bgc = brighten(bgc, 0.1)

            bgc, outline, tt = self.get_tile_colour(cal, tile)

            # convert to hex
            bgc = rgb_to_hex(bgc)
            outline = rgb_to_hex(outline)

            # draw objects
            canvas.create_rectangle(*tile_rect, fill=bgc, outline=outline, width=cbw)
            canvas.create_text(tile_rect[0] + (og_rect.w / 2), tile_rect[1] + (og_rect.h / 2), fill=rgb_to_hex(WHITE), text=f"{tt}")

        # draw week dividers
        if cal.switch_week_divs:
            for i, date in enumerate(cal.dates):
                idx = cal.r_c_to_i(0, i)
                tile_rect = cal.get_rect(idx, canvas_rect)
                tomorrow = None if i == len(cal.tiles) - 1 else cal.tiles[i + 1].date
                diff = None if tomorrow is None else tomorrow - date
                # print("date: {}, tomorrow: {}, diff: {}".format(date, tomorrow, diff))
                weekend_rect = None
                is_monday = date.weekday() == 0  # Monday is 0
                if i == 0 and is_monday:
                    # weekend_rect = (0, 0, cal.border_width, self.height)
                    weekend_rect = (0, 0, cal.border_width, self.height)
                elif tomorrow is not None and diff.days > 2:
                    # weekend_rect = (tile_rect[2], tile_rect[1], tile_rect[2] + cal.border_width, tile_rect[3])
                    weekend_rect = [tile_rect[2], 0, tile_rect[2] + (cbw / 2), self.height]
                if weekend_rect is not None:
                    colour = rgb_to_hex(cal.weekend_div_colour)
                    canvas.create_rectangle(*weekend_rect, fill=colour, outline=colour, width=cal.border_width)

        # top_row_y = cal.get_rect(0, canvas_rect)
        top_y = self.HEADER_TOP_HEIGHT + (cbw / 2)  # + (3 * cbw)
        # raise ValueError(f"TOP Y: {top_y}")
        left_legend_rect = Rect2(cbw / 2, cbw / 2, self.HEADER_LEFT_WIDTH, self.HEADER_LEFT_HEIGHT)
        top_legend_rect = Rect2(cbw / 2, cbw / 2, self.HEADER_TOP_WIDTH, self.HEADER_TOP_HEIGHT)
        canvas_header_top.create_rectangle(*rect2_to_tkinter(top_legend_rect), fill=rgb_to_hex(style["TOP_HEADER_FILL"]), outline=rgb_to_hex(style["TOP_HEADER_OUTLINE"]), width=cbw)
        canvas_header_left.create_rectangle(*rect2_to_tkinter(left_legend_rect), fill=rgb_to_hex(style["LEFT_HEADER_FILL"]), outline=rgb_to_hex(style["LEFT_HEADER_OUTLINE"]), width=cbw)

        # draw left legend
        for i in range(cal.rows):
            row_height = cal.row_height(i, canvas_rect)
            # line_rect = Rect2(left_legend_rect.x, top_row_y.y + ((1 + i) * ((top_row_y.h / 2) + (1 * cbw))), left_legend_rect.w, row_height)
            line_rect = Rect2(left_legend_rect.x, cal.y_at_row(i, canvas_rect), left_legend_rect.w, row_height)
            line_rect.y += top_y
            # line_rect = rect2_to_tkinter(line_rect)
            # canvas_header_left.create_rectangle(*line_rect, fill=rgb_to_hex(BLACK), outline=rgb_to_hex(WHITE), width=cbw)
            # canvas_header_left.create_rectangle(*list(line_rect)[:4], fill=rgb_to_hex(random_color() if i != 0 else ORANGE), outline=rgb_to_hex(WHITE), width=cbw)
            lrx, lry, lrw, lrh = line_rect.sq_rect()
            # canvas_header_left.create_text(lrx + (lrw / 2), lry + (lrh / 2), fill=rgb_to_hex(WHITE), font="Times 12 italic bold", text=str(cal.lines[i]))
            canvas_header_left.create_text(lrx + (lrw / 2), lry + (lrh / 2), fill=rgb_to_hex(WHITE), text=str(cal.lines[i]))
            # txt = canvas_header_left.create_text(lrx + (lrw / 2), lry + (lrh / 2), fill=rgb_to_hex(WHITE), font="Times 12 italic bold", text=str(cal.lines[i]))
            # print(f"line: {cal.lines[i]}, lr: {line_rect}")
            # p / 0

        # draw top legend
        for i in range(cal.cols):
            # if i > 0:
            #     break
            col_width = cal.col_width(i, canvas_rect)
            # line_rect = Rect2(left_legend_rect.x, top_row_y.y + ((1 + i) * ((top_row_y.h / 2) + (1 * cbw))), left_legend_rect.w, row_height)
            line_rect = Rect2(cal.x_at_col(i, canvas_rect), top_legend_rect.y, col_width, top_legend_rect.h)
            # line_rect.y += top_y
            # line_rect = rect2_to_tkinter(line_rect)
            # canvas_header_left.create_rectangle(*line_rect, fill=rgb_to_hex(BLACK), outline=rgb_to_hex(WHITE), width=cbw)
            # canvas_header_left.create_rectangle(*list(line_rect)[:4], fill=rgb_to_hex(random_color() if i != 0 else ORANGE), outline=rgb_to_hex(WHITE), width=cbw)
            lrx, lry, lrw, lrh = line_rect.sq_rect()
            # canvas_header_left.create_text(lrx + (lrw / 2), lry + (lrh / 2), fill=rgb_to_hex(WHITE), font="Times 12 italic bold", text=str(cal.lines[i]))
            canvas_header_top.create_text(lrx + (lrw / 2), lry + (lrh / 2), fill=rgb_to_hex(WHITE), text=str(cal.date(i, inc_y=False)))
            # print("date:", cal.dates[i], "lr:", line_rect, "sq:", line_rect.sq_rect(), "lrw:" ,lrw)
            # txt = canvas_header_left.create_text(lrx + (lrw / 2), lry + (lrh / 2), fill=rgb_to_hex(WHITE), font="Times 12 italic bold", text=str(cal.lines[i]))
            # print(f"line: {cal.lines[i]}, lr: {line_rect}")
            # p / 0

        dragging = cal.get_dragging()
        if dragging or self.DRAG_PLACEMENT_MARKER_1 or self.DRAG_PLACEMENT_MARKER_2:
            print(f"dragging: {dragging}, self.DRAG_PLACEMENT_MARKER_1: {self.DRAG_PLACEMENT_MARKER_1}, self.DRAG_PLACEMENT_MARKER_2: {self.DRAG_PLACEMENT_MARKER_2}")
            for tile in dragging:
                ti = tile.ser
                tile = cal.tiles[ti]
                # rh = cal.row_height(ti, canvas_rect)
                # cw = cal.col_width(ti, canvas_rect)
                rect = cal.get_rect(ti, canvas_rect)
                rect2 = tkinter_to_rect2(rect)
                rect[0] += tile.drag_x - (rect2.w / 2)
                rect[1] += tile.drag_y - (rect2.h / 2)
                rect[2] = rect[0] + rect2.w
                rect[3] = rect[1] + rect2.h
                rect3 = tkinter_to_rect2(rect)
                tile.drag_x = 0
                tile.drag_y = 0
                canvas.create_rectangle(rect, fill=rgb_to_hex(tile.colour_dragging))
                tt = tile.wo_num if tile.wo_num is not None else ""
                if tt:
                    ttx, tty = rect3.x + (rect3.w / 2), rect3.y + (rect3.h / 2)
                    # print(f"ttx, tty: {ttx}, {tty}, rect: {rect}, tt: {tt}")
                    font_colour = font_foreground(tile.colour_dragging)
                    canvas.create_text((ttx, tty), fill=rgb_to_hex(font_colour), text=f"{tt}")

            dpm = None
            colour = None
            if self.DRAG_PLACEMENT_MARKER_1:
                # mark the edges of the tile to indicate that the tiles to the right and left should make room
                dpm = self.DRAG_PLACEMENT_MARKER_1
                colour = style["DRAG_PLACEMENT_MARKER_ARROW_1"]
            elif self.DRAG_PLACEMENT_MARKER_2:
                # mark the middle of the tile to indicate that the dragged tile should replace the current hovered tile.
                dpm = self.DRAG_PLACEMENT_MARKER_2
                colour = style["DRAG_PLACEMENT_MARKER_ARROW_2"]
            if dpm:
                dpmr = tkinter_to_rect2(dpm)
                pts1 = [dpmr.center[0], dpmr.top, dpmr.left - self.DPM_ARROW_WIDTH, dpmr.top - dpmr.h, dpmr.right + self.DPM_ARROW_WIDTH, dpmr.top - dpmr.h]  # down arrow
                pts2 = [dpmr.center[0], dpmr.bottom, dpmr.left - self.DPM_ARROW_WIDTH, dpmr.bottom + dpmr.h, dpmr.right + self.DPM_ARROW_WIDTH, dpmr.bottom + dpmr.h]  # up arrow
                # canvas.create_rectangle(*dpm, fill=rgb_to_hex(style["WEEKEND_DIV"]))
                canvas.create_polygon(*pts1, fill=rgb_to_hex(colour))
                canvas.create_polygon(*pts2, fill=rgb_to_hex(colour))

            self.DRAG_PLACEMENT_MARKER_1 = None
            self.DRAG_PLACEMENT_MARKER_2 = None

        # draw_canvas(cal, canvas, canvas_header_top, canvas_header_left)
        canvas.update()
        canvas_header_top.update()
        canvas_header_left.update()

    def get_current_style(self):
        """Get the style dict."""
        # TODO hardcoded default style here
        return self.STYLES["DEFAULT"]

    def get_current_calendar(self):
        """Return the PSCalendar object located at the current tab using 'CAL_IDX'."""
        assert isinstance(self.TAB_DATA[self.CAL_IDX]["Cal"], PSCalendar2), "Error \'self.TAB_DATA[self.CAL_IDX]['Cal']\' needs to be a PSCalendar2 object"
        return self.TAB_DATA[self.CAL_IDX]["Cal"]

    def get_current_cal_canvas(self):
        """Return the Tkinter.Canvas object located at the current tab using 'CAL_IDX'."""
        return self.TAB_DATA[self.CAL_IDX]["canvas_cal"]

    def get_current_cal_canvas_rect(self):
        """Return the Canvas bounds as a Rect2 object, at the current tab using 'CAL_IDX'."""
        cal = self.TAB_DATA[self.CAL_IDX]["Cal"]
        cbw = cal.border_width
        return Rect2(cbw, cbw, self.width, self.height)

    def get_tile_colour(self, cal, tile, new_background=False):

        bgc = tile.colour
        if new_background or (not tile.is_empty and bgc in [cal.colour_tile_general, cal.colour_beam_line_tile, cal.colour_gnk_line_tile]):
            if tile.is_beam():
                bgc = cal.colour_beam_line_tile
            elif tile.is_gnk():
                bgc = cal.colour_gnk_line_tile
            elif tile.is_t():
                bgc = cal.colour_tile_general

        last_swap_pair = cal.swap_pair
        outline = tile.colour_border
        tt = tile.wo_num if tile.wo_num is not None else ""

        # highlight selected tile
        if tile.selected:
            bgc = tile.colour_selected

        # highlight last swapped pair
        if cal.highlight_last_swapped:
            if last_swap_pair:
                a, b = last_swap_pair
                if tile in last_swap_pair and tile.ser in {a.ser, b.ser}:
                    bgc = brighten(bgc, 0.15)
                    # print(f"OUTLINE: {outline}")
                    outline = darken(outline, 0.15)

        if self.HIGHLIGHTED_EDITED_TILES:
            if tile.is_edited():
                print(f"tile: {tile} is edited, tile.OG: {tile.OG}")
                bgc = brighten(bgc, self.EDITED_HIGHLIGHT_PROPORTION)
                # outline = font_foreground(bgc)  # don't do this for now 2022-05-13
        return bgc, outline, tt

    def calculate_dpms(self, event):
        """While dragging a tile, calculate the rects to draw placement arrows around the destination tile.
            self.DRAG_PLACEMENT_MARKER_1 denotes the marker at the edge of the tile. When placed the tiles around it will shift.
            self.DRAG_PLACEMENT_MARKER_2 denotes the marker int the middle of a tile. When placed the tile will swap with destination tile."""
        cal = self.get_current_calendar()
        canvas_rect = self.get_current_cal_canvas_rect()
        selected = cal.get_selected()
        x2, y2 = event.x, event.y
        hovering_tile = cal.tile_at_x_y(x2, y2, canvas_rect)
        hovering_rect = cal.get_rect(hovering_tile.ser, canvas_rect, tkinter_rect=False)
        go_left = False
        on_edge = True
        if (x2 < hovering_rect.center[0] and hovering_tile.j != cal.cols - 1) or hovering_tile.j == cal.cols:
            go_left = True
        if go_left:
            rect = hovering_rect.x - cal.border_width, hovering_rect.top, hovering_rect.x, hovering_rect.bottom
        else:
            rect = hovering_rect.right, hovering_rect.top, hovering_rect.right + cal.border_width, hovering_rect.bottom
        if hovering_rect.x + (self.middle_drag_placement_factor * hovering_rect.w) <= x2 <= hovering_rect.right - (self.middle_drag_placement_factor * hovering_rect.w):
            on_edge = False
        print(f"on_edge: {on_edge}")
        if on_edge:
            self.DRAG_PLACEMENT_MARKER_1 = rect
        else:
            rect = [hovering_rect.center[0] - (cal.border_width / 2), hovering_rect.top,
                    hovering_rect.center[0] + (cal.border_width / 2), hovering_rect.bottom]
            self.DRAG_PLACEMENT_MARKER_2 = rect

        return selected, cal, canvas_rect, x2, y2

    def hover(self, event):
        x, y = event.x, event.y
        cal = self.get_current_calendar()
        canvas_rect = self.get_current_cal_canvas_rect()
        r, c = cal.x_y_to_r_c(x, y, canvas_rect)
        tile_n = cal.r_c_to_i(r, c)
        # print(f"x, y : {x}, {y}, r,c: ({r}, {c}), w,h: ({cal.col_width(c, canvas_rect)}, {cal.row_height(r, canvas_rect)}), tile_N: {tile_n}")
        do_draw = False
        if self.USE_HOVER:
            cal.set_zoom(tile_n)
            do_draw = True
        if do_draw:
            self.draw_calendar()

        # canvas = self.TAB_DATA[self.CAL_IDX]["canvas_cal"]
        # canvas.create_oval(cal.get_rect(tile_n, canvas_rect), fill=rgb_to_hex(DODGERBLUE_2))
        # canvas.create_oval((x - 5, y - 5, x + 5, y + 5), fill=rgb_to_hex(DODGERBLUE_2))

    def leave(self, event):
        x, y = event.x, event.y
        cal = self.get_current_calendar()
        cal.clear_zoom()
        self.draw_calendar()
        
    def drag(self, event):
        selected, cal, canvas_rect, x2, y2 = self.calculate_dpms(event)

        if selected:
            for tile in selected:
                cal.dragging = tile.ser
                x1, y1, w, h = cal.get_rect(tile.ser, canvas_rect)
                xd = 1
                yd = 1
                if x2 < x1:
                    xd *= -1
                if y2 < y1:
                    yd *= -1
                tile.drag_x = x2 - x1
                tile.drag_y = y2 - y1
        dragging = cal.get_dragging()
        print(f"dragging: e: {event}, drag: {dragging}")
        self.draw_calendar()
        # dragging = cal.get_dragging()
        # if dragging:
        #     for tile in dragging:
        #         ti = tile.ser
        #         tile = cal.tiles[ti]
        #         # rh = cal.row_height(ti, canvas_rect)
        #         # cw = cal.col_width(ti, canvas_rect)
        #         rect = cal.get_rect(ti, canvas_rect)
        #         rect[0] += x2
        #         rect[1] += y2
        #         canvas.create_rectangle(rect, fill=rgb_to_hex(tile.colour_dragging))

    def click(self, event):
        x, y = event.x, event.y
        cal = self.get_current_calendar()
        canvas_rect = self.get_current_cal_canvas_rect()
        r, c = cal.x_y_to_r_c(x, y, canvas_rect)
        cbw = cal.border_width
        canvas_rect = Rect2(cbw, cbw, self.width, self.height)
        tile_n = cal.r_c_to_i(r, c)
        tile = cal.tiles[tile_n]
        cal.selected = tile_n
        print(f"Aclick: e: {event}, tile.selected: {tile.selected}")
        # tile.selected = not tile.selected
        # cal.colour = cal.colour_selected
        self.draw_calendar()
        print(f"Bclick: e: {event}, tile.selected: {tile.selected}")
        self.update_tile_control()

    def release(self, event):
        cal = self.get_current_calendar()
        canvas_rect = self.get_current_cal_canvas_rect()
        x, y = event.x, event.y
        tile = cal.tile_at_x_y(x, y, canvas_rect)
        dragging = cal.get_dragging()
        do_swap = False
        selected, cal, canvas_rect, x2, y2 = self.calculate_dpms(event)
        if dragging and tile and dragging != tile:
            # TODO release a dragging tile over an existing tile.
            is_empty = tile.is_empty()
            drag_tile, *drag_rest = dragging
            print(f"releasing over tile: {tile.ser}")
            if is_empty:
                print(f"inserting drag_tile: {drag_tile.ser}, into empty tile space {tile.ser}")
                do_swap = True
            else:
                print(f"NEED TO SWAP, dpm1: {self.DRAG_PLACEMENT_MARKER_1}, dpm2: {self.DRAG_PLACEMENT_MARKER_2}")
                # if self.DRAG_PLACEMENT_MARKER_1:
                #     print("dropping on the edge")
                # elif self.DRAG_PLACEMENT_MARKER_2:
                if self.DRAG_PLACEMENT_MARKER_2:
                    print("dropping in the middle")
                    do_swap = True
                else:
                    if drag_tile.line == tile.line:
                        # same line swap
                        self.shift_line_units(tile, 1)
                    else:
                        self.shift_line_units(tile, 1)
                cal.clear_selected()

            if do_swap:
                print("PERFORMING SWAP")
                if self.ASSERT_SAME_LINE_SWAP:
                    if drag_tile.line != tile.line:
                        easygui.msgbox(self.ERMSG_NO_CROSS_LINE_SWAP)

                cal.swap_tiles(drag_tile, tile)
                cal.clear_selected()
            # else:
        elif tile == dragging:
           print("can't replace a tile with the same tile")

        # ensure to delete these after calling calculate_dps
        self.DRAG_PLACEMENT_MARKER_1 = None
        self.DRAG_PLACEMENT_MARKER_2 = None
        cal.clear_dragging()
        self.draw_calendar()

    def update_tile_control(self):
        """When a tile is selected, update the usage of the mini tile control notebook widget."""
        cal = self.get_current_calendar()
        selected = cal.get_selected()
        self.clear_tile_control_fields()
        if selected:
            selected, *rest_selected = selected
            if selected:
                curr_tab = self.TABS_tile_control[self.TCTL_IDX]
                if not selected.is_empty():
                    self.tctl_tv_wo_num.set(f"{selected.wo_num}")
                    self.tctl_tv_model.set(f"{selected.model_name}")
                    self.tctl_tv_dealer.set(f"{selected.dealer}")
                    self.tctl_tv_status.set(f"{selected.status}")
                    self.tctl_tv_beam.set(f"{selected.beam}")
                    self.tctl_tv_start_date.set(f"{selected.job_start}")
                    self.tctl_tv_serial.set(f"{selected.serial}")
                    self.tctl_tv_quote.set(f"{selected.quote}")
                # if self.TCTL_IDX == 0:
                #     # + / -
                #
                # if self.TCTL_IDX == 1:
                #     # Add
                # if self.TCTL_IDX == 2:
                #     # Delete

    def bind_calendar(self):
        self.notebook_tab_control.bind("<<NotebookTabChanged>>", self.on_tab_change)
        self.notebook_tile_control.bind("<<NotebookTabChanged>>", self.on_tctl_tab_change)
        for i, tab in enumerate(self.TABS):
            canvas = self.TAB_DATA[i]["canvas_cal"]
            bindings = {
                "<Motion>": self.hover,
                "<Leave>": self.leave,
                "<B1-Motion>": self.drag,
                "<Button-1>": self.click,
                "<ButtonRelease-1>": self.release
            }
            for bnd, fnc in bindings.items():
                if i == self.CAL_IDX:
                    canvas.bind(bnd, fnc)
                else:
                    canvas.unbind(bnd)

    def clear_tile_control_fields(self):
        self.tctl_tv_wo_num.set("")
        self.tctl_tv_model.set("")
        self.tctl_tv_dealer.set("")
        self.tctl_tv_status.set("")
        self.tctl_tv_beam.set("")
        self.tctl_tv_start_date.set("")
        self.tctl_tv_serial.set("")
        self.tctl_tv_quote.set("")

    def tctl_save_click(self):
        cal = self.get_current_calendar()
        selected = cal.get_selected()
        if selected:
            selected, *rest_selected = selected
            wo_num_new = self.tctl_tv_wo_num.get()
            model_name_new = self.tctl_tv_model.get()
            dealer_new = self.tctl_tv_dealer.get()
            status_new = self.tctl_tv_status.get()
            beam_new = self.tctl_tv_beam.get()
            start_date_new = self.tctl_tv_start_date.get()
            serial_new = self.tctl_tv_serial.get()
            quote_new = self.tctl_tv_quote.get()

            wo_num_old = selected.wo_num
            model_name_old = selected.model_name
            dealer_old = selected.dealer
            status_old = selected.status
            beam_old = selected.beam
            start_date_old = selected.job_start
            serial_old = selected.serial
            quote_old = selected.quote

            # TODO need to scrub input here
            if wo_num_old != wo_num_new:
                selected.wo_num = wo_num_new
                cal.log({"Update WO": {
                    "tidx": selected.ser,
                    "old": wo_num_old,
                    "new": wo_num_new
                }})

            if model_name_old != model_name_new:
                selected.model_name = model_name_new
                cal.log({"Update ModelName": {
                    "tidx": selected.ser,
                    "old": model_name_old,
                    "new": model_name_new
                }})

            if dealer_old != dealer_new:
                selected.dealer = dealer_new
                cal.log({"Update Dealer": {
                    "tidx": selected.ser,
                    "old": dealer_old,
                    "new": dealer_new
                }})

            if status_old != status_new:
                selected.status = status_new
                cal.log({"Update Status": {
                    "tidx": selected.ser,
                    "old": status_old,
                    "new": status_new
                }})

            if beam_old != beam_new:
                selected.beam = beam_new
                cal.log({"Update Beam": {
                    "tidx": selected.ser,
                    "old": beam_old,
                    "new": beam_new
                }})

            if start_date_old != start_date_new:
                selected.job_start = start_date_new
                cal.log({"Update StartDate": {
                    "tidx": selected.ser,
                    "old": start_date_old,
                    "new": start_date_new
                }})

            if serial_old != serial_new:
                selected.serial = serial_new
                cal.log({"Update Serial": {
                    "tidx": selected.ser,
                    "old": serial_old,
                    "new": serial_new
                }})

            if quote_old != quote_new:
                selected.quote = quote_new
                cal.log({"Update Quote": {
                    "tidx": selected.ser,
                    "old": quote_old,
                    "new": quote_new
                }})

    def tctl_undo_click(self):
        print("undo!!")

    def save_changes_update_server(self):
        print("save_changes_update_server")

    def menu_control_undo_click(self):
        print("menu_control_undo_click")

    def move_next_period(self, tile, cal_idx=None):
        """Move a given tile from the given cal_idx to the next calendar in the same line"""
        cal_idx = self.CAL_IDX if cal_idx is None else cal_idx
        curr_cal = self.TAB_DATA[cal_idx]["Cal"]
        print(f"MOVING {tile} to next period ({cal_idx} -> {cal_idx + 1})")
        if cal_idx >= len(self.TABS) - 1:
            curr_cal.log({
                "Moving CalendarTileNextPeriod": {
                    "tile": str(tile),
                    "cal_idx": cal_idx
                }
            })

            # self.TABS[len(self.TABS)] = None
            self.TABS.append(None)
            self.TAB_DATA[len(self.TABS)] = None
            self.TAB_NAMES.append(self.new_tab_name())

            new_tab_obj = self.new_tab_obj()
            new_tab_dat_obj = self.new_tab_dat_obj()
            new_tab_dat_obj["Tab"] = new_tab_obj

            print(f"new_tab_dat_obj: {new_tab_dat_obj}")
            # print(f"A VIEW: {self.TAB_DATA[len(self.TAB_DATA) - 1]}")
            key = len(self.TAB_DATA) - 1
            self.TAB_DATA[key] = new_tab_dat_obj
            print(f"B VIEW: {self.TAB_DATA[key]}")

            label_cal_title = tkinter.Label(new_tab_obj, text="Production Schedule" + str(len(self.TAB_DATA) - 1) + "\n{} - {}")
            # .format(dt.datetime.strftime(last_date, "%Y-%m-%d"), dt.datetime.strftime(c_end_date, "%Y-%m-%d")))
            frame_calendar = tkinter.Frame(new_tab_obj)
            canvas_cal = tkinter.Canvas(frame_calendar, height=self._tile_bounds.height,
                                            width=self._tile_bounds.width, bg=rgb_to_hex(GRAY_12))
            # canvas_header_left = tkinter.Canvas(frame_calendar, height=self._tile_bounds.height + self.TILE_BORDER_WIDTH, width=60, bg=rgb_to_hex(INDIGO))  # left legend
            # can_header_top = tkinter.Canvas(frame_calendar, height=25, width=self._tile_bounds.height + 60 + self.TILE_BORDER_WIDTH, bg=rgb_to_hex(BLACK))  # top legend
            canvas_header_left = tkinter.Canvas(frame_calendar, height=self.HEADER_LEFT_HEIGHT,
                                                    width=self.HEADER_LEFT_WIDTH, bg=rgb_to_hex(BLACK))  # left legend
            can_header_top = tkinter.Canvas(frame_calendar, height=self.HEADER_TOP_HEIGHT,
                                                width=self.HEADER_TOP_WIDTH, bg=rgb_to_hex(BLACK))  # top legend
            canvas_pop_up = tkinter.Menu(frame_calendar, tearoff=0)
            self.TAB_DATA[key].update(
                    {"Name": self.TAB_NAMES[-1], "frame_calendar": frame_calendar, "canvas_cal": canvas_cal,
                     "canvas_header_left": canvas_header_left, "canvas_header_top": can_header_top,
                     "canvas_pop_up": canvas_pop_up})

            # canvas_pop_up.pack()
            frame_calendar.pack()
            canvas_header_left.pack(side=tkinter.LEFT)
            can_header_top.pack()
            canvas_cal.pack()

            start_date = end_of_month(curr_cal.dates[-1]) + datetime.timedelta(days=1)
            end_date = end_of_month(start_date)
            data = pandas.DataFrame(data={
                "WO#": [tile.wo_num],
                "InputField1": [tile.model_name],
                "InputField2": [tile.dealer],
                "Stock/Sold": [tile.status],
                "Beam WO#": [tile.beam],
                "JobStartDate": [tile.job_start]
            })
            lines = curr_cal.lines
            dates = []
            td = start_date
            while td <= end_date:
                if td.isoweekday() < 6:
                    dates.append(td)
                td = td + datetime.timedelta(days=1)
            psc = self.create_calendar_p(start_date, end_date, data, lines, dates)
            print(f"PSC: {psc}, type: {type(psc)}")
            print(f"UPDATING calIDX: {len(self.TAB_DATA) - 1}")
            assert psc is not None, "PSC IS NONE !!!"
            tab_name = self.TAB_NAMES[-1]
            new_tab_dat_obj.update({"Cal": psc})
            self.TAB_DATA[key].update({"Cal": psc})
            print(f"new_tab_obj: {new_tab_obj}, type: {type(new_tab_obj)}")
            print(f"self.notebook_tab_control: {self.notebook_tab_control}, type: {type(self.notebook_tab_control)}")
            print(f"new Tab name <{tab_name}>")
            self.notebook_tab_control.add(new_tab_obj, text=tab_name)

            # raise PSCalendar2.CalendarException(f"Error no nore calendars to move this unit forward to. \n'{tile}'")
            # lines = curr_cal.lines
            # month_ranges = []
            # months_ahead = 1
            # start_date = end_of_month(curr_cal.dates[-1]) + datetime.timedelta(days=1)
            # td = datetime2(start_date.year, start_date.month, start_date.day, start_date.hour, start_date.minute,
            #                start_date.second)
            # for mi in range(months_ahead):
            #     month_ranges.append((first_of_month(td), end_of_month(td)))
            #     td = td.add_month()
            # start_date, end_date = month_ranges[0]
            # # lines, dates, data = await self.get_data(start_date, end_date)
            # data = pandas.DataFrame()
            # dates = []
            # td = start_date
            # while td <= end_date:
            #     dates.append(td)
            #     td = td + datetime.timedelta(days=1)
            # new_cal = self.create_calendar_p(start_date, end_date, data, lines, dates, style_in=None)
            #
            # # from here I have to recreate all calendar objects, add them to the pscFrame Tabs lists and redraw everything.
            # # TODO not doing this for V1
            # self.TABS[len(self.TABS)] =
            # self.TAB_DATA[len(self.TABS)] =
            # self.TAB_NAMES[len(self.TABS)] =

        line = tile.line
        curr_cal = self.TAB_DATA[cal_idx]["Cal"]
        next_cal = self.TAB_DATA[cal_idx + 1]["Cal"]
        print(dict_print(self.TAB_DATA[cal_idx], "A"))
        print(dict_print(self.TAB_DATA[cal_idx + 1], "B"))
        print(f"TAB_DATA: {len(self.TAB_DATA)}: {self.TAB_DATA.keys()}")
        print(f"TAB_DATA: {len(self.TAB_DATA)}: {self.TAB_DATA}")
        print(f"CURRCAL CAL_IDX: {self.CAL_IDX}: {curr_cal}")
        print(f"NEXTCAL CAL_IDX: {self.CAL_IDX}: {next_cal}")
        if line not in next_cal.lines:
            raise ValueError(f"Error cannot move {tile} forward because there is no matching line in the next period.")
        insert_result = next_cal.insert(tile)
        if insert_result is not None:
            print(f"inner_result: {insert_result}")
            # at this point, trying to insert a brand new unit on the first day of the next calendar. Need to shift line first though.
            self.shift_line_units(insert_result)

        old = self.CAL_IDX
        self.CAL_IDX = len(self.TABS) - 1
        self.draw_calendar()
        self.CAL_IDX = old

    def shift_line_units(self, start_tile, n_days=1):
        print(f"START TILE: {start_tile}")
        n_days = 1  # TODO HARDCODED THIS CAP
        line = start_tile.line
        curr_cal = self.get_current_calendar()
        start_row, start_col = start_tile.i, start_tile.j

        bring_to_end = False
        for i in range(len(self.TABS) - 1, self.CAL_IDX - 1, -1):
            stop_col = start_tile.j
            cal = self.TAB_DATA[i]["Cal"]
            print(f"i: {i}, cal: {cal}")
            line_idx = cal.lines.index(line)
            if i > self.CAL_IDX:
                stop_col = 0
            for j in range(cal.cols - 1, stop_col, -1):
                k1 = cal.r_c_to_i(line_idx, j)
                k2 = cal.r_c_to_i(line_idx, j - 1)
                tile_a = cal.tiles[k1]
                tile_b = cal.tiles[k2]
                # print(f"SWAP i,j: ({i}, {j}) a: {tile_a.ser}, b: {tile_b.ser}")
                if not tile_a.is_empty() and tile_a.j == cal.cols - 1:
                    # TODO this just cycles the entire line
                    print("swapping to next calendar")
                    if not tile_b.is_empty() and tile_b.j == cal.cols - 2:
                        bring_to_end = True
                    cal.delete(tile_a)
                    self.move_next_period(tile_a, cal_idx=i)
                else:
                    # if abs(tile_a.ser - tile_b.ser) != 1:
                    #     print(f"abs(tile_a.ser - tile_b.ser) != 1: a: {tile_a.ser}, b: {tile_b.ser}, cal: {i}")
                    cal.swap_tiles(tile_a, tile_b)

            if bring_to_end:
                # TODO this still dosesnt work as advertised
                print("BRINGING TO END")
                idx = cal.r_c_to_i(start_tile.i, cal.cols - 1)
                cal.swap_tiles(start_tile, cal.tiles[idx])
        # drawing the calendar on return to calling function

    def get_calendars(self):
        return [self.TAB_DATA[i]["Cal"] for i in range(len(self.TABS))]

    def date_new_unit(self):
        # at this point safeties have been checked, just add the tile - even if something is already there.
        print("DATING NEW UNIT")
        cal = self.get_current_calendar()
        ct = self.tctl_new_unit_obj
        cal.tiles[ct.ser] = ct
        self.tctl_new_unit_obj = None
        self.draw_calendar()

    def clear_unit_fields(self):
        self.lb_chosen_new_row.set("")
        self.lb_chosen_new_col.set("")
        self.lb_chosen_new_unit.set("")
        self.canvas_tctl_view_tile.delete("all")

    def update_new_view_window(self):
        print(f"updating unit view")
        cal = self.get_current_calendar()
        lines = cal.lines
        dates = cal.dates
        r, c = lines.index(self.lb_chosen_new_row.get()), dates.index(datetime.datetime.strptime(self.lb_chosen_new_col.get(), "%Y-%m-%d %H:%M:%S"))
        ser = cal.r_c_to_i(r, c)
        if not cal.tiles[ser].is_empty():
            self.canvas_tctl_view_tile.delete("all")
            print("clear!")
            self.btn_tctl_add_new_tile.config(state="disabled")
            self.tctl_new_unit_obj = None
        else:
            self.btn_tctl_add_new_tile.config(state="normal")
            wo = self.lb_chosen_new_unit.get()
            line = cal.lines[r]
            date = cal.dates[c]
            colour = cal.colour_tile_general
            colour_border = cal.colour_border
            colour_font = cal.colour_font
            colour_selected = cal.colour_selected
            colour_hovered = cal.colour_hovered
            colour_dragging = cal.colour_dragging
            ct = CalendarTile2(ser, r, c, line, date, colour, colour_border, colour_font, colour_selected, colour_hovered, colour_dragging, DO_COPY=True)
            bounds = [0, 0, self.tctl_preview_width, self.tctl_preview_height]
            rect = Rect2(bounds[0], bounds[1], bounds[2] - bounds[0], bounds[3] - bounds[1])
            print(f"NEW TILE: {ct}, rect: {rect}, bounds: {bounds}")
            self.tctl_new_unit_obj = ct
            # TODO HARDCODED HERE
            ct.set_data(wo, "MODEL_NAME", "DEALER", "STATUS", "JOB", "BEAM_START", "SERIAL", "QUOTE")
            ct.edited = False
            bgc, outline, tt = self.get_tile_colour(cal, ct, new_background=True)
            self.canvas_tctl_view_tile.create_rectangle(*rect2_to_tkinter(rect), fill=rgb_to_hex(bgc), outline=rgb_to_hex(outline))
            self.canvas_tctl_view_tile.create_text(rect.x + (rect.w / 2), rect.y + (rect.h / 2), text=tt, fill=rgb_to_hex(font_foreground(bgc)), font=self.font)

    def new_unit_change(self, *args):
        wo, i, j = self.lb_chosen_new_unit.get(), self.lb_chosen_new_col.get(), self.lb_chosen_new_row.get()
        if all([wo, i, j]):
            self.update_new_view_window()

    def new_row_change(self, *args):
        wo, i, j = self.lb_chosen_new_unit.get(), self.lb_chosen_new_col.get(), self.lb_chosen_new_row.get()
        if all([wo, i, j]):
            self.update_new_view_window()

    def new_col_change(self, *args):
        wo, i, j = self.lb_chosen_new_unit.get(), self.lb_chosen_new_col.get(), self.lb_chosen_new_row.get()
        if all([wo, i, j]):
            self.update_new_view_window()

    def new_tab_name(self):
        tab_names = self.TAB_NAMES
        tab_ns = [int(name.split("+")[1].split(" ")[0]) for name in tab_names if "+" in name]
        print(f"TAB_NS: {tab_ns}")
        if tab_ns:
            last_name = tab_ns[-1]
            return f"+{last_name + 1} Months"
        return f"NEW TAB {len(self.TAB_NAMES) + 1}"

# def rect2_to_tkinter(rect):
#     assert isinstance(rect, Rect2), "Error value is not a valid Rect2 object."
#     return [rect.x, rect.y, rect.w + rect.x, rect.h + rect.y]

#  PSCalendar
#     - selected
#     - hovering, width=200