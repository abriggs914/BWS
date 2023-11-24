USE BWSdb
GO

SELECT
	*
FROM
	[OrdersV2]
WHERE
	[SGQuote] = 'SG101395'
;

SELECT
	*
FROM
	[ProductsV2]
LEFT JOIN
	[OrdersV2]
ON
	[ProductsV2].[Model No] = [OrdersV2].[Model No]
WHERE
	[SGQuote] = 'SG101395'
;