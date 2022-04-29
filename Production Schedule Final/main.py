from pscframe import *
import datetime
import calendar

if __name__ == "__main__":
    pscf = PSCCalendarFrame(1500, 600, "This is a title", max_tile_w=200, max_tile_h=200, max_n_zoomed_cols=1, max_n_zoomed_rows=1)
    # pscf = PSCCalendarFrame(1200, 450, "This is a title")
    pscf.open(datetime.datetime.strptime("2022-03-01", "%Y-%m-%d"), n_cals=1)
