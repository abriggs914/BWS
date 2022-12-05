USE SysproCompanyA
GO

SELECT
	'InvMaster' AS [Table]
	, *
FROM
	[InvMaster] WITH (NOLOCK)
;

SELECT
	'MrpJobMaster' AS [Table]
	, *
FROM
	[MrpJobMaster] WITH (NOLOCK)
;

SELECT
	'WipJobAllMat' AS [Table]
	, *
FROM
	[WipJobAllMat] WITH (NOLOCK)
;

---- Dead End # 1

--SELECT
--	'WipMaster' AS [Table]
--	, *
--FROM
--	[WipMaster] WITH (NOLOCK)
--WHERE 
--	[MasterJob] IS NOT NULL AND [MasterJob] <> ''
--;



-- What are my sub jobs

SELECT
	[WipJobAllMat].[Job]
	, [WipMaster].[StockCode]
	, [WipMaster].[Warehouse]
	, [Operation]
	, [PlannedStartDate]
	, *
FROM
	[WipMaster] WITH (NOLOCK)
INNER JOIN
	[WipJobAllMat] WITH (NOLOCK)
	ON [WipMaster].[StockCode] = [WipJobAllMat].[StockCode]
INNER JOIN
	[WipJobAllLab] WITH (NOLOCK)
	ON [WipJobAllMat].[OperationOffset] = [WipJobAllLab].[Operation]
	AND [WipJobAllMat].[Job] = [WipJobAllLab].[Job]
WHERE
	LEFT([WipJobAllMat].[Job], 1) = '1'
;


-- list of all stockcodes broken down into sub jobs ordered by startdate, job, operation, stockcode
-- Need to identify:
--		how many are needed to make
--		how many have been made
--		how many needed to make
--		how many scrapped

-- THEN
-- compare to the list of available inventory

SELECT
	[WipJobAllMat].[Job] AS [WipJobAllMat_Job]
	, [WipJobAllLab].[Job] AS [WipJobAllLab_Job]
	, [WipMaster].[Job] AS [WipMaster_Job]
	, [WipMaster].[StockCode] AS [F_StockCode]
	, [WipMaster].[Warehouse] AS [F_Warehouse]
	, [Operation] AS [F_Operation]
	, [PlannedStartDate] AS [F_PlannedStartDate]
	, [WipMaster].[QtyToMake] AS [F_QtyToMake]
	, [WipMaster].[QtyManufactured] AS [F_QtyManufactured]
	, [WipMaster].[TotalQtyScrapped] AS [F_TotQtyScrapped]
	
	, [WipJobAllMat].[NetUnitQtyReqd] AS [F_I need this many]
	, [WipJobAllMat].[NetUnitQtyReqdEnt] AS [F_]


	, [WipMaster].[GrossQty]
	, [WipMaster].[GrossQtyEnt]
	, [WipMaster].[QtyManufactured]
	, [WipMaster].[QtyManufacturedEnt]
	, [WipMaster].[QtyToMake]
	, [WipMaster].[QtyToMakeEnt]
	, [WipMaster].[TotalQtyScrapped]
	, [WipMaster].[TotQtyScrappedEnt]
	
	, [WipJobAllMat].[FixedQtyPer]
	, [WipJobAllMat].[FixedQtyPerEnt]
	--, [WipJobAllMat].[FixedQtyPerFlag]
	, [WipJobAllMat].[NetUnitQtyReqd]
	, [WipJobAllMat].[NetUnitQtyReqdEnt]
	, [WipJobAllMat].[QtyBilled]
	, [WipJobAllMat].[QtyBilledEnt]
	, [WipJobAllMat].[QtyIssued]
	, [WipJobAllMat].[QtyIssuedEnt]
	, [WipJobAllMat].[QtyOutstanding]
	, [WipJobAllMat].[QtyOutstandingEnt]
	, [WipJobAllMat].[QtyReserved]
	, [WipJobAllMat].[QtyReservedEnt]
	, [WipJobAllMat].[QtyToIssue]
	, [WipJobAllMat].[QtyToIssueEnt]
	, [WipJobAllMat].[QtyTotRequired]
	, [WipJobAllMat].[QtyTotRequiredEnt]
	, [WipJobAllMat].[ReservedLotQty]
	, [WipJobAllMat].[ReservedSerQty]
	, [WipJobAllMat].[ScrapQuantity]
	, [WipJobAllMat].[ScrapQuantityEnt]
	, [WipJobAllMat].[UnitQtyReqd]
	, [WipJobAllMat].[UnitQtyReqdEnt]
	
	, [WipJobAllLab].[IStartupQty]
	, [WipJobAllLab].[IStartupQtyEnt]
	, [WipJobAllLab].[OperYieldQty]
	, [WipJobAllLab].[OperYieldQtyEnt]
	, [WipJobAllLab].[ParentQtyPlanEnt]
	, [WipJobAllLab].[ParentQtyPlanned]
	, [WipJobAllLab].[ParIssQty]
	, [WipJobAllLab].[ParIssQtyEnt]
	, [WipJobAllLab].[QtyCompleted]
	, [WipJobAllLab].[QtyCompletedEnt]
	, [WipJobAllLab].[QtyScrapped]
	, [WipJobAllLab].[QtyScrappedEnt]
	, [WipJobAllLab].[QueueTime]
	, [WipJobAllLab].[SubQtyPer]
	, [WipJobAllLab].[ToolSetQty]
	, [WipJobAllLab].[TransferQtyOrPct]
	, [WipJobAllLab].[TransferQtyPct]
	, [WipJobAllLab].[TransferQtyPctEnt]
	, *
FROM
	[WipMaster] WITH (NOLOCK)
INNER JOIN
	[WipJobAllMat] WITH (NOLOCK)
ON
	[WipMaster].[StockCode] = [WipJobAllMat].[StockCode]
INNER JOIN
	[WipJobAllLab] WITH (NOLOCK)
ON
	[WipJobAllMat].[OperationOffset] = [WipJobAllLab].[Operation]
	AND [WipJobAllMat].[Job] = [WipJobAllLab].[Job]
WHERE
	LEFT([WipJobAllMat].[Job], 1) = '1'
	AND ([PlannedStartDate] >= DATEADD(DAY, -14, GETDATE())
		OR
		[PlannedStartDate] IS NULL)
ORDER BY
	[WipJobAllLab].[PlannedStartDate]
	, [WipJobAllMat].[Job]
	--, [WipJobAllLab].[Operation]
	, [WipMaster].[Job]
	, [WipJobAllMat].[StockCode]

	, [Operation]

;



-- All Inventory
SELECT
	[InvMaster].[StockCode]
	, [Description]
	, [LongDesc]
	, [Warehouse]
	, [QtyOnHand]
	, [QtyOnOrder]
	, [QtyOnBackOrder]
	, [QtyAllocated]
	, [QtyAllocated] - ([QtyOnHand] + [QtyOnOrder] + [QtyOnBackOrder]) AS [CalcAvailable]
	--, *
FROm
	[InvWarehouse]
INNER JOIN
	[InvMaster]
ON
	[InvWarehouse].[StockCode] = [InvMaster].[StockCode]
--WHERE 


-- All AVAILABLE Inventory
SELECT
	*
FROM (
	SELECT
		*
		, [CalcOwned] - [QtyAllocated] AS [CalcAvailable]
	FROM (
		SELECT
			[InvMaster].[StockCode]
			, [Description]
			, [LongDesc]
			, [Warehouse]
			, [QtyOnHand]
			, [QtyOnOrder]
			, [QtyOnBackOrder]
			, [QtyAllocated]
			, ([QtyOnHand] + [QtyOnOrder] + [QtyOnBackOrder]) AS [CalcOwned]
			--, *
		FROm
			[InvWarehouse]
		INNER JOIN
			[InvMaster]
		ON
			[InvWarehouse].[StockCode] = [InvMaster].[StockCode]
		
	) AS [Sub1]
	WHERE
		[CalcOwned] > 0
) AS [Sub2]
WHERE
	[CalcAvailable] > 0
;


DECLARE @SD AS DATETIME;
DECLARE @ED AS DATETIME;
SELECT @SD = DATEADD(DAY, -6, GETDATE());
SELECT @ED = DATEADD(DAY, 7, GETDATE());

SELECT
	*
FROM 
	[BWSdb].[dbo].[Production]
WHERE
	ISNULL([Prod Date], [Prod Date2]) BETWEEN @SD AND @ED
;

