SELECT
	[IM].[StockCode],
	[IM].[Description],
	[IM].[LongDesc]
FROM
	[SysproCompanyA].[dbo]. InvWarehouse [IW]
LEFT JOIN
	[SysproCompanyA].[dbo]. InvMaster AS IM ON ([IW].[StockCode] = [IM].[StockCode]) AND ([IW].[Warehouse] = [IM].[WarehouseToUse])
WHERE
	[IM].[StockCode] = '2602267'

SELECT
	[IM].[TrnType],
	COUNT(*) AS [NTimes]
FROM
	[SysproCompanyA].[dbo].[InvMovements] [IM]
GROUP BY
	[IM].[TrnType]


WHERE
	[IM].[StockCode] = '2602267'
ORDER BY
	[IM].[EntryDate] DESC


SELECT
    [SO].[SalesOrder],
    [SO].[SalesOrderLine],
    [SO].[MStockCode],
    [SO].[MStockDes],
	[IM].[LongDesc],
    [SO].[MStockingUom],
    [SO].[MWarehouse],
    [IW].[DefaultBin],
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
    [SM].[Customer],
    [SM].[CustomerName],
    [SM].[ShipAddress1],
    [SM].[ShipAddress2],
    [SM].[ShipAddress3],
    [SM].[ShipAddress3Loc],
    [SM].[ShipAddress4],
    [SM].[ShipAddress5],
    [IW].[QtyOnHand] - (
        [IW].[QtyAllocated] + [IW].[QtyAllocatedToPick] + [IW].[QtyAllocatedWip]
    ) AS Available,
    [SO].[MOrderQty] * (
        [SO].[MPrice] - (
            (([SO].[MPrice] * ([SO].[MDiscPct1] / 100))) + [SO].[MDiscValue]
        )
    ) AS Amount,
    [SO].[MOrderQty] * (
        (
            (([SO].[MPrice] * ([SO].[MDiscPct1] / 100))) + [SO].[MDiscValue]
        )
    ) AS Discount
FROM
    ((
        [SysproCompanyA].[dbo]. SorDetail AS SO
        LEFT JOIN [SysproCompanyA].[dbo]. InvWarehouse AS IW ON ([SO].[MWarehouse] = [IW].[Warehouse])
        AND ([SO].[MStockCode] = [IW].[StockCode])
    )
    LEFT JOIN [SysproCompanyA].[dbo]. SorMaster AS SM ON [SO].[SalesOrder] = [SM].[SalesOrder]
	)
	LEFT JOIN [SysproCompanyA].[dbo]. InvMaster AS IM ON ([IW].[StockCode] = [IM].[StockCode]) AND ([IW].[Warehouse] = [IM].[WarehouseToUse])
WHERE
    (
        [SO].[SalesOrder] = RIGHT('000000000000000' + '115364', 15)
    )
    --AND (Nz ([SO].[MStockCode]) <> '');
    AND (ISNULL ([SO].[MStockCode], '') <> '');


SELECT TOP 1000
	*
FROM
	[SysproCompanyA].[dbo].[InvJournalCtl] [IM]