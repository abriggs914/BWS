import tkinter
import datetime

import pandas as pd

import utility
import tkinter_utility
import datetime_utility
import dataframe_utility
from pyodbc_connection import connect
from colour_utility import *


# Main grid program for STG Production scheduling tool.
# supports scrolling and the first attempt at hovering using canvas objects active listeners
# Needs to apply a new method so as to not differentiate between tile and text.
# Needs click and drag event handlers.


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

        self.data = dict()
        
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
            "colour_tile_outline": Colour("#111111")
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
            "colour_tile_outline_hover": self.data["colour_tile_outline"].brightened(0.25)
        })

        self.data["geometry"] = tkinter_utility.calc_geometry_tl(0.75, 0.75, largest=1, rtype=dict)
        self.data.update({
            "total_width": self.data["geometry"]["width"],
            "total_height": self.data["geometry"]["height"]
        })
        n_cols = self.data["days_forward"] + self.data["days_backward"] + 1  # +1 for today in the middle

        self.df_prod_lines = connect(**SQL_USED_LINES)
        self.df_orders = connect(**SQL_DATED_STG_UNITS)
        # self.df_orders_stg = datetime_utility.replace_timestamp_datetime(self.df_orders_stg)
        # dataframe_utility.convert_timestamp_to_datetime(self.df_orders_stg)
        # print(f"{self.df_orders_stg.dtypes=}")

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

        canvas_background = self.data["colour_calendar_background"]
        gc = utility.grid_cells(
            self.data["tile_width"] * n_cols,
            n_cols,
            self.data["tile_height"] * n_rows,
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
                self.data["tile_width"] * n_cols,
                self.data["tile_height"] * n_rows
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
        self.list_dates = pd.date_range(self.data["first_date"], periods=n_cols, normalize=False)
        self.tiles = {d: {pl: dict() for pl in self.list_prod_lines} for d in self.list_dates}
        self.tiles["home"] = dict()

        # print(f"{now=}\n{self.list_dates=}")

        # top left 'home' cell
        self.tiles["home"]["tile"] = self.canvas.create_rectangle(
            *gc[0][0],
            fill=self.data["colour_tile_header_home_background"].hex_code
        )

        # header row
        for i, row in enumerate(gc[:1]):
            for j, col in enumerate(row[1:]):
                # print(f"{i=}, {j=}")
                prod_line = self.list_prod_lines[i]
                date = self.list_dates[j]
                tile_colour = self.data["colour_tile_header_row_background"]
                tile_text_colour = self.data["colour_tile_header_row_foreground"]
                to_do_texts = [
                    f"{date:%A}",  # Day of Week
                    f"{date:%B}",  # Month
                    f"{date:%d}".removeprefix("0") + f"{utility.number_suffix(date.day)}",  # Numerical month date
                    f"{date:%Y}"  # Year
                ]
                self.tiles[date][prod_line].update({
                    "tile": self.canvas.create_rectangle(
                        *col,
                        fill=tile_colour.hex_code
                    ),
                    "texts": [
                        self.canvas.create_text(
                            int(col[0] + (self.data["tile_width"] * 0.5)),
                            int(col[1] + ((k + 1) * self.data["tile_height"] / (1 + len(to_do_texts)))),
                            text=txt,
                            fill=tile_text_colour.hex_code
                        )
                        for k, txt, in enumerate(to_do_texts)
                    ]
                })

        # header columns
        for i, row in enumerate(gc[1:]):
            for j, col in enumerate(row[:1]):
                # print(f"{i=}, {j=}")
                prod_line = self.list_prod_lines[i]
                date = self.list_dates[j]
                tile_colour = self.data["colour_tile_header_col_background"]
                tile_text_colour = self.data["colour_tile_header_col_foreground"]
                to_do_texts = [
                    prod_line
                ]
                self.tiles[date][prod_line].update({
                    "tile": self.canvas.create_rectangle(
                        *col,
                        fill=tile_colour.hex_code
                    ),
                    "texts": [
                        self.canvas.create_text(
                            int(col[0] + (self.data["tile_width"] * 0.5)),
                            int(col[1] + ((k + 1) * self.data["tile_height"] / (1 + len(to_do_texts)))),
                            text=txt,
                            fill=tile_text_colour.hex_code
                        )
                        for k, txt, in enumerate(to_do_texts)
                    ]
                })

        # rest of the tiles_stg
        for i, row in enumerate(gc[1:]):
            for j, col in enumerate(row[1:]):
                prod_line = self.list_prod_lines[i]
                date = self.list_dates[j]
                tile_colour = self.data["colour_tile_background"]
                tile_outline = self.data["colour_tile_outline"]
                tile_active_colour = self.data["colour_tile_background_hover"]
                tile_active_outline = self.data["colour_tile_outline_hover"]
                tile = self.canvas.create_rectangle(
                    *col,
                    fill=tile_colour.hex_code,
                    outline=tile_outline.hex_code,
                    activefill=tile_active_colour.hex_code,
                    activeoutline=tile_active_outline.hex_code
                )
                # tile_text_colour = self.data["colour_tile_foreground"]
                # to_do_texts = [
                #     f"{i}x{j}"
                # ]
                self.tiles[date][prod_line].update({
                    "tile": tile  #,
                    # "texts": [
                    #     self.canvas.create_text(
                    #         int(col[0] + (self.data["tile_width"] * 0.5)),
                    #         int(col[1] + ((k + 1) * self.data["tile_height"] / (1 + len(to_do_texts)))),
                    #         text=txt,
                    #         fill=tile_text_colour.hex_code
                    #     )
                    #     for k, txt, in enumerate(to_do_texts)
                    # ]
                })
                # self.canvas.tag_bind(tile, "<Motion>", self.on_motion)


        # self.df_orders_stg["Available Date"] = pd.to_datetime(self.df_orders_stg["Available Date"], infer_datetime_format=True)
        # self.df_orders_stg["Available Date"] = pd.to_datetime(self.df_orders_stg["Available Date"]).dt.to_pydatetime()

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
            print(f"{type(date)=}, {date=}, {prod_line=}")
            print(f"{dat_dealer=}")
            if date is not None and prod_line is not None:
                if self.data["first_date"] <= date <= self.data["last_date"]:
                    # place this tile with date and prod_line
                    tile_data = self.tiles[date][prod_line]
                    col = self.canvas.bbox(tile_data["tile"])
                    # prev_texts = tile_data.get("texts", [])
                    tile_text_colour = self.data["colour_tile_foreground"]
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
                                fill=tile_text_colour.hex_code
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

        self.title("Stargate Production Scheduler")
        self.geometry(self.data["geometry"]["str"])

        self.grid_widgets()

        self.canvas.configure(xscrollcommand=self.scroll_bar_x.set)
        self.canvas.bind("<MouseWheel>", self.on_mousewheel_calendar)

        print(f"{self.data=}")

    def grid_keys(self):
        return "row", "column", "rowspan", "columnspan", "ipadx", "ipady", "padx", "pady", "sticky"

    def grid_widgets(self):
        r, c, rs, cs, ix, iy, x, y, s = self.grid_keys()
        self.frame_calendar.grid()
        self.canvas.grid()
        self.scroll_bar_x.grid(**{s: "ew"})

    def scroll_x_calendar(self, *args):
        # change the canvas xview when the scrollbar is interacted with
        # print(f"scroll_x: {args=}")
        self.canvas.xview(*args)

    def on_mousewheel_calendar(self, event):
        # move the canvas xview when mousewheel scrolled
        self.canvas.xview_scroll(int(-1*(event.delta/120)), "units")

    # def on_motion(self, event):


if __name__ == '__main__':

    app = App()
    app.mainloop()
