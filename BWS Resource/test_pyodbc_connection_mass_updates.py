from pyodbc_connection import connect


def test1():
    table = "[IT Requests]"
    w_cond_all = "[ITRequestID#] < 100"
    stmt_tmpl_write = f"UPDATE {table} SET [CancellationReason] = 'TESTING MASS UPDATE ' + CAST(GETDATE() AS NVARCHAR(MAX)) WHERE {w_cond_all};"
    stmt_tmpl_clear = f"UPDATE {table} SET [CancellationReason] = NULL WHERE {w_cond_all};"
    stmt_tmpl = f"UPDATE {table} SET [CancellationReason] = 'TESTING MASS UPDATE ' + CAST(GETDATE() AS NVARCHAR(MAX)) WHERE [ITRequestID#] = {{IDNUM}};"
    # connect(stmt_tmpl_write)
    # connect(stmt_tmpl_clear)
    #
    stmts = ""
    for i in range(1, 100):
        stmts += stmt_tmpl.format(IDNUM=i) + "\n"
    print(f"{stmts}")
    connect(stmts)


if __name__ == '__main__':
    test1()
