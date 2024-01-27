
-- Use speclinesV2 description to infer the NPO description.
-- Ran 3rd

USE BWSdb
GO

BEGIN TRAN;



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

	
UPDATE
	[Custom WorkV2]
SET
	[Description] = [SL].[SpecDescription]
FROM
	[Custom WorkV2] [CW]
INNER JOIN
	[Custom WorkV2_SpecLines] AS [SL]
ON
	[CW].[ID] = [SL].[NPOID]
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

ROLLBACK;
COMMIT;