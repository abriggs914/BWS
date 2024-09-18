from customtkinter_utility import *
from colour_utility import *


class App(ctk.CTk):

    def __init__(self, **kwargs):
        super().__init__(**kwargs)

        self.width, self.height = 500, 500

        self.default_font = "Arial", 12
        self.default_text_fill_start = Colour("#000000")
        self.default_text_fill_end = Colour("#696969")
        self.default_text_outline_start = Colour("#FFFFFF")
        self.default_text_outline_end = Colour("#BBBBBB")
        self.default_text_outline_width = 1
        self.default_text_anchor = ctk.CENTER
        self.default_text_anchor_outline = ctk.CENTER
        self.default_canvas_background = Colour("#343434")

        self.canvas = ctk.CTkCanvas(
            self,
            width=self.width,
            height=self.height,
            background=self.default_canvas_background.hex_code
        )

        self.texts_to_do = [
            ["STARGATE"],
            ["BWS"]
        ]
        self.kwargs_texts = {
            "STARGATE": {
                "font": ("Verdana", 40, "bold"),
                "fill_start": Colour(STARGATE_BLUE),
                "outline_start": Colour("#FFFFFF"),
                "anchor": ctk.N,
                "anchor_outline": ctk.N,
                "outline_width": 2
            },
            "BWS": {
                "font": ("Impact", 112, "bold"),
                "fill_start": Colour(BWS_RED),
                "outline_start": Colour(BWS_GREY),
                "anchor": ctk.S,
                "anchor_outline": ctk.S,
                "outline_width": 3
            }
        }
        self.tags = {}

        self.width_text = int(self.width * 0.85)
        self.height_text = int(self.height * 0.85)
        self.height_text_row = self.height_text / len(self.texts_to_do)

        xpls = []
        # min_xpl, max_xpl = float("inf"), -1
        # min_n_let, max_n_let = float("inf"), -1
        for row in self.texts_to_do:
            n_let = 0
            for txt in row:
                n_let += len(txt)
            n_let += len(row) - 1
            xpl = self.width_text / n_let
            xpls.append({
                "xpl": xpl,
                "n_let": n_let
            })
            # min_xpl = min(min_xpl, xpl)
            # min_n_let = min(min_n_let, n_let)
            # max_xpl = max(max_xpl, xpl)
            # max_n_let = max(max_n_let, n_let)

        # min_xpl, max_xpl = min([xpl["xpl"] for xpl in xpls]), max([xpl["xpl"] for xpl in xpls])

        # print(f"{xpls=}")
        # print(f"{min_xpl=}, {max_xpl=}\n{min_n_let=}, {max_n_let=}\nhpr={self.height_text_row}")

        x0 = (self.width - self.width_text) / 2
        y0 = (self.height - self.height_text) / 2
        for i, row in enumerate(self.texts_to_do):
            self.tags.setdefault(i, {})
            xpl = xpls[i]["xpl"]
            for j, txt in enumerate(row):
                self.tags[i].setdefault(j, {})
                for k, let in enumerate(txt):
                    if let:
                        x = x0 + ((k + 0.5) * xpl)
                        y = y0 + ((i + 0.5) * self.height_text_row)  # + (self.height_text_row / 2)
                        kwargs = self.kwargs_texts.get(txt, {})
                        fill_start = kwargs.get("fill_start", self.default_text_fill_start)
                        outline_start = kwargs.get("outline_start", self.default_text_outline_start)
                        # fill_end = kwargs.get("fill_start", self.default_text_fill_end)
                        # outline_end = kwargs.get("outline_start", self.default_text_outline_end)
                        anchor_0 = kwargs.get("anchor", self.default_text_anchor)
                        anchor_1 = kwargs.get("anchor_outline", self.default_text_anchor_outline)
                        outline_width = kwargs.get("outline_width", self.default_text_outline_width)
                        font_0 = kwargs.get("font", self.default_font)
                        font_1 = [font_0[0], font_0[1] - outline_width]
                        if len(font_0) == 3:
                            font_1.append(font_0[2])
                        self.tags[i][j].setdefault(k, {
                            "rect": self.canvas.create_rectangle(
                                x0 + (k * xpl),
                                y0 + (i * self.height_text_row),
                                x0 + ((k + 1) * xpl),
                                y0 + ((i + 1) * self.height_text_row),
                                fill=random_colour(rgb=False)
                            ),
                            "tag_0": self.canvas.create_text(
                                x, y,
                                text=let,
                                font=font_0,
                                fill=outline_start.hex_code,
                                anchor=anchor_0
                            ),
                            "tag_1": self.canvas.create_text(
                                x, y,
                                text=let,
                                font=font_1,
                                fill=fill_start.hex_code,
                                anchor=anchor_1
                            ),
                            "text": let
                        })
                        self.canvas.itemconfigure(
                            self.tags[i][j][k]["rect"],
                            state=ctk.HIDDEN
                        )

        self.frame_controls = ctk.CTkFrame(self)
        self.btn_start = button_factory(
            self.frame_controls,
            tv_btn="start",
            command=self.start
        )
        self.btn_end = button_factory(
            self.frame_controls,
            tv_btn="end",
            command=self.end
        )

        self.canvas.grid(row=0, column=0)
        self.frame_controls.grid(row=1, column=0)
        self.frame_controls.rowconfigure(0, weight=100)
        self.btn_start[1].grid(row=0, column=0)
        self.btn_end[1].grid(row=0, column=1)
        self.rowconfigure(0, weight=90)
        self.rowconfigure(1, weight=10)
        self.columnconfigure(0, weight=100)

    def start(self):
        print(f"start")

        n_slices = 24
        sps = 25
        s_off = 0

        for i, row in enumerate(self.texts_to_do):
            for j, txt in enumerate(row):
                kwargs = self.kwargs_texts.get(txt, {})
                fill_start = kwargs.get("fill_start", self.default_text_fill_start)
                fill_end = kwargs.get("fill_start", self.default_text_fill_end)
                outline_start = kwargs.get("outline_start", self.default_text_outline_start)
                outline_end = kwargs.get("outline_start", self.default_text_outline_end)
                # grad_fill = [gradient(k, n_slices, fill_start, fill_end) for k in range(n_slices + 1)]
                # grad_outline = [gradient(k, n_slices, outline_start, outline_end) for k in range(n_slices + 1)]
                for k, let in enumerate(txt):
                    for l in range(n_slices + 1):
                        print(f"{i=}, {j=}, {k=}, {l=}, {txt=}, {let=}, {s_off=}, {(l*sps)+s_off=}")
                        self.after(
                            (l * sps) + s_off,
                            lambda i_=i, j_=j, k_=k, l_=l, o_s=outline_start, o_e=outline_end:
                                self.canvas.itemconfigure(
                                    self.tags[i_][j_][k_]["tag_0"],
                                    fill=gradient(l_, n_slices, o_s, o_e, rgb=False)
                                )
                        )
                        self.after(
                            (l * sps) + s_off,
                            lambda i_=i, j_=j, k_=k, l_=l, f_s=fill_start, f_e=fill_end:
                                self.canvas.itemconfigure(
                                    self.tags[i_][j_][k_]["tag_1"],
                                    fill=gradient(l_, n_slices, f_s, f_e, rgb=False)
                                )
                        )
                    # tspl = (n_slices + 1) * sps
                    s_off += (n_slices + 1) * sps
                    s_off *= 0.5
                    s_off = int(s_off)

    def end(self):
        print(f"end")


if __name__ == '__main__':

    app = App()
    app.mainloop()