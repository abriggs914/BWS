SELECT
	CAST(RIGHT([PD].[PurchaseOrder], 6) AS INT) AS [PO],
	[PD].[MStockCode] AS [StockCode],
	[PD].[MStockDes] AS [Description],
	[PD].[MStockingUom] AS [UoM],
	[PD].[MOrderQty] AS [QtyOrdered],
	[PD].[MReceivedQty] AS [QtyReceived],
	[PD].[MLatestDueDate] AS [LatestDueDate],
	[PD].[MLastReceiptDat] AS [LastReceiptDate],
	[PD].[MPrice] AS [Price]
FROM
	[SysproCompanyA].[dbo].[PorMasterDetail] [PD]
WHERE
	((LOWER([PD].[MStockDes]) LIKE '%-mach%')
	OR (LOWER([PD].[MStockCode]) LIKE '%-mach%'))
	AND ([PD].[MOrderQty] > [PD].[MReceivedQty])
	AND ([PD].[MWarehouse] = '01')

SELECT
	*
FROM
	[SysproCompanyA].[dbo].[v_OpenSalesOrders]