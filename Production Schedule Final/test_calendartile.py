from pscalendar import *

ct = CalendarTile2(0, 0, 0, "Line1", dt.datetime(2022, 5, 10, 15, 13, 0), (0, 255, 0), (0, 0, 0), (255, 20, 20),
                   (0, 15, 115), (90, 90, 90), (255, 15, 78), DO_COPY=True)
print(f"A: {ct.is_edited()}")
ct.set_data("10014545", "model", "dealer", "status", "beam", dt.datetime(2022, 8, 8, 12, 15, 45), "serial", "quote")
print(f"B: {ct.is_edited()}")
ct2 = ct.__copy__()
print(f"C: {ct2.is_edited()}")
