SELECT TOP 10000 [QtyOnHand]
, [PurchaseOrder]
, *
from WipMaster with (nolock)
left outer join WipJobAllMat with (nolock) on WipMaster.Job = WipJobAllMat.Job
left outer join v_JobWIPValue on WipMaster.Job = v_JobWIPValue.Job
left outer join InvMaster with (nolock) on WipJobAllMat.StockCode = InvMaster.StockCode
left outer join WipJobAllLab with (nolock) on WipMaster.Job = WipJobAllLab.Job
left outer join InvWarehouse with (nolock) on WipMaster.StockCode = InvWarehouse.StockCode
left outer join [PorMasterDetail] with (nolock) on WipMaster.StockCode = [PorMasterDetail].[MStockCode]
WHERE WipMaster.Job = '10015454'
--AND [QtyOnHand] > 0



DECLARE @WO AS NVARCHAR(MAX);
SET @WO = '10015454';
DECLARE @wos AS TABLE([Job#] INT, [Job] NVARCHAR(MAX));
INSERT INTO @wos SELECT * FROM [BWSdb].[dbo].[split_string_idx](@wo, ';');


--SELECT
--		1 AS [ph],
--		[WipMaster].[Job],
--		'M' AS [Part Category],
--		[Operation],
--		MIN([WipMaster].[JobStartDate]) AS [WipMaster.JobStartDate],
--		MIN([WipMaster].[Job]) AS [WipMaster.Job],
--		[WipJobAllMat].[StockCode] AS [WipMaster.StockCode],
--		[WipJobAllMat].[StockDescription] AS [WipMaster.StockDescription],
--		CAST(ROUND((QtyOnHand), 0) AS int) AS [QtyOnHand],
--		CAST(ROUND([QtyIssued], 0) AS int) AS [QtyIssued],
--		CAST(ROUND([UnitQtyReqd], 0) AS int) AS [QtyRequired],
--		CAST(ROUND(SUM([RunTimeIssued]), 2) AS decimal(14, 2)) AS [HrsIssued],
--		(CASE WHEN (CAST(ROUND([UnitQtyReqd], 0) AS int)) - CAST(ROUND([QtyIssued], 0) AS int) <= 0 THEN 'Y' else 'N' END) AS [Complete],
--		[WipMaster].[Warehouse] AS [Warehouse]
--		,[WipJobAllLab].[WorkCentre] AS [WorkCentre]
--		,[WipJobAllLab].[IMachine] AS [IMachine]
--	FROM
--		[WipJobAllMat] WITH (NOLOCK)
--	LEFT OUTER JOIN
--		[WipMaster] WITH (NOLOCK)
--	ON
--		[WipJobAllMat].[StockCode] = [WipMaster].[StockCode] and [WipJobAllMat].[Warehouse] = [WipMaster].[Warehouse]
--	LEFT OUTER  JOIN
--		[WipJobAllLab]
--	ON
--		[WipJobAllLab].[Job] = [WipMaster].[Job]
--	LEFT OUTER  JOIN
--		[InvWarehouse]
--	ON
--		[InvWarehouse].[StockCode] = [WipMaster].[StockCode] and [InvWarehouse].[Warehouse] = [WipMaster].[Warehouse]
--	WHERE
--		[WipJobAllMat].[Job] IN (SELECT [Job] FROM @wos)
--	GROUP BY
--		[WipMaster].[Job],
--		[WipJobAllMat].[StockCode],
--		[WipJobAllMat].[StockDescription],
--		[WipMaster].[Warehouse]
--		,[WipJobAllLab].[WorkCentre]
--		,[WipJobAllLab].[IMachine]
	
--		,[Operation]
--		,[UnitQtyReqd]
--		,[QtyIssued]
--		,[QtyOnHand]
--	--ORDER BY
--	--	[WipMaster.JobStartDate]
--	ORDER BY [WipMaster.StockCode]


SELECT * FROM (

SELECT
	ROW_NUMBER() OVER (
		PARTITION BY
			[WipJobAllMat].[StockCode],
			[WipJobAllMat].[StockDescription]
		ORDER BY
			[WipMaster].[JobStartDate]
	) AS [Row#],
		1 AS [ph],
		[WipMaster].[Job],
		'M' AS [Part Category],
		[Operation],
		MIN([WipMaster].[JobStartDate]) AS [WipMaster.JobStartDate],
		MIN([WipMaster].[Job]) AS [WipMaster.Job],
		[WipJobAllMat].[StockCode] AS [WipMaster.StockCode],
		[WipJobAllMat].[StockDescription] AS [WipMaster.StockDescription],
		CAST(ROUND((QtyOnHand), 0) AS int) AS [QtyOnHand],
		CAST(ROUND([QtyIssued], 0) AS int) AS [QtyIssued],
		CAST(ROUND([UnitQtyReqd], 0) AS int) AS [QtyRequired],
		CAST(ROUND(SUM([RunTimeIssued]), 2) AS decimal(14, 2)) AS [HrsIssued],
		(CASE WHEN (CAST(ROUND([UnitQtyReqd], 0) AS int)) - CAST(ROUND([QtyIssued], 0) AS int) <= 0 THEN 'Y' else 'N' END) AS [Complete],
		[WipMaster].[Warehouse] AS [Warehouse]
		,[WipJobAllLab].[WorkCentre] AS [WorkCentre]
		,[WipJobAllLab].[IMachine] AS [IMachine]
		,[PurchaseOrder]
	FROM
		[WipJobAllMat] WITH (NOLOCK)
	LEFT OUTER JOIN
		[WipMaster] WITH (NOLOCK)
	ON
		[WipJobAllMat].[StockCode] = [WipMaster].[StockCode] and [WipJobAllMat].[Warehouse] = [WipMaster].[Warehouse]
	LEFT OUTER JOIN
		[WipJobAllLab]
	ON
		[WipJobAllLab].[Job] = [WipMaster].[Job]
	LEFT OUTER JOIN
		[InvWarehouse]
	ON
		[InvWarehouse].[StockCode] = [WipMaster].[StockCode] and [InvWarehouse].[Warehouse] = [WipMaster].[Warehouse]
	LEFT OUTER JOIN
		[PorMasterDetail]
	ON	
		[WipMaster].[StockCode] = [PorMasterDetail].[MStockCode]
	WHERE
		[WipJobAllMat].[Job] IN (SELECT [Job] FROM @wos)
		AND ([JobStartDate] > DATEADD(YEAR, -1, GETDATE()) OR [JobStartDate] IS NULL)
	GROUP BY
		[WipMaster].[Job],
		[WipJobAllMat].[StockCode],
		[WipJobAllMat].[StockDescription],
		
		[WipMaster].[JobStartDate],
		[WipMaster].[Warehouse]
		,[WipJobAllLab].[WorkCentre]
		,[WipJobAllLab].[IMachine]
	
		,[Operation]
		,[UnitQtyReqd]
		,[QtyIssued]
		,[QtyOnHand]
		,[PurchaseOrder]
	--ORDER BY
	--	[WipMaster.JobStartDate]
) AS [Src]
WHERE
	[Src].[Row#] = 1
ORDER BY [WipMaster.StockCode]