import streamlit as st
import pygwalker as pyg
from pyodbc_connection import *
import streamlit.components.v1 as components
import matplotlib.pyplot as plt

if __name__ == '__main__':

    title = "Sales Forecasting Dashboard"

    st.set_page_config(
        page_title=title,
        layout="wide"
    )

    st.title(title)

    df = connect("""
SELECT
	*
FROM
	[v_SFC_OrdersData]
;
""")

    # for Pygwalker visualizer
    # pyg_html = pyg.walk(df, return_html=True)
    # components.html(pyg_html, height=1000, scrolling=True)
