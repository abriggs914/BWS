

-- Script to collect duplicate serial tags based on prod year, and company
-- 2024-01-17

SELECT

	LEFT([Serial Number], 3) AS [Prefix],
	LEFT(RIGHT([Serial Number], 8), 1) AS [Prod Year],
	RIGHT([OrdersV2].[Serial Number], 3) AS [Suffix],
	[Serial Number],
	* 
FROM
	[OrdersV2]
INNER JOIN
	(
	SELECT
		LEFT([Serial Number], 3) AS [Prefix],
		RIGHT([Serial Number], 3) AS [Suffix],
		(LEFT(RIGHT([Serial Number], 8), 1)) AS [Prod Year]
	FROM (
	SELECT 
		[SGQuote] AS [A],
		[Serial Number],
		LEFT([Serial Number], 3) AS [B],
		RIGHT([Serial Number], 3) AS [C],
		(LEFT(RIGHT([Serial Number], 8), 1)) AS [D]
	FROM
		[OrdersV2]
	GROUP BY
		[SGQuote],
		[Serial Number],
		RIGHT([Serial Number], 3),
		(LEFT(RIGHT([Serial Number], 8), 1))
	--HAVING
	--	COUNT(*) > 1
	--ORDER BY
	--	RIGHT([Serial Number], 3)

	) AS [Src]
	WHERE
		[Serial Number] IS NOT NULL
	GROUP BY
		LEFT([Serial Number], 3),
		RIGHT([Serial Number], 3),
		(LEFT(RIGHT([Serial Number], 8), 1))
	HAVING
		COUNT(*) > 1
	) AS [Src2]
ON
	RIGHT([OrdersV2].[Serial Number], 3) = [Suffix]
	AND LEFT([Serial Number], 3) = [Prefix]
	AND LEFT(RIGHT([Serial Number], 8), 1) = [Prod Year]
--WHERE
--	(LEFT(RIGHT([Serial Number], 8), 1)) = 'S'
--	AND (LEFT([Serial Number], 3)) <> '2XB'
ORDER BY
	LEFT(RIGHT([Serial Number], 8), 1),
	LEFT([Serial Number], 3),
	RIGHT([OrdersV2].[Serial Number], 3)

