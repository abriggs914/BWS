
-- Counts of requests by requester


SELECT [RequestedBy], COUNT(*) AS [C] FROM [IT Requests]
LEFT JOIN
	[ITR Customers]
ON
	[RequestedBy] = [Name]
LEFT JOIN
	[IT Personnel]
ON
	[ITPersonAssignedID] = [ITPersonID#]
GROUP BY
	[RequestedBy]