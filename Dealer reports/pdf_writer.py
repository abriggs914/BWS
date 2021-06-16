import math
import os

from utility import *
from colour_utility import *
from fpdf import FPDF
import webbrowser


MARGIN_LINES_WIDTH = 3


class PDF(FPDF):

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.w = 210
        self.h = 297
        self.page_heights = [0]

    def titles(self, title, x, y, w, h, colour, align="C", border=0):
        # self.set_fill_color(*BWS_GREY)
        # self.rect(0, 0, 210, 20, "FD")
        self.set_font('Arial', 'B', 16)
        self.set_xy(x, y)
        self.set_text_color(*colour)
        self.cell(w=w, h=h, align=align, txt=title, border=border)

    def texts(self, x, y, name, font=('Arial', '', 12), font_colour=BLACK):
        if name in os.listdir():
            with open(name, 'rb') as xy:
                txt = xy.read().decode('latin-1')
        else:
            txt = name
        self.set_xy(x, y)
        self.set_text_color(*font_colour)
        self.set_font(*font)
        self.multi_cell(0, 10, txt, align='J')

    def margin_lines(self, x, y, w, h, border_colour, content_colour, border_width=MARGIN_LINES_WIDTH):
        self.set_fill_color(*border_colour)  # color for outer rectangle
        self.rect(x, y, w, h, 'DF')
        self.set_fill_color(*content_colour)  # color for inner rectangle
        self.rect(x + border_width, y + border_width, w - (2 * border_width), h - (2 * border_width), 'FD')

        # self.rect(5.0, 5.0, 200.0, 287.0)

        # self.set_line_width(0.0)
        # self.line(5.0, 5.0, 205.0, 5.0)  # top one
        # self.line(5.0, 292.0, 205.0, 292.0)  # bottom one
        # self.line(5.0, 5.0, 5.0, 292.0)  # left one
        # self.line(205.0, 5.0, 205.0, 292.0)  # right one

    def table(self, title, x, y, w, contents, header_colours=(0,0 ), colours=(WHITE)):
        if not isinstance(contents, dict) and dict:
            raise ValueError("Parameter \"contents\" must be a populated dict object.")

        cx = cy = 0
        th = 20
        page_left = self.h - (2 * (TABLE_MARGIN + MARGIN_LINES_WIDTH)) - th
        title_margin = 5
        top_margin = 8
        bottom_margin = 8
        left_margin = 8
        right_margin = 8
        line_width = 0
        header = []
        content_lst = [[]]
        # otx = TABLE_MARGIN + MARGIN_LINES_WIDTH + left_margin
        # oty = TABLE_MARGIN + MARGIN_LINES_WIDTH + top_margin
        # ocx = otx + (1.5 * line_width)
        # ocy = oty + line_width + th

        otx = x + left_margin
        oty = y + top_margin
        ocx = otx + (1.5 * line_width)
        ocy = oty + line_width + th

        self.titles(title, otx + (title_margin / 2), oty + (title_margin / 2), w - (2 * title_margin), th - (2 * title_margin), BWS_RED)
        self.set_fill_color(*BWS_BLACK)

        for i, itms in enumerate(contents):
            row = itms
            col_vals = contents[row]
            # print("row:", row, "col_vals:", col_vals)
            content_lst.append([])
            for head, value in col_vals.items():
                h_names = [h[0] for h in header]
                j = lstindex(h_names, head)
                mhv = max(len(str(head)), len(str(value)))
                if j == -1:
                    header.append((head, mhv))
                    content_lst[0].append(head)
                else:
                    header[j] = (head, max(header[j][1], mhv))

                h_names = [h[0] for h in header]
                j = lstindex(h_names, head)
                c = len(content_lst[i + 1])
                if 0 < i:
                    d = c - j
                    # print("i: ", i, "c:", c, "d:", d, "j:", j, "value:", value, "content_list[i]:", content_lst[i + 1])
                    if d <= 0:
                        content_lst[i + 1] += [None for k in range(abs(d))]
                if j < c:
                    content_lst[i + 1][j] = value
                else:
                    content_lst[i + 1].append(value)

        n_rows = len(contents)
        n_cols = len(header)

        for row in content_lst:
            row += [None for i in range(max(0, n_cols - len(row)))]

        height = page_left - top_margin - bottom_margin - (2 * title_margin) - ((2 + n_rows) * line_width)
        width = self.w - (2 * (TABLE_MARGIN + MARGIN_LINES_WIDTH)) - left_margin - right_margin - ((1 + n_cols) * line_width)
        print("self.w:", self.w, "width:", width)
        cell_height = height / (1 + n_rows)
        cell_width = width / n_cols
        print("header:", header)
        print("\n##\n" + "\n".join(list(map(str, content_lst))) + "\n##\n")
        print("(N x M): ({} x {})".format(n_rows, n_cols))
        print("(H x W): ({} x {})".format(height, width))
        print("(CH x CW): ({} x {})".format(cell_height, cell_width))

        self.set_fill_color(*BWS_GREY)
        cch = cell_height + (line_width / 2)
        pages = 0
        i_off = 0
        space_used = 0
        print("ocy:", ocy, "height:", height, "self.h:", self.h)
        for i in range(n_rows + 1):

            if i == 0:
                self.set_font('Arial', 'B', 14)
                self.set_fill_color(*header_colours[0])
                self.set_text_color(*header_colours[1])
                ch = cch
            else:
                self.set_font('Arial', '', 10)
                fill_colour = colours[0][i % len(colours[0])]
                font_colour = colours[1][i % len(colours[1])]
                self.set_fill_color(*fill_colour)
                self.set_text_color(*font_colour)
                ch = 5

            cy = ocy + (((i) * ch) + max(0, ((1 if i else 0) * cch) - 5)) - (pages * space_used) + FOOTER_MARGIN
            # print("\tself.get_y():", self.get_y(), "ch:", ch, "self.h:", self.h, "(self.get_y() + ch):", (self.get_y() + ch), "(self.get_y() + ch) >= self.h:", (self.get_y() + ch) >= self.h)
            # print("\tcy:", cy, "ch:", ch, "self.h:", self.h, "(cy + ch):", (cy + ch), "(cy + ch) >= self.h:", ((cy + ch) >= self.h))
            if (cy + ch) >= page_left:
                self.add_page()
                self.set_xy(cx, 0)
                page_left = self.h
                pages += 1
                print("\tpage break on line i={}".format(i))
                i_off += i

            for j in range(n_cols):
                cell_value = str(content_lst[i][j])
                cw = cell_width + (line_width / 2)
                cx = ocx + (j * cw)
                # cy = ocy + (((i - i_off) * ch) + max(0, ((1 if i else 0) * cch) - 5)) - (pages * height)
                cy = ocy + (((i) * ch) + max(0, ((1 if i else 0) * cch) - 5)) - (pages * space_used) + FOOTER_MARGIN
                print("pages: {} i: {} j: {} cx: {} cy: {}, self.get_y: {} cv: {}".format(pages, i, j, cx, cy, self.get_y(), cell_value))
                self.rect(cx, cy, cell_width, ch, 'DF')
                # self.texts(cx + (cw / 2), cy + (ch / 2), cell_value)
                # self.texts(cx, cy, cell_value)
                self.set_xy(cx, cy)
                self.cell(cell_width, ch, cell_value, 1, 1, 'C')
                space_used += ch
                # x, y, name, font=('Arial', '', 12), font_colour=BLACK

        # self.rect(x, y, w, height, 'FD')
        self.rect(0, self.h - FOOTER_MARGIN, self.w, FOOTER_MARGIN, 'FD')
        return cx, cy


if __name__ == "__main__":
    pdf = PDF(orientation='P', unit='mm', format='A4')
    pdf.set_auto_page_break(True, margin=5)
    pdf.set_title("Dealer Delivery Reports")
    pdf.add_page()
    print("pdf.page_no():", pdf.page_no())
    pdf.margin_lines(5, 5, 200, 287, BWS_RED, (255, 255, 255))
    pdf.titles("Dealer Delivery Reports", 0, 0, 210, 40, BWS_BLACK)
    pdf.set_author('Avery Briggs')

    TABLE_MARGIN = 10
    FOOTER_MARGIN = 10

    # TABLE_X = 5 + MARGIN_LINES_WIDTH + TABLE_MARGIN
    # TABLE_Y = 10 + MARGIN_LINES_WIDTH + TABLE_MARGIN
    TABLE_W = 200 - (2 * (MARGIN_LINES_WIDTH + TABLE_MARGIN))
    # TABLE_H = 200 - (2 * (MARGIN_LINES_WIDTH + TABLE_MARGIN))

    contents_1 = {
        1: {"a": 1, "b": 2, "c": 1},
        2: {"a": 2, "b": 563, "c": 2, "d": 15},
        3: {"a": 3, "b": 3, "c": 3, "d": 5},
        4: {"a": 4, "b": 4, "c": 4, "d": 5},
        5: {"c": 44, "d": 6},
        8: {"b": "Really lo", "d": 54566678898, "a": "This stri"},
        6: {"e": 2},
        9: {"e": 22},
        10: {"d": 24},
        11: {"b": 16},
        7: {"e": 21, "d": 5, "a": 13},
        12: {'d': 55, 'c': 90, 'a': 84},
        13: {'c': 92, 'b': 86},
        14: {'a': 36},
        15: {'b': 54},
        16: {'b': 57},
        17: {'b': 31, 'a': 83, 'd': 23, 'c': 55},
        18: {'d': 63, 'a': 31, 'c': 72},
        19: {'c': 85},
        20: {'b': 96, 'a': 12, 'e': 30},
        21: {'b': 25, 'e': 55},
        22: {'d': 77, 'c': 24, 'a': 28},
        23: {'d': 40, 'c': 82},
        24: {'e': 84, 'd': 57},
        25: {'e': 89},
        26: {'a': 90},
        27: {'a': 93, 'c': 30, 'e': 22},
        28: {'c': 80},
        29: {'b': 5, 'c': 64, 'e': 35},
        30: {'e': 76, 'c': 88},
        31: {'e': 68, 'b': 49, 'a': 24, 'c': 78},
        32: {'a': 0, 'e': 34, 'c': 44, 'd': 25},
        33: {'d': 68, 'a': 19, 'b': 63},
        34: {'e': 74, 'c': 2},
        35: {'b': 24, 'e': 92, 'c': 98},
        36: {'d': 82, 'e': 23, 'c': 46},
        37: {'e': 62, 'a': 94},
        38: {'d': 59, 'c': 32},
        39: {'e': 48},
        40: {'b': 79, 'a': 93, 'd': 61, 'e': 12}
    }
    contents_2 = {
        1: {"a": 1, "b": 2, "c": 1},
        2: {"a": 2, "b": 563, "c": 2, "d": 15},
        3: {"a": 3, "b": 3, "c": 3, "d": 5},
        4: {"a": 4, "b": 4, "c": 4, "d": 5},
        8: {"b": "Really lo", "d": 54566678898, "a": "This stri"},
        6: {"e": 2},
        9: {"e": 22},
        10: {"d": 24},
        7: {"e": 21, "d": 5, "a": 13},
        12: {'d': 55, 'c': 90, 'a': 84},
        13: {'c': 92, 'b': 86},
        15: {'b': 54},
        17: {'b': 31, 'a': 83, 'd': 23, 'c': 55},
        18: {'d': 63, 'a': 31, 'c': 72},
        22: {'d': 77, 'c': 24, 'a': 28},
        23: {'d': 40, 'c': 82},
        26: {'a': 90},
        27: {'a': 93, 'c': 30, 'e': 22},
        30: {'e': 76, 'c': 88},
        31: {'e': 68, 'b': 49, 'a': 24, 'c': 78},
        32: {'a': 0, 'e': 34, 'c': 44, 'd': 25},
        33: {'d': 68, 'a': 19, 'b': 63},
        34: {'e': 74, 'c': 2},
        38: {'d': 59, 'c': 32},
        39: {'e': 48},
        40: {'b': 79, 'a': 93, 'd': 61, 'e': 12}
    }
    contents_3 = {
        1: {"a": 1, "b": 2, "c": 154654654457112245748},
        2: {"a": 2, "b": 563, "c": 2, "d": 15},
        3: {"a": 3, "b": 3, "c": 3, "d": 5},
        4: {"a": 4, "b": 4, "c": 4, "d": 5},
        8: {"b": "Really lo", "d": 54566678898, "a": "This stri"},
        6: {"e": 2},
        17: {'b': 31, 'a': 83, 'd': 23, 'c': 55},
        18: {'d': 63, 'a': 31, 'c': 72},
        30: {'e': 76, 'c': 88},
        31: {'e': 68, 'b': 49, 'a': 24, 'c': 78},
        40: {'b': 79, 'a': 93, 'd': 61, 'e': 12}
    }

    TABLE_X = TABLE_MARGIN + MARGIN_LINES_WIDTH
    TABLE_Y = TABLE_MARGIN + MARGIN_LINES_WIDTH
    table1 = pdf.table(
        title="Remorques Lewis",
        x=TABLE_X,
        y=TABLE_Y,
        w=TABLE_W,
        contents=contents_3,
        header_colours=[BLACK, BWS_RED],
        colours=[[BWS_RED, BWS_GREY, BWS_BLACK], [BWS_BLACK, BWS_RED, BWS_RED]]
    )

    print("1. (TABLE_X, TABLE_Y): ({}, {})".format(TABLE_X, TABLE_Y))
    TABLE_Y = table1[1]
    print("2. (TABLE_X, TABLE_Y): ({}, {})".format(TABLE_X, TABLE_Y))

    table2 = pdf.table(
        title="NorthEast",
        x=TABLE_X,
        y=TABLE_Y,
        w=TABLE_W,
        contents=contents_1,
        header_colours=[BLACK, BWS_RED],
        colours=[[BWS_RED, BWS_GREY, BWS_BLACK], [BWS_BLACK, BWS_RED, BWS_RED]]
    )

    TABLE_Y = table2[1]

    table3 = pdf.table(
        title="Fort Garry International Ltd.",
        x=TABLE_X,
        y=TABLE_Y,
        w=TABLE_W,
        contents=contents_2,
        header_colours=[BLACK, BWS_RED],
        colours=[[BWS_RED, BWS_GREY, BWS_BLACK], [BWS_BLACK, BWS_RED, BWS_RED]]
    )

    pdf.output('test.pdf', 'F')

    print("Hello World!")
    print("table1:", table1)
    print("table2:", table2)
    webbrowser.open("test.pdf")
