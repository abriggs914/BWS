
-- WSOM WIP 2

SELECT
	*
FROM (
	SELECT
		[OS_Model]
		, [OS_Grp]
		, [OS_Sec]
		, [OS_Desc]

		, [CW_Qty]
		, [CW_Desc]
		, [CWFL_Grp]
		, [CWFL_Sec]
		, [CWFL_Desc]
		, [CWSL_Grp]
		, [CWSL_Sec]
		, [CWSL_Desc]
	
		, [OO_Qty]
		, [OO_Desc]
		, [OOFL_Grp]
		, [OOFL_Sec]
		, [OOFL_Desc]
		, [OOSL_Grp]
		, [OOSL_Sec]
		, [OOSL_Desc]
	FROM (
		SELECT
			[OS].[Quote#] AS [OS_Quote]
			,[OS].[Model No] AS [OS_Model]
			,[CW_Src].*
			,[OO_Src].*
			,[OS].[Group] AS [OS_Grp]
			,[OS].[Section] AS [OS_Sec]
			,[OS].[Description] AS [OS_Desc]
		FROM 
			[BWSdb].[dbo].[Order Standards] [OS] WITH (NOLOCK)
		LEFT JOIN (
			SELECT
				[CW].[Quote#] AS [CW_Quote]
				, [CW].[Qty] AS [CW_Qty]
				, [CW].[Description] AS [CW_Desc]
				, [CWFL].[SpecGroup] AS [CWFL_Grp]
				, [CWFL].[SpecSection] AS [CWFL_Sec]
				, [CWFL].[Description] AS [CWFL_Desc]
				, [CWSL].[SpecGroup] AS [CWSL_Grp]
				, [CWSL].[SpecSection] AS [CWSL_Sec]
				, [CWSL].[Description] AS [CWSL_Desc]
			FROM 
				[BWSdb].[dbo].[Custom Work] [CW] WITH (NOLOCK)
			LEFT JOIN
				[BWSdb].[dbo].[Custom Work_FactoryLines] [CWFL] WITH (NOLOCK)
			ON
				([CW].[Quote#] = [CWFL].[Quote#])
				AND ([CW].[ID] = [CWFL].[NPOID])
			LEFT JOIN
				[BWSdb].[dbo].[Custom Work_SpecLines] [CWSL] WITH (NOLOCK)
			ON
				([CW].[Quote#] = [CWSL].[Quote#])
				AND ([CW].[ID] = [CWSL].[NPOID])
		) AS [CW_Src]
		ON
			([OS].[Quote#] = [CW_Src].[CW_Quote])
			AND ([OS].[Group] = [CW_Src].[CWFL_Grp])
			AND ([OS].[Section] = [CW_Src].[CWFL_Sec])
		LEFT JOIN (
			SELECT
				[OO].[Quote#] AS [OO_Quote]
				, [OO].[Qty] AS [OO_Qty]
				, [OO].[Description] AS [OO_Desc]
				, [OOFL].[SpecGroup] AS [OOFL_Grp]
				, [OOFL].[SpecSection] AS [OOFL_Sec]
				, [OOFL].[Description] AS [OOFL_Desc]
				, [OOSL].[SpecGroup] AS [OOSL_Grp]
				, [OOSL].[SpecSection] AS [OOSL_Sec]
				, [OOSL].[Description] AS [OOSL_Desc]
			FROM 
				[BWSdb].[dbo].[Order Options] [OO] WITH (NOLOCK)
			LEFT JOIN
				[BWSdb].[dbo].[Order Options_FactoryLines] [OOFL] WITH (NOLOCK)
			ON
				([OO].[Quote#] = [OOFL].[Quote#])
				AND ([OO].[ID] = [OOFL].[OrderOptionID])
			LEFT JOIN
				[BWSdb].[dbo].[Order Options_SpecLines] [OOSL] WITH (NOLOCK)
			ON
				([OO].[Quote#] = [OOSL].[Quote#])
				AND ([OO].[ID] = [OOSL].[OrderOptionID])
		) AS [OO_Src]
		ON
			([OS].[Quote#] = [OO_Src].[OO_Quote])
			AND ([OS].[Group] = [OO_Src].[OOFL_Grp])
			AND ([OS].[Section] = [OO_Src].[OOFL_Sec])
	) AS [Src]
	GROUP BY
		[OS_Model]
		, [OS_Grp]
		, [OS_Sec]
		, [OS_Desc]

		, [CW_Qty]
		, [CW_Desc]
		, [CWFL_Grp]
		, [CWFL_Sec]
		, [CWFL_Desc]
		, [CWSL_Grp]
		, [CWSL_Sec]
		, [CWSL_Desc]
	
		, [OO_Qty]
		, [OO_Desc]
		, [OOFL_Grp]
		, [OOFL_Sec]
		, [OOFL_Desc]
		, [OOSL_Grp]
		, [OOSL_Sec]
		, [OOSL_Desc]
	HAVING
		COUNT(*) > 1
) AS [DblSpecs]
CROSS JOIN (
	SELECT
			[OS].[Quote#] AS [OS_Quote]
			,[OS].[Model No] AS [OS_Model]
			,[CW_Src].*
			,[OO_Src].*
			,[OS].[Group] AS [OS_Grp]
			,[OS].[Section] AS [OS_Sec]
			,[OS].[Description] AS [OS_Desc]
		FROM 
			[BWSdb].[dbo].[Order Standards] [OS] WITH (NOLOCK)
		LEFT JOIN (
			SELECT
				[CW].[Quote#] AS [CW_Quote]
				, [CW].[Qty] AS [CW_Qty]
				, [CW].[Description] AS [CW_Desc]
				, [CWFL].[SpecGroup] AS [CWFL_Grp]
				, [CWFL].[SpecSection] AS [CWFL_Sec]
				, [CWFL].[Description] AS [CWFL_Desc]
				, [CWSL].[SpecGroup] AS [CWSL_Grp]
				, [CWSL].[SpecSection] AS [CWSL_Sec]
				, [CWSL].[Description] AS [CWSL_Desc]
			FROM 
				[BWSdb].[dbo].[Custom Work] [CW] WITH (NOLOCK)
			LEFT JOIN
				[BWSdb].[dbo].[Custom Work_FactoryLines] [CWFL] WITH (NOLOCK)
			ON
				([CW].[Quote#] = [CWFL].[Quote#])
				AND ([CW].[ID] = [CWFL].[NPOID])
			LEFT JOIN
				[BWSdb].[dbo].[Custom Work_SpecLines] [CWSL] WITH (NOLOCK)
			ON
				([CW].[Quote#] = [CWSL].[Quote#])
				AND ([CW].[ID] = [CWSL].[NPOID])
		) AS [CW_Src]
		ON
			([OS].[Quote#] = [CW_Src].[CW_Quote])
			AND ([OS].[Group] = [CW_Src].[CWFL_Grp])
			AND ([OS].[Section] = [CW_Src].[CWFL_Sec])
		LEFT JOIN (
			SELECT
				[OO].[Quote#] AS [OO_Quote]
				, [OO].[Qty] AS [OO_Qty]
				, [OO].[Description] AS [OO_Desc]
				, [OOFL].[SpecGroup] AS [OOFL_Grp]
				, [OOFL].[SpecSection] AS [OOFL_Sec]
				, [OOFL].[Description] AS [OOFL_Desc]
				, [OOSL].[SpecGroup] AS [OOSL_Grp]
				, [OOSL].[SpecSection] AS [OOSL_Sec]
				, [OOSL].[Description] AS [OOSL_Desc]
			FROM 
				[BWSdb].[dbo].[Order Options] [OO] WITH (NOLOCK)
			LEFT JOIN
				[BWSdb].[dbo].[Order Options_FactoryLines] [OOFL] WITH (NOLOCK)
			ON
				([OO].[Quote#] = [OOFL].[Quote#])
				AND ([OO].[ID] = [OOFL].[OrderOptionID])
			LEFT JOIN
				[BWSdb].[dbo].[Order Options_SpecLines] [OOSL] WITH (NOLOCK)
			ON
				([OO].[Quote#] = [OOSL].[Quote#])
				AND ([OO].[ID] = [OOSL].[OrderOptionID])
		) AS [OO_Src]
		ON
			([OS].[Quote#] = [OO_Src].[OO_Quote])
			AND ([OS].[Group] = [OO_Src].[OOFL_Grp])
			AND ([OS].[Section] = [OO_Src].[OOFL_Sec])
) AS [OrderSpecs]
WHERE
	([DblSpecs].[OS_Grp] = [OrderSpecs].[OS_Grp])
	AND ([DblSpecs].[OS_Sec] = [OrderSpecs].[OS_Sec])
	AND ([DblSpecs].[OS_Desc] = [OrderSpecs].[OS_Desc])
	
	AND ([DblSpecs].[CW_Qty] = [OrderSpecs].[CW_Qty])
	AND ([DblSpecs].[CW_Desc] = [OrderSpecs].[CW_Desc])
	AND ([DblSpecs].[CWFL_Grp] = [OrderSpecs].[CWFL_Grp])
	AND ([DblSpecs].[CWFL_Sec] = [OrderSpecs].[CWFL_Sec])
	AND ([DblSpecs].[CWFL_Desc] = [OrderSpecs].[CWFL_Desc])
	AND ([DblSpecs].[CWSL_Grp] = [OrderSpecs].[CWSL_Grp])
	AND ([DblSpecs].[CWSL_Sec] = [OrderSpecs].[CWSL_Sec])
	AND ([DblSpecs].[CWSL_Desc] = [OrderSpecs].[CWSL_Desc])
	
	AND ([DblSpecs].[OO_Qty] = [OrderSpecs].[OO_Qty])
	AND ([DblSpecs].[OO_Desc] = [OrderSpecs].[OO_Desc])
	AND ([DblSpecs].[OOFL_Grp] = [OrderSpecs].[OOFL_Grp])
	AND ([DblSpecs].[OOFL_Sec] = [OrderSpecs].[OOFL_Sec])
	AND ([DblSpecs].[OOFL_Desc] = [OrderSpecs].[OOFL_Desc])
	AND ([DblSpecs].[OOSL_Grp] = [OrderSpecs].[OOSL_Grp])
	AND ([DblSpecs].[OOSL_Sec] = [OrderSpecs].[OOSL_Sec])
	AND ([DblSpecs].[OOSL_Desc] = [OrderSpecs].[OOSL_Desc])
;