from pyodbc_connection import *


sql = """
SELECT
	[COMPANY NAME],
	[ADDRESS],
	[CITY],
	[PROVINCE],
	[POSTAL CODE]
FROM
	[Dealers]
ORDER BY
	[COMPANY NAME];"""


f_name = r"dealers_info.csv"
	

if __name__ == "__main__":

	data = connect(sql)
	with open(f_name, "w") as f:
		header = list(data.columns)
		f.write(";;".join(header) + "\n")
		for row in data.itertuples():
			f.write(";;".join(map(lambda x: str(str(x).replace("\u200e", "").encode("utf-8"), "utf-8"), row[1:])) + "\n")
		
	# data.to_csv("dealers_info.csv", sep=";;")  # sep cant be more than 1 in length