import tkinter
from tkinter import messagebox
from datetime_utility import *
from orbiting_date_picker import OrbitingDatePicker
from tkinter_utility import *
from colour_utility import *


class LineShifter(tkinter.Frame):

    def __init__(self, master, lines, min_date, max_date, disabled=False):
        super().__init__(master)

        self.disabled = disabled
        self.status = tkinter.Variable(self, value={})

        self.colour_background = Colour(185, 185, 185).hex_code
        self.colour_button_background = Colour(216, 216, 216).hex_code

        assert is_date(min_date), f"Error, you must pass a valid date for 'min_date' parameter. Got '{min_date=}'"
        assert is_date(max_date), f"Error, you must pass a valid date for 'max_date' parameter. Got '{max_date=}'"
        assert lines, "Error, you must pass a valid selection list of lines."

        self.min_date = min_date
        self.max_date = max_date
        self.start_date = None
        self.end_date = None

        self.frame_dates = tkinter.Frame(self, background=rgb_to_hex(HAZEL))
        self.frame_start_date = tkinter.Frame(self.frame_dates, background=rgb_to_hex(TEAL))
        self.tv_label_start_date, self.label_start_date = label_factory(self.frame_start_date, tv_label="Starting:")
        self.btn_arrow_start_date = ArrowButton(self.frame_start_date)
        self.tv_btn_start_to_today, self.btn_start_to_today = button_factory(self.frame_start_date, tv_btn="today",
                                                                             command=self.click_set_start_date_today,
                                                                             kwargs_btn={"font": ("Arial", 8)})
        self.tv_btn_start_min_date, self.btn_start_min_date = button_factory(self.frame_start_date, tv_btn="min",
                                                                             command=self.click_set_start_date_min_date,
                                                                             kwargs_btn={"font": ("Arial", 8)})
        self.tv_btn_start_max_date, self.btn_start_max_date = button_factory(self.frame_start_date, tv_btn="max",
                                                                             command=self.click_set_start_date_max_date,
                                                                             kwargs_btn={"font": ("Arial", 8)})
        self.odp_start_date = OrbitingDatePicker(self.frame_start_date, date_format="yyyy-MM-dd")
        self.odp_start_date.checkbox_showing_orbiter.grid_forget()

        self.frame_end_date = tkinter.Frame(self.frame_dates, background=rgb_to_hex(ORANGE))
        self.tv_label_end_date, self.label_end_date = label_factory(self.frame_end_date, tv_label="Ending:")
        self.btn_arrow_end_date = ArrowButton(self.frame_end_date)
        self.tv_btn_end_to_today, self.btn_end_to_today = button_factory(self.frame_end_date, tv_btn="today",
                                                                         command=self.click_set_end_date_today,
                                                                         kwargs_btn={"font": ("Arial", 8)})
        self.tv_btn_end_min_date, self.btn_end_min_date = button_factory(self.frame_end_date, tv_btn="min",
                                                                         command=self.click_set_end_date_min_date,
                                                                         kwargs_btn={"font": ("Arial", 8)})
        self.tv_btn_end_max_date, self.btn_end_max_date = button_factory(self.frame_end_date, tv_btn="max",
                                                                             command=self.click_set_end_date_max_date,
                                                                             kwargs_btn={"font": ("Arial", 8)})
        self.odp_end_date = OrbitingDatePicker(self.frame_end_date, date_format="yyyy-MM-dd")
        self.odp_end_date.checkbox_showing_orbiter.grid_forget()

        self.frame_date_btns = tkinter.Frame(self.frame_dates)
        # first date, last date,

        self.lines = lines
        self.tv_combo_label, self.combo_label, self.tv_combo, self.combo = combo_factory(
            self,
            tv_label="Line:",
            kwargs_label={
                "background": self.colour_background
            },
            kwargs_combo={
                "values": self.lines,
                "justify": tkinter.CENTER
            }
        )
        self.tv_direction = tkinter.IntVar(self, name="direction", value=1)
        self.tv_forward = tkinter.StringVar(self, name="tv_forward", value="Forward")
        self.tv_backward = tkinter.StringVar(self, name="tv_backward", value="Backward")
        self.radio_button_forward = tkinter.Radiobutton(self, variable=self.tv_direction, value=1,
                                                        textvariable=self.tv_forward, background=self.colour_background)
        self.radio_button_backward = tkinter.Radiobutton(self, variable=self.tv_direction, value=2,
                                                         textvariable=self.tv_backward,
                                                         background=self.colour_background)
        self.tv_label_spinbox = tkinter.StringVar(self, name="label_spinbox", value="Days:")
        self.tv_spinbox = tkinter.IntVar(self, name="tv_spinbox", value=1)
        self.label_spinbox = tkinter.Label(self, textvariable=self.tv_label_spinbox, background=self.colour_background)
        self.spinbox = tkinter.Spinbox(self, textvariable=self.tv_spinbox, command=self.days_update,
                                       values=list(range(1, 8)), state="readonly", justify=tkinter.CENTER)
        self.tv_button_shift, self.button_shift = button_factory(
            self,
            tv_btn="shift units",
            kwargs_btn={
                "background": self.colour_button_background,
                "command": self.click_shift_units,
                "foreground": Colour(GRAY_60).hex_code
            }
        )

        self.frame_shift_status = tkinter.Frame(self)
        self.tv_label_entry_shift_status, \
            self.label_entry_shift_status, \
            self.tv_entry_shift_status, \
            self.entry_shift_status = \
            entry_factory(
                self.frame_shift_status,
                kwargs_entry={
                    "width": 70,
                    "justify": tkinter.CENTER,
                    "state": "readonly"
                }
            )

        self.tv_combo.trace_variable("w", self.combo_update)
        self.tv_direction.trace_variable("w", self.direction_update)
        self.btn_arrow_start_date.bind("<Button-1>", self.click_arrow_btn_start_date)
        self.btn_arrow_end_date.bind("<Button-1>", self.click_arrow_btn_end_date)
        self.odp_start_date.dateentry_entry.bind()

        self.combo_label.grid(row=2, column=1, padx=5, pady=5)

        self.frame_dates.grid(row=1, column=1, columnspan=4, padx=5, pady=5)

        self.frame_start_date.grid(row=0, column=0, columnspan=3, padx=5, pady=5)
        self.label_start_date.grid(row=0, column=0, columnspan=2, padx=5, pady=5)
        self.btn_arrow_start_date.grid(row=0, column=2, padx=5, pady=5)
        self.grid_start_date_widgets(False)

        self.frame_end_date.grid(row=0, column=3, columnspan=3, padx=5, pady=5)
        self.label_end_date.grid(row=0, column=0, columnspan=2, padx=5, pady=5)
        self.btn_arrow_end_date.grid(row=0, column=2, padx=5, pady=5)
        self.grid_end_date_widgets(False)

        self.frame_date_btns.grid(row=2, column=0, columnspan=2, padx=5, pady=5)

        self.combo.grid(row=2, column=2, padx=5, pady=5)
        self.radio_button_forward.grid(row=3, column=1, padx=5, pady=5)
        self.radio_button_backward.grid(row=4, column=1, padx=5, pady=5)
        self.label_spinbox.grid(row=3, column=2, padx=5, pady=5)
        self.spinbox.grid(row=4, column=2, padx=5, pady=5)
        self.frame_shift_status.grid(row=5, column=1, columnspan=2, padx=5, pady=5)
        self.button_shift.grid(row=6, column=1, columnspan=2, padx=5, pady=5)
        self.entry_shift_status.grid(row=0, column=0, columnspan=4, padx=5, pady=5)
        self.configure(background=self.colour_background)

    def grid_start_date_widgets(self, do_grid=True):
        if do_grid:
            self.odp_start_date.grid(row=1, column=0, columnspan=3, padx=5, pady=5)
            self.btn_start_min_date.grid(row=2, column=0, padx=5, pady=5)
            self.btn_start_to_today.grid(row=2, column=1, padx=5, pady=5)
            self.btn_start_max_date.grid(row=2, column=2, padx=5, pady=5)
        else:
            self.odp_start_date.grid_forget()
            self.btn_start_to_today.grid_forget()
            self.btn_start_min_date.grid_forget()
            self.btn_start_max_date.grid_forget()

    def grid_end_date_widgets(self, do_grid=True):
        if do_grid:
            self.odp_end_date.grid(row=1, column=0, columnspan=3, padx=5, pady=5)
            self.btn_end_min_date.grid(row=2, column=0, padx=5, pady=5)
            self.btn_end_to_today.grid(row=2, column=1, padx=5, pady=5)
            self.btn_end_max_date.grid(row=2, column=2, padx=5, pady=5)
        else:
            self.odp_end_date.grid_forget()
            self.btn_end_to_today.grid_forget()
            self.btn_end_min_date.grid_forget()
            self.btn_end_max_date.grid_forget()

    def combo_update(self, var_name, index, mode):
        print(f"combo_update {var_name=}, {index=}, {mode=}")
        if self.tv_combo.get() not in self.lines:
            self.tv_combo.set(self.lines[0])
        self.status_update()

    def direction_update(self, var_name, index, mode):
        print(f"direction_update {var_name=}, {index=}, {mode=}")
        self.status_update()

    def days_update(self):
        print(f"days_update")
        self.tv_spinbox.set(clamp(1, self.tv_spinbox.get(), 7))
        self.status_update()

    def status_update(self, *args):
        print(f"status_update, {args=}")
        msg = self.tv_entry_shift_status.get()
        result = {
            "line": self.tv_combo.get(),
            "direction": "forward" if self.tv_direction.get() == 1 else "backward",
            "days": self.tv_spinbox.get(),
            "start_date": self.odp_start_date.date,
            "end_date": self.odp_end_date.date,
            "msg": msg,
            "submission": False
        }
        if result["line"] and args:
            result["submission"] = True
        if not result["line"] and args:
            tkinter.messagebox.showinfo(title="Error", message="Error, you must select a line first.")
            result["submission"] = False
            self.combo.focus()
        print(f"{result=}")
        self.status.set(result)
        self.update_status()

        print(f"\tstatus\n{self.status.get()}")

    def click_shift_units(self):
        if not self.disabled:
            print(f"click_shift_units")
            self.status_update(1)
        else:
            tkinter.messagebox.showinfo("STG Prod Sched", "Shifting is not enabled for this application - Feature coming soon.")

    def disable_all_widgets(self):
        self.combo.configure(state="disabled")
        self.spinbox.configure(state="disabled")
        self.button_shift.configure(state="disabled")
        self.radio_button_forward.configure(state="disabled")
        self.radio_button_backward.configure(state="disabled")

    def enable_all_widgets(self):
        self.combo.configure(state="normal")
        self.spinbox.configure(state="normal")
        self.button_shift.configure(state="normal")
        self.radio_button_forward.configure(state="normal")
        self.radio_button_backward.configure(state="normal")

    def click_set_start_date_today(self):
        self.odp_start_date.dateentry_entry.set_date(datetime.datetime.today().date())
        self.odp_start_date.dateentry_change()
        self.update_status()

    def click_set_end_date_today(self):
        self.odp_end_date.dateentry_entry.set_date(datetime.datetime.today().date())
        self.odp_end_date.dateentry_change()
        self.update_status()

    def click_set_start_date_min_date(self):
        self.odp_start_date.dateentry_entry.set_date(self.min_date)
        self.odp_start_date.dateentry_change()
        self.update_status()

    def click_set_end_date_min_date(self):
        self.odp_end_date.dateentry_entry.set_date(self.min_date)
        self.odp_end_date.dateentry_change()
        self.update_status()

    def click_set_start_date_max_date(self):
        self.odp_start_date.dateentry_entry.set_date(self.max_date)
        self.odp_start_date.dateentry_change()
        self.update_status()

    def click_set_end_date_max_date(self):
        self.odp_end_date.dateentry_entry.set_date(self.max_date)
        self.odp_end_date.dateentry_change()
        self.update_status()

    def click_arrow_btn_start_date(self, event):
        state = self.btn_arrow_start_date.mode
        if state == "down":
            self.btn_arrow_start_date.change_direction("up")
        else:
            self.btn_arrow_start_date.change_direction("down")
        self.grid_start_date_widgets(do_grid=state == "down")
        self.update_status()

    def click_arrow_btn_end_date(self, event):
        state = self.btn_arrow_end_date.mode
        if state == "down":
            self.btn_arrow_end_date.change_direction("up")
        else:
            self.btn_arrow_end_date.change_direction("down")
        self.grid_end_date_widgets(do_grid=state == "down")
        self.update_status()

    def update_status(self, *args):
        if args:
            start_args, end_args = args
        else:
            osd = self.btn_arrow_start_date.mode == "up"
            oed = self.btn_arrow_end_date.mode == "up"
            try:
                sd = datetime.datetime.strptime(self.odp_start_date.tv_date.get(), "%Y-%m-%d")
                ed = datetime.datetime.strptime(self.odp_end_date.tv_date.get(), "%Y-%m-%d")
                ln = self.tv_combo.get()
                dr = "forward" if self.tv_direction.get() == 1 else "backward"
                dy = self.tv_spinbox.get()
                st = self.status.get()
                print(f"{osd=}, {oed=}, {sd=}, {ed=}, {ln=}, {dr=}, {dy=}, {st=}")
                msg = ""
                if osd and sd:
                    msg = f"Starting {sd:%Y-%m-%d}"
                if oed and ed:
                    if msg:
                        msg += f" to {ed:%Y-%m-%d}, "
                    else:
                        msg = f"Up to {ed:%Y-%m-%d}, "
                elif msg:
                    msg += ", "
                a = "all " if not osd and not oed else ""
                l = "all lines" if ln == "All" else "line"
                msg += f"Shift {a}units on {l} "
                if ln != "All":
                    if ln:
                        msg += f"'{ln}' "
                    else:
                        msg += f"____ "
                s = "s" if dy != 1 else ""
                msg += f"{dr} by {dy} day{s}."
                self.tv_entry_shift_status.set(msg)
            except ValueError as ve:
                pass


def status_update(*args):
    print(f"GLOBAL STATUS UPDATE {args=}")
    print(f"BEFORE: {status.get()}")
    current = eval(status.get())
    if current["submission"]:
        current["submission"] = False
    status.set(current)
    print(f"AFTER:  {status.get()}")


if __name__ == '__main__':
    WIN = tkinter.Tk()
    WIDTH, HEIGHT = 900, 600
    WIN.geometry(f"{WIDTH}x{HEIGHT}")
    lines = [f"T{i + 1}" for i in range(6)]
    ls = LineShifter(WIN, lines=lines)
    status = ls.status
    status.trace_variable("w", status_update)
    ls.pack()
    WIN.mainloop()
