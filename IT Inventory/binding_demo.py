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

    win.mainloop()

