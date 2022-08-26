import datetime

import pandas as pd
import pyodbc


# General Pyodbc connection handler.
# Version........................1.2
# Date....................2022-08-25
# Author................Avery Briggs


def connect(sql, cstr="DRIVER={SQL Server};SERVER=server3;DATABASE=BWSdb;UID=user5;PWD=M@gic456", driver=None, server=None, database=None, uid=None, pwd=None, do_print=False, do_show=False):
    template = "DRIVER={{dri}};SERVER={svr};DATABASE={db};UID={uid};PWD={pwd}"
    params = [driver, server, database, uid, pwd]
    if cstr is None or any([x is not None for x in params]):
		
    df = None
    try:
        # sql_opt = "SELECT [IT Requests].*, [dept].[Dept] AS [DeptName], [IT Personnel].[Name] AS [ITPersonnelAssignedName] FROM [IT Requests] LEFT JOIN [Dept] ON [IT Requests].[Department] = [Dept].[DeptID] LEFT JOIN [IT Personnel] ON [IT Requests].[ITPersonAssignedID] = [IT Personnel].[ITPersonID#]"
        if do_print:
            print("connecting...")
        conn = pyodbc.connect(cstr)
        if do_print:
            print("querying...")
        if do_show:
            print(sql)
        df = pd.DataFrame(pd.read_sql_query(sql, conn))
        if do_print:
            print("closing...")
        conn.close()
    except pyodbc.DatabaseError as de:
        print(f"DatabaseError\n{de}")
    finally:
        if not isinstance(df, pd.DataFrame):
            df = pd.DataFrame()
    return df


if __name__ == "__main__":
	print(connect("SELECT * FROM [IT Requests]"))
