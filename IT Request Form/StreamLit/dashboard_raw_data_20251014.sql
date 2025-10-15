SELECT
	[ITR].*,
	[ITC].[CustomerID] AS [RequestByID],
	[Dept].[Dept]
FROM
	[BWSdb].[dbo].[IT Requests] [ITR]
LEFT JOIN
	[BWSdb].[dbo].[IT Personnel] [ITP]
ON
	[ITR].[ITPersonAssignedID] = [ITP].[ITPersonID#]
LEFT JOIN
	[BWSdb].[dbo].[ITR Customers] [ITC]
ON
	LOWER([ITR].[RequestedBy]) = LOWER([ITC].[Name])
LEFT JOIN (
	SELECT
        MIN([Dept].[DeptID]) AS [MinOfDeptID],
        [Dept].[Dept]
    FROM
        [BWSdb].[dbo].[Dept] 
    GROUP BY
        [Dept].[Dept]
    HAVING
        [Dept].[Dept] <> ''
) AS [Dept]
ON
	[ITR].[Department] = [Dept].[MinOfDeptID]


SELECT
	SUM([LabourActual])
FROM
	[BWSdb].[dbo].[IT Requests] [ITR]
LEFT JOIN
	[BWSdb].[dbo].[IT Personnel] [ITP]
ON
	[ITR].[ITPersonAssignedID] = [ITP].[ITPersonID#]
LEFT JOIN
	[BWSdb].[dbo].[ITR Customers] [ITC]
ON
	LOWER([ITR].[RequestedBy]) = LOWER([ITC].[Name])
LEFT JOIN (
	SELECT
        MIN([Dept].[DeptID]) AS [MinOfDeptID],
        [Dept].[Dept]
    FROM
        [BWSdb].[dbo].[Dept] 
    GROUP BY
        [Dept].[Dept]
    HAVING
        [Dept].[Dept] <> ''
) AS [Dept]
ON
	[ITR].[Department] = [Dept].[MinOfDeptID]
WHERE
	[Dept] = 'Administration'