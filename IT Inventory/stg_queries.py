import re

import pandas

from pyodbc_connection import connect


SQL_V_TOOLSANDEQUIP = {
    "sql": """SELECT TOP (1000) [Equip_num]
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
