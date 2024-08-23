USE [BWSdb]
GO

/****** Object:  View [dbo].[v_ITRequestsPerMonthTotals]    Script Date: 2024-08-23 3:06:45 PM ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





ALTER VIEW [dbo].[v_ITRequestsPerMonthTotals] AS

	
	WITH MonthlyStatusCounts AS (
		SELECT
			YEAR([RequestDate]) AS [Year],
			MONTH([RequestDate]) AS [Month],
			SUM(CASE WHEN [Status] IN ('Complete', 'Incomplete', 'Declined') THEN 1 ELSE 0 END) AS [CountOfLeftOpen],
			SUM(CASE WHEN [Status] NOT IN ('Complete', 'Incomplete', 'Declined') THEN 1 ELSE 0 END) AS [CountOpen]
		FROM
			[IT Requests]
		WHERE
			[Status] IS NOT NULL
		GROUP BY
			YEAR([RequestDate]),
			MONTH([RequestDate])
	)
	SELECT
		MSC1.[Year],
		MSC1.[Month],
		MSC1.[CountOfLeftOpen],
		MSC1.[CountOpen],
		(
			SELECT SUM(MSC2.[CountOfLeftOpen])
			FROM MonthlyStatusCounts MSC2
			WHERE
				MSC2.[Year] < MSC1.[Year]
				OR (MSC2.[Year] = MSC1.[Year] AND MSC2.[Month] <= MSC1.[Month])
		--) AS [TotalCountLeftOpen],
		) AS [Sum Left Open Requests],
		(
			SELECT SUM(MSC2.[CountOpen])
			FROM MonthlyStatusCounts MSC2
			WHERE
				MSC2.[Year] < MSC1.[Year]
				OR (MSC2.[Year] = MSC1.[Year] AND MSC2.[Month] <= MSC1.[Month])
		--) AS [TotalCountOpen]
		) AS [Sum Opened Requests]
		, DATENAME(MONTH, DATEADD(MONTH, [Month] , 0 ) - 1 ) + ' ' + CAST([Year] AS NVARCHAR(4)) AS [DateFmt]
	FROM
		MonthlyStatusCounts MSC1
	/*
	ORDER BY
		MSC1.[Year],
		MSC1.[Month]
	;
	*/


/*
SELECT
	[Row#]
	, [CountOf Requests]
	, [CountOf Queued]
	, [CountOf In Progress]
	, [CountOf Complete]
	, [CountOf Complete]
	, [CountOf Declined]
	, [CountOf Debugging]
	, [CountOf Waiting]
	, [CountOf LeftBehind]
	, [Sum Left Open Requests]
	, [Sum Opened Requests]

	, (SELECT SUM([Sum Left Open Requests]) FROM [Base] WHERE [Year] < [Year] AS [Total Sum Left Open Requests]
	, SUM([Sum Opened Requests]) AS [Total Sum Opened Requests]

	, [Year]
	, [Month]
	, [DateFmt]
FROM (

	SELECT
		[Row#]
		, SUM([CountOf Requests]) AS [CountOf Requests]
		, SUM([CountOf Queued]) AS [CountOf Queued]
		, SUM([CountOf In Progress]) AS [CountOf In Progress]
		, SUM([CountOf Complete]) AS [CountOf Complete]
		, SUM([CountOf Incomplete]) AS [CountOf Incomplete]
		, SUM([CountOf Declined]) AS [CountOf Declined]
		, SUM([CountOf Debugging]) AS [CountOf Debugging]
		, SUM([CountOf Waiting]) AS [CountOf Waiting]
		, SUM([CountOf LeftBehind]) AS [CountOf LeftBehind]
		, SUM([Sum Left Open Requests]) AS [Sum Left Open Requests]
		, SUM([Sum Opened Requests]) AS [Sum Opened Requests]
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
			, 0 AS [CountOf Debugging]
			, 0 AS [CountOf Waiting]
			, 0 AS [CountOf LeftBehind]
			, 0 AS [Sum Left Open Requests]
			, 0 AS [Sum Opened Requests]
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
			,DATENAME(MONTH, DATEADD(MONTH, [Month] , 0 ) - 1 ) + ' ' + CAST([B].[SeqNo] AS NVARCHAR(4)) AS [DateFmt]
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
			, 0 AS [CountOf Debugging]
			, 0 AS [CountOf Waiting]
			, 0 AS [CountOf LeftBehind]
			, 0 AS [Sum Left Open Requests]
			, 0 AS [Sum Opened Requests]
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
			,DATENAME(MONTH, DATEADD(MONTH, [Month] , 0 ) - 1 ) + ' ' + CAST([B].[SeqNo] AS NVARCHAR(4)) AS [DateFmt]
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
			, 0 AS [CountOf Debugging]
			, 0 AS [CountOf Waiting]
			, 0 AS [CountOf LeftBehind]
			, 0 AS [Sum Left Open Requests]
			, 0 AS [Sum Opened Requests]
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
			,DATENAME(MONTH, DATEADD(MONTH, [Month] , 0 ) - 1 ) + ' ' + CAST([B].[SeqNo] AS NVARCHAR(4)) AS [DateFmt]
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
			, 0 AS [CountOf Debugging]
			, 0 AS [CountOf Waiting]
			, 0 AS [CountOf LeftBehind]
			, 0 AS [Sum Left Open Requests]
			, 0 AS [Sum Opened Requests]
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
			,DATENAME(MONTH, DATEADD(MONTH, [Month] , 0 ) - 1 ) + ' ' + CAST([B].[SeqNo] AS NVARCHAR(4)) AS [DateFmt]
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
			, 0 AS [CountOf Debugging]
			, 0 AS [CountOf Waiting]
			, 0 AS [CountOf LeftBehind]
			, 0 AS [Sum Left Open Requests]
			, 0 AS [Sum Opened Requests]
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
			,DATENAME(MONTH, DATEADD(MONTH, [Month] , 0 ) - 1 ) + ' ' + CAST([B].[SeqNo] AS NVARCHAR(4)) AS [DateFmt]
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
			, 0 AS [CountOf Debugging]
			, 0 AS [CountOf Waiting]
			, 0 AS [CountOf LeftBehind]
			, 0 AS [Sum Left Open Requests]
			, 0 AS [Sum Opened Requests]
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
			,DATENAME(MONTH, DATEADD(MONTH, [Month] , 0 ) - 1 ) + ' ' + CAST([B].[SeqNo] AS NVARCHAR(4)) AS [DateFmt]
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
	--GROUP BY
	--	[Year]
	--	, [Month]
	--	, [DateFmt]
	--	, [Row#]
	
	UNION ALL
		SELECT
			0 AS [CountOf Requests]
			, 0 AS [CountOf Queued]
			, 0 AS [CountOf In Progress]
			, 0 AS [CountOf Complete]
			, 0 AS [CountOf Incomplete]
			, 0 AS [CountOf Declined]
			, COUNT([ITRequestID#]) AS [CountOf Debugging]
			, 0 AS [CountOf Waiting]
			, 0 AS [CountOf LeftBehind]
			, 0 AS [Sum Left Open Requests]
			, 0 AS [Sum Opened Requests]
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
			,DATENAME(MONTH, DATEADD(MONTH, [Month] , 0 ) - 1 ) + ' ' + CAST([B].[SeqNo] AS NVARCHAR(4)) AS [DateFmt]
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
			[Status] = 'Debugging'
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
			, 0 AS [CountOf Declined]
			, 0 AS [CountOf Debugging]
			, COUNT([ITRequestID#]) AS [CountOf Waiting]
			, 0 AS [CountOf LeftBehind]
			, 0 AS [Sum Left Open Requests]
			, 0 AS [Sum Opened Requests]
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
			,DATENAME(MONTH, DATEADD(MONTH, [Month] , 0 ) - 1 ) + ' ' + CAST([B].[SeqNo] AS NVARCHAR(4)) AS [DateFmt]
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
			[Status] = 'Waiting'
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
			, 0 AS [CountOf Declined]
			, 0 AS [CountOf Debugging]
			, 0 AS [CountOf Waiting]
			, COUNT([ITRequestID#]) AS [CountOf LeftBehind]
			, 0 AS [Sum Left Open Requests]
			, 0 AS [Sum Opened Requests]
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
			,DATENAME(MONTH, DATEADD(MONTH, [Month] , 0 ) - 1 ) + ' ' + CAST([B].[SeqNo] AS NVARCHAR(4)) AS [DateFmt]
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
			[Status] NOT IN ('Complete', 'Incomplete', 'Declined')
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
			, 0 AS [CountOf Declined]
			, 0 AS [CountOf Debugging]
			, 0 AS [CountOf Waiting]
			, 0 AS [CountOf LeftBehind]
			, (
			SELECT 
				SUM(CASE WHEN [Status] IN ('Complete', 'Incomplete', 'Declined') THEN 0 ELSE 1 END) AS [Sum Left Open Requests]
			FROM
				[IT Requests] AS [B2]
			WHERE
				YEAR([B2].[RequestDate]) <= [Year] --YEAR([A].[RequestDate])
				AND MONTH([B2].[RequestDate]) <= [Month] -- MONTH([A].[RequestDate])
		) AS [Sum Left Open Requests]
			, 0 AS [Sum Opened Requests]
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
			,DATENAME(MONTH, DATEADD(MONTH, [Month] , 0 ) - 1 ) + ' ' + CAST([B].[SeqNo] AS NVARCHAR(4)) AS [DateFmt]
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
			[dbo].[IT Requests] AS [A]
		ON
			YEAR([RequestDate]) = [Year] AND MONTH([RequestDate]) = [Month]
		LEFT JOIN
			[dbo].[IT Personnel]
		ON
			[A].[ITPersonAssignedID] = [IT Personnel].ITPersonID#
		WHERE
			[Status] NOT IN ('Complete', 'Incomplete', 'Declined')
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
			, 0 AS [CountOf Declined]
			, 0 AS [CountOf Debugging]
			, 0 AS [CountOf Waiting]
			, 0 AS [CountOf LeftBehind]
			, 0 AS [Sum Left Open Requests]
			, (
			SELECT 
				COUNT(*) AS [Sum Left Open Requests]
			FROM
				[IT Requests] AS [B2]
			WHERE
				YEAR([B2].[RequestDate]) <= [Year] --YEAR([A].[RequestDate])
				AND MONTH([B2].[RequestDate]) <= [Month] -- MONTH([A].[RequestDate])
		) AS [Sum Opened Requests]
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
			,DATENAME(MONTH, DATEADD(MONTH, [Month] , 0 ) - 1 ) + ' ' + CAST([B].[SeqNo] AS NVARCHAR(4)) AS [DateFmt]
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
				AND ([B].[SeqNo] * 100) + [Month] <= (YEAR(GETDATE()) * 100) + MONTH(GETDATE())
		) AS [Calendar]
		LEFT JOIN
			[dbo].[IT Requests] AS [A]
		ON
			YEAR([RequestDate]) = [Year] AND MONTH([RequestDate]) = [Month]
		LEFT JOIN
			[dbo].[IT Personnel]
		ON
			[A].[ITPersonAssignedID] = [IT Personnel].ITPersonID#
		GROUP BY
			[Year]
			, [Month]
			, [DateFmt]
			, [Row#]


		--UNION ALL
		--SELECT 
		--0, 0, 0, 0, 0, 0, 0, 0, 0, 
		--(
		--	SELECT 
		--		SUM(CASE WHEN [Status] IN ('Complete', 'Incomplete', 'Declined') THEN 0 ELSE 1 END) AS [Sum Left Open Requests]
		--	FROM
		--		[IT Requests] AS [B]
		--	WHERE
		--		YEAR([B].[RequestDate]) <= YEAR([A].[RequestDate])
		--		AND MONTH([B].[RequestDate]) <= MONTH([A].[RequestDate])
		--) AS [Running Total]
		--, YEAR([RequestDate]) AS [Year]
		--, YEAR([RequestDate]) AS [Month]
		--, DATENAME(MONTH, DATEADD(MONTH, MONTH([RequestDate]) , 0 ) - 1 ) + ' ' + CAST(YEAR([RequestDate]) AS NVARCHAR(4)) AS [DateFmt] 
		--, 0 AS [Row#]
		--FROM
		--	[IT Requests] AS [A]
		--GROUP BY
		--	YEAR([RequestDate])
		--	, MONTH([RequestDate])


	) AS [Src]
	GROUP BY
		[Year]
		, [Month]
		, [DateFmt]
		, [Row#]
) AS [Base]
GROUP BY

	[Row#]
	, [CountOf Requests]
	, [CountOf Queued]
	, [CountOf In Progress]
	, [CountOf Complete]
	, [CountOf Complete]
	, [CountOf Declined]
	, [CountOf Debugging]
	, [CountOf Waiting]
	, [CountOf LeftBehind]
	, [Sum Left Open Requests]
	, [Sum Opened Requests]
	, [Year]
	, [Month]
	, [DateFmt]
ORDER BY
	[Year]
	,[Month]
*/
GO


