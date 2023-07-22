DECLARE
	@wo VARCHAR(8),
	@io BIT,
	@sc NVARCHAR(MAX)
;
SET @wo = '10016619';
SET @io = 0;
SET @sc = '40960709';


SELECT
	0 AS [ph],
	1 AS [MadeIn],
	MAX([WipMaster].[JobStartDate]) AS [WipMaster.JobStartDate],
	MAX([WipMaster].[Job]) AS [WipMaster.Job],
	[WipJobAllMat].[StockCode] AS [WipMaster.StockCode],
	[WipJobAllMat].[StockDescription] AS [WipMaster.StockDescription],
	CAST(ROUND(AVG(QtyOnHand), 0) AS int) AS [QtyOnHand],
	CAST(ROUND(AVG([QtyIssued]), 0) AS int) AS [QtyIssued],
	CAST(ROUND(AVG([UnitQtyReqd]), 0) AS int) AS [QtyRequired],
	CAST(ROUND(SUM([RunTimeIssued]), 2) AS decimal(14, 2)) AS [HrsIssued],
	(CASE WHEN (CAST(ROUND(AVG([UnitQtyReqd]), 0) AS int)) - CAST(ROUND(AVG([QtyIssued]), 0) AS int) <= 0 THEN 'Y' else 'N' END) AS [Complete],
	[WipMaster].[Warehouse] AS [Warehouse]
FROM
	[WipJobAllMat] WITH (NOLOCK)
INNER JOIN
	[WipMaster] WITH (NOLOCK)
ON
	[WipJobAllMat].[StockCode] = [WipMaster].[StockCode]
	AND [WipJobAllMat].[Warehouse] = [WipMaster].[Warehouse]
INNER JOIN
	[WipJobAllLab]
ON
	[WipJobAllLab].[Job] = [WipMaster].[Job]
INNER JOIN
	[InvWarehouse]
ON
	[InvWarehouse].[StockCode] = [WipMaster].[StockCode] 
	AND [InvWarehouse].[Warehouse] = [WipMaster].[Warehouse]
WHERE
	[WipJobAllMat].[Job] = @wo
	AND ((@io = 1 AND [WipMaster].[Complete] = 'N') OR @io = 0)
	AND QtyOnHand = 0
	and WipMaster.Job not in ('10015030', '10015031', '10015032')
GROUP BY
	[WipJobAllMat].[StockCode], [WipJobAllMat].[StockDescription], [WipMaster].[Warehouse]


-- All StockCodes in a given WO
SELECT 
	*
FROM 
	[WipJobAllMat]
WHERE
	[Job] = @wo
;


SELECT 'STARTING STOCKCODE MATCHING' AS [X]

-- Next job for this stock code with 0 value issued.
SELECT TOP 1 
	[Mat].[Job]
	, [StockCode]
	, [Warehouse]
	, [StockDescription]
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
	, [WorkCentre]
FROM
	[WipJobAllMat] AS [Mat]
INNER JOIN
	[WipJobAllLab] AS [Lab]
ON
	[Mat].[Job] = [Lab].[Job]
WHERE
	[StockCode] = @sc
	--AND [QtyIssued] <> [UnitQtyReqd]
	--AND [ActualFinishDate] IS NULL
	--AND [PlannedStartDate] BETWEEN DATEADD(MONTH, -6, GETDATE()) AND DATEADD(YEAR, 5, GETDATE())
ORDER BY
	[PlannedStartDate]
;

-- Next Job to Start for this stockcode that has not already been finished
-- AND has a planned start date between 3 months ago and 5 years into the future.
-- AND has not already been given the part in question.
SELECT TOP 1 
	[Mat].[Job]
	, [StockCode]
	, [Warehouse]
	, [StockDescription]
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
	, [WorkCentre]
FROM
	[WipJobAllMat] AS [Mat]
INNER JOIN
	[WipJobAllLab] AS [Lab]
ON
	[Mat].[Job] = [Lab].[Job]
WHERE
	[StockCode] = @sc
	--AND [QtyIssued] <> [UnitQtyReqd]
	--AND [ActualFinishDate] IS NULL
	--AND [PlannedStartDate] BETWEEN DATEADD(MONTH, -6, GETDATE()) AND DATEADD(YEAR, 5, GETDATE())
ORDER BY
	[PlannedStartDate]
;

SELECT
	*
FROM
	[SalProductClass]
--WHERE
--	LOWER([Description]) LIKE '%laser%'
ORDER BY
	[ProductClass]

SELECT
	*
FROM
	[SalBranch]

-- Get Partcategory for a stockcode.
SELECT
	[PartCategory]
	,[ProductClass]
	,[ProductGroup]
	, *
FROM
	[InvMaster]
WHERE
	[StockCode] = @sc
;

-- Last unfulfilled PO for a stock code
SELECT	
	*
FROM (
	SELECT	
		*
		, ROW_NUMBER() OVER(
			PARTITION BY
				[MStockCode]
			ORDER BY
				[MLatestDueDate] DESC
		) AS [Rn]
	FROM
		[PorMasterDetail]
	WHERE
		[MStockCode] = @sc
		--AND [MReceivedQty] < [MOrderQty]
) AS [SrcA]
--WHERE
--	[Rn] = 1
;

--SELECT TOP 10 * FROM [WipMaster]
SELECT * FROM [WipMaster] WHERE [StockCode] = @sc

-- Last unfulfilled PO for a stock code
SELECT	
	*
FROM (
	SELECT	
		*
		, ROW_NUMBER() OVER(
			PARTITION BY
				[StockCode]
			ORDER BY
				[WipMaster].[JobTenderDate] DESC
				, [WipMaster].[ActCompleteDate] DESC
		) AS [Rn]
	FROM
		[WipMaster]
	WHERE
		[StockCode] = @sc
		--AND [Complete] <> 'Y'
) AS [SrcA]
WHERE
	[Rn] = 1
;

SELECT
	'[WipMaster]' AS [T]
	,*
FROM
	[WipMaster]
WHERE
	[StockCode] = @sc

SELECT
	'[InvMaster]' AS [T]
	,*
FROM
	[InvMaster]
WHERE
	[StockCode] = @sc

SELECT
	'[InvWarehouse]' AS [T]
	,*
FROM
	[InvWarehouse]
WHERE
	[StockCode] = @sc

SELECT
	'[PorMasterDetail]' AS [T]
	,*
FROM
	[PorMasterDetail]
WHERE
	[MStockCode] = @sc

SELECT
	'[WipJobAllMat]' AS [T]
	,*
FROM
	[WipJobAllMat]
WHERE
	[StockCode] = @sc