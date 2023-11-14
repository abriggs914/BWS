USE BWSdb
GO

SELECT
	DISTINCT [Model No]
FROM
	[ProductsV2]

BEGIN TRAN;

SELECT
	[OrdersV2].*
FROM
	[OrdersV2]
LEFT JOIN
	[ProductsV2]
ON
	[OrdersV2].[Model No] = [ProductsV2].[Model No]
WHERE
	[ProductID] IS NULL
;

UPDATE
	[OrdersV2]
SET
	[ProductID] = [IDTrailer]
FROM
	[OrdersV2]
LEFT JOIN
	[ProductsV2]
ON
	[OrdersV2].[Model No] = [ProductsV2].[Model No]
WHERE
	[ProductID] IS NULL
;

SELECT
	[OrdersV2].*
	,[ProductsV2].*
FROM
	[OrdersV2]
LEFT JOIN
	[ProductsV2]
ON
	[OrdersV2].[Model No] = [ProductsV2].[Model No]
WHERE
	[ProductID] IS NULL
;

ROLLBACK;
COMMIT;