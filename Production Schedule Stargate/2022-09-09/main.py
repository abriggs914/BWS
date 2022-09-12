import datetime

import tkinter
from scheduler_app import App
from orbiting_date_picker import OrbitingDatePicker

if __name__ == '__main__':
    today = datetime.datetime.today()
    today = datetime.datetime(2022, 1, 1)
    # WIN = tkinter.Tk()
    # WIN.geometry(f"500x500")
    # WIN.title("Select Start Date")
    # odp = OrbitingDatePicker(WIN).grid()
    # WIN.mainloop()
    # today = odp.today
    App(start_date_in=today).mainloop()
