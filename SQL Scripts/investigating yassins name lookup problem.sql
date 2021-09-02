USE SysproCompanyA
GO

SELECT [DrawOfficeNum], [StockCode], [UserField3], [ProductClass] FROM [InvMaster] WHERE [DrawOfficeNum] != '' AND [DrawOfficeNum] LIKE 'LB-RTF%'