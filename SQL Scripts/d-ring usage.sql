USE BWSdb
GO
-- 2021-05-28
-- Create an option to remove D-rings

SELECT * FROM [Options] AS A WITH (NOLOCK)
	WHERE ([Description] LIKE '% ring%'
		OR [Description] LIKE '%-ring%')
		AND [Draw/Part#] IS NOT NULL
		AND [Description] LIKE '%d%'
		AND [Description] NOT LIKE '%moulded rub rail%'
	ORDER BY [Draw/Part#]

-- These models, have the wrong part number
SELECT * FROM [Options] AS A WITH (NOLOCK)
	WHERE [Draw/Part#] IS NOT NULL
		AND ([Draw/Part#] LIKE '40573'
		OR [Draw/Part#] LIKE '40577')
	ORDER BY [Draw/Part#]

SELECT DISTINCT [Draw/Part#] FROM [Options] AS A WITH (NOLOCK)
	WHERE ([Description] LIKE '% ring%'
		OR [Description] LIKE '%-ring%')
		AND [Draw/Part#] IS NOT NULL
		AND [Description] LIKE '%d%'
		AND [Description] NOT LIKE '%moulded rub rail%'
	ORDER BY [Draw/Part#]

--SELECT * FROM [PartsE2ScrubImport_Estim] WHERE [StockCode] LIKE '40573' ORDER BY [StockCode]
--SELECT * FROM [PartsE2ScrubImport_Estim2] WHERE [PartNo] LIKE '17470'  ORDER BY [PartNo]
--SELECT * FROM [Suggested Parts]
--SELECT * FROM [Products_TempModelSpecs] WHERE [Model No] LIKE '%53ET3x%'

--SELECT * FROM [Configurations_Specs]
--	WHERE [Description] LIKE '%ring

SELECT * FROM [Products_TempModelSpecs]
	WHERE [Description] LIKE '%ring%'

