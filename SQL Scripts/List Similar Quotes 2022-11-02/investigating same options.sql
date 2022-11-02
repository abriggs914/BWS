
	DECLARE @quote AS INT;
	SET @quote = 28070;
	--SET @quote = 26645;
	--SET @quote = 27008;


declare @modelno nvarchar(255) = (select [Model No] from Orders with (nolock) where Quote# = @quote)

	--Drop and create temp table in tmpdb SQL database for faster processing
	IF OBJECT_ID('tempdb..#QuoteOptions') IS NOT NULL
		DROP TABLE #QuoteOptions 

	create table #QuoteOptions
	(
		#Options int,
		[Option No] nvarchar(255),
        [Price] money,
        [Qty] int,
        [Sections] nvarchar(255),
        [Description] nvarchar(max)
	)

	--Grab Quotes with same Model No and Options as @quote parameter
	insert into #QuoteOptions ([Option No], Price, Qty, Sections, Description)
	select [Option No], Price, Qty, Sections, Description
	from [Order Options] with (nolock)
	where Quote# = @quote

	SELECT 'A' AS [X], '#QuoteOptions' AS [Table], * FROM #QuoteOptions

	update #QuoteOptions
	set #Options = NoOptions
	from (select count(*) as NoOptions
		  from [Order Options] with (nolock)
		  where Quote# = @quote) as subCountOptions
		  
	SELECT 'B' AS [X], '#QuoteOptions' AS [Table], * FROM #QuoteOptions

	--Drop and create temp table in tmpdb SQL database for faster processing
	IF OBJECT_ID('tempdb..#QuoteswithsameOptions') IS NOT NULL
		DROP TABLE #QuoteswithsameOptions 

	create table #QuoteswithsameOptions
	(
		[Quote#] int,
		[WO#] int,
		[Quote Date] datetime,
		[Prod Date] datetime
	)


select #Options, @modelno from #QuoteOptions

select Quote#
from [Order Options] with (nolock)
group by Quote#
having count(*) in (select #Options from #QuoteOptions)

	insert into #QuoteswithsameOptions


select main.Quote#, main.WO#, main.[Quote Date], [Prod Date]
	from [Order Options] as main with (nolock)
	inner join Orders with (nolock) on main.Quote# = Orders.Quote#
	left outer join Production with (nolock) on Orders.Quote# = Production.Quote#
	inner join #QuoteOptions as QuoteOptions on main.[Option No] = QuoteOptions.[Option No]
												and (case when main.Sections is null then '' else main.Sections end) = (case when QuoteOptions.Sections is null then '' else QuoteOptions.Sections end)
												and main.Description = QuoteOptions.Description
												AND main.[Qty] = [QuoteOptions].[Qty]
	where main.Quote# in (select Quote#
						  from [Order Options] with (nolock)
						  group by Quote#
						  having count(*) in (select #Options from #QuoteOptions))
	and Orders.[Model No] = @modelno
	and [Date Declined] is null
	group by main.Quote#, main.WO#, main.[Quote Date], [Prod Date]
	--having count(*) = (select distinct #Options from #QuoteOptions)


	SELECT 'C' AS [X], '#QuoteswithsameOptions' AS [Table], * FROM #QuoteswithsameOptions
