import csv
from utility import *

with open("sample.csv", "r") as f:
	total_time = dt.timedelta(seconds=0)
	dicts = csv.DictReader(f)
	for d in dicts:
		# print("d:", d)
		log_on = dt.datetime.strptime(d["InTimeFromShopClk"], "%Y-%m-%d %H:%M")
		log_off = dt.datetime.strptime(d["OutTimeFromShopClk"], "%Y-%m-%d %H:%M")
		print("log_off - log_on:", log_off - log_on)
		total_time += log_off - log_on
	print(dict_print(dicts))
	
	print("total_time:", total_time)
	