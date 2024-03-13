import datetime

import holidays

from datetime_utility import first_of_month, first_of_week


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


def add_halloweens(start=2011, end=2025):
    i_templates_list = []
    for y in range(start, end + 1):
        i_templates_list.append("UPDATE [Calendar] SET [HolidayName] = 'Halloween' "
                                "WHERE [Date] = '{y}-10-31';".format(y=y))
    print("\n" + "\n".join(i_templates_list) + "\n")


def add_mothers_day(start=2011, end=2025):
    # second sunday in May, https://www.calendardate.com/mothers_day_2023.htm

    i_templates_list = []
    for y in range(start, end + 1):
        dm = first_of_month(datetime.datetime(y, 5, 1))
        dw = first_of_week(dm)
        dy = 14
        if dm == dw:
            dy = 7
        d = dw + datetime.timedelta(days=dy)
        # print(f"{d:%Y-%m-%d}")
        i_templates_list.append(f"UPDATE [Calendar] SET [HolidayName] = 'Mother''s Day' WHERE [Date] = '{d:%Y-%m-%d}';")
    print("\n" + "\n".join(i_templates_list) + "\n")


def add_fathers_day(start=2011, end=2025):
    # third sunday in June, https://www.calendardate.com/mothers_day_2023.htm

    i_templates_list = []
    for y in range(start, end + 1):
        dm = first_of_month(datetime.datetime(y, 6, 1))
        dw = first_of_week(dm)
        dy = 21
        if dm == dw:
            dy = 14
        d = dw + datetime.timedelta(days=dy)
        # print(f"{d:%Y-%m-%d}")
        i_templates_list.append(f"UPDATE [Calendar] SET [HolidayName] = 'Father''s Day' WHERE [Date] = '{d:%Y-%m-%d}';")
    print("\n" + "\n".join(i_templates_list) + "\n")


def past_inserts():
    start = datetime.datetime(1900, 1, 1)
    start = datetime.datetime(1951, 1, 1)
    end = datetime.datetime(2010, 12, 31)

    start = datetime.datetime(2026, 1, 1)
    end = datetime.datetime(2041, 1, 1)

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


def holiday_updates(start, end, update_insert="insert", output_file=None):
    dates = [(start + datetime.timedelta(days=i)).date() for i in range((end - start).days)]

    holidays_list = {}
    # Print all the holidays in UnitedKingdom in year 2018
    for ptr in holidays.Canada(years=list(range(start.year, end.year+1))).items():
        date, holiday_name = ptr
        holidays_list.update({date: holiday_name.replace("'", "''")})

    print(f"{holidays_list=}")
    print(f"{dates=}")

    i_templates_list = []

    if update_insert == "insert":
        top_template = f"INSERT INTO [Calendar] ([Date], [Day], [DayOfWeek], [SAT Holiday], [STAT Holiday], " \
                   f"[HolidayName]) VALUES"
        i_template = "('{date}', '{day}', {dow}, {sat_h}, {stat_h}, {hn})"

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

        oput = ""
        for i in range(0, len(i_templates_list), 1000):
            oput_ = f"\n" + top_template
            oput_ += ",\n".join(i_templates_list[i: i + 1000])
            oput_ += f";\n"
            print(oput_)
            oput += oput_

    else:
        top_template = f"UPDATE [Calendar] SET [HolidayName] = {{hn}}, [SAT Holiday] = {{sat_h}}, [STAT Holiday] = {{stat_h}} WHERE [Date] = '{{date}}'"
        for date in dates:
            hn = "NULL"
            dow = date.isoweekday()
            sat_h = 1 if (dow > 5) else 0
            stat_h = 0
            if date in holidays_list:
                hn = f"'{holidays_list[date]}'"
                stat_h = 1

            if sat_h or stat_h:
                i_templates_list.append(
                    top_template.format(date=date, sat_h=sat_h, stat_h=stat_h, hn=hn))

        oput = f"\n".join(i_templates_list)
        print(oput)

        # for i in range(0, len(i_templates_list), 1000):
        #     print(f"\n" + top_template)
        #     print(",\n".join(i_templates_list[i: i + 1000]))
        #     print(f";\n")

    if output_file is not None:
        with open(output_file, "w") as f:
            f.write(oput)


if __name__ == '__main__':

    start_ = datetime.datetime(1900, 1, 1)
    end_ = datetime.datetime(2041, 1, 1)

    # # start_ = datetime.datetime(2020, 1, 1)
    # # end_ = datetime.datetime(2021, 1, 1)
    # o_file = "output.sql"
    #
    # # new_inserts()
    # # old_updates()
    # # past_inserts()
    # holiday_updates(
    #     start=start_,
    #     end=end_,
    #     update_insert="update",
    #     output_file=o_file
    # )
    add_halloweens(start_.year, end_.year)
    add_mothers_day(start_.year, end_.year)
    add_fathers_day(start_.year, end_.year)
