from fpdf import FPDF
import webbrowser

BWS_RED = (171, 35, 40)
BWS_BLACK = (37, 40, 42)
BWS_GREY = (162, 170, 173)
MARGIN_LINES_WIDTH = 3
TABLE_MARGIN = 10


class PDF(FPDF):

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.w = 210
        self.h = 297
        self.page_heights = [0]

    def titles(self, title, x, y, w, h, colour, align="C", border=0):
        self.set_fill_color(*BWS_GREY)
        self.rect(0, 0, 210, 20, "FD")
        self.set_font('Arial', 'B', 16)
        self.set_xy(x, y)
        self.set_text_color(*colour)
        self.cell(w=w, h=h, align=align, txt=title, border=border)

    def texts(self, name):
        with open(name, 'rb') as xy:
            txt = xy.read().decode('latin-1')
        self.set_xy(10.0, 80.0)
        self.set_text_color(76.0, 32.0, 250.0)
        self.set_font('Arial', '', 12)
        self.multi_cell(0, 10, txt)

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

    def table(self, title, x, y, w, colours=((255, 255, 255))):
        self.titles(title, x, y, w, 40, BWS_RED)
        self.set_fill_color(*BWS_BLACK)
        self.rect(x, y, w, 1, 'FD')


pdf = PDF(orientation='P', unit='mm', format='A4')
pdf.set_title("Dealer Delivery Reports")
pdf.add_page()
pdf.add_page()
print("pdf.page_no():", pdf.page_no())
pdf.margin_lines(5, 5, 200, 287, BWS_RED, (255, 255, 255))
pdf.titles("Dealer Delivery Reports", 0, 0, 210, 40, BWS_BLACK)
pdf.set_author('Avery Briggs')

TABLE_X = 5 + MARGIN_LINES_WIDTH + TABLE_MARGIN
TABLE_Y = 40 + MARGIN_LINES_WIDTH + TABLE_MARGIN
TABLE_W = 200 - (2 * (MARGIN_LINES_WIDTH + TABLE_MARGIN))
# TABLE_H = 200 - (2 * (MARGIN_LINES_WIDTH + TABLE_MARGIN))

pdf.table("Remorques Lewis", TABLE_X, TABLE_Y, TABLE_W, [BWS_RED, BWS_GREY, BWS_BLACK])

pdf.output('test.pdf', 'F')

print("Hello World!")
webbrowser.open("test.pdf")
