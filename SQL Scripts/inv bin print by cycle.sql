USE SysproCompanyA
GO

SELECT [DefaultBin], [Warehouse], [CycleCount], [InvMaster].*, [InvWarehouse].* FROM [InvMaster] INNER JOIN [InvWarehouse] ON [InvMaster].[StockCode] = [InvWarehouse].[StockCode]