USE BWSdb
GO

DECLARE @INC AS MONEY;
SET @INC = 1.05;
DECLARE @ID_STG AS INT;
SET @ID_STG = 0;

SELECT
	[Class],
	[Model No],
	(CASE WHEN ([Non-Current] = 0 AND [Proposed] = 0) THEN 'YES' ELSE '' END) AS [Current],
	'$ ' + CONVERT(VARCHAR, [Price], 1) AS [Price BEFORE],
	'$ ' + CONVERT(VARCHAR, ROUND([Price] * @INC, 2), 1) AS [Price AFTER],
	'$ ' + CONVERT(VARCHAR, [US Price], 1) AS [US Price BEFORE],
	'$ ' + CONVERT(VARCHAR, [US Price] * @INC, 1) AS [US Price AFTER]
FROM
	[ProductsV2]
WHERE
	[CompanyID] = @ID_STG
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
	[OptionsV2]
WHERE
	[CompanyID] = @ID_STG
ORDER BY
	[Model No],
	[Description]
;

SELECT
	*
FROM 
	[OptionsV2]
WHERE
	[CompanyID] = @ID_STG
ORDER BY
	[Model No],
	[Description]
;

SELECT *FROM [ProductsV2] WHERE [Model No] LIKE '%14CR1X%' AND [CompanyID] = @ID_STG

SELECT * FROM [SysproCompanyA].[dbo].[WipMaster] WHERE [QtyToMake] > 1