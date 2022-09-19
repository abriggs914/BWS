USE SysproCompanyA
GO

SELECT
	[SysproCompanyA].[dbo].[InvMaster].[StockCode]
	, [SysproCompanyA].[dbo].[InvMaster].[Ebq]
	, [SysproCompanyA].[dbo].[InvMaster].[EbqPan]
	, [SysproCompanyA].[dbo].[InvMaster].[DockToStock]
	, [SysproCompanyA].[dbo].[InvMaster].[FixOverhead]
	, [SysproCompanyA].[dbo].[InvMaster].[FixTimePeriod]
	, [SysproCompanyA].[dbo].[InvMaster].[BatchBill]
	, [SysproCompanyA].[dbo].[InvMaster].[LeadTime]
	, [SysproCompanyA].[dbo].[InvMaster].[Supplier]
FROM
	[InvMaster]
;

SELECT
	[SysproCompanyA].[dbo].[InvWarehouse].[StockCode]
	, [SysproCompanyA].[dbo].[InvWarehouse].[Supplier]
	, [SysproCompanyA].[dbo].[InvWarehouse].[DockToStock]
	, [SysproCompanyA].[dbo].[InvWarehouse].[FixedOverhead]
	, [SysproCompanyA].[dbo].[InvWarehouse].[OrderFixPeriod]
	, [SysproCompanyA].[dbo].[InvWarehouse].[TrfFixTimePeriod]
	, [SysproCompanyA].[dbo].[InvWarehouse].[LeadTime]
	, [SysproCompanyA].[dbo].[InvWarehouse].[SafetyStockQty]
FROM [InvWarehouse]
;

SELECT * FROM [SysproCompanyA].[dbo].[InvMaster];
SELECT * FROM [SysproCompanyA].[dbo].[InvWarehouse];