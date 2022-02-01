USE [SysproCompanyS]
GO

/****** Object:  View [dbo].[v_ListOfStockCodes]    Script Date: 2022-02-01 12:19:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


















ALTER view [dbo].[v_ListOfStockCodes] as
select InvMaster.StockCode, Description, LongDesc, StockUom, AlternateUom, Planner, DateStkAdded as [Date Set up], MinimumQty, MaximumQty,
WarehouseToUse, ProductClass, PartCategory, InvMaster.LeadTime, Ebq, InvMaster.DockToStock,
CycleCount, SafetyStockQty, DefaultBin, InvWarehouse.UnitCost, Mass, QtyOnHand, DateLastStockMove, 
BuyingRule as [Batching Rule],
[Total Issued (Current Year)], [Total Adjusted (Current Year)], [Total Issued (Previous Year)], [Total Adjusted (Previous Year)],
Next1MonthJobAllocations as [Next 1 Month - Job Allocations],
Next3MonthJobAllocations as [Next 3 Months - Job Allocations],
PastAllocations as [Past Due Allocations],
StockTurnoverRatio,
StockOnHold, StockOnHoldReason, OnHoldReason,
case when DateLastCostChange < cast(dateadd(year, -1, getdate()) as date) or DateLastCostChange is null then InvWarehouse.UnitCost
	 else sub12MtsAgo.UnitCost end as [12MthsAgoUnitCost],
case when DateLastCostChange < cast(dateadd(year, -2, getdate()) as date) or DateLastCostChange is null then InvWarehouse.UnitCost
	 else sub24MtsAgo.UnitCost end as [24MthsAgoUnitCost]

from InvMaster with (nolock)
left outer join InvWarehouse with (nolock) on InvMaster.StockCode = InvWarehouse.StockCode
												and InvMaster.WarehouseToUse = InvWarehouse.Warehouse
left outer join (select StockCode, Warehouse,
				sum(case when year(EntryDate) = year(getdate()) and TrnType = 'I' then TrnQty else 0 end) as [Total Issued (Current Year)],
				sum(case when year(EntryDate) = year(getdate()) and TrnType = 'A' then TrnQty else 0 end) as [Total Adjusted (Current Year)],
				sum(case when year(EntryDate) = year(getdate()) - 1 and TrnType = 'I' then TrnQty else 0 end) as [Total Issued (Previous Year)],
				sum(case when year(EntryDate) = year(getdate()) - 1 and TrnType = 'A' then TrnQty else 0 end) as [Total Adjusted (Previous Year)]
				from InvMovements with (nolock)
				group by StockCode, Warehouse) as subMoves on InvMaster.StockCode = subMoves.StockCode
															  and InvMaster.WarehouseToUse = subMoves.Warehouse
left outer join (select MrpDetailPegging.StockCode, sum(Quantity) as Next1MonthJobAllocations
				 from MrpDetailPegging with (nolock)
				 cross join MrpReqCtl with (nolock)
				 where SourceType in ('J', 'K')
				 and MrpDetailPegging.SupplyDemandDate >= MrpReqCtl.SupplyDemandDate
				 and MrpDetailPegging.SupplyDemandDate between cast(getdate() as date) and dateadd(month, 1, cast(getdate() as date))
				 group by MrpDetailPegging.StockCode) as subNext1MthAlloc on InvMaster.StockCode = subNext1MthAlloc.StockCode
left outer join (select MrpDetailPegging.StockCode, sum(Quantity) as Next3MonthJobAllocations
				 from MrpDetailPegging with (nolock)
				 cross join MrpReqCtl with (nolock)
				 where SourceType in ('J', 'K')
				 and MrpDetailPegging.SupplyDemandDate >= MrpReqCtl.SupplyDemandDate
				 and MrpDetailPegging.SupplyDemandDate between cast(getdate() as date) and dateadd(month, 3, cast(getdate() as date))
				 group by MrpDetailPegging.StockCode) as subNext3MthAlloc on InvMaster.StockCode = subNext3MthAlloc.StockCode
left outer join (select MrpDetailPegging.StockCode, sum(Quantity) as PastAllocations
				 from MrpDetailPegging with (nolock)
				 cross join MrpReqCtl with (nolock)
				 where SourceType in ('J', 'K')
				 and MrpDetailPegging.SupplyDemandDate < MrpReqCtl.SupplyDemandDate
				 group by MrpDetailPegging.StockCode) as subPastAlloc on InvMaster.StockCode = subPastAlloc.StockCode
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

GO

