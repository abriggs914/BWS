import os

import pandas as pd
import streamlit as st
from streamlit_utility import display_df


root_location_bws = r"\\server4\Design\VaultWorkspace_BWS\PDFS"
root_location_stg = r"\\stgdc01\Public\STARGATE PDFS"

st.set_page_config(layout="wide")


@st.cache_data(ttl=60*60)
def hold_walk_bws():
    # SUPER SLOW
    return list(os.walk(root_location_bws))


@st.cache_data(ttl=60*60)
def hold_walk_stg():
    # SUPER SLOW
    return list(os.walk(root_location_stg))


@st.cache_data(ttl=60*60)
def gather_parts() -> pd.DataFrame:
    walk_bws = hold_walk_bws()
    walk_stg = hold_walk_stg()

    parts = []
    for dir_path, dir_names, file_names in walk_bws:
        # st.write(f"{len(file_names)=}, {file_names[:5]:}")
        for file in file_names:
            if file.lower().endswith(".pdf"):
                stock_code = os.path.basename(file).removesuffix(".pdf")
                parts.append({
                    "StockCode": stock_code,
                    "Path": os.path.join(dir_path, file)
                })
    
    df = pd.DataFrame(parts)
    if df.empty:
        df.columns = ["StockCode", "Path"]
    return df


@st.cache_data(ttl=None)
def get_pdf(path):
    with open(path, "rb") as f:
        return f.read()


df_parts = gather_parts()

# display_df(
#     df_parts,
#     "df_parts"
# )

list_parts: list[str] = df_parts["StockCode"].unique().tolist()

st.header("Part Search:")

multiselect_parts = st.multiselect(
    label="Enter Parts:",
    options=list_parts,
    max_selections=5
)

if multiselect_parts:
    df_sel_parts = df_parts.loc[
        df_parts["StockCode"].isin(multiselect_parts)
    ]

    display_df(
        df_sel_parts,
        "Selected Parts:"
    )

    st.divider()

    for i, row in df_sel_parts.iterrows():
        dowbload_button = st.download_button(
            label=f'Download "{row["StockCode"]}"',
            data=get_pdf(row["Path"]),
            file_name=row["StockCode"].removesuffix(".pdf") + ".pdf",
            key=f"download_button_{i}",
            mime="application/pdf"
        )
