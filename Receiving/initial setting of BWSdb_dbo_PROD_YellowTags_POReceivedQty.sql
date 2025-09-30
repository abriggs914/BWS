
-- 202509301317 - Initial setting of [BWSdb].[dbo].[PROD_YellowTags].[POReceivedQty]

BEGIN TRAN;

SELECT
	*
FROM
	[BWSdb].[dbo].[PROD_YellowTags] [YT]
INNER JOIN
	[SysproCompanyA].[dbo].[PorMasterDetail] [PMD]
ON
	([YT].[PO] = [PMD].[PurchaseOrder] COLLATE DATABASE_DEFAULT)
	AND ([YT].[StockCode] = [PMD].[MStockCode] COLLATE DATABASE_DEFAULT)
WHERE
	([YT].[Active] = 1)          -- Current YTs
	AND ([YT].[PO] IS NOT NULL)  -- Purchase Order must be known
;

UPDATE
	[BWSdb].[dbo].[PROD_YellowTags]
SET
	[POReceivedQty] = [PMD].[MReceivedQty]
FROM
	[BWSdb].[dbo].[PROD_YellowTags] [YT]
INNER JOIN
	[SysproCompanyA].[dbo].[PorMasterDetail] [PMD]
ON
	([YT].[PO] = [PMD].[PurchaseOrder] COLLATE DATABASE_DEFAULT)
	AND ([YT].[StockCode] = [PMD].[MStockCode] COLLATE DATABASE_DEFAULT)
WHERE
	([YT].[Active] = 1)          -- Current YTs
	AND ([YT].[PO] IS NOT NULL)  -- Purchase Order must be known
;

SELECT
	*
FROM
	[BWSdb].[dbo].[PROD_YellowTags] [YT]
INNER JOIN
	[SysproCompanyA].[dbo].[PorMasterDetail] [PMD]
ON
	([YT].[PO] = [PMD].[PurchaseOrder] COLLATE DATABASE_DEFAULT)
	AND ([YT].[StockCode] = [PMD].[MStockCode] COLLATE DATABASE_DEFAULT)
WHERE
	([YT].[Active] = 1)          -- Current YTs
	AND ([YT].[PO] IS NOT NULL)  -- Purchase Order must be known

ROLLBACK;
COMMIT;