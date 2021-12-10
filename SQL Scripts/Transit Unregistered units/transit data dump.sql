
SELECT
	[SGQuote],
	[Quote Date],
	[Order Date],
	[WO#],
	[Sales Order#],
	[Model No],
	[Price],
	[Serial Number],
	[Available Date],
	[Delivery Date],
	[Purchase Order],
	[PO Date],
	[Shipped Date],
	[Date Registered]
FROM
	[OrdersV2]
WHERE
	[Date Registered] IS NULL
	AND [Delivery Date] BETWEEN DATEADD(YEAR, -5, GETDATE()) AND GETDATE()
	AND [DealerID] IN ((2), (134), (298))
ORDER BY
	[Delivery Date] DESC
;

SELECT
	[SGQuote],
	[Quote Date],
	[Order Date],
	[WO#],
	[Sales Order#],
	[Model No],
	[Price],
	[Serial Number],
	[Available Date],
	[Delivery Date],
	[Purchase Order],
	[PO Date],
	[Shipped Date],
	[Date Registered]
FROM
	[OrdersV2]
WHERE
	[Date Registered] IS NULL
	AND [Shipped Date] BETWEEN DATEADD(YEAR, -5, GETDATE()) AND GETDATE()
	AND [DealerID] IN ((2), (134), (298))
ORDER BY
	[Delivery Date] DESC
;