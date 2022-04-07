USE BWSdb
GO

--DECLARE @depts AS NVARCHAR(MAX);
----SELECT @depts = COALESCE(@depts + ';', '') + [B].[Dept] FROM (SELECT DISTINCT [Dept] FROM (SELECT [Dept].[Dept] FROM [Dept] INNER JOIN [IT Requests] ON [Dept].[DeptID] = [IT Requests].[Department]) AS [A]) AS [B]
--SELECT @depts = COALESCE(@depts + ';', '') + [A].[Dept] FROM (SELECT DISTINCT [Dept] FROM [Dept]) AS [A]

--SELECT @depts AS [D]
--SELECT [splited_data] FROM [BWSdb].[dbo].[split_string_idx](@depts, ';')

ALTER VIEW [dbo].[v_ITRRequestsByDeptByMonth] AS
SELECT * FROM (
	SELECT
		[Row#]
		,[Month]
		,[Year]
		,[DateFmt]
		,COUNT(*) AS [TotalRequests]
		,REPLACE([Dept].Dept, '.', '') AS [Dept]
	FROM (
		SELECT
			ROW_NUMBER() OVER(
				ORDER BY
					[B].[SeqNo]
					,[Month]
			) AS [Row#]
			,[Month]
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
	) AS [DateSrc]
	LEFT JOIN
		[IT Requests]
	ON
		MONTH([RequestDate]) = [DateSrc].[Month]
		AND YEAR([RequestDate]) = [DateSrc].[Year]
	LEFT JOIN
		[Dept]
	ON
		[IT Requests].[Department] = [Dept].[DeptID]
	GROUP BY 
		[Row#]
		,[Dept].[Dept]
		,[Month]
		,[Year]
		,[DateFmt]
) AS [SrcTable]
PIVOT (
	SUM([TotalRequests])
	FOR
		[Dept]
	-- calculated usind @depts above and:
	-- str(tuple(['[' + d + ']' for d in x.split('\n')])).replace('\'', '').replace('.'. '')
	-- where x = text output of:
	-- SELECT @depts = COALESCE(@depts + ';', '') + [A].[Dept] FROM (SELECT DISTINCT [Dept] FROM [Dept]) AS [A]
	-- SELECT [splited_data] FROM [BWSdb].[dbo].[split_string_idx](@depts, ';')
	IN (
		[Administration], [Aluminum], [Assembly], [Axle], [Bill Of Materials], [Engineering], [Finish - Assembly], [Finish - Blast], [Finish - Paint], [HR], [Human Resources], [IT], [Machine Shop], [Maintenance], [Non Productive], [Parts Dept], [Production], [Purchasing], [Quality Control], [Sales], [Scheduling], [Screener - Assembly], [Special Project], [Special Projects], [Sub Beams], [Sub GNK], [Sub Parts], [Warranty], [WIP - Work In Progress]
	)
) AS [PivotTable]
--ORDER BY
	--[Year] * 100 + [Month],
	--COUNT(*) DESC