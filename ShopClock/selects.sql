USE SysproCompanyA
GO

SELECT
	TOP 500
		[TransactionID],
		[JobNumber],
		[JobName],
		[EmployeeNumber],
		[EmployeeName],
		[LoggedOn],
		[InTimeFromShopClk],
		[LoggedOff],
		[OutTimeFromShopClk]
FROM [ClkTransaction] WHERE LEFT(CAST([EmployeeNumber] AS NVARCHAR(MAX)), 1) <> '1' ORDER BY [LoggedOn] DESC