from utility import flatten, dt, print_by_line, Rect2, clamp, tkinter_to_rect2, rect2_to_tkinter, dict_print
from colour_utility import *
import math


class CalendarTile2:
    """Class representing a slot in production. Associated to a trailer line and a date"""

    def __init__(self, ser, i, j, line, date, colour, colour_border, colour_font, colour_selected, colour_hovered, colour_dragging, DO_COPY=False):
        self._ser = ser
        self._i = i
        self._j = j
        self._line = line
        self._date = date

        self._wo_num = None
        self.model_name = None
        self.dealer = None
        self.status = None
        self.beam = None
        self.job_start = None
        self.serial = None
        self.quote = None
        self.text = ""

        # use RGB values and tuples. will be converted to hex via rgb_to_hex()
        self.colour = colour
        self.colour_border = colour_border
        self.og_colour_border = colour_border
        self.colour_font = colour_font

        self.colour_selected = colour_selected
        self.colour_hovered = colour_hovered
        self.colour_dragging = colour_dragging

        self.drag_x = 0
        self.drag_y = 0

        self.selected = False
        self.dragging = False
        self.hovered = False
        self.dbl_clicked = False
        self.zoomed = False
        self._edited = False

        self._edited_lst = {
            "wo_num": False,
            "ser": False,
            "i": False,
            "j": False,
            "line": False,
            "date": False
        }

        if DO_COPY:
            self.OG = self.__copy__()
            self.OG.set_data(*self.get_data())
            self.OG.edited = False
            assert not self.is_edited(), f"self should not be edited: {self}"
        else:
            self.OG = None

        # Finally set edited back to False to begin recording
        self.edited = False

    def set_data(self, wo, model_name, dealer, status, beam, job_start, serial, quote, edit=True):
        self.wo_num = wo
        self.model_name = model_name
        self.dealer = dealer
        self.status = status
        self.beam = beam
        self.job_start = job_start
        self.serial = serial
        self.quote = quote
        self.text = "{}\n{}\n{}\n{}\n{}\n{}\n{}\n{}".format(wo, model_name, dealer, status, beam, job_start, serial, quote)
        if not edit:
            self.edited = False

    def get_data(self):
        return self.wo_num, self.model_name, self.dealer, self.status, self.beam, self.job_start, self.serial, self.quote

    def is_beam(self):
        return self.line[0] == "B"

    def is_gnk(self):
        return self.line[:3] == "GNK"

    def is_t(self):
        return self.line[0] == "T"

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
            "colour_border",
            "colour_font",
            "text",
            "wo_num",
            "model_name",
            "dealer",
            "status",
            "beam",
            "job_start",
            "serial",
            "quote"

        # self.colour_selected = colour_selected
        # self.colour_hovered = colour_hovered
        # self.colour_dragging = colour_dragging
        #
        # self.drag_x = 0
        # self.drag_y = 0
        #
        # self.selected = False
        # self.dragging = False
        # self.hovered = False
        # self.dbl_clicked = False
        # self.zoomed = False
        ],
        [
            self.i,
            self.j,
            self.line,
            self.date,
            self.colour,
            self.colour_border,
            self.colour_font,
            self.text,
            self.wo_num,
            self.model_name,
            self.dealer,
            self.status,
            self.beam,
            self.job_start,
            self.serial,
            self.quote
        ]))

    def is_empty(self):
        return self.wo_num is None

    def is_edited(self):
        # print(f"COMP {self} vs {self.OG}")
        assert self.OG is not None, f"self.OG is None, tile: {self}"
        return self != self.OG or self.edited

    def same_tile(self, other):
        """Return whether a tile has the same wo_num but is not the same exact tile."""
        return isinstance(other, CalendarTile2) and all([
            self == other,
            self.ser != other.ser
        ])

    def __copy__(self):
        # ct = CalendarTile2(self.param_rect, self.border_width, self.row, self.col, self.line, self.date, self.colour,
        #                   self.outline, self.text)
        ct = CalendarTile2(self.ser, self.i, self.j, self.line, self.date, self.colour, self.colour_border, self.colour_font, self.colour_selected, self.colour_hovered, self.colour_dragging, DO_COPY=False)
        ct.set_data(*self.get_data())
        ct.edited = False
        ct.OG = CalendarTile2(self.ser, self.i, self.j, self.line, self.date, self.colour, self.colour_border, self.colour_font, self.colour_selected, self.colour_hovered, self.colour_dragging, DO_COPY=False)
        ct.OG.set_data(*self.get_data())
        ct.OG.edited = False
        # print(f"\t\t{ct}")
        return ct

    def __eq__(self, other):
        return isinstance(other, CalendarTile2) and self.wo_num == other.wo_num

    def __repr__(self):
        return f"<CT WO={'' if self.is_empty() else self.wo_num}, line: {self.line}, date: {self.date}, ({self.i}, {self.j}), ser: {self.ser}>"

    def get_wo_num(self):
        return self._wo_num

    def set_wo_num(self, value):
        self._wo_num = value
        self.edited = True
        self._edited_lst["wo_num"] = True

    def del_wo_num(self):
        del self._wo_num

    def get_ser(self):
        return self._ser

    def set_ser(self, value):
        self._ser = value
        self.edited = True
        self._edited_lst["ser"] = True

    def del_ser(self):
        del self._ser

    def get_i(self):
        return self._i

    def set_i(self, value):
        self._i = value
        self.edited = True
        self._edited_lst["i"] = True

    def del_i(self):
        del self._i

    def get_j(self):
        return self._j

    def set_j(self, value):
        self._j = value
        self.edited = True
        self._edited_lst["j"] = True

    def del_j(self):
        del self._j

    def get_line(self):
        return self._line

    def set_line(self, value):
        self._line = value
        self.edited = True
        self._edited_lst["line"] = True

    def del_line(self):
        del self._line

    def get_date(self):
        return self._date

    def set_date(self, value):
        self._date = value
        self._edited = True
        self._edited_lst["date"] = True

    def del_date(self):
        del self._date

    def get_edited(self):
        return any(self._edited_lst.values())

    def set_edited(self, value):
        self._edited = value
        if not value:
            self._edited_lst = {
            "wo_num": False,
            "ser": False,
            "i": False,
            "j": False,
            "line": False,
            "date": False
        }
        # if value:
        #     raise ValueError(f"SETTING EDITED=TRUE, {self}")

    def del_edited(self):
        del self._edited

    wo_num = property(get_wo_num, set_wo_num, del_wo_num)
    ser = property(get_ser, set_ser, del_ser)
    i = property(get_i, set_i, del_i)
    j = property(get_j, set_j, del_j)
    line = property(get_line, set_line, del_line)
    date = property(get_date, set_date, del_date)
    edited = property(get_edited, set_edited, del_edited)


class PSCalendar2:

    class CalendarException(Exception):
        def __init__(self, message):
            pass

    def __init__(self, start_date, end_date, data, lines, dates, colour_tile, colour_border, colour_font, colour_selected, colour_hovered, colour_dragging, border_width, switch_week_divs, colour_weekend_div, colour_beam_line_tile, colour_t_line_tile, colour_gnk_line_tile, max_n_zoomed_rows=2, max_n_zoomed_cols=2, min_tile_w=30, min_tile_h=15, max_tile_w=100, max_tile_h=50, max_n_selected=1, max_log_size=1000000, highlight_last_swapped=True):
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
        self.colour_tile_general = colour_tile
        self.colour_beam_line_tile = colour_beam_line_tile
        self.colour_t_line_tile = colour_t_line_tile
        self.colour_gnk_line_tile = colour_gnk_line_tile
        self.max_n_selected = max_n_selected
        self.max_n_zoomed_rows = max_n_zoomed_rows
        self.max_n_zoomed_cols = max_n_zoomed_cols
        self.max_log_size = max_log_size
        self.highlight_last_swapped = highlight_last_swapped
        self.zoomed_tile_status = {"row": {"set": set(), "ord": []}, "col": {"set": set(), "ord": []}}

        self.min_tile_w = min_tile_w
        self.min_tile_h = min_tile_h
        self.max_tile_w = max_tile_w
        self.max_tile_h = max_tile_h

        self._dragging = []
        self._selected = []
        self._hover_select = []
        self._dbl_clicked = []
        self._swap_pair = []

        # Create tiles
        self.colour = self.colour_tile_general
        self.colour_border = colour_border
        self.colour_font = colour_font
        self.colour_selected = colour_selected
        self.colour_hovered = colour_hovered
        self.colour_dragging = colour_dragging
        self.tiles = flatten([[CalendarTile2((i * self.cols) + j, i, j, line, date, self.colour, self.colour_border, self.colour_font, self.colour_selected, self.colour_hovered, self.colour_dragging, DO_COPY=True)
              for j, date in enumerate(self.dates)] for i, line in enumerate(self.lines)])

        for i, tile in enumerate(self.tiles):
            idxrc = (i // self.rows), (i % self.rows)
            # print("idxrc:", idxrc)
            idx = (idxrc[1] * self.rows) + idxrc[0]  # self.r_c_to_i(idxrc[1], idxrc[0])
            # idxrc = i // self.rows , (i % self.cols)
            # idx = (self.cols * (i // self.rows)) + (i % self.cols)
            idx = i
            # print("from i: {} to idx: {}, idxrc: {}".format(i, idx, idxrc))

            # recolour
            tile.colour = self.get_calendar_line_tile_colour(tile)

            data_row = data.iloc[idx:idx + 1, :]
            if data_row['InputField1'] is not None and data_row['InputField2'] is not None:
                lst = data_row['WO#'].tolist()
                if not lst:
                    continue
                wo = lst[0]
                # Uncommenting this print line causes the loading process to take ~ 10x longer - too many dataframe prints
                # print("data_row:", data_row, f"WO:<{wo}>")
                if not wo or math.isnan(wo):
                    continue
                wo = int(wo)
                model_name = data_row['InputField1'].tolist()[0]
                dealer = data_row['InputField2'].tolist()[0]
                status = data_row["Stock/Sold"].tolist()[0]
                beam = data_row["Beam WO#"].tolist()[0]
                job_start = data_row["JobStartDate"].tolist()[0]
                # TODO HARDCODED HERE
                serial = data_row["Serial"].tolist()[0]
                quote = int(data_row["Quote#"].tolist()[0])
                self.tiles[i].set_data(wo, model_name, dealer, status, beam, job_start, serial, quote, edit=False)
                self.tiles[i].OG.set_data(wo, model_name, dealer, status, beam, job_start, serial, quote, edit=False)
                # self.tiles[i].edited = False
                # self.tiles[i].OG.edited = False

        self.og_tiles = [tile.__copy__() for tile in self.tiles]
        self.dealers = tuple(set([tile.dealer for tile in self.tiles if tile.dealer is not None]))
        self.dealer_highlights = [None, None, None]
        print("tiles: ")
        print_by_line([t.info_dict() for t in self.tiles])
        print(f"data: {self.data}")
        print_by_line(self.data)

        self.LOG = {}
        self.log_ids = self.init_log_ids()

        # for tile in self.tiles:
        #     if tile.is_edited():
        #         print(dict_print(tile._edited_lst, f"Edited List {tile}"))
        #     assert not tile.is_edited(), f"ERROR tile: {tile} is edited after initialization!!"

    def r_c_to_i(self, r, c):
        return (r * self.cols) + c

    def i_to_r_c(self, i):
        return (i // self.cols), (i % self.cols)

    def x_y_to_r_c(self, x, y, rect):
        """Get the row and column indices for the tile located at x, y inside the binding rect. None, None if x, y cannot be mapped."""
        for i, tile in enumerate(self.tiles):
            r, c = self.i_to_r_c(i)
            rect_calc = self.get_rect(i, rect)
            # print(f"Arc: <{rect_calc}>, type({type(rect_calc)})")
            # rect_calc = list(rect_calc)[:4]
            # print(f"Brc: <{rect_calc}>, type({type(rect_calc)})")
            # x1, y1, x2, y2 = rect2_to_tkinter(rect_calc)
            x1, y1, x2, y2 = rect_calc
            bw = self.border_width
            if x1 - (2 * bw) <= x <= x2 + (2 * bw) and y1 - (2 * bw) <= y <= y2 + (2 * bw):
                return r, c

        print("Could not map x and y: ({}, {})".format(x, y))
        return None, None

    def tile_at_x_y(self, x, y, rect):
        """Get the tile object located at x, y inside the binding rect. None if x, y cannot be mapped."""
        r, c = self.x_y_to_r_c(x, y, rect)
        if r is not None:
            return self.tiles[self.r_c_to_i(r, c)]

    def delete(self, tile_in):
        self.log({
            "Deleting CalendarTile": {
                "tile": str(tile_in)
            }
        })
        ser = tile_in.ser
        i = tile_in.i
        j = tile_in.j
        line = tile_in.line
        date = tile_in.date
        colour = tile_in.colour
        colour_border = tile_in.colour_border
        colour_font = tile_in.colour_font
        colour_selected = tile_in.colour_selected
        colour_hovered = tile_in.colour_hovered
        colour_dragging = tile_in.dragging
        # self.swap_tiles(tile_in, CalendarTile2(ser, i, j, line, date, colour, colour_border, colour_font, colour_selected, colour_hovered, colour_dragging))
        self.tiles[ser] = CalendarTile2(ser, i, j, line, date, colour, colour_border, colour_font, colour_selected, colour_hovered, colour_dragging, DO_COPY=True)

    def insert(self, tile_in):
        print(f"insetting tile: {tile_in}")
        self.log({
            "Inserting CalendarTile": {
                "tile": str(tile_in)
            }
        })
        # line = tile_in.line
        # j = tile_in.j
        # i = self.lines.index(line)
        i = tile_in.i
        j = 0
        idx = self.r_c_to_i(i, j)
        self.tiles[idx] = tile_in
        tile_in.j = 0
        tile_in.ser = idx
        tile_in.date = self.dates[0]
        # tile = self.tiles[idx]
        # print(f"inserting tile_in\n\t{tile_in}\n=>\n\t{tile}\ninto:\n\t{self}\n@\n\t({i}, {j}) => {idx}")
        # return tile
        # if tile.is_empty():
        #     # place this tile here
        #     self.swap_tiles(tile, tile_in)
        # else:
        #     print(f"returning a tile!!! {tile}")
        #     return tile
            # pass
            # shift this line
            # self.swap_tiles(tile, tile_in)

    def swap_tiles(self, tile_a, tile_b):
        """Used to swap exactly 2 tiles in the tiles list."""

        self.log({"Swap CalendarTile": {
            "tile_a": str(tile_a),
            "tile_b": str(tile_b)
        }})
        self.swap_pair = (tile_a.__copy__(), tile_b.__copy__())

        assert isinstance(tile_a, CalendarTile2)
        assert isinstance(tile_b, CalendarTile2)
        options = {
            "T": lambda t: t.is_t(),
            "B": lambda t: t.is_beam(),
            "GNK": lambda t: t.is_gnk()
        }

        old_ser = tile_a.ser
        new_ser = tile_b.ser

        tile_a.ser, tile_b.ser = tile_b.ser, tile_a.ser
        tile_a.i, tile_b.i = tile_b.i, tile_a.i
        tile_a.j, tile_b.j = tile_b.j, tile_a.j
        tile_a.line, tile_b.line = tile_b.line, tile_a.line
        tile_a.date, tile_b.date = tile_b.date, tile_a.date

        # tile_a.selected, tile_b.selected = tile_b.selected, tile_a.selected
        # tile_a.dragging, tile_a.dragging = tile_a.dragging, tile_a.dragging
        # tile_a.hovered, tile_a.hovered = tile_a.hovered, tile_a.hovered
        # tile_a.dbl_clicked, tile_a.dbl_clicked = tile_a.dbl_clicked, tile_a.dbl_clicked
        # tile_a.zoomed, tile_a.zoomed = tile_a.zoomed, tile_a.zoomed
        self.tiles[old_ser], self.tiles[new_ser] = self.tiles[new_ser], self.tiles[old_ser]

        # recolour
        state_a = [k for k, v in options.items() if v(tile_a)][0]
        state_b = [k for k, v in options.items() if v(tile_b)][0]
        if state_a != state_b:
            # if the lines change, and BOTH of the tiles are empty, change the colours back.
            if tile_a.is_empty() and tile_b.is_empty():
                tile_a.colour = self.get_calendar_line_tile_colour(tile_a)
                tile_b.colour = self.get_calendar_line_tile_colour(tile_b)

    def get_calendar_line_tile_colour(self, tile):
        if tile.is_beam():
            bgc = self.colour_beam_line_tile
        elif tile.is_gnk():
            bgc = self.colour_gnk_line_tile
        elif tile.is_t():
            bgc = self.colour_t_line_tile
        else:
            bgc = self.colour_tile_general
        return bgc

    def get_dragging(self):
        # return [t for t in self.tiles if t.dragging]
        return [self.tiles[ti] for ti in self._dragging]

    def set_dragging(self, drag_idx):
        print(f"ADDING {drag_idx}, self._dragging: {self._dragging}")
        if isinstance(drag_idx, list) and not drag_idx:
            self._dragging = []
            return
        if drag_idx not in self._dragging:
            self._dragging.append(drag_idx)
        # self.tiles[drag_idx].dragging = True
        for i in range(len(self.tiles)):
            if i in self._dragging:
                self.tiles[i].dragging = True
            else:
                self.tiles[i].dragging = False

    def clear_dragging(self):
        print(f"CLEARING: self.dragging: {self.dragging}, self._dragging: {self._dragging}")
        for tile in self.tiles:
            tile.dragging = False
        self._dragging = []

    def del_dragging(self):
        del self._dragging

    def get_selected(self):
        return [t for t in self.tiles if t.selected]

    def set_selected(self, drag_idx):
        if isinstance(drag_idx, list) and not drag_idx:
            self._selected = []
            return
        if drag_idx not in self._selected:
            self._selected.append(drag_idx)
            self._selected = self._selected[-(self.max_n_selected):]
            for i in range(len(self.tiles)):
                if i in self._selected:
                    self.tiles[i].selected = True
                else:
                    self.tiles[i].selected = False
        else:
            self._selected.remove(drag_idx)
            self.tiles[drag_idx].selected = not self.tiles[drag_idx].selected

    def clear_selected(self):
        for ti in self._selected:
            tile = self.tiles[ti]
            tile.selected = False
        self._selected = []

    def del_selected(self):
        del self._selected

    def get_hover_select(self):
        return [t for t in self.tiles if t.hovered]

    def set_hover_select(self, drag_idx):
        self._hover_select.append(drag_idx)
        self.tiles[drag_idx].hovered = True

    def del_hover_select(self):
        del self._hover_select

    def get_dbl_select(self):
        return [t for t in self.tiles if t.dbl_clicked]

    def set_dbl_select(self, drag_idx):
        self._dbl_clicked.append(drag_idx)
        self.tiles[drag_idx].dbl_clicked = True

    def del_dbl_select(self):
        del self._dbl_clicked

    def get_swap_pair(self):
        # return [t for t in self.tiles if t.dbl_clicked]
        return self._swap_pair

    def set_swap_pair(self, pair):
        self._swap_pair = pair

    def del_swap_pair(self):
        del self._swap_pair

    def clear_zoom(self):
        self.set_zoom(tile_idx=None)

    def set_zoom(self, tile_idx):
        """Add tile to zoomed tiles list. Remove the max_n + 1th element (FIFO Queue) if already max_n rows or cols are zoomed."""
        # Use sets to determine if a col or row is already zoomed
        # Use lists to determine the order of zooming.
        if tile_idx and tile_idx not in self.zoomed_tile_status["row"]["set"]:
            self.zoomed_tile_status["row"]["set"].add(tile_idx)
            self.zoomed_tile_status["row"]["ord"].append(tile_idx)
        if tile_idx and tile_idx not in self.zoomed_tile_status["col"]["set"]:
            self.zoomed_tile_status["col"]["set"].add(tile_idx)
            self.zoomed_tile_status["col"]["ord"].append(tile_idx)
        for i in range(max(self.max_n_zoomed_cols, self.max_n_zoomed_rows)):
            if i < len(self.zoomed_tile_status["row"]["ord"]):
                self.tiles[self.zoomed_tile_status["row"]["ord"][i]].zoomed = False
            if i < len(self.zoomed_tile_status["col"]["ord"]):
                self.tiles[self.zoomed_tile_status["col"]["ord"][i]].zoomed = False
        # print(dict_print(self.zoomed_tile_status, "A"))

        # delete the max_n + 1th element from rows and cols.
        # Ensures that no more rows than self.max_n_zoomed_rows and no more cols are zoomed than self.max_n_zoomed_cols
        if len(self.zoomed_tile_status["row"]["ord"]) >= self.max_n_zoomed_rows:
            deleting = self.zoomed_tile_status["row"]["ord"][:-self.max_n_zoomed_rows]
            for d in deleting:
                self.zoomed_tile_status["row"]["set"].remove(d)
                self.zoomed_tile_status["row"]["ord"].remove(d)
        if len(self.zoomed_tile_status["col"]["ord"]) >= self.max_n_zoomed_cols:
            deleting = self.zoomed_tile_status["col"]["ord"][:-self.max_n_zoomed_cols]
            for d in deleting:
                self.zoomed_tile_status["col"]["set"].remove(d)
                self.zoomed_tile_status["col"]["ord"].remove(d)

        # set remaining hovered history to zoomed
        for i in range(max(self.max_n_zoomed_cols, self.max_n_zoomed_rows)):
            # print(f"i: {i}")
            if i < len(self.zoomed_tile_status["row"]["ord"]):
                self.tiles[self.zoomed_tile_status["row"]["ord"][i]].zoomed = True
                # print(f"zooming: {self.zoomed_tile_status['row']['ord'][i]}")
            if i < len(self.zoomed_tile_status["col"]["ord"]):
                self.tiles[self.zoomed_tile_status["col"]["ord"][i]].zoomed = True
                # print(f"zooming: {self.zoomed_tile_status['row']['ord'][i]}")
        # print(dict_print(self.zoomed_tile_status, "B"))

    def y_at_row(self, row, rect):

        x, y, w, h, a = rect
        rows = self.rows
        # zc = self.zoomed_cols()
        zr = self.zoomed_tile_status["row"]["ord"]
        lzr = len(zr)
        zoomed_rows = [ti for ti in zr if self.i_to_r_c(ti)[0] < row]
        # zoomed_cols = self.zoomed_tile_status["col"]["ord"]
        lzmr = len(zoomed_rows)
        rh = th = w / rows
        hd = self.max_tile_h - th
        # ch = th = (h - (lzr * hd)) / (rows - lzr)
        # used = (row * th) + (lzr * hd)
        # cw = tw = (w - (lzc * self.max_tile_w) - (2 * (cols - 1) * self.border_width)) / (cols - lzc)
        rh = th = (h - (lzmr * self.max_tile_h)) / (rows - lzr)
        # used = ((row - lzmr) * th) + (lzmr * self.max_tile_h)
        used = (self.max_tile_h * lzmr) + ((row - lzmr) * th) #+ (row * self.border_width)
        # print(f"used: {used}, row: {col}")
        # print(dict_print({1: {"x":x, "y":y, "w":w, "h":h, "a":a, "col:": col, "cols:": cols, "zc:": zc, "zoomed": zoomed_cols, "lzc:": lzc, "lzmc:": lzmc, "tw": tw, "used:": used}}, "x_at_col"))
        return y + used  # + (self.border_width / 2)

        # x, y, w, h, a = rect
        # rows = self.rows
        # zr = self.zoomed_rows()
        # lzr = len(zr)
        # zoomed_rows = [rw for rw in zr if rw < row]
        # lzmr = len(zoomed_rows)
        # ch = th = h / rows
        # hd = self.max_tile_h - th
        # # ch = th = (h - (lzr * hd)) / (rows - lzr)
        # # used = (row * th) + (lzr * hd)
        # ch = th = (h - (lzr * self.max_tile_h) - (2 * (rows - 1) * self.border_width)) / (rows - lzr)
        # # used = ((row - lzmr) * th) + (lzmr * self.max_tile_h)
        # used = (self.max_tile_h * lzmr) + (row * th) #+ (row * self.border_width)
        # # print(f"used: {used}, row: {row}")
        # return y + used + (self.border_width / 2)
        # # return sum([self.row_height(r, rect) for r in range(row)])
        # x, y, w, h, a = rect
        # rows = self.rows
        # zoomed_rows = [rw for rw in self.zoomed_rows() if rw < row]
        # lzr = len(zoomed_rows)
        # ch = th = h / (rows - lzr)
        # hd = self.max_tile_h - th
        # # ch = th = (h - (lzr * hd)) / (rows - lzr)
        # # used = (row * th) + (lzr * hd)
        # ch = th = (h - (lzr * hd)) / (rows - lzr)
        # used = ((row - lzr) * th) + (lzr * self.max_tile_h)
        # return y + used
        # # return sum([self.row_height(r, rect) for r in range(row)])

    # x, y, w, h, a = rect
    # rows = self.rows
    # zoomed_rows = [rw for rw in self.zoomed_rows() if rw < row]
    # lzr = len(zoomed_rows)
    # ch = th = h / (rows - lzr)
    # hd = self.max_tile_h - th
    # ch = th = (h - (lzr * hd)) / (rows - lzr)
    # used = (row * th) + (lzr * hd)
    # return y + used

    # return sum([self.row_height(r, rect) for r in range(row)])

    def x_at_col(self, col, rect):
        x, y, w, h, a = rect
        cols = self.cols
        # zc = self.zoomed_cols()
        zc = self.zoomed_tile_status["col"]["ord"]
        lzc = len(zc)
        zoomed_cols = [ti for ti in zc if self.i_to_r_c(ti)[1] < col]
        # zoomed_cols = self.zoomed_tile_status["col"]["ord"]
        lzmc = len(zoomed_cols)
        cw = tw = w / cols
        wd = self.max_tile_w - tw
        # ch = th = (h - (lzr * hd)) / (rows - lzr)
        # used = (row * th) + (lzr * hd)
        # cw = tw = (w - (lzc * self.max_tile_w) - (2 * (cols - 1) * self.border_width)) / (cols - lzc)
        cw = tw = (w - (lzmc * self.max_tile_w)) / (cols - lzc)
        # used = ((row - lzmr) * th) + (lzmr * self.max_tile_h)
        used = (self.max_tile_w * lzmc) + ((col - lzmc) * tw) #+ (row * self.border_width)
        # print(f"used: {used}, row: {col}")
        # print(dict_print({1: {"x":x, "y":y, "w":w, "h":h, "a":a, "col:": col, "cols:": cols, "zc:": zc, "zoomed": zoomed_cols, "lzc:": lzc, "lzmc:": lzmc, "tw": tw, "used:": used}}, "x_at_col"))
        return x + used  # + (self.border_width / 2)
        # x, y, w, h, a = rect
        # cols = self.cols
        # print(f"Azc: {self.zoomed_cols()}, c: {col}")
        # zoomed_cols = [cw for cw in self.zoomed_cols() if cw < col]
        # print(f"Bzc: {self.zoomed_cols()}")
        # cw = tw = w / cols
        # lzc = len(zoomed_cols)
        # wd = self.max_tile_w - tw
        # cw = tw = (w - (lzc * wd)) / cols
        # used = (col * tw) + (lzc * wd)
        # return x + used
        # # return sum([self.col_width(c, rect) for c in range(col)])

    def row_height(self, row, rect):
        return self.y_at_row(row + 1, rect) - self.y_at_row(row, rect)

        # x, y, w, h, a = rect
        # rows = self.rows
        # # zc = self.zoomed_cols()
        # zr = self.zoomed_tile_status["row"]["ord"]
        # lzr = len(zr)
        # zoomed_rows = [ti for ti in zr if self.i_to_r_c(ti)[0] < row]
        # # zoomed_cols = self.zoomed_tile_status["col"]["ord"]
        # lzmr = len(zoomed_rows)
        # rh = th = w / rows
        # hd = self.max_tile_h - th
        # # ch = th = (h - (lzr * hd)) / (rows - lzr)
        # # used = (row * th) + (lzr * hd)
        # # cw = tw = (w - (lzc * self.max_tile_w) - (2 * (cols - 1) * self.border_width)) / (cols - lzc)
        # rh = th = (h - (lzr * self.max_tile_h)) / (rows - lzr)
        # # used = ((row - lzmr) * th) + (lzmr * self.max_tile_h)
        #
        # # used = (self.max_tile_h * lzmr) + ((row - lzmr) * th) #+ (row * self.border_width)
        # # print(f"used: {used}, row: {col}")
        # # print(dict_print({1: {"x":x, "y":y, "w":w, "h":h, "a":a, "col:": col, "cols:": cols, "zc:": zc, "zoomed": zoomed_cols, "lzc:": lzc, "lzmc:": lzmc, "tw": tw, "used:": used}}, "x_at_col"))
        # # return y + used  # + (self.border_width / 2)
        # return self.max_tile_h if row in zr else th

        # return self.y_at_row(row + 1, rect) - self.y_at_row(row, rect)
        # x, y, w, h, a = rect
        # # w -= 2 * self.border_width
        # # h -= 2 * self.border_width
        # # x += self.border_width
        # # y += self.border_width
        # rows = self.rows
        # # cols = self.cols
        # # cw = tw = w / cols
        # ch = th = h / rows
        # r, c = row, 0
        # # tile_idx = self.r_c_to_i(r, c)
        # # print(f"tile_idx: {tile_idx}, rc: ({r}, {c}), xy: ({x}, {y}), th: {th}, tw: {tw}")
        #
        # # tile = self.tiles[tile_idx]
        # zoomed_rows = self.zoomed_rows()
        # lzr = len([rw for rw in self.zoomed_rows() if rw < row])
        # # zoomed_cols = self.zoomed_cols()
        #
        # # mntw = self.min_tile_w
        # mnth = self.min_tile_h
        # # mxtw = self.max_tile_w
        # mxth = self.max_tile_h
        #
        # if zoomed_rows:
        #     # nh = h - (len(zoomed_rows) * (mxth - th)) - (rows * self.border_width)
        #     nh = h - (lzr * (mxth - th))
        #     th = nh / rows
        # # rinzr =
        # # cinzc = c in zoomed_cols
        # if r in zoomed_rows:
        #     th = mxth
        #
        # # if cinzc:
        #     # tw = mxtw
        # # if not (rinzr or cinzc):
        # # if not rinzr:
        # #     # tw = max(cw, mntw)
        # #     th = max(ch, mnth)
        # #     th = ch
        # return th

    def col_width(self, col, rect):
        return self.x_at_col(col + 1, rect) - self.x_at_col(col, rect)
        # x, y, w, h, a = rect
        # w -= 2 * self.border_width
        # h -= 2 * self.border_width
        # x += self.border_width
        # y += self.border_width
        # # rows = self.rows
        # cols = self.cols
        # cw = tw = w / cols
        # # ch = th = h / rows
        # r, c = 0, col
        # # tile_idx = self.r_c_to_i(r, c)
        # # print(f"tile_idx: {tile_idx}, rc: ({r}, {c}), xy: ({x}, {y}), th: {th}, tw: {tw}")
        #
        # # tile = self.tiles[tile_idx]
        # # zoomed_rows = self.zoomed_rows()
        # zoomed_cols = self.zoomed_cols()
        #
        # mntw = self.min_tile_w
        # # mnth = self.min_tile_h
        # mxtw = self.max_tile_w
        # # mxth = self.max_tile_h
        #
        # # if zoomed_rows:
        # # rinzr = r in zoomed_rows
        # cinzc = c in zoomed_cols
        # # if rinzr:
        # #     th = mxth
        # if cinzc:
        #     tw = mxtw
        # # if not (rinzr or cinzc):
        # if not cinzc:
        #     tw = max(cw, mntw)
        #     # th = max(ch, mnth)
        # return tw

    def get_rect(self, tile_idx, rect, tkinter_rect=True):
        r, c = self.i_to_r_c(tile_idx)
        calc_rect = Rect2(self.x_at_col(c, rect), self.y_at_row(r, rect), self.col_width(c, rect), self.row_height(r, rect))
        # print(f"cr: {calc_rect}")
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

    # def set_always_highlight_dealer(self, val):
    #     self.always_highlight_dealers = True if val else False

    def unhighlight_dealer(self, idx=None):
        if idx is None:
            self.dealer_highlights = [None, None, None]
            return
        self.dealer_highlights[idx] = None

    def highlight_dealer(self, d_name, colour_code, idx, stock_colour=None):
        self.dealer_highlights[idx] = (d_name, colour_code, stock_colour)
        highlighted_dealers = [dh[0] for dh in self.dealer_highlights if dh]
        for i, tile in enumerate(self.tiles):
            dealer = tile.dealer
            if dealer == d_name:
                print(f"highlight tile: {i} from {tile.colour_border} to {colour_code}")
                tile.colour_border = colour_code
            elif dealer not in highlighted_dealers:
                tile.colour_border = tile.og_colour_border

    def date(self, date_idx, inc_y=True, inc_m=True, inc_d=True):
        fmt = ""
        if inc_y:
            fmt += "%Y"
        if inc_m:
            if fmt:
                fmt += "-"
            fmt += "%m"
        if inc_d:
            if fmt:
                fmt += "-"
            fmt += "%d"
        return self.dates[date_idx].strftime(fmt)

    def zoomed_rows(self):
        return [row for row in range(self.rows) if any([self.tiles[self.r_c_to_i(row, col)].zoomed for col in range(self.cols)])]

    def zoomed_cols(self):
        return [col for col in range(self.cols) if any([self.tiles[self.r_c_to_i(row, col)].zoomed for row in range(self.rows)])]

    def log(self, log_dat_in):
        self.LOG[self.new_log_id()] = log_dat_in

    def new_log_id(self):
        return self.log_ids.__next__()

    def init_log_ids(self):
        """Returns a generator to iterate hashable ids, ensuring no duplicates and ordering."""
        valid_ids = range(self.max_log_size)
        for i in valid_ids:
            yield f"{i}||{dt.datetime.now()}"

    def __repr__(self):
            # return "rect: {}, (r, c): ({}, {}), line: {}, date: {}".format(self.rect, self.row, self.col, self.line,
        #                                                                self.date)
        return "date: {} -> {}, line: {}".format(*self.date_range(), self.lines)

    def date_range(self):
        return self.dates[0].strftime("%Y-%m-%d"), self.dates[-1].strftime("%Y-%m-%d")

    dragging = property(get_dragging, set_dragging, del_dragging)
    selected = property(get_selected, set_selected, del_selected)
    hover_select = property(get_hover_select, set_hover_select, del_hover_select)
    dbl_clicked = property(get_dbl_select, set_dbl_select, del_dbl_select)
    swap_pair = property(get_swap_pair, set_swap_pair, del_swap_pair)
