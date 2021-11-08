USE SysproCompanyA
GO

BEGIN TRAN;


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
	[TransactionID] = 1444142;


UPDATE
	[ClkTransaction]
SET [LoggedOn] = '2021-11-08 11:42'
WHERE
	[TransactionID] = 1444142;

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
	[TransactionID] = 1444142;


ROLLBACK;
COMMIT;