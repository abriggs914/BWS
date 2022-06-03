USE BWSdb
GO

ALTER PROCEDURE [dbo].[sp_ITRAnalysisByDepartment]
AS
BEGIN

	DECLARE @ttl_hours_act AS FLOAT;
	DECLARE @ttl_hours_bud AS FLOAT;
	DECLARE @ttl_requests AS INTEGER;

	SELECT @ttl_requests = COUNT(*), @ttl_hours_act = SUM([LabourActual]), @ttl_hours_bud = SUM([LabourEstimate]) FROM [IT Requests];

	SELECT
		MIN([Dept].[DeptID]) AS [ID]
		, [Dept].[Dept]
		, COUNT(*) AS [# Reqs]
		, CAST(ROUND(100 * ((COUNT(*) + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
		, ROUND(SUM(ISNULL([LabourActual], 0)), 2) AS [Act]
		, ROUND(SUM(ISNULL([LabourEstimate], 0)), 2) AS [Bud]
		, ROUND(SUM(ISNULL([LabourActual], 0)) / COUNT(*), 2) AS [Act / Req]
		, ROUND(SUM(ISNULL([LabourEstimate], 0)) / COUNT(*), 2) AS [Bud / Req]
		, ROUND(100 * SUM(ISNULL([LabourActual], 0)) / SUM(ISNULL([LabourEstimate], 0)), 2) AS [% Bud]
		, ROUND(100 * SUM(ISNULL([LabourActual], 0)) / ISNULL(@ttl_hours_act, 0), 2) AS [% Act vs Ttl Act]
		, ROUND(100 * SUM(ISNULL([LabourEstimate], 0)) / ISNULL(@ttl_hours_bud, 0), 2) AS [% Bud vs Ttl Bud]
		, ROUND(100 * SUM(ISNULL([LabourActual], 0)) / ISNULL(@ttl_hours_bud, 0), 2) AS [% Act vs Ttl Bud]
		, ROUND(100 * SUM(ISNULL([LabourEstimate], 0)) / ISNULL(@ttl_hours_act, 0), 2) AS [% Bud vs Ttl Act]
		, @ttl_requests AS [Total Requests]
		, ROUND(@ttl_hours_act, 2) AS [Total Actual]
		, ROUND(@ttl_hours_bud, 2) AS [Total Budget]
	FROM 
		[IT Requests] 
	LEFT JOIN
		Dept
	ON
		[IT Requests].[Department] = Dept.[DeptID]
	GROUP BY
		[Dept].[Dept]
	ORDER BY
		[# Reqs] DESC
END



-- -- Top 5 highest issued requests
--SELECT TOP 5 * FROM [IT Requests] WHERE [LabourActual] IS NOT NULL ORDER BY [LabourActual] DESC

-- -- Bottom 5 highest budgeted requests
--SELECT TOP 5 * FROM [IT Requests] WHERE [LabourEstimate] IS NOT NULL ORDER BY [LabourEstimate]

-- -- Bottom 5 highest issued requests
--SELECT TOP 5 * FROM [IT Requests] WHERE [LabourActual] IS NOT NULL ORDER BY [LabourActual]


-- -- Top 5 most revisited requests
--SELECT TOP 5 * FROM [IT Requests] WHERE [OpenCounter] IS NOT NULL ORDER BY [OpenCounter] DESC