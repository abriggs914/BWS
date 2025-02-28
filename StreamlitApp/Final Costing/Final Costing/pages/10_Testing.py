import datetime
import os.path
import re
from typing import Any, Optional, Literal

import pandas as pd
import pyautogui
import streamlit as st
from streamlit_extras.add_vertical_space import add_vertical_space
from streamlit_autorefresh import st_autorefresh
from streamlit_pills import pills

from pyodbc_connection import connect
from sql_utility import create_sql
from streamlit_utility import coloured_text


TIME_APP_REFRESH = 45 * 1000  # every 45 seconds
MAX_QUERY_HOLD_TIME: int = 1000 * 60 * 2  # 2 hours
SHOW_SPINNERS: bool = True
BWS: int = 0
STG: int = 1
ROOT_DIRECTORY_REQUESTS = r"\\bwsfp01.bwsdomain.local\Public\IT\Requests"
CREDS_BWS: dict[str: Any] = {
    "uid": "user5",
    "pwd": "M@gic456",
    "quote_key": "Quote#"
}
CREDS_STG: dict[str: Any] = {
    "uid": "SGeu1",
    "pwd": "Pupplies-Hagard->Rio0",
    "quote_key": "SGQuote"
}


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
    "session_sqls": {}
    # ,
    # "files_uploaded": ""  # This cannot be set using session_state
}
for k, v in DEFAULT_SESSION_STATE.items():
    st.session_state.setdefault(k, v)
# st.write(dict(st.session_state))


######################
# Data Fetch Functions
######################


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_departments() -> pd.DataFrame:
    sql = """
    SELECT
        MIN([Dept].[DeptID]) AS [MinOfDeptID],
        [Dept].[Dept]
    FROM
        [BWSdb].[dbo].[Dept] 
    GROUP BY
        [Dept].[Dept]
    HAVING
        [Dept].[Dept] <> ''
    ;
    """
    connection_data = {
        "sql": sql,
        "database": "bwsdb",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect(**connection_data)


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_itr_hardware() -> pd.DataFrame:
    sql = "[BWSdb].[dbo].[ITR Hardware]"
    connection_data = {
        "sql": sql,
        "database": "bwsdb",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect(**connection_data)


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_itr_software() -> pd.DataFrame:
    sql = "[BWSdb].[dbo].[ITR Software]"
    connection_data = {
        "sql": sql,
        "database": "bwsdb",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect(**connection_data)


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_itr_training() -> pd.DataFrame:
    sql = "[BWSdb].[dbo].[ITR Training]"
    connection_data = {
        "sql": sql,
        "database": "bwsdb",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect(**connection_data)


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_it_requests() -> pd.DataFrame:
    sql = "[BWSdb].[dbo].[IT Requests]"
    connection_data = {
        "sql": sql,
        "database": "bwsdb",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect(**connection_data)


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_itr_customers() -> pd.DataFrame:
    sql = "[BWSdb].[dbo].[ITR Customers]"
    connection_data = {
        "sql": sql,
        "database": "bwsdb",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect(**connection_data)


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_itr_personnel() -> pd.DataFrame:
    return connect(create_sql("IT Personnel", where="[Active] = 1"))


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_itstr_app_directory() -> pd.DataFrame:
    sql = "[BWSdb].[dbo].[ITSTR_AppDirectory]"
    connection_data = {
        "sql": sql,
        "database": "bwsdb",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect(**connection_data)


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_itstr_user_directory() -> pd.DataFrame:
    sql = "[BWSdb].[dbo].[ITSTR_UserDirectory]"
    connection_data = {
        "sql": sql,
        "database": "bwsdb",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect(**connection_data)


def get_next_it_request_number() -> int:
    # this function needs to be called as close to the insert as possible to reduce race condition
    # bugs caused by a faster user claiming a pre-distributed ITR ID #.
    sql = """
SELECT
	MAX([R].[ITRequestID#]) AS [LastID]
FROM
	[BWSdb].[dbo].[IT Requests] [R]
;
    """
    connection_data = {
        "sql": sql,
        "database": "bwsdb",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    df: pd.DataFrame = connect(**connection_data)
    if df.empty:
        raise ValueError(f"Critical Error could not retrieve a new IT Request ID Number for this input. Please try again later.")
    return df.iloc[0]["LastID"] + 1


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
    click_clear_input_form()


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
            st.rerun()\


@st.dialog("ITR Edit Params", width="large")
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


####################
# Fetch Data SLOW...
####################


default_company: str = "BWS"
default_department: str = "IT"
default_request_type: str = "Training"
default_request_sub_type: str = "Other"
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

df_app_directory: pd.DataFrame = df_app_directory.loc[df_app_directory["AppShortName"] == st.session_state.get("app_short_name")]
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
list_customers: list[str] = sorted(df_itr_customers.loc[df_itr_customers["Active"] == 1, "Name"].dropna().str.title().unique().tolist())

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


def clear_cache():
    st.cache_data.clear()
    st.cache_resource.clear()


def rerun():
    # st.rerun()  # no op
    pyautogui.hotkey("ctrl", "F5")


def clear_cache_and_rerun():
    clear_cache()
    rerun()


button_clear_cache_and_rerun = st.button(
    label="Clear Cache & Rerun",
    on_click=clear_cache_and_rerun
)

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

tab_names = [":star2: New", ":pencil2: Edit"]
if st.session_state.get("signed_in", False):
    # tab_new_request, tab_edit_request = grid["content_row_1"].tabs(tab_names)
    # grid.update({
    #     "tab_new_request": tab_new_request,
    #     "tab_edit_request": tab_edit_request
    # })
    with grid["content_row_1"]:
        tab_choice = pills("Options:", tab_names)
    # grid.update({
    #     "tab_new_request": tab_new_request,
    #     "tab_edit_request": tab_edit_request
    # })
    grid.update({
        "tab_choice": tab_choice
    })


def click_clear_input_form():
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
                    st.write(f"Need to add this person from [ITR Customers]. '{user}' ({cust_id=}) does not have an entry for Streanlit app ID={app_id}")
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
        department_name = df_departments_og.loc[df_departments_og["MinOfDeptID"] == department].iloc[0]["Dept"].title() if not pd.isna(
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
        click_clear_input_form()

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
            df_customer: pd.DataFrame = df_itr_customers_og.loc[df_itr_customers_og["Name"].str.lower() == name.lower()].reset_index()
            if not df_customer.empty:
                follow_up_emails.append(df_customer.iloc[0]["Email"].strip() if not pd.isna(df_customer.iloc[0]["Email"]) else "")
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
        df_dept: pd.DataFrame = df_departments_og.loc[df_departments_og["Dept"].str.lower() == dept.lower()].reset_index()
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
                department_name = df_departments_og.loc[df_departments["MinOfDeptID"] == department] if not pd.isna(department) else ""
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
                        df_cust: pd.DataFrame = df_itr_customers_og.loc[df_itr_customers_og["Email"].str.lower() == email.lower()]
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
                        (st.session_state.get("text_request", "").rstrip() + "\n").lstrip() + f"{datetime.datetime.now():%Y-%m-%d - %H:%M:%S} - {st.session_state.get('user_name')}: "
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

        it_personnel = df_itr_personnel_og.loc[df_itr_personnel_og["Name"].isin(it_personnel), "ITPersonID#"].dropna().unique().tolist()
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
                df_itr_requests = df_itr_requests.loc[df_itr_requests["Status"].isin(["Complete", "Declined", "Incomplete"])]
            else:
                df_itr_requests = df_itr_requests.loc[~df_itr_requests["Status"].isin(["Complete", "Declined", "Incomplete"])]
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

            if nav_button_cols[0].button(":black_left_pointing_double_triangle_with_vertical_bar:", key="button_nav_first_request"):
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
            if nav_button_cols[4].button(":black_right_pointing_double_triangle_with_vertical_bar:", key="button_nav_last_request"):
                print(f"Last")
                st.session_state.update({
                    "itr_edit_id": last_id
                })

        request_form(form=form, mode="edit")


def input_new_request():

    # form = grid["tab_new_request"].container()
    form = grid["content_row_2"].container()
    request_form(form=form, mode="new")


un = st.session_state.get('user_full_name')
if not un:
    un = "NO NAME YET"
print(f"RERUN for '{un}'")
# count = st_autorefresh(interval=TIME_APP_REFRESH, limit=None, key="auto_refresh")


# with grid["title_row"]:
#     st.markdown(coloured_text("Streamlit Authentication Demo", "#653131", html_tags="h1"), unsafe_allow_html=True)

# def op_process(var, ops_dict: dict[str: Any]) -> str:
#     ops_clause = []
#     for op, value_s in ops_dict.items():
#         # op_s = "="
#         op = op.lower()
#         match op:
#             case "!=":
#                 op = "<>"
#             case "<" | ">" | "<=" | ">=":
#                 op = op
#             case "in" | "not in" | "between":
#                 op = op.upper()
#             case _:
#                 op = "="
#         # op = op_s
#         test = ""
#         # if not isinstance(value_s, (list, tuple)):
#         value_s = [value_s]
#         for i, val in enumerate(value_s):
#             if op == "BETWEEN":
#                 v0, v1 = val
#                 ops_clause.append(f"{var} {op} {wrap(v0, is_col=False)} AND {wrap(v1, is_col=False)}")
#             else:
#                 if isinstance(val, (list, tuple)):
#                     if op in ("IN", "NOT IN"):
#                         in_mem = []
#                         for j, val_ in enumerate(val):
#                             in_mem.append(wrap(val_, is_col=False))
#                         ops_clause.append(f"{var} {op} ({', '.join(in_mem)})")
#                     else:
#                         for j, val_ in enumerate(val):
#                             ops_clause.append(f"{var} {op} {wrap(val_, is_col=False)}")
#                 else:
#                     ops_clause.append(f"{var} {op} {val}")
#         # test = []
#         # print(f"OP {op=}, {value_s=}")
#         # if not isinstance(value_s, (list, tuple)):
#         #     value_s = [value_s]
#         # for i, val in enumerate(value_s):
#         #     if isinstance(val, (list, tuple)):
#         #         if op_s == "between":
#         #             v0, v1 = val
#         #             test.append(f"{v0} AND {v1}")
#         #         else:
#         #             for j, val
#         #     else:
#         #
#         #         test.append(f" {val}")
#         #     # test = value_s
#         #     print(f"OP {test=}")
#
#             # ops_clause.append(f"{var} {op_s} {test}")
#     ops_clause = "(" + ") AND (".join(ops_clause) + ")"
#     print(f"OP {ops_clause=}")
#     return ops_clause


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

        # with grid["tab_new_request"]:
        if tab_choice == tab_names[0]:
            input_new_request()

        # with grid["tab_edit_request"]:
        if tab_choice == tab_names[1]:
            edit_request()


        # insert_data: dict[str: Any] = {
        #     "Request": "Request Text",
        #     "DueDate": datetime.datetime.now(),
        #     "Company": "BWS",
        #     "Department": 87,
        #     "Priority": 3,
        #     "SubPriority": 1,
        #     "RequestType": "Hardware",
        #     "RequestSubType": "Computer",
        #     "RequestedBy": "Avery Briggs",
        #     "RequestFollowUpPersonnel": "avery.briggs@bwstrailers.com;abriggs914@gmail.com",
        #     "RequestDate": datetime.datetime.now(),
        #     "Status": "Queued",
        #     "RequestDateOriginal": "2024-11-21 17:01:59",
        #     "Directory": r"C:\Users\abriggs\Documents\BWS\Nulls being weird.sql"
        # }
        # sanitize_cols = list(insert_data.keys())
        # sanitize_cols.remove("RequestFollowUpPersonnel")  # preserve semicolons delimiting email addresses
        # sanitize_cols.remove("Directory")  # preserve backslashes in path
        #
        # wheres = [
        #     [
        #         ["[ITRequestID#]", {"between": [105445, 235564]}],
        #         ["[RequestedBy]", {"=": "Darth Vader"}]
        #     ],
        #     [
        #         [["[ITRequestID#]", {"between": [105445, 235564]}]],
        #         [["[RequestedBy]", {"=": "Darth Vader"}]]
        #     ],
        #     [
        #         [
        #             ["[ITRequestID#]", {"between": [105445, 235564]}],
        #             ["[RequestedBy]", {"=": "Darth Vader"}]
        #         ],
        #         ["[RequestedDate]", {"between": ["2050-01-01", "2051-01-01"]}]
        #     ],
        #     "[ITRequestID#] == 1",
        #     ["[Status] = 'Complete'"],
        #     ["[Status] = 'Complete'",],
        #     ["[ITRequestID#]", {"=": 1054789}],
        #     [
        #         [["RequestedBy", {"like": "%avery%"}]],
        #         [["RequestDate", {"between": ["2024-11-01", "2024-11-30 23:59:59"]}]]
        #     ],
        #     [
        #         [["RequestedBy", {"like": "%avery%"}],],
        #         [["RequestDate", {"between": ["2024-11-01", "2024-11-30 23:59:59"]}],]
        #     ],
        #     [
        #         ["RequestedBy", {"like": "%avery%"}],
        #         ["RequestDate", {"between": ["2024-11-01", "2024-11-30 23:59:59"]}]
        #     ],
        #     [
        #         [
        #             ["RequestedBy", {"like": "%avery%"}],
        #             ["RequestDate", {"between": ["2024-11-01", "2024-11-30 23:59:59"]}]
        #         ]
        #     ],
        #     [
        #         [
        #             [["RequestedBy", {"like": "%avery%"}]],
        #             [["RequestDate", {"between": ["2024-11-01", "2024-11-30 23:59:59"]}]]
        #         ]
        #     ],
        #     [
        #         [
        #             ["RequestedBy", {"like": "%avery%"}],
        #             ["RequestDate", {"between": ["2024-11-01", "2024-11-30 23:59:59"]}]
        #         ]
        #     ],
        #     [
        #         [
        #             ["RequestedBy", {"like": "%avery%"}],
        #             ["RequestDate", {"between": ["2024-11-01", "2024-11-30 23:59:59"]}]
        #         ],
        #         [
        #             ["RequestedBy", {"like": "%james%"}],
        #             ["RequestDate", {"between": ["2024-11-01", "2024-11-30 23:59:59"]}]
        #         ]
        #
        #     ]
        # ]
        # for i, wh in enumerate(wheres):
        #     st.text(f"{i=}, {wh}")
        #     st.text(f"WHERE{parse_where(wh, in_line=True)}")
        #     st.write(f"---")
        #     # print(f"SUCCESS {i=}")
        #
        # # test_sqls = [
        # #     create_sql(
        # #         "IT Requests",
        # #         path_data={
        # #             "Request": "sample_0",
        # #             "DueDate": datetime.datetime.now(),
        # #             "Company": "Stargate",
        # #             "Priority": 3
        # #         },
        # #         mode="update",
        # #         where="[ITRequestID#] == 1",
        # #         transaction_wrap=True
        # #     ),
        # #     create_sql("IT Requests", path_data=["Status"], include_no_lock=True),
        # #     create_sql("IT Requests", where="[Status] = 'Complete'", include_no_lock=True),
        # #     create_sql("IT Requests", path_data=["Status"], where="[Status] = 'Complete'", include_no_lock=True),
        # #     create_sql("IT Requests", order="Status", include_no_lock=True),
        # #     create_sql("IT Requests", order=("Status", "ASC"), include_no_lock=True),
        # #     create_sql("IT Requests", path_data=["Status"], order="Status", include_no_lock=True),
        # #     create_sql("IT Requests", where="[Status] = 'Complete'", order="Status", include_no_lock=True),
        # #     create_sql("IT Requests", path_data=["Status"], where="[Status] = 'Complete'", order="Status",
        # #                        include_no_lock=True),
        # #
        # #     create_sql("IT Requests", order=("Status", "DESC"), include_no_lock=True),
        # #     create_sql("IT Requests", path_data=["Status", "Company", "RequestedBy"],
        # #                        order=["Status", "Company", "RequestedBy"], include_no_lock=True),
        # #     create_sql("IT Requests", where="[Status] = 'Complete'", path_data=["Status", "Company", "RequestedBy"],
        # #                        order=[["Status", "asc"], ["Company", "desc"], "RequestedBy"], include_no_lock=True),
        # #
        # #     create_sql("IT Requests", path_data="Status", order=("Status", "DESC"), group="Status",
        # #                        include_no_lock=True),
        # #     create_sql("IT Requests", path_data=["Status", "Company", "RequestedBy"],
        # #                        order=["Status", "Company", "RequestedBy"], group=["Status", "Company", "RequestedBy"],
        # #                        include_no_lock=True),
        # #     create_sql("IT Requests", where="[Status] = 'Complete'", path_data=["Status", "Company", "RequestedBy"],
        # #                        order=[["Status", "asc"], ["Company", "desc"], "RequestedBy"], include_no_lock=True),
        # #
        # #     create_sql("IT Requests", mode="delete", where="[ITRequestID#] = 105445", transaction_wrap=True),
        # #     create_sql("IT Requests", mode="delete", where=("[ITRequestID#]", {"=": 1054789}),
        # #                        transaction_wrap=True),
        # #     create_sql(
        # #         "IT Requests",
        # #         mode="delete",
        # #         where=(
        # #             ("[ITRequestID#]", {"between": [105445, 235564]}),
        # #             ("[RequestedBy]", {"=": "Darth Vader"})
        # #         ),
        # #         transaction_wrap=True
        # #     ),
        # #
        # #     # should be or
        # #     create_sql(
        # #         "IT Requests",
        # #         mode="delete",
        # #         where=(
        # #             (("[ITRequestID#]", {"between": [105445, 235564]})),
        # #             (("[RequestedBy]", {"=": "Darth Vader"}))
        # #         ),
        # #         transaction_wrap=True
        # #     ),
        # #
        # #     create_sql(
        # #         "IT Requests",
        # #         mode="delete",
        # #         where=(
        # #             (
        # #                 ("[ITRequestID#]", {"between": [105445, 235564]}),
        # #                 ("[RequestedBy]", {"=": "Darth Vader"})
        # #             ),
        # #             ({"between": ["2050-01-01", "2051-01-01"]})
        # #         ),
        # #         transaction_wrap=True
        # #     ),
        # #
        # #     create_sql(
        # #         "IT Requests",
        # #         path_data=insert_data,
        # #         mode="insert",
        # #         sanitize=sanitize_cols,
        # #         transaction_wrap=True
        # #     )
        # # ]
        # #
        # # for i, sql in enumerate(test_sqls):
        # #     # print(f"{sql}")
        # #     st.text(sql)
        # #     st.write("---")
        #
        # # st.text(create_sql(
        # #     "IT Requests",
        # #     path_data={
        # #         "Request": "sample_0",
        # #         "DueDate": datetime.datetime.now(),
        # #         "Company": "Stargate",
        # #         "Priority": 3
        # #     },
        # #     mode="update",
        # #     where="[ITRequestID#] == 1",
        # #     transaction_wrap=True
        # # ))
        # # st.text(create_sql("IT Requests", path_data=["Status"], include_no_lock=True))
        # # st.text(create_sql("IT Requests", where="[Status] = 'Complete'", include_no_lock=True))
        # # st.text(create_sql("IT Requests", path_data=["Status"], where="[Status] = 'Complete'", include_no_lock=True))
        # # st.text(create_sql("IT Requests", order="Status", include_no_lock=True))
        # # st.text(create_sql("IT Requests", order=("Status", "ASC"), include_no_lock=True))
        # # st.text(create_sql("IT Requests", path_data=["Status"], order="Status", include_no_lock=True))
        # # st.text(create_sql("IT Requests", where="[Status] = 'Complete'", order="Status", include_no_lock=True))
        # # st.text(create_sql("IT Requests", path_data=["Status"], where="[Status] = 'Complete'", order="Status", include_no_lock=True))
        # #
        # # st.text(create_sql("IT Requests", order=("Status", "DESC"), include_no_lock=True))
        # # st.text(create_sql("IT Requests", path_data=["Status", "Company", "RequestedBy"], order=["Status", "Company", "RequestedBy"], include_no_lock=True))
        # # st.text(create_sql("IT Requests", where="[Status] = 'Complete'", path_data=["Status", "Company", "RequestedBy"], order=[["Status", "asc"], ["Company", "desc"], "RequestedBy"], include_no_lock=True))
        # #
        # # st.text(create_sql("IT Requests", path_data="Status", order=("Status", "DESC"), group="Status", include_no_lock=True))
        # # st.text(create_sql("IT Requests", path_data=["Status", "Company", "RequestedBy"], order=["Status", "Company", "RequestedBy"], group=["Status", "Company", "RequestedBy"], include_no_lock=True))
        # # st.text(create_sql("IT Requests", where="[Status] = 'Complete'", path_data=["Status", "Company", "RequestedBy"], order=[["Status", "asc"], ["Company", "desc"], "RequestedBy"], include_no_lock=True))
        # #
        # # st.text(create_sql("IT Requests", mode="delete", where="[ITRequestID#] = 105445", transaction_wrap=True))
        # # st.text(create_sql("IT Requests", mode="delete", where=("[ITRequestID#]", {"=": 1054789}), transaction_wrap=True))
        # # st.text(create_sql(
        # #     "IT Requests",
        # #     mode="delete",
        # #     where=(
        # #         ("[ITRequestID#]", {"=": [105445, 235564]}),
        # #         ("[RequestedBy]", {"=": "Darth Vader"})
        # #     ),
        # #     transaction_wrap=True
        # # ))
        # # insert_data: dict[str: Any] = {
        # #     "Request": "Request Text",
        # #     "DueDate": datetime.datetime.now(),
        # #     "Company": "BWS",
        # #     "Department": 87,
        # #     "Priority": 3,
        # #     "SubPriority": 1,
        # #     "RequestType": "Hardware",
        # #     "RequestSubType": "Computer",
        # #     "RequestedBy": "Avery Briggs",
        # #     "RequestFollowUpPersonnel": "avery.briggs@bwstrailers.com;abriggs914@gmail.com",
        # #     "RequestDate": datetime.datetime.now(),
        # #     "Status": "Queued",
        # #     "RequestDateOriginal": "2024-11-21 17:01:59",
        # #     "Directory": r"C:\Users\abriggs\Documents\BWS\Nulls being weird.sql"
        # # }
        # # sanitize_cols = list(insert_data.keys())
        # # sanitize_cols.remove("RequestFollowUpPersonnel")  # preserve semicolons delimiting email addresses
        # # sanitize_cols.remove("Directory")  # preserve backslashes in path
        # # st.text(create_sql(
        # #     "IT Requests",
        # #     path_data=insert_data,
        # #     mode="insert",
        # #     sanitize=sanitize_cols,
        # #     transaction_wrap=True
        # # ))
        # #
        # # # # st.text(
        # # # #     op_process("[ITRequestID#]", {"=": [105445,235567]})
        # # # # )
        # # # # st.text(
        # # # #     op_process("[RequestDate]", {"between": ['2024-11-20', '2024-11-21 23:59:59']})
        # # # # )
        # # # # st.text(
        # # # #     op_process("[ITRequestID#]", {"!=": "15444"})
        # # # # )
        # # # # st.text(
        # # # #     op_process("[ITRequestID#]", {"in": [6565, 454848, 454481]})
        # # # # )
        # # # # st.text(
        # # # #     op_process("[Status#]", {"not in": ["Complete", "Declined", "Incomplete"]})
        # # # # )
        # # #
        # # # st.text(
        # # #     parse_where((
        # # #         ("[ITRequestID#]", {"between": [105445, 235564]}),
        # # #         ("[RequestedBy]", {"=": "Darth Vader"})
        # # #     ))
        # # # )
        # # # st.text(parse_where("[ITRequestID#] = 105445"))
        # # # st.text(parse_where(("[ITRequestID#]", {"=": 1054789})))
        # # # # st.text(
        # # # #     parse_where("[RequestDate]", {"between": ['2024-11-20', '2024-11-21 23:59:59']})
        # # # # )
        # # # # st.text(
        # # # #     parse_where("[ITRequestID#]", {"!=": "15444"})
        # # # # )
        # # # # st.text(
        # # # #     parse_where("[ITRequestID#]", {"in": [6565, 454848, 454481]})
        # # # # )
        # # # # st.text(
        # # # #     parse_where("[Status#]", {"not in": ["Complete", "Declined", "Incomplete"]})
        # # # # )

    # if not check_password():
    #     # st.write(f"## Invalid Credentials.")
    #     # st.write("##### Please contact IT for further assistance with this app.")
    #     st.stop()
    # else:
    #     un = st.session_state.get('user_full_name')
    #     with grid["top_bar"][2]:
    #         styled_un = coloured_text(un, "#797979")
    #         html = f"<div><span>signed in as </span>{styled_un}</div>"
    #         st.markdown(html, unsafe_allow_html=True)
    #
    #     with grid["content_row_0"]:
    #         # st.write(f"Hello {st.session_state.get('user_full_name')}!")
    #         add_vertical_space(4)
    #         st.write(f"Thank you for trying out our BWS Streamlit sign-in service!")
    #         st.write(f"More coming soon, Please check back later.")
    #
    #         user_name = st.session_state.get("user_name")
    #         df_user: pd.DataFrame = df_user_directory.loc[df_user_directory["AppUserName"] == user_name]
    #         cust_id: int = df_user.iloc[0]["ITRCustomerID"]
    #         df_cust: pd.DataFrame = df_itr_customers.loc[df_itr_customers["CustomerID"] == cust_id].iloc[0]
    #
    #         cust_dob_y: int = df_cust["BirthYear"]
    #         cust_dob_m: int = df_cust["BirthMonth"]
    #         cust_dob_d: int = df_cust["BirthDay"]
    #         cust_dob: Optional[datetime.datetime] = None
    #         # print(f"{cust_dob_y=}, {cust_dob_m=}, {cust_dob_d=}")
    #
    #         cust_shirt_size = df_cust["ShirtSize"]
    #
    #         if not any([pd.isna(cust_dob_y), pd.isna(cust_dob_m), pd.isna(cust_dob_d)]):
    #             cust_dob = datetime.datetime(int(cust_dob_y), int(cust_dob_m), int(cust_dob_d))
    #
    #         if not pd.isna(cust_shirt_size):
    #             st.session_state.update({"select_shirt_size": cust_shirt_size})
    #
    #         with st.expander(":pencil2: Edit Personal Data"):
    #             with st.form(key="Customer"):
    #                 st.date_input(
    #                     label="Change your Birthdate:",
    #                     value=cust_dob,
    #                     min_value=datetime.datetime(1935, 1, 1),
    #                     max_value=datetime.datetime.now() + datetime.timedelta(days=-int(round((18*365.25)))),
    #                     key="date_input_birthdate"
    #                     # ,
    #                     # on_change=birthdate_on_change
    #                 )
    #                 st.selectbox(
    #                     label="Shirt-Size:",
    #                     key="select_shirt_size",
    #                     options=list_shirt_sizes
    #                 )
    #                 st.form_submit_button(
    #                     label="Update",
    #                     on_click=lambda: submit_form("Customer")
    #                 )

# st.write(st.session_state)
if not st.session_state.get("toggle_submit_requests", True):
    st.write(st.session_state.get("session_sqls", {}))


from st_mui_multiselect import st_mui_multiselect

options = ["Mayo", "Lettuce", "Pickles", "Tomatoes", "Onions", "Mushrooms", "Ketchup", "Jalapeños"]
selections = st_mui_multiselect(options, size=5)
st.markdown("You selected %s" % ", ".join(selections))


from streamlit_tree_select import tree_select

st.title("🐙 Streamlit-tree-select")
st.subheader("A simple and elegant checkbox tree for Streamlit.")

# Create op_nodes to display
nodes = [
    {"label": "Folder A", "value": "folder_a"},
    {
        "label": "Folder B",
        "value": "folder_b",
        "children": [
            {"label": "Sub-folder A", "value": "sub_a"},
            {"label": "Sub-folder B", "value": "sub_b"},
            {"label": "Sub-folder C", "value": "sub_c"},
        ],
    },
    {
        "label": "Folder C",
        "value": "folder_c",
        "children": [
            {"label": "Sub-folder D", "value": "sub_d"},
            {
                "label": "Sub-folder E",
                "value": "sub_e",
                "children": [
                    {"label": "Sub-sub-folder A", "value": "sub_sub_a"},
                    {"label": "Sub-sub-folder B", "value": "sub_sub_b"},
                ],
            },
            {"label": "Sub-folder F", "value": "sub_f"},
        ],
    },
]

with st.container(border=True):
    return_select = tree_select(nodes)
with st.container(border=True):
    st.color_picker(
        "pick a colour"
    )
with st.container(border=True):
    st.write(return_select)


# [theme]
primaryColor="#4b58ff"
backgroundColor="#0c0c0c"
secondaryBackgroundColor="#7085b9"
textColor="#f5f5f5"

# [theme]
primaryColor="#FF4B4B"
backgroundColor="#FFFFFF"
secondaryBackgroundColor="#F0F2F6"
textColor="#31333F"
font="sans serif"


st.write(f"{st.session_state.get('primaryColor')=}")
st.write(f"{st.session_state.get('backgroundColor')=}")
st.write(f"{st.session_state.get('secondaryBackgroundColor')=}")
st.write(f"{st.session_state.get('textColor')=}")


# st.write(dir(st.config))
# st.write(st.components)
# st.toast(body="TOAST")
# st.write(st.user_info)
# st.write(dir(st.user_info))
# for k, v in st.session_state.items():
#     st.write(f"{k=}, {v=}")


import toml
default_theme = toml.load("./streamlit/config.toml")
st.write(default_theme)
st.session_state.setdefault("theme", {})
new_config: bool = False
for k, v in default_theme["theme"].items():
    if st.session_state["theme"].get(k) != v:
        st.config.set_option(f"theme.{k}", v)
        new_config = True
    st.session_state["theme"][k] = v
if new_config:
    st.rerun()

b1 = st.button(label="b1", type="primary")
b2 = st.button(label="b2", type="secondary")
b3 = st.button(label="b3", type="tertiary")

CONFIG_TEMPLATE = """
[theme]
primaryColor = "{}"
backgroundColor = "{}"
secondaryBackgroundColor = "{}"
textColor = "{}"
font = "sans serif"
"""
config = CONFIG_TEMPLATE.format(
    st.session_state.theme.get("primaryColor"),
    st.session_state.theme.get("backgroundColor"),
    st.session_state.theme.get("secondaryBackgroundColor"),
    st.session_state.theme.get("textColor"),
)
st.write(config)
if b1:
    data = {
        "theme": {
            "primaryColor": st.config.get_option("theme.primaryColor"),
            "backgroundColor": st.config.get_option("theme.backgroundColor"),
            "secondaryBackgroundColor": st.config.get_option("theme.secondaryBackgroundColor"),
            "textColor": st.config.get_option("theme.textColor")
        }
    }
    st.write(data)

# st.write(st.user_info._get_user_info())
# rtc = st.runtime.get_instance()
# rtc = st.runtime.runtime.RuntimeConfig
# st.write(f"{rtc.session_manager_class.num_sessions()=}")
# st.write(f"{st.runtime.RuntimeConfig.session_manager_class.num_active_sessions()=}")
# st.write(f"{st.runtime.RuntimeConfig.session_manager_class.list_sessions()=}")
# st.write(f"{st.runtime.RuntimeConfig.session_manager_class.list_active_sessions()=}")
# st.write(f"{st.runtime.RuntimeConfig.session_manager_class.get_session_info()=}")
# st.write(f"{st.runtime.RuntimeConfig.session_manager_class.get_active_session_info()=}")

from st_excel_table import Table

st.title("Streamlit-Excel-Table")

data = [
    {"id": "hoge", "x": 5.77, "y": 8.85, "color": "red"},
    {"id": "hogedb", "x": 15.77, "y": 18.85, "color": "red"},
    {"id": "hogeba", "x": 25.77, "y": 28.85, "color": "red"},
    {"id": "hogeas", "x": 35.77, "y": 38.85, "color": "red"},
]
Table(data)
