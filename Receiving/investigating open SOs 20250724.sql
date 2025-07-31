SELECT
	*
FROM (
	SELECT
		COUNT([OS].[StockCode]) AS [NumUniqueStockodes],
		SUM(([OS].[Order Qty] - [OS].[Ship Qty])) AS [NumPieces],
		SUM([OS].[QtyOnHand]) AS [NumAvail],
		[OS].[CustomerName],
		[OS].[SalesOrder],
		[OS].[Ship Date]
		--,
		--([OS].[Order Qty] - [OS].[Ship Qty]) AS [NeedToPick]
		--([OS].[Order Qty] - [OS].[Ship Qty]) <= ([OS].[QtyOnHand] - ([QtyOnOrder] + [B/O Qty])) AS [AvailToPick]
	FROM 
		[SysproCompanyA].[dbo].[v_OpenSalesOrders] [OS]
	/*WHERE
		([OS].[Order Qty] - [OS].[Ship Qty]) <= ([OS].[QtyOnHand] - ([QtyOnOrder] + [B/O Qty]))*/
	GROUP BY
		[OS].[CustomerName],
		[OS].[SalesOrder],
		[OS].[Ship Date]
) AS [Src]
WHERE
	[NumPieces] > 0
ORDER BY
	[Src].[Ship Date]

SELECT
	*
FROM 
	[SysproCompanyA].[dbo].[v_OpenSalesOrders] [OS]
WHERE
	([OS].[Order Qty] - [OS].[Ship Qty]) <= ([OS].[QtyOnHand] - ([QtyOnOrder] + [B/O Qty]))
ORDER BY
	[Ship Date]

SELECT
	[SD].[MInvoicePrinted]
	,[SD].[MCommitDate]
	,[SD].[MLineShipDate]
	,[SD].[OrigShipDateAps]
	,*
FROM
	[SysproCompanyA].[dbo].[SorDetail] [SD]
ORDER BY
	[SD].[MLineReceiptDat]
