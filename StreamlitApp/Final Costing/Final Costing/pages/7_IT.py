
import os.path

import pyautogui
import streamlit as st
from streamlit_extras.add_vertical_space import add_vertical_space
from streamlit_autorefresh import st_autorefresh
from streamlit_pills import pills

from pyodbc_connection import connect
from sql_utility import *
from streamlit_utility import coloured_text
from streamlit_utility_bws import load_it_requests, load_departments, load_itr_personnel, load_itstr_app_directory, \
    load_itr_customers, load_itr_hardware, load_itstr_user_directory, load_itr_software, load_itr_training, \
    get_next_it_request_number, get_tables, get_cols, load_production_file

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

tab_names = ["New", "Edit", "Server", "Access"]
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

            st.dataframe(
                st.session_state.get("df_search_cols_result"),
                hide_index=True,
                use_container_width=True
            )

        if sm_tabs == sm_tab_names[1]:
            # SQL Creator

            list_query_types: list[str] = ["SELECT", "UPDATE", "INSERT", "DELETE"]
            list_join_options: list[str] = ["INNER", "LEFT", "RIGHT", "CROSS", "FULL"]

            input_db_cols = st.columns(len(list_databases) + 1)
            input_table_cols = st.columns(1)
            input_join_cols = st.columns([0.35, 0.65])
            radio_query_type = input_db_cols[0].radio(
                label="Query Type:",
                key="radio_query_type",
                options=list_query_types,
                disabled=True
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

            selectbox_table_0 = input_table_cols[0].selectbox(
                label="Select a table:",
                key="selectbox_table_0",
                options=db_options_0
            )

            toggle_use_alias = input_table_cols[0].toggle(
                label="Use Aliasing?",
                key="toggle_use_alias"
            )

            if st.session_state.get("toggle_use_alias", True):
                text_input_alias_0 = input_table_cols[0].text_input(
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
                #         data={"Comments": None},
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
    #         "data": st.session_state.get(""),
    #         "name": "SysproCompanyA.accdb"
    #     }
    # }
    # databases[]
    with grid["content_row_2"]:
        st.subheader("access_maintenance")

    databases = [
        "SysproCompanyA.accdb",
        "SysproCompanyS.accdb",
        "BWS-SalesV4.mdb"
    ]

    download_buttons = []
    for i, db in enumerate(databases):
        db_spl = db.split(".")
        name = "".join(db_spl[:-1])
        key = f"db_file_{name.lower()}"
        data = st.session_state.get(key)
        if data is None:
            st.session_state.update({key: load_production_file(db)})
        # print(f"{i=}, {db=}, {name=}, {key=}")

        if data is not None:
            download_buttons.append(st.download_button(
                label=name,
                data=data,
                file_name=db,
                mime="application/octet-stream"
            ))


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

# st.write(st.session_state)
if not st.session_state.get("toggle_submit_requests", True):
    st.write(st.session_state.get("session_sqls", {}))
