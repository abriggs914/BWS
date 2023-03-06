USE BWSdb
GO

SELECT * FROM [Custom Work] WHERE [Description] LIKE '%none%'
SELECT * FROM [Orders] ORDER BY [Order Date] DESC;

SELECT 
	*
FROM 
	[Orders] 
INNER JOIN
	[Sales Staff]
ON
	[Orders].[Sale PersonID] = [Sales Staff].[ID-SaleStaff]
WHERE
	[Quote#] = 28745;