import csv
import functools
from utility import *

locale.setlocale(locale.LC_ALL, "")
data_file = "data.csv"
out_file = "output.txt"
US_CDN_RATIO = 1.269
WRITING = True

# calculate costing for stacked discounts
costing = lambda og, discounts: og * functools.reduce(lambda a, b: (1 - a) * (1 - b), discounts)
# Usage: costing(741.89, [0.01, 0.015])
# >>> 723.4540334999999
# This demonstrates cost calculation for initial value 741.89 and stacked discounts of 1% and 1.5%

# conversion functions for vonverting cost->CDN->US and any variation in-between
PROFIT_MARGIN = 0.7
FE_RATE = 1.269  # CDN => US
cost_cdn = lambda x: x / PROFIT_MARGIN
cost_us = lambda x: cost_cdn(x) / FE_RATE
cdn_us = lambda x: x / FE_RATE
us_cdn = lambda x : x * FE_RATE
cdn_cost = lambda x: x * PROFIT_MARGIN
us_cost = lambda x: cdn_cost(us_cdn(x))


class Quote:

	def __init__(self, number, model, week, dealer, base, cost, is_us):
		self.number = number
		self.model = model
		self.week = week
		self.dealer = dealer
		self.base = base
		self.cost = cost
		self.is_us = is_us
		
	def __repr__(self):
		return "Quote # %s" % self.number


with open(data_file, 'r') as data, open(out_file, 'w') as out:

	def write(content):
		if WRITING:
			out.write(content + "\n")
	
	data_dict = csv.DictReader(data, delimiter=',')
	fieldnames = data_dict.fieldnames
	data_dict = {line[fieldnames[0]]: line for line in data_dict}
	print("keys: " + str(fieldnames))
	write("keys: " + str(fieldnames))

		
			
	# Pad empty string on a dict key to wnsure that it will be a unique key
	def unique_key(new_key, d):
		if new_key not in d:
			return new_key
		return unique_key(str(new_key) + " ", d)
			
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
			u = int(info[fieldnames[6]].strip())
			if u:
				c *= US_CDN_RATIO
			weeks[w] = (1, c) if w not in weeks else (weeks[w][0] + 1, weeks[w][1] + c)
		
		keys = weeks.keys()
		# weeks = {unique_key((weeks[i][0] if i in keys else 0), weeks): money(weeks[i][1] if i in keys else 0) for i in range(1, max(keys) + 1)}
		# weeks = {i: money(weeks[i][1] if i in keys else 0) for i in range(1, max(keys) + 1)}
		new_weeks = {}
		for i in range(1, max(keys) + 1):
			key = unique_key((weeks[i][0] if i in keys else 0), new_weeks)
			val = money(weeks[i][1] if i in keys else 0)
			# print("UNIQUE:\t<{k}>\n\t<{v}>".format(k=key, v=val))
			new_weeks[key] = val
		weeks.clear()
		weeks.update(new_weeks)
		# print("KEYS: {keys}\nRange: {range}\nWeeks: {weeks}".format(keys=keys, range=range(1, int(str(list(keys)[-1]).strip()) + 1), weeks=weeks))
		# for i in range(-1,15):
			# print("\t{i} in keys: {tf}".format(i=i, tf=i in keys))
		# raise ValueError("QUIT HERE")
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
			u = int(info[fieldnames[6]].strip())
			if u:
				c *= US_CDN_RATIO
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
			nQts = int(str(nQts).strip())
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
			nQts = int(str(nQts).strip())
			if not all(best_week) or best_week[1] > nQts:
				best_week = (i + 1, nQts)
		if not all(best_week):
			return "No quotes to report."
		return "{n} quote{s} in week {w}".format(n=best_week[1], w=best_week[0], s=("s" if best_week[1] > 1 else ""))
		
	def total_base(dat):
		bases = []
		for k, info in dat.items():
			b = float(info[fieldnames[4]].strip()[1:])
			u = int(info[fieldnames[6]].strip())
			if u:
				b *= US_CDN_RATIO
			bases.append(b)
		return sum(bases)
		
	def total_cost(dat):
		costs = []
		for k, info in dat.items():
			c = float(info[fieldnames[5]].strip()[1:])
			u = int(info[fieldnames[6]].strip())
			if u:
				c *= US_CDN_RATIO
			costs.append(c)
		return sum(costs)
		
	def total_quotes(dat):
		return len(dat)
		
	def avg_weekly_reporting(dat):
		weekly = weekly_counts(dat)
		t = total_quotes(dat)
		length = len(weekly)
		weeks = {
			"Average # quotes per week:": "%.3f" % (sum([int(str(k).strip()) for k in weekly.keys()]) / length),
			"Average quote price per week": money(sum([money_value(wv) for wv in weekly.values()]) / length)
		}
		weeks.update({c: p for c, p in weekly.items()})
		return weeks
		
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
		bases = [(k, round(100 * float(info[fieldnames[4]].strip()[1:])) / 100, info[fieldnames[6]].strip()) for k, info in dat.items()]
		bases.sort(reverse=True, key=lambda tup: tup[1])
		top_5 = {}
		for i, info in enumerate(bases):
			qNo, base, us = info
			if len(top_5) == 5:
				break
			
			content = "Quote #{n}, Model: {m}".format(n=qNo, m=dat[qNo][fieldnames[1]].strip())
			if int(us.strip()):
				base *= US_CDN_RATIO
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
		bases = [(k, round(100 * float(info[fieldnames[4]].strip()[1:])) / 100, info[fieldnames[6]].strip()) for k, info in dat.items()]
		bases.sort(key=lambda tup: tup[1])
		top_5 = {}
		for i, info in enumerate(bases):
			qNo, base, us = info
			if len(top_5) == 5:
				break
			
			content = "Quote #{n}, Model: {m}".format(n=qNo, m=dat[qNo][fieldnames[1]].strip())
			if int(us.strip()):
				base *= US_CDN_RATIO
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
		costs = [(k, round(100 * float(info[fieldnames[5]].strip()[1:])) / 100, info[fieldnames[6]].strip()) for k, info in dat.items()]
		costs.sort(reverse=True, key=lambda tup: tup[1])
		top_5 = {}
		for i, info in enumerate(costs):
			qNo, cost, us = info
			if len(top_5) == 5:
				break
			
			content = "Quote #{n}, Model: {m}".format(n=qNo, m=dat[qNo][fieldnames[1]].strip())
			if int(us.strip()):
				cost *= US_CDN_RATIO
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
		costs = [(k, round(100 * float(info[fieldnames[5]].strip()[1:])) / 100, info[fieldnames[6]].strip()) for k, info in dat.items()]
		costs.sort(key=lambda tup: tup[1])
		top_5 = {}
		for i, info in enumerate(costs):
			qNo, cost, us = info
			if len(top_5) == 5:
				break
			
			content = "Quote #{n}, Model: {m}".format(n=qNo, m=dat[qNo][fieldnames[1]].strip())
			if int(us.strip()):
				cost *= US_CDN_RATIO
			c = money(cost)
			if c in top_5:
				if type(top_5[c]) == list:
					top_5[c].append(content)
				else:
					top_5[c] = [top_5[c]] + [content]
			else:
				top_5[c] = content
			
		return top_5
		
	def sequential_quotes(dat):
		qNos = list(dat.keys())
		qNos.sort()
		i = 0
		r = range(int(qNos[0].strip()), int(qNos[-1].strip()) + 1)
		for qNo in r:
			c = int(qNos[i]) == qNo
			m = "check" if c else ""
			print("qNo: {qNo}\t-\t{c}".format(qNo=qNo, c=m))
			write("qNo: {qNo}\t-\t{c}".format(qNo=qNo, c=m))
			i += 1 if c else 0
			
		ir = r.stop - 1 - r.start
		lq = len(qNos)
		res = {
			"range":  str(r.start) + " => " + str(r.stop-1),
			"in range": ir,
			"num": lq,
			"percentage": "%.3f" % (100 * lq / ir) + " %"
		}
		print(dict_print(res, "range of quotes"))
		write(dict_print(res, "range of quotes"))
		# print("range of quotes:\n\t\t{rs} => {re}\nin range:\t{ir}\nnum:\t\t{n}\nPercentage:\t{p} %".format(rs=r.start, re=r.stop-1, ir=ir, n=lq, p="%.3f"%(100 * lq/ir)))
		
	print(dict_print(model_counts(data_dict), "Model Counts:", number=True))
	write(dict_print(model_counts(data_dict), "Model Counts:", number=True))
	print(dict_print(weekly_counts(data_dict), "Weekly Counts:", number=True))
	write(dict_print(weekly_counts(data_dict), "Weekly Counts:", number=True))
	print(dict_print(dealer_counts(data_dict), "Dealer Counts:", number=True))
	write(dict_print(dealer_counts(data_dict), "Dealer Counts:", number=True))
	print(dict_print(dealer_costs(data_dict), "Dealer Costs:", number=True))
	write(dict_print(dealer_costs(data_dict), "Dealer Costs:", number=True))
	print(dict_print(top_5_dealers(data_dict), "Top 5 Dealers:", number=True))
	write(dict_print(top_5_dealers(data_dict), "Top 5 Dealers:", number=True))
	print(dict_print(top_5_models(data_dict), "Top 5 Models:", number=True))
	write(dict_print(top_5_models(data_dict), "Top 5 Models:", number=True))
	print(dict_print(bottom_5_dealers(data_dict), "Bottom 5 Dealers:", number=True))
	write(dict_print(bottom_5_dealers(data_dict), "Bottom 5 Dealers:", number=True))
	print(dict_print(bottom_5_models(data_dict), "Bottom 5 Models:", number=True))
	write(dict_print(bottom_5_models(data_dict), "Bottom 5 Models:", number=True))
	print(dict_print(top_5_base(data_dict), "top 5 bases: ", number=True))
	write(dict_print(top_5_base(data_dict), "top 5 bases: ", number=True))
	print(dict_print(bottom_5_base(data_dict), "bottom 5 bases: ", number=True))
	write(dict_print(bottom_5_base(data_dict), "bottom 5 bases: ", number=True))
	print(dict_print(top_5_cost(data_dict), "top 5 costs: ", number=True))
	write(dict_print(top_5_cost(data_dict), "top 5 costs: ", number=True))
	print(dict_print(bottom_5_cost(data_dict), "bottom 5 costs: ", number=True))
	write(dict_print(bottom_5_cost(data_dict), "bottom 5 costs: ", number=True))
	print(dict_print(avg_weekly_reporting(data_dict), "Weekly reporting", number=True))
	write(dict_print(avg_weekly_reporting(data_dict), "Weekly reporting", number=True))
	
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
	print(dict_print(statistical_reporting, "Statistical reporting"))
	write(dict_print(statistical_reporting, "Statistical reporting"))
	
	sequential_quotes(data_dict)
	
	break_dict_print = {
		1: "A",
		2: ["A"],
		3: ["A", "B"],
		4: [i for i in range(12)],
		"I'm hoping this long key will have som e weird effect on the spacing": "A",
		6: "I'm hoping that this long value will have some weird effect on the spacing",
		7: "A",
		8: [i for i in range(12)],
		9: {"A":"".join(["#" for i in range(16)]), "B":2, "C":3, "D":4, "E":5},
		10: "A",
		11: "A",
		12: "A",
		13: [i for i in range(120)],
		14: "A",
		15: ["A", "B", "C", "D", "E", "F"],
		16: ["print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))"],
		17: ["print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))"],
		18: ["print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))"],
		19: ["print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))", "print(dict_print(\"top 5 bases: \", top_5_base(data_dict), number=True))"],
		20: "A",
		21: [i for i in range(12)]
	}
	
	print(dict_print(break_dict_print, "Break dict print:", number=True))
	# write(dict_print(break_dict_print, "Break dict print:", number=True))
	
	test_dict_print = {
		"set 1": {i: chr(i) for i in range(97, 107)},
		"set 2": {i: chr(i-32) for i in range(97, 107)},
		"set 3": {i-32: chr(i-32) for i in range(97, 107)},
		"set 4": {chr(i-32): chr(i-32) for i in range(97, 107)},
		"set 5": {chr(i-32): chr(i-32) for i in range(97, 107)},
		"set 6": {chr(i-32): chr(i-32) for i in range(97, 107)},
		"set 7": {chr(i-32): chr(i-32) for i in range(97, 107)},
		"set 8": {chr(i-32): chr(i-32) for i in range(97, 107)},
		"set 9": {chr(i-32): chr(i-32) for i in range(97, 107)},
		"set 10": {chr(i-32): chr(i-32) for i in range(97, 107)},
		"set 11": {chr(i-32): chr(i-32) for i in range(97, 107)},
		"set 12": {chr(i-32): chr(i-32) for i in range(97, 107)},
		"set 13": {chr(i-32): chr(i-32) for i in range(97, 107)},
		"set 14": {chr(i-32): chr(i-32) for i in range(97, 107)},
		"set 15": {"first name": "Avery", "last name": "Briggs", "fav number": 10001212154542115, "fav string": "qwertyuiopasdfghjklzxcvbnm"}
	}
	
	print(dict_print(test_dict_print, "test dict print", number=True, sort_header=True, min_encapsulation=True))
	# write(dict_print(test_dict_print, "test dict print", number=True, sort_header=True, min_encapsulation=True))
	
	
	
	
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
	
	
