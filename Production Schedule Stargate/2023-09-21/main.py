import datetime
import sys
import os
import tkinter
import traceback

from colour_utility import *
from settings_initializer import SettingsWriter
from scheduler_app import App
from tkinter import messagebox


SETTINGS_FILE = "./PDS_User_Settings.json"
SETTINGS_FILE_TEST = r"C:\Access\PDS_User_Settings.json"
PROD_DATE = datetime.datetime(2023, 8, 28, 15, 52)
PROGRAM_MODE = "LIVE"
# PROGRAM_MODE = "TEST"
# DARK_MODE = True
DARK_MODE = False
CAN_WIDTH_P = 0.9
CAN_HEIGHT_P = 0.85


# NOTE - Copy this into the desired script you want to restart.
def restart_program(hide_terminal=False):
    """Restarts the current program.
    Note: this function does not return. Any cleanup action (like
    saving data) must be done before calling this function.
    https://stackoverflow.com/questions/41655618/restart-program-tkinter
    https://www.daniweb.com/programming/software-development/code/260268/restart-your-python-program"""
    python = sys.executable
    if hide_terminal and (sys.platform.startswith('win') and ('pythonw.exe' in python.lower())):
        # Use pythonw if it was initially launched with pythonw on Windows
        python = python.replace('pythonw.exe', 'python.exe')
    print(f"{python=}, {sys.argv=}")
    os.execl(python, python, * sys.argv)


def version_generator(inp=None):
    fmt = "%Y.%m.%d.%H%M"
    t_suf = " - TEST"
    if PROGRAM_MODE == "LIVE":
        return PROD_DATE.strftime(fmt)
    if inp is None:
        return datetime.datetime.now().strftime(fmt) + t_suf
    else:
        return inp.strftime(fmt) + t_suf


def run_live():
    error = True
    while error:
        app = None
        try:
            app = App(
                SETTINGS_FILE=SETTINGS_FILE,
                PROGRAM_MODE=PROGRAM_MODE,
                TITLE=f"Stargate Production Scheduler {version}",
                can_width_p=CAN_WIDTH_P,
                can_height_p=CAN_HEIGHT_P,
                restart_handle=restart_program,
                dark_mode=DARK_MODE,
                colour_background_frame_top_bar=Colour(STARGATE_BLUE).hex_code
            )
            app.mainloop()
        except (
                ValueError,
                TypeError,
                tkinter.TclError,
                AttributeError,
                IndexError,
                KeyError
        ) as err:
            error = True
            m = ""
            if isinstance(app, App):
                m = "\nApp did not complete setup\n"
                messagebox.showerror(f"STG Prod Sched", m)
                error = app.setup_complete.get()
            print(f"\n{err=}, {m}{traceback.print_exc()=}")
        else:
            error = False


def error_test():
    App(
        SETTINGS_FILE=SETTINGS_FILE_TEST,
        PROGRAM_MODE=PROGRAM_MODE,
        TITLE=f"Stargate Production Scheduler {version}",
        can_width_p=CAN_WIDTH_P,
        can_height_p=CAN_HEIGHT_P,
        restart_handle=restart_program,
        dark_mode=DARK_MODE,
        colour_background_frame_top_bar=Colour(STARGATE_BLUE).hex_code
    ).mainloop()


# TODO fix broken line shifting. when the date is adjacent to the the edge of the calendar it skips a day
# TODO allow weekend placements

if __name__ == '__main__':

    sf = SETTINGS_FILE if not PROGRAM_MODE == "TEST" else SETTINGS_FILE_TEST
    print(f"{sf=}")
    if not os.path.isfile(sf):
        print(f"not os")
        SettingsWriter(output_file=sf).write()

    today = None
    # today = datetime.datetime.today()
    # today = datetime.datetime(2022, 1, 1)
    # today = datetime.datetime(2023, 1, 31, 13, 21)

    version = version_generator(today)

    if PROGRAM_MODE == "LIVE":
        run_live()
    else:
        error_test()

