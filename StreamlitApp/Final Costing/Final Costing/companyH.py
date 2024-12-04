from sql_utility import *


if __name__ == '__main__':
    print(create_sql("Orders", database="CompanyH"))
    print(select_with_alias(
        table="Orders",
        alias="O",
        prefix="O",
        connection_data={
            "database": "CompanyH"
        }
    ))
    print(select_with_alias(
        table="Products",
        alias="P",
        prefix="P",
        connection_data={
            "database": "CompanyH"
        }
    ))
