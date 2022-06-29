

SELECT 
	--[Status]
	YEAR([RequestDate]) AS [Year]
	, MONTH([RequestDate]) AS [Month]
	, COUNT(*) AS [Ttl Requests]
	, SUM(CASE WHEN [Status] IN ('Complete', 'Incomplete', 'Declined') THEN 1 ELSE 0 END) AS [Completed Requests]
	, SUM(CASE WHEN [Status] IN ('Complete', 'Incomplete', 'Declined') THEN 0 ELSE 1 END) AS [Left Open Requests]
	--, SUM(CASE WHEN [Status] IN ('Complete', 'Incomplete', 'Declined') THEN 0 ELSE 1 END) OVER (
	--	PARTITION BY YEAR([RequestDate]), MONTH([RequestDate])
	--	--ORDER BY YEAR([RequestDate]), MONTH([RequestDate])
	--	--ROWS UNBOUNDED PRECEDING
	--) AS [RunningSum]
FROM 
	[IT Requests]
GROUP BY
	YEAR([RequestDate])
	, MONTH([RequestDate])
	--, [Status]
ORDER BY
	[Year]
	, [Month]

--------------------------------------------------------------------------------------

SELECT 
	--[Status]
	YEAR([RequestDate]) AS [Year]
	, MONTH([RequestDate]) AS [Month]
	, COUNT(*) AS [Ttl Requests]
	, SUM(CASE WHEN [Status] IN ('Complete', 'Incomplete', 'Declined') THEN 1 ELSE 0 END) AS [Completed Requests]
	, SUM(CASE WHEN [Status] IN ('Complete', 'Incomplete', 'Declined') THEN 0 ELSE 1 END) AS [Left Open Requests]
	, (
		SELECT 
			SUM(CASE WHEN [Status] IN ('Complete', 'Incomplete', 'Declined') THEN 0 ELSE 1 END) AS [Left Open Requests]
		FROM
			[IT Requests] AS [B]
		WHERE
			YEAR([B].[RequestDate]) <= YEAR([A].[RequestDate])
			AND MONTH([B].[RequestDate]) <= MONTH([A].[RequestDate])
	) AS [Running Total]
FROM 
	[IT Requests] AS [A]
GROUP BY
	YEAR([RequestDate])
	, MONTH([RequestDate])
	--, [Status]
ORDER BY
	[Year]
	, [Month]