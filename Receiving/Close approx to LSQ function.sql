
-- 2025-09-25 18:27 - Avery Briggs - Close approx to LSQ function.
--  Getting System.OutOfMemoryException error though.

; WITH OS AS (
	SELECT
		[OS].[SortG],
		[OS].[SortSe],
		[OS].[Quote#],
		[OS].[Model No],
		COUNT(*) AS [Num],
		SUM([OO].[CountOptions]) AS [CountOptions],
		SUM([CW].[CountNPOs]) AS [CountNPOs]
	FROM
		[BWSdb].[dbo].[Order Standards] [OS]
	LEFT JOIN (
		SELECT
			[OO].[Quote#],
			COUNT(*) AS [CountOptions]
		FROM
			[BWSdb].[dbo].[Order Options] [OO]
		GROUP BY
			[OO].[Quote#]
	) AS [OO]
	ON
		[OS].[Quote#] = [OO].[Quote#]
	LEFT JOIN (
		SELECT
			[CW].[Quote#],
			COUNT(*) AS [CountNPOs]
		FROM
			[BWSdb].[dbo].[Custom Work] [CW]
		GROUP BY
			[CW].[Quote#]
	) AS [CW]
	ON
		[OS].[Quote#] = [CW].[Quote#]
	GROUP BY
		[OS].[SortG],
		[OS].[SortSe],
		[OS].[Quote#],
		[OS].[Model No]
)
--SELECT COUNT(*) FROM [OS]
SELECT
	[A].[Quote#] AS [Quote_A]
	, [B].[Quote#] AS [Quote_B]
FROM
	[OS] [A]
INNER JOIN
	[OS] [B]
ON
	([A].[Quote#] < [B].[Quote#])
	AND ([A].[Model No] = [B].[Model No])
	AND ([A].[SortG] = [B].[SortG])
	AND ([A].[SortSe] = [B].[SortSe])
	AND ([A].[Num] = [B].[Num])
	AND ([A].[CountOptions] = [B].[CountOptions])
	AND ([A].[CountNPOs] = [B].[CountNPOs])