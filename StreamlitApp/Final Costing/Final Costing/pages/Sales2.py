# Version 2025-02-11 1300

import os
import datetime
import subprocess
from typing import Literal

import pandas as pd
import pdfplumber
import pyodbc

import streamlit as st

from streamlit_pdf_viewer import pdf_viewer

from pyodbc_connection import connect
from streamlit_utility import screen_dimensions, display_df

s_w, s_h = screen_dimensions()

if s_h is None or not s_h:
	s_h = 900
if s_w is None or not s_w:
	s_w = 1600

root_path = r"\\bwsfp01\public\SALES OFFICE\Weekly WO Meetings"


def connection_string_template(
		driver: str = "{SQL Server}",
		server: str = "server3",
		database: str = "BWSdb",
		uid: str = "user5",
		pwd: str = "M@gic456"
) -> str:
	template = "DRIVER={dri};SERVER={svr};DATABASE={db};UID={uid};PWD={pwd}"
	# params = [driver, server, database, uid, pwd]
	if pwd and uid is None:
		raise ValueError("Error you must pass both a username and a password. Got only a password.")
	if uid and pwd is None:
		raise ValueError("Error you must pass both a username and a password. Got only a username.")
	# print(f"before {template=}")
	cstr = template.format(dri=driver, svr=server, db=database, uid=uid, pwd=pwd)
	return cstr


def get_conn_crsr(cstr: str, timeout: int):
	conn = pyodbc.connect(cstr, timeout=timeout)
	crsr = conn.cursor()
	return conn, crsr


@st.cache_resource
def pyodbc_connection_bws(
		timeout: int = 0
):
	return get_conn_crsr(connection_string_template(), timeout)


@st.cache_resource
def pyodbc_connection_stg(
		timeout: int = 0
):
	return get_conn_crsr(
		connection_string_template(
			database="Stargatedb",
			uid="SGeu1",
			pwd="Pupplies-Hagard->Rio0"
		),
		timeout
	)


@st.cache_resource
def pyodbc_connection_syspro_a(
		timeout: int = 0
):
	return get_conn_crsr(
		connection_string_template(
			database="SysproCompanyA",
			uid="SRS",
			pwd=""
		),
		timeout
	)


@st.cache_resource
def pyodbc_connection_syspro_s(
		timeout: int = 0
):
	return get_conn_crsr(
		connection_string_template(
			database="SysproCompanyS",
			uid="SCSRS",
			pwd=""
		),
		timeout
	)


def query_server3(sql, mode: Literal["bws", "stg", "compa", "comps"] = "bws") -> pd.DataFrame:
	m = mode.lower().strip()
	if m == "stg":
		conn, crsr = pyodbc_connection_bws()
	elif m == "compa":
		conn, crsr = pyodbc_connection_syspro_a()
	elif m == "compa":
		conn, crsr = pyodbc_connection_syspro_s()
	else:
		conn, crsr = pyodbc_connection_bws()

	try:
		crsr.execute(sql)
		# df = pd.DataFrame(crsr.fetchall())
		# st.write(crsr.description)
		# # df.columns = [col for col in crsr.description[0]]
		columns = [column[0] for column in getattr(crsr, "description", [])]
		results = crsr.fetchall()
		df = pd.DataFrame.from_records(results, columns=columns)
		conn.commit()
	except:
		df = pd.DataFrame()

	return df


@st.cache_data(ttl=None, show_spinner=True)
def load_meetings() -> pd.DataFrame:
	sql = "SELECT * FROM [BWSdb].[dbo].[WSOM_Meetings]"
	return query_server3(sql, mode="bws")


@st.cache_data(ttl=None, show_spinner=True)
def load_inventory_bws() -> pd.DataFrame:
	sql = "SELECT * FROM [SysproCompanyA].[dbo].[InvMaster]"
	return query_server3(sql, mode="compa")


#
# @st.cache_data(ttl=None, show_spinner=True)
# def load_products():
# 	return connect("Products")
#
#
# @st.cache_data(ttl=None, show_spinner=True)
# def load_orders():
# 	return connect("Orders")
#
#
# @st.cache_data(ttl=None, show_spinner=True)
# def load_meeting_notes():
# 	return connect("WSOM_MeetingNotes")
#
#
# df_products = load_products()
# df_orders = load_orders()
# df_meetings = load_meetings()
# df_meeting_notes = load_meeting_notes()


df_wsom_meetings = load_meetings()
df_inventory_bws = load_inventory_bws()
display_df(
	df_wsom_meetings,
	"WSOM_Meetings"
)
display_df(
	df_inventory_bws,
	"df_inventory_bws"
)


list_of_stockcodes = df_inventory_bws["StockCode"].dropna().unique()

selectbox_stockcodes = st.selectbox(
	label="Select a Stockcode",
	options=list_of_stockcodes
)