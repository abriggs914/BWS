SELECT
	[O].[Quote#] AS [Quote]
	,[O].[WO#] AS [WO]
	,[O].[Serial Number] AS [SN]
	,[P].[Class] AS [Class]
	,[P].[Model No] AS [ModelNo]
	,[D].[COMPANY NAME] AS [CompanyName]
	-- Options
	,[OO].[Option No] AS [OO_OptionNo]
	,[OO].[Description] AS [OO_Description]
	,[OOFL].[Description] AS [OOFL_Description]
	,[OOFL].[SpecDescription] AS [OOFL_SpecDescription]
	,[OOSL].[Description] AS [OOSL_Description]
	,[OOSL].[SpecDescription] AS [OOSL_SpecDescription]
	-- NPOS
	/*,[CW].[ID] AS [CW_NPOID]
	,[CW].[Description] AS [CW_Description]
	,[CWFL].[Description] AS [CWFL_Description]
	,[CWFL].[SpecDescription] AS [CWFL_SpecDescription]
	,[CWSL].[Description] AS [CWSL_Description]
	,[CWSL].[SpecDescription] AS [CWSL_SpecDescription]*/
	-- Pricing
	,[O].[US Sale] AS [USSale]
	,[O].[Price] AS [OrderPrice]
	,[OO].[Qty] AS [OO_Qty]
	,[OO].[Price] AS [OO_Price]
	/*,[CW].[Qty] AS [CW_Qty]
	,[CW].[Price] AS [CW_Price]*/
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

	-- OPTIONS
INNER JOIN
	[BWSdb].[dbo].[Order Options] [OO] WITH (NOLOCK)
ON
	[O].[Quote#] = [OO].[Quote#]
INNER JOIN
	[BWSdb].[dbo].[Order Options_FactoryLines] [OOFL] WITH (NOLOCK)
ON
	([OO].[Option No] = [OOFL].[Option No])
	AND ([OO].[Quote#] = [OOFL].[Quote#])
INNER JOIN
	[BWSdb].[dbo].[Order Options_SpecLines] [OOSL] WITH (NOLOCK)
ON
	([OO].[Option No] = [OOSL].[Option No])
	AND ([OO].[Quote#] = [OOSL].[Quote#])
/*
	-- NPOS
INNER JOIN
	[BWSdb].[dbo].[Custom Work] [CW] WITH (NOLOCK)
ON
	[O].[Quote#] = [CW].[Quote#]
INNER JOIN
	[BWSdb].[dbo].[Custom Work_FactoryLines] [CWFL] WITH (NOLOCK)
ON
	([CW].[ID] = [CWFL].[NPOID])
	AND ([CW].[Quote#] = [CWFL].[Quote#])
INNER JOIN
	[BWSdb].[dbo].[Custom Work_SpecLines] [CWSL] WITH (NOLOCK)
ON
	([CW].[ID] = [CWSL].[NPOID])
	AND ([CW].[Quote#] = [CWSL].[Quote#])
*/
WHERE
	[O].[WO#] = 10016983