USE BWSdb
GO

--#####################################################################################################################
-- Original queries

SELECT * FROM [Options]
	WHERE [Option No] IS NOT NULL
		AND [Description] LIKE '%3 bar weld%'
	ORDER BY [Model No]

SELECT [Model No], [Description] FROM [Options]
	WHERE [Option No] IS NOT NULL
		AND [Description] LIKE '%3 bar weld%'
	ORDER BY [Model No]

--#####################################################################################################################

-- After changes
SELECT * FROM [Options]
	WHERE [Option No] IS NOT NULL
		AND [Description] LIKE '%3 bar weld%'
		AND [Description] NOT LIKE '%48101-1%'
	ORDER BY [Model No]

SELECT [Model No], [Description] FROM [Options]
	WHERE [Option No] IS NOT NULL
		AND [Description] LIKE '%3 bar weld%'
		AND [Description] NOT LIKE '%48101-1%'
	ORDER BY [Model No]

SELECT * FROM [Options_SpecLines]
	WHERE [Option No] IS NOT NULL
		AND [SpecDescription] LIKE '%3 bar weld%'
		AND [SpecDescription] NOT LIKE '%48101-1%'
		AND ([Description] LIKE '%14001%'
		OR [Description] LIKE '%14006%')
	ORDER BY [Model No]
	
SELECT [Model], [Model No], [Class], [Proposed], [Non-Current] FROM [Products] ORDER BY [Model No]
SELECT [Model], [Model No], [Class], [Proposed], [Non-Current] FROM [Products]
	WHERE [Model No] LIKE '%48et%'
	ORDER BY [Model No]
SELECT * FROM [Products] ORDER BY [Model]

