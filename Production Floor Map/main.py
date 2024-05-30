import tkinter

from tkinter_utility import *
from PIL import ImageTk, Image
import json


def collide_point(bbox, point):
    return all([
        bbox[0] <= point[0] <= bbox[2],
        bbox[1] <= point[1] <= bbox[3]
    ])


class WorkStation:

    def __init__(self, data: dict):
        self.name = data.get("name", "UNNAMED WORK STATION")
        self.is_cad_station = data.get("is_cad_station", False)
        self.number = data.get("number", None)
        self.row = data.get("row", None)
        self.col = data.get("col", None)

        self.background = data.get("colour_background", Colour("#303078"))


class App(tkinter.Tk):

    def __init__(self):
        super().__init__()

        ########################
        #  Application title   #
        ########################
        self.tv_title_app_full = tkinter.StringVar(self, value="Demo Tkinter App")
        self.tv_title_app_short = tkinter.StringVar(self, value="Demo App")
        self.title(self.tv_title_app_full.get())

        ##############################
        #   Application dimensions   #
        ##############################
        self.calc_geometry = calc_geometry_tl("zoomed", largest=True, rtype=dict)  # full-screen application
        self.w_p_app, self.h_p_app = 2 / 3, 4 / 9
        # self.calc_geometry = calc_geometry_tl(self.w_p_app, self.h_p_app, largest=True, rtype=dict)  # dimensions above
        self.w_app, self.h_app = self.calc_geometry["width"], self.calc_geometry["height"]
        self.w_canvas_map, self.h_canvas_map = self.w_app * 0.75, self.h_app * 0.75

        print(f"{self.calc_geometry=}")
        if (geo := self.calc_geometry["geometry"]) == "zoomed":
            self.state(geo)
        else:
            self.geometry(geo)

        self.time_wait_hover_canvas_map = 1200
        self.rv_showing_pop_up_frames = 10  # Number of total frames to expand the pop-up window
        self.fps_pop_up = 1 / 32  # Frames per second the pop-up button is rendered. Represents a percentage of a one second.
        self.width_pop_up = 180
        self.height_pop_up = 250
        self.pad_pop_up = 20
        self.colour_pop_up = Colour("#A0A8FF")

        self.json_layout_file = "hawkins_layout_2024_05_29.json"
        with open(self.json_layout_file, "r") as f:
            json_data = json.load(f)
            # self.map_file = "\\\\bwsfp01\\public\\IT\\Resource\\Images\\production_floor_map_2024_05_29_marked.jpg"
            self.map_file = json_data["work_stations"]["settings"]["map_file"]
            self.width_cell = json_data["work_stations"]["settings"]["width_cell"]
            self.height_cell = json_data["work_stations"]["settings"]["height_cell"]
            self.list_stations = [WorkStation(data) for data in json_data["work_stations"]["stations"]]

        self.list_idxs_stations = [(s.row, s.col) for s in self.list_stations]

        #############################
        #   Begin widget creation   #
        #############################
        self.frame_button_bar = tkinter.Frame(self)
        self.frame_ctl_checks = tkinter.Frame(self.frame_button_bar)

        # self.list_tv_ctl_checks, self.list_ctl_checks = checkbox_factory(
        # 	self.frame_ctl_checks,
        # 	buttons=[
        # 		("Show Grid-Lines", self.update_show_grid_lines),
        # 		("Show Station Markers", self.update_show_station_markers)
        # 	]
        # )

        self.text_checkbox_show_grid_lines = "Show Grid-Lines"
        self.text_checkbox_show_station_markers = "Show Station Markers"
        self.controls_checkboxes = checkbox_factory(
            self.frame_ctl_checks,
            buttons=[
                (self.text_checkbox_show_grid_lines, self.update_show_grid_lines),
                (self.text_checkbox_show_station_markers, self.update_show_station_markers)
            ],
			default_values=[True, True],
            rtype=dict
        )

        self.canvas_map = tkinter.Canvas(
            self,
            width=self.w_canvas_map,
            height=self.h_canvas_map
        )

        self.colour_err_no_map_found_label = Colour("#CD6951")

        try:
            self.img_prod_floor_hawkins_map = Image.open(self.map_file)
            self.img_prod_floor_hawkins_map = self.img_prod_floor_hawkins_map.resize(
                (
                    int(self.w_canvas_map),
                    int(self.h_canvas_map)
                ),
                Image.LANCZOS
            )
            self.photo_prod_floor_hawkins_map = ImageTk.PhotoImage(self.img_prod_floor_hawkins_map)
            self.canvas_map.create_image(
                0,
                0,
                anchor=tkinter.NW,
                image=self.photo_prod_floor_hawkins_map
            )
        except OSError:
            self.canvas_map.create_text(
                self.w_canvas_map / 2,
                self.h_canvas_map / 2,
                text=f"Could not load map",
                font=("Arial", 42, "bold"),
                fill=self.colour_err_no_map_found_label.hex_code
            )

        self.colour_dot = Colour("#B0FFCF")
        self.width_dot, self.height_dot = 12, 12
        self.tag_dot = self.canvas_map.create_oval(
            (-2 * self.width_dot) - (self.width_dot / 2),
            (-2 * self.height_dot) - (self.height_dot / 2),
            (-2 * self.width_dot) + (self.width_dot / 2),
            (-2 * self.height_dot) + (self.height_dot / 2),
            fill=self.colour_dot.hex_code
        )

        self.width_line_vertical = 2
        self.colour_line_vertical = Colour("#963232")
        self.width_line_horizontal = 2
        self.colour_line_horizontal = Colour("#323296")

        self.lines_vertical = list()
        for i in range(0, int(self.w_canvas_map), self.width_cell):
            self.lines_vertical.append(
                self.canvas_map.create_line(
                    0 + (i * self.width_cell),
                    0,
                    0 + (i * self.width_cell),
                    self.h_canvas_map,
                    fill=self.colour_line_vertical.hex_code,
                    width=self.width_line_vertical
                )
            )

        self.lines_horizontal = list()
        for i in range(0, int(self.h_canvas_map), self.height_cell):
            self.lines_horizontal.append(
                self.canvas_map.create_line(
                    0,
                    0 + (i * self.height_cell),
                    self.w_canvas_map,
                    0 + (i * self.height_cell),
                    fill=self.colour_line_horizontal.hex_code,
                    width=self.width_line_horizontal
                )
            )

        self.bbox_pop_up = (-100, -50, -100, -50)
        self.tag_pop_up = self.canvas_map.create_rectangle(
            *self.bbox_pop_up,
            fill=self.colour_pop_up.hex_code
        )

        self.list_station_rects = list()
        self.init_station_squares()

        self.n_cols, self.n_rows = len(self.lines_vertical) + 1, len(self.lines_vertical) + 1
        self.curr_col = tkinter.IntVar(self, value=-1)
        self.curr_row = tkinter.IntVar(self, value=-1)
        self.tv_showing_pop_up = tkinter.BooleanVar(self, value=False)
        self.tv_x_y_pop_up_launch = tkinter.Variable(self, value=(None, None))
        self.tv_showing_pop_up_frames = tkinter.IntVar(self, value=self.rv_showing_pop_up_frames)
        self.bbox_pop_up = tkinter.Variable(self, value=[None] * 4)
        self.list_ids_after_expand_showing_pop_up = tkinter.Variable(self, value=list())

        # self.columnconfigure(0, weight=1)
        self.grid_widgets()

        self.id_after_hover_canvas_map = None
        self.n_clicks = tkinter.IntVar(self, value=0)
        self.canvas_map.tag_raise(self.tag_pop_up)
        self.canvas_map.tag_raise(self.tag_dot)
        self.tv_showing_pop_up.trace_variable("w", self.update_showing_pop_up)
        self.canvas_map.bind("<Motion>", self.motion_canvas_map)
        self.canvas_map.bind("<Button-1>", self.click_canvas_map)

    def grid_widgets(self):
        r, c, rs, cs, ix, iy, x, y, s = grid_keys()
        # self.lbl_demo.grid(**{r: 0, c: 0, s: "nsew"})
        self.frame_button_bar.grid(**{r: 0, c: 0, s: "nsew"})
        self.frame_ctl_checks.grid(**{r: 0, c: 0, s: "nsew"})
        for i, key in enumerate(self.controls_checkboxes):
            btn = self.controls_checkboxes[key]["btn"]
            btn.grid(**{r: 0, c: i})
        self.canvas_map.grid(**{r: 1, c: 0, s: "nsew"})

    # self.columnconfigure(0, weight=1)

    def get_line_idxs(self, ex, ey):
        return int(ey / (self.height_cell ** 2)), int(ex / (self.width_cell ** 2))

    def get_event_lines(self, event):
        ex, ey = event.x, event.y
        idx_h, idx_v = self.get_line_idxs(ex, ey)

        lines_h = self.lines_horizontal[idx_h:idx_h + 2]
        lines_v = self.lines_vertical[idx_v:idx_v + 2]
        return lines_h, lines_v

    def update_show_grid_lines(self, *args):
        # print(f"update_show_grid_lines v={self.list_tv_ctl_checks[0].get()}")
        key = self.text_checkbox_show_grid_lines
        val = self.controls_checkboxes[key]['var'].get()
        print(f"update_show_grid_lines v={val}")

        state = "normal" if val else "hidden"

        for line in self.lines_horizontal:
            self.canvas_map.itemconfigure(
                line,
                state=state
            )

        for line in self.lines_vertical:
            self.canvas_map.itemconfigure(
                line,
                state=state
            )

    def update_show_station_markers(self, *args):
        key = self.text_checkbox_show_station_markers
        val = self.controls_checkboxes[key]['var'].get()
        print(f"update_show_station_markers v={val}")

        state = "normal" if val else "hidden"

        for station in self.list_station_rects:
            self.canvas_map.itemconfigure(
                station,
                state=state
            )

    def init_station_squares(self):
        for i, station in enumerate(self.list_stations):
            name = station.name
            idx_h = station.row
            idx_v = station.col
            bg = station.background

            line_top = self.lines_horizontal[idx_h]
            line_left = self.lines_vertical[idx_v]
            bbox_top = self.canvas_map.bbox(line_top)
            bbox_left = self.canvas_map.bbox(line_left)
            w_line_top = self.width_line_horizontal
            w_line_left = self.width_line_vertical

            bbox = (
                bbox_left[0] + w_line_left,
                bbox_top[1] + w_line_top,
                bbox_left[0] + (self.width_cell ** 2) + w_line_left,
                bbox_top[1] + (self.height_cell ** 2) + w_line_top
            )

            print(f"{name=}, {idx_h=}, {idx_v=}, {bbox=}")

            self.list_station_rects.append(
                self.canvas_map.create_rectangle(
                    *bbox,
                    fill=bg.hex_code
                )
            )

    def motion_canvas_map(self, event):

        if self.id_after_hover_canvas_map is not None:
            self.after_cancel(self.id_after_hover_canvas_map)

        ex, ey = event.x, event.y
        idx_h, idx_v = self.get_line_idxs(ex, ey)
        self.canvas_map.coords(
            self.tag_dot,
            ex - (self.width_dot / 2),
            ey - (self.height_dot / 2),
            ex + (self.width_dot / 2),
            ey + (self.height_dot / 2)
        )

        if self.tv_showing_pop_up.get():

            bbox = self.bbox_pop_up.get()
            bbox = (
                bbox[0] - self.pad_pop_up,
                bbox[1] - self.pad_pop_up,
                bbox[2] + self.pad_pop_up,
                bbox[3] + self.pad_pop_up
            )

            if not collide_point(bbox, (ex, ey)):
                self.tv_showing_pop_up.set(False)

        else:

            lines_h, lines_v = self.get_event_lines(event)

            for line in self.lines_horizontal:
                self.canvas_map.itemconfigure(
                    line,
                    fill=self.colour_line_horizontal.hex_code
                )

            for line in self.lines_vertical:
                self.canvas_map.itemconfigure(
                    line,
                    fill=self.colour_line_vertical.hex_code
                )

            for line in lines_h:
                self.canvas_map.itemconfigure(
                    line,
                    fill=self.colour_line_horizontal.brightened(0.4).hex_code
                )

            for line in lines_v:
                self.canvas_map.itemconfigure(
                    line,
                    fill=self.colour_line_vertical.brightened(0.4).hex_code
                )

            changed = False
            if self.curr_col.get() != idx_v:
                self.curr_col.set(idx_v)
                changed = True
            if self.curr_row.get() != idx_h:
                self.curr_row.set(idx_h)
                changed = True

            # if changed:
            #	print(f"{ex=}, {ey=}, {idx_h=}, {idx_v=}")
            self.id_after_hover_canvas_map = self.after(self.time_wait_hover_canvas_map, self.show_pop_up)

    def click_canvas_map(self, event):
        self.n_clicks.set(self.n_clicks.get() + 1)
        ex, ey = event.x, event.y
        idx_h, idx_v = self.get_line_idxs(ex, ey)
        # lines_h, lines_v = self.get_event_lines(event)
        print(f"#{str(self.n_clicks.get()).rjust(3)} | row={idx_h}, col={idx_v}")

    def show_pop_up(self):
        omx, omy = self.winfo_pointerx(), self.winfo_pointery()
        left_canvas_map = self.canvas_map.winfo_rootx()
        top_canvas_map = self.canvas_map.winfo_rooty()
        # mx, my = self.canvas_map.canvasx(omx), self.canvas_map.canvasy(omy)
        mx, my = omx - left_canvas_map, omy - top_canvas_map
        idx_h, idx_v = self.get_line_idxs(mx, my)
        row, col = self.curr_row.get(), self.curr_col.get()
        bbox_canvas_map = self.bbox(self.canvas_map)
        w_can, h_can = self.w_canvas_map, self.h_canvas_map
        print(
            f"{omx=}, {omy=}, {mx=}, {my=}, {idx_h=}, {idx_v=}, {row=}, {col=}, {left_canvas_map=}, {top_canvas_map=}, can_x={self.canvas_map.canvasx(mx)}, can_y={self.canvas_map.canvasy(my)}")
        if (idx_h == row) and (idx_v == col):
            print(f"still hovering this spot")
            print(f"{self.list_idxs_stations=}")
            if (row, col) in self.list_idxs_stations:
                print(f"hovering station")
                self.tv_showing_pop_up.set(True)
                self.tv_x_y_pop_up_launch.set((mx, my))

    def update_showing_pop_up(self, *args):
        showing = self.tv_showing_pop_up.get()

        if showing:
            state = "normal"
        else:
            state = "hidden"
            for id_after in self.list_ids_after_expand_showing_pop_up.get():
                self.after_cancel(id_after)

        self.canvas_map.itemconfigure(
            self.tag_pop_up,
            state=state
        )

        if showing:
            self.tv_showing_pop_up_frames.set(self.rv_showing_pop_up_frames)
            list_ids_after_expand_showing_pop_up = list()
            for i in range(self.tv_showing_pop_up_frames.get()):
                ms = int(i * 1000 * self.fps_pop_up)
                print(f"{i=}, {ms=}")
                list_ids_after_expand_showing_pop_up.append(self.after(ms, self.expand_pop_up))
            self.list_ids_after_expand_showing_pop_up.set(list_ids_after_expand_showing_pop_up)

    def expand_pop_up(self):
        n_frames = self.rv_showing_pop_up_frames - self.tv_showing_pop_up_frames.get()
        p_frames = n_frames / self.rv_showing_pop_up_frames

        bbox_canvas_map = self.bbox(self.canvas_map)
        mx, my = self.tv_x_y_pop_up_launch.get()
        w_pu, h_pu = self.width_pop_up, self.height_pop_up
        w_pu *= p_frames
        h_pu *= p_frames

        self.bbox_pop_up.set((
            max(0, min(mx, bbox_canvas_map[2] - w_pu)),
            max(0, min(my, bbox_canvas_map[3] - h_pu)),
            # max(mx + self.width_pop_up, min(mx + w_pu, bbox_canvas_map[2])),
            # max(my + self.height_pop_up, min(my + h_pu, bbox_canvas_map[3])),
            min(mx + w_pu, bbox_canvas_map[2]),
            min(my + h_pu, bbox_canvas_map[3])
        ))
        print(f"{w_pu=}, {h_pu=}, {self.bbox_pop_up.get()=}")
        self.canvas_map.coords(
            self.tag_pop_up,
            *self.bbox_pop_up.get()
        )
        self.tv_showing_pop_up_frames.set(self.tv_showing_pop_up_frames.get() - 1)


if __name__ == '__main__':
    app = App()
    app.mainloop()
