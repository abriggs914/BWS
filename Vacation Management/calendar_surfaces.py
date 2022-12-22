import datetime
import tkinter

from utility import *
from colour_utility import *
from tkinter_utility import *


FONT_FAMILY, CALENDAR_TEXT_SIZE = "Arial", 16


class FrameCalendar(tkinter.Frame):
    def __init__(self, master, date_in=None):
        super().__init__(master)

        self.frame = tkinter.Frame(self, height=400)

        self.current_date = tkinter.StringVar(self)
        self.date_format = "%Y-%m-%d %H:%M:%S"
        if date_in is not None:
            self.current_date.set(datetime.datetime.strptime(date_in, self.date_format).strftime(self.date_format))
        else:
            self.current_date.set(datetime.datetime.now().strftime(self.date_format))

        # ensure that the current date parameter is a sunday!
        self.current_date.set(first_of_week(datetime.datetime.strptime(self.current_date.get(), self.date_format)).strftime(self.date_format))

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
        colours = [
            LIGHTSKYBLUE,
            LIGHTSTEELBLUE,
            LIGHTSEAGREEN,
            SEAGREEN_4__SEAGREEN_,
            PALEVIOLETRED,
            PLUM_3,
            ORANGERED_1__ORANGERED_,
            RED_3,
            ORANGE,
            LIGHTSALMON_4,
            PALETURQUOISE_4,
            MIDNIGHTBLUE
        ]
        self.colours = dict(zip(range(12), [{
            "main": rgb_to_hex(col),
            "even": brighten(col, 0.1, rgb=False),
            "odd": darken(col, 0.1, rgb=False),
            "font": (FONT_FAMILY, CALENDAR_TEXT_SIZE),
            "foreground_even": font_foreground(brighten(col, 0.1, rgb=False)),
            "foreground_odd": font_foreground(darken(col, 0.1, rgb=False))
        } for col in colours]))
        # self.colours = {
        #     0: {
        #         "main": rgb_to_hex(LIGHTSKYBLUE),
        #         "odd": brighten(LIGHTSKYBLUE, 0.1, rgb=False),
        #         "even": darken(LIGHTSKYBLUE, 0.1, rgb=False)
        #         # ,
        #         # "font": (FONT_FAMILY, CALENDAR_TEXT_SIZE),
        #         # "foreground_odd": font_foreground()
        #     },
        #     1: {
        #         "main": rgb_to_hex(LIGHTSTEELBLUE),
        #         "odd": brighten(LIGHTSTEELBLUE, 0.1, rgb=False),
        #         "even": darken(LIGHTSTEELBLUE, 0.1, rgb=False)
        #     },
        #     2: {
        #         "main": rgb_to_hex(LIGHTSEAGREEN),
        #         "odd": brighten(LIGHTSEAGREEN, 0.1, rgb=False),
        #         "even": darken(LIGHTSEAGREEN, 0.1, rgb=False)
        #     },
        #     3: {
        #         "main": rgb_to_hex(LIGHTSTEELBLUE),
        #         "odd": brighten(LIGHTSTEELBLUE, 0.1, rgb=False),
        #         "even": darken(LIGHTSTEELBLUE, 0.1, rgb=False)
        #     },
        #     4: {
        #         "main": rgb_to_hex(LIGHTSTEELBLUE),
        #         "odd": brighten(LIGHTSTEELBLUE, 0.1, rgb=False),
        #         "even": darken(LIGHTSTEELBLUE, 0.1, rgb=False)
        #     },
        #     5: {
        #         "main": rgb_to_hex(LIGHTSTEELBLUE),
        #         "odd": brighten(LIGHTSTEELBLUE, 0.1, rgb=False),
        #         "even": darken(LIGHTSTEELBLUE, 0.1, rgb=False)
        #     },
        #     6: {
        #         "main": rgb_to_hex(LIGHTSTEELBLUE),
        #         "odd": brighten(LIGHTSTEELBLUE, 0.1, rgb=False),
        #         "even": darken(LIGHTSTEELBLUE, 0.1, rgb=False)
        #     },
        #     7: {
        #         "main": rgb_to_hex(LIGHTSTEELBLUE),
        #         "odd": brighten(LIGHTSTEELBLUE, 0.1, rgb=False),
        #         "even": darken(LIGHTSTEELBLUE, 0.1, rgb=False)
        #     },
        #     8: {
        #         "main": rgb_to_hex(LIGHTSTEELBLUE),
        #         "odd": brighten(LIGHTSTEELBLUE, 0.1, rgb=False),
        #         "even": darken(LIGHTSTEELBLUE, 0.1, rgb=False)
        #     },
        #     9: {
        #         "main": rgb_to_hex(LIGHTSTEELBLUE),
        #         "odd": brighten(LIGHTSTEELBLUE, 0.1, rgb=False),
        #         "even": darken(LIGHTSTEELBLUE, 0.1, rgb=False)
        #     },
        #     10: {
        #         "main": rgb_to_hex(LIGHTSTEELBLUE),
        #         "odd": brighten(LIGHTSTEELBLUE, 0.1, rgb=False),
        #         "even": darken(LIGHTSTEELBLUE, 0.1, rgb=False)
        #     },
        #     11: {
        #         "main": rgb_to_hex(LIGHTSTEELBLUE),
        #         "odd": brighten(LIGHTSTEELBLUE, 0.1, rgb=False),
        #         "even": darken(LIGHTSTEELBLUE, 0.1, rgb=False)
        #     }
        # }
        self.weekday_tile_colour_even = rgb_to_hex("GRAY_30")
        self.weekday_tile_colour_odd = rgb_to_hex("GRAY_45")
        self.draw_weekdays()

        self.selected_cell = None, None
        self.click_coords = None, None
        self.dragging_rect = None
        self.settings_square_selection = False  # by default select by sequence.

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
        self.dates_grid = []
        self.number_rows = 52  # weeks
        self.h_tile = self.w_tile
        self.draw_grid()
        self.canvas_grid.configure(scrollregion=(0, 0, self.calendar_width, self.number_rows * self.h_tile))
        self.dragging_rect = self.canvas_grid.create_rectangle(0, 0, self.w_tile, self.h_tile)
        self.selected_tiles = []
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

    def i_to_rc(self, i):
        return i // 7, i % 7

    def rc_to_i(self, r, c):
        return (r * 7) + c

    def draw_grid(self):
        tw, th = self.w_tile, self.h_tile
        # self.canvas_grid.delete()
        gc = grid_cells(self.calendar_width, 7, self.number_rows * th, self.number_rows)
        date = datetime.datetime.strptime(self.current_date.get(), self.date_format)
        for i, row in enumerate(gc):
            for j, dims in enumerate(row):
                ii = self.rc_to_i(i, j)
                t_date = date + datetime.timedelta(days=ii)
                print(f"{t_date: {self.date_format}}")
                is_even = i % 2 == 0
                colour_data = self.colours[t_date.month - 1]
                fill_colour = colour_data["even"] if is_even else colour_data["odd"]
                self.objects_grid.append(self.canvas_grid.create_rectangle(*dims, fill=fill_colour))
                self.dates_grid.append(t_date)
                tag = self.objects_grid[-1]
                self.canvas_grid.tag_bind(tag, "<Button-1>", self.click_canvas_grid)
                self.canvas_grid.tag_bind(tag, "<B1-Motion>", self.motion_canvas_grid)
                self.canvas_grid.tag_bind(tag, "<ButtonRelease-1>", self.release_canvas_grid)

    def click_canvas_grid(self, event):
        print(f"{event=}")
        x, y = self.canvas_grid.canvasx(event.x), self.canvas_grid.canvasy(event.y)
        r, c = self.xy_to_rc(x, y)
        self.click_coords = x, y
        self.selected_cell = r, c
        self.canvas_grid.move(self.dragging_rect, x, y)
        print(f"{r=}, {c=}")

    def motion_canvas_grid(self, event):
        r, c = self.selected_cell
        if r is not None and c is not None:
            self.canvas_grid.itemconfigure(self.dragging_rect, state="normal")
            x, y = self.canvas_grid.canvasx(event.x), self.canvas_grid.canvasy(event.y)
            ox, oy = self.click_coords
            bounds = self.canvas_grid.bbox(self.dragging_rect)
            print(f"{bounds=}")
            x1, y1, x2, y2 = bounds
            w1 = x2 - x1
            h1 = y2 - y1
            w2 = 2
            if x < x1:
                # print(f"A")
                x1 = x
                x2 = ox
            elif x > x2:
                # print(f"B")
                x2 = x
                x1 = ox
            else:
                m = x1 + (w1 / 2)
                # print(f"C")
                if x < m:
                    # print(f"D")
                    x1 = x
                    x2 = ox
                elif x > m:
                    # print(f"E")
                    x1 = ox
                    x2 = x
                    # w2 = x - m + w1

            if y < y1:
                # print(f"F")
                y1 = y
                y2 = oy
            elif y > y2:
                # print(f"G")
                y2 = y
                y1 = oy
            else:
                m = y1 + (h1 / 2)
                print(f"H")
                if y < m:
                    # print(f"I")
                    y1 = y
                    y2 = oy
                elif y > m:
                    # print(f"J")
                    y1 = oy
                    y2 = y
                    # w2 = x - m + w1

            # self.canvas_grid.itemconfigure(self.dragging_rect, width=w2)
            self.canvas_grid.coords(self.dragging_rect, x1, y1, x2, y2)

    def reset_random_cell_colour(self, cs, rs):
        for r in range(*rs):
            for c in range(*cs):
                i = self.rc_to_i(r, c)
                obj = self.objects_grid[i]
                self.canvas_grid.itemconfigure(obj, fill=random_colour(rgb=False))
        # for i, obj in enumerate(self.objects_grid[cs2: rs2]):
        #     print(f"{i=}, {obj=}")
        #     self.canvas_grid.itemconfigure(obj, fill=random_colour(rgb=False))

    def release_canvas_grid(self, event):
        self.selected_tiles.clear()
        # self.canvas_grid.moveto(self.dragging_rect, 0, 0)
        x1, y1, x2, y2 = self.canvas_grid.bbox(self.dragging_rect)
        r_tl, c_tl = self.xy_to_rc(x1, y1)
        r_tr, c_tr = self.xy_to_rc(x2, y1)
        r_bl, c_bl = self.xy_to_rc(x1, y2)
        r_br, c_br = self.xy_to_rc(x2, y2)
        cs = min([c_tl, c_tr, c_bl, c_br]), max([c_tl, c_tr, c_bl, c_br]) + 1
        rs = min([r_tl, r_tr, r_bl, r_br]), max([r_tl, r_tr, r_bl, r_br])
        cs2 = self.rc_to_i(rs[0], cs[0])
        rs2 = self.rc_to_i(rs[1], cs[1])

        if self.settings_square_selection:
            # square selection
            for r in range(rs[0], rs[1] + 1):
                for c in range(*cs):
                    i = self.rc_to_i(r, c)
                    obj = self.objects_grid[i]
                    self.canvas_grid.itemconfigure(obj, fill="green")
                    self.selected_tiles.append(i)
        else:
            # sequence selection
            for i in range(cs2, rs2):
                self.selected_tiles.append(i)
                obj = self.objects_grid[i]
                print(f"{i=}, {obj=}")
                self.canvas_grid.itemconfigure(obj, fill="green")



        # self.after(1500, self.reset_random_cell_colour, cs, rs)


        # for i, obj in enumerate(self.objects_grid[cs2: rs2]):
        #     print(f"{i=}, {obj=}")
        #     self.canvas_grid.itemconfigure(obj, fill="green")
        #
        # self.after(1500, self.reset_random_cell_colour, cs2, rs2)

        self.canvas_grid.coords(self.dragging_rect, 0, 0, 1, 1)
        self.canvas_grid.itemconfigure(self.dragging_rect, state="hidden")
        # self.canvas_grid.create_rectangle()
        # self.canvas_grid.itemconfig(self.dragging_rect, __x0=0, __y0=0)
        # self.canvas_grid.itemconfig(self.dragging_rect, x=0, y=0)
        # print(f"A release_canvas_grid {self.canvas_grid.bbox(self.dragging_rect)=}")
        # self.canvas_grid.move(self.dragging_rect, 0, 0)
        # print(f"B release_canvas_grid {self.canvas_grid.bbox(self.dragging_rect)=}, {result=}")
