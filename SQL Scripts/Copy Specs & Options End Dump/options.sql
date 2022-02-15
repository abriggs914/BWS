USE BWSdb
GO



	SELECT * FROM [OptionsV2] WHERE [Model No] = 'End Dump 4X'

DECLARE @print_1 AS BIT = 0;
DECLARE @print_2 AS BIT = 0;
DECLARE @print_3 AS BIT = 0;

DECLARE @do_update AS BIT = 0;

DECLARE @tid1 AS INT;
DECLARE @tid2 AS INT;
DECLARE @mn1 AS NVARCHAR(MAX);
DECLARE @mn2 AS NVARCHAR(MAX);

SET @tid1 = 541; -- End Dump 3X
SET @tid1 = 490; -- End Dump 4X
SELECT @mn1 = [Model No] FROM [ProductsV2] WHERE [IDTrailer] = @tid1
SELECT @mn2 = [Model No] FROM [ProductsV2] WHERE [IDTrailer] = @tid2

IF @print_1 = 1 BEGIN

	SELECT * FROM [ProductsV2] WHERE [IDTrailer] = @tid1
	SELECT * FROM [OptionsV2] WHERE [Model No] = @mn1
	SELECT * FROM [StandardsV2] WHERE [Model No] = @mn1

	SELECT * FROM [ProductsV2] WHERE [IDTrailer] = @tid2
	SELECT * FROM [OptionsV2] WHERE [Model No] = @mn2
	SELECT * FROM [StandardsV2] WHERE [Model No] = @mn2

	SELECT * FROM [OptionsV2] WHERE LOWER([Model No]) = 'End Dump 3X'
	SELECT * FROM [StandardsV2] WHERE LOWER([Model No]) = 'End Dump 4X'

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
	SELECT * FROM [Options] WHERE LOWER([Model No]) LIKE '%end dump 4x%'
	SELECT * FROM [Products] WHERE LOWER([Model No]) LIKE '%end dump 4x%'
END

--IF @do_update = 1 BEGIN
	
	BEGIN TRAN;

	SELECT
		'A' AS [Place],
		*
	FROM
		[OptionsV2]
	WHERE
		[Model No] = 'End Dump 4X'

	DELETE FROM 
		[OptionsV2]
	WHERE
		[Model No] = 'End Dump 4X'

	SELECT
		'B' AS [Place],
		*
	FROM
		[OptionsV2]
	WHERE
		[Model No] = 'End Dump 4X'

	DECLARE @T AS TABLE (
		[Model No] NVARCHAR(MAX),
		[Option No] NVARCHAR(MAX),
		[Start Date] DATETIME,
		[End Date] DATETIME,
		[Price] FLOAT,
		[Sections] NVARCHAR(MAX),
		[Description] NVARCHAR(MAX),
		[Weight] INT,
		[Width] INT,
		[Deck Length] INT,
		[Spread] INT,
		[SortSe] INT,
		[Draw/Part#] NVARCHAR(MAX),
		[Std Hours] FLOAT,
		[Obsolete] BIT,
		[Selection] BIT,
		[New Option Wording] NVARCHAR(MAX),
		[OptionInfo] NVARCHAR(MAX),
		[OptionPromptFlag] BIT,
		[OptionPrompt] NVARCHAR(MAX),
		[OptionConfigInfo] NVARCHAR(MAX),
		[US Price] MONEY,
		[CompanyID] INT
	)

	INSERT INTO @T
	SELECT 
		'End Dump 4X',
		REPLACE([Option No], '3X', '4X'),
		[Start Date],
		[End Date],
		[Price],
		[Sections],
		[Description],
		[Weight],
		[Width],
		[Deck Length],
		[Spread],
		[SortSe],
		[Draw/Part#],
		[Std Hours],
		[Obsolete],
		[Selection],
		[New Option Wording],
		[OptionInfo],
		[OptionPromptFlag],
		[OptionPrompt],
		[OptionConfigInfo],
		[US Price],
		[CompanyID]
	FROM
		[OptionsV2] 
	WHERE
		[Model No] = 'End Dump 3X'

		
	SELECT *
	FROM
		[OptionsV2] 
	WHERE
		[Model No] = 'End Dump 4X'
	SELECT *
	FROM
		[OptionsV2] 
	WHERE
		[Model No] = 'End Dump 3X'
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

	DELETE FROM [OptionsV2] WHERE [Model No] = 'End Dump 4X'


	INSERT INTO
		[OptionsV2]
	([Model No]
           ,[Option No]
           ,[Start Date]
           ,[End Date]
           ,[Price]
           ,[Sections]
           ,[Description]
           ,[Weight]
           ,[Width]
           ,[Deck Length]
           ,[Spread]
           ,[SortSe]
           ,[Draw/Part#]
           ,[Std Hours]
           ,[Obsolete]
           ,[Selection]
           ,[New Option Wording]
           ,[OptionInfo]
           ,[OptionPromptFlag]
           ,[OptionPrompt]
           ,[OptionConfigInfo]
           ,[US Price]
           ,[CompanyID])
	SELECT [Model No]
           ,[Option No]
           ,[Start Date]
           ,[End Date]
           ,[Price]
           ,[Sections]
           ,[Description]
           ,[Weight]
           ,[Width]
           ,[Deck Length]
           ,[Spread]
           ,[SortSe]
           ,[Draw/Part#]
           ,[Std Hours]
           ,[Obsolete]
           ,[Selection]
           ,[New Option Wording]
           ,[OptionInfo]
           ,[OptionPromptFlag]
           ,[OptionPrompt]
           ,[OptionConfigInfo]
           ,[US Price]
           ,[CompanyID]
		  FROM @T
	
	SELECT
		'C' AS [Place],
		*
	FROM
		[OptionsV2]
	WHERE
		[Model No] = 'End Dump 4X'

--END

	ROLLBACK;
	COMMIT;