USE SysproCompanyA
GO

SELECT

	[W].[MaterialCost]
	,[P].[SellingPrice]
	,[M].[MaterialCost]
	,[QtyOnHand]
	,[W].[LabourCost]
	,*
FROM 
	[InvMaster] AS [M]
INNER JOIN
	[InvPrice] AS [P]
ON
	[M].[StockCode] = [P].[StockCode]
INNER JOIN 
	[InvWarehouse] AS [W]
ON
	[M].[StockCode] = [W].[StockCode]
WHERE
	[M].[StockCode] = '101235'

	
--SELECT * FROM [Stargatedb].[dbo].[v_ListOfStockCodes]
SELECT * FROM [SysproCompanyA].[dbo].[v_ListOfStockCodes] WHERE [StockCode] = '101235'
--SELECT * FROM [SysproCompanyS].[dbo].[v_ListOfStockCodes]
--SELECT * FROM [BWSdb].[dbo].[v_ListOfStockCodes]