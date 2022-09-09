USE BWSdb
GO

SELECT
	* 
FROM
	[OrdersV2]
LEFT JOIN
	[ProductionV2] 
ON
	[OrdersV2].[SGQuote] = [ProductionV2].[SGQuote] 
WHERE
	[Prod Date] IS NULL 
	AND [Prod Date2] IS NULL
	AND [OrdersV2].[Order Date] IS NOT NULL