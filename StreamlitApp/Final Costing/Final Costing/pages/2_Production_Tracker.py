import datetime
import warnings

import pandas as pd
import streamlit as st
import plotly.express as px
from st_click_detector import click_detector
from streamlit.components.v1 import components
from streamlit_autorefresh import st_autorefresh
from streamlit_extras.add_vertical_space import add_vertical_space
from streamlit_extras.dataframe_explorer import dataframe_explorer

from colour_utility import gradient
from pyodbc_connection import connect
from utility import flatten, get_windows_user


# version 202411041146


# print(f"RERUN for {st.session_state.get('session_user', 'NO NAME YET')} {datetime.datetime.now():%x %X}")

warnings.filterwarnings("ignore")

REQUIRES_PASSWORD = True
CIRCLES_NOT_SQUARES = True

BWS = 0
STG = 1

E_ASC_SORT = ":small_red_triangle:"
E_DESC_SORT = ":small_red_triangle_down:"
E_NO_SORT = ":black_medium_small_square:"
E_INFORMATION = ":information_source:"
E_WORKING = ":wrench:"
E_EXPAND = ":heavy_plus_sign:"
E_SHRINK = ":heavy_minus_sign:"
if CIRCLES_NOT_SQUARES:
    E_OP_COMPLETE = ":large_green_circle:"
    E_OP_STARTED = ":large_yellow_circle:"
    E_OP_NOT_STARTED = ":red_circle:"
else:
    E_OP_COMPLETE = ":large_green_square:"
    E_OP_STARTED = ":large_yellow_square:"
    E_OP_NOT_STARTED = ":large_red_square:"

cols_rename = {
    "NumOpenTransactions": E_WORKING,
    "Expand": E_INFORMATION,
    "JobDescription": "Desc",
    "Model No": "Model",
    "COMPANY NAME": "Company",
    "JobDeliveryDate": "Delivery Date",
    "ProgressOps": "OPs Prog.",
    "ProgressTotalBudget": "Bud. Prog."
}

cols_lookup = {k: v for k, v in cols_rename.items()}
cols_lookup.update({v: k for k, v in cols_rename.items()})

st.set_page_config(layout="wide")

default_session_state = {
    BWS: {},
    STG: {},
    "sort_col": cols_rename["ProgressOps"],
    "sort_style": E_DESC_SORT,
    "expanded_index": None,
    "expanded_index_reverse_lookup": None
}
for k, v in default_session_state.items():
    st.session_state.setdefault(k, v)


def click():
    print(f"CLICK")
    for i, row in df_production_data_by_op.iterrows():
        job = row["Job"]
        if job in SG_QUOTES_OF_INTEREST:
            # print(f"{df_production_data_by_op.iloc[i]=}")
            # df_production_data_by_op.iloc[i][cols_rename["ProgressOps"]] = df_production_data_by_op.iloc[i][cols_rename["ProgressOps"]] + 0.5

            if job not in st.session_state[COMP]:
                st.session_state[COMP][job] = {}

            print(f"WAS >> {job} {st.session_state[COMP][job]=}")

            if "ops_sum" not in st.session_state[COMP][job]:
                st.session_state[COMP][job] = {}
            val = st.session_state[COMP][job].setdefault("ops_sum", 0)
            st.session_state[COMP][job].update({"ops_sum": val + 0.5})

            print(f"NOW >> {job} {st.session_state[COMP][job]=}")

    # df = df_production_data_by_op.loc[df_production_data_by_op['Job'].isin(SG_QUOTES_OF_INTEREST), ["Job", "Progress"]]
    # print(f"NOW >>{df}")


SG_QUOTES_OF_INTEREST = ["10001546"]
# st.button(
#     label="Add",
#     on_click=click
# )


# time_cache_prod_data_by_op_stg = 60*60*1000  # 1 hour
time_cache_prod_data_by_op_stg = 3 * 60 * 1000  # 3 minutes
time_app_refresh = 45 * 1000  # every 45 seconds

CREDS_BWS = {
    "uid": "user5",
    "pwd": "M@gic456"
}
CREDS_STG = {
    "uid": "SGeu1",
    "pwd": "Pupplies-Hagard->Rio0"
}

# if "session_user" not in st.session_state:
#     st.session_state["session_user"] = get_windows_user()


@st.cache_data(show_spinner=True, ttl=time_cache_prod_data_by_op_stg)
def load_itr_customers_data() -> pd.DataFrame:
    sql = """
SELECT
	*
FROM
    [BWSdb].[dbo].[ITR Customers]
;
    """
    connection_data = {
        "sql": sql,
        "database": "bwsdb",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect(**connection_data)


@st.cache_data(show_spinner=True, ttl=time_cache_prod_data_by_op_stg)
def load_itstr_app_directory() -> pd.DataFrame:
    sql = """
SELECT
	*
FROM
    [BWSdb].[dbo].[ITSTR_AppDirectory]
;
    """
    connection_data = {
        "sql": sql,
        "database": "bwsdb",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect(**connection_data)


@st.cache_data(show_spinner=True, ttl=time_cache_prod_data_by_op_stg)
def load_itstr_user_directory() -> pd.DataFrame:
    sql = """
SELECT
	*
FROM
    [BWSdb].[dbo].[ITSTR_UserDirectory]
;
    """
    connection_data = {
        "sql": sql,
        "database": "bwsdb",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect(**connection_data)


@st.cache_data(show_spinner=True, ttl=time_cache_prod_data_by_op_stg)
def load_prod_data_status_codes_stg() -> pd.DataFrame:
    sql = """
SELECT
	0 AS [Code],
	'Not Started' AS [Desc]
UNION ALL
SELECT
	1 AS [Code],
	'In Progress' AS [Desc]
UNION ALL
SELECT
	2 AS [Code],
	'Complete' AS [Desc]
    """
    connection_data = {
        "sql": sql,
        "database": "SysproCompanyS",
        "uid": CREDS_STG["uid"],
        "pwd": CREDS_STG["pwd"]
    }
    return connect(**connection_data)


@st.cache_data(show_spinner=True, ttl=time_cache_prod_data_by_op_stg)
def load_prod_data_by_op_stg() -> pd.DataFrame:
    print(f"NEW STG PROD DATA BY OP")
    sql = """
-- ====================================
-- Operation Status values:
-- 0 - Not Started
-- 1 - In Progress ("CURRENT OPERATION" check mark legend from Vishal's "WORKFLOW STARGATE" spreadsheet)
-- 2 - Complete ("COMPLETED OPERATION" check mark legend from Vishal's "WORKFLOW STARGATE" spreadsheet)
-- ====================================


SELECT
	[Job]
    , [JobDescription]
    , [Model No]
    , [COMPANY NAME]
    , [JobDeliveryDate]
	, [Operation1Status]
	, [Operation2Status]
	, [Operation3Status]
	, [Operation4Status]
	, [Operation5Status]
	, [Operation6Status]
	, [Operation7Status]
	, [Operation8Status]
	, [Operation9Status]
	, [Operation10Status]
	, [Operation11Status]
	, [Operation12Status]
	, [Operation13Status]
	, [Operation14Status]
	, [Operation15Status]
	, [Operation16Status]
	, [Operation17Status]
	, [Operation18Status]
	, [Operation19Status]
	, SUM(
		(CASE WHEN ISNULL([Operation1Status], 0) = 2 THEN 1 WHEN [Operation1Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation2Status], 0) = 2 THEN 1 WHEN [Operation2Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation3Status], 0) = 2 THEN 1 WHEN [Operation3Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation4Status], 0) = 2 THEN 1 WHEN [Operation4Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation5Status], 0) = 2 THEN 1 WHEN [Operation5Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation6Status], 0) = 2 THEN 1 WHEN [Operation6Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation7Status], 0) = 2 THEN 1 WHEN [Operation7Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation8Status], 0) = 2 THEN 1 WHEN [Operation8Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation9Status], 0) = 2 THEN 1 WHEN [Operation9Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation10Status], 0) = 2 THEN 1 WHEN [Operation10Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation11Status], 0) = 2 THEN 1 WHEN [Operation11Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation12Status], 0) = 2 THEN 1 WHEN [Operation12Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation13Status], 0) = 2 THEN 1 WHEN [Operation13Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation14Status], 0) = 2 THEN 1 WHEN [Operation14Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation15Status], 0) = 2 THEN 1 WHEN [Operation15Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation16Status], 0) = 2 THEN 1 WHEN [Operation16Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation17Status], 0) = 2 THEN 1 WHEN [Operation17Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation18Status], 0) = 2 THEN 1 WHEN [Operation18Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation19Status], 0) = 2 THEN 1 WHEN [Operation19Status] = 1 THEN 0.5 ELSE 0 END)
	) AS [ProgressOps]
	, [NumOpenTransactions]
	, [TotalRunTimeAct]
	, [TotalRunTimeEst]
FROM (
	SELECT
		[Job]
		, [JobDescription]
		, [O2].[Model No]
		, [D2].[COMPANY NAME]
		, [JobDeliveryDate]
		, MAX(CASE WHEN [Operation] = 1 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 1 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 1 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation1Status]
		, MAX(CASE WHEN [Operation] = 2 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 2 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 2 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation2Status]
		, MAX(CASE WHEN [Operation] = 3 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 3 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 3 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation3Status]
		, MAX(CASE WHEN [Operation] = 4 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 4 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 4 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation4Status]
		, MAX(CASE WHEN [Operation] = 5 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 5 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 5 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation5Status]
		, MAX(CASE WHEN [Operation] = 6 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 6 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 6 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation6Status]
		, MAX(CASE WHEN [Operation] = 7 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 7 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 7 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation7Status]
		, MAX(CASE WHEN [Operation] = 8 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 8 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 8 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation8Status]
		, MAX(CASE WHEN [Operation] = 9 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 9 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 9 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation9Status]
		, MAX(CASE WHEN [Operation] = 10 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 10 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 10 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation10Status]
		, MAX(CASE WHEN [Operation] = 11 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 11 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 11 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation11Status]
		, MAX(CASE WHEN [Operation] = 12 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 12 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 12 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation12Status]
		, MAX(CASE WHEN [Operation] = 13 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 13 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 13 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation13Status]
		, MAX(CASE WHEN [Operation] = 14 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 14 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 14 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation14Status]
		, MAX(CASE WHEN [Operation] = 15 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 15 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 15 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation15Status]
		, MAX(CASE WHEN [Operation] = 16 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 16 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 16 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation16Status]
		, MAX(CASE WHEN [Operation] = 17 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 17 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 17 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation17Status]
		, MAX(CASE WHEN [Operation] = 18 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 18 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 18 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation18Status]
		, MAX(CASE WHEN [Operation] = 19 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 19 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 19 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation19Status]
		, SUM([NumOpenTransactions]) AS [NumOpenTransactions]
		, SUM([RunTimeIssued]) AS [TotalRunTimeAct]
		, SUM([IExpUnitRunTim]) AS [TotalRunTimeEst]
	FROM (
		SELECT
			[Master].[Job]
			, [Master].[JobDescription]
			, [Master].[JobDeliveryDate]
			, [Lab].[Operation]
			, [Lab].[RunTimeIssued]
			, [Lab].[IExpUnitRunTim]
			, [subClkTransactionCount].[numInProgressTransaction]
			, [Lab].[OperCompleted]
			, [subClkTransactionCount].[numCompleteTransaction]
			, ISNULL([subClkTransactionCount].[NumOpenTransactions], 0) AS [NumOpenTransactions]
		FROM
			[SysproCompanyS].[dbo].[WipJobAllLab] [Lab] WITH (NOLOCK)
		INNER JOIN
			[SysproCompanyS].[dbo].[WipMaster] [Master] WITH (NOLOCK)
		ON
			[Lab].[Job] = [Master].[Job]
		LEFT OUTER JOIN (
			SELECT 
				[C].[JobNumber]
				, [C].[Operation]
				, COUNT(CASE WHEN [C].[OperationComplete] = 0 THEN [C].[TransactionID] END) AS [numInProgressTransaction]
				, COUNT(CASE WHEN [C].[OperationComplete] = 1 THEN [C].[TransactionID] END) AS [numCompleteTransaction]
				, SUM((CASE WHEN [C].[LoggedOff] IS NULL THEN 1 ELSE 0 END)) AS [NumOpenTransactions]
			FROM
				[SysproCompanyS].[dbo].[ClkTransaction] [C] WITH (NOLOCK)
			WHERE
				[C].[JobNumber] <> ''
			GROUP BY
				[C].[JobNumber]
				, [C].[Operation]
		) AS [subClkTransactionCount]
		ON
			[Lab].[Job] = [subClkTransactionCount].[JobNumber]
			AND [Lab].[Operation] = [subClkTransactionCount].[Operation]
		WHERE
			[ActCompleteDate] IS NULL
	) AS [mainsub]
	INNER JOIN
		[BWSdb].[dbo].[OrdersV2] [O2] WITH (NOLOCK)
	ON
		[mainsub].[Job] = CAST([O2].[WO#] AS VARCHAR(20))
	INNER JOIN
		[BWSdb].[dbo].[DealersV2] [D2] WITH (NOLOCK)
	ON
		[O2].[DealerID] = [D2].[ID]
	GROUP BY
		[mainsub].[Job]
		, [mainsub].[JobDescription]
		, [O2].[Model No]
		, [D2].[COMPANY NAME]
		, [mainsub].[JobDeliveryDate]
) AS [Src]
GROUP BY
	[Job]
    , [JobDescription]
    , [Model No]
    , [COMPANY NAME]
    , [JobDeliveryDate]
	, [Operation1Status]
	, [Operation2Status]
	, [Operation3Status]
	, [Operation4Status]
	, [Operation5Status]
	, [Operation6Status]
	, [Operation7Status]
	, [Operation8Status]
	, [Operation9Status]
	, [Operation10Status]
	, [Operation11Status]
	, [Operation12Status]
	, [Operation13Status]
	, [Operation14Status]
	, [Operation15Status]
	, [Operation16Status]
	, [Operation17Status]
	, [Operation18Status]
	, [Operation19Status]
	, [NumOpenTransactions]
	, [TotalRunTimeAct]
	, [TotalRunTimeEst]
ORDER BY
	[Job]
;
    """
    connection_data = {
        "sql": sql,
        "database": "SysproCompanyS",
        "uid": CREDS_STG["uid"],
        "pwd": CREDS_STG["pwd"]
    }

    result = connect(**connection_data)

    # # TODO TESTING HERE
    # result.loc[result["Job"].isin(SG_QUOTES_OF_INTEREST), "NumOpenTransactions"] = 1
    # print(f"{result.loc[result['Job'].isin(SG_QUOTES_OF_INTEREST)]=}")

    return result


@st.cache_data(show_spinner=True, ttl=time_cache_prod_data_by_op_stg)
def load_prod_data_by_op_bws() -> pd.DataFrame:
    print(f"NEW BWS PROD DATA BY OP")
    sql = """
-- ====================================
-- Operation Status values:
-- 0 - Not Started
-- 1 - In Progress ("CURRENT OPERATION" check mark legend from Vishal's "WORKFLOW STARGATE" spreadsheet)
-- 2 - Complete ("COMPLETED OPERATION" check mark legend from Vishal's "WORKFLOW STARGATE" spreadsheet)
-- ====================================


SELECT
	[Job]
    , [JobDescription]
    , [Model No]
    , [COMPANY NAME]
    , [JobDeliveryDate]
	, [Operation1Status]
	, [Operation2Status]
	, [Operation3Status]
	, [Operation4Status]
	, [Operation5Status]
	, [Operation6Status]
	, [Operation7Status]
	, [Operation8Status]
	, [Operation9Status]
	, [Operation10Status]
	, [Operation11Status]
	, [Operation12Status]
	, [Operation13Status]
	, [Operation14Status]
	, [Operation15Status]
	, [Operation16Status]
	, [Operation17Status]
	, [Operation18Status]
	, [Operation19Status]
	, SUM(
		(CASE WHEN ISNULL([Operation1Status], 0) = 2 THEN 1 WHEN [Operation1Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation2Status], 0) = 2 THEN 1 WHEN [Operation2Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation3Status], 0) = 2 THEN 1 WHEN [Operation3Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation4Status], 0) = 2 THEN 1 WHEN [Operation4Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation5Status], 0) = 2 THEN 1 WHEN [Operation5Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation6Status], 0) = 2 THEN 1 WHEN [Operation6Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation7Status], 0) = 2 THEN 1 WHEN [Operation7Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation8Status], 0) = 2 THEN 1 WHEN [Operation8Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation9Status], 0) = 2 THEN 1 WHEN [Operation9Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation10Status], 0) = 2 THEN 1 WHEN [Operation10Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation11Status], 0) = 2 THEN 1 WHEN [Operation11Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation12Status], 0) = 2 THEN 1 WHEN [Operation12Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation13Status], 0) = 2 THEN 1 WHEN [Operation13Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation14Status], 0) = 2 THEN 1 WHEN [Operation14Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation15Status], 0) = 2 THEN 1 WHEN [Operation15Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation16Status], 0) = 2 THEN 1 WHEN [Operation16Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation17Status], 0) = 2 THEN 1 WHEN [Operation17Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation18Status], 0) = 2 THEN 1 WHEN [Operation18Status] = 1 THEN 0.5 ELSE 0 END)
		+ (CASE WHEN ISNULL([Operation19Status], 0) = 2 THEN 1 WHEN [Operation19Status] = 1 THEN 0.5 ELSE 0 END)
	) AS [ProgressOps]
	, [NumOpenTransactions]
	, [TotalRunTimeAct]
	, [TotalRunTimeEst]
FROM (
	SELECT
		[Job]
		, [JobDescription]
		, [O].[Model No]
		, [D].[COMPANY NAME]
		, [JobDeliveryDate]
		, MAX(CASE WHEN [Operation] = 1 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 1 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 1 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation1Status]
		, MAX(CASE WHEN [Operation] = 2 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 2 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 2 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation2Status]
		, MAX(CASE WHEN [Operation] = 3 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 3 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 3 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation3Status]
		, MAX(CASE WHEN [Operation] = 4 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 4 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 4 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation4Status]
		, MAX(CASE WHEN [Operation] = 5 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 5 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 5 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation5Status]
		, MAX(CASE WHEN [Operation] = 6 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 6 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 6 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation6Status]
		, MAX(CASE WHEN [Operation] = 7 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 7 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 7 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation7Status]
		, MAX(CASE WHEN [Operation] = 8 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 8 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 8 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation8Status]
		, MAX(CASE WHEN [Operation] = 9 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 9 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 9 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation9Status]
		, MAX(CASE WHEN [Operation] = 10 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 10 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 10 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation10Status]
		, MAX(CASE WHEN [Operation] = 11 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 11 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 11 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation11Status]
		, MAX(CASE WHEN [Operation] = 12 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 12 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 12 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation12Status]
		, MAX(CASE WHEN [Operation] = 13 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 13 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 13 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation13Status]
		, MAX(CASE WHEN [Operation] = 14 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 14 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 14 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation14Status]
		, MAX(CASE WHEN [Operation] = 15 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 15 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 15 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation15Status]
		, MAX(CASE WHEN [Operation] = 16 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 16 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 16 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation16Status]
		, MAX(CASE WHEN [Operation] = 17 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 17 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 17 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation17Status]
		, MAX(CASE WHEN [Operation] = 18 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 18 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 18 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation18Status]
		, MAX(CASE WHEN [Operation] = 19 AND ([OperCompleted] = 'Y' OR [numCompleteTransaction] > 0) THEN 2
					WHEN [Operation] = 19 AND ([RunTimeIssued] > 0 OR [numInProgressTransaction] > 0) THEN 1
					WHEN [Operation] = 19 AND ([RunTimeIssued] = 0 AND [numInProgressTransaction] = 0) THEN 0
					ELSE 0
					END) AS [Operation19Status]
		, SUM([NumOpenTransactions]) AS [NumOpenTransactions]
		, SUM([RunTimeIssued]) AS [TotalRunTimeAct]
		, SUM([IExpUnitRunTim]) AS [TotalRunTimeEst]
	FROM (
		SELECT
			[Master].[Job]
			, [Master].[JobDescription]
			, [Master].[JobDeliveryDate]
			, [Lab].[Operation]
			, [Lab].[RunTimeIssued]
			, [Lab].[IExpUnitRunTim]
			, [subClkTransactionCount].[numInProgressTransaction]
			, [Lab].[OperCompleted]
			, [subClkTransactionCount].[numCompleteTransaction]
			, ISNULL([subClkTransactionCount].[NumOpenTransactions], 0) AS [NumOpenTransactions]
		FROM
			[SysproCompanyA].[dbo].[WipJobAllLab] [Lab] WITH (NOLOCK)
		INNER JOIN
			[SysproCompanyA].[dbo].[WipMaster] [Master] WITH (NOLOCK)
		ON
			[Lab].[Job] = [Master].[Job]
		LEFT OUTER JOIN (
			SELECT 
				[C].[JobNumber]
				, [C].[Operation]
				, COUNT(CASE WHEN [C].[OperationComplete] = 0 THEN [C].[TransactionID] END) AS [numInProgressTransaction]
				, COUNT(CASE WHEN [C].[OperationComplete] = 1 THEN [C].[TransactionID] END) AS [numCompleteTransaction]
				, SUM((CASE WHEN [C].[LoggedOff] IS NULL THEN 1 ELSE 0 END)) AS [NumOpenTransactions]
			FROM
				[SysproCompanyA].[dbo].[ClkTransaction] [C] WITH (NOLOCK)
			WHERE
				[C].[JobNumber] <> ''
			GROUP BY
				[C].[JobNumber]
				, [C].[Operation]
		) AS [subClkTransactionCount]
		ON
			[Lab].[Job] = [subClkTransactionCount].[JobNumber]
			AND [Lab].[Operation] = [subClkTransactionCount].[Operation]
		WHERE
			[ActCompleteDate] IS NULL
	) AS [mainsub]
	INNER JOIN
		[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
	ON
		[mainsub].[Job] = CAST([O].[WO#] AS VARCHAR(20))
	INNER JOIN
		[BWSdb].[dbo].[Dealers] [D] WITH (NOLOCK)
	ON
		[O].[DealerID] = [D].[ID]
	GROUP BY
		[mainsub].[Job]
		, [mainsub].[JobDescription]
		, [O].[Model No]
		, [D].[COMPANY NAME]
		, [mainsub].[JobDeliveryDate]
) AS [Src]
GROUP BY
	[Job]
    , [JobDescription]
    , [Model No]
    , [COMPANY NAME]
    , [JobDeliveryDate]
	, [Operation1Status]
	, [Operation2Status]
	, [Operation3Status]
	, [Operation4Status]
	, [Operation5Status]
	, [Operation6Status]
	, [Operation7Status]
	, [Operation8Status]
	, [Operation9Status]
	, [Operation10Status]
	, [Operation11Status]
	, [Operation12Status]
	, [Operation13Status]
	, [Operation14Status]
	, [Operation15Status]
	, [Operation16Status]
	, [Operation17Status]
	, [Operation18Status]
	, [Operation19Status]
	, [NumOpenTransactions]
	, [TotalRunTimeAct]
	, [TotalRunTimeEst]
ORDER BY
	[Job]
;
    """
    connection_data = {
        "sql": sql,
        "database": "SysproCompanyA",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect(**connection_data)


@st.cache_data(show_spinner=True, ttl=time_cache_prod_data_by_op_stg)
def load_bws_prod_ops():
#     print(f"NEW BWS PROD OPS")
#     sql = """
# SELECT * FROM [SysproCompanyA].[dbo].[v_ProdOperationNames] ORDER BY [Operation];
#     """
#     connection_data = {
#         "sql": sql,
#         "database": "SysproCompanyA",
#         "uid": CREDS_BWS["uid"],
#         "pwd": CREDS_BWS["pwd"]
#     }
#     return connect(**connection_data)
    print(f"NEW BWS PROD OPS")
    sql = """
SELECT 
	*
FROM
	[BWSdb].[dbo].[ProductionOperations] 
WHERE
	([CompanyID] = 0)
	AND ([Active] = 1) 
ORDER BY
	(CASE WHEN [OperationNum] = 0 THEN 1 ELSE 0 END),
	[OperationNum]
;
            """
    connection_data = {
        "sql": sql,
        "database": "BWSdb",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect(**connection_data)


@st.cache_data(show_spinner=True, ttl=time_cache_prod_data_by_op_stg)
def load_stg_prod_ops():
    print(f"NEW STG PROD OPS")
    sql = """
SELECT * FROM [SysproCompanyS].[dbo].[v_ProdOperationNames] ORDER BY [Operation];
    """
    connection_data = {
        "sql": sql,
        "database": "SysproCompanyS",
        "uid": CREDS_STG["uid"],
        "pwd": CREDS_STG["pwd"]
    }
    return connect(**connection_data)
    # print(f"NEW BWS PROD OPS")
    # sql = """
    #     SELECT
    #         *
    #     FROM
    #         [BWSdb].[dbo].[ProductionOperations]
    #     WHERE
    #         ([CompanyID] = 1)
    #         AND ([Active] = 1)
    #     ORDER BY
    #         (CASE WHEN [OperationNum] = 0 THEN 1 ELSE 0 END),
    #         [OperationNum]
    #     ;
    #                 """
    # connection_data = {
    #     "sql": sql,
    #     "database": "BWSdb",
    #     "uid": CREDS_BWS["uid"],
    #     "pwd": CREDS_BWS["pwd"]
    # }
    # return connect(**connection_data)


@st.cache_data(show_spinner=True, ttl=time_cache_prod_data_by_op_stg)
def load_order_options_bws():
    print(f"NEW BWS ORDER OPTIONS")
    sql = """
SELECT * FROM [BWSdb].[dbo].[Order Options];
    """
    connection_data = {
        "sql": sql,
        "database": "BWSdb",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect(**connection_data)


@st.cache_data(show_spinner=True, ttl=time_cache_prod_data_by_op_stg)
def load_order_options_stg():
    print(f"NEW STG ORDER OPTIONS")
    sql = """
SELECT * FROM [BWSdb].[dbo].[Order OptionsV2];
    """
    connection_data = {
        "sql": sql,
        "database": "BWSdb",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect(**connection_data)


@st.cache_data(show_spinner=True, ttl=time_cache_prod_data_by_op_stg)
def load_custom_work_bws():
    print(f"NEW BWS Custom Work")
    sql = """
SELECT * FROM [BWSdb].[dbo].[Custom Work];
    """
    connection_data = {
        "sql": sql,
        "database": "BWSdb",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect(**connection_data)


@st.cache_data(show_spinner=True, ttl=time_cache_prod_data_by_op_stg)
def load_custom_work_stg():
    print(f"NEW STG Custom Work")
    sql = """
SELECT * FROM [BWSdb].[dbo].[Custom WorkV2];
    """
    connection_data = {
        "sql": sql,
        "database": "BWSdb",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect(**connection_data)


@st.cache_data(show_spinner=True, ttl=time_cache_prod_data_by_op_stg)
def load_WipJobAllMat_data(job) -> pd.DataFrame:
    db_name = f"SysproCompany{COMP_LETTER}"
    sql = f"""
    SELECT
        *
    FROM
        [{db_name}].[dbo].[WipJobAllMat]
    WHERE
        [Job] = '{job}'
    ;
        """
    connection_data = {
        "sql": sql,
        "database": db_name,
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    if COMP == STG:
        connection_data.update({
            "uid": CREDS_STG["uid"],
            "pwd": CREDS_STG["pwd"]
        })
    return connect(**connection_data)


@st.cache_data(show_spinner=True, ttl=time_cache_prod_data_by_op_stg)
def load_WipJobAllLab_data(job) -> pd.DataFrame:
    db_name = f"SysproCompany{COMP_LETTER}"
    sql = f"""
    SELECT
        *
    FROM
        [{db_name}].[dbo].[WipJobAllLab]
    WHERE
        [Job] = '{job}'
    ;
        """
    connection_data = {
        "sql": sql,
        "database": db_name,
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    if COMP == STG:
        connection_data.update({
            "uid": CREDS_STG["uid"],
            "pwd": CREDS_STG["pwd"]
        })
    return connect(**connection_data)


@st.cache_data(show_spinner=True, ttl=time_cache_prod_data_by_op_stg)
def load_ClkTransaction_data(job) -> pd.DataFrame:
    db_name = f"SysproCompany{COMP_LETTER}"
    sql = f"""
SELECT
    *
FROM
    [{db_name}].[dbo].[ClkTransaction]
WHERE
    [JobNumber] = '{job}'
;
    """
    connection_data = {
        "sql": sql,
        "database": db_name,
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    if COMP == STG:
        connection_data.update({
            "uid": CREDS_STG["uid"],
            "pwd": CREDS_STG["pwd"]
        })
    return connect(**connection_data)


@st.cache_data(show_spinner=True, ttl=time_cache_prod_data_by_op_stg)
def load_material_bws():
    sql = """
SELECT
	[Src].[ValueRequired] - [Src].[ValueIssued] AS [ValueLeftToIssue]
	,([Src].[ValueRequired] - [Src].[ValueIssued]) / (CASE WHEN [QtyLeftToIssue] = 0 THEN 1 ELSE [QtyLeftToIssue] END) AS [ValueLeftToIssuePerPart]
	,[Src].*
FROM (
	SELECT
		([Mat].[UnitCost] * [Mat].[UnitQtyReqd]) AS [ValueRequired]
		,([Mat].[UnitQtyReqd] - [Mat].[QtyIssued]) AS [QtyLeftToIssue]
		,*
	FROM
		[SysproCompanyA].[dbo].[WipJobAllMat] [Mat] WITH (NOLOCK)
	WHERE
		LEFT([Job], 1) = '1'
		AND (LEN([Job]) = 8)
		AND (([Mat].[Warehouse] = '01')
		OR ([Mat].[Warehouse] = '02'))
) AS [Src]
"""
    connection_data = {
        "sql": sql,
        "database": "BWSdb",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect(**connection_data)


@st.cache_data(show_spinner=True, ttl=time_cache_prod_data_by_op_stg)
def load_material_stg():
    sql = """
SELECT
	[Src].[ValueRequired] - [Src].[ValueIssued] AS [ValueLeftToIssue]
	,([Src].[ValueRequired] - [Src].[ValueIssued]) / (CASE WHEN [QtyLeftToIssue] = 0 THEN 1 ELSE [QtyLeftToIssue] END) AS [ValueLeftToIssuePerPart]
	,[Src].*
FROM (
	SELECT
		([Mat].[UnitCost] * [Mat].[UnitQtyReqd]) AS [ValueRequired]
		,([Mat].[UnitQtyReqd] - [Mat].[QtyIssued]) AS [QtyLeftToIssue]
		,*
	FROM
		[SysproCompanyS].[dbo].[WipJobAllMat] [Mat] WITH (NOLOCK)
	WHERE
		LEFT([Job], 1) = '1'
		AND (LEN([Job]) = 8)
		AND (([Mat].[Warehouse] = '01')
		OR ([Mat].[Warehouse] = '02'))
) AS [Src]
"""
    connection_data = {
        "sql": sql,
        "database": "BWSdb",
        "uid": CREDS_STG["uid"],
        "pwd": CREDS_STG["pwd"]
    }
    return connect(**connection_data)


def click_column_header(j, col):
    print(f"click_column_header {j=}, {col=}")
    prev_sc = st.session_state.get("sort_col")
    prev_ss = st.session_state.get("sort_style")
    m = ""
    if col == prev_sc:
        m += "A"
        if prev_ss == E_NO_SORT:
            m += "B"
            ss = E_DESC_SORT
        elif prev_ss == E_DESC_SORT:
            m += "C"
            ss = E_ASC_SORT
        else:
            m += "D"
            ss = E_NO_SORT
            col = None
    else:
        m += "E"
        ss = E_DESC_SORT

    print(f"{m=}")

    old_expanded_idx = st.session_state.get("expanded_index")
    if old_expanded_idx is not None:
        df_job = df_production_data_by_op.iloc[old_expanded_idx]
        job = df_job["Job"]
        st.session_state.update({"expanded_index_reverse_lookup": job})

    st.session_state.update({
        "sort_col": col,
        "sort_style": ss
    })

    # print(f"\n")
    # for k, v in st.session_state.items():
    #     print(f"{k=}, {v=}")
    # print(f"\n")


def click_expand_order(i, j):
    print(f"click_expand_order {i=}, {j=}")
    prev_exp = st.session_state.get("expanded_index")
    df_data = df_production_data_by_op.iloc[i]
    if i != prev_exp:
        print(f"NEW")
        st.session_state["expanded_index"] = i
    else:
        # shrink:
        st.session_state["expanded_index"] = None

# slow
df_itstr_app_directory = load_itstr_app_directory()
df_itstr_user_directory = load_itstr_user_directory()
df_itr_customers = load_itr_customers_data()
df_operation_names_bws = load_bws_prod_ops()
df_operation_names_stg = load_stg_prod_ops()
df_order_options_bws = load_order_options_bws()
df_order_options_stg = load_order_options_bws()
df_npos_bws = load_custom_work_bws()
df_npos_stg = load_custom_work_stg()
df_material_bws = load_material_bws()
df_material_stg = load_material_stg()

if REQUIRES_PASSWORD:
    pass

# st.markdown("""
#     <style>
#     .selected-job {
#         background-color: #FF0000;
#     }
#     </style>
# """,
#             unsafe_allow_html=True
# )


options_radio_company_choice = [
    ":red[BWS]",
    ":blue[STARGATE]"
]
title_cols = st.columns([1, 0.15])
with title_cols[0]:
    radio_company_choice = st.radio(
        "Company:",
        options_radio_company_choice,
        key="radio_company_choice",
        horizontal=True
    )

COMP = BWS if radio_company_choice == options_radio_company_choice[0] else STG
COLOUR_OPERATIONS: list = list()

if COMP == BWS:
    # BWS

    N_OPERATIONS = 19
    COLOUR_OPERATIONS = ["#650808", "#086508"]
    df_production_data_status_codes = load_prod_data_status_codes_stg()
    df_production_data_by_op = load_prod_data_by_op_bws()
    df_material = df_material_bws
else:
    # STG

    N_OPERATIONS = 19
    COLOUR_OPERATIONS = ["#650808", "#086508"]
    # df_production_data_status_codes = st.session_state.setdefault("df_production_data_status_codes", load_prod_data_status_codes_stg())
    # df_production_data_by_op = st.session_state.setdefault("df_production_data_by_op", load_prod_data_by_op_stg())
    df_production_data_status_codes = load_prod_data_status_codes_stg()
    df_production_data_by_op = load_prod_data_by_op_stg()
    df_material = df_material_stg

df_production_data_by_op["ProgressTotalBudget"] = df_production_data_by_op["TotalRunTimeAct"] / \
                                                  df_production_data_by_op["TotalRunTimeEst"]
df_production_data_by_op["Expand"] = 1
og_columns = list(df_production_data_by_op.columns)

for new_pos, col_name in [
    (0, "NumOpenTransactions"),
    (1, "Expand"),
    (6, "ProgressOps"),
    (6, "ProgressTotalBudget")
]:
    og_columns.remove(col_name)
    og_columns.insert(new_pos, col_name)

cols_production_og_translator = {col: f"F_{col}" for col in list(df_production_data_by_op.columns) if
                                 all(["operation" in col.lower(), "status" in col.lower()])}
cols_production = list(cols_production_og_translator.keys())
cols_production = {int(col.lower().removeprefix("operation").removesuffix("status")): col for col in cols_production}
cols_lookup.update({k: v for k, v in cols_production_og_translator.items()})
cols_lookup.update({v: k for k, v in cols_production_og_translator.items()})
cols_lookup.update({str(k): v for k, v in cols_production.items()})
cols_lookup.update({k: v for k, v in cols_production.items()})

# cell_formatter = lambda status_val: f":heavy_check_mark:" if status_val == 2 else (f":wrench:" if status_val == 1 else f":red_circle:")
cell_formatter = lambda status_val: E_OP_COMPLETE if status_val == 2 else (
    E_OP_STARTED if status_val == 1 else E_OP_NOT_STARTED)
for i, col in cols_production.items():
    df_production_data_by_op[f"F_{col}"] = df_production_data_by_op[col].apply(lambda val: cell_formatter(val))

df_production_data_by_op["JobDeliveryDate"] = df_production_data_by_op["JobDeliveryDate"].apply(
    lambda val: f"{val:%Y-%m-%d}" if not pd.isna(val) else "-")
df_production_data_by_op["NumOpenTransactions"] = df_production_data_by_op["NumOpenTransactions"].apply(
    lambda val: ":wrench:" if val >= 1 else "")
del df_production_data_by_op["TotalRunTimeAct"]
del df_production_data_by_op["TotalRunTimeEst"]
og_columns.remove("TotalRunTimeAct")
og_columns.remove("TotalRunTimeEst")

# Sort the main plotting data
if st.session_state.get("sort_col") is None:
    sort_by = cols_lookup[default_session_state["sort_col"]]
    sort_style = default_session_state["sort_style"]
else:
    # print(f"{cols_lookup=}")
    # print(f"{st.session_state.get('sort_col')=}, {type(st.session_state.get('sort_col'))=}")
    sort_by = cols_lookup[st.session_state.get("sort_col")]
df_production_data_by_op.sort_values(
    by=sort_by,
    ascending=st.session_state.get("sort_style") != E_DESC_SORT,
    inplace=True,
    ignore_index=True
)

# If sorting would change the expanded index, update it by reverse-looking-up the index by job.
if (old_expanded_job := st.session_state.get("expanded_index_reverse_lookup")) is not None:
    print(f"{old_expanded_job=}")
    new_expanded_index = df_production_data_by_op.loc[df_production_data_by_op["Job"] == old_expanded_job].index
    st.session_state.update({
        "expanded_index_reverse_lookup": None,
        "expanded_index": new_expanded_index
    })

table_styles = [
    {
        "fg": "#CECEFF"
    },
    {
        "fg": "#FFFFFF"
    }
]

add_vertical_space(3)
width_cols_production = [0.22 for _ in cols_production]
col_order = {
    "NumOpenTransactions": 0.15,
    "Expand": 0.16,
    "Job": 0.4,
    "JobDescription": 0.5,
    "Model No": 0.95,
    "COMPANY NAME": 0.95,
    "JobDeliveryDate": 0.48,
    "ProgressTotalBudget": 0.5,
    "ProgressOps": 0.5
}
col_order.update({
    c: w for c, w in zip(cols_production, width_cols_production)
})

if COMP == STG:
    COMP_NAME = "Stargate"
    COMP_LETTER = "S"
else:
    COMP_NAME = "BWS"
    COMP_LETTER = "A"
    col_order["JobDescription"] = 0.6
    col_order["Model No"] = 0.6

with title_cols[0]:
    st.write(f"### {COMP_NAME} Production Data")
    st.markdown(f"###### as of: :red[{datetime.datetime.now():%x %X}]")

with title_cols[1]:
    with st.container():
        st.write(f"Operation Status Legend")
        st.write(f"{E_OP_NOT_STARTED} -- Not Started")
        st.write(f"{E_OP_STARTED} -- In Progress")
        st.write(f"{E_OP_COMPLETE} -- Complete")

col_widths = [val for col, val in col_order.items()]
header_col_widths = flatten([[0.55 * cw, 0.45 * cw] for cw in col_widths])

rows_per_expansion = 3
header_grid = [st.columns(col_widths, vertical_alignment="bottom")]
grid = []
# grid.append(st.divider())
for i in range(df_production_data_by_op.shape[0]):
    grid.append(st.columns(col_widths))
    if st.session_state.get("expanded_index") == i:
        grid.append(st.divider())
        grid.append(st.columns(1))
        grid.append(st.divider())

df_production_data_by_op.rename(
    columns=cols_rename,
    inplace=True
)
cols_description = [col for col in og_columns if col not in cols_production_og_translator]

# print(f"{cols_rename=}")
# Header row
clicked_col_content = {}
# for j, col in enumerate(header_columns):
for j, col in enumerate(col_order):
    # print(f"{j=}, {col=}")

    ss = ""
    m = ""

    co = col
    col = f"{j - len(cols_description) + 1}" if (col in cols_production_og_translator) else col
    col = cols_rename.get(col, col)
    ss = E_NO_SORT
    if col == st.session_state.get("sort_col"):
        m += "B"
        ss = f" {st.session_state.get('sort_style')}"

    if col == E_INFORMATION:
        ss = ""

    if COMP == BWS:
        df_col = df_operation_names_bws.loc[df_operation_names_bws["OperationNum"] == col]
    else:
        df_col = df_operation_names_stg.loc[df_operation_names_stg["Operation"] == col]
    col_n = col
    if not df_col.empty:
        # col = f"{col_n} :heavy_minus_sign: {df_col.iloc[0]['OperationDescription']}"
        if COMP == STG:
            col = f"{df_col.iloc[0]['OperationDescription']}"
        else:
            col = df_col.iloc[0]["MachineCodeDescription"]
        if pd.isna(col) and (df_col.shape[0] > 1):
            col = df_col.iloc[1]["MachineCodeDescription"]
    lbl = f"{col}{ss}"
    # print(f"HEAD {j=}, {col=}, {ss=}, {lbl=}, {m=}")
    with header_grid[0][j]:
        # if j % 2 == 0:
        #     # text
        #     st.write(col)
        # else:
        st.button(
            label=str(col_n),
            on_click=lambda j_=j, col_=col_n: click_column_header(j_, col_),
            key=f"CD_{COMP}_{j}_{col}",
            use_container_width=True,
            help=lbl
        )

exp_count = 0
# operation_colour_map = {
#     i: gradient(i, N_OPERATIONS, COLOUR_OPERATIONS[0], COLOUR_OPERATIONS[-1], rgb=False)
#     for i in range(1, N_OPERATIONS + 1)
# }
# operation_colour_map.update({
#     str(k): v for k, v in operation_colour_map.items()
# })
# print(f"{operation_colour_map=}")

# for i_row in df_production_data_by_op.itertuples():
for i, row in df_production_data_by_op.iterrows():
    # print(f"{i_row=}")
    job = row["Job"]
    df_job_material = df_material.loc[df_material["Job"] == job]
    df_job_material.sort_values(
        by="ValueLeftToIssue",
        ascending=False,
        inplace=True
    )
    # st.write("df_job_material")
    # st.dataframe(df_job_material)
    # print(f"{i=}, {job=}")
    new = row[cols_rename["ProgressOps"]]
    old = st.session_state.setdefault(COMP, {}).setdefault(job, {}).setdefault(cols_rename["ProgressOps"], None)

    key_done_showing = f"DS_{COMP}_{i}"
    show_count = st.session_state.setdefault(key_done_showing, 0)
    rsv_show_count = 6
    done_showing = show_count <= -1

    msg = ""

    if old is None:
        # was not previously known
        msg += "A"
        changed = False
        done_showing = True
        st.session_state[COMP][job][cols_rename["ProgressOps"]] = new
        new = old
    else:
        msg += "B"
        changed = new != old

        if show_count <= -1:
            msg += "C"
            # if changed:
            #     msg += "D"
            #     show_count = rsv_show_count
            #     done_showing = False
            done_showing = True
        else:
            msg += "E"
            st.session_state.update({key_done_showing: show_count - 1})
            done_showing = False

    # print(f"{new=}, {old=}, {done_showing=}, {show_count=}, {changed=}, {key_done_showing=}")
    if changed:
        print(f"\t\tCHANGED {datetime.datetime.now():%Y-%m-%d %X}")
        print(f"{msg=}")
        print(f"{i=}, {job=}")
        print(f"{new=}, {old=}")
        print(f"DS={done_showing}, SC={show_count}, CNGD={changed}, K_DS={key_done_showing}")
        st.session_state[COMP][job][cols_rename["ProgressOps"]] = new

    row_is_expanded = st.session_state.get("expanded_index") == i
    if row_is_expanded:
        df_ClkTransaction_job_data = load_ClkTransaction_data(job)
        df_WipJobAllMat_job_data = load_WipJobAllMat_data(job)
        df_WipJobAllLab_job_data = load_WipJobAllLab_data(job)

    # print(f"\nBEGIN ROW POP {i=}, EC={exp_count}, RIP={row_is_expanded}")

    for j, col in enumerate(col_order):
        og_col = str(col)
        # if i == 10:
        #     print(f"{i=}, {j=}, {og_col=}, {col=} ", end="")
        col = cols_rename.get(str(col), str(col))
        # if i == 10:
        #     print(f"{col=} ", end="")
        if col == og_col:
            col = cols_lookup.get(col, col)
        # if i == 10:
        #     print(f"{col=} ", end="")
        # print(f"-> {col}")
        val = df_production_data_by_op.iloc[i][col]
        df_job_material_op = df_job_material.loc[
            df_job_material["OperationOffset"] == j
        ]
        df_job_material_op = df_job_material_op.loc[df_job_material_op["ValueLeftToIssue"] > 0]
        top_un_iss_parts = ""
        for k, row_j_o in df_job_material_op.iterrows():
            top_un_iss_parts += f"{row_j_o['StockCode']}, "
        top_un_iss_parts = top_un_iss_parts.removesuffix(", ")
        if not top_un_iss_parts:
            top_un_iss_parts = "All parts issued"
        # st.write("df_job_material_op")
        # st.dataframe(df_job_material_op)
        # # if i == 10:
        # #     print(f"{val=}")
        # print(f"{i=}, {j=}, EC={exp_count}, {col=}, {val=}")
        if col in cols_production_og_translator:
            # draw circles
            new_key = cols_production_og_translator[col]
            val = df_production_data_by_op.iloc[i][new_key]
            with grid[i + exp_count][j]:
                # st.write(val)
                st.button(
                    label=val,
                    key=f"btn_{job}_op_{j}",
                    use_container_width=False,
                    help=top_un_iss_parts
                )
                # st.markdown(f'<div class="selected-job">{val}</div>', unsafe_allow_html=True)
        else:
            # other labels and progress bars
            with grid[i + exp_count][j]:
                if col == cols_rename["ProgressOps"]:
                    val /= N_OPERATIONS
                    # print(f"=> {val=}, {type(val)=}")
                    st.progress(val, text=f"{val * 100:.2f}%")
                elif col == cols_rename["ProgressTotalBudget"]:
                    # print(f"{col=}, {val=}, {j=}")
                    val = 0 if pd.isna(val) else val
                    if val > 1:
                        st.write(":red[OVER BUDGET!]")
                    else:
                        st.progress(val, text=f"{val * 100:.2f}%")
                elif col == E_INFORMATION:
                    st.button(
                        label=E_SHRINK if st.session_state.get("expanded_index") == i else E_EXPAND,
                        on_click=lambda i_=i, j_=j: click_expand_order(i_, j_),
                        key=f"BTN_EXP_{COMP}_{i}_{j}",
                        use_container_width=True
                    )
                else:
                    if (new == old) and done_showing:
                        st.write(val)
                    else:
                        st.markdown(f'<div class="selected-job">{val}</div>', unsafe_allow_html=True)
                    # st.write(row[j])
    if row_is_expanded:
        # for k in range(1, row_is_expanded + 1):
        with grid[i + exp_count + 2][0]:  #(rows_per_expansion - 1)]:
            # st.write(f"EXPANDED")

            # Production Movements
            options = ["ShopClk Data", "Syspro Labour", "Syspro Material"]
            cols_timeline_clk = ["JobNumber", "LoggedOn", "LoggedOff", "EmployeeNumber", "EmployeeName", "Operation"]

            df_timeline_clk = df_ClkTransaction_job_data[cols_timeline_clk]
            df_timeline_clk = df_timeline_clk.loc[df_timeline_clk["JobNumber"] == job]
            df_timeline_clk["Operation"] = df_timeline_clk["Operation"].astype(int)

            df_timeline_clk["Category"] = df_timeline_clk.apply(
                lambda row:
                row["Operation"]
                , axis=1
            )

            del df_timeline_clk["Operation"]
            df_timeline_clk = df_timeline_clk.rename(columns={
                "LoggedOn": "Start Date",
                "LoggedOff": "End Date",
                "Category": "Operation"
            })
            df_timeline_clk["End Date"] = df_timeline_clk["End Date"].fillna(datetime.datetime.now())
            df_timeline_clk['Start Date'] = pd.to_datetime(df_timeline_clk['Start Date'])
            df_timeline_clk['End Date'] = pd.to_datetime(df_timeline_clk['End Date'])
            df_timeline_clk["Event"] = df_timeline_clk.apply(
                lambda row:
                # f"OP{row['Operation']} - {row['EmployeeNumber']}"
                # f"{row['EmployeeNumber']}"
                f"{row['EmployeeName']} {((row['End Date'] - row['Start Date']).total_seconds() / 3600):.3f} Hrs"
                , axis=1
            )
            df_timeline_clk.sort_values(
                by=["Operation", "Start Date"],
                inplace=True
            )
            # st.dataframe(df_timeline_clk)

            # Create a Gantt-like timeline using Plotly
            print(f"{df_timeline_clk['Operation']=}")
            height_timeline_clk = max(500, 12 * df_timeline_clk.shape[0])
            print(f"{height_timeline_clk=}")
            fig_timeline_clk = px.timeline(
                df_timeline_clk,
                x_start='Start Date',
                x_end='End Date',
                y='Event',
                title='Operation Transactions by Employee',
                color='Operation'
                # ,
                # color_discrete_map=operation_colour_map
            )

            # Update layout to make it more readable
            fig_timeline_clk.update_layout(
                xaxis_title="Date",
                yaxis_title="Employee Hrs By OP",
                height=height_timeline_clk
            )

            # Display in Streamlit
            st.plotly_chart(fig_timeline_clk)

            # Radios and Expanders
            df_explorer_radio = st.radio(
                label="Select some data to investigate:",
                options=options,
                horizontal=True
            )
            if df_explorer_radio == options[0]:
                with st.expander("ClkTransaction Data:"):
                    if not df_ClkTransaction_job_data.empty:
                        # st.dataframe(df_ClkTransaction_job_data)
                        filtered = dataframe_explorer(df_ClkTransaction_job_data, case=False)
                        st.dataframe(filtered, use_container_width=True)
                    else:
                        st.write(f"Could not retrieve any ShopClk Labour data for {job=}.")
            elif df_explorer_radio == options[1]:
                with st.expander("Syspro Labour Data:"):
                    if not df_WipJobAllLab_job_data.empty:
                        # st.dataframe(df_ClkTransaction_job_data)
                        filtered = dataframe_explorer(df_WipJobAllLab_job_data, case=False)
                        st.dataframe(filtered, use_container_width=True)
                    else:
                        st.write(f"Could not retrieve any Syspro Labour data for {job=}.")
            elif df_explorer_radio == options[2]:
                with st.expander("Syspro Material Data:"):
                    if not df_WipJobAllMat_job_data.empty:
                        # st.dataframe(df_WipJobAllMat_job_data)
                        filtered = dataframe_explorer(df_WipJobAllMat_job_data, case=False)
                        st.dataframe(filtered, use_container_width=True, hide_index=True)
                    else:
                        st.write(f"Could not retrieve any Syspro Material data for {job=}.")

            with st.expander(f"Options + NPOs:"):
                st.write(f"#### Options")
                df_options = df_order_options_bws if COMP == BWS else df_order_options_stg
                df_options = df_options.loc[df_options["WO#"] == int(job)]
                st.dataframe(df_options, use_container_width=True, hide_index=True)

                st.write(f"#### NPOs")
                df_npos = df_npos_bws if COMP == BWS else df_npos_stg
                df_npos = df_npos.loc[df_npos["WO#"] == int(job)]
                st.dataframe(df_npos, use_container_width=True, hide_index=True)

                # for j, op in enumerate(df_timeline_clk["Operation"]):
                #     # st.write(f"{j=}, {op=}, {operation_colour_map[op]=}")
                #     st.write(f"""<p style="color:{operation_colour_map[op]};">{j=}, {op=}, {operation_colour_map[op]=}</p>""", unsafe_allow_html=True)

            with st.expander("Unallocated Parts"):
                df_job_material.sort_values(
                    by=["OperationOffset", "ValueLeftToIssue"],
                    ascending=[True, False],
                    inplace=True
                )
                st.dataframe(df_job_material, hide_index=True, use_container_width=True)


        exp_count += rows_per_expansion

count = st_autorefresh(interval=time_app_refresh, limit=None, key="ProductionOverview")
# print(f"{count=}")

for i, row in df_production_data_by_op.iterrows():
    job = row.get("Job")
    # if job is not None:
    ops_sum = row.get(cols_rename["ProgressOps"], 0)
    if job in SG_QUOTES_OF_INTEREST:
        print(f"QoI {job=}, {ops_sum=}")
    st.session_state[COMP].update({job: {"i": i, "ops_sum": ops_sum}})

