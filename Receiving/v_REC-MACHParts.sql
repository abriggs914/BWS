-- 2025-09-02 - Avery Briggs - View of Machine parts that are contracted out.
--								Yassin needs this to quickly see if something is still outstanding


CREATE VIEW [dbo].[v_REC-MACHParts]
AS

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
;