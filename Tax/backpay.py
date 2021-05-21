import datetime as dt
from utility import *

OG_TAX = 0.78299
tax = 1

rate_1 = tax * 40000 / 52
rate_2 = tax * 42000 / 52
rate_d = rate_2 - rate_1

start = dt.datetime(2021, 4, 5)
end = dt.datetime(2021, 5, 20)
week_diff = end.isocalendar().week - start.isocalendar().week - 1

back_pay = rate_d * week_diff
back_payT = OG_TAX * back_pay

print(dict_print({
	"original tax": OG_TAX,
	"tax rate": tax,
	"rate_1": rate_1,
	"rate_2": rate_2,
	"rate_d": rate_d,
	"start": start,
	"end": end,
	"week_diff": week_diff,
	"back_pay": money(back_pay),
	"back_payT": money(back_payT)
}, "Backpay"))
