USE BWSdb
GO

SELECT
	SUM([Hardware]) AS [Hardware]
	, SUM([Software]) AS [Software]
	, SUM([Training]) AS [Training]
	, [RequestType]
FROM (
	SELECT
		COUNT(*) AS [Hardware]
		, 0 AS [Software]
		, 0 AS [Training]
		, 'Hardware' AS [RequestType]
	FROM
		[IT Requests]
	WHERE
		[RequestType] = 'Hardware'
	--GROUP BY
	--	[IT Requests].[RequestType]
	
	UNION ALL

	SELECT
		0 AS [Hardware]
		, COUNT(*) AS [Software]
		, 0 AS [Training]
		, 'Software' AS [RequestType]
	FROM
		[IT Requests]
	WHERE
		[RequestType] = 'Software'
	--GROUP BY
	--	[IT Requests].[RequestType]

	UNION ALL

	SELECT
		0 AS [Hardware]
		, 0 AS [Software]
		, COUNT(*) AS [Training]
		, 'Training' AS [RequestType]
	FROM
		[IT Requests]
	WHERE
		[RequestType] = 'Training'
	--GROUP BY
	--	[IT Requests].[RequestType]
) AS [Src]
GROUP BY
	[RequestType]

SELECT
	COUNT(*) AS [Count]
	, [RequestType]
FROM
	[IT Requests]
GROUP BY
	[RequestType]