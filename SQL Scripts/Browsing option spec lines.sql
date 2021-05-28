USE BWSdb
GO


SELECT * FROM [Order Options]
	ORDER BY [Description]

SELECT * FROM [Options_SpecLines]
	WHERE [SpecDescription] IS NOT NULL
		AND [SpecDescription] LIKE '%manual%'
	ORDER BY [SpecDescription] --WHERE [SpecDescription] LIKE '%manual switch%'

SELECT * FROM [Options_SpecLines]
	WHERE [Option No] LIKE '%25ART-11%'

SELECT * FROM [Options_SpecLines] AS A WITH (NOLOCK)
	WHERE [SpecDescription] LIKE '%lift axle%'
		AND A.[Option No] IN (
			SELECT [Option No] FROM [Order Options]
		)
		
SELECT * FROM [Order Options] AS A WITH (NOLOCK)
	WHERE [Option No] IN (
			SELECT [Option No] FROM [Options_SpecLines]
				WHERE [SpecDescription] LIKE '%lift axle%'
		)

--SELECT * FROM [Order Options]