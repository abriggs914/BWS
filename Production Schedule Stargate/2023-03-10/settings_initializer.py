import datetime
import json
import os

from tkinter_utility import *


class SettingsWriter:

    def __init__(self):

        self.output_file = f"C:/Access/PDS_User_Settings.json"

        self.user_name = os.getlogin()
        self.illegal_sat = True
        self.illegal_sun = True
        self.start_date = datetime.datetime(2021, 10, 1).strftime("%Y-%m-%d")
        self.viewable_months = 36

    def write(self):
        name = self.user_name
        illegal_sat = self.illegal_sat
        illegal_sun = self.illegal_sun
        # start_date = self.odp.date.strftime("%Y-%m-%d")
        start_date = self.start_date
        viewable_months = self.viewable_months
        settings = {
            "user_name": name,
            "allow_saturday": not illegal_sat,
            "allow_sunday": not illegal_sun,
            "start_date": start_date,
            "viewable_months": viewable_months
        }

        with open(self.output_file, "w") as f:
            f.write(json.dumps(settings))


if __name__ == '__main__':
    # SettingsWriter().mainloop()
    SettingsWriter().write()
