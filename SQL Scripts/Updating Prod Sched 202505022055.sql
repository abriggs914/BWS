
-- Updating Prod Sched 20250502 2055

BEGIN TRAN;

	DECLARE @data TABLE ([ID] INT IDENTITY(0, 1), [WO/Quote] INT, [Line] NVARCHAR(3), [Date] DATETIME)
	INSERT INTO @data (
		[WO/Quote],
		[Date],
		[Line]
	)
	VALUES

	-- MAY
	(7253, '2025-05-05', 'T1'),
	(7392, '2025-05-07', 'T1'), -- looks like 7592 though
	(7430, '2025-05-12', 'T1'),
	(7419, '2025-05-14', 'T1'),
	(7415, '2025-05-20', 'T1'),
	(7393, '2025-05-22', 'T1'),
	(7394, '2025-05-27', 'T1'),
	(7395, '2025-05-29', 'T1'),

	(7391, '2025-05-06', 'T4'),
	(7421, '2025-05-13', 'T4'),
	(7422, '2025-05-21', 'T4'),
	(7468, '2025-05-27', 'T4'),

	(7369, '2025-05-05', 'T5'),
	(7336, '2025-05-07', 'T5'),
	(7414, '2025-05-13', 'T5'),
	(7381, '2025-05-15', 'T5'),
	(7382, '2025-05-21', 'T5'),
	(7420, '2025-05-26', 'T5'),

	(7333, '2025-05-05', 'T6'),
	(7431, '2025-05-06', 'T6'),
	(7320, '2025-05-15', 'T6'),
	(7413, '2025-05-20', 'T6'),
	(7396, '2025-05-21', 'T6'),
	(7252, '2025-05-22', 'T6'),
	(7445, '2025-05-26', 'T6'),
	--(7369, '2025-05-27', 'T6'),

	(7296, '2025-05-05', 'T9'),
	(7239, '2025-05-12', 'T9'),
	(7225, '2025-05-20', 'T9'),
	(7297, '2025-05-27', 'T9'),

	(7401, '2025-05-05', 'T15'),
	(7402, '2025-05-07', 'T15'),
	(7370, '2025-05-12', 'T15'),
	(7371, '2025-05-14', 'T15'),
	(7432, '2025-05-20', 'T15'),
	(7450, '2025-05-22', 'T15'),
	(7451, '2025-05-27', 'T15'),
	(7448, '2025-05-29', 'T15'),

	(7390, '2025-05-05', 'T12'),
	(7416, '2025-05-07', 'T12'),
	(7417, '2025-05-12', 'T12'),
	(7418, '2025-05-14', 'T12'),
	(7400, '2025-05-20', 'T12'),

	-- JUNE
	(7447, '2025-06-03', 'T1'),
	(7437, '2025-06-05', 'T1'),
	(7469, '2025-06-10', 'T1'),
	(7470, '2025-06-12', 'T1'),
	(7471, '2025-06-17', 'T1'),
	(7504, '2025-06-19', 'T1'),
	(7505, '2025-06-24', 'T1'),
	(7489, '2025-06-26', 'T1'),

	(7423, '2025-06-02', 'T4'),
	(7438, '2025-06-05', 'T4'),
	(7472, '2025-06-12', 'T4'),
	(7473, '2025-06-17', 'T4'),
	(7475, '2025-06-19', 'T4'),
	(7476, '2025-06-24', 'T4'),
	(7433, '2025-06-26', 'T4'),

	(7378, '2025-06-02', 'T5'),
	(7449, '2025-06-04', 'T5'),
	(7454, '2025-06-09', 'T5'),
	(7435, '2025-06-11', 'T5'),
	(7474, '2025-06-16', 'T5'),
	(7479, '2025-06-18', 'T5'),
	(7480, '2025-06-23', 'T5'),
	(7440, '2025-06-25', 'T5'),
	(7441, '2025-06-30', 'T5'),

	(7229, '2025-06-03', 'T9'),
	(7226, '2025-06-10', 'T9'),
	(7238, '2025-06-17', 'T9'),
	(7230, '2025-06-24', 'T9'),

	(7377, '2025-06-10', 'T15'),
	(7439, '2025-06-12', 'T15'),
	(7436, '2025-06-17', 'T15'),
	(7427, '2025-06-19', 'T15'),
	(7428, '2025-06-24', 'T15'),
	(7429, '2025-06-26', 'T15'),

	(7337, '2025-06-09', 'T12'),
	(7338, '2025-06-10', 'T12'),
	(7339, '2025-06-11', 'T12'),
	(7340, '2025-06-12', 'T12'),

	-- JULY
	(7529, '2025-07-02', 'T1'),
	(7530, '2025-07-07', 'T1'),
	(7531, '2025-07-09', 'T1'),
	(7532, '2025-07-14', 'T1'),
	(7477, '2025-07-16', 'T1'),
	(7478, '2025-07-21', 'T1'),
	(7488, '2025-07-23', 'T1'),
	(7498, '2025-07-28', 'T1'),
	(7501, '2025-07-30', 'T1'),

	(7494, '2025-07-02', 'T4'),
	(7495, '2025-07-08', 'T4'),
	(7485, '2025-07-14', 'T4'),
	(7484, '2025-07-16', 'T4'),
	(7486, '2025-07-21', 'T4'),
	(7487, '2025-07-23', 'T4'),
	(7535, '2025-07-28', 'T4'),
	(7536, '2025-07-30', 'T4'),

	(7444, '2025-07-02', 'T5'),
	(7481, '2025-07-07', 'T5'),
	(7482, '2025-07-09', 'T5'),
	(7452, '2025-07-14', 'T5'),
	(7453, '2025-07-16', 'T5'),
	(7496, '2025-07-21', 'T5'),
	(7497, '2025-07-23', 'T5'),
	(31275, '2025-07-28', 'T5'),
	(7499, '2025-07-30', 'T5'),

	(7163, '2025-07-02', 'T9'),
	(7228, '2025-07-09', 'T9'),

	(7442, '2025-07-02', 'T15'),
	(7443, '2025-07-07', 'T15'),
	(7483, '2025-07-09', 'T15'),
	(7490, '2025-07-14', 'T15'),
	(7492, '2025-07-16', 'T15'),
	(7491, '2025-07-21', 'T15'),
	(7502, '2025-07-23', 'T15'),
	(7533, '2025-07-28', 'T15'),
	(7534, '2025-07-30', 'T15'),

	(7341, '2025-07-07', 'T12'),
	(7342, '2025-07-08', 'T12'),
	(7343, '2025-07-09', 'T12'),
	(7344, '2025-07-10', 'T12'),

	-- AUGUST
	(31427, '2025-08-05', 'T1'),
	(31428, '2025-08-07', 'T1'),

	(31418, '2025-08-05', 'T4'),
	(31424, '2025-08-11', 'T4'),

	(7537, '2025-08-05', 'T5'),
	(7539, '2025-08-07', 'T5'),
	(31426, '2025-08-12', 'T5'),

	(7540, '2025-08-05', 'T15'),
	(7541, '2025-08-11', 'T15'),
	(7542, '2025-08-14', 'T15'),

	(7545, '2025-08-05', 'T12'),
	(7546, '2025-08-06', 'T12'),
	(7547, '2025-08-07', 'T12'),
	(7548, '2025-08-11', 'T12'),
	(7549, '2025-08-12', 'T12'),
	(7550, '2025-08-13', 'T12'),
	(7551, '2025-08-14', 'T12'),
	(7552, '2025-08-18', 'T12'),
	(7553, '2025-08-19', 'T12'),
	(7554, '2025-08-20', 'T12'),
	(7555, '2025-08-21', 'T12'),
	(7556, '2025-08-25', 'T12'),
	(7557, '2025-08-26', 'T12'),
	(7558, '2025-08-27', 'T12'),
	(7559, '2025-08-28', 'T12'),

	-- SEPTEMBER
	--(7527, '2025-09-02', 'T15'),

	(7560, '2025-09-02', 'T12'),
	(7561, '2025-09-03', 'T12'),
	(7562, '2025-09-04', 'T12'),
	(7563, '2025-09-08', 'T12'),
	(7564, '2025-09-09', 'T12'),
	(7565, '2025-09-10', 'T12'),
	(7566, '2025-09-11', 'T12'),
	(7506, '2025-09-15', 'T12'),
	(7507, '2025-09-16', 'T12'),
	(7508, '2025-09-17', 'T12'),
	(7509, '2025-09-18', 'T12'),
	(7510, '2025-09-22', 'T12'),
	(7511, '2025-09-23', 'T12'),
	(7512, '2025-09-24', 'T12'),
	(7513, '2025-09-25', 'T12'),
	(7514, '2025-09-29', 'T12'),
	(7515, '2025-09-30', 'T12'),

	-- October
	(7516, '2025-10-01', 'T12'),
	(7517, '2025-10-02', 'T12'),
	(7518, '2025-10-06', 'T12'),
	(7519, '2025-10-07', 'T12'),
	(7520, '2025-10-08', 'T12'),
	(7521, '2025-10-09', 'T12'),
	(7522, '2025-10-14', 'T12'),
	(7523, '2025-10-15', 'T12'),
	(7524, '2025-10-16', 'T12'),
	(7525, '2025-10-20', 'T12'),
	(7526, '2025-10-21', 'T12'),
	(7527, '2025-10-22', 'T12')
	
	SELECT COUNT(*) AS [#Units] FROM @data;
	SELECT [WO/Quote] AS [#Units] FROM @data GROUP BY [WO/Quote] HAVING COUNT(*) > 1;


	/*SELECT
		*
	FROM (*/
		
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