USE BWSdb
GO


SELECT * FROM [IT Requests]

-- total of all requests
-- total of each status

SELECT
	[Status],
	SUM([Count]) AS [Count]
FROM (
	SELECT
		[Status], COUNT([Status]) AS [Count]
	FROM
		[IT Requests]
	GROUP BY
		[Status]
	UNION
		(
			SELECT
				'Queued' AS [Status],
				0 AS [Count]
		)
	UNION
		(
			SELECT
				'In Progress' AS [Status],
				0 AS [Count]
		)
	UNION
		(
			SELECT
				'Declined' AS [Status],
				0 AS [Count]
		)
	UNION
		(
			SELECT
				'Complete' AS [Status],
				0 AS [Count]
		)
	UNION
		(
			SELECT
				'Incomplete' AS [Status],
				0 AS [Count]
		)
) AS [Src]
GROUP BY
	[Status]
ORDER BY
	[Status]

-- do the above again but grouped by IT person.
-- This will help to identify who is over-assigned / who has space

SELECT
	(CASE WHEN [ITPersonAssignedID] < 2 OR [ITPersonAssignedID] IS NULL THEN 1 ELSE [ITPersonAssignedID] END) AS [ITStaffID],
	[Status],
	SUM([Count]) AS [Count]
FROM (
	SELECT
		[ITPersonAssignedID], [Status], COUNT([Status]) AS [Count]
	FROM
		[IT Requests]
	GROUP BY
		[ITPersonAssignedID], [Status]
	UNION
		(
			SELECT
				NULL AS [ITID#],
				'Queued' AS [Status],
				0 AS [Count]
		)
	UNION
		(
			SELECT
				NULL AS [ITID#],
				'In Progress' AS [Status],
				0 AS [Count]
		)
	UNION
		(
			SELECT
				NULL AS [ITID#],
				'Declined' AS [Status],
				0 AS [Count]
		)
	UNION
		(
			SELECT
				NULL AS [ITID#],
				'Complete' AS [Status],
				0 AS [Count]
		)
	UNION
		(
			SELECT
				NULL AS [ITID#],
				'Incomplete' AS [Status],
				0 AS [Count]
		)
) AS [Src]
GROUP BY
	(CASE WHEN [ITPersonAssignedID] < 2 OR [ITPersonAssignedID] IS NULL THEN 1 ELSE [ITPersonAssignedID] END), [Status]
ORDER BY
	[ITStaffID], [Status]