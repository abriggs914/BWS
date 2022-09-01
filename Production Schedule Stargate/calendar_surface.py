import datetime
import tkinter
from dateutil.relativedelta import relativedelta
from colour_utility import *


class CalendarSurface(tkinter.Canvas):

    def __init__(
            self,
            master,
            width: int,
            height: int,
            start_date: datetime.datetime,
            tile_background_colour=rgb_to_hex(GRAY_17)
    ):
        super().__init__(master, width=width, height=height)
        self.canvas_width = width
        self.canvas_height = height
        self.lines = [f"T{i}" for i in range(1, 7)]
        self.start_date = start_date
        self.end_date = self.start_date + relativedelta(months=6)
        self.rows = len(self.lines)
        self.cols = (self.end_date - self.start_date).days

        self.n_visible_cols = 25
        self.visible_cols = range(25)
        self.tile_background_colour = tile_background_colour

        self.tiles = self.init_tiles()

    def init_tiles(self):
        ts = 3  # space between tiles
        tw = (self.canvas_width - ((self.n_visible_cols + 1) * ts)) / self.n_visible_cols  # tile width
        th = (self.canvas_height - ((self.rows + 1) * ts)) / self.rows  # tile height

        print(f"{self.rows=}, {self.cols=}")

        tiles = []
        for r in range(self.rows + 1):
            row = []
            for c in range(self.cols + 1):
                x1 = (c * tw) + ((c + 1) * ts) + (ts / 2)
                y1 = (r * th) + ((r + 1) * ts) + (ts / 2)
                x2 = ((c + 1) * tw) + ((c + 1) * ts) + (ts / 2)
                y2 = ((r + 1) * th) + ((r + 1) * ts) + (ts / 2)
                xd = x2 - x1
                yd = y2 - y1
                row.append(self.create_rectangle(
                    x1, y1, x2, y2,
                    fill=self.tile_background_colour
                ))
                self.create_text(
                    x1 + (xd / 2),
                    y1 + (yd / 2),
                    text=f"{r=}, {c=}",
                    fill="white"
                )
            tiles.append(row)
        return tiles

    def shift_tiles(self):
        ts = 3  # space between tiles
        tw = (self.canvas_width - ((self.n_visible_cols + 1) * ts)) / self.n_visible_cols  # tile width
        th = (self.canvas_height - ((self.rows + 1) * ts)) / self.rows  # tile height

        print(f"{self.rows=}, {self.cols=}")

        tiles = []
        for r in range(self.rows + 1):
            row = []
            for c in range(self.cols + 1):
                x1 = (c * tw) + ((c + 1) * ts) + (ts / 2)
                y1 = (r * th) + ((r + 1) * ts) + (ts / 2)
                x2 = ((c + 1) * tw) + ((c + 1) * ts) + (ts / 2)
                y2 = ((r + 1) * th) + ((r + 1) * ts) + (ts / 2)
                xd = x2 - x1
                yd = y2 - y1
                row.append(self.create_rectangle(
                    x1, y1, x2, y2,
                    fill=self.tile_background_colour
                ))
                self.create_text(
                    x1 + (xd / 2),
                    y1 + (yd / 2),
                    text=f"{r=}, {c=}",
                    fill="white"
                )
            tiles.append(row)
        return tiles

    def scroll_left(self):
        r = self.visible_cols
        m = self.cols - self.n_visible_cols
        self.visible_cols = range(clamp(0, r.start - 1, m), clamp(self.n_visible_cols, r.stop - 1, self.cols))
        print(f"{self.visible_cols=}")

    def scroll_right(self):
        r = self.visible_cols
        m = self.cols - self.n_visible_cols
        self.visible_cols = range(clamp(0, r.start + 1, m), clamp(self.n_visible_cols, r.stop + 1, self.cols))
        print(f"{self.visible_cols=}")
