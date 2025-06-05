import os.path
import re
from difflib import SequenceMatcher

import pandas as pd
import streamlit
import unicodedata

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


file_nicknames = r"C:\access\streamlit_syspro_nicknames.txt"


st.set_page_config(
	layout="wide"
)

k_bins_to_use: str = "k_bins_to_use"
k_empty_df: str = "k_empty_df"

key = f"k_multiselect_bins"
c_key = f"c_ms_tag_choices"
k_match_strictness = "k_match_strictness"

for k, dv in [
	(k_bins_to_use, None),
	(k_empty_df, None),
	(key, None),
	(c_key, None),
	(k_match_strictness, 50 )
]:
	st.session_state.setdefault(k, dv)

# df_inventory_bws_raw: pd.DataFrame = load_inventory_bws()
# df_inventory_stg_raw: pd.DataFrame = load_inventory_stg()


k_toggle_physical_all: str = "k_toggle_physical_all"
k_toggle_physical_uphill: str = "k_toggle_physical_uphill"
k_toggle_physical_downhill: str = "k_toggle_physical_downhill"


def update_toggle_physical_all():
	val = st.session_state.get(k_toggle_physical_all)
	st.session_state.update({
		k_toggle_physical_uphill: val,
		k_toggle_physical_downhill: val
	})


def update_toggle_physical_downhill():
	dh = st.session_state.get(k_toggle_physical_downhill)
	uh = st.session_state.get(k_toggle_physical_uphill)
	al = st.session_state.get(k_toggle_physical_all)
	st.session_state.update({
		k_toggle_physical_uphill: uh,
		k_toggle_physical_all: dh and uh
	})


def update_toggle_physical_uphill():
	dh = st.session_state.get(k_toggle_physical_downhill)
	uh = st.session_state.get(k_toggle_physical_uphill)
	al = st.session_state.get(k_toggle_physical_all)
	st.session_state.update({
		k_toggle_physical_downhill: dh,
		k_toggle_physical_all: uh and dh
	})


cols_controls = st.columns([0.4, 0.6])

with cols_controls[0]:
	toggle_comp_bws = st.toggle(
		label=":red[BWS]",
		value=True
	)

	toggle_comp_stg = st.toggle(
		label=":blue[STG]",
		value=True
	)

	st.divider()

	st.session_state.setdefault("k_toggle_allow_partial_search", True)
	toggle_allow_partial_search = st.toggle(
		label="Partial Match?",
		key="k_toggle_allow_partial_search"
	)

	with st.container(border=True):
		st.session_state.setdefault(k_toggle_physical_all, False)
		toggle_all_bins = st.toggle(
			label="All Bins",
			key=k_toggle_physical_all,
			on_change=update_toggle_physical_all
		)
		st.session_state.setdefault(k_toggle_physical_downhill, True)
		toggle_physical_downhill = st.toggle(
			label="@ Hawkins",
			key=k_toggle_physical_downhill,
			on_change=update_toggle_physical_downhill
		)
		st.session_state.setdefault(k_toggle_physical_uphill, False)
		toggle_physical_uphill = st.toggle(
			label="@ Montana",
			key=k_toggle_physical_uphill,
			on_change=update_toggle_physical_uphill
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
	[IW].[QtyOnBackOrder],
	[IW].[Supplier],
	[IM].[AlternateKey1],
	[IM].[AlternateKey2],
	[PC].[Description] AS [ProductClass],
	[AS].[SupplierName],
	[AS].[SupplierChName]
FROM
	[SysproCompanyA].[dbo].[InvMaster] [IM]
INNER JOIN
	[SysproCompanyA].[dbo].[InvWarehouse] [IW]
ON
	[IM].[StockCode] = [IW].[StockCode]
INNER JOIN
	[SysproCompanyA].[dbo].[SalProductClass] [PC]
ON
	[IM].[ProductClass] = [PC].[ProductClass]
INNER JOIN
	[SysproCompanyA].[dbo].[ApSupplier] [AS]
ON
	[IM].[Supplier] = [AS].[Supplier]
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
	[IW].[QtyOnBackOrder],
	[IW].[Supplier],
	[IM].[AlternateKey1],
	[IM].[AlternateKey2],
	[PC].[Description] AS [ProductClass],
	[AS].[SupplierName],
	[AS].[SupplierChName]
FROM
	[SysproCompanyS].[dbo].[InvMaster] [IM]
INNER JOIN
	[SysproCompanyS].[dbo].[InvWarehouse] [IW]
ON
	[IM].[StockCode] = [IW].[StockCode]
INNER JOIN
	[SysproCompanyS].[dbo].[SalProductClass] [PC]
ON
	[IM].[ProductClass] = [PC].[ProductClass]
INNER JOIN
	[SysproCompanyS].[dbo].[ApSupplier] [AS]
ON
	[IM].[Supplier] = [AS].[Supplier]
;
	"""
	return connect(sql)


def load_sales_orders() -> pd.DataFrame:
	return load_sql_data(
		"SELECT * FROM [SysproCompanyA].[dbo].[v_OpenSalesOrders]",
		database="SysproCompanyA",
		uid="SRS",
		pwd=""
	)


def normalize_string(s):
	if pd.isna(s):
		return ""
	# Lowercase
	s = s.lower()
	# Remove accents
	s = unicodedata.normalize('NFKD', s).encode('ASCII', 'ignore').decode()
	# Remove all non-alphanumeric characters
	s = re.sub(r'[^a-z0-9]', '', s)
	return s


def determine_match(a: str, b: str, r_val: str = "ratio"):
	seq_match = SequenceMatcher(None, a, b)
	if r_val == "match":
		return seq_match
	else:
		return seq_match.ratio()


@streamlit.dialog(title="Submit Nickname", width="large")
def submit_nickname():
	delim = "__=__"
	txt = textbox_search
	entry_known_part = st.selectbox(
		label="Known Stockcode",
		options=list_stock_codes
	)

	st.write(f"Associate the term '{txt}' with {entry_known_part}'?")

	cols_btns = st.columns(2)
	if entry_known_part:
		with cols_btns[0]:
			if st.button(
				label="cancel"
			):
				st.rerun()
		with cols_btns[1]:
			if st.button(
				label="submit"
			):
				if not os.path.exists(file_nicknames):
					with open(file_nicknames, "w") as f:
						pass
				with open(file_nicknames, "a") as f:
					f.write(f"\t{delim}".join([txt, entry_known_part, f"{datetime.datetime.now():%Y-%m-%d %H:%M:%S}"]))
					
				st.rerun()


df_inventory = load_inventory()

# st.write("df_inventory")
# st.write(df_inventory)

col_stockcode: str = "StockCode"
col_stock_desc: str = "Description"
col_stock_long_desc: str = "LongDesc"
col_supplier: str = "Supplier"
col_alt_key_1: str = "AlternateKey1"
col_alt_key_2: str = "AlternateKey2"
col_product_class: str = "ProductClass"
col_supplier_name: str = "SupplierName"
col_supplier_ch_Name: str = "SupplierChName"
col_bin: str = "DefaultBin"
col_company: str = "Comp"
list_stock_codes = df_inventory[col_stockcode].dropna().unique().tolist()

list_cols_to_check = [col_stockcode, col_stock_desc, col_stock_long_desc, col_supplier, col_alt_key_1, col_alt_key_2, col_product_class, col_supplier_name, col_supplier_ch_Name]
for col in list_cols_to_check:
	df_inventory[f"{col}_norm"] = df_inventory[col].apply(normalize_string)

list_known_bins_hawkins: list[str] = [
	"a", "b", "c", "d", "e", "f", "g", "i", "r"
]
list_known_bins_montana: list[str] = [
	"wh4"
]
list_bins_hawkins: list[str] = [
	b for b in
	df_inventory[col_bin].dropna().unique().tolist()
	if any([
		b.lower().strip().startswith(kb) for kb in list_known_bins_hawkins
	])
]
list_bins_montana: list[str] = [
	b for b in
	df_inventory[col_bin].dropna().unique().tolist()
	if any([
		b.lower().strip().startswith(kb) for kb in list_known_bins_montana
	])
]

# display_df(
# 	df_inventory,
# 	"df_inventory A"
# )

with cols_controls[1]:
	options_mode = ["Select", "Search", "Sales Orders"]
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

	with cols_controls[1]:
		textbox_search = st.text_input(
			label="Search:",
			key="k_textbox_search",
			on_change=lambda : st.session_state.pop(key)
			# ,
			# on_change=lambda : st.session_state.pop(key)
		)

		match_strictness = st.select_slider(
			label="match strictness",
			# min_value=0,
			# max_value=100,
			options=[x * 10 for x in range(11)],
			key=k_match_strictness
		)

		if textbox_search:
			# if st.button(
			# 		label="search"
			# ):

			# df_search_part = df_inventory.loc[
			# 	(
			# 			(df_inventory[col_stockcode].str.lower().str.strip() == textbox_search)
			# 			| (df_inventory[col_stock_desc].str.lower().str.strip() == textbox_search)
			# 			| (df_inventory[col_stock_long_desc].str.lower().str.strip() == textbox_search)
			# 	)
			# 	| (
			# 			toggle_allow_partial_search
			# 			& (
			# 					(df_inventory[col_stockcode].str.lower().str.strip().str.contains(
			# 						textbox_search.lower().strip()))
			# 					| (df_inventory[col_stock_desc].str.lower().str.strip().str.contains(
			# 				textbox_search.lower().strip()))
			# 					| (df_inventory[col_stock_long_desc].str.lower().str.strip().str.contains(
			# 				textbox_search.lower().strip()))
			# 			)
			# 	)
			# 	]

			s_term = textbox_search.lower().strip()
			s_terms = textbox_search.lower().strip().split()
			mask_exact = (
					(df_inventory[col_stockcode] == s_term) |
					(df_inventory[col_stock_desc] == s_term) |
					(df_inventory[col_stock_long_desc] == s_term) |
					(df_inventory[col_supplier] == s_term) |
					(df_inventory[col_alt_key_1] == s_term) |
					(df_inventory[col_alt_key_2] == s_term)
			)

			# mask_partial = (
			# 	df_inventory[f"{col_stockcode}_norm"].str.lower().str.strip().str.contains(normalize_string(s_term)) |
			# 	df_inventory[f"{col_stock_desc}_norm"].str.lower().str.strip().str.contains(normalize_string(s_term)) |
			# 	df_inventory[f"{col_stock_long_desc}_norm"].str.lower().str.strip().str.contains(normalize_string(s_term))
			# )

			for col in list_cols_to_check:
				df_inventory[f"{col}_norm_a"] = df_inventory[f"{col}_norm"].apply(lambda s: determine_match(s, normalize_string(s_term)))

			# df_inventory["sum_norm_a"] = df_inventory[f"{col_stockcode}_norm_a"] + df_inventory[f"{col_stock_desc}_norm_a"] + df_inventory[f"{col_stock_long_desc}_norm_a"] + df_inventory[f"{col_supplier}_norm_a"]
			df_inventory["sum_norm_a"] = sum([df_inventory[f"{col}_norm_a"] for col in list_cols_to_check])
			level = match_strictness / 100
			level *= len(list_cols_to_check)
			mask_partial = (
					(df_inventory["sum_norm_a"]) >= level
			)

			df_search_part = df_inventory.loc[
				mask_exact | (toggle_allow_partial_search and mask_partial)
				]

			if df_search_part.empty and len(s_terms) > 1:
				dfs = []
				for i, s_term in enumerate(s_terms):
					mask_exact = (
							(df_inventory[col_stockcode] == s_term) |
							(df_inventory[col_stock_desc] == s_term) |
							(df_inventory[col_stock_long_desc] == s_term) |
							(df_inventory[col_supplier] == s_term) |
							(df_inventory[col_alt_key_1] == s_term) |
							(df_inventory[col_alt_key_2] == s_term)
					)

					mask_partial = (
							df_inventory[f"{col_stockcode}_norm"].str.lower().str.strip().str.contains(
								normalize_string(s_term)) |
							df_inventory[f"{col_stock_desc}_norm"].str.lower().str.strip().str.contains(
								normalize_string(s_term)) |
							df_inventory[f"{col_stock_long_desc}_norm"].str.lower().str.strip().str.contains(
								normalize_string(s_term)) |
							df_inventory[f"{col_supplier}_norm"].str.lower().str.strip().str.contains(
								normalize_string(s_term)) |
							df_inventory[f"{col_alt_key_1}_norm"].str.lower().str.strip().str.contains(
								normalize_string(s_term)) |
							df_inventory[f"{col_alt_key_2}_norm"].str.lower().str.strip().str.contains(
								normalize_string(s_term))
					)

					dfs.append(df_inventory.loc[
								   mask_exact | (toggle_allow_partial_search and mask_partial)
								   ])

				df_search_part = pd.concat(dfs)

			# display_df(
			# 	df_search_part,
			# 	f"Matching parts for '{s_term}'"
			# )

			if not toggle_all_bins:
				if toggle_physical_downhill and toggle_physical_uphill:
					df_search_part = df_search_part.loc[
						(df_search_part[col_bin].isin(list_bins_hawkins))
						| (df_search_part[col_bin].isin(list_bins_montana))
						]
				elif toggle_physical_uphill:
					df_search_part = df_search_part.loc[
						df_search_part[col_bin].isin(list_bins_montana)
					]
				else:
					df_search_part = df_search_part.loc[
						df_search_part[col_bin].isin(list_bins_hawkins)
					]

			list_of_bins = [b for b in sorted(df_search_part[col_bin].dropna().unique().tolist()) if len(b.strip())]

			if not list_of_bins:
				st.info(f"Could not find any parts matching '{textbox_search}'.")

			# bins_to_use = st.session_state.setdefault(k_bins_to_use, list_of_bins)
			list_companies = []
			if toggle_comp_bws:
				list_companies.append("BWS")
			if toggle_comp_stg:
				list_companies.append("STG")

			if st.session_state.get(c_key) is not None:
				# print(f"INSERT {st.session_state.get(c_key)}")
				st.session_state.update({
					key: st.session_state.get(c_key),
					c_key: None
				})

			if (key not in st.session_state) or (st.session_state.get(key) is None) or st.session_state.get(k_empty_df, False):
				st.session_state.update({key: list_of_bins})
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
		else:
			df_search = pd.DataFrame(columns=['No Data'])

		if df_search.empty:
			if st.button(
				label="submit nickname",
				key=f"k_button_submit_nickname"
			):
				submit_nickname()

	df_search.rename(
		columns={
			col: col.replace("Qty", "").replace("qty", "").replace("QTY", "")
			for col in df_search.columns
			if col.lower().startswith("qty")
		},
		inplace=True
	)
	show_cols = [c for c in df_search.columns if not c.lower().endswith("_norm")]
	# comp, stockcode, description, longdesc, defaultbin, qtyallocated, qtyonhand, qtyonorder, qtyonbackorder
	col_widths = [50, 150, 225, 300, 65, 25, 25, 25, 25]
	display_df(
		df_search[show_cols],
		"df_search",
		width=1500,
		column_config={sc: {"width": w} for sc, w in zip(show_cols, col_widths)}
	)

	st.session_state.update({k_empty_df: df_search.empty})

elif pills_mode == options_mode[2]:
	# Sales Orders
	df_sales_orders = load_sales_orders()
	display_df(
		df_sales_orders,
		"Sales Orders",
		width=1500
	)
