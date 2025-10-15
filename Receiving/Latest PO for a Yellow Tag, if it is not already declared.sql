
-- 2025-10-14 12:03
-- Latest PO for a Yellow Tag, if it is not already declared



SELECT
	[YT].[ID],
	[YT].[StockCode],
	[YT].[PO],
	[MD].[PurchaseOrder],
	[MD].[RN]
FROM
	[BWSdb].[dbo].[PROD_YellowTags] [YT]
LEFT JOIN (
	SELECT
		[MD].[MStockCode],
		[MD].[PurchaseOrder],
		ROW_NUMBER() OVER(
			PARTITION BY
				[MD].[PurchaseOrder]
			ORDER BY
				ISNULL([MD].[MLatestDueDate], GETDATE())
		) AS [RN]
	FROM
		[SysproCompanyA].[dbo].[PorMasterDetail] [MD]
	INNER JOIN 
		[SysproCompanyA].[dbo].[PorHistReceipt] [PH]
	ON
		([MD].[PurchaseOrder] = [PH].[PurchaseOrder])
		AND ([MD].[MStockCode] = [PH].[StockCode])
	WHERE
		(LTRIM(RTRIM(ISNULL([MD].[MStockCode], ''))) <> '')
		AND ([PH].[QtyReceived] < [MD].[MOrderQty])
		AND (ISNULL([MD].[MLatestDueDate], GETDATE()) BETWEEN DATEADD(DAY, -500, GETDATE()) AND DATEADD(DAY, 500, GETDATE()))
	GROUP BY
		[MD].[MStockCode],
		[MD].[PurchaseOrder],
		[MD].[MLatestDueDate]
) AS [MD]
ON
	([YT].[StockCode] = [MD].[MStockCode] COLLATE DATABASE_DEFAULT)
	AND ([YT].[PO] IS NULL)
ORDER BY
	[YT].[ID]


	
	/*

SELECT 
	[YT].[ID] AS [OldID],
	ISNULL([YT].[PO], [MD].[PurchaseOrder]) AS [PurchaseOrder],
	[MD].[MStockCode],
	[MD].[MWarehouse],
	[MD].[MOrigDueDate] AS [OrigDueDate],
	[MD].[MLatestDueDate] AS [LatestDueDate],
	[MD].[MReceivedQty],
	ROW_NUMBER() OVER(
		PARTITION BY
			[MD].[MStockCode]
		ORDER BY
			[MD].[MOrigDueDate] DESC
	) AS [RN]
FROM (
	SELECT
		*
	FROM
		[SysproCompanyA].[dbo].[PorMasterDetail] [MD]
	WHERE
		(LTRIM(RTRIM(ISNULL([MD].[MStockCode], ''))) <> '')
) AS [MD]
INNER JOIN 
	[BWSdb].[dbo].[PROD_YellowTags] [YT] ON [MD].[MStockCode] = [YT].[StockCode] COLLATE DATABASE_DEFAULT
WHERE
	([MStockCode] = 'TR-FL-E07-34.625')
	OR ([PurchaseOrder] = '000000000148759')

	
	*/
/*
(
			CASE WHEN [YT].[PO] IS NULL THEN (
				CASE WHEN (LTRIM(RTRIM(ISNULL([MD].[MStockCode], ''))) <> '') THEN 1 ELSE 0 END)
			ELSE (
				CASE WHEN [YT].[PO] = [MD].[PurchaseOrder] COLLATE DATABASE_DEFAULT THEN 1 ELSE 0 END
			)
		) > 0
*/

