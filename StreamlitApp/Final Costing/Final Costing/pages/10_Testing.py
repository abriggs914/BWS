import datetime
import os.path
import re
from typing import Any, Optional, Literal

import pandas as pd
import streamlit as st
from streamlit_extras.add_vertical_space import add_vertical_space
from streamlit_autorefresh import st_autorefresh

from pyodbc_connection import connect
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

    "date_input_due": datetime.datetime.now().date(),
    "selectbox_company": "",
    "selectbox_department": "",
    "text_input_requested_by": "",
    "selectbox_request_type": "",
    "selectbox_request_sub_type": "",
    "slider_priority": 1,
    "text_request": "",
    "multiselect_followup": []
    # ,
    # "files_uploaded": ""  # This cannot be set using session_state
}
for k, v in DEFAULT_SESSION_STATE.items():
    st.session_state.setdefault(k, v)


#  Potential Functions for Utility Files

def create_sql(
    table: str,
    mode: Literal["select", "insert", "update", "delete"] = "select",
    where: str = "",
    group:
        tuple[tuple[str]] |
        tuple[list[str]] |
        list[tuple[str]] |
        list[list[str]] |
        list[str] |
        tuple[str] |
        str = "",
    order:
        tuple[tuple[str]] |
        tuple[list[str]] |
        list[tuple[str]] |
        list[list[str]] |
        list[str] |
        tuple[str] |
        str = "",
    default_order: str = "ASC",
    data: dict[str: Any] | list[str] | tuple[str] | str = None,
    sanitize: Literal["all", "none"] | list[str] | tuple[str] = "all",
    database: str = "BWSdb",
    ignore_no_where: bool = False
):

    if isinstance(sanitize, (list, tuple)):
        sanitize = [str(s).lower() for s in sanitize]
    else:
        sanitize = sanitize.lower()

    def wrap(val: Any, is_col: bool = True, sanitize: bool = True) -> str:
        # print(f"wrap: {val}")
        if is_col:
            v: str = f"[{str(val).removeprefix('[').removesuffix(']')}]"
        else:
            if isinstance(val, str) and val != "NULL":
                v: str = f"'{val}'"
            elif isinstance(val, datetime.datetime):
                v: str = f"'{val:%Y-%m-%d %H:%M:%S}'"
            elif isinstance(val, datetime.date):
                v: str = f"'{val:%Y-%m-%d}'"
            else:
                v: str = str(val)
        if sanitize:
            v = v.strip()
            v = v[0] + re.sub(r"[;'\\\"]", "", v[1:-1]) + v[-1]
        return v

    def do_sanitize(val: Any) -> bool:
        if sanitize == "all":
            return True
        if sanitize == "none":
            return False
        if isinstance(sanitize, (list, tuple)):
            return val.lower() in sanitize
        return True

    if mode in ("update", "delete"):
        if not where and not ignore_no_where:
            raise ValueError(f"Highly recommend including a where clause when updating or deleting. If you don't want to include a where clause, set 'ignore_no_where' to True. ")
    if mode == "update":
        if not isinstance(data, dict):
            raise ValueError(f"When updating, data must be a dictionary where keys are table column names.")

    table = wrap(table)
    where = where.replace("==", "=")
    if database:
        table = f"{wrap(database)}.[dbo].{table}"
    sql = ""
    if data is None:
        data = {}
    elif isinstance(data, str):
        data = [wrap(data)]
    elif (mode == "select") and isinstance(data, (list, tuple)):
        if data and not isinstance(data[0], str):
            raise ValueError(f"You can only pass a list of data line(s) for insertion method.")
    if data:
        # cols = "[" + "], [".join(data) + "]"
        if (mode == "insert") and isinstance(data, (list, tuple)):
            cols: str = ", ".join(map(wrap, data[0]))
        else:
            cols: str = ", ".join(map(wrap, data))
    else:
        if group:
            raise ValueError(f"You must specify columns for the select statement when addind a 'GROUP BY' clause.")
        if mode != "select":
            raise ValueError(f"You must specify columns when not performing a generic select.")
        cols: str = "*"

    if mode == "select":
        sql = f"SELECT {cols} FROM {table}"
        if where:
            sql += f" WHERE {where}"

        if group:
            if not isinstance(group, (list, tuple)):
                group = [group]
            group = ", ".join([wrap(col) for col in group])
            sql += f" GROUP BY {group}"

        if order:
            if isinstance(order, (list, tuple)):
                if len(order) == 2:
                    order = f"{wrap(order[0])} {order[1]}"
                else:
                    order = ", ".join([
                        f"{wrap(col[0])} {(col[1] if len(col) == 2 else default_order).upper()}"
                        if isinstance(col, (list, tuple))
                        else f"{wrap(col)} {default_order}"
                        for col in order
                    ])
            else:
                order = wrap(order)
            sql += f" ORDER BY {order}"
    elif mode == "insert":
        if not data or not isinstance(data, (dict, list, tuple)):
            raise ValueError(f"You must specify key-value pairs in the 'data' param, indicating which columns and values to insert.")
        if isinstance(data, dict):
            vals: list[str] = [wrap(val, False, sanitize=do_sanitize(key)) for key, val in data.items()]
        else:
            vals: list[str] = [("(" * min(i, 1)) + ", ".join([wrap(val, False, sanitize=do_sanitize(key)) for key, val in dat.items()]) + (")" * (1 if i < (len(data) - 1) else 0)) for i, dat in enumerate(data)]
        vals: str = ", ".join(vals)
        sql = f"INSERT INTO {table} ({cols}) VALUES ({vals})"
    elif mode == "update":
        sql = f"UPDATE {table} SET "
        sql += ", ".join([f"{wrap(key)} = {wrap(val, is_col=False, sanitize=do_sanitize(key))}" for key, val in data.items()])
        # vals: list[str] = [wrap(val, False, sanitize=do_sanitize(key)) for key, val in data.items()]
        if where:
            sql += f" WHERE {where}"

    sql += ";"
    return sql


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
    st.write(create_sql(
        "IT Requests",
        data=update_data,
        mode="update",
        sanitize=["Comments"],
        where=f"[ITRequestID#] == {req_id}"
    ))
    update_data = {
        "Status": "Complete",
        "CompletionDate": datetime.datetime.now()
    }
    st.write(create_sql(
        "IT Requests",
        data=update_data,
        mode="update",
        where=f"[ITRequestID#] == {req_id}"
    ))


@st.dialog("Mark request as complete")
def mark_as_complete_input(req_id, personnel_id):

    def click_date_stamp():
        text = st.session_state.get("text_area_request_comments", "")
        text = f"{text.strip()}\n{datetime.datetime.now():%Y-%m-%d - %H:%M:%S} - {st.session_state.get('user_name')}: "
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


df_itr_requests: pd.DataFrame = load_it_requests()
df_departments: pd.DataFrame = load_departments()
df_itr_personnel: pd.DataFrame = load_itr_personnel()
df_itr_customers: pd.DataFrame = load_itr_customers()
df_app_directory: pd.DataFrame = load_itstr_app_directory()
df_user_directory: pd.DataFrame = load_itstr_user_directory()

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
list_request_types: list[str] = sorted(df_itr_requests["RequestType"].dropna().str.title().unique().tolist())
rt: str = st.session_state.get("selectbox_request_type", [])
rb: str = st.session_state.get("user_full_name", [])
list_request_sub_types: list[str] = sorted(df_itr_requests.loc[df_itr_requests["RequestType"].str.title() == rt, "RequestSubType"].dropna().str.title().unique().tolist())
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
        #         data={
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

grid = {
    "top_bar": st.columns([0.6, 0.2, 0.2]),
    "title_row": st.container(),
    "credentials_row": st.container(),
    "content_row_0": st.container(),
    "content_row_1": st.container(),
    "tab_new_request": None,
    "tab_edit_request": None
}

if st.session_state.get("signed_in", False):
    tab_new_request, tab_edit_request = grid["content_row_1"].tabs([":star2: New", ":pencil2: Edit"])
    grid.update({
        "tab_new_request": tab_new_request,
        "tab_edit_request": tab_edit_request
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


def edit_request():

    form = grid["tab_edit_request"].container()
    with form:
        st.header("Edit Request")


def input_new_request():

    form = grid["tab_new_request"].container()
    with form:
        st.header("New Request")

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

    is_admin: bool = personnel_id >= 0
    st.session_state.setdefault("toggle_is_admin", is_admin)
    st.session_state.setdefault("toggle_mark_as_complete", False)

    file_uploader = None

    form_grid = {
        "title": form.columns(1, vertical_alignment="center"),
        "inputs": form.columns(3, vertical_alignment="center"),
        "text": form.columns(1, vertical_alignment="center"),
        "followup": form.columns(1, vertical_alignment="center"),
        "info": form.columns(1, vertical_alignment="center"),
        "admin": form.columns(1, vertical_alignment="center"),
        "btns": form.columns(3, vertical_alignment="center")
    }

    def click_cancel():
        print(f"cancel")

    def click_clear():
        print(f"clear")
        st.session_state.update({
            "date_input_due": datetime.datetime.now().date(),
            "selectbox_company": "",
            "selectbox_department": "",
            "text_input_requested_by": "",
            "selectbox_request_type": "",
            "selectbox_request_sub_type": "",
            "slider_priority": 1,
            "text_request": "",
            "multiselect_followup": []
        })

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
        attachments: list[dict] = []
        if file_uploader:
            cols = [
                "name",
                "type",
                "size",
                "close",
                "closed",
                "detach",
                "file_id",
                "fileno",
                "flush",
                "getbuffer",
                "getvalue",
                "isatty",
                "read",
                "read1",
                "readable",
                "readinto",
                "readinto1",
                "readline",
                "readlines",
                "seek",
                "seekable",
                "size",
                "tell",
                "truncate",
                "writable",
                "write",
                "writelines"
                # ,
                # "_file_urls",
                # "_checkWritable",
                # "_checkSeekable",
                # "_checkReadable",
                # "_checkClosed"
            ]
            attachments = [
                {
                    f"file_{key}": getattr(file, key)
                    for key in cols
                    if not callable(getattr(file, key))
                }
                for file in file_uploader
            ]

        # st.write("attachments")
        # st.write(attachments)

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

            # BEWARE ARTIFICIALLY 'CLAIMED' A SQL SERVER TABLE ID
            # Call insert statement ASAP to ensure that you actually get this ID
            my_id: int = get_next_it_request_number()
            st.write(f"MY ID# == {my_id}")
            dir_name: str = f"REQID#{str(my_id).rjust(6, '0')}"
            directory: str = os.path.join(ROOT_DIRECTORY_REQUESTS, dir_name)

            if not os.path.exists(directory):
                os.mkdir(directory)

            for file in file_uploader:
                file_name = getattr(file, "name")
                file_path = os.path.join(directory, file_name)
                with open(file_path, "wb") as f:
                    f.write(file.getbuffer())

            directory = "\\\\" + directory.removeprefix("\\")
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
            st.write(create_sql(
                "IT Requests",
                data=insert_data,
                mode="insert",
                sanitize=sanitize_cols
            ))

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

            if mark_as_complete:
                if not st.session_state.get("mark_as_complete_submitted", False):
                    mark_as_complete_input(my_id, personnel_id)
                else:
                    print(f"ALREADY HANDLED {datetime.datetime.now():%Y-%m-%d %H:%M:%S}")

            dialog_mac_submitted_correctly: bool = st.session_state.get("mark_as_complete_submitted", False)
            if dialog_mac_submitted_correctly:
                print(f"UPDATING MAC DETAILS {datetime.datetime.now():%Y-%m-%d %H:%M:%S}")
            else:
                st.write("MAC not submitted")
                print(f"MAC NOT SUBMITTED {datetime.datetime.now():%Y-%m-%d %H:%M:%S}")


            # TODO
            #  calculate [Directory]

            # st.write(create_sql(
            #     "IT Requests",
            #     data=[
            #         {
            #             "Request": text + "_0",
            #             "DueDate": due_date,
            #             "Company": comp,
            #             "Department": dept_id
            #         },
            #         {
            #             "Request": text + "_1",
            #             "DueDate": due_date,
            #             "Company": comp,
            #             "Department": dept_id
            #         }
            #     ],
            #     mode="insert"
            # ))
            # st.write(create_sql("IT Requests", data=["Status"]))
            # st.write(create_sql("IT Requests", where="[Status] = 'Complete'"))
            # st.write(create_sql("IT Requests", data=["Status"], where="[Status] = 'Complete'"))
            # st.write(create_sql("IT Requests", order="Status"))
            # st.write(create_sql("IT Requests", order=("Status", "ASC")))
            # st.write(create_sql("IT Requests", data=["Status"], order="Status"))
            # st.write(create_sql("IT Requests", where="[Status] = 'Complete'", order="Status"))
            # st.write(create_sql("IT Requests", data=["Status"], where="[Status] = 'Complete'", order="Status"))
            #
            # st.write(create_sql("IT Requests", order=("Status", "DESC")))
            # st.write(create_sql("IT Requests", data=["Status", "Company", "RequestedBy"], order=["Status", "Company", "RequestedBy"]))
            # st.write(create_sql("IT Requests", where="[Status] = 'Complete'", data=["Status", "Company", "RequestedBy"], order=[["Status", "asc"], ["Company", "desc"], "RequestedBy"]))
            #
            # st.write(create_sql("IT Requests", data="Status", order=("Status", "DESC"), group="Status"))
            # st.write(create_sql("IT Requests", data=["Status", "Company", "RequestedBy"], order=["Status", "Company", "RequestedBy"], group=["Status", "Company", "RequestedBy"]))
            # st.write(create_sql("IT Requests", where="[Status] = 'Complete'", data=["Status", "Company", "RequestedBy"], order=[["Status", "asc"], ["Company", "desc"], "RequestedBy"]))

    def change_request_type(*args):
        print(f"change_request_type")

    # click_clear()
    with form:

        with form_grid["title"][0]:
            st.markdown(
                "# Request Input",
                unsafe_allow_html=True
            )
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
            st.selectbox(
                label="Sub-Type:",
                key="selectbox_request_sub_type",
                options=list_request_sub_types
            )
        with form_grid["inputs"][2]:
            if is_admin:
                st.toggle(
                    label="Admin",
                    key="toggle_is_admin",
                    disabled=True
                )
                st.toggle(
                    label="Mark Complete?",
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
            )
        with form_grid["text"][0]:
            st.text_area(
                label="Request",
                key="text_request",
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
                on_click=click_cancel,
                use_container_width=True
            )
        with form_grid["btns"][2]:
            st.button(
                label="submit",
                on_click=click_submit,
                use_container_width=True
            )


un = st.session_state.get('user_full_name')
if not un:
    un = "NO NAME YET"
print(f"RERUN for '{un}'")
# count = st_autorefresh(interval=TIME_APP_REFRESH, limit=None, key="auto_refresh")


# with grid["title_row"]:
#     st.markdown(coloured_text("Streamlit Authentication Demo", "#653131", html_tags="h1"), unsafe_allow_html=True)

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

        with grid["tab_new_request"]:
            input_new_request()

        with grid["tab_edit_request"]:
            edit_request()

        # st.write(create_sql(
        #     "IT Requests",
        #     data={
        #         "Request": "sample_0",
        #         "DueDate": datetime.datetime.now(),
        #         "Company": "Stargate",
        #         "Priority": 3
        #     },
        #     mode="update",
        #     where="[ITRequestID#] == 1"
        # ))
        # st.write(create_sql("IT Requests", data=["Status"]))
        # st.write(create_sql("IT Requests", where="[Status] = 'Complete'"))
        # st.write(create_sql("IT Requests", data=["Status"], where="[Status] = 'Complete'"))
        # st.write(create_sql("IT Requests", order="Status"))
        # st.write(create_sql("IT Requests", order=("Status", "ASC")))
        # st.write(create_sql("IT Requests", data=["Status"], order="Status"))
        # st.write(create_sql("IT Requests", where="[Status] = 'Complete'", order="Status"))
        # st.write(create_sql("IT Requests", data=["Status"], where="[Status] = 'Complete'", order="Status"))
        #
        # st.write(create_sql("IT Requests", order=("Status", "DESC")))
        # st.write(create_sql("IT Requests", data=["Status", "Company", "RequestedBy"], order=["Status", "Company", "RequestedBy"]))
        # st.write(create_sql("IT Requests", where="[Status] = 'Complete'", data=["Status", "Company", "RequestedBy"], order=[["Status", "asc"], ["Company", "desc"], "RequestedBy"]))
        #
        # st.write(create_sql("IT Requests", data="Status", order=("Status", "DESC"), group="Status"))
        # st.write(create_sql("IT Requests", data=["Status", "Company", "RequestedBy"], order=["Status", "Company", "RequestedBy"], group=["Status", "Company", "RequestedBy"]))
        # st.write(create_sql("IT Requests", where="[Status] = 'Complete'", data=["Status", "Company", "RequestedBy"], order=[["Status", "asc"], ["Company", "desc"], "RequestedBy"]))

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
