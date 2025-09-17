

DECLARE @wh NVARCHAR(MAX) = '01';
DECLARE @sc NVARCHAR(MAX) = '401824';

SELECT 
	'SRC' AS [T],
	[MD].[PurchaseOrder],
	[MD].[MStockCode],
	ROW_NUMBER() OVER(
		PARTITION BY
			[MD].[MStockCode]
		ORDER BY
			[MD].[MOrigDueDate] DESC
	) AS [RN]
FROM [SysproCompanyA].[dbo].[PorMasterDetail] [MD]
INNER JOIN [BWSdb].[dbo].[PROD_YellowTags] [YT] ON [MD].[MStockCode] = [YT].[StockCode] COLLATE DATABASE_DEFAULT
WHERE ([MD].[MLastReceiptDat] IS NULL) AND ([MD].[MWarehouse] = @wh) AND ([MD].[MStockCode] = @sc) AND ([YT].[Active] = 1)
;

SELECT 
	'B' AS [T],
	*
FROM
	[SysproCompanyA].[dbo].[InvMaster] [IM]
LEFT JOIN
	[SysproCompanyA].[dbo].[ApSupplier] [AS]
ON
	[IM].[Supplier] = [AS].[Supplier]
WHERE
	([IM].[StockCode] = @sc)
;

SELECT
	ISNULL([AS].[SupShortName], [AS].[SupShortName]) AS [Supplier],
	ISNULL([IM].[Description], '') + ' *---* ' + ISNULL([IM].[LongDesc], '') AS [Description],
	[Src].[PurchaseOrder] AS [PO],
	*
FROM 
	[BWSdb].[dbo].[PROD_YellowTags] [YT]
INNER JOIN (
	SELECT 
		[MD].[PurchaseOrder],
		[MD].[MStockCode],
		ROW_NUMBER() OVER(
			PARTITION BY
				[MD].[MStockCode]
			ORDER BY
				[MD].[MOrigDueDate] DESC
		) AS [RN]
	FROM [SysproCompanyA].[dbo].[PorMasterDetail] [MD]
	INNER JOIN [BWSdb].[dbo].[PROD_YellowTags] [YT] ON [MD].[MStockCode] = [YT].[StockCode] COLLATE DATABASE_DEFAULT
	WHERE ([MD].[MLastReceiptDat] IS NULL) AND ([MD].[MWarehouse] = @wh) AND ([YT].[Active] = 1)
) AS [Src]
ON
	[YT].[StockCode] = [Src].[MStockCode] COLLATE DATABASE_DEFAULT
FULL JOIN
	[SysproCompanyA].[dbo].[InvMaster] [IM]
ON
	[Src].[MStockCode] = [IM].[StockCode]
LEFT JOIN
	[SysproCompanyA].[dbo].[ApSupplier] [AS]
ON
	[IM].[Supplier] = [AS].[Supplier]
WHERE
	/*
	([Src].[RN] = 1)
	AND ([YT].[Active] = 1)
	AND ([IM].[StockCode] = @sc)
	*/
	(ISNULL([Src].[RN], 1) = 1)
	AND (ISNULL([YT].[Active], 1) = 1)
	AND ([IM].[StockCode] = @sc)
;