-- top 3 request types and sub types for each department

DECLARE @ttl_hours_act AS FLOAT;
DECLARE @ttl_hours_bud AS FLOAT;
DECLARE @ttl_requests AS INTEGER;
DECLARE @ttl_requests_serviced AS INTEGER;

SELECT @ttl_requests = COUNT(*), @ttl_hours_act = SUM([LabourActual]), @ttl_hours_bud = SUM([LabourEstimate]), @ttl_requests_serviced = SUM(CASE WHEN [OpenCounter] IS NULL THEN 0 WHEN [OpenCounter] > 0 THEN 1 ELSE 0 END) FROM [IT Requests];

SELECT
	MIN([Dept].[DeptID]) AS [ID]
	, [Dept].[Dept]
	, [RequestType]
	, [RequestSubType]
	, COUNT(*) AS [# Reqs]
	, CAST(ROUND(100 * ((COUNT(*) + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
	, CAST(ROUND(100 * ((COUNT(*) + 0.0) / @ttl_requests_serviced), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs Ser]
	, ROUND(SUM(ISNULL([LabourActual], 0)), 2) AS [Act]
	, ROUND(SUM(ISNULL([LabourEstimate], 0)), 2) AS [Bud]
	, ROUND(SUM(ISNULL([LabourActual], 0)) / (CASE WHEN ISNULL(COUNT(*), 1) = 0 THEN 1 ELSE ISNULL(COUNT(*), 1) END), 2) AS [Act / Req]
	, ROUND(SUM(ISNULL([LabourEstimate], 0)) / (CASE WHEN ISNULL(COUNT(*), 1) = 0 THEN 1 ELSE ISNULL(COUNT(*), 1) END), 2) AS [Bud / Req]
	, ROUND(100 * SUM(ISNULL([LabourActual], 0)) / (CASE WHEN SUM(ISNULL([LabourEstimate], 1)) = 0 THEN 1 ELSE SUM(ISNULL([LabourEstimate], 1)) END), 2) AS [% Bud]
	, ROUND(100 * SUM(ISNULL([LabourActual], 0)) / ISNULL(@ttl_hours_act, 1), 2) AS [% Act vs Ttl Act]
	, ROUND(100 * SUM(ISNULL([LabourEstimate], 0)) / ISNULL(@ttl_hours_bud, 1), 2) AS [% Bud vs Ttl Bud]
	, ROUND(100 * SUM(ISNULL([LabourActual], 0)) / ISNULL(@ttl_hours_bud, 1), 2) AS [% Act vs Ttl Bud]
	, ROUND(100 * SUM(ISNULL([LabourEstimate], 0)) / ISNULL(@ttl_hours_act, 1), 2) AS [% Bud vs Ttl Act]
	, @ttl_requests AS [Total Requests]
	, @ttl_requests_serviced AS [Total Requests Serviced]
	, ROUND(@ttl_hours_act, 2) AS [Total Actual]
	, ROUND(@ttl_hours_bud, 2) AS [Total Budget]
	, SUM((CASE WHEN [IsOpened] = 1 THEN 1 ELSE 0 END)) AS [# Open]
	, MAX([LastStatusUpdate]) AS [LastUpdated]
	--, ROUND(MAX(ISNULL([LabourActual], 0)), 2) AS [WorstAct]
	--, ROUND((CASE WHEN MAX(ISNULL([LabourEstimate], 1)) = 0 THEN 1 ELSE MAX(ISNULL([LabourEstimate], 1)) END), 2) AS [WorstBud]
	--, ROUND(100 * MAX(ISNULL([LabourActual], 0)) / (CASE WHEN MAX(ISNULL([LabourEstimate], 1)) = 0 THEN 1 ELSE MAX(ISNULL([LabourEstimate], 1)) END), 2) AS [WorstActToBud]
	, ROUND(100 * MAX(ISNULL([LabourActual], 0) / (CASE WHEN (ISNULL([LabourEstimate], 1)) = 0 THEN 1 ELSE (ISNULL([LabourEstimate], 1)) END)), 2) AS [WorstActToBud]

FROM 
	[IT Requests] 
LEFT JOIN
	[ITR Software]
ON
	[ITR Software].[Software] = [IT Requests].[RequestSubType]
	AND [IT Requests].[RequestType] = 'Software'
LEFT JOIN
	[ITR Hardware]
ON
	[ITR Hardware].[Hardware] = [IT Requests].[RequestSubType]
	AND [IT Requests].[RequestType] = 'Hardware'
LEFT JOIN
	[ITR Training]
ON
	[ITR Training].[Training] = [IT Requests].[RequestSubType]
	AND [IT Requests].[RequestType] = 'Training'
LEFT JOIN
	[Dept]
ON
	[IT Requests].[Department] = [Dept].[DeptID]
GROUP BY
	[Dept].[Dept]
	, [IT Requests].[RequestType]
	, [IT Requests].[RequestSubType]
ORDER BY
	[# Reqs] DESC