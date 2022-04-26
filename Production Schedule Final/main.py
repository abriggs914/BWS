from pscframe import *
import datetime
import calendar

if __name__ == "__main__":
    pscf = PSCCalendarFrame(1500, 850, "This is a title")
    pscf.open(datetime.datetime.strptime("2022-03-01", "%Y-%m-%d"), n_cals=1)
