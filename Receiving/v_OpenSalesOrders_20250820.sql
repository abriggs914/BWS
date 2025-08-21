USE [SysproCompanyA]
GO

/****** Object:  View [dbo].[v_OpenSalesOrders]    Script Date: 2025-08-19 9:41:47 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		James Crawford 
-- Create date: 2024-02-09 15:08:58
-- Description:	View resultset used in the "BWS Open Sales Orders" SQL-Linked Excel spreadsheet.

-- 2024-02-14 James Crawford - Added the OrderStatus column as per Lori's request.
-- Also, added where criteria to exclude any lines that have a Ship Qty and B/O Qty of 0 as per Lori's Request. These sales order lines are considered "completed".
-- 2024-02-14 James Crawford - Needed to adjust where criteria again. Lori needs anything that has a ship qty or B/O qty. Both can't be zero.
-- 2024-02-15 James Crawford - Adjusted where criteria again. Lori also needed to see anything with Order Status "2".
-- 2024-04-29 James Crawford - Adjusted where criteria again. Lori needs to also see Order Status "0". She also wanted DocumentType "O" values included, but they already are being included.
-- IT Request # 2713
-- 2025-05-21 1127 - James Crawford - Added PastAllocations and Next3MonthJobAllocations columns from the [SysproCompayA].[dbo].[v_ListOfStockCodes] view to the [v_OpenSalesOrders] view as per Lori's request.
--                                  - Also added the SupplierName column from the [SysproCompanyA].[dbo].[ApSupplier] table to the [v_OpenSalesOrders] view as per Lori's request.
--                                  - Also added the QtyOnHand and QtyOnOrder columns from the [SysproCompanyA].[dbo].[InvWarehouse] table to the [v_OpenSalesOrders] view as per Lori's request.
-- IT Request # 3281
--
-- 2025-08-13 - Avery Briggs -- Copy of v_OpenSalesOrders to specifically only show what can be picked
--
-- =============================================

ALTER view [dbo].[v_OpenSalesOrders] as

WITH [T_Data] AS (
	select CustomerName
		, SorMaster.SalesOrder
		, ReqShipDate as [Ship Date]
		, CustomerPoNumber
		, InvMaster.StockCode
		, MOrderUom as [Uom]
		, MStockDes as [Description]
		, LongDesc as [Long Description]
		, MWarehouse as [Warehouse]
		, MOrderQty as [Order Qty]
		, MShipQty as [Ship Qty]
		, MBackOrderQty as [B/O Qty]
		--, ISNULL([QtyOnHand], 0) - (ISNULL([QtyAllocatedWip], 0) + ISNULL([QtyAllocated], 0)) AS [Available]
		--, ISNULL([QtyOnHand], 0) - (ISNULL([QtyAllocated], 0)) AS [Available]
		, ISNULL([QtyOnHand], 0) - (ISNULL([QtyAllocated], 0)) AS [Available]
		/*, (CASE WHEN 
			(ISNULL([QtyAllocatedWip], 0) + ISNULL([QtyAllocated], 0))
			>= (ISNULL([QtyOnHand], 0) - ISNULL([QtyAllocated], 0))
			THEN 1 ELSE 0 END
			) AS [CanPickForSO]
		*/
		, (CASE WHEN 
			(((ISNULL([QtyOnHand], 0) + ISNULL([QtyOnOrder], 0)) - (ISNULL([QtyAllocatedWip], 0) + ISNULL([QtyAllocated], 0))) >= 0)
			AND	((ISNULL([QtyOnHand], 0) - ISNULL([QtyAllocated], 0) >= 0))
			THEN 1 ELSE 0 END) AS [CanPickForSO]
		, ShippingInstrs as [Shipping Instructions]
		, OrderStatus
		, DocumentType
		, (
				select sum(Quantity) as Next3MonthJobAllocations
				from 
					MrpDetailPegging with (nolock)
				cross join 
					MrpReqCtl with (nolock)
				inner join 
					WipJobAllMat with (nolock) 
				on 
					MrpDetailPegging.OrderNumber = WipJobAllMat.Job
					and MrpDetailPegging.JobLine = WipJobAllMat.Line
					and MrpDetailPegging.StockCode = WipJobAllMat.StockCode	
				where 
					SourceType in ('J', 'K')
					and MrpDetailPegging.SupplyDemandDate >= MrpReqCtl.SupplyDemandDate
					and MrpDetailPegging.SupplyDemandDate between cast(getdate() as date) and dateadd(month, 3, cast(getdate() as date))
					and MrpDetailPegging.StockCode = SorDetail.MStockCode
					and WipJobAllMat.Warehouse = SorDetail.MWarehouse
			) as [Next 3 Months - Job Allocations]
		, (
				select sum(Quantity) as PastAllocations
				from 
					MrpDetailPegging with (nolock)
				cross join 
					MrpReqCtl with (nolock)
				inner join 
					WipJobAllMat with (nolock) 
				on 
					MrpDetailPegging.OrderNumber = WipJobAllMat.Job
					and MrpDetailPegging.JobLine = WipJobAllMat.Line
					and MrpDetailPegging.StockCode = WipJobAllMat.StockCode
				where 
					SourceType in ('J', 'K')
					and MrpDetailPegging.SupplyDemandDate < MrpReqCtl.SupplyDemandDate
					and MrpDetailPegging.StockCode = SorDetail.MStockCode
					and WipJobAllMat.Warehouse = SorDetail.MWarehouse
			) as [Past Due Allocations]
		, ApSupplier.SupplierName
		, InvWarehouse.QtyOnHand
		, InvWarehouse.QtyOnOrder
	FROM
		SorMaster with (nolock)
	inner JOIN
		SorDetail with (nolock)
	ON
		SorMaster.SalesOrder = SorDetail.SalesOrder
	inner JOIN
		InvMaster with (nolock)
	ON
		SorDetail.MStockCode = InvMaster.StockCode
	inner JOIN
		ApSupplier with (nolock)
	ON
		InvMaster.Supplier = ApSupplier.Supplier
	left outer join
		InvWarehouse with (nolock)
	ON
		InvMaster.StockCode = InvWarehouse.StockCode
		and SorDetail.MWarehouse = InvWarehouse.Warehouse
	WHERE
		OrderStatus in ('0', '1', '8', 'S', '2', '3', '4')
		and SorMaster.Branch = 'CS'
		and (
			MShipQty <> 0
			or MBackOrderQty <> 0
		)
)
SELECT
	/*[SOCanBePicked],
	[SOCanBePicked1],
	[SumCanPick],
	[CountAll],*/
	[T_Data].*
	--, [CanPickForSO]
	, [SOCanBePicked1] AS [SOCanBePicked]
FROM (
	SELECT
		[CustomerName]
		, [SalesOrder]
		, [Ship Date]
		, [CustomerPoNumber]
		, (CASE WHEN COUNT(*) = COUNT(CASE WHEN ([Order Qty] - [Ship Qty]) <= [Available] THEN 1 ELSE 0 END) THEN 1 ELSE 0 END) AS [SOCanBePicked]
		, (CASE WHEN COUNT(*) = SUM([CanPickForSO]) THEN 1 ELSE 0 END) AS [SOCanBePicked1]
		, SUM([CanPickForSO]) AS [SumCanPick]
		, COUNT(*) AS [CountAll]
	FROM
		[T_Data]
	GROUP BY
		[CustomerName]
		, [SalesOrder]
		, [Ship Date]
		, [CustomerPoNumber]
) AS [Src]
INNER JOIN
	[T_Data]
ON
	[Src].[SalesOrder] = [T_Data].[SalesOrder]
/*WHERE
	([SumCanPick] = [CountAll])
	AND ([QtyOnHand] > 0)
ORDER BY
	[Src].[SalesOrder]*/


/*  -- Removed 2025-08-19 9:42 - Avery Briggs
select CustomerName
    , SorMaster.SalesOrder
    , ReqShipDate as [Ship Date]
    , CustomerPoNumber
    , InvMaster.StockCode
    , MOrderUom as [Uom]
    , MStockDes as [Description]
    , LongDesc as [Long Description]
    , MWarehouse as [Warehouse]
    , MOrderQty as [Order Qty]
    , MShipQty as [Ship Qty]
    , MBackOrderQty as [B/O Qty]
    , ShippingInstrs as [Shipping Instructions]
    , OrderStatus
    , DocumentType
    , (
            select sum(Quantity) as Next3MonthJobAllocations
            from 
                MrpDetailPegging with (nolock)
            cross join 
                MrpReqCtl with (nolock)
            inner join 
                WipJobAllMat with (nolock) 
            on 
                MrpDetailPegging.OrderNumber = WipJobAllMat.Job
                and MrpDetailPegging.JobLine = WipJobAllMat.Line
                and MrpDetailPegging.StockCode = WipJobAllMat.StockCode	
            where 
                SourceType in ('J', 'K')
                and MrpDetailPegging.SupplyDemandDate >= MrpReqCtl.SupplyDemandDate
                and MrpDetailPegging.SupplyDemandDate between cast(getdate() as date) and dateadd(month, 3, cast(getdate() as date))
                and MrpDetailPegging.StockCode = SorDetail.MStockCode
                and WipJobAllMat.Warehouse = SorDetail.MWarehouse
        ) as [Next 3 Months - Job Allocations]
    , (
            select sum(Quantity) as PastAllocations
            from 
                MrpDetailPegging with (nolock)
            cross join 
                MrpReqCtl with (nolock)
            inner join 
                WipJobAllMat with (nolock) 
            on 
                MrpDetailPegging.OrderNumber = WipJobAllMat.Job
                and MrpDetailPegging.JobLine = WipJobAllMat.Line
                and MrpDetailPegging.StockCode = WipJobAllMat.StockCode
            where 
                SourceType in ('J', 'K')
                and MrpDetailPegging.SupplyDemandDate < MrpReqCtl.SupplyDemandDate
                and MrpDetailPegging.StockCode = SorDetail.MStockCode
                and WipJobAllMat.Warehouse = SorDetail.MWarehouse
        ) as [Past Due Allocations]
    , ApSupplier.SupplierName
    , InvWarehouse.QtyOnHand
    , InvWarehouse.QtyOnOrder
FROM
    SorMaster with (nolock)
inner JOIN
    SorDetail with (nolock)
ON
    SorMaster.SalesOrder = SorDetail.SalesOrder
inner JOIN
    InvMaster with (nolock)
ON
    SorDetail.MStockCode = InvMaster.StockCode
inner JOIN
    ApSupplier with (nolock)
ON
    InvMaster.Supplier = ApSupplier.Supplier
left outer join
    InvWarehouse with (nolock)
ON
    InvMaster.StockCode = InvWarehouse.StockCode
    and SorDetail.MWarehouse = InvWarehouse.Warehouse
WHERE
    OrderStatus in ('0', '1', '8', 'S', '2', '3', '4')
    and SorMaster.Branch = 'CS'
    and (
        MShipQty <> 0
        or MBackOrderQty <> 0
    )
*/    
GO


