--USE [BWSdb]
--GO


	USE [SysproCompanyA]
GO

DECLARE 
	@sd datetime, @ed datetime, @sd1 datetime, @ed1 datetime;
	
SET @sd = '2022-01-01';
SET @ed = '2022-01-31';
SET @sd1 = '2022-02-01';
SET @ed1 = '2022-02-28';

    -- Insert statements for procedure here
	--Dealer Sales Summary - Prelim

	declare @sd2 datetime, @ed2 datetime

	select @sd2 = DATEADD(YEAR, -1, @sd1)
	select @ed2 = DATEADD(YEAR, -1, @ed1)

	--Drop and create temp table in tmpdb SQL database for faster processing
	IF OBJECT_ID('tempdb..#tmptable') IS NOT NULL
		DROP TABLE #tmptable 

	create table #tmptable
	(
		[Units Sold] float,
		[Selling Price] float,
		[Actual Margin] float,
		[Actual Hours] float,
		Initials nvarchar(MAX), 
		Grouping int, 
		Label nvarchar(MAX), 
		LabelTtl nvarchar(MAX), 
		Section nvarchar(MAX), 
		LabelSection nvarchar(MAX), 
		US nvarchar(MAX), 
		LabelUS nvarchar(MAX),
		[Units Sold Prior] float,
		[Selling Price Prior] float,
		[Actual Margin Prior] float,
		[Actual Hours Prior] float
	)

	--insert current and prior period, non-cancelled, non-excluded and invoiced units into current tv 
	insert into #tmptable
	select sum([Units Sold]) as [Units Sold], 
	sum([Selling Price]) as [Selling Price], 
	sum([Actual Margin]) as [Actual Margin], 
	sum([Actual Hours]) as [Actual Hours], 
	Initials, Grouping, Label, LabelTtl, Section, LabelSection, US, LabelUS,
	sum([Units Sold Prior]) as [Units Sold Prior],
	sum([Selling Price Prior]) as [Selling Price Prior],
	sum([Actual Margin Prior]) as [Actual Margin Prior],
	sum([Actual Hours Prior]) as [Actual Hours Prior]
	from (select sum(UnitCount) as [Units Sold],
	sum([Net Cost]) as [Selling Price],
	sum(ActMargin) as [Actual Margin],
	sum(TotalActual) as [Actual Hours],
	Initials, Grouping, Label, LabelTtl, Section, LabelSection, US, LabelUS,
	0 as [Units Sold Prior],
	0 as [Selling Price Prior],
	0 as [Actual Margin Prior],
	0 as [Actual Hours Prior] 
	from [BWSdb].[dbo].dtSalesPerformance
	inner join [BWSdb].[dbo].[spv_DealerSalesSummary (Initials)] on dtSalesPerformance.WO# = [spv_DealerSalesSummary (Initials)].WO#
	and dtSalesPerformance.[Invoice #] = [spv_DealerSalesSummary (Initials)].[Invoice #]
	where [Date Declined] is null and dtSalesPerformance.WO# not like '3%'
	and dtSalesPerformance.[Invoice Date] between @sd and @ed
	and UnitExcl = 1
	group by Initials, Grouping, Label, LabelTtl, Section, LabelSection, US, LabelUS
	having (case when Initials = 'BWS' and sum(UnitCount)= 0 then 0 else 1 end) = 1

	union all select 0 as [Units Sold],
	0 as [Selling Price],
	0 as [Actual Margin],
	0 as [Actual Hours],
	Initials, Grouping, Label, LabelTtl, Section, LabelSection, US, LabelUS,
	sum(UnitCount) as [Units Sold Prior],
	sum([Net Cost]) as [Selling Price Prior],
	sum(ActMargin) as [Actual Margin Prior],
	sum(TotalActual) as [Actual Hours Prior] 
	from [BWSdb].[dbo].dtSalesPerformance
	inner join [BWSdb].[dbo].[spv_DealerSalesSummary (Initials)] on dtSalesPerformance.WO# = [spv_DealerSalesSummary (Initials)].WO#
	and dtSalesPerformance.[Invoice #] = [spv_DealerSalesSummary (Initials)].[Invoice #]
	where [Date Declined] is null and dtSalesPerformance.WO# not like '3%'
	and dtSalesPerformance.[Invoice Date] between @sd1 and @ed1
	and UnitExcl = 1
	group by Initials, Grouping, Label, LabelTtl, Section, LabelSection, US, LabelUS
	having (case when Initials = 'BWS' and sum(UnitCount)= 0 then 0 else 1 end) = 1

	union all select 0, 0, 0, 0,
	[v_Dealer Totals Breakdown].Initials, [GROUPING], Label, LabelTtl, Section, LabelSection, US, LabelUS,
	0, 0, 0, 0 from [BWSdb].[dbo].[v_Dealer Totals Breakdown]
	group by [v_Dealer Totals Breakdown].Initials, [GROUPING], Label, LabelTtl, Section, LabelSection, US, LabelUS) as subA
	group by Initials, Grouping, Label, LabelTtl, Section, LabelSection, US, LabelUS

	--Dealer Sales Summary - Prelim PF
	--Drop and create temp table in tmpdb SQL database for faster processing
	IF OBJECT_ID('tempdb..#tmptablePF') IS NOT NULL
		DROP TABLE #tmptablePF 

	create table #tmptablePF
	(
		[Units Sold] float,
		[Selling Price] float,
		Initials nvarchar(MAX), 
		Grouping int, 
		Label nvarchar(MAX), 
		LabelTtl nvarchar(MAX), 
		Section nvarchar(MAX), 
		LabelSection nvarchar(MAX), 
		US nvarchar(MAX), 
		LabelUS nvarchar(MAX)
	)

	--insert prior fiscal period, non-cancelled and non-excluded units into pf tv
	insert into #tmptablePF
	select sum([Units Sold]) as [Units Sold], 
	sum([Selling Price]) as [Selling Price],
	Initials, Grouping, Label, LabelTtl, Section, LabelSection, US, LabelUS
	from (select sum(UnitCount) as [Units Sold],
	sum([Net Cost]) as [Selling Price],
	Initials, Grouping, Label, LabelTtl, Section, LabelSection, US, LabelUS
	from [BWSdb].[dbo].dtSalesPerformance
	inner join [BWSdb].[dbo].[spv_DealerSalesSummary (Initials)] on dtSalesPerformance.WO# = [spv_DealerSalesSummary (Initials)].WO#
	and dtSalesPerformance.[Invoice #] = [spv_DealerSalesSummary (Initials)].[Invoice #]
	where [Date Declined] is null and dtSalesPerformance.WO# not like '3%'
	and dtSalesPerformance.[Invoice Date] between @sd2 and @ed2
	and UnitExcl = 1
	group by Initials, Grouping, Label, LabelTtl, Section, LabelSection, US, LabelUS
	having (case when Initials = 'BWS' and sum(UnitCount)= 0 then 0 else 1 end) = 1

	union all select 0, 0,
	[v_Dealer Totals Breakdown].Initials, [GROUPING], Label, LabelTtl, Section, LabelSection, US, LabelUS
	from [BWSdb].[dbo].[v_Dealer Totals Breakdown]
	group by [v_Dealer Totals Breakdown].Initials, [GROUPING], Label, LabelTtl, Section, LabelSection, US, LabelUS) as subB
	group by Initials, Grouping, Label, LabelTtl, Section, LabelSection, US, LabelUS

	--Insert blank record for hard-coded 'DCI-R' Dealer grouping if no records fall in the @sd2 and @ed2 invoice range
	if (select count(*) from #tmptable where Initials = 'DCI-R') = 0
		insert into #tmptable
		select 0, 0, 0, 0, 'DCI-R', 1, 'American Dealers', 'Ttl US', 'American', 'Total American', 'American', 'Total US', 0, 0, 0, 0

	if (select count(*) from #tmptablePF where Initials = 'DCI-R') = 0
		insert into #tmptablePF
		select 0, 0, 'DCI-R', 1, 'American Dealers', 'Ttl US', 'American', 'Total American', 'American', 'Total US'

	--Insert blank record for hard-coded 'TMC' Dealer grouping if no records fall in the @sd2 and @ed2 invoice range
	if (select count(*) from #tmptable where Initials = 'TMC') = 0 and (select count(*) from #tmptablePF where Initials = 'TMC') <> 0
		insert into #tmptable
		select 0, 0, 0, 0, 'TMC', 5, 'Proprietary, Direct & Other', 'Ttl Dir/Other', 'Other', 'Total Other', 'Canadian', 'Total CDN', 0, 0, 0, 0

	if (select count(*) from #tmptablePF where Initials = 'TMC') = 0 and (select count(*) from #tmptable where Initials = 'TMC') <> 0
		insert into #tmptablePF
		select 0, 0, 'TMC', 5, 'Proprietary, Direct & Other', 'Ttl Dir/Other', 'Other', 'Total Other', 'Canadian', 'Total CDN'

	--Dealer Sales Summary - Units On Order
	--Drop and create temp table in tmpdb SQL database for faster processing
	IF OBJECT_ID('tempdb..#tmptableUOO') IS NOT NULL
		DROP TABLE #tmptableUOO 

	create table #tmptableUOO
	(
		Initials nvarchar(MAX),
		[On Order] float,
		[On Order Prior] float
	)

	--insert current and prior period units on order into uoo tv 
	insert into #tmptableUOO
	select Initials, sum([On Order]) as [On Order], sum([On Order Prior]) as [On Order Prior]
	from (select case when Class <> 'Container Chassis' and Initials = 'DCI' then 'DCI-R' else Initials end as Initials, 
	count(Quote#) as [On Order], 0 as [On Order Prior] 
	FROM [BWSdb].[dbo].[v_Order Book Detail v2]
	WHERE ([COMPANY NAME] <> N'BWS Manufacturing Ltd.')
	and ([PO Date] is not null and [PO Date] <= @ed)
	and ([Invoice Date] is null or [Invoice Date] > @ed)
	and ([Date Declined] is null or [Date Declined] > @ed)
	group by Class, Initials

	union all select case when Class <> 'Container Chassis' and Initials = 'DCI' then 'DCI-R' else Initials end as Initials, 
	0, count(Quote#)
	FROM [BWSdb].[dbo].[v_Order Book Detail v2]
	WHERE ([COMPANY NAME] <> N'BWS Manufacturing Ltd.')
	and ([PO Date] is not null and [PO Date] <= @ed1)
	and ([Invoice Date] is null or [Invoice Date] > @ed1)
	and ([Date Declined] is null or [Date Declined] > @ed1)
	group by Class, Initials) as subC
	group by Initials
































	declare @glyear decimal(4, 0), @glmonth decimal(2, 0), @priorglyear decimal(4, 0), @priorglmonth decimal(2, 0),  
			@ytdsd datetime, @pytdsd datetime,  @pytded datetime, @pytd2sd datetime, @pytd2ed datetime, @pytd3sd datetime, @pytd3ed datetime,
			@pytdpsd datetime, @pytdped datetime

	declare @loopid int = 1,
			@loopglyear decimal(4, 0),
			@loopglperiod decimal(2, 0),
			@loopglenddatefix datetime,
			@SQLselect nvarchar(4000)

	--Create table for future proof method of collecting period end dates
	--Drop and create temp table in tmpdb SQL database for faster processing
	IF OBJECT_ID('tempdb..#PeriodEndDates') IS NOT NULL
		DROP TABLE #PeriodEndDates

	create table #PeriodEndDates
	(
		RecordID int identity(1, 1),
		GlYear decimal(4, 0),
		GlPeriod decimal(2, 0),
		PeriodEndDate datetime
	)

	--declare stuff for period end date collecting
	select @loopglyear = GlYear,
		   @loopglperiod = GlPeriod
	from GenControl with (nolock) -- <- HERE, YOU WOULD USE WHICHEVER "Control" SQL TABLE BASED ON SYSPRO MODULE YOU WERE WORKING WITHIN! (i.e. Inventory = InvControl)
	where Company = 'A'

	--grab current period end date (if it's there)
	select @SQLselect = 'insert into #PeriodEndDates (GlYear, GLPeriod, PeriodEndDate)
						 select ' + cast(@loopglyear as nvarchar) + ', ' + cast(@loopglperiod as nvarchar) +', CurYrMthEnd' + cast(@loopglperiod as nvarchar) + ' from InvControl with (nolock)'

	exec sp_executesql @SQLselect

	--If it's not there, update today's date
	if (select PeriodEndDate from #PeriodEndDates) is null
		begin
			update #PeriodEndDates
			set PeriodEndDate = cast(getdate() as date)
		end

	select @loopid = @loopid + 1

	if @loopglperiod = 1	
		begin
			select @loopglperiod = 12,
				   @loopglyear = @loopglyear - 1
		end
	else
		begin
			select @loopglperiod = @loopglperiod - 1
		end
	
	--Loop through current and prior year month end date columns 
	while @loopglyear >= (select GlYear - 1 from GenControl with (nolock) where Company = 'A')
		begin
			if @loopglyear = (select GlYear from GenControl with (nolock) where Company = 'A')
				begin
					select @SQLselect = 'insert into #PeriodEndDates (GlYear, GLPeriod, PeriodEndDate)
										 select ' + cast(@loopglyear as nvarchar) + ', ' + cast(@loopglperiod as nvarchar) +', CurYrPrdEnd' + cast(@loopglperiod as nvarchar) + ' from GenControl with (nolock) where Company = ''A'''
				end
			else
				begin
					select @SQLselect = 'insert into #PeriodEndDates (GlYear, GLPeriod, PeriodEndDate)
										 select ' + cast(@loopglyear as nvarchar) + ', ' + cast(@loopglperiod as nvarchar) +', PrvYrPrdEnd' + cast(@loopglperiod as nvarchar) + ' from GenControl with (nolock) where Company = ''A'''
				end

			exec sp_executesql @SQLselect
			
			if (select PeriodEndDate from #PeriodEndDates where GlYear = @loopglyear and GlPeriod = @loopglperiod and @loopglperiod <> 12) is null
				begin
					if @loopglperiod = 12
						begin
							delete from #PeriodEndDates 
							where GlYear = @loopglyear
							and GlPeriod = @loopglperiod

							select @loopglenddatefix = dateadd(month, -1, PeriodEndDate)
							from #PeriodEndDates
							where GlYear = @loopglyear + 1
							and GlPeriod = 1

							select @loopglenddatefix = DATEADD(mm, DATEDIFF(mm, 0, @loopglenddatefix), 0)

							select @loopglenddatefix = DATEADD(dd, -DAY(DATEADD(mm, 1, dateadd(day, 1, @loopglenddatefix))), DATEADD(mm, 1, dateadd(day, 1, @loopglenddatefix)))

							insert into #PeriodEndDates (GlYear, GlPeriod, PeriodEndDate)
							select @loopglyear, @loopglperiod, @loopglenddatefix

							select @loopglperiod = @loopglperiod - 1
						end
					else
						begin
							delete from #PeriodEndDates
							where GlYear = @loopglyear
							and GlPeriod = @loopglperiod

							select @loopglyear = @loopglyear - 1,
								   @loopglperiod = 12
						end
				end
			else
				begin
					if @loopglperiod = 1	
						begin
							select @loopglperiod = 12,
								   @loopglyear = @loopglyear - 1
						end
					else
						begin
							select @loopglperiod = @loopglperiod - 1
						end
				end
				
			select @loopid = @loopid + 1
		end

	--Continue rest of the way (going back 8 years), based on last period end date
	declare @loopdate datetime,
			@loopenddate datetime,
			@loopglstartyear decimal(4, 0) = @loopglyear

	select top (1) @loopdate = dateadd(day, -1, DATEADD(mm, DATEDIFF(mm, 0, PeriodEndDate), 0))
	from #PeriodEndDates
	order by RecordID desc

	insert into #PeriodEndDates (GlYear, GlPeriod, PeriodEndDate)
	select @loopglyear, @loopglperiod, @loopdate

	while @loopglstartyear - @loopglyear <= 7
		begin
			select @loopdate = dateadd(day, -1, DATEADD(mm, DATEDIFF(mm, 0, @loopdate), 0))

			if @loopglyear = 2017 and @loopglperiod = 8
				begin
					select @loopglperiod = 12,
						   @loopglyear = @loopglyear - 1
				end
			else
				begin
					if @loopglperiod = 1
						begin
							select @loopglperiod = 12,
								   @loopglyear = @loopglyear - 1
						end
					else
						begin
							select @loopglperiod = @loopglperiod - 1
						end
				end

			insert into #PeriodEndDates (GlYear, GlPeriod, PeriodEndDate)
			select @loopglyear, @loopglperiod, @loopdate
		end

	declare @Localsd1 datetime,
			@Localed1 datetime,
			@Localsd datetime,
			@Localed datetime

	set @localsd1 = @sd1
	set	@localed1 = @ed1
	set @Localsd = @sd
	set @Localed = @ed

    -- Insert statements for procedure here
	--Drop and create temp table in tmpdb SQL database for faster processing
	IF OBJECT_ID('tempdb..#CostGLPF') IS NOT NULL
		DROP TABLE #CostGLPF 

	create table #CostGLPF
	(
		Journal decimal(10, 0),
		Customer varchar(15),
		OriginZoomKey varchar(100),
		CostValue decimal(14, 2)
	)

	insert into #CostGLPF (Journal, Customer, OriginZoomKey, CostValue)
	select Journal,
	case when Customer is null then '1' else Customer end as Customer, OriginZoomKey,
	sum(EntryValue) as CostValue from GenTransaction with (nolock)
	inner join ArTrnDetail with (nolock) on GenTransaction.OriginZoomKey = '61:' + right('0000' + cast(TrnYear as varchar(4)), 4)
																			+ right('00' + cast(TrnMonth as varchar(2)), 2)
																			+ right('00000' + cast(Register as varchar(5)), 5)
																			+ right('000000' + cast(REPLACE(LTRIM(REPLACE(Invoice, '0', ' ')), ' ', '0') as varchar(6)), 6)
																			+ right('00000' + cast(SummaryLine as varchar(5)), 5)
																			+ right('00000' + cast(DetailLine as varchar(5)), 5)
	inner join #PeriodEndDates on GenTransaction.GlYear = #PeriodEndDates.GlYear
								  and GenTransaction.GlPeriod = #PeriodEndDates.GlPeriod
	where JnlDate between @Localsd1 and @Localed1
	and (case when year(PeriodEndDate) = year(@Localed1) and month(PeriodEndDate) = month(@Localed1) then 1
			  when PeriodEndDate between @Localsd1 and @Localed1 then 1
			  when year(PeriodEndDate) = year(@Localsd1) and month(PeriodEndDate) = month(@Localsd1) then 1
			  else 0 end) = 1
	and GlCode = 5095
	group by Journal, Customer, OriginZoomKey

	union all select Journal,
	case when Customer is null then '1' else Customer end as Customer, OriginZoomKey,
	sum(EntryValue) as CostValue from GenTransaction with (nolock)
	inner join ArTrnDetail with (nolock) on GenTransaction.OriginZoomKey = right('0000' + cast(TrnYear as varchar(4)), 4)
																			+ right('00' + cast(TrnMonth as varchar(2)), 2)
																			+ right('0000000000' + cast(Register as varchar(10)), 10)
																			+ left(right('000000000000000' + cast(Invoice as varchar(15)), 15) + space(20), 20)
																			+ right('0000000000' + cast(SummaryLine as varchar(10)), 10)
																			+ right('0000000000' + cast(DetailLine as varchar(10)), 10)
	inner join #PeriodEndDates on GenTransaction.GlYear = #PeriodEndDates.GlYear
								  and GenTransaction.GlPeriod = #PeriodEndDates.GlPeriod
	where JnlDate between @Localsd1 and @Localed1
	and (case when year(PeriodEndDate) = year(@Localed1) and month(PeriodEndDate) = month(@Localed1) then 1
			  when PeriodEndDate between @Localsd1 and @Localed1 then 1
			  when year(PeriodEndDate) = year(@Localsd1) and month(PeriodEndDate) = month(@Localsd1) then 1
			  else 0 end) = 1
	and GlCode = 5095
	group by Journal, Customer, OriginZoomKey

	union all select Journal, 'Other' as Customer, OriginZoomKey,
	sum(EntryValue) as CostValue from GenTransaction with (nolock)
	inner join #PeriodEndDates on GenTransaction.GlYear = #PeriodEndDates.GlYear
								  and GenTransaction.GlPeriod = #PeriodEndDates.GlPeriod
	where JnlDate between @Localsd1 and @Localed1
	and (case when year(PeriodEndDate) = year(@Localed1) and month(PeriodEndDate) = month(@Localed1) then 1
			  when PeriodEndDate between @Localsd1 and @Localed1 then 1
			  when year(PeriodEndDate) = year(@Localsd1) and month(PeriodEndDate) = month(@Localsd1) then 1
			  else 0 end) = 1
	and GlCode = 5095
	and Source <> 'SA'
	group by Journal, OriginZoomKey

	--Drop and create temp table in tmpdb SQL database for faster processing
	IF OBJECT_ID('tempdb..#CostJnlPF') IS NOT NULL
		DROP TABLE #CostJnlPF 

	create table #CostJnlPF
	(
		Journal decimal(10, 0),
		Customer varchar(15),
		OriginZoomKey varchar(100)
	)

	insert into #CostJnlPF (Journal, Customer, OriginZoomKey)
	select Journal,
	case when Customer is null then '1' else Customer end as Customer, OriginZoomKey
	from GenTransaction with (nolock)
	inner join ArTrnDetail with (nolock) on GenTransaction.OriginZoomKey = '61:' + right('0000' + cast(TrnYear as varchar(4)), 4)
																			+ right('00' + cast(TrnMonth as varchar(2)), 2)
																			+ right('00000' + cast(Register as varchar(5)), 5)
																			+ right('000000' + cast(REPLACE(LTRIM(REPLACE(Invoice, '0', ' ')), ' ', '0') as varchar(6)), 6)
																			+ right('00000' + cast(SummaryLine as varchar(5)), 5)
																			+ right('00000' + cast(DetailLine as varchar(5)), 5)
	inner join #PeriodEndDates on GenTransaction.GlYear = #PeriodEndDates.GlYear
								  and GenTransaction.GlPeriod = #PeriodEndDates.GlPeriod
	where JnlDate between @Localsd1 and @Localed1
	and (case when year(PeriodEndDate) = year(@Localed1) and month(PeriodEndDate) = month(@Localed1) then 1
			  when PeriodEndDate between @Localsd1 and @Localed1 then 1
			  when year(PeriodEndDate) = year(@Localsd1) and month(PeriodEndDate) = month(@Localsd1) then 1
			  else 0 end) = 1
	and GlCode in (4505, 4510)

	union all select Journal,
	case when Customer is null then '1' else Customer end as Customer, OriginZoomKey
	from GenTransaction with (nolock)
	inner join ArTrnDetail with (nolock) on GenTransaction.OriginZoomKey = right('0000' + cast(TrnYear as varchar(4)), 4)
																			+ right('00' + cast(TrnMonth as varchar(2)), 2)
																			+ right('0000000000' + cast(Register as varchar(10)), 10)
																			+ left(right('000000000000000' + cast(Invoice as varchar(15)), 15) + space(20), 20)
																			+ right('0000000000' + cast(SummaryLine as varchar(10)), 10)
																			+ right('0000000000' + cast(DetailLine as varchar(10)), 10)
	inner join #PeriodEndDates on GenTransaction.GlYear = #PeriodEndDates.GlYear
								  and GenTransaction.GlPeriod = #PeriodEndDates.GlPeriod
	where JnlDate between @Localsd1 and @Localed1
	and (case when year(PeriodEndDate) = year(@Localed1) and month(PeriodEndDate) = month(@Localed1) then 1
			  when PeriodEndDate between @Localsd1 and @Localed1 then 1
			  when year(PeriodEndDate) = year(@Localsd1) and month(PeriodEndDate) = month(@Localsd1) then 1
			  else 0 end) = 1
	and GlCode in (4505, 4510)

	union all select Journal, 'Other' as Customer, OriginZoomKey
	from GenTransaction with (nolock)
	inner join #PeriodEndDates on GenTransaction.GlYear = #PeriodEndDates.GlYear
								  and GenTransaction.GlPeriod = #PeriodEndDates.GlPeriod
	where JnlDate between @Localsd1 and @Localed1
	and (case when year(PeriodEndDate) = year(@Localed1) and month(PeriodEndDate) = month(@Localed1) then 1
			  when PeriodEndDate between @Localsd1 and @Localed1 then 1
			  when year(PeriodEndDate) = year(@Localsd1) and month(PeriodEndDate) = month(@Localsd1) then 1
			  else 0 end) = 1
	and GlCode in (4505, 4510)
	and Source <> 'SA'

	--Drop and create temp table in tmpdb SQL database for faster processing
	IF OBJECT_ID('tempdb..#CostGLCF') IS NOT NULL
		DROP TABLE #CostGLCF 

	create table #CostGLCF
	(
		Journal decimal(10, 0),
		Customer varchar(15),
		OriginZoomKey varchar(100),
		CostValue decimal(14, 2)
	)

	insert into #CostGLCF (Journal, Customer, OriginZoomKey, CostValue)
	select Journal,
	case when Customer is null then '1' else Customer end as Customer, OriginZoomKey,
	sum(EntryValue) as CostValue from GenTransaction with (nolock)
	inner join ArTrnDetail with (nolock) on GenTransaction.OriginZoomKey = '61:' + right('0000' + cast(TrnYear as varchar(4)), 4)
																			+ right('00' + cast(TrnMonth as varchar(2)), 2)
																			+ right('00000' + cast(Register as varchar(5)), 5)
																			+ right('000000' + cast(REPLACE(LTRIM(REPLACE(Invoice, '0', ' ')), ' ', '0') as varchar(6)), 6)
																			+ right('00000' + cast(SummaryLine as varchar(5)), 5)
																			+ right('00000' + cast(DetailLine as varchar(5)), 5)
	inner join #PeriodEndDates on GenTransaction.GlYear = #PeriodEndDates.GlYear
								  and GenTransaction.GlPeriod = #PeriodEndDates.GlPeriod
	where JnlDate between @Localsd and @Localed
	and (case when year(PeriodEndDate) = year(@Localed) and month(PeriodEndDate) = month(@Localed) then 1
			  when PeriodEndDate between @Localsd and @Localed then 1
			  when year(PeriodEndDate) = year(@Localsd) and month(PeriodEndDate) = month(@Localsd) then 1
			  else 0 end) = 1
	and GlCode = 5095
	group by Journal, Customer, OriginZoomKey

	union all select Journal,
	case when Customer is null then '1' else Customer end as Customer, OriginZoomKey,
	sum(EntryValue) as CostValue from GenTransaction with (nolock)
	inner join ArTrnDetail with (nolock) on GenTransaction.OriginZoomKey = right('0000' + cast(TrnYear as varchar(4)), 4)
																			+ right('00' + cast(TrnMonth as varchar(2)), 2)
																			+ right('0000000000' + cast(Register as varchar(10)), 10)
																			+ left(right('000000000000000' + cast(Invoice as varchar(15)), 15) + space(20), 20)
																			+ right('0000000000' + cast(SummaryLine as varchar(10)), 10)
																			+ right('0000000000' + cast(DetailLine as varchar(10)), 10)
	inner join #PeriodEndDates on GenTransaction.GlYear = #PeriodEndDates.GlYear
								  and GenTransaction.GlPeriod = #PeriodEndDates.GlPeriod
	where JnlDate between @Localsd and @Localed
	and (case when year(PeriodEndDate) = year(@Localed) and month(PeriodEndDate) = month(@Localed) then 1
			  when PeriodEndDate between @Localsd and @Localed then 1
			  when year(PeriodEndDate) = year(@Localsd) and month(PeriodEndDate) = month(@Localsd) then 1
			  else 0 end) = 1
	and GlCode = 5095
	group by Journal, Customer, OriginZoomKey

	union all select Journal, 'Other' as Customer, OriginZoomKey,
	sum(EntryValue) as CostValue from GenTransaction with (nolock)
	inner join #PeriodEndDates on GenTransaction.GlYear = #PeriodEndDates.GlYear
								  and GenTransaction.GlPeriod = #PeriodEndDates.GlPeriod
	where JnlDate between @Localsd and @Localed
	and (case when year(PeriodEndDate) = year(@Localed) and month(PeriodEndDate) = month(@Localed) then 1
			  when PeriodEndDate between @Localsd and @Localed then 1
			  when year(PeriodEndDate) = year(@Localsd) and month(PeriodEndDate) = month(@Localsd) then 1
			  else 0 end) = 1
	and GlCode = 5095
	and Source <> 'SA'
	group by Journal, OriginZoomKey

	--Drop and create temp table in tmpdb SQL database for faster processing
	IF OBJECT_ID('tempdb..#CostJnlCF') IS NOT NULL
		DROP TABLE #CostJnlCF 

	create table #CostJnlCF
	(
		Journal decimal(10, 0),
		Customer varchar(15),
		OriginZoomKey varchar(100)
	)

	insert into #CostJnlCF (Journal, Customer, OriginZoomKey)
	select Journal,
	case when Customer is null then '1' else Customer end as Customer, OriginZoomKey
	from GenTransaction with (nolock)
	inner join ArTrnDetail with (nolock) on GenTransaction.OriginZoomKey = '61:' + right('0000' + cast(TrnYear as varchar(4)), 4)
																			+ right('00' + cast(TrnMonth as varchar(2)), 2)
																			+ right('00000' + cast(Register as varchar(5)), 5)
																			+ right('000000' + cast(REPLACE(LTRIM(REPLACE(Invoice, '0', ' ')), ' ', '0') as varchar(6)), 6)
																			+ right('00000' + cast(SummaryLine as varchar(5)), 5)
																			+ right('00000' + cast(DetailLine as varchar(5)), 5)
	inner join #PeriodEndDates on GenTransaction.GlYear = #PeriodEndDates.GlYear
								  and GenTransaction.GlPeriod = #PeriodEndDates.GlPeriod
	where JnlDate between @Localsd and @Localed
	and (case when year(PeriodEndDate) = year(@Localed) and month(PeriodEndDate) = month(@Localed) then 1
			  when PeriodEndDate between @Localsd and @Localed then 1
			  when year(PeriodEndDate) = year(@Localsd) and month(PeriodEndDate) = month(@Localsd) then 1
			  else 0 end) = 1
	and GlCode in (4505, 4510)

	union all select Journal,
	case when Customer is null then '1' else Customer end as Customer, OriginZoomKey
	from GenTransaction with (nolock)
	inner join ArTrnDetail with (nolock) on GenTransaction.OriginZoomKey = right('0000' + cast(TrnYear as varchar(4)), 4)
																			+ right('00' + cast(TrnMonth as varchar(2)), 2)
																			+ right('0000000000' + cast(Register as varchar(10)), 10)
																			+ left(right('000000000000000' + cast(Invoice as varchar(15)), 15) + space(20), 20)
																			+ right('0000000000' + cast(SummaryLine as varchar(10)), 10)
																			+ right('0000000000' + cast(DetailLine as varchar(10)), 10)
	inner join #PeriodEndDates on GenTransaction.GlYear = #PeriodEndDates.GlYear
								  and GenTransaction.GlPeriod = #PeriodEndDates.GlPeriod
	where JnlDate between @Localsd and @Localed
	and (case when year(PeriodEndDate) = year(@Localed) and month(PeriodEndDate) = month(@Localed) then 1
			  when PeriodEndDate between @Localsd and @Localed then 1
			  when year(PeriodEndDate) = year(@Localsd) and month(PeriodEndDate) = month(@Localsd) then 1
			  else 0 end) = 1
	and GlCode in (4505, 4510)

	union all select Journal, 'Other' as Customer, OriginZoomKey
	from GenTransaction with (nolock)
	inner join #PeriodEndDates on GenTransaction.GlYear = #PeriodEndDates.GlYear
								  and GenTransaction.GlPeriod = #PeriodEndDates.GlPeriod
	where JnlDate between @Localsd and @Localed
	and (case when year(PeriodEndDate) = year(@Localed) and month(PeriodEndDate) = month(@Localed) then 1
			  when PeriodEndDate between @Localsd and @Localed then 1
			  when year(PeriodEndDate) = year(@Localsd) and month(PeriodEndDate) = month(@Localsd) then 1
			  else 0 end) = 1
	and GlCode in (4505, 4510)
	and Source <> 'SA'
	
	--Drop and create temp table in tmpdb SQL database for faster processing
	IF OBJECT_ID('tempdb..#maintbl') IS NOT NULL
		DROP TABLE #maintbl 

	create table #maintbl
	(
		GlCode varchar(35),
		Journal decimal(10, 0),
		Dealer nvarchar(255),
		PriorGrossPrice decimal(14, 2),
		PriorDiscount decimal(14, 2),
		PriorCOGS decimal(14, 2),
		CurrentGrossPrice decimal(14, 2),
		CurrentDiscount decimal(14, 2),
		CurrentCOGS decimal(14, 2)
	)

	insert into #maintbl (GlCode, Journal, Dealer, PriorGrossPrice, PriorDiscount, PriorCOGS, CurrentGrossPrice, CurrentDiscount, CurrentCOGS)
	select GlCode, GenTransaction.Journal,
	case when Initials is null then 'Direct' when ArTrnDetail.Customer is null then '1' else Initials end as Dealer,
	sum(case when EntryValue < 0 then EntryValue else 0 end) * -1 as PriorGrossPrice,
	sum(case when EntryValue > 0 then EntryValue else 0 end) as PriorDiscount, 
	case when subA.CostValue is null then 0 else subA.CostValue end as PriorCOGS,
	0 as CurrentGrossPrice,
	0 as CurrentDiscount,
	0 as CurrentCOGS
	from GenTransaction with (nolock)
	inner join ArTrnDetail with (nolock) on GenTransaction.OriginZoomKey = '61:' + right('0000' + cast(TrnYear as varchar(4)), 4)
																			+ right('00' + cast(TrnMonth as varchar(2)), 2)
																			+ right('00000' + cast(Register as varchar(5)), 5)
																			+ right('000000' + cast(REPLACE(LTRIM(REPLACE(Invoice, '0', ' ')), ' ', '0') as varchar(6)), 6)
																			+ right('00000' + cast(SummaryLine as varchar(5)), 5)
																			+ right('00000' + cast(DetailLine as varchar(5)), 5)
	inner join #PeriodEndDates on GenTransaction.GlYear = #PeriodEndDates.GlYear
								  and GenTransaction.GlPeriod = #PeriodEndDates.GlPeriod
	left outer join BWSdb.dbo.dtSYSPROCustomerInitals with (nolock) on ArTrnDetail.Customer = dtSYSPROCustomerInitals.SYSPROCustomer collate Latin1_General_BIN
	left outer join #CostGLPF as subA on GenTransaction.Journal = subA.Journal
					 and (case when ArTrnDetail.Customer is null then '1' else ArTrnDetail.Customer end) = subA.Customer collate Latin1_General_BIN
					 and GenTransaction.OriginZoomKey = subA.OriginZoomKey collate Latin1_General_BIN
	where JnlDate between @Localsd1 and @Localed1
	and (case when year(PeriodEndDate) = year(@Localed1) and month(PeriodEndDate) = month(@Localed1) then 1
			  when PeriodEndDate between @Localsd1 and @Localed1 then 1
			  when year(PeriodEndDate) = year(@Localsd1) and month(PeriodEndDate) = month(@Localsd1) then 1
			  else 0 end) = 1
	and GlCode in (4505, 4510)
	group by GlCode, GenTransaction.Journal, Initials, ArTrnDetail.Customer, subA.CostValue

	union all select GlCode, GenTransaction.Journal,
	case when Initials is null then 'Direct' when ArTrnDetail.Customer is null then '1' else Initials end as Dealer,
	sum(case when EntryValue < 0 then EntryValue else 0 end) * -1 as PriorGrossPrice,
	sum(case when EntryValue > 0 then EntryValue else 0 end) as PriorDiscount, 
	case when subA.CostValue is null then 0 else subA.CostValue end as PriorCOGS,
	0 as CurrentGrossPrice,
	0 as CurrentDiscount,
	0 as CurrentCOGS
	from GenTransaction with (nolock)
	inner join ArTrnDetail with (nolock) on GenTransaction.OriginZoomKey = right('0000' + cast(TrnYear as varchar(4)), 4)
																			+ right('00' + cast(TrnMonth as varchar(2)), 2)
																			+ right('0000000000' + cast(Register as varchar(10)), 10)
																			+ left(right('000000000000000' + cast(Invoice as varchar(15)), 15) + space(20), 20)
																			+ right('0000000000' + cast(SummaryLine as varchar(10)), 10)
																			+ right('0000000000' + cast(DetailLine as varchar(10)), 10)
	inner join #PeriodEndDates on GenTransaction.GlYear = #PeriodEndDates.GlYear
								  and GenTransaction.GlPeriod = #PeriodEndDates.GlPeriod
	left outer join BWSdb.dbo.dtSYSPROCustomerInitals with (nolock) on ArTrnDetail.Customer = dtSYSPROCustomerInitals.SYSPROCustomer collate Latin1_General_BIN
	left outer join #CostGLPF as subA on GenTransaction.Journal = subA.Journal
					 and (case when ArTrnDetail.Customer is null then '1' else ArTrnDetail.Customer end) = subA.Customer collate Latin1_General_BIN
					 and GenTransaction.OriginZoomKey = subA.OriginZoomKey collate Latin1_General_BIN
	where JnlDate between @Localsd1 and @Localed1
	and (case when year(PeriodEndDate) = year(@Localed1) and month(PeriodEndDate) = month(@Localed1) then 1
			  when PeriodEndDate between @Localsd1 and @Localed1 then 1
			  when year(PeriodEndDate) = year(@Localsd1) and month(PeriodEndDate) = month(@Localsd1) then 1
			  else 0 end) = 1
	and GlCode in (4505, 4510)
	group by GlCode, GenTransaction.Journal, Initials, ArTrnDetail.Customer, subA.CostValue

	union all select GlCode, GenTransaction.Journal, 'Other' as Dealer,
	sum(case when EntryValue < 0 then EntryValue else 0 end) * -1 as PriorGrossPrice,
	sum(case when EntryValue > 0 then EntryValue else 0 end) as PriorDiscount, 
	case when subA.CostValue is null then 0 else subA.CostValue end as PriorCOGS,
	0 as CurrentGrossPrice,
	0 as CurrentDiscount,
	0 as CurrentCOGS
	from GenTransaction with (nolock)
	inner join #PeriodEndDates on GenTransaction.GlYear = #PeriodEndDates.GlYear
								  and GenTransaction.GlPeriod = #PeriodEndDates.GlPeriod
	left outer join #CostGLPF as subA on GenTransaction.Journal = subA.Journal
					 and GenTransaction.OriginZoomKey = subA.OriginZoomKey collate Latin1_General_BIN
	where JnlDate between @Localsd1 and @Localed1
	and (case when year(PeriodEndDate) = year(@Localed1) and month(PeriodEndDate) = month(@Localed1) then 1
			  when PeriodEndDate between @Localsd1 and @Localed1 then 1
			  when year(PeriodEndDate) = year(@Localsd1) and month(PeriodEndDate) = month(@Localsd1) then 1
			  else 0 end) = 1
	and GlCode in (4505, 4510)
	and Source <> 'SA'
	group by GlCode, GenTransaction.Journal, subA.Customer, subA.CostValue

	insert into #maintbl (GlCode, Journal, Dealer, PriorGrossPrice, PriorDiscount, PriorCOGS, CurrentGrossPrice, CurrentDiscount, CurrentCOGS)
	select GlCode, GenTransaction.Journal,
	case when Initials is null then 'Direct' when ArTrnDetail.Customer is null then '1' else Initials end as Dealer,
	0 as PriorGrossPrice,
	0 as PriorDiscount, 
	0 as PriorCOGS,
	sum(case when EntryValue < 0 then EntryValue else 0 end) * -1 as CurrentGrossPrice,
	sum(case when EntryValue > 0 then EntryValue else 0 end) as CurrentDiscount,
	case when subA.CostValue is null then 0 else subA.CostValue end as CurrentCOGS
	from GenTransaction with (nolock)
	inner join ArTrnDetail with (nolock) on GenTransaction.OriginZoomKey = '61:' + right('0000' + cast(TrnYear as varchar(4)), 4)
																			+ right('00' + cast(TrnMonth as varchar(2)), 2)
																			+ right('00000' + cast(Register as varchar(5)), 5)
																			+ right('000000' + cast(REPLACE(LTRIM(REPLACE(Invoice, '0', ' ')), ' ', '0') as varchar(6)), 6)
																			+ right('00000' + cast(SummaryLine as varchar(5)), 5)
																			+ right('00000' + cast(DetailLine as varchar(5)), 5)
	inner join #PeriodEndDates on GenTransaction.GlYear = #PeriodEndDates.GlYear
								  and GenTransaction.GlPeriod = #PeriodEndDates.GlPeriod
	left outer join BWSdb.dbo.dtSYSPROCustomerInitals with (nolock) on ArTrnDetail.Customer = dtSYSPROCustomerInitals.SYSPROCustomer collate Latin1_General_BIN
	left outer join #CostGLCF as subA on GenTransaction.Journal = subA.Journal 
					 and (case when ArTrnDetail.Customer is null then '1' else ArTrnDetail.Customer end) = subA.Customer collate Latin1_General_BIN
					 and GenTransaction.OriginZoomKey = subA.OriginZoomKey collate Latin1_General_BIN
	where JnlDate between @Localsd and @Localed
	and (case when year(PeriodEndDate) = year(@Localed) and month(PeriodEndDate) = month(@Localed) then 1
			  when PeriodEndDate between @Localsd and @Localed then 1
			  when year(PeriodEndDate) = year(@Localsd) and month(PeriodEndDate) = month(@Localsd) then 1
			  else 0 end) = 1
	and GlCode in (4505, 4510)
	group by GlCode, GenTransaction.Journal, Initials, ArTrnDetail.Customer, subA.CostValue

	union all select GlCode, GenTransaction.Journal,
	case when Initials is null then 'Direct' when ArTrnDetail.Customer is null then '1' else Initials end as Dealer,
	0 as PriorGrossPrice,
	0 as PriorDiscount, 
	0 as PriorCOGS,
	sum(case when EntryValue < 0 then EntryValue else 0 end) * -1 as CurrentGrossPrice,
	sum(case when EntryValue > 0 then EntryValue else 0 end) as CurrentDiscount,
	case when subA.CostValue is null then 0 else subA.CostValue end as CurrentCOGS
	from GenTransaction with (nolock)
	inner join ArTrnDetail with (nolock) on GenTransaction.OriginZoomKey = right('0000' + cast(TrnYear as varchar(4)), 4)
																			+ right('00' + cast(TrnMonth as varchar(2)), 2)
																			+ right('0000000000' + cast(Register as varchar(10)), 10)
																			+ left(right('000000000000000' + cast(Invoice as varchar(15)), 15) + space(20), 20)
																			+ right('0000000000' + cast(SummaryLine as varchar(10)), 10)
																			+ right('0000000000' + cast(DetailLine as varchar(10)), 10)
	inner join #PeriodEndDates on GenTransaction.GlYear = #PeriodEndDates.GlYear
								  and GenTransaction.GlPeriod = #PeriodEndDates.GlPeriod
	left outer join BWSdb.dbo.dtSYSPROCustomerInitals with (nolock) on ArTrnDetail.Customer = dtSYSPROCustomerInitals.SYSPROCustomer collate Latin1_General_BIN
	left outer join #CostGLCF as subA on GenTransaction.Journal = subA.Journal 
					 and (case when ArTrnDetail.Customer is null then '1' else ArTrnDetail.Customer end) = subA.Customer collate Latin1_General_BIN
					 and GenTransaction.OriginZoomKey = subA.OriginZoomKey collate Latin1_General_BIN
	where JnlDate between @Localsd and @Localed
	and (case when year(PeriodEndDate) = year(@Localed) and month(PeriodEndDate) = month(@Localed) then 1
			  when PeriodEndDate between @Localsd and @Localed then 1
			  when year(PeriodEndDate) = year(@Localsd) and month(PeriodEndDate) = month(@Localsd) then 1
			  else 0 end) = 1
	and GlCode in (4505, 4510)
	group by GlCode, GenTransaction.Journal, Initials, ArTrnDetail.Customer, subA.CostValue

	union all select GlCode, GenTransaction.Journal, 'Other' as Dealer,
	0 as PriorGrossPrice,
	0 as PriorDiscount, 
	0 as PriorCOGS,
	sum(case when EntryValue < 0 then EntryValue else 0 end) * -1 as CurrentGrossPrice,
	sum(case when EntryValue > 0 then EntryValue else 0 end) as CurrentDiscount,
	case when subA.CostValue is null then 0 else subA.CostValue end as CurrentCOGS
	from GenTransaction with (nolock)
	inner join #PeriodEndDates on GenTransaction.GlYear = #PeriodEndDates.GlYear
								  and GenTransaction.GlPeriod = #PeriodEndDates.GlPeriod
	left outer join #CostGLPF as subA on GenTransaction.Journal = subA.Journal
					 and GenTransaction.OriginZoomKey = subA.OriginZoomKey collate Latin1_General_BIN
	where JnlDate between @Localsd and @Localed
	and (case when year(PeriodEndDate) = year(@Localed) and month(PeriodEndDate) = month(@Localed) then 1
			  when PeriodEndDate between @Localsd and @Localed then 1
			  when year(PeriodEndDate) = year(@Localsd) and month(PeriodEndDate) = month(@Localsd) then 1
			  else 0 end) = 1
	and GlCode in (4505, 4510)
	and Source <> 'SA'
	group by GlCode, GenTransaction.Journal, subA.Customer, subA.CostValue

	insert into #maintbl (GlCode, Journal, Dealer, PriorGrossPrice, PriorDiscount, PriorCOGS, CurrentGrossPrice, CurrentDiscount, CurrentCOGS)
	select '5095', 0, 'Misc.', 0, 0, sum(a.PriorNetCOGS) - sum(c.PriorGLCOGS), 0, 0, sum(b.CurrentNetCOGS) - sum(c.CurrentGLCOGS)
	from (select sum(CostValue) as PriorNetCOGS from #CostGLPF) as a
	cross join (select sum(CostValue) as CurrentNetCOGS from #CostGLCF) as b
	cross join (select sum(PriorCOGS) as PriorGLCOGS, sum(CurrentCOGS) as CurrentGLCOGS from #maintbl) as c



















	--Final select statement
	SELECT 
		[SumOfUnitsSoldPrior],
		[SumOfSumOfSelling PricePrior],
		[PFSellingPrice],
		[Change%Prior],
		[SumOfSumOfActual MarginPrior],
		[Margin % Prior],
		[Avg Rev Prior],
		[SumOfSumOfActual Hours Prior],
		[Con Prior],
		[On Order Prior],
		[Initials],
		[Grouping],
		[Label],
		[LabelTtl],
		[Section],
		[LabelSection],
		[US],
		[LabelUS],
		[CountryID],
		[SumOfUnitsSold],
		[SumOfSumOfSelling Price],
		[Change%],
		[SumOfSumOfActual Margin],
		[SumOfSumOfActual Hours],
		[On Order],
		[Margin %],
		[Avg Rev],
		[Con],
		(CASE WHEN [Dealer] IS NULL THEN '' ELSE [Dealer] END) AS [Dealer],
		(CASE WHEN [PriorGrossPrice] IS NULL THEN 0 ELSE [PriorGrossPrice] END) AS [PriorGrossPrice],
		(CASE WHEN [PriorSellingPrice] IS NULL THEN 0 ELSE [PriorSellingPrice] END) AS [PriorSellingPrice],
		(CASE WHEN [PriorCOGS] IS NULL THEN 0 ELSE [PriorCOGS] END) AS [PriorCOGS],
		(CASE WHEN [PriorMargin] IS NULL THEN 0 ELSE [PriorMargin] END) AS [PriorMargin],
		(CASE WHEN [GlCode] IS NULL THEN 0 ELSE [GlCode] END) AS [GlCode],
		(CASE WHEN [LblGroup] IS NULL THEN '' ELSE [LblGroup] END) AS [LblGroup],
		(CASE WHEN [CurrentGrossPrice] IS NULL THEN 0 ELSE [CurrentGrossPrice] END) AS [CurrentGrossPrice],
		(CASE WHEN [CurrentDiscount] IS NULL THEN 0 ELSE [CurrentDiscount] END) AS [CurrentDiscount],
		(CASE WHEN [CurrentSellingPrice] IS NULL THEN 0 ELSE [CurrentSellingPrice] END) AS [CurrentSellingPrice],
		(CASE WHEN [CurrentCOGS] IS NULL THEN 0 ELSE [CurrentCOGS] END) AS [CurrentCOGS],
		(CASE WHEN [CurrentMargin] IS NULL THEN 0 ELSE [CurrentMargin] END) AS [CurrentMargin],
		(CASE WHEN [CurrentMargin%] IS NULL THEN 0 ELSE [CurrentMargin%] END) AS [CurrentMargin%],
		(CASE WHEN [Change%B] IS NULL THEN 0 ELSE [Change%B] END) AS [Change%B]
	FROM
	
	(
	select a.[Units Sold Prior] as SumOfUnitsSoldPrior,
	a.[Selling Price Prior] as [SumOfSumOfSelling PricePrior],
	b.[Selling Price] as PFSellingPrice,
	case when b.[Selling Price] = 0 then 0 else (a.[Selling Price Prior] - b.[Selling Price])/b.[Selling Price] end as [Change%Prior],
	a.[Actual Margin Prior] as [SumOfSumOfActual MarginPrior],
	case when a.[Selling Price Prior] = 0 then 0 else a.[Actual Margin Prior]/a.[Selling Price Prior] end as [Margin % Prior],
	case when a.[Units Sold Prior] = 0 then 0 else (a.[Selling Price Prior]/a.[Units Sold Prior]) end as [Avg Rev Prior],
	a.[Actual Hours Prior] as [SumOfSumOfActual Hours Prior],
	case when a.[Actual Hours Prior] = 0 then 0 else a.[Actual Margin Prior]/a.[Actual Hours Prior] end as [Con Prior],
	case when c.[On Order Prior] is null then 0 else c.[On Order Prior] end as [On Order Prior],
	a.Initials, a.Grouping, a.Label, a.LabelTtl, a.Section, a.LabelSection, a.US, a.LabelUS, 
	case when a.Initials = 'DCI-R' then 1 when a.Initials = 'TMC' then 0 else d.CountryID end as CountryID,
	a.[Units Sold] as SumOfUnitsSold,
	a.[Selling Price] as [SumOfSumOfSelling Price],
	case when a.[Selling Price Prior] = 0 then 0 else (a.[Selling Price] - a.[Selling Price Prior])/a.[Selling Price Prior] end as [Change%],
	a.[Actual Margin] as [SumOfSumOfActual Margin],
	a.[Actual Hours] as [SumOfSumOfActual Hours],
	case when c.[On Order] is null then 0 else c.[On Order] end as [On Order],
	case when a.[Selling Price] = 0 then 0 else a.[Actual Margin]/a.[Selling Price] end as [Margin %],
	case when a.[Units Sold] = 0 then 0 else (a.[Selling Price]/a.[Units Sold]) end as [Avg Rev],
	case when a.[Actual Hours] = 0 then 0 else a.[Actual Margin]/a.[Actual Hours] end as Con
	
	--,NULL AS [Dealer],NULL AS [PriorGrossPrice], NULL AS [PriorDiscount], NULL AS [PriorSellingPrice], NULL AS [PriorCOGS],
	--NULL AS [PriorMargin],NULL AS [PriorMargin%], NULL AS [GlCode], NULL AS [LblGroup], NULL AS [CurrentGrossPrice],
	--NULL AS [CurrentDiscount],NULL AS [CurrentSellingPrice], NULL AS [CurrentCOGS], NULL AS [CurrentMargin], NULL AS [Change%B]

	from #tmptable as a
	inner join #tmptablePF as b on a.Initials = b.Initials
	left outer join #tmptableUOO as c on a.Initials = c.Initials
	left outer join (select Initials, 
					 case when [CURRENT DEALER CDN] = 1 then 0
						  when [CURRENT DEALER US] = 1 then 1
						  else null end as CountryID 
					 from [BWSdb].[dbo].Dealers
					 where (cast([CURRENT DEALER] as int) + cast([CURRENT DEALER CDN] as int) + cast([CURRENT DEALER US] as int)) > 0
					 group by Initials, [CURRENT DEALER CDN], [CURRENT DEALER US]) as d on a.Initials = d.Initials
	where ((case when isnull(c.[On Order], 0) = 0 then 0 when c.[On Order] < 0 then c.[On Order] * -1 else c.[On Order] end) + 
	(case when isnull(c.[On Order Prior], 0) = 0 then 0 when c.[On Order Prior] < 0 then c.[On Order Prior] * -1 else c.[On Order Prior] end) +
	(case when isnull(a.[Units Sold], 0) = 0 then 0 when a.[Units Sold] < 0 then a.[Units Sold] * -1 else a.[Units Sold] end) +
	(case when isnull(a.[Units Sold Prior], 0) = 0 then 0 when a.[Units Sold Prior] < 0 then a.[Units Sold Prior] * -1 else a.[Units Sold Prior] end) +
	(case when a.Initials in ('DCI-R', 'TMC') then 1 else 0 end) /*+
	(case when isnull(b.[Units Sold], 0) = 0 then 0 else b.[Units Sold] end)*/) <> 0	
	) AS [SrcA]

	--INNER JOIN
	--	[WipMaster]
	--ON
	--	[WipMaster].[Customer]

	LEFT JOIN (

	select 
	--NULL AS [SumOfUnitsSoldPrior], NULL AS [SumOfSumOfSelling PricePrior], NULL AS [PFSellingPrice], NULL AS [Change%Prior], NULL AS [SumOfSumOfActual MarginPrior],
	--NULL AS [Margin % Prior], NULL AS [Avg Rev Prior], NULL AS [SumOfSumOfActual Hours Prior], NULL AS [Con Prior],
	--NULL AS [On Order Prior], NULL AS [Initials], NULL AS [Grouping], NULL AS [Label],
	--NULL AS [LabelTtl], NULL AS [Section], NULL AS [LabelSection], NULL AS [US], NULL AS [LabelUS], NULL AS [CountryID], NULL AS [SumOfUnitsSold],
	--NULL AS [SumOfSumOfSelling Price], NULL AS [Change%], NULL AS [SumOfSumOfActual Margin], NULL AS [SumOfSumOfActual Hours], NULL AS [On Order],
	--NULL AS [Margin %], NULL AS [Avg Rev], NULL AS [Con],
	[Dealer],

	convert(float, sum(PriorGrossPrice)) as PriorGrossPrice,
	convert(float, sum(PriorDiscount)) as PriorDiscount,
	convert(float, sum(PriorGrossPrice - PriorDiscount)) as PriorSellingPrice, 
	convert(float, sum(PriorCOGS)) as PriorCOGS,
	convert(float, sum(PriorGrossPrice - PriorDiscount) - sum(PriorCOGS)) as PriorMargin,
	case when GlCode = 5095 then 0 
		 when convert(float, sum(PriorGrossPrice - PriorDiscount)) = 0 then 0
		 else convert(float, (sum(PriorGrossPrice - PriorDiscount) - sum(PriorCOGS)) / (sum(PriorGrossPrice - PriorDiscount))) end as [PriorMargin%],
	GlCode,
	case GlCode when 4505 then 'CDN'
				when 4510 then 'US'
				when 5095 then 'Misc.'
				else '' end as LblGroup,
	convert(float, sum(CurrentGrossPrice)) as CurrentGrossPrice,
	convert(float, sum(CurrentDiscount)) as CurrentDiscount,
	convert(float, sum(CurrentGrossPrice - CurrentDiscount)) as CurrentSellingPrice, 
	convert(float, sum(CurrentCOGS)) as CurrentCOGS,
	convert(float, sum(CurrentGrossPrice - CurrentDiscount) - sum(CurrentCOGS)) as CurrentMargin,
	case when GlCode = 5095 then 0 
		 when convert(float, sum(CurrentGrossPrice - CurrentDiscount)) = 0 then 0
		 else convert(float, (sum(CurrentGrossPrice - CurrentDiscount) - sum(CurrentCOGS)) / (sum(CurrentGrossPrice - CurrentDiscount))) end as [CurrentMargin%],
	case when convert(float, (sum(PriorGrossPrice - PriorDiscount))) = 0 then 0 else convert(float, (sum(CurrentGrossPrice - CurrentDiscount) - sum(PriorGrossPrice - PriorDiscount)) / sum(PriorGrossPrice - PriorDiscount)) end as [Change%B]
	from #maintbl
	group by GlCode, [Dealer]

	) AS [SrcB]
	ON
		[SrcA].[Initials] = [SrcB].[Dealer]


