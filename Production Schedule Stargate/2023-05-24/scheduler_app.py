import calendar
import datetime
import sys
import os
import json
import tkinter
import webbrowser

import pdfkit

from settings_initializer import SettingsWriter
from html_utility import html_to_pdf
from tkinter_utility import *
from tkinter import messagebox

from datetime_utility import *
from colour_demo import ColourWidget
from calendar_surface import *
from line_shift_demo import LineShifter
from utility import Rect2, print_by_line
from bs4 import BeautifulSoup


class App(tkinter.Tk):

    def __init__(
            self,
            SETTINGS_FILE,
            PROGRAM_MODE,
            TITLE="Stargate Production Scheduler",
            WIDTH=500,
            HEIGHT=500,
            restart_handle=None,
            can_width_p=0.85,
            can_height_p=0.65,
            colour_background_frame_top_bar=Colour(78, 15, 15).hex_code,
            warn_weekends: bool = True,
            illegal_saturday: bool = True,
            illegal_sunday: bool = True,
            pdf_dir="C:/Access/STGProdSched/PDFs",
            html_dir="C:/Access/STGProdSched/HTMLs",
            dark_mode=True
    ):
        super().__init__()

        self.PROGRAM_MODE = PROGRAM_MODE
        self.SETTINGS_FILE = SETTINGS_FILE
        self.directory_pdf = pdf_dir
        self.directory_html = html_dir
        self.start_date = None
        self.df_production = None
        self.df_work_days = None
        self.df_valid_users = None
        self.df_used_lines = None
        self.this_user_is_valid = None
        self.this_user_publishes = None
        self.user_name = None
        self.dark_mode = dark_mode
        self.populate_data()
        self.init_stgprodsched_directory()
        self.init_queries_directory()
        self.init_pdfs_directory()
        self.init_html_directory()

        if self.user_name is None:
            tkinter.messagebox.showerror(title="Fatal",
                                         message="Error, you do not currently have permission to use this application.\nPlease contact IT for further assistance.")
            sys.exit()
        if self.df_production is None or self.df_work_days is None or self.df_valid_users is None or self.this_user_is_valid is None or self.this_user_publishes is None:
            tkinter.messagebox.showerror(title="Fatal", message="Error, unable to load production data")
            sys.exit()
        if not self.this_user_is_valid:
            tkinter.messagebox.showerror(title="Fatal",
                                         message="Error, you are not currently a vailid production schedule updater. Please contact IT for further assistance.")
            sys.exit()

        print(f"\n\t" + "\n\t".join([f"{n.ljust(30)} - {v}" for n, v in zip(
            ["self.user_name", "self.start_date", "self.this_user_is_valid", "self.this_user_publishes"],
            [self.user_name, self.start_date, self.this_user_is_valid, self.this_user_publishes]
        )]))

        self.colour_schemes = {
            "fg_infor_frame_quote_hyperlink": "#3222ee"
        }

        ###############################################################################################################
        # State variables
        ###############################################################################################################
        self.valid_app_states = ["IDLE", "DRAGGING", "SELECTED"]
        self._app_state = "IDLE"
        self.min_calendar_search_char_threshold = 3
        self.drag_tile_queue = []
        self.drag_text_queue = []
        self.drag_tile = None
        self.drag_text = None
        self.dragging_details = None
        self.select_tile = None
        self.select_text = None
        self.select_details = None
        self.removed_quotes = []  # use this to track quotes removed from the combo list.
        self.warn_weekends = warn_weekends
        self.illegal_saturday = illegal_saturday
        self.illegal_sunday = illegal_sunday
        self.dirty = tkinter.BooleanVar(self, value=False)

        ###############################################################################################################
        #  Tkinter variables and set-up
        ###############################################################################################################
        self.TITLE = TITLE
        self.WIDTH = WIDTH
        self.HEIGHT = HEIGHT
        self.width_p = can_width_p
        self.height_p = can_height_p
        self.geometry(f"{self.WIDTH}x{self.HEIGHT}")
        self.state("zoomed")
        self.title(self.TITLE)
        self.update()  # call here to get valid w_info dimensions below
        self.window_width = self.winfo_width()
        self.window_height = self.winfo_height()
        self.restart_handle = restart_handle

        self.colour_background_frame_top_bar = colour_background_frame_top_bar

        self.frame_top_bar = tkinter.Frame(self, name="frame_top_bar", background=self.colour_background_frame_top_bar)

        can_w, can_h = int(self.window_width * self.width_p), int(self.window_height * self.height_p)
        self.frame_calendar_a = tkinter.Frame(self, name="frame_calendar_a")
        self.frame_calendar_b = tkinter.Frame(self.frame_calendar_a, name="frame_calendar_b")
        self.frame_top_bar_a = tkinter.Frame(self.frame_top_bar, name="frame_top_bar_a")
        self.frame_top_bar_b = tkinter.Frame(self.frame_top_bar, name="frame_top_bar_b")
        self.frame_top_bar_c = tkinter.Frame(self.frame_top_bar, name="frame_top_bar_c")
        self.frame_top_bar_d = tkinter.Frame(self.frame_top_bar, name="frame_top_bar_d")
        self.frame_top_bar_e = tkinter.Frame(self.frame_top_bar, name="frame_top_bar_e")
        self.frame_top_bar_f = tkinter.Frame(self.frame_top_bar, name="frame_top_bar_f")
        self.frame_top_bar_g = tkinter.Frame(self.frame_top_bar, name="frame_top_bar_g")

        self.frame_toggles_sat_sun = tkinter.Frame(self.frame_top_bar_f, name="frame_toggles_sat_sun")

        self.tl_search_choice = None
        self.tl_search_choice_frame = None
        self.tag_tl_search_choice = "tl_search_choice"

        self.tl_multi_combo = None
        self.tag_tl_multi_combo = "tl_multi_combo"
        self.var_multi_combo_unit_popped = tkinter.BooleanVar(self, value=False)

        used_lines = self.df_used_lines["Prod Line"].values.tolist()
        if dark_mode:
            self.calendar_surface = CalendarSurface(self.frame_calendar_b, PROGRAM_MODE=self.PROGRAM_MODE,
                                                    lines=used_lines, user_name=self.user_name,
                                                    width=can_w, height=can_h, dirty_status_var=self.dirty,
                                                    start_date=self.start_date, weekend_proportion=0.1,
                                                    illegal_saturday=self.illegal_saturday,
                                                    illegal_sunday=self.illegal_sunday)
        else:
            self.calendar_surface = CalendarSurface(self.frame_calendar_b, PROGRAM_MODE=self.PROGRAM_MODE,
                                                    lines=used_lines, user_name=self.user_name,
                                                    width=can_w, height=can_h, dirty_status_var=self.dirty,
                                                    start_date=self.start_date, weekend_proportion=0.1,
                                                    illegal_saturday=self.illegal_saturday,
                                                    illegal_sunday=self.illegal_sunday,

                                                    # colours for date axis legend (Y)
                                                    row_legend_background_colour=rgb_to_hex(GRAY_60),
                                                    row_legend_outline_colour=rgb_to_hex(BLACK),
                                                    row_legend_active_background_colour="#e2e0ee",
                                                    row_legend_active_outline_colour=rgb_to_hex(BLACK),

                                                    # colours for trailer line axis legend (X)
                                                    col_legend_background_colour=rgb_to_hex(GRAY_60),
                                                    col_legend_outline_colour=rgb_to_hex(BLACK),
                                                    col_legend_active_background_colour="#e2e0ee",
                                                    col_legend_active_outline_colour=rgb_to_hex(BLACK),

                                                    # regular tile colour
                                                    tile_background_colour=rgb_to_hex(GRAY_99),
                                                    tile_outline_colour=rgb_to_hex(BLACK),
                                                    active_fill_colour=rgb_to_hex(GRAY_90),
                                                    active_outline_colour=rgb_to_hex(YELLOW_3),

                                                    # weekend tile colour
                                                    tile_wkd_background_colour=Colour(STARGATE_BLUE).hex_code,
                                                    tile_wkd_outline_colour=rgb_to_hex(GRAY_8),
                                                    active_wkd_fill_colour=Colour(STARGATE_BLUE).brighten(0.25).hex_code,
                                                    active_wkd_outline_colour=rgb_to_hex(GRAY_8),

                                                    # other colours
                                                    selected_colour=rgb_to_hex(CADETBLUE),
                                                    drag_colour=rgb_to_hex(CORNFLOWERBLUE),
                                                    )
        print(f"{list(enumerate(self.df_production.columns))=}")
        self.calendar_surface.populate_units(self.df_production)
        self.calendar_surface.dirty_status_var.set(False)  # reset to false after tile initialization.

        # self.combo_unit_selection = ttk.Combobox(self.frame_top_bar, values=self.dat_list_of_units(remove_placed=True), textvariable=self.tv_combo_unit_selection, state="readonly")

        # self.tv_label_combo_unit_selection,\
        # self.label_combo_unit_selection,\
        # self.tv_combo_unit_selection,\
        # self.combo_unit_selection\
        #     = combo_factory(
        #         self.frame_top_bar_b,
        #         tv_label="Select a Quote#",
        #         kwargs_combo={
        #             "name": "selection_combo",
        #             "values": self.dat_list_of_units(remove_placed=True, remove_beyond=True),
        #             "state": "readonly"
        #         }
        # )
        self.multi_combo_unit_selection = MultiComboBox(
            self.frame_top_bar_b,
            self.dat_list_of_units(remove_placed=True, remove_beyond=True),
            auto_grid=False,
            tv_label="Select a Quote #:",
            height_in_rows=8,
            lock_result_col="SGQuote",
            viewable_column_widths=[90, 85, 180, 170, 140],
            limit_to_list=False
            # limit_to_list=True
        )

        # self.multi_combo_unit_selection.configure(background="tan")

        # self.tv_label_combo_unit_selection, \
        self.label_combo_unit_selection = self.multi_combo_unit_selection.res_label
        self.tv_combo_unit_selection = self.multi_combo_unit_selection.res_tv_entry
        self.combo_unit_selection = self.multi_combo_unit_selection.res_entry

        self.tv_btn_insert_combo_choice, \
            self.button_insert_combo_choice \
            = button_factory(
            self.frame_top_bar_b,
            tv_btn="+",
            kwargs_btn={
                "background": rgb_to_hex(GRAY_17),
                "foreground": rgb_to_hex(WHITE),
                "font": ("Arial", 16)
            }
        )
        self.button_insert_combo_choice.config(command=self.click_insert_combo_choice)

        self.tv_btn_update_changes, \
            self.button_update_changes \
            = button_factory(
            self.frame_top_bar_c,
            tv_btn="Commit",
            kwargs_btn={
                "name": "button_update"
            },
            command=self.click_update_sql
        )

        self.tv_btn_undo, \
            self.button_undo \
            = button_factory(
            self.frame_top_bar_c,
            tv_btn="<",
            kwargs_btn={
                "name": "button_undo"
            },
            command=self.click_undo
        )

        self.tv_btn_redo, \
            self.button_redo \
            = button_factory(
            self.frame_top_bar_c,
            tv_btn=">",
            kwargs_btn={
                "name": "button_redo"
            },
            command=self.click_redo
        )

        self.tv_btn_refresh, \
            self.button_refresh \
            = button_factory(
            self.frame_top_bar_c,
            tv_btn="Refresh",
            kwargs_btn={
                "name": "button_refresh"
            },
            command=self.click_refresh
        )

        self.tv_btn_print_schedule, \
            self.btn_print_schedule \
            = button_factory(
            self.frame_top_bar_c,
            tv_btn="Print",
            kwargs_btn={
                "name": "button_print"
            },
            command=self.print_schedule
        )

        # self.tv_label_unit_scroll_search,\
        # self.label_unit_scroll_search,\
        # self.tv_entry_unit_scroll_search,\
        # self.entry_unit_scroll_search \
        #     = entry_factory(
        #         self.frame_top_bar_a,
        #         tv_label="Search Calendar:"
        # )

        self.tv_entry_unit_scroll_search = tkinter.StringVar(self, value="")
        self.entry_unit_scroll_search = EntryWithPlaceholder(
            self.frame_top_bar_a,
            textvariable=self.tv_entry_unit_scroll_search,
            font=('arial', 10, 'normal'),
            placeholder="Quote# or Date"
        )

        self.tv_label_submit_unit_search, \
            self.button_submit_unit_search \
            = button_factory(
            self.frame_top_bar_a,
            tv_btn="Search Calendar",
            kwargs_btn={
                "name": "button_submit_search",
                "command": self.click_search_units
            }
        )

        self.tv_label_button_go_to_today, \
            self.button_go_to_today \
            = button_factory(
            self.frame_top_bar_a,
            tv_btn="Go To Today",
            kwargs_btn={
                "name": "button_go_to_today"
            },
            command=self.click_go_to_today
        )
        # self.tv_entry_unit_scroll_search.trace_variable("w", self.unit_search_update)

        # canvas and calendar objects
        # self.tv_btn_scroll_left, self.button_scroll_left = button_factory(self.frame_calendar_a, tv_btn="left", kwargs_btn={"command": self.click_left_scroll})
        # self.tv_btn_scroll_right, self.button_scroll_right = button_factory(self.frame_calendar_a, tv_btn="right", kwargs_btn={"command": self.click_right_scroll})

        # colour coder
        self.frame_colour_coder = ColourWidget(self.frame_top_bar_d, dealers=self.dat_list_of_dealers(),
                                               default_colour=rgb_to_hex(GRAY_17))
        self.tv_label_colour_coder = tkinter.StringVar(self, value="Colour Code By Dealer:")
        self.label_colour_coder = tkinter.Label(self.frame_top_bar_d, textvariable=self.tv_label_colour_coder)
        self.canv_btn_show_colour_coder = ArrowButton(self.frame_top_bar_d)
        self.canv_btn_show_colour_coder.bind("<Button-1>", self.click_show_colour_coder)

        # line shifter
        dates = self.calendar_surface.dates_list
        min_date, max_date = utility.minmax(dates)
        # print(f"{min_date=}, {max_date=}")
        self.line_shifter = LineShifter(self.frame_top_bar_e, lines=["All"] + self.calendar_surface.lines,
                                        min_date=min_date, max_date=max_date)
        self.tv_ls_start_date = self.line_shifter.odp_start_date.tv_date
        self.tv_ls_end_date = self.line_shifter.odp_end_date.tv_date
        self.tv_ls_start_date.trace_variable("w", self.update_ls_start_date)
        self.tv_ls_end_date.trace_variable("w", self.update_ls_end_date)
        self.tv_label_line_shifter = tkinter.StringVar(self, value="Shift Lines:")
        self.label_line_shifter = tkinter.Label(self.frame_top_bar_e, textvariable=self.tv_label_line_shifter)
        self.canv_btn_show_line_shifter = ArrowButton(self.frame_top_bar_e)
        self.canv_btn_show_line_shifter.bind("<Button-1>", self.click_show_line_shifter)

        self.frame_colour_coder.status_code.trace_variable("w", self.colour_coder_update)

        for r, tile_row in enumerate(self.calendar_surface.tiles):
            for c, tile in enumerate(tile_row):
                self.calendar_surface.tag_bind(tile, "<Double-Button-1>", self.dbl_click_tile)
                self.calendar_surface.tag_bind(tile, "<Double-3>", self.dbl_right_click_tile)

        self.calendar_scroll_bar = tkinter.Scrollbar(self.frame_calendar_b, orient="horizontal",
                                                     command=self.calendar_surface.xview, )
        self.calendar_surface.configure(xscrollcommand=self.calendar_scroll_bar.set)

        # Info Frame
        self.info_frame_labels = [
            "SGQuote#",
            "WO#",
            "Model No",
            "Dealer",
            "Serial #",
            "Customer WO#",
            "Galvanized",
            "Prod Date",
            "Delivery Date"
        ]
        self.frame_info_frame = InfoFrame(
            self.frame_top_bar_g,
            labels=self.info_frame_labels,
            auto_grid=True,
            key_width=25,
            val_width=25,
            width=50,
            background="#77a1ee",
            padx=10,
            pady=10,
            cell_border=True
        )
        ke_il = self.frame_info_frame.de_keyify(self.info_frame_labels[0])
        quote_label_data = self.frame_info_frame.info_labels[ke_il]
        if_qu_tv, if_qu_lb = quote_label_data["v_tv"], quote_label_data["v_label"]

        col_scheme = self.colour_schemes
        if_qu_lb.configure(foreground=col_scheme["fg_infor_frame_quote_hyperlink"])
        if_qu_lb.bind("<Button-1>", self.click_info_frame_quote_hyperlink)
        if_qu_lb.bind("<Double-Button-1>", self.click_info_frame_quote_hyperlink)

        ################################################################################################################
        # Begin Testing widgets
        ################################################################################################################
        self.tv_label_testing_frame, \
            self.label_testing_frame \
            = label_factory(
            self.frame_top_bar_f,
            tv_label="Testing Mode Enabled",
            kwargs_label={
                "foreground": rgb_to_hex(RED_3)
            }
        )

        self.tv_btn_export_changes, \
            self.button_export_changes \
            = button_factory(
            self.frame_top_bar_f,
            tv_btn="export",
            kwargs_btn={
                "name": "button_export"
            }
        )
        self.button_export_changes.bind("<Button-1>", self.click_export_sql, True)

        self.debug_tv_show_history, \
            self.debug_show_history \
            = button_factory(
            self.frame_top_bar_f,
            tv_btn="show history",
            kwargs_btn={
                "name": "debug_show_history",
                "command": self.click_debug_show_history
            }
        )

        self.tv_label_debug_app_state, \
            self.debug_label_entry_app_state, \
            self.tv_debug_app_state, \
            self.debug_entry_app_state \
            = entry_factory(
            self.frame_top_bar_f,
            tv_label="App State:",
            tv_entry=self.app_state,
            kwargs_entry={
                "name": "debug_appstate",
                "state": "readonly"
            }
        )

        self.debug_tv_show_scrollregion, \
            self.debug_show_scrollregion \
            = button_factory(
            self.frame_top_bar_f,
            tv_btn="show scrollregion",
            kwargs_btn={
                "name": "debug_show_scrollregion",
                "command": self.click_debug_show_scrollregion
            }
        )

        self.toggle_button_sat = ToggleButton(
            self.frame_toggles_sat_sun,
            labels=None,
            label_text="Sat",
            state=not self.illegal_saturday,
            width_label=5
        )

        self.toggle_button_sun = ToggleButton(
            self.frame_toggles_sat_sun,
            labels=None,
            label_text="Sun",
            state=not self.illegal_sunday,
            width_label=5,
            auto_grid=(0, 1)
        )

        ###############################################################################################################
        #   bind event handlers
        ###############################################################################################################
        self.calendar_surface.status.trace_variable("w", self.calendar_surface_status_update)
        self.calendar_surface.bind("<Button-1>", self.click_calendar_surface)
        self.calendar_surface.bind("<Button-3>", self.click_calendar_surface_left)
        self.calendar_surface.bind("<ButtonRelease-1>", self.release_calendar_surface)
        self.calendar_surface.bind("<Motion>", self.motion_calendar_surface)
        self.frame_calendar_b.bind('<Configure>', self.onFrameConfigure)
        # self.calendar_surface.bind_all("<MouseWheel>", lambda event: self.xview('scroll', int(-1*(event.delta/120)), 'units'))
        self.calendar_surface.bind("<MouseWheel>",
                                   lambda event: self.xview(event, 'scroll', int(-1 * (event.delta / 120)), 'units'))
        self.line_shifter.status.trace_variable("w", self.line_shifter_update)
        self.entry_unit_scroll_search.bind("<Return>", self.click_search_units)

        self.multi_combo_unit_selection.tree_treeview.bind("<<TreeviewSelect>>", self.multi_combo_tree_selection_update)

        self.showing_colour_coder = tkinter.BooleanVar(self, value=False)
        self.showing_line_shifter = tkinter.BooleanVar(self, value=False)
        self.showing_colour_coder.trace_variable("w", self.update_showing_widgets)
        self.showing_line_shifter.trace_variable("w", self.update_showing_widgets)

        self.toggle_button_sat.state.trace_variable("w", self.update_toggle_sat)
        self.toggle_button_sun.state.trace_variable("w", self.update_toggle_sun)

        self.bind("<Control-p>", self.print_schedule)
        self.bind("<Control-z>", self.click_undo)
        self.bind("<Control-Shift-Z>", self.click_redo)

        ###############################################################################################################
        #  grid widgets
        ###############################################################################################################
        self.init_colour_code()
        self.grid_widgets()

        self.protocol("WM_DELETE_WINDOW", self.on_closing)

        # self.button_scroll_left.pack(side=tkinter.LEFT)
        # self.button_scroll_right.pack(side=tkinter.RIGHT)

    def init_colour_code(self):
        cs = "colour_scheme"
        data = self.settings_data
        if cs in data:
            dealers = self.settings_data[cs]
            if dealers is not None:
                for dealer, colour in dealers.items():
                    c = colour.lower()
                    self.frame_colour_coder.status[dealer.title()] = c
                    if c in self.frame_colour_coder.colours:
                        self.frame_colour_coder.remove_colour(c)
                    # else:
                    #     self.frame_colour_coder.colours
                    self.colour_coder_update(None, None, None, init_pass={"dealer": dealer, "colour": c})
                    # print(f"INIT {dealer=} with {c=}")
                    # print(dict_print(self.frame_colour_coder.status, "NEW STATUS"))

    def grid_keys(self):
        return "row", "column", "rowspan", "columnspan", "ipadx", "ipady", "padx", "pady", "sticky"

    def grid_widgets(self):
        r, c, rs, cs, ix, iy, x, y, s = self.grid_keys()
        self.grid()

        # frames for positioning
        self.frame_top_bar.grid(**{r: 0, c: 0, s: "ew"})
        self.frame_top_bar_b.grid(**{r: 0, c: 0})
        self.frame_top_bar_c.grid(**{r: 0, c: 1})
        self.frame_top_bar_d.grid(**{r: 0, c: 3})
        self.frame_top_bar_e.grid(**{r: 0, c: 4})
        self.frame_top_bar_g.grid(**{r: 0, c: 6})
        self.frame_top_bar_a.grid(**{r: 0, c: 2, rs: 2})

        # multi-column combobox
        self.multi_combo_unit_selection.grid(**{r: 0, c: 0, ix: 5, iy: 2})
        self.multi_combo_unit_selection.res_label.grid(**{r: 0, c: 0, ix: 5, iy: 2})
        self.multi_combo_unit_selection.frame_top_most.grid(**{r: 1, c: 0, s: "ew", ix: 5, iy: 2})
        self.multi_combo_unit_selection.res_entry.grid(row=0, column=0, sticky="ew", ipadx=5, ipady=2)
        self.multi_combo_unit_selection.res_canvas.grid(**{r: 0, c: 1})
        self.label_combo_unit_selection.grid(**{r: 0, c: 0, ix: 5, iy: 2})
        self.combo_unit_selection.grid(**{r: 1, c: 0, ix: 5, iy: 2})
        self.button_insert_combo_choice.grid(**{r: 2, c: 0, ix: 5, iy: 2})

        # widgets
        self.label_colour_coder.grid(**{r: 0, c: 0, ix: 5, iy: 2})
        self.canv_btn_show_colour_coder.grid(**{r: 0, c: 1})
        self.label_line_shifter.grid(**{r: 0, c: 0, ix: 5, iy: 2})
        self.canv_btn_show_line_shifter.grid(**{r: 0, c: 1})
        self.update_showing_widgets()

        # search widget
        self.entry_unit_scroll_search.grid(**{r: 1, c: 1, ix: 5, iy: 2})  # , sticky="ew")
        self.button_submit_unit_search.grid(**{r: 2, c: 1, ix: 5, iy: 2})  # , sticky="ew")
        self.button_go_to_today.grid(**{r: 3, c: 1, ix: 5, iy: 2})  # , sticky="ew")

        # control buttons
        self.button_update_changes.grid(**{r: 0, c: 0, cs: 2, ix: 5, iy: 2})
        self.button_refresh.grid(**{r: 1, c: 0, cs: 2, ix: 5, iy: 2})
        self.btn_print_schedule.grid(**{r: 2, c: 0, cs: 2, ix: 5, iy: 2})
        self.button_undo.grid(**{r: 3, c: 0, ix: 5, iy: 2})
        self.button_redo.grid(**{r: 3, c: 1, ix: 5, iy: 2})

        # calendar widget
        self.frame_calendar_a.grid(**{r: 1, c: 0, s: "ew", ix: 5, iy: 2})
        self.frame_calendar_b.grid(**{ix: 5, iy: 2})
        self.calendar_surface.grid(**{r: 1, c: 1, s: "ew", ix: 5, iy: 2})
        self.calendar_scroll_bar.grid(**{r: 2, c: 1, s: "ew", ix: 5, iy: 2})

        if self.PROGRAM_MODE == "TEST":
            self.frame_top_bar_f.grid(**{r: 0, c: 5, ix: 5, iy: 2})
            self.label_testing_frame.grid()
            self.button_export_changes.grid()
            self.debug_label_entry_app_state.grid()
            self.debug_entry_app_state.grid()
            self.debug_show_history.grid()
            self.debug_show_scrollregion.grid()
            self.frame_toggles_sat_sun.grid()

    def init_tl_multi_combo(self):
        self.tl_multi_combo = tkinter.Toplevel()

    def click_show_colour_coder(self, *args):
        print(f"\tclick_show_colour_coder")
        self.showing_colour_coder.set(not self.showing_colour_coder.get())
        # self.update_showing_widgets()

    def click_show_line_shifter(self, *args):
        print(f"\tclick_show_line_shifter")
        self.showing_line_shifter.set(not self.showing_line_shifter.get())
        # self.update_showing_widgets()

    def update_showing_widgets(self, *args):
        print(f"\t\tupdate_showing_widgets")
        if self.showing_colour_coder.get():
            self.frame_colour_coder.grid(row=1, column=0, columnspan=2, ipadx=5, ipady=2)
            self.canv_btn_show_colour_coder.change_direction("n")
        else:
            self.frame_colour_coder.grid_forget()
            self.canv_btn_show_colour_coder.change_direction("s")

        if self.showing_line_shifter.get():
            self.line_shifter.grid(row=1, column=0, columnspan=2, ipadx=5, ipady=2)
            self.canv_btn_show_line_shifter.change_direction("n")
        else:
            self.line_shifter.grid_forget()
            self.canv_btn_show_line_shifter.change_direction("s")

    def update_toggle_sat(self, *args):
        print(f"update saturday toggle: {self.toggle_button_sat.state.get()}")
        self.calendar_surface.toggle_saturday()

    def update_toggle_sun(self, *args):
        print(f"update sunday toggle: {self.toggle_button_sun.state.get()}")

    def update_ls_start_date(self, *args):
        dt = self.line_shifter.odp_start_date.tv_date.get()
        print(f"update_ls_start_date {dt=}")
        if is_date(dt):
            self.line_shifter.update_status()

    def update_ls_end_date(self, *args):
        dt = self.line_shifter.odp_end_date.tv_date.get()
        print(f"update_ls_end_date {dt=}")
        if is_date(dt):
            self.line_shifter.update_status()

    def calendar_surface_status_update(self, *args):
        status_data = eval(self.calendar_surface.status.get())
        code = status_data.get("code")
        msg = status_data.get("msg")
        print(f"calendar_surface_status_update {code=}, {msg=}")
        match code:
            case 1:
                # bind self.calendar_surface with action events
                self.bind_calendar_surface()
                self.bind_top_frame()
            case 2:
                # unbind action events from self.calendar_surface for pop-up
                self.unbind_calendar_surface()
                self.unbind_top_frame()
            case _:
                pass

    def print_schedule(self, *event):
        print(f"print_schedule")
        # FILE_NAME = "test.pdf"
        # # pdf = pdf_writer_old.PDF(FILE_NAME, 'L', 'mm', (600, 750))
        # pdf = pdf_writer.PDF(FILE_NAME)
        # pdf.set_auto_page_break(True, margin=5)
        # pdf.set_title("Stargate Production Schedule")  # TODO needs start and end dates
        # pdf.set_author('Avery Briggs')
        # pdf.add_page()
        # pdf.margin_border(STARGATE_BLUE, WHITE)
        # pdf.time_stamp()

        n_info_lines = 6
        dates = self.calendar_surface.dates_list
        lines = self.calendar_surface.lines
        contents = {l: {d: self.calendar_surface.tile_properties[i][j]["unit_in"] for j, d in enumerate(dates) if
                        self.calendar_surface.tile_properties[i][j]["unit_in"]} for i, l in enumerate(lines)}
        # min_date, max_date = utility.minmax(flatten([list(contents[line].keys()) for line in contents]))
        # content = {line: {} for line in lines}
        #
        # dd = (max_date - min_date).days
        # for d in range(dd):
        #     t_date = min_date + datetime.timedelta(days=d)
        #     found = False
        #     for j, l in enumerate(lines):
        #         value = self.calendar_surface.tile_properties[j][d]["unit_in"]
        #         if value:
        #             found = True
        #             content[l][t_date] = value
        #     if not found:
        #         content[lines[0]][t_date] = None
        #
        # print(f"\n{min_date=}\n{max_date=}\n")
        # for k, v in content.items():
        #     print(f"{k=}\t{len(v)=}\t{v=}")
        # # raise Exception("STOP!!!")
        #
        # pdf.table(
        #     title="demo_table",
        #     x=0,
        #     y=0,
        #     w=200,
        #     # contents=pdf_writer.random_test_set(12),
        #     contents=content,
        #     desc_txt="demo description text."
        # )

        min_date, max_date = utility.minmax(dates)

        xd = (max_date.month + (12 * max_date.year))
        nd = (min_date.month + (12 * min_date.year))
        # td = 1 + xd - nd
        td = relativedelta(max_date, min_date).months + (12 * relativedelta(max_date, min_date).years)

        print(f"1 {dates=}")
        # dates = [d for d in dates if min_date <= d and d <= max_date]

        print(f"{min_date=}, {max_date=}")
        print(f"{xd=}, {nd=}, {td=}")
        print(f"2 {dates=}")

        content = {i: {line: {} for line in lines} for i in range(td + 1)}
        print(f"A {content=}")

        for i, d in enumerate(dates):
            if (d.isoweekday() % 7 not in [0, 6]):
                # t_date = min_date + datetime.timedelta(days=)
                f_date = d.strftime("%Y-%m-%d")
                mi = (d.month + (12 * d.year)) - nd
                print(f"{i=}, {f_date=}, {mi=}")
                for j, l in enumerate(lines):
                    # value = self.calendar_surface.tile_properties[j][i]["unit_in"]
                    value = self.calendar_surface.tile_properties[j + 1][i + 1]["unit_in"]
                    if value:
                        value = value.calendar_repr()
                    else:
                        value = "\n" * n_info_lines
                    value = value.replace("\n", "<br>")
                    print(f"\t{i=}, {j=}, {f_date=}, {l=}, {value=}")
                    # k = f"{d:%A\n%Y-%m-%d}"
                    # k = f"{d:%a\n%Y-%m-%d}"
                    k = f"{d:%a}, {d.day}{date_suffix(d)}"
                    content[mi][l][k] = value
            # else:
            #     print(f"{d=}")

        # print(f"{content=}")

        # content
        # x     | day1  | day2   | day 2
        # Line1 |       | unit1  |
        # Line2 | unit2 | unit3  |
        pdf_dir = self.directory_pdf
        html_dir = self.directory_html
        file_out = f"{html_dir}/html_output_{datetime.datetime.now():%Y-%m-%d_%H_%M_%S}.html"
        pdf_file_out = f"{pdf_dir}/pdf_output_{datetime.datetime.now():%Y-%m-%d_%H_%M_%S}.pdf"

        # t_style = f"<style>@media print {{table {{width: 100%; height: 100%;}}"
        # t_style = f"{t_style} @page {{size: 11in 17in; margin: 0;}}}}</style>"

        # t_style = f"<style> table {{max-width: 5100px; width: 100%; max-height: 3100px; height: 100%; table-layout: auto;}}</style>"
        t_style = f"<style>html, body {{height: 100%; margin: 0; padding: 0;}}"
        # t_style = f"{t_style} table {{max-width: 5100px; width: 100%; max-height: 3100px; height: 100%; table-layout: auto;}}</style>"
        t_style = f"{t_style} table {{max-width: 5100px; width: 100%; table-layout: auto;}}"
        t_style = f"{t_style} h2 {{page-break-before: always;}}"
        t_style = f"{t_style} .table-wrapper {{display: flex; flex-direction: column; height: 100%;}}"
        t_style = f"{t_style} tr {{flex-grow: 1;}}"
        t_style = f"{t_style}</style>"

        smi = min_date.month - 1
        t_title = f"<title>Page Title</title>"
        html = f"<!DOCTYPE html><html><head>{t_title}{t_style}</head><body>"
        print(f"FIN {content=}")
        print(f"{list(content.keys())=}")
        for month, data in content.items():
            # print(f"{data['date'].items()=}")
            y = (min_date + relativedelta(months=month)).year
            mn = calendar.month_name[((smi + month) % 12) + 1]
            html = f"{html}<H2>{mn} {y}</H2>"
            # print(f"{month=} {mn} {smi + month}")
            df_content = pd.DataFrame(data).transpose().fillna("")
            html = f"{html}<div class='table-wrapper'>{df_content.to_html(escape=False)}</div>"
            # print(f"{df_content.to_html()=}")
        html = f"{html}</body></html>"

        soup = BeautifulSoup(html, "html.parser")
        html = soup.prettify()

        with open(file_out, 'w') as f:
            f.write(html)

        print(f"{file_out=}\n{pdf_file_out=}")
        options = {
            "page-size": "tabloid",
            "orientation": "Landscape",
            'margin-top': '0.5in',
            'margin-right': '0.5in',
            'margin-bottom': '0.5in',
            'margin-left': '0.5in',
            'encoding': "UTF-8",
        }
        html_to_pdf(file_out, pdf_file_out, do_open=True, options=options, do_quit=True)

        # # TODO configure this for each computer.
        # wkhtmltopdf_path = r"C:\Program Files\wkhtmltopdf\bin\wkhtmltopdf.exe"
        # if not os.path.exists(wkhtmltopdf_path):
        #     # print(f"Error, please install wkhtmltopdf before continuing")
        #     try:
        #         print(f"Checking Environment Vars for wkhtmltopdf")
        #         config = pdfkit.configuration()
        #     except OSError:
        #         # not present in path
        #         print(f"Error, wkhtmltopdf not found in path either. Please install before continuing")
        #         sys.exit()
        #
        # options = {
        #     "page-size": "tabloid",
        #     "orientation": "Landscape",
        #     'margin-top': '0.5in',
        #     'margin-right': '0.5in',
        #     'margin-bottom': '0.5in',
        #     'margin-left': '0.5in',
        #     'encoding': "UTF-8",
        # }
        # config = pdfkit.configuration(wkhtmltopdf=wkhtmltopdf_path)
        # pdfkit.from_file(file_out, pdf_file_out, configuration=config, options=options)
        #
        # # from weasyprint import HTML
        # # HTML(file_out).write_pdf(pdf_file_out)
        #
        # webbrowser.open(pdf_file_out)
        #
        # # # content = {i: {line: {} for line in lines} for i in range(td)}
        # # content = {i: {line:  for line in lines} for i in range(td)}
        # #
        # # # print(f"\n{self.calendar_surface.tile_properties[0]=}\n{type(self.calendar_surface.tile_properties)=}")
        # #
        # # # print(f"\n\tBEFORE\n{content=}\n")
        # #
        # # dd = (max_date - min_date).days
        # # for d in range(dd):
        # #     t_date = min_date + datetime.timedelta(days=d)
        # #     f_date = t_date.strftime("%Y-%m-%d")
        # #     mi = (t_date.month + (12 * t_date.year)) - nd
        # #     print(f"{d=}, {mi=}, {f_date=}")
        # #     found = False
        # #     for j, l in enumerate(lines):
        # #         value = self.calendar_surface.tile_properties[j][d]["unit_in"]
        # #         if value:
        # #             found = True
        # #             content[mi][l][f_date] = value
        # #     if not found:
        # #         print(f"\tFN\t\t{d=}, {mi=}, {f_date=}")
        # #         content[mi][lines[0]][f_date] = None
        # #
        # # # print(f"\n\tAFTER\n{content=}\n")
        # #
        # # # print(f"\n{min_date=}\n{max_date=}\n")
        # # for k, v in content.items():
        # #     print(f"\n\t{k=}\n\t{len(v)=}\n")
        # #     for k1, v1 in v.items():
        # #         print(f"\n\t\t{k1=}\n\t\t{v1=}\n")
        # #
        # # # content
        # # # x     | day1  | day2   | day 2
        # # # Line1 |       | unit1  |
        # # # Line2 | unit2 | unit3  |
        # # file_out = f"html_output_{datetime.datetime.now():%Y-%m-%d_%H_%M_%S}.html"
        # # html = f"<!DOCTYPE html><html><head><title>Page Title</title></head><body>"
        # # for month, data in content.items():
        # #     # print(f"{data['date'].items()=}")
        # #     # df_content = pd.DataFrame({f"{k:%Y-%m-%d}": v for k, v in data["date"].items()}).transpose()
        # #     df_content = pd.DataFrame(data).transpose().fillna("")
        # #     html = f"{html}{df_content.to_html()}"
        # #     # for day, value in month.items():
        # # html = f"{html}</body></html>"
        # # with open(file_out, 'w') as f:
        # #     f.write(html)
        # #
        # # webbrowser.open(file_out)
        # #
        # # # raise Exception("STOP!!!")
        # #
        # # # df2table(self.df_production, title="DEMO", show_table=True)
        # #
        # # # for i in content:
        # # #     pdf.table(
        # # #         title=f"demo_table #{i}",
        # # #         x=0,
        # # #         y=0,
        # # #         w=200,
        # # #         # contents=pdf_writer.random_test_set(12),
        # # #         contents=content[i],
        # # #         desc_txt="demo description text."
        # # #     )
        # # #     break
        # # #
        # # # pdf.output(FILE_NAME, 'F')
        # # # pdf.open_in_browser()

    def multi_combo_tree_selection_update(self, *args):
        self.multi_combo_unit_selection.treeview_selection_update(*args)
        selections = self.multi_combo_unit_selection.tree_treeview.selection()
        if selections:
            q_id = int(selections[0])
            print(f"{q_id=}")
            # print(f"{self.multi_combo_unit_selection.data=}")
            # print(f"{self.multi_combo_unit_selection.data['SGQuote']=}")
            quote = self.multi_combo_unit_selection.data["SGQuote"].tolist()[q_id]
            print(f"SELECTED Quote: {quote}")
            self.update_info_frame(quote)

    def unbind_top_frame(self):
        self.line_shifter.disable_all_widgets()
        self.frame_colour_coder.disable_all_widgets()

        self.combo_unit_selection.configure(state="disabled")
        self.button_insert_combo_choice.configure(state="disabled")
        self.button_refresh.configure(state="disabled")
        self.button_undo.configure(state="disabled")
        self.button_redo.configure(state="disabled")
        self.button_update_changes.configure(state="disabled")
        self.button_export_changes.configure(state="disabled")
        self.entry_unit_scroll_search.configure(state="disabled")
        self.button_submit_unit_search.configure(state="disabled")

    def bind_top_frame(self):
        self.line_shifter.enable_all_widgets()
        self.frame_colour_coder.enable_all_widgets()

        self.combo_unit_selection.configure(state="normal")
        self.button_insert_combo_choice.configure(state="normal")
        self.button_refresh.configure(state="normal")
        self.button_undo.configure(state="normal")
        self.button_redo.configure(state="normal")
        self.button_update_changes.configure(state="normal")
        self.button_export_changes.configure(state="normal")
        self.entry_unit_scroll_search.configure(state="normal")
        self.button_submit_unit_search.configure(state="normal")

    def bind_calendar_surface(self):
        print(f"bind_calendar_surface")
        self.calendar_surface.configure(xscrollcommand=self.calendar_scroll_bar.set)
        self.calendar_surface.bind("<Button-1>", self.click_calendar_surface)
        self.calendar_surface.bind("<Button-3>", self.click_calendar_surface_left)
        self.calendar_surface.bind("<ButtonRelease-1>", self.release_calendar_surface)
        self.calendar_surface.bind("<Motion>", self.motion_calendar_surface)
        self.frame_calendar_b.bind('<Configure>', self.onFrameConfigure)
        # self.calendar_surface.bind_all("<MouseWheel>", lambda event: self.xview('scroll', int(-1*(event.delta/120)), 'units'))
        self.calendar_surface.bind("<MouseWheel>",
                                   lambda event: self.xview(event, 'scroll', int(-1 * (event.delta / 120)), 'units'))

    def unbind_calendar_surface(self):
        print(f"unbind_calendar_surface")
        # self.calendar_surface.unbind_all("all")
        # self.calendar_surface.configure(xscrollcommand=self.calendar_scroll_bar_x.set)
        self.calendar_surface.unbind("<Button-1>")
        self.calendar_surface.unbind("<Button-3>")
        self.calendar_surface.unbind("<ButtonRelease-1>")
        self.calendar_surface.unbind("<Motion>")
        self.frame_calendar_b.unbind('<Configure>')
        # self.calendar_surface.bind_all("<MouseWheel>", lambda event: self.xview('scroll', int(-1*(event.delta/120)), 'units'))
        self.calendar_surface.unbind("<MouseWheel>")

    def on_closing(self):
        if self.dirty.get() and messagebox.askokcancel("Quit?", "Do you want to quit?"):
            match ans2 := messagebox.askyesnocancel("Save?", "Do you want to commit your session?"):
                case True:
                    self.click_update_sql(are_u_sure=True)
                case _:
                    pass
            if ans2 is not None:
                self.destroy()
        if not self.dirty.get():
            self.destroy()

    def init_stgprodsched_directory(self):
        if not os.path.isdir("C:/Access/STGProdSched"):
            os.mkdir("C:/Access/STGProdSched")
        if not os.path.isdir("./STGProdSched"):
            os.mkdir("./STGProdSched")

    def init_queries_directory(self):
        if not os.path.isdir("C:/Access/STGProdSched/Queries"):
            os.mkdir("C:/Access/STGProdSched/Queries")
        if not os.path.isdir("./STGProdSched/Queries"):
            os.mkdir("./STGProdSched/Queries")

    def init_pdfs_directory(self):
        if not os.path.isdir("C:/Access/STGProdSched/PDFs"):
            os.mkdir("C:/Access/STGProdSched/PDFs")
        if not os.path.isdir("./STGProdSched/PDFs"):
            os.mkdir("./STGProdSched/PDFs")

    def init_html_directory(self):
        if not os.path.isdir("C:/Access/STGProdSched/HTMLs"):
            os.mkdir("C:/Access/STGProdSched/HTMLs")
        if not os.path.isdir("./STGProdSched/HTMLs"):
            os.mkdir("./STGProdSched/HTMLs")

    def verify_user(self, user_name):
        if user_name is None:
            return user_name
        return check_user(user_name)

    def read_settings_data(self):
        data = {}
        try:
            with open(self.SETTINGS_FILE, "r") as f:
                data = json.load(f)
                # data = j
                # user_name = j.get("user_name", None)
                # print(f"READ USER {user_name=}, {j=}")
        except FileNotFoundError as fnf:
            print(fnf)
            messagebox.showerror(title="Settings",
                                 message="Error no file named '{C:/Access/PDS_User_Setting.json}' found.")

        return data

    def populate_data(self):
        """Mass Database Query 'Getter' Function. Should be called at the beginning of app execution, or using a thread."""
        # self.df_production = connect(**SQL_ALL_DATED_STG_UNITS)
        self.settings_data = self.read_settings_data()
        self.start_date = datetime.datetime.strptime(
            self.settings_data.get("start_date", datetime.datetime.now().strftime("%Y-%m-%d")), "%Y-%m-%d")
        self.df_production = connect(**SQL_ALL_STG_UNITS)

        # print(f"A {list(self.df_production.columns)=}")
        # print(f"A {len(list(self.df_production.columns))=}")

        self.df_work_days = connect(**SQL_ALL_STG_PROD_DAYS)
        self.df_valid_users = connect(**SQL_VALID_USERS)
        self.df_used_lines = connect(**SQL_USED_LINES)
        self.user_name = self.verify_user(self.settings_data.get("user_name", ""))
        self.this_user_is_valid = not self.df_valid_users.query(f"UserName == '{self.user_name}'").empty
        self.this_user_publishes = self.this_user_is_valid and \
                                   self.df_valid_users[self.df_valid_users["UserName"] == self.user_name][
                                       "AllowPublish"].tolist()[0]
        if self.df_production.empty:
            self.df_production = None
        else:
            self.df_production = self.df_production.fillna("")
            self.df_production["Available Date"] = pandas.to_datetime(self.df_production["Available Date"],
                                                                      errors="coerce").dt.strftime('%Y-%m-%d')
            # self.df_production["WO#"] = int(self.df_production["WO#"]) if self.df_production["WO#"] else self.df_production["WO#"]
            # self.df_production.loc[self.df_production["WO#"], "WO#"] = int(self.df_production["WO#"])
            # self.df_production['WO#'] = np.where(isnumber(self.df_production['WO#']), 0, self.df_production['WO#'])
            # print(f"{[x for x in self.df_production['JobStartLine'].tolist() if x]=}")
            # print(f"{[x for x in self.df_production['WO#'].tolist() if x]=}")
        if self.df_work_days.empty:
            self.df_work_days = None

    def dat_list_of_units(self, remove_placed=False, remove_beyond=False):

        def pick(x):
            print(f"{x=}")
            y = x.split("||")
            y = [(z if z != "None" else None) for z in y]
            return (y[0] if y[0] else (y[1] if y[1] else y[2]))

        units = self.calendar_surface.units

        # dict_result = {}
        print(f"{self.df_production=}")

        result = self.df_production[
            [
                'OrdersV2_SGQuote',
                'dtProductionSchedule_SGQuote',
                'dtProductionScheduleV2_SGQuote',
                'OrdersV2_WO#',
                'dtProductionSchedule_WO#',
                'dtProductionScheduleV2_WO#',
                'Model No',
                "COMPANY NAME",
                "Serial Number",
                "Customer WO#"
            ]
        ].copy()
        assert isinstance(result, pd.DataFrame)
        picks_a = []
        picks_b = []
        for i in range(result.shape[0]):
            # print(f"\n{i=}")
            a, b, c = \
                result["OrdersV2_SGQuote"].loc[i], \
                    result["dtProductionSchedule_SGQuote"].loc[i], \
                    result["dtProductionScheduleV2_SGQuote"].loc[i]
            print(f"\t{a=}\t\t{b=}\t\t{c=}")
            d, e, f = \
                result["OrdersV2_WO#"].iloc[i], \
                    result["dtProductionSchedule_WO#"].iloc[i], \
                    result["dtProductionScheduleV2_WO#"].iloc[i]
            print(f"\t{d=}\t\t{e=}\t\t{f=}")
            picks_a.append(a if a else (b if b else c))
            x = d if d else (e if e else f)
            x = x if not x else int(x)
            picks_b.append(x)

        result["Customer WO#"] = result["Customer WO#"].fillna(0)
        result["Customer WO#"] = result["Customer WO#"].replace("", 0)
        result["Customer WO#"] = result["Customer WO#"].astype(int)
        result["Customer WO#"] = result["Customer WO#"].replace(0, "")
        result["Customer WO#"] = result["Customer WO#"].astype(str)
        result["SG1"] = picks_a
        result["WO1"] = picks_b
        result.drop("OrdersV2_SGQuote", axis=1, inplace=True)
        result.drop("dtProductionSchedule_SGQuote", axis=1, inplace=True)
        result.drop("dtProductionScheduleV2_SGQuote", axis=1, inplace=True)
        result.drop("OrdersV2_WO#", axis=1, inplace=True)
        result.drop("dtProductionSchedule_WO#", axis=1, inplace=True)
        result.drop("dtProductionScheduleV2_WO#", axis=1, inplace=True)
        result.rename(columns={
            'SG1': 'SGQuote',
            "COMPANY NAME": "Dealer",
            'WO1': 'WO#',
            "Serial Number": "Serial#"
        }, inplace=True)

        # # quotes = self.df_production["SGQuote"]
        # # print(f"{self.df_production[['SGQuote', 'WO#', 'Model No']]=}")
        # result = self.df_production[['SGQuote', 'WO#', 'Model No', "COMPANY NAME", "Serial Number"]]
        # # print(f"{result['SGQuote']=}\n{result['SGQuote'].iloc[0]=}")
        # # result["SG1"] =(
        # #     result["SGQuote"].iloc[0] + "||" +
        # #     result["SGQuote"].iloc[1] + "||" +
        # #     result["SGQuote"].iloc[2]
        # # ).agg(lambda x: pick(x))
        # picks_a = []
        # picks_b = []
        # for i in range(result.shape[0]):
        #     # print(f"\n{i=}")
        #     a, b, c =\
        #         result["SGQuote"].iloc[i][0],\
        #         result["SGQuote"].iloc[i][1],\
        #         result["SGQuote"].iloc[i][2]
        #     d, e, f =\
        #         result["WO#"].iloc[i][0],\
        #         result["WO#"].iloc[i][1],\
        #         result["WO#"].iloc[i][2]
        #     # print(f"\t{a=}\t\t{b=}\t\t{c=}")
        #     picks_a.append(a if a else (b if b else c))
        #     picks_b.append(d if d else (e if e else f))
        #
        # result["SG1"] = picks_a
        # result["WO1"] = picks_b
        # result.drop("SGQuote", axis=1, inplace=True)
        # result.drop("WO#", axis=1, inplace=True)
        # result.rename(columns={
        #     'SG1': 'SGQuote',
        #     "COMPANY NAME": "Dealer",
        #     'WO1': 'WO#',
        #     "Serial Number": "Serial#"
        # }, inplace=True)

        # print(f"\n\tA\n{result=}")
        #
        # print(f"{units=}")
        # print(f"{self.calendar_surface.tiles_beyond=}")

        if remove_placed:
            for unit_in, unit_o in units.items():
                print(f"{unit_in=}, {unit_o=}")
                # if unit_in == "SG100520":
                #     print(f"\n\n\n\n\n\n")
                #     for v in unit_o.__dict__:
                #         print(f"{v[1:]=}, {getattr(unit_in, v[1:], '__')=}")
                #     print(f"\n\n\n\n\n\n")
                #     # raise Exception("STOP!!!!!!!")
                if unit_in not in [None, "none", ""]:
                    if unit_o.placed:
                        assert isinstance(unit_o, Unit)
                        print(f"REMOVING\tp={unit_o.placed}\t{unit_in=}")
                        result = result[result["SGQuote"] != unit_in]

        if remove_beyond:
            for line, line_data in self.calendar_surface.tiles_beyond.items():
                for direction, units_in in line_data.items():
                    for unit_in in units_in:
                        if unit_in is not None:
                            # print(f"unit_in: {unit_in}")
                            # lst.remove(unit_in.SGQuote)
                            print(f"REMOVING BEYOND\t{unit_in=}")
                            result = result[result["SGQuote"] != unit_in]

        # print(f"\n\tB\n{result=}")

        # raise Exception("STOP!")
        return result[['SGQuote', 'WO#', 'Model No', "Dealer", "Serial#", "Customer WO#"]].reset_index(drop=True)

        # raise Exception("STOP!")
        #
        # for i, row in quotes.iterrows():
        #     print(f"{i=}, {row=}, {row.values=}")
        #     q_a, q_b, q_c = row.values
        #     print(f"{q_a=}, {q_b=}, {q_c}")
        #     error = False
        #     if q_a is not None:
        #         if (q_b and q_a != q_b) or q_c and (q_a != q_c):
        #             error = True
        #     elif q_b is not None:
        #         if (q_a and q_b != q_a) or q_c and (q_b != q_c):
        #             error = True
        #     elif q_c is not None:
        #         if (q_a and q_c != q_a) or q_b and (q_c != q_b):
        #             error = True
        #     if error:
        #         raise Exception("ERROR")
        #     dict_result[i] = (q_a if q_a is not None else (q_b if q_b is not None else q_c))
        #
        # print(f"{dict_result=}")
        #
        # for key in dict_result:
        #     row = self.df_production.iloc[key]
        #
        #
        #
        #
        #
        # # print(f"{units=}")
        # # print(f"{self.df_production['SGQuote'].values.tolist()=}")
        # # print(f"{self.df_production['SGQuote'].values.tolist()[0]=}")
        # # print(f"{self.df_production['SGQuote'].values.tolist()[0][0]=}")
        # # # (1 == (1 if not remove_placed else (1 if tup[0] not in units else 0)))
        # # print(f"{rem=}")
        # # lst = [tup[0] for tup in self.df_production["SGQuote"].values.tolist() if tup[0] is not None and (1 == (1 if not remove_placed else (1 if tup[0] in units else 0)))]
        # # lst = [tup[0] for tup in self.df_production["SGQuote"].values.tolist() if tup and (tup[0] is not None) and (tup[0][0] is not None)]
        # # lst = [tup[0] for tup in self.df_production["SGQuote"].values.tolist() if tup and (tup[0] is not None)]
        # # lst = [tup[0] for tup in self.df_production["SGQuote"].values.tolist() if tup]
        # lst = [tup[0] if tup[0] is not None else tup[1] for tup in self.df_production["SGQuote"].values.tolist() if tup and (tup[0] is not None or tup[1] is not None)]
        # print(f"{self.df_production['SGQuote']=}\n{type(self.df_production['SGQuote'])=}")
        # uniqueA = self.df_production["SGQuote"]
        # assert isinstance(uniqueA, pandas.DataFrame)
        # print(f"{uniqueA=}")
        # print(f"{uniqueA['SGQuote']=}")
        # # print(f"{lst=}")
        #
        #
        # if remove_placed:
        #     for unit_in, unit_o in units.items():
        #         # print(f"{unit_in=}")
        #         if unit_in not in [None, "none", ""]:
        #             if unit_o.placed:
        #                 lst.remove(unit_in)
        # if remove_beyond:
        #     for line, line_data in self.calendar_surface.tiles_beyond.items():
        #         for direction, units_in in line_data.items():
        #             for unit_in in units_in:
        #                 if unit_in is not None:
        #                     # print(f"unit_in: {unit_in}\n\t{lst}")
        #                     lst.remove(unit_in.SGQuote)
        # lst.sort()
        # # print(f"LST: {lst=}")
        # return lst

    def dat_list_of_dealers(self):
        print_by_line(self.df_production["InputField2"].values.tolist())
        # lst = list({tup[0] for tup in self.df_production["InputField2"].values.tolist() if
        #             tup[0]})
        lst = list({tup for tup in self.df_production["InputField2"].values.tolist() if tup})
        lst.sort()
        return lst

    def release_calendar_surface(self, event):
        print(f"RCS release {event=}")
        x, y = event.x, event.y
        dt = self.drag_tile
        ddt = self.dragging_details
        ht = self.calendar_surface.tile_at_xy((x, y))
        dt_rc = self.calendar_surface.tile_to_rc(dt)
        ht_rc = self.calendar_surface.tile_to_rc(ht)
        print(f"{dt=}, {ht=}, {dt_rc=}, {ht_rc=}")
        if ht_rc:
            if ht_rc[0] != 0 and ht_rc[1] != 0:
                print(f"HERE A")
                if self.app_state == "DRAGGING":
                    print(f"HERE B")
                    if dt != ht:
                        print(f"HERE C")
                        # releasing a dragged tile over a new position
                        print(f"DDT: <{ddt=}>")
                        unit_in = ddt["unit_in"]
                        ft = ddt["from_tag"]

                        self.app_state = "IDLE"
                        self.drag_tile = None
                        self.calendar_surface.itemconfigure(dt, state="hidden")
                        self.calendar_surface.itemconfigure(self.drag_text, state="hidden")

                        if unit_in:
                            # TODO double check that this day is not a weekend
                            print(f"HERE D")
                            if self.move_tile(ht, ft, unit_in):
                                print(f"MOVED!")
                    else:
                        # TODO investigate where a dragged tile goes when released over the same spot. ht == dt
                        # releasing a dragged tile on the same position.
                        self.app_state = "SELECTED"
                        self.select_details = {
                            "quote": ddt["quote"],
                            "unit_in": ddt["unit_in"],
                            "from_tag": ht
                        }
                        self.select_tile = dt
                        self.drag_tile = None
                        self.calendar_surface.itemconfigure(dt, state="hidden")
                        self.calendar_surface.itemconfigure(self.drag_text, state="hidden")
                        self.update_info_frame()
                else:
                    print(f"INVALID STATE")
        else:
            print(f"LET GO OFF CALENDAR")

    def enter_multi_combo_unit_and_search(self, quote):
        self.multi_combo_unit_selection.res_tv_entry.set(quote)
        self.multi_combo_unit_selection.update_typed_in(None)
        self.multi_combo_unit_selection.filter_treeview()
        is_hidden = self.multi_combo_unit_selection.tv_tree_is_hidden.get()
        if is_hidden:
            self.multi_combo_unit_selection.click_canvas_dropdown_button(None)

    def destroy_final_search_window(self):
        self.tl_search_choice.destroy()
        self.tl_search_choice = None

    def select_final_search(self, quote, key, value, where):
        # self.multi_combo_unit_selection.select(quote)
        print(f"FINAL SELECT QUOTE={quote}, {key=}, {value=}, {where=}")
        if self.tl_search_choice:
            self.destroy_final_search_window()
        if where == "combo_box":
            self.enter_multi_combo_unit_and_search(quote)
            # print(f"selecting combo box")
            # self.multi_combo_unit_selection.select(quote)
            # self.multi_combo_unit_selection.res_tv_entry.set(quote)
            # self.multi_combo_unit_selection.update_typed_in(None)
            # self.multi_combo_unit_selection.filter_treeview()
            # self.multi_combo_unit_selection.submit_typed_in(None)
        else:
            # "calendar_surface"
            self.tv_entry_unit_scroll_search.set(quote)
            self.click_search_units(None)

    def finalize_search_choice(self, options):
        m_rows = 20

        self.tl_search_choice = tkinter.Toplevel(self)
        self.tl_search_choice.grab_set()
        self.tl_search_choice.protocol("WM_DELETE_WINDOW", self.destroy_final_search_window)
        self.tl_search_choice_frame = tkinter.Frame(self.tl_search_choice)
        buttons = list(options.keys())
        buttons.sort()
        frames = []
        row_count = 0
        for i, quote in enumerate(buttons):
            opts = "\n".join(options[quote]["msgs"])
            key = options[quote]["keys"][0]
            val = options[quote]["vals"][0]
            where = options[quote]["wheres"][0]
            frames.append(
                tkinter.Frame(
                    self.tl_search_choice_frame,
                    borderwidth=2,
                    relief="groove",
                    width=200
                )
            )
            bf = button_factory(
                frames[-1],
                tv_btn=quote.upper(),
                command=lambda q=quote, k=key, v=val, w=where: self.select_final_search(q, k, v, w))
            lf = label_factory(frames[-1], tv_label=opts)
            frames[-1].columnconfigure(0, minsize=100)
            frames[-1].grid(row=i % m_rows, column=i // m_rows)
            bf[1].grid(row=0, column=0)
            lf[1].grid(row=0, column=1)
            row_count += 1
        self.tl_search_choice_frame.grid()

    def click_search_units(self, *args, pass_thru_date=None):
        text = self.tv_entry_unit_scroll_search.get().upper()
        bba = self.calendar_surface.bbox("all")
        bbaw = (bba[2] - bba[0])
        cw = self.calendar_surface.canvas_width
        print(f"{self.calendar_surface.units=}")
        handled = False
        results = {}
        date_in = is_date(text)
        is_date_in = date_in is not None
        if len(text) < self.min_calendar_search_char_threshold:
            messagebox.showerror(title="Calendar Search",
                                 message=f"Please enter at least {self.min_calendar_search_char_threshold} characters before trying to search.")
            return
        if text:
            if pass_thru_date is None and (text in self.calendar_surface.units):
                unit_in = self.calendar_surface.units[text]
                if unit_in.placed:
                    r_c = self.calendar_surface.quote_rc(text)
                    if r_c:
                        r, c = r_c
                        bbox = self.calendar_surface.rc_bbox((r, c))
                        x, y = int((bbox[0] - (cw / 2)) + ((bbox[2] - bbox[0]) / 2)), int(
                            bbox[1] + ((bbox[3] - bbox[1]) / 2))
                        # x, y = int(bbox[0] + ((bbox[2] - bbox[0]) / 2)) - (bbaw / 2), int(bbox[1] + ((bbox[3] - bbox[1]) / 2))
                        x /= bbaw

                        # self.calendar_surface.scan_dragto(x, y)
                        self.calendar_surface.xview_moveto(x)
                        self.re_draw_legend(None)
                        self.flash_tile(r, c)
                        print(f"found! Quote={text} at {r=}, {c=}, {x=}, {y=}")
                        handled = True
                elif unit_in.SGQuote or self.multi_combo_unit_selection.value_exists(unit_in.SGQuote):
                    messagebox.showinfo(title="Calendar Search", message="unit found in combo box.")

                    self.enter_multi_combo_unit_and_search(unit_in.SGQuote)

                    # self.tv_combo_unit_selection.set(text)
                    # self.combo_unit_selection.focus()
                    # self.multi_combo_unit_selection.select(unit_in.SGQuote)
                    self.re_draw_legend(None)
                    handled = True
                elif unit_in.SGQuote in self.calendar_surface.get_beyond_quotes():
                    d = unit_in.Available_Date
                    l = unit_in.job_start_line_v2
                    messagebox.showinfo(title="Calendar Search",
                                        message=f"Unit found beyond viewable range.\nLine: {l}\nDate: {d:%A, %B} {d.day}{date_suffix(d.day)} {d:%Y}")
                    handled = True
            elif pass_thru_date is None:

                search_units = True
                if is_date_in:
                    options = ["Include Units", "Just Calendar Days", "Cancel"]
                    # ans = tkinter.messagebox.askquestion(
                    #     title="Calendar Search",
                    #     message=f"Do you want to search units for date {date_in:%Y-%m-%d}, or just the calendar days?"
                    #     #options=options
                    # )
                    w, h = 800, 150
                    x, y = self.winfo_reqwidth(), self.winfo_reqheight()
                    x //= 2
                    y //= 2
                    x -= (w // 2)
                    y -= (h // 2)
                    cmb = CustomMessageBox(
                        title="Calendar Search",
                        w=w,
                        h=h,
                        x=x,
                        y=y,
                        msg=f"Do you want to search units for date {date_in:%Y-%m-%d}, or just the calendar days?",
                        b1=options[0],
                        b2=options[1],
                        b3=options[2],
                        ret_btn_text=True
                        #     #options=options
                    )
                    # assert isinstance(cmb, tkinter.Toplevel)
                    cmb.focus_set()
                    cmb.grab_set()
                    self.wait_window(cmb)
                    ans = cmb.choice.get()
                    print(f"{ans=}")
                    if options.index(ans) != 0:
                        search_units = False

                if search_units:
                    print(f"Need to search all units by all columns.")
                    print(f"Searching placed units")
                    f_unit = None
                    for unit, u_data in self.calendar_surface.units.items():
                        if unit:
                            print(f"unit= {unit}")
                            dat = u_data.__dict__
                            for key, val in dat.items():
                                if key != "_history":
                                    if text in str(val).upper():
                                        handled = True
                                        f_unit = unit
                                        where = "combo_box"
                                        if u_data.placed:
                                            where = "calendar_surface"
                                        # msg = f"Search term = {text}, Same value as {key=}: {val}"
                                        msg = f"Matches '{key.removeprefix('_')}', Value: '{str(val)[:50]}', Where: '{where}'"
                                        print(msg)
                                        if unit not in results:
                                            results[unit] = {"msgs": [], "keys": [], "vals": [], "wheres": []}
                                        results[unit]["msgs"].append(msg)
                                        results[unit]["keys"].append(key)
                                        results[unit]["vals"].append(val)
                                        results[unit]["wheres"].append(where)

                    print(dict_print(results, "Possible matches"))

                    # self.multi_combo_unit_selection.select(u_data.SGQuote)
                    #         break
                    # if handled:
                    #     break

                if handled:
                    # print(f"f_unit= {f_unit}")
                    if len(results) > 1:
                        self.finalize_search_choice(results)
                    else:
                        quote = list(results.keys())[0]
                        key = results[quote]["keys"][0]
                        val = results[quote]["keys"][0]
                        where = results[quote]["keys"][0]
                        self.select_final_search(quote, key, val, where)

            if not handled and (date_in is not None):
                print(f"DATE: {text=}, {date_in=}")
                if date_in in self.calendar_surface.dates_list:
                    idx = self.calendar_surface.dates_list.index(date_in)
                    r, c = 1, idx + 1
                    bbox = self.calendar_surface.rc_bbox((r, c))
                    x, y = int((bbox[0] - (cw / 2)) + ((bbox[2] - bbox[0]) / 2)), int(
                        bbox[1] + ((bbox[3] - bbox[1]) / 2))
                    # x, y = int(bbox[0] + ((bbox[2] - bbox[0]) / 2)) - (bbaw / 2), int(bbox[1] + ((bbox[3] - bbox[1]) / 2))
                    x /= bbaw

                    # self.calendar_surface.scan_dragto(x, y)
                    self.calendar_surface.xview_moveto(x)
                    self.re_draw_legend(None)
                    print(f"found! Date={text} at {r=}, {c=}, {x=}, {y=}")
            elif handled:
                pass
            else:
                messagebox.showerror(title="Search Error", message=f"Error, quote or date '{text}' not found.")

        else:
            messagebox.showerror(title="Search Error", message="Error, please enter a valid quote number or a date.")

    def update_info_frame(self, tile_in=None):
        # "SGQuote#",
        # "WO#",
        # "Model No",
        # "Dealer",
        # "Serial #",
        # "Customer WO#",
        # "Galvanized",
        # "Prod Date",
        # "Delivery Date"
        unit = None
        if tile_in is None:
            # use selected tile
            tile = self.select_tile
            if tile is not None:
                r_c = self.calendar_surface.tile_to_rc(tile)
                if r_c is not None:
                    r, c = r_c
                    unit = self.calendar_surface.tile_properties[r][c]["unit_in"]
        else:
            unit = self.calendar_surface.units[tile_in]

        print(f"{unit}")
        if unit is not None:
            labels = self.info_frame_labels
            values = [
                unit.SGQuote,
                unit.WO,
                unit.InputField1,
                unit.InputField2,
                unit.Serial_Number,
                unit.Customer_WO,
                unit.IsGalv,
                unit.Prod_Date_1,
                unit.Delivery_Date
            ]
            for k, v in zip(labels, values):
                self.frame_info_frame.change_value(k, v)

    def click_go_to_today(self):
        before = self.tv_entry_unit_scroll_search.get()
        self.tv_entry_unit_scroll_search.set(datetime.datetime.now().strftime("%Y-%m-%d"))
        self.click_search_units(None, pass_thru_date=True)
        self.tv_entry_unit_scroll_search.set(before)
        self.flash_today()

    def flash_today(self, slices=10, half_offset=250):
        d = datetime.datetime.now().date()
        d1, d2, d3 = d.year, d.month, d.day
        d = datetime.datetime(d1, d2, d3)
        # print(f"{self.calendar_surface.dates_list=}")
        di = self.calendar_surface.dates_list.index(d)
        lines = self.calendar_surface.lines
        tp = self.calendar_surface.tile_properties
        tags = [tp[i][di] for i in range(len(lines) + 1)]
        # print(f"{tags=}")

        rect_org_colours = [self.calendar_surface.itemcget(tg["tag_rect"], "fill") for tg in tags]
        rect_new_colours = [Colour(c).darkened(0.3) for c in rect_org_colours]
        grads = [[gradient(j, slices, *org_new_c, rgb=False) for i, org_new_c in enumerate(zip(rect_org_colours, rect_new_colours))] for j in range(slices)]
        rev_grads = grads[::-1]
        grads = grads + rev_grads
        # print(f"{grads=}\n{rect_org_colours=}\n{rect_new_colours=}\n{len(grads)=}\n{len(tags)=}\n{len(grads[0])=}")
        # print_by_line(grads)
        for j, grad in enumerate(grads):
            if j >= len(grads) // 2:
                o = half_offset
            else:
                o = 0
            for i, row in enumerate(tags):
                tg = row["tag_rect"]
                # print(f"{j=}, {i=}, {tg=}")
                self.after(100 + (15 * j) + (2 * i) + o, lambda t=tg, ii=i, jj=j: self.calendar_surface.itemconfigure(t, fill=grads[jj][ii]))

    def flash_quote(self, quote_in, slices=10, half_offset=250):
        quote_f = self.calendar_surface.quote_rc(quote_in)
        if quote_f:
            self.flash_tile(*quote_f, slices=slices, half_offset=half_offset)

    def flash_tile(self, i, j, slices=10, half_offset=250):
        tp = self.calendar_surface.tile_properties
        tags = [tp[i][j]]
        # print(f"{tags=}")

        rect_org_colours = [self.calendar_surface.itemcget(tg["tag_rect"], "fill") for tg in tags]
        rect_new_colours = [Colour(c).darkened(0.3) for c in rect_org_colours]
        grads = [[gradient(j, slices, *org_new_c, rgb=False) for i, org_new_c in enumerate(zip(rect_org_colours, rect_new_colours))] for j in range(slices)]
        rev_grads = grads[::-1]
        grads = grads + rev_grads
        # print(f"{grads=}\n{rect_org_colours=}\n{rect_new_colours=}\n{len(grads)=}\n{len(tags)=}\n{len(grads[0])=}")
        # print_by_line(grads)
        for j, grad in enumerate(grads):
            if j >= len(grads) // 2:
                o = half_offset
            else:
                o = 0
            for i, row in enumerate(tags):
                tg = row["tag_rect"]
                # print(f"{j=}, {i=}, {tg=}")
                self.after(100 + (15 * j) + (2 * i) + o, lambda t=tg, ii=i, jj=j: self.calendar_surface.itemconfigure(t, fill=grads[jj][ii]))

    def click_calendar_surface_left(self, event):
        """Delete a tile when right-clicking the mouse over a valid unit."""
        print(f"CCSL {event=}, {self.app_state=}")
        x, y = event.x, event.y
        rc = self.calendar_surface.rc_at_xy((x, y))
        # print(f"{rc=}")
        if rc:
            # print(f"--A")
            r, c = rc
            if r > 0 and c > 0:
                # print(f"--B")
                unit_in = self.calendar_surface.tile_properties[r][c]["unit_in"]
                if unit_in:
                    # print(f"--C")
                    self.removed_quotes.append(unit_in.SGQuote)
                    self.delete_tile(r, c, unit_in)
                elif self.app_state == "DRAGGING":
                    # print(f"--D {self.drag_tile=}, {self.select_tile=}")
                    # user is dragging a tile and right-clicked to drop it.
                    self.calendar_surface.itemconfigure(self.drag_tile, state="hidden")
                    self.calendar_surface.itemconfigure(self.drag_text, state="hidden")
                    st_rc = self.calendar_surface.tile_to_rc(self.select_tile)
                    # print(f"{st_rc=}")
                    if st_rc:
                        # print(f"flashing")
                        st_r, st_c = st_rc
                        self.calendar_surface.revert_colour(st_rc)
                        self.flash_tile(st_r, st_c)
                    self.drag_tile = None
                    self.select_tile = None
                    self.app_state = "IDLE"
                    self.calendar_surface.revert_colour(rc)
                    print(f"NO UNIT IN")

    def get_combo_quote(self):
        q = self.tv_combo_unit_selection.get()
        if q and self.multi_combo_unit_selection.is_valid():
            return q
        return None

    def click_calendar_surface(self, event):
        print(f"CCS click {event=}")
        x, y = event.x, event.y
        tile = self.calendar_surface.tile_at_xy((x, y))
        print(f"\t{x=}, {y=}, {tile=}")

        # drag tile, hover tile canvas tags and row columns
        dt = self.drag_tile
        ddt = self.dragging_details
        ht = self.calendar_surface.tile_at_xy((x, y))
        dt_rc = self.calendar_surface.tile_to_rc(dt)
        ht_rc = self.calendar_surface.tile_to_rc(ht)
        print(f"{dt=}, {ht=}, {dt_rc=}, {ht_rc=}")
        combo_quote = self.get_combo_quote()
        print(f"COMBO_QUOTE= '{combo_quote}'")
        if tile is not None:
            if self.app_state == "IDLE":
                if ht_rc[0] != 0 and ht_rc[1] != 0:
                    # TODO double check that this day is not a weekend

                    self.app_state = "SELECTED"
                    print(f"\n\t{self.tv_combo_unit_selection.get()=}\n")
                    # if self.tv_combo_unit_selection.get() in self.calendar_surface.units:
                    self.calendar_surface.itemconfigure(tile, fill=self.calendar_surface.selected_colour)
                    self.select_tile = tile
                    self.select_details = {
                        # "quote": self.tv_combo_unit_selection.get(),
                        # "unit_in": self.calendar_surface.units[self.tv_combo_unit_selection.get()],
                        "quote": combo_quote,
                        "unit_in": self.calendar_surface.units[combo_quote],
                        "from_tag": ht
                    }
                    self.calendar_surface.itemconfigure(self.drag_tile, state="normal")
                    self.calendar_surface.itemconfigure(self.drag_text, state="normal")
                    self.update_info_frame()
                    # else:
                    #     print(f"NEW ELSE HERE")

            elif self.app_state == "DRAGGING":

                self.app_state = "IDLE"
                # self.calendar_surface.it
                # TODO take the dragging tile data and insert it into the tile where the click was set.

                from_combo = self.dragging_details['from_tag'] is None
                drag_unit = ddt["unit_in"]
                ft = ddt["from_tag"]
                print(f"dt is overridden by {ft}")
                if from_combo:
                    if ht_rc[0] != 0 and ht_rc[1] != 0:
                        # TODO double check that this day is not a weekend
                        # values = self.multi_combo_unit_selection.data["SGQuote"].values.tolist()
                        # values.remove(self.tv_combo_unit_selection.get())
                        quote_to_delete = self.tv_combo_unit_selection.get()
                        self.removed_quotes.append(quote_to_delete)
                        self.multi_combo_unit_selection.delete_item(value=quote_to_delete, )
                        # self.combo_unit_selection.configure(values=values)
                        self.tv_combo_unit_selection.set("")
                        print("FROM COMBO")
                        success = self.overwrite_tile(ht, drag_unit)
                        if not success:
                            print(f"NOT SUCCESS")
                        # self.calendar_surface.itemconfigure(tile, fill=random_colour(rgb=False))
                else:
                    if ht_rc[0] != 0 and ht_rc[1] != 0:
                        if dt != ht:
                            if drag_unit:
                                # TODO double check that this day is not a weekend
                                self.move_tile(ht, ft, drag_unit)

                self.calendar_surface.itemconfigure(self.drag_tile, state="hidden")
                self.calendar_surface.itemconfigure(self.drag_text, state="hidden")
                self.drag_tile = None
            else:

                # self.app_state == "SELECTED"
                self.calendar_surface.itemconfigure(tile, fill=self.calendar_surface.selected_colour)
                self.select_tile = tile
                unit_in = self.calendar_surface.quote_at_xy((x, y))
                self.select_details = {
                    "quote": unit_in.SGQuote,
                    "unit_in": unit_in,
                    "from_tag": ht
                }
                self.update_info_frame()

    def motion_calendar_surface(self, event):
        # print(f"motion {event=}")
        if self.app_state == "DRAGGING":
            dt = self.drag_tile
            # bbox = self.calendar_surface.bbox(dt)
            # cx, cy, cw, ch = self.calendar_surface.winfo_rootx(), self.calendar_surface.winfo_rooty(), self.calendar_surface.winfo_width(), self.calendar_surface.winfo_height()
            # # xe, ye = event
            #
            # # xe = event.x - (self.calendar_surface.tile_width / 2)
            # # ye = event.y - (self.calendar_surface.tile_height / 2)
            # # # mx = self.winfo_width() - (2 * self.calendar_surface.tile_width) - cx - (self.calendar_surface.tile_width / 1.5)
            # # # my = self.winfo_height() - (2 * self.calendar_surface.tile_height) - cy - (self.calendar_surface.tile_height / 1.5)
            # # mx = cx + self.calendar_surface.winfo_width() - (self.calendar_surface.tile_width / 1)
            # # my = cy + self.calendar_surface.winfo_height() - (self.calendar_surface.tile_height / 1)
            # # print(f"{bbox=}, {cx=}, {cy=}, {cw=}, {ch=}, {mx=}, {my=}, {xe=}, {ye=}")
            # # xe = clamp(0, xe, mx)
            # # ye = clamp(0, ye, my)

            x = self.calendar_surface.canvasx(event.x) - (self.calendar_surface.tile_width / 2)
            y = self.calendar_surface.canvasy(event.y) - (self.calendar_surface.tile_height / 2)
            # bbox = [
            #     self.calendar_surface.winfo_x(),
            #     self.calendar_surface.winfo_y(),
            #     self.calendar_surface.winfo_x() + self.calendar_surface.winfo_width() - (self.calendar_surface.tile_width / 2),
            #     self.calendar_surface.winfo_y() + self.calendar_surface.winfo_height() - (self.calendar_surface.tile_height / 2)
            # ]

            bbox = self.calendar_surface.bbox("all")
            xe = clamp(bbox[0], x, bbox[2])
            ye = clamp(bbox[1], y, bbox[3])
            self.calendar_surface.moveto(dt, xe, ye)
            self.calendar_surface.moveto(self.drag_text, xe, ye)
            #
            # x, y = event.x, event.y
            # bbox = self.calendar_surface.bbox("all")
            # new_rect = clamp_rect([x, y, self.calendar_surface.tile_width, self.calendar_surface.tile_height], bbox, maintain_inner_dims=True)
            # self.calendar_surface.moveto(self.drag_tile, new_rect[0], new_rect[1])
            #
            #
            # xe, ye = event.x - (self.calendar_surface.tile_width / 2), event.y - (self.calendar_surface.tile_height / 2)
            # mx, my = self.winfo_width() - (2 * self.calendar_surface.tile_width) - cx - (self.calendar_surface.tile_width / 1.5), self.winfo_height() - (2 * self.calendar_surface.tile_height) - cy - (self.calendar_surface.tile_height / 1.5)
            # print(f"{bbox=}, {cx=}, {cy=}, {cw=}, {ch=}, {mx=}, {my=}, {xe=}, {ye=}")
            # xe = clamp(0, xe, mx)
            # ye = clamp(0, ye, my)
            # self.calendar_surface.moveto(dt, xe, ye)
        elif self.app_state == "SELECTED":
            self.app_state = "DRAGGING"
            r_c = self.calendar_surface.rc_at_xy(
                (self.calendar_surface.canvasx(event.x), self.calendar_surface.canvasy(event.y)))
            r_c = self.calendar_surface.rc_at_xy((event.x, event.y))
            if r_c:
                r, c = r_c
                unit_in = self.calendar_surface.tile_properties[r][c]["unit_in"]
                self.dragging_details = {
                    "quote": unit_in.SGQuote if unit_in else None,
                    "unit_in": unit_in,
                    "from_tag": self.select_details["from_tag"]
                }
                self.update()

    # def scroll_calendar_surface(self, event):
    #     print(f"Scrolling: {event}")
    #     first = self.calendar_surface.bbox(self.calendar_surface.tiles_stg[0][0])
    #     last = self.calendar_surface.bbox(self.calendar_surface.tiles_stg[-1][-1])
    #     print(f"{first=}, {last=}")
    #     self.calendar_surface.xview_scroll(int(-1 * (event.delta / 120)), "units")

    def xview(self, event, *args):
        self.calendar_surface.xview(*args)
        # TODO fix this
        self.re_draw_legend(event)

        # raise ValueError("STOPPP!")
        # https://stackoverflow.com/questions/63629407/tkinter-how-to-stop-scrolling-above-canvas-window
        # if self.calendar_surface.xview() == (0.0, 1.0):
        #     print(f"EARLY EXIT")
        #     return
        # print(f"LATE EXIT {args=}")

    def re_draw_legend(self, event):

        can = self.calendar_surface
        cx, cy = can.canvasx(0), can.canvasy(0)

        # xvi = self.calendar_surface.xview()
        tw, th, ts = can.tile_width, can.tile_height, can.tile_space
        # a = int(self.calendar_surface["width"])
        # # b = self.calendar_surface.winfo_width()
        # visible_width = a
        # scroll_pos = xvi[0] * visible_width
        # x = int(scroll_pos)
        lines = can.lines
        # tp_0 = self.calendar_surface.tile_properties[1][0]
        # bb_0 = self.calendar_surface.bbox(tp_0["tag_rect"])
        # x += bb_0[0]
        # print(f"Scroll: {xvi=}, {x=}, vw={visible_width}, xvi[0]*vw={xvi[0] * visible_width:.2f}, {bb_0=}")
        x, y = cx, cy
        # print(f"{x=}, {y=}")
        for i in range(0, len(lines) + 1):
            tp = can.tile_properties[i][0]
            tile = tp["tag_rect"]
            x1, y1, x2, y2 = tp["x1"], tp["y1"], tp["x2"], tp["y2"]
            # t1_x1, t1_y1, t1_x2, t1_y2 = tp["t1_x1"], tp["t1_y1"], tp["t1_x2"], tp["t1_y2"]
            # t2_x1, t2_y1, t2_x2, t2_y2 = tp["t2_x1"], tp["t2_y1"], tp["t2_x2"], tp["t2_y2"]
            # t3_x1, t3_y1, t3_x2, t3_y2 = tp["t3_x1"], tp["t3_y1"], tp["t3_x2"], tp["t3_y2"]
            # t4_x1, t4_y1, t4_x2, t4_y2 = tp["t4_x1"], tp["t4_y1"], tp["t4_x2"], tp["t4_y2"]
            # t5_x1, t5_y1, t5_x2, t5_y2 = tp["t5_x1"], tp["t5_y1"], tp["t5_x2"], tp["t5_y2"]
            # t6_x1, t6_y1, t6_x2, t6_y2 = tp["t6_x1"], tp["t6_y1"], tp["t6_x2"], tp["t6_y2"]
            t1_x1, t1_y1 = tp["t1_x1"], tp["t1_y1"]
            t2_x1, t2_y1 = tp["t2_x1"], tp["t2_y1"]
            t3_x1, t3_y1 = tp["t3_x1"], tp["t3_y1"]
            t4_x1, t4_y1 = tp["t4_x1"], tp["t4_y1"]
            t5_x1, t5_y1 = tp["t5_x1"], tp["t5_y1"]
            t6_x1, t6_y1 = tp["t6_x1"], tp["t6_y1"]

            # tw = self.calendar_surface.tile_width
            # x = self.calendar_surface.canvasx(0 - tw)
            # x = self.calendar_surface.canvasx(0) - (xv[0] * self.calendar_surface.canvas_width)
            # print(f"{tile=}, {x=}, sp={scroll_pos}, sa={scroll_amount}, {bbox=}")

            # self.calendar_surface.moveto(tile, x, bbox[1])
            # self.calendar_surface.move(tile, x, 0)
            # self.calendar_surface.coords(tile, x, bbox[1], x + tw, bbox[3])
            # self.calendar_surface.coords(tile, x, bbox[1])
            # self.calendar_surface.itemconfigure(tile, state="normal")
            y += th + (1.5 * ts)
            # self.calendar_surface.coords(tile, x, y, x + tw, y + th)
            self.calendar_surface.coords(tile, x, y1, x + tw, y2)

            if i > 0:
                for j in range(1, 7):
                    # self.calendar_surface.moveto(tp[f"t{i}_tag"], x + (tw // 2), bbox[1] + ((bbox[3] - bbox[1]) // 2))
                    # self.calendar_surface.move(tp[f"t{i}_tag"], x, 0)
                    # self.calendar_surface.coords(tp[f"t{i}_tag"], x, bbox[1])
                    self.calendar_surface.coords(tp[f"t{j}_tag"], x + (tw / 2), eval(f"t{j}_y1"))

        # xvi = self.calendar_surface.xview()
        # tw = self.calendar_surface.tile_width
        # a = int(self.calendar_surface["width"])
        # # b = self.calendar_surface.winfo_width()
        # visible_width = a
        # scroll_pos = xvi[0] * visible_width
        # x = int(scroll_pos)
        # lines = self.calendar_surface.lines
        # tp_0 = self.calendar_surface.tile_properties[1][0]
        # bb_0 = self.calendar_surface.bbox(tp_0["tag_rect"])
        # x += bb_0[0]
        # print(f"Scroll: {xvi=}, {x=}, vw={visible_width}, xvi[0]*vw={xvi[0] * visible_width:.2f}, {bb_0=}")
        # for i in range(1, len(lines) + 1):
        #     tp = self.calendar_surface.tile_properties[i][0]
        #     tile = tp["tag_rect"]
        #     bbox = self.calendar_surface.rc_bbox((i, 0))
        #     # tw = self.calendar_surface.tile_width
        #     # x = self.calendar_surface.canvasx(0 - tw)
        #     # x = self.calendar_surface.canvasx(0) - (xv[0] * self.calendar_surface.canvas_width)
        #     # print(f"{tile=}, {x=}, sp={scroll_pos}, sa={scroll_amount}, {bbox=}")
        #
        #     # self.calendar_surface.moveto(tile, x, bbox[1])
        #     # self.calendar_surface.move(tile, x, 0)
        #     self.calendar_surface.coords(tile, x, bbox[1], x + tw, bbox[3])
        #     # self.calendar_surface.coords(tile, x, bbox[1])
        #     # self.calendar_surface.itemconfigure(tile, state="normal")
        #
        #     for i in range(1, 7):
        #         # self.calendar_surface.moveto(tp[f"t{i}_tag"], x + (tw // 2), bbox[1] + ((bbox[3] - bbox[1]) // 2))
        #         # self.calendar_surface.move(tp[f"t{i}_tag"], x, 0)
        #         self.calendar_surface.coords(tp[f"t{i}_tag"], x, bbox[1])
        #
        # # xvi = self.calendar_surface.xview()
        # # tw = self.calendar_surface.tile_width
        # # a = int(self.calendar_surface["width"])
        # # # b = self.calendar_surface.winfo_width()
        # # visible_width = a
        # # scroll_pos = xvi[0] * visible_width
        # # x = int(scroll_pos)
        # # lines = self.calendar_surface.lines
        # # tp_0 = self.calendar_surface.tile_properties[1][0]
        # # bb_0 = self.calendar_surface.bbox(tp_0["tag_rect"])
        # # x += bb_0[0]
        # # print(f"Scroll: {xvi=}, {x=}, vw={visible_width}, xvi[0]*vw={xvi[0] * visible_width:.2f}, {bb_0=}")
        # # for i in range(1, len(lines) + 1):
        # #     tp = self.calendar_surface.tile_properties[i][0]
        # #     tile = tp["tag_rect"]
        # #     bbox = self.calendar_surface.rc_bbox((i, 0))
        # #     # tw = self.calendar_surface.tile_width
        # #     # x = self.calendar_surface.canvasx(0 - tw)
        # #     # x = self.calendar_surface.canvasx(0) - (xv[0] * self.calendar_surface.canvas_width)
        # #     # print(f"{tile=}, {x=}, sp={scroll_pos}, sa={scroll_amount}, {bbox=}")
        # #
        # #     # self.calendar_surface.moveto(tile, x, bbox[1])
        # #     # self.calendar_surface.move(tile, x, 0)
        # #     self.calendar_surface.coords(tile, x, bbox[1], x + tw, bbox[3])
        # #     # self.calendar_surface.coords(tile, x, bbox[1])
        # #     # self.calendar_surface.itemconfigure(tile, state="normal")
        # #
        # #     for i in range(1, 7):
        # #         # self.calendar_surface.moveto(tp[f"t{i}_tag"], x + (tw // 2), bbox[1] + ((bbox[3] - bbox[1]) // 2))
        # #         # self.calendar_surface.move(tp[f"t{i}_tag"], x, 0)
        # #         self.calendar_surface.coords(tp[f"t{i}_tag"], x, bbox[1])
        # #
        # # # xvi = self.calendar_surface.xview()
        # # # tw = self.calendar_surface.tile_width
        # # # a = int(self.calendar_surface["width"])
        # # # b = self.calendar_surface.winfo_width()
        # # # visible_width = a - b
        # # # scroll_pos = xvi[0] * visible_width
        # # # x = -scroll_pos
        # # # lines = self.calendar_surface.lines
        # # # print(f"Scroll: {x=}, vw={visible_width}, {a=}, {b=}")
        # # # for i in range(1, len(lines) + 1):
        # # #     tp = self.calendar_surface.tile_properties[i][0]
        # # #     tile = tp["tag_rect"]
        # # #     # bbox = self.calendar_surface.rc_bbox((i, 0))
        # # #     # tw = self.calendar_surface.tile_width
        # # #     # x = self.calendar_surface.canvasx(0 - tw)
        # # #     # x = self.calendar_surface.canvasx(0) - (xv[0] * self.calendar_surface.canvas_width)
        # # #     # print(f"{tile=}, {x=}, sp={scroll_pos}, sa={scroll_amount}, {bbox=}")
        # # #
        # # #     # self.calendar_surface.moveto(tile, x, bbox[1])
        # # #     self.calendar_surface.move(tile, x, 0)
        # # #     self.calendar_surface.itemconfigure(tile, state="normal")
        # # #
        # # #     for i in range(1, 6):
        # # #         # self.calendar_surface.moveto(tp[f"t{i}_tag"], x + (tw // 2), bbox[1] + ((bbox[3] - bbox[1]) // 2))
        # # #         self.calendar_surface.move(tp[f"t{i}_tag"], x, 0)
        # # #
        # # #
        # # # # x = self.calendar_surface.canvasx(0)
        # # # # lines = self.calendar_surface.lines
        # # # # for i in range(1, len(lines) + 1):
        # # # #     tp = self.calendar_surface.tile_properties[i][0]
        # # # #     tile = tp["tag_rect"]
        # # # #     # bbox = self.calendar_surface.rc_bbox((i, 0))
        # # # #     # tw = self.calendar_surface.tile_width
        # # # #     # x = self.calendar_surface.canvasx(0 - tw)
        # # # #     # x = self.calendar_surface.canvasx(0) - (xv[0] * self.calendar_surface.canvas_width)
        # # # #     # print(f"{tile=}, {x=}, sp={scroll_pos}, sa={scroll_amount}, {bbox=}")
        # # # #
        # # # #     # self.calendar_surface.moveto(tile, x, bbox[1])
        # # # #     self.calendar_surface.move(tile, x, 0)
        # # # #     for i in range(1, 6):
        # # # #         # self.calendar_surface.moveto(tp[f"t{i}_tag"], x + (tw // 2), bbox[1] + ((bbox[3] - bbox[1]) // 2))
        # # # #         self.calendar_surface.move(tp[f"t{i}_tag"], x, 0)
        # # # #
        # # # #
        # # # # # scroll_pos = self.calendar_surface.xview()[0]
        # # # # # scroll_amount = event.delta / 120.0
        # # # # # new_pos = scroll_pos - (scroll_amount * 0.1)
        # # # # # # new_pos = scroll_pos - (scroll_amount * 1)
        # # # # # cw = self.calendar_surface.canvas_width
        # # # # # # x = clamp(0, new_pos * cw, cw)
        # # # # # x = new_pos * cw
        # # # # # lines = self.calendar_surface.lines
        # # # # # tp_0 = self.calendar_surface.tile_properties[0][0]
        # # # # # bb_0 = self.calendar_surface.bbox(tp_0["tag_rect"])
        # # # # # x -= bb_0[0]
        # # # # # print(f"{x=}, sp={scroll_pos}, sa={scroll_amount}, {tp_0=}, {bb_0=}")
        # # # # #
        # # # # # for i in range(1, len(lines) + 1):
        # # # # #     tp = self.calendar_surface.tile_properties[i][0]
        # # # # #     tile = tp["tag_rect"]
        # # # # #     bbox = self.calendar_surface.rc_bbox((i, 0))
        # # # # #     tw = self.calendar_surface.tile_width
        # # # # #     # x = self.calendar_surface.canvasx(0 - tw)
        # # # # #     # x = self.calendar_surface.canvasx(0) - (xv[0] * self.calendar_surface.canvas_width)
        # # # # #     # print(f"{tile=}, {x=}, sp={scroll_pos}, sa={scroll_amount}, {bbox=}")
        # # # # #
        # # # # #     # self.calendar_surface.moveto(tile, x, bbox[1])
        # # # # #     self.calendar_surface.move(tile, x, 0)
        # # # # #     for i in range(1, 6):
        # # # # #         # self.calendar_surface.moveto(tp[f"t{i}_tag"], x + (tw // 2), bbox[1] + ((bbox[3] - bbox[1]) // 2))
        # # # # #         self.calendar_surface.move(tp[f"t{i}_tag"], x, 0)
        # # # # #
        # # # # # # xv = self.calendar_surface.xview()
        # # # # # # print(f"redraw_legend {xv=}, {args=}")
        # # # # # # lines = self.calendar_surface.lines
        # # # # # # for i in range(1, len(lines) + 1):
        # # # # # #     tp = self.calendar_surface.tile_properties[i][0]
        # # # # # #     tile = tp["tag_rect"]
        # # # # # #     bbox = self.calendar_surface.rc_bbox((i, 0))
        # # # # # #     tw = self.calendar_surface.tile_width
        # # # # # #     x = self.calendar_surface.canvasx(0 - tw)
        # # # # # #     x = self.calendar_surface.canvasx(0) - (xv[0] * self.calendar_surface.canvas_width)
        # # # # # #     print(f"{tile=}, {x=}, {bbox=}")
        # # # # # #
        # # # # # #     self.calendar_surface.moveto(tile, x, bbox[1])
        # # # # # #     for i in range(1, 6):
        # # # # # #         self.calendar_surface.moveto(tp[f"t{i}_tag"], x + (tw // 2), bbox[1] + ((bbox[3] - bbox[1]) // 2))
        # # # # # #     # self.xview('scroll', int(-1 * (event.delta / 120)), 'units')
        # # # # # #     # self.calendar_surface.xview('scroll', int(-1 * (args[1] / 120)), 'units')

    def onFrameConfigure(self, event):
        print(f"{self.calendar_surface.cget('scrollregion')=}")
        self.calendar_surface.configure(scrollregion=self.calendar_surface.bbox('all'))
        print(f"{self.calendar_surface.cget('scrollregion')=}")

    def click_insert_combo_choice(self):
        print(f"insert combo choice, {self.tv_combo_unit_selection.get()=}")
        fail = False
        if self.multi_combo_unit_selection.tree_treeview.selection():
            if self.tv_combo_unit_selection.get():
                self.app_state = "DRAGGING"
                self.dragging_details = {
                    "quote": self.tv_combo_unit_selection.get(),
                    "unit_in": self.calendar_surface.units[self.tv_combo_unit_selection.get()],
                    "from_tag": None
                }
                self.update()
            else:
                fail = True
        else:
            fail = True

        if fail:
            r_message = "You need to select a unit from the dropdown before you can place it."
            tkinter.messagebox.showerror(title="Selection Needed", message=r_message)
            self.combo_unit_selection.focus()

    def click_export_sql(self, commit=False):
        print(f"TRYING TO SAVE")
        if self.this_user_publishes:
            sql_res = self.calendar_surface.export_tile_sql(self.removed_quotes)
            # print(f"SQL\n\n<{sql_res}>")

            if commit:
                tkinter.messagebox.showinfo(title="SQL Export", message="Data updated successfully!")
                self.dirty.set(False)
            else:
                tkinter.messagebox.showinfo(title="SQL Export", message="Data successfully exported!")
        else:
            tkinter.messagebox.showinfo(title="SQL Export",
                                        message="Error, your user is not currently allowed to make edits to the production schedule. Please contact IT for further assistance.")

    def click_update_sql(self, are_u_sure=False):
        if self.this_user_publishes:
            if are_u_sure or tkinter.messagebox.askyesnocancel(title="Server Update",
                                                               message="Are you sure you want to commit your changes to the server?"):
                sql_res = self.calendar_surface.update_tile_sql(self.removed_quotes)
                print(f"SQL\n\n<{sql_res}>")
                tkinter.messagebox.showinfo(title="Server Update", message="Data updated successfully!")
        else:
            tkinter.messagebox.showinfo(title="Server Update",
                                        message="Error, your user is not currently allowed to make edits to the production schedule. Please contact IT for further assistance.")

    def click_info_frame_quote_hyperlink(self, event):
        before = self.tv_entry_unit_scroll_search.get()
        self.tv_entry_unit_scroll_search.set(self.frame_info_frame.get_value("SGQuote#"))
        self.click_search_units(None)
        self.tv_entry_unit_scroll_search.set(before)

    def click_debug_show_scrollregion(self):
        can = self.calendar_surface
        print(f"self.calendar_surface.scrollregion:\n{can.cget('scrollregion')}")

        x, y = can.canvasx(0), can.canvasy(0)
        w, h = can.winfo_width(), can.winfo_height()
        vs = Rect2(x, y, w, h).tkinter_rect()
        print(f"Viewable region: x={x}, y={y}, w={w}, h={h}")
        print(f"{vs.x1=}, {vs.y1=}, {vs.x2=}, {vs.y2=}")

    def click_debug_show_history(self):
        print(f"self.calendar_surface.history:\n{self.calendar_surface.history}")
        print(f"self.calendar_surface.redo_history:\n{self.calendar_surface.redo_history}")

    def click_refresh(self):
        print("REFRESHING")
        self.restart_handle()

    def click_redo(self, *event):
        redo_data = self.calendar_surface.redo()
        success, data = redo_data
        msg = data["msg"]
        match success:
            case 0:
                # failure
                tkinter.messagebox.showinfo(title="Redo", message="Nothing to redo!")
            case 1:
                pass
            case 2:
                # 2 - success - but need to remove from combo list.
                quote = data["quote"]
                # TODO this doesnt work
                self.multi_combo_unit_selection.delete_item(value=quote)
                # new_list = list(self.combo_unit_selection["values"])
                # new_list.remove(quote)
                # self.combo_unit_selection.configure(values=new_list)
            case 3:
                # 2 - success - but need to add quote to calendar.
                quote = data["quote"]

                # unit_in = last.unit_in
                # r_from = last.r_from
                # c_from = last.c_from
                # r_to = last.r_to
                # c_to = last.c_to
                # self.set_rc_with_unit((r_from, c_from), unit_in)
                # self.remove_tile(r_to, c_to)

                # TODO this doesnt work
                df = self.df_production
                to_add = df.loc[(
                        (df["OrdersV2_SGQuote"] == quote) |
                        (df["dtProductionSchedule_SGQuote"] == quote) |
                        (df["dtProductionScheduleV2_SGQuote"] == quote)
                )]
                wo1, wo2, wo3, dealer, sn, model_no, cust_wo = to_add[[
                    "OrdersV2_WO#",
                    "dtProductionSchedule_WO#",
                    "dtProductionScheduleV2_WO#",
                    "COMPANY NAME",
                    "Serial Number",
                    "Model No",
                    "Customer WO#"
                ]].values.tolist()[0]
                wo = wo1 if wo1 else (wo2 if wo2 else wo3)
                print(f"{wo=}, {dealer=}, {sn=}, {model_no=}")
                od = dict()
                od.update({"SGQuote": quote})
                od.update({"WO#": wo})
                od.update({"Model No": model_no})
                od.update({"Dealer": dealer})
                od.update({"Serial#": sn})
                od.update({"Serial#": sn})
                od.update({"Customer WO#": cust_wo})
                self.multi_combo_unit_selection.add_new_item(quote, "SGQuote", od)
                # values = list(self.combo_unit_selection["values"])
                # values.append(quote)
                # values.sort()
                # self.combo_unit_selection.configure(values=values)
            case 4:
                pass
            case 5:
                # 4 - success - but need to shift in reverse
                line_in = data["line_in"]
                days_in = data["days_in"]
                direction_in = data["direction_in"]
                start_date_in = data["start_date"]
                end_date_in = data["end_date"]
                msg_in = data["msg"]
                self.calendar_surface.shift_line({
                    "line": line_in,
                    "direction": direction_in,
                    "days": days_in,
                    "start_date": start_date_in,
                    "end_date": end_date_in,
                    "msg": msg_in,
                    "submission": True
                }
                    , dealer_status=self.frame_colour_coder.status
                    , undoable=False
                )
            case _:
                raise ValueError(f"Error redo not successful. Returned {success}\n{msg=}")
        print(f"REDO {success}, {msg=}")

    def click_undo(self, *args):
        undo_data = self.calendar_surface.undo()
        success, data = undo_data
        msg = data["msg"]
        match success:
            case 0:
                # failure
                tkinter.messagebox.showinfo(title="Undo", message="Nothing to undo!")
            case 1:
                # success
                # tkinter.messagebox.showinfo(title="Undo", message="Nothing to undo!")
                pass
            case 2:
                # 2 - success - but need to re-add a removed tile to the combo list.
                quote = data["quote"]
                if quote in self.removed_quotes:
                    # TODO this doesnt work
                    df = self.df_production
                    to_add = df.loc[(
                            (df["OrdersV2_SGQuote"] == quote) |
                            (df["dtProductionSchedule_SGQuote"] == quote) |
                            (df["dtProductionScheduleV2_SGQuote"] == quote)
                    )]
                    wo1, wo2, wo3, dealer, sn, model_no = to_add[[
                        "OrdersV2_WO#",
                        "dtProductionSchedule_WO#",
                        "dtProductionScheduleV2_WO#",
                        "COMPANY NAME",
                        "Serial Number",
                        "Model No"
                    ]].values.tolist()[0]
                    wo = wo1 if wo1 else (wo2 if wo2 else wo3)
                    print(f"{wo=}, {dealer=}, {sn=}, {model_no=}")
                    od = dict()
                    od.update({"SGQuote": quote})
                    od.update({"WO#": wo})
                    od.update({"Model No": model_no})
                    od.update({"Dealer": dealer})
                    od.update({"Serial#": sn})
                    self.multi_combo_unit_selection.add_new_item(quote, "SGQuote", od)

                    # new_list = list(self.combo_unit_selection["values"])
                    # new_list.append(quote)
                    # new_list.sort()
                    # self.combo_unit_selection.configure(values=new_list)
                else:
                    print(f"{quote=} not found in {self.removed_quotes}")
            case 3:
                # 2 - success - but need to remove quote from combo list.
                quote = data["quote"]
                self.multi_combo_unit_selection.delete_item(value=quote)
                # values = list(self.combo_unit_selection["values"])
                # values.remove(quote)
                # self.combo_unit_selection.configure(values=values)
            case 4:
                # 4 - success - but need to re-colour code
                unit_to = data["unit_to"]
                unit_from = data["unit_from"]
                self.colour_code_dealer(unit_to.InputField2_v2)
                self.colour_code_dealer(unit_from.InputField2_v2)
                self.flash_quote(unit_from.SGQuote)
            case 5:
                # 4 - success - but need to shift in reverse
                line_in = data["line_in"]
                days_in = data["days_in"]
                direction_in = data["direction_in"]
                direction_in = "forward" if direction_in == "backward" else "forward"
                start_date_in = data["start_date"]
                end_date_in = data["end_date"]
                msg_in = data["msg"]
                self.calendar_surface.shift_line({
                    "line": line_in,
                    "direction": direction_in,
                    "days": days_in,
                    "start_date": start_date_in,
                    "end_date": end_date_in,
                    "msg": msg_in,
                    "submission": True
                }
                    , dealer_status=self.frame_colour_coder.status
                    , undoable=False
                )
            case _:
                raise ValueError(f"Error undo not successful. Returned {success}\n{msg=}")
        print(f"UNDO {success}, {msg=}")

    def dbl_click_tile(self, event):
        # self.calendar_surface.dbl_click_tile(event)
        x, y = event.x, event.y
        tile = self.calendar_surface.tile_at_xy((x, y))
        print(f"Double click!, tile chosen: {tile}")
        if tile is not None:
            self.drag_tile = tile
            self.app_state = "DRAGGING"
            self.update()

    def dbl_right_click_tile(self, event):
        # self.calendar_surface.dbl_click_tile(event)
        x, y = event.x, event.y
        tile = self.calendar_surface.tile_at_xy((x, y))
        r, c = self.calendar_surface.rc_at_xy((x, y))
        unit = self.calendar_surface.tile_properties[r][c]["unit_in"]
        print(f"Double right click!, tile chosen: {tile=}, {unit=}, {r=}, {c=}")

        if tile is not None and unit is None:
            print(f"REVERTING COLOUR ON DBL CLICK")
            self.calendar_surface.revert_colour((r, c))

    def update(self) -> None:
        if self.app_state == "DRAGGING":
            dt = self.drag_tile
            if dt is None:
                ts = self.calendar_surface.tile_space
                tw = self.calendar_surface.tile_width
                th = self.calendar_surface.tile_height
                x1, y1 = self.winfo_pointerxy()
                rx, ry = self.winfo_rootx(), self.winfo_rooty()
                wx, wy = self.winfo_x(), self.winfo_y()
                cx, cy = self.calendar_surface.winfo_rootx(), self.calendar_surface.winfo_rooty()
                print(f"{x1=}, {y1=}, {wx=}, {wy=}, {rx=}, {ry=}, {cx=}, {cy=}")
                x1 -= cx
                y1 -= cy
                self.clear_drag_tile_queue()
                self.clear_drag_text_queue()
                self.drag_tile = self.calendar_surface.create_rectangle(x1 - (tw / 2), y1, x1 + (tw / 2), y1 + th,
                                                                        fill=self.calendar_surface.drag_colour)
                self.drag_text = self.calendar_surface.create_text(x1, y1 + (th / 2),
                                                                   text=self.dragging_details["quote"],
                                                                   width=x1 + (tw / 2), fill="white")
                self.drag_tile_queue.append(self.drag_tile)
                self.drag_text_queue.append(self.drag_text)
                # self.drag_coordinates =
                dt = self.drag_tile
        super(App, self).update()

    def clear_drag_tile_queue(self):
        for tile in self.drag_tile_queue:
            self.calendar_surface.itemconfigure(tile, state="hidden")
        self.drag_tile_queue.clear()

    def clear_drag_text_queue(self):
        for text in self.drag_text_queue:
            self.calendar_surface.itemconfigure(text, state="hidden")
        self.drag_text_queue.clear()

    def move_tile(self, tag_to: int | str, tag_from: int | str, unit_in: Unit) -> bool:
        print(f"move_tile(self, {tag_to=}, tag_from: int | str, unit_in: Unit) -> bool:")
        to_rc = self.calendar_surface.tile_to_rc(tag_to)
        from_rc = self.calendar_surface.tile_to_rc(tag_from)
        s1, s2 = False, False

        if to_rc:
            # TODO decide if this is a normal placement or a swa.
            r, c = from_rc
            tr, tc = self.calendar_surface.tile_to_rc(tag_to)
            unit_from = self.calendar_surface.tile_properties[tr][tc]["unit_in"]
            already_a_tile = unit_from is not None
            print(
                f"Moving a tile {r=}, {c=}, {already_a_tile=}, {unit_in=}, {self.calendar_surface.tile_properties[r][c]['unit_in']=}")
            if already_a_tile:
                self.calendar_surface.new_history(CalendarSurface.SwapUndoable(r, c, tr, tc, unit_from, unit_in))
                s1 = self.overwrite_tile(tag_to, unit_in, undoable=False)
                s2 = self.overwrite_tile(tag_from, unit_from, undoable=False)
                self.calendar_surface.revert_colour(from_rc)
                self.calendar_surface.revert_colour(to_rc)
                self.colour_code_dealer(unit_in.InputField2_v2)
                self.colour_code_dealer(unit_from.InputField2_v2)
                # s2 = self.delete_tile(r, c, unit_in, unplace=False, undoable=False)
            else:
                self.calendar_surface.new_history(CalendarSurface.MovementUndoable(r, c, tr, tc, unit_in))
                s1 = self.overwrite_tile(tag_to, unit_in, undoable=False)
                s2 = self.delete_tile(r, c, unit_in, unplace=False, undoable=False)
        return s1 and s2

    def delete_tile(self, r, c, unit_in, unplace=True, undoable=True) -> bool:
        print(f"delete_tile(self, r, c, unit_in, unplace=True) -> bool:")
        details = self.calendar_surface.tile_properties[r][c]
        string_vars = [
            tv_text_1 := details["text_1"],
            tv_text_2 := details["text_2"],
            tv_text_3 := details["text_3"],
            tv_text_4 := details["text_4"],
            tv_text_5 := details["text_5"],
            tv_text_6 := details["text_6"]
        ]
        for sv in string_vars:
            sv.set("")

        if undoable:
            self.calendar_surface.new_history(CalendarSurface.DeletionUndoable(r, c, unit_in))
        self.calendar_surface.delete_tile(r, c, unplace=unplace)

        # self.calendar_surface.tile_properties[r][c]["unit_in"] = None
        if unit_in.SGQuote in self.removed_quotes:
            # add the deleted unit to the multi-select combo box.
            # need to get WO, dealer, SN, model no from df_production
            # to_add = self.df_production[self.df_production["SGQuote"] == unit_in.SGQuote].reset_index(drop=True)
            # to_add = self.df_production["SGQuote"] == unit_in.SGQuote
            df = pd.DataFrame(self.df_production)
            q = unit_in.SGQuote
            # df.rename({
            #     0: "SGQ1",
            #     1: "SGQ2",
            #     2: "SGQ3"
            # })

            # df.rename((
            #     (0, "SGQ1"),
            #     (1, "SGQ2"),
            #     (2, "SGQ3")
            # ))

            # print(f"\tBEFORE\n{df=}\n{type(df)=}\n{df.columns=}")
            # og_cols = list(df.columns)
            # # q_idxs = [i for i, c in enumerate(og_cols) if c == "SGQuote"]
            # reps = ["SQ1", "SQ2", "SQ3"]
            # d = 0
            # res_cols = []
            # for i, c in enumerate(og_cols):
            #     if c == "SGQuote":
            #         res_cols.append(reps[d])
            #         d += 1
            #     else:
            #         res_cols.append(c)
            #
            # print(f"{res_cols=}")
            #
            # print(f"\tAFTER\n{df=}\n{type(df)=}\n{df.columns=}")
            # df = pd.DataFrame(self.df_production, columns=res_cols)

            # to_add = df["SGQuote"] == unit_in.SGQuote
            # to_add = df.loc[:, (df == unit_in.SGQuote).any()]
            # to_add = df.loc[["SGQuote", "WO#", "COMPANY NAME", "Serial Number", "Model No"], df["SGQuote"] == unit_in.SGQuote]

            # filter = (df == unit_in.SGQuote).any()
            # to_add = df.loc[:, filter]

            # to_add = df[df["SGQuote"] == unit_in.SGQuote]
            # to_add = df[(df[
            #                  [
            #                      "OrdersV2_SGQuote",
            #                      "dtProductionSchedule_SGQuote",
            #                      "dtProductionScheduleV2_SGQuote",
            #                      "OrdersV2_WO#",
            #                      "dtProductionSchedule_WO#",
            #                      "dtProductionScheduleV2_WO#",
            #                      "COMPANY NAME",
            #                      "Serial Number",
            #                      "Model No"
            #                  ]] == unit_in.SGQuote).any()]

            to_add = df.loc[(
                    (df["OrdersV2_SGQuote"] == q) |
                    (df["dtProductionSchedule_SGQuote"] == q) |
                    (df["dtProductionScheduleV2_SGQuote"] == q)
            )]

            # assert isinstance(to_add, pandas.DataFrame)

            print(f"{to_add=}\n{type(to_add)=}")
            if not to_add.empty:
                # print(f"{to_add[['OrdersV2_WO#', 'dtProductionSchedule_WO#', 'dtProductionScheduleV2_WO#', 'COMPANY NAME', 'Serial Number', 'Model No']].values.tolist()=}")
                wo1, wo2, wo3, dealer, sn, model_no, cw = to_add[[
                    "OrdersV2_WO#",
                    "dtProductionSchedule_WO#",
                    "dtProductionScheduleV2_WO#",
                    "COMPANY NAME",
                    "Serial Number",
                    "Model No",
                    "Customer WO#"
                ]].values.tolist()[0]
                wo = wo1 if wo1 else (wo2 if wo2 else wo3)
                print(f"{wo=}, {dealer=}, {sn=}, {model_no=}")
                od = dict()
                od.update({"SGQuote": unit_in.SGQuote})
                od.update({"WO#": wo})
                od.update({"Model No": model_no})
                od.update({"Dealer": dealer})
                od.update({"Serial#": sn})
                od.update({"Customer WO#": cw})
                self.multi_combo_unit_selection.add_new_item(val=unit_in.SGQuote, col="SGQuote", rest_values=od)
            # new_list = list(self.combo_unit_selection["values"])
            # new_list.append(unit_in.SGQuote)
            # new_list.sort()
            # self.combo_unit_selection.configure(values=new_list)
        self.calendar_surface.revert_colour((r, c))
        return True

    def overwrite_tile(self, tag_in: int | str, unit_in: Unit, undoable: bool = True) -> bool:
        print(f"overwrite_tile(self, tag_in: int | str, unit_in: Unit) -> bool:")
        rc = self.calendar_surface.tile_to_rc(tag_in)
        if rc is not None:
            r, c = rc
            print(f"HERE E")
            # this tag was found, and it is a tile tag
            # self.calendar_surface.itemconfigure(tag_in, **details)
            details = self.calendar_surface.tile_properties[rc[0]][rc[1]]
            # tags = [
            #     tag_rect := details["tag_rect"],
            #     tag_t1 := details["t1_tag"],
            #     tag_t2 := details["t2_tag"],
            #     tag_t3 := details["t3_tag"],
            #     tag_t4 := details["t4_tag"],
            #     tag_t5 := details["t5_tag"]
            # ]
            string_vars = [
                tv_text_1 := details["text_1"],
                tv_text_2 := details["text_2"],
                tv_text_3 := details["text_3"],
                tv_text_4 := details["text_4"],
                tv_text_5 := details["text_5"],
                tv_text_6 := details["text_6"]
            ]
            # update the tile text variables on the main screen
            # set the new unit_in to be recognized in self.calendar_surface
            text_order = self.calendar_surface.text_order
            keys = unit_in.__dict__.keys()
            for i, text_tv in enumerate(zip(text_order, string_vars)):
                text, tv = text_tv
                text = "_" + text
                value = text
                print(f"HERE\t{text=}, {keys=}")
                if text in keys:
                    value = getattr(unit_in, text, "N/A")
                print(f"\t\t{i=}, {text=} = {value=}, {tv.get()=}")
                tv.set(value)
                print(f"\t\t\t{tv.get()=}")

            if undoable:
                self.calendar_surface.new_history(CalendarSurface.PlacementUndoable(r, c, unit_in))

            self.calendar_surface.set_rc_with_unit(rc, unit_in)
            # print(f"{unit_in=}")
            # self.calendar_surface.tile_properties[r][c]["unit_in"] = unit_in
            dealer = unit_in.InputField2_v2
            if dealer:
                dealer_colour = self.frame_colour_coder.status[dealer]
                if dealer_colour and dealer_colour != "none":
                    self.calendar_surface.colour_code_dealer(dealer, dealer_colour)

            # tv_text_1.set()

            return True
        return False

    def colour_coder_update(self, var_name, index, mode, init_pass=False):
        print(f"{var_name=}, {index=}, {mode=}, value={getattr(self.frame_colour_coder, 'status_code').get()}")
        if isinstance(init_pass, bool) and not init_pass:
            info = eval(self.frame_colour_coder.status_code.get())
        else:
            info = init_pass

        dealer, colour, clear = info["dealer"], info["colour"], info.get("clear", False)
        colour = Colour(colour)
        if colour.colour_name is None:
            colour = get_colour_name(colour, name_only=True).title()
        else:
            colour = colour.colour_name
        self.calendar_surface.colour_code_dealer(dealer, colour)

        data = dict(self.settings_data)

        print(dict_print(data, "data"))

        cs = "colour_scheme"
        if cs not in data or not data[cs]:
            cd = {}
        else:
            cd = dict(data[cs])

        if not clear:
            cd[dealer] = colour
        elif dealer in cd:
            del cd[dealer]

        # print(f"{data=}")
        # print(f"{cd=}")
        self.settings_data[cs] = cd

        # self.settings_data = cd

        SettingsWriter(output_file=self.SETTINGS_FILE, colour_scheme=cd).write()

    def line_shifter_update(self, *args):
        print(f"line_shifter_update: {args=}")
        status = self.line_shifter.status
        print(f"BEFORE: {status.get()}")
        current = eval(status.get())
        if current["submission"]:
            self.calendar_surface.shift_line(
                current,
                dealer_status=self.frame_colour_coder.status
            )
            current["submission"] = False
        status.set(current)
        print(f"AFTER:  {status.get()}")

    # def unit_search_update(self):
    #     text = self.tv_entry_unit_scroll_search.get()
    #     if text:
    #

    def colour_code_dealer(self, dealer_in):
        if dealer_in:
            dealer_colour = self.frame_colour_coder.status[dealer_in]
            if dealer_colour and dealer_colour != "none":
                self.calendar_surface.colour_code_dealer(dealer_in, dealer_colour)

    def get_app_state(self):
        return self._app_state

    def set_app_state(self, app_state_in):
        if app_state_in not in self.valid_app_states:
            raise ValueError(
                f"Error param 'app_state_in' is not a valid app state.\nMust be one of {self.valid_app_states}\nGot: {app_state_in}")
        self._app_state = app_state_in
        self.tv_debug_app_state.set(self.app_state)

    def del_app_state(self):
        del self._app_state

    app_state = property(get_app_state, set_app_state, del_app_state)
