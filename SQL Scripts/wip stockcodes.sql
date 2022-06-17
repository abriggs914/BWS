USE SysproCompanyA
GO

SELECT DISTINCT [InvMaster].[StockCode], [InvWarehouse].[DefaultBin], [InvMaster].[ProductClass] FROM [InvWarehouse] LEFT JOIN [InvMaster] ON [InvWarehouse].[StockCode] = [InvMaster].[StockCode]