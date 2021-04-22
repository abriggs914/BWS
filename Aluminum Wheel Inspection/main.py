import csv
from utility import *

with open("table.csv", 'r') as f:
	reader = csv.DictReader(f)
	
	ordered_options = []
	for i, line in enumerate(reader):
		ordered_options.append(line)
		
	print("Orders:\n" + "\n".join(list(map(str, ordered_options))))
	
	print("header:", reader.fieldnames)
	
	wheel_counts = {
		"17.5": {"steel": 0, "machined": 0, "polished": 0, "orders": []},
		"22.5": {"steel": 0, "machined": 0, "polished": 0, "orders": []},
		"24.5": {"steel": 0, "machined": 0, "polished": 0, "orders": []}
	}
	for order in ordered_options:
		for wheel_count in wheel_counts:
			if wheel_count in order["Description"]:
				d = order["Description"]
				spl = d.split(";;")
				f, l = spl[0].split(" ")[-2:], spl[1].split(" ")[1:]
				
				if f[1] == "steel":
					wheel_counts[wheel_count]["steel"] += int(f[0][1:].strip())
				elif f[1] == "machined":
					wheel_counts[wheel_count]["machined"] += int(f[0][1:].strip())
				elif f[1] == "polished":
					wheel_counts[wheel_count]["polished"] += int(f[0][1:].strip())
				
				if l[1][:-1] == "steel":
					wheel_counts[wheel_count]["steel"] += int(l[0].strip())
				elif l[1][:-1] == "machined":
					wheel_counts[wheel_count]["machined"] += int(l[0].strip())
				elif l[1][:-1] == "polished":
					wheel_counts[wheel_count]["polished"] += int(l[0].strip())
				# print("spl:", spl, "f: ", f, "l:", l)
				wheel_counts[wheel_count]["orders"].append(order["Quote#"])
				break
				
	print(dict_print(wheel_counts, "Wheel counts"))
		