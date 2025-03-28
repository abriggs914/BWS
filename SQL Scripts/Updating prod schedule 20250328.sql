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


--BEGIN TRAN;

DECLARE @data TABLE ([ID] INT IDENTITY(0, 1), [WO/Quote] INT, [Line] NVARCHAR(3), [Date] DATETIME)
INSERT INTO @data (
	[WO/Quote],
	[Line],
	[Date]
)
VALUES

-- AL1 by Month
(7280, 'AL1', '2025-03-31'),
(7281, 'AL1', '2025-04-07'),
(31111, 'AL1', '2025-04-14'),
(31119, 'AL1', '2025-04-16'),
(7408, 'AL1', '2025-04-21'),
(7404, 'AL1', '2025-04-23'),
(7407, 'AL1', '2025-04-28'),
(7282, 'AL1', '2025-04-30'),

(7283, 'AL1', '2025-05-05'),
(7284, 'AL1', '2025-05-07'),
(7311, 'AL1', '2025-05-12'),
(7310, 'AL1', '2025-05-14'),
(7303, 'AL1', '2025-05-20'),
(7405, 'AL1', '2025-05-22'),
(7406, 'AL1', '2025-05-26'),
(7312, 'AL1', '2025-05-28'),

(31185, 'AL1', '2025-06-02'),
(31230, 'AL1', '2025-06-04'),
(31231, 'AL1', '2025-06-09'),
(31174, 'AL1', '2025-06-11'),
(31247, 'AL1', '2025-06-16'),
(31276, 'AL1', '2025-06-18'),
(7304, 'AL1', '2025-06-23'),
(7305, 'AL1', '2025-06-25'),

(7306, 'AL1', '2025-07-02'),
(7307, 'AL1', '2025-07-03'),
(7308, 'AL1', '2025-07-07'),
(7309, 'AL1', '2025-07-09'),
(7298, 'AL1', '2025-07-14'),
(7299, 'AL1', '2025-07-16'),
(7300, 'AL1', '2025-07-21'),
(7301, 'AL1', '2025-07-23'),
(7302, 'AL1', '2025-07-28'),


-- AL2 by Month
(7409, 'AL2', '2025-04-15'),
(7428, 'AL2', '2025-04-22'),
(7427, 'AL2', '2025-04-24'),
(7429, 'AL2', '2025-04-29'),

(7425, 'AL2', '2025-05-06'),
(7410, 'AL2', '2025-05-08'),
(7411, 'AL2', '2025-05-13'),
(7424, 'AL2', '2025-05-20'),
(7412, 'AL2', '2025-05-22'),
(7426, 'AL2', '2025-05-27'),

(31161, 'AL2', '2025-07-08')
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