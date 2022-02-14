USE [SysproCompanyS]
GO
--/****** Object:  StoredProcedure [dbo].[sp_DealerPartsSalesSummary]    Script Date: 2022-02-10 10:27:21 AM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO

--ALTER PROCEDURE [dbo].[sp_DealerPartsSalesSummary]
DECLARE
	@sd datetime, @ed datetime, @sd1 datetime, @ed1 datetime
--AS BEGIN
--USE [BWSdb]
--GO


--	USE [SysproCompanyA]
--GO

----CREATE PROCEDURE [dbo].[sp_DealerPartsSalesSummary]
--DECLARE @sd datetime, @ed datetime, @sd1 datetime, @ed1 datetime
----AS BEGIN

 
	
SET @sd = '2018-11-01';
SET @ed = '2022-02-01';
SET @sd1 = '2018-11-01';
SET @ed1 = '2022-02-01';

--SET @sd = '1990-01-01';
--SET @ed = '2030-12-31';
--SET @sd1 = '1990-01-01';
--SET @ed1 = '2030-12-31';



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
		[Actual Hours Prior] float,
		[COGS] FLOAT,
		[InvoiceMonth] INT,
		[InvoiceYear] INT
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
	sum([Actual Hours Prior]) as [Actual Hours Prior],
	SUM([COGS]) AS [COGS],
	[InvoiceMonth],	[InvoiceYear] 
	from (select sum(UnitCount) as [Units Sold],
	sum([Net Cost]) as [Selling Price],
	sum(ActMargin) as [Actual Margin],
	sum(TotalActual) as [Actual Hours],
	Initials, Grouping, Label, LabelTtl, Section, LabelSection, US, LabelUS,
	0 as [Units Sold Prior],
	0 as [Selling Price Prior],
	0 as [Actual Margin Prior],
	0 as [Actual Hours Prior],
	SUM([ActualTotalCost]) AS [COGS],
	MONTH([Invoice Date]) AS [InvoiceMonth],
	YEAR([Invoice Date]) AS [InvoiceYear]
	from [Stargatedb].[dbo].dtSalesPerformance
	inner join [Stargatedb].[dbo].[spv_DealerSalesSummary (Initials)] on dtSalesPerformance.WO# = [spv_DealerSalesSummary (Initials)].WO#
	and dtSalesPerformance.[Invoice #] = [spv_DealerSalesSummary (Initials)].[Invoice #]
	where [Date Declined] is null and dtSalesPerformance.WO# not like '3%'
	and dtSalesPerformance.[Invoice Date] between @sd and @ed
	and UnitExcl = 1
	group by Initials, Grouping, Label, LabelTtl, Section, LabelSection, US, LabelUS, MONTH([Invoice Date]), YEAR([Invoice Date])
	having (case when Initials = 'BWS' and sum(UnitCount)= 0 then 0 else 1 end) = 1

	union all select 0 as [Units Sold],
	0 as [Selling Price],
	0 as [Actual Margin],
	0 as [Actual Hours],
	Initials, Grouping, Label, LabelTtl, Section, LabelSection, US, LabelUS,
	sum(UnitCount) as [Units Sold Prior],
	sum([Net Cost]) as [Selling Price Prior],
	sum(ActMargin) as [Actual Margin Prior],
	sum(TotalActual) as [Actual Hours Prior],
	0 AS [COGS],
	MONTH([Invoice Date]) AS [InvoiceMonth],
	YEAR([Invoice Date]) AS [InvoiceYear]
	from [Stargatedb].[dbo].dtSalesPerformance
	inner join [Stargatedb].[dbo].[spv_DealerSalesSummary (Initials)] on dtSalesPerformance.WO# = [spv_DealerSalesSummary (Initials)].WO#
	and dtSalesPerformance.[Invoice #] = [spv_DealerSalesSummary (Initials)].[Invoice #]
	where [Date Declined] is null and dtSalesPerformance.WO# not like '3%'
	and dtSalesPerformance.[Invoice Date] between @sd1 and @ed1
	and UnitExcl = 1
	group by Initials, Grouping, Label, LabelTtl, Section, LabelSection, US, LabelUS, MONTH([Invoice Date]), YEAR([Invoice Date])
	having (case when Initials = 'BWS' and sum(UnitCount)= 0 then 0 else 1 end) = 1

	union all select 0, 0, 0, 0,
	[v_Dealer Totals Breakdown By Quote And Date].Initials, [GROUPING], Label, LabelTtl, Section, LabelSection, US, LabelUS,
	0, 0, 0, 0,
	0 AS [COGS],
	[OrderMonth] AS [InvoiceMonth],
	[OrderYear] AS [InvoiceYear]
	from [Stargatedb].[dbo].[v_Dealer Totals Breakdown By Quote And Date]
	group by [v_Dealer Totals Breakdown By Quote And Date].Initials, [GROUPING], Label, LabelTtl, Section, LabelSection, US, LabelUS, [OrderMonth], [OrderYear]) as subA
	group by Initials, Grouping, Label, LabelTtl, Section, LabelSection, US, LabelUS, [InvoiceMonth], [InvoiceYear]

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
		LabelUS nvarchar(MAX),
		[COGS] FLOAT,
		[InvoiceMonth] INT,
		[InvoiceYear] INT
	)

	--insert prior fiscal period, non-cancelled and non-excluded units into pf tv
	insert into #tmptablePF
	select sum([Units Sold]) as [Units Sold], 
	sum([Selling Price]) as [Selling Price],
	Initials, Grouping, Label, LabelTtl, Section, LabelSection, US, LabelUS, SUM([COGS]) AS [COGS],
	[InvoiceMonth], [InvoiceYear]
	from (select sum(UnitCount) as [Units Sold],
	sum([Net Cost]) as [Selling Price],
	Initials, Grouping, Label, LabelTtl, Section, LabelSection, US, LabelUS, SUM([ActualTotalCost]) AS [COGS]
	, MONTH([Invoice Date]) AS [InvoiceMonth], YEAR([Invoice Date]) AS [InvoiceYear]
	from [Stargatedb].[dbo].dtSalesPerformance
	inner join [Stargatedb].[dbo].[spv_DealerSalesSummary (Initials)] on dtSalesPerformance.WO# = [spv_DealerSalesSummary (Initials)].WO#
	and dtSalesPerformance.[Invoice #] = [spv_DealerSalesSummary (Initials)].[Invoice #]
	where [Date Declined] is null and dtSalesPerformance.WO# not like '3%'
	and dtSalesPerformance.[Invoice Date] between @sd2 and @ed2
	and UnitExcl = 1
	group by Initials, Grouping, Label, LabelTtl, Section, LabelSection, US, LabelUS, MONTH([Invoice Date]), YEAR([Invoice Date])
	having (case when Initials = 'BWS' and sum(UnitCount)= 0 then 0 else 1 end) = 1

	union all select 0, 0,
	[v_Dealer Totals Breakdown By Quote And Date].Initials, [GROUPING], Label, LabelTtl, Section, LabelSection, US, LabelUS, 0 AS [COGS], [OrderMonth], [OrderYear]
	from [Stargatedb].[dbo].[v_Dealer Totals Breakdown By Quote And Date]
	group by [OrderMonth], [OrderYear], [v_Dealer Totals Breakdown By Quote And Date].Initials, [GROUPING], Label, LabelTtl, Section, LabelSection, US, LabelUS) as subB
	group by [InvoiceMonth], [InvoiceYear], Initials, Grouping, Label, LabelTtl, Section, LabelSection, US, LabelUS

	--Insert blank record for hard-coded 'DCI-R' Dealer grouping if no records fall in the @sd2 and @ed2 invoice range
	if (select count(*) from #tmptable where Initials = 'DCI-R') = 0
		insert into #tmptable
		select 0, 0, 0, 0, 'DCI-R', 1, 'American Dealers', 'Ttl US', 'American', 'Total American', 'American', 'Total US', 0, 0, 0, 0, 0, 1, 2018

	if (select count(*) from #tmptablePF where Initials = 'DCI-R') = 0
		insert into #tmptablePF
		select 0, 0, 'DCI-R', 1, 'American Dealers', 'Ttl US', 'American', 'Total American', 'American', 'Total US', 0, 1, 2018

	--Insert blank record for hard-coded 'TMC' Dealer grouping if no records fall in the @sd2 and @ed2 invoice range
	if (select count(*) from #tmptable where Initials = 'TMC') = 0 and (select count(*) from #tmptablePF where Initials = 'TMC') <> 0
		insert into #tmptable
		select 0, 0, 0, 0, 'TMC', 5, 'Proprietary, Direct & Other', 'Ttl Dir/Other', 'Other', 'Total Other', 'Canadian', 'Total CDN', 0, 0, 0, 0, 0, 1, 2018

	if (select count(*) from #tmptablePF where Initials = 'TMC') = 0 and (select count(*) from #tmptable where Initials = 'TMC') <> 0
		insert into #tmptablePF
		select 0, 0, 'TMC', 5, 'Proprietary, Direct & Other', 'Ttl Dir/Other', 'Other', 'Total Other', 'Canadian', 'Total CDN', 0, 1, 2018

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
	count([SGQuote]) as [On Order], 0 as [On Order Prior] 
	FROM [Stargatedb].[dbo].[v_Order Book Detail v2]
	WHERE ([COMPANY NAME] <> N'BWS Manufacturing Ltd.')
	and ([PO Date] is not null and [PO Date] <= @ed)
	and ([Invoice Date] is null or [Invoice Date] > @ed)
	and ([Date Declined] is null or [Date Declined] > @ed)
	group by Class, Initials

	union all select case when Class <> 'Container Chassis' and Initials = 'DCI' then 'DCI-R' else Initials end as Initials, 
	0, count([SGQuote])
	FROM [Stargatedb].[dbo].[v_Order Book Detail v2]
	WHERE ([COMPANY NAME] <> N'BWS Manufacturing Ltd.')
	and ([PO Date] is not null and [PO Date] <= @ed1)
	and ([Invoice Date] is null or [Invoice Date] > @ed1)
	and ([Date Declined] is null or [Date Declined] > @ed1)
	group by Class, Initials) as subC
	group by Initials































-- Insert statements for procedure here
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
	where Company = 'S'

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
	while @loopglyear >= (select GlYear - 1 from GenControl with (nolock) where Company = 'S')
		begin
			if @loopglyear = (select GlYear from GenControl with (nolock) where Company = 'S')
				begin
					select @SQLselect = 'insert into #PeriodEndDates (GlYear, GLPeriod, PeriodEndDate)
										 select ' + cast(@loopglyear as nvarchar) + ', ' + cast(@loopglperiod as nvarchar) +', CurYrPrdEnd' + cast(@loopglperiod as nvarchar) + ' from GenControl with (nolock) where Company = ''S'''
				end
			else
				begin
					select @SQLselect = 'insert into #PeriodEndDates (GlYear, GLPeriod, PeriodEndDate)
										 select ' + cast(@loopglyear as nvarchar) + ', ' + cast(@loopglperiod as nvarchar) +', PrvYrPrdEnd' + cast(@loopglperiod as nvarchar) + ' from GenControl with (nolock) where Company = ''S'''
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

	--Drop and create temp table in tmpdb SQL database for faster processing
	IF OBJECT_ID('tempdb..#CostGLPF') IS NOT NULL
		DROP TABLE #CostGLPF 

	create table #CostGLPF
	(
		Journal decimal(10, 0),
		Customer varchar(15),
		OriginZoomKey varchar(100),
		CostValue decimal(14, 2), 
		[JnlMonth] INT,
		[JnlYear] INT
	)

	insert into #CostGLPF (Journal, Customer, OriginZoomKey, CostValue, [JnlMonth], [JnlYear])
	select Journal,
	case when Customer is null then '1' else Customer end as Customer, OriginZoomKey,
	sum(EntryValue) as CostValue
	,  MONTH([JnlDate]), YEAR([JnlDate])
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
	and GlCode = 5001
	group by Journal, Customer, OriginZoomKey,  MONTH([JnlDate]), YEAR([JnlDate])

	union all select Journal,
	case when Customer is null then '1' else Customer end as Customer, OriginZoomKey,
	sum(EntryValue) as CostValue,  MONTH([JnlDate]), YEAR([JnlDate]) from GenTransaction with (nolock)
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
	and GlCode = 5001
	group by Journal, Customer, OriginZoomKey,  MONTH([JnlDate]), YEAR([JnlDate])

	union all select Journal, 'Other' as Customer, OriginZoomKey,
	sum(EntryValue) as CostValue,  MONTH([JnlDate]), YEAR([JnlDate]) from GenTransaction with (nolock)
	inner join #PeriodEndDates on GenTransaction.GlYear = #PeriodEndDates.GlYear
								  and GenTransaction.GlPeriod = #PeriodEndDates.GlPeriod
	where JnlDate between @Localsd1 and @Localed1
	and (case when year(PeriodEndDate) = year(@Localed1) and month(PeriodEndDate) = month(@Localed1) then 1
			  when PeriodEndDate between @Localsd1 and @Localed1 then 1
			  when year(PeriodEndDate) = year(@Localsd1) and month(PeriodEndDate) = month(@Localsd1) then 1
			  else 0 end) = 1
	and GlCode = 5001
	and Source <> 'SA'
	group by Journal, OriginZoomKey,  MONTH([JnlDate]), YEAR([JnlDate])

	--Drop and create temp table in tmpdb SQL database for faster processing
	IF OBJECT_ID('tempdb..#CostJnlPF') IS NOT NULL
		DROP TABLE #CostJnlPF 

	create table #CostJnlPF
	(
		Journal decimal(10, 0),
		Customer varchar(15),
		OriginZoomKey varchar(100),
		[JnlMonth] INT,
		[JnlYear] INT
	)

	insert into #CostJnlPF (Journal, Customer, OriginZoomKey, [JnlMonth], [JnlYear])
	select Journal,
	case when Customer is null then '1' else Customer end as Customer, OriginZoomKey
	,  MONTH([JnlDate]), YEAR([JnlDate])
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
	and GlCode in (4013, 4022)

	union all select Journal,
	case when Customer is null then '1' else Customer end as Customer, OriginZoomKey,  MONTH([JnlDate]), YEAR([JnlDate])
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
	and GlCode in (4013, 4022)

	union all select Journal, 'Other' as Customer, OriginZoomKey,  MONTH([JnlDate]), YEAR([JnlDate])
	from GenTransaction with (nolock)
	inner join #PeriodEndDates on GenTransaction.GlYear = #PeriodEndDates.GlYear
								  and GenTransaction.GlPeriod = #PeriodEndDates.GlPeriod
	where JnlDate between @Localsd1 and @Localed1
	and (case when year(PeriodEndDate) = year(@Localed1) and month(PeriodEndDate) = month(@Localed1) then 1
			  when PeriodEndDate between @Localsd1 and @Localed1 then 1
			  when year(PeriodEndDate) = year(@Localsd1) and month(PeriodEndDate) = month(@Localsd1) then 1
			  else 0 end) = 1
	and GlCode in (4013, 4022)
	and Source <> 'SA'

	--Drop and create temp table in tmpdb SQL database for faster processing
	IF OBJECT_ID('tempdb..#CostGLCF') IS NOT NULL
		DROP TABLE #CostGLCF 

	create table #CostGLCF
	(
		Journal decimal(10, 0),
		Customer varchar(15),
		OriginZoomKey varchar(100),
		CostValue decimal(14, 2),
		[JnlMonth] INT,
		[JnlYear] INT
	)

	insert into #CostGLCF (Journal, Customer, OriginZoomKey, CostValue, JnlMonth, JnlYear)
	select Journal,
	case when Customer is null then '1' else Customer end as Customer, OriginZoomKey,
	sum(EntryValue) as CostValue,  MONTH([JnlDate]), YEAR([JnlDate]) from GenTransaction with (nolock)
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
	and GlCode = 5001
	group by Journal, Customer, OriginZoomKey,  MONTH([JnlDate]), YEAR([JnlDate])

	union all select Journal,
	case when Customer is null then '1' else Customer end as Customer, OriginZoomKey,
	sum(EntryValue) as CostValue,  MONTH([JnlDate]), YEAR([JnlDate]) from GenTransaction with (nolock)
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
	and GlCode = 5001
	group by Journal, Customer, OriginZoomKey,  MONTH([JnlDate]), YEAR([JnlDate])

	union all select Journal, 'Other' as Customer, OriginZoomKey,
	sum(EntryValue) as CostValue,  MONTH([JnlDate]), YEAR([JnlDate]) from GenTransaction with (nolock)
	inner join #PeriodEndDates on GenTransaction.GlYear = #PeriodEndDates.GlYear
								  and GenTransaction.GlPeriod = #PeriodEndDates.GlPeriod
	where JnlDate between @Localsd and @Localed
	and (case when year(PeriodEndDate) = year(@Localed) and month(PeriodEndDate) = month(@Localed) then 1
			  when PeriodEndDate between @Localsd and @Localed then 1
			  when year(PeriodEndDate) = year(@Localsd) and month(PeriodEndDate) = month(@Localsd) then 1
			  else 0 end) = 1
	and GlCode = 5001
	and Source <> 'SA'
	group by Journal, OriginZoomKey,  MONTH([JnlDate]), YEAR([JnlDate])

	--Drop and create temp table in tmpdb SQL database for faster processing
	IF OBJECT_ID('tempdb..#CostJnlCF') IS NOT NULL
		DROP TABLE #CostJnlCF 

	create table #CostJnlCF
	(
		Journal decimal(10, 0),
		Customer varchar(15),
		OriginZoomKey varchar(100),
		[JnlMonth] INT,
		[JnlYear] INT
	)

	insert into #CostJnlCF (Journal, Customer, OriginZoomKey, JnlMonth, JnlYear)
	select Journal,
	case when Customer is null then '1' else Customer end as Customer, OriginZoomKey,  MONTH([JnlDate]), YEAR([JnlDate])
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
	and GlCode in (4013, 4022)

	union all select Journal,
	case when Customer is null then '1' else Customer end as Customer, OriginZoomKey,  MONTH([JnlDate]), YEAR([JnlDate])
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
	and GlCode in (4013, 4022)

	union all select Journal, 'Other' as Customer, OriginZoomKey,  MONTH([JnlDate]), YEAR([JnlDate])
	from GenTransaction with (nolock)
	inner join #PeriodEndDates on GenTransaction.GlYear = #PeriodEndDates.GlYear
								  and GenTransaction.GlPeriod = #PeriodEndDates.GlPeriod
	where JnlDate between @Localsd and @Localed
	and (case when year(PeriodEndDate) = year(@Localed) and month(PeriodEndDate) = month(@Localed) then 1
			  when PeriodEndDate between @Localsd and @Localed then 1
			  when year(PeriodEndDate) = year(@Localsd) and month(PeriodEndDate) = month(@Localsd) then 1
			  else 0 end) = 1
	and GlCode in (4013, 4022)
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
		CurrentCOGS decimal(14, 2),
		[GlMonth] INT,
		[GlYear] INT
	)

	insert into #maintbl (GlCode, Journal, Dealer, PriorGrossPrice, PriorDiscount, PriorCOGS, CurrentGrossPrice, CurrentDiscount, CurrentCOGS, GlMonth, GlYear)
	select GlCode, GenTransaction.Journal,
	case when Initials is null then 'Direct' when ArTrnDetail.Customer is null then '1' else Initials end as Dealer,
	sum(case when EntryValue < 0 then EntryValue else 0 end) * -1 as PriorGrossPrice,
	sum(case when EntryValue > 0 then EntryValue else 0 end) as PriorDiscount, 
	case when subA.CostValue is null then 0 else subA.CostValue end as PriorCOGS,
	0 as CurrentGrossPrice,
	0 as CurrentDiscount,
	0 as CurrentCOGS
	,MONTH([PeriodEndDate])
	,YEAR([PeriodEndDate])
	--,MONTH(GenTransaction.[JnlDate])
	--,YEAR(GenTransaction.[JnlDate])
	--,(GenTransaction.[GlPeriod])
	--,(GenTransaction.[GlYear])
	from GenTransaction with (nolock)
	inner join ArTrnDetail with (nolock) on GenTransaction.OriginZoomKey = '61:' + right('0000' + cast(TrnYear as varchar(4)), 4)
																			+ right('00' + cast(TrnMonth as varchar(2)), 2)
																			+ right('00000' + cast(Register as varchar(5)), 5)
																			+ right('000000' + cast(REPLACE(LTRIM(REPLACE(Invoice, '0', ' ')), ' ', '0') as varchar(6)), 6)
																			+ right('00000' + cast(SummaryLine as varchar(5)), 5)
																			+ right('00000' + cast(DetailLine as varchar(5)), 5)
	inner join #PeriodEndDates on GenTransaction.GlYear = #PeriodEndDates.GlYear
								  and GenTransaction.GlPeriod = #PeriodEndDates.GlPeriod
	left outer join [BWSdb].dbo.dtSYSPROCustomerInitals with (nolock) on ArTrnDetail.Customer = dtSYSPROCustomerInitals.SYSPROCustomer collate Latin1_General_BIN
	left outer join #CostGLPF as subA on GenTransaction.Journal = subA.Journal AND (subA.[JnlMonth] = MONTH([JnlDate]) AND subA.[JnlYear] = YEAR([JnlDate]))
					 and (case when ArTrnDetail.Customer is null then '1' else ArTrnDetail.Customer end) = subA.Customer collate Latin1_General_BIN
					 and GenTransaction.OriginZoomKey = subA.OriginZoomKey collate Latin1_General_BIN
	where JnlDate between @Localsd1 and @Localed1
	and (case when year(PeriodEndDate) = year(@Localed1) and month(PeriodEndDate) = month(@Localed1) then 1
			  when PeriodEndDate between @Localsd1 and @Localed1 then 1
			  when year(PeriodEndDate) = year(@Localsd1) and month(PeriodEndDate) = month(@Localsd1) then 1
			  else 0 end) = 1
	and GlCode in (4013, 4022)
	group by GlCode, GenTransaction.Journal, Initials, ArTrnDetail.Customer, subA.CostValue
	,MONTH([PeriodEndDate])
	,YEAR([PeriodEndDate])
	--,MONTH(GenTransaction.[JnlDate])
	--,YEAR(GenTransaction.[JnlDate])
	--,(GenTransaction.[GlPeriod])
	--,(GenTransaction.[GlYear])

	union all select GlCode, GenTransaction.Journal,
	case when Initials is null then 'Direct' when ArTrnDetail.Customer is null then '1' else Initials end as Dealer,
	sum(case when EntryValue < 0 then EntryValue else 0 end) * -1 as PriorGrossPrice,
	sum(case when EntryValue > 0 then EntryValue else 0 end) as PriorDiscount, 
	case when subA.CostValue is null then 0 else subA.CostValue end as PriorCOGS,
	0 as CurrentGrossPrice,
	0 as CurrentDiscount,
	0 as CurrentCOGS
	,MONTH([PeriodEndDate])
	,YEAR([PeriodEndDate])
	--,MONTH(GenTransaction.[JnlDate])
	--,YEAR(GenTransaction.[JnlDate])
	--,(GenTransaction.[GlPeriod])
	--,(GenTransaction.[GlYear])
	from GenTransaction with (nolock)
	inner join ArTrnDetail with (nolock) on GenTransaction.OriginZoomKey = right('0000' + cast(TrnYear as varchar(4)), 4)
																			+ right('00' + cast(TrnMonth as varchar(2)), 2)
																			+ right('0000000000' + cast(Register as varchar(10)), 10)
																			+ left(right('000000000000000' + cast(Invoice as varchar(15)), 15) + space(20), 20)
																			+ right('0000000000' + cast(SummaryLine as varchar(10)), 10)
																			+ right('0000000000' + cast(DetailLine as varchar(10)), 10)
	inner join #PeriodEndDates on GenTransaction.GlYear = #PeriodEndDates.GlYear
								  and GenTransaction.GlPeriod = #PeriodEndDates.GlPeriod
	left outer join [BWSdb].dbo.dtSYSPROCustomerInitals with (nolock) on ArTrnDetail.Customer = dtSYSPROCustomerInitals.SYSPROCustomer collate Latin1_General_BIN
	left outer join #CostGLPF as subA on GenTransaction.Journal = subA.Journal AND (subA.[JnlMonth] = MONTH([JnlDate]) AND subA.[JnlYear] = YEAR([JnlDate]))
					 and (case when ArTrnDetail.Customer is null then '1' else ArTrnDetail.Customer end) = subA.Customer collate Latin1_General_BIN
					 and GenTransaction.OriginZoomKey = subA.OriginZoomKey collate Latin1_General_BIN
	where JnlDate between @Localsd1 and @Localed1
	and (case when year(PeriodEndDate) = year(@Localed1) and month(PeriodEndDate) = month(@Localed1) then 1
			  when PeriodEndDate between @Localsd1 and @Localed1 then 1
			  when year(PeriodEndDate) = year(@Localsd1) and month(PeriodEndDate) = month(@Localsd1) then 1
			  else 0 end) = 1
	and GlCode in (4013, 4022)
	group by GlCode, GenTransaction.Journal, Initials, ArTrnDetail.Customer, subA.CostValue
	,MONTH([PeriodEndDate])
	,YEAR([PeriodEndDate])
	--,MONTH(GenTransaction.[JnlDate])
	--,YEAR(GenTransaction.[JnlDate])
	--,(GenTransaction.[GlPeriod])
	--,(GenTransaction.[GlYear])

	union all select GlCode, GenTransaction.Journal, 'Other' as Dealer,
	sum(case when EntryValue < 0 then EntryValue else 0 end) * -1 as PriorGrossPrice,
	sum(case when EntryValue > 0 then EntryValue else 0 end) as PriorDiscount, 
	case when subA.CostValue is null then 0 else subA.CostValue end as PriorCOGS,
	0 as CurrentGrossPrice,
	0 as CurrentDiscount,
	0 as CurrentCOGS
	,MONTH([PeriodEndDate])
	,YEAR([PeriodEndDate])
	--,MONTH(GenTransaction.[JnlDate])
	--,YEAR(GenTransaction.[JnlDate])
	--,(GenTransaction.[GlPeriod])
	--,(GenTransaction.[GlYear])
	from GenTransaction with (nolock)
	inner join #PeriodEndDates on GenTransaction.GlYear = #PeriodEndDates.GlYear
								  and GenTransaction.GlPeriod = #PeriodEndDates.GlPeriod
	left outer join #CostGLPF as subA on GenTransaction.Journal = subA.Journal AND (subA.[JnlMonth] = MONTH([JnlDate]) AND subA.[JnlYear] = YEAR([JnlDate]))
					 and GenTransaction.OriginZoomKey = subA.OriginZoomKey collate Latin1_General_BIN
	where JnlDate between @Localsd1 and @Localed1
	and (case when year(PeriodEndDate) = year(@Localed1) and month(PeriodEndDate) = month(@Localed1) then 1
			  when PeriodEndDate between @Localsd1 and @Localed1 then 1
			  when year(PeriodEndDate) = year(@Localsd1) and month(PeriodEndDate) = month(@Localsd1) then 1
			  else 0 end) = 1
	and GlCode in (4013, 4022)
	and Source <> 'SA'
	group by GlCode, GenTransaction.Journal, subA.Customer, subA.CostValue
	,MONTH([PeriodEndDate])
	,YEAR([PeriodEndDate])
	--,MONTH(GenTransaction.[JnlDate])
	--,YEAR(GenTransaction.[JnlDate])
	--,(GenTransaction.[GlPeriod])
	--,(GenTransaction.[GlYear])

	insert into #maintbl (GlCode, Journal, Dealer, PriorGrossPrice, PriorDiscount, PriorCOGS, CurrentGrossPrice, CurrentDiscount, CurrentCOGS, [GlMonth], [GlYear])
	select GlCode, GenTransaction.Journal,
	case when Initials is null then 'Direct' when ArTrnDetail.Customer is null then '1' else Initials end as Dealer,
	0 as PriorGrossPrice,
	0 as PriorDiscount, 
	0 as PriorCOGS,
	sum(case when EntryValue < 0 then EntryValue else 0 end) * -1 as CurrentGrossPrice,
	sum(case when EntryValue > 0 then EntryValue else 0 end) as CurrentDiscount,
	case when subA.CostValue is null then 0 else subA.CostValue end as CurrentCOGS
	,MONTH([PeriodEndDate])
	,YEAR([PeriodEndDate])
	--,MONTH(GenTransaction.[JnlDate])
	--,YEAR(GenTransaction.[JnlDate])
	--,(GenTransaction.[GlPeriod])
	--,(GenTransaction.[GlYear])
	from GenTransaction with (nolock)
	inner join ArTrnDetail with (nolock) on GenTransaction.OriginZoomKey = '61:' + right('0000' + cast(TrnYear as varchar(4)), 4)
																			+ right('00' + cast(TrnMonth as varchar(2)), 2)
																			+ right('00000' + cast(Register as varchar(5)), 5)
																			+ right('000000' + cast(REPLACE(LTRIM(REPLACE(Invoice, '0', ' ')), ' ', '0') as varchar(6)), 6)
																			+ right('00000' + cast(SummaryLine as varchar(5)), 5)
																			+ right('00000' + cast(DetailLine as varchar(5)), 5)
	inner join #PeriodEndDates on GenTransaction.GlYear = #PeriodEndDates.GlYear
								  and GenTransaction.GlPeriod = #PeriodEndDates.GlPeriod
	left outer join [BWSdb].dbo.dtSYSPROCustomerInitals with (nolock) on ArTrnDetail.Customer = dtSYSPROCustomerInitals.SYSPROCustomer collate Latin1_General_BIN
	left outer join #CostGLCF as subA on GenTransaction.Journal = subA.Journal  AND (subA.[JnlMonth] = MONTH([JnlDate]) AND subA.[JnlYear] = YEAR([JnlDate]))
					 and (case when ArTrnDetail.Customer is null then '1' else ArTrnDetail.Customer end) = subA.Customer collate Latin1_General_BIN
					 and GenTransaction.OriginZoomKey = subA.OriginZoomKey collate Latin1_General_BIN
	where JnlDate between @Localsd and @Localed
	and (case when year(PeriodEndDate) = year(@Localed) and month(PeriodEndDate) = month(@Localed) then 1
			  when PeriodEndDate between @Localsd and @Localed then 1
			  when year(PeriodEndDate) = year(@Localsd) and month(PeriodEndDate) = month(@Localsd) then 1
			  else 0 end) = 1
	and GlCode in (4013, 4022)
	group by GlCode, GenTransaction.Journal, Initials, ArTrnDetail.Customer, subA.CostValue
	,MONTH([PeriodEndDate])
	,YEAR([PeriodEndDate])
	--,MONTH(GenTransaction.[JnlDate])
	--,YEAR(GenTransaction.[JnlDate])
	--,(GenTransaction.[GlPeriod])
	--,(GenTransaction.[GlYear])

	union all select GlCode, GenTransaction.Journal,
	case when Initials is null then 'Direct' when ArTrnDetail.Customer is null then '1' else Initials end as Dealer,
	0 as PriorGrossPrice,
	0 as PriorDiscount, 
	0 as PriorCOGS,
	sum(case when EntryValue < 0 then EntryValue else 0 end) * -1 as CurrentGrossPrice,
	sum(case when EntryValue > 0 then EntryValue else 0 end) as CurrentDiscount,
	case when subA.CostValue is null then 0 else subA.CostValue end as CurrentCOGS
	,MONTH([PeriodEndDate])
	,YEAR([PeriodEndDate])
	--,MONTH(GenTransaction.[JnlDate])
	--,YEAR(GenTransaction.[JnlDate])
	--,(GenTransaction.[GlPeriod])
	--,(GenTransaction.[GlYear])
	from GenTransaction with (nolock)
	inner join ArTrnDetail with (nolock) on GenTransaction.OriginZoomKey = right('0000' + cast(TrnYear as varchar(4)), 4)
																			+ right('00' + cast(TrnMonth as varchar(2)), 2)
																			+ right('0000000000' + cast(Register as varchar(10)), 10)
																			+ left(right('000000000000000' + cast(Invoice as varchar(15)), 15) + space(20), 20)
																			+ right('0000000000' + cast(SummaryLine as varchar(10)), 10)
																			+ right('0000000000' + cast(DetailLine as varchar(10)), 10)
	inner join #PeriodEndDates on GenTransaction.GlYear = #PeriodEndDates.GlYear
								  and GenTransaction.GlPeriod = #PeriodEndDates.GlPeriod
	left outer join [BWSdb].dbo.dtSYSPROCustomerInitals with (nolock) on ArTrnDetail.Customer = dtSYSPROCustomerInitals.SYSPROCustomer collate Latin1_General_BIN
	left outer join #CostGLCF as subA on GenTransaction.Journal = subA.Journal  AND (subA.[JnlMonth] = MONTH([JnlDate]) AND subA.[JnlYear] = YEAR([JnlDate]))
					 and (case when ArTrnDetail.Customer is null then '1' else ArTrnDetail.Customer end) = subA.Customer collate Latin1_General_BIN
					 and GenTransaction.OriginZoomKey = subA.OriginZoomKey collate Latin1_General_BIN
	where JnlDate between @Localsd and @Localed
	and (case when year(PeriodEndDate) = year(@Localed) and month(PeriodEndDate) = month(@Localed) then 1
			  when PeriodEndDate between @Localsd and @Localed then 1
			  when year(PeriodEndDate) = year(@Localsd) and month(PeriodEndDate) = month(@Localsd) then 1
			  else 0 end) = 1
	and GlCode in (4013, 4022)
	group by GlCode, GenTransaction.Journal, Initials, ArTrnDetail.Customer, subA.CostValue, GenTransaction.[GlPeriod], GenTransaction.[GlYear]
	,MONTH([PeriodEndDate])
	,YEAR([PeriodEndDate])
	--,MONTH(GenTransaction.[JnlDate])
	--,YEAR(GenTransaction.[JnlDate])
	--,(GenTransaction.[GlPeriod])
	--,(GenTransaction.[GlYear])

	union all select GlCode, GenTransaction.Journal, 'Other' as Dealer,
	0 as PriorGrossPrice,
	0 as PriorDiscount, 
	0 as PriorCOGS,
	sum(case when EntryValue < 0 then EntryValue else 0 end) * -1 as CurrentGrossPrice,
	sum(case when EntryValue > 0 then EntryValue else 0 end) as CurrentDiscount,
	case when subA.CostValue is null then 0 else subA.CostValue end as CurrentCOGS
	,MONTH([PeriodEndDate])
	,YEAR([PeriodEndDate])
	--,MONTH(GenTransaction.[JnlDate])
	--,YEAR(GenTransaction.[JnlDate])
	--,(GenTransaction.[GlPeriod])
	--,(GenTransaction.[GlYear])
	from GenTransaction with (nolock)
	inner join #PeriodEndDates on GenTransaction.GlYear = #PeriodEndDates.GlYear
								  and GenTransaction.GlPeriod = #PeriodEndDates.GlPeriod
	left outer join #CostGLPF as subA on GenTransaction.Journal = subA.Journal AND (subA.[JnlMonth] = MONTH([JnlDate]) AND subA.[JnlYear] = YEAR([JnlDate]))
					 and GenTransaction.OriginZoomKey = subA.OriginZoomKey collate Latin1_General_BIN
	where JnlDate between @Localsd and @Localed
	and (case when year(PeriodEndDate) = year(@Localed) and month(PeriodEndDate) = month(@Localed) then 1
			  when PeriodEndDate between @Localsd and @Localed then 1
			  when year(PeriodEndDate) = year(@Localsd) and month(PeriodEndDate) = month(@Localsd) then 1
			  else 0 end) = 1
	and GlCode in (4013, 4022)
	and Source <> 'SA'
	group by GlCode, GenTransaction.Journal, subA.Customer, subA.CostValue
	,MONTH([PeriodEndDate])
	,YEAR([PeriodEndDate])
	--,MONTH(GenTransaction.[JnlDate])
	--,YEAR(GenTransaction.[JnlDate])
	--,(GenTransaction.[GlPeriod])
	--,(GenTransaction.[GlYear])




	insert into #maintbl (GlCode, Journal, Dealer, PriorGrossPrice, PriorDiscount, PriorCOGS, CurrentGrossPrice, CurrentDiscount, CurrentCOGS, [GlMonth], [GlYear])
	select '5001', 0, 'Misc.', 0, 0, SUM([PriorNetCOGS]) - SUM([PriorGLCOGS]), 0, 0, sum(b.CurrentNetCOGS) - sum(c.CurrentGLCOGS)
	, c.[GlMonth], c.[GlYear]
	from (select [JnlMonth], [JnlYear], sum(CostValue) as PriorNetCOGS from #CostGLPF GROUP BY [JnlMonth], [JnlYear]) as a
	cross join (select [JnlMonth], [JnlYear], sum(CostValue) as CurrentNetCOGS from #CostGLCF GROUP BY [JnlMonth], [JnlYear]) as b
	cross join (select SUM([PriorCOGS]) as [PriorGLCOGS], sum(CurrentCOGS) as CurrentGLCOGS, [GlMonth], [GlYear] from #maintbl GROUP BY [GlMonth], [GlYear]) as c
	WHERE
		[GlMonth] = a.[JnlMonth] AND [GlMonth] = b.[JnlMonth]
		AND [GlYear] = a.[JnlYear] AND [GlYear] = b.[JnlYear]
	GROUP BY [GlMonth], [GlYear], a.[JnlMonth], a.[JnlYear], b.[JnlMonth], b.[JnlYear]









	
	DECLARE @looping_month_start AS INT;
	DECLARE @looping_month_stop AS INT;
	DECLARE @t_month AS DATE;
	SET @looping_month_start = 0;
	SET @looping_month_stop = DATEDIFF(MONTH, @sd, @ed);

	WHILE @looping_month_start < @looping_month_stop + 1 BEGIN

		SET @t_month = DATEADD(MONTH, @looping_month_start, @sd);

		--Insert blank record for hard-coded 'DCI-R' Dealer grouping if no records fall in the @sd2 and @ed2 invoice range
		insert into #tmptable
			select 0, 0, 0, 0, 'Misc.', 0, 'Misc.', 'Misc.', 'Misc.', 'Misc.', 'Misc.', 'Misc.', 0, 0, 0, 0, 0, MONTH(@t_month), YEAR(@t_month)

		INSERT INTO #tmptablePF
			select 0, 0, 'Misc.', 0, 'Misc.', 'Misc.', 'Misc.', 'Misc.', 'Misc.', 'Misc.', 0, MONTH(@t_month), YEAR(@t_month)

		SET @looping_month_start = @looping_month_start + 1;
	END





	--Final select statement
	SELECT 
		CAST([InvoiceYear] AS NVARCHAR(4)) + '-' + RIGHT('00' + CAST([InvoiceMonth] AS NVARCHAR(2)), 2) AS [FmtDate],
		SUM([Units Sold]) AS [Units Sold],
		[Initials],
		SUM([Trailer Selling Price]) AS [Trailer Selling Price],
		SUM([Trailer COGS]) AS [Trailer COGS],
		SUM([Parts Selling Price]) AS [Parts Selling Price],
		SUM([Parts COGS]) AS [Parts COGS]
	FROM
	
	(
	SELECT
		[InvoiceYear],
		[InvoiceMonth],
		[SumOfUnitsSoldPrior] AS [Units Sold],
		[Initials],
		[SumOfSumOfSelling Price] AS [Trailer Selling Price],
		(CASE WHEN [COGS] IS NULL THEN 0 ELSE [COGS] END) AS [Trailer COGS],
		0 AS [Parts Selling Price],
		0 AS [Parts COGS]
		FROM (
			select 
				a.[InvoiceMonth],
				a.[InvoiceYear],
				a.[Units Sold Prior] as SumOfUnitsSoldPrior,
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
			case when a.[Actual Hours] = 0 then 0 else a.[Actual Margin]/a.[Actual Hours] end as Con,
			a.[COGS]
			from #tmptable as a
			inner join #tmptablePF as b on a.Initials = b.Initials AND (a.[InvoiceMonth] = b.[InvoiceMonth] AND a.[InvoiceYear] = b.[InvoiceYear])
			left outer join #tmptableUOO as c on a.Initials = c.Initials
			left outer join (select Initials, 
							 case when [CURRENT DEALER CDN] = 1 then 0
								  when [CURRENT DEALER US] = 1 then 1
								  else null end as CountryID 
							 from [BWSdb].[dbo].DealersV2
							 where (cast([CURRENT DEALER] as int) + cast([CURRENT DEALER CDN] as int) + cast([CURRENT DEALER US] as int)) > 0
							 group by Initials, [CURRENT DEALER CDN], [CURRENT DEALER US]) as d on a.Initials = d.Initials
			where ((case when isnull(c.[On Order], 0) = 0 then 0 when c.[On Order] < 0 then c.[On Order] * -1 else c.[On Order] end) + 
			(case when isnull(c.[On Order Prior], 0) = 0 then 0 when c.[On Order Prior] < 0 then c.[On Order Prior] * -1 else c.[On Order Prior] end) +
			(case when isnull(a.[Units Sold], 0) = 0 then 0 when a.[Units Sold] < 0 then a.[Units Sold] * -1 else a.[Units Sold] end) +
			(case when isnull(a.[Units Sold Prior], 0) = 0 then 0 when a.[Units Sold Prior] < 0 then a.[Units Sold Prior] * -1 else a.[Units Sold Prior] end) +
			(case when a.Initials in ('DCI-R', 'TMC', 'Misc.') then 1 else 0 end) /*+
			(case when isnull(b.[Units Sold], 0) = 0 then 0 else b.[Units Sold] end)*/) <> 0	
			) AS [SrcSubA]

	UNION 

	SELECT
		[GlYear],
		[GlMonth],
		0,
		[Dealer],
		0,
		0,
		[PriorSellingPrice],
		[PriorCOGS]
	FROM (

		select 
		convert(float, sum(PriorGrossPrice)) as PriorGrossPrice,
		convert(float, sum(PriorDiscount)) as PriorDiscount,
		convert(float, sum(PriorGrossPrice - PriorDiscount)) as [PriorSellingPrice], 
		convert(float, sum(PriorCOGS)) as [PriorCOGS],
		convert(float, sum(PriorGrossPrice - PriorDiscount) - sum(PriorCOGS)) as PriorMargin,
		case when GlCode = 5001 then 0 
			 when convert(float, sum(PriorGrossPrice - PriorDiscount)) = 0 then 0
			 else convert(float, (sum(PriorGrossPrice - PriorDiscount) - sum(PriorCOGS)) / (sum(PriorGrossPrice - PriorDiscount))) end as [PriorMargin%],
		GlCode,
		case GlCode when 4013 then 'CDN'
					when 4022 then 'US'
					when 5001 then 'Misc.'
					else '' end as LblGroup,
		Dealer,
		convert(float, sum(CurrentGrossPrice)) as CurrentGrossPrice,
		convert(float, sum(CurrentDiscount)) as CurrentDiscount,
		convert(float, sum(CurrentGrossPrice - CurrentDiscount)) as CurrentSellingPrice, 
		convert(float, sum(CurrentCOGS)) as CurrentCOGS,
		convert(float, sum(CurrentGrossPrice - CurrentDiscount) - sum(CurrentCOGS)) as CurrentMargin,
		case when GlCode = 5001 then 0 
			 when convert(float, sum(CurrentGrossPrice - CurrentDiscount)) = 0 then 0
			 else convert(float, (sum(CurrentGrossPrice - CurrentDiscount) - sum(CurrentCOGS)) / (sum(CurrentGrossPrice - CurrentDiscount))) end as [CurrentMargin%],
		case when convert(float, (sum(PriorGrossPrice - PriorDiscount))) = 0 then 0 else convert(float, (sum(CurrentGrossPrice - CurrentDiscount) - sum(PriorGrossPrice - PriorDiscount)) / sum(PriorGrossPrice - PriorDiscount)) end as [Change%],
		[GlMonth],
		[GlYear]
		from #maintbl
		group by GlCode, Dealer, [GlMonth],	[GlYear]
		) AS [SrcSubB]

	) AS [Src]
	--ON
	--	[SrcA].[Initials] = [SrcB].[Dealer]
	--	AND ([SrcA].[InvoiceMonth] = [SrcB].[GlMonth] AND [SrcA].[InvoiceYear] = [SrcB].[GlYear])
	WHERE
		CAST(CAST([Src].[InvoiceYear] AS NVARCHAR(4)) + '-' + CAST([Src].[InvoiceMonth] AS NVARCHAR(2)) + '-01' AS DATE) BETWEEN @sd AND @ed
	GROUP BY
	[InvoiceYear], [InvoiceMonth], [Initials]
	ORDER BY
		[InvoiceYear], [InvoiceMonth], [Initials]


--END


--SELECT * FROM #maintbl ORDER BY [GLYear], [GlMonth], [Dealer]
--SELECT * FROM #maintbl WHERE [Dealer] LIKE '%misc.%' ORDER BY [GLYear], [GlMonth], [Dealer]
--END

SELECT * FROM #tmptable
SELECT * FROM #tmptablePF
SELECT * FROM #tmptableUOO
SELECT * FROM #PeriodEndDates
SELECT * FROM #CostGLCF
SELECT * FROM #CostGLPF
SELECT * FROM #CostJnlCF
SELECT * FROM #CostJnlPF
SELECT * FROM #maintbl