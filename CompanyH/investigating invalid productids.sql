SELECT
	*
FROM
	[CompanyH].[dbo].[Products]
;

SELECT
	*
FROM
	[CompanyH].[dbo].[Orders]
;

SELECT
	*
FROM
	[CompanyH].[dbo].[Orders]
WHERE
	[CompanyID] = 1
;

SELECT
	[BWSdbQuoteNumber]
FROM
	[CompanyH].[dbo].[Orders]
GROUP BY
	[BWSdbQuoteNumber]
HAVING
	COUNT(*) > 1
;

-- Investigating invalid [Orders].[ProductID]
SELECT
	[CompanyID],
	[ProductID],
	COUNT(*) AS [NOrders],
	MIN([QuoteNumber]) AS [MinQuoteNumber],
	MAX([QuoteNumber]) AS [MaxQuoteNumber]
FROM
	[CompanyH].[dbo].[Orders]
GROUP BY
	[CompanyID],
	[ProductID]
ORDER BY
	[ProductID]
;


SELECT
	*
FROM
	[CompanyH].[dbo].[Orders]
WHERE
	[BWSdbQuoteNumber] = 'SG101445'

	
SELECT
	*
FROM
	[BWSdb].[dbo].[ITR Customers]
SELECT
	*
FROM
	[BWSdb].[dbo].[Employees]
ORDER BY
	--[Terminated] DESC
	(CASE WHEN [Terminated] IS NOT NULL THEN 0 ELSE 1 END)
	,[2nd Name]
	,[1st Name]
	,[Terminated] DESC
SELECT
	*
FROM
	[BWSdb].[dbo].[Employees - Salary]
SELECT
	*
FROM
	[BWSdb].[dbo].[Employees Standard Hours]