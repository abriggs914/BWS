USE BWSdb
GO

SELECT * FROM [Defects_Print] WHERE [ReportedBy] LIKE '%Yassin%'
SELECT * FROM [Payroll] WHERE [1st Name] LIKE '%Yassin%' ORDER BY [2nd Name], [1st Name]

USE SysproCompanyA
GO

SELECT * FROM [BomEmployee] WHERE [Name] LIKE '%Yassin%' OR [Name] LIKE '%YASSIN%' ORDER BY [Name]