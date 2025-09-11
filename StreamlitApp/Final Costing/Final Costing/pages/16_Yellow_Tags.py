import pandas as pd

from typing import Any
from pyodbc_connection import connect
from streamlit_utility import display_df, st


@st.cache_data(ttl=60)
def load_yellow_tags() -> pd.DataFrame:
	sql = """
SELECT
	[YT].*,
	[IW].[QtyOnHand],
	[IM].[Description] AS [Desc],
	[IM].[LongDesc]
FROM
	[BWSdb].[dbo].[PROD_YellowTags] [YT]
LEFT JOIN
	[SysproCompanyA].[dbo].[InvWarehouse] [IW] 
ON
	[YT].[StockCode] = [IW].[StockCode] COLLATE DATABASE_DEFAULT
LEFT JOIN
	[SysproCompanyA].[dbo].[InvMaster] [IM] 
ON
	[YT].[StockCode] = [IM].[StockCode] COLLATE DATABASE_DEFAULT
WHERE
	[IW].[Warehouse] = '01'
;
	"""
	return connect(sql)


@st.dialog("YT Update", width="large")
def ask_commit_update(data):
	ids = list(data.keys())
	st.write("Are you sure you want to update?")
	df_updated = df_yts.loc[ids]
	display_df(
		df_updated[vis_cols.values()],
		"Updated"
	)


def change_df_yts():
	df_edited: dict[str: dict[int: dict[str: Any]]] = st.session_state.get(k_de_yts, {})
	edited_rows = df_edited.get("edited_rows", {})
	added_rows = df_edited.get("added_rows", {})
	deleted_rows = df_edited.get("deleted_rows", {})
	print(f"{edited_rows=}")
	ask_commit_update(edited_rows)


df_yts = load_yellow_tags()
vis_cols = {
	"DateCreated": "Missing Since",
	"WO": "WO",
	"QtyMissing": "# Missing",
	"QtyOnHand": "# on Hand",
	"StockCode": "Part",
	"Desc": "Desc",
	"LongDesc": "Long Desc",
	"Supplier": "Supplier",
	"PO": "PO",
	"Notes": "Notes"
}
df_yts: pd.DataFrame = df_yts.rename(columns=vis_cols)
df_yts[vis_cols["DateCreated"]] = df_yts[vis_cols["DateCreated"]].apply(lambda x: x.date() if pd.notnull(x) else "")
k_df_yts: str = "key_df_yts"
k_de_yts: str = "key_de_yts"
de_yts = st.data_editor(
	df_yts[vis_cols.values()],
	width=1500,
	height=650,
	on_change=change_df_yts,
	key=k_de_yts
)
