import datetime
import json
import os

from utility import dict_print

class SettingsWriter:

    def __init__(
            self,
            output_file=f"C:/Access/User_Settings.json",
            illegal_sat: bool = True,
            illegal_sun: bool = True,
            start_date: datetime.datetime = datetime.datetime(2021, 10, 1),
            viewable_months: int = 36,
            colour_scheme: dict = None
    ):
        assert isinstance(illegal_sat, bool), f"Error param 'illegal_sat must be a valid bool instance. Got '{type(illegal_sat)}'"
        assert isinstance(illegal_sun, bool), f"Error param 'illegal_sun must be a valid bool instance. Got '{type(illegal_sun)}'"
        assert isinstance(viewable_months, int) and viewable_months > 0, f"Error param 'viewable_months' must be a valid int instance, and it must be non-negative, and non-zero. Got viewable_months={viewable_months}, type='{type(illegal_sun)}'"
        assert isinstance(start_date, datetime.datetime), f"Error param 'start_date must be a valid datetime.datetime instance. Got '{type(start_date)}'"

        self.output_file = output_file
        self.user_name = os.getlogin()
        self.illegal_sat = illegal_sat
        self.illegal_sun = illegal_sun
        self.start_date = start_date.strftime("%Y-%m-%d")
        self.viewable_months = viewable_months
        self.colour_scheme = colour_scheme

        self.settings_keys = [
            "user_name",
            "allow_saturday",
            "allow_sunday",
            "start_date",
            "viewable_months",
            "colour_scheme"
        ]

    def write(self):
        name = self.user_name
        illegal_sat = self.illegal_sat
        illegal_sun = self.illegal_sun
        # start_date = self.odp.date.strftime("%Y-%m-%d")
        start_date = self.start_date
        viewable_months = self.viewable_months
        colour_scheme = self.colour_scheme

        keys = self.settings_keys
        vals = [
            name,
            not illegal_sat,
            not illegal_sun,
            start_date,
            viewable_months,
            colour_scheme
        ]
        assert len(keys) == len(vals), f"Error keys and values lists have different lengths.\n\t{keys=}\n\t{vals=}"
        settings = dict(zip(keys, vals))

        print(dict_print(settings, "Settings"))

        print(f"PRE WRITE\n\t{self.output_file=}\n\t{keys=}\n\t{vals=}\n\t{settings=}")
        with open(self.output_file, "w") as f:
            f.write(json.dumps(settings))
        print(f"POST WRITE")


if __name__ == '__main__':
    SettingsWriter().write()
