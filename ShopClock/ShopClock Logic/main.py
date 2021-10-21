from utility import *

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
                offset += dt.timedelta(0,0,0,0,0,-12)

        lo_fi_time = last_out - first_in
        clocked_time += offset
        emp_dict.update({
            "shift_time:": shift_time,  # denotes the very last transaction subtract the first transaction.
            "lo_fi_time:": lo_fi_time,  # denotes the difference between last sign-out and first sign-in.
            "clocked_time": clocked_time  # running sum of hours. (Value of actual worked hours)
        })

        print(dict_print(emp_dict, "Results"))
