
from pyodbc_connection import connect


SQL_BWS_EMPLOYEE_LIST = {
    "sql": """SELECT
	[StaffID#]
	,[Emp#]
	,[2nd Name]
	,[1st Name]
	,[Employees].[Dept] AS [DeptID]
	,[Dept].[Dept]
	,[Date Hired]
	,[DOB]
FROM
	[Employees]
LEFT JOIN
	[Dept]
ON
	[Employees].[Dept] = [Dept].[DeptID]
WHERE
	[Terminated] IS NULL

UNION ALL

SELECT
	[StaffID#]
	,[Emp#]
	,[2nd Name]
	,[1st Name]
	,[Employees - Salary].[Dept] AS [DeptID]
	,[Dept].[Dept]
	,[Date Hired]
	,[DOB]
FROM
	[Employees - Salary]
LEFT JOIN
	[Dept]
ON
	[Employees - Salary].[Dept] = [Dept].[DeptID]
WHERE
	[Terminated] IS NULL

ORDER BY
	[2nd Name]
	,[1st Name]
;""",
    "database": "BWSdb",
    "uid": "user5",
    "pwd": "M@gic456"
}


if __name__ == "__main__":
    for query in [
        "SQL_BWS_EMPLOYEE_LIST"
    ]:
        print(f"{query}:\n{connect(**eval(query))}")
