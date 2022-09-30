import datetime
import re

import pandas

from pyodbc_connection import connect


SQL_V_TOOLSANDEQUIP = {
    "sql": """SELECT [Equip_num]
      ,[Equip_Desc]
      ,[Status]
      ,[Availability]
      ,[Acquisition_date]
      ,[ModelYear]
      ,[ModelNo]
      ,[Serial_No]
      ,[Manufacturer]
      ,[Manager]
      ,[Division]
      ,[Owner]
      ,[Acquisition]
      ,[SupplierName]
      ,[Assigned_to]
      ,[Assigned_dept]
      ,[Class]
      ,[Category]
      ,[Location]
      ,[Current_location]
      ,[Warranty_date]
      ,[UsageGroup]
  FROM [uniPoint_Live].[dbo].[v_Tools&Equip]""",
    "database": "uniPoint_Live",
    "uid": "SRS",
    "pwd": ""
}


SQL_UOM = {
    "sql": """SELECT [ID]
      ,[Name]
      ,[Suffix]
  FROM [BWSdb].[dbo].[ITI UOM]""",
    "database": "BWSdb",
    "uid": "user5",
    "pwd": "M@gic456"
}


SQL_TYPE = {
    "sql": """SELECT [ID]
      ,[Name]
  FROM [BWSdb].[dbo].[ITI Type]""",
    "database": "BWSdb",
    "uid": "user5",
    "pwd": "M@gic456"
}


SQL_CONDITION = {
    "sql": """SELECT TOP (1000) [ID]
      ,[Name]
  FROM [BWSdb].[dbo].[ITI Condition]""",
    "database": "BWSdb",
    "uid": "user5",
    "pwd": "M@gic456"
}


SQL_STATUS = {
    "sql": """SELECT [ID]
      ,[Name]
  FROM [BWSdb].[dbo].[ITI Status]""",
    "database": "BWSdb",
    "uid": "user5",
    "pwd": "M@gic456"
}


SQL_WIRE = {
    "sql": """SELECT [ID]
      ,[Name]
  FROM [BWSdb].[dbo].[ITI WIRE]""",
    "database": "BWSdb",
    "uid": "user5",
    "pwd": "M@gic456"
}


SQL_NETWORK = {
    "sql": """SELECT [ID]
      ,[Name]
  FROM [BWSdb].[dbo].[ITI Network]""",
    "database": "BWSdb",
    "uid": "user5",
    "pwd": "M@gic456"
}


SQL_PERIPHERALS = {
    "sql": """SELECT [ID]
      ,[Name]
  FROM [BWSdb].[dbo].[ITI Peripherals]""",
    "database": "BWSdb",
    "uid": "user5",
    "pwd": "M@gic456"
}


SQL_COMPUTER = {
    "sql": """SELECT [ID]
      ,[Name]
  FROM [BWSdb].[dbo].[ITI Computer]""",
    "database": "BWSdb",
    "uid": "user5",
    "pwd": "M@gic456"
}


SQL_UNKNOWN = {
    "sql": """SELECT [ID]
      ,[Name]
  FROM [BWSdb].[dbo].[ITI Unknown]""",
    "database": "BWSdb",
    "uid": "user5",
    "pwd": "M@gic456"
}


SQL_INSERT_NEW_ITI_ITEM = {
    "sql": """INSERT INTO [dbo].[ITI Item]
           ([Name]
           ,[Description]
           ,[IsActive]
           ,[Condition]
           ,[Type]
           ,[SubType]
           ,[DateCreated])
     VALUES ('{n}', '{d}', {a}, {c}, {t}, {y}, '{r}');""",
    "database": "BWSdb",
    "uid": "user5",
    "pwd": "M@gic456"
}


def insert_new_item(data):
    name = data["name"]
    description = data["description"]
    is_active = data["is_active"]
    condition = data["condition"]
    ttype = data["type"]
    stype = data["sub_type"]
    date_created = datetime.datetime.now()
    sql = SQL_INSERT_NEW_ITI_ITEM["sql"].format(
        n=name,
        d=description,
        a=is_active,
        c=condition,
        t=ttype,
        y=stype,
        r=date_created.strftime("%Y-%m-%d")
    )
    database = SQL_INSERT_NEW_ITI_ITEM["database"]
    uid = SQL_INSERT_NEW_ITI_ITEM["uid"]
    pwd = SQL_INSERT_NEW_ITI_ITEM["pwd"]
    result = connect(sql=sql, database=database, uid=uid, pwd=pwd)
    assert isinstance(result, pandas.DataFrame)
    return result["UserName"].tolist()[0] if not result.empty else None


# def check_user(user_in):
#     sql = SQL_VALID_USER_COUNT_WHERE["sql"].format(u=user_in)
#     database = SQL_VALID_USER_COUNT_WHERE["database"]
#     uid = SQL_VALID_USER_COUNT_WHERE["uid"]
#     pwd = SQL_VALID_USER_COUNT_WHERE["pwd"]
#     result = connect(sql=sql, database=database, uid=uid, pwd=pwd)
#     assert isinstance(result, pandas.DataFrame)
#     return result["UserName"].tolist()[0] if not result.empty else None


if __name__ == "__main__":
    for query in [
        "SQL_V_TOOLSANDEQUIP"
    ]:
        print(f"{query}:\n{connect(**eval(query))}")
