USE BWSdb

SELECT * FROM [Configurations_Specs]
	WHERE ([Description] LIKE '%45%'
		AND [Description] LIKE '%degree%')
		OR ([Description] LIKE '%bend%'
		OR [Description] LIKE '%bent%')
		AND [Description] LIKE '%straight%'


SELECT * FROM [Configurations_Specs]
SELECT * FROM [Master Options_ModelLink]
SELECT * FROM [Master Options]

		
SELECT * FROM [Configurations_Specs]
SELECT * FROM [Configurations]
SELECT * FROM [Products_TempModelSpecs] ORDER BY [Model No]
SELECT * FROM [Products]
SELECT * FROM [ProductsV2]
SELECT * FROM [Configurations_Options_SpecLines]
SELECT * FROM [Products_Classes]
SELECT * FROM [Products - Dealers]


-- Models with multiple D-ring descriptions on the same line
SELECT * FROM [Standards] 
	WHERE [Model No] IS NOT NULL
		AND ([Description] LIKE '%pair%'
		OR [Description] LIKE '%pr%')
		AND ((([Description] LIKE '%45%'
		OR [Description] LIKE '%bend%')
		AND [Description] LIKE '%straight%')
		OR ([Description] LIKE '%standard%'
		AND [Description] LIKE '%degree%'))
	ORDER BY [Model No]

SELECT * FROM [Standards] 
	WHERE [Model No] IS NOT NULL 
		AND [Description] LIKE '%ring%'
		AND [Description] NOT LIKE '%lift ring%'
		AND [Description] NOT LIKE '%spring%'
		AND [Description] NOT LIKE '%bearing%'
		AND [Description] NOT LIKE '%steering%'
GO