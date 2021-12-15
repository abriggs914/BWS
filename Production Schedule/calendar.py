import easygui
import tkinter
from utility import *
from colour_utility import *
# import mouse


class CalendarTile:

    def __init__(self, tile_rect, border_width, row, col, line, date, colour, text=None):
        self.param_rect = Rect2(*tile_rect)
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
        self.rect = (
        self.rect.left + self.border_width, self.rect.top + self.border_width, self.rect.right - self.border_width,
        self.rect.bottom - self.border_width)

    def __copy__(self):
        return CalendarTile(self.param_rect, self.border_width, self.row, self.col, self.line, self.date, self.colour,
                            self.text)

    def __repr__(self):
        return "rect: {}, (r, c): ({}, {}), line: {}, date: {}".format(self.rect, self.row, self.col, self.line,
                                                                       self.date)


class Calendar:

    def __init__(self, canvas, w, h, start_date, end_date, lines):
        assert isinstance(start_date,
                          dt.datetime), "Start_date object \"{}\" must be a datetime.datetime object.".format(
            start_date)
        assert isinstance(end_date, dt.datetime), "End_date object \"{}\" must be a datetime.datetime object.".format(
            end_date)
        assert isinstance(start_date,
                          dt.datetime), "Start_date object \"{}\" must be a datetime.datetime object.".format(
            start_date)
        assert end_date >= start_date, "End_date \"{}\" must be after start_date \"{}\".".format(end_date, start_date)

        self.width = w
        self.height = h
        self.canvas = canvas
        self.lines = lines
        self.switch_use_hover = True
        self.border_width = 3
        self.readable_width = 100
        self.readable_height = 75
        self.readable_width = 250
        self.readable_height = 250

        # Capping max days at 60
        date_diff = (end_date - start_date).days
        if date_diff > 60:
            end_date = start_date + dt.timedelta(days=60)
        date_diff = int(ceil((end_date - start_date).days))
        self.rows = len(self.lines)
        self.cols = date_diff
        self.dates = [start_date + dt.timedelta(days=1 + i) for i in range(date_diff)]

        # self.tile_rect = Rect2(0, 0, (w - ((len(self.dates) + 1) * self.border_width)) / max(1, len(self.dates)), (h - ((len(self.lines) + 1) * self.border_width)) / max(1, len(self.lines)))
        self.tile_rect = Rect2(self.border_width, self.border_width, (w - self.border_width) / max(1, len(self.dates)),
                               (h - self.border_width) / max(1, len(self.lines)))
        # self.tiles = flatten([[CalendarTile(self.tile_rect, self.border_width, i, j, line, date, random_colour()) for
        #                        j, date in enumerate(self.dates)] for i, line in enumerate(self.lines)])
        self.tiles = flatten([[CalendarTile(self.tile_rect, self.border_width, i, j, line, date, GRAY_17) for
                               j, date in enumerate(self.dates)] for i, line in enumerate(self.lines)])
        self.og_tiles = [tile.__copy__() for tile in self.tiles]

        print("{}\n{}".format(len(self.tiles), self.tiles))

        self.dragging = None
        self.selected = None
        self.hovered = None
        self.hover_select = None
        self.draw_canvas()
        self.bind_canvas()

    def set_user_hover_mode(self, use_hover):
        self.switch_use_hover = use_hover

    def bind_canvas(self):
        self.canvas.bind("<Motion>", self.hovering)
        self.canvas.bind("<Leave>", self.leaving)
        self.canvas.bind("<Enter>", self.hover_entering)
        self.canvas.bind("<Button-1>", self.click_print)
        self.canvas.bind("<B1-Motion>", self.drag_print)
        self.canvas.bind("<ButtonRelease-1>", self.release_drag)

    def unbind_canvas(self):
        self.canvas.unbind("<Button-1>")
        self.canvas.unbind("<B1-Motion>")

    def leaving(self, *args):
        # self.tiles = [tile.__copy__() for tile in self.og_tiles]
        for i, tile in enumerate(self.og_tiles):
            self.tiles[i].rect = tuple([v for v in self.og_tiles[i].rect])
        self.hovered = None
        self.draw_canvas()

    def hover_entering(self, *args):
        pass
        # event = args[0]
        # mouse_x, mouse_y = event.x, event.y
        # self.hovered = self.r_c_to_i(*self.x_y_to_r_c(mouse_x, mouse_y))
        # print("entering:", self.hovered)
        # self.draw_canvas()

    def hovering(self, *args):
        if not self.switch_use_hover:
            return
        event = args[0]
        mouse_x, mouse_y = event.x, event.y
        rc = self.x_y_to_r_c(mouse_x, mouse_y)
        if rc is None:
            print("rc is None")
            return
        r, c = rc
        tw = self.tile_rect.width
        th = self.tile_rect.height
        rw = max(tw, self.readable_width)
        rh = max(th, self.readable_height)
        ntw = (self.width - (rw - tw) - (3 * self.border_width)) / max(1, self.cols)
        nth = (self.height - (rh - th) - (3 * self.border_width)) / max(1, self.rows)
        if self.hovered != self.r_c_to_i(r, c) or self.hovered is None:
            for i, row in enumerate(range(self.rows)):
                for j, col in enumerate(range(self.cols)):
                    idx = self.r_c_to_i(row, col)
                    x1, y1, x2, y2 = self.tiles[idx].rect
                    bw = self.tiles[idx].border_width
                    nx1 = j * ntw
                    nx1 += rw - ntw if j > c else 0
                    nx2 = nx1 + (rw if j == c else ntw)
                    ny1 = i * nth
                    ny1 += rh - nth if i > r else 0
                    ny2 = ny1 + (rh if i == r else nth)
                    if nx1 == 0:
                        nx1 = bw
                    if ny1 == 0:
                        ny1 = bw
                    self.tiles[idx].rect = (nx1 + bw, ny1 + bw, nx2 - bw, ny2 - bw)
            self.hovered = self.r_c_to_i(r, c)
        # for i, tile in enumerate(self.tiles):
        #     tr, tc = self.i_to_r_c(i)
        #     x1, y1, x2, y2 = self.tiles[i].rect
        #     # handled = False
        #         if self.readable_height > self.tile_rect.height:
        #             if tr == r:
        #                 self.tiles[i].rect = (x1, y1, x2, y1 + self.readable_height)
        #                 # handled = True
        #             else:
        #                 s_height = (self.height - self.readable_height) / max(1, (self.rows - 1))
        #                 # self.tiles[i].rect = (x1, y1 + (self.readable_height - (y2 - y1)), x2, y1 + s_height)
        #                 self.tiles[i].rect = (x1, y1, x2, y1 + s_height)
        #
        #         if self.readable_width > self.tile_rect.width:
        #             if tc == c:
        #                 hw = self.readable_width / 2
        #                 # self.tiles[i].rect = (x1 - hw, y1, x1 + hw, y2)
        #                 self.tiles[i].rect = (x1 - (2 * hw), y1, x1 + (2 * hw), y2)
        #                 # handled = True
        #             else:
        #                 # t_width = self.width / max(1, self.cols)
        #                 t_width = self.tile_rect.width
        #                 n_width = (self.width - self.readable_width) / max(1, (self.cols - 1))
        #                 d_width = t_width - n_width
        #                 sd_width = tc * d_width
        #                 print("self.width:", self.width, "self.readable_width:", self.readable_width, "t_width:",
        #                       t_width, "n_width:", n_width, ", d_width:", d_width, "tc:", tc, "sd_width:", sd_width)
        #                 # s_width = (self.width - self.readable_width) / max(1, (self.cols - 1))
        #                 # p_width = (x2 - x1) / s_width
        #                 # self.tiles[i].rect = (x1 + (self.readable_height - (x2 - x1)), y1, x1 + s_width, y2)
        #                 if tc < c:
        #                     # self.tiles[i].rect = (x1 + (max(0, tc - 1) * d_width), y1, (x1 + (max(0, tc - 1) * d_width) + n_width), y2)
        #                     self.tiles[i].rect = (x1 - sd_width, y1, (x1 + n_width - sd_width), y2)
        #                 else:
        #                     # self.tiles[i].rect = (x1 - (max(0, tc - 1) * d_width) + self.readable_width, y1, (x1 - (max(0, tc - 1) * d_width) + n_width + self.readable_width), y2)
        #                     self.tiles[i].rect = (x1 + sd_width, y1, (x1 + sd_width + n_width), y2)

        # if not handled:
        #     self.tiles[i].rect = (x1, y1, x1 + self.readable_width, y2)

            self.draw_canvas()

    def hovering_old(self, *args):
        print("hovering")
        event = args[0]
        mouse_x, mouse_y = event.x, event.y
        r, c = self.x_y_to_r_c(mouse_x, mouse_y)
        for i, tile in enumerate(self.tiles):
            tr, tc = self.i_to_r_c(i)
            x1, y1, x2, y2 = self.tiles[i].rect
            # handled = False
            if self.hovered or 1:
                if self.readable_height > self.tile_rect.height:
                    if tr == r:
                        self.tiles[i].rect = (x1, y1, x2, y1 + self.readable_height)
                        # handled = True
                    else:
                        s_height = (self.height - self.readable_height) / max(1, (self.rows - 1))
                        # self.tiles[i].rect = (x1, y1 + (self.readable_height - (y2 - y1)), x2, y1 + s_height)
                        self.tiles[i].rect = (x1, y1, x2, y1 + s_height)

                if self.readable_width > self.tile_rect.width:
                    if tc == c:
                        hw = self.readable_width / 2
                        # self.tiles[i].rect = (x1 - hw, y1, x1 + hw, y2)
                        self.tiles[i].rect = (x1 - (2 * hw), y1, x1 + (2 * hw), y2)
                        # handled = True
                    else:
                        # t_width = self.width / max(1, self.cols)
                        t_width = self.tile_rect.width
                        n_width = (self.width - self.readable_width) / max(1, (self.cols - 1))
                        d_width = t_width - n_width
                        sd_width = tc * d_width
                        print("self.width:", self.width, "self.readable_width:", self.readable_width, "t_width:",
                              t_width, "n_width:", n_width, ", d_width:", d_width, "tc:", tc, "sd_width:", sd_width)
                        # s_width = (self.width - self.readable_width) / max(1, (self.cols - 1))
                        # p_width = (x2 - x1) / s_width
                        # self.tiles[i].rect = (x1 + (self.readable_height - (x2 - x1)), y1, x1 + s_width, y2)
                        if tc < c:
                            # self.tiles[i].rect = (x1 + (max(0, tc - 1) * d_width), y1, (x1 + (max(0, tc - 1) * d_width) + n_width), y2)
                            self.tiles[i].rect = (x1 - sd_width, y1, (x1 + n_width - sd_width), y2)
                        else:
                            # self.tiles[i].rect = (x1 - (max(0, tc - 1) * d_width) + self.readable_width, y1, (x1 - (max(0, tc - 1) * d_width) + n_width + self.readable_width), y2)
                            self.tiles[i].rect = (x1 + sd_width, y1, (x1 + sd_width + n_width), y2)

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
                if tile_num in [self.dragging, self.selected, self.hover_select]:
                    outline = WHITE
                else:
                    outline = bgc
            else:
                fgc = BLACK
                if tile_num in [self.dragging, self.selected, self.hover_select]:
                    outline = GRAY_15
                else:
                    outline = bgc
            tile_num = tile.text if tile.text is not None else tile_num
            self.canvas.create_rectangle(*tile.rect, fill=rgb_to_hex(bgc), outline=rgb_to_hex(outline),
                                         width=self.border_width)
            self.canvas.create_text(tile.rect[0] + ((tile.rect[2] - tile.rect[0]) / 2),
                                    tile.rect[1] + ((tile.rect[3] - tile.rect[1]) / 2), fill=rgb_to_hex(fgc),
                                    font="Times 12 italic bold", text=str(tile_num))

    def r_c_to_i(self, r, c):
        return (r * self.cols) + c

    def i_to_r_c(self, i):
        return (i // self.cols), (i % self.cols)

    def x_y_to_r_c(self, x, y):
        # tw = self.tile_rect.width
        # th = self.tile_rect.height
        # r = int(y // th)
        # c = int(x // tw)
        # return r, c
        for i, tile in enumerate(self.tiles):
            x1, y1, x2, y2 = tile.rect
            r, c = self.i_to_r_c(i)
            bw = tile.border_width
            if x1 - (2 * bw) <= x <= x2 + (2 * bw) and y1 - (2 * bw) <= y <= y2 + (2 * bw):
                return r, c

        print("Could not map x and y: ({}, {})".format(x, y))

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
                self.hover_select = new_select
                self.draw_canvas()
                self.swap_tiles(self.selected, new_select)
                self.hover_select = None
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
                    self.hover_select = hover_tile
                    self.unbind_canvas()
                    self.draw_canvas()
                    self.swap_tiles(self.dragging, hover_tile)
                    self.dragging = None
                    self.selected = None
                    self.hover_select = None
                    self.draw_canvas()
                    self.bind_canvas()
            i += 1

            # print("type(drag_event):", type(drag_event))

    def swap_tiles(self, dragging_tile, hover_tile):
        ans = easygui.ynbox(msg="Are you sure you wamt to swap tile#{} with  tile#{}".format(dragging_tile, hover_tile),
                            title="Swap Confirm", default_choice="No", )
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
