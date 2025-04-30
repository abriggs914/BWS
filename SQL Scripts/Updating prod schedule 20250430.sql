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
(7281, 'AL1', '2025-05-13'),
(7455, 'AL1', '2025-05-16'),
(7456, 'AL1', '2025-05-23'),
(7408, 'AL1', '2025-05-27'),
(7404, 'AL1', '2025-05-30'),
(7407, 'AL1', '2025-06-03'),
(7282, 'AL1', '2025-06-05'),
(7283, 'AL1', '2025-06-10'),
(7284, 'AL1', '2025-06-12'),
(7311, 'AL1', '2025-06-17'),
(7310, 'AL1', '2025-06-19'),
(7303, 'AL1', '2025-06-24'),
(7405, 'AL1', '2025-06-26'),
(7406, 'AL1', '2025-07-02'),
(7312, 'AL1', '2025-07-08'),
(7457, 'AL1', '2025-07-10'),
(7158, 'AL1', '2025-07-15'),
(7159, 'AL1', '2025-07-17'),
(7460, 'AL1', '2025-07-22'),
(7462, 'AL1', '2025-07-24'),
(7463, 'AL1', '2025-07-29'),
(7464, 'AL1', '2025-07-31'),
(7465, 'AL1', '2025-08-06'),
(7466, 'AL1', '2025-08-12'),
(7467, 'AL1', '2025-08-14'),
(7304, 'AL1', '2025-08-19'),
(7305, 'AL1', '2025-08-21'),
(7306, 'AL1', '2025-08-26'),
(7307, 'AL1', '2025-08-28'),
(7308, 'AL1', '2025-09-02'),
(7309, 'AL1', '2025-09-04'),
(7298, 'AL1', '2025-09-09'),
(7299, 'AL1', '2025-09-11'),
(7300, 'AL1', '2025-09-16'),
(7301, 'AL1', '2025-09-18'),
(7302, 'AL1', '2025-09-23'),
(31423, 'AL1', '2025-09-25'),

-- AL2 by Month
(7409, 'AL2', '2025-05-26'),
(7410, 'AL2', '2025-05-14'),
(7411, 'AL2', '2025-05-21'),
(7412, 'AL2', '2025-05-29'),

(7493, 'AL2', '2025-06-02'),
(7424, 'AL2', '2025-06-04'),
(7425, 'AL2', '2025-06-09'),
(7426, 'AL2', '2025-06-11'),
(7427, 'AL2', '2025-06-16'),
(7428, 'AL2', '2025-06-18'),
(7429, 'AL2', '2025-06-23'),
(7461, 'AL2', '2025-07-09')
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