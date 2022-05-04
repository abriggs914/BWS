from pscframe import *
import datetime
import calendar

if __name__ == "__main__":
    pscf = PSCCalendarFrame(width_p=1500, height_p=600, title_p="Production Schedule Editor", max_tile_w=200, max_tile_h=200, max_n_zoomed_cols=1, max_n_zoomed_rows=1, max_n_selected=1, border_width=3)
    # pscf = PSCCalendarFrame(width_p=1200, height_p=450, title_p="Production Schedule Editor", max_tile_w=200, max_tile_h=200, max_n_zoomed_cols=1, max_n_zoomed_rows=1, max_n_selected=1, border_width=3)
    pscf.open(datetime.datetime.strptime("2022-05-01", "%Y-%m-%d"), n_cals=10)
