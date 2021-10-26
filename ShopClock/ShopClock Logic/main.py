from utility import *


# Used for signing-out. Takes care of employees clocking-out late.
# interval in minutes
# threshold in minutes
def align_ahead(time, interval, threshold=0, start_time=None, end_time=None):
    if start_time is None:
        start_time = dt.datetime(time.year, time.month, time.day, 0, 0, 0)
    if end_time is None:
        end_time = dt.datetime(time.year, time.month, time.day, 0, 0, 0) + dt.timedelta(days=1) + dt.timedelta(
            minutes=threshold)

    n_minutes = (end_time - start_time).total_seconds() / 60
    intervals = [start_time + dt.timedelta(minutes=(i * interval)) for i in range(ceil(n_minutes / interval))]

    for t in intervals:
        if t + dt.timedelta(minutes=threshold) >= time:
            return t
    return time


# Used for signing-in. Takes care of employees being late.
# interval in minutes
# threshold in minutes
def align_behind(time, interval, threshold=0, start_time=None, end_time=None):
    if start_time is None:
        # start_time = time + dt.timedelta(hours=-12)
        start_time = dt.datetime(time.year, time.month, time.day, 0, 0, 0)
    if end_time is None:
        # end_time = time + dt.timedelta(hours=12)
        end_time = dt.datetime(time.year, time.month, time.day, 0, 0, 0) + dt.timedelta(days=1) + dt.timedelta(
            minutes=threshold)

    n_minutes = (end_time - start_time).total_seconds() / 60
    # print("start_time:", start_time)
    # print("end_time:", end_time)
    # print("n_minutes:", n_minutes)
    intervals = [start_time + dt.timedelta(minutes=(i * interval)) for i in range(ceil(n_minutes / interval))]

    # print("intervals:", "\n".join([str(t) for t in intervals]))

    for i, t in enumerate(intervals):
        if time - dt.timedelta(minutes=threshold) <= t:
            # print("early exit")
            return t
        # elif t - dt.timedelta(minutes=threshold) > time:
        # print("early exit")
        # return t
    # print("last exit")
    return time


def write_align_ahead_tests():
    with open("align_ahead output.txt", "w")  as f:
        td = dt.datetime(2021, 10, 26, 0, 0, 0)
        f.write(dict_print({
            "start_date:": td,
            "interval": interval,
            "threshold": threshold
        }, "Align-ahead args"))
        f.write("\n\n")
        for i in range(60 * 24):
            # print("td: \"{}\": {}".format(td, align_ahead(td, interval, threshold)))
            f.write("td: \"{}\": {}\n".format(td, align_ahead(td, interval, threshold)))
            td = td + dt.timedelta(minutes=1)


def write_align_behind_tests():
    with open("align_behind output.txt", "w")  as f:
        td = dt.datetime(2021, 10, 26, 0, 0, 0)
        f.write(dict_print({
            "start_date:": td,
            "interval": interval,
            "threshold": threshold
        }, "Align-behind args"))
        f.write("\n\n")
        for i in range(60 * 24):
            # print("td: \"{}\": {}".format(td, align_ahead(td, interval, threshold)))
            f.write("td: \"{}\": {}\n".format(td, align_behind(td, interval, threshold)))
            td = td + dt.timedelta(minutes=1)


if __name__ == '__main__':
    sign_in = dt.datetime(2021, 10, 21, 6, 30, 0)
    sign_out = dt.datetime(2021, 10, 21, 14, 30, 0)
    lunch_in = sign_in + dt.timedelta(0, 0, 0, 0, 30, 4)
    lunch_out = sign_in + dt.timedelta(0, 0, 0, 0, 0, 4)
    afternoon_in = lunch_in + dt.timedelta(0, 0, 0, 0, 30, 2)
    afternoon_out = lunch_in + dt.timedelta(0, 0, 0, 0, 15, 2)

    # normal employee shift 6:30-10:30-11:00-14:30
    emp_1_data = [("in", sign_in), ("out", lunch_out), ("in", lunch_in), ("out", sign_out)]
    # normal employee shift  6:30-10:30-11:00-13:15-13:30-14:30
    emp_2_data = [("in", sign_in), ("out", lunch_out), ("in", lunch_in), ("out", afternoon_out), ("in", afternoon_in),
                  ("out", sign_out)]

    # employee shift not ended previous day ---10:30-11:00-14:30
    emp_3_data = [("out", lunch_out), ("in", lunch_in), ("out", afternoon_out), ("in", afternoon_in)]

    # employee shift not ended today 6:30-10:30-11:00---
    emp_4_data = [("in", sign_in), ("out", lunch_out), ("in", lunch_in)]

    # employee shift not ended previous day or today 6:30-10:30-11:00---
    emp_5_data = [("out", lunch_out), ("in", lunch_in), ("out", afternoon_out)]

    emps = [(100, emp_1_data), (200, emp_2_data), (300, emp_3_data), (400, emp_4_data), (500, emp_5_data)]

    for i, emp in enumerate(emps):
        emp_num, emp_data = emp

        emp_dict = {"emp_num": emp_num}

        emp_data.sort(key=lambda tpl: tpl[1])
        clocked_in = False
        work_time = None
        first_in = None
        last_out = None
        clocked_time = dt.timedelta()
        time = dt.timedelta()
        for j, dat in enumerate(emp_data):
            status, time = dat
            if status == "in":
                clocked_in = True
                work_time = time
                if first_in is None:
                    first_in = time
            else:
                clocked_in = False
                if work_time is None:
                    work_time = dt.datetime(time.year, time.month, time.day, 0, 0, 0)
                clocked_time += (time - work_time)
                if last_out is None or time > last_out:
                    last_out = time
            emp_dict.update({str(j) + " " + status: time})

        if len(emp_data) % 2 == 1:
            clocked_time += (dt.datetime(time.year, time.month, time.day + 1, 0, 0, 0) - time)

        if first_in is None:
            first_in = 0
        if last_out is None:
            last_out = 0

        offset = dt.timedelta()
        if not emp_data:
            shift_time = 0
        else:
            shift_time = emp_data[-1][1] - emp_data[0][1]
            if emp_data[0][0] == "out":
                offset += dt.timedelta(0, 0, 0, 0, 0, -12)

        lo_fi_time = last_out - first_in
        clocked_time += offset
        emp_dict.update({
            "shift_time:": shift_time,  # denotes the very last transaction subtract the first transaction.
            "lo_fi_time:": lo_fi_time,  # denotes the difference between last sign-out and first sign-in.
            "clocked_time": clocked_time  # running sum of hours. (Value of actual worked hours)
        })

        print(dict_print(emp_dict, "Results"))

        t1 = dt.datetime.now()
        t2 = dt.datetime(2021, 10, 26, 7, 56, 0)
        t3 = dt.datetime(2021, 10, 26, 7, 57, 0)
        t4 = dt.datetime(2021, 10, 26, 7, 58, 0)
        t5 = dt.datetime(2021, 10, 26, 7, 59, 0)
        t6 = dt.datetime(2021, 10, 26, 8, 0, 0)
        t7 = dt.datetime(2021, 10, 26, 8, 1, 0)
        t8 = dt.datetime(2021, 10, 26, 8, 2, 0)
        t9 = dt.datetime(2021, 10, 26, 8, 3, 0)
        t10 = dt.datetime(2021, 10, 26, 8, 4, 0)
        interval = 15
        threshold = 3
        print("align_ahead \"" + str(t1) + "\":", align_ahead(t1, interval, threshold))

        for t in [t2, t3, t4, t5, t6, t7, t8, t9, t10]:
            print("t: \"{}\": {}".format(t, align_ahead(t, interval, threshold)))

        # write_align_ahead_tests()
        write_align_behind_tests()
