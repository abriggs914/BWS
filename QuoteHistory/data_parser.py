import csv

data_file = "data.csv"

with open(data_file, 'r') as data:
	data_dict = csv.DictReader(data, delimiter=',')
	fieldnames = data_dict.fieldnames
	data_dict = {line[fieldnames[0]]: line for line in data_dict}
	print("keys: " + str(fieldnames))
	
	def model_counts(dat) :
		models = {}
		for qNo, info in dat.items():
			m = info[fieldnames[1]].strip()
			models[m] = 1 if m not in models else models[m] + 1
		
		ms = list(models.keys())
		ms.sort()
		models = {m: models[m] for m in ms}
		return models
	
	def weekly_counts(dat) :
		weeks = {}
		for qNo, info in dat.items():
			w = int(info[fieldnames[2]].strip())
			weeks[w] = 1 if w not in weeks else weeks[w] + 1
		
		keys = weeks.keys()
		weeks = {i: (weeks[i] if i in keys else 0) for i in range(max(keys) + 1)}
		return weeks
		
	def total_quotes(dat):
		return len(dat)
		
	def dict_print(d):
		m = ""
		for k, v in d.items():
			ml = str(k)
			ml += str(v).rjust(18 - len(ml), ".") + "\n"
			m += ml
		return m
		
	print("\nmodel counts:\n" + dict_print(model_counts(data_dict)))
	print("\nweekly counts:\n" + dict_print(weekly_counts(data_dict)))
	print("\ntotal quotes:\n" + str(total_quotes(data_dict)))