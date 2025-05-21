
-- Updating Prod Sched 20250505 1341

BEGIN TRAN;

	DECLARE @data TABLE ([ID] INT IDENTITY(0, 1), [WO/Quote] INT, [Line] NVARCHAR(3), [Date] DATETIME)
	INSERT INTO @data (
		[WO/Quote],
		[Date],
		[Line]
	)
	VALUES
	
	(31430, '2025-07-30', 'AL2'),
	(31433, '2025-08-07', 'AL2'),
	(31468, '2025-08-13', 'AL2'),
	(31485, '2025-08-20', 'AL2'),
	(31334, '2025-09-03', 'AL2'),
	(31335, '2025-09-10', 'AL2'),

	(7302, '2025-11-05', 'AL1'),
	(7301, '2025-11-03', 'AL1'),
	(7300, '2025-10-29', 'AL1'),
	(7299, '2025-10-27', 'AL1'),
	(7298, '2025-10-22', 'AL1'),
	(7309, '2025-10-20', 'AL1'),
	(7308, '2025-10-15', 'AL1'),
	(7307, '2025-10-13', 'AL1'),
	(7306, '2025-10-08', 'AL1'),
	(7305, '2025-10-06', 'AL1'),
	(7304, '2025-10-01', 'AL1'),
	(7303, '2025-09-29', 'AL1'),
	(31343, '2025-08-19', 'AL1'),
	(31490, '2025-08-21', 'AL1'),
	(31423, '2025-08-26', 'AL1')
	
	SELECT COUNT(*) AS [#Units] FROM @data;
	SELECT [WO/Quote] AS [#Units] FROM @data GROUP BY [WO/Quote] HAVING COUNT(*) > 1;

	WITH [DatedUnits] (
		[RN],
		[F_WO],
		[WO/Quote],
		[Line],
		[Date],
		[Quote#],
		[WO#],
		[Model No],
		[Quote Date]
	) AS (
		SELECT
			ROW_NUMBER() OVER(
				PARTITION BY
					[WO/Quote] 
				ORDER BY
					[F_WO] DESC
			) AS [RN],
			[F_WO],
			[WO/Quote],
			[Line],
			[Date],
			[Quote#],
			[WO#],
			[Model No],
			[Quote Date]
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
	)
		
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
		INNER JOIN
			[BWSdb].[dbo].[Prod Lines] [PL]
		ON
			[Src1].[Line] = [PL].[Prod Line]
		ORDER BY
			[Date],
			[LO]
		/*WHERE
			[RN] = 1*/
	/*) AS [Src]
	RIGHT JOIN
		@data
	ON
		[Src].[Quote#] */



	SELECT 
		[Src1].*,
		[dtP].[WO Line 1],
		[dtP].[WO Line 2],
		[dtP].[Prod Date 1],
		[dtP].[Prod Date 2]
	FROM (
		SELECT
			*
		FROM
			[DatedUnits]
	) AS [Src1]
	INNER JOIN
		[BWSdb].[dbo].[dtProductionSchedule] [dtP]
	ON
		[Src1].[Quote#] = [dtP].[Quote#]
	WHERE
		[RN] = 1
	ORDER BY
		[Date]

	/*
	-- Confirming that there are no entries in @data that are invalid (planned for same line & date)
	SELECT
		*
	FROM
		@data [q1]
	CROSS JOIN
		@data [q2]
	WHERE
		([q1].[Date] = [q2].[Date])
		AND ([q1].[Line] = [q2].[Line])
		AND ([q1].[WO/Quote] <> [q2].[WO/Quote])
	*/


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