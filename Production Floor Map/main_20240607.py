import datetime
import enum
import tkinter
from tkinter import font

import pandas as pd

from pyodbc_connection import connect, can_connect
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


class Hardware:

    def __init__(self, data: dict):
        self.data = data
        self.name = data.get("name", "UNNAMED WORK STATION")
        self.is_cad_station = data.get("is_cad_station", False)
        self.number = data.get("number", None)
        self.row = data.get("row", None)
        self.col = data.get("col", None)
        self.uni_point_name = f"STATION{self.number if self.number is not None else '__'}"
        if self.is_cad_station:
            self.uni_point_name = f"CAD{self.uni_point_name}"

        self.background = data.get("colour_background", Colour("#303078"))

        self._is_computer = True
        self._is_printer = False

    def set_is_printer(self, value: bool):
        raise NotImplementedError

    def get_is_printer(self):
        raise NotImplementedError

    def del_is_printer(self):
        raise NotImplementedError

    def set_is_computer(self, value: bool):
        raise NotImplementedError

    def get_is_computer(self):
        raise NotImplementedError

    def del_is_computer(self):
        raise NotImplementedError

    is_computer = property(get_is_computer, set_is_computer, del_is_computer)
    is_printer = property(get_is_printer, set_is_printer, del_is_printer)


class WorkStation(Hardware):

    def __init__(self, data: dict):
        super().__init__(data)
        self.is_computer = True
        self.is_printer = False

        self.background = self.data.get("colour_background_workstation", Colour("#303078"))

    def set_is_printer(self, value: bool):
        if value:
            raise ValueError("Please create a Printer object instead.")
        self._is_printer = value

    def get_is_printer(self):
        return self._is_printer

    def del_is_printer(self):
        del self._is_printer

    def set_is_computer(self, value: bool):
        if not value:
            raise ValueError("Value must be true for a a WorkStation object.")
        self._is_computer = value

    def get_is_computer(self):
        return self._is_computer

    def del_is_computer(self):
        del self._is_computer

    is_computer = property(get_is_computer, set_is_computer, del_is_computer)
    is_printer = property(get_is_printer, set_is_printer, del_is_printer)


class WorkPrinter(Hardware):
    def __init__(self, data: dict):
        super().__init__(data)
        self.is_computer = False
        self.is_printer = True

        self.background = self.data.get("colour_background_workprinter", Colour("#783030"))

    def set_is_printer(self, value: bool):
        if not value:
            raise ValueError("Value must be true for a a WorkPrinter object.")
        self._is_printer = value

    def get_is_printer(self):
        return self._is_printer

    def del_is_printer(self):
        del self._is_printer

    def set_is_computer(self, value: bool):
        if value:
            raise ValueError("Please create a WorkStation object instead.")
        self._is_computer = value

    def get_is_computer(self):
        return self._is_computer

    def del_is_computer(self):
        del self._is_computer

    is_computer = property(get_is_computer, set_is_computer, del_is_computer)
    is_printer = property(get_is_printer, set_is_printer, del_is_printer)


class State(enum.Enum):

    POP_UP: str = "pop_up"
    IDLE: str = "idle"
    REPORTING_ISSUE: str = "reporting_issue"
    LOADING: str = "loading"


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
        self.height_pop_up = tkinter.IntVar(self, value=550)
        self.width_pop_up_ab_next = tkinter.IntVar(self, value=20)
        self.height_pop_up_ab_next = tkinter.IntVar(self, value=20)
        self.p_w_info_frame_pop_up = tkinter.DoubleVar(self, value=0.8)
        self.p_h_info_frame_pop_up = tkinter.DoubleVar(self, value=0.8)
        self.pad_pop_up = 40  # Horizontal and Vertical spacing to 'pad' the pop-up bbox. this will allow the user to hover a larger rectangle when trying to navigate to the pop-up from the launch cell
        self.colour_pop_up = Colour("#A0A8FF")

        self.tv_lbl_combo_map_sel, self.lbl_combo_map_sel, self.tv_combo_map_sel, self.combo_map_sel = combo_factory(
            self,
            tv_label="Choose a Map",
            kwargs_combo={
                "width": 50
            },
            values=[
                "hawkins_layout_2024_05_29.json",
                "hawkins_office_layout_2024_06_06.json"
            ]
        )

        self.json_layout_file = None
        self.map_file = None
        self.width_cell = None
        self.height_cell = None
        self.list_stations = list()
        self.list_printers = list()
        self.list_idxs_stations = list()
        self.list_idxs_printers = list()

        # self.json_layout_file = "hawkins_layout_2024_05_29.json"
        # self.json_layout_file = "hawkins_office_layout_2024_06_06.json"
        # with open(self.json_layout_file, "r") as f:
        #     json_data = json.load(f)
        #     # self.map_file = "\\\\bwsfp01\\public\\IT\\Resource\\Images\\production_floor_map_2024_05_29_marked.jpg"
        #     self.map_file = json_data["work_stations"]["settings"]["map_file"]
        #     self.width_cell = json_data["work_stations"]["settings"]["width_cell"]
        #     self.height_cell = json_data["work_stations"]["settings"]["height_cell"]
        #     self.list_stations = [WorkStation(data) for data in json_data["work_stations"].get("stations", [])]
        #     self.list_printers = [WorkPrinter(data) for data in json_data["work_stations"].get("printers", [])]
        #
        # self.list_idxs_stations = [(s.row, s.col) for s in self.list_stations]
        # self.list_idxs_printers = [(p.row, p.col) for p in self.list_printers]

        #############################
        #   Begin widget creation   #
        #############################
        self.frame_button_bar = tkinter.Frame(self)
        self.frame_toggle_report_issue = tkinter.Frame(self.frame_button_bar)
        self.frame_ctl_checks = tkinter.Frame(self.frame_button_bar)

        self.text_err_could_not_unipoint_data = f"Could not load Unipoint Data from Server3."
        self.text_err_could_not_loap_map = f"Could not load map"
        self.text_checkbox_show_grid_lines = f"Show Grid-Lines"
        self.text_checkbox_show_station_markers = f"Show Station Markers"

        # self.t = ToggleButton(
        #     self.frame_button_bar,
        #     label_text=f"Report Issue",
        #     labels=("Yes", "No")
        # )
        self.tv_lbl_toggle_report_issue, self.lbl_toggle_report_issue = label_factory(
            self.frame_toggle_report_issue,
            tv_label=f"Report an Issue"
        )
        self.toggle_report_issue = ToggleCanvas(
            self.frame_toggle_report_issue,
            option_a="Yes",
            option_b="No",
            auto_grid=False,
            default_value="No"
        )

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

        self.img_prod_floor_hawkins_map = None
        self.photo_prod_floor_hawkins_map = None

        self.df_unipoint_equipment = None
        if can_connect(timeout=60):
            self.load_dfs()

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
        self.lines_horizontal = list()

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
        self.list_printer_rects = list()
        self.init_station_squares()
        self.init_printer_squares()

        self.n_cols, self.n_rows = len(self.lines_vertical) + 1, len(self.lines_vertical) + 1
        self.curr_col = tkinter.IntVar(self, value=-1)
        self.curr_row = tkinter.IntVar(self, value=-1)
        # self.tv_showing_pop_up = tkinter.BooleanVar(self, value=False)
        self.tv_x_y_pop_up_launch = tkinter.Variable(self, value=(-1, -1))
        self.tv_showing_pop_up_frames = tkinter.IntVar(self, value=self.rv_showing_pop_up_frames)
        # self.bbox_pop_up = tkinter.Variable(self, value=(None, None, None, None))
        self.list_ids_after_expand_showing_pop_up = tkinter.Variable(self, value=list())

        self.info_frame_pop_up = InfoFrame(
            self.canvas_map,
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
        self.arrow_button_pop_up_prev = ArrowButton(
            self.canvas_map,
            mode="left",
            callback=self.click_pop_up_arrow_btn_prev
        )
        self.arrow_button_pop_up_next = ArrowButton(
            self.canvas_map,
            mode="right",
            callback=self.click_pop_up_arrow_btn_next
        )
        self.tag_arrow_button_pop_up_next = self.canvas_map.create_window(
            *self.tv_x_y_pop_up_launch.get(),
            anchor=tkinter.NW,
            window=self.arrow_button_pop_up_next,
            width=self.width_pop_up_ab_next.get(),
            height=self.height_pop_up_ab_next.get()
        )
        self.tag_arrow_button_pop_up_prev = self.canvas_map.create_window(
            *self.tv_x_y_pop_up_launch.get(),
            anchor=tkinter.NW,
            window=self.arrow_button_pop_up_prev,
            width=self.width_pop_up_ab_next.get(),
            height=self.height_pop_up_ab_next.get()
        )

        # self.columnconfigure(0, weight=1)
        self.grid_widgets()

        #############################
        #      State Variables      #
        #############################
        # self.valid_states = (
        #     State.LOADING,
        #     State.IDLE,
        #     State.REPORTING_ISSUE
        # )
        self.var_state = tkinter.Variable(self, value=State.LOADING)

        #############################
        #          Bindings         #
        #############################
        self.toggle_report_issue.value.trace_variable("w", self.update_tv_toggle_report_issue)
        self.id_after_hover_canvas_map = None
        self.n_clicks = tkinter.IntVar(self, value=0)
        self.canvas_map.tag_raise(self.tag_pop_up)
        self.canvas_map.tag_raise(self.tag_dot)
        # self.canvas_map.tag_raise(self.tag_info_frame_pop_up)
        self.tv_combo_map_sel.trace_variable("w", self.update_tv_combo_map_sel)
        # self.tv_showing_pop_up.trace_variable("w", self.update_showing_pop_up)
        self.var_state.trace_variable("w", self.update_var_state)
        self.bind_motion_canvas_map = None
        # self.bind_motion_canvas_map = self.canvas_map.bind("<Motion>", self.motion_canvas_map)
        self.bind_button1_canvas_map = self.canvas_map.bind("<Button-1>", self.click_canvas_map)

        self.list_tags_pop_up_window = (
            self.tag_info_frame_pop_up,
            self.tag_arrow_button_pop_up_prev,
            self.tag_arrow_button_pop_up_next
        )

        for pop_up_window_tag in self.list_tags_pop_up_window:
            self.canvas_map.itemconfigure(pop_up_window_tag, state="hidden")

    def update_var_state(self, *args):
        state = eval(self.var_state.get())
        # print(f"update_var_state => {state=}")
        self.update_showing_pop_up()
        # if state == State.POP_UP:

    def grid_widgets(self):
        r, c, rs, cs, ix, iy, x, y, s = grid_keys()
        # self.lbl_demo.grid(**{r: 0, c: 0, s: "nsew"})
        self.frame_button_bar.grid(**{r: 0, c: 0, s: "nsew"})
        self.frame_toggle_report_issue.grid(**{r: 0, c: 0})
        self.lbl_toggle_report_issue.grid(**{r: 0, c: 0})
        self.toggle_report_issue.grid(**{r: 1, c: 0})
        self.frame_ctl_checks.grid(**{r: 0, c: 1, rs: 2, s: "nsew"})
        self.lbl_combo_map_sel.grid(**{r: 1, c: 0, s: "nsew"})
        self.combo_map_sel.grid(**{r: 2, c: 0, s: "nsew"})
        for i, key in enumerate(self.controls_checkboxes):
            btn = self.controls_checkboxes[key]["btn"]
            btn.grid(**{r: 0, c: i})
        self.canvas_map.grid(**{r: 3, c: 0, s: "nsew"})

    # self.columnconfigure(0, weight=1)

    def load_dfs(self):
        sql_unipoint_equipment = {
            "sql": """
SELECT 
    [Equip_num]
    ,[Location]
    ,[Current_location]
    ,[Class]
    ,[Category]
    ,[Equip_Desc]
    ,[Acquisition_date]
    ,[Warranty_date]
    ,[Manufacturer]
    ,[ModelNo]
    ,[ModelYear]
    ,[Serial_No]
    ,[UsageGroup]
    ,[Assigned_dept]
    ,[Assigned_to]
    ,[Manager]
    ,[Division]
    ,[Acquisition]
    ,[SupplierName]
    ,[Owner]
    ,[Status]
    ,[Availability]
FROM 
    [uniPoint_Live].[dbo].[v_Tools&Equip]""",
            "database": "uniPoint_Live",
            "uid": "SRS",
            "pwd": ""
        }
        self.df_unipoint_equipment = connect(**sql_unipoint_equipment)
        # self.list_info_frame_pop_up_columns = [
        #     # 'Equip_num',
        #     'Equip_Desc',
        #     'Status',
        #     'Availability',
        #     'Acquisition_date',
        #     'Warranty_date',
        #     'ModelYear',
        #     'ModelNo',
        #     'Serial_No',
        #     'Manufacturer',
        #     'Manager',
        #     'Division',
        #     'Owner',
        #     'Acquisition',
        #     'SupplierName',
        #     'Assigned_to',
        #     'Assigned_dept',
        #     'Class',
        #     'Category',
        #     'Location',
        #     'Current_location',
        #     'UsageGroup'
        # ]

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
        print(f"WorkStations:")
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

            print(f"\t{name=}, {idx_h=}, {idx_v=}, {bbox=}")

            self.list_station_rects.append(
                self.canvas_map.create_rectangle(
                    *bbox,
                    fill=bg.hex_code
                )
            )

    def init_printer_squares(self) -> None:
        print(f"WorkPrinters:")
        for i, printer in enumerate(self.list_printers):
            name = printer.name
            idx_h = printer.row
            idx_v = printer.col
            bg = printer.background

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

            print(f"\t{name=}, {idx_h=}, {idx_v=}, {bbox=}")

            self.list_printer_rects.append(
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

        state = eval(self.var_state.get())
        # print(f"{ex=}, {ey=}, {state=}")

        if state == State.POP_UP:

            bbox = self.bbox_pop_up.get()
            bbox = (
                bbox[0] - self.pad_pop_up,
                bbox[1] - self.pad_pop_up,
                bbox[2] + self.pad_pop_up,
                bbox[3] + self.pad_pop_up
            )

            if not collide_point(bbox, (ex, ey)):
                self.var_state.set(State.IDLE)
                # self.tv_showing_pop_up.set(False)

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

            if state != State.IDLE:
                # if state='loading' quit
                # OR if state='reporting_issue' quit
                print(f"QQ1")
                return

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

        state = eval(self.var_state.get())
        # if state == self.valid_states[2]:
        if state == State.REPORTING_ISSUE:
            # reporting issue
            print(f"reporting issue")

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
            print(f"{self.list_idxs_printers=}")
            if (row, col) in self.list_idxs_stations:
                print(f"hovering station")
                # self.tv_showing_pop_up.set(True)
                self.var_state.set(State.POP_UP)
                self.tv_x_y_pop_up_launch.set((mx, my))
            elif (row, col) in self.list_idxs_printers:
                print(f"hovering station")
                # self.tv_showing_pop_up.set(True)
                self.var_state.set(State.POP_UP)
                self.tv_x_y_pop_up_launch.set((mx, my))

    def update_showing_pop_up(self, *args) -> None:
        # showing = self.tv_showing_pop_up.get()
        showing = eval(self.var_state.get()) == State.POP_UP

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

        # values = dict(zip(self.))
        # {
            # "Key_B": f"{datetime.datetime.now():%Y-%m-%d %H:%M:%S}",
            # "key_C": f"{}"

        # }
        # self.info_frame_pop_up.change_value(values)
        # self.info_frame_pop_up.change_value("Key_B", f"{datetime.datetime.now():%Y-%m-%d %H:%M:%S}")

        for pop_up_window_tag in self.list_tags_pop_up_window:
            self.canvas_map.itemconfigure(pop_up_window_tag, state="normal")

        width = self.width_pop_up.get()
        height = self.height_pop_up.get()
        w_info_frame = width * self.p_w_info_frame_pop_up.get()
        h_info_frame = height * self.p_h_info_frame_pop_up.get()
        h_space = width - w_info_frame
        v_space = height - h_info_frame
        # px, py = self.tv_x_y_pop_up_launch.get()
        px, py = self.bbox_pop_up.get()[:2]
        x_info_frame = px + (h_space / 4)
        y_info_frame = py + (v_space / 4)
        self.canvas_map.coords(
            self.tag_info_frame_pop_up,
            x_info_frame,
            y_info_frame
        )
        self.canvas_map.coords(
            self.tag_arrow_button_pop_up_prev,
            x_info_frame,
            y_info_frame - (self.height_pop_up_ab_next.get() + 5)
        )
        self.canvas_map.coords(
            self.tag_arrow_button_pop_up_next,
            # (px + w_info_frame) - ((h_space / 4) + self.width_pop_up_ab_next.get()),
            # (px + self.width_pop_up.get()) - ((h_space / 2) + self.width_pop_up_ab_next.get()),
            (x_info_frame + w_info_frame) - self.width_pop_up_ab_next.get(),
            y_info_frame - (self.height_pop_up_ab_next.get() + 5)
        )

        # puc = self.puc
        row, col = self.curr_row.get(), self.curr_col.get()
        station = self.idxs_to_station(row, col)
        # bbox_pop_up = self.bbox_pop_up.get()
        print(f"{station=}")
        if station is not None:
        #     puc.set_station(station)
            if self.df_unipoint_equipment is not None:
                print(f"self.df_unipoint_equipment is not None")
                df_station = self.df_unipoint_equipment.loc[self.df_unipoint_equipment["Equip_Desc"] == station.uni_point_name]
                if not df_station.empty:
                    print(f"{df_station=}")
                    print(f"{df_station.shape[0]} row(s)")
                    for i, data in df_station.iterrows():
                        self.info_frame_pop_up.change_value(data)

                else:
                    print(f"could not find unipoint entry for '{station.uni_point_name}'")
                    self.info_frame_pop_up.change_value({k: "" for k in self.info_frame_pop_up.info_labels})

        #     puc.show_contents()
        # else:
        #     puc.hide_contents()

    def click_pop_up_arrow_btn_prev(self, event):
        print(f"click_pop_up_arrow_btn_prev {event=}")

    def click_pop_up_arrow_btn_next(self, event):
        print(f"click_pop_up_arrow_btn_next {event=}")

    def update_tv_combo_map_sel(self, *args):
        # self.var_state.set(self.valid_states[0])
        self.var_state.set(State.LOADING)
        sel_map = self.tv_combo_map_sel.get()
        print(f"{sel_map=}")
        self.json_layout_file = sel_map

        with open(self.json_layout_file, "r") as f:
            json_data = json.load(f)
            # self.map_file = "\\\\bwsfp01\\public\\IT\\Resource\\Images\\production_floor_map_2024_05_29_marked.jpg"
            self.map_file = json_data["work_stations"]["settings"]["map_file"]
            self.width_cell = json_data["work_stations"]["settings"]["width_cell"]
            self.height_cell = json_data["work_stations"]["settings"]["height_cell"]
            self.list_stations = [WorkStation(data) for data in json_data["work_stations"].get("stations", [])]
            self.list_printers = [WorkPrinter(data) for data in json_data["work_stations"].get("printers", [])]

        self.list_idxs_stations = [(s.row, s.col) for s in self.list_stations]
        self.list_idxs_printers = [(p.row, p.col) for p in self.list_printers]

        # #############################
        # #   Begin widget creation   #
        # #############################
        # self.frame_button_bar = tkinter.Frame(self)
        # self.frame_ctl_checks = tkinter.Frame(self.frame_button_bar)
        #
        # self.text_err_could_not_unipoint_data = f"Could not load Unipoint Data from Server3."
        # self.text_err_could_not_loap_map = f"Could not load map"
        # self.text_checkbox_show_grid_lines = f"Show Grid-Lines"
        # self.text_checkbox_show_station_markers = f"Show Station Markers"
        # self.controls_checkboxes = checkbox_factory(
        #     self.frame_ctl_checks,
        #     buttons=[
        #         (self.text_checkbox_show_grid_lines, self.update_show_grid_lines),
        #         (self.text_checkbox_show_station_markers, self.update_show_station_markers)
        #     ],
        #     default_values=[True, True],
        #     rtype=dict
        # )
        #
        # self.canvas_map = tkinter.Canvas(
        #     self,
        #     width=self.w_canvas_map,
        #     height=self.h_canvas_map
        # )
        #
        # self.colour_err_no_map_found_label = Colour("#CD6951")

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

        # self.df_unipoint_equipment = None
        # self.load_dfs()
        #
        # self.colour_dot = Colour("#B0FFCF")
        # self.width_dot, self.height_dot = 12, 12
        # self.tag_dot = self.canvas_map.create_oval(
        #     (-2 * self.width_dot) - (self.width_dot / 2),
        #     (-2 * self.height_dot) - (self.height_dot / 2),
        #     (-2 * self.width_dot) + (self.width_dot / 2),
        #     (-2 * self.height_dot) + (self.height_dot / 2),
        #     fill=self.colour_dot.hex_code
        # )
        #
        # self.width_line_vertical = 2
        # self.colour_line_vertical = Colour("#963232")
        # self.width_line_horizontal = 2
        # self.colour_line_horizontal = Colour("#323296")

        for line in self.lines_vertical:
            self.canvas_map.delete(line)
        self.lines_vertical.clear()
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

        for line in self.lines_horizontal:
            self.canvas_map.delete(line)
        self.lines_horizontal.clear()
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

        # self.bbox_pop_up = tkinter.Variable(self, value=(
        #     (-2 * self.width_pop_up.get()) - self.width_pop_up.get(),
        #     (-2 * self.height_pop_up.get()) - self.height_pop_up.get(),
        #     -self.width_pop_up.get(),
        #     -self.height_pop_up.get()
        # ))
        #
        # # (-200, -100, -100, -50))
        # self.tag_pop_up = self.canvas_map.create_rectangle(
        #     *self.bbox_pop_up.get(),
        #     fill=self.colour_pop_up.hex_code
        # )

        for line in self.list_station_rects:
            self.canvas_map.delete(line)
        self.list_station_rects.clear()
        for line in self.list_printer_rects:
            self.canvas_map.delete(line)
        self.list_printer_rects.clear()

        self.init_station_squares()
        self.init_printer_squares()

        self.n_cols, self.n_rows = len(self.lines_vertical) + 1, len(self.lines_vertical) + 1
        self.curr_col.set(-1)
        self.curr_row.set(-1)
        # self.tv_showing_pop_up.set(False)
        self.tv_x_y_pop_up_launch.set((-1, -1))
        self.tv_showing_pop_up_frames.set(self.rv_showing_pop_up_frames)
        # self.bbox_pop_up = tkinter.Variable(self, value=(None, None, None, None))
        self.list_ids_after_expand_showing_pop_up.set(list())

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
        # self.info_frame_pop_up = InfoFrame(
        #     self.canvas_map,
        #     auto_grid=True,
        #     key_width=15,
        #     val_width=20
        # )
        # self.tag_info_frame_pop_up = self.canvas_map.create_window(
        #     *self.tv_x_y_pop_up_launch.get(),
        #     anchor=tkinter.NW,
        #     window=self.info_frame_pop_up,
        #     width=self.width_pop_up.get() * self.p_w_info_frame_pop_up.get(),
        #     height=self.height_pop_up.get() * self.p_h_info_frame_pop_up.get()
        # )
        # self.arrow_button_pop_up_prev = ArrowButton(
        #     self.canvas_map,
        #     mode="left",
        #     callback=self.click_pop_up_arrow_btn_prev
        # )
        # self.arrow_button_pop_up_next = ArrowButton(
        #     self.canvas_map,
        #     mode="right",
        #     callback=self.click_pop_up_arrow_btn_next
        # )
        # self.tag_arrow_button_pop_up_next = self.canvas_map.create_window(
        #     *self.tv_x_y_pop_up_launch.get(),
        #     anchor=tkinter.NW,
        #     window=self.arrow_button_pop_up_next,
        #     width=self.width_pop_up_ab_next.get(),
        #     height=self.height_pop_up_ab_next.get()
        # )
        # self.tag_arrow_button_pop_up_prev = self.canvas_map.create_window(
        #     *self.tv_x_y_pop_up_launch.get(),
        #     anchor=tkinter.NW,
        #     window=self.arrow_button_pop_up_prev,
        #     width=self.width_pop_up_ab_next.get(),
        #     height=self.height_pop_up_ab_next.get()
        # )
        #
        # # self.columnconfigure(0, weight=1)
        # self.grid_widgets()

        self.id_after_hover_canvas_map = None
        self.n_clicks.set(0)
        self.canvas_map.tag_raise(self.tag_pop_up)
        self.canvas_map.tag_raise(self.tag_dot)
        # # self.canvas_map.tag_raise(self.tag_info_frame_pop_up)
        # self.tv_showing_pop_up.trace_variable("w", self.update_showing_pop_up)
        # self.canvas_map.bind("<Motion>", self.motion_canvas_map)
        # self.canvas_map.bind("<Button-1>", self.click_canvas_map)
        #
        # self.list_tags_pop_up_window = (
        #     self.tag_info_frame_pop_up,
        #     self.tag_arrow_button_pop_up_prev,
        #     self.tag_arrow_button_pop_up_next
        # )

        for pop_up_window_tag in self.list_tags_pop_up_window:
            self.canvas_map.itemconfigure(pop_up_window_tag, state="hidden")

        self.bind_motion_canvas_map = self.canvas_map.bind("<Motion>", self.motion_canvas_map)
        self.var_state.set(State.IDLE)

    def update_tv_toggle_report_issue(self, *args):
        val = self.toggle_report_issue.value.get()
        if val == self.toggle_report_issue.option_a:
            self.var_state.set(State.REPORTING_ISSUE)
        else:
            self.var_state.set(State.IDLE)



if __name__ == '__main__':
    app = App()
    app.mainloop()
