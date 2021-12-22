import math

import easygui
import tkinter
from pdf_writer import *
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
        self.top_level_wo_idx = None

        self.wo_num = None
        self.model_name = None
        self.dealer = None
        self.status = None
        self.beam = None
        self.job_start = None

        # if self.line[0] == "B":
        #     # Beam Line
        #     self.top_level_wo_idx =
        # if self.line[:3] == "GNK":
        #     # GNK Line

        assert isinstance(self.rect, Rect2)

        self.rect = self.rect.translated((col * self.rect.width), (row * self.rect.height))
        self.rect = (
        self.rect.left + self.border_width, self.rect.top + self.border_width, self.rect.right - self.border_width,
        self.rect.bottom - self.border_width)

    def set_data(self, wo, model_name, dealer, status, beam, job_start):
        self.wo_num = wo
        self.model_name = model_name
        self.dealer = dealer
        self.status = status
        self.beam = beam
        self.job_start = job_start
        self.text = "{}\n{}\n{}\n{}\n{}\n{}".format(wo, model_name, dealer, status, beam, job_start)

    def get_data(self):
        return self.wo_num, self.model_name, self.dealer, self.status, self.beam, self.job_start

    def is_beam(self):
        return self.line[0] == "B"

    def is_gnk(self):
        return self.line[:3] == "GNK"

    def is_top_level_wo(self):
        return str(self.wo_num)[:4] == "1001"

    def get_pdf_text(self):
        return self.text if len("".join([s.strip() for s in self.text.split("None")])) else "Line: {}\nDate: {}".format(self.line, self.date)

    def info_dict(self):
        return dict(zip([
            "row",
            "col",
            "line",
            "date",
            "colour",
            "text",
            "top_level_wo_idx",
            "wo_num",
            "model_name",
            "dealer",
            "status",
            "beam",
            "job_start"
        ],
        [
            self.row,
            self.col,
            self.line,
            self.date,
            self.colour,
            self.text,
            self.top_level_wo_idx,
            self.wo_num,
            self.model_name,
            self.dealer,
            self.status,
            self.beam,
            self.job_start
        ]))

    def __copy__(self):
        ct = CalendarTile(self.param_rect, self.border_width, self.row, self.col, self.line, self.date, self.colour,
                            self.text)
        ct.set_data(*self.get_data())
        return ct

    def __repr__(self):\
        # return "rect: {}, (r, c): ({}, {}), line: {}, date: {}".format(self.rect, self.row, self.col, self.line,
        #                                                                self.date)
        return "date: {}, line: {}".format(self.date.strftime("%Y-%m-%d"), self.line)


class PSCalendar:

    def __init__(self, canvas, canvas_header_col, canvas_header_row, pop_up_canvas, w, h, start_date, end_date, data, lines, dates, border_width):
        assert isinstance(start_date,
                          dt.datetime), "Start_date object \"{}\" must be a datetime.datetime object.".format(
            start_date)
        assert isinstance(end_date, dt.datetime), "End_date object \"{}\" must be a datetime.datetime object.".format(
            end_date)
        assert isinstance(start_date,
                          dt.datetime), "Start_date object \"{}\" must be a datetime.datetime object.".format(
            start_date)
        assert end_date >= start_date, "End_date \"{}\" must be after start_date \"{}\".".format(end_date, start_date)

        self.version_num = 1
        self.start_date = start_date
        self.end_date = end_date
        self.width = w
        self.height = h
        self.canvas = canvas
        self.canvas_header_col = canvas_header_col
        self.canvas_header_row = canvas_header_row
        self.canvas_pop_up = pop_up_canvas
        self.lines = lines
        self.switch_use_hover = True
        self.border_width = border_width
        self.readable_width = 100
        self.readable_height = 75
        self.readable_width = 250
        self.readable_height = 250
        self.hiding_non_selected_tiles = True
        self.export_pdf_mode = "TABLOID"
        self.pdf_min_encapsulation = True

        # # Capping max days at 60
        # # TODO this needs to omit non-production days (weekends)
        # date_diff = (end_date - start_date).days
        # if date_diff > 60:
        #     end_date = start_date + dt.timedelta(days=60)
        # date_diff = int(ceil((end_date - start_date).days))
        # self.rows = len(self.lines)
        # self.cols = date_diff
        # self.dates = [start_date + dt.timedelta(days=1 + i) for i in range(date_diff)]
        self.rows = len(lines)
        self.cols = len(dates)
        self.dates = dates

        # self.tile_rect = Rect2(0, 0, (w - ((len(self.dates) + 1) * self.border_width)) / max(1, len(self.dates)), (h - ((len(self.lines) + 1) * self.border_width)) / max(1, len(self.lines)))
        self.tile_rect = Rect2(self.border_width, self.border_width, (w - self.border_width) / max(1, len(self.dates)),
                               (h - self.border_width) / max(1, len(self.lines)))
        # self.tiles = flatten([[CalendarTile(self.tile_rect, self.border_width, i, j, line, date, random_colour()) for
        #                        j, date in enumerate(self.dates)] for i, line in enumerate(self.lines)])
        self.tiles = flatten([[CalendarTile(self.tile_rect, self.border_width, i, j, line, date, GRAY_17, text="Line: {}\nDate: {}".format(line, date.strftime("%Y-%m-%d"))) for
                               j, date in enumerate(self.dates)] for i, line in enumerate(self.lines)])

        for i, tile in enumerate(self.tiles):
            idxrc = (i // self.rows), (i % self.rows)
            # print("idxrc:", idxrc)
            idx = (idxrc[1] * self.rows) + idxrc[0] #          self.r_c_to_i(idxrc[1], idxrc[0])
            # idxrc = i // self.rows , (i % self.cols)
            # idx = (self.cols * (i // self.rows)) + (i % self.cols)
            idx = i
            # print("from i: {} to idx: {}, idxrc: {}".format(i, idx, idxrc))
            data_row = data.iloc[idx:idx+1, :]
            if data_row['InputField1'] is not None and data_row['InputField2'] is not None:
                # print("data_row:", data_row)
                if math.isnan(data_row['WO#'].tolist()[0]):
                    continue
                wo = int(data_row['WO#'].tolist()[0])
                model_name = data_row['InputField1'].tolist()[0]
                dealer = data_row['InputField2'].tolist()[0]
                status = data_row["Stock/Sold"].tolist()[0]
                beam = data_row["Beam WO#"].tolist()[0]
                job_start = data_row["JobStartDate"].tolist()[0]
                self.tiles[i].set_data(wo, model_name, dealer, status, beam, job_start)

        # self.tiles = [CalendarTile(self.tile_rect, self.border_width, 0, i, "Dates", date, BLACK, text=date.strftime("%Y-%m-%d")) for i, date in enumerate(self.dates)] + self.tiles
        # self.rows += 1
        # tiles = []
        # for i, tile in range(len(self.rows):
        #
        #
        # self.cols += 1

        self.og_tiles = [tile.__copy__() for tile in self.tiles]

        print("{}\n{}".format(len(self.tiles), self.tiles))

        self.dragging = None
        self.selected = None
        self.hovered = None
        self.hover_select = None
        self.current_hover = None
        self.dbl_clicked = None
        # self.showing_pop_up = False
        self.draw_canvas()
        self.bind_canvas()

    # def __init__(self, canvas, w, h, start_date, end_date, data, lines, dates):
    #     assert isinstance(start_date,
    #                       dt.datetime), "Start_date object \"{}\" must be a datetime.datetime object.".format(
    #         start_date)
    #     assert isinstance(end_date, dt.datetime), "End_date object \"{}\" must be a datetime.datetime object.".format(
    #         end_date)
    #     assert isinstance(start_date,
    #                       dt.datetime), "Start_date object \"{}\" must be a datetime.datetime object.".format(
    #         start_date)
    #     assert end_date >= start_date, "End_date \"{}\" must be after start_date \"{}\".".format(end_date, start_date)
    #
    #     lines = ["NONE"] + lines
    #     dates = ["NONE"] + dates
    #
    #     self.start_date = start_date
    #     self.end_date = end_date
    #     self.width = w
    #     self.height = h
    #     self.canvas = canvas
    #     self.lines = lines
    #     self.switch_use_hover = True
    #     self.border_width = 3
    #     self.readable_width = 100
    #     self.readable_height = 75
    #     self.readable_width = 250
    #     self.readable_height = 250
    #     self.hiding_non_selected_tiles = True
    #     self.export_pdf_mode = "TABLOID"
    #
    #     # # Capping max days at 60
    #     # # TODO this needs to omit non-production days (weekends)
    #     # date_diff = (end_date - start_date).days
    #     # if date_diff > 60:
    #     #     end_date = start_date + dt.timedelta(days=60)
    #     # date_diff = int(ceil((end_date - start_date).days))
    #     # self.rows = len(self.lines)
    #     # self.cols = date_diff
    #     # self.dates = [start_date + dt.timedelta(days=1 + i) for i in range(date_diff)]
    #     self.rows = len(lines)
    #     self.cols = len(dates)
    #     self.dates = dates
    #
    #     # self.tile_rect = Rect2(0, 0, (w - ((len(self.dates) + 1) * self.border_width)) / max(1, len(self.dates)), (h - ((len(self.lines) + 1) * self.border_width)) / max(1, len(self.lines)))
    #     self.tile_rect = Rect2(self.border_width, self.border_width, (w - self.border_width) / max(1, len(self.dates)),
    #                            (h - self.border_width) / max(1, len(self.lines)))
    #     # self.tiles = flatten([[CalendarTile(self.tile_rect, self.border_width, i, j, line, date, random_colour()) for
    #     #                        j, date in enumerate(self.dates)] for i, line in enumerate(self.lines)])
    #     self.tiles = flatten([[CalendarTile(self.tile_rect, self.border_width, i, j, line, date, GRAY_17 if i != 0 and j != 0 else BLACK,
    #                                         text="Line: {}\nDate: {}".format(line, date.strftime("%Y-%m-%d") if isinstance(date, datetime.datetime) else date)) for
    #                            j, date in enumerate(self.dates)] for i, line in enumerate(self.lines)])
    #
    #     for i, tile in enumerate(self.tiles):
    #         idxrc = (i // self.rows), (i % self.rows)
    #         print("idxrc:", idxrc)
    #         idx = (idxrc[1] * self.rows) + idxrc[0]  # self.r_c_to_i(idxrc[1], idxrc[0])
    #         # idxrc = i // self.rows , (i % self.cols)
    #         # idx = (self.cols * (i // self.rows)) + (i % self.cols)
    #         idx = i
    #         print("from i: {} to idx: {}, idxrc: {}".format(i, idx, idxrc))
    #         data_row = data.iloc[idx:idx + 1, :]
    #         if data_row['InputField1'] is not None and data_row['InputField2'] is not None:
    #             # print("data_row:", data_row)
    #             # if idxrc[0] == 0 or idxrc[1] == 0:
    #             if i < self.cols or i % self.cols == 0:
    #                 continue
    #             if not data_row['WO#'].tolist():
    #                 continue
    #             if math.isnan(data_row['WO#'].tolist()[0]):
    #                 continue
    #             wo = int(data_row['WO#'].tolist()[0])
    #             model_name = data_row['InputField1'].tolist()[0]
    #             dealer = data_row['InputField2'].tolist()[0]
    #             status = data_row["Stock/Sold"].tolist()[0]
    #             beam = data_row["Beam WO#"].tolist()[0]
    #             job_start = data_row["JobStartDate"].tolist()[0]
    #             self.tiles[i].text = "{}\n{}\n{}\n{}\n{}\n{}".format(wo, model_name, dealer, status, beam, job_start)
    #
    #     # self.tiles = [CalendarTile(self.tile_rect, self.border_width, 0, i, "Dates", date, BLACK, text=date.strftime("%Y-%m-%d")) for i, date in enumerate(self.dates)] + self.tiles
    #     # self.rows += 1
    #     # tiles = []
    #     # for i, tile in range(len(self.rows):
    #     #
    #     #
    #     # self.cols += 1
    #
    #     self.og_tiles = [tile.__copy__() for tile in self.tiles]
    #
    #     print("{}\n{}".format(len(self.tiles), self.tiles))
    #
    #     self.dragging = None
    #     self.selected = None
    #     self.hovered = None
    #     self.hover_select = None
    #     self.current_hover = None
    #     self.draw_canvas()
    #     self.bind_canvas()

    # Exports to a one-page tabloid pdf.
    # Beware small texts
    def export_to_pdf_full(self):
        print("exporting...")
        if self.export_pdf_mode == "TABLOID":
            w_pdf = 625
            h_pdf = 750
            w_pdf = 500
            h_pdf = 750
            w_pdf = 470
            h_pdf = 750
            # w_pdf = 279
            # h_pdf = 432
            # w_pdf = 432
            # h_pdf = 279

            w_pdf = 590
            h_pdf = 750
            w_pdf, h_pdf = h_pdf, w_pdf

        else:
            print("Requested PDF export size not supported yet.")
            return

        # Init FPDF object
        title = r"ProdSched_V{}_{}--{}".format(self.version_num, self.start_date.strftime("%Y-%m-%d"), self.end_date.strftime("%Y-%m-%d"))
        f_name = title + "_full.pdf"
        pdf = PDF(f_name, 'L', 'mm', (h_pdf, w_pdf))
        pdf.set_auto_page_break(True, margin=5)
        pdf.set_title(title)
        pdf.set_author('Avery Briggs')
        pdf.add_page()
        pdf.margin_border(BWS_RED, WHITE)
        pdf.time_stamp()
        pdf.titles("Production Schedule\n{} - {}".format(dt.datetime.strftime(self.start_date, "%Y-%m-%d"), dt.datetime.strftime(self.end_date, "%Y-%m-%d")), (pdf.w - 50) / 2, 10, 50, 10, BLUE_4__DARKBLUE_)

        contents = {line: {self.dates[j % self.cols].strftime("%Y-%m-%d"): tile.get_pdf_text() for j, tile in enumerate(self.tiles) if tile.line == line} for i, line in enumerate(self.lines)}
        print(dict_print(contents, "Contents"))
        pdf.table(
            "",
            10,
            20,
            pdf.w - 20,
            contents,
            header_colours=[GRAY_36, WHITE],
            colours=[[WHITE, GRAY_69], [BWS_BLACK]],
            show_row_names=True,
            row_name_col_lbl="Date",
            cell_height=3.85,
            cell_font=('Arial', '', 9),
            top_margin=0,
            left_margin=0
            # ,
            # header_font=('Arial', 'B', 20)
        )

        # Save and Open
        pdf.output(f_name, 'F')
        pdf.open_in_browser()

    # Exports to a two-page tabloid pdf.
    # Splits the 11 lines into 2 pages.
    def export_to_pdf(self):
        print("exporting...")
        if self.export_pdf_mode == "TABLOID":
            w_pdf = 625
            h_pdf = 750
            w_pdf = 500
            h_pdf = 750
            w_pdf = 470
            h_pdf = 750
            # w_pdf = 279
            # h_pdf = 432
            # w_pdf = 432
            # h_pdf = 279

            w_pdf = 590
            h_pdf = 750
            w_pdf, h_pdf = h_pdf, w_pdf

        else:
            print("Requested PDF export size not supported yet.")
            return

        # Init FPDF object
        title = r"ProdSched_V{}_{}--{}".format(self.version_num, self.start_date.strftime("%Y-%m-%d"), self.end_date.strftime("%Y-%m-%d"))
        f_name = title + ".pdf"
        pdf = PDF(f_name, 'L', 'mm', (h_pdf, w_pdf))
        pdf.set_auto_page_break(True, margin=5)
        pdf.set_title(title)
        pdf.set_author('Avery Briggs')
        pdf.add_page()
        pdf.margin_border(BWS_RED, WHITE)
        pdf.time_stamp()
        pdf.titles("Production Schedule\n{} - {}".format(dt.datetime.strftime(self.start_date, "%Y-%m-%d"), dt.datetime.strftime(self.end_date, "%Y-%m-%d")), (pdf.w - 50) / 2, 10, 50, 10, BLUE_4__DARKBLUE_)

        contents_first = {line: {self.dates[j % self.cols].strftime("%Y-%m-%d"): tile.get_pdf_text() for j, tile in enumerate(self.tiles) if tile.line == line} for i, line in enumerate(self.lines[:len(self.lines)])}
        contents_last = {line: {self.dates[j % self.cols].strftime("%Y-%m-%d"): tile.get_pdf_text() for j, tile in enumerate(self.tiles) if tile.line == line} for i, line in enumerate(self.lines[len(self.lines):])}
        print(dict_print(contents_first, "Contents First"))
        print(dict_print(contents_last, "Contents Last"))
        # contents_first = contents[:len(contents) // 2]
        # contents_last = contents[len(contents) // 2:]
        pdf.table(
            "",
            10,
            20,
            pdf.w - 20,
            contents_first,
            header_colours=[GRAY_36, WHITE],
            colours=[[WHITE, GRAY_69], [BWS_BLACK]],
            show_row_names=True,
            row_name_col_lbl="Date / Line",
            cell_height=3.85,
            cell_font=('Arial', '', 9),
            top_margin=0,
            left_margin=0
            # ,
            # header_font=('Arial', 'B', 20)
        )
        pdf.add_page()
        pdf.table(
            "",
            10,
            20,
            pdf.w - 20,
            contents_last,
            header_colours=[GRAY_36, WHITE],
            colours=[[WHITE, GRAY_69], [BWS_BLACK]],
            show_row_names=True,
            row_name_col_lbl="Date / Line",
            cell_height=3.85,
            cell_font=('Arial', '', 9),
            top_margin=0,
            left_margin=0
            # , new_page_for_table=True
            # ,
            # header_font=('Arial', 'B', 20)
        )

        # Save and Open
        pdf.output(f_name, 'F')
        pdf.open_in_browser()

    def populate_pop_up_menu(self):
        self.canvas_pop_up.add_command(label="Add 1 Day", command=self.add_day)
        self.canvas_pop_up.add_command(label="Subtract 1 Day", command=self.subtract_day)
        self.canvas_pop_up.add_separator()
        self.canvas_pop_up.add_checkbutton(label="Apply to Entire Line")
        self.canvas_pop_up.add_radiobutton(label="A")
        self.canvas_pop_up.add_radiobutton(label="B")

    def wipe_pop_up_menu(self):
        self.canvas_pop_up.delete(0, 6)

    def set_user_hover_mode(self, use_hover):
        self.switch_use_hover = use_hover

    def bind_canvas(self):
        self.canvas.bind("<Motion>", self.hovering)
        self.canvas.bind("<Leave>", self.leaving)
        self.canvas.bind("<Enter>", self.hover_entering)
        self.canvas.bind("<Button-1>", self.click_print)
        self.canvas.bind("<Double-Button-1>", self.dbl_click_tile)
        self.canvas.bind("<B1-Motion>", self.drag_print)
        self.canvas.bind("<ButtonRelease-1>", self.release_drag)

    def unbind_canvas(self):
        self.canvas.unbind("<Button-1>")
        self.canvas.unbind("<B1-Motion>")

    def unbind_for_pop_up(self):
        self.canvas.unbind("<Motion>")
        self.canvas.unbind("<Leave>")
        self.unbind_canvas()

    def dbl_click_tile(self, *args):
        # if self.showing_pop_up:
        #     self.showing_pop_up = not self.showing_pop_up
        #     return
        event = args[0]
        mouse_x, mouse_y = event.x, event.y
        r, c = self.x_y_to_r_c(mouse_x, mouse_y)
        i = self.r_c_to_i(r, c)
        if i in range(len(self.tiles)):
            self.wipe_pop_up_menu()
            # self.showing_pop_up = True
            self.dbl_clicked = i
            tile = self.tiles[i]
            rect = tile.rect
            tw = rect[2] - rect[0]
            th = rect[3] - rect[1]
            # tile.colour = brighten(tile.colour, 0.25)
            h, w = 12, 25
            # try:
            if 1:

                self.dbl_clicked = self.r_c_to_i(r, c)
                print("double clicked:", self.dbl_clicked)
                tw = self.tile_rect.width
                th = self.tile_rect.height
                rw = max(tw, self.readable_width)
                rh = max(th, self.readable_height)
                ntw = (self.width - (rw - tw) - (3 * self.border_width)) / max(1, self.cols)
                nth = (self.height - (rh - th) - (3 * self.border_width)) / max(1, self.rows)
                if 1:
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

                self.draw_canvas()
                self.populate_pop_up_menu()
                print("TRY", self.dbl_clicked)
                self.unbind_for_pop_up()
                x = int(event.x_root) + tw
                y = int(event.y_root)
                self.canvas_pop_up.tk_popup(event.x_root,
                                            event.y_root)

            # finally:
            if 1:
                print("FINALLY", self.dbl_clicked)
                # self.canvas_pop_up.grab_release()
                self.bind_canvas()
            # cpu = self.canvas_pop_up
            # cpu.delete("all")
            # cpu.config(height=h, width=w)
            # cpu.config(x1=30, y1=12)
            # self.draw_canvas()
        self.selected = None
        self.hovered = None
        self.hover_select = None
        self.dragging = None
        self.current_hover = None

    def leaving(self, *args):
        print("Left")
        # self.tiles = [tile.__copy__() for tile in self.og_tiles]
        for i, tile in enumerate(self.og_tiles):
            self.tiles[i].rect = tuple([v for v in self.og_tiles[i].rect])
        self.hovered = None
        self.current_hover = None
        self.draw_canvas()

    def hover_entering(self, *args):
        event = args[0]
        mouse_x, mouse_y = event.x, event.y
        self.current_hover = self.r_c_to_i(*self.x_y_to_r_c(mouse_x, mouse_y))
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
        self.current_hover = self.r_c_to_i(*rc)
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

        # if self.showing_pop_up:
        #     self.canvas_pop_up.config(state="disabled")
        # else:
        #     self.canvas_pop_up.config(state="normal")

        for tile in self.tiles:
            show_txt = not self.hiding_non_selected_tiles
            # print("tile.rect.tupl:", tile.rect)
            bgc = tile.colour
            r, c = tile.row, tile.col
            tile_num = self.r_c_to_i(r, c)
            if sum(bgc) < 300:
                fgc = WHITE
                if tile_num in [self.dragging, self.selected, self.hover_select, self.current_hover, self.dbl_clicked]:
                    outline = WHITE
                    show_txt = True
                else:
                    outline = bgc
            else:
                fgc = BLACK
                if tile_num in [self.dragging, self.selected, self.hover_select, self.current_hover, self.dbl_clicked]:
                    outline = GRAY_15
                    show_txt = True
                else:
                    outline = bgc
            tile_txt = tile.text if tile.text is not None else tile_num
            self.canvas.create_rectangle(*tile.rect, fill=rgb_to_hex(bgc), outline=rgb_to_hex(outline),
                                         width=self.border_width)
            # print("tile_num: {}\ntile_txt: {}".format(tile_num, tile_txt))
            if show_txt:
                self.canvas.create_text(tile.rect[0] + ((tile.rect[2] - tile.rect[0]) / 2),
                                        tile.rect[1] + ((tile.rect[3] - tile.rect[1]) / 2), fill=rgb_to_hex(fgc),
                                        font="Times 12 italic bold", text=str(tile_txt))
            else:
                # raise ValueError("HEY")
                tile_num = "" if tile.wo_num is None else tile.wo_num
                self.canvas.create_text(tile.rect[0] + ((tile.rect[2] - tile.rect[0]) / 2),
                                        tile.rect[1] + ((tile.rect[3] - tile.rect[1]) / 2), fill=rgb_to_hex(fgc),
                                        font="Times 12 italic bold", text=str(tile_num))
        self.redraw_legend()

    def redraw_legend(self):
        self.canvas_header_row.delete("all")
        self.canvas_header_col.delete("all")

        for i, tile in enumerate(self.tiles):
            r, c = self.i_to_r_c(i)
            rect = tile.rect
            if r == 0 or c == 0:
                tw = (rect[2] - rect[0]) + self.border_width
                th = (rect[3] - rect[1]) + self.border_width
                if r == 0:
                    th = 25
                if c == 0:
                    tw = 60
                if r == 0:
                    # self.canvas_header_row.create_text((c * tw) + 60 + (tw / 2) + self.border_width, th / 2, fill=rgb_to_hex(WHITE), font="Times 12 italic bold", text=tile.date.strftime("%Y-%m-%d"))
                    self.canvas_header_row.create_text(60 + rect[0] + (tw / 2), th / 2, fill=rgb_to_hex(WHITE), font="Times 12 italic bold", text=tile.date.strftime("%Y-%m-%d"))
                if c == 0:
                    # self.canvas_header_col.create_text(tw / 2, (r * th) + 25 + (th / 2) + self.border_width, fill=rgb_to_hex(WHITE), font="Times 12 italic bold", text=tile.line)
                    self.canvas_header_col.create_text(tw / 2, rect[1] + (th / 2), fill=rgb_to_hex(WHITE), font="Times 12 italic bold", text=tile.line)


        # th = self.tile_rect.h
        # # cw, ch = canvas_header_col.size()
        # cw, ch = 60, self.height
        # tw = cw
        # print("tw: {}, th: {}, cw: {}, ch: {}".format(tw, th, cw, ch))
        # print("tw: {}, th: {}, cw: {}, ch: {}".format(type(tw), type(th), type(cw), type(ch)))
        # for i, line in enumerate(self.lines):
        #     print("line:", line)
        #     l_rect = (0, i * th, tw, (i + 1) * th)
        #     # l_rect = l_rect[2] - l_rect[0], l_rect[3] - l_rect[1]
        #     l_rect = l_rect[0] + ((l_rect[2] - l_rect[0]) / 2), l_rect[1] + ((l_rect[3] - l_rect[1]) / 2)
        #     # l_rect = l_rect[0], l_rect[1]
        #     self.canvas_header_col.create_text(*l_rect, fill=rgb_to_hex(WHITE), font="Times 12 italic bold", text=line)
        #
        # tw = self.tile_rect.w
        # # cw, ch = canvas_header_row.size()
        # cw, ch = self.width, 25
        # th = ch
        # print("tw: {}, th: {}, cw: {}, ch: {}".format(tw, th, cw, ch))
        # print("tw: {}, th: {}, cw: {}, ch: {}".format(type(tw), type(th), type(cw), type(ch)))
        # for i, date in enumerate(self.dates):
        #     print("date:", date)
        #     l_rect = ((i * tw), 0, ((i + 1) * tw), th)
        #     l_rect = l_rect[0] + ((l_rect[2] - l_rect[0]) / 2) + 60, l_rect[1] + ((l_rect[3] - l_rect[1]) / 2)
        #     # l_rect = l_rect[0], l_rect[1]
        #     self.canvas_header_row.create_text(*l_rect, fill=rgb_to_hex(WHITE), font="Times 12 italic bold",
        #                                        text=date.strftime("%Y-%m-%d"))
        #
        #





        # self.canvas_header_row.delete("all")
        # self.canvas_header_col.delete("all")
        #
        # th = self.tile_rect.h
        # # cw, ch = canvas_header_col.size()
        # cw, ch = 60, self.height
        # tw = cw
        # print("tw: {}, th: {}, cw: {}, ch: {}".format(tw, th, cw, ch))
        # print("tw: {}, th: {}, cw: {}, ch: {}".format(type(tw), type(th), type(cw), type(ch)))
        # for i, line in enumerate(self.lines):
        #     print("line:", line)
        #     l_rect = (0, i * th, tw, (i + 1) * th)
        #     # l_rect = l_rect[2] - l_rect[0], l_rect[3] - l_rect[1]
        #     l_rect = l_rect[0] + ((l_rect[2] - l_rect[0]) / 2), l_rect[1] + ((l_rect[3] - l_rect[1]) / 2)
        #     # l_rect = l_rect[0], l_rect[1]
        #     self.canvas_header_col.create_text(*l_rect, fill=rgb_to_hex(WHITE), font="Times 12 italic bold", text=line)
        #
        # tw = self.tile_rect.w
        # # cw, ch = canvas_header_row.size()
        # cw, ch = self.width, 25
        # th = ch
        # print("tw: {}, th: {}, cw: {}, ch: {}".format(tw, th, cw, ch))
        # print("tw: {}, th: {}, cw: {}, ch: {}".format(type(tw), type(th), type(cw), type(ch)))
        # for i, date in enumerate(self.dates):
        #     print("date:", date)
        #     l_rect = ((i * tw), 0, ((i + 1) * tw), th)
        #     l_rect = l_rect[0] + ((l_rect[2] - l_rect[0]) / 2) + 60, l_rect[1] + ((l_rect[3] - l_rect[1]) / 2)
        #     # l_rect = l_rect[0], l_rect[1]
        #     self.canvas_header_row.create_text(*l_rect, fill=rgb_to_hex(WHITE), font="Times 12 italic bold",
        #                                   text=date.strftime("%Y-%m-%d"))

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
        print("BEGIN: sel: {}, hsl: {}, drg: {}".format(self.selected, self.hover_select, self.dragging))
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
            print("END A: sel: {}, hsl: {}, drg: {}".format(self.selected, self.hover_select, self.dragging))
            return
        self.dragging = new_select
        self.selected = new_select
        self.hover_select = new_select
        self.draw_canvas()
        print("END B: sel: {}, hsl: {}, drg: {}".format(self.selected, self.hover_select, self.dragging))

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
        # self.tiles[dragging_tile].text = new_tile[0] if new_tile[0] is not None else str(hover_tile)
        t_data = self.tiles[dragging_tile].__copy__()
        self.tiles[dragging_tile].set_data(*self.tiles[hover_tile].get_data())
        self.tiles[dragging_tile].colour = new_tile[1]
        # self.tiles[hover_tile].text = old_tile[0] if old_tile[0] is not None else str(dragging_tile)
        self.tiles[hover_tile].set_data(*t_data.get_data())
        self.tiles[hover_tile].colour = old_tile[1]

    def add_day(self):
        print("add_day clicked:", self.dbl_clicked)
        tile = self.tiles[self.dbl_clicked]
        print("tile:", tile)
        tile.colour = darken(tile.colour, 0.1)
        self.dbl_clicked = None
        self.draw_canvas()

    def subtract_day(self):
        print("add_day clicked:", self.dbl_clicked)
        tile = self.tiles[self.dbl_clicked]
        print("tile:", tile)
        tile.colour = brighten(tile.colour, 0.1)
        self.dbl_clicked = None
        self.draw_canvas()