from pyodbc_connection import connect
from itertools import combinations


def date_first(msg: str, keyword="date") -> str:
    lmsg = msg.lower()
    if keyword in msg:
        idx = msg.index(keyword)
        if msg[idx - 2 : idx].lower() != "up":
            msg = f"Date{msg[:idx]}{msg[idx + len(keyword):]}"
    # print(f"RETURNED MESSAGE '{msg=}'")
    return msg


def parse_connection_data(data: dict) -> dict:

    valid_ = {
        "bwsdb": {
            "uid": "user5",
            "pwd": "M@gic456"
        },
        "stargatedb": {
            "uid": "SGeu1",
            "pwd": "Pupplies-Hagard->Rio0"
        }
    }

    if isinstance(data, dict):
        server = data.get("server", "SERVER3").lower()
        database = data.get("database", "BWSdb").lower()
        uid = data.get("uid", valid_[database].get("uid", None))
        pwd = data.get("pwd", valid_[database].get("pwd", None))

        r_uid = valid_[database]["uid"]
        r_pwd = valid_[database]["pwd"]

        if (uid == r_uid) and (pwd == r_pwd):
            return {
                "server": server,
                "database": database,
                "uid": uid,
                "pwd": pwd
            }

    return dict()


def select_with_alias(
        table: str | list | tuple,
        alias: str | None = None,
        prefix: str | None = None,
        f_keys: list | tuple | dict = None,
        no_spaces: bool = True,
        specials_replace: bool = True,
        do_print: bool = False,
        connection_data: dict | None = None,
        with_no_locks: bool = True
) -> str:

    l_table_names = []
    l_table_alias = []
    l_alias = []
    l_keys = []
    l_cds = []

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
                combos_sub = list(combinations(range(lk), i))
                combos += combos_sub

            for combo in combos:
                new_key = k
                for ci in combo:
                    new_key = new_key[:ci] + k[ci].upper() + new_key[ci + 1:]
                # print(f"{k=}, {new_key=}, {combo=}")
                specials[new_key] = val

    # tables = [
    #     # ("Order Options", "OO", "OrderOptions"),
    #     # ("Custom Work", "CW", "CustomWork_"),
    #     # ("Order OptionsV2", "OO2", "OrderOptionsV2"),
    #     # ("Custom WorkV2", "CW2", "CustomWorkV2_"),
    #     # ("WipMaster", "W", "WipMaster_")
    #     # ("WipMaster", "W", "WipMaster_")
    #     ("dtProductionSchedule", "dt2", "dtProdSched_")
    # ]

    if not table:
        raise ValueError(f"'table' can't be None or empty")
    else:
        if not alias:
            if not isinstance(table, (tuple, list)):
                raise ValueError(f"'alias' can't be None or empty string")
        else:
            if not prefix:
                raise ValueError(f"'prefix' can't be None or empty string")
            else:
                prefix = alias

    if not isinstance(table, (list, tuple)):
        tables = [(table, alias, prefix)]
    else:
        tables = table

    # print(f"-A {type(f_keys)=}, {f_keys=}")
    # if isinstance(f_keys, (list, tuple)):
    #     print(f"-B")
    #     if f_keys:
    #         print(f"-C {f_keys[0]=}")
    #         # if not isinstance(f_keys[0], (list, tuple)):
    #         print(f"{len(tables)=}")
    #         f_keys = [f_keys for _ in range(len(tables))]
    #         print(f"{len(f_keys)=}")
    if f_keys is not None:
        if isinstance(f_keys, (list, tuple)) and isinstance(f_keys[0], (list, tuple)) and (len(tables) > len(f_keys)):
            # print(f"--AA")
            f_keys = list(f_keys) + [f_keys[-1] for _ in range(len(tables) - len(f_keys))]
        elif isinstance(f_keys, (list, tuple)) and (not isinstance(f_keys[0], (list, tuple))):
            # print(f"--BB")
            f_keys = [f_keys for _ in range(len(tables))]
        elif len(tables) != len(f_keys):
            # print(f"--CC")
            f_keys = list(f_keys) + [f_keys[-1] for _ in range(len(tables) - len(f_keys))]

    # print(f"{tables=}\n{f_keys=}")

    i = 0
    for tn, ta, *a in tables:
        # print(f"{a=}, {i=}, {f_keys=}")
        cd = None
        fk = (None, None, None)
        if f_keys:
            fk = f_keys[i]
        if not a:
            # no prefix | connection data | foreign key given
            a = ta
        else:
            a = a[0]
            if isinstance(a, (list, tuple)) and (len(a) > 1):
                fk = a[1]

        # print(f">> {tn=}, {ta=}, {a=}, {cd=}, {fk=}")

        l_table_names.append(tn)
        l_table_alias.append(ta)
        l_alias.append(a)
        l_keys.append(fk)
        l_cds.append(cd)
        i += 1

    select_statement = "SELECT\n"
    if do_print:
        print(select_statement)
    first = True

    re_connect = True
    if connection_data is not None:
        re_connect = False
        connection_data = parse_connection_data(connection_data)

    join_msg = ""
    cols = {}

    for tn, ta, a, cd, l_key in zip(l_table_names, l_table_alias, l_alias, l_cds, l_keys):

        if not a.endswith("_"):
            a += "_"

        # print(f"{tn=}, {ta=}, {a=}, {cd_l_keys=}")
        # cd, l_keys = cd_l_keys
        # print(f"{tn=}, {ta=}, {a=}, {cd=}, {l_key=}")

        if re_connect:
            connection_data = parse_connection_data(cd)

        # df = connect(f"""SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = N'{tn}'""", database="SysproCompanyA", uid="SRS", pwd="")
        # df = connect(f"""SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = N'{tn}'""", database="Stargatedb",
        #              uid="SGeu1", pwd="Pupplies-Hagard->Rio0")
        # df = connect(f"""SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = N'{tn}'""")
        df = connect(f"""SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = N'{tn}'""", **connection_data)
        # print(df)

        col_names = df["COLUMN_NAME"].values.tolist()

        # ,[C].[Name] AS [ITRCustomersName]
        if specials_replace:
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

        if no_spaces:
            ta = ta.replace(" ", "")
            a = a.replace(" ", "")

        # print(f"{col_names=}")

        for name in col_names:
            # print(f"{name=}")

            if name not in cols:
                cols[name] = ta

            og_name = name
            if specials_replace:
                r_word = name
                for spec in specials:
                    # print(f"2 {spec=}, {r_word=}")
                    if spec in r_word:
                        if callable(specials[spec]):
                            r_word = specials[spec](r_word, spec)
                        else:
                            r_word = r_word.replace(spec, "")
                name = r_word

            if no_spaces:
                name = name.replace(" ", "")

            result = f"\t{'' if first else ','}[{ta}].[{og_name}] AS [{a}{name}]"
            select_statement += result + "\n"
            if do_print:
                print(result)
            first = False

    select_statement += "FROM\n"
    if do_print:
        print(f"FROM")

    # print(f"{cols=}")

    msg = ""
    i = 0
    for tn, ta, a, cd, l_key in zip(l_table_names, l_table_alias, l_alias, l_cds, l_keys):
        # print(f"<< {tn=}, {ta=}, {a=}, {cd=}, {l_key=}")
        msg = f"\t[{tn}] AS [{ta}]" + (" WITH (NOLOCK)" if with_no_locks else "")
        if join_msg:
            msg += join_msg.format(OTHERTABLE=ta)
            join_msg = ""
        else:
            msg += ","
        select_statement += msg + "\n"

        if do_print:
            print(msg)
        if l_key:
            j_style, l1, l2 = l_key
            if j_style and l1 and l2:
                try:
                    table = cols[l1]
                except KeyError as ke:
                    raise KeyError(f"Invalid join column name '{l1}'")
                select_statement = select_statement.removesuffix(",\n") + "\n"
                msg = f"{j_style.upper()} JOIN"
                join_msg = f"\nON\n\t[{table}].[{l1}] = [{{OTHERTABLE}}].[{l2}]"
                select_statement += msg + "\n"
                if do_print:
                    print(msg)
        i += 1

    if join_msg:
        if (i < len(tables)) and join_msg:
            msg += join_msg.format(OTHERTABLE=ta)
            join_msg = ""
        else:
            msg += ","
        select_statement += msg + "\n"

    # print(f"BEFORE\n{select_statement=}")
    # select_statement = select_statement.removesuffix(msg + "\n")
    select_statement = select_statement.removesuffix(",\n")

    print(f"\n--" + ("#" * 120) + "\n")

    return select_statement
