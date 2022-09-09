import datetime

from scheduler_app import App

if __name__ == '__main__':
    App(start_date_in=datetime.datetime(2022, 1, 1)).mainloop()
