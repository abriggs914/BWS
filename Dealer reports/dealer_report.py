import re
import datetime as dt
from test_suite import *

file_name = "C:/Users/ABriggs/Documents/BWS/Dealer reports/Dealer Status Review.txt"
file_name = "C:/Users/ABriggs/Documents/BWS/Dealer reports/demo_1.txt"

HOLIDAYS_2021 = list(map(lambda x : dt.datetime.strptime(x, "%Y-%m-%d"), [
		"2021-02-15",
		"2021-01-01",
		"2021-04-02",
		"2021-05-24",
		"2021-07-01",
		"2021-07-02",
		"2021-08-02",
		"2021-08-03",
		"2021-08-04",
		"2021-08-05",
		"2021-08-06",
		"2021-09-06",
		"2021-10-11",
		"2021-11-11",
		"2021-12-24",
		"2021-12-27",
		"2021-12-28",
		"2021-12-29",
		"2021-12-30",
		"2021-12-31"
	]))

class Order:
	def __init__(self, line):
		# spl = line.split()
		# print("(" + str(len(line)) + ")" + str(line))

		char_table = []
		for page in data:
			for dat in page:
				char_table.append(list(dat))

		vertical_dividers = []
		for row in char_table:
			for i, let in enumerate(row):
				if let == " ":
					keep = True
					for j in range(len(char_table)):
						if i < len(char_table[j]) and char_table[j][i] != " ":
							keep = False
							break
					if keep and i not in vertical_dividers:
						vertical_dividers.append(i)

		vertical_dividers = list(vertical_dividers)
		vertical_dividers.sort()
		i = 0
		grouped_dividers = []
		lvd = len(vertical_dividers)
		while i < lvd:
			j = i + 1
			while j < (lvd - 1) and vertical_dividers[i] == vertical_dividers[j] - 1:
				j += 1
			if j < lvd:
				grouped_dividers.append(vertical_dividers[j])
			i = j
			i += 1
		grouped_dividers.append(len(line))

		items = []
		start = 0
		stop = 0
		i = 0
		while i < len(grouped_dividers):
			stop = grouped_dividers[i]
			s = "".join(line[start: stop]).strip()
			if s:
				items.append(s)
			start = grouped_dividers[i]
			if i + 1 < len(grouped_dividers):
				stop = grouped_dividers[i + 1]
			else:
				stop = len(line)
			i += 1

		if len(items) == 10:
			self.quote, self.WO, self.model_no, self.serial_number, self.order, self.production, self.MRP_finish, self.req_delivery_date, self.P, self.est_delivery = items
			self.available_date = None
			self.F = None
		if len(items) == 12:
			self.quote, self.WO, self.model_no, self.serial_number, self.order, self.production, self.MRP_finish, self.req_delivery_date, self.P, self.available_date, self.est_delivery, self.F = items

	def __repr__(self):
		return "{quote}, {WO}, {model_no}, {serial_number}, {order}, {production}, {MRP_finish}, {req_delivery_date}, {P}, {available_date}, {est_delivery}, {F}".format(
			quote=self.quote,
			WO=self.WO,
			model_no=self.model_no,
			serial_number=self.serial_number,
			order=self.order,
			production=self.production,
			MRP_finish=self.MRP_finish,
			req_delivery_date=self.req_delivery_date,
			P=self.P,
			available_date=self.available_date,
			est_delivery=self.est_delivery,
			F=self.F)


def minmax(a, b):
	if a <= b:
		return a, b
	return b, a


def add_business_days(d, bd, holidays=None):
	if holidays == None:
		holidays = []
	i = 0
	t = dt.datetime(d.year, d.month, d.day)
	# print("holidays: " + str(holidays))
	while i < bd:
		t = t + dt.timedelta(days=1)
		# print("t: " + str(t) + ", (t not in holidays): " + str(t not in holidays))
		if t.weekday() < 5 and t not in holidays:
			i += 1
	return t


def business_days_between(d1, d2, holidays=None):
	business_days = 0
	if holidays == None:
		holidays = []
	date_1 = d1 if type(d1) == dt.datetime else dt.datetime.strptime(d1, "%d-%b-%y")
	date_2 = d2 if type(d2) == dt.datetime else dt.datetime.strptime(d2, "%d-%b-%y")

	date_1, date_2 = minmax(date_1, date_2)

	diff = (date_2 - date_1).days
	temp = date_1
	for i in range(diff):
		temp = date_1 + dt.timedelta(days=i+1)
		if temp.weekday() < 5 and temp not in holidays: # Monday == 0, Sunday == 6 
			business_days += 1
	i = 0
	while temp.weekday() >= 5 or temp in holidays:
		temp = temp + dt.timedelta(days=1)
		if temp not in holidays:
			business_days += 1
			break
	# print("temp: {temp}\ndate_2: {date_2}\ntemp < date_2: {td2}".format(temp=temp, date_2=date_2, td2=(temp < date_2)))
	# print("business_days: " + str(business_days))
	return business_days


with open(file_name, 'r') as f:
	lines = f.readlines()
	
	i = 0
	pages = 0
	data = []
	while i < len(lines):
		line = lines[i]
		spl = line.split()
		if spl == ["Date", "Date", "Date"]:
			i += 1
			page_data = []
			while i < len(lines) and "Criteria: Dealer, PO Date, Date Completed, Shipped Date and Date" not in lines[i]:
				s = lines[i].strip()
				if s:
					page_data.append(s)
				i += 1
			pages += 1
			data.append(page_data)
		i += 1
			

	print("pages: " + str(pages))
	print("\n\n-----------\n\n")
	
	def create_orders():
		orders = []
		for page in data:
			for dat in page:
				orders.append(Order(dat))
				print(orders[-1])
		return orders

	def need_est_delivery_update(orders, lead_days=5, forward_review_threshold=5, backward_review_threshold=3):
		need_adjusting = []
		forward_review = []
		backward_review = []
		for order in orders:
			est = dt.datetime.strptime(order.est_delivery, "%d-%b-%y")
			mrp = dt.datetime.strptime(order.MRP_finish, "%d-%b-%y")
			avail = dt.datetime.strptime(order.available_date, "%d-%b-%y") if order.available_date != None else None
			print("\nest: {est}, mrp: {mrp}, avail: {avail}".format(est=est, mrp=mrp, avail=avail))
			if avail:
				new_date = add_business_days(avail, lead_days, HOLIDAYS_2021)
				date_diff = business_days_between(est, new_date, HOLIDAYS_2021)
				if new_date < est:
					# moving forward
					if date_diff >= forward_review_threshold: # comparing business days
						forward_review.append(order)
					if date_diff >= 10:
						need_adjusting.append((new_date, order))  # only update very far pushed forward orders

				elif new_date > est:
					# moving backward
					if date_diff >= backward_review_threshold: # comparing business days
						backward_review.append(order)
					if date_diff >= 3:
						need_adjusting.append((new_date, order))  # only update very far pushed backward orders
				else:
					# no change
					pass
			else:					
				new_date = add_business_days(mrp, lead_days, HOLIDAYS_2021)
				date_diff = business_days_between(est, new_date, HOLIDAYS_2021)
				if new_date < est:
					# moving forward
					if date_diff >= forward_review_threshold: # comparing business days
						forward_review.append(order)
					if date_diff >= 10:
						need_adjusting.append((new_date, order))  # only update very far pushed forward orders

				elif new_date > est:
					# moving backward
					if date_diff >= backward_review_threshold: # comparing business days
						backward_review.append(order)
					if date_diff >= 3:
						need_adjusting.append((new_date, order))  # only update very far pushed backward orders
				else:
					# no change
					pass
		return need_adjusting, forward_review, backward_review

	orders = create_orders()
	need_adjusted, forward_review, backward_review = need_est_delivery_update(orders)
	print("\n\tNeeds estimated delivery date updated:\n")
	for order in need_adjusted:
		print(order)
	print("\n\tReview forward moving units:\n")
	for order in forward_review:
		print(order)
	print("\n\tReview backward moving units:\n")
	for order in backward_review:
		print(order)



	def do_test():
			
		bd_test_set = {
			"test_1, 03-Jul-21 -> 21-Jun-21 - no holidays": [
				[
					dt.datetime.strptime("21-Jun-21", "%d-%b-%y"),
					dt.datetime.strptime("03-Jul-21", "%d-%b-%y")
				],
				10
			],
			"test_2, 21-Jun-21 -> 03-Jul-21 - no holidays": [
				[
					dt.datetime.strptime("03-Jul-21", "%d-%b-%y"),
					dt.datetime.strptime("21-Jun-21", "%d-%b-%y")
				],
				10
			],
			"test_3, 02-Aug-21 -> 28-Jul-21 - no holidays": [
				[
					dt.datetime.strptime("02-Aug-21", "%d-%b-%y"),
					dt.datetime.strptime("28-Jul-21", "%d-%b-%y")
				],
				3
			],
			"test_4, 02-Aug-21 -> 28-Jul-21": [
				[
					dt.datetime.strptime("02-Aug-21", "%d-%b-%y"),
					dt.datetime.strptime("28-Jul-21", "%d-%b-%y"),
					HOLIDAYS_2021
				],
				3
			],
			"test_5, 07-Jul-21 -> 25-Jun-21": [
				[
					dt.datetime.strptime("07-Jul-21", "%d-%b-%y"),
					dt.datetime.strptime("25-Jun-21", "%d-%b-%y"),
					HOLIDAYS_2021
				],
				6
			],
			"test_6, 07-Jul-21 -> 25-Jun-21 - no holidays": [
				[
					dt.datetime.strptime("07-Jul-21", "%d-%b-%y"),
					dt.datetime.strptime("25-Jun-21", "%d-%b-%y")
				],
				8
			]
		}

		add_business_days_test_set = {
			"test_1, 07-Jul-21 + 7 business days - no holidays": [
				[
					dt.datetime.strptime("07-Jul-21", "%d-%b-%y"),
					7
				],
				dt.datetime(2021, 7, 16)
			],
			"test_2, 27-Jun-21 + 7 business days - no holidays": [
				[
					dt.datetime.strptime("27-Jun-21", "%d-%b-%y"),
					7
				],
				dt.datetime(2021, 7, 6)
			],
			"test_3, 27-Jun-21 + 7 business days": [
				[
					dt.datetime.strptime("27-Jun-21", "%d-%b-%y"),
					7,
					HOLIDAYS_2021
				],
				dt.datetime(2021, 7, 8)
			]
		}
		tests_to_run = [
			(business_days_between, bd_test_set),
			(add_business_days, add_business_days_test_set)
		]
		run_multiple_tests(tests_to_run)

	# do_test()

