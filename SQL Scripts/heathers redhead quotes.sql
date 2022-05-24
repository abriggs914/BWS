USE BWSdb
GO
SELECT 
	[Quote#]
	, [WO#]
	, [Serial Number]
	, [Purchase Order]
	, [Quote Date]
	, [Order Date]
	, [Delivery Date]
	, [PO Date]
	, [Model No]
	, [Width]
	, [Spread]
	, [COMPANY NAME]
	, CAST([Price] AS DECIMAL(16, 3)) AS [ORIGINAL Price]
	, CAST(1.05 * [Price] AS DECIMAL(16, 3)) AS [5% Increase Price]
	, CAST(1.06 * [Price] AS DECIMAL(16, 3)) AS [6% Increase Price]
	, CAST(1.06 * 1.05 * [Price] AS DECIMAL(16, 3)) AS [6% + 5% Increase Price]
	, (CASE WHEN [Orders].[US Sale] = 1 THEN 'YES' ELSE 'NO' END) AS [IsUSSale]
FROM
	[Orders]
LEFT JOIN 
	[Dealers]
ON
	[Orders].[DealerID] = [Dealers].[ID]
WHERE
	[COMPANY NAME] LIKE '%redhead%'
	AND [Date Declined] IS NULL
	AND [Quote Date] > '2021-01-01'
	--AND [Order Date] IS NOT NULL
	--AND ([Delivery Date] IS NULL OR [Delivery Date] > GETDATE())
ORDER BY
	[Quote Date] DESC