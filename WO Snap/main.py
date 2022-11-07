
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
        [LoggedOff] IS NOT NULL
        AND LEFT([EmployeeNumber], 1) <> '1'
        --AND (YEAR([LoggedOn]) = 2021 OR YEAR([LoggedOn]) = 2022)
        
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

GO_HOME_THRESHOLD = 9.5  # after this many hours of no new transactions, this employee must have gone home.
GO_HOME_THRESHOLD = clamp(5, GO_HOME_THRESHOLD, 23)


def calc_go_home_times(is_bws):
    if is_bws:
        data = connect(sql, database="SysproCompanyA", uid="SRS", pwd="", do_print=True, do_show=False)
    else:
        data = connect(sql, database="SysproCompanyS", uid="SCSRS", pwd="", do_print=True, do_show=False)

    rows, cols = data.shape
    print(f"# rows = {rows}, # cols = {cols}")

    calc_vals = []
    last_log_offs = []
    last_transactions = []
    last_transaction_emp = []
    parsable = []
    is_new_shift = []

    for i, row in data.iterrows():
        prev_row = data.iloc[i - 1]
        prev_log_on = prev_row["LoggedOn"]
        prev_log_off = prev_row["LoggedOff"]
        prev_transaction = prev_row["TransactionID"]

        new_log_on = row["LoggedOn"]
        new_log_off = row["LoggedOff"]

        val = ((new_log_on - prev_log_off) / pd.Timedelta(hours=1))

        old_num = prev_row["EmployeeNumber"]
        new_num = row["EmployeeNumber"]
        if new_num != old_num:
            val = None

        calc_vals.append(val)
        last_transactions.append(prev_transaction)
        last_transaction_emp.append(old_num)
        last_log_offs.append(prev_log_off)
        parsable.append(val is None or (val >= 0))
        is_new_shift.append(val is None or val >= GO_HOME_THRESHOLD)

        # # if '1478508' <= str(row["TransactionID"]) <= '1478533':
        # if '1439070' <= str(row["TransactionID"]) <= '1439120':
        # # if str(row["TransactionID"]) == '1474599':
        #     print(f"{val=}, {prev_transaction=}, {row=}, {calc_vals[-1]=}\n{type(row['LoggedOn'])}\n{type(row['LoggedOff'])}")
        #     values = '\n'.join(list(map(str, [new_log_on, new_log_off, prev_log_on, prev_log_off])))
        #     print(f"VALUES\n{values}")

    print(f"Adding calculated columns...")
    # this is slow...
    data["LastLogOffs"] = last_log_offs
    data["LastTransaction"] = last_transactions
    data["LastTransactionEmp"] = last_transaction_emp
    data["HrsFromLastLogOn"] = calc_vals
    data["Parsed"] = parsable
    data["IsNewShift"] = is_new_shift
    print(f"Columns added successfully!")

    d = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    c = "BWS" if is_bws else "STG"
    e_name = f"output {c} {d}.xlsx"
    f_name = f"output {c} {d}.sql"
    print(f"creating excel '{e_name}'...")
    data.to_excel(e_name)
    print(f"excel creation complete!")
    print(data)

    update_query = "INSERT INTO" \
                   " [ClkTransactionNewShifts]" \
                   " (" \
                   "    [ClkTransactionIDIn]," \
                   "    [ClkTransactionIDLast]," \
                   "    [IsNewShift]," \
                   "    [Parsed]," \
                   "    [Alteration]" \
                   ") VALUES {t};"
    if is_bws:
        update_query = "\nUSE [SysproCompanyA]\nGO\n" + update_query
    else:
        update_query = "\nUSE [SysproCompanyA]\nGO\n" + update_query
    rows = []
    template = "({a}, {b}, {c}, {d}, '{e}')"

    for i, row in data.iterrows():
        rows.append(template.format(a=row["TransactionID"], b=row["LastTransaction"], c=(1 if row["IsNewShift"] else 0), d=(1 if row["Parsed"] else 0), e="INITIALIZATION"))

    with open(f_name, "w") as f:
        for i in range(0, len(rows), 1000):
            f.write(update_query.format(t=",\n".join(rows[i: i + 1000])))


if __name__ == '__main__':
    calc_go_home_times(is_bws=True)
    calc_go_home_times(is_bws=False)
