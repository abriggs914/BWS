USE BWSdb
GO

-- Script to accept two lists of quotes.
-- One list [MQuoteFrom] specifies the quotes to copy options from
-- The other [MQuoteTo] specifies the quotes to copy options to
-- All quotes MUST previously exist AND you may only copy options with quotes of the same model.

BEGIN TRAN;

	DECLARE @doUpdate AS BIT = 1;
	DECLARE @deleteExisting AS BIT = 1;

	DECLARE @t AS TABLE (
		[ID] INT IDENTITY(0, 1),
		[MQuoteFrom] INT,
		[MQuoteTo] INT,
		[NewWO] NVARCHAR(MAX),
		[NewQuoteDate] DATETIME,
        [NewOrderDate] DATETIME
		--,[NewPrice] MONEY
	);
	INSERT INTO @t (
		[MQuoteFrom],
		[MQuoteTo]
	) VALUES 
		(28804, 28805)
	;

	UPDATE
		[@t]
	SET
		[NewWO] = [WO#],
		[NewQuoteDate] = [Quote Date],
        [NewOrderDate] = [Order Date]
		--,[NewPrice] = [Price]
	FROM
		[Orders]
	INNER JOIN
		@t
	ON
		[Orders].[Quote#] = [@t].[MQuoteTo]
	;
	
	DECLARE @i AS INT, @c AS INT;
	DECLARE @msg AS NVARCHAR(MAX);
	DECLARE @m1 AS NVARCHAR(MAX), @m2 AS NVARCHAR(MAX);
	DECLARE @q1 AS NVARCHAR(MAX), @q2 AS NVARCHAR(MAX);
	SELECT @c = COUNT(*) FROM @t;

	WHILE @i < @c BEGIN
	
		SELECT @m1 = [Products].[Model No], @q1 = [MQuoteFrom] FROM [Products] INNER JOIN [Orders] ON [Products].[Model No] = [Orders].[Model No] INNER JOIN @t ON [Orders].[Quote#] = [@t].[MQuoteFrom] WHERE [ID] = @i;
		SELECT @m2 = [Products].[Model No], @q2 = [MQuoteTo] FROM [Products] INNER JOIN [Orders] ON [Products].[Model No] = [Orders].[Model No] INNER JOIN @t ON [Orders].[Quote#] = [@t].[MQuoteTo] WHERE [ID] = @i;
		
		IF @m1 <> @m2 BEGIN
			-- QUIT

			SELECT @msg = 'All models must match in order to copy quote options.\n Quote ''' + @q1 + ''' (' + @m1 + ') does not match quote ''' + @q2 + ''' (' + @m2 + ').';

			ROLLBACK;
			RAISERROR(@msg, 16, 1);
		END

		SELECT @i = @i + 1;
	END

	SELECT * FROM @t
	PRINT 'Good to go'

	IF @deleteExisting = 1 AND @doUpdate = 1 BEGIN
	
		PRINT 'Performing Deletes'
		
		-- Order Options
		DELETE 
			[Order Options]
		FROM
			[Order Options]
		INNER JOIN
			@t
		ON
			[Order Options].[Quote#] = [@t].[MQuoteTo]
		;
		-- Order Options_FactoryLines
		DELETE 
			[Order Options_FactoryLines]
		FROM
			[Order Options_FactoryLines]
		INNER JOIN
			@t
		ON
			[Order Options_FactoryLines].[Quote#] = [@t].[MQuoteTo]
		;
		-- Order Options_SpecLines
		DELETE 
			[Order Options_SpecLines]
		FROM
			[Order Options_SpecLines]
		INNER JOIN
			@t
		ON
			[Order Options_SpecLines].[Quote#] = [@t].[MQuoteTo]
		;
		-- Custom Work
		DELETE 
			[Custom Work]
		FROM
			[Custom Work]
		INNER JOIN
			@t
		ON
			[Custom Work].[Quote#] = [@t].[MQuoteTo]
		;
		-- Custom Work_FactoryLines
		DELETE 
			[Custom Work_FactoryLines]
		FROM
			[Custom Work_FactoryLines]
		INNER JOIN
			@t
		ON
			[Custom Work_FactoryLines].[Quote#] = [@t].[MQuoteTo]
		;
		-- Custom Work_SpecLines
		DELETE 
			[Custom Work_SpecLines]
		FROM
			[Custom Work_SpecLines]
		INNER JOIN
			@t
		ON
			[Custom Work_SpecLines].[Quote#] = [@t].[MQuoteTo]
		;
	END
	ELSE BEGIN 
		PRINT 'Skipped Deletes'
	END

	PRINT 'After Deletes'
	
	-- New Inserts

	-- Order Options
	
	SELECT
		'BEF Order Options' AS [T]
		, *
	FROM 
		[Order Options] AS [A]
	INNER JOIN
		@t
	ON
		[A].[Quote#] = [@t].[MQuoteFrom]
	;

	IF @doUpdate = 1 BEGIN
	
		INSERT INTO
			[Order Options]
		(
			[Quote Date]
           ,[Order Date]
           ,[WO#]
           ,[Quote#]
           ,[Option No]
           ,[Price]
           ,[Qty]
           ,[Sections]
           ,[Description]
           ,[Comments]
           ,[Weight]
           ,[Cost]
           ,[Material Cost]
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
           ,[Start Date]
           ,[End Date]
           ,[SortSe]
           ,[Width]
           ,[Spread]
           ,[Draw/Part#]
           ,[OptionInfo]
           ,[OptionPromptFlag]
           ,[OptionPrompt]
           ,[OptionConfigInfo]
           ,[Are WO Specs Different?]
           ,[Comments V2]
		)		
		SELECT
			[NewQuoteDate]
           ,[NewOrderDate]
           ,[NewWO]
           ,[MQuoteTo]
           ,[Option No]
           ,[Price]
           ,[Qty]
           ,[Sections]
           ,[Description]
           ,[Comments]
           ,[Weight]
           ,[Cost]
           ,[Material Cost]
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
           ,[Start Date]
           ,[End Date]
           ,[SortSe]
           ,[Width]
           ,[Spread]
           ,[Draw/Part#]
           ,[OptionInfo]
           ,[OptionPromptFlag]
           ,[OptionPrompt]
           ,[OptionConfigInfo]
           ,[Are WO Specs Different?]
           ,[Comments V2]
		FROM 
			[Order Options] AS [A]
		INNER JOIN
			@t
		ON
			[A].[Quote#] = [@t].[MQuoteFrom]
		;

		SELECT
			'AFT Order Options' AS [T]
			, *
		FROM 
			[Order Options] AS [A]
		INNER JOIN
			@t
		ON
			[A].[Quote#] = [@t].[MQuoteTo]
		;
	END

	-- Order Options_FactoryLines
	
	SELECT
		'BEF Order Options_FactoryLines' AS [T]
		, *
	FROM 
		[Order Options_FactoryLines] AS [A]
	INNER JOIN
		@t
	ON
		[A].[Quote#] = [@t].[MQuoteFrom]
	;
	
	IF @doUpdate = 1 BEGIN

		INSERT INTO
			[Order Options_FactoryLines]
		(
			[WO#]
           ,[Quote#]
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
           ,[OrderOptionID]
		)
		SELECT
			[NewWO]
           ,[MQuoteTo]
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
           ,[OrderOptionID]
		FROM
			[Order Options_FactoryLines]
		INNER JOIN
			@t
		ON
			[Order Options_FactoryLines].[Quote#] = [@t].[MQuoteFrom] 
		;

		SELECT
			'AFT Order Options_FactoryLines' AS [T]
			, *
		FROM 
			[Order Options_FactoryLines] AS [A]
		INNER JOIN
			@t
		ON
			[A].[Quote#] = [@t].[MQuoteTo]
		;
	END

	-- Order Options_SpecLines
	
	SELECT
		'BEF Order Options_SpecLines' AS [T]
		, *
	FROM 
		[Order Options_SpecLines] AS [A]
	INNER JOIN
		@t
	ON
		[A].[Quote#] = [@t].[MQuoteFrom]
	;
	IF @doUpdate = 1 BEGIN
		INSERT INTO
			[Order Options_SpecLines]
		(
			[WO#]
           ,[Quote#]
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
           ,[OrderOptionID]
		)
		SELECT
			[NewWO]
           ,[MQuoteTo]
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
           ,[OrderOptionID]
		FROM
			[Order Options_SpecLines]
		INNER JOIN
			@t
		ON
			[Order Options_SpecLines].[Quote#] = [@t].[MQuoteFrom]
		;
		SELECT
			'AFT Order Options_SpecLines' AS [T]
			, *
		FROM 
			[Order Options_SpecLines] AS [A]
		INNER JOIN
			@t
		ON
			[A].[Quote#] = [@t].[MQuoteTo]
		;
	END

	-- Custom Work
	
	SELECT
		'BEF Custom Work' AS [T]
		, *
	FROM 
		[Custom Work] AS [A]
	INNER JOIN
		@t
	ON
		[A].[Quote#] = [@t].[MQuoteFrom]
	;

	IF @doUpdate = 1 BEGIN
		INSERT INTO
			[Custom Work]
		(
			[Quote Date]
           ,[Quote#]
           ,[Order Date]
           ,[WO#]
           ,[Section]
           ,[SortSe]
           ,[Description]
           ,[Qty]
           ,[Price]
           ,[Cost]
           ,[Labour Cost]
           ,[Made In Material]
           ,[Bought Out Material]
           ,[Weight]
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
           ,[Eng Hours]
           ,[Option Date]
           ,[Draw/Part#]
           ,[NPOInfo]
           ,[NPOPromptFlag]
           ,[NPOPrompt]
           ,[NPOConfigInfo]
           ,[NPOExpirationDate]
           ,[US Price]
           ,[Are WO Specs Different?]
		)
		SELECT
			[NewQuoteDate]
           ,[MQuoteTo]
           ,[NewOrderDate]
           ,[NewWO]
           ,[Section]
           ,[SortSe]
           ,[Description]
           ,[Qty]
           ,[Price]
           ,[Cost]
           ,[Labour Cost]
           ,[Made In Material]
           ,[Bought Out Material]
           ,[Weight]
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
           ,[Eng Hours]
           ,[Option Date]
           ,[Draw/Part#]
           ,[NPOInfo]
           ,[NPOPromptFlag]
           ,[NPOPrompt]
           ,[NPOConfigInfo]
           ,[NPOExpirationDate]
           ,[US Price]
           ,[Are WO Specs Different?]
		FROM
			[Custom Work]
		INNER JOIN
			@t
		ON
			[Custom Work].[Quote#] = [@t].[MQuoteFrom]
		;
		SELECT
			'AFT Custom Work' AS [T]
			, *
		FROM 
			[Custom Work] AS [A]
		INNER JOIN
			@t
		ON
			[A].[Quote#] = [@t].[MQuoteTo]
		;
	END

	-- Custom Work_FactoryLines

	SELECT
		'BEF Custom Work_FactoryLines' AS [T]
		, *
	FROM 
		[Custom Work_FactoryLines] AS [A]
	INNER JOIN
		@t
	ON
		[A].[Quote#] = [@t].[MQuoteFrom]
	;

	IF @doUpdate = 1 BEGIN
		INSERT INTO
			[Custom Work_FactoryLines]
		(
			[Quote#]
           ,[WO#]
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
           ,[NPOID]
		)
		SELECT
			[MQuoteTo]
           ,[NewWO]
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
           ,[NPOID]
		FROM
			[Custom Work_FactoryLines]
		INNER JOIN
			@t
		ON
			[Custom Work_FactoryLines].[Quote#] = [@t].[MQuoteFrom]
		;
		SELECT
			'AFT Custom Work_FactoryLines' AS [T]
			, *
		FROM 
			[Custom Work_FactoryLines] AS [A]
		INNER JOIN
			@t
		ON
			[A].[Quote#] = [@t].[MQuoteTo]
		;
	END

	-- Custom Work_SpecLines

	SELECT
		'BEF Custom Work_SpecLines' AS [T]
		, *
	FROM 
		[Custom Work_SpecLines] AS [A]
	INNER JOIN
		@t
	ON
		[A].[Quote#] = [@t].[MQuoteFrom]
	;

	IF @doUpdate = 1 BEGIN
		INSERT INTO
			[Custom Work_SpecLines]
		(
			[Quote#]
           ,[WO#]
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
           ,[NPOID]
		)
		SELECT
			[MQuoteTo]
           ,[NewWO]
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
           ,[NPOID]
		FROM
			[Custom Work_SpecLines]
		INNER JOIN
			@t
		ON
			[Custom Work_SpecLines].[Quote#] = [@t].[MQuoteFrom]
		;
		SELECT
			'AFT Custom Work_SpecLines' AS [T]
			, *
		FROM 
			[Custom Work_SpecLines] AS [A]
		INNER JOIN
			@t
		ON
			[A].[Quote#] = [@t].[MQuoteTo]
		;
	END

ROLLBACK;
COMMIT;