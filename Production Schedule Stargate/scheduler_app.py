import datetime
import tkinter
from tkinter_utility import entry_factory, button_factory
from calendar_surface import CalendarSurface


class App(tkinter.Tk):

    def __init__(self, TITLE="Stargate Production Scheduler", WIDTH=500, HEIGHT=500):
        super().__init__()

        self.TITLE = TITLE
        self.WIDTH = WIDTH
        self.HEIGHT = HEIGHT
        self.geometry(f"{self.WIDTH}x{self.HEIGHT}")
        self.state("zoomed")
        self.title(self.TITLE)
        self.update()
        self.window_width = self.winfo_width()
        self.window_height = self.winfo_height()

        can_w, can_h = self.window_width * 0.75, self.window_height * 0.65

        self.calendar_frame_a = tkinter.Frame(self)
        self.calendar_frame_b = tkinter.Frame(self.calendar_frame_a)
        self.calendar_surface = CalendarSurface(self.calendar_frame_b, can_w, can_h, datetime.datetime.now())
        self.tv_btn_scroll_left, self.button_scroll_left = button_factory(self.calendar_frame_a, tv_btn="left")
        self.tv_btn_scroll_right, self.button_scroll_right = button_factory(self.calendar_frame_a, tv_btn="right")

        self.calendar_surface.bind("<Button-1>", self.click_calendar_surface)
        # self.calendar_surface.bind("<Motion>", self.motion_calendar_surface)
        self.button_scroll_left.config(command=self.click_left_scroll)
        self.button_scroll_right.config(command=self.click_right_scroll)

        self.calendar_frame_a.pack()
        self.calendar_frame_b.pack()
        self.calendar_surface.pack(side=tkinter.TOP)
        self.button_scroll_left.pack(side=tkinter.LEFT)
        self.button_scroll_right.pack(side=tkinter.RIGHT)

    def click_calendar_surface(self, *event):
        print(f"click {event=}")

    def motion_calendar_surface(self, *event):
        print(f"motion {event=}")

    def click_left_scroll(self):
        print(f"click_left")
        self.calendar_surface.scroll_left()

    def click_right_scroll(self):
        print(f"click_right")
        self.calendar_surface.scroll_right()

    def update(self) -> None:
        super(App, self).update()
