SELECT
	*

FROM
	[BWSdb].[dbo].[PROD_YellowTags]
;
SELECT
	*
FROM
	[BWSdb].[dbo].[hist_PROD_YellowTags]
;

SELECT
	[Src].[StockCode],
	[IM].[Supplier],
	[AS].[SupShortName],
	[IM].*
FROM (
	SELECT
		[YT].[StockCode]
	FROM
		[BWSdb].[dbo].[PROD_YellowTags] [YT]
	WHERE
		[YT].[Supplier] IS NULL
	GROUP BY
		[YT].[StockCode]
	) AS [Src]
LEFT JOIN
	[SysproCompanyA].[dbo].[InvMaster] [IM]
ON
	[Src].[StockCode] = [IM].[StockCode] COLLATE DATABASE_DEFAULT
LEFT JOIN
	[SysproCompanyA].[dbo].[ApSupplier] [AS]
ON
	[IM].[Supplier] = [AS].[Supplier] COLLATE DATABASE_DEFAULT
;

DECLARE @wo AS NVARCHAR(MAX) = '10017283'

SELECT
	*
FROM
	[SysproCompanyA].[dbo].[WipJobAllMat] [WM]
WHERE
	([WM].[Job] = @wo)
;

SELECT
	*
FROM
	[SysproCompanyA].[dbo].[WipJobPost] [WP]
WHERE
	([WP].[Job] = @wo)
	AND
	(ISNULL([WP].[MStockCode], '') <> '')
	--AND (ISNULL([WP].[MQtyIssued], 0) = 0)

SELECT
	*
FROM
	[BWSdb].[dbo].[Production] [P]
WHERE
	ISNULL([P].[Prod Date], [P].[Prod Date2]) > DATEADD(DAY, -400, GETDATE())

SELECT
    [WM].[Job],
    --[WP].[Job],
    [WM].[OperationOffset],
	--[WP].[LOperation],
    [WM].[StockCode],
	[WM].[Uom],
    --[WP].[MStockCode],
    [WM].[UnitQtyReqd],
    ISNULL([WP].[MQtyIssued], 0) AS [QtyIssued],
	[WM].[Warehouse],
	[WM].[StockDescription],
	[WM].[Bin]
	--,
	--*
FROM
	[SysproCompanyA].[dbo].[WipJobAllMat] [WM]
LEFT JOIN [SysproCompanyA].[dbo].[WipJobPost] [WP] 
    ON ([WP].[Job] = [WM].[Job])
   AND ([WP].[MStockCode] = [WM].[StockCode])
   AND ([WP].[LOperation] = [WM].[OperationOffset])
LEFT JOIN (
	SELECT
		*
	FROM
		[BWSdb].[dbo].[Production] [P]
	WHERE
		ISNULL([P].[Prod Date], [P].[Prod Date2]) > DATEADD(DAY, -400, GETDATE())
) AS [P]
ON
	(CASE WHEN LEFT([WM].[Job], 1) = '1' THEN (
		CASE WHEN ([WM].[Job] = CAST([P].[WO#] AS NVARCHAR(MAX))) THEN 1 ELSE 0 END)
	ELSE 0 END) = 1
WHERE
	(ISNULL([WP].[MStockCode], '') = '')
	AND ((ISNULL([WM].[UnitQtyReqd], 0) > (ISNULL([WP].[MQtyIssued], 0)))
	OR (ISNULL([WM].[AllocCompleted], 'N') = 'N'))
	--AND (ISNULL([WP].[MProductClass], 'INFO') <> 'INFO')

SELECT 
    [WM].[Job],
    [WM].[OperationOffset],
    [WM].[StockCode],
    [WM].[UnitQtyReqd],
    ISNULL(SUM([WP].[MQtyIssued]), 0) AS [QtyIssued],
    [WM].[UnitQtyReqd] - ISNULL(SUM([WP].[MQtyIssued]), 0) AS [QtyMissing]
FROM [SysproCompanyA].[dbo].[WipJobAllMat] [WM]
LEFT JOIN [SysproCompanyA].[dbo].[WipJobPost] [WP]
    ON [WM].[Job] = [WP].[Job]
   AND [WM].[StockCode] = [WP].[MStockCode]
   AND [WM].[OperationOffset] = [WP].[LOperation]
WHERE
	(ISNULL([WP].[MProductClass], 'INFO') <> 'INFO')
GROUP BY 
    [WM].[Job], [WM].[OperationOffset], [WM].[StockCode], [WM].[UnitQtyReqd]
HAVING 
    ISNULL(SUM([WP].[MQtyIssued]), 0) < ISNULL(SUM([WM].[UnitQtyReqd]), 0);
;


-- 202509221126
SELECT
    [WM].[Job],
    [WM].[OperationOffset],
    [WM].[StockCode],
	[WM].[Uom],
    [WM].[UnitQtyReqd],
    ISNULL([WP].[MQtyIssued], 0) AS [QtyIssued],
	[WM].[Warehouse],
	[WM].[StockDescription],
	[WM].[Bin]
FROM
	[SysproCompanyA].[dbo].[WipJobAllMat] [WM]
LEFT JOIN [SysproCompanyA].[dbo].[WipJobPost] [WP] 
    ON ([WP].[Job] = [WM].[Job])
   AND ([WP].[MStockCode] = [WM].[StockCode])
   AND ([WP].[LOperation] = [WM].[OperationOffset])
LEFT JOIN (
	SELECT
		*
	FROM
		[BWSdb].[dbo].[Production] [P]
	WHERE
		ISNULL([P].[Prod Date], [P].[Prod Date2]) > DATEADD(DAY, -400, GETDATE())
) AS [P]
ON
	(CASE WHEN LEFT([WM].[Job], 1) = '1' THEN (
		CASE WHEN ([WM].[Job] = CAST([P].[WO#] AS NVARCHAR(MAX))) THEN 1 ELSE 0 END)
	ELSE 0 END) = 1
WHERE
	(ISNULL([WP].[MStockCode], '') = '')
	AND (
		(ISNULL([WM].[UnitQtyReqd], 0) > (ISNULL([WP].[MQtyIssued], 0)))
		OR (ISNULL([WM].[AllocCompleted], 'N') = 'N')
	)