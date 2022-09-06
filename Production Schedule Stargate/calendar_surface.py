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
            tile_background_colour: str = rgb_to_hex(GRAY_17),
            tile_outline_colour: str = rgb_to_hex(BLACK),
            active_fill_colour: str = rgb_to_hex(GRAY_66),
            active_outline_colour: str = rgb_to_hex(YELLOW_3),
            n_visible_cols: int = 14
    ):
        super().__init__(master, width=width, height=height)
        self.canvas_width = width
        self.canvas_height = height
        self.lines = [f"T{i}" for i in range(1, 7)]
        self.start_date = start_date
        self.end_date = self.start_date + relativedelta(months=6)
        self.rows = len(self.lines)
        self.cols = (self.end_date - self.start_date).days
        self.max_tiles = self.rows * self.cols

        self.n_visible_cols = n_visible_cols
        self.visible_cols = range(self.n_visible_cols)
        self.tile_background_colour = tile_background_colour
        self.tile_outline_colour = tile_outline_colour
        self.active_fill_colour = active_fill_colour
        self.active_outline_colour = active_outline_colour

        self.tile_space = 3
        self.tile_width = None
        self.tile_height = None
        self.texts = []
        self.tiles = self.init_tiles()

    def init_tiles(self):
        ts = self.tile_space  # space between tiles
        tw = (self.canvas_width - ((self.n_visible_cols + 1) * ts)) / (self.n_visible_cols + 1)  # tile width
        th = (self.canvas_height - ((self.rows + 1) * ts)) / (self.rows + 1)  # tile height
        self.tile_width = tw
        self.tile_height = th

        print(f"{self.rows=}, {self.cols=}")

        tiles = []
        n_slices = (self.rows + 1) * (self.cols + 1)
        print(f"{n_slices=}")
        grad = rainbow_gradient(n_slices)
        for r in range(self.rows + 1):
            row = []
            row_2 = []
            for c in range(self.cols + 1):
                x1 = (c * tw) + ((c + 1) * ts) + (ts / 2)
                y1 = (r * th) + ((r + 1) * ts) + (ts / 2)
                x2 = ((c + 1) * tw) + ((c + 1) * ts) + (ts / 2)
                y2 = ((r + 1) * th) + ((r + 1) * ts) + (ts / 2)
                xd = x2 - x1
                yd = y2 - y1
                tile_colour = rgb_to_hex(next(grad))
                font_colour = rgb_to_hex(font_foreground(tile_colour))
                outline_colour = self.tile_outline_colour
                active_fill_colour = self.active_fill_colour
                active_outline_colour = self.active_outline_colour
                # tile_colour = self.tile_background_colour
                # font_colour = "white"
                row.append(self.create_rectangle(
                    x1, y1, x2, y2,
                    fill=tile_colour,
                    outline=outline_colour,
                    activeoutline=active_outline_colour,
                    activefill=active_fill_colour
                ))
                text_1 = f"{r-1=}"
                text_2 = f"{c-1=}"
                if r == 0:
                    text_1 = f"{self.start_date + datetime.timedelta(days=c):%Y-%m-%d}"
                    text_2 = ""
                if c == 0 and r > 0:
                    text_1 = ""
                    text_2 = f"{self.lines[r - 1]}"
                row_2.append(self.create_text(
                    x1 + (xd / 2),
                    y1 + (yd / 4),
                    text=text_1,
                    fill=font_colour,
                    width=tw,
                    activefill=active_fill_colour
                ))
                row_2.append(self.create_text(
                    x1 + (xd / 2),
                    y1 + (3 * yd / 4),
                    text=text_2,
                    fill=font_colour,
                    width=tw,
                ))

            tiles.append(row)
            self.texts.append(row_2)
        return tiles

    def shift_tiles(self):
        ts = 3  # space between tiles
        tw = (self.canvas_width - ((self.n_visible_cols + 1) * ts)) / (self.n_visible_cols + 1)  # tile width
        th = (self.canvas_height - ((self.rows + 1) * ts)) / (self.rows + 1)  # tile height

        print(f"{self.rows=}, {self.cols=}")

        vis_range = self.visible_cols
        # col_offset = (vis_range.start * (tw + ts)) + ((tw + ts) / 2) + ts
        col_offset = (vis_range.start * (tw + ts)) + ts

        # tiles = []
        for r in range(self.rows + 1):
            # row = []
            for c in range(self.cols + 1):
                x1 = ((c * tw) + ((c + 1) * ts) + (ts / 2)) - col_offset
                y1 = (r * th) + ((r + 1) * ts) + (ts / 2)
                x2 = (((c + 1) * tw) + ((c + 1) * ts) + (ts / 2)) - col_offset
                y2 = ((r + 1) * th) + ((r + 1) * ts) + (ts / 2)
                xd = x2 - x1
                yd = y2 - y1
                text1 = self.find_withtag(self.texts[r][2 * c])
                text2 = self.find_withtag(self.texts[r][(2 * c) + 1])
                bb1 = self.bbox(self.texts[r][2 * c])
                bb2 = self.bbox(self.texts[r][(2 * c) + 1])
                print(f"{text1=}, {text2=}, {bb1=}, {bb2=}")
                self.moveto(self.tiles[r][c], x1, y1)
                # self.moveto(self.texts[r][2 * c], x1 + ((xd + ts) / 2) - ts)
                # self.moveto(self.texts[r][(2 * c) + 1], x1 + ((xd + ts) / 2) - ts)
                self.moveto(self.texts[r][2 * c], x1 + ts)
                self.moveto(self.texts[r][(2 * c) + 1], x1 + ts)

                # row.append(self.create_rectangle(
                #     x1, y1, x2, y2,
                #     fill=self.tile_background_colour
                # ))
            #     self.create_text(
            #         x1 + (xd / 2),
            #         y1 + (yd / 2),
            #         text=f"{r=}, {c=}",
            #         fill="white"
            #     )
            # tiles.append(row)
        # return tiles

    def scroll_left(self):
        ts = self.tile_space
        tw = self.tile_width
        th = self.tile_height
        r = self.visible_cols
        m = self.cols - self.n_visible_cols
        do_shift = self.visible_cols.start > 0
        self.visible_cols = range(clamp(0, r.start - 1, m), clamp(self.n_visible_cols, r.stop - 1, self.cols))
        print(f"{self.visible_cols=}")
        # self.shift_tiles()
        if do_shift:
            for r, tile_row in enumerate(self.tiles):
                for c, tile in enumerate(tile_row):
                    self.move(tile, tw + (ts / 2), 0)
                    self.move(self.texts[r][2 * c], tw + (ts / 2), 0)
                    self.move(self.texts[r][(2 * c) + 1], tw + (ts / 2), 0)

    def scroll_right(self):
        ts = self.tile_space
        tw = self.tile_width
        th = self.tile_height
        r = self.visible_cols
        m = self.cols - self.n_visible_cols
        do_shift = self.visible_cols.stop < (self.cols - 1)
        self.visible_cols = range(clamp(0, r.start + 1, m), clamp(self.n_visible_cols, r.stop + 1, self.cols))
        print(f"{self.visible_cols=}")
        # self.shift_tiles()
        if do_shift:
            for r, tile_row in enumerate(self.tiles):
                for c, tile in enumerate(tile_row):
                    self.move(tile, -(tw + (ts / 2)), 0)
                    self.move(self.texts[r][2 * c], -(tw + (ts / 2)), 0)
                    self.move(self.texts[r][(2 * c) + 1], -(tw + (ts / 2)), 0)

    def dbl_click_tile(self, event):
        print(f"{event}")
