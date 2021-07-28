USE BWSdb
GO

SELECT
	[Dept].[DeptID],
	[Dept].[Position],
	[Dept].[Dept]
FROM
	[Dept]
ORDER BY
	[Dept].[dept];