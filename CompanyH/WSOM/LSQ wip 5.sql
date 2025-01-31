
-- WSOM WIP 5

DECLARE @sd DATETIME = DATEADD(MONTH, -1, GETDATE());
SELECT 
	[A].[Quote#] AS [Parent]
	,[B].[Quote#] AS [Child]
	,COUNT(*) AS [Freq]
FROM (
	SELECT		
		[StandardOptionCustom].*
	FROM
		[BWSdb].[dbo].[Orders] [O1] WITH (NOLOCK)
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
	)
	AS [StandardOptionCustom]
	ON
		[O1].[Quote#] = [StandardOptionCustom].[Quote#]
	WHERE
		@sd < [O1].[Order Date]
) AS [A]

INNER JOIN (
	SELECT		
		[StandardOptionCustom].*
	FROM
		[BWSdb].[dbo].[Orders] [O1] WITH (NOLOCK)
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
	)
	AS [StandardOptionCustom]
	ON
		[O1].[Quote#] = [StandardOptionCustom].[Quote#]
	WHERE
		@sd < [O1].[Order Date]
) AS [B]
ON
	([A].[Model No] = [B].[Model No])
	AND ([A].[Quote#] <> [B].[Quote#])
	AND	(
		(
			([A].[OS_Group] IS NOT NULL) 
			AND	([A].[OS_Section] IS NOT NULL) 
			AND	([A].[OS_Desc] IS NOT NULL) 
			AND	([A].[OS_Group] = [B].[OS_Group])
			AND ([A].[OS_Section] = [B].[OS_Section])
			AND ([A].[OS_Desc] = [B].[OS_Desc])
		)
		OR (
			([A].[OP_Desc] IS NOT NULL)
			AND ([A].[OP_Qty] IS NOT NULL)
			AND ([A].[OP_Desc] = [B].[OP_Desc])
			AND ([A].[OP_Qty] = [B].[OP_Qty])
		)
		OR (
			([A].[CW_Desc] IS NOT NULL)
			AND ([A].[CW_Desc] = [B].[CW_Desc])
		)
	)

GROUP BY
	[A].[Quote#]
	, [B].[Quote#]
ORDER BY
	[A].[Quote#]


------------------------------------------------
------------------------------------------------
------------------------------------------------
------------------------------------------------


SELECT		
	[O1].[Quote#]
	, [O1].[Order Date]
	, [O1].[WO#]
	, [O1].[Model No]
	, [Os2].[Group]
	, [Os2].[Section]
	, [Os2].[Description] AS [OStanDesc]
	, [Op2].[Option No]
	, [Op2].[Description] AS [OOptnDesc]
	, [Cw2].[Description] AS [CWorkDesc]
	, COUNT(*) AS [Num]
FROM
	[BWSdb].[dbo].[Orders] [O1] WITH (NOLOCK)
INNER JOIN
	[BWSdb].[dbo].[Order Standards] [Os2] WITH (NOLOCK)
ON
	[O1].[Quote#] = [Os2].[Quote#]
LEFT JOIN
	[BWSdb].[dbo].[Order Options] [Op2] WITH (NOLOCK)
ON
	[O1].[Quote#] = [Op2].[Quote#]
LEFT JOIN
	[BWSdb].[dbo].[Custom Work] [Cw2] WITH (NOLOCK)
ON
	[O1].[Quote#] = [Cw2].[Quote#]
/*
WHERE
	-- Non-cancelled unit
	([O1].[Date Declined] IS NULL)
	AND (
		-- Matching [Orders].[ProductID], [Orders].[Width], and [Orders].[Spread]
		([O1].[ProductID] = [O2].[ProductID])
		AND ([O1].[Width] = [O2].[Width])
		AND ([O1].[Spread] = [O2].[Spread])
	)
	AND (
		-- Matching [Order Standards].[Group], [Order Standards].[Section], and [Order Standards].[Description]
		([Os1].[Group] = [Os2].[Group])
		AND ([Os1].[Section] = [Os2].[Section])
		AND ([Os1].[Description] = [Os2].[Description])
	)
	AND (
		-- Matching [Order Options].[Sections] and [Order Options].[Description]
		([Op1].[Sections] = [Op2].[Sections])
		AND ([Op1].[Description] = [Op2].[Description])
		AND ([Op1].[Qty] = [Op2].[Qty])
	)
	AND (
		-- Matching [Custom Work].[Description]
		--[Cw1].[Section] = [Cw2].[Section]
		--AND 
		[Cw1].[Description] = [Cw2].[Description]
	)
*/
GROUP BY
	[O1].[Quote#]
	, [O1].[Order Date]
	, [O1].[WO#]
	, [O1].[Model No]
	, [Os2].[Group]
	, [Os2].[Section]
	, [Os2].[Description]
	, [Op2].[Option No]
	, [Op2].[Description]
	, [Cw2].[Description]
ORDER BY
	[Quote#] DESC



------------------------------------------------------------------
------------------------------------------------------------------
------------------------------------------------------------------


SELECT
	[Quote#]
FROM (
	
	SELECT		
		[O1].[Quote#]
		, [O1].[Order Date]
		, [O1].[WO#]
		, [O1].[Model No]
		, [Os2].[Group]
		, [Os2].[Section]
		, [Os2].[Description] AS [OStanDesc]
		, [Op2].[Option No]
		, [Op2].[Description] AS [OOptnDesc]
		, [Cw2].[Description] AS [CWorkDesc]
	FROM
		[BWSdb].[dbo].[Orders] [O1] WITH (NOLOCK)
	CROSS JOIN (
		SELECT
			*
		FROM
			[BWSdb].[dbo].[Orders] WITH (NOLOCK)
		WHERE
			[Quote#] = @quote
	) AS [O2]
	
	-- Add [Order Standards]
	CROSS JOIN (
		SELECT
			*
		FROM
			[BWSdb].[dbo].[Order Standards] WITH (NOLOCK)
		WHERE
			[Quote#] = @quote
	) AS [Os1]
			
	-- Add [Order Options]
	CROSS JOIN (
		SELECT
			*
		FROM
			[BWSdb].[dbo].[Order Options] WITH (NOLOCK)
		WHERE
			[Quote#] = @quote
	) AS [Op1]

	-- Add [Custom Work]
	CROSS JOIN (
		SELECT
			*
		FROM
			[BWSdb].[dbo].[Custom Work] WITH (NOLOCK)
		WHERE
			[Quote#] = @quote
	) AS [Cw1]
	LEFT JOIN
		[BWSdb].[dbo].[Order Standards] [Os2] WITH (NOLOCK)
	ON
		[O1].[Quote#] = [Os2].[Quote#]
	LEFT JOIN
		[BWSdb].[dbo].[Order Options] [Op2] WITH (NOLOCK)
	ON
		[O1].[Quote#] = [Op2].[Quote#]
	LEFT JOIN
		[BWSdb].[dbo].[Custom Work] [Cw2] WITH (NOLOCK)
	ON
		[O1].[Quote#] = [Cw2].[Quote#]
	WHERE
		-- Non-cancelled unit
		([O1].[Date Declined] IS NULL)
		AND (
			-- Matching [Orders].[ProductID], [Orders].[Width], and [Orders].[Spread]
			([O1].[ProductID] = [O2].[ProductID])
			AND ([O1].[Width] = [O2].[Width])
			AND ([O1].[Spread] = [O2].[Spread])
		)
		AND (
			-- Matching [Order Standards].[Group], [Order Standards].[Section], and [Order Standards].[Description]
			([Os1].[Group] = [Os2].[Group])
			AND ([Os1].[Section] = [Os2].[Section])
			AND ([Os1].[Description] = [Os2].[Description])
		)
		AND (
			-- Matching [Order Options].[Sections] and [Order Options].[Description]
			([Op1].[Sections] = [Op2].[Sections])
			AND ([Op1].[Description] = [Op2].[Description])
			AND ([Op1].[Qty] = [Op2].[Qty])
		)
		AND (
			-- Matching [Custom Work].[Description]
			--[Cw1].[Section] = [Cw2].[Section]
			--AND 
			[Cw1].[Description] = [Cw2].[Description]
		)
	GROUP BY
		[O1].[Quote#]
		, [O1].[Order Date]
		, [O1].[WO#]
		, [O1].[Model No]
		, [Os2].[Group]
		, [Os2].[Section]
		, [Os2].[Description]
		, [Op2].[Option No]
		, [Op2].[Description]
		, [Cw2].[Description]
	
) [Src]
INNER JOIN
	@results [Res]
ON
	CAST([Src].[Quote#] AS NVARCHAR(12)) = [Res].[Quote]
WHERE
	([Quote#] <> @quote)
GROUP BY
	[Quote#]
ORDER BY
	[Quote#] DESC