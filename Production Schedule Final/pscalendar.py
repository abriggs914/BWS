from utility import flatten, dt


class CalendarTile2:

    def __init__(self, ser, i, j, line, date):
        self.ser = ser
        self.i = i
        self.j = j
        self.line = line
        self.date = date


class PSCalendar2:

    def __init__(self, start_date, end_date, data, lines, dates):
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
        self.tiles = flatten([[CalendarTile2((i * self.cols) + j, i, j, line, date)
              for j, date in enumerate(self.dates)] for i, line in enumerate(self.lines)])

    def __repr__(self): \
            # return "rect: {}, (r, c): ({}, {}), line: {}, date: {}".format(self.rect, self.row, self.col, self.line,
        #                                                                self.date)
        return "date: {}, line: {}".format(self.dates[0].strftime("%Y-%m-%d"), self.lines)
