USE Stargatedb
GO


SELECT
	[P2].*
FROM (
	SELECT
		ROW_NUMBER() OVER(
			PARTITION BY [P1].[SGQuote]
			ORDER BY [P1].[UpdateDate] DESC
		) AS [RowN]
		, [P1].[SGQuote]
		, [P1].[UpdateID]
	FROM
		[PDS Updates] AS [P1]
	GROUP BY
		[P1].[SGQuote]
		, [P1].[UpdateID]
		, [P1].[UpdateDate]
) AS [A]
INNER JOIN
	[PDS Updates] AS [P2]
ON
	[A].[UpdateID] = [P2].[UpdateID]
WHERE
	[RowN] = 1
ORDER BY
	[SGQuote]
;
