USE BWSdb
GO

SELECT
	[O].[SGQuote]
	,[O].[Quote Date]
	,[O].[Order Date]
	,[O].[WO#]
	,[O].[Model No]
	--,[O].[Sale PersonID]
	,[S].[Sales Person]
	,[O].[Price]
	,[O].[Serial Number]
	,[O].[Available Date]
	,[O].[Delivery Date]
	,[O].[Requested Delivery Date]
	--,[O].[DealerID]
	,[D].[COMPANY NAME] AS [Dealer]
	,(CASE WHEN [O].[US Sale] = 1 THEN 'Y' ELSE 'N' END) AS [US Sale]
	,[O].[Notes]
FROM
	[OrdersV2] AS [O]
LEFT JOIN
	[DealersV2] AS [D]
ON
	[O].[DealerID] = [D].[ID]
LEFT JOIN
	[Sales Staff] AS [S]
ON
	[O].[Sale PersonID] = [S].[ID-SaleStaff]
WHERE
	([Delivery Date] >= '2023-04-01'
	OR [Requested Delivery Date] >= '2023-04-01')
	AND [Date Declined] IS NULL
ORDER BY
	ISNULL([Delivery Date], [Requested Delivery Date])
;