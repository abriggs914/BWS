from inventory_queries import *
from pyodbc_connection import *


if __name__ == '__main__':

    df_customers = connect(**SQL_ITR_CUSTOMERS)
    df_serial_indications = connect(**SQL_ITI_SERIAL_INDICATION)
    df_locations = connect(**SQL_ITI_LOCATIONS)
    df_buildings = connect(**SQL_ITI_BUILDINGS)

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
