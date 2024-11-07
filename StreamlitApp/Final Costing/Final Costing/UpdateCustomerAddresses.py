from pyodbc_connection import connect
import pandas as pd


if __name__ == '__main__':

    null = "NULL"
    excel_customers_20241104 = r"U:\Quick files\Junk\2024-11-04T20-25_export.xlsx"
    excel_customers = "U:\Quick files\Junk\Customers_202411071922.xlsx"
    df_0: pd.DataFrame = pd.read_excel(excel_customers)
    df_1: pd.DataFrame = pd.read_excel(excel_customers_20241104)

    df_1 = df_1[["WO#", "strAddress", "latitude", "longitude"]]
    df = df_0.merge(df_1, on="WO#")

    print(f"{df.head()}")
    print(f"{df.columns.to_list()}")

    sql_statements: str = ""

    in_sql = f"\nINSERT INTO [BWSdb].[dbo].[Customers] ("
    in_sql += f"[WO#], [Customer], [Address], "
    in_sql += f"[City], [Province/State], [Postal Code/ZIP] "
    in_sql += f"[Phone], [Cell], [Email] "
    in_sql += f"[Contact], [Notes], [Claim Number] "
    in_sql += f"[Quote#], [Fax], [ShippedAddressString] "
    in_sql += f"[ShippedLatitude], [ShippedLongitude]) VALUES "
    sql_statements += f"{in_sql}\n"
    j = 0
    for i, row in df.iterrows():
        wo: int = row["WO#"]
        customer: str = row["Customer"]
        address: str = row["Address"]
        city: str = row["City"]
        province: str = row["Province/State"]
        postal: str = row["Postal Code/ZIP"]
        phone: str = row["Phone"]
        cell: str = row["Cell"]
        email: str = row["Email"]
        contact: str = row["Contact"]
        notes: str = row["Notes"]
        claim: int = row["Claim Number"]
        quote: int = row["Quote#"]
        fax: int = row["Fax"]
        ship_lat: float = row["latitude"]
        ship_long: float = row["longitude"]
        ship_addr: str = row["strAddress"]

        if pd.isna(customer):
            customer = null
        else:
            customer = "'" + f"{customer}".replace("'", "''") + "'"
        if pd.isna(address):
            address = null
        else:
            address = "'" + f"{address}".replace("'", "''") + "'"
        if pd.isna(city):
            city = null
        else:
            city = "'" + f"{city}".replace("'", "''") + "'"
        if pd.isna(province):
            province = null
        else:
            province = "'" + f"{province}".replace("'", "''") + "'"
        if pd.isna(postal):
            postal = null
        else:
            postal = "'" + f"{postal}".replace("'", "''") + "'"
        if pd.isna(phone):
            phone = null
        else:
            phone = "'" + f"{phone}".replace("'", "''") + "'"
        if pd.isna(cell):
            cell = null
        else:
            cell = "'" + f"{cell}".replace("'", "''") + "'"
        if pd.isna(email):
            email = null
        else:
            email = "'" + f"{email}".replace("'", "''") + "'"
        if pd.isna(contact):
            contact = null
        else:
            contact = "'" + f"{contact}".replace("'", "''") + "'"
        if pd.isna(notes):
            notes = null
        else:
            notes = "'" + f"{notes}".replace("'", "''") + "'"
        if pd.isna(ship_addr):
            ship_addr = null
        else:
            ship_addr = "'" + f"{ship_addr}".replace("'", "''") + "'"
        if pd.isna(fax):
            fax = null
        if pd.isna(claim):
            claim = null
        if pd.isna(quote):
            quote = null
        if pd.isna(ship_lat):
            ship_lat = null
        if pd.isna(ship_long):
            ship_long = null

        if not any([pd.isna(wo), pd.isna(ship_lat), pd.isna(ship_long)]):
            if j == 1999:
                sql_statements = sql_statements.removesuffix(",\n") + "\n"
                sql_statements += f"{in_sql}\n"
                j = 0
            sql = f"({wo}, {customer}, {address}, "
            sql += f"{city}, {province}, {postal}, "
            sql += f"{phone}, {cell}, {email}, "
            sql += f"{contact}, {notes}, {claim}, "
            sql += f"{quote}, {fax}, {ship_lat}, "
            sql += f"{ship_long}, {ship_addr}),"
            sql_statements += f"{sql}\n"
            j += 1

    sql_statements = sql_statements.removesuffix(",\n") + "\n"

    print(f"{sql_statements}")
    with open(r"C:\Access\InsertCustomerAddresses_BWS.sql", "w") as f:
        f.write(f"BEGIN TRAN;\n")
        f.write(sql_statements)
        f.write(f"\nROLLBACK;")
        f.write(f"\nCOMMIT;")

    # for i, row in df_1.iterrows():
    #     wo: int = row["WO#"]
    #     addr: str = row["strAddress"].replace("'", "''")
    #     lat: float = row["latitude"]
    #     long: float = row["longitude"]
    #     if not any([pd.isna(wo), pd.isna(addr), pd.isna(lat), pd.isna(long)]):
    #         lat = round(lat, 6)
    #         long = round(long, 6)
    #         sql = f"UPDATE [BWSdb].[dbo].[Customers] SET"
    #         sql += f" [ShippedLatitude] = {lat},"
    #         sql += f" [ShippedLongitude] = {long},"
    #         sql += f" [ShippedAddressString] = '{addr}'"
    #         sql += f" WHERE [WO#] = {wo}"
    #         statements.append(sql)
    #
    # print(";\n".join(statements) + ";")
    # with open(r"C:\Access\UpdateCustomerAddresses_BWS.sql", "w") as f:
    #     f.write(f"BEGIN TRAN;\n")
    #     f.write(";\n".join(statements) + ";")
    #     f.write(f"\nROLLBACK;")
    #     f.write(f"\nCOMMIT;")
