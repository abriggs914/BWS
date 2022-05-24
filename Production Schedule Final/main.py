from pscframe import *
import datetime

# TODO 2022-05-10 Fix dealer colour highlighter only on top and left of tiles.
# TODO 2022-05-10 Fix dealer colour highlighter 2 & 3.
# TODO 2022-05-12 Add Quote# and serial number to tilecontrol notebook tabs.
# TODO 2022-05-12 param HIGHLIGHT_EDITED_TILES does not currently work.
# TODO 2022-05-16 Available quotes list is Hardcoded

# TODO 2022-05-16 Fixed Shifting units to the right.
# TODO 2022-05-18 Highlight the other units that match WOs in circles
# TODO 2022-05-18 Created a loop to ensure units with matching WOs show the correct dates. (GNK missing from this funtionality)
# TODO 2022-05-18 Fix the cell spacing to get borders on all 4 sides rather than top and left only
# TODO 2022-05-18 Need to fix the undo functions.
# TODO 2022-05-18 Added GNK Date to tile control notebook
# TODO 2022-05-24 Working on PSCalendar2.undo
# TODO 2022-05-24 Delete tiles
# TODO 2022-05-24 General line shifting options. Need to support moving backwards

import calendar

if __name__ == "__main__":
    pscf = PSCCalendarFrame(width_p=1500, height_p=600, title_p="Production Schedule Editor", max_tile_w=200, max_tile_h=200, max_n_zoomed_cols=1, max_n_zoomed_rows=1, max_n_selected=1, border_width=1.5, HIGHLIGHT_EDITED_TILES=True, EDITED_HIGHLIGHT_PROPORTION=0.18)
    # pscf = PSCCalendarFrame(width_p=1200, height_p=450, title_p="Production Schedule Editor", max_tile_w=200, max_tile_h=200, max_n_zoomed_cols=1, max_n_zoomed_rows=1, max_n_selected=1, border_width=3, HIGHLIGHT_EDITED_TILES=True)

    try:
        pscf.open(datetime.datetime.strptime("2022-05-01", "%Y-%m-%d"), n_cals=None)
    except KeyboardInterrupt as ki:
        # print(f"Caught KeyboardInterrupt: {ki}")
        pass

    print("Calendar Logs:")
    calendars = pscf.get_calendars()
    with open("psc_session_log.txt", "a") as f:
        f.write(f"\n-- {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')} --")
        for i, cal in enumerate(calendars):
            print(dict_print(cal.LOG, f"Calendar Log #{i}  " + "({} -> {})".format(*cal.date_range())))
            f.write(dict_print(cal.LOG, f"Calendar Log #{i}  " + "({} -> {})".format(*cal.date_range())))
