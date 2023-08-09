
USE SysproCompanyA
GO


-- 2023-08-08 1837
-- 






DECLARE
	@WO VARCHAR(MAX);
SELECT
@WO='10016619'

SELECT
	*
FROM
	[WipJobAllMat]
WHERE
	[WipJobAllMat].[Job] = @WO

-- Unique Parts in this WO
SELECT
	'R' AS [T]
	, [Wip].[Job] AS [WipJob]
	, [Wip].[Customer]
	, [Por].[PurchaseOrder]
	, [Wip].[JobStartDate]
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

LEFT JOIN
	[PorMasterDetail] AS [Por]
ON
	[Whs].[StockCode] = [Por].[MStockCode]
	--AND [Mat].[Job] = [Por].[MJob]
	AND [Wip].[Job] = [Por].[MJob]

--INNER JOIN
--	[WipJobAllLab] AS [Lab]
--ON
--	[Mat].[Job] = [Lab].[Job]
	--AND [Mat].[StockCode] = [Lab].[
WHERE
	[Mat].[Job] = @WO
	--AND ISNULL([Wip].[Complete], 'N') = 'N'
GROUP BY
	[Wip].[Job]
	, [Wip].[Job]
	, [Wip].[Customer]
	, [Por].[PurchaseOrder]
	, [Wip].[JobStartDate]
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
ORDER BY
	[OperationOffset]
	, [StockCode]

	
SELECT
	'WipMaster' AS [T], 
	*
FROM 
	[WipMaster] 
WHERE 
	[MasterJob] = @WO
	OR [Job] LIKE '%' + @WO + '%'
	
SELECT
	'WipJobAllMat' AS [T], 
	*
FROM 
	[WipJobAllMat] 
WHERE 
	[Job] = @WO

SELECT
	'WipJobAllLab' AS [T], 
	*
FROM 
	[WipJobAllLab] 
WHERE 
	[Job] = @WO
	
SELECT 'v_JobWIPValue' AS [T], * FROM v_JobWIPValue WHERE [Job] = @WO;
SELECT 'PorMasterDetail' AS [T], * FROM [PorMasterDetail] WHERE ISNULL([MJob], '') <> '' -- [MJob] = @WO;