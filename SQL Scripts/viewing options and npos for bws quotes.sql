USE BWSdb
GO

SELECT * FROM [Order Options] WHERE [Quote#] IN (27857, 27859);
SELECT * FROM [Custom Work] WHERE [Quote#] IN (27857, 27859);
SELECT * FROM [Custom Work_FactoryLines] WHERE [Quote#] IN (27857, 27859);
SELECT * FROM [Custom Work_SpecLines] WHERE [Quote#] IN (27857, 27859);