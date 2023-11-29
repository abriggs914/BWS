import pandas as pd
import pygwalker as pyg
from pyodbc_connection import *
import streamlit as st
import streamlit.components.v1 as components


average_number_formatting = 2


SQL_DF1 = """SELECT * FROM [v_SFC_BWSUnionSTGOrders];"""

# Dealer Status by Country
SQL_DF2 = """SELECT
	COUNT(*) AS [C]
	,[OriginTable]
	,[Dealers_ID]
	,[Dealers_CompanyID]
	,[Dealers_COMPANYNAME]
	,(CASE WHEN (
		CAST(ISNULL([Dealers_CURRENTDEALER], 0) AS INT) 
		+ CAST(ISNULL([Dealers_CURRENTDEALERCDN], 0) AS INT) 
		+ CAST(ISNULL([Dealers_CURRENTDEALERUS], 0) AS INT)) <> 0 THEN 1 
		ELSE 0
	END) AS [CurrentDealer]
	,(CASE WHEN (
		CAST(ISNULL([Dealers_CURRENTDEALERUS], 0) AS INT) 
		+ CAST(ISNULL([Dealers_EasternUS], 0) AS INT) 
		+ CAST(ISNULL([Dealers_CentralUS], 0) AS INT) 
		+ CAST(ISNULL([Dealers_WesternUS], 0) AS INT)
		+ CAST(ISNULL([Dealers_American], 0) AS INT)) <> 0 THEN 1 
		ELSE 0
	END) AS [USDealer]
	,(CASE WHEN (
		CAST(ISNULL([Dealers_CURRENTDEALERCDN], 0) AS INT) 
		+ CAST(ISNULL([Dealers_EasternCanada], 0) AS INT)
		+ CAST(ISNULL([Dealers_CentralCanada], 0) AS INT)
		+ CAST(ISNULL([Dealers_WesternCanada], 0) AS INT)) <> 0 THEN 1
		ELSE 0
	END) AS [CDNDealer]
FROM
	[v_SFC_BWSUnionSTGOrders]
GROUP BY
	[OriginTable]
	,[Dealers_ID]
	,[Dealers_CompanyID]
	,[Dealers_COMPANYNAME]
	,[Dealers_CURRENTDEALER]
	,[Dealers_EasternUS]
	,[Dealers_CentralUS]
	,[Dealers_WesternUS]
	,[Dealers_EasternCanada]
	,[Dealers_CentralCanada]
	,[Dealers_WesternCanada]
	,[Dealers_American]
	,[Dealers_CURRENTDEALERCDN]
	,[Dealers_CURRENTDEALERUS];
"""

# Warranty Counts
SQL_DF3 = """SELECT
	[V].[OriginTable],
	[V].[Dealers_ID],
	[V].[Dealers_COMPANYNAME],
	COUNT([V].[Orders_DateRegistered]) AS [NumWarrantyRegistrations]
FROM
	[v_SFC_BWSUnionSTGOrders] AS [V]
WHERE
	[V].[Dealers_ID] IS NOT NULL
GROUP BY
	[V].[OriginTable],
	[V].[Dealers_ID],
	[V].[Dealers_COMPANYNAME]
ORDER BY
	[V].[Dealers_COMPANYNAME]
;"""


def get_dealer_id(name: str) -> int:
    ct = st.session_state["choice_company"]
    ci = list_company_choices.index(ct)
    print(f"{name=}, {ct=}, {ci=}")

    # BWS OR STG
    df_choice_dealer_id = df1.loc[
        (df1["OriginTable"] == ct)
        & (df1["Orders_CompanyID"] == ci)
        & (df1["Dealers_COMPANYNAME"] == name)
    ]

    # retrieve the dealer's id
    # st.write("BEFORE")
    # st.table(df_choice_dealer_id)
    df_choice_dealer_id = df_choice_dealer_id.groupby(["Dealers_ID", "Dealers_COMPANYNAME"]).count().reset_index()
    # st.table(df_choice_dealer_id[["Dealers_ID", "Dealers_COMPANYNAME"]])
    # st.write("AFTER")
    # print("AFTER")
    # print(df_choice_dealer_id)
    # st.table(df_choice_dealer_id)
    choice_dealer_id = int(df_choice_dealer_id.loc[0]["Dealers_ID"])
    return choice_dealer_id


def is_dealer_current(name: str | int) -> bool:
    """Is this dealer Name or ID, a current dealer?"""
    if isinstance(name, str):
        df_sub = df2.loc[(df2["Dealers_COMPANYNAME"] == name)]
    else:
        # print(f"HERE A")
        print(df2.loc[df2["Dealers_ID"] == name])
        # print(f"HERE B")
        df_sub = df2.loc[(df2["Dealers_ID"] == name)]

    df_sub = df_sub.reset_index(drop=True)
    # print(f"{df_sub=}")
    # st.table(df_sub)
    rows, cols = df_sub.shape
    if rows:
        return df_sub.loc[0]["CurrentDealer"] == 1


def is_dealer_cdn(name: str | int) -> bool:
    """Is this dealer Name or ID, Canadian?"""
    if isinstance(name, str):
        df_sub = df2.loc[df2["Dealers_COMPANYNAME"] == name]
    else:
        df_sub = df2.loc[df2["Dealers_ID"] == name]

    df_sub = df_sub.reset_index(drop=True)
    rows, cols = df_sub.shape
    if rows:
        return df_sub.loc[0]["CDNDealer"] == 1


def is_dealer_us(name: str | int) -> bool:
    """Is this dealer Name or ID, American?"""
    if isinstance(name, str):
        df_sub = df2.loc[df2["Dealers_COMPANYNAME"] == name]
    else:
        df_sub = df2.loc[df2["Dealers_ID"] == name]

    df_sub = df_sub.reset_index(drop=True)
    rows, cols = df_sub.shape
    if rows:
        return df_sub.loc[0]["USDealer"] == 1


def click_radio_company():
    """Clear session_state choice_dealer when the company is changed."""
    old_val = choice_company
    new_val = st.session_state["choice_company"]

    if old_val != new_val:
        st.session_state["choice_dealer"] = None

    # print(f"CLICK1 {choice_company=}")
    # print(f"CLICK2 {st.session_state['choice_company']=}")


def update_quotes_vs_orders_chart(dealer_id: int):
    """Show this dealer vs country data on quotes vs orders capture rate."""
    print(f"update_quotes_vs_orders_chart")
    choice_dealer = st.session_state["choice_dealer"]
    choice_company_id = list_company_choices.index(st.session_state["choice_company"])
    df_cdn_dealers = df_bws_cdn_dealers if choice_company_id == 0 else df_stg_cdn_dealers
    df_us_dealers = df_bws_us_dealers if choice_company_id == 0 else df_stg_us_dealers
    cdn_ids = set(df_cdn_dealers["Dealers_ID"].values.tolist())
    us_ids = set(df_us_dealers["Dealers_ID"].values.tolist())

    if dealer_id in cdn_ids:
        cdn_ids.remove(dealer_id)
    if dealer_id in us_ids:
        us_ids.remove(dealer_id)

    sql = f"EXEC [sp_SFC_IndividualSalesData] @dealerID=0, @companyID={choice_company_id}"
    print(f"{sql=}")
    df_quotes_vs_orders = connect(sql)

    df_sub_cdn = df_quotes_vs_orders.loc[df_quotes_vs_orders["DealerID"].isin(cdn_ids)]
    df_sub_us = df_quotes_vs_orders.loc[df_quotes_vs_orders["DealerID"].isin(us_ids)]
    df_dealer = df_quotes_vs_orders.loc[df_quotes_vs_orders["DealerID"] == dealer_id]

    n_us_dealers = df_sub_us.shape[0]
    n_cdn_dealers = df_sub_cdn.shape[0]
    n_all_dealers = n_cdn_dealers + n_us_dealers + 1

    cdn_agg_dict = {col: 'count' for col in df_sub_cdn.columns}
    us_agg_dict = {col: 'count' for col in df_sub_us.columns}
    cdn_agg_dict.update({col: 'sum' for col in df_sub_cdn.columns if col.startswith("Num")})
    us_agg_dict.update({col: 'sum' for col in df_sub_us.columns if col.startswith("Num")})

    df_sub_cdn = df_sub_cdn.agg(cdn_agg_dict).to_frame().T
    df_sub_us = df_sub_us.agg(us_agg_dict).to_frame().T

    cols = [
        "OGTable",
        "NumQuotesPrepared",
        "NumInvalidQuotes",
        "NumSoldDeliveredUnits",
        "NumUnitsOnOrder",
        "NumQuotesOutToDealer",
        "NumCancelledQuotes",
        "NumCancelledOrders"
    ]

    df_sub_us = df_sub_us[cols]
    df_sub_cdn = df_sub_cdn[cols]
    df_dealer = df_dealer[cols]

    df_sub_us = df_sub_us[cols]
    df_sub_cdn = df_sub_cdn[cols]
    df_sub_us_avg = df_sub_us[cols]
    df_sub_cdn_avg = df_sub_cdn[cols]

    # print(f"{choice_dealer=}")
    # df_dealer.at[0, "OGTable"] = choice_dealer
    df_sub_us.at[0, "OGTable"] = "US Dealers"
    df_sub_cdn.at[0, "OGTable"] = "CDN Dealers"
    df_sub_us_avg.at[0, "OGTable"] = "US Dealers Avg."
    df_sub_cdn_avg.at[0, "OGTable"] = "CDN Dealers Avg."

    df_dealer["Count"] = 1
    df_sub_us["Count"] = n_us_dealers
    df_sub_cdn["Count"] = n_cdn_dealers
    df_sub_us_avg["Count"] = n_us_dealers
    df_sub_cdn_avg["Count"] = n_cdn_dealers

    # st.write("CDN V")
    # st.table(df_sub_cdn)
    # st.write("CDN ^")
    # st.write("US V")
    # st.table(df_sub_us)
    # st.write("US ^")

    # st.table(df_dealer.append(df_sub_cdn, ignore_index=True).append(df_sub_us, ignore_index=True))

    legend_data = {
        "Long Desc.": [
            "Country Grouping",
            "Count of Dealers in Group",
            "Num Quotes Prepared",
            "Num Invalid Quotes",
            "Num Sold And Delivered Quotes",
            "Num Quotes On Order",
            "Num Quotes Out To Dealer",
            "Num Cancelled Quotes",
            "Num Cancelled Orders"
        ],
        "ColumnName": [
            "OGTable",
            "Count",
            "NumQuotesPrepared",
            "NumInvalidQuotes",
            "NumSoldDeliveredUnits",
            "NumUnitsOnOrder",
            "NumQuotesOutToDealer",
            "NumCancelledQuotes",
            "NumCancelledOrders"
        ],
        "Acronym": [
            "Country",
            "Count",
            "Q",
            "IQ",
            "SD",
            "OO",
            "OD",
            "CQ",
            "CO"
        ]
    }
    dict_legend_data = dict(zip(legend_data["ColumnName"], legend_data["Acronym"]))

    print(f"{dict_legend_data=}")

    df_sub_total = pd.concat(
        [
            df_dealer,
            df_sub_cdn,
            df_sub_us
        ],
        ignore_index=True,
        sort=False
    )[cols]
    df_sub_total = df_sub_total.agg({k: v for k, v in cdn_agg_dict.items() if k in cols}).to_frame().T
    df_sub_avg = pd.concat(
        [
            df_dealer,
            df_sub_cdn,
            df_sub_us
        ],
        ignore_index=True,
        sort=False
    )[cols]
    df_sub_avg = df_sub_avg.agg({k: v for k, v in cdn_agg_dict.items() if k in cols}).to_frame().T

    df_sub_us = df_sub_us.rename(columns=dict_legend_data)
    df_sub_cdn = df_sub_cdn.rename(columns=dict_legend_data)
    df_sub_us_avg = df_sub_us_avg.rename(columns=dict_legend_data)
    df_sub_cdn_avg = df_sub_cdn_avg.rename(columns=dict_legend_data)
    df_dealer = df_dealer.rename(columns=dict_legend_data)
    df_sub_total = df_sub_total.rename(columns=dict_legend_data)
    df_sub_avg = df_sub_avg.rename(columns=dict_legend_data)

    df_sub_total.at[0, "Country"] = "All Dealers Total"
    df_sub_total.at[0, "Count"] = f"{n_all_dealers:.0f}"
    df_sub_avg.at[0, "Country"] = "All Dealers Avg."
    df_sub_avg.at[0, "Count"] = f"{n_all_dealers:.0f}"

    print(f"{df_sub_total=}")
    print(f"{df_sub_us=}")
    print(f"{df_sub_cdn=}")

    for col in legend_data["Acronym"][2:]:
        fmt = f".{average_number_formatting}f"
        df_sub_us_avg.at[0, col] = f"{(df_sub_us_avg.loc[0][col] / n_us_dealers):{fmt}}"
        df_sub_cdn_avg.at[0, col] = f"{(df_sub_cdn_avg.loc[0][col] / n_cdn_dealers):{fmt}}"
        df_sub_avg.at[0, col] = f"{(df_sub_avg.loc[0][col] / n_all_dealers):{fmt}}"

        # df_sub_us_avg.at[0, col] = (df_sub_us_avg.loc[0][col] / n_us_dealers)
        # df_sub_cdn_avg.at[0, col] = (df_sub_cdn_avg.loc[0][col] / n_cdn_dealers)
        # df_sub_avg.at[0, col] = (df_sub_avg.loc[0][col] / n_all_dealers)

    df_legend = pd.DataFrame(data=legend_data)[["Long Desc.", "Acronym"]]

    # Chart title
    qvo_title = f"## {'BWS' if choice_company_id == 0 else 'STG'} Data"

    container_quotes_vs_orders.empty()
    if st.session_state["showing_quotes_vs_orders_legend"]:
        container_quotes_vs_orders.table(df_legend)
        # container_quotes_vs_orders.dataframe(df_legend.style.highlight_max(axis=0))
        # container_quotes_vs_orders.dataframe(df_legend.style.background_gradient(cmap="RdYlGn", vmin=104, vmax=622))
        # container_quotes_vs_orders.dataframe(df_legend.style.bar(subset=['Q'], cmap='summer'))

    df_quotes_vs_orders = pd.concat(
        [
            df_dealer,
            df_sub_cdn_avg,
            df_sub_cdn,
            df_sub_us_avg,
            df_sub_us,
            df_sub_total,
            df_sub_avg
        ],
        ignore_index=True,
        sort=False
    )
    df_quotes_vs_orders.at[0, "Country"] = choice_dealer
    df_quotes_vs_orders = df_quotes_vs_orders[legend_data["Acronym"]]

    # show title and chart
    container_quotes_vs_orders.markdown(qvo_title)
    container_quotes_vs_orders.table(df_quotes_vs_orders)

    # if st.session_state["quotes_vs_orders_chart_style"] == "count":
    #     container_quotes_vs_orders.table(df_quotes_vs_orders)
    # elif st.session_state["quotes_vs_orders_chart_style"] == "":
    #     container_quotes_vs_orders.table(df_quotes_vs_orders)


def update_warranty_registrations_chart(dealer_id: int):
    n_reg = 2
    reg_delta = 5
    container_warranty_registrations.metric(
        label="Warranty Registrations", value=f"{n_reg}", delta=f"{reg_delta}"
    )
    # """Show this dealer vs country data on quotes vs orders capture rate."""
    # print(f"update_quotes_vs_orders_chart")
    # choice_dealer = st.session_state["choice_dealer"]
    # choice_company_id = list_company_choices.index(st.session_state["choice_company"])
    # df_cdn_dealers = df_bws_cdn_dealers if choice_company_id == 0 else df_stg_cdn_dealers
    # df_us_dealers = df_bws_us_dealers if choice_company_id == 0 else df_stg_us_dealers
    # cdn_ids = set(df_cdn_dealers["Dealers_ID"].values.tolist())
    # us_ids = set(df_us_dealers["Dealers_ID"].values.tolist())
    #
    # if dealer_id in cdn_ids:
    #     cdn_ids.remove(dealer_id)
    # if dealer_id in us_ids:
    #     us_ids.remove(dealer_id)
    #
    # sql = f"EXEC [sp_SFC_IndividualSalesData] @dealerID=0, @companyID={choice_company_id}"
    # print(f"{sql=}")
    # df_quotes_vs_orders = connect(sql)
    #
    # df_sub_cdn = df_quotes_vs_orders.loc[df_quotes_vs_orders["DealerID"].isin(cdn_ids)]
    # df_sub_us = df_quotes_vs_orders.loc[df_quotes_vs_orders["DealerID"].isin(us_ids)]
    # df_dealer = df_quotes_vs_orders.loc[df_quotes_vs_orders["DealerID"] == dealer_id]
    #
    # n_us_dealers = df_sub_us.shape[0]
    # n_cdn_dealers = df_sub_cdn.shape[0]
    # n_all_dealers = n_cdn_dealers + n_us_dealers + 1
    #
    # cdn_agg_dict = {col: 'count' for col in df_sub_cdn.columns}
    # us_agg_dict = {col: 'count' for col in df_sub_us.columns}
    # cdn_agg_dict.update({col: 'sum' for col in df_sub_cdn.columns if col.startswith("Num")})
    # us_agg_dict.update({col: 'sum' for col in df_sub_us.columns if col.startswith("Num")})
    #
    # df_sub_cdn = df_sub_cdn.agg(cdn_agg_dict).to_frame().T
    # df_sub_us = df_sub_us.agg(us_agg_dict).to_frame().T
    #
    # cols = [
    #     "OGTable",
    #     "NumQuotesPrepared",
    #     "NumInvalidQuotes",
    #     "NumSoldDeliveredUnits",
    #     "NumUnitsOnOrder",
    #     "NumQuotesOutToDealer",
    #     "NumCancelledQuotes",
    #     "NumCancelledOrders"
    # ]
    #
    # df_sub_us = df_sub_us[cols]
    # df_sub_cdn = df_sub_cdn[cols]
    # df_dealer = df_dealer[cols]
    #
    # df_sub_us = df_sub_us[cols]
    # df_sub_cdn = df_sub_cdn[cols]
    # df_sub_us_avg = df_sub_us[cols]
    # df_sub_cdn_avg = df_sub_cdn[cols]
    #
    # # print(f"{choice_dealer=}")
    # # df_dealer.at[0, "OGTable"] = choice_dealer
    # df_sub_us.at[0, "OGTable"] = "US Dealers"
    # df_sub_cdn.at[0, "OGTable"] = "CDN Dealers"
    # df_sub_us_avg.at[0, "OGTable"] = "US Dealers Avg."
    # df_sub_cdn_avg.at[0, "OGTable"] = "CDN Dealers Avg."
    #
    # df_dealer["Count"] = 1
    # df_sub_us["Count"] = n_us_dealers
    # df_sub_cdn["Count"] = n_cdn_dealers
    # df_sub_us_avg["Count"] = n_us_dealers
    # df_sub_cdn_avg["Count"] = n_cdn_dealers
    #
    # # st.write("CDN V")
    # # st.table(df_sub_cdn)
    # # st.write("CDN ^")
    # # st.write("US V")
    # # st.table(df_sub_us)
    # # st.write("US ^")
    #
    # # st.table(df_dealer.append(df_sub_cdn, ignore_index=True).append(df_sub_us, ignore_index=True))
    #
    # legend_data = {
    #     "Long Desc.": [
    #         "Country Grouping",
    #         "Count of Dealers in Group",
    #         "Num Quotes Prepared",
    #         "Num Invalid Quotes",
    #         "Num Sold And Delivered Quotes",
    #         "Num Quotes On Order",
    #         "Num Quotes Out To Dealer",
    #         "Num Cancelled Quotes",
    #         "Num Cancelled Orders"
    #     ],
    #     "ColumnName": [
    #         "OGTable",
    #         "Count",
    #         "NumQuotesPrepared",
    #         "NumInvalidQuotes",
    #         "NumSoldDeliveredUnits",
    #         "NumUnitsOnOrder",
    #         "NumQuotesOutToDealer",
    #         "NumCancelledQuotes",
    #         "NumCancelledOrders"
    #     ],
    #     "Acronym": [
    #         "Country",
    #         "Count",
    #         "Q",
    #         "IQ",
    #         "SD",
    #         "OO",
    #         "OD",
    #         "CQ",
    #         "CO"
    #     ]
    # }
    # dict_legend_data = dict(zip(legend_data["ColumnName"], legend_data["Acronym"]))
    #
    # print(f"{dict_legend_data=}")
    #
    # df_sub_total = pd.concat(
    #     [
    #         df_dealer,
    #         df_sub_cdn,
    #         df_sub_us
    #     ],
    #     ignore_index=True,
    #     sort=False
    # )[cols]
    # df_sub_total = df_sub_total.agg({k: v for k, v in cdn_agg_dict.items() if k in cols}).to_frame().T
    # df_sub_avg = pd.concat(
    #     [
    #         df_dealer,
    #         df_sub_cdn,
    #         df_sub_us
    #     ],
    #     ignore_index=True,
    #     sort=False
    # )[cols]
    # df_sub_avg = df_sub_avg.agg({k: v for k, v in cdn_agg_dict.items() if k in cols}).to_frame().T
    #
    # df_sub_us = df_sub_us.rename(columns=dict_legend_data)
    # df_sub_cdn = df_sub_cdn.rename(columns=dict_legend_data)
    # df_sub_us_avg = df_sub_us_avg.rename(columns=dict_legend_data)
    # df_sub_cdn_avg = df_sub_cdn_avg.rename(columns=dict_legend_data)
    # df_dealer = df_dealer.rename(columns=dict_legend_data)
    # df_sub_total = df_sub_total.rename(columns=dict_legend_data)
    # df_sub_avg = df_sub_avg.rename(columns=dict_legend_data)
    #
    # df_sub_total.at[0, "Country"] = "All Dealers Total"
    # df_sub_total.at[0, "Count"] = f"{n_all_dealers:.0f}"
    # df_sub_avg.at[0, "Country"] = "All Dealers Avg."
    # df_sub_avg.at[0, "Count"] = f"{n_all_dealers:.0f}"
    #
    # print(f"{df_sub_total=}")
    # print(f"{df_sub_us=}")
    # print(f"{df_sub_cdn=}")
    #
    # for col in legend_data["Acronym"][2:]:
    #     fmt = f".{average_number_formatting}f"
    #     df_sub_us_avg.at[0, col] = f"{(df_sub_us_avg.loc[0][col] / n_us_dealers):{fmt}}"
    #     df_sub_cdn_avg.at[0, col] = f"{(df_sub_cdn_avg.loc[0][col] / n_cdn_dealers):{fmt}}"
    #     df_sub_avg.at[0, col] = f"{(df_sub_avg.loc[0][col] / n_all_dealers):{fmt}}"
    #
    #     # df_sub_us_avg.at[0, col] = (df_sub_us_avg.loc[0][col] / n_us_dealers)
    #     # df_sub_cdn_avg.at[0, col] = (df_sub_cdn_avg.loc[0][col] / n_cdn_dealers)
    #     # df_sub_avg.at[0, col] = (df_sub_avg.loc[0][col] / n_all_dealers)
    #
    # df_legend = pd.DataFrame(data=legend_data)[["Long Desc.", "Acronym"]]
    #
    # # Chart title
    # qvo_title = f"## {'BWS' if choice_company_id == 0 else 'STG'} Data"
    #
    # container_quotes_vs_orders.empty()
    # if st.session_state["showing_quotes_vs_orders_legend"]:
    #     container_quotes_vs_orders.table(df_legend)
    #     # container_quotes_vs_orders.dataframe(df_legend.style.highlight_max(axis=0))
    #     # container_quotes_vs_orders.dataframe(df_legend.style.background_gradient(cmap="RdYlGn", vmin=104, vmax=622))
    #     # container_quotes_vs_orders.dataframe(df_legend.style.bar(subset=['Q'], cmap='summer'))
    #
    # df_quotes_vs_orders = pd.concat(
    #     [
    #         df_dealer,
    #         df_sub_cdn_avg,
    #         df_sub_cdn,
    #         df_sub_us_avg,
    #         df_sub_us,
    #         df_sub_total,
    #         df_sub_avg
    #     ],
    #     ignore_index=True,
    #     sort=False
    # )
    # df_quotes_vs_orders.at[0, "Country"] = choice_dealer
    # df_quotes_vs_orders = df_quotes_vs_orders[legend_data["Acronym"]]
    #
    # # show title and chart
    # container_quotes_vs_orders.markdown(qvo_title)
    # container_quotes_vs_orders.table(df_quotes_vs_orders)
    #
    # # if st.session_state["quotes_vs_orders_chart_style"] == "count":
    # #     container_quotes_vs_orders.table(df_quotes_vs_orders)
    # # elif st.session_state["quotes_vs_orders_chart_style"] == "":
    # #     container_quotes_vs_orders.table(df_quotes_vs_orders)


def update_choice_dealer():
    if st.session_state['choice_dealer']:
        choice_dealer_id = get_dealer_id(st.session_state["choice_dealer"])
        choice_company_id = list_company_choices.index(st.session_state["choice_company"])
        # print(f"EXEC [sp_SFC_IndividualSalesData] @dealerID=-{choice_dealer_id}, @companyID={choice_company_id}")

        # df_quotes_vs_orders = connect(f"EXEC [sp_SFC_IndividualSalesData] @dealerID=-{choice_dealer_id}, @companyID={choice_company_id}")
        # container_quotes_vs_orders.table(df_quotes_vs_orders)

        container_quotes_vs_orders.write(f"DEALER: {choice_dealer}")
        container_quotes_vs_orders.write(f"ID: {choice_dealer_id}")
        container_quotes_vs_orders.write(f"CURRENT: {is_dealer_current(choice_dealer_id)}")
        container_quotes_vs_orders.write(f"CDN: {is_dealer_cdn(choice_dealer_id)}")
        container_quotes_vs_orders.write(f"US: {is_dealer_us(choice_dealer_id)}")

        update_quotes_vs_orders_chart(choice_dealer_id)
        update_warranty_registrations_chart(choice_dealer_id)


def click_showing_quotes_vs_orders_legend():
    showing = st.session_state["showing_quotes_vs_orders_legend"]


# https://www.youtube.com/watch?v=ogyxjkYRgPE&t=988s


database = {
    "df1": SQL_DF1,
    "df2": SQL_DF2,
    "df3": SQL_DF3
}


def load_data():

    for df, sql in database.items():
        time_key = f"{df}_time"
        print(f"{df=}, {time_key=} {sql[:25]=}")
        if time_key not in st.session_state:
            st.session_state[time_key] = datetime.datetime.now()
        elif (datetime.datetime.now() - st.session_state[time_key]).seconds > st.session_state["df_reset_time"]:
            st.session_state[df] = connect(sql)
            st.session_state[time_key] = datetime.datetime.now()

        if df not in st.session_state:
            st.session_state[df] = connect(sql)
            st.session_state[time_key] = datetime.datetime.now()


if __name__ == '__main__':

    title = "Dealer Review Dashboard"

    st.set_page_config(
        page_title=title,
        layout="wide"
    )

    # init session-state
    if "choice_company" not in st.session_state:
        st.session_state["choice_company"] = None
    if "choice_dealer" not in st.session_state:
        st.session_state["choice_dealer"] = None
    if "df_reset_time" not in st.session_state:
        st.session_state["df_reset_time"] = 300

    if "showing_quotes_vs_orders_legend" not in st.session_state:
        st.session_state["showing_quotes_vs_orders_legend"] = False

    load_data()

    # if "df1_time" not in st.session_state:
    #     st.session_state["df1_time"] = datetime.datetime.now()
    # elif (datetime.datetime.now() - st.session_state["df1_time"]).seconds > st.session_state["df_reset_time"]:
    #     st.session_state["df1"] = connect(SQL_DF1)
    #     st.session_state["df1_time"] = datetime.datetime.now()
    #
    # if "df2_time" not in st.session_state:
    #     st.session_state["df2_time"] = datetime.datetime.now()
    # elif (datetime.datetime.now() - st.session_state["df2_time"]).seconds > st.session_state["df_reset_time"]:
    #     st.session_state["df2"] = connect(SQL_DF2)
    #     st.session_state["df2_time"] = datetime.datetime.now()
    #
    # if "df1" not in st.session_state:
    #     st.session_state["df1"] = connect(SQL_DF1)
    #     st.session_state["df1_time"] = datetime.datetime.now()
    #
    # if "df2" not in st.session_state:
    #     st.session_state["df2"] = connect(SQL_DF2)
    #     st.session_state["df2_time"] = datetime.datetime.now()

    st.title(title)

    # df1 = connect("""SELECT * FROM [v_SFC_BWSUnionSTGOrders];""")

    # st.session_state["df1"] = df1
    df1 = st.session_state["df1"]
    df2 = st.session_state["df2"]
    df3 = st.session_state["df3"]

    # print(f"{df1}")
    # print(f"{df2}")
    # print(f"{df3}")

    # Local lists and DFs
    list_known_invalid_dealers = {None, "Cancel", "Cancelled"}
    df_bws_data = df1.loc[(df1["OriginTable"] == "BWS") & (df1["Orders_CompanyID"] == 0)]
    df_stg_data = df1.loc[(df1["OriginTable"] == "STG") & (df1["Orders_CompanyID"] == 1)]
    list_bws_dealers = sorted(
        [d for d in df_bws_data["Dealers_COMPANYNAME"].unique() if d not in list_known_invalid_dealers])
    list_stg_dealers = sorted(
        [d for d in df_stg_data["Dealers_COMPANYNAME"].unique() if d not in list_known_invalid_dealers])
    list_all_dealers = sorted(list(set(list_bws_dealers + list_stg_dealers)))
    list_company_choices = ["BWS", "STG"]  #, "ALL"]
    df_all_cdn_dealers = df2.loc[df2["CDNDealer"]]
    df_all_us_dealers = df2.loc[df2["USDealer"]]
    df_bws_cdn_dealers = df2.loc[df2["CDNDealer"] & (df2["OriginTable"] == "BWS")]
    df_bws_us_dealers = df2.loc[df2["USDealer"] & (df2["OriginTable"] == "BWS")]
    df_stg_cdn_dealers = df2.loc[df2["CDNDealer"] & (df2["OriginTable"] == "STG")]
    df_stg_us_dealers = df2.loc[df2["USDealer"] & (df2["OriginTable"] == "STG")]
    df_warranties_by_country = df3.groupby(["OriginTable"])[["NumWarrantyRegistrations"]].sum()

    n_total_warranties = df_warranties_by_country.sum()
    n_bws_warranties = df_warranties_by_country.loc["BWS"]
    n_stg_warranties = df_warranties_by_country.loc["STG"]

    # Company choice
    choice_company = st.radio(
        "Select a Company:",
        list_company_choices,
        key="choice_company",
        on_change=click_radio_company
        # ,
        # index=None
    )

    choice_dealer = st.selectbox(
        "Select a Dealer:",
        list_bws_dealers if choice_company == list_company_choices[0]
        else (list_stg_dealers if choice_company == list_company_choices[1]
              else (list_all_dealers if choice_company == list_company_choices[-1]
                    else list_bws_dealers)),
        key="choice_dealer",
        on_change=update_choice_dealer
        # ,
        # index=None
    )

    container_quotes_vs_orders = st.expander("Quotes VS. Orders")
    container_warranty_registrations = st.expander("Warranty Registrations")

    choice_show_QVO_legend = container_quotes_vs_orders.toggle(
        "Show Legend",
        key="showing_quotes_vs_orders_legend"
        # ,
        # on_click=click_showing_quotes_vs_orders_legend
    )

    # sb1 = st.selectbox(
    #     "Hello?",
    #     [
    #         "A  | 1.20",
    #         "B  | 1.22",
    #         "C  | 1.25",
    #         "D  | 1.27",
    #         "E  | 1.32"
    #     ]
    # )

    if choice_dealer:
        # ct = st.session_state["choice_company"]
        # ci = 1 if ct == list_company_choices[1] else 0
        # if ct != list_company_choices[-1]:
        #     # BWS OR STG
        #     df_choice_dealer_id = df1.loc[
        #         (df1["OriginTable"] == ct)
        #         & (df1["Orders_CompanyID"] == ci)
        #         & (df1["Dealers_COMPANYNAME"] == choice_dealer)
        #         ]
        # else:
        #     # BWS AND STG
        #     df_choice_dealer_id = df1.loc[
        #         (df1["Dealers_COMPANYNAME"] == choice_dealer)
        #     ]
        #
        # # retrieve the dealers id
        # df_choice_dealer_id = df_choice_dealer_id.groupby(["Dealers_ID", "Dealers_COMPANYNAME"]).count().reset_index()
        # # st.table(df_choice_dealer_id[["Dealers_ID", "Dealers_COMPANYNAME"]])
        # choice_dealer_id = int(df_choice_dealer_id.loc[0]["Dealers_ID"])  # default to first row
        # # st.write(choice_dealer)
        # # st.write(choice_dealer_id)

        print(f"HERE!! {choice_dealer=}")
        update_choice_dealer()

    # pyg_html = pyg.walk(df, return_html=True)
    #
    # components.html(pyg_html, height=1000, scrolling=True)
