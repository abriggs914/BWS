USE SysproCompanyA
GO

SELECT
	*
FROM
	[ClkTransaction]
WHERE
	(DATEPART(YEAR, [LoggedOn]) = 2021
	AND DATEPART(MONTH, [LoggedOn]) = 9
	AND DATEPART(DAY, [LoggedOn]) = 13)
	OR (DATEPART(YEAR, [LoggedOff]) = 2021
	AND DATEPART(MONTH, [LoggedOff]) = 9
	AND DATEPART(DAY, [LoggedOff]) = 13)
ORDER BY
	[TransactionID]


USE SysproCompanyS
GO

SELECT
	*
FROM
	[ClkTransaction]
WHERE
	(DATEPART(YEAR, [LoggedOn]) = 2021
	AND DATEPART(MONTH, [LoggedOn]) = 9
	AND DATEPART(DAY, [LoggedOn]) = 13)
	OR (DATEPART(YEAR, [LoggedOff]) = 2021
	AND DATEPART(MONTH, [LoggedOff]) = 9
	AND DATEPART(DAY, [LoggedOff]) = 13)
ORDER BY
	[TransactionID]