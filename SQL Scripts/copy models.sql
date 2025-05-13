
USE [BWSdb]
GO

DECLARE
	@modelnoFrom NVARCHAR(255) = 'AFED2X',
	@modelnoTo NVARCHAR(255) = 'AFED2X',
	@compidfrom INT = 1,
	@compidto INT = 0,
	@safe BIT = 1,
	@resetDates BIT = 1,
	@defaultDaySpan INT = 365,

	@validAllNew BIT = 1,
	@validNewProd BIT = NULL,
	@validNewStan BIT = NULL,
	@validNewOptn BIT = NULL,
	@validNewBStd BIT = NULL,
	@validNewBOpt BIT = NULL,
	@validNewOFac BIT = NULL,
	@validNewOSpc BIT = NULL,
	@validNewSNTp BIT = NULL
;

-- Don't expose these variables
DECLARE
	@sdelim NVARCHAR(25) = '__',
	@lenStandardSerial INT = 3,
	@lenOptionSerial INT = 5
;

-- Logic to ensure that if a select portion of the table subset above is chosen, then the 'All' option is turned off.
IF ISNULL(@validNewProd, 1) = 0 SELECT @validAllNew = 0;
IF ISNULL(@validNewStan, 1) = 0	SELECT @validAllNew = 0;
IF ISNULL(@validNewOptn, 1) = 0 SELECT @validAllNew = 0;
IF ISNULL(@validNewBStd, 1) = 0	SELECT @validAllNew = 0;
IF ISNULL(@validNewBOpt, 1) = 0	SELECT @validAllNew = 0;
IF ISNULL(@validNewOFac, 1) = 0	SELECT @validAllNew = 0;
IF ISNULL(@validNewOSpc, 1) = 0	SELECT @validAllNew = 0;
IF ISNULL(@validNewSNTp, 1) = 0	SELECT @validAllNew = 0;

-- If nothing specified individually to toggle off @validAllNew, then set all table variables to True.
IF ISNULL(@validAllNew, 0) = 1 BEGIN
	SELECT
		@validNewProd = 1,
		@validNewStan = 1,
		@validNewOptn = 1,
		@validNewBStd = 1,
		@validNewBOpt = 1,
		@validNewOFac = 1,
		@validNewOSpc = 1,
		@validNewSNTp = 1
	;
END

-- Input Varible Sanitization
SELECT
	@defaultDaySpan = (CASE WHEN ISNULL(@defaultDaySpan, -1) < 0 THEN 365 ELSE @defaultDaySpan END)
;

/*
SELECT
	*
FROM
	[BWSdb].[dbo].[ProductsV2]
WHERE
	[Model No] IN ('AFED2X', 'B-Train PULL 3X - Pace', 'BTP3XSS PACE')
	
SELECT
	*
FROM
	[BWSdb].[dbo].[Products]
WHERE
	[Model No] IN ('AFED2X', 'B-Train PULL 3X - Pace', 'BTP3XSS PACE')
SELECT
	*
FROM
	[BWSdb].[dbo].[Options]
WHERE
	[Model No] IN ('AFED2X', 'B-Train PULL 3X - Pace', 'BTP3XSS PACE')

--		('AFED2X', 'AFED2X', 'Aluminum Frameless End Dumps')
*/
--BEGIN TRAN;

-- 2024-11-25 1439 - James Crawford - initial commit.
-- 2025-03-19 1902 - Avery Briggs - Added support to change the model name

-- Tables to Consider:
/*
	[ProductsV2]
	[StandardsV2]
	[OptionsV2]
	[Budget Options V2]
	[Budget Std V2]
	[Options_SpecLinesV2]
	[Options_FactoryLinesV2]
	[SN Type V2]
*/


IF (@modelnoFrom = @modelnoTo) AND (@compidfrom = @compidto) AND (ISNULL(@safe, 0) = 0) BEGIN
	-- Copying within same table and same name not permitted.
	-- **Unless @safe is activated to prevent deleteing records before trying to copy them.
	RETURN
END


-- If @safe is enabled, then the new model name must be unique.
-- Appends a delimiter '__' and an incremented number to the new Model's name.
IF @safe = 1 BEGIN
	IF (@compidto = 1) AND EXISTS(SELECT * FROM [ProductsV2] WHERE [Model No] = @modelnoTo) BEGIN
		-- Model name already exists
		SELECT 
			@modelnoTo = (
				CASE WHEN LOWER([Model No]) = LOWER(@modelnoTo) THEN 
					SUBSTRING(
						[Model No], 1,
						(CASE WHEN CHARINDEX(@sdelim, [Model No]) > 0 THEN 
							CHARINDEX(@sdelim, [Model No]) - 1 
						ELSE 
							LEN([Model No])
						END)
				) + @sdelim + (CASE WHEN CHARINDEX(@sdelim, [Model No]) = 0 THEN
					'1'
					WHEN CHARINDEX(@sdelim, [Model No]) > 0 THEN 
						CAST(CAST(SUBSTRING([Model No], CHARINDEX(@sdelim, [Model No]), LEN([Model No])) AS INT) + 1 AS NVARCHAR(255))
					ELSE ''
				END)
				ELSE [Model No]
			END)
		FROM 
			[ProductsV2]
		WHERE
			[Model No] = @modelnoTo
		;
	END
	ELSE IF (@compidto = 0) AND EXISTS(SELECT * FROM [Products] WHERE [Model No] = @modelnoTo) BEGIN
		-- Model name already exists
		SELECT 
			@modelnoTo = (
				CASE WHEN LOWER([Model No]) = LOWER(@modelnoTo) THEN 
					SUBSTRING(
						[Model No], 1,
						(CASE WHEN CHARINDEX(@sdelim, [Model No]) > 0 THEN 
							CHARINDEX(@sdelim, [Model No]) - 1 
						ELSE 
							LEN([Model No])
						END)
				) + @sdelim + (CASE WHEN CHARINDEX(@sdelim, [Model No]) = 0 THEN
					'1'
					WHEN CHARINDEX(@sdelim, [Model No]) > 0 THEN 
						CAST(CAST(SUBSTRING([Model No], CHARINDEX(@sdelim, [Model No]), LEN([Model No])) AS INT) + 1 AS NVARCHAR(255))
					ELSE ''
				END)
				ELSE [Model No]
			END)
		FROM 
			[Products]
		WHERE
			[Model No] = @modelnoTo
		;
	END
END


-- Clear any existing data from the destination tables
-------------------------------------------------------------------
-- BE CAUTIOUS AS THERE IS NO [CompanyID] TO CROSS-REFERENCE IN BWS
-------------------------------------------------------------------
IF @compidto = 1 BEGIN
	-- STG
	IF ISNULL(@validNewProd, 0) = 1 DELETE FROM [ProductsV2] WHERE ([Model No] = @modelnoTo) AND ([CompanyID] = @compidto);
	IF ISNULL(@validNewStan, 0) = 1 DELETE FROM [StandardsV2] WHERE ([Model No] = @modelnoTo) AND ([CompanyID] = @compidto);
	IF ISNULL(@validNewOptn, 0) = 1 DELETE FROM [OptionsV2] WHERE ([Model No] = @modelnoTo) AND ([CompanyID] = @compidto);
	IF ISNULL(@validNewBOpt, 0) = 1 DELETE FROM [Budget Options V2] WHERE ([Model No] = @modelnoTo) AND ([CompanyID] = @compidto);
	IF ISNULL(@validNewBStd, 0) = 1 DELETE FROM [Budget Std V2] WHERE ([Model No] = @modelnoTo) AND ([CompanyID] = @compidto);
	IF ISNULL(@validNewOSpc, 0) = 1 DELETE FROM [Options_SpecLinesV2] WHERE ([Model No] = @modelnoTo) AND ([CompanyID] = @compidto);
	IF ISNULL(@validNewOFac, 0) = 1 DELETE FROM [Options_FactoryLinesV2] WHERE ([Model No] = @modelnoTo) AND ([CompanyID] = @compidto);
	IF ISNULL(@validNewSNTp, 0) = 1 DELETE FROM [SN Type V2] WHERE ([Model No] = @modelnoTo) AND ([CompanyID] = @compidto);
END
ELSE IF @compidto = 0 BEGIN
	-- BWS	
	IF ISNULL(@validNewProd, 0) = 1 DELETE FROM [Products] WHERE ([Model No] = @modelnoTo) AND ([CompanyID] = @compidto);
	IF ISNULL(@validNewStan, 0) = 1 DELETE FROM [Standards] WHERE ([Model No] = @modelnoTo)  -- AND ([CompanyID] = @compidto);
	IF ISNULL(@validNewOptn, 0) = 1 DELETE FROM [Options] WHERE ([Model No] = @modelnoTo)  -- AND ([CompanyID] = @compidto);
	IF ISNULL(@validNewBOpt, 0) = 1 DELETE FROM [Budget Options] WHERE ([Model No] = @modelnoTo)  -- AND ([CompanyID] = @compidto);
	IF ISNULL(@validNewBStd, 0) = 1 DELETE FROM [Budget Std] WHERE ([Model No] = @modelnoTo)  -- AND ([CompanyID] = @compidto);
	IF ISNULL(@validNewOSpc, 0) = 1 DELETE FROM [Options_SpecLines] WHERE ([Model No] = @modelnoTo)  -- AND ([CompanyID] = @compidto);
	IF ISNULL(@validNewOFac, 0) = 1 DELETE FROM [Options_FactoryLines] WHERE ([Model No] = @modelnoTo)  -- AND ([CompanyID] = @compidto);
	IF ISNULL(@validNewSNTp, 0) = 1 DELETE FROM [SN Type] WHERE ([Model No] = @modelnoTo) AND ([CompanyID] = @compidto);
END


IF @compidfrom <> @compidto BEGIN
	IF @compidfrom = 1 BEGIN
		-- Copy BWS -> STG
		
		-- [ProductsV2]
		IF ISNULL(@validNewProd, 0) = 1 BEGIN
			INSERT INTO
				[dbo].[ProductsV2]
			(
				[Class]
			   ,[Proposed]
			   ,[Non-Current]
			   ,[Model]
			   ,[Model No]
			   ,[Top Level Part# (SYSPRO)]
			   ,[Grouping]
			   ,[Start Date]
			   ,[End Date]
			   ,[Price]
			   ,[Weight]
			   ,[Make]
			   ,[NVIS]
			   ,[Promo Drawing]
			   ,[Width]
			   ,[Spread]
			   ,[Deck Length]
			   ,[Days]
			   ,[GN]
			   ,[Paint]
			   ,[Finish]
			   ,[S/NL1]
			   ,[S/NL2]
			   ,[S/NT1]
			   ,[S/NT2]
			   ,[S/NAxles]
			   ,[Selection]
			   ,[EffComDate]
			   ,[ComRate]
			   ,[LastCostUpdate]
			   ,[LCUInitials]
			   ,[QR_Discount1]
			   ,[QR_Discount2]
			   ,[QR_Discount3]
			   ,[QR_ExpectedMargin]
			   ,[tmpProductsV2ClassesID]
			   ,[QRUS_Discount1]
			   ,[QRUS_Discount2]
			   ,[QRUS_Discount3]
			   ,[QRUS_ExpectedMargin]
			   ,[US Price]
			   ,[Customer]
			   ,[Top Level Part# (SYSPRO 8)]
			   ,[Promo Drawing V2]
			   ,[CompanyID]
			   ,[DateCreated]
			)
			SELECT
				[Class]
			   ,[Proposed]
			   ,[Non-Current]
			   ,[Model]
			   ,[Model No]
			   ,[Top Level Part# (SYSPRO)]
			   ,[Grouping]
			   ,[Start Date]
			   ,[End Date]
			   ,[Price]
			   ,[Weight]
			   ,[Make]
			   ,[NVIS]
			   ,[Promo Drawing]
			   ,[Width]
			   ,[Spread]
			   ,[Deck Length]
			   ,[Days]
			   ,[GN]
			   ,[Paint]
			   ,[Finish]
			   ,[S/NL1]
			   ,[S/NL2]
			   ,[S/NT1]
			   ,[S/NT2]
			   ,[S/NAxles]
			   ,[Selection]
			   ,[EffComDate]
			   ,[ComRate]
			   ,[LastCostUpdate]
			   ,[LCUInitials]
			   ,[QR_Discount1]
			   ,[QR_Discount2]
			   ,[QR_Discount3]
			   ,[QR_ExpectedMargin]
			   ,NULL --[tmpProductsV2ClassesID]
			   ,[QRUS_Discount1]
			   ,[QRUS_Discount2]
			   ,[QRUS_Discount3]
			   ,[QRUS_ExpectedMargin]
			   ,[US Price]
			   ,[Customer]
			   ,[Top Level Part# (SYSPRO 8)]
			   ,[Promo Drawing V2]
			   ,@compidto
			   ,(CASE WHEN ISNULL(@resetDates, 0) = 1 THEN GETDATE() ELSE [DateCreated] END)
			FROM
				[Products]
			WHERE
				[Model No] = @modelnoFrom
			;			
		END

		-- [StandardsV2]
		IF ISNULL(@validNewStan, 0) = 1 BEGIN
			INSERT INTO 
				[dbo].[StandardsV2]
			(
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
			   ,[CompanyID]
			   ,[Tarp]
			)
			SELECT
				@modelnoTo
			   ,@modelnoTo + '-' + RIGHT('00000' + ISNULL([Standard No], ''), @lenStandardSerial)
			   ,[Group]
			   ,[Section]
			   ,[Description]
			   ,(CASE WHEN ISNULL(@resetDates, 0) = 1 THEN GETDATE() ELSE [Start Date] END)
			   ,(CASE WHEN ISNULL(@resetDates, 0) = 1 THEN DATEADD(DAY, @defaultDaySpan, GETDATE()) ELSE [End Date] END)
			   ,[SortG]
			   ,[SortSe]
			   ,[Selection]
			   ,[SortGv2]
			   ,[SortSev2]
			   ,[New Spec Wording]
			   ,@compidto
			   ,NULL  -- [Tarp]
			FROM
				[Standards]
			WHERE
				[Model No] = @modelnoFrom
			;
		END
		
		IF ISNULL(@validNewOptn, 0) = 1 BEGIN
			INSERT INTO
				[dbo].[OptionsV2]
			(
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
			   ,[CompanyID]
			   ,[Tarp]
			)
			SELECT
				@modelnoTo
			   ,@modelnoTo + '-' + RIGHT('00000' + ISNULL([Option No], ''), @lenOptionSerial)
			   ,(CASE WHEN ISNULL(@resetDates, 0) = 1 THEN GETDATE() ELSE [Start Date] END)
			   ,(CASE WHEN ISNULL(@resetDates, 0) = 1 THEN DATEADD(DAY, @defaultDaySpan, GETDATE()) ELSE [End Date] END)
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
			   ,NULL  -- [Tarp]
			FROM
				[Options]
			WHERE
				[Model No] = @modelnoFrom
			;
		END
		
		IF ISNULL(@validNewBStd, 0) = 1 BEGIN
			INSERT INTO
				[dbo].[Budget Std V2]
			(
				[Model No]
			   ,[Top Level Part# (SYSPRO)]
			   ,[Std Date]
			   ,[COGS]
			   ,[Labour Cost]
			   ,[Made In Material]
			   ,[Bought Out Material]
			   ,[Machine Shop]
			   ,[Axles]
			   ,[Stakes/Bunks]
			   ,[Beam]
			   ,[GNK]
			   ,[Parts]
			   ,[Subs]
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
			   ,[Margins Base]
			   ,[Margins Options]
			   ,[Top Level Part# (SYSPRO 8)]
			   ,[CompanyID]
			   ,[Operation1Hours]
			   ,[Operation2Hours]
			   ,[Operation3Hours]
			   ,[Operation4Hours]
			   ,[Operation5Hours]
			   ,[Operation6Hours]
			   ,[Operation7Hours]
			   ,[Operation8Hours]
			   ,[Operation9Hours]
			   ,[Operation10Hours]
			   ,[Operation11Hours]
			   ,[Operation12Hours]
			   ,[Operation13Hours]
			   ,[Operation14Hours]
			   ,[Operation15Hours]
			   ,[Operation16Hours]
			   ,[Operation17Hours]
			   ,[Galvanized]
			)
			SELECT
				@modelnoTo
			   ,[Top Level Part# (SYSPRO)]
			   ,(CASE WHEN ISNULL(@resetDates, 0) = 1 THEN GETDATE() ELSE [Std Date] END)
			   ,[COGS]
			   ,[Labour Cost]
			   ,[Made In Material]
			   ,[Bought Out Material]
			   ,[Machine Shop]
			   ,[Axles]
			   ,[Stakes/Bunks]
			   ,[Beam]
			   ,[GNK]
			   ,[Parts]
			   ,[Subs]
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
			   ,[Margins Base]
			   ,[Margins Options]
			   ,[Top Level Part# (SYSPRO 8)]
			   ,@compidto
			   ,NULL  -- [Operation1Hours]
			   ,NULL  -- [Operation2Hours]
			   ,NULL  -- [Operation3Hours]
			   ,NULL  -- [Operation4Hours]
			   ,NULL  -- [Operation5Hours]
			   ,NULL  -- [Operation6Hours]
			   ,NULL  -- [Operation7Hours]
			   ,NULL  -- [Operation8Hours]
			   ,NULL  -- [Operation9Hours]
			   ,NULL  -- [Operation10Hours]
			   ,NULL  -- [Operation11Hours]
			   ,NULL  -- [Operation12Hours]
			   ,NULL  -- [Operation13Hours]
			   ,NULL  -- [Operation14Hours]
			   ,NULL  -- [Operation15Hours]
			   ,NULL  -- [Operation16Hours]
			   ,NULL  -- [Operation17Hours]
			   ,[Galvanized]
			FROM
				[Budget Std]
			WHERE
				[Model No] = @modelnoFrom
			;
		END
		
		IF ISNULL(@validNewBOpt, 0) = 1 BEGIN
			INSERT INTO
				[dbo].[Budget Options V2]
			(
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
			   ,[CompanyID]
			   ,[Operation1Hours]
			   ,[Operation2Hours]
			   ,[Operation3Hours]
			   ,[Operation4Hours]
			   ,[Operation5Hours]
			   ,[Operation6Hours]
			   ,[Operation7Hours]
			   ,[Operation8Hours]
			   ,[Operation9Hours]
			   ,[Operation10Hours]
			   ,[Operation11Hours]
			   ,[Operation12Hours]
			   ,[Operation13Hours]
			   ,[Operation14Hours]
			   ,[Operation15Hours]
			   ,[Operation16Hours]
			   ,[Operation17Hours]
			   ,[Galvanized]
			)
			SELECT
				(CASE WHEN ISNULL(@resetDates, 0) = 1 THEN GETDATE() ELSE [Bud_Date_Opt] END)
			   ,@modelnoTo
			   ,@modelnoTo + '-' + RIGHT('00000' + ISNULL([Option No], ''), 5)
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
			   ,NULL  -- [Operation1Hours]
			   ,NULL  -- [Operation2Hours]
			   ,NULL  -- [Operation3Hours]
			   ,NULL  -- [Operation4Hours]
			   ,NULL  -- [Operation5Hours]
			   ,NULL  -- [Operation6Hours]
			   ,NULL  -- [Operation7Hours]
			   ,NULL  -- [Operation8Hours]
			   ,NULL  -- [Operation9Hours]
			   ,NULL  -- [Operation10Hours]
			   ,NULL  -- [Operation11Hours]
			   ,NULL  -- [Operation12Hours]
			   ,NULL  -- [Operation13Hours]
			   ,NULL  -- [Operation14Hours]
			   ,NULL  -- [Operation15Hours]
			   ,NULL  -- [Operation16Hours]
			   ,NULL  -- [Operation17Hours]
			   ,[Galvanized]
			FROM
				[Budget Options]
			WHERE
				[Model No] = @modelnoFrom
			;
		END
		
		IF ISNULL(@validNewOFac, 0) = 1 BEGIN
			INSERT INTO 
				[dbo].[Options V2_FactoryLines]
			(
				[Stock Code (SYSPRO)]
			   ,[Model No]
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
			SELECT
				NULL  -- [Stock Code (SYSPRO)]
			   ,@modelnoTo
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
				[Options_FactoryLines]
			WHERE
				[Model No] = @modelnoFrom
			;
		END
		
		IF ISNULL(@validNewOSpc, 0) = 1 BEGIN
			INSERT INTO 
				[dbo].[Options V2_SpecLines]
			(
				[Stock Code (SYSPRO)]
			   ,[Model No]
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
			SELECT
				NULL  -- [Stock Code (SYSPRO)]
			   ,@modelnoTo
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
				[Options_SpecLines]
			WHERE
				[Model No] = @modelnoFrom
			;
		END
		
		IF ISNULL(@validNewSNTp, 0) = 1 BEGIN
			INSERT INTO 
				[dbo].[SN Type V2]
			(
				[Model No]
			   ,[MNT1]
			   ,[MNT2]
			   ,[Position4]
			   ,[Position5]
			   ,[Position6]
			   ,[Position7]
			   ,[Position8]
			   ,[CompanyID]
			)
			SELECT
				@modelnoTo
			   ,[MNT1]
			   ,[MNT2]
			   ,[Position4]
			   ,[Position5]
			   ,[Position6]
			   ,[Position7]
			   ,[Position8]
			   ,@compidto
			FROM
				[SN Type]
			WHERE
				([Model No] = @modelnoFrom)
				AND ([CompanyID] = @compidfrom)
			;
		END

	END
	ELSE BEGIN
		-- Copy STG -> BWS
	END
END
ELSE BEGIN
	IF @compidfrom = 1 BEGIN
		-- Copy BWS -> BWS
	END
	ELSE BEGIN
		-- Copy STG -> STG
	END
END


/*
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
				[ProductsV2]
			WHERE
				[Model No] = @modelnoFrom
				and CompanyID = @compidfrom
			;

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


DECLARE
	@modelnoTo nvarchar(255) = 'AFED2X',
	@modelnoFrom nvarchar(255) = 'AFED2X',
	@compidfrom int = 1,
	@compidto int = 0;

BEGIN TRAN;
IF (@compidfrom = 1) AND (@compidto = 0) BEGIN

	INSERT INTO 
		[BWSdb].[dbo].[SN Type]
	(
		[Model No],
		[MNT1],
		[MNT2],
		[Position4],
		[Position5],
		[Position6],
		[Position7],
		[Position8],
		[CompanyID]
	)
	SELECT
		@modelnoTo,
		[MNT1],
		[MNT2],
		[Position4],
		[Position5],
		[Position6],
		[Position7],
		[Position8],
		@compidto
	FROM
		[BWSdb].[dbo].[SN Type]
	WHERE
		([Model No] = @modelnoFrom)
		AND ([CompanyID] = @compidfrom)
END
ELSE BEGIN
	INSERT INTO 
		[BWSdb].[dbo].[SN Type V2]
	(
		[Model No],
		[MNT1],
		[MNT2],
		[Position4],
		[Position5],
		[Position6],
		[Position7],
		[Position8],
		[CompanyID]
	)
	SELECT
		@modelnoTo,
		[MNT1],
		[MNT2],
		[Position4],
		[Position5],
		[Position6],
		[Position7],
		[Position8],
		@compidto
	FROM
		[BWSdb].[dbo].[SN Type V2]
	WHERE
		([Model No] = @modelnoFrom)
		AND ([CompanyID] = @compidfrom)
END

ROLLBACK;
COMMIT;
*/