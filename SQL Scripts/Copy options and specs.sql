
USE BWSdb
GO
BEGIN TRAN;

	-----------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------


	-- STANDARDS


	DECLARE @TSt AS TABLE (
		[Model No] NVARCHAR(MAX),
		[Standard No] NVARCHAR(MAX),
		[Group]  NVARCHAR(MAX),
		[Section] NVARCHAR(MAX),
		[Description] NVARCHAR(MAX),
		[StartDate] DATETIME,
		[EndDate] DATETIME,
		[SortG] INT,
		[SortSe] INT,
		[Selection] BIT,
		[SortGv2] INT,
		[SortSev2] INT,
		[New Spec Wording] NVARCHAR(MAX),
		[CompanyID] INT
	)

	INSERT INTO @TSt
	SELECT 
		'Frameless End Dump 2X',
		REPLACE([Standard No], 'End Dump 2X', 'Frameless End Dump 2X'),
		[Group],
		[Section],
		[Description],
		[Start Date],
		[End Date],
		[SortG],
		[SortSe],
		[Selection],
		[SortGv2],
		[SortSev2],
		[New Spec Wording],
		[CompanyID]
	FROM
		[StandardsV2] 
	WHERE
		[Model No] = 'End Dump 2X'

	SELECT
		'A Standards' AS [Place],
		*
	FROM
		@TSt
	WHERE
		[Model No] = 'Frameless End Dump 2X'
	;

	DELETE FROM [StandardsV2] WHERE	[Model No] = 'Frameless End Dump 2X';

	INSERT INTO [StandardsV2]
	SELECT 
		[Model No],
		[Standard No],
		[Group],
		[Section],
		[Description],
		[StartDate],
		[EndDate],
		[SortG],
		[SortSe],
		[Selection],
		[SortGv2],
		[SortSev2],
		[New Spec Wording],
		[CompanyID]
	FROM
		@TSt
	;

	SELECT
		'B Standards' AS [Place],
		*
	FROM
		[StandardsV2]
	WHERE
		[Model No] = 'Frameless End Dump 2X'
	;


	-----------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------


	-- FACTORY LINES


	DECLARE @TFl AS TABLE (
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

	INSERT INTO @TFl
	SELECT 
		'Frameless End Dump 2X'
		,REPLACE([Option No], 'End Dump 2X', 'Frameless End Dump 2X')
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
		[Options_FactoryLinesV2] 
	WHERE
		[Model No] = 'End Dump 2X'
	
	SELECT
		'A Factory Lines' AS [Place],
		*
	FROM
		[Options_FactoryLinesV2]
	WHERE
		[Model No] = 'Frameless End Dump 2X'

	DELETE FROM [Options_FactoryLinesV2] WHERE [Model No] = 'Frameless End Dump 2X'

	INSERT INTO
		[Options_FactoryLinesV2]
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
		  FROM @TFl
	
	SELECT
		'B Factory Lines' AS [Place],
		*
	FROM
		[Options_FactoryLinesV2]
	WHERE
		[Model No] = 'Frameless End Dump 2X'


	-----------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------


	-- SPEC LINES

	
	SELECT
		'A Spec Lines' AS [Place],
		*
	FROM
		[Options_SpecLinesV2]
	WHERE
		[Model No] = 'Frameless End Dump 2X'

	DELETE FROM [Options_SpecLinesV2] WHERE [Model No] = 'Frameless End Dump 2X'

	DECLARE @TSl AS TABLE (
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

	INSERT INTO @TSl
	SELECT 
		'Frameless End Dump 2X'
		,REPLACE([Option No], 'End Dump 2X', 'Frameless End Dump 2X')
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
		[Model No] = 'End Dump 2X'
	;

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
		  FROM @TSl
	
	SELECT
		'B Spec Lines' AS [Place],
		*
	FROM
		[Options_SpecLinesV2]
	WHERE
		[Model No] = 'Frameless End Dump 2X'


	-----------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------


	-- OPTIONS
	
	
	SELECT
		'A Options' AS [Place],
		*
	FROM
		[OptionsV2]
	WHERE
		[Model No] = 'Frameless End Dump 2X'

	DELETE FROM [OptionsV2] WHERE [Model No] = 'Frameless End Dump 2X'

	DECLARE @TOp AS TABLE (
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

	INSERT INTO @TOp
	SELECT 
		'Frameless End Dump 2X',
		REPLACE([Option No], 'End Dump 2X', 'Frameless End Dump 2X'),
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
		[Model No] = 'End Dump 2X'
	
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
		  FROM @TOp
	
	SELECT
		'B Options' AS [Place],
		*
	FROM
		[OptionsV2]
	WHERE
		[Model No] = 'Frameless End Dump 2X'


	-----------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------


	-- BUDGET OPTIONS
	
	
	SELECT
		'A Budget Optons' AS [Place],
		*
	FROM
		[Budget Options V2]
	WHERE
		[Model No] = 'Frameless End Dump 2X'
	
	DELETE FROM [Budget Options V2] WHERE [Model No] = 'Frameless End Dump 2X'

	DECLARE @TBo AS TABLE (
		[Bud_Date_Opt] DATETIME
           ,[Model No] NVARCHAR(MAX)
           ,[Option No] NVARCHAR(MAX)
           ,[Description] NVARCHAR(MAX)
           ,[Cost] MONEY
           ,[Labour Cost] MONEY
           ,[Made In Material] MONEY
           ,[Bought Out Material] MONEY
           ,[Machine Shop] FLOAT
           ,[Steel Kit] FLOAT
           ,[Axles] FLOAT
           ,[Stakes/Bunks] FLOAT
           ,[Beam] FLOAT
           ,[GNK] FLOAT
           ,[Parts] FLOAT
           ,[Line] FLOAT
           ,[Step 1] FLOAT
           ,[Step 2] FLOAT
           ,[Blast] FLOAT
           ,[Paint] FLOAT
           ,[Finish] FLOAT
           ,[Finish - GNK] FLOAT
           ,[Final Assembly] FLOAT
           ,[Tire Assembly] FLOAT
           ,[Shipping] FLOAT
           ,[Sections] NVARCHAR(MAX)
           ,[SortSe] INT
           ,[Obsolete] BIT
           ,[CompanyID] INT
		)

	INSERT INTO @TBo
	SELECT 
		[Bud_Date_Opt],
		'Frameless End Dump 2X',
		REPLACE([Option No], 'End Dump 2X', 'Frameless End Dump 2X')
           ,[Description]
           ,[Cost]
           ,[Labour Cost]
           ,[Made In Material]
           ,[Bought Out Material]
           ,[Machine Shop]
           ,[Steel Kit]
           ,[Axles]
           ,[Stakes/Bunks]
           ,[Beam]
           ,[GNK]
           ,[Parts]
           ,[Line]
           ,[Step 1]
           ,[Step 2]
           ,[Blast]
           ,[Paint]
           ,[Finish]
           ,[Finish - GNK]
           ,[Final Assembly]
           ,[Tire Assembly]
           ,[Shipping]
           ,[Sections]
           ,[SortSe]
           ,[Obsolete]
           ,[CompanyID]
	FROM
		[Budget Options V2] 
	WHERE
		[Model No] = 'End Dump 2X'

	INSERT INTO
		[Budget Options V2]
	([Bud_Date_Opt]
           ,[Model No]
           ,[Option No]
           ,[Description]
           ,[Cost]
           ,[Labour Cost]
           ,[Made In Material]
           ,[Bought Out Material]
           ,[Machine Shop]
           ,[Steel Kit]
           ,[Axles]
           ,[Stakes/Bunks]
           ,[Beam]
           ,[GNK]
           ,[Parts]
           ,[Line]
           ,[Step 1]
           ,[Step 2]
           ,[Blast]
           ,[Paint]
           ,[Finish]
           ,[Finish - GNK]
           ,[Final Assembly]
           ,[Tire Assembly]
           ,[Shipping]
           ,[Sections]
           ,[SortSe]
           ,[Obsolete]
           ,[CompanyID])

	SELECT [Bud_Date_Opt]
           ,[Model No]
           ,[Option No]
           ,[Description]
           ,[Cost]
           ,[Labour Cost]
           ,[Made In Material]
           ,[Bought Out Material]
           ,[Machine Shop]
           ,[Steel Kit]
           ,[Axles]
           ,[Stakes/Bunks]
           ,[Beam]
           ,[GNK]
           ,[Parts]
           ,[Line]
           ,[Step 1]
           ,[Step 2]
           ,[Blast]
           ,[Paint]
           ,[Finish]
           ,[Finish - GNK]
           ,[Final Assembly]
           ,[Tire Assembly]
           ,[Shipping]
           ,[Sections]
           ,[SortSe]
           ,[Obsolete]
           ,[CompanyID]
		  FROM @TBo
	
	SELECT
		'B Budget Optons' AS [Place],
		*
	FROM
		[Budget Options V2]
	WHERE
		[Model No] = 'Frameless End Dump 2X'

ROLLBACK;
COMMIT;