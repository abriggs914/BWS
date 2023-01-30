USE BWSdb
GO

SELECT DISTINCT
	[Prod Line]
	, MIN([Order]) AS [OrderB]
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
	UNION ALL
	SELECT DISTINCT [Prod Line], [ProductionV2].[Prod#] + 1000 FROM [ProductionV2]
	UNION ALL
	SELECT DISTINCT [Prod Line2], [ProductionV2].[Prod#] + 2000 FROM [ProductionV2]
	UNION ALL	
	SELECT DISTINCT [JobStartLine], [dtProductionScheduleV2].[ProdSchedV2ID#] + 3000 FROM [Stargatedb].[dbo].[dtProductionScheduleV2]

) AS [SubA]
WHERE
	[Prod Line] IS NOT NULL
GROUP BY
	[Prod Line]
ORDER BY
	[OrderB],
	[Prod Line]
;

--SELECT * FROM [OrdersV2]
--SELECT DISTINCT [Prod Line], [Prod Line2] FROM [ProductionV2]
--SELECT DISTINCT [JobStartLine] FROM [Stargatedb].[dbo].[dtProductionScheduleV2]