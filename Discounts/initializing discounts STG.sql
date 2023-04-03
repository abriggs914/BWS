USE BWSdb
GO

BEGIN TRAN;

SELECT
	[ProductsV2].[IDTrailer]
	, [ProductsV2].[Model No]
	, [Class]
	, [SGQuote]
	, [ProductID]
FROM
	[OrdersV2]
LEFT JOIN
	[ProductsV2]
ON
	[ProductsV2].[Model No] = [OrdersV2].[Model No]
WHERE
	[ProductsV2].[CompanyID] = 1
ORDER BY
	[SGQuote]
;

UPDATE
	[OrdersV2]
SET
	[ProductID] = [ProductsV2].[IDTrailer]
FROM
	[OrdersV2]
LEFT JOIN
	[ProductsV2]
ON
	[ProductsV2].[Model No] = [OrdersV2].[Model No]
WHERE
	[ProductsV2].[CompanyID] = 1
;

SELECT
	[ProductsV2].[IDTrailer]
	, [ProductsV2].[Model No]
	, [Class]
	, [SGQuote]
	, [ProductID]
FROM
	[OrdersV2]
LEFT JOIN
	[ProductsV2]
ON
	[ProductsV2].[Model No] = [OrdersV2].[Model No]
WHERE
	[ProductsV2].[CompanyID] = 1
ORDER BY
	[ProductID]
;

ROLLBACK;
COMMIT;