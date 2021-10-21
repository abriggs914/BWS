USE BWSdb
GO
SELECT * FROM [Shifts]

--SELECT * FROM [Hours Worked] ORDER BY [DateWorked]
--SELECT * FROM [dtOvertimeYTD]


USE Stargatedb
GO
SELECT * FROM [v_EmployeeBadges]
SELECT * FROM [Shifts]
SELECT * FROM [Status]
SELECT * FROM [Employees]
SELECT * FROM [Employees - Salary]
SELECT * FROM [Hours Worked]
SELECT * FROM [Dept]
SELECT * FROM [Hours Worked] ORDER BY [DateWorked]
SELECT * FROM [dtOvertimeYTD]


sp_AbsentGraphbyDept

EXEC [dbo].[sp_WeeklyRpt] @startdate='2021-05-12', @enddate='2021-10-25';

SELECT * FROM [Employees]
SELECT * FROM [Dept]

USE SysproCompanyS
GO
SELECT * FROM [WipLabJnl]
SELECT * FROM [ClkTransaction]
