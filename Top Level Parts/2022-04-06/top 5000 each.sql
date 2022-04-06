
SELECT TOP 5000 *
FROM
	[WipMaster] WITH (NOLOCK)

SELECT TOP 5000 *
FROM
	[WipJobAllMat] WITH (NOLOCK) 
--ON
--	[WipMaster].[Job] = [WipJobAllMat].[Job]

SELECT TOP 5000 *
FROM
	[WipJobAllLab] WITH (NOLOCK)
--ON
--	[WipMaster].[Job] = [WipJobAllLab].[Job]
--	AND [WipJobAllMat].[OperationOffset] = [WipJobAllLab].[Operation]

SELECT TOP 5000 *
FROM
	[v_JobWIPValue] WITH (NOLOCK)
--ON
--	[WipMaster].[Job] = [v_JobWIPValue].[Job]

SELECT TOP 5000 *
FROM
	[InvMaster] WITH (NOLOCK)
--ON
--	[WipJobAllMat].[StockCode] = [InvMaster].[StockCode]

SELECT TOP 5000 *
FROM
	[InvWarehouse] WITH (NOLOCK)
--ON
--	[WipJobAllMat].[StockCode] = [InvWarehouse].[StockCode]
--	--AND [WipJobAllMat].[Warehouse] = [InvWarehouse].Warehouse -- For sure not this

SELECT TOP 5000 *
FROM
	[PorMasterDetail] WITH (NOLOCK)
--ON
--	[WipJobAllMat].[StockCode] = [PorMasterDetail].[MStockCode]
--	AND [WipJobAllMat].[Warehouse] = [PorMasterDetail].[MWarehouse]
--	--AND [WipMaster].[StockCode] = [PorMasterDetail].[MWarehouse]