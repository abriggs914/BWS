import datetime

from scheduler_app import App


# TODO fix broken undo function seems to work okay for single actions but when trying to undo several in a row it starts to break.

if __name__ == '__main__':

    today = datetime.datetime.today()
    today = datetime.datetime(2022, 1, 1)

    App(start_date_in=today).mainloop()
