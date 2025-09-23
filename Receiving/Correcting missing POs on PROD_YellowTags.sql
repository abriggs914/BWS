
-- Correcting missing POs on PROD_YellowTags
/*
BEGIN TRAN;


UPDATE
	[BWSdb].[dbo].[PROD_YellowTags]
SET
	[PO] = '000000000114364'
WHERE
	[StockCode] = '04184'

ROLLBACk;
COMMIT;
*/


SELECT
	*
FROM
	[BWSdb].[dbo].[PROD_YellowTags]
WHERE
	ISNULL([PO], '') = ''
ORDER BY
	[StockCode]

SELECT
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
	WHERE ([MD].[MLastReceiptDat] IS NULL) AND ([YT].[Active] = 1)
) AS [Src]
ON
	[YT].[StockCode] = [Src].[MStockCode] COLLATE DATABASE_DEFAULT
INNER JOIN
	[SysproCompanyA].[dbo].[InvMaster] [IM]
ON
	[Src].[MStockCode] = [IM].[StockCode]
LEFT JOIN
	[SysproCompanyA].[dbo].[ApSupplier] [AS]
ON
	[IM].[Supplier] = [AS].[Supplier]
WHERE
	(ISNULL([Src].[RN], 1) = 1)
	AND (ISNULL([YT].[Active], 1) = 1)
	AND (ISNULL([PO], '') = '')
;