USE BWSdb
GO

SELECT * FROM [Orders]
WHERE [Special Instructions] LIKE '%ABRIGGS%'
ORDER BY [Serial Number]