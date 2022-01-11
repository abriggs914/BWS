USE SysproCompanyA
GO

SELECT [DateStkAdded] AS [Date], * FROM [InvMaster] WHERE LOWER(RIGHT([StockCode], 2)) LIKE '%-p%' ORDER BY [DateStkAdded] DESC
--SELECT * FROM [WipJobAllMat]