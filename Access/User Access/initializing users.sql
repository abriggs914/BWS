USE BWSdb
GO


BEGIN TRAN;

INSERT INTO [ADO_User_Access] ([ITRCustomerID], [ADOModuleID], [ValidFrom], [ValidTo])
SELECT 
	[C].[CustomerID]
	, [A].[ID]
	, '2021-01-01'
	, '2024-12-31 23:59:59'
FROM
	[ITR Customers] [C]
CROSS JOIN
	[ADO_Modules] [A]
LEFT JOIN
	[ADO_User_Access] [U]
ON
	[C].[CustomerID] = [U].[ITRCustomerID]
	AND [A].[ID] = [U].[ADOModuleID]
WHERE
	([Name] LIKE '%avery%'
	OR [Name] LIKE '%james crawford%'
	OR [Name] LIKE '%jamie merr%')
	AND	([U].[ID] IS NULL)


UPDATE
	[ADO_User_Access]
SET
	[ValidTo] = '2024-12-31 23:59:59'
WHERE
	[ITRCustomerID] = 4

ROLLBACK;
COMMIT;

SELECT
	*
FROM
	[LQS Quote Edit]