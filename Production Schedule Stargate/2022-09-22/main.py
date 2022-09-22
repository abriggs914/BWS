import datetime
import sys
import os

from scheduler_app import App


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


# TODO fix broken undo function seems to work okay for single actions but when trying to undo several in a row it starts to break.

if __name__ == '__main__':

    today = datetime.datetime.today()
    today = datetime.datetime(2022, 1, 1)

    App(start_date_in=today, restart_handle=restart_program).mainloop()
