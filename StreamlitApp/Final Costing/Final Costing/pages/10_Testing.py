import datetime
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
    mode: Literal["select", "insert"] = "select",
    data: dict[str: Any] | list[str] | tuple[str] | str = None,
    database: str = "BWSdb"
):

    def wrap(val: Any, is_col: bool = True) -> str:
        print(f"wrap: {val}")
        if is_col:
            return f"[{str(val).removeprefix('[').removesuffix(']')}]"
        else:
            if isinstance(val, str) and val != "NULL":
                return f"'{val}'"
            elif isinstance(val, datetime.date):
                return f"'{val:%Y-%m-%d}'"
            elif isinstance(val, datetime.datetime):
                return f"'{val:%Y-%m-%d %H:%M:%S}'"
            else:
                return str(val)

    table = wrap(table)
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
            vals: list[str] = [wrap(val, False) for val in data.values()]
        else:
            vals: list[str] = [("(" * min(i, 1)) + ", ".join([wrap(val, False) for val in dat.values()]) + (")" * (1 if i < (len(data) - 1) else 0)) for i, dat in enumerate(data)]
        vals: str = ", ".join(vals)
        sql = f"INSERT INTO {table} ({cols}) VALUES ({vals})"

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


#################
# Event Listeners
#################


def birthdate_on_change():
    dob = st.session_state.get("date_input_birthdate")
    print(f"NEW DOB {dob}")


#################
# Helper Functions
#################


def submit_form(form_key):
    print(f"SUBMIT {form_key} FORM")
    sql = ""
    match form_key:
        case "Customer":
            sql = "UPDATE [BWSdb].[dbo].[ITR Customers] SET "
            dob: Optional[datetime.datetime] = st.session_state.get("date_input_birthdate")
            shirt_size: Optional[str] = st.session_state.get("select_shirt_size")
            cust_id = st.session_state.get("itr_customer_id")
            print(f"NEW DOB {dob}")
            if dob:
                dob_y: int = dob.year
                dob_m: int = dob.month
                dob_d: int = dob.day
                print(f"y={dob_y}, m={dob_m}, d={dob_d} ", end="")
                sql += f"[BirthYear] = {dob_y}, "
                sql += f"[BirthMonth] = {dob_m}, "
                sql += f"[BirthDay] = {dob_d}, "
            if shirt_size:
                print(f"ss={shirt_size}", end="")
                sql += f"[ShirtSize] = '{shirt_size}', "

            sql = sql.removesuffix(", ")
            sql += f" WHERE [CustomerID] = {cust_id};"
            print(f"")
        case _:
            raise KeyError(f"This {form_key=} is unrecognized.")

    if sql:
        print(f"{sql=}")


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
    "content_row_1": st.container()
}


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


def input_new_request():

    form = grid["content_row_1"].container()
    cust_id: int = -1
    personnel_id: int = -1
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
    st.session_state.update({"toggle_is_admin": is_admin})

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

        st.write("attachments")
        st.write(attachments)

        follow_up: str = ";".join(follow_up)

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
            sql: str = f"INSERT INTO [BWSdb].[dbo].[IT Requests] ()"
            st.write(create_sql(
                "IT Requests",
                data={
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
                    "RequestDateOriginal": datetime.datetime.now()
                },
                mode="insert"
            ))

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
        input_new_request()
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
