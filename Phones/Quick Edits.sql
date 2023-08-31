USE BWSdb
GO

SELECT * FROM [ITP PhoneLines] ORDER BY [Extension]

SELECT * FROM [ITP PhoneLines] ORDER BY
[Section], [SectionOrder]
SELECT * FROM [ITP PhoneLines] ORDER BY
[Extension]
SELECT * FROM [ITP FormSections] ORDER BY
[ID]
SELECT * FROM [ITR Customers] ORDER BY [ITR Customers].[CustomerID]


BEGIN TRAN

UPDATE
	[ITP PhoneLines]
SET
	[DisplayName] = 'Designer'
WHERE
	[Extension] = 165

ROLLBACk;
COMMIT;