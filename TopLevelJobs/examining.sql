

DECLARE @SD AS DATETIME;
DECLARE @ED AS DATETIME;

DECLARE @week_or_2weeks AS BIT;  -- 1 for 1 week, 0 for 2 weeks
SELECT @week_or_2weeks = 1


IF @week_or_2weeks = 1 BEGIN
	SELECT @SD = DATEADD(DAY, -3, GETDATE());
	SELECT @ED = DATEADD(DAY, 4, GETDATE());
END
ELSE BEGIN
	SELECT @SD = DATEADD(DAY, -6, GETDATE());
	SELECT @ED = DATEADD(DAY, 7, GETDATE());
END


SELECT
	*
	, 0 AS [F_TopLevelJobComplete]
	, 0 AS [F_SubLevelJobComplete]
	, 0 AS [F_SubLevelPartComplete]
FROM (
	SELECT
		COUNT(*) AS [C]
		, [WipJobAllMat].[Job] AS [F_WipJobAllMat_Job]
		, [WipJobAllLab].[Job] AS [F_WipJobAllLab_Job]
		, [WipMaster].[Job] AS [F_WipMaster_Job]
		, [WipMaster].[StockCode] AS [F_StockCode]
		, [WipMaster].[Warehouse] AS [F_Warehouse]
		, [Operation] AS [F_Operation]
		, [PlannedStartDate] AS [F_PlannedStartDate]
		, [WipMaster].[QtyToMake] AS [F_QtyToMake]
		, [WipMaster].[QtyManufactured] AS [F_QtyManufactured]
		, [WipMaster].[TotalQtyScrapped] AS [F_TotQtyScrapped]
	
		, [WipJobAllMat].[NetUnitQtyReqd] AS [F_I need this many]
		, [WipJobAllMat].[NetUnitQtyReqdEnt] AS [F_]
		, [JobDescription] AS [F_JobDescription]
		, [WipMaster].[StockDescription] AS [F_StockDescription]
		, [Production].[Model No] AS [F_ModelNo]
		, [Complete] AS [F_Complete]

		--, [ActCompleteDate]
		--, [AllocCompleted]
		--, [Axle Complete]
		--, [Beam Complete]
		--, [Blast Complete]
		--, [CompletedJobFlag]
		--, [Date Completed]
		--, [GN Complete]
		--, [WipJobAllLab].[OperCompleted]
		--, [Other Complete]
		--, [Paint Complete]
		--, [PctCompleteFlag]
		--, [PiecesCompleted]
		--, [Prod Complete]
		--, [Prod2 Complete]
		--, [QtyCompleted]
		--, [QtyCompletedEnt]


		--, [WipMaster].[GrossQty]
		--, [WipMaster].[GrossQtyEnt]
		--, [WipMaster].[QtyManufactured]
		--, [WipMaster].[QtyManufacturedEnt]
		--, [WipMaster].[QtyToMake]
		--, [WipMaster].[QtyToMakeEnt]
		--, [WipMaster].[TotalQtyScrapped]
		--, [WipMaster].[TotQtyScrappedEnt]
	
		--, [WipJobAllMat].[FixedQtyPer]
		--, [WipJobAllMat].[FixedQtyPerEnt]
		----, [WipJobAllMat].[FixedQtyPerFlag]
		--, [WipJobAllMat].[NetUnitQtyReqd]
		--, [WipJobAllMat].[NetUnitQtyReqdEnt]
		--, [WipJobAllMat].[QtyBilled]
		--, [WipJobAllMat].[QtyBilledEnt]
		--, [WipJobAllMat].[QtyIssued]
		--, [WipJobAllMat].[QtyIssuedEnt]
		--, [WipJobAllMat].[QtyOutstanding]
		--, [WipJobAllMat].[QtyOutstandingEnt]
		--, [WipJobAllMat].[QtyReserved]
		--, [WipJobAllMat].[QtyReservedEnt]
		--, [WipJobAllMat].[QtyToIssue]
		--, [WipJobAllMat].[QtyToIssueEnt]
		--, [WipJobAllMat].[QtyTotRequired]
		--, [WipJobAllMat].[QtyTotRequiredEnt]
		--, [WipJobAllMat].[ReservedLotQty]
		--, [WipJobAllMat].[ReservedSerQty]
		--, [WipJobAllMat].[ScrapQuantity]
		--, [WipJobAllMat].[ScrapQuantityEnt]
		--, [WipJobAllMat].[UnitQtyReqd]
		--, [WipJobAllMat].[UnitQtyReqdEnt]
	
		--, [WipJobAllLab].[IStartupQty]
		--, [WipJobAllLab].[IStartupQtyEnt]
		--, [WipJobAllLab].[OperYieldQty]
		--, [WipJobAllLab].[OperYieldQtyEnt]
		--, [WipJobAllLab].[ParentQtyPlanEnt]
		--, [WipJobAllLab].[ParentQtyPlanned]
		--, [WipJobAllLab].[ParIssQty]
		--, [WipJobAllLab].[ParIssQtyEnt]
		--, [WipJobAllLab].[QtyCompleted]
		--, [WipJobAllLab].[QtyCompletedEnt]
		--, [WipJobAllLab].[QtyScrapped]
		--, [WipJobAllLab].[QtyScrappedEnt]
		--, [WipJobAllLab].[QueueTime]
		--, [WipJobAllLab].[SubQtyPer]
		--, [WipJobAllLab].[ToolSetQty]
		--, [WipJobAllLab].[TransferQtyOrPct]
		--, [WipJobAllLab].[TransferQtyPct]
		--, [WipJobAllLab].[TransferQtyPctEnt]
		--, *
	FROM
		[SysproCompanyA].[dbo].[WipMaster] WITH (NOLOCK)
	INNER JOIN
		[SysproCompanyA].[dbo].[WipJobAllMat] WITH (NOLOCK)
	ON
		[WipMaster].[StockCode] = [WipJobAllMat].[StockCode]
	INNER JOIN
		[SysproCompanyA].[dbo].[WipJobAllLab] WITH (NOLOCK)
	ON
		[WipJobAllMat].[OperationOffset] = [WipJobAllLab].[Operation]
		AND [WipJobAllMat].[Job] = [WipJobAllLab].[Job]
	LEFT JOIN	
		[BWSdb].[dbo].[Production]
	ON
		[WipJobAllMat].[Job] = CAST([Production].[WO#] AS NVARCHAR(8))
	WHERE
		LEFT([WipJobAllMat].[Job], 1) = '1'
		AND (([WipJobAllLab].[PlannedStartDate] >= @SD)
			OR
			[WipJobAllLab].[PlannedStartDate] IS NULL)
	GROUP BY
	
		[WipJobAllMat].[Job]
		, [WipJobAllLab].[Job]
		, [WipMaster].[Job]
		, [WipMaster].[StockCode]
		, [WipMaster].[Warehouse]
		, [Operation]
		, [PlannedStartDate]
		, [WipMaster].[QtyToMake]
		, [WipMaster].[QtyManufactured]
		, [WipMaster].[TotalQtyScrapped]
	
		, [WipJobAllMat].[NetUnitQtyReqd]
		, [WipJobAllMat].[NetUnitQtyReqdEnt]
		, [JobDescription]
		, [WipMaster].[StockDescription]
		, [Production].[Model No]
		, [Complete]
) AS [Sub1]

--WHERE
--	ISNULL([F_Complete], 'N') <> 'Y'


ORDER BY
	[F_PlannedStartDate]
	, [F_WipJobAllMat_Job]
	--, [WipJobAllLab].[Operation]
	, [F_WipMaster_Job]
	, [F_StockCode]

--	, [Operation]

;