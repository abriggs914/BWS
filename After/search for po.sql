/*
SELECT
	*
FROM
	[SysproCompanyA].[dbo].[PorMasterHdr] [PC] WITH (NOLOCK)
*/

SELECT
	[PD].[PurchaseOrder],
	[PD].[MStockCode],
	[PD].[MWarehouse],
	[MOrderUom],
	[MOrderQty],
	[MReceivedQty],
	[PD].[MOrigDueDate],
	[PD].[MLatestDueDate],
	[PD].[MLastReceiptDat],
	[PD].[MCompleteFlag],
	[PD].[MPrice],
	[PD].[MDiscPct1],
	[PD].[MDiscPct2],
	[PD].[MDiscPct3],

	[PH].[Supplier] AS [PHSupplier],

	[PR].[PoDate],
	[PR].[QtyReceived],
	[PR].[PriceReceived],
	[PR].[Currency],
	[PR].[ExchangeRate],

	[AS].[SupplierName] AS [Supplier],
	[AS].[SupShortName],
	[AS].[Contact],
	[AS].[Telephone],
	[AS].[Email],
	[AS].[Nationality]
FROM
	[SysproCompanyA].[dbo].[PorMasterDetail] [PD] WITH (NOLOCK)
LEFT JOIN
	[SysproCompanyA].[dbo].[PorMasterHdr] [PH] WITH (NOLOCK)
ON
	[PD].[PurchaseOrder] = [PH].[PurchaseOrder]
LEFT JOIN (
	SELECT
		[PRs].[PurchaseOrder],
		[PRs].[StockCode],
		[PRs].[Warehouse],
		[PRs].[Supplier],
		[PRs].[Currency],
		[PRs].[ExchangeRate],
		MIN([PRs].[DateReceived]) AS [FirstDateReceived],
		MAX([PRs].[DateReceived]) AS [LastDateReceived],
		[PRs].[PoDate],
		SUM([PRs].[QtyReceived]) AS [QtyReceived],
		SUM([PRs].[PriceReceived]) AS [PriceReceived]
	FROM
		[SysproCompanyA].[dbo].[PorHistReceipt] [PRs] WITH (NOLOCK)
	GROUP BY
		[PRs].[PurchaseOrder],
		[PRs].[StockCode],
		[PRs].[Warehouse],
		[PRs].[Supplier],
		[PRs].[Currency],
		[PRs].[ExchangeRate],
		[PRs].[PoDate]
) AS [PR]
ON
	([PD].[PurchaseOrder] = [PR].[PurchaseOrder])
	AND ([PD].[MStockCode] = [PR].[StockCode])
	AND ([PD].[MWarehouse] = [PR].[Warehouse])
	AND ([PD].[MLastReceiptDat] = [PR].[LastDateReceived])

LEFT JOIN
	[SysproCompanyA].[dbo].[ApSupplier] [AS] WITH (NOLOCK)
ON
	[PH].[Supplier] = [AS].[Supplier]
WHERE
	(
		(ISNULL([MStockCode], '') <> '')
		OR (ISNULL([MOrderQty], 0) <> 0)
	)
	AND LOWER([PH].[PurchaseOrder]) = RIGHT('0000000000000000' + '150828', 15)