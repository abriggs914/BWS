import datetime

import pandas as pd
import pyodbc


# General Pyodbc connection handler.
# Version........................1.1
# Date....................2022-08-10
# Author................Avery Briggs


def connect(sql, cstr="DRIVER={SQL Server};SERVER=server3;DATABASE=BWSdb;UID=user5;PWD=M@gic456", do_print=False):
    df = None
    try:
        # sql_opt = "SELECT [IT Requests].*, [dept].[Dept] AS [DeptName], [IT Personnel].[Name] AS [ITPersonnelAssignedName] FROM [IT Requests] LEFT JOIN [Dept] ON [IT Requests].[Department] = [Dept].[DeptID] LEFT JOIN [IT Personnel] ON [IT Requests].[ITPersonAssignedID] = [IT Personnel].[ITPersonID#]"
        if do_print:
            print("connecting...")
        conn = pyodbc.connect(cstr)
        if do_print:
            print("querying...")
        df = pd.DataFrame(pd.read_sql_query(sql, conn))
        if do_print:
            print("closing...")
        conn.close()
    except pyodbc.DatabaseError as de:
        print(f"DatabaseError\n{de}")
    return df


if __name__ == "__main__":
	print(connect("SELECT * FROM [IT Requests]"))

