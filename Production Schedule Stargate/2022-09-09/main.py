import datetime

import tkinter
from tkinter import ttk, colorchooser
from scheduler_app import App
from orbiting_date_picker import OrbitingDatePicker
from tkinter_utility import combo_factory, button_factory
from dataclasses import dataclass
from colour_utility import font_foreground, Colour


class ColourWidget(tkinter.Frame):

    def __init__(self, master, dealers=None, colours=None, default_colour=f"000000", do_d_sort=True, do_c_sort=True):
        super(ColourWidget, self).__init__(master)

        def_dealers = ["A", "B", "C"]
        def_colours = ["red", "blue", "green", "custom", "none"]

        self.f1 = tkinter.Frame(self)
        self.f2 = tkinter.Frame(self)
        self.default_colour = default_colour
        self.dealers = def_dealers if dealers is None else dealers
        self.colours = def_colours if colours is None else colours
        if do_d_sort:
            self.dealers.sort(key=lambda k: k if k else "none")
        if do_c_sort:
            self.colours.sort(key=lambda k: k if k else "none")

        self.status = {d: "none" for d in self.dealers}
        self.custom = {d: "none" for d in self.dealers}

        self.tv_lbl1, self.lbl1, self.tv_cb1, self.cb1 = combo_factory(self.f1, tv_label="Dealers", kwargs_combo={"values": self.dealers, "state": "readonly"})
        self.tv_lbl2, self.lbl2, self.tv_cb2, self.cb2 = combo_factory(self.f1, tv_label="Colours", kwargs_combo={"values": self.colours, "state": "readonly"})
        self.tv_btn1, self.btn1 = button_factory(self.f2, tv_btn="clear all", kwargs_btn={"command": self.click_clear_all})
        self.tv_btn2, self.btn2 = button_factory(self.f2, tv_btn="clear fields", kwargs_btn={"command": self.click_clear_fields})

        self.tv_cb1.trace_variable("w", self.new_dealer)
        self.tv_cb2.trace_variable("w", self.new_colour)

        self.lbl1.grid(row=1, column=1)
        self.lbl2.grid(row=2, column=1)
        self.cb1.grid(row=1, column=2)
        self.cb2.grid(row=2, column=2)
        self.btn2.grid(row=1, column=1)
        self.btn1.grid(row=1, column=2)
        self.f1.grid()
        self.f2.grid()
        self.pack()

    def dealer_colour(self):
        return self.tv_cb1.get(), self.tv_cb2.get()

    def click_clear_all(self):
        for d in self.dealers:
            self.update_status(d, None)
        self.click_clear_fields()

    def click_clear_fields(self):
        self.tv_cb1.set("")
        self.tv_cb2.set("")

    def update_status(self, dealer, colour):
        if colour == "none":
            colour = self.default_colour
        elif colour == "custom":
            colour = self.colour_choose()
        if colour is None:
            colour = self.default_colour
        self.status[dealer] = colour
        colour = Colour(colour).hex_code
        # print(f"colour_in {colour=}")
        # self.cb2.config(
        #     background=colour,
        #     #fieldbackground=colour,
        #     # selectbackground=colour,
        #     foreground=font_foreground(colour, rgb=False)
        # )
        # self.cb2.update()
        # print(f"{self.status=}")

    def new_dealer(self, var_name, index, mode):
        d, c = self.dealer_colour()
        if c:
            self.tv_cb2.set("")
        if d:
            state = self.status[d]
            # print(f"old {state=}")
            if state and state != "none":
                # self.add_colour(state)
                # print(f"BEFORE: {self.tv_cb2.get()=}, {self.cb2['values']=}")
                self.cb2.set(state)
                # print(f"After: {self.tv_cb2.get()=}, {self.cb2['values']=}")
                # if self.status[d] not in self.cb2["values"]:
                #     self.add_colour(self.status[d])
                # self.cb1.config(values=[*self.cb1["values"], self.status[d]])
        # elif d:
        #     if c not in ["custom", "none"]:
        #         print(f"Setting {d=} to {c=}")
        #     elif c == "custom":
        #         print(f"custom colour from dealer {d=}")
        #     else:
        #         print(f"removing colour from dealer {d=}")
        #     self.update_status(d, c)

    def new_colour(self, var_name, index, mode):
        d, c = self.dealer_colour()
        if c and d and self.status[d] != c:
            # if c not in ["custom", "none"]:
            #     print(f"Setting {d=} to {c=}")
            # elif c == "custom":
            #     print(f"custom colour from dealer {d=}")
            # else:
            #     print(f"removing colour from dealer {d=}")
            old_colour = self.status[d]
            self.remove_colour(c)
            self.add_colour(old_colour)
            self.cb1.focus()
            self.update_status(d, c)

    def remove_colour(self, colour):
        if colour not in ["custom", "none"]:
            lst = list(self.cb2["values"])
            lst.remove(colour)
            self.cb2.config(values=lst)

    def add_colour(self, colour):
        colour = "none" if colour is None else colour
        lst = list(self.cb2["values"])
        if colour not in lst:
            lst = [*lst, colour]
            lst.sort()
            self.cb2.config(values=lst)

    def colour_choose(self, default=None):
        default = self.default_colour if default is None else self.default_colour
        rgb_code, colour_code = colorchooser.askcolor(title="Choose color")
        if colour_code is None:
            return default
        return colour_code


if __name__ == '__main__':

    # WIN = tkinter.Tk()
    # WIN.geometry(f"500x500")
    # WIN.title("Select Start Date")
    # cw = ColourWidget(WIN)
    # WIN.mainloop()


    today = datetime.datetime.today()
    today = datetime.datetime(2022, 1, 1)
    # WIN = tkinter.Tk()
    # WIN.geometry(f"500x500")
    # WIN.title("Select Start Date")
    # odp = OrbitingDatePicker(WIN).grid()
    # WIN.mainloop()
    # today = odp.today
    App(start_date_in=today).mainloop()
