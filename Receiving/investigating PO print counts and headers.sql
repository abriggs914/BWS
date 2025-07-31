SELECT
	*
FROM
	[SysproCompanyA].[dbo].[PorMasterDetail] [MD]
WHERE
	([MD].[MReceivedQty] < [MD].[MOrderQty])
	AND ([MD].[MLatestDueDate] > '2022-01-01')
;


SELECT
	*
FROM
	[SysproCompanyA].[dbo].[PorHistReceipt] [MD]
WHERE
	--([MD].[MReceivedQty] < [MD].[MOrderQty])
	--AND ([MD].[MLatestDueDate] > '2022-01-01')
	--AND
	([MD].[PurchaseOrder] = '000000000130295')
;

SELECT
	*
FROM
	[SysproCompanyA].[dbo].[PorMasterHdr] [MD]


WHERE
	--([MD].[MReceivedQty] < [MD].[MOrderQty])
	--AND ([MD].[MLatestDueDate] > '2022-01-01')
	--AND
	([MD].[PurchaseOrder] = '000000000130295')



SELECT
	[MD].[PurchaseOrder],
	[MD].[PrintCount]
FROM
	[SysproCompanyA].[dbo].[PorMasterHdr] [MD]
GROUP BY
	[MD].[PurchaseOrder],
	[MD].[PrintCount]
HAVING
	[MD].[PrintCount] > 1
;



SELECT TOP 2000
	[AS].[SupplierName],
	[MD].[StockCode],
	[IM].[Description],
	[IM].[LongDesc],
	[IW].[DefaultBin],
	[MD].[Journal],
	[MD].[PurchaseOrder],
	[PM].[MLastReceiptDat],
	[MD].[QtyReceived],
	[MD].[PriceUom],
	[MD].[PriceReceived],
	[MD].[Reference] AS [GRN]
FROM
	[SysproCompanyA].[dbo].[PorHistReceipt] [MD]
INNER JOIN
	[SysproCompanyA].[dbo].[PorMasterDetail] [PM]
ON
	([MD].[PurchaseOrder] = [PM].[PurchaseOrder])
	AND ([MD].[Warehouse] = [PM].[MWarehouse])
	AND ([MD].[StockCode] = [PM].[MStockCode])
INNER JOIN
	[SysproCompanyA].[dbo].[InvMaster] [IM]
ON
	[MD].[StockCode] = [IM].[StockCode]
INNER JOIN
	[SysproCompanyA].[dbo].[InvWarehouse] [IW]
ON
	([MD].[StockCode] = [IW].[StockCode])
	AND ([MD].[Warehouse] = [IW].[Warehouse])
INNER JOIN
	[SysproCompanyA].[dbo].[ApSupplier] [AS]
ON
	[MD].[Supplier] = [AS].[Supplier]
/*WHERE
	--([MD].[MReceivedQty] < [MD].[MOrderQty])
	--AND ([MD].[MLatestDueDate] > '2022-01-01')
	--AND
	([MD].[PurchaseOrder] = '000000000130295')*/
ORDER BY
	[PM].[MLastReceiptDat] DESC
;



SELECT TOP 2000
	[PM].[MLastReceiptDat],
	COUNT([MD].[StockCode]) AS [NumStockCodes],
	SUM([MD].[PriceReceived]) AS [TotalPriceReceived]
FROM
	[SysproCompanyA].[dbo].[PorHistReceipt] [MD]
INNER JOIN
	[SysproCompanyA].[dbo].[PorMasterDetail] [PM]
ON
	([MD].[PurchaseOrder] = [PM].[PurchaseOrder])
	AND ([MD].[Warehouse] = [PM].[MWarehouse])
	AND ([MD].[StockCode] = [PM].[MStockCode])
INNER JOIN
	[SysproCompanyA].[dbo].[ApSupplier] [AS]
ON
	[MD].[Supplier] = [AS].[Supplier]
GROUP BY
	[PM].[MLastReceiptDat]
ORDER BY
	[PM].[MLastReceiptDat] DESC
;



SELECT TOP 2000
	[AS].[SupplierName],
	[MD].[StockCode],
	[IM].[Description],
	[IM].[LongDesc],
	[IW].[DefaultBin],
	[MD].[Journal],
	[MD].[PurchaseOrder],
	[PM].[MLastReceiptDat],
	[MD].[QtyReceived],
	[MD].[PriceUom],
	[MD].[PriceReceived],
	[MD].[Reference] AS [GRN]
FROM
	[SysproCompanyA].[dbo].[PorHistReceipt] [MD]
INNER JOIN
	[SysproCompanyA].[dbo].[PorMasterDetail] [PM]
ON
	([MD].[PurchaseOrder] = [PM].[PurchaseOrder])
	AND ([MD].[Warehouse] = [PM].[MWarehouse])
	AND ([MD].[StockCode] = [PM].[MStockCode])
INNER JOIN
	[SysproCompanyA].[dbo].[ApSupplier] [AS]
ON
	[MD].[Supplier] = [AS].[Supplier]
INNER JOIN
	[SysproCompanyA].[dbo].[InvMaster] [IM]
ON
	[MD].[StockCode] = [IM].[StockCode]
INNER JOIN
	[SysproCompanyA].[dbo].[InvWarehouse] [IW]
ON
	([MD].[StockCode] = [IW].[StockCode])
	AND ([MD].[Warehouse] = [IW].[Warehouse])
WHERE
	--([MD].[MReceivedQty] < [MD].[MOrderQty])
	--AND ([MD].[MLatestDueDate] > '2022-01-01')
	--AND
	(LOWER([IM].[Description]) LIKE '%tape%')
ORDER BY
	[PM].[MLastReceiptDat] DESC