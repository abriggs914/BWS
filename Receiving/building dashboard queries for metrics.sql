
DECLARE @d AS DATE;
SELECT
	@d = CAST('2025-09-30' AS DATE)

-- Posted material and labour for today only
SELECT
	[JPD].[TrnDateTime],
	[JP].*
FROM
	[SysproCompanyA].[dbo].[WipJobPost] [JP]
INNER JOIN
	[SysproCompanyA].[dbo].[v_PROD_WipJobPostDateTime] [JPD]
ON
	([JP].[Job] = [JPD].[Job])
	AND ([JP].[Line] = [JPD].[Line])
WHERE
	CAST([JPD].[TrnDateTime] AS DATE) = @d
;

-- Quotes and orders for today
SELECT
	[O].[Quote Date]
	,[O].[Order Date]
	,[O].[Date Registered]
	,[O].[Date Declined]
	,[O].[Decline/Rejected]
	,[O].[Date In Service]
	,[O].[Invoice Date]

	,[O].[Quote#]
	,[O].[WO#]
	,[O].[Serial Number]
	,[O].[ProductID]
	,[O].[Model No]
	,[O].[US Sale]
	,[O].[Price]

	,ISNULL([P].[Prod Date], [P].[Prod Date2]) AS [ProdDate]
	,ISNULL([P].[Prod Line], [P].[Prod Line2]) AS [ProdLine]
	
	,[C].[Customer]
	,[D].[COMPANY NAME]
FROM
	[BWSdb].[dbo].[Orders] [O]
LEFT JOIN
	[BWSdb].[dbo].[Production] [P]
ON
	[O].[Quote#] = [P].[Quote#]
LEFT JOIN
	[BWSdb].[dbo].[Customers] [C]
ON
	[O].[CustID] = [C].[ID#]
LEFT JOIN
	[BWSdb].[dbo].[Dealers] [D]
ON
	[O].[DealerID] = [D].[ID]
WHERE
	--(
	([O].[Quote Date] = @d)
	OR ([O].[Order Date] = @d)
	OR ([O].[Date Registered] = @d)
	OR ([O].[Date Declined] = @d)
	OR ([O].[Date In Service] = @d)
	OR ([O].[Invoice Date] = @d)
	
	OR ([P].[Prod Date] = @d)
	OR ([P].[Prod Date2] = @d)
;

-- Sales Orders and SO invoices for today
SELECT
	[SM].[SalesOrder],
	[AR].[InvoiceDate],
	[SM].[OrderDate],
	[SM].[DateLastDocPrt],
	[SM].[DateLastInvPrt],
	[SM].[EntrySystemDate],
	[SM].[ReqShipDate],
	[SM].[OrderStatus],
	[SM].[Salesperson],
	[SM].[CustomerName],
	[SM].[Email],
	[SM].[ShippingInstrs],
	[SM].[ShipAddress1],
	[SM].[ShipAddress2],
	[SM].[ShipAddress3],
	[SM].[ShipAddress4],
	[SM].[ShipAddress5],
	[SM].[InvoiceCount],
	[SM].[LastInvoice],
	[SM].[Area],
	[SM].[ExchangeRate],
	[SM].[LastOperator],

	[SD].[SalesOrderLine],
	[SD].[LineType],
	[SD].[MProductClass],
	[IM].[PartCategory],
	[IM].[Supplier],
	[AS].[SupplierName],
	[AS].[SupShortName],
	[SD].[MStockCode],
	[IM].[Description],
	[IM].[LongDesc],
	[IM].[WarehouseToUse],
	[SD].[MWarehouse],
	[SD].[MBin],
	[IW].[DefaultBin],
	[SD].[MOrderQty],
	[SD].[MShipQty],
	[SD].[MBackOrderQty],
	[SD].[MUnitCost],
	[SD].[MOrderUom],
	[SD].[MPrice],
	[SD].[MDiscPct1],
	[SD].[MDiscPct2],
	[SD].[MDiscPct3],
	[SD].[MLineShipDate],
	[SD].[NComment],
	[AR].[Customer],
	[AR].[Invoice],
	[AS].[LastPurchDate],

	[IW].[QtyOnHand],
	[IW].[QtyOnOrder],
	[IW].[QtyOnBackOrder],
	[IW].[QtyAllocated],
	[IW].[QtyAllocatedToPick],
	[IW].[QtyAllocatedWip],
	[IW].[DateLastSale],
	[IW].[DateLastStockMove],
	[IW].[DateLastPurchase]
FROM
	[SysproCompanyA].[dbo].[SorMaster] [SM] WITH (NOLOCK)
LEFT JOIN
	[SysproCompanyA].[dbo].[SorDetail] [SD] WITH (NOLOCK)
ON
	[SM].[SalesOrder] = [SD].[SalesOrder]
LEFT JOIN
	[SysproCompanyA].[dbo].[InvMaster] [IM] WITH (NOLOCK)
ON
	[SD].[MStockCode] = [IM].[StockCode]
LEFT JOIN
	[SysproCompanyA].[dbo].[ArInvoice] [AR]
ON
	[SM].[LastInvoice] = [AR].[Invoice]
LEFT JOIN
	[SysproCompanyA].[dbo].[ApSupplier] [AS] WITH (NOLOCK)
ON
	[IM].[Supplier] = [AS].[Supplier]
LEFT OUTER JOIN
	[SysproCompanyA].[dbo].[InvWarehouse] [IW] WITH (NOLOCK)
ON
	[IM].[StockCode] = [IW].[StockCode]
	AND [SD].[MWarehouse] = [IW].[Warehouse]
WHERE
	([SM].[DateLastDocPrt] = @d)
	OR ([SM].[DateLastInvPrt] = @d)
	OR ([SM].[EntrySystemDate] = @d)
	OR ([SD].[MLineShipDate] = @d)
	OR ([SM].[OrderDate] = @d)
	OR ([SM].[ReqShipDate] = @d)
	OR ([AR].[InvoiceDate] = @d)
;



SELECT
	[PM].[MLatestDueDate],
	[PM].[MLastReceiptDat],
	[PM].[MOrigDueDate],
	[PH].[OrderEntryDate],
	[PH].[OrderDueDate],
	[PH].[DateLastDocPrt],
	[PH].[MemoDate],

	[PM].[PurchaseOrder],
	[PM].[Line],
	[PM].[MStockCode],
	[PM].[MStockDes],
	[PM].[MWarehouse],
	[PM].[MOrderUom],
	[PM].[MOrderQty],
	[PM].[MReceivedQty],
	[PM].[MPrice],
	[PM].[MForeignPrice],
	[PM].[NComment],
	[PH].[Supplier],
	--[PH].[Ref],

	[PM].[MPrice] * [PM].[MReceivedQty] AS [PriceRec],
	
	[AS].[SupplierName],
	[AS].[SupShortName],
	*
FROM
	[SysproCompanyA].[dbo].[PorMasterDetail] [PM]
LEFT JOIN
	[SysproCompanyA].[dbo].[PorMasterHdr] [PH]
ON
	[PM].[PurchaseOrder] = [PH].[PurchaseOrder]
LEFT JOIN
	[SysproCompanyA].[dbo].[ApSupplier] [AS]
ON
	[PH].[Supplier] = [AS].[Supplier]
LEFT JOIN
	[SysproCompanyA].[dbo].[PorHistReceipt] [HR]
ON
	([PM].[PurchaseOrder] = [HR].[PurchaseOrder])
	--AND ([PM].[PurchaseOrder] = [HR].[Reference])
WHERE
	([PM].[MLatestDueDate] = @d)
	OR ([PM].[MOrigDueDate] = @d)
	OR ([PM].[MLatestDueDate] = @d)
	OR ([PH].[OrderEntryDate] = @d)
	OR ([PH].[OrderDueDate] = @d)
	OR ([PH].[MemoDate] = @d)