import os
from pyodbc_connection import connect


# Add the remaining Access DBs from server3/Production to [ADO Databases].


def test1():
    root = r"\\server3\Production"

    access_dbs_exts = [f for f in os.listdir(root) if f.endswith(".accdb") or f.endswith(".mdb")]
    access_dbs = [f.split(".")[0] for f in access_dbs_exts]

    known_dbs = connect("[ADO Databases]")
    print(f"{known_dbs=}")

    sql = f"INSERT INTO [ADO Databases] ([Name], [ServerLoc]) VALUES "
    for i, db in enumerate(access_dbs):
        print(f"{db=}")
        df1 = known_dbs.loc[known_dbs["Name"].str.lower() == db.lower()]
        print(df1)
        if known_dbs.loc[known_dbs["Name"].str.lower() == db.lower()].empty:
            sl = os.path.join(root, access_dbs_exts[i])
            sql += f"('{db}', '{sl}'),"

    sql = sql[:-1]
    print(f"\n\tSQL:\n{sql}")

    # connect(sql)

    s = "#A5C7FF"
    s = "#85B7FF"


def test2():

    # tempdb objects do not appear reachable from outside MSSQL Server

    # table = "#PracticeTable"
    table = "##PracticeTable"
    # table = "tempdb..#PracticeTable"
    stmt1 = f"SELECT * FROM {table};"
    # df1 = connect(table, database="tempdb")
    df1 = connect(stmt1)
    print(f"{df1=}")


if __name__ == '__main__':
    # test1()
    test2()
