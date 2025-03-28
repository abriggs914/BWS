
-- Parts
SELECT
	ISNULL([PR].[Prod Date], [PR].[Prod Date2]) AS [DateProduction],
	[O].[WO#],
	[O].[Quote#],
	[P].[Model No],
	[D].[COMPANY NAME],
	[JM].[StockCode],
	[JM].[StockDescription],
	[JM].[OperationOffset],
	[JM].[QtyIssued],
	[JM].[UnitCost],
	[JM].[ValueIssued],
	[JM].[ValueBilled],
	(CASE WHEN ISNULL([JM].[AllocCompleted], 'N') = 'Y' THEN 1 ELSE 0 END) AS [Complete],
	[JP].[TrnDate],
	[IM].[WarehouseToUse],
	[IW].[DefaultBin]
FROM
	[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
INNER JOIN
	[SysproCompanyA].[dbo].[WipJobAllMat] [JM] WITH (NOLOCK)
ON
	CAST([O].[WO#] AS NVARCHAR(250)) = [JM].[Job]
INNER JOIN
	[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
ON
	[O].[ProductID] = [P].[IDTrailer]
INNER JOIN
	[BWSdb].[dbo].[Dealers] [D] WITH (NOLOCK)
ON
	[O].[DealerID] = [D].[ID]
LEFT JOIN
	[BWSdb].[dbo].[Production] [PR] WITH (NOLOCK)
ON
	[O].[WO#] = [PR].[WO#]
LEFT JOIN
	[SysproCompanyA].[dbo].[WipJobPost] [JP]
ON
	(CAST([O].[WO#] AS NVARCHAR(250)) = [JP].[Job])
	AND ([JM].[StockCode] = [JP].[MStockCode])
	
LEFT JOIN
	[SysproCompanyA].[dbo].[InvMaster] [IM] WITH (NOLOCK)
ON
	[JM].[StockCode] = [IM].[StockCode]
LEFT JOIN
	[SysproCompanyA].[dbo].[InvWarehouse] [IW] WITH (NOLOCK)
ON
    ([IM].StockCode = [IW].StockCode)
    AND ([IM].[WarehouseToUse] = [IW].[Warehouse])

WHERE
	([O].[WO#] IS NOT NULL)
	AND ([O].[Decline/Rejected] = 4)

-- Subs
SELECT
	[Src].*,
	[JM].[Job],
	[JM].[StockCode] AS [SubStockCode],
	[JM].[StockDescription] AS [SubStockDescription],
	[JM].[Warehouse] AS [SubWareHouse],
	[JM].[QtyIssued] AS [SubQtyIssued],
	[JM].[UnitCost] AS [SubUnitCost],
	[JM].[ValueIssued] AS [SubValueIssued],
	[JM].[ValueBilled] AS [SubValueBilled],
	[JM].[AllocCompleted] AS [SubAllocCompleted],
	[JP].[TrnDate],
	[IM].[WarehouseToUse] AS [SubWarehouseToUse],
	[IW].[DefaultBin] AS [SubDefaultBin]
FROM (
	SELECT
		ISNULL([PR].[Prod Date], [PR].[Prod Date2]) AS [DateProduction],
		[O].[WO#],
		[O].[Quote#],
		[P].[Model No],
		[D].[COMPANY NAME],
		[JM].[StockCode],
		[JM].[StockDescription],
		[JM].[OperationOffset],
		[JM].[QtyIssued],
		[JM].[UnitCost],
		[JM].[ValueIssued],
		[JM].[ValueBilled],
		(CASE WHEN ISNULL([JM].[AllocCompleted], 'N') = 'Y' THEN 1 ELSE 0 END) AS [Complete],
		[IM].[WarehouseToUse],
		[IW].[DefaultBin]
	FROM
		[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
	INNER JOIN
		[SysproCompanyA].[dbo].[WipJobAllMat] [JM] WITH (NOLOCK)
	ON
		CAST([O].[WO#] AS NVARCHAR(250)) = [JM].[Job]
	INNER JOIN
		[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
	ON
		[O].[ProductID] = [P].[IDTrailer]
	INNER JOIN
		[BWSdb].[dbo].[Dealers] [D] WITH (NOLOCK)
	ON
		[O].[DealerID] = [D].[ID]
	LEFT JOIN
		[BWSdb].[dbo].[Production] [PR] WITH (NOLOCK)
	ON
		[O].[WO#] = [PR].[WO#]
	LEFT JOIN
		[SysproCompanyA].[dbo].[InvMaster] [IM] WITH (NOLOCK)
	ON
		[JM].[StockCode] = [IM].[StockCode]
	LEFT JOIN
		[SysproCompanyA].[dbo].[InvWarehouse] [IW] WITH (NOLOCK)
	ON
		([IM].StockCode = [IW].StockCode)
		AND ([IM].[WarehouseToUse] = [IW].[Warehouse])
	WHERE
		([O].[WO#] IS NOT NULL)
		AND ([O].[Decline/Rejected] = 4)
) AS [Src]
INNER JOIN
	[SysproCompanyA].[dbo].[WipJobAllMat] [JM]
ON
	([Src].[StockCode] = [JM].[Job])
	AND ([Src].[OperationOffset] = [JM].[OperationOffset])
LEFT JOIN
	[SysproCompanyA].[dbo].[WipJobPost] [JP]
ON
	(CAST([Src].[WO#] AS NVARCHAR(250)) = [JP].[Job])
	AND ([JM].[StockCode] = [JP].[MStockCode])
LEFT JOIN
	[SysproCompanyA].[dbo].[InvMaster] [IM] WITH (NOLOCK)
ON
	[JM].[StockCode] = [IM].[StockCode]
LEFT JOIN
	[SysproCompanyA].[dbo].[InvWarehouse] [IW] WITH (NOLOCK)
ON
    ([IM].StockCode = [IW].StockCode)
    AND ([IM].[WarehouseToUse] = [IW].[Warehouse])

--
-- ORIGINAL PARTS
-- Parts
SELECT
	ISNULL([PR].[Prod Date], [PR].[Prod Date2]) AS [DateProduction],
	[O].[WO#],
	[O].[Quote#],
	[P].[Model No],
	[D].[COMPANY NAME],
	[JM].[StockCode],
	[JM].[StockDescription],
	[JM].[OperationOffset],
	[JM].[QtyIssued],
	[JM].[UnitCost],
	[JM].[ValueIssued],
	[JM].[ValueBilled],
	(CASE WHEN ISNULL([JM].[AllocCompleted], 'N') = 'Y' THEN 1 ELSE 0 END) AS [Complete],
	[JP].[TrnDate]
FROM
	[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
INNER JOIN
	[SysproCompanyA].[dbo].[WipJobAllMat] [JM] WITH (NOLOCK)
ON
	CAST([O].[WO#] AS NVARCHAR(250)) = [JM].[Job]
INNER JOIN
	[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
ON
	[O].[ProductID] = [P].[IDTrailer]
INNER JOIN
	[BWSdb].[dbo].[Dealers] [D] WITH (NOLOCK)
ON
	[O].[DealerID] = [D].[ID]
LEFT JOIN
	[BWSdb].[dbo].[Production] [PR] WITH (NOLOCK)
ON
	[O].[WO#] = [PR].[WO#]
LEFT JOIN
	[SysproCompanyA].[dbo].[WipJobPost] [JP]
ON
	(CAST([O].[WO#] AS NVARCHAR(250)) = [JP].[Job])
	AND ([JM].[StockCode] = [JP].[MStockCode])
WHERE
	([O].[WO#] IS NOT NULL)
	AND ([O].[Decline/Rejected] = 4)

-- ORIGINAL SUB PARTS
-- Subs
SELECT
	[Src].*,
	[JM].[Job],
	[JM].[StockCode] AS [SubStockCode],
	[JM].[StockDescription] AS [SubStockDescription],
	[JM].[Warehouse] AS [SubWareHouse],
	[JM].[QtyIssued] AS [SubQtyIssued],
	[JM].[UnitCost] AS [SubUnitCost],
	[JM].[ValueIssued] AS [SubValueIssued],
	[JM].[ValueBilled] AS [SubValueBilled],
	[JM].[AllocCompleted] AS [SubAllocCompleted],
	[JP].[TrnDate]
FROM (
	SELECT
		ISNULL([PR].[Prod Date], [PR].[Prod Date2]) AS [DateProduction],
		[O].[WO#],
		[O].[Quote#],
		[P].[Model No],
		[D].[COMPANY NAME],
		[JM].[StockCode],
		[JM].[StockDescription],
		[JM].[OperationOffset],
		[JM].[QtyIssued],
		[JM].[UnitCost],
		[JM].[ValueIssued],
		[JM].[ValueBilled],
		(CASE WHEN ISNULL([JM].[AllocCompleted], 'N') = 'Y' THEN 1 ELSE 0 END) AS [Complete]
	FROM
		[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
	INNER JOIN
		[SysproCompanyA].[dbo].[WipJobAllMat] [JM] WITH (NOLOCK)
	ON
		CAST([O].[WO#] AS NVARCHAR(250)) = [JM].[Job]
	INNER JOIN
		[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
	ON
		[O].[ProductID] = [P].[IDTrailer]
	INNER JOIN
		[BWSdb].[dbo].[Dealers] [D] WITH (NOLOCK)
	ON
		[O].[DealerID] = [D].[ID]
	LEFT JOIN
		[BWSdb].[dbo].[Production] [PR] WITH (NOLOCK)
	ON
		[O].[WO#] = [PR].[WO#]
	WHERE
		([O].[WO#] IS NOT NULL)
		AND ([O].[Decline/Rejected] = 4)
) AS [Src]
INNER JOIN
	[SysproCompanyA].[dbo].[WipJobAllMat] [JM]
ON
	([Src].[StockCode] = [JM].[Job])
	AND ([Src].[OperationOffset] = [JM].[OperationOffset])
LEFT JOIN
	[SysproCompanyA].[dbo].[WipJobPost] [JP]
ON
	(CAST([Src].[WO#] AS NVARCHAR(250)) = [JP].[Job])
	AND ([JM].[StockCode] = [JP].[MStockCode])
