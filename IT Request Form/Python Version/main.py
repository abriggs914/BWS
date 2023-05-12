from tkinter_utility import *
from tkinter import ttk


def grid_keys():
    return "row", "column", "rowspan", "columnspan", "ipadx", "ipady", "padx", "pady", "sticky"


class ReqFrame(tkinter.Frame):

    def __init__(self, master, auto_grid=False, width=900, height=600):
        super().__init__(master, width=width, height=height)

        self.width_height = width, height
        self.auto_grid = auto_grid

        self.def_data = {
            ".__req_name": "REQID#"
        }

        self.frame_top = tkinter.Frame(self)
        self.tv_label_req_name,\
            self.label_req_name =\
            label_factory(
                self.frame_top,
                tv_label=self.def_data[".__req_name"]
            )

        r, c, rs, cs, ix, iy, px, py, s = grid_keys()
        self.grid_args = {
            "frame_top": {r: 0, c: 0, cs: 1, rs: 1},

            # frame_top
            "label_req_name": {r: 0, c: 0, cs: 1, rs: 1}
        }

        if isinstance(auto_grid, bool) and auto_grid:
            self.auto_grid_widgets()
            self.grid_widgets()

    def parse_auto_grid(self):
        ag = self.auto_grid
        off = 0 if isinstance(ag, bool) else ag
        return (off, 0) if isinstance(off, int) else off

    def auto_grid_widgets(self):
        off_r, off_c = self.parse_auto_grid()
        r, c, rs, cs, ix, iy, x, y, s = grid_keys()

        self.grid_args.update({
            ".": {r: off_r, c: off_c, cs: 1, rs: 1}
        })

    def grid_widgets(self):

        for k, args in self.grid_args.items():
            if k == ".":
                eval(f"self.grid(**{args})")
            else:
                eval(f"self.{k}.grid(**{args})")


class ReqInput(ReqFrame):

    def __init__(self, master, auto_grid=False):
        super().__init__(master, auto_grid=auto_grid)

        self.def_data.update({
            "0__req_name": "New Request"
        })

        self.tv_label_req_name.set(self.def_data["0__req_name"])
        self.configure(background=random_colour(rgb=False))


class ReqEdit(ReqFrame):

    def __init__(self, master, auto_grid=False):
        super().__init__(master, auto_grid=auto_grid)

        self.def_data.update({
            "1__req_name": "REQID#"
        })

        self.tv_label_req_name.set(self.def_data["1__req_name"])
        self.configure(background=random_colour(rgb=False))


# from ttkwidgets import
class App(tkinter.Tk):

    def __init__(self):
        super().__init__()

        self.style = ttk.Style()
        self.style.configure("Custom.TNotebook.Tab", minwidth=300, maxwidth=500)

        self.nbk_control = ttk.Notebook(self, style="Custom.TNotebook")
        self.nbk_control_tab_texts = ["New", "Edit"]


        r, c, rs, cs, ix, iy, px, py, s = grid_keys()
        self.grid_args = {
            "nbk_control": {r: 0, c: 0, cs: 1, rs: 1}
        }
        self.frame_tab_0 = ReqInput(self.nbk_control)
        self.frame_tab_1 = ReqEdit(self.nbk_control)

        self.tabs = [
            (self.frame_tab_0, self.nbk_control_tab_texts[0]),
            (self.frame_tab_1, self.nbk_control_tab_texts[1])
        ]

        for tab, text in self.tabs:
            self.nbk_control.add(tab, text=text)

        self.grid_widgets()

        self.state("zoomed")

    def grid_widgets(self):
        for k, args in self.grid_args.items():
            eval(f"self.{k}.grid(**{args})")

        for tab, text in self.tabs:
            tab.grid_widgets()


if __name__ == '__main__':
    app = App()
    app.mainloop()
