import datetime
import tkinter

import pandas
from dateutil.relativedelta import relativedelta
from colour_utility import *
from unit import Unit


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
        # self.texts = []
        self.tile_properties = []
        self.tiles = self.init_tiles()
        self.units = {}

        print(f"{self.start_date=}, {self.end_date=}")

    def quote_rc(self, quote_in) -> tuple | None:
        """Retrieve the row and column for the specified quote number."""
        if quote_in in self.units:
            for r, tile_row in enumerate(self.tiles):
                for c, tile in enumerate(tile_row):
                    unit = self.tile_properties[r][c]["unit"]
                    if unit.SGQuote == quote_in:
                        return r, c
        print(f"Param 'quote_in' = <{quote_in}> not found in tiles.")
        return None

    def init_tiles(self) -> list:
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
        # TODO recalculate these positions so that the left most column is unaffected by the 'timeline' shifting
        #  Currently this tile is treated the same as all of the others
        for r in range(self.rows + 1):
            row = []
            row_2 = []
            tile_detail_row = []
            for c in range(self.cols + 1):
                x1 = (c * tw) + ((c + 1) * ts) + (ts / 2)
                y1 = (r * th) + ((r + 1) * ts) + (ts / 2)
                x2 = ((c + 1) * tw) + ((c + 1) * ts) + (ts / 2)
                y2 = ((r + 1) * th) + ((r + 1) * ts) + (ts / 2)
                xd = x2 - x1
                yd = y2 - y1
                # tile_colour = rgb_to_hex(next(grad))
                tile_colour = self.tile_background_colour
                font_colour = rgb_to_hex(font_foreground(tile_colour))
                outline_colour = self.tile_outline_colour
                active_fill_colour = self.active_fill_colour
                active_outline_colour = self.active_outline_colour
                row.append(self.create_rectangle(
                    x1, y1, x2, y2,
                    fill=tile_colour,
                    outline=outline_colour,
                    activeoutline=active_outline_colour,
                    activefill=active_fill_colour
                ))
                text_1 = tkinter.StringVar(self, value=f"{r-1=}")
                text_2 = tkinter.StringVar(self, value=f"{c-1=}")
                if r == 0 and c > 0:
                    text_1.set(f"{self.start_date + datetime.timedelta(days=c):%Y-%m-%d}")
                    text_2.set("")
                if c == 0 and r > 0:
                    text_1.set("")
                    text_2.set(f"{self.lines[r - 1]}")

                offset = (1 * yd / 10)
                text_3, text_4, text_5 = tkinter.StringVar(self, value=f"{row[-1]}"), tkinter.StringVar(self, value="4"), tkinter.StringVar(self, value="5")
                t1_x1, t1_y1 = x1 + (xd / 2), y1 + offset
                t2_x1, t2_y1 = x1 + (xd / 2), y1 + (1 * yd / 5) + offset
                t3_x1, t3_y1 = x1 + (xd / 2), y1 + (2 * yd / 5) + offset
                t4_x1, t4_y1 = x1 + (xd / 2), y1 + (3 * yd / 5) + offset
                t5_x1, t5_y1 = x1 + (xd / 2), y1 + (4 * yd / 5) + offset

                for i in range(1, 6):
                    wip_x = eval(f"t{i}_x1")
                    wip_y = eval(f"t{i}_y1")
                    wip_t = eval(f"text_{i}")
                    row_2.append(
                        self.create_text(
                            wip_x,
                            wip_y,
                            text=wip_t.get(),
                            fill=font_colour,
                            width=tw,
                            activefill=active_fill_colour
                        )
                    )

                # row_2.append(self.create_text(
                #     t1_x1,
                #     t1y1,
                #     text=text_1,
                #     fill=font_colour,
                #     width=tw,
                #     activefill=active_fill_colour
                # ))
                # row_2.append(self.create_text(
                #     x1 + (xd / 2),
                #     y1 + (3 * yd / 4),
                #     text=text_2,
                #     fill=font_colour,
                #     width=tw,
                # ))
                tile_details = {
                    "tag_rect": row[-1],
                    "x1": x1,
                    "y1": y1,
                    "x2": x2,
                    "y2": y2,

                    "t1_tag": row_2[-5],
                    "t1_x1": t1_x1,
                    "t1_y1": t1_y1,
                    "text_1": text_1,

                    "t2_tag": row_2[-4],
                    "t2_x1": t2_x1,
                    "t2_y1": t2_y1,
                    "text_2": text_2,

                    "t3_tag": row_2[-3],
                    "t3_x1": t3_x1,
                    "t3_y1": t3_y1,
                    "text_3": text_3,

                    "t4_tag": row_2[-2],
                    "t4_x1": t4_x1,
                    "t4_y1": t4_y1,
                    "text_4": text_4,

                    "t5_tag": row_2[-1],
                    "t5_x1": t5_x1,
                    "t5_y1": t5_y1,
                    "text_5": text_5,

                    "unit":None
                }

                tile_detail_row.append(tile_details)
            tiles.append(row)
            # self.texts.append(row_2)
            self.tile_properties.append(tile_detail_row)

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

    def scroll_left(self) -> None:
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
                    tag_t1 = self.tile_properties[r][c]["t1_tag"]
                    tag_t2 = self.tile_properties[r][c]["t2_tag"]
                    tag_t3 = self.tile_properties[r][c]["t3_tag"]
                    tag_t4 = self.tile_properties[r][c]["t4_tag"]
                    tag_t5 = self.tile_properties[r][c]["t5_tag"]
                    self.move(tag_t1, (tw + (ts / 2)), 0)
                    self.move(tag_t2, (tw + (ts / 2)), 0)
                    self.move(tag_t3, (tw + (ts / 2)), 0)
                    self.move(tag_t4, (tw + (ts / 2)), 0)
                    self.move(tag_t5, (tw + (ts / 2)), 0)
                    # self.move(self.texts[r][2 * c], tw + (ts / 2), 0)
                    # self.move(self.texts[r][(2 * c) + 1], tw + (ts / 2), 0)

    def scroll_right(self) -> None:
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
                    tag_t1 = self.tile_properties[r][c]["t1_tag"]
                    tag_t2 = self.tile_properties[r][c]["t2_tag"]
                    tag_t3 = self.tile_properties[r][c]["t3_tag"]
                    tag_t4 = self.tile_properties[r][c]["t4_tag"]
                    tag_t5 = self.tile_properties[r][c]["t5_tag"]
                    self.move(tag_t1, -(tw + (ts / 2)), 0)
                    self.move(tag_t2, -(tw + (ts / 2)), 0)
                    self.move(tag_t3, -(tw + (ts / 2)), 0)
                    self.move(tag_t4, -(tw + (ts / 2)), 0)
                    self.move(tag_t5, -(tw + (ts / 2)), 0)
                    # self.move(self.texts[r][2 * c], -(tw + (ts / 2)), 0)
                    # self.move(self.texts[r][(2 * c) + 1], -(tw + (ts / 2)), 0)

    def dbl_click_tile(self, event):
        print(f"{event}")

    def tile_at_xy(self, xy: tuple[int, int]) -> int | None:
        # print(f"{self.tiles=}")
        # x, y = self.winfo_pointerxy()
        # print(f"{self.canvasx(x)=}, {self.canvasy(y)}")
        x, y = xy
        for tile_row in self.tiles:
            for col_idx in range(self.visible_cols.start, self.visible_cols.stop + 1):
                tile = tile_row[col_idx]
                bbox = self.bbox(tile)
                # print(f"\t\t{tile=}, {x=}, {y=}, {bbox=}")
                if bbox[0] <= x <= bbox[2] and bbox[1] <= y <= bbox[3]:
                    return tile
        return None

    def populate_units(self, df: pandas.DataFrame) -> None:
        assert isinstance(df, pandas.DataFrame)
        for row in df.iterrows():
            values = row[1].tolist()
            print(f"{len(values)=}, {values=}")
            unit = Unit(*values)
            print(f"{unit=}, {list(unit)=}")
            sgquote = unit.SGQuote
            self.units[sgquote] = unit
            avail_date = unit.Available_Date
            finish_date_1 = unit.job_finish_date_v2
            finish_date_2 = unit.Finish_Date
            print(f"LINES: {unit.job_start_date_v2=}, {unit.job_finish_date_v2=}, {unit.Available_Date=}, {unit.Delivery_Date=}, {unit.Finish_Date=}")
            print(f"\t\t{avail_date=}, {finish_date_1=}, {finish_date_2=}")
            if avail_date and (self.start_date <= avail_date <= self.end_date):
                print(f"\t\tVALID avail_date!!")
            elif finish_date_1 and finish_date_1 != "None" and (self.start_date <= finish_date_1 <= self.end_date):
                print(f"\t\tVALID finish_date_1!!")
            elif finish_date_2 and finish_date_1 != "None" and (self.start_date <= finish_date_2 <= self.end_date):
                print(f"\t\tVALID finish_date_2!!")
            else:
                print(f"{avail_date=}, {finish_date_1=}, {finish_date_2=}  not found.")
            # print(f"{unit}")
