
USE SysproCompanyA
GO


-- 2023-08-10 1212
-- 


DECLARE
	@WO VARCHAR(MAX),
	@WH VARCHAR(MAX);

SELECT
	@WO='10016619',
	@WH='06';

DECLARE @StockCodes AS TABLE (
	[ID] INT IDENTITY(0, 1)
	, [StockCode] NVARCHAR(MAX)
	, [Operation] INT
	, [Warehouse] NVARCHAR(MAX)
	, [TLStartDate] DATETIME
)

DECLARE @UnitStartDate AS DATETIME;
SELECT @UnitStartDate = [JobStartDate] FROM [WipMaster] WHERE [Job] = @WO



--SELECT
--	*
--FROM
--	[WipJobAllMat]
--WHERE
--	[WipJobAllMat].[Job] = @WO

-- Unique Sub Parts in this WO
SELECT
	'R' AS [T]
	, [Mat].[OperationOffset]
	, [Inv].[PartCategory]
	, [Mat].[Warehouse]
	, [Mat].[StockCode]
	, [Mat].[StockDescription]
	, [Whs].[QtyOnHand]
	, [Whs].[QtyOnOrder]
	, [Whs].[QtyAllocated]
	, [Mat].[UnitQtyReqd]
	, [Mat].[QtyIssued]
FROM
	[WipMaster] AS [Wip]
LEFT JOIN
	[WipJobAllMat] AS [Mat]
ON
	[Mat].[StockCode] = [Wip].[StockCode]
LEFT JOIN
	[InvMaster] AS [Inv]
ON
	[Mat].[StockCode] = [Inv].[StockCode]
LEFT JOIN
	[InvWarehouse] AS [Whs]
ON
	[Whs].[StockCode] = [Mat].[StockCode]
	AND [Mat].[Warehouse] = [Whs].[Warehouse]

WHERE
	[Mat].[Job] = @WO
	--AND ISNULL([Wip].[Complete], 'N') = 'N'
GROUP BY
	[Mat].[OperationOffset]
	, [Inv].[PartCategory]
	, [Mat].[Warehouse]
	, [Mat].[StockCode]
	, [Mat].[StockDescription]
	, [Whs].[QtyOnHand]
	, [Whs].[QtyOnOrder]
	, [Whs].[QtyAllocated]
	, [Mat].[UnitQtyReqd]
	, [Mat].[QtyIssued]
ORDER BY
	[OperationOffset]
	, [StockCode]


	
-- Unique BO Parts in this WO
SELECT
	'R' AS [T]
	, [Mat].[OperationOffset]
	, [Inv].[PartCategory]
	, [Mat].[Warehouse]
	, [Mat].[StockCode]
	, [Mat].[StockDescription]
	, [Whs].[QtyOnHand]
	, [Whs].[QtyOnOrder]
	, [Whs].[QtyAllocated]
	, [Mat].[UnitQtyReqd]
	, [Mat].[QtyIssued]
FROM
	[WipJobAllMat] AS [Mat]
LEFT JOIN
	[InvMaster] AS [Inv]
ON
	[Mat].[StockCode] = [Inv].[StockCode]
LEFT JOIN
	[InvWarehouse] AS [Whs]
ON
	[Whs].[StockCode] = [Mat].[StockCode]
	AND [Mat].[Warehouse] = [Whs].[Warehouse]

WHERE
	[Mat].[Job] = @WO
	--AND ISNULL([Wip].[Complete], 'N') = 'N'
GROUP BY
	[Mat].[OperationOffset]
	, [Inv].[PartCategory]
	, [Mat].[Warehouse]
	, [Mat].[StockCode]
	, [Mat].[StockDescription]
	, [Whs].[QtyOnHand]
	, [Whs].[QtyOnOrder]
	, [Whs].[QtyAllocated]
	, [Mat].[UnitQtyReqd]
	, [Mat].[QtyIssued]
ORDER BY
	[OperationOffset]
	, [StockCode]


-- Unique BO Parts in this WO
INSERT INTO @StockCodes ([StockCode], [Operation], [Warehouse], [TLStartDate]) 
SELECT
	[Mat].[StockCode]
	,[Mat].[OperationOffset]
	,[Mat].[Warehouse]
	,@UnitStartDate
FROM
	[WipJobAllMat] AS [Mat]
LEFT JOIN
	[InvMaster] AS [Inv]
ON
	[Mat].[StockCode] = [Inv].[StockCode]
LEFT JOIN
	[InvWarehouse] AS [Whs]
ON
	[Whs].[StockCode] = [Mat].[StockCode]
	AND [Mat].[Warehouse] = [Whs].[Warehouse]

WHERE
	[Mat].[Job] = @WO
	AND [Mat].[Warehouse] = CAST(@WH AS INT)
	--AND ISNULL([Wip].[Complete], 'N') = 'N'
GROUP BY
	[Mat].[OperationOffset]
	, [Inv].[PartCategory]
	, [Mat].[Warehouse]
	, [Mat].[StockCode]
	, [Mat].[StockDescription]
	, [Whs].[QtyOnHand]
	, [Whs].[QtyOnOrder]
	, [Whs].[QtyAllocated]
	, [Mat].[UnitQtyReqd]
	, [Mat].[QtyIssued]
ORDER BY
	[OperationOffset]
	, [StockCode]
;


SELECT
	'INSERT',
	[Mat].[StockCode]
	,[Mat].[OperationOffset]
	,[Mat].[Warehouse]
	,@UnitStartDate
FROM
	[WipJobAllMat] AS [Mat]
LEFT JOIN
	[InvMaster] AS [Inv]
ON
	[Mat].[StockCode] = [Inv].[StockCode]
LEFT JOIN
	[InvWarehouse] AS [Whs]
ON
	[Whs].[StockCode] = [Mat].[StockCode]
	AND [Mat].[Warehouse] = [Whs].[Warehouse]

WHERE
	[Mat].[Job] = @WO
	AND [Mat].[OperationOffset] = CAST(@WH AS INT)
	--AND ISNULL([Wip].[Complete], 'N') = 'N'
GROUP BY
	[Mat].[OperationOffset]
	, [Inv].[PartCategory]
	, [Mat].[Warehouse]
	, [Mat].[StockCode]
	, [Mat].[StockDescription]
	, [Whs].[QtyOnHand]
	, [Whs].[QtyOnOrder]
	, [Whs].[QtyAllocated]
	, [Mat].[UnitQtyReqd]
	, [Mat].[QtyIssued]
ORDER BY
	[OperationOffset]
	, [StockCode]
;





SELECT
	'HERE' AS [X],
			[SC].[ID],
			[SC].[StockCode],
			[Wip].[StockDescription],
			[SC].[Operation],
			[SC].[TLStartDate],
			[Wip].[JobStartDate],
			[Wip].[Job],
			[SC].[Warehouse],
			ABS(DATEDIFF(SECOND, [SC].[TLStartDate], [Wip].[JobStartDate])) AS [DiffSec],
			ROW_NUMBER() OVER(
				PARTITION BY
					[SC].[StockCode]
				ORDER BY
					ABS(DATEDIFF(SECOND, [SC].[TLStartDate], [Wip].[JobStartDate]))
			) AS [RnSubs]
		FROM
			@StockCodes AS [SC]
		LEFT JOIN
			[WipMaster] AS [Wip]
		ON
			[SC].[StockCode] = [Wip].[StockCode]




SELECT 'BEGIN ANSWER' AS [X]

SELECT
	[Operation]
	, [SrcB].[StockCode]
	, ISNULL([SrcB].[StockDescription], [MStockDes]) AS [StockDescription]
	, ISNULL([SrcB].[Job], [PurchaseOrder]) AS [JobOrPO]
	, ISNULL([JobStartDate], [MLatestDueDate]) AS [StartOrDueDate]
	, [Mat].[UnitQtyReqd]
	, [QtyOnHand]
	, [QtyOnOrder]
	, [QtyAllocatedWip]
	, [QtyIssued]
	--, [SrcB].[Warehouse]
	, [Inv].[Warehouse]
FROM (
	SELECT
		[SrcA].*
		,ROW_NUMBER() OVER(
				PARTITION BY
					[SrcA].[StockCode]
				ORDER BY
					ABS(DATEDIFF(SECOND, [SrcA].[TLStartDate], [Por].[MLatestDueDate]))
		) AS [RnPOs]
		, [Por].[PurchaseOrder]
		, [Por].[MLatestDueDate]
		, [Por].[MStockDes]
	FROM (
		SELECT
			[SC].[ID],
			[SC].[StockCode],
			[Wip].[StockDescription],
			[SC].[Operation],
			[SC].[TLStartDate],
			[Wip].[JobStartDate],
			[Wip].[Job],
			--[Warehouse],
			ABS(DATEDIFF(SECOND, [SC].[TLStartDate], [Wip].[JobStartDate])) AS [DiffSec],
			ROW_NUMBER() OVER(
				PARTITION BY
					[SC].[StockCode]
				ORDER BY
					ABS(DATEDIFF(SECOND, [SC].[TLStartDate], [Wip].[JobStartDate]))
			) AS [RnSubs]
		FROM
			@StockCodes AS [SC]
		LEFT JOIN
			[WipMaster] AS [Wip]
		ON
			[SC].[StockCode] = [Wip].[StockCode]
	) AS [SrcA]
	LEFT JOIN
		[PorMasterDetail] AS [Por]
	ON
		[SrcA].[StockCode] = [Por].[MStockCode]
		AND [SrcA].[Job] IS NULL
	WHERE
		[RnSubs] = 1
) AS [SrcB]
LEFT JOIN
	[WipJobAllMat] AS [Mat]
ON
	[SrcB].[StockCode] = [Mat].[StockCode]
	AND [SrcB].[Operation] = [Mat].[OperationOffset]
	AND [Mat].[Job] = @WO
LEFT JOIN
	[InvWarehouse] AS [Inv]
ON
	[SrcB].[StockCode] = [Inv].[StockCode]
	--AND ISNULL([SrcB].[Warehouse], [Inv].[Warehouse]) = [Inv].[Warehouse]
WHERE
	[RnPOs] = 1
	AND [Inv].[Warehouse] = @WH
ORDER BY
	[Operation]
	,[SrcB].[StockCode]