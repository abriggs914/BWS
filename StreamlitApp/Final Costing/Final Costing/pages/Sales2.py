# Version 2025-02-11 1300

import os
import datetime
import subprocess

import pandas as pd
import pdfplumber

import streamlit as st

from streamlit_pdf_viewer import pdf_viewer

from pyodbc_connection import connect
from streamlit_utility import screen_dimensions

s_w, s_h = screen_dimensions()

if s_h is None or not s_h:
	s_h = 900
if s_w is None or not s_w:
	s_w = 1600

root_path = r"\\bwsfp01\public\SALES OFFICE\Weekly WO Meetings"


@st.cache_data(ttl=None, show_spinner=True)
def load_meetings():
	return connect("WSOM_Meetings")


@st.cache_data(ttl=None, show_spinner=True)
def load_products():
	return connect("Products")


@st.cache_data(ttl=None, show_spinner=True)
def load_orders():
	return connect("Orders")


@st.cache_data(ttl=None, show_spinner=True)
def load_meeting_notes():
	return connect("WSOM_MeetingNotes")


df_products = load_products()
df_orders = load_orders()
df_meetings = load_meetings()
df_meeting_notes = load_meeting_notes()