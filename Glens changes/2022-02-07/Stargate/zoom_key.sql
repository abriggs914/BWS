
DECLARE
	@sd datetime, @ed datetime, @sd1 datetime, @ed1 datetime

SET @sd = '2018-11-01';
SET @ed = '2022-02-01';
SET @sd1 = '2018-11-01';
SET @ed1 = '2022-02-01';


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

	
	SELECT TOP 200 * FROM ArTrnDetail
	SELECT * FROM GenTransaction

	-- !!! THE ZOOM KEY inner join is wrong!