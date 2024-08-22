import copy
import datetime
import enum
import io
import math
import random
import threading
import time
import tkinter
import numpy as np
from tkinter import messagebox, ttk
from itertools import zip_longest
from typing import Tuple, Optional

import CTkTable
import customtkinter as ctk
import pandas as pd

import utility
import tkinter_utility
import datetime_utility
from pyodbc_connection import connect
from colour_utility import *
from PIL import Image, ImageTk, ImageGrab, ImageDraw, ImageFont
from ttkwidgets.color import askcolor, ColorPicker
from ttkwidgets.font import askfont, FontChooser, FontSelectFrame
import customtkinter_utility

import win32gui
import win32con
import win32api

# TODO shrink weekend tiles_stg, currently they are just exempt from placement actions. Takes too much space.
# TODO add slight animation for successful placement. 'Ripple' the row and column once complete.  -- CHECK 202404161806
# TODO 202403251934 - the date and line bucket functions seem to have some "drift". when scrolling to the other end of the calendar
#   The hovered tile is too far to the right of the pointer.
# TODO 202406211312 Remove the data dictionary and declare all of the values as class attributes


### ONLY FOR STARGATE AND ONLY TEMPORARILY
# At some point a more modern calculation will be used
# one that considers type of unit, Galvanization, etc...
N_BUSINESS_DAYS_AVAIL_TO_DELIVERY = 3

STARGATE_SQL_CREDS = {
    "database": "StargateDB",
    "uid": "SGeu1",
    "pwd": "Pupplies-Hagard->Rio0"
}

BWS_SQL_CREDS = {
    "database": "BWSdb",
    "uid": "user5",
    "pwd": "M@gic456"
}

for sql_data in (
        SQL_USED_LINES_BWS := {
            "sql": """
SELECT
	[PL].[Prod Line]
FROM
	[BWSdb].[dbo].[dtProductionSchedule] AS [PS]
INNER JOIN
	[BWSdb].[dbo].[Prod Lines] AS [PL]
ON
	(CASE 
		WHEN [PS].[WO Line 1] IS NOT NULL THEN
			(CASE WHEN [PS].[WO Line 1] = [PL].[Prod Line] THEN 1 ELSE 0 END)
		WHEN [PS].[WO Line 2] IS NOT NULL THEN
			(CASE WHEN [PS].[WO Line 2] = [PL].[Prod Line] THEN 1 ELSE 0 END)
		WHEN [PS].[Other Line] IS NOT NULL THEN
			(CASE WHEN [PS].[Other Line] = [PL].[Prod Line] THEN 1 ELSE 0 END)
		WHEN [PS].[GN Line] IS NOT NULL THEN
			(CASE WHEN [PS].[GN Line] = [PL].[Prod Line] THEN 1 ELSE 0 END)
		WHEN [PS].[Beam Line] IS NOT NULL THEN
			(CASE WHEN [PS].[Beam Line] = [PL].[Prod Line] THEN 1 ELSE 0 END)
		ELSE 0
	END) > 0
WHERE
	[PL].[LO] IS NOT NULL
GROUP BY
	[PL].[Prod Line]
	,[PL].[LO]
ORDER BY
	[PL].[LO]
;

    """
        },
        SQL_HOLIDAYS_BWS := {
            "sql": """
SELECT
	[C].[Date] AS [C_Date]
	,[C].[Day] AS [C_Day]
	,[C].[DayOfWeek] AS [C_DayOfWeek]
	,[C].[SAT Holiday] AS [C_SATHoliday]
	,[C].[STAT Holiday] AS [C_STATHoliday]
	,[C].[HolidayName] AS [C_HolidayName]

	,[vC].[CalendarDate] AS [vC_DateCalendar]
	,[vC].[WorkDay] AS [vC_WorkDay]
FROM
	[BWSDB].[dbo].[Calendar] AS [C] WITH (NOLOCK)
FULL OUTER JOIN
	[SysproCompanyA].[dbo].[v_CalendarWorkDays] AS [vC] WITH (NOLOCK)
ON
	[C].[Date] = [vC].[CalendarDate]
WHERE
	[C].[Date] IS NOT NULL
        """
        },
        SQL_WARRANTY_CLAIMS_BWS := {
            "sql": """
SELECT
	[WO#]
FROM
	[BWSdb].[dbo].[Orders]
WHERE
	ISNULL([Warranty], 0) = 1
;
"""
        },
        SQL_DATED_BWS_UNITS_1 := {
            "sql": "EXEC [BWSdb].[dbo].[sp_ProductionSchedule V4_Slots] {SD}, {ED};"
        },
        SQL_DATED_BWS_UNITS_2 := {
            "sql": """
SELECT
    *
FROM
    [BWSdb].[dbo].[Orders]
WHERE
    ([Order Date] BETWEEN {SD} AND {ED})
    OR ([Quote Date] BETWEEN {SD} AND {ED}) 
    OR ([Available Date] BETWEEN {SD} AND {ED}) 
    OR ([Delivery Date] BETWEEN {SD} AND {ED}) 
    OR ([Finish Date] BETWEEN {SD} AND {ED}) 
    OR ([PO Date] BETWEEN {SD} AND {ED}) 
    OR ([Est Pro Date] BETWEEN {SD} AND {ED}) 
    OR ([Date Registered] BETWEEN {SD} AND {ED})
    OR ([Date In Service] BETWEEN {SD} AND {ED})  
    OR ([Invoice Date] BETWEEN {SD} AND {ED}) 
    OR ([Shipped Date] BETWEEN {SD} AND {ED})
    OR ([Date Requested] BETWEEN {SD} AND {ED})
    OR ([BWSPaidDate] BETWEEN {SD} AND {ED})   
    OR ([CommPaidDate] BETWEEN {SD} AND {ED})   
    OR ([Lead Date] BETWEEN {SD} AND {ED})   
    OR ([DateLastQuoteReport] BETWEEN {SD} AND {ED})
    OR ([JobAvailableScheduled] BETWEEN {SD} AND {ED})   
;
"""
        },
        SQL_DATED_BWS_UNITS_3 := {
            "sql": """
SELECT
    *
FROM
    [BWSdb].[dbo].[dtProductionSchedule]
WHERE
    ([Beam Date] BETWEEN {SD} AND {ED})
    OR ([Prod Date 1] BETWEEN {SD} AND {ED})
    OR ([Prod Date 2] BETWEEN {SD} AND {ED})
    OR ([Other Date] BETWEEN {SD} AND {ED})
    OR ([Prod On] BETWEEN {SD} AND {ED})
    OR ([Prod Off] BETWEEN {SD} AND {ED})
    OR ([Prod2 On] BETWEEN {SD} AND {ED})
    OR ([Prod2 Off] BETWEEN {SD} AND {ED})
    OR ([Beam On] BETWEEN {SD} AND {ED})
    OR ([Beam Off] BETWEEN {SD} AND {ED})
    OR ([GN On] BETWEEN {SD} AND {ED})
    OR ([GN Off] BETWEEN {SD} AND {ED})
    OR ([Axle On] BETWEEN {SD} AND {ED})
    OR ([Axle Off] BETWEEN {SD} AND {ED})
    OR ([Other On] BETWEEN {SD} AND {ED})
    OR ([Other Off] BETWEEN {SD} AND {ED})
;
"""
        }
):
    for cred_k, cred_v in BWS_SQL_CREDS.items():
        if cred_k not in sql_data:
            sql_data.update({cred_k: cred_v})

for sql_data in (

        SQL_USED_LINES_STG := {
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

        SQL_WARRANTY_CLAIMS_STG := {
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

        SQL_HOLIDAYS_STG := {
            "sql": """
SELECT
	[C].[Date] AS [C_Date]
	,[C].[Day] AS [C_Day]
	,[C].[DayOfWeek] AS [C_DayOfWeek]
	,[C].[SAT Holiday] AS [C_SATHoliday]
	,[C].[STAT Holiday] AS [C_STATHoliday]
	,[C].[HolidayName] AS [C_HolidayName]

	,[vC].[CalendarDate] AS [vC_DateCalendar]
	,[vC].[WorkDay] AS [vC_WorkDay]
FROM
	[BWSDB].[dbo].[Calendar] AS [C] WITH (NOLOCK)
FULL OUTER JOIN
	[SysproCompanyS].[dbo].[v_CalendarWorkDays] AS [vC] WITH (NOLOCK)
ON
	[C].[Date] = [vC].[CalendarDate]
WHERE
	[C].[Date] IS NOT NULL
        """,
            "database": "BWSDB",
            "uid": "user5",
            "pwd": "M@gic456"
        },

        SQL_DATED_STG_UNITS := {
            "sql": """
    SELECT
        B.[ProdSchedV2ID#]
        ,[O].[SGQuote] AS [OrdersV2_SGQuote]
        ,B.[WO#] AS [OrdersV2_WO#]
        --,B.[JobStartDate]
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
        ,[LightDarkTheme]
        ,[AskMonitors]
        ,[ShowCalendarOnly]
        ,[ColourTheme]
        ,[ColourCodingPriority]
        ,[ColourCodingPriorityOnly]
        ,[AdminPassword]
        ,[ModeCompany]
        ,[AllowedCompanies]
    FROM
        [Stargatedb].[dbo].[PDS Valid Updaters]
    ;
    """
        }

):
    for cred_k, cred_v in STARGATE_SQL_CREDS.items():
        if cred_k not in sql_data:
            sql_data.update({cred_k: cred_v})


class COMPANY(enum.Enum):
    BWS: int = 0
    STG: int = 1


# Stargate units are scheduled from available date [Stargate].[dbo].[dtProductionScheduleV2].[JobFinishDate]
# BWS units are scheduled by Start date


class App(ctk.CTk):

    def __init__(self):
        super().__init__()

        self.date_version = datetime.datetime(2024, 8, 22)
        print(f"DATE-VERSION >>> {self.date_version:%Y-%m-%d}")
        self.file_last_session_sql: str = "last_session_sql.sql"
        self.default_admin_password = "trailer"

        self.app_state = {
            "hovered": [],
            "selected": [],
            "dragged": [],
            "cursor_drag_pos": [None, None]
        }
        self.history = ctk.Variable(value=list(), name="history")
        self.listbox_history = []
        self.settings = {
            "mode_company": COMPANY.STG.value,
            "allow_multi_select": False,
            "colour_coding": {},
            "TEST_MODE": ctk.BooleanVar(self, value=False),
            "allowed_to_publish": ctk.BooleanVar(self, value=False),
            "admin_password": ctk.StringVar(self, value=self.default_admin_password),
            "admin_password_entered": ctk.BooleanVar(self, value=False),
            "min_font_size_tile": 8,
            "max_font_size_tile": 18,
            "start_at_first_of_month": True,
            "end_at_end_of_month": True
        }
        self.list_sl_preview_table_cols = ["Quote", "Current Date", "New Date"]
        self.tl_data: dict = {}

        # default values
        self.days_backward = 3 * 7
        self.days_forward = 52 * 7

        self.opacity_reload = 0.6
        self.x_top_widgets = 10
        self.y_top_widgets = 5
        self.margin_between_mc_and_calendar = 20
        self.max_tries_admin_password = 5

        self.default_allowed_companies = [1]  # stargate only by default
        self.default_allowed_comp_bws = False
        self.default_allowed_comp_stg = False
        self.default_colour_code_priority = ["dealer"]
        self.default_colour_code_only_priority = True
        self.default_show_galvanized = True
        self.default_light_dark_theme = "Dark"
        self.default_colour_theme = "Dark Blue"
        self.default_ask_monitors = "Yes"
        self.default_allow_publish = "No"
        self.default_show_left_widgets = "Yes"
        self.txt_non_prod_day = "Non-Prod Day"

        self.kwargs_lbl = {
            "font": ("Calibri", 18),
            "justify": ctk.LEFT
        }
        self.grid_args_frame = {
            "padx": 40,
            "pady": 15,
            "sticky": ctk.NSEW
        }
        self.grid_args_switch = {
            # "padx": 10,
            "pady": 12,
            "sticky": ctk.E
        }
        self.grid_args_label = {
            # "padx": 20,
            "pady": 12,
            "sticky": ctk.W
        }

        self.colour_background_theme_green = Colour("#006940")
        self.colour_background_theme_blue = Colour("#0066A9")
        self.colour_background_theme_dark_blue = Colour("#003689")
        self.colour_foreground_theme_green = Colour("#FFFFFF")
        self.colour_foreground_theme_blue = Colour("#FFFFFF")
        self.colour_foreground_theme_dark_blue = Colour("#FFFFFF")
        self.colour_foreground_testing_mode_label = Colour("#981415")
        self.font_foreground_testing_mode_label = ("Arial", 12, "bold")
        self.colour_foreground_processing_label = Colour(JADE_GREEN)
        self.colour_background_processing_label = Colour("#083712")
        self.font_foreground_processing_label = ("Arial", 32, "bold")
        self.colour_background_root_canvas = Colour("#12CC16")
        # "colour_app_background" = Colour("#C3C3C3"),
        # "colour_app_background" = Colour("#941186"),
        self.colour_app_background = Colour(self.cget("bg"))
        # "colour_app_background" = Colour("#F0F0F0"),
        self.colour_calendar_background = Colour("#101060")
        self.colour_tile_header_home_background = Colour("#181210")
        self.colour_tile_header_row_background = Colour("#321116")
        self.colour_tile_header_row_foreground = Colour("#e4e4ff")
        self.colour_tile_header_col_background = Colour("#321116")
        self.colour_tile_header_col_foreground = Colour("#e4e4ff")

        self.colour_tile_background = Colour("#ecdddd")
        self.colour_tile_foreground = Colour("#090909")
        self.colour_tile_background_non_prod = self.colour_tile_background.darkened(0.25)
        self.font_tile = "Arial 10"
        self.colour_tile_outline = Colour("#111111")
        self.width_tile_outline = 1

        self.colour_garbage_background = Colour("#A32234")
        self.colour_garbage_foreground = Colour("#632234")
        self.colour_garbage_outline = Colour("#632234")
        self.colour_garbage_border_width = 4

        self.colour_background_app = Colour("#777797")
        self.colour_background_calendar_app = Colour("#777797")
        self.colour_tile_background_selected = Colour("#DC4245")
        self.colour_tile_foreground_selected = Colour("#090909")
        self.font_tile_selected = "Arial 12 bold"
        self.colour_tile_outline_selected = Colour("#DDA911")
        self.colour_background_holiday = Colour("#AABBFD")
        self.colour_foreground_holiday = Colour("#A44000")
        self.colour_test_dot = Colour("#AE3341")

        self.colour_tl_sl_preview_header = Colour("#003578")
        self.colour_sl_fg_text_warnings_preview_warn = Colour("#FF7777")
        self.colour_sl_fg_text_warnings_preview_no_warn = Colour("#FEFEFE")

        self.width_tile_outline_selected = 4
        self.height_calendar_scrollbar = 20

        # self.default_font = ("Arial", 10)
        self.default_font = ctk.CTkFont(
            family="Arial",
            size=10
        )

        self.colour_background_testing_mode_label = self.colour_background_app.brightened(0.15)
        self.colour_fill_multi_combobox_drag_tile = self.colour_tile_background.darkened(0.2)
        self.colour_outline_multi_combobox_drag_tile = self.colour_tile_foreground.darkened(0.2)
        self.colour_tile_background_hover = self.colour_tile_background.brightened(0.25)
        self.colour_tile_foreground_hover = self.colour_tile_foreground.brightened(0.25)
        self.font_tile_hover = "Arial 13 bold"
        self.colour_tile_outline_hover = self.colour_tile_outline.brightened(0.25)
        self.width_tile_outline_hover = 2

        self.colour_tile_background_weekend = self.colour_tile_background.darkened(0.5)
        self.colour_tile_foreground_weekend = self.colour_tile_foreground.darkened(0.5)
        self.colour_tile_outline_weekend = self.colour_tile_outline.darkened(0.5)
        self.font_tile_weekend = self.font_tile
        self.width_tile_outline_weekend = self.width_tile_outline

        self.colour_tile_background_weekend_selected = self.colour_tile_background_selected.darkened(0.25)
        self.colour_tile_foreground_weekend_selected = self.colour_tile_foreground_selected.darkened(0.25)
        self.colour_tile_outline_weekend_selected = self.colour_tile_outline_selected.darkened(0.25)
        self.font_tile_weekend_selected = self.font_tile_selected

        self.colour_tile_background_weekend_hover = self.colour_tile_background_hover.darkened(0.25)
        self.colour_tile_foreground_weekend_hover = self.colour_tile_foreground_hover.darkened(0.25)
        self.colour_tile_outline_weekend_hover = self.colour_tile_outline_hover.darkened(0.25)
        self.font_tile_weekend_hover = self.font_tile_hover

        self.title_application_full = f"Stargate Production Scheduler -- {self.date_version:%Y-%m-%d}"
        self.title_application_short = "STG Prod Sched"
        self.msg_no_movement_non_publish = f"No Movements allowed because you are a non-publish user"
        self.msg_please_do_not_rerun = f"\n\nPlease do not re-run the application until you have consulted IT."
        self.msg_non_valid_pds_user = f"You do not have permission to use this app.{self.msg_please_do_not_rerun}"
        self.msg_non_publish_user = f"You do not have permission to publish changes with this app.{self.msg_please_do_not_rerun}"
        self.abc_has_hist_msg = f"Are you sure you want to exit, you have unsaved work?"
        self.abc_no_hist_msg = f"Are you sure you want to exit?"
        self.abcsh_has_hist_msg = f"Save your work before quitting?"
        self.abcsh_no_hist_msg = f"Are you sure you want to exit?"
        self.msg_no_hist_on_save = f"You do not have any unsaved changes."
        self.msg_save_successful = f"Changes saved successfully!"
        self.msg_last_session_sql = f"Please submit the file 'last_session_sql.sql' to IT to salvage your work.{self.msg_please_do_not_rerun}"
        self.msg_save_unsuccessful = f"An error occurred and your changes were not saved correctly. {self.msg_last_session_sql}"
        self.msg_no_commit_test_mode = f"No changes saved because testing mode is enabled."
        self.msg_no_units_on_holiday = f"There are currently no units scheduled on a holiday for this period."
        self.msg_please_restart_to_activate_colour_theme = f"Please restart the application in order for your new colour theme to be applied."
        self.msg_now_allowed_to_publish = f"You now have permission to publish your changes."
        self.msg_now_not_allowed_to_publish = f"Your ability to publish has been deactivated."
        self.msg_incorrect_admin_password_max_tries = f"You have reached the maximum number of attempts to login as an admin.{self.msg_please_do_not_rerun}."
        self.msg_incorrect_admin_password = f"Incorrect admin password."
        self.msg_blank_admin_password = f"Please enter a valid password."
        self.msg_no_company_to_switch = f"You do not have permission to change companies{self.msg_please_do_not_rerun}"
        self.msg_invalid_company_to_switch = f"You do not have permission to enter company {{COMPANY}}.{self.msg_please_do_not_rerun}"
        self.msg_feature_coming_soon = f"Feature Coming Soon"

        self.tv_done_interact_tl = ctk.BooleanVar(self, value=True)
        self.tl_cc_app: Optional[ctk.CTkToplevel] = None
        self.tl_ad: Optional[ctk.CTkToplevel] = None
        self.tl_tu: Optional[ctk.CTkToplevel] = None
        self.tl_sc: Optional[ctk.CTkToplevel] = None
        self.cb_admin_password_entered = None

        # print(f"{self.cget('bg')=}")
        self.menubar = tkinter.Menu(self)
        # self.menubar = ctk.CTkOptionMenu(self)
        self.configure(menu=self.menubar)
        self.mb_file = tkinter.Menu(
            self.menubar,
            tearoff=False
        )
        self.mb_tools = tkinter.Menu(
            self.menubar,
            tearoff=False
        )
        self.mb_help = tkinter.Menu(
            self.menubar,
            tearoff=False
        )

        mb_file = [
            ("Testing Mode", self.click_mb_testing_mode),
            ("Settings", self.click_app_theme),
            ("Save", self.click_mb_save),
            ("Admin", self.click_mb_admin),
            ("Switch Companies", self.click_mb_switch_companies)
        ]
        mb_file.sort(key=lambda tup: tup[0])
        mb_file.append(("", None))
        mb_file.append(("Exit", self.click_mb_exit))
        for lbl, cmd in mb_file:
            if cmd is None:
                self.mb_file.add_separator()
            else:
                self.mb_file.add_command(
                    label=lbl,
                    command=cmd
                )

        mb_tools = [
            ("Check Units Planned On Non Prod Day",
             lambda: self.check_for_units_on_holidays(include_all_holidays=False)),
            ("Check Units Planned On Any Holiday", lambda: self.check_for_units_on_holidays(include_all_holidays=True)),
            ("Go To Today", self.click_mb_go_to_today),
            ("Shift Line", self.click_mb_shift_line),
            ("Colour Code", self.click_mb_colour_code)
        ]
        mb_tools.sort(key=lambda tup: tup[0])
        for lbl, cmd in mb_tools:
            if cmd is None:
                self.mb_tools.add_separator()
            else:
                self.mb_tools.add_command(
                    label=lbl,
                    command=cmd
                )

        mb_help = [
            ("Tutorial", self.click_mb_tutorial)
        ]
        mb_help.sort(key=lambda tup: tup[0])
        for lbl, cmd in mb_help:
            if cmd is None:
                self.mb_help.add_separator()
            else:
                self.mb_help.add_command(
                    label=lbl,
                    command=cmd
                )

        self.menubar.add_cascade(
            label="File",
            menu=self.mb_file,
            underline=0
        )
        self.menubar.add_cascade(
            label="Tools",
            menu=self.mb_tools,
            underline=0
        )
        self.menubar.add_cascade(
            label="Help",
            menu=self.mb_help,
            underline=0
        )

        self.title(self.title_application_full)
        self.configure(
            background=self.colour_app_background.hex_code
        )

        self.df_valid_updaters = None
        self.frame_testing = None
        self.tv_lbl_processing, self.lbl_processing = None, None
        self.tl_tv_switch_dark = ctk.StringVar(self, value=self.default_light_dark_theme)
        self.tl_tv_switch_colour = ctk.StringVar(self, value=self.default_colour_theme)
        self.tl_tv_switch_allow_publish = ctk.StringVar(self, value=self.default_allow_publish)
        self.tl_tv_count_tries_allow_publish = ctk.IntVar(self, value=0)
        self.lbl_admin_password_attempts_remaining = (ctk.StringVar(self, value=f""), None)
        self.entry_admin_password_attempts_remaining = None
        self.tl_tv_switch_ask_monitors = ctk.StringVar(self, value=self.default_ask_monitors)
        self.tl_tv_switch_show_left_widgets = ctk.StringVar(self, value=self.default_show_left_widgets)
        self.tl_tv_colour_code_priority = ctk.Variable(self, value=self.default_colour_code_priority)
        self.tl_tv_colour_code_only_priority = ctk.BooleanVar(self, value=self.default_colour_code_only_priority)
        self.tl_tv_show_galvanized = ctk.BooleanVar(self, value=self.default_show_galvanized)
        self.tl_tv_showing_galvanized = ctk.BooleanVar(self, value=self.default_show_galvanized)
        self.tv_allowed_companies = ctk.Variable(self, value=self.default_allowed_companies)
        self.tv_allowed_comp_bws = ctk.BooleanVar(self, value=self.default_allowed_comp_bws)
        self.tv_allowed_comp_stg = ctk.BooleanVar(self, value=self.default_allowed_comp_stg)
        self.settings["TEST_MODE"].trace_variable("w", self.tv_update_test_mode)
        self.settings["init_test_mode_done"] = ctk.BooleanVar(self, value=False)
        self.settings["count_application_reloads"] = ctk.IntVar(self, value=0)

        self.is_valid_updater = self.check_valid_updater()
        if not self.is_valid_updater:
            self.create_new_pds_user()

            # messagebox.showerror(
            #     title=self.title_application_short,
            #     message=self.msg_create_new_pds_user
            # )
            # messagebox.showerror(
            #     title=self.title_application_short,
            #     message=self.msg_non_valid_pds_user
            # )

        # print(f"{self.tl_tv_switch_ask_monitors.get()=}")
        # self.calc_geometry = tkinter_utility.calc_geometry_tl("zoomed", parent=self, ask=True, rtype=dict, bypass_parent_withdraw=True)
        # self.calc_geometry = customtkinter_utility.calc_geometry_tl(
        #     1.0,
        #     1.0,
        #     parent=self,
        #     ask=self.tl_tv_switch_ask_monitors.get() == "Yes",
        #     rtype=dict,
        #     bypass_parent_withdraw=True
        # )
        self.calc_geometry = customtkinter_utility.calc_geometry_tl(
            "zoomed",
            parent=self,
            ask=self.tl_tv_switch_ask_monitors.get() == "Yes",
            rtype=dict,
            bypass_parent_withdraw=True,
            do_print=True
        )

        if self.settings["TEST_MODE"].get():
            print(f"DIMS: {self.calc_geometry=}")

        self.total_width = self.calc_geometry["width"]
        self.total_height = self.calc_geometry["height"]

        self.n_cols: int = self.days_forward + self.days_backward + 1  # +1 for today in the middle

        self.frame_calendar = ctk.CTkFrame(
            self,
            width=self.calc_geometry["width"],
            height=self.calc_geometry["height"],
            bg_color=self.colour_background_app.hex_code
        )

        self.frame_testing = ctk.CTkFrame(
            self.frame_calendar,
            width=self.calc_geometry["width"],
            height=30,
            bg_color=self.colour_background_app.hex_code
        )

        self.tv_lbl_processing, self.lbl_processing = None, None

        self.tv_lbl_testing_mode, self.lbl_testing_mode = tkinter_utility.label_factory(
            self.frame_testing,
            tv_label="TESTING MODE ENABLED",
            kwargs_label={
                "fg": self.colour_foreground_testing_mode_label.hex_code,
                "bg": self.colour_background_testing_mode_label.hex_code,
                "font": self.font_foreground_testing_mode_label
            }
        )

        tm = self.settings["TEST_MODE"].get()
        self.df_calendar_stg = connect(**SQL_HOLIDAYS_STG, do_show=tm, do_print=tm)
        self.df_prod_lines_stg = connect(**SQL_USED_LINES_STG, do_show=tm, do_print=tm)
        self.df_orders_stg = connect(**SQL_DATED_STG_UNITS, do_show=tm, do_print=tm).fillna("")
        self.multi_combobox_columns_stg = ['Quote#', 'WO#', 'Model No', "Dealer", "Serial#", "Customer WO#"]
        self.info_frame_columns_stg = \
            ["US Sale"] \
            + self.multi_combobox_columns_stg \
            + ["Prod Date", "Delivery Date (Est)", "Sched Finish", "Sched Line"]
        self.df_multi_combobox_data_orders_stg = pd.DataFrame(columns=self.multi_combobox_columns_stg)
        self.df_rest_orders_stg = pd.DataFrame(columns=self.df_orders_stg.columns)
        # self.df_orders_stg = datetime_utility.replace_timestamp_datetime(self.df_orders_stg)
        # dataframe_utility.convert_timestamp_to_datetime(self.df_orders_stg)
        # print(f"{self.df_orders_stg.dtypes=}")

        self.df_multi_combobox_data_warranties_stg = connect(**SQL_WARRANTY_CLAIMS_STG, do_show=tm, do_print=tm)
        self.df_multi_combobox_data_warranties_stg = self.df_multi_combobox_data_warranties_stg.fillna("")
        # # self.df_multi_combobox_data_warranties_stg["WAR_WO"] = self.df_multi_combobox_data_warranties_stg["WAR_WO"].apply(lambda val: int(val) if str(val).isnumeric() else val)
        # self.df_multi_combobox_data_warranties_stg["WAR_WO"] = self.df_multi_combobox_data_warranties_stg["WAR_WO"].apply(
        #     lambda x:
        #     int(x) if str(x).isnumeric() else str(x)
        # )
        # print(f"{self.df_multi_combobox_data_warranties_stg['WAR_WO']=}")

        self.today = datetime_utility.date_to_datetime(datetime.datetime.now().date())
        # now = datetime.datetime.now()
        self.first_date = self.today + datetime.timedelta(days=-self.days_backward)
        if self.settings["start_at_first_of_month"]:
            self.first_date = datetime_utility.first_of_month(self.first_date)
        self.last_date = self.today + datetime.timedelta(days=self.days_forward)
        if self.settings["end_at_end_of_month"]:
            self.last_date = datetime_utility.end_of_month(self.last_date)
        self.list_dates = pd.date_range(self.first_date, periods=self.n_cols, normalize=False).to_list()

        SQL_DATED_BWS_UNITS_1.update({
            "sql": SQL_DATED_BWS_UNITS_1["sql"].format(
                SD=f"'{self.list_dates[0]:%Y-%m-%d}'",
                ED=f"'{self.list_dates[-1]:%Y-%m-%d} 23:59:59'"
            )
        })
        SQL_DATED_BWS_UNITS_2.update({
            "sql": SQL_DATED_BWS_UNITS_2["sql"].format(
                SD=f"'{self.list_dates[0]:%Y-%m-%d}'",
                ED=f"'{self.list_dates[-1]:%Y-%m-%d} 23:59:59'"
            )
        })
        SQL_DATED_BWS_UNITS_3.update({
            "sql": SQL_DATED_BWS_UNITS_3["sql"].format(
                SD=f"'{self.list_dates[0]:%Y-%m-%d}'",
                ED=f"'{self.list_dates[-1]:%Y-%m-%d} 23:59:59'"
            )
        })
        self.df_calendar_bws = connect(**SQL_HOLIDAYS_BWS, do_show=tm, do_print=tm)
        self.df_prod_lines_bws = connect(**SQL_USED_LINES_BWS, do_show=tm, do_print=tm)

        self.df_orders_bws_1 = connect(**SQL_DATED_BWS_UNITS_1, do_show=tm, do_print=tm).fillna("")
        self.df_orders_bws_2 = connect(**SQL_DATED_BWS_UNITS_2, do_show=tm, do_print=tm).fillna("")
        print(f"A {self.df_orders_bws_2=}")
        print(f"A {sorted(list(self.df_orders_bws_2.columns))=}")
        self.df_orders_bws_3 = connect(**SQL_DATED_BWS_UNITS_3, do_show=tm, do_print=tm).fillna("")
        self.df_orders_bws_1 = self.df_orders_bws_1.loc[self.df_orders_bws_1["Quote#"] != ""]
        self.df_orders_bws_2 = self.df_orders_bws_2.loc[self.df_orders_bws_2["Quote#"] != ""]
        self.df_orders_bws_3 = self.df_orders_bws_3.loc[self.df_orders_bws_3["Quote#"] != ""]
        self.df_orders_bws_2 = self.df_orders_bws_2.add_prefix("Orders_")
        self.df_orders_bws_3 = self.df_orders_bws_3.add_prefix("dtProdSched_")
        self.df_orders_bws_2 = self.df_orders_bws_2.rename(columns={"Orders_Quote#": "Quote#"})
        self.df_orders_bws_3 = self.df_orders_bws_3.rename(columns={"dtProdSched_Quote#": "Quote#"})

        print(f"{self.df_orders_bws_1=}")
        print(f"B {self.df_orders_bws_2=}")
        print(f"{self.df_orders_bws_3=}")
        print(f"{sorted(list(self.df_orders_bws_1.columns))=}")
        print(f"B {sorted(list(self.df_orders_bws_2.columns))=}")
        print(f"{sorted(list(self.df_orders_bws_3.columns))=}")

        self.df_orders_bws = self.df_orders_bws_1.merge(
            self.df_orders_bws_2,
            on="Quote#",
            how="outer"
        )
        self.df_orders_bws = self.df_orders_bws.merge(
            self.df_orders_bws_3,
            on="Quote#",
            how="outer"
        )
        self.df_orders_bws["WO#"] = (
            self.df_orders_bws["WO#"].apply(
                lambda x: str(x).rstrip('.0') if pd.notnull(x) else ''
            )
        )
        self.df_orders_bws["Quote#"] = (
            self.df_orders_bws["Quote#"].apply(
                lambda x: str(x).rstrip('.0') if pd.notnull(x) else ''
            )
        )

        if self.settings["TEST_MODE"].get():
            print(f"{self.df_orders_bws=}")

        self.multi_combobox_columns_bws = ['Quote#', 'WO#', 'Model No', "Dealer", "Serial#", "Customer WO#"]
        self.info_frame_columns_bws = \
            ["US Sale"] \
            + self.multi_combobox_columns_bws \
            + ["Prod Date", "Delivery Date (Est)", "Sched Finish", "Sched Line"]
        self.df_multi_combobox_data_orders_bws = pd.DataFrame(columns=self.multi_combobox_columns_bws)
        self.df_rest_orders_bws = pd.DataFrame(columns=self.df_orders_bws.columns)
        # self.df_orders_stg = datetime_utility.replace_timestamp_datetime(self.df_orders_stg)
        # dataframe_utility.convert_timestamp_to_datetime(self.df_orders_stg)
        # print(f"{self.df_orders_stg.dtypes=}")

        print(f"{sorted(list(self.df_orders_stg.columns))=}")
        print(f"{sorted(list(self.df_orders_bws.columns))=}")

        self.list_multi_combobox_warranties_viewable_col_widths = {
            "Claim #": 60,
            "WO": 80,
            "WO#": 80,
            "Model Name": 100,
            "Dealer": 85,
            "Serial Number": 110,
            "Failure": 100,
            "Reason": 75,
            "Location": 80,
            "Parts & Labour": 90,
            "Job": 100
        }

        self.df_multi_combobox_data_warranties_stg = connect(**SQL_WARRANTY_CLAIMS_STG, do_show=tm, do_print=tm)
        self.df_multi_combobox_data_warranties_stg = self.df_multi_combobox_data_warranties_stg.fillna("")
        if self.settings["TEST_MODE"].get():
            print(f"{self.df_multi_combobox_data_warranties_stg['Job']=}")
        self.list_multi_combobox_warranties_viewable_cols_stg = {
            "Job": "Job"
        }
        self.list_multi_combobox_warranties_viewable_col_widths_stg = [
            self.list_multi_combobox_warranties_viewable_col_widths[k] for k in
            self.list_multi_combobox_warranties_viewable_cols_stg.values()]
        self.list_prod_lines_stg = self.df_prod_lines_stg["Prod Line"].to_list()
        self.list_warranty_lines_stg = self.list_prod_lines_stg[-1:]  # currently only using the last line

        self.df_multi_combobox_data_warranties_bws = connect(**SQL_WARRANTY_CLAIMS_BWS, do_show=tm, do_print=tm)
        self.df_multi_combobox_data_warranties_bws = self.df_multi_combobox_data_warranties_bws.fillna("")
        if self.settings["TEST_MODE"].get():
            print(f"{self.df_multi_combobox_data_warranties_bws['WO#']=}")
        self.list_multi_combobox_warranties_viewable_cols_bws = {
            "WO#": "WO#"
        }
        self.list_multi_combobox_warranties_viewable_col_widths_bws = [
            self.list_multi_combobox_warranties_viewable_col_widths[k] for k in
            self.list_multi_combobox_warranties_viewable_cols_bws.values()]
        self.list_prod_lines_bws = self.df_prod_lines_bws["Prod Line"].to_list()
        # self.list_warranty_lines_bws = self.list_prod_lines_bws[-1:]  # currently only using the last line
        self.list_warranty_lines_bws = []  # currently no lines allocated for warranty
        # self.df_multi_combobox_data_warranties_stg = self.df_multi_combobox_data_warranties_stg.rename(columns=self.list_multi_combobox_warranties_viewable_cols_stg)

        # TODO gracefully fail if DFs are empty

        self.n_rows_stg = self.df_prod_lines_stg.shape[0] + 1  # +1 for header row
        self.n_rows_bws = self.df_prod_lines_bws.shape[0] + 1  # +1 for header row

        self.width_multi_combobox = 725
        self.height_multi_combobox = 150

        if self.settings["TEST_MODE"].get():
            print(f"{self.width_multi_combobox=}\n{self.height_multi_combobox=}")

        self.tile_width_stg = 175
        self.tile_height_stg = 110
        self.tile_width_bws = 175
        self.tile_height_bws = 110
        # self.tile_width_weekend = 60
        # self.tile_height_weekend = 110
        # self.tile_width_legend_lines = 110
        # self.tile_height_legend_lines = 110
        self.canvas_width_og = self.total_width - self.width_multi_combobox
        self.canvas_height_og = self.total_height - self.height_multi_combobox
        self.canvas_width = self.canvas_width_og
        self.canvas_height = self.canvas_height_og

        # adjust incase too few prod lines
        if (self.tile_height_stg * self.n_rows_stg) < self.total_height:
            self.tile_height_stg = self.canvas_height / self.n_rows_stg
        if (self.tile_height_bws * self.n_rows_bws) < self.total_height:
            self.tile_height_bws = self.canvas_height / self.n_rows_bws

        self.x_place_frame_canvas = self.width_multi_combobox - self.margin_between_mc_and_calendar
        self.y_place_frame_canvas = self.y_top_widgets
        self.w_place_frame_canvas = int(self.calc_geometry["width"])
        self.h_place_frame_canvas = int(self.calc_geometry["height"])

        self.x_place_frame_multi_combobox = self.x_top_widgets
        self.y_place_frame_multi_combobox = self.y_top_widgets

        self.x_place_frame_info_frame = self.x_top_widgets
        self.y_place_frame_info_frame = self.height_multi_combobox + 195

        self.frame_canvas = ctk.CTkFrame(
            self.frame_calendar,

            width=self.canvas_width,
            height=self.canvas_height + self.height_calendar_scrollbar,  # scrollbar space

            # width = self.w_place_frame_canvas,
            # height = self.h_place_frame_canvas,

            bg_color=self.colour_background_calendar_app.hex_code
        )
        self.frame_left_controls = ctk.CTkFrame(
            self.frame_calendar,
            height=self.canvas_height + self.height_calendar_scrollbar,  # scrollbar space
            bg_color=self.colour_background_calendar_app.hex_code
        )
        self.frame_info_frame = ctk.CTkFrame(self.frame_left_controls)

        self.w_frame_multi_combobox, self.h_frame_multi_combobox = 690, 420
        self.space_btwn_mc_qinfo = 20
        self.w_tb_warranty, self.h_tb_warranty = 300, 40
        # multicombobox for searching
        self.frame_multi_combobox = ctk.CTkFrame(
            self.frame_left_controls,
            width=self.w_frame_multi_combobox,
            height=self.h_frame_multi_combobox
        )
        self.frame_mc_inner = ctk.CTkFrame(
            self.frame_multi_combobox,
            width=self.w_frame_multi_combobox,
            height=self.h_frame_multi_combobox - (2 * self.h_tb_warranty)
        )
        # self.frame_multi_combobox.columnconfigure(0, weight=100)
        self.frame_multi_combobox.grid_propagate(False)
        self.frame_multi_combobox.pack_propagate(False)
        self.frame_mc_inner.grid_propagate(False)
        self.frame_mc_inner.pack_propagate(False)
        self.frame_mc_inner.columnconfigure(0, weight=100)

        # multi-combobox selector for orders or warranties
        # self.toggle_warranty = tkinter_utility.ToggleCanvas(
        #     self.frame_multi_combobox,
        #     option_a="Orders",
        #     option_b="Warranty",
        #     width=300,
        #     height=40,
        #     default_value="Orders",
        #     auto_grid=False
        # )
        # self.toggle_warranty.value.trace_variable("w", self.update_toggle_canvas_selection)
        self.tv_toggle_warranty = ctk.StringVar(self, value="Orders")
        self.tv_toggle_warranty.trace_variable("w", self.update_toggle_canvas_selection)
        self.toggle_warranty = ctk.CTkSegmentedButton(
            self.frame_multi_combobox,
            values=["Orders", "Warranty"],
            variable=self.tv_toggle_warranty,
            width=self.w_tb_warranty,
            height=self.h_tb_warranty
        )

        self.y_place_toggle_warranty = self.y_top_widgets + self.h_tb_warranty

        ####################
        # BWS WIDGETS #
        ####################

        # multi-combobox now that data has been sorted
        self.multi_combobox_orders_bws = tkinter_utility.MultiComboBox(
            self.frame_mc_inner,
            data=self.df_multi_combobox_data_orders_bws,
            include_aggregate_row=False,
            include_drop_down_arrow=False,
            limit_to_list=False,
            allow_insert_ask=False,
            lock_result_col="Quote#",
            auto_grid=False
            # ,
            # show_index_column=False
        )
        self.multi_combobox_orders_bws.res_entry.unbind("<Return>",
                                                        self.multi_combobox_orders_bws.bind_return_res_entry)
        self.multi_combobox_orders_bws.res_entry.bind("<Return>", self.submit_combobox_entry)

        # multi-combobox for warranty quotes
        self.multi_combobox_warranties_bws = tkinter_utility.MultiComboBox(
            self.frame_mc_inner,
            data=self.df_multi_combobox_data_warranties_bws,
            viewable_column_names=self.list_multi_combobox_warranties_viewable_cols_bws,
            viewable_column_widths=self.list_multi_combobox_warranties_viewable_col_widths_bws,
            include_aggregate_row=False,
            include_drop_down_arrow=False,
            limit_to_list=False,
            allow_insert_ask=False,
            lock_result_col="WO#",
            auto_grid=False,
            width=self.x_place_frame_canvas,
            show_index_column=False
        )

        self.tiles_bws = {d: {pl: dict() for pl in self.list_prod_lines_bws} for d in self.list_dates}
        self.tiles_bws["home"] = dict()
        self.df_ids_to_date_line_bws = {}

        ####################
        # STARGATE WIDGETS #
        ####################

        # multi-combobox now that data has been sorted
        self.multi_combobox_orders_stg = tkinter_utility.MultiComboBox(
            self.frame_mc_inner,
            data=self.df_multi_combobox_data_orders_stg,
            include_aggregate_row=False,
            include_drop_down_arrow=False,
            limit_to_list=False,
            allow_insert_ask=False,
            lock_result_col="Quote#",
            auto_grid=False
            # ,
            # show_index_column=False
        )
        self.multi_combobox_orders_stg.res_entry.unbind("<Return>",
                                                        self.multi_combobox_orders_stg.bind_return_res_entry)
        self.multi_combobox_orders_stg.res_entry.bind("<Return>", self.submit_combobox_entry)

        # multi-combobox for warranty quotes
        self.multi_combobox_warranties_stg = tkinter_utility.MultiComboBox(
            self.frame_mc_inner,
            data=self.df_multi_combobox_data_warranties_stg,
            viewable_column_names=self.list_multi_combobox_warranties_viewable_cols_stg,
            viewable_column_widths=self.list_multi_combobox_warranties_viewable_col_widths_stg,
            include_aggregate_row=False,
            include_drop_down_arrow=False,
            limit_to_list=False,
            allow_insert_ask=False,
            lock_result_col="Job",
            auto_grid=False,
            width=self.x_place_frame_canvas,
            show_index_column=False
        )

        self.tiles_stg = {d: {pl: dict() for pl in self.list_prod_lines_stg} for d in self.list_dates}
        self.tiles_stg["home"] = dict()
        self.df_ids_to_date_line_stg = {}
        if self.settings["TEST_MODE"].get():
            print(f"{len(self.list_dates)=}")
            print(f"{len(self.tiles_stg)=}")
            print(f"{len(self.tiles_bws)=}")
            # print(f"{self.tiles_stg=}")
            # print(f"{list(self.tiles_stg)[:5]=}")

        self.df_calendar_stg = self.df_calendar_stg.loc[
            (self.list_dates[0] <= self.df_calendar_stg["C_Date"])
            & (self.df_calendar_stg["C_Date"] <= self.list_dates[-1])
            #  & (self.df_calendar_stg["STAT Holiday"] == 1)
            ]
        self.holidays_stg = self.df_calendar_stg.dropna(subset=["C_HolidayName"]).set_index("C_Date")[
            "C_HolidayName"].to_dict()
        self.work_holidays_stg = self.df_calendar_stg.loc[
            self.df_calendar_stg["C_STATHoliday"] == 1
            ].dropna(subset=["C_HolidayName"]).set_index("C_Date")["C_HolidayName"].to_dict()

        self.df_calendar_bws = self.df_calendar_bws.loc[
            (self.list_dates[0] <= self.df_calendar_bws["C_Date"])
            & (self.df_calendar_bws["C_Date"] <= self.list_dates[-1])
            #  & (self.df_calendar_stg["STAT Holiday"] == 1)
            ]
        self.holidays_bws = self.df_calendar_bws.dropna(subset=["C_HolidayName"]).set_index("C_Date")[
            "C_HolidayName"].to_dict()
        self.work_holidays_bws = self.df_calendar_bws.loc[
            self.df_calendar_bws["C_STATHoliday"] == 1
            ].dropna(subset=["C_HolidayName"]).set_index("C_Date")["C_HolidayName"].to_dict()

        if self.settings["TEST_MODE"].get():
            print(f"{self.df_calendar_stg=}")
            print(f"{self.holidays_stg=}")
            print(f"{self.work_holidays_stg=}")

            print(f"{self.df_calendar_bws=}")
            print(f"{self.holidays_bws=}")
            print(f"{self.work_holidays_bws=}")

        # list_weekend_days = [d for d in self.list_dates if (d.weekday() >= 5)]
        # n_weekend_days = len(list_weekend_days)
        # n_weekdays = self.n_cols - n_weekend_days

        # TODO fix variable column sizing
        canvas_width_scroll_stg = self.tile_width_stg * self.n_cols  # old method
        canvas_width_scroll_bws = self.tile_width_bws * self.n_cols  # old method
        self.canvas_width_scroll_region_stg = canvas_width_scroll_stg
        self.canvas_width_scroll_region_bws = canvas_width_scroll_bws
        self.canvas_height_scroll_region_stg = self.tile_height_stg * self.n_rows_stg
        self.canvas_height_scroll_region_bws = self.tile_height_bws * self.n_rows_bws

        # self.calc_grid_cells_stg = utility.grid_cells(
        #     self.canvas_width_scroll_region_stg,
        #     self.n_cols + 1,
        #     self.canvas_height_scroll_region_stg,
        #     self.n_rows_stg,
        #     r_type=list
        # )
        if self.settings["TEST_MODE"].get():
            print(f"{self.n_cols=}, {self.n_rows_stg=}")
            print(f"{self.n_cols=}, {self.n_rows_bws=}")
        self.date_is_weekend = list()
        self.calc_grid_cells_stg = self.calc_daily_grid_cells(
            self.list_dates[0],
            self.list_dates[-1],
            self.df_calendar_stg,
            self.canvas_width_scroll_region_stg,
            self.canvas_height_scroll_region_stg,
            n_rows=self.n_rows_stg,
            company=COMPANY.STG.value
        )
        # print(f"{self.calc_grid_cells_stg=}")
        self.calc_grid_cells_bws = self.calc_daily_grid_cells(
            self.list_dates[0],
            self.list_dates[-1],
            self.df_calendar_bws,
            self.canvas_width_scroll_region_stg,
            self.canvas_height_scroll_region_bws,
            n_rows=self.n_rows_bws,
            company=COMPANY.BWS.value
        )
        if self.settings["TEST_MODE"].get():
            print(f"{len(self.calc_grid_cells_stg)=}")
            print(f"{len(self.calc_grid_cells_stg[0])=}")
            print(f"{len(self.calc_grid_cells_bws)=}")
            print(f"{len(self.calc_grid_cells_bws[0])=}")
            # print(f"{self.calc_grid_cells_bws=}")

        self.canvas_stg = ctk.CTkCanvas(
            self.frame_canvas,
            width=self.canvas_width,
            height=self.canvas_height,
            background=self.colour_calendar_background.hex_code,
            scrollregion=(
                0,
                0,
                self.canvas_width_scroll_region_stg,
                self.canvas_height_scroll_region_stg
            )
        )
        self.canvas_bws = ctk.CTkCanvas(
            self.frame_canvas,
            width=self.canvas_width,
            height=self.canvas_height,
            background=self.colour_calendar_background.hex_code,
            scrollregion=(
                0,
                0,
                self.canvas_width_scroll_region_stg,
                self.canvas_height_scroll_region_bws
            )
        )
        self.scroll_bar_x = ctk.CTkScrollbar(
            self.frame_canvas,
            orientation="horizontal",
            command=self.scroll_x_calendar
        )

        self.invisible_canvas = ctk.CTkCanvas(
            self.frame_calendar,
            width=self.calc_geometry["width"],
            height=self.calc_geometry["height"],
            background=self.colour_background_root_canvas.hex_code,
            scrollregion=(
                0,
                0,
                self.calc_geometry["width"],
                self.calc_geometry["height"]
            )
        )

        # High level message labels:
        self.tv_lbl_processing, self.lbl_processing = tkinter_utility.label_factory(
            self.invisible_canvas,
            tv_label="processing",
            kwargs_label={
                "fg": self.colour_foreground_processing_label.hex_code,
                "bg": self.colour_background_processing_label.hex_code,
                "font": self.font_foreground_processing_label
            }
        )

        ###################
        # STARGATE ORDERS #
        ###################

        # rest of the tiles_stg
        for i, row in enumerate(self.calc_grid_cells_stg[1:]):
            # print(f"{i=}, {row=}")
            for j, col in enumerate(row[1:]):
                prod_line = self.list_prod_lines_stg[i]
                date = self.list_dates[j]
                # is_weekend = date.weekday() >= 5
                is_weekend = self.is_valid_prod_date(date) == "weekend"
                # print(f"{date=}, {prod_line=}, {is_weekend=}")
                if is_weekend:
                    tile_colour = self.colour_tile_background_weekend
                    tile_outline = self.colour_tile_outline_weekend
                    tile_outline_width = self.width_tile_outline_weekend
                    font = self.font_tile_weekend
                else:
                    tile_colour = self.colour_tile_background
                    tile_outline = self.colour_tile_outline
                    tile_outline_width = self.width_tile_outline
                    font = self.font_tile
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
                    parent=self.canvas_stg
                )
                self.tiles_stg[date][prod_line].update({
                    "tile": tile,
                    "texts": []
                })

        # loop orders and populate the calendar
        self.concats_rest_orders_stg = []
        self.concats_multi_combobox_orders_stg = []
        self.concats_rest_orders_to_multi_combobox_stg = []
        self.concats_double_entries_stg = []
        self.min_date_stg, self.max_date_stg = None, None
        self.min_line_stg, self.max_line_stg = None, None
        for i, row in self.df_orders_stg.iterrows():
            no_fit = False
            double = False
            # mc_append_row = None
            dat_quote = row.get(self.quote_key("quote"), "QUOTE=____")
            # print(f"{dat_quote=}, {row['InputField2'].tolist()=}")
            dat_wo = row.get(self.quote_key("wo"), "WO=____")
            dat_sn = row.get(self.quote_key("sn"), "")
            dat_dealer = row.get(self.quote_key("dealer"), "DEALER=____")
            dat_galv = row.get(self.quote_key("galv"), "GALV=____")
            dat_model = row.get(self.quote_key("model"), "MODEL=____")
            dat_cust_wo = row.get(self.quote_key("Customer WO#"), "CUSTWO=____")
            date = row.get("Available Date", None)
            prod_line = row.get("JobStartLine", None)
            self.df_ids_to_date_line_stg[i] = (date, prod_line)
            if prod_line == "":
                prod_line = None

            if self.settings["TEST_MODE"].get():
                print(f"{dat_quote=}, {date=}, {prod_line=}", end="")
                # print(f"{dat_dealer=}")

            if date is not None and prod_line is not None:
                if self.first_date <= date <= self.last_date:
                    # place this tile with date and prod_line

                    idx_pl = self.list_prod_lines_stg.index(prod_line)

                    if (self.min_date_stg is None) or (date < self.min_date_stg):
                        self.min_date_stg = date
                    if (self.max_date_stg is None) or (date > self.max_date_stg):
                        self.max_date_stg = date
                    if (self.min_line_stg is None) or (idx_pl < self.min_line_stg):
                        self.min_line_stg = idx_pl
                    if (self.max_line_stg is None) or (idx_pl > self.max_line_stg):
                        self.max_line_stg = idx_pl

                    if self.settings["TEST_MODE"].get():
                        print(f"\tFITS")

                    tile_data = self.tiles_stg[date][prod_line]
                    if 'tile' not in tile_data:
                        print(f"{tile_data=}")
                    col = self.canvas_stg.bbox(tile_data["tile"])
                    # prev_texts = tile_data.get("texts", [])
                    tile_text_colour = self.colour_tile_foreground
                    font = self.font_tile
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
                    if self.tiles_stg[date][prod_line].get("order"):

                        if self.settings["TEST_MODE"].get():
                            print(f">>> {dat_quote=}, {date=}, {prod_line=} already has an order!!!!")

                        no_fit = True
                        double = True
                    else:
                        self.tiles_stg[date][prod_line].update({
                            "order": i,
                            "texts": [
                                self.canvas_stg.create_text(
                                    int(col[0] + (self.tile_width_stg * 0.5)),
                                    int(col[1] + ((k + 1) * self.tile_height_stg / (1 + len(to_do_texts)))),
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

                    if self.settings["TEST_MODE"].get():
                        print(f"\tDOESNT FIT")

                    # mc_append_row = []
                    new_row_data = {k: [v] for k, v in row.items()}
                    new_df = pd.DataFrame(new_row_data, index=[self.df_rest_orders_stg.shape[0]])
                    self.concats_rest_orders_stg.append(new_df)

                    if self.settings["TEST_MODE"].get():
                        # print(f"\n\tBEFORE\n\nnew_df={new_df}\n\nself.df_rest_orders_stg={self.df_rest_orders_stg}")
                        # self.df_rest_orders_stg = pd.concat([self.df_rest_orders_stg, new_df], ignore_index=True)
                        # print(f"\n\tAFTER\n\nnew_df={new_df}\n\nself.df_rest_orders_stg={self.df_rest_orders_stg}")
                        pass

                    if double:
                        new_df = pd.DataFrame(new_row_data, index=[self.df_rest_orders_stg.shape[0]])
                        self.concats_double_entries_stg.append(new_df)
            else:
                # add this order to the combobox for placing

                if self.settings["TEST_MODE"].get():
                    print(f"\tCOMBOBOX")

                new_row_data = {k: [v] for k, v in zip(self.df_multi_combobox_data_orders_stg.columns,
                                                       [dat_quote, dat_wo, dat_model, dat_dealer, dat_sn, dat_cust_wo])}
                new_df = pd.DataFrame(new_row_data)
                # self.df_multi_combobox_data_orders_stg = pd.concat([self.df_multi_combobox_data_orders_stg, new_df], ignore_index=True)
                self.concats_multi_combobox_orders_stg.append(new_df)

        # TODO add self.concats_rest_orders_stg to self.concats_multi_combobox_orders_stg
        if self.concats_rest_orders_stg:
            self.df_rest_orders_stg = pd.concat(self.concats_rest_orders_stg, ignore_index=True)

            for i, row in self.df_rest_orders_stg.iterrows():
                dat_quote = row.get(self.quote_key("quote"), "QUOTE=____")
                # print(f"{dat_quote=}, {row['InputField2'].tolist()=}")
                dat_wo = row.get(self.quote_key("wo"), "WO=____")
                dat_sn = row.get(self.quote_key("sn"), "")
                dat_dealer = row.get(self.quote_key("dealer"), "DEALER=____")
                dat_galv = row.get(self.quote_key("galv"), "GALV=____")
                dat_model = row.get(self.quote_key("model"), "MODEL=____")
                dat_cust_wo = row.get(self.quote_key("Customer WO#"), "CUSTWO=____")
                new_row_data = {k: [v] for k, v in zip(self.df_multi_combobox_data_orders_stg.columns,
                                                       [dat_quote, dat_wo, dat_model, dat_dealer, dat_sn, dat_cust_wo])}
                new_df = pd.DataFrame(new_row_data)
                self.concats_rest_orders_to_multi_combobox_stg.append(new_df)

        #     self.df_multi_combobox_data_orders_stg = pd.concat(self.concats_rest_orders_stg, ignore_index=True)
        if self.concats_multi_combobox_orders_stg:
            self.concats_multi_combobox_orders_stg = self.concats_rest_orders_to_multi_combobox_stg + self.concats_multi_combobox_orders_stg
            self.df_multi_combobox_data_orders_stg = pd.concat(self.concats_multi_combobox_orders_stg, ignore_index=True)
            # self.df_multi_combobox_data_orders_stg["Customer WO#"] = self.df_multi_combobox_data_orders_stg[
            #     "Customer WO#"].apply(lambda x: int(x) if not pd.isna(x) else x)
            # self.df_multi_combobox_data_orders_stg["Customer WO#"] = pd.to_numeric(self.df_multi_combobox_data_orders_stg["Customer WO#"], errors='coerce').astype('Int64')
            self.df_multi_combobox_data_orders_stg["Customer WO#"] = (
                self.df_multi_combobox_data_orders_stg["Customer WO#"].apply(
                    lambda x: str(x).rstrip('.0') if pd.notnull(x) else ''
                )
            )
            if self.settings["TEST_MODE"].get():
                print(f"{self.df_multi_combobox_data_orders_stg=}")

            # if mc_append_row:
            #     # add new row record to mc
            #     pass

        if self.settings["TEST_MODE"].get():
            print(f"STG")
            print(f"self.df_orders==\n{self.df_orders_stg}")
            print(f"self.df_rest_orders==\n{self.df_rest_orders_stg}")
            print(f"self.df_multi_combobox_data_orders==\n{self.df_multi_combobox_data_orders_stg}")
            print(f"self.df_rest_orders.columns==\n{list(self.df_rest_orders_stg.columns)}")
            print(
                f"self.df_multi_combobox_data_orders.columns==\n{list(self.df_multi_combobox_data_orders_stg.columns)}")

        # header row
        for i, row in enumerate(self.calc_grid_cells_stg[:1]):
            for j, col in enumerate(row[1:]):
                # print(f"{i=}, {j=}")
                # prod_line = self.list_prod_lines_stg[i]
                key = "date_legend"
                date = self.list_dates[j]
                # is_holiday = date in self.holidays_stg
                holiday_name = self.holidays_stg.get(date, None)
                tile_colour = self.colour_tile_header_row_background
                tile_text_colour = self.colour_tile_header_row_foreground
                font = self.font_tile
                tile_outline = self.colour_tile_outline
                tile_outline_width = self.width_tile_outline
                to_do_texts = [
                    f"{date:%A}",  # Day of Week
                    f"{date:%B}",  # Month
                    f"{date:%d}".removeprefix("0") + f"{utility.number_suffix(date.day)}",
                    # Numerical month date
                    f"{date:%Y}"  # Year
                ]
                if holiday_name is not None:
                    to_do_texts.append(holiday_name)
                    non_prod_day = self.is_valid_prod_date(date) == "holiday"
                    # print(f"Check {date=} -- {non_prod_day=}")
                    if non_prod_day:
                        to_do_texts.append(self.txt_non_prod_day)
                        tile_colour = tile_colour.darkened(0.1)
                        for k, k_line in enumerate(self.list_prod_lines_stg):
                            # print(f"{k=}, {k_line=}")
                            self.canvas_stg.itemconfigure(
                                self.tiles_stg[date][k_line]["tile"],
                                fill=self.colour_tile_background_non_prod.hex_code
                            )
                if key not in self.tiles_stg[date]:
                    self.tiles_stg[date][key] = dict()
                self.tiles_stg[date][key].update({
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
                        parent=self.canvas_stg
                    ),
                    "texts": [
                        self.canvas_stg.create_text(
                            int(col[0] + (self.tile_width_stg * 0.5)),
                            int(col[1] + ((k + 1) * self.tile_height_stg / (1 + len(to_do_texts)))),
                            text=txt,
                            fill=tile_text_colour.hex_code,
                            font=font
                        )
                        for k, txt, in enumerate(to_do_texts)
                    ]
                })
                if holiday_name is not None:
                    self.canvas_stg.itemconfigure(self.tiles_stg[date][key]["texts"][-1],
                                                  fill=self.colour_foreground_holiday.hex_code)
                    text = self.canvas_stg.itemcget(self.tiles_stg[date][key]["texts"][-1], "text")
                    if text == self.txt_non_prod_day:
                        self.canvas_stg.itemconfigure(self.tiles_stg[date][key]["texts"][-2],
                                                      fill=self.colour_foreground_holiday.hex_code)

        # header columns
        for i, row in enumerate(self.calc_grid_cells_stg[1:]):
            for j, col in enumerate(row[:1]):
                # i, j = i + 1, j + 1  # enumeration from second element will offset the data
                # print(f"{i=}, {j=}")
                prod_line = self.list_prod_lines_stg[i]
                # date = self.list_dates[j]
                key = "line_legend"
                tile_colour = self.colour_tile_header_col_background
                tile_text_colour = self.colour_tile_header_col_foreground
                font = self.font_tile
                tile_outline = self.colour_tile_outline
                tile_outline_width = self.width_tile_outline
                to_do_texts = [
                    prod_line
                ]
                if key not in self.tiles_stg:
                    if self.settings["TEST_MODE"].get():
                        print(f"ADDING KEY {key=}")
                    self.tiles_stg[key] = dict()
                if prod_line not in self.tiles_stg:
                    if self.settings["TEST_MODE"].get():
                        print(f"ADDING SUB KEY {prod_line=}")
                    self.tiles_stg[key][prod_line] = dict()
                self.tiles_stg[key][prod_line].update({
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
                        parent=self.canvas_stg
                    ),
                    "texts": [
                        self.canvas_stg.create_text(
                            int(col[0] + (self.tile_width_stg * 0.5)),
                            int(col[1] + ((k + 1) * self.tile_height_stg / (1 + len(to_do_texts)))),
                            text=txt,
                            fill=tile_text_colour.hex_code,
                            font=font
                        )
                        for k, txt, in enumerate(to_do_texts)
                    ]
                })

        ##############
        # BWS ORDERS #
        ##############
        # rest of the tiles_stg
        for i, row in enumerate(self.calc_grid_cells_bws[1:]):
            # print(f"{i=}, {row=}")
            for j, col in enumerate(row[1:]):
                prod_line = self.list_prod_lines_bws[i]
                date = self.list_dates[j]
                # is_weekend = date.weekday() >= 5
                is_weekend = self.is_valid_prod_date(date) == "weekend"
                # print(f"{date=}, {prod_line=}, {is_weekend=}")
                if is_weekend:
                    tile_colour = self.colour_tile_background_weekend
                    tile_outline = self.colour_tile_outline_weekend
                    tile_outline_width = self.width_tile_outline_weekend
                    font = self.font_tile_weekend
                else:
                    tile_colour = self.colour_tile_background
                    tile_outline = self.colour_tile_outline
                    tile_outline_width = self.width_tile_outline
                    font = self.font_tile
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
                    parent=self.canvas_bws
                )
                self.tiles_bws[date][prod_line].update({
                    "tile": tile,
                    "texts": []
                })

        # loop orders and populate the calendar
        self.concats_rest_orders_bws = []
        self.concats_multi_combobox_orders_bws = []
        self.concats_rest_orders_to_multi_combobox_bws = []
        self.concats_double_entries_bws = []
        self.min_date_bws, self.max_date_bws = None, None
        self.min_line_bws, self.max_line_bws = None, None
        for i, row in self.df_orders_bws.iterrows():
            no_fit = False
            double = False
            # mc_append_row = None
            dat_quote = row.get(self.quote_key("quote", COMPANY.BWS.value), "QUOTE=____")
            # print(f"{dat_quote=}, {row['InputField2'].tolist()=}")
            dat_wo = row.get(self.quote_key("wo", COMPANY.BWS.value), "WO=____")
            dat_sn = row.get(self.quote_key("sn", COMPANY.BWS.value), "")
            dat_dealer = row.get(self.quote_key("dealer", COMPANY.BWS.value), "DEALER=____")
            dat_galv = row.get(self.quote_key("galv", COMPANY.BWS.value), "GALV=____")
            dat_model = row.get(self.quote_key("model", COMPANY.BWS.value), "MODEL=____")
            dat_cust_wo = row.get(self.quote_key("Customer WO#", COMPANY.BWS.value), "CUSTWO=____")
            date = row.get("Prod Date", None)
            prod_line = row.get("Prod Line", None)
            self.df_ids_to_date_line_bws[i] = (date, prod_line)
            if prod_line == "":
                prod_line = None

            if self.settings["TEST_MODE"].get():
                print(f"{dat_quote=}, {date=}, {prod_line=}", end="")
                # print(f"{dat_dealer=}")

            if date is not None and prod_line is not None:
                if self.first_date <= date <= self.last_date:
                    # place this tile with date and prod_line

                    idx_pl = self.list_prod_lines_bws.index(prod_line)

                    if (self.min_date_bws is None) or (date < self.min_date_bws):
                        self.min_date_bws = date
                    if (self.max_date_bws is None) or (date > self.max_date_bws):
                        self.max_date_bws = date
                    if (self.min_line_bws is None) or (idx_pl < self.min_line_bws):
                        self.min_line_bws = idx_pl
                    if (self.max_line_bws is None) or (idx_pl > self.max_line_bws):
                        self.max_line_bws = idx_pl

                    if self.settings["TEST_MODE"].get():
                        print(f"\tFITS")

                    tile_data = self.tiles_bws[date][prod_line]
                    if 'tile' not in tile_data:
                        print(f"{tile_data=}")
                    col = self.canvas_bws.bbox(tile_data["tile"])
                    # prev_texts = tile_data.get("texts", [])
                    tile_text_colour = self.colour_tile_foreground
                    font = self.font_tile
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
                    if self.tiles_bws[date][prod_line].get("order"):

                        if self.settings["TEST_MODE"].get():
                            print(f">>> {dat_quote=}, {date=}, {prod_line=} already has an order!!!!")

                        no_fit = True
                        double = True
                    else:
                        self.tiles_bws[date][prod_line].update({
                            "order": i,
                            "texts": [
                                self.canvas_bws.create_text(
                                    int(col[0] + (self.tile_width_bws * 0.5)),
                                    int(col[1] + ((k + 1) * self.tile_height_bws / (1 + len(to_do_texts)))),
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

                    if self.settings["TEST_MODE"].get():
                        print(f"\tDOESNT FIT")

                    # mc_append_row = []
                    new_row_data = {k: [v] for k, v in row.items()}
                    new_df = pd.DataFrame(new_row_data, index=[self.df_rest_orders_bws.shape[0]])
                    self.concats_rest_orders_bws.append(new_df)

                    if self.settings["TEST_MODE"].get():
                        # print(f"\n\tBEFORE\n\nnew_df={new_df}\n\nself.df_rest_orders_stg={self.df_rest_orders_stg}")
                        # self.df_rest_orders_stg = pd.concat([self.df_rest_orders_stg, new_df], ignore_index=True)
                        # print(f"\n\tAFTER\n\nnew_df={new_df}\n\nself.df_rest_orders_stg={self.df_rest_orders_stg}")
                        pass

                    if double:
                        new_df = pd.DataFrame(new_row_data, index=[self.df_rest_orders_bws.shape[0]])
                        self.concats_double_entries_bws.append(new_df)
            else:
                # add this order to the combobox for placing

                if self.settings["TEST_MODE"].get():
                    print(f"\tCOMBOBOX")

                new_row_data = {k: [v] for k, v in zip(self.df_multi_combobox_data_orders_bws.columns,
                                                       [dat_quote, dat_wo, dat_model, dat_dealer, dat_sn,
                                                        dat_cust_wo])}
                new_df = pd.DataFrame(new_row_data)
                # self.df_multi_combobox_data_orders_stg = pd.concat([self.df_multi_combobox_data_orders_stg, new_df], ignore_index=True)
                self.concats_multi_combobox_orders_bws.append(new_df)

        # TODO add self.concats_rest_orders_stg to self.concats_multi_combobox_orders_stg
        if self.concats_rest_orders_bws:
            self.df_rest_orders_bws = pd.concat(self.concats_rest_orders_bws, ignore_index=True)

            for i, row in self.df_rest_orders_bws.iterrows():
                dat_quote = row.get(self.quote_key("quote", COMPANY.BWS.value), "QUOTE=____")
                # print(f"{dat_quote=}, {row['InputField2'].tolist()=}")
                dat_wo = row.get(self.quote_key("wo", COMPANY.BWS.value), "WO=____")
                dat_sn = row.get(self.quote_key("sn", COMPANY.BWS.value), "")
                dat_dealer = row.get(self.quote_key("dealer", COMPANY.BWS.value), "DEALER=____")
                dat_galv = row.get(self.quote_key("galv", COMPANY.BWS.value), "GALV=____")
                dat_model = row.get(self.quote_key("model", COMPANY.BWS.value), "MODEL=____")
                dat_cust_wo = row.get(self.quote_key("Customer WO#", COMPANY.BWS.value), "CUSTWO=____")
                new_row_data = {k: [v] for k, v in zip(self.df_multi_combobox_data_orders_bws.columns,
                                                       [dat_quote, dat_wo, dat_model, dat_dealer, dat_sn,
                                                        dat_cust_wo])}
                new_df = pd.DataFrame(new_row_data)
                self.concats_rest_orders_to_multi_combobox_bws.append(new_df)

        #     self.df_multi_combobox_data_orders_stg = pd.concat(self.concats_rest_orders_stg, ignore_index=True)
        if self.concats_multi_combobox_orders_bws:
            self.concats_multi_combobox_orders_bws = self.concats_rest_orders_to_multi_combobox_bws + self.concats_multi_combobox_orders_bws
            self.df_multi_combobox_data_orders_bws = pd.concat(self.concats_multi_combobox_orders_bws,
                                                               ignore_index=True)
            # self.df_multi_combobox_data_orders_stg["Customer WO#"] = self.df_multi_combobox_data_orders_stg[
            #     "Customer WO#"].apply(lambda x: int(x) if not pd.isna(x) else x)
            # self.df_multi_combobox_data_orders_stg["Customer WO#"] = pd.to_numeric(self.df_multi_combobox_data_orders_stg["Customer WO#"], errors='coerce').astype('Int64')
            self.df_multi_combobox_data_orders_bws["Customer WO#"] = (
                self.df_multi_combobox_data_orders_bws["Customer WO#"].apply(
                    lambda x: str(x).rstrip('.0') if pd.notnull(x) else ''
                )
            )
            # print(f"{self.df_multi_combobox_data_orders_bws=}")

            # if mc_append_row:
            #     # add new row record to mc
            #     pass

        if self.settings["TEST_MODE"].get():
            print(f"BWS")
            print(f"self.df_orders==\n{self.df_orders_bws}")
            print(f"self.df_rest_orders==\n{self.df_rest_orders_bws}")
            print(f"self.df_multi_combobox_data_orders==\n{self.df_multi_combobox_data_orders_bws}")
            print(f"self.df_rest_orders.columns==\n{list(self.df_rest_orders_bws.columns)}")
            print(
                f"self.df_multi_combobox_data_orders.columns==\n{list(self.df_multi_combobox_data_orders_bws.columns)}")

            print(f"{self.list_prod_lines_stg=}")
            print(f"{self.list_prod_lines_bws=}")
            print(f"{self.tiles_stg=}")
            print(f"{self.tiles_bws=}")

        # header row
        for i, row in enumerate(self.calc_grid_cells_bws[:1]):
            for j, col in enumerate(row[1:]):
                if self.settings["TEST_MODE"].get():
                    print(f"{i=}, {j=}")
                # prod_line = self.list_prod_lines_stg[i]
                key = "date_legend"
                date = self.list_dates[j]
                # is_holiday = date in self.holidays_stg
                holiday_name = self.holidays_bws.get(date, None)
                tile_colour = self.colour_tile_header_row_background
                tile_text_colour = self.colour_tile_header_row_foreground
                font = self.font_tile
                tile_outline = self.colour_tile_outline
                tile_outline_width = self.width_tile_outline
                to_do_texts = [
                    f"{date:%A}",  # Day of Week
                    f"{date:%B}",  # Month
                    f"{date:%d}".removeprefix("0") + f"{utility.number_suffix(date.day)}",
                    # Numerical month date
                    f"{date:%Y}"  # Year
                ]
                if holiday_name is not None:
                    to_do_texts.append(holiday_name)
                    non_prod_day = self.is_valid_prod_date(date) == "holiday"
                    print(f"Check {date=} -- {non_prod_day=}")
                    if non_prod_day:
                        to_do_texts.append(self.txt_non_prod_day)
                        tile_colour = tile_colour.darkened(0.1)
                        for k, k_line in enumerate(self.list_prod_lines_bws):
                            print(f"{k=}, {k_line=}")
                            self.canvas_bws.itemconfigure(
                                self.tiles_bws[date][k_line]["tile"],
                                fill=self.colour_tile_background_non_prod.hex_code
                            )
                if key not in self.tiles_bws[date]:
                    self.tiles_bws[date][key] = dict()
                self.tiles_bws[date][key].update({
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
                        parent=self.canvas_bws
                    ),
                    "texts": [
                        self.canvas_bws.create_text(
                            int(col[0] + (self.tile_width_bws * 0.5)),
                            int(col[1] + ((k + 1) * self.tile_height_bws / (1 + len(to_do_texts)))),
                            text=txt,
                            fill=tile_text_colour.hex_code,
                            font=font
                        )
                        for k, txt, in enumerate(to_do_texts)
                    ]
                })
                if holiday_name is not None:
                    self.canvas_bws.itemconfigure(self.tiles_bws[date][key]["texts"][-1],
                                                  fill=self.colour_foreground_holiday.hex_code)
                    text = self.canvas_bws.itemcget(self.tiles_bws[date][key]["texts"][-1], "text")
                    if text == self.txt_non_prod_day:
                        self.canvas_bws.itemconfigure(self.tiles_bws[date][key]["texts"][-2],
                                                      fill=self.colour_foreground_holiday.hex_code)

        # header columns
        for i, row in enumerate(self.calc_grid_cells_bws[1:]):
            for j, col in enumerate(row[:1]):
                # i, j = i + 1, j + 1  # enumeration from second element will offset the data
                # print(f"{i=}, {j=}")
                prod_line = self.list_prod_lines_bws[i]
                # date = self.list_dates[j]
                key = "line_legend"
                tile_colour = self.colour_tile_header_col_background
                tile_text_colour = self.colour_tile_header_col_foreground
                font = self.font_tile
                tile_outline = self.colour_tile_outline
                tile_outline_width = self.width_tile_outline
                to_do_texts = [
                    prod_line
                ]
                if key not in self.tiles_bws:
                    if self.settings["TEST_MODE"].get():
                        print(f"ADDING KEY {key=}")
                    self.tiles_bws[key] = dict()
                if prod_line not in self.tiles_bws:
                    if self.settings["TEST_MODE"].get():
                        print(f"ADDING SUB KEY {prod_line=}")
                    self.tiles_bws[key][prod_line] = dict()
                self.tiles_bws[key][prod_line].update({
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
                        parent=self.canvas_bws
                    ),
                    "texts": [
                        self.canvas_bws.create_text(
                            int(col[0] + (self.tile_width_bws * 0.5)),
                            int(col[1] + ((k + 1) * self.tile_height_bws / (1 + len(to_do_texts)))),
                            text=txt,
                            fill=tile_text_colour.hex_code,
                            font=font
                        )
                        for k, txt, in enumerate(to_do_texts)
                    ]
                })




        print(f"{self.min_date_stg=}, {self.max_date_stg=}")
        print(f"{self.list_prod_lines_stg[self.min_line_stg]=}, {self.list_prod_lines_stg[self.max_line_stg]=}")
        print(f"{self.min_date_bws=}, {self.max_date_bws=}")
        print(f"{self.list_prod_lines_bws[self.min_line_bws]=}, {self.list_prod_lines_bws[self.max_line_bws]=}")


































        # check colour coding
        self.colour_code()

        # top left 'home' cell
        try:
            self.stg_logo_image = Image.open(r"C:\Access\Stargate Logo 50%.jpg")
            self.stg_logo_image = ImageTk.PhotoImage(
                self.stg_logo_image.resize(
                    (
                        # max(int(self.tile_width_bws), int(self.tile_width_stg)),
                        # max(int(self.tile_height_bws), int(self.tile_height_stg))
                        int(self.tile_width_stg),
                        int(self.tile_height_stg)
                    ),
                    # Image.ANTIALIAS
                    Image.LANCZOS
                )
            )
        except FileNotFoundError:
            self.stg_logo_image = None

        try:
            self.bws_logo_image = Image.open(r"C:\Access\BWS Chrome Final WO Manufacturing.jpg")
            self.bws_logo_image = ImageTk.PhotoImage(
                self.bws_logo_image.resize(
                    (
                        int(self.tile_width_bws),
                        int(self.tile_height_bws)
                    ),
                    # Image.ANTIALIAS
                    Image.LANCZOS
                )
            )
        except FileNotFoundError:
            self.bws_logo_image = None

        if self.stg_logo_image:
            self.tiles_stg["home"]["tile"] = self.canvas_stg.create_image(
                self.calc_grid_cells_stg[0][0][0] + (self.tile_width_stg / 2),
                self.calc_grid_cells_stg[0][0][1] + (self.tile_height_stg / 2),
                anchor=ctk.CENTER,
                image=self.stg_logo_image
            )
        else:
            self.tiles_stg["home"]["tile"] = self.draw_rect(
                self.calc_grid_cells_stg[0][0],
                fill=self.colour_tile_header_home_background.hex_code,
                parent=self.canvas_stg
            )

        # print(f"{self.calc_grid_cells_bws=}")

        if self.bws_logo_image:
            self.tiles_bws["home"]["tile"] = self.canvas_bws.create_image(
                self.calc_grid_cells_bws[0][0][0] + (self.tile_width_bws / 2),
                self.calc_grid_cells_bws[0][0][1] + (self.tile_height_bws / 2),
                anchor=ctk.CENTER,
                image=self.bws_logo_image
            )
        else:
            self.tiles_bws["home"]["tile"] = self.draw_rect(
                self.calc_grid_cells_bws[0][0],
                fill=self.colour_tile_header_home_background.hex_code,
                parent=self.canvas_bws
            )

        self.multi_combobox_orders_stg.add_new_item(self.df_multi_combobox_data_orders_stg)
        self.multi_combobox_orders_bws.add_new_item(self.df_multi_combobox_data_orders_bws)

        self.bg_info_frame = Colour("SystemButtonFace")
        self.info_frame_stg = tkinter_utility.InfoFrame(
            self.frame_info_frame,
            labels=self.info_frame_columns_stg,
            auto_grid=True,
            header="Quote Information STG:",
            key_width=16,
            val_width=50,
            width=150,
            background=self.bg_info_frame.hex_code,
            padx=10,
            pady=10,
            cell_border=True,
            key_label_keywords={
                "font": "Arial 12 bold",
                "bg": self.bg_info_frame.brightened(0.25).hex_code
            },
            value_label_keywords={
                "font": "Arial 12 bold",
                "bg": self.bg_info_frame.brightened(0.25).hex_code
            },
            header_kwargs={
                "font": "Arial 18 bold",
                "bg": self.bg_info_frame.hex_code
            },
            formats={
                "Prod Date": lambda d: d.strftime("%Y-%m-%d"),
                # "Delivery Date (Est)": lambda d: d.strftime("%Y-%m-%d"),
                "Sched Finish": lambda d: d.strftime("%Y-%m-%d")
            }
        )
        self.tv_btn_if_goto_stg, self.btn_if_goto_stg = customtkinter_utility.button_factory(
            self.info_frame_stg.frame_header,
            tv_btn="Go To",
            command=self.click_if_goto
        )
        ga = {k: v for k, v in self.info_frame_stg.grid_args["header"].items()}
        ga.update({"columnspan": 1, "column": 0})
        self.info_frame_stg.header[1].grid_forget()
        self.info_frame_stg.header[1].grid(**ga)
        ga.update({"columnspan": 1, "column": 1, "padx": 110})
        self.btn_if_goto_stg.grid(**ga)

        self.info_frame_bws = tkinter_utility.InfoFrame(
            self.frame_info_frame,
            labels=self.info_frame_columns_bws,
            auto_grid=True,
            header="Quote Information BWS:",
            key_width=16,
            val_width=50,
            width=150,
            background=self.bg_info_frame.hex_code,
            padx=10,
            pady=10,
            cell_border=True,
            key_label_keywords={
                "font": "Arial 12 bold",
                "bg": self.bg_info_frame.brightened(0.25).hex_code
            },
            value_label_keywords={
                "font": "Arial 12 bold",
                "bg": self.bg_info_frame.brightened(0.25).hex_code
            },
            header_kwargs={
                "font": "Arial 18 bold",
                "bg": self.bg_info_frame.hex_code
            },
            formats={
                "Prod Date": lambda d: d.strftime("%Y-%m-%d"),
                # "Delivery Date (Est)": lambda d: d.strftime("%Y-%m-%d"),
                "Sched Finish": lambda d: d.strftime("%Y-%m-%d")
            }
        )
        self.tv_btn_if_goto_bws, self.btn_if_goto_bws = customtkinter_utility.button_factory(
            self.info_frame_bws.frame_header,
            tv_btn="Go To",
            command=self.click_if_goto
        )
        ga = {k: v for k, v in self.info_frame_bws.grid_args["header"].items()}
        ga.update({"columnspan": 1, "column": 0})
        self.info_frame_bws.header[1].grid_forget()
        self.info_frame_bws.header[1].grid(**ga)
        ga.update({"columnspan": 1, "column": 1, "padx": 110})
        self.btn_if_goto_bws.grid(**ga)

        if (geo := self.calc_geometry["str"]) == "zoomed":
            self.state(geo)
            # self.attributes("-fullscreen", True)
        else:
            self.geometry(geo)
        print(f"{geo=}")

        self.tv_multi_combobox_drag_tile = ctk.BooleanVar(self, value=False)

        # transparent method
        # canvas_stg
        # https://stackoverflow.com/questions/53021603/how-to-make-a-tkinter-canvas-background-transparent
        self.set_invisible_canvas()

        self.drag_tile_start_pos = 200, 400
        self.multi_combobox_drag_tile = self.draw_rect(
            (
                *self.drag_tile_start_pos,
                100 + (self.tile_width_bws if (self.settings["mode_company"] == COMPANY.BWS.value) else self.tile_width_stg),
                100 + (self.tile_height_bws if (self.settings["mode_company"] == COMPANY.BWS.value) else self.tile_height_stg)
            ),
            fill=self.colour_fill_multi_combobox_drag_tile.hex_code,
            outline=self.colour_outline_multi_combobox_drag_tile.hex_code,
            parent=self.invisible_canvas
        )
        self.dot = self.invisible_canvas.create_oval(
            5, 5, 25, 25,
            fill=self.colour_test_dot.hex_code
        )
        self.multi_combobox_drag_tile_texts_placeholder = "PLACEHOLDER"
        self.multi_combobox_drag_tile_texts = [
            self.invisible_canvas.create_text(
                (self.drag_tile_start_pos[0] + ((100 + (self.tile_width_bws if (self.settings["mode_company"] == COMPANY.BWS.value) else self.tile_width_stg)) / 2)),
                (self.drag_tile_start_pos[1] + ((100 + (self.tile_height_bws if (self.settings["mode_company"] == COMPANY.BWS.value) else self.tile_height_stg)) / 2)),
                text=self.multi_combobox_drag_tile_texts_placeholder,
                fill=self.colour_tile_foreground.hex_code,
                font=self.font_tile
            )
        ]

        # scrollable listbox for event history
        self.frame_listbox_history = ctk.CTkFrame(self.frame_left_controls)
        self.listbox_history = tkinter.Listbox(
            self.frame_listbox_history,
            width=110
        )
        self.scroll_bar_history = ctk.CTkScrollbar(self.frame_listbox_history)
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
        self.bn_mousewheel_calendar = None
        self.bn_motion_calendar = None
        self.bn_lclickmotion_calendar = None
        self.bn_lclickmotion_invisible_canvas = None
        self.bn_lrelease_calendar = None
        self.bn_lclick_calendar = None
        self.bn_rrelease_calendar = None
        self.bn_ctlz = None
        self.bind_treeview_to_canvas()

        # traces
        self.tv_done_interact_tl.trace_variable("w", self.update_done_interact_tl)
        self.canvas_stg.configure(xscrollcommand=self.scroll_bar_x.set)
        self.canvas_bws.configure(xscrollcommand=self.scroll_bar_x.set)
        self.history.trace_variable("w", self.tv_update_history)
        self.multi_combobox_orders_stg.res_tv_entry.trace_remove("write",
                                                                 self.multi_combobox_orders_stg.trace_res_tv_entry)
        self.multi_combobox_orders_bws.res_tv_entry.trace_remove("write",
                                                                 self.multi_combobox_orders_bws.trace_res_tv_entry)
        self.multi_combobox_orders_stg.res_tv_entry.trace_add("write", self.multi_combobox_entry_update)
        self.multi_combobox_orders_bws.res_tv_entry.trace_add("write", self.multi_combobox_entry_update)
        self.multi_combobox_orders_stg.trace_res_tv_entry = self.multi_combobox_orders_stg.res_tv_entry.trace_add(
            "write",
            self.multi_combobox_orders_stg.update_entry)
        self.multi_combobox_orders_bws.trace_res_tv_entry = self.multi_combobox_orders_bws.res_tv_entry.trace_add(
            "write",
            self.multi_combobox_orders_bws.update_entry)
        self.tl_tv_switch_colour.trace_variable("w", self.update_colour_theme)
        self.tl_tv_switch_dark.trace_variable("w", self.update_light_dark_theme)
        self.tl_tv_switch_ask_monitors.trace_variable("w", self.update_ask_monitors)
        self.tl_tv_switch_allow_publish.trace_variable("w", self.update_allow_publish)
        self.tl_tv_count_tries_allow_publish.trace_variable("w", self.update_count_tries_allow_publish)
        self.tl_tv_switch_show_left_widgets.trace_variable("w", self.update_show_calendar_only)
        self.tl_tv_colour_code_priority.trace_variable("w", self.update_switch_colour_code_priority)
        self.tl_tv_colour_code_only_priority.trace_variable("w", self.update_switch_colour_code_only_priority)
        self.tl_tv_show_galvanized.trace_variable("w", self.update_show_galvanized)
        self.tv_allowed_comp_bws.trace_variable("w", self.update_allowed_comp_bws)
        self.tv_allowed_comp_stg.trace_variable("w", self.update_allowed_comp_stg)
        self.tv_allowed_companies.trace_variable("w", self.update_allowed_companies)

        self.tv_done_interact_tl.set(True)
        self.protocol("WM_DELETE_WINDOW", self.on_closing)
        self.tv_update_test_mode()
        self.update_allowed_comp_bws()
        self.update_allowed_comp_stg()
        print(f"{self.settings['mode_company']=}, {self.default_allowed_companies=}")
        self.switch_company(self.settings["mode_company"])
        # if self.settings["mode_company"] != self.default_allowed_companies[0]:
        #     # if not stargate on-load, then switch company
        #     self.switch_company(self.settings["mode_company"])
        self.after(1200, self.click_mb_go_to_today())
        # self.bind("<Control-Z>", self.undo)
        # self.canvas_stg.bind("<Control-z>", self.undo)
        # self.bind("<Ctrl-z>", self.undo)

        if self.settings["TEST_MODE"].get():
            print(f"{self.tiles_stg=}")
            print(f"{self.tiles_bws=}")

        in_test_mode = self.settings["TEST_MODE"].get()
        print(f"{self.settings['TEST_MODE'].get()=}")

        print(f"TEST_MODE={'Y' if in_test_mode else 'N'}")
        companies = list(map(lambda c: c.name, COMPANY))
        print(f"COMPANY={companies[self.settings['mode_company']]}")

    def quote_key(self, attr: str = "quote", comp_id: int = None) -> str:
        if comp_id is None:
            mc = self.settings["mode_company"]
        else:
            mc = comp_id
        # STG by default
        match attr.lower():
            case "dealer" | "inputfield2":
                return "InputField2"  # same for both companies
            case "galv" | "galvanized" | "isgalv":
                return "IsGalvanized" if (mc == COMPANY.BWS.value) else "IsGalv"
            case "wo" | "wo#":
                return "WO#" if (mc == COMPANY.BWS.value) else "OrdersV2_WO#"
            case "cust_wo" | "custwo" | "customer wo#":
                return "WO#" if (mc == COMPANY.BWS.value) else "Customer WO#"
            case "model" | "model no" | "inputfield1":
                return "InputField1"  # same for both companies
            case "serial" | "sn":
                return "Orders_Serial Number" if (mc == COMPANY.BWS.value) else "Serial Number"
            case "ussale" | "us sale" | "us":
                return "Orders_US Sale" if (mc == COMPANY.BWS.value) else "US Sale"  # same for both companies
            case "delivery date":
                return "Orders_Delivery Date" if (mc == COMPANY.BWS.value) else "Delivery Date"
            case _:
                return "Quote#" if (mc == COMPANY.BWS.value) else "OrdersV2_SGQuote"

    def calculate_nth_business_day(
            self,
            date: datetime.datetime | pd.Timestamp,
            n_days: int
    ):
        mc = self.settings["mode_company"]
        if mc == COMPANY.BWS.value:
            sql = f"SELECT [SysproCompanyA].[dbo].[GetNthBusinessDay]('{date:%Y-%m-%d}', {n_days}) AS [NthDay]"
            df = connect(sql, **BWS_SQL_CREDS)
        else:
            sql = f"SELECT [SysproCompanyS].[dbo].[GetNthBusinessDay]('{date:%Y-%m-%d}', {n_days}) AS [NthDay]"
            df = connect(sql, **STARGATE_SQL_CREDS)
        if not df.empty:
            return df.iloc[0]["NthDay"]

    def calc_daily_grid_cells(
            self,
            day_0: pd.Timestamp | datetime.datetime,
            day_1: pd.Timestamp | datetime.datetime,
            df_calendar: pd.DataFrame,
            can_width: int,
            can_height: int,
            n_rows: int = 1,
            weights: tuple[int, int] = (90, 10),
            company: int = COMPANY.STG.value
    ):
        # self.calc_grid_cells_stg = utility.grid_cells(
        #     self.canvas_width_scroll_region_stg,
        #     n_cols + 1,
        #     self.canvas_height_scroll_region_stg,
        #     n_rows_stg,
        #     r_type=list
        # )

        weight_weekday, weight_weekend = weights

        print(f"{day_0=}, {day_1=}, {n_rows=}")

        list_dates = pd.date_range(day_0, day_1)[:-1]
        weekdays = set()
        weekend_days = set()
        week_holidays = set()
        unknown_days = set()
        for i, date in enumerate([None, *list_dates]):
            if date is None:
                unknown_days.add(date)
                date_is_weekend = 0
            else:
                df_date = df_calendar.loc[df_calendar["C_Date"] == date]
                if not df_date.empty:
                    date_data = df_date.iloc[0]
                    dow_n = date_data["C_Day"]
                    dow = date_data["C_DayOfWeek"]
                    weekend_holiday = date_data["C_SATHoliday"]
                    other_holiday = date_data["C_STATHoliday"]
                    holiday_name = date_data["C_HolidayName"]
                    work_day = date_data["vC_WorkDay"]
                    if work_day == 1:
                        weekdays.add(i)
                        date_is_weekend = 0
                    elif weekend_holiday == 1:
                        weekend_days.add(i)
                        date_is_weekend = 1
                    else:
                        week_holidays.add(i)
                        date_is_weekend = 0
                else:
                    unknown_days.add(i)
                    date_is_weekend = 0

            self.date_is_weekend.append(date_is_weekend)

        print(f"{weekdays=}")
        print(f"{weekend_days=}")
        print(f"{week_holidays=}")
        print(f"{unknown_days=}")

        n_weekend_days = len(weekend_days)
        n_weekdays = len(weekdays) + len(week_holidays) + len(unknown_days)
        n_cols = n_weekdays + n_weekend_days

        print(f"{len(list_dates)=}")
        print(f"{n_cols=}, {n_rows=}")
        print(f"{n_weekdays=}")
        print(f"{n_weekend_days=}")

        space_w_wd = (can_width * (weight_weekday / 100)) * (n_weekdays / n_cols)
        space_w_we = (can_width * (weight_weekend / 100)) * (n_weekend_days / n_cols)
        w_wd = space_w_wd / n_weekdays
        w_we = space_w_we / n_weekend_days
        hc = can_height / n_rows
        print(f"{w_wd=}, {w_we=}, {hc=}")

        if company == COMPANY.BWS.value:
            self.tile_width_bws = w_wd
            # self.tile_width_weekend = w_we
            self.tile_height_bws = hc
        else:
            self.tile_width_stg = w_wd
            # self.tile_width_weekend = w_we
            self.tile_height_stg = hc

        xt = 0

        res = [[] for _ in range(n_rows)]
        for j in range(n_cols):
            # date = list_dates[j]
            wc = w_wd
            if j in weekend_days:
                print(f"WEEKEND {j=}")
                wc = w_we
            x0 = xt
            x1 = x0 + wc
            # col_lst = list()
            for i in range(n_rows):
                y0 = i * hc
                y1 = y0 + hc
                # col_lst.append([x0, y0, x1, y1])
                res[i].insert(j, [x0, y0, x1, y1])
            # res.append(copy.deepcopy(col_lst))
            xt += wc
        self.canvas_width_scroll_region_stg = xt
        if company == COMPANY.BWS.value:
            if getattr(self, "canvas_bws", None) is not None:
                self.canvas_bws.configure(
                    width=self.canvas_width_scroll_region_stg
                )
        else:
            if getattr(self, "canvas_stg", None) is not None:
                self.canvas_stg.configure(
                    width=self.canvas_width_scroll_region_stg
                )
        print(f"{res=}")
        return res
        # return np.transpose(res).tolist()

        # return utility.grid_cells(
        #     can_width,
        #     (day_1 - day_0).days + 1,
        #     can_height,
        #     n_rows_stg,
        #     r_type=list
        # )

    def set_invisible_canvas(self, mode="invisble"):
        print(f'set_invisible_canvas {mode=}, {self.settings['init_test_mode_done'].get()=}')

        if mode == "gray":
            if self.settings["init_test_mode_done"].get():
                self.wm_attributes("-alpha", self.opacity_reload)
            # self.call("wm", "attributes", ".", "-alpha", "0.9")  # Window Opacity 0.0-1.0
        else:
            # invisible
            if self.settings["init_test_mode_done"].get():
                self.wm_attributes("-alpha", 1)
            # self.call("wm", "attributes", ".", "-alpha", "1.0")  # Window Opacity 0.0-1.0
            hwnd = self.invisible_canvas.winfo_id()
            colorkey = win32api.RGB(*self.colour_background_root_canvas.rgb_code)
            wnd_exstyle = win32gui.GetWindowLong(hwnd, win32con.GWL_EXSTYLE)
            new_exstyle = wnd_exstyle | win32con.WS_EX_LAYERED
            win32gui.SetWindowLong(hwnd, win32con.GWL_EXSTYLE, new_exstyle)
            # print(f"C1 {hwnd=}, {colorkey=}, {wnd_exstyle=}, {new_exstyle=}")
            win32gui.SetLayeredWindowAttributes(hwnd, colorkey, 255, win32con.LWA_COLORKEY)

    def tv_update_test_mode(self, *args):
        tm = self.settings["TEST_MODE"].get()
        if tm:
            print(f"tv_update_test_mode")
            print(f"{getattr(self, 'invisible_canvas', None)=}")

        if tm:
            if self.frame_testing is not None:
                print(f"SHOWING FRAME TESTING")
                self.frame_testing.grid(row=0, column=0, columnspan=2, pady=3)
                self.frame_calendar.rowconfigure(0, weight=5)
            else:
                print(f"TM & NOT FT")
            # self.lbl_testing_mode.grid(row=0, column=0, columnspan=2, pady=3)
            if getattr(self, "invisible_canvas", None) is not None:
                self.invisible_canvas.itemconfigure(self.dot, state="normal")
        else:
            if getattr(self, "frame_calendar", None) is not None:
                self.frame_calendar.rowconfigure(0, weight=0)
            if self.frame_testing is not None:
                self.frame_testing.grid_forget()
                self.listbox_history.grid_forget()
                self.scroll_bar_history.grid_forget()
                print(f"HIDING FRAME TESTING")
            else:
                print(f"NOT TM & NOT FT")
            # self.lbl_testing_mode.grid_forget()
            if getattr(self, "invisible_canvas", None) is not None:
                self.invisible_canvas.itemconfigure(self.dot, state="hidden")

        if getattr(self, "frame_calendar", None) is not None:
            if tm:
                print(f"W=2")
                self.frame_calendar.rowconfigure(0, weight=2, minsize=8)
                self.frame_calendar.rowconfigure(1, weight=98)
                # self.frame_calendar.rowconfigure(2, weight=31)
                # self.frame_calendar.rowconfigure(3, weight=31)
            else:
                print(f"W=0")
                self.frame_calendar.rowconfigure(0, weight=0, minsize=0)
                self.frame_calendar.rowconfigure(1, weight=100)
        #         self.frame_calendar.rowconfigure(2, weight=33)
        #         self.frame_calendar.rowconfigure(3, weight=33)

        self.reload_application()

    def update_allowed_companies(self, *args):
        tm = self.settings["TEST_MODE"].get()
        tm = True
        if tm:
            print(f"update_allowed_companies")
        ac = self.tv_allowed_companies.get()
        inc_bws = self.tv_allowed_comp_bws.get()
        inc_stg = self.tv_allowed_comp_stg.get()

        ac_s = f"'{str(list(ac)).replace(' ', '')}'"

        if tm:
            print(f"{ac=}, {ac_s=}, {inc_bws=}, {inc_stg=}")

        un = self.app_state["user_name"]
        sql = "UPDATE [Stargatedb].[dbo].[PDS Valid Updaters] SET [AllowedCompanies] = {ac_s} WHERE [UserName] = '{un}';"
        sql = sql.format(ac_s=ac_s, un=un)
        connect(sql, **STARGATE_SQL_CREDS, do_show=True)

    def update_allowed_comp_bws(self, *args):
        print(f"update_allowed_comp_bws")
        tm = self.settings["TEST_MODE"].get()
        tm = True
        if tm:
            print(f"update_allowed_comp_bws")
        ac = self.tv_allowed_companies.get()
        inc_bws = self.tv_allowed_comp_bws.get()
        comp_id = COMPANY.BWS.value
        valid = set(ac)
        if inc_bws:
            valid.add(comp_id)
        else:
            if comp_id in valid:
                valid.remove(comp_id)
        self.tv_allowed_companies.set(list(valid))
        # if tm:
        print(f"update_allowed_comp_bws ac={self.tv_allowed_companies.get()}")

    def update_allowed_comp_stg(self, *args):
        print(f"update_allowed_comp_stg")
        tm = self.settings["TEST_MODE"].get()
        tm = True
        if tm:
            print(f"update_allowed_comp_stg")
        ac = self.tv_allowed_companies.get()
        inc_stg = self.tv_allowed_comp_stg.get()
        comp_id = COMPANY.STG.value
        valid = set(ac)
        if inc_stg:
            valid.add(comp_id)
        else:
            if comp_id in valid:
                valid.remove(comp_id)
        self.tv_allowed_companies.set(list(valid))
        # if tm:
        print(f"update_allowed_comp_stg ac={self.tv_allowed_companies.get()}")

    def update_show_galvanized(self, *args):
        tm = self.settings["TEST_MODE"].get()
        old_showing = self.tl_tv_showing_galvanized.get()
        new_showing = self.tl_tv_show_galvanized.get()
        do_switch = old_showing != new_showing
        tile_text_colour = self.colour_tile_foreground
        font = self.font_tile

        comp = self.settings["mode_company"]
        tiles = self.tiles_bws if (comp == COMPANY.BWS.value) else self.tiles_stg
        lines = self.list_prod_lines_bws if (comp == COMPANY.BWS.value) else self.list_prod_lines_stg
        can = self.canvas_bws if (comp == COMPANY.BWS.value) else self.canvas_stg
        df_orders = self.df_orders_bws if (comp == COMPANY.BWS.value) else self.df_orders_stg
        tw = self.tile_width_bws if (comp == COMPANY.BWS.value) else self.tile_width_stg
        th = self.tile_height_bws if (comp == COMPANY.BWS.value) else self.tile_height_stg

        # print(f"{old_showing=}, {new_showing=}, {do_switch=}")

        if do_switch:
            for i, date in enumerate(self.list_dates):
                for j, line in enumerate(lines):
                    tile_data = tiles.get(date, dict()).get(line, dict())
                    tag = tile_data.get("tile", None)
                    order = tile_data.get("order", None)
                    t_tags = tile_data.get("texts", list())

                    if (tag is not None) and (t_tags is not None) and (order is not None):
                        bbox = can.bbox(tag)
                        to_do_texts = [can.itemcget(ttag, "text") for ttag in t_tags]
                        for ttag in t_tags:
                            can.delete(ttag)
                        if old_showing:
                            # remove galv
                            to_do_texts = to_do_texts[:-1]
                        else:
                            # add galv
                            galv = df_orders.iloc[order]["IsGalv"]
                            to_do_texts.append(galv)

                        tiles[date][line].update({
                            "texts": [
                                can.create_text(
                                    int(bbox[0] + (tw * 0.5)),
                                    int(bbox[1] + ((k + 1) * th / (1 + len(to_do_texts)))),
                                    text=txt,
                                    fill=tile_text_colour.hex_code,
                                    font=font
                                )
                                for k, txt, in enumerate(to_do_texts)
                            ]
                        })
            self.tl_tv_showing_galvanized.set(new_showing)
            self.tl_tv_show_galvanized.set(old_showing)

        # if tm:
        #     print(f"{showing=}")

        # f

    def update_switch_colour_code_only_priority(self, *args):
        tm = self.settings["TEST_MODE"].get()
        prio = int(self.tl_tv_colour_code_only_priority.get())
        # prio_s = 1 if (prio == 0) else 0  # logic is inverse for this column
        prio_s = f"{prio}"
        un = self.app_state["user_name"]
        sql = "UPDATE [Stargatedb].[dbo].[PDS Valid Updaters] SET [ColourCodingPriorityOnly] = {prio_s} WHERE [UserName] = '{un}';"
        sql = sql.format(prio_s=prio_s, un=un)
        connect(sql, **STARGATE_SQL_CREDS, do_show=True)

        self.colour_code()

    def update_switch_colour_code_priority(self, *args):
        tm = self.settings["TEST_MODE"].get()
        pri = self.tl_tv_colour_code_priority.get()
        pri_s = pri.lower()
        # TODO 2024-08-13 1217 where this is a segmentedbutton, need to wrap the selection in a list
        pri_s = str([pri_s]).replace("'", "\"")
        if tm:
            print(f"{pri=}")
        un = self.app_state["user_name"]
        sql = "UPDATE [Stargatedb].[dbo].[PDS Valid Updaters] SET [ColourCodingPriority] = '{pri_s}' WHERE [UserName] = '{un}';"
        sql = sql.format(pri_s=pri_s, un=un)
        connect(sql, **STARGATE_SQL_CREDS, do_show=True)

        self.colour_code()

    def update_show_calendar_only(self, *args):
        slw = self.tl_tv_switch_show_left_widgets.get()
        slw = 0 if (slw == "No") else 1
        slw_u = 1 if (slw == 0) else 0  # logic is inverse for this column
        un = self.app_state["user_name"]
        sql = "UPDATE [Stargatedb].[dbo].[PDS Valid Updaters] SET [ShowCalendarOnly] = {slw_u} WHERE [UserName] = '{un}';"
        sql = sql.format(slw_u=slw_u, un=un)
        connect(sql, **STARGATE_SQL_CREDS, do_show=True)

        if slw:
            self.frame_left_controls.grid(row=1, column=0, rowspan=1, sticky=ctk.NSEW)
            self.canvas_width = self.canvas_width_og
        else:
            self.frame_left_controls.grid_forget()
            self.canvas_width = self.total_width

        comp = self.settings["mode_company"]
        if comp == COMPANY.BWS.value:
            self.canvas_bws.configure(
                width=self.canvas_width
            )
        else:
            self.canvas_stg.configure(
                width=self.canvas_width
            )

    def update_count_tries_allow_publish(self, *args):
        tm = self.settings["TEST_MODE"].get()
        na = self.max_tries_admin_password
        count = self.tl_tv_count_tries_allow_publish.get()
        if count >= na:
            messagebox.showerror(
                title=self.title_application_short,
                message=self.msg_incorrect_admin_password_max_tries,
                parent=(self.tl_ad if (self.tl_ad is not None) else self)
            )
            self.mb_file.entryconfig("Admin", state=ctk.DISABLED)
            atl = 0
        else:
            atl = max(0, na - count)

        self.lbl_admin_password_attempts_remaining[0].set(f"{atl} attempt{'' if atl == 1 else 's'} remaining")
        col = gradient(min(na, count), na, "#EFEFEF", "#ED5858", rgb=False)
        widget = self.lbl_admin_password_attempts_remaining[1]
        if widget is not None:
            if tm:
                print(f"{widget=}, {col=}")
            try:
                widget.configure(text_color=col)
            except tkinter.TclError:
                pass

        if self.entry_admin_password_attempts_remaining is not None:
            if atl == 0:
                self.entry_admin_password_attempts_remaining[3].configure(state=ctk.DISABLED)

    def update_allow_publish(self, *args):
        ap = self.tl_tv_switch_allow_publish.get()
        ap = 0 if (ap == "No") else 1
        # ap = 0 if (ap == 1) else 0  # logic is inverse for this column
        un = self.app_state["user_name"]
        sql = "UPDATE [Stargatedb].[dbo].[PDS Valid Updaters] SET [AllowPublish] = {ap} WHERE [UserName] = '{un}';"
        sql = sql.format(ap=ap, un=un)
        connect(sql, **STARGATE_SQL_CREDS, do_show=True)

        if ap:
            msg = self.msg_now_allowed_to_publish
        else:
            msg = self.msg_now_not_allowed_to_publish

        messagebox.showinfo(
            title=self.title_application_short,
            message=msg,
            parent=self.tl_ad if self.tl_ad is not None else self
        )

        if self.tl_ad is not None:
            self.on_close_tl_ad()

        if ap:
            self.tl_tv_switch_show_left_widgets.set("Yes")
            btn_state = ctk.NORMAL
        else:
            btn_state = ctk.DISABLED

        self.mb_file.entryconfig("Save", state=btn_state)
        self.mb_file.entryconfig("Settings", state=btn_state)
        self.mb_tools.entryconfig("Shift Line", state=btn_state)

    def update_ask_monitors(self, *args):
        am = self.tl_tv_switch_ask_monitors.get()
        am = 0 if (am == "No") else 1
        un = self.app_state["user_name"]
        sql = "UPDATE [Stargatedb].[dbo].[PDS Valid Updaters] SET [AskMonitors] = {am} WHERE [UserName] = '{un}';"
        sql = sql.format(am=am, un=un)
        connect(sql, **STARGATE_SQL_CREDS, do_show=True)

    def update_light_dark_theme(self, *args):
        ldt_o = self.tl_tv_switch_dark.get()
        ldt = ldt_o
        if ldt is None:
            ldt = "NULL"
            ldt_o = "System"
        else:
            if ldt not in ("Light", "Dark"):
                ldt = "NULL"
                ldt_o = "System"
            else:
                ldt = f"'{ldt}'"
        un = self.app_state["user_name"]
        sql = "UPDATE [Stargatedb].[dbo].[PDS Valid Updaters] SET [LightDarkTheme] = {ldt} WHERE [UserName] = '{un}';"
        sql = sql.format(ldt=ldt, un=un)
        ctk.set_appearance_mode(ldt_o)
        connect(sql, **STARGATE_SQL_CREDS, do_show=True)

    def update_all_widgets_theme(self, parent=None):
        tm = self.settings["TEST_MODE"].get()
        lc_o = self.tl_tv_switch_colour.get()
        if tm:
            print(f"update_all_widgets_theme 1 {lc_o=}")

        lc = lc_o.replace(" ", "-").lower()
        if tm:
            print(f"update_all_widgets_theme 2 {lc=}")

        if lc == "dark-blue":
            bg = self.colour_background_theme_dark_blue
            fg = self.colour_foreground_theme_dark_blue
        elif lc == "blue":
            bg = self.colour_background_theme_blue
            fg = self.colour_foreground_theme_blue
        else:
            bg = self.colour_background_theme_green
            fg = self.colour_foreground_theme_green

        for widget_name in [
            "toggle_warranty",
            "btn_if_goto_stg"
            "btn_if_goto_bws"
        ]:
            widget = getattr(self, widget_name, None)
            if widget is not None:
                if tm:
                    print(f"{widget=}")
                    print(f"{self.nametowidget(widget)=}")
                    print(f"{widget_name=}, fg={fg.hex_code}, bg={bg.hex_code}")
                if isinstance(widget, ctk.CTkSegmentedButton):
                    widget.configure(
                        text_color=fg.hex_code,
                        selected_color=bg.hex_code,
                        selected_hover_color=bg.darkened(0.1).hex_code
                    )
                else:
                    widget.configure(
                        fg_color=bg.hex_code,
                        text_color=fg.hex_code
                    )

        # if parent is None:
        #     parent = self
        #
        # for child in parent.winfo_children():
        #     # print(f"{child=}")
        #     if isinstance(child, ctk.CTkBaseClass):  # Assuming all widgets inherit from CTkBaseClass
        #         child.configure()  # Refresh widget appearance
        #
        #     self.update_all_widgets_theme(parent=child)

    def update_colour_theme(self, *args):
        tm = self.settings["TEST_MODE"].get()
        lc_o = self.tl_tv_switch_colour.get()
        if tm:
            print(f"update_colour_theme 1 {lc_o=}")

        lc = lc_o.replace(" ", "-").lower()
        if tm:
            print(f"update_colour_theme 2 {lc=}")

        ctk.set_default_color_theme(lc)
        self.update_all_widgets_theme()

        if lc is None:
            lc = "NULL"
        else:
            lc = f"'{lc}'"

        try:
            c = Colour(lc_o)
        except Colour.ColourCreationError:
            c = self.colour_tl_sl_preview_header

        self.colour_tl_sl_preview_header = c

        # ldt = ldt_o
        # if ldt is None:
        #     ldt = "NULL"
        #     ldt_o = "System"
        # else:
        #     if ldt not in ("Light", "Dark"):
        #         ldt = "NULL"
        #         ldt_o = "System"
        #     else:
        #         ldt = f"'{ldt}'"
        un = self.app_state["user_name"]
        sql = "UPDATE [Stargatedb].[dbo].[PDS Valid Updaters] SET [ColourTheme] = {lc} WHERE [UserName] = '{un}';"
        sql = sql.format(lc=lc, un=un)
        connect(sql, **STARGATE_SQL_CREDS, do_show=True)

        # this wont take effect until program restart, inform the user.
        # parent = self.tl_cc_app if (self.tl_cc_app is not None) else self
        # messagebox.showinfo(
        #     title=self.title_application_short,
        #     message=self.msg_please_restart_to_activate_colour_theme,
        #     parent=parent
        # )

    def tv_update_history(self, *args):
        tm = self.settings["TEST_MODE"].get()
        hist = self.history.get()
        if tm:
            print(f"History update: {hist=}")
        known_hist = self.listbox_history.get(0, ctk.END)
        lh, lkh = len(hist), len(known_hist)

        comp = self.settings["mode_company"]
        tiles = self.tiles_bws if (comp == COMPANY.BWS.value) else self.tiles_stg

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
            print(f"{list(tiles.keys())=}")
            print(f"{date_1=}, {line_1=}")
            print(f"{tiles.get(date_1)=}")
            print(f"{tiles.get(date_1, {}).get(line_1)=}")

            if new_code == "SWAP":
                # sometimes in a swap, the first spot will be empty (ex: move Unit to an empty tile)
                print(f"SWAP TO AN EMPTY CELL")

            order_1 = tiles[date_1][line_1].get("order")
            msg = f"{new_code} | {order_1} ({date_1:%Y-%m-%d}, {line_1})"
            if len(new_items) > 1:
                date_2, line_2 = new_items[1]

                date_2 = pd.Timestamp(date_2)
                print(f"{date_2=}, {line_2=}")
                print(f"{tiles.get(date_2)=}")
                print(f"{tiles.get(date_2, {}).get(line_2)=}")

                order_2 = tiles[date_2][line_2].get("order")
                msg += f"<-> {order_2} ({date_2:%Y-%m-%d}, {line_2})"

            self.listbox_history.insert(ctk.END, msg)

            if self.settings["TEST_MODE"].get():
                print(f"Inserted {new_item=}\n{hist=}")
        elif lh < lkh:
            # deleted a history event
            del_item = known_hist[-1]
            idx = known_hist.index(str(del_item))
            self.listbox_history.delete(idx)
            if self.settings["TEST_MODE"].get():
                print(f"deleted {del_item=}")
        else:
            # no change
            if self.settings["TEST_MODE"].get():
                print(f"No Change")
        # self.listbox_history
        if self.settings["TEST_MODE"].get():
            print(f"AFTER {list(self.history.get())=}")

    def colour_code(self, date=None, line=None):
        tm = self.settings["TEST_MODE"].get()
        cc = self.settings["colour_coding"]
        ht = self.app_state["hovered"]
        st = self.app_state["selected"]
        dt = self.app_state["dragged"]
        dcc = cc.get("dealer", dict())
        mcc = cc.get("model", dict())

        default_cc = {
            "bg": self.colour_tile_background.hex_code,
            "fg": self.colour_tile_foreground.hex_code,
            "outline": self.colour_tile_outline.hex_code,
            "width": self.width_tile_outline,
            "font": self.font_tile
        }

        pri_cc = self.tl_tv_colour_code_priority.get()
        pri_cc_s = pri_cc.lower()
        cc_if_not_top_priority = not self.tl_tv_colour_code_only_priority.get()

        company = self.settings["mode_company"]
        lines = self.list_prod_lines_bws if (company == COMPANY.BWS.value) else self.list_prod_lines_stg
        tiles = self.tiles_bws if (company == COMPANY.BWS.value) else self.tiles_stg
        can = self.canvas_bws if (company == COMPANY.BWS.value) else self.canvas_stg
        df_orders = self.df_orders_bws if (company == COMPANY.BWS.value) else self.df_orders_stg

        if tm:
            print(f"\n{cc=}\n{dcc=}\n{mcc=}\n{pri_cc_s=}, {cc_if_not_top_priority=}")
        if date is None or line is None:
            # colour code every tile
            date_to_check = [d for d in self.list_dates]
            line_to_check = [l for l in lines]
        else:
            date_to_check = [date]
            line_to_check = [line]

        for date_ in date_to_check:
            for line_ in line_to_check:
                kcc = dict()
                tile_data = tiles.get(date_, {}).get(line_, {})
                if tile_data:
                    tag = tile_data["tile"]
                    t_tags = tile_data["texts"]
                    order = tile_data.get("order", None)
                    if order:
                        # print(f"{order} ", end="")
                        df_i = df_orders.iloc[order]
                        dealer = df_i[self.quote_key("dealer")]
                        model = df_i[self.quote_key("Model No")]
                        # print(f"{dealer} ", end="")
                        kcc_d = dcc.get(dealer, dict())
                        kcc_m = mcc.get(model, dict())

                        abc = f""
                        if pri_cc_s == "model":
                            abc += f"A"
                            if kcc_m:
                                abc += f"B"
                                kcc = kcc_m
                            elif cc_if_not_top_priority:
                                abc += f"C"
                                kcc = kcc_d
                        else:
                            abc += f"D"
                            if kcc_d:
                                abc += f"E"
                                kcc = kcc_d
                            elif cc_if_not_top_priority:
                                abc += f"F"
                                kcc = kcc_m

                        # if line_ == "ED1":
                        if tm:
                            print(f"{line_=}, {date_=}, {model=}, {dealer=}, {kcc=}")
                            print(f"{abc=}, {kcc_m=}, {kcc_d=}")

                        if not kcc:
                            kcc = default_cc

                        if kcc:
                            bg = kcc.get("bg", None)
                            fg = kcc.get("fg", None)
                            bd = kcc.get("outline", None)
                            ou = kcc.get("width", None)
                            ft = kcc.get("font", None)

                            # bg_h = Colour(bg).brighten(0.15, safe=True).hex_code
                            # fg_h = Colour(fg).brighten(0.15, safe=True).hex_code
                            # bd_h = Colour(bd).brighten(0.15, safe=True).hex_code

                            bg_h = Colour(bg).brighten(0.15, safe=False).hex_code
                            fg_h = Colour(fg).brighten(0.15, safe=False).hex_code
                            bd_h = Colour(bd).brighten(0.15, safe=False).hex_code
                            ou_h = ou
                            ft_h = ft

                            # style_k = ["bg", "fg", "outline", "width", "font"]
                            # style_v = [bg, fg, bd, ou, ft]
                            # style = dict(zip(style_k, style_v))
                            # for k in style_k:
                            #     if style[k] is None:
                            #         del style[k]

                            is_hovered = (date_, line_) in ht
                            bg = bg_h if is_hovered else bg
                            fg = fg_h if is_hovered else fg
                            ou = ou_h if is_hovered else ou
                            bd = bd_h if is_hovered else bd
                            ft = ft_h if is_hovered else ft

                            # print(f"{date_=}, {line_=}, {is_hovered=}")
                            # print(f"{style=}")
                            can.itemconfigure(
                                tag,
                                fill=bg,
                                width=ou,
                                outline=bd
                                # ,
                                # activefill=bg_h,
                                # activeoutline=bd_h,
                            )
                            for t_tag in t_tags:
                                can.itemconfigure(
                                    t_tag,
                                    fill=fg,
                                    font=ft
                                    # ,
                                    # activefill=fg_h
                                )
                        else:
                            print(f"skipped {date_=}, {line_=} NO CC FOR '{dealer=}'")
                #     else:
                #         print(f"skipped {date_=}, {line_=} NO ORDER")
                # else:
                #     print(f"skipped {date_=}, {line_=} NO TD")

    def create_new_pds_user(self):
        tm = self.settings["TEST_MODE"].get()

        # silently create new PDS user in 'view-only' mode
        un = self.app_state["user_name"]
        columns = ["UserName", "Active", "AllowPublish", "InTestingMode", "LightDarkTheme", "AskMonitors",
                   "ShowCalendarOnly"]
        sql = f"INSERT INTO [PDS Valid Updaters] ([{'], ['.join(columns)}]) VALUES "
        sql += f"('{un}', 1, 0, 0, 'System', 0, 1);"

        self.settings["TEST_MODE"].set(False)
        self.settings["allowed_to_publish"].set(False)
        ctk.set_appearance_mode("System")
        self.tl_tv_switch_dark.set("System")
        self.tl_tv_switch_ask_monitors.set("No")
        self.tl_tv_switch_show_left_widgets.set("No")
        self.tl_tv_colour_code_priority.set("model")
        self.tl_tv_colour_code_only_priority.set(True)

        if tm:
            print(f"--\n{sql}")
        else:
            res = connect(sql, **STARGATE_SQL_CREDS, do_print=tm, do_exec=True, do_show=tm)

    def check_valid_updater(self):
        self.df_valid_updaters = connect(**SQL_VALID_UPDATERS)

        user = utility.get_windows_user(2)
        # use this for testing
        # user = "bwsdomain.local\\gf"
        # user = "bwsdomain.local\\mguest"
        # user = "bwsdomain.local\\tmerrithew"
        self.app_state["user_full"] = user
        user_domain, *user_name = user.lower().split("\\")
        if not user_name:
            user_name = user
        self.app_state["user_domain"] = user_domain
        self.app_state["user_name"] = user_name[0] if isinstance(user_name, (list, tuple)) else user_name
        df = self.df_valid_updaters.loc[self.df_valid_updaters["UserName"].str.lower().str.strip() == user_name[0]]

        df_admin = \
            self.df_valid_updaters.loc[self.df_valid_updaters["UserName"].str.lower().str.strip() == "abriggs"].iloc[0]
        admin_pwd = df_admin["AdminPassword"]
        self.settings["admin_password"].set(admin_pwd)

        # valid_users = [un.lower().strip() for un in self.df_valid_updaters["UserName"].unique() if len(un)]
        if self.settings["TEST_MODE"].get():
            print(f"{df=}")

        print(f"{user=}, {user_domain=}, {user_name=}", end="")

        if not df.empty:
            # idx = df.index[0]
            # print(f"{df=}, {idx=}")
            df_pds_user = df.iloc[0]
            cc = df_pds_user["ColourCoding"]
            test_mode = df_pds_user["InTestingMode"]
            light_dark_theme = df_pds_user["LightDarkTheme"]
            if pd.isna(light_dark_theme):
                light_dark_theme = get_windows_theme().title()
                if light_dark_theme is None:
                    light_dark_theme = self.default_light_dark_theme
            ask_monitors = df_pds_user["AskMonitors"]
            if pd.isna(ask_monitors):
                ask_monitors = self.default_ask_monitors
            else:
                ask_monitors = "No" if (int(ask_monitors) == 0) else "Yes"
            allowed_to_publish = bool(df_pds_user["AllowPublish"])
            cc = cc if not pd.isna(cc) else {}
            self.settings["colour_coding"] = eval(str(cc))

            show_left_widgets = df_pds_user["ShowCalendarOnly"]
            if pd.isna(show_left_widgets):
                show_left_widgets = self.default_show_left_widgets
            else:
                show_left_widgets = "No" if (int(show_left_widgets) == 1) else "Yes"

            colour_theme = df_pds_user["ColourTheme"]
            if pd.isna(colour_theme):
                colour_theme = self.default_colour_theme
            else:
                colour_theme = colour_theme.replace("-", " ").title()

            colour_code_priority = df_pds_user["ColourCodingPriority"]
            if pd.isna(colour_code_priority):
                colour_code_priority = self.default_colour_code_priority
            else:
                colour_code_priority = eval(colour_code_priority)
                if not isinstance(colour_code_priority, (list, tuple)):
                    if isinstance(colour_code_priority, str):
                        colour_code_priority = [colour_code_priority]
                    else:
                        colour_code_priority = self.default_colour_code_priority
            # TODO 2024-08-13 1207 where this is currently a segmented button, select only top priority
            colour_code_priority = colour_code_priority[0]

            colour_code_priority_only = df_pds_user["ColourCodingPriorityOnly"]
            if pd.isna(colour_code_priority_only):
                colour_code_priority_only = self.default_colour_code_only_priority

            allowed_companies = df_pds_user["AllowedCompanies"]
            print(f"START {allowed_companies=}")
            if pd.isna(allowed_companies):
                print(f"a")
                valid_ac = self.default_allowed_companies
            else:
                allowed_companies = eval(allowed_companies)
                print(f"b")
                if not isinstance(allowed_companies, (tuple, list)):
                    print(f"c")
                    if isinstance(allowed_companies, str):
                        print(f"d")
                        valid_ac = [allowed_companies]
                    else:
                        print(f"e")
                        valid_ac = self.default_allowed_companies
                else:
                    print(f"f")
                    valid_ac = list()
                    for i, val in enumerate(allowed_companies):
                        print(f"{i=}, {val=}, {COMPANY.BWS.value=}, {COMPANY.STG.value=}")
                        if val == COMPANY.BWS.value:
                            # self.tv_allowed_comp_bws.set(True)
                            print(f"g")
                            valid_ac.append(val)
                        elif val == COMPANY.STG.value:
                            # self.tv_allowed_comp_stg.set(True)
                            print(f"h")
                            valid_ac.append(val)
                    if not valid_ac:
                        print(f"i")
                        valid_ac = self.default_allowed_companies

            print(f"END {valid_ac=}, {type(valid_ac)=}")
            for val in valid_ac:
                print(f"{val=}")
                if val == COMPANY.BWS.value:
                    print(f"j")
                    self.tv_allowed_comp_bws.set(True)
                    self.update_allowed_comp_bws()
                elif val == COMPANY.STG.value:
                    print(f"k")
                    self.tv_allowed_comp_stg.set(True)
                    self.update_allowed_comp_stg()
            print(f"END {allowed_companies=}")
            print(f"{self.tv_allowed_comp_bws.get()=}")
            print(f"{self.tv_allowed_comp_stg.get()=}")
            print(f"{self.tv_allowed_companies.get()=}")

            mode_company = df_pds_user["ModeCompany"]
            if pd.isna(mode_company):
                print(f"a")
                valid_ac = self.default_allowed_companies[0]
            else:
                mode_company = int(mode_company)
            self.settings["mode_company"] = mode_company

            # self.tv_allowed_companies.set(valid_ac)
            print(f"{mode_company=}")
            print(f"{self.settings['mode_company']=}")

            print(f" FOUND! TM={bool(test_mode)}, AP={allowed_to_publish}")
            print(f"{colour_code_priority=}")

            # print(f"INIT TEST MODE {test_mode}")
            self.settings["TEST_MODE"].set(bool(test_mode))
            self.settings["allowed_to_publish"].set(allowed_to_publish)
            self.tl_tv_switch_allow_publish.set("Yes" if allowed_to_publish else "No")
            ctk.set_appearance_mode(light_dark_theme)
            self.tl_tv_switch_colour.set(colour_theme)
            self.tl_tv_switch_dark.set(light_dark_theme)
            self.tl_tv_switch_ask_monitors.set(ask_monitors)
            self.tl_tv_switch_show_left_widgets.set(show_left_widgets)
            self.tl_tv_colour_code_priority.set(colour_code_priority.title())
            self.tl_tv_colour_code_only_priority.set(colour_code_priority_only)
            self.update_colour_theme()
            # if self.settings["mode_company"] != self.default_allowed_companies[0]:
            # self.settings["mode_company"] = mode_company

            return True

        print(f" NOT FOUND")
        return False

    def update_done_interact_tl(self, *args):
        ditl = self.tv_done_interact_tl.get()

        self.bind_widgets(ditl)

        if not ditl:
            # print(f"CHECK AGAIN")
            self.after(250, self.update_done_interact_tl)

        #
        #     self.winfo_pointerxy()
        #     state = self.winfo_pointerstate()
        #
        #     # Check if any mouse buttons are held down
        #     if (state & 0x100) or (state & 0x200) or (state & 0x400):
        #         print(f"CHECK AGAIN")
        #         self.after(250, self.update_done_interact_tl)

    def bind_widgets(self, do_bind: bool = True):
        print(f"{do_bind=}")

        company = self.settings["mode_company"]
        can = self.canvas_bws if (company == COMPANY.BWS.value) else self.canvas_stg

        if do_bind:

            self.bn_mousewheel_calendar = can.bind("<MouseWheel>", self.on_mousewheel_calendar)
            self.bn_motion_calendar = can.bind("<Motion>", self.on_motion_calendar)
            self.bn_lclickmotion_calendar = can.bind("<B1-Motion>", self.on_left_click_motion_calendar)

            self.bn_lrelease_calendar = can.bind("<ButtonRelease-1>", self.on_left_click_release_calendar)
            self.bn_lclick_calendar = can.bind("<Button-1>", self.on_left_click_calendar)
            self.bn_rrelease_calendar = can.bind("<ButtonRelease-3>", self.on_right_click_calendar)

            self.bn_lclickmotion_invisible_canvas = self.invisible_canvas.bind("<B1-Motion>",
                                                                               self.on_left_click_root_canvas)
            self.bn_ctlz = self.bind("<Control-z>", self.undo)

        else:
            bindings = [
                ("<MouseWheel>", "bn_mousewheel_calendar"),
                ("<Motion>", "bn_motion_calendar"),
                ("<B1-Motion>", "bn_lclickmotion_calendar"),
                ("<ButtonRelease-1>", "bn_lrelease_calendar"),
                ("<Button-1>", "bn_lclick_calendar"),
                ("<ButtonRelease-3>", "bn_rrelease_calendar")
            ]
            for bind_seq, attr in bindings:
                o_attr = getattr(self, attr, None)
                if o_attr is not None:
                    can.unbind(bind_seq, o_attr)
                    setattr(self, attr, None)

            if self.bn_ctlz is not None:
                self.unbind("<Control-z>", self.bn_ctlz)
                self.bn_ctlz = None

        # print(f"{self.canvas_stg.bind()=}")

    def grid_keys(self) -> tuple[str, str, str, str, str, str, str, str, str]:
        return "row", "column", "rowspan", "columnspan", "ipadx", "ipady", "padx", "pady", "sticky"

    def grid_widgets(self) -> None:
        r, c, rs, cs, ix, iy, x, y, s = self.grid_keys()
        tm = self.settings["TEST_MODE"].get()
        is_warranty = self.tv_toggle_warranty.get() == "Warranty"
        slw = self.tl_tv_switch_show_left_widgets.get()
        print(f"{slw=}")
        show_calendar_only = slw == "No"
        comp = self.settings["mode_company"]

        # self
        self.frame_calendar.grid(**{r: 0, c: 0, s: ctk.NSEW})
        # self.frame_calendar.grid_propagate(False)

        # frame_calendar
        if tm:
            self.frame_testing.grid(**{r: 0, c: 0, rs: 1, cs: 1})
        self.frame_canvas.grid(**{r: 1, c: 1, rs: 1, s: ctk.NSEW})
        self.frame_left_controls.grid(**{r: 1, c: 0, rs: 1, s: ctk.NSEW})

        # frame_testing
        self.lbl_testing_mode.grid()

        # frame_canvas
        if comp == COMPANY.BWS.value:
            self.canvas_bws.grid(**{r: 0})
        else:
            self.canvas_stg.grid(**{r: 0})
        self.scroll_bar_x.grid(**{r: 1, s: ctk.EW})

        # frame_left_controls
        self.frame_multi_combobox.grid(**{r: 0, c: 0})
        self.frame_info_frame.grid(**{r: 1, c: 0})
        if tm:
            self.frame_listbox_history.grid(**{r: 2, c: 0})

        # frame_multi_combobox
        self.frame_mc_inner.grid(**{r: 0, c: 0, x: 10, y: 10})

        # frame_listbox_history
        self.listbox_history.grid(**{r: 0, c: 0, cs: 1, rs: 1})
        self.scroll_bar_history.grid(**{r: 0, c: 1, cs: 1, rs: 1, s: ctk.NS})

        if tm:
            print(f"GW W=2")
            self.frame_calendar.rowconfigure(0, weight=2, minsize=8)
            self.frame_calendar.rowconfigure(1, weight=98)
        else:
            print(f"GW W=0")
            self.frame_calendar.rowconfigure(0, weight=0, minsize=0)
            self.frame_calendar.rowconfigure(1, weight=100)

        # self.frame_calendar.rowconfigure(0)
        # fr: ctk.CTkFrame = self.frame_calendar
        # fr.rowconfigure(0,)

        self.frame_calendar.columnconfigure(0, weight=35)
        self.frame_calendar.columnconfigure(1, weight=65)

        if is_warranty:
            if comp == COMPANY.BWS.value:
                self.multi_combobox_warranties_bws.grid_widget()
            else:
                self.multi_combobox_warranties_stg.grid_widget()
        else:
            if comp == COMPANY.BWS.value:
                self.multi_combobox_orders_bws.grid_widget()
            else:
                self.multi_combobox_orders_stg.grid_widget()

        self.toggle_warranty.grid(**{r: 1, c: 0})

        if show_calendar_only:
            self.frame_left_controls.grid_forget()

            self.canvas_width = self.total_width
            if comp == COMPANY.BWS.value:
                self.canvas_bws.configure(
                    width=self.canvas_width
                )
            else:
                self.canvas_stg.configure(
                    width=self.canvas_width
                )

        # frame_calendar
        # goes on top of everything
        self.invisible_canvas.grid(**{r: 0, c: 0, cs: 2, rs: 2, s: "nsew"})

        print(f"END Grid {tm=}, slw={show_calendar_only}")

    def scroll_x_calendar(self, *args) -> None:
        # change the canvas_stg xview when the scrollbar is interacted with
        # print(f"scroll_x: {args=}")
        comp_id = self.settings["mode_company"]
        print(f"SX {comp_id=}, BWS={COMPANY.BWS.value}, STG={COMPANY.STG.value}")
        if comp_id == COMPANY.BWS.value:
            self.canvas_bws.xview(*args)
        else:
            self.canvas_stg.xview(*args)
        self.redraw_legend()

    def on_mousewheel_calendar(self, event) -> None:
        # move the canvas_stg xview when mousewheel scrolled
        comp_id = self.settings["mode_company"]
        print(f"MW {comp_id=}, BWS={COMPANY.BWS.value}, STG={COMPANY.STG.value}")
        if comp_id == COMPANY.BWS.value:
            self.canvas_bws.xview_scroll(int(-1 * (event.delta / 120)), "units")
        else:
            self.canvas_stg.xview_scroll(int(-1 * (event.delta / 120)), "units")
        self.redraw_legend()

    def get_current_canvas_view(self) -> tuple[float, float, float, float]:
        srw = self.canvas_width_scroll_region_stg
        comp_id = self.settings["mode_company"]
        if comp_id == COMPANY.BWS.value:
            x_1, x_2 = self.canvas_bws.xview()
            y_1, y_2 = self.canvas_bws.yview()
            srh = self.canvas_height_scroll_region_bws
        else:
            x_1, x_2 = self.canvas_stg.xview()
            y_1, y_2 = self.canvas_stg.yview()
            srh = self.canvas_height_scroll_region_stg
        x_1 *= srw
        x_2 *= srw
        y_1 *= srh
        y_2 *= srh
        return x_1, y_1, x_2, y_2

    def redraw_legend(self):
        """Ensure that the left legend containing line names is visible after scrolling."""
        ci = self.settings["mode_company"]
        # tw_legend_lines = self.tile_width_legend_lines
        # th_legend_lines = self.tile_height_legend_lines
        comp = self.settings["mode_company"]
        tw = self.tile_width_bws if (comp == COMPANY.BWS.value) else self.tile_width_stg
        th = self.tile_height_bws if (comp == COMPANY.BWS.value) else self.tile_height_stg
        # tw_w, th_w = self.tile_width_weekend, self.tile_height_weekend
        x_1, y_1, x_2, y_2 = self.get_current_canvas_view()
        # print(f"{x_1=}, {x_2}, {y_1}, {y_2}")
        # print(f"{col_legend=}")
        # tiles_stg = [dat["tile"] for dat in col_legend]

        if ci == COMPANY.BWS.value:
            col_legend = [dat for prod_line, dat in self.tiles_bws["line_legend"].items()]
            home_tile = self.tiles_bws["home"]["tile"]
            img = self.bws_logo_image
            can = self.canvas_bws

        else:
            col_legend = [dat for prod_line, dat in self.tiles_stg["line_legend"].items()]
            home_tile = self.tiles_stg["home"]["tile"]
            img = self.stg_logo_image
            can = self.canvas_stg

        if img:
            # move image
            can.coords(
                home_tile,
                x_1 + (tw / 2),
                y_1 + (th / 2)
            )
            # can.coords(
            #     home_tile,
            #     x_1,
            #     y_1,
            #     x_1 + tw,
            #     y_1 + th
            # )
        else:
            # move rectangle
            can.coords(home_tile, x_1, y_1, x_1 + tw, y_1 + th)

        for dat in col_legend:
            tile = dat["tile"]
            bw = float(can.itemcget(tile, "width"))
            bbox = can.bbox(tile)
            y_t = bbox[1] + bw
            # print(f"{bbox=}, {x_1=}, {y_1=}, {x_2=}, {y_2=}, {x_1=}, {y_t=}, {x_1 + tw=}, {y_t + th=}")
            # self.canvas_stg.coords(tile, x_1 + (tw / 2), y_t + (th / 2))
            can.coords(tile, x_1, y_t, x_1 + tw, y_t + th)
            can.tag_raise(tile)

            for txt in dat.get("texts", []):
                # print(f"{self.canvas_stg.itemcget(txt, 'text')=}")
                can.coords(txt, x_1 + (tw / 2), y_t + (th / 2))
                can.tag_raise(txt)

        # print(f"{self.canvas_stg.winfo_viewable()=}")
        # print(f"{self.canvas_stg.xview()=}")

    def is_valid_prod_date(self, date_in: datetime.datetime | pd.Timestamp, include_all_holidays: bool = False) -> str:
        comp = self.settings["mode_company"]
        holidays = self.holidays_bws if (comp == COMPANY.BWS.value) else self.holidays_stg
        work_holidays = self.work_holidays_bws if (comp == COMPANY.BWS.value) else self.work_holidays_stg
        if date_in.weekday() < 5:
            if include_all_holidays:
                res = "holiday" if (date_in in holidays) else "valid"
            else:
                res = "holiday" if (date_in in work_holidays) else "valid"
        else:
            res = "weekend"
        return res

        # valid = date_in.weekday() < 5
        # if valid:
        #     valid = date_in not in self.holidays_stg
        #     res = "valid" if valid else "holiday"
        # else:
        #     res = "weekend"
        #
        # return res

    def get_date_bucket(self, x: int | float) -> pd.Timestamp | None:
        """
        Return the CLOSEST date to a given x position on the calendar
        Assumes the coordinates are absolute to the scroll region and not the viewable area.
        Use tkinter.canvas_stg.canvasx and canvasy methods to convert before passing as params here.
        """
        # srw = self.canvas_width_scroll_region_stg
        # dates = self.list_dates
        # p = min(x / srw, 0.999)  # prevent index out of bounds
        # # i = int(p * len(dates)) - 1
        # # i = int(p * (len(dates) + 1))
        # # include the legend in space calculations, but exclude for indexing
        # i = int(p * (len(dates) + 1)) - 1
        # # print(f"DB {x=}, {srw=}, {p=}, {len(dates)=}, {i=}")
        # # return dates[i] if i > 0 else dates[0]
        # return dates[i] if i >= 0 else None

        # srw = self.canvas_width_scroll_region_stg
        # dates = self.list_dates
        # d_idx = dates.index()
        # p = min(x / srw, 0.999)  # prevent index out of bounds
        # sum_weekends =

        comp = self.settings["mode_company"]
        gc = self.calc_grid_cells_bws if (comp == COMPANY.BWS.value) else self.calc_grid_cells_stg

        # print(f"{x=}", end="")
        for i, date in enumerate(self.list_dates[:-1]):
            gc_top = gc[0][i + 1]
            x0, y0, x1, y1 = gc_top
            if x0 <= x <= x1:
                # print(f" {i=}, {date=}", end="\n")
                return date
        # print(f" None", end="\n")

    def get_prod_line_bucket(self, y: int | float) -> str | None:
        """
        Return the CLOSEST prod line to a given y position on the calendar
        Assumes the coordinates are absolute to the scroll region and not the viewable area.
        Use tkinter.canvas_stg.canvasx and canvasy methods to convert before passing as params here.
        """
        # srh = self.canvas_height_scroll_region_stg
        # lines = self.list_prod_lines_stg
        # p = min(y / srh, 0.999)  # prevent index out of bounds
        # # include the legend in space calculations, but exclude for indexing
        # i = int(p * (len(lines) + 1)) - 1
        # # print(f"PLB {y=}, {srh=}, {p=}, {len(lines)=}, {i=}")
        # # return lines[i] if i > 0 else lines[0]
        # return lines[i] if i >= 0 else None

        comp = self.settings["mode_company"]
        gc = self.calc_grid_cells_bws if (comp == COMPANY.BWS.value) else self.calc_grid_cells_stg
        lines = self.list_prod_lines_bws if (comp == COMPANY.BWS.value) else self.list_prod_lines_stg

        # print(f"{y=}", end="")
        for i, line in enumerate(lines):
            gc_top = gc[i + 1][0]
            x0, y0, x1, y1 = gc_top
            if y0 <= y <= y1:
                # print(f" {i=}, {line=}", end="\n")
                return line
        # print(f" None", end="\n")

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
        comp = self.settings["mode_company"]
        if comp == COMPANY.BWS.value:
            return self.tiles_bws.get(date, {}).get(line, {})
        else:
            return self.tiles_stg.get(date, {}).get(line, {})

    def get_tile_bbox(self, date: pd.Timestamp | str, prod_line: str) -> tuple[float, float, float, float] | None:

        comp = self.settings["mode_company"]
        lines = self.list_prod_lines_bws if (comp == COMPANY.BWS.value) else self.list_prod_lines_stg
        gc = self.calc_grid_cells_bws if (comp == COMPANY.BWS.value) else self.calc_grid_cells_stg

        if isinstance(date, str):
            date = pd.Timestamp(date)

        try:
            i_line = lines.index(prod_line) + 1
        except (IndexError, ValueError):
            i_line = None
        try:
            i_date = self.list_dates.index(date) + 1
        except (IndexError, ValueError):
            i_date = None

        if i_line is None or i_date is None:
            return None

        # return self.calc_grid_cells_stg[i_date][i_line]
        print(f"{i_line=}, {i_date=}")
        return gc[i_line][i_date]

    def select_tile(self, date: pd.Timestamp, prod_line: str, select: bool = True) -> None:
        # print(f"SEL {self.settings['allow_multi_select']=}")
        if not select:
            # self.app_state["selected"].clear()
            self.clear_selected_tiles()
        else:
            if not self.settings["allow_multi_select"]:
                self.select_tile(date, prod_line, False)
            if (date is not None) and (prod_line is not None):
                self.update_info_frame(date, prod_line)
                self.app_state["selected"].append((date, prod_line))

    def hover_tile(self, date: pd.Timestamp, prod_line: str) -> None:
        # print(f"HOVER ({date=}, {prod_line=})")
        tm = self.settings["TEST_MODE"].get()
        ap = self.settings["allowed_to_publish"].get()
        if ap:
            self.app_state["hovered"].append((date, prod_line))
        else:
            if tm:
                print(self.msg_no_movement_non_publish)

    def drag_tile(self, date: pd.Timestamp, prod_line: str) -> None:
        tm = self.settings["TEST_MODE"].get()
        ap = self.settings["allowed_to_publish"].get()
        if ap:
            self.app_state["dragged"].append((date, prod_line))
        else:
            if tm:
                print(self.msg_no_movement_non_publish)

    def delete_tile(self, date_line: tuple[pd.Timestamp, str], from_undo: bool = False) -> None:
        tm = self.settings["TEST_MODE"].get()
        if tm:
            print(f"DELETE TILE {date_line=}")

        comp = self.settings["mode_company"]
        can = self.canvas_bws if (comp == COMPANY.BWS.value) else self.canvas_stg
        tiles = self.tiles_bws if (comp == COMPANY.BWS.value) else self.tiles_stg
        warranty_lines = self.list_warranty_lines_bws if (comp == COMPANY.BWS.value) else self.list_warranty_lines_stg
        df_warranties = self.df_multi_combobox_data_warranties_bws if (comp == COMPANY.BWS.value) else self.df_multi_combobox_data_orders_stg
        df_orders = self.df_orders_bws if (comp == COMPANY.BWS.value) else self.df_orders_stg
        combobox_warranties = self.multi_combobox_warranties_bws if (comp == COMPANY.BWS.value) else self.multi_combobox_warranties_stg
        combobox_orders = self.multi_combobox_orders_bws if (comp == COMPANY.BWS.value) else self.multi_combobox_orders_stg

        ap = self.settings["allowed_to_publish"].get()
        if ap:
            date, line = date_line
            is_warranty = line in warranty_lines
            order = tiles[date][line].get("order", None)
            if order is not None:

                # remove from calendar
                if tm:
                    print(f"texts_to_change == {tiles[date][line]['texts']=}")
                    print(
                        f"texts_to_change == {[can.itemcget(txt, 'text') for txt in tiles[date][line]['texts']]=}")
                for txt in tiles[date][line].get("texts", []):
                    can.itemconfigure(txt, text="")
                tiles[date][line]["order"] = None

                # add to combobox
                if is_warranty:
                    if tm:
                        print(f"{is_warranty=}")
                    data = df_warranties.iloc[order]
                    dat_job = data.get("Job")
                    new_row_data = {
                        k: [v]
                        for k, v in zip(
                            combobox_warranties.tree_controller.viewable_column_names,
                            [dat_job]
                        )
                    }
                    if tm:
                        print(
                            f"self.multi_combobox_warranties.tree_controller.viewable_column_names=\n\t{self.multi_combobox_warranties_stg.tree_controller.viewable_column_names}")
                        print(f"{[dat_job]=}")
                else:
                    if tm:
                        print(f"{is_warranty=}")
                    data = df_orders.iloc[order]

                    dat_quote = data.get(self.quote_key("quote"))
                    # print(f"{dat_quote=}, {row['InputField2'].tolist()=}")
                    dat_wo = data.get(self.quote_key("wo"))
                    dat_sn = data.get(self.quote_key("sn"))
                    dat_dealer = data.get(self.quote_key("dealer"))
                    dat_galv = data.get(self.quote_key("galv"))
                    dat_model = data.get(self.quote_key("model"))
                    dat_cust_wo = data.get(self.quote_key("Customer WO#"))
                    # new_row_data = {k: [v] for k, v in zip(self.df_multi_combobox_data_orders_stg.columns,
                    if tm:
                        print(
                            f"self.multi_combobox_orders.tree_controller.viewable_column_names=\n\t{self.multi_combobox_orders_stg.tree_controller.viewable_column_names}")
                        print(f"{[dat_quote, dat_wo, dat_model, dat_dealer, dat_sn, dat_cust_wo]=}")
                        # print(f"zip(self.multi_combobox_orders_stg.tree_controller.viewable_column_names  [dat_quote, dat_wo, dat_model, dat_dealer, dat_sn, dat_cust_wo])")
                    new_row_data = {
                        k: [v]
                        for k, v in zip(
                            combobox_orders.tree_controller.viewable_column_names,
                            [dat_quote, dat_wo, dat_model, dat_dealer, dat_sn, dat_cust_wo]
                        )
                    }

                new_df = pd.DataFrame(new_row_data)
                if tm:
                    print(f"new_df={new_df}")
                if is_warranty:
                    combobox_warranties.add_new_item(val=new_df)
                else:
                    combobox_orders.add_new_item(val=new_df)

                if comp == COMPANY.BWS.value:
                    self.df_ids_to_date_line_bws[order] = (None, None)
                else:
                    self.df_ids_to_date_line_stg[order] = (None, None)

                if not from_undo:
                    # self.history.append(("DELETE", order, date_line))
                    hist = list(self.history.get())
                    hist.append(("DELETE", order, date_line))
                    self.history.set(hist)
        else:
            if tm:
                print(self.msg_no_movement_non_publish)

    def insert_tile(
            self,
            df_orders_id: int,
            date_line: tuple[pd.Timestamp, str],
            from_undo: bool = False,
            do_animate: None | str = None
    ) -> None:
        tm = self.settings["TEST_MODE"].get()
        if tm:
            print(f"insert_tile")
        ap = self.settings["allowed_to_publish"].get()

        comp = self.settings["mode_company"]
        can = self.canvas_bws if (comp == COMPANY.BWS.value) else self.canvas_stg
        tiles = self.tiles_bws if (comp == COMPANY.BWS.value) else self.tiles_stg
        warranty_lines = self.list_warranty_lines_bws if (comp == COMPANY.BWS.value) else self.list_warranty_lines_stg
        df_warranties = self.df_multi_combobox_data_warranties_bws if (comp == COMPANY.BWS.value) else self.df_multi_combobox_data_orders_stg
        df_orders = self.df_orders_bws if (comp == COMPANY.BWS.value) else self.df_orders_stg
        combobox_warranties = self.multi_combobox_warranties_bws if (comp == COMPANY.BWS.value) else self.multi_combobox_warranties_stg
        combobox_orders = self.multi_combobox_orders_bws if (comp == COMPANY.BWS.value) else self.multi_combobox_orders_stg

        if ap:

            date, line = date_line
            is_warranty = line in warranty_lines
            if tm:
                print(f"{is_warranty=}")

            if from_undo:
                if is_warranty:
                    war_job = df_warranties[df_orders_id]["Job"]
                else:
                    quote = df_orders.iloc[df_orders_id][self.quote_key("quote")]
            else:
                if is_warranty:
                    war_job = combobox_warranties.res_tv_entry.get()
                else:
                    quote = combobox_orders.res_tv_entry.get()
            if isinstance(date, str):
                date = pd.Timestamp(date)
            order_already_exists = tiles[date][line].get("order", None)

            if order_already_exists is not None:
                # there is already a tile in this position.
                if is_warranty:
                    exist_war_job = df_warranties.iloc[order_already_exists]["Job"]
                    ans = messagebox.askyesnocancel(
                        title=self.title_application_short,
                        message=f"'{exist_war_job}' already scheduled for {datetime_utility.date_str_format(date)} on '{line}'.\nAre you sure you want to place '{war_job}' here instead?",
                        parent=self
                    )
                    if ans == ctk.YES:
                        # move existing unit to combobox, then place this new one
                        self.delete_tile(date_line)
                    else:
                        # return the dragging tile to the combobox and stop
                        self.clear_master_drag_tile()
                        return
                else:
                    exist_quote = df_orders.iloc[order_already_exists][self.quote_key("quote")]
                    ans = messagebox.askyesnocancel(
                        title=self.title_application_short,
                        message=f"'{exist_quote}' already scheduled for {datetime_utility.date_str_format(date)} on '{line}'.\nAre you sure you want to place '{quote}' here instead?",
                        parent=self
                    )
                    if ans == ctk.YES:
                        # move existing unit to combobox, then place this new one
                        self.delete_tile(date_line)
                    else:
                        # return the dragging tile to the combobox and stop
                        self.clear_master_drag_tile()
                        return

            bbox = self.get_tile_bbox(date, line)
            # order = self.tiles_stg[date][line].get("order")
            if is_warranty:
                row = df_warranties.iloc[df_orders_id]
            else:
                row = df_orders.iloc[df_orders_id]
            texts = tiles[date][line].get("texts", [])
            drag_texts = self.multi_combobox_drag_tile_texts

            tile_text_colour = self.colour_tile_foreground
            font = self.font_tile

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

                tw = self.tile_width_bws if (comp == COMPANY.BWS.value) else self.tile_width_stg
                th = self.tile_height_bws if (comp == COMPANY.BWS.value) else self.tile_height_stg
                texts = [
                    can.create_text(
                        int(bbox[0] + (tw * 0.5)),
                        int(bbox[1] + ((k + 1) * th / (1 + len(to_do_texts)))),
                        text=txt,
                        fill=tile_text_colour.hex_code,
                        font=font
                    )
                    for k, txt, in enumerate(to_do_texts)
                ]

                n_txts = len(texts)
                bw = float(can.itemcget(tiles[date][line]["tile"], "width"))
                y_t = bbox[1] + bw
                for i, txts_ in enumerate(zip(texts, to_do_texts)):
                    txt, text = txts_
                    can.coords(txt, bbox[0] + (tw / 2), y_t + ((i + 1) * (th / (n_txts + 1))))
                    can.itemconfigure(txt, text=text)

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
                    mc_wo = row[self.quote_key("WO#")]
                    mc_model = row[self.quote_key("Model No")]
                    mc_dealer = row[self.quote_key("dealer")]
                    mc_galv = row[self.quote_key("galv")]
                    mc_vals = [mc_quote, mc_wo, mc_model, mc_dealer, mc_galv]
                for txt, text in zip_longest(texts, mc_vals):
                    if text is not None:
                        can.itemconfigure(txt, text=text)
                    else:
                        can.itemconfigure(txt, state=ctk.HIDDEN)

            # df_order_in_mc = self.multi_combobox_orders_stg.tree_controller.df.loc[self.multi_combobox_orders_stg.tree_controller.df["SGQuote"] == quote]
            if is_warranty:
                combobox_warranties.delete_item(value=war_job, mode="all")
            else:
                combobox_orders.delete_item(value=quote, mode="all")

            if tm:
                print(f"SETTING {date=}, {line=} == {{'order': {df_orders_id}, 'texts': {texts}}}")
            if comp == COMPANY.BWS.value:
                self.df_ids_to_date_line_bws[df_orders_id] = date_line
            else:
                self.df_ids_to_date_line_stg[df_orders_id] = date_line
            tiles[date][line].update({
                "order": df_orders_id,
                "texts": texts
            })
            if not from_undo:
                # self.history.append(
                #     ("INSERT", df_orders_id, date_line)
                # )

                hist = list(self.history.get())
                hist.append(("INSERT", df_orders_id, date_line))
                self.history.set(hist)

            self.colour_code(date, line)
            if tm:
                # print(f"\n\tPOST INSERT\n{self.history=}")
                print(f"\n\tPOST INSERT\n{self.history.get()=}")
            self.select_tile(date, line)
            self.update_selected_tiles()
            self.redraw_legend()
            if do_animate is not None:
                self.flash_tile(date_line, mode=do_animate)
        else:
            if tm:
                print(self.msg_no_movement_non_publish)

    def swap_tiles(
            self,
            date_line_1: tuple[pd.Timestamp, str],
            date_line_2: tuple[pd.Timestamp, str],
            from_undo: bool = False,
            do_animate: None | str = None
    ) -> None:
        tm = self.settings["TEST_MODE"].get()

        ap = self.settings["allowed_to_publish"].get()

        comp = self.settings["mode_company"]
        # can = self.canvas_bws if (comp == COMPANY.BWS.value) else self.canvas_stg
        tiles = self.tiles_bws if (comp == COMPANY.BWS.value) else self.tiles_stg
        warranty_lines = self.list_warranty_lines_bws if (comp == COMPANY.BWS.value) else self.list_warranty_lines_stg
        # df_warranties = self.df_multi_combobox_data_warranties_bws if (comp == COMPANY.BWS.value) else self.df_multi_combobox_data_orders_stg
        # df_orders = self.df_orders_bws if (comp == COMPANY.BWS.value) else self.df_orders_stg
        # combobox_warranties = self.multi_combobox_warranties_bws if (comp == COMPANY.BWS.value) else self.multi_combobox_warranties_stg
        # combobox_orders = self.multi_combobox_orders_bws if (comp == COMPANY.BWS.value) else self.multi_combobox_orders_stg

        if ap:
            date_1, line_1 = date_line_1
            date_2, line_2 = date_line_2

            is_war_1 = line_1 in warranty_lines
            is_war_2 = line_2 in warranty_lines
            if (is_war_1 + is_war_2) % 2 != 0:
                # 1 of these units comes from warranty
                messagebox.showinfo(
                    title=self.title_application_short,
                    message=f"Cannot swap production units with warranty units",
                    parent=self
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
                order_1, order_2 = tiles[date_1][line_1].get("order"), tiles[date_2][line_2].get(
                    "order")
                texts_1, texts_2 = tiles[date_1][line_1].get("texts"), tiles[date_2][line_2].get(
                    "texts")
                tile_1, tile_2 = tiles[date_1][line_1].get("tile"), tiles[date_2][line_2].get("tile")
                if tm:
                    print(f"{texts_1=}, {texts_2=}")

                # swap df_ids_to_date_line_stg
                if order_1 is not None:
                    if comp == COMPANY.BWS.value:
                        self.df_ids_to_date_line_bws[order_1] = date_line_2
                    else:
                        self.df_ids_to_date_line_stg[order_1] = date_line_2
                if order_2 is not None:
                    if comp == COMPANY.BWS.value:
                        self.df_ids_to_date_line_bws[order_2] = date_line_1
                    else:
                        self.df_ids_to_date_line_stg[order_2] = date_line_1

                if comp == COMPANY.BWS.value:
                    # swap df_orders_stg indexes
                    self.tiles_bws[date_1][line_1]["order"] = order_2
                    self.tiles_bws[date_2][line_2]["order"] = order_1

                    # swap texts for rendering
                    self.tiles_bws[date_1][line_1]["texts"] = texts_2
                    self.tiles_bws[date_2][line_2]["texts"] = texts_1

                    # swap positions on canvas_bws
                    self.canvas_bws.coords(tile_1, *bbox_2)
                    self.canvas_bws.coords(tile_2, *bbox_1)

                    # swap the tile ids
                    self.tiles_bws[date_1][line_1]["tile"] = tile_2
                    self.tiles_bws[date_2][line_2]["tile"] = tile_1
                else:
                    # swap df_orders_stg indexes
                    self.tiles_stg[date_1][line_1]["order"] = order_2
                    self.tiles_stg[date_2][line_2]["order"] = order_1

                    # swap texts for rendering
                    self.tiles_stg[date_1][line_1]["texts"] = texts_2
                    self.tiles_stg[date_2][line_2]["texts"] = texts_1

                    # swap positions on canvas_stg
                    self.canvas_stg.coords(tile_1, *bbox_2)
                    self.canvas_stg.coords(tile_2, *bbox_1)

                    # swap the tile ids
                    self.tiles_stg[date_1][line_1]["tile"] = tile_2
                    self.tiles_stg[date_2][line_2]["tile"] = tile_1

                # animate success
                if do_animate is not None:
                    self.flash_tile(date_line_1, mode=do_animate)
                    self.flash_tile(date_line_2, mode=do_animate)

                if not from_undo:
                    if order_1 or order_2:
                        # one of these tiles_stg is an order, record in the history and allow undos.
                        # self.history.append(
                        #     ("SWAP", date_line_1, date_line_2)
                        # )

                        hist = list(self.history.get())
                        hist.append(("SWAP", date_line_1, date_line_2))
                        self.history.set(hist)

                if tm:
                    print(
                        f"AFTER SWAP\n\tself.tiles_stg[{date_1}][{line_1}]={tiles[date_1][line_1]}\n\tself.tiles_stg[{date_2}][{line_2}]={tiles[date_2][line_2]}")

        else:
            if tm:
                print(self.msg_no_movement_non_publish)

    def on_right_click_calendar(self, event) -> None:
        tm = self.settings["TEST_MODE"].get()
        ap = self.settings["allowed_to_publish"].get()
        slw = self.tl_tv_switch_show_left_widgets.get()
        slw = 0 if (slw == "No") else 1
        ap = ap and slw
        comp = self.settings["mode_company"]
        can = self.canvas_bws if (comp == COMPANY.BWS.value) else self.canvas_stg
        tiles = self.tiles_bws if (comp == COMPANY.BWS.value) else self.tiles_stg
        if tm:
            print(f"on_right_click_calendar")
        ex, ey = event.x, event.y
        ex, ey = can.canvasx(ex), can.canvasy(ey)
        date, line = self.get_date_line_at_x_y(ex, ey)
        order = tiles[date][line].get("order", None)
        if tm:
            print(f"{date=}, {line=}, {order=}")
        if (date is not None) and (line is not None) and (order is not None):
            # delete tile
            if tm:
                print(f"DELETE {date=}, {line=}")
            if ap:
                self.delete_tile((date, line))
            else:
                self.show_quote_info_tl(date, line)
            # self.insert_tile(dfad)
        if not ap:
            self.clear_selected_tiles()

    def on_left_click_calendar(self, event):
        tm = self.settings["TEST_MODE"].get()
        if tm:
            print(f"on_left_click_calendar_ {event=}")
        ht = self.app_state["hovered"]
        st = self.app_state["selected"]
        dt = self.app_state["dragged"]
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
        print(f"{event.widget=}")
        if not self.tv_done_interact_tl.get():
            print(f"NOT DONE WITH TL")
            return

        comp = self.settings["mode_company"]
        can = self.canvas_bws if (comp == COMPANY.BWS.value) else self.canvas_stg
        tiles = self.tiles_bws if (comp == COMPANY.BWS.value) else self.tiles_stg
        can = self.canvas_bws if (comp == COMPANY.BWS.value) else self.canvas_stg
        tiles = self.tiles_bws if (comp == COMPANY.BWS.value) else self.tiles_stg
        warranty_lines = self.list_warranty_lines_bws if (comp == COMPANY.BWS.value) else self.list_warranty_lines_stg
        df_warranties = self.df_multi_combobox_data_warranties_bws if (comp == COMPANY.BWS.value) else self.df_multi_combobox_data_orders_stg
        df_orders = self.df_orders_bws if (comp == COMPANY.BWS.value) else self.df_orders_stg
        combobox_warranties = self.multi_combobox_warranties_bws if (comp == COMPANY.BWS.value) else self.multi_combobox_warranties_stg
        combobox_orders = self.multi_combobox_orders_bws if (comp == COMPANY.BWS.value) else self.multi_combobox_orders_stg

        tm = self.settings["TEST_MODE"].get()
        st = self.app_state["selected"]
        dt = self.app_state["dragged"]
        x, y = event.x, event.y
        o_x, o_y = can.canvasx(x), can.canvasy(y)
        date, line = self.get_date_bucket(o_x), self.get_prod_line_bucket(o_y)
        # tile_data = self.get_tile_at_x_y(o_x, o_y)
        # if tm:
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
            if self.is_valid_prod_date(date) != "weekend":
                # weekday placement
                stat_idx = tiles.get(date, {}).get(line, {}).get("order", None)
                stat_tile = tiles.get(date, {}).get(line, {}).get("tile", None)
                stat_bbox = self.get_tile_bbox(date, line)
                drag_bbox = self.get_tile_bbox(drag_date, drag_line)
                stat_texts = tiles[date][line].get("texts", [])
                drag_texts = tiles[drag_date][drag_line].get("texts", [])
                self.select_tile(date, line)  # swap selected tile for info frame change
                self.swap_tiles((drag_date, drag_line), (date, line), do_animate="valid")

                self.drag_tile(date, line)  # add the stationary tile for drag re-adjustment
            else:
                # weekend placement
                self.flash_tile((date, line), mode="invalid_we")

            self.clear_drag_tiles()
            self.clear_selected_tiles()

        else:

            # if not st:
            #     print(f"NOT SELECTED")
            #     return

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
                    o_id = tiles[s_date][s_line].get('order', None)
                    is_warranty = s_line in warranty_lines
                    if o_id:
                        if is_warranty:
                            war_job = df_warranties[o_id]["Job"]
                            if tm:
                                print(f"\tSel: <{sel=}>, <{o_id=}>, <{war_job=}>")
                        else:
                            quote = df_orders.iloc[o_id][self.quote_key("quote")] if (o_id is not None) else None
                            if tm:
                                print(f"\tSel: <{sel=}>, <{o_id=}>, <{quote=}>")
                        # self.app_state["selected"].append(sel)
                        orders.append(sel)
                    else:
                        print(f"no order")
                self.update_selected_tiles()
                if tm:
                    print(f"END SELECTED = {self.app_state['selected']=}")

        print(f"{orders=}")
        if not orders:
            self.clear_info_frame()

    def on_left_click_root_canvas(self, event) -> None:
        tm = self.settings["TEST_MODE"].get()
        if tm:
            print(f"on_left_click_root_canvas {datetime.datetime.now():%Y-%m-%d %H:%M:%S}")

    def drag_treeview_warranty_entry(self, event):
        tm = self.settings["TEST_MODE"].get()
        if tm:
            print(f"drag_treeview_warranty_entry {event=}")
        self.drag_treeview_entry(event)

    def release_treeview_warranty_entry(self, event):
        tm = self.settings["TEST_MODE"].get()
        if tm:
            print(f"release_treeview_warranty_entry {event=}")
        self.release_treeview_entry(event)

    def drag_treeview_entry(self, event):
        tm = self.settings["TEST_MODE"].get()
        if tm:
            print(f"drag_treeview_entry, {event=}")
        # is_warranty = self.toggle_warranty.value.get() == "Warranty"
        is_warranty = self.tv_toggle_warranty.get() == "Warranty"

        comp = self.settings["mode_company"]
        # can = self.canvas_bws if (comp == COMPANY.BWS.value) else self.canvas_stg
        # tiles = self.tiles_bws if (comp == COMPANY.BWS.value) else self.tiles_stg
        # warranty_lines = self.list_warranty_lines_bws if (comp == COMPANY.BWS.value) else self.list_warranty_lines_stg
        # df_warranties = self.df_multi_combobox_data_warranties_bws if (comp == COMPANY.BWS.value) else self.df_multi_combobox_data_orders_stg
        df_orders = self.df_orders_bws if (comp == COMPANY.BWS.value) else self.df_orders_stg
        combobox_warranties = self.multi_combobox_warranties_bws if (comp == COMPANY.BWS.value) else self.multi_combobox_warranties_stg
        combobox_orders = self.multi_combobox_orders_bws if (comp == COMPANY.BWS.value) else self.multi_combobox_orders_stg

        if tm:
            print(f"\t{is_warranty=}")

        treeview = combobox_orders.tree_treeview
        vcn = combobox_orders.tree_controller.viewable_column_names
        tv_dt = self.tv_multi_combobox_drag_tile.get()
        # self.multi_combobox_canvas_drag_tile.grid_forget()
        tw = self.tile_width_bws if (comp == COMPANY.BWS.value) else self.tile_width_stg
        th = self.tile_height_bws if (comp == COMPANY.BWS.value) else self.tile_height_stg
        h_multi_combobox_toggle = self.h_tb_warranty
        e_x, e_y = event.x, event.y
        e_x1, e_y1 = self.invisible_canvas.canvasx(e_x), self.invisible_canvas.canvasy(e_y)
        bbf = combobox_orders.bbox()
        mcy = combobox_orders.winfo_y()
        hmct = self.h_tb_warranty
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
                    war_job = combobox_warranties.res_tv_entry.get()
                    new_texts = [war_job]
                else:
                    quote = combobox_orders.res_tv_entry.get()
                    order_id = df_orders.loc[df_orders[self.quote_key("quote")] == quote].index
                    quote_data = list(df_orders.iloc[order_id].iterrows())[0][1]
                    # print(f"{quote_data=}")

                    mc_quote = quote
                    mc_wo = quote_data[self.quote_key("WO#")]
                    mc_model = quote_data[self.quote_key("Model No")]
                    mc_dealer = quote_data[self.quote_key("dealer")]
                    mc_galv = quote_data[self.quote_key("galv")]

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

        self.invisible_canvas.coords(self.dot, e_x - 10, e_y - 10, e_x + 10, e_y + 10)

    def release_treeview_entry(self, event):
        tm = self.settings["TEST_MODE"].get()
        if tm:
            print(f"release_treeview_entry")
        # self.multi_combobox_canvas_drag_tile.grid_forget()
        # is_warranty = self.toggle_warranty.value.get() == "Warranty"
        is_warranty = self.tv_toggle_warranty.get() == "Warranty"

        comp = self.settings["mode_company"]
        can = self.canvas_bws if (comp == COMPANY.BWS.value) else self.canvas_stg
        tiles = self.tiles_bws if (comp == COMPANY.BWS.value) else self.tiles_stg
        lines = self.list_prod_lines_bws if (comp == COMPANY.BWS.value) else self.list_prod_lines_stg
        warranty_lines = self.list_warranty_lines_bws if (comp == COMPANY.BWS.value) else self.list_warranty_lines_stg
        df_warranties = self.df_multi_combobox_data_warranties_bws if (
                    comp == COMPANY.BWS.value) else self.df_multi_combobox_data_orders_stg
        df_orders = self.df_orders_bws if (comp == COMPANY.BWS.value) else self.df_orders_stg
        combobox_warranties = self.multi_combobox_warranties_bws if (
                    comp == COMPANY.BWS.value) else self.multi_combobox_warranties_stg
        combobox_orders = self.multi_combobox_orders_bws if (
                    comp == COMPANY.BWS.value) else self.multi_combobox_orders_stg
        info_frame = self.info_frame_bws if (comp == COMPANY.BWS.value) else self.info_frame_stg

        if tm:
            print(f"\t{is_warranty=}")
        # self.multi_combobox_orders_stg.grid()
        self.tv_multi_combobox_drag_tile.set(False)
        self.invisible_canvas.itemconfigure(self.multi_combobox_drag_tile, state="hidden")
        e_x, e_y = event.x, event.y
        tw = self.tile_width_bws if (comp == COMPANY.BWS.value) else self.tile_width_stg
        th = self.tile_height_bws if (comp == COMPANY.BWS.value) else self.tile_height_stg

        x_fc = getattr(self, "x_place_frame_canvas", 0)
        y_fc = getattr(self, "y_place_frame_canvas", 0)
        w_fc = getattr(self, "w_place_frame_canvas", 1)
        h_fc = getattr(self, "h_place_frame_canvas", 1)

        x_mc = getattr(self, "x_place_frame_multi_combobox", 0)
        y_mc = getattr(self, "y_place_frame_multi_combobox", 0)

        x_if = getattr(self, "x_place_frame_info_frame", 0)
        y_if = getattr(self, "y_place_frame_info_frame", 0)

        # bbox_canvas = self.canvas_stg.bbox()
        # bbox_if = self.info_frame_stg.bbox()
        # bbox_mc = self.multi_combobox_orders_stg.bbox()
        bbox_canvas = list(self.frame_canvas.bbox(can))
        bbox_if = list(self.frame_info_frame.bbox(info_frame))
        bbox_mc = list(self.frame_multi_combobox.bbox(combobox_orders))

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

        self.invisible_canvas.coords(self.dot, e_x - 10, e_y - 10, e_x + 10, e_y + 10)

        if tm:
            print(f"\n\t{e_x=}, {e_y=}\n\t{x_fc=}, {y_fc=}\n\t{bbox_canvas=}\n\t{bbox_if=}\n\t{bbox_mc=}")
        if (bbox_canvas[0] <= e_x <= bbox_canvas[2]) and (bbox_canvas[1] <= e_y <= bbox_canvas[3]):
            date_line = self.get_date_line_at_x_y(can.canvasx(e_x - x_fc), can.canvasy(e_y - y_fc))
            # date_line = self.get_date_line_at_x_y(self.canvas_stg.canvasx(e_x), self.canvas_stg.canvasy(e_y))
            if date_line:
                date, line = date_line
                # if date.weekday() < 5:
                if self.is_valid_prod_date(date) == "weekend":
                    # dropped in calendar and on a weekday
                    # order_id = self.multi_combobox_orders_stg.res_tv_entry.get()

                    if is_warranty:

                        if line not in warranty_lines:
                            # return the dragging tile to the combobox and stop
                            messagebox.showinfo(
                                title=self.title_application_short,
                                message=f"Warranty units can only be placed in warranty lines:\n\t" + "\n\t".join(
                                    warranty_lines),
                                parent=self
                            )
                            self.flash_tile(date_line, mode="invalid")
                            self.clear_master_drag_tile()
                            return

                        war_job = combobox_warranties.res_tv_entry.get()
                        war_job_id = df_warranties.loc[
                            df_warranties["Job"] == war_job].index[0]

                        if tm:
                            # print(f"{quote=}, {order_id_1=}, {order_id_2=}, {order_id=}")
                            print(f"{war_job=}, {war_job_id=}")
                            print(f"dropped in calendar {date_line=}")
                        self.insert_tile(war_job_id, date_line, do_animate="valid")
                        try:
                            combobox_warranties.delete_item(value=war_job)
                        except ValueError as ve:
                            # quote not found in multi-combobox
                            pass
                        combobox_warranties.res_tv_entry.set("")
                    else:

                        if line in warranty_lines:
                            # return the dragging tile to the combobox and stop
                            prod_lines = [l for l in lines]
                            for l in warranty_lines:
                                prod_lines.remove(l)
                            messagebox.showinfo(
                                title=self.title_application_short,
                                message=f"Production units can only be placed in production lines:\n\t" + "\n\t".join(
                                    prod_lines),
                                parent=self
                            )
                            self.flash_tile(date_line, mode="invalid")
                            self.clear_master_drag_tile()
                            return

                        quote = combobox_orders.res_tv_entry.get()
                        # order_id_1 = self.df_orders_stg.loc[self.df_orders_stg["OrdersV2_SGQuote"] == quote].index
                        # order_id_2 = self.df_multi_combobox_data_orders_stg.loc[self.df_multi_combobox_data_orders_stg["SGQuote"] == quote].index
                        # order_id_2 = self.df_multi_combobox_data_orders_stg.loc[self.df_multi_combobox_data_orders_stg["SGQuote"] == quote].index
                        # order_id = order_id_2
                        order_id = df_orders.loc[df_orders[self.quote_key("Quote")] == quote].index[0]
                        if tm:
                            # print(f"{quote=}, {order_id_1=}, {order_id_2=}, {order_id=}")
                            print(f"{quote=}, {order_id=}")
                            print(f"dropped in calendar {date_line=}")
                        self.insert_tile(order_id, date_line, do_animate="valid")
                        try:

                            combobox_orders.delete_item(value=quote)
                        except ValueError as ve:
                            # quote not found in multi-combobox
                            pass

                        combobox_orders.res_tv_entry.set("")
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

        tm = self.settings["TEST_MODE"].get()
        if tm:
            print(f"FLASH TILE {date_line=}, {mode=} ", end="")
        date, line = date_line
        if isinstance(date, str) and date:
            date = pd.Timestamp(date)

        comp = self.settings["mode_company"]
        can = self.canvas_bws if (comp == COMPANY.BWS.value) else self.canvas_stg
        tiles = self.tiles_bws if (comp == COMPANY.BWS.value) else self.tiles_stg
        # lines = self.list_prod_lines_bws if (comp == COMPANY.BWS.value) else self.list_prod_lines_stg
        # warranty_lines = self.list_warranty_lines_bws if (comp == COMPANY.BWS.value) else self.list_warranty_lines_stg
        # df_warranties = self.df_multi_combobox_data_warranties_bws if (
        #             comp == COMPANY.BWS.value) else self.df_multi_combobox_data_orders_stg
        # df_orders = self.df_orders_bws if (comp == COMPANY.BWS.value) else self.df_orders_stg
        # combobox_warranties = self.multi_combobox_warranties_bws if (
        #             comp == COMPANY.BWS.value) else self.multi_combobox_warranties_stg
        # combobox_orders = self.multi_combobox_orders_bws if (
        #             comp == COMPANY.BWS.value) else self.multi_combobox_orders_stg
        # info_frame = self.info_frame_bws if (comp == COMPANY.BWS.value) else self.info_frame_stg

        tile_data = tiles[date][line]
        tile = tile_data["tile"]

        # movement work

        bba = can.bbox("all")
        bbaw = (bba[2] - bba[0])
        cw = self.canvas_width
        t_bbox = can.bbox(tile)
        x, y = int((t_bbox[0] - (cw / 2)) + ((t_bbox[2] - t_bbox[0]) / 2)), int(
            t_bbox[1] + ((t_bbox[3] - t_bbox[1]) / 2))
        x /= bbaw
        need_to_move = (bba[0] <= x <= bba[2])
        if tm:
            print(f"{need_to_move=}")
        # if do_move and need_to_move:
        if do_move:
            can.xview_moveto(x)
            self.redraw_legend()

        # flash work

        bg_f, fg_f, outline_f = None, None, None
        bg, fg, outline = \
            self.colour_tile_background, \
                self.colour_tile_foreground, \
                self.colour_tile_outline
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
                    self.colour_tile_background_weekend, \
                        self.colour_tile_foreground_weekend, \
                        self.colour_tile_outline_weekend

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
                       can.itemconfigure(tile_, fill=g_bg_, outline=g_ol_))

        # after animation, check if the tile is selected, then restore.
        if (sel := self.app_state.get("selected", None)) is not None:
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
        tm = self.settings["TEST_MODE"].get()

        comp = self.settings["mode_company"]
        # can = self.canvas_bws if (comp == COMPANY.BWS.value) else self.canvas_stg
        # tiles = self.tiles_bws if (comp == COMPANY.BWS.value) else self.tiles_stg
        # lines = self.list_prod_lines_bws if (comp == COMPANY.BWS.value) else self.list_prod_lines_stg
        # warranty_lines = self.list_warranty_lines_bws if (comp == COMPANY.BWS.value) else self.list_warranty_lines_stg
        # df_warranties = self.df_multi_combobox_data_warranties_bws if (
        #             comp == COMPANY.BWS.value) else self.df_multi_combobox_data_orders_stg
        # df_orders = self.df_orders_bws if (comp == COMPANY.BWS.value) else self.df_orders_stg
        combobox_warranties = self.multi_combobox_warranties_bws if (
                    comp == COMPANY.BWS.value) else self.multi_combobox_warranties_stg
        combobox_orders = self.multi_combobox_orders_bws if (
                    comp == COMPANY.BWS.value) else self.multi_combobox_orders_stg
        # info_frame = self.info_frame_bws if (comp == COMPANY.BWS.value) else self.info_frame_stg

        old_bind = combobox_orders.tree_controller.binding_treeview_b1_motion
        combobox_orders.tree_controller.treeview.bind("<B1-Motion>", self.drag_treeview_entry)
        combobox_orders.tree_controller.treeview.bind("<ButtonRelease-1>", self.release_treeview_entry)

        if tm:
            print(f"{old_bind=}")

        old_bind_war = combobox_warranties.tree_controller.binding_treeview_b1_motion
        combobox_warranties.tree_controller.treeview.bind("<B1-Motion>",
                                                                         self.drag_treeview_warranty_entry)
        combobox_warranties.tree_controller.treeview.bind("<ButtonRelease-1>",
                                                                         self.release_treeview_warranty_entry)

    def on_left_click_motion_calendar(self, event) -> None:
        tm = self.settings["TEST_MODE"].get()
        ap = self.settings["allowed_to_publish"].get()
        ht = self.app_state["hovered"]
        st = self.app_state["selected"]
        dt = self.app_state["dragged"]
        x, y = event.x, event.y

        comp = self.settings["mode_company"]
        can = self.canvas_bws if (comp == COMPANY.BWS.value) else self.canvas_stg
        tiles = self.tiles_bws if (comp == COMPANY.BWS.value) else self.tiles_stg
        # lines = self.list_prod_lines_bws if (comp == COMPANY.BWS.value) else self.list_prod_lines_stg
        # warranty_lines = self.list_warranty_lines_bws if (comp == COMPANY.BWS.value) else self.list_warranty_lines_stg
        # df_warranties = self.df_multi_combobox_data_warranties_bws if (
        #             comp == COMPANY.BWS.value) else self.df_multi_combobox_data_orders_stg
        # df_orders = self.df_orders_bws if (comp == COMPANY.BWS.value) else self.df_orders_stg
        # combobox_warranties = self.multi_combobox_warranties_bws if (
        #             comp == COMPANY.BWS.value) else self.multi_combobox_warranties_stg
        # combobox_orders = self.multi_combobox_orders_bws if (
        #             comp == COMPANY.BWS.value) else self.multi_combobox_orders_stg
        # info_frame = self.info_frame_bws if (comp == COMPANY.BWS.value) else self.info_frame_stg

        o_x, o_y = can.canvasx(x), can.canvasy(y)
        x_1, y_1, x_2, y_2 = self.get_current_canvas_view()
        if tm:
            print(f"{o_x=}, {o_y=}, {event.delta=}, {event=}")
            print(f"{ht=}, {st=}, {dt=}")
        if not st:
            # nothing selected, select the hovered and continue
            for date, line in ht:
                self.select_tile(date, line)

            st = self.app_state["selected"]

        p_x, p_y = self.app_state["cursor_drag_pos"]
        if p_x is None:
            p_x = x
        if p_y is None:
            p_y = y

        if ap:
            tw = self.tile_width_bws if (comp == COMPANY.BWS.value) else self.tile_width_stg
            th = self.tile_height_bws if (comp == COMPANY.BWS.value) else self.tile_height_stg
            # tw_w, th_w = self.tile_width_weekend, self.tile_height_weekend
            d_x, d_y = o_x - p_x, o_y - p_y
            for date, line in (dt + st):
                if self.is_valid_prod_date(date) != "weekend":
                    # only weekdays are allowed to move
                    td = tiles[date][line]
                    tile = td["tile"]
                    bw = float(can.itemcget(tile, "width"))
                    bbox = can.bbox(tile)
                    if tm:
                        print(f"\n{can.type(tile)=}")
                        print(f"{tile=}, {bbox=}")
                    t_x, t_y = bbox[0] + bw, bbox[1] + bw
                    if tm:
                        print(f"{date=}, {line=}, {d_x=}, {d_y=}, {t_x=}, {t_y=}")
                    # self.canvas_stg.move(tile, t_x + d_x, t_y + d_y)
                    can.coords(tile, o_x - (tw / 2), o_y - (th / 2), o_x + (tw / 2), o_y + (th / 2))
                    can.tag_raise(tile)
                    y_t = bbox[1] + bw

                    txts = tiles[date][line].get("texts", [])
                    for i, txt in enumerate(txts):
                        # self.canvas_stg.coords(txt, bbox[0] + (tw / 2), bbox[1] + (th / 2))
                        can.coords(txt, bbox[0] + (tw / 2), y_t + ((i + 1) * (th / (len(txts) + 1))))
                        can.tag_raise(txt)

                    if (date, line) not in dt:
                        self.drag_tile(date, line)

                    # self.get_tile_at_x_y()
                    self.hover_tile(date, line)

            self.app_state["cursor_drag_pos"] = (o_x, o_y)

    def on_motion_calendar(self, event) -> None:
        st = self.app_state["selected"]
        dt = self.app_state["dragged"]
        x, y = event.x, event.y

        comp = self.settings["mode_company"]
        can = self.canvas_bws if (comp == COMPANY.BWS.value) else self.canvas_stg

        o_x, o_y = can.canvasx(x), can.canvasy(y)
        # tile = self.canvas_stg.find_closest(ox, oy)
        date = self.get_date_bucket(o_x)
        line = self.get_prod_line_bucket(o_y)
        if date is None or line is None:
            self.clear_hover_tiles()
            return
        # self.canvas_stg.itemcget()
        # print(f"{x=}, {y=}, {o_x=}, {o_y=}, {date=}, {line=}, {st=}, {dt=}, {event=}")
        # self.app_state["hovered"].clear()

        # don't overwrite the selected and dragging tiles_stg with new hovers
        if (date, line) not in (st + dt):
            self.clear_hover_tiles()
            self.hover_tile(date, line)
            self.update_hover_tiles()

    def update_hover_tiles(self) -> None:
        ht = self.app_state["hovered"]
        st = self.app_state["selected"]
        ab = self.colour_tile_background_hover
        af = self.colour_tile_foreground_hover
        ao = self.colour_tile_outline_hover
        font = self.font_tile_hover
        ow = self.width_tile_outline_hover

        ab_w = self.colour_tile_background_weekend_hover
        af_w = self.colour_tile_foreground_weekend_hover
        ao_w = self.colour_tile_outline_weekend_hover
        font_w = self.font_tile_weekend_hover

        comp = self.settings["mode_company"]
        can = self.canvas_bws if (comp == COMPANY.BWS.value) else self.canvas_stg
        tiles = self.tiles_bws if (comp == COMPANY.BWS.value) else self.tiles_stg

        # print(f"UHT:: {ht=}, {st=}", end="")
        gc = self.calc_grid_cells_bws if (comp == COMPANY.BWS.value) else self.calc_grid_cells_stg
        y0_c0 = gc[0][0][1]
        y1_c0 = gc[0][0][3]

        for date, prod_line in ht:
            # is_weekend = date.weekday() >= 5
            is_weekend = self.is_valid_prod_date(date) == "weekend"
            tile = tiles[date][prod_line].get("tile", None)
            texts = tiles[date][prod_line].get("texts", [])
            if tile is not None:
                # print(f" TIN", end="")
                bbox = can.bbox(tile)
                y0, y1 = bbox[1], bbox[3]
                can.itemconfigure(
                    tile,
                    fill=(ab_w if is_weekend else ab).hex_code,
                    outline=(ao_w if is_weekend else ao).hex_code,
                    width=ow
                )
                if y1 < y0_c0:
                    can.tag_raise(tile)
            for text in texts:
                # print(f", '{text}'", end="")
                bbox = can.bbox(text)
                y0, y1 = bbox[1], bbox[3]
                can.itemconfigure(
                    text,
                    fill=(af_w if is_weekend else af).hex_code,
                    font=(font_w if is_weekend else font)
                )
                if y1 < y0_c0:
                    can.tag_raise(text)
            # print(f"")

            # if (date, prod_line) not in st:
            self.colour_code(date, prod_line)

    def clear_hover_tiles(self) -> None:
        ht = self.app_state["hovered"]
        st = self.app_state["selected"]
        dt = self.app_state["dragged"]
        b = self.colour_tile_background
        f = self.colour_tile_foreground
        o = self.colour_tile_outline
        font = self.font_tile

        b_w = self.colour_tile_background_weekend
        f_w = self.colour_tile_foreground_weekend
        o_w = self.colour_tile_outline_weekend
        font_w = self.font_tile_weekend

        comp = self.settings["mode_company"]
        can = self.canvas_bws if (comp == COMPANY.BWS.value) else self.canvas_stg
        tiles = self.tiles_bws if (comp == COMPANY.BWS.value) else self.tiles_stg
        lines = self.list_prod_lines_bws if (comp == COMPANY.BWS.value) else self.list_prod_lines_stg
        warranty_lines = self.list_warranty_lines_bws if (comp == COMPANY.BWS.value) else self.list_warranty_lines_stg
        df_warranties = self.df_multi_combobox_data_warranties_bws if (
                    comp == COMPANY.BWS.value) else self.df_multi_combobox_data_orders_stg
        df_orders = self.df_orders_bws if (comp == COMPANY.BWS.value) else self.df_orders_stg
        combobox_warranties = self.multi_combobox_warranties_bws if (
                    comp == COMPANY.BWS.value) else self.multi_combobox_warranties_stg
        combobox_orders = self.multi_combobox_orders_bws if (
                    comp == COMPANY.BWS.value) else self.multi_combobox_orders_stg
        info_frame = self.info_frame_bws if (comp == COMPANY.BWS.value) else self.info_frame_stg

        b_np = self.colour_tile_background_non_prod

        ow = self.width_tile_outline
        # print(f"{(st + dt)=}")

        # ensure that the selected and dragging tiles_stg are not blanked
        sub_ht = [key for key in ht if key not in (st + dt)]

        self.app_state["hovered"].clear()
        for date, prod_line in sub_ht:
            # is_weekend = date.weekday() >= 5
            valid_status = self.is_valid_prod_date(date)
            is_weekend = valid_status == "weekend"
            non_prod = valid_status == "holiday"
            tile = tiles[date][prod_line].get("tile", None)
            texts = tiles[date][prod_line].get("texts", [])
            if tile is not None:
                can.itemconfigure(
                    tile,
                    fill=(b_w if is_weekend else (b_np if non_prod else b)).hex_code,
                    outline=(o_w if is_weekend else o).hex_code,
                    width=ow
                )
            for text in texts:
                # print(f"CONFIG: {self.canvas_stg.itemcget(text, 'text')=}")
                can.itemconfigure(
                    text,
                    fill=(f_w if is_weekend else f).hex_code,
                    font=(font_w if is_weekend else font)
                )

            self.colour_code(date, prod_line)

    def clear_master_drag_tile(self):
        self.invisible_canvas.itemconfigure(self.multi_combobox_drag_tile, state="hidden")
        for txt in self.multi_combobox_drag_tile_texts:
            self.invisible_canvas.itemconfigure(txt, state="hidden")

    def update_selected_tiles(self) -> None:
        # print(f"update_selected_tiles")
        st = self.app_state["selected"]
        ab = self.colour_tile_background_selected
        af = self.colour_tile_foreground_selected
        ao = self.colour_tile_outline_selected
        font = self.font_tile_selected

        comp = self.settings["mode_company"]
        can = self.canvas_bws if (comp == COMPANY.BWS.value) else self.canvas_stg
        tiles = self.tiles_bws if (comp == COMPANY.BWS.value) else self.tiles_stg

        ab_w = self.colour_tile_background_weekend_selected
        af_w = self.colour_tile_foreground_weekend_selected
        ao_w = self.colour_tile_outline_weekend_selected
        font_w = self.font_tile_weekend_selected

        ow = self.width_tile_outline_selected
        tm = self.settings["TEST_MODE"].get()
        if tm:
            print(f"{st=}")
        for date, prod_line in st:
            # is_weekend = date.weekday() >= 5
            is_weekend = self.is_valid_prod_date(date) == "weekend"
            tile = tiles[date][prod_line].get("tile", None)
            texts = tiles[date][prod_line].get("texts", [])
            if tile:
                can.itemconfigure(
                    tile,
                    fill=(ab_w if is_weekend else ab).hex_code,
                    outline=(ao_w if is_weekend else ao).hex_code,
                    width=ow
                )
            for text in texts:
                can.itemconfigure(
                    text,
                    fill=(af_w if is_weekend else af).hex_code,
                    font=(font_w if is_weekend else font)
                )

            # self.colour_code(date, prod_line)

    def clear_selected_tiles(self) -> None:
        st = self.app_state["selected"]
        b = self.colour_tile_background
        f = self.colour_tile_foreground
        o = self.colour_tile_outline
        font = self.font_tile

        b_w = self.colour_tile_background_weekend
        f_w = self.colour_tile_foreground_weekend
        o_w = self.colour_tile_outline_weekend
        font_w = self.font_tile_weekend

        comp = self.settings["mode_company"]
        can = self.canvas_bws if (comp == COMPANY.BWS.value) else self.canvas_stg
        tiles = self.tiles_bws if (comp == COMPANY.BWS.value) else self.tiles_stg

        ow = self.width_tile_outline
        for date, prod_line in st:
            # is_weekend = date.weekday() >= 5
            is_weekend = self.is_valid_prod_date(date) == "weekend"
            tile = tiles[date][prod_line].get("tile", None)
            texts = tiles[date][prod_line].get("texts", [])
            if tile:
                can.itemconfigure(
                    tile,
                    fill=(b_w if is_weekend else b).hex_code,
                    outline=(o_w if is_weekend else o).hex_code,
                    width=ow
                )
            for text in texts:
                # print(f"CONFIG: {self.canvas_stg.itemcget(text, 'text')=}")
                can.itemconfigure(
                    text,
                    fill=(f_w if is_weekend else f).hex_code,
                    font=(font_w if is_weekend else font)
                )
            self.colour_code(date, prod_line)
        self.app_state["selected"].clear()

    def clear_drag_tiles(self):
        tm = self.settings["TEST_MODE"].get()
        if tm:
            print(f"RESETTING DRAG TILES")
        # tw_w, th_w = self.tile_width_weekend, self.tile_height_weekend

        comp = self.settings["mode_company"]
        can = self.canvas_bws if (comp == COMPANY.BWS.value) else self.canvas_stg
        tiles = self.tiles_bws if (comp == COMPANY.BWS.value) else self.tiles_stg
        tw = self.tile_width_bws if (comp == COMPANY.BWS.value) else self.tile_width_stg
        th = self.tile_height_bws if (comp == COMPANY.BWS.value) else self.tile_height_stg

        for date, line in self.app_state["dragged"]:
            bbox = self.get_tile_bbox(date, line)
            tile = tiles[date][line]["tile"]
            # print(f"{date=}, {line=}, {tile=}, {bbox=}")
            can.coords(tile, *bbox)

            texts = tiles[date][line].get("texts", [])
            for i, txt in enumerate(texts):
                tx, ty = int(bbox[0] + (tw * 0.5)), int(bbox[1] + ((i + 1) * th / (1 + len(texts))))
                can.coords(txt, tx, ty)
            self.colour_code(date, line)

        self.app_state["dragged"].clear()

    def undo(self, event):
        tm = self.settings["TEST_MODE"].get()
        if tm:
            # print(f"undo {self.history=}")
            print(f"undo {self.history.get()=}")
        # if self.history:
        if self.history.get():
            # action, *data = self.history.pop(-1)
            action, *data = list(self.history.get()).pop(-1)
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
        tm = self.settings["TEST_MODE"].get()
        if tm:
            print(f"submit_combobox_entry")

        comp = self.settings["mode_company"]
        df_orders = self.df_orders_bws if (comp == COMPANY.BWS.value) else self.df_orders_stg
        combobox_orders = self.multi_combobox_orders_bws if (
                    comp == COMPANY.BWS.value) else self.multi_combobox_orders_stg

        quote = combobox_orders.res_tv_entry.get().lower()
        n_mc_records = len(combobox_orders.tree_treeview.get_children())

        if n_mc_records:
            messagebox.showinfo(
                title=self.title_application_short,
                message=f"Please keep entering characters. There are still options in the combo-box below.",
                parent=self
            )
            return

        if len(str(quote)):
            select_cols = [
                self.quote_key("quote"),
                self.quote_key("WO#"),
                self.quote_key("Model No"),
                self.quote_key("dealer")
            ]
            df = df_orders[
                df_orders[select_cols].apply(
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
                    title=self.title_application_short,
                    message=f"Could not find anything matching '{quote}'.",
                    parent=self
                )

    def multi_combobox_entry_update(self, *args):
        tm = self.settings["TEST_MODE"].get()

        comp = self.settings["mode_company"]
        can = self.canvas_bws if (comp == COMPANY.BWS.value) else self.canvas_stg
        tiles = self.tiles_bws if (comp == COMPANY.BWS.value) else self.tiles_stg
        lines = self.list_prod_lines_bws if (comp == COMPANY.BWS.value) else self.list_prod_lines_stg
        warranty_lines = self.list_warranty_lines_bws if (comp == COMPANY.BWS.value) else self.list_warranty_lines_stg
        df_warranties = self.df_multi_combobox_data_warranties_bws if (
                    comp == COMPANY.BWS.value) else self.df_multi_combobox_data_orders_stg
        df_orders = self.df_orders_bws if (comp == COMPANY.BWS.value) else self.df_orders_stg
        combobox_warranties = self.multi_combobox_warranties_bws if (
                    comp == COMPANY.BWS.value) else self.multi_combobox_warranties_stg
        combobox_orders = self.multi_combobox_orders_bws if (
                    comp == COMPANY.BWS.value) else self.multi_combobox_orders_stg
        info_frame = self.info_frame_bws if (comp == COMPANY.BWS.value) else self.info_frame_stg

        quote = combobox_orders.res_tv_entry.get().lower()
        lq = len(quote)
        n_mc_records = len(combobox_orders.tree_treeview.get_children())
        if tm:
            print(f"multi_combobox_entry_update {quote=}, {n_mc_records=}")
        if n_mc_records > 0:
            # search text in multi-combobox
            pass
        else:
            select_cols = [
                self.quote_key("quote"),
                self.quote_key("WO#"),
                self.quote_key("Model No"),
                self.quote_key("dealer")
            ]
            df = df_orders[
                df_orders[select_cols].apply(
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
                    if comp == COMPANY.BWS.value:
                        date, line = self.df_ids_to_date_line_bws[idx]
                    else:
                        date, line = self.df_ids_to_date_line_stg[idx]
                    if tm:
                        print(f"{idx=}, {date=}, {line=}")
                    if (date is not None) and (line is not None) and (not pd.isna(date)) and (not pd.isna(line)):
                        self.select_tile(date, line)
                        self.update_selected_tiles()
                        self.flash_tile((date, line), mode="attention")

    def click_tl_tile(self, event, idx, tag):
        # select this tile, and flash it on the calendar
        tm = self.settings["TEST_MODE"].get()

        comp = self.settings["mode_company"]
        can = self.canvas_bws if (comp == COMPANY.BWS.value) else self.canvas_stg
        tiles = self.tiles_bws if (comp == COMPANY.BWS.value) else self.tiles_stg
        lines = self.list_prod_lines_bws if (comp == COMPANY.BWS.value) else self.list_prod_lines_stg
        warranty_lines = self.list_warranty_lines_bws if (comp == COMPANY.BWS.value) else self.list_warranty_lines_stg
        df_warranties = self.df_multi_combobox_data_warranties_bws if (
                    comp == COMPANY.BWS.value) else self.df_multi_combobox_data_orders_stg
        df_orders = self.df_orders_bws if (comp == COMPANY.BWS.value) else self.df_orders_stg
        combobox_warranties = self.multi_combobox_warranties_bws if (
                    comp == COMPANY.BWS.value) else self.multi_combobox_warranties_stg
        combobox_orders = self.multi_combobox_orders_bws if (
                    comp == COMPANY.BWS.value) else self.multi_combobox_orders_stg
        info_frame = self.info_frame_bws if (comp == COMPANY.BWS.value) else self.info_frame_stg

        if comp == COMPANY.BWS.value:
            date, line = self.df_ids_to_date_line_bws[idx]
        else:
            date, line = self.df_ids_to_date_line_stg[idx]

        if tm:
            print(f"{event=}, {idx=}, {tag=}")
            print(f"{date=}, {line=}")
        self.tl_data["tl_dataframe_choice"].destroy()
        self.grab_set()
        combobox_orders.res_tv_entry.set(df_orders.iloc[idx][self.quote_key("quote")])
        self.flash_tile((date, line), mode="attention")

    def motion_tl_tile(self, idx, tag, tidx=None, ttag=None):
        # a tile is being hovered, change its colour.

        comp = self.settings["mode_company"]

        for tile in self.tl_data["tiles_stg" if (comp == COMPANY.BWS.value) else "tiles_stg"]:
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
        tm = self.settings["TEST_MODE"].get()

        comp = self.settings["mode_company"]

        self.tl_data["bg"] = Colour("#006723")
        self.tl_data["fg"] = Colour("#101010")
        self.tl_data["tiles_stg"] = []
        self.tl_data["tiles_bws"] = []
        self.tl_data["texts"] = []

        if tm:
            print(f"CHOOSE FROM CHOICES\n{df=}")
        if not df.empty:
            self.tl_data["tl_dataframe_choice"] = ctk.CTkToplevel(self)
            self.tl_data["tl_dataframe_choice"].title(self.title_application_short + " - Choose")
            self.tl_data["frame_tl"] = ctk.CTkFrame(self.tl_data["tl_dataframe_choice"])
            n_choices = df.shape[0]
            max_choices_per_col = 4
            choices_per_col = min(n_choices, max_choices_per_col)
            n_rows = (n_choices // max_choices_per_col) + 1
            n_cols = choices_per_col

            if (n_rows < (n_cols / 2)) and (n_choices < (n_rows * n_cols)):
                # too many tiles_stg in 1 row, even it out
                n_cols -= 1
                n_rows = (n_choices // n_cols) + 1

            tw = self.tile_width_bws if (comp == COMPANY.BWS.value) else self.tile_width_stg
            th = self.tile_height_bws if (comp == COMPANY.BWS.value) else self.tile_height_stg
            x0, y0 = 0, 0
            xm, ym = 10, 10
            m = 2

            w = int((tw + m + m) * n_cols)
            h = int((th + m + m) * n_rows)

            self.tl_data["canvas_tl"] = ctk.CTkCanvas(
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
                print(f"AA {n_rows=}, {n_cols=}, {choices_per_col=}, {self.tl_data['tiles_stg']=}, {self.tl_data['tiles_bws']=}")
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
                    self.tl_data["tiles_bws" if (comp == COMPANY.BWS.value) else "tiles_stg"].append(
                        self.draw_rect(
                            (
                                x0_,
                                y0_,
                                x1_,
                                y1_
                            ),
                            fill=self.tl_data["bg"].hex_code,
                            # ,
                            # activefill=fc.brightened(0.25).hex_code
                            parent=self.tl_data["canvas_tl"]
                        )
                    )

                    mc_quote = str(quote_data[self.quote_key("quote")])
                    mc_wo = str(quote_data[self.quote_key("WO#")])
                    mc_model = str(quote_data[self.quote_key("Model No")])
                    mc_dealer = str(quote_data[self.quote_key("dealer")])
                    mc_galv = str(quote_data[self.quote_key("galv")])
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

                    tag = self.tl_data["tiles_bws" if (comp == COMPANY.BWS.value) else "tiles_stg"][-1]
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
                print(f"BB {n_rows=}, {n_cols=}, {choices_per_col=}, {self.tl_data['tiles_stg']=}, {self.tl_data['tiles_bws']=}")

            self.tl_data["frame_tl"].pack()
            self.tl_data["canvas_tl"].pack()

            if tm:
                print(f"{w=}, {h=}")

            tl_geom = customtkinter_utility.calc_geometry_tl(w, h, largest=True, rtype=dict)
            self.tl_data["tl_dataframe_choice"].title(self.title_application_full)
            self.tl_data["tl_dataframe_choice"].geometry(tl_geom["geometry"])
            self.tl_data["tl_dataframe_choice"].grab_set()
            self.wait_window(self.tl_data["tl_dataframe_choice"])

    def update_info_frame(self, date, prod_line):
        tm = self.settings["TEST_MODE"].get()
        print(f"update_info_frame")

        comp = self.settings["mode_company"]
        # can = self.canvas_bws if (comp == COMPANY.BWS.value) else self.canvas_stg
        tiles = self.tiles_bws if (comp == COMPANY.BWS.value) else self.tiles_stg
        # lines = self.list_prod_lines_bws if (comp == COMPANY.BWS.value) else self.list_prod_lines_stg
        # warranty_lines = self.list_warranty_lines_bws if (comp == COMPANY.BWS.value) else self.list_warranty_lines_stg
        # df_warranties = self.df_multi_combobox_data_warranties_bws if (
        #             comp == COMPANY.BWS.value) else self.df_multi_combobox_data_orders_stg
        df_orders = self.df_orders_bws if (comp == COMPANY.BWS.value) else self.df_orders_stg
        # combobox_warranties = self.multi_combobox_warranties_bws if (
        #             comp == COMPANY.BWS.value) else self.multi_combobox_warranties_stg
        # combobox_orders = self.multi_combobox_orders_bws if (
        #             comp == COMPANY.BWS.value) else self.multi_combobox_orders_stg
        # info_frame = self.info_frame_bws if (comp == COMPANY.BWS.value) else self.info_frame_stg

        if (date is not None) and (prod_line is not None):
            date_tile_data = tiles.get(date)
            tile, order = None, None
            if date_tile_data:
                tile = date_tile_data[prod_line]
                order = date_tile_data[prod_line].get("order")
            if tm:
                print(f"{tile=}")
            if order is not None:
                series = df_orders.iloc[order]
                delivery_date = self.calculate_nth_business_day(date, N_BUSINESS_DAYS_AVAIL_TO_DELIVERY)
                days_between = (delivery_date - date).days
                dat_1 = {
                    "KD": date,
                    "KL": prod_line,
                    "US Sale": series[self.quote_key("US Sale")],
                    "Quote#": series[self.quote_key("quote")],
                    "WO#": series[self.quote_key("WO#")],
                    "Model No": series[self.quote_key("Model No")],
                    "Dealer": series[self.quote_key("dealer")],
                    "Serial#": series[self.quote_key("sn")],
                    "Customer WO#": series[self.quote_key("Customer WO#")],
                    "Sched Finish": date,
                    "Sched Line": prod_line,
                    "Delivery Date (Est)": f"{delivery_date:%Y-%m-%d} (+ {days_between} days)"
                }
                # if tm:
                print(f"{dat_1=}", end="")
                if comp == COMPANY.BWS.value:
                    for k in self.info_frame_columns_bws:
                        v = dat_1.get(k, f"'{k}'=?")
                        self.info_frame_bws.change_value(k, v)
                    print(f" BWS")
                else:
                    for k in self.info_frame_columns_stg:
                        v = dat_1.get(k, f"'{k}'=?")
                        self.info_frame_stg.change_value(k, v)
                    print(f" STG")
        else:
            self.info_frame_stg.change_value("Quote#", "?")

    def clear_info_frame(self):
        print(f"clear_info_frame")
        comp = self.settings["mode_company"]

        if comp == COMPANY.BWS.value:
            for k in self.info_frame_columns_bws:
                self.info_frame_bws.change_value(k, "")
        else:
            for k in self.info_frame_columns_stg:
                self.info_frame_stg.change_value(k, "")

    def draw_rect(
            self,
            bbox: tuple[int, int, int, int] | list[int, int, int, int],
            fill: None | str | Colour = None,
            activefill: None | str | Colour = None,
            outline: None | str | Colour = None,
            activeoutline: None | str | Colour = None,
            width: None | int = None,
            parent: None | ctk.CTkCanvas = None,
            default_all: bool = False
    ):
        comp = self.settings["mode_company"]
        if parent is None:
            parent = self.canvas_bws if (comp == COMPANY.BWS.value) else self.canvas_stg

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
            args["fill"] = self.colour_tile_background.hex_code
            args["activefill"] = self.colour_tile_background_hover.hex_code
            args["outline"] = self.colour_tile_background.hex_code
            args["activeoutline"] = self.colour_tile_background_hover.hex_code
            args["width"] = self.width_tile_outline
        else:
            for k, v in zip(kwarg_keys, kwarg_vals):
                args[k] = v

        for k in kwarg_keys:
            if args[k] is None:
                del args[k]

        # print(f"{args=}")

        return parent.create_rectangle(*bbox, **args)

    def click_mb_go_to_today(self, event=None):
        tm = self.settings["TEST_MODE"].get()
        if tm:
            print(f"click_mb_go_to_today")
        comp = self.settings["mode_company"]
        date = pd.Timestamp(self.today)
        prod_lines = self.list_prod_lines_bws if (comp == COMPANY.BWS.value) else self.list_prod_lines_stg
        can = self.canvas_bws if (comp == COMPANY.BWS.value) else self.canvas_stg
        line = prod_lines[0]
        tile_data = (self.tiles_bws if (comp == COMPANY.BWS.value) else self.tiles_stg)[date][line]
        tile = tile_data["tile"]

        # movement work

        bba = can.bbox("all")
        bbaw = (bba[2] - bba[0])
        cw = self.canvas_width
        t_bbox = can.bbox(tile)
        x, y = int((t_bbox[0] - (cw / 2)) + ((t_bbox[2] - t_bbox[0]) / 2)), int(
            t_bbox[1] + ((t_bbox[3] - t_bbox[1]) / 2))
        x /= bbaw
        need_to_move = (bba[0] <= x <= bba[2])
        # if tm:
        #     print(f"{need_to_move=}")
        if need_to_move:
            can.xview_moveto(x)
            self.redraw_legend()

        for line_ in prod_lines:
            self.flash_tile((date, line_), mode="attention")

    def click_mb_shift_line(self, event=None):

        # w, h = 1400, 800
        w, h = self.calc_geometry["w"], self.calc_geometry["h"]
        wm, hm = 5, 5
        tl_name = "tl_shift_lines"
        self.tl_data[tl_name] = ctk.CTkToplevel(self)
        self.tl_data[tl_name].title(self.title_application_short + " - Shift Line")
        comp = self.settings["mode_company"]
        tiles = self.tiles_bws if (comp == COMPANY.BWS.value) else self.tiles_stg
        can = self.canvas_bws if (comp == COMPANY.BWS.value) else self.canvas_stg
        prod_lines = self.list_prod_lines_bws if (comp == COMPANY.BWS.value) else self.list_prod_lines_stg
        df_orders = self.df_orders_bws if (comp == COMPANY.BWS.value) else self.df_orders_stg

        bg_sl_main = Colour("#153001")
        bg_sl_vc = Colour("#051001")
        bg_sl_btn = Colour("#E0E0FF")
        fg_sl_btn = Colour("#051001")
        bg_sl_btn_hover = bg_sl_btn.brightened(0.25)
        fg_sl_btn_hover = fg_sl_btn.brightened(0.25)

        def update_quotes_affected(*args, do_snapshot_method: bool = False):
            print(f"update_quotes_affected")

            p_line = self.tl_data["combobox_lines"][2].get()
            n_days = self.tl_data["var_slider_n_days"].get()
            sd = self.tl_data["frame_sd"].var_date_entry.get()
            ed = self.tl_data["frame_ed"].var_date_entry.get()
            ed_disabled = self.tl_data["var_end_date_disabled"].get()

            if isinstance(sd, str):
                sd = datetime.datetime.strptime(sd, "%Y-%m-%d")

            if not ed_disabled:
                if isinstance(ed, str):
                    ed = datetime.datetime.strptime(ed, "%Y-%m-%d")
                # ed_a = ed + datetime.timedelta(days=n_days)
            else:
                ed = self.list_dates[-1]
                # ed_a = ed

            if comp == COMPANY.BWS.value:
                if sd < self.min_date_bws:
                    sd = self.min_date_bws
                if ed > self.max_date_bws:
                    ed = self.max_date_bws
            else:
                if sd < self.min_date_stg:
                    sd = self.min_date_stg
                if ed > self.max_date_stg:
                    ed = self.max_date_stg
            # sd = clamp(self.min_date_stg, sd, self.max_date_stg)
            # ed = clamp(self.min_date_stg, ed, self.max_date_stg)
            # ed_a = (ed + datetime.timedelta(days=n_days)) if (not ed_disabled) else ed
            ed_a = self.calculate_nth_business_day(ed, n_days) if (not ed_disabled) else ed

            # data = self.df_orders_stg.loc[self.df_orders_stg[""]]
            print(f"{self.min_date_bws=}, {self.max_date_bws=}")
            print(f"{self.min_date_stg=}, {self.max_date_stg=}")
            print(f"{ed=}, {sd=}, {p_line=}")
            data = []
            print(f"{self.tiles_bws=}")
            print(f"{self.tiles_stg=}")
            print(f"{self.list_dates=}")
            self.tl_data["tl_sl_data"] = {}
            for i, date in enumerate(self.list_dates[::-1]):
                # if not (sd <= date <= ed):
                #     print(f"\tCONT{sd=}, {ed=}, {date=}")
                #     continue
                if sd <= date <= ed:
                    for j, line in enumerate(prod_lines):
                        if (p_line == "All") or (line == p_line):
                            print(f"({i}, {j}), {line}, {date:%Y-%m-%d}, {p_line}")
                            # continue
                            date_tile_data = tiles.get(date, {})
                            date_line_data = date_tile_data.get(line)
                            order = None
                            quote = None
                            if date_line_data:
                                order = date_line_data.get("order")
                                if order:
                                    # df_o = self.df_orders_stg.loc[self.df_orders_stg["OrdersV2_SGQuote"]]
                                    df_o = df_orders.iloc[order]
                                    quote = df_o[self.quote_key("quote")]
                                    date_fmt = "%Y-%m-%d"
                                    nth_date = self.calculate_nth_business_day(date, n_days)
                                    date_f = f"{date:{date_fmt}}"
                                    nth_date_f = f"{nth_date:{date_fmt}}"
                                    print(f"-> {quote}")
                                    self.tl_data["tl_sl_data"][quote] = {
                                        "curr_date": date,
                                        "new_date": nth_date,
                                        "line": line,
                                        "order": order
                                    }
                                    if p_line == "All":
                                        data.append([quote, line, date_f, nth_date_f])
                                    else:
                                        data.append([quote, date_f, nth_date_f])
                            #     else:
                            #         print(f"\tCONT order is none {date_line_data=}, {date=}, {line=}")
                            # else:
                            #     print(f"\tCONT no date_line_data, {date=}, {line=}")
                    # if (p_line != "All") and (line != p_line):
                    #     print(f"\tCONT{line}, {p_line}")
                    #     continue
                    # date_tile_data = self.tiles_stg.get(date, {})
                    # date_line_data = date_tile_data.get(line)
                    # order = None
                    # quote = None
                    # if date_line_data:
                    #     order = date_line_data.get("order")
                    #     if order:
                    #         # df_o = self.df_orders_stg.loc[self.df_orders_stg["OrdersV2_SGQuote"]]
                    #         df_o = self.df_orders_stg.iloc[order]
                    #         quote = df_o["OrdersV2_SGQuote"]
                    #         date_fmt = "%Y-%m-%d"
                    #         nth_date = self.calculate_nth_business_day(date, n_days)
                    #         date = f"{date:{date_fmt}}"
                    #         nth_date = f"{nth_date:{date_fmt}}"
                    #         if p_line == "All":
                    #             data.append([quote, line, date, nth_date])
                    #         else:
                    #             data.append([quote, date, nth_date])
                    #     else:
                    #         print(f"\tCONT order is none {date_line_data=}, {date=}, {line=}")
                    # else:
                    #     print(f"\tCONT no date_line_data, {date=}, {line=}")

                    # print(f"EFFECTED: ij=({i}, {j}), {line=}, {date=}, {order=}, {quote=}")
            header = [col for col in self.list_sl_preview_table_cols]
            if p_line == "All":
                header.insert(1, "Line")
            data = [header, *data]
            print(f"{data=}")
            print(f"# rows: {len(data)}")
            lines_in_use = list()
            dates_in_use = list()

            if len(data) <= 1:
                data = [header, ["", "No Data", ""]]
                self.tl_data["tl_canvas_preview"].itemconfigure(self.tl_data["tl_canvas_lbl_no_data"], state="normal")
                if not do_snapshot_method:
                    self.tl_data["tl_canvas_preview"].delete("all")
            else:
                self.tl_data["tl_canvas_preview"].itemconfigure(self.tl_data["tl_canvas_lbl_no_data"], state="hidden")
                i_tag = self.tl_data.get("tl_canvas_preview_image")
                if i_tag is not None:
                    for tag in self.tl_data["tl_canvas_preview"].find_withtag(i_tag):
                        self.tl_data["tl_canvas_preview"].delete(tag)

                # x0, y0, x1, y1 = 0, 0, 350, 350
                # data was built in reverse
                # tl_date, br_date = data[-1][-2], data[1][-2]
                tl_date, br_date = sd, ed
                tl_line, br_line = prod_lines[0], prod_lines[-1]
                lines_in_use = [p_line] if p_line != "All" else prod_lines
                dates_in_use = pd.date_range(sd, ed_a).to_list()

                cw, ch = 100, 75
                self.tl_data["tl_sl_can_p_w"] = (len(dates_in_use) + 1) * cw
                self.tl_data["tl_sl_can_p_h"] = (len(lines_in_use) + 1) * ch
                self.tl_data["tl_canvas_preview"].configure(
                    width=self.tl_data["tl_sl_can_p_w"],
                    height=self.tl_data["tl_sl_can_p_h"]
                )

                if do_snapshot_method:

                    if p_line == "All":
                        # tl_line = data[-1][-3]
                        # br_line = data[1][-3]
                        print(f"A= {tl_date=}, {tl_line=}, {br_date=}, {br_line=}")
                        top_left_bbox = self.get_tile_bbox(tl_date, tl_line)
                        bot_right_bbox = self.get_tile_bbox(br_date, br_line)
                    else:
                        # br_line = tl_line = p_line
                        print(f"B= {tl_date=}, {tl_line=}, {br_date=}, {br_line=}")
                        top_left_bbox = self.get_tile_bbox(tl_date, tl_line)
                        bot_right_bbox = self.get_tile_bbox(br_date, br_line)
                    print(f"{top_left_bbox=}, {bot_right_bbox=}")

                    xv = can.xview()
                    x1, x2 = can.bbox("all")[0::2]
                    w = x2 - x1
                    vw = (xv[1] - xv[0]) * w
                    # print(f"{date=}, {line=}")
                    # print(f"{self.canvas_stg.xview()=}")
                    # print(f"{self.canvas_stg.bbox('all')=}")
                    bbox = top_left_bbox
                    # print(f"{bbox=}, {vw=}")
                    x = bbox[0]  # - (vw / 2)
                    x = max(0, x)
                    p = x / w
                    can.xview_moveto(p)
                    self.redraw_legend()

                    # self.canvas_stg.xview_moveto(self.canvas_stg.canvasx(x0) / self.canvas_stg.winfo_width())
                    # self.canvas_stg.yview_moveto(self.canvas_stg.canvasy(y0) / self.canvas_stg.winfo_height())
                    # x0 /= 10
                    # y0 /= 10
                    # x1 /= 10
                    # y1 /= 10
                    # x0, y0, x1, y1 = top_left_bbox[:2] + bot_right_bbox[-2:]
                    x0, y0, x1, y1 = 0, 0, 800, 800
                    print(
                        f"{x0:.2f}, {y0:.2f}, {x1:.2f}, {y1:.2f}, tl_date={tl_date:%Y-%m-%d}, {tl_line=}, br_date={br_date:%Y-%m-%d}, {br_line=}")
                    ps = can.postscript(colormode='color')
                    # Convert PostScript to image
                    image = Image.open(io.BytesIO(ps.encode('utf-8')))
                    # Crop the image to the viewport
                    image = image.crop((x0, y0, x1, y1))
                    # Convert the cropped image to a format suitable for tkinter
                    canvas_image = ImageTk.PhotoImage(image)
                    # Display the captured image in the viewport canvas
                    self.tl_data["tl_canvas_preview"].create_image(0, 0, image=canvas_image, anchor=ctk.NW)
                    self.tl_data[
                        "tl_canvas_preview"].image = canvas_image  # Keep a reference to avoid garbage collection

                    # self.tl_data["tl_canvas_preview"].itemconfigure(self.tl_data["tl_canvas_lbl_no_data"], state="hidden")
                    # i_tag = self.tl_data.get("tl_canvas_preview_image")
                    # if i_tag is not None:
                    #     for tag in self.tl_data["tl_canvas_preview"].find_withtag(i_tag):
                    #         self.tl_data["tl_canvas_preview"].delete(tag)
                    #
                    # x0, y0, x1, y1 = 0, 0, 350, 350
                    # image = ImageGrab.grab().crop((x0, y0, x1, y1))
                    # # Convert the captured image to a format suitable for tkinter
                    # canvas_image = ImageTk.PhotoImage(image)
                    # # Display the captured image in the viewport canvas_stg
                    # self.tl_data["tl_canvas_preview_image"] = self.tl_data["tl_canvas_preview"].create_image(0, 0, image=canvas_image, anchor=ctk.NW)
                    # self.tl_data["tl_canvas_preview"].image = canvas_image
                    # # self.tl_data["tl_canvas_preview"].itemconfigure(self.tl_data["tl_canvas_lbl_no_data"], state="normal")
                else:
                    self.tl_data["tl_canvas_preview"].delete("all")
                    nr, nc = len(lines_in_use) + 1, (ed_a - sd).days + 2
                    # if p_line == "All":
                    #     nr = 2

                    # create rectangle grid
                    self.tl_data["tl_sl_gc"] = utility.grid_cells(
                        self.tl_data["tl_sl_can_p_w"],
                        nc,
                        self.tl_data["tl_sl_can_p_h"],
                        nr
                    )
                    gc = self.tl_data["tl_sl_gc"]
                    self.tl_data["tl_sl_tags"] = list()
                    for row in gc:
                        row_tags = []
                        for x0_, y0_, x1_, y1_ in row:
                            row_tags.append({
                                "rect": self.tl_data["tl_canvas_preview"].create_rectangle(
                                    x0_, y0_, x1_, y1_,
                                    fill=self.colour_tile_background.hex_code
                                )
                            })
                        self.tl_data["tl_sl_tags"].append(row_tags)

                    # recolour weekends
                    for j, date in enumerate(dates_in_use, start=1):
                        # if date.weekday() >= 5:
                        #     weekend
                        valid_status = self.is_valid_prod_date(date)
                        if valid_status != "valid":
                            print(f"\tIF   {j=}, {date=}")
                            bg_col = self.colour_background_holiday if valid_status == "holiday" else self.colour_tile_background_weekend
                            for i, line in enumerate(lines_in_use, start=1):
                                self.tl_data["tl_canvas_preview"].itemconfigure(
                                    self.tl_data["tl_sl_tags"][i][j]["rect"],
                                    fill=bg_col.hex_code
                                )
                        else:
                            print(f"\tELSE {j=}, {date=}")

                    # print(f"{len(tags)=}, {len(tags[0])=}")
                    # print(f"{tags=}")

                    self.tl_data["tl_canvas_preview"].itemconfigure(
                        self.tl_data["tl_sl_tags"][0][0]["rect"],
                        fill=self.colour_tile_header_row_background.hex_code
                    )

                    # column header of day labels
                    for i in range(1):
                        print(f"{i=}")
                        for j, date in enumerate(dates_in_use, start=1):
                            print(f"\t{j=}")
                            self.tl_data["tl_sl_tags"][i][j].update({
                                "text": self.tl_data["tl_canvas_preview"].create_text(
                                    gc[i][j][0] + ((gc[i][j][2] - gc[i][j][0]) / 2),
                                    gc[i][j][1] + ((gc[i][j][3] - gc[i][j][1]) / 2),
                                    text=f"{date.day}",
                                    fill=self.colour_tile_header_row_foreground.hex_code
                                )
                            })
                            self.tl_data["tl_canvas_preview"].itemconfigure(
                                self.tl_data["tl_sl_tags"][i][j]["rect"],
                                fill=self.colour_tile_header_row_background.hex_code
                            )

                    # row header of line labels
                    for i, line in enumerate(lines_in_use, start=1):
                        # print(f"{i=}")
                        for j in range(1):
                            # print(f"\t{j=}")
                            self.tl_data["tl_sl_tags"][i][j].update({
                                "text": self.tl_data["tl_canvas_preview"].create_text(
                                    gc[i][j][0] + ((gc[i][j][2] - gc[i][j][0]) / 2),
                                    gc[i][j][1] + ((gc[i][j][3] - gc[i][j][1]) / 2),
                                    text=f"{line}",
                                    fill=self.colour_tile_header_col_foreground.hex_code
                                )
                            })
                            self.tl_data["tl_canvas_preview"].itemconfigure(
                                self.tl_data["tl_sl_tags"][i][j]["rect"],
                                fill=self.colour_tile_header_col_background.hex_code
                            )

                    print(f"{lines_in_use=}")
                    print(f"{dates_in_use=}")
                    x_off_arrow = 10
                    y_off_mult_line = 5
                    angle = 45
                    font_size = 16
                    self.tl_data["tl_sl_data_count_thru"] = {}
                    for i, line in enumerate(lines_in_use, start=1):
                        for j, date in enumerate(dates_in_use, start=1):

                            date_tile_data = tiles.get(date, {})
                            date_line_data = date_tile_data.get(line)
                            order = None
                            quote = None
                            if date_line_data:
                                order = date_line_data.get("order")
                                if order:
                                    df_o = df_orders.iloc[order]
                                    quote = df_o[self.quote_key("quote")]
                                    q_data = self.tl_data["tl_sl_data"].get(quote, {})
                                    c_date = q_data.get("curr_date")
                                    n_date = q_data.get("new_date")

                                    # tags[i][j].update({
                                    #     "text": self.tl_data["tl_canvas_preview"].create_text(
                                    #         gc[i][j][0] + ((gc[i][j][2] - gc[i][j][0]) / 2),
                                    #         gc[i][j][1] + ((gc[i][j][3] - gc[i][j][1]) / 2),
                                    #         text=f"{quote}"
                                    #     )
                                    # })
                                    text = f"{quote}"
                                    font = ImageFont.truetype("calibri.ttf", font_size)
                                    # text_width, text_height = font.getsize(text)
                                    text_width, text_height = font.getbbox(text)[2:]
                                    image = Image.new("RGBA", (text_width, text_height), (255, 255, 255, 0))
                                    draw = ImageDraw.Draw(image)
                                    draw.text((0, 0), text, font=font, fill="black")
                                    rotated_image = image.rotate(angle, expand=1)
                                    tk_image = ImageTk.PhotoImage(rotated_image)
                                    cw, ch = gc[i][j][2] - gc[i][j][0], gc[i][j][3] - gc[i][j][1]
                                    x = gc[i][j][0] + (cw / 2)
                                    y = gc[i][j][1] + (ch / 2)
                                    if (c_date is not None) and (n_date is not None):
                                        d_days = (n_date - c_date).days
                                    else:
                                        d_days = -1

                                    if (date, line) not in self.tl_data["tl_sl_data_count_thru"]:
                                        self.tl_data["tl_sl_data_count_thru"][(date, line)] = 0

                                    for k in range(d_days):
                                        date_ = date + datetime.timedelta(days=k)

                                        if (date_, line) not in self.tl_data["tl_sl_data_count_thru"]:
                                            self.tl_data["tl_sl_data_count_thru"][(date_, line)] = 0

                                        self.tl_data["tl_sl_data_count_thru"][(date_, line)] += 1
                                    # self.tl_data["tl_sl_data_count_thru"][(date, line)] += 1

                                    print(f"{self.tl_data['tl_sl_data_count_thru']=}")

                                    print(
                                        f"{x=:.2f}, {y=:.2f}, {text_width=:.2f}, {text_height=:.2f}, {text=}, {c_date=}, {n_date=}, {d_days=}")

                                    self.tl_data["tl_sl_tags"][i][j].update({
                                        "text": self.tl_data["tl_canvas_preview"].create_image(
                                            x, y,
                                            image=tk_image
                                        ),
                                        "tk_image": tk_image,
                                        "image": image,
                                        "rot_image": rotated_image
                                    })

                                    if sd <= date <= ed:
                                        self.tl_data["tl_sl_tags"][i][j].update({
                                            "arrow_m": self.tl_data["tl_canvas_preview"].create_line(
                                                x + x_off_arrow,
                                                y + (y_off_mult_line * self.tl_data["tl_sl_data_count_thru"][
                                                    (date, line)]),
                                                x + (d_days * cw) - x_off_arrow,
                                                y + (y_off_mult_line * self.tl_data["tl_sl_data_count_thru"][
                                                    (date, line)]),
                                                width=2,
                                                fill="#FF0000"
                                            ),

                                            "arrow_l": self.tl_data["tl_canvas_preview"].create_line(
                                                x + (d_days * cw) - (2 * x_off_arrow),
                                                y - 10 + (y_off_mult_line * self.tl_data["tl_sl_data_count_thru"][
                                                    (date, line)]),
                                                x + (d_days * cw) - x_off_arrow,
                                                y + (y_off_mult_line * self.tl_data["tl_sl_data_count_thru"][
                                                    (date, line)]),
                                                width=2,
                                                fill="#FF0000"
                                            ),

                                            "arrow_r": self.tl_data["tl_canvas_preview"].create_line(
                                                x + (d_days * cw) - (2 * x_off_arrow),
                                                y + 10 + (y_off_mult_line * self.tl_data["tl_sl_data_count_thru"][
                                                    (date, line)]),
                                                x + (d_days * cw) - x_off_arrow,
                                                y + (y_off_mult_line * self.tl_data["tl_sl_data_count_thru"][
                                                    (date, line)]),
                                                width=2,
                                                fill="#FF0000"
                                            )
                                        })

                    if not ed_disabled:
                        for i, line in enumerate(lines_in_use, start=1):
                            for j in range(n_days, 0, -1):
                                am = self.tl_data["tl_sl_tags"][i][-j].get("arrow_m")
                                al = self.tl_data["tl_sl_tags"][i][-j].get("arrow_l")
                                ar = self.tl_data["tl_sl_tags"][i][-j].get("arrow_r")
                                for t in (am, al, ar):
                                    if t is not None:
                                        self.tl_data["tl_canvas_preview"].itemconfigure(
                                            t,
                                            state="hidden"
                                        )

                            # # q = data[i][0]
                            # # q_line = p_line if (p_line != "All") else data[i][1]
                            # # cd = pd.Timestamp(data[i][-2])
                            # # nd = pd.Timestamp(data[i][-1])
                            # # j2 = dates_in_use.index(nd)
                            # print(f"{i=}, {j=}, {date=}, {cd=}, {q_line}, {line}, {q}")
                            # if (date == cd) and (q_line == line):
                            #     tags[i][j].update({
                            #         "text": self.tl_data["tl_canvas_preview"].create_text(
                            #             gc[i][j][0] + ((gc[i][j][2] - gc[i][j][0]) / 2),
                            #             gc[i][j][1] + ((gc[i][j][3] - gc[i][j][1]) / 2),
                            #             text=f"{q}"
                            #         )
                            #     })
                            # # self.tl_data["tl_canvas_preview"].itemconfigure(

                    for i, row_dat in enumerate(self.tl_data["tl_sl_tags"][1:], start=1):
                        for j, tag_data in enumerate(row_dat[1:], start=1):
                            text_tag = tag_data.get("text")
                            if text_tag is not None:
                                self.tl_data["tl_canvas_preview"].tag_raise(text_tag)

            self.tl_data["tl_sl_dates_in_use"] = dates_in_use.copy()
            self.tl_data["tl_sl_lines_in_use"] = lines_in_use.copy()
            self.tl_data["table_change_preview"].columns = len(header)
            self.tl_data["table_change_preview"].rows = len(data)
            self.tl_data["table_change_preview"].update_values(data)
            self.tl_data["label_count_preview"][0].set(f"{len(data) - 1} Quote(s)")
            check_warnings()

        def check_warnings():
            data = self.tl_data["table_change_preview"].get()[1:]
            p_line = self.tl_data["combobox_lines"][2].get()
            n_days = self.tl_data["var_slider_n_days"].get()
            sd = self.tl_data["frame_sd"].var_date_entry.get()
            ed = self.tl_data["frame_ed"].var_date_entry.get()
            direction = "forward"

            if isinstance(sd, str):
                sd = datetime.datetime.strptime(sd, "%Y-%m-%d")

            ed_disabled = self.tl_data["var_end_date_disabled"].get()

            min_date, max_date = self.list_dates[0], self.list_dates[-1]

            if len(data) > 1:

                if ed_disabled:
                    ed = max_date

                if isinstance(ed, str):
                    ed = datetime.datetime.strptime(ed, "%Y-%m-%d")

                # TODO consider business days here
                days_of_interest = pd.date_range(
                    sd - datetime.timedelta(days=n_days),
                    ed + datetime.timedelta(days=n_days)
                ).to_list()
                # days_of_interest = days_of_interest[:days_of_interest.index(sd)] + days_of_interest[days_of_interest.index(ed) + 1:]

                print(f"{days_of_interest=}")

                warnings = []
                warned_quotes = dict()
                written_warned_quotes = dict()
                if direction == "backward":
                    # TODO
                    pass
                else:
                    # for i, day in enumerate(days_of_interest[::-1]):
                    quotes_new_dates = {tup[0]: tup[-1] for tup in data}
                    dates_line_quote = {tup[-1]: {tup[-2]: tup[1] if p_line == "All" else p_line} for tup in data}
                    for row in data:
                        if p_line == "All":
                            quote, line_, curr_date_s, new_date_s = row
                        else:
                            quote, curr_date_s, new_date_s = row
                            line_ = p_line
                        curr_date, new_date = pd.Timestamp(curr_date_s), pd.Timestamp(new_date_s)
                        c_date_idx = days_of_interest.index(curr_date)
                        n_date_idx = c_date_idx + n_days
                        for line in prod_lines:
                            if (line != line_) or ((p_line != "All") and (p_line != line)):
                                continue
                            # # check quotes being moved
                            # e_quote = dates_line_quote[new_date_s].get(line)
                            # if e_quote is not None:
                            #     # warn there is already an order here.
                            #     warnings.append(f"Cannot move {quote} on {line_} to {new_date:%Y-%m-%d} from {curr_date:%Y-%m-%d} because {e_quote} is already there.")

                            data_date_line = tiles[new_date][line]
                            order = data_date_line.get("order")
                            if order is not None:
                                # warn there is already an order here.
                                e_quote = df_orders.iloc[order][self.quote_key("quote")]

                                if e_quote not in quotes_new_dates:
                                    warnings.append(
                                        f">  Cannot move {quote} on {line} to {new_date:%Y-%m-%d} from {curr_date:%Y-%m-%d} because {e_quote} is already there.")
                                    warned_quotes[(curr_date, new_date, line)] = quote
                                    written_warned_quotes[(curr_date, new_date, line)] = quote
                                else:
                                    if (new_date, line) in warned_quotes:
                                        o_quote = warned_quotes[(curr_date, new_date, line)]
                                        warnings.append(
                                            f">  Cannot move {quote} on {line} to {new_date:%Y-%m-%d} from {curr_date:%Y-%m-%d} because you are already moving {o_quote} there.")
                                        written_warned_quotes[(curr_date, new_date, line)] = o_quote
                                    else:
                                        warned_quotes[(curr_date, new_date, line)] = quote

                print(f"{self.tl_data['tl_sl_dates_in_use']=}")
                print(f"{self.tl_data['tl_sl_lines_in_use']=}")
                print(f"{warned_quotes=}")
                print(f"{warnings=}")
                self.tl_data["tl_textbox_warning"].configure(state="normal")
                self.tl_data["tl_textbox_warning"].delete("1.0", ctk.END)
                for i, warning in enumerate(warnings):
                    print(f"{warning=}")
                    # self.tl_data["tl_textbox_warning"].insert("1.0", warning)
                    self.tl_data["tl_textbox_warning"].insert(ctk.END, ("\n" if i != 0 else "") + warning)

                if not warnings:
                    self.tl_data["tl_textbox_warning"].insert(ctk.END,
                                                              "No Issues found.\nClick submit to commit this shift.")
                    font_colour = self.colour_sl_fg_text_warnings_preview_no_warn.hex_code
                    self.tl_data["btn_submit"][1].configure(state="normal")
                else:
                    font_colour = self.colour_sl_fg_text_warnings_preview_warn.hex_code
                    self.tl_data["btn_submit"][1].configure(state="disabled")

                for od, nd, line in written_warned_quotes:
                    quote = written_warned_quotes[(od, nd, line)]
                    print(f"{od=}, {nd=}, {line=}, {quote=}, ", end="")
                    try:
                        ts_idx = self.tl_data["tl_sl_dates_in_use"].index(od)
                    except (IndexError, ValueError):
                        ts_idx = None
                    print(f" {ts_idx=}, ", end="")
                    try:
                        l_idx = self.tl_data["tl_sl_lines_in_use"].index(line)
                    except (IndexError, ValueError):
                        l_idx = None
                    print(f" {l_idx=}, ", end="")

                    if (ts_idx is not None) and (l_idx is not None):
                        rect = self.tl_data["tl_sl_tags"][l_idx + 1][ts_idx + 1].get("rect")
                        print(f" {rect=}, ", end="")
                        col = Colour(self.tl_data["tl_canvas_preview"].itemcget(
                            rect, "fill"
                        ))
                        print(f" {col=}, ", end="\n")
                        self.tl_data["tl_canvas_preview"].itemconfigure(
                            rect,
                            fill=col.reden_c(0.3).hex_code
                        )
                    else:
                        print(f" ELSE ", end="\n")

                self.tl_data["tl_textbox_warning"].see(ctk.END)
                print(f"{self.tl_data['tl_textbox_warning'].get('1.0', ctk.END)=}")
                self.tl_data["tl_textbox_warning"].configure(
                    state="disabled",
                    text_color=font_colour
                )

        def update_shift_text(*args):
            line = self.tl_data["combobox_lines"][2].get()
            n_days = self.tl_data["var_slider_n_days"].get()
            sd = self.tl_data["frame_sd"].var_date_entry.get()
            ed = self.tl_data["frame_ed"].var_date_entry.get()

            ed_disabled = self.tl_data["var_end_date_disabled"].get()

            min_date, max_date = self.list_dates[0], self.list_dates[-1]

            if isinstance(sd, str):
                sd = datetime.datetime.strptime(sd, "%Y-%m-%d")

            # TODO consider business days
            if sd < (min_date + datetime.timedelta(days=n_days)):
                self.tl_data["label_shift_text"][0][0].set("Please correct dates.")
                self.tl_data["label_shift_text"][1][0].set("Start date is too early.")
                return

            # if sd < datetime.datetime(self.today.year, self.today.month, self.today.day):
            if sd < min_date:
                self.tl_data["label_shift_text"][0][0].set("Please correct dates.")
                self.tl_data["label_shift_text"][1][0].set("Start date is too early.")
                return

            if not ed_disabled:
                if isinstance(ed, str):
                    ed = datetime.datetime.strptime(ed, "%Y-%m-%d")

                if ed <= sd:
                    self.tl_data["label_shift_text"][0][0].set("")
                    self.tl_data["label_shift_text"][1][0].set("Please correct dates.")
                    return

                if ed > (max_date - datetime.timedelta(days=n_days)):
                    self.tl_data["label_shift_text"][0][0].set("")
                    self.tl_data["label_shift_text"][1][0].set("Please correct dates.")
                    return

            msg1 = "Shift "
            if line:
                msg1 += f"{line}"
            else:
                msg1 += f"____"
            msg1 += " line"
            msg1 += "s " if line == "All" else " "

            if n_days:
                msg1 += f"{n_days}"
            else:
                msg1 += f"____"
                n_days = 0

            msg1 += f" day{'s' if n_days != 1 else ''} forward"
            msg2 = "Between " if not ed_disabled else "Starting "
            if sd:
                msg2 += f"{sd:%Y-%m-%d}"
            else:
                msg2 += "____"
            if not ed_disabled:
                msg2 += " and "
                if ed:
                    msg2 += f"{ed:%Y-%m-%d}"
                else:
                    msg2 += "____"

            all_set = all(map(bool, [line, n_days, sd, (ed or ed_disabled)]))

            self.tl_data["label_shift_text"][0][0].set(msg1)
            self.tl_data["label_shift_text"][1][0].set(msg2)

            if all_set:
                update_quotes_affected()

        def update_combobox_lines(*args):
            line = self.tl_data["combobox_lines"][2].get()
            if line:
                update_shift_text()

        def update_slider_n_days(*args):
            n_days = self.tl_data["var_slider_n_days"].get()
            if n_days:
                update_shift_text()

        def update_frame_sd(*args):
            sd = self.tl_data["frame_sd"].var_date_entry.get()
            if sd:
                update_shift_text()

        def update_frame_ed(*args):
            ed = self.tl_data["frame_ed"].var_date_entry.get()
            if ed:
                update_shift_text()

        def click_cancel(*args):
            print(f"click_cancel")
            on_closing_shift_lines()

        def click_submit(*args):
            print(f"click_submit")

            if comp == COMPANY.BWS.value:
                messagebox.showinfo(
                    title=self.title_application_short + f" - Shift Line",
                    message=self.msg_feature_coming_soon
                )
                return

            data = self.tl_data["table_change_preview"].get()[1:]
            p_line = self.tl_data["combobox_lines"][2].get()
            # n_days = self.tl_data["var_slider_n_days"].get()
            # sd = self.tl_data["frame_sd"].var_date_entry.get()
            # ed = self.tl_data["frame_ed"].var_date_entry.get()
            # direction = "forward"
            #
            # if isinstance(sd, str):
            #     sd = datetime.datetime.strptime(sd, "%Y-%m-%d")
            #
            # ed_disabled = self.tl_data["var_end_date_disabled"].get()
            #
            # min_date_stg, max_date_stg = self.list_dates[0], self.list_dates[-1]

            if len(data) > 1:

                # if ed_disabled:
                #     ed = max_date_stg
                #
                # if isinstance(ed, str):
                #     ed = datetime.datetime.strptime(ed, "%Y-%m-%d")

                sql_statements = f""
                for row in data:

                    if p_line == "All":
                        quote, line_, curr_date_s, new_date_s = row
                    else:
                        quote, curr_date_s, new_date_s = row
                        line_ = p_line

                    sql_statements += f"/* Shifting quote '{quote}' */"

                    # sql_statement = f"UPDATE "

                    now = datetime.datetime.now()
                    date = f"{now:%Y-%m-%d %H:%M:%S}"
                    user = self.app_state["user_name"]
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

                    dat_1 = {
                        "KD": new_date_s,  # [Available Date]
                        "KL": line_,  # [JobAvailableLine]
                        "KS": date,  # [JobAvailableScheduled]
                        "KB": user,  # [JobAvailableScheduledBy]
                        "KQ": quote  # [SGQuote]
                    }
                    sql_statements += f"\n/* {rt1} */\n{sql_swap_1.format(**dat_1)}"

                    dat_2 = {
                        "KJ": line_,  # [JobStartLine]
                        "KK": new_date_s,  # [JobFinishDate]
                        "KQ": quote  # [SGQuote]
                    }
                    sql_statements += f"\n/* {rt2} */\n{sql_swap_2.format(**dat_2)}"

                print(f"{sql_statements=}")
                try:
                    connect(sql_statements, do_show=True, do_exec=False, do_print=True)
                except:
                    messagebox.showerror(
                        title=self.title_application_short,
                        message=self.msg_save_unsuccessful,
                        parent=self.tl_data[tl_name]
                    )
                else:
                    if sql_statements:
                        messagebox.showinfo(
                            title=self.title_application_short,
                            message=self.msg_save_successful,
                            parent=self.tl_data[tl_name]
                        )

                on_closing_shift_lines()
            else:
                self.tl_data["label_shift_text"][0][0].set("Please choose different inputs.")
                self.tl_data["label_shift_text"][1][0].set("No quotes were found in your specified range.")
                self.tl_data["btn_submit"][1].configure(state="disabled")
                return
                # messagebox.showerror(
                #     title=self.title_application_short,
                #     message=self.
                # )

        def click_disable_end_date(*args):
            disabled = self.tl_data["var_end_date_disabled"].get()
            widgets = [
                self.tl_data["frame_ed"].entry,
                self.tl_data["frame_ed"].date_picker,
                self.tl_data["frame_ed"].btn_dropdown
            ]
            if disabled:
                self.tl_data["btn_disable_end_date"][0].set("Disable 'End Date'")
                state = "normal"
            else:
                self.tl_data["btn_disable_end_date"][0].set("Enable 'End Date'")
                state = "disabled"

            for wid in widgets:
                wid.configure(state=state)
            self.tl_data["var_end_date_disabled"].set(not disabled)
            update_shift_text()

        def on_closing_shift_lines(*args):
            self.tl_data[tl_name].destroy()
            self.grab_set()

        tl_geom = customtkinter_utility.calc_geometry_tl(w, h, largest=True, rtype=dict, parent=self)
        self.tl_data[tl_name].geometry(tl_geom["geometry"])

        # line
        # sd
        # ed
        # n days

        self.tl_data["tl_frame_days"] = ctk.CTkFrame(
            self.tl_data[tl_name],
            width=w - (wm / 2),
            height=300,
            bg_color=bg_sl_main.hex_code
        )
        # self.tl_data["tl_frame_days"].rowconfigure(0, weight=10)
        # self.tl_data["tl_frame_days"].rowconfigure(1, weight=90)
        self.tl_data["tl_frame_days_sd"] = ctk.CTkScrollableFrame(
            self.tl_data["tl_frame_days"],
            width=400,
            height=300
        )
        self.tl_data["tl_frame_days_ed"] = ctk.CTkScrollableFrame(
            self.tl_data["tl_frame_days"],
            width=400,
            height=300
        )
        # self.tl_data["tl_frame_days_sd"].grid_propagate(False)
        # self.tl_data["tl_frame_days_ed"].grid_propagate(False)

        self.tl_data["label_sd"] = customtkinter_utility.label_factory(
            self.tl_data["tl_frame_days_sd"],
            tv_label="Start Date:"
        )
        self.tl_data["frame_sd"] = customtkinter_utility.CtkEntryDate(
            self.tl_data["tl_frame_days_sd"]
        )
        self.tl_data["label_ed"] = customtkinter_utility.label_factory(
            self.tl_data["tl_frame_days_ed"],
            tv_label="End Date:"
        )
        self.tl_data["var_end_date_disabled"] = ctk.BooleanVar(self.tl_data[tl_name], value=False)
        self.tl_data["btn_disable_end_date"] = customtkinter_utility.button_factory(
            self.tl_data["tl_frame_days_ed"],
            tv_btn="Disable 'End Date'",
            command=click_disable_end_date
        )
        self.tl_data["frame_ed"] = customtkinter_utility.CtkEntryDate(
            self.tl_data["tl_frame_days_ed"]
        )
        # ed = f"{datetime.datetime.now() + datetime.timedelta(days=7):%Y-%m-%d}"
        # self.tl_data["frame_ed"].date_picker.selection_set(self.tl_data["frame_ed"].date_picker.format_date(ed))
        ed = datetime.datetime.now() + datetime.timedelta(days=7)
        self.tl_data["frame_ed"].date_picker.selection_set(ed)
        # self.tl_data["frame_ed"].var_date_picker.set(self.tl_data["frame_ed"].date_picker.format_date(ed))
        # self.tl_data["frame_ed"].var_date_picker.set(self.tl_data["frame_ed"].date_picker.format_date(ed))

        weight_tl = 35, 65
        self.tl_data["tl_frame_left"] = ctk.CTkFrame(
            self.tl_data[tl_name],
            # bg_color="#12FF32",
            width=self.total_width * (weight_tl[0] / 100),
            height=600
        )
        self.tl_data["tl_frame_right"] = ctk.CTkFrame(
            self.tl_data[tl_name],
            # bg_color="#FF1232",
            width=self.total_width * (weight_tl[1] / 100),
            height=600
        )
        self.tl_data["tl_frame_left_scrollable"] = ctk.CTkScrollableFrame(
            self.tl_data["tl_frame_left"],
            width=550
        )
        # self.tl_data["tl_frame_middle_widgets"] = ctk.CTkFrame(
        #     self.tl_data["tl_frame_left"]
        #     # , bg_color="#127833"
        # )
        # self.tl_data["tl_frame_middle_widgets"].columnconfigure(0, weight=20)
        # self.tl_data["tl_frame_middle_widgets"].columnconfigure(1, weight=80)
        # self.tl_data["tl_frame_middle_widgets"].rowconfigure(0, weight=30)
        self.tl_data["tl_frame_right_widgets"] = ctk.CTkFrame(
            self.tl_data["tl_frame_days"]
            # , bg_color="#781233"
        )

        self.tl_data["combobox_lines"] = customtkinter_utility.combo_factory(
            self.tl_data["tl_frame_right_widgets"],
            tv_label="Line:",
            values=["All"] + prod_lines
        )

        self.tl_data["var_slider_n_days"] = ctk.IntVar(self, value=1)
        # self.tl_data["slider_n_days"] = ttk.Scale(
        #     self.tl_data[tl_name],
        #     from_=1,
        #     to=7,
        #     orient="horizontal",
        #     variable=self.tl_data["var_slider_n_days"]
        # )
        self.tl_data["label_slider_n_days"] = customtkinter_utility.label_factory(
            self.tl_data["tl_frame_right_widgets"],
            tv_label=f"# Days:"
        )
        self.tl_data["label_val_slider_n_days"] = customtkinter_utility.label_factory(
            self.tl_data["tl_frame_right_widgets"],
            tv_label=self.tl_data["var_slider_n_days"]
        )
        self.tl_data["slider_n_days"] = ctk.CTkSlider(
            self.tl_data["tl_frame_right_widgets"],
            from_=1,
            to=7,
            orientation="horizontal",
            variable=self.tl_data["var_slider_n_days"]
        )

        self.tl_data["tl_frame_btns"] = ctk.CTkFrame(
            self.tl_data["tl_frame_right_widgets"]
            # ,
            # bg_color="#986614"
        )
        self.tl_data["btn_cancel"] = customtkinter_utility.button_factory(
            self.tl_data["tl_frame_btns"],
            tv_btn="cancel",
            command=click_cancel
        )
        self.tl_data["btn_submit"] = customtkinter_utility.button_factory(
            self.tl_data["tl_frame_btns"],
            tv_btn="submit",
            command=click_submit
        )
        self.tl_data["btn_submit"][1].configure(state="disabled")

        self.tl_data["label_shift_text"] = [
            customtkinter_utility.label_factory(
                self.tl_data["tl_frame_right_widgets"],
                tv_label="",
                kwargs_label={"font": ("Calibri", 20)}
            ),
            customtkinter_utility.label_factory(
                self.tl_data["tl_frame_right_widgets"],
                tv_label="",
                kwargs_label={"font": ("Calibri", 20)}
            )
        ]

        # random_table = [[random.randint(-5, 15) for j in range(3)] for j in range(13)]
        scan_p_w, scan_p_h = 1000, 500
        self.tl_data["tl_sl_can_p_w"], self.tl_data["tl_sl_can_p_h"] = 5000, 500
        # self.tl_data["tl_frame_preview"] = ctk.CTkScrollableFrame(
        #     self.tl_data["tl_frame_left"],
        #     # bg_color="#123378",
        #     width=self.total_width,
        #     height=400
        # )

        self.tl_data["tl_scroll_canvas"] = ctk.CTkScrollableFrame(
            self.tl_data["tl_frame_right"],
            width=scan_p_w,
            height=scan_p_h,
            orientation="horizontal"
        )

        self.tl_data["tl_canvas_preview"] = ctk.CTkCanvas(
            self.tl_data["tl_scroll_canvas"],
            width=self.tl_data["tl_sl_can_p_w"],
            height=self.tl_data["tl_sl_can_p_h"]
        )
        self.tl_data["tl_canvas_lbl_no_data"] = self.tl_data["tl_canvas_preview"].create_text(
            self.tl_data["tl_sl_can_p_w"] / 2,
            self.tl_data["tl_sl_can_p_h"] / 2,
            text="No Data",
            font=("Calibri", 16)
        )

        # self.tl_data["tl_frame_preview"].columnconfigure(0, weight=50)
        # self.tl_data["tl_frame_preview"].columnconfigure(1, weight=50)
        self.tl_data["label_change_preview"] = customtkinter_utility.label_factory(
            self.tl_data["tl_frame_right"],
            tv_label="Quotes Affected:",
            kwargs_label={
                "font": ("Calibri", 20)
            }
        )
        self.tl_data["table_change_preview"] = CTkTable.CTkTable(
            self.tl_data["tl_frame_left_scrollable"],
            values=[self.list_sl_preview_table_cols, ["", "No Data", ""]],
            header_color=self.colour_tl_sl_preview_header.hex_code,
            hover=True
        )
        self.tl_data["label_count_preview"] = customtkinter_utility.label_factory(
            self.tl_data["tl_frame_left"],
            tv_label="0 Quotes(s)",
            kwargs_label={
                "font": ("Calibri", 20)
            }
        )

        # self.tl_data["tl_frame_warning"] = ctk.CTkFrame(self.tl_data["tl_frame_left"])
        self.tl_data["tl_textbox_warning"] = ctk.CTkTextbox(
            self.tl_data["tl_frame_left"],
            width=500,
            font=("Calibri", 18),
            wrap="word"
        )
        self.tl_data["tl_textbox_warning"].configure(state="disabled")

        self.tl_data["combobox_lines"][2].trace_variable("w", update_combobox_lines)
        self.tl_data["var_slider_n_days"].trace_variable("w", update_slider_n_days)
        self.tl_data["frame_sd"].var_date_entry.trace_variable("w", update_frame_sd)
        self.tl_data["frame_ed"].var_date_entry.trace_variable("w", update_frame_ed)

        self.tl_data["tl_frame_days"].columnconfigure(0, weight=33)
        self.tl_data["tl_frame_days"].columnconfigure(1, weight=33)
        self.tl_data["tl_frame_days"].columnconfigure(2, weight=33)
        self.tl_data["tl_frame_days"].grid_propagate(False)
        self.tl_data["tl_frame_left"].grid_propagate(False)
        self.tl_data["tl_frame_right"].grid_propagate(False)
        self.tl_data[tl_name].columnconfigure(0, weight=weight_tl[0])
        self.tl_data[tl_name].columnconfigure(1, weight=weight_tl[1])

        # tl_name
        self.tl_data["tl_frame_days"].grid(row=0, column=0, columnspan=2)
        self.tl_data["tl_frame_left"].grid(row=1, column=0, rowspan=1)
        self.tl_data["tl_frame_right"].grid(row=1, column=1, rowspan=1)

        # tl_frame_days
        self.tl_data["tl_frame_days_sd"].grid(row=0, column=0, rowspan=1, columnspan=1, padx=5, pady=5)
        self.tl_data["tl_frame_days_ed"].grid(row=0, column=1, rowspan=1, columnspan=1, padx=5, pady=5)
        self.tl_data["tl_frame_right_widgets"].grid(row=0, column=2, rowspan=1, columnspan=1, padx=5, pady=5)

        # tl_frame_left
        self.tl_data["tl_textbox_warning"].grid(padx=20, pady=10)
        self.tl_data["tl_frame_left_scrollable"].grid(row=1, column=0, padx=20, pady=5)
        self.tl_data["label_count_preview"][1].grid(row=2, column=0, padx=20, ipadx=20, pady=5, sticky=ctk.E)

        # self.tl_data["tl_frame_warning"].grid(row=0, column=0, columnspan=1, padx=20, pady=5)
        # self.tl_data["tl_frame_middle_widgets"].grid(row=1, column=0, columnspan=1)

        # tl_frame_left_scrollable
        self.tl_data["table_change_preview"].grid(row=0, column=1, rowspan=1, columnspan=1)

        # tl_frame_right
        self.tl_data["label_change_preview"][1].grid(row=0, column=0, rowspan=1, columnspan=2)
        self.tl_data["tl_scroll_canvas"].grid(row=1, column=1, rowspan=1)
        # self.tl_data["tl_frame_preview"].grid(row=0, column=0, sticky=ctk.EW)

        # tl_scroll_canvas
        self.tl_data["tl_canvas_preview"].grid(row=0, column=0, rowspan=1, sticky=ctk.NSEW)

        # tl_frame_days_sd
        self.tl_data["label_sd"][1].grid(row=0, column=0, rowspan=1, columnspan=1, padx=10, pady=10)
        self.tl_data["frame_sd"].grid(row=1, column=0, rowspan=1, columnspan=1, padx=10, pady=10)

        # tl_frame_days_ed
        self.tl_data["label_ed"][1].grid(row=0, column=1, rowspan=1, columnspan=1, padx=10, pady=10)
        self.tl_data["btn_disable_end_date"][1].grid(row=0, column=2, rowspan=1, columnspan=1, padx=10, pady=10)
        self.tl_data["frame_ed"].grid(row=1, column=1, rowspan=1, columnspan=2, padx=10, pady=10)

        # tl_frame_middle_widgets

        # tl_frame_right_widgets
        self.tl_data["combobox_lines"][1].grid(row=0, column=0, columnspan=1)
        self.tl_data["combobox_lines"][3].grid(row=0, column=1, padx=8, columnspan=2)
        self.tl_data["label_slider_n_days"][1].grid(row=1, column=0, padx=8)
        self.tl_data["label_val_slider_n_days"][1].grid(row=1, column=1, padx=8)
        self.tl_data["slider_n_days"].grid(row=1, column=2, padx=8)
        self.tl_data["tl_frame_btns"].grid(row=2, column=0, padx=8, columnspan=3)
        self.tl_data["label_shift_text"][0][1].grid(row=3, column=0, columnspan=3, padx=8, pady=9)
        self.tl_data["label_shift_text"][1][1].grid(row=4, column=0, columnspan=3, padx=8, pady=9)

        # tl_frame_btns
        self.tl_data["btn_cancel"][1].grid(row=0, column=0, rowspan=1, columnspan=1, padx=10, pady=10)
        self.tl_data["btn_submit"][1].grid(row=0, column=1, rowspan=1, columnspan=1, padx=10, pady=10)

        # tl_frame_preview

        # tl_frame_warning

        self.tl_data[tl_name].protocol("WM_DELETE_WINDOW", on_closing_shift_lines)
        self.tl_data[tl_name].grab_set()
        self.wait_window(self.tl_data[tl_name])

    def click_mb_colour_code(self, event=None):
        tm = self.settings["TEST_MODE"].get()


        comp = self.settings["mode_company"]
        # can = self.canvas_bws if (comp == COMPANY.BWS.value) else self.canvas_stg
        # tiles = self.tiles_bws if (comp == COMPANY.BWS.value) else self.tiles_stg
        # lines = self.list_prod_lines_bws if (comp == COMPANY.BWS.value) else self.list_prod_lines_stg
        # warranty_lines = self.list_warranty_lines_bws if (comp == COMPANY.BWS.value) else self.list_warranty_lines_stg
        # df_warranties = self.df_multi_combobox_data_warranties_bws if (
        #             comp == COMPANY.BWS.value) else self.df_multi_combobox_data_orders_stg
        df_orders = self.df_orders_bws if (comp == COMPANY.BWS.value) else self.df_orders_stg
        # combobox_warranties = self.multi_combobox_warranties_bws if (
        #             comp == COMPANY.BWS.value) else self.multi_combobox_warranties_stg
        # combobox_orders = self.multi_combobox_orders_bws if (
        #             comp == COMPANY.BWS.value) else self.multi_combobox_orders_stg
        # info_frame = self.info_frame_bws if (comp == COMPANY.BWS.value) else self.info_frame_stg

        # open colour code TopLevel.
        known_dealers = sorted([d for d in df_orders[self.quote_key("dealer")].unique().tolist() if len(str(d))])
        known_models = sorted([m for m in df_orders[self.quote_key("Model No")].unique().tolist() if len(str(m))])
        known_dealers.sort()
        known_colour_codes = self.settings.get("colour_coding", {})
        known_colour_codes_d = known_colour_codes.get("dealers", {})
        known_colour_codes_m = known_colour_codes.get("models", {})
        n_dealers = len(known_dealers)
        n_models = len(known_models)
        if tm:
            print(f"{known_colour_codes=}")
            print(f"{known_colour_codes_d=}")
            print(f"{known_colour_codes_m=}")
            print(f"{known_dealers=}, {known_colour_codes=}")
            print(f"{known_colour_codes_d=}, {known_colour_codes_m=}")
        self.tl_data["tl_colour_code"] = ctk.CTkToplevel(self)
        self.tl_data["tl_colour_code"].title(self.title_application_short + " - Colour Code")

        self.tl_data["cc_changed"] = ctk.BooleanVar(self, value=False)

        n_cols = 3
        # n_btns_per_row = 25
        # n_cols = (max(n_dealers, n_models) // n_btns_per_row) + 1
        n_btns_per_row = round(max(n_dealers, n_models) / n_cols) + 2
        tw, th, m = 325, 60, 15
        total_width_dealers = n_cols * (tw + m)
        # total_height_dealers = 600
        total_height_dealers = n_btns_per_row * (th + m)
        # total_width_dealers, total_height_dealers = (n_cols * (tw + m))

        # w, h = 1400, 800
        # w, h = total_width_dealers + 500, 800
        w, h = 1.0, 1.0
        tl_geom = customtkinter_utility.calc_geometry_tl(w, h, largest=True, rtype=dict, parent=self)
        self.tl_data["tl_colour_code"].geometry(tl_geom["geometry"])

        bg_cc_main = Colour("#459001")
        bg_cc_vc = Colour("#051001")
        bg_cc_btn = Colour("#E0E0FF")
        fg_cc_btn = Colour("#051001")
        bg_cc_btn_hover = bg_cc_btn.brightened(0.25)
        fg_cc_btn_hover = fg_cc_btn.brightened(0.25)
        colour_bg_top_button = Colour("#52C5F2")
        colour_fg_top_button = Colour("#022562")
        colour_outline_top_button = Colour("#000000")

        if tm:
            print(
                f"{n_models=}, {n_dealers=}, rows={n_btns_per_row}, cols={n_cols}, width={total_width_dealers}, height={total_height_dealers}")

        grid_cells = utility.grid_cells(
            total_width_dealers,
            n_cols,
            total_height_dealers,
            n_btns_per_row,
            x_pad=m,
            y_pad=m,
            r_type=list
        )

        pri0 = self.tl_tv_colour_code_priority.get().title()
        pri1 = "Dealer" if pri0 == "Model" else "Model"
        cc_tp = self.tl_tv_colour_code_only_priority.get()
        self.tl_data["tl_cc_cc_pri_lbl0"] = customtkinter_utility.label_factory(
            self.tl_data["tl_colour_code"],
            tv_label="Colour-Coding Priority:"
        )
        self.tl_data["tl_cc_cc_pri_lbl1"] = customtkinter_utility.label_factory(
            self.tl_data["tl_colour_code"],
            tv_label=f"{pri0}" if cc_tp else f"{pri0}, {pri1}",
            kwargs_label={
                "text_color": "#ABABAB"
            }
        )

        self.tl_data["tl_cc_tv_dm_option"] = ctk.StringVar(
            self.tl_data["tl_colour_code"],
            value="Dealers"
        )
        self.tl_data["tl_cc_dm_option"] = ctk.CTkSegmentedButton(
            self.tl_data["tl_colour_code"],
            values=["Dealers", "Models"],
            variable=self.tl_data["tl_cc_tv_dm_option"]
        )

        self.tl_data["tl_cc_scroll_canvas"] = ctk.CTkScrollableFrame(
            self.tl_data["tl_colour_code"],
            width=total_width_dealers + (2 * m),
            height=750
            # ,
            # height=total_height_dealers + (2 * m)
        )

        self.tl_data["tl_canvas"] = ctk.CTkCanvas(
            self.tl_data["tl_cc_scroll_canvas"],
            width=total_width_dealers + (2 * m),
            height=total_height_dealers + (2 * m),
            bg=bg_cc_main.hex_code
        )
        self.tl_data["tl_frame"] = ctk.CTkFrame(
            self.tl_data["tl_colour_code"],
            width=total_width_dealers + (2 * m),
            height=total_height_dealers + (2 * m)
            # ,
            # fg_color=bg_cc_main.darkened(0.25).hex_code
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
            tl_geom_cc = customtkinter_utility.calc_geometry_tl(
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
            f1_tup, f1_obj = self.tl_data['tl_font_select_frame'].font
            print(f"{f1_tup=}, {f1_obj=}")
            font = ctk.CTkFont(*f1_tup)
            # if tm:
            print(f"CHOSEN {font=}")
            # ctk_font = ctk.CTkFont(font)
            # print(f"CHOSEN {ctk_font=}")
            if font:
                # font_name_font_size, font_obj = font
                # if font_name_font_size is None:
                #     font_name_font_size = self.default_font
                # font_name, font_size, *rest = font_name_font_size
                font_name = font.cget("family")
                font_size = font.cget("size")
                print(f"-1 {font_size=}")
                # font_size_ = max(self.settings["min_font_size_tile"],
                #                  min(font_size, self.settings["max_font_size_tile"]))
                font_size_ = clamp(self.settings["min_font_size_tile"], font_size, self.settings["max_font_size_tile"])
                font.configure(size=font_size_)
                # if tm:
                print(f"1 {font_name=}\n{font_size_=}\n{font=}")
                print(f"{font.cget('family')=}")
                print(f"{font.cget('size')=}")
                # if font_size != font_size_:
                #     font_obj = (font_name, font_size_)
                # if tm:
                #     print(f"2 {font_size=}, {font_size_=}, {font_obj=}")
                self.tl_data["tl_cc_view_canvas"].itemconfigure(
                    self.tl_data["tl_cc_vc_edit_text"],
                    font=font
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
            # font = ctk.CTkFont(self.tl_data["tl_font_select_frame"].font)
            # if tm:
            #     print(f"CHOSEN {font=}")
            #     # ctk_font = ctk.CTkFont(font)
            #     # print(f"CHOSEN {ctk_font=}")
            # if font:
            #     # font_name_font_size, font_obj = font
            #     font_name = font.cget("family")
            #     font_size = font.cget("size")
            #     # if font_name_font_size is None:
            #     #     font_name_font_size = self.default_font
            #     # print(f"{font_name_font_size=}")
            #     # font_name, font_size, *rest = font_name_font_size
            #     # font_size_ = max(self.settings["min_font_size_tile"],
            #     #                  min(font_size, self.settings["max_font_size_tile"]))
            #     print(f"-1 {font_size=}")
            #     font_size_ = clamp(self.settings["min_font_size_tile"], font_size, self.settings["max_font_size_tile"])
            #     font.configure(size=font_size_)
            #     if tm:
            #         print(f"1 {font_name=}, {font_size_=}, {font=}")
            #     # if font_size != font_size_:
            #     #     font_obj = (font_name, font_size_)
            #     # if tm:
            #     #     print(f"2 {font_size=}, {font_size_=}, {font_obj=}")
            #     # self.tl_data["tl_font_label_choice"][1].configure(font=font)

        def clear_vc_edit_tile():
            self.tl_data["tl_cc_view_canvas"].itemconfigure(
                self.tl_data["tl_cc_vc_edit_tile"],
                state="hidden"
            )
            self.tl_data["tl_cc_view_canvas"].itemconfigure(
                self.tl_data["tl_cc_vc_edit_text"],
                text=f""
            )
            for key, parent, text, command in btn_data:
                if key != "tl_cc_btn_go_back":
                    self.tl_data[key][1].configure(state=ctk.DISABLED)
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
            self.tl_data["tl_font_choice"] = ctk.CTkToplevel(self.tl_data["tl_colour_code"])
            self.tl_data["tl_font_choice"].title(self.title_application_short + " - Font")
            # self.tl_data["tl_font_choice"] = tkinter.Toplevel(self.tl_data["tl_colour_code"])
            tl_geom_fc = customtkinter_utility.calc_geometry_tl(
                500, 200, parent=self, rtype=dict
            )
            self.tl_data["tl_font_choice"].geometry(tl_geom_fc["geometry"])
            # self.tl_data["tl_font_label_choice"] = customtkinter_utility.label_factory(
            #     self.tl_data["tl_font_choice"],
            #     tv_label=f"Sample Text",
            #     kwargs_label={
            #         "text_color": "#000000"
            #     }
            # )
            # self.tl_data["tl_font_select_frame"] = FontSelectFrame(
            #     master=self.tl_data["tl_font_choice"],
            #     callback=update_font_choice
            # )
            self.tl_data["tl_font_select_frame"] = customtkinter_utility.FontSelectFrame(
                master=self.tl_data["tl_font_choice"],
                callback=update_font_choice
            )
            self.tl_data["tl_font_select_frame"].set_min_size(self.settings["min_font_size_tile"])
            self.tl_data["tl_font_select_frame"].set_max_size(self.settings["max_font_size_tile"])

            self.tl_data["tl_fc_btn_cancel"] = customtkinter_utility.button_factory(
                self.tl_data["tl_font_choice"],
                tv_btn=f"Cancel",
                command=click_font_cancel,
                kwargs_btn={
                    "bg_color": bg_cc_btn.hex_code,
                    "fg_color": fg_cc_btn.hex_code
                    # ,
                    # "activebackground": bg_cc_btn_hover.hex_code,
                    # "activeforeground": fg_cc_btn_hover.hex_code,
                }
            )
            self.tl_data["tl_fc_btn_save"] = customtkinter_utility.button_factory(
                self.tl_data["tl_font_choice"],
                tv_btn=f"Save",
                command=click_font_save,
                kwargs_btn={
                    "bg_color": bg_cc_btn.hex_code,
                    "fg_color": fg_cc_btn.hex_code
                    # ,
                    # "activebackground": bg_cc_btn_hover.hex_code,
                    # "activeforeground": fg_cc_btn_hover.hex_code,
                }
            )

            # self.tl_data["tl_font_label_choice"][1].grid(row=0, column=0, columnspan=2, rowspan=1, padx=5, pady=5)
            self.tl_data["tl_font_select_frame"].grid(row=0, column=0, columnspan=2, rowspan=1, sticky="snew", padx=5,
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

        def click_top_btn(event):
            # self.tl_data["tl_cc_scroll_canvas"].canvas_stg.yview_moveto(0)
            self.tl_data["tl_cc_scroll_canvas"]._parent_canvas.yview_moveto(0)

        def click_dealer_tile(event, dealer_idx, dealer_model: str = "dealer"):
            clear_vc_edit_tile()

            visible = self.tl_data["tl_cc_view_canvas"].itemcget(
                self.tl_data["tl_cc_vc_edit_tile"],
                "state"
            )
            if visible != ctk.NORMAL:
                self.tl_data["tl_cc_view_canvas"].itemconfigure(
                    self.tl_data["tl_cc_vc_edit_tile"],
                    state=ctk.NORMAL
                )
                self.tl_data["tl_cc_frame_btn_bar"].grid(row=3, column=0, columnspan=2, rowspan=1)

                for key, parent, text, command in btn_data:
                    if key != "tl_cc_btn_go_back":
                        self.tl_data[key][1].configure(state=ctk.NORMAL)

            if tm:
                print(f"click_dealer_tile", end="")
            can_opts = self.tl_data["tl_canvas"]
            can_vc = self.tl_data["tl_cc_view_canvas"]
            if dealer_model == "model":
                dealer = known_models[dealer_idx]
                tag = opt_tags_models[dealer_idx]["tile"]
                t_tag = opt_tags_models[dealer_idx]["text"]
            else:
                dealer = known_dealers[dealer_idx]
                tag = opt_tags_dealers[dealer_idx]["tile"]
                t_tag = opt_tags_dealers[dealer_idx]["text"]
            if tm:
                print(f" {dealer=}")
            bbox_vc = self.tl_data["tl_colour_code"].bbox(can_opts)
            if tm:
                print(f"{bbox_vc=}")

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
            cc = self.settings.get("colour_coding", {})
            cc.update(known_colour_codes)
            self.settings["colour_coding"] = cc
            if tm:
                print(f"{self.settings['colour_coding']=}")
            self.save_colour_coding()
            messagebox.showinfo(
                title=self.title_application_short,
                message=f"Changes applied successfully.",
                parent=self.tl_data["tl_colour_code"]
            )

        def click_cancel(event=None):
            clear_vc_edit_tile()

        def click_default(event=None):
            if tm:
                print(f"click_default")
            dm = self.tl_data["tl_cc_tv_dm_option"].get().lower().removesuffix("s")
            can_opts = self.tl_data["tl_canvas"]
            can_vc = self.tl_data["tl_cc_view_canvas"]
            cv_tag = self.tl_data["tl_cc_vc_edit_tile"]
            cv_t_tag = self.tl_data["tl_cc_vc_edit_text"]
            dealer = can_vc.itemcget(cv_t_tag, "text")

            if dealer.strip():
                dealer_idx, model_idx = None, None
                if dm == "model":
                    model_idx = known_models.index(dealer)
                    tag = opt_tags_models[model_idx]["tile"]
                    t_tag = opt_tags_models[model_idx]["text"]
                else:
                    dealer_idx = known_dealers.index(dealer)
                    tag = opt_tags_dealers[dealer_idx]["tile"]
                    t_tag = opt_tags_dealers[dealer_idx]["text"]

                if tm:
                    print(f"{dealer_idx=}, {model_idx=}, {tag=}, {t_tag=}")

                bg = self.colour_tile_background.hex_code
                fg = self.colour_tile_foreground.hex_code
                bd = self.colour_tile_outline.hex_code
                ou = self.width_tile_outline
                ft = self.font_tile

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
            dm = self.tl_data["tl_cc_tv_dm_option"].get().lower().removesuffix("s")
            can_opts = self.tl_data["tl_canvas"]
            can_vc = self.tl_data["tl_cc_view_canvas"]

            cv_tag = self.tl_data["tl_cc_vc_edit_tile"]
            cv_t_tag = self.tl_data["tl_cc_vc_edit_text"]

            dealer = can_vc.itemcget(cv_t_tag, "text")
            if tm:
                print(f"{dealer=} ", end="")
            if dealer:
                dealer_idx, model_idx = None, None
                if dm == "model":
                    model_idx = known_models.index(dealer)
                    tag = opt_tags_models[model_idx]["tile"]
                    t_tag = opt_tags_models[model_idx]["text"]
                else:
                    dealer_idx = known_dealers.index(dealer)
                    tag = opt_tags_dealers[dealer_idx]["tile"]
                    t_tag = opt_tags_dealers[dealer_idx]["text"]

                if tm:
                    print(f"{dealer_idx=}, {model_idx=}, {tag=}, {t_tag=}")
                    # print(f"{can_opts.get_children()=}")

                bg = can_vc.itemcget(cv_tag, "fill")
                fg = can_vc.itemcget(cv_t_tag, "fill")
                bd = can_vc.itemcget(cv_tag, "outline")
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
                if dm not in known_colour_codes:
                    known_colour_codes[dm] = {}
                known_colour_codes[dm][dealer] = {
                    "bg": bg,
                    "fg": fg,
                    "outline": bd,
                    "width": ou,
                    "font": ft
                }
                if dm == "model":
                    known_colour_codes_m[dealer] = {
                        "bg": bg,
                        "fg": fg,
                        "outline": bd,
                        "width": ou,
                        "font": ft
                    }
                else:
                    known_colour_codes_d[dealer] = {
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
                    title=self.title_application_short,
                    message=f"Would you like to save your changes?",
                    parent=self.tl_data["tl_colour_code"]
                )
                if ans == ctk.YES:
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
                    title=self.title_application_short,
                    message=f"Save changes for '{dealer}'?",
                    parent=self.tl_data["tl_colour_code"]
                )
                if ans == ctk.YES:
                    click_save()
                changes = True

            if tm:
                print(f"\t{changes}")
            if changes:
                save_changes()
            else:
                messagebox.showinfo(
                    title=self.title_application_short,
                    message=f"No changes to apply.",
                    parent=self.tl_data["tl_colour_code"]
                )

        def click_go_back():
            if tm:
                print(f"click_go_back")
            changes = self.tl_data["cc_changed"].get()
            if tm:
                print(f"\t{changes}")
            if changes:
                ans = messagebox.askyesnocancel(
                    title=self.title_application_short,
                    message=f"Would you like to save your changes?",
                    parent=self.tl_data["tl_colour_code"]
                )
                if ans == ctk.YES:
                    # save changes
                    save_changes()
                else:
                    # quit without saving
                    pass
            quit_cc()

        def update_dealers_models_option(*args):
            value = self.tl_data["tl_cc_tv_dm_option"].get().lower().removesuffix("s")
            print(f"{value}")

            values = []
            if value == "model":
                values.append(("normal", opt_tags_models))
                values.append(("hidden", opt_tags_dealers))
            else:
                values.append(("normal", opt_tags_dealers))
                values.append(("hidden", opt_tags_models))

            for state, data in values:
                for i, tag_data in data.items():
                    tile = tag_data.get("tile")
                    text = tag_data.get("text", [])
                    self.tl_data["tl_canvas"].itemconfigure(
                        tile,
                        state=state
                    )
                    self.tl_data["tl_canvas"].itemconfigure(
                        text,
                        state=state
                    )

            click_top_btn(None)

        idx = 0
        opt_tags_dealers = {}
        opt_tags_models = {}
        opt_tags_app = {}
        t_template = ["tile", "text"]
        dm_ = self.tl_data["tl_cc_tv_dm_option"].get().lower().removesuffix("s")
        # dm_ = self.tl_tv_colour_code_priority.get().lower()
        for i, gc_row in enumerate(grid_cells):
            for j, gc in enumerate(gc_row):
                idx = ((i * len(gc_row)) + j)
                if tm:
                    print(f"{i=}, {gc=}")

                if len(opt_tags_models) < len(known_models):
                    model = known_models[idx]

                    k_model = known_colour_codes.get("model", {}).get(model, {})
                    k_bg = k_model.get("bg", self.colour_tile_background.hex_code)
                    k_fg = k_model.get("fg", self.colour_tile_foreground.hex_code)
                    k_bd = k_model.get("outline", self.colour_tile_outline.hex_code)
                    k_ou = k_model.get("width", self.width_tile_outline)
                    k_ft = k_model.get("font", self.font_tile)

                    tag = self.draw_rect(
                        gc,
                        fill=k_bg,
                        outline=k_bd,
                        width=k_ou,
                        parent=self.tl_data["tl_canvas"]
                    )
                    self.tl_data["tl_canvas"].itemconfigure(
                        tag,
                        state="hidden" if (dm_ == "dealer") else "normal"
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
                        text=f"{model}"
                    )
                    opt_tags_models[idx] = {}
                    opt_tags_models[idx]["tile"] = tag
                    opt_tags_models[idx]["text"] = t_tag
                    self.tl_data["tl_canvas"].tag_bind(
                        tag,
                        "<Button-1>",
                        lambda event_=None, d_idx=idx:
                        click_dealer_tile(event_, d_idx, dealer_model="model")
                    )
                    self.tl_data["tl_canvas"].tag_bind(
                        t_tag,
                        "<Button-1>",
                        lambda event_=None, d_idx=idx:
                        click_dealer_tile(event_, d_idx, dealer_model="model")
                    )
                    if tm:
                        print(f"{model=}, {idx=}, {tag=}, {t_tag=}")

                if len(opt_tags_dealers) < len(known_dealers):
                    dealer = known_dealers[idx]

                    k_dealer = known_colour_codes.get("dealer", {}).get(dealer, {})
                    print(f"{dm_=}, {dealer=}, {idx=}, {k_dealer=}")
                    k_bg = k_dealer.get("bg", self.colour_tile_background.hex_code)
                    k_fg = k_dealer.get("fg", self.colour_tile_foreground.hex_code)
                    k_bd = k_dealer.get("outline", self.colour_tile_outline.hex_code)
                    k_ou = k_dealer.get("width", self.width_tile_outline)
                    k_ft = k_dealer.get("font", self.font_tile)

                    tag = self.draw_rect(
                        gc,
                        fill=k_bg,
                        outline=k_bd,
                        width=k_ou,
                        parent=self.tl_data["tl_canvas"]
                    )
                    self.tl_data["tl_canvas"].itemconfigure(
                        tag,
                        state="hidden" if (dm_ == "model") else "normal"
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
                if (idx + 1) >= max(n_models, n_dealers):
                    break
            if (idx + 1) >= max(n_models, n_dealers):
                break

        self.tl_data["tl_cc_tag_top_btn_rect"] = self.draw_rect(
            grid_cells[-1][-1],
            fill=colour_bg_top_button.hex_code,
            outline=colour_outline_top_button.hex_code,
            parent=self.tl_data["tl_canvas"]
        )
        self.tl_data["tl_cc_tag_top_btn_text"] = self.tl_data["tl_canvas"].create_text(
            grid_cells[-1][-1][0] + ((grid_cells[-1][-1][2] - grid_cells[-1][-1][0]) / 2),
            grid_cells[-1][-1][1] + ((grid_cells[-1][-1][3] - grid_cells[-1][-1][1]) / 2),
            fill=colour_fg_top_button.hex_code,
            text="^",
            font=("Calibri", 24, "bold")
        )

        self.tl_data["tl_canvas"].tag_bind(
            self.tl_data["tl_cc_tag_top_btn_rect"],
            "<Button-1>",
            click_top_btn
        )

        self.tl_data["tl_canvas"].tag_bind(
            self.tl_data["tl_cc_tag_top_btn_text"],
            "<Button-1>",
            click_top_btn
        )

        w_pc = int(total_width_dealers * 0.6)
        h_pc = int(total_height_dealers * 0.1)

        self.tl_data["tl_cc_view_canvas"] = ctk.CTkCanvas(
            self.tl_data["tl_frame"],
            width=w_pc,
            height=h_pc,
            bg=bg_cc_main.hex_code
        )

        # x0_vc_et, y0_vc_et = 25, 25
        # w_vc_et, h_vc_et = 500, 60
        x0_vc_et, y0_vc_et = 25, 25
        w_vc_et, h_vc_et = w_pc - (2 * x0_vc_et), h_pc - (2 * y0_vc_et)
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
            "fg_color": bg_cc_btn.hex_code,
            "text_color": fg_cc_btn.hex_code,
            # "activebackground": bg_cc_btn_hover.hex_code,
            # "activeforeground": fg_cc_btn_hover.hex_code,
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

            ("tl_cc_btn_app", "tl_frame", "App Theme", self.click_app_theme)
        ]
        self.tl_data["tl_cc_frame_btn_bar"] = ctk.CTkFrame(
            self.tl_data["tl_frame"],
            fg_color=bg_cc_main.hex_code
        )

        for btn_key, parent_frame, btn_text, callback in btn_data:
            self.tl_data[btn_key] = customtkinter_utility.button_factory(
                self.tl_data[parent_frame],
                tv_btn=btn_text,
                command=callback,
                kwargs_btn={k: v for k, v in kwargs_btn.items()}
            )

        self.tl_data["tl_cc_tv_dm_option"].trace_variable("w", update_dealers_models_option)
        update_dealers_models_option()

        # self.tl_data["tl_colour_code"]
        self.tl_data["tl_colour_code"].columnconfigure(0, weight=15)
        self.tl_data["tl_colour_code"].columnconfigure(1, weight=15)
        self.tl_data["tl_colour_code"].columnconfigure(2, weight=35)
        self.tl_data["tl_colour_code"].columnconfigure(3, weight=35)
        self.tl_data["tl_cc_cc_pri_lbl0"][1].grid(row=0, column=0, rowspan=1, padx=20, pady=20, sticky=ctk.E)
        self.tl_data["tl_cc_cc_pri_lbl1"][1].grid(row=0, column=1, rowspan=1, padx=20, pady=20, sticky=ctk.W)
        self.tl_data["tl_cc_dm_option"].grid(row=0, column=2, rowspan=1, padx=20, pady=20)
        self.tl_data["tl_cc_scroll_canvas"].grid(row=1, column=0, rowspan=2, columnspan=3, sticky=ctk.NS)
        self.tl_data["tl_frame"].grid(row=0, column=3, rowspan=3, sticky=ctk.NS)

        # self.tl_data["tl_cc_scroll_canvas"]
        self.tl_data["tl_canvas"].grid(sticky=ctk.NS)

        # self.tl_data["tl_frame"]
        self.tl_data["tl_cc_view_canvas"].grid(row=0, column=0, columnspan=2, rowspan=1, pady=40)
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

    def click_app_theme(self, *args):
        print(f"click_app_theme / settings")
        self.tl_cc_app = ctk.CTkToplevel(self)
        self.tl_cc_app.title(self.title_application_short + " - Settings")
        self.tl_cc_app.geometry(customtkinter_utility.calc_geometry_tl(900, 750, parent=self))

        # Light and Dark Theme
        tl_cc_app_frame_light_dark_theme = ctk.CTkFrame(self.tl_cc_app)
        tv_lbl_ldt, lbl_ldt = customtkinter_utility.label_factory(
            tl_cc_app_frame_light_dark_theme,
            tv_label="Theme:",
            kwargs_label=self.kwargs_lbl
        )
        tl_at_switch_dark_mode = ctk.CTkSegmentedButton(
            tl_cc_app_frame_light_dark_theme,
            values=["Light", "Dark", "System"],
            variable=self.tl_tv_switch_dark,
            font=self.kwargs_lbl["font"]
        )
        tl_cc_app_frame_light_dark_theme.grid(**self.grid_args_frame)
        lbl_ldt.grid(row=0, column=0, **self.grid_args_label)
        tl_at_switch_dark_mode.grid(row=0, column=1, **self.grid_args_switch)

        # Ask Monitors
        tl_cc_app_frame_ask_monitors = ctk.CTkFrame(self.tl_cc_app)
        tv_lbl_am, lbl_am = customtkinter_utility.label_factory(
            tl_cc_app_frame_ask_monitors,
            tv_label="Ask Monitors on Start up:",
            kwargs_label=self.kwargs_lbl
        )
        tl_at_switch_ask_monitors = ctk.CTkSegmentedButton(
            tl_cc_app_frame_ask_monitors,
            values=["No", "Yes"],
            variable=self.tl_tv_switch_ask_monitors,
            font=self.kwargs_lbl["font"]
        )
        tl_cc_app_frame_ask_monitors.grid(**self.grid_args_frame)
        lbl_am.grid(row=0, column=0, **self.grid_args_label)
        tl_at_switch_ask_monitors.grid(row=0, column=1, **self.grid_args_switch)

        # Show left Widgets
        tl_cc_app_frame_show_left_widgets = ctk.CTkFrame(self.tl_cc_app)
        tv_lbl_slw, lbl_slw = customtkinter_utility.label_factory(
            tl_cc_app_frame_show_left_widgets,
            tv_label="Show Left Control Widgets:",
            kwargs_label=self.kwargs_lbl
        )
        tl_at_switch_show_left_widgets = ctk.CTkSegmentedButton(
            tl_cc_app_frame_show_left_widgets,
            values=["No", "Yes"],
            variable=self.tl_tv_switch_show_left_widgets,
            font=self.kwargs_lbl["font"]
        )
        tl_cc_app_frame_show_left_widgets.grid(**self.grid_args_frame)
        lbl_slw.grid(row=0, column=0, **self.grid_args_label)
        tl_at_switch_show_left_widgets.grid(row=0, column=1, **self.grid_args_switch)

        # Colour Theme
        tl_cc_app_frame_colour_theme = ctk.CTkFrame(self.tl_cc_app)
        tv_lbl_ct, lbl_ct = customtkinter_utility.label_factory(
            tl_cc_app_frame_colour_theme,
            tv_label="App Accent Colour:",
            kwargs_label=self.kwargs_lbl
        )
        tl_at_switch_colour_theme = ctk.CTkSegmentedButton(
            tl_cc_app_frame_colour_theme,
            values=["Blue", "Green", "Dark Blue"],
            variable=self.tl_tv_switch_colour,
            font=self.kwargs_lbl["font"]
        )
        tl_cc_app_frame_colour_theme.grid(**self.grid_args_frame)
        lbl_ct.grid(row=0, column=0, **self.grid_args_label)
        tl_at_switch_colour_theme.grid(row=0, column=1, **self.grid_args_switch)

        # Colour Coding Priority
        tl_cc_app_frame_colour_code_priority = ctk.CTkFrame(self.tl_cc_app)
        tv_lbl_ccp, lbl_ccp = customtkinter_utility.label_factory(
            tl_cc_app_frame_colour_code_priority,
            tv_label="Colour-Coding Priority:",
            kwargs_label=self.kwargs_lbl
        )
        tl_at_switch_colour_code_priority = ctk.CTkSegmentedButton(
            tl_cc_app_frame_colour_code_priority,
            values=["Dealer", "Model"],
            variable=self.tl_tv_colour_code_priority,
            font=self.kwargs_lbl["font"]
        )
        tl_cc_app_frame_colour_code_priority.grid(**self.grid_args_frame)
        lbl_ccp.grid(row=0, column=0, **self.grid_args_label)
        tl_at_switch_colour_code_priority.grid(row=0, column=1, **self.grid_args_switch)

        # Colour Coding Priority only switch
        tl_cc_app_frame_colour_code_only_priority = ctk.CTkFrame(self.tl_cc_app)
        tl_cc_lbl_colour_code_only_priority = customtkinter_utility.label_factory(
            tl_cc_app_frame_colour_code_only_priority,
            tv_label="Colour-code by top priority only:",
            kwargs_label=self.kwargs_lbl
        )
        tl_cc_checkbox_colour_code_only_priority = customtkinter_utility.checkbox_factory(
            tl_cc_app_frame_colour_code_only_priority,
            tv_label="",
            tv_checkbox=self.tl_tv_colour_code_only_priority
        )
        tl_cc_checkbox_colour_code_only_priority[2]._text_label.grid_forget()
        tl_cc_checkbox_colour_code_only_priority[2]._bg_canvas.grid_forget()
        tl_cc_checkbox_colour_code_only_priority[2]._canvas.grid_forget()
        tl_cc_checkbox_colour_code_only_priority[2].grid_columnconfigure(0, weight=100)
        tl_cc_checkbox_colour_code_only_priority[2].grid_columnconfigure(1, weight=0)
        tl_cc_checkbox_colour_code_only_priority[2].grid_columnconfigure(2, weight=0)
        tl_cc_checkbox_colour_code_only_priority[2]._bg_canvas.grid(row=0, column=0, columnspan=1, sticky=ctk.E)
        tl_cc_checkbox_colour_code_only_priority[2]._canvas.grid(row=0, column=0, columnspan=1, sticky=ctk.E)
        tl_cc_app_frame_colour_code_only_priority.grid(**self.grid_args_frame)
        tl_cc_lbl_colour_code_only_priority[1].grid(row=0, column=0, **self.grid_args_label)
        tl_cc_checkbox_colour_code_only_priority[2].grid(row=0, column=1, **self.grid_args_switch)

        # Show Galvanized
        tl_frame_show_galvanized = ctk.CTkFrame(self.tl_cc_app)
        tl_lbl_show_galvanized = customtkinter_utility.label_factory(
            tl_frame_show_galvanized,
            tv_label="Show Galvanized Flag:",
            kwargs_label=self.kwargs_lbl
        )
        tl_checkbox_show_galvanized = customtkinter_utility.checkbox_factory(
            tl_frame_show_galvanized,
            tv_label="",
            tv_checkbox=self.tl_tv_show_galvanized
        )
        tl_checkbox_show_galvanized[2]._text_label.grid_forget()
        tl_checkbox_show_galvanized[2]._bg_canvas.grid_forget()
        tl_checkbox_show_galvanized[2]._canvas.grid_forget()
        tl_checkbox_show_galvanized[2].grid_columnconfigure(0, weight=100)
        tl_checkbox_show_galvanized[2].grid_columnconfigure(1, weight=0)
        tl_checkbox_show_galvanized[2].grid_columnconfigure(2, weight=0)
        tl_checkbox_show_galvanized[2]._bg_canvas.grid(row=0, column=0, columnspan=1, sticky=ctk.E)
        tl_checkbox_show_galvanized[2]._canvas.grid(row=0, column=0, columnspan=1, sticky=ctk.E)
        tl_frame_show_galvanized.grid(**self.grid_args_frame)
        tl_lbl_show_galvanized[1].grid(row=0, column=0, **self.grid_args_label)
        tl_checkbox_show_galvanized[2].grid(row=0, column=1, **self.grid_args_switch)

        # Allowed Companies
        tl_frame_allowed_companies = ctk.CTkFrame(self.tl_cc_app)
        tl_lbl_allowed_companies = customtkinter_utility.label_factory(
            tl_frame_allowed_companies,
            tv_label="Allowed Companies:",
            kwargs_label=self.kwargs_lbl
        )
        tl_frame_allowed_companies_sel = ctk.CTkFrame(
            tl_frame_allowed_companies
        )
        tl_frame_allowed_companies_sel.rowconfigure(0, weight=100)
        tl_frame_allowed_companies_sel.columnconfigure(0, weight=50)
        tl_frame_allowed_companies_sel.columnconfigure(1, weight=50)
        tl_checkbox_allowed_comp_bws = customtkinter_utility.checkbox_factory(
            tl_frame_allowed_companies_sel,
            tv_label="BWS",
            tv_checkbox=self.tv_allowed_comp_bws
        )
        tl_checkbox_allowed_comp_stg = customtkinter_utility.checkbox_factory(
            tl_frame_allowed_companies_sel,
            tv_label="STG",
            tv_checkbox=self.tv_allowed_comp_stg
        )
        tl_frame_allowed_companies.grid(**self.grid_args_frame)
        tl_lbl_allowed_companies[1].grid(row=0, column=0, **self.grid_args_label)
        tl_frame_allowed_companies_sel.grid(row=0, column=1, sticky=ctk.E)
        tl_checkbox_allowed_comp_bws[2].grid(row=0, column=0, **self.grid_args_switch)
        tl_checkbox_allowed_comp_stg[2].grid(row=0, column=1, **self.grid_args_switch)

        self.tl_cc_app.columnconfigure(0, weight=100)
        self.tl_cc_app.rowconfigure(0, weight=100)
        question_frames = [
            tl_cc_app_frame_light_dark_theme,
            tl_cc_app_frame_ask_monitors,
            tl_cc_app_frame_show_left_widgets,
            tl_cc_app_frame_colour_theme,
            tl_cc_app_frame_colour_code_priority,
            tl_cc_app_frame_colour_code_only_priority,
            tl_frame_show_galvanized,
            tl_frame_allowed_companies
        ]
        row_weight = math.floor(100 / len(question_frames))
        for i, f in enumerate(question_frames):
            f.columnconfigure(0, weight=65, minsize=220)
            f.columnconfigure(1, weight=35, minsize=100)
            self.tl_cc_app.rowconfigure(i, weight=row_weight)

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

    def save_colour_coding(self):
        tm = self.settings["TEST_MODE"].get()
        if tm:
            print(f"save_colour_coding")
        known_colour_codes = self.settings.get("colour_coding", {})
        un = self.app_state["user_name"]
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

    def ask_before_close(self, parent=None) -> Tuple[bool, bool]:
        print(f"ask_before_close")
        tm = self.settings["TEST_MODE"].get()
        if tm:
            print(f"ask_before_close")
        # has_history = self.history
        print(f"{self.history.get()=}")
        has_history = self.history.get()

        print(f"{has_history=}")

        msg = self.abc_no_hist_msg
        if has_history:
            msg = self.abc_has_hist_msg

        if parent is None:
            parent = self

        return messagebox.askyesnocancel(
            title=self.title_application_short,
            message=msg,
            parent=parent
        ), has_history

    def ask_save_before_close(self, parent=None) -> Tuple[bool, bool]:
        print(f"ask_save_before_close")
        # has_history = self.history
        has_history = self.history.get()
        print(f"{has_history=}")
        msg = self.abcsh_no_hist_msg
        if has_history:
            msg = self.abcsh_has_hist_msg

        if parent is None:
            parent = self

        return messagebox.askyesnocancel(
            title=self.title_application_short,
            message=msg,
            parent=parent
        ), has_history

    def switch_company(self, comp_id):
        tm = self.settings["TEST_MODE"].get()
        ac = self.tv_allowed_companies.get()
        curr_company = self.settings["mode_company"]
        companies = list(map(lambda c: getattr(c, "name"), COMPANY))
        print(f"-> SWITCH COMPANY {curr_company=}, {comp_id=}")
        print(f"{ac=}")
        if comp_id not in ac:
            messagebox.showerror(
                title=self.title_application_short + " - Switch Companies",
                message=self.msg_invalid_company_to_switch.format(COMPANY=companies[comp_id]),
                parent=(self if (self.tl_sc is None) else self.tl_sc)
            )
        else:
            # if comp_id != curr_company:
            print(f"SWITCH TO {companies[comp_id]=}")
            if comp_id == COMPANY.BWS.value:
                grid_bws = True
                grid_stg = False
                bbox_mc_drag_tile = (
                    *self.drag_tile_start_pos,
                    100 + self.tile_width_bws,
                    100 + self.tile_height_bws
                )
            else:
                grid_bws = False
                grid_stg = True
                bbox_mc_drag_tile = (
                    *self.drag_tile_start_pos,
                    100 + self.tile_width_stg,
                    100 + self.tile_height_stg
                )

            self.invisible_canvas.coords(
                self.multi_combobox_drag_tile,
                *bbox_mc_drag_tile
            )
            self.invisible_canvas.coords(
                self.multi_combobox_drag_tile_texts,
                bbox_mc_drag_tile[0] + ((bbox_mc_drag_tile[2] - bbox_mc_drag_tile[0]) / 2),
                bbox_mc_drag_tile[1] + ((bbox_mc_drag_tile[3] - bbox_mc_drag_tile[1]) / 2)
            )

                # bws widgets
            self.multi_combobox_orders_bws.grid_widget(grid_bws)
            self.multi_combobox_warranties_bws.grid_widget(grid_bws)

            # stg widgets
            self.multi_combobox_orders_stg.grid_widget(grid_stg)
            self.multi_combobox_warranties_stg.grid_widget(grid_stg)

            if not grid_stg:
                self.canvas_stg.grid_forget()
                self.info_frame_stg.grid_forget()
            else:
                self.canvas_stg.grid(row=0)
                self.info_frame_stg.grid()

            if not grid_bws:
                self.canvas_bws.grid_forget()
                self.info_frame_bws.grid_forget()
            else:
                self.canvas_bws.grid(row=0)
                self.info_frame_bws.grid()

            print(f"{grid_bws=}, {grid_stg=}")

            self.settings["mode_company"] = comp_id
            mc_s = f"{comp_id}" if (comp_id != -1) else ""
            if not mc_s:
                mc_s = "NULL"
            if tm:
                print(f"{mc_s=}")

            if comp_id != curr_company:
                un = self.app_state["user_name"]
                sql = "UPDATE [Stargatedb].[dbo].[PDS Valid Updaters] SET [ModeCompany] = {mc_s} WHERE [UserName] = '{un}';"
                sql = sql.format(mc_s=mc_s, un=un)
                connect(sql, **STARGATE_SQL_CREDS, do_show=True)

        self.bind_widgets()
        self.colour_code()

    def click_mb_switch_companies(self, *args):
        tm = self.settings["TEST_MODE"].get()
        ac = self.tv_allowed_companies.get()
        comp = self.settings["mode_company"]
        tw = self.tile_width_bws if (comp == COMPANY.BWS.value) else self.tile_width_stg
        th = self.tile_height_bws if (comp == COMPANY.BWS.value) else self.tile_height_stg
        tv_selected_company = ctk.IntVar(self, value=-1)
        print(f"{ac=}, {type(ac)=}")
        if len(ac) < 2:
            messagebox.showinfo(
                title=self.title_application_short + " - Switch Companies",
                message=self.msg_no_company_to_switch,
                parent=self
            )
        else:
            self.tl_sc = ctk.CTkToplevel(self)
            geom = customtkinter_utility.calc_geometry_tl(
                800, 550, parent=self, rtype=dict
            )
            self.tl_sc.geometry(geom["str"])
            self.tl_sc.title(self.title_application_short + " - Switch Companies")

            self.tl_sc.rowconfigure(0, weight=100)
            self.tl_sc.columnconfigure(0, weight=100)

            def on_close_tl_sc(*args):
                self.tl_sc.destroy()

            def on_click_company(event, idx):
                print(f"{idx=}, {btns[idx]['lbl']=}")
                comp_id = btns[idx]["comp_id"]
                comp_lbl = btns[idx]["lbl"]
                if comp_id != self.settings["mode_company"]:
                    print(f"NEED TO SWITCH COMPANIES")
                    tl_sc_lbl[0].set(f"Switch to {comp_lbl}?")
                else:
                    print(f"STAY ON {comp_lbl}")

                tv_selected_company.set(idx)

                for i in range(len(btns)):
                    state = ctk.HIDDEN if i != idx else ctk.NORMAL
                    print(f"{i=}, {state=}")
                    tl_sc_canvas.itemconfigure(
                        btns[i]["bd_tag"],
                        state=state
                    )

            def click_ays_no(*args):
                print(f"click_ays_no")
                on_close_tl_sc()

            def click_ays_yes(*args):
                print(f"click_ays_yes")
                # on_close_tl_sc()
                idx = tv_selected_company.get()
                if idx == -1:
                    idx = self.default_allowed_companies[0]
                comp_id = btns[idx]["comp_id"]
                comp_lbl = btns[idx]["lbl"]
                print(f"SWITCHING TO {comp_lbl}")
                self.switch_company(comp_id)
                on_close_tl_sc()

            def update_selected_company(*args):
                comp = tv_selected_company.get()
                sel = comp != self.settings["mode_company"]
                print(f"{comp=}, {sel=}, {self.settings['mode_company']=}")
                state = ctk.NORMAL if sel else ctk.HIDDEN
                tl_sc_canvas.itemconfigure(tl_sc_tag_btns, state=state)

            w_can, h_can = 600, 400
            tl_sc_canvas = ctk.CTkCanvas(
                self.tl_sc,
                width=w_can,
                height=h_can
            )
            # gc_btns = tkinter_utility.grid_cells(
            #     w_can,
            #     len(ac),
            #     h_can,
            #     1,
            #     x_pad=25,
            #     y_pad=25
            # )
            gc_btns = tkinter_utility.grid_cells(
                (len(ac) * tw) + ((len(ac) + 1) * 20) + 50,
                len(ac),
                th + 20 + 50,
                1,
                x_pad=25,
                y_pad=25
            )
            btns = [
                {"lbl": "BWS", "img": self.bws_logo_image, "comp_id": COMPANY.BWS.value},
                {"lbl": "STG", "img": self.stg_logo_image, "comp_id": COMPANY.STG.value}
            ]
            for i, row in enumerate(gc_btns):
                for j, bbox in enumerate(row):
                    data = btns[j]
                    lbl_txt = data["lbl"]
                    img = data["img"]

                    mg = 2
                    bbox_bd = (
                        bbox[0] - mg,
                        bbox[1] - mg,
                        bbox[2] + mg,
                        bbox[3] + mg
                    )
                    print(f"{bbox=}, {bbox_bd=}")
                    bd_tag = tl_sc_canvas.create_rectangle(
                        *bbox_bd,
                        fill="#CCBB55"
                    )

                    if img is not None:
                        tag = tl_sc_canvas.create_image(
                            bbox[0] + ((bbox[2] - bbox[0]) / 2),
                            bbox[1] + ((bbox[3] - bbox[1]) / 2),
                            anchor=ctk.CENTER,
                            image=img
                        )
                    else:
                        tag = tl_sc_canvas.create_image(
                            bbox[0] + ((bbox[2] - bbox[0]) / 2),
                            bbox[1] + ((bbox[3] - bbox[1]) / 2),
                            text=lbl_txt
                        )

                    btns[j].update({"tag": tag, "bd_tag": bd_tag})
                    tl_sc_canvas.tag_bind(
                        tag,
                        "<Button-1>",
                        lambda event, idx_=j: on_click_company(event, idx_)
                    )

            tl_sc_frame_ays = ctk.CTkFrame(self.tl_sc, width=200, height=100)
            tl_sc_frame_ays.rowconfigure(0, weight=20)
            tl_sc_frame_ays.rowconfigure(1, weight=80)
            tl_sc_frame_ays.columnconfigure(0, weight=50)
            tl_sc_frame_ays.columnconfigure(1, weight=50)
            tl_sc_btn_cancel = customtkinter_utility.button_factory(
                tl_sc_frame_ays,
                tv_btn="no",
                command=click_ays_no
            )
            tl_sc_btn_submit = customtkinter_utility.button_factory(
                tl_sc_frame_ays,
                tv_btn="yes",
                command=click_ays_yes
            )
            tl_sc_lbl = customtkinter_utility.label_factory(
                tl_sc_frame_ays,
                tv_label="",
                kwargs_label={
                    "font": self.kwargs_lbl["font"]
                }
            )

            tl_sc_canvas.grid(row=0, column=0, sticky=ctk.NSEW)
            tl_sc_lbl[1].grid(row=0, column=0, columnspan=2, padx=16, pady=12)
            tl_sc_btn_cancel[1].grid(row=1, column=0, padx=16, pady=12)
            tl_sc_btn_submit[1].grid(row=1, column=1, padx=16, pady=12)

            tl_sc_tag_btns = tl_sc_canvas.create_window(
                w_can / 2,
                gc_btns[-1][-1][-1] + 80,
                anchor=ctk.CENTER,
                width=200,
                height=100,
                window=tl_sc_frame_ays
            )

            tv_selected_company.trace_variable("w", update_selected_company)
            on_click_company(None, self.settings["mode_company"])
            tv_selected_company.set(self.settings["mode_company"])

            self.tl_sc.grab_set()
            # entry_pwd[3].focus_force()
            self.tl_sc.protocol("WM_DELETE_WINDOW", on_close_tl_sc)
            # self.tl_ad.after(100, lambda: self.entry_admin_password_attempts_remaining[3].focus_force())
            self.wait_window(self.tl_sc)

    def on_close_tl_ad(self, *args):
        self.settings["admin_password_entered"].trace_remove("write", self.cb_admin_password_entered)
        self.tl_ad.destroy()
        self.grab_set()
        self.after(250, lambda: self.tv_done_interact_tl.set(True))

    def click_mb_admin(self, event=None):
        self.tv_done_interact_tl.set(False)
        self.entry_admin_password_attempts_remaining = None
        self.tl_ad = ctk.CTkToplevel(self)
        geom = customtkinter_utility.calc_geometry_tl(
            800, 550, parent=self, rtype=dict
        )
        self.tl_ad.geometry(geom["str"])
        self.tl_ad.title(self.title_application_short + " - Admin")

        ad_pwd = self.settings["admin_password"].get()

        def update_admin_pwd_entered(*args):
            entered = self.settings["admin_password_entered"].get()
            if entered:
                tl_ad_frame_enter.grid_forget()
                tl_ad_frame_entered.grid(row=1, column=0, **self.grid_args_frame, columnspan=2)

            else:
                tl_ad_frame_enter.grid(row=1, column=0, **self.grid_args_frame, columnspan=2)
                tl_ad_frame_entered.grid_forget()

                # self.tl_ad.rowconfigure(0, weight=33)
                # self.tl_ad.rowconfigure(1, weight=33)
                # self.tl_ad.rowconfigure(2, weight=33)

        def click_cancel(*args):
            self.on_close_tl_ad()

        def click_submit(*args):
            ma = self.max_tries_admin_password
            ct = self.tl_tv_count_tries_allow_publish.get()
            pwd = self.entry_admin_password_attempts_remaining[2].get()
            print(f"{pwd=}, {ad_pwd=}")
            if pwd:
                if pwd == ad_pwd:
                    self.settings["admin_password_entered"].set(True)
                    print(f"accepted")
                    ct -= 1
                else:
                    print(f"failure")
                    if (ct + 1) < ma:
                        messagebox.showerror(
                            title=self.title_application_short,
                            message=self.msg_incorrect_admin_password,
                            parent=self.tl_ad
                        )
                    self.entry_admin_password_attempts_remaining[2].set("")
                self.tl_tv_count_tries_allow_publish.set(ct + 1)
            else:
                messagebox.showerror(
                    title=self.title_application_short,
                    message=self.msg_blank_admin_password,
                    parent=self.tl_ad
                )

        def entry_return(*args):
            click_submit()

        frame_top = ctk.CTkFrame(self.tl_ad)
        frame_top.rowconfigure(0, weight=75)
        frame_top.rowconfigure(1, weight=25)
        frame_top.columnconfigure(0, weight=75)
        frame_top.columnconfigure(1, weight=25)
        lbl_title = customtkinter_utility.label_factory(
            frame_top,
            tv_label=f"Admin Menu",
            kwargs_label={
                "font": self.kwargs_lbl["font"]
            }
        )
        self.update_count_tries_allow_publish()
        self.lbl_admin_password_attempts_remaining = customtkinter_utility.label_factory(
            frame_top,
            tv_label=self.lbl_admin_password_attempts_remaining[0]
        )
        tl_ad_frame_enter = ctk.CTkFrame(self.tl_ad)
        self.entry_admin_password_attempts_remaining = customtkinter_utility.entry_factory(
            tl_ad_frame_enter,
            tv_label=f"Enter password:",
            kwargs_entry={
                "show": "*",
                "justify": ctk.CENTER
            }
        )
        frame_btns = ctk.CTkFrame(tl_ad_frame_enter)
        btn_cancel = customtkinter_utility.button_factory(
            frame_btns,
            tv_btn=f"cancel",
            command=click_cancel
        )
        btn_submit = customtkinter_utility.button_factory(
            frame_btns,
            tv_btn=f"submit",
            command=click_submit
        )
        self.cb_admin_password_entered = self.settings["admin_password_entered"].trace_variable("w",
                                                                                                update_admin_pwd_entered)

        # Allow Publish
        tl_ad_frame_entered = ctk.CTkFrame(self.tl_ad)
        tl_ad_frame_allow_publish = ctk.CTkFrame(tl_ad_frame_entered)
        tv_lbl_ap, lbl_ap = customtkinter_utility.label_factory(
            tl_ad_frame_allow_publish,
            tv_label="Allow Publishing:",
            kwargs_label=self.kwargs_lbl
        )
        tl_ad_switch_allow_publish = ctk.CTkSegmentedButton(
            tl_ad_frame_allow_publish,
            values=["No", "Yes"],
            variable=self.tl_tv_switch_allow_publish,
            font=self.kwargs_lbl["font"]
        )

        question_frames = [
            tl_ad_frame_enter,
            tl_ad_frame_entered,
            tl_ad_frame_allow_publish
        ]
        row_weight = math.floor(100 / len(question_frames))
        self.tl_ad.columnconfigure(0, weight=50)
        self.tl_ad.columnconfigure(1, weight=50)
        self.tl_ad.rowconfigure(0, weight=25)
        self.tl_ad.rowconfigure(1, weight=75)
        for i, f in enumerate(question_frames):
            f.columnconfigure(0, weight=65, minsize=220)
            f.columnconfigure(1, weight=35, minsize=100)
            # self.tl_ad.rowconfigure(i, weight=row_weight)

        # self.tl_ad
        frame_top.grid(sticky=ctk.NSEW, columnspan=2)

        # frame_top
        lbl_title[1].grid(row=0, column=0, sticky=ctk.NSEW, columnspan=2)
        self.lbl_admin_password_attempts_remaining[1].grid(row=1, column=1, sticky=ctk.SE, padx=12, pady=5)
        # x_ = geom["w"] - (geom["w"] - 50)
        # y_ = geom["h"] - (geom["h"] - 50)
        # x_ = 5 + geom["x1"]
        # y_ = 5 + geom["y1"]
        # print(f"{x_=}, {y_=}, {geom=}")
        # lbl_tries[1].place(x=x_, y=y_)

        # tl_ad_frame_enter
        self.entry_admin_password_attempts_remaining[1].grid(row=0, column=0, padx=12, pady=12, sticky=ctk.NSEW,
                                                             columnspan=2)
        self.entry_admin_password_attempts_remaining[3].grid(row=1, column=0, padx=12, pady=12, columnspan=2)
        frame_btns.grid(row=2, column=0, padx=12, pady=12, columnspan=2)

        # frame_btns
        btn_cancel[1].grid(row=0, column=0, padx=12, pady=12)
        btn_submit[1].grid(row=0, column=1, padx=12, pady=12)

        # tl_ad_frame_entered
        tl_ad_frame_allow_publish.grid(row=0, column=0, **self.grid_args_frame, columnspan=2)

        # tl_ad_frame_allow_publish
        lbl_ap.grid(row=0, column=0, **self.grid_args_label)
        tl_ad_switch_allow_publish.grid(row=0, column=1, **self.grid_args_switch)

        self.entry_admin_password_attempts_remaining[3].bind("<Return>", entry_return)
        update_admin_pwd_entered()
        self.tl_ad.grab_set()
        # entry_pwd[3].focus_force()
        self.tl_ad.protocol("WM_DELETE_WINDOW", self.on_close_tl_ad)
        self.tl_ad.after(100, lambda: self.entry_admin_password_attempts_remaining[3].focus_force())
        self.wait_window(self.tl_ad)
        self.settings["admin_password_entered"].set(False)

    def click_mb_save(self, event=None):
        tm = self.settings["TEST_MODE"].get()
        if tm:
            print(f"click_mb_save, {event=}")
        statements = self.on_closing(do_quit=False, do_commit=not tm)
        print(f"{statements=}")

    #     test_mode = self.settings["TEST_MODE"].get()
    #     # history = self.history
    #
    #     hist = list(self.history.get())
    #     if not hist:
    #         messagebox.showinfo(
    #             title=self.title_application_short,
    #             message=self.msg_no_hist_on_save
    #         )
    #         return
    #
    #     sql_statments = self.on_closing(do_quit=False)
    #     for stmt in sql_statments:
    #         if not test_mode:
    #             df_res = connect(
    #                 sql=stmt
    #             )
    #
    #     # self.history.clear()
    #     self.history.set(list())
    #     messagebox.showinfo(
    #         title=self.title_application_short,
    #         message=self.msg_save_successful
    #     )

    def reload_application(self, reload_time=4000):
        tm = self.settings["TEST_MODE"].get()
        if tm:
            print(f"begin reload_application {self.settings['init_test_mode_done'].get()=}")
        if self.lbl_processing is not None:
            self.lbl_processing.pack(expand=True, fill="both")

        def wait_loop():
            if tm:
                print(f"begin sleep")
            time.sleep(reload_time / 1000)
            if tm:
                print(f"end sleep")
                self.settings["count_application_reloads"].set(self.settings["count_application_reloads"].get() + 1)

        if self.settings["init_test_mode_done"].get():
            self.set_invisible_canvas("gray")
            thread = threading.Thread(target=wait_loop)
            thread.start()
            thread.join()
            self.set_invisible_canvas()
        else:
            if self.settings["count_application_reloads"].get() > 0:
                self.settings["init_test_mode_done"].set(True)

        if self.lbl_processing is not None:
            self.lbl_processing.pack_forget()
        if tm:
            print(f"end reload_application")

    def set_pds_testing_mode(self, in_testing_mode: bool):

        tm = self.settings["TEST_MODE"].get()
        domain_un = self.app_state["user_full"]
        *domain, un = domain_un.split("\\")
        sql = f"UPDATE [PDS Valid Updaters] SET [InTestingMode] = {int(in_testing_mode)} WHERE [UserName] = '{un}';"
        if tm:
            print(f"--\n{sql}")
        connect(sql, **STARGATE_SQL_CREDS, do_print=tm, do_show=tm)
        if tm:
            print(f"--")
        self.settings["TEST_MODE"].set(in_testing_mode)

    def click_mb_testing_mode(self, event=None):
        tm = self.settings["TEST_MODE"].get()
        if tm:
            print(f"click_mb_testing_mode")

        in_tm = self.settings["TEST_MODE"].get()
        tl_name = "tl_testing_mode"
        tlsn = "tl_tm"

        def click_yes():
            if tm:
                print(f"click_yes TM={in_tm}")
            on_closing_tm()
            self.set_pds_testing_mode(not in_tm)

        def click_no():
            if tm:
                print(f"click_no TM={in_tm}")
            on_closing_tm()
            self.set_pds_testing_mode(in_tm)

        def on_closing_tm(*args):
            self.tl_data[tl_name].destroy()
            self.grab_set()

        self.tl_data[tl_name] = ctk.CTkToplevel(self)
        self.tl_data[tl_name].title(self.title_application_short + " - Testing Mode")

        w, h = 350, 160
        tl_geom = customtkinter_utility.calc_geometry_tl(w, h, largest=True, rtype=dict, parent=self)
        self.tl_data[tl_name].geometry(tl_geom["geometry"])

        message = f"Enter Testing Mode?" if (not in_tm) else f"Exit Testing Mode?"

        kwargs_btn = {
            "font": ("Calibri", 16)
        }

        # toplevel - testing mode - textvariable - label
        self.tl_data[f"{tlsn}_tv_lbl_message"], self.tl_data[
            f"{tlsn}_lbl_message"] = customtkinter_utility.label_factory(
            self.tl_data[tl_name],
            tv_label=message,
            kwargs_label=kwargs_btn.copy()
        )
        self.tl_data[f"{tlsn}_tv_btn_yes"], self.tl_data[f"{tlsn}_btn_yes"] = customtkinter_utility.button_factory(
            self.tl_data[tl_name],
            tv_btn="yes",
            command=click_yes,
            kwargs_btn=kwargs_btn.copy()
        )
        self.tl_data[f"{tlsn}_tv_btn_no"], self.tl_data[f"{tlsn}_btn_no"] = customtkinter_utility.button_factory(
            self.tl_data[tl_name],
            tv_btn="no",
            command=click_no,
            kwargs_btn=kwargs_btn.copy()
        )

        self.tl_data[f"{tlsn}_lbl_message"].grid(row=0, column=0, columnspan=2, padx=20, pady=20)
        self.tl_data[f"{tlsn}_btn_no"].grid(row=1, column=0, columnspan=1, padx=5, pady=5)
        self.tl_data[f"{tlsn}_btn_yes"].grid(row=1, column=1, columnspan=1, padx=5, pady=5)

        self.tl_data[tl_name].protocol("WM_DELETE_WINDOW", on_closing_tm)
        self.tl_data[tl_name].grab_set()
        self.wait_window(self.tl_data[tl_name])

    def click_mb_tutorial(
            self,
            event=None,
            sample_texts_in: Optional[dict[dict[str: str]]] = None
    ):
        self.tv_done_interact_tl.set(False)
        self.tl_tu = ctk.CTkToplevel(self)
        geom = customtkinter_utility.calc_geometry_tl(
            1500, 900, parent=self, rtype=dict
        )
        self.tl_tu.geometry(geom["str"])
        self.tl_tu.title(self.title_application_short + " - Help")

        # self.tl_tu.rowconfigure(0, weight=15)
        self.tl_tu.rowconfigure(0, weight=85)
        self.tl_tu.rowconfigure(1, weight=15)

        self.tl_tu.columnconfigure(0, weight=15)
        self.tl_tu.columnconfigure(1, weight=5)
        self.tl_tu.columnconfigure(2, weight=80)

        tc_colour_fg_text = Colour("#000000")

        if sample_texts_in is None:
            sample_texts_in = {
                "SG101522": {
                    "name": "Quote Number",
                    "desc": "Sequential number for indexing this quote.\n'SG' for 'Stargate'\nThen the next 6 letters are the serial.\n**Counting began at 100000"
                },
                "10001468": {
                    "name": "WO Number",
                    "desc": "Sequential number for indexing stargate Work Order numbers.\nDifferent than the Quote Number, a unit with a WO#\nindicates labour and or materials have been allocated to the quote."
                },
                "Pony Dump 3X17": {
                    "name": "Model Name",
                    "desc": "Indicates the name of the model."
                },
                "Transit Trailer Limited": {
                    "name": "Dealer Name",
                    "desc": "One of the many dealer's Stargate servers."
                },
                "N": {
                    "name": "Galvanized Indicator",
                    "desc": "If 'Y' this unit is, or will be galvanized."
                }
            }

        def update_showing(*args):
            og = tv_showing_og.get()
            new = tv_showing.get()
            if og != new:
                canvas_tile_contents.grid_forget()

        tv_showing_og = ctk.StringVar(self.tl_tu, value="")
        tv_showing = ctk.StringVar(self.tl_tu, value="")
        tv_showing.trace_variable("w", update_showing)

        def click_tile_contents(*args):
            print(f"click_tile_contents")
            tv_showing.set("click_tile_contents")
            canvas_tile_contents.grid(row=0, column=0, sticky=ctk.NSEW)

        def click_go_back(*args):
            self.on_close_tl_tu(None)
            return "break"

        def on_motion_demo_rect(event):
            ex, ey = event.x, event.y
            last_hover = tc_hover_rect.get()
            # print(f"{last_hover=}")
            for ttag in tc_tags_rect:
                bbox = canvas_tile_contents.bbox(ttag)
                tag_txt = canvas_tile_contents.itemcget(ttag, "text")
                tag_col = Colour(canvas_tile_contents.itemcget(ttag, "fill"))
                f_col = tag_col
                if (bbox[0] <= ex <= bbox[2]) and (bbox[1] <= ey <= bbox[3]):
                    if ttag != last_hover:
                        f_col = tag_col.brightened(0.45)
                        tc_hover_rect.set(ttag)
                        # idx = tc_sample_texts.index(tag_txt)
                        # show demo text
                        canvas_tile_contents.itemconfigure(
                            tc_tag_txt_name,
                            text=sample_texts_in[tag_txt]["name"]
                        )
                        canvas_tile_contents.itemconfigure(
                            tc_tag_txt_desc,
                            text=sample_texts_in[tag_txt]["desc"]
                        )
                elif ttag != last_hover:
                    f_col = tc_colour_fg_text

                canvas_tile_contents.itemconfigure(
                    ttag,
                    fill=f_col.hex_code
                )

            # event_widget = event.widget
            # print(f"{event_widget=}")
            # type_e_widget = type(event_widget)
            # if type_e_widget == "Line":
            #     print(f"LINE")
            # else:
            #     print(f"{type_e_widget}")

        frame_btns = ctk.CTkFrame(self.tl_tu)
        frame_window = ctk.CTkFrame(self.tl_tu)
        btns = [
            {"Tile Contents": {"btn": None, "cmd": click_tile_contents}}
        ]
        gc = tkinter_utility.grid_cells(
            120, 1, geom["h"] * 0.6, len(btns)
        )
        for i, row in enumerate(gc):
            for j, bbox in enumerate(row):
                btn_lbl = list(btns[i].keys())[j]
                btn_cmd = btns[i][btn_lbl]["cmd"]
                btns[i][btn_lbl]["btn"] = customtkinter_utility.button_factory(
                    frame_btns,
                    tv_btn=btn_lbl,
                    command=btn_cmd
                )
                btns[i][btn_lbl]["btn"][1].grid(row=i, column=0, sticky=ctk.NSEW)

        tc_w_can, tc_h_can = 800, 800
        canvas_tile_contents = ctk.CTkCanvas(
            frame_window,
            width=tc_w_can,
            height=tc_h_can,
            background="#C9C9C9"
        )
        tc_rect_height = 250
        tc_bbox_rect = (
            25,
            ((tc_h_can - tc_rect_height) / 2),
            tc_rect_height + 25,
            ((tc_h_can + tc_rect_height) / 2)
        )
        # print(f'{tc_bbox_rect=}')
        tc_hover_rect = ctk.IntVar(self.tl_tu, value=-1)
        tc_tag_rect = self.draw_rect(
            tc_bbox_rect,
            fill=self.colour_tile_background.hex_code,
            parent=canvas_tile_contents
        )
        tc_tag_txt_lbl_name = canvas_tile_contents.create_text(
            tc_bbox_rect[2] + 30,
            260,
            text="Name:",
            font=self.kwargs_lbl["font"],
            anchor=ctk.NW
        )
        tc_tag_txt_name = canvas_tile_contents.create_text(
            tc_bbox_rect[2] + 45,
            300,
            text="CONTENTS",
            anchor=ctk.NW
        )
        tc_tag_txt_lbl_desc = canvas_tile_contents.create_text(
            tc_bbox_rect[2] + 30,
            420,
            text="Description:",
            font=self.kwargs_lbl["font"],
            anchor=ctk.NW
        )
        tc_tag_txt_desc = canvas_tile_contents.create_text(
            tc_bbox_rect[2] + 45,
            480,
            text="CONTENTS",
            anchor=ctk.NW
        )
        tc_tags_rect = list()
        tc_sample_texts = [txt for txt in sample_texts_in]
        tc_gc_texts = tkinter_utility.grid_cells(
            tc_bbox_rect[2] - tc_bbox_rect[0],
            1,
            tc_bbox_rect[3] - tc_bbox_rect[1],
            len(tc_sample_texts),
            x_0=tc_bbox_rect[0],
            y_0=tc_bbox_rect[1]
        )
        for i, row in enumerate(tc_gc_texts):
            for j, bbox in enumerate(row):
                mx = bbox[0] + ((bbox[2] - bbox[0]) / 2)
                my = bbox[1] + ((bbox[3] - bbox[1]) / 2)
                tc_tags_rect.append(
                    canvas_tile_contents.create_text(
                        mx, my, text=tc_sample_texts[i],
                        font=self.kwargs_lbl["font"],
                        fill=tc_colour_fg_text.hex_code
                    )
                )

        canvas_tile_contents.bind(
            "<Motion>",
            on_motion_demo_rect
        )

        line_canvas = ctk.CTkCanvas(
            self.tl_tu,
            background="#FFFFFF",
            width=4,
            height=geom["h"] * 0.7,
            borderwidth=0,
            highlightcolor="#FFFFFF"
        )

        frame_ctl_btns = ctk.CTkFrame(self.tl_tu)
        frame_ctl_btns.rowconfigure(0, weight=100)
        frame_ctl_btns.columnconfigure(0, weight=100)
        btn_go_back = customtkinter_utility.button_factory(
            frame_ctl_btns,
            tv_btn="go back",
            command=click_go_back
        )

        frame_btns.grid(row=0, column=0)
        line_canvas.grid(row=0, column=1)
        frame_window.grid(row=0, column=2)
        frame_ctl_btns.grid(row=1, column=0, columnspan=3, sticky=ctk.NSEW)
        btn_go_back[1].grid(row=0, column=0, sticky=ctk.E, padx=20, pady=12)

        self.tl_tu.grab_set()
        self.tl_tu.protocol("WM_DELETE_WINDOW", self.on_close_tl_tu)
        self.wait_window(self.tl_tu)

    def on_close_tl_tu(self, event=None):
        self.grab_release()
        self.tl_tu.destroy()
        # self.bind("<ButtonRelease-1>")
        self.after(250, lambda: self.tv_done_interact_tl.set(True))
        # return "break"

    def click_mb_exit(self, event=None):
        tm = self.settings["TEST_MODE"].get()
        if tm:
            print(f"click_mb_exit, {event=}")
        ans_has_history = self.ask_save_before_close(parent=self)
        ans, has_history = ans_has_history
        if ans == ctk.YES:
            # quit without saving
            self.destroy()
        else:
            # continue editing
            pass

    def on_closing(self, do_quit: bool = True, do_commit: bool = True) -> None | list:
        print(f"on_closing")
        comp = self.settings["mode_company"]
        tm = self.settings["TEST_MODE"].get()
        # history = self.history
        # do_exec = False  # automatically update server using generated sql statements.
        do_exec = do_commit  # automatically update server using generated sql statements.

        # in_test_mode = self.settings["TEST_MODE"].get()
        print(f"TEST_MODE={'Y' if tm else 'N'}")

        do_exec = do_exec and (not tm)

        history = list(self.history.get())
        print(f"{history=}")
        sql_statments = []

        if do_quit:
            # ans_has_history = self.ask_save_before_close()
            if history:
                ans_has_history = self.ask_save_before_close(parent=self)
            else:
                ans_has_history = self.ask_before_close(parent=self)

            ans, has_history = ans_has_history
        else:
            ans = ctk.YES
            has_history = bool(len(history))
        print(f"{ans=}, {has_history=}")
        if ans == ctk.YES:

            if has_history:

                # need the date, line, and Quote # for SQL update query
                # user = utility.get_windows_user(2)
                # user = self.app_state["user"]
                user = self.app_state["user_name"]
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

                for s_df in self.concats_double_entries_stg:
                    stmt_1 = f""
                    if tm:
                        print(f"{s_df[[self.quote_key('quote'), 'Available Date', 'JobAvailableLine']]=}")
                    # sql_1 += sql_blank_double_1.format()
                    stmt_1 += f"\n/* SQL OUTPUT - FIX DOUBLE - {date}*/\n\n/*{rt1}*/\n"

                    for i, row in s_df.iterrows():
                        quote = s_df.iloc[i][self.quote_key("quote")]
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
                            order_1 = self.tiles_stg[date_1][line_1].get("order")
                            order_2 = self.tiles_stg[date_2][line_2].get("order")
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
                                    "KQ": self.df_orders_stg.iloc[order_1]["OrdersV2_SGQuote"]
                                }
                                stmt_1 += f"\n{sql_swap_1.format(**dat_1)}"
                                dat_2 = {"KJ": line_1, "KK": date_1,
                                         "KQ": self.df_orders_stg.iloc[order_1]["OrdersV2_SGQuote"]}
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
                                    "KQ": self.df_orders_stg.iloc[order_2]["OrdersV2_SGQuote"]
                                }
                                stmt_1 += f"\n{sql_swap_1.format(**dat_1)}"
                                dat_2 = {"KJ": line_2, "KK": date_2,
                                         "KQ": self.df_orders_stg.iloc[order_2]["OrdersV2_SGQuote"]}
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
                                "KQ": self.df_orders_stg.iloc[order]["OrdersV2_SGQuote"]
                            }
                            stmt_1 += f"\n{sql_swap_1.format(**dat)}"
                            dat_2 = {"KJ": line_, "KK": date_, "KQ": self.df_orders_stg.iloc[order]["OrdersV2_SGQuote"]}
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

                            quote = self.df_orders_stg.iloc[order]["OrdersV2_SGQuote"]
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
                    # TODO need to ensure that the delivery date is offset.
                    #  Wedge in another update to OrdersV2 probably
                    # sql_statments.append(stmt_)

                # if stmt_1.strip():
                #     print(f"SQL =\n\nBEGIN TRAN;\n\n{stmt_1}\n\nROLLBACK;\nCOMMIT;")

                stmts = "\n".join(sql_statments)
                # if tm:
                print(f"{do_exec=}")
                print(f"{stmts=}")
                # connect_stmts = " ".join([stmt.replace("\n", " ") for stmt in sql_statments[1:]])
                tran_stmts = f"/* SQL */\n/* Date: {date} =*/\n\nBEGIN TRAN;\n\n{stmts}\n\nROLLBACK;\nCOMMIT;"
                if tm:
                    print(f"{'=' * 120}\n\ttran_stmts:\n{tran_stmts}{'=' * 120}")

                if not self.settings["allowed_to_publish"].get():
                    do_exec = False

                out_file = self.file_last_session_sql.removesuffix(".sql")
                out_file += f"{now:%Y%m%d%H%M}.sql"
                with open(out_file, "w") as f:
                    f.write(tran_stmts)

                if do_exec:

                    if comp == COMPANY.BWS.value:
                        messagebox.showinfo(
                            title=self.title_application_short,
                            message=self.msg_feature_coming_soon,
                            parent=self
                        )

                    connect(stmts, **STARGATE_SQL_CREDS, do_show=tm, do_print=tm)
                    messagebox.showinfo(
                        title=self.title_application_short,
                        message=self.msg_save_successful,
                        parent=self
                    )
                    # for stmt in stmts.split(";"):
                    #     st = stmt.replace("\t", " ").replace("\n", " ")
                    #     if st and (not st.startswith("--")):
                    #         print(f"{st=}")
                    #         connect(st)
                else:
                    if tm:
                        messagebox.showinfo(
                            title=self.title_application_short,
                            message=self.msg_no_commit_test_mode,
                            parent=self
                        )
                    elif not self.settings["allowed_to_publish"].get():
                        messagebox.showerror(
                            title=self.title_application_short,
                            message=self.msg_non_publish_user,
                            parent=self
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
        tm = self.settings["TEST_MODE"].get()
        if tm:
            print(f"update_toggle_canvas_selection")
        # toggle_mode = self.toggle_warranty.value.get()
        toggle_mode = self.tv_toggle_warranty.get()
        comp = self.settings["mode_company"]

        self.toggle_warranty.grid_forget()

        if toggle_mode == "Warranty":
            if comp == COMPANY.BWS.value:
                self.multi_combobox_orders_bws.grid_widget(False)
                self.multi_combobox_warranties_bws.grid_widget(True)
            else:
                self.multi_combobox_orders_stg.grid_widget(False)
                self.multi_combobox_warranties_stg.grid_widget(True)
        else:
            # Orders
            if comp == COMPANY.BWS.value:
                self.multi_combobox_orders_bws.grid_widget(True)
                self.multi_combobox_warranties_bws.grid_widget(False)
            else:
                self.multi_combobox_orders_stg.grid_widget(True)
                self.multi_combobox_warranties_stg.grid_widget(False)

        self.toggle_warranty.grid(row=1, column=0)

    def click_if_goto(self):
        tm = self.settings["TEST_MODE"].get()
        if tm:
            print(f"click_if_goto")
        comp = self.settings["mode_company"]
        can = self.canvas_bws if (comp == COMPANY.BWS.value) else self.canvas_stg
        info_frame = self.info_frame_bws if (comp == COMPANY.BWS.value) else self.info_frame_stg

        # before = self.tv_entry_unit_scroll_search.get()
        quote = info_frame.get_value("Quote#")
        if tm:
            print(f"{quote=}")
        if quote:
            date = pd.Timestamp(info_frame.get_value("Sched Finish"))
            line = info_frame.get_value("Sched Line")
            bbox = can.bbox("all")
            xv = can.xview()
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

            can.xview_moveto(p)
            self.flash_tile((date, line), mode="attention")
            self.redraw_legend()

    def check_for_units_on_holidays(self, include_all_holidays: bool = False):
        tm = self.settings["TEST_MODE"].get()
        comp = self.settings["mode_company"]
        tiles = self.tiles_bws if (comp == COMPANY.BWS.value) else self.tiles_stg
        df_orders = self.df_orders_bws if (comp == COMPANY.BWS.value) else self.df_orders_stg
        prod_lines = self.list_prod_lines_bws if (comp == COMPANY.BWS.value) else self.list_prod_lines_stg
        holidays = self.holidays_bws if (comp == COMPANY.BWS.value) else self.holidays_stg
        work_holidays = self.work_holidays_bws if (comp == COMPANY.BWS.value) else self.work_holidays_stg
        day_str = "holiday" if include_all_holidays else self.txt_non_prod_day
        units_on_holiday = {}
        t = "  "
        data = holidays if include_all_holidays else work_holidays
        for d, hn in data.items():
            if tm:
                print(f"{d=}, {hn=}")
            for line in prod_lines:
                tile_data = tiles[d][line]
                if (order := tile_data.get("order")) is not None:
                    qn = df_orders.iloc[order][self.quote_key("quote")]
                    if tm:
                        print(f"{qn=} found on {line=}, on {d=}")
                    units_on_holiday[(d, line)] = (qn, order)
                else:
                    if tm:
                        print(f"no order, {d=}, {line=}")

        if units_on_holiday:
            msg = f"The following quotes were found to be scheduled on a {day_str}:\n"
            shown_dates = set()
            for d, l in units_on_holiday:
                qn, order = units_on_holiday[(d, l)]
                if d not in shown_dates:
                    hn = data[d]
                    msg += f"\n{(t if shown_dates else '')}{hn.center(18)} -- {datetime_utility.date_str_format(d, include_weekday=True, short_month=True, short_weekday=True).center(20)}"
                    shown_dates.add(d)
                msg += f"\n{4 * t}{l.rjust(5)}: {qn}"
            messagebox.showwarning(
                title=self.title_application_short,
                message=msg,
                parent=self
            )
        else:
            # ctk.CTkSegmentedButton
            messagebox.showinfo(
                title=self.title_application_short,
                message=self.msg_no_units_on_holiday,
                parent=self
            )

    def quit_cc_app(self):
        print(f"quit_cc_app")
        self.tl_cc_app.destroy()
        self.grab_set()

    def show_quote_info_tl(self, date, line):
        tm = self.settings["TEST_MODE"].get()
        comp = self.settings["mode_company"]
        # tile_data = self.tiles_stg[date][line]
        tl_name = "tl_qi"
        self.tl_data[tl_name] = ctk.CTkToplevel(self)
        self.tl_data[tl_name].title(self.title_application_short + " - Quote Info")
        self.tl_data[tl_name].geometry(customtkinter_utility.calc_geometry_tl(
            700, 350, parent=self
        ))

        def close_tl(*args):
            self.tl_data[tl_name].destroy()
            self.grab_set()

        tiles = self.tiles_bws if (comp == COMPANY.BWS.value) else self.tiles_stg
        df_orders = self.df_orders_bws if (comp == COMPANY.BWS.value) else self.df_orders_stg
        info_frame_columns = self.info_frame_columns_bws if (comp == COMPANY.BWS.value) else self.info_frame_columns_stg

        self.tl_data["tl_qi_info_frame"] = tkinter_utility.InfoFrame(
            self.tl_data[tl_name],
            labels=info_frame_columns,
            auto_grid=True,
            header="Quote Information:",
            key_width=16,
            val_width=50,
            width=150,
            background=self.bg_info_frame.hex_code,
            padx=10,
            pady=10,
            cell_border=True,
            key_label_keywords={
                "font": "Arial 12 bold",
                "bg": self.bg_info_frame.brightened(0.25).hex_code
            },
            value_label_keywords={
                "font": "Arial 12 bold",
                "bg": self.bg_info_frame.brightened(0.25).hex_code
            },
            header_kwargs={
                "font": "Arial 18 bold",
                "bg": self.bg_info_frame.hex_code
            },
            formats={
                "Prod Date": lambda d: d.strftime("%Y-%m-%d"),
                # "Delivery Date (Est)": lambda d: d.strftime("%Y-%m-%d"),
                "Sched Finish": lambda d: d.strftime("%Y-%m-%d")
            }
        )

        if (date is not None) and (line is not None):
            date_tile_data = tiles.get(date)
            tile, order = None, None
            if date_tile_data:
                tile = date_tile_data[line]
                order = date_tile_data[line].get("order")
            if tm:
                print(f"{tile=}")
            if order is not None:
                series = df_orders.iloc[order]
                if pd.isna(df_orders[self.quote_key("delivery date")]):
                    delivery_date = self.calculate_nth_business_day(date, N_BUSINESS_DAYS_AVAIL_TO_DELIVERY)
                else:
                    delivery_date = df_orders[self.quote_key("delivery date")]
                days_between = (delivery_date - date).days
                dat_1 = {
                    "KD": date,
                    "KL": line,
                    "US Sale": series[self.quote_key("US Sale")],
                    "Quote#": series[self.quote_key("quote")],
                    "WO#": series[self.quote_key("wo")],
                    "Model No": series[self.quote_key("model")],
                    "Dealer": series[self.quote_key("dealer")],
                    "Serial#": series[self.quote_key("sn")],
                    "Customer WO#": series[self.quote_key("Customer WO#")],
                    "Sched Finish": date,
                    "Sched Line": line,
                    "Delivery Date (Est)": f"{delivery_date:%Y-%m-%d} (+ {days_between} days)"
                }
                if tm:
                    print(f"{dat_1=}")
                for k in info_frame_columns:
                    v = dat_1.get(k, f"'{k}'=?")
                    self.tl_data["tl_qi_info_frame"].change_value(k, v)
        else:
            self.tl_data["tl_qi_info_frame"].change_value(self.quote_key("quote"), "?")

        self.tl_data[tl_name].protocol("WM_DELETE_WINDOW", close_tl)
        self.tl_data[tl_name].grab_set()
        self.wait_window(self.tl_data[tl_name])


def test_canvas_window():
    app = ctk.CTk()

    can1 = ctk.CTkCanvas(app, background="#789456")
    can2 = ctk.CTkCanvas(can1, background="#654987")
    can3 = ctk.CTkCanvas(can2, background="#654321")

    can1.create_window(10, 10, anchor=ctk.NW, window=can2)
    can2.create_window(20, 20, anchor=ctk.NW, window=can3)

    can1.pack()

    app.mainloop()


if __name__ == '__main__':
    # test_canvas_window()
    app = App()
    app.mainloop()
