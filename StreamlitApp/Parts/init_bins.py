from pyodbc_connection import connect, pd


data = {
	"A": {
		0: [5, 4, 3, 2, 1],
		1: [11, 10, 9, 8],
		2: [16, "A15B", "A15A", 14, 13, 12],
		3: [21, "A20B", "A20A", 19, 18, 17],
		4: [26, "A25B", "A25A", 24, 23, 22, 22],
		5: [31, "A30B", "A30A", 29, 28, 27],
		6: [36, "A35B", "A35A", 34, 33, 32],
		7: [41, 40, 39, 38, 37],
		8: [],
		9: [46],
		10: ["A50E", "A50D", "A50C", "A50B", "A50A", 49, 48, 47],
		11: [],
		12: [55]
	},
	"B": {
		0: [None],
		1: ["4B", "4A", 3, 2, 1],
		2: ["8B", "8A", 7, 6, 5],
		3: [15, 14, 13, 12, 11, 10, 9],
		4: [22, 21, 20, 19, 18, 17, 16],
		5: [29, 28, 27, 26, 25, 24, 23],
		6: [36, 35, 34, 33, 32, 31, 30],
		7: [43, 42, 41, 40, 39, 38, 37],
		8: [None, 46, "45B", "45A", 44, 43, 42],
		9: ["B50E", "B50D", "B50C", "B50B", "B50A", 49, 48, 47],
		10: ["B54E", "B54D", "B54C", "B54B", "B54A", 53, 52, 51],
		11: ["B58G", "B58F", "B58E", "B58D", "B58C", "B58B", "B58A", 58, 57, 56],
		12: [59, "A56"]
	},
	"C": {
		0: [None],
		1: [None],
		2: [10, 9, 8, 7, 6],
		3: [15, 14, 13, 12, 11],
		4: [20, 19, 18, 17, 16],
		5: [25, 24, 23, 22, 21],
		6: [30, 29, 28, 27, 26],
		7: [35, 34, 33, 32, 31],
		8: [None, 36],
		9: [41, 40, 39, 38],
		10: ["C45E", "C45D", "C45C", "C45B", "C45A", 45, 44, 43, 42],
		11: ["C49E", "C49D", "C49C", "C49B", "C49A", 49, 48, 47],
		12: [None]
	},
	"D": {
		0: [],
		1: [],
		2: [8, 7, 6],
		3: [15, 14, 13, 12, 11],
		4: [20, 19, 18, 17, 16],
		5: [25, 24, 23, 22, 21],
		6: [30, 29, 28, 27, 26],
		7: [35, 34, 33, 32, 31],
		8: [None, 36],
		9: [42, 41, 40, 39, 38],
		10: ["D45E", "D45D", "D45C", "D45B", "D45A", 45, 44, 43],
		11: ["D49G", "D49F", "D49E", "D49D", "D49C", "D49B", "D49A", 49, 48, 47],
		12: ["D54G", "D54F", "D54E", "D54D", "D54C", "D54B", "D54A", "D53E", "D53D", "D53C", "D53B", "D53A", 52, 51]
	},
	"E": {
		0: [],
		1: [5, 4, 3, 2, 1],
		2: [None, 8, 7, 6],
		3: [15, 14, 13, 12, 11],
		4: [20, 19, 18, 17, 16],
		5: ["E25D", "E25C", "E25B", "E25A", 24, 23, 22, 21],
		6: [30, 29, 28, 27, 26],
		7: [35, 34, 33, 32, 31],
		8: [None, 36],
		9: [40, 39, 38],
		10: ["E45E", "E45D", "E45C", "E45B", "E45A", 43, 42],
		11: [None, 49, 48],
		12: ["D53E", "D53D", "D53C", "D53B", "D53A", 52, 51],
	},
	"F": {
		0: [None],
		1: [5, 4, 3, 2, 1],
		2: ["F10B", "F10A", 9, 8, 7, 6],
		3: [15, 14, 13, 12, 11],
		4: [20, 19, 18, 17, 16],
		5: [25, 24, 23, 22, 21],
		6: [30, 29, 28, 27, 26],
		7: [35, 34, 33, 32, 31],
		8: [None, 36],
		9: ["E36H", "E36G", "E36F", "E36E", "E36D", "E36C", "E36B", "E36A"],
		10: ["E38E", "E38D", "E38C", "E38B", "E38A", 37],
		12: [40, 39]
	},
	"G": {
		0: [None],
		1: [5, 4, 3, 2, 1],
		2: [10, 9, 8, 7, 6],
		3: [15, 14, 13, 12, 11],
		4: [20, 19, 18, 17, 16],
		5: [25, 24, 23, 22, 21],
		6: [30, 29, 28, 27, 26],
		7: [35, 34, 33, 32, 31],
		8: [None]
	},
	"H": {
		0: [None],
		1: [None],
		2: ["H2B", "H2A", 2, 1],
		3: ["H4D", "H4C", "H4B", "H4A", 4, 3],
		4: [None, 6, 5],
		5: ["H9B", "H9A", 9, 8, 7],
		6: ["H11B", "H11A", 11, 10],
		7: [16, 15, 14, 13, 12]
	},
	"R1": {
		0: [None],
		1: [30, 29, 28, 27, 26],
		2: [35, 34, 33, 32, 31],
		3: [40, 39, 38, 37, 36],
		4: [42, 41]
	},
	"R2": {
		0: [5, 4, 3, 2, 1],
		1: [10, 9, 8, 7, 6],
		2: [15, 14, 13, 12, 11],
		3: [20, 19, 18, 17, 16],
		4: [25, 24, 23, 22, 21]
	}
}


def load_known_shelves() -> pd.DataFrame:
	return connect(t_name_shelves)


def load_known_sections() -> pd.DataFrame:
	return connect(t_name_sections)


def validate_sql_term(val, as_str: bool = True):
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


# physical: logical
section_map = {
	"A": "A",
	"B": "C",
	"C": "D",
	"D": "F",
	"E": "G",
	"F": "I",
	"G": "J",
	"H": "L",
	"R1": "J",
	"R2": "L"
}


if __name__ == '__main__':

	skip_exist: bool = True  # 20260113 skipping all previously configured data

	cols = ["Section", "ShelfSectionID", "Shelf", "ShelfRow"]
	t_name_shelves = "[BWSdb].[dbo].[INV_WarehouseLayout_HawkinsShelves]".removeprefix("[").removesuffix("]")
	t_name_sections = "[BWSdb].[dbo].[INV_WarehouseShelfSections_Hawkins]".removeprefix("[").removesuffix("]")
	sql_i = f"INSERT INTO [{t_name_shelves}]\n\t([{'], ['.join(cols)}])\nVALUES\n\t"
	sql_u_t = f"UPDATE [{t_name_shelves}]\nSET\n\t"
	sql_u = []
	has_inserts: bool = False
	df_sections = load_known_sections()
	df_known = load_known_shelves()
	print("df_known[cols]")
	print(df_known[cols])
	print("df_sections")
	print(df_sections)

	# df_known_ = df_known[df_known["ParentShelf"].isin(["G", "H", "R"])]
	# print("df_known_[cols]")
	# print(df_known_[cols])
	df_new_rows = []
	df_sections["Section"] = df_sections["Section"].astype(str)
	df_sections["Group"] = df_sections["Group"].astype(str)
	# print("df_sections")
	# print(df_sections[["ID", "Section", "Group"]])
	for i, sec in enumerate(data):
		sec_data = data[sec]
		for j, bins in sec_data.items():
			for k, bin_location in enumerate(bins):
				if isinstance(bin_location, int):
					bin_location = f"{sec[0]}{bin_location}"
				print(f"{i=}, {j=}, sec={sec}=>{section_map[sec]}, {k=}, {bin_location=}, grp={j+(5 if sec[0] != "R" else 0)}", end="")
				if not bin_location:
					print("")
					continue
				df_sec = df_sections.loc[
					(df_sections["Section"] == str(section_map[sec]))
					& (df_sections["Group"] == str(j + (5 if sec[0] != "R" else 0)))
				]
				if not df_sec.empty:
					ss_id = df_sec.reset_index().loc[0, "ID"]
					print(f", {ss_id=}")
					vals = [section_map[sec], ss_id, bin_location, len(bins) - (k + 1)]
					df_known_same_loc = df_known.loc[
						(df_known["Section"] == str(section_map[sec]))
						& (df_known["Shelf"] == str(bin_location))
					]
					if df_known_same_loc.empty:
						sql_i += f"({', '.join(map(validate_sql_term, vals))}),\n\t"
						has_inserts = True
					elif not skip_exist:
						known_vals = df_known_same_loc[cols]
						if any([v0 != v1 for v0, v1 in zip(known_vals, vals)]):
							vals_ = ""
							for col, val in zip(cols, vals):
								vals_ += f"{col}] = {validate_sql_term(val)},\n\t["
							vals_ = vals_.rstrip().removesuffix(",").strip().removesuffix("[").strip().removesuffix(",")
							sql_u.append(sql_u_t + f"\n\t[" + vals_ + f"\nWHERE\n\t[ID] = {int(df_known_same_loc.reset_index().loc[0, "ID"])}\n;")
					df_new_rows.append(pd.DataFrame([dict(zip(cols, vals))]))
				else:
					print("")

	sql_i = sql_i.rstrip().removesuffix(",")
	print(sql_i)
	for sql in sql_u:
		print(sql)

	if df_new_rows:
		df_new = pd.concat(df_new_rows).reset_index(drop=True)
		print("df_new")
		print(df_new)

		# mask = None
		# for col in cols:
		# 	if mask is None:
		# 		mask = (~df_new[col].isin(df_known[cols]))
		# 	else:
		# 		mask = mask & (~df_new[col].isin(df_known[cols]))

		df_new_new = pd.concat([df_known, df_new])
		df_new_new.drop_duplicates(subset=cols, inplace=True)
		df_new_new.sort_values(by=cols, ascending=True, inplace=True)
		print('df_new_new[cols]')
		print(df_new_new[cols])

	with open("sqls_to_run.sql", "w") as f:
		f.write("-- SQL to Insert New Rows:\n")
		if has_inserts:
			f.write(sql_i + "\n--" + ("="*110) + "\n\n")
		f.write("-- SQL to Update Old Rows:\n")
		for line in sql_u:
			f.write(line + "\n")