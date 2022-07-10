USE BWSdb
GO

SELECT TOP 2500
	*
FROM
	[Orders]
WHERE
	[Quote Date] IS NOT NULL
ORDER BY
	[Quote Date] DESC

SELECT * FROM [Sales Staff]

SELECT TOP 2500
	[Sales Person], [Dealers].[COMPANY NAME], [Orders].*
FROM
	[ORDERS]
INNER JOIN
	[Sales Staff]
ON
	[Sales Staff].[ID-SaleStaff] = [Orders].[Sale PersonID]
INNER JOIN
	[Dealers]
ON 
	[Dealers].ID = [Orders].[DealerID]
WHERE
	[Quote Date] IS NOT NULL
ORDER BY
	[Quote Date] DESC