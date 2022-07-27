from tkinter import *
from tkinter import ttk


def selectmode_none():
    tv['selectmode']="none"

def selectmode_browse():
    tv['selectmode']="browse"

def selectmode_extended():
    tv['selectmode']="extended"


if __name__ == "__main__":
    ws = Tk()

    tv = ttk.Treeview(
        ws,
        columns=(1, 2, 3),
        show='headings',
        height=8
        )
    tv.pack()

    tv.heading(1, text='roll number')
    tv.heading(2, text='name')
    tv.heading(3, text='class')

    tv.insert(parent='', index=0, iid=0, values=(21, "Krishna", 5))
    tv.insert(parent='', index=1, iid=1, values=(18, "Bhem", 3))
    tv.insert(parent='', index=2, iid=2, values=(12, "Golu", 6))
    tv.insert(parent='', index=3, iid=3, values=(6, "Priya", 3))


    b1 = Button(
        ws,
        text="Browse",
        pady=20,
        command=selectmode_browse
        )
    b1.pack(side=LEFT, fill=X, expand=True)


    b2 = Button(
        ws,
        text="None",
        pady=20,
        command=selectmode_none
        )
    b2.pack(side=LEFT, fill=X, expand=True)


    b3 = Button(
        ws,
        text="Extended",
        pady=20,
        command=selectmode_extended
        )
    b3.pack(side=LEFT, fill=X, expand=True)

    style = ttk.Style()
    style.theme_use("default")
    style.map("Treeview")

    ws.mainloop()