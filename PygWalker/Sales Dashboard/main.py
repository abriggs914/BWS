import pygwalker as pyg
from pyodbc_connection import *
import streamlit as st
import streamlit.components.v1 as components


# https://www.youtube.com/watch?v=ogyxjkYRgPE&t=988s


if __name__ == '__main__':

    title = "IT Requests Streamlit + PygWalker Demo"

    st.set_page_config(
        page_title=title,
        layout="wide"
    )

    st.title(title)

    df = connect("""
SELECT
	'v_ADG Latest Accessors' AS [Table],
	'TotalAccesses' AS [By],
	*
FROM
	[BWSdb].[dbo].[v_ADG Latest Accessors]
ORDER BY
	[TotalAccesses] DESC
;
""")

    pyg_html = pyg.walk(df, return_html=True)

    components.html(pyg_html, height=1000, scrolling=True)