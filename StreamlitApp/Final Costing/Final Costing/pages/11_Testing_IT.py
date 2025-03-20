import json
from typing import Optional, Literal

import pandas as pd
import streamlit as st
from streamlit_agraph import Node, agraph, Config, Edge

from colour_utility import Colour, gradient
from dataframe_utility import random_df
from pyodbc_connection import connect

from streamlit_sortables import sort_items

# -- 2025-03-19
# Gather the most frequent uses of each group and section
# Every model has their own set of groups and sections
#


st.set_page_config(
	layout="wide",
	page_title="Testing IT"
)


def display_df(
		df: pd.DataFrame,
		title: Optional[str] = None,
		hide_index: str | bool = "if_int",
		show_shape: bool = True
):
	title = title if title else ""
	shape = df.shape
	if show_shape:
		title = f"{title} ({shape[0]} Rows".strip()
		title += f" x {shape[1]} Cols)" if len(shape) > 1 else ")"

	if title:
		st.write(title)

	if hide_index == "if_int":
		hide_index = str(df.index.dtype).lower() == "int64"

	# st.write(f"{title=}, {hide_index=}")
	stdf = st.dataframe(
		data=df,
		hide_index=hide_index
	)
	return stdf


@st.cache_data(show_spinner=True, ttl=None)
def load_orders() -> pd.DataFrame:
	sql = ("""
SELECT
 	*
FROM
	[BWSdb].[dbo].[Orders]
WHERE
	[Decline/Rejected] = 4
""").strip()
	df = connect(
		sql=sql
	)

	df.sort_values(
		by=[clbl_o_orderDate],
		ascending=False,
		inplace=True
	)

	return df


@st.cache_data(show_spinner=True, ttl=None)
def load_df_groups_sections_os() -> pd.DataFrame:
# 	sql = """
# SELECT
# 	[OS].[SortG]
# 	,[OS].[Group]
# 	,[OS].[SortSe]
# 	,[OS].[Section]
# 	,COUNT(*) AS [CFreq]
# FROM
# 	[BWSdb].[dbo].[Order Standards] [OS] WITH (NOLOCK)
# GROUP BY
# 	[OS].[SortG]
# 	,[OS].[Group]
# 	,[OS].[SortSe]
# 	,[OS].[Section]
# ORDER BY
# 	[OS].[SortG]
# 	,[OS].[SortSe]
# ;
# 	"""
	sql = """
SELECT
	[P].[Grouping]
	,[P].[Class]
	,[P].[Model No]
	,[OS].[SortG]
	,[OS].[Group]
	,[OS].[SortSe]
	,[OS].[Section]
	,COUNT(*) AS [CFreq]
FROM
	[BWSdb].[dbo].[Order Standards] [OS] WITH (NOLOCK)
INNER JOIN
	[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
ON
	[OS].[Quote#] = [O].[Quote#]
INNER JOIN
	[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
ON
	[O].[ProductID] = [P].[IDTrailer]
WHERE
	([O].[Decline/Rejected] = 4)
	AND ([P].[Proposed] = 0)
	AND ([P].[Non-Current] = 0)
GROUP BY
	[P].[Grouping]
	,[P].[Class]
	,[P].[Model No]
	,[OS].[SortG]
	,[OS].[Group]
	,[OS].[SortSe]
	,[OS].[Section]
ORDER BY
	[P].[Grouping]
	,[P].[Class]
	,[P].[Model No]
	,[OS].[SortG]
	,[OS].[SortSe]
;
	"""

	df = connect(
		sql=sql
	)

	df[clbl_group] = df[clbl_group].map(lambda g: None if pd.isna(g) else g.title().strip())
	df[clbl_section] = df[clbl_section].map(lambda s: None if pd.isna(s) else s.title().strip())
	for invalid_val in [
		"none",
		"None",
		"null",
		"Null"
	]:
		df.replace(
			invalid_val,
			None,
			inplace=True
		)

	# Sort to prepare for pruning based on frequency
	df.sort_values(
		by=[clbl_sortG, clbl_sortSe, clbl_cFreq],
		ascending=[True, True, False],
		inplace=True
	)

	return df


clbl_modelNo: str = "Model No"
clbl_group: str = "Group"
clbl_section: str = "Section"
clbl_cFreq: str = "CFreq"
clbl_sortG: str = "SortG"
clbl_sortSe: str = "SortSe"
# Moved sorting and some baseline sanitizing to the cache function
df_groups_sections_os = load_df_groups_sections_os()

clbl_o_quote: str = "Quote#"
clbl_o_orderDate: str = "Order Date"
df_orders = load_orders()

display_df(
	df_groups_sections_os,
	"df_groups_sections_os"
)

display_df(
	df_orders,
	"df_orders"
)

display_df(
	df_groups_sections_os.describe(include="all"),
	"df_groups_sections_os Described",
	hide_index=False
)

df_order_model_counts = df_orders[clbl_modelNo].value_counts().reset_index().merge(
	df_orders[clbl_modelNo].value_counts(normalize=True).reset_index(),
	on=clbl_modelNo
)
count_models = len(df_order_model_counts[clbl_modelNo].dropna().unique())

st.write(f"{count_models=}")
# df_001 = df_groups_sections_os.groupby(
# 	by=[clbl_group]
# 	,
# 	as_index=False
# ).agg({
# 	clbl_modelNo: "count"
# }).rename(columns={
# 	clbl_modelNo: "NumOrders"
# })
# df_001["PctOrders"] = df_001["NumOrders"] / count_models
df_001 = df_groups_sections_os.value_counts([clbl_modelNo, clbl_group]).reset_index()
df_001.sort_values([clbl_modelNo, clbl_group], inplace=True)

df_002 = df_groups_sections_os.groupby(
	clbl_group,
	as_index=False
).value_counts([clbl_modelNo])

df_003 = df_groups_sections_os.value_counts([clbl_modelNo]).reset_index()

cc0 = st.columns(3)
with cc0[0]:
	display_df(df_001, "df_001")
with cc0[1]:
	display_df(df_002, "df_002")
with cc0[2]:
	display_df(df_003, "df_003")

df_004 = df_001.rename(columns={"count": "MGCount"}).merge(
	df_order_model_counts.rename(columns={"count": "xSold", "proportion": "PctTotalSold"}),
	on=clbl_modelNo
)

cc1 = st.columns(2)
with cc1[0]:
	display_df(df_order_model_counts, "df_order_model_counts")
with cc1[1]:
	display_df(df_004, "df_004")
# with cc1[1]:
# 	display_df(df_002, "df_002")
# with cc1[2]:
# 	display_df(df_003, "df_003")


display_df(random_df(6,6).describe(include="all"))

st.stop()
# Remove some records that are highly irregular
# FORMULA: CFreq >= average(bottom 30%)
bottom_percent: float = 0.2
mean_bottom: int = int(round(df_groups_sections_os.tail(int(df_groups_sections_os.shape[0] * bottom_percent))[clbl_cFreq].mean(), 0))
st.warning(f"OMITTING GROUPS AND SECTIONS NOT USED AT LEAST {mean_bottom} TIMES.")
df_groups_sections_os = df_groups_sections_os.loc[
	df_groups_sections_os[clbl_cFreq] >= mean_bottom
]

display_df(df_groups_sections_os, "df_groups_sections_os")

list_groups = df_groups_sections_os[clbl_group].dropna().unique().tolist()
list_sections = df_groups_sections_os[clbl_section].dropna().unique().tolist()

# df_top_groups = df_groups_sections_os["Group"].groupby(
# 	by="Group",
# 	as_index=False
# ).first()

df_top_groups = df_groups_sections_os.loc[
	df_groups_sections_os.groupby(clbl_group).idxmax()[clbl_cFreq]
]
display_df(df_top_groups, "df_top_groups")


data_sortable_groups = [
	{"header": "Set Order:", "items": list_groups},
	{"header": "Exclude:", "items": []}
]
st.write("##### Groups:")
sortable_groups = sort_items(
	items=data_sortable_groups,
	multi_containers=True,
	direction="horizontal"
)

ord_groups_keep = {v: i for i, v in enumerate(sortable_groups[0]["items"], start=1)}
ogk_sections = {}
for i, v in enumerate(ord_groups_keep):
	ogk_sections[v] = {}
	for j, row in df_groups_sections_os.loc[df_groups_sections_os[clbl_group] == v].iterrows():
		sec = row[clbl_section]
		sortSe = row[clbl_sortSe]
		ogk_sections[v][sec] = sortSe

df_ord_groups_keep: pd.DataFrame = pd.DataFrame([ord_groups_keep]).transpose().reset_index().rename(columns={"index": "Group", 0: "Order"})
# df_ord_groups_keep[""]

display_df(df_ord_groups_keep, "df_ord_groups_keep")

st.divider()

cols_0 = st.columns([1/3, 1/3, 1/3])
with cols_0[0]:
	st.write("ord_groups_keep")
	st.write(ord_groups_keep)
with cols_0[1]:
	st.write("ogk_sections")
	st.write(ogk_sections)
with cols_0[2]:
	selectbox_group_edit = st.selectbox(
		label="Edit Section order within Group:",
		options=ord_groups_keep
	)
	if selectbox_group_edit:
		# st.write("ogk_sections")
		# st.write(ogk_sections)

		filtered_sections_in = [s for s in ogk_sections[selectbox_group_edit] if s and (not pd.isna(ogk_sections[selectbox_group_edit][s]))]
		filtered_sections_out = [s for s in ogk_sections[selectbox_group_edit] if (s and pd.isna(ogk_sections[selectbox_group_edit][s]))]
		data_sortable_sections = [
			{"header": "Set Order:", "items": filtered_sections_in},
			{"header": "Exclude:", "items": filtered_sections_out}
		]
		st.write("##### Sections:")
		sortable_sections = sort_items(
			items=data_sortable_sections,
			multi_containers=True,
			direction="horizontal"
		)

st.divider()

cols_1 = st.columns(2)
with cols_1[0]:
	st.write(list_groups)
with cols_1[1]:
	st.write(list_sections)

st.write(df_groups_sections_os[clbl_cFreq].mean())
st.write(df_groups_sections_os[clbl_cFreq].std())
st.write(df_groups_sections_os.tail(int(df_groups_sections_os.shape[0] * 0.3))[clbl_cFreq].mean())

if ord_groups_keep:

	toggle_show_agraph = st.toggle(
		label="Show AGraph"
	)

	if toggle_show_agraph:
		node_size_group = 80
		node_size_section = 25
		colour_node_group_0 = Colour("#FFBBBB")
		colour_node_group_1 = Colour("#BBBBFF")
		n_groups = len(ord_groups_keep)
		grad_node_group = [
			Colour(gradient(i, n_groups, colour_node_group_0, colour_node_group_1, rgb=False))
			for i in range(n_groups + 1)
		]
		# colour_node_section = Colour("#FFBBBB")

		sortse_per_group: pd.DataFrame = df_groups_sections_os.groupby(
			by=[clbl_group, clbl_sortSe],
			as_index=False,
			dropna=False
		).agg({
			clbl_cFreq: "count"
		}).groupby(
			by=[clbl_group],
			as_index=False
		).agg({
			clbl_cFreq: "max"
		}).rename(columns={
			clbl_cFreq: "NSections"
		})
		sortse_per_group["NSections"] += 1
		sortse_per_group["Order"] = sortse_per_group[clbl_group].apply(lambda grp: ord_groups_keep[grp])
		sortse_per_group.sort_values(
			by="Order",
			inplace=True
		)
		sortse_per_group["CumTotalSections"] = sortse_per_group["NSections"].cumsum()
		sortse_per_group["StartAt"] = sortse_per_group["CumTotalSections"] - sortse_per_group["NSections"]
		display_df(sortse_per_group, "sortse_per_group", hide_index=False)

		group_node_id = lambda group_idx: f"node_group_{group_idx}"
		group_node_section_id = lambda group_idx, section_idx: f"node_group_section_{group_idx}_{section_idx}"
		group_node_colour = lambda group_idx: grad_node_group[group_idx]
		# group_node_level = lambda group: sortse_per_group.loc[sortse_per_group[clbl_group] == group].iloc[0]["StartAt"]
		def group_node_level(group):
			# print(f"group_node_level {group=}", end="")
			gnl = int(sortse_per_group.loc[sortse_per_group[clbl_group] == group].iloc[0]["StartAt"])
			# print(f" {gnl}")
			return gnl

		nodes_groups = []
		nodes_group_sections = []
		ngs = 0
		edges = []
		for i, g in enumerate(ord_groups_keep):
			gni = group_node_id(i)
			nodes_groups.append(Node(
				id=gni,
				label=g,
				title=f"G: {g}",
				level=group_node_level(g),
				# level=i*2,
				size=node_size_group,
				shape="dot",
				color=group_node_colour(i).hex_code
			))

			df_group: pd.DataFrame = df_groups_sections_os.loc[
				df_groups_sections_os["Group"] == g
			].groupby(
				by=[clbl_section, clbl_sortSe],
				as_index=False
			).agg({
				clbl_cFreq: "sum"
			})

			if i < 5:
				display_df(df_group, f"df_group_{i}")

			t_section_uses = df_group[clbl_cFreq].max()
			for j, row in df_group.iterrows():
				ngs += 1
				sec = row[clbl_section]
				freq = int(row[clbl_cFreq])
				size = int(round(max(15, (node_size_section * (freq / max(1, t_section_uses)))**1.2), 0))
				gnsi = group_node_section_id(i, j)
				if i == 0:
					print(f"{i=}, {j=}, {g=}, {sec=}, {freq=}, tsu={t_section_uses}, {size=}")
				nodes_group_sections.append(Node(
					id=gnsi,
					label=sec,
					title=f"S: {sec} x{freq}",
					level=(2*i)+1,
					size=size,
					shape="dot",
					color=group_node_colour(i).greener_c(0.25).darkened(0.3).hex_code
				))
				edges.append(Edge(
					source=gni,
					target=gnsi
				))

			if i < len(ord_groups_keep):
				edges.append(Edge(
					source=gni,
					target=group_node_id(i + 1)
				))

		config = Config(
			hierarchical=True,
			# color="#601216",
			# background="#601216"
			# backgroundcolor="#601216"
			backgroundColor="#601216",
			width=1600,
			height=900,
			levelSeparation=150,
			nodeSpacing=200,
			treeSpacing=400,
			physics=False
		)

		nodes = nodes_groups + nodes_group_sections

		st.write("ngs")
		st.write(ngs)

		# nodes_data = [node.to_dict() for node in nodes]
		# edges_data = [edge.to_dict() for edge in edges]
		# st.write("nodes_data")
		# st.write(nodes_data)
		# st.write("edges_data")
		# st.write(edges_data)
		#
		# data = {"nodes": nodes_data, "edges": edges_data}
		# st.write("data")
		# st.write(data)
		# data_json = json.dumps(data)
		# st.write("data_json")
		# st.write(data_json)

		with st.container(border=1):
			graph = agraph(
				nodes=nodes,
				edges=edges,
				config=config
			)

else:
	st.write("Need a selection of groups first.")
