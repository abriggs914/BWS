import tkinter

import ttkwidgets.autocomplete
from datetime_utility import date_str_format
from orbiting_date_picker import OrbitingDatePicker
from pyodbc_connection import connect
from tkinter_utility import *
from queries import *
from tkinter import ttk

from utility import lstindex, dict_print


def sort_list_with_unknown(lst):
    u_lst = [str(w).upper() for w in lst]
    u, i, l = "UNKNOWN" in lst, "UNKNOWN" in u_lst, "unknown" in lst,
    # if "UNKNOWN" in [str(w).upper() for w in lst]:

    # print(f"IN {lst}")

    if u or i or l:
        # print(f"A")
        if l:
            # print(f"C")
            lst.remove("unknown")  # Remove "UNKNOWN" from the list
            lst.sort()  # Sort the remaining elements alphabetically
            lst.insert(0, "unknown")  # Insert "UNKNOWN" at the beginning
        if u:
            # print(f"D")
            lst.remove("UNKNOWN")  # Remove "UNKNOWN" from the list
            lst.sort()  # Sort the remaining elements alphabetically
            lst.insert(0, "UNKNOWN")  # Insert "UNKNOWN" at the beginning
        else:
            # print(f"E")
            idx = lstindex(u_lst, "UNKNOWN")
            val = lst[idx]
            lst.pop(idx)  # Remove "UNKNOWN" from the list
            lst.sort()  # Sort the remaining elements alphabetically
            lst.insert(0, val)  # Insert "UNKNOWN" at the beginning
    else:
        # print(f"B")
        lst.sort()  # Sort the list alphabetically

    # print(f"OUT {lst}")

    return lst


def grid_keys():
    return "row", "column", "rowspan", "columnspan", "ipadx", "ipady", "padx", "pady", "sticky"


class ReqFrame(tkinter.Frame):

    def __init__(self, master, master_data, auto_grid=False, width=900, height=600, state_request_type_as_combobox=True, state_company_as_combobox=True):
        super().__init__(master)

        self.width_height = width, height
        self.auto_grid = auto_grid

        self.def_data = {
            ".__req_name": "REQID#",
            "__def_lbl_company": "Please select:",
            "__def_lbl_request_type": "Please select:",

            "__lbl_request_date": "Due Date:",
            "__list_departments": [],
            "__lbl_department": "Department:",
            "__lbl_company": "Company",
            "__list_companies": [],
            "__lbl_request_type": "Request Type:",
            "__list_request_types": [],
            "__lbl_request_sub_type": "Request Sub-Type:",
            "__list_request_sub_types": [],
            "__lbl_request_text": "Request:",
            "__lbl_request_comments": "Comments:",

            "__state_request_type_as_combobox": state_request_type_as_combobox,
            "__state_company_as_combobox": state_company_as_combobox,

            "__val_request_due_date": tkinter.StringVar(self, value=""),
            "__val_request_company": tkinter.StringVar(self, value=""),
            "__val_request_department": tkinter.StringVar(self, value=""),
            "__val_request_type": tkinter.StringVar(self, value=""),
            "__val_request_sub_type": tkinter.StringVar(self, value=""),
            "__val_request_text": tkinter.StringVar(self, value=""),
            "__val_request_comments": tkinter.StringVar(self, value=""),
            "__val_request_priority": tkinter.StringVar(self, value="")
        }
        self.def_data.update(master_data)

        # self.state_data = {
        #     ""
        # }

        self.frame_top = tkinter.Frame(self, name="top")
        self.frame_controls_a = tkinter.Frame(self, name="a")
        self.frame_controls_b = tkinter.Frame(self, name="b")
        self.frame_controls_c = tkinter.Frame(self, name="c")

        self.frame_controls_a_a = tkinter.Frame(self.frame_controls_a, name="a_a")
        self.frame_controls_a_b = tkinter.Frame(self.frame_controls_a, name="a_b")

        self.frame_controls_c_a = tkinter.Frame(self.frame_controls_c, name="c_a")

        self.tv_label_req_name,\
            self.label_req_name =\
            label_factory(
                self.frame_top,
                tv_label=self.def_data[".__req_name"]
            )

        # Request Date
        self.tv_ctl_lbl_request_date,\
        self.ctl_lbl_request_date = \
            label_factory(
                self.frame_controls_a,
                tv_label=self.def_data["__lbl_request_date"]
            )
        self.ctl_request_date = OrbitingDatePicker(
            self.frame_controls_a
        )

        # Company
        self.tv_ctl_lbl_company,\
        self.ctl_lbl_company = \
            label_factory(
                self.frame_controls_a,
                tv_label=self.def_data["__lbl_company"]
            )
        if self.def_data["__state_company_as_combobox"]:
            self.ctl_company = ttkwidgets.autocomplete.AutocompleteCombobox(
                self.frame_controls_a,
                completevalues=self.def_data["__list_companies"]
            )
        else:
            self.tv_ctl_company,\
            self.list_tv_ctl_company,\
            self.list_radio_btns_company =\
                radio_factory(
                    self.frame_controls_a_b,
                    buttons=self.def_data["__list_companies"]
                )
            self.tv_company_choice,\
            self.lbl_company_choice = \
                label_factory(
                    self.frame_controls_a_b,
                    tv_label=self.def_data["__def_lbl_company"]
                )
            self.def_data["__state_showing_radios_company"] = tkinter.BooleanVar(self, value=False)

        # Department
        self.tv_ctl_lbl_department,\
        self.ctl_lbl_department = \
            label_factory(
                self.frame_controls_a,
                tv_label=self.def_data["__lbl_department"]
            )
        self.ctl_department = ttkwidgets.autocomplete.AutocompleteCombobox(
            self.frame_controls_a,
            completevalues=self.def_data["__list_departments"]
        )

        # Request Type
        self.tv_ctl_lbl_request_type,\
        self.ctl_lbl_request_type = \
            label_factory(
                self.frame_controls_a,
                tv_label=self.def_data["__lbl_request_type"]
            )
        if self.def_data["__state_request_type_as_combobox"]:
            self.ctl_request_type = ttkwidgets.autocomplete.AutocompleteCombobox(
                self.frame_controls_a,
                completevalues=self.def_data["__list_request_types"]
            )
        else:
            self.tv_ctl_request_type,\
            self.list_tv_ctl_request_type,\
            self.list_radio_btns_request_type =\
                radio_factory(
                    self.frame_controls_a_a,
                    buttons=self.def_data["__list_request_types"]
                )
            self.tv_request_type_choice,\
            self.lbl_request_type_choice = \
                label_factory(
                    self.frame_controls_a_a,
                    tv_label=self.def_data["__def_lbl_request_type"]
                )
            self.def_data["__state_showing_radios_request_type"] = tkinter.BooleanVar(self, value=False)

        # Request Type
        self.tv_ctl_lbl_request_sub_type,\
        self.ctl_lbl_request_sub_type = \
            label_factory(
                self.frame_controls_a,
                tv_label=self.def_data["__lbl_request_sub_type"]
            )
        self.ctl_request_sub_type = ttkwidgets.autocomplete.AutocompleteCombobox(
            self.frame_controls_a,
            completevalues=self.def_data["__list_request_sub_types"]
        )

        # Request Text
        self.tv_ctl_lbl_request_text,\
        self.ctl_lbl_request_text = \
            label_factory(
                self.frame_controls_b,
                tv_label=self.def_data["__lbl_request_text"]
            )
        self.tv_ctl_request_text = tkinter.StringVar(self, value="")
        self.ctl_request_text = TextWithVar(
            self.frame_controls_b,
            textvariable=self.tv_ctl_request_text,
            height=10
        )

        # Comments Date Stamp Button
        self.tv_ctl_btn_date_stamp,\
        self.ctl_btn_date_stamp =\
            button_factory(
                self.frame_controls_c,
                tv_btn="Date Stamp",
                command=self.click_date_stamp
            )

        # Comments
        self.tv_ctl_lbl_request_comments,\
        self.ctl_lbl_request_comments = \
            label_factory(
                self.frame_controls_c,
                tv_label=self.def_data["__lbl_request_comments"]
            )
        self.tv_ctl_comments = tkinter.StringVar(self, value="")
        self.ctl_request_comments = TextWithVar(
            self.frame_controls_c_a,
            textvariable=self.tv_ctl_comments,
            height=15
        )

        # Binding and variable tracing
        self.def_data["__state_showing_radios_request_type"].trace_variable("w", self.update_showing_radios_request_type)
        self.def_data["__state_showing_radios_company"].trace_variable("w", self.update_showing_radios_company)
        self.tv_ctl_comments.trace_add("write", self.update_comments)


        if self.def_data["__state_request_type_as_combobox"]:
            self.ctl_request_type.bind("<<ComboboxSelected>>", self.click_cbox_selected_req_type)
            self.ctl_request_type.bind("<Tab>", self.click_cbox_selected_req_type)
        else:
            self.tv_ctl_request_type.trace_variable("w", self.update_radio_btn_request_type)
            self.frame_controls_a_a.bind("<Enter>", self.enter_frame_ctl_request_type)
            self.frame_controls_a_a.bind("<Leave>", self.leave_frame_ctl_request_type)

        if self.def_data["__state_company_as_combobox"]:
            pass
        else:
            self.tv_ctl_company.trace_variable("w", self.update_radio_btn_company)
            self.frame_controls_a_b.bind("<Enter>", self.enter_frame_ctl_company)
            self.frame_controls_a_b.bind("<Leave>", self.leave_frame_ctl_company)

        # Grid args and setup

        r, c, rs, cs, ix, iy, px, py, s = grid_keys()
        self.grid_args = {
            "frame_top": {r: 0, c: 0, cs: 1, rs: 1},
            "frame_controls_a": {r: 1, c: 0, cs: 1, rs: 1},
            "frame_controls_b": {r: 2, c: 0, cs: 1, rs: 1},
            "frame_controls_c": {r: 3, c: 0, cs: 1, rs: 1},

            "frame_controls_c_a": {r: 1, c: 0, cs: 2, rs: 1},

            # frame_top
            "label_req_name": {r: 0, c: 0, cs: 1, rs: 1},

            # frame_controls_a
            "ctl_lbl_request_date": {r: 0, c: 0, cs: 1, rs: 1},
            "ctl_request_date": {r: 0, c: 1, cs: 1, rs: 1},

            "ctl_lbl_company": {r: 1, c: 0, cs: 1, rs: 1},
            # company control is conditional

            "ctl_lbl_department": {r: 2, c: 0, cs: 1, rs: 1},
            "ctl_department": {r: 2, c: 1, cs: 1, rs: 1},

            "ctl_lbl_request_type": {r: 0, c: 2, cs: 1, rs: 1},
            # request type control is conditional

            "ctl_lbl_request_sub_type": {r: 1, c: 2, cs: 1, rs: 1},
            "ctl_request_sub_type": {r: 1, c: 3, cs: 1, rs: 1},

            # frame_controls_b
            "ctl_lbl_request_text": {r: 0, c: 0, cs: 1, rs: 1},
            "ctl_request_text": {r: 1, c: 0, cs: 1, rs: 1},

            # frame_controls_c
            "ctl_lbl_request_comments": {r: 0, c: 0, cs: 1, rs: 1},
            "ctl_btn_date_stamp": {r: 0, c: 1, cs: 1, rs: 1},

            # frame_controls_c_a,
            "ctl_request_comments": {r: 0, c: 0, cs: 2, rs: 1},
            "ctl_request_comments.scrollbar": {r: 0, c: 2, cs: 1, rs: 1, s: "ns"}

        }

        # Conditional grid
        if self.def_data["__state_request_type_as_combobox"]:
            self.grid_args.update({
                "ctl_request_type": {r: 0, c: 3, cs: 1, rs: 1}
            })
        else:
            self.grid_args.update({
                "frame_controls_a_a": {r: 0, c: 3, cs: 1, rs: 1},
                "lbl_request_type_choice": {r: 0, c: 0, cs: 1, rs: 1}
            })
            for i, btn in enumerate(self.list_radio_btns_request_type):
                self.grid_args.update({
                    # frame_controls_a_a
                    f"list_radio_btns_request_type[{i}]": {r: i, c: 0, cs: 1, rs: 1}
                })

        if self.def_data["__state_company_as_combobox"]:
            self.grid_args.update({
                "ctl_company": {r: 1, c: 1, cs: 1, rs: 1}
            })
        else:
            self.grid_args.update({
                "frame_controls_a_b": {r: 1, c: 1, cs: 1, rs: 1},
                "lbl_company_choice": {r: 0, c: 0, cs: 1, rs: 1}
            })
            for i, btn in enumerate(self.list_radio_btns_company):
                self.grid_args.update({
                    # frame_controls_a_a
                    f"list_radio_btns_company[{i}]": {r: i, c: 0, cs: 1, rs: 1}
                })

        self.configure(width=width, height=height)

        if isinstance(auto_grid, bool) and auto_grid:
            self.auto_grid_widgets()
            self.grid_widgets()

    def parse_auto_grid(self):
        ag = self.auto_grid
        off = 0 if isinstance(ag, bool) else ag
        return (off, 0) if isinstance(off, int) else off

    def grid_request_type_radios(self, do_grid):
        # print(f"\ngrid_request_type_radios {do_grid=}")
        for i, btn in enumerate(self.list_radio_btns_request_type):
            # print(f"\t{i=}, {btn=}")
            # self.grid()
            if do_grid:
                args = self.grid_args[f"list_radio_btns_request_type[{i}]"]
                btn.grid(**args)
            else:
                btn.grid_forget()

        # if val := self.def_data["__val_request_type"].get():
        #     print(f"{val=}")
        #     self.tv_request_type_choice.set(val)

        if do_grid:
            self.lbl_request_type_choice.grid_forget()
        else:
            args = self.grid_args[f"lbl_request_type_choice"]
            self.lbl_request_type_choice.grid(**args)

    def grid_company_radios(self, do_grid):
        # print(f"\ngrid_company_radios {do_grid=}")
        for i, btn in enumerate(self.list_radio_btns_company):
            # print(f"\t{i=}, {btn=}")
            # self.grid()
            if do_grid:
                args = self.grid_args[f"list_radio_btns_company[{i}]"]
                btn.grid(**args)
            else:
                btn.grid_forget()

        # if val := self.def_data["__val_request_company"].get():
        #     print(f"{val=}")
        #     self.tv_company_choice.set(val)

        if do_grid:
            self.lbl_company_choice.grid_forget()
        else:
            args = self.grid_args[f"lbl_company_choice"]
            self.lbl_company_choice.grid(**args)

    def auto_grid_widgets(self):
        off_r, off_c = self.parse_auto_grid()
        r, c, rs, cs, ix, iy, x, y, s = grid_keys()

        self.grid_args.update({
            ".": {r: off_r, c: off_c, cs: 1, rs: 1}
        })

    def grid_widgets(self):
        print(f"ReqFrame gridding everything")
        for k, args in self.grid_args.items():
            if k == ".":
                eval(f"self.grid(**{args})")
            else:
                eval(f"self.{k}.grid(**{args})")

        if not self.def_data["__state_request_type_as_combobox"]:
            self.grid_request_type_radios(self.def_data["__state_showing_radios_request_type"].get())

        if not self.def_data["__state_company_as_combobox"]:
            self.grid_company_radios(self.def_data["__state_showing_radios_company"].get())

    def clear_ctl_request_sub_type(self):
        print(f"clear_ctl_request_sub_type")
        self.ctl_request_sub_type.set("")

    def update_comments(self, *args):
        print(f"\nUPDATE!")
        self.ctl_request_comments.see(tkinter.END)
        print(f"                       {self.tv_ctl_comments.get()=}")
        print(f"             {self.ctl_request_comments.text.get()=}")
        print(f"{self.ctl_request_comments.get('1.0', tkinter.END)=}")

    def update_radio_btn_request_type(self, *args):
        self.click_cbox_selected_req_type(None)
        val = self.def_data["__list_request_types"][self.tv_ctl_request_type.get()]
        self.def_data["__val_request_type"].set(val)
        self.tv_request_type_choice.set(val)
        print(f"{self.def_data['__val_request_type'].get()=}")

    def update_radio_btn_company(self, *args):
        val = self.def_data["__list_companies"][self.tv_ctl_company.get()]
        self.def_data["__val_request_company"].set(val)
        self.tv_company_choice.set(val)
        print(f"{self.def_data['__val_request_company'].get()=}")

    def update_showing_radios_company(self, *args):
        showing = self.def_data["__state_showing_radios_company"].get()
        self.grid_company_radios(showing)
        self.def_data["__state_showing_radios_company"].set(not showing)

    def update_showing_radios_request_type(self, *args):
        showing = self.def_data["__state_showing_radios_request_type"].get()
        self.grid_request_type_radios(showing)
        self.def_data["__state_showing_radios_request_type"].set(not showing)

    def click_cbox_selected_req_type(self, event):
        if self.def_data["__state_request_type_as_combobox"]:
            req_type = self.ctl_request_type.get()
        else:
            req_type = self.tv_ctl_request_type.get()
        old_val = self.def_data["__val_request_type"].get()
        print(f"click_cbox_selected_req_type selected={req_type}")

        print(f'{self.def_data["__list_request_types"][req_type]=}')

        req_type_s = self.def_data["__list_request_types"][req_type]
        if req_type_s != old_val:
            match req_type_s:
                case "Hardware":
                    lst = self.def_data["__list_hardware"]
                case "Software":
                    lst = self.def_data["__list_software"]
                case "Training":
                    lst = self.def_data["__list_training"]
                case _:
                    lst = []
                    raise ValueError(f"Request Type '{req_type_s}' not recognized.")

            self.def_data["__list_request_sub_types"] = lst
            # self.ctl_request_sub_type.configure(values=lst)
            print(f"SETTING list: {lst}")
            self.ctl_request_sub_type.set_completion_list(lst)

            if self.ctl_request_sub_type.get():
                self.clear_ctl_request_sub_type()
            self.def_data["__val_request_type"].set(req_type_s)

    def click_date_stamp(self):
        self.ctl_request_comments.focus()
        val = self.tv_ctl_comments.get()
        print(f"BEFORE {val=}")
        if val:
            val += "\n"
        val += date_str_format(datetime.datetime.now(), include_time=True, include_weekday=True, short_month=True, short_weekday=True) + " - "
        print(f"PRESET {val=}")
        # self.tv_ctl_comments.set(val)
        self.ctl_request_comments.text.set(val)
        # self.ctl_request_comments.update_set_text(val, pass_thru=True)

    def enter_frame_ctl_company(self, event):
        # print(f"enter_frame_ctl_company {event=}")
        self.def_data["__state_showing_radios_company"].set(True)

    def leave_frame_ctl_company(self, event):
        # print(f"leave_frame_ctl_company {event=}")
        self.def_data["__state_showing_radios_company"].set(False)

    def enter_frame_ctl_request_type(self, event):
        # print(f"enter_frame_ctl_company {event=}")
        self.def_data["__state_showing_radios_request_type"].set(True)

    def leave_frame_ctl_request_type(self, event):
        # print(f"leave_frame_ctl_company {event=}")
        self.def_data["__state_showing_radios_request_type"].set(False)


class ReqInput(ReqFrame):

    def __init__(self, master, master_data, auto_grid=False, *args, **kwargs):
        super().__init__(master, master_data=master_data, auto_grid=auto_grid, *args, **kwargs)

        self.def_data.update({
            "0__req_name": "New Request"
        })

        self.tv_label_req_name.set(self.def_data["0__req_name"])
        self.configure(background=random_colour(rgb=False))


class ReqEdit(ReqFrame):

    def __init__(self, master, master_data, auto_grid=False, *args, **kwargs):
        super().__init__(master, master_data=master_data, auto_grid=auto_grid, *args, **kwargs)

        self.def_data.update({
            "1__req_name": "REQID#"
        })

        self.tv_label_req_name.set(self.def_data["1__req_name"])
        self.configure(background=random_colour(rgb=False))


# from ttkwidgets import
class App(tkinter.Tk):

    def __init__(self, req_type_as_cbox=True, company_as_cbox=True):
        super().__init__()

        self.df_v_itr_dept = None
        self.df_reqsub_hardware = None
        self.df_reqsub_software = None
        self.df_reqsub_training = None
        self.populate_data()

        self.master_data = {
            "__state_request_type_as_combobox": req_type_as_cbox,
            "__state_company_as_combobox": company_as_cbox,
            "__list_tab_texts": ["New", "Edit"],
            "__list_departments": sort_list_with_unknown(list(self.df_v_itr_dept["DeptName"].unique())),
            "__list_companies": ["Hugo", "BWS", "Stargate", "Lewis"],
            "__list_request_types": ["Hardware", "Software", "Training"],
            "__list_hardware": sort_list_with_unknown(list(self.df_reqsub_hardware["Hardware"].unique())),
            "__list_software": sort_list_with_unknown(list(self.df_reqsub_software["Software"].unique())),
            "__list_training": sort_list_with_unknown(list(self.df_reqsub_training["Training"].unique()))
        }

        print(dict_print(self.master_data))

        self.style = ttk.Style()
        self.style.configure(
            "Custom.TNotebook",
            minwidth=300,
            maxwidth=500,
            tabmargins=[10, 4, 10, 4],  # Increase the left and right padding
            padding=[10, 10]  # Increase the left and right padding
        )

        self.nbk_control = ttk.Notebook(
            self,
            style="Custom.TNotebook",
            width=900,
            height=600
        )
        self.nbk_control_tab_texts = self.master_data["__list_tab_texts"]

        self.frame_tab_0 = ReqInput(
            self.nbk_control,
            master_data=self.master_data,
            state_request_type_as_combobox=self.master_data["__state_request_type_as_combobox"],
            state_company_as_combobox=self.master_data["__state_company_as_combobox"]
        )
        self.frame_tab_1 = ReqEdit(
            self.nbk_control,
            master_data=self.master_data,
            state_request_type_as_combobox=self.master_data["__state_request_type_as_combobox"],
            state_company_as_combobox=self.master_data["__state_company_as_combobox"]
        )

        self.tabs = [
            (self.frame_tab_0, self.nbk_control_tab_texts[0]),
            (self.frame_tab_1, self.nbk_control_tab_texts[1])
        ]

        for tab, text in self.tabs:
            txt = text.center(30)
            self.nbk_control.add(tab, text=txt)

        r, c, rs, cs, ix, iy, px, py, s = grid_keys()
        self.grid_args = {
            "nbk_control": {r: 0, c: 0, cs: 1, rs: 1}
        }

        self.grid_widgets()

        self.state("zoomed")

        self.bind("<<NotebookTabChanged>>", self.click_tab_change)

    def populate_data(self):
        self.df_v_itr_dept = connect(**V_ITR_DEPT)
        self.df_reqsub_hardware = connect(**V_ITR_HARDWARE)
        self.df_reqsub_software = connect(**V_ITR_SOFTWARE)
        self.df_reqsub_training = connect(**V_ITR_TRAINING)

        def df_validator(df_in):
            return df_in is not None and isinstance(df_in, pandas.DataFrame) and not df_in.empty

        if any([
            not df_validator(self.df_v_itr_dept),
            not df_validator(self.df_reqsub_hardware),
            not df_validator(self.df_reqsub_software),
            not df_validator(self.df_reqsub_training)
        ]):
            raise ValueError("Error, some dataframes were not loaded correctly.\nApplication needs to shut down.")

    def grid_widgets(self):
        for k, args in self.grid_args.items():
            eval(f"self.{k}.grid(**{args})")

        for tab, text in self.tabs:
            tab.grid_widgets()

    def click_tab_change(self, event):
        # print(f"click_tab_change")
        selected_tab_1 = event.widget.tab('current')['text'].strip()
        selected_tab_2 = self.nbk_control.tab('current')['text'].strip()

        print(f"click_tab_change tab='{selected_tab_1}'")


if __name__ == '__main__':
    app = App(req_type_as_cbox=False, company_as_cbox=False)
    app.mainloop()
