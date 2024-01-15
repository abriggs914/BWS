import tkinter
import datetime

import pandas as pd

import utility
import tkinter_utility
import datetime_utility
import dataframe_utility
from pyodbc_connection import connect
from colour_utility import *
from PIL import Image, ImageTk


# Main grid program for STG Production scheduling tool.
# click and drag listeners implemented, undo history, disable multiselect


SQL_USED_LINES = {
    "sql": """
SELECT
	[Prod Line]
FROM
	[Prod Lines]
WHERE
	[Active] = 1
ORDER BY
	[LO]
;
	""",
    "database": "StargateDB",
    "uid": "SGeu1",
    "pwd": "Pupplies-Hagard->Rio0"
}


SQL_DATED_STG_UNITS = {
    "sql": """SELECT
    B.[ProdSchedV2ID#]
    ,B.[SGQuote] AS [OrdersV2_SGQuote]
    ,B.[WO#] AS [OrdersV2_WO#]
    ,B.[JobStartDate]
    ,B.[JobFinishDate]
    --,B.[dtprodschedv2ts]
    ,B.[JobStartLine]
    --,B.[HideFromProdInput]
    ,B.[InputField1]
    ,B.[InputField2]
    --,B.[ApplyUpdate]
    --,B.[ApplyUpdateUser]
      
    , A.[ProdSchedID#]
    ,A.[SGQuote] AS [dtProductionSchedule_SGQuote]
    ,A.[WO#] AS [dt_ProductionSchedule_WO#]
    --,A.[InputField1]
    --,A.[InputField2]
    ,A.[Beam Line]
    ,A.[Beam Date]
    ,A.[GN Line]
    ,A.[GN Date]
    ,A.[WO Line 1]
    ,A.[Prod Date 1]
    ,A.[WO Line 2]
    ,A.[Prod Date 2]
    --,A.[Other]
    --,A.[Other Line]
    --,A.[Other Date]
    --,A.[HideFromProdInput]
    --,A.[Step1SYSPROBudget]
    --,A.[Step2SYSPROBudget]
    --,A.[dtprodschedts]
    --,A.[ApplyUpdate]
    --,A.[ApplyUpdateUser]
    ,A.[Slot#]
    ,A.[Slot/Quote]
    --,A.[Slot Approved]
    ,A.[Prod On]
    ,A.[Prod On Time]
    ,A.[Prod Off]
    ,A.[Prod Off Time]
    ,A.[Prod PM]
    ,A.[Prod Complete]
    ,A.[Prod2 On]
    ,A.[Prod2 On Time]
    ,A.[Prod2 Off]
    ,A.[Prod2 Off Time]
    ,A.[Prod2 PM]
    ,A.[Prod2 Complete]
    --,A.[Prod Instructions]
    ,A.[Beam On]
    ,A.[Beam Off]
    ,A.[Beam Complete]
    ,A.[Beam PM]
    ,A.[Beam Instructions]
    ,A.[GN On]
    ,A.[GN Off]
    ,A.[GN Complete]
    ,A.[GN PM]
    ,A.[GN Instructions]
    ,A.[Axle]
    ,A.[Axle On]
    ,A.[Axle Off]
    ,A.[Axle Complete]
    ,A.[Axle PM]
    ,A.[Axle Instructions]
    ,A.[Other On]
    ,A.[Other On Time]
    ,A.[Other Off]
    ,A.[Other Off Time]
    ,A.[Other Complete]
    ,A.[Other PM]
    ,A.[Other Instructions]
    ,A.[Stargate WO#]
            
    , O. [OrderID]
    ,O.[SGQuote] AS [dtProductionScheduleV2_SGQuote]
    ,O.[Quote Date]
    ,O.[Order Date]
    ,O.[WO#] AS [dt_ProductionScheduleV2_WO#]
    ,O.[Sales Order#]
    ,O.[Model No]
    ,O.[Width]
    ,O.[Spread]
    ,O.[DealerID]
    ,O.[Sale PersonID]
    ,O.[Price]
    ,O.[Prom Drawing]
    --,O.[Special Instructions]
    ,O.[Date Declined]
    ,O.[Decline/Rejected]
    ,O.[Serial Number]
    ,O.[Available Date]
    ,O.[Delivery Date]
    ,O.[Requested Delivery Date]
    ,O.[Finish Date]
    ,O.[Purchase Order]
    ,O.[PO Date]
    --,O.[PayID]
    --,O.[Volume Discount]
    --,O.[Program Discount]
    --,O.[Discount1_Name]
    --,O.[Discount1_Type]
    --,O.[Discount1]
    --,O.[Discount2_Name]
    --,O.[Discount2_Type]
    --,O.[Discount2]
    --,O.[Discount3_Name]
    --,O.[Discount3_Type]
    --,O.[Discount3]
    --,O.[Est Pro Date]
    --,O.[Notes]
    --,O.[EngNotes]
    --,O.[CarrierID]
    --,O.[CustID]
    ,O.[US Sale]
    ,O.[Shipped Date]
    --,O.[GL Override Date]
    --,O.[FE Rate]
    --,O.[PDD]
    ,O.[Deck Length]
    ,O.[Invoice #]
    ,O.[Date Registered]
    ,O.[Date In Service]
    ,O.[Invoice Date]
    --,O.[Date Requested]
    ,O.[GVWR]
    ,O.[Tare]
    --,O.[Selection]
    --,O.[Warranty]
    --,O.[BWSPaid]
    --,O.[BWSPaidDate]
    --,O.[CommPaid]
    --,O.[CommPaidDate]
    --,O.[ts_timestamp]
    --,O.[ModifiedBy]
    --,O.[Lead Date]
    --,O.[Lead Source]
    --,O.[LeadID]
    --,O.[DealerBranchID]
    --,O.[DealerSalesPersonID]
    --,O.[DataEntryCheck]
    --,O.[DataEntryUser]
    --,O.[FinishedGoodsDealerLocID]
    --,O.[WO Reviewed]
    --,O.[WO Review Date]
    --,O.[Follow Up Date]
    --,O.[MSOIsDifferent]
    --,O.[MSOLocID]
    --,O.[EstInvDateOverride]
    --,O.[Estimated Invoice Date]
    --,O.[AdditionalPricingInfo]
    ,O.[Slot#]
    --,O.[TempModel?]
    --,O.[HighRiskUnit]
    --,O.[EngNotes V2]
    ,O.[CompanyID]
    ,O.[Customer WO#]
    --,O.[PriceSecured]
    --,O.[DateSecured]
    --,O.[SecuredBy]
	,(CASE WHEN C.[SGQuote] IS NULL THEN 'N' ELSE 'Y' END) AS [IsGalv]

	--,[D].[COMPANY NAME]
FROM
    [BWSdb].[dbo].[OrdersV2] AS [O]
LEFT JOIN 
    [dtProductionSchedule] AS [A]
ON
    [A].[SGQuote] = [O].[SGQuote]
LEFT JOIN 
    [dtProductionScheduleV2] AS [B]
ON
    [B].[SGQuote] = [O].[SGQuote]
LEFT JOIN
    [BWSdb].[dbo].[v_GalvanizedStargateOrders] AS [C]
ON
    [C].[SGQuote] = [O].[SGQuote]
--LEFT JOIN
--    [BWSdb].[dbo].[DealersV2] AS [D]
--ON
--    [O].[DealerID] = [D].[ID]
WHERE
    [B].[JobFinishDate] IS NOT NULL
ORDER BY
    [B].[JobFinishDate]
;""",
    "database": "StargateDB",
    "uid": "SGeu1",
    "pwd": "Pupplies-Hagard->Rio0"
}


class App(tkinter.Tk):

    def __init__(self):
        super().__init__()

        self.data = {
            "state": {
                "hovered": [],
                "selected": [],
                "dragged": [],
                "cursor_drag_pos": [None, None]
            },
            "history": [],
            "settings": {
                "allow_multi_select": False
            }
        }
        
        # default values
        self.data.update({
            "days_backward": 3 * 7,
            "days_forward": 52 * 7,

            "colour_calendar_background": Colour("#000000"),
            "colour_tile_header_home_background": Colour("#181210"),
            "colour_tile_header_row_background": Colour("#321116"),
            "colour_tile_header_row_foreground": Colour("#e4e4ff"),
            "colour_tile_header_col_background": Colour("#321116"),
            "colour_tile_header_col_foreground": Colour("#e4e4ff"),

            "colour_tile_background": Colour("#ecdddd"),
            "colour_tile_foreground": Colour("#090909"),
            "font_tile": "Arial 10",
            "colour_tile_outline": Colour("#111111"),
            "width_tile_outline": 1
        })
        self.data.update({
            # "colour_calendar_background": Colour("#000000"),
            # "colour_tile_header_home_background": Colour("#181210"),
            # "colour_tile_header_row_background": Colour("#321116"),
            # "colour_tile_header_row_foreground": Colour("#e4e4ff"),
            # "colour_tile_header_col_background": Colour("#321116"),
            # "colour_tile_header_col_foreground": Colour("#e4e4ff"),
            "colour_tile_background_hover": self.data["colour_tile_background"].brightened(0.25),
            "colour_tile_foreground_hover": self.data["colour_tile_foreground"].brightened(0.25),
            "font_tile_hover": "Arial 12 bold",
            "colour_tile_outline_hover": self.data["colour_tile_outline"].brightened(0.25),
            "width_tile_outline_hover": 2,

            "colour_tile_background_selected": Colour("#DC4245"),
            "colour_tile_foreground_selected": Colour("#090909"),
            "font_tile_selected": "Arial 12 bold",
            "colour_tile_outline_selected": Colour("#DDA911"),
            "width_tile_outline_selected": 2
        })

        self.data["geometry"] = tkinter_utility.calc_geometry_tl(0.75, 0.75, largest=1, rtype=dict)
        self.data.update({
            "total_width": self.data["geometry"]["width"],
            "total_height": self.data["geometry"]["height"]
        })
        n_cols = self.data["days_forward"] + self.data["days_backward"] + 1  # +1 for today in the middle

        self.df_prod_lines = connect(**SQL_USED_LINES)
        self.df_orders = connect(**SQL_DATED_STG_UNITS)
        # self.df_orders = datetime_utility.replace_timestamp_datetime(self.df_orders)
        # dataframe_utility.convert_timestamp_to_datetime(self.df_orders)
        # print(f"{self.df_orders.dtypes=}")

        # TODO gracefully fail if DFs are empty

        n_rows = self.df_prod_lines.shape[0] + 1  # +1 for header row
        self.list_prod_lines = self.df_prod_lines["Prod Line"].to_list()

        self.data.update({
            "tile_width": 175,
            "tile_height": 110,
            "canvas_width": self.data["total_width"] * 0.75,
            "canvas_height": self.data["total_height"] * 0.75
        })

        # adjust incase too few prod lines
        if (self.data["tile_height"] * n_rows) < self.data["total_height"]:
            self.data.update({
                "tile_height": self.data["canvas_height"] / n_rows
            })

        self.data.update({
            "canvas_width_scroll_region": self.data["tile_width"] * n_cols,
            "canvas_height_scroll_region": self.data["tile_height"] * n_rows,
        })

        canvas_background = self.data["colour_calendar_background"]
        self.calc_grid_cells = utility.grid_cells(
            self.data["canvas_width_scroll_region"],
            n_cols,
            self.data["canvas_height_scroll_region"],
            n_rows,
            r_type=list
        )

        self.frame_calendar = tkinter.Frame(self)
        self.canvas = tkinter.Canvas(
            self.frame_calendar,
            width=self.data["canvas_width"],
            height=self.data["canvas_height"],
            background=canvas_background.hex_code,
            scrollregion=(
                0,
                0,
                self.data["canvas_width_scroll_region"],
                self.data["canvas_height_scroll_region"]
            )
        )
        self.scroll_bar_x = tkinter.Scrollbar(
            self.frame_calendar,
            orient="horizontal",
            command=self.scroll_x_calendar
        )

        now = datetime_utility.date_to_datetime(datetime.datetime.now().date())
        # now = datetime.datetime.now()
        self.data["first_date"] = now + datetime.timedelta(days=-self.data["days_backward"])
        self.data["last_date"] = now + datetime.timedelta(days=self.data["days_forward"])
        # self.list_dates = pd.date_range(self.data["first_date"], periods=n_cols).to_pydatetime().tolist()
        self.list_dates = pd.date_range(self.data["first_date"], periods=n_cols, normalize=False).to_list()
        self.tiles = {d: {pl: dict() for pl in self.list_prod_lines} for d in self.list_dates}
        self.tiles["home"] = dict()

        # print(f"{now=}\n{self.list_dates=}")

        # rest of the tiles
        for i, row in enumerate(self.calc_grid_cells[1:]):
            for j, col in enumerate(row[1:]):
                prod_line = self.list_prod_lines[i]
                date = self.list_dates[j]
                tile_colour = self.data["colour_tile_background"]
                tile_outline = self.data["colour_tile_outline"]
                tile_outline_width = self.data["width_tile_outline"]
                font = self.data["font_tile"]
                tile = self.canvas.create_rectangle(
                    *col,
                    fill=tile_colour.hex_code,
                    outline=tile_outline.hex_code,
                    width=tile_outline_width
                )
                self.tiles[date][prod_line].update({
                    "tile": tile,
                    "texts": []
                })

        # loop orders and populate the calendar
        for i, row in self.df_orders.iterrows():
            dat_quote = row.get("OrdersV2_SGQuote", "QUOTE=____")
            # print(f"{dat_quote=}, {row['InputField2'].tolist()=}")
            dat_wo = row.get("OrdersV2_WO#", "WO=____")
            dat_sn = row.get("Serial Number#", "SN=____")
            dat_dealer = row.get("InputField2", "DEALER=____")
            dat_galv = row.get("IsGalv", "GALV=____")
            dat_model = row.get("InputField1", "MODEL=____")
            date = row.get("Available Date", None)
            prod_line = row.get("JobStartLine", None)
            # print(f"{type(date)=}, {date=}, {prod_line=}")
            # print(f"{dat_dealer=}")
            if date is not None and prod_line is not None:
                if self.data["first_date"] <= date <= self.data["last_date"]:
                    # place this tile with date and prod_line
                    tile_data = self.tiles[date][prod_line]
                    col = self.canvas.bbox(tile_data["tile"])
                    # prev_texts = tile_data.get("texts", [])
                    tile_text_colour = self.data["colour_tile_foreground"]
                    font = self.data["font_tile"]
                    to_do_texts = [
                        v for v in [
                            dat_quote,
                            dat_wo,
                            dat_sn,
                            dat_model,
                            dat_dealer,
                            dat_galv
                        ]
                    ]
                    self.tiles[date][prod_line].update({
                        "order": i,
                        "texts": [
                            self.canvas.create_text(
                                int(col[0] + (self.data["tile_width"] * 0.5)),
                                int(col[1] + ((k + 1) * self.data["tile_height"] / (1 + len(to_do_texts)))),
                                text=txt,
                                fill=tile_text_colour.hex_code,
                                font=font
                            )
                            for k, txt, in enumerate(to_do_texts)
                        ]
                    })
                else:
                    # this order has already been placed and does not fit on this calendar
                    pass
            else:
                # add this order to the combobox for placing
                pass

        # header row
        for i, row in enumerate(self.calc_grid_cells[:1]):
            for j, col in enumerate(row[1:]):
                # print(f"{i=}, {j=}")
                # prod_line = self.list_prod_lines[i]
                key = "date_legend"
                date = self.list_dates[j]
                tile_colour = self.data["colour_tile_header_row_background"]
                tile_text_colour = self.data["colour_tile_header_row_foreground"]
                font = self.data["font_tile"]
                tile_outline = self.data["colour_tile_outline"]
                tile_outline_width = self.data["width_tile_outline"]
                to_do_texts = [
                    f"{date:%A}",  # Day of Week
                    f"{date:%B}",  # Month
                    f"{date:%d}".removeprefix("0") + f"{utility.number_suffix(date.day)}",
                    # Numerical month date
                    f"{date:%Y}"  # Year
                ]
                if key not in self.tiles[date]:
                    self.tiles[date][key] = dict()
                self.tiles[date][key].update({
                    "tile": self.canvas.create_rectangle(
                        *col,
                        fill=tile_colour.hex_code,
                        outline=tile_outline.hex_code,
                        width=tile_outline_width
                    ),
                    "texts": [
                        self.canvas.create_text(
                            int(col[0] + (self.data["tile_width"] * 0.5)),
                            int(col[1] + ((k + 1) * self.data["tile_height"] / (1 + len(to_do_texts)))),
                            text=txt,
                            fill=tile_text_colour.hex_code,
                            font=font
                        )
                        for k, txt, in enumerate(to_do_texts)
                    ]
                })

        # header columns
        for i, row in enumerate(self.calc_grid_cells[1:]):
            for j, col in enumerate(row[:1]):
                # i, j = i + 1, j + 1  # enumeration from second element will offset the data
                # print(f"{i=}, {j=}")
                prod_line = self.list_prod_lines[i]
                # date = self.list_dates[j]
                key = "line_legend"
                tile_colour = self.data["colour_tile_header_col_background"]
                tile_text_colour = self.data["colour_tile_header_col_foreground"]
                font = self.data["font_tile"]
                tile_outline = self.data["colour_tile_outline"]
                tile_outline_width = self.data["width_tile_outline"]
                to_do_texts = [
                    prod_line
                ]
                if key not in self.tiles:
                    print(f"ADDING KEY {key=}")
                    self.tiles[key] = dict()
                if prod_line not in self.tiles:
                    print(f"ADDING SUB KEY {prod_line=}")
                    self.tiles[key][prod_line] = dict()
                self.tiles[key][prod_line].update({
                    "tile": self.canvas.create_rectangle(
                        *col,
                        fill=tile_colour.hex_code,
                        outline=tile_outline.hex_code,
                        width=tile_outline_width
                    ),
                    "texts": [
                        self.canvas.create_text(
                            int(col[0] + (self.data["tile_width"] * 0.5)),
                            int(col[1] + ((k + 1) * self.data["tile_height"] / (1 + len(to_do_texts)))),
                            text=txt,
                            fill=tile_text_colour.hex_code,
                            font=font
                        )
                        for k, txt, in enumerate(to_do_texts)
                    ]
                })

        # top left 'home' cell
        try:
            self.data["stg_logo_image"] = Image.open(r"C:\Access\Stargate Logo 50%.jpg")
            self.data["stg_logo_image"] = ImageTk.PhotoImage(
                self.data["stg_logo_image"].resize(
                    (
                        int(self.data["tile_width"]),
                        int(self.data["tile_height"])
                    ),
                    Image.ANTIALIAS
                )
            )
        except FileExistsError:
            self.data["stg_logo_image"] = None

        if self.data["stg_logo_image"]:
            self.tiles["home"]["tile"] = self.canvas.create_image(
                self.calc_grid_cells[0][0][0] + (self.data["tile_width"] / 2),
                self.calc_grid_cells[0][0][1] + (self.data["tile_height"] / 2),
                anchor=tkinter.CENTER,
                image=self.data["stg_logo_image"]
            )
        else:
            self.tiles["home"]["tile"] = self.canvas.create_rectangle(
                *self.calc_grid_cells[0][0],
                fill=self.data["colour_tile_header_home_background"].hex_code
            )

        self.title("Stargate Production Scheduler")
        self.geometry(self.data["geometry"]["str"])

        self.grid_widgets()

        self.canvas.configure(xscrollcommand=self.scroll_bar_x.set)
        self.canvas.bind("<MouseWheel>", self.on_mousewheel_calendar)
        self.canvas.bind("<Motion>", self.on_motion_calendar)
        self.canvas.bind("<B1-Motion>", self.on_left_click_motion_calendar)
        self.canvas.bind("<ButtonRelease-1>", self.on_left_click_calendar)
        self.canvas.bind("<ButtonRelease-3>", self.on_right_click_calendar)
        self.canvas.bind("<Control-z>", self.undo)
        self.bind("<Control-z>", self.undo)
        self.protocol("WM_DELETE_WINDOW", self.on_closing)
        # self.bind("<Control-Z>", self.undo)
        # self.canvas.bind("<Control-z>", self.undo)
        # self.bind("<Ctrl-z>", self.undo)

        print(f"{self.data=}")
        print(f"{self.tiles=}")

    def grid_keys(self) -> tuple[str, str, str, str, str, str, str, str, str]:
        return "row", "column", "rowspan", "columnspan", "ipadx", "ipady", "padx", "pady", "sticky"

    def grid_widgets(self) -> None:
        r, c, rs, cs, ix, iy, x, y, s = self.grid_keys()
        self.frame_calendar.grid()
        self.canvas.grid()
        self.scroll_bar_x.grid(**{s: "ew"})

    def scroll_x_calendar(self, *args) -> None:
        # change the canvas xview when the scrollbar is interacted with
        # print(f"scroll_x: {args=}")
        self.canvas.xview(*args)
        self.redraw_legend()

    def on_mousewheel_calendar(self, event) -> None:
        # move the canvas xview when mousewheel scrolled
        self.canvas.xview_scroll(int(-1*(event.delta/120)), "units")
        self.redraw_legend()

    def get_current_canvas_view(self) -> tuple[float, float, float, float]:
        x_1, x_2 = self.canvas.xview()
        y_1, y_2 = self.canvas.yview()
        srw = self.data["canvas_width_scroll_region"]
        srh = self.data["canvas_height_scroll_region"]
        x_1 *= srw
        x_2 *= srw
        y_1 *= srh
        y_2 *= srh
        return x_1, y_1, x_2, y_2

    def redraw_legend(self):
        """Ensure that the left legend containing line names is visible after scrolling."""
        tw, th = self.data["tile_width"], self.data["tile_height"]
        x_1, y_1, x_2, y_2 = self.get_current_canvas_view()
        # print(f"{x_1=}, {x_2}, {y_1}, {y_2}")
        col_legend = [dat for prod_line, dat in self.tiles["line_legend"].items()]
        # print(f"{col_legend=}")
        # tiles = [dat["tile"] for dat in col_legend]
        home_tile = self.tiles["home"]["tile"]
        self.canvas.coords(home_tile, x_1 + (tw / 2), y_1 + (th / 2))
        for dat in col_legend:
            tile = dat["tile"]
            bw = float(self.canvas.itemcget(tile, "width"))
            bbox = self.canvas.bbox(tile)
            y_t = bbox[1] + bw
            # print(f"{bbox=}, {x_1=}, {y_1=}, {x_2=}, {y_2=}, {x_1=}, {y_t=}, {x_1 + tw=}, {y_t + th=}")
            # self.canvas.coords(tile, x_1 + (tw / 2), y_t + (th / 2))
            self.canvas.coords(tile, x_1, y_t, x_1 + tw, y_t + th)
            self.canvas.tag_raise(tile)

            for txt in dat.get("texts", []):
                # print(f"{self.canvas.itemcget(txt, 'text')=}")
                self.canvas.coords(txt, x_1 + (tw / 2), y_t + (th / 2))
                self.canvas.tag_raise(txt)

        # print(f"{self.canvas.winfo_viewable()=}")
        # print(f"{self.canvas.xview()=}")

    def get_date_bucket(self, x: int | float) -> pd.Timestamp | None:
        """
        Return the CLOSEST date to a given x position on the calendar
        Assumes the coordinates are absolute to the scroll region and not the viewable area.
        Use tkinter.canvas.canvasx and canvasy methods to convert before passing as params here.
        """
        srw = self.data["canvas_width_scroll_region"]
        dates = self.list_dates
        p = min(x / srw, 0.999)  # prevent index out of bounds
        # i = int(p * len(dates)) - 1
        # i = int(p * (len(dates) + 1))
        # include the legend in space calculations, but exclude for indexing
        i = int(p * (len(dates) + 1)) - 1
        # print(f"DB {x=}, {srw=}, {p=}, {len(dates)=}, {i=}")
        # return dates[i] if i > 0 else dates[0]
        return dates[i] if i >= 0 else None

    def get_prod_line_bucket(self, y: int | float) -> str | None:
        """
        Return the CLOSEST prod line to a given y position on the calendar
        Assumes the coordinates are absolute to the scroll region and not the viewable area.
        Use tkinter.canvas.canvasx and canvasy methods to convert before passing as params here.
        """
        srh = self.data["canvas_height_scroll_region"]
        lines = self.list_prod_lines
        p = min(y / srh, 0.999)  # prevent index out of bounds
        # include the legend in space calculations, but exclude for indexing
        i = int(p * (len(lines) + 1)) - 1
        # print(f"PLB {y=}, {srh=}, {p=}, {len(lines)=}, {i=}")
        # return lines[i] if i > 0 else lines[0]
        return lines[i] if i >= 0 else None

    def get_date_line_at_x_y(self, x: int | float, y: int | float) -> tuple[pd.Timestamp, str] | tuple[None, None]:
        """
        Get the date and line for a given x and y on the canvas.
        Assumes the coordinates are absolute to the scroll region and not the viewable area.
        Use tkinter.canvas.canvasx and canvasy methods to convert before passing as params here.
        """
        # tile = self.canvas.find_closest(x, y)
        date = self.get_date_bucket(x)
        line = self.get_prod_line_bucket(y)
        return date, line

    def get_tile_at_x_y(self, x: int | float, y: int | float) -> dict:
        """
        Get the tile data for a given x and y on the canvas.
        Assumes the coordinates are absolute to the scroll region and not the viewable area.
        Use tkinter.canvas.canvasx and canvasy methods to convert before passing as params here.
        """
        # tile = self.canvas.find_closest(x, y)
        date, line = self.get_date_line_at_x_y(x, y)
        return self.tiles.get(date, {}).get(line, {})

    def get_tile_bbox(self, date: pd.Timestamp, prod_line: str) -> tuple[float, float, float, float] | None:
        try:
            i_line = self.list_prod_lines.index(prod_line) + 1
        except IndexError:
            i_line = None
        try:
            i_date = self.list_dates.index(date) + 1
        except IndexError:
            i_date = None

        if i_line is None or i_date is None:
            return None

        # return self.calc_grid_cells[i_date][i_line]
        return self.calc_grid_cells[i_line][i_date]

    def select_tile(self, date: pd.Timestamp, prod_line: str, select: bool = True) -> None:
        # print(f"SEL {self.data['settings']['allow_multi_select']=}")
        if not select:
            # self.data["state"]["selected"].clear()
            self.clear_selected_tiles()
        else:
            if not self.data["settings"]["allow_multi_select"]:
                self.select_tile(date, prod_line, False)
            self.data["state"]["selected"].append((date, prod_line))

    def hover_tile(self, date: pd.Timestamp, prod_line: str) -> None:
        self.data["state"]["hovered"].append((date, prod_line))

    def drag_tile(self, date: pd.Timestamp, prod_line: str) -> None:
        self.data["state"]["dragged"].append((date, prod_line))

    def swap_tiles(self, date_line_1: tuple[pd.Timestamp, str], date_line_2: tuple[pd.Timestamp, str], from_undo: bool = False) -> None:
        date_1, line_1 = date_line_1
        date_2, line_2 = date_line_2
        bbox_1, bbox_2 = self.get_tile_bbox(date_1, line_1), self.get_tile_bbox(date_2, line_2)
        order_1, order_2 = self.tiles[date_1][line_1].get("order"), self.tiles[date_2][line_2].get("order")
        texts_1, texts_2 = self.tiles[date_1][line_1].get("texts"), self.tiles[date_2][line_2].get("texts")
        tile_1, tile_2 = self.tiles[date_1][line_1].get("tile"), self.tiles[date_2][line_2].get("tile")

        # swap df_orders indexes
        self.tiles[date_1][line_1]["order"] = order_2
        self.tiles[date_2][line_2]["order"] = order_1

        # swap texts for rendering
        self.tiles[date_1][line_1]["texts"] = texts_2
        self.tiles[date_2][line_2]["texts"] = texts_1

        # swap positions on canvas
        self.canvas.coords(tile_1, *bbox_2)
        self.canvas.coords(tile_2, *bbox_1)

        # swap the tile ids
        self.tiles[date_1][line_1]["tile"] = tile_2
        self.tiles[date_2][line_2]["tile"] = tile_1

        if not from_undo:
            if order_1 or order_2:
                # one of these tiles is an order, record in the history and allow undos.
                self.data["history"].append(
                    ("SWAP", date_line_1, date_line_2)
                )

    def on_right_click_calendar(self, event) -> None:
        self.clear_selected_tiles()


    def on_left_click_calendar(self, event) -> None:
        dt = self.data["state"]["dragged"]
        print(f"on_left_click_calendar, {dt=}")
        x, y = event.x, event.y
        o_x, o_y = self.canvas.canvasx(x), self.canvas.canvasy(y)
        date, line = self.get_date_bucket(o_x), self.get_prod_line_bucket(o_y)
        # tile_data = self.get_tile_at_x_y(o_x, o_y)
        print(f"on_left_click_calendar, {date=}, {line=}")
        state = event.state
        shift_held = state & 0x1
        control_held = state & 0x4
        selected = []

        # TODO this does not support multi select
        drag_date, drag_line = dt[0] if dt else (None, None)
        # drag_idx = self.tiles.get(drag_date, {}).get(drag_line, {}).get("order", None)
        # drag_tile = self.tiles[dt[0][0]][dt[0][1]]["tile"]

        if dt:
            print(f"DRAG")
            # something is being dragged, set it down
            stat_idx = self.tiles.get(date, {}).get(line, {}).get("order", None)
            stat_tile = self.tiles.get(date, {}).get(line, {}).get("tile", None)
            stat_bbox = self.get_tile_bbox(date, line)
            drag_bbox = self.get_tile_bbox(drag_date, drag_line)
            stat_texts = self.tiles[date][line].get("texts", [])
            drag_texts = self.tiles[drag_date][drag_line].get("texts", [])
            self.swap_tiles((drag_date, drag_line), (date, line))

            # if stat_idx:
            #     # an order is already in this spot, need to swap
            #     print(f"Swap")
            #     # # stat_order_data = self.df_orders.iloc[stat_idx]
            #     # # drag_order_data = self.df_orders.iloc[drag_idx]
            #     #
            #     # # swap df_orders indexes
            #     # self.tiles[date][line]["order"] = drag_idx
            #     # self.tiles[drag_date][drag_line]["order"] = stat_idx
            #     #
            #     # # swap texts for rendering
            #     # self.tiles[date][line]["texts"] = drag_texts
            #     # self.tiles[drag_date][drag_line]["texts"] = stat_texts
            #     #
            #     # # swap positions on canvas
            #     # self.canvas.coords(drag_tile, *stat_bbox)
            #     # self.canvas.coords(stat_tile, *drag_bbox)
            #     #
            #     # # swap the tile ids
            #     # self.tiles[date][line]["tile"] = drag_tile
            #     # self.tiles[drag_date][drag_line]["tile"] = stat_tile
            #     self.swap_tiles((drag_date, drag_line), (date, line))
            # else:
            #     # let go over a non-unit tile, place it here
            #     self.swap_tiles((drag_date, drag_line), (date, line))
            #     # self.tiles[date][line]["order"] = drag_idx
            #     # self.tiles[drag_date][drag_line]["order"] = stat_idx
            #     # self.tiles[date][line]["texts"] = drag_texts
            #     # self.tiles[drag_date][drag_line]["texts"] = stat_texts
            #     # self.canvas.coords(stat_tile, *drag_bbox)
            #     # self.canvas.coords(drag_tile, *stat_bbox)
            #     # self.tiles[date][line]["tile"] = drag_tile
            #     # self.tiles[drag_date][drag_line]["tile"] = stat_tile

            self.drag_tile(date, line)  # add the stationary tile for drag re-adjustment
            self.reset_drag_tiles()
            self.clear_selected_tiles()

        else:
            print(f"NOT DRAG")
            if date is None:
                # clicked the prod line select the whole line
                # TODO
                pass
            elif line is None:
                # clicked the date select the entire column
                # selected = [(date, line_) for line_ in self.list_prod_lines]
                # TODO turned this off since multiselect is not supported.
                pass
            elif date is None and line is None:
                return
            else:
                selected = [(date, line)]

            if selected:
                if not shift_held:
                    # print(f"CLEARING SELECTED")
                    self.clear_selected_tiles()

                for sel in selected:
                    self.select_tile(*sel)
                    # self.data["state"]["selected"].append(sel)
                self.update_selected_tiles()
                # print(f"END SELECTED = {self.data['state']['selected']=}")

    def on_left_click_motion_calendar(self, event) -> None:
        ht = self.data["state"]["hovered"]
        st = self.data["state"]["selected"]
        dt = self.data["state"]["dragged"]
        x, y = event.x, event.y
        o_x, o_y = self.canvas.canvasx(x), self.canvas.canvasy(y)
        x_1, y_1, x_2, y_2 = self.get_current_canvas_view()
        print(f"{o_x=}, {o_y=}, {event.delta=}, {event=}")
        if not st:
            # nothing selected, select the hovered and continue
            for date, line in ht:
                self.select_tile(date, line)

            st = self.data["state"]["selected"]

        p_x, p_y = self.data["state"]["cursor_drag_pos"]
        if p_x is None:
            p_x = x
        if p_y is None:
            p_y = y

        tw, th = self.data["tile_width"], self.data["tile_height"]
        d_x, d_y = o_x - p_x, o_y - p_y
        for date, line in (dt + st):
            td = self.tiles[date][line]
            tile = td["tile"]
            bw = float(self.canvas.itemcget(tile, "width"))
            bbox = self.canvas.bbox(tile)
            print(f"\n{self.canvas.type(tile)=}")
            print(f"{tile=}, {bbox=}")
            t_x, t_y = bbox[0] + bw, bbox[1] + bw
            print(f"{date=}, {line=}, {d_x=}, {d_y=}, {t_x=}, {t_y=}")
            # self.canvas.move(tile, t_x + d_x, t_y + d_y)
            self.canvas.coords(tile, o_x - (tw / 2), o_y - (th / 2), o_x + (tw / 2), o_y + (th / 2))
            self.canvas.tag_raise(tile)
            y_t = bbox[1] + bw

            txts = self.tiles[date][line].get("texts", [])
            for i, txt in enumerate(txts):
                # self.canvas.coords(txt, bbox[0] + (tw / 2), bbox[1] + (th / 2))
                self.canvas.coords(txt, bbox[0] + (tw / 2), y_t + ((i + 1) * (th / (len(txts) + 1))))
                self.canvas.tag_raise(txt)

            if (date, line) not in dt:
                self.drag_tile(date, line)

            # self.get_tile_at_x_y()
            self.hover_tile(date, line)

        self.data["state"]["cursor_drag_pos"] = (o_x, o_y)

    def on_motion_calendar(self, event) -> None:
        st = self.data["state"]["selected"]
        dt = self.data["state"]["dragged"]
        x, y = event.x, event.y
        o_x, o_y = self.canvas.canvasx(x), self.canvas.canvasy(y)
        # tile = self.canvas.find_closest(ox, oy)
        date = self.get_date_bucket(o_x)
        line = self.get_prod_line_bucket(o_y)
        if date is None or line is None:
            return
        # self.canvas.itemcget()
        # print(f"{x=}, {y=}, {ox=}, {oy=}, {tile=}, {date=}, {line=}, {event=}")
        # self.data["state"]["hovered"].clear()

        # don't overwrite the selected and dragging tiles with new hovers
        if (date, line) not in (st + dt):
            self.clear_hover_tiles()
            self.hover_tile(date, line)
            self.update_hover_tiles()

    def update_hover_tiles(self) -> None:
        ht = self.data["state"]["hovered"]
        ab = self.data["colour_tile_background_hover"]
        af = self.data["colour_tile_foreground_hover"]
        ao = self.data["colour_tile_outline_hover"]
        font = self.data["font_tile_hover"]
        ow = self.data["width_tile_outline_hover"]
        for date, prod_line in ht:
            tile = self.tiles[date][prod_line].get("tile", None)
            texts = self.tiles[date][prod_line].get("texts", [])
            if tile:
                self.canvas.itemconfigure(
                    tile,
                    fill=ab.hex_code,
                    outline=ao.hex_code,
                    width=ow
                )
            for text in texts:
                self.canvas.itemconfigure(
                    text,
                    fill=af.hex_code,
                    font=font
                )

    def clear_hover_tiles(self) -> None:
        ht = self.data["state"]["hovered"]
        st = self.data["state"]["selected"]
        dt = self.data["state"]["dragged"]
        b = self.data["colour_tile_background"]
        f = self.data["colour_tile_foreground"]
        o = self.data["colour_tile_outline"]
        font = self.data["font_tile"]
        ow = self.data["width_tile_outline"]
        # print(f"{(st + dt)=}")

        # ensure that the selected and dragging tiles are not blanked
        sub_ht = [key for key in ht if key not in (st + dt)]

        for date, prod_line in sub_ht:
            tile = self.tiles[date][prod_line].get("tile", None)
            texts = self.tiles[date][prod_line].get("texts", [])
            if tile:
                self.canvas.itemconfigure(
                    tile,
                    fill=b.hex_code,
                    outline=o.hex_code,
                    width=ow
                )
            for text in texts:
                # print(f"CONFIG: {self.canvas.itemcget(text, 'text')=}")
                self.canvas.itemconfigure(
                    text,
                    fill=f.hex_code,
                    font=font
                )
        self.data["state"]["hovered"].clear()

    def update_selected_tiles(self) -> None:
        st = self.data["state"]["selected"]
        ab = self.data["colour_tile_background_selected"]
        af = self.data["colour_tile_foreground_selected"]
        ao = self.data["colour_tile_outline_selected"]
        font = self.data["font_tile_selected"]
        ow = self.data["width_tile_outline_selected"]
        print(f"{st=}")
        for date, prod_line in st:
            tile = self.tiles[date][prod_line].get("tile", None)
            texts = self.tiles[date][prod_line].get("texts", [])
            if tile:
                self.canvas.itemconfigure(
                    tile,
                    fill=ab.hex_code,
                    outline=ao.hex_code,
                    width=ow
                )
            for text in texts:
                self.canvas.itemconfigure(
                    text,
                    fill=af.hex_code,
                    font=font
                )

    def clear_selected_tiles(self) -> None:
        st = self.data["state"]["selected"]
        b = self.data["colour_tile_background"]
        f = self.data["colour_tile_foreground"]
        o = self.data["colour_tile_outline"]
        font = self.data["font_tile"]
        ow = self.data["width_tile_outline"]
        for date, prod_line in st:
            tile = self.tiles[date][prod_line].get("tile", None)
            texts = self.tiles[date][prod_line].get("texts", [])
            if tile:
                self.canvas.itemconfigure(
                    tile,
                    fill=b.hex_code,
                    outline=o.hex_code,
                    width=ow
                )
            for text in texts:
                # print(f"CONFIG: {self.canvas.itemcget(text, 'text')=}")
                self.canvas.itemconfigure(
                    text,
                    fill=f.hex_code,
                    font=font
                )
        self.data["state"]["selected"].clear()

    def reset_drag_tiles(self):
        print(f"RESETTING DRAG TILES")
        tw, th = self.data["tile_width"], self.data["tile_height"]
        for date, line in self.data["state"]["dragged"]:
            bbox = self.get_tile_bbox(date, line)
            tile = self.tiles[date][line]["tile"]
            # print(f"{date=}, {line=}, {tile=}, {bbox=}")
            self.canvas.coords(tile, *bbox)

            texts = self.tiles[date][line].get("texts", [])
            for i, txt in enumerate(texts):
                tx, ty = int(bbox[0] + (tw * 0.5)), int(bbox[1] + ((i + 1) * th / (1 + len(texts))))
                self.canvas.coords(txt, tx, ty)
                
        self.data["state"]["dragged"].clear()

    def undo(self, event):
        print(f"undo {self.data['history']=}")
        if self.data["history"]:
            action, *data = self.data["history"].pop(-1)
            match action:
                case "SWAP":
                    keys_1, keys_2 = data
                    self.swap_tiles(keys_2, keys_1, from_undo=True)
                case _:
                    raise ValueError("Cant undo")

    def on_closing(self):
        # need the date, line, and Quote # for SQL update query
        user = "abriggs"
        rt1 = "[OrdersV2]"
        kd = "[Available Date]"
        kl = "[JobAvailableLine]"
        ks = "[JobAvailableScheduled]"
        kb = "[JobAvailableScheduledBy]"
        kq = "[SGQuote]"

        rt2 = "[Stargatedb].[dbo].[dtProductionScheduleV2]"
        kj = "[JobStartLine]"

        sql_swap_1 = f"UPDATE\n\t{rt1}\nSET\n\t{kd} = '{{KD}}',\n\t{kl} = '{{KL}}',\n\t{ks} = '{{KS}}',\n\t{kb} = '{{KB}}'\nWHERE\n\t{kq} = '{{KQ}}'\n;"
        sql_swap_2 = f"UPDATE\n\t{rt2}\nSET\n\t{kj} = '{{KJ}}'\nWHERE\n\t{kq} = '{{KQ}}'\n;"
        now = datetime.datetime.now()
        date = f"{now:%Y-%m-%d %H:%M:%S}"
        sql_1 = f""
        sql_2 = f""
        history = self.data["history"]
        # print(f"{history}")
        for action, *data in history:
            # print(f"\t{action=}")
            match action:
                case "SWAP":
                    keys_1, keys_2 = data
                    date_1, line_1 = keys_1
                    date_2, line_2 = keys_2
                    order_1 = self.tiles[date_1][line_1].get("order")
                    order_2 = self.tiles[date_2][line_2].get("order")
                    if order_1 is not None:
                        dat_1 = {
                            "KD": date_1,
                            "KL": line_1,
                            "KS": date,
                            "KB": user,
                            "KQ": self.df_orders.iloc[order_1]["OrdersV2_SGQuote"]
                        }
                        sql_1 += f"\n{sql_swap_1.format(**dat_1)}"
                        dat_2 = {"KJ": line_1, "KQ": self.df_orders.iloc[order_1]["OrdersV2_SGQuote"]}
                        sql_2 += f"\n{sql_swap_2.format(**dat_2)}"

                    if order_2 is not None:
                        dat_1 = {
                            "KD": date_2,
                            "KL": line_2,
                            "KS": date,
                            "KB": user,
                            "KQ": self.df_orders.iloc[order_2]["OrdersV2_SGQuote"]
                        }
                        sql_1 += f"\n{sql_swap_1.format(**dat_1)}"
                        dat_2 = {"KJ": line_1, "KQ": self.df_orders.iloc[order_2]["OrdersV2_SGQuote"]}
                        sql_2 += f"\n{sql_swap_2.format(**dat_2)}"

                    sql_1 = sql_1.removeprefix('\n')
                    sql_2 = sql_2.removeprefix('\n')
                    sql_1 = f"-- SQL OUTPUT - {date}\n\n-- {rt1}\n{sql_1}\n\n-- {rt2}\n{sql_2}"

                case _:
                    raise ValueError("Cant undo")

        print(f"SQL =\n{sql_1}")

        self.destroy()


if __name__ == '__main__':

    app = App()
    app.mainloop()
