USE SysproCompanyA
GO

SELECT * FROM [InvMaster] ORDER BY [StockCode]
SELECT * FROM [WipMaster] ORDER BY [StockCode]

USE SysproCompanyS
GO

SELECT * FROM [InvMaster] ORDER BY [StockCode]
USE SysproCompanyS
GO

SELECT * FROM [InvMaster] WHERE [e] LIKE '%%' ORDER BY [StockCode]

USE BWSdb
GO
SELECT * FROM [OrdersV2] WHERE [Customer WO#] LIKE '%10001121%' 
SELECT * FROM [OrdersV2] WHERE [WO#] LIKE '%10001121%' 
