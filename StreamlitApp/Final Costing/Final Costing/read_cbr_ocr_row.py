import re


known_cols: list[str] = [
	"Qty Ord.",
	"Qty Ship.",
	"Qty B.O.",
	"Piece No.",
	"Unit Price",
	"Total Price"
]
int_cols = {"lst": known_cols[:3], "func": lambda v: try_cast(v, "int")}
str_cols = {"lst": known_cols[3:4], "func": lambda v: try_cast(v, "str")}
dbl_cols = {"lst": known_cols[-2:], "func": lambda v: try_cast(v, "float")}


def combine_num_parts(num_txt):
    snt_splt = num_txt.split(" ")
    t_price_a = ""
    t_price_b = snt_splt[-1]
    # print(f"{txt=}, {snt_splt=}")
    if snt_splt[-2].isnumeric() and ("." not in snt_splt[-2]):
        t_price_a = snt_splt[-2]
    t_price = f"{t_price_a}{t_price_b}"
    # print(f"    {t_price=}")
    return t_price


def frame(txt):
    pat_1_digit = r"\d+\s"
    prefixed_digits = {}
    count_start_digits = 0
    count_tries = 0
    txt_w = txt
    m_start_digit = re.match(pat_1_digit, txt_w)
    while m_start_digit:
        txt_match = m_start_digit.group().strip()
        if txt_match:
            count_start_digits += 1
            prefixed_digits[count_tries] = txt_match
        count_tries += 1
        txt_w = txt_w[m_start_digit.end():]
        m_start_digit = re.match(pat_1_digit, txt_w)
        if count_tries > 10:
            break
		
    txt = txt_w
    print(f"{txt=}")
    t_price, u_price = "", ""
    pat_currencies = r"(\d+(?:[.,\s]\d+)+)\s"
    m_trailing_currencies = re.match(pat_currencies, txt[::-1])
    if m_trailing_currencies:
        trailing_currencies = m_trailing_currencies.group()[::-1].strip()
        trailing_currencies_ns = trailing_currencies.replace(" ", "").strip()
        trailing_currencies_0 = combine_num_parts(trailing_currencies)
        trailing_currencies_0_ns = trailing_currencies_0.replace(" ", "").strip()
        t_price = trailing_currencies_0
        if len(trailing_currencies_ns) != len(trailing_currencies_0_ns):
            space_idxs = [i for i, c in enumerate(txt) if c == " "]
            trailing_currencies_1_ns = txt.replace(" ", "").strip().removesuffix(trailing_currencies_0_ns)
            trailing_currencies_1 = ""
            for i, c in enumerate(trailing_currencies_1_ns):
                if space_idxs and (i == space_idxs[0]):
                    trailing_currencies_1 += " "
                trailing_currencies_1 += c
        
            u_price = combine_num_parts(trailing_currencies_1)

    txt_w = txt_w.replace(" ", "").strip().removesuffix(f"{u_price}{t_price}".replace(" ", "").strip())
    # txt_ns = txt.replace(" ", "").strip()
    # rest = txt_ns[:m_trailing_currencies.start() if m_trailing_currencies else len(txt_ns)]
    idx = m_trailing_currencies.end() if m_trailing_currencies else len(txt_w)
    part = txt_w[:idx].strip()
    print(f"{idx=}, {txt_w=}")

    prefixed_digits.setdefault(2, 0)
    prefixed_digits.setdefault(1, 0)
    prefixed_digits.setdefault(0, 0)
	
    row_vals = list(map(str, prefixed_digits.values())) + [part, u_price, t_price]
    row_vals = ", ".join(row_vals)

    return row_vals


if __name__ == "__main__":

	splt_vals_i = "4 40939813-L 910.00 3 640.0"
	splt_vals_j = "4 4 40939813-L 910.00 3 640.0"
	splt_vals_k = "4 4 40939813-L 910.00 640"

	for i, txt in enumerate([
		splt_vals_i,
		splt_vals_j,
		splt_vals_k,
	]):
		print(frame(txt))
