from calendar import *
import tkinter


if __name__ == '__main__':
    print('PyCharm')

    # w = 700
    # h = 500
    # Inclusive start and end dates
    start_date = dt.datetime(2021, 11, 15)
    end_date = dt.datetime(2021, 12, 13)
    lines = [
        "GNK1",
        "GNK2",
        "TBF",
        "PBF",
        "B1",
        "B2",
        "B3",
        "B4",
        "TS1",
        "TS2",
        "TS3",
        "T1",
        "T2",
        "T3",
        "T4",
        "T5",
        "T6",
        "T7",
        "T8",
        "T9",
        "T10",
        "T11"
    ]

    print("I should see {} rows by {} cols".format(len(lines), (end_date - start_date).days))

    win_w, win_h = 1700, 900
    can_w, can_h = win_w * 0.98, win_h * 0.8
    window = tkinter.Tk()
    window.geometry("{}x{}".format(win_w, win_h))
    window.title("Production Schedule")

    calendar_frame = tkinter.Frame(window)
    canvas = tkinter.Canvas(calendar_frame, height=can_h, width=can_w, bg=rgb_to_hex(GRAY_12))
    print("GEOMETRY:", canvas.winfo_geometry())
    c = Calendar(canvas, can_w, can_h, start_date, end_date, lines)

    label_title = tkinter.Label(window, text="Production Schedule\n{} - {}".format(dt.datetime.strftime(start_date, "%Y-%m-%d"), dt.datetime.strftime(end_date, "%Y-%m-%d")))

    label_title.pack()
    canvas.pack()
    calendar_frame.pack()
    window.mainloop()
