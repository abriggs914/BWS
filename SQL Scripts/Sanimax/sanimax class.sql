USE BWSdb
GO

SELECT * FROM [ProductsV2] ORDER BY [Class], [Model]
SELECT * FROM [OptionsV2] ORDER BY [Option No]

DECLARE @models AS TABLE ([ID] INT);
INSERT INTO @models ([ID]) VALUES
(540) -- End Dump 4X - Sanimax Quebec
, (538) -- End Dump 3X - Sanimax (Hamiliton SPIF)
, (539) -- End Dump 2X - Sanimax US Spread
, (403) -- 53ET3X

SELECT * FROM [ProductsV2] WHERE [IDTrailer] IN (SELECT [ID] FROM @models) ORDER BY [Class], [Model]


-- Update class for these 3 models
BEGIN TRAN;

	SELECT * FROM [ProductsV2] WHERE [IDTrailer] IN (SELECT [ID] FROM @models) ORDER BY [Class], [Model]

	UPDATE
		[ProductsV2]
	SET
		[Class] = 'Sanimax'
	WHERE
		[IDTrailer] IN (SELECT [ID] FROM @models)
	
	SELECT * FROM [ProductsV2] WHERE [IDTrailer] IN (SELECT [ID] FROM @models) ORDER BY [Class], [Model]


	
	-- Update model name for 540

	SELECT * FROM [ProductsV2] WHERE [IDTrailer] = 540 ORDER BY [Class], [Model]

	UPDATE
		[ProductsV2]
	SET
		[Model No] = 'ED4X Sanimax'
		, [Model] = 'End Dump 4X - Sanimax Quebec'
	WHERE
		[IDTrailer] = 540
	
	SELECT * FROM [ProductsV2] WHERE [IDTrailer] = 540 ORDER BY [Class], [Model]


	
	-- Update model name for 538

	SELECT * FROM [ProductsV2] WHERE [IDTrailer] = 538 ORDER BY [Class], [Model]

	UPDATE
		[ProductsV2]
	SET
		[Model No] = 'ED3X Sanimax'
		, [Model] = 'End Dump 3X ABP (Hamilton Spiff)'
	WHERE
		[IDTrailer] = 538
	
	SELECT * FROM [ProductsV2] WHERE [IDTrailer] = 538 ORDER BY [Class], [Model]


	
BEGIN TRAN;
	-- Update model name for 539

	SELECT * FROM [ProductsV2] WHERE [IDTrailer] = 540 ORDER BY [Class], [Model]

	UPDATE
		[ProductsV2]
	SET
		[Model No] = 'ED4X Sanimax'
		 --,[Model] = 'End Dump 4X Quebec SAN Pork'
	WHERE
		[IDTrailer] = 540
	
	SELECT * FROM [ProductsV2] WHERE [IDTrailer] = 540 ORDER BY [Class], [Model]


ROLLBACK;
COMMIT;