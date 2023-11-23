USE BWSdb
GO

SELECT
	*
FROM
	[ITI Locations]

SELECT
	*
FROM
	[ITR Customers]
WHERE
	[Name] LIKE '%kyle%'

SELECT
	*
FROM
	[ITI Locations] AS [I]
CROSS JOIN
	[ITR Customers] AS [C]
WHERE
	[I].[ID] = 43 
	AND [C].[CustomerID] = 66

BEGIN TRAN;


SELECT
	*
FROM
	[ITI Locations] AS [I]
CROSS JOIN
	[ITR Customers] AS [C]
WHERE
	[I].[ID] = 43 
	AND [C].[CustomerID] = 66

UPDATE
	[ITI Locations]
SET
	[Active] = 1
	,[DateActive] = GETDATE()
	,[Description] = 'Kyle''s Section of warehouse counter, beside Warehouse Counter computer.'
	,[EmployeeAssigned] = [C].[CustomerID]
FROM
	[ITI Locations] AS [I]
CROSS JOIN
	[ITR Customers] AS [C]
WHERE
	[I].[ID] = 43 
	AND [C].[CustomerID] = 66

	
SELECT
	*
FROM
	[ITI Locations] AS [I]
CROSS JOIN
	[ITR Customers] AS [C]
WHERE
	[I].[ID] = 43 
	AND [C].[CustomerID] = 66

ROLLBACK;
COMMIT;
