USE BWSdb
GO

SELECT * FROM [Options]
	WHERE [Option No] IS NOT NULL
		AND [Description] LIKE '%3 bar weld%'
	ORDER BY [Model No]

SELECT [Model No], [Description] FROM [Options]
	WHERE [Option No] IS NOT NULL
		AND [Description] LIKE '%3 bar weld%'
	ORDER BY [Model No]