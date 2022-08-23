import datetime
import tkinter

from generation import NVIS
from tkinter import ttk

class NVISGenerator(tkinter.Tk):

    def __init__(self):
        super().__init__()

        self.geometry(f"{400}x{350}")
        self.title("BWS NVIS Generator")

        self.tv_label_title = tkinter.StringVar(self, value="Enter a Quote# and select a Model Year to generate a new Serial Number.")
        self.tv_label_quote = tkinter.StringVar(self, value="Quote#:")
        self.tv_label_model_year = tkinter.StringVar(self, value="Model Year:")
        self.tv_label_status = tkinter.StringVar(self, value="Status:")
        self.tv_btn_generate = tkinter.StringVar(self, value="generate")
        self.tv_label_sequential = tkinter.StringVar(self, value="Sequential:")
        self.tv_quote = tkinter.StringVar(self)
        self.tv_model_year = tkinter.StringVar(self)
        self.tv_status = tkinter.StringVar(self)
        self.tv_sequential = tkinter.StringVar(self)

        self.label_title = tkinter.Label(self, textvariable=self.tv_label_title)
        self.label_quote = tkinter.Label(self, textvariable=self.tv_label_quote)
        self.entry_quote_number = tkinter.Entry(self, textvariable=self.tv_quote)
        self.label_model_year = tkinter.Label(self, textvariable=self.tv_label_model_year)
        self.combo_model_year = ttk.Combobox(self, textvariable=self.tv_model_year)
        self.entry_status = tkinter.Entry(self, textvariable=self.tv_status, state="readonly")
        self.label_sequential = tkinter.Label(self, textvariable=self.tv_label_sequential)
        self.entry_sequential = tkinter.Entry(self, textvariable=self.tv_sequential)
        self.button_generate = tkinter.Button(self, textvariable=self.tv_btn_generate, command=self.generate_NVIS)
        self.label_status_code = tkinter.Label(self, textvariable=self.tv_label_status)

        self.tv_label_dat_model_no = tkinter.StringVar(self, value="Model No:")
        self.tv_label_dat_wo = tkinter.StringVar(self, value="WO#:")
        self.tv_label_dat_length = tkinter.StringVar(self, value="Length:")
        self.tv_label_dat_axles = tkinter.StringVar(self, value="Axles:")
        self.tv_label_dat_trailer_type = tkinter.StringVar(self, value="Type of Trailer:")
        self.tv_label_dat_body_type = tkinter.StringVar(self, value="Type of Body:")
        self.tv_label_dat_model_year = tkinter.StringVar(self, value="Model Year:")
        self.tv_label_dat_check_digit = tkinter.StringVar(self, value="Check Digit:")
        self.tv_dat_model_no = tkinter.StringVar(self)
        self.tv_dat_wo = tkinter.StringVar(self)
        self.tv_dat_length = tkinter.StringVar(self)
        self.tv_dat_axles = tkinter.StringVar(self)
        self.tv_dat_trailer_type = tkinter.StringVar(self)
        self.tv_dat_body_type = tkinter.StringVar(self)
        self.tv_dat_model_year = tkinter.StringVar(self)
        self.tv_dat_check_digit = tkinter.StringVar(self)
        self.label_dat_model_no = tkinter.Label(self, textvariable=self.tv_label_dat_model_no)
        self.label_dat_wo = tkinter.Label(self, textvariable=self.tv_label_dat_wo)
        self.label_dat_length = tkinter.Label(self, textvariable=self.tv_label_dat_length)
        self.label_dat_axles = tkinter.Label(self, textvariable=self.tv_label_dat_axles)
        self.label_dat_trailer_type = tkinter.Label(self, textvariable=self.tv_label_dat_trailer_type)
        self.label_dat_body_type = tkinter.Label(self, textvariable=self.tv_label_dat_body_type)
        self.label_dat_model_year = tkinter.Label(self, textvariable=self.tv_label_dat_model_year)
        self.label_dat_check_digit = tkinter.Label(self, textvariable=self.tv_label_dat_check_digit)
        self.entry_dat_model_no = tkinter.Entry(self, textvariable=self.tv_dat_model_no, state="readonly")
        self.entry_dat_wo = tkinter.Entry(self, textvariable=self.tv_dat_wo, state="readonly")
        self.entry_dat_length = tkinter.Entry(self, textvariable=self.tv_dat_length, state="readonly")
        self.entry_dat_axles = tkinter.Entry(self, textvariable=self.tv_dat_axles, state="readonly")
        self.entry_dat_trailer_type = tkinter.Entry(self, textvariable=self.tv_dat_trailer_type, state="readonly")
        self.entry_dat_body_type = tkinter.Entry(self, textvariable=self.tv_dat_body_type, state="readonly")
        self.entry_dat_model_year = tkinter.Entry(self, textvariable=self.tv_dat_model_year, state="readonly")
        self.entry_dat_check_digit = tkinter.Entry(self, textvariable=self.tv_dat_check_digit, state="readonly")

        today_year = datetime.datetime.now().year
        self.combo_model_year["values"] = list(range(today_year - 5, today_year + 6))

        self.grid()
        self.label_title.grid(row=1, column=1, columnspan=4)
        self.label_quote.grid(row=2, column=1, columnspan=2)
        self.entry_quote_number.grid(row=1, column=3, columnspan=2)
        self.label_quote.grid(row=3, column=1, columnspan=2)
        self.entry_quote_number.grid(row=3, column=3, columnspan=2)
        self.label_model_year.grid(row=4, column=1, columnspan=2)
        self.combo_model_year.grid(row=4, column=3, columnspan=2)
        self.label_sequential.grid(row=5, column=1, columnspan=2)
        self.entry_sequential.grid(row=5, column=3, columnspan=2)
        self.button_generate.grid(row=6, column=2, columnspan=2)
        self.entry_status.grid(row=7, column=1, columnspan=4)


        self.label_dat_model_no.grid(row=10, column=1, columnspan=2)
        self.label_dat_wo.grid(row=11, column=1, columnspan=2)
        self.label_dat_length.grid(row=12, column=1, columnspan=2)
        self.label_dat_axles.grid(row=13, column=1, columnspan=2)
        self.label_dat_trailer_type.grid(row=14, column=1, columnspan=2)
        self.label_dat_body_type.grid(row=15, column=1, columnspan=2)
        self.label_dat_model_year.grid(row=16, column=1, columnspan=2)
        self.label_dat_check_digit.grid(row=17, column=1, columnspan=2)

        self.entry_dat_model_no.grid(row=10, column=3, columnspan=2)
        self.entry_dat_wo.grid(row=11, column=3, columnspan=2)
        self.entry_dat_length.grid(row=12, column=3, columnspan=2)
        self.entry_dat_axles.grid(row=13, column=3, columnspan=2)
        self.entry_dat_trailer_type.grid(row=14, column=3, columnspan=2)
        self.entry_dat_body_type.grid(row=15, column=3, columnspan=2)
        self.entry_dat_model_year.grid(row=16, column=3, columnspan=2)
        self.entry_dat_check_digit.grid(row=17, column=3, columnspan=2)

    def error_status(self, message="Error, please fix input params."):
        self.tv_status.set(message)
        self.entry_status.config(foreground="red")

    def set_status(self, status_in="ERROR", is_error=False, foreground="black"):
        if status_in == "ERROR" or is_error:
            self.error_status()
        else:
            self.tv_status.set(status_in)
            self.entry_status.config(foreground=foreground)

    def generate_NVIS(self):
        quote = self.tv_quote.get()
        model_year = self.tv_model_year.get()
        sequential = self.tv_sequential.get()
        sequential = sequential if sequential is not None and len(sequential) > 0 else None
        self.tv_status.set(str(NVIS(quote, model_year, sequential_start=sequential)))

if __name__ == "__main__":
    # print(NVIS(26454, 2022))
    NVISGenerator().mainloop()

