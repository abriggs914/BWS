from utility import *

lst_syspro_data = [
    (3, 2.68),
    (4, 6.78),
    (4, 1.35),
    (4, 0.38),
    (4, 9.62),
    (4, 10.32),
    (4, 9.53),
    (4, 3.52),
    (4, -3.52),
    (4, 9.5),
    (4, 2.42),
    (4, 3.4)
]

lst_shopclock_data = [
    {
        "name": "PRIOR, BLAIRE",
        "work_centre": "TRAILER ASSEMBLY",
        "logged_on": datetime.datetime(2022, 10, 3, 9, 14),
        "logged_off": datetime.datetime(2022, 10, 3, 16, 1),
        "image": r"\\nas1\Public\IT\Requests\REQID#001247\Screenshot 2022-10-07 101627.png"
    },
    {
        "name": "LEVESQUE, ANDREW",
        "work_centre": "TRAILER ASSEMBLY",
        "logged_on": datetime.datetime(2022, 10, 3, 15, 9),
        "logged_off": datetime.datetime(2022, 10, 3, 16, 30),
        "image": r"\\nas1\Public\IT\Requests\REQID#001247\Screenshot 2022-10-07 102203.png"
    },

    {
        "name": "PRIOR, BLAIRE",
        "work_centre": "TRAILER ASSEMBLY",
        "logged_on": datetime.datetime(2022, 10, 4, 6, 53),
        "logged_off": datetime.datetime(2022, 10, 4, 16, 30),
        "image": r"\\nas1\Public\IT\Requests\REQID#001247\Screenshot 2022-10-07 102327.png"
    },
    {
        "name": "LEVESQUE, ANDREW",
        "work_centre": "TRAILER ASSEMBLY",
        "logged_on": datetime.datetime(2022, 10, 4, 6, 56),
        "logged_off": datetime.datetime(2022, 10, 4, 7, 19),
        "image": r"\\nas1\Public\IT\Requests\REQID#001247\Screenshot 2022-10-07 102622.png"
    },
    {
        "name": "MASKELL, LOGAN",
        "work_centre": "TRAILER ASSEMBLY",
        "logged_on": datetime.datetime(2022, 10, 4, 6, 12),
        "logged_off": datetime.datetime(2022, 10, 4, 16, 31),
        "image": r"\\nas1\Public\IT\Requests\REQID#001247\Screenshot 2022-10-07 103629.png"
    },

    {
        "name": "PRIOR, BLAIRE",
        "work_centre": "TRAILER ASSEMBLY",
        "logged_on": datetime.datetime(2022, 10, 5, 6, 58),
        "logged_off": datetime.datetime(2022, 10, 5, 16, 30),
        "image": r"\\nas1\Public\IT\Requests\REQID#001247\Screenshot 2022-10-07 102754.png"
    },
    {
        "name": "MASKELL, LOGAN",
        "work_centre": "TRAILER ASSEMBLY",
        "logged_on": datetime.datetime(2022, 10, 5, 7, 0),
        "logged_off": datetime.datetime(2022, 10, 5, 16, 30),
        "image": r"\\nas1\Public\IT\Requests\REQID#001247\Screenshot 2022-10-07 102913.png"
    },

    {
        "name": "MASKELL, LOGAN",
        "work_centre": "TRAILER ASSEMBLY",
        "logged_on": datetime.datetime(2022, 10, 6, 5, 53),
        "logged_off": datetime.datetime(2022, 10, 6, 9, 17),
        "image": r"\\nas1\Public\IT\Requests\REQID#001247\Screenshot 2022-10-07 103316.png"
    },
    {
        "name": "PRIOR, BLAIRE",
        "work_centre": "TRAILER ASSEMBLY",
        "logged_on": datetime.datetime(2022, 10, 6, 6, 52),
        "logged_off": datetime.datetime(2022, 10, 6, 9, 17),
        "image": r"\\nas1\Public\IT\Requests\REQID#001247\Screenshot 2022-10-07 103004.png"
    }
]


def sum_op(op):
    return sum([v[1] for v in lst_syspro_data if v[0] == op])


if __name__ == '__main__':
    print(f"{sum_op(3)=}")
    print(f"{sum_op(4)=}")

    employees = {}
    days = {}
    # emp_keys = {"idxs", "ttl_hours", "by_day"}
    # by_day_keys = {"day", "idxs", "ttl_hours"}

    ttl_hours = 0

    for i, data in enumerate(lst_shopclock_data):
        name = data.get("name", None)
        work_centre = data.get("work_centre", None)
        logged_on = data.get("logged_on", None)
        logged_off = data.get("logged_off", None)
        image = data.get("image", None)
        dk = logged_on.strftime("%Y-%m-%d")
        if name not in employees:
            employees[name] = {}
            employees[name]["idxs"] = []
            employees[name]["ttl_hours"] = 0
            # employees[name]["by_day"] = dict(zip(by_day_keys, [None for _ in by_day_keys]))
        if dk not in days:
            days[dk] = {}
            days[dk]["idxs"] = set()
            days[dk]["ttl_hours"] = 0

        employees[name]["idxs"].append(i)
        hours = (logged_off - logged_on).seconds / 3600
        employees[name]["ttl_hours"] += hours
        ttl_hours += hours

        days[dk]["ttl_hours"] += hours
        days[dk]["idxs"].add(i)

    print(dict_print(days, "Days"))
    print(dict_print(employees, "Employees"))
    print(f"{ttl_hours = }")

