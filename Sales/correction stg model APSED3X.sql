DECLARE @m1 NVARCHAR(MAX) = 'APSED3X';
DECLARE @m2 NVARCHAR(MAX) = 'Aluminum Post & Sheet End Dump 3X';

/*
SELECT
	*
FROM
	[BWSdb].[dbo].[ProductsV2]
WHERE
	[Model No] = @m1
	OR [Model No] = @m2

SELECT
	*
FROM
	[BWSdb].[dbo].[Options V2_FactoryLines]
WHERE
	[Model No] = @m1
	OR [Model No] = @m2

SELECT
	*
FROM
	[BWSdb].[dbo].[Options V2_SpecLines]
WHERE
	[Model No] = @m1
	OR [Model No] = @m2

SELECT
	*
FROM
	[BWSdb].[dbo].[Budget Options V2]
WHERE
	[Model No] = @m1
	OR [Model No] = @m2

SELECT
	*
FROM
	[BWSdb].[dbo].[OptionsV2]
WHERE
	[Model No] = @m1
	OR [Model No] = @m2
*/

BEGIN TRAN;


SELECT
	*
FROM
	[BWSdb].[dbo].[OptionsV2]
WHERE
	[Model No] = @m1
	OR [Model No] = @m2

	
UPDATE
	[BWSdb].[dbo].[OptionsV2]
SET
	[Model No] = @m1,
	[Option No] = @m1 + RIGHT([Option No], 6)
WHERE
	[Model No] = @m1
	OR [Model No] = @m2

	
SELECT
	*
FROM
	[BWSdb].[dbo].[OptionsV2]
WHERE
	[Model No] = @m1
	OR [Model No] = @m2

/*
SELECT
	*
FROM
	[BWSdb].[dbo].[ProductsV2]
WHERE
	[Model No] = @m1
	OR [Model No] = @m2

SELECT
	*
FROM
	[BWSdb].[dbo].[Options_FactoryLinesV2]
WHERE
	[Model No] = @m1
	OR [Model No] = @m2

SELECT
	*
FROM
	[BWSdb].[dbo].[Options_SpecLinesV2]
WHERE
	[Model No] = @m1
	OR [Model No] = @m2

SELECT
	*
FROM
	[BWSdb].[dbo].[StandardsV2]
WHERE
	[Model No] = @m1
	OR [Model No] = @m2


	-----------------------------------------------------


UPDATE
	[BWSdb].[dbo].[Options_FactoryLinesV2]
SET
	[Model No] = @m1
	, [Option No] = @m1 + RIGHT([Option No], 6)
WHERE
	[Model No] = @m2

UPDATE
	[BWSdb].[dbo].[Options_SpecLinesV2]
SET
	[Model No] = @m1
	, [Option No] = @m1 + RIGHT([Option No], 6)
WHERE
	[Model No] = @m2

UPDATE
	[BWSdb].[dbo].[StandardsV2]
SET
	[Model No] = @m1
	, [Standard No] = @m1 + RIGHT([Standard No], 3)
WHERE
	[Model No] = @m2



	-----------------------------------------------------

	
SELECT
	*
FROM
	[BWSdb].[dbo].[ProductsV2]
WHERE
	[Model No] = @m1
	OR [Model No] = @m2

SELECT
	*
FROM
	[BWSdb].[dbo].[Options_FactoryLinesV2]
WHERE
	[Model No] = @m1
	OR [Model No] = @m2

SELECT
	*
FROM
	[BWSdb].[dbo].[Options_SpecLinesV2]
WHERE
	[Model No] = @m1
	OR [Model No] = @m2

SELECT
	*
FROM
	[BWSdb].[dbo].[StandardsV2]
WHERE
	[Model No] = @m1
	OR [Model No] = @m2
	*/

/*
SELECT
	*
FROM
	[BWSdb].[dbo].[Budget Options V2]
WHERE
	[Model No] = @m1
	OR [Model No] = @m2

	--------------------------------
	
UPDATE
	[BWSdb].[dbo].[Budget Options V2]
SET
	[Model No] = @m1,
	[Option No] = @m1 + RIGHT([Option No], 6)
WHERE
	--[Model No] = @m1
	--OR
	[Model No] = @m2

	--------------------------------

	
SELECT
	*
FROM
	[BWSdb].[dbo].[Budget Options V2]
WHERE
	[Model No] = @m1
	OR [Model No] = @m2
*/



ROLLBACK;
COMMIT;