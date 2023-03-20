USE BWSdb
GO

SELECT
	*
FROM
	[ProductsV2]
ORDER BY
	[Model No] 
;

SELECT
	*
FROM
	[OrdersV2]
ORDER BY
	[SGQuote]
;

SELECT
	*
FROM
	[Custom WorkV2]
WHERE
	[SGQuote] = 'SG101123'

SELECT
	*
FROM
	[Custom WorkV2_FactoryLines]
WHERE
	[SGQuote] = 'SG101123'

SELECT
	*
FROM
	[Custom WorkV2_SpecLines]
WHERE
	[SGQuote] = 'SG101122'
ORDER BY
	[SpecSortG]
	, [SpecSortSe]