USE SysproCompanyA
GO
DECLARE @SD AS DATETIME;
DECLARE @ED AS DATETIME;
SET @SD = '2021-08-01';
SET @ED = '2021-08-27';

-- Steel Parts Kits
SELECT	
	@SD AS [SD],
	@ED AS [ED],
	[JobStartDate],
	[JobDeliveryDate],
	[StockCode],
	[Job]
FROM
	[WipMaster]
WHERE
	[JobStartDate] BETWEEN @SD AND @ED 
	AND [StockCode] LIKE 'SP%' 
	AND LEFT([Job], 1) = '7'
ORDER BY
	[JobDeliveryDate]
;

-- Truck and Pony Parts Kits
SELECT	
	@SD AS [SD],
	@ED AS [ED],
	[JobStartDate],
	[JobDeliveryDate],
	[StockCode],
	[Job]
FROM
	[WipMaster]
WHERE
	[JobStartDate] BETWEEN @SD AND @ED 
	AND ([StockCode] LIKE 'PF%' 
	OR [StockCode] LIKE 'TF%')
	AND LEFT([Job], 1) = '7'
ORDER BY
	[JobDeliveryDate]
;