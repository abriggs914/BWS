import pandas as pd
import pyodbc


def connect(sql, driver="{SQL Server}",
            server="server3", database="BWSdb", uid="user5", pwd="M@gic456", do_print=False, do_show=False):
    template = "DRIVER={dri};SERVER={svr};DATABASE={db};UID={uid};PWD={pwd}"
    # params = [driver, server, database, uid, pwd]
    if pwd and uid is None:
        raise ValueError("Error you must pass both a username and a password. Got only a password.")
    if uid and pwd is None:
        raise ValueError("Error you must pass both a username and a password. Got only a username.")
    # print(f"before {template=}")
    cstr = template.format(dri=driver, svr=server, db=database, uid=uid, pwd=pwd)

    has_insert = all([(stmt in sql.upper()) for stmt in ["INSERT INTO ", "VALUES "]])

    # print(f"after {template=}")
    df = None
    # print(f"\tRES\t{cstr=}, {template=}")
    try:
        # sql_opt = "SELECT [IT Requests].*, [dept].[Dept] AS [DeptName], [IT Personnel].[Name] AS [ITPersonnelAssignedName] FROM [IT Requests] LEFT JOIN [Dept] ON [IT Requests].[Department] = [Dept].[DeptID] LEFT JOIN [IT Personnel] ON [IT Requests].[ITPersonAssignedID] = [IT Personnel].[ITPersonID#]"
        if do_print:
            print("connecting...")
        if do_show:
            print(f"cstr: '{cstr}'")
        conn = pyodbc.connect(cstr)
        crsr = conn.cursor()
        if do_print:
            print("querying...")
        if do_show:
            print(sql)

        if has_insert:
            crsr.execute(sql)
            conn.commit()
        else:
            df = pd.DataFrame(pd.read_sql_query(sql, conn))

        if do_print:
            print("closing...")
        conn.close()
    except pyodbc.DatabaseError as de:
        print(f"DatabaseError\n{de}")
    # except TypeError as te:
    #     print(f"TypeError\n{te}")
    finally:
        if not isinstance(df, pd.DataFrame):
            df = pd.DataFrame()
    return df


def fff():
    driver = "{SQL Server}"
    server = "server3"
    database = "BWSdb"
    uid = "user5"
    pwd = "M@gic456"
    do_print = False
    do_show = False
    template = "DRIVER={dri};SERVER={svr};DATABASE={db};UID={uid};PWD={pwd}"
    # params = [driver, server, database, uid, pwd]
    # print(f"before {template=}")
    cstr = template.format(dri=driver, svr=server, db=database, uid=uid, pwd=pwd)
    sql = 'EXEC [sp_ITREstimateLabour] @company=NULL, @department=NULL, @requestType=NULL, @requestSubType=NULL'
    df = None
    try:
        # sql_opt = "SELECT [IT Requests].*, [dept].[Dept] AS [DeptName], [IT Personnel].[Name] AS [ITPersonnelAssignedName] FROM [IT Requests] LEFT JOIN [Dept] ON [IT Requests].[Department] = [Dept].[DeptID] LEFT JOIN [IT Personnel] ON [IT Requests].[ITPersonAssignedID] = [IT Personnel].[ITPersonID#]"
        if do_print:
            print("connecting...")
        if do_show:
            print(f"cstr: '{cstr}'")
        conn = pyodbc.connect(cstr)
        cursor = conn.cursor()

        # 'D' AS [qid]
        # , NULL AS [ID]
        # , 'All' AS [Company]
        # , 'All' AS [Dept]
        # , @requestType AS [RequestType]
        # , @requestSubType AS [RequestSubType]
        # , COUNT(*) AS [  # Reqs]
        # , @ttl_requests AS [Tot Reqs]
        # , @ttl_hours_act AS [Tot Act]
        # , @ttl_hours_bud AS [Tot Bud]
        # , CAST(ROUND(100 * ((COUNT(*) + 0.0) / @ ttl_requests), 2) AS DECIMAL(16, 2)) AS [ % Ttl Reqs]
        # , SUM([LabourActual]) AS [Act]
        # , SUM([LabourEstimate]) AS [Bud]
        # , ROUND(SUM([LabourActual]) / (CASE WHEN SUM([LabourEstimate]) = 0 THEN 1 ELSE SUM([LabourEstimate]) END), 2) AS [Act / Bud]
        # , ROUND(SUM([LabourActual]) / (CASE WHEN COUNT( *) = 0 THEN 1 ELSE COUNT(*) END), 2) AS [Act / Req]
        # , ROUND(SUM([LabourEstimate]) / (CASE WHEN COUNT( *) = 0 THEN 1 ELSE COUNT(*) END), 2) AS [Bud / Req]
        # , ROUND(100 * SUM([LabourActual]) / @ ttl_hours_act, 2) AS [ % Total Act]
        # , ROUND(100 * SUM([LabourEstimate]) / @ ttl_hours_bud, 2) AS [ % Total Bud]

        # pyodbc.SQL_INTEGER
        # output_vars = [
        #     cursor.var(pyodbc.SQL_VARCHAR, size=1),  # qid
        #     cursor.var(pyodbc.SQL_INTEGER),  # id
        #     cursor.var(pyodbc.SQL_VARCHAR),  # company
        #     cursor.var(pyodbc.SQL_VARCHAR),  # department
        #     cursor.var(pyodbc.SQL_VARCHAR),  # request type
        #     cursor.var(pyodbc.SQL_VARCHAR),  # request sub type
        #     cursor.var(pyodbc.SQL_INTEGER),  # tot reqs
        #     cursor.var(pyodbc.SQL_DECIMAL),  # tot act
        #     cursor.var(pyodbc.SQL_DECIMAL),  # tot bud
        #     cursor.var(pyodbc.SQL_DECIMAL),  # % Ttl Reqs
        #     cursor.var(pyodbc.SQL_DECIMAL),  # Act
        #     cursor.var(pyodbc.SQL_DECIMAL),  # bud
        #     cursor.var(pyodbc.SQL_DECIMAL),  # act / bud
        #     cursor.var(pyodbc.SQL_DECIMAL),  # act / req
        #     cursor.var(pyodbc.SQL_DECIMAL),  # bud / req
        #     cursor.var(pyodbc.SQL_DECIMAL),  # % total act
        #     cursor.var(pyodbc.SQL_DECIMAL)  # % total bud
        # ]

        # cursor.execute(sql, output_vars)

        # for i, var in enumerate(output_vars):
        #     print(f"{i=}, {var.value=}")

        sql = """
            EXEC [sp_ITREstimateLabour]
                @company=?,
                @department=?,
                @requestType=?,
                @requestSubType=?,
                @output1=?,
                @output2=?,
                @output3=?,
                @output4=?,
                @output5=?,
                @output6=?,
                @output7=?,
                @output8=?,
                @output9=?,
                @output10=?,
                @output11=?,
                @output12=?,
                @output13=?,
                @output14=?,
                @output15=?,
                @output16=?',
                @output17=?',
                @output18=?',
                @output19=?',
                @output20=?',
                @output21=?',
                @output22=?'
        """
        company = None
        department = None
        request_type = None
        request_sub_type = None
        vals = [company, department, request_type, request_sub_type]
        for i, v in enumerate(vals):
            if v is None:
                vals[i] = "NULL"
            else:
                if not v.startswith("'"):
                    vals[i] = f"'{v}"
                if not v.endswith("'"):
                    vals[i] = f"{v}'"

        outputs = [
            cursor.execute("DECLARE @qid NVARCHAR(1);"),
            cursor.execute("DECLARE @id INTEGER;"),
            cursor.execute("DECLARE @company NVARCHAR(MAX);"),
            cursor.execute("DECLARE @company NVARCHAR(MAX);"),
            cursor.execute("DECLARE @requestType NVARCHAR(MAX);"),
            cursor.execute("DECLARE @requestSubType NVARCHAR(MAX);"),
            cursor.execute("DECLARE @requestSubType DECIMAL(14, 7);"),
            cursor.execute("DECLARE @requestSubType NVARCHAR(MAX);"),
            cursor.execute("DECLARE @totalReqs INTEGER;"),
            cursor.execute("DECLARE @totAct DECIMAL(14, 7);"),
            cursor.execute("DECLARE @totBud DECIMAL(14, 7);"),
            cursor.execute("DECLARE @pctTotReqs DECIMAL(14, 7);"),
            cursor.execute("DECLARE @act DECIMAL(14, 7);"),
            cursor.execute("DECLARE @bud DECIMAL(14, 7);"),
            cursor.execute("DECLARE @actPerBud DECIMAL(14, 7);"),
            cursor.execute("DECLARE @actPerReq DECIMAL(14, 7);"),
            cursor.execute("DECLARE @budPerReq DECIMAL(14, 7);"),
            cursor.execute("DECLARE @pctTotAct DECIMAL(14, 7);"),
            cursor.execute("DECLARE @pctTotbud DECIMAL(14, 7);")
        ]

        cursor.execute(sql, *(*vals, *outputs))

        output_vals = [
            cursor.execute("SELECT @qid;").fetchval(),
            cursor.execute("SELECT @id;").fetchval(),
            cursor.execute("SELECT @company;").fetchval(),
            cursor.execute("SELECT @company;").fetchval(),
            cursor.execute("SELECT @requestType;").fetchval(),
            cursor.execute("SELECT @requestSubType;").fetchval(),
            cursor.execute("SELECT @requestSubType;").fetchval(),
            cursor.execute("SELECT @requestSubType;").fetchval(),
            cursor.execute("SELECT @totalReqs;").fetchval(),
            cursor.execute("SELECT @totAct;").fetchval(),
            cursor.execute("SELECT @totBud;").fetchval(),
            cursor.execute("SELECT @pctTotReqs;").fetchval(),
            cursor.execute("SELECT @act;").fetchval(),
            cursor.execute("SELECT @bud;").fetchval(),
            cursor.execute("SELECT @actPerBud;").fetchval(),
            cursor.execute("SELECT @actPerReq;").fetchval(),
            cursor.execute("SELECT @budPerReq;").fetchval(),
            cursor.execute("SELECT @pctTotAct;").fetchval(),
            cursor.execute("SELECT @pctTotbud;").fetchval()
        ]

        print(f"OUTPUT VALS:")
        for i, val in enumerate(output_vals):
            print(f"{i=}, {val=}")

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
    # except TypeError as te:
    #     print(f"TypeError\n{te}")
    finally:
        if not isinstance(df, pd.DataFrame):
            df = pd.DataFrame()
    return df


def exec_labour_prediction(company=None, department=None, request_type=None, request_sub_type=None):
    vals = [company, department, request_type, request_sub_type]
    for i, v in enumerate(vals):
        if v is None:
            vals[i] = "NULL"
        else:
            if not v.startswith("'"):
                vals[i] = f"'{v}"
            if not v.endswith("'"):
                vals[i] = f"{v}'"
    sql = "EXEC [sp_ITREstimateLabour] @company={0}, @department={1}, @requestType={2}, @requestSubType={3}".format(
        *vals)
    print(f"{sql=}")
    print(f"{connect(sql)=}")
    return connect(
        sql=sql
    )


if __name__ == '__main__':
    # print(f"{exec_labour_prediction()=}")
    print(f"{fff()=}")
