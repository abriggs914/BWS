from pyodbc_connection import *
from utility import *

if __name__ == '__main__':

    update_query = "INSERT INTO" \
                   " [ClkTransactionNewShift]" \
                   " (" \
                   "    [ClkTransactionIDIn]," \
                   "    [ClkTransactionIDLast]," \
                   "    [IsNewShift]," \
                   "    [Parsed]," \
                   "    [Alteration]" \
                   ") VALUES ({a}, {b}, {c}, {d}, '{e}')"


