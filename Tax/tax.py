
from utility import dict_print
from sys import maxsize

# brackets = {
	# "first $43,835": (lambda x: x <= 43835, (0, 43835), (24.68, 12.34, (-5.99, 14.83))),
	# "over $43,835 up to $49,020": (lambda x: 43835 < x <= 49020, (43835, 49020), (29.82, 14.91, (1.1, 20.75))),
	# "over $49,020 up to $87,671": (lambda x: 49020 < x <= 87671, (49020, 87671), (35.32, 17.66, (8.69, 27.07))),
	# "over $87,671 up to $98,040": (lambda x: 87671 < x <= 98040, (87671, 98040), (37.02, 18.51, (11.04, 29.03))),
	# "over $98,040 up to $142,534": (lambda x: 98040 < x <= 142534, (98040, 142534), (42.52, 21.26, (18.63, 35.35))),
	# "over $142,534 up to $151,978": (lambda x: 142534 < x <= 151978, (142534, 151978), (43.84, 21.92, (20.45, 36.87))),
	# "over $151,978 up to $162,383": (lambda x: 151978 < x <= 162383, (151978, 162383), (47.16, 23.58, (25.03, 40.69))),
	# "over $162,383 up to $216,511": (lambda x: 162383 < x <= 216511, (162383, 216511), (49.62, 24.81, (28.43, 43.52))),
	# "over $216,511": (lambda x: 216511 < x, (216511, maxsize), (53.3, 26.65, (33.51, 47.75))),
# }

brackets = {
	"first $43,401": (lambda x: x <= 43401, (0, 43401), (9.68, 0, (0, 0))),
	"over $43,401 up to $86,803": (lambda x: 43401 < x <= 86803, (43401, 86803), (14.82, 0, (0, 0))),
	"over $86,803 up to $141,122": (lambda x: 86803 < x <= 141122, (86803, 141122), (16.52, 0, (0, 0))),
	"over $141,122 up to $160,776": (lambda x: 141122 < x <= 160776, (141122, 160776), (17.84, 0, (0, 0))),
	"over $160776": (lambda x: 160776 > x, (160776, maxsize), (20.3, 0, (0, 0)))
}


def calc_taxes(vals):
	print("vals 1:", vals)
	s = vals["salary"]
	m = s
	t = 0
	for bracket, bracket_vals in brackets.items():
		func, r, b_vals = bracket_vals
		low, high = r
		print("\nbracket:", bracket, "(low, high):", ("(" + str(low) + ", " + str(high) + ")"), "m:", m)
		if m <= 0:
			break
		else:
			p = b_vals[0] / 100
			print("b_vals[0]:",b_vals[0],"m:",m,"p:",p,"range?", (m in range(low, high)),"res", (m * p if ((m in range(low, high)) or (m >= high)) else high))
			vals[bracket] = min(m, high) * p
			if (m + t) in range(low, high):
				vals["paid taxes"] += m * p  # vals[bracket]
				vals["marginal bracket"] = bracket
			else:
				t += high
				# vals[bracket] = high
				vals["paid taxes"] += m * p  # vals[bracket]
			m -= high
	vals["earnings"] = vals["salary"] - vals["paid taxes"]
	vals["% Taxes"] = (1 - (vals["earnings"] / vals["salary"])) * 100
	print("vals 2:", vals)


if __name__ == "__main__":
	values_40000 = {
		"salary": 40000,
		"paid taxes": 0,
		"earnings": 0
	}
	values_50000 = {
		"salary": 50000,
		"paid taxes": 0,
		"earnings": 0
	}
	values_86000 = {
		"salary": 86000,
		"paid taxes": 0,
		"earnings": 0
	}
	values_365000 = {
		"salary": 365000,
		"paid taxes": 0,
		"earnings": 0
	}

	calc_taxes(values_40000)
	print(dict_print(values_40000, "Values"))

	calc_taxes(values_50000)
	print(dict_print(values_50000, "Values"))

	calc_taxes(values_86000)
	print(dict_print(values_86000, "Values"))

	calc_taxes(values_365000)
	print(dict_print(values_365000, "Values"))
