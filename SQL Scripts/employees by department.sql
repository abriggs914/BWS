USE BWSdb

SELECT * FROM Department
SELECT * FROM Dept
SELECT
	[Dept].[Dept],
	[Dept].[Position],
	*
FROM
	[Employees]
INNER JOIN
	[Dept]
ON
	[Dept].[DeptID] = [Employees].[Dept]
ORDER BY
	[Date Hired]