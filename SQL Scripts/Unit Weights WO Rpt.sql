

-- Re-run the WO Rpt from Access and sum the weights of options, NPO's and specs for each given WO.

DECLARE @tWOs AS TABLE([ID] INT IDENTITY(0, 1), [WO] NVARCHAR(8), [Quote] INT, [Weight] INT);
INSERT INTO @tWOs ([WO]) VALUES
('10016246'), ('10016205'), ('10016149'), ('10016098'), ('10016030'),
('10016029'), ('10016028'), ('10016027'), ('10016013'), ('10016011'),
('10016008'), ('10015977'), ('10015976'), ('10015975'), ('10015972'),
('10015971'), ('10015970'), ('10015969'), ('10015968'), ('10015967'),
('10015951'), ('10015950'), ('10015949'), ('10015938'), ('10015937'),
('10015936'), ('10015935'), ('10015916'), ('10015915'), ('10015910'),
('10015763'), ('10015637'), ('10015595'), ('10015589'), ('10015588'),
('10015565'), ('10015522'), ('10015487'), ('10015486'), ('10015485'),
('10015484'), ('10015483'), ('10015482'), ('10015469'), ('10015459'),
('10015377')
;

UPDATE
	@tWOs
SET
	[Quote] = [Quote#]
FROM
	[Orders]
INNER JOIN
	@tWOs
ON
	[Orders].[WO#] = [WO]
;

SELECT * FROM @tWOs

DECLARE 
	@QuoteorWO int,
	@QuoteorWORev int,
	@i int,
	@c int
;

SELECT
	@i = 0,
	@c = COUNT(*) FROM @tWOs
;


WHILE @i < @c BEGIN

	SELECT
		@QuoteorWO = [Quote],
		@QuoteorWORev = 0
	FROM
		@tWOs
	WHERE
		[ID] = @i
	;

	--SELECT
	--	@QuoteorWO AS [Quote]
	--	, @QuoteorWORev AS [Rev]

    -- Insert statements for procedure here
	--Drop and create temp table in tmpdb SQL database for faster processing
	IF OBJECT_ID('tempdb..#specs') IS NOT NULL
		DROP TABLE #specs 

	create table #specs
	(
		SpecID int identity(1, 1),
		[OptionNPOID] int,
		[Quote#] int,
		[WO#] int,
		[Group] nvarchar(255),
		SortGv2 int,
		Section nvarchar(255),
		SortSev2 int,
		SpecSortSeLine int default(0),
		Description nvarchar(max),
		Bold bit default(0),
		Italic bit default(0),
		Underline bit default(0),
		BackColour nvarchar(255) default('Transparent'),
		FontColour nvarchar(255) default('Black'),
		[Steel Kit] float,
		[Axles] float,
		[Step 1] float,
		[Step 2] float,
		[Blast] float,
		[Paint] float,
		[Finish - GNK] float,
		[Final Assembly] float,
		[Tire Assembly] float,
		[Shipping] float,
		[Draw/Part#] nvarchar(255),
		[OptNPOWt] int
	)

	IF OBJECT_ID('tempdb..#optionspecs') IS NOT NULL
		DROP TABLE #optionspecs 

	create table #optionspecs
	(
		OptionSpecID int identity(1, 1),
		[WO#] int,
		[Quote#] int,
		[Option No] nvarchar(255),
		Description nvarchar(max),
		[Line#] int,
		SpecGroup nvarchar(255),
		SpecSortG int,
		SpecSection nvarchar(255),
		SpecSortSe float,
		SpecDescription nvarchar(max),
		SpecDescriptionBold bit,
		SpecDescriptionItalic bit,
		SpecDescriptionUnderline bit,
		SpecDescriptionBackColour nvarchar(255),
		SpecDescriptionFontColour nvarchar(255),
		SpecSortSeLine int,
		OrderOptionID int
	)

	IF OBJECT_ID('tempdb..#npospecs') IS NOT NULL
		DROP TABLE #npospecs 

	create table #npospecs
	(
		NPOSpecID int identity(1, 1),
		[Quote#] int,
		[WO#] int,
		Description nvarchar(max),
		[Line#] int,
		SpecGroup nvarchar(255),
		SpecSortG int,
		SpecSection nvarchar(255),
		SpecSortSe float,
		SpecDescription nvarchar(max),
		SpecDescriptionBold bit,
		SpecDescriptionItalic bit,
		SpecDescriptionUnderline bit,
		SpecDescriptionBackColour nvarchar(255),
		SpecDescriptionFontColour nvarchar(255),
		SpecSortSeLine int,
		NPOID int
	)

	--Create table variable for ft. and in. calculation
	declare @ftandin table
	(
		OptionNPOID int,
		SortGv2 int,
		SortSev2 int,
		Feet int,
		FeetPosition int,
		Inches int,
		InchesPosition int,
		Bold bit default(0),
		Italic bit default(0),
		Underline bit default(0),
		BackColour nvarchar(255) default('Transparent'),
		FontColour nvarchar(255) default('Black'),
		[Steel Kit] float,
		[Axles] float,
		[Step 1] float,
		[Step 2] float,
		[Blast] float,
		[Paint] float,
		[Finish - GNK] float,
		[Final Assembly] float,
		[Tire Assembly] float,
		[Shipping] float,
		[Draw/Part#] nvarchar(255),
		OptNPOWt int,
		Changed bit default(0),
		NPO bit default(0)
	)

	declare @t table
	(
		ID int,
		Description nvarchar(max),
		Starts int,
		Pos int,
		token nvarchar(max)
	)

	--Grab values for Width, Spread and Deck Length WO Headers
	declare @WidthSpreadandDeckLength table
	(
		Quote# int,
		Width int default(0),
		Spread int default(0),
		DeckLength int default(0)
	)

	--Determine which revision is being requested
	declare @maxrev int = case when (select case when max(Rev#) is null then 1 else max(Rev#) end 
									 from Orders_RevHistory with (nolock) where (Quote# = @QuoteorWO or WO# = @QuoteorWO)) is null then 1
							   else (select case when max(Rev#) is null then 1 else max(Rev#) end 
								     from Orders_RevHistory with (nolock) where (Quote# = @QuoteorWO or WO# = @QuoteorWO)) end

	--Generate WO Report based on requested revision		
	if @QuoteorWORev = 0 or @QuoteorWORev = @maxrev
		begin

			--Ensure there are Factory (WO Spec) Lines for @QuoteorWO
			if (select count(*) from [Order Options_FactoryLines] with (nolock) where Quote# = @QuoteorWO or WO# = @QuoteorWO) = 0
				begin
					insert into [Order Options_FactoryLines] with (tablock) ([WO#], [Quote#], [Option No], [Description], [Line#], [SpecGroup], [SpecSortG], [SpecSection], [SpecSortSe], [SpecDescription], 
																			 [SpecDescriptionBold], [SpecDescriptionItalic], [SpecDescriptionUnderline], [SpecDescriptionBackColour], [SpecDescriptionFontColour], [SpecSortSeLine], OrderOptionID)

					select [Order Options].[WO#], [Order Options].[Quote#], [Order Options].[Option No], [Order Options].[Description], [Line#], [SpecGroup], [SpecSortG], [SpecSection], [SpecSortSe], [SpecDescription], 
					[SpecDescriptionBold], [SpecDescriptionItalic], [SpecDescriptionUnderline], [SpecDescriptionBackColour], [SpecDescriptionFontColour], [SpecSortSeLine], [Order Options].ID
					from [Order Options_SpecLines] with (nolock)
					inner join [Order Options] on [Order Options_SpecLines].Quote# = [Order Options].Quote#
												  and [Order Options_SpecLines].OrderOptionID = [Order Options].ID
					where [Order Options].Quote# = @QuoteorWO or [Order Options].WO# = @QuoteorWO
				end

			if (select count(*) from [Custom Work_FactoryLines] with (nolock) where Quote# = @QuoteorWO or WO# = @QuoteorWO) = 0
				begin
					insert into [Custom Work_FactoryLines] with (tablock) ([Quote#], [WO#], [Description], [Line#], [SpecGroup], [SpecSortG], [SpecSection], [SpecSortSe], [SpecDescription], [SpecDescriptionBold], 
																		   [SpecDescriptionItalic], [SpecDescriptionUnderline], [SpecDescriptionBackColour], [SpecDescriptionFontColour], [SpecSortSeLine], [NPOID])
					select [Custom Work].[Quote#], [Custom Work].[WO#], [Custom Work].[Description], [Line#], [SpecGroup], [SpecSortG], [SpecSection], [SpecSortSe], [SpecDescription], 
					[SpecDescriptionBold], [SpecDescriptionItalic], [SpecDescriptionUnderline], [SpecDescriptionBackColour], [SpecDescriptionFontColour], [SpecSortSeLine], [Custom Work].ID
					from [Custom Work_SpecLines] with (nolock)
					inner join [Custom Work] on [Custom Work_SpecLines].Quote# = [Custom Work].Quote#
												  and [Custom Work_SpecLines].NPOID = [Custom Work].ID
					where [Custom Work].Quote# = @QuoteorWO or [Custom Work].WO# = @QuoteorWO
				end

			--Ensure there are NO duplicate WO spec lines
			delete from [Order Options_FactoryLines]
			where (Quote# = @QuoteorWO or WO# = @QuoteorWO)
			and ID not in (select FirstID
							from (select Quote#, WO#, [Option No], Description, SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecDescription, 
								  SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
								  SpecSortSeLine, OrderOptionID, min(ID) as FirstID
								  from [Order Options_FactoryLines] with (nolock)
								  group by Quote#, WO#, [Option No], Description, SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecDescription, 
								  SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
								  SpecSortSeLine, OrderOptionID
								  having count(*) >= 1) as subCount)

			delete from [Custom Work_FactoryLines]
			where (Quote# = @QuoteorWO or WO# = @QuoteorWO)
			and ID not in (select FirstID
							from (select Quote#, WO#, Description, SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecDescription, 
								  SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
								  SpecSortSeLine, NPOID, min(ID) as FirstID
								  from [Custom Work_FactoryLines] with (nolock)
								  group by Quote#, WO#, Description, SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecDescription, 
								  SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
								  SpecSortSeLine, NPOID
								  having count(*) >= 1) as subCount) 

			--Ensure there are Order Hours for @QuoteorWO
			if (select count(*) from [Order Hours] with (nolock) where Quote# = @QuoteorWO or WO# = @QuoteorWO) = 0
				begin
					insert into [Order Hours] with (tablock) ([Quote#], [WO#], [COGS], [Labour Cost], [Made In Material], [Bought Out Material], 
															  [Machine Shop], [Axles], [Stakes/Bunks], [Beam], [GNK], [Parts], [Subs], [Line], [Step 1], [Step 2], 
															  [Blast], [Paint], [Finish], [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Margins Base], [Margins Options])
					select Quote#, WO#, [COGS], [Labour Cost], [Made In Material], [Bought Out Material], 
					[Machine Shop], [Axles], [Stakes/Bunks], [Beam], [GNK], [Parts], [Subs], [Line], [Step 1], [Step 2], 
					[Blast], [Paint], [Finish], [Finish - GNK], [Final Assembly], [Tire Assembly], [Shipping], [Margins Base], [Margins Options] 
					from Orders with (nolock)
					inner join BWSdb.dbo.[Budget Std] on Orders.[Model No] = [Budget Std].[Model No]
					where Quote# = @QuoteorWO or WO# = @QuoteorWO
				end

			--Insert specs for model into tv
			insert into #specs ([Quote#], WO#, [Group], SortGv2, Section, SortSev2, Description)
			select [Quote#], WO#, [Group], SortGv2, Section, SortSev2, Description from [Order Standards] with (nolock)
			where [Quote#] = @QuoteorWO or WO# = @QuoteorWO

			--Insert option and npo spec lines into corresponding temp tables (for better report performance)
			insert into #optionspecs (WO#, Quote#, [Option No], Description, Line#, SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecDescription,
									  SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
									  SpecSortSeLine, OrderOptionID)
			select distinct [Order Options].WO#, [Order Options].Quote#, [Order Options].[Option No], [Order Options].Description,
			case when [Are WO Specs Different?] = 0 then QuoteSpecs.Line# 
				 when [Are WO Specs Different?] = 1 then WOSpecs.Line# end as Line,
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecGroup 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecGroup end) as SpecGroup, 
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecSortG 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecSortG end) as SpecSortG, 
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecSection 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecSection end) as SpecSection, 
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecSortSe 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecSortSe end) as SpecSortSe, 
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecDescription 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecDescription end) as SpecDescription,
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecDescriptionBold 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecDescriptionBold end) as SpecDescriptionBold, 
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecDescriptionItalic 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecDescriptionItalic end) as SpecDescriptionItalic, 
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecDescriptionUnderline 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecDescriptionUnderline end) as SpecDescriptionUnderline, 
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecDescriptionBackColour 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecDescriptionBackColour end) as SpecDescriptionBackColour, 
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecDescriptionFontColour 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecDescriptionFontColour end) as SpecDescriptionFontColour,
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecSortSeLine 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecSortSeLine end) as SpecSortSeLine, 
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.OrderOptionID 
				  when [Are WO Specs Different?] = 1 then WOSpecs.OrderOptionID end) as OrderOptionID
			from [Order Options] with (nolock)
			left outer join [Order Options_SpecLines] as QuoteSpecs with (nolock) on [Order Options].Quote# = QuoteSpecs.Quote#
																						and [Order Options].[Option No] = QuoteSpecs.[Option No]
																						and [Order Options].Description = QuoteSpecs.Description
			left outer join [Order Options_FactoryLines] as WOSpecs with (nolock) on [Order Options].Quote# = WOSpecs.Quote#
																						and [Order Options].[Option No] = WOSpecs.[Option No]
																						and [Order Options].Description = WOSpecs.Description
			where ([Order Options].[Quote#] = @QuoteorWO or [Order Options].WO# = @QuoteorWO)

			insert into #npospecs (WO#, Quote#, Description, Line#, SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecDescription,
								   SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
								   SpecSortSeLine, NPOID)
			select distinct [Custom Work].WO#, [Custom Work].Quote#, [Custom Work].Description,
			case when [Are WO Specs Different?] = 0 then QuoteSpecs.Line# 
				 when [Are WO Specs Different?] = 1 then WOSpecs.Line# end as Line,
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecGroup 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecGroup end) as SpecGroup, 
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecSortG 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecSortG end) as SpecSortG, 
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecSection 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecSection end) as SpecSection, 
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecSortSe 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecSortSe end) as SpecSortSe, 
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecDescription 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecDescription end) as SpecDescription,
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecDescriptionBold 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecDescriptionBold end) as SpecDescriptionBold, 
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecDescriptionItalic 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecDescriptionItalic end) as SpecDescriptionItalic, 
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecDescriptionUnderline 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecDescriptionUnderline end) as SpecDescriptionUnderline, 
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecDescriptionBackColour 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecDescriptionBackColour end) as SpecDescriptionBackColour, 
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecDescriptionFontColour 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecDescriptionFontColour end) as SpecDescriptionFontColour,
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecSortSeLine 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecSortSeLine end) as SpecSortSeLine, 
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.NPOID 
				  when [Are WO Specs Different?] = 1 then WOSpecs.NPOID end) as NPOID
			from [Custom Work] with (nolock)
			left outer join [Custom Work_SpecLines] as QuoteSpecs with (nolock) on [Custom Work].Quote# = QuoteSpecs.Quote#
																					and ([Custom Work].Description = QuoteSpecs.Description
																						 or [Custom Work].ID = QuoteSpecs.NPOID)
			left outer join [Custom Work_FactoryLines] as WOSpecs with (nolock) on [Custom Work].Quote# = WOSpecs.Quote#
																					and ([Custom Work].Description = WOSpecs.Description
																						 or [Custom Work].ID = WOSpecs.NPOID)
			where ([Custom Work].[Quote#] = @QuoteorWO or [Custom Work].WO# = @QuoteorWO)

			--Insert lines from options into tv with replace code >= 1
			insert into #specs (OptionNPOID, [Quote#], WO#, [Group], SortGv2, Section, SortSev2, SpecSortSeLine, Description, Bold, Italic, Underline, BackColour, FontColour, [Steel Kit], Axles, [Step 1], [Step 2], Blast, Paint, [Finish - GNK], [Final Assembly], [Tire Assembly], Shipping, [Draw/Part#], OptNPOWt)
			select OptionNPOID, [Quote#], WO#, SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, OptionD, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour, [Steel Kit], Axles, [Step 1], [Step 2], Blast, Paint, [Finish - GNK], [Final Assembly], [Tire Assembly], Shipping, [Draw/Part#], Wt
			from (select case when Line# = 1 then [Order Options].ID else null end as OptionNPOID,
				  [Order Options].[Quote#], [Order Options].WO#, SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, case when Qty > 1 then convert(nvarchar, Qty) + ', ' + SpecDescription else SpecDescription end as OptionD, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
				  case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
				  case when Line# = 1 then Axles * Qty else 0 end as Axles, 
				  case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
				  case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
				  case when Line# = 1 then Blast * Qty else 0 end as Blast, 
				  case when Line# = 1 then Paint * Qty else 0 end as Paint, 
				  case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
				  case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
				  case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly], 
				  case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
				  case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
				  case when Line# = 1 then Weight * Qty else 0 end as Wt
				  from [Order Options] with (nolock)
				  inner join #optionspecs as OptionSpecs with (nolock) on [Order Options].Quote# = OptionSpecs.Quote#
															 and [Order Options].ID = OptionSpecs.OrderOptionID
				  where ([Order Options].[Quote#] = @QuoteorWO or [Order Options].WO# = @QuoteorWO) and SpecSortG is not null and SpecSortSeLine >= 1) as mainsub
			left outer join (select SortGv2, SortSev2, Description from #specs) as b on mainsub.SpecSortG = b.SortGv2 and mainsub.SpecSortSe = b.SortSev2 and mainsub.OptionD = b.Description

			--Update lines from options with replace code = 0
			update #specs
			set OptionNPOID = b.OptionNPOID,
			Description = b.OptionD,
			[Steel Kit] = case when a.[Steel Kit] is null then b.[Steel Kit] else a.[Steel Kit] + b.[Steel Kit] end,
			Axles = case when a.Axles is null then b.Axles else a.Axles + b.Axles end,
			[Step 1] = case when a.[Step 1] is null then b.[Step 1] else a.[Step 1] + b.[Step 1] end,
			[Step 2] = case when a.[Step 2] is null then b.[Step 2] else a.[Step 2] + b.[Step 2] end,
			Blast = case when a.Blast is null then b.Blast else a.Blast + b.Blast end,
			Paint = case when a.Paint is null then b.Paint else a.Paint + b.Paint end,
			[Finish - GNK] = case when a.[Finish - GNK] is null then b.[Finish - GNK] else a.[Finish - GNK] + b.[Finish - GNK] end,
			[Final Assembly] = case when a.[Final Assembly] is null then b.[Final Assembly] else a.[Final Assembly] + b.[Final Assembly] end,
			[Tire Assembly] = case when a.[Tire Assembly] is null then b.[Tire Assembly] else a.[Tire Assembly] + b.[Tire Assembly] end,
			Shipping = case when a.Shipping is null then b.Shipping else a.Shipping + b.Shipping end,
			Bold = b.SpecDescriptionBold,
			Italic = b.SpecDescriptionItalic,
			Underline = b.SpecDescriptionUnderline,
			BackColour = b.SpecDescriptionBackColour,
			FontColour = b.SpecDescriptionFontColour,
			[Draw/Part#] = case when b.[Draw/Part#] is null then a.[Draw/Part#]  when a.[Draw/Part#] is null then b.[Draw/Part#] else a.[Draw/Part#] + '
			' + b.[Draw/Part#] end,
			OptNPOWt = b.Wt
			from #specs as a
			inner join (select OptionNPOID, [Quote#], WO#, SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, OptionD, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour, [Steel Kit], Axles, [Step 1], [Step 2], Blast, Paint, [Finish - GNK], [Final Assembly], [Tire Assembly], Shipping, [Draw/Part#], Wt 
						from (select case when Line# = 1 then [Order Options].ID else null end as OptionNPOID,
							  [Order Options].[Quote#], [Order Options].WO#, SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, case when Qty > 1 then convert(nvarchar, Qty) + ', ' + SpecDescription else SpecDescription end as OptionD, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
							  case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
							  case when Line# = 1 then Axles * Qty else 0 end as Axles, 
							  case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
							  case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
							  case when Line# = 1 then Blast * Qty else 0 end as Blast, 
							  case when Line# = 1 then Paint * Qty else 0 end as Paint, 
							  case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
							  case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
							  case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly], 
							  case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
							  case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
							  case when Line# = 1 then Weight * Qty else 0 end as Wt
							  from [Order Options] with (nolock)
							  inner join #optionspecs as OptionSpecs with (nolock) on [Order Options].Quote# = OptionSpecs.Quote#
																		 and [Order Options].ID = OptionSpecs.OrderOptionID
							  where ([Order Options].[Quote#] = @QuoteorWO or [Order Options].WO# = @QuoteorWO) and SpecSortG is not null and SpecSortSeLine = 0) as mainsub) as b on a.[Quote#] = b.[Quote#] and a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe and a.SpecSortSeLine = b.SpecSortSeLine

			--Insert lines from options with replace code >= 0 and are non-existant in specs tv
			insert into #specs (OptionNPOID, [Quote#], WO#, [Group], SortGv2, Section, SortSev2, SpecSortSeLine, Description, Bold, Italic, Underline, BackColour, FontColour, [Steel Kit], Axles, [Step 1], [Step 2], Blast, Paint, [Finish - GNK], [Final Assembly], [Tire Assembly], Shipping, [Draw/Part#], OptNPOWt)
			select OptionNPOID, [Quote#], WO#, SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, OptionD, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour, [Steel Kit], Axles, [Step 1], [Step 2], Blast, Paint, [Finish - GNK], [Final Assembly], [Tire Assembly], Shipping, [Draw/Part#], Wt
						from (select case when Line# = 1 then [Order Options].ID else null end as OptionNPOID,
							  [Order Options].[Quote#], [Order Options].WO#, SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, case when Qty > 1 then convert(nvarchar, Qty) + ', ' + SpecDescription else SpecDescription end as OptionD, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
							  case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
							  case when Line# = 1 then Axles * Qty else 0 end as Axles, 
							  case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
							  case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
							  case when Line# = 1 then Blast * Qty else 0 end as Blast, 
							  case when Line# = 1 then Paint * Qty else 0 end as Paint, 
							  case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
							  case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
							  case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly], 
							  case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
							  case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
							  case when Line# = 1 then Weight * Qty else 0 end as Wt
							  from [Order Options] with (nolock)
							  inner join #optionspecs as OptionSpecs with (nolock) on [Order Options].Quote# = OptionSpecs.Quote#
																		 and [Order Options].ID = OptionSpecs.OrderOptionID
							  where ([Order Options].[Quote#] = @QuoteorWO or [Order Options].WO# = @QuoteorWO) and SpecSortG is not null and SpecSortSeLine >= 0) as mainsub
			left outer join (select SortGv2, SortSev2, Description from #specs) as b on mainsub.SpecSortG = b.SortGv2 and mainsub.SpecSortSe = b.SortSev2 and mainsub.OptionD = b.Description
			where SortSev2 is null
			and Description is null

			--Insert lines from npos with replace code >= 1
			insert into #specs (OptionNPOID, [Quote#], WO#, [Group], SortGv2, Section, SortSev2, SpecSortSeLine, Description, Bold, Italic, Underline, BackColour, FontColour, [Steel Kit], Axles, [Step 1], [Step 2], Blast, Paint, [Finish - GNK], [Final Assembly], [Tire Assembly], Shipping, [Draw/Part#], OptNPOWt)
			select OptionNPOID, [Quote#], WO#, SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, NPOD, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour, [Steel Kit], Axles, [Step 1], [Step 2], Blast, Paint, [Finish - GNK], [Final Assembly], [Tire Assembly], Shipping, [Draw/Part#], Wt
			from (select case when Line# = 1 then [Custom Work].ID else null end as OptionNPOID,
				  [Custom Work].[Quote#], [Custom Work].WO#, SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, '*NPO*: ' + case when Qty > 1 then convert(nvarchar, Qty) + ', ' + SpecDescription else SpecDescription end as NPOD, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
				  case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
				  case when Line# = 1 then Axles * Qty else 0 end as Axles, 
				  case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
				  case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
				  case when Line# = 1 then Blast * Qty else 0 end as Blast, 
				  case when Line# = 1 then Paint * Qty else 0 end as Paint, 
				  case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
				  case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
				  case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly], 
				  case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
				  case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
				  case when Line# = 1 then Weight * Qty else 0 end as Wt
				  from [Custom Work] with (nolock)
				  inner join #npospecs as NPOSpecs with (nolock) on [Custom Work].Quote# = NPOSpecs.Quote#
															and [Custom Work].ID = NPOSpecs.NPOID
				  where ([Custom Work].[Quote#] = @QuoteorWO or [Custom Work].WO# = @QuoteorWO) and SpecSortG is not null and SpecSortSeLine >= 1) as mainsub
			left outer join (select SortGv2, SortSev2, Description from #specs) as b on mainsub.SpecSortG = b.SortGv2 and mainsub.SpecSortSe = b.SortSev2 and mainsub.NPOD = b.Description

			--Update lines from npos with replace code = 0
			update #specs
			set OptionNPOID = b.OptionNPOID,
			Description = b.NPOD,
			[Steel Kit] = case when a.[Steel Kit] is null then b.[Steel Kit] else a.[Steel Kit] + b.[Steel Kit] end,
			Axles = case when a.Axles is null then b.Axles else a.Axles + b.Axles end,
			[Step 1] = case when a.[Step 1] is null then b.[Step 1] else a.[Step 1] + b.[Step 1] end,
			[Step 2] = case when a.[Step 2] is null then b.[Step 2] else a.[Step 2] + b.[Step 2] end,
			Blast = case when a.Blast is null then b.Blast else a.Blast + b.Blast end,
			Paint = case when a.Paint is null then b.Paint else a.Paint + b.Paint end,
			[Finish - GNK] = case when a.[Finish - GNK] is null then b.[Finish - GNK] else a.[Finish - GNK] + b.[Finish - GNK] end,
			[Final Assembly] = case when a.[Final Assembly] is null then b.[Final Assembly] else a.[Final Assembly] + b.[Final Assembly] end,
			[Tire Assembly] = case when a.[Tire Assembly] is null then b.[Tire Assembly] else a.[Tire Assembly] + b.[Tire Assembly] end,
			Shipping = case when a.Shipping is null then b.Shipping else a.Shipping + b.Shipping end,
			Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
			Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
			Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
			BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
			FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end,
			[Draw/Part#] = case when b.[Draw/Part#] is null then a.[Draw/Part#]  when a.[Draw/Part#] is null then b.[Draw/Part#] else a.[Draw/Part#] + '
			' + b.[Draw/Part#] end,
			OptNPOWt = b.Wt
			from #specs as a
			inner join (select OptionNPOID, [Quote#], WO#, SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, NPOD, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour, [Steel Kit], Axles, [Step 1], [Step 2], Blast, Paint, [Finish - GNK], [Final Assembly], [Tire Assembly], Shipping, [Draw/Part#], Wt
						from (select case when Line# = 1 then [Custom Work].ID else null end as OptionNPOID,
							  [Custom Work].[Quote#], [Custom Work].WO#, SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, '*NPO*: ' + case when Qty > 1 then convert(nvarchar, Qty) + ', ' + SpecDescription else SpecDescription end as NPOD, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
							  case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
							  case when Line# = 1 then Axles * Qty else 0 end as Axles, 
							  case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
							  case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
							  case when Line# = 1 then Blast * Qty else 0 end as Blast, 
							  case when Line# = 1 then Paint * Qty else 0 end as Paint, 
							  case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
							  case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
							  case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly], 
							  case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
							  case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
							  case when Line# = 1 then Weight * Qty else 0 end as Wt
							  from [Custom Work] with (nolock)
							  inner join #npospecs as NPOSpecs with (nolock) on [Custom Work].Quote# = NPOSpecs.Quote#
																	   and [Custom Work].ID = NPOSpecs.NPOID
							  where ([Custom Work].[Quote#] = @QuoteorWO or [Custom Work].WO# = @QuoteorWO) and SpecSortG is not null and SpecSortSeLine = 0) as mainsub) as b on a.[Quote#] = b.[Quote#] and a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe and a.SpecSortSeLine = b.SpecSortSeLine

			--Insert lines from npos with replace code >= 0 and are non-existant in specs tv
			insert into #specs (OptionNPOID, [Quote#], WO#, [Group], SortGv2, Section, SortSev2, SpecSortSeLine, Description, Bold, Italic, Underline, BackColour, FontColour, [Steel Kit], Axles, [Step 1], [Step 2], Blast, Paint, [Finish - GNK], [Final Assembly], [Tire Assembly], Shipping, [Draw/Part#], OptNPOWt)
			select OptionNPOID, [Quote#], WO#, SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, NPOD, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour, [Steel Kit], Axles, [Step 1], [Step 2], Blast, Paint, [Finish - GNK], [Final Assembly], [Tire Assembly], Shipping, [Draw/Part#], Wt
			from (select case when Line# = 1 then [Custom Work].ID else null end as OptionNPOID,
				  [Custom Work].[Quote#], [Custom Work].WO#, SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, '*NPO*: ' + case when Qty > 1 then convert(nvarchar, Qty) + ', ' + SpecDescription else SpecDescription end as NPOD, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
				  case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
				  case when Line# = 1 then Axles * Qty else 0 end as Axles, 
				  case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
				  case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
				  case when Line# = 1 then Blast * Qty else 0 end as Blast, 
				  case when Line# = 1 then Paint * Qty else 0 end as Paint, 
				  case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
				  case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
				  case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly], 
				  case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
				  case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
				  case when Line# = 1 then Weight * Qty else 0 end as Wt
				  from [Custom Work] with (nolock)
				  inner join #npospecs as NPOSpecs with (nolock) on [Custom Work].Quote# = NPOSpecs.Quote#
															and [Custom Work].ID = NPOSpecs.NPOID
				  where ([Custom Work].[Quote#] = @QuoteorWO or [Custom Work].WO# = @QuoteorWO) and SpecSortG is not null and SpecSortSeLine >= 0) as mainsub
			left outer join (select SortGv2, SortSev2, Description from #specs) as b on mainsub.SpecSortG = b.SortGv2 and mainsub.SpecSortSe = b.SortSev2 and mainsub.NPOD = b.Description
			where SortSev2 is null
			and Description is null

			--Update "Weight lbs +/- 2%" spec line based on total weight from options and npos (WITH ", including options" WORDING TO AVOID CONFUSION)
			update #specs
			set Description = cast(b.Weight as nvarchar) + ', including options'
			from #specs as a
			cross join (select sum(Weight) as Weight 
						from (select case when Description is null then 0 
										  else cast(dbo.GetNumbersFromString(replace(replace(Description, ',', ''), ' ', '')) as int) end as Weight
							  from #specs
							  where Section in ('Weight lbs +/- 2%', 'Weight lbs +/- 3%') -- Adjusted to include for new Weight wording as per Shelley - JWC - Feb 11, 2022

							  union all select sum(Weight)
							  from (select (Weight * Qty) as Weight 
									from [Order Options] with (nolock)
									where (Quote# = @QuoteorWO or WO# = @QuoteorWO)
							
									union all select sum(Weight * Qty)
									from [Custom Work] with (nolock)
									where (Quote# = @QuoteorWO or WO# = @QuoteorWO)) as mainsub) as mainsub) as b
			where Section in ('Weight lbs +/- 2%', 'Weight lbs +/- 3%') -- Adjusted to include for new Weight wording as per Shelley - JWC - Feb 11, 2022

			--Update lines from options and npos with code -99 (addition to first int value in string only)
			--Code reference for selecting int: http://stackoverflow.com/a/16667778/4027761 + http://stackoverflow.com/questions/9136722/sql-server-2008-error-converting-data-type-nvarchar-to-float
			update #specs
			set OptionNPOID = case when b.OptionNPOID is null then a.OptionNPOID else b.OptionNPOID end,
			Description = case when subC.NetSD is null then a.Description
							  else replace(a.Description, 
								   left(SUBSTRING(a.Description, PATINDEX('%[0-9]%', a.Description), len(a.Description)), PATINDEX('%[^0-9]%', SUBSTRING(a.Description, PATINDEX('%[0-9]%', a.Description), len(a.Description)) + 't') - 1), 
								   case when NPOIndicator = 1 then '(*NPO*->) ' else '' end + cast(cast(left(SUBSTRING(a.Description, PATINDEX('%[0-9]%', a.Description), len(a.Description)), PATINDEX('%[^0-9]%', SUBSTRING(a.Description, PATINDEX('%[0-9]%', a.Description), len(a.Description)) + 't') - 1) as float) + subC.NetSD as nvarchar)) end,
			[Steel Kit] = case when b.[Steel Kit] is null then a.[Steel Kit] when a.[Steel Kit] is null then b.[Steel Kit] else a.[Steel Kit] + b.[Steel Kit] end,
			Axles = case when b.Axles is null then a.Axles when a.Axles is null then b.Axles else a.Axles + b.Axles end,
			[Step 1] = case when b.[Step 1] is null then a.[Step 1] when a.[Step 1] is null then b.[Step 1] else a.[Step 1] + b.[Step 1] end,
			[Step 2] = case when b.[Step 2] is null then a.[Step 2] when a.[Step 2] is null then b.[Step 2] else a.[Step 2] + b.[Step 2] end,
			Blast = case when b.Blast is null then a.Blast when a.Blast is null then b.Blast else a.Blast + b.Blast end,
			Paint = case when b.Paint is null then a.Paint when a.Paint is null then b.Paint else a.Paint + b.Paint end,
			[Finish - GNK] = case when b.[Finish - GNK] is null then a.[Finish - GNK] when a.[Finish - GNK] is null then b.[Finish - GNK] else a.[Finish - GNK] + b.[Finish - GNK] end,
			[Final Assembly] = case when b.[Final Assembly] is null then a.[Final Assembly] when a.[Final Assembly] is null then b.[Final Assembly] else a.[Final Assembly] + b.[Final Assembly] end,
			[Tire Assembly] = case when b.[Tire Assembly] is null then a.[Tire Assembly] when a.[Tire Assembly] is null then b.[Tire Assembly] else a.[Tire Assembly] + b.[Tire Assembly] end,
			Shipping = case when b.Shipping is null then a.Shipping when a.Shipping is null then b.Shipping else a.Shipping + b.Shipping end,
			[Draw/Part#] = case when b.[Draw/Part#] is null then a.[Draw/Part#]  when a.[Draw/Part#] is null then b.[Draw/Part#] else a.[Draw/Part#] + '
			' + b.[Draw/Part#] end,
			OptNPOWt = case when b.Weight is null then a.OptNPOWt when a.OptNPOWt is null then b.Weight else a.OptNPOWt + b.Weight end,
			Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
			Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
			Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
			BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
			FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end
			from #specs as a
			left outer join (select mainsub.OptionNPOID, mainsub.SpecSortG, mainsub.SpecSortSe, mainsub.NPOIndicator, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour, [Steel Kit], Axles, [Step 1], [Step 2], Blast, Paint, [Finish - GNK], [Final Assembly], [Tire Assembly], Shipping, Weight, subA.[Draw/Part#]
							 from (select OptionNPOID, SpecSortG, SpecSortSe, max(NPOIndicator) as NPOIndicator, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour, 
								   sum([Steel Kit]) as [Steel Kit], sum(Axles) as Axles, sum([Step 1]) as [Step 1], sum([Step 2]) as [Step 2], sum(Blast) as Blast, sum(Paint) as Paint, sum([Finish - GNK]) as [Finish - GNK], sum([Final Assembly]) as [Final Assembly], sum([Tire Assembly]) as [Tire Assembly], sum(Shipping) as Shipping, sum(Wt) as Weight
								   from (select b.ID as OptionNPOID, OptionSpecs.SpecSortG, OptionSpecs.SpecSortSe, 0 as NPOIndicator, 
										 SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
										 case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
										 case when Line# = 1 then Axles * Qty else 0 end as Axles, 
										 case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
										 case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
										 case when Line# = 1 then Blast * Qty else 0 end as Blast, 
										 case when Line# = 1 then Paint * Qty else 0 end as Paint, 
										 case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
										 case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
										 case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly], 
										 case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
										 case when Line# = 1 then Weight * Qty else 0 end as Wt
										 from [Order Options] with (nolock)
										 inner join #optionspecs as OptionSpecs with (nolock) on [Order Options].Quote# = OptionSpecs.Quote#
																									and [Order Options].[Option No] = OptionSpecs.[Option No]
																									and [Order Options].Description = OptionSpecs.Description
										 left outer join (select SpecSortG, SpecSortSe, [Order Options].ID from [Order Options] with (nolock)
														  inner join #optionspecs as OptionSpecs with (nolock) on [Order Options].Quote# = OptionSpecs.Quote#
																													and [Order Options].[Option No] = OptionSpecs.[Option No]
																													and [Order Options].Description = OptionSpecs.Description
														  where ([Order Options].Quote# = @QuoteorWO or [Order Options].WO# = @QuoteorWO) and SpecSortSeLine = '-99' and Line# = 1) as b on OptionSpecs.SpecSortG = b.SpecSortG and OptionSpecs.SpecSortSe = b.SpecSortSe
										 where ([Order Options].Quote# = @QuoteorWO or [Order Options].WO# = @QuoteorWO) and SpecSortSeLine = '-99'
 
										 union all select b.ID as OptionNPOID, NPOSpecs.SpecSortG, NPOSpecs.SpecSortSe, 1,
										 SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
										 case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
										 case when Line# = 1 then Axles * Qty else 0 end as Axles, 
										 case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
										 case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
										 case when Line# = 1 then Blast * Qty else 0 end as Blast, 
										 case when Line# = 1 then Paint * Qty else 0 end as Paint, 
										 case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
										 case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
										 case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly], 
										 case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
										 case when Line# = 1 then Weight * Qty else 0 end as Wt
										 from [Custom Work] with (nolock)
										 inner join #npospecs as NPOSpecs with (nolock) on [Custom Work].Quote# = NPOSpecs.Quote#
																						   and [Custom Work].Description = NPOSpecs.Description
										 left outer join (select SpecSortG, SpecSortSe, [Custom Work].ID from [Custom Work] with (nolock)
														  inner join #npospecs as NPOSpecs with (nolock) on [Custom Work].Quote# = NPOSpecs.Quote#
																											and [Custom Work].Description = NPOSpecs.Description
														  where ([Custom Work].Quote# = @QuoteorWO or [Custom Work].WO# = @QuoteorWO) and SpecSortSeLine = '-99' and Line# = 1) as b on NPOSpecs.SpecSortG = b.SpecSortG and NPOSpecs.SpecSortSe = b.SpecSortSe
										 where ([Custom Work].[Quote#] = @QuoteorWO or [Custom Work].WO# = @QuoteorWO) and SpecSortSeLine = '-99') as mainsub
									group by OptionNPOID, SpecSortG, SpecSortSe, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour) as mainsub
								left outer join (select [Order Options].ID, [Draw/Part#] from [Order Options] with (nolock)
												inner join #optionspecs as OptionSpecs with (nolock) on [Order Options].Quote# = OptionSpecs.Quote#
																										and [Order Options].[Option No] = OptionSpecs.[Option No]
																										and [Order Options].Description = OptionSpecs.Description
											where ([Order Options].Quote# = @QuoteorWO or [Order Options].WO# = @QuoteorWO) and Line# = 1
									
											union all select [Custom Work].ID, [Draw/Part#] from [Custom Work] with (nolock)
												inner join #npospecs as NPOSpecs with (nolock) on [Custom Work].Quote# = NPOSpecs.Quote#
																								  and [Custom Work].Description = NPOSpecs.Description
											where ([Custom Work].[Quote#] = @QuoteorWO or [Custom Work].WO# = @QuoteorWO) and Line# = 1) as subA on mainsub.OptionNPOID = subA.ID) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe
				left outer join (select SpecSortG, SpecSortSe, sum(SD) as NetSD
									from (select OptionSpecs.SpecSortG, OptionSpecs.SpecSortSe, convert(float, case when isnumeric(SpecDescription) = 0 then null else SpecDescription end) * Qty as SD
											from [Order Options] with (nolock)
											inner join #optionspecs as OptionSpecs with (nolock) on [Order Options].Quote# = OptionSpecs.Quote#
																									and [Order Options].[Option No] = OptionSpecs.[Option No]
																									and [Order Options].Description = OptionSpecs.Description
											left outer join (select SpecSortG, SpecSortSe, [Order Options].ID from [Order Options] with (nolock)
															inner join #optionspecs as OptionSpecs with (nolock) on [Order Options].Quote# = OptionSpecs.Quote#
																													and [Order Options].[Option No] = OptionSpecs.[Option No]
																													and [Order Options].Description = OptionSpecs.Description
															where ([Order Options].Quote# = @QuoteorWO or [Order Options].WO# = @QuoteorWO) and SpecSortSeLine = '-99' and Line# = 1) as b on OptionSpecs.SpecSortG = b.SpecSortG and OptionSpecs.SpecSortSe = b.SpecSortSe
											where ([Order Options].Quote# = @QuoteorWO or [Order Options].WO# = @QuoteorWO) and SpecSortSeLine = '-99'

											union all select NPOSpecs.SpecSortG, NPOSpecs.SpecSortSe, convert(float, case when isnumeric(SpecDescription) = 0 then null else SpecDescription end) * Qty as SD
											from [Custom Work] with (nolock)
											inner join #npospecs as NPOSpecs with (nolock) on [Custom Work].Quote# = NPOSpecs.Quote#
																							and [Custom Work].Description = NPOSpecs.Description
											left outer join (select SpecSortG, SpecSortSe, [Custom Work].ID from [Custom Work] with (nolock)
															inner join #npospecs as NPOSpecs with (nolock) on [Custom Work].Quote# = NPOSpecs.Quote#
																											and [Custom Work].Description = NPOSpecs.Description
															where ([Custom Work].Quote# = @QuoteorWO or [Custom Work].WO# = @QuoteorWO) and SpecSortSeLine = '-99' and Line# = 1) as b on NPOSpecs.SpecSortG = b.SpecSortG and NPOSpecs.SpecSortSe = b.SpecSortSe
											where ([Custom Work].[Quote#] = @QuoteorWO or [Custom Work].WO# = @QuoteorWO) and SpecSortSeLine = '-99') as mainsubB
									group by SpecSortG, SpecSortSe) as subC on a.SortGv2 = subC.SpecSortG
																			   and a.SortSev2 = subC.SpecSortSe
				where a.SpecID = any (select MinID from (select min(SpecID) as MinID, SortGv2, SortSev2 from #specs 
														 group by SortGv2, SortSev2) as mainsub
														 group by MinID)

			--Insert line address and descriptions containing 'ft' and/or 'in' (both WITHOUT decimal values)
			--Look here if you decide to look for whole int value next to "in.": http://stackoverflow.com/questions/32971430/select-first-int-before-characters-in-string
			insert into @ftandin (SortGv2, SortSev2, Feet, FeetPosition, Inches, InchesPosition)
			select SortGv2, SortSev2, 
			case when CHARINDEX('ft.', Description) = 0 then 0
		 				   else cast(left(substring(Description, case when patindex('%[0-9][0-9] ft%', Description) = 0 then patindex('%[0-9] ft%', Description)
															  when patindex('%[0-9][0-9][0-9] ft%', Description) = 0 then patindex('%[0-9][0-9] ft%', Description)
															  else patindex('%[0-9][0-9][0-9] ft%', Description) end, len(Description)), patindex('%[^0-9]%', substring(Description, case when patindex('%[0-9][0-9] ft%', Description) = 0 then patindex('%[0-9] ft%', Description)
																																														  when patindex('%[0-9][0-9][0-9] ft%', Description) = 0 then patindex('%[0-9][0-9] ft%', Description)
																																														  else patindex('%[0-9][0-9][0-9] ft%', Description) end, len(Description))) - 1) as int) end as Feet,
			case when CHARINDEX('ft.', Description) = 0 then 0
		 				   else CHARINDEX(left(substring(Description, case when patindex('%[0-9][0-9] ft%', Description) = 0 then patindex('%[0-9] ft%', Description)
																   when patindex('%[0-9][0-9][0-9] ft%', Description) = 0 then patindex('%[0-9][0-9] ft%', Description)
																   else patindex('%[0-9][0-9][0-9] ft%', Description) end, len(Description)), patindex('%[^0-9]%', substring(Description, case when patindex('%[0-9][0-9] ft%', Description) = 0 then patindex('%[0-9] ft%', Description)
																																														  when patindex('%[0-9][0-9][0-9] ft%', Description) = 0 then patindex('%[0-9][0-9] ft%', Description)
																																														  else patindex('%[0-9][0-9][0-9] ft%', Description) end, len(Description))) - 1), Description) end as FeetPosition,
			case when CHARINDEX('in.', Description) = 0 then 0
				 else cast(left(substring(Description, case when patindex('%[0-9][0-9] in%', Description) = 0 then patindex('%[0-9] in%', Description)
															when patindex('%[0-9][0-9][0-9] in%', Description) = 0 then patindex('%[0-9][0-9] in%', Description)
															else patindex('%[0-9][0-9][0-9] in%', Description) end, len(Description)), patindex('%[^0-9]%', substring(Description, case when patindex('%[0-9][0-9] in%', Description) = 0 then patindex('%[0-9] in%', Description)
																																														when patindex('%[0-9][0-9][0-9] in%', Description) = 0 then patindex('%[0-9][0-9] in%', Description)
																																														else patindex('%[0-9][0-9][0-9] in%', Description) end, len(Description))) - 1) as int) end as Inches,
			case when CHARINDEX('in.', Description) = 0 then 0
				 else CHARINDEX(substring(Description, case when patindex('%[0-9][0-9] in%', Description) = 0 then patindex('%[0-9] in%', Description)
															when patindex('%[0-9][0-9][0-9] in%', Description) = 0 then patindex('%[0-9][0-9] in%', Description)
															else patindex('%[0-9][0-9][0-9] in%', Description) end, len(Description)), Description) end as InchesPosition																																										  
			from #specs
			where (Description like '% ft.%' and Description not like '%[0-9].[0-9] ft.%')
			or (Description like '% in.%' and Description not like '%[0-9].[0-9] in.%')

			--Update lines from options and npos with code -98 (ft. and in. addition)
			update @ftandin
			set OptionNPOID = case when b.OptionNPOID is null then a.OptionNPOID else b.OptionNPOID end,
			Inches = case when b.NetInches is null then a.Inches else a.Inches + b.NetInches end,
			[Steel Kit] = case when b.[Steel Kit] is null then a.[Steel Kit] when a.[Steel Kit] is null then b.[Steel Kit] else a.[Steel Kit] + b.[Steel Kit] end,
			Axles = case when b.Axles is null then a.Axles when a.Axles is null then b.Axles else a.Axles + b.Axles end,
			[Step 1] = case when b.[Step 1] is null then a.[Step 1] when a.[Step 1] is null then b.[Step 1] else a.[Step 1] + b.[Step 1] end,
			[Step 2] = case when b.[Step 2] is null then a.[Step 2] when a.[Step 2] is null then b.[Step 2] else a.[Step 2] + b.[Step 2] end,
			Blast = case when b.Blast is null then a.Blast when a.Blast is null then b.Blast else a.Blast + b.Blast end,
			Paint = case when b.Paint is null then a.Paint when a.Paint is null then b.Paint else a.Paint + b.Paint end,
			[Finish - GNK] = case when b.[Finish - GNK] is null then a.[Finish - GNK] when a.[Finish - GNK] is null then b.[Finish - GNK] else a.[Finish - GNK] + b.[Finish - GNK] end,
			[Final Assembly] = case when b.[Final Assembly] is null then a.[Final Assembly] when a.[Final Assembly] is null then b.[Final Assembly] else a.[Final Assembly] + b.[Final Assembly] end,
			[Tire Assembly] = case when b.[Tire Assembly] is null then a.[Tire Assembly] when a.[Tire Assembly] is null then b.[Tire Assembly] else a.[Tire Assembly] + b.[Tire Assembly] end,
			Shipping = case when b.Shipping is null then a.Shipping when a.Shipping is null then b.Shipping else a.Shipping + b.Shipping end,
			[Draw/Part#] = case when b.[Draw/Part#] is null then a.[Draw/Part#]  when a.[Draw/Part#] is null then b.[Draw/Part#] else a.[Draw/Part#] + '
			' + b.[Draw/Part#] end,
			OptNPOWt = case when b.Weight is null then a.OptNPOWt when a.OptNPOWt is null then b.Weight else a.OptNPOWt + b.Weight end,
			Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
			Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
			Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
			BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
			FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end,
			Changed = case when b.NetInches is null then 0 else 1 end,
			NPO = case when b.NPOIndicator is null then 0 else b.NPOIndicator end
			from @ftandin as a
			left outer join (select OptionNPOID, SpecSortG, SpecSortSe, NPOIndicator, NetInches, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour, [Steel Kit], Axles, [Step 1], [Step 2], Blast, Paint, [Finish - GNK], [Final Assembly], [Tire Assembly], Shipping, [Draw/Part#], Weight
							 from (select OptionNPOID, SpecSortG, SpecSortSe, NPOIndicator, sum(cast(Inches as int)) as NetInches, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
								   sum([Steel Kit]) as [Steel Kit], sum(Axles) as Axles, sum([Step 1]) as [Step 1], sum([Step 2]) as [Step 2], sum(Blast) as Blast, sum(Paint) as Paint, sum([Finish - GNK]) as [Finish - GNK], sum([Final Assembly]) as [Final Assembly], sum([Tire Assembly]) as [Tire Assembly], sum(Shipping) as Shipping, [Draw/Part#], sum(Wt) as Weight
 								   from (select b.ID as OptionNPOID, OptionSpecs.SpecSortG, OptionSpecs.SpecSortSe, 0 as NPOIndicator, cast(left(RIGHT(SpecDescription, LEN(SpecDescription) - CHARINDEX('.', SpecDescription)), 2) as int) * Qty as Inches, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
						   				 case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
										 case when Line# = 1 then Axles * Qty else 0 end as Axles, 
										 case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
										 case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
										 case when Line# = 1 then Blast * Qty else 0 end as Blast, 
										 case when Line# = 1 then Paint * Qty else 0 end as Paint, 
										 case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
										 case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
										 case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly], 
										 case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
										 case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
										 case when Line# = 1 then Weight * Qty else 0 end as Wt
										 from [Order Options] with (nolock)
										 inner join #optionspecs as OptionSpecs with (nolock) on [Order Options].Quote# = OptionSpecs.Quote#
																					and [Order Options].ID = OptionSpecs.OrderOptionID
										 left outer join (select SpecSortG, SpecSortSe, [Order Options].ID from [Order Options] with (nolock)
														  inner join #optionspecs as OptionSpecs with (nolock) on [Order Options].Quote# = OptionSpecs.Quote#
																									 and [Order Options].ID = OptionSpecs.OrderOptionID
														  where ([Order Options].Quote# = @QuoteorWO or [Order Options].WO# = @QuoteorWO) and SpecSortSeLine = '-98' and Line# = 1) as b on OptionSpecs.SpecSortG = b.SpecSortG and OptionSpecs.SpecSortSe = b.SpecSortSe
										 where ([Order Options].[Quote#] = @QuoteorWO or [Order Options].WO# = @QuoteorWO) and SpecSortSeLine = '-98') as mainsub
									group by OptionNPOID, SpecSortG, SpecSortSe, NPOIndicator, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour, [Draw/Part#]) as mainsub) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe

			update @ftandin
			set OptionNPOID = case when b.OptionNPOID is null then a.OptionNPOID else b.OptionNPOID end,
			Inches = case when b.NetInches is null then a.Inches else a.Inches + b.NetInches end,
			[Steel Kit] = case when b.[Steel Kit] is null then a.[Steel Kit] when a.[Steel Kit] is null then b.[Steel Kit] else a.[Steel Kit] + b.[Steel Kit] end,
			Axles = case when b.Axles is null then a.Axles when a.Axles is null then b.Axles else a.Axles + b.Axles end,
			[Step 1] = case when b.[Step 1] is null then a.[Step 1] when a.[Step 1] is null then b.[Step 1] else a.[Step 1] + b.[Step 1] end,
			[Step 2] = case when b.[Step 2] is null then a.[Step 2] when a.[Step 2] is null then b.[Step 2] else a.[Step 2] + b.[Step 2] end,
			Blast = case when b.Blast is null then a.Blast when a.Blast is null then b.Blast else a.Blast + b.Blast end,
			Paint = case when b.Paint is null then a.Paint when a.Paint is null then b.Paint else a.Paint + b.Paint end,
			[Finish - GNK] = case when b.[Finish - GNK] is null then a.[Finish - GNK] when a.[Finish - GNK] is null then b.[Finish - GNK] else a.[Finish - GNK] + b.[Finish - GNK] end,
			[Final Assembly] = case when b.[Final Assembly] is null then a.[Final Assembly] when a.[Final Assembly] is null then b.[Final Assembly] else a.[Final Assembly] + b.[Final Assembly] end,
			[Tire Assembly] = case when b.[Tire Assembly] is null then a.[Tire Assembly] when a.[Tire Assembly] is null then b.[Tire Assembly] else a.[Tire Assembly] + b.[Tire Assembly] end,
			Shipping = case when b.Shipping is null then a.Shipping when a.Shipping is null then b.Shipping else a.Shipping + b.Shipping end,
			[Draw/Part#] = case when b.[Draw/Part#] is null then a.[Draw/Part#]  when a.[Draw/Part#] is null then b.[Draw/Part#] else a.[Draw/Part#] + '
			' + b.[Draw/Part#] end,
			OptNPOWt = case when b.Weight is null then a.OptNPOWt when a.OptNPOWt is null then b.Weight else a.OptNPOWt + b.Weight end,
			Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
			Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
			Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
			BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
			FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end,
			Changed = case when b.NetInches is null and Changed <> 1 then 0 else 1 end,
			NPO = case when b.NPOIndicator is null and NPO <> 1 then 0 else b.NPOIndicator end
			from @ftandin as a
			left outer join (select OptionNPOID, SpecSortG, SpecSortSe, NPOIndicator, NetInches, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour, [Steel Kit], Axles, [Step 1], [Step 2], Blast, Paint, [Finish - GNK], [Final Assembly], [Tire Assembly], Shipping, [Draw/Part#], Weight
							 from (select OptionNPOID, SpecSortG, SpecSortSe, NPOIndicator, sum(cast(Inches as int)) as NetInches, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
								   sum([Steel Kit]) as [Steel Kit], sum(Axles) as Axles, sum([Step 1]) as [Step 1], sum([Step 2]) as [Step 2], sum(Blast) as Blast, sum(Paint) as Paint, sum([Finish - GNK]) as [Finish - GNK], sum([Final Assembly]) as [Final Assembly], sum([Tire Assembly]) as [Tire Assembly], sum(Shipping) as Shipping, [Draw/Part#], sum(Wt) as Weight
 								   from (select b.ID as OptionNPOID, NPOSpecs.SpecSortG, NPOSpecs.SpecSortSe, 1 as NPOIndicator, cast(left(RIGHT(SpecDescription, LEN(SpecDescription) - CHARINDEX('.', SpecDescription)), 2) as int) * Qty as Inches,
										 SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
										 case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
										 case when Line# = 1 then Axles * Qty else 0 end as Axles, 
										 case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
										 case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
										 case when Line# = 1 then Blast * Qty else 0 end as Blast, 
										 case when Line# = 1 then Paint * Qty else 0 end as Paint, 
										 case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
										 case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
										 case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly],
										 case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
										 case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
										 case when Line# = 1 then Weight * Qty else 0 end as Wt
										 from [Custom Work] with (nolock)
										 inner join #npospecs as NPOSpecs with (nolock) on [Custom Work].Quote# = NPOSpecs.Quote#
																				  and [Custom Work].ID = NPOSpecs.NPOID
										 left outer join (select SpecSortG, SpecSortSe, [Custom Work].ID from [Custom Work] with (nolock)
														  inner join #npospecs as NPOSpecs with (nolock) on [Custom Work].Quote# = NPOSpecs.Quote#
																								   and [Custom Work].ID = NPOSpecs.NPOID
														  where ([Custom Work].Quote# = @QuoteorWO or [Custom Work].WO# = @QuoteorWO) and SpecSortSeLine = '-98' and Line# = 1) as b on NPOSpecs.SpecSortG = b.SpecSortG and NPOSpecs.SpecSortSe = b.SpecSortSe								 
										 where ([Custom Work].[Quote#] = @QuoteorWO or [Custom Work].WO# = @QuoteorWO) and SpecSortSeLine = '-98') as mainsub
									group by OptionNPOID, SpecSortG, SpecSortSe, NPOIndicator, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour, [Draw/Part#]) as mainsub) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe

			--Adjust ft. and in. to proper measurments (Inches <= 12)
			update @ftandin
			set Feet = case when Inches between 12 and 23 then Feet + 1
							when Inches between 24 and 35 then Feet + 2
							when Inches between 36 and 47 then Feet + 3
							when Inches between 48 and 59 then Feet + 4
							when Inches between 60 and 71 then Feet + 5
							when Inches between 72 and 83 then Feet + 6
							when Inches between 84 and 95 then Feet + 7
							when Inches between 96 and 107 then Feet + 8
							when Inches between 108 and 119 then Feet + 9
							when Inches between 120 and 131 then Feet + 10
							else Feet end,
			Inches = case when Inches between 12 and 23 then Inches - 12
						  when Inches between 24 and 35 then Inches - 24
						  when Inches between 36 and 47 then Inches - 36
						  when Inches between 48 and 59 then Inches - 48
						  when Inches between 60 and 71 then Inches - 60
						  when Inches between 72 and 83 then Inches - 72
						  when Inches between 84 and 95 then Inches - 84
						  when Inches between 96 and 107 then Inches - 96
						  when Inches between 108 and 119 then Inches - 108
						  when Inches between 120 and 131 then Inches - 120
						  else Inches end
			where Changed = 1

			--Update lines from options and npos with code -98 (ft. addition only)
			update @ftandin
			set Feet = case when b.NetFeet is null then a.Feet else a.Feet + b.NetFeet end,
			Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
			Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
			Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
			BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
			FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end,
			Changed = case when b.NetFeet is null and Changed <> 1 then 0 else 1 end,
			NPO = case when b.NPOIndicator is null and NPO <> 1 then 0 else b.NPOIndicator end
			from @ftandin as a
			left outer join (select SpecSortG, SpecSortSe, NPOIndicator, NetFeet, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour 
							 from (select SpecSortG, SpecSortSe, NPOIndicator, sum(cast(Feet as int)) as NetFeet, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour
								   from (select SpecSortG, SpecSortSe, 0 as NPOIndicator, cast(LEFT(SpecDescription, CHARINDEX('.',SpecDescription) - 1) as int) * Qty as Feet, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order Options] with (nolock)
										 inner join #optionspecs as OptionSpecs with (nolock) on [Order Options].Quote# = OptionSpecs.Quote#
																					and [Order Options].ID = OptionSpecs.OrderOptionID
										 where ([Order Options].[Quote#] = @QuoteorWO or [Order Options].WO# = @QuoteorWO) and SpecSortSeLine = '-98') as mainsub
									group by SpecSortG, SpecSortSe, NPOIndicator, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour) as mainsub) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe

			update @ftandin
			set Feet = case when b.NetFeet is null then a.Feet else a.Feet + b.NetFeet end,
			Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
			Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
			Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
			BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
			FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end,
			Changed = case when b.NetFeet is null and Changed <> 1 then 0 else 1 end,
			NPO = case when b.NPOIndicator is null and NPO <> 1 then 0 else b.NPOIndicator end
			from @ftandin as a
			left outer join (select SpecSortG, SpecSortSe, NPOIndicator, NetFeet, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour 
							 from (select SpecSortG, SpecSortSe, NPOIndicator, sum(cast(Feet as int)) as NetFeet, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour
								   from (select SpecSortG, SpecSortSe, 1 as NPOIndicator, cast(LEFT(SpecDescription, CHARINDEX('.',SpecDescription) - 1) as int) * Qty as Feet, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom Work] with (nolock)
										 inner join #npospecs as NPOSpecs with (nolock) on [Custom Work].Quote# = NPOSpecs.Quote#
																				  and [Custom Work].ID = NPOSpecs.NPOID	
										 where (NPOSpecs.[Quote#] = @QuoteorWO or NPOSpecs.WO# = @QuoteorWO) and SpecSortSeLine = '-98') as mainsub
									group by SpecSortG, SpecSortSe, NPOIndicator, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour) as mainsub) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe

			--Handing changed @ftandin tv records with "1" position
			update @ftandin
			set FeetPosition = 0
			where FeetPosition = 1
			and Changed = 1

			update @ftandin
			set InchesPosition = 0
			where InchesPosition = 1
			and Changed = 1

			--Update @specs tv with lines from @ftandin tv
			update #specs
			set OptionNPOID = case when b.OptionNPOID is null then a.OptionNPOID else b.OptionNPOID end,
			Description = case when b.Feet is null then a.Description --No Feet/Inches additions
								   when b.Feet = 0 then case when NPO = 1 then '*NPO*: ' else '' end + left(Description, b.InchesPosition) + cast(b.Inches as nvarchar) + right(Description, len(Description) - (CHARINDEX('in.', Description) - 2)) --Inches addition only
								   when b.Inches = 0 then case when NPO = 1 then '*NPO*: ' else '' end + left(Description, b.FeetPosition) + cast(b.Feet as nvarchar) + right(Description, len(Description) - (CHARINDEX('ft.', Description) - 2)) --Feet addition only
								   when b.Feet <> 0 and CHARINDEX('in.', Description) = 0 then case when NPO = 1 then '*NPO*: ' else '' end + left(Description, b.FeetPosition) + cast(b.Feet as nvarchar) + ' ft. ' + cast(b.Inches as nvarchar) + ' in. ' 
																							   + right(Description, len(Description) - (len(cast(b.Feet as nvarchar) + ' ft. '))) --Changes ft. to ft. and in.
								   when b.Inches <> 0 and CHARINDEX('ft.', Description) = 0 then case when NPO = 1 then '*NPO*: ' else '' end + left(Description, b.InchesPosition) + cast(b.Feet as nvarchar) + ' ft. ' + cast(b.Inches as nvarchar) + right(Description, len(Description) - (CHARINDEX('in.', Description) - 2)) --Changes in. to ft. and in.
								   else case when NPO = 1 then '*NPO*: ' else '' end + left(Description, b.FeetPosition) + cast(b.Feet as nvarchar) + ' ft. ' + cast(b.Inches as nvarchar) + right(Description, len(Description) - (CHARINDEX('in.', Description) - 2)) end, 
			[Steel Kit] = case when b.[Steel Kit] is null then a.[Steel Kit] when a.[Steel Kit] is null then b.[Steel Kit] else a.[Steel Kit] + b.[Steel Kit] end,
			Axles = case when b.Axles is null then a.Axles when a.Axles is null then b.Axles else a.Axles + b.Axles end,
			[Step 1] = case when b.[Step 1] is null then a.[Step 1] when a.[Step 1] is null then b.[Step 1] else a.[Step 1] + b.[Step 1] end,
			[Step 2] = case when b.[Step 2] is null then a.[Step 2] when a.[Step 2] is null then b.[Step 2] else a.[Step 2] + b.[Step 2] end,
			Blast = case when b.Blast is null then a.Blast when a.Blast is null then b.Blast else a.Blast + b.Blast end,
			Paint = case when b.Paint is null then a.Paint when a.Paint is null then b.Paint else a.Paint + b.Paint end,
			[Finish - GNK] = case when b.[Finish - GNK] is null then a.[Finish - GNK] when a.[Finish - GNK] is null then b.[Finish - GNK] else a.[Finish - GNK] + b.[Finish - GNK] end,
			[Final Assembly] = case when b.[Final Assembly] is null then a.[Final Assembly] when a.[Final Assembly] is null then b.[Final Assembly] else a.[Final Assembly] + b.[Final Assembly] end,
			[Tire Assembly] = case when b.[Tire Assembly] is null then a.[Tire Assembly] when a.[Tire Assembly] is null then b.[Tire Assembly] else a.[Tire Assembly] + b.[Tire Assembly] end,
			Shipping = case when b.Shipping is null then a.Shipping when a.Shipping is null then b.Shipping else a.Shipping + b.Shipping end,
			[Draw/Part#] = case when b.[Draw/Part#] is null then a.[Draw/Part#]  when a.[Draw/Part#] is null then b.[Draw/Part#] else a.[Draw/Part#] + '
			' + b.[Draw/Part#] end,
			OptNPOWt = case when b.OptNPOWt is null then a.OptNPOWt when a.OptNPOWt is null then b.OptNPOWt else a.OptNPOWt + b.OptNPOWt end,
			Bold = b.Bold,
			Italic = b.Italic,
			Underline = b.Underline,
			BackColour = b.BackColour,
			FontColour = b.FontColour
			from #specs as a
			inner join @ftandin as b on a.SortGv2 = b.SortGv2 and a.SortSev2 = b.SortSev2
			where Changed = 1

			--Update lines from options and npos with code -97 (additional text)
			update #specs
			set OptionNPOID = case when b.OptionNPOID is null then a.OptionNPOID else b.OptionNPOID end,
			Description = case when b.SpecDescription is null then a.Description else a.Description + ' ' + b.SpecDescription end,
			[Steel Kit] = case when b.[Steel Kit] is null then a.[Steel Kit] when a.[Steel Kit] is null then b.[Steel Kit] else a.[Steel Kit] + b.[Steel Kit] end,
			Axles = case when b.Axles is null then a.Axles when a.Axles is null then b.Axles else a.Axles + b.Axles end,
			[Step 1] = case when b.[Step 1] is null then a.[Step 1] when a.[Step 1] is null then b.[Step 1] else a.[Step 1] + b.[Step 1] end,
			[Step 2] = case when b.[Step 2] is null then a.[Step 2] when a.[Step 2] is null then b.[Step 2] else a.[Step 2] + b.[Step 2] end,
			Blast = case when b.Blast is null then a.Blast when a.Blast is null then b.Blast else a.Blast + b.Blast end,
			Paint = case when b.Paint is null then a.Paint when a.Paint is null then b.Paint else a.Paint + b.Paint end,
			[Finish - GNK] = case when b.[Finish - GNK] is null then a.[Finish - GNK] when a.[Finish - GNK] is null then b.[Finish - GNK] else a.[Finish - GNK] + b.[Finish - GNK] end,
			[Final Assembly] = case when b.[Final Assembly] is null then a.[Final Assembly] when a.[Final Assembly] is null then b.[Final Assembly] else a.[Final Assembly] + b.[Final Assembly] end,
			[Tire Assembly] = case when b.[Tire Assembly] is null then a.[Tire Assembly] when a.[Tire Assembly] is null then b.[Tire Assembly] else a.[Tire Assembly] + b.[Tire Assembly] end,
			Shipping = case when b.Shipping is null then a.Shipping when a.Shipping is null then b.Shipping else a.Shipping + b.Shipping end,
			[Draw/Part#] = case when b.[Draw/Part#] is null then a.[Draw/Part#]  when a.[Draw/Part#] is null then b.[Draw/Part#] else a.[Draw/Part#] + '
			' + b.[Draw/Part#] end,
			OptNPOWt = case when b.Weight is null then a.OptNPOWt when a.OptNPOWt is null then b.Weight else a.OptNPOWt + b.Weight end,
			Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
			Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
			Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
			BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
			FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end
			from #specs as a
			left outer join (select OptionNPOID, SpecSortG, SpecSortSe, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
							 sum([Steel Kit]) as [Steel Kit], sum(Axles) as Axles, sum([Step 1]) as [Step 1], sum([Step 2]) as [Step 2], sum(Blast) as Blast, sum(Paint) as Paint, sum([Finish - GNK]) as [Finish - GNK], sum([Final Assembly]) as [Final Assembly], sum([Tire Assembly]) as [Tire Assembly], sum(Shipping) as Shipping, [Draw/Part#], sum(Wt) as Weight
							 from (select b.ID as OptionNPOID, OptionSpecs.SpecSortG, OptionSpecs.SpecSortSe, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
								   case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
								   case when Line# = 1 then Axles * Qty else 0 end as Axles, 
								   case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
								   case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
								   case when Line# = 1 then Blast * Qty else 0 end as Blast, 
								   case when Line# = 1 then Paint * Qty else 0 end as Paint, 
								   case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
								   case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
								   case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly], 
								   case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
								   case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
								   case when Line# = 1 then Weight * Qty else 0 end as Wt
								   from [Order Options] with (nolock)
								   inner join #optionspecs as OptionSpecs with (nolock) on [Order Options].Quote# = OptionSpecs.Quote#
																			  and [Order Options].ID = OptionSpecs.OrderOptionID
								   left outer join (select SpecSortG, SpecSortSe, [Order Options].ID from [Order Options] with (nolock)
													inner join #optionspecs as OptionSpecs with (nolock) on [Order Options].Quote# = OptionSpecs.Quote#
																								and [Order Options].ID = OptionSpecs.OrderOptionID
													where ([Order Options].Quote# = @QuoteorWO or [Order Options].WO# = @QuoteorWO) and SpecSortSeLine = '-97' and Line# = 1) as b on OptionSpecs.SpecSortG = b.SpecSortG and OptionSpecs.SpecSortSe = b.SpecSortSe
								   where ([Order Options].[Quote#] = @QuoteorWO or [Order Options].WO# = @QuoteorWO) and SpecSortSeLine = '-97'

								   union all select b.ID as OptionNPOID, NPOSpecs.SpecSortG, NPOSpecs.SpecSortSe, '*NPO*: ' + SpecDescription,
								   SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
								   case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
								   case when Line# = 1 then Axles * Qty else 0 end as Axles, 
								   case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
								   case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
								   case when Line# = 1 then Blast * Qty else 0 end as Blast, 
								   case when Line# = 1 then Paint * Qty else 0 end as Paint, 
								   case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
								   case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
								   case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly],
								   case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
								   case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
								   case when Line# = 1 then Weight * Qty else 0 end as Wt
								   from [Custom Work] with (nolock)
								   inner join #npospecs as NPOSpecs with (nolock) on [Custom Work].Quote# = NPOSpecs.Quote#
																			and [Custom Work].ID = NPOSpecs.NPOID
								   left outer join (select SpecSortG, SpecSortSe, [Custom Work].ID from [Custom Work] with (nolock)
													inner join #npospecs as NPOSpecs with (nolock) on [Custom Work].Quote# = NPOSpecs.Quote#
																							 and [Custom Work].ID = NPOSpecs.NPOID
													where ([Custom Work].Quote# = @QuoteorWO or [Custom Work].WO# = @QuoteorWO) and SpecSortSeLine = '-97' and Line# = 1) as b on NPOSpecs.SpecSortG = b.SpecSortG and NPOSpecs.SpecSortSe = b.SpecSortSe
								   where ([Custom Work].[Quote#] = @QuoteorWO or [Custom Work].WO# = @QuoteorWO) and SpecSortSeLine = '-97') as mainsub
							 group by OptionNPOID, SpecSortG, SpecSortSe, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour, [Draw/Part#]) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe
			where a.SpecSortSeLine = 0

			--delete from specs tv where code from option and npo lines = -96
			delete #specs
			from #specs as a
			inner join (select SpecSortG, SpecSortSe from [Order Options] with (nolock)
						inner join #optionspecs as OptionSpecs with (nolock) on [Order Options].Quote# = OptionSpecs.Quote#
																   and [Order Options].ID = OptionSpecs.OrderOptionID
						where ([Order Options].[Quote#] = @QuoteorWO or [Order Options].WO# = @QuoteorWO) and SpecSortSeLine = '-96'

						union all select SpecSortG, SpecSortSe from [Custom Work] with (nolock)
						inner join #npospecs as NPOSpecs with (nolock) on [Custom Work].Quote# = NPOSpecs.Quote#
																 and [Custom Work].ID = NPOSpecs.NPOID
						where ([Custom Work].[Quote#] = @QuoteorWO or [Custom Work].WO# = @QuoteorWO) and SpecSortSeLine = '-96') as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe

			--Update lines from options and npos with code -95 (find and replace)
			update #specs
			set OptionNPOID = case when b.OptionNPOID is null then a.OptionNPOID else b.OptionNPOID end,
			Description = case when b.SpecDescription is null then a.Description 
								   else replace(a.Description, 
 												right(left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1), len(left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1)) - charindex('~', left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1))), 
												case when NPOIndicator = 1 then '(*NPO*->) ' else '' end + left(right(b.SpecDescription, len(b.SpecDescription) - (CHARINDEX('~.~', b.SpecDescription) + 2)), (len(b.SpecDescription) - (CHARINDEX('~.~', b.SpecDescription) + 2)) - 1)) end,
			[Steel Kit] = case when b.[Steel Kit] is null then a.[Steel Kit] when a.[Steel Kit] is null then b.[Steel Kit] else a.[Steel Kit] + b.[Steel Kit] end,
			Axles = case when b.Axles is null then a.Axles when a.Axles is null then b.Axles else a.Axles + b.Axles end,
			[Step 1] = case when b.[Step 1] is null then a.[Step 1] when a.[Step 1] is null then b.[Step 1] else a.[Step 1] + b.[Step 1] end,
			[Step 2] = case when b.[Step 2] is null then a.[Step 2] when a.[Step 2] is null then b.[Step 2] else a.[Step 2] + b.[Step 2] end,
			Blast = case when b.Blast is null then a.Blast when a.Blast is null then b.Blast else a.Blast + b.Blast end,
			Paint = case when b.Paint is null then a.Paint when a.Paint is null then b.Paint else a.Paint + b.Paint end,
			[Finish - GNK] = case when b.[Finish - GNK] is null then a.[Finish - GNK] when a.[Finish - GNK] is null then b.[Finish - GNK] else a.[Finish - GNK] + b.[Finish - GNK] end,
			[Final Assembly] = case when b.[Final Assembly] is null then a.[Final Assembly] when a.[Final Assembly] is null then b.[Final Assembly] else a.[Final Assembly] + b.[Final Assembly] end,
			[Tire Assembly] = case when b.[Tire Assembly] is null then a.[Tire Assembly] when a.[Tire Assembly] is null then b.[Tire Assembly] else a.[Tire Assembly] + b.[Tire Assembly] end,
			Shipping = case when b.Shipping is null then a.Shipping when a.Shipping is null then b.Shipping else a.Shipping + b.Shipping end,
			[Draw/Part#] = case when b.[Draw/Part#] is null then a.[Draw/Part#]  when a.[Draw/Part#] is null then b.[Draw/Part#] else a.[Draw/Part#] + '
			' + b.[Draw/Part#] end,
			OptNPOWt = case when b.Weight is null then a.OptNPOWt when a.OptNPOWt is null then b.Weight else a.OptNPOWt + b.Weight end,
			Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
			Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
			Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
			BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
			FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end
			from #specs as a
			left outer join (select OptionNPOID, SpecSortG, SpecSortSe, NPOIndicator, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
							 sum([Steel Kit]) as [Steel Kit], sum(Axles) as Axles, sum([Step 1]) as [Step 1], sum([Step 2]) as [Step 2], sum(Blast) as Blast, sum(Paint) as Paint, sum([Finish - GNK]) as [Finish - GNK], sum([Final Assembly]) as [Final Assembly], sum([Tire Assembly]) as [Tire Assembly], sum(Shipping) as Shipping, [Draw/Part#], sum(Wt) as Weight
							 from (select b.ID as OptionNPOID, OptionSpecs.SpecSortG, OptionSpecs.SpecSortSe, 0 as NPOIndicator, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
								   case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
								   case when Line# = 1 then Axles * Qty else 0 end as Axles, 
								   case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
								   case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
								   case when Line# = 1 then Blast * Qty else 0 end as Blast, 
								   case when Line# = 1 then Paint * Qty else 0 end as Paint, 
								   case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
								   case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
								   case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly], 
								   case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
								   case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
								   case when Line# = 1 then Weight * Qty else 0 end as Wt
								   from [Order Options] with (nolock)
								   inner join #optionspecs as OptionSpecs with (nolock) on [Order Options].Quote# = OptionSpecs.Quote#
																			  and [Order Options].ID = OptionSpecs.OrderOptionID
								   left outer join (select SpecSortG, SpecSortSe, [Order Options].ID from [Order Options] with (nolock)
													inner join #optionspecs as OptionSpecs with (nolock) on [Order Options].Quote# = OptionSpecs.Quote#
																								and [Order Options].ID = OptionSpecs.OrderOptionID
													where ([Order Options].Quote# = @QuoteorWO or [Order Options].WO# = @QuoteorWO) and SpecSortSeLine = '-95' and Line# = 1) as b on OptionSpecs.SpecSortG = b.SpecSortG and OptionSpecs.SpecSortSe = b.SpecSortSe
								   where ([Order Options].[Quote#] = @QuoteorWO or [Order Options].WO# = @QuoteorWO) and SpecSortSeLine = '-95'

								   union all select b.ID as OptionNPOID, NPOSpecs.SpecSortG, NPOSpecs.SpecSortSe, 1, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
								   case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
								   case when Line# = 1 then Axles * Qty else 0 end as Axles, 
								   case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
								   case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
								   case when Line# = 1 then Blast * Qty else 0 end as Blast, 
								   case when Line# = 1 then Paint * Qty else 0 end as Paint, 
								   case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
								   case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
								   case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly],
								   case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
								   case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
								   case when Line# = 1 then Weight * Qty else 0 end as Wt
								   from [Custom Work] with (nolock)
								   inner join #npospecs as NPOSpecs with (nolock) on [Custom Work].Quote# = NPOSpecs.Quote#
																			and [Custom Work].ID = NPOSpecs.NPOID
								   left outer join (select SpecSortG, SpecSortSe, [Custom Work].ID from [Custom Work] with (nolock)
													inner join #npospecs as NPOSpecs with (nolock) on [Custom Work].Quote# = NPOSpecs.Quote#
																							 and [Custom Work].ID = NPOSpecs.NPOID
													where ([Custom Work].Quote# = @QuoteorWO or [Custom Work].WO# = @QuoteorWO) and SpecSortSeLine = '-95' and Line# = 1) as b on NPOSpecs.SpecSortG = b.SpecSortG and NPOSpecs.SpecSortSe = b.SpecSortSe
								   where ([Custom Work].[Quote#] = @QuoteorWO or [Custom Work].WO# = @QuoteorWO) and SpecSortSeLine = '-95') as mainsub
							  group by OptionNPOID, SpecSortG, SpecSortSe, NPOIndicator, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour, [Draw/Part#]) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe
			where a.SpecSortSeLine = 0

			--insert error-handling lines for options and npos with code -95 (find and replace) and no matching address in specs table
			insert into #specs ([Quote#], WO#, SortGv2, [Group], SortSev2, Section, [Description], Bold, Italic, Underline, BackColour, FontColour, [Steel Kit], Axles, [Step 1], [Step 2], Blast, Paint, [Finish - GNK], [Final Assembly], [Tire Assembly], Shipping, OptNPOWt)
			select [Quote#], WO#, SpecSortG, SpecGroup, SpecSortSe, SpecSection, 'Spec Address not found, please review Option and NPO Addresses with -95 code', 1, SpecDescriptionItalic, SpecDescriptionUnderline, 'Red', 'Yellow', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			from (select [Order Options].[Quote#], [Order Options].WO#, SpecSortG, SpecGroup, SpecSortSe, SpecSection, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order Options] with (nolock)
				  inner join #optionspecs as OptionSpecs with (nolock) on [Order Options].Quote# = OptionSpecs.Quote#
															 and [Order Options].ID = OptionSpecs.OrderOptionID
				  where ([Order Options].[Quote#] = @QuoteorWO or [Order Options].WO# = @QuoteorWO) and SpecSortSeLine = '-95'

				  union all select [Custom Work].[Quote#], [Custom Work].WO#, SpecSortG, SpecGroup, SpecSortSe, SpecSection, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom Work] with (nolock)
				  inner join #npospecs as NPOSpecs with (nolock) on [Custom Work].Quote# = NPOSpecs.Quote#
														   and [Custom Work].ID = NPOSpecs.NPOID
				  where ([Custom Work].[Quote#] = @QuoteorWO or [Custom Work].WO# = @QuoteorWO) and SpecSortSeLine = '-95') as mainsub
			left outer join (select SortGv2, SortSev2, Description from #specs) as b on mainsub.SpecSortG = b.SortGv2 and mainsub.SpecSortSe = b.SortSev2
			where SortSev2 is null
			and Description is null

			--Update lines from options and npos with code -94 (find and replace - 2nd runthrough)
			update #specs
			set OptionNPOID = case when b.OptionNPOID is null then a.OptionNPOID else b.OptionNPOID end,
			Description = case when b.SpecDescription is null then a.Description 
								   else replace(a.Description, 
 												right(left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1), len(left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1)) - charindex('~', left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1))), 
												case when NPOIndicator = 1 then '(*NPO*->) ' else '' end + left(right(b.SpecDescription, len(b.SpecDescription) - (CHARINDEX('~.~', b.SpecDescription) + 2)), (len(b.SpecDescription) - (CHARINDEX('~.~', b.SpecDescription) + 2)) - 1)) end,
			[Steel Kit] = case when b.[Steel Kit] is null then a.[Steel Kit] when a.[Steel Kit] is null then b.[Steel Kit] else a.[Steel Kit] + b.[Steel Kit] end,
			Axles = case when b.Axles is null then a.Axles when a.Axles is null then b.Axles else a.Axles + b.Axles end,
			[Step 1] = case when b.[Step 1] is null then a.[Step 1] when a.[Step 1] is null then b.[Step 1] else a.[Step 1] + b.[Step 1] end,
			[Step 2] = case when b.[Step 2] is null then a.[Step 2] when a.[Step 2] is null then b.[Step 2] else a.[Step 2] + b.[Step 2] end,
			Blast = case when b.Blast is null then a.Blast when a.Blast is null then b.Blast else a.Blast + b.Blast end,
			Paint = case when b.Paint is null then a.Paint when a.Paint is null then b.Paint else a.Paint + b.Paint end,
			[Finish - GNK] = case when b.[Finish - GNK] is null then a.[Finish - GNK] when a.[Finish - GNK] is null then b.[Finish - GNK] else a.[Finish - GNK] + b.[Finish - GNK] end,
			[Final Assembly] = case when b.[Final Assembly] is null then a.[Final Assembly] when a.[Final Assembly] is null then b.[Final Assembly] else a.[Final Assembly] + b.[Final Assembly] end,
			[Tire Assembly] = case when b.[Tire Assembly] is null then a.[Tire Assembly] when a.[Tire Assembly] is null then b.[Tire Assembly] else a.[Tire Assembly] + b.[Tire Assembly] end,
			Shipping = case when b.Shipping is null then a.Shipping when a.Shipping is null then b.Shipping else a.Shipping + b.Shipping end,
			[Draw/Part#] = case when b.[Draw/Part#] is null then a.[Draw/Part#]  when a.[Draw/Part#] is null then b.[Draw/Part#] else a.[Draw/Part#] + '
			' + b.[Draw/Part#] end,
			OptNPOWt = case when b.Weight is null then a.OptNPOWt when a.OptNPOWt is null then b.Weight else a.OptNPOWt + b.Weight end,
			Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
			Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
			Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
			BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
			FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end
			from #specs as a
			left outer join (select OptionNPOID, SpecSortG, SpecSortSe, NPOIndicator, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
							 sum([Steel Kit]) as [Steel Kit], sum(Axles) as Axles, sum([Step 1]) as [Step 1], sum([Step 2]) as [Step 2], sum(Blast) as Blast, sum(Paint) as Paint, sum([Finish - GNK]) as [Finish - GNK], sum([Final Assembly]) as [Final Assembly], sum([Tire Assembly]) as [Tire Assembly], sum(Shipping) as Shipping, [Draw/Part#], sum(Wt) as Weight
							 from (select b.ID as OptionNPOID, OptionSpecs.SpecSortG, OptionSpecs.SpecSortSe, 0 as NPOIndicator, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
								   case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
								   case when Line# = 1 then Axles * Qty else 0 end as Axles, 
								   case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
								   case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
								   case when Line# = 1 then Blast * Qty else 0 end as Blast, 
								   case when Line# = 1 then Paint * Qty else 0 end as Paint, 
								   case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
								   case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
								   case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly], 
								   case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
								   case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
								   case when Line# = 1 then Weight * Qty else 0 end as Wt
								   from [Order Options] with (nolock)
								   inner join #optionspecs as OptionSpecs with (nolock) on [Order Options].Quote# = OptionSpecs.Quote#
																			  and [Order Options].ID = OptionSpecs.OrderOptionID
								   left outer join (select SpecSortG, SpecSortSe, [Order Options].ID from [Order Options] with (nolock)
													inner join #optionspecs as OptionSpecs with (nolock) on [Order Options].Quote# = OptionSpecs.Quote#
																								and [Order Options].ID = OptionSpecs.OrderOptionID
													where ([Order Options].Quote# = @QuoteorWO or [Order Options].WO# = @QuoteorWO) and SpecSortSeLine = '-94' and Line# = 1) as b on OptionSpecs.SpecSortG = b.SpecSortG and OptionSpecs.SpecSortSe = b.SpecSortSe
								   where ([Order Options].[Quote#] = @QuoteorWO or [Order Options].WO# = @QuoteorWO) and SpecSortSeLine = '-94'

								   union all select b.ID as OptionNPOID, NPOSpecs.SpecSortG, NPOSpecs.SpecSortSe, 1, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
								   case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
								   case when Line# = 1 then Axles * Qty else 0 end as Axles, 
								   case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
								   case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
								   case when Line# = 1 then Blast * Qty else 0 end as Blast, 
								   case when Line# = 1 then Paint * Qty else 0 end as Paint, 
								   case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
								   case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
								   case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly],
								   case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
								   case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
								   case when Line# = 1 then Weight * Qty else 0 end as Wt
								   from [Custom Work] with (nolock)
								   inner join #npospecs as NPOSpecs with (nolock) on [Custom Work].Quote# = NPOSpecs.Quote#
																			and [Custom Work].ID = NPOSpecs.NPOID
								   left outer join (select SpecSortG, SpecSortSe, [Custom Work].ID from [Custom Work] with (nolock)
													inner join #npospecs as NPOSpecs with (nolock) on [Custom Work].Quote# = NPOSpecs.Quote#
																							 and [Custom Work].ID = NPOSpecs.NPOID
													where ([Custom Work].Quote# = @QuoteorWO or [Custom Work].WO# = @QuoteorWO) and SpecSortSeLine = '-94' and Line# = 1) as b on NPOSpecs.SpecSortG = b.SpecSortG and NPOSpecs.SpecSortSe = b.SpecSortSe
								   where ([Custom Work].[Quote#] = @QuoteorWO or [Custom Work].WO# = @QuoteorWO) and SpecSortSeLine = '-94') as mainsub
							  group by OptionNPOID, SpecSortG, SpecSortSe, NPOIndicator, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour, [Draw/Part#]) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe
			where a.SpecSortSeLine = 0

			--insert error-handling lines for options and npos with code -94 (find and replace - 2nd runthrough) and no matching address in specs table
			insert into #specs ([Quote#], WO#, SortGv2, [Group], SortSev2, Section, [Description], Bold, Italic, Underline, BackColour, FontColour, [Steel Kit], Axles, [Step 1], [Step 2], Blast, Paint, [Finish - GNK], [Final Assembly], [Tire Assembly], Shipping, OptNPOWt)
			select [Quote#], WO#, SpecSortG, SpecGroup, SpecSortSe, SpecSection, 'Spec Address not found, please review Option and NPO Addresses with -94 code', 1, SpecDescriptionItalic, SpecDescriptionUnderline, 'Red', 'Yellow', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			from (select [Order Options].[Quote#], [Order Options].WO#, SpecSortG, SpecGroup, SpecSortSe, SpecSection, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order Options] with (nolock)
				  inner join #optionspecs as OptionSpecs with (nolock) on [Order Options].Quote# = OptionSpecs.Quote#
															 and [Order Options].ID = OptionSpecs.OrderOptionID
				  where ([Order Options].[Quote#] = @QuoteorWO or [Order Options].WO# = @QuoteorWO) and SpecSortSeLine = '-94'

				  union all select [Custom Work].[Quote#], [Custom Work].WO#, SpecSortG, SpecGroup, SpecSortSe, SpecSection, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom Work] with (nolock)
				  inner join #npospecs as NPOSpecs with (nolock) on [Custom Work].Quote# = NPOSpecs.Quote#
														   and [Custom Work].ID = NPOSpecs.NPOID
				  where ([Custom Work].[Quote#] = @QuoteorWO or [Custom Work].WO# = @QuoteorWO) and SpecSortSeLine = '-94') as mainsub
			left outer join (select SortGv2, SortSev2, Description from #specs) as b on mainsub.SpecSortG = b.SortGv2 and mainsub.SpecSortSe = b.SortSev2
			where SortSev2 is null
			and Description is null

			--Update lines from options and npos with code -93 (find int value and "replace" with initial and specified int values added together - i.e. ~10~.~2~ will find 10 and replace it with 12)
			update #specs
			set Description = case when b.SpecDescription is null then a.Description 
								   else replace(a.Description, 
 												right(left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1), len(left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1)) - charindex('~', left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1))),
												case when NPOIndicator = 1 then '(*NPO*->) ' else '' end 
												+ cast(cast(right(left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1), len(left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1)) - charindex('~', left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1))) as float) 
												+ (cast(left(right(b.SpecDescription, len(b.SpecDescription) - (CHARINDEX('~.~', b.SpecDescription) + 2)), (len(b.SpecDescription) - (CHARINDEX('~.~', b.SpecDescription) + 2)) - 1) as float) * Qty) as nvarchar)) end,
			[Steel Kit] = case when b.[Steel Kit] is null then a.[Steel Kit] when a.[Steel Kit] is null then b.[Steel Kit] else a.[Steel Kit] + b.[Steel Kit] end,
			Axles = case when b.Axles is null then a.Axles when a.Axles is null then b.Axles else a.Axles + b.Axles end,
			[Step 1] = case when b.[Step 1] is null then a.[Step 1] when a.[Step 1] is null then b.[Step 1] else a.[Step 1] + b.[Step 1] end,
			[Step 2] = case when b.[Step 2] is null then a.[Step 2] when a.[Step 2] is null then b.[Step 2] else a.[Step 2] + b.[Step 2] end,
			Blast = case when b.Blast is null then a.Blast when a.Blast is null then b.Blast else a.Blast + b.Blast end,
			Paint = case when b.Paint is null then a.Paint when a.Paint is null then b.Paint else a.Paint + b.Paint end,
			[Finish - GNK] = case when b.[Finish - GNK] is null then a.[Finish - GNK] when a.[Finish - GNK] is null then b.[Finish - GNK] else a.[Finish - GNK] + b.[Finish - GNK] end,
			[Final Assembly] = case when b.[Final Assembly] is null then a.[Final Assembly] when a.[Final Assembly] is null then b.[Final Assembly] else a.[Final Assembly] + b.[Final Assembly] end,
			[Tire Assembly] = case when b.[Tire Assembly] is null then a.[Tire Assembly] when a.[Tire Assembly] is null then b.[Tire Assembly] else a.[Tire Assembly] + b.[Tire Assembly] end,
			Shipping = case when b.Shipping is null then a.Shipping when a.Shipping is null then b.Shipping else a.Shipping + b.Shipping end,
			[Draw/Part#] = case when b.[Draw/Part#] is null then a.[Draw/Part#]  when a.[Draw/Part#] is null then b.[Draw/Part#] else a.[Draw/Part#] + '
			' + b.[Draw/Part#] end,
			OptNPOWt = case when b.Weight is null then a.OptNPOWt when a.OptNPOWt is null then b.Weight else a.OptNPOWt + b.Weight end,
			Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
			Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
			Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
			BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
			FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end
			from #specs as a
			left outer join (select OptionNPOID, SpecSortG, SpecSortSe, NPOIndicator, Qty, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
							 sum([Steel Kit]) as [Steel Kit], sum(Axles) as Axles, sum([Step 1]) as [Step 1], sum([Step 2]) as [Step 2], sum(Blast) as Blast, sum(Paint) as Paint, sum([Finish - GNK]) as [Finish - GNK], sum([Final Assembly]) as [Final Assembly], sum([Tire Assembly]) as [Tire Assembly], sum(Shipping) as Shipping, [Draw/Part#], sum(Wt) as Weight
							 from (select b.ID as OptionNPOID, OptionSpecs.SpecSortG, OptionSpecs.SpecSortSe, 0 as NPOIndicator, Qty, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
								   case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
								   case when Line# = 1 then Axles * Qty else 0 end as Axles, 
								   case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
								   case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
								   case when Line# = 1 then Blast * Qty else 0 end as Blast, 
								   case when Line# = 1 then Paint * Qty else 0 end as Paint, 
								   case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
								   case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
								   case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly], 
								   case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
								   case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
								   case when Line# = 1 then Weight * Qty else 0 end as Wt
								   from [Order Options] with (nolock)
								   inner join #optionspecs as OptionSpecs with (nolock) on [Order Options].Quote# = OptionSpecs.Quote#
																			  and [Order Options].ID = OptionSpecs.OrderOptionID
								   left outer join (select SpecSortG, SpecSortSe, [Order Options].ID from [Order Options] with (nolock)
													inner join #optionspecs as OptionSpecs with (nolock) on [Order Options].Quote# = OptionSpecs.Quote#
																								and [Order Options].ID = OptionSpecs.OrderOptionID
													where ([Order Options].Quote# = @QuoteorWO or [Order Options].WO# = @QuoteorWO) and SpecSortSeLine = '-93' and Line# = 1) as b on OptionSpecs.SpecSortG = b.SpecSortG and OptionSpecs.SpecSortSe = b.SpecSortSe
								   where ([Order Options].[Quote#] = @QuoteorWO or [Order Options].WO# = @QuoteorWO) and SpecSortSeLine = '-93'

								   union all select b.ID as OptionNPOID, NPOSpecs.SpecSortG, NPOSpecs.SpecSortSe, 1, Qty, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
								   case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
								   case when Line# = 1 then Axles * Qty else 0 end as Axles, 
								   case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
								   case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
								   case when Line# = 1 then Blast * Qty else 0 end as Blast, 
								   case when Line# = 1 then Paint * Qty else 0 end as Paint, 
								   case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
								   case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
								   case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly],
								   case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
								   case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
								   case when Line# = 1 then Weight * Qty else 0 end as Wt
								   from [Custom Work] with (nolock)
								   inner join #npospecs as NPOSpecs with (nolock) on [Custom Work].Quote# = NPOSpecs.Quote#
																			and [Custom Work].ID = NPOSpecs.NPOID
								   left outer join (select SpecSortG, SpecSortSe, [Custom Work].ID from [Custom Work] with (nolock)
													inner join #npospecs as NPOSpecs with (nolock) on [Custom Work].Quote# = NPOSpecs.Quote#
																							 and [Custom Work].ID = NPOSpecs.NPOID
													where ([Custom Work].Quote# = @QuoteorWO or [Custom Work].WO# = @QuoteorWO) and SpecSortSeLine = '-93' and Line# = 1) as b on NPOSpecs.SpecSortG = b.SpecSortG and NPOSpecs.SpecSortSe = b.SpecSortSe
								   where ([Custom Work].[Quote#] = @QuoteorWO or [Custom Work].WO# = @QuoteorWO) and SpecSortSeLine = '-93') as mainsub
							  group by OptionNPOID, SpecSortG, SpecSortSe, NPOIndicator, Qty, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour, [Draw/Part#]) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe
			where a.SpecSortSeLine = 0

			--insert error-handling lines for options and npos with code -93 (find int value and "replace" with initial and specified int values added together - i.e. ~10~.~2~ will find 10 and replace it with 12) and no matching address in specs table
			insert into #specs ([Quote#], WO#, SortGv2, [Group], SortSev2, Section, [Description], Bold, Italic, Underline, BackColour, FontColour, [Steel Kit], Axles, [Step 1], [Step 2], Blast, Paint, [Finish - GNK], [Final Assembly], [Tire Assembly], Shipping, OptNPOWt)
			select [Quote#], WO#, SpecSortG, SpecGroup, SpecSortSe, SpecSection, 'Spec Address not found, please review Option and NPO Addresses with -93 code', 1, SpecDescriptionItalic, SpecDescriptionUnderline, 'Red', 'Yellow', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			from (select [Order Options].[Quote#], [Order Options].WO#, SpecSortG, SpecGroup, SpecSortSe, SpecSection, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order Options] with (nolock)
				  inner join #optionspecs as OptionSpecs with (nolock) on [Order Options].Quote# = OptionSpecs.Quote#
															 and [Order Options].ID = OptionSpecs.OrderOptionID
				  where ([Order Options].[Quote#] = @QuoteorWO or [Order Options].WO# = @QuoteorWO) and SpecSortSeLine = '-93'

				  union all select [Custom Work].[Quote#], [Custom Work].WO#, SpecSortG, SpecGroup, SpecSortSe, SpecSection, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom Work] with (nolock)
				  inner join #npospecs as NPOSpecs with (nolock) on [Custom Work].Quote# = NPOSpecs.Quote#
														   and [Custom Work].ID = NPOSpecs.NPOID
				  where ([Custom Work].[Quote#] = @QuoteorWO or [Custom Work].WO# = @QuoteorWO) and SpecSortSeLine = '-93') as mainsub
			left outer join (select SortGv2, SortSev2, Description from #specs) as b on mainsub.SpecSortG = b.SortGv2 and mainsub.SpecSortSe = b.SortSev2
			where SortSev2 is null
			and Description is null

			--Update lines from options and npos with code -92 (find and replace - purge spec line with "find" value, add "replace" value to "find" value)
			update #specs
			set Description = case when b.SpecDescription is null then a.Description 
								   else case when NPOIndicator = 1 then '(*NPO*->) ' else '' end 
										+ cast(cast(right(left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1), len(left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1)) - charindex('~', left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1))) as float) 
										+ (cast(left(right(b.SpecDescription, len(b.SpecDescription) - (CHARINDEX('~.~', b.SpecDescription) + 2)), (len(b.SpecDescription) - (CHARINDEX('~.~', b.SpecDescription) + 2)) - 1) as float) * Qty) as nvarchar) end,
			[Steel Kit] = case when b.[Steel Kit] is null then a.[Steel Kit] when a.[Steel Kit] is null then b.[Steel Kit] else a.[Steel Kit] + b.[Steel Kit] end,
			Axles = case when b.Axles is null then a.Axles when a.Axles is null then b.Axles else a.Axles + b.Axles end,
			[Step 1] = case when b.[Step 1] is null then a.[Step 1] when a.[Step 1] is null then b.[Step 1] else a.[Step 1] + b.[Step 1] end,
			[Step 2] = case when b.[Step 2] is null then a.[Step 2] when a.[Step 2] is null then b.[Step 2] else a.[Step 2] + b.[Step 2] end,
			Blast = case when b.Blast is null then a.Blast when a.Blast is null then b.Blast else a.Blast + b.Blast end,
			Paint = case when b.Paint is null then a.Paint when a.Paint is null then b.Paint else a.Paint + b.Paint end,
			[Finish - GNK] = case when b.[Finish - GNK] is null then a.[Finish - GNK] when a.[Finish - GNK] is null then b.[Finish - GNK] else a.[Finish - GNK] + b.[Finish - GNK] end,
			[Final Assembly] = case when b.[Final Assembly] is null then a.[Final Assembly] when a.[Final Assembly] is null then b.[Final Assembly] else a.[Final Assembly] + b.[Final Assembly] end,
			[Tire Assembly] = case when b.[Tire Assembly] is null then a.[Tire Assembly] when a.[Tire Assembly] is null then b.[Tire Assembly] else a.[Tire Assembly] + b.[Tire Assembly] end,
			Shipping = case when b.Shipping is null then a.Shipping when a.Shipping is null then b.Shipping else a.Shipping + b.Shipping end,
			[Draw/Part#] = case when b.[Draw/Part#] is null then a.[Draw/Part#]  when a.[Draw/Part#] is null then b.[Draw/Part#] else a.[Draw/Part#] + '
			' + b.[Draw/Part#] end,
			OptNPOWt = case when b.Weight is null then a.OptNPOWt when a.OptNPOWt is null then b.Weight else a.OptNPOWt + b.Weight end,
			Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
			Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
			Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
			BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
			FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end
			from #specs as a
			left outer join (select OptionNPOID, SpecSortG, SpecSortSe, NPOIndicator, Qty, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
							 sum([Steel Kit]) as [Steel Kit], sum(Axles) as Axles, sum([Step 1]) as [Step 1], sum([Step 2]) as [Step 2], sum(Blast) as Blast, sum(Paint) as Paint, sum([Finish - GNK]) as [Finish - GNK], sum([Final Assembly]) as [Final Assembly], sum([Tire Assembly]) as [Tire Assembly], sum(Shipping) as Shipping, [Draw/Part#], sum(Wt) as Weight
							 from (select b.ID as OptionNPOID, OptionSpecs.SpecSortG, OptionSpecs.SpecSortSe, 0 as NPOIndicator, Qty, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
								   case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
								   case when Line# = 1 then Axles * Qty else 0 end as Axles, 
								   case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
								   case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
								   case when Line# = 1 then Blast * Qty else 0 end as Blast, 
								   case when Line# = 1 then Paint * Qty else 0 end as Paint, 
								   case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
								   case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
								   case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly], 
								   case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
								   case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
								   case when Line# = 1 then Weight * Qty else 0 end as Wt
								   from [Order Options] with (nolock)
								   inner join #optionspecs as OptionSpecs with (nolock) on [Order Options].Quote# = OptionSpecs.Quote#
																			  and [Order Options].ID = OptionSpecs.OrderOptionID
								   left outer join (select SpecSortG, SpecSortSe, [Order Options].ID from [Order Options] with (nolock)
													inner join #optionspecs as OptionSpecs with (nolock) on [Order Options].Quote# = OptionSpecs.Quote#
																							   and [Order Options].ID = OptionSpecs.OrderOptionID
													where ([Order Options].Quote# = @QuoteorWO or [Order Options].WO# = @QuoteorWO) and SpecSortSeLine = '-92' and Line# = 1) as b on OptionSpecs.SpecSortG = b.SpecSortG and OptionSpecs.SpecSortSe = b.SpecSortSe
								   where ([Order Options].[Quote#] = @QuoteorWO or [Order Options].WO# = @QuoteorWO) and SpecSortSeLine = '-92'

								   union all select b.ID as OptionNPOID, NPOSpecs.SpecSortG, NPOSpecs.SpecSortSe, 1, Qty, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
								   case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
								   case when Line# = 1 then Axles * Qty else 0 end as Axles, 
								   case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
								   case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
								   case when Line# = 1 then Blast * Qty else 0 end as Blast, 
								   case when Line# = 1 then Paint * Qty else 0 end as Paint, 
								   case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
								   case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
								   case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly],
								   case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
								   case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
								   case when Line# = 1 then Weight * Qty else 0 end as Wt
								   from [Custom Work] with (nolock)
								   inner join #npospecs as NPOSpecs with (nolock) on [Custom Work].Quote# = NPOSpecs.Quote#
																			and [Custom Work].ID = NPOSpecs.NPOID
								   left outer join (select SpecSortG, SpecSortSe, [Custom Work].ID from [Custom Work] with (nolock)
													inner join #npospecs as NPOSpecs with (nolock) on [Custom Work].Quote# = NPOSpecs.Quote#
																							 and [Custom Work].ID = NPOSpecs.NPOID
													where ([Custom Work].Quote# = @QuoteorWO or [Custom Work].WO# = @QuoteorWO) and SpecSortSeLine = '-92' and Line# = 1) as b on NPOSpecs.SpecSortG = b.SpecSortG and NPOSpecs.SpecSortSe = b.SpecSortSe
								   where ([Custom Work].[Quote#] = @QuoteorWO or [Custom Work].WO# = @QuoteorWO) and SpecSortSeLine = '-92') as mainsub
							  group by OptionNPOID, SpecSortG, SpecSortSe, NPOIndicator, Qty, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour, [Draw/Part#]) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe
			where a.SpecSortSeLine = 0

			--insert error-handling lines for options and npos with code -92 (find and replace - purge spec line with "find" value, add "replace" value to "find" value) and no matching address in specs table
			insert into #specs ([Quote#], WO#, SortGv2, [Group], SortSev2, Section, [Description], Bold, Italic, Underline, BackColour, FontColour, [Steel Kit], Axles, [Step 1], [Step 2], Blast, Paint, [Finish - GNK], [Final Assembly], [Tire Assembly], Shipping, OptNPOWt)
			select [Quote#], WO#, SpecSortG, SpecGroup, SpecSortSe, SpecSection, 'Spec Address not found, please review Option and NPO Addresses with -92 code', 1, SpecDescriptionItalic, SpecDescriptionUnderline, 'Red', 'Yellow', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			from (select [Order Options].[Quote#], [Order Options].WO#, SpecSortG, SpecGroup, SpecSortSe, SpecSection, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order Options] with (nolock)
				  inner join #optionspecs as OptionSpecs with (nolock) on [Order Options].Quote# = OptionSpecs.Quote#
														     and [Order Options].ID = OptionSpecs.OrderOptionID
				  where ([Order Options].[Quote#] = @QuoteorWO or [Order Options].WO# = @QuoteorWO) and SpecSortSeLine = '-92'

				  union all select [Custom Work].[Quote#], [Custom Work].WO#, SpecSortG, SpecGroup, SpecSortSe, SpecSection, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom Work] with (nolock)
				  inner join #npospecs as NPOSpecs with (nolock) on [Custom Work].Quote# = NPOSpecs.Quote#
														   and [Custom Work].ID = NPOSpecs.NPOID
				  where ([Custom Work].[Quote#] = @QuoteorWO or [Custom Work].WO# = @QuoteorWO) and SpecSortSeLine = '-92') as mainsub
			left outer join (select SortGv2, SortSev2, Description from #specs) as b on mainsub.SpecSortG = b.SortGv2 and mainsub.SpecSortSe = b.SortSev2
			where SortSev2 is null
			and Description is null

			--Purge @ftandin tv for code -91
			delete from @ftandin

			--Update lines from options and npos with code -91 (ft. and in. addition with cap)
			insert into @ftandin (SortGv2, SortSev2, Feet, FeetPosition, Inches, InchesPosition)
			select SortGv2, SortSev2, 
			case when CHARINDEX('ft.', Description) = 0 then 0
		 				   else cast(left(substring(Description, case when patindex('%[0-9][0-9] ft%', Description) = 0 then patindex('%[0-9] ft%', Description)
															  when patindex('%[0-9][0-9][0-9] ft%', Description) = 0 then patindex('%[0-9][0-9] ft%', Description)
															  else patindex('%[0-9][0-9][0-9] ft%', Description) end, len(Description)), patindex('%[^0-9]%', substring(Description, case when patindex('%[0-9][0-9] ft%', Description) = 0 then patindex('%[0-9] ft%', Description)
																																														  when patindex('%[0-9][0-9][0-9] ft%', Description) = 0 then patindex('%[0-9][0-9] ft%', Description)
																																														  else patindex('%[0-9][0-9][0-9] ft%', Description) end, len(Description))) - 1) as int) end as Feet,
			case when CHARINDEX('ft.', Description) = 0 then 0
		 				   else CHARINDEX(left(substring(Description, case when patindex('%[0-9][0-9] ft%', Description) = 0 then patindex('%[0-9] ft%', Description)
																   when patindex('%[0-9][0-9][0-9] ft%', Description) = 0 then patindex('%[0-9][0-9] ft%', Description)
																   else patindex('%[0-9][0-9][0-9] ft%', Description) end, len(Description)), patindex('%[^0-9]%', substring(Description, case when patindex('%[0-9][0-9] ft%', Description) = 0 then patindex('%[0-9] ft%', Description)
																																														  when patindex('%[0-9][0-9][0-9] ft%', Description) = 0 then patindex('%[0-9][0-9] ft%', Description)
																																														  else patindex('%[0-9][0-9][0-9] ft%', Description) end, len(Description))) - 1), Description) end as FeetPosition,
			case when CHARINDEX('in.', Description) = 0 then 0
				 else cast(left(substring(Description, case when patindex('%[0-9][0-9] in%', Description) = 0 then patindex('%[0-9] in%', Description)
															when patindex('%[0-9][0-9][0-9] in%', Description) = 0 then patindex('%[0-9][0-9] in%', Description)
															else patindex('%[0-9][0-9][0-9] in%', Description) end, len(Description)), patindex('%[^0-9]%', substring(Description, case when patindex('%[0-9][0-9] in%', Description) = 0 then patindex('%[0-9] in%', Description)
																																														when patindex('%[0-9][0-9][0-9] in%', Description) = 0 then patindex('%[0-9][0-9] in%', Description)
																																														else patindex('%[0-9][0-9][0-9] in%', Description) end, len(Description))) - 1) as int) end as Inches,
			case when CHARINDEX('in.', Description) = 0 then 0
				 else CHARINDEX(substring(Description, case when patindex('%[0-9][0-9] in%', Description) = 0 then patindex('%[0-9] in%', Description)
															when patindex('%[0-9][0-9][0-9] in%', Description) = 0 then patindex('%[0-9][0-9] in%', Description)
															else patindex('%[0-9][0-9][0-9] in%', Description) end, len(Description)), Description) end as InchesPosition																																										  
			from #specs
			where (Description like '% ft.%' and Description not like '%[0-9].[0-9] ft.%')
			or (Description like '% in.%' and Description not like '%[0-9].[0-9] in.%')
	
			update @ftandin
			set OptionNPOID = case when b.OptionNPOID is null then a.OptionNPOID else b.OptionNPOID end,
			Inches = case when b.NetInches is null then a.Inches else a.Inches + b.NetInches end,
			[Steel Kit] = case when b.[Steel Kit] is null then a.[Steel Kit] when a.[Steel Kit] is null then b.[Steel Kit] else a.[Steel Kit] + b.[Steel Kit] end,
			Axles = case when b.Axles is null then a.Axles when a.Axles is null then b.Axles else a.Axles + b.Axles end,
			[Step 1] = case when b.[Step 1] is null then a.[Step 1] when a.[Step 1] is null then b.[Step 1] else a.[Step 1] + b.[Step 1] end,
			[Step 2] = case when b.[Step 2] is null then a.[Step 2] when a.[Step 2] is null then b.[Step 2] else a.[Step 2] + b.[Step 2] end,
			Blast = case when b.Blast is null then a.Blast when a.Blast is null then b.Blast else a.Blast + b.Blast end,
			Paint = case when b.Paint is null then a.Paint when a.Paint is null then b.Paint else a.Paint + b.Paint end,
			[Finish - GNK] = case when b.[Finish - GNK] is null then a.[Finish - GNK] when a.[Finish - GNK] is null then b.[Finish - GNK] else a.[Finish - GNK] + b.[Finish - GNK] end,
			[Final Assembly] = case when b.[Final Assembly] is null then a.[Final Assembly] when a.[Final Assembly] is null then b.[Final Assembly] else a.[Final Assembly] + b.[Final Assembly] end,
			[Tire Assembly] = case when b.[Tire Assembly] is null then a.[Tire Assembly] when a.[Tire Assembly] is null then b.[Tire Assembly] else a.[Tire Assembly] + b.[Tire Assembly] end,
			Shipping = case when b.Shipping is null then a.Shipping when a.Shipping is null then b.Shipping else a.Shipping + b.Shipping end,
			[Draw/Part#] = case when b.[Draw/Part#] is null then a.[Draw/Part#]  when a.[Draw/Part#] is null then b.[Draw/Part#] else a.[Draw/Part#] + '
			' + b.[Draw/Part#] end,
			OptNPOWt = case when b.Weight is null then a.OptNPOWt when a.OptNPOWt is null then b.Weight else a.OptNPOWt + b.Weight end,
			Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
			Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
			Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
			BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
			FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end,
			Changed = case when b.NetInches is null then 0 else 1 end,
			NPO = case when b.NPOIndicator is null then 0 else b.NPOIndicator end
			from @ftandin as a
			left outer join (select OptionNPOID, SpecSortG, SpecSortSe, NPOIndicator, NetInches, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour, [Steel Kit], Axles, [Step 1], [Step 2], Blast, Paint, [Finish - GNK], [Final Assembly], [Tire Assembly], Shipping, [Draw/Part#], Weight
							 from (select OptionNPOID, SpecSortG, SpecSortSe, NPOIndicator, sum(cast(Inches as int)) as NetInches, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
								   sum([Steel Kit]) as [Steel Kit], sum(Axles) as Axles, sum([Step 1]) as [Step 1], sum([Step 2]) as [Step 2], sum(Blast) as Blast, sum(Paint) as Paint, sum([Finish - GNK]) as [Finish - GNK], sum([Final Assembly]) as [Final Assembly], sum([Tire Assembly]) as [Tire Assembly], sum(Shipping) as Shipping, [Draw/Part#], sum(Wt) as Weight
 								   from (select b.ID as OptionNPOID, OptionSpecs.SpecSortG, OptionSpecs.SpecSortSe, 0 as NPOIndicator, cast(right(left(SpecDescription, CHARINDEX('~', SpecDescription) - 1), charindex('.', SpecDescription) - 1) as int) * Qty as Inches, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
						   				 case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
										 case when Line# = 1 then Axles * Qty else 0 end as Axles, 
										 case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
										 case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
										 case when Line# = 1 then Blast * Qty else 0 end as Blast, 
										 case when Line# = 1 then Paint * Qty else 0 end as Paint, 
										 case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
										 case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
										 case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly], 
										 case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
										 case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
										 case when Line# = 1 then Weight * Qty else 0 end as Wt
										 from [Order Options] with (nolock)
										 inner join #optionspecs as OptionSpecs with (nolock) on [Order Options].Quote# = OptionSpecs.Quote#
																				    and [Order Options].ID = OptionSpecs.OrderOptionID
										 left outer join (select SpecSortG, SpecSortSe, [Order Options].ID from [Order Options] with (nolock)
														  inner join #optionspecs as OptionSpecs with (nolock) on [Order Options].Quote# = OptionSpecs.Quote#
																									 and [Order Options].ID = OptionSpecs.OrderOptionID
														  where ([Order Options].Quote# = @QuoteorWO or [Order Options].WO# = @QuoteorWO) and SpecSortSeLine = '-91' and Line# = 1) as b on OptionSpecs.SpecSortG = b.SpecSortG and OptionSpecs.SpecSortSe = b.SpecSortSe
										 where ([Order Options].[Quote#] = @QuoteorWO or [Order Options].WO# = @QuoteorWO) and SpecSortSeLine = '-91'

										 union all select b.ID as OptionNPOID, NPOSpecs.SpecSortG, NPOSpecs.SpecSortSe, 1, cast(right(left(SpecDescription, CHARINDEX('~', SpecDescription) - 1), charindex('.', SpecDescription) - 1) as int) * Qty as Inches,
										 SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
										 case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
										 case when Line# = 1 then Axles * Qty else 0 end as Axles, 
										 case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
										 case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
										 case when Line# = 1 then Blast * Qty else 0 end as Blast, 
										 case when Line# = 1 then Paint * Qty else 0 end as Paint, 
										 case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
										 case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
										 case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly],
										 case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
										 case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
										 case when Line# = 1 then Weight * Qty else 0 end as Wt
										 from [Custom Work] with (nolock)
										 inner join #npospecs as NPOSpecs with (nolock) on [Custom Work].Quote# = NPOSpecs.Quote#
																				  and [Custom Work].ID = NPOSpecs.NPOID
										 left outer join (select SpecSortG, SpecSortSe, [Custom Work].ID from [Custom Work] with (nolock)
														  inner join #npospecs as NPOSpecs with (nolock) on [Custom Work].Quote# = NPOSpecs.Quote#
																								   and [Custom Work].ID = NPOSpecs.NPOID
														  where ([Custom Work].Quote# = @QuoteorWO or [Custom Work].WO# = @QuoteorWO) and SpecSortSeLine = '-91' and Line# = 1) as b on NPOSpecs.SpecSortG = b.SpecSortG and NPOSpecs.SpecSortSe = b.SpecSortSe								 
										 where ([Custom Work].[Quote#] = @QuoteorWO or [Custom Work].WO# = @QuoteorWO) and SpecSortSeLine = '-91') as mainsub
									group by OptionNPOID, SpecSortG, SpecSortSe, NPOIndicator, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour, [Draw/Part#]) as mainsub) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe

			--Adjust ft. and in. to proper measurments (Inches <= 12)
			update @ftandin
			set Feet = case when Inches between 12 and 23 then Feet + 1
							when Inches between 24 and 35 then Feet + 2
							when Inches between 36 and 47 then Feet + 3
							when Inches between 48 and 59 then Feet + 4
							when Inches between 60 and 71 then Feet + 5
							when Inches between 72 and 83 then Feet + 6
							when Inches between 84 and 95 then Feet + 7
							when Inches between 96 and 107 then Feet + 8
							when Inches between 108 and 119 then Feet + 9
							when Inches between 120 and 131 then Feet + 10
							else Feet end,
			Inches = case when Inches between 12 and 23 then Inches - 12
						  when Inches between 24 and 35 then Inches - 24
						  when Inches between 36 and 47 then Inches - 36
						  when Inches between 48 and 59 then Inches - 48
						  when Inches between 60 and 71 then Inches - 60
						  when Inches between 72 and 83 then Inches - 72
						  when Inches between 84 and 95 then Inches - 84
						  when Inches between 96 and 107 then Inches - 96
						  when Inches between 108 and 119 then Inches - 108
						  when Inches between 120 and 131 then Inches - 120
						  else Inches end
			where Changed = 1
	
			--Update lines from options and npos with code -91 (ft. addition only)
			update @ftandin
			set Feet = case when b.NetFeet is null then a.Feet else a.Feet + b.NetFeet end,
			Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
			Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
			Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
			BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
			FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end,
			Changed = case when b.NetFeet is null then 0 else 1 end,
			NPO = case when b.NPOIndicator is null then 0 else b.NPOIndicator end
			from @ftandin as a
			left outer join (select SpecSortG, SpecSortSe, NPOIndicator, NetFeet, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour 
							 from (select SpecSortG, SpecSortSe, NPOIndicator, sum(cast(Feet as int)) as NetFeet, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour
								   from (select SpecSortG, SpecSortSe, 0 as NPOIndicator, cast(LEFT(SpecDescription, CHARINDEX('.',SpecDescription) - 1) as int) * Qty as Feet, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order Options] with (nolock)
										 inner join #optionspecs as OptionSpecs with (nolock) on [Order Options].Quote# = OptionSpecs.Quote#
																				    and [Order Options].ID = OptionSpecs.OrderOptionID
										 where ([Order Options].Quote# = @QuoteorWO or [Order Options].WO# = @QuoteorWO) and SpecSortSeLine = '-91'

										 union all select SpecSortG, SpecSortSe, 1, cast(LEFT(SpecDescription, CHARINDEX('.',SpecDescription) - 1) as int) * Qty as Feet, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom Work] with (nolock)
										 inner join #npospecs as NPOSpecs with (nolock) on [Custom Work].Quote# = NPOSpecs.Quote#
																			      and [Custom Work].ID = NPOSpecs.NPOID	
										 where ([Custom Work].Quote# = @QuoteorWO or [Custom Work].WO# = @QuoteorWO) and SpecSortSeLine = '-91') as mainsub
									group by SpecSortG, SpecSortSe, NPOIndicator, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour) as mainsub) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe

			--Apply cap from option and NPO lines with code -91
			update @ftandin
			set Feet = case when (Feet * 12) + Inches >= (CapFeet * 12) + CapInches then CapFeet else Feet end,
			Inches = case when (Feet * 12) + Inches >= (CapFeet * 12) + CapInches then CapInches else Inches end
			from @ftandin as a
			inner join (select SpecSortG, SpecSortSe,
						left(right(SpecDescription, charindex('~', SpecDescription) + 1), charindex('.', right(SpecDescription, charindex('~', SpecDescription) + 1)) - 1) as CapFeet,
						left(right(SpecDescription, len(SpecDescription) - charindex('.', SpecDescription, charindex('.', SpecDescription) + 1)),
							 CHARINDEX('~', right(SpecDescription, len(SpecDescription) - charindex('.', SpecDescription, charindex('.', SpecDescription) + 1))) - 1)  as CapInches
						from #optionspecs as OptionSpecs
						where (OptionSpecs.Quote# = @QuoteorWO or OptionSpecs.WO# = @QuoteorWO) and SpecSortSeLine = '-91'

						union all select SpecSortG, SpecSortSe,
						left(right(SpecDescription, charindex('~', SpecDescription) + 1), charindex('.', right(SpecDescription, charindex('~', SpecDescription) + 1)) - 1),
						left(right(SpecDescription, len(SpecDescription) - charindex('.', SpecDescription, charindex('.', SpecDescription) + 1)),
							 CHARINDEX('~', right(SpecDescription, len(SpecDescription) - charindex('.', SpecDescription, charindex('.', SpecDescription) + 1))) - 1)
						from #npospecs as NPOSpecs
						where (NPOSpecs.Quote# = @QuoteorWO or NPOSpecs.WO# = @QuoteorWO) and SpecSortSeLine = '-91') as b on a.SortGv2 = b.SpecSortG
																												 and a.SortSev2 = b.SpecSortSe

			--Handing changed @ftandin tv records with "1" position
			update @ftandin
			set FeetPosition = 0
			where FeetPosition = 1
			and Changed = 1
	
			update @ftandin
			set InchesPosition = 0
			where InchesPosition = 1
			and Changed = 1
	
			--Update @specs tv with lines from @ftandin tv
			update #specs
			set OptionNPOID = case when b.OptionNPOID is null then a.OptionNPOID else b.OptionNPOID end,
			Description = case when b.Feet is null then a.Description --No Feet/Inches additions
							   when b.Feet = 0 then case when NPO = 1 then '*NPO*: ' else '' end + left(Description, b.InchesPosition) + cast(b.Inches as nvarchar) + right(Description, len(Description) - (CHARINDEX('in.', Description) - 2)) --Inches addition only
							   when b.Inches = 0 and InchesPosition = 0 then case when NPO = 1 then '*NPO*: ' else '' end + left(Description, case when Description like '*NPO*:%' then b.FeetPosition - 1 else b.FeetPosition end) + cast(b.Feet as nvarchar) + right(Description, len(Description) - (CHARINDEX('ft.', Description) - 2)) --Feet addition only
							   when b.Feet <> 0 and CHARINDEX('in.', Description) = 0 then case when NPO = 1 then '*NPO*: ' else '' end + left(Description, case when Description like '*NPO*:%' then b.FeetPosition - 1 else b.FeetPosition end) + cast(b.Feet as nvarchar) + ' ft. ' + cast(b.Inches as nvarchar) + ' in. ' 
																						   + right(Description, len(Description) - (len(cast(b.Feet as nvarchar) + ' ft. '))) --Changes ft. to ft. and in.
							   when b.Inches <> 0 and CHARINDEX('ft.', Description) = 0 then case when NPO = 1 then '*NPO*: ' else '' end + left(Description, b.InchesPosition) + cast(b.Feet as nvarchar) + ' ft. ' + cast(b.Inches as nvarchar) + right(Description, len(Description) - (CHARINDEX('in.', Description) - 2)) --Changes in. to ft. and in.
							   else case when NPO = 1 then '*NPO*: ' else '' end + left(Description, case when Description like '*NPO*:%' then b.FeetPosition - 1 else b.FeetPosition end) + cast(b.Feet as nvarchar) + ' ft. ' + cast(b.Inches as nvarchar) + right(Description, len(Description) - (CHARINDEX('in.', Description) - 2)) end, 
			[Steel Kit] = case when b.[Steel Kit] is null then a.[Steel Kit] when a.[Steel Kit] is null then b.[Steel Kit] else a.[Steel Kit] + b.[Steel Kit] end,
			Axles = case when b.Axles is null then a.Axles when a.Axles is null then b.Axles else a.Axles + b.Axles end,
			[Step 1] = case when b.[Step 1] is null then a.[Step 1] when a.[Step 1] is null then b.[Step 1] else a.[Step 1] + b.[Step 1] end,
			[Step 2] = case when b.[Step 2] is null then a.[Step 2] when a.[Step 2] is null then b.[Step 2] else a.[Step 2] + b.[Step 2] end,
			Blast = case when b.Blast is null then a.Blast when a.Blast is null then b.Blast else a.Blast + b.Blast end,
			Paint = case when b.Paint is null then a.Paint when a.Paint is null then b.Paint else a.Paint + b.Paint end,
			[Finish - GNK] = case when b.[Finish - GNK] is null then a.[Finish - GNK] when a.[Finish - GNK] is null then b.[Finish - GNK] else a.[Finish - GNK] + b.[Finish - GNK] end,
			[Final Assembly] = case when b.[Final Assembly] is null then a.[Final Assembly] when a.[Final Assembly] is null then b.[Final Assembly] else a.[Final Assembly] + b.[Final Assembly] end,
			[Tire Assembly] = case when b.[Tire Assembly] is null then a.[Tire Assembly] when a.[Tire Assembly] is null then b.[Tire Assembly] else a.[Tire Assembly] + b.[Tire Assembly] end,
			Shipping = case when b.Shipping is null then a.Shipping when a.Shipping is null then b.Shipping else a.Shipping + b.Shipping end,
			[Draw/Part#] = case when b.[Draw/Part#] is null then a.[Draw/Part#]  when a.[Draw/Part#] is null then b.[Draw/Part#] else a.[Draw/Part#] + '
			' + b.[Draw/Part#] end,
			OptNPOWt = case when b.OptNPOWt is null then a.OptNPOWt when a.OptNPOWt is null then b.OptNPOWt else a.OptNPOWt + b.OptNPOWt end,
			Bold = b.Bold,
			Italic = b.Italic,
			Underline = b.Underline,
			BackColour = b.BackColour,
			FontColour = b.FontColour
			from #specs as a
			inner join @ftandin as b on a.SortGv2 = b.SortGv2 and a.SortSev2 = b.SortSev2
			where Changed = 1

			--Replace "ft. 0 in." with "ft." as "0 in." is unnecessary
			update #specs
			set Description = replace(Description, 'ft. 0 in.', 'ft.')

			--Code -90 - infinite find and replace array (minics code 0)
			--Drop and create temp table in tmpdb SQL database for faster processing
			--Code reference: http://stackoverflow.com/questions/8726111/sql-server-find-nth-occurrence-in-a-string
			IF OBJECT_ID('tempdb..#T') IS NOT NULL
				DROP TABLE #T 
	
			--Grab Option and NPO Spec Line Descriptions for Code -90
			select SpecDescription as img into #t
			from [Order Options] with (nolock)
			inner join #optionspecs as OptionSpecs with (nolock) on [Order Options].Quote# = OptionSpecs.Quote#
													   and [Order Options].ID = OptionSpecs.OrderOptionID
			where ([Order Options].Quote# = @QuoteorWO or [Order Options].WO# = @QuoteorWO) and SpecSortSeLine = '-90'

			union all select SpecDescription
			from [Custom Work] with (nolock)
			inner join #npospecs as NPOSpecs with (nolock) on [Custom Work].Quote# = NPOSpecs.Quote#
													 and [Custom Work].ID = NPOSpecs.NPOID
			where ([Custom Work].Quote# = @QuoteorWO or [Custom Work].WO# = @QuoteorWO) and SpecSortSeLine = '-90'

			;with T(img, starts, pos) as (
				select img, 1, charindex('~', img) from #t
				union all
				select img, cast(pos + 1 as int), charindex('~', img, pos + 1)
				from t
				where pos > 0
			)
			insert into @t (ID, Description, Starts, Pos, token)
			select ROW_NUMBER() over (partition by img order by img, starts, pos),
			img, starts, pos,
			substring(img, starts, case when pos > 0 then pos - starts else len(img) end) token
			from T
			where substring(img, starts, case when pos > 0 then pos - starts else len(img) end) <> '.'
			and substring(img, starts, case when pos > 0 then pos - starts else len(img) end) <> ''
			order by img, starts

			--Update the description in the Specs table, based on the Spec Line and the Option/NPO Qty
			update #specs
			set OptionNPOID = case when b.OptionNPOID is null then a.OptionNPOID else b.OptionNPOID end,
			Description = token,
			[Steel Kit] = case when b.[Steel Kit] is null then a.[Steel Kit] when a.[Steel Kit] is null then b.[Steel Kit] else a.[Steel Kit] + b.[Steel Kit] end,
			Axles = case when b.Axles is null then a.Axles when a.Axles is null then b.Axles else a.Axles + b.Axles end,
			[Step 1] = case when b.[Step 1] is null then a.[Step 1] when a.[Step 1] is null then b.[Step 1] else a.[Step 1] + b.[Step 1] end,
			[Step 2] = case when b.[Step 2] is null then a.[Step 2] when a.[Step 2] is null then b.[Step 2] else a.[Step 2] + b.[Step 2] end,
			Blast = case when b.Blast is null then a.Blast when a.Blast is null then b.Blast else a.Blast + b.Blast end,
			Paint = case when b.Paint is null then a.Paint when a.Paint is null then b.Paint else a.Paint + b.Paint end,
			[Finish - GNK] = case when b.[Finish - GNK] is null then a.[Finish - GNK] when a.[Finish - GNK] is null then b.[Finish - GNK] else a.[Finish - GNK] + b.[Finish - GNK] end,
			[Final Assembly] = case when b.[Final Assembly] is null then a.[Final Assembly] when a.[Final Assembly] is null then b.[Final Assembly] else a.[Final Assembly] + b.[Final Assembly] end,
			[Tire Assembly] = case when b.[Tire Assembly] is null then a.[Tire Assembly] when a.[Tire Assembly] is null then b.[Tire Assembly] else a.[Tire Assembly] + b.[Tire Assembly] end,
			Shipping = case when b.Shipping is null then a.Shipping when a.Shipping is null then b.Shipping else a.Shipping + b.Shipping end,
			[Draw/Part#] = case when b.[Draw/Part#] is null then a.[Draw/Part#]  when a.[Draw/Part#] is null then b.[Draw/Part#] else a.[Draw/Part#] + '
			' + b.[Draw/Part#] end,
			OptNPOWt = case when b.Weight is null then a.OptNPOWt when a.OptNPOWt is null then b.Weight else a.OptNPOWt + b.Weight end
			from #specs as a
			inner join (select OptionNPOID, SpecSortG, SpecSortSe, FirstLine, token, 
						sum([Steel Kit]) as [Steel Kit], sum(Axles) as Axles, sum([Step 1]) as [Step 1], sum([Step 2]) as [Step 2], sum(Blast) as Blast, sum(Paint) as Paint,
						sum([Finish - GNK]) as [Finish - GNK], sum([Final Assembly]) as [Final Assembly], sum([Tire Assembly]) as [Tire Assembly], sum(Shipping) as Shipping, [Draw/Part#], sum(Wt) as Weight
						from (select b.ID as OptionNPOID, OptionSpecs.SpecSortG, OptionSpecs.SpecSortSe, FirstLine, token, 
							  case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
							  case when Line# = 1 then Axles * Qty else 0 end as Axles, 
							  case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
							  case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
							  case when Line# = 1 then Blast * Qty else 0 end as Blast, 
							  case when Line# = 1 then Paint * Qty else 0 end as Paint, 
							  case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
							  case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
							  case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly], 
							  case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
							  case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
							  case when Line# = 1 then Weight * Qty else 0 end as Wt
							  from [Order Options] with (nolock)
							  inner join #optionspecs as OptionSpecs with (nolock) on [Order Options].Quote# = OptionSpecs.Quote#
																		 and [Order Options].ID = OptionSpecs.OrderOptionID
							  inner join (select SpecSortG, SpecSortSe,
											min(case when SpecSortSeLine < 0 then 0 else SpecSortSeLine end) as FirstLine 
											from #optionspecs
											where Quote# = @QuoteorWO or WO# = @QuoteorWO
											group by SpecSortG, SpecSortSe) as subFirstLine on OptionSpecs.SpecSortG = subFirstLine.SpecSortG
																								and OptionSpecs.SpecSortSe = subFirstLine.SpecSortSe
							  left outer join (select SpecSortG, SpecSortSe, [Order Options].ID from [Order Options] with (nolock)
											   inner join #optionspecs as OptionSpecs with (nolock) on [Order Options].Quote# = OptionSpecs.Quote#
																						  and [Order Options].ID = OptionSpecs.OrderOptionID
											   where ([Order Options].Quote# = @QuoteorWO or [Order Options].WO# = @QuoteorWO) and SpecSortSeLine = '-90' and Line# = 1) as b on OptionSpecs.SpecSortG = b.SpecSortG and OptionSpecs.SpecSortSe = b.SpecSortSe
							  inner join @t as a on [Order Options].Qty = a.ID
													and OptionSpecs.SpecDescription = a.Description
							  where ([Order Options].Quote# = @QuoteorWO or [Order Options].WO# = @QuoteorWO) and SpecSortSeLine = '-90'

							  union all select b.ID, NPOSpecs.SpecSortG, NPOSpecs.SpecSortSe, FirstLine, token, 
							  case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
							  case when Line# = 1 then Axles * Qty else 0 end as Axles, 
							  case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
							  case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
							  case when Line# = 1 then Blast * Qty else 0 end as Blast, 
							  case when Line# = 1 then Paint * Qty else 0 end as Paint, 
							  case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
							  case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
							  case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly], 
							  case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
							  case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
							  case when Line# = 1 then Weight * Qty else 0 end as Wt
							  from [Custom Work] with (nolock)
							  inner join #npospecs as NPOSpecs with (nolock) on [Custom Work].Quote# = NPOSpecs.Quote#
																	   and [Custom Work].ID = NPOSpecs.NPOID
							  inner join (select SpecSortG, SpecSortSe,
											min(case when SpecSortSeLine < 0 then 0 else SpecSortSeLine end) as FirstLine 
											from #npospecs
											where Quote# = @QuoteorWO
											group by SpecSortG, SpecSortSe) as subFirstLine on NPOSpecs.SpecSortG = subFirstLine.SpecSortG
																							   and NPOSpecs.SpecSortSe = subFirstLine.SpecSortSe
							  left outer join (select SpecSortG, SpecSortSe, [Custom Work].ID from [Custom Work] with (nolock)
											   inner join #npospecs as NPOSpecs with (nolock) on [Custom Work].Quote# = NPOSpecs.Quote#
																						and [Custom Work].ID = NPOSpecs.NPOID
											   where ([Custom Work].Quote# = @QuoteorWO or [Custom Work].WO# = @QuoteorWO) and SpecSortSeLine = '-90' and Line# = 1) as b on NPOSpecs.SpecSortG = b.SpecSortG and NPOSpecs.SpecSortSe = b.SpecSortSe
							  inner join @t as a on [Custom Work].Qty = a.ID
													and NPOSpecs.SpecDescription = a.Description
							  where ([Custom Work].Quote# = @QuoteorWO or [Custom Work].WO# = @QuoteorWO) and SpecSortSeLine = '-90') as mainsub
						group by OptionNPOID, SpecSortG, SpecSortSe, FirstLine, token, [Draw/Part#]) as b on a.SortGv2 = b.SpecSortG
																											  and a.SortSev2 = b.SpecSortSe
																											  and a.SpecSortSeLine = b.FirstLine

			/*

				Code -89 to be added later!
				Will mimic code -99, but will have a cap (similar to code -91)

			*/

			--Remove nulls from formatting columns
			update #specs
			set Bold = 0
			where Bold is null

			update #specs
			set Italic = 0
			where Italic is null
	
			update #specs
			set Underline = 0
			where Underline is null

			update #specs
			set BackColour = 'Transparent'
			where BackColour is null

			update #specs
			set FontColour = 'Black'
			where FontColour is null

			--Add "Comments" from Order Options to end of text for first line
			update #specs
			set Description = Description + ': ' + convert(nvarchar(max), Comments)
			from #specs as a
			inner join (select SpecSortG, SpecSortSe,
						case when SpecSortSeLine < 0 then 0 else SpecSortSeLine end as SpecSortSeLine,
						case when Qty > 1 then convert(nvarchar, Qty) + ', ' + SpecDescription else SpecDescription end as SpecDescription, 
						Comments from [Order Options] with (nolock)
						inner join #optionspecs as OptionSpecs with (nolock) on [Order Options].Quote# = OptionSpecs.Quote#
																   and [Order Options].ID = OptionSpecs.OrderOptionID
						where ([Order Options].Quote# = @QuoteorWO or [Order Options].WO# = @QuoteorWO)
						and Line# = 1
						and Comments is not null) as b on a.SortGv2 = b.SpecSortG
														  and a.SortSev2 = b.SpecSortSe
														  and a.SpecSortSeLine = b.SpecSortSeLine

			insert into @WidthSpreadandDeckLength (Quote#, Width)
			select Quote#, left(SUBSTRING(Description, PATINDEX('%[0-9]%', Description), len(Description)), PATINDEX('%[^0-9]%', SUBSTRING(Description, PATINDEX('%[0-9]%', Description), len(Description)) + 't') - 1)
			from #specs
			where [Group] = 'Trailer'
			and Section = 'Overall Width'

			update @WidthSpreadandDeckLength
			set Quote# = a.Quote#,
			Spread = left(SUBSTRING(Description, PATINDEX('%[0-9]%', Description), len(Description)), PATINDEX('%[^0-9]%', SUBSTRING(Description, PATINDEX('%[0-9]%', Description), len(Description)) + 't') - 1)
			from #specs as a
			where [Group] = 'SUSPENSION/AXLES'
			and Section = 'Spread'

			update @WidthSpreadandDeckLength
			set Quote# = a.Quote#,
			DeckLength = left(SUBSTRING(Description, PATINDEX('%[0-9]%', Description), len(Description)), PATINDEX('%[^0-9]%', SUBSTRING(Description, PATINDEX('%[0-9]%', Description), len(Description)) + 't') - 1)
			from #specs as a
			where [Group] = 'DECK'
 			and Section = 'Deck Length'

			--Update Orders table
			update Orders
			set Width = b.Width,
			Spread = b.Spread,
			[Deck Length] = b.DeckLength
			from Orders as a with (nolock)
			inner join @WidthSpreadandDeckLength as b on a.Quote# = b.Quote#

			--Update Design table
			update Design
			set Width = b.Width,
			Spread = b.Spread,
			[Deck Length] = b.DeckLength
			from Design as a with (nolock)
			inner join @WidthSpreadandDeckLength as b on a.Quote# = b.Quote#

			--Move all *NPO* characters to the front of the line and remove *NPO* characters that aren't
			update #specs
			set Description = '*NPO*: ' + Description
			where Description like '%*NPO*%'
			and CHARINDEX('*NPO*', Description) <> 1

			update #specs
			set Description = REPLACE(Description, ' *NPO*: ', ' ')
	
			update #specs
			set Description = REPLACE(Description, '(*NPO*->) ', '')

			----select statement
			--select Orders.Quote#, @QuoteorWORev as Revision#, Orders.WO#, [GN WO#], Products.[Top Level Part# (SYSPRO)],
			--subD.Width, subD.Spread, subD.DeckLength as [Deck Length],
			--Orders.[Model No],
			--Orders.[Order Date], [Prod Date], [Available Date], Orders.[Delivery Date], [Date Declined],
			--case when CompletedJobInfo.ActCompleteDate is null then dbo.Production.[Date Completed] else CompletedJobInfo.ActCompleteDate end as [Date Completed],
			--Orders.[Shipped Date],
			--case when CompletedJobInfo.EntInvoiceDate is null then dbo.Orders.[Invoice Date] else CompletedJobInfo.EntInvoiceDate end as [Invoice Date],
			--Class, Model, PDD, [Prom Drawing],
			--subA.Weight as TrailerWt,
			--cast(subA.Weight / 2.2046226218 as float) as TrailerKg,
			--subB.TtlOptWt,
			--cast(subB.TtlOptWt / 2.2046226218 as float) as TtlOptKg,
			--subC.CWwt,
			--cast(subC.CWwt / 2.2046226218 as float) as CWKg,
			--subA.Weight + subB.TtlOptWt + subC.CWwt as UnitWt,
			--cast((subA.Weight + subB.TtlOptWt + subC.CWwt) / 2.2046226218 as float) as UnitKg,
			--[COMPANY NAME], CONTACT, Orders.[Serial Number], [PO Date], [Purchase Order], [Sales Person], Orders.[Special Instructions],
			--0 as BaseSK, [Order Hours].Axles as BaseAxle, [Order Hours].[Step 1] as BaseStep1, [Order Hours].[Step 2] as BaseStep2,
			--[Order Hours].Blast as BaseBlast, [Order Hours].Paint as BasePaint, 
			--[Order Hours].[Finish - GNK] as BaseFGNK, [Order Hours].[Final Assembly] as BaseFinalAssembly, 
			--[Order Hours].[Tire Assembly] as BaseTireAssembly, [Order Hours].Shipping as BaseShipping,
			--(0 + [Order Hours].Axles + [Order Hours].[Step 1] + [Order Hours].[Step 2] + [Order Hours].Blast + [Order Hours].Paint 
			-- + [Order Hours].[Finish - GNK] + [Order Hours].[Final Assembly] + [Order Hours].[Tire Assembly] + [Order Hours].Shipping) as BaseHours,
			--sub.[Group] as SGroup, sub.SortGv2 as SSortG, sub.Section as SSection, sub.SortSev2 as SSortSe, sub.SpecSortSeLine as SSortSeLine, sub.Description, 
			--sub.Bold, sub.Italic, sub.Underline, sub.BackColour, sub.FontColour,
			--sub.[Steel Kit] as OptSK, sub.Axles as OptAxle, sub.[Step 1] as OptStep1, sub.[Step 2] as OptStep2, 
			--sub.Blast as OptBlast, sub.Paint as OptPaint, 
			--sub.[Finish - GNK] as OptFGNK, sub.[Final Assembly] as OptFinalAssembly, sub.[Tire Assembly] as OptTireAssembly, sub.Shipping as OptShipping,
			--(sub.Axles + sub.[Step 1] + sub.[Step 2] + sub.Blast + sub.Paint + sub.[Finish - GNK] + sub.[Final Assembly] + sub.[Tire Assembly] + sub.Shipping) as OptHours,
			--[Draw/Part#], OptionNPOID, OptNPOWt, BOL#
			--from Orders with (nolock)
			--inner join BWSdb.dbo.Products with (nolock) on Orders.[Model No] = Products.[Model No]
			--left outer join Production with (nolock) on Orders.Quote# = Production.Quote#
			----left outer join SysproCompanyA.dbo.v_CompletedJobInfo with (nolock) on CAST(dbo.Orders.WO# AS varchar(20)) COLLATE Latin1_General_BIN = SysproCompanyA.dbo.v_CompletedJobInfo.Job
			--left outer join ( 
			--				select *
			--				from (
			--						select *,
			--						ROW_NUMBER() over(partition by Job order by Job, InvoiceNumber desc) as RowID
			--						from SysproCompanyA.dbo.v_CompletedJobInfo with (nolock)
			--					) as subA
			--				where RowID = 1
			--				) as CompletedJobInfo on CAST(dbo.Orders.WO# AS varchar(20)) COLLATE Latin1_General_BIN = CompletedJobInfo.Job
			--left outer join (select Quote#, case when Description is null then 0
			--									 else LEFT(SUBSTRING(replace(replace(replace(Description,'(',''),')',''), ',', ''), PATINDEX('%[0-9.-]%', replace(replace(replace(Description,'(',''),')',''), ',', '')), 8000),
			--												PATINDEX('%[^0-9.-]%', SUBSTRING(replace(replace(replace(Description,'(',''),')',''), ',', ''), PATINDEX('%[0-9.-]%', replace(replace(replace(Description,'(',''),')',''), ',', '')), 8000) + 'X') -1)
			--									 end as Weight
			--									 --else dbo.GetNumbersFromString(Description) end as Weight 
			--									 --else cast(replace(replace(replace(Description, 'TBD', '0'), ',', ''), ' ', '') as int) end as Weight
			--				 from [Order Standards] with (nolock) 
			--				 where Section in ('Weight lbs +/- 2%', 'Weight lbs +/- 3%')) as subA on Orders.Quote# = subA.Quote# -- Adjusted to include for new Weight wording as per Shelley - JWC - Feb 11, 2022
			--left outer join (select Quote#, sum(Weight) as TtlOptWt
			--				 from (select Quote#, (Weight * Qty) as Weight 
			--					   from [Order Options] with (nolock)) as mainsub
			--				 group by Quote#) as subB on Orders.Quote# = subB.Quote#
			--left outer join (select Quote#, sum(Weight) as CWwt
			--				 from (select Quote#, (Weight * Qty) as Weight
			--					   from [Custom Work] with (nolock)) as mainsub
			--				 group by Quote#) as subC on Orders.Quote# = subC.Quote#
			--inner join #specs as sub on Orders.Quote# = sub.Quote#
			--inner join Dealers with (nolock) on Orders.DealerID = Dealers.ID
			--inner join [Sales Staff] with (nolock) on Orders.[Sale PersonID] = [Sales Staff].[ID-SaleStaff]
			--left outer join [Order Hours] with (nolock) on Orders.Quote# = [Order Hours].Quote#
			--left outer join @WidthSpreadandDeckLength as subD on Orders.Quote# = subD.Quote#
			--left outer join v_WORpt1_BOLNo on Orders.WO# = v_WORpt1_BOLNo.WO#
			--where Orders.Quote# = @QuoteorWO
			--or Orders.WO# = @QuoteorWO

			UPDATE
				@tWOs
			SET
				[Weight] = [Src].[Weight] + [Src].[TtlOptWt] + [Src].[CWwt]
			from (SELECT subA.[Weight], [TtlOptWt], [CWwt] FROM Orders with (nolock)
			inner join BWSdb.dbo.Products with (nolock) on Orders.[Model No] = Products.[Model No]
			left outer join Production with (nolock) on Orders.Quote# = Production.Quote#
			--left outer join SysproCompanyA.dbo.v_CompletedJobInfo with (nolock) on CAST(dbo.Orders.WO# AS varchar(20)) COLLATE Latin1_General_BIN = SysproCompanyA.dbo.v_CompletedJobInfo.Job
			left outer join ( 
							select *
							from (
									select *,
									ROW_NUMBER() over(partition by Job order by Job, InvoiceNumber desc) as RowID
									from SysproCompanyA.dbo.v_CompletedJobInfo with (nolock)
								) as subA
							where RowID = 1
							) as CompletedJobInfo on CAST(dbo.Orders.WO# AS varchar(20)) COLLATE Latin1_General_BIN = CompletedJobInfo.Job
			left outer join (select Quote#, case when Description is null then 0
												 else LEFT(SUBSTRING(replace(replace(replace(Description,'(',''),')',''), ',', ''), PATINDEX('%[0-9.-]%', replace(replace(replace(Description,'(',''),')',''), ',', '')), 8000),
															PATINDEX('%[^0-9.-]%', SUBSTRING(replace(replace(replace(Description,'(',''),')',''), ',', ''), PATINDEX('%[0-9.-]%', replace(replace(replace(Description,'(',''),')',''), ',', '')), 8000) + 'X') -1)
												 end as Weight
												 --else dbo.GetNumbersFromString(Description) end as Weight 
												 --else cast(replace(replace(replace(Description, 'TBD', '0'), ',', ''), ' ', '') as int) end as Weight
							 from [Order Standards] with (nolock) 
							 where Section in ('Weight lbs +/- 2%', 'Weight lbs +/- 3%')) as subA on Orders.Quote# = subA.Quote# -- Adjusted to include for new Weight wording as per Shelley - JWC - Feb 11, 2022
			left outer join (select Quote#, sum(Weight) as TtlOptWt
							 from (select Quote#, (Weight * Qty) as Weight 
								   from [Order Options] with (nolock)) as mainsub
							 group by Quote#) as subB on Orders.Quote# = subB.Quote#
			left outer join (select Quote#, sum(Weight) as CWwt
							 from (select Quote#, (Weight * Qty) as Weight
								   from [Custom Work] with (nolock)) as mainsub
							 group by Quote#) as subC on Orders.Quote# = subC.Quote#
			inner join #specs as sub on Orders.Quote# = sub.Quote#
			inner join Dealers with (nolock) on Orders.DealerID = Dealers.ID
			inner join [Sales Staff] with (nolock) on Orders.[Sale PersonID] = [Sales Staff].[ID-SaleStaff]
			left outer join [Order Hours] with (nolock) on Orders.Quote# = [Order Hours].Quote#
			left outer join @WidthSpreadandDeckLength as subD on Orders.Quote# = subD.Quote#
			left outer join v_WORpt1_BOLNo on Orders.WO# = v_WORpt1_BOLNo.WO#
			where Orders.Quote# = @QuoteorWO
			or Orders.WO# = @QuoteorWO
			) AS [Src]
		WHERE
			[@tWOs].[ID] = @i

		end
	else
		begin
			
			--Ensure there are Factory (WO Spec) Lines for @QuoteorWO and @QuoteorWORev
			if (select count(*) from [Order Options_FactoryLines_RevHistory] with (nolock) where (Quote# = @QuoteorWO or WO# = @QuoteorWO) and Rev# = @QuoteorWORev) = 0
				begin
					insert into [Order Options_FactoryLines_RevHistory] with (tablock) (Rev#, RevDate, [WO#], [Quote#], [Option No], [Description], [Line#], [SpecGroup], [SpecSortG], [SpecSection], [SpecSortSe], [SpecDescription], 
																						[SpecDescriptionBold], [SpecDescriptionItalic], [SpecDescriptionUnderline], [SpecDescriptionBackColour], [SpecDescriptionFontColour], [SpecSortSeLine], OrderOptionID)
					select [Order Options_RevHistory].Rev#, [Order Options_RevHistory].RevDate, [Order Options_RevHistory].[WO#], [Order Options_RevHistory].[Quote#], [Order Options_RevHistory].[Option No], [Order Options_RevHistory].[Description], [Line#], [SpecGroup], [SpecSortG], [SpecSection], [SpecSortSe], [SpecDescription], 
					[SpecDescriptionBold], [SpecDescriptionItalic], [SpecDescriptionUnderline], [SpecDescriptionBackColour], [SpecDescriptionFontColour], [SpecSortSeLine], [Order Options_RevHistory].OrdOptRevID#
					from [Order Options_SpecLines_RevHistory] with (nolock)
					inner join [Order Options_RevHistory] with (nolock) on [Order Options_SpecLines_RevHistory].Quote# = [Order Options_RevHistory].Quote#
															 and [Order Options_SpecLines_RevHistory].Rev# = [Order Options_RevHistory].Rev#
															 and [Order Options_SpecLines_RevHistory].OrderOptionID = [Order Options_RevHistory].OrdOptRevID#
					where ([Order Options_RevHistory].Quote# = @QuoteorWO or [Order Options_RevHistory].WO# = @QuoteorWO)
					and [Order Options_RevHistory].Rev# = @QuoteorWORev
				end

			if (select count(*) from [Custom Work_FactoryLines_RevHistory] with (nolock) where (Quote# = @QuoteorWO or WO# = @QuoteorWO) and Rev# = @QuoteorWORev) = 0
				begin
					insert into [Custom Work_FactoryLines_RevHistory] with (tablock) (Rev#, RevDate, [Quote#], [WO#], [Description], [Line#], [SpecGroup], [SpecSortG], [SpecSection], [SpecSortSe], [SpecDescription], [SpecDescriptionBold], 
																		   [SpecDescriptionItalic], [SpecDescriptionUnderline], [SpecDescriptionBackColour], [SpecDescriptionFontColour], [SpecSortSeLine], [NPOID])
					select [Custom Work_RevHistory].Rev#, [Custom Work_RevHistory].RevDate, [Custom Work_RevHistory].[Quote#], [Custom Work_RevHistory].[WO#], [Custom Work_RevHistory].[Description], [Line#], [SpecGroup], [SpecSortG], [SpecSection], [SpecSortSe], [SpecDescription], 
					[SpecDescriptionBold], [SpecDescriptionItalic], [SpecDescriptionUnderline], [SpecDescriptionBackColour], [SpecDescriptionFontColour], [SpecSortSeLine], [Custom Work_RevHistory].CWRevID#
					from [Custom Work_SpecLines_RevHistory] with (nolock)
					inner join [Custom Work_RevHistory] with (nolock) on [Custom Work_SpecLines_RevHistory].Quote# = [Custom Work_RevHistory].Quote#
														   and [Custom Work_SpecLines_RevHistory].Rev# = [Custom Work_RevHistory].Rev#
														   and [Custom Work_SpecLines_RevHistory].NPOID = [Custom Work_RevHistory].CWRevID#
					where ([Custom Work_RevHistory].Quote# = @QuoteorWO or [Custom Work_RevHistory].WO# = @QuoteorWO)
					and [Custom Work_RevHistory].Rev# = @QuoteorWORev
				end

			--Ensure there are NO duplicate WO spec lines
			delete from [Order Options_FactoryLines_RevHistory]
			where (Quote# = @QuoteorWO or WO# = @QuoteorWO)
			and OrdOptFLRevID# not in (select FirstID
										from (select Quote#, Rev#, WO#, [Option No], Description, SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecDescription, 
											  SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
											  SpecSortSeLine, OrderOptionID, min(OrdOptFLRevID#) as FirstID
											  from [Order Options_FactoryLines_RevHistory] with (nolock)
											  group by Quote#, Rev#, WO#, [Option No], Description, SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecDescription, 
											  SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
											  SpecSortSeLine, OrderOptionID
											  having count(*) >= 1) as subCount)

			delete from [Custom Work_FactoryLines_RevHistory]
			where (Quote# = @QuoteorWO or WO# = @QuoteorWO)
			and CWSLRevID# not in (select FirstID
									from (select Quote#, Rev#, WO#, Description, SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecDescription, 
										  SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
										  SpecSortSeLine, NPOID, min(CWSLRevID#) as FirstID
										  from [Custom Work_FactoryLines_RevHistory] with (nolock)
										  group by Quote#, Rev#, WO#, Description, SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecDescription, 
										  SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
										  SpecSortSeLine, NPOID
										  having count(*) >= 1) as subCount)

			--Insert specs for model into tv
			insert into #specs ([Quote#], WO#, [Group], SortGv2, Section, SortSev2, Description)
			select [Quote#], WO#, [Group], SortGv2, Section, SortSev2, Description from [Order Standards_RevHistory] with (nolock)
			where ([Quote#] = @QuoteorWO or WO# = @QuoteorWO)
			and Rev# = @QuoteorWORev

			--Insert option and npo spec lines into corresponding temp tables (for better report performance)
			insert into #optionspecs (WO#, Quote#, [Option No], Description, Line#, SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecDescription,
									  SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
									  SpecSortSeLine, OrderOptionID)
			select distinct [Order Options_RevHistory].WO#, [Order Options_RevHistory].Quote#, 
			[Order Options_RevHistory].[Option No], [Order Options_RevHistory].Description,
			case when [Are WO Specs Different?] = 0 then QuoteSpecs.Line# 
				 when [Are WO Specs Different?] = 1 then WOSpecs.Line# end as Line,
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecGroup 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecGroup end) as SpecGroup, 
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecSortG 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecSortG end) as SpecSortG, 
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecSection 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecSection end) as SpecSection, 
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecSortSe 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecSortSe end) as SpecSortSe, 
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecDescription 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecDescription end) as SpecDescription,
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecDescriptionBold 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecDescriptionBold end) as SpecDescriptionBold, 
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecDescriptionItalic 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecDescriptionItalic end) as SpecDescriptionItalic, 
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecDescriptionUnderline 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecDescriptionUnderline end) as SpecDescriptionUnderline, 
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecDescriptionBackColour 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecDescriptionBackColour end) as SpecDescriptionBackColour, 
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecDescriptionFontColour 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecDescriptionFontColour end) as SpecDescriptionFontColour,
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecSortSeLine 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecSortSeLine end) as SpecSortSeLine, 
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.OrderOptionID 
				  when [Are WO Specs Different?] = 1 then WOSpecs.OrderOptionID end) as OrderOptionID
			from [Order Options_RevHistory] with (nolock)
			left outer join [Order Options_SpecLines_RevHistory] as QuoteSpecs with (nolock) on [Order Options_RevHistory].Quote# = QuoteSpecs.Quote#
																								and [Order Options_RevHistory].[Option No] = QuoteSpecs.[Option No]
																								and [Order Options_RevHistory].Description = QuoteSpecs.Description
			left outer join [Order Options_FactoryLines_RevHistory] as WOSpecs with (nolock) on [Order Options_RevHistory].Quote# = WOSpecs.Quote#
																								and [Order Options_RevHistory].[Option No] = WOSpecs.[Option No]
																								and [Order Options_RevHistory].Description = WOSpecs.Description
			where ([Order Options_RevHistory].[Quote#] = @QuoteorWO or [Order Options_RevHistory].WO# = @QuoteorWO)
			and [Order Options_RevHistory].Rev# = @QuoteorWORev

			insert into #npospecs (WO#, Quote#, Description, Line#, SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecDescription,
								   SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
								   SpecSortSeLine, NPOID)
			select distinct [Custom Work_RevHistory].WO#, [Custom Work_RevHistory].Quote#, [Custom Work_RevHistory].Description,
			case when [Are WO Specs Different?] = 0 then QuoteSpecs.Line# 
				 when [Are WO Specs Different?] = 1 then WOSpecs.Line# end as Line,
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecGroup 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecGroup end) as SpecGroup, 
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecSortG 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecSortG end) as SpecSortG, 
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecSection 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecSection end) as SpecSection, 
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecSortSe 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecSortSe end) as SpecSortSe, 
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecDescription 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecDescription end) as SpecDescription,
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecDescriptionBold 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecDescriptionBold end) as SpecDescriptionBold, 
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecDescriptionItalic 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecDescriptionItalic end) as SpecDescriptionItalic, 
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecDescriptionUnderline 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecDescriptionUnderline end) as SpecDescriptionUnderline, 
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecDescriptionBackColour 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecDescriptionBackColour end) as SpecDescriptionBackColour, 
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecDescriptionFontColour 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecDescriptionFontColour end) as SpecDescriptionFontColour,
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.SpecSortSeLine 
				  when [Are WO Specs Different?] = 1 then WOSpecs.SpecSortSeLine end) as SpecSortSeLine, 
			(case when [Are WO Specs Different?] = 0 then QuoteSpecs.NPOID 
				  when [Are WO Specs Different?] = 1 then WOSpecs.NPOID end) as NPOID
			from [Custom Work_RevHistory] with (nolock)
			left outer join [Custom Work_SpecLines_RevHistory] as QuoteSpecs with (nolock) on [Custom Work_RevHistory].Quote# = QuoteSpecs.Quote#
																							  and ([Custom Work_RevHistory].Description = QuoteSpecs.Description
																								   or [Custom Work_RevHistory].CWRevID# = QuoteSpecs.NPOID)
			left outer join [Custom Work_FactoryLines_RevHistory] as WOSpecs with (nolock) on [Custom Work_RevHistory].Quote# = WOSpecs.Quote#
																							  and ([Custom Work_RevHistory].Description = WOSpecs.Description
																								   or [Custom Work_RevHistory].CWRevID# = WOSpecs.NPOID)
			where ([Custom Work_RevHistory].[Quote#] = @QuoteorWO or [Custom Work_RevHistory].WO# = @QuoteorWO)
			and [Custom Work_RevHistory].Rev# = @QuoteorWORev

			--Insert lines from options into tv with replace code >= 1
			insert into #specs (OptionNPOID, [Quote#], WO#, [Group], SortGv2, Section, SortSev2, SpecSortSeLine, Description, Bold, Italic, Underline, BackColour, FontColour, [Steel Kit], Axles, [Step 1], [Step 2], Blast, Paint, [Finish - GNK], [Final Assembly], [Tire Assembly], Shipping, [Draw/Part#], OptNPOWt)
			select OptionNPOID, [Quote#], WO#, SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, OptionD, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour, [Steel Kit], Axles, [Step 1], [Step 2], Blast, Paint, [Finish - GNK], [Final Assembly], [Tire Assembly], Shipping, [Draw/Part#], Wt
			from (select case when Line# = 1 then [Order Options_RevHistory].OrdOptRevID# else null end as OptionNPOID,
				  [Order Options_RevHistory].[Quote#], [Order Options_RevHistory].WO#, SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, case when Qty > 1 then convert(nvarchar, Qty) + ', ' + SpecDescription else SpecDescription end as OptionD, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
				  case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
				  case when Line# = 1 then Axles * Qty else 0 end as Axles, 
				  case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
				  case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
				  case when Line# = 1 then Blast * Qty else 0 end as Blast, 
				  case when Line# = 1 then Paint * Qty else 0 end as Paint, 
				  case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
				  case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
				  case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly], 
				  case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
				  case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
				  case when Line# = 1 then Weight * Qty else 0 end as Wt
				  from [Order Options_RevHistory] with (nolock)
				  inner join #optionspecs as OptionSpecs with (nolock) on [Order Options_RevHistory].Quote# = OptionSpecs.Quote#
																		  and [Order Options_RevHistory].OrdOptRevID# = OptionSpecs.OrderOptionID
				  where ([Order Options_RevHistory].[Quote#] = @QuoteorWO or [Order Options_RevHistory].WO# = @QuoteorWO) and [Order Options_RevHistory].Rev# = @QuoteorWORev and SpecSortG is not null and SpecSortSeLine >= 1) as mainsub
			left outer join (select SortGv2, SortSev2, Description from #specs) as b on mainsub.SpecSortG = b.SortGv2 and mainsub.SpecSortSe = b.SortSev2 and mainsub.OptionD = b.Description

			--Update lines from options with replace code = 0
			update #specs
			set OptionNPOID = b.OptionNPOID,
			Description = b.OptionD,
			[Steel Kit] = case when a.[Steel Kit] is null then b.[Steel Kit] else a.[Steel Kit] + b.[Steel Kit] end,
			Axles = case when a.Axles is null then b.Axles else a.Axles + b.Axles end,
			[Step 1] = case when a.[Step 1] is null then b.[Step 1] else a.[Step 1] + b.[Step 1] end,
			[Step 2] = case when a.[Step 2] is null then b.[Step 2] else a.[Step 2] + b.[Step 2] end,
			Blast = case when a.Blast is null then b.Blast else a.Blast + b.Blast end,
			Paint = case when a.Paint is null then b.Paint else a.Paint + b.Paint end,
			[Finish - GNK] = case when a.[Finish - GNK] is null then b.[Finish - GNK] else a.[Finish - GNK] + b.[Finish - GNK] end,
			[Final Assembly] = case when a.[Final Assembly] is null then b.[Final Assembly] else a.[Final Assembly] + b.[Final Assembly] end,
			[Tire Assembly] = case when a.[Tire Assembly] is null then b.[Tire Assembly] else a.[Tire Assembly] + b.[Tire Assembly] end,
			Shipping = case when a.Shipping is null then b.Shipping else a.Shipping + b.Shipping end,
			Bold = b.SpecDescriptionBold,
			Italic = b.SpecDescriptionItalic,
			Underline = b.SpecDescriptionUnderline,
			BackColour = b.SpecDescriptionBackColour,
			FontColour = b.SpecDescriptionFontColour,
			[Draw/Part#] = case when b.[Draw/Part#] is null then a.[Draw/Part#]  when a.[Draw/Part#] is null then b.[Draw/Part#] else a.[Draw/Part#] + '
			' + b.[Draw/Part#] end,
			OptNPOWt = b.Wt
			from #specs as a
			inner join (select OptionNPOID, [Quote#], WO#, SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, OptionD, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour, [Steel Kit], Axles, [Step 1], [Step 2], Blast, Paint, [Finish - GNK], [Final Assembly], [Tire Assembly], Shipping, [Draw/Part#], Wt 
						from (select case when Line# = 1 then [Order Options_RevHistory].OrdOptRevID# else null end as OptionNPOID,
							  [Order Options_RevHistory].[Quote#], [Order Options_RevHistory].WO#, SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, case when Qty > 1 then convert(nvarchar, Qty) + ', ' + SpecDescription else SpecDescription end as OptionD, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
							  case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
							  case when Line# = 1 then Axles * Qty else 0 end as Axles, 
							  case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
							  case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
							  case when Line# = 1 then Blast * Qty else 0 end as Blast, 
							  case when Line# = 1 then Paint * Qty else 0 end as Paint, 
							  case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
							  case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
							  case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly], 
							  case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
							  case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
							  case when Line# = 1 then Weight * Qty else 0 end as Wt
							  from [Order Options_RevHistory] with (nolock)
							  inner join #optionspecs as OptionSpecs with (nolock) on [Order Options_RevHistory].Quote# = OptionSpecs.Quote#
																					and [Order Options_RevHistory].OrdOptRevID# = OptionSpecs.OrderOptionID
							  where ([Order Options_RevHistory].[Quote#] = @QuoteorWO or [Order Options_RevHistory].WO# = @QuoteorWO) and [Order Options_RevHistory].Rev# = @QuoteorWORev and SpecSortG is not null and SpecSortSeLine = 0) as mainsub) as b on a.[Quote#] = b.[Quote#] and a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe and a.SpecSortSeLine = b.SpecSortSeLine

			--Insert lines from options with replace code >= 0 and are non-existant in specs tv
			insert into #specs (OptionNPOID, [Quote#], WO#, [Group], SortGv2, Section, SortSev2, SpecSortSeLine, Description, Bold, Italic, Underline, BackColour, FontColour, [Steel Kit], Axles, [Step 1], [Step 2], Blast, Paint, [Finish - GNK], [Final Assembly], [Tire Assembly], Shipping, [Draw/Part#], OptNPOWt)
			select OptionNPOID, [Quote#], WO#, SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, OptionD, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour, [Steel Kit], Axles, [Step 1], [Step 2], Blast, Paint, [Finish - GNK], [Final Assembly], [Tire Assembly], Shipping, [Draw/Part#], Wt
						from (select case when Line# = 1 then [Order Options_RevHistory].OrdOptRevID# else null end as OptionNPOID,
							  [Order Options_RevHistory].[Quote#], [Order Options_RevHistory].WO#, SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, case when Qty > 1 then convert(nvarchar, Qty) + ', ' + SpecDescription else SpecDescription end as OptionD, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
							  case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
							  case when Line# = 1 then Axles * Qty else 0 end as Axles, 
							  case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
							  case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
							  case when Line# = 1 then Blast * Qty else 0 end as Blast, 
							  case when Line# = 1 then Paint * Qty else 0 end as Paint, 
							  case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
							  case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
							  case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly], 
							  case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
							  case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
							  case when Line# = 1 then Weight * Qty else 0 end as Wt
							  from [Order Options_RevHistory] with (nolock)
							  inner join #optionspecs as OptionSpecs with (nolock) on [Order Options_RevHistory].Quote# = OptionSpecs.Quote#
																					and [Order Options_RevHistory].OrdOptRevID# = OptionSpecs.OrderOptionID
							  where ([Order Options_RevHistory].[Quote#] = @QuoteorWO or [Order Options_RevHistory].WO# = @QuoteorWO) and [Order Options_RevHistory].Rev# = @QuoteorWORev and SpecSortG is not null and SpecSortSeLine >= 0) as mainsub
			left outer join (select SortGv2, SortSev2, Description from #specs) as b on mainsub.SpecSortG = b.SortGv2 and mainsub.SpecSortSe = b.SortSev2 and mainsub.OptionD = b.Description
			where SortSev2 is null
			and Description is null

			--Insert lines from npos with replace code >= 1
			insert into #specs (OptionNPOID, [Quote#], WO#, [Group], SortGv2, Section, SortSev2, SpecSortSeLine, Description, Bold, Italic, Underline, BackColour, FontColour, [Steel Kit], Axles, [Step 1], [Step 2], Blast, Paint, [Finish - GNK], [Final Assembly], [Tire Assembly], Shipping, [Draw/Part#], OptNPOWt)
			select OptionNPOID, [Quote#], WO#, SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, NPOD, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour, [Steel Kit], Axles, [Step 1], [Step 2], Blast, Paint, [Finish - GNK], [Final Assembly], [Tire Assembly], Shipping, [Draw/Part#], Wt
			from (select case when Line# = 1 then [Custom Work_RevHistory].CWRevID# else null end as OptionNPOID,
				  [Custom Work_RevHistory].[Quote#], [Custom Work_RevHistory].WO#, SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, '*NPO*: ' + case when Qty > 1 then convert(nvarchar, Qty) + ', ' + SpecDescription else SpecDescription end as NPOD, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
				  case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
				  case when Line# = 1 then Axles * Qty else 0 end as Axles, 
				  case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
				  case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
				  case when Line# = 1 then Blast * Qty else 0 end as Blast, 
				  case when Line# = 1 then Paint * Qty else 0 end as Paint, 
				  case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
				  case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
				  case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly], 
				  case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
				  case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
				  case when Line# = 1 then Weight * Qty else 0 end as Wt
				  from [Custom Work_RevHistory] with (nolock)
				  inner join #npospecs as NPOSpecs with (nolock) on [Custom Work_RevHistory].Quote# = NPOSpecs.Quote#
																	  and [Custom Work_RevHistory].CWRevID# = NPOSpecs.NPOID
				  where ([Custom Work_RevHistory].[Quote#] = @QuoteorWO or [Custom Work_RevHistory].WO# = @QuoteorWO) and [Custom Work_RevHistory].Rev# = @QuoteorWORev and SpecSortG is not null and SpecSortSeLine >= 1) as mainsub
			left outer join (select SortGv2, SortSev2, Description from #specs) as b on mainsub.SpecSortG = b.SortGv2 and mainsub.SpecSortSe = b.SortSev2 and mainsub.NPOD = b.Description

			--Update lines from npos with replace code = 0
			update #specs
			set OptionNPOID = b.OptionNPOID,
			Description = b.NPOD,
			[Steel Kit] = case when a.[Steel Kit] is null then b.[Steel Kit] else a.[Steel Kit] + b.[Steel Kit] end,
			Axles = case when a.Axles is null then b.Axles else a.Axles + b.Axles end,
			[Step 1] = case when a.[Step 1] is null then b.[Step 1] else a.[Step 1] + b.[Step 1] end,
			[Step 2] = case when a.[Step 2] is null then b.[Step 2] else a.[Step 2] + b.[Step 2] end,
			Blast = case when a.Blast is null then b.Blast else a.Blast + b.Blast end,
			Paint = case when a.Paint is null then b.Paint else a.Paint + b.Paint end,
			[Finish - GNK] = case when a.[Finish - GNK] is null then b.[Finish - GNK] else a.[Finish - GNK] + b.[Finish - GNK] end,
			[Final Assembly] = case when a.[Final Assembly] is null then b.[Final Assembly] else a.[Final Assembly] + b.[Final Assembly] end,
			[Tire Assembly] = case when a.[Tire Assembly] is null then b.[Tire Assembly] else a.[Tire Assembly] + b.[Tire Assembly] end,
			Shipping = case when a.Shipping is null then b.Shipping else a.Shipping + b.Shipping end,
			Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
			Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
			Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
			BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
			FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end,
			[Draw/Part#] = case when b.[Draw/Part#] is null then a.[Draw/Part#]  when a.[Draw/Part#] is null then b.[Draw/Part#] else a.[Draw/Part#] + '
			' + b.[Draw/Part#] end,
			OptNPOWt = b.Wt
			from #specs as a
			inner join (select OptionNPOID, [Quote#], WO#, SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, NPOD, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour, [Steel Kit], Axles, [Step 1], [Step 2], Blast, Paint, [Finish - GNK], [Final Assembly], [Tire Assembly], Shipping, [Draw/Part#], Wt
						from (select case when Line# = 1 then [Custom Work_RevHistory].CWRevID# else null end as OptionNPOID,
							  [Custom Work_RevHistory].[Quote#], [Custom Work_RevHistory].WO#, SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, '*NPO*: ' + case when Qty > 1 then convert(nvarchar, Qty) + ', ' + SpecDescription else SpecDescription end as NPOD, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
							  case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
							  case when Line# = 1 then Axles * Qty else 0 end as Axles, 
							  case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
							  case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
							  case when Line# = 1 then Blast * Qty else 0 end as Blast, 
							  case when Line# = 1 then Paint * Qty else 0 end as Paint, 
							  case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
							  case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
							  case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly], 
							  case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
							  case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
							  case when Line# = 1 then Weight * Qty else 0 end as Wt
							  from [Custom Work_RevHistory] with (nolock)
							  inner join #npospecs as NPOSpecs with (nolock) on [Custom Work_RevHistory].Quote# = NPOSpecs.Quote#
																				  and [Custom Work_RevHistory].CWRevID# = NPOSpecs.NPOID
							  where ([Custom Work_RevHistory].[Quote#] = @QuoteorWO or [Custom Work_RevHistory].WO# = @QuoteorWO) and SpecSortG is not null and SpecSortSeLine = 0) as mainsub) as b on a.[Quote#] = b.[Quote#] and a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe and a.SpecSortSeLine = b.SpecSortSeLine

			--Insert lines from npos with replace code >= 0 and are non-existant in specs tv
			insert into #specs (OptionNPOID, [Quote#], WO#, [Group], SortGv2, Section, SortSev2, SpecSortSeLine, Description, Bold, Italic, Underline, BackColour, FontColour, [Steel Kit], Axles, [Step 1], [Step 2], Blast, Paint, [Finish - GNK], [Final Assembly], [Tire Assembly], Shipping, [Draw/Part#], OptNPOWt)
			select OptionNPOID, [Quote#], WO#, SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, NPOD, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour, [Steel Kit], Axles, [Step 1], [Step 2], Blast, Paint, [Finish - GNK], [Final Assembly], [Tire Assembly], Shipping, [Draw/Part#], Wt
			from (select case when Line# = 1 then [Custom Work_RevHistory].CWRevID# else null end as OptionNPOID,
				  [Custom Work_RevHistory].[Quote#], [Custom Work_RevHistory].WO#, SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, '*NPO*: ' + case when Qty > 1 then convert(nvarchar, Qty) + ', ' + SpecDescription else SpecDescription end as NPOD, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
				  case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
				  case when Line# = 1 then Axles * Qty else 0 end as Axles, 
				  case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
				  case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
				  case when Line# = 1 then Blast * Qty else 0 end as Blast, 
				  case when Line# = 1 then Paint * Qty else 0 end as Paint, 
				  case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
				  case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
				  case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly], 
				  case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
				  case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
				  case when Line# = 1 then Weight * Qty else 0 end as Wt
				  from [Custom Work_RevHistory] with (nolock)
				  inner join #npospecs as NPOSpecs with (nolock) on [Custom Work_RevHistory].Quote# = NPOSpecs.Quote#
																	  and [Custom Work_RevHistory].CWRevID# = NPOSpecs.NPOID
				  where ([Custom Work_RevHistory].[Quote#] = @QuoteorWO or [Custom Work_RevHistory].WO# = @QuoteorWO) and [Custom Work_RevHistory].Rev# = @QuoteorWORev and SpecSortG is not null and SpecSortSeLine >= 0) as mainsub
			left outer join (select SortGv2, SortSev2, Description from #specs) as b on mainsub.SpecSortG = b.SortGv2 and mainsub.SpecSortSe = b.SortSev2 and mainsub.NPOD = b.Description
			where SortSev2 is null
			and Description is null

			--Update "Weight lbs +/- 2%" spec line based on total weight from options and npos (WITH ", including options" WORDING TO AVOID CONFUSION)
			update #specs
			set Description = cast(b.Weight as nvarchar) + ', including options'
			from #specs as a
			cross join (select sum(Weight) as Weight 
						from (select case when Description is null then 0 
										  else cast(dbo.GetNumbersFromString(replace(replace(Description, ',', ''), ' ', '')) as int) end as Weight
							  from #specs
							  where Section in ('Weight lbs +/- 2%', 'Weight lbs +/- 3%') -- Adjusted to include for new Weight wording as per Shelley - JWC - Feb 11, 2022

							  union all select sum(Weight)
							  from (select (Weight * Qty) as Weight 
									from [Order Options_RevHistory] with (nolock)
									where (Quote# = @QuoteorWO or WO# = @QuoteorWO)
									and Rev# = @QuoteorWORev
							
									union all select sum(Weight * Qty)
									from [Custom Work_RevHistory] with (nolock)
									where (Quote# = @QuoteorWO or WO# = @QuoteorWO)
									and Rev# = @QuoteorWORev) as mainsub) as mainsub) as b
			where Section in ('Weight lbs +/- 2%', 'Weight lbs +/- 3%') -- Adjusted to include for new Weight wording as per Shelley - JWC - Feb 11, 2022

			--Update lines from options and npos with code -99 (addition to first int value in string only)
			--Code reference for selecting int: http://stackoverflow.com/a/16667778/4027761 + http://stackoverflow.com/questions/9136722/sql-server-2008-error-converting-data-type-nvarchar-to-float
			update #specs
			set OptionNPOID = case when b.OptionNPOID is null then a.OptionNPOID else b.OptionNPOID end,
			Description = case when subC.NetSD is null then a.Description
							  else replace(a.Description, 
								   left(SUBSTRING(a.Description, PATINDEX('%[0-9]%', a.Description), len(a.Description)), PATINDEX('%[^0-9]%', SUBSTRING(a.Description, PATINDEX('%[0-9]%', a.Description), len(a.Description)) + 't') - 1), 
								   case when NPOIndicator = 1 then '(*NPO*->) ' else '' end + cast(cast(left(SUBSTRING(a.Description, PATINDEX('%[0-9]%', a.Description), len(a.Description)), PATINDEX('%[^0-9]%', SUBSTRING(a.Description, PATINDEX('%[0-9]%', a.Description), len(a.Description)) + 't') - 1) as float) + subC.NetSD as nvarchar)) end,
			[Steel Kit] = case when b.[Steel Kit] is null then a.[Steel Kit] when a.[Steel Kit] is null then b.[Steel Kit] else a.[Steel Kit] + b.[Steel Kit] end,
			Axles = case when b.Axles is null then a.Axles when a.Axles is null then b.Axles else a.Axles + b.Axles end,
			[Step 1] = case when b.[Step 1] is null then a.[Step 1] when a.[Step 1] is null then b.[Step 1] else a.[Step 1] + b.[Step 1] end,
			[Step 2] = case when b.[Step 2] is null then a.[Step 2] when a.[Step 2] is null then b.[Step 2] else a.[Step 2] + b.[Step 2] end,
			Blast = case when b.Blast is null then a.Blast when a.Blast is null then b.Blast else a.Blast + b.Blast end,
			Paint = case when b.Paint is null then a.Paint when a.Paint is null then b.Paint else a.Paint + b.Paint end,
			[Finish - GNK] = case when b.[Finish - GNK] is null then a.[Finish - GNK] when a.[Finish - GNK] is null then b.[Finish - GNK] else a.[Finish - GNK] + b.[Finish - GNK] end,
			[Final Assembly] = case when b.[Final Assembly] is null then a.[Final Assembly] when a.[Final Assembly] is null then b.[Final Assembly] else a.[Final Assembly] + b.[Final Assembly] end,
			[Tire Assembly] = case when b.[Tire Assembly] is null then a.[Tire Assembly] when a.[Tire Assembly] is null then b.[Tire Assembly] else a.[Tire Assembly] + b.[Tire Assembly] end,
			Shipping = case when b.Shipping is null then a.Shipping when a.Shipping is null then b.Shipping else a.Shipping + b.Shipping end,
			[Draw/Part#] = case when b.[Draw/Part#] is null then a.[Draw/Part#]  when a.[Draw/Part#] is null then b.[Draw/Part#] else a.[Draw/Part#] + '
			' + b.[Draw/Part#] end,
			OptNPOWt = case when b.Weight is null then a.OptNPOWt else a.OptNPOWt + b.Weight end,
			Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
			Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
			Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
			BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
			FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end
			from #specs as a
			left outer join (select mainsub.OptionNPOID, mainsub.SpecSortG, mainsub.SpecSortSe, mainsub.NPOIndicator, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour, [Steel Kit], Axles, [Step 1], [Step 2], Blast, Paint, [Finish - GNK], [Final Assembly], [Tire Assembly], Shipping, Weight, subA.[Draw/Part#]
							 from (select OptionNPOID, SpecSortG, SpecSortSe, max(NPOIndicator) as NPOIndicator, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour, 
								   sum([Steel Kit]) as [Steel Kit], sum(Axles) as Axles, sum([Step 1]) as [Step 1], sum([Step 2]) as [Step 2], sum(Blast) as Blast, sum(Paint) as Paint, sum([Finish - GNK]) as [Finish - GNK], sum([Final Assembly]) as [Final Assembly], sum([Tire Assembly]) as [Tire Assembly], sum(Shipping) as Shipping, sum(Wt) as Weight
								   from (select b.OrdOptRevID# as OptionNPOID, OptionSpecs.SpecSortG, OptionSpecs.SpecSortSe, 0 as NPOIndicator, 
										 SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
										 case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
										 case when Line# = 1 then Axles * Qty else 0 end as Axles, 
										 case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
										 case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
										 case when Line# = 1 then Blast * Qty else 0 end as Blast, 
										 case when Line# = 1 then Paint * Qty else 0 end as Paint, 
										 case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
										 case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
										 case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly], 
										 case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
										 case when Line# = 1 then Weight * Qty else 0 end as Wt
										 from [Order Options_RevHistory] with (nolock)
										 inner join #optionspecs as OptionSpecs with (nolock) on [Order Options_RevHistory].Quote# = OptionSpecs.Quote#
																							   and [Order Options_RevHistory].OrdOptRevID# = OptionSpecs.OrderOptionID
										 left outer join (select SpecSortG, SpecSortSe, [Order Options_RevHistory].OrdOptRevID# from [Order Options_RevHistory] with (nolock)
														  inner join [Order Options_FactoryLines_RevHistory] with (nolock) on [Order Options_RevHistory].Quote# = [Order Options_FactoryLines_RevHistory].Quote#
																											    and [Order Options_RevHistory].Rev# = [Order Options_FactoryLines_RevHistory].Rev#
																												and [Order Options_RevHistory].OrdOptRevID# = [Order Options_FactoryLines_RevHistory].OrderOptionID
														  where ([Order Options_RevHistory].Quote# = @QuoteorWO or [Order Options_RevHistory].WO# = @QuoteorWO) and [Order Options_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-99' and Line# = 1) as b on OptionSpecs.SpecSortG = b.SpecSortG and OptionSpecs.SpecSortSe = b.SpecSortSe
										 where ([Order Options_RevHistory].Quote# = @QuoteorWO or [Order Options_RevHistory].WO# = @QuoteorWO) and [Order Options_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-99'
 
										 union all select b.CWRevID# as OptionNPOID, NPOSpecs.SpecSortG, NPOSpecs.SpecSortSe, 1,
										 SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
										 case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
										 case when Line# = 1 then Axles * Qty else 0 end as Axles, 
										 case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
										 case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
										 case when Line# = 1 then Blast * Qty else 0 end as Blast, 
										 case when Line# = 1 then Paint * Qty else 0 end as Paint, 
										 case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
										 case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
										 case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly], 
										 case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
										 case when Line# = 1 then Weight * Qty else 0 end as Wt
										 from [Custom Work_RevHistory] with (nolock)
										 inner join #npospecs as NPOSpecs with (nolock) on [Custom Work_RevHistory].Quote# = NPOSpecs.Quote#
																							 and [Custom Work_RevHistory].CWRevID# = NPOSpecs.NPOID
										 left outer join (select SpecSortG, SpecSortSe, [Custom Work_RevHistory].CWRevID# from [Custom Work_RevHistory] with (nolock)
														  inner join #npospecs as NPOSpecs with (nolock) on [Custom Work_RevHistory].Quote# = NPOSpecs.Quote#
																											  and [Custom Work_RevHistory].CWRevID# = NPOSpecs.NPOID
														  where ([Custom Work_RevHistory].Quote# = @QuoteorWO or [Custom Work_RevHistory].WO# = @QuoteorWO) and [Custom Work_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-99' and Line# = 1) as b on NPOSpecs.SpecSortG = b.SpecSortG and NPOSpecs.SpecSortSe = b.SpecSortSe
										 where ([Custom Work_RevHistory].[Quote#] = @QuoteorWO or [Custom Work_RevHistory].WO# = @QuoteorWO) and [Custom Work_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-99') as mainsub
									group by OptionNPOID, SpecSortG, SpecSortSe, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour) as mainsub
								left outer join (select [Order Options_RevHistory].OrdOptRevID#, [Draw/Part#] from [Order Options_RevHistory] with (nolock)
												 inner join #optionspecs as OptionSpecs with (nolock) on [Order Options_RevHistory].Quote# = OptionSpecs.Quote#
																									   and [Order Options_RevHistory].OrdOptRevID# = OptionSpecs.OrderOptionID
												 where ([Order Options_RevHistory].Quote# = @QuoteorWO or [Order Options_RevHistory].WO# = @QuoteorWO) and [Order Options_RevHistory].Rev# = @QuoteorWORev and Line# = 1
									
												 union all select [Custom Work_RevHistory].CWRevID#, [Draw/Part#] from [Custom Work_RevHistory] with (nolock)
												 inner join #npospecs as NPOSpecs with (nolock) on [Custom Work_RevHistory].Quote# = NPOSpecs.Quote#
																									 and [Custom Work_RevHistory].CWRevID# = NPOSpecs.NPOID
												 where ([Custom Work_RevHistory].[Quote#] = @QuoteorWO or [Custom Work_RevHistory].WO# = @QuoteorWO) and [Custom Work_RevHistory].Rev# = @QuoteorWORev and Line# = 1) as subA on mainsub.OptionNPOID = subA.OrdOptRevID#) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe
				left outer join (select SpecSortG, SpecSortSe, sum(SD) as NetSD
									from (select OptionSpecs.SpecSortG, OptionSpecs.SpecSortSe, convert(float, case when isnumeric(SpecDescription) = 0 then null else SpecDescription end) * Qty as SD
											from [Order Options_RevHistory] with (nolock)
										 inner join #optionspecs as OptionSpecs with (nolock) on [Order Options_RevHistory].Quote# = OptionSpecs.Quote#
																							   and [Order Options_RevHistory].OrdOptRevID# = OptionSpecs.OrderOptionID
										 left outer join (select SpecSortG, SpecSortSe, [Order Options_RevHistory].OrdOptRevID# from [Order Options_RevHistory] with (nolock)
														  inner join [Order Options_FactoryLines_RevHistory] with (nolock) on [Order Options_RevHistory].Quote# = [Order Options_FactoryLines_RevHistory].Quote#
																											    and [Order Options_RevHistory].Rev# = [Order Options_FactoryLines_RevHistory].Rev#
																												and [Order Options_RevHistory].OrdOptRevID# = [Order Options_FactoryLines_RevHistory].OrderOptionID
														  where ([Order Options_RevHistory].Quote# = @QuoteorWO or [Order Options_RevHistory].WO# = @QuoteorWO) and [Order Options_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-99' and Line# = 1) as b on OptionSpecs.SpecSortG = b.SpecSortG and OptionSpecs.SpecSortSe = b.SpecSortSe
										 where ([Order Options_RevHistory].Quote# = @QuoteorWO or [Order Options_RevHistory].WO# = @QuoteorWO) and [Order Options_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-99'

											union all select NPOSpecs.SpecSortG, NPOSpecs.SpecSortSe, convert(float, case when isnumeric(SpecDescription) = 0 then null else SpecDescription end) * Qty as SD
											from [Custom Work_RevHistory] with (nolock)
										 inner join #npospecs as NPOSpecs with (nolock) on [Custom Work_RevHistory].Quote# = NPOSpecs.Quote#
																							 and [Custom Work_RevHistory].CWRevID# = NPOSpecs.NPOID
										 left outer join (select SpecSortG, SpecSortSe, [Custom Work_RevHistory].CWRevID# from [Custom Work_RevHistory] with (nolock)
														  inner join #npospecs as NPOSpecs with (nolock) on [Custom Work_RevHistory].Quote# = NPOSpecs.Quote#
																											  and [Custom Work_RevHistory].CWRevID# = NPOSpecs.NPOID
														  where ([Custom Work_RevHistory].Quote# = @QuoteorWO or [Custom Work_RevHistory].WO# = @QuoteorWO) and [Custom Work_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-99' and Line# = 1) as b on NPOSpecs.SpecSortG = b.SpecSortG and NPOSpecs.SpecSortSe = b.SpecSortSe
										 where ([Custom Work_RevHistory].[Quote#] = @QuoteorWO or [Custom Work_RevHistory].WO# = @QuoteorWO) and [Custom Work_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-99') as mainsubB
									group by SpecSortG, SpecSortSe) as subC on a.SortGv2 = subC.SpecSortG
																			   and a.SortSev2 = subC.SpecSortSe
				where a.SpecID = any (select MinID from (select min(SpecID) as MinID, SortGv2, SortSev2 from #specs 
														 group by SortGv2, SortSev2) as mainsub
														 group by MinID)

			--Insert line address and descriptions containing 'ft' and/or 'in' (both WITHOUT decimal values)
			--Look here if you decide to look for whole int value next to "in.": http://stackoverflow.com/questions/32971430/select-first-int-before-characters-in-string
			insert into @ftandin (SortGv2, SortSev2, Feet, FeetPosition, Inches, InchesPosition)
			select SortGv2, SortSev2, 
			case when CHARINDEX('ft.', Description) = 0 then 0
		 				   else cast(left(substring(Description, case when patindex('%[0-9][0-9] ft%', Description) = 0 then patindex('%[0-9] ft%', Description)
															  when patindex('%[0-9][0-9][0-9] ft%', Description) = 0 then patindex('%[0-9][0-9] ft%', Description)
															  else patindex('%[0-9][0-9][0-9] ft%', Description) end, len(Description)), patindex('%[^0-9]%', substring(Description, case when patindex('%[0-9][0-9] ft%', Description) = 0 then patindex('%[0-9] ft%', Description)
																																														  when patindex('%[0-9][0-9][0-9] ft%', Description) = 0 then patindex('%[0-9][0-9] ft%', Description)
																																														  else patindex('%[0-9][0-9][0-9] ft%', Description) end, len(Description))) - 1) as int) end as Feet,
			case when CHARINDEX('ft.', Description) = 0 then 0
		 				   else CHARINDEX(left(substring(Description, case when patindex('%[0-9][0-9] ft%', Description) = 0 then patindex('%[0-9] ft%', Description)
																   when patindex('%[0-9][0-9][0-9] ft%', Description) = 0 then patindex('%[0-9][0-9] ft%', Description)
																   else patindex('%[0-9][0-9][0-9] ft%', Description) end, len(Description)), patindex('%[^0-9]%', substring(Description, case when patindex('%[0-9][0-9] ft%', Description) = 0 then patindex('%[0-9] ft%', Description)
																																														  when patindex('%[0-9][0-9][0-9] ft%', Description) = 0 then patindex('%[0-9][0-9] ft%', Description)
																																														  else patindex('%[0-9][0-9][0-9] ft%', Description) end, len(Description))) - 1), Description) end as FeetPosition,
			case when CHARINDEX('in.', Description) = 0 then 0
				 else cast(left(substring(Description, case when patindex('%[0-9][0-9] in%', Description) = 0 then patindex('%[0-9] in%', Description)
															when patindex('%[0-9][0-9][0-9] in%', Description) = 0 then patindex('%[0-9][0-9] in%', Description)
															else patindex('%[0-9][0-9][0-9] in%', Description) end, len(Description)), patindex('%[^0-9]%', substring(Description, case when patindex('%[0-9][0-9] in%', Description) = 0 then patindex('%[0-9] in%', Description)
																																														when patindex('%[0-9][0-9][0-9] in%', Description) = 0 then patindex('%[0-9][0-9] in%', Description)
																																														else patindex('%[0-9][0-9][0-9] in%', Description) end, len(Description))) - 1) as int) end as Inches,
			case when CHARINDEX('in.', Description) = 0 then 0
				 else CHARINDEX(substring(Description, case when patindex('%[0-9][0-9] in%', Description) = 0 then patindex('%[0-9] in%', Description)
															when patindex('%[0-9][0-9][0-9] in%', Description) = 0 then patindex('%[0-9][0-9] in%', Description)
															else patindex('%[0-9][0-9][0-9] in%', Description) end, len(Description)), Description) end as InchesPosition																																										  
			from #specs
			where (Description like '% ft.%' and Description not like '%[0-9].[0-9] ft.%')
			or (Description like '% in.%' and Description not like '%[0-9].[0-9] in.%')

			--Update lines from options and npos with code -98 (ft. and in. addition)
			update @ftandin
			set OptionNPOID = case when b.OptionNPOID is null then a.OptionNPOID else b.OptionNPOID end,
			Inches = case when b.NetInches is null then a.Inches else a.Inches + b.NetInches end,
			[Steel Kit] = case when b.[Steel Kit] is null then a.[Steel Kit] when a.[Steel Kit] is null then b.[Steel Kit] else a.[Steel Kit] + b.[Steel Kit] end,
			Axles = case when b.Axles is null then a.Axles when a.Axles is null then b.Axles else a.Axles + b.Axles end,
			[Step 1] = case when b.[Step 1] is null then a.[Step 1] when a.[Step 1] is null then b.[Step 1] else a.[Step 1] + b.[Step 1] end,
			[Step 2] = case when b.[Step 2] is null then a.[Step 2] when a.[Step 2] is null then b.[Step 2] else a.[Step 2] + b.[Step 2] end,
			Blast = case when b.Blast is null then a.Blast when a.Blast is null then b.Blast else a.Blast + b.Blast end,
			Paint = case when b.Paint is null then a.Paint when a.Paint is null then b.Paint else a.Paint + b.Paint end,
			[Finish - GNK] = case when b.[Finish - GNK] is null then a.[Finish - GNK] when a.[Finish - GNK] is null then b.[Finish - GNK] else a.[Finish - GNK] + b.[Finish - GNK] end,
			[Final Assembly] = case when b.[Final Assembly] is null then a.[Final Assembly] when a.[Final Assembly] is null then b.[Final Assembly] else a.[Final Assembly] + b.[Final Assembly] end,
			[Tire Assembly] = case when b.[Tire Assembly] is null then a.[Tire Assembly] when a.[Tire Assembly] is null then b.[Tire Assembly] else a.[Tire Assembly] + b.[Tire Assembly] end,
			Shipping = case when b.Shipping is null then a.Shipping when a.Shipping is null then b.Shipping else a.Shipping + b.Shipping end,
			[Draw/Part#] = case when b.[Draw/Part#] is null then a.[Draw/Part#]  when a.[Draw/Part#] is null then b.[Draw/Part#] else a.[Draw/Part#] + '
			' + b.[Draw/Part#] end,
			OptNPOWt = case when b.Weight is null then a.OptNPOWt when a.OptNPOWt is null then b.Weight else a.OptNPOWt + b.Weight end,
			Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
			Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
			Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
			BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
			FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end,
			Changed = case when b.NetInches is null then 0 else 1 end,
			NPO = case when b.NPOIndicator is null then 0 else b.NPOIndicator end
			from @ftandin as a
			left outer join (select OptionNPOID, SpecSortG, SpecSortSe, NPOIndicator, NetInches, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour, [Steel Kit], Axles, [Step 1], [Step 2], Blast, Paint, [Finish - GNK], [Final Assembly], [Tire Assembly], Shipping, [Draw/Part#], Weight
							 from (select OptionNPOID, SpecSortG, SpecSortSe, NPOIndicator, sum(cast(Inches as int)) as NetInches, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
								   sum([Steel Kit]) as [Steel Kit], sum(Axles) as Axles, sum([Step 1]) as [Step 1], sum([Step 2]) as [Step 2], sum(Blast) as Blast, sum(Paint) as Paint, sum([Finish - GNK]) as [Finish - GNK], sum([Final Assembly]) as [Final Assembly], sum([Tire Assembly]) as [Tire Assembly], sum(Shipping) as Shipping, [Draw/Part#], sum(Wt) as Weight
 								   from (select b.OrdOptRevID# as OptionNPOID, OptionSpecs.SpecSortG, OptionSpecs.SpecSortSe, 0 as NPOIndicator, cast(left(RIGHT(SpecDescription, LEN(SpecDescription) - CHARINDEX('.', SpecDescription)), 2) as int) * Qty as Inches, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
						   				 case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
										 case when Line# = 1 then Axles * Qty else 0 end as Axles, 
										 case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
										 case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
										 case when Line# = 1 then Blast * Qty else 0 end as Blast, 
										 case when Line# = 1 then Paint * Qty else 0 end as Paint, 
										 case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
										 case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
										 case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly], 
										 case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
										 case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
										 case when Line# = 1 then Weight * Qty else 0 end as Wt
										 from [Order Options_RevHistory] with (nolock)
										 inner join #optionspecs as OptionSpecs with (nolock) on [Order Options_RevHistory].Quote# = OptionSpecs.Quote#
																							   and [Order Options_RevHistory].OrdOptRevID# = OptionSpecs.OrderOptionID
										 left outer join (select SpecSortG, SpecSortSe, [Order Options_RevHistory].OrdOptRevID# from [Order Options_RevHistory] with (nolock)
														  inner join #optionspecs as OptionSpecs with (nolock) on [Order Options_RevHistory].Quote# = OptionSpecs.Quote#
																												and [Order Options_RevHistory].OrdOptRevID# = OptionSpecs.OrderOptionID
														  where ([Order Options_RevHistory].Quote# = @QuoteorWO or [Order Options_RevHistory].WO# = @QuoteorWO) and [Order Options_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-98' and Line# = 1) as b on OptionSpecs.SpecSortG = b.SpecSortG and OptionSpecs.SpecSortSe = b.SpecSortSe
										 where ([Order Options_RevHistory].[Quote#] = @QuoteorWO or [Order Options_RevHistory].WO# = @QuoteorWO) and [Order Options_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-98') as mainsub
									group by OptionNPOID, SpecSortG, SpecSortSe, NPOIndicator, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour, [Draw/Part#]) as mainsub) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe

			update @ftandin
			set OptionNPOID = case when b.OptionNPOID is null then a.OptionNPOID else b.OptionNPOID end,
			Inches = case when b.NetInches is null then a.Inches else a.Inches + b.NetInches end,
			[Steel Kit] = case when b.[Steel Kit] is null then a.[Steel Kit] when a.[Steel Kit] is null then b.[Steel Kit] else a.[Steel Kit] + b.[Steel Kit] end,
			Axles = case when b.Axles is null then a.Axles when a.Axles is null then b.Axles else a.Axles + b.Axles end,
			[Step 1] = case when b.[Step 1] is null then a.[Step 1] when a.[Step 1] is null then b.[Step 1] else a.[Step 1] + b.[Step 1] end,
			[Step 2] = case when b.[Step 2] is null then a.[Step 2] when a.[Step 2] is null then b.[Step 2] else a.[Step 2] + b.[Step 2] end,
			Blast = case when b.Blast is null then a.Blast when a.Blast is null then b.Blast else a.Blast + b.Blast end,
			Paint = case when b.Paint is null then a.Paint when a.Paint is null then b.Paint else a.Paint + b.Paint end,
			[Finish - GNK] = case when b.[Finish - GNK] is null then a.[Finish - GNK] when a.[Finish - GNK] is null then b.[Finish - GNK] else a.[Finish - GNK] + b.[Finish - GNK] end,
			[Final Assembly] = case when b.[Final Assembly] is null then a.[Final Assembly] when a.[Final Assembly] is null then b.[Final Assembly] else a.[Final Assembly] + b.[Final Assembly] end,
			[Tire Assembly] = case when b.[Tire Assembly] is null then a.[Tire Assembly] when a.[Tire Assembly] is null then b.[Tire Assembly] else a.[Tire Assembly] + b.[Tire Assembly] end,
			Shipping = case when b.Shipping is null then a.Shipping when a.Shipping is null then b.Shipping else a.Shipping + b.Shipping end,
			[Draw/Part#] = case when b.[Draw/Part#] is null then a.[Draw/Part#]  when a.[Draw/Part#] is null then b.[Draw/Part#] else a.[Draw/Part#] + '
			' + b.[Draw/Part#] end,
			OptNPOWt = case when b.Weight is null then a.OptNPOWt when a.OptNPOWt is null then b.Weight else a.OptNPOWt + b.Weight end,
			Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
			Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
			Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
			BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
			FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end,
			Changed = case when b.NetInches is null and Changed <> 1 then 0 else 1 end,
			NPO = case when b.NPOIndicator is null and NPO <> 1 then 0 else b.NPOIndicator end
			from @ftandin as a
			left outer join (select OptionNPOID, SpecSortG, SpecSortSe, NPOIndicator, NetInches, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour, [Steel Kit], Axles, [Step 1], [Step 2], Blast, Paint, [Finish - GNK], [Final Assembly], [Tire Assembly], Shipping, [Draw/Part#], Weight
							 from (select OptionNPOID, SpecSortG, SpecSortSe, NPOIndicator, sum(cast(Inches as int)) as NetInches, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
								   sum([Steel Kit]) as [Steel Kit], sum(Axles) as Axles, sum([Step 1]) as [Step 1], sum([Step 2]) as [Step 2], sum(Blast) as Blast, sum(Paint) as Paint, sum([Finish - GNK]) as [Finish - GNK], sum([Final Assembly]) as [Final Assembly], sum([Tire Assembly]) as [Tire Assembly], sum(Shipping) as Shipping, [Draw/Part#], sum(Wt) as Weight
 								   from (select b.CWRevID# as OptionNPOID, NPOSpecs.SpecSortG, NPOSpecs.SpecSortSe, 1 as NPOIndicator, cast(left(RIGHT(SpecDescription, LEN(SpecDescription) - CHARINDEX('.', SpecDescription)), 2) as int) * Qty as Inches,
										 SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
										 case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
										 case when Line# = 1 then Axles * Qty else 0 end as Axles, 
										 case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
										 case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
										 case when Line# = 1 then Blast * Qty else 0 end as Blast, 
										 case when Line# = 1 then Paint * Qty else 0 end as Paint, 
										 case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
										 case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
										 case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly],
										 case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
										 case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
										 case when Line# = 1 then Weight * Qty else 0 end as Wt
										 from [Custom Work_RevHistory] with (nolock)
										 inner join #npospecs as NPOSpecs with (nolock) on [Custom Work_RevHistory].Quote# = NPOSpecs.Quote#
																							 and [Custom Work_RevHistory].CWRevID# = NPOSpecs.NPOID
										 left outer join (select SpecSortG, SpecSortSe, [Custom Work_RevHistory].CWRevID# from [Custom Work_RevHistory] with (nolock)
														  inner join #npospecs as NPOSpecs with (nolock) on [Custom Work_RevHistory].Quote# = NPOSpecs.Quote#
																											  and [Custom Work_RevHistory].CWRevID# = NPOSpecs.NPOID
														  where ([Custom Work_RevHistory].Quote# = @QuoteorWO or [Custom Work_RevHistory].WO# = @QuoteorWO) and [Custom Work_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-98' and Line# = 1) as b on NPOSpecs.SpecSortG = b.SpecSortG and NPOSpecs.SpecSortSe = b.SpecSortSe								 
										 where ([Custom Work_RevHistory].[Quote#] = @QuoteorWO or [Custom Work_RevHistory].WO# = @QuoteorWO) and [Custom Work_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-98') as mainsub
									group by OptionNPOID, SpecSortG, SpecSortSe, NPOIndicator, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour, [Draw/Part#]) as mainsub) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe


			--Adjust ft. and in. to proper measurments (Inches <= 12)
			update @ftandin
			set Feet = case when Inches between 12 and 23 then Feet + 1
							when Inches between 24 and 35 then Feet + 2
							when Inches between 36 and 47 then Feet + 3
							when Inches between 48 and 59 then Feet + 4
							when Inches between 60 and 71 then Feet + 5
							when Inches between 72 and 83 then Feet + 6
							when Inches between 84 and 95 then Feet + 7
							when Inches between 96 and 107 then Feet + 8
							when Inches between 108 and 119 then Feet + 9
							when Inches between 120 and 131 then Feet + 10
							else Feet end,
			Inches = case when Inches between 12 and 23 then Inches - 12
						  when Inches between 24 and 35 then Inches - 24
						  when Inches between 36 and 47 then Inches - 36
						  when Inches between 48 and 59 then Inches - 48
						  when Inches between 60 and 71 then Inches - 60
						  when Inches between 72 and 83 then Inches - 72
						  when Inches between 84 and 95 then Inches - 84
						  when Inches between 96 and 107 then Inches - 96
						  when Inches between 108 and 119 then Inches - 108
						  when Inches between 120 and 131 then Inches - 120
						  else Inches end
			where Changed = 1

			--Update lines from options and npos with code -98 (ft. addition only)
			update @ftandin
			set Feet = case when b.NetFeet is null then a.Feet else a.Feet + b.NetFeet end,
			Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
			Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
			Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
			BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
			FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end,
			Changed = case when b.NetFeet is null and Changed <> 1 then 0 else 1 end,
			NPO = case when b.NPOIndicator is null and NPO <> 1 then 0 else b.NPOIndicator end
			from @ftandin as a
			left outer join (select SpecSortG, SpecSortSe, NPOIndicator, NetFeet, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour 
							 from (select SpecSortG, SpecSortSe, NPOIndicator, sum(cast(Feet as int)) as NetFeet, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour
								   from (select SpecSortG, SpecSortSe, 0 as NPOIndicator, cast(LEFT(SpecDescription, CHARINDEX('.',SpecDescription) - 1) as int) * Qty as Feet, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order Options_RevHistory] with (nolock)
										 inner join #optionspecs as OptionSpecs with (nolock) on [Order Options_RevHistory].Quote# = OptionSpecs.Quote#
																							   and [Order Options_RevHistory].OrdOptRevID# = OptionSpecs.OrderOptionID
										 where ([Order Options_RevHistory].[Quote#] = @QuoteorWO or [Order Options_RevHistory].WO# = @QuoteorWO) and [Order Options_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-98') as mainsub
									group by SpecSortG, SpecSortSe, NPOIndicator, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour) as mainsub) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe

			update @ftandin
			set Feet = case when b.NetFeet is null then a.Feet else a.Feet + b.NetFeet end,
			Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
			Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
			Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
			BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
			FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end,
			Changed = case when b.NetFeet is null and Changed <> 1 then 0 else 1 end,
			NPO = case when b.NPOIndicator is null and NPO <> 1 then 0 else b.NPOIndicator end
			from @ftandin as a
			left outer join (select SpecSortG, SpecSortSe, NPOIndicator, NetFeet, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour 
							 from (select SpecSortG, SpecSortSe, NPOIndicator, sum(cast(Feet as int)) as NetFeet, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour
								   from (select SpecSortG, SpecSortSe, 1 as NPOIndicator, cast(LEFT(SpecDescription, CHARINDEX('.',SpecDescription) - 1) as int) * Qty as Feet, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom Work_RevHistory] with (nolock)
										 inner join #npospecs as NPOSpecs with (nolock) on [Custom Work_RevHistory].Quote# = NPOSpecs.Quote#
																							 and [Custom Work_RevHistory].CWRevID# = NPOSpecs.NPOID
										 where ([Custom Work_RevHistory].[Quote#] = @QuoteorWO or [Custom Work_RevHistory].WO# = @QuoteorWO) and [Custom Work_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-98') as mainsub
									group by SpecSortG, SpecSortSe, NPOIndicator, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour) as mainsub) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe

			--Handing changed @ftandin tv records with "1" position
			update @ftandin
			set FeetPosition = 0
			where FeetPosition = 1
			and Changed = 1

			update @ftandin
			set InchesPosition = 0
			where InchesPosition = 1
			and Changed = 1

			--Update @specs tv with lines from @ftandin tv
			update #specs
			set OptionNPOID = case when b.OptionNPOID is null then a.OptionNPOID else b.OptionNPOID end,
			Description = case when b.Feet is null then a.Description --No Feet/Inches additions
								   when b.Feet = 0 then case when NPO = 1 then '*NPO*: ' else '' end + left(Description, b.InchesPosition) + cast(b.Inches as nvarchar) + right(Description, len(Description) - (CHARINDEX('in.', Description) - 2)) --Inches addition only
								   when b.Inches = 0 then case when NPO = 1 then '*NPO*: ' else '' end + left(Description, case when b.FeetPosition > 0 then b.FeetPosition - 1 else 0 end) + cast(b.Feet as nvarchar) + right(Description, len(Description) - (CHARINDEX('ft.', Description) - 2)) --Feet addition only
								   when b.Feet <> 0 and CHARINDEX('in.', Description) = 0 then case when NPO = 1 then '*NPO*: ' else '' end + left(Description, case when b.FeetPosition > 0 then b.FeetPosition - 1 else 0 end) + cast(b.Feet as nvarchar) + ' ft. ' + cast(b.Inches as nvarchar) + ' in. ' 
																							   + right(Description, len(Description) - (len(cast(b.Feet as nvarchar) + ' ft. '))) --Changes ft. to ft. and in.
								   when b.Inches <> 0 and CHARINDEX('ft.', Description) = 0 then case when NPO = 1 then '*NPO*: ' else '' end + left(Description, b.InchesPosition) + cast(b.Feet as nvarchar) + ' ft. ' + cast(b.Inches as nvarchar) + right(Description, len(Description) - (CHARINDEX('in.', Description) - 2)) --Changes in. to ft. and in.
								   else case when NPO = 1 then '*NPO*: ' else '' end + left(Description, case when b.FeetPosition > 0 then b.FeetPosition - 1 else 0 end) + cast(b.Feet as nvarchar) + ' ft. ' + cast(b.Inches as nvarchar) + right(Description, len(Description) - (CHARINDEX('in.', Description) - 2)) end, 
			[Steel Kit] = case when b.[Steel Kit] is null then a.[Steel Kit] when a.[Steel Kit] is null then b.[Steel Kit] else a.[Steel Kit] + b.[Steel Kit] end,
			Axles = case when b.Axles is null then a.Axles when a.Axles is null then b.Axles else a.Axles + b.Axles end,
			[Step 1] = case when b.[Step 1] is null then a.[Step 1] when a.[Step 1] is null then b.[Step 1] else a.[Step 1] + b.[Step 1] end,
			[Step 2] = case when b.[Step 2] is null then a.[Step 2] when a.[Step 2] is null then b.[Step 2] else a.[Step 2] + b.[Step 2] end,
			Blast = case when b.Blast is null then a.Blast when a.Blast is null then b.Blast else a.Blast + b.Blast end,
			Paint = case when b.Paint is null then a.Paint when a.Paint is null then b.Paint else a.Paint + b.Paint end,
			[Finish - GNK] = case when b.[Finish - GNK] is null then a.[Finish - GNK] when a.[Finish - GNK] is null then b.[Finish - GNK] else a.[Finish - GNK] + b.[Finish - GNK] end,
			[Final Assembly] = case when b.[Final Assembly] is null then a.[Final Assembly] when a.[Final Assembly] is null then b.[Final Assembly] else a.[Final Assembly] + b.[Final Assembly] end,
			[Tire Assembly] = case when b.[Tire Assembly] is null then a.[Tire Assembly] when a.[Tire Assembly] is null then b.[Tire Assembly] else a.[Tire Assembly] + b.[Tire Assembly] end,
			Shipping = case when b.Shipping is null then a.Shipping when a.Shipping is null then b.Shipping else a.Shipping + b.Shipping end,
			[Draw/Part#] = case when b.[Draw/Part#] is null then a.[Draw/Part#]  when a.[Draw/Part#] is null then b.[Draw/Part#] else a.[Draw/Part#] + '
			' + b.[Draw/Part#] end,
			OptNPOWt = case when b.OptNPOWt is null then a.OptNPOWt when a.OptNPOWt is null then b.OptNPOWt else a.OptNPOWt + b.OptNPOWt end,
			Bold = b.Bold,
			Italic = b.Italic,
			Underline = b.Underline,
			BackColour = b.BackColour,
			FontColour = b.FontColour
			from #specs as a
			inner join @ftandin as b on a.SortGv2 = b.SortGv2 and a.SortSev2 = b.SortSev2
			where Changed = 1

			--Update lines from options and npos with code -97 (additional text)
			update #specs
			set OptionNPOID = case when b.OptionNPOID is null then a.OptionNPOID else b.OptionNPOID end,
			Description = case when b.SpecDescription is null then a.Description else a.Description + ' ' + b.SpecDescription end,
			[Steel Kit] = case when b.[Steel Kit] is null then a.[Steel Kit] when a.[Steel Kit] is null then b.[Steel Kit] else a.[Steel Kit] + b.[Steel Kit] end,
			Axles = case when b.Axles is null then a.Axles when a.Axles is null then b.Axles else a.Axles + b.Axles end,
			[Step 1] = case when b.[Step 1] is null then a.[Step 1] when a.[Step 1] is null then b.[Step 1] else a.[Step 1] + b.[Step 1] end,
			[Step 2] = case when b.[Step 2] is null then a.[Step 2] when a.[Step 2] is null then b.[Step 2] else a.[Step 2] + b.[Step 2] end,
			Blast = case when b.Blast is null then a.Blast when a.Blast is null then b.Blast else a.Blast + b.Blast end,
			Paint = case when b.Paint is null then a.Paint when a.Paint is null then b.Paint else a.Paint + b.Paint end,
			[Finish - GNK] = case when b.[Finish - GNK] is null then a.[Finish - GNK] when a.[Finish - GNK] is null then b.[Finish - GNK] else a.[Finish - GNK] + b.[Finish - GNK] end,
			[Final Assembly] = case when b.[Final Assembly] is null then a.[Final Assembly] when a.[Final Assembly] is null then b.[Final Assembly] else a.[Final Assembly] + b.[Final Assembly] end,
			[Tire Assembly] = case when b.[Tire Assembly] is null then a.[Tire Assembly] when a.[Tire Assembly] is null then b.[Tire Assembly] else a.[Tire Assembly] + b.[Tire Assembly] end,
			Shipping = case when b.Shipping is null then a.Shipping when a.Shipping is null then b.Shipping else a.Shipping + b.Shipping end,
			[Draw/Part#] = case when b.[Draw/Part#] is null then a.[Draw/Part#]  when a.[Draw/Part#] is null then b.[Draw/Part#] else a.[Draw/Part#] + '
			' + b.[Draw/Part#] end,
			OptNPOWt = case when b.Weight is null then a.OptNPOWt else a.OptNPOWt + b.Weight end,
			Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
			Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
			Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
			BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
			FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end
			from #specs as a
			left outer join (select OptionNPOID, SpecSortG, SpecSortSe, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
							 sum([Steel Kit]) as [Steel Kit], sum(Axles) as Axles, sum([Step 1]) as [Step 1], sum([Step 2]) as [Step 2], sum(Blast) as Blast, sum(Paint) as Paint, sum([Finish - GNK]) as [Finish - GNK], sum([Final Assembly]) as [Final Assembly], sum([Tire Assembly]) as [Tire Assembly], sum(Shipping) as Shipping, [Draw/Part#], sum(Wt) as Weight
							 from (select b.OrdOptRevID# as OptionNPOID, OptionSpecs.SpecSortG, OptionSpecs.SpecSortSe, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
								   case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
								   case when Line# = 1 then Axles * Qty else 0 end as Axles, 
								   case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
								   case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
								   case when Line# = 1 then Blast * Qty else 0 end as Blast, 
								   case when Line# = 1 then Paint * Qty else 0 end as Paint, 
								   case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
								   case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
								   case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly], 
								   case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
								   case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
								   case when Line# = 1 then Weight * Qty else 0 end as Wt
								   from [Order Options_RevHistory] with (nolock)
								   inner join #optionspecs as OptionSpecs with (nolock) on [Order Options_RevHistory].Quote# = OptionSpecs.Quote#
																						 and [Order Options_RevHistory].OrdOptRevID# = OptionSpecs.OrderOptionID
								   left outer join (select SpecSortG, SpecSortSe, [Order Options_RevHistory].OrdOptRevID# from [Order Options_RevHistory] with (nolock)
								   inner join #optionspecs as OptionSpecs with (nolock) on [Order Options_RevHistory].Quote# = OptionSpecs.Quote#
																						 and [Order Options_RevHistory].OrdOptRevID# = OptionSpecs.OrderOptionID
													where ([Order Options_RevHistory].Quote# = @QuoteorWO or [Order Options_RevHistory].WO# = @QuoteorWO) and [Order Options_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-97' and Line# = 1) as b on OptionSpecs.SpecSortG = b.SpecSortG and OptionSpecs.SpecSortSe = b.SpecSortSe
								   where ([Order Options_RevHistory].[Quote#] = @QuoteorWO or [Order Options_RevHistory].WO# = @QuoteorWO) and [Order Options_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-97'

								   union all select b.CWRevID# as OptionNPOID, NPOSpecs.SpecSortG, NPOSpecs.SpecSortSe, '*NPO*: ' + SpecDescription,
								   SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
								   case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
								   case when Line# = 1 then Axles * Qty else 0 end as Axles, 
								   case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
								   case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
								   case when Line# = 1 then Blast * Qty else 0 end as Blast, 
								   case when Line# = 1 then Paint * Qty else 0 end as Paint, 
								   case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
								   case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
								   case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly],
								   case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
								   case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
								   case when Line# = 1 then Weight * Qty else 0 end as Wt
								   from [Custom Work_RevHistory] with (nolock)
								   inner join #npospecs as NPOSpecs with (nolock) on [Custom Work_RevHistory].Quote# = NPOSpecs.Quote#
																					   and [Custom Work_RevHistory].CWRevID# = NPOSpecs.NPOID
								   left outer join (select SpecSortG, SpecSortSe, [Custom Work_RevHistory].CWRevID# from [Custom Work_RevHistory] with (nolock)
												    inner join #npospecs as NPOSpecs with (nolock) on [Custom Work_RevHistory].Quote# = NPOSpecs.Quote#
																									    and [Custom Work_RevHistory].CWRevID# = NPOSpecs.NPOID
													where ([Custom Work_RevHistory].Quote# = @QuoteorWO or [Custom Work_RevHistory].WO# = @QuoteorWO) and [Custom Work_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-97' and Line# = 1) as b on NPOSpecs.SpecSortG = b.SpecSortG and NPOSpecs.SpecSortSe = b.SpecSortSe
								   where ([Custom Work_RevHistory].[Quote#] = @QuoteorWO or [Custom Work_RevHistory].WO# = @QuoteorWO) and [Custom Work_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-97') as mainsub
							 group by OptionNPOID, SpecSortG, SpecSortSe, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour, [Draw/Part#]) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe
			where a.SpecSortSeLine = 0

			--delete from specs tv where code from option and npo lines = -96
			delete #specs
			from #specs as a
			inner join (select SpecSortG, SpecSortSe from [Order Options_RevHistory] with (nolock)
						inner join #optionspecs as OptionSpecs with (nolock) on [Order Options_RevHistory].Quote# = OptionSpecs.Quote#
																			  and [Order Options_RevHistory].OrdOptRevID# = OptionSpecs.OrderOptionID
						where ([Order Options_RevHistory].[Quote#] = @QuoteorWO or [Order Options_RevHistory].WO# = @QuoteorWO) and [Order Options_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-96'

						union all select SpecSortG, SpecSortSe from [Custom Work_RevHistory] with (nolock)
						inner join #npospecs as NPOSpecs with (nolock) on [Custom Work_RevHistory].Quote# = NPOSpecs.Quote#
																			and [Custom Work_RevHistory].CWRevID# = NPOSpecs.NPOID
						where ([Custom Work_RevHistory].[Quote#] = @QuoteorWO or [Custom Work_RevHistory].WO# = @QuoteorWO) and [Custom Work_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-96') as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe

			--Update lines from options and npos with code -95 (find and replace)
			update #specs
			set OptionNPOID = case when b.OptionNPOID is null then a.OptionNPOID else b.OptionNPOID end,
			Description = case when b.SpecDescription is null then a.Description 
								   else replace(a.Description, 
 												right(left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1), len(left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1)) - charindex('~', left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1))), 
												case when NPOIndicator = 1 then '(*NPO*->) ' else '' end + left(right(b.SpecDescription, len(b.SpecDescription) - (CHARINDEX('~.~', b.SpecDescription) + 2)), (len(b.SpecDescription) - (CHARINDEX('~.~', b.SpecDescription) + 2)) - 1)) end,
			[Steel Kit] = case when b.[Steel Kit] is null then a.[Steel Kit] when a.[Steel Kit] is null then b.[Steel Kit] else a.[Steel Kit] + b.[Steel Kit] end,
			Axles = case when b.Axles is null then a.Axles when a.Axles is null then b.Axles else a.Axles + b.Axles end,
			[Step 1] = case when b.[Step 1] is null then a.[Step 1] when a.[Step 1] is null then b.[Step 1] else a.[Step 1] + b.[Step 1] end,
			[Step 2] = case when b.[Step 2] is null then a.[Step 2] when a.[Step 2] is null then b.[Step 2] else a.[Step 2] + b.[Step 2] end,
			Blast = case when b.Blast is null then a.Blast when a.Blast is null then b.Blast else a.Blast + b.Blast end,
			Paint = case when b.Paint is null then a.Paint when a.Paint is null then b.Paint else a.Paint + b.Paint end,
			[Finish - GNK] = case when b.[Finish - GNK] is null then a.[Finish - GNK] when a.[Finish - GNK] is null then b.[Finish - GNK] else a.[Finish - GNK] + b.[Finish - GNK] end,
			[Final Assembly] = case when b.[Final Assembly] is null then a.[Final Assembly] when a.[Final Assembly] is null then b.[Final Assembly] else a.[Final Assembly] + b.[Final Assembly] end,
			[Tire Assembly] = case when b.[Tire Assembly] is null then a.[Tire Assembly] when a.[Tire Assembly] is null then b.[Tire Assembly] else a.[Tire Assembly] + b.[Tire Assembly] end,
			Shipping = case when b.Shipping is null then a.Shipping when a.Shipping is null then b.Shipping else a.Shipping + b.Shipping end,
			[Draw/Part#] = case when b.[Draw/Part#] is null then a.[Draw/Part#]  when a.[Draw/Part#] is null then b.[Draw/Part#] else a.[Draw/Part#] + '
			' + b.[Draw/Part#] end,
			OptNPOWt = case when b.Weight is null then a.OptNPOWt else b.Weight end,
			Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
			Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
			Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
			BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
			FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end
			from #specs as a
			left outer join (select OptionNPOID, SpecSortG, SpecSortSe, NPOIndicator, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
							 sum([Steel Kit]) as [Steel Kit], sum(Axles) as Axles, sum([Step 1]) as [Step 1], sum([Step 2]) as [Step 2], sum(Blast) as Blast, sum(Paint) as Paint, sum([Finish - GNK]) as [Finish - GNK], sum([Final Assembly]) as [Final Assembly], sum([Tire Assembly]) as [Tire Assembly], sum(Shipping) as Shipping, [Draw/Part#], sum(Wt) as Weight
							 from (select b.OrdOptRevID# as OptionNPOID, OptionSpecs.SpecSortG, OptionSpecs.SpecSortSe, 0 as NPOIndicator, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
								   case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
								   case when Line# = 1 then Axles * Qty else 0 end as Axles, 
								   case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
								   case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
								   case when Line# = 1 then Blast * Qty else 0 end as Blast, 
								   case when Line# = 1 then Paint * Qty else 0 end as Paint, 
								   case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
								   case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
								   case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly], 
								   case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
								   case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
								   case when Line# = 1 then Weight * Qty else 0 end as Wt
								   from [Order Options_RevHistory] with (nolock)
								   inner join #optionspecs as OptionSpecs with (nolock) on [Order Options_RevHistory].Quote# = OptionSpecs.Quote#
																						 and [Order Options_RevHistory].OrdOptRevID# = OptionSpecs.OrderOptionID
								   left outer join (select SpecSortG, SpecSortSe, [Order Options_RevHistory].OrdOptRevID# from [Order Options_RevHistory] with (nolock)
												    inner join #optionspecs as OptionSpecs with (nolock) on [Order Options_RevHistory].Quote# = OptionSpecs.Quote#
																										  and [Order Options_RevHistory].OrdOptRevID# = OptionSpecs.OrderOptionID
													where ([Order Options_RevHistory].Quote# = @QuoteorWO or [Order Options_RevHistory].WO# = @QuoteorWO) and [Order Options_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-95' and Line# = 1) as b on OptionSpecs.SpecSortG = b.SpecSortG and OptionSpecs.SpecSortSe = b.SpecSortSe
								   where ([Order Options_RevHistory].[Quote#] = @QuoteorWO or [Order Options_RevHistory].WO# = @QuoteorWO) and [Order Options_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-95'

								   union all select b.CWRevID# as OptionNPOID, NPOSpecs.SpecSortG, NPOSpecs.SpecSortSe, 1, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
								   case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
								   case when Line# = 1 then Axles * Qty else 0 end as Axles, 
								   case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
								   case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
								   case when Line# = 1 then Blast * Qty else 0 end as Blast, 
								   case when Line# = 1 then Paint * Qty else 0 end as Paint, 
								   case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
								   case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
								   case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly],
								   case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
								   case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
								   case when Line# = 1 then Weight * Qty else 0 end as Wt
								   from [Custom Work_RevHistory] with (nolock)
								   inner join #npospecs as NPOSpecs with (nolock) on [Custom Work_RevHistory].Quote# = NPOSpecs.Quote#
																					   and [Custom Work_RevHistory].CWRevID# = NPOSpecs.NPOID
								   left outer join (select SpecSortG, SpecSortSe, [Custom Work_RevHistory].CWRevID# from [Custom Work_RevHistory] with (nolock)
													inner join #npospecs as NPOSpecs with (nolock) on [Custom Work_RevHistory].Quote# = NPOSpecs.Quote#
																										and [Custom Work_RevHistory].CWRevID# = NPOSpecs.NPOID
													where ([Custom Work_RevHistory].Quote# = @QuoteorWO or [Custom Work_RevHistory].WO# = @QuoteorWO) and [Custom Work_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-95' and Line# = 1) as b on NPOSpecs.SpecSortG = b.SpecSortG and NPOSpecs.SpecSortSe = b.SpecSortSe
								   where ([Custom Work_RevHistory].[Quote#] = @QuoteorWO or [Custom Work_RevHistory].WO# = @QuoteorWO) and [Custom Work_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-95') as mainsub
							  group by OptionNPOID, SpecSortG, SpecSortSe, NPOIndicator, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour, [Draw/Part#]) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe
			where a.SpecSortSeLine = 0

			--insert error-handling lines for options and npos with code -95 (find and replace) and no matching address in specs table
			insert into #specs ([Quote#], WO#, SortGv2, [Group], SortSev2, Section, [Description], Bold, Italic, Underline, BackColour, FontColour, [Steel Kit], Axles, [Step 1], [Step 2], Blast, Paint, [Finish - GNK], [Final Assembly], [Tire Assembly], Shipping, OptNPOWt)
			select [Quote#], WO#, SpecSortG, SpecGroup, SpecSortSe, SpecSection, 'Spec Address not found, please review Option and NPO Addresses with -95 code', 1, SpecDescriptionItalic, SpecDescriptionUnderline, 'Red', 'Yellow', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			from (select [Order Options_RevHistory].[Quote#], [Order Options_RevHistory].WO#, SpecSortG, SpecGroup, SpecSortSe, SpecSection, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order Options_RevHistory] with (nolock)
				  inner join #optionspecs as OptionSpecs with (nolock) on [Order Options_RevHistory].Quote# = OptionSpecs.Quote#
																		and [Order Options_RevHistory].OrdOptRevID# = OptionSpecs.OrderOptionID
				  where ([Order Options_RevHistory].[Quote#] = @QuoteorWO or [Order Options_RevHistory].WO# = @QuoteorWO) and [Order Options_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-95'

				  union all select [Custom Work_RevHistory].[Quote#], [Custom Work_RevHistory].WO#, SpecSortG, SpecGroup, SpecSortSe, SpecSection, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom Work_RevHistory] with (nolock)
				  inner join #npospecs as NPOSpecs with (nolock) on [Custom Work_RevHistory].Quote# = NPOSpecs.Quote#
																	  and [Custom Work_RevHistory].CWRevID# = NPOSpecs.NPOID
				  where ([Custom Work_RevHistory].[Quote#] = @QuoteorWO or [Custom Work_RevHistory].WO# = @QuoteorWO) and [Custom Work_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-95') as mainsub
			left outer join (select SortGv2, SortSev2, Description from #specs) as b on mainsub.SpecSortG = b.SortGv2 and mainsub.SpecSortSe = b.SortSev2
			where SortSev2 is null
			and Description is null

			--Update lines from options and npos with code -94 (find and replace - 2nd runthrough)
			update #specs
			set OptionNPOID = case when b.OptionNPOID is null then a.OptionNPOID else b.OptionNPOID end,
			Description = case when b.SpecDescription is null then a.Description 
								   else replace(a.Description, 
 												right(left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1), len(left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1)) - charindex('~', left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1))), 
												case when NPOIndicator = 1 then '(*NPO*->) ' else '' end + left(right(b.SpecDescription, len(b.SpecDescription) - (CHARINDEX('~.~', b.SpecDescription) + 2)), (len(b.SpecDescription) - (CHARINDEX('~.~', b.SpecDescription) + 2)) - 1)) end,
			[Steel Kit] = case when b.[Steel Kit] is null then a.[Steel Kit] when a.[Steel Kit] is null then b.[Steel Kit] else a.[Steel Kit] + b.[Steel Kit] end,
			Axles = case when b.Axles is null then a.Axles when a.Axles is null then b.Axles else a.Axles + b.Axles end,
			[Step 1] = case when b.[Step 1] is null then a.[Step 1] when a.[Step 1] is null then b.[Step 1] else a.[Step 1] + b.[Step 1] end,
			[Step 2] = case when b.[Step 2] is null then a.[Step 2] when a.[Step 2] is null then b.[Step 2] else a.[Step 2] + b.[Step 2] end,
			Blast = case when b.Blast is null then a.Blast when a.Blast is null then b.Blast else a.Blast + b.Blast end,
			Paint = case when b.Paint is null then a.Paint when a.Paint is null then b.Paint else a.Paint + b.Paint end,
			[Finish - GNK] = case when b.[Finish - GNK] is null then a.[Finish - GNK] when a.[Finish - GNK] is null then b.[Finish - GNK] else a.[Finish - GNK] + b.[Finish - GNK] end,
			[Final Assembly] = case when b.[Final Assembly] is null then a.[Final Assembly] when a.[Final Assembly] is null then b.[Final Assembly] else a.[Final Assembly] + b.[Final Assembly] end,
			[Tire Assembly] = case when b.[Tire Assembly] is null then a.[Tire Assembly] when a.[Tire Assembly] is null then b.[Tire Assembly] else a.[Tire Assembly] + b.[Tire Assembly] end,
			Shipping = case when b.Shipping is null then a.Shipping when a.Shipping is null then b.Shipping else a.Shipping + b.Shipping end,
			[Draw/Part#] = case when b.[Draw/Part#] is null then a.[Draw/Part#]  when a.[Draw/Part#] is null then b.[Draw/Part#] else a.[Draw/Part#] + '
			' + b.[Draw/Part#] end,
			OptNPOWt = case when b.Weight is null then a.OptNPOWt else b.Weight end,
			Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
			Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
			Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
			BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
			FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end
			from #specs as a
			left outer join (select OptionNPOID, SpecSortG, SpecSortSe, NPOIndicator, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
							 sum([Steel Kit]) as [Steel Kit], sum(Axles) as Axles, sum([Step 1]) as [Step 1], sum([Step 2]) as [Step 2], sum(Blast) as Blast, sum(Paint) as Paint, sum([Finish - GNK]) as [Finish - GNK], sum([Final Assembly]) as [Final Assembly], sum([Tire Assembly]) as [Tire Assembly], sum(Shipping) as Shipping, [Draw/Part#], sum(Wt) as Weight
							 from (select b.OrdOptRevID# as OptionNPOID, OptionSpecs.SpecSortG, OptionSpecs.SpecSortSe, 0 as NPOIndicator, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
								   case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
								   case when Line# = 1 then Axles * Qty else 0 end as Axles, 
								   case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
								   case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
								   case when Line# = 1 then Blast * Qty else 0 end as Blast, 
								   case when Line# = 1 then Paint * Qty else 0 end as Paint, 
								   case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
								   case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
								   case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly], 
								   case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
								   case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
								   case when Line# = 1 then Weight * Qty else 0 end as Wt
								   from [Order Options_RevHistory] with (nolock)
								   inner join #optionspecs as OptionSpecs with (nolock) on [Order Options_RevHistory].Quote# = OptionSpecs.Quote#
																						 and [Order Options_RevHistory].OrdOptRevID# = OptionSpecs.OrderOptionID
								   left outer join (select SpecSortG, SpecSortSe, [Order Options_RevHistory].OrdOptRevID# from [Order Options_RevHistory] with (nolock)
													inner join #optionspecs as OptionSpecs with (nolock) on [Order Options_RevHistory].Quote# = OptionSpecs.Quote#
																										  and [Order Options_RevHistory].OrdOptRevID# = OptionSpecs.OrderOptionID
													where ([Order Options_RevHistory].Quote# = @QuoteorWO or [Order Options_RevHistory].WO# = @QuoteorWO) and [Order Options_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-94' and Line# = 1) as b on OptionSpecs.SpecSortG = b.SpecSortG and OptionSpecs.SpecSortSe = b.SpecSortSe
								   where ([Order Options_RevHistory].[Quote#] = @QuoteorWO or [Order Options_RevHistory].WO# = @QuoteorWO) and [Order Options_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-94'

								   union all select b.CWRevID# as OptionNPOID, NPOSpecs.SpecSortG, NPOSpecs.SpecSortSe, 1, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
								   case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
								   case when Line# = 1 then Axles * Qty else 0 end as Axles, 
								   case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
								   case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
								   case when Line# = 1 then Blast * Qty else 0 end as Blast, 
								   case when Line# = 1 then Paint * Qty else 0 end as Paint, 
								   case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
								   case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
								   case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly],
								   case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
								   case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
								   case when Line# = 1 then Weight * Qty else 0 end as Wt
								   from [Custom Work_RevHistory] with (nolock)
								   inner join #npospecs as NPOSpecs with (nolock) on [Custom Work_RevHistory].Quote# = NPOSpecs.Quote#
																					   and [Custom Work_RevHistory].CWRevID# = NPOSpecs.NPOID
								   left outer join (select SpecSortG, SpecSortSe, [Custom Work_RevHistory].CWRevID# from [Custom Work_RevHistory] with (nolock)
													inner join #npospecs as NPOSpecs with (nolock) on [Custom Work_RevHistory].Quote# = NPOSpecs.Quote#
																										and [Custom Work_RevHistory].CWRevID# = NPOSpecs.NPOID
													where ([Custom Work_RevHistory].Quote# = @QuoteorWO or [Custom Work_RevHistory].WO# = @QuoteorWO) and [Custom Work_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-94' and Line# = 1) as b on NPOSpecs.SpecSortG = b.SpecSortG and NPOSpecs.SpecSortSe = b.SpecSortSe
								   where ([Custom Work_RevHistory].[Quote#] = @QuoteorWO or [Custom Work_RevHistory].WO# = @QuoteorWO) and [Custom Work_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-94') as mainsub
							  group by OptionNPOID, SpecSortG, SpecSortSe, NPOIndicator, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour, [Draw/Part#]) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe
			where a.SpecSortSeLine = 0

			--insert error-handling lines for options and npos with code -94 (find and replace - 2nd runthrough) and no matching address in specs table
			insert into #specs ([Quote#], WO#, SortGv2, [Group], SortSev2, Section, [Description], Bold, Italic, Underline, BackColour, FontColour, [Steel Kit], Axles, [Step 1], [Step 2], Blast, Paint, [Finish - GNK], [Final Assembly], [Tire Assembly], Shipping, OptNPOWt)
			select [Quote#], WO#, SpecSortG, SpecGroup, SpecSortSe, SpecSection, 'Spec Address not found, please review Option and NPO Addresses with -94 code', 1, SpecDescriptionItalic, SpecDescriptionUnderline, 'Red', 'Yellow', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			from (select [Order Options_RevHistory].[Quote#], [Order Options_RevHistory].WO#, SpecSortG, SpecGroup, SpecSortSe, SpecSection, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order Options_RevHistory] with (nolock)
				  inner join #optionspecs as OptionSpecs with (nolock) on [Order Options_RevHistory].Quote# = OptionSpecs.Quote#
																		and [Order Options_RevHistory].OrdOptRevID# = OptionSpecs.OrderOptionID
				  where ([Order Options_RevHistory].[Quote#] = @QuoteorWO or [Order Options_RevHistory].WO# = @QuoteorWO) and [Order Options_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-94'

				  union all select [Custom Work_RevHistory].[Quote#], [Custom Work_RevHistory].WO#, SpecSortG, SpecGroup, SpecSortSe, SpecSection, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom Work_RevHistory] with (nolock)
				  inner join #npospecs as NPOSpecs with (nolock) on [Custom Work_RevHistory].Quote# = NPOSpecs.Quote#
																	  and [Custom Work_RevHistory].CWRevID# = NPOSpecs.NPOID
				  where ([Custom Work_RevHistory].[Quote#] = @QuoteorWO or [Custom Work_RevHistory].WO# = @QuoteorWO) and [Custom Work_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-94') as mainsub
			left outer join (select SortGv2, SortSev2, Description from #specs) as b on mainsub.SpecSortG = b.SortGv2 and mainsub.SpecSortSe = b.SortSev2
			where SortSev2 is null
			and Description is null

			--Update lines from options and npos with code -93 (find int value and "replace" with initial and specified int values added together - i.e. ~10~.~2~ will find 10 and replace it with 12)
			update #specs
			set Description = case when b.SpecDescription is null then a.Description 
								   else replace(a.Description, 
 												right(left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1), len(left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1)) - charindex('~', left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1))),
												case when NPOIndicator = 1 then '(*NPO*->) ' else '' end 
												+ cast(cast(right(left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1), len(left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1)) - charindex('~', left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1))) as float) 
												+ (cast(left(right(b.SpecDescription, len(b.SpecDescription) - (CHARINDEX('~.~', b.SpecDescription) + 2)), (len(b.SpecDescription) - (CHARINDEX('~.~', b.SpecDescription) + 2)) - 1) as float) * Qty) as nvarchar)) end,
			[Steel Kit] = case when b.[Steel Kit] is null then a.[Steel Kit] when a.[Steel Kit] is null then b.[Steel Kit] else a.[Steel Kit] + b.[Steel Kit] end,
			Axles = case when b.Axles is null then a.Axles when a.Axles is null then b.Axles else a.Axles + b.Axles end,
			[Step 1] = case when b.[Step 1] is null then a.[Step 1] when a.[Step 1] is null then b.[Step 1] else a.[Step 1] + b.[Step 1] end,
			[Step 2] = case when b.[Step 2] is null then a.[Step 2] when a.[Step 2] is null then b.[Step 2] else a.[Step 2] + b.[Step 2] end,
			Blast = case when b.Blast is null then a.Blast when a.Blast is null then b.Blast else a.Blast + b.Blast end,
			Paint = case when b.Paint is null then a.Paint when a.Paint is null then b.Paint else a.Paint + b.Paint end,
			[Finish - GNK] = case when b.[Finish - GNK] is null then a.[Finish - GNK] when a.[Finish - GNK] is null then b.[Finish - GNK] else a.[Finish - GNK] + b.[Finish - GNK] end,
			[Final Assembly] = case when b.[Final Assembly] is null then a.[Final Assembly] when a.[Final Assembly] is null then b.[Final Assembly] else a.[Final Assembly] + b.[Final Assembly] end,
			[Tire Assembly] = case when b.[Tire Assembly] is null then a.[Tire Assembly] when a.[Tire Assembly] is null then b.[Tire Assembly] else a.[Tire Assembly] + b.[Tire Assembly] end,
			Shipping = case when b.Shipping is null then a.Shipping when a.Shipping is null then b.Shipping else a.Shipping + b.Shipping end,
			[Draw/Part#] = case when b.[Draw/Part#] is null then a.[Draw/Part#]  when a.[Draw/Part#] is null then b.[Draw/Part#] else a.[Draw/Part#] + '
			' + b.[Draw/Part#] end,
			OptNPOWt = case when b.Weight is null then a.OptNPOWt else b.Weight end,
			Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
			Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
			Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
			BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
			FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end
			from #specs as a
			left outer join (select OptionNPOID, SpecSortG, SpecSortSe, NPOIndicator, Qty, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
							 sum([Steel Kit]) as [Steel Kit], sum(Axles) as Axles, sum([Step 1]) as [Step 1], sum([Step 2]) as [Step 2], sum(Blast) as Blast, sum(Paint) as Paint, sum([Finish - GNK]) as [Finish - GNK], sum([Final Assembly]) as [Final Assembly], sum([Tire Assembly]) as [Tire Assembly], sum(Shipping) as Shipping, [Draw/Part#], sum(Wt) as Weight
							 from (select b.OrdOptRevID# as OptionNPOID, OptionSpecs.SpecSortG, OptionSpecs.SpecSortSe, 0 as NPOIndicator, Qty, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
								   case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
								   case when Line# = 1 then Axles * Qty else 0 end as Axles, 
								   case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
								   case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
								   case when Line# = 1 then Blast * Qty else 0 end as Blast, 
								   case when Line# = 1 then Paint * Qty else 0 end as Paint, 
								   case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
								   case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
								   case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly], 
								   case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
								   case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
								   case when Line# = 1 then Weight * Qty else 0 end as Wt
								   from [Order Options_RevHistory] with (nolock)
								   inner join #optionspecs as OptionSpecs with (nolock) on [Order Options_RevHistory].Quote# = OptionSpecs.Quote#
																						 and [Order Options_RevHistory].OrdOptRevID# = OptionSpecs.OrderOptionID
								   left outer join (select SpecSortG, SpecSortSe, [Order Options_RevHistory].OrdOptRevID# from [Order Options_RevHistory] with (nolock)
													inner join #optionspecs as OptionSpecs with (nolock) on [Order Options_RevHistory].Quote# = OptionSpecs.Quote#
																										  and [Order Options_RevHistory].OrdOptRevID# = OptionSpecs.OrderOptionID
													where ([Order Options_RevHistory].Quote# = @QuoteorWO or [Order Options_RevHistory].WO# = @QuoteorWO) and [Order Options_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-93' and Line# = 1) as b on OptionSpecs.SpecSortG = b.SpecSortG and OptionSpecs.SpecSortSe = b.SpecSortSe
								   where ([Order Options_RevHistory].[Quote#] = @QuoteorWO or [Order Options_RevHistory].WO# = @QuoteorWO) and [Order Options_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-93'

								   union all select b.CWRevID# as OptionNPOID, NPOSpecs.SpecSortG, NPOSpecs.SpecSortSe, 1, Qty, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
								   case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
								   case when Line# = 1 then Axles * Qty else 0 end as Axles, 
								   case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
								   case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
								   case when Line# = 1 then Blast * Qty else 0 end as Blast, 
								   case when Line# = 1 then Paint * Qty else 0 end as Paint, 
								   case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
								   case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
								   case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly],
								   case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
								   case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
								   case when Line# = 1 then Weight * Qty else 0 end as Wt
								   from [Custom Work_RevHistory] with (nolock)
								   inner join #npospecs as NPOSpecs with (nolock) on [Custom Work_RevHistory].Quote# = NPOSpecs.Quote#
																					and [Custom Work_RevHistory].CWRevID# = NPOSpecs.NPOID
								   left outer join (select SpecSortG, SpecSortSe, [Custom Work_RevHistory].CWRevID# from [Custom Work_RevHistory] with (nolock)
													inner join #npospecs as NPOSpecs with (nolock) on [Custom Work_RevHistory].Quote# = NPOSpecs.Quote#
																										and [Custom Work_RevHistory].CWRevID# = NPOSpecs.NPOID
													where ([Custom Work_RevHistory].Quote# = @QuoteorWO or [Custom Work_RevHistory].WO# = @QuoteorWO) and [Custom Work_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-93' and Line# = 1) as b on NPOSpecs.SpecSortG = b.SpecSortG and NPOSpecs.SpecSortSe = b.SpecSortSe
								   where ([Custom Work_RevHistory].[Quote#] = @QuoteorWO or [Custom Work_RevHistory].WO# = @QuoteorWO) and [Custom Work_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-93') as mainsub
							  group by OptionNPOID, SpecSortG, SpecSortSe, NPOIndicator, Qty, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour, [Draw/Part#]) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe
			where a.SpecSortSeLine = 0

			--insert error-handling lines for options and npos with code -93 (find int value and "replace" with initial and specified int values added together - i.e. ~10~.~2~ will find 10 and replace it with 12) and no matching address in specs table
			insert into #specs ([Quote#], WO#, SortGv2, [Group], SortSev2, Section, [Description], Bold, Italic, Underline, BackColour, FontColour, [Steel Kit], Axles, [Step 1], [Step 2], Blast, Paint, [Finish - GNK], [Final Assembly], [Tire Assembly], Shipping, OptNPOWt)
			select [Quote#], WO#, SpecSortG, SpecGroup, SpecSortSe, SpecSection, 'Spec Address not found, please review Option and NPO Addresses with -93 code', 1, SpecDescriptionItalic, SpecDescriptionUnderline, 'Red', 'Yellow', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			from (select [Order Options_RevHistory].[Quote#], [Order Options_RevHistory].WO#, SpecSortG, SpecGroup, SpecSortSe, SpecSection, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order Options_RevHistory] with (nolock)
				  inner join #optionspecs as OptionSpecs with (nolock) on [Order Options_RevHistory].Quote# = OptionSpecs.Quote#
																		and [Order Options_RevHistory].OrdOptRevID# = OptionSpecs.OrderOptionID
				  where ([Order Options_RevHistory].[Quote#] = @QuoteorWO or [Order Options_RevHistory].WO# = @QuoteorWO) and [Order Options_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-93'

				  union all select [Custom Work_RevHistory].[Quote#], [Custom Work_RevHistory].WO#, SpecSortG, SpecGroup, SpecSortSe, SpecSection, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom Work_RevHistory] with (nolock)
				  inner join #npospecs as NPOSpecs with (nolock) on [Custom Work_RevHistory].Quote# = NPOSpecs.Quote#
																	  and [Custom Work_RevHistory].CWRevID# = NPOSpecs.NPOID
				  where ([Custom Work_RevHistory].[Quote#] = @QuoteorWO or [Custom Work_RevHistory].WO# = @QuoteorWO) and [Custom Work_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-93') as mainsub
			left outer join (select SortGv2, SortSev2, Description from #specs) as b on mainsub.SpecSortG = b.SortGv2 and mainsub.SpecSortSe = b.SortSev2
			where SortSev2 is null
			and Description is null

			--Update lines from options and npos with code -92 (find and replace - purge spec line with "find" value, add "replace" value to "find" value)
			update #specs
			set Description = case when b.SpecDescription is null then a.Description 
								   else case when NPOIndicator = 1 then '(*NPO*->) ' else '' end 
										+ cast(cast(right(left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1), len(left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1)) - charindex('~', left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1))) as float) 
										+ (cast(left(right(b.SpecDescription, len(b.SpecDescription) - (CHARINDEX('~.~', b.SpecDescription) + 2)), (len(b.SpecDescription) - (CHARINDEX('~.~', b.SpecDescription) + 2)) - 1) as float) * Qty) as nvarchar) end,
			[Steel Kit] = case when b.[Steel Kit] is null then a.[Steel Kit] when a.[Steel Kit] is null then b.[Steel Kit] else a.[Steel Kit] + b.[Steel Kit] end,
			Axles = case when b.Axles is null then a.Axles when a.Axles is null then b.Axles else a.Axles + b.Axles end,
			[Step 1] = case when b.[Step 1] is null then a.[Step 1] when a.[Step 1] is null then b.[Step 1] else a.[Step 1] + b.[Step 1] end,
			[Step 2] = case when b.[Step 2] is null then a.[Step 2] when a.[Step 2] is null then b.[Step 2] else a.[Step 2] + b.[Step 2] end,
			Blast = case when b.Blast is null then a.Blast when a.Blast is null then b.Blast else a.Blast + b.Blast end,
			Paint = case when b.Paint is null then a.Paint when a.Paint is null then b.Paint else a.Paint + b.Paint end,
			[Finish - GNK] = case when b.[Finish - GNK] is null then a.[Finish - GNK] when a.[Finish - GNK] is null then b.[Finish - GNK] else a.[Finish - GNK] + b.[Finish - GNK] end,
			[Final Assembly] = case when b.[Final Assembly] is null then a.[Final Assembly] when a.[Final Assembly] is null then b.[Final Assembly] else a.[Final Assembly] + b.[Final Assembly] end,
			[Tire Assembly] = case when b.[Tire Assembly] is null then a.[Tire Assembly] when a.[Tire Assembly] is null then b.[Tire Assembly] else a.[Tire Assembly] + b.[Tire Assembly] end,
			Shipping = case when b.Shipping is null then a.Shipping when a.Shipping is null then b.Shipping else a.Shipping + b.Shipping end,
			[Draw/Part#] = case when b.[Draw/Part#] is null then a.[Draw/Part#]  when a.[Draw/Part#] is null then b.[Draw/Part#] else a.[Draw/Part#] + '
			' + b.[Draw/Part#] end,
			OptNPOWt = case when b.Weight is null then a.OptNPOWt else b.Weight end,
			Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
			Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
			Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
			BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
			FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end
			from #specs as a
			left outer join (select OptionNPOID, SpecSortG, SpecSortSe, NPOIndicator, Qty, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
							 sum([Steel Kit]) as [Steel Kit], sum(Axles) as Axles, sum([Step 1]) as [Step 1], sum([Step 2]) as [Step 2], sum(Blast) as Blast, sum(Paint) as Paint, sum([Finish - GNK]) as [Finish - GNK], sum([Final Assembly]) as [Final Assembly], sum([Tire Assembly]) as [Tire Assembly], sum(Shipping) as Shipping, [Draw/Part#], sum(Wt) as Weight
							 from (select b.OrdOptRevID# as OptionNPOID, OptionSpecs.SpecSortG, OptionSpecs.SpecSortSe, 0 as NPOIndicator, Qty, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
								   case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
								   case when Line# = 1 then Axles * Qty else 0 end as Axles, 
								   case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
								   case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
								   case when Line# = 1 then Blast * Qty else 0 end as Blast, 
								   case when Line# = 1 then Paint * Qty else 0 end as Paint, 
								   case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
								   case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
								   case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly], 
								   case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
								   case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
								   case when Line# = 1 then Weight * Qty else 0 end as Wt
								   from [Order Options_RevHistory] with (nolock)
								   inner join #optionspecs as OptionSpecs with (nolock) on [Order Options_RevHistory].Quote# = OptionSpecs.Quote#
																						 and [Order Options_RevHistory].OrdOptRevID# = OptionSpecs.OrderOptionID
								   left outer join (select SpecSortG, SpecSortSe, [Order Options_RevHistory].OrdOptRevID# from [Order Options_RevHistory] with (nolock)
													inner join #optionspecs as OptionSpecs with (nolock) on [Order Options_RevHistory].Quote# = OptionSpecs.Quote#
																										  and [Order Options_RevHistory].OrdOptRevID# = OptionSpecs.OrderOptionID
													where ([Order Options_RevHistory].Quote# = @QuoteorWO or [Order Options_RevHistory].WO# = @QuoteorWO) and [Order Options_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-92' and Line# = 1) as b on OptionSpecs.SpecSortG = b.SpecSortG and OptionSpecs.SpecSortSe = b.SpecSortSe
								   where ([Order Options_RevHistory].[Quote#] = @QuoteorWO or [Order Options_RevHistory].WO# = @QuoteorWO) and [Order Options_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-92'

								   union all select b.CWRevID# as OptionNPOID, NPOSpecs.SpecSortG, NPOSpecs.SpecSortSe, 1, Qty, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
								   case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
								   case when Line# = 1 then Axles * Qty else 0 end as Axles, 
								   case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
								   case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
								   case when Line# = 1 then Blast * Qty else 0 end as Blast, 
								   case when Line# = 1 then Paint * Qty else 0 end as Paint, 
								   case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
								   case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
								   case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly],
								   case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
								   case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
								   case when Line# = 1 then Weight * Qty else 0 end as Wt
								   from [Custom Work_RevHistory] with (nolock)
								   inner join #npospecs as NPOSpecs with (nolock) on [Custom Work_RevHistory].Quote# = NPOSpecs.Quote#
																					   and [Custom Work_RevHistory].CWRevID# = NPOSpecs.NPOID
								   left outer join (select SpecSortG, SpecSortSe, [Custom Work_RevHistory].CWRevID# from [Custom Work_RevHistory] with (nolock)
													inner join #npospecs as NPOSpecs with (nolock) on [Custom Work_RevHistory].Quote# = NPOSpecs.Quote#
																										and [Custom Work_RevHistory].CWRevID# = NPOSpecs.NPOID
													where ([Custom Work_RevHistory].Quote# = @QuoteorWO or [Custom Work_RevHistory].WO# = @QuoteorWO) and [Custom Work_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-92' and Line# = 1) as b on NPOSpecs.SpecSortG = b.SpecSortG and NPOSpecs.SpecSortSe = b.SpecSortSe
								   where ([Custom Work_RevHistory].[Quote#] = @QuoteorWO or [Custom Work_RevHistory].WO# = @QuoteorWO) and [Custom Work_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-92') as mainsub
							  group by OptionNPOID, SpecSortG, SpecSortSe, NPOIndicator, Qty, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour, [Draw/Part#]) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe
			where a.SpecSortSeLine = 0

			--insert error-handling lines for options and npos with code -92 (find and replace - purge spec line with "find" value, add "replace" value to "find" value) and no matching address in specs table
			insert into #specs ([Quote#], WO#, SortGv2, [Group], SortSev2, Section, [Description], Bold, Italic, Underline, BackColour, FontColour, [Steel Kit], Axles, [Step 1], [Step 2], Blast, Paint, [Finish - GNK], [Final Assembly], [Tire Assembly], Shipping, OptNPOWt)
			select [Quote#], WO#, SpecSortG, SpecGroup, SpecSortSe, SpecSection, 'Spec Address not found, please review Option and NPO Addresses with -92 code', 1, SpecDescriptionItalic, SpecDescriptionUnderline, 'Red', 'Yellow', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			from (select [Order Options_RevHistory].[Quote#], [Order Options_RevHistory].WO#, SpecSortG, SpecGroup, SpecSortSe, SpecSection, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order Options_RevHistory] with (nolock)
				  inner join #optionspecs as OptionSpecs with (nolock) on [Order Options_RevHistory].Quote# = OptionSpecs.Quote#
																		and [Order Options_RevHistory].OrdOptRevID# = OptionSpecs.OrderOptionID
				  where ([Order Options_RevHistory].[Quote#] = @QuoteorWO or [Order Options_RevHistory].WO# = @QuoteorWO) and [Order Options_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-92'

				  union all select [Custom Work_RevHistory].[Quote#], [Custom Work_RevHistory].WO#, SpecSortG, SpecGroup, SpecSortSe, SpecSection, SpecDescription, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom Work_RevHistory] with (nolock)
				  inner join #npospecs as NPOSpecs with (nolock) on [Custom Work_RevHistory].Quote# = NPOSpecs.Quote#
																	  and [Custom Work_RevHistory].CWRevID# = NPOSpecs.NPOID
				  where ([Custom Work_RevHistory].[Quote#] = @QuoteorWO or [Custom Work_RevHistory].WO# = @QuoteorWO) and [Custom Work_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-92') as mainsub
			left outer join (select SortGv2, SortSev2, Description from #specs) as b on mainsub.SpecSortG = b.SortGv2 and mainsub.SpecSortSe = b.SortSev2
			where SortSev2 is null
			and Description is null

			--Purge @ftandin tv for code -91
			delete from @ftandin

			--Update lines from options and npos with code -91 (ft. and in. addition with cap)
			insert into @ftandin (SortGv2, SortSev2, Feet, FeetPosition, Inches, InchesPosition)
			select SortGv2, SortSev2, 
			case when CHARINDEX('ft.', Description) = 0 then 0
		 				   else cast(left(substring(Description, case when patindex('%[0-9][0-9] ft%', Description) = 0 then patindex('%[0-9] ft%', Description)
															  when patindex('%[0-9][0-9][0-9] ft%', Description) = 0 then patindex('%[0-9][0-9] ft%', Description)
															  else patindex('%[0-9][0-9][0-9] ft%', Description) end, len(Description)), patindex('%[^0-9]%', substring(Description, case when patindex('%[0-9][0-9] ft%', Description) = 0 then patindex('%[0-9] ft%', Description)
																																														  when patindex('%[0-9][0-9][0-9] ft%', Description) = 0 then patindex('%[0-9][0-9] ft%', Description)
																																														  else patindex('%[0-9][0-9][0-9] ft%', Description) end, len(Description))) - 1) as int) end as Feet,
			case when CHARINDEX('ft.', Description) = 0 then 0
		 				   else CHARINDEX(left(substring(Description, case when patindex('%[0-9][0-9] ft%', Description) = 0 then patindex('%[0-9] ft%', Description)
																   when patindex('%[0-9][0-9][0-9] ft%', Description) = 0 then patindex('%[0-9][0-9] ft%', Description)
																   else patindex('%[0-9][0-9][0-9] ft%', Description) end, len(Description)), patindex('%[^0-9]%', substring(Description, case when patindex('%[0-9][0-9] ft%', Description) = 0 then patindex('%[0-9] ft%', Description)
																																														  when patindex('%[0-9][0-9][0-9] ft%', Description) = 0 then patindex('%[0-9][0-9] ft%', Description)
																																														  else patindex('%[0-9][0-9][0-9] ft%', Description) end, len(Description))) - 1), Description) end as FeetPosition,
			case when CHARINDEX('in.', Description) = 0 then 0
				 else cast(left(substring(Description, case when patindex('%[0-9][0-9] in%', Description) = 0 then patindex('%[0-9] in%', Description)
															when patindex('%[0-9][0-9][0-9] in%', Description) = 0 then patindex('%[0-9][0-9] in%', Description)
															else patindex('%[0-9][0-9][0-9] in%', Description) end, len(Description)), patindex('%[^0-9]%', substring(Description, case when patindex('%[0-9][0-9] in%', Description) = 0 then patindex('%[0-9] in%', Description)
																																														when patindex('%[0-9][0-9][0-9] in%', Description) = 0 then patindex('%[0-9][0-9] in%', Description)
																																														else patindex('%[0-9][0-9][0-9] in%', Description) end, len(Description))) - 1) as int) end as Inches,
			case when CHARINDEX('in.', Description) = 0 then 0
				 else CHARINDEX(substring(Description, case when patindex('%[0-9][0-9] in%', Description) = 0 then patindex('%[0-9] in%', Description)
															when patindex('%[0-9][0-9][0-9] in%', Description) = 0 then patindex('%[0-9][0-9] in%', Description)
															else patindex('%[0-9][0-9][0-9] in%', Description) end, len(Description)), Description) end as InchesPosition																																										  
			from #specs
			where (Description like '% ft.%' and Description not like '%[0-9].[0-9] ft.%')
			or (Description like '% in.%' and Description not like '%[0-9].[0-9] in.%')
	
			update @ftandin
			set OptionNPOID = case when b.OptionNPOID is null then a.OptionNPOID else b.OptionNPOID end,
			Inches = case when b.NetInches is null then a.Inches else a.Inches + b.NetInches end,
			[Steel Kit] = case when b.[Steel Kit] is null then a.[Steel Kit] when a.[Steel Kit] is null then b.[Steel Kit] else a.[Steel Kit] + b.[Steel Kit] end,
			Axles = case when b.Axles is null then a.Axles when a.Axles is null then b.Axles else a.Axles + b.Axles end,
			[Step 1] = case when b.[Step 1] is null then a.[Step 1] when a.[Step 1] is null then b.[Step 1] else a.[Step 1] + b.[Step 1] end,
			[Step 2] = case when b.[Step 2] is null then a.[Step 2] when a.[Step 2] is null then b.[Step 2] else a.[Step 2] + b.[Step 2] end,
			Blast = case when b.Blast is null then a.Blast when a.Blast is null then b.Blast else a.Blast + b.Blast end,
			Paint = case when b.Paint is null then a.Paint when a.Paint is null then b.Paint else a.Paint + b.Paint end,
			[Finish - GNK] = case when b.[Finish - GNK] is null then a.[Finish - GNK] when a.[Finish - GNK] is null then b.[Finish - GNK] else a.[Finish - GNK] + b.[Finish - GNK] end,
			[Final Assembly] = case when b.[Final Assembly] is null then a.[Final Assembly] when a.[Final Assembly] is null then b.[Final Assembly] else a.[Final Assembly] + b.[Final Assembly] end,
			[Tire Assembly] = case when b.[Tire Assembly] is null then a.[Tire Assembly] when a.[Tire Assembly] is null then b.[Tire Assembly] else a.[Tire Assembly] + b.[Tire Assembly] end,
			Shipping = case when b.Shipping is null then a.Shipping when a.Shipping is null then b.Shipping else a.Shipping + b.Shipping end,
			[Draw/Part#] = case when b.[Draw/Part#] is null then a.[Draw/Part#]  when a.[Draw/Part#] is null then b.[Draw/Part#] else a.[Draw/Part#] + '
			' + b.[Draw/Part#] end,
			OptNPOWt = case when b.Weight is null then a.OptNPOWt when a.OptNPOWt is null then b.Weight else a.OptNPOWt + b.Weight end,
			Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
			Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
			Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
			BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
			FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end,
			Changed = case when b.NetInches is null then 0 else 1 end,
			NPO = case when b.NPOIndicator is null then 0 else b.NPOIndicator end
			from @ftandin as a
			left outer join (select OptionNPOID, SpecSortG, SpecSortSe, NPOIndicator, NetInches, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour, [Steel Kit], Axles, [Step 1], [Step 2], Blast, Paint, [Finish - GNK], [Final Assembly], [Tire Assembly], Shipping, [Draw/Part#], Weight
							 from (select OptionNPOID, SpecSortG, SpecSortSe, NPOIndicator, sum(cast(Inches as int)) as NetInches, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
								   sum([Steel Kit]) as [Steel Kit], sum(Axles) as Axles, sum([Step 1]) as [Step 1], sum([Step 2]) as [Step 2], sum(Blast) as Blast, sum(Paint) as Paint, sum([Finish - GNK]) as [Finish - GNK], sum([Final Assembly]) as [Final Assembly], sum([Tire Assembly]) as [Tire Assembly], sum(Shipping) as Shipping, [Draw/Part#], sum(Wt) as Weight
 								   from (select b.OrdOptRevID# as OptionNPOID, OptionSpecs.SpecSortG, OptionSpecs.SpecSortSe, 0 as NPOIndicator, cast(right(left(SpecDescription, CHARINDEX('~', SpecDescription) - 1), charindex('.', SpecDescription) - 1) as int) * Qty as Inches, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
						   				 case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
										 case when Line# = 1 then Axles * Qty else 0 end as Axles, 
										 case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
										 case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
										 case when Line# = 1 then Blast * Qty else 0 end as Blast, 
										 case when Line# = 1 then Paint * Qty else 0 end as Paint, 
										 case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
										 case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
										 case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly], 
										 case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
										 case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
										 case when Line# = 1 then Weight * Qty else 0 end as Wt
										 from [Order Options_RevHistory] with (nolock)
										 inner join #optionspecs as OptionSpecs with (nolock) on [Order Options_RevHistory].Quote# = OptionSpecs.Quote#
																							   and [Order Options_RevHistory].OrdOptRevID# = OptionSpecs.OrderOptionID
										 left outer join (select SpecSortG, SpecSortSe, [Order Options_RevHistory].OrdOptRevID# from [Order Options_RevHistory] with (nolock)
														  inner join #optionspecs as OptionSpecs with (nolock) on [Order Options_RevHistory].Quote# = OptionSpecs.Quote#
																											    and [Order Options_RevHistory].OrdOptRevID# = OptionSpecs.OrderOptionID
														  where ([Order Options_RevHistory].Quote# = @QuoteorWO or [Order Options_RevHistory].WO# = @QuoteorWO) and [Order Options_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-91' and Line# = 1) as b on OptionSpecs.SpecSortG = b.SpecSortG and OptionSpecs.SpecSortSe = b.SpecSortSe
										 where ([Order Options_RevHistory].[Quote#] = @QuoteorWO or [Order Options_RevHistory].WO# = @QuoteorWO) and [Order Options_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-91'

										 union all select b.CWRevID# as OptionNPOID, NPOSpecs.SpecSortG, NPOSpecs.SpecSortSe, 1, cast(right(left(SpecDescription, CHARINDEX('~', SpecDescription) - 1), charindex('.', SpecDescription) - 1) as int) * Qty as Inches,
										 SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour,
										 case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
										 case when Line# = 1 then Axles * Qty else 0 end as Axles, 
										 case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
										 case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
										 case when Line# = 1 then Blast * Qty else 0 end as Blast, 
										 case when Line# = 1 then Paint * Qty else 0 end as Paint, 
										 case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
										 case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
										 case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly],
										 case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
										 case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
										 case when Line# = 1 then Weight * Qty else 0 end as Wt
										 from [Custom Work_RevHistory] with (nolock)
										 inner join #npospecs as NPOSpecs with (nolock) on [Custom Work_RevHistory].Quote# = NPOSpecs.Quote#
																							 and [Custom Work_RevHistory].CWRevID# = NPOSpecs.NPOID
										 left outer join (select SpecSortG, SpecSortSe, [Custom Work_RevHistory].CWRevID# from [Custom Work_RevHistory] with (nolock)
										 inner join #npospecs as NPOSpecs with (nolock) on [Custom Work_RevHistory].Quote# = NPOSpecs.Quote#
																							 and [Custom Work_RevHistory].CWRevID# = NPOSpecs.NPOID
														  where ([Custom Work_RevHistory].Quote# = @QuoteorWO or [Custom Work_RevHistory].WO# = @QuoteorWO) and [Custom Work_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-91' and Line# = 1) as b on NPOSpecs.SpecSortG = b.SpecSortG and NPOSpecs.SpecSortSe = b.SpecSortSe								 
										 where ([Custom Work_RevHistory].[Quote#] = @QuoteorWO or [Custom Work_RevHistory].WO# = @QuoteorWO) and [Custom Work_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-91') as mainsub
									group by OptionNPOID, SpecSortG, SpecSortSe, NPOIndicator, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour, [Draw/Part#]) as mainsub) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe

			--Adjust ft. and in. to proper measurments (Inches <= 12)
			update @ftandin
			set Feet = case when Inches between 12 and 23 then Feet + 1
							when Inches between 24 and 35 then Feet + 2
							when Inches between 36 and 47 then Feet + 3
							when Inches between 48 and 59 then Feet + 4
							when Inches between 60 and 71 then Feet + 5
							when Inches between 72 and 83 then Feet + 6
							when Inches between 84 and 95 then Feet + 7
							when Inches between 96 and 107 then Feet + 8
							when Inches between 108 and 119 then Feet + 9
							when Inches between 120 and 131 then Feet + 10
							else Feet end,
			Inches = case when Inches between 12 and 23 then Inches - 12
						  when Inches between 24 and 35 then Inches - 24
						  when Inches between 36 and 47 then Inches - 36
						  when Inches between 48 and 59 then Inches - 48
						  when Inches between 60 and 71 then Inches - 60
						  when Inches between 72 and 83 then Inches - 72
						  when Inches between 84 and 95 then Inches - 84
						  when Inches between 96 and 107 then Inches - 96
						  when Inches between 108 and 119 then Inches - 108
						  when Inches between 120 and 131 then Inches - 120
						  else Inches end
			where Changed = 1

			--Update lines from options and npos with code -91 (ft. addition only)
			update @ftandin
			set Feet = case when b.NetFeet is null then a.Feet else a.Feet + b.NetFeet end,
			Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
			Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
			Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
			BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
			FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end,
			Changed = case when b.NetFeet is null then 0 else 1 end,
			NPO = case when b.NPOIndicator is null then 0 else b.NPOIndicator end
			from @ftandin as a
			left outer join (select SpecSortG, SpecSortSe, NPOIndicator, NetFeet, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour 
							 from (select SpecSortG, SpecSortSe, NPOIndicator, sum(cast(Feet as int)) as NetFeet, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour
								   from (select SpecSortG, SpecSortSe, 0 as NPOIndicator, cast(LEFT(SpecDescription, CHARINDEX('.',SpecDescription) - 1) as int) * Qty as Feet, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order Options_RevHistory] with (nolock)
										 inner join #optionspecs as OptionSpecs with (nolock) on [Order Options_RevHistory].Quote# = OptionSpecs.Quote#
																							   and [Order Options_RevHistory].OrdOptRevID# = OptionSpecs.OrderOptionID
										 where ([Order Options_RevHistory].Quote# = @QuoteorWO or [Order Options_RevHistory].WO# = @QuoteorWO) and [Order Options_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-91'

										 union all select SpecSortG, SpecSortSe, 1, cast(LEFT(SpecDescription, CHARINDEX('.',SpecDescription) - 1) as int) * Qty as Feet, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom Work_RevHistory] with (nolock)
										 inner join #npospecs as NPOSpecs with (nolock) on [Custom Work_RevHistory].Quote# = NPOSpecs.Quote#
																							 and [Custom Work_RevHistory].CWRevID# = NPOSpecs.NPOID
										 where ([Custom Work_RevHistory].Quote# = @QuoteorWO or [Custom Work_RevHistory].WO# = @QuoteorWO) and [Custom Work_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-91') as mainsub
									group by SpecSortG, SpecSortSe, NPOIndicator, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour) as mainsub) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe

			--Apply cap from option and NPO lines with code -91
			update @ftandin
			set Feet = case when (Feet * 12) + Inches >= (CapFeet * 12) + CapInches then CapFeet else Feet end,
			Inches = case when (Feet * 12) + Inches >= (CapFeet * 12) + CapInches then CapInches else Inches end
			from @ftandin as a
			inner join (select SpecSortG, SpecSortSe,
						left(right(SpecDescription, charindex('~', SpecDescription) + 1), charindex('.', right(SpecDescription, charindex('~', SpecDescription) + 1)) - 1) as CapFeet,
						left(right(SpecDescription, len(SpecDescription) - charindex('.', SpecDescription, charindex('.', SpecDescription) + 1)),
							 CHARINDEX('~', right(SpecDescription, len(SpecDescription) - charindex('.', SpecDescription, charindex('.', SpecDescription) + 1))) - 1)  as CapInches
						from #optionspecs as OptionSpecs
						where (OptionSpecs.Quote# = @QuoteorWO or OptionSpecs.WO# = @QuoteorWO) and SpecSortSeLine = '-91'

						union all select SpecSortG, SpecSortSe,
						left(right(SpecDescription, charindex('~', SpecDescription) + 1), charindex('.', right(SpecDescription, charindex('~', SpecDescription) + 1)) - 1),
						left(right(SpecDescription, len(SpecDescription) - charindex('.', SpecDescription, charindex('.', SpecDescription) + 1)),
							 CHARINDEX('~', right(SpecDescription, len(SpecDescription) - charindex('.', SpecDescription, charindex('.', SpecDescription) + 1))) - 1)
						from #npospecs as NPOSpecs
						where (NPOSpecs.Quote# = @QuoteorWO or NPOSpecs.WO# = @QuoteorWO) and SpecSortSeLine = '-91') as b on a.SortGv2 = b.SpecSortG

			--Handing changed @ftandin tv records with "1" position
			update @ftandin
			set FeetPosition = 0
			where FeetPosition = 1
			and Changed = 1
	
			update @ftandin
			set InchesPosition = 0
			where InchesPosition = 1
			and Changed = 1
	
			--Update @specs tv with lines from @ftandin tv
			update #specs
			set OptionNPOID = case when b.OptionNPOID is null then a.OptionNPOID else b.OptionNPOID end,
			Description = case when b.Feet is null then a.Description --No Feet/Inches additions
							   when b.Feet = 0 then case when NPO = 1 then '*NPO*: ' else '' end + left(Description, b.InchesPosition) + cast(b.Inches as nvarchar) + right(Description, len(Description) - (CHARINDEX('in.', Description) - 2)) --Inches addition only
							   when b.Inches = 0 and InchesPosition = 0 then case when NPO = 1 then '*NPO*: ' else '' end + left(Description, case when Description like '*NPO*:%' then b.FeetPosition - 1 else b.FeetPosition end) + cast(b.Feet as nvarchar) + right(Description, len(Description) - (CHARINDEX('ft.', Description) - 2)) --Feet addition only
							   when b.Feet <> 0 and CHARINDEX('in.', Description) = 0 then case when NPO = 1 then '*NPO*: ' else '' end + left(Description, case when Description like '*NPO*:%' then b.FeetPosition - 1 else b.FeetPosition end) + cast(b.Feet as nvarchar) + ' ft. ' + cast(b.Inches as nvarchar) + ' in. ' 
																						   + right(Description, len(Description) - (len(cast(b.Feet as nvarchar) + ' ft. '))) --Changes ft. to ft. and in.
							   when b.Inches <> 0 and CHARINDEX('ft.', Description) = 0 then case when NPO = 1 then '*NPO*: ' else '' end + left(Description, b.InchesPosition) + cast(b.Feet as nvarchar) + ' ft. ' + cast(b.Inches as nvarchar) + right(Description, len(Description) - (CHARINDEX('in.', Description) - 2)) --Changes in. to ft. and in.
							   else case when NPO = 1 then '*NPO*: ' else '' end + left(Description, case when Description like '*NPO*:%' then b.FeetPosition - 1 else b.FeetPosition end) + cast(b.Feet as nvarchar) + ' ft. ' + cast(b.Inches as nvarchar) + right(Description, len(Description) - (CHARINDEX('in.', Description) - 2)) end, 
			[Steel Kit] = case when b.[Steel Kit] is null then a.[Steel Kit] when a.[Steel Kit] is null then b.[Steel Kit] else a.[Steel Kit] + b.[Steel Kit] end,
			Axles = case when b.Axles is null then a.Axles when a.Axles is null then b.Axles else a.Axles + b.Axles end,
			[Step 1] = case when b.[Step 1] is null then a.[Step 1] when a.[Step 1] is null then b.[Step 1] else a.[Step 1] + b.[Step 1] end,
			[Step 2] = case when b.[Step 2] is null then a.[Step 2] when a.[Step 2] is null then b.[Step 2] else a.[Step 2] + b.[Step 2] end,
			Blast = case when b.Blast is null then a.Blast when a.Blast is null then b.Blast else a.Blast + b.Blast end,
			Paint = case when b.Paint is null then a.Paint when a.Paint is null then b.Paint else a.Paint + b.Paint end,
			[Finish - GNK] = case when b.[Finish - GNK] is null then a.[Finish - GNK] when a.[Finish - GNK] is null then b.[Finish - GNK] else a.[Finish - GNK] + b.[Finish - GNK] end,
			[Final Assembly] = case when b.[Final Assembly] is null then a.[Final Assembly] when a.[Final Assembly] is null then b.[Final Assembly] else a.[Final Assembly] + b.[Final Assembly] end,
			[Tire Assembly] = case when b.[Tire Assembly] is null then a.[Tire Assembly] when a.[Tire Assembly] is null then b.[Tire Assembly] else a.[Tire Assembly] + b.[Tire Assembly] end,
			Shipping = case when b.Shipping is null then a.Shipping when a.Shipping is null then b.Shipping else a.Shipping + b.Shipping end,
			[Draw/Part#] = case when b.[Draw/Part#] is null then a.[Draw/Part#]  when a.[Draw/Part#] is null then b.[Draw/Part#] else a.[Draw/Part#] + '
			' + b.[Draw/Part#] end,
			OptNPOWt = case when b.OptNPOWt is null then a.OptNPOWt when a.OptNPOWt is null then b.OptNPOWt else a.OptNPOWt + b.OptNPOWt end,
			Bold = b.Bold,
			Italic = b.Italic,
			Underline = b.Underline,
			BackColour = b.BackColour,
			FontColour = b.FontColour
			from #specs as a
			inner join @ftandin as b on a.SortGv2 = b.SortGv2 and a.SortSev2 = b.SortSev2
			where Changed = 1

			--Replace "ft. 0 in." with "ft." as "0 in." is unnecessary
			update #specs
			set Description = replace(Description, 'ft. 0 in.', 'ft.')

			--Code -90 - infinite find and replace array (minics code 0)
			--Drop and create temp table in tmpdb SQL database for faster processing
			--Code reference: http://stackoverflow.com/questions/8726111/sql-server-find-nth-occurrence-in-a-string
			IF OBJECT_ID('tempdb..#t2') IS NOT NULL
				DROP TABLE #t2 
	
			--Grab Option and NPO Spec Line Descriptions for Code -90
			select SpecDescription as img into #t2
			from [Order Options_RevHistory] with (nolock)
			inner join #optionspecs as OptionSpecs with (nolock) on [Order Options_RevHistory].Quote# = OptionSpecs.Quote#
																  and [Order Options_RevHistory].OrdOptRevID# = OptionSpecs.OrderOptionID
			where ([Order Options_RevHistory].Quote# = @QuoteorWO or [Order Options_RevHistory].WO# = @QuoteorWO) and [Order Options_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-90'

			union all select SpecDescription
			from [Custom Work_RevHistory] with (nolock)
			inner join #npospecs as NPOSpecs with (nolock) on [Custom Work_RevHistory].Quote# = NPOSpecs.Quote#
																and [Custom Work_RevHistory].CWRevID# = NPOSpecs.NPOID
			where ([Custom Work_RevHistory].Quote# = @QuoteorWO or [Custom Work_RevHistory].WO# = @QuoteorWO) and [Custom Work_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-90'

			;with T(img, starts, pos) as (
				select img, 1, charindex('~', img) from #t2
				union all
				select img, cast(pos + 1 as int), charindex('~', img, pos + 1)
				from t
				where pos > 0
			)
			insert into @t (ID, Description, Starts, Pos, token)
			select ROW_NUMBER() over (partition by img order by img, starts, pos),
			img, starts, pos,
			substring(img, starts, case when pos > 0 then pos - starts else len(img) end) token
			from T
			where substring(img, starts, case when pos > 0 then pos - starts else len(img) end) <> '.'
			and substring(img, starts, case when pos > 0 then pos - starts else len(img) end) <> ''
			order by img, starts

			--Update the description in the Specs table, based on the Spec Line and the Option/NPO Qty
			update #specs
			set OptionNPOID = case when b.OptionNPOID is null then a.OptionNPOID else b.OptionNPOID end,
			Description = token,
			[Steel Kit] = case when b.[Steel Kit] is null then a.[Steel Kit] when a.[Steel Kit] is null then b.[Steel Kit] else a.[Steel Kit] + b.[Steel Kit] end,
			Axles = case when b.Axles is null then a.Axles when a.Axles is null then b.Axles else a.Axles + b.Axles end,
			[Step 1] = case when b.[Step 1] is null then a.[Step 1] when a.[Step 1] is null then b.[Step 1] else a.[Step 1] + b.[Step 1] end,
			[Step 2] = case when b.[Step 2] is null then a.[Step 2] when a.[Step 2] is null then b.[Step 2] else a.[Step 2] + b.[Step 2] end,
			Blast = case when b.Blast is null then a.Blast when a.Blast is null then b.Blast else a.Blast + b.Blast end,
			Paint = case when b.Paint is null then a.Paint when a.Paint is null then b.Paint else a.Paint + b.Paint end,
			[Finish - GNK] = case when b.[Finish - GNK] is null then a.[Finish - GNK] when a.[Finish - GNK] is null then b.[Finish - GNK] else a.[Finish - GNK] + b.[Finish - GNK] end,
			[Final Assembly] = case when b.[Final Assembly] is null then a.[Final Assembly] when a.[Final Assembly] is null then b.[Final Assembly] else a.[Final Assembly] + b.[Final Assembly] end,
			[Tire Assembly] = case when b.[Tire Assembly] is null then a.[Tire Assembly] when a.[Tire Assembly] is null then b.[Tire Assembly] else a.[Tire Assembly] + b.[Tire Assembly] end,
			Shipping = case when b.Shipping is null then a.Shipping when a.Shipping is null then b.Shipping else a.Shipping + b.Shipping end,
			[Draw/Part#] = case when b.[Draw/Part#] is null then a.[Draw/Part#]  when a.[Draw/Part#] is null then b.[Draw/Part#] else a.[Draw/Part#] + '
			' + b.[Draw/Part#] end,
			OptNPOWt = case when b.Weight is null then a.OptNPOWt when a.OptNPOWt is null then b.Weight else a.OptNPOWt + b.Weight end
			from #specs as a
			inner join (select OptionNPOID, SpecSortG, SpecSortSe, FirstLine, token, 
						sum([Steel Kit]) as [Steel Kit], sum(Axles) as Axles, sum([Step 1]) as [Step 1], sum([Step 2]) as [Step 2], sum(Blast) as Blast, sum(Paint) as Paint,
						sum([Finish - GNK]) as [Finish - GNK], sum([Final Assembly]) as [Final Assembly], sum([Tire Assembly]) as [Tire Assembly], sum(Shipping) as Shipping, [Draw/Part#], sum(Wt) as Weight
						from (select b.OrdOptRevID# as OptionNPOID, OptionSpecs.SpecSortG, OptionSpecs.SpecSortSe, FirstLine, token, 
							  case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
							  case when Line# = 1 then Axles * Qty else 0 end as Axles, 
							  case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
							  case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
							  case when Line# = 1 then Blast * Qty else 0 end as Blast, 
							  case when Line# = 1 then Paint * Qty else 0 end as Paint, 
							  case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
							  case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
							  case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly], 
							  case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
							  case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
							  case when Line# = 1 then Weight * Qty else 0 end as Wt
							  from [Order Options_RevHistory] with (nolock)
							  inner join #optionspecs as OptionSpecs with (nolock) on [Order Options_RevHistory].Quote# = OptionSpecs.Quote#
																					and [Order Options_RevHistory].OrdOptRevID# = OptionSpecs.OrderOptionID
							  inner join (select SpecSortG, SpecSortSe,
											min(case when SpecSortSeLine < 0 then 0 else SpecSortSeLine end) as FirstLine 
											from #optionspecs
											where Quote# = @QuoteorWO or WO# = @QuoteorWO
											group by SpecSortG, SpecSortSe) as subFirstLine on OptionSpecs.SpecSortG = subFirstLine.SpecSortG
																								and OptionSpecs.SpecSortSe = subFirstLine.SpecSortSe
							  left outer join (select SpecSortG, SpecSortSe, [Order Options_RevHistory].OrdOptRevID# from [Order Options_RevHistory] with (nolock)
											   inner join #optionspecs as OptionSpecs with (nolock) on [Order Options_RevHistory].Quote# = OptionSpecs.Quote#
																									 and [Order Options_RevHistory].OrdOptRevID# = OptionSpecs.OrderOptionID
											   where ([Order Options_RevHistory].Quote# = @QuoteorWO or [Order Options_RevHistory].WO# = @QuoteorWO) and [Order Options_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-90' and Line# = 1) as b on OptionSpecs.SpecSortG = b.SpecSortG and OptionSpecs.SpecSortSe = b.SpecSortSe
							  inner join @t as a on [Order Options_RevHistory].Qty = a.ID
													and OptionSpecs.SpecDescription = a.Description
							  where ([Order Options_RevHistory].Quote# = @QuoteorWO or [Order Options_RevHistory].WO# = @QuoteorWO) and [Order Options_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-90'

							  union all select b.CWRevID#, NPOSpecs.SpecSortG, NPOSpecs.SpecSortSe, FirstLine, token, 
							  case when Line# = 1 then [Steel Kit] * Qty else 0 end as [Steel Kit], 
							  case when Line# = 1 then Axles * Qty else 0 end as Axles, 
							  case when Line# = 1 then [Step 1] * Qty else 0 end as [Step 1], 
							  case when Line# = 1 then [Step 2] * Qty else 0 end as [Step 2], 
							  case when Line# = 1 then Blast * Qty else 0 end as Blast, 
							  case when Line# = 1 then Paint * Qty else 0 end as Paint, 
							  case when Line# = 1 then [Finish - GNK] * Qty else 0 end as [Finish - GNK], 
							  case when Line# = 1 then [Final Assembly] * Qty else 0 end as [Final Assembly], 
							  case when Line# = 1 then [Tire Assembly] * Qty else 0 end as [Tire Assembly], 
							  case when Line# = 1 then Shipping * Qty else 0 end as Shipping,
							  case when Line# = 1 then [Draw/Part#] else null end as [Draw/Part#],
							  case when Line# = 1 then Weight * Qty else 0 end as Wt
							  from [Custom Work_RevHistory] with (nolock)
							  inner join #npospecs as NPOSpecs with (nolock) on [Custom Work_RevHistory].Quote# = NPOSpecs.Quote#
																				  and [Custom Work_RevHistory].CWRevID# = NPOSpecs.NPOID
							  inner join (select SpecSortG, SpecSortSe,
											min(case when SpecSortSeLine < 0 then 0 else SpecSortSeLine end) as FirstLine 
											from #npospecs
											where Quote# = @QuoteorWO
											group by SpecSortG, SpecSortSe) as subFirstLine on NPOSpecs.SpecSortG = subFirstLine.SpecSortG
																							   and NPOSpecs.SpecSortSe = subFirstLine.SpecSortSe
							  left outer join (select SpecSortG, SpecSortSe, [Custom Work_RevHistory].CWRevID# from [Custom Work_RevHistory] with (nolock)
											   inner join #npospecs as NPOSpecs with (nolock) on [Custom Work_RevHistory].Quote# = NPOSpecs.Quote#
																								   and [Custom Work_RevHistory].CWRevID# = NPOSpecs.NPOID
											   where ([Custom Work_RevHistory].Quote# = @QuoteorWO or [Custom Work_RevHistory].WO# = @QuoteorWO) and [Custom Work_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-90' and Line# = 1) as b on NPOSpecs.SpecSortG = b.SpecSortG and NPOSpecs.SpecSortSe = b.SpecSortSe
							  inner join @t as a on [Custom Work_RevHistory].Qty = a.ID
													and NPOSpecs.SpecDescription = a.Description
							  where ([Custom Work_RevHistory].Quote# = @QuoteorWO or [Custom Work_RevHistory].WO# = @QuoteorWO) and [Custom Work_RevHistory].Rev# = @QuoteorWORev and SpecSortSeLine = '-90') as mainsub
						group by OptionNPOID, SpecSortG, SpecSortSe, FirstLine, token, [Draw/Part#]) as b on a.SortGv2 = b.SpecSortG
																											  and a.SortSev2 = b.SpecSortSe
																											  and a.SpecSortSeLine = b.FirstLine

			/*

				Code -89 to be added later!
				Will mimic code -99, but will have a cap (similar to code -91)

			*/

			--Remove nulls from formatting columns
			update #specs
			set Bold = 0
			where Bold is null

			update #specs
			set Italic = 0
			where Italic is null
	
			update #specs
			set Underline = 0
			where Underline is null

			update #specs
			set BackColour = 'Transparent'
			where BackColour is null

			update #specs
			set FontColour = 'Black'
			where FontColour is null

			--Add "Comments" from Order Options to end of text for first line
			update #specs
			set Description = Description + ': ' + convert(nvarchar(max), Comments)
			from #specs as a
			inner join (select SpecSortG, SpecSortSe,
						case when SpecSortSeLine < 0 then 0 else SpecSortSeLine end as SpecSortSeLine,
						case when Qty > 1 then convert(nvarchar, Qty) + ', ' + SpecDescription else SpecDescription end as SpecDescription, 
						Comments from [Order Options_RevHistory] with (nolock)
						inner join #optionspecs as OptionSpecs with (nolock) on [Order Options_RevHistory].Quote# = OptionSpecs.Quote#
																			  and [Order Options_RevHistory].OrdOptRevID# = OptionSpecs.OrderOptionID
						where ([Order Options_RevHistory].Quote# = @QuoteorWO or [Order Options_RevHistory].WO# = @QuoteorWO) and [Order Options_RevHistory].Rev# = @QuoteorWORev
						and Line# = 1
						and Comments is not null) as b on a.SortGv2 = b.SpecSortG
														  and a.SortSev2 = b.SpecSortSe
														  and a.SpecSortSeLine = b.SpecSortSeLine

			insert into @WidthSpreadandDeckLength (Quote#, Width)
			select Quote#, left(SUBSTRING(Description, PATINDEX('%[0-9]%', Description), len(Description)), PATINDEX('%[^0-9]%', SUBSTRING(Description, PATINDEX('%[0-9]%', Description), len(Description)) + 't') - 1)
			from #specs
			where [Group] = 'Trailer'
			and Section = 'Overall Width'

			update @WidthSpreadandDeckLength
			set Quote# = a.Quote#,
			Spread = left(SUBSTRING(Description, PATINDEX('%[0-9]%', Description), len(Description)), PATINDEX('%[^0-9]%', SUBSTRING(Description, PATINDEX('%[0-9]%', Description), len(Description)) + 't') - 1)
			from #specs as a
			where [Group] = 'SUSPENSION/AXLES'
			and Section = 'Spread'

			update @WidthSpreadandDeckLength
			set Quote# = a.Quote#,
			DeckLength = left(SUBSTRING(Description, PATINDEX('%[0-9]%', Description), len(Description)), PATINDEX('%[^0-9]%', SUBSTRING(Description, PATINDEX('%[0-9]%', Description), len(Description)) + 't') - 1)
			from #specs as a
			where [Group] = 'DECK'
 			and Section = 'Deck Length'

			--Update Orders table
			update Orders
			set Width = b.Width,
			Spread = b.Spread,
			[Deck Length] = b.DeckLength
			from Orders as a with (nolock)
			inner join @WidthSpreadandDeckLength as b on a.Quote# = b.Quote#

			--Update Design table
			update Design
			set Width = b.Width,
			Spread = b.Spread,
			[Deck Length] = b.DeckLength
			from Design as a with (nolock)
			inner join @WidthSpreadandDeckLength as b on a.Quote# = b.Quote#

			--Move all *NPO* characters to the front of the line and remove *NPO* characters that aren't
			update #specs
			set Description = '*NPO*: ' + Description
			where Description like '%*NPO*%'
			and CHARINDEX('*NPO*', Description) <> 1

			update #specs
			set Description = REPLACE(Description, ' *NPO*: ', ' ')
	
			update #specs
			set Description = REPLACE(Description, '(*NPO*->) ', '')

			----select statement
			--select Orders_RevHistory.Quote#, Orders_RevHistory.Rev# as Revision#, Orders_RevHistory.WO#, [GN WO#], Products.[Top Level Part# (SYSPRO)],
			--subD.Width, subD.Spread, subD.DeckLength as [Deck Length],
			--Orders_RevHistory.[Model No],
			--Orders_RevHistory.[Order Date], [Prod Date], [Available Date], Orders_RevHistory.[Delivery Date], [Date Declined],
			--case when CompletedJobInfo.ActCompleteDate is null then dbo.Production.[Date Completed] else CompletedJobInfo.ActCompleteDate end as [Date Completed],
			--Orders_RevHistory.[Shipped Date],
			--case when CompletedJobInfo.EntInvoiceDate is null then dbo.Orders_RevHistory.[Invoice Date] else CompletedJobInfo.EntInvoiceDate end as [Invoice Date],
			--Class, Model, PDD, [Prom Drawing],
			--subA.Weight as TrailerWt,
			--cast(subA.Weight / 2.2046226218 as float) as TrailerKg,
			--subB.TtlOptWt,
			--cast(subB.TtlOptWt / 2.2046226218 as float) as TtlOptKg,
			--subC.CWwt,
			--cast(subC.CWwt / 2.2046226218 as float) as CWKg,
			--subA.Weight + subB.TtlOptWt + subC.CWwt as UnitWt,
			--cast((subA.Weight + subB.TtlOptWt + subC.CWwt) / 2.2046226218 as float) as UnitKg,
			--[COMPANY NAME], CONTACT, Orders_RevHistory.[Serial Number], [PO Date], [Purchase Order], [Sales Person], Orders_RevHistory.[Special Instructions],
			--0 as BaseSK, [Order Hours_RevHistory].Axles as BaseAxle, [Order Hours_RevHistory].[Step 1] as BaseStep1, [Order Hours_RevHistory].[Step 2] as BaseStep2,
			--[Order Hours_RevHistory].Blast as BaseBlast, [Order Hours_RevHistory].Paint as BasePaint, 
			--[Order Hours_RevHistory].[Finish - GNK] as BaseFGNK, [Order Hours_RevHistory].[Final Assembly] as BaseFinalAssembly, 
			--[Order Hours_RevHistory].[Tire Assembly] as BaseTireAssembly, [Order Hours_RevHistory].Shipping as BaseShipping,
			--(0 + [Order Hours_RevHistory].Axles + [Order Hours_RevHistory].[Step 1] + [Order Hours_RevHistory].[Step 2] + [Order Hours_RevHistory].Blast + [Order Hours_RevHistory].Paint 
			-- + [Order Hours_RevHistory].[Finish - GNK] + [Order Hours_RevHistory].[Final Assembly] + [Order Hours_RevHistory].[Tire Assembly] + [Order Hours_RevHistory].Shipping) as BaseHours,
			--sub.[Group] as SGroup, sub.SortGv2 as SSortG, sub.Section as SSection, sub.SortSev2 as SSortSe, sub.SpecSortSeLine as SSortSeLine, sub.Description, 
			--sub.Bold, sub.Italic, sub.Underline, sub.BackColour, sub.FontColour,
			--sub.[Steel Kit] as OptSK, sub.Axles as OptAxle, sub.[Step 1] as OptStep1, sub.[Step 2] as OptStep2, 
			--sub.Blast as OptBlast, sub.Paint as OptPaint, 
			--sub.[Finish - GNK] as OptFGNK, sub.[Final Assembly] as OptFinalAssembly, sub.[Tire Assembly] as OptTireAssembly, sub.Shipping as OptShipping,
			--(sub.Axles + sub.[Step 1] + sub.[Step 2] + sub.Blast + sub.Paint + sub.[Finish - GNK] + sub.[Final Assembly] + sub.[Tire Assembly] + sub.Shipping) as OptHours,
			--[Draw/Part#], OptionNPOID, OptNPOWt, BOL#
			--from Orders_RevHistory with (nolock)
			--inner join BWSdb.dbo.Products with (nolock) on Orders_RevHistory.[Model No] = Products.[Model No]
			--left outer join Production with (nolock) on Orders_RevHistory.Quote# = Production.Quote#
			----left outer join SysproCompanyA.dbo.v_CompletedJobInfo with (nolock) on CAST(dbo.Orders_RevHistory.WO# AS char(8)) COLLATE Latin1_General_BIN = SysproCompanyA.dbo.v_CompletedJobInfo.Job
			--left outer join ( 
			--				select *
			--				from (
			--						select *,
			--						ROW_NUMBER() over(partition by Job order by Job, InvoiceNumber desc) as RowID
			--						from SysproCompanyA.dbo.v_CompletedJobInfo with (nolock)
			--					) as subA
			--				where RowID = 1
			--				) as CompletedJobInfo on CAST(dbo.Orders_RevHistory.WO# AS varchar(20)) COLLATE Latin1_General_BIN = CompletedJobInfo.Job
			--left outer join (select Quote#, Rev#, case when Description is null then 0
			--									 else LEFT(SUBSTRING(replace(replace(replace(Description,'(',''),')',''), ',', ''), PATINDEX('%[0-9.-]%', replace(replace(replace(Description,'(',''),')',''), ',', '')), 8000),
			--												PATINDEX('%[^0-9.-]%', SUBSTRING(replace(replace(replace(Description,'(',''),')',''), ',', ''), PATINDEX('%[0-9.-]%', replace(replace(replace(Description,'(',''),')',''), ',', '')), 8000) + 'X') -1)
			--									 end as Weight
			--									 --else dbo.GetNumbersFromString(Description) end as Weight 
			--									 --else cast(replace(replace(replace(Description, 'TBD', '0'), ',', ''), ' ', '') as int) end as Weight
			--				 from [Order Standards_RevHistory] with (nolock)
			--				 where Section in ('Weight lbs +/- 2%', 'Weight lbs +/- 3%')) as subA on Orders_RevHistory.Quote# = subA.Quote# -- Adjusted to include for new Weight wording as per Shelley - JWC - Feb 11, 2022
			--																 and Orders_RevHistory.Rev# = subA.Rev#
			--left outer join (select Quote#, Rev#, sum(Weight) as TtlOptWt
			--				 from (select Quote#, Rev#, (Weight * Qty) as Weight 
			--					   from [Order Options_RevHistory] with (nolock)) as mainsub
			--				 group by Quote#, Rev#) as subB on Orders_RevHistory.Quote# = subB.Quote#
			--												   and Orders_RevHistory.Rev# = subB.Rev#
			--left outer join (select Quote#, Rev#, sum(Weight) as CWwt
			--				 from (select Quote#, Rev#, (Weight * Qty) as Weight
			--					   from [Custom Work_RevHistory] with (nolock)) as mainsub
			--				 group by Quote#, Rev#) as subC on Orders_RevHistory.Quote# = subC.Quote#
			--												   and Orders_RevHistory.Rev# = subC.Rev#
			--inner join #specs as sub on Orders_RevHistory.Quote# = sub.Quote#
			--inner join Dealers with (nolock) on Orders_RevHistory.DealerID = Dealers.ID
			--inner join [Sales Staff] with (nolock) on Orders_RevHistory.[Sale PersonID] = [Sales Staff].[ID-SaleStaff]
			--left outer join [Order Hours_RevHistory] with (nolock) on Orders_RevHistory.Quote# = [Order Hours_RevHistory].Quote#
			--											and Orders_RevHistory.Rev# = [Order Hours_RevHistory].Rev#
			--left outer join @WidthSpreadandDeckLength as subD on Orders_RevHistory.Quote# = subD.Quote#
			--left outer join v_WORpt1_BOLNo on Orders_RevHistory.WO# = v_WORpt1_BOLNo.WO#
			--where (Orders_RevHistory.Quote# = @QuoteorWO or Orders_RevHistory.WO# = @QuoteorWO)
			--and Orders_RevHistory.Rev# = @QuoteorWORev


	UPDATE
		@tWOs
	SET
		[Weight] = [Src].Weight + TtlOptWt + CWwt

			from ( SELECT subA.[Weight], [TtlOptWt], [CWwt] FROM Orders_RevHistory with (nolock)
			inner join BWSdb.dbo.Products with (nolock) on Orders_RevHistory.[Model No] = Products.[Model No]
			left outer join Production with (nolock) on Orders_RevHistory.Quote# = Production.Quote#
			--left outer join SysproCompanyA.dbo.v_CompletedJobInfo with (nolock) on CAST(dbo.Orders_RevHistory.WO# AS char(8)) COLLATE Latin1_General_BIN = SysproCompanyA.dbo.v_CompletedJobInfo.Job
			left outer join ( 
							select *
							from (
									select *,
									ROW_NUMBER() over(partition by Job order by Job, InvoiceNumber desc) as RowID
									from SysproCompanyA.dbo.v_CompletedJobInfo with (nolock)
								) as subA
							where RowID = 1
							) as CompletedJobInfo on CAST(dbo.Orders_RevHistory.WO# AS varchar(20)) COLLATE Latin1_General_BIN = CompletedJobInfo.Job
			left outer join (select Quote#, Rev#, case when Description is null then 0
												 else LEFT(SUBSTRING(replace(replace(replace(Description,'(',''),')',''), ',', ''), PATINDEX('%[0-9.-]%', replace(replace(replace(Description,'(',''),')',''), ',', '')), 8000),
															PATINDEX('%[^0-9.-]%', SUBSTRING(replace(replace(replace(Description,'(',''),')',''), ',', ''), PATINDEX('%[0-9.-]%', replace(replace(replace(Description,'(',''),')',''), ',', '')), 8000) + 'X') -1)
												 end as Weight
												 --else dbo.GetNumbersFromString(Description) end as Weight 
												 --else cast(replace(replace(replace(Description, 'TBD', '0'), ',', ''), ' ', '') as int) end as Weight
							 from [Order Standards_RevHistory] with (nolock)
							 where Section in ('Weight lbs +/- 2%', 'Weight lbs +/- 3%')) as subA on Orders_RevHistory.Quote# = subA.Quote# -- Adjusted to include for new Weight wording as per Shelley - JWC - Feb 11, 2022
																			 and Orders_RevHistory.Rev# = subA.Rev#
			left outer join (select Quote#, Rev#, sum(Weight) as TtlOptWt
							 from (select Quote#, Rev#, (Weight * Qty) as Weight 
								   from [Order Options_RevHistory] with (nolock)) as mainsub
							 group by Quote#, Rev#) as subB on Orders_RevHistory.Quote# = subB.Quote#
															   and Orders_RevHistory.Rev# = subB.Rev#
			left outer join (select Quote#, Rev#, sum(Weight) as CWwt
							 from (select Quote#, Rev#, (Weight * Qty) as Weight
								   from [Custom Work_RevHistory] with (nolock)) as mainsub
							 group by Quote#, Rev#) as subC on Orders_RevHistory.Quote# = subC.Quote#
															   and Orders_RevHistory.Rev# = subC.Rev#
			inner join #specs as sub on Orders_RevHistory.Quote# = sub.Quote#
			inner join Dealers with (nolock) on Orders_RevHistory.DealerID = Dealers.ID
			inner join [Sales Staff] with (nolock) on Orders_RevHistory.[Sale PersonID] = [Sales Staff].[ID-SaleStaff]
			left outer join [Order Hours_RevHistory] with (nolock) on Orders_RevHistory.Quote# = [Order Hours_RevHistory].Quote#
														and Orders_RevHistory.Rev# = [Order Hours_RevHistory].Rev#
			left outer join @WidthSpreadandDeckLength as subD on Orders_RevHistory.Quote# = subD.Quote#
			left outer join v_WORpt1_BOLNo on Orders_RevHistory.WO# = v_WORpt1_BOLNo.WO#
			where (Orders_RevHistory.Quote# = @QuoteorWO or Orders_RevHistory.WO# = @QuoteorWO)
			and Orders_RevHistory.Rev# = @QuoteorWORev) AS [Src]
		WHERE
		[@tWOs].[ID] = @i
	
	end
	SELECT @i = @i + 1;
END

SELECT * FROM @tWOs