-- WSOM WIP 4

SELECT
	[O_CW_Src].[TrailerID]
	, [O_CW_Src].[TrailerID]
	, [O_CW_Src].[Quote]
	, [O_CW_Src].[CW_Desc]
	, [O_CW_Src].[CW_Qty]
FROM (
	SELECT
		[P].[IDTrailer] AS [TrailerID]
		, [CW].[Description] AS [CW_Desc]
		, [CW].[Qty] AS [CW_Qty]
	FROM
		[BWSdb].[dbo].[Custom Work] [CW] WITH (NOLOCK)
	INNER JOIN
		[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
	ON
		[CW].[Quote#] = [O].[Quote#]
	INNER JOIN
		[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
	ON
		[O].[ProductID] = [P].[IDTrailer]
	GROUP BY
		[P].[IDTrailer]
		, [CW].[Description]
		, [CW].[Qty]
	HAVING 
		COUNT(*) > 1
) AS [CW_Src]
INNER JOIN (
	SELECT
		[O].[Quote#]
		, [P].[IDTrailer] AS [TrailerID]
		, [O].[Quote#] AS [Quote]
		, [CW].[Description] AS [CW_Desc]
		, [CW].[Qty] AS [CW_Qty]
	FROM
		[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
	INNER JOIN
		[BWSdb].[dbo].[Custom Work] [CW] WITH (NOLOCK)
	ON
		[CW].[Quote#] = [O].[Quote#]
	INNER JOIN
		[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
	ON
		[O].[ProductID] = [P].[IDTrailer]
) AS [O_CW_Src]
ON
	([CW_Src].[CW_Desc] = [O_CW_Src].[CW_Desc])
	AND ([CW_Src].[CW_Qty] = [O_CW_Src].[CW_Qty])
	AND ([CW_Src].[TrailerID] = [O_CW_Src].[TrailerID])
/*ORDER BY
	[O_CW_Src].[Quote#] DESC*/