USE BWSdb
GO

-- IT Inventory items lended out that havent been returned yet
SELECT
	*
FROM
	[ITI Inventory] AS [I]
WHERE
	[I].[AssignedExpectedReturn] IS NOT NULL
;


SELECT
	*
FROM
	[ITI Inventory History] AS [I]