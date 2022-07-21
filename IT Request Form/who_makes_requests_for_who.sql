SELECT
	[RequestDateOriginal], 
	[ITRequestID#],
	[IT Requests].[RequestedBy],
	[ITR Customers].[Name],
	[ITR Customers].[CustomerID]
FROM
	[IT Requests]
LEFT JOIN
	[ITR Customers]
ON
	[IT Requests].[RequestedBy] = [ITR Customers].[Name]
ORDER BY
	[ITRequestID#]