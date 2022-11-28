USE SysproCompanyA
GO

SELECT * FROM [ClkTransaction] WHERE [LoggedOn] BETWEEN DATEADD(DAY, -4, GETDATE()) AND GETDATE() AND RIGHT([EmployeeNumber], 3) IN ('675', '646', '524', '651') ORDER BY [LoggedOff]
SELECT * FROM [ClkTransaction] WHERE [LoggedOn] BETWEEN DATEADD(DAY, -4, GETDATE()) AND GETDATE() AND RIGHT([EmployeeNumber], 3) IN ('100') ORDER BY [LoggedOff]