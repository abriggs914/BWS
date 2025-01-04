import re


def convert_phone_number(phone: str) -> str:
    og_phone: str = phone
    pn: str = og_phone
    try:

        for i, c in enumerate(["-", "(", ")", "+"]):
            pn = pn.replace(c, "")
        pn = pn.strip()

        ifd: int = -1
        if m := re.search(r"\d", pn):
            ifd = m.start()

        area_code_pattern: str = r"\(\d{3}\).+"
        area_code_search: re.Match = re.search(area_code_pattern, og_phone)
        area_code_size: int = 5
        area_code_parse: str = ""
        area_code_idx: int = -1
        country_code_parse: str = ""
        country_code_idx: int = -1
        if not area_code_search:
            area_code_pattern = r"[\d{3}]\s[\d{3}]"
            area_code_size = 3
            area_code_search = re.search(area_code_pattern, og_phone)

        if area_code_search:
            area_code_parse = area_code_search.group()[:area_code_size]
            area_code_idx = area_code_search.start()

            country_search_str: str = og_phone[:area_code_idx].rstrip()[::-1]
            country_code_search: re.Match = re.search(r"\d", country_search_str)
            if country_code_search:
                country_code_parse = country_code_search.group()
                country_code_idx = country_code_search.start()

        area_code_parse = area_code_parse.removeprefix("(").removesuffix(")")

        t_phone: str = ""
        allowed_spaces: int = 2
        for i, c in enumerate(pn[ifd:]):
            if c.isdigit():
                t_phone += c
            elif c == " ":
                # else:
                allowed_spaces -= 1
                if allowed_spaces < 0:
                    break
        pn = t_phone
        lsp: int = len(pn)

        if lsp < 7:
            return f"D {pn} == Too few digits"
        elif lsp > 11:
            return f"D {pn} == Too many digits"
        elif 7 < lsp < 10:
            return f"D {pn} == Odd digits"

        p1: str = r'[\d]{11}'  # with area code and country code
        p2: str = r'[\d]{10}'  # just area code
        p3: str = r'[\d]{7}'  # just phone number

        if area_code_parse:
            # at least 10 digits given
            if country_code_parse:
                s_idx: int = area_code_idx + len(country_code_parse) + len(area_code_parse)
                return f"F1 <{pn}> {country_code_parse} ({area_code_parse}) {pn[s_idx + 1: s_idx + 4]}-{pn[s_idx + 4: s_idx:8]}{pn[s_idx + 8:]}"
            else:
                s_idx: int = area_code_idx + len(area_code_parse)
                return f"F2 <{pn}> ({area_code_parse}) {pn[s_idx + 1: s_idx + 4]}-{pn[s_idx + 4: s_idx:8]}{pn[s_idx + 8:]}"

        if re.search(p1, pn):
            return f"A <{pn}> {pn[0]} ({pn[1:4]}) {pn[4:7]}-{pn[7:11]}{pn[11:]}"
            # return f"A {s_phone}"
        elif re.search(p2, pn):
            return f"B <{pn}> ({pn[:3]}) {pn[3:6]}-{pn[6:10]}{pn[10:]}"
            # return f"B {s_phone}"
        elif re.search(p3, pn):
            return f"C <{pn}> {pn[:3]}-{pn[3:8]}{pn[8:]}"
            # return f"C {s_phone}"
        else:
            return f"E {pn}"
        # return re.sub(r'(\d{7}\d)', r'(\1)', phone)
    except:
        return ""


if __name__ == '__main__':
    lst_7 = [
        "1234567"
    ]
    lst_10 = [
        "5061234567"
    ]
    lst_11 = [
        "15061234567"
    ]
    l_extras = [
        "1 pineapple, 5 oranges, 0 apples, 6 pears, 3 lemons, 2 mangoes, 3 grapes, 8 bananas, 4 limes, 7 strawberries, 2 melons.",
        "239 Moose Mountain Road, e7j-1r4"
    ]

    lsts = []
    for i, lst in enumerate([lst_7, lst_10, lst_11]):
        to_add = []
        for j, pn in enumerate(lst):
            to_add.extend([
                f"{i=}, {j=}",
                pn,
                f"  {pn}  ",  # leading and trailing spaces
                f"+{pn}  ",  # leading plus
                f"this is my phone number: {pn}  ",  # leading text 1
                f"this is my phone number;{pn}  ",  # leading text 2
                f"{pn}, my number.",  # trailing spaces
                f"{pn}, call me",  # trailing spaces
                f"+1({pn[:3]}){pn[3:6]}-{pn[6:10]}{pn[10:]}",
                f"({pn[:3]})-{pn[3:6]}-{pn[6:10]}{pn[10:]}"
            ])
        lsts.extend(to_add)

    lsts += l_extras

    for i, pn in enumerate(lsts):
        print(f"{i=}, {pn=}, parsed='{convert_phone_number(pn)}'")
