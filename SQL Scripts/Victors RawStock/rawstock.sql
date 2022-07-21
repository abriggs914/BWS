
USE SysproCompanyA
GO

SELECT
	[InvMaster].*
FROM
	[InvMaster]
LEFT JOIN
	[BomStructure]
ON
	[BomStructure].[ParentPart] = [InvMaster].[StockCode]
WHERE
	[PartCategory] = 'B'