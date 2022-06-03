USE BWSdb
GO

--SELECT
--	SUM([Hardware]) AS [Hardware]
--	, SUM([Software]) AS [Software]
--	, SUM([Training]) AS [Training]
--	, [RequestType]
--FROM (
--	SELECT
--		COUNT(*) AS [Hardware]
--		, 0 AS [Software]
--		, 0 AS [Training]
--		, 'Hardware' AS [RequestType]
--	FROM
--		[IT Requests]
--	WHERE
--		[RequestType] = 'Hardware'
--	--GROUP BY
--	--	[IT Requests].[RequestType]
	
--	UNION ALL

--	SELECT
--		0 AS [Hardware]
--		, COUNT(*) AS [Software]
--		, 0 AS [Training]
--		, 'Software' AS [RequestType]
--	FROM
--		[IT Requests]
--	WHERE
--		[RequestType] = 'Software'
--	--GROUP BY
--	--	[IT Requests].[RequestType]

--	UNION ALL

--	SELECT
--		0 AS [Hardware]
--		, 0 AS [Software]
--		, COUNT(*) AS [Training]
--		, 'Training' AS [RequestType]
--	FROM
--		[IT Requests]
--	WHERE
--		[RequestType] = 'Training'
--	--GROUP BY
--	--	[IT Requests].[RequestType]
--) AS [Src]
--GROUP BY
--	[RequestType]

DECLARE @ttl_hours_act AS FLOAT;
DECLARE @ttl_hours_bud AS FLOAT;
DECLARE @ttl_requests AS INTEGER;

SELECT @ttl_requests = COUNT(*), @ttl_hours_act = SUM([LabourActual]), @ttl_hours_bud = SUM([LabourEstimate]) FROM [IT Requests];

SELECT
	[Name]
	, COUNT(*) AS [# Requests]
	, CAST(ROUND(100 * ((COUNT(*) + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Requests]
	, ROUND(SUM(ISNULL([LabourActual], 0)), 2) AS [Actual]
	, ROUND(SUM(ISNULL([LabourEstimate], 0)), 2) AS [Budgeted]
	, ROUND(SUM(ISNULL([LabourActual], 0)) / COUNT(*), 2) AS [Actual / Request]
	, ROUND(SUM(ISNULL([LabourEstimate], 0)) / COUNT(*), 2) AS [Budget / Request]
	, ROUND(SUM(ISNULL([LabourActual], 0)) / @ttl_requests, 2) AS [Actual / Request (Ttl)]
	, ROUND(SUM(ISNULL([LabourEstimate], 0)) / @ttl_requests, 2) AS [Budget / Request (Ttl)]
	, ROUND(100 * (SUM(ISNULL([LabourActual], 0)) / SUM(ISNULL([LabourEstimate], 0))), 2) AS [% Budget]
	, ROUND(100 * (SUM(ISNULL([LabourActual], 0)) / ISNULL(@ttl_hours_act, 0)), 2) AS [% Actual vs Ttl Actual]
	, ROUND(100 * (SUM(ISNULL([LabourEstimate], 0)) / ISNULL(@ttl_hours_bud, 0)), 2) AS [% Budget vs Ttl Budget]
	, ROUND(100 * (SUM(ISNULL([LabourActual], 0)) / ISNULL(@ttl_hours_bud, 0)), 2) AS [% Actual vs Ttl Budget]
	, ROUND(100 * (SUM(ISNULL([LabourEstimate], 0)) / ISNULL(@ttl_hours_act, 0)), 2) AS [% Budget vs Ttl Actual]
	, @ttl_requests AS [Total Requests]
	, ROUND(@ttl_hours_act, 2) AS [Total Actual]
	, ROUND(@ttl_hours_bud, 2) AS [Total Budget]
FROM
	[IT Requests]
LEFT JOIN
	[IT Personnel]
ON
	[IT Requests].ITPersonAssignedID = [IT Personnel].[ITPersonID#]
GROUP BY
	[Name]

SELECT
	COUNT(*) AS [Count]
	, [Name]
FROM
	[IT Requests]
LEFT JOIN
	[IT Personnel]
ON
	[IT Requests].ITPersonAssignedID = [IT Personnel].[ITPersonID#]
GROUP BY
	[Name]