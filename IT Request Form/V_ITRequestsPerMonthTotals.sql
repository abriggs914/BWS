USE BWSdb
GO

ALTER VIEW [dbo].[v_ITRequestsPerMonthTotals] AS
SELECT
	[Row#]
	, SUM([CountOf Requests]) AS [CountOf Requests]
	, SUM([CountOf Queued]) AS [CountOf Queued]
	, SUM([CountOf In Progress]) AS [CountOf In Progress]
	, SUM([CountOf Complete]) AS [CountOf Complete]
	, SUM([CountOf Incomplete]) AS [CountOf Incomplete]
	, SUM([CountOf Declined]) AS [CountOf Declined]
	, [Year]
	, [Month]
	, [DateFmt] 
FROM (
	SELECT
		COUNT([ITRequestID#]) AS [CountOf Requests]
		, 0 AS [CountOf Queued]
		, 0 AS [CountOf In Progress]
		, 0 AS [CountOf Complete]
		, 0 AS [CountOf Incomplete]
		, 0 AS [CountOf Declined]
		, [Year]
		, [Month]
		, [DateFmt]
		, [Row#]
	FROM (
		SELECT
		ROW_NUMBER() OVER(
			ORDER BY
				[B].SeqNo,
				[Month]
		) AS [Row#]
		, [Month]
		,[B].SeqNo AS [Year]
		,DATENAME(MONTH, DateAdd( month , [Month] , 0 ) - 1 ) + ' ' + CAST([B].[SeqNo] AS NVARCHAR(4)) AS [DateFmt]
		FROM (
			SELECT TOP 12
				[SequenceNumbers].[SeqNo] AS [Month]
			FROM
				[SequenceNumbers]
			) AS [A]
			CROSS JOIN (
				SELECT TOP 250
					[SeqNo]
				FROM
					[BWSdb].[dbo].[SequenceNumbers]
				WHERE
					[SeqNo] >= YEAR(DATEADD(MONTH, -1, (SELECT MIN([RequestDate]) AS [sd] FROM [dbo].[IT Requests])))
			) AS [B]
		WHERE
			2020 <= [B].[SeqNo] AND [B].[SeqNo] <= 2250
			AND (100 * YEAR(DATEADD(MONTH, -1, (SELECT MIN([RequestDate]) AS [sd] FROM [dbo].[IT Requests])))) + MONTH(DATEADD(MONTH, -1, (SELECT MIN([RequestDate]) AS [sd] FROM [dbo].[IT Requests]))) <= (100 * [B].[SeqNo]) + [Month] AND (100 * [B].[SeqNo]) + [Month] <= (100 * YEAR(DATEADD(MONTH, 1, (SELECT MAX([RequestDate]) AS [sd] FROM [dbo].[IT Requests])))) + MONTH(DATEADD(MONTH, 1, (SELECT MAX([RequestDate]) AS [sd] FROM [dbo].[IT Requests])))
	) AS [Calendar]
	LEFT JOIN
		[dbo].[IT Requests]
	ON
		YEAR([RequestDate]) = [Year] AND MONTH([RequestDate]) = [Month]
	LEFT JOIN
		[dbo].[IT Personnel]
	ON
		[IT Requests].[ITPersonAssignedID] = [IT Personnel].ITPersonID#
	GROUP BY
		[Year]
		, [Month]
		, [DateFmt] 
		, [Row#]

	UNION ALL

	SELECT
		0 AS [CountOf Requests]
		, COUNT([ITRequestID#]) AS [CountOf Queued]
		, 0 AS [CountOf In Progress]
		, 0 AS [CountOf Complete]
		, 0 AS [CountOf Incomplete]
		, 0 AS [CountOf Declined]
		, [Year]
		, [Month]
		, [DateFmt] 
		, [Row#]
	FROM (
		SELECT
			ROW_NUMBER() OVER(
				ORDER BY
					[B].SeqNo,
					[Month]
		) AS [Row#]
		, [Month]
		,[B].SeqNo AS [Year]
		,DATENAME(MONTH, DateAdd( month , [Month] , 0 ) - 1 ) + ' ' + CAST([B].[SeqNo] AS NVARCHAR(4)) AS [DateFmt]
		FROM (
			SELECT TOP 12
				[SequenceNumbers].[SeqNo] AS [Month]
			FROM
				[SequenceNumbers]
			) AS [A]
			CROSS JOIN (
				SELECT TOP 250
					[SeqNo]
				FROM
					[BWSdb].[dbo].[SequenceNumbers]
				WHERE
					[SeqNo] >= YEAR(DATEADD(MONTH, -1, (SELECT MIN([RequestDate]) AS [sd] FROM [dbo].[IT Requests])))
			) AS [B]
		WHERE
			2020 <= [B].[SeqNo] AND [B].[SeqNo] <= 2250
			AND (100 * YEAR(DATEADD(MONTH, -1, (SELECT MIN([RequestDate]) AS [sd] FROM [dbo].[IT Requests])))) + MONTH(DATEADD(MONTH, -1, (SELECT MIN([RequestDate]) AS [sd] FROM [dbo].[IT Requests]))) <= (100 * [B].[SeqNo]) + [Month] AND (100 * [B].[SeqNo]) + [Month] <= (100 * YEAR(DATEADD(MONTH, 1, (SELECT MAX([RequestDate]) AS [sd] FROM [dbo].[IT Requests])))) + MONTH(DATEADD(MONTH, 1, (SELECT MAX([RequestDate]) AS [sd] FROM [dbo].[IT Requests])))
	) AS [Calendar]
	LEFT JOIN
		[dbo].[IT Requests]
	ON
		YEAR([RequestDate]) = [Year] AND MONTH([RequestDate]) = [Month]
	LEFT JOIN
		[dbo].[IT Personnel]
	ON
		[IT Requests].[ITPersonAssignedID] = [IT Personnel].ITPersonID#
	WHERE
		[Status] = 'Queued'
	GROUP BY
		[Year]
		, [Month]
		, [DateFmt]
		, [Row#]

UNION ALL

	SELECT
		0 AS [CountOf Requests]
		, 0 AS [CountOf Queued]
		, COUNT([ITRequestID#]) AS [CountOf In Progress]
		, 0 AS [CountOf Complete]
		, 0 AS [CountOf Incomplete]
		, 0 AS [CountOf Declined]
		, [Year]
		, [Month]
		, [DateFmt] 
		, [Row#]
	FROM (
		SELECT
			ROW_NUMBER() OVER(
				ORDER BY
					[B].SeqNo,
					[Month]
		) AS [Row#]
		, [Month]
		,[B].SeqNo AS [Year]
		,DATENAME(MONTH, DateAdd( month , [Month] , 0 ) - 1 ) + ' ' + CAST([B].[SeqNo] AS NVARCHAR(4)) AS [DateFmt]
		FROM (
			SELECT TOP 12
				[SequenceNumbers].[SeqNo] AS [Month]
			FROM
				[SequenceNumbers]
			) AS [A]
			CROSS JOIN (
				SELECT TOP 250
					[SeqNo]
				FROM
					[BWSdb].[dbo].[SequenceNumbers]
				WHERE
					[SeqNo] >= YEAR(DATEADD(MONTH, -1, (SELECT MIN([RequestDate]) AS [sd] FROM [dbo].[IT Requests])))
			) AS [B]
		WHERE
			2020 <= [B].[SeqNo] AND [B].[SeqNo] <= 2250
			AND (100 * YEAR(DATEADD(MONTH, -1, (SELECT MIN([RequestDate]) AS [sd] FROM [dbo].[IT Requests])))) + MONTH(DATEADD(MONTH, -1, (SELECT MIN([RequestDate]) AS [sd] FROM [dbo].[IT Requests]))) <= (100 * [B].[SeqNo]) + [Month] AND (100 * [B].[SeqNo]) + [Month] <= (100 * YEAR(DATEADD(MONTH, 1, (SELECT MAX([RequestDate]) AS [sd] FROM [dbo].[IT Requests])))) + MONTH(DATEADD(MONTH, 1, (SELECT MAX([RequestDate]) AS [sd] FROM [dbo].[IT Requests])))
	) AS [Calendar]
	LEFT JOIN
		[dbo].[IT Requests]
	ON
		YEAR([RequestDate]) = [Year] AND MONTH([RequestDate]) = [Month]
	LEFT JOIN
		[dbo].[IT Personnel]
	ON
		[IT Requests].[ITPersonAssignedID] = [IT Personnel].ITPersonID#
	WHERE
		[Status] = 'In Progress'
	GROUP BY
		[Year]
		, [Month]
		, [DateFmt]
		, [Row#]

UNION ALL

	SELECT
		0 AS [CountOf Requests]
		, 0 AS [CountOf Queued]
		, 0 AS [CountOf In Progress]
		, COUNT([ITRequestID#]) AS [CountOf Complete]
		, 0 AS [CountOf Incomplete]
		, 0 AS [CountOf Declined]
		, [Year]
		, [Month]
		, [DateFmt] 
		, [Row#]
	FROM (
		SELECT
		ROW_NUMBER() OVER(
				ORDER BY
					[B].SeqNo,
					[Month]
		) AS [Row#]
		, [Month]
		,[B].SeqNo AS [Year]
		,DATENAME(MONTH, DateAdd( month , [Month] , 0 ) - 1 ) + ' ' + CAST([B].[SeqNo] AS NVARCHAR(4)) AS [DateFmt]
		FROM (
			SELECT TOP 12
				[SequenceNumbers].[SeqNo] AS [Month]
			FROM
				[SequenceNumbers]
			) AS [A]
			CROSS JOIN (
				SELECT TOP 250
					[SeqNo]
				FROM
					[BWSdb].[dbo].[SequenceNumbers]
				WHERE
					[SeqNo] >= YEAR(DATEADD(MONTH, -1, (SELECT MIN([RequestDate]) AS [sd] FROM [dbo].[IT Requests])))
			) AS [B]
		WHERE
			2020 <= [B].[SeqNo] AND [B].[SeqNo] <= 2250
			AND (100 * YEAR(DATEADD(MONTH, -1, (SELECT MIN([RequestDate]) AS [sd] FROM [dbo].[IT Requests])))) + MONTH(DATEADD(MONTH, -1, (SELECT MIN([RequestDate]) AS [sd] FROM [dbo].[IT Requests]))) <= (100 * [B].[SeqNo]) + [Month] AND (100 * [B].[SeqNo]) + [Month] <= (100 * YEAR(DATEADD(MONTH, 1, (SELECT MAX([RequestDate]) AS [sd] FROM [dbo].[IT Requests])))) + MONTH(DATEADD(MONTH, 1, (SELECT MAX([RequestDate]) AS [sd] FROM [dbo].[IT Requests])))
	) AS [Calendar]
	LEFT JOIN
		[dbo].[IT Requests]
	ON
		YEAR([RequestDate]) = [Year] AND MONTH([RequestDate]) = [Month]
	LEFT JOIN
		[dbo].[IT Personnel]
	ON
		[IT Requests].[ITPersonAssignedID] = [IT Personnel].ITPersonID#
	WHERE
		[Status] = 'Complete'
	GROUP BY
		[Year]
		, [Month]
		, [DateFmt]
		, [Row#]

UNION ALL

	SELECT
		0 AS [CountOf Requests]
		, 0 AS [CountOf Queued]
		, 0 AS [CountOf In Progress]
		, 0 AS [CountOf Complete]
		, COUNT([ITRequestID#]) AS [CountOf Incomplete]
		, 0 AS [CountOf Declined]
		, [Year]
		, [Month]
		, [DateFmt] 
		, [Row#]
	FROM (
		SELECT
		ROW_NUMBER() OVER(
				ORDER BY
					[B].SeqNo,
					[Month]
		) AS [Row#]
		, [Month]
		,[B].SeqNo AS [Year]
		,DATENAME(MONTH, DateAdd( month , [Month] , 0 ) - 1 ) + ' ' + CAST([B].[SeqNo] AS NVARCHAR(4)) AS [DateFmt]
		FROM (
			SELECT TOP 12
				[SequenceNumbers].[SeqNo] AS [Month]
			FROM
				[SequenceNumbers]
			) AS [A]
			CROSS JOIN (
				SELECT TOP 250
					[SeqNo]
				FROM
					[BWSdb].[dbo].[SequenceNumbers]
				WHERE
					[SeqNo] >= YEAR(DATEADD(MONTH, -1, (SELECT MIN([RequestDate]) AS [sd] FROM [dbo].[IT Requests])))
			) AS [B]
		WHERE
			2020 <= [B].[SeqNo] AND [B].[SeqNo] <= 2250
			AND (100 * YEAR(DATEADD(MONTH, -1, (SELECT MIN([RequestDate]) AS [sd] FROM [dbo].[IT Requests])))) + MONTH(DATEADD(MONTH, -1, (SELECT MIN([RequestDate]) AS [sd] FROM [dbo].[IT Requests]))) <= (100 * [B].[SeqNo]) + [Month] AND (100 * [B].[SeqNo]) + [Month] <= (100 * YEAR(DATEADD(MONTH, 1, (SELECT MAX([RequestDate]) AS [sd] FROM [dbo].[IT Requests])))) + MONTH(DATEADD(MONTH, 1, (SELECT MAX([RequestDate]) AS [sd] FROM [dbo].[IT Requests])))
	) AS [Calendar]
	LEFT JOIN
		[dbo].[IT Requests]
	ON
		YEAR([RequestDate]) = [Year] AND MONTH([RequestDate]) = [Month]
	LEFT JOIN
		[dbo].[IT Personnel]
	ON
		[IT Requests].[ITPersonAssignedID] = [IT Personnel].ITPersonID#
	WHERE
		[Status] = 'Incomplete'
	GROUP BY
		[Year]
		, [Month]
		, [DateFmt]
		, [Row#]

UNION ALL

	SELECT
		0 AS [CountOf Requests]
		, 0 AS [CountOf Queued]
		, 0 AS [CountOf In Progress]
		, 0 AS [CountOf Complete]
		, 0 AS [CountOf Incomplete]
		, COUNT([ITRequestID#]) AS [CountOf Declined]
		, [Year]
		, [Month]
		, [DateFmt] 
		, [Row#]
	FROM (
		SELECT
		ROW_NUMBER() OVER(
				ORDER BY
					[B].SeqNo,
					[Month]
		) AS [Row#]
		, [Month]
		,[B].SeqNo AS [Year]
		,DATENAME(MONTH, DateAdd( month , [Month] , 0 ) - 1 ) + ' ' + CAST([B].[SeqNo] AS NVARCHAR(4)) AS [DateFmt]
		FROM (
			SELECT TOP 12
				[SequenceNumbers].[SeqNo] AS [Month]
			FROM
				[SequenceNumbers]
			) AS [A]
			CROSS JOIN (
				SELECT TOP 250
					[SeqNo]
				FROM
					[BWSdb].[dbo].[SequenceNumbers]
				WHERE
					[SeqNo] >= YEAR(DATEADD(MONTH, -1, (SELECT MIN([RequestDate]) AS [sd] FROM [dbo].[IT Requests])))
			) AS [B]
		WHERE
			2020 <= [B].[SeqNo] AND [B].[SeqNo] <= 2250
			AND (100 * YEAR(DATEADD(MONTH, -1, (SELECT MIN([RequestDate]) AS [sd] FROM [dbo].[IT Requests])))) + MONTH(DATEADD(MONTH, -1, (SELECT MIN([RequestDate]) AS [sd] FROM [dbo].[IT Requests]))) <= (100 * [B].[SeqNo]) + [Month] AND (100 * [B].[SeqNo]) + [Month] <= (100 * YEAR(DATEADD(MONTH, 1, (SELECT MAX([RequestDate]) AS [sd] FROM [dbo].[IT Requests])))) + MONTH(DATEADD(MONTH, 1, (SELECT MAX([RequestDate]) AS [sd] FROM [dbo].[IT Requests])))
	) AS [Calendar]
	LEFT JOIN
		[dbo].[IT Requests]
	ON
		YEAR([RequestDate]) = [Year] AND MONTH([RequestDate]) = [Month]
	LEFT JOIN
		[dbo].[IT Personnel]
	ON
		[IT Requests].[ITPersonAssignedID] = [IT Personnel].ITPersonID#
	WHERE
		[Status] = 'Declined'
	GROUP BY
		[Year]
		, [Month]
		, [DateFmt]
		, [Row#]
) AS [Src]
GROUP BY
	[Year]
	, [Month]
	, [DateFmt]
	, [Row#]