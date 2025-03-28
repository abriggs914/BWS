--exec [sp_NewQuoteReport V2] 30184, 1


SELECT
	*
FROM (
	SELECT
		[P].[Class]
		,[P].[Model No] AS [ModelNo]
		-- Standards
		,[OS].[Group] AS [OS_Froup]
		,[OS].[Section] AS [OS_Section]
		,[OS].[SortG] AS [OS_SortG]
		,[OS].[SortSe] AS [OS_SortSe]

		-- Options
		,[OOFL].[SpecGroup] AS [OOFL_SpecGroup]
		,[OOFL].[SpecSection] AS [OOFL_SpecSection]
		,[OOFL].[SpecSortG] AS [OOFL_SpecSortG]  -- Group (Parent)   v
		,[OOFL].[SpecSortSe] AS [OOFL_SpecSortSe]  -- Section (Child) ^
		,[OOFL].[Line#] AS [OOFL_Line#]           -- (Parent) v  (Ordering)
		,[OOFL].[SpecSortSeLine] AS [OOFL_SpecSortSeLine]  -- (Child)  ^  (Indication#)
	
		,[OOSL].[SpecGroup] AS [OOSL_SpecGroup]
		,[OOSL].[SpecSection] AS [OOSL_SpecSection]
		,[OOSL].[SpecSortG] AS [OOSL_SpecSortG]  -- Group (Parent)   v
		,[OOSL].[SpecSortSe] AS [OOSL_SpecSectionSe]  -- Section (Child) ^
		,[OOSL].[Line#] AS [OOSL_Line#]           -- (Parent) v  (Ordering)
		,[OOSL].[SpecSortSeLine] AS [OOSL_SpecSortSeLine]  -- (Child)  ^  (Indication#)
		-- NPOS
		,[CWFL].[SpecGroup] AS [CWFL_SpecGroup]
		,[CWFL].[SpecSection] AS [CWFL_SpecSection]
		,[CWFL].[SpecSortG] AS [CWFL_SpecSortG]  -- Group (Parent)   v
		,[CWFL].[SpecSortSe] AS [CWFL_SpecSortSe]  -- Section (Child) ^
	
		,[CWSL].[SpecGroup] AS [CWSL_SpecGroup]
		,[CWSL].[SpecSection] AS [CWSL_SpecSection]
		,[CWSL].[SpecSortG] AS [CWSL_SpecSortG]  -- Group (Parent)   v
		,[CWSL].[SpecSortSe] AS [CWSL_SpecSortSe]  -- Section (Child) ^
		,COUNT(*) AS [CFreq]
	FROM
		[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
	INNER JOIN
		[BWSdb].[dbo].[Products] [P] WITH (NOLOCK)
	ON
		[O].[ProductID] = [P].[IDTrailer]
	INNER JOIN
		[BWSdb].[dbo].[Order Standards] [OS] WITH (NOLOCK)
	ON
		[O].[Quote#] = [OS].[Quote#]
	INNER JOIN
		[BWSdb].[dbo].[Order Options] [OO] WITH (NOLOCK)
	ON
		[O].[Quote#] = [OO].[Quote#]
	INNER JOIN
		[BWSdb].[dbo].[Custom Work] [CW] WITH (NOLOCK)
	ON
		[O].[Quote#] = [CW].[Quote#]
	LEFT JOIN
		[BWSdb].[dbo].[Custom Work_FactoryLines] [CWFL] WITH (NOLOCK)
	ON
		([CW].[ID] = [CWFL].[NPOID])
		AND ([O].[Quote#] = [CWFL].[Quote#])
	LEFT JOIN
		[BWSdb].[dbo].[Custom Work_SpecLines] [CWSL] WITH (NOLOCK)
	ON
		([CW].[ID] = [CWSL].[NPOID])
		AND ([O].[Quote#] = [CWSL].[Quote#])
	LEFT JOIN
		[BWSdb].[dbo].[Order Options_FactoryLines] [OOFL] WITH (NOLOCK)
	ON
		([OO].[Option No] = [OOFL].[Option No])
		AND ([O].[Quote#] = [OOFL].[Quote#])
	LEFT JOIN
		[BWSdb].[dbo].[Order Options_SpecLines] [OOSL] WITH (NOLOCK)
	ON
		([OO].[Option No] = [OOSL].[Option No])
		AND ([O].[Quote#] = [OOSL].[Quote#])
	WHERE
		([O].[WO#] = 10016983)
		/*AND
		(LOWER(ISNULL([CW].[Description], 'none')) <> 'none')
		AND (UPPER(ISNULL([OO].[Description], 'NO OPTIONS FOR THIS WORK ORDER')) <> 'NO OPTIONS FOR THIS WORK ORDER')*/
	GROUP BY
		[P].[Class]
		,[P].[Model No]
		-- Standards
		,[OS].[Group]
		,[OS].[Section]
		,[OS].[SortG]
		,[OS].[SortSe]
		-- Options
		,[OOFL].[SpecGroup]
		,[OOFL].[SpecSection]
		,[OOFL].[SpecSortG]  -- Group (Parent)   v
		,[OOFL].[SpecSortSe]  -- Section (Child) ^
		,[OOFL].[Line#]           -- (Parent) v  (Ordering)
		,[OOFL].[SpecSortSeLine]  -- (Child)  ^  (Indication#)
	
		,[OOSL].[SpecGroup]
		,[OOSL].[SpecSection]
		,[OOSL].[SpecSortG]  -- Group (Parent)   v
		,[OOSL].[SpecSortSe]  -- Section (Child) ^
		,[OOSL].[Line#]           -- (Parent) v  (Ordering)
		,[OOSL].[SpecSortSeLine]  -- (Child)  ^  (Indication#)
		-- NPOS
		,[CWFL].[SpecGroup]
		,[CWFL].[SpecSection]
		,[CWFL].[SpecSortG]  -- Group (Parent)   v
		,[CWFL].[SpecSortSe]  -- Section (Child) ^
	
		,[CWSL].[SpecGroup]
		,[CWSL].[SpecSection]
		,[CWSL].[SpecSortG]  -- Group (Parent)   v
		,[CWSL].[SpecSortSe]
) AS [Src]
ORDER BY
	[OS_SortG]
	--,ISNULL([OOSL_SpecSortG], ISNULL([OOFL_SpecSortG], [OS_SortG]))
	,[OS_SortSe]
;

/*
SELECT
	[Class]
	,[ModelNo]
	-- Standards
	,[OS_Group]
	,[OS_Section]
	,[OS_SortG]
	,[OS_SortSe]
	-- Options
	,[OOFL].[SpecGroup]
	,[OOFL].[SpecSection]
	,[OOFL].[SpecSortG]  -- Group (Parent)   v
	,[OOFL].[SpecSortSe]  -- Section (Child) ^
	,[OOFL].[Line#]           -- (Parent) v  (Ordering)
	,[OOFL].[SpecSortSeLine]  -- (Child)  ^  (Indication#)
	
	,[OOSL].[SpecGroup]
	,[OOSL].[SpecSection]
	,[OOSL].[SpecSortG]  -- Group (Parent)   v
	,[OOSL].[SpecSortSe]  -- Section (Child) ^
	,[OOSL].[Line#]           -- (Parent) v  (Ordering)
	,[OOSL].[SpecSortSeLine]  -- (Child)  ^  (Indication#)
	-- NPOS
	,[CWFL].[SpecGroup]
	,[CWFL].[SpecSection]
	,[CWFL].[SpecSortG]  -- Group (Parent)   v
	,[CWFL].[SpecSortSe]  -- Section (Child) ^
	
	,[CWSL].[SpecGroup]
	,[CWSL].[SpecSection]
	,[CWSL].[SpecSortG]  -- Group (Parent)   v
	,[CWSL].[SpecSortSe]  -- Section (Child) ^
	,COUNT(*) AS [CFreq]
FROM (
	SELECT
		[O].[Quote#] AS [Quote]
		,[P].[Class] AS [Class]
		,[P].[Model No] AS [ModelNo]
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
	,[CWFL].[SpecSortSe]*/