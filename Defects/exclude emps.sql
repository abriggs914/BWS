
--USE BWSdb
--GO

--SELECT * FROM [dbo].[v_SGKnownQuotes] ORDER BY [WO#] DESC


-- exclude ali patterson

USE SysproCompanyA
GO
SELECT * FROM [ClkEmployee] WHERE LOWER([ClkEmployee].[Name]) LIKE 'son';


USE BWSdb
GO

SELECT * FROM [Employees] WHERE LOWER([Employees].[2nd Name]) LIKE 'son';