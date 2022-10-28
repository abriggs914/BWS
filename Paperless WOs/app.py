import tkinter

from tkinter_utility import *


class App(tkinter.Tk):

    def __init__(self):
        super().__init__()

        self.f_width, self.f_height = 400, 400
        self.geometry(f"{self.f_width}x{self.f_height}")
        self.title("Part Tracker")

        self.tv_wo = tkinter.StringVar()
        self.tv_pn = tkinter.StringVar()
        self.tv_ct = tkinter.StringVar()

        # Work Order #
        self.tv_label_wo,\
        self.label_wo,\
        self.tv_entry_wo,\
        self.entry_wo\
            = entry_factory(
                self,
                tv_label="WO:",
                tv_entry=self.tv_wo
        )

        # Part Number
        self.tv_label_pn,\
        self.label_pn,\
        self.tv_combo_pn,\
        self.combo_pn\
            = combo_factory(
                self,
                tv_label="Part # OR Desc:",
                tv_combo=self.tv_pn,
                kwargs_combo={
                    "values": []
                }
        )

        # Comments
        self.tv_label_ct,\
        self.label_ct,\
        self.tv_entry_ct,\
        self.entry_ct\
            = entry_factory(
                self,
                tv_label="Comments:",
                tv_entry=self.tv_ct
        )

        self.tv_btn_cancel,\
        self.btn_cancel,\
            = button_factory(
                self,
                tv_btn="cancel",
                kwargs_btn={
                    "command": self.click_btn_cancel
                }
        )

        self.tv_btn_submit,\
        self.btn_submit,\
            = button_factory(
                self,
                tv_btn="submit",
                kwargs_btn={
                    "command": self.click_btn_submit
                }
        )

        self.label_wo.grid(row=0, column=0)
        self.entry_wo.grid(row=0, column=1)
        self.label_pn.grid(row=1, column=0)
        self.combo_pn.grid(row=1, column=1)
        self.label_ct.grid(row=2, column=0)
        self.entry_ct.grid(row=2, column=1)
        self.btn_cancel.grid(row=3, column=0)
        self.btn_submit.grid(row=3, column=1)

    def click_btn_cancel(self, *args):
        print(f"click_btn_cancel")

    def click_btn_submit(self, *args):
        print(f"click_btn_submit")
