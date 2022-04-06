
SELECT TOP 5000 *
FROM
	[WipMaster] WITH (NOLOCK)
LEFT OUTER JOIN
	[WipJobAllMat] WITH (NOLOCK) 
ON
	[WipMaster].[Job] = [WipJobAllMat].[Job]
LEFT OUTER JOIN 
	[v_JobWIPValue] WITH (NOLOCK)
ON
	[WipMaster].[Job] = [v_JobWIPValue].[Job]
LEFT OUTER JOIN
	[InvMaster] WITH (NOLOCK)
ON
	[WipJobAllMat].[StockCode] = [InvMaster].[StockCode]
LEFT OUTER JOIN 
	[InvWarehouse] WITH (NOLOCK)
ON
	[WipJobAllMat].[StockCode] = [InvWarehouse].[StockCode]
	--AND [WipJobAllMat].[Warehouse] = [InvWarehouse].Warehouse -- For sure not this
LEFT OUTER JOIN
	[WipJobAllLab] WITH (NOLOCK)
ON
	[WipMaster].[Job] = [WipJobAllLab].[Job]
	AND [WipJobAllMat].[OperationOffset] = [WipJobAllLab].[Operation]
LEFT OUTER JOIN
	[PorMasterDetail] WITH (NOLOCK)
ON
	[WipJobAllMat].[StockCode] = [PorMasterDetail].[MStockCode]
	AND [WipJobAllMat].[Warehouse] = [PorMasterDetail].[MWarehouse]
	--AND [WipMaster].[StockCode] = [PorMasterDetail].[MWarehouse]