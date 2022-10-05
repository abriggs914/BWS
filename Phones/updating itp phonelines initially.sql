
BEGIN TRAN;

SELECT * FROM [ITR Customers] ORDER BY [Name]


SELECT * FROM [ITP PhoneLines]
UPDATE [ITP PhoneLines]
	SET
		[AssignedTo] = CAST([C].[CustomerID] AS INT)
FROM [ITP PhoneLines]
INNER JOIN
	[ITR Customers] AS [C]
ON
	[ITP PhoneLines].[Extension] = CAST([C].[WorkExtension] AS INT)
SELECT * FROM [ITP PhoneLines]

ROLLBACK;
COMMIT;