USE BWSdb
GO

SELECT [Quote#], * FROM [Production]
SELECT [Quote#], * FROM [Production] WHERE [ProdEmailStartSent] IS NOT NULL ORDER BY [ProdEmailStartSent]
SELECT [Quote#], [WO#], [ProdEmailStartSent] FROM [Production] WHERE [ProdEmailStartSent] IS NOT NULL ORDER BY [ProdEmailStartSent]
