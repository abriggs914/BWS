
USE BWSdb
GO


DECLARE @class AS NVARCHAR(MAX);  -- [Forms]![Edit Existing Model Parameters]![Class]
SET @class = 'Sanimax';
DECLARE @model AS NVARCHAR(MAX);  -- [Forms]![Edit Existing Model Parameters]![Model No]
SET @model = 'End Dump 3X - Sanimax (Hamiliton SPIF)';

SELECT 
	ProductsV2.Class
	, ProductsV2.Model
	, ProductsV2.[Model No]
	, ProductsV2.Price
	, ProductsV2.[US Price]
	, ProductsV2.[Start Date]
	, ProductsV2.[End Date]
	, OptionsV2.[Option No]
	, OptionsV2.[start Date] AS [Start Date]
	, OptionsV2.[end date] AS [End Date]
	, OptionsV2.Price
	, OptionsV2.[US Price]
	, OptionsV2.SortSe
	, OptionsV2.Sections
	, OptionsV2.Description
	, OptionsV2.Weight
	, ProductsV2.Weight
	, OptionsV2.Obsolete
FROM 
	ProductsV2 
INNER JOIN
	OptionsV2 
ON 
	(ProductsV2.[Model No] = OptionsV2.[Model No])
	AND (ProductsV2.CompanyID = OptionsV2.CompanyID)
WHERE 
	(((ProductsV2.Class)=@class) 
	AND ((ProductsV2.[Model No])=@model)
	AND ((OptionsV2.Description)<>'NO OPTIONS FOR THIS WORK ORDER') 
	AND ((OptionsV2.Obsolete)=0));

	
	
SELECT * FROM [OptionsV2] WHERE [OptionsV2].[Model No]  = 'ED4X Sanimax'
SELECT * FROM [Options_FactoryLinesV2] WHERE [Options_FactoryLinesV2].[Model No]  = 'End Dump 4X Quebec SAN Pork'
SELECT * FROM [Options_SpecLinesV2] WHERE [Options_SpecLinesV2].[Model No]  = 'End Dump 4X Quebec SAN Pork'

BEGIN TRAN;

	UPDATE
		[Options V2]

ROLLBACK
COMMIT;