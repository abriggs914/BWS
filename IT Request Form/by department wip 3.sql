-- Most frequent Dept, Request Tyoe, Request SubType, and the number of requests.
-- NOT ANYMORE!!

SELECT
	[Dept]
	, [RequestType]
	, [RequestSubType]
	, COUNT([RequestSubType]) AS [C]
	, SUM([LabourActual]) AS [Ttl Act]
	, SUM([LabourEstimate]) AS [Ttl Est]
	, SUM([LabourActual]) / NULLIF(COUNT([RequestSubType]), 0) AS [Act / Req]
	, SUM([LabourEstimate]) / NULLIF(COUNT([RequestSubType]), 0) AS [Est / Req]
FROM 
	[IT Requests] 
LEFT JOIN
	[Dept]
ON
	[IT Requests].[Department] = [Dept].[DeptID]
GROUP BY
	[Dept].[Dept]
	, [RequestSubType]
	, [RequestType]
HAVING
	COUNT(*) < (
		SELECT
			MAX([C])
		FROM (
			SELECT
				[Dept]
				, [RequestType]
				, [RequestSubType]
				, COUNT([RequestSubType]) AS [C]
			FROM 
				[IT Requests] 
			LEFT JOIN
				[Dept]
			ON
				[IT Requests].[Department] = [Dept].[DeptID]
			GROUP BY
				[Dept].[Dept]
				, [RequestSubType]
				, [RequestType]
			) AS [A]
		)
--ORDER BY
--	COUNT([RequestSubType]) DESC