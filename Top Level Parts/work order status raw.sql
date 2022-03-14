USE [SysproCompanyA]
GO

--/****** Object:  View [dbo].[v_WorkOrderStatus]    Script Date: 2022-03-14 11:13:19 AM ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO











--ALTER view [dbo].[v_WorkOrderStatus] as
select WipMaster.Job, WipMaster.JobDescription, WipMaster.StockCode AS ParentPart, WipMaster.StockDescription as ParentDescription, WipMaster.JobTenderDate, 
WipMaster.ActCompleteDate, WipMaster.QtyToMake, 
case PartCategory when 'B' then 'Total Bought Out Material:'
when 'M' then 'Total Made In Material:'
when 'G' then 'Total Phantom Material:'
when 'S' then 'Total Subcontracted Material:'
when 'P' then 'Total Planning Material:'
when 'K' then 'Total Kit Material:'
when 'C' then 'Total Co-Product Material:'
else '' end as MaterialGrouping, 
case when PartCategory is null or PartCategory = 'S' then 'B'
else PartCategory end as PartCategory,
WipJobAllMat.StockCode, 
WipJobAllMat.StockDescription,
WipJobAllMat.SequenceNum,
WipJobAllMat.OperationOffset,
WipJobAllMat.Uom,
UnitCost,
WipJobAllMat.Warehouse as WarehouseToUse /*InvMaster.WarehouseToUse*/, 
cast(UnitQtyReqd * QtyToMake as decimal(18, 2)) AS QtyRequired, 
WipJobAllMat.QtyIssuedEnt as QtyIssued, 
WipJobAllMat.ValueIssued, 
v_JobWIPValue.Total from WipMaster with (nolock)
left outer join WipJobAllMat with (nolock) on WipMaster.Job = WipJobAllMat.Job
left outer join v_JobWIPValue on WipMaster.Job = v_JobWIPValue.Job
left outer join InvMaster with (nolock) on WipJobAllMat.StockCode = InvMaster.StockCode





--GO


