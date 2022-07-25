# import tkinter as tk
import tkinter
from tkinter import Button, Label, Frame, StringVar, Tk, Entry
from PIL import ImageTk, Image
from tkinter import ttk
from time import sleep
from overlay import Window

from colour_utility import *
from orbiting_date_picker import OrbitingDatePicker
from game_state_machine import BooleanGSM

#  https://github.com/davidmaamoaix/overlay/issues/3


def test_2():
    # win = Window(fill=rgb_to_hex(RED), colour=rgb_to_hex(RED), background=rgb_to_hex(RED), outline=rgb_to_hex(RED))
    WIDTH, HEIGHT = 500, 500
    win_overlay = Window(size=(WIDTH, HEIGHT))
    win = Frame(win_overlay.root, width=WIDTH, height=HEIGHT)
    win.pack()
    label = Label(win, text="Window_0")
    label.pack()

    tv_btn = StringVar(value="stop dragging")
    gsm_win_draggable = BooleanGSM()

    def set_new_pos():
        state = gsm_win_draggable.state()
        win.draggable = state
        if state:
            tv_btn.set("start dragging")
        else:
            tv_btn.set("stop dragging")
        gsm_win_draggable.__next__()
        win_overlay.draggable = gsm_win_draggable.state()


    button = Button(win, textvariable=tv_btn, command=set_new_pos)
    button.pack()
    odp = OrbitingDatePicker(win)
    odp.pack()
    Window.launch()


def test_3():

    def other_stuff(text):
        '''A simple demonstration. The usage of sleep is to emphasize the effects of each action.'''
        print(text)
        sleep(2)
        win_0.hide() # Hides the overlay.
        sleep(1)
        win_0.show() # Shows the overlay.
        sleep(1)
        win_0.focus() # Sets focus to overlay.
        win_1.center() # Moves the overlay to the center of the screen.
        sleep(1)
        Window.hide_all() # Hides all overlays.
        sleep(1)
        Window.show_all() # Shows all overlays.
        sleep(1)
        win_0.destroy() # Kills the overlay.
        sleep(1)
        Window.destroy_all() # Kills all overlays and ends the mainloop.


    '''Creates two windows.'''
    win_0 = Window()
    label_0 = Label(win_0.root, text="Window_0")
    label_0.pack()
    win_1 = Window()
    label_1 = Label(win_1.root, text="Window_1")
    label_1.pack()

    Window.after(2000, other_stuff, 'Hello World') # Identical to the after method of tkinter.Tk.

    Window.launch()


def test_4():
    pass


class Timer(Tk):

    def __init__(self):
        super().__init__()
        WIDTH, HEIGHT = 900, 600
        self.geometry(f"{WIDTH}x{HEIGHT}")

        # self.image_button_play = Image.open(r"C:\Users\ABriggs\Documents\BWS\Doomsday Counter\pause.png")
        # self.image_button_play = ImageTk.PhotoImage(self.image_button_play)
        self.image_button_play = tkinter.PhotoImage(file=r"C:\Users\ABriggs\Documents\BWS\Doomsday Counter\Screenshot 2022-07-21 144200.png")

        self.timer_units = ["Years", "Months", "Fortnights", "Weeks", "Days", "Hours", "Minutes", "Seconds"]

        self.frame_back = Frame(self, background=rgb_to_hex(RED))
        self.frame_desc = Frame(self.frame_back, background=rgb_to_hex(GREEN))
        self.frame_details = Frame(self.frame_back, background=rgb_to_hex(BLUE))
        self.frame_timer = Frame(self.frame_back, background=rgb_to_hex(PINK))
        self.frame_controls = Frame(self.frame_back, background=rgb_to_hex(YELLOW_3))

        self.sv_label_desc_desc = StringVar(self, value="Description")
        self.sv_label_detail_wo = StringVar(self, value="WO:")
        self.sv_label_detail_start_date = StringVar(self, value="Start Date:")
        self.sv_label_detail_stop_date = StringVar(self, value="Stop Date:")
        self.sv_label_detail_priority = StringVar(self, value="Priority:")
        self.sv_label_detail_completion_date = StringVar(self, value="Completion Date:")

        self.sv_entry_desc_desc = StringVar(self, value="")
        self.sv_entry_detail_wo = StringVar(self, value="")
        self.sv_entry_detail_start_date = StringVar(self, value="")
        self.sv_entry_detail_stop_date = StringVar(self, value="")
        self.sv_entry_detail_priority = StringVar(self, value="")
        self.sv_entry_detail_completion_date = StringVar(self, value="")

        self.sv_entry_timer_all = StringVar(self, value="")
        self.sv_entry_timer_current = StringVar(self, value="")
        self.sv_entry_timer_unit = StringVar(self, value="")

        self.sv_btn_play = StringVar(self, value="play")

        self.label_desc_desc = Label(self.frame_desc, textvariable=self.sv_label_desc_desc)

        self.label_detail_wo = Label(self.frame_details, textvariable=self.sv_label_detail_wo)
        self.label_detail_start_date = Label(self.frame_details, textvariable=self.sv_label_detail_start_date)
        self.label_detail_stop_date = Label(self.frame_details, textvariable=self.sv_label_detail_stop_date)
        self.label_detail_priority = Label(self.frame_details, textvariable=self.sv_label_detail_priority)
        self.label_detail_completion_date = Label(self.frame_details, textvariable=self.sv_label_detail_completion_date)

        self.entry_desc_desc = Entry(self.frame_desc, textvariable=self.sv_entry_desc_desc, width=50)

        self.entry_detail_wo = Entry(self.frame_details, textvariable=self.sv_entry_detail_wo)
        self.entry_detail_start_date = Entry(self.frame_details, textvariable=self.sv_entry_detail_start_date)
        self.entry_detail_stop_date = Entry(self.frame_details, textvariable=self.sv_entry_detail_stop_date)
        self.entry_detail_priority = Entry(self.frame_details, textvariable=self.sv_entry_detail_priority)
        self.entry_detail_completion_date = Entry(self.frame_details, textvariable=self.sv_entry_detail_completion_date)

        self.entry_timer_all = Entry(self.frame_timer, textvariable=self.sv_entry_timer_all)
        self.entry_timer_current = Entry(self.frame_timer, textvariable=self.sv_entry_timer_current)

        self.combo_timer_unit = ttk.Combobox(self.frame_timer, textvariable=self.sv_entry_timer_unit, values=self.timer_units)

        self.button_play = Button(self.frame_controls, textvariable=self.sv_btn_play, image=self.image_button_play,
                                  command=self.btn_play_clicked)

        self.frame_back.grid()
        self.frame_desc.grid(row=1, column=1, columnspan=1, rowspan=2)
        self.frame_details.grid(row=1, column=2, columnspan=4, rowspan=3)
        self.frame_timer.grid(row=4, column=2, columnspan=5, rowspan=3)
        self.frame_controls.grid(row=7, column=1, columnspan=12, rowspan=1)

        self.label_desc_desc.grid(row=1, column=1, columnspan=12, rowspan=1)
        self.label_detail_wo.grid(row=1, column=1, columnspan=1, rowspan=1)
        self.label_detail_start_date.grid(row=1, column=3, columnspan=1, rowspan=1)
        self.label_detail_stop_date.grid(row=2, column=3, columnspan=1, rowspan=1)
        self.label_detail_priority.grid(row=2, column=1, columnspan=1, rowspan=1)
        self.label_detail_completion_date.grid(row=3, column=3, columnspan=1, rowspan=1)

        self.entry_desc_desc.grid(row=2, column=1, columnspan=12, rowspan=4)
        self.entry_detail_wo.grid(row=1, column=2, columnspan=1, rowspan=1)
        self.entry_detail_start_date.grid(row=1, column=4, columnspan=1, rowspan=1)
        self.entry_detail_stop_date.grid(row=2, column=4, columnspan=1, rowspan=1)
        self.entry_detail_priority.grid(row=2, column=2, columnspan=1, rowspan=1)
        self.entry_detail_completion_date.grid(row=3, column=4, columnspan=1, rowspan=1)

        self.entry_timer_all.grid(row=1, column=1, columnspan=1, rowspan=1)
        self.entry_timer_current.grid(row=2, column=1, columnspan=1, rowspan=1)
        self.combo_timer_unit.grid(row=3, column=1, columnspan=1, rowspan=1)

        self.button_play.grid(row=1, column=1, columnspan=1, rowspan=1)

    def btn_play_clicked(self):
        print(f"btn_play_clicked")

if __name__ == "__main__":
    # test_2()
    # test_3()

    t = Timer()
    t.mainloop()

    # test_4()
