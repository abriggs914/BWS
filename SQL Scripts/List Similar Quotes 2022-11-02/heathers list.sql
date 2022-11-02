
-- Heathers quotes in question
DECLARE @t AS TABLE([ID] INT IDENTITY(1, 1), [Quote] INT, [SameAs] INT)

INSERT INTO @t ([Quote], [SameAs]) VALUES
(28070, NULL),
(28062, NULL),
(28067, NULL),
(28176, 28067),
(28139, NULL),
(28069, NULL),
(28202, 28139),
(28203, 28139),
(28068, 28069),
(28173, 28067),
(28178, 28069),
(28204, 28139),
(28171, 28062),
(28172, 28062),
(28174, 28062),
(28179, 28069),
(28205, 28139),
(28175, NULL),
(28177, 28067),
(28138, NULL),
(28125, NULL),
(28236, NULL),
(28237, NULL),
(28244, 28125),
(28124, NULL)
;

SELECT * FROM @t

SELECT
	*
FROM 
	[Orders]
INNER JOIN
	@t
ON
	[Orders].[Quote#] = [@t].[Quote]

SELECT
	*
FROM
	[Orders]
LEFT JOIN
	[Order Options] 
ON
	[Orders].[Quote#] = [Order Options].[Quote#]
WHERE
	[Order Options].[Quote#] IS NULL
ORDER BY
	[Orders].[Quote#]

SELECT
	*
FROM
	[Orders]
LEFT JOIN
	[Custom Work]
ON
	[Orders].[Quote#] = [Custom Work].[Quote#]
WHERE
	[Custom Work].[Quote#] IS NULL
ORDER BY
	[Orders].[Quote#]

	/*
SELECT
	*
FROM
	[Orders]
LEFT JOIN
	[Order OptionsV2] 
ON
	[Orders].[WO#] = [Order OptionsV2].[WO#]
WHERE
	[Order OptionsV2].[WO#] IS NULL
ORDER BY
	[Orders].[Quote#]

SELECT
	*
FROM
	[OrdersV2]
LEFT JOIN
	[Custom WorkV2]
ON
	[OrdersV2].[WO#] = [Custom WorkV2].[WO#]
WHERE
	[Custom WorkV2].[WO#] IS NULL
ORDER BY
	[OrdersV2].
*/


SELECT * FROM (
	SELECT
		[Orders].*
	FROM
		[Orders]
	LEFT JOIN
		[Custom Work]
	ON
		[Orders].[Quote#] = [Custom Work].[Quote#]
	WHERE
		[Custom Work].[Quote#] IS NULL
) AS [SrcA]
INNER JOIN
	@t
ON
	[SrcA].[Quote#] = [@t].[Quote]
ORDER BY
	[SrcA].[Quote#]