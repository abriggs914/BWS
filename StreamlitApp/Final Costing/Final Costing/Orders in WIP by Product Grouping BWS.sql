
SELECT
	'All Data Ungrouped' AS [Desc]
	,[Cal].[Date]
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
	([Cal].[Date] BETWEEN [OrderSrc].[JobStartDate] AND ISNULL([OrderSrc].[ActCompleteDate], DATEADD(MONTH, 4, GETDATE())))
	AND ([P].[IDTrailer] = [OrderSrc].[ProductID])
WHERE
	([Cal].[Date] BETWEEN DATEADD(YEAR, -5, GETDATE()) AND DATEADD(MONTH, 14, GETDATE()))
	AND ([P].[Non-Current] = 0)
	AND ([P].[Proposed] = 0)
GROUP BY
	[Cal].[Date]
	,[Cal].[Day]
	,[P].[Grouping]
ORDER BY
	[Cal].[Date]
	,[P].[Grouping]