DECLARE @sc NVARCHAR(MAX) = '101211';
DECLARE @wh NVARCHAR(MAX) = '01';

SELECT * FROM [SysproCompanyA].[dbo].[InvMaster] [IM] WHERE [IM].[StockCode] = @sc
SELECT * FROM [SysproCompanyA].[dbo].[InvWarehouse] [IW] WHERE ([IW].[StockCode] = @sc) AND ([IW].[Warehouse] = @wh)
SELECT * FROM [SysproCompanyA].[dbo].[PorMasterDetail] [MD] WHERE ([MD].[MStockCode] = @sc) AND ([MD].[MLastReceiptDat] IS NULL) AND ([MD].[MWarehouse] = @wh)


SELECT 
	*
FROM (
	SELECT 
		*,
		ROW_NUMBER() OVER(
			ORDER BY
				[MD].[MOrigDueDate] DESC
		) AS [RN]
	FROM [SysproCompanyA].[dbo].[PorMasterDetail] [MD] 
	WHERE ([MD].[MStockCode] = @sc) AND ([MD].[MLastReceiptDat] IS NULL) AND ([MD].[MWarehouse] = @wh)
) AS [Src]
WHERE
	[RN] = 1