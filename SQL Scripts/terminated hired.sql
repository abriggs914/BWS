USE SysproCompanyA
GO

SELECT 
	* 
FROM
	[ClkEmployee] 
LEFT JOIN
	[BWSdb].[dbo].[Employees] AS [A]
ON
	[ClkEmployee].[Employee] = CAST([A].[Emp#] AS NVARCHAR(MAX))
ORDER BY
	[TimeStamp] DESC
	
SELECT 
	* 
FROM
	[BWSdb].[dbo].[Employees - Salary]
ORDER BY
	[Terminated] DESC
	,[Date Hired] DESC
SELECT 
	* 
FROM
	[BWSdb].[dbo].[Employees]
ORDER BY
	[Terminated] DESC
	,[Date Hired] DESC
--	[TimeStamp] DESC
