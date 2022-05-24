

def calendar_tile_from_repr(repr):
    """Parse the repr of a CalendarTile2 object and return the ser."""
    try:
        return int(repr.split(" ser: ")[-1].replace(">", ""))
    except ValueError as ve:
        raise ValueError(ve)
    except TypeError as te:
        raise TypeError(te)
    except IndexError as ie:
        raise IndexError(ie)


class CalendarTile2:
    """Class representing a slot in production. Associated to a trailer line and Beam, GNK, and T line dates"""

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
        self._job_start = None
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

        self.date_data = None
        self.gnk_date = None
        self.beam_date = None
        self.prod_date = None

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

    def set_date_data(self, date_data):
        self.date_data = date_data
        # print(dict_print(date_data, "Date Data"))
        # if self.is_gnk():
        self.gnk_date = date_data["gnk"]
        # elif self.is_beam():
        self.beam_date = date_data["beam"]
        # else:
        self.prod_date = date_data["t"]

        self.job_start = date_data["t"] if date_data["t"] is not None else self.job_start
        self.beam = date_data["beam"] if date_data["beam"] is not None else self.beam

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
        self._job_start = value
        self._edited = True
        self._edited_lst["date"] = True

    def del_date(self):
        del self._date

    def get_job_start(self):
        return self._job_start

    def set_job_start(self, value):
        self._job_start = value
        self._date = value

    def del_job_start(self):
        del self._job_start

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
    job_start = property(get_job_start, set_job_start, del_job_start)
    edited = property(get_edited, set_edited, del_edited)