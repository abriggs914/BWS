/*
SELECT TOP 100
	[Description]
FROM
	[BWSdb].[dbo].[Order Options]
GROUP BY
	[Description]

SELECT
	*
FROM
	[BWSdb].[dbo].[IT Requests]
*/

SELECT
	[P].[Grouping]
	,[P].[Class]
	,[P].[Model No]
	,[OS].[SortG]
	,[OS].[Group]
	,[OS].[SortSe]
	,[OS].[Section]
	,COUNT(*) AS [CFreq]
FROM
	[BWSdb].[dbo].[Order Standards] [OS] WITH (NOLOCK)
INNER JOIN
	[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
ON
	[OS].[Quote#] = [O].[Quote#]
INNER JOIN
	[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
ON
	[O].[ProductID] = [P].[IDTrailer]
WHERE
	([O].[Decline/Rejected] = 4)
	AND ([P].[Proposed] = 0)
	AND ([P].[Non-Current] = 0)
GROUP BY
	[P].[Grouping]
	,[P].[Class]
	,[P].[Model No]
	,[OS].[SortG]
	,[OS].[Group]
	,[OS].[SortSe]
	,[OS].[Section]
ORDER BY
	[P].[Grouping]
	,[P].[Class]
	,[P].[Model No]
	,[OS].[SortG]
	,[OS].[SortSe]
;

SELECT
	[SortG]
	,[Group]
	,[SortSe]
	,[Section]
	,COUNT(*) AS [CFreq]
FROM
	[BWSdb].[dbo].[Order Standards]
GROUP BY
	[SortG]
	,[Group]
	,[SortSe]
	,[Section]
ORDER BY
	[SortG]
	,[SortSe]
;

-----------------------------------------------------------------------------------------------------------------------
-- Sorts and Labels

SELECT
	[SortG]
	,[Group]
	,COUNT(*) AS [CFreq]
FROM
	[BWSdb].[dbo].[Order Standards] [OS]
INNER JOIN
	[BWSdb].[dbo].[Orders] [O]
ON
	[OS].[Quote#] = [O].[Quote#]
WHERE
	[O].[Date Declined] IS NULL
GROUP BY
	[SortG]
	,[Group]
ORDER BY
	[SortG]
;

SELECT
	[SortSe]
	,[Section]
	,COUNT(*) AS [CFreq]
FROM
	[BWSdb].[dbo].[Order Standards] [OS]
INNER JOIN
	[BWSdb].[dbo].[Orders] [O]
ON
	[OS].[Quote#] = [O].[Quote#]
WHERE
	[O].[Date Declined] IS NULL
GROUP BY
	[SortSe]
	,[Section]
ORDER BY
	[SortSe]
;

-----------------------------------------------------------------------------------------------------------------------
-- Just Labels

SELECT
	[Group]
	,COUNT(*) AS [CFreq]
FROM
	[BWSdb].[dbo].[Order Standards] [OS]
INNER JOIN
	[BWSdb].[dbo].[Orders] [O]
ON
	[OS].[Quote#] = [O].[Quote#]
WHERE
	[O].[Date Declined] IS NULL
GROUP BY
	[Group]
ORDER BY
	[Group]
;

SELECT
	[Section]
	,COUNT(*) AS [CFreq]
FROM
	[BWSdb].[dbo].[Order Standards] [OS]
INNER JOIN
	[BWSdb].[dbo].[Orders] [O]
ON
	[OS].[Quote#] = [O].[Quote#]
WHERE
	[O].[Date Declined] IS NULL
GROUP BY
	[Section]
ORDER BY
	[Section]

-----------------------------------------------------------------------------------------------------------------------
-- Sorts and Labels
SELECT
	*
FROM (
	SELECT
		[SortSe]
		,[Section]
		,COUNT(*) AS [CFreq]
	FROM
		[BWSdb].[dbo].[Order Standards] [OS]
	INNER JOIN
		[BWSdb].[dbo].[Orders] [O]
	ON
		[OS].[Quote#] = [O].[Quote#]
	WHERE
		[O].[Date Declined] IS NULL
	GROUP BY
		[SortSe]
		,[Section]
) AS [Src]
GROUP BY
	ISNULL([SortSe], -1) 
	,ISNULL([Section], 'N/A')
ORDER BY
	[SortSe]