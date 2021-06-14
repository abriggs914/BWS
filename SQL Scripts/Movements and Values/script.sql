USE SysproCompanyA
GO

SELECT * FROM [InvMovements]
	WHERE [Warehouse] LIKE '%02%'

SELECT * FROM [InvWarehouse]
	WHERE [Warehouse] LIKE '%02%'

SELECT [StockCode], [Description], [LongDesc] FROM [InvMaster]

--------------------------------------------------------------------------


SELECT InvMaster.[StockCode], InvMaster.[Description], InvMaster.[LongDesc]
FROM [InvMaster]
LEFT JOIN
	InvMovements
ON InvMovements.[StockCode] IS NOT NULL
	AND InvMovements.[Warehouse] LIKE '%02%'
	AND InvMovements.[StockCode] = InvMaster.[StockCode]
	
	

SELECT InvMaster.[StockCode], InvMaster.[Description], InvMaster.[LongDesc]
FROM [InvMaster]
LEFT JOIN
	InvMovements
ON InvMovements.[StockCode] IS NOT NULL
	AND InvMovements.[Warehouse] LIKE '%02%'
	AND InvMovements.[StockCode] = InvMaster.[StockCode]


SELECT InvMaster.[StockCode], InvMaster.[Description], InvMaster.[LongDesc]
FROM [InvMaster]
LEFT JOIN
	InvWarehouse
ON InvWarehouse.[StockCode] IS NOT NULL
	AND InvWarehouse.[Warehouse] LIKE '%02%'
	AND InvWarehouse.[StockCode] = InvMaster.[StockCode]

-----------------------------------------------------------------------------

SELECT * FROM [InvWarehouse] as a
JOIN
(
SELECT InvMaster.[StockCode], InvMaster.[Description], InvMaster.[LongDesc]
FROM [InvMaster]
INNER JOIN
	InvWarehouse
ON InvWarehouse.[StockCode] IS NOT NULL
	AND InvWarehouse.[Warehouse] LIKE '%02%'
	AND InvWarehouse.[StockCode] = InvMaster.[StockCode]) as b
ON a.[StockCode] = b.[StockCode]

----------------------------------------------------------------------

SELECT
	InvMaster.[StockCode], InvMaster.[Description], InvMaster.[LongDesc], InvWarehouse.*
FROM
	InvWarehouse
INNER JOIN
	InvMaster
ON
	InvWarehouse.[Warehouse] LIKE '%02%'
	AND	InvWarehouse.[StockCode] = InvMaster.[StockCode];

SELECT
	InvMaster.[StockCode], InvMaster.[Description], InvMaster.[LongDesc], InvMovements.*
FROM
	InvMovements
INNER JOIN
	InvMaster
ON
	InvMovements.[Warehouse] LIKE '%02%'
	AND	InvMovements.[StockCode] = InvMaster.[StockCode];