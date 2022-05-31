USE BWSdb
GO

SELECT [Quote#], [Orders].[CustID], * FROM [Orders] WHERE [Quote#] = 26683
SELECT * FROM [dtProductionSchedule] WHERE [Quote#] = 26683
SELECT * FROM [Order Standards] WHERE [Quote#] = 26683

SELECT * FROM [Production] WHERE [Quote#] = 26683
SELECT * FROM [Customers] WHERE [Quote#] = 26683

USE BWSdb_20211205
GO

SELECT [Quote#], [Orders].[CustID], * FROM [Orders] WHERE [Quote#] = 26683
SELECT * FROM [dtProductionSchedule] WHERE [Quote#] = 26683
SELECT * FROM [Order Standards] WHERE [Quote#] = 26683

SELECT * FROM [Production] WHERE [Quote#] = 26683
SELECT * FROM [Customers] WHERE [Quote#] = 26683