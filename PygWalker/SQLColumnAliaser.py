import sys

from pyodbc_connection import connect

if __name__ == '__main__':
    # print(sys.argv)

    table_name = "ITR Customers"
    table_alias = "C"
    alias = "ITRCustomers"

    table_name = "IT Personnel"
    table_alias = "P"
    alias = "ITPersonnel"

    df = connect(f"""SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = N'{table_name}'""")
    # print(df)

    col_names = df["COLUMN_NAME"].values.tolist()

    # ,[C].[Name] AS [ITRCustomersName]
    for name in col_names:
        print(f",[{table_alias}].[{name}] AS [{alias}{name}]")
