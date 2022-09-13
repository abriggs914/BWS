import datetime
import tkinter

import pandas
from dateutil.relativedelta import relativedelta
from colour_utility import *
from unit import Unit
from utility import dict_print, date_suffix

PROGRAM_MODE = "LIVE"
# PROGRAM_MODE = "TEST"


class CalendarSurface(tkinter.Canvas):

    def __init__(
            self,
            master,
            width: int,
            height: int,
            start_date: datetime.datetime,

            # colours for date axis legend (Y)
            row_legend_background_colour: str = rgb_to_hex(GRAY_8),
            row_legend_outline_colour: str = rgb_to_hex(BLACK),
            row_legend_active_background_colour: str = rgb_to_hex(GRAY_42),
            row_legend_active_outline_colour: str = rgb_to_hex(BLACK),

            # colours for trailer line axis legend (X)
            col_legend_background_colour: str = rgb_to_hex(GRAY_8),
            col_legend_outline_colour: str = rgb_to_hex(BLACK),
            col_legend_active_background_colour: str = rgb_to_hex(GRAY_42),
            col_legend_active_outline_colour: str = rgb_to_hex(BLACK),

            # regular tile coulour
            tile_background_colour: str = rgb_to_hex(GRAY_17),
            tile_outline_colour: str = rgb_to_hex(BLACK),
            active_fill_colour: str = rgb_to_hex(GRAY_66),
            active_outline_colour: str = rgb_to_hex(YELLOW_3),

            # weekend tile coulour
            tile_wkd_background_colour: str = rgb_to_hex(GRAY_8),
            tile_wkd_outline_colour: str = rgb_to_hex(GRAY_8),
            active_wkd_fill_colour: str = rgb_to_hex(GRAY_8),
            active_wkd_outline_colour: str = rgb_to_hex(GRAY_8),

            n_visible_cols: int = 14,
            sql_output_file_name: str = "./{ts}_sql_output.sql",
            text_order: list[str] = ["SGQuote", "InputField1_v2", "InputField2_v2", "WO", "GALV?"]
    ):
        super().__init__(master, width=width, height=height)
        self.canvas_width = width
        self.canvas_height = height
        self.lines = [f"T{i}" for i in range(1, 7)]
        self.start_date = start_date
        self.end_date = self.start_date + relativedelta(months=6)
        self.dates_list = [self.start_date + datetime.timedelta(days=i) for i in range((self.end_date - self.start_date).days)] + [self.end_date]
        self.rows = len(self.lines)
        self.cols = (self.end_date - self.start_date).days
        self.max_tiles = self.rows * self.cols
        self.text_order = text_order

        self.n_visible_cols = n_visible_cols
        self.visible_cols = range(self.n_visible_cols)
        self.tile_background_colour = tile_background_colour
        self.tile_outline_colour = tile_outline_colour
        self.active_fill_colour = active_fill_colour
        self.active_outline_colour = active_outline_colour

        self.tile_wkd_background_colour = tile_wkd_background_colour
        self.tile_wkd_outline_colour = tile_wkd_outline_colour
        self.active_wkd_fill_colour = active_wkd_fill_colour
        self.active_wkd_outline_colour = active_wkd_outline_colour

        self.row_legend_background_colour = row_legend_background_colour
        self.row_legend_outline_colour = row_legend_outline_colour
        self.row_legend_active_background_colour = row_legend_active_background_colour
        self.row_legend_active_outline_colour = row_legend_active_outline_colour
        self.col_legend_background_colour = col_legend_background_colour
        self.col_legend_outline_colour = col_legend_outline_colour
        self.col_legend_active_background_colour = col_legend_active_background_colour
        self.col_legend_active_outline_colour =col_legend_active_outline_colour

        self.tile_space = 3
        self.tile_width = None
        self.tile_height = None
        # self.texts = []
        self.tile_properties = []  # list of dictionaries containing the rest of the required tile data (text id and tvs)
        self.tiles = self.init_tiles()  # list of canvas tags for the cells len = n_rows * n_cols
        self.units = {None: None, "": None}  # dictionary of Stargate quote numbers.

        self.sql_output_file_name = sql_output_file_name

        print(f"{self.start_date=}, {self.end_date=}")

    def quote_rc(self, quote_in) -> tuple | None:
        """Retrieve the row and column for the specified quote number."""
        if quote_in in self.units:
            for r, tile_row in enumerate(self.tiles):
                for c, tile in enumerate(tile_row):
                    unit = self.tile_properties[r][c]["unit_in"]
                    if unit:
                        print(f"\t\t checking {unit=}")
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
                outline_colour = self.tile_outline_colour
                active_fill_colour = self.active_fill_colour
                active_outline_colour = self.active_outline_colour
                if r == 0 and c > 0:
                    tile_colour = self.col_legend_background_colour
                    outline_colour = self.col_legend_outline_colour
                    active_fill_colour = self.col_legend_active_background_colour
                    active_outline_colour = self.col_legend_active_outline_colour
                if c == 0 and r > 0:
                    tile_colour = self.row_legend_background_colour
                    outline_colour = self.row_legend_outline_colour
                    active_fill_colour = self.row_legend_active_background_colour
                    active_outline_colour = self.row_legend_active_outline_colour
                if r == 0 and c == 0:
                    tile_colour = rgb_to_hex(BLACK)
                    outline_colour = rgb_to_hex(WHITE)
                    active_fill_colour = rgb_to_hex(WHITE)
                    active_outline_colour = rgb_to_hex(BLACK)

                if c > 0:
                    dat = self.dates_list[c - 1]
                    if dat.weekday() > 4:
                        tile_colour = self.tile_wkd_background_colour
                        outline_colour = self.tile_wkd_outline_colour
                        active_fill_colour = self.active_wkd_fill_colour
                        active_outline_colour = self.active_wkd_outline_colour

                font_colour = rgb_to_hex(font_foreground(tile_colour))
                row.append(self.create_rectangle(
                    x1, y1, x2, y2,
                    fill=tile_colour,
                    outline=outline_colour,
                    activeoutline=active_outline_colour,
                    activefill=active_fill_colour
                ))
                # text_1 = tkinter.StringVar(self, name=self.cal, value=f"{r-1=}")
                text_1 = tkinter.StringVar(self, name=self.sv_keyify(r, c, 1), value=f"{r-1=}")
                text_2 = tkinter.StringVar(self, name=self.sv_keyify(r, c, 2), value=f"{c-1=}")
                text_3 = tkinter.StringVar(self, name=self.sv_keyify(r, c, 3), value=f"")
                text_4 = tkinter.StringVar(self, name=self.sv_keyify(r, c, 4), value=f"")
                text_5 = tkinter.StringVar(self, name=self.sv_keyify(r, c, 5), value=f"")

                if PROGRAM_MODE == "LIVE":
                    # if r == 0 and c > 0:
                    #     # text_1.set(f"{self.start_date + datetime.timedelta(days=c):%Y-%m-%d}")
                    #     text_1.set(f"{self.dates_list[c - 1]:%Y-%m-%d}")
                    #     text_2.set("")
                    # elif c == 0 and r > 0:
                    #     text_1.set("")
                    #     text_2.set(f"{self.lines[r - 1]}")
                    # else:
                    #     text_1.set("")
                    #     text_2.set("")
                    if r == 0 and c > 0:
                        # text_1.set(f"{self.start_date + datetime.timedelta(days=c):%Y-%m-%d}")
                        today = self.dates_list[c - 1]
                        text_1.set(f"{today:%Y}")
                        text_2.set(f"{today:%B}")
                        text_3.set(f"{today:%d}")
                        text_3.set("{}{}".format(int(text_3.get()), date_suffix(int(text_3.get()))))
                        text_4.set(f"{today:%A}")
                    elif c == 0 and r > 0:
                        text_1.set("")
                        text_2.set(f"{self.lines[r - 1]}")
                    else:
                        text_1.set("")
                        text_2.set("")
                else:
                    if r == 0 and c > 0:
                        text_1.set(f"{self.start_date + datetime.timedelta(days=c):%Y-%m-%d}")
                        text_2.set("")
                    if c == 0 and r > 0:
                        text_1.set("")
                        text_2.set(f"{self.lines[r - 1]}")

                    text_3.set(f"{row[-1]}")
                    text_4.set(f"{r=}")
                    text_5.set(f"{c=}")

                offset = (1 * yd / 10)
                t1_x1, t1_y1 = x1 + (xd / 2), y1 + offset
                t2_x1, t2_y1 = x1 + (xd / 2), y1 + (1 * yd / 5) + offset
                t3_x1, t3_y1 = x1 + (xd / 2), y1 + (2 * yd / 5) + offset
                t4_x1, t4_y1 = x1 + (xd / 2), y1 + (3 * yd / 5) + offset
                t5_x1, t5_y1 = x1 + (xd / 2), y1 + (4 * yd / 5) + offset

                text_1.trace_variable("w", self.update_canvas_text)
                text_2.trace_variable("w", self.update_canvas_text)
                text_3.trace_variable("w", self.update_canvas_text)
                text_4.trace_variable("w", self.update_canvas_text)
                text_5.trace_variable("w", self.update_canvas_text)

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

                    "unit_in": None
                }

                tile_detail_row.append(tile_details)
            tiles.append(row)
            # self.texts.append(row_2)
            self.tile_properties.append(tile_detail_row)

        return tiles

    def sv_keyify(self, r, c, num):
        s = "___"
        return "tv{s}{r}{s}{c}{s}{num}".format(r=f"000{r}"[-3:], c=f"000{c}"[-3:], num=f"000{num}"[-3:], s=s)

    def sv_dekeyify(self, key):
        s = "___"
        spl = key.split(s)
        return list(map(int, spl[1:]))

    def update_canvas_text(self, var_name, index, mode):
        r_c_num = self.sv_dekeyify(var_name)
        if r_c_num:
            r, c, num = r_c_num
            tag = self.tile_properties[r][c][f"t{num}_tag"]
            value = self.tile_properties[r][c][f'text_{num}'].get()
            self.itemconfigure(tag, text=value)
            # print(f"retrieving: {value=}")
            print(f"A{var_name=}, {index=}, {mode=}, {value=}, {tag=}")
        # self.itemconfigure()
        else:
            print(f"B{var_name=}, {index=}, {mode=}, {r_c_num=}")

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

    def rc_at_xy(self, xy: tuple[int, int]) -> tuple[int, int] | None:
        """Retrieve the row and column indices for the tile located at grid coordinates x, y."""
        x, y = xy
        cx, cy = self.canvasx(x), self.canvasy(y)
        for r, tile_row in enumerate(self.tiles):
            for c, tile in enumerate(tile_row):
                bbox = self.bbox(tile)
                if bbox:
                    if bbox[0] <= cx <= bbox[2] and bbox[1] <= cy <= bbox[3]:
                        return r, c
        return None

    def tile_at_xy(self, xy: tuple[int, int]) -> int | None:
        """Retrieve the tile tag at grid coordinates x, y."""
        rc = self.rc_at_xy(xy)
        if rc:
            return self.tiles[rc[0]][rc[1]]
        return None

    def quote_at_xy(self, xy: tuple[int, int]) -> Unit | None:
        """Retrieve the unit object at grid coordinates x, y."""
        rc = self.rc_at_xy(xy)
        if rc:
            r, c = rc
            return self.tile_properties[r][c]["unit_in"]
        return None

    def tile_to_rc(self, tag_in: int, extend=False) -> tuple[int, int] | None:
        """Reverse look-up on self.tiles using canvas tag ids. Use extend to also search the text tags."""
        for r, tile_row in enumerate(self.tiles):
            for c, tile in enumerate(tile_row):
                if tile == tag_in:
                    return r, c
                if extend:
                    details = self.tile_properties[r][c]
                    tags = [
                        tag_rect := details["tag_rect"],
                        tag_t1 := details["t1_tag"],
                        tag_t2 := details["t2_tag"],
                        tag_t3 := details["t3_tag"],
                        tag_t4 := details["t4_tag"],
                        tag_t5 := details["t5_tag"]
                    ]
                    if any(list(map(lambda t: t == tag_in, tags))):
                        return r, c
        return None

    def rc_bbox(self, rc):
        """Retrieve the bbox for the tile located at row r and column c."""
        return self.bbox(self.tiles[rc[0]][rc[1]])
        # print(f"{self.tiles=}")
        # x, y = self.winfo_pointerxy()
        # print(f"{self.canvasx(x)=}, {self.canvasy(y)}")
        # x, y = xy
        # print(f"{self.bbox('all')=}, {x=}, {y=}, {self.canvasx(x)=}, {self.canvasy(y)=}")
        # for tile_row in self.tiles:
        #     # for col_idx in range(self.visible_cols.start, self.visible_cols.stop + 1):
        #     #     tile = tile_row[col_idx]
        #     for tile in tile_row:
        #         bbox = self.bbox(tile)
        #         print(f"\t\t{tile=}, {x=}, {y=}, {bbox=}, {self.canvasx(x)=}, {self.canvasy(y)=}")
        #         if bbox[0] <= self.canvasx(x) <= bbox[2] and bbox[1] <= self.canvasy(y) <= bbox[3]:
        #             return tile
        # return None

    def populate_units(self, df: pandas.DataFrame) -> None:
        assert isinstance(df, pandas.DataFrame)
        for row in df.iterrows():
            # df["Available Date"] = pandas.to_datetime(df["Available Date"])
            values = row[1].tolist()
            # print(f"{len(values)=}, {values=}")
            new_unit = Unit(*values).init()
            # print(f"{unit_in=}, {list(unit_in)=}")
            sgquote = new_unit.SGQuote
            self.units[sgquote] = new_unit
            avail_date = new_unit.Available_Date
            finish_date_1 = new_unit.job_finish_date_v2
            finish_date_2 = new_unit.Finish_Date
            # print(f"LINES: {unit_in.job_start_date_v2=}, {unit_in.job_finish_date_v2=}, {unit_in.Available_Date=}, {unit_in.Delivery_Date=}, {unit_in.Finish_Date=}")
            print(f"\t\t{new_unit=}, {avail_date=}, {finish_date_1=}, {finish_date_2=}")
            print(f"{self.start_date=}, {self.end_date=}")
            date_idx = None
            if avail_date and (self.start_date <= avail_date <= self.end_date):
                print(f"\t\tVALID avail_date!!")
                date_idx = self.dates_list.index(avail_date) + 1
            elif finish_date_1 and finish_date_1 != "None" and (self.start_date <= finish_date_1 <= self.end_date):
                print(f"\t\tVALID finish_date_1!!")
                date_idx = self.dates_list.index(finish_date_1) + 1
            # elif finish_date_2 and finish_date_1 != "None" and (self.start_date <= finish_date_2 <= self.end_date):
            #     print(f"\t\tVALID finish_date_2!!")
            #     date_idx = self.dates_list.index(finish_date_2) + 1
            else:
                print(f"{avail_date=}, {finish_date_1=}, {finish_date_2=}  not found.")

            line_idx = None
            if new_unit.WO_Line_1:
                line_idx = self.lines.index(new_unit.WO_Line_1) + 1
            elif new_unit.WO_Line_2:
                line_idx = self.lines.index(new_unit.WO_Line_2) + 1
            # print(f"{unit_in}")

            print(f"{line_idx=}, {date_idx=}")
            if date_idx and line_idx:
                print(f"placing tile! at {new_unit=} {line_idx=}, {date_idx=}")
                self.set_rc_with_unit((line_idx, date_idx), new_unit)

    def set_rc_with_unit(self, rc: tuple[int, int], unit_in: Unit) -> None:
        self.set_tile_with_unit(self.tiles[rc[0]][rc[1]], unit_in)

    def set_tile_with_unit(self, tag_in: int | str, unit_in: Unit) -> None:
        assert isinstance(unit_in, Unit)
        rc = self.tile_to_rc(tag_in)
        if rc:
            r, c = rc
            # SGQuote# | Model No | Dealer Name | WO | Galv
            text_order = self.text_order
            details = [
                self.tile_properties[r][c]["text_1"],
                self.tile_properties[r][c]["text_2"],
                self.tile_properties[r][c]["text_3"],
                self.tile_properties[r][c]["text_4"],
                self.tile_properties[r][c]["text_5"]
            ]
            keys = unit_in.__dict__.keys()
            for i, text_tv in enumerate(zip(text_order, details)):
                text, tv = text_tv
                text = "_" + text
                value = text
                if text in keys:
                    value = getattr(unit_in, text, "N/A")
                print(f"\t\t{i=}, {text=} = {value=}, {tv.get()=}")
                tv.set(value)
                print(f"\t\t\t{tv.get()=}")

            unit_in.Available_Date = self.dates_list[c - 1]
            unit_in.JobStartLine = self.lines[r - 1]
            self.tile_properties[r][c]["unit_in"] = unit_in
            self.units[unit_in.SGQuote] = unit_in
            print(dict_print(self.units, "self.units"))
        else:
            raise ValueError(f"Error can't assign this tile with this unit_in. {tag_in=}, {unit_in=}")

    def export_tile_sql(self):
        fn = self.sql_output_file_name.format(ts=datetime.datetime.now().strftime("%Y-%m-%d %H%M"))
        template = "UPDATE [BWSdb].[dbo].[OrdersV2] SET [Available Date] = '{d}' WHERE [SGQuote] = '{q}'"
        template_2 = "UPDATE [BWSdb].[dbo].[OrdersV2] SET [Available Date] = '{d}' WHERE [SGQuote] = '{q}';\nUPDATE [Stargatedb].[dbo].[dtProductionScheduleV2] SET [JobFinishDate] = '{j}', [JobStartLine] = '{l}' WHERE [SGQuote] = '{q}'"
        result = ""
        result_2 = ""

        for unit_k, unit_o in self.units.items():
            if unit_k not in [None, "None", ""]:
                print(f"{unit_k=}, {unit_o=}")
                rc = self.quote_rc(unit_k)
                print(f"{rc=}")
                if rc:
                    # r, c = rc
                    # tag = self.tiles[r][c]
                    new_avail_date = unit_o.Available_Date
                    line = unit_o.JobStartLine
                    print(f"{new_avail_date=}")
                    result += f"\n-- {unit_k}\n" + template.format(d=new_avail_date, q=unit_k)
                    result_2 += f"\n-- {unit_k}\n" + template_2.format(d=new_avail_date, q=unit_k, j=new_avail_date, l=line)
                # else:
                #     result += f"\n-- {unit_k}\n"
                    # raise ValueError(f"{unit_k=} not found!")
        print(f"<{result}>")
        if result:
            with open(fn, "w") as f:
                # f.write(result)
                f.write(result_2)

        print(f"{self.tile_properties[0]=}")
        for r, prop in enumerate(self.tile_properties):
            for c, det in enumerate(prop):
                print(f"{r=}, {c=}, {det['unit_in']=}")
        return result

    def undo(self):
        oldest = None
        for unit_k, unint_o in self.units.items():
            if unit_k not in [None, "None", ""]:
                history = unint_o.history
                for k, v in history.items():
                    if len(v) > 1:
                        print(f"{unit_k}, {k=}, {v=}")
                        last_record = v[-1]
                        t, val = last_record
                        if oldest is None or t < oldest[0]:
                            oldest = t, val, unit_k, k
        if oldest:
            t, val, unit_k, k = oldest
            print(f"{t=}, {val=}, {unit_k=}, {k=}")
        else:
            print(f"Nothing to undo")
