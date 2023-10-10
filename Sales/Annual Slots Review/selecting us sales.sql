USE BWSdb
GO

SELECT
	CAST([Price] AS DECIMAL(18, 6))
	, [Quote Date]
	, [Quote#]
	, [Model No]
	, [Price]
	, [US Sale]
FROM
	[Orders]
ORDER BY
	[Model No]
	, [Quote Date]

SELECT
	SUM(CAST([Price] AS DECIMAL(18, 6)))
FROM
	[Orders]


SELECT
	* 
FROM
	[DealersV2]
WHERE
	[CURRENT DEALER] = 1
	AND [CompanyID] = 1
ORDER BY
	[COMPANY NAME]