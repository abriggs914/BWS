import datetime

import holidays


# can_holidays = holidays.Canada()


def new_inserts():
    start = datetime.datetime(2017, 1, 1)
    end = datetime.datetime(2025, 12, 31)
    dates = [(start + datetime.timedelta(days=i)).date() for i in range((end - start).days)]

    holidays_list = {}
    # Print all the holidays in UnitedKingdom in year 2018
    for ptr in holidays.Canada(years=list(range(2017, 2026))).items():
        date, holiday_name = ptr
        holidays_list.update({date: holiday_name.replace("'", "''")})

    top_template = f"INSERT INTO [Calendar] ([Date], [Day], [DayOfWeek], [SAT Holiday], [STAT Holiday], " \
                   f"[HolidayName]) VALUES"
    i_template = "('{date}', '{day}', {dow}, {sat_h}, {stat_h}, {hn})"
    i_templates_list = []

    print(f"{holidays_list=}")
    print(f"{dates=}")

    for date in dates:
        hn = "NULL"
        dow = date.isoweekday()
        sat_h = 1 if (dow > 5) else 0
        stat_h = 0
        if date in holidays_list:
            hn = f"'{holidays_list[date]}'"
            stat_h = 1

        i_templates_list.append(
            i_template.format(date=date, day=date.strftime("%A"), dow=dow, sat_h=sat_h, stat_h=stat_h, hn=hn))

    for i in range(0, len(i_templates_list), 1000):
        print(f"\n" + top_template)
        print(",\n".join(i_templates_list[i: i + 1000]))
        print(f";\n")


def old_updates():
    start = datetime.datetime(2011, 1, 1)
    end = datetime.datetime(2018, 1, 1)
    dates = [(start + datetime.timedelta(days=i)).date() for i in range((end - start).days)]

    holidays_list = {}
    # Print all the holidays in UnitedKingdom in year 2018
    for ptr in holidays.Canada(years=list(range(start.year, end.year + 1))).items():
        date, holiday_name = ptr
        holidays_list.update({date: holiday_name.replace("'", "''")})

    i_template = "UPDATE [Calendar] SET [HolidayName] = {hn} WHERE [Date] = '{date} 00:00:00.000';"
    i_templates_list = []

    print(f"{holidays_list=}")
    print(f"{dates=}")

    for date in dates:
        hn = "NULL"
        if date in holidays_list:
            hn = f"'{holidays_list[date]}'"

        i_templates_list.append(
            i_template.format(date=date, hn=hn))

    for i in range(0, len(i_templates_list), 1000):
        print("\n".join(i_templates_list[i: i + 1000]) + "\n")


def add_halloweens():
    start = 2011
    end = 2025
    i_templates_list = []
    for y in range(start, end + 1):
        i_templates_list.append("UPDATE [Calendar] SET [HolidayName] = 'Halloween' "
                                "WHERE [Date] = '{y}-10-31';".format(y=y))
    print("\n" + "\n".join(i_templates_list) + "\n")


if __name__ == '__main__':
    # new_inserts()
    # old_updates()
    add_halloweens()
