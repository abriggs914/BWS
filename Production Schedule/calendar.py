import easygui
import tkinter
from utility import *
from colour_utility import *


class CalendarTile:

    def __init__(self, tile_rect, border_width, row, col, line, date, colour, text=None):
        self.rect = tile_rect
        self.border_width = border_width
        self.row = row
        self.col = col
        self.line = line
        self.date = date
        self.colour = colour
        self.text = text

        assert isinstance(self.rect, Rect2)

        self.rect = self.rect.translated((col * self.rect.width), (row * self.rect.height))
        self.rect = (self.rect.left + self.border_width, self.rect.top + self.border_width, self.rect.right - self.border_width, self.rect.bottom - self.border_width)

    def __copy__(self):
        return CalendarTile(self.rect, self.border_width, self.row, self.col, self.line, self.date, self.colour, self.text)

    def __repr__(self):
        return "rect: {}, (r, c): ({}, {}), line: {}, date: {}".format(self.rect, self.row, self.col, self.line, self.date)


class Calendar:

    def __init__(self, canvas, w, h, start_date, end_date, lines):
        assert isinstance(start_date, dt.datetime), "Start_date object \"{}\" must be a datetime.datetime object.".format(start_date)
        assert isinstance(end_date, dt.datetime), "End_date object \"{}\" must be a datetime.datetime object.".format(end_date)
        assert isinstance(start_date, dt.datetime), "Start_date object \"{}\" must be a datetime.datetime object.".format(start_date)
        assert end_date >= start_date, "End_date \"{}\" must be after start_date \"{}\".".format(end_date, start_date)

        self.width = w
        self.height = h
        self.canvas = canvas
        self.lines = lines
        self.border_width = 3
        self.readable_width = 100
        self.readable_height = 75

        # Capping max days at 60
        date_diff = (end_date - start_date).days
        if date_diff > 60:
            end_date = start_date + dt.timedelta(days=60)
        date_diff = int(ceil((end_date - start_date).days))
        self.rows = len(self.lines)
        self.cols = date_diff
        self.dates = [start_date + dt.timedelta(days=1+i) for i in range(date_diff)]

        # self.tile_rect = Rect2(0, 0, (w - ((len(self.dates) + 1) * self.border_width)) / max(1, len(self.dates)), (h - ((len(self.lines) + 1) * self.border_width)) / max(1, len(self.lines)))
        self.tile_rect = Rect2(self.border_width, self.border_width, (w - self.border_width) / max(1, len(self.dates)), (h - self.border_width) / max(1, len(self.lines)))
        self.tiles = flatten([[CalendarTile(self.tile_rect, self.border_width, i, j, line, date, random_colour()) for j, date in enumerate(self.dates)] for i, line in enumerate(self.lines)])
        self.og_tiles = [tile.__copy__() for tile in self.tiles]

        print("{}\n{}".format(len(self.tiles), self.tiles))

        self.dragging = None
        self.selected = None
        self.draw_canvas()
        self.bind_canvas()

    def bind_canvas(self):
        self.canvas.bind("<Motion>", self.hovering)
        self.canvas.bind("<Leave>", self.leaving)
        self.canvas.bind("<Button-1>", self.click_print)
        self.canvas.bind("<B1-Motion>", self.drag_print)
        self.canvas.bind("<ButtonRelease-1>", self.release_drag)

    def unbind_canvas(self):
        self.canvas.unbind("<Button-1>")
        self.canvas.unbind("<B1-Motion>")

    def leaving(self, *args):
        self.tiles = self.og_tiles
        self.draw_canvas()

    def hovering(self, *args):
        print("hovering")
        event = args[0]
        mouse_x, mouse_y = event.x, event.y
        r, c = self.x_y_to_r_c(mouse_x, mouse_y)
        for i, tile in enumerate(self.tiles):
            tr, tc = self.i_to_r_c(i)
            x1, y1, x2, y2 = self.tiles[i].rect
            # handled = False
            if tr == r:
                self.tiles[i].rect = (x1, y1, x2, y1 + self.readable_height)
                # handled = True
            else:
                s_height = (self.height - self.readable_height) / max(1, (self.rows - 1))
                # self.tiles[i].rect = (x1, y1 + (self.readable_height - (y2 - y1)), x2, y1 + s_height)
                self.tiles[i].rect = (x1, y1, x2, y1 + s_height)
            if tc == c:
                self.tiles[i].rect = (x1, y1, x1 + self.readable_width, y2)
                # handled = True
            else:
                # t_width = self.width / max(1, self.cols)
                t_width = x2 - x1
                n_width = (self.width - self.readable_width) / max(1, (self.cols - 1))
                d_width = t_width - n_width
                print("self.width:", self.width, "self.readable_width:", self.readable_width, "t_width:", t_width, ", d_width:", d_width)
                # s_width = (self.width - self.readable_width) / max(1, (self.cols - 1))
                # p_width = (x2 - x1) / s_width
                # self.tiles[i].rect = (x1 + (self.readable_height - (x2 - x1)), y1, x1 + s_width, y2)
                if tc < c:
                    fact = -1
                else:
                    fact = 1
                d_width *= fact
                self.tiles[i].rect = (x1 + d_width, y1, (x1 + n_width + d_width), y2)

            # if not handled:
            #     self.tiles[i].rect = (x1, y1, x1 + self.readable_width, y2)

        self.draw_canvas()

    def draw_canvas(self):
        self.canvas.delete("all")
        for tile in self.tiles:
            # print("tile.rect.tupl:", tile.rect)
            bgc = tile.colour
            r, c = tile.row, tile.col
            tile_num = self.r_c_to_i(r, c)
            if sum(bgc) < 300:
                fgc = WHITE
                if tile_num == self.dragging:
                    outline = WHITE
                else:
                    outline = bgc
            else:
                fgc = BLACK
                if tile_num == self.dragging:
                    outline = GRAY_15
                else:
                    outline = bgc
            tile_num = tile.text if tile.text is not None else tile_num
            self.canvas.create_rectangle(*tile.rect, fill=rgb_to_hex(bgc), outline=rgb_to_hex(outline), width=self.border_width)
            self.canvas.create_text(tile.rect[0] + ((tile.rect[2] - tile.rect[0]) / 2), tile.rect[1] + ((tile.rect[3] - tile.rect[1]) / 2), fill=rgb_to_hex(fgc), font="Times 12 italic bold", text=str(tile_num))

    def r_c_to_i(self, r, c):
        return (r * self.cols) + c

    def i_to_r_c(self, i):
        return (i // self.cols), (i % self.cols)

    def x_y_to_r_c(self, x, y):
        tw = self.tile_rect.width
        th = self.tile_rect.height
        r = int(y // th)
        c = int(x // tw)
        return r, c

    def release_drag(self, *args):
        self.dragging = None

    def click_print(self, *args):
        event = args[0]
        mouse_x, mouse_y = event.x, event.y
        new_select = self.r_c_to_i(*self.x_y_to_r_c(mouse_x, mouse_y))
        if self.selected is not None:
            print("self.selected is not None")
            if self.selected != new_select:
                print("self.selected {}, new_select: {}".format(self.selected, new_select))
                self.swap_tiles(self.selected, new_select)
                self.selected = None
            self.selected = None
            self.draw_canvas()
            return
        self.dragging = new_select
        self.selected = new_select
        self.draw_canvas()

    def drag_print(self, *args):
        drag_event = args[0]
        assert isinstance(drag_event, tkinter.Event)
        mouse_x, mouse_y = drag_event.x, drag_event.y
        # print("drag_event:", drag_event.)
        # print("x:", mouse_x, "y:", mouse_y)
        i = 0
        while i < len(self.tiles):
            tile = self.tiles[i]
            x1, y1, x2, y2 = tile.rect
            if x1 <= mouse_x <= x2 and y1 <= mouse_y <= y2:
                hover_tile = self.r_c_to_i(tile.row, tile.col)

                if self.dragging is None:
                    self.dragging = self.r_c_to_i(tile.row, tile.col)
                elif hover_tile != self.dragging:
                    print("Swapping self.dragging: {} with hovering tile: {}".format(self.dragging, hover_tile))
                    self.unbind_canvas()
                    self.swap_tiles(self.dragging, hover_tile)
                    self.dragging = None
                    self.selected = None
                    self.draw_canvas()
                    self.bind_canvas()
            i += 1

            # print("type(drag_event):", type(drag_event))

    def swap_tiles(self, dragging_tile, hover_tile):
        ans = easygui.ynbox(msg="Are you sure you wamt to swap tile#{} with  tile#{}".format(dragging_tile, hover_tile), title="Swap Confirm", default_choice="No",)
        print("ans:", ans)
        if not ans:
            print("Swap declined")
            return
        old_tile = self.tiles[dragging_tile].text, self.tiles[dragging_tile].colour
        new_tile = self.tiles[hover_tile].text, self.tiles[hover_tile].colour
        self.tiles[dragging_tile].text = new_tile[0] if new_tile[0] is not None else str(hover_tile)
        self.tiles[dragging_tile].colour = new_tile[1]
        self.tiles[hover_tile].text = old_tile[0] if old_tile[0] is not None else str(dragging_tile)
        self.tiles[hover_tile].colour = old_tile[1]
