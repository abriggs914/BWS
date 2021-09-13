USE SysproCompanyA
GO

SELECT
	[JobStartDate],
	[JobDeliveryDate],
	[StockCode],
	[Job],
	(CASE WHEN CAST([SalesOrder] AS BIGINT) = 0 THEN '' ELSE CAST([SalesOrder] AS BIGINT) END) AS [SalesOrder],
	CAST([PurchaseOrder] AS BIGINT) AS [PurchaseOrder]
From
	[WipMaster]
INNER JOIN
	[SysproCompanyS].[dbo].[PorMasterDetail]
ON
	[PorMasterDetail].[MStockCode] = [WipMaster].[StockCode]
WHERE
	([JobStartDate] BETWEEN '9/1/2021' AND '9/25/2021' OR [JobDeliveryDate] BETWEEN '9/1/2021' AND '9/25/2021' )
	AND [StockCode] LIKE 'SP%'
	AND LEFT([Job], 1) = '7'
ORDER BY [JobDeliveryDate];