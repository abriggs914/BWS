USE BWSdb
GO

--SELECT
--	*
--FROM 
--	@t
--LEFT JOIN
--	[OrdersV2]
--ON
--	[OrdersV2].[SGQuote] = [@t].[SGQuote]
--	AND [IsSTGQuote] = 1
--LEFT JOIN
--	[Orders]
--ON
--	CAST([Orders].[Quote#] AS NVARCHAR(5)) = [@t].[SGQuote]
--	AND [IsSTGQuote] = 0
--ORDER BY
--	[@t].[ID]
--;

SELECT
	*
FROM 
	[dbo].#temp_stg_update AS [T]
LEFT JOIN
	[BWSdb].[dbo].[Custom WorkV2_SpecLines] AS [O]
ON
	[O].[SGQuote] = [T].[SGQuote]
	AND [IsSTGQuote] = 1
WHERE
	[SpecDescription] LIKE '%9 ft%'
	AND [SpecSortSe] = 370
ORDER BY
	[T].[ID]
;
