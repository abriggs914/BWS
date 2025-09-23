
SELECT * FROM [BWSdb].[dbo].[PROD_YellowTags] [YT]
SELECT * FROM [BWSdb].[dbo].[hist_PROD_YellowTags] [YT]
/*
SELECT * FROM [BWSdb].[dbo].[PROD_YellowTags] [YT]
ORDER BY
	[YT].[ID]

SELECT
	[YT].[ID],
	[YT].[DateCreated],
	[YT].[LastModified],
	[YT].[Active],
	[YT].[DateActive],
	[YT].[DateInActive],
	[YT].[WO],
	[YT].[StockCode],
	[YT].[Description],
	[YT].[QtyMissing],
	[YT].[Supplier],
	[YT].[Notes]
FROM 
	[BWSdb].[dbo].[PROD_YellowTags] [YT]
LEFT JOIN 
	[SysproCompanyA].[dbo].[InvMaster] [IM]
ON
	[YT].[StockCode] = [IM].[StockCode] COLLATE DATABASE_DEFAULT
LEFT JOIN
	[SysproCompanyA].[dbo].[InvWarehouse] [IW]
ON
	[IM].[StockCode] = [IW].[StockCode]
WHERE
	[IW].[Warehouse] = '01'
ORDER BY
	[YT].[ID]
*/


SELECT
	[YT].[ID],
	[YT].[DateCreated],
	[YT].[LastModified],
	[YT].[Active],
	[YT].[DateActive],
	[YT].[DateInActive],
	[YT].[PO],
	[YT].[WO],
	[YT].[StockCode],
	[YT].[Description] AS [YTDescription],
	[YT].[QtyMissing],
	--[YT].[Supplier],
	[YT].[Notes],
	[IW].[QtyOnHand],
	[IM].[Description],
	[IM].[LongDesc],
	[AS].[SupShortName] AS [Supplier],
	[IW].[Warehouse]
FROM 
	[BWSdb].[dbo].[PROD_YellowTags] [YT]
LEFT JOIN
	[SysproCompanyA].[dbo].[InvMaster] [IM]
ON
	[YT].[StockCode] = [IM].[StockCode] COLLATE DATABASE_DEFAULT
LEFT JOIN
	[SysproCompanyA].[dbo].[InvWarehouse] [IW]
ON
	([IM].[StockCode] = [IW].[StockCode])
	AND ([IM].[WarehouseToUse] = [IW].[Warehouse])
LEFT JOIN
	[SysproCompanyA].[dbo].[ApSupplier] [AS]
ON
	[IM].[Supplier] = [AS].[Supplier]
ORDER BY
	[YT].[ID]


SELECT
	*
FROM (
	SELECT 
		[MD].[PurchaseOrder],
		[MD].[MStockCode],
		[MD].[MWarehouse],
		ROW_NUMBER() OVER(
			PARTITION BY
				[MD].[MStockCode]
			ORDER BY
				[MD].[MOrigDueDate] DESC
		) AS [RN]
	FROM [SysproCompanyA].[dbo].[PorMasterDetail] [MD]
	INNER JOIN [BWSdb].[dbo].[PROD_YellowTags] [YT] ON [MD].[MStockCode] = [YT].[StockCode] COLLATE DATABASE_DEFAULT
	WHERE ([MD].[MLastReceiptDat] IS NULL) AND ([YT].[Active] = 1)
) AS [Src]
/*ON
	[YT].[StockCode] = [Src].[MStockCode] COLLATE DATABASE_DEFAULT*/
FULL JOIN
	[SysproCompanyA].[dbo].[InvMaster] [IM]
ON
	([Src].[MStockCode] = [IM].[StockCode])
	AND ([Src].[MWarehouse] = [IM].[WarehouseToUse])
LEFT JOIN
	[SysproCompanyA].[dbo].[ApSupplier] [AS]
ON
	[IM].[Supplier] = [AS].[Supplier]
WHERE
	(ISNULL([Src].[RN], 1) = 1)
	--AND (ISNULL([YT].[Active], 1) = 1)
;