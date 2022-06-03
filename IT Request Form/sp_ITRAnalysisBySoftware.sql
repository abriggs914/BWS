
ALTER PROCEDURE [dbo].[sp_ITRAnalysisBySoftware]
AS
BEGIN

	DECLARE @ttl_hours_act AS FLOAT;
	DECLARE @ttl_hours_bud AS FLOAT;
	DECLARE @ttl_requests AS INTEGER;

	SELECT @ttl_requests = COUNT(*), @ttl_hours_act = SUM([LabourActual]), @ttl_hours_bud = SUM([LabourEstimate]) FROM [IT Requests];

	SELECT
		[RequestSubType]
		, COUNT(*) AS [# Reqs]
		, CAST(ROUND(100 * ((COUNT(*) + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
		, ROUND(SUM(ISNULL([LabourActual], 0)), 2) AS [Act]
		, ROUND(SUM(ISNULL([LabourEstimate], 0)), 2) AS [Bud]
		, ROUND(SUM(ISNULL([LabourActual], 0)) / COUNT(*), 2) AS [Act / Req]
		, ROUND(SUM(ISNULL([LabourEstimate], 0)) / COUNT(*), 2) AS [Bud / Req]
		, ROUND(SUM(ISNULL([LabourActual], 0)) / @ttl_requests, 2) AS [Act / Req (Ttl)]
		, ROUND(SUM(ISNULL([LabourEstimate], 0)) / @ttl_requests, 2) AS [Bud / Req (Ttl)]
		, ROUND(100 * (SUM(ISNULL([LabourActual], 0)) / SUM(ISNULL([LabourEstimate], 0))), 2) AS [% Bud]
		, ROUND(100 * (SUM(ISNULL([LabourActual], 0)) / ISNULL(@ttl_hours_act, 0)), 2) AS [% Act vs Ttl Act]
		, ROUND(100 * (SUM(ISNULL([LabourEstimate], 0)) / ISNULL(@ttl_hours_bud, 0)), 2) AS [% Bud vs Ttl Bud]
		, ROUND(100 * (SUM(ISNULL([LabourActual], 0)) / ISNULL(@ttl_hours_bud, 0)), 2) AS [% Act vs Ttl Bud]
		, ROUND(100 * (SUM(ISNULL([LabourEstimate], 0)) / ISNULL(@ttl_hours_act, 0)), 2) AS [% Bud vs Ttl Act]
		, @ttl_requests AS [Total Reqs]
		, ROUND(@ttl_hours_act, 2) AS [Total Act]
		, ROUND(@ttl_hours_bud, 2) AS [Total Bud]
	FROM
		[IT Requests]
	INNER JOIN
		[ITR Software]
	ON
		[IT Requests].[RequestSubType] = [ITR Software].[Software]
	WHERE
		[RequestType] = 'Software'
	GROUP BY
		[RequestSubType]

END