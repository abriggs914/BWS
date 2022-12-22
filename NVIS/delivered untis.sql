USE BWSdb
GO

SELECT * FROM [Orders]
WHERE [Delivery Date] IS NOT NULL
ORDER BY [Delivery Date]