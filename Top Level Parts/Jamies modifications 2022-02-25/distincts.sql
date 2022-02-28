USE SysproCompanyA
GO

SELECT DISTINCT [OperationOffset] FROM [WipJobAllMat]
SELECT DISTINCT [Warehouse], [StockCode] FROM [InvWarehouse]
SELECT DISTINCT [StockCode], [Warehouse] FROM [WipMaster]
