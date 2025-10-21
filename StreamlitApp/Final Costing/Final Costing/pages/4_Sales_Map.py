import datetime
from typing import Any

import pandas as pd
import streamlit as st
from geopy.exc import GeocoderUnavailable
from streamlit_extras.add_vertical_space import add_vertical_space
from streamlit_pills import pills
import streamlit_wordcloud as wordcloud

import location_utility
from location_utility import address_to_coords
from pyodbc_connection import connect
from utility import percent, sigmoid
import pydeck as pdk

#####################
# Company Boilerplate
#####################


APP_SHORT_NAME = "Sales Map"
TIME_APP_REFRESH = 45 * 1000  # every 45 seconds
MAX_QUERY_HOLD_TIME: int = 1000 * 60 * 6  # 6 hours
HOLD_FOREVER: float = float("inf")
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
    "radio_sort_order_choice": "Descending",
    "prep_df_start_time": None,
    "tg_show_hexagons": False
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
	[Quote#]
	,[WO#]
	,[Model No]
	,[Customer]
	,[Dealer]
	,ISNULL([CustAddress], [DealerAddress]) AS [ShippedAddress]
	,ISNULL([CustCity], [DealerCity]) AS [ShippedCity]
	,ISNULL([CustProvince], [DealerProvince]) AS [ShippedProvince]
	,ISNULL([CustPostal], [DealerPostal]) AS [ShippedPostal]
    ,[ShippedAddressString]
    ,[ShippedLatitude]
    ,[ShippedLongitude]
FROM (
	SELECT
		[O].[Quote#]
		,[O].[WO#]
		,[O].[Model No]
		,[C].[Customer]
		,[C].[Address] AS [CustAddress]
		,[C].[City] AS [CustCity]
		,[C].[Province/State] AS [CustProvince]
		,[C].[Postal Code/ZIP] AS [CustPostal]
		,[D].[COMPANY NAME] AS [Dealer]
		,[D].[Address] AS [DealerAddress]
		,[D].[City] AS [DealerCity]
		,[D].[PROVINCE] AS [DealerProvince]
		,[D].[POSTAL CODE] AS [DealerPostal]
		,[C].[ShippedAddressString]
		,[C].[ShippedLatitude]
		,[C].[ShippedLongitude]
	FROM
		[BWSdb].[dbo].[Orders] [O]
	LEFT JOIN
		[BWSdb].[dbo].[Dealers] [D]
	ON
		[O].[DealerID] = [D].[ID]
	LEFT JOIN
		[BWSdb].[dbo].[Dealers_SalesPeople] [DS]
	ON
		([O].[DealerBranchID] = [DS].[BranchID])
		AND ([O].[DealerSalesPersonID] = [DS].[Dealers_SPID])
		AND ([O].[DealerID] = [DS].[DealerID])
	LEFT JOIN
		[BWSdb].[dbo].[Dealers_SalesPersonBranch] [DSB]
	ON
		([DS].[BranchID] = [DSB].[Dealers_SPBID])
	LEFT JOIN
		[BWSdb].[dbo].[Customers] [C]
	ON
		[O].[WO#] = [C].[WO#]
	WHERE
		([O].[Decline/Rejected] = 4)
		AND ([O].[WO#] IS NOT NULL)
) AS [Src]
"""
    connection_data = {
        "sql": sql,
        "database": "bwsdb",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect(**connection_data)


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_model_freq_data() -> pd.DataFrame:
    sql: str = """
SELECT
	[ModelSrc].[C_M] AS [CompID]
	, [ModelSrc].[ProductID]
	, [ModelSrc].[Class]
	, [ModelSrc].[Model No]
	, ISNULL([OrderSrc].[NQuotes], 0) AS [NQuotes_Model]
	, ISNULL([OrderSrc].[NOrders], 0) AS [NOrders_Model]
	, ISNULL([ClassSrc].[NQuotes], 0) AS [NQuotes_Class]
	, ISNULL([ClassSrc].[NOrders], 0) AS [NOrders_Class]
	, ISNULL([CompSrc].[NQuotes], 0) AS [NQuotes_Company]
	, ISNULL([CompSrc].[NOrders], 0) AS [NOrders_Company]
	, [OrderSrc].[FirstQuote] AS [FirstQuote_Model]
	, [OrderSrc].[LastQuote] AS [LastQuote_Model]
	, [ClassSrc].[FirstQuote] AS [FirstQuote_Class]
	, [ClassSrc].[LastQuote] AS [LastQuote_Class]
	, [CompSrc].[FirstQuote] AS [FirstQuote_Company]
	, [CompSrc].[LastQuote] AS [LastQuote_Company]
	, ISNULL([OrderSrc].[NOrders], 0) / CAST((CASE WHEN ISNULL([OrderSrc].[NQuotes], 0) = 0 THEN 1 ELSE [OrderSrc].[NQuotes] END) AS DECIMAL(18, 8)) AS [CaptureRate_Model]
	, ISNULL([ClassSrc].[NOrders], 0) / CAST((CASE WHEN ISNULL([ClassSrc].[NQuotes], 0) = 0 THEN 1 ELSE [ClassSrc].[NQuotes] END) AS DECIMAL(18, 8)) AS [CaptureRate_Class]
	, ISNULL([CompSrc].[NOrders], 0) / CAST((CASE WHEN ISNULL([CompSrc].[NQuotes], 0) = 0 THEN 1 ELSE [CompSrc].[NQuotes] END) AS DECIMAL(18, 8)) AS [CaptureRate_Company]
	, [OrderSrc].[FirstDateQuote] AS [FirstDateQuote_Model]
	, [OrderSrc].[LastDateQuote] AS [LastDateQuote_Model]
	, [ClassSrc].[FirstDateQuote] AS [FirstDateQuote_Class]
	, [ClassSrc].[LastDateQuote] AS [LastDateQuote_Class]
	, [CompSrc].[FirstDateQuote] AS [FirstDateQuote_Company]
	, [CompSrc].[LastDateQuote] AS [LastDateQuote_Company]
FROM (
	SELECT
		[P].[IDTrailer] AS [ProductID]
		, [P].[Class]
		, [P].[Model No]
		, 0 AS [C_M]
	FROM
		[BWSdb].[dbo].[Products] [P]
	WHERE
		([P].[Proposed] = 0)
		AND ([P].[Non-Current] = 0)
		AND ([P].[CompanyID] = 0)
	UNION ALL
	SELECT
		[P2].[IDTrailer] AS [ProductID]
		, [P2].[Class]
		, [P2].[Model No]
		, 1 AS [C_M]
	FROM
		[BWSdb].[dbo].[ProductsV2] [P2]
	WHERE
		([P2].[Proposed] = 0)
		AND ([P2].[Non-Current] = 0)
		AND ([P2].[CompanyID] = 1)
) AS [ModelSrc]
LEFT JOIN (
	SELECT
		0 AS [C_O]
		, [O].[ProductID]
		, [O].[Model No]
		, COUNT(*) AS [NQuotes]
		, SUM((CASE WHEN [O].[Decline/Rejected] = 4 THEN 1 ELSE 0 END)) AS [NOrders]
		, MIN([O].[Quote#]) AS [FirstQuote]
		, MAX([O].[Quote#]) AS [LastQuote]
		, MIN([O].[Quote Date]) AS [FirstDateQuote]
		, MAX([O].[Quote Date]) AS [LastDateQuote]
	FROM
		[BWSdb].[dbo].[Orders] [O]
	GROUP BY
		[O].[ProductID]
		, [O].[Model No]
	UNION ALL
	SELECT
		1 AS [C_O]
		, [O2].[ProductID]
		, [O2].[Model No]
		, COUNT(*) AS [NQuotes]
		, SUM((CASE WHEN [O2].[Decline/Rejected] = 4 THEN 1 ELSE 0 END)) AS [NOrders]
		, MIN(CAST(RIGHT([O2].[SGQuote], 6) AS INT)) AS [FirstQuote]
		, MAX(CAST(RIGHT([O2].[SGQuote], 6) AS INT)) AS [LastQuote]
		, MIN([O2].[Quote Date]) AS [FirstDateQuote]
		, MAX([O2].[Quote Date]) AS [LastDateQuote]
	FROM
		[BWSdb].[dbo].[OrdersV2] [O2]
	GROUP BY
		[O2].[ProductID]
		, [O2].[Model No]
) AS [OrderSrc]
ON
	([ModelSrc].[ProductID] = [OrderSrc].[ProductID])
	AND ([ModelSrc].[C_M] = [OrderSrc].[C_O])
LEFT JOIN (
	SELECT
		[ModelSrc].[C_M] AS [CompID]
		, [ModelSrc].[Class]
		, ISNULL(SUM([OrderSrc].[NQuotes]), 0) AS [NQuotes]
		, ISNULL(SUM([OrderSrc].[NOrders]), 0) AS [NOrders]
		, MIN([OrderSrc].[FirstQuote]) AS [FirstQuote]
		, MAX([OrderSrc].[LastQuote]) AS [LastQuote]
		, MIN([OrderSrc].[FirstDateQuote]) AS [FirstDateQuote]
		, MAX([OrderSrc].[LastDateQuote]) AS [LastDateQuote]
	FROM (
		SELECT
			[P].[IDTrailer] AS [ProductID]
			, [P].[Class]
			, [P].[Model No]
			, 0 AS [C_M]
		FROM
			[BWSdb].[dbo].[Products] [P]
		WHERE
			([P].[Proposed] = 0)
			AND ([P].[Non-Current] = 0)
			AND ([P].[CompanyID] = 0)
		UNION ALL
		SELECT
			[P2].[IDTrailer] AS [ProductID]
			, [P2].[Class]
			, [P2].[Model No]
			, 1 AS [C_M]
		FROM
			[BWSdb].[dbo].[ProductsV2] [P2]
		WHERE
			([P2].[Proposed] = 0)
			AND ([P2].[Non-Current] = 0)
			AND ([P2].[CompanyID] = 1)
	) AS [ModelSrc]
	LEFT JOIN (
		SELECT
			0 AS [C_O]
			, [O].[ProductID]
			, [O].[Model No]
			, COUNT(*) AS [NQuotes]
			, SUM((CASE WHEN [O].[Decline/Rejected] = 4 THEN 1 ELSE 0 END)) AS [NOrders]
			, MIN([O].[Quote#]) AS [FirstQuote]
			, MAX([O].[Quote#]) AS [LastQuote]
			, MIN([O].[Quote Date]) AS [FirstDateQuote]
			, MAX([O].[Quote Date]) AS [LastDateQuote]
		FROM
			[BWSdb].[dbo].[Orders] [O]
		GROUP BY
			[O].[ProductID]
			, [O].[Model No]
		UNION ALL
		SELECT
			1 AS [C_O]
			, [O2].[ProductID]
			, [O2].[Model No]
			, COUNT(*) AS [NQuotes]
			, SUM((CASE WHEN [O2].[Decline/Rejected] = 4 THEN 1 ELSE 0 END)) AS [NOrders]
			, MIN(CAST(RIGHT([O2].[SGQuote], 6) AS INT)) AS [FirstQuote]
			, MAX(CAST(RIGHT([O2].[SGQuote], 6) AS INT)) AS [LastQuote]
			, MIN([O2].[Quote Date]) AS [FirstDateQuote]
			, MAX([O2].[Quote Date]) AS [LastDateQuote]
		FROM
			[BWSdb].[dbo].[OrdersV2] [O2]
		GROUP BY
			[O2].[ProductID]
			, [O2].[Model No]
	) AS [OrderSrc]
	ON
		([ModelSrc].[ProductID] = [OrderSrc].[ProductID])
		AND ([ModelSrc].[C_M] = [OrderSrc].[C_O])
	GROUP BY
		[ModelSrc].[C_M]
		,[ModelSrc].[Class]
) AS [ClassSrc]
ON
	[ModelSrc].[Class] = [ClassSrc].[Class]
LEFT JOIN (
	SELECT
		0 AS [C_C]
		, COUNT(*) AS [NQuotes]
		, SUM((CASE WHEN [O].[Decline/Rejected] = 4 THEN 1 ELSE 0 END)) AS [NOrders]
		, MIN([O].[Quote#]) AS [FirstQuote]
		, MAX([O].[Quote#]) AS [LastQuote]
		, MIN([O].[Quote Date]) AS [FirstDateQuote]
		, MAX([O].[Quote Date]) AS [LastDateQuote]
	FROM
		[BWSdb].[dbo].[Orders] [O]
	UNION ALL
	SELECT
		1 AS [C_C]
		, COUNT(*) AS [NQuotes]
		, SUM((CASE WHEN [O2].[Decline/Rejected] = 4 THEN 1 ELSE 0 END)) AS [NOrders]
		, MIN(CAST(RIGHT([O2].[SGQuote], 6) AS INT)) AS [FirstQuote]
		, MAX(CAST(RIGHT([O2].[SGQuote], 6) AS INT)) AS [LastQuote]
		, MIN([O2].[Quote Date]) AS [FirstDateQuote]
		, MAX([O2].[Quote Date]) AS [LastDateQuote]
	FROM
		[BWSdb].[dbo].[OrdersV2] [O2]
) AS [CompSrc]
ON
	[ModelSrc].[C_M] = [CompSrc].[C_C]
ORDER BY
	[ModelSrc].[Model No]
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


##################
# Helper Functions
##################


@st.cache_data(show_spinner=False, ttl=HOLD_FOREVER)
def query_lat_long(str_address) -> tuple[float, float]:
    try:
        return address_to_coords(str_address)
    except GeocoderUnavailable:
        return None, None


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def add_lat_long(df: pd.DataFrame) -> pd.DataFrame:
    progress_lat_long = st.progress(
        value=0,
        text="Loading..."
    )
    df[["strAddress", "latitude", "longitude"]] = (None, None, None)
    total = df.shape[0]
    for i, row in df.iterrows():
        str_address = f"{row['ShippedCity']}, {row['ShippedProvince']}"
        # st.write(f"{i=}, {str_address=}")
        progress_lat_long.progress(
            value=i / total,
            text=f"{percent(i / total)} - {i} / {total}")
        df.loc[i, ["strAddress", "latitude", "longitude"]] = str_address, *query_lat_long(str_address)

    progress_lat_long.progress(1, "Complete!")
    progress_lat_long.empty()
    return df


# # Function to create HTML progress bar without newlines
# def create_progress_bar_html(status_id):
#     progress = (status_id / 13) * 100
#     return f'<div style="width: 100%;"><div style="width: {progress}%; background-color: #76c7c0; text-align: center; color: white;">{progress:.1f}%</div></div>'


####################
# Fetch Data SLOW...
####################


# df_stg = load_data_stg()
df_stg = pd.DataFrame()
df_bws = load_data_bws()



tab_names = ["Word-Cloud", "Map"]
tab_choice = pills("Options:", tab_names)


if tab_choice == tab_names[1]:

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


    df_sales = df_bws

    lat_long_cols = ["latitude", "longitude"]
    df_sales = df_sales.rename(columns={"ShippedLatitude": "latitude", "ShippedLongitude": "longitude"})
    df_sales = df_sales.dropna(subset=lat_long_cols)
    df_sales["Size"] = 2000
    df_sales_addr_counts: pd.DataFrame = df_sales.groupby(by=lat_long_cols).agg({"Size": "count"}).reset_index()

    st.dataframe(df_sales)
    st.dataframe(df_sales_addr_counts)

    total_addr_counts: int = df_sales_addr_counts["Size"].sum()
    for i, row in df_sales.iterrows():
        lat: float = row["latitude"]
        long: float = row["longitude"]
        if not any([pd.isna(lat), pd.isna(long)]):
            # st.write(f"{i=}, {lat=}, {long=}")
            count: int = df_sales_addr_counts.loc[
                (df_sales_addr_counts["latitude"] == lat)
                & (df_sales_addr_counts["longitude"] == long)
            ].iloc[0]["Size"]
            # st.write(f"  => {count=}")
            df_sales.loc[i, ["Size", "SizeN"]] = count * 50, count
    # df_sales["Size"] = df_sales.apply(
    #     lambda row:
    #         df_sales_addr_counts.loc[
    #             (df_sales_addr_counts["latitude"] == row["latitude"])
    #             & (df_sales_addr_counts["longitude"] == row["longitude"]),
    #             "Size"
    #         ] * 20,
    #     axis=1
    # )

    st.dataframe(df_sales)
    st.dataframe(df_sales_addr_counts)


    # FOR TESTING
    # df_sales = df_sales.loc[df_sales["Quote#"] > 30800].reset_index()
    # df_sales = add_lat_long(df_sales)

    # progress_lat_long = st.progress(
    #     value=0,
    #     text="Loading..."
    # )
    # df_sales["strAddress"] = df_sales.apply(lambda row: f"{row['ShippedCity']}, {row['ShippedProvince']}", axis=1)
    # df_sales[["latitude", "longitude"]] = (None, None)
    # st.dataframe(df_sales, hide_index=True, use_container_width=True)
    # unique_addresses = df_sales["strAddress"].str.lower().dropna().unique()
    # # total = df_sales.shape[0]
    # total = len(unique_addresses)
    # st.session_state["prep_df_start_time"] = datetime.datetime.now()
    # for i, address in enumerate(unique_addresses):
    #     # st.write(f"{i=}, {address_lines=}")
    #     s_past = (datetime.datetime.now() - st.session_state.get("prep_df_start_time")).total_seconds()
    #     progress_lat_long.progress(
    #         value=i / total,
    #         text=f"{percent(i / total)} - {i} / {total} - {s_past} s")
    #     df_sales.loc[df_sales["strAddress"].str.lower() == address, ["latitude", "longitude"]] = query_lat_long(address)
    # # for i, row in df_sales.iterrows():
    # #     # st.write(f"{i=}, {str_address=}")
    # #     progress_lat_long.progress(
    # #         value=i / total,
    # #         text=f"{percent(i / total)} - {i} / {total}")
    # #     df_sales.loc[i, ["strAddress", "latitude", "longitude"]] = str_address, *query_lat_long(str_address)
    # progress_lat_long.progress(1, "Complete!")
    # progress_lat_long.empty()

    #######################
    # Begin Widget Creation
    #######################
    st.write(f"df_sales")
    st.dataframe(df_sales, hide_index=True)

    st.write(f"## :red[BWS data only on maps - Stargate coming soon]")
    st.map(
        df_sales[lat_long_cols].dropna(subset=lat_long_cols)
    )

    here = location_utility.get_ip_coords()
    default_here = [37.76, -122.4]
    if here is None:
        here = default_here
    elif here[0] is None:
        here = default_here

    view_state = pdk.ViewState(
        latitude=here[0], longitude=here[1], controller=True, zoom=2.4, pitch=30
    )

    toggle_show_hexagons = st.toggle(
        label="Hexagons",
        key="tg_show_hexagons"
    )

    if st.session_state.get("tg_show_hexagons"):
        chart = pdk.Deck(
            map_style=None,
            height=1000,
            initial_view_state=view_state,
            layers=[pdk.Layer(
            "HexagonLayer",
                data=df_sales,
                get_position="[longitude, latitude]",
                radius=10000,
                elevation_scale=200,
                elevation_range=[0, 5000],
                pickable=True,
                extruded=True,
                id="sales_by_address_hexagons"
            )]
        )
    else:
        chart = pdk.Deck(
            map_style=None,
            height=1000,
            initial_view_state=view_state,
            layers=[pdk.Layer(
            "ScatterplotLayer",
                data=df_sales,
                get_position="[longitude, latitude]",
                get_color="[200, 30, 0, 160]",
                get_radius="Size",
                pickable=True,
                id="sales_by_address_points"
            )],
            tooltip={"text": "{SizeN}x {ShippedAddressString}"}
        )

    event = st.pydeck_chart(
        chart
        # ,
        # on_select="rerun",
        # selection_mode="multi-object"
    )
    st.write(event.selection)
    # st.write(event.selection())  # error
    # for k, v in event.selection.items():  # error
    #     st.write(f"{k=}, {v=}")


    # grid = {
    #     "content_row_0": st.columns(2),
    #     "content_row_1": st.container()
    # }
    #
    #
    # options_sort_col = ["None"] + MonitoringSchedulesqlquerydf.columns.tolist()
    # with grid["content_row_0"][0]:
    #     radio_sort_col_choice = st.radio(
    #         "Sort Order:",
    #         options_sort_col,
    #         key="radio_sort_col_choice",
    #         horizontal=True
    #     )
    #
    # options_sort_order = ["None", "Ascending", "Descending"]
    # sort_col = radio_sort_col_choice
    # sort_ord = st.session_state.get("radio_sort_order_choice")
    # if sort_col != "None":
    #     with grid["content_row_0"][1]:
    #         radio_sort_order_choice = st.radio(
    #             "Sort Order:",
    #             options_sort_order,
    #             key="radio_sort_order_choice",
    #             horizontal=True
    #         )
    #         sort_ord = radio_sort_order_choice
    #
    # if (radio_sort_col_choice != "None") and (sort_ord != "None"):
    #     MonitoringSchedulesqlquerydf.sort_values(by=sort_col, ascending=sort_ord == "Ascending", inplace=True)
    #
    # with grid["content_row_1"]:
    #     add_vertical_space(3)
    #     # Add SQL dataframe to streamlit site
    #     st.write(MonitoringSchedulesqlquerydf.to_html(escape=False, index=False), unsafe_allow_html=True)

else:

    df_model_freq_data: pd.DataFrame = load_model_freq_data()
    total = df_model_freq_data["NOrders_Model"].sum()
    df_model_freq_data["Value_Model"] = df_model_freq_data.apply(
        lambda row:
            50000 * (row.get("NOrders_Model", 0) if not pd.isna(row["NOrders_Model"]) else 0) / total
            # 50000 * sigmoid((row.get("NOrders", 0) if not pd.isna(row["NOrders"]) else 0) / total)
        , axis=1
    )
    df_model_freq_data["Value_Class"] = df_model_freq_data.apply(
        lambda row:
            50000 * (row.get("NOrders_Class", 0) if not pd.isna(row["NOrders_Class"]) else 0) / total
            # 50000 * sigmoid((row.get("NOrders", 0) if not pd.isna(row["NOrders"]) else 0) / total)
        , axis=1
    )
    st.write(df_model_freq_data.columns.tolist())
    st.dataframe(df_model_freq_data)

    words_bws_model = [
        {
            "text": row["Model No"],
            "value": row["Value_Model"],
            "value_": row["NOrders_Model"],
            "class": row["Class"]
        }
        for i, row in df_model_freq_data.loc[
            (df_model_freq_data["CompID"] == 0)
            & (df_model_freq_data["NOrders_Model"] > 0)
        ].iterrows()
    ]
    words_stg_model = [
        {
            "text": row["Model No"],
            "value": row["Value_Model"],
            "value_": row["NOrders_Model"],
            "class": row["Class"]
        }
        for i, row in df_model_freq_data.loc[
            (df_model_freq_data["CompID"] == 1)
            & (df_model_freq_data["NOrders_Model"] > 0)
        ].iterrows()
    ]

    words_bws_class = [
        {
            "text": row["Class"],
            "value": row["Value_Class"],
            "value_": row["NOrders_Class"]
        }
        for i, row in df_model_freq_data.loc[
            (df_model_freq_data["CompID"] == 0)
            & (df_model_freq_data["NOrders_Class"] > 0)
        ].iterrows()
    ]
    words_stg_class = [
        {
            "text": row["Class"],
            "value": row["Value_Class"],
            "value_": row["NOrders_Class"]
        }
        for i, row in df_model_freq_data.loc[
            (df_model_freq_data["CompID"] == 1)
            & (df_model_freq_data["NOrders_Class"] > 0)
        ].iterrows()
    ]
    words_bws_model = list(map(eval, list(set(map(str, words_bws_model)))))
    words_stg_model = list(map(eval, list(set(map(str, words_stg_model)))))
    words_bws_class = list(map(eval, list(set(map(str, words_bws_class)))))
    words_stg_class = list(map(eval, list(set(map(str, words_stg_class)))))

    words_bws_model = sorted(words_bws_model, key=lambda d: d["value"], reverse=True)
    words_stg_model = sorted(words_stg_model, key=lambda d: d["value"], reverse=True)
    words_bws_class = sorted(words_bws_class, key=lambda d: d["value"], reverse=True)
    words_stg_class = sorted(words_stg_class, key=lambda d: d["value"], reverse=True)

    # st.write(words)
    # st.write(f"{len(words)=}")

    # words = [
    #     dict(text="Robinhood", value=16000, color="#b5de2b", country="US", industry="Cryptocurrency"),
    #     dict(text="Personio", value=8500, color="#b5de2b", country="DE", industry="Human Resources"),
    #     dict(text="Boohoo", value=6700, color="#b5de2b", country="UK", industry="Beauty"),
    #     dict(text="Deliveroo", value=13400, color="#b5de2b", country="UK", industry="Delivery"),
    #     dict(text="SumUp", value=8300, color="#b5de2b", country="UK", industry="Credit Cards"),
    #     dict(text="CureVac", value=12400, color="#b5de2b", country="DE", industry="BioPharma"),
    #     dict(text="Deezer", value=10300, color="#b5de2b", country="FR", industry="Music Streaming"),
    #     dict(text="Eurazeo", value=31, color="#b5de2b", country="FR", industry="Asset Management"),
    #     dict(text="Drift", value=6000, color="#b5de2b", country="US", industry="Marketing Automation"),
    #     dict(text="Twitch", value=4500, color="#b5de2b", country="US", industry="Social Media"),
    #     dict(text="Plaid", value=5600, color="#b5de2b", country="US", industry="FinTech"),
    # ]

    max_words: int = max(len(words_bws_model), len(words_stg_model))
    st.session_state.setdefault("slider_show_number_models", max_words)
    slider_show_number_models = st.slider(
        label="Show # Models",
        key="slider_show_number_models",
        min_value=5,
        max_value=max_words,
        step=1
    )

    # st.write("<br>")
    # st.write(f"Try hovering over a model")
    # st.write("<br>")


    st.write("Models:")
    model_cols = st.columns(2)
    st.write("Classes:")
    class_cols = st.columns(2)

    st.write(f":red[Data represents all Orders from BWS & Stargate systems for All-time.]")

    w, h = "800px", "600px"

    with model_cols[0]:
        st.write(":red[BWS]")
        wordcloud_bws_model = wordcloud.visualize(
            words_bws_model,
            width=w,
            height=h,
            tooltip_data_fields={
                'text': 'Model Name',
                'value_': '# Orders',
                'value': 'per. value',
                'class': 'Model Class'
            },
            per_word_coloring=False,
            ignore_hover=True,
            max_words=st.session_state.get("slider_show_number_models")
        )

    with model_cols[1]:
        st.write(":blue[Stargate]")
        wordcloud_stg_model = wordcloud.visualize(
            words_stg_model,
            width=w,
            height=h,
            tooltip_data_fields={
                'text': 'Model Name',
                'value_': '# Orders',
                'value': 'per. value',
                'class': 'Model Class'
            },
            per_word_coloring=False,
            ignore_hover=True,
            max_words=st.session_state.get("slider_show_number_models")
        )

    with class_cols[0]:
        st.write(":red[BWS]")
        wordcloud_bws_class = wordcloud.visualize(
            words_bws_class,
            width=w,
            height=h,
            tooltip_data_fields={
                'text': 'Class',
                'value_': '# Orders',
                'value': 'per. value'
            },
            per_word_coloring=False,
            ignore_hover=True,
            max_words=st.session_state.get("slider_show_number_models")
        )

    with class_cols[1]:
        st.write(":blue[Stargate]")
        wordcloud_stg_class = wordcloud.visualize(
            words_stg_class,
            width=w,
            height=h,
            tooltip_data_fields={
                'text': 'Class',
                'value_': '# Orders',
                'value': 'per. value'
            },
            per_word_coloring=False,
            ignore_hover=True,
            max_words=st.session_state.get("slider_show_number_models")
        )

    st.write(f"{wordcloud_bws_model=}")
    st.write(f"{wordcloud_stg_model=}")
    st.write(f"{wordcloud_bws_class=}")
    st.write(f"{wordcloud_stg_class=}")
