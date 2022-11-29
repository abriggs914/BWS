import tkinter

from tkinter_utility import *




def root_return(*args):
    print(f"Root returned!")


def unbind_things(*args):
    win.unbind("<Return>")


def rebind_things(*args):
    win.bind("<Return>", root_return)


def enter_b2(*args):
    print(f"Enter B2!")


if __name__ == '__main__':


    win = tkinter.Tk()
    win.geometry(f"600x400")
    win.title("Binding Demo")

    win.bind("<Return>", root_return)
    a1, a2 = button_factory(win, tv_btn="unbind", kwargs_btn={"command": unbind_things})
    b1, b2 = button_factory(win, tv_btn="rebind", kwargs_btn={"command": rebind_things})

    a2.pack()
    b2.pack()

    b2.bind("<Enter>", enter_b2)

    namer = alpha_seq(3, prefix="nm_", numbers_instead=True)

    c1 = tkinter.StringVar(win, value="")
    c2 = tkinter.StringVar(win, value="")
    c3 = tkinter.IntVar(win, value=0)
    c4 = tkinter.StringVar(win, value="")
    c1.trace_variable("w", lambda *_: c2.set(c2.get() + "!"))
    c2.trace_variable("w", lambda *_: c3.set(c3.get() + 1))
    c3.trace_variable("w", lambda *_: c4.set(next(namer)))
    c4.trace_variable("w", lambda *_: print(f"{c4.get()=}"))

    d1, d2, d3, d4 = entry_factory(win, tv_label="entry:", tv_entry=c1)
    e1, e2, e3, e4 = entry_factory(win, tv_label="c1:", tv_entry=c1, kwargs_entry={"state": "disabled"})
    f1, f2, f3, f4 = entry_factory(win, tv_label="c2:", tv_entry=c2, kwargs_entry={"state": "disabled"})
    g1, g2, g3, g4 = entry_factory(win, tv_label="c3:", tv_entry=c3, kwargs_entry={"state": "disabled"})
    h1, h2, h3, h4 = entry_factory(win, tv_label="c4:", tv_entry=c4, kwargs_entry={"state": "disabled"})

    for i in range(ord("d"), ord("h") + 1):
        eval(f"{chr(i)}2.pack()")
        eval(f"{chr(i)}4.pack()")

    win.mainloop()

