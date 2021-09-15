USE SysproCompanyA
GO

SELECT
	[JobStartDate],
	[JobDeliveryDate],
	[StockCode],
	[Job],
	REPLACE(LTRIM(REPLACE([SalesOrder], '0', ' ')), ' ', '0') AS [SalesOrder],
	REPLACE(LTRIM(REPLACE([PurchaseOrder], '0', ' ')), ' ', '0') AS [PurchaseOrder],
	[Complete]
From 
	[WipMaster] 
INNER JOIN
	[SysproCompanyS].[dbo].[PorMasterDetail]
ON
	[PorMasterDetail].[MStockCode] = [WipMaster].[StockCode]
WHERE
	([JobStartDate] BETWEEN '1/1/2021' AND '9/30/2021' 
	OR [JobDeliveryDate] BETWEEN '1/1/2021' AND '9/30/2021' )
	AND ([StockCode] LIKE 'PF%' OR [StockCode] LIKE 'TF%') 
	AND LEFT([Job], 1) = '7' 
	AND [Complete] = 'N' 
	AND ((0 = 1 AND [JobDeliveryDate] <= CAST(GETDATE() AS DATETIME)) OR (0 = 0 AND [JobDeliveryDate] > CAST(GETDATE() AS DATETIME))) ORDER BY [JobDeliveryDate];