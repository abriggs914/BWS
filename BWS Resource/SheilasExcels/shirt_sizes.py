import datetime

import pandas as pd
from pyodbc_connection import connect



if __name__ == '__main__':

    file_path = r"\\nas1\public\SHEILA\CLOTHING 2021\CLOTHING SIZES November 2023 updated.xls"

    df = pd.read_excel(file_path)
    df = df.rename(columns={"Unnamed: 1": "Size", "Unnamed: 4": "Size"})
    df_assembly = df.iloc[list(range(22)), list(range(2))].rename(columns={"ASSEMBLY(Lester)": "Name"}).reset_index()
    df_engineering = df.iloc[list(range(25, 33)), list(range(2))].rename(columns={"ASSEMBLY(Lester)": "Name"}).reset_index()
    df_paint = df.iloc[list(range(36, 45)), list(range(2))].rename(columns={"ASSEMBLY(Lester)": "Name"}).reset_index()
    df_subs = df.iloc[list(range(47, 51)), list(range(2))].rename(columns={"ASSEMBLY(Lester)": "Name"}).reset_index()
    df_maintenance = df.iloc[list(range(54, 55)), list(range(2))].rename(columns={"ASSEMBLY(Lester)": "Name"}).reset_index()
    df_wip = df.iloc[list(range(58, 61)), list(range(2))].rename(columns={"ASSEMBLY(Lester)": "Name"}).reset_index()
    df_axle = df.iloc[list(range(64, 65)), list(range(2))].rename(columns={"ASSEMBLY(Lester)": "Name"}).reset_index()
    df_admin = df.iloc[list(range(68, 77)), list(range(2))].rename(columns={"ASSEMBLY(Lester)": "Name"}).reset_index()

    df_finish = df.iloc[list(range(18)), list(range(3, 5))].rename(columns={"FINISH(Rick)": "Name"}).reset_index()
    df_sub_parts = df.iloc[list(range(21, 36)), list(range(3, 5))].rename(columns={"FINISH(Rick)": "Name"}).reset_index()
    df_bom = df.iloc[list(range(39, 44)), list(range(3, 5))].rename(columns={"FINISH(Rick)": "Name"}).reset_index()
    df_sales = df.iloc[list(range(51, 57)), list(range(3, 5))].rename(columns={"FINISH(Rick)": "Name"}).reset_index()
    df_machine = df.iloc[list(range(60, 66)), list(range(3, 5))].rename(columns={"FINISH(Rick)": "Name"}).reset_index()
    df_parts_montana = df.iloc[list(range(69, 71)), list(range(3, 5))].rename(columns={"FINISH(Rick)": "Name"}).reset_index()
    df_parts_hawkins = df.iloc[list(range(74, 78)), list(range(3, 5))].rename(columns={"FINISH(Rick)": "Name"}).reset_index()
    df_purchasing = df.iloc[list(range(81, 85)), list(range(3, 5))].rename(columns={"FINISH(Rick)": "Name"}).reset_index()

    df_assembly["Department"] = 62
    df_engineering["Department"] = 32
    df_paint["Department"] = 25
    df_subs["Department"] = 19
    df_maintenance["Department"] = 63
    df_wip["Department"] = 157
    df_axle["Department"] = 68
    df_admin["Department"] = 29

    df_finish["Department"] = 97
    df_sub_parts["Department"] = 19
    df_bom["Department"] = 108
    df_sales["Department"] = 21
    df_machine["Department"] = 17
    df_parts_montana["Department"] = 34
    df_parts_hawkins["Department"] = 34
    df_purchasing["Department"] = 31

    df_ttl = pd.concat(
        [
            df_assembly,
            df_engineering,
            df_paint,
            df_subs,
            df_maintenance,
            df_wip,
            df_axle,
            df_admin,
            df_finish,
            df_sub_parts,
            df_bom,
            df_sales,
            df_machine,
            df_parts_montana,
            df_parts_hawkins,
            df_purchasing
        ]
    )

    sqls = []

    df_customers = connect("SELECT * FROM [ITR Customers];")

    # print(f"{df_assembly=}")
    # print(f"{list(df_assembly.columns)=}")
    # print(f"{df_finish=}")
    # print(f"{list(df_finish.columns)=}")

    print(f"{df_ttl=}")
    print(f"{list(df_ttl.columns)=}")
    skipped = []

    valid = {"SMALL": ["S", "SMALL"]}
    valid.update({"MEDIUM": ["M", "MED", "MEDIUM"]})
    valid.update({"LARGE": ["L", "LG", "LARGE"]})
    valid.update({"X LARGE": ["XL", "XLG", "XLARGE"]})
    valid.update({"XX LARGE": ["XXL", "XXLG", "XXLARGE"]})
    valid.update({"XXX LARGE": ["XXXL", "XXXLG", "XXXLARGE"]})
    valid.update({"XXXX LARGE": ["XXXXL", "XXXXLG", "XXXXLARGE"]})

    inv_valid = {}
    for k, vs in valid.items():
        for v in vs:
            inv_valid[v] = k
    print(f"{inv_valid=}")

    template_sql_update = f"UPDATE [ITR Customers] SET [ShirtSize] = '{{SIZE}}', [ShirtSizeDate] = '{{SIZE_DATE}}' WHERE [CustomerID] = {{CUSTID}};"

    for i, row in df_ttl.iterrows():
        size_date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        og_idx = row["index"]
        name = str(row["Name"]).lower()

        # print(f"{name=}, {pd.isna(name)=}")
        if pd.isna(row["Name"]):
            continue

        size = inv_valid[str(row["Size"]).replace(" ", "").upper()]
        df_itr_cust_id = df_customers.loc[df_customers["Name"].str.lower() == name].reset_index()

        if not df_itr_cust_id.empty:
            itr_cust_id = df_itr_cust_id.iloc[0]["CustomerID"]
            # print(f"ID: {itr_cust_id}, {name=}\t\t{size=}")
            # print(template_sql_update.format(SIZE=size, SIZE_DATE=size_date, CUSTID=itr_cust_id))
            sqls.append(template_sql_update.format(SIZE=size, SIZE_DATE=size_date, CUSTID=itr_cust_id))
        else:
            itr_cust_id = None
            skipped.append((name, size))

    template_sql_insert = f"INSERT INTO [ITR Customers] ([Name], [Company], [IsAPerson], [ShirtSize], [ShirtSizeDate], [Active]) "
    template_sql_insert += f"VALUES ('{{NAME}}', 'BWS', 1, '{{SIZE}}', '{{SIZE_DATE}}', 1);"
    print(f"\n\tSkipped")
    for name, size in skipped:
        size_date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        # print(f"{name=}, {size=}")
        # print(template_sql_insert.format(NAME=name, SIZE=size, SIZE_DATE=size_date))
        sqls.append(template_sql_insert.format(NAME=name, SIZE=size, SIZE_DATE=size_date))

    print("\n".join(sqls))

    for sql in sqls:
        connect(sql)
