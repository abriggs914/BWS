import csv

data_file = "data.csv"
US_CDN_RATIO = 1.209

with open(data_file, 'r') as data:
	data_dict = csv.DictReader(data, delimiter=',')
	fieldnames = data_dict.fieldnames
	data_dict = {line[fieldnames[0]]: line for line in data_dict}
	print("keys: " + str(fieldnames))
		
	def dict_print(n, d, number=False):
		m = "\n--  " + str(n) + "  --\n\n"
		l = 15
		for k, v in d.items():
			lk = len(str(k))
			lv = len(str(v))
			if type(k) == list:
				lk += (2 * len(k) + 2 + len(k) - 1)
			if type(v) == list:
				lv += (2 * len(v) + 2 + len(v) - 1)
			l = max(l, max(lk, lv))
		l += 3
		for i, info in enumerate(d.items()):
			k, v = info
			ml = str(k)
			if number:
				ml = str(i+1) + "  -  " + ml
			ml += str(v).rjust(l - len(ml), ".") + "\n"
			m += "\t" + ml
		return m
		
	def money(v):
		return "$ %.2f" % v
	
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
		weeks = {i: (weeks[i] if i in keys else 0) for i in range(1, max(keys) + 1)}
		return weeks
	
	def dealer_counts(dat) :
		dealers = {}
		for qNo, info in dat.items():
			d = info[fieldnames[3]].strip()
			dealers[d] = 1 if d not in dealers else dealers[d] + 1
		
		ds = list(dealers.keys())
		ds.sort()
		dealers = {d: dealers[d] for d in ds}
		return dealers
		
	def total_base(dat):
		bases = []
		for k, info in dat.items():
			b = float(info[fieldnames[4]].strip()[1:])
			if info[fieldnames[6]]:
				b *= US_CDN_RATIO
			bases.append(b)
		return sum(bases)
		
	def total_cost(dat):
		costs = []
		for k, info in dat.items():
			c = float(info[fieldnames[5]].strip()[1:])
			if info[fieldnames[6]]:
				c *= US_CDN_RATIO
			costs.append(c)
		return sum(costs)
		
	def total_quotes(dat):
		return len(dat)
		
	def avg_base(dat):
		return total_base(dat) / total_quotes(dat)
	
	def avg_cost(dat):
		return total_cost(dat) / total_quotes(dat)
		
	def top_dealer(d):
		top_dealer = -1, None
		for d, c in d.items():
			if not top_dealer:
				top_dealer = c, d
			elif top_dealer[0] < c:
				top_dealer = c, d
		return top_dealer
		
	def top_model(d):
		top_model = -1, None
		for m, c in d.items():
			if not top_model:
				top_model = c, m
			elif top_model[0] < c:
				top_model = c, m
		return top_model
		
	def bottom_dealer(d):
		bottom_dealer = float("inf"), None
		for d, c in d.items():
			if not bottom_dealer:
				bottom_dealer = c, d
			elif bottom_dealer[0] > c:
				bottom_dealer = c, d
		return bottom_dealer
		
	def bottom_model(d):
		bottom_model = float("inf"), None
		for m, c in d.items():
			if not bottom_model:
				bottom_model = c, m
			elif bottom_model[0] > c:
				bottom_model = c, m
		return bottom_model
		
	def top_5_dealers(dat):
		top_5 = {}
		d = dealer_counts(dat)
		for i in range(min(5, len(d))):
			c, td = top_dealer(d)
			if c in top_5:
				if type(top_5[c]) == list:
					top_5[c].append(td)
				else:
					top_5[c] = [top_5[c], td]
			else:
				top_5[c] = td
			del d[td]
		return top_5
		
	def bottom_5_dealers(dat):
		bottom_5 = {}
		d = dealer_counts(dat)
		for i in range(min(5, len(d))):
			c, bd = bottom_dealer(d)
			if c in bottom_5:
				if type(bottom_5[c]) == list:
					bottom_5[c].append(bd)
				else:
					bottom_5[c] = [bottom_5[c], bd]
			else:
				bottom_5[c] = bd
			del d[bd]
		return bottom_5
		
	def top_5_models(dat):
		top_5 = {}
		m = model_counts(dat)
		for i in range(min(5, len(m))):
			c, tm = top_model(m)
			if c in top_5:
				if type(top_5[c]) == list:
					top_5[c].append(tm)
				else:
					top_5[c] = [top_5[c], tm]
			else:
				top_5[c] = tm
			del m[tm]
		return top_5
		
	def bottom_5_models(dat):
		bottom_5 = {}
		m = model_counts(dat)
		for i in range(min(5, len(m))):
			c, bm = bottom_model(m)
			if c in bottom_5:
				if type(bottom_5[c]) == list:
					bottom_5[c].append(bm)
				else:
					bottom_5[c] = [bottom_5[c], bm]
			else:
				bottom_5[c] = bm
			del m[bm]
		return bottom_5
		
	print(dict_print("Model Counts:", model_counts(data_dict)))
	print(dict_print("Weekly Counts:", weekly_counts(data_dict)))
	print(dict_print("Dealer Counts:", dealer_counts(data_dict)))
	print("\nTotal Quotes:\n" + str(total_quotes(data_dict)))
	print("\nTotal Base Costs:\n" + money(total_base(data_dict)))
	print("\nTotal Costs:\n" + money(total_cost(data_dict)))
	print("\nAverage Base Costs:\n" + money(avg_base(data_dict)))
	print("\nAverage Costs:\n" + money(avg_cost(data_dict)))
	print(dict_print("Top 5 Dealers:", top_5_dealers(data_dict), number=True))
	print(dict_print("Top 5 Models:", top_5_models(data_dict), number=True))
	print(dict_print("Bottom 5 Dealers:", bottom_5_dealers(data_dict), number=True))
	print(dict_print("Bottom 5 Models:", bottom_5_models(data_dict), number=True))