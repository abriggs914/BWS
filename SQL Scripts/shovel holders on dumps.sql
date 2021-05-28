USE BWSdb
GO

-- Shovel holders for Dump trailers
SELECT * FROM [Options] AS A WITH (NOLOCK)
	WHERE [Description] LIKE '%shovel%'
	ORDER BY [Description]


-- Shovel holders for Dump trailers
SELECT * FROM [Order OptionsV2] AS A WITH (NOLOCK)
	WHERE [Description] LIKE '%shovel%'
	--ORDER BY [Description]

-- Shovel holders for Dump trailers
SELECT * FROM [Options_SpecLines] AS A WITH (NOLOCK)
	WHERE [Description] LIKE '%shovel%'
	--ORDER BY [Description]
	
-- Shovel holders for Dump trailers
SELECT * FROM [Options_SpecLines] AS A WITH (NOLOCK)
	WHERE ([Model No] LIKE '%42et%'
		OR [Model No] LIKE '%48et%')
		AND [Model No] LIKE '%p%'
		AND [Model No] LIKE '%2x%'
	ORDER BY [SpecDescription]

SELECT * FROM [Order Options]
	WHERE [Description] LIKE '%air lift%'
		AND [Option No] LIKE '%et%'
		AND ([Option No] LIKE '%2x%'
		OR [Option No] LIKE '%3x%')
	ORDER BY [Quote Date]

SELECT * FROM [Options_SpecLines]
	WHERE [SpecDescription] LIKE '%air lift%'
		AND [Option No] LIKE '%et%'
		AND ([Option No] LIKE '%2x%'
		OR [Option No] LIKE '%3x%')
	ORDER BY [Model No]