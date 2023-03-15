import pyodbc
import pandas as pd

from pyodbc_connection import connect

sg_quote_list = [
    "SG101115",
    "SG101116"
]
sg_quote_list = ",\n".join([f"('{el}')" for el in sg_quote_list])
tt_name = f"tempdb_tempOptionsTable"
u_name = f"user5"
collate_str = f"COLLATE DATABASE_DEFAULT"

init_sql = f"""
IF OBJECT_ID('{tt_name}') IS NOT NULL BEGIN
	DROP TABLE {tt_name}
END;

GRANT CREATE TABLE TO {u_name};
	
CREATE TABLE {tt_name} (
	[Quote] NVARCHAR(MAX),
	[Model No] NVARCHAR(MAX),
	[Dealer] INT,
	[Customer] INT,
	[WO] NVARCHAR(8)
);

REVOKE CREATE TABLE ON BWSdb.* TO {u_name};

GRANT SELECT ON {tt_name} TO {u_name};
GRANT UPDATE ON {tt_name} TO {u_name};
GRANT INSERT ON {tt_name} TO {u_name};

INSERT INTO {tt_name} ([Quote]) VALUES
{sg_quote_list};

UPDATE
	{tt_name}
SET
	[Model No] = [OrdersV2].[Model No]
	, [Dealer] = [OrdersV2].[DealerID]
	, [Customer] = [OrdersV2].[CustID]
	, [WO] = [OrdersV2].[WO#]
FROM
	[OrdersV2]
WHERE
	[{tt_name}].[Quote] = [OrdersV2].[SGQuote];

SELECT * FROM {tt_name};
"""

data = {
    "Quote-Specific Selects": {
        "OrdersV2": {
            "t": "OrdersV2",
            "on": ("SGQuote", "Quote")
        },
        "DesignV2": {
            "t": "DesignV2",
            "on": ("SGQuote", "Quote")
        },
        "CustomersV2": {
            "t": "CustomersV2",
            "on": ("ID#", "Customer")
        },
        "ProductionV2": {
            "t": "ProductionV2",
            "on": ("SGQuote", "Quote")
        },
        "Order HoursV2": {
            "t": "Order HoursV2",
            "on": ("SGQuote", "Quote")
        },
        "dtProductionScheduleV2": {
            "t": "Stargatedb].[dbo].[dtProductionScheduleV2",
            "on": ("SGQuote", "Quote"),
            "db": "Stargatedb"
        }
    },
    "Quote-Specific Options": {
        "Order OptionsV2": {
            "t": "Order OptionsV2",
            "on": ("SGQuote", "Quote")
        },
        "Order OptionsV2_FactoryLines": {
            "t": "Order OptionsV2_FactoryLines",
            "on": ("SGQuote", "Quote")
        },
        "Order OptionsV2_SpecLines": {
            "t": "Order OptionsV2_SpecLines",
            "on": ("SGQuote", "Quote")
        }
    },
    "Quote-Specific NPOs": {
        "Custom WorkV2": {
            "t": "Custom WorkV2",
            "on": ("SGQuote", "Quote")
        },
        "Custom WorkV2_FactoryLines": {
            "t": "Custom WorkV2_FactoryLines",
            "on": ("SGQuote", "Quote")
        },
        "Custom WorkV2_SpecLines": {
            "t": "Custom WorkV2_SpecLines",
            "on": ("SGQuote", "Quote")
        }
    },
    "Non Quote-Specific Selects": {
        "ProductsV2": {
            "t": "ProductsV2",
            "on": ("Model No", "Model No")
        },
        "StandardsV2": {
            "t": "StandardsV2",
            "on": ("Model No", "Model No")
        },
        "Order StandardsV2": {
            "t": "Order StandardsV2",
            "on": ("SGQuote", "Quote")
        }
    },
    "Non Quote-Specific Options": {
        "OptionsV2": {
            "t": "OptionsV2",
            "on": ("Model No", "Model No")
        },
        "Budget OptionsV2": {
            "t": "Budget Options V2",
            "on": ("Model No", "Model No")
        },
        "OptionsV2_FactoryLines": {
            "t": "Options V2_FactoryLines",
            "on": ("Model No", "Model No")
        },
        "OptionsV2_SpecLines": {
            "t": "Options V2_SpecLines",
            "on": ("Model No", "Model No")
        }
    },
    "WO Specific Selects": {
        "Defects": {
            "t": "Defects",
            "on": ("WO#", "WO")
        },
        "Defects_BPF": {
            "t": "Defects_BPF",
            "on": ("WO#", "WO")
        },
        "Defects_Print": {
            "t": "Defects_Print",
            "on": ("WO#", "WO")
        },
        "Defects_Snags": {
            "t": "Defects_Snags",
            "on": ("WO#", "WO")
        }
    },
    "Syspro Selects": {
        "WipJobAllLab": {
            "t": "SysproCompanyS].[dbo].[WipJobAllLab",
            "on": ("Job", "WO"),
            "collate": (True, True),
            "db": "SysproCompanyS"
        },
        "WipJobAmendJnl": {
            "t": "SysproCompanyS].[dbo].[WipJobAmendJnl",
            "on": ("Job", "WO"),
            "collate": (True, True),
            "db": "SysproCompanyS"
        },
        "ClkTransaction": {
            "t": "SysproCompanyS].[dbo].[ClkTransaction",
            "on": ("JobNumber", "WO"),
            "collate": (True, True),
            "db": "SysproCompanyS"
        }
    }
}


def number_columns(table, section, t_name, db_name=None, user=None, pwd=None):
    global data
    sql = f"SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '{table.split('.')[-1].replace('[', '').replace(']', '')}';"

    if db_name is None and user is None and pwd is None:
        df = connect(sql=sql)
    elif db_name is not None:
        if user is None and pwd is None:
            sql = sql.replace("BWSdb", db_name)
            df = connect(sql=sql, database=db_name)
        else:
            assert user is not None, f"Error param 'user' is None."
            assert pwd is not None, f"Error param 'pwd' is None."
            sql = sql.replace("BWSdb", db_name)
            df = connect(sql=sql, database=db_name, uid=user, pwd=pwd)
    else:
        assert user is not None, f"Error param 'user' is None."
        assert pwd is not None, f"Error param 'pwd' is None."
        df = connect(sql=sql, uid=user, pwd=pwd)

    n_rows, n_cols = df.shape
    data[section][t_name]["df"] = df
    return n_rows


def exec_init_sql(do_print=True):
    # Connect to SQL Server
    server = "server3"
    database = "BWSdb"
    username = "user5"
    password = "M@gic456"
    driver = '{SQL Server}'  # or your specific ODBC driver
    cstr = f'DRIVER={driver};SERVER={server};DATABASE={database};UID={username};PWD={password}'
    cnxn = pyodbc.connect(cstr)

    if do_print:
        print(f"{cstr}\n{init_sql}")

    # raise ValueError("STOPPPPP!")

    # Execute the SQL query
    cursor = cnxn.cursor()
    df = None
    queries = [q.strip() for q in init_sql.split(";") if q.strip()]
    for i, q in enumerate(queries):
        if q:
            # print(f"Q: {q}")
            if i == (len(queries) - 1):
                df = pd.DataFrame(pd.read_sql_query(q, cnxn))
            else:
                # print(f"{i=}, e")
                cursor.execute(q)
                cursor.commit()
        # if i <= (len(queries) - 1):
        #     print(f"{i=}, c")

    cursor.close()
    cnxn.close()

    # print(f"\n\tResult from Init:\n{df}\n\n")
    return df


# Press the green button in the gutter to run the script.
if __name__ == '__main__':

    # print(f"\n\tInit:\n{init_sql}")
    df_master = exec_init_sql()

    for section, section_data in data.items():
        print(f"\n-- {section}")
        for t_name, table_data in section_data.items():
            tbl = table_data.get("t", None)
            on = table_data.get("on", None)
            collate = table_data.get("collate", None)
            db = table_data.get("db", None)
            cols = number_columns(tbl, section, t_name, db_name=db)
            nulls = ", ".join(["NULL" for _ in range(cols + 5)])
            collate_0, collate_1 = f"", f""
            if collate is not None:
                collate_0 = f" {collate_str}"
                collate_1 = f" {collate_str}"
            on_0, on_1 = f"", f""
            if on is not None:
                on_0 = f"{on[0]}"
                on_1 = f"{on[1]}"
            sql = f"""SELECT '{t_name}' AS [T], * FROM [{tbl}] INNER JOIN {tt_name} ON [{tbl}].[{on_0}]{collate_0} = [{tt_name}].[{on_1}]{collate_1}"""
            sql = f"\n{sql}\nUNION ALL\nSELECT 'PH_{t_name}' AS [T], {nulls}"
            # sql = sql.replace("\n", "\n\t")
            print(f"{sql}")
