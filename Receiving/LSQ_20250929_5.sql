/*
SELECT DISTINCT
	[A].[ProductID]
FROM
	[BWSdb].[dbo].[Orders] [A]
WHERE
	RIGHT([A].[Model No], 3) = 'ANR'
*/

SELECT ProductID, SortG, SortSe, Description,
           STRING_AGG([O].Quote#, ',') AS Quotes,
           COUNT(*) AS Cnt
    FROM [BWSdb].[dbo].Orders O
    INNER JOIN [BWSdb].[dbo].[Order Standards] OS ON O.Quote# = OS.Quote#
    WHERE O.[Order Date] >= '2024-12-31'
    GROUP BY ProductID, SortG, SortSe, Description
    HAVING COUNT(*) > 1


;WITH OrderStandards AS (
	SELECT 
		[S_A].[SortG],
		[S_A].[SortSe],
		[S_A].[Description],
		[A].[Quote#],
		[A].[ProductID]
	FROM
		[BWSdb].[dbo].[Orders] [A]
	INNER JOIN
		[BWSdb].[dbo].[Order Standards] [S_A]
	ON
		[A].[Quote#] = [S_A].[Quote#]
	WHERE
		([A].[ProductID] IN (1440, 1436, 1454, 2258))
		AND ([Order Date] >= '2024-12-31')
),
SameModel AS (
	SELECT
		[A].[Quote#] AS [Quote_A] 
		,[B].[Quote#] AS [Quote_B] 
	FROM 
		OrderStandards [A]
	INNER JOIN 
		OrderStandards [B]
	ON
		([A].[Quote#] <> [B].[Quote#])
		AND ([A].[ProductID] = [B].[ProductID])
		AND ([A].[SortG] = [B].[SortG])
		AND ([A].[SortSe] = [B].[SortSe])
		AND ([A].[Description] = [B].[Description])
	GROUP BY
		[A].[Quote#]
		, [B].[Quote#]
)
SELECT
	[SM].[Quote_A]
	,[SM].[Quote_B]
FROM
	SameModel [SM]
ORDER BY
	[SM].[Quote_A]
;