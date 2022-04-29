from utility import *

import pandas as pd
import pyodbc
from xlwt import Workbook

# Program to query and dump Work order status data into an excel spreadsheet
# with each job# on it's own tab. (Yes, A LOT of tabs)
# All jobs are queried for status as of EOD on 2022-03-31.

if __name__ == '__main__':
    directory = "Spreadsheets"
    do_BWS = False
    start_t = dt.datetime.now()

    ranges = [
        # (dt.datetime(2020, 3, 31), dt.datetime(2021, 3, 31)),
        (dt.datetime(2021, 4, 1), dt.datetime(2022, 3, 31))
    ]

    if do_BWS:
        # BWS output
        cstr = "DRIVER={SQL Server};SERVER=server3;DATABASE=SysproCompanyA;UID=SRS;PWD="
    else:
        # STG output
        cstr = "DRIVER={SQL Server};SERVER=server3;DATABASE=SysproCompanyS;UID=SCSRS;PWD="

    sql = """
    SET NOCOUNT ON;
select InvMaster.StockCode, [Description], LongDesc, Warehouse,

sum(case when year(EntryDate) = {y1} and month(EntryDate) = 4 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) as [April {y1} Purchases],
avg(case when year(EntryDate) = {y1} and month(EntryDate) = 4 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [April {y1} Avg Unit Cost],
sum(case when year(EntryDate) = {y1} and month(EntryDate) = 4 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) * avg(case when year(EntryDate) = {y1} and month(EntryDate) = 4 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [April {y1} Cost],

sum(case when year(EntryDate) = {y1} and month(EntryDate) = 5 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) as [May {y1} Purchases],
avg(case when year(EntryDate) = {y1} and month(EntryDate) = 5 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [May {y1} Avg Unit Cost],
sum(case when year(EntryDate) = {y1} and month(EntryDate) = 5 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) * avg(case when year(EntryDate) = {y1} and month(EntryDate) = 5 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [May {y1} Cost],

sum(case when year(EntryDate) = {y1} and month(EntryDate) = 6 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) as [June {y1} Purchases],
avg(case when year(EntryDate) = {y1} and month(EntryDate) = 6 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [June {y1} Avg Unit Cost],
sum(case when year(EntryDate) = {y1} and month(EntryDate) = 6 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) * avg(case when year(EntryDate) = {y1} and month(EntryDate) = 6 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [June {y1} Cost],

sum(case when year(EntryDate) = {y1} and month(EntryDate) = 7 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) as [July {y1} Purchases],
avg(case when year(EntryDate) = {y1} and month(EntryDate) = 7 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [July {y1} Avg Unit Cost],
sum(case when year(EntryDate) = {y1} and month(EntryDate) = 7 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) * avg(case when year(EntryDate) = {y1} and month(EntryDate) = 7 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [July {y1} Cost],

sum(case when year(EntryDate) = {y1} and month(EntryDate) = 8 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) as [August {y1} Purchases],
avg(case when year(EntryDate) = {y1} and month(EntryDate) = 8 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [August {y1} Avg Unit Cost],
sum(case when year(EntryDate) = {y1} and month(EntryDate) = 8 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) * avg(case when year(EntryDate) = {y1} and month(EntryDate) = 8 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [August {y1} Cost],

sum(case when year(EntryDate) = {y1} and month(EntryDate) = 9 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) as [September {y1} Purchases],
avg(case when year(EntryDate) = {y1} and month(EntryDate) = 9 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [September {y1} Avg Unit Cost],
sum(case when year(EntryDate) = {y1} and month(EntryDate) = 9 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) * avg(case when year(EntryDate) = {y1} and month(EntryDate) = 9 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [September {y1} Cost],

sum(case when year(EntryDate) = {y1} and month(EntryDate) = 10 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) as [October {y1} Purchases],
avg(case when year(EntryDate) = {y1} and month(EntryDate) = 10 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [October {y1} Avg Unit Cost],
sum(case when year(EntryDate) = {y1} and month(EntryDate) = 10 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) * avg(case when year(EntryDate) = {y1} and month(EntryDate) = 10 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [October {y1} Cost],

sum(case when year(EntryDate) = {y1} and month(EntryDate) = 11 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) as [November {y1} Purchases],
avg(case when year(EntryDate) = {y1} and month(EntryDate) = 11 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [November {y1} Avg Unit Cost],
sum(case when year(EntryDate) = {y1} and month(EntryDate) = 11 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) * avg(case when year(EntryDate) = {y1} and month(EntryDate) = 11 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [November {y1} Cost],

sum(case when year(EntryDate) = {y1} and month(EntryDate) = 12 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) as [December {y1} Purchases],
avg(case when year(EntryDate) = {y1} and month(EntryDate) = 12 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [December {y1} Avg Unit Cost],
sum(case when year(EntryDate) = {y1} and month(EntryDate) = 12 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) * avg(case when year(EntryDate) = {y1} and month(EntryDate) = 12 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [December {y1} Cost],

sum(case when year(EntryDate) = {y2} and month(EntryDate) = 1 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) as [January {y2} Purchases],
avg(case when year(EntryDate) = {y2} and month(EntryDate) = 1 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [January {y2} Avg Unit Cost],
sum(case when year(EntryDate) = {y2} and month(EntryDate) = 1 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) * avg(case when year(EntryDate) = {y2} and month(EntryDate) = 1 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [January {y2} Cost],

sum(case when year(EntryDate) = {y2} and month(EntryDate) = 2 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) as [February {y2} Purchases],
avg(case when year(EntryDate) = {y2} and month(EntryDate) = 2 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [February {y2} Avg Unit Cost],
sum(case when year(EntryDate) = {y2} and month(EntryDate) = 2 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) * avg(case when year(EntryDate) = {y2} and month(EntryDate) = 2 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [February {y2} Cost],

sum(case when year(EntryDate) = {y2} and month(EntryDate) = 3 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) as [March {y2} Purchases], -- unit cost
avg(case when year(EntryDate) = {y2} and month(EntryDate) = 3 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [March {y2} Avg Unit Cost], -- unit cost
sum(case when year(EntryDate) = {y2} and month(EntryDate) = 3 and MovementType = 'I' and TrnType = 'R' then TrnQty else 0 end) * avg(case when year(EntryDate) = {y2} and month(EntryDate) = 3 and MovementType = 'I' and TrnType = 'R' then [UnitCost] else 0 end) as [March {y2} Cost]
from InvMovements with (nolock)
left outer join InvMaster with (nolock) on InvMovements.StockCode = InvMaster.StockCode
where (
        (Warehouse not in ('02', '03', '06', '99') and MovementType = 'I' and TrnType = 'R')
)
and EntryDate between '{d1}' and '{d2}'
group by InvMaster.StockCode, [Description], LongDesc, Warehouse
"""

    print("connecting...")
    conn = pyodbc.connect(cstr)
    end_conn_t = dt.datetime.now()

    wb = Workbook()
    sheets = {}
    writeable = False
    md1, md2 = None, None

    for d1, d2 in ranges:
        if md1 is None:
            md1 = md2 = d1
        if d1 < md1:
            md1 = d1
        if d2 > md2:
            md2 = d2
        sheet_name = f"{d1.strftime('%Y-%m-%d')} -- {d2.strftime('%Y-%m-%d')}"
        sheet = wb.add_sheet(sheet_name)
        # sheets[]
        sql_str = sql.format(d1=d1, d2=d2, y1=d1.year, y2=d2.year)
        print("querying...")
        df = pd.DataFrame(pd.read_sql_query(sql_str, conn))

        writeable = True
        cols = list(df.columns)
        for i, row_dat in df.iterrows():
            for j, c_r in enumerate(zip(cols, row_dat)):
                c_name, value = c_r
                # print(f"i, j: ({i}, {j}), v: {value}")
                if i == 0:
                    sheet.write(0, j, str(c_name))
                sheet.write(i + 1, j, value)

    end_query_t = dt.datetime.now()
    end_process_t = dt.datetime.now()
    # print(data[list(data.keys())[0]])

    f_name = None
    if writeable:
        if do_BWS:
            f_name = "BWS Purchases By SKU Summary - {md1} to {md2}.xls"
        else:
            f_name = "Stargate Purchases By SKU Summary - {md1} to {md2}.xls"
        f_name = directory + "/" + f_name.format(md1=md1.strftime("%Y-%m-%d"), md2=md2.strftime("%Y-%m-%d"))
        wb.save(f_name)
    else:
        print("NOT WRITABLE")

    conn.close()

    print("done!")
    end_t = dt.datetime.now()
    time_diff = (end_t - start_t).seconds
    time_conn = (end_conn_t - start_t).seconds
    time_query = (end_query_t - end_conn_t).seconds
    time_process = (end_process_t - end_query_t).seconds
    time_results = {
        "start time": start_t,
        "end time": end_t,
        "time connecting": time_conn,
        "time querying": time_query,
        "time writing": time_process,
        "Total Time (s)": time_diff,
        "Output File:": "\'" + f_name + "\'"
    }
    print(dict_print(time_results, "Time Results"))
