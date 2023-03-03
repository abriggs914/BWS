import os
import webbrowser
import pdfkit

from html_utility import *
from colour_utility import *
from tkinter_utility import *
from datetime_utility import *
from pyodbc_connection import connect
from location_utility import company_from_location
from orbiting_date_picker import OrbitingDatePicker
from utility import dict_print, next_available_file_name, get_windows_user


class ToggleButtonQuantity(ToggleButton):

    def __init__(
            self,
            master,
            start_val=0,
            init_val=0,
            stop_val=100,
            scale_kwargs=None,
            label_scale_kwargs=None,
            *args,
            **kwargs
    ):
        super().__init__(master, *args, **kwargs)

        print(f"Start state: {self.state.get()=}\n{self.switch_mode.get()=}")

        valid_label_scale_kwargs = {
            "row": 0,
            "column": 2,
            "rowspan": 1,
            "columnspan": 1,
            "ipadx": 0,
            "ipady": 0,
            "padx": 0,
            "pady": 0
        }
        valid_scale_kwargs = {
            "row": 0,
            "column": 3,
            "rowspan": 1,
            "columnspan": 1,
            "ipadx": 0,
            "ipady": 0,
            "padx": 0,
            "pady": 0
        }
        if scale_kwargs is None:
            self.scale_kwargs = valid_scale_kwargs
        else:
            self.scale_kwargs = scale_kwargs
            for k, v in valid_scale_kwargs.items():
                if k not in self.scale_kwargs:
                    self.scale_kwargs.update({k: v})

        if label_scale_kwargs is None:
            self.label_scale_kwargs = valid_label_scale_kwargs
        else:
            self.label_scale_kwargs = scale_kwargs
            for k, v in valid_label_scale_kwargs.items():
                if k not in self.label_scale_kwargs:
                    self.label_scale_kwargs.update({k: v})

        self.start_val = start_val if start_val is not None else 0
        self.stop_val = stop_val if stop_val is not None else 0
        self.init_val = clamp(self.start_val, init_val, self.stop_val)
        self.tv_scale = tkinter.IntVar(self, value=self.init_val)
        self.tv_scale.trace_variable("w", self.update_scale)
        self.tv_label_scale = tkinter.StringVar(self, value=f"x {self.tv_scale.get()}")
        self.scale = tkinter.Scale(
            self,
            variable=self.tv_scale,
            from_=self.start_val,
            to=self.stop_val,
            orient=tkinter.HORIZONTAL,
            width=self.height * 0.3,
            length=self.width,
            showvalue=0
        )
        self.label_scale = tkinter.Label(
            self,
            textvariable=self.tv_label_scale,
            background=self.colour_bg_true,
            foreground=self.colour_fg_true,
            font=self.label_font
        )

        self.rowconfigure("all", weight=1, uniform='row')
        self.columnconfigure([0, 1, 2, 3], minsize=100)
        self.columnconfigure([0, 1], weight=1, uniform='column')
        # self.columnconfigure(1, weight=1, uniform='column')
        # self.columnconfigure(2, weight=1, uniform='column')

    def show_question(self, *args):
        print(f"show_quantity {self.state.get()=}")
        if self.state.get():
            self.label_scale.grid(**self.label_scale_kwargs)
            self.scale.grid(**self.scale_kwargs)
            self.animate_number()
        else:
            self.label_scale.grid_forget()
            self.scale.grid_forget()

    def animate_number(self):
        s = self.n_slices
        t = self.after_time
        g = self.gradients[1]
        b, f = g

        def iter_update(i):
            if i == s:
                return
            cf = f[i]
            cb = b[i]
            self.label_scale.configure(background=cb, foreground=cf)
            self.after(t, iter_update, (i + 1))

        iter_update(0)

    def update_scale(self, *args):
        self.tv_label_scale.set(f"x {self.tv_scale.get()}")

    # def state_change(self, *args):
    #     state = self.state.get()
    #     if state:
    #         self.scale.grid()

    def get_objects(self):
        return (*super().get_objects(), (self.tv_scale, self.label_scale, self.scale))


class ToggleButtonWiredLess(ToggleButton):

    def __init__(
            self,
            master,
            tb_kwargs=None,
            tb_label_kwargs=None,
            tb_frame_canvas_kwargs=None,
            tb_canvas_kwargs=None,
            *args,
            **kwargs
    ):
        super().__init__(master, *args, **kwargs)

        print(f"Start state: {self.state.get()=}\n{self.switch_mode.get()=}")

        valid_tb_kwargs = {
            "row": 0,
            "column": 2,
            "rowspan": 1,
            "columnspan": 2,
            "ipadx": 0,
            "ipady": 0,
            "padx": 0,
            "pady": 0,
            "sticky": "nsew"
        }
        valid_label_kwargs = {
            "row": 0,
            "column": 0,
            "rowspan": 1,
            "columnspan": 1,
            "ipadx": 0,
            "ipady": 0,
            "padx": 0,
            "pady": 0
        }
        valid_frame_canvas_kwargs = {
            "row": 0,
            "column": 1,
            "rowspan": 1,
            "columnspan": 1,
            "ipadx": 0,
            "ipady": 0,
            "padx": 0,
            "pady": 0
        }
        valid_canvas_kwargs = {
            "row": 0,
            "column": 0,
            "rowspan": 1,
            "columnspan": 1,
            "ipadx": 0,
            "ipady": 0,
            "padx": 0,
            "pady": 0
        }

        if tb_kwargs is None:
            self.tb_kwargs = valid_tb_kwargs
        else:
            self.tb_kwargs = tb_kwargs
            for k, v in valid_tb_kwargs.items():
                if k not in self.tb_kwargs:
                    self.tb_kwargs.update({k: v})

        if tb_label_kwargs is None:
            self.tb_label_kwargs = valid_label_kwargs
        else:
            self.tb_label_kwargs = tb_label_kwargs
            for k, v in valid_label_kwargs.items():
                if k not in self.tb_label_kwargs:
                    self.tb_label_kwargs.update({k: v})

        if tb_frame_canvas_kwargs is None:
            self.tb_frame_canvas_kwargs = valid_frame_canvas_kwargs
        else:
            self.tb_frame_canvas_kwargs = tb_frame_canvas_kwargs
            for k, v in valid_frame_canvas_kwargs.items():
                if k not in self.tb_frame_canvas_kwargs:
                    self.tb_frame_canvas_kwargs.update({k: v})

        if tb_canvas_kwargs is None:
            self.tb_canvas_kwargs = valid_canvas_kwargs
        else:
            self.tb_canvas_kwargs = tb_canvas_kwargs
            for k, v in valid_canvas_kwargs.items():
                if k not in self.tb_canvas_kwargs:
                    self.tb_canvas_kwargs.update({k: v})

        self.tb__, \
        self.tb__label_data, \
        self.tb__frame_canvas, \
        self.tb__canvas_data \
            = ToggleButton(
            self,
            label_text="Wireless?",
            labels=("Yes", "No"),
            height_canvas=self.height,
            height_label=self.height_label,
            label_font=self.label_font,
            width_canvas=100,
            width_label=10,
            auto_grid=False
        ).get_objects()
        self.tb__tv_label, self.tb__label = self.tb__label_data
        self.tb__state, self.tb__canvas = self.tb__canvas_data

        print(f"##{self.switch_positions=}")
        try:
            print(f"##{self.switch_positions=}")
        except AttributeError:
            print(f"##self.switch_positions NOT FOUND")

        print(f"Start state: {self.tb__.state.get()=}\n{self.tb__.switch_mode.get()=}")

        self.rowconfigure("all", weight=1, uniform='row')
        self.columnconfigure([0, 1, 2, 3], minsize=100)
        self.columnconfigure([0, 1], weight=1, uniform='column')

        # self.rowconfigure("all", weight=1, uniform='row')
        # self.columnconfigure("all", weight=1, uniform='column')
        # self.columnconfigure(1, weight=1, uniform='column')
        # self.columnconfigure(2, weight=1, uniform='column')
        # self.columnconfigure(3, weight=1, uniform='column')

    def grid_widgets(self):
        super(ToggleButtonWiredLess, self).grid_widgets()
        self.show_widgets()

    def grid_forget_widgets(self):
        super(ToggleButtonWiredLess, self).grid_forget_widgets()
        self.hide_widgets()

    def show_question(self, *args):
        print(f"show_question {self.state.get()=}")
        if self.state.get():
            self.show_widgets()
        else:
            self.hide_widgets()

    def show_widgets(self):
        self.tb__.grid(**self.tb_kwargs)
        self.tb__label.grid(**self.tb_label_kwargs)
        self.tb__frame_canvas.grid(**self.tb_frame_canvas_kwargs)
        self.tb__canvas.grid(**self.tb_canvas_kwargs)

    def hide_widgets(self):
        self.tb__.grid_forget()
        self.tb__label.grid_forget()
        self.tb__frame_canvas.grid_forget()
        self.tb__canvas.grid_forget()

    # def state_change(self, *args):
    #     state = self.state.get()
    #     if state:
    #         self.scale.grid()

    # def get_objects(self):
    #     return (*super().get_objects(), (self.tv_scale, self.scale))


# job description


class HardwareFormApp(tkinter.Tk):

    def __init__(self):
        super().__init__()
        self.state("zoomed")

        # TODO the number of monitors needs to be displayed.

        q = "quantity"
        w = "wired(less)"
        d = "databaseSelection"

        self.default_data = {
            "start_of_day_hour": 8,
            "start_of_day_minute": 0,
            "start_of_day_format": "%A %a %d %Y",
            "odp_date_format": "YYYY-mm-dd",
            "no_comment": "N/A",
            "it_sign_off": """
            <div class=\"it_section\">
                <form>
                    <label for=\"form_start_date\">Start Date:</label>
                    <input name=\"form_start_date\" class=\"it_text\" value=\"{it_start_date}\" disabled>
                    <label for=\"form_end_date\">End Date:</label>
                    <input name=\"form_end_date\" class=\"it_text\" value=\"{it_end_date}\" disabled>
                </form>
                <h5>Comments:</h5>
                <p class=\"it_text_block\">{it_comments}</p>
            </div>""",
            "it_css": """
                .it_text {{
                    text-align: center;
                }}
                div.it_section {{
                    background: {background_it_section};
                }}
            """
        }

        self.flags = {
            "-odbc": self.flag_odbc,
            "-outlook": self.flag_outlook,
            "-outlook_archive": self.flag_outlook_archive,
            "-g_drive": self.flag_g_drive,
            "-u_drive": self.flag_u_drive
        }

        self.frame_top_controls = tkinter.Frame(self, name="top_controls", background="#10aee3")
        self.frame_top_controls_a = tkinter.Frame(self.frame_top_controls, name="top_controls_a", background="#171717")
        # self.frame_top_controls_a_a = tkinter.Frame(self.frame_top_controls_a, name="top_controls_a_a")
        self.frame_top_controls_b = tkinter.Frame(self.frame_top_controls, name="top_controls_b")
        self.frame_top_controls_c = tkinter.Frame(self.frame_top_controls, name="top_controls_c", background="#171717")
        self.frame_top_controls_d = tkinter.Frame(self.frame_top_controls, name="top_controls_d", background="#171717")
        self.frame_software = tkinter.Frame(self, name="fame_software", background="#141441", width=200)
        self.frame_hardware = tkinter.Frame(self, name="fame_hardware", background="#411414", width=200)
        self.frame_comp_choice = tkinter.Frame(self.frame_hardware, name="fame_comp_choice")
        self.frame_hardware_toggle_buttons = tkinter.Frame(self.frame_hardware, background=random_colour(rgb=False))
        self.frame_software_toggle_buttons = tkinter.Frame(self.frame_software, background=random_colour(rgb=False))
        self.frame_auto_reports = tkinter.Frame(self, name="frame_auto_reports", background="#54CE98")

        self.tv_label_comp_choice = tkinter.StringVar(self, value="Select Hardware:", name="tv_label_comp_choice")
        self.tv_comp_choice = tkinter.StringVar(self, name="tv_comp_choice")
        self.tv_label_company_choice = tkinter.StringVar(self, value="Select Company:", name="tv_label_company_choice")
        self.tv_company_choice = tkinter.StringVar(self, name="tv_company_choice", value=company_from_location())
        self.tv_label_objective_choice = tkinter.StringVar(self, value="What would you like help with?",
                                                           name="tv_label_objective_choice")
        self.tv_objective_choice = tkinter.StringVar(self, name="tv_objective_choice")

        # self.frame_hardware_software_toggles = tkinter.Frame(self)

        self.colour_schemes = {
            "background_text_block": "#888888",
            "background_bws": Colour(BWS_GREY).hex_code,
            "foreground_bws": Colour(BWS_RED).hex_code,
            "background_stg": Colour(STARGATE_BLUE).hex_code,
            "foreground_stg": Colour(SNOW).hex_code,
            "background_lew": Colour(GRAY_31).hex_code,
            "foreground_lew": Colour(GREEN_ONION).hex_code,
            "background_hug": Colour(GRAY_31).hex_code,
            "foreground_hug": Colour(GOLD_2).hex_code,
            "font_size_p": 18,
            "font_size_emp_name": 18,
            "font_size_due_date": 18,
            "font_size_company": 18,
            "font_size_boss": 18,
            "background_it_section": "#888888",
            "foreground_valid_date": "black",
            "foreground_invalid_date": "red",
            "signature_font": "Brush Script MT",
            "font_size_user_signature": 22
        }

        # https://www.pythontutorial.net/tkinter/ttk-style/
        self.style = ttk.Style()
        self.style_key_odp_normal = "odp.Red.TEntry"
        self.style_key_odp_invalid = "odp.Black.TEntry"
        self.init_style_keys()

        self.list_of_objectives = {
            "New Employee Hire": {
                "obj": """
New employee {new_emp_name}, will be starting {new_start_date} at {new_company}.
They will be reporting to {new_boss}.
They will require the following Hardware and Software prepared and installed.
{new_hardware}
{new_software}

Please notify {new_follow_up} once this has been completed

Comments:
{new_comments}
                    """,
                "html": """
<!DOCTYPE html>
<html>

<head>
    <title>Page Title</title>\
    <style>
        div.lists {{
            display: flex;
			justify-content: space-between;
        }}
        div.lst_h {{
            display: inline-block;
            width: 45%;
        }}
        div.lst_s {{
            display: inline-block;
            width: 45%;
        }}
        div.text_block {{
            background:#888888;
        }}
        p.text_block {{
            background:{background_text_block};
            font-size:{font_size_p}px;
        }}
        mark.company {{
            background:{background_company};
            color:{foreground_company};
            font-size:{font_size_company}px;
        }}
        mark.due_date {{
            background:{background_company};
            color:{foreground_due_date};
            font-size:{font_size_due_date}px;
        }}
        mark.emp_name {{
            background:{background_company};
            color:{foreground_emp_name};
            font-size:{font_size_emp_name}px;
        }}
        mark.boss_name {{
            background:{background_company};
            color:{foreground_boss_name};
            font-size:{font_size_boss}px;
        }}
        input.signature {{
            font-family:{signature_font};
        }}
        div.signature_block {{
            display: flex;
        }}
        {rem_styles}
        {signature_css}
        {it_css}      
    </style>
</head>

<body>

    <h1>
        New Hire Request for Hardware
    </h1>
    
    <div class="text_block">
        <p class="text_block">
            New employee
            <mark class="emp_name">{new_emp_name}</mark>, will be starting
            <mark class="due_date">{new_start_date}</mark> at
            <mark class="company">{new_company}</mark>.
        </p>
        <p class="text_block">
            They will be reporting to <mark class="boss_name">{new_boss}</mark>.
        </p>
        <p class="text_block">
            They will require the following Hardware and Software prepared and installed:
        </p>
    </div>

    <div class="lists">
        {new_hardware_list}
        {new_software_list}
    </div>

    <div class="text_block">
        <h4>Comments</h4>
        <p class="text_block">
            {new_comments}.
        </p>
    </div>

    <div class="signature_block">
        {signature_html}
    </div>

    <div class="it_section_block">
        {it_sign_off}
    </div>

</body>

</html>""",
                "flags": {
                    "auto": {
                        True: [
                            "-odbc",
                            "-outlook",
                            "-outlook_archive",
                            "-g_drive",
                            "-u_drive"
                        ]
                    },
                    "other": []
                }
            },
            "New Position for Existing Employee": {},
            "Employee Departure": {},
            "Installations": {},
            "Removals": {},
            "Traveling / Sick Day Lending": {},
            "License Renewals": {},
            "Other": {}
        }
        self.list_of_computers = [
            "Laptop",
            "Desktop",
            "Printer",
            "Mobile Phone",
            "Landline",
            "tablet"
        ]
        self.list_of_companies = [
            "BWS",
            "Stargate",
            "Lewis",
            "Hugo"
        ]

        # Begin factories #

        self.tv_label_auto_desc_text, \
        self.label_auto_desc_text, \
        self.tv_auto_desc_text, \
        self.auto_desc_text, \
            = text_factory(
            self.frame_auto_reports,
            tv_label="Auto-Generated Objective:",
            tv_text="Please select an objective from above.",
            kwargs_text={
                "width": 100
            }
        )

        self.tv_label_objective_choice, \
        self.label_objective_choice, \
        self.tv_objective_choice, \
        self.combo_objective_choice = \
            combo_factory(
                self.frame_top_controls_b,
                tv_label=self.tv_label_objective_choice,
                tv_combo=self.tv_objective_choice,
                kwargs_combo={
                    "justify": tkinter.CENTER,
                    "values": list(self.list_of_objectives.keys()),
                    "width": 50
                }
            )

        self.tv_label_entry_user_name, \
        self.label_entry_user_name, \
        self.tv_entry_user_name, \
        self.entry_user_name = \
            entry_factory(
                self.frame_top_controls_b,
                tv_label="Username:",
                tv_entry=get_windows_user(),
                # tv_text=os.environ.get('USERNAME'),
                kwargs_entry={
                    "justify": tkinter.CENTER,
                    "state": "disabled",
                    "width": 30
                }
            )

        self.tv_label_comp_choice, \
        self.label_comp_choice, \
        self.tv_comp_choice, \
        self.combo_comp_choice = \
            combo_factory(
                self.frame_comp_choice,
                tv_label=self.tv_label_comp_choice,
                tv_combo=self.tv_comp_choice,
                kwargs_combo={
                    "justify": tkinter.CENTER,
                    "values": self.list_of_computers
                }
            )

        self.tv_label_company_choice, \
        self.label_company_choice, \
        self.tv_company_choice, \
        self.combo_company_choice = \
            combo_factory(
                self.frame_top_controls_b,
                tv_label=self.tv_label_company_choice,
                tv_combo=self.tv_company_choice,
                kwargs_combo={
                    "justify": tkinter.CENTER,
                    "values": self.list_of_companies
                }
            )
        self.init_colour_combo_company()

        self.tv_label_odp, self.label_odp = \
            label_factory(
                self.frame_top_controls_b,
                tv_label="Due Date:"
            )

        self.tv_button_submit_form, \
        self.button_submit_form \
            = button_factory(
            self.frame_top_controls_d,
            tv_btn="Submit Form",
            kwargs_btn={
                "command": self.click_submit_form
            }
        )

        # End factories #

        # Begin Other Control Widgets #

        self.tb_allow_hardware = ToggleButton(
            self.frame_hardware,
            label_text="Hardware:",
            labels=None,
            state=False,
            auto_grid=True
        )

        self.tb_allow_software = ToggleButton(
            self.frame_software,
            label_text="Software:",
            labels=None,
            state=False,
            auto_grid=True
        )

        self.odp = OrbitingDatePicker(self.frame_top_controls_b, date_format=self.default_data["odp_date_format"])

        sql = """
            SELECT
                [ITR Customers].[Name]
                , [ITR Customers].[Company]
                , [Dept].[Dept] AS [Department]
            FROM
                [ITR Customers]
            INNER JOIN
                [Dept]
            ON
                [ITR Customers].[Department] = [Dept].[DeptID]
            WHERE
                [Active] = 1
            ORDER BY
                [Name]
        """
        self.df_itr_customers = connect(sql=sql, server="server3", database="BWSdb", uid="user5", pwd="M@gic456")
        self.df_itr_departments = self.df_itr_customers["Department"].unique()
        self.df_itr_companies = self.df_itr_customers["Company"].unique()
        self.df_itr_employees = self.df_itr_customers["Name"].unique()
        # self.tv_label_mc_emp_selection, self.label_mc_emp_selection = label_factory(
        #     self.frame_top_controls_a_a,
        #     tv_label="Who is this for?"
        # )
        self.tb_same_user_as_for = ToggleButton(
            self.frame_top_controls_a,
            label_text="Who is this for?",
            state=True,
            labels=("Me", ""),
            auto_grid=True
        )
        self.mc_emp_selection = MultiComboBox(
            self.frame_top_controls_a,
            data=self.df_itr_customers,
            viewable_column_names=[
                "Name",
                "Company",
                "Department"
            ],
            indexable_column="Name",
            # tv_label="Who is this for?",
            limit_to_list=False,
            lock_result_col="Name",
            auto_grid=False
        )
        self.mc_emp_selection.res_tv_entry.set(self.tv_entry_user_name.get())

        self.tb_same_user_as_follow_up = ToggleButton(
            self.frame_top_controls_c,
            label_text="Follow up with you?",
            state=True,
            labels=None,
            auto_grid=True
        )
        self.mc_follow_up_selection = MultiComboBox(
            self.frame_top_controls_c,
            data=self.df_itr_customers,
            viewable_column_names=[
                "Name",
                "Company",
                "Department"
            ],
            indexable_column="Name",
            # tv_label="Who is this for?",
            limit_to_list=False,
            lock_result_col="Name",
            auto_grid=False
        )
        self.mc_follow_up_selection.res_tv_entry.set(self.tv_entry_user_name.get())

        self.tv_btn_open_tl_comments, \
        self.btn_open_tl_comments \
            = button_factory(
            self.frame_top_controls_b,
            tv_btn="Edit Comments",
            kwargs_btn={
                "command": self.click_open_comments
            }
        )
        self.tl_comments_input = None
        self.tl_frame_comments_btns = None
        self.tl_tv_label_text_comments = None
        self.tl_label_text_comments = None
        self.tl_tv_text_comments = tkinter.StringVar(self, value="", name="tv_comments")
        self.tl_text_comments = None
        self.tl_tv_btn_submit_comment = None
        self.tl_btn_submit_comment = None
        self.tl_tv_btn_cancel_comment = None
        self.tl_btn_cancel_comment = None
        self.tl_tv_btn_clear_comment = None
        self.tl_btn_clear_comment = None
        self.tl_tv_btn_undo_comment = None
        self.tl_btn_undo_comment = None

        self.tl_frame_new_emp_name_btns = None
        self.tl_tv_text_new_emp_name = tkinter.StringVar(self, value="", name="tv_new_emp_name")
        self.tl_tv_btn_submit_new_emp_name = None
        self.tl_btn_submit_new_emp_name = None
        self.tl_tv_btn_cancel_new_emp_name = None
        self.tl_btn_cancel_new_emp_name = None
        self.tl_tv_btn_clear_new_emp_name = None
        self.tl_btn_clear_new_emp_name = None
        self.tl_tv_btn_undo_new_emp_name = None
        self.tl_btn_undo_new_emp_name = None
        self.tl_new_emp_name_input = None
        self.tl_tv_label_new_emp_name = None
        self.tl_new_emp_name = None
        self.tl_label_new_emp_name = None
        self.tl_tv_new_emp_name = None

        # End Other Control Widgets #

        r, c, rs, cs, ix, iy, x, y, s = self.grid_keys()

        # Begin Software #

        self.questions_software = [
            ("Outlook Email", None, tkinter.StringVar(self, name="outlook")),
            ("Outlook Archive", None, tkinter.StringVar(self, name="outlook")),
            ("Access", d, tkinter.StringVar(self, name="access")),
            ("ODBC", None, tkinter.StringVar(self, name="odbc")),
            ("G-Drive (Public)", None, tkinter.StringVar(self, name="g_drive")),
            ("U-Drive (Private)", None, tkinter.StringVar(self, name="u_drive")),
            ("Syspro8", None, tkinter.StringVar(self, name="syspro8")),
            ("ShopClock", None, tkinter.StringVar(self, name="shopclock")),
            ("SolidWorks", None, tkinter.StringVar(self, name="solidworks")),
            ("Inventor", None, tkinter.StringVar(self, name="inventor")),
            ("SGVault", None, tkinter.StringVar(self, name="sgvault"))
        ]
        self.questions_software = {
            k.lower().replace("(", "").replace(")", ""): dict(zip(["text", "follow_up", "var"], [k, f, v])) for
            k, f, v in self.questions_software}

        for j, q_title_q_data in enumerate(self.questions_software.items()):
            q_title, q_data = q_title_q_data
            q_text, q_follow_up, q_var = list(q_data.values())
            follow_up_style = None if q_follow_up is None else (
                q_follow_up if not isinstance(q_follow_up, tuple) else q_follow_up[0])
            if follow_up_style == q:
                style, data = q_follow_up
            # elif follow_up_style == w:
            #     style, data = q_follow_up if q_follow_up
            else:
                style, data = (w, (None, None))

            print(f"\n{follow_up_style=}, {style=}, {data=}")

            if follow_up_style == w:
                print(f"WIREDLESS  {q_text=}")
                tb, label_data, \
                frame_canvas, \
                btn_data = \
                    ToggleButtonWiredLess(
                        self.frame_software_toggle_buttons,
                        label_text=q_text,
                        labels=None,
                        width_label=20,
                        width_canvas=50,
                        height_canvas=30,
                        auto_grid=False
                    ).get_objects()
                quantity_data = None, None, None
            else:
                print(f"QUANTITY  {q_text=}")
                tb, label_data, \
                frame_canvas, btn_data, \
                quantity_data = \
                    ToggleButtonQuantity(
                        self.frame_software_toggle_buttons,
                        label_text=q_text,
                        labels=None,
                        start_val=data[0],
                        stop_val=data[1],
                        width_label=20,
                        width_canvas=50,
                        height_canvas=30,
                        auto_grid=False
                    ).get_objects()

            tv_label, label = label_data
            var, canvas = btn_data
            q_var, label_scale, scale = quantity_data
            self.questions_software[q_title].update({
                "tb": tb,
                "tv_label": tv_label,
                "label": label,
                "var": var,
                "frame_canvas": frame_canvas,
                "canvas": canvas,
                "q_var": q_var,
                "scale": scale,
                "showing": True,
                "grid_args": {
                    "label": {r: 0, c: 0, cs: 1, rs: 1},
                    "canvas": {r: 0, c: 1, cs: 1, rs: 1},
                    "frame_canvas": {r: 0, c: 1, cs: 1, rs: 1},
                    "tb": {r: j, c: 0, cs: 1, rs: 1}
                }
            })

            tb.grid(**self.questions_software[q_title]["grid_args"]["tb"])
            canvas.grid(**self.questions_software[q_title]["grid_args"]["canvas"])
            frame_canvas.grid(**self.questions_software[q_title]["grid_args"]["frame_canvas"])
            label.grid(**self.questions_software[q_title]["grid_args"]["label"])

            if q_follow_up is not None:
                if style == q:
                    var.trace_variable("w", tb.show_question)
                if style == w:
                    var.trace_variable("w", tb.show_question)

            # label.grid(row=0, column=0, columnspan=1, rowspan=1)
            # canvas.grid(row=0, column=1, columnspan=1, rowspan=1)
            # frame_canvas.grid(row=0, column=1, columnspan=1, rowspan=1)
            # tb.grid()

        # End Software #

        # Begin Hardware #

        self.questions_hardware = [
            ("Extra Charger(s)", None, tkinter.StringVar(self, name="extra_chargers")),
            ("Monitor(s)", (q, (1, 3)), tkinter.StringVar(self, name="monitors")),
            # ("Peripheral Cable(s)", None, tkinter.StringVar(win, name="peripheral_cables")),
            ("Dock", None, tkinter.StringVar(self, name="dock")),
            ("Keyboard", w, tkinter.StringVar(self, name="keyboard")),
            ("Mouse", w, tkinter.StringVar(self, name="mouse")),
            ("Mouse pad", None, tkinter.StringVar(self, name="mouse_pad")),
            ("Camera", None, tkinter.StringVar(self, name="camera")),
            ("Microphone", None, tkinter.StringVar(self, name="microphone"))
        ]
        self.questions_hardware = {
            k.lower().replace("(", "").replace(")", ""): dict(zip(["text", "follow_up", "var"], [k, f, v])) for
            k, f, v in self.questions_hardware}

        for j, q_title_q_data in enumerate(self.questions_hardware.items()):
            q_title, q_data = q_title_q_data
            q_text, q_follow_up, q_var = list(q_data.values())
            follow_up_style = None if q_follow_up is None else (
                q_follow_up if not isinstance(q_follow_up, tuple) else q_follow_up[0])
            if follow_up_style == q:
                style, data = q_follow_up
            # elif follow_up_style == w:
            #     style, data = q_follow_up if q_follow_up
            else:
                style, data = (w, (None, None))

            print(f"\n{follow_up_style=}, {style=}, {data=}")

            if follow_up_style == w:
                print(f"WIREDLESS  {q_text=}")
                tb, label_data, \
                frame_canvas, \
                btn_data = \
                    ToggleButtonWiredLess(
                        self.frame_hardware_toggle_buttons,
                        label_text=q_text,
                        labels=None,
                        width_label=20,
                        width_canvas=50,
                        height_canvas=30,
                        auto_grid=False
                    ).get_objects()
                quantity_data = None, None, None
            else:
                print(f"QUANTITY  {q_text=}")
                tb, label_data, \
                frame_canvas, btn_data, \
                quantity_data = \
                    ToggleButtonQuantity(
                        self.frame_hardware_toggle_buttons,
                        label_text=q_text,
                        labels=None,
                        start_val=data[0],
                        stop_val=data[1],
                        width_label=20,
                        width_canvas=50,
                        height_canvas=30,
                        auto_grid=False
                    ).get_objects()

            tv_label, label = label_data
            var, canvas = btn_data
            q_var, label_scale, scale = quantity_data
            self.questions_hardware[q_title].update({
                "tb": tb,
                "tv_label": tv_label,
                "label": label,
                "var": var,
                "frame_canvas": frame_canvas,
                "canvas": canvas,
                "q_var": q_var,
                "scale": scale,
                "showing": True,
                "grid_args": {
                    "label": {r: 0, c: 0, cs: 1, rs: 1},
                    "canvas": {r: 0, c: 1, cs: 1, rs: 1},
                    "frame_canvas": {r: 0, c: 1, cs: 1, rs: 1},
                    "tb": {r: j, c: 0, cs: 1, rs: 1}
                }
            })

            # do not automatically grid the hardware toggles.
            # rely on the update_comp_choice function to add or remove them.
            # tb.grid(**self.questions_hardware[q_title]["grid_args"]["tb"])
            # canvas.grid(**self.questions_hardware[q_title]["grid_args"]["canvas"])
            # frame_canvas.grid(**self.questions_hardware[q_title]["grid_args"]["frame_canvas"])
            # label.grid(**self.questions_hardware[q_title]["grid_args"]["label"])

            if q_follow_up is not None:
                if style == q:
                    var.trace_variable("w", tb.show_question)
                if style == w:
                    var.trace_variable("w", tb.show_question)
            # canvas.grid(row=0, column=1, columnspan=1, rowspan=1)
            # .grid(row=0, column=1, columnspan=1, rowspan=1)

        print(f"{dict_print(self.questions_hardware, 'Hardware')}")
        print(f"{dict_print(self.questions_software, 'Software')}")

        # ================================================================
        # ===================        Griding       =======================
        # ================================================================

        ipad_x_1, ipad_y_1 = 0, 0
        self.grid_args = {

            # self
            "frame_top_controls": {r: 0, c: 0, cs: 3, ix: ipad_x_1, iy: ipad_y_1},
            "frame_hardware": {r: 1, c: 0, ix: ipad_x_1, iy: ipad_y_1},
            "frame_software": {r: 1, c: 1, ix: ipad_x_1, iy: ipad_y_1},
            "frame_auto_reports": {r: 2, c: 0, rs: 1, cs: 3, ix: ipad_x_1, iy: ipad_y_1, s: "nswe"},

            # frame_top_controls
            "frame_top_controls_a": {r: 0, c: 0, rs: 1, cs: 1, ix: ipad_x_1, iy: ipad_y_1},
            "frame_top_controls_b": {r: 0, c: 1, rs: 1, cs: 1, ix: ipad_x_1, iy: ipad_y_1},
            "frame_top_controls_c": {r: 0, c: 2, rs: 1, cs: 1, ix: ipad_x_1, iy: ipad_y_1},
            "frame_top_controls_d": {r: 0, c: 3, rs: 1, cs: 1, ix: ipad_x_1, iy: ipad_y_1},

            # frame_top_controls_a
            # "frame_top_controls_a_a": {r: 0, c: 0},
            "mc_emp_selection": {r: 1, c: 0, rs: 1, cs: 1},
            #
            # # frame_top_controls_a_a
            # "label_mc_emp_selection": {r: 0, c: 0, rs: 1, cs: 1},

            # frame_top_controls_b
            "label_entry_user_name": {r: 0, c: 0, rs: 1, cs: 1, ix: ipad_x_1, iy: ipad_y_1},
            "entry_user_name": {r: 0, c: 1, rs: 1, cs: 1, ix: ipad_x_1, iy: ipad_y_1},
            "label_objective_choice": {r: 1, c: 0, ix: ipad_x_1, iy: ipad_y_1},
            "combo_objective_choice": {r: 1, c: 1, ix: ipad_x_1, iy: ipad_y_1},
            "label_company_choice": {r: 2, c: 0, ix: ipad_x_1, iy: ipad_y_1},
            "combo_company_choice": {r: 2, c: 1, ix: ipad_x_1, iy: ipad_y_1},
            "label_odp": {r: 3, c: 0, ix: ipad_x_1, iy: ipad_y_1},
            "odp": {r: 3, c: 1, ix: ipad_x_1, iy: ipad_y_1},
            "btn_open_tl_comments": {r: 4, c: 1, ix: ipad_x_1, iy: ipad_y_1},

            # frame_top_controls_c
            # "frame_top_controls_a_a": {r: 0, c: 0},
            "mc_follow_up_selection": {r: 1, c: 0, rs: 1, cs: 1},

            # frame_top_controls_d
            "button_submit_form": {r: 0, c: 0, ix: ipad_x_1, iy: ipad_y_1, cs: 1, rs: 1},

            # frame_hardware
            "frame_comp_choice": {r: 1, c: 0, ix: ipad_x_1, iy: ipad_y_1},
            "frame_hardware_toggle_buttons": {r: 2, c: 0, ix: ipad_x_1, iy: ipad_y_1},

            # frame_software
            "frame_software_toggle_buttons": {r: 2, c: 0, ix: ipad_x_1, iy: ipad_y_1},

            # frame_comp_choice
            "label_comp_choice": {r: 2, c: 0, ix: ipad_x_1, iy: ipad_y_1},
            "combo_comp_choice": {r: 2, c: 1, ix: ipad_x_1, iy: ipad_y_1},

            # frame_auto_reports
            "label_auto_desc_text": {r: 0, c: 0, rs: 1, cs: 3, ix: ipad_x_1, iy: ipad_y_1},
            "auto_desc_text": {r: 1, c: 0, rs: 1, cs: 3, ix: ipad_x_1, iy: ipad_y_1, s: "nswe"}
        }

        self.init_grid = {
            "frame_top_controls",
            "frame_hardware",
            "frame_software",
            "frame_auto_reports",
            "frame_top_controls_a",
            "frame_top_controls_b",
            "frame_top_controls_c",
            "frame_top_controls_d",
            # "frame_top_controls_a_a",
            "label_auto_desc_text",
            "auto_desc_text",
            "mc_emp_selection",
            "mc_follow_up_selection",
            # "label_mc_emp_selection",
            "label_entry_user_name",
            "entry_user_name",
            "label_objective_choice",
            "combo_objective_choice",
            "label_company_choice",
            "combo_company_choice",
            "label_odp",
            "odp",
            "btn_open_tl_comments",
            "label_comp_choice",
            "combo_comp_choice",
            "button_submit_form"
        }

        for k in self.init_grid:
            v = self.grid_args[k]
            eval(f"self.{k}.grid(**{v})")

        # self.tb_allow_hardware.grid_widgets()
        # self.tb_allow_software.grid_widgets()
        # self.tb_same_user_as_for.grid_widgets()
        # self.tb_same_user_as_follow_up.grid_widgets()

        # for k, v in self.grid_args.items():
        #     eval(f"self.{k}.grid(**{v})")

        # self.mc_emp_selection.grid(**self.grid_args["mc_emp_selection"])
        #
        # self.label_entry_user_name.grid(**self.grid_args["label_entry_user_name"])
        # self.entry_user_name.grid(**self.grid_args["entry_user_name"])
        # self.label_objective_choice.grid(**self.grid_args["label_objective_choice"])
        # self.combo_objective_choice.grid(**self.grid_args["combo_objective_choice"])
        # self.label_company_choice.grid(**self.grid_args["label_company_choice"])
        # self.combo_company_choice.grid(**self.grid_args["combo_company_choice"])
        # self.label_comp_choice.grid(**self.grid_args["label_company_choice"])
        # self.combo_comp_choice.grid(**self.grid_args["combo_company_choice"])
        # self.label_odp.grid(**self.grid_args["label_odp"])
        # self.odp.grid(**self.grid_args["odp"])
        # self.frame_auto_reports.grid(**self.grid_args["frame_auto_reports"])
        # self.label_auto_desc_text.grid(**self.grid_args["label_auto_desc_text"])
        # self.auto_desc_text.grid(**self.grid_args["auto_desc_text"])

        # tb, label_data, canvas_frame, canvas_data = self.tb_allow_hardware.get_objects()
        # tb.grid(row=0, column=0)
        # label_data[1].grid(row=0, column=0)
        # canvas_frame.grid(row=0, column=1)
        # canvas_data[1].grid(row=0, column=0)
        # tb, label_data, canvas_frame, canvas_data = self.tb_allow_software.get_objects()
        # tb.grid(row=0, column=0)
        # label_data[1].grid(row=0, column=0)
        # canvas_frame.grid(row=0, column=1)
        # canvas_data[1].grid(row=0, column=0)
        # tb, label_data, canvas_frame, canvas_data = self.tb_same_user_as_for.get_objects()
        # tb.grid(row=0, column=0)
        # label_data[1].grid(row=0, column=0)
        # canvas_frame.grid(row=0, column=1)
        # canvas_data[1].grid(row=0, column=0)
        # tb, label_data, canvas_frame, canvas_data = self.tb_same_user_as_follow_up.get_objects()
        # tb.grid(row=0, column=0)
        # label_data[1].grid(row=0, column=0)
        # canvas_frame.grid(row=0, column=1)
        # canvas_data[1].grid(row=0, column=0)

        # self.label_mc_emp_selection.grid(**self.grid_args["label_mc_emp_selection"])
        #
        # self.frame_top_controls.grid(**self.grid_args["frame_top_controls"])
        # self.frame_top_controls_a.grid(**self.grid_args["frame_top_controls_a"])
        # self.frame_top_controls_a_a.grid(**self.grid_args["frame_top_controls_a_a"])
        # self.frame_top_controls_b.grid(**self.grid_args["frame_top_controls_b"])

        # self.frame_hardware.grid(**self.grid_args["frame_hardware"])
        # self.frame_software.grid(**self.grid_args["frame_software"])
        # self.frame_comp_choice.grid(**self.grid_args["frame_comp_choice"])
        # self.frame_hardware_toggle_buttons.grid(**self.grid_args["frame_hardware_toggle_buttons"])

        # End Griding #

        # Begin Traces #

        self.tb_same_user_as_for.state.trace_variable("w", self.update_who_for_me)
        self.tb_same_user_as_follow_up.state.trace_variable("w", self.update_follow_up_me)
        self.tv_comp_choice.trace_variable("w", self.update_comp_choice)
        self.tv_company_choice.trace_variable("w", self.update_company_choice)
        self.odp.date_var.trace_variable("w", self.update_due_date)
        self.tv_objective_choice.trace_variable("w", self.update_objective)
        self.tb_allow_hardware.state.trace_variable("w", self.update_allow_hardware)
        self.tb_allow_software.state.trace_variable("w", self.update_allow_software)
        self.mc_emp_selection.res_tv_entry.trace_variable("w", self.update_who_for_selection)

        # End Traces #

        # Begin Configurations #

        self.frame_top_controls.columnconfigure([0, 1, 2], minsize=450)
        self.frame_top_controls.rowconfigure([0], minsize=150)

        # End Configurations #

    def init_style_keys(self):

        # normal ODP date foreground
        self.style.configure(
            self.style_key_odp_normal,
            fieldforeground=self.colour_schemes["foreground_valid_date"],
            foreground=self.colour_schemes["foreground_valid_date"]
        )

        # invalid ODP date foreground
        self.style.configure(
            self.style_key_odp_invalid,
            fieldforeground=self.colour_schemes["foreground_invalid_date"],
            foreground=self.colour_schemes["foreground_invalid_date"]
        )

    def init_colour_combo_company(self):
        """Use this to initially set the colours of the company combo."""
        print(f"init_colour_combo_company")
        company = self.tv_company_choice.get()
        background, foreground = self.company_colours(company)
        self.combo_company_choice.configure(background=background, foreground=foreground)

    def na_if_none(self, val):
        if (val is None) or (not val and (
                isinstance(val, str) or isinstance(val, list) or isinstance(val, tuple) or isinstance(val, dict))):
            return self.default_data["no_comment"]
        return val

    def update_objective(self, *args, do_flags=True):
        val = self.tv_objective_choice.get()
        if val in self.list_of_objectives:
            print(f"{val=}\n{self.list_of_objectives[val]=}")
            obj = self.list_of_objectives[val]["obj"]
            data = self.form_data(val, do_flags=do_flags)

            if val == "New Employee Hire":
                kwargs = {
                    "new_emp_name": data["new_emp_name"],
                    "new_start_date": data["new_due_date"],
                    "new_company": data["new_company"],
                    "new_boss": data["new_boss"],
                    "new_hardware": data["new_hardware"],
                    "new_software": data["new_software"],
                    "new_user_name": data["new_user_name"],
                    "new_follow_up": data["new_follow_up"],
                    "new_comments": data["new_comments"]
                }

                # msg = re.sub("\s+", ' ', obj.format(**kwargs))
                msg = obj.format(**kwargs)
                print(f"\n\tResult\n{msg}\n")

                self.tv_auto_desc_text.set(msg)
            else:
                raise ValueError(f"Error, right now this objective is not supported: obj='{val}'.")

        else:
            # New objective
            pass
        print(f"objective='{val}'")

    def get_frame_hardware_toggles(self):
        result = []
        print(f"BEGIN get_frame_hardware_toggles: {result}")
        for q in self.questions_hardware:
            tb = self.questions_hardware[q]["tb"]
            print(f"{q=}, {tb=}, {tb.state.get()=}")
            if tb.state.get():
                result.append(q)
        print(f"END get_frame_hardware_toggles: {result}")
        return result

    def get_frame_software_toggles(self):
        result = []
        print(f"BEGIN get_frame_software_toggles: {result}")
        for q in self.questions_software:
            tb = self.questions_software[q]["tb"]
            print(f"{q=}, {tb=}, {tb.state.get()=}")
            if tb.state.get():
                result.append(q)
        print(f"END get_frame_software_toggles: {result}")
        return result

    def update_follow_up_me(self, *args):
        val = self.tb_same_user_as_follow_up.state.get()
        if val:
            self.mc_follow_up_selection.grid_forget()
            self.mc_follow_up_selection.res_tv_entry.set(self.tv_entry_user_name.get())
            self.update_objective(args, do_flags=False)
        else:
            self.mc_follow_up_selection.grid_widget()
            self.mc_follow_up_selection.grid(**self.grid_args["mc_follow_up_selection"])

    def update_who_for_selection(self, *args):
        """Called as a trace when the multi-combobox, 'Who is this for?', value is changed."""
        self.update_objective(args, do_flags=False)

    def update_who_for_me(self, *args):
        """Called as a trace when the toggle button, 'Who is this for?', is changed."""
        val = self.tb_same_user_as_for.state.get()
        if val:
            self.mc_emp_selection.grid_forget()
            self.mc_emp_selection.res_tv_entry.set(self.tv_entry_user_name.get())
            self.update_objective(args, do_flags=False)
        else:
            self.mc_emp_selection.grid_widget()
            self.mc_emp_selection.grid(**self.grid_args["mc_emp_selection"])

    def update_company_choice(self, *args):
        print(f"update_company_choice")
        self.update_objective(args, do_flags=False)
        company = self.tv_company_choice.get()
        # background, foreground = self.company_colours(company)
        # print(f"{background=}, {foreground=}")
        # self.combo_company_choice.configure(background=background, foreground=foreground)


    def update_due_date(self, *args):
        self.update_objective(args, do_flags=False)
        date = datetime.datetime.fromisoformat(self.odp.date_var.get()).date()
        if date < datetime.datetime.now().date():
            style_key = self.style_key_odp_invalid
            colour = self.colour_schemes["foreground_invalid_date"]
        else:
            style_key = self.style_key_odp_normal
            # colour = "black"
        print(f"date='{date}', '{style_key}'")
        # self.odp.dateentry_entry.configure(fieldforeground=colour)

        self.odp.dateentry_entry.configure(style=style_key)
        # TODO fix this colouring for invalid dates.

    def update_comp_choice(self, *args):
        val = self.tv_comp_choice.get()

        if val == "New Employee Hire":
            self.ask_new_emp_name()

        if val not in self.list_of_computers[:2]:
            for k in self.questions_hardware:
                # self.questions_hardware[k]["showing"] = False
                self.questions_hardware[k]["tb"].grid_forget()
                self.questions_hardware[k]["label"].grid_forget()
                self.questions_hardware[k]["canvas"].grid_forget()
                self.questions_hardware[k]["frame_canvas"].grid_forget()
        else:

            for k in self.questions_hardware:
                # if self.questions_hardware[k]["showing"]:
                self.questions_hardware[k]["tb"].grid(**self.questions_hardware[k]["grid_args"]["tb"])
                self.questions_hardware[k]["label"].grid(**self.questions_hardware[k]["grid_args"]["label"])
                self.questions_hardware[k]["canvas"].grid(**self.questions_hardware[k]["grid_args"]["canvas"])
                self.questions_hardware[k]["frame_canvas"].grid(
                    **self.questions_hardware[k]["grid_args"]["frame_canvas"])

            show_chargers = True
            showing_chargers = self.questions_hardware["extra chargers"]["showing"]
            match val:
                case "Desktop":
                    # hide charger + dock question for desktop users
                    show_chargers = False

            if show_chargers:
                if not showing_chargers:
                    # self.questions_hardware["extra chargers"]["tb"].grid_widgets()
                    self.questions_hardware["extra chargers"]["tb"].grid(
                        **self.questions_hardware["extra chargers"]["grid_args"]["tb"])
                    self.questions_hardware["extra chargers"]["showing"] = True

                    self.questions_hardware["dock"]["tb"].grid(**self.questions_hardware["dock"]["grid_args"]["tb"])
                    self.questions_hardware["dock"]["showing"] = True
            else:
                if showing_chargers:
                    self.questions_hardware["extra chargers"]["tb"].grid_forget()
                    self.questions_hardware["extra chargers"]["showing"] = False

                    self.questions_hardware["dock"]["tb"].grid_forget()
                    self.questions_hardware["dock"]["showing"] = False

            self.frame_hardware_toggle_buttons.grid(**self.grid_args["frame_hardware_toggle_buttons"])

        self.update_objective(args, do_flags=False)

    def update_allow_hardware(self, *args):
        """When hardware switch is clicked, update showing section"""
        allow = self.tb_allow_hardware.state.get()
        if allow:
            self.show_hardware_section()
        else:
            self.hide_hardware_section()

    def update_allow_software(self, *args):
        """When software switch is clicked, update showing section"""
        allow = self.tb_allow_software.state.get()
        if allow:
            self.show_software_section()
        else:
            self.hide_software_section()

    def show_hardware_section(self):
        self.frame_comp_choice.grid(**self.grid_args["frame_comp_choice"])
        self.frame_hardware_toggle_buttons.grid(**self.grid_args["frame_hardware_toggle_buttons"])

    def hide_hardware_section(self):
        self.frame_comp_choice.grid_forget()
        self.frame_hardware_toggle_buttons.grid_forget()

    def show_software_section(self):
        self.frame_software_toggle_buttons.grid(**self.grid_args["frame_software_toggle_buttons"])

    def hide_software_section(self):
        self.frame_software_toggle_buttons.grid_forget()

    def ask_new_emp_name(self):
        r, c, rs, cs, ix, iy, x, y, s = self.grid_keys()
        if self.tl_new_emp_name_input is None:
            self.tl_new_emp_name_input = tkinter.Toplevel(self)
            self.tl_new_emp_name_input.title("Edit Comments")
            self.tl_frame_new_emp_name_btns = tkinter.Frame(self.tl_new_emp_name_input)
            self.tl_tv_label_new_emp_name, \
            self.tl_label_new_emp_name, \
            self.tl_tv_new_emp_name, \
            self.tl_new_emp_name \
                = text_factory(
                self.tl_new_emp_name_input,
                tv_label="Enter New Employees Name:",
                tv_text=self.tl_tv_text_new_emp_name
            )
            self.tl_tv_btn_submit_new_emp_name, \
            self.tl_btn_submit_new_emp_name \
                = button_factory(
                self.tl_frame_new_emp_name_btns,
                tv_btn="submit",
                kwargs_btn={
                    "command": self.tl_click_submit_new_emp_name
                }
            )
            self.tl_tv_btn_cancel_new_emp_name, \
            self.tl_btn_cancel_new_emp_name \
                = button_factory(
                self.tl_frame_new_emp_name_btns,
                tv_btn="cancel",
                kwargs_btn={
                    "command": self.tl_click_cancel_new_emp_name
                }
            )
            self.tl_tv_btn_clear_new_emp_name, \
            self.tl_btn_clear_new_emp_name \
                = button_factory(
                self.tl_frame_new_emp_name_btns,
                tv_btn="clear",
                kwargs_btn={
                    "command": self.tl_click_clear_new_emp_name
                }
            )
            self.tl_tv_btn_undo_new_emp_name, \
            self.tl_btn_undo_new_emp_name \
                = button_factory(
                self.tl_frame_new_emp_name_btns,
                tv_btn="undo",
                kwargs_btn={
                    "command": self.tl_click_undo_new_emp_name
                }
            )

            # print(f"TEST '{self.test_id == id(self.tl_text_comments.text)}'")

            # self.tl_label_text_comments.grid(**{r: 0, c: 0, cs: 4})
            self.tl_new_emp_name_input.grid(**{r: 1, c: 2, cs: 4})
            self.tl_frame_new_emp_name_btns.grid(**{r: 2, c: 0, cs: 4})
            self.tl_btn_submit_new_emp_name.grid(**{r: 0, c: 0})
            # self.tl_btn_undo_comment.grid(**{r: 0, c: 1})  # TODO fix the undo function.
            self.tl_btn_clear_new_emp_name.grid(**{r: 0, c: 2})
            self.tl_btn_cancel_new_emp_name.grid(**{r: 0, c: 3})

            self.tl_new_emp_name_input.protocol("WM_DELETE_WINDOW", self.tl_close_new_emp_name)
            # self.wait_window(self.tl_comments_input)
            # self.tl_comments_input.wait_window()
            self.tl_new_emp_name_input.grab_set()
        else:
            print(f"Cant open another top level before closing the previous.")

    def click_open_comments(self, *event):
        print(f"click_open_comments")
        r, c, rs, cs, ix, iy, x, y, s = self.grid_keys()
        if self.tl_comments_input is None:
            self.tl_comments_input = tkinter.Toplevel(self)
            self.tl_comments_input.title("Edit Comments")
            self.tl_frame_comments_btns = tkinter.Frame(self.tl_comments_input)
            self.tl_tv_label_text_comments, \
            self.tl_label_text_comments, \
            self.tl_tv_text_comments, \
            self.tl_text_comments \
                = text_factory(
                self.tl_comments_input,
                tv_label="Enter Comments:",
                tv_text=self.tl_tv_text_comments
            )
            self.tl_tv_btn_submit_comment, \
            self.tl_btn_submit_comment \
                = button_factory(
                self.tl_frame_comments_btns,
                tv_btn="submit",
                kwargs_btn={
                    "command": self.tl_click_submit_comments
                }
            )
            self.tl_tv_btn_cancel_comment, \
            self.tl_btn_cancel_comment \
                = button_factory(
                self.tl_frame_comments_btns,
                tv_btn="cancel",
                kwargs_btn={
                    "command": self.tl_click_cancel_comments
                }
            )
            self.tl_tv_btn_clear_comment, \
            self.tl_btn_clear_comment \
                = button_factory(
                self.tl_frame_comments_btns,
                tv_btn="clear",
                kwargs_btn={
                    "command": self.tl_click_clear_comments
                }
            )
            self.tl_tv_btn_undo_comment, \
            self.tl_btn_undo_comment \
                = button_factory(
                self.tl_frame_comments_btns,
                tv_btn="undo",
                kwargs_btn={
                    "command": self.tl_click_undo_comments
                }
            )

            # print(f"TEST '{self.test_id == id(self.tl_text_comments.text)}'")

            # self.tl_label_text_comments.grid(**{r: 0, c: 0, cs: 4})
            self.tl_text_comments.grid(**{r: 1, c: 2, cs: 4})
            self.tl_frame_comments_btns.grid(**{r: 2, c: 0, cs: 4})
            self.tl_btn_submit_comment.grid(**{r: 0, c: 0})
            # self.tl_btn_undo_comment.grid(**{r: 0, c: 1})  # TODO fix the undo function.
            self.tl_btn_clear_comment.grid(**{r: 0, c: 2})
            self.tl_btn_cancel_comment.grid(**{r: 0, c: 3})

            self.tl_comments_input.protocol("WM_DELETE_WINDOW", self.tl_close_comments)
            # self.wait_window(self.tl_comments_input)
            # self.tl_comments_input.wait_window()
            self.tl_comments_input.grab_set()
        else:
            print(f"Cant open another top level before closing the previous.")

    def tl_close_comments(self, *event):
        print(f"close_tl_comments")
        self.tl_comments_input.destroy()
        self.tl_comments_input = None

    def tl_click_submit_comments(self, *event):
        print(f"click_submit_comments")
        self.tl_close_comments(event)

    def tl_click_cancel_comments(self, *event):
        print(f"click_cancel_comments")
        if messagebox.askokcancel("Quit?", "Are you sure you want to exit without saving?"):
            self.tl_close_comments(event)

    def tl_click_clear_comments(self, *event):
        print(f"click_clear_comments")
        self.tl_tv_text_comments.set("")

    def tl_click_undo_comments(self, *event):
        print(f"click_undo_comments")
        self.tl_text_comments.undo()

    def tl_close_new_emp_name(self, *event):
        print(f"close_tl_new_emp_name")
        self.tl_new_emp_name_input.destroy()
        self.tl_new_emp_name_input = None

    def tl_click_submit_new_emp_name(self, *event):
        print(f"tl_click_submit_new_emp_name")

    def tl_click_cancel_new_emp_name(self, *event):
        print(f"tl_click_cancel_new_emp_name")

    def tl_click_clear_new_emp_name(self, *event):
        print(f"tl_click_clear_new_emp_name")

    def tl_click_undo_new_emp_name(self, *event):
        print(f"tl_click_undo_new_emp_name")

    def flag_open_software(self):
        """Call this whenever an internal software switch needs to be shown.
        Ensures that toggle_buttons_frame is visible"""
        if not self.tb_allow_software.state.get():
            self.tb_allow_software.click()

    def flag_open_hardware(self):
        """Call this whenever an internal hardware switch needs to be shown.
        Ensures that toggle_buttons_frame is visible"""
        if not self.tb_allow_hardware.state.get():
            self.tb_allow_hardware.click()

    def flag_odbc(self, state=None):
        # set odbc flag
        self.flag_helper("software", "odbc", state)

    def flag_outlook(self, state=None):
        # set outlook flag
        self.flag_helper("software", "outlook email", state)

    def flag_outlook_archive(self, state=None):
        self.flag_helper("software", "outlook archive", state)

    def flag_g_drive(self, state=None):
        self.flag_helper("software", "g-drive public", state)

    def flag_u_drive(self, state=None):
        self.flag_helper("software", "u-drive private", state)

    def flag_helper(self, sh, k, state):
        if sh == "software":
            tb = self.questions_software[k]["tb"]
        else:
            tb = self.questions_hardware[k]["tb"]
        if state is None:
            tb.click()
            state = tb.state.get()
        else:
            s = tb.state.get()
            if state and not s:
                tb.click()
            elif not state and s:
                tb.click()
        if state:
            if sh == "software":
                self.flag_open_software()
            else:
                self.flag_open_hardware()

    def generate_user_signature(self, user_name):
        style = f"""
        input.signature {{
            border: 0;
            border-bottom: 1px solid #000;
            font-size: {self.colour_schemes['font_size_user_signature']}px;
            text-align: center;
        }}
        input.date {{
            border: 0;
            border-bottom: 1px solid #000;
            font-size: {self.colour_schemes['font_size_user_signature']}px;
            text-align: center;
        }}"""
        now = date_str_format(datetime.datetime.now(), include_weekday=True)  # .strftime(self.default_data["start_of_day_format"])
        html_ = f"<label class=\"signature_text\" for=\"user_signature\">Your Signature:</label>\n\t\t"
        html_ += f"<input type=\"text\" class=\"signature\" value=\"{user_name}\" name=\"user_signature\" size=45 disabled>"
        html_ += f"<label class=\"date_text\" for=\"user_date\">Date:</label>\n\t\t"
        html_ += f"<input type=\"text\" class=\"date\" value=\"{now}\" name=\"user_date\" size=45 disabled>"
        return style, html_

    def click_submit_form(self, *event):
        print(f"click_submit_form")
        if data := self.ready_to_submit():
            val = self.tv_objective_choice.get()
            # obj = self.list_of_objectives[val]["obj"]
            # html_ = self.list_of_objectives[val]["html"]
            obj = data["obj"]
            html_ = data["html"]

            print(f"{data=}")
            print(f"{obj}")
            print(f"{html_}")

            if val == "New Employee Hire":

                hardware_list = data["new_hardware"]
                software_list = data["new_software"]
                print(f"{hardware_list=}\n{software_list=}")
                if not (isinstance(hardware_list, list) or isinstance(hardware_list, tuple) or isinstance(hardware_list,
                                                                                                          dict)):
                    hardware_list = [hardware_list]
                if not (isinstance(software_list, list) or isinstance(software_list, tuple) or isinstance(software_list,
                                                                                                          dict)):
                    software_list = [software_list]

                e_hardware = self.empty_comment(hardware_list)
                e_software = self.empty_comment(software_list)

                # Validate any input here before generating the html and pdf forms.
                if e_hardware and not e_software:
                    if not self.ask_sure_no_hardware():
                        return
                elif e_software and not e_hardware:
                    if not self.ask_sure_no_software():
                        return
                elif e_hardware and e_software:
                    if not self.ask_sure_no_hardware_software():
                        return

                style_tag_h, list_tag_h = list_to_html(
                    hardware_list,
                    class_name="lst_h",
                    is_ordered=False,
                    wrap_style=False,
                    title="Hardware",
                    background="#6d6d6d",
                    level_in=1
                )
                style_tag_s, list_tag_s = list_to_html(
                    software_list,
                    class_name="lst_s",
                    is_ordered=False,
                    wrap_style=False,
                    title="Software",
                    background="#6d6d6d",
                    level_in=1
                )

                print(f"{list_tag_s=}\n{list_tag_h=}")

                # tag_lists = f"<div class=\"lists\">{list_tag_h}{list_tag_s}</div>"
                rem_styles = f"{style_tag_h} {style_tag_s}"

                background_company, foreground_company = self.company_colours(data["new_company"])
                foreground_due_date = foreground_company
                foreground_emp_name = foreground_company
                foreground_boss_name = foreground_company

                cs = self.colour_schemes
                print(dict_print(cs, "CS"))
                signature_css, signature_html = self.generate_user_signature(data["new_user_name"])

                it_css = self.default_data["it_css"]
                kwargs = {
                    "background_it_section": cs["background_it_section"]
                }
                print(f"it_css:\n")
                print(it_css)
                it_css = it_css.format(**kwargs)

                kwargs = {
                    "new_emp_name": data["new_emp_name"],
                    "new_start_date": data["new_due_date"],
                    "new_company": data["new_company"],
                    "new_boss": data["new_boss"],
                    "new_hardware_list": list_tag_h,
                    "new_software_list": list_tag_s,
                    "new_user_name": data["new_user_name"],
                    "new_follow_up": data["new_follow_up"],
                    "new_comments": data["new_comments"],
                    "rem_styles": rem_styles,
                    "background_company": background_company,
                    "foreground_company": foreground_company,
                    "foreground_due_date": foreground_due_date,
                    "foreground_emp_name": foreground_emp_name,
                    "foreground_boss_name": foreground_boss_name,
                    "background_text_block": cs["background_text_block"],
                    "font_size_p": cs["font_size_p"],
                    "font_size_emp_name": cs["font_size_emp_name"],
                    "font_size_due_date": cs["font_size_due_date"],
                    "font_size_company": cs["font_size_company"],
                    "font_size_boss": cs["font_size_boss"],
                    "signature_css": signature_css,
                    "signature_html": signature_html,
                    "it_sign_off": self.default_data["it_sign_off"],
                    "it_css": it_css,
                    "signature_font": cs["signature_font"]
                }

                html_ = html_.format(**kwargs)
                print(f"\n\thtml_:\n{html_}")

                fn = next_available_file_name(f"request_output.html")
                with open(fn, "w") as f:
                    f.write(html_)

                webbrowser.open(fn)

                self.commit_pdf(fn)

            else:
                raise ValueError(f"Error, objective '{val}' is not supported yet.")

    def commit_pdf(self, file_name, do_open=True):

        pdf_file_out = file_name.removesuffix(".html") + ".pdf"
        print(f"HTML file: {file_name}")
        print(f"PDF file : {pdf_file_out}")

        wkhtmltopdf_path = r"C:\Program Files\wkhtmltopdf\bin\wkhtmltopdf.exe"
        if not os.path.exists(wkhtmltopdf_path):
            print(f"Error, please install wkhtmltopdf before continuing")
            quit()
        # else:
        #     try:
        #         config = pdfkit.configuration()
        #     except OSError:
        #         # not present in path
        #         print(f"Error, wkhtmltopdf not found in path either. Please install before continuing")
        #         quit()

        options = {
            "page-size": "letter",
            "orientation": "portrait",
            'margin-top': '0.5in',
            'margin-right': '0.5in',
            'margin-bottom': '0.5in',
            'margin-left': '0.5in',
            'encoding': "UTF-8",
        }

        config = pdfkit.configuration(wkhtmltopdf=wkhtmltopdf_path)
        pdfkit.from_file(file_name, pdf_file_out, configuration=config, options=options)

        # from weasyprint import HTML
        # HTML(file_out).write_pdf(pdf_file_out)

        if do_open:
            webbrowser.open(pdf_file_out)

    def empty_comment(self, lst):
        if len(lst) == 1:
            return lst[0] == self.default_data["no_comment"]
        return False

    def form_data(self, key=None, do_flags=True):
        if key is not None:
            if key not in self.list_of_objectives:
                raise KeyError(f"Error, key '{key}' is not in the list of objectives.")

            full_obj = self.list_of_objectives[key]
            obj = full_obj["obj"]
            html_ = full_obj["html"]
            flags = full_obj["flags"]
            flags_auto = flags["auto"]
            flags_other = flags["other"]

            if do_flags:
                for k, flags_list in flags_auto.items():
                    if isinstance(k, bool):
                        # if key is True in auto-flags then ensure this is on
                        for flag in flags_list:
                            self.flags[flag](state=k)

            new_user_name = self.na_if_none(self.tv_entry_user_name.get())
            new_emp_name = self.na_if_none(self.mc_emp_selection.res_tv_entry.get())
            date = self.odp.date
            start_hour, \
            start_minute = \
                self.default_data["start_of_day_hour"], \
                self.default_data["start_of_day_minute"]
            date = datetime.datetime(date.year, date.month, date.day, start_hour, start_minute)
            date_s = date_str_format(date, include_time=True, include_weekday=True)
            new_due_date = self.na_if_none(date_s)
            new_company = self.na_if_none(self.tv_company_choice.get())
            new_hardware = self.na_if_none(self.get_frame_hardware_toggles())
            new_software = self.na_if_none(self.get_frame_software_toggles())
            new_follow_up = self.na_if_none(self.mc_follow_up_selection.res_tv_entry.get())
            new_boss = self.na_if_none(self.na_if_none(self.tv_entry_user_name.get()))

            if self.tl_text_comments is not None:
                new_comments = self.na_if_none(self.tl_text_comments.text.get())
            else:
                new_comments = self.na_if_none(None)

            data = {
                "flags": flags,
                "flags_auto": flags_auto,
                "flags_other": flags_other,
                "new_user_name": new_user_name,
                "new_emp_name": new_emp_name,
                "new_due_date": new_due_date,
                "new_follow_up": new_follow_up,
                "new_hardware": new_hardware,
                "new_software": new_software,
                "new_comments": new_comments,
                "new_company": new_company,
                "new_boss": new_boss,
                "obj": obj,
                "html": html_
            }
            print(f"{dict_print(data, 'Data')}")

            return data
        return {}

    def ready_to_submit(self):
        val = self.tv_objective_choice.get()
        data = self.form_data(val, do_flags=False)
        if all([val, *list(data.items())]):
            return data
        return {}

    def ask_sure_no_hardware(self):
        return messagebox.askokcancel(title="Are you sure?", message="Proceed with no Hardware?")

    def ask_sure_no_software(self):
        return messagebox.askokcancel(title="Are you sure?", message="Proceed with no Software?")

    def ask_sure_no_hardware_software(self):
        return messagebox.askokcancel(title="Are you sure?", message="Proceed with no Hardware or Software?")

    def company_colours(self, company_in):
        cs = self.colour_schemes
        match company_in:
            case "BWS":
                return cs["background_bws"], cs["foreground_bws"]
            case "Stargate":
                return cs["background_stg"], cs["foreground_stg"]
            case "Lewis":
                return cs["background_lew"], cs["foreground_lew"]
            case "Hugo":
                return cs["background_hug"], cs["foreground_hug"]
            case _:
                raise ValueError("Error")

    def grid_keys(self):
        return "row", "column", "rowspan", "columnspan", "ipadx", "ipady", "padx", "pady", "sticky"


def test_form():
    app = HardwareFormApp()
    app.mainloop()
    # win.geometry(f"600x600")
    #
    # q = "quantity"
    # w = "wired(less)"
    #
    # frame_comp_choice = tkinter.Frame(name="fame_comp_choice")
    # tv_label_comp_choice = tkinter.StringVar(win, value="Select Hardware:", name="tv_label_comp_choice")
    # tv_comp_choice = tkinter.StringVar(win, name="tv_comp_choice")
    #
    # tv_label_comp_choice, \
    # label_comp_choice, \
    # tv_comp_choice, \
    # combo_comp_choice = \
    #     combo_factory(
    #         frame_comp_choice,
    #         tv_label=tv_label_comp_choice,
    #         tv_combo=tv_comp_choice,
    #         kwargs_combo={
    #             "justify": tkinter.CENTER,
    #             "values": [
    #                 "Laptop",
    #                 "Desktop"
    #             ]
    #         }
    #     )
    #
    # questions_hardware = [
    #     ("Extra Charger(s)", None, tkinter.StringVar(win, name="extra_chargers")),
    #     ("Monitor(s)", (q, 3), tkinter.StringVar(win, name="monitors")),
    #     # ("Peripheral Cable(s)", None, tkinter.StringVar(win, name="peripheral_cables")),
    #     ("Dock", None, tkinter.StringVar(win, name="dock")),
    #     ("Keyboard", w, tkinter.StringVar(win, name="keyboard")),
    #     ("Mouse", w, tkinter.StringVar(win, name="mouse")),
    #     ("Mouse pad", None, tkinter.StringVar(win, name="mouse_pad")),
    #     ("Camera", None, tkinter.StringVar(win, name="camera")),
    #     ("Microphone", None, tkinter.StringVar(win, name="microphone"))
    # ]
    # questions_hardware = {k.lower().replace("(", "").replace(")", ""): dict(zip(["text", "follow_up", "var"], [k, f, v])) for
    #              k, f, v in questions_hardware}
    #
    # frame_hardware_toggle_buttons = tkinter.Frame(win, background=random_colour(rgb=False))
    # for q_title, q_data in questions_hardware.items():
    #     q_text, q_follow_up, q_var = list(q_data.values())
    #     tb, label_data, \
    #     frame_canvas, btn_data,\
    #     quantity_data = \
    #         ToggleButtonQuantity(
    #             frame_hardware_toggle_buttons,
    #             label_text=q_text,
    #             labels=None
    #             # ,
    #             # t_animation_time=100,
    #             # n_slices=1000000
    #         ).get_objects()
    #     tv_label, label = label_data
    #     var, canvas = btn_data
    #     q_var, scale = quantity_data
    #     questions_hardware[q_title].update({
    #         "button": tb,
    #         "tv_label": tv_label,
    #         "label": label,
    #         "var": var,
    #         "frame_canvas": frame_canvas,
    #         "canvas": canvas,
    #         "q_var": q_var,
    #         "scale": scale
    #     })
    #
    #     if q_follow_up is not None:
    #         if q_follow_up == q:
    #             var.trace_variable("w", tb.show_quantity)
    #
    #     label.grid(row=0, column=0)
    #     canvas.grid(row=0, column=1)
    #     frame_canvas.grid(row=0, column=1)
    #     tb.grid()
    #
    # label_comp_choice.grid(row=0, column=0, ipadx=12, ipady=12)
    # combo_comp_choice.grid(row=0, column=1, ipadx=12, ipady=12)
    # frame_comp_choice.grid()
    # frame_hardware_toggle_buttons.grid()
    #
    # # tbq = ToggleButtonQuantity(win)


def test_grid():
    app = tkinter.Tk()
    app.geometry(f"600x400")
    a = tkinter.Frame(app, name="frame_a", background="red", width=40, height=40)

    b = tkinter.Frame(app, name="frame_b", background="green", width=40, height=40)
    c = tkinter.Frame(app, name="frame_c", background="blue", width=40, height=40)
    d = tkinter.Frame(app, name="frame_d", background="indigo", width=40, height=40)

    e = tkinter.Frame(app, name="frame_e", background="violet", width=40, height=40)
    f = tkinter.Frame(app, name="frame_f", background="teal", width=40, height=40)
    g = tkinter.Frame(app, name="frame_g", background="orange", width=40, height=40)

    i = tkinter.Frame(d, name="frame_i", background="black", width=40, height=40)
    h = tkinter.Frame(d, name="frame_h", background="olive", width=40, height=40)

    a.grid(row=0, column=0, ipadx=12, ipady=12)
    b.grid(row=0, column=1, ipadx=12, ipady=12)
    c.grid(row=1, column=0, ipadx=12, ipady=12)
    d.grid(row=1, column=1, ipadx=12, ipady=12)

    e.grid(row=2, column=0, ipadx=12, ipady=12)
    f.grid(row=2, column=1, ipadx=12, ipady=12)
    g.grid(row=2, column=2, ipadx=12, ipady=12)

    h.grid(row=0, column=1, ipadx=12, ipady=12)
    i.grid(row=0, column=0, ipadx=12, ipady=12)

    var = tkinter.BooleanVar(app, value=False)

    def clicked(*event):
        print(f"clicked")
        var.set(not var.get())
        if var.get():
            h.grid_forget()
        else:
            h.grid(row=0, column=1, ipadx=12, ipady=12)

    tv_btn, btn = button_factory(app, tv_btn="click me", kwargs_btn={"command": clicked})
    tv_lbl, lbl, tv_entry, entry = entry_factory(app, tv_label="Var:", tv_entry=var)

    btn.grid()
    lbl.grid()
    entry.grid()

    app.mainloop()


if __name__ == '__main__':
    # test_tb1()
    test_form()
    # test_grid()

#
# class ToggleButton(tkinter.Frame):
#
#     def __init__(
#             self,
#             master,
#             label_text="Toggle",
#             state: bool = False,
#             width_label=25,
#             height_label=1,
#             width_canvas=100,
#             height_canvas=50,
#             colour_fg_true="#003000",
#             colour_bg_true="#29c164",
#             colour_fg_false="#300000",
#             colour_bg_false="#c12929",
#             *args, **kwargs):
#         super().__init__(master, width=width_canvas, height=height_canvas, *args, **kwargs)
#
#         self.tv_label = tkinter.StringVar(self, value=label_text)
#         self.label = tkinter.Label(self, textvariable=self.tv_label, width=width_label, height=height_label)
#         self.frame_canvas = tkinter.Frame(self, width=width_label + width_canvas)
#         self.canvas = tkinter.Canvas(self.frame_canvas, width=width_canvas, height=height_canvas)
#
#         self.colour_bg_true = colour_bg_true
#         self.colour_bg_false = colour_bg_false
#         self.colour_fg_true = colour_fg_true
#         self.colour_fg_false = colour_fg_false
#         self.width = width_canvas
#         self.height = height_canvas
#
#         self.state = tkinter.BooleanVar(self, value=state)
#         self.state.trace_variable("w", self.state_update)
#
#         self.sliding = tkinter.BooleanVar(self, value=False)
#
#         self.bind("<Button-1>", self.click)
#         self.label.bind("<Button-1>", self.click)
#         self.frame_canvas.bind("<Button-1>", self.click)
#         self.canvas.bind("<Button-1>", self.click)
#
#         self.text_off = self.canvas.create_text(self.width * 0.25, self.height / 2, text="Off", fill=self.colour_fg_false)
#         self.text_on = self.canvas.create_text(self.width * 0.75, self.height / 2, text="On", fill=self.colour_fg_true)
#         # self.round_rect = self.canvas.create_rectangle(self.width * 0.15, self.height * 0.15, self.width * 0.85, self.height * 0.85, outline=self.colour_fg_false, fill="")
#         self.round_rect = rounded_rect(self.canvas, self.width * 0.15, self.height * 0.15, self.width * 0.7, self.height * 0.7, 5)
#         for line in self.round_rect:
#             self.canvas.itemconfigure(line, fill=self.colour_fg_false)
#         # , width = 2, outline = self.colour_fg_false, fill = ""
#
#         self.state_update()
#
#     def state_update(self, *args):
#         slices = 10
#         state = self.state.get()
#         bg_start = self.colour_bg_true if not state else self.colour_bg_false
#         bg_end = self.colour_bg_false if not state else self.colour_bg_true
#         bg_gradient_colours = [gradient(i, slices, bg_start, bg_end) for i in range(slices)]
#         fg_start = self.colour_fg_true if not state else self.colour_fg_false
#         fg_end = self.colour_fg_false if not state else self.colour_fg_true
#         bg_gradient_colours = [gradient(i, slices, bg_start, bg_end, rgb=False) for i in range(slices)]
#         fg_gradient_colours = [gradient(i, slices, fg_start, fg_end, rgb=False) for i in range(slices)]
#
#         # print(f"Status Update: {state=}")
#
#         if state:
#             self.canvas.itemconfigure(self.text_on, state="normal")
#             self.canvas.itemconfigure(self.text_off, state="hidden")
#         else:
#             self.canvas.itemconfigure(self.text_on, state="hidden")
#             self.canvas.itemconfigure(self.text_off, state="normal")
#
#         def iter_update(i):
#             # print(f"\titer_{i=}")
#             if i == slices:
#                 self.sliding.set(False)
#                 return
#
#             bg_colour = bg_gradient_colours[i]
#             fg_colour = fg_gradient_colours[i]
#
#             # https://stackoverflow.com/questions/22838255/tkinter-canvas-resizing-automatically
#             self.configure(background=bg_colour, highlightthickness=0)
#             for line in self.round_rect:
#                 tp = self.canvas.type(line)
#                 if tp == "line":
#                     self.canvas.itemconfigure(line, fill=fg_colour)
#                 elif tp == "arc":
#                     self.canvas.itemconfigure(line, outline=fg_colour)
#
#             self.canvas.itemconfigure(self.text_on, fill=fg_colour)
#             self.canvas.itemconfigure(self.text_off, fill=fg_colour)
#             self.canvas.configure(background=bg_colour, highlightthickness=0)
#             self.label.configure(background=bg_colour, foreground=fg_colour, highlightthickness=0)
#
#             self.after(50, iter_update, i + 1)
#
#         iter_update(0)
#
#     def click(self, *args):
#         if not self.sliding.get():
#             self.sliding.set(True)
#             self.state.set(not self.state.get())
#
#     def get_objects(self):
#         return (
#             self,
#             (self.tv_label, self.label),
#             self.frame_canvas,
#             (self.state, self.canvas)
#         )
