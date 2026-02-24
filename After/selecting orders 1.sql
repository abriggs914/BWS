
-- selecting orders
-- 2026-02-24

SELECT
	'BWS' AS [Comp],
	CAST([O].[Quote#] AS NVARCHAR(250)),
	[O].[WO#],
	[O].[Serial Number],
	[O].[Decline/Rejected]
FROM
	[BWSdb].[dbo].[Orders] [O] WITH (NOLOCK)
UNION ALL(
	SELECT
		'STG' AS [Comp],
		CAST([O2].[SGQuote] AS NVARCHAR(250)),
		[O2].[WO#],
		[O2].[Serial Number],
		[O2].[Decline/Rejected]
	FROM
		[BWSdb].[dbo].[OrdersV2] [O2] WITH (NOLOCK)
)