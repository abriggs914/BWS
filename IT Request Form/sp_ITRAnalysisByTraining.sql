
CREATE PROCEDURE [dbo].[sp_ITRAnalysisByTraining]
AS
BEGIN

	DECLARE @ttl_hours_act AS FLOAT;
	DECLARE @ttl_hours_bud AS FLOAT;
	DECLARE @ttl_requests AS INTEGER;

	SELECT @ttl_requests = COUNT(*), @ttl_hours_act = SUM([LabourActual]), @ttl_hours_bud = SUM([LabourEstimate]) FROM [IT Requests];

	SELECT
		[RequestType]
		, [RequestSubType]
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
	INNER JOIN
		[ITR Hardware]
	ON
		[IT Requests].[RequestSubType] = [ITR Hardware].[Hardware]
	WHERE
		[RequestType] = 'Hardware'
	GROUP BY
		[RequestType]
		, [RequestSubType]

END