
SELECT
	[O].[Discount1],
	[O].[Discount2],
	[O].[Discount3],
	'BWS' AS [Comp],
	CAST([O].[Quote#] AS NVARCHAR(250)) AS [Quote],
	[O].[WO#] AS [WO],
	[O].[Serial Number] AS [SerialNumber],
	[O].[Decline/Rejected] AS [DeclineRejected],
	[O].[Quote Date] AS [QuoteDate],
	 *
FROM
	[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
WHERE
	ISNULL([O].[Discount1], 0) <> 0
	OR ISNULL([O].[Discount2], 0) <> 0
	OR ISNULL([O].[Discount3], 0) <> 0