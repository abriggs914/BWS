
-- Invoice # to Sales Order Look Up

SELECT
	*
FROM
    SorMaster WITH (NOLOCK)
INNER JOIN
    SorDetail WITH (NOLOCK)
ON
    SorMaster.SalesOrder = SorDetail.SalesOrder
INNER JOIN
    InvMaster WITH (NOLOCK)
ON
    SorDetail.MStockCode = InvMaster.StockCode
INNER JOIN
    ApSupplier WITH (NOLOCK)
ON
    InvMaster.Supplier = ApSupplier.Supplier
LEFT OUTER JOIN
    InvWarehouse WITH (NOLOCK)
ON
    InvMaster.StockCode = InvWarehouse.StockCode
    AND SorDetail.MWarehouse = InvWarehouse.Warehouse
WHERE
    /*OrderStatus IN ('0', '1', '8', 'S', '2', '3', '4')
    AND
	*/
	SorMaster.Branch = 'CS'
    /*AND (
        MShipQty <> 0
        OR MBackOrderQty <> 0
    )*/
	AND [LastInvoice] = '000000000106236'