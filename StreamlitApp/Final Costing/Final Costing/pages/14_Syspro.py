import streamlit_utility_bws
from streamlit_utility_bws import *
from streamlit_utility import *
from streamlit_pills import pills

# inventory query
# job query
# issue parts to job
# issue parts to movements (lines, or over multiple jobs)
# Known delayed items
# interruptions


st.set_page_config(
	layout="wide"
)

k_bins_to_use: str = "k_bins_to_use"


# df_inventory_bws_raw: pd.DataFrame = load_inventory_bws()
# df_inventory_stg_raw: pd.DataFrame = load_inventory_stg()

toggle_comp_bws = st.toggle(
	label=":red[BWS]",
	value=True
)

toggle_comp_stg = st.toggle(
	label=":blue[STG]",
	value=True
)

# if toggle_comp_bws and (not toggle_comp_stg):
# 	df_inventory: pd.DataFrame = df_inventory_bws_raw
#
# elif (not toggle_comp_bws) and toggle_comp_stg:
# 	df_inventory: pd.DataFrame = df_inventory_stg_raw
#
# else:
# 	df_inventory: pd.DataFrame = pd.concat([
# 		df_inventory_bws_raw,
# 		df_inventory_stg_raw
# 	])


@st.cache_data(ttl=None)
def load_inventory():
	sql = """
SELECT
		'BWS' AS [Comp],
		[IM].[StockCode],
		[IM].[Description],
		[IM].[LongDesc],
		[IW].[DefaultBin],
		[IW].[QtyAllocated],
		[IW].[QtyOnHand],
		[IW].[QtyOnOrder],
		[IW].[QtyOnBackOrder]
	FROM
		[SysproCompanyA].[dbo].[InvMaster] [IM]
	INNER JOIN
		[SysproCompanyA].[dbo].[InvWarehouse] [IW]
	ON
		[IM].[StockCode] = [IW].[StockCode]
	UNION
	SELECT
		'STG' AS [Comp],
		[IM].[StockCode],
		[IM].[Description],
		[IM].[LongDesc],
		[IW].[DefaultBin],
		[IW].[QtyAllocated],
		[IW].[QtyOnHand],
		[IW].[QtyOnOrder],
		[IW].[QtyOnBackOrder]
	FROM
		[SysproCompanyS].[dbo].[InvMaster] [IM]
	INNER JOIN
		[SysproCompanyS].[dbo].[InvWarehouse] [IW]
	ON
		[IM].[StockCode] = [IW].[StockCode]
	"""
	return connect(sql)


df_inventory = load_inventory()

# st.write(df_inventory)
# st.write("df_inventory")

col_stockcode: str = "StockCode"
col_stock_desc: str = "Description"
col_stock_long_desc: str = "LongDesc"
col_bin: str = "DefaultBin"
col_company: str = "Comp"
list_stock_codes = df_inventory[col_stockcode].dropna().unique().tolist()

options_mode = ["Select", "Search"]
st.session_state.setdefault("k_pills_mode", 1)
pills_mode = pills(
	label="Mode",
	options=options_mode,
	key=f"k_pills_mode"
)

if pills_mode == options_mode[0]:

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

elif pills_mode == options_mode[1]:

	textbox_search = st.text_input(
		label="Search:",
		key="k_textbox_search"
		# ,
		# on_change=lambda : st.session_state.pop(key)
	)
	st.session_state.setdefault("k_toggle_allow_partial_search", True)
	toggle_allow_partial_search = st.toggle(
		label="Partial Match?",
		key="k_toggle_allow_partial_search"
	)

	if textbox_search:
		# if st.button(
		# 		label="search"
		# ):

		df_search_part = df_inventory.loc[
			(
					(df_inventory[col_stockcode].str.lower().str.strip() == textbox_search)
					| (df_inventory[col_stock_desc].str.lower().str.strip() == textbox_search)
					| (df_inventory[col_stock_long_desc].str.lower().str.strip() == textbox_search)
			)
			| (
					toggle_allow_partial_search
					& (
							(df_inventory[col_stockcode].str.lower().str.strip().str.contains(textbox_search.lower().strip()))
							| (df_inventory[col_stock_desc].str.lower().str.strip().str.contains(textbox_search.lower().strip()))
							| (df_inventory[col_stock_long_desc].str.lower().str.strip().str.contains(textbox_search.lower().strip()))
				   )
			)
		]
		list_of_bins = [b for b in sorted(df_search_part[col_bin].dropna().unique().tolist()) if len(b.strip())]
		# bins_to_use = st.session_state.setdefault(k_bins_to_use, list_of_bins)
		list_companies = []
		if toggle_comp_bws:
			list_companies.append("BWS")
		if toggle_comp_stg:
			list_companies.append("STG")

		key = f"k_multiselect_bins"
		c_key = f"c_ms_tag_choices"
		if st.session_state.get(c_key) is not None:
			# print(f"INSERT {st.session_state.get(c_key)}")
			st.session_state.update({
				key: st.session_state.get(c_key),
				c_key: None
			})

		st.session_state.setdefault(key, list_of_bins)
		# ms_tag_choices = st.multiselect(
        #     label="Tags",
        #     key=key,
        #     options=list_of_bins
        # )

		cols_btns = st.columns([0.15, 0.15, 0.7])
		with cols_btns[0]:
			if st.button(
					label="all",
					key=f"btn_add_all_bins"
			):
				st.session_state.update({key: list_of_bins})

		with cols_btns[1]:
			if st.button(
					label="none",
					key=f"btn_remove_all_bins"
			):
				st.session_state.update({key: []})

		with cols_btns[2]:
			multiselect_bins = st.multiselect(
				label="Bins",
				options=list_of_bins,
				key=key
			)

		df_search = df_search_part.loc[
			df_search_part[col_bin].isin(multiselect_bins)
		]
		df_search = df_search.loc[
			df_search[col_company].isin(list_companies)
		]
		display_df(
			df_search,
			"df_search",
			width=1200
		)
