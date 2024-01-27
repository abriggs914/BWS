USE BWSdb_Restore_202401252100
GO

SELECT
	[ID]
	,[Description]
FROM
	[Custom WorkV2]
	
USE BWSdb
GO

SELECT
	[ID]
	,[Description]
FROM
	[Custom WorkV2]

SELECT
	[CW2].[ID],
	[RCW2].[ID],
	[CW2].[Description],
	[RCW2].[Description]
FROM
	[Custom WorkV2] AS [CW2]
FULL OUTER JOIN
	[BWSdb_Restore_202401252100].[dbo].[Custom WorkV2] AS [RCW2]
ON
	[CW2].[ID] = [RCW2].[ID]
	
SELECT
	[CW2].[ID],
	--[RCW2].[ID],
	[CW2].[Description],
	[CW2].[SGQuote]
	--[RCW2].[Description]
FROM
	[Custom WorkV2] AS [CW2]
FULL OUTER JOIN
	[BWSdb_Restore_202401252100].[dbo].[Custom WorkV2] AS [RCW2]
ON
	[CW2].[ID] = [RCW2].[ID]
WHERE
	[CW2].[Description] LIKE '%DELETE this%'

SELECT
	[SL].[Description]
	,[FL].[Description]
FROM
	[Custom WorkV2_FactoryLines] AS [FL]
FULL OUTER JOIN
	[Custom WorkV2] AS [CW]
ON
	[CW].[SGQuote] = [FL].[SGQuote]
FULL OUTER JOIN
	[Custom WorkV2_SpecLines] AS [SL]
ON
	[CW].[SGQuote] = [SL].[SGQuote]
WHERE
	[CW].[SGQuote] IN (
		'SG101369',
		'SG101273',
		'SG101271',
		'SG101541',
		'SG101542'
	)
	AND (
		[CW].[Description] LIKE '%DELETE this%'
	)

SELECT
	[CW].[Description]
	,[SL].[Description]
	,[SL].[Line#]
	,[SL].[SpecDescription]
	--,[FL].[Description]
	,[CW].[SGQuote]
	,[CW].[ID]
	,[SL].[NPOID]
FROM
	[Custom WorkV2] AS [CW]
INNER JOIN
	[Custom WorkV2_SpecLines] AS [SL]
ON
	--[CW].[SGQuote] = [SL].[SGQuote]
	[CW].[ID] = [SL].[NPOID]
--LEFT JOIN
--	[Custom WorkV2_FactoryLines] AS [FL]
--ON
--	[CW].[SGQuote] = [FL].[SGQuote]
WHERE
	[CW].[SGQuote] IN (
		'SG101369',
		'SG101273',
		'SG101271',
		'SG101541',
		'SG101542'
	)
	AND (
		[CW].[Description] LIKE '%DELETE this%'
	)
ORDER BY
	[CW].[ID]


SELECT
	[CW].[Description]
	,[SL].[Description]
	,[FL].[Description]
	,[SL].[SpecDescription]
	,[FL].[SpecDescription]
	,[SL].[Line#]
	,[CW].[SGQuote]
	,[CW].[ID]
	,[SL].[NPOID]
FROM
	[Custom WorkV2] AS [CW]
INNER JOIN
	[Custom WorkV2_SpecLines] AS [SL]
ON
	--[CW].[SGQuote] = [SL].[SGQuote]
	[CW].[ID] = [SL].[NPOID]
LEFT JOIN
	[Custom WorkV2_FactoryLines] AS [FL]
ON
	[CW].[ID] = [FL].[NPOID]
WHERE
	[CW].[SGQuote] IN (
		'SG101369',
		'SG101273',
		'SG101271',
		'SG101541',
		'SG101542'
	)
	AND (
		[CW].[Description] LIKE '%DELETE this%'
	)
ORDER BY
	[CW].[ID]