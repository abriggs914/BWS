from pscframe import *
import calendar

if __name__ == "__main__":
    pscf = PSCCalendarFrame(600, 400, "This is a title", n_test_cals=2)
    pscf.do_splash("2022-03-01", 6)
    pscf.set_full_screen()
    pscf.run()


