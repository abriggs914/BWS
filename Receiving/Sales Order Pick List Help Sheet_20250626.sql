
-- Sales Order Pick List Help Sheet
-- 2025-06-25 10:17
SELECT
	[SO].[SalesOrder],
	[SO].[SalesOrderLine],
	[SO].[MStockCode],
	[SO].[MStockDes],
	[SO].[MStockingUom],
	[SO].[MWarehouse],
	[SO].[MBin],
	[SO].[MOrderQty],
	[SO].[MShipQty],
	[SO].[MBackOrderQty],
	[SO].[MPrice],
	[IW].[QtyAllocated],
	[IW].[QtyAllocatedToPick],
	[IW].[QtyAllocatedWip],
	[IW].[QtyOnBackOrder],
	[IW].[QtyOnHand],
	[IW].[QtyOnOrder],
	[IW].[QtyOnHand] - ([IW].[QtyAllocated] + [IW].[QtyAllocatedToPick] + [IW].[QtyAllocatedWip]) AS [Available], 
	[SO].[MPrice] - (([SO].[MPrice] * ([SO].[MDiscPct1] / 100))) AS [Amount],
	[SM].[Customer],
	[SM].[CustomerName],
	[SM].[ShipAddress1],
	[SM].[ShipAddress2],
	[SM].[ShipAddress3],
	[SM].[ShipAddress3Loc],
	[SM].[ShipAddress4],
	[SM].[ShipAddress5],
	[DiscPct1],
	[DiscPct2],
	[DiscPct3],
	[SO].[MDiscValue],
	[SO].[MDiscValue],
	*
FROM
	[SysproCompanyA].[dbo].[SorDetail] [SO]
LEFT JOIN
	[SysproCompanyA].[dbo].[InvWarehouse] [IW]
ON
	([SO].[MStockCode] = [IW].[StockCode])
	AND ([SO].[MWarehouse] = [IW].[Warehouse])
LEFT JOIN
	[SysproCompanyA].[dbo].[SorMaster] [SM]
ON
	[SO].[SalesOrder] = [SM].[SalesOrder]
WHERE
	--([SO].[SalesOrder] = RIGHT('000000000000000' + '115163', 15))
	(ISNULL([SO].[MDiscValue], 0) <> 0)
	--(ISNULL([SO].[MDiscPct1], 0) <> 0)
	--AND (ISNULL([SO].[MDiscPct2], 0) <> 0)
	--AND (ISNULL([SO].[MDiscPct3], 0) <> 0)
	AND (ISNULL([SO].[MStockCode], '') <> '')
;

/*
SELECT
	*
FROM
	[SysproCompanyA].[dbo].[SorDetail] [SO]
WHERE
	([SO].[LineType] = '1')
	AND ([SO].[SalesOrderResStat])
	AND (
		([SO].[SalesOrder] = RIGHT('000000000000000' + '115048', 15))
		OR ([SO].[SalesOrder] = RIGHT('000000000000000' + '115165', 15))
	)
;


SELECT
	CAST([SalesOrder] AS INT) AS [SalesOrder]
FROM
	[SysproCompanyA].[dbo].[SorDetail] [SO]
/*WHERE
	[SO].[SalesOrder] = RIGHT('000000000000000' + '115048', 15)*/
GROUP BY
	[SalesOrder]
;



SELECT
	CAST([SalesOrder] AS INT) AS [SalesOrder]
FROM
	[SysproCompanyA].[dbo].[SorDetail] [SO]
/*WHERE
	[SO].[SalesOrder] = RIGHT('000000000000000' + '115048', 15)*/
WHERE
	([SO].[LineType] = '1')
	AND ([SO].[MShipQty] > 0)
GROUP BY
	[SalesOrder]
;



SELECT
	*--CAST([SalesOrder] AS INT) AS [SalesOrder]
FROM
	[SysproCompanyA].[dbo].[SorMaster] [SM]
WHERE
	([SM].[OrderStatus] = '9')  -- complete
	AND (
		([SM].[SalesOrder] = RIGHT('000000000000000' + '115048', 15))
		OR ([SM].[SalesOrder] = RIGHT('000000000000000' + '115165', 15))
	)*/