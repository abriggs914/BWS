USE SysproCompanyA
GO

SELECT
	*
FROM 
	[InvMaster]
FULL OUTER JOIN
	[InvWarehouse]
ON
	[InvMaster].[StockCode] = [InvWarehouse].[StockCode]
ORDER BY
	[InvMaster].[StockCode]
	, [InvWarehouse].[StockCode]
;