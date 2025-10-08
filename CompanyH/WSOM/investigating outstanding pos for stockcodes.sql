
-- Outstanding POs for each YT StockCode.
-- ReceivedDate must be null
SELECT 
	[MD].[PurchaseOrder],
	[MD].[MStockCode],
	[MD].[MWarehouse],
	[MD].[MOrigDueDate] AS [OrigDueDate],
	[MD].[MLatestDueDate] AS [LatestDueDate],
	[MD].[MReceivedQty],
	ROW_NUMBER() OVER(
		PARTITION BY
			[MD].[MStockCode]
		ORDER BY
			[MD].[MLastReceiptDat] DESC
	) AS [RN]
FROM (
	SELECT
		*
	FROM
		[SysproCompanyA].[dbo].[PorMasterDetail] 
	WHERE
		(LTRIM(RTRIM(ISNULL([PorMasterDetail].[MStockCode], ''))) <> '')
) AS [MD]
INNER JOIN [BWSdb].[dbo].[PROD_YellowTags] [YT] ON [MD].[MStockCode] = [YT].[StockCode] COLLATE DATABASE_DEFAULT
--WHERE ([MD].[MLastReceiptDat] IS NULL)