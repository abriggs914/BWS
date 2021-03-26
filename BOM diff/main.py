import csv
from utility import *

class Part:
	def __init__(self, comp, desc, long_desc, quantity, uom, material_cost, run_time, labour_cost, total_cost):
		self.comp = comp
		self.desc = desc
		self.long_desc = long_desc
		self.quantity = quantity
		self.uom = uom
		self.material_cost = material_cost
		self.run_time = run_time
		self.labour_cost = labour_cost
		self.total_cost = total_cost
		
	def table_repr(self):
		return {"Quantity": self.quantity, "Desc": self.desc, "Total cost": self.total_cost}
	
	def __repr__(self):
		return str(self.quantity) + " x " + self.desc
		
def get_parts(csv_reader_obj):
	bom_parts = {}
	fieldnames = csv_reader_obj.fieldnames
	for line in csv_reader_obj:
	
		q = (line["QtPer"] if "QtPer" in fieldnames else line["QtyRequired"]).replace(",", "")
		mc = (line["MC"] if "MC" in fieldnames else "").replace(",", "")
		rt = (line["RT"] if "MC" in fieldnames else "").replace(",", "")
		lc = (line["LC"] if "MC" in fieldnames else "").replace(",", "")
		tc = (line["TC"] if "TC" in fieldnames else line["ValueRequried"]).replace(",", "")
		
		comp = line["Comp"] if "Comp" in fieldnames else line["StockCode"]
		if not comp:
			continue
		desc = line["Desc_txt"] if "Desc_txt" in fieldnames else line["StockDescription"]
		long_desc = line["LongDesc_txt"] if "LongDesc_txt" in fieldnames else None
		quantity = float(q) if q else 0
		uom = line["SUOM"] if "SUOM" in fieldnames else line["Uom"]
		material_cost = float(mc) if mc else 0
		run_time = float(rt) if rt else 0
		labour_cost = float(lc) if lc else 0
		total_cost = float(tc) if tc else 0
		
		# print("total_cost: " + str(total_cost))
		
		part = Part(comp, desc, long_desc, quantity, uom, material_cost, run_time, labour_cost, total_cost)
		# print(line)
		bom_parts[comp.upper()] = part
		
	return bom_parts
	
def bom_diff(bom_1, bom_2):
	iter_bom = bom_1 if len(bom_1) >= len(bom_2) else bom_2
	comp_bom = bom_2 if len(bom_1) >= len(bom_2) else bom_1
	diff_bom = {}
	for comp, part in iter_bom.items():
		if comp not in comp_bom:
			diff_bom[comp] = part
		else:
			if part.quantity != comp_bom[comp].quantity:
				q = bom_2[comp].quantity - bom_1[comp].quantity
				c = bom_2[comp].total_cost - bom_1[comp].total_cost
				if q != 0:
					diff_bom[comp] = Part(
						part.comp,
						part.desc,
						part.long_desc,
						q,
						part.uom,
						part.material_cost,
						part.run_time,
						part.labour_cost,
						c
					)
	return diff_bom

def calc_bom_diff(bom_csv_file_1, bom_csv_file_2, PRINTING=False):
	with open(bom_csv_file_1, "r") as f1, open(bom_csv_file_2, "r") as f2:
		f1_csv = csv.DictReader(f1)
		f2_csv = csv.DictReader(f2)
		print("f1_csv.fieldnames: " + str(f1_csv.fieldnames))
		print("f2_csv.fieldnames: " + str(f2_csv.fieldnames))
		print("Same fieldnames: " + str(f1_csv.fieldnames == f2_csv.fieldnames))
		
		bom_1_parts = get_parts(f1_csv)
		bom_2_parts = get_parts(f2_csv)
		print(bom_2_parts)
		
		print(dict_print({comp: part.table_repr() for comp, part in bom_1_parts.items()}, "bom_1_parts", number=True))
		print(dict_print({comp: part.table_repr() for comp, part in bom_2_parts.items()}, "bom_2_parts", number=True))
			
		# print("\n\n" + str(bom_1_parts[0]))
		
		diff_bom = bom_diff(bom_1_parts, bom_2_parts)
		if PRINTING:
			print(dict_print({comp: part.table_repr() for comp, part in diff_bom.items()}, "diff_bom", number=True))
		return diff_bom

if __name__ == "__main__":
	file_1 = "EMFL Recosting Rpt.csv"
	file_2 = "Work Order 10014779 Status - Operation Sorting.csv"
			
		# print("\n\n" + str(bom_1_parts[0]))
		
	diff_bom = calc_bom_diff(file_1, file_2)
	print(dict_print({comp: part.table_repr() for comp, part in diff_bom.items()}, "diff_bom", number=True))