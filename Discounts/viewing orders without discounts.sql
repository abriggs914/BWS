USE BWSdb
GO

SELECT 
	[Quote#]
	, [WO#]
	, [Model No]
	, [Quote Date]
	, [Order Date]
	, [DiscountID]
	, [ProductID]
FROM
	[Orders]
ORDER BY
	[Order Date] DESC
;

SELECT 
	[Quote#]
	, [WO#]
	, [Model No]
	, [Quote Date]
	, [Order Date]
	, [DiscountID]
	, [ProductID]
FROM
	[Orders]
ORDER BY
	[DiscountID] DESC
;

SELECT 
	[Quote#]
	, [WO#]
	, [Model No]
	, [Quote Date]
	, [Order Date]
	, [DiscountID]
	, [ProductID]
FROM
	[Orders]
ORDER BY
	[Quote Date] DESC
;