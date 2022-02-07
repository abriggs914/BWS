USE [SysproCompanyA]
GO
--/****** Object:  StoredProcedure [dbo].[sp_PartsSalesSummary]    Script Date: 2022-02-07 10:25:33 AM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO

---- =============================================
---- Author:		<Author,,Name>
---- Create date: <Create Date,,>
---- Description:	<Description,,>
---- =============================================
--ALTER PROCEDURE [dbo].[sp_PartsSalesSummary] 
--	-- Add the parameters for the stored procedure here

DECLARE
	@sd1 datetime, @ed1 datetime, @sd datetime, @ed datetime 
SET @sd = '2022-01-01';
SET @ed = '2022-01-31';
SET @sd1 = '2022-02-01';
SET @ed1 = '2022-02-28';
-- --with recompile
--AS
--BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

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





	

	select convert(float, sum(PriorGrossPrice)) as PriorGrossPrice,
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
	case when convert(float, (sum(PriorGrossPrice - PriorDiscount))) = 0 then 0 else convert(float, (sum(CurrentGrossPrice - CurrentDiscount) - sum(PriorGrossPrice - PriorDiscount)) / sum(PriorGrossPrice - PriorDiscount)) end as [Change%]
	from #maintbl
	group by GlCode



	select [Dealer], convert(float, sum(PriorGrossPrice)) as PriorGrossPrice,
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
	case when convert(float, (sum(PriorGrossPrice - PriorDiscount))) = 0 then 0 else convert(float, (sum(CurrentGrossPrice - CurrentDiscount) - sum(PriorGrossPrice - PriorDiscount)) / sum(PriorGrossPrice - PriorDiscount)) end as [Change%]
	from #maintbl
	group by GlCode, [Dealer]
	
	SELECT * FROM #maintbl
	SELECT * FROM #CostGLCF
	SELECT * FROM #CostGLPF
	SELECT * FROM #CostJnlCF
	SELECT * FROM #CostJnlPF
