

-- All missing employees from [ClkShiftEmpAssign] who have made at least 1 clkTransaction Entry.
SELECT DISTINCT [EmployeeNumber], [EmployeeName] FROM [ClkTransaction] LEFT JOIN [ClkShiftEmpAssign] ON [EmployeeNumber] = [Emp#] WHERE [Emp#] IS NULL ORDER BY [EmployeeNumber]


BEGIN TRAN;
SELECT DISTINCT [EmployeeNumber], [EmployeeName] FROM [ClkTransaction] LEFT JOIN [ClkShiftEmpAssign] ON [EmployeeNumber] = [Emp#] WHERE [Emp#] IS NULL ORDER BY [EmployeeNumber]

INSERT INTO
	[ClkShiftEmpAssign]
SELECT
	1, [EmployeeNumber]
FROM (
	SELECT DISTINCT [EmployeeNumber], [EmployeeName] FROM [ClkTransaction] LEFT JOIN [ClkShiftEmpAssign] ON [EmployeeNumber] = [Emp#] WHERE [Emp#] IS NULL
) AS [A]

SELECT DISTINCT [EmployeeNumber], [EmployeeName] FROM [ClkTransaction] LEFT JOIN [ClkShiftEmpAssign] ON [EmployeeNumber] = [Emp#] WHERE [Emp#] IS NULL ORDER BY [EmployeeNumber]

ROLLBACK:
COMMIT;

-- All missing employees from [ClkShiftEmpAssign] who have made at least 1 clkTransaction Entry.

--SELECT
--	(UPPER([2nd Name])) + ', ' + (UPPER([1st Name])) AS [EmployeeName1]
--	,'100' + RIGHT('000' + CAST([BWSdb].[dbo].[Payroll].[Emp#] AS NVARCHAR(MAX)), 3) AS [E]
--	, (CASE WHEN [Hourly/Salary] = 'Salary' THEN '200' + RIGHT('000' + CAST([BWSdb].[dbo].[Payroll].[Emp#] AS NVARCHAR(MAX)), 3) ELSE '100' + RIGHT('000' + CAST([BWSdb].[dbo].[Payroll].[Emp#] AS NVARCHAR(MAX)), 3) END) AS [EmployeeNumber1]
--	,[Hourly/Salary]
--FROM
--	[BWSdb].[dbo].[Payroll]
--LEFT JOIN 
--	[ClkShiftEmpAssign]
--ON 
--	(CASE WHEN [Hourly/Salary] = 'Salary' THEN '200' + RIGHT('000' + CAST([BWSdb].[dbo].[Payroll].[Emp#] AS NVARCHAR(MAX)), 3) ELSE '100' + RIGHT('000' + CAST([BWSdb].[dbo].[Payroll].[Emp#] AS NVARCHAR(MAX)), 3) END) = [ClkShiftEmpAssign].[Emp#]
--WHERE
--	[ClkShiftEmpAssign].[Emp#] IS NULL
--ORDER BY
--	[EmployeeName1]
----SELECT DISTINCT [EmployeeNumber], [EmployeeName] FROM [Payroll] LEFT JOIN [ClkShiftEmpAssign] ON [EmployeeNumber] = [Emp#] WHERE [Emp#] IS NULL ORDER BY [EmployeeNumber]

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [PK]
      ,[ShiftID]
      ,[Emp#]
  FROM [SysproCompanyA].[dbo].[ClkShiftEmpAssign]

  

BEGIN TRAN;
SELECT DISTINCT [EmployeeNumber], [EmployeeName] FROM [ClkTransaction] LEFT JOIN [ClkShiftEmpAssign] ON [EmployeeNumber] = [Emp#] WHERE [Emp#] IS NULL ORDER BY [EmployeeNumber]

INSERT INTO
	[ClkShiftEmpAssign]
SELECT
	1, 200630


SELECT DISTINCT [EmployeeNumber], [EmployeeName] FROM [ClkTransaction] LEFT JOIN [ClkShiftEmpAssign] ON [EmployeeNumber] = [Emp#] WHERE [Emp#] IS NULL ORDER BY [EmployeeNumber]

ROLLBACK:
COMMIT;