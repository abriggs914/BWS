import datetime
from typing import Any

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
    "app_short_name": "Authentication Demo"
}
for k, v in DEFAULT_SESSION_STATE.items():
    st.session_state.setdefault(k, v)


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


df_itr_customers: pd.DataFrame = load_itr_customers()
df_app_directory: pd.DataFrame = load_itstr_app_directory()
df_user_directory: pd.DataFrame = load_itstr_user_directory()
df_app_directory: pd.DataFrame = df_app_directory.loc[df_app_directory["AppShortName"] == st.session_state.get("app_short_name")]
app_id: int = df_app_directory.iloc[0]["ID"] if not df_app_directory.empty else -1

# st.write(f"{app_id=}, {type(app_id)=}")
# st.dataframe(df_app_directory, use_container_width=True)
# st.dataframe(df_user_directory, use_container_width=True)

df_user_directory: pd.DataFrame = df_user_directory.loc[df_user_directory["ITSTRAppID"] == app_id]
df_user_directory["AppUserName"] = df_user_directory["AppUserName"].str.lower()


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


un = st.session_state.get('user_full_name')
if not un:
    un = "NO NAME YET"
print(f"RERUN for '{un}'")
count = st_autorefresh(interval=TIME_APP_REFRESH, limit=None, key="auto_refresh")


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

# st.write(st.session_state)
