import datetime
import sys
import os

from settings_initializer import SettingsWriter
from scheduler_app import App


SETTINGS_FILE = "./PDS_User_Settings.json"


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


# TODO fix broken line shifting. when the date is adjacent to the the edge of the calendar it skips a day
# TODO allow weekend placements

if __name__ == '__main__':

    if not os.path.isfile(SETTINGS_FILE):
        SettingsWriter().write()

    # today = datetime.datetime.today()
    # today = datetime.datetime(2022, 1, 1)

    version = "2022.10.25.1116"

    App(
        TITLE=f"Stargate Production Scheduler {version}",
        can_width_p=0.999,
        restart_handle=restart_program
    ).mainloop()
