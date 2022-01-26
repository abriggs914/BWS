USE SysproCompanyA
GO

SELECT Top 5 * FROM [ClkTransaction] ORDER BY [TransactionID] DESC

SELECT * FROM [ClkShiftRoundRules]

SELECT * FROM [ClkTransaction] WHERE [EmployeeNumber] = 200336 AND [LoggedOn] BETWEEN '2022-01-23' AND '2022-01-25' ORDER BY [TransactionID] DESC