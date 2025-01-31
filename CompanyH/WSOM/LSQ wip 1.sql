
-- WSOM WIP 1

SELECT		
	'OS' AS [T]
	, [OS2].[Quote#]
	, NULL AS [Order Date]
	, [OS2].[WO#]
	, [OS2].[Model No]
	, [Os2].[Group] AS [OS_Group]
	, [Os2].[Section] AS [OS_Section]
	, [Os2].[Description] AS [OS_Desc]
	, [OS2].[Standard No] AS [OS_NO]
	, NULL AS [OP_NO]
	, NULL AS [OP_Desc]
	, NULL AS [OP_Qty]
	, NULL AS [CW_Desc]
FROM
	[BWSdb].[dbo].[Order Standards] [OS2] WITH (NOLOCK)
	
UNION ALL

SELECT		
	'OP' AS [T]
	, [OP2].[Quote#]
	, [OP2].[Order Date]
	, [OP2].[WO#]
	, [P].[Model No] AS [Model No]
	, NULL AS [OS_Group]
	, NULL AS [OS_Section]
	, NULL AS [OS_Desc]
	, NULL AS [OS_NO]
	, [OP2].[Option No] AS [OP_NO]
	, [OP2].[Description] AS [OP_Desc]
	, [OP2].[Qty] AS [OP_Qty]
	, NULL AS [CW_Desc]
FROM
	[BWSdb].[dbo].[Order Options] [OP2] WITH (NOLOCK)
INNER JOIN
	[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
ON
	[OP2].[Quote#] = [O].[Quote#]
INNER JOIN
	[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
ON
	[O].[ProductID] = [P].[IDTrailer]
	
UNION ALL

SELECT		
	'CW' AS [T]
	, [CW2].[Quote#]
	, [CW2].[Order Date]
	, [CW2].[WO#]
	, [P].[Model No] AS [Model No]
	, NULL AS [OS_Group]
	, NULL AS [OS_Section]
	, NULL AS [OS_Desc]
	, NULL AS [OS_NO]
	, NULL AS [OP_NO]
	, NULL AS [OP_Desc]
	, NULL AS [OP_Qty]
	, [CW2].[Description] AS [CW_Desc]
FROM
	[BWSdb].[dbo].[Custom Work] [CW2] WITH (NOLOCK)
INNER JOIN
	[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
ON
	[CW2].[Quote#] = [O].[Quote#]
INNER JOIN
	[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
ON
	[O].[ProductID] = [P].[IDTrailer]
WHERE
	LTRIM(RTRIM(LOWER(ISNULL([CW2].[Description], '')))) <> 'none'

ORDER BY
	[Quote#] DESC
	, [T]
;

-----------------------------------------------------------------
-----------------------------------------------------------------
-----------------------------------------------------------------

-- 2


SELECT
	*
FROM (
	SELECT
		[T]
		, [Model No]
		, [OS_Group]
		, [OS_Section]
		, [OS_Desc]
		, [OS_NO]
		, [OP_NO]
		, [OP_Desc]
		, [OP_Qty]
		, [CW_Desc]
		, COUNT(*) AS [Count]
	FROM (
		SELECT		
			'OS' AS [T]
			, [OS2].[Model No]
			, [Os2].[Group] AS [OS_Group]
			, [Os2].[Section] AS [OS_Section]
			, [Os2].[Description] AS [OS_Desc]
			, [OS2].[Standard No] AS [OS_NO]
			, NULL AS [OP_NO]
			, NULL AS [OP_Desc]
			, NULL AS [OP_Qty]
			, NULL AS [CW_Desc]
		FROM
			[BWSdb].[dbo].[Order Standards] [OS2] WITH (NOLOCK)
	
		UNION ALL

		SELECT		
			'OP' AS [T]
			, [P].[Model No] AS [Model No]
			, NULL AS [OS_Group]
			, NULL AS [OS_Section]
			, NULL AS [OS_Desc]
			, NULL AS [OS_NO]
			, [OP2].[Option No] AS [OP_NO]
			, [OP2].[Description] AS [OP_Desc]
			, [OP2].[Qty] AS [OP_Qty]
			, NULL AS [CW_Desc]
		FROM
			[BWSdb].[dbo].[Order Options] [OP2] WITH (NOLOCK)
		INNER JOIN
			[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
		ON
			[OP2].[Quote#] = [O].[Quote#]
		INNER JOIN
			[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
		ON
			[O].[ProductID] = [P].[IDTrailer]
	
		UNION ALL

		SELECT		
			'CW' AS [T]
			, [P].[Model No] AS [Model No]
			, NULL AS [OS_Group]
			, NULL AS [OS_Section]
			, NULL AS [OS_Desc]
			, NULL AS [OS_NO]
			, NULL AS [OP_NO]
			, NULL AS [OP_Desc]
			, NULL AS [OP_Qty]
			, [CW2].[Description] AS [CW_Desc]
		FROM
			[BWSdb].[dbo].[Custom Work] [CW2] WITH (NOLOCK)
		INNER JOIN
			[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
		ON
			[CW2].[Quote#] = [O].[Quote#]
		INNER JOIN
			[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
		ON
			[O].[ProductID] = [P].[IDTrailer]
		WHERE
			LTRIM(RTRIM(LOWER(ISNULL([CW2].[Description], '')))) <> 'none'
	) AS [A]
	GROUP BY
		[T]
		, [Model No]
		, [OS_Group]
		, [OS_Section]
		, [OS_Desc]
		, [OS_NO]
		, [OP_NO]
		, [OP_Desc]
		, [OP_Qty]
		, [CW_Desc]
) AS [B]
INNER JOIN (
	SELECT		
		'OS' AS [T]
		, [OS2].[Quote#]
		, NULL AS [Order Date]
		, [OS2].[WO#]
		, [OS2].[Model No]
		, [Os2].[Group] AS [OS_Group]
		, [Os2].[Section] AS [OS_Section]
		, [Os2].[Description] AS [OS_Desc]
		, [OS2].[Standard No] AS [OS_NO]
		, NULL AS [OP_NO]
		, NULL AS [OP_Desc]
		, NULL AS [OP_Qty]
		, NULL AS [CW_Desc]
	FROM
		[BWSdb].[dbo].[Order Standards] [OS2] WITH (NOLOCK)
	
	UNION ALL

	SELECT		
		'OP' AS [T]
		, [OP2].[Quote#]
		, [OP2].[Order Date]
		, [OP2].[WO#]
		, [P].[Model No] AS [Model No]
		, NULL AS [OS_Group]
		, NULL AS [OS_Section]
		, NULL AS [OS_Desc]
		, NULL AS [OS_NO]
		, [OP2].[Option No] AS [OP_NO]
		, [OP2].[Description] AS [OP_Desc]
		, [OP2].[Qty] AS [OP_Qty]
		, NULL AS [CW_Desc]
	FROM
		[BWSdb].[dbo].[Order Options] [OP2] WITH (NOLOCK)
	INNER JOIN
		[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
	ON
		[OP2].[Quote#] = [O].[Quote#]
	INNER JOIN
		[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
	ON
		[O].[ProductID] = [P].[IDTrailer]
	
	UNION ALL

	SELECT		
		'CW' AS [T]
		, [CW2].[Quote#]
		, [CW2].[Order Date]
		, [CW2].[WO#]
		, [P].[Model No] AS [Model No]
		, NULL AS [OS_Group]
		, NULL AS [OS_Section]
		, NULL AS [OS_Desc]
		, NULL AS [OS_NO]
		, NULL AS [OP_NO]
		, NULL AS [OP_Desc]
		, NULL AS [OP_Qty]
		, [CW2].[Description] AS [CW_Desc]
	FROM
		[BWSdb].[dbo].[Custom Work] [CW2] WITH (NOLOCK)
	INNER JOIN
		[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
	ON
		[CW2].[Quote#] = [O].[Quote#]
	INNER JOIN
		[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
	ON
		[O].[ProductID] = [P].[IDTrailer]
	WHERE
		LTRIM(RTRIM(LOWER(ISNULL([CW2].[Description], '')))) <> 'none'
) AS [C]
ON
	--([B].[Model No] = [C].[Model No])
	--AND ([B].[OS_Group] = [C].[OS_Group])
	--AND ([B].[OS_Section] = [C].[OS_Section])
	--AND ([B].[OS_Desc] = [C].[OS_Desc])
	--AND ([B].[OP_Desc] = [C].[OP_Desc])
	--AND ([B].[OP_Qty] = [C].[OP_Qty])
	--AND ([B].[CW_Desc] = [C].[CW_Desc])

	([C].[Model No] = [B].[Model No])
	AND	(
		(
			([C].[OS_Group] IS NOT NULL) 
			AND	([C].[OS_Section] IS NOT NULL) 
			AND	([C].[OS_Desc] IS NOT NULL) 
			AND	([C].[OS_Group] = [B].[OS_Group])
			AND ([C].[OS_Section] = [B].[OS_Section])
			AND ([C].[OS_Desc] = [B].[OS_Desc])
		)
		OR (
			([C].[OP_Desc] IS NOT NULL)
			AND ([C].[OP_Qty] IS NOT NULL)
			AND ([C].[OP_Desc] = [B].[OP_Desc])
			AND ([C].[OP_Qty] = [B].[OP_Qty])
		)
		OR (
			([C].[CW_Desc] IS NOT NULL)
			AND ([C].[CW_Desc] = [B].[CW_Desc])
		)
	)
;

-----------------------------------------------------------------
-----------------------------------------------------------------
-----------------------------------------------------------------

-- 3

SELECT
	*
FROM (
	SELECT
		[T]
		, [Model No]
		, [OS_Group]
		, [OS_Section]
		, [OS_Desc]
		, [OS_NO]
		, [OP_NO]
		, [OP_Desc]
		, [OP_Qty]
		, [CW_Desc]
		, COUNT(*) AS [Count]
	FROM (
		SELECT		
			'OS' AS [T]
			, [OS2].[Model No]
			, [Os2].[Group] AS [OS_Group]
			, [Os2].[Section] AS [OS_Section]
			, [Os2].[Description] AS [OS_Desc]
			, [OS2].[Standard No] AS [OS_NO]
			, NULL AS [OP_NO]
			, NULL AS [OP_Desc]
			, NULL AS [OP_Qty]
			, NULL AS [CW_Desc]
		FROM
			[BWSdb].[dbo].[Order Standards] [OS2] WITH (NOLOCK)
	
		UNION ALL

		SELECT		
			'OP' AS [T]
			, [P].[Model No] AS [Model No]
			, NULL AS [OS_Group]
			, NULL AS [OS_Section]
			, NULL AS [OS_Desc]
			, NULL AS [OS_NO]
			, [OP2].[Option No] AS [OP_NO]
			, [OP2].[Description] AS [OP_Desc]
			, [OP2].[Qty] AS [OP_Qty]
			, NULL AS [CW_Desc]
		FROM
			[BWSdb].[dbo].[Order Options] [OP2] WITH (NOLOCK)
		INNER JOIN
			[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
		ON
			[OP2].[Quote#] = [O].[Quote#]
		INNER JOIN
			[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
		ON
			[O].[ProductID] = [P].[IDTrailer]
	
		UNION ALL

		SELECT		
			'CW' AS [T]
			, [P].[Model No] AS [Model No]
			, NULL AS [OS_Group]
			, NULL AS [OS_Section]
			, NULL AS [OS_Desc]
			, NULL AS [OS_NO]
			, NULL AS [OP_NO]
			, NULL AS [OP_Desc]
			, NULL AS [OP_Qty]
			, [CW2].[Description] AS [CW_Desc]
		FROM
			[BWSdb].[dbo].[Custom Work] [CW2] WITH (NOLOCK)
		INNER JOIN
			[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
		ON
			[CW2].[Quote#] = [O].[Quote#]
		INNER JOIN
			[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
		ON
			[O].[ProductID] = [P].[IDTrailer]
		WHERE
			LTRIM(RTRIM(LOWER(ISNULL([CW2].[Description], '')))) <> 'none'
	) AS [A]
	GROUP BY
		[T]
		, [Model No]
		, [OS_Group]
		, [OS_Section]
		, [OS_Desc]
		, [OS_NO]
		, [OP_NO]
		, [OP_Desc]
		, [OP_Qty]
		, [CW_Desc]
) AS [B]
INNER JOIN (
	SELECT		
		'OS' AS [T]
		, [OS2].[Quote#]
		, NULL AS [Order Date]
		, [OS2].[WO#]
		, [OS2].[Model No]
		, [Os2].[Group] AS [OS_Group]
		, [Os2].[Section] AS [OS_Section]
		, [Os2].[Description] AS [OS_Desc]
		, [OS2].[Standard No] AS [OS_NO]
		, NULL AS [OP_NO]
		, NULL AS [OP_Desc]
		, NULL AS [OP_Qty]
		, NULL AS [CW_Desc]
	FROM
		[BWSdb].[dbo].[Order Standards] [OS2] WITH (NOLOCK)
	
	UNION ALL

	SELECT		
		'OP' AS [T]
		, [OP2].[Quote#]
		, [OP2].[Order Date]
		, [OP2].[WO#]
		, [P].[Model No] AS [Model No]
		, NULL AS [OS_Group]
		, NULL AS [OS_Section]
		, NULL AS [OS_Desc]
		, NULL AS [OS_NO]
		, [OP2].[Option No] AS [OP_NO]
		, [OP2].[Description] AS [OP_Desc]
		, [OP2].[Qty] AS [OP_Qty]
		, NULL AS [CW_Desc]
	FROM
		[BWSdb].[dbo].[Order Options] [OP2] WITH (NOLOCK)
	INNER JOIN
		[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
	ON
		[OP2].[Quote#] = [O].[Quote#]
	INNER JOIN
		[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
	ON
		[O].[ProductID] = [P].[IDTrailer]
	
	UNION ALL

	SELECT		
		'CW' AS [T]
		, [CW2].[Quote#]
		, [CW2].[Order Date]
		, [CW2].[WO#]
		, [P].[Model No] AS [Model No]
		, NULL AS [OS_Group]
		, NULL AS [OS_Section]
		, NULL AS [OS_Desc]
		, NULL AS [OS_NO]
		, NULL AS [OP_NO]
		, NULL AS [OP_Desc]
		, NULL AS [OP_Qty]
		, [CW2].[Description] AS [CW_Desc]
	FROM
		[BWSdb].[dbo].[Custom Work] [CW2] WITH (NOLOCK)
	INNER JOIN
		[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
	ON
		[CW2].[Quote#] = [O].[Quote#]
	INNER JOIN
		[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
	ON
		[O].[ProductID] = [P].[IDTrailer]
	WHERE
		LTRIM(RTRIM(LOWER(ISNULL([CW2].[Description], '')))) <> 'none'
) AS [C]
ON
	--([B].[Model No] = [C].[Model No])
	--AND ([B].[OS_Group] = [C].[OS_Group])
	--AND ([B].[OS_Section] = [C].[OS_Section])
	--AND ([B].[OS_Desc] = [C].[OS_Desc])
	--AND ([B].[OP_Desc] = [C].[OP_Desc])
	--AND ([B].[OP_Qty] = [C].[OP_Qty])
	--AND ([B].[CW_Desc] = [C].[CW_Desc])

	([C].[Model No] = [B].[Model No])
	AND	(
		(
			([C].[OS_Group] IS NOT NULL) 
			AND	([C].[OS_Section] IS NOT NULL) 
			AND	([C].[OS_Desc] IS NOT NULL) 
			AND	([C].[OS_Group] = [B].[OS_Group])
			AND ([C].[OS_Section] = [B].[OS_Section])
			AND ([C].[OS_Desc] = [B].[OS_Desc])
		)
		OR (
			([C].[OP_Desc] IS NOT NULL)
			AND ([C].[OP_Qty] IS NOT NULL)
			AND ([C].[OP_Desc] = [B].[OP_Desc])
			AND ([C].[OP_Qty] = [B].[OP_Qty])
		)
		OR (
			([C].[CW_Desc] IS NOT NULL)
			AND ([C].[CW_Desc] = [B].[CW_Desc])
		)
	)
;

-----------------------------------------------------------------
-----------------------------------------------------------------
-----------------------------------------------------------------

-- 4

SELECT
	*
FROM (
	SELECT
		[T]
		, [Model No]
		, [OS_Group]
		, [OS_Section]
		, [OS_Desc]
		, [OS_NO]
		, [OP_NO]
		, [OP_Desc]
		, [OP_Qty]
		, [CW_Desc]
		, COUNT(*) AS [Count]
	FROM (
		SELECT		
			'OS' AS [T]
			, [OS2].[Model No]
			, [Os2].[Group] AS [OS_Group]
			, [Os2].[Section] AS [OS_Section]
			, [Os2].[Description] AS [OS_Desc]
			, [OS2].[Standard No] AS [OS_NO]
			, NULL AS [OP_NO]
			, NULL AS [OP_Desc]
			, NULL AS [OP_Qty]
			, NULL AS [CW_Desc]
		FROM
			[BWSdb].[dbo].[Order Standards] [OS2] WITH (NOLOCK)
	
		UNION ALL

		SELECT		
			'OP' AS [T]
			, [P].[Model No] AS [Model No]
			, NULL AS [OS_Group]
			, NULL AS [OS_Section]
			, NULL AS [OS_Desc]
			, NULL AS [OS_NO]
			, [OP2].[Option No] AS [OP_NO]
			, [OP2].[Description] AS [OP_Desc]
			, [OP2].[Qty] AS [OP_Qty]
			, NULL AS [CW_Desc]
		FROM
			[BWSdb].[dbo].[Order Options] [OP2] WITH (NOLOCK)
		INNER JOIN
			[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
		ON
			[OP2].[Quote#] = [O].[Quote#]
		INNER JOIN
			[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
		ON
			[O].[ProductID] = [P].[IDTrailer]
	
		UNION ALL

		SELECT		
			'CW' AS [T]
			, [P].[Model No] AS [Model No]
			, NULL AS [OS_Group]
			, NULL AS [OS_Section]
			, NULL AS [OS_Desc]
			, NULL AS [OS_NO]
			, NULL AS [OP_NO]
			, NULL AS [OP_Desc]
			, NULL AS [OP_Qty]
			, [CW2].[Description] AS [CW_Desc]
		FROM
			[BWSdb].[dbo].[Custom Work] [CW2] WITH (NOLOCK)
		INNER JOIN
			[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
		ON
			[CW2].[Quote#] = [O].[Quote#]
		INNER JOIN
			[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
		ON
			[O].[ProductID] = [P].[IDTrailer]
		WHERE
			LTRIM(RTRIM(LOWER(ISNULL([CW2].[Description], '')))) <> 'none'
	) AS [A]
	GROUP BY
		[T]
		, [Model No]
		, [OS_Group]
		, [OS_Section]
		, [OS_Desc]
		, [OS_NO]
		, [OP_NO]
		, [OP_Desc]
		, [OP_Qty]
		, [CW_Desc]
) AS [B]
ORDER BY
	[T]
;