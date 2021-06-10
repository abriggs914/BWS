from utility import *

spec_sheets = [
	"SpecSections_40HDG3X AG.txt",
	"SpecSections_53ET3X.txt",
]

data = {}

for i, file_name in enumerate(spec_sheets):
	sections = {}
	with open(file_name, "r") as f:
		lines = f.readlines()
		curr_section = None
		for line in lines:
			print("line", line)
			if line.startswith("- "):
				section = tuple(map(str.strip, line[2:].split(" - ")))
				print("section", section)
				curr_section = (section[0], section[1])
				sections[curr_section] = {}
			else:
				print("curr_section:", curr_section)
				sub_section = tuple(map(str.strip, line.split(" - ")))
				sections[curr_section].update({sub_section: file_name})
		# data[file_name] = {
			# "lines": lines.copy(),
			# "Sections": sections
		# }
		data[file_name] = {
			"Sections": sections
		}
		# data.update(sections)
	
	# print(dict_print(sections, "Sections"))
print(dict_print(data, "Data"))