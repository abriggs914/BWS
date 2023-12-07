USE BWSdb
GO

SELECT
	*
FROM
	[Orders]
WHERE
	[Serial Number] LIKE '%61006900'
	OR [Serial Number] LIKE '2B955HG32%'
ORDER BY
	[Serial Number]

EXEC [sp_NewQuoteReport V3] 'SG101393', 0

SELECT
	*
FROM
	[OrdersV2]
WHERE
	[Serial Number] LIKE '%61006900'