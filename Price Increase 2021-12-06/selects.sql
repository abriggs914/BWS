USE BWSdb
GO

DECLARE @INC AS MONEY;
SET @INC = 1.05;

SELECT
	[Class],
	[Model No],
	(CASE WHEN ([Non-Current] = 0 AND [Proposed] = 0) THEN 'YES' ELSE '' END) AS [Current],
	'$ ' + CONVERT(VARCHAR, [Price], 1) AS [Price BEFORE],
	'$ ' + CONVERT(VARCHAR, ROUND([Price] * @INC, 2), 1) AS [Price AFTER],
	'$ ' + CONVERT(VARCHAR, [US Price], 1) AS [US Price BEFORE],
	'$ ' + CONVERT(VARCHAR, [US Price] * @INC, 1) AS [US Price AFTER]
FROM
	[Products]
ORDER BY
	[Class],
	[Model No],
	[Price]
;

SELECT
	[Model No],
	[Option No],
	[Description],
	(CASE WHEN [Obsolete] = 1 THEN 'YES' ELSE '' END) AS [Obsolete],
	'$ ' + CONVERT(VARCHAR, [Price], 1) AS [Price BEFORE],
	'$ ' + CONVERT(VARCHAR, ROUND([Price] * @INC, 2), 1) AS [Price AFTER],
	'$ ' + CONVERT(VARCHAR, [US Price], 1) AS [US Price BEFORE],
	'$ ' + CONVERT(VARCHAR, [US Price] * @INC, 1) AS [US Price AFTER]
FROM 
	[Options]
ORDER BY
	[Model No],
	[Description]
;

SELECT
	*
FROM 
	[Options]
ORDER BY
	[Model No],
	[Description]
;

SELECT *FROM [Products] WHERE [Model No] LIKE '%14CR1X%'

SELECT * FROM [SysproCompanyA].[dbo].[WipMaster] WHERE [QtyToMake] > 1