from typing import Any

import pandas as pd
import streamlit as st
from streamlit_extras.add_vertical_space import add_vertical_space

from pyodbc_connection import connect


#####################
# Company Boilerplate
#####################


APP_SHORT_NAME = "Monitoring Schedule"
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


# call this first or streamlit will be cranky if you do it later.
st.set_page_config(layout="wide")
st.title(APP_SHORT_NAME)
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
    "app_short_name": APP_SHORT_NAME,
    "radio_sort_col_choice": "None",
    "radio_sort_order_choice": "Descending"
}
for k, v in DEFAULT_SESSION_STATE.items():
    st.session_state.setdefault(k, v)


######################
# Data Fetch Functions
######################


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_data_stg() -> pd.DataFrame:
    sql = """
SELECT
	[OrdersV2].[SGQuote]
    ,[OrdersV2].[WO#]
    ,CASE WHEN [v_CompletedJobInfo].[EntInvoiceDate] IS NOT NULL THEN 13
        WHEN [WipMaster].[ActCompleteDate] IS NOT NULL THEN 12
        WHEN [SubWiPLabourIssued].[NetLabourCharged] <> 0 THEN 10
        WHEN [SubWiPPartsIssued].[NetIssued] <> 0 THEN 9
        WHEN [DesignV2].[BOM Complete For Review] IS NOT NULL THEN 7
        WHEN [DesignV2].[Complete] = 1 THEN 6
        WHEN [OrdersV2].[Prom Drawing] = 1 THEN 5
        WHEN [WipMaster].[Job] IS NOT NULL THEN 4
        WHEN [LongLeadQuoteMaster].[SGQuote] IS NOT NULL THEN 3
        WHEN [OrdersV2].[WO Reviewed] = 1 THEN 2
        WHEN [SorMaster].[SalesOrder] IS NOT NULL THEN 1
        ELSE 0
        END AS [UnitStatusID]
    ,CASE WHEN [v_CompletedJobInfo].[EntInvoiceDate] IS NOT NULL THEN 'Unit Invoiced'
        WHEN [WipMaster].[ActCompleteDate] IS NOT NULL THEN 'Work Order Closed'
        WHEN [SubWiPLabourIssued].[NetLabourCharged] <> 0 THEN 'First Labour Issued'
        WHEN [SubWiPPartsIssued].[NetIssued] <> 0 THEN 'First Parts Issued'
        WHEN [DesignV2].[BOM Complete For Review] IS NOT NULL THEN 'Bill of Material Reviewed'
        WHEN [DesignV2].[Complete] = 1 THEN 'Engineering Prints Done'
        WHEN [OrdersV2].[Prom Drawing] = 1 THEN 'Promo Drawing Approved by Customer'
        WHEN [WipMaster].[Job] IS NOT NULL THEN 'HAS a Work Order'
        WHEN [LongLeadQuoteMaster].[SGQuote] IS NOT NULL THEN 'HAS a Long Lead Quote made'
        WHEN [OrdersV2].[WO Reviewed] = 1 THEN 'Reviewed at Sales Order Meeting'
        WHEN [SorMaster].[SalesOrder] IS NOT NULL THEN 'HAS a Sales Order in Syspro'
        ELSE 'New unit/yet to be reviewed at Sales Order Meeting/Unit out of milestone scope'
        END AS [UnitStatusDesc]
FROM
    [BWSdb].[dbo].[OrdersV2] WITH (NOLOCK)
LEFT OUTER JOIN
    [SysproCompanyA].[dbo].[SorMaster] WITH (NOLOCK)
ON
    [OrdersV2].[Sales Order#] = [SorMaster].[SalesOrder]
LEFT OUTER JOIN
    [Stargatedb].[dbo].[LongLeadQuoteMaster] WITH (NOLOCK)
ON
    [OrdersV2].[SGQuote] = [LongLeadQuoteMaster].[SGQuote]
LEFT OUTER JOIN
    [SysproCompanyS].[dbo].[WipMaster] WITH (NOLOCK)
ON
    CAST([OrdersV2].[WO#] AS NVARCHAR(20)) = [WipMaster].[Job]
LEFT OUTER JOIN
    [BWSdb].[dbo].[DesignV2] WITH (NOLOCK)
ON
    [OrdersV2].[SGQuote] = [DesignV2].[SGQuote]
LEFT OUTER JOIN
    (
        SELECT
			[Job]
            ,SUM([QtyIssued]) AS [NetIssued]
        FROM
            [SysproCompanyS].[dbo].[WipJobAllMat] WITH (NOLOCK)
        GROUP BY
            [Job]
    ) AS [SubWiPPartsIssued]
ON
    [WipMaster].[Job] = [SubWiPPartsIssued].[Job]
LEFT OUTER JOIN
    (
        SELECT
			[Job]
            ,SUM([RunTimeIssued]) AS [NetLabourCharged]
        FROM
            [SysproCompanyS].[dbo].[WipJobAllLab] WITH (NOLOCK)
        GROUP BY
            [Job]
    ) AS [SubWiPLabourIssued]
ON
    [WipMaster].[Job] = [SubWiPLabourIssued].[Job]
LEFT OUTER JOIN
    [SysproCompanyS].[dbo].[v_CompletedJobInfo]
ON
    CAST([OrdersV2].[WO#] AS NVARCHAR(20)) = [v_CompletedJobInfo].[Job]
"""
    connection_data = {
        "sql": sql,
        "database": "bwsdb",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect(**connection_data)


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_data_bws() -> pd.DataFrame:
    sql = """
SELECT
	[Orders].[Quote#]
    ,[Orders].[WO#]
    ,CASE WHEN [v_CompletedJobInfo].[EntInvoiceDate] IS NOT NULL THEN 13
        WHEN [WipMaster].[ActCompleteDate] IS NOT NULL THEN 12
        WHEN [SubWiPLabourIssued].[NetLabourCharged] <> 0 THEN 10
        WHEN [SubWiPPartsIssued].[NetIssued] <> 0 THEN 9
        WHEN [Design].[BOM Complete For Review] IS NOT NULL THEN 7
        WHEN [Design].[Complete] = 1 THEN 6
        WHEN [Orders].[Prom Drawing] IS NOT NULL THEN 5
        WHEN [WipMaster].[Job] IS NOT NULL THEN 4
        --WHEN [LongLeadQuoteMaster].[Quote#] IS NOT NULL THEN 3
        WHEN [Orders].[WO Reviewed] = 1 THEN 2
        WHEN [SorMaster].[SalesOrder] IS NOT NULL THEN 1
        ELSE 0
        END AS [UnitStatusID]
    ,CASE WHEN [v_CompletedJobInfo].[EntInvoiceDate] IS NOT NULL THEN 'Unit Invoiced'
        WHEN [WipMaster].[ActCompleteDate] IS NOT NULL THEN 'Work Order Closed'
        WHEN [SubWiPLabourIssued].[NetLabourCharged] <> 0 THEN 'First Labour Issued'
        WHEN [SubWiPPartsIssued].[NetIssued] <> 0 THEN 'First Parts Issued'
        WHEN [Design].[BOM Complete For Review] IS NOT NULL THEN 'Bill of Material Reviewed'
        WHEN [Design].[Complete] = 1 THEN 'Engineering Prints Done'
        WHEN [Orders].[Prom Drawing] IS NOT NULL THEN 'Promo Drawing Approved by Customer'
        WHEN [WipMaster].[Job] IS NOT NULL THEN 'HAS a Work Order'
        --WHEN [LongLeadQuoteMaster].[Quote#] IS NOT NULL THEN 'HAS a Long Lead Quote made'
        WHEN [Orders].[WO Reviewed] = 1 THEN 'Reviewed at Sales Order Meeting'
        WHEN [SorMaster].[SalesOrder] IS NOT NULL THEN 'HAS a Sales Order in Syspro'
        ELSE 'New unit/yet to be reviewed at Sales Order Meeting/Unit out of milestone scope'
        END AS [UnitStatusDesc]
FROM
    [BWSdb].[dbo].[Orders] WITH (NOLOCK)
LEFT OUTER JOIN
    [SysproCompanyA].[dbo].[SorMaster] WITH (NOLOCK)
ON
    [Orders].[Sales Order#] = [SorMaster].[SalesOrder]
--LEFT OUTER JOIN
--    [BWSdb].[dbo].[LongLeadQuoteMaster] WITH (NOLOCK)
--ON
--    [Orders].[Quote#] = [LongLeadQuoteMaster].[Quote#]
LEFT OUTER JOIN
    [SysproCompanyA].[dbo].[WipMaster] WITH (NOLOCK)
ON
    CAST([Orders].[WO#] AS NVARCHAR(20)) = [WipMaster].[Job]
LEFT OUTER JOIN
    [BWSdb].[dbo].[Design] WITH (NOLOCK)
ON
    [Orders].[Quote#] = [Design].[Quote#]
LEFT OUTER JOIN
    (
        SELECT
			[Job]
            ,SUM([QtyIssued]) AS [NetIssued]
        FROM
            [SysproCompanyA].[dbo].[WipJobAllMat] WITH (NOLOCK)
        GROUP BY
            [Job]
    ) AS [SubWiPPartsIssued]
ON
    [WipMaster].[Job] = [SubWiPPartsIssued].[Job]
LEFT OUTER JOIN
    (
        SELECT
			[Job]
            ,SUM([RunTimeIssued]) AS [NetLabourCharged]
        FROM
            [SysproCompanyA].[dbo].[WipJobAllLab] WITH (NOLOCK)
        GROUP BY
            [Job]
    ) AS [SubWiPLabourIssued]
ON
    [WipMaster].[Job] = [SubWiPLabourIssued].[Job]
LEFT OUTER JOIN
    [SysproCompanyA].[dbo].[v_CompletedJobInfo]
ON
    CAST([Orders].[WO#] AS NVARCHAR(20)) = [v_CompletedJobInfo].[Job]
"""
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


#################
# Helper Functions
#################


# Function to create HTML progress bar without newlines
def create_progress_bar_html(status_id):
    progress = (status_id / 13) * 100
    return f'<div style="width: 100%;"><div style="width: {progress}%; background-color: #76c7c0; text-align: center; color: white;">{progress:.1f}%</div></div>'


####################
# Fetch Data SLOW...
####################


df_stg = load_data_stg()
df_bws = load_data_bws()


###################################################
# Company Choice is critical for further processing
###################################################


add_vertical_space(3)
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
QUOTE_KEY = CREDS_STG["quote_key"] if COMP == STG else CREDS_BWS["quote_key"]


###########
# Prep Data
###########

# Select company appropriate data
MonitoringSchedulesqlquerydf = df_bws if COMP == BWS else df_stg

# Reformat WO# column as int
MonitoringSchedulesqlquerydf['WO#'] = MonitoringSchedulesqlquerydf['WO#'].apply(lambda x: int(x) if pd.notna(x) else x)
MonitoringSchedulesqlquerydf['WO#'] = MonitoringSchedulesqlquerydf['WO#'].apply(lambda x: '{:.0f}'.format(x) if pd.notna(x) else x)

# Add "Unit Progress" column with HTML progress bars
MonitoringSchedulesqlquerydf['Unit Progress'] = MonitoringSchedulesqlquerydf['UnitStatusID'].apply(create_progress_bar_html)

# Add "UnitStatusDesc" column as "Status Description" column at the end of the dataframe
MonitoringSchedulesqlquerydf['Status Description'] = MonitoringSchedulesqlquerydf['UnitStatusDesc']

# Drop UnitStatusID & UnitStatusDesc columns
MonitoringSchedulesqlquerydf.drop(columns=['UnitStatusID', 'UnitStatusDesc'], inplace=True)


#######################
# Begin Widget Creation
#######################


grid = {
    "content_row_0": st.columns(2),
    "content_row_1": st.container()
}


options_sort_col = ["None"] + MonitoringSchedulesqlquerydf.columns.tolist()
with grid["content_row_0"][0]:
    radio_sort_col_choice = st.radio(
        "Sort Order:",
        options_sort_col,
        key="radio_sort_col_choice",
        horizontal=True
    )

options_sort_order = ["None", "Ascending", "Descending"]
sort_col = radio_sort_col_choice
sort_ord = st.session_state.get("radio_sort_order_choice")
if sort_col != "None":
    with grid["content_row_0"][1]:
        radio_sort_order_choice = st.radio(
            "Sort Order:",
            options_sort_order,
            key="radio_sort_order_choice",
            horizontal=True
        )
        sort_ord = radio_sort_order_choice

if (radio_sort_col_choice != "None") and (sort_ord != "None"):
    MonitoringSchedulesqlquerydf.sort_values(by=sort_col, ascending=sort_ord == "Ascending", inplace=True)

with grid["content_row_1"]:
    add_vertical_space(3)
    # Add SQL dataframe to streamlit site
    st.write(MonitoringSchedulesqlquerydf.to_html(escape=False, index=False), unsafe_allow_html=True)
