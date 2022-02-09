USE SysproCompanyA
GO
--Investingating Jen's time issue

DECLARE @sd AS DATETIME;
DECLARE @ed AS DATETIME;
SET @sd = '2022-02-06'
SET @ed = '2022-02-07 23:59:59';

SELECT *  FROM [ClkTransaction] WHERE (([LoggedOn] BETWEEN @sd AND @ed) OR ([LoggedOff] BETWEEN @sd AND @ed)) ORDER BY [EmployeeName], [LoggedOn]

DECLARE @emp_list AS TABLE ([ID] INT IDENTITY(1, 1), [Emp#] REAL, [EmployeeName] NVARCHAR(MAX));

INSERT INTO @emp_list ([Emp#], [EmployeeName])
SELECT [EmployeeNumber], [EmployeeName] From [ClkTransaction] WHERE
(
	[EmployeeNumber] = 200622
	OR [EmployeeNumber] = 200623
	OR [EmployeeNumber] = 200624
	OR [EmployeeNumber] = 200114
	OR [EmployeeNumber] = 200434
)
AND (([LoggedOn] BETWEEN @sd AND @ed) OR ([LoggedOff] BETWEEN @sd AND @ed))



SELECT DISTINCT [@emp_list].[Emp#], [EmployeeName], [ShiftID] FROM @emp_list INNER JOIN [ClkShiftEmpAssign] ON [@emp_list].[Emp#] = [ClkShiftEmpAssign].[Emp#]

SELECT * FROM [ClkTransaction] WHERE [EmployeeNumber] IN (SELECT [Emp#] FROM @emp_list) AND (([LoggedOn] BETWEEN @sd AND @ed) OR ([LoggedOff] BETWEEN @sd AND @ed)) ORDER BY [EmployeeName], [LoggedOn]

EXEC [sp_ClkLabourOverride] @sd =@sd, @ed=@ed 

SELECT * FROM [ClkShiftEmpAssign] ORDER BY [Emp#]



SELECT DISTINCT [EmployeeNumber], [EmployeeName] FROM [ClkTransaction] LEFT JOIN [ClkShiftEmpAssign] ON [EmployeeNumber] = [Emp#] WHERE [Emp#] IS NULL ORDER BY [EmployeeNumber]

SELECT TOP 20 * FROM [ClkTransaction] WHERE [EmployeeNumber] = 200434 ORDER BY [LoggedOn] DESC

--BEGIN TRAN;

--SELECT * FROM [ClkShiftEmpAssign] ORDER BY [Emp#]
--SELECT DISTINCT [EmployeeNumber], [EmployeeName] FROM [ClkTransaction] LEFT JOIN [ClkShiftEmpAssign] ON [EmployeeNumber] = [Emp#] WHERE [Emp#] IS NULL ORDER BY [EmployeeNumber]

--INSERT INTO
--	[ClkShiftEmpAssign]
--([Emp#], [ShiftID])

--SELECT DISTINCT [EmployeeNumber], 1 FROM [ClkTransaction] LEFT JOIN [ClkShiftEmpAssign] ON [EmployeeNumber] = [Emp#] WHERE [Emp#] IS NULL ORDER BY [EmployeeNumber]

--SELECT * FROM [ClkShiftEmpAssign] ORDER BY [Emp#]
--SELECT DISTINCT [EmployeeNumber], [EmployeeName] FROM [ClkTransaction] LEFT JOIN [ClkShiftEmpAssign] ON [EmployeeNumber] = [Emp#] WHERE [Emp#] IS NULL ORDER BY [EmployeeNumber]

--ROLLBACK;
--COMMIT;