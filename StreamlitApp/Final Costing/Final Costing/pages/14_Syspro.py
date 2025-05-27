from streamlit_utility_bws import *
from streamlit_utility import *


# inventory query
# job query
# issue parts to job
# issue parts to movements (lines, or over multiple jobs)
# Known delayed items
# interruptions


df_inventory_bws_raw: pd.DataFrame = load_inventory_bws()
df_inventory_stg_raw: pd.DataFrame = load_inventory_stg()


toggle_comp_bws = st.toggle(
    label=":red[BWS]",
    value=True
)

toggle_comp_stg = st.toggle(
    label=":blue[STG]",
    value=True
)

if toggle_comp_bws and (not toggle_comp_stg):
    df_inventory: pd.DataFrame = df_inventory_bws_raw

elif (not toggle_comp_bws) and toggle_comp_stg:
    df_inventory: pd.DataFrame = df_inventory_stg_raw

else:
    df_inventory: pd.DataFrame = pd.concat([
        df_inventory_bws_raw,
        df_inventory_stg_raw
    ])

col_stockcode: str = "StockCode"
list_stock_codes = df_inventory[col_stockcode].dropna().unique().tolist()


with st.container(border=True):
    st.write("Inventory Query")
    st.write("list_stock_codes")
    st.write(list_stock_codes[:50])
    selectbox_stock_code = st.selectbox(
        label="StockCode",
        key="k_selectbox_stock_code",
        options=list_stock_codes,
        label_visibility="hidden"
    )

    if selectbox_stock_code:
        sel_stock_code = selectbox_stock_code
        df_sel_stock_code = df_inventory.loc[df_inventory[col_stockcode] == sel_stock_code]
        display_df(
            df_sel_stock_code,
            "df_sel_stock_code"
        )
