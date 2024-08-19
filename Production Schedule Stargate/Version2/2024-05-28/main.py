import threading
import time
import tkinter
from tkinter import messagebox
from itertools import zip_longest
from typing import Tuple, Optional

import pandas as pd

import utility
import tkinter_utility
import datetime_utility
from pyodbc_connection import connect
from colour_utility import *
from PIL import Image, ImageTk
from ttkwidgets.color import askcolor, ColorPicker
from ttkwidgets.font import askfont, FontChooser, FontSelectFrame

import win32gui
import win32con
import win32api

# TODO shrink weekend tiles_stg, currently they are just exempt from placement actions. Takes too much space.
# TODO add slight animation for successful placement. 'Ripple' the row and column once complete.  -- CHECK 202404161806
# TODO 202403251934 - the date and line bucket functions seem to have some "drift". when scrolling to the other end of the calendar
#   The hovered tile is too far to the right of the pointer.
# TODO 202406211312 Remove the data dictionary and declare all of the values as class attributes


STARGATE_SQL_CREDS = {
    "database": "StargateDB",
    "uid": "SGeu1",
    "pwd": "Pupplies-Hagard->Rio0"
}


for sql_data in (

        SQL_USED_LINES := {
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
        """
        },

        SQL_WARRANTY_CLAIMS := {
            "sql": """SELECT
        [ID]
        ,[DateCreated]
        ,[CreatedBy]
        ,[Job]
        ,[Line]
        ,[Date]
    FROM
        [PDS_WarrantyUnits]"""
        },

        SQL_HOLIDAYS := {
            "sql": """
        SELECT
            *
        FROM
            [Calendar]
        ;
        """,
            "database": "BWSDB",
            "uid": "user5",
            "pwd": "M@gic456"
        },

        SQL_DATED_STG_UNITS := {
            "sql": """SELECT
        B.[ProdSchedV2ID#]
        ,[O].[SGQuote] AS [OrdersV2_SGQuote]
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
        ,[O].[JobAvailableLine]
        ,[O].[JobAvailableScheduled]
        ,[O].[JobAvailableScheduledBy]
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
    --WHERE
    --    [B].[JobFinishDate] IS NOT NULL
    ORDER BY
        [B].[JobFinishDate]
    ;"""
        },

        SQL_VALID_UPDATERS := {
            "sql": """
    SELECT
        [ID]
        ,[DateAdded]
        ,[TimeStamp]
        ,[UserName]
        ,[Active]
        ,[DateRemoved]
        ,[AllowPublish]
        ,[AllowSaturday]
        ,[AllowSunday]
        ,[ColourCoding]
        ,[InTestingMode]
    FROM
        [Stargatedb].[dbo].[PDS Valid Updaters]
    ;
    """
        }

):
    for cred_k, cred_v in STARGATE_SQL_CREDS.items():
        if cred_k not in sql_data:
            sql_data.update({cred_k: cred_v})


class App(tkinter.Tk):

    def __init__(self):
        super().__init__()

        self.date_version = datetime.datetime(2024,6,21)
        print(f"DATE-VERSION >>> {self.date_version:%Y-%m-%d}")
        self.file_last_session_sql: str = "last_session_sql.sql"

        self.data: dict = {
            "state": {
                "hovered": [],
                "selected": [],
                "dragged": [],
                "cursor_drag_pos": [None, None]
            },
            # "history": [],
            "history": tkinter.Variable(value=list(), name="history"),
            "listbox_history": [],
            "settings": {
                "allow_multi_select": False,
                "colour_coding": {},
                "TEST_MODE": tkinter.BooleanVar(self, value=False),
                "min_font_size_tile": 8,
                "max_font_size_tile": 18,
                "start_at_first_of_month": True,
                "end_at_end_of_month": True
            }
        }
        self.tl_data: dict = {}

        # default values
        self.data.update({
            "days_backward": 3 * 7,
            "days_forward": 52 * 7,

            "opacity_reload": 0.6,
            "x_top_widgets": 10,
            "y_top_widgets": 5,
            "margin_between_mc_and_calendar": 20,

            "colour_foreground_testing_mode_label": Colour("#981415"),
            "font_foreground_testing_mode_label": ("Arial", 12, "bold"),
            "colour_foreground_processing_label": Colour(JADE_GREEN),
            "colour_background_processing_label": Colour("#083712"),
            "font_foreground_processing_label": ("Arial", 32, "bold"),
            "colour_background_root_canvas": Colour("#12CC16"),
            # "colour_app_background": Colour("#C3C3C3"),
            # "colour_app_background": Colour("#941186"),
            "colour_app_background": Colour(self.cget("bg")),
            # "colour_app_background": Colour("#F0F0F0"),
            "colour_calendar_background": Colour("#101060"),
            "colour_tile_header_home_background": Colour("#181210"),
            "colour_tile_header_row_background": Colour("#321116"),
            "colour_tile_header_row_foreground": Colour("#e4e4ff"),
            "colour_tile_header_col_background": Colour("#321116"),
            "colour_tile_header_col_foreground": Colour("#e4e4ff"),

            "colour_tile_background": Colour("#ecdddd"),
            "colour_tile_foreground": Colour("#090909"),
            "font_tile": "Arial 10",
            "colour_tile_outline": Colour("#111111"),
            "width_tile_outline": 1,

            "colour_garbage_background": Colour("#A32234"),
            "colour_garbage_foreground": Colour("#632234"),
            "colour_garbage_outline": Colour("#632234"),
            "colour_garbage_border_width": 4,

            "colour_background_app": Colour("#777797"),
            "colour_background_calendar_app": Colour("#777797"),
            "colour_tile_background_selected": Colour("#DC4245"),
            "colour_tile_foreground_selected": Colour("#090909"),
            "font_tile_selected": "Arial 12 bold",
            "colour_tile_outline_selected": Colour("#DDA911"),
            "width_tile_outline_selected": 4,
            "height_calendar_scrollbar": 20,

            "default_font": ("Arial", 10)
        })
        self.data.update({
            # "colour_calendar_background": Colour("#000000"),
            # "colour_tile_header_home_background": Colour("#181210"),
            # "colour_tile_header_row_background": Colour("#321116"),
            # "colour_tile_header_row_foreground": Colour("#e4e4ff"),
            # "colour_tile_header_col_background": Colour("#321116"),
            # "colour_tile_header_col_foreground": Colour("#e4e4ff"),
            "colour_background_testing_mode_label": self.data["colour_background_app"].brightened(0.15),
            "colour_fill_multi_combobox_drag_tile": self.data["colour_tile_background"].darkened(0.2),
            # "colour_fill_multi_combobox_drag_tile": self.data["colour_app_background"],
            "colour_outline_multi_combobox_drag_tile": self.data["colour_tile_foreground"].darkened(0.2),
            "colour_tile_background_hover": self.data["colour_tile_background"].brightened(0.25),
            "colour_tile_foreground_hover": self.data["colour_tile_foreground"].brightened(0.25),
            "font_tile_hover": "Arial 12 bold",
            "colour_tile_outline_hover": self.data["colour_tile_outline"].brightened(0.25),
            "width_tile_outline_hover": 2,

            "colour_tile_background_weekend": self.data["colour_tile_background"].darkened(0.5),
            "colour_tile_foreground_weekend": self.data["colour_tile_foreground"].darkened(0.5),
            "colour_tile_outline_weekend": self.data["colour_tile_outline"].darkened(0.5),
            "font_tile_weekend": self.data["font_tile"],
            "width_tile_outline_weekend": self.data["width_tile_outline"]
        })
        self.data.update({
            "colour_tile_background_weekend_selected": self.data["colour_tile_background_selected"].darkened(0.25),
            "colour_tile_foreground_weekend_selected": self.data["colour_tile_foreground_selected"].darkened(0.25),
            "colour_tile_outline_weekend_selected": self.data["colour_tile_outline_selected"].darkened(0.25),
            "font_tile_weekend_selected": self.data["font_tile_selected"],

            "colour_tile_background_weekend_hover": self.data["colour_tile_background_hover"].darkened(0.25),
            "colour_tile_foreground_weekend_hover": self.data["colour_tile_foreground_hover"].darkened(0.25),
            "colour_tile_outline_weekend_hover": self.data["colour_tile_outline_hover"].darkened(0.25),
            "font_tile_weekend_hover": self.data["font_tile_hover"]
        })

        self.data.update({
            "title_application_full": f"Stargate Production Scheduler -- {self.date_version:%Y-%m-%d}",
            "title_application_short": "STG Prod Sched",
            "abc_has_hist_msg": f"Are you sure you want to exit, you have unsaved work?",
            "abc_no_hist_msg": f"Are you sure you want to exit?",
            "abcsh_has_hist_msg": f"Save your work before quitting?",
            "abcsh_no_hist_msg": f"Are you sure you want to exit?",
            "msg_no_hist_on_save": f"You do not have any unsaved changes.",
            "msg_save_successful": f"Changes saved successfully!",
            "msg_no_commit_test_mode": f"No changes saved because testing mode is enabled."
        })

        self.tl_cc_app: Optional[tkinter.Toplevel] = None

        # print(f"{self.cget('bg')=}")
        self.menubar = tkinter.Menu(self)
        self.configure(menu=self.menubar)
        self.mb_file = tkinter.Menu(
            self.menubar,
            tearoff=False
        )
        # self.mb_file.add_command(
        #     label="Save",
        #     command=self.click_mb_save
        # )
        self.mb_file.add_command(
            label="Check Units Planned On Holiday",
            command=self.check_for_units_on_holidays
        )
        self.mb_file.add_command(
            label="Colour Code",
            command=self.click_mb_colour_code
        )
        self.mb_file.add_command(
            label="Testing Mode",
            command=self.click_mb_testing_mode
        )
        self.mb_file.add_separator()
        self.mb_file.add_command(
            label="Exit",
            command=self.click_mb_exit
        )
        self.menubar.add_cascade(
            label="File",
            menu=self.mb_file,
            underline=0
        )

        self.title(self.data["title_application_full"])
        self.configure(
            background=self.data["colour_app_background"].hex_code
        )

        # self.data["geometry"] = tkinter_utility.calc_geometry_tl(0.75, 0.75, largest=1, rtype=dict)
        # self.data["geometry"] = tkinter_utility.calc_geometry_tl("zoomed", largest=1, rtype=dict)
        self.data["geometry"] = tkinter_utility.calc_geometry_tl("zoomed", largest=True, rtype=dict)

        if self.data["settings"]["TEST_MODE"].get():
            print(f"DIMS: {self.data['geometry']=}")
        self.data.update({
            "total_width": self.data["geometry"]["width"],
            "total_height": self.data["geometry"]["height"]
        })
        n_cols: int = self.data["days_forward"] + self.data["days_backward"] + 1  # +1 for today in the middle

        self.frame_calendar = tkinter.Frame(
            self,
            width=self.data["geometry"]["width"],
            height=self.data["geometry"]["height"],
            background=self.data["colour_background_app"].hex_code
        )

        self.tv_lbl_processing, self.lbl_processing = None, None

        self.tv_lbl_testing_mode, self.lbl_testing_mode = tkinter_utility.label_factory(
            self,
            tv_label="TESTING MODE ENABLED",
            kwargs_label={
                "fg": self.data["colour_foreground_testing_mode_label"].hex_code,
                "bg": self.data["colour_background_testing_mode_label"].hex_code,
                "font": self.data["font_foreground_testing_mode_label"]
            }
        )

        self.df_valid_updaters = None
        self.data["settings"]["TEST_MODE"].trace_variable("w", self.tv_update_test_mode)
        self.data["settings"]["init_test_mode_done"] = tkinter.BooleanVar(self, value=False)
        self.check_valid_updater()

        tm = self.data["settings"]["TEST_MODE"].get()
        self.df_calendar = connect(**SQL_HOLIDAYS, do_show=tm, do_print=tm)
        self.df_prod_lines = connect(**SQL_USED_LINES, do_show=tm, do_print=tm)
        self.df_orders = connect(**SQL_DATED_STG_UNITS, do_show=tm, do_print=tm).fillna("")
        self.data["multi_combobox_columns_stg"] = ['SGQuote', 'WO#', 'Model No', "Dealer", "Serial#", "Customer WO#"]
        self.data["info_frame_columns_stg"] = \
            ["US Sale"] \
            + self.data["multi_combobox_columns_stg"] \
            + ["Prod Date", "Delivery Date", "Sched Finish", "Sched Line"]
        self.df_multi_combobox_data_orders = pd.DataFrame(columns=self.data["multi_combobox_columns_stg"])
        self.df_rest_orders = pd.DataFrame(columns=self.df_orders.columns)
        # self.df_orders_stg = datetime_utility.replace_timestamp_datetime(self.df_orders_stg)
        # dataframe_utility.convert_timestamp_to_datetime(self.df_orders_stg)
        # print(f"{self.df_orders_stg.dtypes=}")

        self.df_multi_combobox_data_warranties = connect(**SQL_WARRANTY_CLAIMS, do_show=tm, do_print=tm)
        self.df_multi_combobox_data_warranties = self.df_multi_combobox_data_warranties.fillna("")
        # # self.df_multi_combobox_data_warranties_stg["WAR_WO"] = self.df_multi_combobox_data_warranties_stg["WAR_WO"].apply(lambda val: int(val) if str(val).isnumeric() else val)
        # self.df_multi_combobox_data_warranties_stg["WAR_WO"] = self.df_multi_combobox_data_warranties_stg["WAR_WO"].apply(
        #     lambda x:
        #     int(x) if str(x).isnumeric() else str(x)
        # )
        # print(f"{self.df_multi_combobox_data_warranties_stg['WAR_WO']=}")

        if self.data["settings"]["TEST_MODE"].get():
            print(f"{self.df_multi_combobox_data_warranties['Job']=}")
        self.list_multi_combobox_warranties_viewable_col_widths = {
            "Claim #": 60,
            "WO": 80,
            "Model Name": 100,
            "Dealer": 85,
            "Serial Number": 110,
            "Failure": 100,
            "Reason": 75,
            "Location": 80,
            "Parts & Labour": 90,
            "Job": 100
        }
        self.list_multi_combobox_warranties_viewable_cols = {
            "Job": "Job"
        }
        self.list_multi_combobox_warranties_viewable_col_widths = [
            self.list_multi_combobox_warranties_viewable_col_widths[k] for k in
            self.list_multi_combobox_warranties_viewable_cols.values()]
        # self.df_multi_combobox_data_warranties_stg = self.df_multi_combobox_data_warranties_stg.rename(columns=self.list_multi_combobox_warranties_viewable_cols_stg)

        # TODO gracefully fail if DFs are empty

        n_rows = self.df_prod_lines.shape[0] + 1  # +1 for header row
        self.list_prod_lines = self.df_prod_lines["Prod Line"].to_list()
        self.list_warranty_lines = self.list_prod_lines[-1:]  # currently only using the last line

        self.data["width_multi_combobox"] = 725
        self.data["height_multi_combobox"] = 150

        if self.data["settings"]["TEST_MODE"].get():
            print(f"{self.data['width_multi_combobox']=}\n{self.data['height_multi_combobox']=}")

        self.data.update({
            "tile_width": 175,
            "tile_height": 110,
            "tile_width_weekend": 60,
            "tile_height_weekend": 110,
            "tile_width_legend_lines": 110,
            "tile_height_legend_lines": 110,
            "canvas_width": self.data["total_width"] - self.data["width_multi_combobox"],
            "canvas_height": self.data["total_height"] - self.data["height_multi_combobox"]
        })

        # adjust incase too few prod lines
        if (self.data["tile_height"] * n_rows) < self.data["total_height"]:
            self.data.update({
                "tile_height": self.data["canvas_height"] / n_rows
            })

        self.data.update({
            "x_place_frame_canvas": self.data["width_multi_combobox"] - self.data["margin_between_mc_and_calendar"],
            "y_place_frame_canvas": self.data["y_top_widgets"],
            "w_place_frame_canvas": int(self.data["geometry"]["width"]),
            "h_place_frame_canvas": int(self.data["geometry"]["height"]),

            "x_place_frame_multi_combobox": self.data["x_top_widgets"],
            "y_place_frame_multi_combobox": self.data["y_top_widgets"],

            "x_place_frame_info_frame": self.data["x_top_widgets"],
            "y_place_frame_info_frame": self.data["height_multi_combobox"] + 195
        })

        self.frame_info_frame = tkinter.Frame(self.frame_calendar)
        self.frame_canvas = tkinter.Frame(
            self.frame_calendar,
            width=self.data["canvas_width"],
            height=self.data["canvas_height"] + self.data["height_calendar_scrollbar"],  # scrollbar space
            background=self.data["colour_background_calendar_app"].hex_code
        )
        # multicombobox for searching
        self.frame_multi_combobox = tkinter.Frame(
            self.frame_calendar
        )
        self.frame_mc_inner = tkinter.Frame(
            self.frame_multi_combobox
        )

        # multi-combobox selector for orders or warranties
        self.toggle_warranty = tkinter_utility.ToggleCanvas(
            self.frame_multi_combobox,
            option_a="Orders",
            option_b="Warranty",
            width=300,
            height=40,
            default_value="Orders",
            auto_grid=False
        )
        self.toggle_warranty.value.trace_variable("w", self.update_toggle_canvas_selection)

        self.data.update({
            "y_place_toggle_warranty": self.data["y_top_widgets"] + self.toggle_warranty.height
        })

        # multi-combobox now that data has been sorted
        self.multi_combobox_orders = tkinter_utility.MultiComboBox(
            self.frame_mc_inner,
            data=self.df_multi_combobox_data_orders,
            include_aggregate_row=False,
            include_drop_down_arrow=False,
            limit_to_list=False,
            allow_insert_ask=False,
            lock_result_col="SGQuote",
            auto_grid=False,
            show_index_column=False
        )
        self.multi_combobox_orders.res_entry.unbind("<Return>", self.multi_combobox_orders.bind_return_res_entry)
        self.multi_combobox_orders.res_entry.bind("<Return>", self.submit_combobox_entry)

        # multi-combobox for warranty quotes
        self.multi_combobox_warranties = tkinter_utility.MultiComboBox(
            self.frame_mc_inner,
            data=self.df_multi_combobox_data_warranties,
            viewable_column_names=self.list_multi_combobox_warranties_viewable_cols,
            viewable_column_widths=self.list_multi_combobox_warranties_viewable_col_widths,
            include_aggregate_row=False,
            include_drop_down_arrow=False,
            limit_to_list=False,
            allow_insert_ask=False,
            lock_result_col="Job",
            auto_grid=False,
            width=self.data["x_place_frame_canvas"],
            show_index_column=False
        )

        self.today = datetime_utility.date_to_datetime(datetime.datetime.now().date())
        # now = datetime.datetime.now()
        self.data["first_date"] = self.today + datetime.timedelta(days=-self.data["days_backward"])
        if self.data["settings"]["start_at_first_of_month"]:
            self.data["first_date"] = datetime_utility.first_of_month(self.data["first_date"])
        self.data["last_date"] = self.today + datetime.timedelta(days=self.data["days_forward"])
        if self.data["settings"]["end_at_end_of_month"]:
            self.data["last_date"] = datetime_utility.end_of_month(self.data["last_date"])
        # self.list_dates = pd.date_range(self.data["first_date"], periods=n_cols).to_pydatetime().tolist()
        self.list_dates = pd.date_range(self.data["first_date"], periods=n_cols, normalize=False).to_list()
        self.tiles = {d: {pl: dict() for pl in self.list_prod_lines} for d in self.list_dates}
        self.tiles["home"] = dict()
        self.df_ids_to_date_line = {}
        # print(f"{list(self.tiles_stg)[:5]=}")

        self.df_calendar = self.df_calendar.loc[
            (self.list_dates[0] <= self.df_calendar["Date"]) & (self.df_calendar["Date"] <= self.list_dates[-1])]
        self.holidays = self.df_calendar.dropna(subset=["HolidayName"]).set_index("Date")["HolidayName"].to_dict()

        if self.data["settings"]["TEST_MODE"].get():
            print(f"{self.df_calendar=}")
            print(f"{self.holidays=}")

        list_weekend_days = [d for d in self.list_dates if (d.weekday() >= 5)]
        n_weekend_days = len(list_weekend_days)
        n_weekdays = n_cols - n_weekend_days

        # TODO fix variable column sizing
        canvas_width_scroll = self.data["tile_width"] * n_cols  # old method
        # canvas_width_scroll = sum([
        #     self.data["tile_width_legend_lines"],
        #     (n_weekdays * self.data["tile_width"]),
        #     (n_weekend_days * self.data["tile_width_weekend"])
        # ])

        self.data.update({
            "canvas_width_scroll_region":
            # ((n_cols - n_weekend_days) * self.data["tile_width"])
            # + (n_weekend_days * self.data["tile_width_weekend"]),
            #     self.data["tile_width"] * n_cols,
                canvas_width_scroll,
            "canvas_height_scroll_region_stg": self.data["tile_height"] * n_rows,
        })

        # canvas_background = self.data["colour_calendar_background"]
        self.calc_grid_cells = utility.grid_cells(
            self.data["canvas_width_scroll_region"],
            n_cols,
            self.data["canvas_height_scroll_region_stg"],
            n_rows,
            r_type=list
        )
        # self.calc_grid_cells_stg = utility.grid_cells(
        #     self.data["canvas_width_scroll_region"],
        #     n_cols,
        #     self.data["canvas_height_scroll_region_stg"],
        #     n_rows_stg,
        #     r_type=list
        # )

        self.canvas = tkinter.Canvas(
            self.frame_canvas,
            width=self.data["canvas_width"],
            height=self.data["canvas_height"],
            background=self.data["colour_calendar_background"].hex_code,
            scrollregion=(
                0,
                0,
                self.data["canvas_width_scroll_region"],
                self.data["canvas_height_scroll_region_stg"]
            )
        )
        self.scroll_bar_x = tkinter.Scrollbar(
            self.frame_canvas,
            orient="horizontal",
            command=self.scroll_x_calendar
        )

        self.invisible_canvas = tkinter.Canvas(
            self.frame_calendar,
            width=self.data["geometry"]["width"],
            height=self.data["geometry"]["height"],
            background=self.data["colour_background_root_canvas"].hex_code,
            scrollregion=(
                0,
                0,
                self.data["geometry"]["width"],
                self.data["geometry"]["height"]
            )
        )

        # High level message labels:
        self.tv_lbl_processing, self.lbl_processing = tkinter_utility.label_factory(
            self.invisible_canvas,
            tv_label="processing",
            kwargs_label={
                "fg": self.data["colour_foreground_processing_label"].hex_code,
                "bg": self.data["colour_background_processing_label"].hex_code,
                "font": self.data["font_foreground_processing_label"]
            }
        )

        # rest of the tiles_stg
        for i, row in enumerate(self.calc_grid_cells[1:]):
            for j, col in enumerate(row[1:]):
                prod_line = self.list_prod_lines[i]
                date = self.list_dates[j]
                is_weekend = date.weekday() >= 5
                if is_weekend:
                    tile_colour = self.data["colour_tile_background_weekend"]
                    tile_outline = self.data["colour_tile_outline_weekend"]
                    tile_outline_width = self.data["width_tile_outline_weekend"]
                    font = self.data["font_tile_weekend"]
                else:
                    tile_colour = self.data["colour_tile_background"]
                    tile_outline = self.data["colour_tile_outline"]
                    tile_outline_width = self.data["width_tile_outline"]
                    font = self.data["font_tile"]
                # tile = self.canvas_stg.create_rectangle(
                #     *col,
                #     fill=tile_colour.hex_code,
                #     outline=tile_outline.hex_code,
                #     width=tile_outline_width
                # )
                tile = self.draw_rect(
                    col,
                    fill=tile_colour.hex_code,
                    outline=tile_outline.hex_code,
                    width=tile_outline_width,
                    parent=self.canvas
                )
                self.tiles[date][prod_line].update({
                    "tile": tile,
                    "texts": []
                })

        # loop orders and populate the calendar
        self.concats_rest_orders = []
        self.concats_multi_combobox_orders = []
        self.concats_rest_orders_to_multi_combobox = []
        self.concats_double_entries = []
        for i, row in self.df_orders.iterrows():
            no_fit = False
            double = False
            # mc_append_row = None
            dat_quote = row.get("OrdersV2_SGQuote", "QUOTE=____")
            # print(f"{dat_quote=}, {row['InputField2'].tolist()=}")
            dat_wo = row.get("OrdersV2_WO#", "WO=____")
            dat_sn = row.get("Serial Number#", "")
            dat_dealer = row.get("InputField2", "DEALER=____")
            dat_galv = row.get("IsGalv", "GALV=____")
            dat_model = row.get("InputField1", "MODEL=____")
            dat_cust_wo = row.get("Customer WO#", "CUSTWO=____")
            date = row.get("Available Date", None)
            prod_line = row.get("JobStartLine", None)
            self.df_ids_to_date_line[i] = (date, prod_line)
            if prod_line == "":
                prod_line = None

            if self.data["settings"]["TEST_MODE"].get():
                print(f"{dat_quote=}, {date=}, {prod_line=}", end="")
                # print(f"{dat_dealer=}")

            if date is not None and prod_line is not None:
                if self.data["first_date"] <= date <= self.data["last_date"]:
                    # place this tile with date and prod_line

                    if self.data["settings"]["TEST_MODE"].get():
                        print(f"\tFITS")

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
                        ] if v
                    ]
                    if self.tiles[date][prod_line].get("order"):

                        if self.data["settings"]["TEST_MODE"].get():
                            print(f">>> {dat_quote=}, {date=}, {prod_line=} already has an order!!!!")

                        no_fit = True
                        double = True
                    else:
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
                    no_fit = True

                if no_fit:

                    if self.data["settings"]["TEST_MODE"].get():
                        print(f"\tDOESNT FIT")

                    # mc_append_row = []
                    new_row_data = {k: [v] for k, v in row.items()}
                    new_df = pd.DataFrame(new_row_data, index=[self.df_rest_orders.shape[0]])
                    self.concats_rest_orders.append(new_df)

                    if self.data["settings"]["TEST_MODE"].get():
                        # print(f"\n\tBEFORE\n\nnew_df={new_df}\n\nself.df_rest_orders_stg={self.df_rest_orders_stg}")
                        # self.df_rest_orders_stg = pd.concat([self.df_rest_orders_stg, new_df], ignore_index=True)
                        # print(f"\n\tAFTER\n\nnew_df={new_df}\n\nself.df_rest_orders_stg={self.df_rest_orders_stg}")
                        pass

                    if double:
                        new_df = pd.DataFrame(new_row_data, index=[self.df_rest_orders.shape[0]])
                        self.concats_double_entries.append(new_df)
            else:
                # add this order to the combobox for placing

                if self.data["settings"]["TEST_MODE"].get():
                    print(f"\tCOMBOBOX")

                new_row_data = {k: [v] for k, v in zip(self.df_multi_combobox_data_orders.columns,
                                                       [dat_quote, dat_wo, dat_model, dat_dealer, dat_sn, dat_cust_wo])}
                new_df = pd.DataFrame(new_row_data)
                # self.df_multi_combobox_data_orders_stg = pd.concat([self.df_multi_combobox_data_orders_stg, new_df], ignore_index=True)
                self.concats_multi_combobox_orders.append(new_df)

        # TODO add self.concats_rest_orders_stg to self.concats_multi_combobox_orders_stg
        if self.concats_rest_orders:
            self.df_rest_orders = pd.concat(self.concats_rest_orders, ignore_index=True)

            for i, row in self.df_rest_orders.iterrows():
                dat_quote = row.get("OrdersV2_SGQuote", "QUOTE=____")
                # print(f"{dat_quote=}, {row['InputField2'].tolist()=}")
                dat_wo = row.get("OrdersV2_WO#", "WO=____")
                dat_sn = row.get("Serial Number#", "")
                dat_dealer = row.get("InputField2", "DEALER=____")
                dat_galv = row.get("IsGalv", "GALV=____")
                dat_model = row.get("InputField1", "MODEL=____")
                dat_cust_wo = row.get("Customer WO#", "CUSTWO=____")
                new_row_data = {k: [v] for k, v in zip(self.df_multi_combobox_data_orders.columns,
                                                       [dat_quote, dat_wo, dat_model, dat_dealer, dat_sn, dat_cust_wo])}
                new_df = pd.DataFrame(new_row_data)
                self.concats_rest_orders_to_multi_combobox.append(new_df)

        #     self.df_multi_combobox_data_orders_stg = pd.concat(self.concats_rest_orders_stg, ignore_index=True)
        if self.concats_multi_combobox_orders:
            self.concats_multi_combobox_orders = self.concats_rest_orders_to_multi_combobox + self.concats_multi_combobox_orders
            self.df_multi_combobox_data_orders = pd.concat(self.concats_multi_combobox_orders, ignore_index=True)

            # if mc_append_row:
            #     # add new row record to mc
            #     pass

        if self.data["settings"]["TEST_MODE"].get():
            print(f"self.df_orders==\n{self.df_orders}")
            print(f"self.df_rest_orders==\n{self.df_rest_orders}")
            print(f"self.df_multi_combobox_data_orders==\n{self.df_multi_combobox_data_orders}")
            print(f"self.df_rest_orders.columns==\n{list(self.df_rest_orders.columns)}")
            print(f"self.df_multi_combobox_data_orders.columns==\n{list(self.df_multi_combobox_data_orders.columns)}")

        # header row
        for i, row in enumerate(self.calc_grid_cells[:1]):
            for j, col in enumerate(row[1:]):
                # print(f"{i=}, {j=}")
                # prod_line = self.list_prod_lines_stg[i]
                key = "date_legend"
                date = self.list_dates[j]
                # is_holiday = date in self.holidays_stg
                holiday_name = self.holidays.get(date, None)
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
                if holiday_name is not None:
                    to_do_texts.append(holiday_name)
                if key not in self.tiles[date]:
                    self.tiles[date][key] = dict()
                self.tiles[date][key].update({
                    # "tile": self.canvas_stg.create_rectangle(
                    #     *col,
                    #     fill=tile_colour.hex_code,
                    #     outline=tile_outline.hex_code,
                    #     width=tile_outline_width
                    # ),
                    "tile": self.draw_rect(
                        col,
                        fill=tile_colour.hex_code,
                        outline=tile_outline.hex_code,
                        width=tile_outline_width,
                        parent=self.canvas
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
                if holiday_name is not None:
                    self.canvas.itemconfigure(self.tiles[date][key]["texts"][-1], fill="#A44000")

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
                    if self.data["settings"]["TEST_MODE"].get():
                        print(f"ADDING KEY {key=}")
                    self.tiles[key] = dict()
                if prod_line not in self.tiles:
                    if self.data["settings"]["TEST_MODE"].get():
                        print(f"ADDING SUB KEY {prod_line=}")
                    self.tiles[key][prod_line] = dict()
                self.tiles[key][prod_line].update({
                    # "tile": self.canvas_stg.create_rectangle(
                    #     *col,
                    #     fill=tile_colour.hex_code,
                    #     outline=tile_outline.hex_code,
                    #     width=tile_outline_width
                    # ),
                    "tile": self.draw_rect(
                        col,
                        fill=tile_colour.hex_code,
                        outline=tile_outline.hex_code,
                        width=tile_outline_width,
                        parent=self.canvas
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

        # check colour coding
        self.colour_code()

        # top left 'home' cell
        try:
            self.data["stg_logo_image"] = Image.open(r"C:\Access\Stargate Logo 50%.jpg")
            self.data["stg_logo_image"] = ImageTk.PhotoImage(
                self.data["stg_logo_image"].resize(
                    (
                        int(self.data["tile_width"]),
                        int(self.data["tile_height"])
                    ),
                    # Image.ANTIALIAS
                    Image.LANCZOS
                )
            )
        except FileNotFoundError:
            self.data["stg_logo_image"] = None

        if self.data["stg_logo_image"]:
            self.tiles["home"]["tile"] = self.canvas.create_image(
                self.calc_grid_cells[0][0][0] + (self.data["tile_width"] / 2),
                self.calc_grid_cells[0][0][1] + (self.data["tile_height"] / 2),
                anchor=tkinter.CENTER,
                image=self.data["stg_logo_image"]
            )
        else:
            # self.tiles_stg["home"]["tile"] = self.canvas_stg.create_rectangle(
            #     *self.calc_grid_cells_stg[0][0],
            #     fill=self.data["colour_tile_header_home_background"].hex_code
            # )
            self.tiles["home"]["tile"] = self.draw_rect(
                *self.calc_grid_cells[0][0],
                fill=self.data["colour_tile_header_home_background"].hex_code,
                parent=self.canvas
            )

        self.multi_combobox_orders.add_new_item(self.df_multi_combobox_data_orders)

        bg_info_frame = Colour("SystemButtonFace")
        self.info_frame = tkinter_utility.InfoFrame(
            self.frame_info_frame,
            labels=self.data["info_frame_columns_stg"],
            auto_grid=True,
            header="Quote Information:",
            key_width=16,
            val_width=50,
            width=150,
            background=bg_info_frame.hex_code,
            padx=10,
            pady=10,
            cell_border=True,
            key_label_keywords={
                "font": "Arial 12 bold",
                "bg": bg_info_frame.brightened(0.25).hex_code
            },
            value_label_keywords={
                "font": "Arial 12 bold",
                "bg": bg_info_frame.brightened(0.25).hex_code
            },
            header_kwargs={
                "font": "Arial 18 bold",
                "bg": bg_info_frame.hex_code
            },
            formats={
                "Prod Date": lambda d: d.strftime("%Y-%m-%d"),
                "Delivery Date": lambda d: d.strftime("%Y-%m-%d"),
                "Sched Finish": lambda d: d.strftime("%Y-%m-%d")
            }
        )
        self.tv_btn_if_goto, self.btn_if_goto = tkinter_utility.button_factory(
            self.info_frame.frame_header,
            tv_btn="Go To",
            command=self.click_if_goto
        )
        ga = {k: v for k, v in self.info_frame.grid_args["header"].items()}
        ga.update({"columnspan": 1, "column": 0})
        self.info_frame.header[1].grid_forget()
        self.info_frame.header[1].grid(**ga)
        ga.update({"columnspan": 1, "column": 1, "padx": 110})
        self.btn_if_goto.grid(**ga)

        if (geo := self.data["geometry"]["str"]) == "zoomed":
            self.state(geo)
        else:
            self.geometry(geo)

        self.tv_multi_combobox_drag_tile = tkinter.BooleanVar(self, value=False)

        # transparent method
        # canvas_stg
        # https://stackoverflow.com/questions/53021603/how-to-make-a-tkinter-canvas-background-transparent
        self.set_invisible_canvas()

        drag_tile_start_pos = 200, 400
        self.multi_combobox_drag_tile = self.draw_rect(
            (
                *drag_tile_start_pos,
                100 + self.data["tile_width"],
                100 + self.data["tile_height"]
            ),
            fill=self.data["colour_fill_multi_combobox_drag_tile"].hex_code,
            outline=self.data["colour_outline_multi_combobox_drag_tile"].hex_code,
            parent=self.invisible_canvas
        )
        self.dot = self.invisible_canvas.create_oval(
            5, 5, 25, 25,
            fill="#AE3341"
        )
        self.multi_combobox_drag_tile_texts_placeholder = "PLACEHOLDER"
        self.multi_combobox_drag_tile_texts = [
            self.invisible_canvas.create_text(
                (drag_tile_start_pos[0] + ((100 + self.data["tile_width"]) / 2)),
                (drag_tile_start_pos[1] + ((100 + self.data["tile_height"]) / 2)),
                text=self.multi_combobox_drag_tile_texts_placeholder,
                fill=self.data["colour_tile_foreground"].hex_code,
                font=self.data["font_tile"]
            )
        ]

        # scrollable listbox for event history
        self.frame_listbox_history = tkinter.Frame(self)
        self.listbox_history = tkinter.Listbox(
            self.frame_listbox_history,
            width=110
        )
        self.scroll_bar_history = tkinter.Scrollbar(self.frame_listbox_history)
        self.listbox_history.configure(yscrollcommand=self.scroll_bar_history.set)
        self.scroll_bar_history.configure(command=self.listbox_history.yview)

        # add all widgets
        self.grid_widgets()

        # self.invisible_canvas.tag_raise(self.multi_combobox_drag_tile)
        self.invisible_canvas.itemconfigure(self.multi_combobox_drag_tile, state="hidden")
        for txt in self.multi_combobox_drag_tile_texts:
            self.invisible_canvas.itemconfigure(txt, state="hidden")

        # self.invisible_canvas.tag_raise(self.multi_combobox_window)
        # # self.multi_combobox_window.lift()

        # bindings
        self.canvas.configure(xscrollcommand=self.scroll_bar_x.set)
        self.data["history"].trace_variable("w", self.tv_update_history)
        self.canvas.bind("<MouseWheel>", self.on_mousewheel_calendar)
        self.canvas.bind("<Motion>", self.on_motion_calendar)
        self.canvas.bind("<B1-Motion>", self.on_left_click_motion_calendar)
        self.invisible_canvas.bind("<B1-Motion>", self.on_left_click_root_canvas)
        self.bind_treeview_to_canvas()
        self.canvas.bind("<ButtonRelease-1>", self.on_left_click_release_calendar)
        self.canvas.bind("<Button-1>", self.on_left_click_calendar)
        self.canvas.bind("<ButtonRelease-3>", self.on_right_click_calendar)
        self.canvas.bind("<Control-z>", self.undo)
        self.multi_combobox_orders.res_tv_entry.trace_remove("write", self.multi_combobox_orders.trace_res_tv_entry)
        self.multi_combobox_orders.res_tv_entry.trace_add("write", self.multi_combobox_entry_update)
        self.multi_combobox_orders.trace_res_tv_entry = self.multi_combobox_orders.res_tv_entry.trace_add("write",
                                                                                                          self.multi_combobox_orders.update_entry)
        self.bind("<Control-z>", self.undo)
        self.protocol("WM_DELETE_WINDOW", self.on_closing)
        self.tv_update_test_mode()
        # self.bind("<Control-Z>", self.undo)
        # self.canvas_stg.bind("<Control-z>", self.undo)
        # self.bind("<Ctrl-z>", self.undo)

        if self.data["settings"]["TEST_MODE"].get():
            print(f"{self.data=}")
            print(f"{self.tiles=}")

        in_test_mode = self.data["settings"]["TEST_MODE"]

        print(f"TEST_MODE={'Y' if in_test_mode else 'N'}")

    def set_invisible_canvas(self, mode="invisble"):

        if mode == "gray":
            if self.data["settings"]["init_test_mode_done"].get():
                self.wm_attributes("-alpha", self.data["opacity_reload"])
            # self.call("wm", "attributes", ".", "-alpha", "0.9")  # Window Opacity 0.0-1.0
        else:
            # invisible
            if self.data["settings"]["init_test_mode_done"].get():
                self.wm_attributes("-alpha", 1)
            # self.call("wm", "attributes", ".", "-alpha", "1.0")  # Window Opacity 0.0-1.0
            hwnd = self.invisible_canvas.winfo_id()
            colorkey = win32api.RGB(*self.data["colour_background_root_canvas"].rgb_code)
            wnd_exstyle = win32gui.GetWindowLong(hwnd, win32con.GWL_EXSTYLE)
            new_exstyle = wnd_exstyle | win32con.WS_EX_LAYERED
            win32gui.SetWindowLong(hwnd, win32con.GWL_EXSTYLE, new_exstyle)
            # print(f"C1 {hwnd=}, {colorkey=}, {wnd_exstyle=}, {new_exstyle=}")
            win32gui.SetLayeredWindowAttributes(hwnd, colorkey, 255, win32con.LWA_COLORKEY)

    def tv_update_test_mode(self, *args):
        tm = self.data["settings"]["TEST_MODE"].get()
        if tm:
            print(f"tv_update_test_mode")
            print(f"{getattr(self, 'invisible_canvas', None)=}")

        if tm:
            self.lbl_testing_mode.grid(row=0, column=0, columnspan=2, pady=3)
            if getattr(self, "invisible_canvas", None) is not None:
                self.invisible_canvas.itemconfigure(self.dot, state="normal")
        else:
            self.lbl_testing_mode.grid_forget()
            if getattr(self, "invisible_canvas", None) is not None:
                self.invisible_canvas.itemconfigure(self.dot, state="hidden")

        self.reload_application()

    def tv_update_history(self, *args):
        tm = self.data["settings"]["TEST_MODE"].get()
        hist = self.data["history"].get()
        if tm:
            print(f"History update: {hist=}")
        # known_hist = self.data.get("listbox_history", [])
        known_hist = self.listbox_history.get(0, tkinter.END)
        lh, lkh = len(hist), len(known_hist)
        if lh > lkh:
            # added new history event
            new_item = hist[-1]
            if tm:
                print(f"{new_item=}")
            # self.listbox_history.insert(tkinter.END, str(new_item))
            new_code, *new_items = new_item
            date_2, line_2, order_2 = [None] * 3


            # TODO investigate here
            # Exception in Tkinter callback
            # Traceback (most recent call last):
            #   File "C:\Users\ABriggs\AppData\Local\Programs\Python\Python311\Lib\tkinter\__init__.py", line 1948, in __call__
            #     return self.func(*args)
            #            ^^^^^^^^^^^^^^^^
            #   File "C:\Users\ABriggs\Documents\BWS\Production Schedule Stargate\Version2\2024-05-28\main.py", line 1232, in tv_update_history
            #     date_1 = pd.Timestamp(date_1)
            #              ^^^^^^^^^^^^^^^^^^^^
            #   File "pandas\_libs\tslibs\timestamps.pyx", line 1667, in pandas._libs.tslibs.timestamps.Timestamp.__new__
            #   File "pandas\_libs\tslibs\conversion.pyx", line 280, in pandas._libs.tslibs.conversion.convert_to_tsobject
            #   File "pandas\_libs\tslibs\conversion.pyx", line 557, in pandas._libs.tslibs.conversion.convert_str_to_tsobject
            #   File "pandas\_libs\tslibs\parsing.pyx", line 307, in pandas._libs.tslibs.parsing.parse_datetime_string
            # ValueError: Given date string "4" not likely a datetime

            if tm:
                print(f"{new_code=}, {new_items=}")
            date_1, line_1 = new_items[-1]
            date_1 = pd.Timestamp(date_1)
            # date_2 = pd.Timestamp(date_2)
            print(f"{list(self.tiles.keys())=}")
            print(f"{date_1=}, {line_1=}")
            print(f"{self.tiles.get(date_1)=}")
            print(f"{self.tiles.get(date_1, {}).get(line_1)=}")

            if new_code == "SWAP":
                # sometimes in a swap, the first spot will be empty (ex: move Unit to an empty tile)
                print(f"SWAP TO AN EMPTY CELL")

            order_1 = self.tiles[date_1][line_1].get("order")
            msg = f"{new_code} | {order_1} ({date_1:%Y-%m-%d}, {line_1})"
            if len(new_items) > 1:
                date_2, line_2 = new_items[1]

                date_2 = pd.Timestamp(date_2)
                print(f"{date_2=}, {line_2=}")
                print(f"{self.tiles.get(date_2)=}")
                print(f"{self.tiles.get(date_2, {}).get(line_2)=}")

                order_2 = self.tiles[date_2][line_2].get("order")
                msg += f"<-> {order_2} ({date_2:%Y-%m-%d}, {line_2})"

            self.listbox_history.insert(tkinter.END, msg)

            if self.data["settings"]["TEST_MODE"].get():
                print(f"Inserted {new_item=}\n{hist=}")
        elif lh < lkh:
            # deleted a history event
            del_item = known_hist[-1]
            idx = known_hist.index(str(del_item))
            self.listbox_history.delete(idx)
            if self.data["settings"]["TEST_MODE"].get():
                print(f"deleted {del_item=}")
        else:
            # no change
            if self.data["settings"]["TEST_MODE"].get():
                print(f"No Change")
        # self.listbox_history
        if self.data["settings"]["TEST_MODE"].get():
            print(f"AFTER {list(self.data['history'].get())=}")

    def colour_code(self, date=None, line=None):
        cc = self.data["settings"]["colour_coding"]
        if date is None or line is None:
            # colour code every tile
            date_to_check = [d for d in self.list_dates]
            line_to_check = [l for l in self.list_prod_lines]
        else:
            date_to_check = [date]
            line_to_check = [line]

        for date_ in date_to_check:
            for line_ in line_to_check:
                tile_data = self.tiles.get(date_, {}).get(line_, {})
                if tile_data:
                    tag = tile_data["tile"]
                    t_tags = tile_data["texts"]
                    order = tile_data.get("order", None)
                    if order:
                        # print(f"{order} ", end="")
                        dealer = self.df_orders.iloc[order]["InputField2"]
                        # print(f"{dealer} ", end="")
                        if dealer in cc:
                            kcc = cc[dealer]
                            bg = kcc.get("bg", None)
                            fg = kcc.get("fg", None)
                            bd = kcc.get("outline", None)
                            ou = kcc.get("width", None)
                            ft = kcc.get("font", None)

                            bg_h = Colour(bg).brighten(0.15, safe=True).hex_code
                            fg_h = Colour(fg).brighten(0.15, safe=True).hex_code
                            bd_h = Colour(bd).brighten(0.15, safe=True).hex_code
                            ou_h = ou
                            ft_h = ft

                            style_k = ["bg", "fg", "outline", "width", "font"]
                            style_v = [bg, fg, bd, ou, ft]
                            style = dict(zip(style_k, style_v))
                            for k in style_k:
                                if style[k] is None:
                                    del style[k]

                            # print(f"{style=}")
                            self.canvas.itemconfigure(
                                tag,
                                fill=bg,
                                width=ou,
                                outline=bd,
                                activefill=bg_h,
                                activeoutline=bd_h,
                            )
                            for t_tag in t_tags:
                                self.canvas.itemconfigure(
                                    t_tag,
                                    fill=fg,
                                    font=ft,
                                    activefill=fg_h
                                )
                #         else:
                #             print(f"skipped {date_=}, {line_=} NO CC FOR '{dealer=}'")
                #     else:
                #         print(f"skipped {date_=}, {line_=} NO ORDER")
                # else:
                #     print(f"skipped {date_=}, {line_=} NO TD")

    def check_valid_updater(self):
        self.df_valid_updaters = connect(**SQL_VALID_UPDATERS)

        user = utility.get_windows_user(2)
        # use this for testing
        # user = "bwsdomain.local\\cbg"
        self.data["state"]["user_full"] = user
        user_domain, *user_name = user.lower().split("\\")
        if not user_name:
            user_name = user
        self.data["state"]["user_domain"] = user_domain
        self.data["state"]["user_name"] = user_name[0] if isinstance(user_name, (list, tuple)) else user_name
        df = self.df_valid_updaters.loc[self.df_valid_updaters["UserName"].str.lower().str.strip() == user_name[0]]

        # valid_users = [un.lower().strip() for un in self.df_valid_updaters["UserName"].unique() if len(un)]
        if self.data["settings"]["TEST_MODE"].get():
            print(f"{df=}")

        print(f"{user=}, {user_domain=}, {user_name=}", end="")

        if not df.empty:
            print(f" FOUND!")
            # idx = df.index[0]
            # print(f"{df=}, {idx=}")
            df_pds_user = df.iloc[0]
            cc = df_pds_user["ColourCoding"]
            test_mode = df_pds_user["InTestingMode"]
            cc = cc if not pd.isna(cc) else {}
            self.data["settings"]["colour_coding"] = eval(str(cc))
            print(f"INIT TEST MODE {test_mode}")
            self.data["settings"]["TEST_MODE"].set(bool(test_mode))
            return True

        print(f" NOT FOUND")
        return False

    def grid_keys(self) -> tuple[str, str, str, str, str, str, str, str, str]:
        return "row", "column", "rowspan", "columnspan", "ipadx", "ipady", "padx", "pady", "sticky"

    def grid_widgets(self) -> None:
        r, c, rs, cs, ix, iy, x, y, s = self.grid_keys()
        # if self.data["settings"]["TEST_MODE"].get():
        #     self.lbl_testing_mode.grid()
        self.frame_calendar.grid(**{r: 1})
        self.frame_calendar.grid_propagate(False)
        # self.frame_canvas.grid(**{s: "nsew"})
        # self.frame_canvas.grid_propagate(False)
        self.canvas.grid(**{r: 0})
        self.scroll_bar_x.grid(**{r: 1, s: "ew"})
        is_warranty = self.toggle_warranty.value.get() == "Warranty"

        self.frame_canvas.place(
            x=self.data["x_place_frame_canvas"],
            y=self.data["y_place_frame_canvas"],
            width=self.data["w_place_frame_canvas"],
            height=self.data["h_place_frame_canvas"]
        )

        self.frame_multi_combobox.place(
            x=self.data["x_place_frame_multi_combobox"],
            y=self.data["y_place_frame_multi_combobox"]
        )
        self.frame_mc_inner.grid(**{r: 0, c: 0})

        self.frame_info_frame.place(
            x=self.data["x_top_widgets"],
            y=self.data["height_multi_combobox"] + 235
        )

        tm = self.data["settings"]["TEST_MODE"].get()
        if tm:
            self.listbox_history.grid(row=0, column=0, columnspan=1, rowspan=1)
            self.scroll_bar_history.grid(row=0, column=1, columnspan=1, rowspan=1, sticky="ns")
            self.frame_listbox_history.place(
                x=self.data["x_top_widgets"],
                y=self.data["height_multi_combobox"] + 235 + 340
            )

        if is_warranty:
            self.multi_combobox_warranties.grid_widget()
        else:
            self.multi_combobox_orders.grid_widget()
        self.toggle_warranty.grid(**{r: 1, c: 0})

        # goes on top of everything
        self.invisible_canvas.grid(**{r: 0, c: 0, cs: 2, rs: 2, s: "nsew"})

    def scroll_x_calendar(self, *args) -> None:
        # change the canvas_stg xview when the scrollbar is interacted with
        # print(f"scroll_x: {args=}")
        self.canvas.xview(*args)
        self.redraw_legend()

    def on_mousewheel_calendar(self, event) -> None:
        # move the canvas_stg xview when mousewheel scrolled
        self.canvas.xview_scroll(int(-1 * (event.delta / 120)), "units")
        self.redraw_legend()

    def get_current_canvas_view(self) -> tuple[float, float, float, float]:
        x_1, x_2 = self.canvas.xview()
        y_1, y_2 = self.canvas.yview()
        srw = self.data["canvas_width_scroll_region"]
        srh = self.data["canvas_height_scroll_region_stg"]
        x_1 *= srw
        x_2 *= srw
        y_1 *= srh
        y_2 *= srh
        return x_1, y_1, x_2, y_2

    def redraw_legend(self):
        """Ensure that the left legend containing line names is visible after scrolling."""
        tw_legend_lines = self.data["tile_width_legend_lines"]
        th_legend_lines = self.data["tile_height_legend_lines"]
        tw, th = self.data["tile_width"], self.data["tile_height"]
        tw_w, th_w = self.data["tile_width_weekend"], self.data["tile_height_weekend"]
        x_1, y_1, x_2, y_2 = self.get_current_canvas_view()
        # print(f"{x_1=}, {x_2}, {y_1}, {y_2}")
        col_legend = [dat for prod_line, dat in self.tiles["line_legend"].items()]
        # print(f"{col_legend=}")
        # tiles_stg = [dat["tile"] for dat in col_legend]
        home_tile = self.tiles["home"]["tile"]

        if self.data["stg_logo_image"]:
            # move image
            self.canvas.coords(home_tile, x_1 + (tw / 2), y_1 + (th / 2))
        else:
            # move rectangle
            self.canvas.coords(home_tile, x_1, y_1, x_1 + tw, y_1 + th)

        for dat in col_legend:
            tile = dat["tile"]
            bw = float(self.canvas.itemcget(tile, "width"))
            bbox = self.canvas.bbox(tile)
            y_t = bbox[1] + bw
            # print(f"{bbox=}, {x_1=}, {y_1=}, {x_2=}, {y_2=}, {x_1=}, {y_t=}, {x_1 + tw=}, {y_t + th=}")
            # self.canvas_stg.coords(tile, x_1 + (tw / 2), y_t + (th / 2))
            self.canvas.coords(tile, x_1, y_t, x_1 + tw, y_t + th)
            self.canvas.tag_raise(tile)

            for txt in dat.get("texts", []):
                # print(f"{self.canvas_stg.itemcget(txt, 'text')=}")
                self.canvas.coords(txt, x_1 + (tw / 2), y_t + (th / 2))
                self.canvas.tag_raise(txt)

        # print(f"{self.canvas_stg.winfo_viewable()=}")
        # print(f"{self.canvas_stg.xview()=}")

    def get_date_bucket(self, x: int | float) -> pd.Timestamp | None:
        """
        Return the CLOSEST date to a given x position on the calendar
        Assumes the coordinates are absolute to the scroll region and not the viewable area.
        Use tkinter.canvas_stg.canvasx and canvasy methods to convert before passing as params here.
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
        Use tkinter.canvas_stg.canvasx and canvasy methods to convert before passing as params here.
        """
        srh = self.data["canvas_height_scroll_region_stg"]
        lines = self.list_prod_lines
        p = min(y / srh, 0.999)  # prevent index out of bounds
        # include the legend in space calculations, but exclude for indexing
        i = int(p * (len(lines) + 1)) - 1
        # print(f"PLB {y=}, {srh=}, {p=}, {len(lines)=}, {i=}")
        # return lines[i] if i > 0 else lines[0]
        return lines[i] if i >= 0 else None

    def get_date_line_at_x_y(self, x: int | float, y: int | float) -> tuple[pd.Timestamp, str] | tuple[None, None]:
        """
        Get the date and line for a given x and y on the canvas_stg.
        Assumes the coordinates are absolute to the scroll region and not the viewable area.
        Use tkinter.canvas_stg.canvasx and canvasy methods to convert before passing as params here.
        """
        # tile = self.canvas_stg.find_closest(x, y)
        date = self.get_date_bucket(x)
        line = self.get_prod_line_bucket(y)
        return date, line

    def get_tile_at_x_y(self, x: int | float, y: int | float) -> dict:
        """
        Get the tile data for a given x and y on the canvas_stg.
        Assumes the coordinates are absolute to the scroll region and not the viewable area.
        Use tkinter.canvas_stg.canvasx and canvasy methods to convert before passing as params here.
        """
        # tile = self.canvas_stg.find_closest(x, y)
        date, line = self.get_date_line_at_x_y(x, y)
        return self.tiles.get(date, {}).get(line, {})

    def get_tile_bbox(self, date: pd.Timestamp, prod_line: str) -> tuple[float, float, float, float] | None:
        try:
            i_line = self.list_prod_lines.index(prod_line) + 1
        except (IndexError, ValueError):
            i_line = None
        try:
            i_date = self.list_dates.index(date) + 1
        except (IndexError, ValueError):
            i_date = None

        if i_line is None or i_date is None:
            return None

        # return self.calc_grid_cells_stg[i_date][i_line]
        return self.calc_grid_cells[i_line][i_date]

    def select_tile(self, date: pd.Timestamp, prod_line: str, select: bool = True) -> None:
        # print(f"SEL {self.data['settings']['allow_multi_select']=}")
        if not select:
            # self.data["state"]["selected"].clear()
            self.clear_selected_tiles()
        else:
            if not self.data["settings"]["allow_multi_select"]:
                self.select_tile(date, prod_line, False)
            if (date is not None) and (prod_line is not None):
                self.update_info_frame(date, prod_line)
                self.data["state"]["selected"].append((date, prod_line))

    def hover_tile(self, date: pd.Timestamp, prod_line: str) -> None:
        # print(f"HOVER ({date=}, {prod_line=})")
        self.data["state"]["hovered"].append((date, prod_line))

    def drag_tile(self, date: pd.Timestamp, prod_line: str) -> None:
        self.data["state"]["dragged"].append((date, prod_line))

    def delete_tile(self, date_line: tuple[pd.Timestamp, str], from_undo: bool = False) -> None:
        tm = self.data["settings"]["TEST_MODE"].get()
        if tm:
            print(f"DELETE TILE {date_line=}")

        date, line = date_line
        is_warranty = line in self.list_warranty_lines
        order = self.tiles[date][line].get("order", None)
        if order is not None:

            # remove from calendar
            if tm:
                print(f"texts_to_change == {self.tiles[date][line]['texts']=}")
                print(
                    f"texts_to_change == {[self.canvas.itemcget(txt, 'text') for txt in self.tiles[date][line]['texts']]=}")
            for txt in self.tiles[date][line].get("texts", []):
                self.canvas.itemconfigure(txt, text="")
            self.tiles[date][line]["order"] = None

            # add to combobox
            if is_warranty:
                if tm:
                    print(f"{is_warranty=}")
                data = self.df_multi_combobox_data_warranties.iloc[order]
                dat_job = data.get("Job")
                new_row_data = {
                    k: [v]
                    for k, v in zip(
                        self.multi_combobox_warranties.tree_controller.viewable_column_names,
                        [dat_job]
                    )
                }
                if tm:
                    print(
                        f"self.multi_combobox_warranties.tree_controller.viewable_column_names=\n\t{self.multi_combobox_warranties.tree_controller.viewable_column_names}")
                    print(f"{[dat_job]=}")
            else:
                if tm:
                    print(f"{is_warranty=}")
                data = self.df_orders.iloc[order]

                dat_quote = data.get("OrdersV2_SGQuote")
                # print(f"{dat_quote=}, {row['InputField2'].tolist()=}")
                dat_wo = data.get("OrdersV2_WO#")
                dat_sn = data.get("Serial Number#")
                dat_dealer = data.get("InputField2")
                dat_galv = data.get("IsGalv")
                dat_model = data.get("InputField1")
                dat_cust_wo = data.get("Customer WO#")
                # new_row_data = {k: [v] for k, v in zip(self.df_multi_combobox_data_orders_stg.columns,
                if tm:
                    print(
                        f"self.multi_combobox_orders.tree_controller.viewable_column_names=\n\t{self.multi_combobox_orders.tree_controller.viewable_column_names}")
                    print(f"{[dat_quote, dat_wo, dat_model, dat_dealer, dat_sn, dat_cust_wo]=}")
                    # print(f"zip(self.multi_combobox_orders_stg.tree_controller.viewable_column_names  [dat_quote, dat_wo, dat_model, dat_dealer, dat_sn, dat_cust_wo])")
                new_row_data = {
                    k: [v]
                    for k, v in zip(
                        self.multi_combobox_orders.tree_controller.viewable_column_names,
                        [dat_quote, dat_wo, dat_model, dat_dealer, dat_sn, dat_cust_wo]
                    )
                }

            new_df = pd.DataFrame(new_row_data)
            if tm:
                print(f"new_df={new_df}")
            if is_warranty:
                self.multi_combobox_warranties.add_new_item(val=new_df)
            else:
                self.multi_combobox_orders.add_new_item(val=new_df)
            self.df_ids_to_date_line[order] = (None, None)
            if not from_undo:
                # self.data["history"].append(("DELETE", order, date_line))
                hist = list(self.data["history"].get())
                hist.append(("DELETE", order, date_line))
                self.data["history"].set(hist)

    def insert_tile(
            self,
            df_orders_id: int,
            date_line: tuple[pd.Timestamp, str],
            from_undo: bool = False,
            do_animate: None | str = None
    ) -> None:
        tm = self.data["settings"]["TEST_MODE"].get()
        if tm:
            print(f"insert_tile")

        date, line = date_line
        is_warranty = line in self.list_warranty_lines
        if tm:
            print(f"{is_warranty=}")

        if from_undo:
            if is_warranty:
                war_job = self.df_multi_combobox_data_warranties[df_orders_id]["Job"]
            else:
                quote = self.df_orders.iloc[df_orders_id]["OrdersV2_SGQuote"]
        else:
            if is_warranty:
                war_job = self.multi_combobox_warranties.res_tv_entry.get()
            else:
                quote = self.multi_combobox_orders.res_tv_entry.get()
        if isinstance(date, str):
            date = pd.Timestamp(date)
        order_already_exists = self.tiles[date][line].get("order", None)

        if order_already_exists is not None:
            # there is already a tile in this position.
            if is_warranty:
                exist_war_job = self.df_multi_combobox_data_warranties.iloc[order_already_exists]["Job"]
                ans = messagebox.askyesnocancel(
                    title=self.data["title_application_short"],
                    message=f"'{exist_war_job}' already scheduled for {datetime_utility.date_str_format(date)} on '{line}'.\nAre you sure you want to place '{war_job}' here instead?"
                )
                if ans == tkinter.YES:
                    # move existing unit to combobox, then place this new one
                    self.delete_tile(date_line)
                else:
                    # return the dragging tile to the combobox and stop
                    self.clear_master_drag_tile()
                    return
            else:
                exist_quote = self.df_orders.iloc[order_already_exists]["OrdersV2_SGQuote"]
                ans = messagebox.askyesnocancel(
                    title=self.data["title_application_short"],
                    message=f"'{exist_quote}' already scheduled for {datetime_utility.date_str_format(date)} on '{line}'.\nAre you sure you want to place '{quote}' here instead?"
                )
                if ans == tkinter.YES:
                    # move existing unit to combobox, then place this new one
                    self.delete_tile(date_line)
                else:
                    # return the dragging tile to the combobox and stop
                    self.clear_master_drag_tile()
                    return

        bbox = self.get_tile_bbox(date, line)
        # order = self.tiles_stg[date][line].get("order")
        if is_warranty:
            row = self.df_multi_combobox_data_warranties.iloc[df_orders_id]
        else:
            row = self.df_orders.iloc[df_orders_id]
        texts = self.tiles[date][line].get("texts", [])
        drag_texts = self.multi_combobox_drag_tile_texts

        tile_text_colour = self.data["colour_tile_foreground"]
        font = self.data["font_tile"]

        if tm:
            print(f"{df_orders_id=}\n{texts=}\n{row=}\n{type(row)=}\n{bbox=}")

        # assert(isinstance(row, pd.core.frame.DataFrame))
        # row = row.reset_index()
        # row2 = row.iloc[0]
        # print(f"{row2=}\n{type(row2)=}")

        if not texts:
            # create the texts
            if tm:
                print(f"create the texts")
            bbox = self.get_tile_bbox(date, line)

            to_do_texts = [
                self.invisible_canvas.itemcget(txt, "text")
                for txt in self.multi_combobox_drag_tile_texts
            ]
            # if len(to_do_texts) == 1:
            #     if to_do_texts[0] == self.multi_combobox_drag_tile_texts_placeholder:
            #         to_do_texts.clear()

            if tm:
                print(f"{to_do_texts=}")

            texts = [
                self.canvas.create_text(
                    int(bbox[0] + (self.data["tile_width"] * 0.5)),
                    int(bbox[1] + ((k + 1) * self.data["tile_height"] / (1 + len(to_do_texts)))),
                    text=txt,
                    fill=tile_text_colour.hex_code,
                    font=font
                )
                for k, txt, in enumerate(to_do_texts)
            ]

            tw, th = self.data["tile_width"], self.data["tile_height"]
            n_txts = len(texts)
            bw = float(self.canvas.itemcget(self.tiles[date][line]["tile"], "width"))
            y_t = bbox[1] + bw
            for i, txts_ in enumerate(zip(texts, to_do_texts)):
                txt, text = txts_
                self.canvas.coords(txt, bbox[0] + (tw / 2), y_t + ((i + 1) * (th / (n_txts + 1))))
                self.canvas.itemconfigure(txt, text=text)

        else:
            # reconfigure the texts
            if tm:
                print(f"reconfigure the texts")
            # order_id = self.df_orders_stg.loc[self.df_orders_stg["OrdersV2_SGQuote"] == quote].index
            # quote_data = list(self.df_orders_stg.iloc[order_id].iterrows())[0][1]
            # print(f"{quote_data=}")

            # data = row[0]
            if is_warranty:
                mc_vals = [war_job]

            else:
                mc_quote = quote
                # mc_wo = data["OrdersV2_WO#"]
                # mc_model = data["Model No"]
                # mc_dealer = data["InputField2"]
                # mc_galv = data["IsGalv"]
                mc_wo = row["OrdersV2_WO#"]
                mc_model = row["Model No"]
                mc_dealer = row["InputField2"]
                mc_galv = row["IsGalv"]
                mc_vals = [mc_quote, mc_wo, mc_model, mc_dealer, mc_galv]
            for txt, text in zip_longest(texts, mc_vals):
                if text is not None:
                    self.canvas.itemconfigure(txt, text=text)
                else:
                    self.canvas.itemconfigure(txt, state="hidden")

        # df_order_in_mc = self.multi_combobox_orders_stg.tree_controller.df.loc[self.multi_combobox_orders_stg.tree_controller.df["SGQuote"] == quote]
        if is_warranty:
            self.multi_combobox_warranties.delete_item(value=war_job, mode="all")
        else:
            self.multi_combobox_orders.delete_item(value=quote, mode="all")

        if tm:
            print(f"SETTING {date=}, {line=} == {{'order': {df_orders_id}, 'texts': {texts}}}")
        self.df_ids_to_date_line[df_orders_id] = date_line
        self.tiles[date][line].update({
            "order": df_orders_id,
            "texts": texts
        })
        if not from_undo:
            # self.data["history"].append(
            #     ("INSERT", df_orders_id, date_line)
            # )

            hist = list(self.data["history"].get())
            hist.append(("INSERT", df_orders_id, date_line))
            self.data["history"].set(hist)

        self.colour_code(date, line)
        if tm:
            # print(f"\n\tPOST INSERT\n{self.data['history']=}")
            print(f"\n\tPOST INSERT\n{self.data['history'].get()=}")
        self.select_tile(date, line)
        self.update_selected_tiles()
        self.redraw_legend()
        if do_animate is not None:
            self.flash_tile(date_line, mode=do_animate)

    def swap_tiles(
            self,
            date_line_1: tuple[pd.Timestamp, str],
            date_line_2: tuple[pd.Timestamp, str],
            from_undo: bool = False,
            do_animate: None | str = None
    ) -> None:
        tm = self.data["settings"]["TEST_MODE"].get()
        date_1, line_1 = date_line_1
        date_2, line_2 = date_line_2

        is_war_1 = line_1 in self.list_warranty_lines
        is_war_2 = line_2 in self.list_warranty_lines
        if (is_war_1 + is_war_2) % 2 != 0:
            # 1 of these units comes from warranty
            messagebox.showinfo(
                title=self.data["title_application_short"],
                message=f"Cannot swap production units with warranty units"
            )
            self.flash_tile(date_line_2, mode="invalid")
            return

        # TODO undo swap doesnt work

        if tm:
            print(f"SWAP => {date_1=}, {date_2=}\n{type(date_1)=}, {type(date_2)=}\n{line_1=}, {line_2=}")
        if isinstance(date_1, str) and date_1:
            date_1 = pd.Timestamp(date_1)
        if isinstance(date_2, str) and date_2:
            date_2 = pd.Timestamp(date_2)

        if (date_1 != date_2) or (line_1 != line_2):
            # assert the tile being place in a NEW position, not the same one.
            if tm:
                print(f"New position")

            bbox_1, bbox_2 = self.get_tile_bbox(date_1, line_1), self.get_tile_bbox(date_2, line_2)
            order_1, order_2 = self.tiles[date_1][line_1].get("order"), self.tiles[date_2][line_2].get("order")
            texts_1, texts_2 = self.tiles[date_1][line_1].get("texts"), self.tiles[date_2][line_2].get("texts")
            tile_1, tile_2 = self.tiles[date_1][line_1].get("tile"), self.tiles[date_2][line_2].get("tile")
            if tm:
                print(f"{texts_1=}, {texts_2=}")

            # swap df_ids_to_date_line_stg
            if order_1 is not None:
                self.df_ids_to_date_line[order_1] = date_line_2
            if order_2 is not None:
                self.df_ids_to_date_line[order_2] = date_line_1

            # swap df_orders_stg indexes
            self.tiles[date_1][line_1]["order"] = order_2
            self.tiles[date_2][line_2]["order"] = order_1

            # swap texts for rendering
            self.tiles[date_1][line_1]["texts"] = texts_2
            self.tiles[date_2][line_2]["texts"] = texts_1

            # swap positions on canvas_stg
            self.canvas.coords(tile_1, *bbox_2)
            self.canvas.coords(tile_2, *bbox_1)

            # swap the tile ids
            self.tiles[date_1][line_1]["tile"] = tile_2
            self.tiles[date_2][line_2]["tile"] = tile_1

            # animate success
            if do_animate is not None:
                self.flash_tile(date_line_1, mode=do_animate)
                self.flash_tile(date_line_2, mode=do_animate)

            if not from_undo:
                if order_1 or order_2:
                    # one of these tiles_stg is an order, record in the history and allow undos.
                    # self.data["history"].append(
                    #     ("SWAP", date_line_1, date_line_2)
                    # )

                    hist = list(self.data["history"].get())
                    hist.append(("SWAP", date_line_1, date_line_2))
                    self.data["history"].set(hist)

            if tm:
                print(
                    f"AFTER SWAP\n\tself.tiles_stg[{date_1}][{line_1}]={self.tiles[date_1][line_1]}\n\tself.tiles_stg[{date_2}][{line_2}]={self.tiles[date_2][line_2]}")

    def on_right_click_calendar(self, event) -> None:
        tm = self.data["settings"]["TEST_MODE"].get()
        if tm:
            print(f"on_right_click_calendar")
        ex, ey = event.x, event.y
        ex, ey = self.canvas.canvasx(ex), self.canvas.canvasy(ey)
        date, line = self.get_date_line_at_x_y(ex, ey)
        order = self.tiles[date][line].get("order", None)
        if tm:
            print(f"{date=}, {line=}, {order=}")
        if (date is not None) and (line is not None) and (order is not None):
            # delete tile
            if tm:
                print(f"DELETE {date=}, {line=}")
            self.delete_tile((date, line))
            # self.insert_tile(dfad)
        self.clear_selected_tiles()

    def on_left_click_calendar(self, event):
        tm = self.data["settings"]["TEST_MODE"].get()
        if tm:
            print(f"on_left_click_calendar_ {event=}")
        ht = self.data["state"]["hovered"]
        st = self.data["state"]["selected"]
        dt = self.data["state"]["dragged"]
        if ht:
            ht_0 = ht[0]
            h_date, h_line = ht_0
            if st:
                st_0 = st[0]
                s_date, s_line = st_0
                if (s_date != h_date) or (s_line != h_line):
                    # hovering and clicked a different tile
                    if tm:
                        print(f"DIFF TILE")
                else:
                    if tm:
                        print(f"SAME TILE")
            else:
                if tm:
                    print(f'NOTHING SELECTED')
        else:
            if tm:
                print(f"NOTHING HOVERED")

    def on_left_click_release_calendar(self, event) -> None:
        tm = self.data["settings"]["TEST_MODE"].get()
        dt = self.data["state"]["dragged"]
        x, y = event.x, event.y
        o_x, o_y = self.canvas.canvasx(x), self.canvas.canvasy(y)
        date, line = self.get_date_bucket(o_x), self.get_prod_line_bucket(o_y)
        # tile_data = self.get_tile_at_x_y(o_x, o_y)
        if tm:
            print(f"on_left_click_calendar, {dt=} {date=}, {line=}")

        if date is None or line is None:
            # print(f"NONE => {date=}, {line=}, {dt=}")
            # return dt to its original position.
            self.clear_drag_tiles()
            return

        state = event.state
        shift_held = state & 0x1
        control_held = state & 0x4
        selected = []

        # TODO this does not support multi select
        drag_date, drag_line = dt[0] if dt else (None, None)
        # drag_idx = self.tiles_stg.get(drag_date, {}).get(drag_line, {}).get("order", None)
        # drag_tile = self.tiles_stg[dt[0][0]][dt[0][1]]["tile"]
        orders = []

        if dt:
            if tm:
                print(f"DRAG")
            # something is being dragged, set it down
            if date.weekday() < 5:
                # weekday placement
                stat_idx = self.tiles.get(date, {}).get(line, {}).get("order", None)
                stat_tile = self.tiles.get(date, {}).get(line, {}).get("tile", None)
                stat_bbox = self.get_tile_bbox(date, line)
                drag_bbox = self.get_tile_bbox(drag_date, drag_line)
                stat_texts = self.tiles[date][line].get("texts", [])
                drag_texts = self.tiles[drag_date][drag_line].get("texts", [])
                self.select_tile(date, line)  # swap selected tile for info frame change
                self.swap_tiles((drag_date, drag_line), (date, line), do_animate="valid")

                self.drag_tile(date, line)  # add the stationary tile for drag re-adjustment
            else:
                # weekend placement
                self.flash_tile((date, line), mode="invalid_we")

            self.clear_drag_tiles()
            self.clear_selected_tiles()

        else:
            if tm:
                print(f"NOT DRAG")
            if date is None:
                # clicked the prod line select the whole line
                # TODO
                pass
            elif line is None:
                # clicked the date select the entire column
                # selected = [(date, line_) for line_ in self.list_prod_lines_stg]
                # TODO turned this off since multiselect is not supported.
                pass
            elif date is None and line is None:
                return
            else:
                selected = [(date, line)]

            if selected:
                if not shift_held:
                    if tm:
                        print(f"CLEARING SELECTED")
                    self.clear_selected_tiles()

                for sel in selected:
                    self.select_tile(*sel)
                    s_date, s_line = sel
                    o_id = self.tiles[s_date][s_line].get('order', None)
                    is_warranty = s_line in self.list_warranty_lines
                    if is_warranty:
                        war_job = self.df_multi_combobox_data_warranties[o_id]["Job"]
                        if tm:
                            print(f"\tSel: <{sel=}>, <{o_id=}>, <{war_job=}>")
                    else:
                        quote = self.df_orders.iloc[o_id]["OrdersV2_SGQuote"] if (o_id is not None) else None
                        if tm:
                            print(f"\tSel: <{sel=}>, <{o_id=}>, <{quote=}>")
                    # self.data["state"]["selected"].append(sel)
                    if o_id:
                        orders.append(sel)
                self.update_selected_tiles()
                if tm:
                    print(f"END SELECTED = {self.data['state']['selected']=}")

        if not orders:
            self.clear_info_frame()

    def on_left_click_root_canvas(self, event) -> None:
        tm = self.data["settings"]["TEST_MODE"].get()
        if tm:
            print(f"on_left_click_root_canvas {datetime.datetime.now():%Y-%m-%d %H:%M:%S}")

    def drag_treeview_warranty_entry(self, event):
        tm = self.data["settings"]["TEST_MODE"].get()
        if tm:
            print(f"drag_treeview_warranty_entry {event=}")
        self.drag_treeview_entry(event)

    def release_treeview_warranty_entry(self, event):
        tm = self.data["settings"]["TEST_MODE"].get()
        if tm:
            print(f"release_treeview_warranty_entry {event=}")
        self.release_treeview_entry(event)

    def drag_treeview_entry(self, event):
        tm = self.data["settings"]["TEST_MODE"].get()
        if tm:
            print(f"drag_treeview_entry, {event=}")
        is_warranty = self.toggle_warranty.value.get() == "Warranty"
        if tm:
            print(f"\t{is_warranty=}")

        treeview = self.multi_combobox_orders.tree_treeview
        vcn = self.multi_combobox_orders.tree_controller.viewable_column_names
        tv_dt = self.tv_multi_combobox_drag_tile.get()
        # self.multi_combobox_canvas_drag_tile.grid_forget()
        tw, th = self.data["tile_width"], self.data["tile_height"]
        h_multi_combobox_toggle = self.toggle_warranty.height
        e_x, e_y = event.x, event.y
        e_x1, e_y1 = self.invisible_canvas.canvasx(e_x), self.invisible_canvas.canvasy(e_y)
        bbf = self.multi_combobox_orders.bbox()
        mcy = self.multi_combobox_orders.winfo_y()
        hmct = self.toggle_warranty.height
        offy = 20
        if tm:
            print(f"{h_multi_combobox_toggle=}, {e_x=}, {e_y=}\n{e_x1=}, {e_y1=}\n\t{bbf=}\n\t{mcy=}")

        # print(f"DRAG TREEVIEW ENTRY, {tv_dt=}")

        region1 = treeview.identify("region", event.x, event.y)
        column = treeview.identify_column(event.x)
        if tv_dt or column:
            # col_idx1 = vcn.index(name)
            # col_idx2 = (col_idx1 + 1) if col_idx1 < len(vcn) else (len(vcn) - 1)
            # width2 = treeview.column(f"#{col_idx2}").get("width_canvas", 0)
            if tv_dt or (region1 not in ("separator", "nothing")):
                # dragging something not the column headers or nothing
                # bbox = (event.x, event.y, event.x + 100, event.y + 100)
                # bbox = (
                #     event.x - (tw / 2),
                #     event.y - (th / 2),
                #     event.x + (tw / 2),
                #     event.y + (th / 2)
                # )
                bbox = [
                    event.x,
                    event.y,
                    event.x + tw,
                    event.y + th
                ]
                if not is_warranty:
                    bbox[0] -= (tw / 2)
                    bbox[2] -= (tw / 2)

                # bbox = (
                #     event.x - (tw / 2),
                #     event.y + mcy + hmct + offy - (th / 2),
                #     event.x + (tw / 2),
                #     event.y + mcy + hmct + offy + (th / 2)
                # )
                if tm:
                    print(
                        f"{event.x=}, {event.y=}\n{self.invisible_canvas.canvasx(event.x)=}, {self.invisible_canvas.canvasy(event.y)=}")
                    print(f"{region1=}, {column=}, {bbox=}")
                self.invisible_canvas.coords(
                    self.multi_combobox_drag_tile,
                    *bbox
                )

                self.invisible_canvas.itemconfigure(self.multi_combobox_drag_tile, state="normal")
                self.tv_multi_combobox_drag_tile.set(True)
                # bring MC drag tile to the top
                self.invisible_canvas.tag_raise(self.multi_combobox_drag_tile)

                bw = float(self.invisible_canvas.itemcget(self.multi_combobox_drag_tile, "width"))
                y_t = bbox[1] + bw
                out_texts = []
                txts = self.multi_combobox_drag_tile_texts
                if is_warranty:
                    war_job = self.multi_combobox_warranties.res_tv_entry.get()
                    new_texts = [war_job]
                else:
                    quote = self.multi_combobox_orders.res_tv_entry.get()
                    order_id = self.df_orders.loc[self.df_orders["OrdersV2_SGQuote"] == quote].index
                    quote_data = list(self.df_orders.iloc[order_id].iterrows())[0][1]
                    # print(f"{quote_data=}")

                    mc_quote = quote
                    mc_wo = quote_data["OrdersV2_WO#"]
                    mc_model = quote_data["Model No"]
                    mc_dealer = quote_data["InputField2"]
                    mc_galv = quote_data["IsGalv"]

                    new_texts = [
                        mc_quote,
                        mc_wo,
                        mc_model,
                        mc_dealer,
                        mc_galv
                    ]

                if tm:
                    print(f"{txts=}, {new_texts=}")

                # move the tile
                # print(f"{new_texts=}")
                n_txts = max([len(lst) for lst in [txts, new_texts]])
                for i, txts_ in enumerate(zip_longest(txts, new_texts)):
                    txt, text = txts_
                    if txt is None:
                        out_texts.append(self.invisible_canvas.create_text(
                            bbox[0], bbox[1], text=text
                        ))
                        txt = out_texts[-1]
                    else:
                        out_texts.append(txt)

                    if self.invisible_canvas.itemcget(txt, "state") == "hidden":
                        self.invisible_canvas.itemconfigure(txt, state="normal")
                    # bbox_t = ()
                    # self.invisible_canvas.coords(text, *bbox_t)
                    self.invisible_canvas.coords(txt, bbox[0] + (tw / 2), y_t + ((i + 1) * (th / (n_txts + 1))))
                    self.invisible_canvas.itemconfigure(txt, text=text)
                    self.invisible_canvas.tag_raise(txt)
                self.multi_combobox_drag_tile_texts = out_texts

        self.invisible_canvas.coords(self.dot, e_x-10, e_y-10, e_x+10, e_y+10)

    def release_treeview_entry(self, event):
        tm = self.data["settings"]["TEST_MODE"].get()
        if tm:
            print(f"release_treeview_entry")
        # self.multi_combobox_canvas_drag_tile.grid_forget()
        is_warranty = self.toggle_warranty.value.get() == "Warranty"
        if tm:
            print(f"\t{is_warranty=}")
        # self.multi_combobox_orders_stg.grid()
        self.tv_multi_combobox_drag_tile.set(False)
        self.invisible_canvas.itemconfigure(self.multi_combobox_drag_tile, state="hidden")
        e_x, e_y = event.x, event.y
        tw, th = self.data["tile_width"], self.data["tile_height"]

        x_fc = self.data.get("x_place_frame_canvas", 0)
        y_fc = self.data.get("y_place_frame_canvas", 0)
        w_fc = self.data.get("w_place_frame_canvas", 1)
        h_fc = self.data.get("h_place_frame_canvas", 1)

        x_mc = self.data.get("x_place_frame_multi_combobox", 0)
        y_mc = self.data.get("y_place_frame_multi_combobox", 0)

        x_if = self.data.get("x_place_frame_info_frame", 0)
        y_if = self.data.get("y_place_frame_info_frame", 0)

        # bbox_canvas = self.canvas_stg.bbox()
        # bbox_if = self.info_frame_stg.bbox()
        # bbox_mc = self.multi_combobox_orders_stg.bbox()
        bbox_canvas = list(self.frame_canvas.bbox(self.canvas))
        bbox_if = list(self.frame_info_frame.bbox(self.info_frame))
        bbox_mc = list(self.frame_multi_combobox.bbox(self.multi_combobox_orders))

        bbox_canvas[0] += x_fc
        bbox_canvas[1] += y_fc
        bbox_canvas[2] += x_fc
        bbox_canvas[3] += y_fc

        bbox_if[0] += x_if
        bbox_if[1] += y_if
        bbox_if[2] += x_if
        bbox_if[3] += y_if

        bbox_mc[0] += x_mc
        bbox_mc[1] += y_mc
        bbox_mc[2] += x_mc
        bbox_mc[3] += y_mc

        if not is_warranty:
            pass
            # e_y += th
        else:
            e_x += (tw / 2)
        #
        e_y += (th / 2)

        self.invisible_canvas.coords(self.dot, e_x-10, e_y-10, e_x+10, e_y+10)

        if tm:
            print(f"\n\t{e_x=}, {e_y=}\n\t{x_fc=}, {y_fc=}\n\t{bbox_canvas=}\n\t{bbox_if=}\n\t{bbox_mc=}")
        if (bbox_canvas[0] <= e_x <= bbox_canvas[2]) and (bbox_canvas[1] <= e_y <= bbox_canvas[3]):
            date_line = self.get_date_line_at_x_y(self.canvas.canvasx(e_x - x_fc), self.canvas.canvasy(e_y - y_fc))
            # date_line = self.get_date_line_at_x_y(self.canvas_stg.canvasx(e_x), self.canvas_stg.canvasy(e_y))
            if date_line:
                date, line = date_line
                if date.weekday() < 5:
                    # dropped in calendar and on a weekday
                    # order_id = self.multi_combobox_orders_stg.res_tv_entry.get()

                    if is_warranty:

                        if line not in self.list_warranty_lines:
                            # return the dragging tile to the combobox and stop
                            messagebox.showinfo(
                                title=self.data["title_application_short"],
                                message=f"Warranty units can only be placed in warranty lines:\n\t" + "\n\t".join(
                                    self.list_warranty_lines)
                            )
                            self.flash_tile(date_line, mode="invalid")
                            self.clear_master_drag_tile()
                            return

                        war_job = self.multi_combobox_warranties.res_tv_entry.get()
                        war_job_id = self.df_multi_combobox_data_warranties.loc[
                            self.df_multi_combobox_data_warranties["Job"] == war_job].index[0]

                        if tm:
                            # print(f"{quote=}, {order_id_1=}, {order_id_2=}, {order_id=}")
                            print(f"{war_job=}, {war_job_id=}")
                            print(f"dropped in calendar {date_line=}")
                        self.insert_tile(war_job_id, date_line, do_animate="valid")
                        try:
                            self.multi_combobox_warranties.delete_item(value=war_job)
                        except ValueError as ve:
                            # quote not found in multi-combobox
                            pass
                        self.multi_combobox_warranties.res_tv_entry.set("")
                    else:

                        if line in self.list_warranty_lines:
                            # return the dragging tile to the combobox and stop
                            prod_lines = [l for l in self.list_prod_lines]
                            for l in self.list_warranty_lines:
                                prod_lines.remove(l)
                            messagebox.showinfo(
                                title=self.data["title_application_short"],
                                message=f"Production units can only be placed in production lines:\n\t" + "\n\t".join(
                                    prod_lines)
                            )
                            self.flash_tile(date_line, mode="invalid")
                            self.clear_master_drag_tile()
                            return

                        quote = self.multi_combobox_orders.res_tv_entry.get()
                        # order_id_1 = self.df_orders_stg.loc[self.df_orders_stg["OrdersV2_SGQuote"] == quote].index
                        # order_id_2 = self.df_multi_combobox_data_orders_stg.loc[self.df_multi_combobox_data_orders_stg["SGQuote"] == quote].index
                        # order_id_2 = self.df_multi_combobox_data_orders_stg.loc[self.df_multi_combobox_data_orders_stg["SGQuote"] == quote].index
                        # order_id = order_id_2
                        order_id = self.df_orders.loc[self.df_orders["OrdersV2_SGQuote"] == quote].index[0]
                        if tm:
                            # print(f"{quote=}, {order_id_1=}, {order_id_2=}, {order_id=}")
                            print(f"{quote=}, {order_id=}")
                            print(f"dropped in calendar {date_line=}")
                        self.insert_tile(order_id, date_line, do_animate="valid")
                        try:
                            self.multi_combobox_orders.delete_item(value=quote)
                        except ValueError as ve:
                            # quote not found in multi-combobox
                            pass

                        self.multi_combobox_orders.res_tv_entry.set("")
                else:
                    # weekend placement not supported
                    self.flash_tile(date_line, mode="invalid_we")
        elif (bbox_if[0] <= e_x <= bbox_if[2]) and (bbox_if[1] <= e_y <= bbox_if[3]):
            # dropped in info frame
            if tm:
                print(f"dropped in info frame")
        elif (bbox_mc[0] <= e_x <= bbox_mc[2]) and (bbox_mc[1] <= e_y <= bbox_mc[3]):
            # dropped in calendar
            if tm:
                print(f"dropped in multi combobox")
        else:
            if tm:
                print(f"dropped on background")

        self.clear_master_drag_tile()

    def flash_tile(self, date_line: tuple[pd.Timestamp, str], mode: str = "invalid", do_move: bool = True):

        # before = self.tv_entry_unit_scroll_search.get()
        # before = self.scroll_bar_x.get()

        tm = self.data["settings"]["TEST_MODE"].get()
        if tm:
            print(f"FLASH TILE {date_line=}, {mode=} ", end="")
        date, line = date_line
        if isinstance(date, str) and date:
            date = pd.Timestamp(date)
        tile_data = self.tiles[date][line]
        tile = tile_data["tile"]

        # movement work

        bba = self.canvas.bbox("all")
        bbaw = (bba[2] - bba[0])
        cw = self.data["canvas_width"]
        t_bbox = self.canvas.bbox(tile)
        x, y = int((t_bbox[0] - (cw / 2)) + ((t_bbox[2] - t_bbox[0]) / 2)), int(
            t_bbox[1] + ((t_bbox[3] - t_bbox[1]) / 2))
        x /= bbaw
        need_to_move = (bba[0] <= x <= bba[2])
        if tm:
            print(f"{need_to_move=}")
        # if do_move and need_to_move:
        if do_move:
            self.canvas.xview_moveto(x)
            self.redraw_legend()

        # flash work

        bg_f, fg_f, outline_f = None, None, None
        bg, fg, outline = \
            self.data["colour_tile_background"], \
                self.data["colour_tile_foreground"], \
                self.data["colour_tile_outline"]
        match mode:
            case "valid":
                bg_f = Colour("#A2F9A3")
                fg_f = Colour("#024003")
                outline_f = Colour("#024003")
            case "invalid":
                bg_f = Colour("#791213")
                fg_f = Colour("#400203")
                outline_f = Colour("#400203")
            case "invalid_we":
                # invalid placement, tile cant be placed on the weekend
                bg, fg, outline = \
                    self.data["colour_tile_background_weekend"], \
                        self.data["colour_tile_foreground_weekend"], \
                        self.data["colour_tile_outline_weekend"]

                bg_f = Colour("#791213")
                fg_f = Colour("#400203")
                outline_f = Colour("#400203")
            case "attention":
                bg_f = Colour("#9293e9")
                fg_f = Colour("#020340")
                outline_f = Colour("#020340")
            case _:
                raise ValueError(f"Unknown mode '{mode}'")

        n_flashes = 9
        s_per_flash = 75
        ttl_anim_time = (n_flashes + 1) * s_per_flash
        bg_g = [gradient(i, n_flashes, bg_f, bg, rgb=False) for i in range(n_flashes + 1)]
        fg_g = [gradient(i, n_flashes, fg_f, fg, rgb=False) for i in range(n_flashes + 1)]
        outline_g = [gradient(i, n_flashes, outline_f, outline, rgb=False) for i in range(n_flashes + 1)]
        for i, grads in enumerate(zip(bg_g, fg_g, outline_g)):
            g_bg, g_fg, g_ol = grads
            self.after((i + 1) * s_per_flash,
                       lambda tile_=tile, g_bg_=g_bg, g_ol_=g_ol:
                       self.canvas.itemconfigure(tile_, fill=g_bg_, outline=g_ol_))

        # after animation, check if the tile is selected, then restore.
        if (sel := self.data["state"].get("selected", None)) is not None:
            # print(f"{sel=}, {type(sel)=}")
            for s_date, s_line in sel:
                # s_date, s_line = sel
                self.after(
                    ttl_anim_time,
                    lambda s_date_=s_date, s_line_=s_line:
                    self.select_tile(s_date_, s_line_)
                )
            self.after(
                ttl_anim_time,
                lambda: self.update_selected_tiles()
            )

    def bind_treeview_to_canvas(self):
        tm = self.data["settings"]["TEST_MODE"].get()
        old_bind = self.multi_combobox_orders.tree_controller.binding_treeview_b1_motion
        self.multi_combobox_orders.tree_controller.treeview.bind("<B1-Motion>", self.drag_treeview_entry)
        self.multi_combobox_orders.tree_controller.treeview.bind("<ButtonRelease-1>", self.release_treeview_entry)

        if tm:
            print(f"{old_bind=}")

        old_bind_war = self.multi_combobox_warranties.tree_controller.binding_treeview_b1_motion
        self.multi_combobox_warranties.tree_controller.treeview.bind("<B1-Motion>", self.drag_treeview_warranty_entry)
        self.multi_combobox_warranties.tree_controller.treeview.bind("<ButtonRelease-1>",
                                                                     self.release_treeview_warranty_entry)

    def on_left_click_motion_calendar(self, event) -> None:
        ht = self.data["state"]["hovered"]
        st = self.data["state"]["selected"]
        dt = self.data["state"]["dragged"]
        x, y = event.x, event.y
        o_x, o_y = self.canvas.canvasx(x), self.canvas.canvasy(y)
        x_1, y_1, x_2, y_2 = self.get_current_canvas_view()
        tm = self.data["settings"]["TEST_MODE"].get()
        if tm:
            print(f"{o_x=}, {o_y=}, {event.delta=}, {event=}")
            print(f"{ht=}, {st=}, {dt=}")
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
        tw_w, th_w = self.data["tile_width_weekend"], self.data["tile_height_weekend"]
        d_x, d_y = o_x - p_x, o_y - p_y
        for date, line in (dt + st):
            if date.weekday() < 5:
                # only weekdays are allowed to move
                td = self.tiles[date][line]
                tile = td["tile"]
                bw = float(self.canvas.itemcget(tile, "width"))
                bbox = self.canvas.bbox(tile)
                if tm:
                    print(f"\n{self.canvas.type(tile)=}")
                    print(f"{tile=}, {bbox=}")
                t_x, t_y = bbox[0] + bw, bbox[1] + bw
                if tm:
                    print(f"{date=}, {line=}, {d_x=}, {d_y=}, {t_x=}, {t_y=}")
                # self.canvas_stg.move(tile, t_x + d_x, t_y + d_y)
                self.canvas.coords(tile, o_x - (tw / 2), o_y - (th / 2), o_x + (tw / 2), o_y + (th / 2))
                self.canvas.tag_raise(tile)
                y_t = bbox[1] + bw

                txts = self.tiles[date][line].get("texts", [])
                for i, txt in enumerate(txts):
                    # self.canvas_stg.coords(txt, bbox[0] + (tw / 2), bbox[1] + (th / 2))
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
        # tile = self.canvas_stg.find_closest(ox, oy)
        date = self.get_date_bucket(o_x)
        line = self.get_prod_line_bucket(o_y)
        if date is None or line is None:
            self.clear_hover_tiles()
            return
        # self.canvas_stg.itemcget()
        # print(f"{x=}, {y=}, {ox=}, {oy=}, {tile=}, {date=}, {line=}, {event=}")
        # self.data["state"]["hovered"].clear()

        # don't overwrite the selected and dragging tiles_stg with new hovers
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

        ab_w = self.data["colour_tile_background_weekend_hover"]
        af_w = self.data["colour_tile_foreground_weekend_hover"]
        ao_w = self.data["colour_tile_outline_weekend_hover"]
        font_w = self.data["font_tile_weekend_hover"]

        for date, prod_line in ht:
            is_weekend = date.weekday() >= 5
            tile = self.tiles[date][prod_line].get("tile", None)
            texts = self.tiles[date][prod_line].get("texts", [])
            if tile:
                self.canvas.itemconfigure(
                    tile,
                    fill=(ab_w if is_weekend else ab).hex_code,
                    outline=(ao_w if is_weekend else ao).hex_code,
                    width=ow
                )
            for text in texts:
                self.canvas.itemconfigure(
                    text,
                    fill=(af_w if is_weekend else af).hex_code,
                    font=(font_w if is_weekend else font)
                )

            self.colour_code(date, prod_line)

    def clear_hover_tiles(self) -> None:
        ht = self.data["state"]["hovered"]
        st = self.data["state"]["selected"]
        dt = self.data["state"]["dragged"]
        b = self.data["colour_tile_background"]
        f = self.data["colour_tile_foreground"]
        o = self.data["colour_tile_outline"]
        font = self.data["font_tile"]

        b_w = self.data["colour_tile_background_weekend"]
        f_w = self.data["colour_tile_foreground_weekend"]
        o_w = self.data["colour_tile_outline_weekend"]
        font_w = self.data["font_tile_weekend"]

        ow = self.data["width_tile_outline"]
        # print(f"{(st + dt)=}")

        # ensure that the selected and dragging tiles_stg are not blanked
        sub_ht = [key for key in ht if key not in (st + dt)]

        for date, prod_line in sub_ht:
            is_weekend = date.weekday() >= 5
            tile = self.tiles[date][prod_line].get("tile", None)
            texts = self.tiles[date][prod_line].get("texts", [])
            if tile:
                self.canvas.itemconfigure(
                    tile,
                    fill=(b_w if is_weekend else b).hex_code,
                    outline=(o_w if is_weekend else o).hex_code,
                    width=ow
                )
            for text in texts:
                # print(f"CONFIG: {self.canvas_stg.itemcget(text, 'text')=}")
                self.canvas.itemconfigure(
                    text,
                    fill=(f_w if is_weekend else f).hex_code,
                    font=(font_w if is_weekend else font)
                )

            self.colour_code(date, prod_line)
        self.data["state"]["hovered"].clear()

    def clear_master_drag_tile(self):
        self.invisible_canvas.itemconfigure(self.multi_combobox_drag_tile, state="hidden")
        for txt in self.multi_combobox_drag_tile_texts:
            self.invisible_canvas.itemconfigure(txt, state="hidden")

    def update_selected_tiles(self) -> None:
        st = self.data["state"]["selected"]
        ab = self.data["colour_tile_background_selected"]
        af = self.data["colour_tile_foreground_selected"]
        ao = self.data["colour_tile_outline_selected"]
        font = self.data["font_tile_selected"]

        ab_w = self.data["colour_tile_background_weekend_selected"]
        af_w = self.data["colour_tile_foreground_weekend_selected"]
        ao_w = self.data["colour_tile_outline_weekend_selected"]
        font_w = self.data["font_tile_weekend_selected"]

        ow = self.data["width_tile_outline_selected"]
        tm = self.data["settings"]["TEST_MODE"].get()
        if tm:
            print(f"{st=}")
        for date, prod_line in st:
            is_weekend = date.weekday() >= 5
            tile = self.tiles[date][prod_line].get("tile", None)
            texts = self.tiles[date][prod_line].get("texts", [])
            if tile:
                self.canvas.itemconfigure(
                    tile,
                    fill=(ab_w if is_weekend else ab).hex_code,
                    outline=(ao_w if is_weekend else ao).hex_code,
                    width=ow
                )
            for text in texts:
                self.canvas.itemconfigure(
                    text,
                    fill=(af_w if is_weekend else af).hex_code,
                    font=(font_w if is_weekend else font)
                )

            self.colour_code(date, prod_line)

    def clear_selected_tiles(self) -> None:
        st = self.data["state"]["selected"]
        b = self.data["colour_tile_background"]
        f = self.data["colour_tile_foreground"]
        o = self.data["colour_tile_outline"]
        font = self.data["font_tile"]

        b_w = self.data["colour_tile_background_weekend"]
        f_w = self.data["colour_tile_foreground_weekend"]
        o_w = self.data["colour_tile_outline_weekend"]
        font_w = self.data["font_tile_weekend"]

        ow = self.data["width_tile_outline"]
        for date, prod_line in st:
            is_weekend = date.weekday() >= 5
            tile = self.tiles[date][prod_line].get("tile", None)
            texts = self.tiles[date][prod_line].get("texts", [])
            if tile:
                self.canvas.itemconfigure(
                    tile,
                    fill=(b_w if is_weekend else b).hex_code,
                    outline=(o_w if is_weekend else o).hex_code,
                    width=ow
                )
            for text in texts:
                # print(f"CONFIG: {self.canvas_stg.itemcget(text, 'text')=}")
                self.canvas.itemconfigure(
                    text,
                    fill=(f_w if is_weekend else f).hex_code,
                    font=(font_w if is_weekend else font)
                )
            self.colour_code(date, prod_line)
        self.data["state"]["selected"].clear()

    def clear_drag_tiles(self):
        tm = self.data["settings"]["TEST_MODE"].get()
        if tm:
            print(f"RESETTING DRAG TILES")
        tw, th = self.data["tile_width"], self.data["tile_height"]
        tw_w, th_w = self.data["tile_width_weekend"], self.data["tile_height_weekend"]
        for date, line in self.data["state"]["dragged"]:
            bbox = self.get_tile_bbox(date, line)
            tile = self.tiles[date][line]["tile"]
            # print(f"{date=}, {line=}, {tile=}, {bbox=}")
            self.canvas.coords(tile, *bbox)

            texts = self.tiles[date][line].get("texts", [])
            for i, txt in enumerate(texts):
                tx, ty = int(bbox[0] + (tw * 0.5)), int(bbox[1] + ((i + 1) * th / (1 + len(texts))))
                self.canvas.coords(txt, tx, ty)
            self.colour_code(date, line)

        self.data["state"]["dragged"].clear()

    def undo(self, event):
        tm = self.data["settings"]["TEST_MODE"].get()
        if tm:
            # print(f"undo {self.data['history']=}")
            print(f"undo {self.data['history'].get()=}")
        # if self.data["history"]:
        if self.data["history"].get():
            # action, *data = self.data["history"].pop(-1)
            action, *data = list(self.data["history"].get()).pop(-1)
            match action:
                case "SWAP":
                    keys_1, keys_2 = data
                    self.swap_tiles(keys_2, keys_1, from_undo=True, do_animate="attention")
                case "INSERT":
                    order, date_line = data
                    date_, line_ = date_line
                    self.delete_tile(date_line, from_undo=True)
                case "DELETE":
                    order, date_line = data
                    date, line = date_line
                    self.insert_tile(order, date_line, from_undo=True, do_animate="attention")
                case _:
                    raise ValueError("Cant undo")

    def submit_combobox_entry(self, event):
        tm = self.data["settings"]["TEST_MODE"].get()
        if tm:
            print(f"submit_combobox_entry")

        quote = self.multi_combobox_orders.res_tv_entry.get().lower()
        n_mc_records = len(self.multi_combobox_orders.tree_treeview.get_children())

        if n_mc_records:
            messagebox.showinfo(
                title=self.data["title_application_short"],
                message=f"Please keep entering characters. There are still options in the combo-box below."
            )
            return

        if len(str(quote)):
            select_cols = [
                "OrdersV2_SGQuote",
                "OrdersV2_WO#",
                "Model No",
                "InputField2"
            ]
            df = self.df_orders[
                self.df_orders[select_cols].apply(
                    lambda x: x.astype(str).str.contains(quote, case=False)
                ).any(axis=1)
            ]
            n_rows = df.shape[0]
            if not df.empty:
                if tm:
                    print(f"QUOTE FOUND IN CALENDAR")
                if n_rows > 1:
                    # more than one possible entry found
                    # pass
                    self.choose_from_choices(df)
            else:
                messagebox.showinfo(
                    title=self.data["title_application_short"],
                    message=f"Could not find anything matching '{quote}'."
                )

    def multi_combobox_entry_update(self, *args):
        tm = self.data["settings"]["TEST_MODE"].get()
        quote = self.multi_combobox_orders.res_tv_entry.get().lower()
        lq = len(quote)
        n_mc_records = len(self.multi_combobox_orders.tree_treeview.get_children())
        if tm:
            print(f"multi_combobox_entry_update {quote=}, {n_mc_records=}")
        if n_mc_records > 0:
            # search text in multi-combobox
            pass
        else:
            select_cols = [
                "OrdersV2_SGQuote",
                "OrdersV2_WO#",
                "Model No",
                "InputField2"
            ]
            df = self.df_orders[
                self.df_orders[select_cols].apply(
                    lambda x: x.astype(str).str.contains(quote, case=False)
                ).any(axis=1)
            ]
            if tm:
                print(f"PARTIAL MATCH SEARCH\n{df=}")
            n_rows = df.shape[0]
            if not df.empty:
                if tm:
                    print(f"QUOTE FOUND IN CALENDAR")
                # if n_rows_stg > 1:
                #     # more than one possible entry found
                #     # pass
                #     self.choose_from_choices(df)
                # else:
                if n_rows == 1:
                    # exactly one match found
                    idx = df.index[0]
                    date, line = self.df_ids_to_date_line[idx]
                    if tm:
                        print(f"{idx=}, {date=}, {line=}")
                    if (date is not None) and (line is not None) and (not pd.isna(date)) and (not pd.isna(line)):
                        self.select_tile(date, line)
                        self.update_selected_tiles()
                        self.flash_tile((date, line), mode="attention")

    def click_tl_tile(self, event, idx, tag):
        # select this tile, and flash it on the calendar
        tm = self.data["settings"]["TEST_MODE"].get()
        date, line = self.df_ids_to_date_line[idx]
        if tm:
            print(f"{event=}, {idx=}, {tag=}")
            print(f"{date=}, {line=}")
        self.tl_data["tl_dataframe_choice"].destroy()
        self.multi_combobox_orders.res_tv_entry.set(self.df_orders.iloc[idx]["OrdersV2_SGQuote"])
        self.flash_tile((date, line), mode="attention")

    def motion_tl_tile(self, idx, tag, tidx=None, ttag=None):
        # a tile is being hovered, change its colour.
        for tile in self.tl_data["tiles_stg"]:
            # print(f"{tile=}, {tag=}, {ttag=}")
            if tile == tag:
                if ttag is not None:
                    for txt in self.tl_data["texts"][tidx]:
                        self.tl_data["canvas_tl"].itemconfigure(txt, fill=self.tl_data["fg"].brightened(0.25).hex_code)

                self.tl_data["canvas_tl"].itemconfigure(tile, fill=self.tl_data["bg"].brightened(0.25).hex_code)
            else:
                # reset this tile's colour
                if ttag is not None:
                    for txt in self.tl_data["texts"][tidx]:
                        self.tl_data["canvas_tl"].itemconfigure(txt, fill=self.tl_data["fg"].hex_code)
                self.tl_data["canvas_tl"].itemconfigure(tile, fill=self.tl_data["bg"].hex_code)

    def choose_from_choices(self, df: pd.DataFrame) -> None:
        tm = self.data["settings"]["TEST_MODE"].get()

        self.tl_data["bg"] = Colour("#006723")
        self.tl_data["fg"] = Colour("#101010")
        self.tl_data["tiles_stg"] = []
        self.tl_data["texts"] = []

        if tm:
            print(f"CHOOSE FROM CHOICES\n{df=}")
        if not df.empty:
            self.tl_data["tl_dataframe_choice"] = tkinter.Toplevel(self)
            self.tl_data["frame_tl"] = tkinter.Frame(self.tl_data["tl_dataframe_choice"])
            n_choices = df.shape[0]
            max_choices_per_col = 4
            choices_per_col = min(n_choices, max_choices_per_col)
            n_rows = (n_choices // max_choices_per_col) + 1
            n_cols = choices_per_col

            if (n_rows < (n_cols / 2)) and (n_choices < (n_rows * n_cols)):
                # too many tiles_stg in 1 row, even it out
                n_cols -= 1
                n_rows = (n_choices // n_cols) + 1

            tw, th = self.data["tile_width"], self.data["tile_height"]
            x0, y0 = 0, 0
            xm, ym = 10, 10
            m = 2

            w = int((tw + m + m) * n_cols)
            h = int((th + m + m) * n_rows)

            self.tl_data["canvas_tl"] = tkinter.Canvas(
                self.tl_data["frame_tl"],
                width=w,
                height=h,
                bg="#987811"
            )

            gc = utility.grid_cells(
                w - 10,
                choices_per_col,
                h - 10,
                n_rows,
                x_pad=5,
                y_pad=5,
                x_0=5,
                y_0=5,
                r_type=list
            )

            idxs = df.index.tolist()
            if tm:
                print(f"AA {n_rows=}, {n_cols=}, {choices_per_col=}, {self.tl_data['tiles_stg']=}")
                print(f"{idxs=}")
            idx = 0
            for i in range(n_rows):
                for j in range(n_cols):
                    if tm:
                        print(f">> {idx=}, {idxs[idx]=}")
                    # quote_data = df.iloc[idxs[idx]]
                    quote_data = df.iloc[idx]
                    if tm:
                        print(f"{i=}, {j=}", end="")
                    # x0_ = x0 + (i * (tw + m))
                    # y0_ = y0 + (j * (th + m))
                    # x1_ = x0 + ((i + 1) * (tw + m))
                    # y1_ = y0 + ((j + 1) * (th + m))
                    x0_, y0_, x1_, y1_, = gc[i][j]
                    if tm:
                        print(f"{w=}, {x0_=}, {y0_=}, {x1_=}, {y1_=}")
                    self.tl_data["tiles_stg"].append(
                        self.draw_rect(
                            (
                                x0_,
                                y0_,
                                x1_,
                                y1_,
                            ),
                            fill=self.tl_data["bg"].hex_code,
                            # ,
                            # activefill=fc.brightened(0.25).hex_code
                            parent=self.tl_data["canvas_tl"]
                        )
                    )

                    mc_quote = str(quote_data["OrdersV2_SGQuote"])
                    mc_wo = str(quote_data["OrdersV2_WO#"])
                    mc_model = str(quote_data["Model No"])
                    mc_dealer = str(quote_data["InputField2"])
                    mc_galv = str(quote_data["IsGalv"])
                    texts_to_do = [v for v in [mc_quote, mc_wo, mc_model, mc_dealer, mc_galv] if len(v)]
                    if tm:
                        print(f"{texts_to_do=}")
                    self.tl_data["texts"].append([
                        self.tl_data["canvas_tl"].create_text(
                            x0_ + (tw / 2),
                            y0_ + ym + ((k + 1) * (tw / (1 + len(texts_to_do)))),
                            text=txt,
                            fill=self.tl_data["fg"].hex_code
                        )
                        for k, txt in enumerate(texts_to_do)])

                    tag = self.tl_data["tiles_stg"][-1]
                    tidx = len(self.tl_data["texts"]) - 1
                    self.tl_data["canvas_tl"].tag_bind(
                        tag,
                        "<Button-1>",
                        lambda event_, idx_=idxs[idx], tag_=tag: self.click_tl_tile(event_, idx_, tag_)
                    )
                    self.tl_data["canvas_tl"].tag_bind(
                        tag,
                        "<Motion>",
                        lambda idx_=idxs[idx], tag_=tag: self.motion_tl_tile(idx_, tag_)
                    )
                    for txt in self.tl_data["texts"][-1]:
                        self.tl_data["canvas_tl"].tag_bind(
                            txt,
                            "<Motion>",
                            lambda idx_=idxs[idx], tag_=tag, tidx_=tidx, ttag_=txt:
                            self.motion_tl_tile(idx_, tag_, tidx_, ttag_)
                        )
                        self.tl_data["canvas_tl"].tag_bind(
                            txt,
                            "<Button-1>",
                            lambda event_, idx_=idxs[idx], tag_=tag: self.click_tl_tile(event_, idx_, tag_)
                        )

                    idx += 1
                    if idx >= n_choices:
                        break

            if tm:
                print(f"BB {n_rows=}, {n_cols=}, {choices_per_col=}, {self.tl_data['tiles_stg']=}")

            self.tl_data["frame_tl"].pack()
            self.tl_data["canvas_tl"].pack()

            if tm:
                print(f"{w=}, {h=}")

            tl_geom = tkinter_utility.calc_geometry_tl(w, h, largest=True, rtype=dict)
            self.tl_data["tl_dataframe_choice"].title(self.data["title_application_full"])
            self.tl_data["tl_dataframe_choice"].geometry(tl_geom["geometry"])
            self.tl_data["tl_dataframe_choice"].grab_set()
            self.wait_window(self.tl_data["tl_dataframe_choice"])

    def update_info_frame(self, date, prod_line):
        tm = self.data["settings"]["TEST_MODE"].get()
        if (date is not None) and (prod_line is not None):
            date_tile_data = self.tiles.get(date)
            tile, order = None, None
            if date_tile_data:
                tile = date_tile_data[prod_line]
                order = date_tile_data[prod_line].get("order")
            if tm:
                print(f"{tile=}")
            if order is not None:
                series = self.df_orders.iloc[order]
                dat_1 = {
                    "KD": date,
                    "KL": prod_line,
                    "US Sale": series["US Sale"],
                    "SGQuote": series["OrdersV2_SGQuote"],
                    "WO#": series["OrdersV2_WO#"],
                    "Model No": series["Model No"],
                    "Dealer": series["InputField2"],
                    "Serial#": series["Serial Number"],
                    "Customer WO#": series["Customer WO#"],
                    "Sched Finish": date,
                    "Sched Line": prod_line
                }
                if tm:
                    print(f"{dat_1=}")
                for k in self.data["info_frame_columns_stg"]:
                    v = dat_1.get(k, f"'{k}'=?")
                    self.info_frame.change_value(k, v)
        else:
            self.info_frame.change_value("SGQuote", "?")

    def clear_info_frame(self):
        for k in self.data["info_frame_columns_stg"]:
            self.info_frame.change_value(k, "")

    def draw_rect(
            self,
            bbox: tuple[int, int, int, int] | list[int, int, int, int],
            fill: None | str | Colour = None,
            activefill: None | str | Colour = None,
            outline: None | str | Colour = None,
            activeoutline: None | str | Colour = None,
            width: None | int = None,
            parent: None | tkinter.Canvas = None,
            default_all: bool = False
    ):
        if parent is None:
            parent = self.canvas

        kwarg_keys = ["fill", "activefill", "outline", "activeoutline", "width"]
        kwarg_vals = [
            fill.hex_code if isinstance(fill, Colour) else fill,
            activefill.hex_code if isinstance(activefill, Colour) else activefill,
            outline.hex_code if isinstance(outline, Colour) else outline,
            activeoutline.hex_code if isinstance(activeoutline, Colour) else activeoutline,
            width
        ]

        args = {}
        if default_all:
            args["fill"] = self.data["colour_tile_background"].hex_code
            args["activefill"] = self.data["colour_tile_background_hover"].hex_code
            args["outline"] = self.data["colour_tile_background"].hex_code
            args["activeoutline"] = self.data["colour_tile_background_hover"].hex_code
            args["width"] = self.data["width_tile_outline"]
        else:
            for k, v in zip(kwarg_keys, kwarg_vals):
                args[k] = v

        for k in kwarg_keys:
            if args[k] is None:
                del args[k]

        # print(f"{args=}")

        return parent.create_rectangle(*bbox, **args)

    def click_mb_colour_code(self, event=None):
        tm = self.data["settings"]["TEST_MODE"].get()

        # open colour code TopLevel.
        known_dealers = [d for d in self.df_orders["InputField2"].unique().tolist() if len(str(d))]
        known_dealers.sort()
        known_colour_codes = self.data.get("settings", {}).get("colour_coding", {})
        n_dealers = len(known_dealers)
        if tm:
            print(f"{known_dealers=}, {known_colour_codes=}")
        self.tl_data["tl_colour_code"] = tkinter.Toplevel(self)
        self.tl_data["tl_colour_code"].title(self.data["title_application_full"])

        self.tl_data["cc_changed"] = tkinter.BooleanVar(self, value=False)

        w, h = 1400, 800
        tl_geom = tkinter_utility.calc_geometry_tl(w, h, largest=True, rtype=dict, parent=self)
        self.tl_data["tl_colour_code"].geometry(tl_geom["geometry"])

        bg_cc_main = Colour("#459001")
        bg_cc_vc = Colour("#051001")
        bg_cc_btn = Colour("#E0E0FF")
        fg_cc_btn = Colour("#051001")
        bg_cc_btn_hover = bg_cc_btn.brightened(0.25)
        fg_cc_btn_hover = fg_cc_btn.brightened(0.25)

        n_dealers_per_row = 14
        n_cols = (n_dealers // n_dealers_per_row) + 1
        tw, th, m = 350, 60, 15
        total_width_dealers = n_cols * (tw + m)
        total_height_dealers = n_dealers_per_row * (th + m)
        grid_cells = utility.grid_cells(
            total_width_dealers,
            n_cols,
            total_height_dealers,
            n_dealers_per_row,
            x_pad=m,
            y_pad=m,
            r_type=list
        )
        self.tl_data["tl_canvas"] = tkinter.Canvas(
            self.tl_data["tl_colour_code"],
            width=total_width_dealers + (2 * m),
            height=total_height_dealers + (2 * m),
            bg=bg_cc_main.hex_code
        )
        self.tl_data["tl_frame"] = tkinter.Frame(
            self.tl_data["tl_colour_code"],
            width=total_width_dealers + (2 * m),
            height=total_height_dealers + (2 * m),
            bg=bg_cc_main.darkened(0.25).hex_code
        )

        def click_bg(event=None):
            if tm:
                print(f"click_bg")
            curr_colour = self.tl_data["tl_cc_view_canvas"].itemcget(
                self.tl_data["tl_cc_vc_edit_tile"],
                "fill"
            )
            res_colour = ask_colour(
                curr_colour=curr_colour,
                parent=self.tl_data["tl_colour_code"],
                title="Select a Background colour"
            )
            res_rgb, res_hex = res_colour
            res_c = Colour(res_hex)
            if tm:
                print(f"{res_colour=}, {res_c=}")
            self.tl_data["tl_cc_view_canvas"].itemconfigure(
                self.tl_data["tl_cc_vc_edit_tile"],
                fill=res_c.hex_code
            )

        def click_fg(event=None):
            if tm:
                print(f"click_fg")
            curr_colour = self.tl_data["tl_cc_view_canvas"].itemcget(
                self.tl_data["tl_cc_vc_edit_text"],
                "fill"
            )
            res_colour = ask_colour(
                curr_colour=curr_colour,
                parent=self.tl_data["tl_colour_code"],
                title="Select a Foreground colour"
            )
            res_rgb, res_hex = res_colour
            if res_hex.strip() != '':
                res_c = Colour(res_hex)
                if tm:
                    print(f"{res_colour=}, {res_c=}")
                self.tl_data["tl_cc_view_canvas"].itemconfigure(
                    self.tl_data["tl_cc_vc_edit_text"],
                    fill=res_c.hex_code
                )

        def click_border(event=None):
            if tm:
                print(f"click_border")
            curr_colour = self.tl_data["tl_cc_view_canvas"].itemcget(
                self.tl_data["tl_cc_vc_edit_tile"],
                "outline"
            )
            res_colour = ask_colour(
                curr_colour=curr_colour,
                parent=self.tl_data["tl_colour_code"],
                title="Select a Border colour"
            )
            res_rgb, res_hex = res_colour
            res_c = Colour(res_hex)
            if tm:
                print(f"{res_colour=}, {res_c=}")
            self.tl_data["tl_cc_view_canvas"].itemconfigure(
                self.tl_data["tl_cc_vc_edit_tile"],
                outline=res_c.hex_code
            )

        def ask_colour(parent, title, curr_colour):
            alpha = False
            self.tl_data["tl_col"] = ColorPicker(parent, curr_colour, alpha, title)
            tl_geom_cc = tkinter_utility.calc_geometry_tl(
                0.22, 0.35, parent=self, rtype=dict
            )
            self.tl_data["tl_col"].geometry(tl_geom_cc["geometry"])

            self.tl_data["tl_col"].grab_set()
            self.tl_data["tl_col"].protocol("WM_DELETE_WINDOW", on_closing_cc_colour)
            self.tl_data["tl_colour_code"].wait_window(self.tl_data["tl_col"])

            res = self.tl_data["tl_col"].get_color()
            if res:
                return res[0], res[2]
            else:
                return None, None

        def click_font_save(event=None):
            if tm:
                print(f"click_font_save")
            font = self.tl_data["tl_font_select_frame"].font
            if font:
                font_name_font_size, font_obj = font
                if font_name_font_size is None:
                    font_name_font_size = self.data["default_font"]
                font_name, font_size, *rest = font_name_font_size
                font_size_ = max(self.data["settings"]["min_font_size_tile"],
                                 min(font_size, self.data["settings"]["max_font_size_tile"]))
                # print(f"1 {font_obj=}")
                if font_size != font_size_:
                    font_obj = (font_name, font_size_)
                # print(f"2 {font_size=}, {font_size_=}, {font_obj=}")
                self.tl_data["tl_cc_view_canvas"].itemconfigure(
                    self.tl_data["tl_cc_vc_edit_text"],
                    font=font_obj
                )
            # self.tl_data["tl_font_choice"].destroy()
            on_closing_cc_font()

        def click_font_cancel(event=None):
            if tm:
                print(f"click_font_cancel")
            # self.tl_data["tl_font_choice"].destroy()
            on_closing_cc_font()

        def update_font_choice(event=None):
            if tm:
                print(f"update_font_choice, {event=}")
            font = self.tl_data["tl_font_select_frame"].font
            if tm:
                print(f"CHOSEN {font=}")
            if font:
                font_name_font_size, font_obj = font
                if font_name_font_size is None:
                    font_name_font_size = self.data["default_font"]
                font_name, font_size, *rest = font_name_font_size
                font_size_ = max(self.data["settings"]["min_font_size_tile"],
                                 min(font_size, self.data["settings"]["max_font_size_tile"]))
                # print(f"1 {font_obj=}")
                if font_size != font_size_:
                    font_obj = (font_name, font_size_)
                # print(f"2 {font_size=}, {font_size_=}, {font_obj=}")
                self.tl_data["tl_font_label_choice"][1].configure(font=font_obj)

        def clear_vc_edit_tile():
            self.tl_data["tl_cc_view_canvas"].itemconfigure(
                self.tl_data["tl_cc_vc_edit_tile"],
                state="hidden"
            )
            self.tl_data["tl_cc_view_canvas"].itemconfigure(
                self.tl_data["tl_cc_vc_edit_text"],
                text=f""
            )
            self.tl_data["tl_cc_frame_btn_bar"].grid_forget()

        def on_closing_cc_colour(event=None):
            self.tl_data["tl_col"].destroy()
            self.tl_data["tl_colour_code"].grab_set()
            self.wait_window(self.tl_data["tl_colour_code"])

        def on_closing_cc_font(event=None):
            self.tl_data["tl_font_choice"].destroy()
            self.tl_data["tl_colour_code"].grab_set()
            self.wait_window(self.tl_data["tl_colour_code"])

        def click_font(event=None):
            if tm:
                print(f"click_font")
            curr_font = self.tl_data["tl_cc_view_canvas"].itemcget(
                self.tl_data["tl_cc_vc_edit_text"],
                "font"
            )
            self.tl_data["tl_font_choice"] = tkinter.Toplevel(self.tl_data["tl_colour_code"])
            tl_geom_fc = tkinter_utility.calc_geometry_tl(
                0.2, 0.12, parent=self, rtype=dict
            )
            self.tl_data["tl_font_choice"].geometry(tl_geom_fc["geometry"])
            self.tl_data["tl_font_label_choice"] = tkinter_utility.label_factory(
                self.tl_data["tl_font_choice"],
                tv_label=f"Sample Text"
            )
            self.tl_data["tl_font_select_frame"] = FontSelectFrame(
                self.tl_data["tl_font_choice"],
                callback=update_font_choice
            )

            self.tl_data["tl_fc_btn_cancel"] = tkinter_utility.button_factory(
                self.tl_data["tl_font_choice"],
                tv_btn=f"Cancel",
                command=click_font_cancel,
                kwargs_btn={
                    "bg": bg_cc_btn.hex_code,
                    "fg": fg_cc_btn.hex_code,
                    "activebackground": bg_cc_btn_hover.hex_code,
                    "activeforeground": fg_cc_btn_hover.hex_code,
                }
            )
            self.tl_data["tl_fc_btn_save"] = tkinter_utility.button_factory(
                self.tl_data["tl_font_choice"],
                tv_btn=f"Save",
                command=click_font_save,
                kwargs_btn={
                    "bg": bg_cc_btn.hex_code,
                    "fg": fg_cc_btn.hex_code,
                    "activebackground": bg_cc_btn_hover.hex_code,
                    "activeforeground": fg_cc_btn_hover.hex_code,
                }
            )

            self.tl_data["tl_font_label_choice"][1].grid(row=0, column=0, columnspan=2, rowspan=1, padx=5, pady=5)
            self.tl_data["tl_font_select_frame"].grid(row=1, column=0, columnspan=2, rowspan=1, sticky="snew", padx=5,
                                                      pady=5)
            self.tl_data["tl_fc_btn_cancel"][1].grid(row=2, column=0, columnspan=1, rowspan=1, padx=5, pady=5)
            self.tl_data["tl_fc_btn_save"][1].grid(row=2, column=1, columnspan=1, rowspan=1, padx=5, pady=5)
            self.tl_data["tl_font_choice"].grab_set()
            self.tl_data["tl_font_choice"].protocol("WM_DELETE_WINDOW", on_closing_cc_font)
            self.tl_data["tl_colour_code"].wait_window(self.tl_data["tl_font_choice"])
            res_font = None, None
            if res_font[0]:
                # res_rgb, res_hex = res_font
                # res_c = Colour(res_hex)
                self.tl_data["tl_cc_view_canvas"].itemconfigure(
                    self.tl_data["tl_cc_vc_edit_text"],
                    font=res_font
                )

        def click_dealer_tile(event, dealer_idx):
            clear_vc_edit_tile()

            visible = self.tl_data["tl_cc_view_canvas"].itemcget(
                self.tl_data["tl_cc_vc_edit_tile"],
                "state"
            )
            if visible != "normal":
                self.tl_data["tl_cc_view_canvas"].itemconfigure(
                    self.tl_data["tl_cc_vc_edit_tile"],
                    state="normal"
                )
                self.tl_data["tl_cc_frame_btn_bar"].grid(row=3, column=0, columnspan=2, rowspan=1)

            if tm:
                print(f"click_dealer_tile", end="")
            can_opts = self.tl_data["tl_canvas"]
            can_vc = self.tl_data["tl_cc_view_canvas"]
            dealer = known_dealers[dealer_idx]
            if tm:
                print(f" {dealer=}")
            bbox_vc = self.tl_data["tl_colour_code"].bbox(can_opts)
            if tm:
                print(f"{bbox_vc=}")
            tag = opt_tags_dealers[dealer_idx]["tile"]
            t_tag = opt_tags_dealers[dealer_idx]["text"]

            cv_tag = self.tl_data["tl_cc_vc_edit_tile"]
            cv_t_tag = self.tl_data["tl_cc_vc_edit_text"]

            bg = can_opts.itemcget(tag, "fill")
            fg = can_opts.itemcget(t_tag, "fill")
            bd = can_opts.itemcget(tag, "outline")
            ou = can_opts.itemcget(tag, "width")
            ft = can_opts.itemcget(t_tag, "font")
            if tm:
                print(f"{tag=}, {t_tag=}, {bg=}, {fg=}, {bd=}, {ou=}")

            can_vc.itemconfigure(
                cv_t_tag,
                text=dealer,
                fill=fg,
                font=ft
            )

            can_vc.itemconfigure(
                cv_tag,
                fill=bg,
                outline=bd,
                width=ou
            )

        def quit_cc():
            self.tl_data["tl_colour_code"].destroy()
            self.grab_set()

        def save_changes():
            cc = self.data.get("settings", {}).get("colour_coding", {})
            cc.update(known_colour_codes)
            self.data["settings"]["colour_coding"] = cc
            if tm:
                print(f"{self.data['settings']['colour_coding']=}")
            self.save_colour_coding()
            messagebox.showinfo(
                title=self.data["title_application_short"],
                message=f"Changes applied successfully."
            )

        def click_cancel(event=None):
            clear_vc_edit_tile()

        def click_default(event=None):
            if tm:
                print(f"click_default")
            can_opts = self.tl_data["tl_canvas"]
            can_vc = self.tl_data["tl_cc_view_canvas"]
            cv_tag = self.tl_data["tl_cc_vc_edit_tile"]
            cv_t_tag = self.tl_data["tl_cc_vc_edit_text"]
            dealer = can_vc.itemcget(cv_t_tag, "text")

            if dealer.strip():
                dealer_idx = known_dealers.index(dealer)

                tag = opt_tags_dealers[dealer_idx]["tile"]
                t_tag = opt_tags_dealers[dealer_idx]["text"]

                bg = self.data["colour_tile_background"].hex_code
                fg = self.data["colour_tile_foreground"].hex_code
                bd = self.data["colour_tile_outline"].hex_code
                ou = self.data["width_tile_outline"]
                ft = self.data["font_tile"]

                can_opts.itemconfigure(
                    tag,
                    fill=bg,
                    outline=bd,
                    width=ou
                )

                can_opts.itemconfigure(
                    t_tag,
                    fill=fg,
                    font=ft
                )

                clear_vc_edit_tile()
                self.tl_data["cc_changed"].set(True)

        def click_save(event=None):
            if tm:
                print(f"click_save")
            can_opts = self.tl_data["tl_canvas"]
            can_vc = self.tl_data["tl_cc_view_canvas"]

            cv_tag = self.tl_data["tl_cc_vc_edit_tile"]
            cv_t_tag = self.tl_data["tl_cc_vc_edit_text"]

            dealer = can_vc.itemcget(cv_t_tag, "text")
            if tm:
                print(f"{dealer=} ", end="")
            if dealer:
                dealer_idx = known_dealers.index(dealer)

                tag = opt_tags_dealers[dealer_idx]["tile"]
                t_tag = opt_tags_dealers[dealer_idx]["text"]
                if tm:
                    print(f"{dealer_idx=}, {tag=}, {t_tag=}")
                    # print(f"{can_opts.get_children()=}")

                bg = can_vc.itemcget(cv_tag, "fill")
                fg = can_vc.itemcget(cv_t_tag, "fill")
                bd = can_vc.itemcget(cv_tag, "outline")
                ou = int(float(can_vc.itemcget(cv_tag, "width")))
                ft = can_vc.itemcget(cv_t_tag, "font")

                can_opts.itemconfigure(
                    tag,
                    fill=bg,
                    outline=bd,
                    width=ou
                )

                can_opts.itemconfigure(
                    t_tag,
                    fill=fg,
                    font=ft
                )
                # self.data
                known_colour_codes[dealer] = {
                    "bg": bg,
                    "fg": fg,
                    "outline": bd,
                    "width": ou,
                    "font": ft
                }
                if tm:
                    print(f"{known_colour_codes=}")
                clear_vc_edit_tile()
                self.tl_data["cc_changed"].set(True)

        def on_closing_cc():
            if tm:
                print(f"on_closing_cc")
            changes = self.tl_data["cc_changed"].get()
            if tm:
                print(f"\t{changes}")
            if changes:
                ans = messagebox.askyesnocancel(
                    title=self.data["title_application_short"],
                    message=f"Would you like to save your changes?"
                )
                if ans == tkinter.YES:
                    # save changes
                    save_changes()
                else:
                    # quit without saving
                    pass
            quit_cc()

        def click_apply():
            if tm:
                print(f"click_apply")
            changes = self.tl_data["cc_changed"].get()

            can_vc = self.tl_data["tl_cc_view_canvas"]
            cv_t_tag = self.tl_data["tl_cc_vc_edit_text"]
            dealer = can_vc.itemcget(cv_t_tag, "text")
            if dealer.strip():
                # a tile is in the edit window now
                ans = messagebox.askyesnocancel(
                    title=self.data["title_application_short"],
                    message=f"Save changes for '{dealer}'?"
                )
                if ans == tkinter.YES:
                    click_save()
                changes = True

            if tm:
                print(f"\t{changes}")
            if changes:
                save_changes()
            else:
                messagebox.showinfo(
                    title=self.data["title_application_short"],
                    message=f"No changes to apply."
                )

        def click_go_back():
            if tm:
                print(f"click_go_back")
            changes = self.tl_data["cc_changed"].get()
            if tm:
                print(f"\t{changes}")
            if changes:
                ans = messagebox.askyesnocancel(
                    title=self.data["title_application_short"],
                    message=f"Would you like to save your changes?"
                )
                if ans == tkinter.YES:
                    # save changes
                    save_changes()
                else:
                    # quit without saving
                    pass
            quit_cc()

        def click_app_theme():
            print(f"click_app_theme")
            self.tl_cc_app = tkinter.Toplevel(self)
            self.tl_cc_app.geometry(tkinter_utility.calc_geometry_tl(900, 600, parent=self))

            # calendar row legend row and column
            tv_lbl, lbl = tkinter_utility.label_factory(
                self.tl_cc_app,
                tv_label="Coming Soon"
            )
            lbl.pack()

            self.tl_cc_app.protocol("WM_DELETE_WINDOW", self.quit_cc_app)
            self.tl_cc_app.grab_set()
            self.wait_window(self.tl_cc_app)

            # print(f"{self.tl_data['tl_cc_btn_app'][0].get()=}")
            # text_btn = self.tl_data["tl_cc_btn_app"][0].get()
            #
            # v_texts = ("App Theme", "Dealers")
            #
            # if text_btn == v_texts[0]:
            #     # go to dealers
            #     dealer_opt_tag_state = "hidden"
            # else:
            #     # go to app theme
            #     dealer_opt_tag_state = "normal"
            #
            # self.tl_data["tl_cc_btn_app"][0].set(v_texts[(v_texts.index(text_btn) + 1) % 2])
            #
            # for i in opt_tags_dealers:
            #     # tag = opt_tags_dealers[idx]["tile"]
            #     # t_tag = opt_tags_dealers[idx]["text"]
            #     for k in ("tile", "text"):
            #         self.tl_data["tl_canvas"].itemconfigure(
            #             opt_tags_dealers[i][k],
            #             state=dealer_opt_tag_state
            #         )

        idx = 0
        opt_tags_dealers = {}
        opt_tags_app = {}
        t_template = ["tile", "text"]
        for i, gc_row in enumerate(grid_cells):
            for j, gc in enumerate(gc_row):
                idx = ((i * len(gc_row)) + j)
                if tm:
                    print(f"{i=}, {gc=}")

                dealer = known_dealers[idx]
                k_dealer = known_colour_codes.get(dealer, {})
                k_bg = k_dealer.get("bg", self.data["colour_tile_background"].hex_code)
                k_fg = k_dealer.get("fg", self.data["colour_tile_foreground"].hex_code)
                k_bd = k_dealer.get("outline", self.data["colour_tile_outline"].hex_code)
                k_ou = k_dealer.get("width", self.data["width_tile_outline"])
                k_ft = k_dealer.get("font", self.data["font_tile"])

                tag = self.draw_rect(
                    gc,
                    fill=k_bg,
                    outline=k_bd,
                    width=k_ou,
                    parent=self.tl_data["tl_canvas"]
                )
                t_tag = self.tl_data["tl_canvas"].create_text(
                    # # int(gc[0] + (gc[2] / 2)),
                    # # int(gc[1] + (gc[3] / 2)),
                    # gc[0],
                    # gc[1],
                    int(gc[0] + (tw / 2)),
                    int(gc[1] + (th / 2)),
                    font=k_ft,
                    fill=k_fg,
                    text=f"{dealer}"
                )
                opt_tags_dealers[idx] = {}
                opt_tags_dealers[idx]["tile"] = tag
                opt_tags_dealers[idx]["text"] = t_tag
                self.tl_data["tl_canvas"].tag_bind(
                    tag,
                    "<Button-1>",
                    lambda event_=None, d_idx=idx:
                    click_dealer_tile(event_, d_idx)
                )
                self.tl_data["tl_canvas"].tag_bind(
                    t_tag,
                    "<Button-1>",
                    lambda event_=None, d_idx=idx:
                    click_dealer_tile(event_, d_idx)
                )
                if tm:
                    print(f"{dealer=}, {idx=}, {tag=}, {t_tag=}")
                if (idx + 1) >= n_dealers:
                    break
            if (idx + 1) >= n_dealers:
                break

        self.tl_data["tl_cc_view_canvas"] = tkinter.Canvas(
            self.tl_data["tl_frame"],
            width=int(total_width_dealers * 0.75),
            height=int(total_height_dealers * 0.12),
            bg=bg_cc_main.hex_code
        )

        x0_vc_et, y0_vc_et = 25, 25
        w_vc_et, h_vc_et = 500, 60
        self.tl_data["tl_cc_vc_edit_tile"] = self.draw_rect(
            (x0_vc_et, y0_vc_et, x0_vc_et + w_vc_et, y0_vc_et + h_vc_et),
            parent=self.tl_data["tl_cc_view_canvas"]
        )
        self.tl_data["tl_cc_vc_edit_text"] = self.tl_data["tl_cc_view_canvas"].create_text(
            x0_vc_et + (w_vc_et / 2),
            y0_vc_et + (h_vc_et / 2),
            text=f" "
        )

        kwargs_btn = {
            "bg": bg_cc_btn.hex_code,
            "fg": fg_cc_btn.hex_code,
            "activebackground": bg_cc_btn_hover.hex_code,
            "activeforeground": fg_cc_btn_hover.hex_code,
            "width": 12
        }
        btn_data = [
            ("tl_cc_btn_bg", "tl_frame", "BG", click_bg),
            ("tl_cc_btn_fg", "tl_frame", "FG", click_fg),
            ("tl_cc_btn_border", "tl_frame", "BD", click_border),
            ("tl_cc_btn_font", "tl_frame", "FONT", click_font),

            ("tl_cc_btn_cancel", "tl_cc_frame_btn_bar", "Cancel", click_cancel),
            ("tl_cc_btn_default", "tl_cc_frame_btn_bar", "Default", click_default),
            ("tl_cc_btn_save", "tl_cc_frame_btn_bar", "Save", click_save),

            ("tl_cc_btn_go_back", "tl_frame", "Go Back", click_go_back),
            ("tl_cc_btn_apply", "tl_frame", "Apply", click_apply),

            ("tl_cc_btn_app", "tl_frame", "App Theme", click_app_theme)
        ]
        self.tl_data["tl_cc_frame_btn_bar"] = tkinter.Frame(
            self.tl_data["tl_frame"],
            background=bg_cc_main.hex_code
        )

        for btn_key, parent_frame, btn_text, callback in btn_data:
            self.tl_data[btn_key] = tkinter_utility.button_factory(
                self.tl_data[parent_frame],
                tv_btn=btn_text,
                command=callback,
                kwargs_btn={k: v for k, v in kwargs_btn.items()}
            )

        # self.tl_data["tl_colour_code"]
        self.tl_data["tl_canvas"].grid(row=0, column=0, rowspan=3, sticky="ns")
        self.tl_data["tl_frame"].grid(row=0, column=1, rowspan=3, sticky="ns")

        # self.tl_data["tl_frame"]
        self.tl_data["tl_cc_view_canvas"].grid(row=0, column=0, columnspan=2, rowspan=1)
        self.tl_data["tl_cc_btn_bg"][1].grid(row=1, column=0, columnspan=1, rowspan=1, padx=12, pady=12)
        self.tl_data["tl_cc_btn_fg"][1].grid(row=1, column=1, columnspan=1, rowspan=1, padx=12, pady=12)
        self.tl_data["tl_cc_btn_border"][1].grid(row=2, column=0, columnspan=1, rowspan=1, padx=12, pady=12)
        self.tl_data["tl_cc_btn_font"][1].grid(row=2, column=1, columnspan=1, rowspan=1, padx=12, pady=12)
        self.tl_data["tl_cc_frame_btn_bar"].grid(row=3, column=0, columnspan=2, rowspan=1, padx=12, pady=12)
        self.tl_data["tl_cc_btn_go_back"][1].grid(row=4, column=0, columnspan=1, rowspan=1, padx=12, pady=12)
        self.tl_data["tl_cc_btn_apply"][1].grid(row=4, column=1, columnspan=1, rowspan=1, padx=12, pady=12)
        self.tl_data["tl_cc_btn_app"][1].grid(row=5, column=0, columnspan=1, rowspan=1, padx=12, pady=12)

        # self.tl_data["tl_cc_frame_btn_bar"]
        self.tl_data["tl_cc_btn_cancel"][1].grid(row=0, column=0, columnspan=1, rowspan=1, padx=12, pady=12)
        self.tl_data["tl_cc_btn_default"][1].grid(row=0, column=1, columnspan=1, rowspan=1, padx=12, pady=12)
        self.tl_data["tl_cc_btn_save"][1].grid(row=0, column=2, columnspan=1, rowspan=1, padx=12, pady=12)

        clear_vc_edit_tile()

        self.tl_data["tl_colour_code"].protocol("WM_DELETE_WINDOW", on_closing_cc)
        self.tl_data["tl_colour_code"].grab_set()
        self.wait_window(self.tl_data["tl_colour_code"])

    def save_colour_coding(self):
        tm = self.data["settings"]["TEST_MODE"].get()
        known_colour_codes = self.data.get("settings", {}).get("colour_coding", {})
        un = self.data["state"]["user_name"]
        if tm:
            print(f"{un=}")
        user_domain, *user_name = un.lower().split("\\")
        if not user_name:
            user_name = un
        cc = "NULL"
        if known_colour_codes:
            known_colour_codes = str(known_colour_codes).replace("'", "''")
            cc = f"'{known_colour_codes}'"

        if tm:
            print(f"{user_name=}")

        sql = f"UPDATE\n\t[PDS Valid Updaters]\nSET\n\t[ColourCoding]={cc}\nWHERE\n\t[UserName] = '{user_name}';"
        # print(f"{sql}")
        res = connect(sql, database="Stargatedb", uid="SGeu1", pwd="Pupplies-Hagard->Rio0")

        self.colour_code()

    def ask_before_close(self) -> Tuple[bool, bool]:
        print(f"ask_before_close")
        tm = self.data["settings"]["TEST_MODE"].get()
        if tm:
            print(f"ask_before_close")
        # has_history = self.data.get("history", {})
        print(f"{self.data['history'].get()=}")
        has_history = self.data["history"].get()

        print(f"{has_history=}")

        msg = self.data["abc_no_hist_msg"]
        if has_history:
            msg = self.data["abc_has_hist_msg"]

        return messagebox.askyesnocancel(
            title=self.data["title_application_short"],
            message=msg
        ), has_history

    def ask_save_before_close(self) -> Tuple[bool, bool]:
        print(f"ask_save_before_close")
        # has_history = self.data.get("history", {})
        has_history = self.data["history"].get()
        print(f"{has_history=}")
        msg = self.data["abcsh_no_hist_msg"]
        if has_history:
            msg = self.data["abcsh_has_hist_msg"]

        return messagebox.askyesnocancel(
            title=self.data["title_application_short"],
            message=msg
        ), has_history

    def click_mb_save(self, event=None):
        tm = self.data["settings"]["TEST_MODE"].get()
        if tm:
            print(f"click_mb_save, {event=}")
        test_mode = self.data["settings"]["TEST_MODE"].get()
        # history = self.data["history"]

        hist = list(self.data["history"].get())
        if not hist:
            messagebox.showinfo(
                title=self.data["title_application_short"],
                message=self.data["msg_no_hist_on_save"]
            )
            return

        sql_statments = self.on_closing(do_quit=False)
        for stmt in sql_statments:
            if not test_mode:
                df_res = connect(
                    sql=stmt
                )

        # self.data["history"].clear()
        self.data["history"].set(list())
        messagebox.showinfo(
            title=self.data["title_application_short"],
            message=self.data["msg_save_successful"]
        )

    def reload_application(self, reload_time=4000):
        tm = self.data["settings"]["TEST_MODE"].get()
        if tm:
            print(f"begin reload_application {self.data['settings']['init_test_mode_done'].get()=}")
        if self.lbl_processing is not None:
            self.lbl_processing.pack(expand=True, fill="both")

        def wait_loop():
            if tm:
                print(f"begin sleep")
            time.sleep(reload_time / 1000)
            if tm:
                print(f"end sleep")

        if self.data["settings"]["init_test_mode_done"].get():
            self.set_invisible_canvas("gray")
            thread = threading.Thread(target=wait_loop)
            thread.start()
            thread.join()
            self.set_invisible_canvas()
        else:
            self.data["settings"]["init_test_mode_done"].set(True)

        if self.lbl_processing is not None:
            self.lbl_processing.pack_forget()
        if tm:
            print(f"end reload_application")

    def set_pds_testing_mode(self, in_testing_mode: bool):

        tm = self.data["settings"]["TEST_MODE"].get()
        domain_un = self.data["state"]["user_full"]
        *domain, un = domain_un.split("\\")
        sql = f"UPDATE [PDS Valid Updaters] SET [InTestingMode] = {int(in_testing_mode)} WHERE [UserName] = '{un}';"
        if tm:
            print(f"--\n{sql}")
        connect(sql, **STARGATE_SQL_CREDS, do_print=tm, do_show=tm)
        if tm:
            print(f"--")
        self.data["settings"]["TEST_MODE"].set(in_testing_mode)

    def click_mb_testing_mode(self, event=None):
        tm = self.data["settings"]["TEST_MODE"].get()
        if tm:
            print(f"click_mb_testing_mode")

        in_tm = self.data["settings"]["TEST_MODE"].get()
        tl_name = "tl_testing_mode"
        tlsn = "tl_tm"

        def click_yes():
            if tm:
                print(f"click_yes")
            on_closing_tm()
            self.set_pds_testing_mode(not in_tm)

        def click_no():
            if tm:
                print(f"click_no")
            on_closing_tm()
            self.set_pds_testing_mode(not in_tm)

        def on_closing_tm(*args):
            self.tl_data[tl_name].destroy()

        self.tl_data[tl_name] = tkinter.Toplevel(self)
        self.tl_data[tl_name].title(self.data["title_application_full"])

        w, h = 200, 120
        tl_geom = tkinter_utility.calc_geometry_tl(w, h, largest=True, rtype=dict, parent=self)
        self.tl_data[tl_name].geometry(tl_geom["geometry"])

        message = f"Enter Testing Mode?" if (not in_tm) else f"Exit Testing Mode?"

        # toplevel - testing mode - textvariable - label
        self.tl_data[f"{tlsn}_tv_lbl_message"], self.tl_data[f"{tlsn}_lbl_message"] = tkinter_utility.label_factory(
            self.tl_data[tl_name],
            tv_label=message
        )
        self.tl_data[f"{tlsn}_tv_btn_yes"], self.tl_data[f"{tlsn}_btn_yes"] = tkinter_utility.button_factory(
            self.tl_data[tl_name],
            tv_btn="yes",
            command=click_yes
        )
        self.tl_data[f"{tlsn}_tv_btn_no"], self.tl_data[f"{tlsn}_btn_no"] = tkinter_utility.button_factory(
            self.tl_data[tl_name],
            tv_btn="no",
            command=click_no
        )

        self.tl_data[f"{tlsn}_lbl_message"].grid(row=0, column=0, columnspan=2, padx=20, pady=20)
        self.tl_data[f"{tlsn}_btn_yes"].grid(row=1, column=0, columnspan=1, padx=5, pady=5)
        self.tl_data[f"{tlsn}_btn_no"].grid(row=1, column=1, columnspan=1, padx=5, pady=5)

        self.tl_data[tl_name].protocol("WM_DELETE_WINDOW", on_closing_tm)
        self.tl_data[tl_name].grab_set()
        self.wait_window(self.tl_data[tl_name])

    def click_mb_exit(self, event=None):
        tm = self.data["settings"]["TEST_MODE"].get()
        if tm:
            print(f"click_mb_exit, {event=}")
        ans_has_history = self.ask_save_before_close()
        ans, has_history = ans_has_history
        if ans == tkinter.YES:
            # quit without saving
            self.destroy()
        else:
            # continue editing
            pass

    def on_closing(self, do_quit: bool = True) -> None | list:
        print(f"on_closing")
        tm = self.data["settings"]["TEST_MODE"].get()
        # history = self.data["history"]
        # do_exec = False  # automatically update server using generated sql statements.
        do_exec = True  # automatically update server using generated sql statements.

        # in_test_mode = self.data["settings"]["TEST_MODE"].get()
        print(f"TEST_MODE={'Y' if tm else 'N'}")

        do_exec = do_exec and (not tm)

        history = list(self.data["history"].get())
        print(f"{history=}")
        sql_statments = []

        if do_quit:
            # ans_has_history = self.ask_save_before_close()
            if history:
                ans_has_history = self.ask_save_before_close()
            else:
                ans_has_history = self.ask_before_close()

            ans, has_history = ans_has_history
        else:
            ans = tkinter.YES
            has_history = bool(len(history))
        print(f"{ans=}, {has_history=}")
        if ans == tkinter.YES:

            if has_history:

                # need the date, line, and Quote # for SQL update query
                # user = utility.get_windows_user(2)
                # user = self.data["state"]["user"]
                user = self.data["state"]["user_name"]
                rt1 = "[BWSdb].[dbo].[OrdersV2]"
                kd = "[Available Date]"
                kl = "[JobAvailableLine]"
                ks = "[JobAvailableScheduled]"
                kb = "[JobAvailableScheduledBy]"
                kq = "[SGQuote]"

                rt2 = "[Stargatedb].[dbo].[dtProductionScheduleV2]"
                kj = "[JobStartLine]"
                kk = "[JobFinishDate]"

                sql_swap_1 = f"UPDATE\n\t{rt1}\nSET\n\t{kd} = '{{KD}}',\n\t{kl} = '{{KL}}',\n\t{ks} = '{{KS}}',\n\t{kb} = '{{KB}}'\nWHERE\n\t{kq} = '{{KQ}}'\n;"
                sql_swap_2 = f"UPDATE\n\t{rt2}\nSET\n\t{kj} = '{{KJ}}',\n\t{kk} = '{{KK}}'\nWHERE\n\t{kq} = '{{KQ}}'\n;"

                sql_blank_double_1 = f"UPDATE\n\t{rt1}\nSET\n\t{kd} = NULL,\n\t{kl} = NULL,\n\t{ks} = '{{KS}}',\n\t{kb} = '{{KB}}'\nWHERE\n\t{kq} = '{{KQ}}'\n;"
                sql_blank_double_2 = f"UPDATE\n\t{rt2}\nSET\n\t{kj} = NULL,\n\t{kk} = NULL\nWHERE\n\t{kq} = '{{KQ}}'\n;"

                now = datetime.datetime.now()
                date = f"{now:%Y-%m-%d %H:%M:%S}"
                stmt_1 = f""
                stmt_2 = f""
                sql_1 = f""
                sql_2 = f""
                if tm:
                    print(f"\n\tON CLOSE\n{history=}")
                # print(f"SHOULD MAKE SURE THESE ARE CLEAR\n\t{len(self.concats_double_entries_stg)}\n\t{self.concats_double_entries_stg=}")

                for s_df in self.concats_double_entries:
                    stmt_1 = f""
                    if tm:
                        print(f"{s_df[['OrdersV2_SGQuote', 'Available Date', 'JobAvailableLine']]=}")
                    # sql_1 += sql_blank_double_1.format()
                    stmt_1 += f"\n/* SQL OUTPUT - FIX DOUBLE - {date}*/\n\n/*{rt1}*/\n"

                    for i, row in s_df.iterrows():
                        quote = s_df.iloc[i]["OrdersV2_SGQuote"]
                        dat = {
                            "KS": date,
                            "KB": user,
                            "KQ": quote
                        }

                        dat_2 = {"KQ": quote}
                        stmt_1 += f"/* Quote: {quote}*/\n"
                        stmt_1 += f"\n{sql_blank_double_1.format(**dat)}\n"
                        stmt_1 += f"\n/* {rt2}*/\n"
                        stmt_1 += f"\n{sql_blank_double_2.format(**dat_2)}\n"
                        sql_statments.append(stmt_1)
                        # print(f"<<<<\n{sql_blank_double_2.format(**dat_2)}")

                        # sql_1 += f"\n{sql_blank_double_1.format(**dat)}\n"
                        # dat_2 = {"KQ": quote}
                        # sql_2 += f"\n{sql_blank_double_2.format(**dat_2)}"
                        # sql_1 = f"-- SQL OUTPUT - FIX DOUBLE - {date}\n\n-- {rt1}\n{sql_1}\n-- {rt2}\n{sql_2}"

                for action, *data in history:
                    stmt_1 = f""
                    stmt_2 = f""
                    # print(f"\t{action=}")
                    match action:
                        case "SWAP":
                            keys_1, keys_2 = data
                            date_1, line_1 = keys_1
                            date_2, line_2 = keys_2
                            if isinstance(date_1, str):
                                date_1 = pd.Timestamp(date_1)
                            if isinstance(date_2, str):
                                date_2 = pd.Timestamp(date_2)
                            if tm:
                                print(f"{date_1=}, {line_1=}, {date_2=}, {line_2=}")
                            order_1 = self.tiles[date_1][line_1].get("order")
                            order_2 = self.tiles[date_2][line_2].get("order")
                            if tm:
                                print(f"{order_1=}, {order_2=}")
                            if order_1 is not None:
                                print(f"\torder_1 is not NONE")
                                order_1 = int(order_1)
                                dat_1 = {
                                    "KD": date_1,
                                    "KL": line_1,
                                    "KS": date,
                                    "KB": user,
                                    "KQ": self.df_orders.iloc[order_1]["OrdersV2_SGQuote"]
                                }
                                stmt_1 += f"\n{sql_swap_1.format(**dat_1)}"
                                dat_2 = {"KJ": line_1, "KK": date_1,
                                         "KQ": self.df_orders.iloc[order_1]["OrdersV2_SGQuote"]}
                                stmt_2 += f"\n{sql_swap_2.format(**dat_2)}"

                            if order_2 is not None:
                                if tm:
                                    print(f"\torder_2 is not NONE")
                                order_2 = int(order_2)
                                dat_1 = {
                                    "KD": date_2,
                                    "KL": line_2,
                                    "KS": date,
                                    "KB": user,
                                    "KQ": self.df_orders.iloc[order_2]["OrdersV2_SGQuote"]
                                }
                                stmt_1 += f"\n{sql_swap_1.format(**dat_1)}"
                                dat_2 = {"KJ": line_2, "KK": date_2,
                                         "KQ": self.df_orders.iloc[order_2]["OrdersV2_SGQuote"]}
                                stmt_2 += f"\n{sql_swap_2.format(**dat_2)}"

                            stmt_1 = stmt_1.removeprefix('\n')
                            stmt_2 = stmt_2.removeprefix('\n')
                            if tm:
                                print(f"PRE_APPEND TO stmt_1:")
                                print(f"1: {stmt_1}")
                                print(f"2: {stmt_2}")
                            stmt_1 = f"/* SQL OUTPUT - SWAP - {date}*/\n\n/* {rt1}*/\n{stmt_1}\n\n/* {rt2}*/\n{stmt_2}"

                        case "INSERT":
                            order, date_line = data
                            date_, line_ = date_line
                            if isinstance(date_, str):
                                date_ = pd.Timestamp(date_)
                            if isinstance(order, str):
                                order = int(order)
                            if tm:
                                print(f"{order=}, {date_=}, {line_=}")

                            dat = {
                                "KD": date_,
                                "KL": line_,
                                "KS": date,
                                "KB": user,
                                "KQ": self.df_orders.iloc[order]["OrdersV2_SGQuote"]
                            }
                            stmt_1 += f"\n{sql_swap_1.format(**dat)}"
                            dat_2 = {"KJ": line_, "KK": date_, "KQ": self.df_orders.iloc[order]["OrdersV2_SGQuote"]}
                            stmt_2 += f"\n{sql_swap_2.format(**dat_2)}"

                            stmt_1 = stmt_1.removeprefix('\n')
                            stmt_2 = stmt_2.removeprefix('\n')
                            stmt_1 = f"/* SQL OUTPUT - INSERT - {date}*/\n\n/* {rt1}*/\n{stmt_1}\n\n/* {rt2}*/\n{stmt_2}"

                        case "DELETE":
                            order, date_line = data
                            date, line = date_line
                            if isinstance(date, str):
                                date = pd.Timestamp(date)
                            if isinstance(order, str):
                                order = int(order)
                            if tm:
                                print(f"{order=}, {date=}, {line=}")

                            quote = self.df_orders.iloc[order]["OrdersV2_SGQuote"]
                            dat = {
                                "KS": date,
                                "KB": user,
                                "KQ": quote
                            }

                            stmt_1 += f"\n/* SQL OUTPUT - DELETE ORDER - {date}*/\n\n/* {rt1}*/\n"
                            dat_2 = {"KQ": quote}
                            stmt_1 += f"/* Quote: {quote}*/\n"
                            stmt_1 += f"\n{sql_blank_double_1.format(**dat)}\n"
                            stmt_1 += f"\n/* {rt2}*/\n"
                            stmt_1 += f"\n{sql_blank_double_2.format(**dat_2)}\n"

                        case _:
                            raise ValueError("Cant undo")
                    sql_statments.append(stmt_1)

                # if stmt_1.strip():
                #     print(f"SQL =\n\nBEGIN TRAN;\n\n{stmt_1}\n\nROLLBACK;\nCOMMIT;")

                stmts = "\n".join(sql_statments)
                # if tm:
                print(f"{do_exec=}")
                print(f"{stmts=}")
                # connect_stmts = " ".join([stmt.replace("\n", " ") for stmt in sql_statments[1:]])
                tran_stmts = f"/* SQL */\n/* Date: {self.today:%Y-%m-%d %H:%M:%S} =*/\n\nBEGIN TRAN;\n\n{stmts}\n\nROLLBACK;\nCOMMIT;"
                if tm:
                    print(f"{'=' * 120}\n\ttran_stmts:\n{tran_stmts}{'=' * 120}")

                if do_exec:

                    with open(self.file_last_session_sql, "w") as f:
                        f.write(tran_stmts)

                    connect(stmts, **STARGATE_SQL_CREDS, do_show=tm, do_print=tm)
                    messagebox.showinfo(
                        title=self.data["title_application_short"],
                        message=self.data["msg_save_successful"]
                    )
                    # for stmt in stmts.split(";"):
                    #     st = stmt.replace("\t", " ").replace("\n", " ")
                    #     if st and (not st.startswith("--")):
                    #         print(f"{st=}")
                    #         connect(st)
                else:
                    if tm:
                        messagebox.showinfo(
                            title=self.data["title_application_short"],
                            message=self.data["msg_no_commit_test_mode"]
                        )

                # # TODO async
                # print(f"{'='*120}\n\tstmts:\n{stmts}{'='*120}\n{stmts=}\n{'='*120}")
                # connect(stmts, do_show=True)  # fires all update statements
        else:
            if ans is None:
                # hit cancel, dont leave
                do_quit = False

        if do_quit:
            self.destroy()
        else:
            return sql_statments

    def update_toggle_canvas_selection(self, *args):
        tm = self.data["settings"]["TEST_MODE"].get()
        if tm:
            print(f"update_toggle_canvas_selection")
        toggle_mode = self.toggle_warranty.value.get()

        self.toggle_warranty.grid_forget()

        if toggle_mode == "Warranty":
            self.multi_combobox_orders.grid_widget(False)
            self.multi_combobox_warranties.grid_widget(True)
        else:
            # Orders
            self.multi_combobox_orders.grid_widget(True)
            self.multi_combobox_warranties.grid_widget(False)

        self.toggle_warranty.grid(row=1, column=0)

    def click_if_goto(self):
        tm = self.data["settings"]["TEST_MODE"].get()
        if tm:
            print(f"click_if_goto")

        # before = self.tv_entry_unit_scroll_search.get()
        quote = self.info_frame.get_value("SGQuote")
        if tm:
            print(f"{quote=}")
        if quote:
            date = pd.Timestamp(self.info_frame.get_value("Sched Finish"))
            line = self.info_frame.get_value("Sched Line")
            bbox = self.canvas.bbox("all")
            xv = self.canvas.xview()
            x1, x2 = bbox[0::2]
            w = x2 - x1
            vw = (xv[1] - xv[0]) * w
            # print(f"{date=}, {line=}")
            # print(f"{self.canvas_stg.xview()=}")
            # print(f"{self.canvas_stg.bbox('all')=}")
            bbox = self.get_tile_bbox(date, line)
            # print(f"{bbox=}, {vw=}")
            x = bbox[0] - (vw / 2)
            x = max(0, x)
            p = x / w
            # print(f"{x=}, {p=}, {self.canvas_stg.canvasx(x)=}")

            self.canvas.xview_moveto(p)
            self.flash_tile((date, line), mode="attention")
            self.redraw_legend()

    def check_for_units_on_holidays(self):
        units_on_holiday = {}
        t = "  "
        for d, hn in self.holidays.items():
            print(f"{d=}, {hn=}")
            for line in self.list_prod_lines:
                tile_data = self.tiles[d][line]
                if (order := tile_data.get("order")) is not None:
                    qn = self.df_orders.iloc[order]["OrdersV2_SGQuote"]
                    print(f"{qn=} found on {line=}, on {d=}")
                    units_on_holiday[(d, line)] = (qn, order)
                else:
                    print(f"no order, {d=}, {line=}")

        if units_on_holiday:
            msg = f"The following quotes were found to be sheduled on a holiday:\n"
            shown_dates = set()
            for d, l in units_on_holiday:
                qn, order = units_on_holiday[(d, l)]
                if d not in shown_dates:
                    hn = self.holidays[d]
                    msg += f"\n{(t if shown_dates else '')}{hn.center(18)} -- {datetime_utility.date_str_format(d, include_weekday=True, short_month=True, short_weekday=True).center(20)}"
                    shown_dates.add(d)
                msg += f"\n{4*t}{l.rjust(5)}: {qn}"
            messagebox.showwarning(
                title=self.data["title_application_short"],
                message=msg
            )

    def quit_cc_app(self):
        print(f"quit_cc_app")
        self.tl_cc_app.destroy()

def test_canvas_window():
    app = tkinter.Tk()

    can1 = tkinter.Canvas(app, background="#789456")
    can2 = tkinter.Canvas(can1, background="#654987")
    can3 = tkinter.Canvas(can2, background="#654321")

    can1.create_window(10, 10, anchor=tkinter.NW, window=can2)
    can2.create_window(20, 20, anchor=tkinter.NW, window=can3)

    can1.pack()

    app.mainloop()


if __name__ == '__main__':
    # test_canvas_window()
    app = App()
    app.mainloop()
