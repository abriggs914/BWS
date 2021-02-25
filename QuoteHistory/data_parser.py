import csv
import functools
from utility import *

# Quotes are up-to-date as of Feb.22/2021 Quote 25771


data_file = "data.csv"
out_file = "output.txt"
US_CDN_RATIO = 1.269
WRITING = False

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

# Function used to calculate the number of total days that have passed given the number of worked days.
# i.e. in week 3, typically you would be working on days 11 - 15. These as total days would be 15 - 19
# which includes any weekends and excludes any holidays that would cause a skipped say.
# usage: day_calculator(11) => 15
# usage: day_calculator(11, 1) => 16
day_calculator = lambda day, n_holidays=0: (((day - 1) // 5) * 2) + day + n_holidays

# Function used to generate a list of lists containing the total day count for each day up to the given work day number
# This doesn't work with holidays yet. Want to have a dictionary of the day that the holiday fell on.
def work_weeks(day, holidays):
		
	dw = lambda d, h=0: d - (2*((d-(max(0, ((d - 1) % 7) - 4)))//7)) - (max(0, ((d - 1) % 7) - 4))

	res = []
	holidays.sort()
	print("holidays: {h}".format(h=holidays))
	idx = 0
	res = [dw(i) for i in range(1, day+1)]
	res = [[res[i+j] for j in range(min(5, day - i))] for i in range(0, day+1, 7)]
	days = ["monday", "tuesday", "wednesday", "thursday", "friday"]
	
	idx = 1
	res = {}
	r = []
	i = 0
	while i < day:
		if i+1 not in holidays:
			r.append(idx)
			idx += 1
		else:
			r.append(" ")
		if len(r) == 5:
			res[len(res)+1] = dict(zip(days, r))
			r = []
		if i % 7 == 4:
			i += 2
		i += 1
	if r:
		res[len(res)+1] = dict(zip(days[:len(r)], r))
		
	return res


class Quote:

	def __init__(self, number, model, week, dealer, base, gross, cost, n_options, is_us):
		self.number = int(number.strip())
		self.model = model.strip()
		self.week = int(week.strip())
		self.dealer = dealer.strip().title()
		self.base = float(base.strip()[1:])
		self.gross = float(gross.strip()[1:])
		self.cost = float(cost.strip()[1:])
		self.n_options = int(n_options.strip())
		self.is_us = int(is_us.strip())
		
		self.baseCDN = self.base * (US_CDN_RATIO if self.is_us else 1)
		self.grossCDN = self.gross * (US_CDN_RATIO if self.is_us else 1)
		self.costCDN = self.cost * (US_CDN_RATIO if self.is_us else 1)
		self.options = self.grossCDN - self.baseCDN
		self.discount = self.costCDN - self.grossCDN
		self.avg_option_cost = self.options / max(1, self.n_options)
		
		print(dict_print(self.info_dict(), "Initialized quote"))
		
	def info_dict(self):
		return {
			"number": self.number,
			"model": self.model,
			"week": self.week,
			"dealer": self.dealer,
			"base": money(self.base),
			"gross": money(self.gross),
			"cost": money(self.cost),
			"n_options": self.n_options,
			"is_us": self.is_us,
			"baseCDN": money(self.baseCDN),
			"grossCDN": money(self.grossCDN),
			"costCDN": money(self.costCDN),
			"options": money(self.options),
			"avg_option_cost": money(self.avg_option_cost),
			"discounts": money(self.discount)
		}
		
	def __repr__(self):
		return "Quote #%s" % self.number


WRITING = input("To write results to \"output.txt\", type \"1\".\n\tHit enter to proceed.\n") == "1"
print("Re-writing \"output.txt\"..." if WRITING else "Results:")

with open(data_file, 'r') as data, open(out_file, 'w' if WRITING else 'r') as out:

	def write(content):
		if WRITING:
			out.write(content + "\n")
	
	data_dict = csv.DictReader(data, delimiter=',')
	fieldnames = data_dict.fieldnames
	# data_dict = {line[fieldnames[0]]: line for line in data_dict}
	quotes = [Quote(*line.values()) for line in data_dict]
	print("keys: " + str(fieldnames))
	write("keys: " + str(fieldnames))
	
	print("quotes: {0}".format(quotes))
	
	print(dict_print(dict(zip([qNo.number for qNo in quotes], [qNo.info_dict() for qNo in quotes])), "Quote history"))
	write(dict_print(dict(zip([qNo.number for qNo in quotes], [qNo.info_dict() for qNo in quotes])), "Quote history"))

		
			
	# Pad empty string on a dict key to wnsure that it will be a unique key
	def unique_key(new_key, d):
		if new_key not in d:
			return new_key
		return unique_key(str(new_key) + " ", d)
			
	def model_counts(dat) :
		models = {}
		for qNo in dat:
			m = qNo.model
			models[m] = 1 if m not in models else models[m] + 1
		
		ms = list(models.keys())
		ms.sort()
		models = {m: models[m] for m in ms}
		return models
	
	def weekly_counts(dat) :
		weeks = {}		
		for qNo in dat:
			w = qNo.week
			c = qNo.costCDN
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
		for qNo in dat:
			d = qNo.dealer
			dealers[d] = 1 if d not in dealers else dealers[d] + 1
		
		ds = list(dealers.keys())
		ds.sort()
		dealers = {d: dealers[d] for d in ds}
		return dealers
	
	def dealer_costs(dat) :
		dealers = {}
		for qNo in dat:
			d = qNo.dealer
			c = qNo.costCDN
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
		for qNo in dat:
			b = qNo.baseCDN
			u = qNo.is_us
			if u:
				b *= US_CDN_RATIO
			bases.append(b)
		return sum(bases)
		
	def total_cost(dat):
		costs = []
		for qNo in dat:
			c = qNo.costCDN
			u = qNo.is_us
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
		
	def avg_dealer_reporting(dat):
		# table of dealers showing: totals [base, gross, cost, options], avgs [base/model, gross/model, cost/model, options/model]
		# table of total dealers showing: totals [base, gross, cost, options], avgs [base/model, gross/model, cost/model, options/model]
		# print("t: {t}, d: {d}".format(t=type(dat), d=dat))
		res = {
				"# Quotes": 0,
				"First Quote": float("inf"),
				"Last Quote": float("-inf"),
				"Total BaseCDN": 0,
				"Total GrossCDN": 0,
				"Total CostCDN": 0,
				"Total DiscountCDN": 0,
				"Total Options": 0,
				"Average BaseCDN": 0,
				"Average GrossCDN": 0,
				"Average CostCDN": 0,
				"Average DiscountCDN": 0,
				"Average Options": 0
			}
		dealers = list([info.dealer for info in dat])
		dealers.sort()
		res = dict(zip(dealers, [res.copy() for i in range(len(dealers))]))
		for qNo in dat:
			# print("RES: " + str(res))
			res[qNo.dealer]["# Quotes"] += 1
			res[qNo.dealer]["First Quote"] = min(res[qNo.dealer]["First Quote"], qNo.number)
			res[qNo.dealer]["Last Quote"] = max(res[qNo.dealer]["Last Quote"], qNo.number)
			res[qNo.dealer]["Total BaseCDN"] += qNo.baseCDN
			res[qNo.dealer]["Total GrossCDN"] += qNo.grossCDN
			res[qNo.dealer]["Total CostCDN"] += qNo.costCDN
			res[qNo.dealer]["Total DiscountCDN"] += qNo.discount
			res[qNo.dealer]["Total Options"] += qNo.n_options
			
			res[qNo.dealer]["Average BaseCDN"] += qNo.baseCDN
			res[qNo.dealer]["Average GrossCDN"] += qNo.grossCDN
			res[qNo.dealer]["Average CostCDN"] += qNo.costCDN
			res[qNo.dealer]["Average DiscountCDN"] += qNo.discount
			res[qNo.dealer]["Average Options"] += qNo.n_options
			
		for dealer in res:
			res[dealer]["Total BaseCDN"] = money(res[dealer]["Total BaseCDN"])
			res[dealer]["Total GrossCDN"] = money(res[dealer]["Total GrossCDN"])
			res[dealer]["Total CostCDN"] = money(res[dealer]["Total CostCDN"])
			res[dealer]["Total DiscountCDN"] = money(res[dealer]["Total DiscountCDN"])
			
			res[dealer]["Average BaseCDN"] = money(res[dealer]["Average BaseCDN"] / res[dealer]["# Quotes"])
			res[dealer]["Average GrossCDN"] = money(res[dealer]["Average GrossCDN"] / res[dealer]["# Quotes"])
			res[dealer]["Average CostCDN"] = money(res[dealer]["Average CostCDN"] / res[dealer]["# Quotes"])
			res[dealer]["Average DiscountCDN"] = money(res[dealer]["Average DiscountCDN"] / res[dealer]["# Quotes"])
			res[dealer]["Average Options"] /= res[dealer]["# Quotes"]
		return res
		
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
		
	def top_5_dealers(dat, num=5):
		top_5 = {}
		d = dealer_counts(dat)
		for i in range(min(num, len(d))):
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
		
	def bottom_5_dealers(dat, num=5):
		bottom_5 = {}
		d = dealer_counts(dat)
		for i in range(min(num, len(d))):
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
		
	def top_5_models(dat, num=5):
		top_5 = {}
		m = model_counts(dat)
		for i in range(min(num, len(m))):
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
		
	def bottom_5_models(dat, num=5):
		bottom_5 = {}
		m = model_counts(dat)
		for i in range(min(num, len(m))):
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
		
		
	
	# Used for when the dict keys will be a monetary value.
	# Works for tie conditions, ensuring 5 unique keys.
	# Defalts to costCDN.
	def rank_money(dat, category="costCDN", num=5, bottom=False):
		values = [(i, round(100 * getattr(qNo, category) / 100)) for i, qNo in enumerate(dat)]
		values.sort(reverse=not bottom, key=lambda tup: tup[1])
		top_5 = {}
		for i, info in enumerate(values):
			qNo, val = info
			if len(top_5) == min(num, len(dat)):
				break
			
			content = {"Quote": dat[qNo].number, "Model": dat[qNo].model}
			v = money(val)
			if v in top_5:
				if type(top_5[v]) == list:
					top_5[v].append(content)
				else:
					top_5[v] = [top_5[v]] + [content]
			else:
				top_5[v] = content
			
		return top_5
		
		
	def top_5_customized(dat, num=5):
		customs = [(i, qNo.n_options) for i, qNo in enumerate(dat)]
		customs.sort(reverse=True, key=lambda tup: tup[1])
		top_5 = {}
		for i, info in enumerate(customs):
			qNo, n_options = info
			if len(top_5) == min(num, len(dat)):
				break
			
			content = "Quote #{n}, Model: {m}".format(n=dat[qNo].number, m=dat[qNo].model)
			n = n_options
			if n in top_5:
				if type(top_5[n]) == list:
					top_5[n].append(content)
				else:
					top_5[n] = [top_5[n]] + [content]
			else:
				top_5[n] = content
			
		return top_5
		
	def bottom_5_customized(dat, num=5):
		customs = [(i, qNo.n_options) for i, qNo in enumerate(dat)]
		customs.sort(key=lambda tup: tup[1])
		top_5 = {}
		for i, info in enumerate(customs):
			qNo, n_options = info
			if len(top_5) == min(num, len(dat)):
				break
			
			content = "Quote #{n}, Model: {m}".format(n=dat[qNo].number, m=dat[qNo].model)
			n = n_options
			if n in top_5:
				if type(top_5[n]) == list:
					top_5[n].append(content)
				else:
					top_5[n] = [top_5[n]] + [content]
			else:
				top_5[n] = content
			
		return top_5
		
	def sequential_quotes(dat):
		qNos = [qNo.number for qNo in dat]
		qNos.sort()
		i = 0
		r = range(qNos[0], qNos[-1] + 1)
		res = {}
		for qNo in r:
			c = int(qNos[i]) == qNo
			m = "check" if c else ""
			res[qNo] = m
			# print("qNo: {qNo}\t-\t{c}".format(qNo=qNo, c=m))
			# write("qNo: {qNo}\t-\t{c}".format(qNo=qNo, c=m))
			i += 1 if c else 0
			
		ir = r.stop - 1 - r.start
		lq = len(qNos)
		space = unique_key("", res)
		res.update({
			"": space,
			"range":  str(r.start) + " => " + str(r.stop-1),
			"in range": ir,
			"num": lq,
			"percentage": "%.3f" % (100 * lq / ir) + " %"
		})
		return res
	
	statistical_reporting = {
		"Total Quotes": total_quotes(quotes),
		"Highest quoted week": highest_quoted_week(quotes),
		"Lowest quoted week": lowest_quoted_week(quotes),
		"Total Base Costs": money(total_base(quotes)),
		"Total Costs": money(total_cost(quotes)),
		"Average Base Costs": money(avg_base(quotes)),
		"Average Costs": money(avg_cost(quotes))
	}
	
		
	to_view = {
		"Model Counts:": (model_counts, {"number": True}),
		"Weekly Counts:": (weekly_counts, {"number": True}),
		"Dealer Counts:": (dealer_counts, {"number": True}),
		"Dealer Costs:": (dealer_costs, {"number": True}),
		"Top 5 Dealers:": (top_5_dealers, {"number": True}),
		"Bottom 5 Dealers:": (bottom_5_dealers, {"number": True}),
		"Top 5 Models:": (top_5_models, {"number": True}),
		"Bottom 5 Models:": (bottom_5_models, {"number": True}),
		"Top 5 Bases:": (rank_money, {"category": "baseCDN"}, {"number": True}),
		"Bottom 5 Bases:": (rank_money, {"category": "baseCDN", "bottom": True}, {"number": True}),
		"Top 5 Gross:": (rank_money, {"category": "grossCDN"}, {"number": True}),
		"Bottom 5 Gross:": (rank_money, {"category": "grossCDN", "bottom": True}, {"number": True}),
		"Top 5 Discounts:": (rank_money, {"category": "discount", "bottom": True}, {"number": True}),
		"Bottom 5 Discounts:": (rank_money, {"category": "discount"}, {"number": True}),
		"Top 5 Costs:": (rank_money, {"category": "costCDN"}, {"number": True}),
		"Bottom 5 Costs:": (rank_money, {"category": "costCDN", "bottom": True}, {"number": True}),
		"Top 5 Customized:": (top_5_customized, {"number": True}),
		"Bottom 5 Customized:": (bottom_5_customized, {"number": True}),
		"Weekly Reporting": (avg_weekly_reporting, {"number": True}),
		"Dealer Reporting": (avg_dealer_reporting, {"number": True}),
		"Statistical Reporting": (lambda x: statistical_reporting, {}),
		"Range of Quotes": (sequential_quotes, {"l": 1, "sep": 1})
	}
	
	for title, dat in to_view.items():
		if len(dat) == 3:
			func, fargs, pargs = dat
			print(dict_print(func(quotes, **fargs), title, **pargs))
			write(dict_print(func(quotes, **fargs), title, **pargs))
		else:
			func, args = dat
			print(dict_print(func(quotes), title, **args))
			write(dict_print(func(quotes), title, **args))
			
	
	print(dict_print(to_view, "to view", number=True))
	

	# a = [work_weeks(i, [43, 8,9,10,11,12,13,14,15,16,17]) for i in range(1, 45)]
	# a = work_weeks(45, [43, 8,9,10,11,12,13,14,15,16,17])
	a = work_weeks(52, [43])
	# a = [work_weeks(i, [43]) for i in range(1, 45)]
	# b = "\n".join([str(i+1) + " - " + str(v) for i, v in enumerate(a)])
	print(dict_print(a, "work weeks", table_title="Weeks"))  #, sort_header=True
	write(dict_print(a, "work weeks", table_title="Weeks"))
