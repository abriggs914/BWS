USE BWSdb
GO

SELECT * FROM [Orders]
	WHERE [Model No] LIKE '%DT%'

SELECT WO# FROM [Order Options]
	WHERE [Option No] LIKE '%DT%'
		AND [Option No] LIKE '%27%'
		--AND [SpecSection] LIKE '%color%'
		AND [WO#] IS NOT NULL
		AND [Sections] LIKE '%paint%'
	ORDER BY [Order Date]

--SELECT * FROM [Order Options_FactoryLines]
--	WHERE [Option No] LIKE '%32%'
		--AND [WO#] IS NOT NULL
		--AND [SpecSection] LIKE '%color%'
	--ORDER BY [Quote#]