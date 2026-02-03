USE [SysproCompanyA]
GO

/****** Object:  View [dbo].[v_InventoryByBinPrint]    Script Date: 2026-01-22 9:35:34 AM ******/

-- 2026-01-21 0935 - Avery Briggs - Removed the restrictive Top 30

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





ALTER view [dbo].[v_InventoryByBinPrint] as
select DefaultBin, InvWarehouse.StockCode, Description, LongDesc, 
CycleCount, InvWarehouse.Warehouse, null as QtyOnHand, UnitCost
from InvMaster with (nolock)
inner join InvWarehouse with (nolock) on InvMaster.StockCode = InvWarehouse.StockCode
left outer join (select distinct StockCode from InvMovements with (nolock)
				 where EntryDate >= dateadd(year, -2, cast(cast(GETDATE() as date) as datetime))) as subMoves on InvMaster.StockCode = subMoves.StockCode
where InvWarehouse.Warehouse = '01'
and CycleCount <> 2
and ProductClass <> 'BF'
and (case when QtyOnHand = 0 and subMoves.StockCode is not null then 1
		  when QtyOnHand > 0 then 1
		  else 0 end) = 1
--order by [DefaultBin], [StockCode]


GO



/*
-- Version 2026-01-20


ALTER view [dbo].[v_InventoryByBinPrint] as
select top (30) DefaultBin, InvWarehouse.StockCode, Description, LongDesc, 
CycleCount, InvWarehouse.Warehouse, null as QtyOnHand, UnitCost
from InvMaster with (nolock)
inner join InvWarehouse with (nolock) on InvMaster.StockCode = InvWarehouse.StockCode
left outer join (select distinct StockCode from InvMovements with (nolock)
				 where EntryDate >= dateadd(year, -2, cast(cast(GETDATE() as date) as datetime))) as subMoves on InvMaster.StockCode = subMoves.StockCode
where InvWarehouse.Warehouse = '01'
and CycleCount <> 2
and ProductClass <> 'BF'
and (case when QtyOnHand = 0 and subMoves.StockCode is not null then 1
		  when QtyOnHand > 0 then 1
		  else 0 end) = 1
order by newid()


GO




*/