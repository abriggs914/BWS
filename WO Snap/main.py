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
    --WHERE
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
        , [LoggedOn]
    ;"""


if __name__ == '__main__':
    print('PyCharm')



    data = connect(sql, database="SysproCompanyA", uid="SRS", pwd="", do_print=True, do_show=False)

    print(f"{data.shape=}")

    calc_vals = []
    last_log_offs = []
    last_transactions = []

    for i, row in data.iterrows():
        prev_row = data.iloc[i - 1]
        prev_log_on = prev_row["LoggedOn"]
        prev_log_off = prev_row["LoggedOff"]
        prev_transaction = prev_row["TransactionID"]

        last_log_offs.append(prev_log_off)

        new_log_on = row["LoggedOn"]

        if prev_log_on == prev_log_off:
            new_log_on, prev_log_off = row["LoggedOff"], new_log_on

        val = (new_log_on - prev_log_off) / pd.Timedelta(hours=1)

        old_num = prev_row["EmployeeNumber"]
        new_num = row["EmployeeNumber"]
        if new_num != old_num:
            val = None

        calc_vals.append(val)
        last_transactions.append(prev_transaction)

    # if str(row["TransactionID"]) == '1011275':
    #     print(f"{row=}, {calc_vals[-1]=}\n{type(row['LoggedOn'])}\n{type(row['LoggedOff'])}")

    # print(f"{calc_vals[:20]=}\n...\n{calc_vals[-20:]=}")

    data["HrsFromLastLogOn"] = calc_vals
    data["LastLogOffs"] = last_log_offs
    data["LastTransaction"] = last_transactions
    data.to_excel("output.xlsx")
    print(data)
