USE BWSdb
GO

SELECT * FROM [ProductionV2];

SELECT
	[Quote#]
	, [WO#]
	, [Stargate WO#]
FROM
	[dtProductionSchedule]
WHERE
	[Stargate WO#] IS NOT NULL
	AND [Stargate WO#] LIKE '%9646%'
;

SELECT
	[SGQuote]
	, [WO#]
	, [OrdersV2].[Invoice #]
	, [OrdersV2].[Slot#]
	, [OrdersV2].[Serial Number]
	, [OrdersV2].[Sales Order#]
	, [OrdersV2].[OrderID]
	, [OrdersV2].[Customer WO#]
	, *
FROM
	[OrdersV2]
WHERE
	[Serial Number] LIKE '%9646%'
	OR [Serial Number] LIKE '%9647%'
	OR [Serial Number] LIKE '%9644%'
	OR [Serial Number] LIKE '%9677%'
	OR [Serial Number] LIKE '%9678%'
	OR [Serial Number] LIKE '%9514%'
	OR [Serial Number] LIKE '%9977%'
	OR [Serial Number] LIKE '%9978%'
	OR [Serial Number] LIKE '%9976%'
	OR [Serial Number] LIKE '%9968%'
	OR [Serial Number] LIKE '%9979%'
	OR [Serial Number] LIKE '%9981%'
	OR [Serial Number] LIKE '%9980%'
	OR [Serial Number] LIKE '%9682%'
	OR [Serial Number] LIKE '%9683%'
	OR [Serial Number] LIKE '%9686%'
	OR [Serial Number] LIKE '%9676%'
	OR [Serial Number] LIKE '%9648%'
;