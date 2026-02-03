
SELECT
	*
FROM
	[SysproCompanyA].[dbo].[InvWarehouse] [IW] WITH (NOLOCK)
WHERE
	[IW].[StockCode] = '70500561'

SELECT
	[IW].[StockCode],
	[IM].[Description],
	[IM].[LongDesc],
	[IW].[DefaultBin],
	[IM].[StockUom],
	[IW].[Warehouse],
	[IW].[LastCostEntered],
	[IW].[QtyAllocatedToPick],
	[IW].[QtyAllocatedWip],
	[IW].[QtyDispatched],
	[IW].[QtyInInspection],
	[IW].[QtyInTransit],
	[IW].[QtyOnBackOrder],
	[IW].[QtyOnHand],
	[IW].[QtyOnOrder],
	[IW].[QtyWipReserved],
	[IW].[QtyAllocated],
	[AS].[SupShortName],
	[IM].[ProductClass],
	[IM].[CycleCount],
	[IW].[UnitCost]
FROM
	[SysproCompanyA].[dbo].[InvWarehouse] [IW] WITH (NOLOCK)
INNER JOIN
	[SysproCompanyA].[dbo].[InvMaster] [IM] WITH (NOLOCK)
ON
	([IW].[StockCode] = [IM].[StockCode])
	AND ([IW].[Warehouse] = [IM].[WarehouseToUse])
INNER JOIN
	[SysproCompanyA].[dbo].[ApSupplier] [AS] WITH (NOLOCK)
ON
	([IM].[Supplier] = [AS].[Supplier])