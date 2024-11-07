from collections import OrderedDict
from tkinter import messagebox

import pandas as pd

import tkinter_utility
from utility import *
from customtkinter_utility import *
from pyodbc_connection import connect

BWS: int = 0
STG: int = 1


def calc_price(step_texts):
    valid_types: dict[str: str] = {
        "%": "percent",
        "+/-": "fixed"
    }
    us_sale: bool = step_texts.get("US Sale", False)
    fx_rate: float = step_texts.get("Exchange Rate", 1)
    base_price = step_texts.get("Base Price", 0)
    options = step_texts.get("Sum Of Options", 0)
    npos = step_texts.get("Sum Of NPOs", 0)
    disc1 = step_texts.get("Discount1", 0)
    disc1_type = step_texts.get("Discount1Type", "fixed")
    disc1_type = valid_types.get(disc1_type)
    disc2 = step_texts.get("Discount2", 0)
    disc2_type = step_texts.get("Discount1Type", "fixed")
    disc2_type = valid_types.get(disc2_type)
    disc3 = step_texts.get("Discount3", 0)
    disc3_type = step_texts.get("Discount1Type", "fixed")
    disc3_type = valid_types.get(disc3_type)

    program_disc = step_texts.get("Program Discount", 0)
    program_disc_type = step_texts.get("Program Discount Type", "fixed")
    volume_disc = step_texts.get("Volume Discount", 0)
    volume_disc_type = step_texts.get("Volume Discount Type", "fixed")

    made_in: float = step_texts.get("Total Made-In (CDN)", 0)
    bought_out: float = step_texts.get("Total Bought-Out (CDN)", 0)
    sub_contract: float = step_texts.get("Total Sub-Contract (CDN)", 0)
    lab_act: float = step_texts.get("Labour Act. (CDN)", 0)

    gross: float = base_price + options + npos
    disc1_v: float = disc1 if disc1_type == "fixed" else (gross * disc1 * -1 / 100 if disc1_type == "percent" else 0)
    disc1_sub: float = gross + disc1_v
    disc2_v: float = disc2 if disc2_type == "fixed" else (disc1_sub * disc2 * -1 / 100 if disc2_type == "percent" else 0)
    disc2_sub: float = disc1_sub + disc2_v
    disc3_v: float = disc3 if disc3_type == "fixed" else (disc2_sub * disc3 * -1 / 100 if disc3_type == "percent" else 0)
    disc3_sub: float = disc2_sub + disc3_v  # this is the value that shows as 'Payable in ## Funds' on the Quote Reports

    sale_price: float = disc3_sub
    total_cost: float = made_in + bought_out + sub_contract + lab_act  # this is negative
    mgn_dol: float = sale_price - abs(total_cost)
    mgn_per: float = (sale_price / (abs(total_cost) if (total_cost != 0) else 1)) - 1

    sale_price_cdn: float = disc3_sub * fx_rate
    disc1_cdn: float = disc1 * (fx_rate if disc1_type == "percent" else 1)
    disc2_cdn: float = disc2 * (fx_rate if disc2_type == "percent" else 1)
    disc3_cdn: float = disc3 * (fx_rate if disc3_type == "percent" else 1)
    gross_cdn: float = gross * fx_rate
    disc1_v_cdn: float = disc1_cdn if disc1_type == "fixed" else (gross_cdn * disc1_cdn * -1 / 100 if disc1_type == "percent" else 0)
    disc1_sub_cdn: float = gross_cdn + disc1_v_cdn
    disc2_v_cdn: float = disc2_cdn if disc2_type == "fixed" else (disc1_sub * disc2_cdn * -1 / 100 if disc2_type == "percent" else 0)
    disc2_sub_cdn: float = disc1_sub_cdn + disc2_v_cdn
    disc3_v_cdn: float = disc3_cdn if disc3_type == "fixed" else (disc2_sub * disc3_cdn * -1 / 100 if disc3_type == "percent" else 0)
    disc3_sub_cdn: float = disc2_sub_cdn + disc3_v_cdn  # this is the CDN equivalent of the payable line of Quote Reports
    mgn_dol_cdn: float = sale_price_cdn - abs(total_cost)
    mgn_per_cdn: float = (sale_price_cdn / (abs(total_cost) if (total_cost != 0) else 1)) - 1

    step_texts.update({
        "US Sale": us_sale,
        "Exchange Rate": fx_rate,
        "Base Price": base_price,
        "Sum Of Options": options,
        "Sum Of NPOs": npos,
        "Discount1": disc1,
        "Discount1Type": disc1_type,
        "Discount2": disc2,
        "Discount2Type": disc2_type,
        "Discount3": disc3,
        "Discount3Type": disc3_type,
        "Program Discount": program_disc,
        "Program Discount Type": program_disc_type,
        "Volume Discount": volume_disc,
        "Volume Discount Type": volume_disc_type,

        "Sale Price (CDN or US)": sale_price,
        "Sale Price (CDN)": sale_price_cdn,
        "Total Cost So Far": total_cost,
        "MarginCDN $": mgn_dol,
        "MarginCDN %": mgn_per,
        "MarginCDN $ (CDN)": mgn_dol_cdn,
        "MarginCDN % (CDN)": mgn_per_cdn,

        "Gross Price (CDN or US)": gross,
        "Gross Price (CDN)": gross_cdn,
        "Discount 1 (CDN or US)": disc1_v,
        "Discount 1 (CDN)": disc1_v_cdn,
        "Discount 1 SubTotal (CDN or US)": disc1_sub,
        "Discount 1 SubTotal (CDN)": disc1_sub_cdn,
        "Discount 2 (CDN or US)": disc2_v,
        "Discount 2 (CDN)": disc2_v_cdn,
        "Discount 2 SubTotal (CDN or US)": disc2_sub,
        "Discount 2 SubTotal (CDN)": disc2_sub_cdn,
        "Discount 3 (CDN or US)": disc3_v,
        "Discount 3 (CDN)": disc3_v_cdn,
        "Discount 3 SubTotal (CDN or US)": disc3_sub,
        "Discount 3 SubTotal (CDN)": disc3_sub_cdn,
        "Program Discount (CDN or US)": "",
        "Program Discount (CDN)": "",
        "Program Discount SubTotal (CDN or US)": "",
        "Program Discount SubTotal (CDN)": "",
        "Volume Discount (CDN or US)": "",
        "Volume Discount (CDN)": "",
        "Volume Discount SubTotal (CDN or US)": "",
        "Volume Discount SubTotal (CDN)": "",
        "Discounts Subtotal": ""
    })

    print(f"{step_texts=}")


def percent_value(val: str) -> float:
    v: str = val.strip().removeprefix("%").removesuffix("%").strip()
    print(f"PV {val=}, {v=}")
    if isnumber(v):
        return float(v)
    return 0


def valid_number(val: Any) -> bool:
    # Increased criteria on utility.isnumber
    s_val: str = str(val)
    is_num: bool = isnumber(val)
    if is_num and (len(s_val) == 1) and (not s_val.isdigit()):
        # eliminate 'i', and 'd' or any other interpreted number types by pandas.
        is_num = False
    return is_num


def grid_keys() -> tuple[str, str, str, str, str, str, str, str, str]:
    return "row", "column", "rowspan", "columnspan", "ipadx", "ipady", "padx", "pady", "sticky"


def load_orders_stg() -> pd.DataFrame:
    return connect("OrdersV2")


def load_options_bws():
    return connect("Order Options")


def load_options_stg():
    return connect("Order OptionsV2")


def load_npos_bws():
    return connect("Custom Work")


def load_npos_stg():
    return connect("Custom WorkV2")


def load_orders_bws():
    return connect(
        sql="""
    SELECT
        *
    FROM
        [BWSdb].[dbo].[Orders]
    INNER JOIN
        [SysproCompanyA].[dbo].[SorMaster]
    ON
        [Orders].[Sales Order#] = [SorMaster].[SalesOrder]
    WHERE
        ([Orders].[WO#] IS NOT NULL)
        AND ([Orders].[Decline/Rejected] = 4)
    ;
    """
    )


def load_material_bws():
    return connect(
        sql="""
    SELECT
        *
    FROM
        [SysproCompanyA].[dbo].[v_WorkOrderStatus]
    WHERE
        LEFT([Job], 1) = '1'
    ;
    """, database="SysproCompanyA"
    )


def load_material_stg():
    return connect(
        sql="""
    SELECT
        *
    FROM
        [SysproCompanyS].[dbo].[v_WorkOrderStatus]
    WHERE
        LEFT([Job], 1) = '1'
    ;
    """, database="SysproCompanyS"
    )


def load_labour_bws():
    return connect(
        sql="""
    SELECT
        *
    FROM
        [SysproCompanyA].[dbo].[WipJobAllLab]
    WHERE
        LEFT([Job], 1) = '1'
    ;
    """, database="SysproCompanyA"
    )


def load_labour_stg():
    return connect(
        sql="""
    SELECT
        *
    FROM
        [SysproCompanyS].[dbo].[WipJobAllLab]
    WHERE
        LEFT([Job], 1) = '1'
    ;
    """, database="SysproCompanyS"
    )


class NumberEntryFrame(ctk.CTkFrame):

    def __init__(
            self,
            master: Any,
            id_name: str,
            text_label: str,
            placeholder_text: str = "",
            default_value: float = "0",
            auto_grid: bool = True,
            width: int = 500,
            height: int = 60,
            valid_range: tuple[float] | list[float] | range = None,
            *args,
            **kwargs
    ):
        super().__init__(master, width=width, height=height, **kwargs)

        self.id_name: str = id_name
        self.text_label: str = text_label
        self.placeholder_text: str = placeholder_text
        self.default_value: float = default_value
        self.auto_grid: bool = auto_grid
        self.valid_range: tuple[float] | list[float] | range = valid_range

        self.colour_bg_entry: Colour = Colour("#363636")
        self.colour_fg_entry: Colour = Colour("#FFFFFF")
        self.colour_bg_invalid_entry: Colour = Colour("#880000")
        self.colour_fg_invalid_entry: Colour = Colour("#FFFFFF")
        self.colour_bg_warn_entry: Colour = Colour("#F76521")
        self.colour_fg_warn_entry: Colour = Colour("#FFFFFF")

        self.var: ctk.StringVar = ctk.StringVar(self, value=money(self.default_value))
        self.tv_lbl_entry: ctk.StringVar = ctk.StringVar(self, value=self.text_label)
        self.tuple_entry: tuple[
            ctk.StringVar,
            ctk.CTkLabel,
            ctk.StringVar,
            ctk.CTkEntry
        ] = entry_factory(
            self,
            tv_label=self.tv_lbl_entry,
            tv_entry=self.var,
            kwargs_entry={
                "text_color": self.colour_fg_entry.hex_code,
                "justify": ctk.CENTER,
                "placeholder_text": self.placeholder_text
                # ,
                # "fg_color": self.colour_bg_entry.hex_code
            }
        )
        self.tv_label: ctk.StringVar = self.tuple_entry[0]
        self.label: ctk.CTkLabel = self.tuple_entry[1]
        self.tv_entry: ctk.StringVar = self.tuple_entry[2]
        self.entry: ctk.CTkEntry = self.tuple_entry[3]

        self.trace_var: str = self.var.trace_variable("w", self.update_var)
        self.columnconfigure(0, weight=50)
        self.columnconfigure(1, weight=50)
        self.rowconfigure(0, weight=100)
        self.grid_propagate(False)
        if self.auto_grid:
            self.grid_widgets()

        self.entry.bind("<FocusOut>", self.entry_focus_out)
        self.entry.bind("<FocusIn>", self.entry_focus_in)

    def value(self) -> float:
        var: float = money_value(self.var.get())
        is_num: bool = self.valid()
        return var if is_num else float(self.default_value)

    def valid(self) -> bool:
        return valid_number(money_value(self.var.get()))

    def reset(self):
        self.var.set(f"{self.default_value}")

    def entry_focus_out(self, *args):
        # print(f"Focus out {self.value()=}")
        self.var.set(money(self.value()))

    def entry_focus_in(self, *args):
        # print(f"Focus in {self.value()=}")
        self.var.set(f"{self.value()}")

    def update_var(self, *args):
        var: float = self.value()
        is_num: bool = self.valid()
        if not self.focus_get():
            self.var.set(money(var))
        mode = ("" if is_num else "in") + "valid"
        print(f"NEF update_var id_name='{self.id_name}' {var=}, {is_num=}, {self.valid_range=}")
        if is_num and (self.valid_range is not None):
            if (isinstance(self.valid_range, range)) and (var not in self.valid_range):
                mode = "warn"
            elif not (self.valid_range[0] <= float(var) <= self.valid_range[1]):
                mode = "warn"
        self.validate_entry(self.entry, mode=mode)

    def validate_entry(self, *widgets, mode: str = "valid"):
        bg: Colour = self.colour_bg_entry
        fg: Colour = self.colour_fg_entry
        for widget in widgets:
            if mode == "invalid":
                bg = self.colour_bg_invalid_entry
                fg = self.colour_fg_invalid_entry
            elif mode == "warn":
                bg = self.colour_bg_warn_entry
                fg = self.colour_fg_warn_entry
            widget.configure(
                text_color=fg.hex_code,
                fg_color=bg.hex_code
            )

    def grid_widgets(self, grid: bool = True):
        if grid:
            # self.grid()
            self.label.grid(row=0, column=0, rowspan=1, columnspan=1, padx=5, pady=5, sticky=ctk.W)
            self.entry.grid(row=0, column=1, rowspan=1, columnspan=1, padx=5, pady=5, sticky=ctk.E)
        else:
            # self.grid_forget()
            self.label.grid_forget()
            self.entry.grid_forget()


class DiscountEntryFrame(NumberEntryFrame):

    def __init__(
            self,
            master: Any,
            auto_grid: bool = True,
            **kwargs
    ):
        super().__init__(
            master,
            auto_grid=False,
            **kwargs
        )

        self.auto_grid: bool = auto_grid

        self.options_toggle: list[str] = ["%", "+/-"]
        self.var_toggle: ctk.StringVar = ctk.StringVar(self, value=self.options_toggle[1])
        self.toggle = ctk.CTkSegmentedButton(
            self,
            variable=self.var_toggle,
            values=self.options_toggle
        )

        self.columnconfigure(0, weight=int(100 / 3))
        self.columnconfigure(1, weight=int(100 / 3))
        self.columnconfigure(2, weight=int(100 / 3))

        if self.auto_grid:
            self.grid_widgets()

        self.trace_var_toggle: str = self.var_toggle.trace_variable("w", self.update_toggle)
        self.var.trace_remove("write", self.trace_var)
        self.trace_var: str = self.var.trace_variable("w", self.update_var)
        self.update_toggle()

    def update_toggle(self, *args):
        toggle = self.var_toggle.get()
        print(f"update_toggle '{toggle}'")
        if toggle == self.options_toggle[0]:
            # %
            self.valid_range = [0, 1.5]
        else:
            # +/-
            self.valid_range = [float("-inf"), float("inf")]
        self.update_var()

    def entry_focus_out(self, *args):
        # print(f"Focus out {self.value()=}")
        self.var.set(money(self.value()) if self.var_toggle.get() == "+/-" else percent(self.value() / 100))

    def update_var(self, *args):
        var: float = self.value()
        is_num: bool = self.valid()
        if not self.focus_get():
            self.var.set(money(var) if self.var_toggle.get() == "+/-" else percent(var / 100))
        mode = ("" if is_num else "in") + "valid"
        print(f"DEF update_var id_name='{self.id_name}' {var=}, {is_num=}, {self.valid_range=}")
        if is_num and (self.valid_range is not None):
            if (isinstance(self.valid_range, range)) and (var not in self.valid_range):
                mode = "warn"
            elif not (self.valid_range[0] <= var <= self.valid_range[1]):
                mode = "warn"
        self.validate_entry(self.entry, mode=mode)

    def set_mode(self, mode: Literal["fixed", "percent"] = "fixed"):
        match mode.lower():
            case "percent":
                self.var_toggle.set(self.options_toggle[0])
                self.var.set(percent(self.value()))
            case _:
                self.var_toggle.set(self.options_toggle[1])
                self.var.set(money(self.value()))

    def grid_widgets(self, grid: bool = True):
        if grid:
            # self.grid()
            self.label.grid(row=0, column=0, rowspan=1, columnspan=1, padx=5, pady=5, sticky=ctk.W)
            self.toggle.grid(row=0, column=1, rowspan=1, columnspan=1, padx=5, pady=5, sticky=ctk.W)
            self.entry.grid(row=0, column=2, rowspan=1, columnspan=1, padx=5, pady=5, sticky=ctk.E)
        else:
            # self.grid_forget()
            self.label.grid_forget()
            self.toggle.grid_forget()
            self.entry.grid_forget()

    def value(self) -> float:
        is_fixed: bool = self.var_toggle.get() == "+/-"
        var: float = money_value(self.var.get()) if is_fixed else percent_value(self.var.get())
        is_num: bool = self.valid()
        print(f"DEF V -> id_name='{self.id_name}', {var=}, {is_fixed=}, {is_num=}")
        return var if is_num else float(self.default_value)

    def valid(self) -> bool:
        var: float = money_value(self.var.get()) if self.var_toggle.get() == "+/-" else percent_value(self.var.get())
        return valid_number(var)


class App(ctk.CTk):

    def __init__(self, *args, **kwargs):
        super().__init__(**kwargs)
        self.title_app: str = "Price Checker"
        self.title(self.title_app)
        self.width: int = 1200
        self.height: int = 800
        self.geometry(calc_geometry_tl(self.width, self.height, largest=1))

        self.colour_bg_entry: Colour = Colour("#363636")
        self.colour_fg_entry: Colour = Colour("#FFFFFF")
        self.colour_bg_invalid_entry: Colour = Colour("#880000")
        self.colour_fg_invalid_entry: Colour = Colour("#FFFFFF")
        self.colour_bg_warn_entry: Colour = Colour("#F76521")
        self.colour_fg_warn_entry: Colour = Colour("#FFFFFF")

        self.default_args_frame: dict[str: Any] = {
            "width": 500,
            "height": 80
        }

        self.company = BWS

        self.df_orders_bws: pd.DataFrame = pd.DataFrame()
        self.df_orders_stg: pd.DataFrame = pd.DataFrame()
        self.df_options_bws: pd.DataFrame = pd.DataFrame()
        self.df_options_stg: pd.DataFrame = pd.DataFrame()
        self.df_npos_bws: pd.DataFrame = pd.DataFrame()
        self.df_npos_stg: pd.DataFrame = pd.DataFrame()
        self.df_orders_showable_bws: pd.DataFrame = pd.DataFrame()
        self.df_orders_showable_stg: pd.DataFrame = pd.DataFrame()
        self.df_orders: pd.DataFrame = pd.DataFrame()
        self.df_options: pd.DataFrame = pd.DataFrame()
        self.df_npos: pd.DataFrame = pd.DataFrame()
        self.df_material_bws: pd.DataFrame = pd.DataFrame()
        self.df_material_stg: pd.DataFrame = pd.DataFrame()
        self.df_labour_bws: pd.DataFrame = pd.DataFrame()
        self.df_labour_stg: pd.DataFrame = pd.DataFrame()
        self.df_orders_showable: pd.DataFrame = pd.DataFrame()
        self.list_show_cols_bws: dict[str: str] = {
            "Quote#": "Quote#",
            "WO#": "WO#",
            "Model No": "Model"
        }
        print(f"Start Load Data: {datetime.datetime.now():%Y-%m-%d %H:%M:%S}")
        self.load_data()
        print(f"End Load Data: {datetime.datetime.now():%Y-%m-%d %H:%M:%S}")
        self.df_orders: pd.DataFrame = self.df_orders_stg if self.company == STG else self.df_orders_bws
        self.df_options: pd.DataFrame = self.df_options_stg if self.company == STG else self.df_options_bws
        self.df_npos: pd.DataFrame = self.df_npos_stg if self.company == STG else self.df_npos_bws
        self.df_material: pd.DataFrame = self.df_material_stg if self.company == STG else self.df_material_bws
        self.df_labour: pd.DataFrame = self.df_labour_stg if self.company == STG else self.df_labour_bws
        self.df_orders_showable: pd.DataFrame = self.df_orders_showable_stg if self.company == STG else self.df_orders_showable_bws

        self.frame_inputs_price: ctk.CTkFrame = ctk.CTkFrame(self)
        self.frame_input_price_discounts: ctk.CTkFrame = ctk.CTkFrame(self)
        self.frame_discount_controls: ctk.CTkFrame = ctk.CTkFrame(self.frame_input_price_discounts, **self.default_args_frame)
        self.frame_input_price_controls: ctk.CTkFrame = ctk.CTkFrame(self, **self.default_args_frame)
        self.frame_inputs_margin: ctk.CTkFrame = ctk.CTkFrame(self)
        self.frame_steps: ctk.CTkScrollableFrame = ctk.CTkScrollableFrame(self)

        self.frame_discount_controls.grid_propagate(False)
        self.frame_input_price_controls.grid_propagate(False)

        self.entry_base_price = NumberEntryFrame(
            self.frame_inputs_price,
            id_name="base_price",
            text_label="Base Price (CDN or US)",
            placeholder_text="Enter a the unit base price in either currency",
            default_value=1
        )

        self.tv_toggle_us_sale: ctk.StringVar = ctk.StringVar(self, value="US Sale")
        self.var_toggle_us_sale: ctk.BooleanVar = ctk.BooleanVar(self, value=False)
        self.toggle_us_sale: ctk.CTkSwitch = ctk.CTkSwitch(
            self.frame_inputs_price,
            variable=self.var_toggle_us_sale,
            textvariable=self.tv_toggle_us_sale,
            command=self.update_us_sale
        )

        self.entry_exchange_rate = NumberEntryFrame(
            self.frame_inputs_price,
            id_name="fx_rate",
            text_label="FX Rate (CDN:US)",
            placeholder_text="Enter a number between 0.5 and 1.5",
            default_value=1,
            valid_range=[0.5, 1.5]
        )

        self.entry_sum_of_options = NumberEntryFrame(
            self.frame_inputs_price,
            id_name="options",
            text_label="Sum of Options (CDN or US)",
            placeholder_text="Enter the total sum of the options.",
            default_value=0,
            valid_range=[0, float("inf")]
        )

        self.entry_sum_of_npos = NumberEntryFrame(
            self.frame_inputs_price,
            id_name="npos",
            text_label="Sum of NPOs (CDN or US)",
            placeholder_text="Enter the total sum of the NPOs.",
            default_value=0,
            valid_range=[0, float("inf")]
        )

        self.tv_toggle_show_discounts: ctk.StringVar = ctk.StringVar(self, value="Show Discounts")
        self.var_toggle_show_discounts: ctk.BooleanVar = ctk.BooleanVar(self, value=True)
        self.toggle_show_discounts: ctk.CTkSwitch = ctk.CTkSwitch(
            self.frame_discount_controls,
            variable=self.var_toggle_show_discounts,
            textvariable=self.tv_toggle_show_discounts,
            command=self.update_show_discounts
        )
        self.lbl_show_discounts: tuple[Any] = label_factory(
            self.frame_discount_controls,
            tv_label="",
            kwargs_label={
                "text_color": self.colour_bg_invalid_entry.hex_code
            }
        )
        self.btn_clear_discounts: tuple[Any] = button_factory(
            self.frame_discount_controls,
            tv_btn="clear",
            command=self.click_clear_discounts
        )

        self.entry_discount1 = DiscountEntryFrame(
            self.frame_input_price_discounts,
            id_name="discount1",
            text_label="Discount 1",
            default_value=0
        )

        self.entry_discount2 = DiscountEntryFrame(
            self.frame_input_price_discounts,
            id_name="discount2",
            text_label="Discount 2",
            default_value=0
        )

        self.entry_discount3 = DiscountEntryFrame(
            self.frame_input_price_discounts,
            id_name="discount3",
            text_label="Discount 3",
            default_value=0
        )

        self.entry_program_discount = DiscountEntryFrame(
            self.frame_input_price_discounts,
            id_name="program_discount",
            text_label="Program Discount",
            default_value=0
        )
        self.entry_program_discount.set_mode("percent")
        self.entry_program_discount.toggle.configure(state=ctk.DISABLED)

        self.entry_volume_discount = DiscountEntryFrame(
            self.frame_input_price_discounts,
            id_name="volume_discount",
            text_label="Volume Discount",
            default_value=0
        )
        self.entry_volume_discount.set_mode("percent")
        self.entry_volume_discount.toggle.configure(state=ctk.DISABLED)

        self.btn_lookup = button_factory(
            self.frame_input_price_controls,
            tv_btn="Lookup Quote or WO",
            command=self.click_lookup_quote
        )

        self.btn_clear = button_factory(
            self.frame_input_price_controls,
            tv_btn="clear",
            command=self.click_clear
        )

        self.btn_submit = button_factory(
            self.frame_input_price_controls,
            tv_btn="submit",
            command=self.click_submit
        )

        self.tv_toggle_show_margin_inputs: ctk.StringVar = ctk.StringVar(self, value="Margins")
        self.var_toggle_show_margin_inputs: ctk.BooleanVar = ctk.BooleanVar(self, value=False)
        self.toggle_show_margin_inputs: ctk.CTkSwitch = ctk.CTkSwitch(
            self,
            variable=self.var_toggle_show_margin_inputs,
            textvariable=self.tv_toggle_show_margin_inputs,
            command=self.update_show_margin_inputs
        )

        self.entry_made_in = NumberEntryFrame(
            self.frame_inputs_margin,
            id_name="made_in",
            text_label="Made In (CDN)",
            placeholder_text="Enter the total of Made-In parts in CDN currency.",
            default_value=0
        )

        self.entry_bought_out = NumberEntryFrame(
            self.frame_inputs_margin,
            id_name="bought_out",
            text_label="Bought Out (CDN)",
            placeholder_text="Enter the total of Bought-Out parts in CDN currency.",
            default_value=0
        )

        self.entry_sub_contract = NumberEntryFrame(
            self.frame_inputs_margin,
            id_name="sub_contract",
            text_label="Sub Contract (CDN)",
            placeholder_text="Enter the total of Sub-Contract parts in CDN currency.",
            default_value=0
        )

        self.entry_labour_act = NumberEntryFrame(
            self.frame_inputs_margin,
            id_name="labour_act",
            text_label="Labour Act. (CDN)",
            placeholder_text="Enter the total of consumed Labour in CDN currency.",
            default_value=0
        )

        self.tl: Optional[ctk.CTkToplevel] = None
        self.tl_mc: Optional[MultiComboBox] = None
        self.tl_btn_select: Optional[tuple[Any]] = None
        self.tl_lbl_title: Optional[tuple[Any]] = None

        self.step_text_objs: dict[str: Any] = {}
        self.step_texts: dict[str: str] = OrderedDict({
            "Gross Price (CDN or US)": "",
            "Discount 1 SubTotal (CDN or US)": "",
            "Discount 2 SubTotal (CDN or US)": "",
            "Discount 3 SubTotal (CDN or US)": "",
            "Program Discount SubTotal (CDN or US)": "",
            "Volume Discount SubTotal (CDN or US)": "",
            "Total Made-In (CDN)": "",
            "Total Bought-Out (CDN)": "",
            "Total Sub-Contract (CDN)": "",
            "Total Cost So Far (CDN)": "",
            "Labour Act. (CDN)": "",
            "Labour Est. (CDN)": "",
            "MarginCDN $": "",
            "MarginCDN %": "",
            "Gross Price (CDN)": "",
            "Discount 1 (CDN or US)": "",
            "Discount 1 (CDN)": "",
            "Discount 1 SubTotal (CDN)": "",
            "Discount 2 (CDN or US)": "",
            "Discount 2 (CDN)": "",
            "Discount 2 SubTotal (CDN)": "",
            "Discount 3 (CDN or US)": "",
            "Discount 3 (CDN)": "",
            "Discount 3 SubTotal (CDN)": "",
            "Program Discount (CDN or US)": "",
            "Program Discount (CDN)": "",
            "Program Discount SubTotal (CDN)": "",
            "Volume Discount (CDN or US)": "",
            "Volume Discount (CDN)": "",
            "Volume Discount SubTotal (CDN)": "",
            "Discounts Subtotal": ""
        })

        r, c, rs, cs, ix, iy, px, py, s = grid_keys()
        self.grid_args: dict[str: dict[str: Any]] = {
            # self
            "frame_inputs_price": {r: 0, c: 0, rs: 1, cs: 1, s: ctk.NSEW},
            "frame_input_price_discounts": {r: 1, c: 0, rs: 1, cs: 1, s: ctk.NSEW},
            "frame_input_price_controls": {r: 2, c: 0, rs: 1, cs: 1, s: ctk.NSEW},
            "toggle_show_margin_inputs": {r: 0, c: 1, rs: 1, cs: 1, px: 5, py: 5},
            "frame_inputs_margin": {r: 1, c: 1, rs: 2, cs: 1, s: ctk.NSEW},
            "frame_steps": {r: 0, c: 2, rs: 3, cs: 1, s: ctk.NSEW},

            # self.frame_inputs_price
            "toggle_us_sale": {r: 0, c: 0, rs: 1, cs: 1, px: 5, py: 5},
            "base_price": {r: 1, c: 0, rs: 1, cs: 1, px: 5, py: 5, s: ctk.NSEW},
            "fx_rate": {r: 2, c: 0, rs: 1, cs: 1, px: 5, py: 5, s: ctk.NSEW},
            "options": {r: 3, c: 0, rs: 1, cs: 1, px: 5, py: 5, s: ctk.NSEW},
            "npos": {r: 4, c: 0, rs: 1, cs: 1, px: 5, py: 5, s: ctk.NSEW},

            # self.frame_input_price_discounts
            "frame_discount_controls": {r: 0, c: 0, rs: 1, cs: 1, px: 5, py: 5},
            "discount1": {r: 1, c: 0, rs: 1, cs: 1, px: 5, py: 5, s: ctk.NSEW},
            "discount2": {r: 2, c: 0, rs: 1, cs: 1, px: 5, py: 5, s: ctk.NSEW},
            "discount3": {r: 3, c: 0, rs: 1, cs: 1, px: 5, py: 5, s: ctk.NSEW},
            "program_discount": {r: 4, c: 0, rs: 1, cs: 1, px: 5, py: 5, s: ctk.NSEW},
            "volume_discount": {r: 5, c: 0, rs: 1, cs: 1, px: 5, py: 5, s: ctk.NSEW},

            # self.frame_discount_controls
            "toggle_show_discounts": {r: 0, c: 0, rs: 1, cs: 1, px: 5, py: 5},
            "lbl_show_discounts": {r: 0, c: 1, rs: 1, cs: 1, px: 5, py: 5},

            # self.frame_input_price_controls
            "btn_lookup": {r: 0, c: 0, rs: 1, cs: 2, px: 5, py: 5},
            "btn_clear": {r: 1, c: 0, rs: 1, cs: 1, px: 5, py: 5},
            "btn_submit": {r: 1, c: 1, rs: 1, cs: 1, px: 5, py: 5},

            # self.frame_inputs_margin
            "entry_made_in": {r: 1, c: 0, rs: 1, cs: 1, px: 5, py: 5},
            "entry_bought_out": {r: 2, c: 0, rs: 1, cs: 1, px: 5, py: 5},
            "entry_sub_contract": {r: 3, c: 0, rs: 1, cs: 1, px: 5, py: 5},
            "entry_labour_act": {r: 4, c: 0, rs: 1, cs: 1, px: 5, py: 5},
        }
        # self.rowconfigure(0, weight=int(100/2))
        # self.rowconfigure(1, weight=int(100/2))
        self.columnconfigure(0, weight=int(0.25 * 100))
        self.columnconfigure(1, weight=int(0.25 * 100))
        self.columnconfigure(2, weight=int(0.5 * 100))
        self.grid_widgets()
        self.update_us_sale()
        self.update_show_margin_inputs()

    def on_close_tl(self):
        print(f"on_close_tl")
        if self.tl.winfo_exists():
            self.tl.withdraw()
        self.grab_set()

    def click_lookup_quote(self):
        print(f"click_lookup_quote")
        if self.tl is None:
            self.tl = ctk.CTkToplevel(self)
            self.tl.title(self.title_app)
            self.tl.geometry(calc_geometry_tl(int(self.width * 0.85), int(self.height * 0.85), parent=self))
        else:
            self.tl.deiconify()

        if self.tl_lbl_title is None:
            self.tl_lbl_title = label_factory(
                self.tl,
                tv_label="Select a Quote or WO:"
            )
            self.tl_lbl_title[1].grid(padx=20, pady=20)
        if self.tl_mc is None:
            self.tl_mc = tkinter_utility.MultiComboBox(
                self.tl,
                data=self.df_orders_showable.sort_values(by="Quote#", ascending=False),
                lock_result_col="Quote#",
                show_index_column=False,
                include_aggregate_row=False,
                include_drop_down_arrow=False
            )

        if self.tl_btn_select is None:
            self.tl_btn_select = button_factory(
                self.tl,
                tv_btn="select",
                command=self.click_tl_select
            )
            self.tl_btn_select[1].grid()

        self.tl.protocol("WM_DELETE_WINDOW", self.on_close_tl)
        self.tl.grab_set()
        self.wait_window(self.tl)

    def click_tl_select(self):
        test_prints: bool = True
        selected: int = int(self.tl_mc.res_tv_entry.get())
        grp: str = self.tl_mc.lock_result_col
        # grp: int = self.tl_mc.rg_var.get()
        # print(f"1 {grp=}")
        # grp: str = self.tl_mc.radio_btn_texts[grp]
        # print(f"2 {grp=}")
        # grp: str = {v: k for k, v in self.list_show_cols_bws.items()}[grp]
        print(f"click_tl_select {selected=}, {grp}")
        if selected:
            df_order: pd.DataFrame = self.df_orders.loc[self.df_orders[grp] == selected]
            df_options: pd.DataFrame = self.df_options.loc[self.df_options[grp] == selected]
            df_npos: pd.DataFrame = self.df_npos.loc[self.df_npos[grp] == selected]
            if test_prints:
                print(f"{df_order=}")
                print(f"{df_options=}")
                print(f"{df_npos=}")
            if not df_order.empty:
                sr_order: pd.Series = df_order.iloc[0]

                quote: int = sr_order["Quote#"]
                job: str = str(sr_order["WO#"])

                df_mat: pd.DataFrame = self.df_material[self.df_material["Job"] == job]
                df_lab: pd.DataFrame = self.df_labour[self.df_labour["Job"] == job]

                print(f"{df_mat=}")
                print(f"{df_lab=}")

                cost_MI: float = -df_mat.loc[df_mat["PartCategory"] == "M", "ValueIssued"].sum()
                cost_BO: float = -df_mat.loc[df_mat["PartCategory"] == "B", "ValueIssued"].sum()
                cost_SC: float = -df_mat.loc[df_mat["PartCategory"] == "G", "ValueIssued"].sum()
                lab_act: float = -df_lab["ValueIssued"].sum()
                lab_bud: float = df_lab["UnitValueReqd"].sum()

                base_price: float = sr_order["Price"]
                us_sale: int = sr_order["US Sale"]
                fx_rate: float = sr_order["ExchangeRate"]
                sum_options: float = (df_options["Price"] * df_options["Qty"]).sum()
                sum_npos: float = df_npos["Price"].sum()
                sum_npos_us: float = df_npos["US Price"].sum()
                disc1: float = sr_order.get("Discount1", 0)
                disc2: float = sr_order.get("Discount2", 0)
                disc3: float = sr_order.get("Discount3", 0)
                program_disc: float = sr_order.get("Program Discount", 0)
                volume_disc: float = sr_order.get("Volume Discount", 0)
                # disc1 = disc1 if not pd.isna(disc1) else 0
                # disc2 = disc2 if not pd.isna(disc2) else 0
                # disc3 = disc3 if not pd.isna(disc3) else 0
                disc1_type: str = sr_order["Discount1_Type"].lower()
                disc2_type: str = sr_order["Discount2_Type"].lower()
                disc3_type: str = sr_order["Discount3_Type"].lower()
                if test_prints:
                    print(f"{base_price=}")
                    print(f"{us_sale=}")
                    print(f"{fx_rate=}")
                    print(f"{sum_options=}")
                    print(f"{sum_npos=}")
                    print(f"{sum_npos_us=}")
                    print(f"{disc1=}")
                    print(f"{disc2=}")
                    print(f"{disc3=}")
                    print(f"{program_disc=}")
                    print(f"{volume_disc=}")
                    print(f"{disc1_type=}")
                    print(f"{disc2_type=}")
                    print(f"{disc3_type=}")
                    print(f"{cost_MI=}")
                    print(f"{cost_BO=}")
                    print(f"{cost_SC=}")
                    print(f"{lab_act=}")
                    print(f"{lab_bud=}")

                self.entry_base_price.var.set(base_price)
                self.var_toggle_us_sale.set(bool(us_sale))
                self.entry_exchange_rate.var.set(fx_rate)
                self.entry_sum_of_options.var.set(sum_options)
                if us_sale:
                    self.entry_sum_of_npos.var.set(sum_npos_us)
                else:
                    self.entry_sum_of_npos.var.set(sum_npos)
                self.entry_discount1.var_toggle.set("%" if disc1_type == "percent" else "+/-")
                self.entry_discount1.var.set(100 * disc1)
                self.entry_discount2.var_toggle.set("%" if disc2_type == "percent" else "+/-")
                self.entry_discount2.var.set(100 * disc2)
                self.entry_discount3.var_toggle.set("%" if disc3_type == "percent" else "+/-")
                self.entry_discount3.var.set(100 * disc3)
                self.entry_program_discount.var.set(program_disc)
                self.entry_volume_discount.var.set(volume_disc)

                self.entry_made_in.var.set(cost_MI)
                self.entry_bought_out.var.set(cost_BO)
                self.entry_sub_contract.var.set(cost_SC)
                self.entry_labour_act.var.set(lab_act)

                for entry in [
                    self.entry_base_price,
                    self.entry_exchange_rate,
                    self.entry_sum_of_options,
                    self.entry_sum_of_npos,
                    self.entry_discount1,
                    self.entry_discount2,
                    self.entry_discount3,
                    self.entry_program_discount,
                    self.entry_volume_discount,

                    self.entry_made_in,
                    self.entry_bought_out,
                    self.entry_sub_contract,
                    self.entry_labour_act
                ]:
                    entry.entry_focus_out()

                self.click_submit()

    def click_submit(self):
        print(f"submit")
        entries: list[NumberEntryFrame] = [
            self.entry_exchange_rate,
            self.entry_base_price,
            self.entry_sum_of_options,
            self.entry_sum_of_npos,
            self.entry_discount1,
            self.entry_discount2,
            self.entry_discount3,
            self.entry_program_discount,
            self.entry_volume_discount,

            self.entry_made_in,
            self.entry_bought_out,
            self.entry_sub_contract,
            self.entry_labour_act
        ]
        all_valid = all(map(lambda e: e.valid(), entries))
        if not all_valid:
            messagebox.showerror(
                title=self.title_app,
                message=f"Please correct your inputs."
            )
        else:
            print(f"All set")
            self.step_texts.update({
                "US Sale": self.var_toggle_us_sale.get(),
                "Exchange Rate": self.entry_exchange_rate.value(),
                "Base Price": self.entry_base_price.value(),
                "Sum Of Options": self.entry_sum_of_options.value(),
                "Sum Of NPOs": self.entry_sum_of_npos.value(),
                "Discount1": self.entry_discount1.value(),
                "Discount1Type": self.entry_discount1.var_toggle.get(),
                "Discount2": self.entry_discount2.value(),
                "Discount2Type": self.entry_discount2.var_toggle.get(),
                "Discount3": self.entry_discount3.value(),
                "Discount3Type": self.entry_discount3.var_toggle.get(),
                "Program Discount": self.entry_program_discount.value(),
                "Program Discount Type": self.entry_program_discount.var_toggle.get(),
                "Volume Discount": self.entry_volume_discount.value(),
                "Volume Discount Type": self.entry_program_discount.var_toggle.get(),
                "Total Made-In (CDN)": self.entry_made_in.value(),
                "Total Bought-Out (CDN)": self.entry_bought_out.value(),
                "Total Sub-Contract (CDN)": self.entry_sub_contract.value(),
                "Labour Act. (CDN)": self.entry_labour_act.value()
            })
            calc_price(self.step_texts)

            for k, v in self.step_texts.items():
                txt = f"{k.rjust(35)} - " + f"{v}".ljust(16)
                if k not in self.step_text_objs:
                    self.step_text_objs[k] = label_factory(
                        self.frame_steps,
                        tv_label=txt,
                        kwargs_label={
                            "width": 180
                        }
                    )
                    self.step_text_objs[k][1].grid()
                else:
                    self.step_text_objs[k][0].set(txt)

            print(f"{self.step_texts=}")

    def click_clear(self):
        print(f"clear")
        self.var_toggle_us_sale.set(False)
        for entry in [
            self.entry_exchange_rate,
            self.entry_base_price,
            self.entry_sum_of_options,
            self.entry_sum_of_npos
        ]:
            entry.reset()
        self.click_clear_discounts()

    def click_clear_discounts(self):
        print(f"click_clear_discounts")
        for entry in [
            self.entry_discount1,
            self.entry_discount2,
            self.entry_discount3,
            self.entry_program_discount,
            self.entry_volume_discount
        ]:
            entry.reset()
        self.var_toggle_show_discounts.set(False)

    def update_us_sale(self, *args):
        us_sale: bool = self.var_toggle_us_sale.get()
        print(f"update_us_sale <{us_sale}>")
        if us_sale:
            self.entry_exchange_rate.grid_widgets()
            self.entry_exchange_rate.grid(**self.grid_args["fx_rate"])
        else:
            self.entry_exchange_rate.var.set("1")
            self.entry_exchange_rate.grid_widgets(False)
            self.entry_exchange_rate.grid_forget()

    def update_show_discounts(self, *args):
        show: bool = self.var_toggle_show_discounts.get()
        print(f"update_show_discounts {show}")
        sum_discounts: float = sum([
            self.entry_discount1.value(),
            self.entry_discount2.value(),
            self.entry_discount3.value(),
            self.entry_program_discount.value(),
            self.entry_volume_discount.value()
        ])
        if (not show) and (sum_discounts != 0):
            show = True
            self.var_toggle_show_discounts.set(show)
            self.lbl_show_discounts[0].set("Non 0 discounts")
        if show:
            self.entry_discount1.grid(**self.grid_args["discount1"])
            self.entry_discount2.grid(**self.grid_args["discount2"])
            self.entry_discount3.grid(**self.grid_args["discount3"])
            self.entry_program_discount.grid(**self.grid_args["program_discount"])
            self.entry_volume_discount.grid(**self.grid_args["volume_discount"])
        else:
            self.entry_discount1.grid_forget()
            self.entry_discount2.grid_forget()
            self.entry_discount3.grid_forget()
            self.entry_program_discount.grid_forget()
            self.entry_volume_discount.grid_forget()
            self.lbl_show_discounts[0].set("")

    def update_show_margin_inputs(self, *args):
        show: bool = self.var_toggle_show_margin_inputs.get()
        print(f"update_show_margin_inputs {show}")

        if show:
            self.frame_inputs_margin.grid(**self.grid_args["frame_inputs_margin"])
        else:
            self.frame_inputs_margin.grid_forget()

    def load_data(self):
        self.df_orders_bws = load_orders_bws()
        self.df_orders_stg = load_orders_stg()
        self.df_options_bws = load_options_bws()
        self.df_options_stg = load_options_stg()
        self.df_npos_bws = load_npos_bws()
        self.df_npos_stg = load_npos_stg()
        self.df_material_bws = load_material_bws()
        self.df_material_stg = load_material_stg()
        self.df_labour_bws = load_labour_bws()
        self.df_labour_stg = load_labour_stg()

        self.df_orders_bws["WO#"] = self.df_orders_bws["WO#"].fillna(0).astype(int)
        self.df_orders_bws["Program Discount"] = self.df_orders_bws["Program Discount"].fillna(0)
        self.df_orders_bws["Volume Discount"] = self.df_orders_bws["Volume Discount"].fillna(0)
        self.df_orders_bws["Quote#"] = self.df_orders_bws["Quote#"].astype(int)
        self.df_orders_bws = self.df_orders_bws.loc[
            (self.df_orders_bws["Decline/Rejected"] == 4)
            & (self.df_orders_bws["WO#"] != 0)
            ]

        self.df_orders_showable_bws = self.df_orders_bws[self.list_show_cols_bws.keys()].rename(
            columns=self.list_show_cols_bws)

    def grid_widgets(self, grid: bool = True):
        if grid:
            # self
            self.frame_inputs_price.grid(**self.grid_args["frame_inputs_price"])
            self.frame_input_price_discounts.grid(**self.grid_args["frame_input_price_discounts"])
            self.frame_input_price_controls.grid(**self.grid_args["frame_input_price_controls"])
            self.toggle_show_margin_inputs.grid(**self.grid_args["toggle_show_margin_inputs"])
            self.frame_inputs_margin.grid(**self.grid_args["frame_inputs_margin"])
            self.frame_steps.grid(**self.grid_args["frame_steps"])

            # self.frame_inputs_price
            self.entry_base_price.grid(**self.grid_args["base_price"])
            self.toggle_us_sale.grid(**self.grid_args["toggle_us_sale"])
            self.entry_exchange_rate.grid(**self.grid_args["fx_rate"])
            self.entry_sum_of_options.grid(**self.grid_args["options"])
            self.entry_sum_of_npos.grid(**self.grid_args["npos"])

            # self.frame_input_price_discounts
            self.frame_discount_controls.grid(**self.grid_args["frame_discount_controls"])
            self.entry_discount1.grid(**self.grid_args["discount1"])
            self.entry_discount2.grid(**self.grid_args["discount2"])
            self.entry_discount3.grid(**self.grid_args["discount3"])
            self.entry_program_discount.grid(**self.grid_args["program_discount"])
            self.entry_volume_discount.grid(**self.grid_args["volume_discount"])

            # self.frame_discount_controls
            self.toggle_show_discounts.grid(**self.grid_args["toggle_show_discounts"])
            self.lbl_show_discounts[1].grid(**self.grid_args["lbl_show_discounts"])

            # self.frame_input_price_controls
            self.btn_lookup[1].grid(**self.grid_args["btn_lookup"])
            self.btn_clear[1].grid(**self.grid_args["btn_clear"])
            self.btn_submit[1].grid(**self.grid_args["btn_submit"])

            # self.frame_inputs_margin
            self.entry_made_in.grid(**self.grid_args["entry_made_in"])
            self.entry_bought_out.grid(**self.grid_args["entry_bought_out"])
            self.entry_sub_contract.grid(**self.grid_args["entry_sub_contract"])
            self.entry_labour_act.grid(**self.grid_args["entry_labour_act"])
        else:
            # self
            self.frame_inputs_price.grid_forget()
            self.frame_input_price_discounts.grid_forget()
            self.frame_input_price_controls.grid_forget()
            self.frame_inputs_margin.grid_forget()
            self.toggle_show_margin_inputs.grid_forget()
            self.frame_steps.grid_forget()

            # self.frame_inputs_price
            self.toggle_us_sale.grid_forget()
            self.toggle_us_sale.grid_forget()
            self.entry_exchange_rate.grid_forget()
            self.entry_sum_of_options.grid_forget()
            self.entry_sum_of_npos.grid_forget()

            # self.frame_input_price_discounts
            self.frame_discount_controls.grid_forget()
            self.entry_discount1.grid_forget()
            self.entry_discount2.grid_forget()
            self.entry_discount3.grid_forget()
            self.entry_program_discount.grid_forget()
            self.entry_volume_discount.grid_forget()

            # self.frame_discount_controls
            self.toggle_show_discounts.grid_forget()
            self.lbl_show_discounts[1].grid_forget()

            # self.frame_input_price_controls
            self.btn_lookup[1].grid_forget()
            self.btn_clear[1].grid_forget()
            self.btn_submit[1].grid_forget()

            # self.frame_inputs_margin
            self.entry_made_in.grid_forget()
            self.entry_bought_out.grid_forget()
            self.entry_sub_contract.grid_forget()
            self.entry_labour_act.grid_forget()


if __name__ == '__main__':
    app = App()
    app.mainloop()
