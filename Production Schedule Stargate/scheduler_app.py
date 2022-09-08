import datetime
import tkinter
from tkinter import ttk

from colour_utility import rgb_to_hex, random_colour
from tkinter_utility import entry_factory, button_factory
from calendar_surface import CalendarSurface
from pyodbc_connection import connect
from utility import clamp


class App(tkinter.Tk):

    def __init__(self, TITLE="Stargate Production Scheduler", WIDTH=500, HEIGHT=500):
        super().__init__()


        self.df_production = None
        self.df_work_days = None
        self.populate_data()

        # State variables
        self.valid_app_states = ["IDLE", "DRAGGING", "SELECTED"]
        self._app_state = "IDLE"
        self.drag_tile = None
        self.drag_text = None
        self.dragging_details = None
        self.select_tile = None
        self.select_text = None
        self.select_details = None

        self.TITLE = TITLE
        self.WIDTH = WIDTH
        self.HEIGHT = HEIGHT
        self.geometry(f"{self.WIDTH}x{self.HEIGHT}")
        self.state("zoomed")
        self.title(self.TITLE)
        self.update()
        self.window_width = self.winfo_width()
        self.window_height = self.winfo_height()

        self.frame_top_bar = tkinter.Frame(self)
        self.tv_combo_unit_selection = tkinter.StringVar(self)
        self.combo_unit_selection = ttk.Combobox(self.frame_top_bar, values=self.dat_list_of_units(), textvariable=self.tv_combo_unit_selection)
        self.tv_btn_insert_combo_choice, self.button_insert_combo_choice = button_factory(self.frame_top_bar, tv_btn="+")
        self.button_insert_combo_choice.config(command=self.click_insert_combo_choice)
        self.tv_btn_save_changes, self.button_save_changes = button_factory(self.frame_top_bar, tv_btn="save", kwargs_btn={"command": self.click_save_changes})
        self.tv_label_debug_app_state, self.debug_label_entry_app_state, self.tv_debug_app_state, self.debug_entry_app_state = entry_factory(self.frame_top_bar, tv_label="App State:", tv_entry=self.app_state, kwargs_entry={"state": "readonly"})

        # canvas and calendar objects
        can_w, can_h = int(self.window_width * 0.75), int(self.window_height * 0.65)
        self.frame_calendar_a = tkinter.Frame(self)
        self.frame_calendar_b = tkinter.Frame(self.frame_calendar_a)

        self.calendar_surface = CalendarSurface(self.frame_calendar_b, can_w, can_h, datetime.datetime.now())
        self.calendar_surface.populate_units(self.df_production)
        self.tv_btn_scroll_left, self.button_scroll_left = button_factory(self.frame_calendar_a, tv_btn="left", kwargs_btn={"command": self.click_left_scroll})
        self.tv_btn_scroll_right, self.button_scroll_right = button_factory(self.frame_calendar_a, tv_btn="right", kwargs_btn={"command": self.click_right_scroll})
        for tile_row in self.calendar_surface.tiles:
            for tile in tile_row:
                self.calendar_surface.tag_bind(tile, "<Double-Button-1>", self.dbl_click_tile)

        # bind event handlers
        self.calendar_surface.bind("<Button-1>", self.click_calendar_surface)
        self.calendar_surface.bind("<Motion>", self.motion_calendar_surface)

        # pack widgets
        self.frame_top_bar.pack()
        self.combo_unit_selection.pack()
        self.button_insert_combo_choice.pack()
        self.button_save_changes.pack()
        self.debug_label_entry_app_state.pack()
        self.debug_entry_app_state.pack()

        self.frame_calendar_a.pack()
        self.frame_calendar_b.pack()
        self.calendar_surface.pack(side=tkinter.TOP)
        self.button_scroll_left.pack(side=tkinter.LEFT)
        self.button_scroll_right.pack(side=tkinter.RIGHT)

    def populate_data(self):
        """Mass Database Query 'Getter' Function. Should be called at the beginning of app execution, or using a thread."""
        # Order and production data pertaining to Stargate units
        self.df_production = connect("""



-- Final Select Query for all STG Prod dates

SELECT
	[dtProductionSchedule].*
	, [dtProductionScheduleV2].*
	, [OrdersV2].*
FROM
	[BWSdb].[dbo].[OrdersV2]
LEFT JOIN 
	[dtProductionSchedule]
ON
	[dtProductionSchedule].[SGQuote] = [OrdersV2].[SGQuote]
LEFT JOIN 
	[dtProductionScheduleV2]
ON
	[dtProductionScheduleV2].[SGQuote] = [OrdersV2].[SGQuote]
WHERE
	[dtProductionScheduleV2].[JobFinishDate] IS NOT NULL
ORDER BY
	[dtProductionScheduleV2].[JobFinishDate]
;

        """, database="Stargatedb", uid="SGeu1", pwd="Pupplies-Hagard->Rio0")
#         self.df_production = connect("""
#
# SELECT
# 	*
# FROM
# 	[dtProductionSchedule]
# LEFT JOIN
# 	[BWSdb].[dbo].[OrdersV2]
# ON
# 	[dtProductionSchedule].[SGQuote] = [OrdersV2].[SGQuote]
# WHERE
# 	ISNULL([dtProductionSchedule].[Prod Date 1], [dtProductionSchedule].[Prod Date 2]) IS NOT NULL
# ORDER BY
# 	ISNULL([dtProductionSchedule].[Prod Date 1], [dtProductionSchedule].[Prod Date 2])
# ;
#
#         """, database="Stargatedb", uid="SGeu1", pwd="Pupplies-Hagard->Rio0")

        self.df_work_days = connect("""SELECT * FROM [v_CalendarWorkDays] ORDER BY [CalendarDate] DESC""", database="SysproCompanyS", uid="SCSRS", pwd="")

    def dat_list_of_units(self):
        return [tup[0] for tup in self.df_production["SGQuote"].values.tolist()]

    def click_calendar_surface(self, event):
        print(f"click {event=}")
        x, y = event.x, event.y
        tile = self.calendar_surface.tile_at_xy((x, y))
        if tile is not None:
            if self.app_state == "IDLE":

                self.app_state = "SELECTED"
                self.calendar_surface.itemconfigure(tile, fill=rgb_to_hex(random_colour()))
                self.select_tile = tile
                self.select_details = {
                    # "quote": self.tv_combo_unit_selection.get(),
                    # "unit": self.calendar_surface.units[self.tv_combo_unit_selection.get()]
                }

            elif self.app_state == "DRAGGING":

                self.app_state = "IDLE"
                # self.calendar_surface.it
                # TODO take the dragging tile data and insert it into the tile where the click was set.
                self.drag_tile = None
                self.calendar_surface.itemconfigure(tile, fill=rgb_to_hex(random_colour()))

            else:

                # self.app_state == "SELECTED"
                self.calendar_surface.itemconfigure(tile, fill=rgb_to_hex(random_colour()))
                self.select_tile = tile
                self.select_details = {
                    # "quote": self.tv_combo_unit_selection.get(),
                    # "unit": self.calendar_surface.units[self.tv_combo_unit_selection.get()]
                }


    def motion_calendar_surface(self, event):
        print(f"motion {event=}")
        if self.app_state == "DRAGGING":
            dt = self.drag_tile
            bbox = self.calendar_surface.bbox(dt)
            cx, cy, cw, ch = self.calendar_surface.winfo_rootx(), self.calendar_surface.winfo_rooty(), self.calendar_surface.winfo_width(), self.calendar_surface.winfo_height()
            # xe, ye = event

            # xe = event.x - (self.calendar_surface.tile_width / 2)
            # ye = event.y - (self.calendar_surface.tile_height / 2)
            # # mx = self.winfo_width() - (2 * self.calendar_surface.tile_width) - cx - (self.calendar_surface.tile_width / 1.5)
            # # my = self.winfo_height() - (2 * self.calendar_surface.tile_height) - cy - (self.calendar_surface.tile_height / 1.5)
            # mx = cx + self.calendar_surface.winfo_width() - (self.calendar_surface.tile_width / 1)
            # my = cy + self.calendar_surface.winfo_height() - (self.calendar_surface.tile_height / 1)
            # print(f"{bbox=}, {cx=}, {cy=}, {cw=}, {ch=}, {mx=}, {my=}, {xe=}, {ye=}")
            # xe = clamp(0, xe, mx)
            # ye = clamp(0, ye, my)

            x = self.calendar_surface.canvasx(event.x) - (self.calendar_surface.tile_width / 2)
            y = self.calendar_surface.canvasx(event.y) - (self.calendar_surface.tile_height / 2)
            bbox = [
                self.calendar_surface.winfo_x(),
                self.calendar_surface.winfo_y(),
                self.calendar_surface.winfo_x() + self.calendar_surface.winfo_width() - (self.calendar_surface.tile_width / 2),
                self.calendar_surface.winfo_y() + self.calendar_surface.winfo_height() - (self.calendar_surface.tile_height / 2)
            ]
            xe = clamp(bbox[0], x, bbox[2])
            ye = clamp(bbox[1], y, bbox[3])
            self.calendar_surface.moveto(dt, xe, ye)
            self.calendar_surface.moveto(self.drag_text, xe, ye)

            # xe, ye = event.x - (self.calendar_surface.tile_width / 2), event.y - (self.calendar_surface.tile_height / 2)
            # mx, my = self.winfo_width() - (2 * self.calendar_surface.tile_width) - cx - (self.calendar_surface.tile_width / 1.5), self.winfo_height() - (2 * self.calendar_surface.tile_height) - cy - (self.calendar_surface.tile_height / 1.5)
            # print(f"{bbox=}, {cx=}, {cy=}, {cw=}, {ch=}, {mx=}, {my=}, {xe=}, {ye=}")
            # xe = clamp(0, xe, mx)
            # ye = clamp(0, ye, my)
            # self.calendar_surface.moveto(dt, xe, ye)

    def click_save_changes(self):
        print(f"SAVING")

    def click_left_scroll(self):
        print(f"click_left")
        self.calendar_surface.scroll_left()

    def click_right_scroll(self):
        print(f"click_right")
        self.calendar_surface.scroll_right()

    def click_insert_combo_choice(self):
        print(f"insert combo choice")
        self.app_state = "DRAGGING"
        self.dragging_details = {
            "quote": self.tv_combo_unit_selection.get(),
            "unit": self.calendar_surface.units[self.tv_combo_unit_selection.get()]
        }
        self.update()

    def dbl_click_tile(self, event):
        # self.calendar_surface.dbl_click_tile(event)
        x, y = event.x, event.y
        tile = self.calendar_surface.tile_at_xy((x, y))
        print(f"Double click!, tile chosen: {tile}")
        if tile is not None:
            self.drag_tile = tile
            self.app_state = "DRAGGING"
            self.update()

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
                self.drag_tile = self.calendar_surface.create_rectangle(x1 - (tw / 2), y1, x1 + (tw / 2), y1 + th, fill="indigo")
                self.drag_text = self.calendar_surface.create_text(x1, y1 + (th / 2), text=self.dragging_details["quote"], width=x1 + (tw / 2), fill="white")
                # self.drag_coordinates =
                dt = self.drag_tile
        super(App, self).update()

    def get_app_state(self):
        return self._app_state

    def set_app_state(self, app_state_in):
        if app_state_in not in self.valid_app_states:
            raise ValueError(f"Error param 'app_state_in' is not a valid app state.\nMust be one of {self.valid_app_states}\nGot: {app_state_in}")
        self._app_state = app_state_in
        self.tv_debug_app_state.set(self.app_state)

    def del_app_state(self):
        del self._app_state

    app_state = property(get_app_state, set_app_state, del_app_state)
