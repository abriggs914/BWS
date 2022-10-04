import datetime
import json
import os
import tkinter.messagebox

from tkinter_utility import *
from grid_manager import GridManager
from orbiting_date_picker import OrbitingDatePicker


class SettingsWriter(tkinter.Tk):

    def __init__(self):
        super().__init__()

        self.output_file = f"C:/Access/PDS_User_Settings.json"

        self.geometry(f"500x500")
        self.title("Settings Writer")

        self.tv_label_info = tkinter.StringVar(self, value="Please fill out the form below before program starts.\nYou may change these settings later.")
        self.label_info = tkinter.Label(self, textvariable=self.tv_label_info)

        self.tv_label_name,\
        self.label_name,\
        self.tv_entry_name,\
        self.entry_name =\
            entry_factory(
                self,
                tv_label="Computer User Name:",
                tv_entry=(os.getlogin() if os.getlogin() else ""),
                kwargs_entry={
                    "state": "disabled"
                }
            )

        self.tv_btn_submit,\
        self.btn_submit =\
            button_factory(
                self,
                tv_btn="submit",
                kwargs_btn={
                    "command": self.click_submit
                }
            )

        self.tv_illegal_sat = tkinter.StringVar(self, value="Saturday")
        self.tv_illegal_sun = tkinter.StringVar(self, value="Sunday")
        self.tv_label_illegal = tkinter.StringVar(self, value="Allow Weekends:")
        self.label_illegal = tkinter.Label(self, textvariable=self.tv_label_illegal)
        self.tv_illegal_sat_val = tkinter.BooleanVar(self, value=False)
        self.check_illegal_sat = tkinter.Checkbutton(self, variable=self.tv_illegal_sat_val, textvariable=self.tv_illegal_sat, state="disabled")
        self.tv_illegal_sun_val = tkinter.BooleanVar(self, value=False)
        self.check_illegal_sun = tkinter.Checkbutton(self, variable=self.tv_illegal_sun_val, textvariable=self.tv_illegal_sun, state="disabled")

        self.tv_label_start_date = tkinter.StringVar(self, value="Start date:")
        self.label_start_date = tkinter.Label(self, textvariable=self.tv_label_start_date)
        # self.odp = OrbitingDatePicker(self)
        self.tv_start_date = tkinter.StringVar(self, value=f"{datetime.datetime(2021,10,1):'%Y-%m-%d'}")
        self.entry_start_date = tkinter.Entry(self, textvariable=self.tv_start_date, state="disabled")
        # self.odp

        self.tv_viewable_months_v = tkinter.IntVar(self, value=48)
        self.tv_viewable_months = tkinter.StringVar(self, value="# Viewable Months:")
        self.label_viewable_months = tkinter.Label(self, textvariable=self.tv_viewable_months)
        self.spin_viewable_months = tkinter.Spinbox(self, from_=1, to=60, increment=1, state="disabled", textvariable=self.tv_viewable_months_v)

        self.gm = GridManager()
        self.gm.grid_widgets(
            [
                [
                    {
                        "widget": self.label_info,
                        "columnspan": 2
                    }
                ],
                [
                    self.label_name,
                    self.entry_name
                ],
                [
                    {
                        "widget": self.label_illegal,
                        "columnspan": 2
                    }
                ],
                [
                    self.check_illegal_sat,
                    self.check_illegal_sun
                ],
                [
                    self.label_viewable_months,
                    self.spin_viewable_months
                ],
                # [
                #     self.label_start_date
                # ],
                # [
                #     self.odp
                # ],
                [
                    self.label_start_date,
                    self.entry_start_date
                ],
                [
                    None, None,
                    {
                        "widget": self.btn_submit,
                        "ipadx": 5,
                        "ipady": 5
                    }

                ]
            ]
        )

        # self.entry_name.focus()
        # self.entry_name.bind("<Return>", self.click_submit())

    #     self.tv_entry_name.trace_variable("w", self.update_entry_name)
    #
    # def update_entry_name(self):
    #     pass

    def click_submit(self):
        name = self.tv_entry_name.get()
        if not name:
            tkinter.messagebox.showerror(title="Settings Error", message="Please enter a valid username.")
            self.entry_name.focus()
            return

        self.write_settings()
        self.destroy()

    def write_settings(self):
        name = self.tv_entry_name.get()
        illegal_sat = self.tv_illegal_sat.get()
        illegal_sun = self.tv_illegal_sun.get()
        # start_date = self.odp.date.strftime("%Y-%m-%d")
        start_date = self.tv_start_date.get().replace("'", "")
        viewable_months = self.tv_viewable_months_v.get()
        settings = {
            "user_name": name,
            "allow_saturday": not illegal_sat,
            "allow_sunday": not illegal_sun,
            "start_date": start_date,
            "viewable_months": viewable_months
        }

        with open(self.output_file, "w") as f:
            f.write(json.dumps(settings))

        tkinter.messagebox.showinfo(title="Settings Writer", message="Settings created successfully!")


if __name__ == '__main__':
    SettingsWriter().mainloop()
