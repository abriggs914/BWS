import csv
import locale

locale.setlocale(locale.LC_ALL, "")
data_file = "data.csv"
US_CDN_RATIO = 1.209

with open(data_file, 'r') as data:
	data_dict = csv.DictReader(data, delimiter=',')
	fieldnames = data_dict.fieldnames
	data_dict = {line[fieldnames[0]]: line for line in data_dict}
	print("keys: " + str(fieldnames))
		
	# Function returns a formatted string containing the contents of a dict object.
	# Special lines and line count for values that are lists.
	# n			-	Name of the dict, printed above the contents.
	# d			-	dict object.
	# number	-	Decide whether to number the content lines.
	# l			-	Minimum number of chars in the content line.
	# 				Spaces between keys and values are populated by marker.
	# sep		-	Additional separation between keys and values.
	# marker	-	Char that separates the key and value of a content line.
	def dict_print(n, d, number=False, l=15, sep=5, marker="."):
		if not d or not n:
			return "None"
		m = "\n--  " + str(n).title() + "  --\n\n"
		fill = 0
		for k, v in d.items():
			lk = len(str(k))
			lv = len(str(v))
			# print("lk: {lk}, lv: {lv}".format(lk=lk, lv=lv))
			if type(k) == list:
				lk += (2 * len(k) + 2 + len(k) - 1)
			if type(v) == list:
				lv = max([len(str(v_elem)) for v_elem in v])
				
				# print("v: {v}".format(v=v))
				# for v_elem in v:
					# print("\tv_elem: {n}<{ve}>".format(n=len(v_elem), ve=v_elem))
				
				fill += len(v)
			l = max(l, (lk + lv))
			# print("calculated L : {l}\tLK: {lk}\tLV: {lv}".format(l=l, lk=lk, lv=lv))
		l += sep
		fill = "".join([" " for i in range(len(str(fill + len(d))))])
		i = 0
		# print("FINAL L: {l}\nFill: {n}<{f}>".format(l=l, n=len(fill), f=fill))
		for k, v in d.items():
			if type(v) != list:
				v = [v]
			for j, v_elem in enumerate(v):
				ml = str(k)
				orig_ml = ml
				num = str(i+1)
				if number:
					ml = fill + "  -  " + ml
					if j == 0:
						ml = num.ljust(len(fill)) + ml[len(fill):]
				ml += str(v_elem).rjust(l - len(orig_ml), marker) + "\n"
				m += "\t" + ml
				i += 1
		return m
		
	def money(v):
		# return "$ %.2f" % v
		return locale.currency(v, grouping=True)
			
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
			c = float(info[fieldnames[5]].strip()[1:])
			weeks[w] = (1, c) if w not in weeks else (weeks[w][0] + 1, weeks[w][1] + c)
		
		keys = weeks.keys()
		weeks = {(weeks[i][0] if i in keys else 0): money(weeks[i][1] if i in keys else 0) for i in range(1, max(keys) + 1)}
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
	
	def dealer_costs(dat) :
		dealers = {}
		for qNo, info in dat.items():
			d = info[fieldnames[3]].strip()
			c = float(info[fieldnames[5]].strip()[1:])
			dealers[d] = c if d not in dealers else dealers[d] + c
		
		ds = list(dealers.keys())
		ds.sort()
		dealers = {d: money(dealers[d]) for d in ds}
		return dealers
		
	def highest_quoted_week(dat):
		weeks = weekly_counts(dat)
		best_week = None, None
		# print("WEEKS: {w}".format(w=weeks))
		for i, week in enumerate(weeks):
			# print("i: {i}, w: {w}, w1: {w1}".format(i=i, w=week, w1=weeks[week]))
			nQts, dollars = week, weeks[week]
			if not all(best_week) or best_week[1] < nQts:
				best_week = (i + 1, nQts)
		if not all(best_week):
			return "No quotes to report."
		return "{n} quote{s} in week {w}".format(n=best_week[1], w=best_week[0], s=("s" if best_week[1] > 1 else ""))
		
	def lowest_quoted_week(dat):
		weeks = weekly_counts(dat)
		best_week = None, None
		# print("WEEKS: {w}".format(w=weeks))
		for i, week in enumerate(weeks):
			# print("i: {i}, w: {w}, w1: {w1}".format(i=i, w=week, w1=weeks[week]))
			nQts, dollars = week, weeks[week]
			if not all(best_week) or best_week[1] > nQts:
				best_week = (i + 1, nQts)
		if not all(best_week):
			return "No quotes to report."
		return "{n} quote{s} in week {w}".format(n=best_week[1], w=best_week[0], s=("s" if best_week[1] > 1 else ""))
		
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
		
	def top_5_base(dat):
		bases = [(k, round(100 * float(info[fieldnames[4]].strip()[1:])) / 100) for k, info in dat.items()]
		bases.sort(reverse=True, key=lambda tup: tup[1])
		top_5 = {}
		for i, info in enumerate(bases):
			qNo, base = info
			if len(top_5) == 5:
				break
			
			content = "Quote #{n}, Model: {m}".format(n=qNo, m=dat[qNo][fieldnames[1]].strip())
			b = money(base)
			if b in top_5:
				if type(top_5[b]) == list:
					top_5[b].append(content)
				else:
					top_5[b] = [top_5[b]] + [content]
			else:
				top_5[b] = content
			
		return top_5
		
	def bottom_5_base(dat):
		bases = [(k, round(100 * float(info[fieldnames[4]].strip()[1:])) / 100) for k, info in dat.items()]
		bases.sort(key=lambda tup: tup[1])
		top_5 = {}
		for i, info in enumerate(bases):
			qNo, base = info
			if len(top_5) == 5:
				break
			
			content = "Quote #{n}, Model: {m}".format(n=qNo, m=dat[qNo][fieldnames[1]].strip())
			b = money(base)
			if b in top_5:
				if type(top_5[b]) == list:
					top_5[b].append(content)
				else:
					top_5[b] = [top_5[b]] + [content]
			else:
				top_5[b] = content
			
		return top_5
		
	def top_5_cost(dat):
		costs = [(k, round(100 * float(info[fieldnames[5]].strip()[1:])) / 100) for k, info in dat.items()]
		costs.sort(reverse=True, key=lambda tup: tup[1])
		top_5 = {}
		for i, info in enumerate(costs):
			qNo, cost = info
			if len(top_5) == 5:
				break
			
			content = "Quote #{n}, Model: {m}".format(n=qNo, m=dat[qNo][fieldnames[1]].strip())
			c = money(cost)
			if c in top_5:
				if type(top_5[c]) == list:
					top_5[c].append(content)
				else:
					top_5[c] = [top_5[c]] + [content]
			else:
				top_5[c] = content
			
		return top_5
		
	def bottom_5_cost(dat):
		costs = [(k, round(100 * float(info[fieldnames[5]].strip()[1:])) / 100) for k, info in dat.items()]
		costs.sort(key=lambda tup: tup[1])
		top_5 = {}
		for i, info in enumerate(costs):
			qNo, cost = info
			if len(top_5) == 5:
				break
			
			content = "Quote #{n}, Model: {m}".format(n=qNo, m=dat[qNo][fieldnames[1]].strip())
			c = money(cost)
			if c in top_5:
				if type(top_5[c]) == list:
					top_5[c].append(content)
				else:
					top_5[c] = [top_5[c]] + [content]
			else:
				top_5[c] = content
			
		return top_5
		
	print(dict_print("Model Counts:", model_counts(data_dict)))
	print(dict_print("Weekly Counts:", weekly_counts(data_dict), number=True))
	print(dict_print("Dealer Counts:", dealer_counts(data_dict)))
	print(dict_print("Dealer Costs:", dealer_costs(data_dict)))
	print(dict_print("Top 5 Dealers:", top_5_dealers(data_dict), number=True))
	print(dict_print("Top 5 Models:", top_5_models(data_dict), number=True))
	print(dict_print("Bottom 5 Dealers:", bottom_5_dealers(data_dict), number=True))
	print(dict_print("Bottom 5 Models:", bottom_5_models(data_dict), number=True))
	print(dict_print("top 5 bases: ", top_5_base(data_dict), number=True))
	print(dict_print("bottom 5 bases: ", bottom_5_base(data_dict), number=True))
	print(dict_print("top 5 costs: ", top_5_cost(data_dict), number=True))
	print(dict_print("bottom 5 costs: ", bottom_5_cost(data_dict), number=True))
	
	statistical_reporting = {
		"Total Quotes": total_quotes(data_dict),
		"Highest quoted week": highest_quoted_week(data_dict),
		"Lowest quoted week": lowest_quoted_week(data_dict),
		"Total Base Costs": money(total_base(data_dict)),
		"Total Costs": money(total_cost(data_dict)),
		"Average Base Costs": money(avg_base(data_dict)),
		"Average Costs": money(avg_cost(data_dict))
	}
	# print("\nTotal Quotes:\n" + str(total_quotes(data_dict)))
	# print("\nTotal Base Costs:\n" + money(total_base(data_dict)))
	# print("\nTotal Costs:\n" + money(total_cost(data_dict)))
	# print("\nAverage Base Costs:\n" + money(avg_base(data_dict)))
	# print("\nAverage Costs:\n" + money(avg_cost(data_dict)))
	print(dict_print("Statistical reporting", statistical_reporting))
	
	# break_dict_print = {
		# 1: "A",
		# 2: ["A"],
		# 3: ["A", "B"],
		# 4: [i for i in range(12)],
		# "I'm hoping this long key will have som e weird effect on the spacing": "A",
		# 6: "I'm hoping that this long value will have some weird effect on the spacing",
		# 7: "A",
		# 8: [i for i in range(12)],
		# 9: "A",
		# 10: "A",
		# 11: "A",
		# 12: "A",
		# 13: [i for i in range(1200)],
		# 14: "A",
		# 15: ["A", "B", "C", "D", "E", "F"],
		# 16: ["print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))"],
		# 17: ["print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))"],
		# 18: ["print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))"],
		# 19: ["print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))"],
		# 20: "A",
		# 21: [i for i in range(12)]
	# }
	
	# print(dict_print("Break dict print:", break_dict_print, number=True))
	
	
	
	
##############################################################################################
##############################################################################################
###########                       Version for collect function                    ############
##############################################################################################
##############################################################################################

		
	# def collect(dat, fieldname, each_predicate=None, each_func=None, all_predicate=None, all_func=None, is_int=False, is_float=False):
		# # predicate Some - filter the list based on an anonymous selection function 
		# # predicate None - don't filter ^ (All will be included)
		# # func Some - apply a function to all returning values.
		# # func None - return un-modified values.
		
		# values = {}
		# for qNo, info in dat.items():
			# val = info[fieldname].strip()
			# values[val] = 
			# models[m] = 1 if m not in models else models[m] + 1
		# for qNo, info in dat.items():
			# w = int(info[fieldnames[2]].strip())
			# weeks[w] = 1 if w not in weeks else weeks[w] + 1
		# for qNo, info in dat.items():
			# d = info[fieldnames[3]].strip()
			# dealers[d] = 1 if d not in dealers else dealers[d] + 1
			
	# def sort_dict_keys(d):
		# keys = d.keys()
		# keys.sort()
		# return keys
	
	# def model_counts(dat) :
		# models = collect(dat, fieldnames[1], all_func=sort_dict_keys)
		# models = {m: models[m] for m in models}
		# return models
	
	# def weekly_counts(dat) :
		# weeks = {}		
		# for qNo, info in dat.items():
			# w = int(info[fieldnames[2]].strip())
			# weeks[w] = 1 if w not in weeks else weeks[w] + 1
		
		# keys = weeks.keys()
		# weeks = {i: (weeks[i] if i in keys else 0) for i in range(1, max(keys) + 1)}
		# return weeks
	
	# def dealer_counts(dat) :
		# dealers = {}
		# for qNo, info in dat.items():
			# d = info[fieldnames[3]].strip()
			# dealers[d] = 1 if d not in dealers else dealers[d] + 1
		
		# ds = list(dealers.keys())
		# ds.sort()
		# dealers = {d: dealers[d] for d in ds}
		# return dealers
		
	# def total_base(dat):
		# bases = []
		# for k, info in dat.items():
			# b = float(info[fieldnames[4]].strip()[1:])
			# if info[fieldnames[6]]:
				# b *= US_CDN_RATIO
			# bases.append(b)
		# return sum(bases)
		
	# def total_cost(dat):
		# costs = []
		# for k, info in dat.items():
			# c = float(info[fieldnames[5]].strip()[1:])
			# if info[fieldnames[6]]:
				# c *= US_CDN_RATIO
			# costs.append(c)
		# return sum(costs)
		
	# def total_quotes(dat):
		# return len(dat)
		
	# def avg_base(dat):
		# return total_base(dat) / total_quotes(dat)
	
	# def avg_cost(dat):
		# return total_cost(dat) / total_quotes(dat)
		
	# def top_dealer(d):
		# top_dealer = -1, None
		# for d, c in d.items():
			# if not top_dealer:
				# top_dealer = c, d
			# elif top_dealer[0] < c:
				# top_dealer = c, d
		# return top_dealer
		
	# def top_model(d):
		# top_model = -1, None
		# for m, c in d.items():
			# if not top_model:
				# top_model = c, m
			# elif top_model[0] < c:
				# top_model = c, m
		# return top_model
		
	# def bottom_dealer(d):
		# bottom_dealer = float("inf"), None
		# for d, c in d.items():
			# if not bottom_dealer:
				# bottom_dealer = c, d
			# elif bottom_dealer[0] > c:
				# bottom_dealer = c, d
		# return bottom_dealer
		
	# def bottom_model(d):
		# bottom_model = float("inf"), None
		# for m, c in d.items():
			# if not bottom_model:
				# bottom_model = c, m
			# elif bottom_model[0] > c:
				# bottom_model = c, m
		# return bottom_model
		
	# def top_5_dealers(dat):
		# top_5 = {}
		# d = dealer_counts(dat)
		# for i in range(min(5, len(d))):
			# c, td = top_dealer(d)
			# if c in top_5:
				# if type(top_5[c]) == list:
					# top_5[c].append(td)
				# else:
					# top_5[c] = [top_5[c], td]
			# else:
				# top_5[c] = td
			# del d[td]
		# return top_5
		
	# def bottom_5_dealers(dat):
		# bottom_5 = {}
		# d = dealer_counts(dat)
		# for i in range(min(5, len(d))):
			# c, bd = bottom_dealer(d)
			# if c in bottom_5:
				# if type(bottom_5[c]) == list:
					# bottom_5[c].append(bd)
				# else:
					# bottom_5[c] = [bottom_5[c], bd]
			# else:
				# bottom_5[c] = bd
			# del d[bd]
		# return bottom_5
		
	# def top_5_models(dat):
		# top_5 = {}
		# m = model_counts(dat)
		# for i in range(min(5, len(m))):
			# c, tm = top_model(m)
			# if c in top_5:
				# if type(top_5[c]) == list:
					# top_5[c].append(tm)
				# else:
					# top_5[c] = [top_5[c], tm]
			# else:
				# top_5[c] = tm
			# del m[tm]
		# return top_5
		
	# def bottom_5_models(dat):
		# bottom_5 = {}
		# m = model_counts(dat)
		# for i in range(min(5, len(m))):
			# c, bm = bottom_model(m)
			# if c in bottom_5:
				# if type(bottom_5[c]) == list:
					# bottom_5[c].append(bm)
				# else:
					# bottom_5[c] = [bottom_5[c], bm]
			# else:
				# bottom_5[c] = bm
			# del m[bm]
		# return bottom_5
		
	# print(dict_print("Model Counts:", model_counts(data_dict)))
	# print(dict_print("Weekly Counts:", weekly_counts(data_dict)))
	# print(dict_print("Dealer Counts:", dealer_counts(data_dict)))
	# print("\nTotal Quotes:\n" + str(total_quotes(data_dict)))
	# print("\nTotal Base Costs:\n" + money(total_base(data_dict)))
	# print("\nTotal Costs:\n" + money(total_cost(data_dict)))
	# print("\nAverage Base Costs:\n" + money(avg_base(data_dict)))
	# print("\nAverage Costs:\n" + money(avg_cost(data_dict)))
	# print(dict_print("Top 5 Dealers:", top_5_dealers(data_dict), number=True))
	# print(dict_print("Top 5 Models:", top_5_models(data_dict), number=True))
	# print(dict_print("Bottom 5 Dealers:", bottom_5_dealers(data_dict), number=True))
	# print(dict_print("Bottom 5 Models:", bottom_5_models(data_dict), number=True))
	
	
