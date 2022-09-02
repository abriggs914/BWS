import datetime
import tkinter
from tkinter import ttk
from tkinter_utility import entry_factory, button_factory
from calendar_surface import CalendarSurface
from pyodbc_connection import connect
from utility import clamp


class App(tkinter.Tk):

    def __init__(self, TITLE="Stargate Production Scheduler", WIDTH=500, HEIGHT=500):
        super().__init__()

        self.df_production = None
        self.populate_data()

        self.valid_app_states = ["IDLE", "DRAGGING", "SELECTED"]
        self.app_state = "IDLE"
        self.drag_tile = None
        self.drag_coordinates = None

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
        self.combo_unit_selection = ttk.Combobox(self.frame_top_bar, values=self.dat_list_of_units())
        self.tv_btn_insert_combo_choice, self.button_insert_combo_choice = button_factory(self.frame_top_bar, tv_btn="+")
        self.button_insert_combo_choice.config(command=self.click_insert_combo_choice)

        # canvas and calendar objects
        can_w, can_h = int(self.window_width * 0.75), int(self.window_height * 0.65)
        self.frame_calendar_a = tkinter.Frame(self)
        self.frame_calendar_b = tkinter.Frame(self.frame_calendar_a)

        self.calendar_surface = CalendarSurface(self.frame_calendar_b, can_w, can_h, datetime.datetime.now())
        self.tv_btn_scroll_left, self.button_scroll_left = button_factory(self.frame_calendar_a, tv_btn="left")
        self.tv_btn_scroll_right, self.button_scroll_right = button_factory(self.frame_calendar_a, tv_btn="right")

        # bind event handlers
        self.calendar_surface.bind("<Button-1>", self.click_calendar_surface)
        self.calendar_surface.bind("<Motion>", self.motion_calendar_surface)
        self.button_scroll_left.config(command=self.click_left_scroll)
        self.button_scroll_right.config(command=self.click_right_scroll)

        # pack widgets
        self.frame_top_bar.pack()
        self.combo_unit_selection.pack()
        self.button_insert_combo_choice.pack()

        self.frame_calendar_a.pack()
        self.frame_calendar_b.pack()
        self.calendar_surface.pack(side=tkinter.TOP)
        self.button_scroll_left.pack(side=tkinter.LEFT)
        self.button_scroll_right.pack(side=tkinter.RIGHT)

    def populate_data(self):
        self.df_production = connect(
            """SELECT
                [OrdersV2].*,
                [ProductionV2].*
            FROM
            	[OrdersV2]
            LEFT JOIN
            	[ProductionV2]
            ON
            	[OrdersV2].[SGQuote] = [ProductionV2].[SGQuote]
            WHERE
            	[Prod Date] IS NULL
            	AND [Prod Date2] IS NULL
            	AND [OrdersV2].[Order Date] IS NOT NULL"""
        )

    def dat_list_of_units(self):
        return [tup[0] for tup in self.df_production["SGQuote"].values.tolist()]

    def click_calendar_surface(self, *event):
        print(f"click {event=}")

    def motion_calendar_surface(self, event):
        print(f"motion {event=}")
        if self.app_state == "DRAGGING":
            dt = self.drag_tile
            bbox = self.calendar_surface.bbox(dt)
            cx, cy, cw, ch = self.calendar_surface.winfo_rootx(), self.calendar_surface.winfo_rooty(), self.calendar_surface.winfo_width(), self.calendar_surface.winfo_height()
            # xe, ye = event
            xe, ye = event.x - (self.calendar_surface.tile_width / 2), event.y - (self.calendar_surface.tile_height / 2)
            mx, my = self.winfo_width() - (2 * self.calendar_surface.tile_width) - cx, self.winfo_height() - (2 * self.calendar_surface.tile_height) - cy
            print(f"{bbox=}, {cx=}, {cy=}, {cw=}, {ch=}, {mx=}, {my=}, {xe=}, {ye=}")
            xe = clamp(0, xe, mx) - cx
            ye = clamp(0, ye, my) - cy
            self.calendar_surface.moveto(dt, xe, ye)

    def click_left_scroll(self):
        print(f"click_left")
        self.calendar_surface.scroll_left()

    def click_right_scroll(self):
        print(f"click_right")
        self.calendar_surface.scroll_right()

    def click_insert_combo_choice(self):
        print(f"insert combo choice")
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
                # self.drag_coordinates =
                dt = self.drag_tile
        super(App, self).update()
