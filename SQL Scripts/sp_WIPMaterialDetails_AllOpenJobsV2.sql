USE [SysproCompanyA]
GO
/****** Object:  StoredProcedure [dbo].[sp_WIPMaterialDetails_AllOpenJobs]    Script Date: 2022-01-04 10:53:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_WIPMaterialDetails_AllOpenJobsV2] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--Drop and create temp table in tmpdb SQL database for faster processing
	IF OBJECT_ID('tempdb..#WIPMaterialDetails') IS NOT NULL
		DROP TABLE #WIPMaterialDetails

	create table #WIPMaterialDetails
	(
		MainJob varchar(20),
		MainJobStartDate datetime,
		MainJobDesc varchar(50),
		Operation decimal(5, 0),
		Component varchar(30),
		Description varchar(50),
		Warehouse varchar(10),
		DefaultBin varchar(20),
		ProductClass varchar(20),
		PartCategory char(1),
		Supplier varchar(250),
		[Iss. to WO] CHAR(1),
		QtyReq decimal(18, 6),
		QtyOnHand decimal(18, 6),
		[Available?] char(1),
		[PO#/WO#] varchar(20),
		[PO Due Date/WO Finish Date] datetime,
		[PO#/WO# Qty] decimal(18, 6),
		Planner varchar(20)
	)

	--Grab Next PO details from MRP
	--Drop and create temp table in tmpdb SQL database for faster processing
	IF OBJECT_ID('tempdb..#WIPMaterialDetails_NextPO') IS NOT NULL
		DROP TABLE #WIPMaterialDetails_NextPO

	create table #WIPMaterialDetails_NextPO
	(
		MainJob varchar(20),
		Operation decimal(5, 0),
		Component varchar(30),
		QtyReq decimal(18, 6),
		AvailableStock decimal(18, 6),
		OrderID int,
		[Next PO#] varchar(20),
		[Next PO Date] datetime,
		[Next PO Qty] decimal(18, 6)
	)

	insert into #WIPMaterialDetails_NextPO
	select WipJobAllLab.Job, Operation, WipJobAllMat.StockCode, UnitQtyReqd, AvailableStock,
	1 as OrderID,
	subNextPO.PurchaseOrder as NextPO,
	subNextPO.MLatestDueDate as NextPODate,
	subNextPO.MOrderQty as NextPOQty
	from WipJobAllLab with (nolock)
	inner join WipJobAllMat with (nolock) on WipJobAllLab.Job = WipJobAllMat.Job
											 and WipJobAllLab.Operation = WipJobAllMat.OperationOffset
	inner join WipMaster with (nolock) on WipJobAllLab.Job = WipMaster.Job
	inner join InvMaster with (nolock) on WipJobAllMat.StockCode = InvMaster.StockCode
	inner join InvWarehouse with (nolock) on WipJobAllMat.StockCode = InvWarehouse.StockCode
											 and WipJobAllMat.Warehouse = InvWarehouse.Warehouse
	left outer join MrpDetailPegging with (nolock) on WipJobAllMat.Job = MrpDetailPegging.OrderNumber
												 and WipJobAllMat.StockCode = MrpDetailPegging.StockCode
	left outer join MrpRequirement with (nolock) on MrpDetailPegging.StockCode = MrpRequirement.StockCode
												 and MrpDetailPegging.SupplyDemandDate = MrpRequirement.SupplyDemandDate
	left outer join (select MStockCode as StockCode,
					MWarehouse as Warehouse,
					PurchaseOrder, MLatestDueDate, MOrderQty
					from (
					select MStockCode, MWarehouse, PorMasterHdr.PurchaseOrder, Line, MLatestDueDate, MOrderQty,
					ROW_NUMBER() over(partition by MStockCode, MWarehouse
									  order by MStockCode, MWarehouse, PorMasterHdr.PurchaseOrder, Line) as RowID
					from PorMasterDetail with (nolock)
					inner join PorMasterHdr with (nolock) on PorMasterDetail.PurchaseOrder = PorMasterHdr.PurchaseOrder
					where OrderStatus not in ('*', '9')
					and LineType = 1
					and MOrderQty > MReceivedQty
					) as mainsub
					where RowID = 1) as subNextPO on WipJobAllMat.StockCode = subNextPO.StockCode
													 and WipJobAllMat.Warehouse = subNextPO.Warehouse
	--left outer join (select StockCode, MrpDetailPegging.SupplyDemandDate, OrderNumber, Quantity 
	--				 from MrpDetailPegging with (nolock)
	--				 cross join MrpReqCtl with (nolock)
	--				 where SourceType = 'P'
	--				 and MrpDetailPegging.SupplyDemandDate >= MrpReqCtl.SupplyDemandDate) as subNextPO on MrpDetailPegging.StockCode = subNextPO.StockCode
	--																									  and MrpDetailPegging.SupplyDemandDate <= subNextPO.SupplyDemandDate
	where ActCompleteDate is null
	and PartCategory = 'B'

	delete from #WIPMaterialDetails_NextPO
	where OrderID <> 1

	--Grab Next WO details from MRP
	--Drop and create temp table in tmpdb SQL database for faster processing
	IF OBJECT_ID('tempdb..#WIPMaterialDetails_NextWO') IS NOT NULL
		DROP TABLE #WIPMaterialDetails_NextWO

	create table #WIPMaterialDetails_NextWO
	(
		MainJob varchar(20),
		Operation decimal(5, 0),
		Component varchar(30),
		QtyReq decimal(18, 6),
		AvailableStock decimal(18, 6),
		OrderID int,
		[Next WO#] varchar(20),
		[Next WO Date] datetime,
		[Next WO Qty] decimal(18, 6)
	)

	insert into #WIPMaterialDetails_NextWO
	select WipJobAllLab.Job, Operation, WipJobAllMat.StockCode, UnitQtyReqd, AvailableStock,
	1 as OrderID,
	subNextWO.Job as NextWO,
	subNextWO.JobDeliveryDate as NextWODate,
	subNextWO.QtyToMake as NextWOQty
	from WipJobAllLab with (nolock)
	inner join WipJobAllMat with (nolock) on WipJobAllLab.Job = WipJobAllMat.Job
											 and WipJobAllLab.Operation = WipJobAllMat.OperationOffset
	inner join WipMaster with (nolock) on WipJobAllLab.Job = WipMaster.Job
	inner join InvMaster with (nolock) on WipJobAllMat.StockCode = InvMaster.StockCode
	inner join InvWarehouse with (nolock) on WipJobAllMat.StockCode = InvWarehouse.StockCode
											 and WipJobAllMat.Warehouse = InvWarehouse.Warehouse
	left outer join MrpDetailPegging with (nolock) on WipJobAllMat.Job = MrpDetailPegging.OrderNumber
												 and WipJobAllMat.StockCode = MrpDetailPegging.StockCode
	left outer join MrpRequirement with (nolock) on MrpDetailPegging.StockCode = MrpRequirement.StockCode
												 and MrpDetailPegging.SupplyDemandDate = MrpRequirement.SupplyDemandDate
	left outer join (select StockCode, Warehouse, Job, JobDeliveryDate, QtyToMake
					from (
					select StockCode, Warehouse, Job, JobDeliveryDate, QtyToMake,
					ROW_NUMBER() over(partition by StockCode, Warehouse
										order by StockCode, Warehouse, JobDeliveryDate) as RowID
					from WipMaster with (nolock)
					where JobClassification in ('SUB', 'PAR')
					and ActCompleteDate is null
					) as mainsub
					where RowID = 1) as subNextWO on WipJobAllMat.StockCode = subNextWO.StockCode
													 and WipJobAllMat.Warehouse = subNextWO.Warehouse
	--left outer join (select StockCode, MrpDetailPegging.SupplyDemandDate, OrderNumber, Quantity 
	--				 from MrpDetailPegging with (nolock)
	--				 cross join MrpReqCtl with (nolock)
	--				 where SourceType = 'W'
	--				 and MrpDetailPegging.SupplyDemandDate >= MrpReqCtl.SupplyDemandDate) as subNextWO on MrpDetailPegging.StockCode = subNextWO.StockCode
	--																									  and MrpDetailPegging.SupplyDemandDate <= subNextWO.SupplyDemandDate
	where ActCompleteDate is null
	and PartCategory = 'M'

	delete from #WIPMaterialDetails_NextWO
	where OrderID <> 1

	--Insert Job material details for @job and operations in @startop and @endop range
	--Include/exclude completed material allocations based on @excludecompletematallocs
	/*if @excludecompletematallocs = 0
		begin*/
			insert into #WIPMaterialDetails (MainJob, MainJobStartDate, MainJobDesc, Operation, Component, Warehouse, DefaultBin, Description, QtyReq, QtyOnHand, ProductClass, Supplier, PartCategory, Planner, [Iss. to WO])
			select WipMaster.Job, JobStartDate, JobDescription, OperationOffset, WipJobAllMat.StockCode, WipJobAllMat.Warehouse,
			case when DefaultBin is null then 'N/A' else DefaultBin end as DefaultBin,
			WipJobAllMat.StockDescription, UnitQtyReqd, QtyOnHand, ProductClass, [ApSupplier].[SupplierName], PartCategory, Planner,
			(CASE WHEN ([UnitQtyReqd] - [QtyIssued]) <= 0 THEN 'Y' ELSE 'N' END) AS [Iss. to WO]
			from WipMaster with (nolock)
			inner join WipJobAllMat with (nolock) on WipMaster.Job = WipJobAllMat.Job
			inner join InvMaster with (nolock) on WipJobAllMat.StockCode = InvMaster.StockCode
			left outer join InvWarehouse with (nolock) on WipJobAllMat.StockCode = InvWarehouse.StockCode
									   and (case when WipJobAllMat.Warehouse = '**' then '01' 
												 else WipJobAllMat.Warehouse end) = InvWarehouse.Warehouse
			LEFT JOIN 
				[ApSupplier]
			ON
				[ApSupplier].[Supplier] = [InvMaster].[Supplier]
			where ActCompleteDate is null
			AND (LOWER([ProductClass]) <> 'info' AND LOWER([ProductClass]) <> 'bf')
			AND (WipJobAllMat.[Warehouse] <> '06' AND WipJobAllMat.[Warehouse] <> '99')
		/*end
	else
		begin
			insert into #WIPMaterialDetails (MainJob, MainJobDesc, Operation, Component, Warehouse, DefaultBin, Description, QtyReq, QtyOnHand)
			select WipMaster.Job, JobDescription, OperationOffset, WipJobAllMat.StockCode, WipJobAllMat.Warehouse,
			case when DefaultBin is null then 'N/A' else DefaultBin end as DefaultBin,
			WipJobAllMat.StockDescription, UnitQtyReqd, QtyOnHand
			from WipMaster with (nolock)
			inner join WipJobAllMat with (nolock) on WipMaster.Job = WipJobAllMat.Job
			left outer join InvWarehouse with (nolock) on WipJobAllMat.StockCode = InvWarehouse.StockCode
									   and (case when WipJobAllMat.Warehouse = '**' then '01' 
												 else WipJobAllMat.Warehouse end) = InvWarehouse.Warehouse
			where WipMaster.Job = @job
			and OperationOffset between @startop and @endop
			and (AllocCompleted = 'N' or AllocCompleted = '')
		end*/

	--Update PO Info for Bought Out materials that are currently not available based on MRP
	update #WIPMaterialDetails
	set [Available?] = case when #WIPMaterialDetails.QtyReq > AvailableStock then 'N' else 'Y' end,
		[PO#/WO#] = case when #WIPMaterialDetails.QtyReq > AvailableStock then [Next PO#] else null end,
		[PO Due Date/WO Finish Date] = case when #WIPMaterialDetails.QtyReq > AvailableStock then [Next PO Date] else null end,
		[PO#/WO# Qty] = case when #WIPMaterialDetails.QtyReq > AvailableStock then [Next PO Qty] else null end
	from #WIPMaterialDetails
	inner join #WIPMaterialDetails_NextPO as NextPO on #WIPMaterialDetails.MainJob = NextPO.MainJob
													   and #WIPMaterialDetails.Operation = NextPO.Operation
													   and #WIPMaterialDetails.Component = NextPO.Component
	
	--Update WO Info for Made In components that are currently not available based on MRP
	update #WIPMaterialDetails
	set [Available?] = case when #WIPMaterialDetails.QtyReq > AvailableStock then 'N' else 'Y' end,
		[PO#/WO#] = case when #WIPMaterialDetails.QtyReq > AvailableStock then [Next WO#] else null end,
		[PO Due Date/WO Finish Date] = case when #WIPMaterialDetails.QtyReq > AvailableStock then [Next WO Date] else null end,
		[PO#/WO# Qty] = case when #WIPMaterialDetails.QtyReq > AvailableStock then [Next WO Qty] else null end
	from #WIPMaterialDetails
	inner join #WIPMaterialDetails_NextWO as NextWO on #WIPMaterialDetails.MainJob = NextWO.MainJob
													   and #WIPMaterialDetails.Operation = NextWO.Operation
													   and #WIPMaterialDetails.Component = NextWO.Component
	
	--Update remaining stock codes that weren't included in MRP update
	update #WIPMaterialDetails
	set [Available?] = case when QtyReq > QtyOnHand then 'N' else 'Y' end
	where [Available?] is null

	--Final select statement
	select * from #WIPMaterialDetails
	order by MainJob, Operation, Component

END
