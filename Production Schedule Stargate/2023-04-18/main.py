import datetime
import sys
import os
import tkinter

from settings_initializer import SettingsWriter
from scheduler_app import App


SETTINGS_FILE = "./PDS_User_Settings.json"
PROD_DATE = datetime.datetime(2023, 4, 18, 11, 30)
PROGRAM_MODE = "LIVE"
# PROGRAM_MODE = "TEST"


# NOTE - Copy this into the desired script you want to restart.
def restart_program():
    """Restarts the current program.
    Note: this function does not return. Any cleanup action (like
    saving data) must be done before calling this function.
    https://stackoverflow.com/questions/41655618/restart-program-tkinter
    https://www.daniweb.com/programming/software-development/code/260268/restart-your-python-program"""
    python = sys.executable
    print(f"{python=}, {sys.argv=}")
    os.execl(python, python, * sys.argv)


def version_generator(inp=None):
    fmt = "%Y.%m.%d.%H%M"
    if PROGRAM_MODE == "LIVE":
        return PROD_DATE.strftime(fmt)
    if inp is None:
        return datetime.datetime.now().strftime(fmt)
    else:
        return inp.strftime(fmt)


def run_live():
    error = True
    while error:
        try:
            App(
                PROGRAM_MODE=PROGRAM_MODE,
                TITLE=f"Stargate Production Scheduler {version}",
                can_width_p=0.999,
                restart_handle=restart_program
            ).mainloop()
        except (
                ValueError,
                TypeError,
                tkinter.TclError,
                AttributeError,
                IndexError,
                KeyError
        ) as err:
            error = True
            print(f"{err=}")
        else:
            error = False


def error_test():
    App(
        PROGRAM_MODE=PROGRAM_MODE,
        TITLE=f"Stargate Production Scheduler {version}",
        can_width_p=0.999,
        restart_handle=restart_program
    ).mainloop()


# TODO fix broken line shifting. when the date is adjacent to the the edge of the calendar it skips a day
# TODO allow weekend placements

if __name__ == '__main__':

    if not os.path.isfile(SETTINGS_FILE):
        SettingsWriter().write()

    today = None
    # today = datetime.datetime.today()
    # today = datetime.datetime(2022, 1, 1)
    # today = datetime.datetime(2023, 1, 31, 13, 21)

    version = version_generator(today)

    if PROGRAM_MODE == "LIVE":
        run_live()
    else:
        error_test()

