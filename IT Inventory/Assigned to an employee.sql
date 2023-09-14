USE BWSdb
GO

-- Assigned to an employee:

DECLARE @cID AS INT = 4; -- My [ITR Customers] ID


SELECT
	[I].*,
	[L].*,
	[R].*
FROM
	[ITI Inventory] AS [I]
INNER JOIN
	[ITI Locations] AS [L]
ON
	[I].[ITLocation] = [L].[ID]
INNER JOIN
	[ITR Customers] AS [R]
ON
	[L].[EmployeeAssigned] = [R].[CustomerID]
WHERE
	[I].[Active] = 1
	AND [I].[IsAssigned] = 1
	AND [R].[CustomerID] = @cID
;

