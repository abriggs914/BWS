USE BWSdb
GO

EXEC sp_OrdersRecapByDealer_SchedulerV2

DECLARE @ytdsd DATETIME = '2023-12-01';
DECLARE @ytded DATETIME = '2023-12-04 23:59:59';

SELECT * FROM [OrdersV2] WHERE [Quote Date] BETWEEN @ytdsd AND @ytded


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

	
SELECT
	*
FROM
	[Orders]
WHERE 
	[DateLastQuoteReport] IS NOT NULL
SELECT
	*
FROM
	[OrdersV2]
WHERE 
	[DateLastQuoteReport] IS NOT NULL
