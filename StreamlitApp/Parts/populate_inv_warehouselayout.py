import pandas as pd
from utility import excel_column_name, isnumber


def validate(val, as_str: bool = True):
	# res = None
	if (val is not None) and (str(val).replace(".", "").isdigit()):
		try:
			if not as_str:
				res = (int(val) if (str(val).endswith(".0") or ("." not in str(val))) else float(val)) if "." in str(val) else int(val)
				# print(f"A {val=}, {val}, {str(val).endswith(".0")=}, {int(val)=}, {res=}")
			else:
				res = f"{int(val) if (str(val).endswith(".0") or ("." not in str(val))) else float(val)}"
				# print(f"B {val=}, {val}, {str(val).endswith(".0")=}, {int(val)=}, {res=}")
		except (TypeError, ValueError):
			res = None if (not as_str) else "NULL"
			# print(f"C {val=}, {val}, {res=}")
	else:
		if (not bool(val)) or pd.isna(val):
			res = None if (not as_str) else "NULL"
			# print(f"D {val=}, {val}, {res=}")
		else:
			res = f"'{val}'"
			# print(f"E {val=}, {val}, {res=}")
	return res


def load_layout_data(pth_layout: str = r"G:\IT\Network Port Layout\BWS\Hawkins Warehouse Layout Rev3 202601050840.xlsx", sheets=None) -> dict[str, pd.DataFrame]:
	if sheets and (not isinstance(sheets, (list, tuple))):
		sheets = [sheets]
	if sheets:
		data = pd.read_excel(
			pth_layout,
			sheet_name=sheets,
		)
	else:
		data = pd.read_excel(
			pth_layout
		)
	# data["Shelves"]["ShelfRow"] = data["Shelves"]["ShelfRow"].apply(lambda v: int(v) if not pd.isna(v) else v)
	return data


if __name__ == "__main__":

	def create_layout_init():
		df_data = load_layout_data(sheets="Layout")
		df_layout = df_data["Layout"]
		# df_legend = df_data["Legend"]
		# df_sections = df_data["ShelfSections"]
		# df_shelves = df_data["Shelves"]

		cols = dict(zip(df_layout.columns, excel_column_name(len(df_layout.columns))))
		t_name = "INV_WarehouseLayout_Hawkins"
		sql = f"INSERT INTO [{t_name}] ([{'], ['.join(cols.values())}]) VALUES ("
		for i, row in df_layout.iterrows():
			sql += f"({', '.join([(f"'{row[c]}'" if (bool(row[c]) and (not pd.isna(row[c]))) else "NULL") for c in cols])}),\n"
		sql = sql.removesuffix(",\n")
		print(sql)


	def create_legend_init():
		df_data = load_layout_data(sheets="Legend")
		df_legend = df_data["Legend"]
		# df_sections = df_data["ShelfSections"]
		# df_shelves = df_data["Shelves"]

		cols = df_legend.columns
		t_name = "INV_WarehouseLayout_Legend"
		sql = f"INSERT INTO [{t_name}] ([{'], ['.join(cols)}]) VALUES\n"
		for i, row in df_legend.iterrows():
			sql += f"({', '.join([(f"'{row[c]}'" if (bool(row[c]) and (not pd.isna(row[c]))) else "NULL") for c in cols])}),\n"
		sql = sql.removesuffix(",\n")
		print(sql)


	def create_shelves_init():
		df_data = load_layout_data(sheets="Shelves")
		df_shelves = df_data["Shelves"]

		cols = df_shelves.columns
		t_name = "INV_WarehouseShelves_Hawkins"
		sql = f"INSERT INTO [{t_name}] ([{'], ['.join(cols)}]) VALUES\n"
		for i, row in df_shelves.iterrows():
			sql += f"({', '.join([validate(row[c]) for c in cols])}),\n"
		sql = sql.removesuffix(",\n")
		print(sql)

	def create_shelf_sections():
		df_data = load_layout_data(sheets="ShelfSections")
		df_sections = df_data["ShelfSections"]

		cols = df_sections.columns.tolist()
		cols.remove("ID")

		t_name = "INV_WarehouseShelfSections_Hawkins"
		sql = f"INSERT INTO [{t_name}] ([{'], ['.join(cols)}]) VALUES\n"
		for i, row in df_sections.iterrows():
			sql += f"({', '.join([validate(row[c]) for c in cols])}),\n"
		sql = sql.removesuffix(",\n")
		print(sql)

	# ["Layout", "Legend", "ShelfSections", "Shelves"]
	# create_layout_init()
	# create_legend_init()
	# create_shelves_init()
	create_shelf_sections()