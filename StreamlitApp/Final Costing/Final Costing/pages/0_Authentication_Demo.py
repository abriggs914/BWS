import datetime
from typing import Any, Optional

import pandas as pd
import streamlit as st
from streamlit_extras.add_vertical_space import add_vertical_space
from streamlit_autorefresh import st_autorefresh

from pyodbc_connection import connect
from streamlit_utility import coloured_text
from streamlit_utility_bws import load_itr_customers, load_itstr_app_directory, load_itstr_user_directory, \
    load_itp_phone_lines

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

N_PER_FRAME = 50


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
    "app_short_name": "Authentication Demo",
    "date_input_birthdate": None,
    "select_shirt_size": None,

    "toggle_admin_mode": False,
    "frame_idx": 0
}
for k, v in DEFAULT_SESSION_STATE.items():
    st.session_state.setdefault(k, v)


######################
# Data Fetch Functions
######################


# @st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
# def load_itr_customers() -> pd.DataFrame:
#     sql = "[BWSdb].[dbo].[ITR Customers]"
#     connection_data = {
#         "sql": sql,
#         "database": "bwsdb",
#         "uid": CREDS_BWS["uid"],
#         "pwd": CREDS_BWS["pwd"]
#     }
#     return connect(**connection_data)
#
#
# @st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
# def load_itstr_app_directory() -> pd.DataFrame:
#     sql = "[BWSdb].[dbo].[ITSTR_AppDirectory]"
#     connection_data = {
#         "sql": sql,
#         "database": "bwsdb",
#         "uid": CREDS_BWS["uid"],
#         "pwd": CREDS_BWS["pwd"]
#     }
#     return connect(**connection_data)
#
#
# @st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
# def load_itstr_user_directory() -> pd.DataFrame:
#     sql = "[BWSdb].[dbo].[ITSTR_UserDirectory]"
#     connection_data = {
#         "sql": sql,
#         "database": "bwsdb",
#         "uid": CREDS_BWS["uid"],
#         "pwd": CREDS_BWS["pwd"]
#     }
#     return connect(**connection_data)


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


df_itr_customers: pd.DataFrame = load_itr_customers()
df_app_directory: pd.DataFrame = load_itstr_app_directory()
df_user_directory: pd.DataFrame = load_itstr_user_directory()
df_itp_phone_lines: pd.DataFrame = load_itp_phone_lines()
df_app_directory: pd.DataFrame = df_app_directory.loc[df_app_directory["AppShortName"] == st.session_state.get("app_short_name")]
app_id: int = df_app_directory.iloc[0]["ID"] if not df_app_directory.empty else -1

# st.write(f"{app_id=}, {type(app_id)=}")
# st.dataframe(df_app_directory, use_container_width=True)
# st.dataframe(df_user_directory, use_container_width=True)

df_itr_customers = pd.merge(
    df_itr_customers,
    df_itp_phone_lines[["Extension", "DisplayName", "AssignedTo"]],
    left_on="CustomerID",
    right_on="AssignedTo",
    how="left"
)

n_customers = df_itr_customers.shape[0]
last_frame_idx = (n_customers - (N_PER_FRAME + 1)) / N_PER_FRAME

st.dataframe(df_itr_customers)

df_user_directory: pd.DataFrame = df_user_directory.loc[df_user_directory["ITSTRAppID"] == app_id]
df_user_directory["AppUserName"] = df_user_directory["AppUserName"].str.lower()

list_shirt_sizes: list[str] = sorted(df_itr_customers["ShirtSize"].dropna().unique().tolist())

grid = {
    "top_bar": st.columns([0.6, 0.2, 0.2]),
    "title_row": st.container(),
    "credentials_row": st.container(),
    "content_row_0": st.container()
}


def check_password():
    """Returns `True` if the user had a correct password."""

    def login_form():
        """Form with widgets to collect user information"""
        with grid["title_row"].form("Credentials"):
            st.write(f"### Please Sign in:")
            st.text_input("Username", key="text_input_username")
            st.text_input("Password", type="password", key="text_input_password")
            st.form_submit_button("Log in", on_click=password_entered)

    def password_entered():
        """Checks whether a password entered by the user is correct."""
        user: str = st.session_state.get("text_input_username", "").lower()
        pswd: str = st.session_state.get("text_input_password", "")
        atpt: int = st.session_state.get("n_attempts_password", DEFAULT_SESSION_STATE["n_attempts_password"])
        matp: int = DEFAULT_SESSION_STATE["n_attempts_password_reset"]
        df_user: pd.DataFrame = df_user_directory.loc[df_user_directory["AppUserName"] == user]
        with grid["credentials_row"]:
            if not df_user.empty:
                # found user
                df_user: pd.DataFrame = df_user.loc[df_user["AppPassword"] == pswd]
                # st.write("DF_USER:")
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
    if st.session_state.get("n_attempts_password") < st.session_state.get("n_attempts_password_reset"):
        login_form()
    return False


def change_frame_idx(offset):
    f_idx = st.session_state.get("frame_idx", 0)
    print(f"A {f_idx=}")
    f_idx = min(max(0, f_idx + (offset * N_PER_FRAME)), (last_frame_idx * N_PER_FRAME))
    print(f"B {f_idx=}")
    st.session_state.update({
        "frame_idx": f_idx
    })


# un = st.session_state.get('user_full_name')
# if not un:
#     un = "NO NAME YET"
# print(f"RERUN for '{un}'")
# count = st_autorefresh(interval=TIME_APP_REFRESH, limit=None, key="auto_refresh")


with grid["title_row"]:
    st.markdown(coloured_text("Streamlit Authentication Demo", "#653131", html_tags="h1"), unsafe_allow_html=True)


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
        with grid["top_bar"][2]:
            styled_un = coloured_text(un, "#797979")
            html = f"<div><span>signed in as </span>{styled_un}</div>"
            st.markdown(html, unsafe_allow_html=True)

        with grid["content_row_0"]:
            # st.write(f"Hello {st.session_state.get('user_full_name')}!")
            add_vertical_space(4)
            st.write(f"Thank you for trying out our BWS Streamlit sign-in service!")
            st.write(f"More coming soon, Please check back later.")

            user_name = st.session_state.get("user_name")

            toggle_admin_mode = st.toggle(
                label="Admin Mode",
                key="toggle_admin_mode"
            )

            if st.session_state.get("toggle_admin_mode"):

                frame_idx = st.session_state.get("frame_idx")
                first_idx = frame_idx
                last_idx = first_idx + N_PER_FRAME - 1

                cols_controls = st.columns([0.15, 0.15, 0.15, 0.55])
                button_back = cols_controls[0].button(
                    label="prev",
                    key="button_frame_back",
                    on_click=lambda: change_frame_idx(-1),
                    disabled=frame_idx == 0
                )

                cols_controls[1].write(
                    f"{frame_idx=}, {first_idx=}, {last_idx=}, {last_frame_idx*N_PER_FRAME=}"
                )

                button_forward = cols_controls[2].button(
                    label="next",
                    key="button_frame_forward",
                    on_click=lambda: change_frame_idx(1),
                    disabled=frame_idx == (last_frame_idx * N_PER_FRAME)
                )

                data_grid = []
                edit_columns = [
                    {
                        "name": "Name",
                        "weight": 0.2
                    },
                    {
                        "name": "Display Name",
                        "weight": 0.2
                    },
                    {
                        "name": "DoB",
                        "weight": 0.15
                    },
                    {
                        "name": "ShirtSize",
                        "weight": 0.15
                    },
                    {
                        "name": "Ext",
                        "weight": 0.15
                    },
                    {
                        "name": "Cell",
                        "weight": 0.15
                    }
                ]
                weights = [col["weight"] for col in edit_columns]
                cols_names = [col["name"] for col in edit_columns]
                data_grid.append(st.columns(weights))
                for i, col in enumerate(cols_names):
                    data_grid[0][i].write(col)

                df_itr_cust_filt = df_itr_customers.loc[
                    (df_itr_customers.index >= first_idx)
                    & (df_itr_customers.index <= last_idx)
                ].reset_index()

                # st.dataframe(df_itr_cust_filt)

                for i, row in df_itr_cust_filt.iterrows():
                    data_grid.append(st.columns(weights))
                    name = row["Name"]
                    print(f"{i=}, {name=}")
                    dob_y: int = row["BirthYear"]
                    dob_m: int = row["BirthMonth"]
                    dob_d: int = row["BirthDay"]
                    dob: Optional[datetime.datetime] = None
                    shirt_size: str = row["ShirtSize"]
                    cell_phone: str = row["CellPhone"]
                    display_name: str = row.get("DisplayName", "")
                    ext: str = row.get("Extension", "")

                    k_name: str = f"text_input_name_{i}"
                    k_dob: str = f"date_input_dob_{i}"
                    k_shirt_size: str = f"selectbox_shirtsize_{i}"
                    k_display_name: str = f"text_input_display_name_{i}"

                    if not any([pd.isna(dob_y), pd.isna(dob_m), pd.isna(dob_d)]):
                        dob = datetime.datetime(int(dob_y), int(dob_m), int(dob_d))

                    if pd.isna(display_name):
                        display_name = ""

                    if pd.isna(ext):
                        ext = ""

                    st.session_state.update({
                        k_name: name,
                        k_dob: dob,
                        k_shirt_size: shirt_size,
                        k_display_name: display_name
                    })

                    # data_grid[i + 1][cols_names.index("Name")].write(name)
                    data_grid[i + 1][cols_names.index("Name")].text_input(
                        label="Name",
                        key=k_name,
                        label_visibility="hidden",
                        disabled=True
                    )
                    # data_grid[i + 1][cols_names.index("Display Name")].write(display_name)
                    data_grid[i + 1][cols_names.index("Display Name")].text_input(
                        label="Display Name",
                        key=k_display_name,
                        label_visibility="hidden"
                    )
                    data_grid[i + 1][cols_names.index("DoB")].date_input(
                        label="DoB",
                        key=k_dob,
                        label_visibility="hidden",
                        format="YYYY-MM-DD"
                    )
                    # selectbox
                    data_grid[i + 1][cols_names.index("ShirtSize")].selectbox(
                        label="ShirtSize",
                        key=k_shirt_size,
                        options=list_shirt_sizes,
                        label_visibility="hidden"
                    )
                    data_grid[i + 1][cols_names.index("Ext")].write(ext)
                    data_grid[i + 1][cols_names.index("Cell")].write(cell_phone)


                # # Sample data
                # data = [
                #     {"Name": "Alice", "Role": "Admin", "Department": "HR"},
                #     {"Name": "Bob", "Role": "User", "Department": "Engineering"},
                #     {"Name": "Charlie", "Role": "User", "Department": "Sales"}
                # ]
                #
                # # Define selectable options for each column
                # role_options = ["Admin", "User", "Guest"]
                # department_options = ["HR", "Engineering", "Sales", "Marketing"]
                #
                # # Streamlit data editor with column configuration
                # edited_data = st.data_editor(
                #     data,
                #     column_config={
                #         "Role": st.column_config.SelectboxColumn(
                #             "Role",
                #             options=role_options
                #         ),
                #         "Department": st.column_config.SelectboxColumn(
                #             "Department",
                #             options=department_options
                #         )
                #     },
                #     key="editable_table_multi"
                # )
                #
                # # Display edited data
                # st.write("Edited Table:", edited_data)
            else:
                df_user: pd.DataFrame = df_user_directory.loc[df_user_directory["AppUserName"] == user_name]
                cust_id: int = df_user.iloc[0]["ITRCustomerID"]
                df_cust: pd.DataFrame = df_itr_customers.loc[df_itr_customers["CustomerID"] == cust_id].iloc[0]

                cust_dob_y: int = df_cust["BirthYear"]
                cust_dob_m: int = df_cust["BirthMonth"]
                cust_dob_d: int = df_cust["BirthDay"]
                cust_dob: Optional[datetime.datetime] = None
                # print(f"{cust_dob_y=}, {cust_dob_m=}, {cust_dob_d=}")

                cust_shirt_size = df_cust["ShirtSize"]

                if not any([pd.isna(cust_dob_y), pd.isna(cust_dob_m), pd.isna(cust_dob_d)]):
                    cust_dob = datetime.datetime(int(cust_dob_y), int(cust_dob_m), int(cust_dob_d))

                if not pd.isna(cust_shirt_size):
                    st.session_state.update({"select_shirt_size": cust_shirt_size})

                with st.expander(":pencil2: Edit Personal Data"):
                    with st.form(key="Customer"):
                        st.date_input(
                            label="Change your Birthdate:",
                            value=cust_dob,
                            min_value=datetime.datetime(1935, 1, 1),
                            max_value=datetime.datetime.now() + datetime.timedelta(days=-int(round((18*365.25)))),
                            key="date_input_birthdate"
                            # ,
                            # on_change=birthdate_on_change
                        )
                        st.selectbox(
                            label="Shirt-Size:",
                            key="select_shirt_size",
                            options=list_shirt_sizes
                        )
                        st.form_submit_button(
                            label="Update",
                            on_click=lambda: submit_form("Customer")
                        )

# st.write(st.session_state)
