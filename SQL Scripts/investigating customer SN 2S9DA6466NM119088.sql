USE BWSdb
GO

-- Second Version

SELECT * FROM [OrdersV2] WHERE [Serial Number] = '2S9DA6466NM119088'
SELECT * FROM [CustomersV2] INNER JOIN [OrdersV2] ON [CustomersV2].[SGQuote] = [OrdersV2].[SGQuote] WHERE [Serial Number] = '2S9DA6466NM119088'
SELECT * FROM [CustomersV2] INNER JOIN [Orders] ON [CustomersV2].[WO#] = [Orders].[WO#] WHERE [Serial Number] = '2S9DA6466NM119088'