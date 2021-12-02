USE BWSdb
GO

SELECT * FROM [Orders] WHERE [Quote#] IN ((26992), (27092), (27093))
SELECT * FROM [Orders] WHERE [Discount3_Name] LIKE '%freight Discount%' ORDER BY [Quote#]
SELECT [Sale PersonID], [Discount3_Type], [Discount3], * FROM [Orders] WHERE [DealerID] = 140 ORDER BY [Quote Date] DESC
SELECT * FROM [Orders] WHERE [Discount1] IS NOT NULL OR [Discount2] IS NOT NULL OR [Discount3] IS NOT NULL ORDER BY [Quote Date] DESC