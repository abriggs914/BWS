SELECT
	'BWS' AS [Cmpany],
	[B_OS].[IDOS],
	CAST([B_OS].[Quote#] AS NVARCHAR(255)) AS [Quote],
    [B_OS].[WO#],
    [B_OS].[Model No],
    [B_OS].[Standard No],
    [B_OS].[Group],
    [B_OS].[Section],
    [B_OS].[Description],
    [B_OS].[Start Date],
    [B_OS].[End Date],
    [B_OS].[SortG],
    [B_OS].[SortSe],
    [B_OS].[SortGv2],
    [B_OS].[SortSev2],
    [B_OS].[os_timestamp],
    [B_OS].[Group_French],
    [B_OS].[Section_French],
    [B_OS].[Description_French]
FROM 
	[BWSdb].[dbo].[Order Standards] [B_OS] WITH (NOLOCK)

UNION ALL (
	SELECT
		'STG' AS [Cmpany],
		[S_OS].[IDOS],
		[S_OS].[SGQuote],
		[S_OS].[WO#],
		[S_OS].[Model No],
		[S_OS].[Standard No],
		[S_OS].[Group],
		[S_OS].[Section],
		[S_OS].[Description],
		[S_OS].[Start Date],
		[S_OS].[End Date],
		[S_OS].[SortG],
		[S_OS].[SortSe],
		[S_OS].[SortGv2],
		[S_OS].[SortSev2],
		[S_OS].[os_timestamp],
		NULL AS [Group_French],
		NULL AS [Section_French],
		NULL AS [Description_French]
	FROM 
		[BWSdb].[dbo].[Order StandardsV2] [S_OS] WITH (NOLOCK)
)