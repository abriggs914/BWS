USE [BWSdb]
GO


-- 2023-10-26 1340


SELECT
[COMPANY NAME]
,* FROM [OrdersV2] 
INNER JOIN
	[DealersV2]
ON
	[OrdersV2].[DealerID] = [DealersV2].[ID]
WHERE [SGQuote] IN
(
	'SG101131',
	'SG101132',
	'SG101134',
	'SG101329',
	'SG101330',
	'SG101331',
	'SG101332',
	'SG101334',
	'SG101337'
)


--/****** Object:  StoredProcedure [dbo].[sp_OrdersRecapByDealer_SchedulerV2]    Script Date: 2023-10-26 2:43:22 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
---- =============================================
---- Author:		<Author,,Name>
---- Create date: <Create Date,,>
---- Description:	<Description,,>
---- =============================================
--ALTER PROCEDURE [dbo].[sp_OrdersRecapByDealer_SchedulerV2] 
--	-- Add the parameters for the stored procedure here
--AS
--BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--Declare dates
	declare @ytdsd datetime, 
			@ytded datetime = cast(getdate() as date), 
			@glyear decimal(4, 0)

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
	from SysproCompanyS.dbo.GenControl with (nolock) -- <- HERE, YOU WOULD USE WHICHEVER "Control" SQL TABLE BASED ON SYSPRO MODULE YOU WERE WORKING WITHIN! (i.e. Inventory = InvControl)
	where Company = 'S'

	--grab current period end date (if it's there)
	select @SQLselect = 'insert into #PeriodEndDates (GlYear, GLPeriod, PeriodEndDate)
						 select ' + cast(@loopglyear as nvarchar) + ', ' + cast(@loopglperiod as nvarchar) +', CurYrPrdEnd' + cast(@loopglperiod as nvarchar) + ' from SysproCompanyA.dbo.GenControl with (nolock) where Company = ''A'''

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
	while @loopglyear >= (select GlYear - 1 from SysproCompanyS.dbo.GenControl with (nolock) where Company = 'S')
		begin
			if @loopglyear = (select GlYear from SysproCompanyS.dbo.GenControl with (nolock) where Company = 'S')
				begin
					select @SQLselect = 'insert into #PeriodEndDates (GlYear, GLPeriod, PeriodEndDate)
										 select ' + cast(@loopglyear as nvarchar) + ', ' + cast(@loopglperiod as nvarchar) +', CurYrPrdEnd' + cast(@loopglperiod as nvarchar) + ' from SysproCompanyS.dbo.GenControl with (nolock) where Company = ''S'''
				end
			else
				begin
					select @SQLselect = 'insert into #PeriodEndDates (GlYear, GLPeriod, PeriodEndDate)
										 select ' + cast(@loopglyear as nvarchar) + ', ' + cast(@loopglperiod as nvarchar) +', PrvYrPrdEnd' + cast(@loopglperiod as nvarchar) + ' from SysproCompanyS.dbo.GenControl with (nolock) where Company = ''S'''
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

	select @glyear = GlYear
	from #PeriodEndDates
	where MONTH(PeriodEndDate) = month(@ytded)
	and YEAR(PeriodEndDate) = year(@ytded)

	select top (1) @ytdsd = DATEADD(mm, DATEDIFF(mm, 0, PeriodEndDate), 0)
	from #PeriodEndDates
	where GlYear = @glyear
	order by PeriodEndDate asc


	select 'INIT' AS [T], case when Initials = 'BWS' then 4
				when [COMPANY NAME] = 'BWS - CDN Direct Sales' then 3
				when [OrdersV2].[US Sale] = 0 then 2
				when [COMPANY NAME] = 'BWS - US Direct Sales' then 1
				when [OrdersV2].[US Sale] = 1 then 0 end as CountrySort,
	case when Initials = 'BWS' then 2
		 when [COMPANY NAME] = 'BWS - CDN Direct Sales' or [OrdersV2].[US Sale] = 0 then 1
		 when [COMPANY NAME] = 'BWS - US Direct Sales' or [OrdersV2].[US Sale] = 1 then 0 end as CountryGroup, 
	case when Initials = 'BWS' then 'Stock' 
		 when [COMPANY NAME] = 'BWS - CDN Direct Sales' then 'BWS CDN'
		 when [OrdersV2].[US Sale] = 0 then 'CDN'
		 when [COMPANY NAME] = 'BWS - US Direct Sales' then 'BWS US' 
		 when [OrdersV2].[US Sale] = 1 then 'US'
		 end as Country, 
	[COMPANY NAME], [SGQuote], WO#, [Quote Date], [Order Date], [PO Date], 
	[Date Declined], [Date Registered], [US Sale], Initials, [Decline/Rejected]
	from [OrdersV2] with (nolock)
	inner join [DealersV2] with (nolock) on [OrdersV2].DealerID = [DealersV2].ID
	WHERE [Date Declined] IS NULL
	and [Quote Date] between @ytdsd and @ytded
	ORDER BY [COMPANY NAME], [SGQuote]

	--Grab Country and Dealer sorting and associated Quote date information for fast referencing
	--Drop and create temp table in tmpdb SQL database for faster processing
	IF OBJECT_ID('tempdb..#OrdersRecapByDealer_CountyInfo_STG') IS NOT NULL
		DROP TABLE #OrdersRecapByDealer_CountyInfo_STG

	create table #OrdersRecapByDealer_CountyInfo_STG 
	(
		CountrySort int,
		CountryGroup int,
		Country nvarchar(10),
		Dealer nvarchar(50),
		Quote NVARCHAR(MAX),
		WO int,
		[Quote Date] datetime,
		[Order Date] datetime,
		[PO Date] datetime,
		[Date Declined] datetime,
		[Date Registered] datetime,
		[US Sale] bit,
		Initials nvarchar(255),
		DeclineRej int
	)

	insert into #OrdersRecapByDealer_CountyInfo_STG
	select case when Initials = 'BWS' then 4
				when [COMPANY NAME] = 'BWS - CDN Direct Sales' then 3
				when [OrdersV2].[US Sale] = 0 then 2
				when [COMPANY NAME] = 'BWS - US Direct Sales' then 1
				when [OrdersV2].[US Sale] = 1 then 0 end as CountrySort,
	case when Initials = 'BWS' then 2
		 when [COMPANY NAME] = 'BWS - CDN Direct Sales' or [OrdersV2].[US Sale] = 0 then 1
		 when [COMPANY NAME] = 'BWS - US Direct Sales' or [OrdersV2].[US Sale] = 1 then 0 end as CountryGroup, 
	case when Initials = 'BWS' then 'Stock' 
		 when [COMPANY NAME] = 'BWS - CDN Direct Sales' then 'BWS CDN'
		 when [OrdersV2].[US Sale] = 0 then 'CDN'
		 when [COMPANY NAME] = 'BWS - US Direct Sales' then 'BWS US' 
		 when [OrdersV2].[US Sale] = 1 then 'US'
		 end as Country, 
	[COMPANY NAME], [SGQuote], WO#, [Quote Date], [Order Date], [PO Date], 
	[Date Declined], [Date Registered], [US Sale], Initials, [Decline/Rejected]
	from [OrdersV2] with (nolock)
	inner join [DealersV2] with (nolock) on [OrdersV2].DealerID = [DealersV2].ID
	WHERE [Date Declined] IS NULL
	and [Quote Date] between @ytdsd and @ytded
	--AND ISNULL([Delivery Date] , DATEADD(DAY, 1, GETDATE())) > GETDATE()

	SELECT '--' AS [T], * FROM [#OrdersRecapByDealer_CountyInfo_STG] ORDER BY [Dealer], [Quote]

	--Drop and create temp table in tmpdb SQL database for faster processing
	IF OBJECT_ID('tempdb..#OrdersRecapByDealer') IS NOT NULL
		DROP TABLE #OrdersRecapByDealer

	create table #OrdersRecapByDealer
	(
		Country char(10),
		CountryGroup int,
		CountrySort int,
		Dealer nvarchar(50),
		[#Quotes] int default (0),
		--[#Quotes] NVARCHAR(MAX) DEFAULT(''),
		[$Quotes] money default (0),
		[#QuotesPerCountry] int default(0),
		[$QuotesPerCountry] money default (0),
		[#Orders] int default (0),
		[$Orders] money default (0),
		[#OrdersPerCountry] int default (0),
		[$OrdersPerCountry] money default (0),
		[QuotesToOrders%] decimal(14, 2),
		[$OrderPotential] as ([$Quotes] - [$Orders]),
		[QuotesToOrdersPerCountry%] decimal(14, 2),
		[$OrderPotentialPerCountry] as ([$QuotesPerCountry] - [$OrdersPerCountry]),
		--[#OutQuotes] int default (0),
		[#OutQuotes] NVARCHAR(MAX) DEFAULT(''),
		[OutQuotesDays] int default(0),
		[OutQuotesModelNo] nvarchar(255),
		[$OutQuotes] money default (0)
	)	

	--SELECT * FROM [#OrdersRecapByDealer_CountyInfo_STG]
	--SELECT * FROM [v_Quote Raw Pricing V2]

	--Insert Outstanding Quotes that has been quoted in the last 90 days
	insert into #OrdersRecapByDealer (Country, CountryGroup, CountrySort, Dealer, #OutQuotes, OutQuotesModelNo, OutQuotesDays, [$OutQuotes])
	select Country, CountryGroup, CountrySort, Dealer, [SGQuote], [Model No],
	case when OrderInfo.[Quote Date] is null then 0 else datediff(day, OrderInfo.[Quote Date], getdate()) end as Days, 
	case when [Net Price] is null then 0 else [Net Price] end
	from #OrdersRecapByDealer_CountyInfo_STG as OrderInfo
	inner join [v_Quote Raw Pricing V2] on OrderInfo.Quote = [v_Quote Raw Pricing V2].[SGQuote]
	where WO is null
	and OrderInfo.[Order Date] is null
	and OrderInfo.[Date Declined] is null
	and OrderInfo.[PO Date] is null
	and DeclineRej = 4
	and (OrderInfo.[Quote Date] is null or datediff(day, OrderInfo.[Quote Date], getdate()) <= 90)

	--Ensure ALL groups appear
	insert into #OrdersRecapByDealer (Country, CountryGroup, CountrySort)
	select mainsub.Country, mainsub.CountryGroup, mainsub.CountrySort
	from (select 0 as CountrySort, 0 as CountryGroup, 'US' as Country
		  union all select 1, 0, 'BWS US'
		  union all select 2, 1, 'CDN'
		  union all select 3, 1, 'BWS CDN'
		  union all select 4, 2, 'BWS') as mainsub
	left outer join #OrdersRecapByDealer as maintbl on mainsub.CountrySort = maintbl.CountrySort
	where maintbl.CountrySort is null

	
	SELECT '-A' AS [T], * FROM #OrdersRecapByDealer --WHERE [CountryGroup] = 1

	--Add YTD Quotes data
	update #OrdersRecapByDealer
	set #Quotes = b.Quotes,
		[$Quotes] = b.Value
	from #OrdersRecapByDealer as a 
	inner join (select Country, CountrySort, Dealer,
				count(*) as Quotes,
				sum([Net Price]) as Value
				from #OrdersRecapByDealer_CountyInfo_STG as OrderInfo
				inner join [v_Quote Raw Pricing V2] on OrderInfo.Quote = [v_Quote Raw Pricing V2].[SGQuote]
				WHERE     ((OrderInfo.WO < 30000000) OR
										(OrderInfo.WO IS NULL))
				and OrderInfo.[Quote Date] between @ytdsd and @ytded
				group by Country, CountrySort, Dealer) as b on a.CountrySort = b.CountrySort
															   and a.Dealer = b.Dealer

															   
	SELECT '-B' AS [T], * FROM #OrdersRecapByDealer ORDER BY [Dealer] --WHERE [CountryGroup] = 1
	SELECT '-B1' AS [T], * FROM #OrdersRecapByDealer_CountyInfo_STG ORDER BY [Dealer] --WHERE [CountryGroup] = 1
	SELECT '-B2' AS [T], * FROM [v_Quote Raw Pricing V2] ORDER BY [COMPANY NAME]

	--MAKE SURE TO INSERT MISSING RECORDS FOR DEALERS THAT HAVE NO O/S QUOTES
	

	SELECT @ytdsd AS [ST], @ytded AS [ED]

	select '-E' AS [T], OrderInfo.Country, OrderInfo.CountryGroup, OrderInfo.CountrySort, OrderInfo.Dealer, *
	--,
	--count(*) as Quotes,
	--sum([Net Price]) as Value
	from #OrdersRecapByDealer_CountyInfo_STG as OrderInfo
	inner join [v_Quote Raw Pricing V2] on OrderInfo.Quote = [v_Quote Raw Pricing V2].[SGQuote]
	left outer join #OrdersRecapByDealer as MainTable on OrderInfo.CountrySort = MainTable.CountrySort
														 and OrderInfo.Dealer = MainTable.Dealer
	--left outer join [DealersV2] on OrderInfo.[Dealer] = [DealersV2].[COMPANY NAME]
	--													 and OrderInfo.Dealer = MainTable.Dealer
	--													 AND [DealersV2].[CompanyID] = 1
	WHERE     ((OrderInfo.WO < 30000000) OR
							(OrderInfo.WO IS NULL))
	and OrderInfo.[Quote Date] between @ytdsd and @ytded
	and MainTable.Dealer is null
	--group by OrderInfo.Country, OrderInfo.CountryGroup, OrderInfo.CountrySort, OrderInfo.Dealer
	ORDER BY [OrderInfo].[Dealer], [Quote]
	--OrderInfo.Country, OrderInfo.CountryGroup, OrderInfo.CountrySort, OrderInfo.Dealer


	insert into #OrdersRecapByDealer (Country, CountryGroup, CountrySort, Dealer, #Quotes, [$Quotes])
	select OrderInfo.Country, OrderInfo.CountryGroup, OrderInfo.CountrySort, OrderInfo.Dealer,
	count(*) as Quotes,
	sum([Net Price]) as Value
	from #OrdersRecapByDealer_CountyInfo_STG as OrderInfo
	inner join [v_Quote Raw Pricing V2] on OrderInfo.Quote = [v_Quote Raw Pricing V2].[SGQuote]
	left outer join #OrdersRecapByDealer as MainTable on OrderInfo.CountrySort = MainTable.CountrySort
														 and OrderInfo.Dealer = MainTable.Dealer
	WHERE     ((OrderInfo.WO < 30000000) OR
							(OrderInfo.WO IS NULL))
	and OrderInfo.[Quote Date] between @ytdsd and @ytded
	and MainTable.Dealer is null
	group by OrderInfo.Country, OrderInfo.CountryGroup, OrderInfo.CountrySort, OrderInfo.Dealer


	
	SELECT '-C' AS [T], * FROM #OrdersRecapByDealer ORDER BY [Dealer] --WHERE [CountryGroup] = 1


	--Add YTD Orders data
	update #OrdersRecapByDealer
	set #Orders = b.Orders,
		[$Orders] = b.Value
	from #OrdersRecapByDealer as a 
	inner join (select Country, CountrySort, Dealer,
				count(*) as Orders,
				sum([Net Price]) as Value
				from #OrdersRecapByDealer_CountyInfo_STG as OrderInfo
				inner join [v_Quote Raw Pricing V2] on OrderInfo.Quote = [v_Quote Raw Pricing V2].[SGQuote]
				WHERE     ((OrderInfo.WO < 30000000) OR
										(OrderInfo.WO IS NULL))
				and OrderInfo.[PO Date] between @ytdsd and @ytded
				group by Country, CountrySort, Dealer) as b on a.CountrySort = b.CountrySort
															   and a.Dealer = b.Dealer

	
	SELECT '-D' AS [T], * FROM #OrdersRecapByDealer ORDER BY [Dealer]  --WHERE [CountryGroup] = 1

	--MAKE SURE TO INSERT MISSING RECORDS FOR DEALERS THAT HAVE NO O/S QUOTES
	insert into #OrdersRecapByDealer (Country, CountryGroup, CountrySort, Dealer, #Orders, [$Orders])
	select OrderInfo.Country, OrderInfo.CountryGroup, OrderInfo.CountrySort, OrderInfo.Dealer,
	count(*) as Orders,
	sum([Net Price]) as Value
	from #OrdersRecapByDealer_CountyInfo_STG as OrderInfo
	inner join [v_Quote Raw Pricing V2] on OrderInfo.Quote = [v_Quote Raw Pricing V2].[SGQuote]
	left outer join #OrdersRecapByDealer as MainTable on OrderInfo.CountrySort = MainTable.CountrySort
														 and OrderInfo.Dealer = MainTable.Dealer
	WHERE     ((OrderInfo.WO < 30000000) OR
							(OrderInfo.WO IS NULL))
	and OrderInfo.[PO Date] between @ytdsd and @ytded
	and MainTable.Dealer is null
	group by OrderInfo.Country, OrderInfo.CountryGroup, OrderInfo.CountrySort, OrderInfo.Dealer



	select OrderInfo.Country, OrderInfo.CountryGroup, OrderInfo.CountrySort, OrderInfo.Dealer,
	count(*) as Orders,
	sum([Net Price]) as Value
	from #OrdersRecapByDealer_CountyInfo_STG as OrderInfo
	inner join [v_Quote Raw Pricing V2] on OrderInfo.Quote = [v_Quote Raw Pricing V2].[SGQuote]
	left outer join #OrdersRecapByDealer as MainTable on OrderInfo.CountrySort = MainTable.CountrySort
														 and OrderInfo.Dealer = MainTable.Dealer
	WHERE     ((OrderInfo.WO < 30000000) OR
							(OrderInfo.WO IS NULL))
	and OrderInfo.[PO Date] between @ytdsd and @ytded
	and MainTable.Dealer is null
	group by OrderInfo.Country, OrderInfo.CountryGroup, OrderInfo.CountrySort, OrderInfo.Dealer


	SELECT 'PRE COUNTRY' AS [T], * FROM #OrdersRecapByDealer ORDER BY [Dealer] --WHERE [CountryGroup] = 1

	--Add country summary values
	update #OrdersRecapByDealer
	set #QuotesPerCountry = b.#Quotes,
		[$QuotesPerCountry] = b.[$Quotes],
		#OrdersPerCountry = b.#Orders,
		[$OrdersPerCountry] = b.[$Orders]
	from #OrdersRecapByDealer as a
	inner join (select Country, CountryGroup, CountrySort,
				SUM(#Quotes) as #Quotes, sum([$Quotes]) as [$Quotes], sum(#Orders) as #Orders, sum([$Orders]) as [$Orders]
				from (select distinct Country, CountryGroup, CountrySort, Dealer, 
					  #Quotes, [$Quotes], #Orders, [$Orders] from #OrdersRecapByDealer) as subA
				group by Country, CountryGroup, CountrySort) as b on a.Country = b.Country
																	 and a.CountryGroup = b.CountryGroup
																	 and a.CountrySort = b.CountrySort

	--Update Quotes to Orders % value
	update #OrdersRecapByDealer
	set [QuotesToOrders%] = case when #Quotes = 0 then 0 else cast(#Orders as decimal(14, 0)) / cast(#Quotes as decimal(14, 0)) end,
		[QuotesToOrdersPerCountry%] = case when #QuotesPerCountry = 0 then 0 else cast(#OrdersPerCountry as decimal(14, 0)) / cast(#QuotesPerCountry as decimal(14, 0)) end

	--Remove groups where there is no data
	delete from #OrdersRecapByDealer
	where Dealer is null
	and OutQuotesModelNo is null

	--Final select statement
	select *, @ytdsd as StartDate, @ytded as EndDate 
	from #OrdersRecapByDealer

	SELECT *, @ytdsd as StartDate, @ytded as EndDate 
	FROM #OrdersRecapByDealer 
	--WHERE [CountryGroup] = 1
	ORDER BY [Dealer]

--END
