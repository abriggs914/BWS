import enum
import os.path
import cv2
import pandas as pd

from PIL import Image
# from pyzbar.pyzbar import decode
import pyzbar.pyzbar as pyz

import pyautogui
import streamlit as st
from streamlit_extras.add_vertical_space import add_vertical_space
from streamlit_autorefresh import st_autorefresh
from streamlit_pills import pills

from datetime_utility import is_date, date_str_format
from html_utility import list_to_html
from pyodbc_connection import connect
from sql_utility import *
from streamlit_utility import coloured_text
from streamlit_utility_bws import load_it_requests, load_departments, load_itr_personnel, load_itstr_app_directory, \
    load_itr_customers, load_itr_hardware, load_itstr_user_directory, load_itr_software, load_itr_training, \
    get_next_it_request_number, get_tables, get_cols, load_production_file
from utility import isnumber

TIME_APP_REFRESH = 45 * 1000  # every 45 seconds
ROOT_DIRECTORY_REQUESTS = r"\\bwsfp01.bwsdomain.local\Public\IT\Requests"

#######################
# Prep st.session_state
#######################


if not os.path.exists(ROOT_DIRECTORY_REQUESTS):
    raise ValueError(f"Error cannot locate requests root directory '{ROOT_DIRECTORY_REQUESTS}'.")

st.set_page_config(layout="wide")
# st.write(dict(st.session_state))
DEFAULT_SESSION_STATE = {
    "auto_refresh": None,
    "text_input_username": "",
    "text_input_password": "",
    "signed_in": False,
    "itr_customer_id": -1,
    "user_name": "",
    "user_full_name": "",
    "sign_in_date": None,
    "n_attempts_password_reset": 5,
    "n_attempts_password": 0,
    "app_short_name": "Testing",
    "app_requires_user_name": True,
    "app_requires_password": True,
    # "date_input_birthdate": None,
    # "select_shirt_size": None,

    "toggle_is_admin": False,
    "toggle_submit_requests": True,

    "date_input_due": datetime.datetime.now().date(),
    "selectbox_company": "",
    "selectbox_department": "",
    "text_input_requested_by": "",
    "selectbox_request_type": "",
    "selectbox_request_sub_type": "",
    "slider_priority": 1,
    "text_request": "",
    "multiselect_followup": [],
    "itr_edit_id": None,
    "multiselect_status": [],
    "multiselect_it_personnel": [],
    "multiselect_requested_by": [],
    "session_sqls": {},

    "toggle_use_alias": True,
    "radio_query_type": "SELECT",
    "toggle_use_join_0": False
    # ,
    # "files_uploaded": ""  # This cannot be set using session_state
}
for k, v in DEFAULT_SESSION_STATE.items():
    st.session_state.setdefault(k, v)


# st.write(dict(st.session_state))


######################
# Data Fetch Functions
######################


def search_server3_tables():
    print(f"search_server3_tables")
    sel_col_names = {
        "TABLE_CATALOG": "CA_0",
        "TABLE_NAME": "CA_1",
        "COLUMN_NAME": "CA_2",
        "PRIMARY_KEY": "CA_3",
        "DATA_TYPE": "CA_4",
        "CHARACTER_MAXIMUM_LENGTH": "CA_5"
    }
    sql_table_template = """
                        SELECT
                	        [{CA_0}]
                            ,[{CA_1}]
                            ,[{CA_2}]
                            ,(CASE WHEN [IS_NULLABLE] = 'NO' THEN 1 ELSE 0 END) AS [{CA_3}]
                            ,[{CA_4}]
                            ,[{CA_5}]
                        FROM
                            INFORMATION_SCHEMA.COLUMNS
                        WHERE
                            LOWER([COLUMN_NAME]) LIKE '%{ST}%'
                        ORDER BY
                            [TABLE_NAME],
                            [COLUMN_NAME]
                        ;
                        """
    sql_values_template = """SELECT * FROM [{TABLE}];"""

    rtype: str = st.session_state.get("radio_col_search_rtype", list_col_search_rtypes[0])
    s_term: str = st.session_state.get("text_column_search", "").strip()
    st.session_state.update({"df_search_cols_result": pd.DataFrame(columns=list(sel_col_names))})
    selected = []
    for i, db in enumerate(list_databases):
        k = f"toggle_db_{db}"
        v = st.session_state.get(k, None)
        if v is None:
            st.session_state.update({k: True})
            v = True
        if v:
            selected.append(i)

    # col_val_all = self.rv_options[self.tv_rb_dv.get()]
    # inp = self.tv_search_input.get().lower()
    # print(f"{inp=}, {selected=}")
    print(f"{s_term=}, {rtype=}, {selected=}")
    dfs = []
    if s_term and selected:
        if rtype == list_col_search_rtypes[1]:
            st.info(
                body="Search by value not supported yet."
            )

        elif rtype == list_col_search_rtypes[0]:
            ca = {v: k for k, v in sel_col_names.items()}
            for db_idx in selected:
                db = list_databases[db_idx]
                cd = parse_connection_data(db)
                ca.update({"ST": s_term})
                sql = sql_table_template.format(**ca)
                print(f"{s_term=}\n{db=}\n{cd=}\n{ca=}")
                print(f"SQL:\n{sql}")
                df = connect(sql, **cd)
                dfs.append(df)
                print(f"{df=}")
            st.session_state.update({"df_search_cols_result": pd.concat(dfs, ignore_index=True)})
        else:
            st.info(
                body="Search by value & column not supported yet."
            )
    else:
        if not selected:
            st.info("No databases selected")
        if not s_term:
            st.info("Enter a search term first.")


#################
# Event Listeners
#################


def birthdate_on_change():
    dob = st.session_state.get("date_input_birthdate")
    print(f"NEW DOB {dob}")


#################
# Helper Functions
#################


def submit_mac_request(req_id: int, personnel_id: int):
    print(f"submit_mac_request")
    comments: float = st.session_state.get("text_area_request_comments", "")
    lab_est: float = st.session_state.get("slider_labour_estimate", 1)
    lab_act: float = st.session_state.get("slider_labour_actual", 1)
    update_data = {
        "Status": "In Progress",
        "ITPersonAssignedID": personnel_id,
        "LabourEstimate": lab_est,
        "LabourActual": lab_act,
        "Comments": comments
    }
    sql = create_sql(
        "IT Requests",
        data=update_data,
        mode="update",
        sanitize=["Comments"],
        where=f"[ITRequestID#] == {req_id}"
    )
    if st.session_state.get("toggle_submit_requests", True):
        connect(sql)
    # st.write(sql)
    st.session_state["session_sqls"][f"{datetime.datetime.now():%Y-%m-%d %H:%M:%S %f}"] = sql
    update_data = {
        "Status": "Complete",
        "CompletionDate": datetime.datetime.now()
    }
    sql = create_sql(
        "IT Requests",
        data=update_data,
        mode="update",
        where=f"[ITRequestID#] == {req_id}"
    )
    if st.session_state.get("toggle_submit_requests", True):
        connect(sql)
    # st.write(sql)
    st.session_state["session_sqls"][f"{datetime.datetime.now():%Y-%m-%d %H:%M:%S %f}"] = sql

    # st.session_state.update({
    #     "mark_as_complete_submitted": False
    #     # ,
    # #     "selectbox_company": "",
    # # "selectbox_department": "Sales",
    # # "text_input_requested_by": rb.strip(),
    # # "selectbox_request_type": "Software",
    # # "selectbox_request_sub_type": "Other",
    # # "slider_priority": 3,
    # # "text_request": "Help Gary Thomas access the NAS1 Engineering Jobs folder for some resources.;".strip(),
    # # "multiselect_followup
    # })
    click_clear_request_input_form()


@st.dialog("Mark request as complete")
def mark_as_complete_input(req_id, personnel_id):
    def click_date_stamp():
        text = (st.session_state.get("text_area_request_comments", "").rstrip() + "\n").lstrip()
        text = f"{text}{datetime.datetime.now():%Y-%m-%d - %H:%M:%S} - {st.session_state.get('user_name')}: "
        st.session_state.update({
            "text_area_request_comments": text
        })

    def click_cancel():
        click_clear()

    def click_clear():
        st.session_state.update({
            "slider_labour_estimate": 1,
            "slider_labour_actual": 1,
            "text_area_request_comments": "",
            "mark_as_complete_submitted": False
        })

    def click_submit():
        print(f"click_submit MAC")
        st.session_state.update({
            "mark_as_complete_submitted": True
        })

    st.write(f"Add labour:")
    cols0 = st.columns(2)
    cols1 = st.columns(3)
    with cols0[0]:
        # st.write()
        st.slider(
            label=f"Estimate (Hrs)",
            key=f"slider_labour_estimate",
            min_value=0,
            max_value=30
        )
    with cols0[1]:
        # st.write(f"Actual (Hrs)")
        st.slider(
            label=f"Actual (Hrs)",
            key=f"slider_labour_actual",
            min_value=0,
            max_value=30
        )
    st.button(
        label="Time Stamp",
        key="button_time_stamp_comments",
        on_click=click_date_stamp
    )
    st.text_area(
        label="Comments:",
        key=f"text_area_request_comments"
    )
    with cols1[0]:
        if st.button(
                label="cancel",
                key="button_mac_cancel"
                # ,
                # on_click=click_cancel
        ):
            st.session_state.update({
                "slider_labour_estimate": 1,
                "slider_labour_actual": 1,
                "text_area_request_comments": "",
                "mark_as_complete_submitted": False
            })
    with cols1[1]:
        if st.button(
                label="clear",
                key="button_mac_clear"
                # ,
                # on_click=click_clear
        ):
            st.session_state.update({
                "slider_labour_estimate": 1,
                "slider_labour_actual": 1,
                "text_area_request_comments": "",
                "mark_as_complete_submitted": False
            })
    with cols1[2]:
        if st.button(
                label="submit",
                key="button_mac_submit"
                # ,
                # on_click=click_submit
        ):
            print(f"click_submit MAC")
            st.session_state.update({
                "mark_as_complete_submitted": True
            })
            submit_mac_request(req_id, personnel_id)
            st.rerun()


@ st.dialog("ITR Edit Params", width="large")
def itr_edit_params():
    if st.button(
            label="Edit Requests"
    ):
        # requested_by = st.session_state.get("multiselect_requested_by", [])
        # it_personnel = st.session_state.get("multiselect_it_personnel", [])
        # status = st.session_state.get("multiselect_status", [])
        # is_complete = st.session_state.get("radio_is_complete", None)
        # is_internal = st.session_state.get("radio_is_internal", None)

        df_itr_requests = df_itr_requests_og.copy()

        # requested_by = st.session_state.get("multiselect_requested_by", [])
        requested_by = st.session_state["multiselect_requested_by"]
        it_personnel = st.session_state.get("multiselect_it_personnel", [])
        status = st.session_state.get("multiselect_status", [])
        use_is_complete = st.session_state.get("toggle_use_is_complete", False)
        use_is_internal = st.session_state.get("toggle_use_is_internal", False)
        is_complete = st.session_state.get("radio_is_complete", None)
        is_internal = st.session_state.get("radio_is_internal", None)

        it_personnel = df_itr_personnel_og.loc[
            df_itr_personnel_og["Name"].isin(it_personnel), "ITPersonID#"].dropna().unique().tolist()
        internal_it = df_itr_personnel_og.loc[df_itr_personnel_og["Active"] == 1, "Name"].dropna().unique().tolist()

        print(f"ITR_EP {st.session_state.get('multiselect_requested_by', [])=}")
        print("ITR_EP requested_by")
        print(requested_by)
        print("ITR_EP it_personnel")
        print(it_personnel)
        print("ITR_EP status")
        print(status)

        print(f"A df={df_itr_requests.shape}")

        if requested_by:
            df_itr_requests = df_itr_requests.loc[df_itr_requests["RequestedBy"].isin(requested_by)]
        print(f"B df={df_itr_requests.shape}")
        if it_personnel:
            df_itr_requests = df_itr_requests.loc[df_itr_requests["ITPersonAssignedID"].isin(it_personnel)]
        print(f"C df={df_itr_requests.shape}")
        if status:
            df_itr_requests = df_itr_requests.loc[df_itr_requests["Status"].isin(status)]
        print(f"D df={df_itr_requests.shape}")
        if use_is_complete:
            if is_complete:
                df_itr_requests = df_itr_requests.loc[
                    df_itr_requests["Status"].isin(["Complete", "Declined", "Incomplete"])]
            else:
                df_itr_requests = df_itr_requests.loc[
                    ~df_itr_requests["Status"].isin(["Complete", "Declined", "Incomplete"])]
        print(f"E df={df_itr_requests.shape}")
        if use_is_internal:
            if is_internal:
                df_itr_requests = df_itr_requests.loc[df_itr_requests["RequestedBy"].isin(internal_it)]
            else:
                df_itr_requests = df_itr_requests.loc[~df_itr_requests["RequestedBy"].isin(internal_it)]

        print(f"F df={df_itr_requests.shape}")
        if not df_itr_requests.empty:
            st.session_state.update({
                # by default go the last available request
                "itr_edit_id": df_itr_requests.iloc[-1]["ITRequestID#"],
                "multiselect_requested_by": requested_by,
                "multiselect_it_personnel": it_personnel,
                "multiselect_status": status
            })
        else:
            st.info("No requests match criteria")
        print(f"LEAVING ITR_EP")
        for k, v in st.session_state.items():
            print(f"{k=}, {v=}")
        st.rerun()

    itr_ms_requested_by = st.multiselect(
        label=f"Requested By:",
        key=f"multiselect_requested_by",
        options=df_itr_requests_og["RequestedBy"].dropna().unique().tolist()
    )

    itr_ms_personnel = st.multiselect(
        label=f"IT Personnel:",
        key=f"multiselect_it_personnel",
        options=df_itr_personnel_og["Name"].dropna().unique().tolist()
    )

    itr_ms_status = st.multiselect(
        label=f"Status:",
        key=f"multiselect_status",
        options=df_itr_requests_og["Status"].dropna().unique().tolist()
    )

    cols_is_complete = st.columns([0.6, 0.4])
    cols_is_internal = st.columns([0.6, 0.4])
    cols_is_complete[0].toggle(
        label="Enable / Disable Is Complete",
        key="toggle_use_is_complete"
    )
    is_complete = cols_is_complete[1].radio(
        label="Is complete",
        options=["Yes", "No"],
        key="radio_is_complete",
        horizontal=True,
        label_visibility="hidden",
        disabled=not st.session_state.get("toggle_use_is_complete")
    )

    cols_is_internal[0].toggle(
        label="Enable / Disable Is Internal",
        key="toggle_use_is_internal"
    )
    is_internal = cols_is_internal[1].radio(
        label="Is internal",
        options=["Yes", "No"],
        key="radio_is_internal",
        horizontal=True,
        label_visibility="hidden",
        disabled=not st.session_state.get("toggle_use_is_internal")
    )

    if st.button(
            label="reset"
    ):
        print(f"ITR_EP RESET")
        st.session_state.update({
            "multiselect_requested_by": [],
            "multiselect_it_personnel": [],
            "multiselect_status": [],
            "radio_is_complete": None,
            "radio_is_internal": None
        })


def get_request_sub_types(rt_in: str = None) -> list[str]:
    if rt_in is None:
        rt_ = st.session_state.get("selectbox_request_type", "").title()
    else:
        rt_ = rt_in
    used = df_itr_requests.loc[
        df_itr_requests["RequestType"].str.title() == rt_, "RequestSubType"
    ].dropna().str.title().unique().tolist()
    if rt_ == "Hardware":
        used += df_itr_hardware["Hardware"].values.tolist()
    elif rt_ == "Software":
        used += df_itr_software["Software"].values.tolist()
    elif rt_ == "Training":
        used += df_itr_training["Training"].values.tolist()
    else:
        used = []
    return sorted(set(used))


# def submit_form(form_key):
#     print(f"SUBMIT {form_key} FORM")
#     sql = ""
#     match form_key:
#         case "Customer":
#             sql = "UPDATE [BWSdb].[dbo].[ITR Customers] SET "
#             dob: Optional[datetime.datetime] = st.session_state.get("date_input_birthdate")
#             shirt_size: Optional[str] = st.session_state.get("select_shirt_size")
#             cust_id = st.session_state.get("itr_customer_id")
#             print(f"NEW DOB {dob}")
#             if dob:
#                 dob_y: int = dob.year
#                 dob_m: int = dob.month
#                 dob_d: int = dob.day
#                 print(f"y={dob_y}, m={dob_m}, d={dob_d} ", end="")
#                 sql += f"[BirthYear] = {dob_y}, "
#                 sql += f"[BirthMonth] = {dob_m}, "
#                 sql += f"[BirthDay] = {dob_d}, "
#             if shirt_size:
#                 print(f"ss={shirt_size}", end="")
#                 sql += f"[ShirtSize] = '{shirt_size}', "
#
#             sql = sql.removesuffix(", ")
#             sql += f" WHERE [CustomerID] = {cust_id};"
#             print(f"")
#         case _:
#             raise KeyError(f"This {form_key=} is unrecognized.")
#
#     if sql:
#         print(f"{sql=}")


# default values for request_form()
default_company: str = "BWS"
default_department: str = "IT"
default_request_type: str = "Training"
default_request_sub_type: str = "Other"

# List of valid file types for file_input for request_form()
list_valid_file_attachment_types: list[str] = [
    # images
    "jpg", "jpeg", "png", "gif", "webp", "heic",

    # audio video
    "mp3", "mp4",

    # Office
    "docx", "xlsx", "xlsm", "pptx",

    # misc
    "txt", "msg", "pdf",

    # code
    "py", "sql", "json", "csv"
]

# List of searchable databases for Server [Maintenance]->[Search Tables]
list_databases = [
    "BWSdb",
    "StargateDB",
    "CompanyH",
    "SysproCompanyA",
    "SysproCompanyS",
    "SysproCompanyL",
    "uniPoint_Live"
]
# List of ways to apply the search term when searching server3 tables.
list_col_search_rtypes = ["Column Names", "Values", "Anything"]


####################
# Fetch Data SLOW...
####################


df_itr_requests: pd.DataFrame = load_it_requests()
df_departments: pd.DataFrame = load_departments()
df_itr_personnel: pd.DataFrame = load_itr_personnel()
df_itr_customers: pd.DataFrame = load_itr_customers()
df_app_directory: pd.DataFrame = load_itstr_app_directory()
df_user_directory: pd.DataFrame = load_itstr_user_directory()
df_itr_hardware: pd.DataFrame = load_itr_hardware()
df_itr_software: pd.DataFrame = load_itr_software()
df_itr_training: pd.DataFrame = load_itr_training()

df_itr_requests_og: pd.DataFrame = df_itr_requests.copy()
df_departments_og: pd.DataFrame = df_departments.copy()
df_itr_customers_og: pd.DataFrame = df_itr_customers.copy()
df_itr_personnel_og: pd.DataFrame = df_itr_personnel.copy()
df_app_directory_og: pd.DataFrame = df_app_directory.copy()
df_user_directory_og: pd.DataFrame = df_user_directory.copy()

df_app_directory: pd.DataFrame = df_app_directory.loc[
    df_app_directory["AppShortName"] == st.session_state.get("app_short_name")]
app_found: bool = not df_app_directory.empty
app_id: int = df_app_directory.iloc[0]["ID"] if app_found else -1
st.session_state.update({
    "app_requires_password": (
        True if pd.isna(df_app_directory.iloc[0]["PasswordRequired"]) else
        df_app_directory.iloc[0]["PasswordRequired"]) if app_found else True,
    "app_requires_user_name": (
        True if pd.isna(df_app_directory.iloc[0]["UserNameRequired"]) else
        df_app_directory.iloc[0]["UserNameRequired"]) if app_found else True,
    "app_master_password": (
        None if pd.isna(df_app_directory.iloc[0]["MasterPassword"]) else
        df_app_directory.iloc[0]["MasterPassword"]) if app_found else None
})
# st.write(f"{app_found=}")
# st.write(f"{app_id=}")
# st.write(f"user_reqd={st.session_state.get('app_requires_user_name')}")
# st.write(f"pwd_reqd={st.session_state.get('app_requires_password')}")
# st.write(f"master_pwd={st.session_state.get('app_master_password')}")

list_companies: list[str] = sorted(df_itr_requests["Company"].dropna().str.upper().unique().tolist())
list_departments: list[str] = sorted(df_departments["Dept"].dropna().str.title().unique().tolist())
list_request_types: list[str] = sorted(["Hardware", "Software", "Training"])
rt: str = st.session_state.get("selectbox_request_type", [])
rb: str = st.session_state.get("user_full_name", [])
list_request_sub_types: list[str] = get_request_sub_types()
list_customers: list[str] = sorted(
    df_itr_customers.loc[df_itr_customers["Active"] == 1, "Name"].dropna().str.title().unique().tolist())

list_companies.insert(0, "")
list_departments.insert(0, "")
list_request_types.insert(0, "")
list_request_sub_types.insert(0, "")
list_customers.insert(0, "")

# st.write(f"{app_id=}, {type(app_id)=}")
# st.dataframe(df_app_directory, use_container_width=True)
# st.dataframe(df_user_directory, use_container_width=True)

unique_app_users: list[str] = df_user_directory_og["AppUserName"].dropna().str.title().unique().tolist()
df_user_directory: pd.DataFrame = df_user_directory.loc[df_user_directory["ITSTRAppID"] == app_id]
if df_user_directory.empty:
    if st.session_state.get("app_requires_user_name"):
        df_user_directory = df_user_directory_og.copy()
        # df_user_directory = pd.concat([
        #     df_user_directory,
        #     pd.DataFrame(
        #         path_data={
        #             "AppUserName": unique_app_users,
        #             "ITSTRAppID": [app_id for _ in unique_app_users]
        #         }
        #     )
        # ])
df_user_directory["AppUserName"] = df_user_directory["AppUserName"].str.title()

# st.write(f"AFTER")
# st.write(df_user_directory)
# st.write(df_itr_customers)

list_shirt_sizes: list[str] = sorted(df_itr_customers["ShirtSize"].dropna().str.title().unique().tolist())


# if st.button(
#     label="Clear Cache & Rerun"
# ):
#     st.cache_data.clear()
#     st.cache_resource.clear()
#     st.rerun()


grid = {
    "top_bar": st.columns([0.6, 0.2, 0.2]),
    "title_row": st.container(),
    "credentials_row": st.container(),
    "content_row_0": st.container(),
    "content_row_1": st.container(),
    "content_row_2": st.container()
    # ,
    # "tab_new_request": None,
    # "tab_edit_request": None
}

tab_names = ["New", "Edit", "Server", "Access", "Inventory", "Code Samples"]
sm_tab_names = ["Search Tables", "SQL Creator", "Coming Soon"]
if st.session_state.get("signed_in", False):
    with grid["content_row_1"]:
        tab_choice = pills("Options:", tab_names)
    grid.update({
        "tab_choice": tab_choice
    })


def click_clear_request_input_form():
    st.session_state.update({
        "date_input_due": datetime.datetime.now().date(),
        "selectbox_company": "",
        "selectbox_department": "",
        "text_input_requested_by": "",
        "selectbox_request_type": "",
        "selectbox_request_sub_type": "",
        "slider_priority": 1,
        "text_request": "",
        "multiselect_followup": [],
        "mark_as_complete_submitted": False
    })

    # forbidden
    # st.session_state.update({"files_uploaded": None})


def check_password():
    """Returns `True` if the user had a correct password."""

    def login_form():
        """Form with widgets to collect user information"""
        with grid["title_row"].form("Credentials"):
            st.write(f"### Please Sign in:")
            st.text_input("Username", key="text_input_username")
            if st.session_state.get("app_requires_password", True):
                st.text_input("Password", type="password", key="text_input_password")
            st.form_submit_button("Log in", on_click=password_entered)

    def password_entered():
        """Checks whether a password entered by the user is correct."""
        user: str = st.session_state.get("text_input_username", "").lower()
        pswd: str = st.session_state.get("text_input_password", "")
        atpt: int = st.session_state.get("n_attempts_password", DEFAULT_SESSION_STATE["n_attempts_password"])
        matp: int = DEFAULT_SESSION_STATE["n_attempts_password_reset"]
        # st.dataframe(df_user_directory)
        df_user: pd.DataFrame = df_user_directory.loc[df_user_directory["AppUserName"] == user]

        if df_user.empty:
            if df_app_directory.iloc[0]["MasterPassword"] == pswd:
                df_user: pd.DataFrame = df_user_directory.loc[df_user_directory["AppUserName"].str.title() == user]
        if df_user.empty:
            df_cust: pd.DataFrame = df_itr_customers.loc[
                (df_itr_customers["WindowsUser"].str.lower() == user)
                | (df_itr_customers["Name"].str.lower() == user)
                ].reset_index()
            if not df_cust.empty:
                cust_id: int = df_cust.iloc[0]["CustomerID"]
                # st.write(f"{cust_id}")
                # st.write(f"{app_id}")
                # st.write(df_user_directory_og)
                df_user: pd.DataFrame = df_user_directory_og.loc[
                    (df_user_directory_og["ITSTRAppID"] == app_id)
                    & (df_user_directory_og["ITRCustomerID"] == cust_id)
                    ]
                if df_user.empty:
                    df_user = pd.concat([
                        pd.DataFrame(columns=df_user.columns),
                        pd.DataFrame(data={
                            "AppUserName": [user],
                            "ITRCustomerID": cust_id
                        })
                    ])
                    st.write(
                        f"Need to add this person from [ITR Customers]. '{user}' ({cust_id=}) does not have an entry for Streanlit app ID={app_id}")
                    if not st.session_state.get("app_requires__password"):
                        st.write("Access granted as no password is needed.")
                else:
                    st.write(f"Found by FullName in [ITSTR_UserDirectory]")

        # st.write(f"{user=}, {pswd=}, {atpt=}, {matp=}")
        # st.write(f"B")
        # st.dataframe(df_user)
        with grid["credentials_row"]:
            if not df_user.empty:
                # found user
                if st.session_state.get("app_requires_password", True):
                    df_user: pd.DataFrame = df_user.loc[df_user["AppPassword"] == pswd].reset_index()
                # st.write("DF_USER: ->")
                # st.dataframe(df_user)
                if not df_user.empty:
                    # valid user and valid password
                    cust_id: int = df_user.iloc[0]["ITRCustomerID"]
                    # st.write(f"{cust_id=}")
                    df_cust: pd.DataFrame = df_itr_customers.loc[df_itr_customers["CustomerID"] == cust_id]
                    # st.write("DF_CUST:")
                    # st.dataframe(df_cust)
                    full_name = df_cust.iloc[0]["Name"]
                    # st.write(f"{full_name=}")
                    st.session_state.update({
                        "signed_in": True,
                        "user_name": user,
                        "itr_customer_id": cust_id,
                        "user_full_name": full_name,
                        "sign_in_date": datetime.datetime.now()
                    })
                else:
                    if (atpt + 1) < matp:
                        st.write(f":red[Incorrect Password, {matp - (atpt + 1)} attempt(s) remaining]")
                    else:
                        st.write(f":red[Maximum attempts entered]")
            else:
                st.write(f":red[You are not recognized as a known user.]")

        st.session_state.update({
            "n_attempts_password": atpt + 1
        })

    # valid sign in
    if st.session_state.get("signed_in", False):
        return True

    # show form if attempts remain
    if st.session_state.get("app_requires_user_name"):
        # st.write("USER REQUIRED")
        if st.session_state.get("n_attempts_password") < st.session_state.get("n_attempts_password_reset"):
            login_form()
        else:
            st.write("TOO MANY ATTEMPTS")
    else:
        st.write("NO USER REQUIRED")
        return True
    return False


def request_form(form, mode: Literal["new", "edit"]):
    global list_request_sub_types

    def click_test_input():
        # Demo request helping Gary Thomas with the public drive
        st.session_state.update({
            "date_input_due": datetime.datetime.now().date(),
            "selectbox_company": "BWS",
            "selectbox_department": "Sales",
            "text_input_requested_by": rb.strip(),
            "selectbox_request_type": "Software",
            "selectbox_request_sub_type": "Other",
            "slider_priority": 3,
            "text_request": "Help Gary Thomas access the NAS1 Engineering Jobs folder for some resources.;".strip(),
            "multiselect_followup": ["Avery Briggs", "James Crawford", "Jamie Merrithew", "Austin Broad"]
        })

    if mode == "new":
        with form:
            st.button(
                label="Test_0",
                key="TEST_INPUT_BUTTON",
                on_click=click_test_input
            )

    cust_id: int = 1
    personnel_id: int = 1
    df_customer: pd.DataFrame = df_itr_customers_og.loc[df_itr_customers_og["Name"].str.lower() == rb.lower()]
    df_personnel: pd.DataFrame = pd.DataFrame()
    if not df_customer.empty:
        df_customer: pd.DataFrame = df_customer.iloc[0]
        cust_id: int = df_customer["CustomerID"]
        df_personnel: pd.DataFrame = df_itr_personnel_og.loc[df_itr_personnel_og["ITRCustomerID"] == cust_id]
        if not df_personnel.empty:
            df_personnel: pd.DataFrame = df_personnel.iloc[0]
            personnel_id: int = df_personnel["ITPersonID#"]

    is_admin: bool = personnel_id > 1
    submit_requests: bool = st.session_state.get("toggle_submit_requests", True)
    st.write(f"{personnel_id=}, {is_admin=}, {submit_requests=}")
    st.session_state.update({"toggle_is_admin": is_admin})
    # st.session_state.update({"toggle_mark_as_complete": False})
    # st.session_state.setdefault("toggle_is_admin", is_admin)
    st.session_state.setdefault("toggle_mark_as_complete", False)

    if mode == "edit":
        my_id: int = st.session_state.get("itr_edit_id")
        df_req: pd.DataFrame = df_itr_requests_og.loc[df_itr_requests_og["ITRequestID#"] == my_id].iloc[0]
        directory = df_req["Directory"]
        due_date = df_req["DueDate"]
        company = df_req["Company"].upper()
        department = df_req["Department"]
        # st.write("department V")
        # st.write(department)
        # st.write("department OG V")
        # st.write(df_departments_og)
        department_name = df_departments_og.loc[df_departments_og["MinOfDeptID"] == department].iloc[0][
            "Dept"].title() if not pd.isna(
            department) else [""]
        # st.write("department_name")
        # st.write(department_name)
        requester: str = df_req["RequestedBy"]
        request_type: str = df_req["RequestType"]
        request_sub_type: str = df_req["RequestSubType"]
        priority: str = df_req["Priority"]
        request: str = df_req["Request"]
        comments: str = df_req["Comments"]
        follow_up: str = df_req["RequestFollowUpPersonnel"]
        follow_up_emails = follow_up.split(";") if not pd.isna(follow_up) else []
        follow_up_names = []
        for i, email in enumerate(follow_up_emails):
            if email:
                df_cust: pd.DataFrame = df_itr_customers_og.loc[
                    df_itr_customers_og["Email"].str.lower() == email.lower()]
                if not df_cust.empty:
                    follow_up_names.append(df_cust.iloc[0]["Name"])
        st.session_state.update({
            "date_input_due": due_date,
            "selectbox_company": company,
            "selectbox_department": department_name,
            "text_input_requested_by": requester,
            "selectbox_request_type": request_type,
            "selectbox_request_sub_type": request_sub_type,
            "slider_priority": priority,
            "text_request": request,
            "text_comments": comments,
            "multiselect_followup": follow_up_names,
            "mark_as_complete_submitted": False
        })
        # list_request_sub_types = sorted(df_itr_requests.loc[df_itr_requests["RequestType"].str.title() == request_type.title(), "RequestSubType"].dropna().str.title().unique().tolist())
        list_request_sub_types = get_request_sub_types(request_type)

    # file_uploader = None

    form_grid = {
        "title": form.columns(1, vertical_alignment="center"),
        "inputs": form.columns(3, vertical_alignment="center"),
        "text": form.columns(1, vertical_alignment="center"),
        "followup": form.columns(1, vertical_alignment="center"),
        "info": form.columns(1, vertical_alignment="center"),
        "admin": form.columns(1, vertical_alignment="center"),
        "btns": form.columns(3, vertical_alignment="center")
    }

    with form_grid["title"][0]:
        if mode == "new":
            st.header("New Request")
        else:
            st.header("Edit Request")

    def click_cancel():
        print(f"cancel")

    def click_clear():
        print(f"clear")
        click_clear_request_input_form()

    def click_submit():
        print(f"submit")
        mark_as_complete = st.session_state.get("toggle_mark_as_complete", False)
        due_date: datetime.date = st.session_state.get("date_input_due", datetime.datetime.now().date())
        comp: str = st.session_state.get("selectbox_company", default_company).strip()
        dept: str = st.session_state.get("selectbox_department", default_department).strip()
        requester: str = st.session_state.get("text_input_requested_by", rb).strip()
        req_type: str = st.session_state.get("selectbox_request_type", default_request_type).strip()
        req_sub_type: str = st.session_state.get("selectbox_request_sub_type", default_request_sub_type).strip()
        priority: int = st.session_state.get("slider_priority", 1)
        text: str = st.session_state.get("text_request", "").strip()
        follow_up: list[str] = st.session_state.get("multiselect_followup", [])
        # st.write(file_uploader)
        # attachments: list[dict] = []
        # if file_uploader:
        #     cols = [
        #         "name",
        #         "type",
        #         "size",
        #         "close",
        #         "closed",
        #         "detach",
        #         "file_id",
        #         "fileno",
        #         "flush",
        #         "getbuffer",
        #         "getvalue",
        #         "isatty",
        #         "read",
        #         "read1",
        #         "readable",
        #         "readinto",
        #         "readinto1",
        #         "readline",
        #         "readlines",
        #         "seek",
        #         "seekable",
        #         "size",
        #         "tell",
        #         "truncate",
        #         "writable",
        #         "write",
        #         "writelines"
        #         # ,
        #         # "_file_urls",
        #         # "_checkWritable",
        #         # "_checkSeekable",
        #         # "_checkReadable",
        #         # "_checkClosed"
        #     ]
        #     attachments = [
        #         {
        #             f"file_{key}": getattr(file, key)
        #             for key in cols
        #             if not callable(getattr(file, key))
        #         }
        #         for file in file_uploader
        #     ]
        #
        # # st.write("attachments")
        # # st.write(attachments)

        follow_up_emails: list[str] = []
        for name in follow_up:
            df_customer: pd.DataFrame = df_itr_customers_og.loc[
                df_itr_customers_og["Name"].str.lower() == name.lower()].reset_index()
            if not df_customer.empty:
                follow_up_emails.append(
                    df_customer.iloc[0]["Email"].strip() if not pd.isna(df_customer.iloc[0]["Email"]) else "")
        follow_up: str = ";".join([email for email in follow_up_emails if email.strip()])

        valid: bool = True

        if not comp:
            form_grid["info"][0].info("Please choose a Company first.")
            valid = False
        if not dept:
            form_grid["info"][0].info("Please choose a Department first.")
            valid = False
        if not req_type:
            form_grid["info"][0].info("Please choose a Request Type first.")
            valid = False
        if not req_sub_type:
            form_grid["info"][0].info("Please choose a Request-Sub-Type first.")
            valid = False
        if not text:
            form_grid["info"][0].info("Please describe your issue first.")
            valid = False

        dept_id: str = "NULL"
        df_dept: pd.DataFrame = df_departments_og.loc[
            df_departments_og["Dept"].str.lower() == dept.lower()].reset_index()
        if not df_dept.empty:
            dept_id = df_dept.iloc[0]["MinOfDeptID"]

        # sub_priority: int = 0
        df_priority: pd.DataFrame = df_itr_requests_og.loc[
            (df_itr_requests_og["RequestedBy"].str.lower() == requester.lower())
            & (df_itr_requests_og["Priority"] == priority)
            ]
        sub_priority: int = df_priority["Priority"].count() + 1
        # if not df_priority.empty:

        if valid:
            st.write("VALID SUBMISSION")

            if mode == "new":
                # BEWARE ARTIFICIALLY 'CLAIMED' A SQL SERVER TABLE ID
                # Call insert statement ASAP to ensure that you actually get this ID
                my_id: int = get_next_it_request_number()
                st.write(f"MY ID# == {my_id}")
                dir_name: str = f"REQID#{str(my_id).rjust(6, '0')}"
                directory: str = os.path.join(ROOT_DIRECTORY_REQUESTS, dir_name)
                print(f"mode==new")
            else:
                my_id: int = st.session_state.get("itr_edit_id")
                df_req: pd.DataFrame = df_itr_requests_og.iloc[my_id]
                directory = df_req["Directory"]
                due_date = df_req["DueDate"]
                company = df_req["Company"]
                department = df_req["Department"]
                department_name = df_departments_og.loc[df_departments["MinOfDeptID"] == department] if not pd.isna(
                    department) else ""
                requester: str = df_req["RequestedBy"]
                request_type: str = df_req["RequestedType"]
                request_sub_type: str = df_req["RequestedSubType"]
                priority: str = df_req["Priority"]
                request: str = df_req["Request"]
                follow_up: str = df_req["RequestFollowUpPersonnel"]
                follow_up_emails = follow_up.split(";") if not pd.isna(follow_up) else []
                follow_up_names = []
                for i, email in enumerate(follow_up_emails):
                    if email:
                        df_cust: pd.DataFrame = df_itr_customers_og.loc[
                            df_itr_customers_og["Email"].str.lower() == email.lower()]
                        if not df_cust.empty:
                            follow_up_names.append(df_cust.iloc[0]["Name"])
                st.session_state.update({
                    "date_input_due": due_date,
                    "selectbox_company": company,
                    "selectbox_department": department_name,
                    "text_input_requested_by": requester,
                    "selectbox_request_type": request_type,
                    "selectbox_request_sub_type": request_sub_type,
                    "slider_priority": priority,
                    "text_request": request,
                    "multiselect_followup": follow_up_names,
                    "mark_as_complete_submitted": False
                })
                print(f"mode==edit")

            if not os.path.exists(directory):
                os.mkdir(directory)

            for file in file_uploader:
                try:
                    file_name = getattr(file, "name")
                    file_path = os.path.join(directory, file_name)
                    with open(file_path, "wb") as f:
                        f.write(file.getbuffer())
                except Exception as e:
                    st.write(f"Error copying file {file}.\n{e}")
                    continue

            directory = "\\\\" + directory.removeprefix("\\\\").removeprefix("\\")
            insert_data: dict[str: Any] = {
                "Request": text,
                "DueDate": due_date,
                "Company": comp,
                "Department": dept_id,
                "Priority": priority,
                "SubPriority": sub_priority,
                "RequestType": req_type,
                "RequestSubType": req_sub_type,
                "RequestedBy": requester,
                "RequestFollowUpPersonnel": follow_up,
                "RequestDate": datetime.datetime.now(),
                "Status": "Queued",
                "RequestDateOriginal": datetime.datetime.now(),
                "Directory": directory
            }
            sanitize_cols = list(insert_data.keys())
            sanitize_cols.remove("RequestFollowUpPersonnel")  # preserve semicolons delimiting email addresses
            sanitize_cols.remove("Directory")  # preserve backslashes in path
            sql = create_sql(
                "IT Requests",
                data=insert_data,
                mode="insert",
                sanitize=sanitize_cols
            )
            if st.session_state.get("toggle_submit_requests", True):
                connect(sql)
            st.session_state["session_sqls"][f"{datetime.datetime.now():%Y-%m-%d %H:%M:%S %f}"] = sql
            # st.write(sql)

            if mode == "new":
                # verify the id claimed
                my_id_after: int = get_next_it_request_number() - 1
                my_id = my_id_after

            st.session_state.update({
                "slider_labour_estimate": 1,
                "slider_labour_actual": 1,
                "text_area_request_comments": "",
                "mark_as_complete_submitted": False
            })
            print(f"MARK AS COMPLETE {datetime.datetime.now():%Y-%m-%d %H:%M:%S}")

            if (mode == "new") and mark_as_complete:
                if not st.session_state.get("mark_as_complete_submitted", False):
                    mark_as_complete_input(my_id, personnel_id)
                else:
                    print(f"ALREADY HANDLED {datetime.datetime.now():%Y-%m-%d %H:%M:%S}")

            if not mark_as_complete:
                st.session_state.update({"mark_as_complete_submitted": True})

            if mode == "new":
                dialog_mac_submitted_correctly: bool = st.session_state.get("mark_as_complete_submitted", False)
                if dialog_mac_submitted_correctly:
                    print(f"UPDATING MAC DETAILS {datetime.datetime.now():%Y-%m-%d %H:%M:%S}")
                else:
                    st.write("MAC not submitted")
                    print(f"MAC NOT SUBMITTED {datetime.datetime.now():%Y-%m-%d %H:%M:%S}")

    def change_request_type(*args):
        print(f"change_request_type")

    # click_clear()
    with form:

        # with form_grid["title"][0]:
        #     st.markdown(
        #         "# Request Input",
        #         unsafe_allow_html=True
        #     )
        with form_grid["inputs"][0]:
            st.date_input(
                label="Due Date:",
                key="date_input_due"
            )
            st.selectbox(
                label="Company:",
                key="selectbox_company",
                options=list_companies
            )
            st.selectbox(
                label="Department:",
                key="selectbox_department",
                options=list_departments
            )
        with form_grid["inputs"][1]:
            st.text_input(
                label="Requester:",
                key="text_input_requested_by",
                disabled=True
            )
            st.selectbox(
                label="Type:",
                key="selectbox_request_type",
                options=list_request_types,
                on_change=change_request_type
            )
            print("list_request_sub_types")
            print(f"{st.session_state.get('selectbox_request_sub_type')=}")
            print(list_request_sub_types)
            st.selectbox(
                label="Sub-Type:",
                key="selectbox_request_sub_type",
                options=list_request_sub_types
            )
        with form_grid["inputs"][2]:
            if is_admin:
                toggle_is_admin = st.toggle(
                    label="Admin",
                    # value=st.session_state.get("toggle_is_admin"),
                    key="toggle_is_admin",
                    disabled=True
                )
                # st.write(f"AA {st.session_state.get('toggle_submit_requests')=}")
                # st.write(f"AA {type(st.session_state.get('toggle_submit_requests'))=}")
                # I don't know why this toggle needs to have a 'value', the session_state value is accurate above...?
                toggle_submit_requests = st.toggle(
                    label="Submit Requests?",
                    value=st.session_state.get("toggle_submit_requests"),
                    key="toggle_submit_requests"
                )
                if mode == "new":
                    toggle_mark_as_complete = st.toggle(
                        label="Mark Complete?",
                        # value=st.session_state.get("toggle_mark_as_complete"),
                        key="toggle_mark_as_complete"
                    )
            st.slider(
                label="Priority:",
                key="slider_priority",
                max_value=10,
                min_value=1,
                step=1
            )
            file_uploader = st.file_uploader(
                label="Attachments",
                accept_multiple_files=True,
                key="files_uploaded"
                # ,
                # type=list_valid_file_attachment_types.copy()
            )
        with form_grid["text"][0]:
            st.button(
                label="Date Stamp",
                key="button_text_request_date_stamp",
                on_click=lambda: st.session_state.update({
                    "text_request":
                        (st.session_state.get("text_request",
                                              "").rstrip() + "\n").lstrip() + f"{datetime.datetime.now():%Y-%m-%d - %H:%M:%S} - {st.session_state.get('user_name')}: "
                })
            )
            st.text_area(
                label="Request",
                key="text_request",
                placeholder="Describe your issue, include as many details as possible and any supporting documentation you can provide. Screenshots are helpful."
            )
            if mode == "edit":
                st.button(
                    label="Date Stamp",
                    key="button_text_comments_date_stamp",
                    on_click=lambda: st.session_state.update({
                        "text_comments":
                            (st.session_state.get("text_comments",
                                                  "").rstrip() + "\n").lstrip() + f"{datetime.datetime.now():%Y-%m-%d - %H:%M:%S} - {st.session_state.get('user_name')}: "
                    })
                )
                st.text_area(
                    label="Comments",
                    key="text_comments",
                    placeholder="Describe your issue, include as many details as possible and any supporting documentation you can provide. Screenshots are helpful."
                )
        with form_grid["followup"][0]:
            st.multiselect(
                label="Follow-up with:",
                key="multiselect_followup",
                options=list_customers,
                placeholder="Optional"
            )
        with form_grid["btns"][0]:
            st.button(
                label="cancel",
                key="btn_cancel",
                on_click=click_cancel,
                use_container_width=True
            )
        with form_grid["btns"][1]:
            st.button(
                label="clear",
                key="btn_clear",
                on_click=click_clear,
                use_container_width=True
            )
        with form_grid["btns"][2]:
            st.button(
                label="submit",
                on_click=click_submit,
                use_container_width=True
            )


def edit_request():
    if st.session_state.get("itr_edit_id") is None:
        itr_edit_params()
    else:

        print(f"RESUMING ER")
        for k, v in st.session_state.items():
            print(f"{k=}, {v=}")

        form = grid["content_row_2"].container()
        with form:
            if st.button(
                    label="filter",
                    key="button_filter_edit"
            ):
                st.session_state.update({"itr_edit_id": None})
                st.rerun()

        df_itr_requests = df_itr_requests_og.copy()

        # requested_by = st.session_state.get("multiselect_requested_by", [])
        requested_by = st.session_state["multiselect_requested_by"]
        it_personnel = st.session_state.get("multiselect_it_personnel", [])
        status = st.session_state.get("multiselect_status", [])
        use_is_complete = st.session_state.get("toggle_use_is_complete", False)
        use_is_internal = st.session_state.get("toggle_use_is_internal", False)
        is_complete = st.session_state.get("radio_is_complete", None)
        is_internal = st.session_state.get("radio_is_internal", None)

        it_personnel = df_itr_personnel_og.loc[
            df_itr_personnel_og["Name"].isin(it_personnel), "ITPersonID#"].dropna().unique().tolist()
        internal_it = df_itr_personnel_og.loc[df_itr_personnel_og["Active"] == 1, "Name"].dropna().unique().tolist()

        print(f"{st.session_state.get('multiselect_requested_by', [])=}")
        print("requested_by")
        print(requested_by)
        print("it_personnel")
        print(it_personnel)
        print("status")
        print(status)
        st.write(f"A")
        st.write(df_itr_requests)
        if requested_by:
            df_itr_requests = df_itr_requests.loc[df_itr_requests["RequestedBy"].isin(requested_by)]
        st.write(f"B")
        st.write(df_itr_requests)
        if it_personnel:
            df_itr_requests = df_itr_requests.loc[df_itr_requests["ITPersonAssignedID"].isin(it_personnel)]
        st.write(f"C")
        st.write(df_itr_requests)
        if status:
            df_itr_requests = df_itr_requests.loc[df_itr_requests["Status"].isin(status)]
        st.write(f"D")
        st.write(df_itr_requests)
        if use_is_complete:
            if is_complete:
                df_itr_requests = df_itr_requests.loc[
                    df_itr_requests["Status"].isin(["Complete", "Declined", "Incomplete"])]
            else:
                df_itr_requests = df_itr_requests.loc[
                    ~df_itr_requests["Status"].isin(["Complete", "Declined", "Incomplete"])]
        st.write(f"E")
        st.write(df_itr_requests)
        if use_is_internal:
            if is_internal:
                df_itr_requests = df_itr_requests.loc[df_itr_requests["RequestedBy"].isin(internal_it)]
            else:
                df_itr_requests = df_itr_requests.loc[~df_itr_requests["RequestedBy"].isin(internal_it)]

        st.write(f"F")
        st.write(df_itr_requests)

        req_id: int = st.session_state.get("itr_edit_id")
        t_reqs: int = df_itr_requests.shape[0]
        filtered_ids: list[int] = [row["ITRequestID#"] for i, row in df_itr_requests.iterrows()]
        filtered_idx: int = filtered_ids.index(req_id)
        # # req_idx_off: int = st.session_state.get("itr_edit_id_offset")
        # # req_idx: int = df_itr_requests.loc[df_itr_requests["ITRequestID#"] == req_id].name
        # st.write("filtered_ids")
        # st.write(filtered_ids)
        prev_id: int = filtered_ids[max(0, filtered_idx - 1)]
        next_id: int = filtered_ids[min(filtered_idx + 1, len(filtered_ids) - 1)]
        first_id: int = filtered_ids[0]
        last_id: int = filtered_ids[-1]
        # df_request: pd.DataFrame = df_itr_requests_og.loc[df_itr_requests_og["ITRequestID#"] == req_id].iloc[0]

        # # req_id: int = df_request["ITRequestID#"]
        # last_req_id: int = df_request.iloc[req_idx].name
        req_str: str = str(req_id).rjust(6, "0")

        with form:
            st.header(f"Edit Request #{req_str}")
            st.write(f"{req_id=}, {t_reqs=}, {filtered_idx=}, {prev_id=}, {next_id=}, {first_id=}, {last_id=}")
            st.write("filtered_ids")
            st.write(filtered_ids)
            nav_button_cols = st.columns([0.1, 0.1, 0.6, 0.1, 0.1])

            with st.expander("Filtered Requests"):
                st.dataframe(df_itr_requests)

            if nav_button_cols[0].button(":black_left_pointing_double_triangle_with_vertical_bar:",
                                         key="button_nav_first_request"):
                print(f"First")
                st.session_state.update({
                    "itr_edit_id": first_id
                })
            if nav_button_cols[1].button(":rewind:", key="button_nav_back_request"):
                st.session_state.update({
                    "itr_edit_id": prev_id
                })
            with nav_button_cols[2]:
                st.write(f"{filtered_idx + 1} / {t_reqs}")
            if nav_button_cols[3].button(":fast_forward:", key="button_nav_next_request"):
                print(f"Next")
                st.session_state.update({
                    "itr_edit_id": next_id
                })
            if nav_button_cols[4].button(":black_right_pointing_double_triangle_with_vertical_bar:",
                                         key="button_nav_last_request"):
                print(f"Last")
                st.session_state.update({
                    "itr_edit_id": last_id
                })

        request_form(form=form, mode="edit")


def input_new_request():
    # form = grid["tab_new_request"].container()
    form = grid["content_row_2"].container()
    request_form(form=form, mode="new")


@st.dialog(title="Select an existing table", width="large")
def import_existing_table_cols():

    def click_df():
        # df_sel: dict = st.session_state.get("stdf_df_tables", {})
        # st.write(df_sel)
        pass

    def validate_chosen():
        df_chosen = st.session_state.get("data_editor_cols", pd.DataFrame())
        st.write("VALIDATING...")

    st.toggle(
        label="Views",
        key=f"toggle_sel_table_views"
    )

    st.session_state.setdefault("selectbox_sel_table", "BWSdb")
    st.selectbox(
        label="Database",
        key=f"selectbox_sel_table",
        options=list_databases
    )

    # df_cols = st.columns([2/5, 3/5], gap="small")
    tabs_df = st.tabs(["Choose Table", "Select Columns", "Review"])

    db_name = st.session_state.get("selectbox_sel_table", "BWSdb")
    count_col = "COLUMN_NAME"
    df_tables_og = get_tables(db_name)
    show_cols = [
        "COLUMN_NAME",
        "PRIMARY_KEY",
        "DATA_TYPE",
        "CHARACTER_MAXIMUM_LENGTH"
    ]
    list_data_types = ["str", "int", "decimal", "float", "date", "datetime", "bit"]
    # join_cols = ["TABLE_NAME"]
    # join_suffixes = ("_x", "_y")
    # col_names = df_tables.columns.tolist()
    #
    # for col1 in join_cols:
    #     for i in range(len(col_names)):
    #         col2 = col_names[i]
    #         if col1 == col2:
    #             col_names[i] = col_names[i] + join_suffixes[0]

    df_tables = df_tables_og.groupby(
        by="TABLE_NAME"
    ).agg({
        count_col: "count"
    }).rename(columns={count_col: "COL_COUNT"})

    def update_sel_columns():
        print(f"update_sel_columns")

    with tabs_df[0]:
        # Select a table
        st.dataframe(
            data=df_tables,
            key=f"stdf_df_tables",
            on_select=click_df,
            selection_mode="single-row"
        )

    with tabs_df[1]:
        # Select some columns from the previous table selection.
        if st.session_state.get("stdf_df_tables"):
            # this works because the table selection st.dataframe is in selection_mode="single-row"
            selected_rows = st.session_state.get("stdf_df_tables")["selection"]["rows"]
            if selected_rows:
                table_name = df_tables.iloc[selected_rows[0]].name
                st.write(table_name)
                df_columns = get_cols(table_name, db_name)
                df_columns["+"] = False
                stde_df_table_columns = st.data_editor(
                    df_columns[["+"] + show_cols],
                    key=f"stdf_df_table_columns",
                    # on_select=lambda: 1,
                    hide_index=True,
                    disabled=show_cols,
                    on_change=update_sel_columns
                )
            else:
                st.write("Select a table first.")

    with tabs_df[2]:
        # Review and submit the selected columns
        cont_table = st.container()
        cols = st.columns([1 / 3, 1 / 3, 1 / 3])
        selected_table_rows = st.session_state.get("stdf_df_tables")["selection"]["rows"]
        if selected_table_rows:
            table_name = df_tables.iloc[selected_table_rows[0]].name
            # selected_column_rows = st.session_state.get("stdf_df_table_columns")["selection"]["rows"]
            selected_column_rows = stde_df_table_columns.loc[stde_df_table_columns["+"]]
            if not selected_column_rows.empty:
                column_names: pd.DataFrame = df_tables_og.loc[
                    df_tables_og["TABLE_NAME"] == table_name
                ].reset_index().iloc[
                    selected_column_rows.index
                ][show_cols].reset_index(drop=True)

                column_names["DATA_TYPE"].replace("nvarchar", "str", inplace=True)
                column_names["DEFAULT"] = None
                column_names["VALID"] = column_names.apply(lambda row:
                                                           bool(len(row["DATA_TYPE"].strip()))
                                                           and bool(len(row["COLUMN_NAME"].strip()))
                                                           , axis=1)

                new_col_names = column_names.columns.tolist()
                new_col_names.remove("PRIMARY_KEY")
                stde_columns = cont_table.data_editor(
                    column_names,
                    column_config={
                        "DATA_TYPE": st.column_config.SelectboxColumn(
                            label="DATA_TYPE",
                            options=list_data_types,
                            required=True,
                            default=list_data_types[0]
                        )
                        # ,
                        # "PRIMARY_KEY": st.column_config.CheckboxColumn(
                        #     label="PK",
                        #     width=50
                        # )
                    },
                    key=f"k_data_editor_cols",
                    on_change=validate_chosen,
                    hide_index=True,
                    column_order=new_col_names,
                    disabled=["VALID"],
                )
                # print(f"--MM")
                # print(stde_columns)
                st.session_state.update({
                    "data_editor_cols_data": column_names[new_col_names],
                    "data_editor_cols": stde_columns
                })

                # if stde_columns.loc[stde_columns["PRIMARY_KEY"]].empty:
                #     st.warning("No PK specified in columns")
                if stde_columns.loc[stde_columns["VALID"]].empty:
                    st.error("You have invalid column details specified.")
                else:
                    with cols[2]:
                        if st.button(
                            label="Submit Columns",
                            key=f"btn_sel_table_submit"
                        ):
                            st.rerun()

        with cols[1]:
            if st.button(
                label="Cancel",
                key=f"btn_sel_table_cancel"
            ):
                st.rerun()


def server_maintenance():
    with grid["content_row_2"]:

        if "df_search_cols_result" not in st.session_state:
            search_server3_tables()

        sm_tabs = pills("Server Maintenance", options=sm_tab_names, label_visibility="hidden")
        if sm_tabs == sm_tab_names[0]:
            st.header("Server3 Table Column Finder")

            input_db_cols = st.columns(len(list_databases) + 1)
            radio_search_rtype = input_db_cols[0].radio(
                label="Databases:",
                options=list_col_search_rtypes,
                key="radio_col_search_rtype"
            )
            toggles_dbs = []
            for i, db in enumerate(list_databases):
                toggles_dbs.append(
                    input_db_cols[i + 1].toggle(
                        label=db,
                        key=f"toggle_db_{db}"
                    )
                )
            # self.list_tv_rb_db, self.list_rb_db_bts = checkbox_factory(
            #     self.frame_db_btns,
            #     buttons=self.list_databases,
            #     default_values=[True for _ in self.list_databases]
            # )

            # self.tv_lbl_search_input, self.lbl_search_input, self.tv_search_input, self.search_input = entry_factory(
            #     self,
            #     tv_label="Search Term:",
            #     kwargs_entry={
            #         "width": 100,
            #         "justify": tkinter.CENTER
            #     }
            # )
            cols_button_row = st.columns([0.8, 0.2, 0.2])
            text_col = cols_button_row[0].text_input(
                label="Column Name:",
                key="text_column_search",
                placeholder="Enter a column name to search each table in the selected databases"
            )
            button_col_search_clear = cols_button_row[1].button(
                label="clear",
                on_click=lambda: st.session_state.update({"text_column_search": ""})
            )
            button_col_search_submit = cols_button_row[2].button(
                label="search",
                on_click=search_server3_tables
            )

            df_search_cols = st.session_state.get("df_search_cols_result")
            stdf_search_cols = st.dataframe(
                df_search_cols,
                hide_index=True,
                use_container_width=True,
                selection_mode="multi-row",
                on_select="rerun"
            )

            # st.write("stdf_search_cols")
            # st.write(stdf_search_cols)
            sel_row_idxs = stdf_search_cols.get("selection", {}).get("rows", [])
            code = ""
            if sel_row_idxs:
                toggle_select_star = st.toggle(
                    label="SELECT *",
                    value=False
                )
                if st.button(
                    label="Write selects"
                ):
                    for i, row_i in enumerate(sel_row_idxs):
                        table_catalog = df_search_cols.loc[row_i, "TABLE_CATALOG"]
                        table_name = df_search_cols.loc[row_i, "TABLE_NAME"]
                        column_name = df_search_cols.loc[row_i, "COLUMN_NAME"]
                        sel_cols = "*" if toggle_select_star else f"[{column_name}]"
                        table = f"[{table_catalog}].[dbo].[{table_name}]"
                        code += f"-- {table}\nSELECT\n\t{sel_cols}\nFROM\n\t{table}\n;\n"
                    st.code(
                        body=code,
                        language="sql",
                        line_numbers=True
                    )

        if sm_tabs == sm_tab_names[1]:
            # SQL Creator

            list_query_types: list[str] = ["SELECT", "UPDATE", "INSERT", "DELETE", "CREATE"]
            list_join_options: list[str] = ["INNER", "LEFT", "RIGHT", "CROSS", "FULL"]

            input_db_cols = st.columns(len(list_databases) + 1)
            input_table_cols = st.container(border=1)
            input_join_cols = st.columns([0.35, 0.65])
            radio_query_type = input_db_cols[0].radio(
                label="Query Type:",
                key="radio_query_type",
                options=list_query_types,
                disabled=False
            )
            toggles_dbs = []
            db_options_0 = []
            for i, db in enumerate(list_databases):
                k = f"toggle_db_{db}"
                toggles_dbs.append(
                    input_db_cols[i + 1].toggle(
                        label=db,
                        key=k
                    )
                )
                v = st.session_state.get(k, False)
                if v:
                    df_tables = get_tables(db)
                    for j, table_name in enumerate(df_tables["TABLE_NAME"].dropna().unique()):
                        db_options_0.append(f"{wrap(db)}.[dbo].{wrap(table_name)}")

                # table_catalog = row["TABLE_CATALOG"]
                # table_name = row["TABLE_NAME"]
                # col_name = row["COLUMN_NAME"]
                # p_key = row["PRIMARY_KEY"]
                # d_type = row["DATA_TYPE"]
                # char_max_len = row["CHARACTER_MAXIMUM_LENGTH"]

            if radio_query_type == "CREATE":
                # default columns for Boilerplate info
                records = [
                    {
                        "Name": "ID",
                        "Type": "int",
                        "Size": None,
                        "Default": None
                    },
                    {
                        "Name": "DateCreated",
                        "Type": "datetime",
                        "Size": None,
                        "Default": "GETDATE()"
                    },
                    {
                        "Name": "LastModified",
                        "Type": "datetime",
                        "Size": None,
                        "Default": None
                    },
                    {
                        "Name": "Active",
                        "Type": "bit",
                        "Size": None,
                        "Default": 1
                    },
                    {
                        "Name": "DateActive",
                        "Type": "datetime",
                        "Size": None,
                        "Default": None
                    },
                    {
                        "Name": "DateInActive",
                        "Type": "datetime",
                        "Size": None,
                        "Default": None
                    }
                ]
                boilerplate_cols = [d["Name"] for d in records]

                # New Column template data
                ct_column_names = ["PK", "Name", "Type", "Size", "Default"]
                ct_type_options = ["str", "int", "decimal", "float", "date", "datetime", "bit"]
                ct_size_options = {
                    "str": range(1, 6000001),
                    "int": "na",
                    "decimal": [f"{a_}, {b_})" for a_ in range(2, 19) for b_ in range(1, 18) if (a_ - 1) >= b_],
                    "float": [f"({a_}, {b_})" for a_ in range(2, 19) for b_ in range(1, 18) if (a_ - 1) >= b_],
                    "date": "na",
                    "datetime": "na"
                }

                ct_text_db_name = input_table_cols.text_input(
                    label="Database Name:",
                    key=f"ct_text_db_name"
                )
                ct_text_table_name = input_table_cols.text_input(
                    label="Table Name:",
                    key=f"ct_text_table_name"
                )

                cols_ct_control = input_table_cols.columns(2)
                with cols_ct_control[0].container(border=1):
                    with st.popover(label="info"):
                        st.write("Add these 6 boiler-plate identification columns to your table.")
                        st.write(
                            "These exact column names are used when generating the associating triggers and backup table scripts.")
                        st.code(("""
    [ID] [int] IDENTITY(0, 1) NOT NULL,
    [DateCreated] [datetime] NULL,
    [LastModified] [datetime] NULL,
    [Active] [bit] NULL,
    [DateActive] [datetime] NULL,
    [DateInActive] [datetime] NULL
                                    """).strip(),
                                language="sql",
                                line_numbers=True
                                )
                    if st.button(
                        label="Add 6 Boilerplate cols"
                    ):
                        df_ct_nc = pd.DataFrame(
                            data=records,
                            columns=ct_column_names
                        )
                        df_ct_nc.loc[df_ct_nc["Name"] == "ID", "PK"] = 1
                        st.session_state.update({
                            "ct_data": df_ct_nc
                        })
                        st.rerun()
                    if st.button(
                        label="Import Existing Table",
                        key=f"btn_import_existing_table"
                    ):
                        import_existing_table_cols()

                with cols_ct_control[1].container(border=1):
                    # # [Name], [Comments], [LastModifiedBy], [Price], [Description], [ModelName]
                    # # FKs
                    general_cols = [
                        {
                            "Name": "Name",
                            "Label": "[Name] [NVARCHAR](50)",
                            "Type": "str",
                            "Size": 50,
                            "Default": None
                        },
                        {
                            "Name": "LastModifiedBy",
                            "Label": "[LastModifiedBy] [NVARCHAR](50)",
                            "Type": "str",
                            "Size": 50,
                            "Default": None
                        },
                        {
                            "Name": "Comments",
                            "Label": "[Comments] [NVARCHAR](MAX)",
                            "Type": "str",
                            "Size": ct_size_options["str"][-1],
                            "Default": None
                        },
                        {
                            "Name": "Description",
                            "Label": "[Description] [NVARCHAR](MAX)",
                            "Type": "str",
                            "Size": ct_size_options["str"][-1],
                            "Default": None
                        },
                        {
                            "Name": "Price",
                            "Label": "[Price] [DECIMAL](18, 2) (DEFAULT=0)",
                            "Type": "decimal",
                            "Size": "(18, 2)",
                            "Default": 0
                        }
                    ]
                    cols_ct_general_cols = st.columns(len(general_cols))
                    for i, data in enumerate(general_cols):
                        col_name = data.get("Name")
                        col_label = data.get("Label")
                        col_type = data.get("Type")
                        col_size = data.get("Size")
                        col_default = data.get("Default")
                        with cols_ct_general_cols[i]:
                            if st.button(
                                    label=f"{col_label}",
                                    key=f"ct_btn_general_col_{i}"
                            ):
                                if not st.session_state.get("ct_data").loc[
                                    st.session_state.get("ct_data")["Name"] == col_name].empty:
                                    st.error(
                                        f"Cannot add {col_label} (NAME='{col_name}'), as it already exists in the columns list.")
                                else:
                                    df_ct_nc = pd.DataFrame(
                                        data=[
                                            {
                                                "Name": col_name,
                                                "Type": col_type,
                                                "Size": col_size,
                                                "Default": col_default
                                            }
                                        ],
                                        columns=ct_column_names
                                    )
                                    st.session_state.update({
                                        "ct_data": pd.concat([
                                            st.session_state.get("ct_data"),
                                            df_ct_nc
                                        ]).reset_index(drop=True)
                                    })
                                    st.rerun()

                input_table_cols.subheader("Columns:")
                print("st.session_state.get('data_editor_cols_data')")
                print(st.session_state.get("data_editor_cols_data"))
                df_decd = st.session_state.get("data_editor_cols_data", pd.DataFrame())
                for idx, col_changes in st.session_state.get("data_editor_cols", {}).get("edited_rows", {}).items():
                    for cn, ev in col_changes.items():
                        df_decd.loc[idx, cn] = ev
                print("df_decd")
                print(df_decd)
                input_table_cols.write(df_decd)
                print(st.session_state.get("data_editor_cols_"))
                input_table_cols.write(st.session_state.get("data_editor_cols"))
                if "ct_data" not in st.session_state:
                    ct_data = pd.DataFrame(columns=ct_column_names)
                    st.session_state.update({"ct_data": ct_data})
                elif not df_decd.empty:
                    # TODO this dataframe doesnt match the expected columns.
                    df_decd.rename(
                        columns={
                            "COLUMN_NAME": "Name",
                            "DATA_TYPE": "Type",
                            "CHARACTER_MAXIMUM_LENGTH": "Size",
                            "DEFAULT": "Default"
                        },
                        inplace=True
                    )
                    # by default, force the PK assignment to be done
                    df_decd["PK"] = False
                    ct_data = df_decd
                else:
                    ct_data = st.session_state.get("ct_data")

                # ct_input_table = input_table_cols[0].data_editor(
                #     data=pd.DataFrame(columns=ct_columns),
                #     column_config={
                #         "decimal": st.column_config.SelectboxColumn(
                #             "Size",
                #             options=ct_type_options
                #         )
                #     }
                # )

                def update_cb_pk(key: str, i: int):
                    print(f"{key=}")
                    for j, row in ct_data.iterrows():
                        ct_data.loc[j, "PK"] = 1 if i == j else 0
                        # if k != key:
                        #     st.session_state.update({k: False})
                        #     df_ct_nc.loc[df_ct_nc["index"] == i, "PK"] = 1
                        # else:
                        #     st.session_state.update({k: True})
                        #     df_ct_nc.loc[df_ct_nc["index"] == i, "PK"] = 1
                    st.session_state.update({
                        "ct_data": ct_data
                    })
                    st.rerun()

                def update_cn(idx: int, direction: int):
                    df = st.session_state.get("ct_data")
                    a, b = (idx - 1, idx) if direction == -1 else (idx, idx + 1)
                    df.loc[a], df.loc[b] = df.loc[b].copy(), df.loc[a].copy()
                    df = df.reset_index(drop=True)
                    st.session_state.update({"ct_data": df})

                def delete_cn(idx: int):
                    df: pd.DataFrame = st.session_state.get("ct_data")
                    # a, b = (idx - 1, idx) if direction == -1 else (idx, idx + 1)
                    # df.loc[a], df.loc[b] = df.loc[b].copy(), df.loc[a].copy()
                    df.drop(index=idx, inplace=True)
                    df = df.reset_index(drop=True)
                    st.session_state.update({"ct_data": df})

                def edit_cn(idx: int):
                    col_name = ct_data.loc[idx, "Name"]
                    col_type = ct_data.loc[idx, "Type"]
                    col_size = ct_data.loc[idx, "Size"]
                    col_default = ct_data.loc[idx, "Default"]
                    st.session_state.update({
                        "ct_nc_editing": True,
                        "ct_nc_editing_revert_idx": idx,
                        "ct_nc_text_input_name": col_name,
                        "ct_nc_text_input_type": col_type,
                        "ct_nc_slider_size": col_size,
                        "ct_default_text_input": col_default
                    })
                    delete_cn(idx)

                def update_selectbox_size():
                    size = st.session_state.get("ct_nc_select_box_size", "MAX")
                    if size == "MAX":
                        size = ct_size_options["str"][-1]
                    st.session_state.update({
                        "ct_nc_slider_size": int(size)
                    })

                ct_columns = input_table_cols.columns(1 + len(ct_column_names), border=0)
                # input_table_cols.write("---")
                print("ct_data")
                print(ct_data)
                st.dataframe(ct_data)
                list_cb_pk_keys = []
                cont_height = 75
                for i, col in enumerate(ct_column_names, start=1):
                    with ct_columns[i]:
                        # container_btn_bar = st.container(height=25)
                        with st.container(height=cont_height):
                            st.write(col)
                with ct_columns[0]:
                    with st.container(height=cont_height):
                        st.empty()
                for i, row in ct_data.iterrows():
                    ct_pk = row["PK"]
                    ct_name = row["Name"]
                    ct_type = row["Type"]
                    ct_size = row["Size"]
                    ct_def = row["Default"]

                    ct_pk = 0 if pd.isna(ct_pk) else bool(ct_pk)
                    with ct_columns[0]:
                        # container_btn_bar = st.container(height=25)
                        btn_bar = st.container(height=cont_height).columns(4, gap="small")
                        if i > 0:
                            btn_bar[0].button(
                                label="^",
                                key=f"ct_btn_col_up_{i}",
                                on_click=lambda i_=i: update_cn(i_, -1)
                            )
                        if i < ct_data.shape[0] - 1:
                            btn_bar[1].button(
                                label="v",
                                key=f"ct_btn_col_down_{i}",
                                on_click=lambda i_=i: update_cn(i_, 1)
                            )
                        btn_bar[2].button(
                            label="edit",
                            key=f"ct_btn_col_edit_{i}",
                            type="secondary",
                            on_click=lambda i_=i: edit_cn(i_)
                        )
                        btn_bar[3].button(
                            label="del",
                            key=f"ct_btn_col_delete_{i}",
                            type="primary",
                            on_click=lambda i_=i: delete_cn(i_)
                        )
                        # st.write("CONTROLS")
                    with ct_columns[1]:
                        k = f"ct_nc_checkbox_pk_{i}"
                        list_cb_pk_keys.append(k)
                        st.session_state.update({k: ct_pk})
                        with st.container(height=cont_height):
                            st.checkbox(
                                label="pk",
                                key=k,
                                label_visibility="hidden",
                                on_change=lambda key_=k, i_=i: update_cb_pk(key_, i_)
                            )
                    with ct_columns[2]:
                        with st.container(height=cont_height):
                            st.write(ct_name)
                    with ct_columns[3]:
                        with st.container(height=cont_height):
                            st.write(ct_type)
                    with ct_columns[4]:
                        with st.container(height=cont_height):
                            st.write(ct_size)
                    with ct_columns[5]:
                        ct_def = None if not ct_def else ct_def
                        with st.container(height=cont_height):
                            st.write(ct_def)
                    # input_table_cols.write(f"{i=}, {row=}")
                if ct_data.shape[0] == 0:
                    input_table_cols.write("0 columns")
                # input_table_cols.write("---")

                ct_nc_editing: bool = st.session_state.get("ct_nc_editing", False)

                if ct_nc_editing or input_table_cols.button(
                        label="Add Column",
                        key=f"ct_btn_add_new_column"
                ):
                    st.session_state.update({"ct_nc_editing": True})
                    ct_nc_text_input_name = ct_columns[2].text_input(
                        label="Name",
                        key="ct_nc_text_input_name"
                    )
                    if st.session_state.get("ct_nc_text_input_name"):
                        ct_nc_text_input_type = ct_columns[3].selectbox(
                            label="Type",
                            key="ct_nc_text_input_type",
                            options=ct_type_options
                        )
                        ct_type = st.session_state.get("ct_nc_text_input_type")
                        if ct_type:
                            validator = ct_size_options[ct_type]
                            size_key = ""
                            if validator != "na":
                                if ct_type == "str":
                                    size_key = "ct_nc_slider_size"
                                    if "ct_nc_select_box_size" not in st.session_state:
                                        st.session_state.update({
                                            "ct_nc_select_box_size": "MAX"
                                        })
                                        update_selectbox_size()
                                    ct_nc_slider_size = ct_columns[4].slider(
                                        label="Size",
                                        key=size_key,
                                        min_value=validator[0],
                                        max_value=validator[-1]
                                    )
                                    ct_nc_select_box_size = ct_columns[4].selectbox(
                                        label="Size",
                                        key="ct_nc_select_box_size",
                                        options=["25", "50", "255", "511", "1023", "MAX"],
                                        label_visibility="hidden",
                                        on_change=update_selectbox_size
                                    )
                                elif ct_type in ["float", "decimal"]:
                                    size_key = "ct_nc_select_box_size"
                                    ct_nc_select_box_size = ct_columns[4].selectbox(
                                        label="Size",
                                        key=size_key,
                                        options=validator
                                    )

                            ct_default_text_input = ct_columns[5].text_input(
                                label="Default Value",
                                key="ct_default_text_input"
                            )

                            ct_save_new_column_disabled = False
                            ct_nc_name = st.session_state.get("ct_nc_text_input_name")
                            ct_nc_type = st.session_state.get("ct_nc_text_input_type")
                            ct_nc_size = st.session_state.get(size_key)
                            ct_nc_default = st.session_state.get("ct_default_text_input")

                            if ct_nc_default:
                                if ct_nc_type in ("str", "float", "decimal"):
                                    # check size of default
                                    if len(ct_nc_default) > ct_nc_size:
                                        input_table_cols.warning(
                                            f"default value '{ct_nc_default}' cannot exceed the size '{ct_nc_size}'."
                                        )
                                if ct_nc_type in ("int", "float", "decimal", "bit"):
                                    # validate number types:
                                    if not isnumber(ct_nc_default):
                                        input_table_cols.warning(
                                            f"default value '{ct_nc_default}' must be a number for this field."
                                        )
                                if ct_nc_type in ("date", "datetime"):
                                    # validate date types
                                    date_val = is_date(ct_nc_default)
                                    if ct_nc_default.lower() == "getdate()":
                                        date_val = "GETDATE()"
                                    elif date_val is None:
                                        input_table_cols.warning(
                                            f"default value '{ct_nc_default}' must be a date for this field."
                                        )

                            if input_table_cols.button(
                                    label="save",
                                    key=f"ct_save_new_column",
                                    disabled=ct_save_new_column_disabled
                            ):
                                record = {
                                    "Name": st.session_state.get("ct_nc_text_input_name"),
                                    "Type": st.session_state.get("ct_nc_text_input_type"),
                                    "Size": st.session_state.get(size_key),
                                    "Default": st.session_state.get("ct_default_text_input")
                                }
                                col_names = list(map(str.lower, ct_data["Name"].tolist()))
                                if ct_nc_name.lower() in col_names:
                                    input_table_cols.warning(
                                        f"Cannot insert another column with the name '{ct_nc_name}', only one instance per table."
                                    )
                                else:
                                    ct_nc_editing_revert_idx = st.session_state.get("ct_nc_editing_revert_idx")
                                    if ct_nc_editing_revert_idx is not None:
                                        ct_data = pd.concat([
                                            ct_data[:ct_nc_editing_revert_idx],
                                            pd.DataFrame(data=[record], columns=ct_column_names),
                                            ct_data[ct_nc_editing_revert_idx:]
                                        ]).reset_index(drop=True)
                                    else:
                                        ct_data = pd.concat([
                                            ct_data,
                                            pd.DataFrame(data=[record], columns=ct_column_names)
                                        ]).reset_index(drop=True)
                                    st.session_state.update({
                                        "ct_data": ct_data,
                                        "ct_nc_editing": False,
                                        "ct_nc_editing_revert_idx": None
                                    })
                                    st.rerun()

                user_name = st.session_state.get("user_full_name", "FULL NAME")
                table_name = wrap(st.session_state.get("ct_text_table_name", "UNNAMED"), is_col=True,
                                  sanitize=True).removeprefix("[").removesuffix("]")
                db_name = wrap(st.session_state.get("ct_text_db_name", "UNNAMED"), is_col=True,
                               sanitize=True).removeprefix("[").removesuffix("]")
                need_db_and_table_names = (not len(f"{db_name}".strip())) or (not len(f"{table_name}".strip()))

                if need_db_and_table_names:
                    input_table_cols.warning("Please specify the Database and New Table Names above.")

                if input_table_cols.button(
                        label="Generate SQL",
                        key="ct_btn_generate_sql",
                        disabled=need_db_and_table_names
                ):
                    if ct_data.shape[0] > 0:
                        now = datetime.datetime.now()
                        create_table_sql = f"\n/****** Object:  Table [dbo].[{{TABLE_NAME}}]    Script Date: {now:%Y-%m-%d %H:%M:%S} ******/"
                        create_table_sql += "\n" + (f"""
USE [{db_name}]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:\t\t<{user_name}>
-- Create date:\t<{now:%Y-%m-%d %H:%M:%S}>
-- Description:\t<Create Table [{db_name}].[dbo].[{{TABLE_NAME}}]>
-- =============================================
                                """).strip()
                        create_table_sql += "\n" + (f"""
CREATE TABLE [dbo].[{{TABLE_NAME}}] (
                                """).strip()

                        sql = create_table_sql.format(TABLE_NAME=table_name)
                        sql_hist = create_table_sql.format(TABLE_NAME=f"hist_{table_name}")
                        sql_hist_trig = (f"""
USE [{db_name}]
GO

/****** Object:  Trigger [dbo].[tr_Update{table_name}History]    Script Date: {now:%Y-%m-%d %H:%M:%S} ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:\t\t<{user_name}>
-- Create date:\t<{now:%Y-%m-%d %H:%M:%S}>
-- Description:\t<Maintain History Table>
-- =============================================
CREATE TRIGGER [dbo].[tr_Update{table_name}History] 
ON [dbo].[{table_name}]
AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
                        """).strip()
                        sql_hist_trig += "\n\n\t" + (f"""
    INSERT INTO
        [{db_name}].[dbo].[hist_{table_name}]
    (
        [NestLevel],
        [ModifiedID],
        [ModifiedBy],
        [ModifiedColumn],
        [Modification],
        [ValueBefore],
        [ValueAfter]
    )
                        """).strip()

                        union_template: str = """
    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[{col}] IS NULL) AND ([C].[{col}] IS NOT NULL) THEN '{col}'
            WHEN ([I].[{col}] IS NULL) AND ([D].[{col}] IS NOT NULL) THEN '{col}'
            WHEN [D].[{col}] <> [C].[{col}] THEN '{col}'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[{col}] IS NULL) AND ([C].[{col}] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[{col}] IS NULL) AND ([D].[{col}] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[{col}] <> [C].[{col}] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[{col}] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[{col}] AS NVARCHAR(MAX)) AS [ValueAfter]
    FROM
        [{db_name}].[dbo].[{table_name}] [C]
    INNER JOIN
        INSERTED [I]
    ON
        [C].[ID] = [I].[ID]
    LEFT JOIN
        DELETED [D]
    ON
        [C].[ID] = [D].[ID]
    WHERE 
        (CASE
            WHEN ([D].[{col}] IS NULL) AND ([C].[{col}] IS NOT NULL) THEN 1
            WHEN ([I].[{col}] IS NULL) AND ([D].[{col}] IS NOT NULL) THEN 1
            WHEN [D].[{col}] <> [I].[{col}] THEN 1
            ELSE 0
        END) > 0                        
                        """
                        sql_hist_trig_lines = []

                        pk_col = None
                        default_values = []
                        bp_cols_copy = boilerplate_cols.copy()
                        has_clr_type: bool = False
                        for i, row in ct_data.iterrows():
                            ct_nc_pk = row["PK"]
                            ct_nc_name = row["Name"]
                            ct_nc_type = row["Type"]
                            ct_nc_size = row["Size"]
                            ct_nc_def = row["Default"]

                            try:
                                bp_cols_copy.remove(ct_nc_name)
                            except ValueError:
                                pass

                            ct_nc_pk = False if (pd.isna(ct_nc_pk) or (not ct_nc_pk)) else ct_nc_pk

                            if ct_nc_size == ct_size_options["str"][-1]:
                                ct_nc_size = "max"

                            # if not ct_cn_def:
                            #     ct_cn_def = "NULL"

                            if not has_clr_type:
                                # text, ntext, image, varchar(max), nvarchar(max), non - FILESTREAM, varbinary(max), xml or large CLR type columns.
                                has_clr_type = (ct_nc_type == "str") and (ct_nc_size == "max")

                            l_sql = ""

                            if ct_nc_def:
                                default_values.append((ct_nc_name, ct_nc_def))

                            st.write(f"{ct_nc_type=}")

                            match ct_nc_type:
                                case "str":
                                    if not ct_nc_pk:
                                        l_sql = f"\n\t[{ct_nc_name}] [nvarchar]({ct_nc_size}) NULL"
                                    else:
                                        # l_sql = f"\n\t[{ct_cn_name}] [nvarchar]({ct_nc_size}) IDENTITY(0, 1) NOT NULL"
                                        st.error(f"Cannot use {ct_nc_type} values as PKs. Feature coming soon")
                                case "date" | "datetime" | "bit" | "float":
                                    if not ct_nc_pk:
                                        l_sql = f"\n\t[{ct_nc_name}] [{ct_nc_type}] NULL"
                                    else:
                                        st.error(f"Cannot use {ct_nc_type} values as PKs.")
                                case "decimal":
                                    if not ct_nc_pk:
                                        a, b = eval(ct_nc_size)
                                        l_sql = f"\n\t[{ct_nc_name}] [{ct_nc_type}]({a}, {b}) NULL"
                                    else:
                                        st.error(f"Cannot use {ct_nc_type} values as PKs.")
                                case "int":
                                    if not ct_nc_pk:
                                        l_sql = f"\n\t[{ct_nc_name}] [int] NULL"
                                    else:
                                        l_sql = f"\n\t[{ct_nc_name}] [int] IDENTITY(0, 1) NOT NULL"
                                        pk_col = ct_nc_name
                                case _:
                                    st.error("UNSURE")

                            sql += f"\n\t{l_sql.strip()},"

                            sql_hist_trig_lines.append(
                                union_template.format(
                                    db_name=db_name,
                                    table_name=table_name,
                                    col=ct_nc_name
                                )
                            )

                        #                     sql += """
                        # [ID] [int] IDENTITY(0,1) NOT NULL,
                        # [DateCreated] [datetime] NULL,
                        # [LastModified] [datetime] NULL,
                        # [Active] [bit] NULL,
                        # [DateActive] [datetime] NULL,
                        # [DateInActive] [datetime] NULL,
                        #
                        # [NHLAPI_ID] [nvarchar](10) NULL,
                        #
                        # [Name] [nvarchar](255) NULL,
                        # [Description] [nvarchar](max) NULL,
                        # [Comments] [nvarchar](max) NULL,

                        sql = sql.removesuffix(",")

                        sql_hist_trig += "\n\tUNION ALL\n".join(sql_hist_trig_lines) + "\n\nEND"

                        # custom columns list for history table
                        sql_hist += "\n\t" + ("""
    [ID] [int] IDENTITY(0, 1) NOT NULL,
    [DateCreated] [datetime] NULL,
    [NestLevel] [int] NULL,
    [ModifiedID] [int] NULL,
    [ModifiedBy] [nvarchar](50) NULL,
    [ModifiedColumn] [nvarchar](512) NULL,
    [Modification] [nvarchar](50) NULL,
    [ValueBefore] [nvarchar](max) NULL, 
    [ValueAfter] [nvarchar](max) NULL
                                    """).strip()

                        # consider CLR type columns
                        clr_type = " ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]" if has_clr_type else ""
                        if pk_col:
                            sql += "\n\n\t" + (f"""
CONSTRAINT [PK_{table_name}] PRIMARY KEY CLUSTERED (
        [{pk_col}] ASC
    )
    WITH (
        PAD_INDEX = OFF,
        STATISTICS_NORECOMPUTE = OFF,
        IGNORE_DUP_KEY = OFF,
        ALLOW_ROW_LOCKS = ON,
        ALLOW_PAGE_LOCKS = ON
        --, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
    ) ON [PRIMARY]
){clr_type}
GO
                                    """).strip()
                        sql_hist += "\n\n\t" + (f"""
CONSTRAINT [PK_hist_{table_name}] PRIMARY KEY CLUSTERED (
        [ID] ASC
    )
    WITH (
        PAD_INDEX = OFF,
        STATISTICS_NORECOMPUTE = OFF,
        IGNORE_DUP_KEY = OFF,
        ALLOW_ROW_LOCKS = ON,
        ALLOW_PAGE_LOCKS = ON
        --, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
    ) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
                                """).strip()

                        # add columns with default values
                        for col, val in default_values:
                            val = val if str(val).strip().endswith("()") else f"({val})"
                            sql += "\n\n" + (f"""
IF (EXISTS (SELECT * 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE (([TABLE_SCHEMA] = 'dbo') 
    AND (TABLE_NAME = '{table_name}'))))
BEGIN
                                """).strip()
                            sql += f"\n\tALTER TABLE [dbo].[{table_name}] ADD CONSTRAINT [DF_{table_name}_{col}] DEFAULT ({val}) FOR [{col}];"
                            sql += "\nEND\nGO"

                        # add history column defaults
                        sql_hist += "\n\n" + (f"""
IF (EXISTS (SELECT * 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE (([TABLE_SCHEMA] = 'dbo') 
    AND (TABLE_NAME = 'hist_{table_name}'))))
BEGIN
                                """).strip()
                        sql_hist += f"\n\tALTER TABLE [dbo].[hist_{table_name}] ADD CONSTRAINT [DF_hist_{table_name}_DateCreated] DEFAULT (GETDATE()) FOR [DateCreated];"
                        sql_hist += "\nEND\nGO"

                        # code for table create
                        input_table_cols.subheader("Step 1  - CREATE TABLE")
                        input_table_cols.code(sql, language="sql", line_numbers=True)

                        if bp_cols_copy:
                            st.warning(
                                f"Cannot infer Boilerplate Trigger because traditional boilerplate cols: [{', '.join(bp_cols_copy)}] could not be found. Please use the 'Boilerplate button to ensure the correct naming conventions are used.'")
                        else:

                            # code for back-up table creation
                            input_table_cols.subheader("Step 2  - CREATE Back-up TABLE")
                            input_table_cols.code(sql_hist, language="sql", line_numbers=True)

                            sql_trig = f"""
USE [{db_name}]
GO

/****** Object:  Trigger [dbo].[tr_Update{table_name}BoilerPlate]    Script Date: {now:%Y-%m-%d %H:%M:%S} ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:\t\t<{user_name}>
-- Create date:\t<{now:%Y-%m-%d %H:%M:%S}>
-- Description:\t<Maintain Boilerplate Columns>
-- =============================================
CREATE TRIGGER [dbo].[tr_Update{table_name}BoilerPlate] 
ON [dbo].[{table_name}]
AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

UPDATE
    [{db_name}].[dbo].[{table_name}]
SET
    [LastModified] = GETDATE()
    , [DateCreated] = ISNULL([C].[DateCreated], GETDATE())
    , [DateActive] = (CASE 
        WHEN ([I].[Active] = 1) AND (([D].[Active] IS NULL) OR ([D].[Active] = 0)) THEN
            GETDATE()
        ELSE
            [C].[DateActive]
        END
    )
    , [DateInactive] = (CASE 
        WHEN ([I].[Active] = 0) AND (([D].[Active] IS NULL) OR ([D].[Active] = 1)) THEN
            GETDATE()
        ELSE
            [C].[DateInActive] 
        END
    )
FROM
    [{db_name}].[dbo].[{table_name}] [C]
INNER JOIN
    INSERTED [I]
ON
    [C].[ID] = [I].[ID]
LEFT JOIN
    DELETED [D]
ON
    [C].[ID] = [D].[ID]
;
END
                                    """.strip()

                            # code for boilerplate trigger creation
                            input_table_cols.subheader("Step 3  - CREATE Boilerplate TRIGGER")
                            input_table_cols.code(sql_trig, language="sql", line_numbers=True)

                            # code for history trigger creation
                            input_table_cols.subheader("Step 4  - CREATE History TRIGGER")
                            input_table_cols.code(sql_hist_trig, language="sql", line_numbers=True)
                    else:
                        st.warning(
                            "Please enter some column information first."
                        )

                #
#                 # default columns for Boilerplate info
#                 records = [
#                     {
#                         "Name": "ID",
#                         "Type": "int",
#                         "Size": None,
#                         "Default": None
#                     },
#                     {
#                         "Name": "DateCreated",
#                         "Type": "datetime",
#                         "Size": None,
#                         "Default": "GETDATE()"
#                     },
#                     {
#                         "Name": "LastModified",
#                         "Type": "datetime",
#                         "Size": None,
#                         "Default": None
#                     },
#                     {
#                         "Name": "Active",
#                         "Type": "bit",
#                         "Size": None,
#                         "Default": 1
#                     },
#                     {
#                         "Name": "DateActive",
#                         "Type": "datetime",
#                         "Size": None,
#                         "Default": None
#                     },
#                     {
#                         "Name": "DateInActive",
#                         "Type": "datetime",
#                         "Size": None,
#                         "Default": None
#                     }
#                 ]
#                 boilerplate_cols = [d["Name"] for d in records]
#
#                 # New Column template data
#                 ct_column_names = ["PK", "Name", "Type", "Size", "Default"]
#                 ct_type_options = ["str", "int", "decimal", "float", "date", "datetime", "bit"]
#                 ct_size_options = {
#                     "str": range(1, 6000001),
#                     "int": "na",
#                     "decimal": [f"{a_}, {b_})" for a_ in range(2, 19) for b_ in range(1, 18) if (a_ - 1) >= b_],
#                     "float": [f"({a_}, {b_})" for a_ in range(2, 19) for b_ in range(1, 18) if (a_ - 1) >= b_],
#                     "date": "na",
#                     "datetime": "na"
#                 }
#
#                 ct_text_db_name = input_table_cols.text_input(
#                     label="Database Name:",
#                     key=f"ct_text_db_name"
#                 )
#                 ct_text_table_name = input_table_cols.text_input(
#                     label="Table Name:",
#                     key=f"ct_text_table_name"
#                 )
#
#                 with input_table_cols.container(border=1):
#                     with st.popover(label="info"):
#                         st.write("Add these 6 boiler-plate identification columns to your table.")
#                         st.write("These exact column names are used when generating the associating triggers and backup table scripts.")
#                         st.code(("""
# [ID] [int] IDENTITY(0, 1) NOT NULL,
# [DateCreated] [datetime] NULL,
# [LastModified] [datetime] NULL,
# [Active] [bit] NULL,
# [DateActive] [datetime] NULL,
# [DateInActive] [datetime] NULL
#                             """).strip(),
#                             language="sql",
#                             line_numbers=True
#                         )
#                     if st.button(
#                         label="Add 6 Boilerplate cols"
#                     ):
#                         df_ct_nc = pd.DataFrame(
#                             data=records,
#                             columns=ct_column_names
#                         )
#                         df_ct_nc.loc[df_ct_nc["Name"] == "ID", "PK"] = 1
#                         st.session_state.update({
#                             "ct_data": df_ct_nc
#                         })
#                         st.rerun()
#
#                 input_table_cols.subheader("Columns:")
#                 if "ct_data" not in st.session_state:
#                     ct_data = pd.DataFrame(columns=ct_column_names)
#                     st.session_state.update({"ct_data": ct_data})
#                 else:
#                     ct_data = st.session_state.get("ct_data")
#
#                 # ct_input_table = input_table_cols[0].data_editor(
#                 #     data=pd.DataFrame(columns=ct_columns),
#                 #     column_config={
#                 #         "decimal": st.column_config.SelectboxColumn(
#                 #             "Size",
#                 #             options=ct_type_options
#                 #         )
#                 #     }
#                 # )
#
#                 def update_cb_pk(key: str, i: int):
#                     print(f"{key=}")
#                     for j, row in ct_data.iterrows():
#                         ct_data.loc[j, "PK"] = 1 if i == j else 0
#                         # if k != key:
#                         #     st.session_state.update({k: False})
#                         #     df_ct_nc.loc[df_ct_nc["index"] == i, "PK"] = 1
#                         # else:
#                         #     st.session_state.update({k: True})
#                         #     df_ct_nc.loc[df_ct_nc["index"] == i, "PK"] = 1
#                     st.session_state.update({
#                         "ct_data": ct_data
#                     })
#                     st.rerun()
#
#                 def update_cn(idx: int, direction: int):
#                     df = st.session_state.get("ct_data")
#                     a, b = (idx - 1, idx) if direction == -1 else (idx, idx + 1)
#                     df.loc[a], df.loc[b] = df.loc[b].copy(), df.loc[a].copy()
#                     df = df.reset_index(drop=True)
#                     st.session_state.update({"ct_data": df})
#
#                 def delete_cn(idx: int):
#                     df: pd.DataFrame = st.session_state.get("ct_data")
#                     # a, b = (idx - 1, idx) if direction == -1 else (idx, idx + 1)
#                     # df.loc[a], df.loc[b] = df.loc[b].copy(), df.loc[a].copy()
#                     df.drop(index=idx, inplace=True)
#                     df = df.reset_index(drop=True)
#                     st.session_state.update({"ct_data": df})
#
#                 def update_selectbox_size():
#                     size = st.session_state.get("ct_nc_select_box_size", "MAX")
#                     if size == "MAX":
#                         size = ct_size_options["str"][-1]
#                     st.session_state.update({
#                         "ct_nc_slider_size": int(size)
#                     })
#
#                 ct_columns = input_table_cols.columns(1 + len(ct_column_names), border=0)
#                 # input_table_cols.write("---")
#                 st.dataframe(ct_data)
#                 list_cb_pk_keys = []
#                 cont_height = 75
#                 for i, col in enumerate(ct_column_names, start=1):
#                     with ct_columns[i]:
#                         # container_btn_bar = st.container(height=25)
#                         with st.container(height=cont_height):
#                             st.write(col)
#                 with ct_columns[0]:
#                     with st.container(height=cont_height):
#                         st.empty()
#                 for i, row in ct_data.iterrows():
#                     ct_pk = row["PK"]
#                     ct_name = row["Name"]
#                     ct_type = row["Type"]
#                     ct_size = row["Size"]
#                     ct_def = row["Default"]
#
#                     ct_pk = 0 if pd.isna(ct_pk) else bool(ct_pk)
#                     with ct_columns[0]:
#                         # container_btn_bar = st.container(height=25)
#                         btn_bar = st.container(height=cont_height).columns(3, gap="small")
#                         if i > 0:
#                             btn_bar[0].button(
#                                 label="^",
#                                 key=f"ct_btn_col_up_{i}",
#                                 on_click=lambda i_=i: update_cn(i_, -1)
#                             )
#                         if i < ct_data.shape[0] - 1:
#                             btn_bar[1].button(
#                                 label="v",
#                                 key=f"ct_btn_col_down_{i}",
#                                 on_click=lambda i_=i: update_cn(i_, 1)
#                             )
#                         btn_bar[2].button(
#                             label="del",
#                             key=f"ct_btn_col_delete_{i}",
#                             type="primary",
#                             on_click=lambda i_=i: delete_cn(i_)
#                         )
#                         # st.write("CONTROLS")
#                     with ct_columns[1]:
#                         k = f"ct_nc_checkbox_pk_{i}"
#                         list_cb_pk_keys.append(k)
#                         st.session_state.update({k: ct_pk})
#                         with st.container(height=cont_height):
#                             st.checkbox(
#                                 label="pk",
#                                 key=k,
#                                 label_visibility="hidden",
#                                 on_change=lambda key_=k, i_=i: update_cb_pk(key_, i_)
#                             )
#                     with ct_columns[2]:
#                         with st.container(height=cont_height):
#                             st.write(ct_name)
#                     with ct_columns[3]:
#                         with st.container(height=cont_height):
#                             st.write(ct_type)
#                     with ct_columns[4]:
#                         with st.container(height=cont_height):
#                             st.write(ct_size)
#                     with ct_columns[5]:
#                         ct_def = None if not ct_def else ct_def
#                         with st.container(height=cont_height):
#                             st.write(ct_def)
#                     # input_table_cols.write(f"{i=}, {row=}")
#                 if ct_data.shape[0] == 0:
#                     input_table_cols.write("0 columns")
#                 # input_table_cols.write("---")
#
#                 ct_nc_editing: bool = st.session_state.get("ct_nc_editing", False)
#
#                 if ct_nc_editing or input_table_cols.button(
#                     label="Add Column",
#                     key=f"ct_btn_add_new_column"
#                 ):
#                     st.session_state.update({"ct_nc_editing": True})
#                     ct_nc_text_input_name = ct_columns[2].text_input(
#                         label="Name",
#                         key="ct_nc_text_input_name"
#                     )
#                     if st.session_state.get("ct_nc_text_input_name"):
#                         ct_nc_text_input_type = ct_columns[3].selectbox(
#                             label="Type",
#                             key="ct_nc_text_input_type",
#                             options=ct_type_options
#                         )
#                         ct_type = st.session_state.get("ct_nc_text_input_type")
#                         if ct_type:
#                             validator = ct_size_options[ct_type]
#                             size_key = ""
#                             if validator != "na":
#                                 if ct_type == "str":
#                                     size_key = "ct_nc_slider_size"
#                                     if "ct_nc_select_box_size" not in st.session_state:
#                                         st.session_state.update({
#                                             "ct_nc_select_box_size": "MAX"
#                                         })
#                                         update_selectbox_size()
#                                     ct_nc_slider_size = ct_columns[4].slider(
#                                         label="Size",
#                                         key=size_key,
#                                         min_value=validator[0],
#                                         max_value=validator[-1]
#                                     )
#                                     ct_nc_select_box_size = ct_columns[4].selectbox(
#                                         label="Size",
#                                         key="ct_nc_select_box_size",
#                                         options=["25", "50", "255", "511", "1023", "MAX"],
#                                         label_visibility="hidden",
#                                         on_change=update_selectbox_size
#                                     )
#                                 elif ct_type in ["float", "decimal"]:
#                                     size_key = "ct_nc_select_box_size"
#                                     ct_nc_select_box_size = ct_columns[4].selectbox(
#                                         label="Size",
#                                         key=size_key,
#                                         options=validator
#                                     )
#
#                             ct_default_text_input = ct_columns[5].text_input(
#                                 label="Default Value",
#                                 key="ct_default_text_input"
#                             )
#
#                             ct_save_new_column_disabled = False
#                             ct_nc_name = st.session_state.get("ct_nc_text_input_name")
#                             ct_nc_type = st.session_state.get("ct_nc_text_input_type")
#                             ct_nc_size = st.session_state.get(size_key)
#                             ct_nc_default = st.session_state.get("ct_default_text_input")
#
#                             if ct_nc_default:
#                                 if ct_nc_type in ("str", "float", "decimal"):
#                                     # check size of default
#                                     if len(ct_nc_default) > ct_nc_size:
#                                         input_table_cols.warning(
#                                             f"default value '{ct_nc_default}' cannot exceed the size '{ct_nc_size}'."
#                                         )
#                                 if ct_nc_type in ("int", "float", "decimal", "bit"):
#                                     # validate number types:
#                                     if not isnumber(ct_nc_default):
#                                         input_table_cols.warning(
#                                             f"default value '{ct_nc_default}' must be a number for this field."
#                                         )
#                                 if ct_nc_type in ("date", "datetime"):
#                                     # validate date types
#                                     date_val = is_date(ct_nc_default)
#                                     if ct_nc_default.lower() == "getdate()":
#                                         date_val = "GETDATE()"
#                                     elif date_val is None:
#                                         input_table_cols.warning(
#                                             f"default value '{ct_nc_default}' must be a date for this field."
#                                         )
#
#                             if input_table_cols.button(
#                                 label="save",
#                                 key=f"ct_save_new_column",
#                                 disabled=ct_save_new_column_disabled
#                             ):
#                                 record = {
#                                     "Name": st.session_state.get("ct_nc_text_input_name"),
#                                     "Type": st.session_state.get("ct_nc_text_input_type"),
#                                     "Size": st.session_state.get(size_key),
#                                     "Default": st.session_state.get("ct_default_text_input")
#                                 }
#                                 col_names = list(map(str.lower, ct_data["Name"].tolist()))
#                                 if ct_nc_name.lower() in col_names:
#                                     input_table_cols.warning(
#                                         f"Cannot insert another column with the name '{ct_nc_name}', only one instance per table."
#                                     )
#                                 else:
#                                     ct_data = pd.concat([
#                                         ct_data,
#                                         pd.DataFrame(data=[record], columns=ct_column_names)
#                                     ]).reset_index(drop=True)
#                                     st.session_state.update({
#                                         "ct_data": ct_data,
#                                         "ct_nc_editing": False
#                                     })
#                                     st.rerun()
#
#                 user_name = st.session_state.get("user_full_name", "FULL NAME")
#                 table_name = st.session_state.get("ct_text_table_name", "UNNAMED")
#                 db_name = st.session_state.get("ct_text_db_name", "UNNAMED")
#                 need_db_and_table_names = (not len(f"{db_name}".strip())) or (not len(f"{table_name}".strip()))
#
#                 if need_db_and_table_names:
#                     input_table_cols.warning("Please specify the Database and New Table Names above.")
#
#                 if input_table_cols.button(
#                     label="Generate SQL",
#                     key="ct_btn_generate_sql",
#                     disabled=need_db_and_table_names
#                 ):
#                     if ct_data.shape[0] > 0:
#                         now = datetime.datetime.now()
#                         sql = f"\n/****** Object:  Table [dbo].[{table_name}]    Script Date: {now:%Y-%m-%d %H:%M:%S} ******/"
#                         sql += "\n" + (f"""
# USE [{db_name}]
# GO
#
# SET ANSI_NULLS ON
# GO
#
# SET QUOTED_IDENTIFIER ON
# GO
#
#
# -- =============================================
# -- Author:\t\t<{user_name}>
# -- Create date:\t<{now:%Y-%m-%d %H:%M:%S}>
# -- Description:\t<Create Table [{db_name}].[dbo].[{table_name}]>
# -- =============================================
#                         """).strip()
#                         sql += "\n" + (f"""
# CREATE TABLE [dbo].[{table_name}] (
#                         """).strip()
#                         pk_col = None
#                         default_values = []
#                         bp_cols_copy = boilerplate_cols.copy()
#                         for i, row in ct_data.iterrows():
#                             ct_nc_pk = row["PK"]
#                             ct_nc_name = row["Name"]
#                             ct_nc_type = row["Type"]
#                             ct_nc_size = row["Size"]
#                             ct_nc_def = row["Default"]
#
#                             try:
#                                 bp_cols_copy.remove(ct_nc_name)
#                             except ValueError:
#                                 pass
#
#                             ct_nc_pk = False if (pd.isna(ct_nc_pk) or (not ct_nc_pk)) else ct_nc_pk
#
#                             if ct_nc_size == ct_size_options["str"][-1]:
#                                 ct_nc_size = "max"
#
#                             # if not ct_cn_def:
#                             #     ct_cn_def = "NULL"
#
#                             l_sql = ""
#
#                             if ct_nc_def:
#                                 default_values.append((ct_nc_name, ct_nc_def))
#
#                             match ct_nc_type:
#                                 case "str":
#                                     if not ct_nc_pk:
#                                         l_sql = f"\n\t[{ct_nc_name}] [nvarchar]({ct_nc_size}) NULL"
#                                     else:
#                                         # l_sql = f"\n\t[{ct_cn_name}] [nvarchar]({ct_nc_size}) IDENTITY(0, 1) NOT NULL"
#                                         st.error(f"Cannot use {ct_nc_type} values as PKs. Feature coming soon")
#                                 case "date" | "datetime" | "bit" | "float":
#                                     if not ct_nc_pk:
#                                         l_sql = f"\n\t[{ct_nc_name}] [{ct_nc_type}] NULL"
#                                     else:
#                                         st.error(f"Cannot use {ct_nc_type} values as PKs.")
#                                 case "decimal":
#                                     if not ct_nc_pk:
#                                         a, b = eval(ct_nc_size)
#                                         l_sql = f"\n\t[{ct_nc_name}] [{ct_nc_type}]({a}, {b}) NULL"
#                                     else:
#                                         st.error(f"Cannot use {ct_nc_type} values as PKs.")
#                                 case "int":
#                                     if not ct_nc_pk:
#                                         l_sql = f"\n\t[{ct_nc_name}] [int] NULL"
#                                     else:
#                                         l_sql = f"\n\t[{ct_nc_name}] [int] IDENTITY(0, 1) NOT NULL"
#                                         pk_col = ct_nc_name
#                                 case _:
#                                     st.error("UNSURE")
#
#                             sql += f"\n\t{l_sql.strip()},"
#
#                         #                     sql += """
#                         # [ID] [int] IDENTITY(0,1) NOT NULL,
#                         # [DateCreated] [datetime] NULL,
#                         # [LastModified] [datetime] NULL,
#                         # [Active] [bit] NULL,
#                         # [DateActive] [datetime] NULL,
#                         # [DateInActive] [datetime] NULL,
#                         #
#                         # [NHLAPI_ID] [nvarchar](10) NULL,
#                         #
#                         # [Name] [nvarchar](255) NULL,
#                         # [Description] [nvarchar](max) NULL,
#                         # [Comments] [nvarchar](max) NULL,
#
#                         sql = sql.removesuffix(",")
#
#                         if pk_col:
#                             sql += "\n\n\t" + (f"""
#     CONSTRAINT [PK_{table_name}] PRIMARY KEY CLUSTERED (
#         [{pk_col}] ASC
#     )
#     WITH (
#         PAD_INDEX = OFF,
#         STATISTICS_NORECOMPUTE = OFF,
#         IGNORE_DUP_KEY = OFF,
#         ALLOW_ROW_LOCKS = ON,
#         ALLOW_PAGE_LOCKS = ON
#         --, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
#     ) ON [PRIMARY]
# ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
# GO
#                             """).strip()
#
#                         for col, val in default_values:
#                             val = val if str(val).strip().endswith("()") else f"({val})"
#                             sql += f"\n\nALTER TABLE [dbo].[{table_name}] ADD CONSTRAINT [DF_{table_name}_{col}]  DEFAULT ({val}) FOR [{col}]\nGO"
#
#                         input_table_cols.code(sql, language="sql", line_numbers=True)
#
#                         if bp_cols_copy:
#                             st.warning(f"Cannot infer Boilerplate Trigger because Traditional boilerplate cols: [{', '.join(bp_cols_copy)}] could not be found. Please use the 'Boilerplate button to ensure the correct naming conventions are used.'")
#                         else:
#                             # if st.button(
#                             #     label="Generate Boilerplate Trigger",
#                             #     key=f"ct_btn_generate_boilerplate_trigger"
#                             # ):
#                             sql = f"""
# USE [{db_name}]
# GO
#
# /****** Object:  Trigger [dbo].[tr_Update{table_name}BoilerPlate]    Script Date: {now:%Y-%m-%d %H:%M:%S} ******/
# SET ANSI_NULLS ON
# GO
# SET QUOTED_IDENTIFIER ON
# GO
#
# -- =============================================
# -- Author:\t\t<{user_name}>
# -- Create date:\t<{now:%Y-%m-%d %H:%M:%S}>
# -- Description:\t<Maintain Boilerplate Columns>
# -- =============================================
# CREATE TRIGGER [dbo].[tr_Update{table_name}BoilerPlate]
# ON [dbo].[{table_name}]
# AFTER INSERT, DELETE, UPDATE
# AS
# BEGIN
#     -- SET NOCOUNT ON added to prevent extra result sets from
#     -- interfering with SELECT statements.
#     SET NOCOUNT ON;
#
#     -- Prevent recursive calls
#     IF TRIGGER_NESTLEVEL() > 1 BEGIN
#         RETURN;
#     END
#
#     UPDATE
#         [{db_name}].[dbo].[{table_name}]
#     SET
#         [LastModified] = GETDATE()
#         , [DateCreated] = ISNULL([C].[DateCreated], GETDATE())
#         , [DateActive] = (CASE
#             WHEN ([I].[Active] = 1) AND ([C].[Active] IS NULL OR [C].[Active] = 0) THEN
#                 GETDATE()
#             ELSE
#                 [C].[DateActive]
#             END
#         )
#         , [DateInactive] = (CASE
#             WHEN ([I].[Active] = 0) AND ([C].[Active] IS NULL OR [C].[Active] = 1) THEN
#                 GETDATE()
#             ELSE
#                 [C].[DateInactive]
#             END
#         )
#     FROM
#         [{db_name}].[dbo].[{table_name}] [C]
#     INNER JOIN
#         INSERTED [I]
#     ON
#         [C].[ID] = [I].[ID]
#     ;
#
#     /*
#     -- Set any deleted records to InActive
#     UPDATE
#         [{db_name}].[dbo].[{table_name}]
#     SET
#         [LastModified] = GETDATE()
#         , [DateInActive] = GETDATE()
#         , [Active] = 0
#     FROM
#         [{db_name}].[dbo].[{table_name}] [C]
#     INNER JOIN
#         DELETED [D]
#     ON
#         [C].[ID] = [D].[ID]
#     ;
#     */
#
# END
#                             """.strip()
#
#                             input_table_cols.code(sql, language="sql", line_numbers=True)
#                     else:
#                         st.warning(
#                             "Please enter some column information first."
#                         )

            else:

                if st.session_state.get("radio_query_type" != "SELECT"):
                    st.session_state.update({"radio_query_type": "SELECT"})
                    st.rerun()

                selectbox_table_0 = input_table_cols.selectbox(
                    label="Select a table:",
                    key="selectbox_table_0",
                    options=db_options_0
                )

                toggle_use_alias = input_table_cols.toggle(
                    label="Use Aliasing?",
                    key="toggle_use_alias"
                )

                if st.session_state.get("toggle_use_alias", True):
                    text_input_alias_0 = input_table_cols.text_input(
                        label="Alias: (SELECT * FROM [Table] AS #ALIAS#)",
                        key="text_input_alias_0",
                        placeholder="If left blank, the first letter of the table will be used."
                    )

                    toggle_use_join_0 = input_join_cols[0].toggle(
                        label="Add a JOIN?",
                        key="toggle_use_join_0"
                    )

                    if st.session_state.get("toggle_use_join_0", False):
                        db_options_1 = db_options_0.copy()
                        db_options_1.remove(selectbox_table_0)
                        cols_table_0 = get_cols(selectbox_table_0, selectbox_table_0)["COLUMN_NAME"].values.tolist()
                        radio_join_type_1 = input_join_cols[0].radio(
                            label="Join type:",
                            key="radio_join_type_1",
                            options=list_join_options,
                            horizontal=True
                        )
                        if st.session_state.get("radio_join_type_1") in ("LEFT", "RIGHT", "FULL"):
                            toggle_join_type_is_outer = input_join_cols[0].toggle(
                                label="OUTER",
                                key="toggle_join_type_is_outer"
                            )
                            input_join_cols[0].write(f":red[WARNING - OUTER JOINS are missing an appropriate WHERE CLAUSE. Coming soon -- 2024-12-04]")
                        if st.session_state.get("radio_join_type_1") != "CROSS":
                            selectbox_table_0_pk = input_join_cols[0].selectbox(
                                label="Primary Key(s)",
                                key="selectbox_table_0_pk",
                                options=cols_table_0
                            )
                        selectbox_table_1 = input_join_cols[1].selectbox(
                            label="Select a table:",
                            key="selectbox_table_1",
                            options=db_options_1
                        )
                        text_input_alias_1 = input_join_cols[1].text_input(
                            label="Alias for 1st JOINED Table",
                            key="text_input_alias_1",
                            placeholder="If left blank, the first letter of the table will be used."
                        )
                        cols_table_1 = get_cols(selectbox_table_1, selectbox_table_1)["COLUMN_NAME"].values.tolist()
                        if st.session_state.get("radio_join_type_1") != "CROSS":
                            selectbox_table_1_pk = input_join_cols[1].selectbox(
                                label="Primary Key(s)",
                                key="selectbox_table_1_pk",
                                options=cols_table_1
                            )
                    else:
                        selectbox_table_1 = ""

                else:
                    text_input_alias_0 = None

                if st.button(
                    label="RUN"
                ) and selectbox_table_0:
                    # st.code(
                    #     create_sql(
                    #         "Orders",
                    #         mode="update",
                    #         path_data={"Comments": None},
                    #         where="[Apples] = [Oranges]"
                    #     )
                    # )
                    # st.write(schema_parse("Orders"))
                    # st.write(schema_parse("[Orders]"))
                    # st.write(schema_parse("[dbo].[Orders]"))
                    # st.write(schema_parse("dbo.[Orders]"))
                    # st.write(schema_parse("dbo.Orders"))
                    # st.write(schema_parse("[dbo].Orders"))
                    # st.write(schema_parse("BWSdb.dbo.Orders"))
                    # st.write(schema_parse("[BWSdb].dbo.Orders"))
                    # st.write(schema_parse("BWSdb.[dbo].Orders"))
                    # st.write(schema_parse("BWSdb.dbo.[Orders]"))
                    # st.write(schema_parse("BWSdb.[dbo].[Orders]"))
                    # st.write(schema_parse("[BWSdb].[dbo].Orders"))
                    # st.write(schema_parse("[BWSdb].dbo.[Orders]"))
                    # st.write(schema_parse("[BWSdb].[dbo].[Orders]"))
                    # st.write(get_table_cols("Orders", "BWSdb"))
                    if text_input_alias_0 is not None:
                        # text_input_alias_0 = selectbox_table_0.split(".")[-1].removeprefix("[").removesuffix("]")
                        if not text_input_alias_0:
                            text_input_alias_0 = schema_parse(selectbox_table_0)[1][0]
                        if not selectbox_table_1:
                            code = select_with_alias(
                                selectbox_table_0,
                                alias=text_input_alias_0,
                            )
                        else:
                            if not text_input_alias_1:
                                text_input_alias_1 = schema_parse(selectbox_table_1)[1][0]
                            if radio_join_type_1 != "CROSS":
                                code = select_with_alias(
                                    [
                                        (selectbox_table_0, text_input_alias_0),
                                        (selectbox_table_1, text_input_alias_1)
                                    ],
                                    f_keys=(
                                        radio_join_type_1 + f" {'OUTER' if st.session_state.get('toggle_join_type_is_outer', False) else ''}".rstrip(),
                                        selectbox_table_0_pk,
                                        selectbox_table_1_pk
                                    )
                                )
                            else:
                                code = select_with_alias(
                                    [
                                        (selectbox_table_0, text_input_alias_0),
                                        (selectbox_table_1, text_input_alias_1)
                                    ]
                                )
                    else:
                        code = create_sql(
                            selectbox_table_0,
                            in_line=False,
                            fetch_cols=True
                        )
                    st.code(
                        code,
                        language="sql",
                        line_numbers=True
                    )

        if sm_tabs == sm_tab_names[-1]:
            st.write("Coming Soon!")


def access_maintenance():
    # databases = {
    #     "SysproCompanyA": {
    #         "key": "db_file_sysprocompanya"
    #         "path_data": st.session_state.get(""),
    #         "name": "SysproCompanyA.accdb"
    #     }
    # }
    # databases[]
    with grid["content_row_2"]:
        st.subheader("access_maintenance")

    databases = [
        'AccessOfDoom.accdb',
        'BWS Bunk Order Form.accdb',
        'BWS-CARs.accdb',
        'BWS-Defects.accdb',
        'BWS-Defects_BPF.accdb',
        'BWS-Defects_Parts_Snags.accdb',
        'BWS-Defects_Print.accdb',
        'BWS-Defects_Receiving.accdb',
        'BWS-Defects_Snags.accdb',
        'BWS-Direct Sales.mdb',
        'BWS-Eng v2.mdb',
        'BWS-Gen v2.mdb',
        'BWS-Jigs.accdb',
        'BWS-Prod v2.mdb',
        'BWS-Pur v2.mdb',
        'BWS-SalesV2.mdb',
        'BWS-SalesV3 (Standalone).mdb',
        'BWS-SalesV3.mdb',
        'BWS-SalesV4-RestoredNov23.mdb',
        'BWS-SalesV4.mdb',
        'BWS-SalesWOEmailHL.accdb',
        'BWS-SalesWOFCEmailHL.accdb',
        'BWS-Warranty.accdb',
        'BWSAdmin - Prod.accdb',
        'BWSAdmin Input.accdb',
        'BWSAdmin.accdb',
        'BWSSV5_Reports.accdb',
        'Defects_Receiving.accdb',
        'IT.accdb',
        'Jamie-HudTemplate V1.accdb',
        'SCStat_ExportWOPDF.accdb',
        'Security V1.accdb',
        'Stargate-SalesWOFCEmailHL.accdb',
        'Stargate-Warranty.accdb',
        'SYSPRO MRP Supplier Forecast.accdb',
        'SYSPRO Stock Code Lookup (Backflushing).accdb',
        'SysproCompanyA Branched May 2023.accdb',
        'SysproCompanyA Operation19 -- 202402121230.accdb',
        'SysproCompanyA.accdb',
        'SysproCompanyL.accdb',
        'SysproCompanyL_F2018.accdb',
        'SysproCompanyS.accdb',
        'SysproCompanyS_Backup.accdb',
        'SysproMultipleWOs_Live.accdb',
        'SysproMultipleWOs_Stargate_Live.accdb',
        'SysproMultipleWOs_Stargate_Test.accdb',
        'SysproMultipleWOs_Test.accdb',
        'SysproWOs_Live.accdb',
        'SysproWOs_Live_Backup.accdb',
        'SysproWOs_Live_Jamie.accdb',
        'SysproWOs_Live_Jeff.accdb',
        'SysproWOs_Live_Stargate.accdb',
        'SysproWOs_Stargate_Live.accdb',
        'SysproWOs_Stargate_Test.accdb',
        'SysproWOs_Test.accdb',
        'TaskTracker.accdb'
    ]
    databases = os.listdir(r"\\server3.bwsdomain.local\production")
    databases = [fn for fn in databases if any([fn.endswith(".mdb"), fn.endswith(".accdb")])]

    main_cols = st.columns(2)
    grid_db_btns = []
    grid_odbc_btns = []

    # download_buttons = []
    for i, db in enumerate(databases):
        db_spl = db.split(".")
        name = "".join(db_spl[:-1])
        key = f"db_file_{name.lower()}"
        toggle_key = f"toggle_db_{i}"
        data = st.session_state.get(key)
        if data is None:
            st.session_state.update({key: load_production_file(db)})
        # print(f"{i=}, {db=}, {name=}, {key=}")

        if data is not None:
            grid_db_btns.append(main_cols[0].columns([0.25, 0.25, 0.5]))
            grid_db_btns[i][0].toggle(
                label="select",
                key=toggle_key,
                label_visibility="hidden"
            )
            grid_db_btns[i][1].download_button(
                label=name,
                data=data,
                file_name=db,
                mime="application/octet-stream"
            )

    # if st.button(
    #     label="Create 'Update Access.bat' file",
    #     key="button_create_update_bat_file"
    # ):
    out_lines = []
    for i, db in enumerate(databases):
        toggle_key = f"toggle_db_{i}"
        if st.session_state.get(toggle_key, False):
            out_lines.append(fr'xcopy "\\SERVER3.bwsdomain.local\Production\{db}" c:\Access\*.* /Y')

    if out_lines:
        grid_db_btns[i][0].download_button(
            # label="download file",
            label="Download 'Update Access.txt'",
            data="\n".join(out_lines),
            file_name="Update Access.txt"
        )
        grid_db_btns[i][0].write(f":red[Please save this output file as '.bat' in order to execute it.]")
        grid_db_btns[i][0].write(f":red[This file type triggers suspicious download protocols, so .txt is the best delivery method.]")

    odbc_connection_dbs = [
        "BWSdb",
        "Stargatedb",
        "UniPointdb",
        "SysproCompanyA",
        "SysproCompanyS",
        "SysproCompanyL"
    ]
    for i, odbc_name in enumerate(odbc_connection_dbs):
        grid_odbc_btns.append(main_cols[1].columns([0.25, 0.25, 0.5]))
        key = f"db_file_{odbc_name.lower()}"
        toggle_key = f"toggle_odbc_{i}"
        grid_odbc_btns[i][0].toggle(
            label=odbc_name,
            key=toggle_key
            # ,
            # label_visibility="hidden"
        )

    out_lines_o = []
    for i, odbc_name in enumerate(odbc_connection_dbs):
        toggle_key = f"toggle_odbc_{i}"
        # dsn_name =
        if st.session_state.get(toggle_key, False):
            out_lines_o.append(fr'odbcconf.exe /a {{CONFIGDSN "SQL Server" "DSN={odbc_name}|Server=SERVER3"}}')

    if out_lines_o:
        grid_odbc_btns[i][0].download_button(
            # label="download file",
            label="Download: 'Connect ODBC.txt'",
            data="\n".join(out_lines_o),
            file_name="Connect ODBC.txt"
        )
        grid_odbc_btns[i][0].write(f":red[Please save this output file as '.bat' in order to execute it.]")
        grid_odbc_btns[i][0].write(f":red[This file type triggers suspicious download protocols, so .txt is the best delivery method.]")



def inventory_maintenance():
    def preprocess_image(image_path, alpha, beta, threshold):
        img = cv2.imread(image_path)
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        bright_contrast_img = cv2.convertScaleAbs(gray, alpha=alpha, beta=beta)
        _, thresholded = cv2.threshold(bright_contrast_img, threshold, 255, cv2.THRESH_BINARY)
        return bright_contrast_img, thresholded

    # File uploader
    uploaded_file = st.file_uploader("Upload a barcode image", type=["jpg", "jpeg", "png"])

    if uploaded_file:
        # Convert the uploaded file to an image
        image = Image.open(uploaded_file)
        width = 600
        st.image(image, caption="Original Image", use_column_width=True, width=width)

        temp_image_path = "temp_uploaded_image.jpg"
        image.save(temp_image_path)

        cols = st.columns(2)
        # Slider for tuning parameters
        alpha = cols[0].slider("Adjust Contrast (Alpha)", min_value=1.0, max_value=3.0, value=1.8, step=0.1)
        beta = cols[0].slider("Adjust Brightness (Beta)", min_value=0, max_value=100, value=40, step=5)
        threshold = cols[0].slider("Threshold Value", min_value=0, max_value=255, value=75, step=5)

        # Preprocess image
        bright_contrast_img, thresholded_img = preprocess_image(temp_image_path, alpha, beta, threshold)

        # Display preprocessed images
        cols[1].image(bright_contrast_img, caption="Brightness/Contrast Adjusted Image", use_column_width=True,
                 channels="GRAY", width=width)
        cols[1].image(thresholded_img, caption="Thresholded Image", use_column_width=True, channels="GRAY", width=width)

        if st.button(label="read"):

            # Decode the barcode
            barcodes_og = pyz.decode(image)
            barcodes_bc = pyz.decode(bright_contrast_img)
            barcodes_ti = pyz.decode(thresholded_img)
            if barcodes_og:
                st.write("Original Image:")
                for barcode in barcodes_og:
                    barcode_data = barcode.path_data.decode('utf-8')
                    barcode_type = barcode.type
                    st.write(f"**Barcode Data**: {barcode_data}")
                    st.write(f"**Barcode Type**: {barcode_type}")
            if barcodes_bc:
                st.write("Bright Image:")
                for barcode in barcodes_bc:
                    barcode_data = barcode.path_data.decode('utf-8')
                    barcode_type = barcode.type
                    st.write(f"**Barcode Data**: {barcode_data}")
                    st.write(f"**Barcode Type**: {barcode_type}")
            if barcodes_ti:
                st.write("Threshold Image:")
                for barcode in barcodes_ti:
                    barcode_data = barcode.path_data.decode('utf-8')
                    barcode_type = barcode.type
                    st.write(f"**Barcode Data**: {barcode_data}")
                    st.write(f"**Barcode Type**: {barcode_type}")
            if not any([barcodes_og, barcodes_bc, barcodes_ti]):
                st.error("No barcodes detected in any of the images.")

    # def isolate_black_on_red(image_path):
    #     """
    #     Preprocess an image to enhance contrast and brightness in grayscale for better barcode decoding.
    #
    #     Args:
    #         image_path (str): Path to the image file.
    #
    #     Returns:
    #         np.ndarray: Preprocessed grayscale image for barcode decoding.
    #     """
    #     # Load the image
    #     img = cv2.imread(image_path)
    #
    #     # Convert to grayscale
    #     gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    #
    #     # Increase brightness and contrast
    #     bright_contrast_img = cv2.convertScaleAbs(gray, alpha=1.8, beta=40)
    #
    #     # Apply Gaussian blur to reduce noise
    #     blurred = cv2.GaussianBlur(bright_contrast_img, (5, 5), 0)
    #
    #     return blurred
    # # # def isolate_black_on_red(image_path):
    # # #     """
    # # #     Enhance an image to isolate black text on red background for better barcode decoding.
    # # #
    # # #     Args:
    # # #         image_path (str): Path to the image file.
    # # #
    # # #     Returns:
    # # #         np.ndarray: Preprocessed image for barcode decoding.
    # # #     """
    # # #     # Load the image
    # # #     img = cv2.imread(image_path)
    # # #
    # # #     # Split the image into BGR channels
    # # #     blue, green, red = cv2.split(img)
    # # #
    # # #     # Enhance black text on red by subtracting blue and green from red
    # # #     enhanced = cv2.subtract(red, cv2.add(blue, green))
    # # #
    # # #     # Normalize brightness to increase visibility
    # # #     brightened = cv2.convertScaleAbs(enhanced, alpha=1.5, beta=30)
    # # #
    # # #     # Apply Gaussian blur to smoothen the image
    # # #     blurred = cv2.GaussianBlur(brightened, (5, 5), 0)
    # # #
    # # #     # Convert to grayscale
    # # #     gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    # # #
    # # #     # Combine enhanced red channel and grayscale for better contrast
    # # #     combined = cv2.addWeighted(blurred, 0.8, gray, 0.2, 0)
    # # #
    # # #     # Apply a lower threshold for binarization
    # # #     _, thresholded = cv2.threshold(combined, 75, 255, cv2.THRESH_BINARY)
    # # #
    # # #     return thresholded
    # # def isolate_black_on_red(image_path):
    # #     """
    # #     Enhance an image to isolate black text on red background for better barcode decoding.
    # #
    # #     Args:
    # #         image_path (str): Path to the image file.
    # #
    # #     Returns:
    # #         np.ndarray: Preprocessed image for barcode decoding.
    # #     """
    # #     img = cv2.imread(image_path)
    # #
    # #     # Split the image into BGR channels
    # #     blue, green, red = cv2.split(img)
    # #
    # #     # Enhance black text on red by subtracting blue and green from red
    # #     enhanced = cv2.subtract(red, cv2.add(blue, green))
    # #
    # #     # Convert to grayscale
    # #     gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    # #
    # #     # Combine enhanced and grayscale for better contrast
    # #     combined = cv2.addWeighted(enhanced, 0.7, gray, 0.3, 0)
    # #
    # #     # Apply thresholding to binarize
    # #     _, thresholded = cv2.threshold(combined, 128, 255, cv2.THRESH_BINARY)
    # #
    # #     return thresholded
    #
    #
    # # Step 1: Upload the image
    # uploaded_file = st.file_uploader("Upload a barcode image", type=["jpg", "jpeg", "png"])
    #
    # if uploaded_file:
    #     st.write("Processing..")
    #     # Step 2: Open the image
    #     image = Image.open(uploaded_file)
    #     st.image(image, caption="Original Image", use_column_width=True)
    #
    #     # Save uploaded file to a temporary location for OpenCV processing
    #     temp_image_path = fr"C:\Access\Streamlit\barcode_test_images\temp_uploaded_image_{datetime.datetime.now():%Y%m%d%H%M%S}.jpg"
    #     image.save(temp_image_path)
    #
    #     # Step 2: Preprocess the image to enhance black on red
    #     preprocessed_image = isolate_black_on_red(temp_image_path)
    #
    #     # Display the preprocessed image
    #     st.image(preprocessed_image, caption="Preprocessed Image", use_column_width=True)
    #
    #     # Step 3: Decode the barcode
    #     barcodes_og = pyz.decode(image)
    #     barcodes_pp = pyz.decode(preprocessed_image)
    #
    #     if barcodes_og:
    #         st.write("Original Image parsed barcodes:")
    #         for barcode in barcodes_og:
    #             barcode_data = barcode.path_data.decode('utf-8')  # Decode the barcode path_data
    #             barcode_type = barcode.type
    #             st.write(f"**Barcode Data**: {barcode_data}")
    #             st.write(f"**Barcode Type**: {barcode_type}")
    #     if barcodes_pp:
    #         st.write("Processed Image parsed barcodes:")
    #         for barcode in barcodes_pp:
    #             barcode_data = barcode.path_data.decode('utf-8')  # Decode the barcode path_data
    #             barcode_type = barcode.type
    #             st.write(f"**Barcode Data**: {barcode_data}")
    #             st.write(f"**Barcode Type**: {barcode_type}")
    #     if (not barcodes_og) and (not barcodes_pp):
    #         st.error("No barcode detected in either the original nor the processed image.")


class Tags(enum.Enum):

    # Languages
    PYTHON: str = "python"
    VBA: str = "vba"
    SQL: str = "sql"

    # Data Structures
    LISTS: str = "lists"
    DATES: str = "dates"
    PDFS: str = "pdfs"

    # Environments
    STREAMLIT: str = "Streamlit"
    SHELL: str = "shell"

    # Record Handling
    LOOKUP: str = "lookup"
    RECORDSET: str = "recordset"

    # Utility Files
    ARRAY_UTILITY: str = "array_utility"
    DICTIONARY_UTILITY: str = "dictionary_utility"
    RECORDSET_UTILITY: str = "recordset_utility"
    PYTHON_UTILITY: str = "python_utility"
    DATE_UTILITY: str = "date_utility"

    # Other
    BUILT_IN: str = "built_in"
    ON_GITHUB: str = "on_GitHub"
    ON_STACKOVERFLOW: str = "on_StackOverFlow"
    THIRD_PARTY: str = "third_party"

    def __str__(self):
        return self.value.replace("_", " ").title()

    def __repr__(self):
        return self.value.replace("_", " ").title()

def code_samples():

    # TEMPLATE
    # {
    #     "name": """""",
    #     "code": """""",
    #     "desc": """""",
    #     "warn": """""",
    #     "date": datetime.datetime()
    #     "tags": [],
    # }

    access_samples = [
        {
            "name": """DLookup""",
            "code": """
' Example 1  => Returns the [Name] value from table [ITRCustomers] where the [CustomerID] = 4 => 'Avery Briggs'
MsgBox DLookup("[Name]", "[ITRCustomers]", "[CustomerID] = 4")

' Example 2 => Runtime Error because [Name2] is not a valid column name in table [ITRCustomers]
MsgBox DLookup("[Name2]", "[ITRCustomers]", "[CustomerID] = 4")
            """,
            "desc": """
Use DLookup to retrieve a single value from a table given some criteria (Optional).
            """,
            "warn": """
This function only returns a single value. If you need more than 1 value from that record it is best to use a Recordset object, or another method.
            """,
            "tags": [Tags.BUILT_IN, Tags.LOOKUP],
            "date": datetime.datetime(2025, 2, 10, 17)
        },
        {
            "name": """RSFetch""",
            "code": """
Dim rs As DAO.Recordset
Set rs = CurrentDb.OpenRecordset("ITPersonnel", dbOpenSnapshot)

' Use FindFirst to navigate to a desired record.
' This criteria will filter for a [Name] matching "avery"
rs.FindFirst "[Name] = 'avery'"

Dim useAccessAlias As Boolean
Dim accessAliasFullName As String
Dim accessAliasWindowsUser As String

' Best practice to ensure you have a valid record after calling FindFirst
If Not rs.NoMatch Then
    
    ' Cast [UseAccessAlias] as a boolean using castType, supports strings and function names ("int", "cint", "cdate", vbdate, etc...)
    useAccessAlias = RSFetch(rs, "UseAccessAlias", castType:=vbBoolean)
    
    ' use wrapStrings set to False to 'unwrap' the strings returned. By default rsfetch will place '"' characters around strings.
    accessAliasFullName = RSFetch(rs, "AccessAliasFullName", wrapStrings:=False)
    accessAliasWindowsUser = RSFetch(rs, "AccessAliasWindowsUser", wrapStrings:=False)

.
.
.
            """,
            "desc": """
Return the value for a given column in a recordset.
Similar in function to using native DAO.Recordset(0) or DAO.Recordset(COLUMN_NAME)
Optionally supports indexed positional lookup if an integer is passed as 'ColName' param.
    Optional features:
    Value-casting,
    Null-value replacement,
    String-wrapping,
    Empty string considered Null
    Errors when values not found
            """,
            "warn": """""",
            "tags": [Tags.LOOKUP, Tags.RECORDSET, Tags.RECORDSET_UTILITY],
            "date": datetime.datetime(2025, 2, 10, 17)
        },
        {
            "name": """ExecPython""",
            "code": r"""

#######################################################################################################################                   
    ' Partial Contents of ExecPython:
    ' !! WARNING !!
    
    ' Use absolute paths for parameters
    ' Ensure all paths in python script are using absolute pathing.
    
    ' Recommended to use some kind of failsafe around the whole program, otherwise a failure will only be reported for a fraction of a second before the window collapses.
    
    '   Example implementation:
    '
    '
    '   import_success:     bool = False
    '   try:
    '       Import os
    '       Import Datetime
    '
    '       Import pdfplumber
    '       from PyPDF2 import PdfMerger
    '
    '       from utility import next_available_file_name
    '
    '   import_success = True
    '
    '   except(ModuleNotFoundError, ImportError) As E:
    '       print(f"\nImport Errors:")
    '       print(f"{e}")
    '
    '
    '   if __name__ == "__main__":

    '       if import_success:
    '           # Do stuff
    '
    '
    '   input("Hit 'Enter' to quit.")
    ' 
#######################################################################################################################
            
            
' This python script is designed to read a text file with an address as it's contents, then write another text file with the calculated GPS coordinates for the given address.
#######################################################################################################################
        Contents of 'read_location_demo_txt.py'
#######################################################################################################################
from location_utility import address_to_coords

address_file = r"C:\Access\location_output_demo.txt"
coords_file = r"C:\Access\location_output_demo_coords.txt"


if __name__ == '__main__':

    with open(address_file, "r") as f:
        address_lines = f.readlines()
        addresses = {}
        for i, line in enumerate(address_lines):
            print(f"{i=}, {line=}")
            address = line.strip()
            addresses[address] = address_to_coords(address)

    with open(coords_file, "w") as f:
        for address, coords in addresses.items():
            f.write(str(coords))
#######################################################################################################################


Dim strPath As String
Dim Loc As String
' Ask for an address
Loc = InputBox("Enter an address")
strPath = "C:\Access\location_output_demo.txt"

If Loc = "" Then
    MsgBox "Please enter a valid address."
    Exit Sub
End If

Printf "Address <" & Loc & ">"
' Write the address to a file to be read in python
Call WriteFile(Loc, strPath)
    
Dim sCoords As String
Dim scriptPath As String
scriptPath = "C:\Users\abriggs\Documents\BWS\StreamlitApp\Final Costing\Final Costing\read_location_demo_txt.py"
Call ExecPython(scriptPath)

' Read the output file from the python program
sCoords = ReadFile(coordsPath)
Printf "CONTENTS <" & sCoords & ">"
            """,
            "desc": """
Function designed to facilitate Shell commands when interacting with python interpreters and files.
Pass the absolute file path of a python script to have its contents executed.
            """,
            "warn": """
Use absolute paths for parameters
Ensure all paths in python script are using absolute pathing.
Optionally pass the absolute path to an interpreter, or have it looked up using a naive approach (see FindPythonPath)
Also choose how the terminal window is displayed. By default it will have normal focus. 
            """,
            "tags": [Tags.PYTHON, Tags.SHELL, Tags.PYTHON_UTILITY],
            "date": datetime.datetime(2025, 2, 10, 17)
        },
        {
            "name": """Scripting.Dictionary""",
            "code": """
Set q = Dictionary("a", 1, "b", 2)
Printf(q) ' => {'a': 1, 'b': 2}
            
Set w = Dictionary()
w(0) = "Avery"
w(1) = "is"
w(2) = "cool"
w(3) = "!"
Set teams = Dictionary()
teams("A") = 1
teams("B") = Array(-2, -1)
teams("C") = Array(-2, "-1")
teams("D") = "15"
teams("E") = True
teams("F") = -9.992
teams("G") = &H12
' ' teams("H") = w  ' failure, no nested dictionaries

Call PrintDict(teams, inLine:=False)
' {
'   'A': 1,
'   'B': [-2, -1],
'   'C': [-2, '-1'],
'   'D': '15',
'   'E': True,
'   'F': -9.992,
'   'G': 18
' }
            """,
            "desc": """
Wrapper 'class' for a sudo-dictionary in VBA.
            
' https://stackoverflow.com/questions/46013120/whats-a-very-simple-way-to-enter-key-value-pairs-in-vba
' We then add items to the dictionary using the 'Add' method,
'   where each item consists of a key-value pair.
'   We can access the values by providing the corresponding keys.
' The 'Exists' method is used to check if a specific key exists in the dictionary.
'   We can loop through all the keys using the Keys property and access the
'   corresponding values using the keys.
' The 'Remove' method allows us to remove a specific item from the dictionary,
'   and the 'Count' property gives us the number of items in the dictionary.
' Finally, we can clear all items from the dictionary using the 'RemoveAll' method.
' Remember to add a reference to the "Microsoft Scripting Runtime" library
'   in your VBA project for the Scripting.Dictionary object to be available.
            """,
            "warn": """""",
            "tags": [Tags.DICTIONARY_UTILITY, Tags.ON_STACKOVERFLOW],
            "date": datetime.datetime(2025, 2, 10, 17)
        },
        {
            "name": """DateFormat""",
            "code": """
dateformat(#2024-06-12#)              ' => "Wednesday June 12th 2024"
dateformat(#2024-06-12#, 1)           ' => "Wednesday, June 12th, 2024"
dateformat(#2024-06-12#, 2)           ' => "Wednesday, June 12th"
dateformat(#2024-06-12#, 3)           ' => "Wednesday June 12th"
printf(dateformat(#2024-06-12#, -1))  ' => "['Wednesday', 'June', '12th', 2024]"
            """,
            "desc": """
Retrieve a date formatted as a string.
You may also just return the values.

Supports 5 modes using integer codes [-1, 0, 1, 2, 3]
            """,
            "warn": """""",
            "tags": [Tags.DATES, Tags.DATE_UTILITY],
            "date": datetime.datetime(2025, 2, 10, 17)
        },
        {
            "name": """Array Utility""",
            "code": """

Dim q As Variant
Dim r As Variant
Dim t As Variant
q = Array(True, True, True)
r = Array(True, True, True, False)
t = Array(True, True, True, Array())

' Appending one array to another, by default this will place every element in 'r' into 'q'
Call Append(q, r)  ' [True, True, True, True, True, True, False] NOT [True, True, True, [True, True, True, False]]

printf "ALL q => T <" & All(q) & ">"  ' True
printf "ALL r => F <" & All(r) & ">"  ' True
printf "ALL q => F <" & All(q) & ">"  ' False
printf "ALL t => F <" & All(t) & ">"  ' False

printf "ANY q => T <" & Any_(q) & ">"  ' True
printf "ANY r => F <" & Any_(r) & ">"  ' True
printf "ANY q => F <" & Any_(q) & ">"  ' True
printf "ANY t => F <" & Any_(t) & ">"  ' True


printarr ifori("a", 10)  ' => ['a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a']
printarr ifori(array(), 10)  ' => [[], [], [], [], [], [], [], [], [], []]
printf ifori("randomhex()", 5, isfunc:=true)  ' ['#B48894', '#4A4DC6', '#04C2D0', '#B50C6A', '#DCCA5F']

' Function 'Slice' is used as a work-around for array slicing.
q = Array(1, 6, 7, 2, 9, 4, 3, 8, 5, 6, 1, 2, 1, 7, 8, 4, 6, 5, 3, 2, 1, 5, 4, 6, 9, 7, 8, 4, 5, 1, 2, 5, 4, 6, 7)
r = map("cstr", Array(1, 6, 7, 2, 9, 4, 3, 8, 5, 6, 1, 2, 1, 7, 8, 4, 6, 5, 3, 2, 1, 5, 4, 6, 9, 7, 8, 4, 5, 1, 2, 5, 4, 6, 7))
t = append(q, -1)
p = Array(-5, -6, -7)
w = append(q, p)
Call printArr(Slice(q, 4, 0, -1), name:="Slice Test1")  ' => [9, 2, 7, 6]
Call printArr(Slice(q, 0, 4, 2), name:="Slice Test2", inLine:=False)  ' => [1, 7, 9]
Call printArr(Slice(q, -1, 14, 3), name:="Slice Test3")  ' => []
Call printArr(Slice(q, 1, 14, 3), name:="Slice Test4")  ' => [6, 9, 8, 1, 7]
Call printArr(Slice(q), name:="Slice Test5")  ' => [1, 6, 7, 2, 9, 4, 3, 8, 5, 6, 1, 2, 1, 7, 8, 4, 6, 5, 3, 2, 1, 5, 4, 6, 9, 7, 8, 4, 5, 1, 2, 5, 4, 6, 7, -5, -6, -7]
Call printArr(Slice(q), name:="Slice Test6")  ' => [1, 6, 7, 2, 9, 4, 3, 8, 5, 6, 1, 2, 1, 7, 8, 4, 6, 5, 3, 2, 1, 5, 4, 6, 9, 7, 8, 4, 5, 1, 2, 5, 4, 6, 7, -5, -6, -7]
Call printArr(Slice(q, start_:=5), name:="Slice Test6")  ' => [1, 6, 7, 2, 9]
Call printArr(Slice(q, end_:=5), name:="Slice Test7")  ' => [4, 3, 8, 5, 6, 1, 2, 1, 7, 8, 4, 6, 5, 3, 2, 1, 5, 4, 6, 9, 7, 8, 4, 5, 1, 2, 5, 4, 6, 7, -5, -6]
Call printArr(Slice(q, step_:=5), name:="Slice Test8")  ' => [1, 4, 1, 4, 1, 7, 2, -5]
            """,
            "desc": """
The Array Utility file was created to mimic several list-oriented functions that exist in python.
These functions are designed to work EXACTLY as the python versions do.
There will be an inherent weakness compared to python's implementations as I cannot take advantage of lazy-processing like generators.
These functions do work well for small to medium sized lists.

Functions List:

'   All                     -   Returns True if all elements are condisdered true values.
'   Any_                    -   Returns True if any element is condisdered a true value. Uses short-circuiting.
'   Append                  -   Adds an element to an array in place, also returns the array.
'   ArrayEqual              -   Determine if two arrays have matching elements in value, type, and order.
'   Average                 -   Determine the average of numerical arrays.
'   Copy                    -   Return a copy of an array.
'   Count                   -   Count how many occurences of an element occur in an array, string or dictionary object.
'   Enumerate               -   Return a 2D array of list elements with their indexes. Think Python's enumerate function.
'   IForI                   -   Return a quick array of n elements of value v.
'   Insert                  -   Insert an element into an array using an index.
'   Index                   -   Return the index of element, or a list of elements in an array.
'   IsArrayEmpty            -   Determine if array is empty, uses error block and ubound.
'   IsIn                    -   Determine whether an element exists in an array. Optionally return it's index.
'   Map                     -   Return an array after calling a function on each element using eval.
'   Max                     -   Determine the maximum from an array or a list of arguments.
'   Min                     -   Determine the minimum from an array or a list of arguments.
'   Mode                    -   Determine the most common elements in an array.
'   PrintArr                -   Print and or obtain a string representation for an array.
'   Range                   -   Return an array of integers in sequence using bounds and a step.
'   Remove                  -   Removes an element from an in array in place, also returns the array. Optionally fails if target not found.
'   Reverse                 -   Return a copy of an array in reverse.
'   Slice                   -   Return a slice of an array using indices and a step. Modeled after python's slicing approach.
'   Sorted                  -   Return a sorted array or string. Modeled after python's sorted function.
'   Str2Array               -   Convert a string to an array.
'   Sum                     -   Determine the sum from an array or a list of arguments.
'   Zip                     -   Take 2 arrays and return a zipped list of elements at the same indexes.
            """,
            "warn": """Please see the source file for more examples.""",
            "tags": [Tags.ARRAY_UTILITY, Tags.PYTHON, Tags.LISTS],
            "date": datetime.datetime(2025, 2, 10, 17)
        },
        {
            "name": """Eval""",
            "code": """""",
            "desc": """
Rules for Eval:
The EXPRESSION MUST BE ABLE TO CONVERT TO A STRING object.
The expression being evaluated will be treated as generic VBA code - NO NESTED NON-NATIVE FUNCTION CALLING
Eval does not work properly in the immediate window. You must test using Script.
            """,
            "warn": """""",
            "tags": [Tags.BUILT_IN],
            "date": datetime.datetime(2025, 2, 10, 17)
        }
    ]

    python_samples = [
        {
            "name": """Streamlit_pdf_viewer""",
            "code": r"""
# normal imports
import os

# aliases
import streamlit as st

# 3rd-party modules
from streamlit_pdf_viewer import pdf_viewer


# Constants
# -  session_state not required (yet)
pdf_width = 1200
pdf_height = 600
root_pdf_folder = r"\\server4.bwsdomain.local\Design\DRAWINGS\Promos\9E) PROMOS BY MODEL 2025\Tags (2025)"


# First section of a streamlit Application
# this line can only be called once, and should be called at the beginning.
st.set_page_config(
	layout="wide",
	page_title="Streamlit Demo"
)


# Helper Functions


@st.cache_data(ttl=None, show_spinner=True)
def load_pdfs():
	# Function stores the list of pdfs in the cache, making successive reruns go faster.
	return [
		file
		for file in os.listdir(root_pdf_folder)
		if file.lower().endswith(".pdf")
	]


@st.cache_data(ttl=None, show_spinner=True)
def load_pdf_binary(pdf_file):
	# Handle opening and reading of the pdf file, caching the results.
	with open(pdf_file, "rb") as f:
		return f.read()


# Begin streamlit widgets
if not os.path.exists(root_pdf_folder):
	# check folder exists before proceeding
	st.error(NotADirectoryError(f"Could not find '{root_pdf_folder}'."))
	st.stop()


# Gather data
# for a small dataset, looping the folder everytime is fine
# pdf_files = [
# 	file
# 	for file in os.listdir(root_pdf_folder)
# 	if file.lower().endswith(".pdf")
# ]
# for larger datasets, the data should be cached.
pdf_files = load_pdfs()


if pdf_files:

	# maintain keys as variables to save typing and typos.
	k_selectbox_file = f"k_selectbox_file"
	selectbox_file = st.selectbox(
		label="Choose a File:",
		placeholder="select a file",
		key=k_selectbox_file,
		options=pdf_files
	)

	# Use safe accessors to st.session_state to maintain variable integrity
	# st.session_state[k_selectbox_file]  may produce KeyError or return None
	pdf_name = st.session_state.get(k_selectbox_file, "")

	if pdf_name:
		pdf_path = os.path.join(root_pdf_folder, pdf_name)
		file_binary = load_pdf_binary(pdf_path)
		st.write(pdf_path)

		# Some widgets have unexpected behaviour when interacting with the session_state.
		# This widget in-particular will display the same PDF despite receiving a new binary.
		# removing the key returns the widget to normal functionality.
		# k_pdf_viewer = f"k_pdf_viewer"
		st_pdf_viewer = pdf_viewer(
			input=file_binary,
			width=pdf_width
			# , key=k_pdf_viewer
		)
	else:
		st.write(f"Select a PDF file first.")
else:
	# Tell user no files were found, the pdf_viewer and selectbox widgets are not even rendered here.
	st.info(f"No PDF files were found in this folder '{root_pdf_folder}'.")
            """,
            "desc": """
Sample code to show how to use a pdf_viewer widget in streamlit.
            """,
            "warn": """
3rd-part widget - has weird interaction with the session_state
            """,
            "tags": [Tags.STREAMLIT, Tags.THIRD_PARTY, Tags.PDFS, Tags.ON_GITHUB],
            "date": datetime.datetime(2025, 2, 10, 17)
        }
    ]

    list_of_tags = list(map(str, list(Tags)))

    samples = {
        Tags.VBA: access_samples,
        Tags.PYTHON: python_samples
    }

    for k in samples:
        if str(k) not in list_of_tags:
            # print(f"ADDING {k=}")
            list_of_tags.insert(0, str(k))
        for sample in samples[k]:
            if k in sample["tags"]:
                # print(f"REMOVING {k=}")
                sample["tags"].remove(k)
            sample["tags"].insert(0, k)
            for k2 in sample["tags"]:
                if str(k2) not in list_of_tags:
                    # print(f"ADDING {k2=}")
                    list_of_tags.append(str(k2))

    key = f"ms_tag_choices"
    c_key = f"c_ms_tag_choices"
    if st.session_state.get(c_key) is not None:
        # print(f"INSERT {st.session_state.get(c_key)}")
        st.session_state.update({
            key: st.session_state.get(c_key),
            c_key: None
        })

    st.session_state.setdefault(key, list_of_tags)
    st.session_state.setdefault("samples_expanded", False)

    cols_tags = st.columns([0.15, 0.85], border=True)

    # def click_tag():
    #     st.session_state.update({key: [tag]})

    with cols_tags[0]:
        if st.button(
            label="all",
            key=f"btn_add_all_tags"
        ):
            st.session_state.update({key: list_of_tags})
        if st.button(
            label="none",
            key=f"btn_remove_all_tags"
        ):
            st.session_state.update({key: []})
        if st.button(
            label="expand all",
            key=f"btn_expand_all_samples"
        ):
            st.session_state.update({"samples_expanded": True})
        if st.button(
            label="collapse all",
            key=f"btn_collapse_all_samples"
        ):
            st.session_state.update({"samples_expanded": False})
    with cols_tags[1]:
        ms_tag_choices = st.multiselect(
            label="Tags",
            key=key,
            options=list_of_tags
        )

    # print(f"NEW == {datetime.datetime.now():%x %X}")
    for lang, samples_list in samples.items():
        for i, data in enumerate(samples_list):
            name = data["name"]
            code = data["code"]
            desc = data["desc"]
            warn = data["warn"]
            tags = data["tags"]
            date = data["date"]
            # # if any tag in 'ms_tags_choices' are in 'tags', then show sample
            # print(f"{lang=}, {i=}, {tags=}, {set(tags)=}, {set(ms_tag_choices)=}, A={set(tags).difference(set(ms_tag_choices))}, len(A)={len(set(tags).difference(set(ms_tag_choices)))}, B={len(tags)}, C={len(set(tags).difference(set(ms_tag_choices))) != len(tags)}")
            # # if len(set(tags).difference(set(ms_tag_choices))) != len(tags):
            # # if len(set(tags).difference(set(ms_tag_choices))) != 0:
            a_ = set(ms_tag_choices)
            b_ = set(map(str, tags))
            # print(f"{a_=}, {b_=}, {a_.intersection(b_)=}")
            if len(a_.intersection(b_)) > 0:
                with st.expander(name, expanded=st.session_state.get("samples_expanded", False)):
                    if "\n" in desc:
                        lines = list_to_html(
                            desc.lstrip().rstrip().split("\n"),
                            is_ordered=False,
                            is_raw=True
                        )
                        st.markdown(lines[0], unsafe_allow_html=True)
                        st.markdown(lines[1], unsafe_allow_html=True)
                    else:
                        st.write(desc)
                    st.code(code, language=str(lang), line_numbers=True)
                    if warn:
                        st.warning(warn)
                    if tags:
                        tag_cols = st.columns(len(tags), border=True)
                        for j, tag in enumerate(tags):
                            # print(f"{j=}, {tag=}, {type(tag)=}")
                            with tag_cols[j]:
                                # st.write(tag)
                                if st.button(
                                    label=str(tag),
                                    key=f"k_btn_{i}_{lang}_{j}"
                                ):
                                    st.session_state.update({c_key: [str(tag)]})
                                    st.rerun()
                    st.write(f"LAST MODIFIED {date_str_format(date)}")


un = st.session_state.get('user_full_name')
if not un:
    un = "NO NAME YET"
print(f"RERUN for '{un}'")
# count = st_autorefresh(interval=TIME_APP_REFRESH, limit=None, key="auto_refresh")


if df_app_directory.empty:
    with grid["content_row_0"]:
        st.write(f"## This Streamlit application '{st.session_state.get('app_short_name')}' is not recognized.")
        st.write("##### Please contact IT for further assistance with this app.")
        st.stop()
else:
    if not check_password():
        # st.write(f"## Invalid Credentials.")
        # st.write("##### Please contact IT for further assistance with this app.")
        st.stop()
    else:
        un = st.session_state.get('user_full_name')
        st.session_state.update({"text_input_requested_by": un})

        with grid["top_bar"][2]:
            styled_un = coloured_text(un, "#797979")
            html = f"<div><span>signed in as </span>{styled_un}</div>"
            st.markdown(html, unsafe_allow_html=True)

        # with grid["tab_new_request"]:
        if tab_choice == tab_names[0]:
            input_new_request()

        # with grid["tab_edit_request"]:
        if tab_choice == tab_names[1]:
            edit_request()

        if tab_choice == tab_names[2]:
            server_maintenance()

        if tab_choice == tab_names[3]:
            access_maintenance()

        if tab_choice == tab_names[4]:
            inventory_maintenance()

        if tab_choice == tab_names[5]:
            code_samples()

# st.write(st.session_state)
if not st.session_state.get("toggle_submit_requests", True):
    st.write(st.session_state.get("session_sqls", {}))


# x = lambda v: v+100
#
#
# def x1(v):
#     return v+10
#
# df1 = pd.DataFrame([{"a": 1, "b": 2}, {"a": 0, "b": -2}, {"a": 11, "b": 12}])
# st.dataframe(df1)
# st.write(df1.last_valid_index())
# st.write(df1.first_valid_index())
# st.write(df1.loc[0, "a"])
# # st.write(int(df1.index.values[0]))
# r