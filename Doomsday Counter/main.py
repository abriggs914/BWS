# import tkinter as tk
from tkinter import Button, Label, Frame, StringVar
from time import sleep
from overlay import Window

from colour_utility import RED, rgb_to_hex
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
    label_0 = tk.Label(win_0.root, text="Window_0")
    label_0.pack()
    win_1 = Window()
    label_1 = tk.Label(win_1.root, text="Window_1")
    label_1.pack()

    Window.after(2000, other_stuff, 'Hello World') # Identical to the after method of tkinter.Tk.

    Window.launch()

if __name__ == "__main__":
    test_2()
    # test_3()
