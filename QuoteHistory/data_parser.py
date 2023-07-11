import csv
import functools
from utility import *
import datetime
import calendar
from matplotlib import pyplot as plt
import random


# Quotes are up-to-date as of Feb.22/2021 Quote 25771


data_file = "data.csv"
out_file = "output.txt"
US_CDN_RATIO = avg([1.269, 1.255, 1.245, 1.235, 1.210])
WRITING = False

# calculate costing for stacked discounts
costing = lambda og, discounts: og * functools.reduce(lambda a, b: (1 - a) * (1 - b), discounts)
# Usage: costing(741.89, [0.01, 0.015])
# >>> 723.4540334999999
# This demonstrates cost calculation for initial value 741.89 and stacked discounts of 1% and 1.5%


# cost		-	Monetary value
# margin	-	Desired profit margin
# FE		-	Federal exchange rate
# increase	-	Price increase (percentage)
def updated_costing(cost, margin=0.3, FE=1.269, increase=0):
	cost *= (1 + (increase / 100))
	margin = 1 - margin
	return {
		"cost": money(cost),
		"CDN": money((cost / margin) if cost >= 0 else (cost * margin)),
		"US": money(((cost / margin) if cost >= 0 else (cost * margin)) / FE)
	}
# usage - print(dict_print(updated_costing(559.86, 0.15, 1.269, 4), "Updated costing"))

def update_costing(cost, margin=0.3, FE=1.269, increase=0):
	print(dict_print(updated_costing(cost, margin, FE, increase), "Update costing {0}".format(money(cost))))

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
def work_weeks(first_day, public_holdays, personal_holidays, sick_days):
	holidays = public_holdays + personal_holidays + sick_days
	holidays.sort()
		
	today = datetime.date.today()
	# today = datetime.date.fromisoformat("2021-07-04")
	# today = datetime.date.fromisoformat("2021-05-25")
	# today = datetime.date.fromisoformat("2021-12-31")
	# today = datetime.date.fromisoformat("2022-04-20")
	day = (today - first_day).days + 1
	dw = lambda d, h=0: d - (2*((d-(max(0, ((d - 1) % 7) - 4)))//7)) - (max(0, ((d - 1) % 7) - 4))

	res = []
	holidays.sort()
	print("Days past: {d}, holidays:\n{h}".format(d=day, h="\n".join(holidays)))
	diff = lambda h: (datetime.date.fromisoformat(h) - first_day).days + 1
	holidays_nums = [diff(h) for h in holidays]
	print("Days past: {d}, holidays_nums: {h}".format(d=day, h=holidays_nums))
	idx = 0
	res = [dw(i) for i in range(1, day+1)]
	res = [[res[i+j] for j in range(min(5, day - i))] for i in range(0, day+1, 7)]
	days = ["monday", "tuesday", "wednesday", "thursday", "friday"]
	week_day_header = ["Worked", "Total", "Off", "Percentage Worked"]
	week_days = dict(zip(week_day_header, [dict(zip(days, [0 for day in days])) for j in week_day_header]))
	
	idx = 1
	res = {}
	r = []
	i = 0
	days_worked = 0
	week = 1
	monday = first_day
	str_holidays = list(map(str, holidays))
	while i < day:
		date_today = first_day + datetime.timedelta(days=i)
		day_of_week = datetime.date.fromisoformat(str(date_today))
		sdow = days[day_of_week.weekday()]
		is_holiday = str(date_today) in str_holidays
		# print("week_days:", week_days)
		# print("week_day_header:", week_day_header[0])
		# print("day_of_week", day_of_week)
		# print("sdwo",sdow)
		# print("week_days[week_day_header[0][day_of_week]]:", week_days[week_day_header[0]])
		
		week_days[week_day_header[0]].update({sdow: week_days[week_day_header[0]][sdow] + (0 if is_holiday else 1)})
		week_days[week_day_header[1]].update({sdow: week_days[week_day_header[1]][sdow] + 1})
		week_days[week_day_header[2]].update({sdow: week_days[week_day_header[2]][sdow] + (1 if is_holiday else 0)})
		week_days[week_day_header[3]].update({sdow: percent(week_days[week_day_header[0]][sdow] / max(1, week_days[week_day_header[1]][sdow]))})
		
		print("TODAY", date_today, ",", days[day_of_week.weekday()], ("\tholiday!" if is_holiday else ""))
		
		# print("i:", i, "day:", day)
		if i+1 not in holidays_nums:
			r.append(idx)
			idx += 1
		else:
			r.append(" ")
		if len(r) == 5:
			# week_str = len(res) + 1
			monday = first_day + datetime.timedelta(days=7*len(res))
			# print("monday  og", monday)
			week_str = str(monday) + " => " + str(monday + datetime.timedelta(days=4))
			lr = len(res)
			res[week_str] = {"week": week}
			res[week_str].update({"sun": 7*lr + 1})
			res[week_str].update(dict(zip(days, r)))
			res[week_str].update({"sat": 7*len(res)})
			r = []
			week += 1
		if i % 7 == 4:
			i += 2
		i += 1
	if r:
		monday = first_day + datetime.timedelta(days=7*len(res))
		week_str = str(monday) + " => " + str(monday + datetime.timedelta(days=4))
		res[week_str] = {"sun": 7*len(res) + 1}
		res[week_str].update({"week": week})
		res[week_str].update(dict(zip(days[:len(r)], r)))
		res[week_str].update({"sat": 7*len(res)})
	days_worked = idx - 1
		
	months = dict(zip([calendar.month_name[i] + " 2021" for i in range(1, 13)], ["" for i in range(12)]))
	first_month = first_day.month
	first_year = first_day.year
	
	date1 = first_day
	date2 = today
	m_date = datetime.date.fromisoformat(max(holidays))
	date2 = max(date2, m_date)
	date1 = date1.replace(day=1)
	date2 = date2.replace(day=1)
	months_str = calendar.month_name
	months = {}
	while date1 <= date2:
		month = date1.month
		year  = date1.year
		month_str = months_str[month]
		months["{} {}".format(month_str, year)] = ""
		next_month = month + 1 if month != 12 else 1
		next_year = year + 1 if next_month == 1 else year
		date1 = date1.replace(month=next_month, year=next_year)
	print(months)	
	next_holiday = None
	last_holiday = None
	# when_holiday_next = None
	# when_holiday_last = None
	print("months: " + str(months))
	holidays_past_pu = 0
	holidays_past_pr = 0
	for d, holiday in zip(holidays_nums, holidays):
		holiday = datetime.date.fromisoformat(holiday)
		month = holiday.month
		year = holiday.year
		sday = day_string(holiday)
		months[calendar.month_name[month] + " {}".format(year)] += sday + ", "
		print("holiday ({th}): {holiday}, d: {d}, day+1: {d1}, d>d1: {dd1}, hm: {hm}".format(th=type(holiday), d=d, holiday=holiday, hm=month, d1=(day), dd1=(d>day)))
		if d > day:
			if next_holiday is None:
				next_holiday = holiday
			else:
				if d < (holiday - first_day).days + 1:
					next_holiday = holiday
		
		if d <= day:
			if last_holiday is None:
				last_holiday = holiday
			else:
				if d >= (holiday - first_day).days + 1:
					last_holiday = holiday
					if holiday.strftime("%Y-%m-%d") in public_holidays:
						holidays_past_pu += 1
					if holiday.strftime("%Y-%m-%d") in personal_holidays:
						holidays_past_pr += 1
			# else:
				# if d 
					
	if next_holiday:
		holiday_diff = (next_holiday - today).days
		when_holiday_next = "In " + str(holiday_diff) + " day" + ("s" if holiday_diff != 1 else "")
		if holiday_diff == 1:
			when_holiday_next = "Tomorrow"
	else:
		next_holiday = "None"
		when_holiday_next = "None"
					
	if last_holiday:
		holiday_diff = (last_holiday - today).days
		when_holiday_last = str(abs(holiday_diff)) + " day" + ("s" if holiday_diff != 1 else "") + " ago"
		if abs(holiday_diff) == 1:
			when_holiday_last = "Yesterday"
	else:
		last_holiday = "None"
		when_holiday_last = "None"
		
		
	# print("days_worked: " + str(days_worked) + ", i: " + str(i) + ", idx: " + str(idx))
	# for d, holiday in zip(holidays_nums, holidays)
	days = ["week"] + ["sun"] + days + ["sat"]
	empty = dict(zip( days, ["---" for i in range(len(days))]))
	res.update({
		" ": empty,
		"Days Passed": day + 1,
		"Days Worked": days_worked,
		"Days Off": day + 1 - days_worked,
		"Public Holidays Taken": holidays_past_pu,
		"Personal Holidays Taken": holidays_past_pr,
		"Percentage Time Off": str((100 * (1 + day - days_worked) / max(1, day + 1))) + " %"
		# "Next Holiday": "In " + str(holiday_diff),
		})
	if when_holiday_next:
		res.update({"Next Holiday": when_holiday_next + ", " + str(next_holiday)})
	if when_holiday_last:
		res.update({"Last Holiday": when_holiday_last + ", " + str(last_holiday)})
	res.update({"  ": empty})
	for month in months:
		if months[month]:
			months[month] = months[month][:-2]
		
	res.update(week_days)
	res.update({
		"   ": empty
	})
	res.update(months)
	return res

def day_string(holiday):
	wday = calendar.day_abbr[holiday.weekday()]
	day = str(holiday.day)
	if day in ["1", "21", "31"]:
		suffix = "st"
	elif day in ["2", "22"]:
		suffix = "nd"
	elif day in ["3", "23"]:
		suffix = "rd"
	else:
		suffix = "th"
	return wday + " " + day + suffix


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
		self.discount_pctg = 100 * abs(self.discount) / max(1, self.grossCDN)
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
			"discounts": money(self.discount),
			"discount %": ("%.3f" % self.discount_pctg) + " %"
		}
		
	def __repr__(self):
		return "Quote #%s" % self.number


WRITING = input("To write results to \"output.txt\", type \"1\".\n\tHit enter to proceed.\n") == "1"
print("Re-writing \"output.txt\"..." if WRITING else "Results:")
to_view = {}

with open(data_file, 'r') as data, open(out_file, 'w' if WRITING else 'r') as out:

	def write(content):
		if WRITING:
			out.write(content + "\n")
	
	data_dict = csv.DictReader(data, delimiter=',')
	fieldnames = data_dict.fieldnames
	# data_dict = {line[fieldnames[0]]: line for line in data_dict}
	quotes = [Quote(*line.values()) for line in data_dict]
	
	to_view["keys"] = str(fieldnames)
	to_view["quotes"] = str(quotes)
	to_view["Quote History"] = dict_print(dict(zip([qNo.number for qNo in quotes], [qNo.info_dict() for qNo in quotes])), "Quote history", number=True)

		
			
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
		weeks = {c: p for c, p in weekly.items()}
		weeks.update({
			"Average # quotes per week:": "%.3f" % (sum([int(str(k).strip()) for k in weekly.keys()]) / length),
			"Average quote price per week": money(sum([money_value(wv) for wv in weekly.values()]) / length)
		})
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
			
			# content = "Quote #{n}, Model: {m}".format(n=dat[qNo].number, m=dat[qNo].model)
			content = {"Quote": dat[qNo].number, "Model": dat[qNo].model}
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
			
			# content = "Quote #{n}, Model: {m}".format(n=dat[qNo].number, m=dat[qNo].model)
			content = {"Quote": dat[qNo].number, "Model": dat[qNo].model}
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
		
	def unfinished_quotes(dat):
		res = {}
		# return dict(zip([qNo.number for qNo in quotes], [qNo.info_dict() for qNo in quotes]))
		for q in dat:
			if q.cost == 0:
				res[q] = q.info_dict()
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
	
		
	to_view.update({
		"Model Counts:": (model_counts, {"number": True}),
		"Weekly Counts:": (weekly_counts, {"number": True}),
		"Dealer Counts:": (dealer_counts, {"number": True}),
		"Dealer Costs:": (dealer_costs, {"number": True}),
		"Top 10 Dealers:": (top_5_dealers, {"num": 10}, {"number": True}),
		"Bottom 10 Dealers:": (bottom_5_dealers, {"num": 10}, {"number": True}),
		"Top 10 Models:": (top_5_models, {"num": 10}, {"number": True}),
		"Bottom 10 Models:": (bottom_5_models, {"num": 10}, {"number": True}),
		"Top 10 Bases:": (rank_money, {"category": "baseCDN", "num": 10}, {"number": True}),
		"Bottom 10 Bases:": (rank_money, {"category": "baseCDN", "bottom": True, "num": 10}, {"number": True}),
		"Top 10 Gross:": (rank_money, {"category": "grossCDN", "num": 10}, {"number": True}),
		"Bottom 10 Gross:": (rank_money, {"category": "grossCDN", "bottom": True, "num": 10}, {"number": True}),
		"Top 10 Discounts:": (rank_money, {"category": "discount", "bottom": True, "num": 10}, {"number": True}),
		"Bottom 10 Discounts:": (rank_money, {"category": "discount", "num": 10}, {"number": True}),
		"Top 10 Costs:": (rank_money, {"category": "costCDN", "num": 10}, {"number": True}),
		"Bottom 10 Costs:": (rank_money, {"category": "costCDN", "bottom": True, "num": 10}, {"number": True}),
		"Top 10 Customized:": (top_5_customized, {"num": 10}, {"number": True}),
		"Bottom 10 Customized:": (bottom_5_customized, {"num": 10}, {"number": True}),
		"Weekly Reporting": (avg_weekly_reporting, {"number": True}),
		"Dealer Reporting": (avg_dealer_reporting, {"number": True}),
		"Statistical Reporting": (lambda x: statistical_reporting, {}),
		"Range of Quotes": (sequential_quotes, {"l": 1, "sep": 1, "number": True}),
		"Unfinished": (unfinished_quotes, {"number": True})
	})
	
	results = {}
	for title, dat in to_view.items():
		if dat and type(dat) == str:
			results[title] = dat
		elif len(dat) == 3:
			func, fargs, pargs = dat
			results[title] = dict_print(func(quotes, **fargs), title, **pargs)
			# print("results: " + str(results))
		else:
			func, args = dat
			results[title] = dict_print(func(quotes), title, **args)
			# print("results: " + str(results))
		
	sizes = [text_size(res) for title, res in results.items()]
	contents_list = {}
	line_num = len(results) + 5
	for i, title in enumerate(results):
		contents_list[line_num] = title
		line_num += sizes[i][0]

	# print(dict_print(results, "results"))
	write(dict_print(contents_list, "contents_list"))
	for title, res in results.items():
		print(res)
		write(res)
			
	
	print(dict_print(to_view, "to view", number=True))
	

	# a = [work_weeks(i, [43, 8,9,10,11,12,13,14,15,16,17]) for i in range(1, 45)]
	# a = work_weeks(45, [43, 8,9,10,11,12,13,14,15,16,17])
	day_one = datetime.date.fromisoformat("2021-01-04")
	public_holidays = [
		"2021-02-15",
		"2021-04-02",
		"2021-05-24",
		"2021-07-01",
		"2021-08-02",
		"2021-09-06",
		"2021-10-11",
		"2021-11-11",
		"2021-12-24",
		"2021-12-27",
		
		"2022-01-03",
		"2022-02-21",
		"2022-04-15",
		"2022-05-23",
		"2022-07-01",
		"2022-08-01",
		"2022-09-05",
		"2022-10-10",
		"2022-11-11",
		"2022-12-26",
		"2022-12-27",
		
		"2023-02-24",
		"2023-04-07",
		"2023-05-22",
		"2023-07-03",
		"2023-08-07",
		"2023-10-09",
		"2023-11-10",
		"2023-12-25",
		"2023-12-26",
		
		"2024-01-01"
	]
	personal_holidays = [
		
		"2021-07-02",
		"2021-08-03",
		"2021-08-04",
		"2021-08-05",
		"2021-08-06",
		"2021-10-29",
		"2021-12-23",
		"2021-12-28",
		"2021-12-29"
		
		,"2022-02-04"
		,"2022-05-09"
		,"2022-06-24"
		,"2022-06-27"
		,"2022-08-02"
		,"2022-08-03"
		,"2022-08-04"
		,"2022-08-15"
		,"2022-08-05"
		,"2022-10-13"
		,"2022-10-14"
		,"2022-12-28"
		,"2022-12-29"
		,"2022-12-30"
		
		,"2023-01-02"
		,"2023-01-03"
		,"2023-01-04"
		,"2023-01-05"
		,"2023-01-06"
		
		# Summer shut-down 2023
		, "2023-06-23"
		, "2023-06-26"
		, "2023-07-07"
		, "2023-07-10"
	]
	sick_days = [
		"2023-05-23"
	]
	
	holidays = public_holidays + personal_holidays + sick_days
	holidays.sort()
	# print(f"{holidays=}")
	a = work_weeks(day_one, public_holidays, personal_holidays, sick_days)
	# a = [work_weeks(i, [43]) for i in range(1, 45)]
	# b = "\n".join([str(i+1) + " - " + str(v) for i, v in enumerate(a)])
	print(dict_print(a, "work weeks", number=True, table_title="Weeks"))  #, sort_header=True
	write(dict_print(a, "work weeks", number=True, table_title="Weeks"))


	import numpy as np
	# import pandas as pd
	x = '''
		import seaborn as sns
		import pandas as pd
		import numpy as np; np.random.seed(8)
		mean, cov = [4, 6], [(1.5, .7), (.7, 1)]
		x, y = np.random.multivariate_normal(mean, cov, 80).T
		ax = sns.regplot(x=x, y=y, color="g")
		x, y = pd.Series(x, name="x_var"), pd.Series(y, name="y_var")
		ax = sns.regplot(x=x, y=y, marker="+")
	'''
		
		
	x = '''
		import numpy as np; np.random.seed(8)
		mean, cov = [4, 6], [(1.5, .7), (.7, 1)]
		x, y = np.random.multivariate_normal(mean, cov, 80).T
		ax = sns.regplot(x=x, y=y, color="g")
	'''
		
		
	x = '''
		# data_reduced= pd.read_csv('fake.txt',sep='\s+')
		plotting = {"Weekly Counts:": (weekly_counts, {"number": True})}
		func, args = list(plotting.values())[0]
		# res = func(quotes)
		data_reduced = func(quotes)
		sns.regplot(data_reduced[0],data_reduced[len(data_reduced - 1)])
	'''








	plotting = {"Weekly Counts:": (weekly_counts, {"number": True})}
	func, args = list(plotting.values())[0]
	res = func(quotes)
	x = '''
		# results[title] = dict_print(func(quotes), title, **args)
		print("func(quotes, **fargs):", func(quotes))
		print(dict_print(func(quotes), "TESTING", **args))
		# results[title] = dict_print(func(quotes, **fargs), title, **pargs)
		#Create a variable numbers_a and set it equal to the range of numbers 1 through 12 (inclusive).
		numbers_a = range(1,13)

		#Create a variable numbers_b and set it equal to a random sample of twelve numbers within range(1000).
		numbers_b = [random.randint(0,1001) for i in range(12)]
	'''
	x = '''
		#Now lets plot these number sets against each other using plt. Call plt.plot() with your two variables as its arguments.
		plt.scatter(numbers_a, numbers_b, label="Quotes per Week")

		#Now call plt.show() and run your code!
		#You should see a graph of random numbers displayed. Youve used two Python modules to accomplish this (random and matplotlib).
		plt.show()
	'''

	x = [[x + 1] for x in range(len(res))]
	y = list(map(lambda x: int(str(x).strip()), res.keys()))
	N = len(x)
	# print("x:", len(x), "x:", x)
	# print("y:", len(y), "y:", y)
	# print("N:", N)
	# print("np.ones((N,1)):", np.ones(N))

	plt.axhline(0, color='r', zorder=-1)
	plt.axvline(0, color='r', zorder=-1)
	plt.title("# Quotes per Week")
	plt.xlabel("Week")
	plt.ylabel("# Quotes")
	plt.grid(color = 'grey', linestyle = '--', linewidth = 0.5)
	plt.scatter(x, y, label="Quotes per Week")

	# fit least-squares with an intercept
	w = np.linalg.lstsq(np.hstack((x, np.ones((N,1)))), y, rcond=None)[0]
	xx = np.linspace(*plt.gca().get_xlim()).T

	# plot best-fit line
	plt.plot(xx, w[0]*xx + w[1], '-k')
	#plt.show()
	
'''
# Viewing change in time off ratio starting 2021-05-28 to 200 days into the future.
# Starting with 102 worked days, how does the ratio change as less time off is taken.

l = list(range(146, 201))
l1 = l[:7]
mods = dict(zip(list(map(lambda x: x % 7, l1)), ["fri", "sat", "sun", "mon", "tue", "wed", "thu"]))
w_mods = [147 % 7, 148 % 7]
g = lambda wd, lst: [] if not lst else [(mods[lst[0] % 7], wd, lst[0], 100 * (1 - (wd / lst[0])))] + g(wd if not lst[1:] or lst[1] % 7 in w_mods else wd + 1, lst[1:])
print("\n".join(list(map(str, g(102, l)))))
'''