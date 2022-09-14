USE BWSdb
GO

CREATE VIEW [dbo].[v_GalvanizedStargateOrders] AS

SELECT 
	[OrdersV2].[SGQuote]
FROM (
	SELECT DISTINCT
		[SGQuote]
	FROM 
		[Order OptionsV2_SpecLines] WITH (NOLOCK)
	WHERE 
		[SpecGroup] = 'GENERAL SPECIFICATIONS'
		AND SpecSection = 'Color'
		AND SpecSortSeLine = 0
		AND LOWER([SpecDescription]) LIKE '%galv%'
	
	UNION ALL

	SELECT DISTINCT
		[SGQuote]
	FROM
		[Custom WorkV2_SpecLines] WITH (NOLOCK)
	WHERE
		[SpecGroup] = 'GENERAL SPECIFICATIONS'
		AND SpecSection = 'Color'
		AND SpecSortSeLine = 0
		AND LOWER([SpecDescription]) LIKE '%galv%'
) AS [Src]
LEFT JOIN
	[BWSdb].[dbo].[OrdersV2]
ON
	[Src].[SGQuote] = [OrdersV2].[SGQuote] 