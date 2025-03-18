import datetime
import os
from typing import Any, Optional

import pandas as pd
import pyautogui
import streamlit as st
import pygwalker as pyg
import streamlit.components.v1 as components
from streamlit_agraph import Node, Config, agraph, Edge
from streamlit_pdf_viewer import pdf_viewer
from streamlit_pills import pills
from st_aggrid import AgGrid, GridOptionsBuilder
import plotly.express as px

from colour_utility import RED, Colour
from pyodbc_connection import connect, connect_2
from sql_utility import casify
from utility import money, flatten


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


colour_node_op = Colour("#1277CC")
colour_node_part_needed = Colour("#CC1212")
colour_node_part_complete = Colour("#77CC12")
colour_node_part_subs_needed = Colour("#CC1212").darken(0.35)
colour_node_part_subs_complete = Colour("#FFF712")
size_node_op = 60
size_node_part = 25
size_node_part_sub = 15

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


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_inventory_20250306() -> pd.DataFrame:
# #     sql0 = casify(("""
# # -- Dump BOM and Access model data into temp table for faster processing
# # select BomStructure.Component
# #     , case when len(BomStructure.Warehouse) = 0 then InvMaster.WarehouseToUse
# #             else BomStructure.Warehouse
# #             end as Warehouse
# #     , BomStructure.ParentPart
# #     , case when AccessBaseModel.[Model No] is not null and AccessQuoteModel.[Model No] is null then AccessBaseModel.[Model No]
# #             when AccessBaseModel.[Model No] is null and AccessQuoteModel.[Model No] is not null then AccessQuoteModel.[Model No]
# #             end as [Model No]
# #     , case when AccessBaseModel.[Model No] is not null and AccessQuoteModel.[Model No] is null then AccessBaseModel.[Class]
# #             when AccessBaseModel.[Model No] is null and AccessQuoteModel.[Model No] is not null then AccessQuoteModel.[Class]
# #             end as [Class]
# #     , case when AccessBaseModel.[Model No] is not null and AccessQuoteModel.[Model No] is null then AccessBaseModel.[Grouping]
# #             when AccessBaseModel.[Model No] is null and AccessQuoteModel.[Model No] is not null then AccessQuoteModel.[Grouping]
# #             end as [Grouping]
# # into
# #     #BomModelData
# # FROM
# #     SysproCompanyA.dbo.BomStructure with (nolock)
# # INNER JOIN
# #     SysproCompanyA.dbo.InvMaster with (nolock)
# # ON
# #     BomStructure.Component = InvMaster.StockCode
# # LEFT OUTER JOIN
# #     (
# #         select Class
# #             , [Model No]
# #             , [Grouping]
# #             , [Top Level Part# (SYSPRO 8)]
# #         from
# #             BWSdb.dbo.Products WITH (NOLOCK)
# #         WHERE
# #             [Non-Current] = 0
# #             and [Proposed] = 0
# #     ) AS AccessBaseModel
# # ON
# #     BomStructure.ParentPart = AccessBaseModel.[Top Level Part# (SYSPRO 8)] COLLATE Latin1_General_BIN
# # LEFT OUTER JOIN
# #     BWSdb.dbo.Orders WITH (NOLOCK)
# # ON
# #     RIGHT(BomStructure.ParentPart, 6) = '-' + CAST(Orders.[Quote#] AS VARCHAR)
# # LEFT OUTER JOIN
# #     (
# #         select IDTrailer
# #             , Class
# #             , [Model No]
# #             , [Grouping]
# #             , [Top Level Part# (SYSPRO 8)]
# #         from
# #             BWSdb.dbo.Products WITH (NOLOCK)
# #         WHERE
# #             [Non-Current] = 0
# #             and [Proposed] = 0
# #     ) AS AccessQuoteModel
# # ON
# #     Orders.ProductID = AccessQuoteModel.IDTrailer
# #     OR Orders.[Model No] = AccessQuoteModel.[Model No]
# # ;
# #
# # -- Dump Inventory values into temp table for faster processing
# # select InvMaster.StockCode
# #     , InvWarehouse.Warehouse
# #     , InvMaster.WarehouseToUse
# #     , InvMaster.CycleCount
# #     , case CycleCount when '1' then '1 - PURCHASED'
# #                     when '2' then '2 - FULL LENGTH STEEL/ALUMINUM'
# #                     when '3' then '3 - STEEL KITS'
# #                     when '4' then '4 - PRECUT STEEL'
# #                     when '5' then '5 - PAINT/PAINT PRODUCTS'
# #                     when '6' then '6 - CONSUMABLES'
# #                     when '7' then '7 - MANUFACTURED PARTS/COMPONENTS'
# #                     when '8' then '8 - AXLES/SUSPENSIONS'
# #                     when '9' then '9 - FLOORING/LUMBER'
# #                     when '10' then '10 - LASER KITS'
# #                     when '11' then '11 - TIRES/WHEELS'
# #                     when '12' then '12 - MARKETING MATERIAL'
# #                     when '13' then '13 - PRECUT ALUMINUM'
# #                     when '14' then '14 - STEEL/ALUM PLATE'
# #                     when '15' then '15 - CYLINDERS'
# #                     when '21' then '21 - OBSOLETE PURCHASED PARTS'
# #                     when '22' then '22 - OBSOLETE FULL LENGTH STEEL'
# #                     when '23' then '23 - OBSOLETE STEEL KITS'
# #                     when '24' then '24 - OBSOLETE PRECUT STEEL'
# #                     when '25' then '25 - OBSOLETE PAINT/PAINT PRODUCTS'
# #                     when '26' then '26 - OBSOLETE CONSUMABLES'
# #                     when '27' then '27 - OBSOLETE MANUFACTURED PARTS/COMPONENTS'
# #                     when '28' then '28 - OBSOLETE AXLES/SUSPENSIONS'
# #                     when '29' then '29 - OBSOLETE FLOORING/LUMBER'
# #                     when '30' then '30 - OBSOLETE LASER KITS'
# #                     when '31' then '31 - OBSOLETE TIRES/WHEELS'
# #                     when '32' then '32 - OBSOLETE MARKETING MATERIAL'
# #                     when '33' then '33 - OBSOLETE PRECUT ALUMINUM'
# #                     when '34' then '34 - OBSOLETE STEEL/ALUM PLATE'
# #                     when '55' then '55 - EXCESS LB AND HR'
# #                     else cast(CycleCount as varchar) + ' - UNCLASSIFIED' end as [CycleCountDescription]
# #     , InvMaster.ProductClass
# #     , InvWarehouse.QtyOnHand
# #     , InvWarehouse.UnitCost
# #     , (InvWarehouse.QtyOnHand * InvWarehouse.UnitCost) as [ValueOnHand]
# # into
# #     #InvData
# # FROM
# #     SysproCompanyA.dbo.InvWarehouse WITH (NOLOCK)
# # INNER JOIN
# #     SysproCompanyA.dbo.InvMaster WITH (NOLOCK)
# # ON
# #     InvWarehouse.StockCode = InvMaster.StockCode
# # LEFT OUTER JOIN
# #     (
# #         select StockCode
# #             , sum(DemandQty) as [NetDemandQty]
# #         FROM
# #             SysproCompanyA.dbo.MrpRequirement with (nolock)
# #         GROUP by
# #             StockCode
# #     ) as subMRPReqDemandSumCheck
# # ON
# #     InvWarehouse.StockCode = subMRPReqDemandSumCheck.StockCode
# # WHERE
# #     (
# #         InvMaster.WarehouseToUse NOT IN ('03', '99')
# #         OR InvMaster.WarehouseToUse IS NULL
# #     )
# #     AND InvWarehouse.QtyOnHand <> 0
# #     and (
# #         subMRPReqDemandSumCheck.NetDemandQty = 0
# #         or subMRPReqDemandSumCheck.NetDemandQty is null
# #     )
# #     """).strip())
# #     sql1 = casify("""
# # select 'Details' as [DatasetType]
# #     , StockCode
# #     , Warehouse
# #     , WarehouseToUse
# #     , CycleCount
# #     , CycleCountDescription
# #     , ProductClass
# #     , QtyOnHand
# #     , UnitCost
# #     , ValueOnHand
# #     , case when ParentPartsCount = 0 and CycleCount = 6 then 'SHOP SUPPLIES'
# #         when ParentPartsCount = 0 and CycleCount <> 6 then 'UNKNOWN'
# #         when ParentPartsCount > 1 then 'MULTIPLE BOMS'
# #         else ParentParts
# #         end as [ParentPart]
# #     , case when ParentPartsCount = 0 and CycleCount = 6 then 'SHOP SUPPLIES'
# #         when ParentPartsCount = 0 and CycleCount <> 6 then 'UNKNOWN'
# #         when ParentPartsCount > 1 then ParentParts
# #         end as [ParentPartsArray (IF MULTIPLE)]
# #     , case when ModelNosCount = 0 and CycleCount = 6 then 'SHOP SUPPLIES'
# #         when ModelNosCount = 0 and CycleCount <> 6 then 'UNKNOWN'
# #         when ModelNosCount > 1 then 'MULTIPLE MODELS'
# #         else ModelNos
# #         end as [ModelNo]
# #     , case when ModelNosCount = 0 and CycleCount = 6 then 'SHOP SUPPLIES'
# #         when ModelNosCount = 0 and CycleCount <> 6 then 'UNKNOWN'
# #         when ModelNosCount > 1 then ModelNos
# #         end as [ModelNosArray (IF MULTIPLE)]
# #     , case when ClassesCount = 0 and CycleCount = 6 then 'SHOP SUPPLIES'
# #         when ClassesCount = 0 and CycleCount <> 6 then 'UNKNOWN'
# #         when ClassesCount > 1 then 'MULTIPLE CLASSES'
# #         else Classes
# #         end as [Class]
# #     , case when ClassesCount = 0 and CycleCount = 6 then 'SHOP SUPPLIES'
# #         when ClassesCount = 0 and CycleCount <> 6 then 'UNKNOWN'
# #         when ClassesCount > 1 then Classes
# #         end as [ClasssArray (IF MULTIPLE)]
# #     , case when GroupingsCount = 0 and CycleCount = 6 then 'SHOP SUPPLIES'
# #         when GroupingsCount = 0 and CycleCount <> 6 then 'UNKNOWN'
# #         when GroupingsCount > 1 then 'MULTIPLE GROUPINGS'
# #         else Groupings
# #         end as [Grouping]
# #     , case when GroupingsCount = 0 and CycleCount = 6 then 'SHOP SUPPLIES'
# #         when GroupingsCount = 0 and CycleCount <> 6 then 'UNKNOWN'
# #         when GroupingsCount > 1 then Groupings
# #         end as [GroupingsArray (IF MULTIPLE)]
# # FROM
# # (
# #     select StockCode
# #         , Warehouse
# #         , WarehouseToUse
# #         , CycleCount
# #         , [CycleCountDescription]
# #         , ProductClass
# #         , QtyOnHand
# #         , UnitCost
# #         , [ValueOnHand]
# #         , (
# #                 SELECT COUNT(*)
# #                 FROM
# #                     #BomModelData as BomModelData
# #                 WHERE
# #                     BomModelData.Component = InvData.StockCode
# #                     and BomModelData.Warehouse = InvData.Warehouse
# #         ) AS [ParentPartsCount]
# #         , ltrim(
# #             STUFF(
# #                 (
# #                     select ', ' + BomModelData.ParentPart
# #                     FROM
# #                         #BomModelData as BomModelData
# #                     WHERE
# #                         BomModelData.Component = InvData.StockCode
# #                         and BomModelData.Warehouse = InvData.Warehouse
# #                 for xml path(''))
# #                 , 1, 1, ''
# #             )
# #         ) as [ParentParts]
# #         , (
# #             select count(distinct BomModelData.[Model No])
# #                     FROM
# #                         #BomModelData as BomModelData
# #                     WHERE
# #                         BomModelData.Component = InvData.StockCode
# #                         and BomModelData.Warehouse = InvData.Warehouse
# #         ) as [ModelNosCount]
# #         , ltrim(
# #             STUFF(
# #                 (
# #                     select distinct ', ' + BomModelData.[Model No]
# #                     FROM
# #                         #BomModelData as BomModelData
# #                     WHERE
# #                         BomModelData.Component = InvData.StockCode
# #                         and BomModelData.Warehouse = InvData.Warehouse
# #                 for xml path(''))
# #                 , 1, 1, ''
# #                 )
# #         ) as [ModelNos]
# #         , (
# #             select count(distinct BomModelData.[Class])
# #                     FROM
# #                         #BomModelData as BomModelData
# #                     WHERE
# #                         BomModelData.Component = InvData.StockCode
# #                         and BomModelData.Warehouse = InvData.Warehouse
# #         ) as [ClassesCount]
# #         , ltrim(
# #             STUFF(
# #                 (
# #                     select distinct ', ' + BomModelData.[Class]
# #                     FROM
# #                         #BomModelData as BomModelData
# #                     WHERE
# #                         BomModelData.Component = InvData.StockCode
# #                         and BomModelData.Warehouse = InvData.Warehouse
# #                 for xml path(''))
# #                 , 1, 1, ''
# #                 )
# #         ) as [Classes]
# #         , (
# #             select count(distinct BomModelData.[Grouping])
# #                     FROM
# #                         #BomModelData as BomModelData
# #                     WHERE
# #                         BomModelData.Component = InvData.StockCode
# #                         and BomModelData.Warehouse = InvData.Warehouse
# #         ) as [GroupingsCount]
# #         , ltrim(
# #             STUFF(
# #                 (
# #                     select distinct ', ' + BomModelData.[Grouping]
# #                     FROM
# #                         #BomModelData as BomModelData
# #                     WHERE
# #                         BomModelData.Component = InvData.StockCode
# #                         and BomModelData.Warehouse = InvData.Warehouse
# #                 for xml path(''))
# #                 , 1, 1, ''
# #                 )
# #         ) as [Groupings]
# #     FROM
# #         #InvData as InvData
# # ) as main;
# #     """).strip()
# #     sql2 = casify("""
# # -- Drop temp table once done with select statements
# # drop table #BomModelData;
# # drop table #InvData;
# #     """).strip()
# #     # sql = casify(("""EXEC [BWSdb].[dbo].[sp_INVFCST_ValuationOnHand20250306]""").strip())
# #     connection_data = {
# #         # "sql": sql,
# #         "database": "BWSdb",
# #         "uid": CREDS_BWS["uid"],
# #         "pwd": CREDS_BWS["pwd"]
# #     }
# #
# #     r0 = connect(sql=sql0, **connection_data, returns_records=False)
# #     r1 = connect(sql=sql1, **connection_data, returns_records=True)
# #     r2 = connect(sql=sql2, ** connection_data, returns_records=False)
# #
# #     return r1
#     sql = ("""
# 	IF OBJECT_ID('tempdb..##BomModelData') IS NOT NULL BEGIN
# 		DROP TABLE ##BomModelData
# 	END;
# 	IF OBJECT_ID('tempdb..##InvData') IS NOT NULL BEGIN
# 		DROP TABLE ##InvData
# 	END;
#
# 	-- Dump BOM and Access model data into temp table for faster processing
#
# 	SELECT BomStructure.Component
# 		, CASE WHEN len(BomStructure.Warehouse) = 0 THEN InvMaster.WarehouseToUse
# 				ELSE BomStructure.Warehouse
# 				END AS Warehouse
# 		, BomStructure.ParentPart
# 		, CASE WHEN AccessBaseModel.[Model No] IS NOT NULL AND AccessQuoteModel.[Model No] IS NULL THEN AccessBaseModel.[Model No]
# 				WHEN AccessBaseModel.[Model No] IS NULL AND AccessQuoteModel.[Model No] IS NOT NULL THEN AccessQuoteModel.[Model No]
# 				END AS [Model No]
# 		, CASE WHEN AccessBaseModel.[Model No] IS NOT NULL AND AccessQuoteModel.[Model No] IS NULL THEN AccessBaseModel.[Class]
# 				WHEN AccessBaseModel.[Model No] IS NULL AND AccessQuoteModel.[Model No] IS NOT NULL THEN AccessQuoteModel.[Class]
# 				END AS [Class]
# 		, CASE WHEN AccessBaseModel.[Model No] IS NOT NULL AND AccessQuoteModel.[Model No] IS NULL THEN AccessBaseModel.[Grouping]
# 				WHEN AccessBaseModel.[Model No] IS NULL AND AccessQuoteModel.[Model No] IS NOT NULL THEN AccessQuoteModel.[Grouping]
# 				END AS [Grouping]
# 	INTO
# 		##BomModelData
# 	FROM
# 		SysproCompanyA.dbo.BomStructure WITH (nolock)
# 	INNER JOIN
# 		SysproCompanyA.dbo.InvMaster WITH (nolock)
# 	ON
# 		BomStructure.Component = InvMaster.StockCode
# 	LEFT OUTER JOIN
# 		(
# 			SELECT CLASS
# 				, [Model No]
# 				, [Grouping]
# 				, [Top Level Part# (SYSPRO 8)]
# 			FROM
# 				BWSdb.dbo.Products WITH (NOLOCK)
# 			WHERE
# 				[Non-Current] = 0
# 				AND [Proposed] = 0
# 		) AS AccessBaseModel
# 	ON
# 		BomStructure.ParentPart = AccessBaseModel.[Top Level Part# (SYSPRO 8)] COLLATE Latin1_General_BIN
# 	LEFT OUTER JOIN
# 		BWSdb.dbo.Orders WITH (NOLOCK)
# 	ON
# 		RIGHT(BomStructure.ParentPart, 6) = '-' + CAST(Orders.[Quote#] AS VARCHAR)
# 	LEFT OUTER JOIN
# 		(
# 			SELECT IDTrailer
# 				, CLASS
# 				, [Model No]
# 				, [Grouping]
# 				, [Top Level Part# (SYSPRO 8)]
# 			FROM
# 				BWSdb.dbo.Products WITH (NOLOCK)
# 			WHERE
# 				[Non-Current] = 0
# 				AND [Proposed] = 0
# 		) AS AccessQuoteModel
# 	ON
# 		Orders.ProductID = AccessQuoteModel.IDTrailer
# 		OR Orders.[Model No] = AccessQuoteModel.[Model No]
# 	;
#
# 	-- Dump Inventory values into temp table for faster processing
# 	SELECT InvMaster.StockCode
# 		, InvWarehouse.Warehouse
# 		, InvMaster.WarehouseToUse
# 		, InvMaster.CycleCount
# 		, CASE CycleCount WHEN '1' THEN '1 - PURCHASED'
# 						WHEN '2' THEN '2 - FULL LENGTH STEEL/ALUMINUM'
# 						WHEN '3' THEN '3 - STEEL KITS'
# 						WHEN '4' THEN '4 - PRECUT STEEL'
# 						WHEN '5' THEN '5 - PAINT/PAINT PRODUCTS'
# 						WHEN '6' THEN '6 - CONSUMABLES'
# 						WHEN '7' THEN '7 - MANUFACTURED PARTS/COMPONENTS'
# 						WHEN '8' THEN '8 - AXLES/SUSPENSIONS'
# 						WHEN '9' THEN '9 - FLOORING/LUMBER'
# 						WHEN '10' THEN '10 - LASER KITS'
# 						WHEN '11' THEN '11 - TIRES/WHEELS'
# 						WHEN '12' THEN '12 - MARKETING MATERIAL'
# 						WHEN '13' THEN '13 - PRECUT ALUMINUM'
# 						WHEN '14' THEN '14 - STEEL/ALUM PLATE'
# 						WHEN '15' THEN '15 - CYLINDERS'
# 						WHEN '21' THEN '21 - OBSOLETE PURCHASED PARTS'
# 						WHEN '22' THEN '22 - OBSOLETE FULL LENGTH STEEL'
# 						WHEN '23' THEN '23 - OBSOLETE STEEL KITS'
# 						WHEN '24' THEN '24 - OBSOLETE PRECUT STEEL'
# 						WHEN '25' THEN '25 - OBSOLETE PAINT/PAINT PRODUCTS'
# 						WHEN '26' THEN '26 - OBSOLETE CONSUMABLES'
# 						WHEN '27' THEN '27 - OBSOLETE MANUFACTURED PARTS/COMPONENTS'
# 						WHEN '28' THEN '28 - OBSOLETE AXLES/SUSPENSIONS'
# 						WHEN '29' THEN '29 - OBSOLETE FLOORING/LUMBER'
# 						WHEN '30' THEN '30 - OBSOLETE LASER KITS'
# 						WHEN '31' THEN '31 - OBSOLETE TIRES/WHEELS'
# 						WHEN '32' THEN '32 - OBSOLETE MARKETING MATERIAL'
# 						WHEN '33' THEN '33 - OBSOLETE PRECUT ALUMINUM'
# 						WHEN '34' THEN '34 - OBSOLETE STEEL/ALUM PLATE'
# 						WHEN '55' THEN '55 - EXCESS LB AND HR'
# 						ELSE cast(CycleCount AS varchar) + ' - UNCLASSIFIED' END AS [CycleCountDescription]
# 		, InvMaster.ProductClass
# 		, InvWarehouse.QtyOnHand
# 		, InvWarehouse.UnitCost
# 		, (InvWarehouse.QtyOnHand * InvWarehouse.UnitCost) AS [ValueOnHand]
# 	INTO
# 		##InvData
# 	FROM
# 		SysproCompanyA.dbo.InvWarehouse WITH (NOLOCK)
# 	INNER JOIN
# 		SysproCompanyA.dbo.InvMaster WITH (NOLOCK)
# 	ON
# 		InvWarehouse.StockCode = InvMaster.StockCode
# 	LEFT OUTER JOIN
# 		(
# 			SELECT StockCode
# 				, sum(DemandQty) AS [NetDemandQty]
# 			FROM
# 				SysproCompanyA.dbo.MrpRequirement WITH (nolock)
# 			GROUP BY
# 				StockCode
# 		) AS subMRPReqDemandSumCheck
# 	ON
# 		InvWarehouse.StockCode = subMRPReqDemandSumCheck.StockCode
# 	WHERE
# 		(
# 			InvMaster.WarehouseToUse NOT IN ('03', '99')
# 			OR InvMaster.WarehouseToUse IS NULL
# 		)
# 		AND InvWarehouse.QtyOnHand <> 0
# 		AND (
# 			subMRPReqDemandSumCheck.NetDemandQty = 0
# 			OR subMRPReqDemandSumCheck.NetDemandQty IS NULL
# 		)
# 	;
#
# 	SELECT
# 		'Details' AS [DatasetType]
# 		, StockCode
# 		, Warehouse
# 		, WarehouseToUse
# 		, CycleCount
# 		, CycleCountDescription
# 		, ProductClass
# 		, QtyOnHand
# 		, UnitCost
# 		, ValueOnHand
# 		, CASE WHEN ParentPartsCount = 0 AND CycleCount = 6 THEN 'SHOP SUPPLIES'
# 			WHEN ParentPartsCount = 0 AND CycleCount <> 6 THEN 'UNKNOWN'
# 			WHEN ParentPartsCount > 1 THEN 'MULTIPLE BOMS'
# 			ELSE ParentParts
# 			END AS [ParentPart]
# 		, CASE WHEN ParentPartsCount = 0 AND CycleCount = 6 THEN 'SHOP SUPPLIES'
# 			WHEN ParentPartsCount = 0 AND CycleCount <> 6 THEN 'UNKNOWN'
# 			WHEN ParentPartsCount > 1 THEN ParentParts
# 			END AS [ParentPartsArray (IF MULTIPLE)]
# 		, CASE WHEN ModelNosCount = 0 AND CycleCount = 6 THEN 'SHOP SUPPLIES'
# 			WHEN ModelNosCount = 0 AND CycleCount <> 6 THEN 'UNKNOWN'
# 			WHEN ModelNosCount > 1 THEN 'MULTIPLE MODELS'
# 			ELSE ModelNos
# 			END AS [ModelNo]
# 		, CASE WHEN ModelNosCount = 0 AND CycleCount = 6 THEN 'SHOP SUPPLIES'
# 			WHEN ModelNosCount = 0 AND CycleCount <> 6 THEN 'UNKNOWN'
# 			WHEN ModelNosCount > 1 THEN ModelNos
# 			END AS [ModelNosArray (IF MULTIPLE)]
# 		, CASE WHEN ClassesCount = 0 AND CycleCount = 6 THEN 'SHOP SUPPLIES'
# 			WHEN ClassesCount = 0 AND CycleCount <> 6 THEN 'UNKNOWN'
# 			WHEN ClassesCount > 1 THEN 'MULTIPLE CLASSES'
# 			ELSE Classes
# 			END AS [Class]
# 		, CASE WHEN ClassesCount = 0 AND CycleCount = 6 THEN 'SHOP SUPPLIES'
# 			WHEN ClassesCount = 0 AND CycleCount <> 6 THEN 'UNKNOWN'
# 			WHEN ClassesCount > 1 THEN Classes
# 			END AS [ClasssArray (IF MULTIPLE)]
# 		, CASE WHEN GroupingsCount = 0 AND CycleCount = 6 THEN 'SHOP SUPPLIES'
# 			WHEN GroupingsCount = 0 AND CycleCount <> 6 THEN 'UNKNOWN'
# 			WHEN GroupingsCount > 1 THEN 'MULTIPLE GROUPINGS'
# 			ELSE Groupings
# 			END AS [Grouping]
# 		, CASE WHEN GroupingsCount = 0 AND CycleCount = 6 THEN 'SHOP SUPPLIES'
# 			WHEN GroupingsCount = 0 AND CycleCount <> 6 THEN 'UNKNOWN'
# 			WHEN GroupingsCount > 1 THEN Groupings
# 			END AS [GroupingsArray (IF MULTIPLE)]
# 	FROM
# 	(
# 		SELECT StockCode
# 			, Warehouse
# 			, WarehouseToUse
# 			, CycleCount
# 			, [CycleCountDescription]
# 			, ProductClass
# 			, QtyOnHand
# 			, UnitCost
# 			, [ValueOnHand]
# 			, (
# 					SELECT COUNT(*)
# 					FROM
# 						##BomModelData AS BomModelData
# 					WHERE
# 						BomModelData.Component = InvData.StockCode
# 						AND BomModelData.Warehouse = InvData.Warehouse
# 			) AS [ParentPartsCount]
# 			, ltrim(
# 				STUFF(
# 					(
# 						SELECT ', ' + BomModelData.ParentPart
# 						FROM
# 							##BomModelData AS BomModelData
# 						WHERE
# 							BomModelData.Component = InvData.StockCode
# 							AND BomModelData.Warehouse = InvData.Warehouse
# 					FOR XML path(''))
# 					, 1, 1, ''
# 				)
# 			) AS [ParentParts]
# 			, (
# 				SELECT count(DISTINCT BomModelData.[Model No])
# 						FROM
# 							##BomModelData AS BomModelData
# 						WHERE
# 							BomModelData.Component = InvData.StockCode
# 							AND BomModelData.Warehouse = InvData.Warehouse
# 			) AS [ModelNosCount]
# 			, ltrim(
# 				STUFF(
# 					(
# 						SELECT DISTINCT ', ' + BomModelData.[Model No]
# 						FROM
# 							##BomModelData AS BomModelData
# 						WHERE
# 							BomModelData.Component = InvData.StockCode
# 							AND BomModelData.Warehouse = InvData.Warehouse
# 					FOR XML path(''))
# 					, 1, 1, ''
# 					)
# 			) AS [ModelNos]
# 			, (
# 				SELECT count(DISTINCT BomModelData.[Class])
# 						FROM
# 							##BomModelData AS BomModelData
# 						WHERE
# 							BomModelData.Component = InvData.StockCode
# 							AND BomModelData.Warehouse = InvData.Warehouse
# 			) AS [ClassesCount]
# 			, ltrim(
# 				STUFF(
# 					(
# 						SELECT DISTINCT ', ' + BomModelData.[Class]
# 						FROM
# 							##BomModelData AS BomModelData
# 						WHERE
# 							BomModelData.Component = InvData.StockCode
# 							AND BomModelData.Warehouse = InvData.Warehouse
# 					FOR XML path(''))
# 					, 1, 1, ''
# 					)
# 			) AS [Classes]
# 			, (
# 				SELECT count(DISTINCT BomModelData.[Grouping])
# 						FROM
# 							##BomModelData AS BomModelData
# 						WHERE
# 							BomModelData.Component = InvData.StockCode
# 							AND BomModelData.Warehouse = InvData.Warehouse
# 			) AS [GroupingsCount]
# 			, ltrim(
# 				STUFF(
# 					(
# 						SELECT DISTINCT ', ' + BomModelData.[Grouping]
# 						FROM
# 							##BomModelData AS BomModelData
# 						WHERE
# 							BomModelData.Component = InvData.StockCode
# 							AND BomModelData.Warehouse = InvData.Warehouse
# 					FOR XML path(''))
# 					, 1, 1, ''
# 					)
# 			) AS [Groupings]
# 		FROM
# 			##InvData AS InvData
# 	) AS main
# 	;
#     """).strip()
#     sql = "EXEC [BWSdb].[dbo].[sp_INVFCST_ValuationOnHand20250306]"
    sql = casify("""SET NOCOUNT ON;

	IF OBJECT_ID('tempdb..##BomModelData') IS NOT NULL BEGIN
		DROP TABLE ##BomModelData
	END;
	IF OBJECT_ID('tempdb..##InvData') IS NOT NULL BEGIN
		DROP TABLE ##InvData
	END;

	-- Dump BOM and Access model data into temp table for faster processing

	SELECT BomStructure.Component
		, CASE WHEN len(BomStructure.Warehouse) = 0 THEN InvMaster.WarehouseToUse
				ELSE BomStructure.Warehouse
				END AS Warehouse
		, BomStructure.ParentPart
		, CASE WHEN AccessBaseModel.[Model No] IS NOT NULL AND AccessQuoteModel.[Model No] IS NULL THEN AccessBaseModel.[Model No]
				WHEN AccessBaseModel.[Model No] IS NULL AND AccessQuoteModel.[Model No] IS NOT NULL THEN AccessQuoteModel.[Model No]
				END AS [Model No]
		, CASE WHEN AccessBaseModel.[Model No] IS NOT NULL AND AccessQuoteModel.[Model No] IS NULL THEN AccessBaseModel.[Class]
				WHEN AccessBaseModel.[Model No] IS NULL AND AccessQuoteModel.[Model No] IS NOT NULL THEN AccessQuoteModel.[Class]
				END AS [Class]
		, CASE WHEN AccessBaseModel.[Model No] IS NOT NULL AND AccessQuoteModel.[Model No] IS NULL THEN AccessBaseModel.[Grouping]
				WHEN AccessBaseModel.[Model No] IS NULL AND AccessQuoteModel.[Model No] IS NOT NULL THEN AccessQuoteModel.[Grouping]
				END AS [Grouping]
	INTO
		##BomModelData
	FROM
		SysproCompanyA.dbo.BomStructure WITH (nolock)
	INNER JOIN
		SysproCompanyA.dbo.InvMaster WITH (nolock)
	ON
		BomStructure.Component = InvMaster.StockCode
	LEFT OUTER JOIN
		(
			SELECT CLASS
				, [Model No]
				, [Grouping]
				, [Top Level Part# (SYSPRO 8)]
			FROM
				BWSdb.dbo.Products WITH (NOLOCK)
			WHERE
				[Non-Current] = 0
				AND [Proposed] = 0
		) AS AccessBaseModel
	ON
		BomStructure.ParentPart = AccessBaseModel.[Top Level Part# (SYSPRO 8)] COLLATE Latin1_General_BIN
	LEFT OUTER JOIN
		BWSdb.dbo.Orders WITH (NOLOCK)
	ON
		RIGHT(BomStructure.ParentPart, 6) = '-' + CAST(Orders.[Quote#] AS VARCHAR)
	LEFT OUTER JOIN
		(
			SELECT IDTrailer
				, CLASS
				, [Model No]
				, [Grouping]
				, [Top Level Part# (SYSPRO 8)]
			FROM
				BWSdb.dbo.Products WITH (NOLOCK)
			WHERE
				[Non-Current] = 0
				AND [Proposed] = 0
		) AS AccessQuoteModel
	ON
		Orders.ProductID = AccessQuoteModel.IDTrailer
		OR Orders.[Model No] = AccessQuoteModel.[Model No]
	;

	-- Dump Inventory values into temp table for faster processing
	SELECT InvMaster.StockCode
		, InvWarehouse.Warehouse
		, InvMaster.WarehouseToUse
		, InvMaster.CycleCount
		, CASE CycleCount WHEN '1' THEN '1 - PURCHASED'
						WHEN '2' THEN '2 - FULL LENGTH STEEL/ALUMINUM'
						WHEN '3' THEN '3 - STEEL KITS'
						WHEN '4' THEN '4 - PRECUT STEEL'
						WHEN '5' THEN '5 - PAINT/PAINT PRODUCTS'
						WHEN '6' THEN '6 - CONSUMABLES'
						WHEN '7' THEN '7 - MANUFACTURED PARTS/COMPONENTS'
						WHEN '8' THEN '8 - AXLES/SUSPENSIONS'
						WHEN '9' THEN '9 - FLOORING/LUMBER'
						WHEN '10' THEN '10 - LASER KITS'
						WHEN '11' THEN '11 - TIRES/WHEELS'
						WHEN '12' THEN '12 - MARKETING MATERIAL'
						WHEN '13' THEN '13 - PRECUT ALUMINUM'
						WHEN '14' THEN '14 - STEEL/ALUM PLATE'
						WHEN '15' THEN '15 - CYLINDERS'
						WHEN '21' THEN '21 - OBSOLETE PURCHASED PARTS'
						WHEN '22' THEN '22 - OBSOLETE FULL LENGTH STEEL'
						WHEN '23' THEN '23 - OBSOLETE STEEL KITS'
						WHEN '24' THEN '24 - OBSOLETE PRECUT STEEL'
						WHEN '25' THEN '25 - OBSOLETE PAINT/PAINT PRODUCTS'
						WHEN '26' THEN '26 - OBSOLETE CONSUMABLES'
						WHEN '27' THEN '27 - OBSOLETE MANUFACTURED PARTS/COMPONENTS'
						WHEN '28' THEN '28 - OBSOLETE AXLES/SUSPENSIONS'
						WHEN '29' THEN '29 - OBSOLETE FLOORING/LUMBER'
						WHEN '30' THEN '30 - OBSOLETE LASER KITS'
						WHEN '31' THEN '31 - OBSOLETE TIRES/WHEELS'
						WHEN '32' THEN '32 - OBSOLETE MARKETING MATERIAL'
						WHEN '33' THEN '33 - OBSOLETE PRECUT ALUMINUM'
						WHEN '34' THEN '34 - OBSOLETE STEEL/ALUM PLATE'
						WHEN '55' THEN '55 - EXCESS LB AND HR'
						ELSE cast(CycleCount AS varchar) + ' - UNCLASSIFIED' END AS [CycleCountDescription]
		, InvMaster.ProductClass
		, InvWarehouse.QtyOnHand
		, InvWarehouse.UnitCost
		, (InvWarehouse.QtyOnHand * InvWarehouse.UnitCost) AS [ValueOnHand]
	INTO
		##InvData
	FROM
		SysproCompanyA.dbo.InvWarehouse WITH (NOLOCK)
	INNER JOIN
		SysproCompanyA.dbo.InvMaster WITH (NOLOCK)
	ON
		InvWarehouse.StockCode = InvMaster.StockCode
	LEFT OUTER JOIN
		(
			SELECT StockCode
				, sum(DemandQty) AS [NetDemandQty]
			FROM
				SysproCompanyA.dbo.MrpRequirement WITH (nolock)
			GROUP BY
				StockCode
		) AS subMRPReqDemandSumCheck
	ON
		InvWarehouse.StockCode = subMRPReqDemandSumCheck.StockCode
	WHERE
		(
			InvMaster.WarehouseToUse NOT IN ('03', '99')
			OR InvMaster.WarehouseToUse IS NULL
		)
		AND InvWarehouse.QtyOnHand <> 0
		/*AND (
			ISNULL([subMRPReqDemandSumCheck].[NetDemandQty], 0) = 0
		)*/
	;

	SELECT 
		'Details' AS [DatasetType]
		, StockCode
		, Warehouse
		, WarehouseToUse
		, CycleCount
		, CycleCountDescription
		, ProductClass
		, QtyOnHand
		, UnitCost
		, ValueOnHand
		, CASE WHEN ParentPartsCount = 0 AND CycleCount = 6 THEN 'SHOP SUPPLIES'
			WHEN ParentPartsCount = 0 AND CycleCount <> 6 THEN 'UNKNOWN'
			WHEN ParentPartsCount > 1 THEN 'MULTIPLE BOMS'
			ELSE ParentParts
			END AS [ParentPart]
		, CASE WHEN ParentPartsCount = 0 AND CycleCount = 6 THEN 'SHOP SUPPLIES'
			WHEN ParentPartsCount = 0 AND CycleCount <> 6 THEN 'UNKNOWN'
			WHEN ParentPartsCount > 1 THEN ParentParts
			END AS [ParentPartsArray (IF MULTIPLE)]
		, CASE WHEN ModelNosCount = 0 AND CycleCount = 6 THEN 'SHOP SUPPLIES'
			WHEN ModelNosCount = 0 AND CycleCount <> 6 THEN 'UNKNOWN'
			WHEN ModelNosCount > 1 THEN 'MULTIPLE MODELS'
			ELSE ModelNos
			END AS [ModelNo]
		, CASE WHEN ModelNosCount = 0 AND CycleCount = 6 THEN 'SHOP SUPPLIES'
			WHEN ModelNosCount = 0 AND CycleCount <> 6 THEN 'UNKNOWN'
			WHEN ModelNosCount > 1 THEN ModelNos
			END AS [ModelNosArray (IF MULTIPLE)]
		, CASE WHEN ClassesCount = 0 AND CycleCount = 6 THEN 'SHOP SUPPLIES'
			WHEN ClassesCount = 0 AND CycleCount <> 6 THEN 'UNKNOWN'
			WHEN ClassesCount > 1 THEN 'MULTIPLE CLASSES'
			ELSE Classes
			END AS [Class]
		, CASE WHEN ClassesCount = 0 AND CycleCount = 6 THEN 'SHOP SUPPLIES'
			WHEN ClassesCount = 0 AND CycleCount <> 6 THEN 'UNKNOWN'
			WHEN ClassesCount > 1 THEN Classes
			END AS [ClasssArray (IF MULTIPLE)]
		, CASE WHEN GroupingsCount = 0 AND CycleCount = 6 THEN 'SHOP SUPPLIES'
			WHEN GroupingsCount = 0 AND CycleCount <> 6 THEN 'UNKNOWN'
			WHEN GroupingsCount > 1 THEN 'MULTIPLE GROUPINGS'
			ELSE Groupings
			END AS [Grouping]
		, CASE WHEN GroupingsCount = 0 AND CycleCount = 6 THEN 'SHOP SUPPLIES'
			WHEN GroupingsCount = 0 AND CycleCount <> 6 THEN 'UNKNOWN'
			WHEN GroupingsCount > 1 THEN Groupings
			END AS [GroupingsArray (IF MULTIPLE)]
	FROM
	(
		SELECT StockCode
			, Warehouse
			, WarehouseToUse
			, CycleCount
			, [CycleCountDescription]
			, ProductClass
			, QtyOnHand
			, UnitCost
			, [ValueOnHand]
			, (
					SELECT COUNT(*)
					FROM
						##BomModelData AS BomModelData
					WHERE
						BomModelData.Component = InvData.StockCode
						AND BomModelData.Warehouse = InvData.Warehouse
			) AS [ParentPartsCount]
			, ltrim(
				STUFF(
					(
						SELECT ', ' + BomModelData.ParentPart
						FROM
							##BomModelData AS BomModelData
						WHERE
							BomModelData.Component = InvData.StockCode
							AND BomModelData.Warehouse = InvData.Warehouse
					FOR XML path(''))
					, 1, 1, ''
				)
			) AS [ParentParts]
			, (
				SELECT count(DISTINCT BomModelData.[Model No])
						FROM
							##BomModelData AS BomModelData
						WHERE
							BomModelData.Component = InvData.StockCode
							AND BomModelData.Warehouse = InvData.Warehouse
			) AS [ModelNosCount]
			, ltrim(
				STUFF(
					(
						SELECT DISTINCT ', ' + BomModelData.[Model No]
						FROM
							##BomModelData AS BomModelData
						WHERE
							BomModelData.Component = InvData.StockCode
							AND BomModelData.Warehouse = InvData.Warehouse
					FOR XML path(''))
					, 1, 1, ''
					)
			) AS [ModelNos]
			, (
				SELECT count(DISTINCT BomModelData.[Class])
						FROM
							##BomModelData AS BomModelData
						WHERE
							BomModelData.Component = InvData.StockCode
							AND BomModelData.Warehouse = InvData.Warehouse
			) AS [ClassesCount]
			, ltrim(
				STUFF(
					(
						SELECT DISTINCT ', ' + BomModelData.[Class]
						FROM
							##BomModelData AS BomModelData
						WHERE
							BomModelData.Component = InvData.StockCode
							AND BomModelData.Warehouse = InvData.Warehouse
					FOR XML path(''))
					, 1, 1, ''
					)
			) AS [Classes]
			, (
				SELECT count(DISTINCT BomModelData.[Grouping])
						FROM
							##BomModelData AS BomModelData
						WHERE
							BomModelData.Component = InvData.StockCode
							AND BomModelData.Warehouse = InvData.Warehouse
			) AS [GroupingsCount]
			, ltrim(
				STUFF(
					(
						SELECT DISTINCT ', ' + BomModelData.[Grouping]
						FROM
							##BomModelData AS BomModelData
						WHERE
							BomModelData.Component = InvData.StockCode
							AND BomModelData.Warehouse = InvData.Warehouse
					FOR XML path(''))
					, 1, 1, ''
					)
			) AS [Groupings]
		FROM
			##InvData AS InvData
	) AS main
	;
    """).strip()
    connection_data = {
        "sql": sql,
        "database": "BWSdb",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect_2(**connection_data, enable_mars=True)


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_inventory_subs() -> pd.DataFrame:
# #     sql = """
# # SELECT
# # 	[Src].*,
# # 	[JM].[Job],
# # 	[JM].[StockCode] AS [SubStockCode],
# # 	[JM].[StockDescription] AS [SubStockDescription],
# # 	[JM].[Warehouse] AS [SubWareHouse],
# # 	[JM].[QtyIssued] AS [SubQtyIssued],
# # 	[JM].[UnitCost] AS [SubUnitCost],
# # 	[JM].[ValueIssued] AS [SubValueIssued],
# # 	[JM].[ValueBilled] AS [SubValueBilled],
# # 	[JM].[AllocCompleted] AS [SubAllocCompleted],
# # 	[JP].[TrnDate],
# # 	[JM].[Bin] AS [SubBin],
# # 	[JM].[Warehouse] AS [SubWarehouse],
# # 	[JM].[OperationOffset] AS [SubOperationOffset],
# # 	([IW].[QtyOnHand] * [IW].[UnitCost]) AS [ValueOnHand]
# # FROM (
# # 	SELECT
# # 		ISNULL([PR].[Prod Date], [PR].[Prod Date2]) AS [DateProduction],
# # 		[O].[WO#],
# # 		[O].[Quote#],
# # 		[P].[Model No],
# # 		[D].[COMPANY NAME],
# # 		[JM].[StockCode],
# # 		[JM].[StockDescription],
# # 		[JM].[OperationOffset],
# # 		[JM].[QtyIssued],
# # 		[JM].[UnitCost],
# # 		[JM].[ValueIssued],
# # 		[JM].[ValueBilled],
# # 		(CASE WHEN ISNULL([JM].[AllocCompleted], 'N') = 'Y' THEN 1 ELSE 0 END) AS [Complete]
# # 	FROM
# # 		[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
# # 	INNER JOIN
# # 		[SysproCompanyA].[dbo].[WipJobAllMat] [JM] WITH (NOLOCK)
# # 	ON
# # 		CAST([O].[WO#] AS NVARCHAR(250)) = [JM].[Job]
# # 	INNER JOIN
# # 		[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
# # 	ON
# # 		[O].[ProductID] = [P].[IDTrailer]
# # 	INNER JOIN
# # 		[BWSdb].[dbo].[Dealers] [D] WITH (NOLOCK)
# # 	ON
# # 		[O].[DealerID] = [D].[ID]
# # 	LEFT JOIN
# # 		[BWSdb].[dbo].[Production] [PR] WITH (NOLOCK)
# # 	ON
# # 		[O].[WO#] = [PR].[WO#]
# # 	WHERE
# # 		([O].[WO#] IS NOT NULL)
# # 		AND ([O].[Decline/Rejected] = 4)
# # ) AS [Src]
# # INNER JOIN
# # 	[SysproCompanyA].[dbo].[WipJobAllMat] [JM] WITH (NOLOCK)
# # ON
# # 	([Src].[StockCode] = [JM].[Job])
# # 	AND ([Src].[OperationOffset] = [JM].[OperationOffset])
# # LEFT JOIN
# # 	[SysproCompanyA].[dbo].[WipJobPost] [JP] WITH (NOLOCK)
# # ON
# # 	(CAST([Src].[WO#] AS NVARCHAR(250)) = [JP].[Job])
# # 	AND ([JM].[StockCode] = [JP].[MStockCode])
# # LEFT JOIN
# # 	[SysproCompanyA].[dbo].[InvWarehouse] [IW] WITH (NOLOCK)
# # ON
# # 	[IW].[StockCode] = [JM].[StockCode]
# # ;
# # 	"""
#     sql = """
# SELECT
# 	[Src].*,
# 	[JM].[Job],
# 	[JM].[StockCode] AS [SubStockCode],
# 	[JM].[StockDescription] AS [SubStockDescription],
# 	[JM].[Warehouse] AS [SubWareHouse],
# 	[JM].[QtyIssued] AS [SubQtyIssued],
# 	[JM].[UnitCost] AS [SubUnitCost],
# 	[JM].[ValueIssued] AS [SubValueIssued],
# 	[JM].[ValueBilled] AS [SubValueBilled],
# 	[JM].[AllocCompleted] AS [SubAllocCompleted],
# 	[JP].[TrnDate],
# 	[JM].[Bin] AS [SubBin],
# 	[JM].[Warehouse] AS [SubWarehouse],
# 	[JM].[OperationOffset] AS [SubOperationOffset],
# 	([IW].[QtyOnHand] * [IW].[UnitCost]) AS [ValueOnHand]
# FROM (
# 	SELECT
# 		ISNULL([PR].[Prod Date], [PR].[Prod Date2]) AS [DateProduction],
# 		[O].[WO#],
# 		[O].[Quote#],
# 		[P].[Model No],
# 		[D].[COMPANY NAME],
# 		[JM].[StockCode],
# 		[JM].[StockDescription],
# 		[JM].[OperationOffset],
# 		[JM].[QtyIssued],
# 		[JM].[UnitCost],
# 		[JM].[ValueIssued],
# 		[JM].[ValueBilled],
# 		(CASE WHEN ISNULL([JM].[AllocCompleted], 'N') = 'Y' THEN 1 ELSE 0 END) AS [Complete]
# 	FROM
# 		[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
# 	INNER JOIN
# 		[SysproCompanyA].[dbo].[WipJobAllMat] [JM] WITH (NOLOCK)
# 	ON
# 		CAST([O].[WO#] AS NVARCHAR(250)) = [JM].[Job]
# 	INNER JOIN
# 		[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
# 	ON
# 		[O].[ProductID] = [P].[IDTrailer]
# 	INNER JOIN
# 		[BWSdb].[dbo].[Dealers] [D] WITH (NOLOCK)
# 	ON
# 		[O].[DealerID] = [D].[ID]
# 	LEFT JOIN
# 		[BWSdb].[dbo].[Production] [PR] WITH (NOLOCK)
# 	ON
# 		[O].[WO#] = [PR].[WO#]
# 	WHERE
# 		([O].[WO#] IS NOT NULL)
# 		AND ([O].[Decline/Rejected] = 4)
# ) AS [Src]
# LEFT JOIN
# 	[SysproCompanyA].[dbo].[WipJobAllMat] [JM] WITH (NOLOCK)
# ON
# 	([Src].[StockCode] = [JM].[Job])
# 	AND ([Src].[OperationOffset] = [JM].[OperationOffset])
# LEFT JOIN
# 	[SysproCompanyA].[dbo].[WipJobPost] [JP] WITH (NOLOCK)
# ON
# 	(CAST([Src].[WO#] AS NVARCHAR(250)) = [JP].[Job])
# 	AND ([JM].[StockCode] = [JP].[MStockCode])
# LEFT JOIN
# 	[SysproCompanyA].[dbo].[InvWarehouse] [IW] WITH (NOLOCK)
# ON
# 	[IW].[StockCode] = [JM].[StockCode]
# 	"""
    sql = """
SELECT
	[Src].*,
	[JM].[Job],
	[JM].[StockCode] AS [SubStockCode],
	[JM].[StockDescription] AS [SubStockDescription],
	[JM].[Warehouse] AS [SubWareHouse],
	[JM].[QtyIssued] AS [SubQtyIssued],
	[JM].[UnitCost] AS [SubUnitCost],
	[JM].[ValueIssued] AS [SubValueIssued],
	[JM].[ValueBilled] AS [SubValueBilled],
	[JM].[AllocCompleted] AS [SubAllocCompleted],
	[JP].[TrnDate],
	[JM].[Bin] AS [SubBin],
	[JM].[Warehouse] AS [SubWarehouse],
	[JM].[OperationOffset] AS [SubOperationOffset],
	[IM].[PartCategory] AS [SubPartCategory],
	([IW].[QtyOnHand] * [IW].[UnitCost]) AS [ValueOnHand]
FROM (
	SELECT
		ISNULL([PR].[Prod Date], [PR].[Prod Date2]) AS [DateProduction],
		[O].[WO#],
		[O].[Quote#],
		[P].[Model No],
		[D].[COMPANY NAME],
		[JM].[StockCode],
		[JM].[StockDescription],
		[JM].[OperationOffset],
		[JM].[QtyIssued],
		[JM].[UnitCost],
		[JM].[ValueIssued],
		[JM].[ValueBilled],
		[IM].[PartCategory],
		(CASE WHEN ISNULL([JM].[AllocCompleted], 'N') = 'Y' THEN 1 ELSE 0 END) AS [Complete]
	FROM
		[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
	INNER JOIN
		[SysproCompanyA].[dbo].[WipJobAllMat] [JM] WITH (NOLOCK)
	ON
		CAST([O].[WO#] AS NVARCHAR(250)) = [JM].[Job]
	INNER JOIN
		[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
	ON
		[O].[ProductID] = [P].[IDTrailer]
	INNER JOIN
		[BWSdb].[dbo].[Dealers] [D] WITH (NOLOCK)
	ON
		[O].[DealerID] = [D].[ID]
	LEFT JOIN
		[BWSdb].[dbo].[Production] [PR] WITH (NOLOCK)
	ON
		[O].[WO#] = [PR].[WO#]
	LEFT JOIN
		[SysproCompanyA].[dbo].[InvMaster] [IM] WITH (NOLOCK)
	ON
		[JM].[StockCode] = [IM].[StockCode]
	WHERE
		([O].[WO#] IS NOT NULL)
		AND ([O].[Decline/Rejected] = 4)
) AS [Src]
LEFT JOIN
	[SysproCompanyA].[dbo].[WipJobAllMat] [JM] WITH (NOLOCK)
ON
	([Src].[StockCode] = [JM].[Job])
	AND ([Src].[OperationOffset] = [JM].[OperationOffset])
LEFT JOIN
	[SysproCompanyA].[dbo].[WipJobPost] [JP] WITH (NOLOCK)
ON
	(CAST([Src].[WO#] AS NVARCHAR(250)) = [JP].[Job])
	AND ([JM].[StockCode] = [JP].[MStockCode])
LEFT JOIN
	[SysproCompanyA].[dbo].[InvWarehouse] [IW] WITH (NOLOCK)
ON
	[IW].[StockCode] = [JM].[StockCode]
LEFT JOIN
	[SysproCompanyA].[dbo].[InvMaster] [IM] WITH (NOLOCK)
ON
	[JM].[StockCode] = [IM].[StockCode]
	;
	"""
    connection_data = {
        "sql": sql,
        "database": "BWSdb",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect(**connection_data)


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_parts_subs_data_bws():
    sql_20250316 = ("""
SELECT
	[Src].*,
	[JM].[Job],
	[JM].[StockCode] AS [SubStockCode],
	[JM].[StockDescription] AS [SubStockDescription],
	[JM].[Warehouse] AS [SubWareHouse],
	[JM].[QtyIssued] AS [SubQtyIssued],
	[JM].[UnitCost] AS [SubUnitCost],
	[JM].[ValueIssued] AS [SubValueIssued],
	[JM].[ValueBilled] AS [SubValueBilled],
	[JM].[AllocCompleted] AS [SubAllocCompleted],
	[JP].[TrnDate]
FROM (
	SELECT
		ISNULL([PR].[Prod Date], [PR].[Prod Date2]) AS [DateProduction],
		[O].[WO#],
		[O].[Quote#],
		[P].[Model No],
		[D].[COMPANY NAME],
		[JM].[StockCode],
		[JM].[StockDescription],
		[JM].[OperationOffset],
		[JM].[QtyIssued],
		[JM].[UnitCost],
		[JM].[ValueIssued],
		[JM].[ValueBilled],
		(CASE WHEN ISNULL([JM].[AllocCompleted], 'N') = 'Y' THEN 1 ELSE 0 END) AS [Complete]
	FROM
		[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
	INNER JOIN
		[SysproCompanyA].[dbo].[WipJobAllMat] [JM] WITH (NOLOCK)
	ON
		CAST([O].[WO#] AS NVARCHAR(250)) = [JM].[Job]
	INNER JOIN
		[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
	ON
		[O].[ProductID] = [P].[IDTrailer]
	INNER JOIN
		[BWSdb].[dbo].[Dealers] [D] WITH (NOLOCK)
	ON
		[O].[DealerID] = [D].[ID]
	LEFT JOIN
		[BWSdb].[dbo].[Production] [PR] WITH (NOLOCK)
	ON
		[O].[WO#] = [PR].[WO#]
	WHERE
		([O].[WO#] IS NOT NULL)
		AND ([O].[Decline/Rejected] = 4)
) AS [Src]
INNER JOIN
	[SysproCompanyA].[dbo].[WipJobAllMat] [JM]
ON
	([Src].[StockCode] = [JM].[Job])
	AND ([Src].[OperationOffset] = [JM].[OperationOffset])
LEFT JOIN
	[SysproCompanyA].[dbo].[WipJobPost] [JP]
ON
	(CAST([Src].[WO#] AS NVARCHAR(250)) = [JP].[Job])
	AND ([JM].[StockCode] = [JP].[MStockCode])
        """).strip()
    sql_20250317 = ("""
SELECT
	[Src].*,
	[JM].[Job],
	[JM].[StockCode] AS [SubStockCode],
	[JM].[StockDescription] AS [SubStockDescription],
	[JM].[Warehouse] AS [SubWareHouse],
	[JM].[QtyIssued] AS [SubQtyIssued],
	[JM].[UnitCost] AS [SubUnitCost],
	[JM].[ValueIssued] AS [SubValueIssued],
	[JM].[ValueBilled] AS [SubValueBilled],
	[JM].[AllocCompleted] AS [SubAllocCompleted],
	[JP].[TrnDate],
	[IM].[WarehouseToUse] AS [SubWarehouseToUse],
	[IW].[DefaultBin] AS [SubDefaultBin]
FROM (
	SELECT
		ISNULL([PR].[Prod Date], [PR].[Prod Date2]) AS [DateProduction],
		[O].[WO#],
		[O].[Quote#],
		[P].[Model No],
		[D].[COMPANY NAME],
		[JM].[StockCode],
		[JM].[StockDescription],
		[JM].[OperationOffset],
		[JM].[QtyIssued],
		[JM].[UnitCost],
		[JM].[ValueIssued],
		[JM].[ValueBilled],
		(CASE WHEN ISNULL([JM].[AllocCompleted], 'N') = 'Y' THEN 1 ELSE 0 END) AS [Complete],
		[IM].[WarehouseToUse],
		[IW].[DefaultBin]
	FROM
		[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
	INNER JOIN
		[SysproCompanyA].[dbo].[WipJobAllMat] [JM] WITH (NOLOCK)
	ON
		CAST([O].[WO#] AS NVARCHAR(250)) = [JM].[Job]
	INNER JOIN
		[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
	ON
		[O].[ProductID] = [P].[IDTrailer]
	INNER JOIN
		[BWSdb].[dbo].[Dealers] [D] WITH (NOLOCK)
	ON
		[O].[DealerID] = [D].[ID]
	LEFT JOIN
		[BWSdb].[dbo].[Production] [PR] WITH (NOLOCK)
	ON
		[O].[WO#] = [PR].[WO#]
	LEFT JOIN
		[SysproCompanyA].[dbo].[InvMaster] [IM] WITH (NOLOCK)
	ON
		[JM].[StockCode] = [IM].[StockCode]
	LEFT JOIN
		[SysproCompanyA].[dbo].[InvWarehouse] [IW] WITH (NOLOCK)
	ON
		([IM].StockCode = [IW].StockCode)
		AND ([IM].[WarehouseToUse] = [IW].[Warehouse])
	WHERE
		([O].[WO#] IS NOT NULL)
		AND ([O].[Decline/Rejected] = 4)
) AS [Src]
INNER JOIN
	[SysproCompanyA].[dbo].[WipJobAllMat] [JM]
ON
	([Src].[StockCode] = [JM].[Job])
	AND ([Src].[OperationOffset] = [JM].[OperationOffset])
LEFT JOIN
	[SysproCompanyA].[dbo].[WipJobPost] [JP]
ON
	(CAST([Src].[WO#] AS NVARCHAR(250)) = [JP].[Job])
	AND ([JM].[StockCode] = [JP].[MStockCode])
LEFT JOIN
	[SysproCompanyA].[dbo].[InvMaster] [IM] WITH (NOLOCK)
ON
	[JM].[StockCode] = [IM].[StockCode]
LEFT JOIN
	[SysproCompanyA].[dbo].[InvWarehouse] [IW] WITH (NOLOCK)
ON
    ([IM].StockCode = [IW].StockCode)
    AND ([IM].[WarehouseToUse] = [IW].[Warehouse])
;
    """).strip()
    sql_20250318 = ("""SELECT
 [Src].*,
 [JM].[Job],
 [JM].[StockCode] AS [SubStockCode],
 [JM].[StockDescription] AS [SubStockDescription],
 [JM].[Warehouse] AS [SubWareHouse],
 [JM].[QtyIssued] AS [SubQtyIssued],
 [JM].[UnitCost] AS [SubUnitCost],
 [JM].[ValueIssued] AS [SubValueIssued],
 [JM].[ValueBilled] AS [SubValueBilled],
 [JM].[AllocCompleted] AS [SubAllocCompleted],
 [JP].[TrnDate],
 [IM].[WarehouseToUse] AS [SubWarehouseToUse],
 [IW].[DefaultBin] AS [SubDefaultBin],
    [Src].[PlannedStartDate],
    [WM].[JobDeliveryDate] as [SubJobDelivery/FinishDate],
    DATEDIFF(DAY, [Src].[PlannedStartDate], [WM].[JobDeliveryDate]) as [NumDaysDiff]
FROM (
 SELECT
  ISNULL([PR].[Prod Date], [PR].[Prod Date2]) AS [DateProduction],
  [O].[WO#],
  [O].[Quote#],
  [P].[Model No],
  [D].[COMPANY NAME],
  [JM].[StockCode],
  [JM].[StockDescription],
  [JM].[OperationOffset],
  [JM].[QtyIssued],
  [JM].[UnitCost],
  [JM].[ValueIssued],
  [JM].[ValueBilled],
  (CASE WHEN ISNULL([JM].[AllocCompleted], 'N') = 'Y' THEN 1 ELSE 0 END) AS [Complete],
  [IM].[WarehouseToUse],
  [IW].[DefaultBin],
        [JL].[PlannedStartDate]
 FROM
  [BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
 INNER JOIN
  [SysproCompanyA].[dbo].[WipJobAllMat] [JM] WITH (NOLOCK)
 ON
  CAST([O].[WO#] AS NVARCHAR(250)) = [JM].[Job]
 INNER JOIN
  [BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
 ON
  [O].[ProductID] = [P].[IDTrailer]
 INNER JOIN
  [BWSdb].[dbo].[Dealers] [D] WITH (NOLOCK)
 ON
  [O].[DealerID] = [D].[ID]
 LEFT JOIN
  [BWSdb].[dbo].[Production] [PR] WITH (NOLOCK)
 ON
  [O].[WO#] = [PR].[WO#]
 LEFT JOIN
  [SysproCompanyA].[dbo].[InvMaster] [IM] WITH (NOLOCK)
 ON
  [JM].[StockCode] = [IM].[StockCode]
 LEFT JOIN
  [SysproCompanyA].[dbo].[InvWarehouse] [IW] WITH (NOLOCK)
 ON
  ([IM].StockCode = [IW].StockCode)
  AND ([IM].[WarehouseToUse] = [IW].[Warehouse])
    LEFT JOIN
        [SysproCompanyA].[dbo].[WipJobAllLab] [JL] WITH (NOLOCK)
    ON
        [JM].Job = [JL].Job
        and [JM].OperationOffset = [JL].Operation
 WHERE
  ([O].[WO#] IS NOT NULL)
  AND ([O].[Decline/Rejected] = 4)
) AS [Src]
LEFT JOIN
    [SysproCompanyA].[dbo].[WipMaster] [WM]
ON
    ([Src].StockCode = [WM].StockCode)
INNER JOIN
 [SysproCompanyA].[dbo].[WipJobAllMat] [JM]
ON
    [WM].Job = [JM].Job
 -- ([Src].[StockCode] = [JM].[StockCode])
 -- AND ([Src].[OperationOffset] = [JM].[OperationOffset])
LEFT JOIN
 [SysproCompanyA].[dbo].[WipJobPost] [JP]
ON
    [WM].Job = [JP].Job
    and [WM].StockCode = [JP].MStockCode
 -- (CAST([Src].[WO#] AS NVARCHAR(250)) = [JP].[Job])
 -- AND ([JM].[StockCode] = [JP].[MStockCode])
LEFT JOIN
 [SysproCompanyA].[dbo].[InvMaster] [IM] WITH (NOLOCK)
ON
 [JM].[StockCode] = [IM].[StockCode]
LEFT JOIN
 [SysproCompanyA].[dbo].[InvWarehouse] [IW] WITH (NOLOCK)
ON
    ([IM].StockCode = [IW].StockCode)
    AND ([IM].[WarehouseToUse] = [IW].[Warehouse])
LEFT JOIN
    [SysproCompanyA].[dbo].[WipJobAllLab] [JL] WITH (NOLOCK)
ON
    [JM].Job = [JL].Job
    and [JM].OperationOffset = [JL].Operation
WHERE
    (
        [WM].JobClassification = 'SUB'
        or [WM].JobClassification is null
    )
    and [WM].ActCompleteDate is null
    and (
        DATEDIFF(DAY, [Src].[PlannedStartDate], [WM].[JobDeliveryDate]) between -30 and 0
        or DATEDIFF(DAY, [Src].[PlannedStartDate], [WM].[JobDeliveryDate]) is null
    )
	--AND (CAST([Src].[WO#] AS NVARCHAR(25)) = @j)
;
    """).strip()
    connection_data = {
        "sql": sql_20250318,
        "database": "bwsdb",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect(**connection_data)


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_parts_data_bws():
    sql_20250316 = ("""
SELECT
	ISNULL([PR].[Prod Date], [PR].[Prod Date2]) AS [DateProduction],
	[O].[WO#],
	[O].[Quote#],
	[P].[Model No],
	[D].[COMPANY NAME],
	[JM].[StockCode],
	[JM].[StockDescription],
	[JM].[OperationOffset],
	[JM].[QtyIssued],
	[JM].[UnitCost],
	[JM].[ValueIssued],
	[JM].[ValueBilled],
	(CASE WHEN ISNULL([JM].[AllocCompleted], 'N') = 'Y' THEN 1 ELSE 0 END) AS [Complete],
	[JP].[TrnDate]
FROM
	[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
INNER JOIN
	[SysproCompanyA].[dbo].[WipJobAllMat] [JM] WITH (NOLOCK)
ON
	CAST([O].[WO#] AS NVARCHAR(250)) = [JM].[Job]
INNER JOIN
	[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
ON
	[O].[ProductID] = [P].[IDTrailer]
INNER JOIN
	[BWSdb].[dbo].[Dealers] [D] WITH (NOLOCK)
ON
	[O].[DealerID] = [D].[ID]
LEFT JOIN
	[BWSdb].[dbo].[Production] [PR] WITH (NOLOCK)
ON
	[O].[WO#] = [PR].[WO#]
LEFT JOIN
	[SysproCompanyA].[dbo].[WipJobPost] [JP]
ON
	(CAST([O].[WO#] AS NVARCHAR(250)) = [JP].[Job])
	AND 
	([JM].[StockCode] = [JP].[MStockCode])
WHERE
	([O].[WO#] IS NOT NULL)
	AND ([O].[Decline/Rejected] = 4)
    """).strip()
    sql_20250317 = ("""
SELECT
	ISNULL([PR].[Prod Date], [PR].[Prod Date2]) AS [DateProduction],
	[O].[WO#],
	[O].[Quote#],
	[P].[Model No],
	[D].[COMPANY NAME],
	[JM].[StockCode],
	[JM].[StockDescription],
	[JM].[OperationOffset],
	[JM].[QtyIssued],
	[JM].[UnitCost],
	[JM].[ValueIssued],
	[JM].[ValueBilled],
	(CASE WHEN ISNULL([JM].[AllocCompleted], 'N') = 'Y' THEN 1 ELSE 0 END) AS [Complete],
	[JP].[TrnDate],
	[IM].[WarehouseToUse],
	[IW].[DefaultBin]
FROM
	[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
INNER JOIN
	[SysproCompanyA].[dbo].[WipJobAllMat] [JM] WITH (NOLOCK)
ON
	CAST([O].[WO#] AS NVARCHAR(250)) = [JM].[Job]
INNER JOIN
	[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
ON
	[O].[ProductID] = [P].[IDTrailer]
INNER JOIN
	[BWSdb].[dbo].[Dealers] [D] WITH (NOLOCK)
ON
	[O].[DealerID] = [D].[ID]
LEFT JOIN
	[BWSdb].[dbo].[Production] [PR] WITH (NOLOCK)
ON
	[O].[WO#] = [PR].[WO#]
LEFT JOIN
	[SysproCompanyA].[dbo].[WipJobPost] [JP]
ON
	(CAST([O].[WO#] AS NVARCHAR(250)) = [JP].[Job])
	AND ([JM].[StockCode] = [JP].[MStockCode])

LEFT JOIN
	[SysproCompanyA].[dbo].[InvMaster] [IM] WITH (NOLOCK)
ON
	[JM].[StockCode] = [IM].[StockCode]
LEFT JOIN
	[SysproCompanyA].[dbo].[InvWarehouse] [IW] WITH (NOLOCK)
ON
    ([IM].StockCode = [IW].StockCode)
    AND ([IM].[WarehouseToUse] = [IW].[Warehouse])

WHERE
	([O].[WO#] IS NOT NULL)
	AND ([O].[Decline/Rejected] = 4)
;
    """).strip()
    connection_data = {
        "sql": sql_20250317,
        "database": "bwsdb",
        "uid": CREDS_BWS["uid"],
        "pwd": CREDS_BWS["pwd"]
    }
    return connect(**connection_data)


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_walk_part_standards():
    path = r"\\server4.bwsdomain.local\Design\DRAWINGS\STANDARDS"
    return list(os.walk(path))


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_walk_part_pdfs():
    path = r"\\server4.bwsdomain.local\Design\VaultWorkspace_BWS\PDFS"
    return list(os.walk(path))


def load_part_standard(part_num: str | list[str]):
    found_files = []
    ff_n = []
    part_nums = [part_num] if not isinstance(part_num, list) else part_num
    for dir_path, dir_names, file_names in load_walk_part_standards():
        for i, file_ in enumerate(file_names):
            file = file_.upper()
            for j, pn in enumerate(part_nums):
                if pn.upper() in file:
                    if file_ not in ff_n:
                        found_files.append((dir_path, file_))
                        ff_n.append(file_)
    return found_files


def load_part_drawing(part_num: str | list[str]):
    found_files = []
    ff_n = []
    part_nums = [part_num] if not isinstance(part_num, list) else part_num
    for dir_path, dir_names, file_names in load_walk_part_pdfs():
        for i, file_ in enumerate(file_names):
            file = file_.upper()
            for j, pn in enumerate(part_nums):
                if pn.upper() in file:
                    if file_ not in ff_n:
                        found_files.append((dir_path, file_))
                        ff_n.append(file_)
    return found_files


@st.cache_data(show_spinner=SHOW_SPINNERS, ttl=MAX_QUERY_HOLD_TIME)
def load_pdf(path: str):
    with open(path, "rb") as f:
        return f.read()


def metrics(df, delta_col: Optional[str] = None):
    cols_metric = st.columns(3)
    with cols_metric[0]:
        df_w = df.copy()
        df_w["RnkAvg"] = \
            df_w[clbl_ValueOnHand].rank(
                method="average",
                ascending=False
            )
        df_w.sort_values(
            by=clbl_ValueOnHand,
            ascending=False,
            inplace=True
        )
        sr_top = df_w.iloc[0]
        avg_pop = df_w[clbl_ValueOnHand].mean()
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
            by=clbl_ValueOnHand,
            ascending=False,
            inplace=True
        )
        sr_med = df_w.iloc[df_w.shape[0] // 2]
        st.metric(
            label="Median:",
            value=money(sr_med[clbl_ValueOnHand]),
            border=1
        )
        # with cols_metric_0[2]:
        df_mode = df_w[clbl_ValueOnHand].mode().iloc[0]
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
                df[clbl_ValueOnHand].sum()
            ),
            border=1
        )
        if delta_col is not None:
            st.metric(
                label="Min:",
                value=money(
                    df.loc[
                        df[clbl_ValueOnHand].idxmin(),
                        clbl_ValueOnHand]
                ),
                delta=f"{selectbox_df_inventory_graph_by_ValueOnHand}: {df.loc[
                    df[clbl_ValueOnHand].idxmin(),
                    selectbox_df_inventory_graph_by_ValueOnHand]}",
                border=1,
                delta_color="off"
            )
        else:
            st.metric(
                label="Min:",
                value=money(
                    df.loc[
                        df[clbl_ValueOnHand].idxmin(),
                        clbl_ValueOnHand]
                ),
                border=1
            )

    with cols_metric[2]:
        st.metric(
            label="St. Dev.:",
            value=money(
                df[clbl_ValueOnHand].std()
            ),
            border=1
        )
        if delta_col is not None:
            st.metric(
                label="Max:",
                value=money(
                    df.loc[
                        df[clbl_ValueOnHand].idxmax(),
                        clbl_ValueOnHand]
                ),
                delta=f"{selectbox_df_inventory_graph_by_ValueOnHand}: {df.loc[
                    df[clbl_ValueOnHand].idxmax(),
                    selectbox_df_inventory_graph_by_ValueOnHand]}",
                border=1,
                delta_color="off"
            )
        else:
            st.metric(
                label="Max:",
                value=money(
                    df.loc[
                        df[clbl_ValueOnHand].idxmax(),
                        clbl_ValueOnHand]
                ),
                border=1
            )


def clear_cache():
    st.cache_data.clear()
    st.cache_resource.clear()


def rerun():
    # st.rerun()  # no op
    pyautogui.hotkey("ctrl", "F5")


def clear_cache_and_rerun():
    clear_cache()
    rerun()


options_pills = [
    "November 2024 Version",
    "Current"
]
k_pills_operation_mode = "pills_operation_mode"
st.session_state.setdefault(k_pills_operation_mode, 1)
cols_top_bar = st.columns([0.65, 0.35])
with cols_top_bar[0]:
    pills_operation_mode = pills(
        label="Operation Mode:",
        options=options_pills,
        index=st.session_state.get(k_pills_operation_mode)
    )
with cols_top_bar[1]:
    button_clear_cache_and_rerun = st.button(
        label="Clear Cache & Rerun",
        on_click=clear_cache_and_rerun
    )

if pills_operation_mode == 0:

    # November 2024 Version

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
else:

    hide_index: bool = False

    clbl_ValueOnHand = "ValueOnHand"
    clbl_ParentPart = "ParentPart"
    clbl_CycleCount = "CycleCount"
    cc_cols = [clbl_CycleCount, "CycleCountDescription"]

    unknown: str = "UNKNOWN"
    df_inventory = load_inventory_20250306()
    df_inventory.replace(unknown, None, inplace=True)
    df_inventory_cols = list(df_inventory.columns)
    df_inventory[clbl_ValueOnHand] = df_inventory[clbl_ValueOnHand].astype(float)

    cols_to_split = {
        "ParentPartsArray (IF MULTIPLE)": [],
        "ModelNosArray (IF MULTIPLE)": [],
        "ClasssArray (IF MULTIPLE)": [],
        "GroupingsArray (IF MULTIPLE)": []
    }
    for c in cols_to_split:
        df_inventory[c] = df_inventory[c].map(
            lambda s: s.split(",") if s else s
        )
        # st.write(df_inventory[c].values.tolist())
        cols_to_split[c] = list(set(df_inventory[c].explode().dropna()))

    with st.container(border=1):
        multiselect_df_inventory_cols_view = st.multiselect(
            label="Select some columns to order the view below",
            options=df_inventory_cols,
            default=df_inventory_cols,
            placeholder="By default, all columns are shown in original order."
        )

        st.write(f"All Data ({df_inventory.shape[0]} Rows x {len(multiselect_df_inventory_cols_view)} Columns):")
        stdf_inventory = st.dataframe(
            data=df_inventory,
            column_order=multiselect_df_inventory_cols_view,
            hide_index=hide_index
        )
        # st.write(f"AgGrid:")
        #
        # gb = GridOptionsBuilder.from_dataframe(df_inventory)
        # gb.configure_side_bar()
        # go = gb.build()
        # agdf_inventory = AgGrid(
        #     data=df_inventory,
        #     gridOptions=go
        # )

        df_inventory_cols_describe = [
            col for col in df_inventory.columns
            if col not in cols_to_split
        ]
        st.write(f"Value Counts and Frequencies:")
        st.dataframe(
            df_inventory[df_inventory_cols_describe].describe().transpose().reset_index(),
            hide_index=hide_index
        )

        metrics(df_inventory)
        # st.write(df_inventory.value_counts())


    # filtered_melted: pd.DataFrame = filtered_melted.melt(
    #     id_vars="Date",
    #     value_vars=[f"NumNewQuotes{suf}", f"NumNewOrders{suf}"],
    #     var_name="Category",
    #     value_name="Count"
    # )

    with (st.container(border=1)):

        df_inventory_options_graph_by_ValueOnHand = [
            "ModelNo",
            "Grouping",
            "ProductClass",
            "Class",
            "Warehouse",
            "CycleCount",
            "ParentPart"
        ]
        df_inventory_options_graph_by_ValueOnHand += list(cols_to_split)

        selectbox_df_inventory_graph_by_ValueOnHand = st.selectbox(
            label="Select a column to graph against ValueOnHand:",
            options=df_inventory_options_graph_by_ValueOnHand,
            index=0
        )
        toggle_df_inventory_sort_by_value_graph_by_ValueOnHand = st.toggle(
            label="Sort by Total Value?",
            value=True,
            key="toggle_df_inventory_sort_by_value_graph_by_ValueOnHand"
        )

        if selectbox_df_inventory_graph_by_ValueOnHand not in cols_to_split:
            df_inventory_graph_by_ValueOnHand = df_inventory.groupby(
                by=selectbox_df_inventory_graph_by_ValueOnHand,
                dropna=False
            ).agg(
                {clbl_ValueOnHand: "sum"}
            ).reset_index()
            graph_col_sizes = [0.25, 0.75]
        else:
            df_inventory_exp = df_inventory.explode(selectbox_df_inventory_graph_by_ValueOnHand)
            df_inventory_graph_by_ValueOnHand = df_inventory_exp.groupby(
                by=selectbox_df_inventory_graph_by_ValueOnHand,
                dropna=False
            ).agg(
                {clbl_ValueOnHand: "sum"}
            ).reset_index()
            graph_col_sizes = [0.35, 0.65]
            st.warning(f"This output for this column is still a work in progress.")
            st.warning(f"Be aware that the output may change from time-to-time while things are tweaked.")

        # st.write("AA")
        # st.write(df_inventory[cc_cols].drop_duplicates(subset=cc_cols))
        if selectbox_df_inventory_graph_by_ValueOnHand == clbl_CycleCount:
            # Add CycleCountDescription to the data charts when investigating CycleCount
            df_inventory_graph_by_ValueOnHand = df_inventory_graph_by_ValueOnHand.merge(
                df_inventory[cc_cols].drop_duplicates(subset=cc_cols),
                on=clbl_CycleCount,
                how="left",
                suffixes=["", "_b"]
            )
            graph_col_sizes = [0.35, 0.65]
        df_inventory_graph_by_ValueOnHand["View"] = True

        if toggle_df_inventory_sort_by_value_graph_by_ValueOnHand:
            df_inventory_graph_by_ValueOnHand.sort_values(
                by=clbl_ValueOnHand,
                inplace=True,
                ascending=False
            )

        cols_graph_0 = st.columns(graph_col_sizes)

        with cols_graph_0[0]:
            st.write(f"Data ({df_inventory_graph_by_ValueOnHand.shape[0]} Rows x {1 + len(df_inventory_graph_by_ValueOnHand.columns.tolist()[:-1])} Columns):")
            k_stdf_inventory_graph_by_ValueOnHand = "stdf_inventory_graph_by_ValueOnHand"
            stde_inventory_graph_by_ValueOnHand = st.data_editor(
                df_inventory_graph_by_ValueOnHand[["View"] + df_inventory_graph_by_ValueOnHand.columns.tolist()[:-1]],
                hide_index=hide_index,
                disabled=df_inventory_graph_by_ValueOnHand.columns.tolist()[:-1],
                key=k_stdf_inventory_graph_by_ValueOnHand
            )

        with cols_graph_0[1]:
            stde_inventory_graph_by_ValueOnHand_v = stde_inventory_graph_by_ValueOnHand.loc[
                stde_inventory_graph_by_ValueOnHand["View"] == True
            ]
            options_pills_graph_0_style = ["Pie", "Bar"]
            pills_graph_0_style = pills(
                label="Graph Style:",
                options=options_pills_graph_0_style,
                index=1,
                key="k_pills_graph_0_style"
                # ,
                # icons=[":pie:", ":bar_chart:"]
            )
            if pills_graph_0_style == options_pills_graph_0_style[1]:
                # Bar
                chart = px.bar(
                    stde_inventory_graph_by_ValueOnHand_v,
                    x=selectbox_df_inventory_graph_by_ValueOnHand,
                    y=clbl_ValueOnHand,
                    title=f"ValueOnHand By {selectbox_df_inventory_graph_by_ValueOnHand}"
                )
                chart.update_xaxes(type="category")
            else:
                # Pie
                chart = px.pie(
                    data_frame=stde_inventory_graph_by_ValueOnHand_v,
                    names=selectbox_df_inventory_graph_by_ValueOnHand,
                    values=clbl_ValueOnHand,
                    hole=0.28,
                    title=f"ValueOnHand Divided By {selectbox_df_inventory_graph_by_ValueOnHand}"
                )

            st.plotly_chart(
                chart,
                theme=None,
                use_container_width=True,
                key="chart_0"
            )

        # cols_metric_0 = st.columns(3)
        # with cols_metric_0[0]:
        #     # st.metric(
        #     #     label="Average:",
        #     #     value=money(df_inventory_graph_by_ValueOnHand_by_ParentPart[clbl_ValueOnHand].mean()),
        #     #     border=1
        #     # )
        #     stde_inventory_graph_by_ValueOnHand3 = stde_inventory_graph_by_ValueOnHand_v.copy()
        #     stde_inventory_graph_by_ValueOnHand3["RnkAvg"] = \
        #     stde_inventory_graph_by_ValueOnHand3[clbl_ValueOnHand].rank(
        #         method="average",
        #         ascending=False
        #     )
        #     stde_inventory_graph_by_ValueOnHand3.sort_values(by=clbl_ValueOnHand, ascending=False,
        #                                                                  inplace=True)
        #     # st.write("df_inventory_graph_by_ValueOnHand_by_ParentPart2")
        #     # st.write(df_inventory_graph_by_ValueOnHand_by_ParentPart2)
        #     sr_top = stde_inventory_graph_by_ValueOnHand3.iloc[0]
        #     avg_pop = stde_inventory_graph_by_ValueOnHand3[clbl_ValueOnHand].mean()
        #     diff = avg_pop - float(sr_top['ValueOnHand'])
        #     st.metric(
        #         label="Mean:",
        #         value=money(avg_pop),
        #         delta=f"Top Avg: '{sr_top[selectbox_df_inventory_graph_by_ValueOnHand]}' ({money(diff)})",
        #         border=1,
        #         delta_color="inverse" if diff < 0 else "normal"
        #     )
        # # with cols_metric_0[1]:
        #     stde_inventory_graph_by_ValueOnHand3 = stde_inventory_graph_by_ValueOnHand_v.copy()
        #     stde_inventory_graph_by_ValueOnHand3.sort_values(
        #         by=clbl_ValueOnHand,
        #         ascending=False,
        #         inplace=True
        #     )
        #     sr_med = stde_inventory_graph_by_ValueOnHand3.iloc[stde_inventory_graph_by_ValueOnHand3.shape[0] // 2]
        #     st.metric(
        #         label="Median:",
        #         value=money(sr_med[clbl_ValueOnHand]),
        #         border=1
        #     )
        # # with cols_metric_0[2]:
        #     df_mode = stde_inventory_graph_by_ValueOnHand_v[clbl_ValueOnHand].mode().iloc[0]
        #     # st.write(df_mode)
        #     # st.write(type(df_mode))
        #     st.metric(
        #         label="Mode:",
        #         value=money(df_mode),
        #         border=1
        #     )
        # with cols_metric_0[1]:
        #     st.metric(
        #         label="Total:",
        #         value=money(
        #             stde_inventory_graph_by_ValueOnHand_v[clbl_ValueOnHand].sum()
        #         ),
        #         border=1
        #     )
        #     st.metric(
        #         label="Min:",
        #         value=money(
        #             stde_inventory_graph_by_ValueOnHand_v.loc[
        #                 stde_inventory_graph_by_ValueOnHand_v[clbl_ValueOnHand].idxmin(),
        #                 clbl_ValueOnHand]
        #         ),
        #         delta=f"{selectbox_df_inventory_graph_by_ValueOnHand}: {stde_inventory_graph_by_ValueOnHand_v.loc[
        #             stde_inventory_graph_by_ValueOnHand_v[clbl_ValueOnHand].idxmin(),
        #             selectbox_df_inventory_graph_by_ValueOnHand]}",
        #         border=1,
        #         delta_color="off"
        #     )
        # with cols_metric_0[2]:
        #     st.metric(
        #         label="St. Dev.:",
        #         value=money(
        #             stde_inventory_graph_by_ValueOnHand_v[clbl_ValueOnHand].std()
        #         ),
        #         border=1
        #     )
        #     st.metric(
        #         label="Max:",
        #         value=money(
        #             stde_inventory_graph_by_ValueOnHand_v.loc[
        #                 stde_inventory_graph_by_ValueOnHand_v[clbl_ValueOnHand].idxmax(),
        #                 clbl_ValueOnHand]
        #         ),
        #         delta=f"{selectbox_df_inventory_graph_by_ValueOnHand}: {stde_inventory_graph_by_ValueOnHand_v.loc[
        #             stde_inventory_graph_by_ValueOnHand_v[clbl_ValueOnHand].idxmax(),
        #             selectbox_df_inventory_graph_by_ValueOnHand]}",
        #         border=1,
        #         delta_color="off"
        #     )
        metrics(stde_inventory_graph_by_ValueOnHand_v, delta_col=selectbox_df_inventory_graph_by_ValueOnHand)

        # df_inventory_graph_by_ValueOnHand2 = df_inventory.groupby(
        #     by=[clbl_ParentPart]
        # ).agg(
        #     {clbl_ValueOnHand: "sum"}
        # ).reset_index()
        # df_inventory_graph_by_ValueOnHand2["View"] = True
        #
        #
        # filtered_melted: pd.DataFrame = df_inventory.melt(
        #     id_vars=[clbl_ValueOnHand, "ParentPart"],
        #     value_vars=[selectbox_df_inventory_graph_by_ValueOnHand],
        #     var_name=f"Category{selectbox_df_inventory_graph_by_ValueOnHand}",
        #     value_name=f"Count{selectbox_df_inventory_graph_by_ValueOnHand}"
        # )
        # st.write("filtered_melted")
        # st.write(filtered_melted)
        # chart = px.bar(
        #     filtered_melted
        #     # .rename(
        #     #     columns={
        #     #         "": ""
        #     #     }
        #     ,
        #     # barmode="stack",
        #     x=f"Category{selectbox_df_inventory_graph_by_ValueOnHand}",
        #     y=clbl_ValueOnHand,
        #     title=f"'ValueOnHand' By {selectbox_df_inventory_graph_by_ValueOnHand}",
        #
        #     color=clbl_ParentPart,
        #     # title=f"Count of new Quotes & WOs {suf}",
        #     # labels={"Date": "Date", "Count": "Count"}
        # )
        # chart.update_xaxes(type="category")
        # st.plotly_chart(
        #     chart,
        #     theme=None,
        #     use_container_width=True,
        #     key="chart_1"
        # )
    # with st.container(border=1):

        st.divider()

        if selectbox_df_inventory_graph_by_ValueOnHand != clbl_ParentPart:

            if selectbox_df_inventory_graph_by_ValueOnHand not in cols_to_split:
                df_inventory_graph_by_ValueOnHand2 = df_inventory.groupby(
                    by=[selectbox_df_inventory_graph_by_ValueOnHand, clbl_ParentPart],
                    dropna=False
                ).agg(
                    {clbl_ValueOnHand: "sum"}
                ).reset_index()
                graph_col_sizes = [0.25, 0.75]
            else:
                df_inventory_exp = df_inventory.explode(selectbox_df_inventory_graph_by_ValueOnHand)
                df_inventory_graph_by_ValueOnHand2 = df_inventory_exp.groupby(
                    by=[selectbox_df_inventory_graph_by_ValueOnHand, clbl_ParentPart],
                    dropna=False
                ).agg(
                    {clbl_ValueOnHand: "sum"}
                ).reset_index()
                graph_col_sizes = [0.35, 0.65]
                st.warning(f"Be aware that the output may change from time-to-time while things are tweaked.")

            if selectbox_df_inventory_graph_by_ValueOnHand == clbl_CycleCount:
                # Add CycleCountDescription to the data charts when investigating CycleCount
                df_inventory_graph_by_ValueOnHand2 = df_inventory_graph_by_ValueOnHand2.merge(
                    df_inventory[cc_cols].drop_duplicates(subset=cc_cols),
                    on=clbl_CycleCount,
                    how="left",
                    suffixes=["", "_b"]
                )
                graph_col_sizes = [0.35, 0.65]
            df_inventory_graph_by_ValueOnHand2["Sel"] = True

            toggle_df_inventory_sort_by_value_graph_by_ValueOnHand2 = st.toggle(
                label="Sort by Total Value?",
                value=True,
                key="toggle_df_inventory_sort_by_value_graph_by_ValueOnHand2"
            )

            if toggle_df_inventory_sort_by_value_graph_by_ValueOnHand2:
                df_inventory_graph_by_ValueOnHand2.sort_values(
                    by=clbl_ValueOnHand,
                    inplace=True,
                    ascending=False
                )

            cols_graph_1 = st.columns(graph_col_sizes)

            with cols_graph_1[0]:
                st.write(f"{clbl_ValueOnHand} x {selectbox_df_inventory_graph_by_ValueOnHand}, Grouped by {clbl_ParentPart} Data:")
                st.write(f"({df_inventory_graph_by_ValueOnHand2.shape[0]} Rows x {1 + len(df_inventory_graph_by_ValueOnHand2.columns.tolist()[:-1])} Columns):")
                stde_inventory_graph_by_ValueOnHand2 = st.data_editor(
                    data=df_inventory_graph_by_ValueOnHand2[["Sel"] + df_inventory_graph_by_ValueOnHand2.columns.tolist()[:-1]],
                    hide_index=hide_index,
                    disabled=df_inventory_graph_by_ValueOnHand2.columns.tolist()[:-1]
                )

            # if stde_inventory_graph_by_ValueOnHand2.shape[0] != stde_inventory_graph_by_ValueOnHand2.loc[
            #         stde_inventory_graph_by_ValueOnHand2["Sel"] == True
            #     ].shape[0]:
            #     if st.button("Select All"):
            #         df_inventory_graph_by_ValueOnHand2["Sel"] = True
            #         st.rerun()

            df_inventory_graph_by_ValueOnHand_by_ParentPart = stde_inventory_graph_by_ValueOnHand2.loc[
                stde_inventory_graph_by_ValueOnHand2["Sel"] == True
                ]
            with cols_graph_1[1]:
                options_pills_graph_1_style = ["Pie", "Bar"]
                pills_graph_1_style = pills(
                    label="Graph Style:",
                    options=options_pills_graph_1_style,
                    index=1,
                    key="k_pills_graph_1_style"
                    # ,
                    # icons=[":pie:", ":bar_chart:"]
                )
                if pills_graph_1_style == options_pills_graph_1_style[1]:
                    # Bar
                    chart = px.bar(
                        df_inventory_graph_by_ValueOnHand_by_ParentPart
                        # .rename(
                        #     columns={
                        #         "": ""
                        #     }
                        ,
                        # barmode="stack",
                        x=selectbox_df_inventory_graph_by_ValueOnHand,
                        y=clbl_ValueOnHand,
                        title=f"{clbl_ValueOnHand} x {selectbox_df_inventory_graph_by_ValueOnHand}, Grouped by {clbl_ParentPart}",

                        color=clbl_ParentPart,
                        # title=f"Count of new Quotes & WOs {suf}",
                        # labels={"Date": "Date", "Count": "Count"}
                    )
                    chart.update_xaxes(type="category")
                else:
                    # Pie

                    options_pills_graph_1_by = [selectbox_df_inventory_graph_by_ValueOnHand, clbl_ParentPart]
                    pills_graph_1_by = pills(
                        label="Graph By:",
                        options=options_pills_graph_1_by,
                        index=0,
                        key="k_pills_graph_1_by"
                        # ,
                        # icons=[":pie:", ":bar_chart:"]
                    )

                    chart = px.pie(
                        df_inventory_graph_by_ValueOnHand_by_ParentPart,
                        # names=selectbox_df_inventory_graph_by_ValueOnHand,
                        # names=clbl_ParentPart,
                        names=pills_graph_1_by,
                        values=clbl_ValueOnHand,
                        hole=0.28,
                        title=f"{clbl_ValueOnHand} Divided By {pills_graph_1_by}"
                    )
                st.plotly_chart(
                    chart,
                    theme=None,
                    use_container_width=True,
                    key="chart_2"
                )

            # cols_metric_1 = st.columns(3)
            # with cols_metric_1[0]:
            #     # st.metric(
            #     #     label="Average:",
            #     #     value=money(df_inventory_graph_by_ValueOnHand_by_ParentPart[clbl_ValueOnHand].mean()),
            #     #     border=1
            #     # )
            #     df_inventory_graph_by_ValueOnHand_by_ParentPart2 = df_inventory_graph_by_ValueOnHand_by_ParentPart.copy()
            #     df_inventory_graph_by_ValueOnHand_by_ParentPart2["RnkAvg"] = df_inventory_graph_by_ValueOnHand_by_ParentPart2[clbl_ValueOnHand].rank(
            #         method="average",
            #         ascending=False
            #     )
            #     df_inventory_graph_by_ValueOnHand_by_ParentPart2.sort_values(by=clbl_ValueOnHand, ascending=False, inplace=True)
            #     # st.write("df_inventory_graph_by_ValueOnHand_by_ParentPart2")
            #     # st.write(df_inventory_graph_by_ValueOnHand_by_ParentPart2)
            #     sr_top = df_inventory_graph_by_ValueOnHand_by_ParentPart2.iloc[0]
            #     avg_pop = df_inventory_graph_by_ValueOnHand_by_ParentPart[clbl_ValueOnHand].mean()
            #     diff = avg_pop - float(sr_top['ValueOnHand'])
            #     st.metric(
            #         label="Mean:",
            #         value=money(avg_pop),
            #         delta=f"Top Avg: '{sr_top['ParentPart']}' ({money(diff)})",
            #         border=1,
            #         delta_color="inverse" if diff < 0 else "normal"
            #     )
            # # with cols_metric_1[1]:
            #     stde_inventory_graph_by_ValueOnHand3 = stde_inventory_graph_by_ValueOnHand_v.copy()
            #     stde_inventory_graph_by_ValueOnHand3.sort_values(
            #         by=clbl_ValueOnHand,
            #         ascending=False,
            #         inplace=True
            #     )
            #     sr_med = stde_inventory_graph_by_ValueOnHand3.iloc[stde_inventory_graph_by_ValueOnHand3.shape[0] // 2]
            #     st.metric(
            #         label="Median:",
            #         value=money(sr_med[clbl_ValueOnHand]),
            #         border=1
            #     )
            # # with cols_metric_1[2]:
            #     df_mode = df_inventory_graph_by_ValueOnHand_by_ParentPart[clbl_ValueOnHand].mode().iloc[0]
            #     # st.write(df_mode)
            #     # st.write(type(df_mode))
            #     st.metric(
            #         label="Mode:",
            #         value=money(df_mode),
            #         border=1
            #     )
            # with cols_metric_1[1]:
            #     st.metric(
            #         label="Total:",
            #         value=money(
            #             df_inventory_graph_by_ValueOnHand_by_ParentPart[clbl_ValueOnHand].sum()
            #         ),
            #         border=1
            #     )
            #     st.metric(
            #         label="Min:",
            #         value=money(
            #             df_inventory_graph_by_ValueOnHand_by_ParentPart.loc[
            #                 df_inventory_graph_by_ValueOnHand_by_ParentPart[clbl_ValueOnHand].idxmin(),
            #                 clbl_ValueOnHand]
            #         ),
            #         delta=f"{selectbox_df_inventory_graph_by_ValueOnHand}: {df_inventory_graph_by_ValueOnHand_by_ParentPart.loc[
            #                 df_inventory_graph_by_ValueOnHand_by_ParentPart[clbl_ValueOnHand].idxmin(),
            #                 selectbox_df_inventory_graph_by_ValueOnHand]}",
            #         border=1,
            #         delta_color="off"
            #     )
            # with cols_metric_1[2]:
            #     st.metric(
            #         label="St. Dev.:",
            #         value=money(
            #             df_inventory_graph_by_ValueOnHand_by_ParentPart[clbl_ValueOnHand].std()
            #         ),
            #         border=1
            #     )
            #     st.metric(
            #         label="Max:",
            #         value=money(
            #             df_inventory_graph_by_ValueOnHand_by_ParentPart.loc[
            #                 df_inventory_graph_by_ValueOnHand_by_ParentPart[clbl_ValueOnHand].idxmax(),
            #                 clbl_ValueOnHand]
            #         ),
            #         delta=f"{selectbox_df_inventory_graph_by_ValueOnHand}: {df_inventory_graph_by_ValueOnHand_by_ParentPart.loc[
            #                 df_inventory_graph_by_ValueOnHand_by_ParentPart[clbl_ValueOnHand].idxmax(),
            #                 selectbox_df_inventory_graph_by_ValueOnHand]}",
            #         border=1,
            #         delta_color="off"
            #     )
            metrics(df_inventory_graph_by_ValueOnHand_by_ParentPart, delta_col=selectbox_df_inventory_graph_by_ValueOnHand)

        else:
            with st.container(border=1):
                st.write(f"Cannot plot '{clbl_ParentPart}' and group by it at the same time.")
                st.write(f"Select another column to view this section.")

    with st.container(border=1):
        selectbox_df_inventory_investigate_col = st.selectbox(
            label="Select a column to Investigate:",
            options=df_inventory.columns.to_list(),
            index=0
        )

        df_inventory_investigate_value_counts = pd.DataFrame(df_inventory[selectbox_df_inventory_investigate_col].value_counts()).reset_index()
        # n_df_inventory_investigate_values = df_inventory_investigate_value_counts.shape[0]
        n_df_inventory_investigate_values = df_inventory_investigate_value_counts["count"].sum()
        df_inventory_investigate_value_counts["pctFreq"] = df_inventory_investigate_value_counts["count"] / max(1, n_df_inventory_investigate_values)

        st.write(f"Chosen Column: '{selectbox_df_inventory_investigate_col}'")
        cols_df_inventory_investigate = st.columns([0.25, 0.75])
        with cols_df_inventory_investigate[0]:
            st.write("All Data:")
            st.dataframe(
                df_inventory[selectbox_df_inventory_investigate_col].describe().reset_index(),
                hide_index=hide_index
            )
        with cols_df_inventory_investigate[1]:
            if selectbox_df_inventory_graph_by_ValueOnHand not in cols_to_split:
                st.write("Unique Value Counts:")
                st.write(f"{df_inventory_investigate_value_counts.shape[0]} Rows x {len(df_inventory_investigate_value_counts.columns)} Columns")
                st.dataframe(
                    df_inventory_investigate_value_counts,
                    hide_index=hide_index
                )
            else:
                cols_sub_investigate = st.columns(2)
                with cols_sub_investigate[0]:
                    st.write("Unique Value Counts:")
                    st.write(f"{df_inventory_investigate_value_counts.shape[0]} Rows x {len(df_inventory_investigate_value_counts.columns)} Columns")
                    st.dataframe(
                        df_inventory_investigate_value_counts,
                        hide_index=hide_index
                    )
                with cols_sub_investigate[1]:
                    df_iivc = pd.DataFrame(
                        df_inventory[selectbox_df_inventory_investigate_col].explode().value_counts()).reset_index()
                    # n_df_iivc = df_iivc.shape[0]
                    n_df_iivc = df_iivc["count"].sum()
                    df_iivc["pctFreq"] = df_iivc["count"] / max(1, n_df_iivc)
                    st.write("Unique Value Counts (Exploded):")
                    st.write(f"{df_iivc.shape[0]} Rows x {len(df_iivc.columns)} Columns")
                    st.dataframe(
                        df_iivc,
                        hide_index=hide_index
                    )

size_node_op: int = 40

st.divider()
# st.header("Parts Graph")
# df_inventory_sub = load_inventory_subs()
# clbl_PartCategory = "PartCategory"
# clbl_OperationOffset = "OperationOffset"
# vlbl_bought_out = "B"
# vlbl_made_in = "M"
#
# df_inventory_sub[clbl_OperationOffset] = df_inventory_sub[clbl_OperationOffset].astype(int)
#
# df_inventory_sub.sort_values(
#     by="DateProduction",
#     ascending=False,
#     inplace=True
# )
# # print(df_inventory_sub)
# # # stdf_inventory_sub = st.write(df_inventory_sub)
# # stdf_inventory_sub = st.dataframe(
# #     data=df_inventory_sub,
# #     hide_index=True
# # )
# lst_jobs = df_inventory_sub["WO#"].unique().tolist()
#
# selectbox_graph_job = st.selectbox(
#     label="Select a Job:",
#     options=lst_jobs,
#     placeholder="Select a Job:"
# )
#
# df_job = df_inventory_sub.loc[
#     (df_inventory_sub["WO#"] == selectbox_graph_job)
#     | (df_inventory_sub["Job"] == selectbox_graph_job)
# ]
# df_job_bought_out = df_job.loc[
#     (df_job[clbl_PartCategory] == vlbl_bought_out)
#     | (
#         df_job[clbl_PartCategory].isna()
#         & (df_job["SubPartCategory"] == vlbl_bought_out)
#     )
# ]
# df_job_made_in = df_job.loc[
#     (df_job[clbl_PartCategory] == vlbl_made_in)
#     | (
#         df_job[clbl_PartCategory].isna()
#         & (df_job["SubPartCategory"] == vlbl_made_in)
#     )
# ]
#
# if df_job.empty:
#     st.write("Select a job to graph.")
# else:
#     st.subheader(f"WO: {selectbox_graph_job}")
#     st.write(f"All Job Data ({df_job.shape[0]} Rows x {df_job.shape[1]} Columns):")
#     stdf_graph_job = st.dataframe(
#         data=df_job,
#         hide_index=hide_index
#     )
#     st.write(f"Bought-Out Parts Data ({df_job_bought_out.shape[0]} Rows x {df_job_bought_out.shape[1]} Columns):")
#     stdf_graph_job_bought_out = st.dataframe(
#         data=df_job_bought_out,
#         hide_index=hide_index
#     )
#     st.write(f"Made-In Parts Data ({df_job_made_in.shape[0]} Rows x {df_job_made_in.shape[1]} Columns):")
#     stdf_graph_job_made_in = st.dataframe(
#         data=df_job_made_in,
#         hide_index=hide_index
#     )
#     nodes = [
#         Node(
#             id=f"node_op_{op}",
#             title=f"{int(op)}",
#             size=size_node_op,
#             level=i
#         )
#         for i, op in enumerate(range(df_job[clbl_OperationOffset].min(), df_job[clbl_OperationOffset].max()))
#     ]
#
#     edges = []
#
#     config = Config(
#         hierarchical=True
#     )
#
#     with st.container(border=1):
#         graph = agraph(
#             nodes=nodes,
#             edges=edges,
#             config=config
#         )

# Copied from WO_final_costing # 2025-03-17
with st.expander(
    label=":new: Parts Per Job"
):
    df_parts_data = load_parts_data_bws()
    df_parts_subs = load_parts_subs_data_bws()
    df_parts_data.rename(
        columns={
            "WO#": "WO",
            "OperationOffset": "Operation",
            "MStockCode": "StockCode"
        },
        inplace=True
    )
    df_parts_subs.rename(
        columns={
            "WO#": "WO",
            "OperationOffset": "Operation",
            "MStockCode": "StockCode"
        },
        inplace=True
    )
    df_parts_data.sort_values(by="DateProduction", ascending=False, inplace=True)

    st.write("### Newest 10 Jobs:")
    stdf_parts_data = st.dataframe(
        data=df_parts_data.head(10)
    )
    list_jobs = df_parts_data["WO"].dropna().unique()

    selectbox_job = st.selectbox(
        label="Choose a Job:",
        options=list_jobs
    )

    options_hierarchy = ["Operation", "Date"]
    selectbox_hierarchy = st.selectbox(
        label="Hierarchy Mode:",
        options=options_hierarchy
    )

    toggle_incomplete_jobs_only = st.toggle(
        label="Incomplete Issued Parts Only?"
    )

    toggle_node_size_by_part_cost = st.toggle(
        label="Size Nodes by Part Cost Totals?"
    )

    toggle_agraph_physics = st.toggle(
        label="Physics?"
    )

    edges = []
    op_nodes = []
    part_nodes = []
    part_subs_nodes = []
    if selectbox_job:

        df_job_parts = df_parts_data.loc[df_parts_data["WO"] == selectbox_job]
        df_job_parts_subs = df_parts_subs.loc[
            df_parts_subs["WO"] == selectbox_job
        ]
        list_operations = sorted(list(map(int, df_job_parts["Operation"].dropna().unique())))

        if toggle_incomplete_jobs_only:
            df_job_parts = df_job_parts.loc[
                pd.isna(df_job_parts["Complete"])
                | (df_job_parts["Complete"] == 0)
            ]

        df_job_parts["OpNode"] = None
        df_job_parts["OpPartNode"] = None
        df_job_parts["MinDateOpUse"] = None
        df_job_parts["TotalPartCostOp"] = None
        df_job_parts_subs["TotalPartCostOp"] = None

        # Temporary 'Constants' relevant to this job
        min_date = df_job_parts["TrnDate"].min()  # first transaction date
        max_date = df_job_parts["TrnDate"].max() + datetime.timedelta(days=1)  # last transaction date

        if pd.isna(min_date):
            min_date = pd.Timestamp.now()
        if pd.isna(max_date):
            max_date = pd.Timestamp.now() + pd.Timedelta(days=1)

        total_cost_job_parts = df_job_parts["ValueBilled"].sum()  # total part cost across all operations
        total_cost_job_parts_subs = df_job_parts_subs["ValueBilled"].sum()  # total part cost across all sub jobs

        # st.write(f"{min_date=}, {max_date=}, {(max_date - min_date).days}")
        # st.write("df_job_parts")
        # st.write(df_job_parts)

        # When hierarchy mode in 'Date' mode, use this dict to determine the node's level
        date_2_level = {
            # use 3 levels for each operation needed (Op, Parts, Subs).
            pd.to_datetime(min_date + datetime.timedelta(days=i)): [3 * i, (3 * i) + 1, (3 * i) + 2]
            for i in range((max_date - min_date).days)
        }

        # DF to store the first date an operation had a transaction
        df_min_op_use: pd.DataFrame = df_job_parts.groupby(
            by=["Operation"]
        ).agg({"TrnDate": "min"}).rename(
            columns={"TrnDate": "MinDateOpUse"}
        ).reset_index()
        df_min_op_use["OG_MinDateOpUse"] = df_min_op_use["MinDateOpUse"]
        df_min_op_use["MinDateOpUse"].replace(
            pd.NaT,
            max_date + datetime.timedelta(days=-1),
            inplace=True
        )
        df_min_op_use.sort_values(
            by="Operation",
            inplace=True
        )

        # DF to store the total part cost for each operation.
        df_job_part_cost_by_op: pd.DataFrame = df_job_parts.groupby(
            by="Operation"
        ).agg({"ValueIssued": "sum"}).rename(
            columns={"ValueIssued": "TotalPartCostOp"}
        ).reset_index()
        max_part_cost_op = df_job_part_cost_by_op["TotalPartCostOp"].max()
        if max_part_cost_op == 0:
            # prevent division by 0
            max_part_cost_op = 1

        df_job_part_sub_cost_by_op: pd.DataFrame = df_job_parts_subs.groupby(
            by="Operation"
        ).agg({"ValueIssued": "sum"}).rename(
            columns={"ValueIssued": "TotalPartCostOp"}
        ).reset_index()
        max_part_cost_subs_op = df_job_part_sub_cost_by_op["TotalPartCostOp"].max()
        if max_part_cost_subs_op == 0:
            # prevent division by 0
            max_part_cost_subs_op = 1

        # When using cost-based sizing for nodes, use this DF to determine node size.
        min_node_size = 200
        max_node_size = 1000
        df_job_part_cost_by_op["NodeSize"] = ((df_job_part_cost_by_op["TotalPartCostOp"] / max_part_cost_op) * (max_node_size - min_node_size)) + min_node_size
        df_job_part_sub_cost_by_op["NodeSize"] = ((df_job_part_sub_cost_by_op["TotalPartCostOp"] / max_part_cost_subs_op) * (max_node_size - min_node_size)) + min_node_size

        # Report
        st.subheader(f"WO# {selectbox_job}")
        with st.container(border=1):
            st.write(f"Total Part Cost: :red[{money(total_cost_job_parts)}]")
            st.write(f"Total Part Subs Cost: :red[{money(total_cost_job_parts_subs)}]")
            st.warning("#TODO -- 20250317")

        # cc = st.columns(2)
        # with cc[0]:
        #     st.write("df_job_part_cost_by_op")
        #     st.write(df_job_part_cost_by_op)
        # with cc[1]:
        #     st.write("df_job_part_sub_cost_by_op")
        #     st.write(df_job_part_sub_cost_by_op)

        if selectbox_hierarchy == options_hierarchy[1]:
            # Date

            config = Config(
                physics=toggle_agraph_physics,
                hierarchical=True,
                direction="LR",
                width=1200,
                height=1600,
                # groups=[1, 2, 3],
                collapsible=True,
                interaction={
                    "selectable": True,
                    "dragNodes": False,
                    "dragView": True,
                    "zoomView": True
                }
            )
            get_level = lambda date_, lvl=0: date_2_level[date_][lvl]

            # # st.write(f"{min_date=}, {max_date=}")
            # # st.write(date_2_level)
            #
            # # st.write("df_min_op_use")
            # # st.write(df_min_op_use)
            #
            # i_c = 0
            # for i, row in df_min_op_use.iterrows():
            #     if pd.isna(row["OG_MinDateOpUse"]):
            #         date_str = "N/A"
            #     else:
            #         date_str = f"{row['MinDateOpUse']:%x}"
            #     op_nodes.append(Node(
            #         id=f"node_part_{i}",
            #         title=f"{int(row['Operation'])} - {date_str}",
            #         size=size_node_op,
            #         level=date_2_level[row["MinDateOpUse"]][0],
            #         color=colour_node_op.hex_code
            #     ))
            #     if i_c > 0:
            #         edges.append(Edge(
            #             source=op_nodes[-2].id,
            #             target=op_nodes[-1].id,
            #             title=f"{i=}"
            #         ))
            #     i_c += 1
            # node_ids = [node.id for node in op_nodes]
            #
            # for i, op_node_id in enumerate(zip(list_operations, node_ids)):
            #     op, node_id = op_node_id
            #     df_op_parts = df_job_parts.loc[df_job_parts["Operation"] == op]
            #     df_op_parts_subs = df_job_parts_subs.loc[
            #         df_job_parts_subs["Operation"] == op
            #     ]
            #     if toggle_incomplete_jobs_only:
            #         df_op_parts_subs = df_op_parts_subs.loc[
            #             pd.isna(df_op_parts_subs["SubAllocCompleted"])
            #             | (df_op_parts_subs["SubAllocCompleted"] == 0)
            #         ]
            #     # st.write(f"#### {i=}, {op=}")
            #     # st.write(df_op_parts)
            #     # st.write(df_op_parts_subs)
            #     for j, row in df_op_parts.iterrows():
            #         complete = row["Complete"]
            #         date = row["TrnDate"]
            #         date = max_date + datetime.timedelta(days=-1) if pd.isna(date) else date
            #         if pd.isna(row["TrnDate"]):
            #             date_str = "N/A"
            #         else:
            #             date_str = f"{row['TrnDate']:%x}"
            #         part_nodes.append(Node(
            #             id=f"node_part_{i}_{j}",
            #             title=f"{row['StockCode']} - {row['StockDescription']} - {date_str}",
            #             size=size_node_part,
            #             color=(colour_node_part_complete if complete else colour_node_part_needed).hex_code
            #             ,
            #             # level=op
            #             # level=max(0, 2*(i-1)) + 1
            #             # level=2*(i-1)
            #             level=date_2_level[date][1]
            #             # group=2 if complete else 1
            #         ))
            #         edges.append(Edge(
            #             source=part_nodes[-1].id,
            #             target=node_id,
            #             title=f"({i=}, {j=})"
            #         ))
            #         df_job_parts.loc[j, "OpNode"] = node_id
            #         df_job_parts.loc[j, "OpPartNode"] = part_nodes[-1].id
            #
            #     for j, row in df_op_parts_subs.iterrows():
            #         complete = row["Complete"]
            #         parent_job = row["Job"]
            #         date = row["TrnDate"]
            #         if pd.isna(row["TrnDate"]):
            #             date_str = "N/A"
            #         else:
            #             date_str = f"{row['MinDateOpUse']:%x}"
            #         df_job_sub_part = df_job_parts.loc[
            #             (df_job_parts["WO"] == selectbox_job)
            #             & (df_job_parts["StockCode"] == parent_job)
            #         ]
            #         # st.write(f"SUBS {i=}, {j=}")
            #         # st.write(df_job_sub_part)
            #         part_node_id = df_job_sub_part.iloc[0]["OpPartNode"]
            #         # st.write(f"{part_node_id=}")
            #         part_subs_nodes.append(Node(
            #             id=f"node_part_sub_{i}_{j}",
            #             title=f"{row['SubStockCode']} - {row['SubStockDescription']} - {date_str}",
            #             size=size_node_part_sub,
            #             color=(colour_node_part_subs_complete if complete else colour_node_part_subs_needed).hex_code
            #             ,
            #             # level=op
            #             # level=max(0, 2*(i-1)) + 1
            #             # level=2*(i-1)
            #             level=date_2_level[date][2]
            #             # group=2 if complete else 1
            #         ))
            #         edges.append(Edge(
            #             source=part_subs_nodes[-1].id,
            #             target=part_node_id,
            #             title=f"({i=}, {j=})"
            #         ))

        else:

            # op_nodes = [
            #     Node(
            #         id=f"node_op_{op}",
            #         title=f"{op}",
            #         size=size_node_op,
            #         color=colour_node_op.hex_code
            #         ,
            #         level=3*i,
            #         # group=0
            #     )
            #     for i, op in enumerate(list_operations)
            # ]
            # node_ids = [node.id for node in op_nodes]
            #
            # edges = [
            #     Edge(
            #         source=op_nodes[i].id,
            #         target=op_nodes[i+1].id
            #     )
            #     for i in range(len(op_nodes) - 1)
            # ]

            config = Config(
                physics=toggle_agraph_physics,
                hierarchical=True,
                # direction="LR",
                width=1200,
                height=1600,
                # groups=[1, 2, 3],
                collapsible=True
            )
            get_level = lambda op_num_, lvl=0: (op_num_ * 3) + lvl

            # # st.write("node_ids")
            # # st.write(node_ids)
            #
            # for i, op_node_id in enumerate(zip(list_operations, node_ids)):
            #     op, node_id = op_node_id
            #     df_op_parts = df_job_parts.loc[df_job_parts["Operation"] == op]
            #     df_op_parts_subs = df_job_parts_subs.loc[
            #         (df_job_parts_subs["WO"] == selectbox_job)
            #         & (df_job_parts_subs["Operation"] == op)
            #     ]
            #     if toggle_incomplete_jobs_only:
            #         df_op_parts_subs = df_op_parts_subs.loc[
            #             pd.isna(df_op_parts_subs["SubAllocCompleted"])
            #             | (df_op_parts_subs["SubAllocCompleted"] == 0)
            #         ]
            #     # st.write(f"#### {i=}, {op=}")
            #     # st.write(df_op_parts)
            #     # st.write(df_op_parts_subs)
            #     for j, row in df_op_parts.iterrows():
            #         complete = row["Complete"]
            #         part_nodes.append(Node(
            #             id=f"node_part_{i}_{j}",
            #             title=f"{row['StockCode']} - {row['StockDescription']}",
            #             size=size_node_part,
            #             color=(colour_node_part_complete if complete else colour_node_part_needed).hex_code
            #             ,
            #             # level=op
            #             # level=max(0, 2*(i-1)) + 1
            #             # level=2*(i-1)
            #             level=(3*i)+1
            #             # group=2 if complete else 1
            #         ))
            #         edges.append(Edge(
            #             source=part_nodes[-1].id,
            #             target=node_id,
            #             title=f"({i=}, {j=})"
            #         ))
            #         df_job_parts.loc[j, "OpNode"] = node_id
            #         df_job_parts.loc[j, "OpPartNode"] = part_nodes[-1].id
            #
            #     for j, row in df_op_parts_subs.iterrows():
            #         complete = row["Complete"]
            #         parent_job = row["Job"]
            #         df_job_sub_part = df_job_parts.loc[
            #             (df_job_parts["WO"] == selectbox_job)
            #             & (df_job_parts["StockCode"] == parent_job)
            #         ]
            #         # st.write(f"SUBS {i=}, {j=}")
            #         # st.write(df_job_sub_part)
            #         part_node_id = df_job_sub_part.iloc[0]["OpPartNode"]
            #         # st.write(f"{part_node_id=}")
            #         part_subs_nodes.append(Node(
            #             id=f"node_part_sub_{i}_{j}",
            #             title=f"{row['SubStockCode']} - {row['SubStockDescription']}",
            #             size=size_node_part_sub,
            #             color=(colour_node_part_subs_complete if complete else colour_node_part_subs_needed).hex_code
            #             ,
            #             # level=op
            #             # level=max(0, 2*(i-1)) + 1
            #             # level=2*(i-1)
            #             level=(3 * i) + 2
            #             # group=2 if complete else 1
            #         ))
            #         edges.append(Edge(
            #             source=part_subs_nodes[-1].id,
            #             target=part_node_id,
            #             title=f"({i=}, {j=})"
            #         ))

        # # if toggle_node_size_by_part_cost:
        # get_size = lambda node_type_id, op_num: \
        #     df_job_part_cost_by_op.loc[
        #         df_job_part_cost_by_op["Operation"] == op_num
        #     ].iloc[0]["NodeSize"] \
        #         if toggle_node_size_by_part_cost else \
        #         [size_node_op, size_node_part, size_node_part_sub][node_type_id]
        # # else:
        # #     get_size = 10

        def get_size(node_type_id, op_num, part_num=None):
            if toggle_node_size_by_part_cost:
                sr_job_part_cost_by_op = df_job_part_cost_by_op.loc[
                    df_job_part_cost_by_op["Operation"] == op_num
                ].iloc[0]
                if node_type_id == 0:
                    # Node
                    return sr_job_part_cost_by_op["NodeSize"]
                else:
                    max_part_cost_op = sr_job_part_cost_by_op["TotalPartCostOp"].max()
                    part_cost = df_job_parts.loc[df_job_parts["StockCode"] == part_num].iloc[0]["ValueIssued"]
                    if max_part_cost_op == 0:
                        max_part_cost_op = 1
                    p_part_cost = part_cost / max_part_cost_op
                    return sr_job_part_cost_by_op["NodeSize"] * p_part_cost
            else:
                return [size_node_op, size_node_part, size_node_part_sub][node_type_id]

        i_c = 0
        for i, row in df_min_op_use.iterrows():
            op_num = row["Operation"]
            if pd.isna(row["OG_MinDateOpUse"]):
                date_str = "N/A"
            else:
                date_str = f"{row['MinDateOpUse']:%x}"
            total_op_cost = df_job_part_cost_by_op.loc[df_job_part_cost_by_op["Operation"] == op_num].iloc[0]["TotalPartCostOp"]
            date_str = f" - {date_str} -- {money(total_op_cost)}".replace(" - N/A ", " ")
            op_nodes.append(Node(
                id=f"node_op_{i}",
                title=f"{int(op_num)}{date_str}",
                # label=f"{int(op_num)}{date_str}",
                # text=f"{int(op_num)}{date_str}",
                # title="MSN BWS 20250219.pdf",
                # size=size_node_op,
                size=get_size(0, op_num),
                # level=date_2_level[row["MinDateOpUse"]][0],
                level=get_level(row["MinDateOpUse"] if (selectbox_hierarchy == options_hierarchy[1]) else i_c, lvl=0),
                color=colour_node_op.hex_code,
                link=r"U:\Quick files\Junk\MSN STG 20250219.pdf",
                data=r"U:\Quick files\Junk\MSN STG 20250219.pdf",
                path=r"U:\Quick files\Junk\MSN STG 20250219.pdf",
                metadata=r"U:\Quick files\Junk\MSN STG 20250219.pdf",
                url=r"U:\Quick files\Junk\MSN STG 20250219.pdf"
                # ,
                # title=r"U:\Quick files\Junk\MSN STG 20250219.pdf"
            ))
            if i_c > 0:
                edges.append(Edge(
                    source=op_nodes[-2].id,
                    target=op_nodes[-1].id,
                    title=f"{i=}"
                ))
            i_c += 1
        node_ids = [node.id for node in op_nodes]

        for i, op_node_id in enumerate(zip(list_operations, node_ids)):
            op, node_id = op_node_id
            df_op_parts = df_job_parts.loc[df_job_parts["Operation"] == op]
            df_op_parts_subs = df_job_parts_subs.loc[
                df_job_parts_subs["Operation"] == op
                ]
            if toggle_incomplete_jobs_only:
                df_op_parts_subs = df_op_parts_subs.loc[
                    pd.isna(df_op_parts_subs["SubAllocCompleted"])
                    | (df_op_parts_subs["SubAllocCompleted"] == 0)
                    ]
            # st.write(f"#### {i=}, {op=}")
            # st.write(df_op_parts)
            # st.write(df_op_parts_subs)
            for j, row in df_op_parts.iterrows():
                complete = row["Complete"]
                date = row["TrnDate"]
                date = max_date + datetime.timedelta(days=-1) if pd.isna(date) else date
                if pd.isna(row["TrnDate"]):
                    date_str = "N/A"
                else:
                    date_str = f"{row['TrnDate']:%x}"
                # if toggle_node_size_by_part_cost:
                #     date_str += f" -- {money(df_job_part_cost_by_op.loc[df_job_part_cost_by_op['Operation'] == op].iloc[0]['TotalPartCostOp'])}"
                date_str += f" -- {money(row['ValueIssued' if complete else 'ValueBilled'])}"
                part_nodes.append(Node(
                    id=f"node_part_{i}_{j}",
                    title=f"{row['StockCode']} - {row['StockDescription']} - {date_str}",
                    # size=size_node_part,
                    size=get_size(1, row["Operation"], part_num=row["StockCode"]),
                    color=(colour_node_part_complete if complete else colour_node_part_needed).hex_code
                    ,
                    # level=op
                    # level=max(0, 2*(i-1)) + 1
                    # level=2*(i-1)
                    # level=date_2_level[date][1]
                    level=get_level(date if (selectbox_hierarchy == options_hierarchy[1]) else i, lvl=1)
                    # group=2 if complete else 1
                ))
                edges.append(Edge(
                    source=part_nodes[-1].id,
                    target=node_id,
                    title=f"({i=}, {j=})"
                ))
                df_job_parts.loc[j, "OpNode"] = node_id
                df_job_parts.loc[j, "OpPartNode"] = part_nodes[-1].id

            for j, row in df_op_parts_subs.iterrows():
                complete = row["Complete"]
                parent_job = row["Job"]
                date = row["TrnDate"]
                stock_code = row["StockCode"]
                if pd.isna(row["TrnDate"]):
                    date_str = "N/A"
                    date = max_date + datetime.timedelta(days=-1)
                else:
                    date_str = f"{row['TrnDate']:%x}"
                # if toggle_node_size_by_part_cost:
                #     # date_str += f" -- {money(df_job_part_cost_by_op.loc[df_job_part_cost_by_op['Operation'] == op].iloc[0]['TotalPartCostOp'])}"
                date_str += f" -- {money(row['ValueIssued' if complete else 'ValueBilled'])}"
                # st.write(f"{j=}, {parent_job=}")
                df_job_sub_part = df_job_parts.loc[
                    (df_job_parts["WO"] == selectbox_job)
                    & (df_job_parts["StockCode"] == stock_code)
                    ]
                # st.write(f"SUBS {i=}, {j=}")
                # st.write(df_job_sub_part)
                if (not df_job_sub_part.empty) or 1:
                    part_node_id = df_job_sub_part.iloc[0]["OpPartNode"]
                    # st.write(f"{part_node_id=}")
                    part_subs_nodes.append(Node(
                        id=f"node_part_sub_{i}_{j}",
                        title=f"{row['SubStockCode']} - {row['SubStockDescription']} - {date_str}",
                        # size=size_node_part_sub,
                        size=get_size(2, row["Operation"], part_num=row["StockCode"]),
                        color=(colour_node_part_subs_complete if complete else colour_node_part_subs_needed).hex_code
                        ,
                        # level=op
                        # level=max(0, 2*(i-1)) + 1
                        # level=2*(i-1)
                        # level=date_2_level[date][2]
                        level=get_level(date if (selectbox_hierarchy == options_hierarchy[1]) else i, lvl=2)
                        # group=2 if complete else 1
                    ))
                    edges.append(Edge(
                        source=part_subs_nodes[-1].id,
                        target=part_node_id,
                        title=f"({i=}, {j=})"
                    ))

        with st.container(border=1, height=1200):
            nodes = op_nodes + part_nodes + part_subs_nodes
            columns_graph = st.columns([2/3, 1/3])
            with columns_graph[0]:
                if not nodes:
                    st.write("No Nodes!")
                if not edges:
                    st.write("No Edges!")
                graph = agraph(
                    nodes=nodes,
                    edges=edges,
                    config=config
                )
            with columns_graph[1]:
                # st.write("graph")
                # st.write(graph)
                if graph:
                    df_op_node_sel = df_job_parts.loc[
                        (df_job_parts["OpNode"] == graph)
                        | (df_job_parts["OpPartNode"] == graph)
                    ]
                    st.write("df_op_node_sel:")
                    st.dataframe(
                        df_op_node_sel,
                        selection_mode="single-row",
                        hide_index=True
                    )
                    stock_codes = df_op_node_sel["StockCode"].dropna().unique().tolist()
                    standard_drawings = load_part_standard(stock_codes)
                    pdf_drawings = load_part_drawing(stock_codes)
                    # st.write("standard_drawings")
                    # st.write(standard_drawings)
                    if standard_drawings:
                        selectbox_drawing_sel = st.selectbox(
                            label="Choose a drawing",
                            options=[tup[-1] for tup in standard_drawings]
                        )
                        if selectbox_drawing_sel:
                            # st.write("selectbox_drawing_sel")
                            # st.write(selectbox_drawing_sel)
                            st.warning("#TODO -- 20250312 -- Finish STL widget")

                            # dwg_path = os.path.join("temp", selectbox_drawing_sel)
                            # dxf_path = dwg_path.replace(".dwg", ".dxf")
                            # stl_path = dwg_path.replace(".dwg", ".stl")
                            #
                            # # Save uploaded file
                            # with open(dwg_path, "wb") as f:
                            #     f.write(uploaded_file.getbuffer())
                            #
                            # # Convert DWG → DXF
                            # dxf_file = convert_dwg_to_dxf(dwg_path, dxf_path)
                            #
                            # if dxf_file:
                            #     # Convert DXF → STL
                            #     stl_file = convert_dxf_to_stl(dxf_file, stl_path)
                            #
                            #     if stl_file:
                            #         st.success("Conversion successful!")
                            #         stl(stl_file, width=500, height=500)  # Display in Streamlit
                            #     else:
                            #         st.error("STL conversion failed.")
                            # else:
                            #     st.error("DXF conversion failed.")

                    # st.write("pdf_drawings")
                    # st.write(pdf_drawings)
                    pdf_options = [tup[-1] for tup in pdf_drawings]
                    if pdf_drawings:
                        selectbox_pdf_sel = st.selectbox(
                            label="Choose a drawing",
                            options=pdf_options
                        )
                        if selectbox_pdf_sel:
                            # st.write("selectbox_pdf_sel")
                            # st.write(selectbox_pdf_sel)
                            idx = pdf_options.index(selectbox_pdf_sel)
                            path = os.path.join(*pdf_drawings[idx])
                            st_pdf_viewer = pdf_viewer(
                                input=load_pdf(path)
                            )
                            st.warning("#TODO -- 20250312 -- PDF search too generic")

                else:
                    st.write("Select a Node first.")

st.session_state.update({k_pills_operation_mode: options_pills.index(pills_operation_mode)})
