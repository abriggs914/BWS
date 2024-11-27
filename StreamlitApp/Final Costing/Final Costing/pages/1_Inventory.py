from typing import Any

import pandas as pd
import streamlit as st
import pygwalker as pyg
import streamlit.components.v1 as components

from pyodbc_connection import connect

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
}
for k, v in DEFAULT_SESSION_STATE.items():
    st.session_state.setdefault(k, v)


######################
# Data Fetch Functions
######################


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_inventory_view_bws_20241125() -> pd.DataFrame:
    sql = """v_InventoryItems_ExpensedAndIssued"""
    connection_data = {
        "sql": sql,
        "database": "SysproCompanyA",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect(**connection_data)


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_inventory_view_stg_20241125() -> pd.DataFrame:
    sql = """v_InventoryItems_ExpensedAndIssued"""
    connection_data = {
        "sql": sql,
        "database": "SysproCompanyS",
        "uid": CREDS_STG["uid"],
        "pwd": CREDS_STG["pwd"]
    }
    return connect(**connection_data)


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_inventory_view_bws_20241126() -> pd.DataFrame:
    sql = """
SELECT
    *
    , [UnitCost] * [QtyOnHand] as [ValueOnHand]
FROM
    [SysproCompanyA].[dbo].[InvWarehouse] WITH (NOLOCK)
;"""
    connection_data = {
        "sql": sql,
        "database": "SysproCompanyA",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect(**connection_data)


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_inventory_view_stg_20241126() -> pd.DataFrame:
    sql = """
SELECT 
    *
    , [UnitCost] * [QtyOnHand] as [ValueOnHand]
FROM
    [SysproCompanyS].[dbo].[InvWarehouse] WITH (NOLOCK)
;"""
    connection_data = {
        "sql": sql,
        "database": "SysproCompanyS",
        "uid": CREDS_STG["uid"],
        "pwd": CREDS_STG["pwd"]
    }
    return connect(**connection_data)


options_radio_dataset_choice = [
    "Dataset 20241125",
    "Dataset 20241126"
]
radio_company_choice = st.radio(
    "Company:",
    options_radio_dataset_choice,
    key="radio_dataset_choice",
    horizontal=True
)

df_inv_bws_20241125: pd.DataFrame = pd.DataFrame()
df_inv_stg_20241125: pd.DataFrame = pd.DataFrame()
df_inv_bws_20241126: pd.DataFrame = pd.DataFrame()
df_inv_stg_20241126: pd.DataFrame = pd.DataFrame()

old_data: bool = st.session_state.get("radio_dataset_choice") == options_radio_dataset_choice[0]

if old_data:
    df_inv_bws_20241125: pd.DataFrame = load_inventory_view_bws_20241125()
    df_inv_stg_20241125: pd.DataFrame = load_inventory_view_stg_20241125()
else:
    df_inv_bws_20241126: pd.DataFrame = load_inventory_view_bws_20241126()
    df_inv_stg_20241126: pd.DataFrame = load_inventory_view_stg_20241126()

# df_inv_bws_og: pd.DataFrame = df_inv_bws_20241125.copy()
# df_inv_stg_og: pd.DataFrame = df_inv_stg_20241125.copy()
# df_inv_bws_og: pd.DataFrame = df_inv_bws_20241125.copy()
# df_inv_stg_og: pd.DataFrame = df_inv_stg_20241125.copy()

df_bws: pd.DataFrame = df_inv_bws_20241125 if old_data else df_inv_bws_20241126
df_stg: pd.DataFrame = df_inv_stg_20241125 if old_data else df_inv_stg_20241126


st.write("## BWS")
st.dataframe(df_bws, use_container_width=True, hide_index=True)
st.write("## Stargate")
st.dataframe(df_stg, use_container_width=True, hide_index=True)


options_radio_company_choice = [
    ":red[BWS]",
    ":blue[STARGATE]"
]
radio_company_choice = st.radio(
    "Company:",
    options_radio_company_choice,
    key="radio_company_choice",
    horizontal=True
)


COMP = BWS if radio_company_choice == options_radio_company_choice[0] else STG

df = df_bws if COMP == BWS else df_stg

pyg_html = pyg.walk(df).to_html()
components.html(pyg_html, height=1000, scrolling=True)
# st.write(pyg_html)
