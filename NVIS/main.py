import datetime
import tkinter

from generation import NVIS
from tkinter import ttk

from utility import clamp


class NVISGenerator(tkinter.Tk):

    def __init__(self):
        super().__init__()

        self.geometry(f"{400}x{400}")
        self.title("BWS NVIS Generator")

        today_year = datetime.datetime.now().year
        self.valid_combo_dates = list(range(today_year - 5, today_year + 5))

        self.style = ttk.Style(self)
        self.style.theme_use("default")
        self.style.map("Entry")
        self.style.map("Button")
        self.style.map("Label")
        self.style.map("Combobox")

        self.tv_label_title = tkinter.StringVar(self, value="Enter a Quote# and select a Model Year to generate a new Serial Number.")
        self.tv_label_quote = tkinter.StringVar(self, value="Quote#:")
        self.tv_label_model_year = tkinter.StringVar(self, value="Model Year:")
        self.tv_label_status = tkinter.StringVar(self, value="Status:")
        self.tv_btn_generate = tkinter.StringVar(self, value="generate serial")
        self.tv_btn_clear = tkinter.StringVar(self, value="clear fields")
        self.tv_label_sequential = tkinter.StringVar(self, value="Sequential:")
        self.tv_quote = tkinter.StringVar(self)
        self.tv_model_year = tkinter.StringVar(self)
        self.tv_status = tkinter.StringVar(self)
        self.tv_sequential = tkinter.StringVar(self)

        self.label_title = tkinter.Label(self, textvariable=self.tv_label_title)
        self.label_quote = tkinter.Label(self, textvariable=self.tv_label_quote)
        self.entry_quote_number = tkinter.Entry(self, textvariable=self.tv_quote, width=25)
        self.label_model_year = tkinter.Label(self, textvariable=self.tv_label_model_year)
        self.combo_model_year = ttk.Combobox(self, textvariable=self.tv_model_year, width=25, show=10)
        self.entry_status = tkinter.Entry(self, textvariable=self.tv_status, state="readonly", width=50, justify="center")
        self.label_sequential = tkinter.Label(self, textvariable=self.tv_label_sequential)
        self.entry_sequential = tkinter.Entry(self, textvariable=self.tv_sequential, width=25)
        self.button_generate = tkinter.Button(self, textvariable=self.tv_btn_generate, command=self.generate_NVIS, width=24)
        self.button_clear = tkinter.Button(self, textvariable=self.tv_btn_clear, command=self.clear_fields, width=24)
        self.label_status_code = tkinter.Label(self, textvariable=self.tv_label_status)

        self.tv_label_dat_model_no = tkinter.StringVar(self, value="Model No:")
        self.tv_label_dat_wo = tkinter.StringVar(self, value="WO#:")
        self.tv_label_dat_length = tkinter.StringVar(self, value="Length:")
        self.tv_label_dat_axles = tkinter.StringVar(self, value="Axles:")
        self.tv_label_dat_trailer_type = tkinter.StringVar(self, value="Type of Trailer:")
        self.tv_label_dat_body_type = tkinter.StringVar(self, value="Type of Body:")
        self.tv_label_dat_model_year = tkinter.StringVar(self, value="Model Year:")
        self.tv_label_dat_units_date = tkinter.StringVar(self, value="Units to Date:")
        self.tv_label_dat_check_digit = tkinter.StringVar(self, value="Check Digit:")
        self.tv_label_dat_server_serial = tkinter.StringVar(self, value="Server Serial:")
        self.tv_dat_model_no = tkinter.StringVar(self)
        self.tv_dat_wo = tkinter.StringVar(self)
        self.tv_dat_length = tkinter.StringVar(self)
        self.tv_dat_axles = tkinter.StringVar(self)
        self.tv_dat_trailer_type = tkinter.StringVar(self)
        self.tv_dat_body_type = tkinter.StringVar(self)
        self.tv_dat_model_year = tkinter.StringVar(self)
        self.tv_dat_units_date = tkinter.StringVar(self)
        self.tv_dat_check_digit = tkinter.StringVar(self)
        self.tv_dat_server_serial = tkinter.StringVar(self)
        self.label_dat_model_no = tkinter.Label(self, textvariable=self.tv_label_dat_model_no)
        self.label_dat_wo = tkinter.Label(self, textvariable=self.tv_label_dat_wo)
        self.label_dat_length = tkinter.Label(self, textvariable=self.tv_label_dat_length)
        self.label_dat_axles = tkinter.Label(self, textvariable=self.tv_label_dat_axles)
        self.label_dat_trailer_type = tkinter.Label(self, textvariable=self.tv_label_dat_trailer_type)
        self.label_dat_body_type = tkinter.Label(self, textvariable=self.tv_label_dat_body_type)
        self.label_dat_model_year = tkinter.Label(self, textvariable=self.tv_label_dat_model_year)
        self.label_dat_units_date = tkinter.Label(self, textvariable=self.tv_label_dat_units_date)
        self.label_dat_check_digit = tkinter.Label(self, textvariable=self.tv_label_dat_check_digit)
        self.label_dat_server_serial = tkinter.Label(self, textvariable=self.tv_label_dat_server_serial)
        self.entry_dat_model_no = tkinter.Entry(self, textvariable=self.tv_dat_model_no, state="readonly")
        self.entry_dat_wo = tkinter.Entry(self, textvariable=self.tv_dat_wo, state="readonly")
        self.entry_dat_length = tkinter.Entry(self, textvariable=self.tv_dat_length, state="readonly")
        self.entry_dat_axles = tkinter.Entry(self, textvariable=self.tv_dat_axles, state="readonly")
        self.entry_dat_trailer_type = tkinter.Entry(self, textvariable=self.tv_dat_trailer_type, state="readonly")
        self.entry_dat_body_type = tkinter.Entry(self, textvariable=self.tv_dat_body_type, state="readonly")
        self.entry_dat_model_year = tkinter.Entry(self, textvariable=self.tv_dat_model_year, state="readonly")
        self.entry_dat_units_date = tkinter.Entry(self, textvariable=self.tv_dat_units_date, state="readonly")
        self.entry_dat_check_digit = tkinter.Entry(self, textvariable=self.tv_dat_check_digit, state="readonly")
        self.entry_dat_server_serial = tkinter.Entry(self, textvariable=self.tv_dat_server_serial, state="readonly")

        self.combo_model_year["values"] = self.valid_combo_dates

        self.grid()
        self.label_title.grid(row=1, column=1, columnspan=4, padx=0, pady=10)
        self.label_quote.grid(row=2, column=1, columnspan=2, padx=0, pady=0)
        self.entry_quote_number.grid(row=1, column=3, columnspan=2, padx=0, pady=0)
        self.label_quote.grid(row=3, column=1, columnspan=2, padx=0, pady=0)
        self.entry_quote_number.grid(row=3, column=3, columnspan=2, padx=0, pady=0)
        self.label_model_year.grid(row=4, column=1, columnspan=2, padx=0, pady=0)
        self.combo_model_year.grid(row=4, column=3, columnspan=2, padx=0, pady=0)
        self.label_sequential.grid(row=5, column=1, columnspan=2, padx=0, pady=0)
        self.entry_sequential.grid(row=5, column=3, columnspan=2, padx=0, pady=0)
        self.button_generate.grid(row=6, column=1, columnspan=2, padx=5, pady=5)
        self.button_clear.grid(row=6, column=3, columnspan=2, padx=5, pady=5)
        self.entry_status.grid(row=7, column=1, columnspan=4, padx=10, pady=10)

        self.label_dat_model_no.grid(row=10, column=1, columnspan=2, padx=0, pady=0)
        self.entry_dat_model_no.grid(row=10, column=3, columnspan=2, padx=0, pady=0)
        self.label_dat_wo.grid(row=11, column=1, columnspan=2, padx=0, pady=0)
        self.entry_dat_wo.grid(row=11, column=3, columnspan=2, padx=0, pady=0)
        self.label_dat_length.grid(row=12, column=1, columnspan=2, padx=0, pady=0)
        self.entry_dat_length.grid(row=12, column=3, columnspan=2, padx=0, pady=0)
        self.label_dat_axles.grid(row=13, column=1, columnspan=2, padx=0, pady=0)
        self.entry_dat_axles.grid(row=13, column=3, columnspan=2, padx=0, pady=0)
        self.label_dat_trailer_type.grid(row=14, column=1, columnspan=2, padx=0, pady=0)
        self.entry_dat_trailer_type.grid(row=14, column=3, columnspan=2, padx=0, pady=0)
        self.label_dat_body_type.grid(row=15, column=1, columnspan=2, padx=0, pady=0)
        self.entry_dat_body_type.grid(row=15, column=3, columnspan=2, padx=0, pady=0)
        self.label_dat_model_year.grid(row=16, column=1, columnspan=2, padx=0, pady=0)
        self.entry_dat_model_year.grid(row=16, column=3, columnspan=2, padx=0, pady=0)
        self.label_dat_units_date.grid(row=17, column=1, columnspan=2, padx=0, pady=0)
        self.entry_dat_units_date.grid(row=17, column=3, columnspan=2, padx=0, pady=0)
        self.label_dat_check_digit.grid(row=18, column=1, columnspan=2, padx=0, pady=0)
        self.entry_dat_check_digit.grid(row=18, column=3, columnspan=2, padx=0, pady=0)
        self.label_dat_server_serial.grid(row=19, column=1, columnspan=2, padx=0, pady=0)
        self.entry_dat_server_serial.grid(row=19, column=3, columnspan=2, padx=0, pady=0)

    def error_status(self, message="Error, please fix input params."):
        self.tv_status.set(message)
        self.entry_status.config(foreground="red")

    def set_status(self, status_in="ERROR", is_error=False, foreground="black"):
        if status_in == "ERROR" or is_error:
            self.error_status()
        else:
            self.tv_status.set(status_in)
            self.entry_status.config(foreground=foreground)

    def set_serial(self, serial_in):
        assert isinstance(serial_in, NVIS), f"Error, serial_in needs to be a NVIS object: {serial_in}, {type(serial_in)}"
        self.set_status(status_in=str(serial_in))
        self.tv_dat_model_no.set(serial_in.model_no)
        self.tv_dat_wo.set(serial_in.wo)
        self.tv_dat_length.set(serial_in.length)
        self.tv_dat_axles.set(serial_in.axles)
        self.tv_dat_trailer_type.set(serial_in.type_of_trailer)
        self.tv_dat_body_type.set(serial_in.type_of_body)
        self.tv_dat_model_year.set(serial_in.model_year)
        self.tv_dat_units_date.set(serial_in.units_to_date)
        self.tv_dat_check_digit.set(serial_in.check_digit)
        self.tv_dat_server_serial.set(serial_in.server_serial)

    def clear_sn_detail(self):
        """Clear the Serial Number detail text fields."""
        self.tv_dat_model_no.set("")
        self.tv_dat_wo.set("")
        self.tv_dat_length.set("")
        self.tv_dat_axles.set("")
        self.tv_dat_trailer_type.set("")
        self.tv_dat_body_type.set("")
        self.tv_dat_model_year.set("")
        self.tv_dat_units_date.set("")
        self.tv_dat_check_digit.set("")
        self.tv_dat_server_serial.set("")

    def clear_fields(self):
        """Clear top 3 textfields. Quote#, Model Year, and Sequential Start #"""
        self.tv_quote.set("")
        self.tv_model_year.set("")
        self.tv_sequential.set("")

        self.clear_sn_detail()

    def validate_combo(self):
        value = self.tv_model_year.get()
        if value not in self.valid_combo_dates:
            if isinstance(value, int) or isinstance(value, float):
                value = clamp(self.valid_combo_dates[0], value, self.valid_combo_dates[-1])
            else:
                value = datetime.datetime.now().year
        else:
            value = datetime.datetime.now().year
        print(f"Validating value: {value}")
        self.tv_model_year.set(str(value))

    def generate_NVIS(self):
        """Using Quote# and Model Year, generate a NVIS or serial number by BWS standards. 2022-08-23"""
        quote = self.tv_quote.get()
        model_year = self.tv_model_year.get()
        sequential = self.tv_sequential.get()
        sequential = sequential if sequential is not None and len(sequential) > 0 else None
        # self.tv_status.set(str(NVIS(quote, model_year, sequential_start=sequential)))
        # self.set_status(status_in=str(NVIS(quote, model_year, sequential_start=sequential)))
        try:
            self.set_serial(NVIS(quote, model_year, sequential_start=sequential))
        except IndexError as ie:
            self.set_status(str(ie), is_error=True)
        except KeyError as ke:
            self.set_status(str(ke), is_error=True)
        except ValueError as ve:
            self.set_status(str(ve), is_error=True)

if __name__ == "__main__":
    # print(NVIS(26454, 2022))
    NVISGenerator().mainloop()

