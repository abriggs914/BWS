SELECT
	[YT].*,
	[IW].[QtyOnHand],
	[IM].[Description] AS [Desc],
	[IM].[LongDesc]
FROM
	[BWSdb].[dbo].[PROD_YellowTags] [YT]
LEFT JOIN
	[SysproCompanyA].[dbo].[InvWarehouse] [IW] 
ON
	[YT].[StockCode] = [IW].[StockCode] COLLATE DATABASE_DEFAULT
LEFT JOIN
	[SysproCompanyA].[dbo].[InvMaster] [IM] 
ON
	[YT].[StockCode] = [IM].[StockCode] COLLATE DATABASE_DEFAULT
WHERE
	[IW].[Warehouse] = '01'
;