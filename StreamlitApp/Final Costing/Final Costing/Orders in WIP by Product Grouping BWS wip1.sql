SELECT
	'All Days' AS [Desc]
	,[Cal].*
FROM
	[BWSdb].[dbo].[Calendar] [Cal]
;

SELECT
	'All Data Ungrouped' AS [Desc]
	,[Cal].*
	,[Master].*
	,[O].*
FROM
	[BWSdb].[dbo].[Calendar] [Cal]
LEFT JOIN
	[SysproCompanyA].[dbo].[WipMaster] [Master]
ON
	[Cal].[Date] = [Master].[JobStartDate]
LEFT JOIN
	[BWSdb].[dbo].[Orders] [O]
ON
	CAST([Master].[Job] AS INT) = [O].[WO#]
WHERE
	([Cal].[Date] BETWEEN DATEADD(YEAR, -5, GETDATE()) AND DATEADD(YEAR, 5, GETDATE()))
	AND (LEFT(ISNULL([Master].[Job], '1'), 1) = '1')
ORDER BY
	[Cal].[Date]
;


SELECT
	[Date]
	/*
	,[Model No]
	,COUNT([Model No]) AS [NumUnits]
	*/
	/*
	,[Class]
	,COUNT([Class]) AS [NumUnits]
	*/
	,[Grouping]
	,COUNT([Grouping]) AS [NumUnits]
FROM (
	SELECT
		--'All Data Ungrouped' AS [Desc]
		--,
		[Cal].*
		,[Master].*
		,[O].*
		,[P].[Grouping]
		,[P].[Class]
	FROM
		[BWSdb].[dbo].[Calendar] [Cal]
	CROSS JOIN
		[BWSdb].[dbo].[Products] [P]
	LEFT JOIN
		[SysproCompanyA].[dbo].[WipMaster] [Master]
	ON
		[Cal].[Date] = [Master].[JobStartDate]
	LEFT JOIN
		[BWSdb].[dbo].[Orders] [O]
	ON
		CAST([Master].[Job] AS INT) = [O].[WO#]
	--ON		[O].[ProductID] = [P].[IDTrailer]
	WHERE
		([Cal].[Date] BETWEEN DATEADD(YEAR, -5, GETDATE()) AND DATEADD(YEAR, 5, GETDATE()))
		AND (LEFT(ISNULL([Master].[Job], '1'), 1) = '1')
		AND (ISNULL([P].[CompanyID], 0) = 0)
		AND ([O].[ProductID] = [P].[IDTrailer])
) AS [Src]
GROUP BY
	[Date]
	--,[Model No]
	--,[Class]
	,[Grouping]
ORDER BY
	[Date]
;
;


SELECT
	[Date]
	/*
	,[Model No]
	,COUNT([Model No]) AS [NumUnits]
	*/
	/*
	,[Class]
	,COUNT([Class]) AS [NumUnits]
	*/
	,[Grouping]
	,COUNT([Grouping]) AS [NumUnits]
FROM (
	SELECT
		--'All Data Ungrouped' AS [Desc]
		--,
		[Cal].*
		,[Master].*
		,[O].*
		,[P].[Grouping]
		,[P].[Class]
	FROM
		[BWSdb].[dbo].[Calendar] [Cal]
	CROSS JOIN
		[BWSdb].[dbo].[Products] [P]
	--ON		[O].[ProductID] = [P].[IDTrailer]
	WHERE
		([Cal].[Date] BETWEEN DATEADD(YEAR, -5, GETDATE()) AND DATEADD(YEAR, 5, GETDATE()))
		AND (LEFT(ISNULL([Master].[Job], '1'), 1) = '1')
		AND (ISNULL([P].[CompanyID], 0) = 0)
		AND ([O].[ProductID] = [P].[IDTrailer])
) AS [Src]
GROUP BY
	[Date]
	--,[Model No]
	--,[Class]
	,[Grouping]
ORDER BY
	[Date]
;


SELECT
	'All Data Ungrouped' AS [Desc]
	,* 
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
	([Cal].[Date] = [OrderSrc].[JobStartDate])
	AND ([P].[IDTrailer] = [OrderSrc].[ProductID])
WHERE
	([Cal].[Date] BETWEEN DATEADD(YEAR, -5, GETDATE()) AND DATEADD(YEAR, 5, GETDATE()))