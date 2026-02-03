SELECT
	[SM].[Supplier],
	[SD].[NComment],
	[SD].[MStockCode],
	[SD].[MStockDes],
	[SD].[MOrderQty],
	[SM].[DateLastDocPrt],
	*
FROM



	[SysproCompanyA].[dbo].[PorMasterHdr] [SM] -- 1 Record / SO
INNER JOIN
	[SysproCompanyA].[dbo].[PorMasterDetail] [SD] -- 1 Record / SO-Stockcode
ON
	[SM].[PurchaseOrder] = [SD].[PurchaseOrder]

WHERE
	[SM].[PurchaseOrder] = '000000000150802'

/*
	[SysproCompanyA].[dbo].[SorDetail] [SD] -- 1 Record / Line on SO
WHERE
	LTRIM(RTRIM(ISNULL([SD].[NComment], ''))) <> ''
	AND ((
		LOWER([SD].[NComment]) LIKE '%96648193%'
	)
	OR  (
		(
			LOWER([SD].[NComment]) LIKE '%midland%'
		)
		OR (
			LOWER([SD].[NComment]) LIKE '%tracking%'
		)
	)
	)
*/
WHERE
	((LOWER([SM].[CustomerName]) LIKE '%remorques%')
	OR (LOWER([SM].[CustomerName]) LIKE '%services 2r%'))
	AND ([OrderDate] BETWEEN '2025-01-01' AND '2025-07-15')
	AND ([SD].[MPrice] < 30000)
	--OR (LOWER(ISNULL([SD].[CustomerName], '')) +  = '%services 2r%')
ORDER BY
	[SM].[DateLastInvPrt]