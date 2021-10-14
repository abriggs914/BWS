USE BWSdb
GO

--SELECT * FROM [Hours Worked] ORDER BY [DateWorked]
SELECT * FROM [dtOvertimeYTD]


USE Stargatedb
GO
SELECT * FROM [dtOvertimeYTD]

EXEC [dbo].[sp_WeeklyRpt] @startdate='2021-05-12', @enddate='2021-10-25';

SELECT * FROM [Hours Worked] ORDER BY [DateWorked]
SELECT * FROM [Employees]
SELECT * FROM [Dept]

USE SysproCompanyS
GO
SELECT * FROM [WipLabJnl]
SELECT * FROM [ClkTransaction]
