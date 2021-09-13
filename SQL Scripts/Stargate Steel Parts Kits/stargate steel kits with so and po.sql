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
	[PurchaseOrder],
	[Complete]
FROM
	[WipMaster]
INNER JOIN
	[SysproCompanyS].[dbo].[PorMasterDetail]
ON
	[PorMasterDetail].[MStockCode] = [WipMaster].[StockCode]
WHERE
	LEFT([Job], 1) = '7'
	AND [StockCode] LIKE 'SP%' 
;

DECLARE @sf AS INT;
SET @sf = 1;

SELECT
	[JobStartDate],
	[JobDeliveryDate],
	[StockCode],
	[Job],
	CAST([SalesOrder] AS BIGINT) AS [SalesOrder],
	CAST([PurchaseOrder] AS BIGINT) AS [PurchaseOrder],
	[Complete]
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
	AND [Complete] = 'N'
	AND ((0 = 1 AND [JobDeliveryDate] <= CAST(GETDATE() AS DATETIME)) OR (0 = 0 AND [JobDeliveryDate] > CAST(GETDATE() AS DATETIME)))
ORDER BY [JobDeliveryDate];
;