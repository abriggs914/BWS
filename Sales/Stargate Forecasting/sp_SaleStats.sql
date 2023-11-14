USE [BWSdb]
GO
/****** Object:  StoredProcedure [dbo].[sp_SaleStats]    Script Date: 2023-11-09 12:52:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--2022-09-28 James Crawford - Added where clause to exclude 3 Half Round Work Orders from reports: 10015030 - 10015032
--IT Request #001197
--2023-11-09 Avery Briggs - Stargate version
--IT Request #001197

CREATE PROCEDURE [dbo].[sp_SaleStatsV2] 
	-- Add the parameters for the stored procedure here
	@sd datetime, @ed datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--Drop and create temp table in tmpdb SQL database for faster processing
	IF OBJECT_ID('tempdb..#SalesStats') IS NOT NULL
		DROP TABLE #SalesStats 

	create table #SalesStats
	(
		Country nvarchar(10),
		CountryGroup int,
		CountrySort int,
		[#OpeningOrderBook] int,
		[$OpeningOrderBook] int,
		[#OpeningOSQuotes] int,
		[$OpeningOSQuotes] int,
		[#OpeningInventory] int,
		[$OpeningInventory] int,
		[#NewQuotes] int,
		[$NewQuotes] int,
		[#NewOrders] int,
		[$NewOrders] int,
		[#QuotesCancelled] int,
		[$QuotesCancelled] int,
		[#OrdersCancelled] int,
		[$OrdersCancelled] int,
		[#OrdersCompleted] int,
		[$OrdersCompleted] int,
		[#Invoiced] int,
		[$Invoiced] int,
		[#RegisteredSales] int,
		[$RegisteredSales] int,
		[#ClosingOrderBook] int,
		[$ClosingOrderBook] int,
		[#ClosingOSQuotes] int,
		[$ClosingOSQuotes] int,
		[#ClosingInventory] int,
		[$ClosingInventory] int,
		[#NetChangeOrders] as ([#ClosingOrderBook] - [#OpeningOrderBook]),
		[$NetChangeOrders] as ([$ClosingOrderBook] - [$OpeningOrderBook])
	)

	--Grab Country sorting and associated Quote date information for fast referencing
	IF OBJECT_ID('tempdb..#SalesStats_CountyInfo') IS NOT NULL
		DROP TABLE #SalesStats_CountyInfo 

	create table #SalesStats_CountyInfo
	(
		CountrySort int,
		CountryGroup int,
		Country nvarchar(10),
		Quote NVARCHAR(8),
		WO int,
		Class nvarchar(255),
		[Quote Date] datetime,
		[Order Date] datetime,
		[PO Date] datetime,
		[Date Declined] datetime,
		[Date Registered] datetime,
		[Date In Service] datetime,
		[Shipped Date] datetime,
		[Invoice Date] datetime,
		[US Sale] bit,
		[Net Price] int,
		DeclineRej int,
		CurrentCDN bit,
		CurrentUS bit,
		Dealer nvarchar(50)
	)

	insert into #SalesStats_CountyInfo
	select distinct case when [DealersV2].Initials = 'BWS' then 4
						 when [DealersV2].[COMPANY NAME] = 'BWS - CDN Direct Sales' then 3
						 when [OrdersV2].[US Sale] = 0 then 2
						 when [DealersV2].[COMPANY NAME] = 'BWS - US Direct Sales' then 1
						 when [OrdersV2].[US Sale] = 1 then 0 end as CountrySort,
	case when [DealersV2].Initials = 'BWS' then 2
		 when [DealersV2].[COMPANY NAME] = 'BWS - CDN Direct Sales' or [OrdersV2].[US Sale] = 0 then 1
		 when [DealersV2].[COMPANY NAME] = 'BWS - US Direct Sales' or [OrdersV2].[US Sale] = 1 then 0 end as CountryGroup, 
	case when [DealersV2].Initials = 'BWS' then 'Stock' 
		 when [DealersV2].[COMPANY NAME] = 'BWS - CDN Direct Sales' then 'BWS CDN'
		 when [OrdersV2].[US Sale] = 0 then 'CDN'
		 when [DealersV2].[COMPANY NAME] = 'BWS - US Direct Sales' then 'BWS US' 
		 when [OrdersV2].[US Sale] = 1 then 'US'
		 end as Country, 
	[OrdersV2].[SGQuote], WO#, [ProductsV2].Class, [OrdersV2].[Quote Date], [OrdersV2].[Order Date], [OrdersV2].[PO Date], 
	[OrdersV2].[Date Declined], [Date Registered], [Date In Service], [Shipped Date], 
	case when SysproCompanyS.dbo.v_CompletedJobInfo.EntInvoiceDate is null then [OrdersV2].[Invoice Date] else SysproCompanyS.dbo.v_CompletedJobInfo.EntInvoiceDate end,
	[US Sale], [Net Price], [Decline/Rejected], [CURRENT DEALER CDN], [CURRENT DEALER US], [DealersV2].[COMPANY NAME]
	from [BWSdb].[dbo].[OrdersV2] with (nolock)
	inner join [BWSdb].[dbo].[v_Quote Raw Pricing V2] on [OrdersV2].[SGQuote] = [v_Quote Raw Pricing V2].[SGQuote]
	inner join [BWSdb].[dbo].[DealersV2] with (nolock) on [OrdersV2].DealerID = [DealersV2].ID
	inner join [BWSdb].[dbo].[ProductsV2] with (nolock) on [OrdersV2].[Model No] = [ProductsV2].[Model No]
	left outer join SysproCompanyS.dbo.v_CompletedJobInfo on CAST([OrdersV2].WO# as varchar(20)) COLLATE Latin1_General_BIN = SysproCompanyS.dbo.v_CompletedJobInfo.Job 
	and (
			--[OrdersV2].WO# not in (10015030, 10015031, 10015032)
			--or
			[OrdersV2].WO# is null
		)
	;

	--Opening and Closing Order Book
	insert into #SalesStats (Country, CountryGroup, CountrySort, [#OpeningOrderBook], [$OpeningOrderBook], [#ClosingOrderBook], [$ClosingOrderBook])
	select Country, CountryGroup, CountrySort,
	count(case when (orders.[Po Date] is not null and orders.[Po Date] <= @sd)
							and ([v_Order Book Detail v2_All].[Invoice Date] is null or [v_Order Book Detail v2_All].[Invoice Date] > @sd)
							and (orders.[Date Declined] is null or (orders.[Date Declined] > @sd /*and DeclineRej <> 8*/)) then Orders.Quote end) as [#OpeningOrderBook],
	cast(sum(case when (orders.[Po Date] is not null and orders.[Po Date] <= @sd)
						and ([v_Order Book Detail v2_All].[Invoice Date] is null or [v_Order Book Detail v2_All].[Invoice Date] > @sd)
						and (orders.[Date Declined] is null or (orders.[Date Declined] > @sd /*and DeclineRej <> 8*/)) and Orders.[US Sale] = 0 then [Selling Price] 
				  when (orders.[Po Date] is not null and orders.[Po Date] <= @sd)
						and ([v_Order Book Detail v2_All].[Invoice Date] is null or [v_Order Book Detail v2_All].[Invoice Date] > @sd)
						and (orders.[Date Declined] is null or (orders.[Date Declined] > @sd /*and DeclineRej <> 8*/)) and Orders.[US Sale] = 1 then [Selling Price] * SellExchangeRate end) as decimal(14, 0)) as [$OpeningOrderBook],
	count(case when (orders.[Po Date] is not null and orders.[Po Date] <= @ed)
					 and ([v_Order Book Detail v2_All].[Invoice Date] is null or [v_Order Book Detail v2_All].[Invoice Date] > @ed)
					 and (orders.[Date Declined] is null or (orders.[Date Declined] > @ed /*and DeclineRej <> 8*/)) then Orders.Quote end) as [#ClosingOrderBook],
	cast(sum(case when (orders.[Po Date] is not null and orders.[Po Date] <= @ed)
						and ([v_Order Book Detail v2_All].[Invoice Date] is null or [v_Order Book Detail v2_All].[Invoice Date] > @ed)
						and (orders.[Date Declined] is null or (orders.[Date Declined] > @ed /*and DeclineRej <> 8*/)) and Orders.[US Sale] = 0 then [Selling Price] 
				  when (orders.[Po Date] is not null and orders.[Po Date] <= @ed)
						and ([v_Order Book Detail v2_All].[Invoice Date] is null or [v_Order Book Detail v2_All].[Invoice Date] > @ed)
						and (orders.[Date Declined] is null or (orders.[Date Declined] > @ed /*and DeclineRej <> 8*/)) and Orders.[US Sale] = 1 then [Selling Price] * SellExchangeRate end) as decimal(14, 0)) as [$ClosingOrderBook]
	from #SalesStats_CountyInfo as Orders
	inner join [Stargatedb].[dbo].[v_Order Book Detail v2_All] with (nolock) on Orders.Quote = [v_Order Book Detail v2_All].[SGQuote]
	cross join (select SellExchangeRate from SysproCompanyS.dbo.TblCurrency with (nolock)
				where Currency = 'US') as subA
	group by Country, CountryGroup, CountrySort
	;

	----Include Stock units on "Stock" line
	--update #SalesStats
	--set #OpeningOrderBook = b.#OpeningOrderBook,
	--	[$OpeningOrderBook] = b.[$OpeningOrderBook],
	--	#ClosingOrderBook = b.#ClosingOrderBook,
	--	[$ClosingOrderBook] = b.[$ClosingOrderBook]
	--from #SalesStats as a
	--inner join (select CountrySort,
	--			count(case when (orders.[Po Date] is not null and orders.[Po Date] <= @sd)
	--									and ([v_Order Book Detail v2_All].[Invoice Date] is null or [v_Order Book Detail v2_All].[Invoice Date] > @sd)
	--									and (orders.[Date Declined] is null or (orders.[Date Declined] > @sd and DeclineRej <> 8))
	--									and (ActCompleteDate is null or ActCompleteDate > @sd) then Orders.Quote end) as [#OpeningOrderBook],
	--			cast(sum(case when (orders.[Po Date] is not null and orders.[Po Date] <= @sd)
	--								and ([v_Order Book Detail v2_All].[Invoice Date] is null or [v_Order Book Detail v2_All].[Invoice Date] > @sd)
	--								and (orders.[Date Declined] is null or (orders.[Date Declined] > @sd and DeclineRej <> 8))
	--								and (ActCompleteDate is null or ActCompleteDate > @sd) and Orders.[US Sale] = 0 then [Selling Price] 
	--						  when (orders.[Po Date] is not null and orders.[Po Date] <= @sd)
	--								and ([v_Order Book Detail v2_All].[Invoice Date] is null or [v_Order Book Detail v2_All].[Invoice Date] > @sd)
	--								and (orders.[Date Declined] is null or (orders.[Date Declined] > @sd and DeclineRej <> 8))
	--								and (ActCompleteDate is null or ActCompleteDate > @sd) and Orders.[US Sale] = 1 then [Selling Price] * SellExchangeRate end) as decimal(14, 0)) as [$OpeningOrderBook],
	--			count(case when (orders.[Po Date] is not null and orders.[Po Date] <= @ed)
	--							 and ([v_Order Book Detail v2_All].[Invoice Date] is null or [v_Order Book Detail v2_All].[Invoice Date] > @ed)
	--							 and (orders.[Date Declined] is null or (orders.[Date Declined] > @ed and DeclineRej <> 8))
	--							 and (ActCompleteDate is null or ActCompleteDate > @ed) then Orders.Quote end) as [#ClosingOrderBook],
	--			cast(sum(case when (orders.[Po Date] is not null and orders.[Po Date] <= @ed)
	--								and ([v_Order Book Detail v2_All].[Invoice Date] is null or [v_Order Book Detail v2_All].[Invoice Date] > @ed)
	--								and (orders.[Date Declined] is null or (orders.[Date Declined] > @ed and DeclineRej <> 8))
	--								and (ActCompleteDate is null or ActCompleteDate > @ed) and Orders.[US Sale] = 0 then [Selling Price] 
	--						  when (orders.[Po Date] is not null and orders.[Po Date] <= @ed)
	--								and ([v_Order Book Detail v2_All].[Invoice Date] is null or [v_Order Book Detail v2_All].[Invoice Date] > @ed)
	--								and (orders.[Date Declined] is null or (orders.[Date Declined] > @ed and DeclineRej <> 8))
	--								and (ActCompleteDate is null or ActCompleteDate > @ed) and Orders.[US Sale] = 1 then [Selling Price] * SellExchangeRate end) as decimal(14, 0)) as [$ClosingOrderBook]
	--			from #SalesStats_CountyInfo as Orders
	--			inner join [v_Order Book Detail v2_All] with (nolock) on Orders.Quote = [v_Order Book Detail v2_All].Quote#
	--			left outer join SysproCompanyA.dbo.v_CompletedJobInfo with (nolock) on cast(Orders.WO as char(8)) = v_CompletedJobInfo.Job
	--			cross join (select SellExchangeRate from SysproCompanyA.dbo.TblCurrency with (nolock)
	--						where Currency = 'US') as subA
	--			where CountrySort = 4
	--			group by CountrySort) as b on a.CountrySort = b.CountrySort

	--Ensure ALL groups appear
	insert into #SalesStats (Country, CountryGroup, CountrySort)
	select mainsub.Country, mainsub.CountryGroup, mainsub.CountrySort
	from (select 0 as CountrySort, 0 as CountryGroup, 'US' as Country
		  union all select 1, 0, 'BWS US'
		  union all select 2, 1, 'CDN'
		  union all select 3, 1, 'BWS CDN'
		  union all select 4, 2, 'Stock') as mainsub
	left outer join #SalesStats as maintbl on mainsub.CountrySort = maintbl.CountrySort
	where maintbl.CountrySort is null
	;
	
	--Opening and Closing O/S Quotes, New Quotes, New Orders and Quotes Cancelled
	update #SalesStats
	set [#OpeningOSQuotes] = b.[#OpeningOSQuotes],
	[$OpeningOSQuotes] = b.[$OpeningOSQuotes],
	[#NewQuotes] = b.[#NewQuotes],
	[$NewQuotes] = b.[$NewQuotes],
	[#NewOrders] = b.[#NewOrders],
	[$NewOrders] = b.[$NewOrders],
	[#QuotesCancelled] = b.[#QuotesCancelled],
	[$QuotesCancelled] = b.[$QuotesCancelled],
	[#OrdersCancelled] = b.[#OrdersCancelled],
	[$OrdersCancelled] = b.[$OrdersCancelled],
	[#OrdersCompleted] = b.[#OrdersCompleted],
	[$OrdersCompleted] = b.[$OrdersCompleted],
	[#Invoiced] = c.[#Invoiced],
	[$Invoiced] = c.[$Invoiced],
	[#RegisteredSales] = d.[#RegisteredSales],
	[$RegisteredSales] = d.[$RegisteredSales],
	[#ClosingOSQuotes] = b.[#ClosingOSQuotes],
	[$ClosingOSQuotes] = b.[$ClosingOSQuotes]
	from #SalesStats as a
	left outer join (select CountrySort,
					count(case when Orders.[Quote Date] between @sd and @ed then Orders.Quote end) as [#NewQuotes],
					sum(case when Orders.[Quote Date] between @sd and @ed then [Net Price] else 0 end) as [$NewQuotes],
					count(case when Orders.[PO Date] between @sd and @ed then Orders.Quote end) as [#NewOrders],
					sum(case when Orders.[PO Date] between @sd and @ed then [Net Price] else 0 end) as [$NewOrders],
					count(case when Orders.[Date Declined] between @sd and @ed and DeclineRej <> 8 then Orders.Quote end) as [#QuotesCancelled],
					sum(case when Orders.[Date Declined] between @sd and @ed and DeclineRej <> 8 then [Net Price] else 0 end) as [$QuotesCancelled],
					count(case when Orders.[Date Declined] between @sd and @ed and DeclineRej <> 8 and Orders.[PO Date] is not null then Orders.Quote end) as [#OrdersCancelled],
					sum(case when Orders.[Date Declined] between @sd and @ed and DeclineRej <> 8 and Orders.[PO Date] is not null then [Net Price] else 0 end) as [$OrdersCancelled],
					count(case when ActCompleteDate between @sd and @ed then Orders.Quote end) as [#OrdersCompleted],
					sum(case when ActCompleteDate between @sd and @ed then [Net Price] else 0 end) as [$OrdersCompleted],
					count(case when (Orders.[Date Declined] is null or (Orders.[Date Declined] > @sd and DeclineRej <> 8))
									and (Orders.[PO Date] is null or Orders.[PO Date] >= @sd)
									and Orders.[Quote Date] < @sd then Orders.Quote end) as [#OpeningOSQuotes],
					sum(case when (Orders.[Date Declined] is null or (Orders.[Date Declined] > @sd and DeclineRej <> 8))
									and (Orders.[PO Date] is null or Orders.[PO Date] >= @sd)
									and Orders.[Quote Date] < @sd then [Net Price] else 0 end) as [$OpeningOSQuotes],
					count(case when (Orders.[Date Declined] is null or (Orders.[Date Declined] > @ed and DeclineRej <> 8))
									and (Orders.[PO Date] is null or Orders.[PO Date] >= @ed)
									and Orders.[Quote Date] <= @ed then Orders.Quote end) as [#ClosingOSQuotes],
					sum(case when (Orders.[Date Declined] is null or (Orders.[Date Declined] > @ed and DeclineRej <> 8))
									and (Orders.[PO Date] is null or Orders.[PO Date] >= @ed)
									and Orders.[Quote Date] <= @ed then [Net Price] else 0 end) as [$ClosingOSQuotes]
					from #SalesStats_CountyInfo as Orders
					left outer join SysproCompanyS.dbo.v_CompletedJobInfo with (nolock) on cast(Orders.WO as varchar(20)) = v_CompletedJobInfo.Job
					group by CountrySort) as b on a.CountrySort = b.CountrySort
	left outer join (select CountrySort, 
					sum(UnitCount) as [#Invoiced], 
					sum([Net Cost]) as [$Invoiced]
					from #SalesStats_CountyInfo as Orders
					inner join [Stargatedb].[dbo].dtSalesPerformance with (nolock) on Orders.WO = dtSalesPerformance.WO#
					where dtSalesPerformance.[Invoice Date] between @sd and @ed
					and UnitExcl = 1
					and (case when Dealer = 'Demountable Concepts, Inc.' and Class = 'Container Chassis' then 0 else 1 end) = 1
					and Dealer <> 'Hale Trailer Brake & Wheel'
					--and WO# not in (10015030, 10015031, 10015032)
					group by CountrySort) as c on a.CountrySort = c.CountrySort
	left outer join (select CountrySort, 
					 sum(UnitCount) as [#RegisteredSales],
					 sum([Net Price]) as [$RegisteredSales]
					 from #SalesStats_CountyInfo as Orders
					 inner join [Stargatedb].[dbo].dtSalesPerformance on Orders.WO = dtSalesPerformance.WO#
					 where [Date In Service] between @sd and @ed
					 and dtSalesPerformance.[Invoice Date] <= @ed
					 and UnitExcl = 1
					 and (case when Dealer = 'Demountable Concepts, Inc.' and Class = 'Container Chassis' then 0 else 1 end) = 1
					 and Dealer <> 'Hale Trailer Brake & Wheel'
					 --and WO# not in (10015030, 10015031, 10015032)
					 group by CountrySort) as d on a.CountrySort = d.CountrySort
	;

	--Opening Inventory
	--Fetch data from sp_InventoryValuation (used in Inventory report) for count and net selling price as of start date
	--Drop and create temp table in tmpdb SQL database for faster processing
	IF OBJECT_ID('tempdb..#tmpdtInventoryValuation') IS NOT NULL
		DROP TABLE #tmpdtInventoryValuation 

	create table #tmpdtInventoryValuation
	(
		Job int,
		EntInvoiceDate datetime,
		ActCompleteDate datetime,
		ExchangeRate decimal(18, 6),
		TotalCostToDate decimal(14, 2)
	)

	insert into #tmpdtInventoryValuation
	exec [BWSdb].[dbo].[sp_inventoryvaluationV2] @sd
	;

	update #SalesStats
	set [#OpeningInventory] = b.[#OpeningInventory],
	[$OpeningInventory] = b.[$OpeningInventory]
	from #SalesStats as a
	left outer join (select CountrySort,
					count(Quote#) as [#OpeningInventory],
					cast(sum([Selling Price]) as decimal(14, 0)) as [$OpeningInventory]
					from #SalesStats_CountyInfo as Orders
					inner join [BWSdb].[dbo].[v_Inventory Detail V2] as a with (nolock) on Orders.Quote = a.Quote#
					inner join #tmpdtInventoryValuation as b on a.WO# = b.Job
					where (
								--WO# not in (10015030, 10015031, 10015032)
								--or 
								WO# is null
							)
					group by CountrySort) as b on a.CountrySort = b.CountrySort
	;

	--Closing Inventory
	--Purge temp Inventory Valuation table
	--Fetch data from sp_InventoryValuation (used in Inventory report) for count and net selling price as of end date
	truncate table #tmpdtInventoryValuation
	;

	insert into #tmpdtInventoryValuation
	exec [BWSdb].[dbo].[sp_inventoryvaluationV2] @ed
	;

	update #SalesStats
	set [#ClosingInventory] = b.[#ClosingInventory],
	[$ClosingInventory] = b.[$ClosingInventory]
	from #SalesStats as a
	left outer join (select CountrySort,
					count(Quote#) as [#ClosingInventory],
					cast(sum([Selling Price]) as decimal(14, 0)) as [$ClosingInventory]
					from #SalesStats_CountyInfo as Orders
					inner join [BWSdb].[dbo].[v_Inventory Detail V2] as a with (nolock) on Orders.Quote = a.Quote#
					inner join #tmpdtInventoryValuation as b on a.WO# = b.Job
					where (
								--WO# not in (10015030, 10015031, 10015032)
								--or
								WO# is null
							)
					group by CountrySort) as b on a.CountrySort = b.CountrySort
	;

	--Update null values
	update #SalesStats
	set #OpeningOrderBook = case when #OpeningOrderBook is null then 0 else #OpeningOrderBook end,
	[$OpeningOrderBook] = case when [$OpeningOrderBook] is null then 0 else [$OpeningOrderBook] end,
	#Invoiced = case when #Invoiced is null then 0 else #Invoiced end,
	[$Invoiced] = case when [$Invoiced] is null then 0 else [$Invoiced] end,
	[#RegisteredSales] = case when [#RegisteredSales] is null then 0 else [#RegisteredSales] end,
	[$RegisteredSales] = case when [$RegisteredSales] is null then 0 else [$RegisteredSales] end,
	#OpeningInventory = case when #OpeningInventory is null then 0 else #OpeningInventory end,
	[$OpeningInventory] = case when [$OpeningInventory] is null then 0 else [$OpeningInventory] end,
	#ClosingOrderBook = case when #ClosingOrderBook is null then 0 else #ClosingOrderBook end,
	[$ClosingOrderBook] = case when [$ClosingOrderBook] is null then 0 else [$ClosingOrderBook] end,
	#ClosingInventory = case when #ClosingInventory is null then 0 else #ClosingInventory end,
	[$ClosingInventory] = case when [$ClosingInventory] is null then 0 else [$ClosingInventory] end
	
	--Select statement
	select * from #SalesStats

END
