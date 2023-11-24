USE [SysproCompanyA]
GO

/****** Object:  View [dbo].[v_ListOfStockCodes]    Script Date: 2023-11-24 2:48:14 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- Author:          James Crawford
-- Date Created:    2021-01-26 11:37
-- Description:     View resultset for the "Stock Codes_BWS" SQL-linked Excel spreadsheet

-- 2022-03-30 James Crawford - removed warehouse link (subMoves sub-query) to include ALL warehouse values for the stock code (commented out "and InvMaster.WarehouseToUse = InvWarehouse.Warehouse" line)
-- 2022-05-26 James Crawford - Adjusted link to go based on all warehouses in lieu of the warehouse to use
-- 2022-07-05 James Crawford - Added AlternateKey2 field (AlternateKey2 as [CAD Comments])
-- IT Request# 000810
-- 2022-07-11 James Crawford - Added QtyOnOrder field as per Yassin's request
-- IT Request# 000852
-- 2022-08-02 James Crawford - Removed Total Issued (April 1 2021 - March 31 2022), Total Adjusted (April 1 2021 - March 31 2022), and Total Transferred (April 1 2021 - March 31 2022) columns as per Lori
-- Added Manufacture Lead Time, C/O StockCode, and Cut Only (Y) as per Lori
-- IT Request# 000966
-- 2022-10-14 James Crawford - Added more columns as per Lori's request (OrderFixPeriod, OrderMaximum, OrderMinimum, OrderPolicy, MajorOrderMult, MinorOrderMult, FixTimePeriod)
-- IT Request# 001280
-- 2023-08-21 James Crawford - Added the following fields as per Lori's request:
-- 1) Technical Specification
-- 2) Sales Order add Text
-- 3) P/Order add Text
-- IT Request# 002230
-- 2023-09-15 James Crawford - Removed the following fields as per Lori's request:
-- 1) Technical Specification
-- 2) Sales Order add Text
-- 3) P/Order add Text
-- IT Request# 002285

ALTER view [dbo].[v_ListOfStockCodes] as
select InvMaster.StockCode, Description, LongDesc, StockUom, AlternateUom, Planner, DateStkAdded as [Date Set up], MinimumQty, MaximumQty,
WarehouseToUse, InvWarehouse.Warehouse, ProductClass, PartCategory, InvMaster.LeadTime, Ebq, InvMaster.DockToStock,
CycleCount, SafetyStockQty, DefaultBin, InvWarehouse.UnitCost, [P].[SellingPrice], [InvMaster].[MaterialCost], Mass, QtyOnHand, DateLastStockMove, 
BuyingRule as [Batching Rule],
[Total Issued (Rolling 12 Months)], [Total Adjusted (Rolling 12 Months)], [Total Transferred (Rolling 12 Months)],
[Total Sales (Rolling 12 Months)],
Next1MonthJobAllocations as [Next 1 Month - Job Allocations],
Next3MonthJobAllocations as [Next 3 Months - Job Allocations],
PastAllocations as [Past Due Allocations],
StockTurnoverRatio,
StockOnHold, StockOnHoldReason, OnHoldReason,
case when DateLastCostChange < cast(dateadd(year, -1, getdate()) as date) or DateLastCostChange is null then InvWarehouse.UnitCost
	 else sub12MtsAgo.UnitCost end as [12MthsAgoUnitCost],
case when DateLastCostChange < cast(dateadd(year, -2, getdate()) as date) or DateLastCostChange is null then InvWarehouse.UnitCost
	 else sub24MtsAgo.UnitCost end as [24MthsAgoUnitCost],
ApSupplier.Supplier, ApSupplier.SupplierName, [Last Issue Date], [Last Receipt Date],
AlternateKey2 as [CAD Comments],
QtyOnOrder, 
InvMaster.ManufLeadTime as [Manufacture Lead Time],
InvMaster.UserField1 as [C/O StockCode],
InvMaster.UserField3 as [Cut Only (Y)]
, OrderFixPeriod
, OrderMaximum
, OrderMinimum
, OrderPolicy
, MajorOrderMult
, MinorOrderMult
, FixTimePeriod
from InvMaster with (nolock)
LEFT JOIN [InvPrice] AS [P] ON [InvMaster].[StockCode] = [P].[StockCode]
left outer join InvWarehouse with (nolock) on InvMaster.StockCode = InvWarehouse.StockCode
												-- and InvMaster.WarehouseToUse = InvWarehouse.Warehouse
left outer join ApSupplier with (nolock) on InvMaster.Supplier = ApSupplier.Supplier
left outer join (select StockCode, Warehouse,
				sum(case when year(EntryDate) = year(getdate()) and TrnType = 'I' then TrnQty else 0 end) as [Total Issued (Current Year)],
				sum(case when year(EntryDate) = year(getdate()) and TrnType = 'A' then TrnQty else 0 end) as [Total Adjusted (Current Year)],
				sum(case when year(EntryDate) = year(getdate()) - 1 and TrnType = 'I' then TrnQty else 0 end) as [Total Issued (Previous Year)],
				sum(case when year(EntryDate) = year(getdate()) - 1 and TrnType = 'A' then TrnQty else 0 end) as [Total Adjusted (Previous Year)],
				sum(case when EntryDate between dateadd(month, -12, cast(getdate() as date)) and cast(getdate() as date) and TrnType = 'I' then TrnQty else 0 end) as [Total Issued (Rolling 12 Months)],
				sum(case when EntryDate between dateadd(month, -12, cast(getdate() as date)) and cast(getdate() as date) and TrnType = 'A' then TrnQty else 0 end) as [Total Adjusted (Rolling 12 Months)],
				sum(case when EntryDate between dateadd(month, -12, cast(getdate() as date)) and cast(getdate() as date) and TrnType = 'T' then TrnQty else 0 end) as [Total Transferred (Rolling 12 Months)],
				sum(case when EntryDate between dateadd(month, -12, cast(getdate() as date)) and cast(getdate() as date) and MovementType = 'S' then TrnQty else 0 end) as [Total Sales (Rolling 12 Months)],
				sum(case when EntryDate between '2021-04-01' and '2022-03-31' and TrnType = 'I' then TrnQty else 0 end) as [Total Issued (April 1 2021 - March 31 2022)],
				sum(case when EntryDate between '2021-04-01' and '2022-03-31' and TrnType = 'A' then TrnQty else 0 end) as [Total Adjusted (April 1 2021 - March 31 2022)],
				sum(case when EntryDate between '2021-04-01' and '2022-03-31' and TrnType = 'T' then TrnQty else 0 end) as [Total Transferred (April 1 2021 - March 31 2022)],
				max(case when TrnType = 'I' then EntryDate else null end) as [Last Issue Date],
				max(case when TrnType = 'R' then EntryDate else null end) as [Last Receipt Date]				
				from InvMovements with (nolock)
				group by StockCode, Warehouse) as subMoves on InvMaster.StockCode = subMoves.StockCode
															  and InvWarehouse.Warehouse = subMoves.Warehouse 
left outer join (
					select MrpDetailPegging.StockCode, WipJobAllMat.Warehouse, sum(Quantity) as Next1MonthJobAllocations
					from MrpDetailPegging with (nolock)
					cross join MrpReqCtl with (nolock)
					inner join WipJobAllMat with (nolock) on MrpDetailPegging.OrderNumber = WipJobAllMat.Job
															 and MrpDetailPegging.JobLine = WipJobAllMat.Line
															 and MrpDetailPegging.StockCode = WipJobAllMat.StockCode	
					where SourceType in ('J', 'K')
					and MrpDetailPegging.SupplyDemandDate >= MrpReqCtl.SupplyDemandDate
					and MrpDetailPegging.SupplyDemandDate between cast(getdate() as date) and dateadd(month, 1, cast(getdate() as date))
					group by MrpDetailPegging.StockCode, WipJobAllMat.Warehouse
				) as subNext1MthAlloc on InvMaster.StockCode = subNext1MthAlloc.StockCode
											and InvWarehouse.Warehouse = subNext1MthAlloc.Warehouse
left outer join (
					select MrpDetailPegging.StockCode, WipJobAllMat.Warehouse, sum(Quantity) as Next3MonthJobAllocations
					from MrpDetailPegging with (nolock)
					cross join MrpReqCtl with (nolock)
					inner join WipJobAllMat with (nolock) on MrpDetailPegging.OrderNumber = WipJobAllMat.Job
															 and MrpDetailPegging.JobLine = WipJobAllMat.Line
															 and MrpDetailPegging.StockCode = WipJobAllMat.StockCode	
					where SourceType in ('J', 'K')
					and MrpDetailPegging.SupplyDemandDate >= MrpReqCtl.SupplyDemandDate
					and MrpDetailPegging.SupplyDemandDate between cast(getdate() as date) and dateadd(month, 3, cast(getdate() as date))
					group by MrpDetailPegging.StockCode, WipJobAllMat.Warehouse
				) as subNext3MthAlloc on InvMaster.StockCode = subNext3MthAlloc.StockCode
											and InvWarehouse.Warehouse = subNext3MthAlloc.Warehouse
left outer join (
					select MrpDetailPegging.StockCode, WipJobAllMat.Warehouse, sum(Quantity) as PastAllocations
					from MrpDetailPegging with (nolock)
					cross join MrpReqCtl with (nolock)
					inner join WipJobAllMat with (nolock) on MrpDetailPegging.OrderNumber = WipJobAllMat.Job
															 and MrpDetailPegging.JobLine = WipJobAllMat.Line
															 and MrpDetailPegging.StockCode = WipJobAllMat.StockCode
					where SourceType in ('J', 'K')
					and MrpDetailPegging.SupplyDemandDate < MrpReqCtl.SupplyDemandDate
					group by MrpDetailPegging.StockCode, WipJobAllMat.Warehouse
				) as subPastAlloc on InvMaster.StockCode = subPastAlloc.StockCode
										and InvWarehouse.Warehouse = subPastAlloc.Warehouse
left outer join (select InvMaster.StockCode, 
				sum(TrnQty) 
				/ case when DateStkAdded > dateadd(year, -1, cast(getdate() as date)) 
					   then datediff(day, DateStkAdded, cast(getdate() as date)) 
					   else 365 end as StockTurnoverRatio
				from InvMaster with (nolock)
				inner join InvMovements with (nolock) on InvMaster.StockCode = InvMovements.StockCode
				where (MovementType = 'I' and TrnType in ('I', 'S'))
				and EntryDate between dateadd(year, -1, cast(getdate() as date)) and cast(getdate() - 1 as date)
				group by InvMaster.StockCode, DateStkAdded) as subTurnover on InvMaster.StockCode = subTurnover.StockCode
left outer join (select *
				from (
				select StockCode, Warehouse, UnitCost, EntryDate, TrnTime,
				ROW_NUMBER() over (partition by StockCode order by EntryDate desc, TrnTime desc) as LastCost12MthsAgoID
				from InvMovements with (nolock)
				where EntryDate <= cast(dateadd(year, -1, getdate()) as date)
				and Warehouse = '01'
				) as mainsub
				where LastCost12MthsAgoID = 1) as sub12MtsAgo on InvWarehouse.StockCode = sub12MtsAgo.StockCode
left outer join (select *
				from (
				select StockCode, Warehouse, UnitCost, EntryDate, TrnTime,
				ROW_NUMBER() over (partition by StockCode order by EntryDate desc, TrnTime desc) as LastCost24MthsAgoID
				from InvMovements with (nolock)
				where EntryDate <= cast(dateadd(year, -2, getdate()) as date)
				and Warehouse = '01'
				) as mainsub
				where LastCost24MthsAgoID = 1) as sub24MtsAgo on InvWarehouse.StockCode = sub24MtsAgo.StockCode
where (InvWarehouse.Warehouse <> '03' or InvWarehouse.Warehouse is null)
GO


