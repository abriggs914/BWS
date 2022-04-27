from pscframe import *
import datetime
import calendar

if __name__ == "__main__":
    pscf = PSCCalendarFrame(1500, 550, "This is a title")
    # pscf = PSCCalendarFrame(1200, 450, "This is a title")
    pscf.open(datetime.datetime.strptime("2022-03-01", "%Y-%m-%d"), n_cals=1)
