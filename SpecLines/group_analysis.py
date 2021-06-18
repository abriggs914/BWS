import csv
from utility import *

with open("groups_by_class.csv", "r") as f:
	lines = csv.DictReader(f)
	
	sections = {}
	classes = {}
	sort_sections = {}
	
	for line in lines:
		clazz = line["Class"]
		section = line["SpecGroup"]
		sort_g = int(line["SpecSortG"])
		
		# Shorter string identifiers to fit the width better.
		# !! CAREFULL !! These are truncated values used as dict keys,
		#                there may be some accidental overwriting
		#                depending on the shortness. MIN=5 (LOG class)
		section_6 = section[:6]
		clazz_6 = clazz[:6]
		
		# sort_sections
		if sort_g not in sort_sections:
			sort_sections[sort_g] = {}
		if clazz_6 not in sort_sections[sort_g]:
			sort_sections[sort_g].update({clazz_6: [section_6]})
		else:
			sort_sections[sort_g][clazz_6].append(section)
			print("WARNING! The section sorting number \"{}\" has more than one entry")
		
		# classes
		if clazz_6 not in classes:
			classes[clazz_6] = {}
		if section_6 not in classes[clazz_6]:
			classes[clazz_6].update({section_6: [sort_g]})
		else:
			classes[clazz_6][section_6].append(sort_g)
			print("WARNING! The \"{}\" section of the \"{}\" class, has more than 1 entry:\t{}".format(section_6, clazz_6, classes[clazz_6][section_6]))
		
		# sections
		if section not in sections:
			sections[section] = {}
		if sort_g not in sections[section]:
			sections[section].update({sort_g: 1})
		else:
			sections[section][sort_g] += 1
			
	print(dict_print(sections, "Counts:  Sort_Section_G x Section"), "\n")
	print(dict_print(classes, "Counts:  Section x Class"), "\n")
	print(dict_print(sort_sections, "sort_sections"), "\n")