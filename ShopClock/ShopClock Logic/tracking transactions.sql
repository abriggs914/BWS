USE SysproCompanyA
GO


SELECT 
	TOP 200 *
FROM
	[ClkTransaction] WITH (NOLOCK)
ORDER BY
	[LoggedOn] DESC

SELECT 
	TOP 200 *
FROM
	[ClkTransaction] WITH (NOLOCK)
ORDER BY
	[LoggedOff] DESC



SELECT
	TOP 200 *
FROM
	[ClkTransaction] WITH (NOLOCK)
WHERE
	[InTimeFromShopClk] IS NOT NULL
	OR [OutTimeFromShopClk] IS NOT NULL
ORDER BY
	[LoggedOn] DESC,
	[LoggedOff] DESC

SELECT 
	[TransactionID],
	[JobNumber],
	[EmployeeNumber],
	[EmployeeName],
	[LoggedOn],
	[InTimeFromShopClk],
	[LoggedOff],
	[OutTimeFromShopClk]
FROM
	[ClkTransaction] WITH (NOLOCK)
WHERE
	[InTimeFromShopClk] IS NOT NULL
	OR [OutTimeFromShopClk] IS NOT NULL


--SELECT 
--	[TransactionID],
--	[JobNumber],
--	[EmployeeNumber],
--	[EmployeeName],
--	[LoggedOn],
--	[InTimeFromShopClk],
--	[LoggedOff],
--	[OutTimeFromShopClk]
--FROM
--	[ClkTransaction] WITH (NOLOCK)
--WHERE
--	[InTimeFromShopClk] IS NOT NULL
--	OR [OutTimeFromShopClk] IS NOT NULL
--	AND 1 = (CASE WHEN [OutTimeFromShopClk] IS NULL THEN 0 WHEN RIGHT(CAST([OutTimeFromShopClk] AS NVARCHAR(MAX)), 1) = '5' END)