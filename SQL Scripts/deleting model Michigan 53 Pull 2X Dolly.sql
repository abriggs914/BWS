USE BWSdb
GO

BEGIN TRAN;

SELECT * FROM [ProductsV2] WHERE [Model No] LIKE '%Michigan 5/3 Pull 2X, Dolly%'
SELECT * FROM [StandardsV2] WHERE [Model No] LIKE '%Michigan 5/3 Pull 2X, Dolly%'
SELECT * FROM [OrdersV2] WHERE [Model No] LIKE '%Michigan 5/3 Pull 2X, Dolly%'
SELECT * FROM [OptionsV2] WHERE [Model No] LIKE '%Michigan 5/3 Pull 2X, Dolly%'
SELECT * FROM [Budget Options V2] WHERE [Model No] LIKE '%Michigan 5/3 Pull 2X, Dolly%'
SELECT * FROM [Order OptionsV2_FactoryLines] WHERE [Option No] LIKE '%Michigan 5/3 Pull 2X, Dolly%'
SELECT * FROM [Order OptionsV2_SpecLines] WHERE [Option No] LIKE '%Michigan 5/3 Pull 2X, Dolly%'


DELETE FROM
	[ProductsV2] WHERE [Model No] LIKE '%Michigan 5/3 Pull 2X, Dolly%'
DELETE FROM
	[StandardsV2] WHERE [Model No] LIKE '%Michigan 5/3 Pull 2X, Dolly%'
DELETE FROM
	[OrdersV2] WHERE [Model No] LIKE '%Michigan 5/3 Pull 2X, Dolly%'
DELETE FROM
	[OptionsV2] WHERE [Model No] LIKE '%Michigan 5/3 Pull 2X, Dolly%'
DELETE FROM
	[Budget Options V2] WHERE [Model No] LIKE '%Michigan 5/3 Pull 2X, Dolly%'
DELETE FROM
	[Order OptionsV2_FactoryLines] WHERE [Order OptionsV2_FactoryLines].[Option No] LIKE '%Michigan 5/3 Pull 2X, Dolly%'
DELETE FROM
	[Order OptionsV2_SpecLines] WHERE [Order OptionsV2_SpecLines].[Option No] LIKE '%Michigan 5/3 Pull 2X, Dolly%'

SELECT * FROM [ProductsV2] WHERE [Model No] LIKE '%Michigan 5/3 Pull 2X, Dolly%'
SELECT * FROM [StandardsV2] WHERE [Model No] LIKE '%Michigan 5/3 Pull 2X, Dolly%'
SELECT * FROM [OrdersV2] WHERE [Model No] LIKE '%Michigan 5/3 Pull 2X, Dolly%'
SELECT * FROM [OptionsV2] WHERE [Model No] LIKE '%Michigan 5/3 Pull 2X, Dolly%'
SELECT * FROM [Budget Options V2] WHERE [Model No] LIKE '%Michigan 5/3 Pull 2X, Dolly%'
SELECT * FROM [Order OptionsV2_FactoryLines] WHERE [Option No] LIKE '%Michigan 5/3 Pull 2X, Dolly%'
SELECT * FROM [Order OptionsV2_SpecLines] WHERE [Option No] LIKE '%Michigan 5/3 Pull 2X, Dolly%'

ROLLBACK;
COMMIT;