USE bwsdb
GO

-- Exploring Options_SpecLines, and viewing records.

--SELECT * FROM [Custom Work_FactoryLines]
--SELECT * FROM [Custom Work_SpecLines]
--SELECT * FROM [Order Options_FactoryLines]
--SELECT * FROM [Order Options_SpecLines]
SELECT * FROM [Products]
--SELECT * FROM [Options_FactoryLines]


-- Ensure that "c/w Manual switch in toolbox" does not appear on any Tags.
-- Resulting table should be empty if all changes were made correctly.
SELECT * FROM [Options_SpecLines] AS A WITH (NOLOCK) 
	WHERE [SpecDescription] LIKE '%manual switch%' 
		AND A.[Model No] IN 
			(SELECT [Model No] FROM [Products] WITH (NOLOCK)
				WHERE [Non-Current] = 0)
	ORDER BY [Model No]

-- Ensure that the correct beam dims are displayed for TAG trailer quotes.
-- i.e. inspect option code -90 when adding deck length to these units.
SELECT * FROM [Options_SpecLines] AS A WITH (NOLOCK)
	WHERE [SpecSortSeLine] = -90
		AND A.[Model No] IN
			(SELECT [Model No] FROM [Products] WITH (NOLOCK)
				WHERE [Class] LIKE '%tag%')
	ORDER BY [Model No]

SELECT * FROM [Order Options_SpecLines] AS A WITH (NOLOCK)
	WHERE [SpecSortSeLine] = -90
