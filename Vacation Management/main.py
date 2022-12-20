from calendar_surfaces import *


if __name__ == '__main__':

    window = tkinter.Tk()
    W, H = 900, 750
    window.geometry(f"{W}x{H}")
    window.title("Vacation Management")

    annual = AnnualFrameCalendar(window)

    window.mainloop()
