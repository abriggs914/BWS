USE SysproCompanyA
GO

DECLARE @dtInvMaster AS TABLE 
(
	[ID] INT IDENTITY(1, 1)
	, [DateCreated] DATETIME DEFAULT GETDATE()
	, [StockCode] NVARCHAR(MAX)
	, [Description] NVARCHAR(MAX)
	, [LongDesc] NVARCHAR(MAX)
);

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