USE SysproCompanyA
GO

SELECT [DateStkAdded] AS [Date], * FROM [InvMaster] WHERE LOWER([StockCode]) LIKE '%-mach%' ORDER BY [DateStkAdded] DESC
SELECT * FROM [WipJobAllMat]