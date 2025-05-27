import datetime
import os

import streamlit as st
import pandas as pd
from typing import Any, Optional

from pyodbc_connection import connect
from sql_utility import create_sql, get_database_tables, get_table_cols
from streamlit_utility import coloured_text
from utility import money

MAX_QUERY_HOLD_TIME: int = 1000 * 60 * 2  # 2 hours
MAX_FILE_HOLD_TIME: int = 1000 * 60 * 6  # 6 hours
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


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_departments() -> pd.DataFrame:
    """
    Load unique department names with the first claimed ID for each label.
    :return: pd.DataFrame(columns=["MinOfDeptID", "Dept"])
    """
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
    """
    Load all path_data from [ITR Hardware]
    :return: pd.DataFrame() # columns unknown
    """
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
    """
    Load all path_data from [ITR Software]
    :return: pd.DataFrame() # columns unknown
    """
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
    """
    Load all path_data from [ITR Training]
    :return: pd.DataFrame() # columns unknown
    """
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
    """
    Load all path_data from [IT Requests]
    :return: pd.DataFrame() # columns unknown
    """
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
    """
    Load all path_data from [ITR Customers]
    :return: pd.DataFrame() # columns unknown
    """
    # sql = "[BWSdb].[dbo].[ITR Customers]"
    # connection_data = {
    #     "sql": sql,
    #     "database": "bwsdb",
    #     "uid": CREDS_BWS["uid"],
    #     "pwd": CREDS_BWS["pwd"]
    # }
    # return connect(**connection_data)
    return connect(create_sql("ITR Customers", where="[Active] = 1"))


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_itr_personnel() -> pd.DataFrame:
    """
    Load all path_data from [IT Personnel]
    :return: pd.DataFrame() # columns unknown
    """
    return connect(create_sql("IT Personnel", where="[Active] = 1"))


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_itstr_app_directory() -> pd.DataFrame:
    """
    Load all path_data from [ITSTR_AppDirectory]
    :return: pd.DataFrame() # columns unknown
    """
    # sql = "[BWSdb].[dbo].[ITSTR_AppDirectory]"
    # connection_data = {
    #     "sql": sql,
    #     "database": "bwsdb",
    #     "uid": CREDS_BWS["uid"],
    #     "pwd": CREDS_BWS["pwd"]
    # }
    # return connect(**connection_data)
    return connect(create_sql("ITSTR_AppDirectory", where="[Active] = 1"))


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_itstr_user_directory() -> pd.DataFrame:
    """
    Load all path_data from [ITSTR_UserDirectory]
    :return: pd.DataFrame() # columns unknown
    """
    # sql = "[BWSdb].[dbo].[ITSTR_UserDirectory]"
    # connection_data = {
    #     "sql": sql,
    #     "database": "bwsdb",
    #     "uid": CREDS_BWS["uid"],
    #     "pwd": CREDS_BWS["pwd"]
    # }
    # return connect(**connection_data)
    return connect(create_sql("ITSTR_UserDirectory", where="[Active] = 1"))


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def get_tables(db: str) -> pd.DataFrame:
    """
    Caching return DF of Database columns.
    :param db: Database name as a string ex:'BWSdb'
    :return: pd.DataFrame(columns=["TABLE_CATALOG", "TABLE_NAME", "COLUMN_NAME", "PRIMARY_KEY", "DATA_TYPE", "CHARACTER_MAXIMUM_LENGTH"])
    """
    return get_database_tables(db)


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def get_cols(table: str, database: str):
    """
    Similar to get_tables, except that you can cross-reference with a given table name.
    :param table: Table name as string ex:'Orders'
    :param db: Database name as a string ex:'BWSdb'
    :return: pd.DataFrame(columns=["TABLE_CATALOG", "TABLE_NAME", "COLUMN_NAME", "PRIMARY_KEY", "DATA_TYPE", "CHARACTER_MAXIMUM_LENGTH"])
    """
    # st.write(f"GET_COLS -> {table=}, {database=}")
    return get_table_cols(table, database, use_streamlit_cache=True)


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_FILE_HOLD_TIME)
def load_production_file(file_name: str):
    """
    Load a file into the cache for later retrieval, defaults to files in Server3/Production
    :param file_name: File name as string ex:'SysproCompanyA.accdb'
    :return: File contents as binary.
    """
    dn = os.path.dirname(file_name)
    bn = os.path.basename(file_name)
    if not dn:
        dn = r"\\server3.bwsdomain.local\Production"
    path = os.path.join(dn, bn)
    if not os.path.exists(path):
        raise ValueError(f"Could not find file '{path}'.")

    print(f"## LPD ## {path=}")
    with open(path, "rb") as f:
        content = f.read()

    return content


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_itp_phone_lines():
    return connect(create_sql("ITP PhoneLines", where="[Active] = 1"))


def get_next_it_request_number() -> int:
    """
    this function needs to be called as close to the insert as possible to reduce race condition
    bugs caused by a faster user claiming a pre-distributed ITR ID #.
    :return: integer representing the next available ID on [IT Requests]
    """
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
        raise ValueError(
            f"Critical Error could not retrieve a new IT Request ID Number for this input. Please try again later.")
    return df.iloc[0]["LastID"] + 1


@st.dialog(title="Who are you?", width="large")
def who_are_you():
    if st.button(
        label="quit",
        key="who_are_you_quit"
    ):
        st.rerun()


@st.dialog(title="Sign in", width="large")
def check_password(app_short_name: str = None):
    """Returns `True` if the user had a correct password."""

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
    }
    for k, v in DEFAULT_SESSION_STATE.items():
        st.session_state.setdefault(k, v)

    st.session_state.update({"radios_choose_user": False})

    # df_user_directory = st.session_state.setdefault("df_user_directory", load_itstr_user_directory())
    # df_app_directory = st.session_state.setdefault("df_app_directory", load_itstr_app_directory())
    df_user_directory = load_itstr_user_directory()
    df_app_directory = load_itstr_app_directory()
    df_itr_customers = load_itr_customers()

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

    if app_short_name is None:
        app_short_name = st.session_state.get("app_short_name", "UNKNOWN")
    st.write(f"{app_short_name=}")
    st.write(f"app_requires_password={st.session_state.get('app_requires_password')}")

    grid = {
        "title_row": st.container(),
        "credentials_row": st.container()
    }

    def validate_name(*args):
        print(f"VN {args=}")
        name = st.session_state.get("text_input_username", "").lower()
        if not name:
            return
        dfs: list[pd.DataFrame] = [
            df_itr_customers.loc[df_itr_customers["Name"].str.lower() == name],
            df_itr_customers.loc[df_itr_customers["Name"].str.lower().str.contains(name)],
            df_user_directory.loc[df_user_directory["AppUserName"].str.lower() == name],
            df_user_directory.loc[df_user_directory["AppUserName"].str.lower().str.contains(name)]
        ]

        for i, df in enumerate(dfs):
            nk = "AppUserName" if "AppUserName" in df.columns else "Name"
            uk = "ITRCustomerID" if "ITRCustomerID" in df.columns else "CustomerID"
            names = df[nk].dropna().unique()
            if len(names) > 1:
                for j, name in enumerate(names):
                    key = f"choose_user_{j}"
                    if key in st.session_state:
                        del st.session_state[key]
                    if grid["credentials_row"].button(
                        label=name.title(),
                        key=key
                    ):
                        print(f"HELLO THERE")
                        cust_id: int = df.iloc[0][uk]
                        st.write(f"{cust_id=}")
                        df_cust: pd.DataFrame = df_itr_customers.loc[df_itr_customers["CustomerID"] == cust_id]
                        # st.write("DF_CUST:")
                        # st.dataframe(df_cust)
                        full_name = df_cust.iloc[0]["Name"]
                        st.session_state.update({
                            "radios_choose_user": i,
                            "handled_radios_choose_user": True,
                            "signed_in": True,
                            "user_name": name,
                            "itr_customer_id": cust_id,
                            "user_full_name": full_name,
                            "sign_in_date": datetime.datetime.now()
                        })
                        password_entered()

                break

        print(f"{name=}")

    def login_form():
        """Form with widgets to collect user information"""
        n = datetime.datetime.now()
        # with grid["title_row"].form(f"Credentials_{n:%x %X}"):
        # with grid["title_row"].form(f"Credentials"):
        with grid["title_row"].container():
            st.dataframe(df_itr_customers)
            st.dataframe(df_user_directory)
            st.dataframe(df_app_directory)
            st.write(f"### Please Sign in:")
            st.text_input(
                label="Username",
                key="text_input_username",
                on_change=validate_name
            )
            if st.session_state.get("app_requires_password", True):
                st.text_input("Password", type="password", key="text_input_password")
            # st.form_submit_button("Log in", on_click=password_entered)
            st.button("Log in", on_click=password_entered)

    def password_entered():
        """Checks whether a password entered by the user is correct."""
        user: str = st.session_state.get("text_input_username", "").lower()
        pswd: str = st.session_state.get("text_input_password", "")
        atpt: int = st.session_state.get("n_attempts_password", DEFAULT_SESSION_STATE["n_attempts_password"])
        matp: int = DEFAULT_SESSION_STATE["n_attempts_password_reset"]
        # st.dataframe(df_user_directory)
        df_user: pd.DataFrame = df_user_directory.loc[df_user_directory["AppUserName"] == user]
        df_user_l = df_user.copy()
        names = []

        print(f"PE:: {user=}, {pswd=}, {atpt=}, {matp=}")


        cust_id: int = 1
        cust_key: str = "ITRCustomerID"

        radio_toggles = []

        def check_others(i_, k_):
            print(f"check_others {i_=}, {k_=}")
            # i = -1
            # check = True
            # is_on = st.session_state.get(k_, False)
            # while check:
            #     i += 1
            #     key = f"radio_toggle_{i}"
            #     found = key in st.session_state
            #     if is_on and found and (i_ != (i)):
            #         st.session_state.update({key: False})
            #     check = found
            # print(f"check_others {i_=}, {k_=}, {i=}, {is_on=}")
            # if is_on:
            st.session_state.update({
                "radios_choose_user": i_,
                "handled_radios_choose_user": True
            })
            st.rerun()

        trc = ""
        st.session_state.update({
            "handled_radios_choose_user": True,
            "radios_choose_user": None
        })

        if df_user.empty:
            trc += "A"
            if df_app_directory.iloc[0]["MasterPassword"] == pswd:
                trc += "B"
                df_user: pd.DataFrame = df_user_directory.loc[df_user_directory["AppUserName"].str.lower() == user]
                df_user_l = df_user.copy()
        if df_user.empty:
            trc += "C"
            df_cust: pd.DataFrame = df_itr_customers.loc[
                (df_itr_customers["WindowsUser"].str.lower() == user)
                | (df_itr_customers["Name"].str.lower() == user)
                ].reset_index()
            if not df_cust.empty:
                trc += "D"
                cust_id: int = df_cust.iloc[0]["CustomerID"]
                # st.write(f"{cust_id}")
                # st.write(f"{app_id}")
                # st.write(df_user_directory_og)
                df_user: pd.DataFrame = df_user_directory.loc[
                    (df_user_directory["ITSTRAppID"] == app_id)
                    & (df_user_directory["ITRCustomerID"] == cust_id)
                    ]
                df_user_l = df_user.copy()
                # names = df_user_l["Name"].dropna().unique().tolist()
                if df_user.empty:
                    trc += "E"
                    df_user = pd.concat([
                        pd.DataFrame(columns=df_user.columns),
                        pd.DataFrame(data={
                            "AppUserName": [user],
                            "ITRCustomerID": cust_id
                        })
                    ])
                    df_user_l = df_user.copy()
                    # names = df_user_l["Name"].dropna().unique().tolist()
                    st.write(
                        f"Need to add this person from [ITR Customers]. '{user}' ({cust_id=}) does not have an entry for Streanlit app ID={app_id}")
                    if not st.session_state.get("app_requires__password"):
                        trc += "F"
                        st.write("Access granted as no password is needed.")
                else:
                    trc += "G"
                    st.write(f"Found by FullName in [ITSTR_UserDirectory]")
        if df_user.empty:
            trc += "H"
            df_user_l: pd.DataFrame = df_itr_customers.loc[
                df_itr_customers["Name"].str.lower().str.contains(user)
            ]
            names = df_user_l["Name"].dropna().unique().tolist()
            grid["credentials_row"].write("df_user_l")
            grid["credentials_row"].dataframe(df_user_l)
            sh = df_user_l.shape
            cust_key = "CustomerID"
            if sh[0] == 1:
                # 1 match
                trc += "I"
                df_user = df_user_l
                # st.session_state.update({"handled_radios_choose_user": True})
            elif sh[0] > 1:
                # st.write()
                trc += "J"
                # if not st.session_state.get("handled_radios_choose_user"):
                # trc += "K"
                del st.session_state[" "]
                st.session_state.update({
                    "handled_radios_choose_user": False,
                    "req_handled_radios_choose_user": True
                })
                # radios_choose_user = grid["credentials_row"].radio(
                #     label=f"Found {sh[0]} name({'' if sh[0] == 1 else 's'}), please tell me who you are:",
                #     key="radios_choose_user",
                #     options=names
                # )
                # for i, name in enumerate(names):
                #     key = f"radio_toggle_{i}"
                #     if key in st.session_state:
                #         del st.session_state[key]
                #     if grid["credentials_row"].button(
                #         label=name,
                #         key=key
                #     ):
                #         print(f"HELLO THERE")
                #         trc += "L"
                #         cust_id: int = df_user.iloc[0][cust_key]
                #         st.write(f"{cust_id=}")
                #         df_cust: pd.DataFrame = df_itr_customers.loc[df_itr_customers["CustomerID"] == cust_id]
                #         # st.write("DF_CUST:")
                #         # st.dataframe(df_cust)
                #         full_name = df_cust.iloc[0]["Name"]
                #         st.session_state.update({
                #             "radios_choose_user": i,
                #             "handled_radios_choose_user": True,
                #             "signed_in": True,
                #             "user_name": user,
                #             "itr_customer_id": cust_id,
                #             "user_full_name": full_name,
                #             "sign_in_date": datetime.datetime.now()
                #         })
                #         # raise ValueError("HEY!")
                #         # return True
                #         st.rerun()
                #     else:
                #         print(f"{i=}, {name=}, ELSE")
                #     # radio_toggles.append(
                #     #     grid["credentials_row"].button(
                #     #         label=name,
                #     #         key=key,
                #     #
                #     #         # on_change=lambda i_=i, k_=key: check_others(i_, k_)
                #     #     )
                #     # )
                #     # if radio_toggles[-1]:
                #     #     trc += "L"
                #     #     st.session_state.update({
                #     #         "radios_choose_user": i,
                #     #         "handled_radios_choose_user": True
                #     #     })
                #     #     # st.rerun()
                #
                # # else:\

            else:
                trc += "Q"

        hrcu = st.session_state.get("handled_radios_choose_user", False)
        st.write(f"{user=}, {pswd=}, {atpt=}, {matp=}, {hrcu=}")
        print(f"{trc=}, {user=}, {pswd=}, {atpt=}, {matp=}, {hrcu=}, {df_user.empty=}")
        print(f"COLS={list(df_user.columns)}")
        for k, v in st.session_state.items():
            print(f"{k=}, {v=}")
        # st.write(f"B")
        # st.dataframe(df_user)
        if st.session_state.get("handled_radios_choose_user", False):

            if st.session_state.get("radios_choose_user") is not None:
                trc += "M"
                user_name_idx = st.session_state.get('radios_choose_user')
                print(f"{user_name_idx=}")
                if user_name_idx is not None:
                    trc += "N"
                    user_name = names[user_name_idx]
                else:
                    trc += "O"
                    user_name = ""
                print(f"I AM name #{user_name_idx} -> '{user_name}'")
                if user_name:
                    trc += "P"
                    df_user = df_user_l.loc[df_user_l["Name"] == user_name]
                    cust_id = df_user.iloc[0][cust_key]
                    df_user = pd.concat([
                        pd.DataFrame(columns=df_user.columns),
                        pd.DataFrame(data={
                            "AppUserName": [user],
                            cust_key: cust_id
                        })
                    ])
            else:
                print("radios_choose_user IS NONE")

            with grid["credentials_row"]:
                if not df_user.empty:
                    # found user
                    if st.session_state.get("app_requires_password", True):
                        df_user: pd.DataFrame = df_user.loc[df_user["AppPassword"] == pswd].reset_index()
                    st.write(" > > DF_USER: ->")
                    st.dataframe(df_user)
                    if not df_user.empty:
                        # valid user and valid password
                        cust_id: int = df_user.iloc[0][cust_key]
                        st.write(f"{cust_id=}")
                        df_cust: pd.DataFrame = df_itr_customers.loc[df_itr_customers["CustomerID"] == cust_id]
                        # st.write("DF_CUST:")
                        # st.dataframe(df_cust)
                        full_name = df_cust.iloc[0]["Name"]
                        st.write(f"{full_name=}")
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
        # check_password()

    # valid sign in
    print(f"AAA {st.session_state.get('signed_in')=}")
    if st.session_state.get("signed_in", False):
        # return True
        st.rerun()

    # show form if attempts remain
    if st.session_state.get("app_requires_user_name"):
        # st.write("USER REQUIRED")
        if st.session_state.get("n_attempts_password") < st.session_state.get("n_attempts_password_reset"):
            # if not st.session_state.get("handled_radios_choose_user"):
            login_form()
        else:
            st.write("TOO MANY ATTEMPTS")
    else:
        st.write("NO USER REQUIRED")
        # return True
        st.rerun()
    # return False


def metrics(df, metric_col: str, delta_col: Optional[str] = None):
    cols_metric = st.columns(3)
    with cols_metric[0]:
        df_w = df.copy()
        df_w["RnkAvg"] = \
            df_w[metric_col].rank(
                method="average",
                ascending=False
            )
        df_w.sort_values(
            by=metric_col,
            ascending=False,
            inplace=True
        )
        sr_top = df_w.iloc[0]
        avg_pop = df_w[metric_col].mean()
        diff = avg_pop - float(sr_top['ValueOnHand'])
        if delta_col is not None:
            delta = f"Top Avg Diff: '{sr_top[selectbox_df_inventory_graph_by_ValueOnHand]}' ({money(diff)})"
        else:
            delta = f"Top Avg Diff: ({money(diff)})"
        st.metric(
            label="Mean:",
            value=money(avg_pop),
            delta=delta,
            border=1,
            delta_color="inverse" if diff < 0 else "normal"
        )
        # with cols_metric_0[1]:
        df_w = df.copy()
        df_w.sort_values(
            by=metric_col,
            ascending=False,
            inplace=True
        )
        sr_med = df_w.iloc[df_w.shape[0] // 2]
        st.metric(
            label="Median:",
            value=money(sr_med[metric_col]),
            border=1
        )
        # with cols_metric_0[2]:
        df_mode = df_w[metric_col].mode().iloc[0]
        # st.write(df_mode)
        # st.write(type(df_mode))
        st.metric(
            label="Mode:",
            value=money(df_mode),
            border=1
        )
    with cols_metric[1]:
        st.metric(
            label="Total:",
            value=money(
                df[metric_col].sum()
            ),
            border=1
        )
        if delta_col is not None:
            st.metric(
                label="Min:",
                value=money(
                    df.loc[
                        df[metric_col].idxmin(),
                        metric_col]
                ),
                delta=f"{selectbox_df_inventory_graph_by_ValueOnHand}: {df.loc[
                    df[metric_col].idxmin(),
                    selectbox_df_inventory_graph_by_ValueOnHand]}",
                border=1,
                delta_color="off"
            )
        else:
            st.metric(
                label="Min:",
                value=money(
                    df.loc[
                        df[metric_col].idxmin(),
                        metric_col]
                ),
                border=1
            )

    with cols_metric[2]:
        st.metric(
            label="St. Dev.:",
            value=money(
                df[metric_col].std()
            ),
            border=1
        )
        if delta_col is not None:
            st.metric(
                label="Max:",
                value=money(
                    df.loc[
                        df[metric_col].idxmax(),
                        metric_col]
                ),
                delta=f"{selectbox_df_inventory_graph_by_ValueOnHand}: {df.loc[
                    df[metric_col].idxmax(),
                    selectbox_df_inventory_graph_by_ValueOnHand]}",
                border=1,
                delta_color="off"
            )
        else:
            st.metric(
                label="Max:",
                value=money(
                    df.loc[
                        df[metric_col].idxmax(),
                        metric_col]
                ),
                border=1
            )


@st.cache_data(ttl=None, show_spinner=True)
def load_products_bws():
	return connect("Products")


@st.cache_data(ttl=None, show_spinner=True)
def load_dealers_bws():
	return connect("Dealers")


@st.cache_data(ttl=None, show_spinner=True)
def load_orders_bws():
	return connect("Orders")


@st.cache_data(show_spinner=True, ttl=MAX_QUERY_HOLD_TIME)
def load_sql_data(sql, **connection_data) -> pd.DataFrame:
	return connect(sql, **connection_data)


def load_orders() -> pd.DataFrame:
	return load_sql_data("Orders")


def load_orders2() -> pd.DataFrame:
	return load_sql_data("OrdersV2")


def load_dealers() -> pd.DataFrame:
	return load_sql_data("Dealers")


def load_dealers2() -> pd.DataFrame:
	return load_sql_data("DealersV2")


def load_order_standards() -> pd.DataFrame:
	return load_sql_data("Order Standards")


def load_order_standards2() -> pd.DataFrame:
	return load_sql_data("Order StandardsV2")


def load_options() -> pd.DataFrame:
	return load_sql_data("Order Options")


def load_options2() -> pd.DataFrame:
	return load_sql_data("Order OptionsV2")


def load_npos() -> pd.DataFrame:
	return load_sql_data("Custom Work")


def load_npos2() -> pd.DataFrame:
	return load_sql_data("Custom WorkV2")


def load_production() -> pd.DataFrame:
	return load_sql_data("Production")


def load_production2() -> pd.DataFrame:
	return load_sql_data("ProductionV2")


def load_inventory_bws() -> pd.DataFrame:
    return load_sql_data(
        "InvMaster",
        database="SysproCompanyA",
        uid="SRS",
        pwd=""
    )


def load_inventory_stg() -> pd.DataFrame:
    return load_sql_data(
        "InvMaster",
        database="SysproCompanyS",
        uid="SCSRS",
        pwd=""
    )


if __name__ == '__main__':

    st.write("Hello")
    signed_in = st.session_state.get("signed_in", False)
    if not signed_in:
        check_password()
        # st.write(f"## Invalid Credentials.")
        # st.write("##### Please contact IT for further assistance with this app.")
        # st.stop()
    else:
        un = st.session_state.get('user_full_name')
        st.session_state.update({"text_input_requested_by": un})

        # with grid["top_bar"][2]:
        styled_un = coloured_text(un, "#797979")
        html = f"<div><span>signed in as </span>{styled_un}</div>"
        st.markdown(html, unsafe_allow_html=True)