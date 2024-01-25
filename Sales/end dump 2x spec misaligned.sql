USE BWSdb
GO

SELECT
	*
FROM
	[OrdersV2]
WHERE
	[SGQuote] = 'SG101540'
;

SELECT
	*
FROM
	[OrdersV2 History]
WHERE
	[Model No] = 'End Dump 2X'
;

SELECT
	*
FROM
	[OrdersV2]
WHERE
	[Model No] = 'End Dump 2X'
;

SELECT
	*
FROM
	[ProductsV2]
WHERE
	[Model No] = 'End Dump 2X'
;

SELECT
	*
FROM
	[StandardsV2]
WHERE
	[Model No] = 'End Dump 2X'
;

SELECT
	*
FROM
	[Order StandardsV2] 
WHERE
	[SGQuote] = 'SG101540'
	OR [SGQuote] = 'SG100285'
	--AND [Section] = 'ABS'
ORDER BY
	[SortGv2]
	,[SortSev2]
;

SELECT 
	BWSdb_ProductsV2.Class,
	BWSdb_ProductsV2.Model,
	BWSdb_ProductsV2.Price,
	BWSdb_ProductsV2.[Start Date],
	BWSdb_ProductsV2.[End Date],
	BWSdb_StandardsV2.[Model No], 
	BWSdb_ProductsV2.[Non-Current],
	BWSdb_StandardsV2.[Standard No], 
	[BWSdb_StandardsV2].[start Date] AS [Start Date],
	[BWSdb_StandardsV2].[end date] AS [End Date], 
	BWSdb_StandardsV2.SortSe, 
	BWSdb_StandardsV2.Section, 
	BWSdb_StandardsV2.Description,
	BWSdb_StandardsV2.SortGv2, 
	BWSdb_StandardsV2.SortSev2,
	BWSdb_StandardsV2.[Group], 
	BWSdb_StandardsV2.SortG
FROM 
	[ProductsV2] AS [BWSdb_ProductsV2]
INNER JOIN
	[StandardsV2] AS [BWSdb_StandardsV2]
ON 
	BWSdb_ProductsV2.[Model No] = BWSdb_StandardsV2.[Model No]
WHERE 
	(
		(BWSdb_ProductsV2.Class='End Dumps')
		And (BWSdb_StandardsV2.[Model No]='End Dump 2X')
		And (BWSdb_ProductsV2.[Non-Current]=0)
	)
ORDER BY
	[SortGv2]
	,[SortSev2]
; 
