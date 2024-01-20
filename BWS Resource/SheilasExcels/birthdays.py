import datetime

import pandas as pd
from pyodbc_connection import connect

excel_key_list = r"\\nas1\public\KEY LIST JUNE 2010.xls"

excel_birthdays = r"\\nas1\public\SHEILA\CLOTHING 2021\BWS_Birthday Report Jul 13 (2).xls"

sql_customers = """
SELECT
	*
FROM
	[ITR Customers]
;
"""

sql_found = """UPDATE [ITR Customers] SET [BirthYear] = {BY}, [BirthMonth] = {BM}, [BirthDay] = {BD}, [MiddleName] = {MN} WHERE [Name] = '{NAME}'"""
sql_new = """INSERT INTO [ITR Customers] ([Name], [Company], [Active], [BirthYear], [BirthMonth], [BirthDay], [MiddleName]) VALUES ('{NAME}', 'BWS', 1, {BY}, {BM}, {BD}, {MN})"""
sqls = [[], []]

if __name__ == '__main__':

    df_customers = connect(sql_customers)
    df_birthdays = pd.read_excel(excel_birthdays, skiprows=1)
    print(f"{df_birthdays}")

    for i, row in df_birthdays.iterrows():
        name = row["Position ID"]
        b_date_r = row["Birth Date"]
        b_date_day_r = row["Day"]
        b_date_month_r = row["Month"]
        l_name, f_name = name.split(",")
        f_name, *mid_name = f_name.strip().split(" ")
        name = f"{f_name} {l_name}".title().strip()
        mid_name = (mid_name if isinstance(mid_name, list) else [mid_name])
        mid_name = f"'{mid_name[0]}'" if mid_name else "NULL"

        if not pd.isnull(b_date_r):
            date = datetime.datetime.strptime(b_date_r, "%d/%m/%Y")
            b_year, b_month, b_day = date.year, date.month, date.day
        else:
            b_year, b_month, b_day = ["NULL" for i in range(3)]

        if not df_customers.loc[df_customers["Name"] == name].empty:
            print(f"Found ", end="")
            sqls[0].append(sql_found.format(BY=b_year, BM=b_month, BD=b_day, NAME=name, MN=mid_name))
        else:
            print(f"Couldn't find ", end="")
            sqls[1].append(sql_new.format(BY=b_year, BM=b_month, BD=b_day, NAME=name, MN=mid_name))

        print(f"{name}, {b_date_r}")

    for sqls_ in sqls:
        for sql in sqls_:
            print(f"{sql}")
