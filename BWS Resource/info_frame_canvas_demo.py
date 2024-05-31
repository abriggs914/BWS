import tkinter

from pyodbc_connection import connect
from tkinter_utility import *


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

        if (geo := self.calc_geometry["geometry"]) == "zoomed":
            self.state(geo)
        else:
            self.geometry(geo)

        #############################
        #   Begin widget creation   #
        #############################

        self.tv_lbl_demo, self.lbl_demo = label_factory(
            self,
            tv_label="Hello World!",
            kwargs_label={
                "bg": Colour("#CA98A3").hex_code,
                "fg": Colour("#5A090A").hex_code,
                "font": ("Arial", 30, "bold")
            }
        )

        self.canvas = tkinter.Canvas(
            self,
            background=Colour("#0878FF").hex_code
        )

        # center the demo widget
        self.columnconfigure(0, weight=1)
        self.rowconfigure(0, weight=10)
        self.rowconfigure(0, weight=90)

        self.xy_pos = tkinter.Variable(self, value=(None, None))
        self.bind("<Motion>", self.motion)
        self.w_dot = 6
        self.tag_dot_event = self.canvas.create_oval(
            self.canvas.winfo_x() + ((self.canvas.winfo_width() - self.w_dot) / 2),
            self.canvas.winfo_y() + ((self.canvas.winfo_height() - self.w_dot) / 2),
            self.canvas.winfo_x() + ((self.canvas.winfo_width() + self.w_dot) / 2),
            self.canvas.winfo_y() + ((self.canvas.winfo_height() + self.w_dot) / 2),
            fill=Colour("#C37501").hex_code
        )
        self.tag_dot_pointer = self.canvas.create_oval(
            self.canvas.winfo_x() + ((self.canvas.winfo_width() - self.w_dot) / 2),
            self.canvas.winfo_y() + ((self.canvas.winfo_height() - self.w_dot) / 2),
            self.canvas.winfo_x() + ((self.canvas.winfo_width() + self.w_dot) / 2),
            self.canvas.winfo_y() + ((self.canvas.winfo_height() + self.w_dot) / 2),
            fill=Colour("#01C345").hex_code
        )

        self.grid_widgets()

    def grid_widgets(self):
        r, c, rs, cs, ix, iy, x, y, s = grid_keys()
        self.lbl_demo.grid(**{r: 0, c: 0, s: "nsew"})
        self.canvas.grid(**{r: 1, c: 0, s: "nsew"})

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

    def motion(self, event: tkinter.Event):
        print(f"\n\n")
        ex, ey = event.x, event.y
        px, py = self.canvas.winfo_pointerxy()
        y_drag_bar = self.winfo_rooty()
        cx, cy = self.canvas.canvasx(ex), self.canvas.canvasy(ey)
        # py += y_drag_bar  # add back in the drag bar height
        print(f"{event.__dict__=}")
        print(f"{self.winfo_screen()=}")
        print(f"{self.winfo_viewable()=}")
        print(f"{self.winfo_geometry()=}")
        print(f"{self.winfo_rootx()=}")
        print(f"{self.winfo_rooty()=}")
        print(f"{self.winfo_screenvisual()=}")
        print(f"{self.winfo_vrootx()=}")
        print(f"{self.winfo_vrooty()=}")
        print(f"{self.winfo_vrootwidth()=}")
        print(f"{self.winfo_vrootheight()=}")
        print(f"motion {ex=}, {ey=}, {cx=}, {cy=}, {px=}, {py=}")
        w = self.w_dot
        self.xy_pos.set((ex, ey))
        self.canvas.coords(
            self.tag_dot_event,
            clamp(w, cx - (w / 2), self.canvas.winfo_width()),
            clamp(w, cy - (w / 2), self.canvas.winfo_height()),
            clamp(w, cx + (w / 2), self.canvas.winfo_width()),
            clamp(w, cy + (w / 2), self.canvas.winfo_height())
        )
        self.canvas.coords(
            self.tag_dot_pointer,
            clamp(w, px - (w / 2), self.canvas.winfo_width()),
            clamp(w, py - (w / 2), self.canvas.winfo_height()),
            clamp(w, px + (w / 2), self.canvas.winfo_width()),
            clamp(w, py + (w / 2), self.canvas.winfo_height())
        )


if __name__ == '__main__':
    app = App()
    app.mainloop()
