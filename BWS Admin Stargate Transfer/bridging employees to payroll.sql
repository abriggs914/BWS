

--SELECT * FROM [Orders]
--SELECT * FROM [OrdersV2]
--SELECT * FROM [Status]
--SELECT * FROM [Benefits]


USE BWSdb
GO


EXEC [dbo].[sp_EmployeeEmails]



-- SELECT * FROM [Employees] ORDER BY [2nd Name], [1st Name]
SELECT * FROM [Employees] ORDER BY [Emp#]
SELECT * FROM [Payroll] ORDER BY [Emp#]

USE Stargatedb
GO
-- SELECT * FROM [Employees] ORDER BY [2nd Name], [1st Name]
SELECT * FROM [Employees] ORDER BY [Emp#]
SELECT * FROM [Payroll] ORDER BY [Emp#]

BEGIN TRAN;

SELECT * FROM [Payroll] ORDER BY [Emp#]
UPDATE
	[Payroll]
SET
	[1st Name] = UPPER('Victor'),
	[2nd Name] = UPPER('Davies')
WHERE
	[Emp#] = 300098
	
SELECT * FROM [Payroll] ORDER BY [Emp#]
ROLLBACK;
COMMIT;

--SELECT * FROM [Status]
--SELECT * FROM [Benefits]
--SELECT * FROM [Production Days]
--SELECT * FROM [v_HourlyManagers]
--SELECT * FROM [Payroll]


BEGIN TRAN;

SELECT * FROM [Payroll] ORDER BY [Emp#]
SELECT * FROM [Payroll] WHERE [Date] = '2021-11-19' ORDER BY [Emp#]

DELETE FROM
	[Payroll]
WHERE
	[Date] = '2021-11-19'
	
SELECT * FROM [Payroll] WHERE [Date] = '2021-11-19' ORDER BY [Emp#]
SELECT * FROM [Payroll] ORDER BY [Emp#]

ROLLBACK;

COMMIT;

BEGIN TRAN;

SELECT * FROM [Employees] ORDER BY [Emp#]
SELECT * FROM [Employees] WHERE [Date Hired] = '2021-11-19' ORDER BY [Emp#]

DELETE FROM
	[Employees]
WHERE
	[Date Hired] = '2021-11-19'
	
SELECT * FROM [Employees] WHERE [Date Hired] = '2021-11-19' ORDER BY [Emp#]
SELECT * FROM [Employees] ORDER BY [Emp#]

ROLLBACK;
COMMIT;
