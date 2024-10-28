
-- BWS Selects
SELECT
	'All Data Ungrouped' AS [Desc]
	,[Cal].[Date]
	,YEAR([Cal].[Date]) AS [ProdYear]
	,MONTH([Cal].[Date]) AS [ProdMonth]
	,DAY([Cal].[Date]) AS [ProDay]
	,[Cal].[Day]
	,[P].[Grouping]
	--,[Job]
	,COUNT([Job]) AS [AllInWip]
	/*,COUNT(*) AS [All]
	,COUNT([P].[Grouping]) AS [AllGrouping]*/
FROM
	[BWSdb].[dbo].[Calendar] [Cal]
CROSS JOIN
	[BWSdb].[dbo].[Products] [P]
LEFT JOIN (
	SELECT
		*
	FROM
		[SysproCompanyA].[dbo].[WipMaster] [Master]
	INNER JOIN
		[BWSdb].[dbo].[Orders] [O]
	ON
		CAST([Master].[Job] AS INT) = [O].[WO#]
	WHERE
		LEFT(ISNULL([Master].[Job], '1'), 1) = '1'
) AS [OrderSrc]
ON
	--([Cal].[Date] = [OrderSrc].[JobStartDate])
	([Cal].[Date] BETWEEN [OrderSrc].[JobStartDate] AND ISNULL([OrderSrc].[ActCompleteDate], DATEADD(DAY, 21, GETDATE())))
	AND ([P].[IDTrailer] = [OrderSrc].[ProductID])
WHERE
	([Cal].[Date] BETWEEN DATEADD(YEAR, -5, GETDATE()) AND DATEADD(DAY, 14, GETDATE()))
	AND ([P].[Non-Current] = 0)
	AND ([P].[Proposed] = 0)
GROUP BY
	[Cal].[Date]
	,[Cal].[Day]
	,[P].[Grouping]
ORDER BY
	[Cal].[Date]
	,[P].[Grouping]

-- STG Selects
SELECT
	'All Data Ungrouped' AS [Desc]
	,[Cal].[Date]
	,YEAR([Cal].[Date]) AS [ProdYear]
	,MONTH([Cal].[Date]) AS [ProdMonth]
	,DAY([Cal].[Date]) AS [ProDay]
	,[Cal].[Day]
	,[P2].[Grouping]
	--,[Job]
	,COUNT([Job]) AS [AllInWip]
	/*,COUNT(*) AS [All]
	,COUNT([P2].[Grouping]) AS [AllGrouping]*/
FROM
	[BWSdb].[dbo].[Calendar] [Cal]
CROSS JOIN
	[BWSdb].[dbo].[ProductsV2] [P2]
LEFT JOIN (
	SELECT
		*
	FROM
		[SysproCompanyS].[dbo].[WipMaster] [Master]
	INNER JOIN
		[BWSdb].[dbo].[OrdersV2] [O2]
	ON
		CAST([Master].[Job] AS INT) = [O2].[WO#]
	WHERE
		LEFT(ISNULL([Master].[Job], '1'), 1) = '1'
) AS [OrderSrc]
ON
	--([Cal].[Date] = [OrderSrc].[JobStartDate])
	([Cal].[Date] BETWEEN [OrderSrc].[JobStartDate] AND ISNULL([OrderSrc].[ActCompleteDate], DATEADD(DAY, 21, GETDATE())))
	AND ([P2].[IDTrailer] = [OrderSrc].[ProductID])
WHERE
	([Cal].[Date] BETWEEN DATEADD(YEAR, -5, GETDATE()) AND DATEADD(DAY, 14, GETDATE()))
	AND ([P2].[Non-Current] = 0)
	AND ([P2].[Proposed] = 0)
GROUP BY
	[Cal].[Date]
	,[Cal].[Day]
	,[P2].[Grouping]
ORDER BY
	[Cal].[Date]
	,[P2].[Grouping]