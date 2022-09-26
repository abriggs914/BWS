import datetime

import tkinter
from tkinter import colorchooser
from colour_utility import Colour
from grid_manager import GridManager
from tkinter_utility import combo_factory, button_factory


class ColourWidget(tkinter.Frame):

    def __init__(
            self,
            master,
            dealers=None,
            colours=None,
            default_colour=f"000000",
            do_d_sort=True,
            do_c_sort=True,
            colour_background=Colour(185, 185, 185).hex_code,
            colour_button_background=Colour(216, 216, 216).hex_code,
            label_ipadx=5,
            label_ipady=5,
            combo_ipadx=5,
            combo_ipady=5,
            button_ipadx=5,
            button_ipady=5
    ):
        super(ColourWidget, self).__init__(master)

        self.colour_background = colour_background
        self.colour_button_background = colour_button_background
        self.label_ipadx = label_ipadx
        self.label_ipady = label_ipady
        self.combo_ipadx = combo_ipadx
        self.combo_ipady = combo_ipady
        self.button_ipadx = button_ipadx
        self.button_ipady = button_ipady

        def_dealers = ["A", "B", "C"]
        def_colours = ["red", "blue", "green", "custom", "none"]

        self.status_code = tkinter.StringVar(self, value="")
        # self.status_code.trace_variable("w", self.variable_update)
        self.do_d_sort = do_d_sort
        self.do_c_sort = do_c_sort
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

        self.tv_lbl1, self.lbl1, self.tv_cb1, self.cb1 = combo_factory(self.f1, tv_label="Dealers", kwargs_label={"background": self.colour_background}, kwargs_combo={"values": self.dealers, "state": "readonly", "width":75})
        self.tv_lbl2, self.lbl2, self.tv_cb2, self.cb2 = combo_factory(self.f1, tv_label="Colours", kwargs_label={"background": self.colour_background}, kwargs_combo={"values": self.colours, "state": "readonly", "width":75})
        self.tv_btn1, self.btn1 = button_factory(self.f2, tv_btn="reset", kwargs_btn={"command": self.click_clear_all, "background": self.colour_button_background})
        self.tv_btn2, self.btn2 = button_factory(self.f2, tv_btn="clear", kwargs_btn={"command": self.click_clear_fields, "background": self.colour_button_background})

        self.tv_cb1.trace_variable("w", self.new_dealer)
        self.tv_cb2.trace_variable("w", self.new_colour)

        self.grid_manager = GridManager()
        self.grid_manager.grid_widgets(
            [
                [
                    {
                        "widget": self.lbl1,
                        "ipadx": self.label_ipadx,
                        "ipady": self.label_ipady
                    },
                    {
                        "widget": self.cb1,
                        "ipadx": self.combo_ipadx,
                        "ipady": self.combo_ipady
                    }
                ],
                [
                    {
                        "widget": self.lbl2,
                        "ipadx": self.label_ipadx,
                        "ipady": self.label_ipady
                    },
                    {
                        "widget": self.cb2,
                        "ipadx": self.combo_ipadx,
                        "ipady": self.combo_ipady
                    }
                ],
                [
                    {
                        "widget": self.btn2,
                        "ipadx": self.button_ipadx,
                        "ipady": self.button_ipady
                    },
                    {
                        "widget": self.btn1,
                        "ipadx": self.button_ipadx,
                        "ipady": self.button_ipady
                    }
                ]
            ]
        )
        self.f1.grid()
        self.f2.grid()
        self.grid(ipadx=10, ipady=10)

        self.configure(background=self.colour_background)

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
        self.status_code.set(f"{{'dealer': '{dealer.upper()}', 'colour': '{colour.upper()}'}}")

    def new_dealer(self, var_name, index, mode):
        d, c = self.dealer_colour()
        if c:
            self.tv_cb2.set("")
        if d:
            state = self.status[d]
            if state and state != "none":
                self.cb2.set(state)

    def new_colour(self, var_name, index, mode):
        d, c = self.dealer_colour()
        if c and d and self.status[d] != c:
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
            if self.do_c_sort:
                lst.sort()
            self.cb2.config(values=lst)

    def colour_choose(self, default=None):
        default = self.default_colour if default is None else self.default_colour
        rgb_code, colour_code = colorchooser.askcolor(title="Choose color")
        if colour_code is None:
            return default
        return colour_code

    def variable_update(self):
        d, c = self.dealer_colour()
        self.status_code.set("")


if __name__ == '__main__':

    WIN = tkinter.Tk()
    WIN.geometry(f"500x500")
    WIN.title("Select Start Date")
    cw = ColourWidget(WIN)
    WIN.mainloop()