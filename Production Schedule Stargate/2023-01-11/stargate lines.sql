USE Stargatedb
GO
SELECT DISTINCT
	[Prod Line]
	, [Order]
FROM (
	SELECT
		'TL' AS [Prod Line]
		, 1 AS [Order]
	UNION ALL
	SELECT 
		'LBL', 2
	UNION ALL
	SELECT 
		'WFL', 3
	UNION ALL
	SELECT 
		'TBL', 4
	UNION ALL
	SELECT 
		'PL', 5
	--UNION ALL
	--SELECT DISTINCT
	--	[Prod Line], [ID] + 100
	--FROM
	--	[Prod Lines]
	UNION ALL
	SELECT DISTINCT
		[Prod Line], [ID] + 1000
	FROM
		[BWSdb].[dbo].[Prod Lines]
	INNER JOIN
		[BWSdb].[dbo].[OrdersV2]
	ON
		[Prod Lines].[Prod Line] = [OrdersV2].[l]
) AS [SubA]
ORDER BY
	[Order]
	, [Prod Line]