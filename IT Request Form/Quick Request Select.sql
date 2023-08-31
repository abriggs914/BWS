USE BWSdb
GO

SELECT
	*
FROM
	[IT Requests] AS [R]
LEFT JOIN
	[IT Personnel] AS [P]
ON
	[R].[ITPersonAssignedID] = [P].[ITPersonID#]
LEFT JOIN
	[ITR Customers] AS [C]
ON
	[P].[ITRCustomerID] = [C].[CustomerID]
WHERE
	[Status] NOT IN ('Declined', 'Complete', 'Incomplete')
	AND LOWER([C].[Name]) LIKE '%avery%'
	OR LOWER([RequestedBy]) LIKE '%avery%'
ORDER BY
	[RequestDateOriginal] DESC
