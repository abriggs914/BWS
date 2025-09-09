import pandas as pd
from pyodbc_connection import connect


if __name__ == "__main__":

    df_old = connect("PROD_YellowTags")
    df_new = pd.read_excel(r"C:\Users\abriggs\Downloads\STARGATE WORKFLOW -JULY 07.xlsx", "Yellow Tag for Aluminum")

    new_cols = {}
    for col in df_new.columns:
        new_cols[col] = col.replace("'", "").replace('"', "").replace(" ", "_").split("**")[0].strip()
    df_new.rename(columns=new_cols, inplace=True)

    # df_old_yts = df_old.groupby(
    #     by=["StockCode", "WO"]
    # )
    # df_new_yts = df_new.groupby(
    #     by=["BWS_PART_#", "WORK_ORDER"]
    # )
    # print(df_old_yts.head())
    # print(df_new_yts.head())
    
    df_old["WO"] = df_old["WO"].astype(str, errors="ignore").apply(lambda wo: wo.split(".")[0])
    df_old["WO"] = df_old["WO"].astype(str).str.strip()
    df_new["WORK_ORDER"] = df_new["WORK_ORDER"].astype(str, errors="ignore").apply(lambda wo: wo.split(".")[0])
    df_new["WORK_ORDER"] = df_new["WORK_ORDER"].astype(str).str.strip()
    df_old["StockCode"] = df_old["StockCode"].astype(str).str.strip()
    df_new["BWS_PART_#"] = df_new["BWS_PART_#"].astype(str).str.strip()

    df_new["WORK_ORDER"] = df_new["WORK_ORDER"].replace("1007566", "10017566")
    df_new["#_NEEDED"] = df_new["#_NEEDED"].replace("ne", "1")
    df_new["#_NEEDED"] = df_new["#_NEEDED"].replace("1 set", "1")

    # Define the keys
    old_keys = df_old[["StockCode", "WO"]].drop_duplicates()
    new_keys = df_new[["BWS_PART_#", "WORK_ORDER"]].drop_duplicates()

    # Rename new keys to match old keys for comparison
    new_cols = ["StockCode", "WO"]
    new_keys.columns = new_cols

    # Perform anti-join to find records in new_keys but not in old_keys
    unmatched_keys = new_keys.merge(old_keys, on=["StockCode", "WO"], how="left", indicator=True)
    unmatched_keys = unmatched_keys[unmatched_keys["_merge"] == "left_only"].drop(columns="_merge")

    print(unmatched_keys)

    df_to_insert = df_new.merge(
        unmatched_keys,
        left_on=["BWS_PART_#", "WORK_ORDER"],
        right_on=["StockCode", "WO"],
        how="inner"
    )
    df_to_insert = df_to_insert.drop(columns=["StockCode", "WO"])
    print(df_to_insert.columns)
    print(df_to_insert)

    def row_fetch(row, col, default="NULL", default_type="str", do_wrap: bool = True, err_on_not_found: bool = True):
        if err_on_not_found:
            v = row[col]
        else:
            v = row.get(col, default)

        if pd.isna(v):
            v = default
        elif v == "nan":
            v = default

        if v != default:
            if (default_type.lower() == "str") and do_wrap:
                v = f"'{v}'"
                
        return v
    
    def any_record(lst):
        f = False
        for el in lst:
            if isinstance(el, str):
                if el.lower().replace("\"", '').replace("'", "").strip() not in ["nan", "null"]:
                    f = True
            elif not pd.isna(el):
                f = True

            if f:
                return f

    sql = "INSERT INTO [BWSdb].[dbo].[PROD_YellowTags] ([Active], [WO], [StockCode], [QtyMissing], [Notes]) VALUES\n"
    found_rows = False
    for i, row in df_to_insert.iterrows():
        found_rows = True
        wo = row_fetch(row, "WORK_ORDER")
        sc = row_fetch(row, "BWS_PART_#")
        qm = row_fetch(row, "#_NEEDED", default_type="int")
        notes = row_fetch(row, "NOTES")
        if any_record([wo, sc, qm]):
            sql = sql + f"(1, {wo}, {sc}, {qm}, {notes}),\n"
    
    sql = sql.removesuffix(",\n")

    if found_rows:
        print(sql)
