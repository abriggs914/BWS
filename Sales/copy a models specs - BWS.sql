
USE BWSdb
GO

-- BWS
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
		('31LBT3X W', '33LBT3X W', 'Log Western')
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
	
	SELECT @countNewProd = COUNT(*) FROM [Products]				AS [A] INNER JOIN @t ON [A].[Model No] = [@t].[MCopyTo];
	SELECT @countNewStan = COUNT(*) FROM [Standards]			AS [A] INNER JOIN @t ON [A].[Model No] = [@t].[MCopyTo];
	SELECT @countNewOptn = COUNT(*) FROM [Options]				AS [A] INNER JOIN @t ON [A].[Model No] = [@t].[MCopyTo];
	SELECT @countNewBStd = COUNT(*) FROM [Budget Std]			AS [A] INNER JOIN @t ON [A].[Model No] = [@t].[MCopyTo];
	SELECT @countNewBOpt = COUNT(*) FROM [Budget Options]		AS [A] INNER JOIN @t ON [A].[Model No] = [@t].[MCopyTo];
	SELECT @countNewOFac = COUNT(*) FROM [Options_FactoryLines]	AS [A] INNER JOIN @t ON [A].[Model No] = [@t].[MCopyTo];
	SELECT @countNewOSpc = COUNT(*) FROM [Options_SpecLines]	AS [A] INNER JOIN @t ON [A].[Model No] = [@t].[MCopyTo];
	SELECT @countNewSNTp = COUNT(*) FROM [SN Type]				AS [A] INNER JOIN @t ON [A].[Model No] = [@t].[MCopyTo];
	
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
		'Bef Products' AS [T],
		*
	FROM
		[Products]
	INNER JOIN
		@t AS [T]
	ON
		[Products].[Model No] = [T].[MCopyFrom]
		OR [Products].[Model No] = [T].[MCopyTo]
	;

	IF @doUpdate = 1 BEGIN

		INSERT INTO
			[Products]
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
           ,[tmpProductsClassesID]
           ,[QRUS_Discount1]
           ,[QRUS_Discount2]
           ,[QRUS_Discount3]
           ,[QRUS_ExpectedMargin]
           ,[US Price]
           ,[Customer]
           ,[Top Level Part# (SYSPRO 8)]
           ,[Promo Drawing V2]
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
           ,[tmpProductsClassesID]
           ,[QRUS_Discount1]
           ,[QRUS_Discount2]
           ,[QRUS_Discount3]
           ,[QRUS_ExpectedMargin]
           ,[US Price]
           ,[Customer]
           ,[Top Level Part# (SYSPRO 8)]
           ,[Promo Drawing V2]
		FROM
			[Products]
		INNER JOIN
			@t AS [T]
		ON
			[Products].[Model No] = [T].[MCopyFrom]
		;
	
		SELECT
			'Aft Products' AS [T],
			*
		FROM
			[Products]
		INNER JOIN
			@t AS [T]
		ON
			[Products].[Model No] = [T].[MCopyFrom]
			OR [Products].[Model No] = [T].[MCopyTo]
		;

	END

	-- End Products

	----------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------

	-- Begin Standards

	SELECT
		'Bef Standards' AS [T],
		*
	FROM
		[Standards]
	INNER JOIN
		@t AS [T]
	ON
		[Standards].[Model No] = [T].[MCopyFrom]
		OR [Standards].[Model No] = [T].[MCopyTo]
	;

	IF @doUpdate = 1 BEGIN

		INSERT INTO
			[Standards]
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
		FROM
			[Standards]
		INNER JOIN
			@t AS [T]
		ON
			[Standards].[Model No] = [T].[MCopyFrom]
		ORDER BY
			[SortG],
			[SortSe]
		;

		SELECT 
			'Aft Standards' AS [T],
			*
		FROM
			[Standards]
		INNER JOIN
			@t AS [T]
		ON
			[Standards].[Model No] = [T].[MCopyFrom]
			OR [Standards].[Model No] = [T].[MCopyTo]
		;

	END

	-- End Standards

	----------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------

	-- Begin Options

	SELECT
		'Bef Options' AS [T],
		*
	FROM
		[Options]
	INNER JOIN
		@t AS [T]
	ON
		[Options].[Model No] = [T].[MCopyFrom]
		OR [Options].[Model No] = [T].[MCopyTo]
	;

	IF @doUpdate = 1 BEGIN

		INSERT INTO
			[Options]
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
		FROM
			[Options]
		INNER JOIN
			@t AS [T]
		ON
			[Options].[Model No] = [T].[MCopyFrom]
		ORDER BY
			[SortSe]
		;
	
		SELECT
			'Aft Options' AS [T],
			*
		FROM
			[Options]
		INNER JOIN
			@t AS [T]
		ON
			[Options].[Model No] = [T].[MCopyFrom]
			OR [Options].[Model No] = [T].[MCopyTo]
		;

	END

	-- End Options

	----------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------

	-- Begin Budget Std

	SELECT
		'Bef Budget Std' AS [T],
		*
	FROM
		[Budget Std]
	INNER JOIN
		@t AS [T]
	ON
		[Budget Std].[Model No] = [T].[MCopyFrom]
		OR [Budget Std].[Model No] = [T].[MCopyTo]

	IF @doUpdate = 1 BEGIN
		INSERT INTO
			[Budget Std]
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
			FROM 
				[Budget Std]
			INNER JOIN
				@t AS [T]
			ON
				[Budget Std].[Model No] = [T].[MCopyFrom]
		;

		SELECT
			'Aft Budget Std' AS [T],
			*
		FROM
			[Budget Std]
		INNER JOIN
			@t AS [T]
		ON
			[Budget Std].[Model No] = [T].[MCopyFrom]
			OR [Budget Std].[Model No] = [T].[MCopyTo]
	END

	-- End Budget Std

	----------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------

	-- Begin Budget Options

	SELECT
		'Bef Budget Options' AS [T],
		*
	FROM
		[Budget Options]
	INNER JOIN
		@t AS [T]
	ON
		[Budget Options].[Model No] = [T].[MCopyFrom]
		OR [Budget Options].[Model No] = [T].[MCopyTo]
	;

	IF @doUpdate = 1 BEGIN
		INSERT INTO
			[Budget Options]
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
		FROM
			[Budget Options]
		INNER JOIN
			@t AS [T]
		ON
			[Budget Options].[Model No] = [T].[MCopyFrom]
		;

		SELECT
			'Aft Budget Options' AS [T],
			*
		FROM
			[Budget Options]
		INNER JOIN
			@t AS [T]
		ON
			[Budget Options].[Model No] = [T].[MCopyFrom]
			OR [Budget Options].[Model No] = [T].[MCopyTo]
		;

	END

	-- End Budget Options

	----------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------

	-- Begin Options_SpecLines
	
	SELECT
		'Bef Options_SpecLines' AS [T]
		, *
	FROM
		[Options_SpecLines]
	INNER JOIN
		@t AS [T]
	ON
		[Options_SpecLines].[Model No] = [T].[MCopyFrom]
		OR [Options_SpecLines].[Model No] = [T].[MCopyTo]
	ORDER BY
		[SpecSortG]
		, [SpecSortSe]
		, [SpecSortSeLine]

	IF @doUpdate = 1 BEGIN
		INSERT INTO
			[Options_SpecLines]
		(
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
		SELECT

			  [T].[MCopyTo]
			,[T].[MCopyTo] + '-' + RIGHT('00000' + CAST(
			ROW_NUMBER() OVER(
				ORDER BY
					[SpecSortG]
			)
			AS NVARCHAR(MAX)), 5)
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
			[Options_SpecLines]
		INNER JOIN
			@t AS [T]
		ON
			[Options_SpecLines].[Model No] = [T].[MCopyFrom]
		ORDER BY
			[SpecSortG]
			, [SpecSortSe]
			, [SpecSortSeLine]
		;

		SELECT
			'Aft Options_SpecLines' AS [T]
			, *
		FROM
			[Options_SpecLines]
		INNER JOIN
			@t AS [T]
		ON
			[Options_SpecLines].[Model No] = [T].[MCopyFrom]
			OR [Options_SpecLines].[Model No] = [T].[MCopyTo]
		ORDER BY
			[SpecSortG]
			, [SpecSortSe]
			, [SpecSortSeLine]
		;
	END

	-- End Options_SpecLines

	----------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------

	-- Begin Options_FactoryLines

	SELECT
		'Bef Options_FactoryLines' AS [T],
		*
	FROM
		[Options_FactoryLines]
	INNER JOIN
		@t AS [T]
	ON
		[Options_FactoryLines].[Model No] = [T].[MCopyFrom]
	ORDER BY
		[SpecSortG]
		, [SpecSortSe]
		, [SpecSortSeLine]
	;

	IF @doUpdate = 1 BEGIN
		
		INSERT INTO
			[Options_FactoryLines]
		(
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
		SELECT
		
			[T].[MCopyTo]
			,[T].[MCopyTo] + '-' + RIGHT('00000' + CAST(
			ROW_NUMBER() OVER(
				ORDER BY
					[SpecSortG]
			)
			AS NVARCHAR(MAX)), 5)
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
			[Options_FactoryLines]
		INNER JOIN
			@t AS [T]
		ON
			[Options_FactoryLines].[Model No] = [T].[MCopyFrom]
		ORDER BY
			[SpecSortG]
			, [SpecSortSe]
			, [SpecSortSeLine]
		;

		SELECT
			'Aft Options_FactoryLines' AS [T],
			*
		FROM
			[Options_FactoryLines]
		INNER JOIN
			@t AS [T]
		ON
			[Options_FactoryLines].[Model No] = [T].[MCopyFrom]
		ORDER BY
			[SpecSortG]
			, [SpecSortSe]
			, [SpecSortSeLine]
		;

	END

	-- End Options_FactoryLines

	----------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------

	-- Begin SN Type

	SELECT
		'Bef SN Type' AS [T],
		*
	FROM
		[SN Type]
	INNER JOIN
		@t AS [T]
	ON
		[SN Type].[Model No] = [T].[MCopyFrom]
		OR [SN Type].[Model No] = [T].[MCopyTo]
	;

	IF @doUpdate = 1 BEGIN
		
		INSERT INTO
			[SN Type]
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
			[SN Type]
		INNER JOIN
			@t AS [T]
		ON
			[SN Type].[Model No] = [T].[MCopyFrom]
		;

		SELECT
			'Aft SN Type' AS [T],
			*
		FROM
			[SN Type]
		INNER JOIN
			@t AS [T]
		ON
			[SN Type].[Model No] = [T].[MCopyFrom]
			OR [SN Type].[Model No] = [T].[MCopyTo]
		;
	END
			

	-- End SN Type

	----------------------------------------------------------------------------------------------------------------------

	END
	ELSE BEGIN
		PRINT 'NO'
	END
	
ROLLBACK;
COMMIT;