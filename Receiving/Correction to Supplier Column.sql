/*
-- 2025-09-08 - Avery Briggs - Correction to Supplier Column
BEGIN 

*/
	DECLARE @wh NVARCHAR(MAX) = '01';
	/*
	UPDATE
		[BWSdb].[dbo].[PROD_YellowTags]
	SET
		[Description] = ISNULL([IM].[Description], '') + ' *---* ' + ISNULL([IM].[LongDesc], '')
	*/
	SELECT
	ISNULL([IM].[Description], '') + ' *---* ' + ISNULL([IM].[LongDesc], ''),
		*
	FROM 
		[BWSdb].[dbo].[PROD_YellowTags] [YT]
	INNER JOIN (
		SELECT 
			[MD].[PurchaseOrder],
			[MD].[MStockCode],
			ROW_NUMBER() OVER(
				PARTITION BY
					[MD].[MStockCode]
				ORDER BY
					[MD].[MOrigDueDate] DESC
			) AS [RN]
		FROM [SysproCompanyA].[dbo].[PorMasterDetail] [MD]
		INNER JOIN [BWSdb].[dbo].[PROD_YellowTags] [YT] ON [MD].[MStockCode] = [YT].[StockCode] COLLATE DATABASE_DEFAULT
		WHERE ([MD].[MLastReceiptDat] IS NULL) AND ([MD].[MWarehouse] = @wh) AND ([YT].[Active] = 1)
	) AS [Src]
	ON
		[YT].[StockCode] = [Src].[MStockCode] COLLATE DATABASE_DEFAULT
	FULL JOIN
		[SysproCompanyA].[dbo].[InvMaster] [IM]
	ON
		[Src].[MStockCode] = [IM].[StockCode]
	LEFT JOIN
		[SysproCompanyA].[dbo].[ApSupplier] [AS]
	ON
		[IM].[Supplier] = [AS].[Supplier]
	WHERE
		([Src].[RN] = 1)
		AND ([YT].[Active] = 1)
	;
/*
ROLLBACK;
COMMIT;
*/