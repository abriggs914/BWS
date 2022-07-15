USE BWSdb
GO

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
ORDER BY
	[Orders].[Order Date]
;