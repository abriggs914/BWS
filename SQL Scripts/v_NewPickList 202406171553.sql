USE [SysproCompanyS]
GO

/****** Object:  View [dbo].[v_NewPickList]    Script Date: 2024-06-17 3:16:43 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- 2022-09-27 James Crawford - Added JobDescription and SubWOJobDescription fields to match Stargate side
-- Also adjusted layout and made sure the Bin column was changed to DefaultBin (InvWarehouse) instead of Bin (WipJobAllMat)
-- IT Request #000972
-- 2022-09-28 James Crawford - Added where clause to exclude 3 Half Round Work Orders from reports: 10015030 - 10015032
-- IT Request #001197
-- 2022-10-05 James Crawford - Added LongDesc and Warehouse fields
-- Added where clause to exclude any stock codes where Warehouse = 99 OR Bin Location = "BFLUSH"
-- ^ ****** Ended up changing this to exclude any stock codes where Warehouse = 99 and Planner = 5 later on! ******
-- IT Request #000972
-- 2024-06-12 Avery Briggs - copied functionality from BWS side of things
-- 2024-06-17 Avery Briggs - Operation Names

ALTER VIEW [dbo].[v_NewPickList] AS
SELECT 
	[WipMaster].[Job]
	, [WipJobAllMat].[StockCode]
	, [WipJobAllMat].[StockDescription]
	, [InvMaster].[LongDesc]
	, [WipJobAllMat].[Warehouse]
	, [WipMaster].[JobDescription]
	, CAST([UnitQtyReqd] * [WipMaster].[QtyToMake] AS DECIMAL(18, 2)) AS [UnitQtyReqd]
	, [OperationOffset]
	, [Uom]
	, [DefaultBin] AS [Bin]
	, [QtyIssued]
	, [ProductClass]
	, [SubJob].[Job] AS [SubWO]
	, [SubJob].[JobDescription] AS [SubWOJobDescription]
	, [QtyOnHand] - [QtyAllocated] AS [QtyAvailable]
	--, [BomMachine].[Description]
	--, [BomMachine].[WorkCentre]
	--, [WipJobAllLab].[IMachine]
	, [WipJobAllLab].[WorkCentreDesc]
	--, [WipJobAllLab].[WorkCentre]
	,[ON].[OperationDescription]
FROM
	[SysproCompanyS].[dbo].[WipMaster] WITH (NOLOCK)
INNER JOIN
	[SysproCompanyS].[dbo].[WipJobAllMat] WITH (NOLOCK)
on 
	[WipMaster].[Job] = [WipJobAllMat].[Job]
INNER JOIN
	[SysproCompanyS].[dbo].[InvMaster] WITH (NOLOCK)
on 
	[WipJobAllMat].[StockCode] = [InvMaster].[StockCode]
LEFT OUTER JOIN 
	[SysproCompanyS].[dbo].[WipMaster] AS [SubJob] WITH (NOLOCK) 
ON 
	[SubJob].[JobDescription] LIKE '%' + RIGHT(RTRIM([WipJobAllMat].[Job]), 4) + '%'
	AND [SubJob].[StockCode] = [WipJobAllMat].[StockCode]
LEFT OUTER JOIN 
	[InvWarehouse] WITH (NOLOCK)  
ON 
	[WipJobAllMat].[StockCode] = [InvWarehouse].[StockCode]
	AND [WipJobAllMat].[Warehouse] = [InvWarehouse].[Warehouse]
LEFT OUTER JOIN 
	[WipJobAllLab] WITH (NOLOCK)  
ON 
	[WipJobAllMat].[OperationOffset] = [WipJobAllLab].[Operation]
	AND [WipJobAllMat].[Job] = [WipJobAllLab].[Job]
LEFT JOIN
	[v_ProdOperationNames] [ON]
ON
	[ON].[Operation] = [OperationOffset]
/*LEFT OUTER JOIN 
	[BomMachine] WITH (NOLOCK)  
ON 
	[BomMachine].[Machine] = [WipJobAllLab].[IMachine]*/
WHERE 
	[WipMaster].[Job] NOT IN ('10015030', '10015031', '10015032')
	AND (
			[WipJobAllMat].[Warehouse] <> '99'
			AND [Planner] <> '5'
		)
GO


