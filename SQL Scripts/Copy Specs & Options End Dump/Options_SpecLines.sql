USE BWSdb
GO



	SELECT * FROM [Budget Options V2] WHERE [Model No] = 'End Dump 5X'

DECLARE @print_1 AS BIT = 0;
DECLARE @print_2 AS BIT = 0;
DECLARE @print_3 AS BIT = 0;

DECLARE @do_update AS BIT = 0;

DECLARE @tid1 AS INT;
DECLARE @tid2 AS INT;
DECLARE @mn1 AS NVARCHAR(MAX);
DECLARE @mn2 AS NVARCHAR(MAX);

SET @tid1 = 490; -- End Dump 4X
SET @tid2 = 506; -- End Dump 5X
SELECT @mn1 = [Model No] FROM [ProductsV2] WHERE [IDTrailer] = @tid1
SELECT @mn2 = [Model No] FROM [ProductsV2] WHERE [IDTrailer] = @tid2

IF @print_1 = 1 BEGIN

	SELECT * FROM [ProductsV2] WHERE [IDTrailer] = @tid1
	SELECT * FROM [OptionsV2] WHERE [Model No] = @mn1
	SELECT * FROM [StandardsV2] WHERE [Model No] = @mn1

	SELECT * FROM [ProductsV2] WHERE [IDTrailer] = @tid2
	SELECT * FROM [OptionsV2] WHERE [Model No] = @mn2
	SELECT * FROM [StandardsV2] WHERE [Model No] = @mn2

	SELECT * FROM [OptionsV2] WHERE LOWER([Model No]) = 'End Dump 4X'
	SELECT * FROM [StandardsV2] WHERE LOWER([Model No]) = 'End Dump 5X'

	--SELECT * FROM [ProductsV2] ORDER BY [Model No]
END

IF @print_2 = 1 BEGIN

	SELECT * FROM [ProductsV2] WHERE [IDTrailer] = @tid1
	SELECT
		[Option No],
		[Sections],
		[Description],
		[Price]
	FROM
		[OptionsV2] WHERE [Model No] = @mn1
	;

	SELECT 
		[Group],
		[Section],
		[Description]
	FROM [StandardsV2] WHERE [Model No] = @mn1

END

IF @print_3 = 1 BEGIN
	SELECT * FROM [Options] WHERE LOWER([Model No]) LIKE '%end dump 5X%'
	SELECT * FROM [Products] WHERE LOWER([Model No]) LIKE '%end dump 5X%'
END

--IF @do_update = 1 BEGIN
	
	BEGIN TRAN;

	SELECT
		'A' AS [Place],
		*
	FROM
		[Options_SpecLinesV2]
	WHERE
		[Model No] = 'End Dump 5X'

	--DELETE FROM 
	--	[Budget Options V2]
	--WHERE
	--	[Model No] = 'End Dump 5X'

	SELECT
		'B' AS [Place],
		*
	FROM
		[Options_SpecLinesV2]
	WHERE
		[Model No] = 'End Dump 5X'

	DECLARE @T AS TABLE (
			[Model No] nvarchar(50)
           ,[Option No] nvarchar(50)
           ,[Description] nvarchar(max)
           ,[Line#] int
           ,[SpecGroup] nvarchar(255)
           ,[SpecSortG] int
           ,[SpecSection] nvarchar(255)
           ,[SpecSortSe] float
           ,[SpecDescription] nvarchar(max)
           ,[SpecDescriptionBold] bit
           ,[SpecDescriptionItalic] bit
           ,[SpecDescriptionUnderline] bit
           ,[SpecDescriptionBackColour] nvarchar(255)
           ,[SpecDescriptionFontColour] nvarchar(255)
           ,[SpecSortSeLine] int
           ,[CompanyID] int
		)

	INSERT INTO @T
	SELECT 
		'End Dump 5X'
		,REPLACE([Option No], '4X', '5X')
           ,[Description]
           ,[Line#]
           ,[SpecGroup]
           ,[SpecSortG]
           ,[SpecSection]
           ,[SpecSortSe]
           ,[SpecDescription]
           ,[SpecDescriptionBold]
           ,[SpecDescriptionItalic]
           ,[SpecDescriptionUnderline]
           ,[SpecDescriptionBackColour]
           ,[SpecDescriptionFontColour]
           ,[SpecSortSeLine]
           ,[CompanyID]
	FROM
		[Options_SpecLinesV2] 
	WHERE
		[Model No] = 'End Dump 4X'

		
	SELECT *
	FROM
		[Options_SpecLinesV2] 
	WHERE
		[Model No] = 'End Dump 5X'
	SELECT *
	FROM
		[Options_SpecLinesV2] 
	WHERE
		[Model No] = 'End Dump 4X'
	SELECT * FROM @T

	--(
	--	[Model No],
	--	[Standard No],
	--	[Group],
	--	[Section],
	--	[Description],
	--	[Start Date],
	--	[End Date],
	--	[SortG],
	--	[SortSe],
	--	[Selection],
	--	[SortGv2],
	--	[SortSev2],
	--	[New Spec Wording],
	--	[CompanyID]
	--)

	DELETE FROM [Options_SpecLinesV2] WHERE [Model No] = 'End Dump 5X'


	INSERT INTO
		[Options_SpecLinesV2]
	([Model No]
           ,[Option No]
           ,[Description]
           ,[Line#]
           ,[SpecGroup]
           ,[SpecSortG]
           ,[SpecSection]
           ,[SpecSortSe]
           ,[SpecDescription]
           ,[SpecDescriptionBold]
           ,[SpecDescriptionItalic]
           ,[SpecDescriptionUnderline]
           ,[SpecDescriptionBackColour]
           ,[SpecDescriptionFontColour]
           ,[SpecSortSeLine]
           ,[CompanyID])

	SELECT [Model No]
           ,[Option No]
           ,[Description]
           ,[Line#]
           ,[SpecGroup]
           ,[SpecSortG]
           ,[SpecSection]
           ,[SpecSortSe]
           ,[SpecDescription]
           ,[SpecDescriptionBold]
           ,[SpecDescriptionItalic]
           ,[SpecDescriptionUnderline]
           ,[SpecDescriptionBackColour]
           ,[SpecDescriptionFontColour]
           ,[SpecSortSeLine]
           ,[CompanyID]
		  FROM @T
	
	SELECT
		'C' AS [Place],
		*
	FROM
		[Options_SpecLinesV2]
	WHERE
		[Model No] = 'End Dump 5X'

--END

	ROLLBACK;
	COMMIT;