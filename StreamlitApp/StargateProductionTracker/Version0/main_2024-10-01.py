import datetime

import pandas as pd
import streamlit as st
from streamlit.components.v1 import components
from streamlit_autorefresh import st_autorefresh
from streamlit_extras.add_vertical_space import add_vertical_space

from pyodbc_connection import connect

BWS = 0
STG = 1

print(f"RERUN")

st.set_page_config(layout="wide")
st.session_state.setdefault(BWS, {})
st.session_state.setdefault(STG, {})



def click():
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
st.button(
    label="Add",
    on_click=click
)


# time_cache_prod_data_by_op_stg = 60*60*1000  # 1 hour
time_cache_prod_data_by_op_stg = 30*1000  # 30 seconds
time_app_refresh = 30*1000  # every 30 seconds

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
        "uid": "SGeu1",
        "pwd": "Pupplies-Hagard->Rio0"
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
	--, 19 AS [TotalOps]
FROM (
	SELECT
		[Job]
		, [JobDescription]
		, [OrdersV2].[Model No]
		, [DealersV2].[COMPANY NAME]
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
		, [NumOpenTransactions]
	FROM
		(
			SELECT [WipMaster].[Job]
				, [WipMaster].[JobDescription]
				, [WipMaster].[JobDeliveryDate]
				, [WipJobAllLab].[Operation]
				, [WipJobAllLab].[RunTimeIssued]
				, [subClkTransactionCount].[numInProgressTransaction]
				, [WipJobAllLab].[OperCompleted]
				, [subClkTransactionCount].[numCompleteTransaction]
				, ISNULL([subClkTransactionCount].[NumOpenTransactions], 0) AS [NumOpenTransactions]
			FROM
				[SysproCompanyS].[dbo].[WipJobAllLab] WITH (NOLOCK)
			INNER JOIN
				[SysproCompanyS].[dbo].[WipMaster] WITH (NOLOCK)
			ON
				[WipJobAllLab].[Job] = [WipMaster].[Job]
			LEFT OUTER JOIN
				(
					SELECT [JobNumber]
						, [Operation]
						, COUNT(CASE WHEN [OperationComplete] = 0 THEN [TransactionID] END) AS [numInProgressTransaction]
						, COUNT(CASE WHEN [OperationComplete] = 1 THEN [TransactionID] END) AS [numCompleteTransaction]
						, SUM((CASE WHEN [LoggedOff] IS NULL THEN 1 ELSE 0 END)) AS [NumOpenTransactions]
					FROM
						[SysproCompanyS].[dbo].[ClkTransaction] WITH (NOLOCK)
					WHERE
						[JobNumber] <> ''
					GROUP BY
						[JobNumber]
						, [Operation]
				) AS [subClkTransactionCount]
			ON
				[WipJobAllLab].[Job] = [subClkTransactionCount].[JobNumber]
				AND [WipJobAllLab].[Operation] = [subClkTransactionCount].[Operation]
			WHERE
				[ActCompleteDate] IS NULL
		) AS [mainsub]
	INNER JOIN
		[BWSdb].[dbo].[OrdersV2] WITH (NOLOCK)
	ON
		[mainsub].[Job] = CAST([OrdersV2].[WO#] AS VARCHAR(20))
	INNER JOIN
		[BWSdb].[dbo].[DealersV2] WITH (NOLOCK)
	ON
		[OrdersV2].[DealerID] = [DealersV2].[ID]
	GROUP BY
		[Job]
		, [JobDescription]
		, [OrdersV2].[Model No]
		, [DealersV2].[COMPANY NAME]
		, [JobDeliveryDate]
		, [NumOpenTransactions]
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
;
    """
    connection_data = {
        "sql": sql,
        "database": "SysproCompanyS",
        "uid": "SGeu1",
        "pwd": "Pupplies-Hagard->Rio0"
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
	--, 19 AS [TotalOps]
FROM (
	SELECT
		[Job]
		, [JobDescription]
		, [Orders].[Model No]
		, [Dealers].[COMPANY NAME]
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
		, [NumOpenTransactions]
	FROM
		(
			SELECT [WipMaster].[Job]
				, [WipMaster].[JobDescription]
				, [WipMaster].[JobDeliveryDate]
				, [WipJobAllLab].[Operation]
				, [WipJobAllLab].[RunTimeIssued]
				, [subClkTransactionCount].[numInProgressTransaction]
				, [WipJobAllLab].[OperCompleted]
				, [subClkTransactionCount].[numCompleteTransaction]
				, ISNULL([subClkTransactionCount].[NumOpenTransactions], 0) AS [NumOpenTransactions]
			FROM
				[SysproCompanyA].[dbo].[WipJobAllLab] WITH (NOLOCK)
			INNER JOIN
				[SysproCompanyA].[dbo].[WipMaster] WITH (NOLOCK)
			ON
				[WipJobAllLab].[Job] = [WipMaster].[Job]
			LEFT OUTER JOIN
				(
					SELECT [JobNumber]
						, [Operation]
						, COUNT(CASE WHEN [OperationComplete] = 0 THEN [TransactionID] END) AS [numInProgressTransaction]
						, COUNT(CASE WHEN [OperationComplete] = 1 THEN [TransactionID] END) AS [numCompleteTransaction]
						, SUM((CASE WHEN [LoggedOff] IS NULL THEN 1 ELSE 0 END)) AS [NumOpenTransactions]
					FROM
						[SysproCompanyA].[dbo].[ClkTransaction] WITH (NOLOCK)
					WHERE
						[JobNumber] <> ''
					GROUP BY
						[JobNumber]
						, [Operation]
				) AS [subClkTransactionCount]
			ON
				[WipJobAllLab].[Job] = [subClkTransactionCount].[JobNumber]
				AND [WipJobAllLab].[Operation] = [subClkTransactionCount].[Operation]
			WHERE
				[ActCompleteDate] IS NULL
		) AS [mainsub]
	INNER JOIN
		[BWSdb].[dbo].[Orders] WITH (NOLOCK)
	ON
		[mainsub].[Job] = CAST([Orders].[WO#] AS VARCHAR(20))
	INNER JOIN
		[BWSdb].[dbo].[Dealers] WITH (NOLOCK)
	ON
		[Orders].[DealerID] = [Dealers].[ID]
	GROUP BY
		[Job]
		, [JobDescription]
		, [Orders].[Model No]
		, [Dealers].[COMPANY NAME]
		, [JobDeliveryDate]
		, [NumOpenTransactions]
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
;
    """
    connection_data = {
        "sql": sql,
        "database": "SysproCompanyA",
        "uid": "user5",
        "pwd": "M@gic456"
    }
    return connect(**connection_data)


# options_radio_company_choice = [
#     ":#AB2328[BWS]",
#     ":#1B4581[STARGATE]"
# ]
options_radio_company_choice = [
    ":red[BWS]",
    ":blue[STARGATE]"
]
radio_company_choice = st.radio(
    "Company:",
    options_radio_company_choice,
    key="radio_company_choice"
)

COMP = BWS if radio_company_choice == options_radio_company_choice[0] else STG

if COMP == BWS:
    # BWS

    N_OPERATIONS = 19
    df_production_data_status_codes = load_prod_data_status_codes_stg()
    df_production_data_by_op = load_prod_data_by_op_bws()
else:
    # STG

    N_OPERATIONS = 19
    # df_production_data_status_codes = st.session_state.setdefault("df_production_data_status_codes", load_prod_data_status_codes_stg())
    # df_production_data_by_op = st.session_state.setdefault("df_production_data_by_op", load_prod_data_by_op_stg())
    df_production_data_status_codes = load_prod_data_status_codes_stg()
    df_production_data_by_op = load_prod_data_by_op_stg()

og_columns = list(df_production_data_by_op.columns)

og_columns.remove("NumOpenTransactions")
og_columns.insert(0, "NumOpenTransactions")
og_columns.remove("ProgressOps")
og_columns.insert(6, "ProgressOps")

cols_production_og_translator = {col: f"F_{col}" for col in list(df_production_data_by_op.columns) if all(["operation" in col.lower(), "status" in col.lower()])}
cols_production = list(cols_production_og_translator.keys())
cols_production = {int(col.lower().removeprefix("operation").removesuffix("status")): col for col in cols_production}

cell_formatter = lambda status_val: f":large_green_circle:" if status_val == 2 else (f":large_yellow_circle:" if status_val == 1 else f":red_circle:")
for i, col in cols_production.items():
    # # column_config_df_production_data_by_op.update({
    # #     col: st.column_config.CheckboxColumn(
    # #         label=tmpl_column_config_df_production_data_by_op["lbl"](i),
    # #         help=tmpl_column_config_df_production_data_by_op["help"](i),
    # #         default=tmpl_column_config_df_production_data_by_op["default"],
    # #     )
    # # })
    # column_config_df_production_data_by_op.update({
    #     col: st.column_config.TextColumn(
    #         label=tmpl_column_config_df_production_data_by_op["lbl"](i),
    #         help=tmpl_column_config_df_production_data_by_op["help"](i)
    #         # ,
    #         # validate=
    #         # ,
    #         # cell_formatter=cell_formatter
    #         # ,
    #         # default=tmpl_column_config_df_production_data_by_op["default"]
    #
    #     )
    # })

    df_production_data_by_op[f"F_{col}"] = df_production_data_by_op[col].apply(lambda val: cell_formatter(val))

df_production_data_by_op["JobDeliveryDate"] = df_production_data_by_op["JobDeliveryDate"].apply(lambda val: f"{val:%Y-%m-%d}" if not pd.isna(val) else "-")
df_production_data_by_op["NumOpenTransactions"] = df_production_data_by_op["NumOpenTransactions"].apply(lambda val: ":wrench:" if val >= 1 else "")
df_production_data_by_op.sort_values(by="ProgressOps", ascending=False, inplace=True)


table_styles = [
    {
        "fg": "#CECEFF"
    },
    {
        "fg": "#FFFFFF"
    }
]


title_cols = st.columns([1, 0.15])
with title_cols[0]:
    st.write("### Stargate Production Data")
with title_cols[1]:
    st.markdown(f"###### as of: :red[{datetime.datetime.now():%x %X}]")

add_vertical_space(3)

col_widths = [0.15] + [0.36, 0.5, 0.95, 0.95, 0.6] + [0.5] + [0.18 for _ in cols_production]
grid = [st.columns(col_widths, vertical_alignment="bottom")]
# grid.append(st.divider())
grid += [
    st.columns(col_widths)
    for _ in range(df_production_data_by_op.shape[0])
]
# print(f"{len(grid)=}")

cols_rename = {
    "NumOpenTransactions": ":wrench:",
    "JobDescription": "Desc",
    "Model No": "Model",
    "COMPANY NAME": "Company",
    "JobDeliveryDate": "Delivery Date",
    "ProgressOps": "Progress"
}
df_production_data_by_op.rename(
    columns=cols_rename,
    inplace=True
)
cols_description = [col for col in og_columns if col not in cols_production_og_translator]


# Header row
for j, col in enumerate(og_columns):
    if col in cols_production_og_translator:
        col = f"{j - len(cols_description) + 1}"
    col = cols_rename.get(col, col)
    # print(f"HEAD {j=}, {col=}")
    with grid[0][j]:
        st.write(col)
        # st.markdown(f'<div class="sticky-header">{col}</div>', unsafe_allow_html=True)


for i, row in df_production_data_by_op.iterrows():
    job = row["Job"]

    for j, col in enumerate(og_columns):
        col = cols_rename.get(col, col)
        val = df_production_data_by_op.iloc[i][col]
        if col in cols_production_og_translator:
            # draw circles
            new_key = cols_production_og_translator[col]
            val = df_production_data_by_op.iloc[i][new_key]
            with grid[i+1][j]:
                st.write(val)
                # st.markdown(f'<div class="selected-job">{val}</div>', unsafe_allow_html=True)
        else:
            # other labels and progress bars
            with grid[i+1][j]:
                if col == cols_rename["ProgressOps"]:
                    val /= N_OPERATIONS
                    st.progress(val, text=f"{val*100:.2f}%")
                else:
                    st.write(val)


count = st_autorefresh(interval=time_app_refresh, limit=None, key="fizzbuzzcounter")
