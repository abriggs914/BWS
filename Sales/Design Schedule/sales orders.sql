USE SysproCompanyS
GO

SELECT
	*
FROM
	[SorMaster]

SELECT
	[O].[SGQuote],
	[O].[Sales Order#],
	[S].[SalesOrder]
FROM
	[BWSdb].[dbo].[DesignV2] AS [D]
LEFT JOIN
	[BWSdb].[dbo].[OrdersV2] AS [O]
ON
	[D].[SGQuote] = [O].[SGQuote]
LEFT JOIN
	[SorMaster] AS [S]
ON
	[O].[Sales Order#] = CAST([S].[SalesOrder] AS INT)