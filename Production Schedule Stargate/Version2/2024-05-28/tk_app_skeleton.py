from tkinter_utility import *
from PIL import ImageTk, Image


class WorkStation:

    def __init__(self, name):
        self.name = name


class App(tkinter.Tk):

    def __init__(self):
        super().__init__()

        ########################
        #  Application title   #
        ########################
        self.tv_title_app_full = tkinter.StringVar(self, value="Demo Tkinter App")
        self.tv_title_app_short = tkinter.StringVar(self, value="Demo App")
        self.title(self.tv_title_app_full.get())

        ##############################
        #   Application dimensions   #
        ##############################
        self.calc_geometry = calc_geometry_tl("zoomed", largest=True, rtype=dict)  # full-screen application
        self.w_p_app, self.h_p_app = 2 / 3, 4 / 9
        # self.calc_geometry = calc_geometry_tl(self.w_p_app, self.h_p_app, largest=True, rtype=dict)  # dimensions above

        self.w_app, self.h_app = self.calc_geometry["width"], self.calc_geometry["height"]

        if (geo := self.calc_geometry["geometry"]) == "zoomed":
            self.state(geo)
        else:
            self.geometry(geo)

        #############################
        #   Begin widget creation   #
        #############################

        self.tv_lbl_demo, self.lbl_demo = label_factory(
            self,
            tv_label="Hello World!",
            kwargs_label={
                "bg": Colour("#CA98A3").hex_code,
                "fg": Colour("#5A090A").hex_code,
                "font": ("Arial", 30, "bold")
            }
        )

        # center the demo widget
        self.columnconfigure(0, weight=1)
        self.rowconfigure(0, weight=1)

        self.grid_widgets()

    def grid_widgets(self):
        r, c, rs, cs, ix, iy, x, y, s = grid_keys()
        self.lbl_demo.grid(**{r: 0, c: 0, s: "nsew"})


if __name__ == '__main__':
    app = App()
    app.mainloop()