import os.path
import sys

import pandas as pd
import streamlit as st


@st.cache_data(ttl=3600)
def load_data():
    # with open(path_spreadsheet1, "rb", encoding=sys.getfilesystemencoding()) as f:
    with open(path_spreadsheet1, "rb") as f:
        df1 = pd.read_excel(f, "Sheet1")
    with open(path_spreadsheet2, "rb") as f:
        df2 = pd.read_excel(f)
    with open(path_spreadsheet3, "rb") as f:
        df3 = pd.read_excel(f)

    return df1, df2, df3


if __name__ == '__main__':

    st.set_page_config(page_title="Parts Inventory Spreadsheets", layout="wide")
    st.title("Parts Inventory Spreadsheets")

    if "choice_side_by_side" not in st.session_state:
        st.session_state["choice_side_by_side"] = False

    st.toggle(
        label="side-by-side",
        key="choice_side_by_side",
        help="Move the charts next to each other or keep in vertical line."
    )

    path_spreadsheet1 = r"\\nas1.bwsdomain.local\public\PARTS\FPYT.xlsx"
    path_spreadsheet2 = r"\\nas1.bwsdomain.local\public\PARTS\MISSING PARTS.xlsx"
    path_spreadsheet3 = r"\\nas1.bwsdomain.local\public\PARTS\TRAILER KIT YT.xlsx"

    df1, df2, df3 = load_data()

    if sbs := st.session_state["choice_side_by_side"]:
        col1, col2, col3 = st.columns(3)

    for i, itms in enumerate({
        path_spreadsheet1: df1,
        path_spreadsheet2: df2,
        path_spreadsheet3: df3
    }.items()):
        pth, df = itms

        if sbs:
            col = eval(f"col{i+1}")
            col.markdown(f"## {os.path.basename(pth)}")
            col.dataframe(
                df,
                height=750,
                use_container_width=True
            )
        else:
            st.markdown(f"## {os.path.basename(pth)}")
            st.dataframe(
                df,
                height=750,
                use_container_width=True
            )
