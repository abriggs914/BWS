import os

import pandas as pd
import streamlit as st
from streamlit_utility import display_df

import streamlit_auth_sql as auth
########################################################################
# Begin Auth Boilerplate

APP_NAME: str = st.secrets["app"]['app_name']
PAGE_NAME: str = f"{APP_NAME}_monitoring_schedule"

if not auth.st_auth(APP_NAME):
	st.info(f"Please contact Avery for further help with registering for this program.")
	# Go no further
	st.stop()

admin_end_users = ["abriggs"]
admin_test_users = ["rec"] + admin_end_users
user = st.session_state.get("user", "??")

if user in admin_test_users:
	with st.sidebar:
		if st.button(
			label="Clear Cache & Rerun",
			key=f"k_clear_cache_rerun"
		):
			st.cache_data.clear()
			st.cache_resource.clear()
			st.rerun()
		with st.popover("session_state"):
			info_dict = auth.load_session_state_info()
			st.write(info_dict)

# if st.button("change password"):
with st.popover("change password"):
	if auth.show_change_password(APP_NAME):
		st.rerun()

# End Auth Boilerplate
########################################################################


root_location_bws = r"\\server4\Design\VaultWorkspace_BWS\PDFS"
root_location_stg = r"\\stgdc01\Public\STARGATE PDFS"

st.set_page_config(layout="wide")


MAX_QUERY_HOLD_TIME: float = 2.5 * 60 * 60  # in seconds


@st.cache_data(ttl=MAX_QUERY_HOLD_TIME)
def hold_walk_bws():
    # SUPER SLOW
    return list(os.walk(root_location_bws))


@st.cache_data(ttl=MAX_QUERY_HOLD_TIME)
def hold_walk_stg():
    # SUPER SLOW
    return list(os.walk(root_location_stg))


@st.cache_data(ttl=MAX_QUERY_HOLD_TIME)
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
