/*SELECT * FROM [BWSdb].[dbo].[PROD_YellowTags]
SELECT * FROM [BWSdb].[dbo].[REC_Events]*/
SELECT * FROM [SysproCompanyA].[dbo].[v_OpenSalesOrders]
/*
SELECT
	*
FROM
	[SysproCompanyA].[dbo].[InvWarehouse]
WHERE
	[StockCode] = '20336'
;
*/
/*
SELECT
	*
FROM
	[SysproCompanyA].[dbo].[InvWarehouse]
WHERE
	([QtyInInspection] > 0
	OR [QtyInTransit] > 0)
	AND [QtyOnHand] > 0
;*/

/*SELECT
	*
FROM
	[SysproCompanyA].[dbo].[cla]
;*/

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
	--SorMaster.Branch = 'CS'
    /*AND (
        MShipQty <> 0
        OR MBackOrderQty <> 0
    )*/
	--AND [LastInvoice] = '000000000106236'
	--AND 
	[LastInvoice] LIKE '%106309%'


