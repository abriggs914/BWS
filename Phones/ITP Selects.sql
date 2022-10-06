USE BWSdb
GO



SELECT * FROM [ITP PhoneLines] WHERE [Extension] IN (176, 174, 169, 123);
SELECT 'ITP PhoneLines' AS [Table], * FROM [ITP PhoneLines];
SELECT 'ITR FormSections' AS [Table], * FROM [ITP FormSections];
SELECT * FROM [ITR Customers] WHERE [WorkExtension] IN ('176', '174', '169', '123')
SELECT 'ITR Customers' AS [Table], * FROM [ITR Customers] ORDER BY [Name]


SELECT 
	[AssignedTo]
	,[ID]
	,[Name] AS [NAME]
	,ISNULL([Extension], [WorkExtension]) AS [EXT]
	,[DisplayName] AS [POSITION]
	,[WorkPhone] AS [WORK#]
	,[HomePhone] AS [HOME#]
	,[CellPhone] AS [CELL#]
FROM
	[ITP PhoneLines]
FULL OUTER JOIN
	[ITR Customers]
ON
	[ITP PhoneLines].[AssignedTo] = [ITR Customers].[CustomerID]
WHERE
	[Name] IS NOT NULL
ORDER BY
	[Name]

SELECT 'v_ITP PhoneListData' AS [Table], * FROM [v_ITP PhoneListData]