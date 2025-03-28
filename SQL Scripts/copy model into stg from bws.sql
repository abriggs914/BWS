use BWSdb
go

BEGIN TRAN;

-- 2024-11-25 1439 - James Crawford - initial commit.
-- 2025-03-19 1902 - Avery Briggs - Added support to change the model name

declare 
@modelnoFrom nvarchar(255) = 'Walking Floor 4X',
@modelnoTo nvarchar(255) = 'AWF4X',
		@compidfrom int = 1,
		@compidto int = 0

	--Remove specs from destination company
	delete from StandardsV2
	where [Model No] = @modelnoTo
	and CompanyID = @compidto

	--Insert specs from source company into destination company
	insert into StandardsV2 with (tablock) ([Model No], [Standard No], [Group], Section, [Description], [Start Date], [End Date], SortG, SortSe, Selection, SortGv2, SortSev2, CompanyID)
	select @modelnoTo, [Standard No], [Group], Section, [Description], [Start Date], [End Date], SortG, SortSe, Selection, SortGv2, SortSev2, @compidto
	from StandardsV2
	where [Model No] = @modelnoFrom
	and CompanyID = @compidfrom

	--Compare results
	select * from StandardsV2 with (nolock)
	where [Model No] = @modelnoFrom
	and CompanyID = @compidfrom

	select * from StandardsV2 with (nolock)
	where [Model No] = @modelnoFrom
	and CompanyID = @compidto

	--Remove options from destination company
	delete from OptionsV2
	where [Model No] = @modelnoTo
	and CompanyID = @compidto

	delete from Options_SpecLinesV2
	where [Model No] = @modelnoTo
	and CompanyID = @compidto

	delete from Options_FactoryLinesV2
	where [Model No] = @modelnoTo
	and CompanyID = @compidto

	delete from [Budget Options V2]
	where [Model No] = @modelnoTo
	and CompanyID = @compidto

	--Insert options from source company into destination company
	insert into OptionsV2 with (tablock) ([Model No]
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
		  ,CompanyID)
	select @modelnoTo
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
		  ,@compidto
		  from OptionsV2 with (nolock)
		  where [Model No] = @modelnoFrom
		  and CompanyID = @compidfrom

	insert into Options_SpecLinesV2 with (tablock) ([Model No]
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
		  ,CompanyID)
	select @modelnoTo
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
		  ,@compidto
		  from Options_SpecLinesV2 with (nolock)
		  where [Model No] = @modelnoFrom
		  and CompanyID = @compidfrom

	insert into Options_FactoryLinesV2 with (tablock) ([Model No]
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
		  ,CompanyID)
	select @modelnoTo
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
		  ,@compidto
		  from Options_FactoryLinesV2 with (nolock)
		  where [Model No] = @modelnoFrom
		  and CompanyID = @compidfrom

	insert into [Budget Options V2] with (tablock) ([Bud_Date_Opt]
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
		  ,CompanyID)
	select [Bud_Date_Opt]
		  ,@modelnoTo
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
		  ,@compidto
		  from [Budget Options V2] with (nolock)
		  where [Model No] = @modelnoFrom
		  and CompanyID = @compidfrom

	-- Copy over to BWS legacy table if compying to BWS from Stargate
	if @compidto = 0 and @compidfrom = 1
		BEGIN
			DELETE FROM Options
			WHERE
				[Model No] = @modelnoTo

			DELETE FROM Options_FactoryLines
			WHERE
				[Model No] = @modelnoTo

			DELETE FROM Options_SpecLines
			WHERE
				[Model No] = @modelnoTo		

			DELETE FROM [Budget Options]
			WHERE
				[Model No] = @modelnoTo

			delete FROM Standards
			WHERE
				[Model No] = @modelnoTo

			INSERT INTO Options with (tablock) (
				[Model No]
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
			)
			select @modelnoTo
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
			FROM
				OptionsV2
			WHERE
				[Model No] = @modelnoFrom
				and CompanyID = @compidfrom

			INSERT INTO Options_FactoryLines with (tablock) (
				[Model No]
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
			)
			SELECT @modelnoTo
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
			FROM
				Options_FactoryLinesV2
			WHERE
				[Model No] = @modelnoFrom
				and CompanyID = @compidfrom

			INSERT INTO Options_SpecLines with (tablock) (
				[Model No]
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
			)
			SELECT @modelnoTo
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
			FROM
				Options_SpecLinesV2
			WHERE
				[Model No] = @modelnoFrom
				and CompanyID = @compidfrom

			INSERT INTO [Budget Options] with (tablock) (
				[Bud_Date_Opt]
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
				,[Galvanized]
			)
			select [Bud_Date_Opt]
				,@modelnoTo
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
				,[Galvanized]
			FROM
				[Budget Options V2]
			WHERE
				[Model No] = @modelnoFrom
				and CompanyID = @compidfrom

			INSERT into Standards with (tablock) (
				[Model No]
				,[Standard No]
				,[Group]
				,[Section]
				,[Description]
				,[Start Date]
				,[End Date]
				,[SortG]
				,[SortSe]
				,[Selection]
				,[SortGv2]
				,[SortSev2]
				,[New Spec Wording]
			)
			select @modelnoTo
				,[Standard No]
				,[Group]
				,[Section]
				,[Description]
				,[Start Date]
				,[End Date]
				,[SortG]
				,[SortSe]
				,[Selection]
				,[SortGv2]
				,[SortSev2]
				,[New Spec Wording]
			FROM
				StandardsV2
			WHERE
				[Model No] = @modelnoFrom
				and CompanyID = @compidfrom
		END
		

	--Compare results
	select * from OptionsV2
	where [Model No] = @modelnoFrom
	and CompanyID = @compidfrom

	select * from OptionsV2
	where [Model No] = @modelnoTo
	and CompanyID = @compidto

	select * from Options_SpecLinesV2
	where [Model No] = @modelnoFrom
	and CompanyID = @compidfrom

	select * from Options_SpecLinesV2
	where [Model No] = @modelnoTo
	and CompanyID = @compidto

	select * from Options_FactoryLinesV2
	where [Model No] = @modelnoFrom
	and CompanyID = @compidfrom

	select * from Options_FactoryLinesV2
	where [Model No] = @modelnoTo
	and CompanyID = @compidto

	select * from [Budget Options V2]
	where [Model No] = @modelnoFrom
	and CompanyID = @compidfrom

	select * from [Budget Options V2]
	where [Model No] = @modelnoTo
	and CompanyID = @compidto

	select * from Options
	where
		[Model No] = @modelnoTo

	select * from Options_SpecLines
	where 
		[Model No] = @modelnoTo

	select * from Options_FactoryLines	
	where 
		[Model No] = @modelnoTo

	select * from [Budget Std]
	WHERE
		[Model No] = @modelnoTo

	select * from [Standards]
	WHERE
		[Model No] = @modelnoTo

ROLLBACK;
COMMIT;