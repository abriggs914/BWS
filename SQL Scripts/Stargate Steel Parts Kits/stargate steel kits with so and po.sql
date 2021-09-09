USE SysproCompanyA
GO

--SELECT [SalesOrder], * FROM [WipMaster] WHERE [SalesOrder] != '' AND LEFT([Job], 1) = '7'
--SELECT * FROM [PorMasterDetail] -- WHERE [SalesOrder] != '' AND LEFT([Job], 1) = '7'



SELECT 
	[WipMaster].[StockCode],
	[WipMaster].[Job],
	[JobStartDate], 
	[JobDeliveryDate],
	[SalesOrder],
	[PurchaseOrder]
FROM
	[WipMaster]
INNER JOIN
	[SysproCompanyS].[dbo].[PorMasterDetail]
ON
	[PorMasterDetail].[MStockCode] = [WipMaster].[StockCode]
WHERE
	LEFT([Job], 1) = '7'
	AND [StockCode] LIKE 'SP%' 