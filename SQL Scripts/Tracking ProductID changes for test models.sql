USE BWSdb
GO

SELECT
	*
FROM
	[OrdersV2]
WHERE
	[SGQuote] = 'SG101478'


SELECT
	*
FROM
	[ProductsV2]
INNER JOIN
	[OrdersV2]
ON
	[ProductsV2].[Model No] = [OrdersV2].[Model No]
WHERE
	[SGQuote] = 'SG101478'

	
SELECT
	*
FROM
	[ProductsV2]
WHERE
	[Model No] = 'BTL4X'
	OR [IDTrailer] IN (637, 652)
	OR [IDTrailer] IN (655, 653)