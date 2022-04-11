from pscframe import *
import calendar
import datetime

if __name__ == "__main__":
    pscf = PSCCalendarFrame(800, 550, "This is a title")
    pscf.open(datetime.datetime.strptime("2022-03-01", "%Y-%m-%d"), 6)
