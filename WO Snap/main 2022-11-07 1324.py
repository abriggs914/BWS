import pandas as pd

from pyodbc_connection import *
from utility import *

sql = """SELECT 
        [TransactionID]
        , [EmployeeName]
        , [EmployeeNumber]
        , [LoggedOn]
        , [LoggedOff]
    FROM 
        [ClkTransaction]

    WHERE
        LEFT([EmployeeNumber], 1) <> '1'
        AND (YEAR([LoggedOn]) = 2021 OR YEAR([LoggedOn]) = 2022)

    --WHERE
    --   [EmployeeNumber] = 200613
    --	YEAR([LoggedOn]) = 2021
        --AND 
        --[EmployeeNumber] = 200434



    GROUP BY
        [TransactionID]
        , [EmployeeName]
        , [EmployeeNumber]
        , [LoggedOn]
        , [LoggedOff]
    ORDER BY
        [EmployeeName]
        , [TransactionID]
        , [LoggedOn]
        ;"""

if __name__ == '__main__':
    print('PyCharm')

    data = connect(sql, database="SysproCompanyA", uid="SRS", pwd="", do_print=True, do_show=False)

    print(f"{data.shape=}")

    calc_vals = []
    last_log_offs = []
    last_transactions = []
    parsable = []

    for i, row in data.iterrows():
        prev_row = data.iloc[i - 1]
        prev_emp_number = prev_row["EmployeeNumber"]
        new_emp_number = row["EmployeeNumber"]
        prev_log_on = prev_row["LoggedOn"]
        prev_log_off = prev_row["LoggedOff"]
        prev_transaction = prev_row["TransactionID"]

        new_log_on = row["LoggedOn"]
        new_log_off = row["LoggedOff"]

        # if new_log_on == new_log_off:
        # print("HERE")
        # employee did not log onto their job, correction by foreman moves the start and end times to the same time
        # use the last log-off time from their previous transaction to determine hours since last transaction.
        # new_log_on, prev_log_off = new_log_on, prev_log_off

        # new_log_on, prev_log_off = prev_log_off, new_log_on

        # if prev_emp_number != new_emp_number:
        #     calc_vals.append(None)
        #     last_transactions.append(None)
        #     last_log_offs.append(None)
        #     continue
        #
        # if new_log_on == new_log_off:
        #     if prev_log_on <= new_log_on <= prev_log_off and prev_log_on <= new_log_off <= prev_log_off:
        #         # this transaction is entirely contained in the row previous to this one
        #         new_log_on = prev_log_on
        #         new_log_off = prev_log_off

        val = ((new_log_on - prev_log_off) / pd.Timedelta(hours=1))

        old_num = prev_row["EmployeeNumber"]
        new_num = row["EmployeeNumber"]
        if new_num != old_num:
            val = None

        calc_vals.append(val)
        last_transactions.append(prev_transaction)
        last_log_offs.append(prev_log_off)
        parsable.append(False if val is None else (val >= 0))

        # # if '1478508' <= str(row["TransactionID"]) <= '1478533':
        # if '1439070' <= str(row["TransactionID"]) <= '1439120':
        # # if str(row["TransactionID"]) == '1474599':
        #     print(f"{val=}, {prev_transaction=}, {row=}, {calc_vals[-1]=}\n{type(row['LoggedOn'])}\n{type(row['LoggedOff'])}")
        #     values = '\n'.join(list(map(str, [new_log_on, new_log_off, prev_log_on, prev_log_off])))
        #     print(f"VALUES\n{values}")

    data["LastLogOffs"] = last_log_offs
    data["LastTransaction"] = last_transactions
    data["HrsFromLastLogOn"] = calc_vals
    data["Parsed"] = parsable

    data.to_excel("output 20221107_132200.xlsx")
    print(data)
