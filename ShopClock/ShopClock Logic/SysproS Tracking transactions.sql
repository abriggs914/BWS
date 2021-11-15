USE SysproCompanyS
GO

SELECT * FROM [ClkShiftRoundRules]
SELECT TOP 200 * FROM [ClkTransaction] ORDER BY [LoggedOn] DESC
SELECT TOP 200 * FROM [ClkTransaction] WHERE [InTimeFromShopClk] IS NOT NULL OR [OutTimeFromShopClk] IS NOT NULL ORDER BY [LoggedOn] DESC

DECLARE @date_version_1 AS DATETIME;
SET @date_version_1 = '2021-11-08 10:30'
SELECT 
	[TransactionID],
	[JobNumber],
	[EmployeeNumber],
	[EmployeeName],
	[LoggedOn],
	[InTimeFromShopClk],
	[LoggedOff],
	[OutTimeFromShopClk],
	[SignedInToday]
FROM
	[ClkTransaction] WITH (NOLOCK)
WHERE
	([InTimeFromShopClk] IS NOT NULL
	OR [OutTimeFromShopClk] IS NOT NULL)
	AND ([LoggedOn] BETWEEN DATEADD(DAY, -7, GETDATE()) AND GETDATE()
		OR [LoggedOff] BETWEEN DATEADD(DAY, -7, GETDATE()) AND GETDATE())
	AND [LoggedOn] > @date_version_1