USE [SysproCompanyA]
GO
/****** Object:  StoredProcedure [dbo].[sp_DealerPartsSalesSummary]    Script Date: 2022-02-09 10:33:57 AM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO

--ALTER PROCEDURE [dbo].[sp_DealerPartsSalesSummary]
--	@sd datetime, @ed datetime, @sd1 datetime, @ed1 datetime
--AS BEGIN
--USE [BWSdb]
--GO


--	USE [SysproCompanyA]
--GO

----CREATE PROCEDURE [dbo].[sp_DealerPartsSalesSummary]
DECLARE @sd datetime, @ed datetime, @sd1 datetime, @ed1 datetime
----AS BEGIN

 
	
SET @sd = '2018-11-01';
SET @ed = '2022-02-28';
SET @sd1 = '2018-11-01';
SET @ed1 = '2022-02-28';

--SET @sd = '1990-01-01';
--SET @ed = '2030-12-31';
--SET @sd1 = '1990-01-01';
--SET @ed1 = '2030-12-31';

    -- Insert statements for procedure here
	--Dealer Sales Summary - Prelim

	declare @sd2 datetime, @ed2 datetime

	select @sd2 = DATEADD(YEAR, -1, @sd1)
	select @ed2 = DATEADD(YEAR, -1, @ed1)




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
	and GlCode = 5095
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
	and GlCode = 5095
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
	and GlCode = 5095
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
	and GlCode in (4505, 4510)

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
	and GlCode in (4505, 4510)

	union all select Journal, 'Other' as Customer, OriginZoomKey,  MONTH([JnlDate]), YEAR([JnlDate])
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
	and GlCode = 5095
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
	and GlCode = 5095
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
	and GlCode = 5095
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
	and GlCode in (4505, 4510)

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
	and GlCode in (4505, 4510)

	union all select Journal, 'Other' as Customer, OriginZoomKey,  MONTH([JnlDate]), YEAR([JnlDate])
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
	,MONTH(GenTransaction.[JnlDate])
	,YEAR(GenTransaction.[JnlDate])
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
	left outer join BWSdb.dbo.dtSYSPROCustomerInitals with (nolock) on ArTrnDetail.Customer = dtSYSPROCustomerInitals.SYSPROCustomer collate Latin1_General_BIN
	left outer join #CostGLPF as subA on GenTransaction.Journal = subA.Journal AND (subA.[JnlMonth] = MONTH([JnlDate]) AND subA.[JnlYear] = YEAR([JnlDate]))
					 and (case when ArTrnDetail.Customer is null then '1' else ArTrnDetail.Customer end) = subA.Customer collate Latin1_General_BIN
					 and GenTransaction.OriginZoomKey = subA.OriginZoomKey collate Latin1_General_BIN
	where JnlDate between @Localsd1 and @Localed1
	and (case when year(PeriodEndDate) = year(@Localed1) and month(PeriodEndDate) = month(@Localed1) then 1
			  when PeriodEndDate between @Localsd1 and @Localed1 then 1
			  when year(PeriodEndDate) = year(@Localsd1) and month(PeriodEndDate) = month(@Localsd1) then 1
			  else 0 end) = 1
	and GlCode in (4505, 4510)
	group by GlCode, GenTransaction.Journal, Initials, ArTrnDetail.Customer, subA.CostValue
	,MONTH(GenTransaction.[JnlDate])
	,YEAR(GenTransaction.[JnlDate])
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
	,MONTH(GenTransaction.[JnlDate])
	,YEAR(GenTransaction.[JnlDate])
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
	left outer join BWSdb.dbo.dtSYSPROCustomerInitals with (nolock) on ArTrnDetail.Customer = dtSYSPROCustomerInitals.SYSPROCustomer collate Latin1_General_BIN
	left outer join #CostGLPF as subA on GenTransaction.Journal = subA.Journal AND (subA.[JnlMonth] = MONTH([JnlDate]) AND subA.[JnlYear] = YEAR([JnlDate]))
					 and (case when ArTrnDetail.Customer is null then '1' else ArTrnDetail.Customer end) = subA.Customer collate Latin1_General_BIN
					 and GenTransaction.OriginZoomKey = subA.OriginZoomKey collate Latin1_General_BIN
	where JnlDate between @Localsd1 and @Localed1
	and (case when year(PeriodEndDate) = year(@Localed1) and month(PeriodEndDate) = month(@Localed1) then 1
			  when PeriodEndDate between @Localsd1 and @Localed1 then 1
			  when year(PeriodEndDate) = year(@Localsd1) and month(PeriodEndDate) = month(@Localsd1) then 1
			  else 0 end) = 1
	and GlCode in (4505, 4510)
	group by GlCode, GenTransaction.Journal, Initials, ArTrnDetail.Customer, subA.CostValue
	,MONTH(GenTransaction.[JnlDate])
	,YEAR(GenTransaction.[JnlDate])
	--,(GenTransaction.[GlPeriod])
	--,(GenTransaction.[GlYear])

	union all select GlCode, GenTransaction.Journal, 'Other' as Dealer,
	sum(case when EntryValue < 0 then EntryValue else 0 end) * -1 as PriorGrossPrice,
	sum(case when EntryValue > 0 then EntryValue else 0 end) as PriorDiscount, 
	case when subA.CostValue is null then 0 else subA.CostValue end as PriorCOGS,
	0 as CurrentGrossPrice,
	0 as CurrentDiscount,
	0 as CurrentCOGS
	,MONTH(GenTransaction.[JnlDate])
	,YEAR(GenTransaction.[JnlDate])
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
	and GlCode in (4505, 4510)
	and Source <> 'SA'
	group by GlCode, GenTransaction.Journal, subA.Customer, subA.CostValue
	,MONTH(GenTransaction.[JnlDate])
	,YEAR(GenTransaction.[JnlDate])
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
	,MONTH(GenTransaction.[JnlDate])
	,YEAR(GenTransaction.[JnlDate])
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
	left outer join BWSdb.dbo.dtSYSPROCustomerInitals with (nolock) on ArTrnDetail.Customer = dtSYSPROCustomerInitals.SYSPROCustomer collate Latin1_General_BIN
	left outer join #CostGLCF as subA on GenTransaction.Journal = subA.Journal  AND (subA.[JnlMonth] = MONTH([JnlDate]) AND subA.[JnlYear] = YEAR([JnlDate]))
					 and (case when ArTrnDetail.Customer is null then '1' else ArTrnDetail.Customer end) = subA.Customer collate Latin1_General_BIN
					 and GenTransaction.OriginZoomKey = subA.OriginZoomKey collate Latin1_General_BIN
	where JnlDate between @Localsd and @Localed
	and (case when year(PeriodEndDate) = year(@Localed) and month(PeriodEndDate) = month(@Localed) then 1
			  when PeriodEndDate between @Localsd and @Localed then 1
			  when year(PeriodEndDate) = year(@Localsd) and month(PeriodEndDate) = month(@Localsd) then 1
			  else 0 end) = 1
	and GlCode in (4505, 4510)
	group by GlCode, GenTransaction.Journal, Initials, ArTrnDetail.Customer, subA.CostValue
	,MONTH(GenTransaction.[JnlDate])
	,YEAR(GenTransaction.[JnlDate])
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
	,MONTH(GenTransaction.[JnlDate])
	,YEAR(GenTransaction.[JnlDate])
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
	left outer join BWSdb.dbo.dtSYSPROCustomerInitals with (nolock) on ArTrnDetail.Customer = dtSYSPROCustomerInitals.SYSPROCustomer collate Latin1_General_BIN
	left outer join #CostGLCF as subA on GenTransaction.Journal = subA.Journal  AND (subA.[JnlMonth] = MONTH([JnlDate]) AND subA.[JnlYear] = YEAR([JnlDate]))
					 and (case when ArTrnDetail.Customer is null then '1' else ArTrnDetail.Customer end) = subA.Customer collate Latin1_General_BIN
					 and GenTransaction.OriginZoomKey = subA.OriginZoomKey collate Latin1_General_BIN
	where JnlDate between @Localsd and @Localed
	and (case when year(PeriodEndDate) = year(@Localed) and month(PeriodEndDate) = month(@Localed) then 1
			  when PeriodEndDate between @Localsd and @Localed then 1
			  when year(PeriodEndDate) = year(@Localsd) and month(PeriodEndDate) = month(@Localsd) then 1
			  else 0 end) = 1
	and GlCode in (4505, 4510)
	group by GlCode, GenTransaction.Journal, Initials, ArTrnDetail.Customer, subA.CostValue, GenTransaction.[GlPeriod], GenTransaction.[GlYear]
	,MONTH(GenTransaction.[JnlDate])
	,YEAR(GenTransaction.[JnlDate])
	--,(GenTransaction.[GlPeriod])
	--,(GenTransaction.[GlYear])

	union all select GlCode, GenTransaction.Journal, 'Other' as Dealer,
	0 as PriorGrossPrice,
	0 as PriorDiscount, 
	0 as PriorCOGS,
	sum(case when EntryValue < 0 then EntryValue else 0 end) * -1 as CurrentGrossPrice,
	sum(case when EntryValue > 0 then EntryValue else 0 end) as CurrentDiscount,
	case when subA.CostValue is null then 0 else subA.CostValue end as CurrentCOGS
	,MONTH(GenTransaction.[JnlDate])
	,YEAR(GenTransaction.[JnlDate])
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
	and GlCode in (4505, 4510)
	and Source <> 'SA'
	group by GlCode, GenTransaction.Journal, subA.Customer, subA.CostValue
	,MONTH(GenTransaction.[JnlDate])
	,YEAR(GenTransaction.[JnlDate])
	--,(GenTransaction.[GlPeriod])
	--,(GenTransaction.[GlYear])

	insert into #maintbl (GlCode, Journal, Dealer, PriorGrossPrice, PriorDiscount, PriorCOGS, CurrentGrossPrice, CurrentDiscount, CurrentCOGS, [GlMonth], [GlYear])
	select '5095', 0, 'Misc.', 0, 0, sum(a.PriorNetCOGS) - sum(c.PriorGLCOGS), 0, 0, sum(b.CurrentNetCOGS) - sum(c.CurrentGLCOGS)
	, c.[GlMonth], c.[GlYear]
	from (select sum(CostValue) as PriorNetCOGS from #CostGLPF) as a
	cross join (select sum(CostValue) as CurrentNetCOGS from #CostGLCF) as b
	cross join (select sum(PriorCOGS) as PriorGLCOGS, sum(CurrentCOGS) as CurrentGLCOGS, [GlMonth], [GlYear] from #maintbl GROUP BY [GlMonth], [GlYear]) as c
	GROUP BY [GlMonth], [GlYear]


SELECT * FROM #maintbl
SELECT sum(PriorGrossPrice - PriorDiscount) AS [SUM(PriorSellingPrice)], SUM([PriorCOGS]) AS [SUM(PriorCOGS)] FROM #maintbl




	select '5095', 0, 'Misc.', 0, 0,
	sum(a.PriorNetCOGS) - sum(c.PriorGLCOGS) AS [A],
	sum(c.PriorGLCOGS) - sum(a.PriorNetCOGS) AS [B],
	AVG(c.PriorGLCOGS) AS [C],
	sum(a.PriorNetCOGS) AS [D],
	0, 0, sum(b.CurrentNetCOGS) - sum(c.CurrentGLCOGS)
	, c.[GlMonth], c.[GlYear]
	from (select sum(CostValue) as PriorNetCOGS from #CostGLPF) as a
	cross join (select sum(CostValue) as CurrentNetCOGS from #CostGLCF) as b
	cross join (select sum(PriorCOGS) as PriorGLCOGS, sum(CurrentCOGS) as CurrentGLCOGS, [GlMonth], [GlYear] from #maintbl GROUP BY [GlMonth], [GlYear]) as c
	GROUP BY [GlMonth], [GlYear], [c].[PriorGLCOGS]