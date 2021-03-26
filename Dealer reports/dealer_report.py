import re

file_name = "Dealer Status Review.txt"

with open(file_name, 'r') as f:
	lines = f.readlines()
	
	i = 0
	pages = 0
	data = []
	while i < len(lines):
		line = lines[i]
		spl = line.split()
		# print(len(line))
		if spl == ["Date", "Date", "Date"]:
			print(line)
			i += 1
			page_data = []
			# while i < len(lines) and not re.search("\w+ Page \d of \d", lines[i]):
			while i < len(lines) and lines[i].split() != ["Date", "Date", "Date"]:
				s = lines[i].strip()
				if re.search("\w+ Page \d of \d", s):
					print(s + ", matches REGEX")
				else:
					print("No match")
				if s:
					page_data.append(s)
				i += 1
			pages += 1
			data.append(page_data)
		i += 1
			
	for page in data:
		for dat in page:
			print("dat: " + str(dat))
	print("pages: " + str(pages))
			
# Page 3 of 4