
/*
SELECT * FROM  [SysproCompanyA].[dbo].[v_OpenSalesOrders]

WHERE
	LOWER([Description]) LIKE '%tank%'

SELECT [SalesOrder] FROM  [SysproCompanyA].[dbo].[v_OpenSalesOrders]
WHERE
	LOWER([CustomerName]) LIKE '%transit%'
GROUP BY [SalesOrder]


SELECT * FROM  [SysproCompanyA].[dbo].[v_OpenSalesOrders]

SELECT * FROM  [SysproCompanyA].[dbo].[v_OpenSalesOrders]
UNION
SELECT * FROM  [SysproCompanys].[dbo].[v_OpenSalesOrders]
;;

SELECT
	*
FROM
	[SysproCompanyA].[dbo].[SalProductClass]

*/



SELECT
	'BWS' AS [Comp],
	[IM].[StockCode],
	[IM].[Description],
	[IM].[LongDesc],
	[IW].[DefaultBin],
	[IW].[QtyAllocated],
	[IW].[QtyOnHand],
	[IW].[QtyOnOrder],
	[IW].[QtyOnBackOrder],
	[IW].[Supplier],
	[IM].[AlternateKey1],
	[IM].[AlternateKey2],
	[PC].[Description] AS [ProductClass],
	[AS].[SupplierName],
	[AS].[SupplierChName]
FROM
	[SysproCompanyA].[dbo].[InvMaster] [IM]
INNER JOIN
	[SysproCompanyA].[dbo].[InvWarehouse] [IW]
ON
	[IM].[StockCode] = [IW].[StockCode]
INNER JOIN
	[SysproCompanyA].[dbo].[SalProductClass] [PC]
ON
	[IM].[ProductClass] = [PC].[ProductClass]
INNER JOIN
	[SysproCompanyA].[dbo].[ApSupplier] [AS]
ON
	[IM].[Supplier] = [AS].[Supplier]
UNION
SELECT
	'STG' AS [Comp],
	[IM].[StockCode],
	[IM].[Description],
	[IM].[LongDesc],
	[IW].[DefaultBin],
	[IW].[QtyAllocated],
	[IW].[QtyOnHand],
	[IW].[QtyOnOrder],
	[IW].[QtyOnBackOrder],
	[IW].[Supplier],
	[IM].[AlternateKey1],
	[IM].[AlternateKey2],
	[PC].[Description] AS [ProductClass],
	[AS].[SupplierName],
	[AS].[SupplierChName]
FROM
	[SysproCompanyS].[dbo].[InvMaster] [IM]
INNER JOIN
	[SysproCompanyS].[dbo].[InvWarehouse] [IW]
ON
	[IM].[StockCode] = [IW].[StockCode]
INNER JOIN
	[SysproCompanyS].[dbo].[SalProductClass] [PC]
ON
	[IM].[ProductClass] = [PC].[ProductClass]
INNER JOIN
	[SysproCompanyS].[dbo].[ApSupplier] [AS]
ON
	[IM].[Supplier] = [AS].[Supplier]