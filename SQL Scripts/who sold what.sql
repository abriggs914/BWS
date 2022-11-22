USE BWSdb
GO

-- Who sold What
SELECT
	[Orders].[Sale PersonID],
	[Sales Staff].[Sales Person]
	,[Orders].[Delivery Date],
	*
FROM
	[Orders]
LEFT JOIN
	[Sales Staff]
ON
	[Orders].[Sale PersonID] = [Sales Staff].[ID-SaleStaff]
WHERE
	[Order Date] IS NOT NULL
	AND [Date Declined] IS NULL
ORDER BY
	[Orders].[Order Date]
;

-- Who sold how many
SELECT
	[Orders].[Sale PersonID]
	, [Sales Staff].[Sales Person]
	, COUNT(*) AS [# Sold]
FROM
	[Orders]
LEFT JOIN
	[Sales Staff]
ON
	[Orders].[Sale PersonID] = [Sales Staff].[ID-SaleStaff]
WHERE
	[Order Date] IS NOT NULL
	AND [Date Declined] IS NULL
GROUP BY
	[Orders].[Sale PersonID]
	, [Sales Staff].[Sales Person]
ORDER BY
	[Sales Person]
	, [# Sold] DESC
;

-- Who sold how many of what
SELECT
	[Orders].[Sale PersonID]
	, [Sales Staff].[Sales Person]
	, [Model No]
	, COUNT(*) AS [# Sold]
FROM
	[Orders]
LEFT JOIN
	[Sales Staff]
ON
	[Orders].[Sale PersonID] = [Sales Staff].[ID-SaleStaff]
WHERE
	[Order Date] IS NOT NULL
	AND [Date Declined] IS NULL
GROUP BY
	[Orders].[Sale PersonID]
	, [Sales Staff].[Sales Person]
	, [Model No]
ORDER BY
	[Sales Person]
	, [# Sold] DESC
	, [Model No]
;

-- Who sold how many to who
SELECT
	[Orders].[Sale PersonID]
	, [Sales Staff].[Sales Person]
	, [COMPANY NAME]
	, COUNT(*) AS [# Sold]
FROM
	[Orders]
LEFT JOIN
	[Sales Staff]
ON
	[Orders].[Sale PersonID] = [Sales Staff].[ID-SaleStaff]
LEFT JOIN
	[Dealers]
ON
	[Orders].[DealerID] = [Dealers].[ID]
WHERE
	[Order Date] IS NOT NULL
	AND [Date Declined] IS NULL
GROUP BY
	[Orders].[Sale PersonID]
	, [Sales Staff].[Sales Person]
	, [COMPANY NAME]
ORDER BY
	[Sales Person]
	, [# Sold] DESC
	, [COMPANY NAME]
;