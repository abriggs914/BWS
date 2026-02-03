SELECT 
	*
FROM
	[BWSdb].[dbo].[INV_WarehouseShelfSections_Hawkins]
SELECT 
	*
FROM
	[BWSdb].[dbo].[INV_WarehouseLayout_HawkinsShelves]
SELECT 
	*
FROM
	[BWSdb].[dbo].[INV_WarehouseLayout_Legend]

SELECT
	[PM].[PurchaseOrder],
	[PM].[ExchangeRate],
	[PM].[OrderEntryDate],
	[PM].[OrderDueDate],
	[PM].[OrderStatus],
	[PM].[ActiveFlag],
	[PM].[CancelledFlag],
	[PM].[ActiveFlag],
	[PM].[Buyer],
	[PS].[SupShortName] AS [Supplier],
	[PS].[SupplierName],
	[PS].[City],
	[PS].[Branch],
	[PS].[CountyZip],
	[PS].[Contact],
	[PS].[Telephone],
	[PS].[Email],
	[PS].[Nationality]
FROM
	[SysproCompanyA].[dbo].[PorMasterHdr] [PM] WITH (NOLOCK)
INNER JOIN
	[SysproCompanyA].[dbo].[ApSupplier] [PS] WITH (NOLOCK)
ON
	[PM].[Supplier] = [PS].[Supplier]
WHERE
	ISNULL([PM].[OrderDueDate], GETDATE()) >= DATEADD(YEAR, -5, GETDATE())
	AND ISNULL([PM].[OrderDueDate], GETDATE()) <= DATEADD(YEAR, 5, GETDATE())