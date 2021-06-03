USE BWSdb
GO

SELECT * FROM [Options]
	WHERE [Description] LIKE '%5820%'
	ORDER BY [Model No], [Draw/Part#]