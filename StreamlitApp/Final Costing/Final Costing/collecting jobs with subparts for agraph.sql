DECLARE @j NVARCHAR(MAX) = '10017212'

SELECT
	*
FROM
	[SysproCompanyA].[dbo].[WipMaster] [WM]
WHERE
	[WM].[Job] = @j
;
SELECT
	[WM1].[Job]
	,[WM1].[OperationOffset]
	,[WM1].[StockCode]
	,[WM1].[StockDescription]
	,[WM1].[Bin]
	,[WM1].[Warehouse]
	,[WM1].[ValueIssued]
	,[WM1].[ValueBilled]
	,[WM1].[AllocCompleted]
	,[WM1].[CompletedJobFlag]
	,[WM2].[Job]
	,[WM2].[StockCode]
	,[WM2].[StockDescription]
FROM
	[SysproCompanyA].[dbo].[WipJobAllMat] [WM1]
LEFT JOIN
	[SysproCompanyA].[dbo].[WipMaster] [WM2]
ON
	[WM1].[StockCode] = [WM2].[StockCode]
WHERE
	[WM1].[Job] = @j
;

SELECT
	*
FROM
	[SysproCompanyA].[dbo].[WipJobAllMat] [WM1]
WHERE
	[StockCode] = '41000111'


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
	[JM].[Bin] AS [SubBin],
	[JM].[Warehouse] AS [SubWarehouse],
	[JM].[OperationOffset] AS [SubOperationOffset],
	[IM].[PartCategory] AS [SubPartCategory],
	([IW].[QtyOnHand] * [IW].[UnitCost]) AS [ValueOnHand]
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
		[IM].[PartCategory],
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
	LEFT JOIN
		[SysproCompanyA].[dbo].[InvMaster] [IM] WITH (NOLOCK)
	ON
		[JM].[StockCode] = [IM].[StockCode]
	WHERE
		([O].[WO#] IS NOT NULL)
		AND ([O].[Decline/Rejected] = 4)
) AS [Src]
LEFT JOIN
	[SysproCompanyA].[dbo].[WipJobAllMat] [JM] WITH (NOLOCK)
ON
	([Src].[StockCode] = [JM].[Job])
	AND ([Src].[OperationOffset] = [JM].[OperationOffset])
LEFT JOIN
	[SysproCompanyA].[dbo].[WipJobPost] [JP] WITH (NOLOCK)
ON
	(CAST([Src].[WO#] AS NVARCHAR(250)) = [JP].[Job])
	AND ([JM].[StockCode] = [JP].[MStockCode])
LEFT JOIN
	[SysproCompanyA].[dbo].[InvWarehouse] [IW] WITH (NOLOCK)
ON
	[IW].[StockCode] = [JM].[StockCode]
LEFT JOIN
	[SysproCompanyA].[dbo].[InvMaster] [IM] WITH (NOLOCK)
ON
	[JM].[StockCode] = [IM].[StockCode]