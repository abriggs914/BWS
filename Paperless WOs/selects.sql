USE SysproCompanyA
GO

SELECT
	[StockCode]
	, [Description]
	, [LongDesc]
	, [Supplier]
	, [ProductClass]
	, [PartCategory]
	, [DrawOfficeNum]
	, [WarehouseToUse]

	, [SupplUnitCode]

	, *
FROM
	[InvMaster]
ORDER BY
	[DateStkAdded] DESC
;

select *
FROM
    [InvAltStock] with (nolock)
;

select *
FROM
    [InvAltSupplier] with (nolock)
;

select *
from
    PorSupStkInfo with (nolock)
;