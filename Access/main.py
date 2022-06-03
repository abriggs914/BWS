import pyodbc

if __name__ == "__main__":

    # This will not work on access 2007 files. they are 32 bit and the odbc driver runs 64 bit drivers.
    # Try this project again once Office 365 is rolled out.

    file_name = r"""C:\Users\ABriggs\Documents\Coding Practice\Coding_Practice\Access\TaskTracker.accdb"""
    print(f"drivers: {pyodbc.drivers()}")
    msa_drivers = [_ for _ in pyodbc.drivers() if 'ACCESS' in _.upper()]
    print(f"ms_drivers: {msa_drivers}")
    # msa_drivers = ['Microsoft Access Driver (*.mdb, *.accdb)']

    try:
        constr = r'Driver={' + msa_drivers[0] + '};DBQ=' + file_name + ';'
        print(f"constr: {constr}")
        conn = pyodbc.connect(constr)
        print("Connected to DB!")
        cursor = conn.cursor()
        cursor.execute('SELECT * FROM [Tasks]')

        for row in cursor.fetchall():
            print(row)
    except ValueError as ve:
        print(f"valueError: {ve}")
    except pyodbc.Error as pe:
        print(f"pyodbcError: {pe}")
