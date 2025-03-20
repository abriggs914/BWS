from typing import Optional

import pandas as pd
import streamlit as st
from streamlit_agraph import Node, agraph, Config, Edge

from colour_utility import Colour, gradient
from pyodbc_connection import connect

from streamlit_sortables import sort_items


st.set_page_config(
	layout="wide",
	page_title="Testing IT"
)


def display_df(
		df: pd.DataFrame,
		title: Optional[str] = None,
		hide_index: bool = True,
		show_shape: bool = True
):
	shape = df.shape
	if show_shape:
		title = title if title else ""
		title = f"{title} ({shape[0]} Rows x {shape[1]} Cols)"

	if title:
		st.write(title)
	stdf = st.dataframe(
		data=df,
		hide_index=hide_index
	)
	return stdf


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
	return connect(
		sql=sql
	)

clbl_group: str = "Group"
clbl_section: str = "Section"
clbl_cFreq: str = "CFreq"
clbl_sortG: str = "SortG"
clbl_sortSe: str = "SortSe"
df_groups_sections_os = load_df_groups_sections_os()
df_groups_sections_os[clbl_group] = df_groups_sections_os[clbl_group].map(lambda g: None if pd.isna(g) else g.title().strip())
df_groups_sections_os[clbl_section] = df_groups_sections_os[clbl_section].map(lambda s: None if pd.isna(s) else s.title().strip())

# Sort to prepare for pruning based on frequency
df_groups_sections_os.sort_values(
	by=[clbl_sortG, clbl_sortSe, clbl_cFreq],
	ascending=[True, True, False],
	inplace=True
)
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
st.write("ord_groups_keep")
st.write(ord_groups_keep)

cols = st.columns(2)
with cols[0]:
	st.write(list_groups)
with cols[1]:
	st.write(list_sections)

st.write(df_groups_sections_os[clbl_cFreq].mean())
st.write(df_groups_sections_os[clbl_cFreq].std())
st.write(df_groups_sections_os.tail(int(df_groups_sections_os.shape[0] * 0.3))[clbl_cFreq].mean())

if ord_groups_keep:

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
		as_index=False
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
		print(f"group_node_level {group=}")
		return sortse_per_group.loc[sortse_per_group[clbl_group] == group].iloc[0]["StartAt"]

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
			freq = row[clbl_cFreq]
			size = max(15, (node_size_section * (freq / max(1, t_section_uses)))**1.2)
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
		treeSpacing=400
	)

	nodes = nodes_groups + nodes_group_sections

	st.write("ngs")
	st.write(ngs)
	with st.container(border=1):
		graph = agraph(
			nodes=nodes,
			edges=edges,
			config=config
		)

else:
	st.write("Need a selection of groups first.")
