--exec [sp_NewQuoteReport V2] 30184, 1

SELECT
	[Class]
	,[ModelNo]
	,[CompanyName]
	-- Standards
	,[OS_Group]
	,[OS_Section]
	,[OS_SortG]
	,[OS_SortSe]
	-- Options
	,[OOFL].[SpecSortG]  -- Group (Parent)   v
	,[OOFL].[SpecSortSe]  -- Section (Child) ^
	,[OOFL].[Line#]           -- (Parent) v  (Ordering)
	,[OOFL].[SpecSortSeLine]  -- (Child)  ^  (Indication#)
	-- NPOS
	,[CWFL].[SpecSortG]  -- Group (Parent)   v
	,[CWFL].[SpecSortSe]  -- Section (Child) ^
	,COUNT(*) AS [CFreq]
FROM (
	SELECT
		[O].[Quote#] AS [Quote]
		,[P].[Class] AS [Class]
		,[P].[Model No] AS [ModelNo]
		,[D].[COMPANY NAME] AS [CompanyName]
		-- Standards
		,[OS].[Group] AS [OS_Group]
		,[OS].[Section] AS [OS_Section]
		,[OS].[SortG] AS [OS_SortG]
		,[OS].[SortSe] AS [OS_SortSe]
		-- Options
		,[OO].[Option No] AS [OO_OptionNo]
		,[OO].[Description] AS [OO_Description]
		-- NPOS
		,[CW].[ID] AS [CW_NPOID]
		,[CW].[Description] AS [CW_Description]
	FROM
		[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
	INNER JOIN
		[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
	ON
		[O].[ProductID] = [P].[IDTrailer]
	INNER JOIN
		[BWSdb].[dbo].[Dealers] [D] WITH (NOLOCK)
	ON
		[O].[DealerID] = [D].[ID]
	INNER JOIN
		[BWSdb].[dbo].[Order Standards] [OS] WITH (NOLOCK)
	ON
		[O].[Quote#] = [OS].[Quote#]

		-- OPTIONS
	INNER JOIN
		[BWSdb].[dbo].[Order Options] [OO] WITH (NOLOCK)
	ON
		[O].[Quote#] = [OO].[Quote#]

		-- NPOS
	INNER JOIN
		[BWSdb].[dbo].[Custom Work] [CW] WITH (NOLOCK)
	ON
		[O].[Quote#] = [CW].[Quote#]

	WHERE
		--([O].[WO#] = 10016983)
		--AND
		(LOWER(ISNULL([CW].[Description], 'none')) <> 'none')
		AND (UPPER(ISNULL([OO].[Description], 'NO OPTIONS FOR THIS WORK ORDER')) <> 'NO OPTIONS FOR THIS WORK ORDER')
	
) AS [Src]
LEFT JOIN
	[BWSdb].[dbo].[Custom Work_FactoryLines] [CWFL] WITH (NOLOCK)
ON
	([Src].[CW_NPOID] = [CWFL].[NPOID])
	AND ([Src].[Quote] = [CWFL].[Quote#])
LEFT JOIN
	[BWSdb].[dbo].[Custom Work_SpecLines] [CWSL] WITH (NOLOCK)
ON
	([Src].[CW_NPOID] = [CWSL].[NPOID])
	AND ([Src].[Quote] = [CWSL].[Quote#])
LEFT JOIN
	[BWSdb].[dbo].[Order Options_FactoryLines] [OOFL] WITH (NOLOCK)
ON
	([Src].[OO_OptionNo] = [OOFL].[Option No])
	AND ([Src].[Quote] = [OOFL].[Quote#])
LEFT JOIN
	[BWSdb].[dbo].[Order Options_SpecLines] [OOSL] WITH (NOLOCK)
ON
	([Src].[OO_OptionNo] = [OOSL].[Option No])
	AND ([Src].[Quote] = [OOSL].[Quote#])
GROUP BY
	[Class]
	,[ModelNo]
	,[CompanyName]
	-- Standards
	,[OS_Group]
	,[OS_Section]
	,[OS_SortG]
	,[OS_SortSe]
	-- Options
	,[OOFL].[SpecSortG]
	,[OOFL].[SpecSortSe]
	,[OOFL].[Line#]
	,[OOFL].[SpecSortSeLine]
	,[CWFL].[SpecSortG]
	,[CWFL].[SpecSortSe]

/*GROUP BY
	[Quote]
	,[WO]
	,[SN]
	,[Class]
	,[ModelNo]
	,[CompanyName]
	-- Options
	,[OO_OptionNo]
	,[OO_Description]
	-- NPOS
	,[CW_NPOID]
	,[CW_Description]
	-- Pricing
	,[USSale]
	,[OrderPrice]
	,[OO_Qty]
	,[OO_Price]
	,[CW_Qty]
	,[CW_Price]*/