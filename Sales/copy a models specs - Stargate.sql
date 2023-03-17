
USE BWSdb
GO

-- Stargate
-- Copy a models everything.

BEGIN TRAN;

	DECLARE @doUpdate AS BIT = 1;

	DECLARE @t AS TABLE (
		[ID] INT IDENTITY(0, 1),
		[MCopyFrom] NVARCHAR(MAX),
		[MCopyTo] NVARCHAR(MAX),
		[Class] NVARCHAR(MAX),
		[Proposed] BIT DEFAULT(1),
		[Non-Current] BIT DEFAULT(0)
	);
	INSERT INTO @t (
		[MCopyFrom],
		[MCopyTo],
		[Class]
	) VALUES 
		('End Dump 3X', 'BTL3X+2X', 'B-Trains')
	;
	
	-- Whether or not to ensure all models are new to tables
	DECLARE @assertAllNew AS BIT = 0;
	DECLARE @assertNewProd AS BIT = 1;
	DECLARE @assertNewStan AS BIT = 1;
	DECLARE @assertNewOptn AS BIT = 1;
	DECLARE @assertNewBStd AS BIT = 1;
	DECLARE @assertNewBOpt AS BIT = 1;
	DECLARE @assertNewOFac AS BIT = 1;
	DECLARE @assertNewOSpc AS BIT = 1;
	DECLARE @assertNewSNTp AS BIT = 1;

	-- If the table insert is valid based on asserts
	DECLARE @validAllNew AS BIT = 0;
	DECLARE @validNewProd AS BIT = 0;
	DECLARE @validNewStan AS BIT = 0;
	DECLARE @validNewOptn AS BIT = 0;
	DECLARE @validNewBStd AS BIT = 0;
	DECLARE @validNewBOpt AS BIT = 0;
	DECLARE @validNewOFac AS BIT = 0;
	DECLARE @validNewOSpc AS BIT = 0;
	DECLARE @validNewSNTp AS BIT = 0;

	DECLARE @countNewProd AS INT = 0;
	DECLARE @countNewStan AS INT = 0;
	DECLARE @countNewOptn AS INT = 0;
	DECLARE @countNewBStd AS INT = 0;
	DECLARE @countNewBOpt AS INT = 0;
	DECLARE @countNewOFac AS INT = 0;
	DECLARE @countNewOSpc AS INT = 0;
	DECLARE @countNewSNTp AS INT = 0;
	
	SELECT @countNewProd = COUNT(*) FROM [ProductsV2]				AS [A] INNER JOIN @t ON [A].[Model No] = [@t].[MCopyTo];
	SELECT @countNewStan = COUNT(*) FROM [StandardsV2]				AS [A] INNER JOIN @t ON [A].[Model No] = [@t].[MCopyTo];
	SELECT @countNewOptn = COUNT(*) FROM [OptionsV2]				AS [A] INNER JOIN @t ON [A].[Model No] = [@t].[MCopyTo];
	SELECT @countNewBStd = COUNT(*) FROM [Budget Std V2]			AS [A] INNER JOIN @t ON [A].[Model No] = [@t].[MCopyTo];
	SELECT @countNewBOpt = COUNT(*) FROM [Budget Options V2]		AS [A] INNER JOIN @t ON [A].[Model No] = [@t].[MCopyTo];
	SELECT @countNewOFac = COUNT(*) FROM [Options V2_FactoryLines]	AS [A] INNER JOIN @t ON [A].[Model No] = [@t].[MCopyTo];
	SELECT @countNewOSpc = COUNT(*) FROM [Options V2_SpecLines]		AS [A] INNER JOIN @t ON [A].[Model No] = [@t].[MCopyTo];
	SELECT @countNewSNTp = COUNT(*) FROM [SN Type V2]				AS [A] INNER JOIN @t ON [A].[Model No] = [@t].[MCopyTo];
	
	IF @assertNewProd = 1 BEGIN
		SELECT @validNewProd = (CASE WHEN @countNewProd = 0 THEN 1 ELSE 0 END);
	END
	IF @assertNewStan = 1 BEGIN
		SELECT @validNewStan = (CASE WHEN @countNewStan = 0 THEN 1 ELSE 0 END);
	END
	IF @assertNewOptn = 1 BEGIN
		SELECT @validNewOptn = (CASE WHEN @countNewOptn = 0 THEN 1 ELSE 0 END);
	END
	IF @assertNewBStd = 1 BEGIN
		SELECT @validNewBStd = (CASE WHEN @countNewBStd = 0 THEN 1 ELSE 0 END);
	END
	IF @assertNewBOpt = 1 BEGIN
		SELECT @validNewBOpt = (CASE WHEN @countNewBOpt = 0 THEN 1 ELSE 0 END);
	END
	IF @assertNewOFac = 1 BEGIN
		SELECT @validNewOFac = (CASE WHEN @countNewOFac = 0 THEN 1 ELSE 0 END);
	END
	IF @assertNewOSpc = 1 BEGIN
		SELECT @validNewOSpc = (CASE WHEN @countNewOSpc = 0 THEN 1 ELSE 0 END);
	END
	IF @assertNewSNTp = 1 BEGIN
		SELECT @validNewSNTp = (CASE WHEN @countNewSNTp = 0 THEN 1 ELSE 0 END);
	END

	--IF @assertAllNew = 1 BEGIN
		-- Ensure all other toggles are met
	SELECT @validAllNew = (CASE WHEN @assertAllNew = 1 THEN
		(CASE WHEN
			(CASE WHEN @validNewProd = 1 THEN 0 ELSE 1 END) +
			(CASE WHEN @validNewStan = 1 THEN 0 ELSE 1 END) +
			(CASE WHEN @validNewOptn = 1 THEN 0 ELSE 1 END) +
			(CASE WHEN @validNewBStd = 1 THEN 0 ELSE 1 END) +
			(CASE WHEN @validNewBOpt = 1 THEN 0 ELSE 1 END) +
			(CASE WHEN @validNewOFac = 1 THEN 0 ELSE 1 END) +
			(CASE WHEN @validNewOSpc = 1 THEN 0 ELSE 1 END) +
			(CASE WHEN @validNewSNTp = 1 THEN 0 ELSE 1 END)
			= 0
		THEN
			1
		ELSE
			0
		END)
	ELSE 1 END)
	--END

	IF @validAllNew = 1 BEGIN

	----------------------------------------------------------------------------------------------------------------------

	-- Begin Products

	SELECT
		'Bef ProductsV2' AS [T],
		*
	FROM
		[ProductsV2]
	INNER JOIN
		@t AS [T]
	ON
		[ProductsV2].[Model No] = [T].[MCopyFrom]
		OR [ProductsV2].[Model No] = [T].[MCopyTo]
	;

	IF @doUpdate = 1 BEGIN

		INSERT INTO
			[ProductsV2]
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
		)
		SELECT
			[T].[Class]
			,1
			,0
		
			,[T].[MCopyTo]
			,[T].[MCopyTo]

			,[Top Level Part# (SYSPRO)]
			,[Grouping]
			,GETDATE()
			,DATEADD(YEAR, 1, GETDATE())
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
		FROM
			[ProductsV2]
		INNER JOIN
			@t AS [T]
		ON
			[ProductsV2].[Model No] = [T].[MCopyFrom]
		;
	
		SELECT
			'Aft ProductsV2' AS [T],
			*
		FROM
			[ProductsV2]
		INNER JOIN
			@t AS [T]
		ON
			[ProductsV2].[Model No] = [T].[MCopyFrom]
			OR [ProductsV2].[Model No] = [T].[MCopyTo]
		;

	END

	-- End Products

	----------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------

	-- Begin Standards

	SELECT
		'Bef StandardsV2' AS [T],
		*
	FROM
		[StandardsV2]
	INNER JOIN
		@t AS [T]
	ON
		[StandardsV2].[Model No] = [T].[MCopyFrom]
		OR [StandardsV2].[Model No] = [T].[MCopyTo]
	;

	IF @doUpdate = 1 BEGIN

		INSERT INTO
			[StandardsV2]
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
		)
		SELECT
		
			[T].[MCopyTo]
			,[T].[MCopyTo] + '-' + RIGHT('00000' + CAST(
			ROW_NUMBER() OVER(
				ORDER BY
					[SortG],
					[SortSe]
			)
			AS NVARCHAR(MAX)), 5)

			   ,[Group]
			   ,[Section]
			   ,[Description]
			   ,GETDATE()
			   ,DATEADD(YEAR, 1, GETDATE())
			   ,[SortG]
			   ,[SortSe]
			   ,[Selection]
			   ,[SortGv2]
			   ,[SortSev2]
			   ,[New Spec Wording]
			   ,[CompanyID]
		FROM
			[StandardsV2]
		INNER JOIN
			@t AS [T]
		ON
			[StandardsV2].[Model No] = [T].[MCopyFrom]
		ORDER BY
			[SortG],
			[SortSe]
		;

		SELECT 
			'Aft StandardsV2' AS [T],
			*
		FROM
			[StandardsV2]
		INNER JOIN
			@t AS [T]
		ON
			[StandardsV2].[Model No] = [T].[MCopyFrom]
			OR [StandardsV2].[Model No] = [T].[MCopyTo]
		;

	END

	-- End Standards

	----------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------

	-- Begin Options

	SELECT
		'Bef OptionsV2' AS [T],
		*
	FROM
		[OptionsV2]
	INNER JOIN
		@t AS [T]
	ON
		[OptionsV2].[Model No] = [T].[MCopyFrom]
		OR [OptionsV2].[Model No] = [T].[MCopyTo]
	;

	IF @doUpdate = 1 BEGIN

		INSERT INTO
			[OptionsV2]
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
		)
		SELECT
		
			[T].[MCopyTo]
			,[T].[MCopyTo] + '-' + RIGHT('00000' + CAST(
			ROW_NUMBER() OVER(
				ORDER BY
					[SortSe]
			)
			AS NVARCHAR(MAX)), 5)
			   ,GETDATE()
			   ,DATEADD(YEAR,1, GETDATE())
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
		FROM
			[OptionsV2]
		INNER JOIN
			@t AS [T]
		ON
			[OptionsV2].[Model No] = [T].[MCopyFrom]
		ORDER BY
			[SortSe]
		;
	
		SELECT
			'Aft OptionsV2' AS [T],
			*
		FROM
			[OptionsV2]
		INNER JOIN
			@t AS [T]
		ON
			[OptionsV2].[Model No] = [T].[MCopyFrom]
			OR [OptionsV2].[Model No] = [T].[MCopyTo]
		;

	END

	-- End Options

	----------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------

	-- Begin Budget Std V2

	SELECT
		'Bef Budget Std V2' AS [T],
		*
	FROM
		[Budget Std V2]
	INNER JOIN
		@t AS [T]
	ON
		[Budget Std V2].[Model No] = [T].[MCopyFrom]
		OR [Budget Std V2].[Model No] = [T].[MCopyTo]

	IF @doUpdate = 1 BEGIN
		INSERT INTO
			[Budget Std V2]
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
		) 
		SELECT
			[T].[MCopyTo]
			   ,NULL
			   ,GETDATE()
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
			FROM 
				[Budget Std V2]
			INNER JOIN
				@t AS [T]
			ON
				[Budget Std V2].[Model No] = [T].[MCopyFrom]
		;

		SELECT
			'Aft Budget Std V2' AS [T],
			*
		FROM
			[Budget Std V2]
		INNER JOIN
			@t AS [T]
		ON
			[Budget Std V2].[Model No] = [T].[MCopyFrom]
			OR [Budget Std V2].[Model No] = [T].[MCopyTo]
	END

	-- End Budget Std V2

	----------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------

	-- Begin Budget Options

	SELECT
		'Bef Budget Options' AS [T],
		*
	FROM
		[Budget Options V2]
	INNER JOIN
		@t AS [T]
	ON
		[Budget Options V2].[Model No] = [T].[MCopyFrom]
		OR [Budget Options V2].[Model No] = [T].[MCopyTo]
	;

	IF @doUpdate = 1 BEGIN
		INSERT INTO
			[Budget Options V2]
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
		)
		SELECT
			GETDATE()
			   ,[T].[MCopyTo]
			,[T].[MCopyTo] + '-' + RIGHT('00000' + CAST(
			ROW_NUMBER() OVER(
				ORDER BY
					[SortSe]
			)
			AS NVARCHAR(MAX)), 5)
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
		FROM
			[Budget Options V2]
		INNER JOIN
			@t AS [T]
		ON
			[Budget Options V2].[Model No] = [T].[MCopyFrom]
		;

		SELECT
			'Aft Budget Options' AS [T],
			*
		FROM
			[Budget Options V2]
		INNER JOIN
			@t AS [T]
		ON
			[Budget Options V2].[Model No] = [T].[MCopyFrom]
			OR [Budget Options V2].[Model No] = [T].[MCopyTo]
		;

	END

	-- End Budget Options

	----------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------

	-- Begin Options V2_SpecLines
	
	SELECT
		'Bef Options V2_SpecLines' AS [T]
		, *
	FROM
		[Options V2_SpecLines]
	INNER JOIN
		@t AS [T]
	ON
		[Options V2_SpecLines].[Model No] = [T].[MCopyFrom]
		OR [Options V2_SpecLines].[Model No] = [T].[MCopyTo]
	ORDER BY
		[SpecSortG]
		, [SpecSortSe]
		, [SpecSortSeLine]

	IF @doUpdate = 1 BEGIN
		INSERT INTO
			[Options V2_SpecLines]
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

			[Stock Code (SYSPRO)]
			   ,[T].[MCopyTo]
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
			[Options V2_SpecLines]
		INNER JOIN
			@t AS [T]
		ON
			[Options V2_SpecLines].[Model No] = [T].[MCopyFrom]
		ORDER BY
			[SpecSortG]
			, [SpecSortSe]
			, [SpecSortSeLine]
		;

		SELECT
			'Aft Options V2_SpecLines' AS [T]
			, *
		FROM
			[Options V2_SpecLines]
		INNER JOIN
			@t AS [T]
		ON
			[Options V2_SpecLines].[Model No] = [T].[MCopyFrom]
			OR [Options V2_SpecLines].[Model No] = [T].[MCopyTo]
		ORDER BY
			[SpecSortG]
			, [SpecSortSe]
			, [SpecSortSeLine]
		;
	END

	-- End Options V2_SpecLines

	----------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------

	-- Begin Options V2_FactoryLines

	SELECT
		'Bef Options V2_FactoryLines' AS [T],
		*
	FROM
		[Options V2_FactoryLines]
	INNER JOIN
		@t AS [T]
	ON
		[Options V2_FactoryLines].[Model No] = [T].[MCopyFrom]
	ORDER BY
		[SpecSortG]
		, [SpecSortSe]
		, [SpecSortSeLine]
	;

	IF @doUpdate = 1 BEGIN
		
		INSERT INTO
			[Options V2_FactoryLines]
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

			[Stock Code (SYSPRO)]
			   ,[T].[MCopyTo]
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
			[Options V2_FactoryLines]
		INNER JOIN
			@t AS [T]
		ON
			[Options V2_FactoryLines].[Model No] = [T].[MCopyFrom]
		ORDER BY
			[SpecSortG]
			, [SpecSortSe]
			, [SpecSortSeLine]
		;

		SELECT
			'Aft Options V2_FactoryLines' AS [T],
			*
		FROM
			[Options V2_FactoryLines]
		INNER JOIN
			@t AS [T]
		ON
			[Options V2_FactoryLines].[Model No] = [T].[MCopyFrom]
		ORDER BY
			[SpecSortG]
			, [SpecSortSe]
			, [SpecSortSeLine]
		;

	END

	-- End Options V2_FactoryLines

	----------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------

	-- Begin SN Type V2

	SELECT
		'Bef SN Type V2' AS [T],
		*
	FROM
		[SN Type V2]
	INNER JOIN
		@t AS [T]
	ON
		[SN Type V2].[Model No] = [T].[MCopyFrom]
		OR [SN Type V2].[Model No] = [T].[MCopyTo]
	;

	IF @doUpdate = 1 BEGIN
		
		INSERT INTO
			[SN Type V2]
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
			[MCopyTo]
           ,[MNT1]
           ,[MNT2]
           ,[Position4]
           ,[Position5]
           ,[Position6]
           ,[Position7]
           ,[Position8]
           ,[CompanyID]
		FROM
			[SN Type V2]
		INNER JOIN
			@t AS [T]
		ON
			[SN Type V2].[Model No] = [T].[MCopyFrom]
		;

		SELECT
			'Aft SN Type V2' AS [T],
			*
		FROM
			[SN Type V2]
		INNER JOIN
			@t AS [T]
		ON
			[SN Type V2].[Model No] = [T].[MCopyFrom]
			OR [SN Type V2].[Model No] = [T].[MCopyTo]
		;
	END
			

	-- End SN Type V2

	----------------------------------------------------------------------------------------------------------------------

	END
	ELSE BEGIN
		PRINT 'NO'
	END
	
ROLLBACK;
COMMIT;