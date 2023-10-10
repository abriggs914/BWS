USE BWSdb
GO

-- 9	- NE
-- 330	- RL

SELECT
	[Quote#]
	, [D].[ID]
	, [COMPANY NAME]
	, [WO#]
	, [Model No]
	, [Quote Date]
	, [Order Date]
	, [Shipped Date]
	, [Delivery Date]
	, [Date Registered]
	, [Decline/Rejected]
	, [Date Declined]
	, [Price]
	, [US Sale]
FROM
	[Orders] AS [O]
LEFT JOIN
	[Dealers] AS [D]
ON
	[O].[DealerID] = [D].[ID]
WHERE
	[D].[ID] = 330

SELECT
	--[Quote#]
	--, [WO#]
	--, [Model No]
	--, [Quote Date]
	--, [Order Date]
	--, [Shipped Date]
	--, [Delivery Date]
	--, [Date Registered]
	[Decline/Rejected]
	--, [Date Declined]
	, SUM([Price]) AS [SumPrice]
	, [US Sale]
	, COUNT(*)
FROM
	[Orders] AS [O]
LEFT JOIN
	[Dealers] AS [D]
ON
	[O].[DealerID] = [D].[ID]
WHERE
	[D].[ID] = 330
GROUP BY
	[Decline/Rejected]
	--, [Date Declined]
	, [US Sale]
ORDER BY
	[Decline/Rejected]
	, [US Sale]