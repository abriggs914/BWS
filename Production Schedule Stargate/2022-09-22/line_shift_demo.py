import tkinter

from tkinter_utility import *


class LineShifter(tkinter.Frame):

    def __init__(self, master, lines):
        super().__init__(master)

        self.lines = lines
        self.tv_combo_label, self.combo_label, self.tv_combo, self.combo = combo_factory(self, tv_label="Line:", kwargs_combo={"values": self.lines})
        self.tv_direction = tkinter.IntVar(self, name="direction", value=1)
        self.tv_forward = tkinter.StringVar(self, name="tv_forward", value="Forward")
        self.tv_backward = tkinter.StringVar(self, name="tv_backward", value="Backward")
        self.radio_button_forward = tkinter.Radiobutton(self, variable=self.tv_direction, value=1, textvariable=self.tv_forward)
        self.radio_button_backward = tkinter.Radiobutton(self, variable=self.tv_direction, value=2, textvariable=self.tv_backward)
        self.tv_label_spinbox = tkinter.StringVar(self, name="label_spinbox", value="Days:")
        self.tv_spinbox = tkinter.IntVar(self, name="tv_spinbox", value=1)
        self.label_spinbox = tkinter.Label(self, textvariable=self.tv_label_spinbox)
        self.spinbox = tkinter.Spinbox(self, textvariable=self.tv_spinbox, from_=1, to=7, command=self.days_update)

        self.tv_combo.trace_variable("w", self.combo_update)
        self.tv_direction.trace_variable("w", self.direction_update)

        self.combo_label.grid(row=1, column=1)
        self.combo.grid(row=1, column=2)
        self.radio_button_forward.grid(row=2, column=1)
        self.radio_button_backward.grid(row=3, column=1)
        self.label_spinbox.grid(row=2, column=2)
        self.spinbox.grid(row=3, column=2)

    def combo_update(self, var_name, index, mode):
        print(f"combo_update {var_name=}, {index=}, {mode=}")

    def direction_update(self, var_name, index, mode):
        print(f"direction_update {var_name=}, {index=}, {mode=}")

    def days_update(self):
        print(f"days_update")

if __name__ == '__main__':
    WIN = tkinter.Tk()
    WIDTH, HEIGHT = 900, 600
    WIN.geometry(f"{WIDTH}x{HEIGHT}")
    lines = [f"T_{i + 1}" for i in range(6)]
    ls = LineShifter(WIN, lines=lines)
    ls.pack()
    WIN.mainloop()
