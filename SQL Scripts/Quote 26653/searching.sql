USE BWSdb
GO

DECLARE @q AS INT;
SET @q = 26653;

SELECT
	[Dealers].[COMPANY NAME],
	[Orders].*
FROM
	[Orders] 
INNER JOIN
	[Dealers]
ON
	[Dealers].[ID] = [Orders].[DealerID]
WHERE
	[Quote#] = @q
;

SELECT
	[Dealers].[COMPANY NAME],
	[Orders].*
FROM
	[Orders] 
INNER JOIN
	[Dealers]
ON
	[Dealers].[ID] = [Orders].[DealerID]
WHERE
	[Quote#] = @q
;

SELECT
	*
FROM
	[Production Slots]
WHERE
	[Quote#] = @q

SELECT
	[Orders].[Quote#],
	[Slot#],
	[Slot Date],
	[Quote Date],
	[Order Date],
	[WO#],
	[Orders].[Model No],
	[Dealers].[COMPANY NAME],
	[Serial Number],
	[Available Date],
	[Delivery Date],
	[Requested Delivery Date]
FROM
	[Orders]
INNER JOIN
	[Dealers]
ON
	[Dealers].[ID] = [Orders].[DealerID]
LEFT JOIN
	[Production Slots]
ON
	[Orders].[Quote#] = [Production Slots].[Quote#]
WHERE
	[Slot#] IS NOT NULL
	AND [Delivery Date] IS NULL
	AND [Order Date] IS NULL
ORDER BY
	[COMPANY NAME],
	[Quote#],
	[Quote Date]