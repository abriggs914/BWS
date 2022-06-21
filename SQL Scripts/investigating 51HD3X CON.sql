SELECT * FROM [ProductsV2] WHERE [Model No] LIKE '%51HD3X CON%';
SELECT * FROM [Products] WHERE [Model No] LIKE '%51HD3X CON%';

SELECT * FROM [Budget Options V2] WHERE [Model No] LIKE '%51HD3X CON%';
SELECT * FROM [Budget Options] WHERE [Model No] LIKE '%51HD3X CON%';

SELECT * FROM [Options] WHERE [Model No] LIKE '%51HD3X CON%';
SELECT * FROM [OptionsV2] WHERE [Model No] LIKE '%51HD3X CON%';


DECLARE @class AS NVARCHAR(MAX);
DECLARE @model AS NVARCHAR(MAX);

SET @class = 'Highway';
SET @class = '51HD3X CON';

SELECT 
	Products.Class,
	Products.Model, Products.[Model No], Products.Price, Products.[US Price], Products.[Start Date], Products.[End Date], Options.[Option No], Options.[start Date] AS [Start Date], Options.[end date] AS [End Date], Options.Price, Options.[US Price], Options.SortSe, Options.Sections, Options.Description, Options.Weight, Products.Weight, Options.Obsolete
FROM Products INNER JOIN Options ON Products.[Model No] = Options.[Model No] ORDER BY [Class], [Model]
--WHERE (((Products.Class)=@class) AND ((Products.[Model No])=@model)) --AND ((Options.Description)<>'NO OPTIONS FOR THIS WORK ORDER') AND ((Options.Obsolete)=0));
