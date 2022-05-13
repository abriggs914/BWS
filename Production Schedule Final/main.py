from pscframe import *
import datetime

# TODO 2022-05-10 Fix dealer colour highlighter only on top and left of tiles.
# TODO 2022-05-10 Fix dealer colour highlighter 2 & 3.
# TODO 2022-05-12 Add Quote# and serial number to tilecontrol notebook tabs.
# TODO 2022-05-12 param HIGHLIGHT_EDITED_TILES does not currently work.

import calendar

if __name__ == "__main__":
    pscf = PSCCalendarFrame(width_p=1500, height_p=600, title_p="Production Schedule Editor", max_tile_w=200, max_tile_h=200, max_n_zoomed_cols=1, max_n_zoomed_rows=1, max_n_selected=1, border_width=3, HIGHLIGHT_EDITED_TILES=True)
    # pscf = PSCCalendarFrame(width_p=1200, height_p=450, title_p="Production Schedule Editor", max_tile_w=200, max_tile_h=200, max_n_zoomed_cols=1, max_n_zoomed_rows=1, max_n_selected=1, border_width=3, HIGHLIGHT_EDITED_TILES=True)

    try:
        pscf.open(datetime.datetime.strptime("2022-05-01", "%Y-%m-%d"), n_cals=2)
    except KeyboardInterrupt as ki:
        # print(f"Caught KeyboardInterrupt: {ki}")
        pass

    print("Calendar Logs:")
    calendars = pscf.get_calendars()
    for i, cal in enumerate(calendars):
        print(dict_print(cal.LOG, f"Calendar Log #{i}"))
