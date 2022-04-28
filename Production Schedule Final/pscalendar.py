from utility import flatten, dt, print_by_line, Rect2, clamp, tkinter_to_rect2, rect2_to_tkinter
from colour_utility import *
import math


class CalendarTile2:
    """Class representing a slot in production. Associated to a trailer line and a date"""

    def __init__(self, ser, i, j, line, date, colour, colour_border, colour_font, colour_selected, colour_hovered, colour_dragging):
        self.ser = ser
        self.i = i
        self.j = j
        self.line = line
        self.date = date

        self.wo_num = None
        self.model_name = None
        self.dealer = None
        self.status = None
        self.beam = None
        self.job_start = None
        self.text = ""

        # use RGB values and tuples. will be converted to hex via rgb_to_hex()
        self.colour = colour
        self.colour_border = colour_border
        self.colour_font = colour_font

        self.colour_selected = colour_selected
        self.colour_hovered = colour_hovered
        self.colour_dragging = colour_dragging

        self.selected = False
        self.hovered = False
        self.dbl_clicked = False
        self.zoomed = False

    def set_data(self, wo, model_name, dealer, status, beam, job_start):
        self.wo_num = wo
        self.model_name = model_name
        self.dealer = dealer
        self.status = status
        self.beam = beam
        self.job_start = job_start
        self.text = "{}\n{}\n{}\n{}\n{}\n{}".format(wo, model_name, dealer, status, beam, job_start)

    def get_data(self):
        return self.wo_num, self.model_name, self.dealer, self.status, self.beam, self.job_start

    def is_beam(self):
        return self.line[0] == "B"

    def is_gnk(self):
        return self.line[:3] == "GNK"

    def is_top_level_wo(self):
        return str(self.wo_num)[:4] == "1001"

    def get_pdf_text(self):
        return self.text if len("".join([s.strip() for s in self.text.split("None")])) else "Line: {}\nDate: {}".format(self.line, self.date)

    def info_dict(self):
        return dict(zip([
            "row",
            "col",
            "line",
            "date",
            "colour",
            "text",
            "wo_num",
            "model_name",
            "dealer",
            "status",
            "beam",
            "job_start"
        ],
        [
            self.i,
            self.j,
            self.line,
            self.date,
            self.colour,
            self.text,
            self.wo_num,
            self.model_name,
            self.dealer,
            self.status,
            self.beam,
            self.job_start
        ]))

    def __repr__(self):
        return f"<CT line: {self.line}, date: {self.date}, ({self.i}, {self.j}), ser: {self.ser}>"


class PSCalendar2:

    class CalendarException(Exception):
        def __init__(self, message):
            pass

    def __init__(self, start_date, end_date, data, lines, dates, colour_tile, colour_border, colour_font, colour_selected, colour_hovered, colour_dragging, border_width, switch_week_divs, colour_weekend_div, max_n_zoomed_rows=2, max_n_zoomed_cols=2, min_tile_w=30, min_tile_h=15, max_tile_w=100, max_tile_h=50):
        assert isinstance(start_date,
                          dt.datetime), "Start_date object \"{}\" must be a datetime.datetime object.".format(
            start_date)
        assert isinstance(end_date, dt.datetime), "End_date object \"{}\" must be a datetime.datetime object.".format(
            end_date)
        assert end_date >= start_date, "End_date \"{}\" must be after start_date \"{}\".".format(end_date, start_date)
        self.version_num = 1
        self.start_date = start_date
        self.end_date = end_date
        self.data = data
        self.lines = lines
        self.dates = dates
        self.rows = len(lines)
        self.cols = len(dates)
        self.border_width = border_width
        self.switch_week_divs = switch_week_divs
        self.weekend_div_colour = colour_weekend_div
        self.max_n_zoomed_rows = max_n_zoomed_rows
        self.max_n_zoomed_cols = max_n_zoomed_cols

        self.min_tile_w = min_tile_w
        self.min_tile_h = min_tile_h
        self.max_tile_w = max_tile_w
        self.max_tile_h = max_tile_h

        self._dragging = None
        self._selected = None
        self._hover_select = None
        self._dbl_clicked = None
        self._swap_pair = None

        # Create tiles
        colour = colour_tile
        colour_border = colour_border
        colour_font = colour_font
        colour_selected = colour_selected
        colour_hovered = colour_hovered
        colour_dragging = colour_dragging
        self.tiles = flatten([[CalendarTile2((i * self.cols) + j, i, j, line, date, colour, colour_border, colour_font, colour_selected, colour_hovered, colour_dragging)
              for j, date in enumerate(self.dates)] for i, line in enumerate(self.lines)])

        for i, tile in enumerate(self.tiles):
            idxrc = (i // self.rows), (i % self.rows)
            # print("idxrc:", idxrc)
            idx = (idxrc[1] * self.rows) + idxrc[0]  # self.r_c_to_i(idxrc[1], idxrc[0])
            # idxrc = i // self.rows , (i % self.cols)
            # idx = (self.cols * (i // self.rows)) + (i % self.cols)
            idx = i
            # print("from i: {} to idx: {}, idxrc: {}".format(i, idx, idxrc))
            data_row = data.iloc[idx:idx + 1, :]
            if data_row['InputField1'] is not None and data_row['InputField2'] is not None:
                # print("data_row:", data_row)
                if math.isnan(data_row['WO#'].tolist()[0]):
                    continue
                wo = int(data_row['WO#'].tolist()[0])
                model_name = data_row['InputField1'].tolist()[0]
                dealer = data_row['InputField2'].tolist()[0]
                status = data_row["Stock/Sold"].tolist()[0]
                beam = data_row["Beam WO#"].tolist()[0]
                job_start = data_row["JobStartDate"].tolist()[0]
                self.tiles[i].set_data(wo, model_name, dealer, status, beam, job_start)

        print("tiles: ")
        print_by_line([t.info_dict() for t in self.tiles])
        print(f"data: {self.data}")
        print_by_line(self.data)

    def r_c_to_i(self, r, c):
        return (r * self.cols) + c

    def i_to_r_c(self, i):
        return (i // self.cols), (i % self.cols)

    def x_y_to_r_c(self, x, y, rect):
        for i, tile in enumerate(self.tiles):
            r, c = self.i_to_r_c(i)
            rect_calc = self.get_rect(i, rect)
            # print(f"Arc: <{rect_calc}>, type({type(rect_calc)})")
            # rect_calc = list(rect_calc)[:4]
            # print(f"Brc: <{rect_calc}>, type({type(rect_calc)})")
            x1, y1, x2, y2 = rect2_to_tkinter(rect_calc)
            bw = self.border_width
            if x1 - (2 * bw) <= x <= x2 + (2 * bw) and y1 - (2 * bw) <= y <= y2 + (2 * bw):
                return r, c

        print("Could not map x and y: ({}, {})".format(x, y))

    def get_dragging(self):
        return [t for t in self.tiles if t.dragging]

    def set_dragging(self, drag_idx):
        self.tiles[drag_idx].dragging = True

    def del_dragging(self):
        del self._dragging

    def get_selected(self):
        return [t for t in self.tiles if t.selected]

    def set_selected(self, drag_idx):
        self.tiles[drag_idx].selected = True

    def del_selected(self):
        del self._selected

    def get_hover_select(self):
        return [t for t in self.tiles if t.hovered]

    def set_hover_select(self, drag_idx):
        self.tiles[drag_idx].hovered = True

    def del_hover_select(self):
        del self._hover_select

    def get_dbl_select(self):
        return [t for t in self.tiles if t.dbl_clicked]

    def set_dbl_select(self, drag_idx):
        self.tiles[drag_idx].dbl_clicked = True

    def del_dbl_select(self):
        del self._dbl_clicked

    def get_swap_pair(self):
        return [t for t in self.tiles if t.dbl_clicked]

    def set_swap_pair(self, pair):
        self._swap_pair = pair

    def del_swap_pair(self):
        del self._swap_pair

    def y_at_row(self, row, rect):
        return sum([self.row_height(r, rect) for r in range(row)])

    def x_at_col(self, col, rect):
        return sum([self.col_width(c, rect) for c in range(col)])

    def row_height(self, row, rect):
        x, y, w, h, a = rect
        # w -= 2 * self.border_width
        # h -= 2 * self.border_width
        # x += self.border_width
        # y += self.border_width
        rows = self.rows
        # cols = self.cols
        # cw = tw = w / cols
        ch = th = h / rows
        r, c = row, 0
        # tile_idx = self.r_c_to_i(r, c)
        # print(f"tile_idx: {tile_idx}, rc: ({r}, {c}), xy: ({x}, {y}), th: {th}, tw: {tw}")

        # tile = self.tiles[tile_idx]
        zoomed_rows = self.zoomed_rows()
        # zoomed_cols = self.zoomed_cols()

        # mntw = self.min_tile_w
        mnth = self.min_tile_h
        # mxtw = self.max_tile_w
        mxth = self.max_tile_h

        if zoomed_rows:
            nh = h - (len(zoomed_rows) * (mxth - th)) - (rows * self.border_width)
            th = nh / rows
        # rinzr =
        # cinzc = c in zoomed_cols
        if r in zoomed_rows:
            th = mxth

        # if cinzc:
            # tw = mxtw
        # if not (rinzr or cinzc):
        # if not rinzr:
        #     # tw = max(cw, mntw)
        #     th = max(ch, mnth)
        #     th = ch
        return th

    def col_width(self, col, rect):
        x, y, w, h, a = rect
        w -= 2 * self.border_width
        h -= 2 * self.border_width
        x += self.border_width
        y += self.border_width
        # rows = self.rows
        cols = self.cols
        cw = tw = w / cols
        # ch = th = h / rows
        r, c = 0, col
        # tile_idx = self.r_c_to_i(r, c)
        # print(f"tile_idx: {tile_idx}, rc: ({r}, {c}), xy: ({x}, {y}), th: {th}, tw: {tw}")

        # tile = self.tiles[tile_idx]
        # zoomed_rows = self.zoomed_rows()
        zoomed_cols = self.zoomed_cols()

        mntw = self.min_tile_w
        # mnth = self.min_tile_h
        mxtw = self.max_tile_w
        # mxth = self.max_tile_h

        # if zoomed_rows:
        # rinzr = r in zoomed_rows
        cinzc = c in zoomed_cols
        # if rinzr:
        #     th = mxth
        if cinzc:
            tw = mxtw
        # if not (rinzr or cinzc):
        if not cinzc:
            tw = max(cw, mntw)
            # th = max(ch, mnth)
        return tw

    def get_rect(self, tile_idx, rect, tkinter_rect=True):
        r, c = self.i_to_r_c(tile_idx)
        calc_rect = Rect2(self.x_at_col(c, rect), self.y_at_row(r, rect), self.col_width(c, rect), self.row_height(r, rect))
        print(f"cr: {calc_rect}")
        if tkinter_rect:
            return rect2_to_tkinter(calc_rect)
        return calc_rect
        # x, y, w, h, a = rect
        # w -= 2 * self.border_width
        # h -= 2 * self.border_width
        # x += self.border_width
        # y += self.border_width
        # rows = self.rows
        # cols = self.cols
        # # cw = tw = w / cols
        # # ch = th = h / rows
        # r, c = self.i_to_r_c(tile_idx)
        # tw = self.col_width(c, rect)
        # th = self.row_height(r, rect)
        # # print(f"tile_idx: {tile_idx}, rc: ({r}, {c}), xy: ({x}, {y}), th: {th}, tw: {tw}")
        #
        # tile = self.tiles[tile_idx]
        # zoomed_rows = self.zoomed_rows()
        # zoomed_cols = self.zoomed_cols()
        #
        # # mntw = self.min_tile_w
        # # mnth = self.min_tile_h
        # mxtw = self.max_tile_w
        # mxth = self.max_tile_h
        #
        # # if zoomed_rows:
        # # rinzr = r in zoomed_rows
        # # cinzc = c in zoomed_cols
        # # if rinzr:
        # #     th = mxth
        # # if cinzc:
        # #     tw = mxtw
        # # if not (rinzr or cinzc):
        # #     tw = max(cw, mntw)
        # #     th = max(ch, mnth)
        #
        # if tile.zoomed:
        #     tile.colour = RED
        #
        # nzr = clamp(0, len(zoomed_rows), self.max_n_zoomed_rows)
        # nzc = clamp(0, len(zoomed_cols), self.max_n_zoomed_cols)
        # unc = len([i for i in range(self.cols) if i in zoomed_cols and i < c])
        # unr = len([i for i in range(self.rows) if i in zoomed_rows and i < r])
        # cnr = clamp(0, r - unr, self.rows)
        # cnc = clamp(0, c - unc, self.cols)
        # # cnc = len([i for i in range(self.cols) if i not in zoomed_cols and i < c])
        # # cnr = len([i for i in range(self.rows) if i not in zoomed_rows and i < r])
        # print(f"N: {tile.ser}, ZOOMED: {tile.zoomed}, zr: {zoomed_rows}, zc: {zoomed_cols}, nzr: {nzr}, nzc: {nzc}, unc: {unc}, unr: {unr}, cnc: {cnc}, cnr: {cnr}, r: {r}, c:{c}")
        #
        # # used_width = (unc * clamp(mntw, tw, mxtw)) + ((c - unc) * tw)
        # # used_height = (unr * clamp(mnth, th, mxth)) + ((r - unr) * th)
        #
        # # used_width = ((unc - 0) * mxtw) + ((c - unc) * tw) - (((unc + nzc) - cnc) * (mxtw - tw))
        # used_width = ((unc - 0) * mxtw) + ((c - unc) * tw) - ((unc - nzc) * (mxtw - tw))
        # used_height = ((unr - 0) * mxth) + ((r - unr) * th) - ((unr - nzr) * (mxth - th))
        #
        # if tkinter_rect:
        #     return Rect2(x + used_width, y + used_height, tw, th)
        # return tkinter_to_rect2(list(Rect2(x + used_width, y + used_height, tw, th))[:4])
        #
        #
        # # if tkinter_rect:
        # #     return Rect2(x + (c * tw), y + (r * th), tw, th)
        # # # print(f"XXXX: {Rect2(x + (c * tw), y + (r * th), tw, th).sq_rect()}")
        # # return tkinter_to_rect2(list(Rect2(x + (c * tw), y + (r * th), tw, th))[:4])

    def zoomed_rows(self):
        return [row for row in range(self.rows) if any([self.tiles[self.r_c_to_i(row, col)].zoomed for col in range(self.cols)])]

    def zoomed_cols(self):
        return [col for col in range(self.cols) if any([self.tiles[self.r_c_to_i(row, col)].zoomed for row in range(self.rows)])]

    def __repr__(self):
            # return "rect: {}, (r, c): ({}, {}), line: {}, date: {}".format(self.rect, self.row, self.col, self.line,
        #                                                                self.date)
        return "date: {}, line: {}".format(self.dates[0].strftime("%Y-%m-%d"), self.lines)

    dragging = property(get_dragging, set_dragging, del_dragging)
    selected = property(get_selected, set_selected, del_selected)
    hover_select = property(get_hover_select, set_hover_select, del_hover_select)
    dbl_clicked = property(get_dbl_select, set_dbl_select, del_dbl_select)
    swap_pair = property(get_swap_pair, set_swap_pair, del_swap_pair)
