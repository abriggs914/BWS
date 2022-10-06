USE BWSdb
GO

SELECT * FROM [Custom Work] WHERE [Description] LIKE '%plug and cable%'
SELECT * FROM [Custom Work_SpecLines] WHERE [Description] LIKE '%plug and cable%'
SELECT * FROM [Custom Work_FactoryLines] WHERE [Description] LIKE '%plug and cable%'
SELECT * FROM [Order Options] WHERE [Description] LIKE '%plug and cable%'
SELECT * FROM [Order Options_FactoryLines] WHERE [Description] LIKE '%plug and cable%'
SELECT * FROM [Order Options_SpecLines] WHERE [Description] LIKE '%plug and cable%'
--SELECT * FROM [Custom] WHERE [Description] LIKE '%c/w drain plug and cable%'




SELECT [Quote#], [WO#], [Description], [SpecDescription], [SpecGroup], [SpecSection] FROM [Custom Work_SpecLines] WHERE [Description] LIKE '%plug and cable%'