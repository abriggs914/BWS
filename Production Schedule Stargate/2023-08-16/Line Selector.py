import tkinter

from tkinter_utility import *


class LineSelector(tkinter.Frame):

    def __init__(self, master, lines_in, auto_grid=True):
        super().__init__(master)

        self.auto_grid = auto_grid
        self.frame_buttons = tkinter.Frame(self)
        self.lines = lines_in
        self.key_gener = (i for i in range(1000000))
        self.grid_args = {}
        self.check_buttons = {}
        self.check_buttons_data = checkbox_factory(
            self.frame_buttons,
            buttons=self.lines
        )

        r, c, rs, cs, ix, iy, x, y, s = self.grid_keys()
        self.grid_args.update({"frame_buttons": {r: 0, c: 0}})
        # print(f"{self.check_buttons_data=}")
        # print(f"{type(self.check_buttons_data)=}")
        # print(f"{len(self.check_buttons_data)=}")
        # print(f"{list(zip(self.check_buttons_data))=}")
        # # for i, tv_var_btn in enumerate(self.check_buttons_data):
        # # for tv_var, btn in self.check_buttons_data:
        for i, tv_var_btn in enumerate(zip(*self.check_buttons_data)):
            # print(f"{i=}, {tv_var_btn=}")
            tv_var, btn = tv_var_btn
            txt = btn.cget("text")
            ke = self.keyify(txt, make_new=True)
            self.check_buttons[ke] = btn
            self.grid_args.update({ke: {r: 1, c: 0}})

        if self.auto_grid:
            self.auto_grid_widgets()

    def new_keyify(self, label_name_in):
        return f"k_{('000000' + str(next(self.key_gener)))[-6:]}_._._{label_name_in.lower()}"

    def keyify(self, label_name_in, make_new=False):
        label_name_in_l = label_name_in.lower()
        delim = "_._._"
        for key in self.grid_args:
            if key.split(delim)[-1] == label_name_in_l:
                return key

        if make_new:
            return self.new_keyify(label_name_in)
        else:
            raise KeyError(f"Error, key '{label_name_in}' not found among keys.")

    # def de_keyify(self, key_in):
    #     alike = []
    #     ke = key_in.lower()
    #     for k in self.info_labels:
    #         if k.split("_")[-1].lower() == ke:
    #             alike.append(k)
    #
    #     if not alike:
    #         raise KeyError(f"Error cannot find any keys that are alike the given key '{key_in}'")
    #     else:
    #         if len(alike) > 1:
    #             print(
    #                 f"WARNING de-keyify function found multiple keys with the given name '{key_in}', returning the first occurence.")
    #         return alike[0]

    def grid_keys(self):
        return "row", "column", "rowspan", "columnspan", "ipadx", "ipady", "padx", "pady", "sticky"

    def parse_auto_grid(self):
        ag = self.auto_grid
        off = 0 if isinstance(ag, bool) else ag
        return (off, 0) if isinstance(off, int) else off

    def auto_grid_widgets(self):
        off_r, off_c = self.parse_auto_grid()
        r, c, rs, cs, ix, iy, x, y, s = self.grid_keys()

        self.grid_args.update({
            ".": {r: off_r, c: off_c, cs: 1, rs: 1}
        })

        # print(dict_print(self.grid_args, "GA"))

        for k in self.grid_args:
            v = self.grid_args[k]
            print(f"{k=}, {v=}")
            self.grid(**v)
            if k == ".":
                self.grid(**v)
            else:
                if k in self.check_buttons:
                    eval(f"self.{k}.grid(**{v})")
                else:
                    eval(f"self.{self.check_buttons[k]}.grid(**{v})")
            # # elif k == "header":
            # #     self.header[1].grid(**v)
            # # elif k == "footer":
            # #     self.footer[1].grid(**v)
            # else:
            #     # print(f"{self.grid_args[k]=}")
            #     self.info_labels[k]["k_label"].grid(**v["k_label"])
            #     self.info_labels[k]["v_label"].grid(**v["v_label"])


if __name__ == '__main__':

    win = tkinter.Tk()
    win.geometry(f"600x450")
    lines = ["A", "B", "C", "D", "E", "F"]
    f = LineSelector(win, lines)
    win.mainloop()
