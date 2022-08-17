USE BWSdb
GO

SELECT 
	*
FROM
	[OrdersV2]
WHERE
	[Order Date] BETWEEN DATEADD(YEAR, -1, GETDATE()) AND GETDATE()
	
SELECT 
	[SGQuote],
	[WO#],
	[Serial Number]
FROM
	v_SGKnownQuotes
ORDER BY
	(CASE WHEN [WO#] = 10000649 THEN 0 ELSE 1 END),
	[WO#]

	
SELECT 
	[SGQuote],
	[WO#],
	[Serial Number],
	[Date Declined]
FROM
	[OrdersV2]
ORDER BY
	(CASE WHEN [WO#] = 10000649 THEN 0 ELSE 1 END),
	[WO#]

DECLARE @table AS TABLE ([ID] INT IDENTITY(1, 1), [WO#] INT)
INSERT INTO @table ([WO#])
SELECT
	[WO#]
FROM
	[OrdersV2]
GROUP BY
	[WO#]
HAVING COUNT(*) > 1

SELECT
	[@table].[WO#]
	, [SGQuote]
	, [Model No]
	, [Order Date] 
	, [Date Declined]
	, [DataEntryUser]
	, [DataEntryCheck]
	, [Serial Number]
FROM
	[OrdersV2]
INNER JOIN
	@table
ON
	[OrdersV2].[WO#] = [@table].[WO#]
ORDER BY
	[@table].[WO#]