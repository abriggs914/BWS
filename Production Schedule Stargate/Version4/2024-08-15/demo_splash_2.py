import math

from customtkinter_utility import *
from colour_utility import *


class Splash(ctk.CTkToplevel):

    def __init__(self, **kwargs):
        super().__init__(**kwargs)

        self.width: int = 500
        self.height: int = 500

        self.default_font: tuple[str, int] = "Arial", 12
        self.default_text_fill_start: Colour = Colour("#000000")
        self.default_text_fill_end: Colour = Colour("#696969")
        self.default_text_outline_start: Colour = Colour("#FFFFFF")
        self.default_text_outline_end: Colour = Colour("#BBBBBB")
        self.default_text_outline_width: int = 1
        self.default_text_anchor: str = ctk.CENTER
        self.default_text_anchor_outline: str = ctk.CENTER
        self.default_canvas_background: Colour = Colour("#242424")
        self.default_canvas_background_border: Colour = Colour("#ECA420")

        self.n_slices: int = 250
        self.time_between_re_runs: int = 600
        self.sec_per_slice = int(25 // 5)
        self.direction_forward = ctk.BooleanVar(self, value=True)
        self.n_cycles = ctk.IntVar(self, value=0)
        self.after_ids = {}
        self.after_ids_run = []
        self.after_ids_reset = []

        self.texts_to_do = [
            ["STARGATE"],
            ["LEWIS"],
            ["BWS"]
        ]
        self.kwargs_texts = {
            "STARGATE": {
                "font": ("Verdana", 40, "bold"),
                "fill_start": Colour(STARGATE_BLUE),
                "outline_start": Colour("#FFFFFF"),
                "fill_end": Colour(STARGATE_BLUE).darkened(0.25),
                "outline_end": Colour("#FFFFFF"),
                "anchor": ctk.N,
                "anchor_outline": ctk.N,
                "outline_width": 2
            },
            "LEWIS": {
                "font": ("Impact", 40, "bold"),
                "fill_start": Colour(GREENISH_BLUE),
                "outline_start": Colour(BWS_GREY),
                "fill_end": Colour(GREENISH_BLUE).darkened(0.25),
                "outline_end": Colour(BWS_GREY).darkened(0.25),
                "anchor": ctk.S,
                "anchor_outline": ctk.S,
                "outline_width": 3
            },
            "BWS": {
                "font": ("Impact", 112, "bold"),
                "fill_start": Colour(BWS_RED),
                "outline_start": Colour(BWS_GREY),
                "fill_end": Colour(BWS_RED).darkened(0.25),
                "outline_end": Colour(BWS_GREY).darkened(0.25),
                "anchor": ctk.S,
                "anchor_outline": ctk.S,
                "outline_width": 3
            }
        }
        self.tags = {}

        self.width_text = int(self.width * 0.85)
        self.height_text = int(self.height * 0.85)
        self.height_text_row = self.height_text / len(self.texts_to_do)
        self.width_background_border = 10
        self.width_moving_background = 2 * self.width_text

        self.configure(
            background=self.default_canvas_background.hex_code,
            borderwidth=0
        )

        self.canvas = ctk.CTkCanvas(
            self,
            width=self.width,
            height=self.height,
            background=self.default_canvas_background.hex_code,
            border=0,
            borderwidth=0
        )
        self.tag_background_0 = self.canvas.create_rectangle(
            0,
            0,
            self.width,
            self.height,
            fill=self.default_canvas_background.hex_code,
            outline=self.default_canvas_background.hex_code
        )
        self.bbox_og_border = (
            ((self.width - self.width_text) / 2) - (self.width_background_border / 2),
            ((self.height - self.height_text) / 2) - (self.width_background_border / 2),
            ((self.width - self.width_text) / 2) + self.width_text + (self.width_background_border / 2),
            ((self.height - self.height_text) / 2) + self.width_text + (self.width_background_border / 2)
        )
        w = 2
        self.tag_background_1 = self.canvas.create_rectangle(
            self.bbox_og_border[0] - w,
            self.bbox_og_border[1] - w,
            self.bbox_og_border[2] + w,
            self.bbox_og_border[3] + w,
            fill="#CCCCCC",
            outline=self.default_canvas_background_border.hex_code
        )
        self.tag_background_1 = self.canvas.create_rectangle(
            *self.bbox_og_border,
            fill=self.default_canvas_background_border.hex_code,
            outline=self.default_canvas_background_border.hex_code
        )

        self.bbox_og_moving_rect = (
            ((self.width - self.width_text) / 2) - (self.width_moving_background / 2),
            ((self.height - self.height_text) / 2) - (self.width_moving_background / 2),
            ((self.width - self.width_text) / 2) + self.width_text + (self.width_moving_background / 2),
            ((self.height - self.height_text) / 2) + self.width_text + (self.width_moving_background / 2)
        )
        # goes between the border and the top-most background rectangle
        # self.tag_moving_rect = self.canvas.create_rectangle(
        #     0,
        #     0,
        #     self.width,
        #     self.height,
        #     fill=self.default_canvas_background.hex_code,
        #     outline=self.default_canvas_background.hex_code
        # )
        self.tag_moving_rect = self.canvas.create_oval(
            *self.bbox_og_moving_rect,
            fill=self.default_canvas_background.hex_code,
            outline=self.default_canvas_background.hex_code
        )

        self.width_oval = 10
        self.height_oval = 10
        self.tag_oval = self.canvas.create_oval(
            self.bbox_og_border[0],
            self.bbox_og_border[1],
            self.bbox_og_border[0] + self.width_oval,
            self.bbox_og_border[1] + self.height_oval,
            fill="#12FF34",
            outline="#12FF34"
        )

        self.tag_background_2 = self.canvas.create_rectangle(
            (self.width - self.width_text) / 2,
            (self.height - self.height_text) / 2,
            ((self.width - self.width_text) / 2) + self.width_text,
            ((self.height - self.height_text) / 2) + self.width_text,
            fill=self.default_canvas_background.hex_code,
            outline=self.default_canvas_background.hex_code
        )

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

        self.canvas.grid(row=0, column=0)
        self.rowconfigure(0, weight=90)
        self.rowconfigure(1, weight=10)
        self.columnconfigure(0, weight=100)

        self.canvas.tag_raise(self.tag_oval)
        self.canvas.bind("<Button-1>", self.click)

    def click(self, event):
        x, y = event.x, event.y
        print(f"CLICK {x=}, {y=}")

    def run_once(self):
        t_anim_time = self.start(times=1, skip_reset=True)
        self.after_ids_run.append(self.after(t_anim_time + 1000, self.end))

    def start(self, times: bool | int = True, carry_anim_time: int = 0, skip_reset: bool = False) -> int:
        print(f"start {times=}, {carry_anim_time=}, {skip_reset=}")

        if skip_reset:
            t_reset = 0
        else:
            t_reset = self.reset(keep_re_runs=True)
            print(f"ADDING {t_reset=}")

        cycle_num = self.n_cycles.get() + 1
        self.after_ids[cycle_num] = []
        s_off = t_reset + carry_anim_time
        print(f"USING {s_off=}")

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
                    for l in range(self.n_slices + 1):
                        # print(f"{i=}, {j=}, {k=}, {l=}, {txt=}, {let=}, {s_off=}, {(l*sps)+s_off=}")
                        self.after_ids[cycle_num].append(
                            self.after(
                                (l * self.sec_per_slice) + s_off,
                                lambda
                                    i_=i, j_=j, k_=k, t_k="tag_0", l_=l, a_n="outline":
                                self.letter_config(i_, j_, k_, t_k, l_, a_n)
                            )
                        )
                        self.after_ids[cycle_num].append(
                            self.after(
                                (l * self.sec_per_slice) + s_off,
                                lambda
                                    i_=i, j_=j, k_=k, t_k="tag_1", l_=l, a_n="fill":
                                self.letter_config(i_, j_, k_, t_k, l_, a_n)
                            )
                        )

                        # self.after(
                        #     (l * sps) + s_off,
                        #     lambda
                        #         t_tag=self.tags[i][j][k]["tag_0"],
                        #         fill_g=gradient(l, self.n_slices, outline_start, outline_end, rgb=False):
                        #     self.letter_config(t_tag, fill_g)
                        # )

                        # self.after(
                        #     (l * sps) + s_off,
                        #     lambda t_tag=self.tags[i][j][k]["tag_0"], fill_g=gradient(l, n_slices, outline_start, outline_end, rgb=False):
                        #         self.canvas.itemconfigure(
                        #             t_tag,
                        #             fill=fill_g
                        #         )
                        # )

                        # self.after(
                        #     (l * sps) + s_off,
                        #     lambda i_=i, j_=j, k_=k, l_=l, o_s=outline_start, o_e=outline_end:
                        #         self.canvas.itemconfigure(
                        #             self.tags[i_][j_][k_]["tag_0"],
                        #             fill=gradient(l_, n_slices, o_s, o_e, rgb=False)
                        #         )
                        # )

                        # self.after(
                        #     (l * sps) + s_off,
                        #     lambda i_=i, j_=j, k_=k, l_=l, o_s=outline_start, o_e=outline_end, txt_=txt, let_=let:
                        #         print(f"tag_0, {i_=}, {j_=}, {k_=}, {l_=}, {txt_=}, {let_=}, {gradient(l_, n_slices, o_s, o_e, rgb=False)}")
                        # )

                        # self.after(
                        #     (l * sps) + s_off,
                        #     lambda i_=i, j_=j, k_=k, l_=l, f_s=fill_start, f_e=fill_end:
                        #         self.canvas.itemconfigure(
                        #             self.tags[i_][j_][k_]["tag_1"],
                        #             fill=gradient(l_, n_slices, f_s, f_e, rgb=False)
                        #         )
                        # )

                        # self.after(
                        #     (l * sps) + s_off,
                        #     lambda i_=i, j_=j, k_=k, l_=l, f_s=fill_start, f_e=fill_end, txt_=txt, let_=let:
                        #         print(f"tag_0, {i_=}, {j_=}, {k_=}, {l_=}, {txt_=}, {let_=}, {gradient(l_, n_slices, f_s, f_e, rgb=False)}")
                        # )

                        # self.after(
                        #     (l * sps) + s_off,
                        #     lambda t_tag=self.tags[i][j][k]["tag_1"], fill_g=gradient(l, n_slices, fill_start, fill_end, rgb=False):
                        #         self.canvas.itemconfigure(
                        #             t_tag,
                        #             fill=fill_g
                        #         )
                        # )

                        # self.after(
                        #     (l * sps) + s_off,
                        #     lambda
                        #         t_tag=self.tags[i][j][k]["tag_1"],
                        #         fill_g=gradient(l, self.n_slices, fill_start, fill_end, rgb=False):
                        #     self.letter_config(t_tag, fill_g)
                        # )

                    for l in range(self.n_slices + 1):
                        # print(f"{i=}, {j=}, {k=}, {l=}, {txt=}, {let=}, {s_off=}, {(l*sps)+s_off=}")

                        self.after_ids[cycle_num].append(
                            self.after(
                                (l * self.sec_per_slice) + s_off + ((self.n_slices + 1) * self.sec_per_slice),
                                lambda
                                    i_=i, j_=j, k_=k, t_k="tag_0", l_=l, a_n="outline":
                                self.letter_config(i_, j_, k_, t_k, l_, a_n, reverse=True)
                            )
                        )
                        self.after_ids[cycle_num].append(
                            self.after(
                                (l * self.sec_per_slice) + s_off + ((self.n_slices + 1) * self.sec_per_slice),
                                lambda
                                    i_=i, j_=j, k_=k, t_k="tag_1", l_=l, a_n="fill":
                                self.letter_config(i_, j_, k_, t_k, l_, a_n, reverse=True)
                            )
                        )

                    # tspl = (n_slices + 1) * sps
                    s_off += (self.n_slices + 1) * self.sec_per_slice
                    # s_off *= 0.75
                    s_off -= 90 * len(txt)
                    # s_off = int(s_off)
                s_off -= 200 * len(row)
                s_off = max(s_off, 0)
        new_t_anim = ((self.n_slices + 2) * self.sec_per_slice) + s_off
        t_anim = carry_anim_time + new_t_anim

        wt = math.ceil(self.bbox_og_border[2] - self.bbox_og_border[0])
        # tps = int(math.ceil(new_t_anim / ((self.n_slices + 1) * 2)))
        # xps = self.width_text / ((self.n_slices + 1) * 2)
        # tps = int(math.ceil(new_t_anim / ((self.n_slices + 1) * 1)))
        # tps = math.ceil(new_t_anim) / ((self.n_slices + 1) * 1)
        tps = math.ceil(new_t_anim) / (wt + (wt // 2))
        xps = wt / ((self.n_slices + 1) * 1)
        for i in range(wt + (wt // 2)):
            pts = self.moving_point(i, reverse=False)
            # pts = self.moving_point(i * xps, reverse=False)
            # pts = self.moving_point(i * self.width_text, reverse=False)
            x0 = self.bbox_og_border[0] + pts[0] - 5
            y0 = self.bbox_og_border[1] + pts[1] - 5
            x1 = self.bbox_og_border[0] + pts[0] + 5
            y1 = self.bbox_og_border[1] + pts[1] + 5
            print(f"{i=}, {x0=}, {y0=}, {x1=}, {y1=}")
            self.after_ids[cycle_num].append(
                self.after(
                    int(tps * i) + t_reset,
                    lambda x0_=x0, y0_=y0, x1_=x1, y1_=y1:
                    self.canvas.coords(
                        self.tag_oval,
                        x0_, y0_, x1_, y1_
                    )
                )
            )
            # x0 = pts[0] - (wt / 2)
            # y0 = pts[1] - (wt / 2)
            # x1 = pts[0] + (wt / 2)
            # y1 = pts[1] + (wt / 2)
            # x0, y0, x1, y1 = self.twist_rect(x0, y0, x1, y1)
            x0 = pts[0] - ((self.bbox_og_moving_rect[2] - self.bbox_og_moving_rect[0]) / 2)
            y0 = pts[1] - ((self.bbox_og_moving_rect[2] - self.bbox_og_moving_rect[0]) / 2)
            x1 = pts[0] + ((self.bbox_og_moving_rect[2] - self.bbox_og_moving_rect[0]) / 2)
            y1 = pts[1] + ((self.bbox_og_moving_rect[2] - self.bbox_og_moving_rect[0]) / 2)
            self.after_ids[cycle_num].append(
                self.after(
                    int(tps * i) + t_reset,
                    lambda x0_=x0, y0_=y0, x1_=x1, y1_=y1:
                    self.canvas.coords(
                        self.tag_moving_rect,
                        x0_, y0_, x1_, y1_
                    )
                )
            )
        # for i in range(self.n_slices * 2):
        #     pts = self.moving_point(i * (self.width_text / (self.n_slices * 2)), reverse=False)
        #     # pts = self.moving_point(i * self.width_text, reverse=False)
        #     x0 = self.bbox_og_border[0] + pts[0] - 5
        #     y0 = self.bbox_og_border[1] + pts[1] - 5
        #     x1 = self.bbox_og_border[0] + pts[0] + 5
        #     y1 = self.bbox_og_border[1] + pts[1] + 5
        #     self.after_ids.append(
        #         self.after(
        #             tps * i,
        #             lambda x0_=x0, y0_=y0, x1_=x1, y1_=y1:
        #                 self.canvas.coords(
        #                     self.tag_oval,
        #                     x0_, y0_, x1_, y1_
        #                 )
        #         )
        #     )

        print(
            f"{t_anim=}, {new_t_anim=}, {times=}, {tps=}, {xps=}, {s_off=}, wt={self.width_text}, ns={self.n_slices}, bbox={self.bbox_og_border}")
        if isinstance(times, int) and not isinstance(times, bool):
            if times <= 0:
                print(f"HERE A")
                return t_anim
            else:
                print(f"HERE B")
                times = times - 1
        if not times:
            print(f"HERE C")
            return t_anim

        t_anim += self.time_between_re_runs
        new_t_anim += self.time_between_re_runs
        print(f"{self.n_slices=},  {tps=}")
        print(f"rerun in {t_anim=}, {new_t_anim=}, {times=}, {self.bbox_og_border=}")
        self.after_ids_run.append(
            self.after(
                new_t_anim,
                lambda
                    r=times,
                    ta=t_anim:
                self.start(times=r, carry_anim_time=ta)
            )
        )
        self.n_cycles.set(cycle_num)
        return t_anim

    def twist_rect(self, x0, y0, x1, y1):
        t_val = 18
        return (
            x0,
            y0 - t_val,
            x1 + t_val,
            y1 - t_val
        )

    def moving_point(self, l: float, reverse: bool = False) -> tuple[float, float]:
        # n_s = 2 * (self.n_slices + 1)
        # p = (l + ((self.n_slices + 1) if reverse else 0)) / n_s
        # x0 = 0
        # x1 = self.width_text - (2 * self.width_background_border)

        fn = lambda x: -0.1 * (x ** 3)
        fn = lambda x: (((0.0292 * x) - 5.85) ** 3) + 200
        fn = lambda x: (((0.022 * x) - 5.85) ** 3) + 200
        fn = lambda x: (((0.027 * x) - 5.85) ** 3) + 200
        fn = lambda x: (((0.027 * x) - 6.3) ** 3) + 250
        # # fn = lambda x: (((0.019*x) - 7.1)**3) + 270
        fn = lambda x: (((0.028 * x) - 6.8) ** 3) + 250
        xp = l
        fx = fn(xp)

        print(f"x={xp:.2f}, y={fx:.2f}")
        return xp, fx

    # def letter_config(self, t_tag, fill_g):
    def letter_config(self, i: int, j: int, k: int, tag_key: str, l: int,
                      attr_name: Literal["fill", "outline"] = "fill", reverse: bool = False):
        # print(f"tag_0, {i_=}, {j_=}, {k_=}, {l_=}, {txt_=}, {let_=}, {gradient(l_, n_slices, f_s, f_e, rgb=False)}")

        txt = self.texts_to_do[i][j]
        kwargs = self.kwargs_texts.get(txt, {})

        fill_start = kwargs.get("fill_start", self.default_text_fill_start)
        fill_end = kwargs.get("fill_end", self.default_text_fill_end)
        outline_start = kwargs.get("outline_start", self.default_text_outline_start)
        outline_end = kwargs.get("outline_end", self.default_text_outline_end)

        if attr_name == "outline":
            c_s = outline_start
            c_e = outline_end
        else:
            c_s = fill_start
            c_e = fill_end

        if reverse:
            c_s, c_e = c_e, c_s

        if c_s == c_e:
            return

        t_tag = self.tags[i][j][k][tag_key]
        fill_g = gradient(l, self.n_slices, c_s, c_e, rgb=False)
        let = self.canvas.itemcget(t_tag, "text")
        # print(f"{t_tag=}, {let=}, {fill_g=}, {i=}, {j=}, {k=}, {l=}, ns={self.n_slices}, tk={tag_key}, an={attr_name}, cs={c_s.hex_code}, ce={c_e.hex_code}")
        self.canvas.itemconfigure(
            t_tag,
            fill=fill_g
        )

        # if (i == 0) and (j == 0) and (k == 0):
        #     print(f"{l=}, {reverse=}")
        #     pts = self.moving_point(l, reverse=reverse)
        #     self.canvas.coords(
        #         self.tag_oval,
        #         pts[0] - 5,
        #         pts[1] - 5,
        #         pts[0] + 5,
        #         pts[1] + 5
        #     )

    def clear_after_ids(self, cycle: Optional[int] = None, keep_re_runs: bool = False):
        if cycle is None:
            cycles = list(range(self.n_cycles.get()))
        else:
            cycles = [cycle]
        for cyc_n in self.after_ids:
            if cyc_n in cycles:
                for id_ in self.after_ids.get(cyc_n, []):
                    self.after_cancel(id_)
                self.after_ids[cyc_n].clear()
        # if not keep_re_runs:
        #     for id_ in self.after_ids_run:
        #         self.after_cancel(id_)
        #     self.after_ids_run.clear()

    def change_letter(self, i: int, j: int, k: int, tag_key: str, l: int, fos: int, col: str | Colour, ec: str | Colour):
        tag = self.tags[i][j][k][tag_key]
        let = self.canvas.itemcget(tag, "text")
        fill = gradient(l, fos, col, ec, rgb=False)
        # print(f"{i=}, {j=}, {k=}, {tag=}, {let=}, {l=}, {fos=}, col={col.hex_code}, ec={ec.hex_code}, {fill=}")
        self.canvas.itemconfigure(
            tag,
            fill=fill
        )

    def fade_out(self) -> int:
        ec = self.default_canvas_background
        tpl = 10
        fos = 250
        t = 0
        for i, row in enumerate(self.texts_to_do):
            for j, txt in enumerate(row):
                for k, let in enumerate(txt):
                    t = (i * 185) + (k * 40)
                    # txt = self.texts_to_do[i][j]
                    # kwargs = self.kwargs_texts.get(txt, {})
                    # fill_start = kwargs.get("fill_start", self.default_text_fill_start)
                    tag_1 = self.tags[i][j][k]["tag_1"]
                    tag_0 = self.tags[i][j][k]["tag_0"]
                    col_f = Colour(self.canvas.itemcget(tag_1, "fill"))
                    col_ou = Colour(self.canvas.itemcget(tag_0, "fill"))
                    for l in range(fos):
                        t += 40
                        self.after_ids_reset.append(
                            self.after(
                                t,
                                lambda
                                    i_=i, j_=j, k_=k, l_=l,
                                    key="tag_1",
                                    fos_=fos,
                                    col_=col_f,
                                    ec_=ec:
                                self.change_letter(
                                    i=i_, j=j_, k=k_, l=l_,
                                    tag_key=key,
                                    fos=fos_,
                                    col=col_,
                                    ec=ec_
                                )
                            )
                        )
                        self.after_ids_reset.append(
                            self.after(
                                t,
                                lambda
                                    i_=i, j_=j, k_=k, l_=l,
                                    key="tag_0",
                                    fos_=fos,
                                    col_=col_ou,
                                    ec_=ec:
                                self.change_letter(
                                    i=i_, j=j_, k=k_, l=l_,
                                    tag_key=key,
                                    fos=fos_,
                                    col=col_,
                                    ec=ec_
                                )
                            )
                        )
                            #print(f"{tag_=}, {fill_=}")

                            # lambda l_=l, col_=col, tag_=tag:
                            #     self.canvas.itemconfigure(
                            #         tag_,
                            #         fill=gradient(l_, fos, col_, ec, rgb=False)
                            #     )
                        # print(f">>{t=}")
                        t += tpl

        new_t_anim = ((self.n_slices + 2) * self.sec_per_slice) + t

        wmr = (self.bbox_og_moving_rect[2] - self.bbox_og_moving_rect[0])
        wt = math.ceil(self.bbox_og_border[2] - self.bbox_og_border[0])
        # tps = int(math.ceil(new_t_anim / ((self.n_slices + 1) * 2)))
        # xps = self.width_text / ((self.n_slices + 1) * 2)
        # tps = int(math.ceil(new_t_anim / ((self.n_slices + 1) * 1)))
        # tps = math.ceil(new_t_anim) / ((self.n_slices + 1) * 1)
        xps = wt / ((self.n_slices + 1) * 1)
        swt = wt + (wt // 2)
        tps = math.ceil(new_t_anim) / swt
        for i in range(swt - 1, -1, -1):
            pts = self.moving_point(i, reverse=False)
            # pts = self.moving_point(i * xps, reverse=False)
            # pts = self.moving_point(i * self.width_text, reverse=False)
            x0 = self.bbox_og_border[2] + pts[0] - 5
            y0 = self.bbox_og_border[3] + pts[1] - 5
            x1 = self.bbox_og_border[2] + pts[0] + 5
            y1 = self.bbox_og_border[3] + pts[1] + 5
            print(f"FO {i=}, {x0=}, {y0=}, {x1=}, {y1=}")
            self.after_ids_reset.append(
                self.after(
                    int(tps * (swt - i)),
                    lambda x0_=x0, y0_=y0, x1_=x1, y1_=y1:
                    self.canvas.coords(
                        self.tag_oval,
                        x0_, y0_, x1_, y1_
                    )
                )
            )
            # x0 = pts[0] - (wt / 2)
            # y0 = pts[1] - (wt / 2)
            # x1 = pts[0] + (wt / 2)
            # y1 = pts[1] + (wt / 2)
            # x0, y0, x1, y1 = self.twist_rect(x0, y0, x1, y1)
            x0 = (wmr / 2) + pts[0] - (wmr / 2)
            y0 = (wmr / 2) + pts[1] - (wmr / 2)
            x1 = (wmr / 2) + pts[0] + (wmr / 2)
            y1 = (wmr / 2) + pts[1] + (wmr / 2)
            self.after_ids_reset.append(
                self.after(
                    int(tps * (swt - i)),
                    lambda x0_=x0, y0_=y0, x1_=x1, y1_=y1:
                    self.canvas.coords(
                        self.tag_moving_rect,
                        x0_, y0_, x1_, y1_
                    )
                )
            )
        t = new_t_anim + tpl
        print(f"FADE-OUT {t=}")
        return t

    def reset(self, keep_re_runs: bool = False) -> int:
        t_anim = self.fade_out()
        t_reset = 0
        self.clear_after_ids(keep_re_runs=keep_re_runs)
        # for i, row in enumerate(self.texts_to_do):
        #     for j, txt in enumerate(row):
        #         for k, let in enumerate(txt):
        #             txt = self.texts_to_do[i][j]
        #             kwargs = self.kwargs_texts.get(txt, {})
        #             fill_start = kwargs.get("fill_start", self.default_text_fill_start)
        #             t_reset = t_anim + i + j + (20 * k)
        #             self.after(
        #                 t_reset,
        #                 lambda
        #                     i_=i,
        #                     j_=j,
        #                     k_=k,
        #                     fill_=fill_start:
        #                 self.canvas.itemconfigure(
        #                     self.tags[i_][j_][k_]["tag_1"],
        #                     fill=fill_.hex_code
        #                 )
        #             )

        t_anim += t_reset
        print(f"RESET {t_anim=}")
        return t_anim

    def end(self):
        print(f"end")
        self.clear_after_ids()


if __name__ == '__main__':

    def kill():
        print(f"Time to die")
        if tl.winfo_exists():
            tl.destroy()
        app.destroy()


    app = ctk.CTk()
    app.after(120000, kill)

    tl = Splash()
    tl.start(skip_reset=True)
    tl.grab_set()
    tl.protocol("WM_DELETE_WINDOW", kill)

    app.mainloop()
