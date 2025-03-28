--exec [sp_NewQuoteReport V2] 30184, 1

SELECT
	[Quote]
	,[WO]
	,[SN]
	,[Class]
	,[ModelNo]
	,[CompanyName]
	-- Standards
	,[OS_ISOS]
	,[OS_StandardNo]
	,[OS_Group]
	,[OS_Section]
	,[OS_Description]
	,[OS_SortG]
	,[OS_SortSe]
	-- Options
	,[OO_OptionNo]
	,[OO_Description]
	,[OOFL].[Description] AS [OO_Description]
	,[OOFL].[SpecDescription] AS [OO_SpecDescription]
	,[OOFL].[SpecSortG]  -- Group (Parent)   v
	,[OOFL].[SpecSortSe]  -- Section (Child) ^
	,[OOFL].[Line#]           -- (Parent) v  (Ordering)
	,[OOFL].[SpecSortSeLine]  -- (Child)  ^  (Indication#)
	-- NPOS
	,[CW_NPOID]
	,[CW_Description]
	,[CWFL].[Description] AS [CW_Description]
	,[CWFL].[SpecDescription] AS [CW_SpecDescription]
	,[CWFL].[SpecSortG]  -- Group (Parent)   v
	,[CWFL].[SpecSortSe]  -- Section (Child) ^
	,[CWFL].[Line#]           -- (Parent) v
	,[CWFL].[SpecSortSeLine]  -- (Child)  ^
	-- Pricing
	,[USSale]
	,[OrderPrice]
	,[OO_Qty]
	,[OO_Price]
	,[CW_Qty]
	,[CW_Price]
	
	--,MAX([EstTotal_Sub]) AS [EstTotal]
FROM (
	SELECT
		[O].[Quote#] AS [Quote]
		,[O].[WO#] AS [WO]
		,[O].[Serial Number] AS [SN]
		,[P].[Class] AS [Class]
		,[P].[Model No] AS [ModelNo]
		,[D].[COMPANY NAME] AS [CompanyName]
		-- Standards
		,[OS].[IDOS] AS [OS_ISOS]
		,[OS].[Standard No] AS [OS_StandardNo]
		,[OS].[Group] AS [OS_Group]
		,[OS].[Section] AS [OS_Section]
		,[OS].[Description] AS [OS_Description]
		,[OS].[SortG] AS [OS_SortG]
		,[OS].[SortSe] AS [OS_SortSe]
		-- Options
		,[OO].[Option No] AS [OO_OptionNo]
		,[OO].[Description] AS [OO_Description]
		-- NPOS
		,[CW].[ID] AS [CW_NPOID]
		,[CW].[Description] AS [CW_Description]
		-- Pricing
		,[O].[US Sale] AS [USSale]
		,[O].[Price] AS [OrderPrice]
		,[OO].[Qty] AS [OO_Qty]
		,[OO].[Price] AS [OO_Price]
		,[CW].[Qty] AS [CW_Qty]
		,[CW].[Price] AS [CW_Price]
		--,(SELECT MAX((ISNULL([O].[Price], 0) + (ISNULL([OO].[Qty], 0) * ISNULL([OO].[Price], 0)) + (ISNULL([CW].[Qty], 0) * ISNULL([CW].[Price], 0)))) GROUP BY [O].[Price], [OO].[Qty], [OO].[Price], [CW].[Qty], [CW].[Price]) AS [EstTotal]
		,(ISNULL([O].[Price], 0) + (ISNULL([OO].[Qty], 0) * ISNULL([OO].[Price], 0)) + (ISNULL([CW].[Qty], 0) * ISNULL([CW].[Price], 0))) AS [EstTotal_Sub]
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

	/*
	WHERE
		[O].[WO#] = 10016983
	*/
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