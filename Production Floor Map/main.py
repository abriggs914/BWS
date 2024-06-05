import datetime
import tkinter
from tkinter import font

from pyodbc_connection import connect
from tkinter_utility import *
from PIL import ImageTk, Image
import json


def collide_point(bbox: tuple[float, float, float, float], point: tuple[float, float]) -> bool:
    """Check if a point is inside a rectangular 'bbox' of format (x0, y0, x1, y1)"""
    return all([
        bbox[0] <= point[0] <= bbox[2],
        bbox[1] <= point[1] <= bbox[3]
    ])


def center_bbox(bbox: tuple[float, float, float, float]) -> tuple[float, float]:
    return (
        bbox[0] + ((bbox[2] - bbox[0]) / 2),
        bbox[1] + ((bbox[3] - bbox[1]) / 2)
    )


class WorkStation:

    def __init__(self, data: dict):
        self.name = data.get("name", "UNNAMED WORK STATION")
        self.is_cad_station = data.get("is_cad_station", False)
        self.number = data.get("number", None)
        self.row = data.get("row", None)
        self.col = data.get("col", None)
        self.uni_point_name = f"STATION{self.number if self.number is not None else '__'}"
        if self.is_cad_station:
            self.uni_point_name = f"CAD{self.uni_point_name}"

        self.background = data.get("colour_background", Colour("#303078"))


class PopUpContentManager:

    def __init__(
            self,
            canvas: tkinter.Canvas,
            pop_up_tag: int,
            bbox_pop_up: tkinter.Variable,
            x_y_pop_up_launch: tkinter.Variable,
            w_pop_up: tkinter.IntVar,
            h_pop_up: tkinter.IntVar,
            rv_w_pop_up: int = 300,
            rv_h_pop_up: int = 250,
            **kwargs
    ):
        self.canvas = canvas
        self.pop_up_tag = pop_up_tag
        self.bbox_pop_up = bbox_pop_up
        self.x_y_pop_up_launch = x_y_pop_up_launch
        self.w_pop_up = w_pop_up
        self.h_pop_up = h_pop_up
        self.rv_w_pop_up = rv_w_pop_up
        self.rv_h_pop_up = rv_h_pop_up

        # default_values
        self.default_colour_lbl = Colour("#000000")
        self.default_colour_txt = Colour("#111945")
        self.default_font_name = "Arial"
        self.default_font_size = 14
        self.default_lbl_station_name = "Station:"
        self.default_lbl_station_number = "Number:"
        self.default_lbl_station_manufacturer = "Manufacturer:"
        self.default_lbl_station_model_name = "Model Name:"
        self.default_lbl_station_acquisition_date = "Acquisition Date:"
        self.default_lbl_station_manager = "Manager:"
        self.default_lbl_station_division = "Division:"
        self.default_lbl_station_assigned_to = "Assigned To:"
        self.default_lbl_station_assigned_dept = "Assigned Dept:"
        self.default_lbl_station_class = "Class:"
        self.default_lbl_station_category = "Category:"
        self.default_lbl_station_current_location = "Current Location:"

        self.m_top, self.m_left, self.m_right, self.m_bottom = [10] * 4

        self.colour_lbl_txt_station_name = self.default_colour_lbl
        self.font_lbl_txt_station_name = (self.default_font_name, self.default_font_size)

        self.colour_txt_station_name = Colour(kwargs.get("colour_txt_station_name", self.default_colour_txt))
        self.font_txt_station_name = (self.default_font_name, self.default_font_size)

        self.colour_lbl_txt_station_number = Colour(kwargs.get("colour_lbl_txt_station_number", self.default_colour_lbl))
        self.font_lbl_txt_station_number = (self.default_font_name, self.default_font_size)

        self.colour_txt_station_number = Colour(kwargs.get("colour_txt_station_number", self.default_colour_txt))
        self.font_txt_station_number = (self.default_font_name, self.default_font_size)

        self.colour_lbl_txt_station_manufacturer = Colour(kwargs.get("colour_lbl_txt_station_manufacturer", self.default_colour_lbl))
        self.font_lbl_txt_station_manufacturer = (self.default_font_name, self.default_font_size)

        self.colour_txt_station_manufacturer = Colour(kwargs.get("colour_txt_station_manufacturer", self.default_colour_txt))
        self.font_txt_station_manufacturer = (self.default_font_name, self.default_font_size)

        self.colour_lbl_txt_station_model_name = Colour(kwargs.get("colour_lbl_txt_station_model_name", self.default_colour_lbl))
        self.font_lbl_txt_station_model_name = (self.default_font_name, self.default_font_size)

        self.colour_txt_station_model_name = Colour(kwargs.get("colour_txt_station_model_name", self.default_colour_txt))
        self.font_txt_station_model_name = (self.default_font_name, self.default_font_size)

        self.colour_lbl_txt_station_acquisition_date = Colour(kwargs.get("colour_lbl_txt_station_acquisition_date", self.default_colour_lbl))
        self.font_lbl_txt_station_acquisition_date = (self.default_font_name, self.default_font_size)

        self.colour_txt_station_acquisition_date = Colour(kwargs.get("colour_txt_station_acquisition_date", self.default_colour_txt))
        self.font_txt_station_acquisition_date = (self.default_font_name, self.default_font_size)

        self.colour_lbl_txt_station_manager = Colour(kwargs.get("colour_lbl_txt_station_manager", self.default_colour_lbl))
        self.font_lbl_txt_station_manager = (self.default_font_name, self.default_font_size)

        self.colour_txt_station_manager = Colour(kwargs.get("colour_txt_station_manager", self.default_colour_txt))
        self.font_txt_station_manager = (self.default_font_name, self.default_font_size)

        self.colour_lbl_txt_station_division = Colour(kwargs.get("colour_lbl_txt_station_division", self.default_colour_lbl))
        self.font_lbl_txt_station_division = (self.default_font_name, self.default_font_size)

        self.colour_txt_station_division = Colour(kwargs.get("colour_txt_station_division", self.default_colour_txt))
        self.font_txt_station_division = (self.default_font_name, self.default_font_size)

        self.colour_lbl_txt_station_assigned_to = Colour(kwargs.get("colour_lbl_txt_station_assigned_to", self.default_colour_lbl))
        self.font_lbl_txt_station_assigned_to = (self.default_font_name, self.default_font_size)

        self.colour_txt_station_assigned_to = Colour(kwargs.get("colour_txt_station_assigned_to", self.default_colour_txt))
        self.font_txt_station_assigned_to = (self.default_font_name, self.default_font_size)

        self.colour_lbl_txt_station_assigned_dept = Colour(kwargs.get("colour_lbl_txt_station_assigned_dept", self.default_colour_lbl))
        self.font_lbl_txt_station_assigned_dept = (self.default_font_name, self.default_font_size)

        self.colour_txt_station_assigned_dept = Colour(kwargs.get("colour_txt_station_assigned_dept", self.default_colour_txt))
        self.font_txt_station_assigned_dept = (self.default_font_name, self.default_font_size)

        self.colour_lbl_txt_station_class = Colour(kwargs.get("colour_lbl_txt_station_class", self.default_colour_lbl))
        self.font_lbl_txt_station_class = (self.default_font_name, self.default_font_size)

        self.colour_txt_station_class = Colour(kwargs.get("colour_txt_station_class", self.default_colour_txt))
        self.font_txt_station_class = (self.default_font_name, self.default_font_size)

        self.colour_lbl_txt_station_category = Colour(kwargs.get("colour_lbl_txt_station_category", self.default_colour_lbl))
        self.font_lbl_txt_station_category = (self.default_font_name, self.default_font_size)

        self.colour_txt_station_category = Colour(kwargs.get("colour_txt_station_category", self.default_colour_txt))
        self.font_txt_station_category = (self.default_font_name, self.default_font_size)

        self.colour_lbl_txt_station_current_location = Colour(kwargs.get("colour_lbl_txt_station_current_location", self.default_colour_lbl))
        self.font_lbl_txt_station_current_location = (self.default_font_name, self.default_font_size)

        self.colour_txt_station_current_location = Colour(kwargs.get("colour_txt_station_current_location", self.default_colour_txt))
        self.font_txt_station_current_location = (self.default_font_name, self.default_font_size)

        # to be populated
        self.tag_lbl_txt_station_name = None
        self.tag_txt_station_name = None
        self.tag_lbl_txt_station_number = None
        self.tag_txt_station_number = None
        self.bbox_lbl_txt_station_name = None
        self.bbox_txt_station_name = None
        self.bbox_lbl_txt_station_number = None
        self.bbox_txt_station_number = None
        self.bbox_lbl_txt_station_manufacturer = None
        self.bbox_txt_station_manufacturer = None
        self.bbox_lbl_txt_station_model_name = None
        self.bbox_txt_station_model_name = None
        self.bbox_lbl_txt_station_acquisition_date = None
        self.bbox_txt_station_acquisition_date = None

        self.bbox_lbl_txt_station_manager = None
        self.bbox_txt_station_manager = None
        self.bbox_lbl_txt_station_division = None
        self.bbox_txt_station_division = None
        self.bbox_lbl_txt_station_assigned_to = None
        self.bbox_txt_station_assigned_to = None
        self.bbox_lbl_txt_station_assigned_dept = None
        self.bbox_txt_station_assigned_dept = None
        self.bbox_lbl_txt_station_class = None
        self.bbox_txt_station_class = None
        self.bbox_lbl_txt_station_category = None
        self.bbox_txt_station_category = None
        self.bbox_lbl_txt_station_current_location = None
        self.bbox_txt_station_current_location = None
        self.list_tags_txt_content = list()
        self.list_tags_content = list()

        # begin population
        self.init_pop_up_contents()
        self.show_contents()
        self.hide_contents()

    def init_pop_up_contents(self) -> None:
        self.tag_lbl_txt_station_name = self.canvas.create_text(
            -2, -2,
            text=self.default_lbl_station_name,
            fill=self.colour_lbl_txt_station_name.hex_code,
            font=self.font_lbl_txt_station_name
        )
        self.tag_txt_station_name = self.canvas.create_text(
            -1, -1,
            text="",
            fill=self.colour_txt_station_name.hex_code,
            font=self.font_txt_station_name
        )
        self.tag_lbl_txt_station_number = self.canvas.create_text(
            -2, -2,
            text=self.default_lbl_station_number,
            fill=self.colour_lbl_txt_station_number.hex_code,
            font=self.font_lbl_txt_station_number
        )
        self.tag_txt_station_number = self.canvas.create_text(
            -1, -1,
            text="",
            fill=self.colour_txt_station_number.hex_code,
            font=self.font_txt_station_number
        )

        self.list_tags_txt_content = [
            self.tag_lbl_txt_station_name,
            self.tag_txt_station_name,
            self.tag_lbl_txt_station_number,
            self.tag_txt_station_number
        ]

    def show_contents(self) -> None:
        self.configure_contents({"state": "normal"})

        # update coordinates
        # bbox_pop_up = self.canvas.bbox(self.pop_up_tag)
        print(f"show_contents {self.bbox_pop_up.get()=}")
        bbox_pop_up = self.bbox_pop_up.get()
        w, h = bbox_pop_up[2] - bbox_pop_up[0], bbox_pop_up[3] - bbox_pop_up[1]
        mx, my = bbox_pop_up[0] + (w / 2), bbox_pop_up[1] + (h / 2)
        w_txt_station_name = (w - 20) / 2
        h_txt_station_name = 20
        m_top, m_left, m_right, m_bottom = self.m_top, self.m_left, self.m_right, self.m_bottom
        m_h_text = 5

        # create offset text bboxes based on the current position of the pop-up
        self.bbox_lbl_txt_station_name = (
            bbox_pop_up[0] + m_left,
            bbox_pop_up[1] + m_top,
            bbox_pop_up[0] + m_left + w_txt_station_name,
            bbox_pop_up[1] + m_top + (1 * h_txt_station_name) + (0 * m_h_text)
        )
        self.bbox_txt_station_name = (
            bbox_pop_up[2] - m_right - w_txt_station_name,
            bbox_pop_up[1] + m_top,
            bbox_pop_up[2] - m_right,
            bbox_pop_up[1] + m_top + (1 * h_txt_station_name) + (0 * m_h_text)
        )
        self.bbox_lbl_txt_station_number = (
            bbox_pop_up[0] + m_left,
            bbox_pop_up[1] + m_top + (1 * h_txt_station_name) + (1 * m_h_text),
            bbox_pop_up[0] + m_left + w_txt_station_name,
            bbox_pop_up[1] + m_top + (2 * h_txt_station_name) + (1 * m_h_text)
        )
        self.bbox_txt_station_number = (
            bbox_pop_up[2] - m_right - w_txt_station_name,
            bbox_pop_up[1] + m_top + (1 * h_txt_station_name) + (1 * m_h_text),
            bbox_pop_up[2] - m_top,
            bbox_pop_up[1] + m_top + (2 * h_txt_station_name) + (1 * m_h_text),
        )

        # center text tags since coords only takes x and y for texts
        for tag, bbox in zip(
            (
                self.tag_lbl_txt_station_name,
                self.tag_txt_station_name,
                self.tag_lbl_txt_station_number,
                self.tag_txt_station_number
            ),
            (
                self.bbox_lbl_txt_station_name,
                self.bbox_txt_station_name,
                self.bbox_lbl_txt_station_number,
                self.bbox_txt_station_number
            )
        ):
            self.canvas.coords(
                tag,
                *center_bbox(bbox)
            )

    def hide_contents(self) -> None:
        self.configure_contents({"state": "hidden"})

    def configure_contents(self, kwargs: dict, apply_to_contents: bool = True, apply_to_texts: bool = True) -> None:
        if apply_to_contents:
            for tag in self.list_tags_content:
                if tag is not None:
                    self.canvas.itemconfigure(
                        tag,
                        **kwargs
                    )
                self.canvas.tag_raise(tag)

        if apply_to_texts:
            for tag in self.list_tags_txt_content:
                if tag is not None:
                    self.canvas.itemconfigure(
                        tag,
                        **kwargs
                    )
                self.canvas.tag_raise(tag)

    def check_widths(self, lbl_data: tuple[tuple[float, float, float, float], int, str], txt_data: tuple[tuple[float, float, float, float], int, str]):
        px, py = self.x_y_pop_up_launch.get()

        left_canvas = self.canvas.winfo_rootx()
        top_canvas = self.canvas.winfo_rooty()
        px += left_canvas
        py += top_canvas

        bbox = self.bbox_pop_up.get()
        bbox_lbl, tag_lbl, text_lbl = lbl_data
        bbox_txt, tag_txt, text_txt = txt_data
        # bbox_txt = self.bbox_txt_station_name
        # bbox_lbl = self.bbox_lbl_txt_station_name
        # font_txt: tkinter.font = self.canvas.itemcget(self.tag_txt_station_name, "font")
        # font_lbl: tkinter.font = self.canvas.itemcget(self.tag_lbl_txt_station_name, "font")
        font_txt: tkinter.font = font.Font(font=self.canvas.itemcget(tag_txt, "font"))
        font_lbl: tkinter.font = font.Font(font=self.canvas.itemcget(tag_lbl, "font"))
        # w_txt = font_txt.measure(station_name)
        # w_lbl = font_lbl.measure(self.canvas.itemcget(self.tag_lbl_txt_station_name, "text"))
        w_txt = font_txt.measure(text_txt)
        w_lbl = font_lbl.measure(text_lbl)
        w_bbox_txt = abs(bbox_txt[2] - bbox_txt[0])
        w_bbox_lbl = abs(bbox_lbl[2] - bbox_lbl[0])
        new_width = sum([
            self.m_left,
            w_txt,
            w_lbl,
            self.m_right
        ])
        curr_width = sum([
            self.m_left,
            w_bbox_lbl,
            w_bbox_txt,
            self.m_right
        ])
        print(f"{lbl_data=}")
        print(f"{txt_data=}")
        print(f"{self.m_left=}, {w_txt=}, {w_lbl=}, {self.m_right=}, {w_bbox_lbl=}, {w_bbox_txt=}")
        print(f"{new_width=}, {curr_width=}")
        print(f"{left_canvas=}, {top_canvas=}")
        if new_width > curr_width:
            # need to expand
            print(f"\tNEED TO EXPAND")
            self.w_pop_up.set(new_width)
            nx, ny = clamp(0, px, bbox[2] - self.w_pop_up.get()), clamp(0, py, bbox[3] - self.h_pop_up.get())
            print(f"Old (x,y)=({px}, {py}), New (x,y)=({nx}, {ny})")
            self.x_y_pop_up_launch.set((nx, ny))
            self.bbox_pop_up.set((
                nx,
                ny,
                nx + self.w_pop_up.get(),
                ny + self.h_pop_up.get()
            ))
        # else:
        #     print(f"WIDTH IS FINE")
        #     self.w_pop_up.set(self.rv_w_pop_up)

    def set_station_name(self, station_name: str) -> None:
        station_name = str(station_name)
        # print(f"POP UP STATION NAME: '{station_name}'")
        self.canvas.itemconfigure(
            self.tag_txt_station_name,
            text=station_name
        )
        # self.check_widths(
        #     (self.bbox_lbl_txt_station_name, self.tag_lbl_txt_station_name, self.canvas.itemcget(self.tag_lbl_txt_station_name, "text")),
        #     (self.bbox_txt_station_name, self.tag_txt_station_name, station_name)
        # )

        # bbox_txt = self.bbox_txt_station_name
        # bbox_lbl = self.bbox_lbl_txt_station_name
        # font_txt: tkinter.font = self.canvas.itemcget(self.tag_txt_station_name, "font")
        # font_lbl: tkinter.font = self.canvas.itemcget(self.tag_lbl_txt_station_name, "font")
        # w_txt = font_txt.measure(station_name)
        # w_lbl = font_lbl.measure(self.canvas.itemcget(self.tag_lbl_txt_station_name, "text"))
        # w_bbox_txt = bbox_txt[2] - bbox_txt[0]
        # w_bbox_lbl = bbox_lbl[2] - bbox_lbl[0]
        # new_width = sum([
        #     self.m_left,
        #     w_txt,
        #     w_lbl,
        #     self.m_right
        # ])
        # curr_width = sum([
        #     self.m_left,
        #     w_bbox_lbl,
        #     w_bbox_txt,
        #     self.m_right
        # ])
        # if new_width > curr_width:
        #     # need to expand
        #     self.w_pop_up.set(new_width)
        # else:
        #     self.w_pop_up.set(self.rv_w_pop_up)

    def set_station_number(self, station_number: str) -> None:
        station_number = str(station_number)
        print(f"POP UP STATION NUMBER: '{station_number}'")
        self.canvas.itemconfigure(
            self.tag_txt_station_number,
            text=station_number
        )
        # self.check_widths(
        #     (self.bbox_lbl_txt_station_number, self.tag_lbl_txt_station_number, self.canvas.itemcget(self.tag_lbl_txt_station_number, "text")),
        #     (self.bbox_txt_station_number, self.tag_txt_station_number, station_number)
        # )

    def set_station(self, station: WorkStation):
        self.set_station_name(station.name)
        self.set_station_number(station.number)


class App(tkinter.Tk):

    def __init__(self):
        super().__init__()

        ########################
        #  Application title   #
        ########################
        self.tv_title_app_full = tkinter.StringVar(self, value="BWS Production Floor Viewer")
        self.tv_title_app_short = tkinter.StringVar(self, value="Prod Floor Viewer")
        self.title(self.tv_title_app_full.get())

        ##############################
        #   Application dimensions   #
        ##############################
        self.geometry(f"100x100+81+80")
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
        self.fps_pop_up = 1 / 48  # Seconds per frame the pop-up button is rendered, (1/2 => 0.5s per frame).
        self.width_pop_up = tkinter.IntVar(self, value=400)
        self.height_pop_up = tkinter.IntVar(self, value=250)
        self.p_w_info_frame_pop_up = tkinter.DoubleVar(self, value=0.8)
        self.p_h_info_frame_pop_up = tkinter.DoubleVar(self, value=0.8)
        self.pad_pop_up = 40  # Horizontal and Vertical spacing to 'pad' the pop-up bbox. this will allow the user to hover a larger rectangle when trying to navigate to the pop-up from the launch cell
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

        self.text_err_could_not_unipoint_data = f"Could not load Unipoint Data from Server3."
        self.text_err_could_not_loap_map = f"Could not load map"
        self.text_checkbox_show_grid_lines = f"Show Grid-Lines"
        self.text_checkbox_show_station_markers = f"Show Station Markers"
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
                text=self.text_err_could_not_loap_map,
                font=("Arial", 42, "bold"),
                fill=self.colour_err_no_map_found_label.hex_code
            )

        self.df_unipoint_equipment = None
        # self.load_dfs()

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

        self.bbox_pop_up = tkinter.Variable(self, value=(
            (-2 * self.width_pop_up.get()) - self.width_pop_up.get(),
            (-2 * self.height_pop_up.get()) - self.height_pop_up.get(),
            -self.width_pop_up.get(),
            -self.height_pop_up.get()
        ))

        # (-200, -100, -100, -50))
        self.tag_pop_up = self.canvas_map.create_rectangle(
            *self.bbox_pop_up.get(),
            fill=self.colour_pop_up.hex_code
        )

        self.list_station_rects = list()
        self.init_station_squares()

        self.n_cols, self.n_rows = len(self.lines_vertical) + 1, len(self.lines_vertical) + 1
        self.curr_col = tkinter.IntVar(self, value=-1)
        self.curr_row = tkinter.IntVar(self, value=-1)
        self.tv_showing_pop_up = tkinter.BooleanVar(self, value=False)
        self.tv_x_y_pop_up_launch = tkinter.Variable(self, value=(-1, -1))
        self.tv_showing_pop_up_frames = tkinter.IntVar(self, value=self.rv_showing_pop_up_frames)
        # self.bbox_pop_up = tkinter.Variable(self, value=(None, None, None, None))
        self.list_ids_after_expand_showing_pop_up = tkinter.Variable(self, value=list())

        # self.puc = PopUpContentManager(
        #     self.canvas_map,
        #     self.tag_pop_up,
        #     self.bbox_pop_up,
        #     self.tv_x_y_pop_up_launch,
        #     self.width_pop_up,
        #     self.height_pop_up,
        #     self.width_pop_up.get(),
        #     self.height_pop_up.get()
        # )
        self.info_frame_pop_up = InfoFrame(
            self.canvas_map,
            labels={"Key_A": "Val_A"},
            auto_grid=True,
            key_width=15,
            val_width=20
        )
        self.tag_info_frame_pop_up = self.canvas_map.create_window(
            *self.tv_x_y_pop_up_launch.get(),
            anchor=tkinter.NW,
            window=self.info_frame_pop_up,
            width=self.width_pop_up.get() * self.p_w_info_frame_pop_up.get(),
            height=self.height_pop_up.get() * self.p_h_info_frame_pop_up.get()
        )

        # self.columnconfigure(0, weight=1)
        self.grid_widgets()

        self.id_after_hover_canvas_map = None
        self.n_clicks = tkinter.IntVar(self, value=0)
        self.canvas_map.tag_raise(self.tag_pop_up)
        self.canvas_map.tag_raise(self.tag_dot)
        # self.canvas_map.tag_raise(self.tag_info_frame_pop_up)
        self.tv_showing_pop_up.trace_variable("w", self.update_showing_pop_up)
        self.canvas_map.bind("<Motion>", self.motion_canvas_map)
        self.canvas_map.bind("<Button-1>", self.click_canvas_map)
        self.canvas_map.itemconfigure(self.tag_info_frame_pop_up, state="hidden")

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

    def load_dfs(self):
        sql_unipoint_equipment = {
            "sql": """
SELECT 
    [Equip_num]
    ,[Equip_Desc]
    ,[Status]
    ,[Availability]
    ,[Acquisition_date]
    ,[ModelYear]
    ,[ModelNo]
    ,[Serial_No]
    ,[Manufacturer]
    ,[Manager]
    ,[Division]
    ,[Owner]
    ,[Acquisition]
    ,[SupplierName]
    ,[Assigned_to]
    ,[Assigned_dept]
    ,[Class]
    ,[Category]
    ,[Location]
    ,[Current_location]
    ,[Warranty_date]
    ,[UsageGroup]
FROM 
    [uniPoint_Live].[dbo].[v_Tools&Equip]""",
            "database": "uniPoint_Live",
            "uid": "SRS",
            "pwd": ""
        }
        self.df_unipoint_equipment = connect(**sql_unipoint_equipment)

        if self.df_unipoint_equipment.empty:
            raise ValueError(self.text_err_could_not_unipoint_data)

    def idxs_to_station(self, idx_h: int, idx_v: int) -> WorkStation | None:
        for i, r_c in enumerate(self.list_idxs_stations):
            r, c = r_c
            if (r == idx_h) and (c == idx_v):
                return self.list_stations[i]

    def get_line_idxs(self, ex: int, ey: int) -> tuple[int, int]:
        return int(ey / (self.height_cell ** 2)), int(ex / (self.width_cell ** 2))

    def get_event_lines(self, event: tkinter.Event) -> tuple[list[int, int], list[int, int]]:
        ex, ey = event.x, event.y
        idx_h, idx_v = self.get_line_idxs(ex, ey)

        lines_h = self.lines_horizontal[idx_h:idx_h + 2]
        lines_v = self.lines_vertical[idx_v:idx_v + 2]
        return lines_h, lines_v

    def update_show_grid_lines(self, *args) -> None:
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

    def update_show_station_markers(self, *args) -> None:
        key = self.text_checkbox_show_station_markers
        val = self.controls_checkboxes[key]['var'].get()
        print(f"update_show_station_markers v={val}")

        state = "normal" if val else "hidden"

        for station in self.list_station_rects:
            self.canvas_map.itemconfigure(
                station,
                state=state
            )

    def init_station_squares(self) -> None:
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

    def motion_canvas_map(self, event: tkinter.Event) -> None:

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

    def click_canvas_map(self, event: tkinter.Event) -> None:
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

    def update_showing_pop_up(self, *args) -> None:
        showing = self.tv_showing_pop_up.get()

        if showing:
            state = "normal"
        else:
            state = "hidden"
            for id_after in self.list_ids_after_expand_showing_pop_up.get():
                self.after_cancel(id_after)
            # self.puc.hide_contents()

            self.canvas_map.itemconfigure(
                self.tag_info_frame_pop_up,
                state=state
            )

        self.canvas_map.itemconfigure(
            self.tag_pop_up,
            state=state
        )

        if showing:
            self.tv_showing_pop_up_frames.set(self.rv_showing_pop_up_frames)
            list_ids_after_expand_showing_pop_up = list()
            for i in range(self.tv_showing_pop_up_frames.get()):
                ms = int(i * 1000 * self.fps_pop_up)
                # print(f"{i=}, {ms=}")
                list_ids_after_expand_showing_pop_up.append(
                    self.after(ms, self.expand_pop_up)
                )
            self.list_ids_after_expand_showing_pop_up.set(list_ids_after_expand_showing_pop_up)

    def expand_pop_up(self) -> None:
        n_frames = self.rv_showing_pop_up_frames - self.tv_showing_pop_up_frames.get()
        p_frames = n_frames / self.rv_showing_pop_up_frames

        bbox_canvas_map = self.bbox(self.canvas_map)
        mx, my = self.tv_x_y_pop_up_launch.get()
        w_pu, h_pu = self.width_pop_up.get(), self.height_pop_up.get()
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
        # print(f"{w_pu=}, {h_pu=}, {self.bbox_pop_up.get()=}")
        self.canvas_map.coords(
            self.tag_pop_up,
            *self.bbox_pop_up.get()
        )
        self.tv_showing_pop_up_frames.set(self.tv_showing_pop_up_frames.get() - 1)
        if self.tv_showing_pop_up_frames.get() <= 0:
            self.finished_expanding_pop_up()

    def finished_expanding_pop_up(self) -> None:
        print(f"finished_expanding_pop_up, {self.tv_x_y_pop_up_launch.get()=}")

        self.info_frame_pop_up.change_value("Key_B", f"{datetime.datetime.now():%Y-%m-%d %H:%M:%S}")
        self.canvas_map.itemconfigure(
            self.tag_info_frame_pop_up,
            state="normal"
        )

        width = self.width_pop_up.get()
        height = self.height_pop_up.get()
        w_info_frame = width * self.p_w_info_frame_pop_up.get()
        h_info_frame = height * self.p_h_info_frame_pop_up.get()
        h_space = width - w_info_frame
        v_space = height - h_info_frame
        px, py = self.tv_x_y_pop_up_launch.get()
        x_info_frame = px + (h_space / 4)
        y_info_frame = py + (v_space / 4)
        self.canvas_map.coords(
            self.tag_info_frame_pop_up,
            x_info_frame,
            y_info_frame
        )

        # puc = self.puc
        # row, col = self.curr_row.get(), self.curr_col.get()
        # station = self.idxs_to_station(row, col)
        # bbox_pop_up = self.bbox_pop_up.get()
        # if station is not None:
        #     puc.set_station(station)
        #     if self.df_unipoint_equipment is not None:
        #         df_station = self.df_unipoint_equipment.loc[self.df_unipoint_equipment["Equip_Desc"] == station.uni_point_name]
        #         if not df_station.empty:
        #             print(f"{df_station=}")
        #         else:
        #             print(f"could not find unipoint entry for '{station.uni_point_name}'")
        #     puc.show_contents()
        # else:
        #     puc.hide_contents()


if __name__ == '__main__':
    app = App()
    app.mainloop()
