import json
import tkinter.messagebox

from tkinter_utility import *
from grid_manager import GridManager


class SettingsWriter(tkinter.Tk):

    def __init__(self):
        super().__init__()

        self.output_file = f"./PDS_User_Setting.json"

        self.geometry(f"500x500")
        self.title("Settings Writer")
        self.tv_label_name,\
        self.label_name,\
        self.tv_entry_name,\
        self.entry_name =\
            entry_factory(
                self,
                tv_label="Computer User Name:"
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
        self.tv_illegal_sat_val = tkinter.BooleanVar(self, value=True)
        self.check_illegal_sat = tkinter.Checkbutton(self, variable=self.tv_illegal_sat_val, textvariable=self.tv_illegal_sat, state="disabled")

        self.gm = GridManager()
        self.gm.grid_widgets(
            [
                [
                    self.label_name,
                    self.entry_name
                ],
                [
                    self.check_illegal_sat
                ],
                [
                    {
                        "widget": self.btn_submit,
                        "columnspan": 2
                    }
                ]
            ]
        )

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

    def write_settings(self):
        name = self.tv_entry_name.get()
        settings = {
            "user_name": name
        }

        with open(self.output_file, "w") as f:
            f.write(json.dumps(settings))



if __name__ == '__main__':
    SettingsWriter().mainloop()
