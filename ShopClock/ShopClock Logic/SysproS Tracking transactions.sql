USE SysproCompanyS
GO

SELECT * FROM [ClkShiftRoundRules]

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