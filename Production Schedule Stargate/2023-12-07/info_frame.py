from tkinter_utility import *


class InfoFrame(tkinter.Frame):

    def __init__(self, master, labels=None, auto_grid=False, key_width=10, val_width=10, header=None, footer=None, cell_border=None, key_label_keywords=None, value_label_keywords=None, header_kwargs=None, footer_kwargs=None, *args, **kwargs):
        super().__init__(master, *args, **kwargs)
        self.auto_grid = auto_grid
        self.header = header
        self.footer = footer
        self.header_kwargs = header_kwargs
        self.footer_kwargs = footer_kwargs
        self.grid_args = {}
        self.labels_in = labels
        self.info_labels = {}
        self.key_gener = (i for i in range(1000000))
        self.key_width = key_width
        self.val_width = val_width
        self.cell_border = cell_border
        self.key_label_kwargs = key_label_keywords if key_label_keywords is not None else {}
        self.val_label_kwargs = value_label_keywords if value_label_keywords is not None else {}
        r, c, rs, cs, ix, iy, x, y, s = self.grid_keys()

        assert hasattr(self.labels_in, "__iter__"), f"Error param 'labels_in' must be an iterable. Got type='{type(self.labels_in)}'"

        self.check_header()
        self.check_footer()
        hi = 1 if self.header is not None else 0

        for i, k in enumerate(self.labels_in):
            if isinstance(self.labels_in, dict):
                k, v = str(k), str(self.labels_in[k])
            elif hasattr(k, "__iter__") and len(k) == 2:
                k, v = map(str, k)
            else:
                k, v = str(k), ""

            ke = self.keyify(k)

            self.check_border()
            self.check_width()

            k_tv, k_label = label_factory(
                self,
                tv_label=k,
                kwargs_label=self.key_label_kwargs
            )
            v_tv, v_label = label_factory(
                self,
                tv_label=v,
                kwargs_label=self.val_label_kwargs
            )
            ri = i + hi
            self.info_labels[ke] = {
                "k_tv": k_tv,
                "k_label": k_label,
                "v_tv": v_tv,
                "v_label": v_label
            }
            self.grid_args[ke] = {
                "k_label": {r: ri, c: 0},
                "v_label": {r: ri, c: 1}
            }

        if self.auto_grid:
            self.auto_grid_widgets()

    def check_border(self):
        if "highlightthickness" not in self.key_label_kwargs and "highlightbackground" not in self.key_label_kwargs and "borderwidth" not in self.key_label_kwargs:
            cb = 1 if self.cell_border is not None else 0
            cc = None if cb != 1 else self.cell_border
            if isinstance(cc, bool):
                cc = f"#000000"
            self.key_label_kwargs.update({
                "borderwidth": 1,
                "highlightthickness": cb,
                "highlightbackground": cc
            })

        if "highlightthickness" not in self.val_label_kwargs and "highlightbackground" not in self.val_label_kwargs and "borderwidth" not in self.val_label_kwargs:
            cb = 1 if self.cell_border is not None else 0
            cc = None if cb != 1 else self.cell_border
            if isinstance(cc, bool):
                cc = f"#000000"
            self.val_label_kwargs.update({
                "borderwidth": 1,
                "highlightthickness": cb,
                "highlightbackground": cc
            })

    def check_width(self):
        if "width" not in self.key_label_kwargs:
            self.key_label_kwargs.update({
                "width": self.key_width
            })
        if "width" not in self.val_label_kwargs:
            self.val_label_kwargs.update({
                "width": self.val_width
            })

    def check_header(self):
        if self.header is not None:
            r, c, rs, cs, ix, iy, x, y, s = self.grid_keys()
            off_r, off_c = self.parse_auto_grid()
            self.header = label_factory(
                self,
                tv_label=self.header,
                kwargs_label=self.header_kwargs
            )
            self.auto_grid = (off_r + 1, off_c)
            self.grid_args["header"] = {r: 0, c: 0, rs: 1, cs: 2}

    def check_footer(self):
        if self.footer is not None:
            r, c, rs, cs, ix, iy, x, y, s = self.grid_keys()
            self.footer = label_factory(
                self,
                tv_label=self.footer,
                kwargs_label=self.footer_kwargs
            )
            ri = len(self.labels_in) + (1 if self.header is not None else 0)
            self.grid_args["footer"] = {r: ri, c: 0, rs: 1, cs: 2}

    def keyify(self, label_name_in):
        return f"k_{('000000'+str(next(self.key_gener)))[-6:]}_{label_name_in}"

    def de_keyify(self, key_in):
        alike = []
        ke = key_in.lower()
        for k in self.info_labels:
            if k.split("_")[-1].lower() == ke:
                alike.append(k)

        if not alike:
            raise KeyError(f"Error cannot find any keys that are alike the given key '{key_in}'")
        else:
            if len(alike) > 1:
                print(
                f"WARNING de-keyify function found multiple keys with the given name '{key_in}', returning the first occurence.")
            return alike[0]

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
            if k == ".":
                self.grid(**v)
            elif k == "header":
                self.header[1].grid(**v)
            elif k == "footer":
                self.footer[1].grid(**v)
            else:
                # print(f"{self.grid_args[k]=}")
                self.info_labels[k]["k_label"].grid(**v["k_label"])
                self.info_labels[k]["v_label"].grid(**v["v_label"])

    def grid_widgets(self, offset=None):
        r, c = (0, 0) if offset is None else ((offset, 0) if isinstance(offset, int) else offset)
        assert isinstance(r, int) and r >= 0, f"Error row offset value '{r}' is not valid for gridding"
        assert isinstance(c, int) and c >= 0, f"Error column offset value '{c}' is not valid for gridding"
        self.auto_grid = (r, c)
        self.auto_grid_widgets()

    def get_objects(self):
        return self, *self.info_labels

    def change_value(self, key, value):
        if key not in self.info_labels:
            print(f"de-keying")
            ke = self.de_keyify(key)
        else:
            ke = key

        self.info_labels[ke]["v_tv"].set(value)

    def get_value(self, key, default=None):
        if key not in self.info_labels:
            print(f"de-keying")
            try:
                ke = self.de_keyify(key)
            except KeyError:
                return default
        else:
            ke = key
        return self.info_labels[ke]["v_tv"].get()


if __name__ == '__main__':
    app = tkinter.Tk()
    info_f_1 = InfoFrame(app, labels=["A", "B", "C"], auto_grid=True, background="#dc8845", padx=10, pady=10)
    info_f_2 = InfoFrame(app, labels={"1st": 1, "2nd": 2, "3rd": 3}, background="#77a1ee", padx=10, pady=10, cell_border=True)
    info_f_3 = InfoFrame(app, labels=[["Monday", 1], "Tuesday", ("Wednesday", 2)], background="#66dd87", padx=10, pady=10, auto_grid=(6, 1))
    info_f_4 = InfoFrame(app, labels=[["Monday", 1], "Tuesday", ("Wednesday", 2)], background="#dddd42", padx=10, pady=10, auto_grid=(9, 1), cell_border=True, key_label_keywords={"background": "#ee1212", "foreground": "#FFFFFF"}, header="Chart 1", footer="End of Chart 1")
    info_f_2.grid_widgets(offset=3)

    # app.after(3000, lambda: info_f_4.change_value("Tuesday", 10))
    # app.after(4000, lambda: info_f_4.change_value("1st", 10))
    app.mainloop()
