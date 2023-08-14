USE SysproCompanyA
GO

SELECT
	*
FROM
	[InvWarehouse]
WHERE
	[StockCode] = '03106'
;

SELECT
	*
FROM
	[WipMaster]
WHERE
	[StockCode] = '03106'
;

SELECT
	*
FROM
	[WipJobAllMat]
WHERE
	[StockCode] = '03081'
	AND [Job] = '10016619'
;

SELECT
	*
FROM
	[BWSdb].[dbo].[Orders]
WHERE
	[ProductID] IS NULL
ORDER BY
	[Quote Date]
;