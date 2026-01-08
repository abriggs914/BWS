import pandas as pd


data = {
	"A": {
		0: [1, 2, 3, 6, 7],
		1: [8, 9, 10, 11],
		2: [12, 13, 14, "A15A", "A15B", 16]
	}
}


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


if __name__ == '__main__':
	t_name = "[BWSdb].[dbo].[INV_WarehouseLayout_HawkinsShelves]".removeprefix("[").removesuffix("]")
	sql = f"INSERT INTO [{t_name}]\n\t([Section], [ShelfSectionID], [Shelf], [ShelfRow])\nVALUES\n\t"
	for i, sec in enumerate(data):
		sec_data = data[sec]
		for j, bins in sec_data.items():
			for k, bin_location in enumerate(bins):
				if isinstance(bin_location, int):
					bin_location = f"{sec}{bin_location}"
				sql += f"({', '.join(map(validate_sql_term, [sec, i + 5, bin_location, len(bins) - (k + 1)]))}),\n\t"
	sql = sql.rstrip().removesuffix(",")

	print(sql)
