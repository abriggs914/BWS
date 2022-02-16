USE SysproCompanyA
GO
--Investingating Jen's time issue

DECLARE @sd AS DATETIME;
DECLARE @ed AS DATETIME;
SET @sd = '2022-02-12'
SET @ed = '2022-02-12 23:59:59';

SELECT *  FROM [ClkTransaction] WHERE (([LoggedOn] BETWEEN @sd AND @ed) OR ([LoggedOff] BETWEEN @sd AND @ed)) ORDER BY [EmployeeName], [LoggedOn]

DECLARE @emp_list AS TABLE ([ID] INT IDENTITY(1, 1), [Emp#] REAL, [EmployeeName] NVARCHAR(MAX));

INSERT INTO @emp_list ([Emp#], [EmployeeName])
SELECT [EmployeeNumber], [EmployeeName] From [ClkTransaction] WHERE
(
	[EmployeeNumber] = 200449
)
AND (([LoggedOn] BETWEEN @sd AND @ed) OR ([LoggedOff] BETWEEN @sd AND @ed))



SELECT DISTINCT [@emp_list].[Emp#], [EmployeeName], [ShiftID] FROM @emp_list INNER JOIN [ClkShiftEmpAssign] ON [@emp_list].[Emp#] = [ClkShiftEmpAssign].[Emp#] ORDER BY [Emp#]

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


-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------


USE SysproCompanyA
GO

BEGIN TRAN;

SELECT * FROM [ClkTransaction] WHERE [TransactionID] = 1464064

UPDATE 
	[ClkTransaction]
SET
	[InTimeFromShopClk] = '2022-02-12 12:00',
	[OutTimeFromShopClk] = '2022-02-12 18:00' 
WHERE
	[TransactionID] = 1464064

SELECT * FROM [ClkTransaction] WHERE [TransactionID] = 1464064

ROLLBACK;
COMMIT;