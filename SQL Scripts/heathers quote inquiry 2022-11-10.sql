USE BWSdb
GO

SELECT
	[Quote#]
	, [WO#]
	, [Model No]
	, [Serial Number]
	, [Order Date]
	, [Requested Delivery Date]
	, [Available Date]
FROM
	[Orders]
WHERE 
	[Quote#] IN 
	(
		28244,
		28249,
		28353,
		27108,
		27925,
		27947
	)
;

SELECT
	[Quote#]
	, [WO#]
	, [Model No]
	, [Serial Number]
	, [Order Date]
	, [Requested Delivery Date]
	, [Available Date]
FROM
	[Orders] 
WHERE
	[Quote#] IN 
	(
		27700,
		27639,
		27638,
		28278,
		28287
	)
;