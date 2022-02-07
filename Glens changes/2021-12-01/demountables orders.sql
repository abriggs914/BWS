USE BWSdb
GO


--	[Quote#],
	--[Model No],
	--[Delivery Date],
	--[Date In Service]




SELECT 
	[Orders].[Shipped Date],
	[Orders].[Date In Service],
	*
FROM
	[Orders]
INNER JOIN
	[Dealers]
ON
	[Dealers].[ID] = [Orders].[DealerID]
WHERE
	[Orders].[DealerID] = 5
	AND [Date In Service] IS NULL
	AND [Shipped Date] IS NOT NULL
	AND [Delivery Date] < GETDATE()
ORDER BY
	[Delivery Date]

BEGIN TRAN;

SELECT * FROM [Orders] WHERE
	[Orders].[DealerID] = 5
	AND [Date In Service] IS NULL
	AND [Shipped Date] IS NOT NULL
	AND [Delivery Date] < GETDATE()
;

UPDATE
	[Orders]
SET
	[Date In Service] = [Shipped Date]
WHERE
	[Orders].[DealerID] = 5
	AND [Date In Service] IS NULL
	AND [Shipped Date] IS NOT NULL
	AND [Delivery Date] < GETDATE()

SELECT * FROM [Orders] WHERE
	[Orders].[DealerID] = 5
	AND [Date In Service] IS NULL
	AND [Shipped Date] IS NOT NULL
	AND [Delivery Date] < GETDATE()
;

ROLLBACK;
COMMIT;