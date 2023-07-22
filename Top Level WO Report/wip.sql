USE SysproCompanyA
GO


DECLARE
	@wo VARCHAR(8),
	@sc VARCHAR(8),
	@io BIT,
	@lb INT,
	@ub INT
;
SET @wo = '10016619';
SET @sc = '40960709';
SET @io = 0;
SET @lb = -8; -- backward 8 months for POs, 80 for WipMaster Job Lookups
SET @ub = 60; -- forward 60 months for POs, 600 for WipMaster Job Lookups

SELECT
	*
FROM (
	SELECT 
		[Mat].[Job] AS [MatJob]
		, [Wip].[Job] AS [WipJob]
		, [Wip].[Rn] AS [WipRn]
		, [Por].[Rn] AS [PorRn]
		, [PartCategory]
		, [Mat].[Warehouse]
		, [Mat].[StockCode]
		, [Mat].[StockDescription]
		, [QtyIssued]
		, [UnitQtyReqd]
		, [OperationOffset]
		, [IMachine]
		, [RunTimeIssued]
		, [IExpUnitRunTimEnt]
		, [PlannedQueueDate]
		, [PlannedStartDate]
		, [PlannedEndDate]
		, [ActualQueueDate]
		, [ActualStartDate]
		, [ActualFinishDate]
		, [Wip].[JobTenderDate]
		, [Wip].[ActCompleteDate]
		, [Por].[MLatestDueDate]
		, [Operation]
		, [WorkCentre]
		, (CASE WHEN [PartCategory] = 'B' THEN [PurchaseOrder] ELSE '' END) AS [PO]
		, (CASE WHEN [Wip].[Job] IS NOT NULL THEN [Wip].[Job] ELSE '' END) AS [SubWO]
		, (CASE WHEN [Por].[MLatestDueDate] IS NULL THEN 'A | ' + [Wip].[Job]
				WHEN [Wip].[JobTenderDate] IS NULL THEN 'B | ' + [Por].[PurchaseOrder]
				WHEN ISNULL([Por].[MLatestDueDate], GETDATE()) <= ISNULL([Wip].[ActCompleteDate], GETDATE())
						--AND [Por].[MLatestDueDate] < [Wip].[JobTenderDate] 
						THEN
					'C | ' + [Por].[PurchaseOrder]
				ELSE 'D | ' + [Wip].[Job]
			END) AS [SubWO_OR_PO]
	FROM 
		[WipJobAllMat] AS [Mat] WITH (NOLOCK)
	LEFT JOIN (
		SELECT	
			[Job]
			, [StockCode]
			, [Warehouse]
			, [JobTenderDate]
			, [ActCompleteDate]
			, ROW_NUMBER() OVER(
				PARTITION BY
					[StockCode]
				ORDER BY
					[WipMaster].[JobTenderDate] DESC
					, [WipMaster].[ActCompleteDate] DESC
			) AS [Rn]
		FROM
			[WipMaster] WITH (NOLOCK)
		--WHERE
		--	[JobTenderDate] BETWEEN DATEADD(MONTH, 10 * @lb, GETDATE()) AND DATEADD(MONTH, 2 * @ub, GETDATE())
		--	OR [ActCompleteDate] BETWEEN DATEADD(MONTH, 10 * @lb, GETDATE()) AND DATEADD(MONTH, 2 *@ub, GETDATE())
	) AS [Wip]
	ON
		(
			[Mat].[StockCode] = [Wip].[StockCode]
			AND [Mat].[Warehouse] = [Wip].[Warehouse]
		)
		OR (
			[Mat].[Job] = [Wip].[Job]
			--AND [Mat].[StockCode] = [Wip].[StockCode]
			--AND [Mat].[Warehouse] = [Wip].[Warehouse]
		)

	LEFT JOIN
		[WipJobAllLab] AS [Lab] WITH (NOLOCK)
	ON
		[Mat].[Job] = [Lab].[Job]
		AND [Lab].[Operation] = [Mat].[OperationOffset]
	LEFT JOIN
		[InvMaster] AS [Inv] WITH (NOLOCK)
	ON
		[Mat].[StockCode] = [Inv].[StockCode]
	LEFT JOIN (
		SELECT	
			*
			, ROW_NUMBER() OVER(
				PARTITION BY
					[MStockCode]
				ORDER BY
					[MLatestDueDate] DESC
			) AS [Rn]
		FROM
			[PorMasterDetail] WITH (NOLOCK)
		WHERE
			[MReceivedQty] < [MOrderQty]
	) AS [Por]
	ON
		[Por].[MStockCode] = [Mat].[StockCode]
	WHERE
		[Mat].[Job] = @wo
		AND ISNULL([Por].[Rn], 1) = 1
		AND ISNULL([Wip].[Rn], 1) = 1
		AND (CASE
			WHEN [Wip].[Job] IS NOT NULL THEN
				(CASE
					WHEN [Wip].[Rn] = 1 THEN 1 
					ELSE 0 
				END)
				ELSE 1
			END) = 1
		--AND [Mat].[StockCode] = '40946379'
		--AND [Mat].[StockCode] = '40946387'
) AS [SrcA]
----WHERE
----	ISNULL([PO], '') + ISNULL([SubWO], '') = ''
--ORDER BY
--	[Operation]
--	, [StockCode]
--	, [UnitQtyReqd] DESC
WHERE
	1=1
	--AND
	--[StockCode] = @sc
--ORDER BY
--	[SubWO_OR_PO]
ORDER BY
	[StockCode]
;