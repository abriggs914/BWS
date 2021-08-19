USE BWSdb
GO


--	[Quote#],
	--[Model No],
	--[Delivery Date],
	--[Date In Service]

SELECT *
FROM
	[Orders]
INNER JOIN
	[Dealers]
ON
	[Dealers].[ID] = [Orders].[DealerID]
WHERE
	[Orders].[DealerID] = 5
	AND [Date In Service] IS NULL
	AND [Delivery Date] IS NOT NULL
	AND [Delivery Date] < GETDATE()
ORDER BY
	[Delivery Date]