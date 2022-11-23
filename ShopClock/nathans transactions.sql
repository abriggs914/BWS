USE SysproCompanyA
GO

SELECT
	* 
FROM 
	[ClkTransaction]
WHERE
	[LoggedOn] BETWEEN DATEADD(DAY, -1, GETDATE()) AND GETDATE()
	AND [EmployeeNumber] = '200434'
ORDER BY
	[LoggedOn] DESC