import itertools
import sys

from pyodbc_connection import connect


def date_first(msg: str, keyword="date") -> str:
    lmsg = msg.lower()
    if keyword in msg:
        idx = msg.index(keyword)
        if msg[idx - 2 : idx].lower() != "up":
            msg = f"Date{msg[:idx]}{msg[idx + len(keyword):]}"
    # print(f"RETURNED MESSAGE '{msg=}'")
    return msg


if __name__ == '__main__':
    # # # print(sys.argv)
    # #
    # # # table_name = "ITR Customers"
    # # # table_alias = "C"
    # # # alias = "ITRCustomers"
    # # #
    # # # table_name = "IT Personnel"
    # # # table_alias = "P"
    # # # alias = "ITPersonnel"
    # #
    # # table_name = "v_SFC_BWSUnionSTGOrders"
    # # table_alias = "UO"
    # # alias = "Orders"
    # #
    # # df = connect(f"""SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = N'{table_name}'""")
    # # # print(df)
    # #
    # # col_names = df["COLUMN_NAME"].values.tolist()
    # #
    # # # ,[C].[Name] AS [ITRCustomersName]
    # # for name in col_names:
    # #     print(f",[{table_alias}].[{name}] AS [{alias}{name}]")
    #
    # table_name = "v_SFC_BWSUnionSTGOrders"
    # table_alias = "UO"
    # alias = "Orders"
    #
    # table_name = "WipMaster"
    # table_alias = "W"
    # alias = "WipMaster"
    #
    l_table_names = []
    l_table_alias = []
    l_alias = []

    NO_SPACES = True
    SPECIALS_REPLACE = True

    specials = {
        "#": "Num",
        "%": "Pctg",
        "$": "Dollars",
        "?": "",
        "/": "",
        "date": date_first
    }
    og_keys = list(specials.keys())

    for k in og_keys:
        val = specials[k]

        if (lk := len(k)) > 1:
            combos = []
            for i in range(lk + 1):
                combos_sub = list(itertools.combinations(range(lk), i))
                combos += combos_sub

            for combo in combos:
                new_key = k
                for ci in combo:
                    new_key = new_key[:ci] + k[ci].upper() + new_key[ci + 1:]
                # print(f"{k=}, {new_key=}, {combo=}")
                specials[new_key] = val
    #
    # tables = [
    #     ("Orders", "O", "Orders_"),
    #     ("Dealers", "D", "Dealers_"),
    #     ("Products", "P", "Products_")
    # ]
    #
    # # tables = [
    # #     ("OrdersV2", "O2", "OrdersV2_"),
    # #     ("DealersV2", "D2", "DealersV2_"),
    # #     ("ProductsV2", "P2", "ProductsV2_")
    # # ]
    # #
    # # tables = [
    # #     ("Sales Staff", "SS", "SalesStaff_")
    # # ]
    # #
    # # tables = [
    # #     ("SorMaster", "SO", "SorMaster_")
    # # ]
    # #
    # # tables = [
    # #     ("v_SFC_BWSUnionSTGOrders", "O", "")
    # # ]

    tables = [
        #("Order Options", "OO", "OrderOptions"),
        #("Custom Work", "CW", "CustomWork_"),
        #("Order OptionsV2", "OO2", "OrderOptionsV2"),
        #("Custom WorkV2", "CW2", "CustomWorkV2_"),
		#("WipMaster", "W", "WipMaster_")
		#("WipMaster", "W", "WipMaster_")
		("dtProductionSchedule", "dt2", "dtProdSched_")
    ]

    for tn, ta, a in tables:
        l_table_names.append(tn)
        l_table_alias.append(ta)
        l_alias.append(a)

    print(f"SELECT\n\t")
    first = True

    for tn, ta, a in zip(l_table_names, l_table_alias, l_alias):

        # df = connect(f"""SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = N'{tn}'""", database="SysproCompanyA", uid="SRS", pwd="")
        df = connect(f"""SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = N'{tn}'""", database="Stargatedb", uid="SGeu1", pwd="Pupplies-Hagard->Rio0")
        # df = connect(f"""SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = N'{tn}'""")
        # print(df)

        col_names = df["COLUMN_NAME"].values.tolist()

        # ,[C].[Name] AS [ITRCustomersName]
        if SPECIALS_REPLACE:
            spec_results = []
            for word in [ta, a]:
                # l_word = word.lower()
                r_word = word
                for spec in specials:
                    # print(f"1 {spec=}, {r_word=}")
                    if spec in r_word:
                        if callable(specials[spec]):
                            r_word = specials[spec](r_word)
                        else:
                            r_word = r_word.replace(spec, "")
                spec_results.append(r_word)
            ta, a = spec_results

        if NO_SPACES:
            ta = ta.replace(" ", "")
            a = a.replace(" ", "")

        for name in col_names:
            og_name = name
            if SPECIALS_REPLACE:
                r_word = name
                for spec in specials:
                    # print(f"2 {spec=}, {r_word=}")
                    if spec in r_word:
                        if callable(specials[spec]):
                            r_word = specials[spec](r_word, spec)
                        else:
                            r_word = r_word.replace(spec, "")
                name = r_word

            if NO_SPACES:
                name = name.replace(" ", "")

            result = f"\t{'' if first else ','}[{ta}].[{og_name}] AS [{a}{name}]"
            print(result)
            first = False

    print(f"FROM")
    for tn, ta, a in zip(l_table_names, l_table_alias, l_alias):
        print(f"\t[{tn}] AS [{ta}]")

