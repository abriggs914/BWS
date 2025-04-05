/*
SELECT TOP 50
	*
FROM
	[BWSdb].[dbo].[dtProductionSchedule] [dtP]
ORDER BY
 [dtP].[Prod Date 1] DESC
SELECT TOP 50
	*
FROM
	[BWSdb].[dbo].[Production] [dtP]
ORDER BY
 [dtP].[Prod Date] DESC
;
*/


BEGIN TRAN;

DECLARE @data TABLE ([ID] INT IDENTITY(0, 1), [WO/Quote] INT, [Line] NVARCHAR(3), [Date] DATETIME)
INSERT INTO @data (
	[WO/Quote],
	[Line],
	[Date]
)
VALUES

-- AL1 by Month
(31274, 'AL1', '2025-06-23'),
(31309, 'AL1', '2025-06-25'),

(31326, 'AL1', '2025-07-02'),
(31308, 'AL1', '2025-07-03'),
(7304, 'AL1', '2025-07-07'),
(7305, 'AL1', '2025-07-09'),
(7306, 'AL1', '2025-07-14'),
(7307, 'AL1', '2025-07-16'),
(7308, 'AL1', '2025-07-21'),
(7309, 'AL1', '2025-07-23'),
(7298, 'AL1', '2025-07-28'),
(7299, 'AL1', '2025-07-30'),

(7300, 'AL1', '2025-08-05'),
(7301, 'AL1', '2025-08-07'),
(7302, 'AL1', '2025-08-12'),


-- AL2 by Month
(7410, 'AL2', '2025-04-28'),

(7411, 'AL2', '2025-05-01'),
(7412, 'AL2', '2025-05-07'),
(7424, 'AL2', '2025-05-13'),
(7425, 'AL2', '2025-05-20'),
(7426, 'AL2', '2025-05-26'),
(7427, 'AL2', '2025-05-29'),

(7428, 'AL2', '2025-06-04'),
(7429, 'AL2', '2025-06-10')
;
DECLARE @min_date DATETIME
DECLARE @max_date DATETIME
SELECT
	@min_date = MIN([Date])
	, @max_date = MAX([Date])
FROM
	@data
GROUP BY
	[Date]
;

SELECT
	*
FROM
	[BWSdb].[dbo].[Production] [dtP]
LEFT JOIN (
	SELECT 
		[Src1].*,
		[dtP].[Prod Line],
		[dtP].[Prod Line2],
		[dtP].[Prod Date],
		[dtP].[Prod Date2]
	FROM (
		SELECT
			ROW_NUMBER() OVER(
				PARTITION BY
					[WO/Quote] 
				ORDER BY
					[F_WO] DESC
			) AS [RN],
			*
		FROM (
			SELECT
				1 AS [F_WO],
				[Data].*,
				[O].[Quote#],
				[O].[WO#],
				[O].[Model No],
				[O].[Quote Date]
			FROM
				[BWSdb].[dbo].[Orders] [O]
			INNER JOIN
				@data [Data]
			ON
				[O].[WO#] = CAST('1001' + CAST([Data].[WO/Quote] AS NVARCHAR(5)) AS INT)

			UNION
 
			SELECT
				0 AS [F_WO],
				[Data].*,
				[O].[Quote#],
				[O].[WO#],
				[O].[Model No],
				[O].[Quote Date]
			FROM
				[BWSdb].[dbo].[Orders] [O]
			INNER JOIN
				@data [Data]
			ON
				[O].[Quote#] = [Data].[WO/Quote]
		) AS [Src0]
	) AS [Src1]
	INNER JOIN
		[BWSdb].[dbo].[Production] [dtP]
	ON
		[Src1].[Quote#] = [dtP].[Quote#]
	WHERE
		[RN] = 1
) AS [D]
ON
	[dtP].[Quote#] = [D].[Quote#]
WHERE
	([D].[Quote#] IS NULL)
	AND (ISNULL([dtP].[Prod Date], [dtP].[Prod Date2]) BETWEEN @min_date AND DATEADD(DAY, 1, @max_date))


SELECT COUNT(*) FROM @data;


SELECT 
	[Src1].*,
	[dtP].[Prod Line],
	[dtP].[Prod Line2],
	[dtP].[Prod Date],
	[dtP].[Prod Date2]
FROM (
	SELECT
		ROW_NUMBER() OVER(
			PARTITION BY
				[WO/Quote] 
			ORDER BY
				[F_WO] DESC
		) AS [RN],
		*
	FROM (
		SELECT
			1 AS [F_WO],
			[Data].*,
			[O].[Quote#],
			[O].[WO#],
			[O].[Model No],
			[O].[Quote Date]
		FROM
			[BWSdb].[dbo].[Orders] [O]
		INNER JOIN
			@data [Data]
		ON
			[O].[WO#] = CAST('1001' + CAST([Data].[WO/Quote] AS NVARCHAR(5)) AS INT)

		UNION
 
		SELECT
			0 AS [F_WO],
			[Data].*,
			[O].[Quote#],
			[O].[WO#],
			[O].[Model No],
			[O].[Quote Date]
		FROM
			[BWSdb].[dbo].[Orders] [O]
		INNER JOIN
			@data [Data]
		ON
			[O].[Quote#] = [Data].[WO/Quote]
	) AS [Src0]
) AS [Src1]
INNER JOIN
	[BWSdb].[dbo].[Production] [dtP]
ON
	[Src1].[Quote#] = [dtP].[Quote#]
WHERE
	[RN] = 1
ORDER BY
	[Date]
;



SELECT 
	[Src1].*,
	[dtP].[Prod Line],
	[dtP].[Prod Line2],
	[dtP].[Prod Date],
	[dtP].[Prod Date2]
FROM (
	SELECT
		ROW_NUMBER() OVER(
			PARTITION BY
				[WO/Quote] 
			ORDER BY
				[F_WO] DESC
		) AS [RN],
		*
	FROM (
		SELECT
			1 AS [F_WO],
			[Data].*,
			[O].[Quote#],
			[O].[WO#],
			[O].[Model No],
			[O].[Quote Date]
		FROM
			[BWSdb].[dbo].[Orders] [O]
		INNER JOIN
			@data [Data]
		ON
			[O].[WO#] = CAST('1001' + CAST([Data].[WO/Quote] AS NVARCHAR(5)) AS INT)

		UNION
 
		SELECT
			0 AS [F_WO],
			[Data].*,
			[O].[Quote#],
			[O].[WO#],
			[O].[Model No],
			[O].[Quote Date]
		FROM
			[BWSdb].[dbo].[Orders] [O]
		INNER JOIN
			@data [Data]
		ON
			[O].[Quote#] = [Data].[WO/Quote]
	) AS [Src0]
) AS [Src1]
INNER JOIN
	[BWSdb].[dbo].[Production] [dtP]
ON
	[Src1].[Quote#] = [dtP].[Quote#]
WHERE
	[RN] = 1
ORDER BY
	[Date]

-------------

UPDATE
	[BWSdb].[dbo].[Production]
SET
	[Prod Date] = [Src1].[Date],
	[Prod Line] = [Src1].[Line]
FROM
	[BWSdb].[dbo].[Production] [dtP]
INNER JOIN (
	SELECT
		ROW_NUMBER() OVER(
			PARTITION BY
				[WO/Quote] 
			ORDER BY
				[F_WO] DESC
		) AS [RN],
		*
	FROM (
		SELECT
			1 AS [F_WO],
			[Data].*,
			[O].[Quote#],
			[O].[WO#],
			[O].[Model No],
			[O].[Quote Date]
		FROM
			[BWSdb].[dbo].[Orders] [O]
		INNER JOIN
			@data [Data]
		ON
			[O].[WO#] = CAST('1001' + CAST([Data].[WO/Quote] AS NVARCHAR(5)) AS INT)

		UNION
 
		SELECT
			0 AS [F_WO],
			[Data].*,
			[O].[Quote#],
			[O].[WO#],
			[O].[Model No],
			[O].[Quote Date]
		FROM
			[BWSdb].[dbo].[Orders] [O]
		INNER JOIN
			@data [Data]
		ON
			[O].[Quote#] = [Data].[WO/Quote]
	) AS [Src0]
) AS [Src1]
ON
	[dtP].[Quote#] = [Src1].[Quote#]


UPDATE
	[BWSdb].[dbo].[dtProductionSchedule]
SET
	[Prod Date 1] = [Src1].[Date],
	[WO Line 1] = [Src1].[Line]
FROM
	[BWSdb].[dbo].[dtProductionSchedule] [dtP]
INNER JOIN (
	SELECT
		ROW_NUMBER() OVER(
			PARTITION BY
				[WO/Quote] 
			ORDER BY
				[F_WO] DESC
		) AS [RN],
		*
	FROM (
		SELECT
			1 AS [F_WO],
			[Data].*,
			[O].[Quote#],
			[O].[WO#],
			[O].[Model No],
			[O].[Quote Date]
		FROM
			[BWSdb].[dbo].[Orders] [O]
		INNER JOIN
			@data [Data]
		ON
			[O].[WO#] = CAST('1001' + CAST([Data].[WO/Quote] AS NVARCHAR(5)) AS INT)

		UNION
 
		SELECT
			0 AS [F_WO],
			[Data].*,
			[O].[Quote#],
			[O].[WO#],
			[O].[Model No],
			[O].[Quote Date]
		FROM
			[BWSdb].[dbo].[Orders] [O]
		INNER JOIN
			@data [Data]
		ON
			[O].[Quote#] = [Data].[WO/Quote]
	) AS [Src0]
) AS [Src1]
ON
	[dtP].[Quote#] = [Src1].[Quote#]
-------------

SELECT 
	[Src1].*,
	[dtP].[Prod Line],
	[dtP].[Prod Line2],
	[dtP].[Prod Date],
	[dtP].[Prod Date2]
FROM (
	SELECT
		ROW_NUMBER() OVER(
			PARTITION BY
				[WO/Quote] 
			ORDER BY
				[F_WO] DESC
		) AS [RN],
		*
	FROM (
		SELECT
			1 AS [F_WO],
			[Data].*,
			[O].[Quote#],
			[O].[WO#],
			[O].[Model No],
			[O].[Quote Date]
		FROM
			[BWSdb].[dbo].[Orders] [O]
		INNER JOIN
			@data [Data]
		ON
			[O].[WO#] = CAST('1001' + CAST([Data].[WO/Quote] AS NVARCHAR(5)) AS INT)

		UNION
 
		SELECT
			0 AS [F_WO],
			[Data].*,
			[O].[Quote#],
			[O].[WO#],
			[O].[Model No],
			[O].[Quote Date]
		FROM
			[BWSdb].[dbo].[Orders] [O]
		INNER JOIN
			@data [Data]
		ON
			[O].[Quote#] = [Data].[WO/Quote]
	) AS [Src0]
) AS [Src1]
INNER JOIN
	[BWSdb].[dbo].[Production] [dtP]
ON
	[Src1].[Quote#] = [dtP].[Quote#]
WHERE
	[RN] = 1
ORDER BY
	[Date]

SELECT 
	[Src1].*,
	[dtP].[WO Line 1],
	[dtP].[WO Line 2],
	[dtP].[Prod Date 1],
	[dtP].[Prod Date 2]
FROM (
	SELECT
		ROW_NUMBER() OVER(
			PARTITION BY
				[WO/Quote] 
			ORDER BY
				[F_WO] DESC
		) AS [RN],
		*
	FROM (
		SELECT
			1 AS [F_WO],
			[Data].*,
			[O].[Quote#],
			[O].[WO#],
			[O].[Model No],
			[O].[Quote Date]
		FROM
			[BWSdb].[dbo].[Orders] [O]
		INNER JOIN
			@data [Data]
		ON
			[O].[WO#] = CAST('1001' + CAST([Data].[WO/Quote] AS NVARCHAR(5)) AS INT)

		UNION
 
		SELECT
			0 AS [F_WO],
			[Data].*,
			[O].[Quote#],
			[O].[WO#],
			[O].[Model No],
			[O].[Quote Date]
		FROM
			[BWSdb].[dbo].[Orders] [O]
		INNER JOIN
			@data [Data]
		ON
			[O].[Quote#] = [Data].[WO/Quote]
	) AS [Src0]
) AS [Src1]
INNER JOIN
	[BWSdb].[dbo].[dtProductionSchedule] [dtP]
ON
	[Src1].[Quote#] = [dtP].[Quote#]
WHERE
	[RN] = 1
ORDER BY
	[Date]

ROLLBACK;
COMMIT;


--------------------------------------------------
/*
SELECT
	[Data].*,
	[O].*
FROM
	[BWSdb].[dbo].[Orders] [O]
INNER JOIN
	@data [Data]
ON
	(CASE WHEN [O].[WO#] = [Data].[WO/Quote] THEN 1 ELSE (
		CASE WHEN [O].[Quote#] = [Data].[WO/Quote] THEN 1 ELSE 0 END
	) END) = 1
	--([O].[Quote#] = [Data].[WO/Quote])
	--OR ([O].[WO#] = [Data].[WO/Quote])
ORDER BY
	[WO/Quote]
*/