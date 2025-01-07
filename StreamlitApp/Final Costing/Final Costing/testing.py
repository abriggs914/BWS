import datetime
import os
import re




def convert_phone_number_old(phone: str) -> str:
    og_phone: str = phone
    pn: str = og_phone
    pn_result: str = ""
    try:

        pn = pn.replace("\n", " ")
        while "  " in pn:
            pn = pn.replace("  ", " ")

        for i, c in enumerate(["-", "(", ")"]):
            pn = pn.replace(c, "")
        pn = pn.strip()

        starts_with_plus: bool = pn.lstrip().startswith("+")
        pn = pn.replace("+", '').strip()

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

        p4: str = r"[\d]{3}-[\d{4}]"  # correct match, just phone number

        if area_code_parse:
            # at least 10 digits given
            if country_code_parse:
                p4 = r"\d \([\d]{3}\) [\d]{3}-[\d{4}]"
                s_idx: int = area_code_idx + len(country_code_parse) + len(area_code_parse)
                pn_result = f"F1 <{pn}> <{s_idx}> {country_code_parse} ({area_code_parse}) {pn[s_idx + 1: s_idx + 4]}-{pn[s_idx + 4: s_idx:8]}{pn[s_idx + 8:]}"
                # return f"F1 <{pn}> <{s_idx}> {country_code_parse} ({area_code_parse}) {pn[s_idx + 1: s_idx + 4]}-{pn[s_idx + 4: s_idx:8]}{pn[s_idx + 8:]}"
            else:
                s_idx: int = area_code_idx + len(area_code_parse)
                p4 = r"\([\d]{3}\) [\d]{3}-[\d{4}]"
                pn_result = f"F2 <{pn}> <{s_idx}> ({area_code_parse}) {pn[s_idx: s_idx + 3]}-{pn[s_idx + 3: s_idx + 7]}{pn[s_idx + 7:]}"
                # return f"F2 <{pn}> <{s_idx}> ({area_code_parse}) {pn[s_idx: s_idx + 3]}-{pn[s_idx + 3: s_idx + 7]}{pn[s_idx + 7:]}"

        if not pn_result:

            if re.search(p1, pn):
                p4 = r"\d \([\d]{3}\) [\d]{3}-[\d{4}]"
                pn_result = f"A <{pn}> {pn[0]} ({pn[1:4]}) {pn[4:7]}-{pn[7:11]}{pn[11:]}"
                # return f"A <{pn}> {pn[0]} ({pn[1:4]}) {pn[4:7]}-{pn[7:11]}{pn[11:]}"
                # return f"A {s_phone}"
            elif re.search(p2, pn):
                p4 = r"\([\d]{3}\) [\d]{3}-[\d{4}]"
                pn_result = f"B <{pn}> ({pn[:3]}) {pn[3:6]}-{pn[6:10]}{pn[10:]}"
                # return f"B <{pn}> ({pn[:3]}) {pn[3:6]}-{pn[6:10]}{pn[10:]}"
                # return f"B {s_phone}"
            elif re.search(p3, pn):
                pn_result = f"C <{pn}> {pn[:3]}-{pn[3:8]}{pn[8:]}"
                # return f"C <{pn}> {pn[:3]}-{pn[3:8]}{pn[8:]}"
                # return f"C {s_phone}"
            else:
                pn_result = f"E {pn}"
                # return f"E {pn}"
            # return re.sub(r'(\d{7}\d)', r'(\1)', phone)

        return pn_result
    except:
        return pn_result


def convert_phone_number(phone: str) -> str:
    """
    Valid param formats:

    "1234567"            # 7 digits, this is the minimum format
    "1234567890"         # 10 digits, includes area code
    "12345678901"        # 11 digits, includes country code and area code
    "+1 (234) 567 8901"  # 11 digits, includes country code and area code, with formatting
    "+1 (234) 567-8901"  # 11 digits, includes country code and area code, with formatting

    Valid return formats:

    +1 (234) 567-8901  # this format has 11 digits, a country-code, an area-code, 2 spaces, 1 left-bracket, 1 right-bracket, and 1 dash.
    (234) 567-8901     # this format has 10 digits, no country-code, an area-code, 1 space, 1 left-bracket, 1 right-bracket, and 1 dash.
    567-8901           # this format has 7 digits, no country-code, no area-code, no spaces, no brackets, and 1 dash, this is the minimum format.

    :param phone: a string containing a series of digits denoting a phone number. Accepts just the digits or a string with preceding or seseding text.
    :return: a string of the parsed phone number digits in the string, returning as many digits that can be identified in a single phone number.
    """
    og_phone: str = phone
    pn: str = og_phone
    pn_res: str = ""
    try:

        og_ifd: int = float("inf")
        og_ild: int = -1

        for i, c in enumerate(og_phone.replace("(", "", 1).replace(")", "", 1).replace("-", "", 1).replace(" ", "").strip()):
            if c.isdigit():
                if i < og_ifd:
                    og_ifd = i
                if i > og_ild:
                    og_ild = i

        pn = pn.replace("\n", " ")
        while "  " in pn:
            pn = pn.replace("  ", " ")

        for i, c in enumerate(["(", ")"]):
            pn = pn.replace(c, "")
        pn = pn.strip()

        idxs_dash = []
        swp: bool = pn.lstrip().startswith("+")  # starts with a '+'
        pn = pn.replace("-", '').strip()
        pn = pn.replace("+", '').strip()

        ifd: int = float("inf")
        ild: int = -1

        print(f"-A {pn=}")
        for i, c in enumerate(pn.replace(" ", "")):
            if c == "-":
                idxs_dash.append(i)
            if c.isdigit():
                if i < ifd:
                    ifd = i
                if i > ild:
                    ild = i

        # if m := re.search(r"\d", pn):
        #     ifd = m.start()
        # if m := re.search(r"\d", pn[::-1]):
        #     ild = m.start()

        area_code_pattern: str = r"\(\d{3}\).+"
        area_code_search: re.Match = re.search(area_code_pattern, og_phone)
        area_code_size: int = 5
        area_code_parse: str = ""
        area_code_idx: int = -1
        country_code_parse: str = ""
        country_code_idx: int = -1
        if not area_code_search:
            area_code_pattern = r"[\d{3}]\s[\d{3}]\D"  # 3 digits, then a space, then 3 more digits, followed by absolutely not a fourth digit.
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

        area_code_parse = area_code_parse  #.removeprefix("(").removesuffix(")")

        t_phone: str = ""
        allowed_spaces: int = 2
        print(f"-B {pn[ifd:]=}")
        for i, c in enumerate(pn.replace(" ", "")[ifd:]):
            if c.isdigit():
                t_phone += c
            elif c == " ":
                # else:
                allowed_spaces -= 1
                if allowed_spaces < 0:
                    break
        pn = t_phone
        lsp: int = len(pn)

        print(f"-C {pn=}")
        if lsp < 7:
            # return f"D {pn} == Too few digits"
            raise ValueError(f"D {pn} == Too few digits")
        elif lsp > 11:
            # return f"D {pn} == Too many digits"
            raise ValueError(f"D {pn} == Too many digits")
        elif 7 < lsp < 10:
            # return f"D {pn} == Odd digits"
            raise ValueError(f"D {pn} == Odd digits")

        p1: str = r'[\d]{11}'  # with area code and country code
        p2: str = r'[\d]{10}'  # just area code
        p3: str = r'[\d]{7}'  # just phone number

        # if swp and not country_code_parse:
        #     raise ValueError(f"E5 Invalid format, must include a country code for phone numbers that start with '+'. {pn=}")

        if area_code_parse:
            # at least 10 digits given
            area_code_idx -= ifd
            # s_og_phone = og_phone[ifd: ild].replace(" ", "")
            # b = s_og_phone.count("(", ifd, ild) + s_og_phone.count(")", ifd, ild)  # + og_phone.count("-", ifd, ifd + 3)
            cci = country_code_idx if country_code_idx >= 0 else 0
            b = int("(" in area_code_parse) + int(")" in area_code_parse) + og_phone.count(" ", cci + ifd, area_code_idx + ifd)
            # pn = pn.removeprefix("+")
            pn_o = pn
            if country_code_parse:
                # s_idx: int = area_code_idx + len(country_code_parse) + len(area_code_parse)
                # pn = pn[area_code_idx + len(area_code_parse) - (swp + b):]
                # pn = pn[len(pn)-(len(area_code_parse) - (swp + b)):]
                a = swp + b
                pn = pn[a:]
                if len(pn) != 7:
                    # return f"E3 Invalid format '{pn}'"
                    raise ValueError(f"E3 Invalid format '{pn}', {country_code_idx=}, {country_code_parse=}, {area_code_idx=}, {area_code_parse=}, {ifd=}, {pn_o=}, {a=}, {b=}, {swp=}")
                # return f"F1 <{pn}> <{s_idx}> {country_code_parse} ({area_code_parse}) {pn[s_idx + 1: s_idx + 4]}-{pn[s_idx + 4: s_idx:8]}{pn[s_idx + 8:]}"
                print(f"F1 <{pn}> {'+' if swp else ''}{country_code_parse} ({area_code_parse.removeprefix('(').removesuffix(')')}) {pn[:3]}-{pn[3: 7]}{pn[7:]}")
                # return f"{'+' if swp else ''}{country_code_parse} ({area_code_parse}) {pn[:3]}-{pn[3: 7]}{pn[7:]}"
                pn_res = f"{'+' if swp else ''}{country_code_parse} ({area_code_parse.removeprefix('(').removesuffix(')')}) {pn[:3]}-{pn[3: 7]}{pn[7:]}"
            else:
                if swp:
                    # return "E2 Invalid format: '+' can only be included in a phone number when the country code is also specified. (ex: '+1(123)......')"
                    raise ValueError("E2 Invalid format: '+' can only be included in a phone number when the country code is also specified. (ex: '+1(123)......')")
                # s_idx: int = area_code_idx + len(area_code_parse)
                # pn = pn[area_code_idx + len(area_code_parse) - (swp + b):]
                a = swp + b
                pn = pn[a:]
                # area_code_parse = area_code_parse.removeprefix("(").removesuffix(")")
                if len(pn) != 7:
                    # return f"E4 Invalid format '{pn}' <{area_code_idx}> {area_code_parse=}"
                    raise ValueError(f"E4 Invalid format '{pn=}' <{area_code_idx=}> {area_code_parse=}, {a=}, {b=}, {ifd=}, {pn_o=}, {swp=}")
                # return f"F2 <{pn}> <{s_idx}> ({area_code_parse}) {pn[s_idx: s_idx + 3]}-{pn[s_idx + 3: s_idx + 7]}{pn[s_idx + 7:]}"
                print(f"F2 <{pn}> ({area_code_parse.removeprefix('(').removesuffix(')')}) {pn[:3]}-{pn[3: 7]}{pn[7:]}")
                # return f"({area_code_parse}) {pn[:3]}-{pn[3: 7]}{pn[7:]}"
                pn_res = f"({area_code_parse.removeprefix('(').removesuffix(')')}) {pn[:3]}-{pn[3: 7]}{pn[7:]}"

        else:

            if re.search(p1, pn):
                print(f"A <{pn}> {'+' if swp else ''}{pn[0]} ({pn[1:4]}) {pn[4:7]}-{pn[7:11]}{pn[11:]}")
                # return f"{'+' if swp else ''}{pn[0]} ({pn[1:4]}) {pn[4:7]}-{pn[7:11]}{pn[11:]}"
                pn_res = f"{'+' if swp else ''}{pn[0]} ({pn[1:4]}) {pn[4:7]}-{pn[7:11]}{pn[11:]}"
                # return f"A {s_phone}"
            else:

                if swp and pn:
                    raise ValueError("E2 Invalid format: '+' can only be included in a phone number when the country code is also specified. (ex: '+1(123)......')")

                if re.search(p2, pn):
                    print(f"B <{pn}> ({pn[:3]}) {pn[3:6]}-{pn[6:10]}{pn[10:]}")
                    # return f"({pn[:3]}) {pn[3:6]}-{pn[6:10]}{pn[10:]}"
                    pn_res = f"({pn[:3]}) {pn[3:6]}-{pn[6:10]}{pn[10:]}"
                    # return f"B {s_phone}"
                elif re.search(p3, pn):
                    print(f"C <{pn}> {pn[:3]}-{pn[3:8]}{pn[8:]}")
                    # return f"{pn[:3]}-{pn[3:8]}{pn[8:]}"
                    pn_res = f"{pn[:3]}-{pn[3:8]}{pn[8:]}"
                    # return f"C {s_phone}"
                else:
                    print(f"E1 {pn}")
                    # return f"{pn}"
                    pn_res = f"{pn}"
            # return re.sub(r'(\d{7}\d)', r'(\1)', phone)
        print(f"{swp=}, {ifd=}, {ild=}, d={ild-ifd}, {og_ifd=}, {og_ild=}, d={og_ild-og_ifd}")
        if og_ild - og_ifd not in [6, 8, 9, 10]:
            raise ValueError(f"E6 Invalid format {pn=}, {pn_res=}")
        return pn_res
    except Exception as e:
        return f"{e}"
        # return pn_res


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
    "239 Moose Mountain Road, e7j-1r4",
    "506-1224=-718",
    "this is a number (221)6461154",
    "12345678901",
    "123456789012",
    "B12345678901A",
    "(645)(455)(4566)"
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


def write_test_file():
    n = datetime.datetime.now()
    date: str = "".join([f"{v}".rjust(2, "0") for v in [n.year, n.month, n.day, n.hour, n.minute, n.second]])
    with open(fr"testing_{date}.txt", "w") as f:
        for i, pn in enumerate(lsts):
            if re.search(r"i=\d, j=\d", pn):
                continue
            f.write(f"{pn}\n")


def run_print_tests():
    for i, pn in enumerate(lsts):
        print(f"{i=}, {pn=}, parsed='{convert_phone_number(pn)}'")


def run_file_tests():
    files: list[str] = os.listdir(".")
    files = [f for f in files if f.endswith(".txt") and f.startswith("testing")]
    if files:
        file = files[-1]
        file = r"testing.txt"
        tests = []
        with open(file, "r") as f:
            for i, line in enumerate(f.readlines()):
                spl = line.rsplit(",", 1)
                if spl:
                    text = spl[0]
                    if len(spl) > 1:
                        ans = spl[1].strip()
                    else:
                        ans = "None"
                    if ans.strip().lower() == "none":
                        ans = ""
                    tests.append({
                        "text": text,
                        "exp": ans,
                        "act": None,
                        "correct": False
                    })
        for i, t_data in enumerate(tests):
            text = t_data["text"]
            exp = t_data["exp"]
            act = convert_phone_number(text)
            correct = exp == act
            if (not correct) and (exp == "") and (act[0] in ["E", "D"]):
                correct = True
            t_data.update({
                "act": act,
                "correct": correct
            })
            print(f"{i=}, {text=}, {exp=}, {act=}, {correct=}'")

        print(f"\n\nIncorrect Tests:")

        incorrect = 0
        for i, t_data in enumerate(tests):
            text = t_data["text"]
            exp = t_data["exp"]
            act = t_data["act"]
            correct = t_data["correct"]
            if not correct:
                incorrect += 1
                print(f"{i=}, {text=}, {exp=}, {act=}, {correct=}'")

        if not incorrect:
            print(f"All tests passed!")


if __name__ == '__main__':
    # run_print_tests()
    # write_test_file()
    run_file_tests()
