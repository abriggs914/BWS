from utility import flatten, dt, print_by_line, Rect2
import math


class CalendarTile2:

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

        self.colour = colour
        self.colour_border = colour_border
        self.colour_font = colour_font

        self.colour_selected = colour_selected
        self.colour_hovered = colour_hovered
        self.colour_dragging = colour_dragging

        self.selected = False
        self.hovered = False
        self.dbl_clicked = False

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

    def __init__(self, start_date, end_date, data, lines, dates, colour_tile, colour_border, colour_font, colour_selected, colour_hovered, colour_dragging, border_width, switch_week_divs, colour_weekend_div):
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

    def get_rect(self, tile_idx, rect):
        x, y, w, h, a = rect
        w -= 2 * self.border_width
        h -= 2 * self.border_width
        x += self.border_width
        y += self.border_width
        rows = self.rows
        cols = self.cols
        tw = w / cols
        th = h / rows
        r, c = self.i_to_r_c(tile_idx)
        print(f"tile_idx: {tile_idx}, rc: ({r}, {c}), xy: ({x}, {y}), th: {th}, tw: {tw}")
        return Rect2(x + (c * tw), y + (r * th), tw, th)

    def __repr__(self):
            # return "rect: {}, (r, c): ({}, {}), line: {}, date: {}".format(self.rect, self.row, self.col, self.line,
        #                                                                self.date)
        return "date: {}, line: {}".format(self.dates[0].strftime("%Y-%m-%d"), self.lines)

    dragging = property(get_dragging, set_dragging, del_dragging)
    selected = property(get_selected, set_selected, del_selected)
    hover_select = property(get_hover_select, set_hover_select, del_hover_select)
    dbl_clicked = property(get_dbl_select, set_dbl_select, del_dbl_select)
    swap_pair = property(get_swap_pair, set_swap_pair, del_swap_pair)
