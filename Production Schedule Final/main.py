from pscframe import *
import datetime
import calendar

if __name__ == "__main__":
    # pscf = PSCCalendarFrame(width_p=1500, height_p=600, title_p="This is a title", max_tile_w=200, max_tile_h=200, max_n_zoomed_cols=1, max_n_zoomed_rows=1, max_n_selected=1)
    pscf = PSCCalendarFrame(width_p=1200, height_p=450, title_p="This is a title", max_tile_w=200, max_tile_h=200, max_n_zoomed_cols=1, max_n_zoomed_rows=1, max_n_selected=1)
    pscf.open(datetime.datetime.strptime("2022-03-01", "%Y-%m-%d"), n_cals=1)
