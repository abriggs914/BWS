# import tkinter as tk
import json
import os.path
import tkinter

import datetime
from collections import OrderedDict
from tkinter import Button, Label, Frame, StringVar, Tk, Entry

import PIL
from PIL import ImageTk, Image
from tkinter import ttk, messagebox
from time import sleep

# import Resampling
# from PIL.Image import Resampling
# import Resampling as Resampling
from overlay import Window

from colour_utility import *
from json_writer import JSONWriter
from orbiting_date_picker import OrbitingDatePicker
from game_state_machine import BooleanGSM, GSM


#  https://github.com/davidmaamoaix/overlay/issues/3
from utility import print_by_line, lenstr


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
        win_0.hide()  # Hides the overlay.
        sleep(1)
        win_0.show()  # Shows the overlay.
        sleep(1)
        win_0.focus()  # Sets focus to overlay.
        win_1.center()  # Moves the overlay to the center of the screen.
        sleep(1)
        Window.hide_all()  # Hides all overlays.
        sleep(1)
        Window.show_all()  # Shows all overlays.
        sleep(1)
        win_0.destroy()  # Kills the overlay.
        sleep(1)
        Window.destroy_all()  # Kills all overlays and ends the mainloop.

    '''Creates two windows.'''
    win_0 = Window()
    label_0 = Label(win_0.root, text="Window_0")
    label_0.pack()
    win_1 = Window()
    label_1 = Label(win_1.root, text="Window_1")
    label_1.pack()

    Window.after(2000, other_stuff, 'Hello World')  # Identical to the after method of tkinter.Tk.

    Window.launch()


def test_4():
    pass


class Timer(Tk):

    def __init__(self):
        super().__init__()

        WIDTH, HEIGHT = 900, 600
        self.geometry(f"{WIDTH}x{HEIGHT}")
        self.title("Timer")

        # self.image_button_play = Image.open(r"C:\Users\ABriggs\Documents\BWS\Doomsday Counter\pause.png")
        # self.image_button_play = ImageTk.PhotoImage(self.image_button_play)

        # self.image_button_play = tkinter.PhotoImage(file=r"C:\Users\ABriggs\Documents\BWS\Doomsday Counter\Screenshot 2022-07-21 144200.png")

        # im = PIL.Image.open(r"C:\Users\abrig\Documents\BWS\BWS\Doomsday Counter\play.png")
        # pim = ImageTk.PhotoImage(im)
        # self.image_button_play = pim

        # self.image_button_play = tkinter.PhotoImage(master=self, file=r"C:\Users\abrig\Documents\BWS\BWS\Doomsday Counter\play.png")

        # Home urls
        # Resampling.LANCZOS
        self.image_button_play = ImageTk.PhotoImage(master=self, image=PIL.Image.open(
            r"./images/play.png").resize((25, 25), Image.ANTIALIAS))
        self.image_button_pause = ImageTk.PhotoImage(master=self, image=PIL.Image.open(
            r"./images/pause.png").resize((25, 25), Image.ANTIALIAS))
        self.image_button_left = ImageTk.PhotoImage(master=self, image=PIL.Image.open(
            r"./images/left.png").resize((25, 25), Image.ANTIALIAS))
        self.image_button_right = ImageTk.PhotoImage(master=self, image=PIL.Image.open(
            r"./images/right.png").resize((25, 25), Image.ANTIALIAS))
        self.image_button_search = ImageTk.PhotoImage(master=self, image=PIL.Image.open(
            r"./images/search.png").resize((25, 25), Image.ANTIALIAS))
        self.image_button_exit = ImageTk.PhotoImage(master=self, image=PIL.Image.open(
            r"./images/exit.png").resize((25, 25), Image.ANTIALIAS))
        self.image_button_last = ImageTk.PhotoImage(master=self, image=PIL.Image.open(
            r"./images/last.png").resize((25, 25), Image.ANTIALIAS))
        self.image_button_stop = ImageTk.PhotoImage(master=self, image=PIL.Image.open(
            r"./images/stop.png").resize((25, 25), Image.ANTIALIAS))
        self.image_button_add = ImageTk.PhotoImage(master=self, image=PIL.Image.open(
            r"./images/add.png").resize((25, 25), Image.ANTIALIAS))
        self.image_button_reset = ImageTk.PhotoImage(master=self, image=PIL.Image.open(
            r"./images/reset.png").resize((25, 25), Image.ANTIALIAS))

        self.image_button_play_orange_accent = ImageTk.PhotoImage(master=self, image=PIL.Image.open(
            r"./images/play_orange_accent.png").resize((25, 25), Image.ANTIALIAS))
        self.image_button_pause_orange_accent = ImageTk.PhotoImage(master=self, image=PIL.Image.open(
            r"./images/pause_orange_accent.png").resize((25, 25), Image.ANTIALIAS))
        self.image_button_left_orange_accent = ImageTk.PhotoImage(master=self, image=PIL.Image.open(
            r"./images/left_orange_accent.png").resize((25, 25), Image.ANTIALIAS))
        self.image_button_right_orange_accent = ImageTk.PhotoImage(master=self, image=PIL.Image.open(
            r"./images/right_orange_accent.png").resize((25, 25), Image.ANTIALIAS))
        self.image_button_search_orange_accent = ImageTk.PhotoImage(master=self, image=PIL.Image.open(
            r"./images/search_orange_accent.png").resize((25, 25), Image.ANTIALIAS))
        self.image_button_exit_orange_accent = ImageTk.PhotoImage(master=self, image=PIL.Image.open(
            r"./images/exit_orange_accent.png").resize((25, 25), Image.ANTIALIAS))
        self.image_button_last_orange_accent = ImageTk.PhotoImage(master=self, image=PIL.Image.open(
            r"./images/last_orange_accent.png").resize((25, 25), Image.ANTIALIAS))
        self.image_button_stop_orange_accent = ImageTk.PhotoImage(master=self, image=PIL.Image.open(
            r"./images/stop_orange_accent.png").resize((25, 25), Image.ANTIALIAS))
        self.image_button_add_orange_accent = ImageTk.PhotoImage(master=self, image=PIL.Image.open(
            r"./images/add_orange_accent.png").resize((25, 25), Image.ANTIALIAS))
        self.image_button_reset_orange_accent = ImageTk.PhotoImage(master=self, image=PIL.Image.open(
            r"./images/reset_orange_accent.png").resize((25, 25), Image.ANTIALIAS))


        # BWS urls
        # self.image_button_play = ImageTk.PhotoImage(master=self, image=PIL.Image.open(r"C:\Users\ABriggs\Documents\BWS\Doomsday Counter\play.png").resize((25, 25), Image.ANTIALIAS))
        # self.image_button_pause = ImageTk.PhotoImage(master=self, image=PIL.Image.open(r"C:\Users\ABriggs\Documents\BWS\Doomsday Counter\pause.png").resize((25, 25), Image.ANTIALIAS))
        # self.image_button_left = ImageTk.PhotoImage(master=self, image=PIL.Image.open(r"C:\Users\ABriggs\Documents\BWS\Doomsday Counter\left.png").resize((25, 25), Image.ANTIALIAS))
        # self.image_button_right = ImageTk.PhotoImage(master=self, image=PIL.Image.open(r"C:\Users\ABriggs\Documents\BWS\Doomsday Counter\right.png").resize((25, 25), Image.ANTIALIAS))
        # self.image_button_search = ImageTk.PhotoImage(master=self, image=PIL.Image.open(r"C:\Users\ABriggs\Documents\BWS\Doomsday Counter\search.png").resize((25, 25), Image.ANTIALIAS))
        # self.image_button_exit = ImageTk.PhotoImage(master=self, image=PIL.Image.open(r"C:\Users\ABriggs\Documents\BWS\Doomsday Counter\exit.png").resize((25, 25), Image.ANTIALIAS))
        # self.image_button_last = ImageTk.PhotoImage(master=self, image=PIL.Image.open(r"C:\Users\ABriggs\Documents\BWS\Doomsday Counter\last.png").resize((25, 25), Image.ANTIALIAS))
        # self.image_button_stop = ImageTk.PhotoImage(master=self, image=PIL.Image.open(r"C:\Users\ABriggs\Documents\BWS\Doomsday Counter\stop.png").resize((25, 25), Image.ANTIALIAS))
        # self.image_button_reset = ImageTk.PhotoImage(master=self, image=PIL.Image.open(r"C:\Users\ABriggs\Documents\BWS\Doomsday Counter\reset.png").resize((25, 25), Image.ANTIALIAS))
        #
        # self.image_button_play_orange_accent = ImageTk.PhotoImage(master=self, image=PIL.Image.open(r"C:\Users\ABriggs\Documents\BWS\Doomsday Counter\play_orange_accent.png").resize((25, 25), Image.ANTIALIAS))
        # self.image_button_pause_orange_accent = ImageTk.PhotoImage(master=self, image=PIL.Image.open(r"C:\Users\ABriggs\Documents\BWS\Doomsday Counter\pause_orange_accent.png").resize((25, 25), Image.ANTIALIAS))
        # self.image_button_left_orange_accent = ImageTk.PhotoImage(master=self, image=PIL.Image.open(r"C:\Users\ABriggs\Documents\BWS\Doomsday Counter\left_orange_accent.png").resize((25, 25), Image.ANTIALIAS))
        # self.image_button_right_orange_accent = ImageTk.PhotoImage(master=self, image=PIL.Image.open(r"C:\Users\ABriggs\Documents\BWS\Doomsday Counter\right_orange_accent.png").resize((25, 25), Image.ANTIALIAS))
        # self.image_button_search_orange_accent = ImageTk.PhotoImage(master=self, image=PIL.Image.open(r"C:\Users\ABriggs\Documents\BWS\Doomsday Counter\search_orange_accent.png").resize((25, 25), Image.ANTIALIAS))
        # self.image_button_exit_orange_accent = ImageTk.PhotoImage(master=self, image=PIL.Image.open(r"C:\Users\ABriggs\Documents\BWS\Doomsday Counter\exit_orange_accent.png").resize((25, 25), Image.ANTIALIAS))
        # self.image_button_last_orange_accent = ImageTk.PhotoImage(master=self, image=PIL.Image.open(r"C:\Users\ABriggs\Documents\BWS\Doomsday Counter\last_orange_accent.png").resize((25, 25), Image.ANTIALIAS))
        # self.image_button_stop_orange_accent = ImageTk.PhotoImage(master=self, image=PIL.Image.open(r"C:\Users\ABriggs\Documents\BWS\Doomsday Counter\stop_orange_accent.png").resize((25, 25), Image.ANTIALIAS))
        # self.image_button_add_orange_accent = ImageTk.PhotoImage(master=self, image=PIL.Image.open(r"C:\Users\ABriggs\Documents\BWS\Doomsday Counter\add_orange_accent.png").resize((25, 25), Image.ANTIALIAS))
        # self.image_button_reset_orange_accent = ImageTk.PhotoImage(master=self, image=PIL.Image.open(r"C:\Users\ABriggs\Documents\BWS\Doomsday Counter\reset_orange_accent.png").resize((25, 25), Image.ANTIALIAS))


        self.timer_units = ["Years", "Months", "Fortnights", "Weeks", "Days", "Hours", "Minutes", "Seconds"]

        self.frame_back = Frame(self, background=rgb_to_hex(RED))
        self.frame_desc = Frame(self.frame_back, background=rgb_to_hex(GREEN))
        self.frame_details = Frame(self.frame_back, background=rgb_to_hex(BLUE))
        self.frame_timer = Frame(self.frame_back, background=rgb_to_hex(PINK))
        self.frame_controls = Frame(self.frame_back, background=rgb_to_hex(YELLOW_3))
        self.frame_records = Frame(self.frame_back, background=rgb_to_hex(PALETURQUOISE_1))

        self.sv_label_state = StringVar(self, value="None")
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
        self.sv_btn_pause = StringVar(self, value="pause")
        self.sv_btn_left = StringVar(self, value="left")
        self.sv_btn_right = StringVar(self, value="right")
        self.sv_btn_search = StringVar(self, value="search")
        self.sv_btn_exit = StringVar(self, value="exit")
        self.sv_btn_last = StringVar(self, value="last")
        self.sv_btn_stop = StringVar(self, value="stop")
        self.sv_btn_add = StringVar(self, value="add")
        self.sv_btn_reset = StringVar(self, value="reset")

        self.label_desc_desc = Label(self.frame_desc, textvariable=self.sv_label_desc_desc)
        self.label_state = Label(self.frame_desc, textvariable=self.sv_label_state)

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

        self.entry_timer_all = Entry(self.frame_timer, textvariable=self.sv_entry_timer_all, width=60)
        self.entry_timer_current = Entry(self.frame_timer, textvariable=self.sv_entry_timer_current, width=60)

        self.combo_timer_unit = ttk.Combobox(self.frame_timer, textvariable=self.sv_entry_timer_unit,
                                             values=self.timer_units)

        self.button_gsms = {
            "pause": GSM(name="pause", options=[
                self.image_button_pause,
                self.image_button_pause_orange_accent
            ]),
            "play": GSM(name="play", options=[
                self.image_button_play,
                self.image_button_play_orange_accent
            ]),
            "left": GSM(name="left", options=[
                self.image_button_left,
                self.image_button_left_orange_accent
            ]),
            "right": GSM(name="right", options=[
                self.image_button_right,
                self.image_button_right_orange_accent
            ]),
            "stop": GSM(name="stop", options=[
                self.image_button_stop,
                self.image_button_stop_orange_accent
            ]),
            "search": GSM(name="search", options=[
                self.image_button_search,
                self.image_button_search_orange_accent
            ]),
            "exit": GSM(name="exit", options=[
                self.image_button_exit,
                self.image_button_exit_orange_accent
            ]),
            "add": GSM(name="add", options=[
                self.image_button_add,
                self.image_button_add_orange_accent
            ]),
            "last": GSM(name="last", options=[
                self.image_button_last,
                self.image_button_last_orange_accent
            ]),
            "reset": GSM(name="reset", options=[
                self.image_button_reset,
                self.image_button_reset_orange_accent
            ])
        }
        self.button_gsms["play"].bind_callback(self.change_button, "play", all_states=True)
        self.button_gsms["pause"].bind_callback(self.change_button, "pause", all_states=True)
        self.button_gsms["left"].bind_callback(self.change_button, "left", all_states=True)
        self.button_gsms["right"].bind_callback(self.change_button, "right", all_states=True)
        self.button_gsms["search"].bind_callback(self.change_button, "search", all_states=True)
        self.button_gsms["exit"].bind_callback(self.change_button, "exit", all_states=True)
        self.button_gsms["reset"].bind_callback(self.change_button, "reset", all_states=True)
        self.button_gsms["last"].bind_callback(self.change_button, "last", all_states=True)
        self.button_gsms["add"].bind_callback(self.change_button, "add", all_states=True)

        self.button_play = Button(self.frame_controls, textvariable=self.sv_btn_play, image=self.button_gsms["play"].state(),
                                  command=self.btn_play_clicked)
        self.button_pause = Button(self.frame_controls, textvariable=self.sv_btn_pause, image=self.button_gsms["pause"].state(),
                                   command=self.btn_pause_clicked)
        self.button_left = Button(self.frame_controls, textvariable=self.sv_btn_left, image=self.button_gsms["left"].state(),
                                  command=self.btn_left_clicked)
        self.button_right = Button(self.frame_controls, textvariable=self.sv_btn_right, image=self.button_gsms["right"].state(),
                                   command=self.btn_right_clicked)
        self.button_search = Button(self.frame_controls, textvariable=self.sv_btn_search,
                                    image=self.button_gsms["search"].state(), command=self.btn_search_clicked)
        self.button_exit = Button(self.frame_controls, textvariable=self.sv_btn_exit, image=self.button_gsms["exit"].state(),
                                  command=self.btn_exit_clicked)
        self.button_last = Button(self.frame_controls, textvariable=self.sv_btn_last, image=self.button_gsms["last"].state(),
                                  command=self.btn_last_clicked)
        self.button_stop = Button(self.frame_controls, textvariable=self.sv_btn_stop, image=self.button_gsms["stop"].state(),
                                  command=self.btn_stop_clicked)
        self.button_add = Button(self.frame_controls, textvariable=self.sv_btn_add, image=self.button_gsms["add"].state(),
                                 command=self.btn_add_clicked)
        self.button_reset = Button(self.frame_controls, textvariable=self.sv_btn_reset, image=self.button_gsms["reset"].state(),
                                 command=self.btn_reset_clicked)

        ###############################################################################################################
        ###############################################################################################################
        ###############################################################################################################

        self.format_history_date = "%Y-%m-%d %H:%M:%S.%f"
        self.format_tree_view = "%Y-%m-%d %H:%M:%S"
        self.tv_columns = ("WO", "Description", "Start Date", "Completion Date", "Stop Date", "Priority", "Time Elapsed")
        self.tv_column_gsms = [(
            GSM(name=f"GSM_sort_{column}", options=[None, "ASC", "DESC"]),
            GSM(name=f"GSM_order_{column}", options=list(range(len(self.tv_columns)
                                                               )))) for column in self.tv_columns]
        self.tv_cols = (
            {"anchor": tkinter.CENTER, "width": 80},
            {"anchor": tkinter.CENTER, "width": 200},
            {"anchor": tkinter.CENTER, "width": 120},
            {"anchor": tkinter.CENTER, "width": 120},
            {"anchor": tkinter.CENTER, "width": 120},
            {"anchor": tkinter.CENTER, "width": 60},
            {"anchor": tkinter.CENTER, "width": 60}
        )
        self.tree_view = ttk.Treeview(self.frame_records, selectmode="extended")
        self.tv_scroll_bar = tkinter.Scrollbar(self.frame_records, orient=tkinter.VERTICAL)
        self.tree_view.config(yscrollcommand=self.tv_scroll_bar.set)
        self.tv_scroll_bar.config(command=self.tree_view.yview)

        self.tree_view["columns"] = self.tv_columns
        self.tree_view.column("#0", width=0, stretch=tkinter.NO)
        self.tree_view.heading("#0", text="", anchor=tkinter.CENTER)
        for column, col_kwargs in zip(self.tv_columns, self.tv_cols):
            # self.tree_view.column(column, anchor=tkinter.CENTER, width=120)
            self.tree_view.column(column, **col_kwargs)
            self.tree_view.heading(column, text=column, anchor=tkinter.CENTER,
                                   command=lambda col=column: self.treeview_sort_column(col, False))

        self.style_tree_view = ttk.Style(self)
        self.style_tree_view.theme_use("default")
        self.style_tree_view.map("Treeview")

        self.output_file = r"./timer_save.json"
        self.record_id = self.new_record_generator()
        self.records = OrderedDict()
        self.text5 = None
        self.text7 = None
        self.text8 = None
        self.check_history()

        ###############################################################################################################
        ###############################################################################################################
        ###############################################################################################################

        self.frame_back.grid()
        self.frame_desc.grid(row=1, column=1, columnspan=1, rowspan=2)
        self.frame_details.grid(row=1, column=2, columnspan=4, rowspan=3)
        self.frame_timer.grid(row=4, column=2, columnspan=5, rowspan=3)
        self.frame_controls.grid(row=7, column=1, columnspan=12, rowspan=1)
        self.frame_records.grid(row=8, column=1, columnspan=12, rowspan=1)

        self.label_desc_desc.grid(row=1, column=1, columnspan=12, rowspan=1)
        self.label_state.grid(row=6, column=1, columnspan=12, rowspan=1)
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
        self.button_pause.grid(row=1, column=2, columnspan=1, rowspan=1)
        self.button_left.grid(row=1, column=3, columnspan=1, rowspan=1)
        self.button_right.grid(row=1, column=4, columnspan=1, rowspan=1)
        self.button_search.grid(row=1, column=5, columnspan=1, rowspan=1)
        self.button_exit.grid(row=1, column=6, columnspan=1, rowspan=1)
        self.button_last.grid(row=1, column=7, columnspan=1, rowspan=1)
        self.button_stop.grid(row=1, column=8, columnspan=1, rowspan=1)
        self.button_add.grid(row=1, column=9, columnspan=1, rowspan=1)
        self.button_reset.grid(row=1, column=10, columnspan=1, rowspan=1)

        # self.tree_view.grid(row=1, column=1, columnspan=1, rowspan=1)
        # self.tv_scroll_bar.grid(row=1, column=2, columnspan=1, rowspan=1)
        self.tree_view.pack(side=tkinter.LEFT)
        self.tv_scroll_bar.pack(side=tkinter.RIGHT, fill=tkinter.Y)

        if self.records:
            self.set_tree_view_selection([0])

        self.tree_view.bind("<<TreeviewSelect>>", self.click_tree_view)  # call this last to avoid triggering above.
        self.tick()

    # def resizeImage(self, img, newWidth, newHeight):
    #     oldWidth = img.width()
    #     oldHeight = img.height()
    #     newPhotoImage = tkinter.PhotoImage(master=self, width=newWidth, height=newHeight)
    #     for x in range(newWidth):
    #         for y in range(newHeight):
    #             xOld = int(x * oldWidth / newWidth)
    #             yOld = int(y * oldHeight / newHeight)
    #             rgb = '#%02x%02x%02x' % img.get(xOld, yOld)
    #             newPhotoImage.put(rgb, (x, y))
    #     return newPhotoImage

    def new_record_generator(self):
        """Generator object to ensure 10000 unique sequential ids."""
        for i in range(10000):
            yield i

    def check_history(self):
        """Before showing records for the first time, insert historical records."""
        if os.path.exists(self.output_file):
            # read save file contents before initaliziing records
            try:
                with open(self.output_file, 'r') as f:
                    raw_json = json.loads(f.read())
                    # print(f"{raw_json=}")
                    # for key_a, val_a in raw_json.items():
                    #     print(f"{key_a=}")

                    record_data = raw_json['data']
                    self.insert_records(record_data)
                    # for wo, wo_data in record_data.items():

            except KeyError as ke:
                raise KeyError(ke)
        else:
            print(f"No previous history to work with.")

    def insert_records(self, records_in):
        # WO, Description, Start Date, Completion Date, End Date, Priority
        # "10011234": {
        #     "description": "This is a description for WO10011234",
        #     "start_date": "2022-07-26 12:33:57.639974",
        #     "stop_date": "2022-07-26 14:11:15.546327",
        #     "completion_date": "2022-07-26 14:11:15.546327",
        #     "priority": 1
        # }
        assert isinstance(records_in, dict), "Error param 'records_in' must be a dictionary."
        for wo, wo_data in records_in.items():
            iid = self.record_id.__next__()
            wo_desc = wo_data["description"]
            wo_start = datetime.datetime.strptime(wo_data["start_date"], self.format_history_date)
            wo_stop = datetime.datetime.strptime(wo_data["stop_date"], self.format_history_date)
            wo_complete = datetime.datetime.strptime(wo_data["completion_date"], self.format_history_date)
            wo_priority = wo_data["priority"]
            time_elapsed = (wo_stop - wo_start).seconds
            self.records[wo] = {
                "description": wo_desc,
                "start_date": wo_start,
                "stop_date": wo_stop,
                "completion_date": wo_complete,
                "priority": wo_priority,
                "time_elapsed": time_elapsed,
                "gsm": GSM(options=["queue", "play", "pause", "complete"])
            }

            self.set_task_gsm(wo)

            wo_start = wo_start.strftime(self.format_tree_view)
            wo_stop = wo_stop.strftime(self.format_tree_view)
            wo_complete = wo_complete.strftime(self.format_tree_view)
            self.tree_view.insert(parent="", index=iid, iid=iid, text="",
                                  values=(wo, wo_desc, wo_start, wo_stop, wo_complete, wo_priority, time_elapsed))

    def set_task_gsm(self, wo, wo_start=None, wo_stop=None, wo_complete=None):
        gsm = self.records[wo]["gsm"]
        wo_start = wo_start if wo_start is not None else self.records[wo]["start_date"]
        wo_stop = wo_stop if wo_stop is not None else self.records[wo]["stop_date"]
        wo_complete = wo_complete if wo_complete is not None else self.records[wo]["completion_date"]
        if wo_start is not None:
            if wo_stop is not None:
                if wo_complete is not None:
                    assert wo_start <= wo_stop <= wo_complete, f"Error in date logic, {wo_start=}, {wo_stop=}, {wo_complete=}"
                    gsm.set_state("complete")
                else:
                    gsm.set_state("pause")
            else:
                gsm.set_state("play")
        else:
            gsm.set_state("queue")
        "queue", "play", "pause", "complete"

    def update_record(self, row, wo):
        # copy changes from self.records to treeview.
        self.tree_view.item(row, values=(
            wo,
            self.records[wo]["description"],
            self.records[wo]["start_date"],
            self.records[wo]["stop_date"],
            self.records[wo]["completion_date"],
            self.records[wo]["priority"],
            self.records[wo]["time_elapsed"]
        ))

    def treeview_sort_column(self, col, reverse):
        """https://stackoverflow.com/questions/1966929/tk-treeview-column-sort"""

        idx = self.tv_columns.index(col)
        gsm_sort, gsm_order = self.tv_column_gsms[idx]
        if gsm_sort.state() == "DESC":
            gsm_sort.__next__()
            self.tree_view.heading(col, text=col, command=lambda colu=col, rev=False: self.treeview_sort_column(colu, rev))
            return
        l = [[self.tree_view.set(k, column) for column in self.tv_columns] + [k] for k in self.tree_view.get_children('')]
        print(f"{l=}")
        # l.sort(reverse=reverse, key=lambda tup: tup[idx])

        gsm_sort.__next__()
        sort_idxs = []
        directions = []
        for i, column in enumerate(self.tv_columns):
            state = self.tv_column_gsms[i][0].state()
            print(f"\t\t\t{column=}, {state=}")
            match state:
                case "ASC":
                    sort_idxs.append(i)
                    directions.append(1)
                case "DESC":
                    sort_idxs.append(i)
                    directions.append(-1)

        print(f" {sort_idxs=}")
        print(f"{directions=}")
        print_by_line([l[0][ix] * direct for ix, direct in zip(sort_idxs, directions)])

        l.sort(reverse=reverse, key=lambda tup: [tup[ix] for ix, direct in zip(sort_idxs, directions)])



        if reverse:
            print(f"\nDO REVERSE\n")

        # rearrange items in sorted positions
        for index, (*vals, k) in enumerate(l):
            self.tree_view.move(k, '', index)

        # new_text = col + (" ASC" if not reverse else " DESC")
        # print(f"sorting by {col=}" + (" ASC" if not reverse else " DESC"))

        # reverse sort next time
        # self.tree_view.heading(col, text=new_text,
        #                        command=lambda colu=col: self.treeview_sort_column(colu, not reverse))

        for i, column in enumerate(self.tv_columns):
            gsm_sort, gsm_order = self.tv_column_gsms[i]
            state = gsm_sort.state()
            new_reverse = state == "ASC"
            print(f"{col=}, {column=}")
            if column == col:
                # gsm_sort.__next__()
                state = gsm_sort.state()
                new_reverse = state == "ASC"
                print(f"\tSelected gsm: {state}")
                print(f"\t{new_reverse=}")
            print(f"{new_reverse=}")
            suffix = (" " + state) if state is not None else ""
            self.tree_view.heading(column, text=column + suffix, command=lambda colu=column, rev=new_reverse: self.treeview_sort_column(colu, rev))

    def set_detail(self, wo):
        # wo, wo_desc, wo_start_date, wo_stop_date, wo_completion_date, wo_priority = temp
        wo_desc = self.records[wo]["description"]
        wo_start_date = self.records[wo]["start_date"]
        wo_stop_date = self.records[wo]["stop_date"]
        wo_completion_date = self.records[wo]["completion_date"]
        wo_priority = self.records[wo]["priority"]
        self.sv_entry_detail_wo.set(wo)
        self.sv_entry_desc_desc.set(wo_desc)
        self.sv_entry_detail_start_date.set(wo_start_date)
        self.sv_entry_detail_stop_date.set(wo_stop_date)
        self.sv_entry_detail_completion_date.set(wo_completion_date)
        self.sv_entry_detail_priority.set(wo_priority)
        self.sv_entry_timer_current.set(self.gen_current_time(wo_start_date, wo_stop_date))
        self.sv_entry_timer_all.set(self.gen_all_time(wo_start_date, wo_stop_date))

    def update_detail(self):
        # selected = self.tree_view.focus()
        # if selected:
            # temp = self.tree_view.item(selected, 'values')
        task = self.get_selected_task()
        if task:
            wo, wo_desc, wo_start_date, wo_stop_date, wo_completion_date, wo_priority, wo_time_elapsed = task
            self.set_detail(wo)

    def calc_diff(self, d1, d2):
        if isinstance(d1, str):
            d1 = datetime.datetime.strptime(d1, self.format_history_date)
        if isinstance(d2, str):
            d2 = datetime.datetime.strptime(d2, self.format_history_date)
        print(f"{d1=}, {d2=}, {type(d1)=}, {type(d2)}")
        return (d2 - d1).seconds

    def multiple_suffix(self, n):
        return "s" if n != 1 else ""

    def gen_all_time(self, d1, d2):
        if d1 is not None and d2 is not None:
            diff = self.calc_diff(d1, d2)
            spy_f = 60 * 60 * 24 * 365.25
            spy_i = int(spy_f)
            years, rem = divmod(diff, spy_i)
            months, rem = divmod(rem, int(spy_f / 12))
            fortnights, rem = divmod(rem, int(spy_f / 26))
            weeks, rem = divmod(rem, int(spy_f / 52))
            days, rem = divmod(rem, 60 * 60 * 24)
            hours, rem = divmod(rem, 60 * 60)
            minutes, rem = divmod(rem, 60)
            seconds = rem
            result = f"ALL: {years=}, {months=}, {fortnights=}, {weeks=}, {days=}, {hours=}, {minutes=}, {seconds=}"

            result = f"{years} year{self.multiple_suffix(years)} + {months} month{self.multiple_suffix(months)} + {fortnights} fortnight{self.multiple_suffix(fortnights)} + {weeks} week{self.multiple_suffix(weeks)} + {days} day{self.multiple_suffix(days)} + {hours} hour{self.multiple_suffix(hours)} + {minutes} minute{self.multiple_suffix(minutes)} + {seconds} second{self.multiple_suffix(seconds)}"
            # print(result)
        else:
            result = "NONE"
        return result

    def gen_current_time(self, d1, d2):
        if d1 is not None and d2 is not None:
            diff = self.calc_diff(d1, d2)
            spy_f = 60 * 60 * 24 * 365.25
            spy_i = int(spy_f)
            years, months, fortnights, weeks, days, hours, minutes, seconds = 0, 0, 0, 0, 0, 0, 0, 0
            match self.sv_entry_timer_unit.get():
                case "Years":
                    n, rem = divmod(diff, spy_i)
                    result = f"{n} year{self.multiple_suffix(n)}"
                case "Months":
                    n, rem = divmod(diff, int(spy_f / 12))
                    result = f"{n} month{self.multiple_suffix(n)}"
                case "Fortnights":
                    n, rem = divmod(diff, int(spy_f / 26))
                    result = f"{n} fortnight{self.multiple_suffix(n)}"
                case "Weeks":
                    n, rem = divmod(diff, int(spy_f / 52))
                    result = f"{n} week{self.multiple_suffix(n)}"
                case "Days":
                    n, rem = divmod(diff, 60 * 60 * 24)
                    result = f"{n} day{self.multiple_suffix(n)}"
                case "Hours":
                    n, rem = divmod(diff, 60 * 60)
                    result = f"{n} hour{self.multiple_suffix(n)}"
                case "Minutes":
                    n, rem = divmod(diff, 60)
                    result = f"{n} minute{self.multiple_suffix(n)}"
                case _:
                    n = diff
                    result = f"{n} second{self.multiple_suffix(n)}"

            # result = f"CURRENT: {years=}, {months=}, {fortnights=}, {weeks=}, {days=}, {hours=}, {minutes=}, {seconds=}"
            # result =
            # print(result)
            return result
        else:
            return "NONE"

    def btn_play_clicked(self):
        print(f"btn_play_clicked")
        self.sv_label_state.set("playing")
        result = self.get_selected_task()
        if result:
            wo, wo_desc, wo_start_date, wo_stop_date, wo_completion_date, wo_priority, wo_time_elapsed = result
            print(f"{wo=}")
            if wo_completion_date is not None:
                answer = self.ask_y_n_c(message="This task is already marked complete. Are you sure you want to record more time on this task?")
                if isinstance(answer, bool):
                    if answer:
                        self.records[wo]["completion_date"] = None
                        self.records[wo]["stop_date"] = None
                    else:
                        # does not want to keep working on this task
                        pass
            else:
                print(f"else")
                if wo_stop_date is not None:
                    answer = self.ask_y_n_c(
                        message="This task has already been stopped. Are you sure you want to record more time on this task?")
                    if isinstance(answer, bool):
                        if answer:
                            self.records[wo]["completion_date"] = None
                            self.records[wo]["stop_date"] = None
                            print(f"CLEARING")
                        else:
                            # does not want to keep working on this task
                            pass

            if wo_start_date is None:
                self.records[wo]["start_date"] = datetime.datetime.now()

            if self.text7 is None:
                self.text7 = datetime.datetime.now()
                self.records[wo]["start_date"] = self.text7

            if self.text7 == "":
                self.text7 = datetime.datetime.now()
                self.records[wo]["start_date"] = self.text7
            else:
                if self.text8 is None:
                    self.text8 = datetime.datetime.now()
                elif self.text8 == "":
                    self.text8 = datetime.datetime.now()
                offset = (self.text8 - self.text7).seconds
                self.text7 += datetime.timedelta(seconds=offset)
                # self.records[wo]["stop_date"] = self.text8
            # if self.text8 is None:
            #     self.text8 = datetime.datetime.now()
            # offset = 0
            # offset =

            self.text8 = ""
            self.set_detail(wo)
            self.update_detail()
        else:
            self.inform_task_selection_needed()

    def btn_pause_clicked(self):
        self.sv_label_state.set("paused")
        print(f"btn_pause_clicked")
        result = self.get_selected_task()
        if result:
            wo, wo_desc, wo_start_date, wo_stop_date, wo_completion_date, wo_priority, wo_time_elapsed = result

            self.text8 = datetime.datetime.now()
            self.records[wo]["stop_date"] = datetime.datetime.now()

            self.set_detail(wo)
            self.update_detail()
        else:
            self.inform_task_selection_needed()

    def btn_left_clicked(self):
        print(f"btn_left_clicked")

    def btn_right_clicked(self):
        print(f"btn_right_clicked")

    def btn_search_clicked(self):
        print(f"btn_search_clicked")

    def btn_exit_clicked(self):
        print(f"btn_exit_clicked")

    def btn_last_clicked(self):
        print(f"btn_last_clicked")

    def btn_stop_clicked(self):
        self.sv_label_state.set("stopped")
        print(f"btn_stop_clicked")

        result = self.get_selected_task()
        if result:
            wo, wo_desc, wo_start_date, wo_stop_date, wo_completion_date, wo_priority, wo_time_elapsed = result

            self.text8 = datetime.datetime.now()
            self.records[wo]["stop_date"] = self.text8
            next(self.button_gsms["stop"])
            self.change_button("stop")

            answer_1 = tkinter.messagebox.askokcancel(message="Are you sure you want to stop timing this task?", title="Complete task?")
            if answer_1:
                self.records[wo]["stop_date"] = datetime.datetime.now()
                answer_2 = tkinter.messagebox.askyesno(message="Do you want to mark this task as complete?", title="Complete task?")
                match answer_2:
                    case True:
                        self.records[wo]["completion_date"] = datetime.datetime.now()
                        tkinter.messagebox.Message("Task completed successfully!")
                    case False:
                        self.records[wo]["completion_date"] = None
                        tkinter.messagebox.Message("Task successfully stopped!")
                    case _:
                        pass

            self.set_detail(wo)
            self.update_detail()
        else:
            self.inform_task_selection_needed()

    def btn_add_clicked(self):
        print(f"btn_add_clicked")

    def btn_reset_clicked(self):
        self.sv_label_state.set("reset")
        print(f"btn_reset_clicked")

        result = self.get_selected_task()
        if result:
            wo, wo_desc, wo_start_date, wo_stop_date, wo_completion_date, wo_priority, wo_time_elapsed = result

            self.text7 = datetime.datetime.now()
            self.records[wo]["start_date"] = self.text7
            self.text8 = datetime.datetime.now()
            self.records[wo]["stop_date"] = self.text8
            next(self.button_gsms["reset"])
            self.set_detail(wo)
            self.update_detail()
        else:
            self.inform_task_selection_needed()

    def change_button(self, button_name, state_in=None):
        # print(f"configuring {self.button_gsms[button_name].state()}")
        match button_name:
            case "play":
                btn = self.button_play #.config(image=self.button_gsms["play"].state())
                # gsm = self.button_gsms["play"]
            case "pause":
                btn = self.button_pause
                # self.button_pause.config(image=self.button_gsms["pause"].state())
            case "left":
                btn = self.button_left
                # self.button_left.config(image=self.button_gsms["left"].state())
            case "right":
                btn = self.button_right
                # self.button_right.config(image=self.button_gsms["right"].state())
            case "search":
                btn = self.button_search
                # self.button_search.config(image=self.button_gsms["search"].state())
            case "exit":
                btn = self.button_exit
                # self.button_exit.config(image=self.button_gsms["exit"].state())
            case "last":
                btn = self.button_last
                # self.button_last.config(image=self.button_gsms["last"].state())
            case "reset":
                btn = self.button_reset
                # self.button_reset.config(image=self.button_gsms["reset"].state())
            case "add":
                btn = self.button_add
                # self.button_add.config(image=self.button_gsms["add"].state())
            case "stop":
                btn = self.button_stop
                # self.button_stop.config(image=self.button_gsms["stop"].state())
            case _:
                raise ValueError(f"Param 'button_name' must be an existing button name got'{button_name}'")
        if state_in is not None:
            self.button_gsms[button_name].set_state(state_in)
        btn.config(image=self.button_gsms[button_name].state())

    def inform_task_selection_needed(self, message=None, append=False):
        default = "Error you must select a task from the table first."
        r_message = message if message is not None else default
        if append and message:
            r_message = default + "\n" + message
        tkinter.messagebox.showerror(title="Selection Needed", message=r_message)

    def ask_y_n_c(self, message, options=None):
        answer = tkinter.messagebox.askyesnocancel(message=message)
        print(f"{answer=}")
        return answer

    def get_selected_task(self, i_wo=False, i_wo_desc=False, i_wo_start_date=False, i_wo_stop_date=False, i_wo_completion_date=False, i_wo_priority=False, i_wo_time_elapsed=False):
        selected = self.tree_view.focus()
        result = self.tree_view.item(selected, 'values')
        if result:
            temp = tuple()
            wo, wo_desc, wo_start_date, wo_stop_date, wo_completion_date, wo_priority, wo_time_elapsed = result
            if i_wo:
                temp = (wo)
            if i_wo_desc:
                temp = (*temp, wo_desc)
            if i_wo_start_date:
                temp = (*temp, wo_start_date)
            if i_wo_stop_date:
                temp = (*temp, wo_stop_date)
            if i_wo_completion_date:
                temp = (*temp, wo_completion_date)
            if i_wo_priority:
                temp = (*temp, wo_priority)
            if i_wo_time_elapsed:
                temp = (*temp, wo_time_elapsed)
            if not temp:
                temp = result
            return temp

    def click_tree_view(self, event):
        print(f"click_tree_view", event)
        # selected = self.tree_view.selection()[0]
        # print(f"{selected=}")

        # selected = self.get_selected_task()
        old_wo = self.sv_entry_detail_wo.get()
        temp = self.get_selected_task()
        print(f"BEFORE FROM {old_wo} to {temp}")
        if temp:
            wo, wo_desc, wo_start_date, wo_stop_date, wo_completion_date, wo_priority, wo_time_elapsed = temp
            print(f"GOING FROM {old_wo} to {wo}")
            # if old_wo != wo:
            #     self.text7 = None
            #     self.text8 = None
            self.set_detail(wo)
            # self.sv_entry_detail_wo.set(wo)
            # self.sv_entry_desc_desc.set(wo_desc)
            # self.sv_entry_detail_start_date.set(wo_start_date)
            # self.sv_entry_detail_stop_date.set(wo_stop_date)
            # self.sv_entry_detail_completion_date.set(wo_completion_date)
            # self.sv_entry_detail_priority.set(wo_priority)
            print(f"{temp=}")

            # for index in selected:
            # count, index = event.count, event.index
            # print(f"{count=}, {index=}")
        else:
            tkinter.messagebox.showerror(title="Nothing Selected", message="Error, no selection has been made on the treeview.")

    def set_tree_view_selection(self, iid):
        # self.tree_view.focus_set()
        # print(f"A {self.get_selected_task() =}, {selected =}")
        self.tree_view.selection_add(iid)
        selected = self.tree_view.focus(str(0))  # without this call, the binding of on selection change for this widget breaks.
        # selected = self.tree_view.focus()
        # wo = list(self.records.keys())[0]
        wo = self.get_selected_task(i_wo=True)
        self.set_detail(wo)
        self.update_record(0, wo)
        print(f"B {self.get_selected_task() =}, {selected =}")

    def tick(self):
        print(f"{self.text7=}, {self.text8=}")

        self.change_button("play", state_in=0)
        self.change_button("pause", state_in=0)
        self.change_button("stop", state_in=0)
        self.change_button("reset", state_in=0)
        # self.button_gsms["play"].set_state(0)
        # self.button_gsms["pause"].set_state(0)
        # self.button_gsms["stop"].set_state(0)
        # # self.button_gsms["reset"].set_state(0)
        if lenstr(self.text7) != 0 and lenstr(self.text8) != 0:
            print("AAAAA")
            next(self.button_gsms["pause"])
        elif lenstr(self.text7) != 0:
            next(self.button_gsms["play"])

        selected = self.get_selected_task()
        if self.text8 is not None and lenstr(self.text8) != 0 and selected:
            if self.text7 is None:
                self.text7 = datetime.datetime.now()
            wo, wo_desc, wo_start_date, wo_stop_date, wo_completion_date, wo_priority, wo_time_elapsed = selected
            self.text7 = self.text7 + datetime.timedelta(seconds=1)
            self.records[wo]["start_date"] = self.text7
            print(f"{self.text8 =}")
            self.text8 = self.text8 + datetime.timedelta(seconds=1)
            self.records[wo]["stop_date"] = self.text8
            self.set_detail(wo)

        for i in range(len(self.records)):
            wo = self.tree_view.item(i, "values")[0]
        # for wo, wo_dat in self.records.items():
            wo_dat = self.records[wo]
            if wo_dat["start_date"] is not None:
                if wo_dat["stop_date"] is not None:
                    self.records[wo]["start_date"] += datetime.timedelta(seconds=1)
                    self.records[wo]["stop_date"] += datetime.timedelta(seconds=1)
                    self.update_record(i, wo)

        self.update_detail()
        self.after(1000, self.tick)


if __name__ == "__main__":
    # test_2()
    # test_3()

    Timer().mainloop()

    # test_4()
