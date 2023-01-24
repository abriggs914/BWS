DECLARE
	@quote varchar(8), @quoterev int
SET @quote = 'SG100044'
SET @quoterev = 0;
--AS
--BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--Drop and create temp table in tmpdb SQL database for faster processing
	IF OBJECT_ID('tempdb..#specs') IS NOT NULL
		DROP TABLE #specs 

	create table #specs
	(
		SpecID int identity(1, 1),
		[SGQuote] varchar(8),
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
		Price money,				
		HideShowOptionPriceWording bit default(0)
	)

	--Create table variable for ft. and in. calculation
	declare @ftandin table
	(
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
		Price money,
		Changed bit default(0),
		NPO bit default(0),				
		HideShowOptionPriceWording bit default(0)
	)

	declare @t table
	(
		ID int,
		Description nvarchar(max),
		Starts int,
		Pos int,
		token nvarchar(max)
	)

	declare @OptionsandNPOs_CountandWeight table
	(
		[OpNPOCount] int,
		[OpNPOWeight] int
	)

	declare @baseweight int

	--Determine if order is Canadian or American
	declare @USSale bit = 0

	select @USSale = [US Sale]
	from OrdersV2 with (nolock)
	where SGQuote = @quote

	--Determine which revision is being requested
	declare @maxrev int = case when (select case when max(Rev#) is null then 1 else max(Rev#) end 
									 from OrdersV2_RevHistory with (nolock)  where SGQuote = @quote) is null then 1
							   else (select case when max(Rev#) is null then 1 else max(Rev#) end 
									 from OrdersV2_RevHistory with (nolock)  where SGQuote = @quote) end

	--Generate Quote Report based on requested revision		
	--if @quoterev = 0 or @quoterev = @maxrev
	--	begin
			--Insert specs for model into tv
			insert into #specs ([SGQuote], [Group], SortGv2, Section, SortSev2, Description)
			select [SGQuote], [Group], SortGv2, Section, SortSev2, Description from [Order StandardsV2] with (nolock)
			where [SGQuote] = @quote

			--Insert lines from options into tv with replace code >= 1
			insert into #specs ([SGQuote], [Group], SortGv2, Section, SortSev2, SpecSortSeLine, Description, Price, HideShowOptionPriceWording, Bold, Italic, Underline, BackColour, FontColour)
			select [SGQuote], SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, OptionD, Price, HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour 
			from (select [Order OptionsV2].[SGQuote], SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, case when Qty > 1 then convert(nvarchar, Qty) + ', ' + SpecDescription else SpecDescription end as OptionD, (case when Line# <> 1 then 0 else Price end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order OptionsV2] with (nolock)
				  inner join [Order OptionsV2_SpecLines] with (nolock) on [Order OptionsV2].SGQuote = [Order OptionsV2_SpecLines].SGQuote
														  and [Order OptionsV2].ID = [Order OptionsV2_SpecLines].OrderOptionID
				  where [Order OptionsV2].[SGQuote] = @quote and SpecSortG is not null and SpecSortSeLine >= 1) as mainsub
			left outer join (select SortGv2, SortSev2, Description from #specs) as b on mainsub.SpecSortG = b.SortGv2 and mainsub.SpecSortSe = b.SortSev2 and mainsub.OptionD = b.Description

			--Update lines from options with replace code = 0
			update #specs
			set Description = b.OptionD,
			Price = case when a.Price is null then b.Price else a.Price + b.Price end,
			HideShowOptionPriceWording = case when a.HideShowOptionPriceWording = 1 then 1 when b.HideShowOptionPriceWording is null then a.HideShowOptionPriceWording else b.HideShowOptionPriceWording end,
			Bold = b.SpecDescriptionBold,
			Italic = b.SpecDescriptionItalic,
			Underline = b.SpecDescriptionUnderline,
			BackColour = b.SpecDescriptionBackColour,
			FontColour = b.SpecDescriptionFontColour
			from #specs as a
			inner join (select [SGQuote], SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, OptionD, Price, HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour 
						from (select [Order OptionsV2].[SGQuote], SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, case when Qty > 1 then convert(nvarchar, Qty) + ', ' + SpecDescription else SpecDescription end as OptionD, (case when Line# <> 1 then 0 else Price end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order OptionsV2] with (nolock) 
							  inner join [Order OptionsV2_SpecLines] with (nolock) on [Order OptionsV2].SGQuote = [Order OptionsV2_SpecLines].SGQuote
																	  and [Order OptionsV2].ID = [Order OptionsV2_SpecLines].OrderOptionID
							  where [Order OptionsV2].[SGQuote] = @quote and SpecSortG is not null and SpecSortSeLine = 0) as mainsub) as b on a.[SGQuote] = b.[SGQuote] and a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe and a.SpecSortSeLine = b.SpecSortSeLine
    
			--Insert lines from options with replace code >= 0 and are non-existant in specs tv
			insert into #specs ([SGQuote], [Group], SortGv2, Section, SortSev2, SpecSortSeLine, Description, Price, HideShowOptionPriceWording, Bold, Italic, Underline, BackColour, FontColour)
			select [SGQuote], SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, OptionD, Price, HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour 
			from (select [Order OptionsV2].[SGQuote], SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, case when Qty > 1 then convert(nvarchar, Qty) + ', ' + SpecDescription else SpecDescription end as OptionD, (case when Line# <> 1 then 0 else Price end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order OptionsV2] with (nolock) 
				  inner join [Order OptionsV2_SpecLines] with (nolock) on [Order OptionsV2].SGQuote = [Order OptionsV2_SpecLines].SGQuote
														  and [Order OptionsV2].ID = [Order OptionsV2_SpecLines].OrderOptionID
				  where [Order OptionsV2].[SGQuote] = @quote and SpecSortG is not null and SpecSortSeLine >= 0) as mainsub
			left outer join (select SortGv2, SortSev2, Description from #specs) as b on mainsub.SpecSortG = b.SortGv2 and mainsub.SpecSortSe = b.SortSev2 and mainsub.OptionD = b.Description
			where SortSev2 is null
			and Description is null

			--Insert lines from npos with replace code >= 1
			insert into #specs ([SGQuote], [Group], SortGv2, Section, SortSev2, SpecSortSeLine, Description, Price, HideShowOptionPriceWording, Bold, Italic, Underline, BackColour, FontColour)
			select [SGQuote], SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, NPOD, Price, HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour
			from (select [Custom WorkV2].[SGQuote], SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, '*NPO*: ' + case when Qty > 1 then convert(nvarchar, Qty) + ', ' + SpecDescription else SpecDescription end as NPOD, (case when Line# <> 1 then 0 else (case when [Quote Date] >= 'january 1 2019' and @USSale = 1 then [US Price] else Price end) end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom WorkV2] with (nolock)
				  inner join [Custom WorkV2_SpecLines] with (nolock) on [Custom WorkV2].SGQuote = [Custom WorkV2_SpecLines].SGQuote
														and [Custom WorkV2].ID = [Custom WorkV2_SpecLines].NPOID
				  where [Custom WorkV2].[SGQuote] = @quote and SpecSortG is not null and SpecSortSeLine >= 1) as mainsub
			left outer join (select SortGv2, SortSev2, Description from #specs) as b on mainsub.SpecSortG = b.SortGv2 and mainsub.SpecSortSe = b.SortSev2 and mainsub.NPOD = b.Description
	
			--Update lines from npos with replace code = 0
			update #specs
			set Description = b.NPOD,
			Price = case when a.Price is null then b.Price else a.Price + b.Price end,
			HideShowOptionPriceWording = case when a.HideShowOptionPriceWording = 1 then 1 when b.HideShowOptionPriceWording is null then a.HideShowOptionPriceWording else b.HideShowOptionPriceWording end,
			Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
			Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
			Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
			BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
			FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end
			from #specs as a
			inner join (select [SGQuote], SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, NPOD, Price, HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour
						from (select [Custom WorkV2].[SGQuote], SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, '*NPO*: ' + case when Qty > 1 then convert(nvarchar, Qty) + ', ' + SpecDescription else SpecDescription end as NPOD, (case when Line# <> 1 then 0 else (case when [Quote Date] >= 'january 1 2019' and @USSale = 1 then [US Price] else Price end) end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom WorkV2] with (nolock)
							  inner join [Custom WorkV2_SpecLines] with (nolock) on [Custom WorkV2].SGQuote = [Custom WorkV2_SpecLines].SGQuote
																	and [Custom WorkV2].ID = [Custom WorkV2_SpecLines].NPOID
							  where [Custom WorkV2].[SGQuote] = @quote and SpecSortG is not null and SpecSortSeLine = 0) as mainsub) as b on a.[SGQuote] = b.[SGQuote] and a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe and a.SpecSortSeLine = b.SpecSortSeLine
	
			--Insert lines from npos with replace code >= 0 and are non-existant in specs tv
			insert into #specs ([SGQuote], [Group], SortGv2, Section, SortSev2, SpecSortSeLine, Description, Price, HideShowOptionPriceWording, Bold, Italic, Underline, BackColour, FontColour)
			select [SGQuote], SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, NPOD, Price, HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour
			from (select [Custom WorkV2].[SGQuote], SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, '*NPO*: ' + case when Qty > 1 then convert(nvarchar, Qty) + ', ' + SpecDescription else SpecDescription end as NPOD, (case when Line# <> 1 then 0 else (case when [Quote Date] >= 'january 1 2019' and @USSale = 1 then [US Price] else Price end) end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom WorkV2] with (nolock)
				  inner join [Custom WorkV2_SpecLines] with (nolock) on [Custom WorkV2].SGQuote = [Custom WorkV2_SpecLines].SGQuote
														and [Custom WorkV2].ID = [Custom WorkV2_SpecLines].NPOID
				  where [Custom WorkV2].[SGQuote] = @quote and SpecSortG is not null and SpecSortSeLine >= 0) as mainsub
			left outer join (select SortGv2, SortSev2, Description from #specs) as b on mainsub.SpecSortG = b.SortGv2 and mainsub.SpecSortSe = b.SortSev2 and mainsub.NPOD = b.Description
			where SortSev2 is null
			and Description is null

			--Grab base weight to pass to report in final select statement
			select @baseweight = case when Description is null then 0 
							  else cast(dbo.GetNumbersFromString(replace(replace(Description, ',', ''), ' ', '')) as int) end
			from [Order StandardsV2]
			where Section in ('Weight lbs +/- 2%', 'Weight lbs +/- 3%') -- Adjusted to include for new Weight wording as per Shelley - JWC - Feb 11, 2022
			and SGQuote = @quote

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
									from [Order OptionsV2] with (nolock)
									where SGQuote = @quote
							
									union all select sum(Weight * Qty)
									from [Custom WorkV2] with (nolock)
									where SGQuote = @quote) as mainsub) as mainsub) as b
			where Section in ('Weight lbs +/- 2%', 'Weight lbs +/- 3%') -- Adjusted to include for new Weight wording as per Shelley - JWC - Feb 11, 2022

			--Update lines from options and npos with code -99 (addition to first int value in string only)
			--Code reference for selecting int: http://stackoverflow.com/a/16667778/4027761
			update #specs
			set Description = case when b.OW is null then a.Description
							  else replace(a.Description, 
								   left(SUBSTRING(a.Description, PATINDEX('%[0-9]%', a.Description), len(a.Description)), PATINDEX('%[^0-9]%', SUBSTRING(a.Description, PATINDEX('%[0-9]%', a.Description), len(a.Description)) + 't') - 1), 
								   case when NPOIndicator = 1 then '(*NPO*->) ' else '' end + cast(cast(left(SUBSTRING(a.Description, PATINDEX('%[0-9]%', a.Description), len(a.Description)), PATINDEX('%[^0-9]%', SUBSTRING(a.Description, PATINDEX('%[0-9]%', a.Description), len(a.Description)) + 't') - 1) as float) + b.OW as nvarchar)) end,
			Price = case when b.Price is null then a.Price when a.Price is null then b.Price else a.Price + b.Price end,
			HideShowOptionPriceWording = case when a.HideShowOptionPriceWording = 1 then 1 when b.HideShowOptionPriceWording is null then a.HideShowOptionPriceWording else b.HideShowOptionPriceWording end,
			Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
			Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
			Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
			BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
			FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end
			from #specs as a
			left outer join (select SpecSortG, SpecSortSe, NPOIndicator, NetWidth as OW, Price, HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour 
							 from (select SpecSortG, SpecSortSe, max(NPOIndicator) as NPOIndicator, sum(SD) as NetWidth, sum(Price) as Price, max(HideShowOptionPriceWording) as HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour
								   from (select SpecSortG, SpecSortSe, 0 as NPOIndicator, convert(float, SpecDescription) * Qty as SD, (case when Line# <> 1 then 0 else Price end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order OptionsV2] with (nolock)
										 inner join [Order OptionsV2_SpecLines] with (nolock) on [Order OptionsV2].SGQuote = [Order OptionsV2_SpecLines].SGQuote
																				 and [Order OptionsV2].ID = [Order OptionsV2_SpecLines].OrderOptionID
										 where [Order OptionsV2].SGQuote = @quote and SpecSortSeLine = '-99'
 
										 union all select SpecSortG, SpecSortSe, 1, convert(float, SpecDescription) * Qty, (case when Line# <> 1 then 0 else (case when [Quote Date] >= 'january 1 2019' and @USSale = 1 then [US Price] else Price end) end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom WorkV2] with (nolock)
										 inner join [Custom WorkV2_SpecLines] with (nolock) on [Custom WorkV2].SGQuote = [Custom WorkV2_SpecLines].SGQuote
																			   and [Custom WorkV2].ID = [Custom WorkV2_SpecLines].NPOID
										 where [Custom WorkV2].SGQuote = @quote and SpecSortSeLine = '-99') as mainsub
									group by SpecSortG, SpecSortSe, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour) as mainsub) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe
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
															else patindex('%[0-9][0-9][0-9] in%', Description) end, len(Description)), Description) end as InchesPosition		from #specs
			where (Description like '% ft.%' and Description not like '%[0-9].[0-9] ft.%')
			or (Description like '% in.%' and Description not like '%[0-9].[0-9] in.%')
	
			--Update lines from options and npos with code -98 (ft. and in. addition)
			update @ftandin
			set Inches = case when b.NetInches is null then a.Inches else a.Inches + b.NetInches end,
			Price = case when b.Price is null then a.Price when a.Price is null then b.Price else a.Price + b.Price end,
			HideShowOptionPriceWording = case when a.HideShowOptionPriceWording = 1 then 1 when b.HideShowOptionPriceWording is null then a.HideShowOptionPriceWording else b.HideShowOptionPriceWording end,
			Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
			Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
			Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
			BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
			FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end,
			Changed = case when b.NetInches is null then 0 else 1 end,
			NPO = case when b.NPOIndicator is null then 0 else b.NPOIndicator end
			from @ftandin as a
			left outer join (select SpecSortG, SpecSortSe, NPOIndicator, NetInches, Price, HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour 
							 from (select SpecSortG, SpecSortSe, NPOIndicator, sum(cast(Inches as int)) as NetInches, sum(Price) as Price, max(HideShowOptionPriceWording) as HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour
								   from (select SpecSortG, SpecSortSe, 0 as NPOIndicator, cast(left(RIGHT(SpecDescription, LEN(SpecDescription) - CHARINDEX('.', SpecDescription)), 2) as int) * Qty as Inches, (case when Line# <> 1 then 0 else Price end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order OptionsV2] with (nolock)
										 inner join [Order OptionsV2_SpecLines] with (nolock) on [Order OptionsV2].SGQuote = [Order OptionsV2_SpecLines].SGQuote
																				 and [Order OptionsV2].ID = [Order OptionsV2_SpecLines].OrderOptionID
										 where [Order OptionsV2].SGQuote = @quote and SpecSortSeLine = '-98') as mainsub
									group by SpecSortG, SpecSortSe, NPOIndicator, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour) as mainsub) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe

			update @ftandin
			set Inches = case when b.NetInches is null then a.Inches else a.Inches + b.NetInches end,
			Price = case when b.Price is null then a.Price when a.Price is null then b.Price else a.Price + b.Price end,
			HideShowOptionPriceWording = case when a.HideShowOptionPriceWording = 1 then 1 when b.HideShowOptionPriceWording is null then a.HideShowOptionPriceWording else b.HideShowOptionPriceWording end,
			Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
			Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
			Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
			BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
			FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end,
			Changed = case when b.NetInches is null and Changed <> 1 then 0 else 1 end,
			NPO = case when b.NPOIndicator is null and NPO <> 1 then 0 else b.NPOIndicator end
			from @ftandin as a
			left outer join (select SpecSortG, SpecSortSe, NPOIndicator, NetInches, Price, HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour 
							 from (select SpecSortG, SpecSortSe, NPOIndicator, sum(cast(Inches as int)) as NetInches, sum(Price) as Price, max(HideShowOptionPriceWording) as HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour
								   from (select SpecSortG, SpecSortSe, 1 as NPOIndicator, cast(left(RIGHT(SpecDescription, LEN(SpecDescription) - CHARINDEX('.', SpecDescription)), 2) as int) * Qty as Inches, (case when Line# <> 1 then 0 else (case when [Quote Date] >= 'january 1 2019' and @USSale = 1 then [US Price] else Price end) end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom WorkV2] with (nolock)
										 inner join [Custom WorkV2_SpecLines] with (nolock) on [Custom WorkV2].SGQuote = [Custom WorkV2_SpecLines].SGQuote
																			   and [Custom WorkV2].ID = [Custom WorkV2_SpecLines].NPOID								 
										 where [Custom WorkV2].SGQuote = @quote and SpecSortSeLine = '-98') as mainsub
									group by SpecSortG, SpecSortSe, NPOIndicator, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour) as mainsub) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe

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
								   from (select SpecSortG, SpecSortSe, 0 as NPOIndicator, cast(LEFT(SpecDescription, CHARINDEX('.',SpecDescription) - 1) as int) * Qty as Feet, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order OptionsV2] with (nolock)
										 inner join [Order OptionsV2_SpecLines] with (nolock) on [Order OptionsV2].SGQuote = [Order OptionsV2_SpecLines].SGQuote
																				 and [Order OptionsV2].ID = [Order OptionsV2_SpecLines].OrderOptionID
										 where [Order OptionsV2].SGQuote = @quote and SpecSortSeLine = '-98') as mainsub
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
								   from (select SpecSortG, SpecSortSe, 1 as NPOIndicator, cast(LEFT(SpecDescription, CHARINDEX('.',SpecDescription) - 1) as int) * Qty as Feet, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom WorkV2] with (nolock)
										 inner join [Custom WorkV2_SpecLines] with (nolock) on [Custom WorkV2].SGQuote = [Custom WorkV2_SpecLines].SGQuote
																			   and [Custom WorkV2].ID = [Custom WorkV2_SpecLines].NPOID	
										 where [Custom WorkV2].SGQuote = @quote and SpecSortSeLine = '-98') as mainsub
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
			set Description = case when b.Feet is null then a.Description --No Feet/Inches additions
								   when b.Feet = 0 then case when NPO = 1 then '*NPO*: ' else '' end + left(Description, b.InchesPosition) + cast(b.Inches as nvarchar) + right(Description, len(Description) - (CHARINDEX('in.', Description) - 2)) --Inches addition only
								   when b.Inches = 0 then case when NPO = 1 then '*NPO*: ' else '' end + left(Description, b.FeetPosition) + cast(b.Feet as nvarchar) + right(Description, len(Description) - (CHARINDEX('ft.', Description) - 2)) --Feet addition only
								   when b.Feet <> 0 and CHARINDEX('in.', Description) = 0 then case when NPO = 1 then '*NPO*: ' else '' end + left(Description, b.FeetPosition) + cast(b.Feet as nvarchar) + ' ft. ' + cast(b.Inches as nvarchar) + ' in. ' 
																							   + right(Description, len(Description) - (len(cast(b.Feet as nvarchar) + ' ft. '))) --Changes ft. to ft. and in.
								   when b.Inches <> 0 and CHARINDEX('ft.', Description) = 0 then case when NPO = 1 then '*NPO*: ' else '' end + left(Description, b.InchesPosition) + cast(b.Feet as nvarchar) + ' ft. ' + cast(b.Inches as nvarchar) + right(Description, len(Description) - (CHARINDEX('in.', Description) - 2)) --Changes in. to ft. and in.
								   else case when NPO = 1 then '*NPO*: ' else '' end + left(Description, b.FeetPosition) + cast(b.Feet as nvarchar) + ' ft. ' + cast(b.Inches as nvarchar) + right(Description, len(Description) - (CHARINDEX('in.', Description) - 2)) end, 
			Price = case when b.Price is null then a.Price when a.Price is null then b.Price else a.Price + b.Price end,
			HideShowOptionPriceWording = case when a.HideShowOptionPriceWording = 1 then 1 when b.HideShowOptionPriceWording is null then a.HideShowOptionPriceWording else b.HideShowOptionPriceWording end,
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
			set Description = case when b.SpecDescription is null then a.Description else a.Description + ' ' + b.SpecDescription end,
			Price = case when b.Price is null then a.Price when a.Price is null then b.Price else a.Price + b.Price end,
			HideShowOptionPriceWording = case when a.HideShowOptionPriceWording = 1 then 1 when b.HideShowOptionPriceWording is null then a.HideShowOptionPriceWording else b.HideShowOptionPriceWording end,
			Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
			Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
			Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
			BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
			FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end
			from #specs as a
			left outer join (select SpecSortG, SpecSortSe, SpecDescription, Price, HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour
							 from (select SpecSortG, SpecSortSe, SpecDescription, (case when Line# <> 1 then 0 else Price end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order OptionsV2] with (nolock)
								   inner join [Order OptionsV2_SpecLines] with (nolock) on [Order OptionsV2].SGQuote = [Order OptionsV2_SpecLines].SGQuote
																		   and [Order OptionsV2].ID = [Order OptionsV2_SpecLines].OrderOptionID
								   where [Order OptionsV2].SGQuote = @quote and SpecSortSeLine = '-97'

								   union all select SpecSortG, SpecSortSe, '*NPO*: ' + SpecDescription, (case when Line# <> 1 then 0 else (case when [Quote Date] >= 'january 1 2019' and @USSale = 1 then [US Price] else Price end) end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom WorkV2] with (nolock)
								   inner join [Custom WorkV2_SpecLines] with (nolock) on [Custom WorkV2].SGQuote = [Custom WorkV2_SpecLines].SGQuote
																		 and [Custom WorkV2].ID = [Custom WorkV2_SpecLines].NPOID
								   where [Custom WorkV2].SGQuote = @quote and SpecSortSeLine = '-97') as mainsub) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe
			where a.SpecSortSeLine = 0

			--delete from specs tv where code from option and npo lines = -96
			delete #specs
			from #specs as a
			inner join (select SpecSortG, SpecSortSe from [Order OptionsV2] with (nolock)
						inner join [Order OptionsV2_SpecLines] with (nolock) on [Order OptionsV2].SGQuote = [Order OptionsV2_SpecLines].SGQuote
																and [Order OptionsV2].ID = [Order OptionsV2_SpecLines].OrderOptionID
						where [Order OptionsV2].SGQuote = @quote and SpecSortSeLine = '-96'

						union all select SpecSortG, SpecSortSe from [Custom WorkV2] with (nolock)
						inner join [Custom WorkV2_SpecLines] with (nolock) on [Custom WorkV2].SGQuote = [Custom WorkV2_SpecLines].SGQuote
															  and [Custom WorkV2].ID = [Custom WorkV2_SpecLines].NPOID
						where [Custom WorkV2].SGQuote = @quote and SpecSortSeLine = '-96') as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe

			--Update lines from options and npos with code -95 (find and replace)
			update #specs
			set Description = case when b.SpecDescription is null then a.Description 
								   else replace(a.Description, 
 												right(left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1), len(left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1)) - charindex('~', left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1))), 
												case when NPOIndicator = 1 then '(*NPO*->) ' else '' end + left(right(b.SpecDescription, len(b.SpecDescription) - (CHARINDEX('.~', b.SpecDescription) + 1)), (len(b.SpecDescription) - (CHARINDEX('.~', b.SpecDescription) + 1)) - 1)) end,
			Price = case when b.Price is null then a.Price when a.Price is null then b.Price else a.Price + b.Price end,
			HideShowOptionPriceWording = case when a.HideShowOptionPriceWording = 1 then 1 when b.HideShowOptionPriceWording is null then a.HideShowOptionPriceWording else b.HideShowOptionPriceWording end,
			Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
			Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
			Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
			BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
			FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end
			from #specs as a
			left outer join (select SpecSortG, SpecSortSe, NPOIndicator, SpecDescription, Price, HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour
							 from (select SpecSortG, SpecSortSe, 0 as NPOIndicator, SpecDescription, (case when Line# <> 1 then 0 else Price end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order OptionsV2] with (nolock)
								   inner join [Order OptionsV2_SpecLines] with (nolock) on [Order OptionsV2].SGQuote = [Order OptionsV2_SpecLines].SGQuote
																		   and [Order OptionsV2].ID = [Order OptionsV2_SpecLines].OrderOptionID
								   where [Order OptionsV2].SGQuote = @quote and SpecSortSeLine = '-95'

								   union all select SpecSortG, SpecSortSe, 1, SpecDescription, (case when Line# <> 1 then 0 else (case when [Quote Date] >= 'january 1 2019' and @USSale = 1 then [US Price] else Price end) end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom WorkV2] with (nolock)
								   inner join [Custom WorkV2_SpecLines] with (nolock) on [Custom WorkV2].SGQuote = [Custom WorkV2_SpecLines].SGQuote
																		 and [Custom WorkV2].ID = [Custom WorkV2_SpecLines].NPOID
								   where [Custom WorkV2].SGQuote = @quote and SpecSortSeLine = '-95') as mainsub) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe
			where a.SpecSortSeLine = 0

			--insert error-handling lines for options and npos with code -95 (find and replace) and no matching address in specs table
			insert into #specs ([SGQuote], SortGv2, [Group], SortSev2, Section, [Description], Price, HideShowOptionPriceWording, Bold, Italic, Underline, BackColour, FontColour)
			select [SGQuote], SpecSortG, SpecGroup, SpecSortSe, SpecSection, 'Spec Address not found, please review Option and NPO Addresses with -95 code', 0, 1, 1, SpecDescriptionItalic, SpecDescriptionUnderline, 'Red', 'Yellow'
			from (select [Order OptionsV2].[SGQuote], SpecSortG, SpecGroup, SpecSortSe, SpecSection, SpecDescription, Price, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order OptionsV2] with (nolock)
				  inner join [Order OptionsV2_SpecLines] with (nolock) on [Order OptionsV2].SGQuote = [Order OptionsV2_SpecLines].SGQuote
														  and [Order OptionsV2].ID = [Order OptionsV2_SpecLines].OrderOptionID
				  where [Order OptionsV2].SGQuote = @quote and SpecSortSeLine = '-95'

				  union all select [Custom WorkV2].[SGQuote], SpecSortG, SpecGroup, SpecSortSe, SpecSection, SpecDescription, (case when [Quote Date] >= 'january 1 2019' and @USSale = 1 then [US Price] else Price end), SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom WorkV2] with (nolock)
				  inner join [Custom WorkV2_SpecLines] with (nolock) on [Custom WorkV2].SGQuote = [Custom WorkV2_SpecLines].SGQuote
														and [Custom WorkV2].ID = [Custom WorkV2_SpecLines].NPOID
				  where [Custom WorkV2].SGQuote = @quote and SpecSortSeLine = '-95') as mainsub
			left outer join (select SortGv2, SortSev2, Description from #specs) as b on mainsub.SpecSortG = b.SortGv2 and mainsub.SpecSortSe = b.SortSev2
			where SortSev2 is null
			and Description is null

			--Update lines from options and npos with code -94 (find and replace - 2nd runthrough)
			update #specs
			set Description = case when b.SpecDescription is null then a.Description 
								   else replace(a.Description, 
 												right(left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1), len(left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1)) - charindex('~', left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1))), 
												case when NPOIndicator = 1 then '(*NPO*->) ' else '' end + left(right(b.SpecDescription, len(b.SpecDescription) - (CHARINDEX('.~', b.SpecDescription) + 1)), (len(b.SpecDescription) - (CHARINDEX('.~', b.SpecDescription) + 1)) - 1)) end,
			Price = case when b.Price is null then a.Price when a.Price is null then b.Price else a.Price + b.Price end,
			HideShowOptionPriceWording = case when a.HideShowOptionPriceWording = 1 then 1 when b.HideShowOptionPriceWording is null then a.HideShowOptionPriceWording else b.HideShowOptionPriceWording end,
			Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
			Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
			Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
			BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
			FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end
			from #specs as a
			left outer join (select SpecSortG, SpecSortSe, NPOIndicator, SpecDescription, Price, HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour
							 from (select SpecSortG, SpecSortSe, 0 as NPOIndicator, SpecDescription, (case when Line# <> 1 then 0 else Price end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order OptionsV2] with (nolock)
								   inner join [Order OptionsV2_SpecLines] with (nolock) on [Order OptionsV2].SGQuote = [Order OptionsV2_SpecLines].SGQuote
																		   and [Order OptionsV2].ID = [Order OptionsV2_SpecLines].OrderOptionID
								   where [Order OptionsV2].SGQuote = @quote and SpecSortSeLine = '-94'

								   union all select SpecSortG, SpecSortSe, 1, SpecDescription, (case when Line# <> 1 then 0 else (case when [Quote Date] >= 'january 1 2019' and @USSale = 1 then [US Price] else Price end) end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom WorkV2] with (nolock)
								   inner join [Custom WorkV2_SpecLines] with (nolock) on [Custom WorkV2].SGQuote = [Custom WorkV2_SpecLines].SGQuote
																		 and [Custom WorkV2].ID = [Custom WorkV2_SpecLines].NPOID
								   where [Custom WorkV2].SGQuote = @quote and SpecSortSeLine = '-94') as mainsub) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe
			where a.SpecSortSeLine = 0

			--insert error-handling lines for options and npos with code -94 (find and replace - 2nd runthrough) and no matching address in specs table
			insert into #specs ([SGQuote], SortGv2, [Group], SortSev2, Section, [Description], Price, HideShowOptionPriceWording, Bold, Italic, Underline, BackColour, FontColour)
			select [SGQuote], SpecSortG, SpecGroup, SpecSortSe, SpecSection, 'Spec Address not found, please review Option and NPO Addresses with -94 code', 0, 1, 1, SpecDescriptionItalic, SpecDescriptionUnderline, 'Red', 'Yellow'
			from (select [Order OptionsV2].[SGQuote], SpecSortG, SpecGroup, SpecSortSe, SpecSection, SpecDescription, Price, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order OptionsV2] with (nolock)
				  inner join [Order OptionsV2_SpecLines] with (nolock) on [Order OptionsV2].SGQuote = [Order OptionsV2_SpecLines].SGQuote
														  and [Order OptionsV2].ID = [Order OptionsV2_SpecLines].OrderOptionID
				  where [Order OptionsV2].SGQuote = @quote and SpecSortSeLine = '-94'

				  union all select [Custom WorkV2].[SGQuote], SpecSortG, SpecGroup, SpecSortSe, SpecSection, SpecDescription, (case when [Quote Date] >= 'january 1 2019' and @USSale = 1 then [US Price] else Price end), SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom WorkV2] with (nolock)
				  inner join [Custom WorkV2_SpecLines] with (nolock) on [Custom WorkV2].SGQuote = [Custom WorkV2_SpecLines].SGQuote
														and [Custom WorkV2].ID = [Custom WorkV2_SpecLines].NPOID
				  where [Custom WorkV2].SGQuote = @quote and SpecSortSeLine = '-94') as mainsub
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
												+ (cast(left(right(b.SpecDescription, len(b.SpecDescription) - (CHARINDEX('.~', b.SpecDescription) + 1)), (len(b.SpecDescription) - (CHARINDEX('.~', b.SpecDescription) + 1)) - 1) as float) * Qty) as nvarchar)) end,
			Price = case when b.Price is null then a.Price when a.Price is null then b.Price else a.Price + b.Price end,
			HideShowOptionPriceWording = case when a.HideShowOptionPriceWording = 1 then 1 when b.HideShowOptionPriceWording is null then a.HideShowOptionPriceWording else b.HideShowOptionPriceWording end,
			Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
			Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
			Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
			BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
			FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end
			from #specs as a
			left outer join (select SpecSortG, SpecSortSe, NPOIndicator, SpecDescription, Qty, Price, HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour
							 from (select SpecSortG, SpecSortSe, 0 as NPOIndicator, SpecDescription, Qty, (case when Line# <> 1 then 0 else Price end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order OptionsV2] with (nolock)
								   inner join [Order OptionsV2_SpecLines] with (nolock) on [Order OptionsV2].SGQuote = [Order OptionsV2_SpecLines].SGQuote
																		   and [Order OptionsV2].ID = [Order OptionsV2_SpecLines].OrderOptionID
								   where [Order OptionsV2].SGQuote = @quote and SpecSortSeLine = '-93'

								   union all select SpecSortG, SpecSortSe, 1, SpecDescription, 1, (case when Line# <> 1 then 0 else (case when [Quote Date] >= 'january 1 2019' and @USSale = 1 then [US Price] else Price end) end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom WorkV2] with (nolock)
								   inner join [Custom WorkV2_SpecLines] with (nolock) on [Custom WorkV2].SGQuote = [Custom WorkV2_SpecLines].SGQuote
																		 and [Custom WorkV2].ID = [Custom WorkV2_SpecLines].NPOID
								   where [Custom WorkV2].SGQuote = @quote and SpecSortSeLine = '-93') as mainsub) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe
			where a.SpecSortSeLine = 0

			--insert error-handling lines for options and npos with code -93 (find int value and "replace" with initial and specified int values added together - i.e. ~10~.~2~ will find 10 and replace it with 12) and no matching address in specs table
			insert into #specs ([SGQuote], SortGv2, [Group], SortSev2, Section, [Description], Price, HideShowOptionPriceWording, Bold, Italic, Underline, BackColour, FontColour)
			select [SGQuote], SpecSortG, SpecGroup, SpecSortSe, SpecSection, 'Spec Address not found, please review Option and NPO Addresses with -93 code', 0, 1, 1, SpecDescriptionItalic, SpecDescriptionUnderline, 'Red', 'Yellow'
			from (select [Order OptionsV2].[SGQuote], SpecSortG, SpecGroup, SpecSortSe, SpecSection, SpecDescription, Price, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order OptionsV2] with (nolock)
				  inner join [Order OptionsV2_SpecLines] with (nolock) on [Order OptionsV2].SGQuote = [Order OptionsV2_SpecLines].SGQuote
														  and [Order OptionsV2].ID = [Order OptionsV2_SpecLines].OrderOptionID
				  where [Order OptionsV2].SGQuote = @quote and SpecSortSeLine = '-93'

				  union all select [Custom WorkV2].[SGQuote], SpecSortG, SpecGroup, SpecSortSe, SpecSection, SpecDescription, (case when [Quote Date] >= 'january 1 2019' and @USSale = 1 then [US Price] else Price end), SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom WorkV2] with (nolock)
				  inner join [Custom WorkV2_SpecLines] with (nolock) on [Custom WorkV2].SGQuote = [Custom WorkV2_SpecLines].SGQuote
														and [Custom WorkV2].ID = [Custom WorkV2_SpecLines].NPOID
				  where [Custom WorkV2].SGQuote = @quote and SpecSortSeLine = '-93') as mainsub
			left outer join (select SortGv2, SortSev2, Description from #specs) as b on mainsub.SpecSortG = b.SortGv2 and mainsub.SpecSortSe = b.SortSev2
			where SortSev2 is null
			and Description is null

			--Update lines from options and npos with code -92 (find and replace - purge spec line with "find" value, add "replace" value to "find" value)
			update #specs
			set Description = case when b.SpecDescription is null then a.Description 
								   else case when NPOIndicator = 1 then '(*NPO*->) ' else '' end 
										+ cast(cast(right(left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1), len(left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1)) - charindex('~', left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1))) as float) 
										+ (cast(left(right(b.SpecDescription, len(b.SpecDescription) - (CHARINDEX('.~', b.SpecDescription) + 1)), (len(b.SpecDescription) - (CHARINDEX('.~', b.SpecDescription) + 1)) - 1) as float) * Qty) as nvarchar) end,
			Price = case when b.Price is null then a.Price when a.Price is null then b.Price else a.Price + b.Price end,
			HideShowOptionPriceWording = case when a.HideShowOptionPriceWording = 1 then 1 when b.HideShowOptionPriceWording is null then a.HideShowOptionPriceWording else b.HideShowOptionPriceWording end,
			Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
			Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
			Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
			BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
			FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end
			from #specs as a
			left outer join (select SpecSortG, SpecSortSe, NPOIndicator, SpecDescription, Qty, Price, HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour
							 from (select SpecSortG, SpecSortSe, 0 as NPOIndicator, SpecDescription, Qty, (case when Line# <> 1 then 0 else Price end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order OptionsV2] with (nolock)
								   inner join [Order OptionsV2_SpecLines] with (nolock) on [Order OptionsV2].SGQuote = [Order OptionsV2_SpecLines].SGQuote
																		   and [Order OptionsV2].ID = [Order OptionsV2_SpecLines].OrderOptionID
								   where [Order OptionsV2].SGQuote = @quote and SpecSortSeLine = '-92'

								   union all select SpecSortG, SpecSortSe, 1, SpecDescription, 1, (case when Line# <> 1 then 0 else (case when [Quote Date] >= 'january 1 2019' and @USSale = 1 then [US Price] else Price end) end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom WorkV2] with (nolock)
								   inner join [Custom WorkV2_SpecLines] with (nolock) on [Custom WorkV2].SGQuote = [Custom WorkV2_SpecLines].SGQuote
																		 and [Custom WorkV2].ID = [Custom WorkV2_SpecLines].NPOID
								   where [Custom WorkV2].SGQuote = @quote and SpecSortSeLine = '-92') as mainsub) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe
			where a.SpecSortSeLine = 0

			--insert error-handling lines for options and npos with code -92 (find and replace - purge spec line with "find" value, add "replace" value to "find" value) and no matching address in specs table
			insert into #specs ([SGQuote], SortGv2, [Group], SortSev2, Section, [Description], Price, HideShowOptionPriceWording, Bold, Italic, Underline, BackColour, FontColour)
			select [SGQuote], SpecSortG, SpecGroup, SpecSortSe, SpecSection, 'Spec Address not found, please review Option and NPO Addresses with -92 code', 0, 1, 1, SpecDescriptionItalic, SpecDescriptionUnderline, 'Red', 'Yellow'
			from (select [Order OptionsV2].[SGQuote], SpecSortG, SpecGroup, SpecSortSe, SpecSection, SpecDescription, Price, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order OptionsV2] with (nolock)
				  inner join [Order OptionsV2_SpecLines] with (nolock) on [Order OptionsV2].SGQuote = [Order OptionsV2_SpecLines].SGQuote
														  and [Order OptionsV2].ID = [Order OptionsV2_SpecLines].OrderOptionID
				  where [Order OptionsV2].SGQuote = @quote and SpecSortSeLine = '-92'

				  union all select [Custom WorkV2].[SGQuote], SpecSortG, SpecGroup, SpecSortSe, SpecSection, SpecDescription, (case when [Quote Date] >= 'january 1 2019' and @USSale = 1 then [US Price] else Price end), SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom WorkV2] with (nolock)
				  inner join [Custom WorkV2_SpecLines] with (nolock) on [Custom WorkV2].SGQuote = [Custom WorkV2_SpecLines].SGQuote
														and [Custom WorkV2].ID = [Custom WorkV2_SpecLines].NPOID
				  where [Custom WorkV2].SGQuote = @quote and SpecSortSeLine = '-92') as mainsub
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
			set Inches = case when b.NetInches is null then a.Inches else a.Inches + b.NetInches end,
			Price = case when b.Price is null then a.Price when a.Price is null then b.Price else a.Price + b.Price end,
			HideShowOptionPriceWording = case when a.HideShowOptionPriceWording = 1 then 1 when b.HideShowOptionPriceWording is null then a.HideShowOptionPriceWording else b.HideShowOptionPriceWording end,
			Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
			Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
			Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
			BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
			FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end,
			Changed = case when b.NetInches is null then 0 else 1 end,
			NPO = case when b.NPOIndicator is null then 0 else b.NPOIndicator end
			from @ftandin as a
			left outer join (select SpecSortG, SpecSortSe, NPOIndicator, NetInches, Price, HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour 
							 from (select SpecSortG, SpecSortSe, NPOIndicator, sum(cast(Inches as int)) as NetInches, sum(Price) as Price, max(HideShowOptionPriceWording) as HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour
								   from (select SpecSortG, SpecSortSe, 0 as NPOIndicator, cast(right(left(SpecDescription, CHARINDEX('~', SpecDescription) - 1), charindex('.', SpecDescription) - 1) as int) * Qty as Inches, (case when Line# <> 1 then 0 else Price end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order OptionsV2] with (nolock)
										 inner join [Order OptionsV2_SpecLines] with (nolock) on [Order OptionsV2].SGQuote = [Order OptionsV2_SpecLines].SGQuote
																				 and [Order OptionsV2].ID = [Order OptionsV2_SpecLines].OrderOptionID
										 where [Order OptionsV2].SGQuote = @quote and SpecSortSeLine = '-91'

										 union all select SpecSortG, SpecSortSe, 1, cast(right(left(SpecDescription, CHARINDEX('~', SpecDescription) - 1), charindex('.', SpecDescription) - 1) as int) * Qty as Inches, (case when Line# <> 1 then 0 else (case when [Quote Date] >= 'january 1 2019' and @USSale = 1 then [US Price] else Price end) end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom WorkV2] with (nolock)
										 inner join [Custom WorkV2_SpecLines] with (nolock) on [Custom WorkV2].SGQuote = [Custom WorkV2_SpecLines].SGQuote
																			   and [Custom WorkV2].ID = [Custom WorkV2_SpecLines].NPOID								 
										 where [Custom WorkV2].SGQuote = @quote and SpecSortSeLine = '-91') as mainsub
									group by SpecSortG, SpecSortSe, NPOIndicator, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour) as mainsub) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe
	
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
								   from (select SpecSortG, SpecSortSe, 0 as NPOIndicator, cast(LEFT(SpecDescription, CHARINDEX('.',SpecDescription) - 1) as int) * Qty as Feet, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order OptionsV2] with (nolock)
										 inner join [Order OptionsV2_SpecLines] with (nolock) on [Order OptionsV2].SGQuote = [Order OptionsV2_SpecLines].SGQuote
																				 and [Order OptionsV2].ID = [Order OptionsV2_SpecLines].OrderOptionID
										 where [Order OptionsV2].SGQuote = @quote and SpecSortSeLine = '-91'

										 union all select SpecSortG, SpecSortSe, 1, cast(LEFT(SpecDescription, CHARINDEX('.',SpecDescription) - 1) as int) * Qty as Feet, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom WorkV2] with (nolock)
										 inner join [Custom WorkV2_SpecLines] with (nolock) on [Custom WorkV2].SGQuote = [Custom WorkV2_SpecLines].SGQuote
																			   and [Custom WorkV2].ID = [Custom WorkV2_SpecLines].NPOID	
										 where [Custom WorkV2].SGQuote = @quote and SpecSortSeLine = '-91') as mainsub
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
						from [Order OptionsV2_SpecLines] with (nolock)
						where [Order OptionsV2_SpecLines].SGQuote = @quote and SpecSortSeLine = '-91'

						union all select SpecSortG, SpecSortSe,
						left(right(SpecDescription, charindex('~', SpecDescription) + 1), charindex('.', right(SpecDescription, charindex('~', SpecDescription) + 1)) - 1),
						left(right(SpecDescription, len(SpecDescription) - charindex('.', SpecDescription, charindex('.', SpecDescription) + 1)),
							 CHARINDEX('~', right(SpecDescription, len(SpecDescription) - charindex('.', SpecDescription, charindex('.', SpecDescription) + 1))) - 1)
						from [Custom WorkV2_SpecLines] with (nolock)
						where [Custom WorkV2_SpecLines].SGQuote = @quote and SpecSortSeLine = '-91') as b on a.SortGv2 = b.SpecSortG
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
			set Description = case when b.Feet is null then a.Description --No Feet/Inches additions
								   when b.Feet = 0 then case when NPO = 1 then '*NPO*: ' else '' end + left(Description, b.InchesPosition) + cast(b.Inches as nvarchar) + right(Description, len(Description) - (CHARINDEX('in.', Description) - 2)) --Inches addition only
								   when b.Inches = 0 and InchesPosition = 0 then case when NPO = 1 then '*NPO*: ' else '' end + left(Description, case when Description like '*NPO*:%' then b.FeetPosition - 1 else b.FeetPosition end) + cast(b.Feet as nvarchar) + right(Description, len(Description) - (CHARINDEX('ft.', Description) - 2)) --Feet addition only
								   when b.Feet <> 0 and CHARINDEX('in.', Description) = 0 then case when NPO = 1 then '*NPO*: ' else '' end + left(Description, case when Description like '*NPO*:%' then b.FeetPosition - 1 else b.FeetPosition end) + cast(b.Feet as nvarchar) + ' ft. ' + cast(b.Inches as nvarchar) + ' in. ' 
																							   + right(Description, len(Description) - (len(cast(b.Feet as nvarchar) + ' ft. '))) --Changes ft. to ft. and in.
								   when b.Inches <> 0 and CHARINDEX('ft.', Description) = 0 then case when NPO = 1 then '*NPO*: ' else '' end + left(Description, b.InchesPosition) + cast(b.Feet as nvarchar) + ' ft. ' + cast(b.Inches as nvarchar) + right(Description, len(Description) - (CHARINDEX('in.', Description) - 2)) --Changes in. to ft. and in.
								   else case when NPO = 1 then '*NPO*: ' else '' end + left(Description, case when Description like '*NPO*:%' then b.FeetPosition - 1 else b.FeetPosition end) + cast(b.Feet as nvarchar) + ' ft. ' + cast(b.Inches as nvarchar) + right(Description, len(Description) - (CHARINDEX('in.', Description) - 2)) end, 
			Price = case when b.Price is null then a.Price when a.Price is null then b.Price else a.Price + b.Price end,
			HideShowOptionPriceWording = case when a.HideShowOptionPriceWording = 1 then 1 when b.HideShowOptionPriceWording is null then a.HideShowOptionPriceWording else b.HideShowOptionPriceWording end,
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
			IF OBJECT_ID('tempdb..#t') IS NOT NULL
				DROP TABLE #t  
	
			--Grab Option and NPO Spec Line Descriptions for Code -90
			select SpecDescription as img into #t
			from [Order OptionsV2] with (nolock)
			inner join [Order OptionsV2_SpecLines] with (nolock) on [Order OptionsV2].SGQuote = [Order OptionsV2_SpecLines].SGQuote
													and [Order OptionsV2].ID = [Order OptionsV2_SpecLines].OrderOptionID
			where [Order OptionsV2].SGQuote = @quote and SpecSortSeLine = '-90'

			union all select SpecDescription
			from [Custom WorkV2] with (nolock)
			inner join [Custom WorkV2_SpecLines] with (nolock) on [Custom WorkV2].SGQuote = [Custom WorkV2_SpecLines].SGQuote
													and [Custom WorkV2].ID = [Custom WorkV2_SpecLines].NPOID
			where [Custom WorkV2].SGQuote = @quote and SpecSortSeLine = '-90'

			--Using Common Table Expressions and table variables, insert and sort the arrays by the table variable ID
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
			set Description = token,
			Price = case when b.Price is null then a.Price when a.Price is null then b.Price else a.Price + b.Price end,
			HideShowOptionPriceWording = case when a.HideShowOptionPriceWording = 1 then 1 when b.HideShowOptionPriceWording is null then a.HideShowOptionPriceWording else b.HideShowOptionPriceWording end
			from #specs as a
			inner join (select [Order OptionsV2_SpecLines].SpecSortG, [Order OptionsV2_SpecLines].SpecSortSe, FirstLine,
						token, case when Line# <> 1 then 0 else Price * Qty end as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording
						from [Order OptionsV2]
						inner join [Order OptionsV2_SpecLines] on [Order OptionsV2].SGQuote = [Order OptionsV2_SpecLines].SGQuote
																and [Order OptionsV2].[Option No] = [Order OptionsV2_SpecLines].[Option No]
																and [Order OptionsV2].Description = [Order OptionsV2_SpecLines].Description
						inner join (select SpecSortG, SpecSortSe,
									min(case when SpecSortSeLine < 0 then 0 else SpecSortSeLine end) as FirstLine 
									from [Order OptionsV2_SpecLines]
									where SGQuote = @quote
									group by SpecSortG, SpecSortSe) as subFirstLine on [Order OptionsV2_SpecLines].SpecSortG = subFirstLine.SpecSortG
																					   and [Order OptionsV2_SpecLines].SpecSortSe = subFirstLine.SpecSortSe		
						inner join @t as a on [Order OptionsV2].Qty = a.ID
											  and [Order OptionsV2_SpecLines].SpecDescription = a.Description
						where [Order OptionsV2].SGQuote = @quote and SpecSortSeLine = '-90'

						union all select [Custom WorkV2_SpecLines].SpecSortG, [Custom WorkV2_SpecLines].SpecSortSe, FirstLine, 
						token, case when Line# <> 1 then 0 else (case when [Quote Date] >= 'january 1 2019' and @USSale = 1 then [US Price] * Qty else Price * Qty end) end,
						case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording
						from [Custom WorkV2]
						inner join [Custom WorkV2_SpecLines] on [Custom WorkV2].SGQuote = [Custom WorkV2_SpecLines].SGQuote
																and [Custom WorkV2].Description = [Custom WorkV2_SpecLines].Description
						inner join (select SpecSortG, SpecSortSe,
									min(case when SpecSortSeLine < 0 then 0 else SpecSortSeLine end) as FirstLine 
									from [Custom WorkV2_SpecLines]
									where SGQuote = @quote
									group by SpecSortG, SpecSortSe) as subFirstLine on [Custom WorkV2_SpecLines].SpecSortG = subFirstLine.SpecSortG
																					   and [Custom WorkV2_SpecLines].SpecSortSe = subFirstLine.SpecSortSe
						inner join @t as a on [Custom WorkV2].Qty = a.ID
											  and [Custom WorkV2_SpecLines].SpecDescription = a.Description
						where [Custom WorkV2].SGQuote = @quote and SpecSortSeLine = '-90') as b on a.SortGv2 = b.SpecSortG
																								and a.SortSev2 = b.SpecSortSe
																								and a.SpecSortSeLine = b.FirstLine




























	delete from @t
	WHERE 1=1
					
	--Code -88 - infinite find and replace array (minics code 0)
			--Drop and create temp table in tmpdb SQL database for faster processing
			--Code reference: http://stackoverflow.com/questions/8726111/sql-server-find-nth-occurrence-in-a-string
			IF OBJECT_ID('tempdb..#t1') IS NOT NULL
				DROP TABLE #t1  
	
			--Grab Option and NPO Spec Line Descriptions for Code -88
			select SpecDescription as img into #t1
			from [Order OptionsV2] with (nolock)
			inner join [Order OptionsV2_SpecLines] with (nolock) on [Order OptionsV2].SGQuote = [Order OptionsV2_SpecLines].SGQuote
													and [Order OptionsV2].ID = [Order OptionsV2_SpecLines].OrderOptionID
			where [Order OptionsV2].SGQuote = @quote and SpecSortSeLine = '-88'

			union all select SpecDescription
			from [Custom WorkV2] with (nolock)
			inner join [Custom WorkV2_SpecLines] with (nolock) on [Custom WorkV2].SGQuote = [Custom WorkV2_SpecLines].SGQuote
													and [Custom WorkV2].ID = [Custom WorkV2_SpecLines].NPOID
			where [Custom WorkV2].SGQuote = @quote and SpecSortSeLine = '-88'

			--Using Common Table Expressions and table variables, insert and sort the arrays by the table variable ID
			;with T(img, starts, pos) as (
				select img, 1, charindex('~', img) from #t1
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



			--SELECT * FROM #specs
			--SELECT * FROM @t
			--end
			declare @new_description NVARCHAR(MAX);






			--VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV










			
			--Update lines from options and npos with code -88 (ft. and in. addition)
			update @ftandin
			set Inches = case when b.NetInches is null then a.Inches else a.Inches + b.NetInches end,
			Price = case when b.Price is null then a.Price when a.Price is null then b.Price else a.Price + b.Price end,
			HideShowOptionPriceWording = case when a.HideShowOptionPriceWording = 1 then 1 when b.HideShowOptionPriceWording is null then a.HideShowOptionPriceWording else b.HideShowOptionPriceWording end,
			Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
			Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
			Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
			BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
			FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end,
			Changed = case when b.NetInches is null then 0 else 1 end,
			NPO = case when b.NPOIndicator is null then 0 else b.NPOIndicator end
			from @ftandin as a
			left outer join (select SpecSortG, SpecSortSe, NPOIndicator, NetInches, Price, HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour 
							 from (select SpecSortG, SpecSortSe, NPOIndicator, sum(cast(Inches as int)) as NetInches, sum(Price) as Price, max(HideShowOptionPriceWording) as HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour
								   from (select SpecSortG, SpecSortSe, 0 as NPOIndicator, cast(left(RIGHT(REPLACE(REPLACE(SpecDescription, '~.~', ' '), '~', ''), LEN(REPLACE(REPLACE(SpecDescription, '~.~', ' '), '~', '')) - CHARINDEX('.', REPLACE(REPLACE(SpecDescription, '~.~', ' '), '~', ''))), 2) as int) * Qty as Inches, (case when Line# <> 1 then 0 else Price end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order OptionsV2] with (nolock)
										 inner join [Order OptionsV2_SpecLines] with (nolock) on [Order OptionsV2].SGQuote = [Order OptionsV2_SpecLines].SGQuote
																				 and [Order OptionsV2].ID = [Order OptionsV2_SpecLines].OrderOptionID
										 where [Order OptionsV2].SGQuote = @quote and SpecSortSeLine = '-88') as mainsub
									group by SpecSortG, SpecSortSe, NPOIndicator, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour) as mainsub) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe

			update @ftandin
			set Inches = case when b.NetInches is null then a.Inches else a.Inches + b.NetInches end,
			Price = case when b.Price is null then a.Price when a.Price is null then b.Price else a.Price + b.Price end,
			HideShowOptionPriceWording = case when a.HideShowOptionPriceWording = 1 then 1 when b.HideShowOptionPriceWording is null then a.HideShowOptionPriceWording else b.HideShowOptionPriceWording end,
			Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
			Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
			Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
			BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
			FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end,
			Changed = case when b.NetInches is null and Changed <> 1 then 0 else 1 end,
			NPO = case when b.NPOIndicator is null and NPO <> 1 then 0 else b.NPOIndicator end
			from @ftandin as a
			left outer join (select SpecSortG, SpecSortSe, NPOIndicator, NetInches, Price, HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour 
							 from (select SpecSortG, SpecSortSe, NPOIndicator, sum(cast(Inches as int)) as NetInches, sum(Price) as Price, max(HideShowOptionPriceWording) as HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour
								   from (select SpecSortG, SpecSortSe, 1 as NPOIndicator, cast(left(RIGHT(REPLACE(REPLACE(SpecDescription, '~.~', ' '), '~', ''), LEN(REPLACE(REPLACE(SpecDescription, '~.~', ' '), '~', '')) - CHARINDEX('.', REPLACE(REPLACE(SpecDescription, '~.~', ' '), '~', ''))), 2) as int) * Qty as Inches, (case when Line# <> 1 then 0 else (case when [Quote Date] >= 'january 1 2019' and @USSale = 1 then [US Price] else Price end) end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom WorkV2] with (nolock)
										 inner join [Custom WorkV2_SpecLines] with (nolock) on [Custom WorkV2].SGQuote = [Custom WorkV2_SpecLines].SGQuote
																			   and [Custom WorkV2].ID = [Custom WorkV2_SpecLines].NPOID								 
										 where [Custom WorkV2].SGQuote = @quote and SpecSortSeLine = '-88') as mainsub
									group by SpecSortG, SpecSortSe, NPOIndicator, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour) as mainsub) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe

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
	
			--Update lines from options and npos with code -88 (ft. addition only)
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
								   from (select SpecSortG, SpecSortSe, 0 as NPOIndicator, cast(LEFT(REPLACE(REPLACE(SpecDescription, '~.~', ' '), '~', ''), CHARINDEX('.',REPLACE(REPLACE(SpecDescription, '~.~', ' '), '~', '')) - 1) as int) * Qty as Feet, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order OptionsV2] with (nolock)
										 inner join [Order OptionsV2_SpecLines] with (nolock) on [Order OptionsV2].SGQuote = [Order OptionsV2_SpecLines].SGQuote
																				 and [Order OptionsV2].ID = [Order OptionsV2_SpecLines].OrderOptionID
										 where [Order OptionsV2].SGQuote = @quote and SpecSortSeLine = '-88') as mainsub
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
								   from (select SpecSortG, SpecSortSe, 1 as NPOIndicator, cast(LEFT(REPLACE(REPLACE(SpecDescription, '~.~', ' '), '~', ''), CHARINDEX('.',REPLACE(REPLACE(SpecDescription, '~.~', ' '), '~', '')) - 1) as int) * Qty as Feet, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom WorkV2] with (nolock)
										 inner join [Custom WorkV2_SpecLines] with (nolock) on [Custom WorkV2].SGQuote = [Custom WorkV2_SpecLines].SGQuote
																			   and [Custom WorkV2].ID = [Custom WorkV2_SpecLines].NPOID	
										 where [Custom WorkV2].SGQuote = @quote and SpecSortSeLine = '-88') as mainsub
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
	
			--SELECT * FROM @ftandin
	
			--Update @specs tv with lines from @ftandin tv
			SELECT @new_description = case when b.Feet is null then a.Description --No Feet/Inches additions
								   when b.Feet = 0 then case when NPO = 1 then '*NPO*: ' else '' end + left(Description, b.InchesPosition) + cast(b.Inches as nvarchar) + right(Description, len(Description) - (CHARINDEX('in.', Description) - 2)) --Inches addition only
								   when b.Inches = 0 then case when NPO = 1 then '*NPO*: ' else '' end + left(Description, b.FeetPosition) + cast(b.Feet as nvarchar) + right(Description, len(Description) - (CHARINDEX('ft.', Description) - 2)) --Feet addition only
								   when b.Feet <> 0 and CHARINDEX('in.', Description) = 0 then case when NPO = 1 then '*NPO*: ' else '' end + left(Description, b.FeetPosition) + cast(b.Feet as nvarchar) + ' ft. ' + cast(b.Inches as nvarchar) + ' in. ' 
																							   + right(Description, len(Description) - (len(cast(b.Feet as nvarchar) + ' ft. '))) --Changes ft. to ft. and in.
								   when b.Inches <> 0 and CHARINDEX('ft.', Description) = 0 then case when NPO = 1 then '*NPO*: ' else '' end + left(Description, b.InchesPosition) + cast(b.Feet as nvarchar) + ' ft. ' + cast(b.Inches as nvarchar) + right(Description, len(Description) - (CHARINDEX('in.', Description) - 2)) --Changes in. to ft. and in.
								   else case when NPO = 1 then '*NPO*: ' else '' end + left(Description, b.FeetPosition) + cast(b.Feet as nvarchar) + ' ft. ' + cast(b.Inches as nvarchar) + right(Description, len(Description) - (CHARINDEX('in.', Description) - 2)) end
			from #specs as a
			inner join @ftandin as b on a.SortGv2 = b.SortGv2 and a.SortSev2 = b.SortSev2
			where Changed = 1


			--Update @specs tv with lines from @ftandin tv
			update #specs
			set Description = case when b.Feet is null then a.Description --No Feet/Inches additions
								   when b.Feet = 0 then case when NPO = 1 then '*NPO*: ' else '' end + left(Description, b.InchesPosition) + cast(b.Inches as nvarchar) + right(Description, len(Description) - (CHARINDEX('in.', Description) - 2)) --Inches addition only
								   when b.Inches = 0 then case when NPO = 1 then '*NPO*: ' else '' end + left(Description, b.FeetPosition) + cast(b.Feet as nvarchar) + right(Description, len(Description) - (CHARINDEX('ft.', Description) - 2)) --Feet addition only
								   when b.Feet <> 0 and CHARINDEX('in.', Description) = 0 then case when NPO = 1 then '*NPO*: ' else '' end + left(Description, b.FeetPosition) + cast(b.Feet as nvarchar) + ' ft. ' + cast(b.Inches as nvarchar) + ' in. ' 
																							   + right(Description, len(Description) - (len(cast(b.Feet as nvarchar) + ' ft. '))) --Changes ft. to ft. and in.
								   when b.Inches <> 0 and CHARINDEX('ft.', Description) = 0 then case when NPO = 1 then '*NPO*: ' else '' end + left(Description, b.InchesPosition) + cast(b.Feet as nvarchar) + ' ft. ' + cast(b.Inches as nvarchar) + right(Description, len(Description) - (CHARINDEX('in.', Description) - 2)) --Changes in. to ft. and in.
								   else case when NPO = 1 then '*NPO*: ' else '' end + left(Description, b.FeetPosition) + cast(b.Feet as nvarchar) + ' ft. ' + cast(b.Inches as nvarchar) + right(Description, len(Description) - (CHARINDEX('in.', Description) - 2)) end, 
			Price = case when b.Price is null then a.Price when a.Price is null then b.Price else a.Price + b.Price end,
			HideShowOptionPriceWording = case when a.HideShowOptionPriceWording = 1 then 1 when b.HideShowOptionPriceWording is null then a.HideShowOptionPriceWording else b.HideShowOptionPriceWording end,
			Bold = b.Bold,
			Italic = b.Italic,
			Underline = b.Underline,
			BackColour = b.BackColour,
			FontColour = b.FontColour
			from #specs as a
			inner join @ftandin as b on a.SortGv2 = b.SortGv2 and a.SortSev2 = b.SortSev2
			where Changed = 1

			--print 'new description: '
			--print 'new description ' + @new_description
			--print 'new description'






			SELECT 'A' AS [HERE], * FROM #specs
			WHERE [Group] = 'TRAILER'

			DECLARE @s_oal AS NVARCHAR(MAX);