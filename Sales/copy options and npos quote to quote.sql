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
		[MQuoteFrom] NVARCHAR(MAX),
		[MQuoteTo] NVARCHAR(MAX),
		[NewWO] NVARCHAR(MAX),
		[NewQuoteDate] DATETIME,
        [NewOrderDate] DATETIME
		--,[NewPrice] MONEY
	);
	INSERT INTO @t (
		[MQuoteFrom],
		[MQuoteTo]
	) VALUES 
		('SG101133', 'SG101135'),
		('SG101134', 'SG101136')
	;

	UPDATE
		[@t]
	SET
		[NewWO] = [WO#],
		[NewQuoteDate] = [Quote Date],
        [NewOrderDate] = [Order Date]
		--,[NewPrice] = [Price]
	FROM
		[OrdersV2]
	INNER JOIN
		@t
	ON
		[OrdersV2].[SGQuote] = [@t].[MQuoteTo]
	;
	
	DECLARE @i AS INT = 0, @c AS INT = 0;
	DECLARE @msg AS NVARCHAR(MAX);
	DECLARE @m1 AS NVARCHAR(MAX), @m2 AS NVARCHAR(MAX);
	DECLARE @q1 AS NVARCHAR(MAX), @q2 AS NVARCHAR(MAX);
	SELECT @c = COUNT(*) FROM @t;

	PRINT '@i = ' + CAST(@i AS NVARCHAR(MAX)) + ', @c = ' + CAST(@c AS NVARCHAR(MAX));
	PRINT 'HERE 1';

	WHILE @i < @c BEGIN
	
		SELECT @m1 = [ProductsV2].[Model No], @q1 = [MQuoteFrom] FROM [ProductsV2] INNER JOIN [OrdersV2] ON [ProductsV2].[Model No] = [OrdersV2].[Model No] INNER JOIN @t ON [OrdersV2].[SGQuote] = [@t].[MQuoteFrom] WHERE [ID] = @i;
		SELECT @m2 = [ProductsV2].[Model No], @q2 = [MQuoteTo] FROM [ProductsV2] INNER JOIN [OrdersV2] ON [ProductsV2].[Model No] = [OrdersV2].[Model No] INNER JOIN @t ON [OrdersV2].[SGQuote] = [@t].[MQuoteTo] WHERE [ID] = @i;

		PRINT '@i= ' + CAST(@i AS NVARCHAR(MAX)) + ', @m1 = ''' + @m1 + ''', @m2 = ''' + @m2 + '''.'
		
		IF @m1 <> @m2 BEGIN
			-- QUIT

			SELECT @msg = 'All models must match in order to copy quote options.\n Quote ''' + @q1 + ''' (' + @m1 + ') does not match quote ''' + @q2 + ''' (' + @m2 + ').';

			ROLLBACK;
			RAISERROR(@msg, 16, 1);
		END

		SELECT @i = @i + 1;
	END

	SELECT * FROM @t;
	PRINT 'Good to go';

	IF @deleteExisting = 1 AND @doUpdate = 1 BEGIN
	
		PRINT 'Performing Deletes'
		
		-- Order OptionsV2
		DELETE 
			[Order OptionsV2]
		FROM
			[Order OptionsV2]
		INNER JOIN
			@t
		ON
			[Order OptionsV2].[SGQuote] = [@t].[MQuoteTo]
		;
		-- Order OptionsV2_FactoryLines
		DELETE 
			[Order OptionsV2_FactoryLines]
		FROM
			[Order OptionsV2_FactoryLines]
		INNER JOIN
			@t
		ON
			[Order OptionsV2_FactoryLines].[SGQuote] = [@t].[MQuoteTo]
		;
		-- Order OptionsV2_SpecLines
		DELETE 
			[Order OptionsV2_SpecLines]
		FROM
			[Order OptionsV2_SpecLines]
		INNER JOIN
			@t
		ON
			[Order OptionsV2_SpecLines].[SGQuote] = [@t].[MQuoteTo]
		;
		-- Custom WorkV2
		DELETE 
			[Custom WorkV2]
		FROM
			[Custom WorkV2]
		INNER JOIN
			@t
		ON
			[Custom WorkV2].[SGQuote] = [@t].[MQuoteTo]
		;
		-- Custom WorkV2_FactoryLines
		DELETE 
			[Custom WorkV2_FactoryLines]
		FROM
			[Custom WorkV2_FactoryLines]
		INNER JOIN
			@t
		ON
			[Custom WorkV2_FactoryLines].[SGQuote] = [@t].[MQuoteTo]
		;
		-- Custom WorkV2_SpecLines
		DELETE 
			[Custom WorkV2_SpecLines]
		FROM
			[Custom WorkV2_SpecLines]
		INNER JOIN
			@t
		ON
			[Custom WorkV2_SpecLines].[SGQuote] = [@t].[MQuoteTo]
		;
	END
	ELSE BEGIN 
		PRINT 'Skipped Deletes'
	END

	PRINT 'After Deletes'
	
	-- New Inserts

	-- Order OptionsV2
	
	SELECT
		'BEF Order OptionsV2' AS [T]
		, *
	FROM 
		[Order OptionsV2] AS [A]
	INNER JOIN
		@t
	ON
		[A].[SGQuote] = [@t].[MQuoteFrom]
	;

	IF @doUpdate = 1 BEGIN
	
		INSERT INTO
			[Order OptionsV2]
		(
			[Quote Date]
           ,[Order Date]
           ,[WO#]
           ,[SGQuote]
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
			[Order OptionsV2] AS [A]
		INNER JOIN
			@t
		ON
			[A].[SGQuote] = [@t].[MQuoteFrom]
		;

		SELECT
			'AFT Order OptionsV2' AS [T]
			, *
		FROM 
			[Order OptionsV2] AS [A]
		INNER JOIN
			@t
		ON
			[A].[SGQuote] = [@t].[MQuoteTo]
		;
	END

	-- Order OptionsV2_FactoryLines
	
	SELECT
		'BEF Order OptionsV2_FactoryLines' AS [T]
		, *
	FROM 
		[Order OptionsV2_FactoryLines] AS [A]
	INNER JOIN
		@t
	ON
		[A].[SGQuote] = [@t].[MQuoteFrom]
	;
	
	IF @doUpdate = 1 BEGIN

		INSERT INTO
			[Order OptionsV2_FactoryLines]
		(
			[WO#]
           ,[SGQuote]
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
			[Order OptionsV2_FactoryLines]
		INNER JOIN
			@t
		ON
			[Order OptionsV2_FactoryLines].[SGQuote] = [@t].[MQuoteFrom] 
		;

		SELECT
			'AFT Order OptionsV2_FactoryLines' AS [T]
			, *
		FROM 
			[Order OptionsV2_FactoryLines] AS [A]
		INNER JOIN
			@t
		ON
			[A].[SGQuote] = [@t].[MQuoteTo]
		;
	END

	-- Order OptionsV2_SpecLines
	
	SELECT
		'BEF Order OptionsV2_SpecLines' AS [T]
		, *
	FROM 
		[Order OptionsV2_SpecLines] AS [A]
	INNER JOIN
		@t
	ON
		[A].[SGQuote] = [@t].[MQuoteFrom]
	;
	IF @doUpdate = 1 BEGIN
		INSERT INTO
			[Order OptionsV2_SpecLines]
		(
			[WO#]
           ,[SGQuote]
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
			[Order OptionsV2_SpecLines]
		INNER JOIN
			@t
		ON
			[Order OptionsV2_SpecLines].[SGQuote] = [@t].[MQuoteFrom]
		;
		SELECT
			'AFT Order OptionsV2_SpecLines' AS [T]
			, *
		FROM 
			[Order OptionsV2_SpecLines] AS [A]
		INNER JOIN
			@t
		ON
			[A].[SGQuote] = [@t].[MQuoteTo]
		;
	END

	-- Custom WorkV2
	
	SELECT
		'BEF Custom WorkV2' AS [T]
		, *
	FROM 
		[Custom WorkV2] AS [A]
	INNER JOIN
		@t
	ON
		[A].[SGQuote] = [@t].[MQuoteFrom]
	;

	IF @doUpdate = 1 BEGIN
		INSERT INTO
			[Custom WorkV2]
		(
			[Quote Date]
           ,[SGQuote]
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
			[Custom WorkV2]
		INNER JOIN
			@t
		ON
			[Custom WorkV2].[SGQuote] = [@t].[MQuoteFrom]
		;
		SELECT
			'AFT Custom WorkV2' AS [T]
			, *
		FROM 
			[Custom WorkV2] AS [A]
		INNER JOIN
			@t
		ON
			[A].[SGQuote] = [@t].[MQuoteTo]
		;
	END

	-- Custom WorkV2_FactoryLines

	SELECT
		'BEF Custom WorkV2_FactoryLines' AS [T]
		, *
	FROM 
		[Custom WorkV2_FactoryLines] AS [A]
	INNER JOIN
		@t
	ON
		[A].[SGQuote] = [@t].[MQuoteFrom]
	;

	IF @doUpdate = 1 BEGIN
		INSERT INTO
			[Custom WorkV2_FactoryLines]
		(
			[SGQuote]
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
			[Custom WorkV2_FactoryLines]
		INNER JOIN
			@t
		ON
			[Custom WorkV2_FactoryLines].[SGQuote] = [@t].[MQuoteFrom]
		;
		SELECT
			'AFT Custom WorkV2_FactoryLines' AS [T]
			, *
		FROM 
			[Custom WorkV2_FactoryLines] AS [A]
		INNER JOIN
			@t
		ON
			[A].[SGQuote] = [@t].[MQuoteTo]
		;
	END

	-- Custom WorkV2_SpecLines

	SELECT
		'BEF Custom WorkV2_SpecLines' AS [T]
		, *
	FROM 
		[Custom WorkV2_SpecLines] AS [A]
	INNER JOIN
		@t
	ON
		[A].[SGQuote] = [@t].[MQuoteFrom]
	;

	IF @doUpdate = 1 BEGIN
		INSERT INTO
			[Custom WorkV2_SpecLines]
		(
			[SGQuote]
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
			[Custom WorkV2_SpecLines]
		INNER JOIN
			@t
		ON
			[Custom WorkV2_SpecLines].[SGQuote] = [@t].[MQuoteFrom]
		;
		SELECT
			'AFT Custom WorkV2_SpecLines' AS [T]
			, *
		FROM 
			[Custom WorkV2_SpecLines] AS [A]
		INNER JOIN
			@t
		ON
			[A].[SGQuote] = [@t].[MQuoteTo]
		;
	END

ROLLBACK;
COMMIT;