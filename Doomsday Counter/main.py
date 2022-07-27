# import tkinter as tk
import json
import os.path
import tkinter

import datetime
from tkinter import Button, Label, Frame, StringVar, Tk, Entry

import PIL
from PIL import ImageTk, Image
from tkinter import ttk
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
            r"C:\Users\abrig\Documents\BWS\BWS\Doomsday Counter\play.png").resize((25, 25), Image.ANTIALIAS))
        self.image_button_pause = ImageTk.PhotoImage(master=self, image=PIL.Image.open(
            r"C:\Users\abrig\Documents\BWS\BWS\Doomsday Counter\pause.png").resize((25, 25), Image.ANTIALIAS))
        self.image_button_left = ImageTk.PhotoImage(master=self, image=PIL.Image.open(
            r"C:\Users\abrig\Documents\BWS\BWS\Doomsday Counter\left.png").resize((25, 25), Image.ANTIALIAS))
        self.image_button_right = ImageTk.PhotoImage(master=self, image=PIL.Image.open(
            r"C:\Users\abrig\Documents\BWS\BWS\Doomsday Counter\right.png").resize((25, 25), Image.ANTIALIAS))
        self.image_button_search = ImageTk.PhotoImage(master=self, image=PIL.Image.open(
            r"C:\Users\abrig\Documents\BWS\BWS\Doomsday Counter\search.png").resize((25, 25), Image.ANTIALIAS))
        self.image_button_exit = ImageTk.PhotoImage(master=self, image=PIL.Image.open(
            r"C:\Users\abrig\Documents\BWS\BWS\Doomsday Counter\exit.png").resize((25, 25), Image.ANTIALIAS))
        self.image_button_last = ImageTk.PhotoImage(master=self, image=PIL.Image.open(
            r"C:\Users\abrig\Documents\BWS\BWS\Doomsday Counter\last.png").resize((25, 25), Image.ANTIALIAS))
        self.image_button_stop = ImageTk.PhotoImage(master=self, image=PIL.Image.open(
            r"C:\Users\abrig\Documents\BWS\BWS\Doomsday Counter\stop.png").resize((25, 25), Image.ANTIALIAS))
        self.image_button_add = ImageTk.PhotoImage(master=self, image=PIL.Image.open(
            r"C:\Users\abrig\Documents\BWS\BWS\Doomsday Counter\add.png").resize((25, 25), Image.ANTIALIAS))

        # BWS urls
        # self.image_button_play = ImageTk.PhotoImage(master=self, image=PIL.Image.open(r"C:\Users\ABriggs\Documents\BWS\Doomsday Counter\play.png").resize((25, 25), Image.ANTIALIAS))
        # self.image_button_pause = ImageTk.PhotoImage(master=self, image=PIL.Image.open(r"C:\Users\ABriggs\Documents\BWS\Doomsday Counter\pause.png").resize((25, 25), Image.ANTIALIAS))
        # self.image_button_left = ImageTk.PhotoImage(master=self, image=PIL.Image.open(r"C:\Users\ABriggs\Documents\BWS\Doomsday Counter\left.png").resize((25, 25), Image.ANTIALIAS))
        # self.image_button_right = ImageTk.PhotoImage(master=self, image=PIL.Image.open(r"C:\Users\ABriggs\Documents\BWS\Doomsday Counter\right.png").resize((25, 25), Image.ANTIALIAS))
        # self.image_button_search = ImageTk.PhotoImage(master=self, image=PIL.Image.open(r"C:\Users\ABriggs\Documents\BWS\Doomsday Counter\search.png").resize((25, 25), Image.ANTIALIAS))
        # self.image_button_exit = ImageTk.PhotoImage(master=self, image=PIL.Image.open(r"C:\Users\ABriggs\Documents\BWS\Doomsday Counter\exit.png").resize((25, 25), Image.ANTIALIAS))
        # self.image_button_last = ImageTk.PhotoImage(master=self, image=PIL.Image.open(r"C:\Users\ABriggs\Documents\BWS\Doomsday Counter\last.png").resize((25, 25), Image.ANTIALIAS))
        # self.image_button_stop = ImageTk.PhotoImage(master=self, image=PIL.Image.open(r"C:\Users\ABriggs\Documents\BWS\Doomsday Counter\stop.png").resize((25, 25), Image.ANTIALIAS))
        # self.image_button_add = ImageTk.PhotoImage(master=self, image=PIL.Image.open(r"C:\Users\ABriggs\Documents\BWS\Doomsday Counter\add.png").resize((25, 25), Image.ANTIALIAS))

        self.timer_units = ["Years", "Months", "Fortnights", "Weeks", "Days", "Hours", "Minutes", "Seconds"]

        self.frame_back = Frame(self, background=rgb_to_hex(RED))
        self.frame_desc = Frame(self.frame_back, background=rgb_to_hex(GREEN))
        self.frame_details = Frame(self.frame_back, background=rgb_to_hex(BLUE))
        self.frame_timer = Frame(self.frame_back, background=rgb_to_hex(PINK))
        self.frame_controls = Frame(self.frame_back, background=rgb_to_hex(YELLOW_3))
        self.frame_records = Frame(self.frame_back, background=rgb_to_hex(PALETURQUOISE_1))

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

        self.combo_timer_unit = ttk.Combobox(self.frame_timer, textvariable=self.sv_entry_timer_unit,
                                             values=self.timer_units)

        self.button_play = Button(self.frame_controls, textvariable=self.sv_btn_play, image=self.image_button_play,
                                  command=self.btn_play_clicked)
        self.button_pause = Button(self.frame_controls, textvariable=self.sv_btn_pause, image=self.image_button_pause,
                                   command=self.btn_pause_clicked)
        self.button_left = Button(self.frame_controls, textvariable=self.sv_btn_left, image=self.image_button_left,
                                  command=self.btn_left_clicked)
        self.button_right = Button(self.frame_controls, textvariable=self.sv_btn_right, image=self.image_button_right,
                                   command=self.btn_right_clicked)
        self.button_search = Button(self.frame_controls, textvariable=self.sv_btn_search,
                                    image=self.image_button_search, command=self.btn_search_clicked)
        self.button_exit = Button(self.frame_controls, textvariable=self.sv_btn_exit, image=self.image_button_exit,
                                  command=self.btn_exit_clicked)
        self.button_last = Button(self.frame_controls, textvariable=self.sv_btn_last, image=self.image_button_last,
                                  command=self.btn_last_clicked)
        self.button_stop = Button(self.frame_controls, textvariable=self.sv_btn_stop, image=self.image_button_stop,
                                  command=self.btn_stop_clicked)
        self.button_add = Button(self.frame_controls, textvariable=self.sv_btn_add, image=self.image_button_add,
                                 command=self.btn_add_clicked)

        ###############################################################################################################
        ###############################################################################################################
        ###############################################################################################################

        self.format_history_date = "%Y-%m-%d %H:%M:%S.%f"
        self.format_tree_view = "%Y-%m-%d %H:%M:%S"
        self.tv_columns = ("WO", "Description", "Start Date", "Completion Date", "Stop Date", "Priority")
        self.tv_column_gsms = [(
            GSM(name=f"GSM_sort_{column}", options=["None", "Asc", "Desc"]),
            GSM(name=f"GSM_order_{column}", options=list(range(len(self.tv_columns)
                                                               )))) for column in self.tv_columns]
        self.tv_cols = (
            {"anchor": tkinter.CENTER, "width": 80},
            {"anchor": tkinter.CENTER, "width": 200},
            {"anchor": tkinter.CENTER, "width": 120},
            {"anchor": tkinter.CENTER, "width": 120},
            {"anchor": tkinter.CENTER, "width": 120},
            {"anchor": tkinter.CENTER, "width": 60}
        )
        self.tree_view = ttk.Treeview(self.frame_records, selectmode="extended")
        self.tv_scroll_bar = tkinter.Scrollbar(self.frame_records, orient=tkinter.VERTICAL)
        self.tree_view.config(yscrollcommand=self.tv_scroll_bar.set)
        self.tv_scroll_bar.config(command=self.tree_view.yview)
        self.tree_view.bind("<<TreeviewSelect>>", self.click_tree_view)

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
        self.records = {}
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

        # self.tree_view.grid(row=1, column=1, columnspan=1, rowspan=1)
        # self.tv_scroll_bar.grid(row=1, column=2, columnspan=1, rowspan=1)
        self.tree_view.pack(side=tkinter.LEFT)
        self.tv_scroll_bar.pack(side=tkinter.RIGHT, fill=tkinter.Y)

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
            self.records[wo] = {
                "description": wo_desc,
                "start_date": wo_start,
                "stop_date": wo_stop,
                "completion_date": wo_complete,
                "priority": wo_priority
            }

            wo_start = wo_start.strftime(self.format_tree_view)
            wo_stop = wo_stop.strftime(self.format_tree_view)
            wo_complete = wo_complete.strftime(self.format_tree_view)
            self.tree_view.insert(parent="", index=iid, iid=iid, text="",
                                  values=(wo, wo_desc, wo_start, wo_stop, wo_complete, wo_priority))

    def update_record(self, row, wo):
        # copy changes from self.records to treeview.
        self.tree_view.item(row, values=(
            wo,
            self.records[wo]["description"],
            self.records[wo]["start_date"],
            self.records[wo]["stop_date"],
            self.records[wo]["completion_date"],
            self.records[wo]["priority"]
        ))

    def treeview_sort_column(self, col, reverse):
        """https://stackoverflow.com/questions/1966929/tk-treeview-column-sort"""

        l = [(self.tree_view.set(k, col), k) for k in self.tree_view.get_children('')]
        l.sort(reverse=reverse)

        # rearrange items in sorted positions
        for index, (val, k) in enumerate(l):
            self.tree_view.move(k, '', index)

        new_text = col + (" ASC" if not reverse else " DESC")
        print(f"sorting by {col=}" + (" ASC" if not reverse else " DESC"))

        # reverse sort next time
        self.tree_view.heading(col, text=new_text,
                               command=lambda colu=col: self.treeview_sort_column(colu, not reverse))

        for column in self.tv_columns:
            if column != col:
                self.tree_view.heading(column, text=column,
                                       command=lambda colu=column: self.treeview_sort_column(colu, not reverse))

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
        selected = self.tree_view.focus()
        if selected:
            temp = self.tree_view.item(selected, 'values')
            wo, wo_desc, wo_start_date, wo_stop_date, wo_completion_date, wo_priority = temp
            self.set_detail(wo)

    def calc_diff(self, d1, d2):
        if isinstance(d1, str):
            d1 = datetime.datetime.strptime(d1, self.format_history_date)
        if isinstance(d2, str):
            d2 = datetime.datetime.strptime(d2, self.format_history_date)
        return (d2 - d1).seconds

    def gen_all_time(self, d1, d2):
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

        suffix = lambda n: "s" if n != 1 else ""
        result = f"{years} year{suffix(years)} + {months} month{suffix(months)} + {fortnights} fortnight{suffix(fortnights)} + {weeks} week{suffix(weeks)}, {days=}, {hours=}, {minutes=}, {seconds=}"
        print(result)
        return result

    def gen_current_time(self, d1, d2):
        diff = self.calc_diff(d1, d2)
        spy_f = 60 * 60 * 24 * 365.25
        spy_i = int(spy_f)
        years, months, fortnights, weeks, days, hours, minutes, seconds = 0, 0, 0, 0, 0, 0, 0, 0
        match self.sv_entry_timer_unit.get():
            case "Years":
                years, rem = divmod(diff, spy_i)
            case "Months":
                months, rem = divmod(diff, int(spy_f / 12))
            case "Fortnights":
                fortnights, rem = divmod(diff, int(spy_f / 26))
            case "Weeks":
                weeks, rem = divmod(diff, int(spy_f / 52))
            case "Days":
                hours, rem = divmod(diff, 60 * 60 * 24)
            case "Hours":
                hours, rem = divmod(diff, 60 * 60)
            case "Minutes":
                minutes, rem = divmod(diff, 60)
            case _:
                seconds = diff

        result = f"CURRENT: {years=}, {months=}, {fortnights=}, {weeks=}, {days=}, {hours=}, {minutes=}, {seconds=}"
        print(result)
        return result

    def btn_play_clicked(self):
        print(f"btn_play_clicked")

    def btn_pause_clicked(self):
        print(f"btn_pause_clicked")

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
        print(f"btn_stop_clicked")

    def btn_add_clicked(self):
        print(f"btn_add_clicked")

    def click_tree_view(self, event):
        print(f"click_tree_view", event)
        # selected = self.tree_view.selection()[0]
        # print(f"{selected=}")

        selected = self.tree_view.focus()
        temp = self.tree_view.item(selected, 'values')
        wo, wo_desc, wo_start_date, wo_stop_date, wo_completion_date, wo_priority = temp
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

    def tick(self):
        for i in range(len(self.records)):
            wo = self.tree_view.item(i, "values")[0]
        # for wo, wo_dat in self.records.items():
            wo_dat = self.records[wo]
            if wo_dat["start_date"] is not None:
                if wo_dat["stop_date"] is None:
                    # do nothing
                    pass
                else:
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
