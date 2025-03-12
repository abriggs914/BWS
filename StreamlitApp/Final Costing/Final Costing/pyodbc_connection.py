import datetime
from typing import Optional

import pandas as pd
import pyodbc


VERSION = \
    """
    General Pyodbc connection handler.
    Geared towards BWS connections.
    Version...............2.6
    Date...........2025-03-06
    Author(s)....Avery Briggs
    """


#######################################################################################################################
#######################################################################################################################
#######################################################################################################################


def VERSION_DETAILS():
    return VERSION.lower().split("version")[0].strip()


def VERSION_NUMBER():
    return float(".".join(VERSION.lower().split("version")[-1].split("date")[0].split(".")[-2:]).strip())


def VERSION_DATE():
    return datetime.datetime.strptime(VERSION.lower().split("date")[-1].split("author")[0].split(".")[-1].strip(), "%Y-%m-%dictionary")


def VERSION_AUTHORS():
    return [w.removeprefix(".").strip().title() for w in VERSION.lower().split("author(s)")[-1].split("..") if w.strip()]


#######################################################################################################################
#######################################################################################################################
#######################################################################################################################


def can_connect(
        driver: str = "{SQL Server}",
        server: str = "server3",
        database: str = "BWSdb",
        uid: str = "user5",
        pwd: str = "M@gic456",
        timeout: int = 0
) -> None | pyodbc.Connection:
    template = "DRIVER={dri};SERVER={svr};DATABASE={db};UID={uid};PWD={pwd}"
    # params = [driver, server, database, uid, pwd]
    if pwd and uid is None:
        raise ValueError("Error you must pass both a username and a password. Got only a password.")
    if uid and pwd is None:
        raise ValueError("Error you must pass both a username and a password. Got only a username.")
    # print(f"before {template=}")
    cstr = template.format(dri=driver, svr=server, db=database, uid=uid, pwd=pwd)
    try:
        conn = pyodbc.connect(cstr, timeout=max(0, min(300, timeout)))
    except pyodbc.DatabaseError as de:
        print(f"DatabaseError\n{de}")
    else:
        return conn


def connect_2(
    sql: str,
    driver: str = "{SQL Server}",
    server: str = "server3",
    database: str = "BWSdb",
    uid: str = "user5",
    pwd: str = "M@gic456",
    timeout: int = 0,
    enable_mars: bool = False,
    error_on_no_records: bool = False
):
    try:
        # print(f"try")
        template = "DRIVER={dri};SERVER={svr};DATABASE={db};UID={uid};PWD={pwd};MARS_Connection={mc}"
        cstr = template.format(dri=driver, svr=server, db=database, uid=uid, pwd=pwd, mc="yes" if enable_mars else "no")
        conn = pyodbc.connect(cstr, timeout=timeout)

        crsr = conn.cursor()
        crsr.execute(sql)
        results = crsr.fetchall()
        conn.commit()

        columns = [desc[0] if desc else i for i, desc in enumerate(crsr.description)]
        # print(columns)
        # print(f"{type(results)=}, {type(results[0])=}")
        df = pd.DataFrame([dict(zip(columns, row)) for row in results], columns=columns)

        conn.close()

        # return results

    except Exception as e:
        df = pd.DataFrame()
        print(f"except\n{e=}")
        if error_on_no_records:
            raise e

    return df


def connect(
        sql: str,
        driver: str = "{SQL Server}",
        server: str = "server3",
        database: str = "BWSdb",
        uid: str = "user5",
        pwd: str = "M@gic456",
        do_print: bool = False,
        do_show: bool = False,
        do_exec: bool = True,
        timeout: int = 0,
        returns_records: Optional[bool] = None
) -> pd.DataFrame:
    """
    A wrapper function for pyodbc.connect function.
    Predefined parameters point to Server3's BWSdb Database using user5's credentials.
    Executes in a try-except block that only catches pyodbc.DatahaseError

    parameters:

        sql         - a string of sql queries delimited by ';'
                      OR a single table name in the database

        driver,
        server,
        database,
        uid,
        and pwd     - These parameters are combined using pyodbc connection string template

        do_print    - shows connection and query status via print statements
        do_show     - shows connection information and sql queries via print statements
        do_exec     - used with 'do_print' and 'do_exec' this parameter controls if the sql is sent to the database.
                    - Use for testing
        timeout     - see pyodbc.connect timeout parameter

    examples:

        print(connect("[IT Requests]"))
        print(connect("SELECT TOP 10 * FROM [IT Requests]", uid="user5", pwd="M@gic456"))
        print(connect("SELECT TOP 10 * FROM [ClkTransaction]", database="SysproCompmanyA", uid="SRS", pwd=""))
    """
    template = "DRIVER={dri};SERVER={svr};DATABASE={db};UID={uid};PWD={pwd}"
    # params = [driver, server, database, uid, pwd]
    if pwd and uid is None:
        raise ValueError("Error you must pass both a username and a password. Got only a password.")
    if uid and pwd is None:
        raise ValueError("Error you must pass both a username and a password. Got only a username.")
    # print(f"before {template=}")
    cstr = template.format(dri=driver, svr=server, db=database, uid=uid, pwd=pwd)

    distinct_queries = [stmt for stmt in f"{sql};".split(";") if stmt.strip()]
    n_distinct_queries = len(distinct_queries)
    has_insert = all([
        any([
            stmt in sql.upper(),
            f"{stmt.rstrip()}\n" in sql.upper(),
            f"{stmt.rstrip()}\t" in sql.upper()
        ])
        for stmt in ["INSERT INTO ", "VALUES "]
    ])
    has_update = all([
        any([
            stmt in sql.upper(),
            f"{stmt.rstrip()}\n" in sql.upper(),
            f"{stmt.rstrip()}\t" in sql.upper()
        ])
        for stmt in ["UPDATE ", "SET "]
    ])
    has_exec = all([
        any([
            stmt in sql.upper(),
            f"{stmt.rstrip()}\n" in sql.upper(),
            f"{stmt.rstrip()}\t" in sql.upper()
        ])
        for stmt in ["EXEC "]
    ])
    has_delete = all([
        any([
            stmt in sql.upper(),
            f"{stmt.rstrip()}\n" in sql.upper(),
            f"{stmt.rstrip()}\t" in sql.upper()
        ])
        for stmt in ["DELETE ", "FROM "]
    ])

    if returns_records is None:
        returns_records = not any([has_insert, has_exec, has_update, has_delete])

    if all([
        n_distinct_queries == 1,
        "SELECT" not in sql.upper(),
        "FROM" not in sql.upper(),
        not any([has_update, has_insert, has_exec, has_delete])
    ]):
        # single table name passed
        tbl = sql.removeprefix("[").removesuffix("]")
        sql = f"SELECT * FROM [{tbl}];"

    # print(f"after {template=}")
    df = None
    conn, crsr = None, None
    # print(f"\tRES\t{cstr=}, {template=}")
    try:
        # sql_opt = "SELECT [IT Requests].*, [dept].[Dept] AS [DeptName], [IT Personnel].[Name] AS [ITPersonnelAssignedName] FROM [IT Requests] LEFT JOIN [Dept] ON [IT Requests].[Department] = [Dept].[DeptID] LEFT JOIN [IT Personnel] ON [IT Requests].[ITPersonAssignedID] = [IT Personnel].[ITPersonID#]"
        if do_print:
            print("connecting...")
        if do_show and do_print:
            print(f"cstr: '{cstr}'")
        if do_exec:
            conn = pyodbc.connect(cstr, timeout=timeout)
            crsr = conn.cursor()
        if do_print:
            print("querying...")
        if do_show:
            if not do_exec:
                print(f"NO-EXEC SQL: ", end="")
            print(sql)

        if (not returns_records) and (has_insert or has_update or has_delete):
            # no return value
            if do_exec:
                crsr.execute(sql)
                conn.commit()
        else:
            if do_exec:
                df = pd.DataFrame(pd.read_sql_query(sql, conn))

        if do_print:
            print("closing...")
        if do_exec:
            conn.close()
    except pyodbc.DatabaseError as de:
        print(f"DatabaseError\n{de}")
    # except TypeError as te:
    #     print(f"TypeError\n{te}")
    finally:
        if not isinstance(df, pd.DataFrame):
            df = pd.DataFrame()
    return df



# def connect(
#         sql: str,
#         driver: str = "{SQL Server}",
#         server: str = "server3",
#         database: str = "BWSdb",
#         uid: str = "user5",
#         pwd: str = "M@gic456",
#         do_print: bool = False,
#         do_show: bool = False,
#         do_exec: bool = True,
#         timeout: int = 0,
#         enable_mars: bool = False,
#         returns_records: Optional[bool] = None,
#         run_as_single: bool = False
# ) -> pd.DataFrame | list[pd.DataFrame]:
#     """
#     A wrapper function for pyodbc.connect function.
#     Predefined parameters point to Server3's BWSdb Database using user5's credentials.
#     Executes in a try-except block that only catches pyodbc.DatahaseError
#
#     parameters:
#
#         sql         - a string of sql queries delimited by ';'
#                       OR a single table name in the database
#
#         driver,
#         server,
#         database,
#         uid,
#         and pwd     - These parameters are combined using pyodbc connection string template
#
#         do_print    - shows connection and query status via print statements
#         do_show     - shows connection information and sql queries via print statements
#         do_exec     - used with 'do_print' and 'do_exec' this parameter controls if the sql is sent to the database.
#                     - Use for testing
#         timeout     - see pyodbc.connect timeout parameter
#
#     examples:
#
#         print(connect("[IT Requests]"))
#         print(connect("SELECT TOP 10 * FROM [IT Requests]", uid="user5", pwd="M@gic456"))
#         print(connect("SELECT TOP 10 * FROM [ClkTransaction]", database="SysproCompmanyA", uid="SRS", pwd=""))
#     """
#     template = "DRIVER={dri};SERVER={svr};DATABASE={db};UID={uid};PWD={pwd};MARS_Connection={mc}"
#     # params = [driver, server, database, uid, pwd]
#     if pwd and uid is None:
#         raise ValueError("Error you must pass both a username and a password. Got only a password.")
#     if uid and pwd is None:
#         raise ValueError("Error you must pass both a username and a password. Got only a username.")
#     # print(f"before {template=}")
#     cstr = template.format(dri=driver, svr=server, db=database, uid=uid, pwd=pwd, mc="yes" if enable_mars else "no")
#
#     distinct_queries = [stmt for stmt in f"{sql};".split(";") if stmt.strip()]
#     n_distinct_queries = 1 if run_as_single else len(distinct_queries)
#     if n_distinct_queries > 1:
#         return [
#             connect(
#                 sql=stmt_,
#                 driver=driver,
#                 server=server,
#                 database=database,
#                 uid=uid,
#                 pwd=pwd,
#                 do_print=do_print,
#                 do_show=do_show,
#                 do_exec=do_exec,
#                 timeout=timeout,
#                 enable_mars=enable_mars,
#                 returns_records=returns_records
#             )
#             for i, stmt_ in enumerate(distinct_queries)
#         ]
#     else:
#
#         has_insert = all([
#             any([
#                 stmt in sql.upper(),
#                 f"{stmt.rstrip()}\n" in sql.upper(),
#                 f"{stmt.rstrip()}\t" in sql.upper()
#             ])
#             for stmt in ["INSERT INTO ", "VALUES "]
#         ])
#         has_update = all([
#             any([
#                 stmt in sql.upper(),
#                 f"{stmt.rstrip()}\n" in sql.upper(),
#                 f"{stmt.rstrip()}\t" in sql.upper()
#             ])
#             for stmt in ["UPDATE ", "SET "]
#         ])
#         has_exec = all([
#             any([
#                 stmt in sql.upper(),
#                 f"{stmt.rstrip()}\n" in sql.upper(),
#                 f"{stmt.rstrip()}\t" in sql.upper()
#             ])
#             for stmt in ["EXEC "]
#         ])
#         has_delete = all([
#             any([
#                 stmt in sql.upper(),
#                 f"{stmt.rstrip()}\n" in sql.upper(),
#                 f"{stmt.rstrip()}\t" in sql.upper()
#             ])
#             for stmt in ["DELETE ", "FROM "]
#         ])
#         has_logic = all([
#             any([
#                 stmt in sql.upper(),
#                 f"{stmt.rstrip()}\n" in sql.upper(),
#                 f"{stmt.rstrip()}\t" in sql.upper()
#             ])
#             for stmt in ["IF ", "BEGIN ", "END "]
#         ])
#         has_drop = all([
#             any([
#                 stmt in sql.upper(),
#                 f"{stmt.rstrip()}\n" in sql.upper(),
#                 f"{stmt.rstrip()}\t" in sql.upper()
#             ])
#             for stmt in ["DROP TABLE "]
#         ])
#         has_select_into = all([
#             any([
#                 stmt in sql.upper(),
#                 f"{stmt.rstrip()}\n" in sql.upper(),
#                 f"{stmt.rstrip()}\t" in sql.upper()
#             ])
#             for stmt in ["SELECT ", "INTO "]
#         ])
#
#         has_delete = has_delete or has_drop
#         has_insert = has_insert or has_select_into
#
#         if returns_records is None:
#             returns_records = not any([has_insert, has_exec, has_update, has_delete])
#
#         if all([
#             n_distinct_queries == 1,
#             "SELECT" not in sql.upper(),
#             "FROM" not in sql.upper(),
#             not any([has_update, has_insert, has_exec, has_delete])
#         ]):
#             # single table name passed
#             tbl = sql.removeprefix("[").removesuffix("]")
#             sql = f"SELECT * FROM [{tbl}];"
#
#         # print(f"after {template=}")
#         df = None
#         conn, crsr = None, None
#         # print(f"\tRES\t{cstr=}, {template=}")
#         try:
#             # sql_opt = "SELECT [IT Requests].*, [dept].[Dept] AS [DeptName], [IT Personnel].[Name] AS [ITPersonnelAssignedName] FROM [IT Requests] LEFT JOIN [Dept] ON [IT Requests].[Department] = [Dept].[DeptID] LEFT JOIN [IT Personnel] ON [IT Requests].[ITPersonAssignedID] = [IT Personnel].[ITPersonID#]"
#             if do_print:
#                 print("connecting...")
#             if do_show and do_print:
#                 print(f"cstr: '{cstr}'")
#             if do_exec:
#                 conn = pyodbc.connect(cstr, timeout=timeout)
#                 crsr = conn.cursor()
#             if do_print:
#                 print("querying...")
#             if do_show:
#                 if not do_exec:
#                     print(f"NO-EXEC SQL: ", end="")
#                 print(sql)
#
#             if (not returns_records) and (has_insert or has_update or has_delete):
#                 # no return value
#                 if do_show:
#                     msg = "'returns_records' is set to False" if has_insert else ""
#                     msg += ", Insert found" if has_insert else ""
#                     msg += ", Update found" if has_insert else ""
#                     msg += ", Delete found" if has_insert else ""
#                     msg = " " + msg.strip().removeprefix(",").strip()
#                     print(f"No expected return value:{msg}.")
#                 if do_exec:
#                     crsr.execute(sql)
#                     conn.commit()
#             else:
#                 if do_exec:
#                     df = pd.DataFrame(pd.read_sql_query(sql, conn))
#
#             if do_print:
#                 print("closing...")
#             if do_exec:
#                 conn.close()
#         except (pyodbc.DatabaseError, TypeError) as e0:
#             print(f"Error_0\n{e0}")
#
#             try:
#                 if (not returns_records) and (has_insert or has_update or has_delete):
#                     if do_exec:
#                         crsr.execute(sql)
#                         conn.commit()
#                 else:
#                     if do_exec:
#                         df = pd.DataFrame(pd.read_sql(sql, conn))
#
#             except (pyodbc.DatabaseError, TypeError) as e1:
#                 print(f"Error_1\n{e1}")
#
#         # except TypeError as te:
#         #     print(f"TypeError\n{te}")
#         finally:
#             if not isinstance(df, pd.DataFrame):
#                 df = pd.DataFrame()
#         return df


if __name__ == "__main__":
    print(connect("SELECT * FROM [IT Requests]"))
    # print(connect("SELECT * FROM [IT Requests]", uid="user5"))  # error this out
    print(connect("SELECT * FROM [IT Requests]", uid="user5", pwd="M@gic456"))
    print(connect("SELECT * FROM [ClkTransaction]", database="SysproCompmanyA", uid="SRS", pwd=""))