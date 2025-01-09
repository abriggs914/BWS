import csv
import pandas as pd

path_main_building = r"U:\Quick files\Security\NewWare Files\main_building.Txt"
path_dome_building = r"U:\Quick files\Security\NewWare Files\dome_building.Txt"
path_tire_shop = r"U:\Quick files\Security\NewWare Files\tire_shop.Txt"


if __name__ == '__main__':

	dfs = []

	for i, path_data in enumerate([
		("Main Building", path_main_building),
		("Dome Building", path_dome_building),
		("Tire Shop", path_tire_shop)
	]):
		name, path = path_data
		with open(path, "r") as f1:
			csv_data = csv.reader(
				f1,
				delimiter="\t"
			)
			if csv_data:
				data = []
				columns = []
				for j, row in enumerate(csv_data):
					if j == 0:
						columns = row
					else:
						data.append(row)
					print(f"{j=}, {row=}")
				df = pd.DataFrame(data=data, columns=columns)
				dfs.append((i, name, df))
				# print(df)
				# # df.sort_values(by="Code #", inplace=True)
				# print(df[["User Label", "Code #"]])

	with open("outputfile.txt", "w") as f2:
		for i, name, df in dfs:
			f2.write(f"\n\n")
			f2.write(f"="*120)
			f2.write(f"\n{'\t'*4}{name}\n")
			f2.write(df[["User Label", "Code #"]].to_string())
			f2.write(f"\n" + f"="*120)
			f2.write(f"\n\n")
