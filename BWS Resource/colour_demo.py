import tkinter

from tkinter_utility import *


class App(tkinter.Tk):

    def __init__(self):
        super().__init__()

        self.colour = Colour("#FFFFFF")

        self.canvas = tkinter.Canvas(self)
        self.rect_colour = self.canvas.create_rectangle(
            20, 20, 170, 170, fill=self.colour.hex_code
        )

        self.frame_btn_controls = tkinter.Frame(self)
        self.tv_btn_random_colour, self.btn_random_colour = button_factory(
            self.frame_btn_controls,
            tv_btn="New Colour",
            command=self.click_new_colour
        )
        self.tv_btn_invert_colour, self.btn_invert_colour = button_factory(
            self.frame_btn_controls,
            tv_btn="Invert",
            command=self.click_invert_colour
        )
        self.tv_btn_darken_010, self.btn_darken_010 = button_factory(
            self.frame_btn_controls,
            tv_btn="10% Darker",
            command=lambda: self.click_darken_colour(by=0.1)
        )
        self.tv_btn_brighten_010, self.btn_brighten_010 = button_factory(
            self.frame_btn_controls,
            tv_btn="10% Brighter",
            command=lambda: self.click_brighten_colour(by=0.1)
        )

        self.frame_btn_controls.grid(row=0, column=0, rowspan=1, columnspan=1, sticky="nsew")
        self.btn_random_colour.grid(row=0, column=0, rowspan=1, columnspan=1, sticky="nsew")
        self.btn_invert_colour.grid(row=1, column=0, rowspan=1, columnspan=1, sticky="nsew")
        self.btn_darken_010.grid(row=2, column=0, rowspan=1, columnspan=1, sticky="nsew")
        self.btn_brighten_010.grid(row=3, column=0, rowspan=1, columnspan=1, sticky="nsew")
        self.canvas.grid(row=0, column=1, rowspan=1, columnspan=1, sticky="nsew")

    def click_darken_colour(self, by=0.25):
        self.apply_colour(self.colour.darken(by))

    def click_brighten_colour(self, by=0.25):
        self.apply_colour(self.colour.brighten(by))

    def click_invert_colour(self, *args):
        self.apply_colour(self.colour.inverse())

    def click_new_colour(self, *args):
        self.apply_colour(Colour(random_colour(rgb=False)))

    def apply_colour(self, colour: Colour):
        self.colour.hex_code = colour.hex_code
        self.canvas.itemconfigure(self.rect_colour, fill=self.colour.hex_code)


if __name__ == '__main__':
    app = App()
    app.mainloop()
