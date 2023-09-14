USE BWSdb
GO

SELECT * FROM [ITI Locations]

-- Located in a IT Location:

--DECLARE @lID AS INT = 2; -- My [ITI Locations] Office ID
DECLARE @lID AS INT = 4; -- Server Room [ITI Locations] ID


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
	AND [L].[ID] = @lID
;

