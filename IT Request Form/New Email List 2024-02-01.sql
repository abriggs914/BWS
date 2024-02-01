
SELECT
	[CustomerID]
	,[C].[Company]
	,[D].[Name] AS [DepartmentName]
	,[C].[Name] AS [EmployeeName]
	,[Email]
FROM
	[ITR Customers] [C]
LEFT JOIN
	[ITD Dept] [D]
ON
	(
		CASE
			WHEN [C].[Department] IS NULL THEN 0
			WHEN CAST([C].[Department] AS NVARCHAR(MAX)) = [D].[DeptRelations] THEN 1
			WHEN [D].[DeptRelations] LIKE ('%;' + CAST([C].[Department] AS NVARCHAR(MAX))  + ';%') THEN 1
			WHEN [D].[DeptRelations] LIKE (CAST([C].[Department] AS NVARCHAR(MAX))  + ';%') THEN 1
			WHEN [D].[DeptRelations] LIKE ('%;' + CAST([C].[Department] AS NVARCHAR(MAX))) THEN 1
			ELSE 0
		END
	) = 1
WHERE
	([C].[Active] = 1)
;