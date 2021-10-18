USE [BWSdb]
GO
--/****** Object:  StoredProcedure [dbo].[sp_NewQuoteReport]    Script Date: 2021-10-18 3:59:10 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
---- =============================================
---- Author:		<Author,,Name>
---- Create date: <Create Date,,>
---- Description:	<Description,,>
---- =============================================
--ALTER PROCEDURE [dbo].[sp_NewQuoteReport] 
	-- Add the parameters for the stored procedure here
	declare @quote int
SET @quote = 17386
--with recompile
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
		[Quote#] int,
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

	--Determine if order is Canadian or American
	declare @USSale bit = 0

	select @USSale = [US Sale]
	from Orders with (nolock)
	where Quote# = @quote
	
	--Ensure Order Options and Custom Work table links are up-to-date
	--Update missing OrderOptionID values
	update [Order Options_SpecLines]
	set OrderOptionID = [Order Options].ID
	from [Order Options_SpecLines]
	inner join [Order Options] on [Order Options_SpecLines].Quote# = [Order Options].Quote#
								  and [Order Options_SpecLines].[Option No] = [Order Options].[Option No]
								  and [Order Options_SpecLines].Description = [Order Options].Description
    where [Order Options_SpecLines].Quote# = @quote

	--Update missing Option No and Description values
	update [Order Options_SpecLines]
	set [Option No] = [Order Options].[Option No],
		Description = [Order Options].Description
	from [Order Options_SpecLines]
	inner join [Order Options] on [Order Options_SpecLines].Quote# = [Order Options].Quote#
								  and [Order Options_SpecLines].OrderOptionID = [Order Options].ID
    where [Order Options_SpecLines].Quote# = @quote

	--Update missing NPOID values
	update [Custom Work_SpecLines]
	set NPOID = [Custom Work].ID
	from [Custom Work_SpecLines]
	inner join [Custom Work] on [Custom Work_SpecLines].Quote# = [Custom Work].Quote#
								and [Custom Work_SpecLines].Description = [Custom Work].Description
    where [Custom Work_SpecLines].Quote# = @quote

	--Update missing Description values
	update [Custom Work_SpecLines]
	set Description = [Custom Work].Description
	from [Custom Work_SpecLines]
	inner join [Custom Work] on [Custom Work_SpecLines].Quote# = [Custom Work].Quote#
								and [Custom Work_SpecLines].NPOID = [Custom Work].ID
    where [Custom Work_SpecLines].Quote# = @quote

	--Insert specs for model into tv
	insert into #specs ([Quote#], [Group], SortGv2, Section, SortSev2, Description)
	select [Quote#], [Group], SortGv2, Section, SortSev2, Description from [Order Standards]
	where [Quote#] = @quote
	
	--Insert lines from options into tv with replace code >= 1
	insert into #specs ([Quote#], [Group], SortGv2, Section, SortSev2, SpecSortSeLine, Description, Price, HideShowOptionPriceWording, Bold, Italic, Underline, BackColour, FontColour)
	select [Quote#], SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, OptionD, Price, HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour 
	from (select [Order Options].[Quote#], SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, case when Qty > 1 then convert(nvarchar, Qty) + ', ' + SpecDescription else SpecDescription end as OptionD, 
		  (case when Line# <> 1 then 0 else Price end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording,
		  SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order Options]
		  inner join [Order Options_SpecLines] on [Order Options].Quote# = [Order Options_SpecLines].Quote#
		                                          and [Order Options].[Option No] = [Order Options_SpecLines].[Option No]
												  and [Order Options].Description = [Order Options_SpecLines].Description
		  where [Order Options].[Quote#] = @quote and SpecSortG is not null and SpecSortSeLine >= 1) as mainsub
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
	inner join (select [Quote#], SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, OptionD, Price, HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour 
				from (select [Order Options].[Quote#], SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, 
					  case when Qty > 1 then convert(nvarchar, Qty) + ', ' + SpecDescription else SpecDescription end as OptionD, 
					  (case when Line# <> 1 then 0 else Price end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording,
					  SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order Options] 
				      inner join [Order Options_SpecLines] on [Order Options].Quote# = [Order Options_SpecLines].Quote#
		                                                      and [Order Options].[Option No] = [Order Options_SpecLines].[Option No]
										                      and [Order Options].Description = [Order Options_SpecLines].Description
					  where [Order Options].[Quote#] = @quote and SpecSortG is not null and SpecSortSeLine = 0) as mainsub) as b on a.[Quote#] = b.[Quote#] and a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe and a.SpecSortSeLine = b.SpecSortSeLine
    
	--Insert lines from options with replace code >= 0 and are non-existant in specs tv
	insert into #specs ([Quote#], [Group], SortGv2, Section, SortSev2, SpecSortSeLine, Description, Price, HideShowOptionPriceWording, Bold, Italic, Underline, BackColour, FontColour)
	select [Quote#], SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, OptionD, Price, HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour 
	from (select [Order Options].[Quote#], SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, case when Qty > 1 then convert(nvarchar, Qty) + ', ' + SpecDescription else SpecDescription end as OptionD, 
		  (case when Line# <> 1 then 0 else Price end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording,
		  SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order Options] 
		  inner join [Order Options_SpecLines] on [Order Options].Quote# = [Order Options_SpecLines].Quote#
		                                          and [Order Options].[Option No] = [Order Options_SpecLines].[Option No]
												  and [Order Options].Description = [Order Options_SpecLines].Description
		  where [Order Options].[Quote#] = @quote and SpecSortG is not null and SpecSortSeLine >= 0) as mainsub
	left outer join (select SortGv2, SortSev2, Description from #specs) as b on mainsub.SpecSortG = b.SortGv2 and mainsub.SpecSortSe = b.SortSev2 and mainsub.OptionD = b.Description
	where SortSev2 is null
	and Description is null
	
	--Insert lines from npos with replace code >= 1
	insert into #specs ([Quote#], [Group], SortGv2, Section, SortSev2, SpecSortSeLine, Description, Price, HideShowOptionPriceWording, Bold, Italic, Underline, BackColour, FontColour)
	select [Quote#], SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, NPOD, Price, HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour
	from (select [Custom Work].[Quote#], SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, '*NPO*: ' + case when Qty > 1 then convert(nvarchar, Qty) + ', ' + SpecDescription else SpecDescription end as NPOD, 
		  (case when Line# <> 1 then 0 else (case when [Quote Date] >= 'january 1 2019' and @USSale = 1 then [US Price] else Price end) end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording,
		  SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom Work]
		  inner join [Custom Work_SpecLines] on [Custom Work].Quote# = [Custom Work_SpecLines].Quote#
												  and [Custom Work].Description = [Custom Work_SpecLines].Description
		  where [Custom Work].[Quote#] = @quote and SpecSortG is not null and SpecSortSeLine >= 1) as mainsub
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
	inner join (select [Quote#], SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, NPOD, Price, HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour
				from (select [Custom Work].[Quote#], SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, '*NPO*: ' + case when Qty > 1 then convert(nvarchar, Qty) + ', ' + SpecDescription else SpecDescription end as NPOD, 
					  (case when Line# <> 1 then 0 else (case when [Quote Date] >= 'january 1 2019' and @USSale = 1 then [US Price] else Price end) end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording,
					  SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom Work]
					  inner join [Custom Work_SpecLines] on [Custom Work].Quote# = [Custom Work_SpecLines].Quote#
															and [Custom Work].Description = [Custom Work_SpecLines].Description
					  where [Custom Work].[Quote#] = @quote and SpecSortG is not null and SpecSortSeLine = 0) as mainsub) as b on a.[Quote#] = b.[Quote#] and a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe and a.SpecSortSeLine = b.SpecSortSeLine
	
	--Insert lines from npos with replace code >= 0 and are non-existant in specs tv
	insert into #specs ([Quote#], [Group], SortGv2, Section, SortSev2, SpecSortSeLine, Description, Price, HideShowOptionPriceWording, Bold, Italic, Underline, BackColour, FontColour)
	select [Quote#], SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, NPOD, Price, HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour
	from (select [Custom Work].[Quote#], SpecGroup, SpecSortG, SpecSection, SpecSortSe, SpecSortSeLine, '*NPO*: ' + case when Qty > 1 then convert(nvarchar, Qty) + ', ' + SpecDescription else SpecDescription end as NPOD, 
		  (case when Line# <> 1 then 0 else (case when [Quote Date] >= 'january 1 2019' and @USSale = 1 then [US Price] else Price end) end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording,
		  SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom Work]
		  inner join [Custom Work_SpecLines] on [Custom Work].Quote# = [Custom Work_SpecLines].Quote#
												and [Custom Work].Description = [Custom Work_SpecLines].Description
		  where [Custom Work].[Quote#] = @quote and SpecSortG is not null and SpecSortSeLine >= 0) as mainsub
	left outer join (select SortGv2, SortSev2, Description from #specs) as b on mainsub.SpecSortG = b.SortGv2 and mainsub.SpecSortSe = b.SortSev2 and mainsub.NPOD = b.Description
	where SortSev2 is null
	and Description is null

	--Grab base weight to pass to report in final select statement
	declare @baseweight int
	select @baseweight = case when Description is null then 0 
							  else cast(dbo.GetNumbersFromString(replace(replace(Description, ',', ''), ' ', '')) as int) end
	from [Order Standards]
	where Section = 'Weight lbs +/- 2%'
	and Quote# = @quote
	
	--Update "Weight lbs +/- 2%" spec line based on total weight from options and npos (WITH ", including options" WORDING TO AVOID CONFUSION)
	update #specs
	set Description = cast(b.Weight as nvarchar) + ', including options'
	from #specs as a
	cross join (select sum(Weight) as Weight 
				from (select case when Description is null then 0 
								  else cast(dbo.GetNumbersFromString(replace(replace(Description, ',', ''), ' ', '')) as int) end as Weight
					  from #specs
					  where Section = 'Weight lbs +/- 2%'

					  union all select sum(Weight)
					  from (select (Weight * Qty) as Weight 
							from [Order Options]
							where Quote# = @quote
							
						    union all select sum(Weight * Qty)
						    from [Custom Work]
						    where Quote# = @quote) as mainsub) as mainsub) as b
	where Section = 'Weight lbs +/- 2%'
	
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
						   from (select SpecSortG, SpecSortSe, 0 as NPOIndicator, convert(float, SpecDescription) * Qty as SD, 
								 (case when Line# <> 1 then 0 else Price end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording,
								 SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order Options]
								 inner join [Order Options_SpecLines] on [Order Options].Quote# = [Order Options_SpecLines].Quote#
																		 and [Order Options].[Option No] = [Order Options_SpecLines].[Option No]
																		 and [Order Options].Description = [Order Options_SpecLines].Description
								 where [Order Options].Quote# = @quote and SpecSortSeLine = '-99'
 
								 union all select SpecSortG, SpecSortSe, 1, convert(float, SpecDescription) * Qty, 
								 (case when Line# <> 1 then 0 else (case when [Quote Date] >= 'january 1 2019' and @USSale = 1 then [US Price] else Price end) end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording,
								 SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom Work]
								 inner join [Custom Work_SpecLines] on [Custom Work].Quote# = [Custom Work_SpecLines].Quote#
																	   and [Custom Work].Description = [Custom Work_SpecLines].Description
								 where [Custom Work].Quote# = @quote and SpecSortSeLine = '-99') as mainsub
							group by SpecSortG, SpecSortSe, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour) as mainsub) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe
		where a.SpecID = any (select MinID from (select min(SpecID) as MinID, SortGv2, SortSev2 from #specs 
											     group by SortGv2, SortSev2) as mainsub
											     group by MinID)
	
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
						   from (select SpecSortG, SpecSortSe, 0 as NPOIndicator, cast(left(RIGHT(SpecDescription, LEN(SpecDescription) - CHARINDEX('.', SpecDescription)), 2) as int) * Qty as Inches, 
								 (case when Line# <> 1 then 0 else Price end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording,
								 SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order Options]
								 inner join [Order Options_SpecLines] on [Order Options].Quote# = [Order Options_SpecLines].Quote#
																		 and [Order Options].[Option No] = [Order Options_SpecLines].[Option No]
																		 and [Order Options].Description = [Order Options_SpecLines].Description
								 where [Order Options].Quote# = @quote and SpecSortSeLine = '-98') as mainsub
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
						   from (select SpecSortG, SpecSortSe, 1 as NPOIndicator, cast(left(RIGHT(SpecDescription, LEN(SpecDescription) - CHARINDEX('.', SpecDescription)), 2) as int) * Qty as Inches, 
								 (case when Line# <> 1 then 0 else (case when [Quote Date] >= 'january 1 2019' and @USSale = 1 then [US Price] else Price end) end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording,
								 SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom Work]
								 inner join [Custom Work_SpecLines] on [Custom Work].Quote# = [Custom Work_SpecLines].Quote#
																	   and [Custom Work].Description = [Custom Work_SpecLines].Description								 
								 where [Custom Work].Quote# = @quote and SpecSortSeLine = '-98') as mainsub
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
						   from (select SpecSortG, SpecSortSe, 0 as NPOIndicator, cast(LEFT(SpecDescription, CHARINDEX('.',SpecDescription) - 1) as int) * Qty as Feet, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order Options]
							     inner join [Order Options_SpecLines] on [Order Options].Quote# = [Order Options_SpecLines].Quote#
																		 and [Order Options].[Option No] = [Order Options_SpecLines].[Option No]
																		 and [Order Options].Description = [Order Options_SpecLines].Description
								 where [Order Options].Quote# = @quote and SpecSortSeLine = '-98') as mainsub
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
						   from (select SpecSortG, SpecSortSe, 1 as NPOIndicator, cast(LEFT(SpecDescription, CHARINDEX('.',SpecDescription) - 1) as int) * Qty as Feet, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom Work]
								 inner join [Custom Work_SpecLines] on [Custom Work].Quote# = [Custom Work_SpecLines].Quote#
																	   and [Custom Work].Description = [Custom Work_SpecLines].Description	
								 where [Custom Work].Quote# = @quote and SpecSortSeLine = '-98') as mainsub
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
				     from (select SpecSortG, SpecSortSe, SpecDescription, (case when Line# <> 1 then 0 else Price end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording,
						   SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order Options]
						   inner join [Order Options_SpecLines] on [Order Options].Quote# = [Order Options_SpecLines].Quote#
																   and [Order Options].[Option No] = [Order Options_SpecLines].[Option No]
																   and [Order Options].Description = [Order Options_SpecLines].Description
						   where [Order Options].Quote# = @quote and SpecSortSeLine = '-97'

						   union all select SpecSortG, SpecSortSe, '*NPO*: ' + SpecDescription, (case when Line# <> 1 then 0 else (case when [Quote Date] >= 'january 1 2019' and @USSale = 1 then [US Price] else Price end) end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording,
						   SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom Work]
						   inner join [Custom Work_SpecLines] on [Custom Work].Quote# = [Custom Work_SpecLines].Quote#
																 and [Custom Work].Description = [Custom Work_SpecLines].Description
						   where [Custom Work].Quote# = @quote and SpecSortSeLine = '-97') as mainsub) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe
	where a.SpecSortSeLine = 0

	--delete from specs tv where code from option and npo lines = -96
	delete #specs
	from #specs as a
	inner join (select SpecSortG, SpecSortSe from [Order Options]
				inner join [Order Options_SpecLines] on [Order Options].Quote# = [Order Options_SpecLines].Quote#
														and [Order Options].[Option No] = [Order Options_SpecLines].[Option No]
														and [Order Options].Description = [Order Options_SpecLines].Description
				where [Order Options].Quote# = @quote and SpecSortSeLine = '-96'

				union all select SpecSortG, SpecSortSe from [Custom Work]
				inner join [Custom Work_SpecLines] on [Custom Work].Quote# = [Custom Work_SpecLines].Quote#
													  and [Custom Work].Description = [Custom Work_SpecLines].Description
				where [Custom Work].Quote# = @quote and SpecSortSeLine = '-96') as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe
	
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
				     from (select SpecSortG, SpecSortSe, 0 as NPOIndicator, SpecDescription, (case when Line# <> 1 then 0 else Price end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording,
						   SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order Options]
						   inner join [Order Options_SpecLines] on [Order Options].Quote# = [Order Options_SpecLines].Quote#
																   and [Order Options].[Option No] = [Order Options_SpecLines].[Option No]
																   and [Order Options].Description = [Order Options_SpecLines].Description
						   where [Order Options].Quote# = @quote and SpecSortSeLine = '-95'

						   union all select SpecSortG, SpecSortSe, 1, SpecDescription, (case when Line# <> 1 then 0 else (case when [Quote Date] >= 'january 1 2019' and @USSale = 1 then [US Price] else Price end) end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording,
						   SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom Work]
						   inner join [Custom Work_SpecLines] on [Custom Work].Quote# = [Custom Work_SpecLines].Quote#
																 and [Custom Work].Description = [Custom Work_SpecLines].Description
						   where [Custom Work].Quote# = @quote and SpecSortSeLine = '-95') as mainsub) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe
    where a.SpecSortSeLine = 0
	
	--insert error-handling lines for options and npos with code -95 (find and replace) and no matching address in specs table
	insert into #specs ([Quote#], SortGv2, [Group], SortSev2, Section, [Description], Price, HideShowOptionPriceWording, Bold, Italic, Underline, BackColour, FontColour)
	select [Quote#], SpecSortG, SpecGroup, SpecSortSe, SpecSection, 'Spec Address not found, please review Option and NPO Addresses with -95 code', 0, 1, 1, SpecDescriptionItalic, SpecDescriptionUnderline, 'Red', 'Yellow'
	from (select [Order Options].[Quote#], SpecSortG, SpecGroup, SpecSortSe, SpecSection, SpecDescription, Price, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order Options]
		  inner join [Order Options_SpecLines] on [Order Options].Quote# = [Order Options_SpecLines].Quote#
												  and [Order Options].[Option No] = [Order Options_SpecLines].[Option No]
												  and [Order Options].Description = [Order Options_SpecLines].Description
		  where [Order Options].Quote# = @quote and SpecSortSeLine = '-95'

		  union all select [Custom Work].[Quote#], SpecSortG, SpecGroup, SpecSortSe, SpecSection, SpecDescription, (case when Line# <> 1 then 0 else (case when [Quote Date] >= 'january 1 2019' and @USSale = 1 then [US Price] else Price end) end), SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom Work]
		  inner join [Custom Work_SpecLines] on [Custom Work].Quote# = [Custom Work_SpecLines].Quote#
												and [Custom Work].Description = [Custom Work_SpecLines].Description
		  where [Custom Work].Quote# = @quote and SpecSortSeLine = '-95') as mainsub
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
				     from (select SpecSortG, SpecSortSe, 0 as NPOIndicator, SpecDescription, (case when Line# <> 1 then 0 else Price end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording,
						   SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order Options]
						   inner join [Order Options_SpecLines] on [Order Options].Quote# = [Order Options_SpecLines].Quote#
																   and [Order Options].[Option No] = [Order Options_SpecLines].[Option No]
																   and [Order Options].Description = [Order Options_SpecLines].Description
						   where [Order Options].Quote# = @quote and SpecSortSeLine = '-94'

						   union all select SpecSortG, SpecSortSe, 1, SpecDescription, (case when Line# <> 1 then 0 else (case when [Quote Date] >= 'january 1 2019' and @USSale = 1 then [US Price] else Price end) end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording,
						   SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom Work]
						   inner join [Custom Work_SpecLines] on [Custom Work].Quote# = [Custom Work_SpecLines].Quote#
																 and [Custom Work].Description = [Custom Work_SpecLines].Description
						   where [Custom Work].Quote# = @quote and SpecSortSeLine = '-94') as mainsub) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe
	where a.SpecSortSeLine = 0

	--insert error-handling lines for options and npos with code -94 (find and replace - 2nd runthrough) and no matching address in specs table
	insert into #specs ([Quote#], SortGv2, [Group], SortSev2, Section, [Description], Price, HideShowOptionPriceWording, Bold, Italic, Underline, BackColour, FontColour)
	select [Quote#], SpecSortG, SpecGroup, SpecSortSe, SpecSection, 'Spec Address not found, please review Option and NPO Addresses with -94 code', 0, 1, 1, SpecDescriptionItalic, SpecDescriptionUnderline, 'Red', 'Yellow'
	from (select [Order Options].[Quote#], SpecSortG, SpecGroup, SpecSortSe, SpecSection, SpecDescription, Price, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order Options]
		  inner join [Order Options_SpecLines] on [Order Options].Quote# = [Order Options_SpecLines].Quote#
												  and [Order Options].[Option No] = [Order Options_SpecLines].[Option No]
												  and [Order Options].Description = [Order Options_SpecLines].Description
		  where [Order Options].Quote# = @quote and SpecSortSeLine = '-94'

		  union all select [Custom Work].[Quote#], SpecSortG, SpecGroup, SpecSortSe, SpecSection, SpecDescription, Price, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom Work]
		  inner join [Custom Work_SpecLines] on [Custom Work].Quote# = [Custom Work_SpecLines].Quote#
												and [Custom Work].Description = [Custom Work_SpecLines].Description
		  where [Custom Work].Quote# = @quote and SpecSortSeLine = '-94') as mainsub
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
				     from (select SpecSortG, SpecSortSe, 0 as NPOIndicator, SpecDescription, Qty, (case when Line# <> 1 then 0 else Price end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording,
						   SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order Options]
						   inner join [Order Options_SpecLines] on [Order Options].Quote# = [Order Options_SpecLines].Quote#
																   and [Order Options].[Option No] = [Order Options_SpecLines].[Option No]
																   and [Order Options].Description = [Order Options_SpecLines].Description
						   where [Order Options].Quote# = @quote and SpecSortSeLine = '-93'

						   union all select SpecSortG, SpecSortSe, 1, SpecDescription, 1, (case when Line# <> 1 then 0 else (case when [Quote Date] >= 'january 1 2019' and @USSale = 1 then [US Price] else Price end) end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording,
						   SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom Work]
						   inner join [Custom Work_SpecLines] on [Custom Work].Quote# = [Custom Work_SpecLines].Quote#
																 and [Custom Work].Description = [Custom Work_SpecLines].Description
						   where [Custom Work].Quote# = @quote and SpecSortSeLine = '-93') as mainsub) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe
	where a.SpecSortSeLine = 0

	--insert error-handling lines for options and npos with code -93 (find int value and "replace" with initial and specified int values added together - i.e. ~10~.~2~ will find 10 and replace it with 12) and no matching address in specs table
	insert into #specs ([Quote#], SortGv2, [Group], SortSev2, Section, [Description], Price, HideShowOptionPriceWording, Bold, Italic, Underline, BackColour, FontColour)
	select [Quote#], SpecSortG, SpecGroup, SpecSortSe, SpecSection, 'Spec Address not found, please review Option and NPO Addresses with -93 code', 0, 1, 1, SpecDescriptionItalic, SpecDescriptionUnderline, 'Red', 'Yellow'
	from (select [Order Options].[Quote#], SpecSortG, SpecGroup, SpecSortSe, SpecSection, SpecDescription, Price, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order Options]
		  inner join [Order Options_SpecLines] on [Order Options].Quote# = [Order Options_SpecLines].Quote#
												  and [Order Options].[Option No] = [Order Options_SpecLines].[Option No]
												  and [Order Options].Description = [Order Options_SpecLines].Description
		  where [Order Options].Quote# = @quote and SpecSortSeLine = '-93'

		  union all select [Custom Work].[Quote#], SpecSortG, SpecGroup, SpecSortSe, SpecSection, SpecDescription, (case when Line# <> 1 then 0 else (case when [Quote Date] >= 'january 1 2019' and @USSale = 1 then [US Price] else Price end) end), SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom Work]
		  inner join [Custom Work_SpecLines] on [Custom Work].Quote# = [Custom Work_SpecLines].Quote#
												and [Custom Work].Description = [Custom Work_SpecLines].Description
		  where [Custom Work].Quote# = @quote and SpecSortSeLine = '-93') as mainsub
	left outer join (select SortGv2, SortSev2, Description from #specs) as b on mainsub.SpecSortG = b.SortGv2 and mainsub.SpecSortSe = b.SortSev2
	where SortSev2 is null
	and Description is null

	--Update lines from options and npos with code -92 (find and replace - purge spec line with "find" value, add "replace" value to "find" value)
	update #specs
	set Description = case when b.SpecDescription is null then a.Description 
	                       else case when NPOIndicator = 1 then '(*NPO*->) ' else '' end 
								+ cast(cast(right(left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1), len(left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1)) - charindex('~', left(b.SpecDescription, charindex('~.', b.SpecDescription) - 1))) as float) 
								+ (cast(left(right(b.SpecDescription, len(b.SpecDescription) - (CHARINDEX('~.~', b.SpecDescription) + 2)), (len(b.SpecDescription) - (CHARINDEX('~.~', b.SpecDescription) + 2)) - 1) as float) * Qty) as nvarchar) end,
	Price = case when b.Price is null then a.Price when a.Price is null then b.Price else a.Price + b.Price end,
	HideShowOptionPriceWording = case when a.HideShowOptionPriceWording = 1 then 1 when b.HideShowOptionPriceWording is null then a.HideShowOptionPriceWording else b.HideShowOptionPriceWording end,
	Bold = case when b.SpecDescriptionBold is null then a.Bold else b.SpecDescriptionBold end,
	Italic = case when b.SpecDescriptionItalic is null then a.Italic else b.SpecDescriptionItalic end,
	Underline = case when b.SpecDescriptionUnderline is null then a.Underline else b.SpecDescriptionUnderline end,
	BackColour = case when b.SpecDescriptionBackColour is null then a.BackColour else b.SpecDescriptionBackColour end,
	FontColour = case when b.SpecDescriptionFontColour is null then a.FontColour else b.SpecDescriptionFontColour end
	from #specs as a
	left outer join (select SpecSortG, SpecSortSe, NPOIndicator, SpecDescription, Qty, Price, HideShowOptionPriceWording, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour
				     from (select SpecSortG, SpecSortSe, 0 as NPOIndicator, SpecDescription, Qty, (case when Line# <> 1 then 0 else Price end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording,
						   SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order Options]
						   inner join [Order Options_SpecLines] on [Order Options].Quote# = [Order Options_SpecLines].Quote#
																   and [Order Options].[Option No] = [Order Options_SpecLines].[Option No]
																   and [Order Options].Description = [Order Options_SpecLines].Description
						   where [Order Options].Quote# = @quote and SpecSortSeLine = '-92'

						   union all select SpecSortG, SpecSortSe, 1, SpecDescription, 1, 
						   (case when Line# <> 1 then 0 else (case when [Quote Date] >= 'january 1 2019' and @USSale = 1 then [US Price] else Price end) end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording,
						   SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom Work]
						   inner join [Custom Work_SpecLines] on [Custom Work].Quote# = [Custom Work_SpecLines].Quote#
																 and [Custom Work].Description = [Custom Work_SpecLines].Description
						   where [Custom Work].Quote# = @quote and SpecSortSeLine = '-92') as mainsub) as b on a.SortGv2 = b.SpecSortG and a.SortSev2 = b.SpecSortSe
	where a.SpecSortSeLine = 0

	--insert error-handling lines for options and npos with code -92 (find and replace - purge spec line with "find" value, add "replace" value to "find" value) and no matching address in specs table
	insert into #specs ([Quote#], SortGv2, [Group], SortSev2, Section, [Description], Price, HideShowOptionPriceWording, Bold, Italic, Underline, BackColour, FontColour)
	select [Quote#], SpecSortG, SpecGroup, SpecSortSe, SpecSection, 'Spec Address not found, please review Option and NPO Addresses with -92 code', 0, 1, 1, SpecDescriptionItalic, SpecDescriptionUnderline, 'Red', 'Yellow'
	from (select [Order Options].[Quote#], SpecSortG, SpecGroup, SpecSortSe, SpecSection, SpecDescription, Price, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order Options]
		  inner join [Order Options_SpecLines] on [Order Options].Quote# = [Order Options_SpecLines].Quote#
												  and [Order Options].[Option No] = [Order Options_SpecLines].[Option No]
												  and [Order Options].Description = [Order Options_SpecLines].Description
		  where [Order Options].Quote# = @quote and SpecSortSeLine = '-92'

		  union all select [Custom Work].[Quote#], SpecSortG, SpecGroup, SpecSortSe, SpecSection, SpecDescription, (case when [Quote Date] >= 'january 1 2019' and @USSale = 1 then [US Price] else Price end), SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom Work]
		  inner join [Custom Work_SpecLines] on [Custom Work].Quote# = [Custom Work_SpecLines].Quote#
												and [Custom Work].Description = [Custom Work_SpecLines].Description
		  where [Custom Work].Quote# = @quote and SpecSortSeLine = '-92') as mainsub
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
						   from (select SpecSortG, SpecSortSe, 0 as NPOIndicator, cast(right(left(SpecDescription, CHARINDEX('~', SpecDescription) - 1), charindex('.', SpecDescription) - 1) as int) * Qty as Inches, 
								 (case when Line# <> 1 then 0 else Price end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording,
								 SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order Options]
								 inner join [Order Options_SpecLines] on [Order Options].Quote# = [Order Options_SpecLines].Quote#
																		 and [Order Options].[Option No] = [Order Options_SpecLines].[Option No]
																		 and [Order Options].Description = [Order Options_SpecLines].Description
								 where [Order Options].Quote# = @quote and SpecSortSeLine = '-91'

								 union all select SpecSortG, SpecSortSe, 1, cast(right(left(SpecDescription, CHARINDEX('~', SpecDescription) - 1), charindex('.', SpecDescription) - 1) as int) * Qty as Inches, 
								 (case when Line# <> 1 then 0 else (case when [Quote Date] >= 'january 1 2019' and @USSale = 1 then [US Price] else Price end) end) * Qty as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording,
								 SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom Work]
								 inner join [Custom Work_SpecLines] on [Custom Work].Quote# = [Custom Work_SpecLines].Quote#
																	   and [Custom Work].Description = [Custom Work_SpecLines].Description								 
								 where [Custom Work].Quote# = @quote and SpecSortSeLine = '-91') as mainsub
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
						   from (select SpecSortG, SpecSortSe, 0 as NPOIndicator, cast(LEFT(SpecDescription, CHARINDEX('.',SpecDescription) - 1) as int) * Qty as Feet, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Order Options]
							     inner join [Order Options_SpecLines] on [Order Options].Quote# = [Order Options_SpecLines].Quote#
																		 and [Order Options].[Option No] = [Order Options_SpecLines].[Option No]
																		 and [Order Options].Description = [Order Options_SpecLines].Description
								 where [Order Options].Quote# = @quote and SpecSortSeLine = '-91'

								 union all select SpecSortG, SpecSortSe, 1, cast(LEFT(SpecDescription, CHARINDEX('.',SpecDescription) - 1) as int) * Qty as Feet, SpecDescriptionBold, SpecDescriptionItalic, SpecDescriptionUnderline, SpecDescriptionBackColour, SpecDescriptionFontColour from [Custom Work]
								 inner join [Custom Work_SpecLines] on [Custom Work].Quote# = [Custom Work_SpecLines].Quote#
																	   and [Custom Work].Description = [Custom Work_SpecLines].Description	
								 where [Custom Work].Quote# = @quote and SpecSortSeLine = '-91') as mainsub
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
				from [Order Options_SpecLines]
				where [Order Options_SpecLines].Quote# = @quote and SpecSortSeLine = '-91'

				union all select SpecSortG, SpecSortSe,
				left(right(SpecDescription, charindex('~', SpecDescription) + 1), charindex('.', right(SpecDescription, charindex('~', SpecDescription) + 1)) - 1),
				left(right(SpecDescription, len(SpecDescription) - charindex('.', SpecDescription, charindex('.', SpecDescription) + 1)),
					 CHARINDEX('~', right(SpecDescription, len(SpecDescription) - charindex('.', SpecDescription, charindex('.', SpecDescription) + 1))) - 1)
				from [Custom Work_SpecLines]
				where [Custom Work_SpecLines].Quote# = @quote and SpecSortSeLine = '-91') as b on a.SortGv2 = b.SpecSortG
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
	IF OBJECT_ID('tempdb..#T') IS NOT NULL
		DROP TABLE #T 
	
	--Grab Option and NPO Spec Line Descriptions for Code -90
	select SpecDescription as img into #t
	from [Order Options]
	inner join [Order Options_SpecLines] on [Order Options].Quote# = [Order Options_SpecLines].Quote#
											and [Order Options].[Option No] = [Order Options_SpecLines].[Option No]
											and [Order Options].Description = [Order Options_SpecLines].Description
	where [Order Options].Quote# = @quote and SpecSortSeLine = '-90'

	union all select SpecDescription
	from [Custom Work]
	inner join [Custom Work_SpecLines] on [Custom Work].Quote# = [Custom Work_SpecLines].Quote#
											and [Custom Work].Description = [Custom Work_SpecLines].Description
	where [Custom Work].Quote# = @quote and SpecSortSeLine = '-90'

	--Using Common Table Expressions and table variables, insert and sort the arrays by the table variable ID
	declare @t table
	(
		ID int,
		Description nvarchar(max),
		Starts int,
		Pos int,
		token nvarchar(max)
	)

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
	inner join (select [Order Options_SpecLines].SpecSortG, [Order Options_SpecLines].SpecSortSe, FirstLine,
				token, case when Line# <> 1 then 0 else Price * Qty end as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording
				from [Order Options]
				inner join [Order Options_SpecLines] on [Order Options].Quote# = [Order Options_SpecLines].Quote#
														and [Order Options].[Option No] = [Order Options_SpecLines].[Option No]
														and [Order Options].Description = [Order Options_SpecLines].Description
				inner join (select SpecSortG, SpecSortSe,
							min(case when SpecSortSeLine < 0 then 0 else SpecSortSeLine end) as FirstLine 
							from [Order Options_SpecLines]
							where Quote# = @quote
							group by SpecSortG, SpecSortSe) as subFirstLine on [Order Options_SpecLines].SpecSortG = subFirstLine.SpecSortG
																			   and [Order Options_SpecLines].SpecSortSe = subFirstLine.SpecSortSe		
				inner join @t as a on [Order Options].Qty = a.ID
									  and [Order Options_SpecLines].SpecDescription = a.Description
				where [Order Options].Quote# = @quote and SpecSortSeLine = '-90'

				union all select [Custom Work_SpecLines].SpecSortG, [Custom Work_SpecLines].SpecSortSe, FirstLine, 
				token, case when Line# <> 1 then 0 else (case when [Quote Date] >= 'january 1 2019' and @USSale = 1 then [US Price] * Qty else Price * Qty end) end, 
				case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording
				from [Custom Work]
				inner join [Custom Work_SpecLines] on [Custom Work].Quote# = [Custom Work_SpecLines].Quote#
														and [Custom Work].Description = [Custom Work_SpecLines].Description
				inner join (select SpecSortG, SpecSortSe,
							min(case when SpecSortSeLine < 0 then 0 else SpecSortSeLine end) as FirstLine 
							from [Custom Work_SpecLines]
							where Quote# = @quote
							group by SpecSortG, SpecSortSe) as subFirstLine on [Custom Work_SpecLines].SpecSortG = subFirstLine.SpecSortG
																			   and [Custom Work_SpecLines].SpecSortSe = subFirstLine.SpecSortSe
				inner join @t as a on [Custom Work].Qty = a.ID
									  and [Custom Work_SpecLines].SpecDescription = a.Description
				where [Custom Work].Quote# = @quote and SpecSortSeLine = '-90') as b on a.SortGv2 = b.SpecSortG
																						and a.SortSev2 = b.SpecSortSe
																						and a.SpecSortSeLine = b.FirstLine


















				
	--Code -88 - infinite find and replace array (minics code 0) with fett and inches addition (mimics code -98)
	--Drop and create temp table in tmpdb SQL database for faster processing
	--Code reference: http://stackoverflow.com/questions/8726111/sql-server-find-nth-occurrence-in-a-string
	IF OBJECT_ID('tempdb..#T1') IS NOT NULL
		DROP TABLE #T1 
	
	--Grab Option and NPO Spec Line Descriptions for Code -90
	select SpecDescription as img into #T1
	from [Order Options]
	inner join [Order Options_SpecLines] on [Order Options].Quote# = [Order Options_SpecLines].Quote#
											and [Order Options].[Option No] = [Order Options_SpecLines].[Option No]
											and [Order Options].Description = [Order Options_SpecLines].Description
	where [Order Options].Quote# = @quote and SpecSortSeLine = '-88'

	union all select SpecDescription
	from [Custom Work]
	inner join [Custom Work_SpecLines] on [Custom Work].Quote# = [Custom Work_SpecLines].Quote#
											and [Custom Work].Description = [Custom Work_SpecLines].Description
	where [Custom Work].Quote# = @quote and SpecSortSeLine = '-88'

	--Using Common Table Expressions and table variables, insert and sort the arrays by the table variable ID
	declare @t1 table
	(
		ID int,
		Description nvarchar(max),
		Starts int,
		Pos int,
		token nvarchar(max)
	)

	;with T(img, starts, pos) as (
		select img, 1, charindex('~', img) from #T1
		union all
		select img, cast(pos + 1 as int), charindex('~', img, pos + 1)
		from t
		where pos > 0
	)





	insert into @t1 (ID, Description, Starts, Pos, token)
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
	inner join (select [Order Options_SpecLines].SpecSortG, [Order Options_SpecLines].SpecSortSe, FirstLine,
				token, case when Line# <> 1 then 0 else Price * Qty end as Price, case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording
				from [Order Options]
				inner join [Order Options_SpecLines] on [Order Options].Quote# = [Order Options_SpecLines].Quote#
														and [Order Options].[Option No] = [Order Options_SpecLines].[Option No]
														and [Order Options].Description = [Order Options_SpecLines].Description
				inner join (select SpecSortG, SpecSortSe,
							min(case when SpecSortSeLine < 0 then 0 else SpecSortSeLine end) as FirstLine 
							from [Order Options_SpecLines]
							where Quote# = @quote
							group by SpecSortG, SpecSortSe) as subFirstLine on [Order Options_SpecLines].SpecSortG = subFirstLine.SpecSortG
																			   and [Order Options_SpecLines].SpecSortSe = subFirstLine.SpecSortSe		
				inner join @t1 as a on [Order Options].Qty = a.ID
									  and [Order Options_SpecLines].SpecDescription = a.Description
				where [Order Options].Quote# = @quote and SpecSortSeLine = '-88'

				union all select [Custom Work_SpecLines].SpecSortG, [Custom Work_SpecLines].SpecSortSe, FirstLine, 
				token, case when Line# <> 1 then 0 else (case when [Quote Date] >= 'january 1 2019' and @USSale = 1 then [US Price] * Qty else Price * Qty end) end, 
				case Line# when 1 then 1 else 0 end as HideShowOptionPriceWording
				from [Custom Work]
				inner join [Custom Work_SpecLines] on [Custom Work].Quote# = [Custom Work_SpecLines].Quote#
														and [Custom Work].Description = [Custom Work_SpecLines].Description
				inner join (select SpecSortG, SpecSortSe,
							min(case when SpecSortSeLine < 0 then 0 else SpecSortSeLine end) as FirstLine 
							from [Custom Work_SpecLines]
							where Quote# = @quote
							group by SpecSortG, SpecSortSe) as subFirstLine on [Custom Work_SpecLines].SpecSortG = subFirstLine.SpecSortG
																			   and [Custom Work_SpecLines].SpecSortSe = subFirstLine.SpecSortSe
				inner join @t1 as a on [Custom Work].Qty = a.ID
									  and [Custom Work_SpecLines].SpecDescription = a.Description
				where [Custom Work].Quote# = @quote and SpecSortSeLine = '-88') as b on a.SortGv2 = b.SpecSortG
																						and a.SortSev2 = b.SpecSortSe
																						and a.SpecSortSeLine = b.FirstLine


















	/*

		Code -89 to be added later!
		Will mimic code -99, but will have a cap (similar to code -91)

	*/

	--Update price column to 0 in specs tv where lines don't equal option and npo first spec line
	update #specs
	set Price = 0
	where SpecID not in (select SpecID
						 from (select SpecID, SpecSortG, SpecSortSe from [Order Options] as a
						 	   inner join [Order Options_SpecLines] on a.Quote# = [Order Options_SpecLines].Quote#
																	   and a.[Option No] = [Order Options_SpecLines].[Option No]
																	   and a.Description = [Order Options_SpecLines].Description
							   inner join #specs as b on a.Quote# = b.Quote# and [Order Options_SpecLines].SpecSortG = b.SortGv2 and [Order Options_SpecLines].SpecSortSe = b.SortSev2
	
							   union all select SpecID, SpecSortG, SpecSortSe from [Custom Work] as a
							   inner join [Custom Work_SpecLines] on a.Quote# = [Custom Work_SpecLines].Quote#
																	 and a.Description = [Custom Work_SpecLines].Description
							   inner join #specs as b on a.Quote# = b.Quote# and [Custom Work_SpecLines].SpecSortG = b.SortGv2 and [Custom Work_SpecLines].SpecSortSe = b.SortSev2) as mainsub
						 group by SpecID)
	and Price is not null

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
				Comments from [Order Options]
				inner join [Order Options_SpecLines] on [Order Options].Quote# = [Order Options_SpecLines].Quote#
														and [Order Options].[Option No] = [Order Options_SpecLines].[Option No]
														and [Order Options].Description = [Order Options_SpecLines].Description
				where [Order Options].Quote# = @quote
				and Line# = 1
				and Comments is not null) as b on a.SortGv2 = b.SpecSortG
												  and a.SortSev2 = b.SpecSortSe
												  and a.SpecSortSeLine = b.SpecSortSeLine
	
	--Move all *NPO* characters to the front of the line and remove *NPO* characters that aren't
	update #specs
	set Description = '*NPO*: ' + Description
	where Description like '%*NPO*%'
	and CHARINDEX('*NPO*', Description) <> 1

	update #specs
	set Description = REPLACE(Description, ' *NPO*: ', ' ')
	
	update #specs
	set Description = REPLACE(Description, '(*NPO*->) ', '')

	--Grab Net Count and Weight of Options and NPOs
	declare @OptionsandNPOs_CountandWeight table
	(
		[OpNPOCount] int,
		[OpNPOWeight] int
	)

	insert into @OptionsandNPOs_CountandWeight ([OpNPOCount], [OpNPOWeight])
	select count(ID), sum(Weight * Qty) from [Order Options]
	where Quote# = @quote

	update @OptionsandNPOs_CountandWeight
	set OpNPOCount = OpNPOCount + ID,
	OpNPOWeight = OpNPOWeight + Weight
	from @OptionsandNPOs_CountandWeight as a
	cross join (select COUNT(ID) as ID, sum(Weight * Qty) as Weight from [Custom Work]
				where Quote# = @quote
				and Description not like 'none%') as b

	--Ensure new discount fields have A value (0 if null)
	update Orders
	set Discount1_Type = case when Discount1_Type is null and Discount1 is null then 'Percent' else Discount1_Type end,
		Discount1 = case when Discount1_Type is null and Discount1 is null then 0 else Discount1 end,
		Discount2_Type = case when Discount2_Type is null and Discount2 is null then 'Percent' else Discount2_Type end,
		Discount2 = case when Discount2_Type is null and Discount2 is null then 0 else Discount2 end,
		Discount3_Type = case when Discount3_Type is null and Discount3 is null then 'Percent' else Discount3_Type end,
		Discount3 = case when Discount3_Type is null and Discount3 is null then 0 else Discount3 end
	where Quote# = @quote
	and ([Quote Date] >= 'january 1 2019' or [Quote Date] is null)

	--select statement
	select Orders.Quote#, Products.Class, Products.Model, Orders.[Model No], [Special Instructions], PDD, [Prom Drawing],
	[COMPANY NAME], Orders.WO#, [Serial Number], [Sales Order#], [Purchase Order], [PO Date], [Delivery Date],
	Orders.[Order Date], [Payment Terms].[Payment Terms], CONTACT, Orders.Price as BasePrice, [Volume Discount], [Program Discount],
	Discount1_Name, Discount1_Type, Discount1, Discount2_Name, Discount2_Type, Discount2, Discount3_Name, Discount3_Type, Discount3,
	subA.[Group] as SGroup, suba.SortGv2 as SSortG, subA.Section as SSection, subA.SortSev2 as SSortSe,
	subA.SpecSortSeLine as SSortSeLine, subA.Description, subA.Price as OptionsPrice, HideShowOptionPriceWording, 
	subA.Bold, subA.Underline, subA.Italic, subA.FontColour, subA.BackColour,
	[Sales Person], subB.OpNPOCount, subb.OpNPOWeight, [US Sale], [Quote Date], AdditionalPricingInfo, @baseweight as BaseWeight
	from Orders with (nolock)
	left outer join Products with (nolock) on Orders.[Model No] = Products.[Model No]
	inner join Dealers with (nolock) on Orders.DealerID = Dealers.ID
	left outer join [Payment Terms] with (nolock) on Orders.PayID = [Payment Terms].PayID
	inner join [Sales Staff] with (nolock) on Orders.[Sale PersonID] = [Sales Staff].[ID-SaleStaff]
	left outer join #specs as subA on Orders.Quote# = subA.Quote#
	cross join @OptionsandNPOs_CountandWeight as subB
	where Orders.Quote# = @quote

--END