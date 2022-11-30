from inventory_queries import *
from pyodbc_connection import *


def test_1():
    sql = """
        `   SELECT
                [ITI Locations].[Name] AS [LocationName]
                , [ITI Locations].[Description]
                , [ITI Buildings].[Name]
                , [ITI Locations].[FloorNumber]
                , [ITR Customers].[Name] AS [EmployeeAssigned]
            FROM
                [ITR Customers]
            LEFT JOIN
                [ITI Locations]
            ON
                [ITI Locations].[EmployeeAssigned] = [ITR Customers].[CustomerID]
    """
    df_3 = pd.merge(df_customers, df_locations, left_on="CustomerID", right_on="EmployeeAssigned")

    sql = """
    `   SELECT
            [ITI Locations].[Name] AS [LocationName]
            , [ITI Locations].[Description]
            , [ITI Buildings].[Name]
            , [ITI Locations].[FloorNumber]
            , [ITR Customers].[Name] AS [EmployeeAssigned]
        FROM
            [ITI Locations]
        LEFT JOIN
            [ITR Customers]
        ON
            [ITI Locations].[EmployeeAssigned] = [ITR Customers].[CustomerID]
        LEFT JOIN
            [ITI Buildings]
        ON
            [ITI Locations].[BuildingID] = [ITI Buildings].[ID]
    """
    df_4 = pd.merge(
        pd.merge(
            df_locations,
            df_customers,
            left_on="EmployeeAssigned",
            right_on="CustomerID"
        ),
        df_buildings,
        left_on="BuildingID",
        right_on="ID"
    )

    print(f"df_customers.columns {df_customers.columns}")
    print(f"df_serial_indications.columns {df_serial_indications.columns}")
    print(f"df_locations.columns {df_locations.columns}")
    print(f"df_3.columns {df_3.columns}")
    print(f"df_4.columns {df_4.columns}")

    print(df_3[["Name_x", "Name_y", "Description"]])
    print(df_4[["Name_x", "Description", "Name", "FloorNumber", "Name_y"]])


def test_2():
    table = "ITI Locations"
    row_id = 4

    print(f"{df_loc_emp_bld_dpt.columns=}")
    print(f"{df_loc_emp_bld_dpt=}")
    df_loc1 = df_serial_indications[df_serial_indications["TableName"] == table]
    print(f"serial indications 1\n{df_loc1}")
    df_loc2 = df_serial_indications[df_serial_indications["RowID"] == row_id]
    print(f"serial indications 2\n{df_loc2}")
    df_loc3 = df_serial_indications[
        (df_serial_indications["TableName"] == table) & (df_serial_indications["RowID"] == row_id)]
    print(f"serial indications 3\n{df_loc3}")
    assert isinstance(df_loc3, pandas.DataFrame)
    print(f"{list(df_loc3.items())=}")
    print(f"{list(df_loc3.iterrows())=}")
    # df_loc = df_loc_emp_bld_dpt[
    #     (df_loc_emp_bld_dpt["TableName"] == table) & (df_loc_emp_bld_dpt["RowID"] == row_id)]
    # print(f"df_loc_emp_bld_dpt\n{df_loc}")


    df_loc_emp_bld_dpt_si = pandas.merge(
        # pandas.merge(
            pandas.merge(
                pandas.merge(
                    df_locations,
                    df_customers,
                    left_on="EmployeeAssigned",
                    how="left",
                    right_on="CustomerID",
                    suffixes=("_[ITI Locations]", "_[ITR Customers]")
                ),
                df_buildings,
                left_on="BuildingID",
                how="left",
                right_on="ID",
                suffixes=("_[A]", "_[ITI Buildings]")
            ),
            df_departments,
            how="left",
            left_on="Department",
            right_on="DeptID",
            suffixes=("_[B]", "_[Dept]")
        )
        # ,
    #     df_serial_indications,
    #     how="left",
    #     left_on="TableName",
    #     right_on="TableName",
    #     suffixes=("_[C]", "_[ITI SI]")
    # )

    df_loc_emp_bld_dpt_si.rename(
        columns={
            'Name_x': 'Loc. Name',
            'Name': 'Bldng',
            'Name_y': 'Emp. Name'
        },
        inplace=True
    )
    print(f"{df_loc_emp_bld_dpt_si.columns=}")
    print(f"{df_loc_emp_bld_dpt_si=}")
    print(f"{list(df_loc_emp_bld_dpt_si.iterrows())=}")


if __name__ == '__main__':

    df_customers = connect(**SQL_ITR_CUSTOMERS)
    df_serial_indications = connect(**SQL_ITI_SERIAL_INDICATION)
    df_locations = connect(**SQL_ITI_LOCATIONS)
    df_buildings = connect(**SQL_ITI_BUILDINGS)
    df_departments = connect(**SQL_DEPARTMENTS)
    df_loc_emp_bld_dpt = pandas.merge(
        pandas.merge(
            pandas.merge(
                df_locations,
                df_customers,
                left_on="EmployeeAssigned",
                how="left",
                right_on="CustomerID",
                suffixes=("_[ITI Locations]", "_[ITR Customers]")
            ),
            df_buildings,
            left_on="BuildingID",
            how="left",
            right_on="ID",
            suffixes=("_[A]", "_[ITI Buildings]")
        ),
        df_departments,
        how="left",
        left_on="Department",
        right_on="DeptID",
        suffixes=("_[B]", "_[Dept]")
    )

    df_loc_emp_bld_dpt.rename(
        columns={
            'Name_x': 'Loc. Name',
            'Name': 'Bldng',
            'Name_y': 'Emp. Name'
        },
        inplace=True
    )

    df_customers["TableName"] = ["ITR Customers" for _ in range(df_customers.shape[0])]
    df_serial_indications["TableName"] = ["ITI Serial Indication" for _ in range(df_serial_indications.shape[0])]
    df_locations["TableName"] = ["ITI Locations" for _ in range(df_locations.shape[0])]
    df_buildings["TableName"] = ["ITI Buildings" for _ in range(df_buildings.shape[0])]
    df_departments["TableName"] = ["Dept" for _ in range(df_departments.shape[0])]
    df_loc_emp_bld_dpt["TableName"] = ["df_loc_emp_bld_dpt" for _ in range(df_loc_emp_bld_dpt.shape[0])]

    # test_1()
    test_2()
