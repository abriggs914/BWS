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

    # df = connect("SELECT * FROM [IT Requests] LEFT JOIN [Department] ON [IT Requests].[Department] = [Department].[Dept ID]")
    # df = connect("exec sp_BudgetCostVariance_AllCurrentProposedUnits 'December 31 2019', '1.5', '1', '1'")
    df = connect("exec [sp_DSR_ACD_PygWalker2023_10_04]")
    # conn = st.experimental_connection(
    #     "BWSdb",
    #     type="sql",
    #     # url="server3://user5:M@gic456@localhost:3306/BWSdb"
    #     # url="server3://user5:M@gic456@localhost/BWSdb"
    #     # url="mssql://user5:M@gic456@localhost/BWSdb"
    #     # url="mssql://user5:M@gic456@localhost/Server3/BWSdb"
    #     # url="mssql://user5:M@gic456@localhost/Server3"
    #     # url="mssql://user5:M@gic456@localhost:1433/Server3"
    #     # url="mssql+pyodbc://user5:M@gic456@localhost:1433/Server3"
    #     # url="mssql+pyodbc://user5:M@gic456@localhost:1433/BWSdb"
    #     # url="mssql://user5:M@gic456@localhost:1433/Server3/BWSdb"
    #
    #     # mssql://[Server_Name[:Portno]]/[Database_Instance_Name]/[Database_Name]?FailoverPartner=[Partner_Server_Name]&InboundId=[Inbound_ID]
    #     url="mssql://Server3:1433/user5:M@gic456@localhost:1433/Server3/BWSdb"
    # )
    # df = conn.query("SELECT * FROM [IT Requests] LEFT JOIN [Department] ON [IT Requests].[Department] = [Department].[Dept ID]")

    pyg_html = pyg.walk(df, return_html=True)

    components.html(pyg_html, height=1000, scrolling=True)
