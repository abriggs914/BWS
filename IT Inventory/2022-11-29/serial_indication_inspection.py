import pandas

from inventory_queries import *
from pyodbc_connection import *


df_customers = None
df_serial_indications = None
df_locations = None
df_buildings = None
df_departments = None
df_loc_emp_bld_dpt = None


def test_1():
    if not isinstance(df_serial_indications, pandas.DataFrame):
        init()
    for i, row in df_serial_indications.iterrows():
        print(f"{i=}, {row=}")


def init():
    global df_customers, df_serial_indications, df_locations, df_buildings, df_departments, df_loc_emp_bld_dpt

    # df_customers = connect(**SQL_ITR_CUSTOMERS)
    df_serial_indications = connect(**SQL_ITI_SERIAL_INDICATION)
    # df_locations = connect(**SQL_ITI_LOCATIONS)
    # df_buildings = connect(**SQL_ITI_BUILDINGS)
    # df_departments = connect(**SQL_DEPARTMENTS)
    # df_loc_emp_bld_dpt = pandas.merge(
    #     pandas.merge(
    #         pandas.merge(
    #             df_locations,
    #             df_customers,
    #             left_on="EmployeeAssigned",
    #             how="left",
    #             right_on="CustomerID",
    #             suffixes=("_[ITI Locations]", "_[ITR Customers]")
    #         ),
    #         df_buildings,
    #         left_on="BuildingID",
    #         how="left",
    #         right_on="ID",
    #         suffixes=("_[A]", "_[ITI Buildings]")
    #     ),
    #     df_departments,
    #     how="left",
    #     left_on="Department",
    #     right_on="DeptID",
    #     suffixes=("_[B]", "_[Dept]")
    # )
    #
    # df_loc_emp_bld_dpt.rename(
    #     columns={
    #         'Name_x': 'Loc. Name',
    #         'Name': 'Bldng',
    #         'Name_y': 'Emp. Name'
    #     },
    #     inplace=True
    # )
    #
    # df_customers["TableName"] = ["ITR Customers" for _ in range(df_customers.shape[0])]
    # df_serial_indications["TableName"] = ["ITI Serial Indication" for _ in range(df_serial_indications.shape[0])]
    # df_locations["TableName"] = ["ITI Locations" for _ in range(df_locations.shape[0])]
    # df_buildings["TableName"] = ["ITI Buildings" for _ in range(df_buildings.shape[0])]
    # df_departments["TableName"] = ["Dept" for _ in range(df_departments.shape[0])]
    # df_loc_emp_bld_dpt["TableName"] = ["df_loc_emp_bld_dpt" for _ in range(df_loc_emp_bld_dpt.shape[0])]



if __name__ == '__main__':
    init()
    test_1()
