
if __name__ == "__main__":

	sql_t = "UPDATE [BWSdb].[dbo].[INV_WarehouseLayout_Hawkins] SET"
	sqls = []

	# # aisle 1
	# cols = ["F", "G", "H", "I", "J", "K"]
	# rows = range(33, 93 + 1)

	# # aisle 2
	# cols = ["T", "U", "V", "W", "X", "Y"]
	# rows = range(42, 95 + 1)

	# # aisle 3
	# cols = ["AH", "AI", "AJ", "AK", "AL", "AM"]
	# rows = range(34, 99 + 1)

	# aisle 3
	cols = ["AV", "AW", "AX", "AY", "AZ", "BA", "BB"]
	rows = range(1, 66 + 1)

	for i in rows:
		sql_i = sql_t
		for j, col in enumerate(cols):
			sql_i += f" [{col}] = 0,"
		sql_i = sql_i.removesuffix(",")
		sql_i += f" WHERE [ID] = {i}"
		sqls.append(sql_i)

	for i, sql in enumerate(sqls):
		print(sql)
