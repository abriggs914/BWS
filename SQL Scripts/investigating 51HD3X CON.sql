SELECT * FROM [ProductsV2] WHERE [Model No] LIKE '%51HD3X CON%';
SELECT * FROM [Products] WHERE [Model No] LIKE '%51HD3X CON%';

SELECT * FROM [Budget Options V2] WHERE [Model No] LIKE '%51HD3X CON%';
SELECT * FROM [Budget Options] WHERE [Model No] LIKE '%51HD3X CON%';

SELECT * FROM [Options] WHERE [Model No] LIKE '%51HD3X CON%';
SELECT * FROM [OptionsV2] WHERE [Model No] LIKE '%51HD3X CON%';


DECLARE @class AS NVARCHAR(MAX);
DECLARE @model AS NVARCHAR(MAX);

SET @class = 'Highway';
SET @model = '51HD3X CON';

SELECT [Class], [Model No] FROM [Products] WHERE (((Products.Class)=@class) AND ((Products.[Model No])=@model)) ORDER BY [Class], [Model]
SELECT * FROM [Options] ORDER BY [Model No]
SELECT * FROM [Options] WHERE ((([Options].[Model No])=@model)) ORDER BY [Model No]

SELECT 
	Products.Class,
	Products.Model, Products.[Model No], Products.Price, Products.[US Price], Products.[Start Date], Products.[End Date], Options.[Option No], Options.[start Date] AS [Start Date], Options.[end date] AS [End Date], Options.Price, Options.[US Price], Options.SortSe, Options.Sections, Options.Description, Options.Weight, Products.Weight, Options.Obsolete
FROM Products INNER JOIN Options ON Products.[Model No] = Options.[Model No] 
WHERE (((Products.Class)=@class) AND ((Products.[Model No])=@model)) --AND (((Options.Description)<>'NO OPTIONS FOR THIS WORK ORDER') AND ((Options.Obsolete)=0))
ORDER BY [Class], [Model]
;


BEGIN TRAN

SELECT * FROM [Options] 
WHERE	
	[Option No] = '88873560'

UPDATE
	[Options]
SET
	[Obsolete] = 1
WHERE	
	[Option No] = '88873560'

SELECT * FROM [Options] 
WHERE	
	[Option No] = '88873560'

ROLLBACK;