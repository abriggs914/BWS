USE BWSdb
GO


DECLARE @sd AS DATETIME;
DECLARE @ed AS DATETIME;

SET @sd = '2021-11-20';
SET @ed = '2021-11-29';

-- Date constraints cover all requests that have ANY date column fall into the range.
-- [RequestDate]
-- [DueDate]
-- [StartDate]
-- [CompletionDate]
-- [LastStatusUpdate]

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
	WHERE
		[RequestDate] BETWEEN @sd AND @ed
		OR [DueDate] BETWEEN @sd AND @ed
		OR [StartDate] BETWEEN @sd AND @ed
		OR [CompletionDate] BETWEEN @sd AND @ed
		OR [LastStatusUpdate] BETWEEN @sd AND @ed
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
	WHERE
		[RequestDate] BETWEEN @sd AND @ed
		OR [DueDate] BETWEEN @sd AND @ed
		OR [StartDate] BETWEEN @sd AND @ed
		OR [CompletionDate] BETWEEN @sd AND @ed
		OR [LastStatusUpdate] BETWEEN @sd AND @ed
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


--------------------------------------------------------------------------------------------------------------------------------------

SELECT [ITPersonID#], [Name], SUM([Queued]) AS [Queued], SUM([In Progress]) AS [In Progress], SUM([Complete]) AS [Complete], SUM([InComplete]) AS [Incomplete], SUM([Declined]) AS [Declined]
FROM (
SELECT [ITStaffID], [Queued], [In Progress], [Complete], [InComplete], [Declined]
FROM (
SELECT
	(CASE WHEN [ITPersonAssignedID] < 2 OR [ITPersonAssignedID] IS NULL THEN 1 ELSE [ITPersonAssignedID] END) AS [ITStaffID],
	[Status],
	SUM([Count]) AS [Count]
FROM (
	SELECT
		[ITPersonAssignedID], [Status], COUNT([Status]) AS [Count]
	FROM
		[IT Requests]
	WHERE
		[RequestDate] BETWEEN @sd AND @ed
		OR [DueDate] BETWEEN @sd AND @ed
		OR [StartDate] BETWEEN @sd AND @ed
		OR [CompletionDate] BETWEEN @sd AND @ed
		OR [LastStatusUpdate] BETWEEN @sd AND @ed
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
) AS [PivotSrc]
PIVOT (
	SUM([Count]) FOR [Status] IN ([Queued], [In Progress], [Complete], [InComplete], [Declined])
) AS [PivotTbl]
UNION 
	SELECT [ITPersonID#], 0, 0, 0, 0, 0 FROM [IT Personnel]
) AS [SrcB]
INNER JOIN
	[IT Personnel]
ON
	[ITStaffID] = [ITPersonID#]
GROUP BY
	[ITPersonID#], [Name]
ORDER BY
	[ITPersonID#], [Name]

SELECT * FROM [IT Personnel]