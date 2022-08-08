USE BWSdb
GO

SELECT * FROM [Orders] WHERE [Quote#] IN (27913);
SELECT * FROM [Orders_RevHistory] WHERE [Quote#] IN (27913);
SELECT * FROM [Order standards] WHERE [Quote#] IN (27913);
SELECT * FROM [Order Options] WHERE [Quote#] IN (27913);
SELECT * FROM [audOrders] WHERE [Quote#] IN (27913);

SELECT [Products].[Price] FROm [Products] WHERE [Model No] = '53HF4X'
SELECT [Products].[Price] FROm [Products] WHERE [Model No] = '48HF4X'

--SELECT * FROM 