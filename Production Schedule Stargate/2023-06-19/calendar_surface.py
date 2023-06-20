
import math
import dataclasses
import tkinter_utility

from screeninfo import get_monitors
from tkinter_utility import tkinter, is_tk_var

from dateutil.relativedelta import relativedelta
from colour_utility import *
from unit import Unit
from utility import dict_print
from datetime_utility import *
from stg_queries import *


def get_largest_monitor():
    return sorted(get_monitors(), key=lambda m: (-m.width_mm, m.width_mm * m.height_mm))[0]


class CalendarSurface(tkinter.Canvas):

    def __init__(
            self,
            master,
            PROGRAM_MODE: str,
            user_name: str,
            width: int,
            height: int,
            start_date: datetime.datetime,
            lines=None,
            dirty_status_var=None,

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

            # regular tile colour
            tile_background_colour: str = rgb_to_hex(GRAY_17),
            tile_outline_colour: str = rgb_to_hex(BLACK),
            active_fill_colour: str = rgb_to_hex(GRAY_66),
            active_outline_colour: str = rgb_to_hex(YELLOW_3),

            # weekend tile colour
            tile_wkd_background_colour: str = rgb_to_hex(GRAY_8),
            tile_wkd_outline_colour: str = rgb_to_hex(GRAY_8),
            active_wkd_fill_colour: str = rgb_to_hex(GRAY_8),
            active_wkd_outline_colour: str = rgb_to_hex(GRAY_8),

            # other colours
            selected_colour: str = rgb_to_hex(FIREBRICK_1),
            drag_colour: str = rgb_to_hex(FIREBRICK_4),

            n_visible_cols: int = 14,
            sql_output_file_name: str = "./STGProdSched/Queries/{ts}_sql_output.sql",
            text_order: list[str] = ["SGQuote", "InputField1_v2", "InputField2_v2", "WO", "Customer_WO", "IsGalv"],

            calendar_text_size: int = 8,

            weekend_proportion: float = 0.5,
            illegal_saturday: bool = True,
            illegal_sunday: bool = True,
            holidays: list[datetime.datetime] = dataclasses.field(default_factory=list)
    ):
        super().__init__(master, width=width, height=height)

        self.PROGRAM_MODE = PROGRAM_MODE

        self.status = tkinter.Variable(self, value={})
        self.dirty_status_var = dirty_status_var if dirty_status_var is not None else tkinter.BooleanVar(self, value=False)

        self.canvas_width = width
        self.canvas_height = height
        self.user_name = user_name
        # self.lines = [f"T{i}" for i in range(1, 7)]
        # self.lines = ["TL", "LBL", "WFL", "TBL", "PL"]
        self.lines = lines
        self.start_date = start_date
        self.end_date = self.start_date + relativedelta(months=24)
        self.dates_list = [self.start_date + datetime.timedelta(days=i) for i in range((self.end_date - self.start_date).days)] + [self.end_date]
        self.date_status = [d.weekday() for d in self.dates_list]
        self.rows = len(self.lines)
        self.cols = (self.end_date - self.start_date).days
        self.max_tiles = self.rows * self.cols
        self.text_order = text_order
        self.illegal_saturday = tkinter.BooleanVar(self, value=illegal_saturday)
        self.illegal_sunday = tkinter.BooleanVar(self, value=illegal_sunday)

        self.weekend_proportion = weekend_proportion
        self.holidays = holidays

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
        self.selected_colour = selected_colour
        self.drag_colour = drag_colour

        self.calendar_text_size = calendar_text_size
        self.tile_space = 3
        self.tile_width = None
        self.tile_height = None
        # self.texts = []
        self.tile_properties = []  # list of dictionaries containing the rest of the required tile data (text id and tvs)
        self.tiles = self.init_tiles()  # list of canvas tags for the cells len = n_rows * n_cols
        self.raise_legend()
        self.units = {None: None, "": None}  # dictionary of Stargate quote numbers.
        self.tiles_beyond = {line: {"left": [], "right": []} for line in self.lines}
        # self.undo_actions = 0

        self.sql_output_file_name = sql_output_file_name
        self.history = []
        self.redo_history = []

        self.dealer_colour_scheme = {}

        print(f"\n\tStart Date:\t\t\t\t\t\t- {self.start_date}\n\tEnd Date\t\t\t\t\t\t- {self.end_date=}")

    def quote_rc(self, quote_in) -> tuple | None:
        """Retrieve the row and column for the specified quote number."""
        if quote_in in self.units:
            for r, tile_row in enumerate(self.tiles):
                for c, tile in enumerate(tile_row):
                    unit = self.tile_properties[r][c]["unit_in"]
                    if unit:
                        # print(f"\t\t checking {unit=}")
                        if unit.SGQuote == quote_in:
                            return r, c
        # print(f"Param 'quote_in' = <{quote_in}> not found in tiles.")
        return None

    def raise_legend(self):
        for r in range(self.rows + 1):
            tp = self.tile_properties[r][0]
            self.tag_raise(tp["tag_rect"])
            for i in range(1, 7):
                self.tag_raise(tp[f"t{i}_tag"])
            # for c in range(self.cols + 1):
            #     if c == 0

    def toggle_saturday(self):
        illegal_sat = self.illegal_saturday.get()
        tw_we = self.tile_width_weekend
        th_we = self.tile_height_weekend
        tw = self.tile_width
        th = self.tile_height
        ntw = tw if illegal_sat else tw_we
        n_weekends = sum([d.weekday() == 5 for d in self.dates_list])
        gd = (tw - tw_we) if illegal_sat else (tw_we - tw)
        t_props = self.tile_properties

        for j in range(len(self.dates_list) - 1, -1, -1):
            d = self.dates_list[j - 1]
            isat = d.weekday() == 5
            c_off = 0
            for i in range(len(self.lines) + 1):
                r = i
                # c = len(t_props[r]) - (j + 1)
                c = j
                props = t_props[r][c]
                r_id = props["tag_rect"]
                x1, y1, x2, y2 = props["x1"], props["y1"], props["x2"], props["y2"]
                w = x2 - x1
                x1 += ((n_weekends - c_off) * gd)
                # x2 += (c * gd)
                # if w != ntw:
                x2 = x1 + (ntw if isat else tw)
                self.coords(r_id, x1, y1, x2, y2)
                if r < 5 and c < 5:
                    print(f"{r=}, {c=}, {((n_weekends - c_off) * gd)=}")
                    print(f"{props}")
            if isat:
                c_off += 1

        self.illegal_saturday.set(not illegal_sat)

        # illegal_sun = self.illegal_sunday.get()
        # self.illegal_sunday.set(not illegal_sun)

    #
    # def toggle_saturday(self):
    #     illegal_sat = self.illegal_saturday.get()
    #     tw_we = self.tile_width_weekend
    #     th_we = self.tile_height_weekend
    #     tw = self.tile_width
    #     th = self.tile_height
    #     ntw = tw if not illegal_sat else tw_we
    #     n_weekends = sum([d.weekday() > 4 for d in self.dates_list])
    #     # gd = (tw - tw_we) if illegal_sat else (tw_we - tw)
    #     t_props = self.tile_properties
    #     for j, d in enumerate(self.dates_list):
    #         c_off = 0
    #         for i, line in enumerate(self.lines):
    #             we = d.weekday() > 4
    #             r = i + 1
    #             c = len(t_props[r]) - (j + 1)
    #             props = t_props[r][c]
    #             r_id = props["tag_rect"]
    #             x1, y1, x2, y2 = props["x1"], props["y1"], props["x2"], props["y2"]
    #             w = x2 - x1
    #             x1 += (c * gd)
    #             x2 += (c * gd)
    #             if w != ntw:
    #                 x2 = x1 + ntw
    #             self.coords(r_id, x1, y1, x2, y2)
    #             if j < 5:
    #                 print(f"{props}")
    #
    #     self.illegal_saturday.set(not illegal_sat)
    #
    #     # illegal_sun = self.illegal_sunday.get()
    #     # self.illegal_sunday.set(not illegal_sun)

    def init_tiles(self) -> list:
        ts = self.tile_space  # space between tiles
        tw = (self.canvas_width - ((self.n_visible_cols + 1) * ts)) / (self.n_visible_cols + 1)  # tile width
        th = (self.canvas_height - ((self.rows + 1) * ts)) / (self.rows + 1)  # tile height
        tw_we = tw * self.weekend_proportion  # tile width weekend
        th_we = (self.canvas_height - ((self.rows + 1) * ts)) / (self.rows + 1)  # tile height weekend
        self.tile_width = tw
        self.tile_height = th
        self.tile_width_weekend = tw_we
        self.tile_height_weekend = th_we
        t_weekend_days = 0

        # print(f"t_width={tw}, t_height={th}, t_width_wk={tw_we}, t_height_w={th_we}")
        # print(f"{self.rows=}, {self.cols=}")

        tiles = []
        n_slices = (self.rows + 1) * (self.cols + 1)
        # print(f"{n_slices=}")
        grad = rainbow_gradient(n_slices, rgb=False)
        count = 0
        # TODO recalculate these positions so that the left most column is unaffected by the 'timeline' shifting
        #  Currently this tile is treated the same as all of the others
        for r in range(self.rows + 1):
            row = []
            row_2 = []
            tile_detail_row = []
            weekend_days = 0
            for c in range(self.cols + 1):

                x1 = (c * tw) + ((c + 1) * ts) + (ts / 2)
                y1 = (r * th) + ((r + 1) * ts) + (ts / 2)
                x2 = ((c + 1) * tw) + ((c + 1) * ts) + (ts / 2)
                y2 = ((r + 1) * th) + ((r + 1) * ts) + (ts / 2)

                # print(f"\tA {r=}, {c=}, {x1=}, {x2=}, {x2=}, {y2=}, {weekend_days=}, {tw - tw_we=}, {th - th_we=}")

                x1 -= (weekend_days * (tw - tw_we))
                x2 -= (weekend_days * (tw - tw_we))
                y1 -= (weekend_days * (th - th_we))
                y2 -= (weekend_days * (th - th_we))

                # print(f"\tB {r=}, {c=}, {x1=}, {x2=}, {x2=}, {y2=}, {weekend_days=}, {tw - tw_we=}, {th - th_we=}")

                if c > 0:
                    today = self.dates_list[c - 1]
                    if self.date_status[c - 1] > 4:
                        # print(f"\t{today=}, {self.date_status[c - 1]=}")
                        weekend_days += 1
                        x2 -= (tw - tw_we)
                        y2 -= (th - th_we)

                xd = x2 - x1
                yd = y2 - y1

                # print(f"\tC {r=}, {c=}, {x1=}, {x2=}, {x2=}, {y2=}, {weekend_days=}, {tw - tw_we=}, {th - th_we=}")

                tile_colour, outline_colour, active_fill_colour, active_outline_colour, font_colour = self.calc_colours(r, c)

                if self.PROGRAM_MODE == "TEST":
                    count += 1
                    # print(f"grabbing the {count=}, {n_slices=}")
                    try:
                        tile_colour = next(grad)
                        font_colour = font_foreground(tile_colour, rgb=False)
                    except StopIteration:
                        pass

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
                text_6 = tkinter.StringVar(self, name=self.sv_keyify(r, c, 6), value=f"")

                if self.PROGRAM_MODE == "LIVE":
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
                        if (self.day_of_week(c - 1) <= 4 or c == 0):
                            # text_1.set(f"{self.start_date + datetime.timedelta(days=c):%Y-%m-%d}")
                            # legend
                            today = self.dates_list[c - 1]
                            text_1.set(f"{today:%Y}")
                            text_2.set(f"{today:%B}")
                            text_3.set(f"{today:%d}")
                            text_4.set("{}{}".format(int(text_3.get()), date_suffix(int(text_3.get()))))
                            text_3.set("")
                            text_5.set(f"{today:%A}")
                            text_6.set(f"{today:%A}")
                        else:
                            text_1.set("")
                            text_2.set("")
                            text_3.set("")
                            text_4.set("")
                            text_5.set("")
                            text_6.set("")
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
                    text_6.set("")

                offset = (1 * yd / 10)
                t1_x1, t1_y1 = x1 + (xd / 2), y1 + offset
                t2_x1, t2_y1 = x1 + (xd / 2), y1 + (1 * yd / 6) + offset
                t3_x1, t3_y1 = x1 + (xd / 2), y1 + (2 * yd / 6) + offset
                t4_x1, t4_y1 = x1 + (xd / 2), y1 + (3 * yd / 6) + offset
                t5_x1, t5_y1 = x1 + (xd / 2), y1 + (4 * yd / 6) + offset
                t6_x1, t6_y1 = x1 + (xd / 2), y1 + (4 * yd / 6) + offset

                text_1.trace_variable("w", self.update_canvas_text)
                text_2.trace_variable("w", self.update_canvas_text)
                text_3.trace_variable("w", self.update_canvas_text)
                text_4.trace_variable("w", self.update_canvas_text)
                text_5.trace_variable("w", self.update_canvas_text)
                text_6.trace_variable("w", self.update_canvas_text)

                def_font = tkinter.font.nametofont("TkTextFont")
                def_font.config(size=self.calendar_text_size)
                for i in range(1, 7):
                    wip_x = eval(f"t{i}_x1")
                    wip_y = eval(f"t{i}_y1")
                    wip_t = eval(f"text_{i}")
                    text = wip_t.get()
                    text_width = def_font.measure(text)
                    width = tw if (self.day_of_week(c - 1) <= 4 or (c == 0 and r > 0)) else tw_we
                    while text and (text_width > width):
                        text = text[:-1]
                        text_width = def_font.measure(text)
                    row_2.append(
                        self.create_text(
                            wip_x,
                            wip_y,
                            text=text,
                            fill=font_colour,
                            # font=("Times", 9),
                            font=def_font,
                            width=width,
                            activefill=active_fill_colour
                        )
                    )

                tile_details = {
                    "tag_rect": row[-1],
                    "x1": x1,
                    "y1": y1,
                    "x2": x2,
                    "y2": y2,

                    "t1_tag": row_2[-6],
                    "t1_x1": t1_x1,
                    "t1_y1": t1_y1,
                    "text_1": text_1,

                    "t2_tag": row_2[-5],
                    "t2_x1": t2_x1,
                    "t2_y1": t2_y1,
                    "text_2": text_2,

                    "t3_tag": row_2[-4],
                    "t3_x1": t3_x1,
                    "t3_y1": t3_y1,
                    "text_3": text_3,

                    "t4_tag": row_2[-3],
                    "t4_x1": t4_x1,
                    "t4_y1": t4_y1,
                    "text_4": text_4,

                    "t5_tag": row_2[-2],
                    "t5_x1": t5_x1,
                    "t5_y1": t5_y1,
                    "text_5": text_5,

                    "t6_tag": row_2[-1],
                    "t6_x1": t6_x1,
                    "t6_y1": t6_y1,
                    "text_6": text_6,

                    "unit_in": None
                }

                tile_detail_row.append(tile_details)
            tiles.append(row)
            # self.texts.append(row_2)
            self.tile_properties.append(tile_detail_row)

        return tiles

    def calc_colours(self, r, c):
        # TODO colourify todays date
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

        #TODO here
        # print(f"-A")
        if r < len(self.tile_properties) and c < len(self.tile_properties[r]):
            # print(f"-B")
            unit = self.tile_properties[r][c]["unit_in"]
            if unit:
                dealer = unit.InputField2_v2.upper()
                # print(f"-C, {dealer=}")
                if dealer in self.dealer_colour_scheme:
                    # print(f"-D, {self.dealer_colour_scheme[dealer]}")

                    colour = Colour(self.dealer_colour_scheme[dealer])
                    b = brighten(colour.rgb_code, 0.25, rgb=False)
                    hc = colour.hex_code
                    fc = font_foreground(colour.rgb_code, rgb=False)
                    af = brighten(fc, 0.25, rgb=False)

                    # self.itemconfigure(
                    #     tile,
                    #     fill=hc,
                    #     activefill=b,
                    #     outline=hc,
                    #     activeoutline=b
                    # )

                    tile_colour,\
                        outline_colour,\
                        active_fill_colour,\
                        active_outline_colour,\
                        font_colour =\
                        hc, hc, b, b, fc

        font_colour = rgb_to_hex(font_foreground(tile_colour))
        return tile_colour, outline_colour, active_fill_colour, active_outline_colour, font_colour

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

            font = tkinter.font.nametofont(self.itemcget(tag, "font"))
            font.configure(size=self.calendar_text_size)
            text_width = font.measure(value)
            width = int(self.itemcget(tag, "width"))
            # print(f"{font=}, {width=}, {text_width=}")
            while value and (text_width > width):
                value = value[:-1]
                text_width = font.measure(value)

            self.itemconfigure(tag, text=value)
            # print(f"retrieving: {value=}")
            # print(f"A{var_name=}, {index=}, {mode=}, {value=}, {tag=}")
        # self.itemconfigure()
        # else:
        #     print(f"B{var_name=}, {index=}, {mode=}, {r_c_num=}")

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
                        tag_t5 := details["t5_tag"],
                        tag_t6 := details["t6_tag"]
                    ]
                    if any(list(map(lambda t: t == tag_in, tags))):
                        return r, c
        return None

    def rc_bbox(self, rc):
        """Retrieve the bbox for the tile located at row r and column c."""
        return self.bbox(self.tiles[rc[0]][rc[1]])

    def populate_units(self, df: pandas.DataFrame) -> None:
        assert isinstance(df, pandas.DataFrame)
        for row in df.iterrows():
            # df["Available Date"] = pandas.to_datetime(df["Available Date"])
            i, values = row
            values = values.tolist()

            # zip_list = [
            #     "_prod_sched_v2_id",
            #     "_quote_v2",
            #     "_wo_num_v2",
            #     "_job_start_date_v2",
            #     "_job_finish_date_v2",
            #     "_dtprodschedv2ts",
            #     "_job_start_line_v2",
            #     "_hide_from_prod_input_v2",
            #     "_InputField1_v2",
            #     "_InputField2_v2",
            #     "_ApplyUpdate_v2",
            #     "_ApplyUpdateUser_v2",
            #     "_prod_sched_id",
            #     "_quote",
            #     "_wo_num",
            #     "_InputField1",
            #     "_InputField2",
            #     "_Beam_Line",
            #     "_Beam_Date",
            #     "_GN_Line",
            #     "_GN_Date",
            #     "_WO_Line_1",
            #     "_Prod_Date_1",
            #     "_WO_Line_2",
            #     "_Prod_Date_2",
            #     "_Other",
            #     "_Other_Line",
            #     "_Other_Date",
            #     "_HideFromProdInput",
            #     "_Step1SYSPROBudget",
            #     "_Step2SYSPROBudget",
            #     "_dtprodschedts",
            #     "_ApplyUpdate",
            #     "_ApplyUpdateUser",
            #     "_Slot",
            #     "_Slot_Quote",
            #     "_Slot_Approved",
            #     "_Prod_On",
            #     "_Prod_On_Time",
            #     "_Prod_Off",
            #     "_Prod_Off_Time",
            #     "_Prod_PM",
            #     "_Prod_Complete",
            #     "_Prod2_On",
            #     "_Prod2_On_Time",
            #     "_Prod2_Off",
            #     "_Prod2_Off_Time",
            #     "_Prod2_PM",
            #     "_Prod2_Complete",
            #     "_Prod_Instructions",
            #     "_Beam_On",
            #     "_Beam_Off",
            #     "_Beam_Complete",
            #     "_Beam_PM",
            #     "_Beam_Instructions",
            #     "_GN_On",
            #     "_GN_Off",
            #     "_GN_Complete",
            #     "_GN_PM",
            #     "_GN_Instructions",
            #     "_Axle",
            #     "_Axle_On",
            #     "_Axle_Off",
            #     "_Axle_Complete",
            #     "_Axle_PM",
            #     "_Axle_Instructions",
            #     "_Other_On",
            #     "_Other_On_Time",
            #     "_Other_Off",
            #     "_Other_Off_Time",
            #     "_Other_Complete",
            #     "_Other_PM",
            #     "_Other_Instructions",
            #     "_Stargate_WO",
            #     "_OrderID",
            #     "_SGQuote",
            #     "_Quote_Date: datetime.dat",
            #     "_Order_Date: datetime.dat",
            #     "_WO",
            #     "_Sales_Order",
            #     "_Model_No",
            #     "_Width",
            #     "_Spread",
            #     "_DealerID",
            #     "_Sale_PersonID",
            #     "_Price",
            #     "_Prom_Drawing",
            #     "_Special_Instructions",
            #     "_Date_Declined",
            #     "_Decline_Rejected",
            #     "_Serial_Number",
            #     "_Available_Date",
            #     "_Delivery_Date",
            #     "_Requested_Delivery_Date",
            #     "_Finish_Date",
            #     "_Purchase_Order",
            #     "_PO_Date",
            #     "_PayID",
            #     "_Volume_Discount",
            #     "_Program_Discount",
            #     "_Discount1_Name",
            #     "_Discount1_Type",
            #     "_Discount1",
            #     "_Discount2_Name",
            #     "_Discount2_Type",
            #     "_Discount2",
            #     "_Discount3_Name",
            #     "_Discount3_Type",
            #     "_Discount3",
            #     "_Est_Pro_Date",
            #     "_Notes",
            #     "_EngNotes",
            #     "_CarrierID",
            #     "_CustID",
            #     "_US_Sale",
            #     "_Shipped_Date",
            #     "_GL_Override_Date",
            #     "_FE_Rate",
            #     "_PDD",
            #     "_Deck_Length",
            #     "_Invoice",
            #     "_Date_Registered",
            #     "_Date_In_Service",
            #     "_Invoice_Date",
            #     "_Date_Requested",
            #     "_GVWR",
            #     "_Tare",
            #     "_Selection",
            #     "_Warranty",
            #     "_BWSPaid",
            #     "_BWSPaidDate",
            #     "_CommPaid",
            #     "_CommPaidDate",
            #     "_ts_timestamp",
            #     "_ModifiedBy",
            #     "_Lead_Date",
            #     "_Lead_Source",
            #     "_LeadID",
            #     "_DealerBranchID",
            #     "_DealerSalesPersonID",
            #     "_DataEntryCheck",
            #     "_DataEntryUser",
            #     "_FinishedGoodsDealerLocID",
            #     "_WO_Reviewed",
            #     "_WO_Review_Date",
            #     "_Follow_Up_Date",
            #     "_MSOIsDifferent",
            #     "_MSOLocID",
            #     "_EstInvDateOverride",
            #     "_Estimated_Invoice_Date",
            #     "_AdditionalPricingInfo",
            #     "_Slot_Orders",
            #     "_TempModel",
            #     "_HighRiskUnit",
            #     "_EngNotes_V2",
            #     "_CompanyID",
            #     "_Customer_WO",
            #     "_PriceSecured",
            #     "_DateSecured",
            #     "_SecuredBy",
            #     "_IsGalv",
            #     "_placed",
            #     "_init_placed",
            #     "_gener",
            #     "_history"
            # ]
            # # print(f"{values[zip_list.index('_placed')]=}")
            #
            # # if i == df.shape[0] - 1:
            # for j, v in enumerate(values):
            #     print(f"{j=}, {zip_list[j]=}, {v=}")

            # print(f"VALUES={values}")
            # print(f"B {list(df.columns)=}")
            # print(f"B {len(list(df.columns))=}")
            # print(f"{len(values)=}")

            new_unit = Unit(*values).init()
            # print(f"{new_unit=}, {list(new_unit)=}, {new_unit.__dict__}")
            # print(f"{new_unit=}, {list(new_unit)=}")
            sgquote = new_unit.SGQuote
            # print(f"{len(values)=}, {values[5:8]=}, {values=}")
            # if sgquote in ["SG100621", "SG100535"]:
            self.units[sgquote] = new_unit
            avail_date = new_unit.Available_Date
            finish_date_1 = new_unit.job_finish_date_v2
            finish_date_2 = new_unit.Finish_Date
            # print(f"LINES: {unit_in.job_start_date_v2=}, {unit_in.job_finish_date_v2=}, {unit_in.Available_Date=}, {unit_in.Delivery_Date=}, {unit_in.Finish_Date=}")
            # print(f"\t\t{new_unit=}, {avail_date=}, {finish_date_1=}, {finish_date_2=}")
            # print(f"{self.start_date=}, {self.end_date=}")
            date_idx = None
            new_date = None
            avail_is_nan = ((isinstance(avail_date, int) or isinstance(avail_date, float)) and math.isnan(avail_date))
            if not avail_is_nan:
                avail_date = datetime.datetime.strptime(avail_date, "%Y-%m-%d")
                new_unit.Available_Date = avail_date
            # print(f"\nNEW_UNIT={new_unit}\n{avail_date=}, {type(avail_date)=}, {avail_is_nan=}, {self.start_date=}, {self.end_date=}")
            if (not avail_is_nan) and avail_date:  # and (self.start_date <= avail_date <= self.end_date):
                # print(f"\t\tVALID avail_date!!")
                new_date = avail_date
            elif finish_date_1 and finish_date_1 != "None" and (self.start_date <= finish_date_1 <= self.end_date):
                # print(f"\t\tVALID finish_date_1!!")
                new_date = finish_date_1

            if new_date is not None and (self.start_date <= new_date <= self.end_date):
                date_idx = self.dates_list.index(new_date) + 1
            else:
                date_idx = None
                # elif finish_date_2 and finish_date_1 != "None" and (self.start_date <= finish_date_2 <= self.end_date):
                #     print(f"\t\tVALID finish_date_2!!")
                #     date_idx = self.dates_list.index(finish_date_2) + 1
            # else:
            #     print(f"{sgquote=}, {avail_date=}, {finish_date_1=}, {finish_date_2=}  not found.")

            line_idx = None
            new_line = None
            if new_unit.WO_Line_1:
                new_line = new_unit.WO_Line_1
            elif new_unit.WO_Line_2:
                new_line = new_unit.WO_Line_2
            elif new_unit.job_start_line_v2:
                new_line = new_unit.job_start_line_v2

            if new_line is not None:
                print(f"\n{new_unit=}\n\t{new_line=}\n{self.lines=}")
                new_unit.job_start_line_v2 = new_line
                line_idx = self.lines.index(new_line) + 1
            # print(f"{unit_in}")

            # print(f"{line_idx=}, {date_idx=}, {new_line=}, {new_date=}, {new_unit=}")
            if date_idx and line_idx:
                # new_unit.placed = True
                print(f"placing tile! at {new_unit=} {line_idx=}, {date_idx=}, {new_unit.history['_placed']=}")
                new_unit.init_placed = True
                self.set_rc_with_unit((line_idx, date_idx), new_unit)
                new_unit.history["_Available_Date"] = [(datetime.datetime.now(), new_unit.gener_id(), new_date)]
                new_unit.history["_job_start_line_v2"] = [(datetime.datetime.now(), new_unit.gener_id(), new_line)]
            elif new_date and new_line:
                print(f"\nCC\t{date_idx=}, {line_idx=}, {new_date=}, {new_line=}\n\t\t{new_unit}\n")
                # TODO add these to the beyond on load.
                sd = self.start_date
                ed = self.end_date
                if new_date < sd:
                    # left
                    dd = (sd - new_date).days + 1
                    lst = self.tiles_beyond[new_line]["left"]
                    for i in range(dd - len(lst) + 1):
                        lst.append(None)
                    iidx = len(lst) - dd
                    print(f"B {dd=}, {len(lst)=}, {dd - len(lst)=}, {iidx=}, {new_date=}, {sd=}")
                    lst.insert(iidx, new_unit)
                    print(f"{lst=}")
                elif new_date > ed:
                    # right
                    dd = (new_date - ed).days
                else:
                    raise ValueError(f"error, date {new_date=} not between {sd=}, {ed=}")

    def set_rc_with_unit(self, rc: tuple[int, int], unit_in: Unit, set_style: bool = False, default_answer: int = None) -> None:
        # print(f"SETTING {rc=} with {unit_in=}, {set_style=}")
        if set_style:
            r, c = rc
            tile = self.tiles[r][c]
            self.set_tile_with_unit_from_tile(tile, tile, unit_in, do_assign=True, default_answer=default_answer)
            self.revert_colour(rc)
        else:
            self.set_tile_with_unit(self.tiles[rc[0]][rc[1]], unit_in, default_answer=default_answer)

    def set_tile_with_unit_from_tile(self, from_tag: int | str, to_tag: int | str, unit_in: Unit, do_assign: bool = False, do_place: bool = True, default_answer: int = None) -> None:
        """Perform the same actions as self.set_tile_with_unit, but in addition it also maintains styling on tiles."""
        # print(f"set_tile_with_unit_from_tile(self, from_tag: int | str, to_tag: int | str, unit_in: Unit, do_assign: bool = False) -> None:")
        self.set_tile_with_unit(to_tag, unit_in, do_assign=do_assign, do_place=do_place, default_answer=default_answer)
        # old_r, old_c = self.tile_to_rc(from_tag)
        # new_r, new_c = self.tile_to_rc(to_tag)
        # old_details = self.tile_properties[old_r][old_c]
        # new_details = self.tile_properties[new_r][new_c]
        ot1, ot2, ot3, ot4, ot5, ot6 = self.get_text_tags(from_tag)
        nt1, nt2, nt3, nt4, nt5, nt6 = self.get_text_tags(to_tag)
        t_order = self.text_order
        for i in range(1, 7):
            for attribute in ['fill', "activefill"]:
                val = self.itemcget(ot1, attribute)
                print(f"\t\tSETTING {eval(f'nt{i}')=}'s {attribute=} = {val=}")
                self.itemconfigure(eval(f"nt{i}"), {attribute: val})

        print(f"{self.get_text_vars(from_tag)=}")
        for sv, text in zip(self.get_text_vars(to_tag), t_order):
            print(f"\t{sv=}, {text=}")
            sv.set(getattr(unit_in, text, "NONE"))
            print(f"\t\t{sv.get()=}")

    def get_text_tags(self, tile_in):
        r, c = self.tile_to_rc(tile_in)
        return (
            self.tile_properties[r][c]["t1_tag"],
            self.tile_properties[r][c]["t2_tag"],
            self.tile_properties[r][c]["t3_tag"],
            self.tile_properties[r][c]["t4_tag"],
            self.tile_properties[r][c]["t5_tag"],
            self.tile_properties[r][c]["t6_tag"]
        )

    def get_text_vars(self, tile_in):
        r, c = self.tile_to_rc(tile_in)
        return (
            self.tile_properties[r][c]["text_1"],
            self.tile_properties[r][c]["text_2"],
            self.tile_properties[r][c]["text_3"],
            self.tile_properties[r][c]["text_4"],
            self.tile_properties[r][c]["text_5"],
            self.tile_properties[r][c]["text_6"]
        )

    def day_of_week(self, column_in):
        """Return the calculated date status at column 'c'. 0-4 -> Mon-Fri, 5, 6 -> Sat, Sun"""
        return self.date_status[column_in]

    def next_available_day(self, row_in):
        print(f"{row_in=}")
        print(f"{self.quote_rc('SG100025')=}")
        print(f"{self.quote_rc('SG100291')=}")
        print(f"{len(self.tile_properties[row_in])=}")
        for c, col_data in enumerate(self.tile_properties[row_in]):
            print(f"{c=}. {row_in=}, {col_data['unit_in']=}")
            if c > 0:
                if col_data.get("unit_in", None) is None:
                    return c + 1

    def unbind_pre_pop_up(self):
        self.status.set({"msg": "Need to disable application while dealing with illegal placement pop-up.", "code": 2})

    def bind_post_pop_up(self):
        self.status.set({"msg": "Need to re-enable CalendarSurface action events after dealing with illegal placement pop-up.", "code": 1})

    def set_tile_with_unit(self, tag_in: int | str, unit_in: Unit, do_assign: bool = True, do_place=True, default_answer: int = None) -> None:
        """Associate a unit object with a given tile space. Unit data only, no UI changes."""
        # default_answer = 1 == back, 3 == forward, else == Nothing
        assert isinstance(unit_in, Unit), "Error param 'unit_in' must be an instance of a Unit."
        rc = self.tile_to_rc(tag_in)
        if rc:
            r, c = rc
            line_in = self.lines[r - 1]

            already_unit = self.tile_properties[r][c]["unit_in"]
            if already_unit is not None:
                print(f"\n\n\tABOUT TO OVERWRITE TILE {already_unit=} WITH {unit_in=}, {r=}, {c=}\n\tNEED TO WALK THE LINE TO DETERMINE IF A UNIT NEEDS TO BE SENT BEYOND.\n\n\n")

                next_col = self.next_available_day(r)
                print(f"NEXT AVAILABLE COLUMN={next_col} ON {self.dates_list[next_col]}, ON LINE {self.lines[r - 1]}")

            wd = self.day_of_week(c - 1)
            if wd > 4:
                # TODO change this to allow weekends sometimes
                date = self.dates_list[c - 1]
                pn = [-1, -1]
                tc = c - 1
                while (tc > 0) and (self.day_of_week(tc - 1) > 4):
                    tc -= 1
                if tc < 0:
                    raise ValueError(f"Error, cannot place tile at column c prev. Out of range: {tc}")
                prev_day = self.dates_list[tc - 1]
                if tc == 0:
                    # need to add to beyond left
                    print("\tAdding to beyond left")
                    line_in = unit_in.JobStartLine
                    self.tiles_beyond[line_in]["left"].insert(-1, unit_in)
                pn[0] = tc - 0
                tc = c + 1
                while (tc < len(self.dates_list)) and (self.day_of_week(tc - 1) > 4):
                    tc += 1
                if tc < 0:
                    raise ValueError(f"Error, cannot place tile at column c next. Out of range: {tc}")
                if tc == len(self.dates_list):
                    # need to add to beyond right
                    print("\tAdding to beyond right")
                    line_in = unit_in.JobStartLine
                    self.tiles_beyond[line_in]["right"].insert(0, unit_in)
                next_day = self.dates_list[tc - 1]
                pn[1] = tc + 0
                prev_day_msg = f"<< {prev_day:'%Y-%m-%d'} <<"
                next_day_msg = f">> {next_day:'%Y-%m-%d'} >>"

                # x, y = self.rc_bbox((r, c))[:2]
                x, y = self.winfo_reqwidth(), self.winfo_reqheight()
                x //= 2
                y //= 2
                # self.unbind_pre_pop_up()

                def close_cmb(ans, unit_in, r, c):
                    print(f"close_cmb {ans=}, {unit_in=}, {r=}, {c=}")
                    if is_tk_var(ans):
                        ans = ans.get()
                    if ans == "closed":
                        ans = 0
                    else:
                        ans = int(ans)
                    # self.bind_post_pop_up()
                    print(f"{ans=}")
                    print(f"A {c=}, {pn=}")
                    if ans == 1:
                        # prev_day_msg
                        self.remove_tile(r, c)
                        self.delete_tile(r, c)
                        c = pn[0]
                        print(f"B {c=}")
                    elif ans == 3:
                        # next_day_msg
                        self.remove_tile(r, c)
                        self.delete_tile(r, c)
                        c = pn[1]
                        print(f"C {c=}")
                    else:
                        # 2
                        c = c
                        print(f"D {c=}")

                    if 0 < c < len(self.dates_list):
                        self.set_rc_with_unit((r, c), unit_in)
                    # modify the history created from the placement action.
                    if self.history:
                        last = self.history[-1]
                        if isinstance(last, CalendarSurface.MovementUndoable):
                            # r_from = last.r_from
                            # c_from = last.c_from
                            # r_to = last.r_to
                            # c_to = last.c_to
                            # print(f"Modifying the history: {last.c_to=}, {c=}")
                            last.c_to = c
                            # self.status.set({"msg": "Need to swap the to col.", "c": c})
                    else:
                        print(f"NO HISTORY TO UNDO")

                if default_answer is None:
                    tv_ans = tkinter.StringVar(self, value="")
                    ans = tkinter_utility.CustomMessageBox(
                        title="Illegal Placement",
                        msg=f"Error placing Quote {unit_in.SGQuote} on line '{line_in}'.\nCurrent application mode does not allow units to placed on a weekend.\nPlease Choose a valid action:",
                        x=x,
                        y=y,
                        b1=prev_day_msg,
                        b2="cancel",
                        b3=next_day_msg,
                        answer_handle=tv_ans
                        # answer_handle=lambda u=unit_in, r=r, c=c: close_cmb(a, u, r, c)
                    )
                    ans.grab_set()
                    print(f"{tv_ans.get()=}")
                    tv_ans.trace_variable("w", lambda xx, yy, zz, a=tv_ans, u=unit_in, r=r, c=c: close_cmb(a, u, r, c))
                    # tt1 = ans.protocol('WM_DELETE_WINDOW', 'return')
                    # print(f"previous handler: {tt1}>")
                    # ans.protocol("WM_DELETE_WINDOW", lambda a=ans.choice, u=unit_in, r=r, c=c: close_cmb(a, u, r, c))
                    # tt1 = ans.protocol('WM_DELETE_WINDOW', 'return')
                    # print(f"new handler: {tt1}>")
                    # print(f"{ans.choice=}")
                    # ans = ans.choice
                else:
                    ans = default_answer
                    close_cmb(ans, unit_in, r, c)
                # self.configure(state="disabled")

                return


            # print(f"date: {self.dates_list[c - 1]=}, {c - 1=}")
            # SGQuote# | Model No | Dealer Name | WO | Galv
            text_order = self.text_order
            details = self.get_text_vars(tag_in)
            keys = unit_in.__dict__.keys()
            print(f"AA {text_order=}")
            print(f"AA {details=}")
            print(f"AA {keys=}")
            for i, text_tv in enumerate(zip(text_order, details)):
                text, tv = text_tv
                text = "_" + text
                value = text
                if text in keys:
                    print(f"\t\t\tBEFORE {value=}")
                    value = getattr(unit_in, text, "N/A")
                    print(f"\t\t\tAFTER {value=}")
                    # TODO last point for UI formatting
                    if text == "_IsGalv":
                        value = value if value != 'N' else ''
                    elif text == "_WO" or text == "_Customer_WO":
                        if value is not None and value != "":
                            if not math.isnan(value):
                                value = int(value)
                    # print(f"\t\t\tAFTER {value=}")
                # print(f"\t\tLOOK HERE 2 {i=}, {text=} = {value=}, {tv.get()=}")
                value = str("" if value is None or str(value).lower() in ["none", "nan"] else value)
                tv.set(value)
                # print(f"\t\t\t{tv.get()=}")

            # print(f"{do_assign=}, {unit_in}")
            if do_assign:
                if do_place:
                    print(f"placing tile! B {unit_in=}")
                    unit_in.placed = True
                # print(f"{unit_in.history['_placed']=}")
                unit_in.Available_Date = self.dates_list[c - 1]
                unit_in.JobStartLine = self.lines[r - 1]
                unit_in.job_start_line_v2 = self.lines[r - 1]
            self.tile_properties[r][c]["unit_in"] = unit_in
            self.units[unit_in.SGQuote] = unit_in
            self.dirty_status_var.set(True)
            self.revert_colour((r, c))
            # print(dict_print(self.units, "self.units"))
        else:
            raise ValueError(f"Error can't assign this tile with this unit_in. {tag_in=}, {unit_in=}")

        # """Associate a unit object with a given tile space. Unit data only, no UI changes."""
        # # default_answer = 1 == back, 3 == forward, else == Nothing
        # assert isinstance(unit_in, Unit), "Error param 'unit_in' must be an instance of a Unit."
        # rc = self.tile_to_rc(tag_in)
        # if rc:
        #     r, c = rc
        #     line_in = self.lines[r - 1]
        #
        #     already_unit = self.tile_properties[r][c]["unit_in"]
        #     if already_unit is not None:
        #         print(
        #             f"\n\n\tABOUT TO OVERWRITE TILE {already_unit=} WITH {unit_in=}, {r=}, {c=}\n\tNEED TO WALK THE LINE TO DETERMINE IF A UNIT NEEDS TO BE SENT BEYOND.\n\n\n")
        #
        #         next_col = self.next_available_day(r)
        #         print(f"NEXT AVAILABLE COLUMN={next_col} ON {self.dates_list[next_col]}, ON LINE {self.lines[r - 1]}")
        #
        #     wd = self.day_of_week(c - 1)
        #     if wd > 4:
        #         date = self.dates_list[c - 1]
        #         pn = [-1, -1]
        #         tc = c - 1
        #         while (tc > 0) and (self.day_of_week(tc - 1) > 4):
        #             tc -= 1
        #         if tc < 0:
        #             raise ValueError(f"Error, cannot place tile at column c prev. Out of range: {tc}")
        #         prev_day = self.dates_list[tc - 1]
        #         if tc == 0:
        #             # need to add to beyond left
        #             print("\tAdding to beyond left")
        #             line_in = unit_in.JobStartLine
        #             self.tiles_beyond[line_in]["left"].insert(-1, unit_in)
        #         pn[0] = tc - 0
        #         tc = c + 1
        #         while (tc < len(self.dates_list)) and (self.day_of_week(tc - 1) > 4):
        #             tc += 1
        #         if tc < 0:
        #             raise ValueError(f"Error, cannot place tile at column c next. Out of range: {tc}")
        #         if tc == len(self.dates_list):
        #             # need to add to beyond right
        #             print("\tAdding to beyond right")
        #             line_in = unit_in.JobStartLine
        #             self.tiles_beyond[line_in]["right"].insert(0, unit_in)
        #         next_day = self.dates_list[tc - 1]
        #         pn[1] = tc + 0
        #         prev_day_msg = f"<< {prev_day:'%Y-%m-%d'} <<"
        #         next_day_msg = f">> {next_day:'%Y-%m-%d'} >>"
        #
        #         # x, y = self.rc_bbox((r, c))[:2]
        #         x, y = self.winfo_reqwidth(), self.winfo_reqheight()
        #         x //= 2
        #         y //= 2
        #
        #         # self.unbind_pre_pop_up()
        #
        #         def close_cmb(ans, r, c):
        #             if rc:
        #                 if wd > 4:
        #                     if ans == "closed":
        #                         ans = 0
        #                     else:
        #                         ans = int(ans)
        #                     # self.bind_post_pop_up()
        #                     print(f"{ans=}")
        #                     print(f"A {c=}, {pn=}")
        #                     if ans == 1:
        #                         # prev_day_msg
        #                         self.remove_tile(r, c)
        #                         self.delete_tile(r, c)
        #                         c = pn[0]
        #                         print(f"B {c=}")
        #                     elif ans == 3:
        #                         # next_day_msg
        #                         self.remove_tile(r, c)
        #                         self.delete_tile(r, c)
        #                         c = pn[1]
        #                         print(f"C {c=}")
        #                     else:
        #                         # 2
        #                         c = c
        #                         print(f"D {c=}")
        #
        #                     if 0 < c < len(self.dates_list):
        #                         self.set_rc_with_unit((r, c), unit_in)
        #                     # modify the history created from the placement action.
        #                     if self.history:
        #                         last = self.history[-1]
        #                         if isinstance(last, CalendarSurface.MovementUndoable):
        #                             # r_from = last.r_from
        #                             # c_from = last.c_from
        #                             # r_to = last.r_to
        #                             # c_to = last.c_to
        #                             # print(f"Modifying the history: {last.c_to=}, {c=}")
        #                             last.c_to = c
        #                             # self.status.set({"msg": "Need to swap the to col.", "c": c})
        #                     else:
        #                         print(f"NO HISTORY TO UNDO")
        #                     return
        #
        #                     # print(f"date: {self.dates_list[c - 1]=}, {c - 1=}")
        #                     # SGQuote# | Model No | Dealer Name | WO | Galv
        #
        #                 text_order = self.text_order
        #                 details = self.get_text_vars(tag_in)
        #                 keys = unit_in.__dict__.keys()
        #                 print(f"AA {text_order=}")
        #                 print(f"AA {details=}")
        #                 print(f"AA {keys=}")
        #                 for i, text_tv in enumerate(zip(text_order, details)):
        #                     text, tv = text_tv
        #                     text = "_" + text
        #                     value = text
        #                     if text in keys:
        #                         print(f"\t\t\tBEFORE {value=}")
        #                         value = getattr(unit_in, text, "N/A")
        #                         print(f"\t\t\tAFTER {value=}")
        #                         # TODO last point for UI formatting
        #                         if text == "_IsGalv":
        #                             value = value if value != 'N' else ''
        #                         elif text == "_WO" or text == "_Customer_WO":
        #                             if value is not None and value != "":
        #                                 if not math.isnan(value):
        #                                     value = int(value)
        #                         # print(f"\t\t\tAFTER {value=}")
        #                     # print(f"\t\tLOOK HERE 2 {i=}, {text=} = {value=}, {tv.get()=}")
        #                     value = str("" if value is None or str(value).lower() in ["none", "nan"] else value)
        #                     tv.set(value)
        #                     # print(f"\t\t\t{tv.get()=}")
        #
        #                 # print(f"{do_assign=}, {unit_in}")
        #                 if do_assign:
        #                     if do_place:
        #                         print(f"placing tile! B {unit_in=}")
        #                         unit_in.placed = True
        #                     # print(f"{unit_in.history['_placed']=}")
        #                     unit_in.Available_Date = self.dates_list[c - 1]
        #                     unit_in.JobStartLine = self.lines[r - 1]
        #                     unit_in.job_start_line_v2 = self.lines[r - 1]
        #                 self.tile_properties[r][c]["unit_in"] = unit_in
        #                 self.units[unit_in.SGQuote] = unit_in
        #                 self.dirty_status_var.set(True)
        #                 # print(dict_print(self.units, "self.units"))
        #             else:
        #                 raise ValueError(f"Error can't assign this tile with this unit_in. {tag_in=}, {unit_in=}")
        #
        #         if default_answer is None:
        #             ans = tkinter_utility.CustomMessageBox(
        #                 title="Illegal Placement",
        #                 msg=f"Error placing Quote {unit_in.SGQuote} on line '{line_in}'.\nCurrent application mode does not allow units to placed on a weekend.\nPlease Choose a valid action:",
        #                 x=x,
        #                 y=y,
        #                 b1=prev_day_msg,
        #                 b2="cancel",
        #                 b3=next_day_msg
        #             )
        #             ans.grab_set()
        #             ans.protocol("WM_DELETE_WINDOW", lambda ans=ans.choice, r=r, c=c: close_cmb(ans, r, c))
        #         else:
        #             ans = default_answer
        #
        #         close_cmb(ans, r, c)
        #         # self.configure(state="disabled")

    def export_tile_sql(self, removed_quotes):
        """Create a sql file containing batch statements from this session."""
        print(f"{removed_quotes=}")
        # print(f"{self.units=}")
        print(f"{self.tiles_beyond=}")
        # print_by_line(self.units)
        fn = self.sql_output_file_name.format(ts=datetime.datetime.now().strftime("%Y-%m-%d %H%M"))
        template = "\n-- {q}\nUPDATE [BWSdb].[dbo].[OrdersV2] SET [Available Date] = '{d}' WHERE [SGQuote] = '{q}'"
        # template_2 = "\n-- {q}\nUPDATE [BWSdb].[dbo].[OrdersV2] SET [Available Date] = '{d}' WHERE [SGQuote] = '{q}';\nUPDATE [Stargatedb].[dbo].[dtProductionScheduleV2] SET [JobFinishDate] = '{j}', [JobStartLine] = '{l}' WHERE [SGQuote] = '{q}'"
        # template_3 = "\n-- {q}\nUPDATE [BWSdb].[dbo].[OrdersV2] SET [Available Date] = NULL WHERE [SGQuote] = '{q}';\nUPDATE [Stargatedb].[dbo].[dtProductionScheduleV2] SET [JobFinishDate] = NULL, [JobStartLine] = NULL WHERE [SGQuote] = '{q}'"
        template_2 = "\n-- {q}\nINSERT INTO [PDS Updates] ([SGQuote], [AvailableDate], [Line], [UpdaterName]) VALUES ('{q}', '{d}', '{l}', '{u}')"
        template_3 = "\n-- {q}\nINSERT INTO [PDS Updates] ([SGQuote], [AvailableDate], [Line], [UpdaterName]) VALUES ('{q}', NULL, NULL, '{u}')"
        result = ""
        result_2 = ""
        result_3 = ""
        result_4 = ""

        rq = {quote for quote in set(removed_quotes)}
        user_name = self.user_name

        for unit_k, unit_o in self.units.items():
            if unit_k not in [None, "None", ""]:
                # print(f"{unit_k=}, {unit_o=}")
                rc = self.quote_rc(unit_k)
                # print(f"{rc=}")
                if rc:
                    # r, c = rc
                    # tag = self.tiles[r][c]
                    new_avail_date = unit_o.Available_Date
                    line = unit_o.JobStartLine
                    # print(f"{new_avail_date=}")
                    result += template.format(d=new_avail_date, q=unit_k)
                    result_2 += template_2.format(d=new_avail_date, q=unit_k, j=new_avail_date, l=line, u=user_name)
                    if unit_k in rq:
                        rq.remove(unit_k)
                # else:
                #     new_avail_date = getattr(unit_o, "Available_Date", "NULL")
                #     line = getattr(unit_o, "JobStartLine", "NULL")
                #     result += template_2.format(d=new_avail_date, q=unit_k, j=new_avail_date, l=line, u=user_name)
                #     result += f"\n-- {unit_k}\n"
                    # raise ValueError(f"{unit_k=} not found!")
        # print(f"RESULT = <{result}>")
        if result:
            with open(fn, "w") as f:
                f.write("\n\n\t-- Insert Updates\n")
                f.write(result_2)
        # print(f"RESULT2 = <{result_2}>")

        # print(f"{rq=}")
        for quote in rq:
            result_3 += template_3.format(q=quote, u=user_name)
        if result_3:
            with open(fn, "a") as f:
                f.write("\n\n\t-- Deletions\n")
                f.write(result_3)

        for line, d1 in self.tiles_beyond.items():
            for direction, que in d1.items():
                q = que.copy()
                if direction == "left":
                    q.reverse()
                for i, unit_in in enumerate(q):
                    if unit_in:
                        new_avail_date = self.dates_list[0] if direction == "left" else self.dates_list[-1]
                        new_avail_date += datetime.timedelta(days=((i+1) * (-1 if direction == "left" else 1)))
                        result_4 += template_2.format(d=new_avail_date, q=unit_in.SGQuote, j=new_avail_date, l=line, u=user_name)
        if result_4:
            with open(fn, "a") as f:
                f.write("\n\n\t-- Beyond Units\n")
                f.write(result_4)
        # print(f"RESULT3 = <{result_3}>")
        # print(f"RESULT4 = <{result_4}>")

        # print(f"{self.tile_properties[0]=}")
        # for r, prop in enumerate(self.tile_properties):
        #     for c, det in enumerate(prop):
        #         print(f"{r=}, {c=}, {det['unit_in']=}")
        return "\n".join([result_2, result_3, result_4])

    def update_tile_sql(self, removed_quotes):
        """Create a sql file containing batch statements from this session."""
        sql = self.export_tile_sql(removed_quotes)
        print(f"SQL\n<{sql}>")
        if sql:
            success = commit_update(sql)
        else:
            success = False
        return success

    def remove_tile(self, r, c):
        # use this one to remove a tile from the UI
        tile = self.tiles[r][c]
        vars = self.get_text_vars(tile)
        for var in vars:
            var.set("")

    def delete_tile(self, r, c, unplace=True):
        # use this one to delete the data association between the unit and the tile.
        details = self.tile_properties[r][c]
        unit_in = details["unit_in"]
        if unit_in:
            quote = unit_in.SGQuote
            if unplace:
                self.units[quote].placed = False
        details["unit_in"] = None

    def redo(self):
        print(f"{self.redo_history=}")
        fail = False
        if self.redo_history:
            last = self.redo_history.pop(-1)
            result = (1, {"msg": "success"})
            match type(last):
                case CalendarSurface.PlacementUndoable:
                    unit_in = last.unit_in
                    r = last.r
                    c = last.c
                    self.set_rc_with_unit((r, c), unit_in)
                    print(f"END UNDO")
                    result = (2, {"msg": "Need to replace unit from combo list.", "quote": unit_in.SGQuote})
                case CalendarSurface.ShiftUndoable:
                    line_in = last.line_in
                    days_in = last.n_days
                    direction_in = last.direction_in
                    result = (5, {"msg": "Need to shift in reverse.", "line_in": line_in, "days_in": days_in,
                                  "direction_in": direction_in})
                case CalendarSurface.MovementUndoable:
                    unit_in = last.unit_in
                    r_from = last.r_from
                    c_from = last.c_from
                    r_to = last.r_to
                    c_to = last.c_to
                    self.set_rc_with_unit((r_from, c_from), unit_in)
                    self.remove_tile(r_to, c_to)
                    self.set_rc_with_unit((r_to, c_to), unit_in)
                    self.remove_tile(r_from, c_from)
                case CalendarSurface.SwapUndoable:
                    unit_from = last.unit_from
                    unit_to = last.unit_to
                    r_from = last.r_from
                    c_from = last.c_from
                    r_to = last.r_to
                    c_to = last.c_to
                    self.set_rc_with_unit((r_to, c_to), unit_to)
                    self.set_rc_with_unit((r_from, c_from), unit_from)
                    result = (4, {"msg": "Need to recolour code tiles.", "unit_to": unit_to, "unit_from": unit_from})
                case CalendarSurface.DeletionUndoable:
                    unit_in = last.unit_in
                    r = last.r
                    c = last.c
                    self.remove_tile(r, c)
                    self.delete_tile(r, c)
                    print(f"END UNDO")
                    result = (3, {"msg": "Need to add quote to combo list.", "quote": unit_in.SGQuote})
                case _:
                    fail = True
        else:
            fail = True

        if not fail:
            print(f"END UNDO")
            # self.redo_history.append(last)
            return result
        # else:
        #     self.history.append(last)

        if fail:
            msg = f"Nothing to undo"
            print(f"END UNDO")
            return (0, {"msg": msg})

    def undo(self) -> tuple[int, dict[str, object]]:
        # 1 - success
        # 0 - failure
        # 2 - success - but need to re-add a removed tile to the combo list.
        print(f"CLICK UNDO")
        fail = False
        result = (1, {"msg": "success"})
        if self.history:
            last = self.history.pop(-1)
            match type(last):
                case CalendarSurface.PlacementUndoable:
                    unit_in = last.unit_in
                    r = last.r
                    c = last.c
                    self.remove_tile(r, c)
                    self.delete_tile(r, c)
                    print(f"END UNDO")
                    result = (2, {"msg": "Need to replace unit in combo list.", "quote": unit_in.SGQuote})
                case CalendarSurface.DeletionUndoable:
                    unit_in = last.unit_in
                    r = last.r
                    c = last.c
                    self.set_rc_with_unit((r, c), unit_in, set_style=True)
                    print(f"END UNDO")
                    result = (3, {"msg": "Need to remove quote from combo list.", "quote": unit_in.SGQuote})
                case CalendarSurface.MovementUndoable:
                    unit_in = last.unit_in
                    r_from = last.r_from
                    c_from = last.c_from
                    r_to = last.r_to
                    c_to = last.c_to
                    self.set_rc_with_unit((r_from, c_from), unit_in)
                    self.remove_tile(r_to, c_to)
                case CalendarSurface.SwapUndoable:
                    unit_from = last.unit_from
                    unit_to = last.unit_to
                    r_from = last.r_from
                    c_from = last.c_from
                    r_to = last.r_to
                    c_to = last.c_to
                    self.set_rc_with_unit((r_from, c_from), unit_to)
                    self.set_rc_with_unit((r_to, c_to), unit_from)
                    result = (4, {"msg": "Need to recolour code tiles.", "unit_to": unit_to, "unit_from": unit_from})
                case CalendarSurface.ShiftUndoable:
                    line_in = last.line_in
                    days_in = last.n_days
                    direction_in = last.direction_in
                    result = (5, {"msg": "Need to shift in reverse.", "line_in": line_in, "days_in": days_in, "direction_in": direction_in})
                case _:
                    fail = True

            if not fail:
                print(f"END UNDO")
                self.redo_history.append(last)
                return result
            else:
                self.history.append(last)
        else:
            fail = True

        if fail:
            msg = f"Nothing to undo"
            print(f"END UNDO")
            return (0, {"msg": msg})

    def colour_cell(self, rc, dealer_colour_status=None):
        print(f"colour_cell")
        r, c = rc
        tile = self.tile_properties[r][c]["tag_rect"]
        unit = self.tile_properties[r][c]["unit_in"]
        if unit is not None:
            dealer = unit.InputField2_v2
        else:
            dealer = None
        # texts = [self.tile_properties[r][c]["t1_tag"], self.tile_properties[r][c]["t2_tag"], self.tile_properties[r][c]["t3_tag"], self.tile_properties[r][c]["t4_tag"], self.tile_properties[r][c]["t5_tag"]]
        texts = self.get_text_tags(tile)
        # if not do_return:
        tile_colour, outline_colour, active_fill_colour, active_outline_colour, font_colour = self.calc_colours(r, c)
        if dealer:
            print(f"{dealer=}")
            print(f"{dealer_colour_status=}")
            print(f"{dealer in dealer_colour_status=}")
            if dealer in dealer_colour_status:
                print(f"{dealer_colour_status[dealer]=}")
            else:
                print(f"'dealer' not in dealer_colour_status")
        if dealer and dealer_colour_status and (dealer in dealer_colour_status) and dealer_colour_status[dealer] and (dealer_colour_status[dealer] != "none"):
            # this cell has a dealer colour code.
            details = self.tile_properties[r][c]
            colour = Colour(dealer_colour_status[dealer])
            b = brighten(colour.rgb_code, 0.25, rgb=False)
            hc = colour.hex_code
            fc = font_foreground(colour.rgb_code, rgb=False)
            af = brighten(fc, 0.25, rgb=False)

            self.itemconfigure(
                tile,
                fill=hc,
                activefill=b,
                outline=hc,
                activeoutline=b
            )

            self.itemconfigure(details["t1_tag"], fill=fc, activefill=af)
            self.itemconfigure(details["t2_tag"], fill=fc, activefill=af)
            self.itemconfigure(details["t3_tag"], fill=fc, activefill=af)
            self.itemconfigure(details["t4_tag"], fill=fc, activefill=af)
            self.itemconfigure(details["t5_tag"], fill=fc, activefill=af)
            self.itemconfigure(details["t6_tag"], fill=fc, activefill=af)

            # if do_return:
            #     return hc, b, hc, b, font_colour

        else:
            self.itemconfigure(tile,
                           fill=tile_colour,
                           outline=outline_colour,
                           activeoutline=active_outline_colour,
                           activefill=active_fill_colour
                           )


            for t in texts:
                self.itemconfigure(t, fill=font_colour, activefill=active_fill_colour)

            # if do_return:
            #     return tile_colour, outline_colour, active_outline_colour, active_fill_colour, font_colour

    def colour_code_dealer(self, dealer, colour):
        if dealer is not None and colour is not None:
            d = dealer.upper()
            colour = Colour(colour)
            b = brighten(colour.rgb_code, 0.25, rgb=False)
            hc = colour.hex_code
            fc = font_foreground(colour.rgb_code, rgb=False)
            af = brighten(fc, 0.25, rgb=False)
            print(f"{d=}, {colour=}, {b=}, {hc=}, {fc=}, {af=}")

            self.dealer_colour_scheme.update({dealer: colour})

            for r, row in enumerate(self.tiles):
                for c, tile in enumerate(row):
                    details = self.tile_properties[r][c]
                    unit_in = details["unit_in"]
                    # print(f"{unit_in=}")
                    if unit_in not in [None, "", "none"]:
                        if unit_in.InputField2_v2 not in [None, "", "none"]:
                            if unit_in.InputField2_v2.upper() == d:
                                self.itemconfigure(
                                    tile,
                                    fill=hc,
                                    activefill=b,
                                    outline=hc,
                                    activeoutline=b
                                )

                                self.itemconfigure(details["t1_tag"], fill=fc, activefill=af)
                                self.itemconfigure(details["t2_tag"], fill=fc, activefill=af)
                                self.itemconfigure(details["t3_tag"], fill=fc, activefill=af)
                                self.itemconfigure(details["t4_tag"], fill=fc, activefill=af)
                                self.itemconfigure(details["t5_tag"], fill=fc, activefill=af)
                                self.itemconfigure(details["t6_tag"], fill=fc, activefill=af)

    def revert_colour(self, rc):
        print(f"REVERTING COLOURS {rc=}")
        r, c = rc
        tile = self.tile_properties[r][c]["tag_rect"]
        # texts = [self.tile_properties[r][c]["t1_tag"], self.tile_properties[r][c]["t2_tag"], self.tile_properties[r][c]["t3_tag"], self.tile_properties[r][c]["t4_tag"], self.tile_properties[r][c]["t5_tag"]]
        texts = self.get_text_tags(tile)
        tile_colour, outline_colour, active_fill_colour, active_outline_colour, font_colour = self.calc_colours(r, c)
        self.itemconfigure(tile,
                    fill=tile_colour,
                    outline=outline_colour,
                    activeoutline=active_outline_colour,
                    activefill=active_fill_colour
        )
        for t in texts:
            self.itemconfigure(t, fill=font_colour, activefill=active_fill_colour)

    def get_beyond_quotes(self):
        beyond = []
        for line, line_data in self.tiles_beyond.items():
            for direction, lst, in line_data.items():
                for unit_in in lst:
                    if unit_in is not None:
                        beyond.append(unit_in.SGQuote)
        return beyond

    def shift_line(self, shift_details, dealer_status=None, undoable=True):
        print(f"{shift_details=}")
        line_in = shift_details["line"]
        direction_in = shift_details["direction"]
        days_in = shift_details["days"]
        submission_in = shift_details["submission"]
        start_date_in = shift_details["start_date"]
        end_date_in = shift_details["end_date"]
        msg_in = shift_details["msg"]
        nsd = not start_date_in
        ned = not end_date_in

        if line_in == "All":
            for line in self.lines:
                self.shift_line(
                    {
                        "line": line,
                        "direction": direction_in,
                        "days": days_in,
                        "start_date": start_date_in,
                        "end_date": end_date_in,
                        "msg": msg_in,
                        "submission": submission_in
                    },
                    dealer_status=dealer_status,
                    undoable=undoable
                )
        else:
            i_row = self.lines.index(line_in) + 1
            start = 1
            stop = len(self.tiles[i_row])
            step = 1
            if direction_in == "forward":
                start, stop = stop - 1, start - 2
                step = -1
            print(f"BEFORE\t{self.tiles_beyond=}")
            unit_popped = None
            i = 0
            weekend_offset = 0

            if undoable:
                self.new_history(CalendarSurface.ShiftUndoable(line_in, days_in, direction_in))

            while i < days_in:
                print(f"{i=}, {start=}, {stop=}, {step=}, {i_row=}")
                # print(f"{bool(self.tiles_beyond[line_in]['right'])=}, '{self.tiles_beyond[line_in]['right']}', {direction_in == 'forward'=}, {direction_in == 'forward' and self.tiles_beyond[line_in]['right']=}")
                # print(f"{bool(self.tiles_beyond[line_in]['left'])=}, '{self.tiles_beyond[line_in]['left']}', {direction_in == 'forward'=}, {direction_in == 'forward' and self.tiles_beyond[line_in]['left']=}")
                # print(f"{bool(self.tiles_beyond[line_in]['right'])=}, '{self.tiles_beyond[line_in]['right']}', {direction_in == 'backward'=}, {direction_in == 'backward' and self.tiles_beyond[line_in]['right']=}")
                # print(f"{bool(self.tiles_beyond[line_in]['left'])=}, '{self.tiles_beyond[line_in]['left']}', {direction_in == 'backward'=}, {direction_in == 'backward' and self.tiles_beyond[line_in]['left']=}")
                if direction_in == "forward" and self.tiles_beyond[line_in]["right"]:
                    self.tiles_beyond[line_in]["right"].insert(0, None)
                    print(f"--A")
                elif direction_in == "forward" and self.tiles_beyond[line_in]["left"]:
                    unit_to_pop = self.tiles_beyond[line_in]["left"][-1]
                    print(f"{unit_to_pop=}")
                    if unit_to_pop:
                        date = self.dates_list[0]
                        print(f"{date=}")
                        if (nsd and ned) or (not nsd and (start_date_in <= date)) or (not ned and (end_date_in >= date)) or (start_date_in <= date <= end_date_in):
                            #TODO shift these tile out of the list
                            # TODO verify that adjacent units arent overwritten at this step
                            # TODO instead of inserting at 1, need to calculate (days - 1) so it will stay in sync with the rest of the calendar
                            unit_popped = self.tiles_beyond[line_in]["left"].pop(-1)
                            if unit_popped:
                                # TODO, check that this insert does not land on a weekend.
                                self.set_rc_with_unit((i_row, 1), unit_popped, default_answer=(1 if direction_in == "backward" else 3))
                    print(f"--B")
                elif direction_in == "backward" and self.tiles_beyond[line_in]["right"]:
                    #TODO shift these tile out of the list
                    # TODO verify that adjacent units arent overwritten at this step
                    # TODO instead of inserting at 1, need to calculate (days - 1) so it will stay in sync with the rest of the calendar
                    unit_popped = self.tiles_beyond[line_in]["right"].pop(0)
                    if unit_popped:
                        # TODO, check that this insert does not land on a weekend.
                        self.set_rc_with_unit((i_row, len(self.tiles[i_row]) - 1), unit_popped, default_answer=(1 if direction_in == "backward" else 3))
                    print(f"--C")
                elif direction_in == "backward" and self.tiles_beyond[line_in]["left"]:
                    # TODO, append nones to save space for weekends.
                    self.tiles_beyond[line_in]["left"].append(None)
                    print(f"--D")
                else:
                    print(f"--E")
                for j in range(start, stop, step):
                    tile = self.tiles[i_row][j]
                    details = self.tile_properties[i_row][j]
                    day = self.dates_list[j]
                    unit_in = details["unit_in"]
                    beyond_left = False
                    beyond_right = False
                    if unit_in not in [None, "none", "", unit_popped]:
                        print(f"\t\t\t\t\t{j=}, {step=}, {(j==1)=}, {(step==1)=}, {(j==1 and step==1)=}")
                        if j == 1 and step == 1:
                            beyond_left = True
                            print(f"HEREA\t\t{self.tiles_beyond=}")
                            self.tiles_beyond[line_in]["left"].insert(-1, unit_in)
                            print(f"HEREB\t\t{self.tiles_beyond=}")
                        elif j == len(self.tiles[i_row]) - 1 and step == -1:
                            beyond_right = True
                            self.tiles_beyond[line_in]["right"].insert(0, unit_in)

                        if not beyond_left and not beyond_right:
                            print(f"{i=}, {j=}, {tile=}, {day=}, {unit_in=}, BL={beyond_left}, BR={beyond_right}, {details=}")
                            # TODO verify that a weekday unit does not get pushed to weekend and vice-versa
                            r_c = i_row, j - step
                            self.set_rc_with_unit(r_c, unit_in, default_answer=(1 if direction_in == "backward" else 3))
                        else:
                            print(f"BEYOND! {i=}, {j=}, {tile=}, {day=}, {unit_in=}, BL={beyond_left}, BR={beyond_right}, {details=}")
                            print(dict_print(self.tiles_beyond, "Tiles Beyond"))
                        self.remove_tile(i_row, j)
                        self.delete_tile(i_row, j)
                        self.colour_cell((i_row, j), dealer_colour_status=dealer_status)
                        self.colour_cell((i_row, j - step), dealer_colour_status=dealer_status)
                        # if not beyond_left and not beyond_right:
                        #     self.after(100, self.set_rc_with_unit, (self, (i_row, j + step), unit_in))
                        # else:

                    # else:
                    #     print(f"SKIP: {unit_in=}")
                i += 1

    # def shift_line(self, shift_details, dealer_status=None, undoable=True):
    #     print(f"{shift_details=}")
    #     line_in = shift_details["line"]
    #     direction_in = shift_details["direction"]
    #     days_in = shift_details["days"]
    #     submission_in = shift_details["submission"]
    #     start_date_in = shift_details["start_date"]
    #     end_date_in = shift_details["end_date"]
    #     msg_in = shift_details["msg"]
    #
    #     if line_in == "All":
    #         for line in self.lines:
    #             self.shift_line(
    #                 {
    #                     "line": line,
    #                     "direction": direction_in,
    #                     "days": days_in,
    #                     "start_date": start_date_in,
    #                     "end_date": end_date_in,
    #                     "msg": msg_in,
    #                     "submission": submission_in
    #                 },
    #                 dealer_status=dealer_status,
    #                 undoable=undoable
    #             )
    #     else:
    #         i_row = self.lines.index(line_in) + 1
    #         start = 1
    #         stop = len(self.tiles[i_row])
    #         step = 1
    #         if direction_in == "forward":
    #             start, stop = stop - 1, start - 2
    #             step = -1
    #         print(f"BEFORE\t{self.tiles_beyond=}")
    #         unit_popped = None
    #         i = 0
    #         weekend_offset = 0
    #
    #         if undoable:
    #             self.new_history(CalendarSurface.ShiftUndoable(line_in, days_in, direction_in))
    #
    #         while i < days_in:
    #             print(f"{i=}, {start=}, {stop=}, {step=}, {i_row=}")
    #             # print(f"{bool(self.tiles_beyond[line_in]['right'])=}, '{self.tiles_beyond[line_in]['right']}', {direction_in == 'forward'=}, {direction_in == 'forward' and self.tiles_beyond[line_in]['right']=}")
    #             # print(f"{bool(self.tiles_beyond[line_in]['left'])=}, '{self.tiles_beyond[line_in]['left']}', {direction_in == 'forward'=}, {direction_in == 'forward' and self.tiles_beyond[line_in]['left']=}")
    #             # print(f"{bool(self.tiles_beyond[line_in]['right'])=}, '{self.tiles_beyond[line_in]['right']}', {direction_in == 'backward'=}, {direction_in == 'backward' and self.tiles_beyond[line_in]['right']=}")
    #             # print(f"{bool(self.tiles_beyond[line_in]['left'])=}, '{self.tiles_beyond[line_in]['left']}', {direction_in == 'backward'=}, {direction_in == 'backward' and self.tiles_beyond[line_in]['left']=}")
    #             if direction_in == "forward" and self.tiles_beyond[line_in]["right"]:
    #                 self.tiles_beyond[line_in]["right"].insert(0, None)
    #                 print(f"A")
    #             elif direction_in == "forward" and self.tiles_beyond[line_in]["left"]:
    #                 #TODO shift these tile out of the list
    #                 # TODO verify that adjacent units arent overwritten at this step
    #                 # TODO instead of inserting at 1, need to calculate (days - 1) so it will stay in sync with the rest of the calendar
    #                 unit_popped = self.tiles_beyond[line_in]["left"].pop(-1)
    #                 if unit_popped:
    #                     # TODO, check that this insert does not land on a weekend.
    #                     self.set_rc_with_unit((i_row, 1), unit_popped, default_answer=(1 if direction_in == "backward" else 3))
    #                 print(f"B")
    #             elif direction_in == "backward" and self.tiles_beyond[line_in]["right"]:
    #                 #TODO shift these tile out of the list
    #                 # TODO verify that adjacent units arent overwritten at this step
    #                 # TODO instead of inserting at 1, need to calculate (days - 1) so it will stay in sync with the rest of the calendar
    #                 unit_popped = self.tiles_beyond[line_in]["right"].pop(0)
    #                 if unit_popped:
    #                     # TODO, check that this insert does not land on a weekend.
    #                     self.set_rc_with_unit((i_row, len(self.tiles[i_row]) - 1), unit_popped, default_answer=(1 if direction_in == "backward" else 3))
    #                 print(f"C")
    #             elif direction_in == "backward" and self.tiles_beyond[line_in]["left"]:
    #                 # TODO, append nones to save space for weekends.
    #                 self.tiles_beyond[line_in]["left"].append(None)
    #                 print(f"D")
    #             else:
    #                 print(f"E")
    #             for j in range(start, stop, step):
    #                 tile = self.tiles[i_row][j]
    #                 details = self.tile_properties[i_row][j]
    #                 day = self.dates_list[j]
    #                 unit_in = details["unit_in"]
    #                 beyond_left = False
    #                 beyond_right = False
    #                 if unit_in not in [None, "none", "", unit_popped]:
    #                     print(f"\t\t\t\t\t{j=}, {step=}, {(j==1)=}, {(step==1)=}, {(j==1 and step==1)=}")
    #                     if j == 1 and step == 1:
    #                         beyond_left = True
    #                         print(f"HEREA\t\t{self.tiles_beyond=}")
    #                         self.tiles_beyond[line_in]["left"].insert(-1, unit_in)
    #                         print(f"HEREB\t\t{self.tiles_beyond=}")
    #                     elif j == len(self.tiles[i_row]) - 1 and step == -1:
    #                         beyond_right = True
    #                         self.tiles_beyond[line_in]["right"].insert(0, unit_in)
    #
    #                     if not beyond_left and not beyond_right:
    #                         print(f"{i=}, {j=}, {tile=}, {day=}, {unit_in=}, BL={beyond_left}, BR={beyond_right}, {details=}")
    #                         # TODO verify that a weekday unit does not get pushed to weekend and vice-versa
    #                         r_c = i_row, j - step
    #                         self.set_rc_with_unit(r_c, unit_in, default_answer=(1 if direction_in == "backward" else 3))
    #                     else:
    #                         print(f"BEYOND! {i=}, {j=}, {tile=}, {day=}, {unit_in=}, BL={beyond_left}, BR={beyond_right}, {details=}")
    #                         print(dict_print(self.tiles_beyond, "Tiles Beyond"))
    #                     self.remove_tile(i_row, j)
    #                     self.delete_tile(i_row, j)
    #                     self.colour_cell((i_row, j), dealer_colour_status=dealer_status)
    #                     self.colour_cell((i_row, j - step), dealer_colour_status=dealer_status)
    #                     # if not beyond_left and not beyond_right:
    #                     #     self.after(100, self.set_rc_with_unit, (self, (i_row, j + step), unit_in))
    #                     # else:
    #
    #                 # else:
    #                 #     print(f"SKIP: {unit_in=}")
    #             i += 1

    def new_history(self, undoable):
        self.history.append(undoable)
        self.redo_history.clear()


    # def get_history(self):
    #     return self._history
    #
    # def set_history(self, history_in):
    #     print(f"SETTING HISTORY\nBEFORE\n{self._history}\nAfter\n{history_in}")
    #     self._history = history_in
    #
    # def del_history(self):
    #     del self._history

    # history = property(get_history, set_history, del_history)

    class Undoable:

        _number = 0

        def __init__(self):
            self.id_num = self.number
            self.ts = datetime.datetime.now()

        def get_number(self):
            self._number += 1
            return self._number

        def set_number(self, number_in: int):
            self._number = number_in

        def del_number(self):
            del self._number

        number = property(get_number, set_number, del_number)

    class PlacementUndoable(Undoable):
        def __init__(self, r: int, c: int, unit_in: Unit):
            super(CalendarSurface.PlacementUndoable, self).__init__()
            self.r = r
            self.c = c
            self.unit_in = unit_in

        def __repr__(self):
            return f"<PlacementUndoable Unit Q={self.unit_in.SGQuote} | ({self.r}, {self.c})>"

    class DeletionUndoable(Undoable):
        def __init__(self, r: int, c: int, unit_in: Unit):
            super(CalendarSurface.DeletionUndoable, self).__init__()
            self.r = r
            self.c = c
            self.unit_in = unit_in

        def __repr__(self):
            return f"<DeletonUndoable Unit Q={self.unit_in.SGQuote} | ({self.r}, {self.c})>"

    class MovementUndoable(Undoable):
        def __init__(self, r_from: int, c_from: int, r_to: int, c_to: int, unit_in: Unit):
            super(CalendarSurface.MovementUndoable, self).__init__()
            self.r_from = r_from
            self.c_from = c_from
            self.r_to = r_to
            self.c_to = c_to
            self.unit_in = unit_in

        def __repr__(self):
            return f"<MovementUndoable Unit Q={self.unit_in.SGQuote} | ({self.r_from}, {self.c_from}) -> ({self.r_to}, {self.c_to})>"

    class ShiftUndoable(Undoable):
        def __init__(self, line: str, n_days: int, direction_in: str):
            super(CalendarSurface.ShiftUndoable, self).__init__()
            self.line_in = line
            self.n_days = n_days
            self.direction_in = direction_in

        def __repr__(self):
            return f"<ShiftUndoable Line={self.line_in} direction={self.direction_in}, days={self.n_days}>"

    class SwapUndoable(Undoable):
        def __init__(self, r_from: int, c_from: int, r_to: int, c_to: int, unit_from: Unit, unit_to: Unit):
            super(CalendarSurface.SwapUndoable, self).__init__()
            self.r_from = r_from
            self.c_from = c_from
            self.r_to = r_to
            self.c_to = c_to
            self.unit_from = unit_from
            self.unit_to = unit_to

        def __repr__(self):
            return f"<SwapUndoable Unit Q={self.unit_from.SGQuote} | ({self.r_from}, {self.c_from}) <-> ({self.r_to}, {self.c_to}) | Unit Q={self.unit_to.SGQuote}>"
