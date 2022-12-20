import tkinter

from tkinter_utility import *


class FrameCalendar(tkinter.Frame):
    def __init__(self, master):
        super().__init__(master)

        self.frame = tkinter.Frame(self, height=400)

        self.current_date = tkinter.StringVar(self)
        self.calendar_width, self.calendar_height = 400, 600
        self.week_height = 20
        self.weekdays_list = ["S", "M", "T", "W", "T", "F", "S"]
        self.objects_week = []
        self.texts_week = []

        self.canvas_week = tkinter.Canvas(self.frame, width=self.calendar_width, height=self.week_height, background=rgb_to_hex("GRAY_17"))
        self.canvas_grid = tkinter.Canvas(self.frame, width=self.calendar_width, height=self.calendar_height, background="darkgrey")
        self.scrollbar_canvas = ttk.Scrollbar(self.frame, orient="vertical", command=self.canvas_grid.yview)
        self.canvas_grid.configure(yscrollcommand=self.scrollbar_canvas.set, scrollregion=(0, 0, self.calendar_width, self.calendar_height))

        self.selected_dates = tkinter.Variable(self, value=[])
        self.w_tile = self.calendar_width / 7
        self.h_tile = None

        self.tv_button_backward, self.button_backward = button_factory(self.frame, tv_btn="<<", kwargs_btn={"command": self.click_button_backward})
        self.tv_button_forward, self.button_forward = button_factory(self.frame, tv_btn=">>", kwargs_btn={"command": self.click_button_forward})

        self.weekday_colour = rgb_to_hex("BURNTUMBER")
        self.draw_weekdays()

        self.selected_cell = None, None
        self.dragging_rect = None

        # add widgets
        self.grid()
        self.frame.grid()
        self.button_backward.grid(row=0, column=0, columnspan=1)
        self.button_forward.grid(row=0, column=1, columnspan=1)
        self.canvas_week.grid(row=1, column=0, columnspan=2, sticky="ew")
        self.canvas_grid.grid(row=2, column=0, columnspan=2, sticky="ew")
        self.scrollbar_canvas.grid(row=2, column=2, sticky="ns")

    def draw_weekdays(self):
        w, h = self.calendar_width, self.week_height
        gc, *rest = grid_cells(w, 7, h, 1)
        for i, dims in enumerate(gc):
            tx, ty = dims[0] + ((dims[2] - dims[0]) / 2), dims[1] + ((dims[3] - dims[1]) / 2)
            self.objects_week.append(self.canvas_week.create_rectangle(*dims, fill=self.weekday_colour))
            self.texts_week.append(self.canvas_week.create_text(tx, ty, text=self.weekdays_list[i], fill=font_foreground(self.weekday_colour, rgb=False), font=("Arial", 18)))
        # print(f"{gc=}")

    def draw_grid(self):
        raise Exception("Override this method in child classes.")

    def click_button_backward(self):
        print(f"click_button_backward")

    def click_button_forward(self):
        print(f"click_button_forward")


class AnnualFrameCalendar(FrameCalendar):
    def __init__(self, master, start_year=datetime.datetime.now().year):
        super().__init__(master)

        # week_1 = datetime.datetime(start_year, 1, 1)
        # week_1_wkdy = week_1.weekday()
        #
        # week_52 = datetime.datetime(start_year, 12, 31)
        # week_52_wkdy = week_52.weekday()
        self.objects_grid = []
        self.number_rows = 52  # weeks
        self.h_tile = self.w_tile
        self.draw_grid()
        self.canvas_grid.configure(scrollregion=(0, 0, self.calendar_width, self.number_rows * self.h_tile))
        self.dragging_rect = self.canvas_grid.create_rectangle(0, 0, self.w_tile, self.h_tile)
        self.canvas_grid.itemconfigure(self.dragging_rect, state="hidden")

    def xy_to_rc(self, x, y):
        tw, th = self.w_tile, self.h_tile
        for i in range(self.number_rows):
            for j in range(7):
                if ((i * tw) <= y <= ((i + 1) * tw)) and ((j * th) <= x <= ((j + 1) * th)):
                    return i, j
        return None, None

    def rc_to_xy(self, r, c):
        tw, th = self.w_tile, self.h_tile
        return (r * tw), (c * th), ((r + 1) * tw), ((c + 1) * th)

    def draw_grid(self):
        tw, th = self.w_tile, self.h_tile
        # self.canvas_grid.delete()
        gc = grid_cells(self.calendar_width, 7, self.number_rows * th, self.number_rows)
        for i, row in enumerate(gc):
            for j, dims in enumerate(row):
                self.objects_grid.append(self.canvas_grid.create_rectangle(*dims, fill=random_colour(rgb=False)))
                tag = self.objects_grid[-1]
                self.canvas_grid.tag_bind(tag, "<Button-1>", self.click_canvas_grid)
                self.canvas_grid.tag_bind(tag, "<B1-Motion>", self.motion_canvas_grid)
                self.canvas_grid.tag_bind(tag, "<ButtonRelease-1>", self.release_canvas_grid)

    def click_canvas_grid(self, event):
        print(f"{event=}")
        x, y = event.x, event.y
        r, c = self.xy_to_rc(x, y)
        self.selected_cell = r, c
        self.canvas_grid.move(self.dragging_rect, x, y)
        print(f"{r=}, {c=}")

    def motion_canvas_grid(self, event):
        r, c = self.selected_cell
        if r is not None and c is not None:
            self.canvas_grid.itemconfigure(self.dragging_rect, state="normal")
            x, y = event.x, event.y
            bounds = self.canvas_grid.bbox(self.dragging_rect)
            print(f"{bounds=}")
            x1, y1, x2, y2 = bounds
            self.canvas_grid.itemconfigure(self.dragging_rect, width=x1 + x)

    def release_canvas_grid(self, event):
        self.canvas_grid.itemconfigure(self.dragging_rect, state="hidden")
        # self.canvas_grid.create_rectangle()
        # self.canvas_grid.itemconfig(self.dragging_rect, __x0=0, __y0=0)
        self.canvas_grid.itemconfig(self.dragging_rect, x=0, y=0)


