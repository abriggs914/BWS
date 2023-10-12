DECLARE @t AS Table(
		QueryType nvarchar(50),
		QueryID int,
		ReportDealer nvarchar(50),
		Quote# int,
		WO# int,
		SalesOrder varchar(6),
		[Model No] nvarchar(50),
		[Serial Number] nvarchar(255),
		[Purchase Order] nvarchar(255),
		[Payment Terms] nvarchar(255),
		[Company Name] nvarchar(50),
		[Order Date] datetime,
		[Invoice Date] datetime,
		[Available Date] datetime,
		[Delivery Date] datetime,
		[Date Completed] datetime,
		[Shipped Date] datetime,
		[Date In Service] datetime,
		[Date Registered] datetime,
		[US Sale] bit,
		[Selling Price (Pre V2)] decimal(14, 0),
		[Selling Price] decimal(14, 0),
		Customer nvarchar(255),
		DOG int,
		Class nvarchar(255),
		DealerID int,
		SlotNo int,
		LastBOL int,
		[PO Delivery Date] datetime,
		[PriceSecured] BIT,
		[Production Date] datetime,
		SlotsRequiredPerMonth int
)

--/****** Object:  StoredProcedure [dbo].[sp_DSR_ACD_PygWalker2023_10_04]    Script Date: 2023-10-11 10:56:53 AM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO

---- 2022-09-28 James Crawford - Added where clause to exclude 3 Half Round Work Orders from reports: 10015030 - 10015032
---- IT Request #001197
---- 2022-12-14 James Crawford - Commented out slots select statement for QueryID "1" as Shelley does not want to see Slots in the "Units On Order" section
---- Also swapped [v_Dealer Status Report 2] SQL view with [v_Dealer Status Report 2_AllCurrentDealers] so we could add Production Date without affecting the normal Dealer Status Report
---- IT Request #001521

--ALTER PROCEDURE [dbo].[sp_DSR_ACD_PygWalker2023_10_04] 
--	-- Add the parameters for the stored procedure here

--AS
--BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--Grab Today's date for easy referencing
	declare @today datetime = cast(getdate() as date)

	--Ensure any Quotes don't have any Shipped Dates before continuing
	update Orders
	set [Shipped Date] = null
	where WO# is null
	and [Order Date] is null
	and [Date In Service] is null
	and [Shipped Date] is not null

	--Drop and create temp table in tmpdb SQL database for faster processing
	IF OBJECT_ID('tempdb..#v_DealerStatusReport2') IS NOT NULL
		DROP TABLE #v_DealerStatusReport2

	create table #v_DealerStatusReport2
	(
		Quote# int,
		WO# int,
		SalesOrder varchar(6),
		[Model No] nvarchar(50),
		[Serial Number] nvarchar(255),
		[Purchase Order] nvarchar(255),
		[Payment Terms] nvarchar(255),
		[Company Name] nvarchar(50),
		[Order Date] datetime,
		[Invoice Date] datetime,
		[Available Date] datetime,
		[Delivery Date] datetime,
		[Date Completed] datetime,
		[Shipped Date] datetime,
		[Date In Service] datetime,
		[Date Registered] datetime,
		[US Sale] bit,
		[Selling Price (Pre V2)] decimal(14, 0),
		[Selling Price] decimal(14, 0),
		Customer nvarchar(255),
		DOG int,
		Class nvarchar(255),
		DealerID int,
		SlotNo int,
		LastBOL int,
		[PO Delivery Date] datetime,
		[PriceSecured] BIT,
		[Production Date] datetime
	)

	insert into #v_DealerStatusReport2
	select * from [v_Dealer Status Report 2_AllCurrentDealers]
	where (
			(DealerID in (select distinct ID from Dealers with (nolock) where [CURRENT DEALER] = 1)
			and Quote# in (select distinct Quote# from Orders with (nolock) where FinishedGoodsDealerLocID is null)
			and Quote# <> 24545) --Manually removed from report as it was never given a WO as per Shelley - February 8, 2021
		or Quote# in (select distinct Quote# from Orders with (nolock)
					inner join Dealers with (nolock) on Orders.FinishedGoodsDealerLocID = Dealers.ID
					where DealerID in (select distinct ID from Dealers with (nolock) where [CURRENT DEALER] = 1)
					and DealerID not in (select ID from Dealers with (nolock) where left([COMPANY NAME], 3) = 'BWS')
					and Quote# <> 24545) --Manually removed from report as it was never given a WO as per Shelley - February 8, 2021
	)
	and (
		[v_Dealer Status Report 2_AllCurrentDealers].WO# not in (10015030, 10015031, 10015032)
		or [v_Dealer Status Report 2_AllCurrentDealers].WO# is null
	)

	--Drop and create temp table in tmpdb SQL database for faster processing
	IF OBJECT_ID('tempdb..#InventoryValuation') IS NOT NULL
		DROP TABLE #InventoryValuation

	create table #InventoryValuation
	(
		Job varchar(20),
		[Invoice Date] datetime,
		[Date Completed] datetime,
		[ExchangeRate] FLOAT,
		[TotalCostToDate] decimal(14, 2)
	)

	insert into #InventoryValuation
	exec sp_InventoryValuation @today

	--Drop and create temp table in tmpdb SQL database for faster processing
	IF OBJECT_ID('tempdb..#BWSStatusReport') IS NOT NULL
		DROP TABLE #BWSStatusReport

	create table #BWSStatusReport
	(
		Quote# int,
		WO# int,
		SalesOrder varchar(6),
		[Model No] nvarchar(50),
		[Serial Number] nvarchar(255),
		[Purchase Order] nvarchar(255),
		[Payment Terms] nvarchar(255),
		[Company Name] nvarchar(50),
		[Order Date] datetime,
		[Invoice Date] datetime,
		[Available Date] datetime,
		[Delivery Date] datetime,
		[Date Completed] datetime,
		[Shipped Date] datetime,
		[Date In Service] datetime,
		[Date Registered] datetime,
		[US Sale] bit,
		[Selling Price (Pre V2)] decimal(14, 0),
		[Selling Price] decimal(14, 0),
		Customer nvarchar(255),
		DOG int,
		Class nvarchar(255),
		DealerID int,
		SlotNo int,
		LastBOL int,
		[PO Delivery Date] datetime,
		[PriceSecured] BIT,
		[Production Date] datetime
	)

	insert into #BWSStatusReport
	select Orders.Quote#, Orders.WO#, REPLACE(LTRIM(REPLACE(v_CompletedJobInfo.[Sales Order#], '0', ' ')), ' ', '0') collate database_default as SalesOrder,
	Orders.[Model No], Orders.[Serial Number], [Purchase Order], [Payment Terms], Dealers.[COMPANY NAME] as Location,
	Orders.[PO Date], /*Orders.[Order Date],*/
	case when v_CompletedJobInfo.EntInvoiceDate is null then Orders.[Invoice Date] else v_CompletedJobInfo.EntInvoiceDate end as [Invoice Date],
	[Available Date], Orders.[Delivery Date],
	case when v_CompletedJobInfo.ActCompleteDate is null then Production.[Date Completed] else v_CompletedJobInfo.ActCompleteDate end as [Date Completed],
	[Shipped Date], [Date In Service], [Date Registered], [US Sale], [Selling Price] as [Selling Price (Pre V2)],
	cast(dbo.fn_QuoteRptV2_SellingPrice(Orders.Quote#, [v_Orders Raw Pricing].[Gross Price], Orders.Discount3_Type, Orders.Discount3, Orders.[Volume Discount], 
										Orders.[Program Discount], Orders.Discount1_Type, Orders.Discount1, Orders.Discount2_Type, Orders.Discount2) 
	as decimal(14, 0)) AS [Selling Price],
	Customers.Customer, 
	CONVERT(int, GETDATE() - Orders.[Shipped Date]) AS DOG,
	Products.Class, Orders.DealerID, Orders.Slot#, subBOL.LastBOL, Orders.[Requested Delivery Date],
	[PriceSecured],
	case when Production.[Prod Date] > Production.[Prod Date2] then Production.[Prod Date2] else Production.[Prod Date] end as [Production Date]
	from Orders with (nolock)
	inner join [v_Orders Raw Pricing] on Orders.Quote# = [v_Orders Raw Pricing].Quote#
	inner join Dealers with (nolock) on Orders.FinishedGoodsDealerLocID = Dealers.ID
	inner join Products with (nolock) on Orders.[Model No] = Products.[Model No]
	left outer join [Payment Terms] with (nolock) on Orders.PayID = [Payment Terms].PayID
	left outer join Production with (nolock) on Orders.Quote# = Production.Quote#
	left outer join Customers with (nolock) on Orders.Quote# = Customers.Quote#
	left outer join SysproCompanyA.dbo.v_CompletedJobInfo on cast(Orders.WO# as varchar(20)) = v_CompletedJobInfo.Job
	left outer join (select WO#, max(BOL#) as LastBOL
					 from dbo.BOL with (nolock)
					 group by WO#) as subBOL on Orders.WO# = subBOL.WO#
	where cast(Orders.WO# as varchar(20)) in (select distinct Job from #InventoryValuation)
	and (left([v_Orders Raw Pricing].[COMPANY NAME], 3) = 'BWS' or [v_Orders Raw Pricing].[COMPANY NAME] = Dealers.[COMPANY NAME])
	and Orders.Quote# <> 24545 --Manually removed from report as it was never given a WO as per Shelley - February 8, 2021
	and (
			Orders.WO# not in (10015030, 10015031, 10015032)
			or Orders.WO# is null
		)

	--Dump Dealer Status Reports for all current dealers into one final temp table
	--Drop and create temp table in tmpdb SQL database for faster processing
	IF OBJECT_ID('tempdb..#DealerStatusReportFinal') IS NOT NULL
		DROP TABLE #DealerStatusReportFinal

	create table #DealerStatusReportFinal
	(
		QueryID int,
		ReportDealer nvarchar(50),
		Quote# int,
		WO# int,
		SalesOrder varchar(6),
		[Model No] nvarchar(50),
		[Serial Number] nvarchar(255),
		[Purchase Order] nvarchar(255),
		[Payment Terms] nvarchar(255),
		[Company Name] nvarchar(50),
		[Order Date] datetime,
		[Invoice Date] datetime,
		[Available Date] datetime,
		[Delivery Date] datetime,
		[Date Completed] datetime,
		[Shipped Date] datetime,
		[Date In Service] datetime,
		[Date Registered] datetime,
		[US Sale] bit,
		[Selling Price (Pre V2)] decimal(14, 0),
		[Selling Price] decimal(14, 0),
		Customer nvarchar(255),
		DOG int,
		Class nvarchar(255),
		DealerID int,
		SlotNo int,
		LastBOL int,
		[PO Delivery Date] datetime,
		[PriceSecured] BIT,
		[Production Date] datetime,
		SlotsRequiredPerMonth int
	)

	declare @dealerlist table
	(
		DealerListID int identity(1, 1),
		Dealer nvarchar(50),
		SlotsRequiredPerMonth int
	)

	insert into @dealerlist (Dealer, SlotsRequiredPerMonth)
	select distinct [COMPANY NAME], 
	case when SlotsRequestedPerMonth is null then 0 else SlotsRequestedPerMonth end
	from Dealers with (nolock)
	where [CURRENT DEALER] = 1

	declare @loopid int = 1,
			@loopdealer nvarchar(50),
			@loopsrpm int

	--Loop through and grab each current dealer's Dealer Status Report
	while @loopid <= (select max(DealerListID) from @dealerlist)
		begin
			select @loopdealer = Dealer,
				   @loopsrpm = SlotsRequiredPerMonth
			from @dealerlist
			where DealerListID = @loopid

			if left(@loopdealer, 3) = 'BWS' and @loopdealer not like '%US Direct%'
				begin
					insert into #DealerStatusReportFinal
					select 1 as QueryID, @loopdealer, *, @loopsrpm from #v_DealerStatusReport2
					where ([Invoice Date] is null or [Invoice Date] > @today)
					and [Date Completed] is null
					and ([Shipped Date] is null or [Shipped Date] > @today)
					and [COMPANY NAME] = @loopdealer

					-- union all select 1 as QueryID, @loopdealer,Slot#, null, null, [Slot Types],
					-- 'Confirm Quote by ' + DATENAME(MONTH, case when [Prod Date 1] is null then dateadd(day, -120, [Prod Date 2]) else dateadd(day, -120, [Prod Date 1]) end) + ' '
					-- 					+ cast(DATEPART(day, case when [Prod Date 1] is null then dateadd(day, -120, [Prod Date 2]) else dateadd(day, -120, [Prod Date 1]) end) as nvarchar) + ', '
					-- 					+ cast(DATEPART(year, case when [Prod Date 1] is null then dateadd(day, -120, [Prod Date 2]) else dateadd(day, -120, [Prod Date 1]) end) as nvarchar) as SerialNumber,
					-- null, null, @loopdealer, null, null, null,
					-- dbo.fn_SlotEstimatedDeliveryDate(case when [Prod Date 1] is null then [Prod Date 2] else [Prod Date 1] end) as DeliveryDate,
					-- null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, @loopsrpm
					-- from dtProductionSchedule with (nolock)
					-- inner join [Production Slots] with (nolock) on dtProductionSchedule.Slot# = [Production Slots].PSlotID#
					-- inner join Dealers with (nolock) on [Production Slots].Dealer = Dealers.ID
					-- where dtProductionSchedule.Quote# is null
					-- and [Slot/Quote] = 1
					-- and [COMPANY NAME] = @loopdealer
					-- and (
					-- 	dtProductionSchedule.WO# not in (10015030, 10015031, 10015032)
					-- 	or dtProductionSchedule.WO# is null
					-- )

					union all select 3 as QueryID, @loopdealer, *, @loopsrpm from #v_DealerStatusReport2
					where ([Date Completed] is not null or [Date Completed] <= @today)
					and ([Shipped Date] is null or [Shipped Date] > @today)
					and [COMPANY NAME] = @loopdealer

					--union all select 4 as QueryID, @loopdealer, * from #BWSStatusReport
					union all select 4 as QueryID, @loopdealer, *, @loopsrpm from #v_DealerStatusReport2 -- <-- CHANGE THIS SELECT STATEMENT TO REFLECT SAME CRITERIA AS LEWIS & STARGATE!
					where [COMPANY NAME] = @loopdealer /*and [Invoice Date] is not null*/ and [Shipped Date] <= @today and [Date In Service] is null
					or ([COMPANY NAME] = @loopdealer and [COMPANY NAME] like '%BWS Manufacturing%' and [Invoice Date] is null and [Shipped Date] <= @today and [Date In Service] is null)

					union all select 5 as QueryID, @loopdealer, *, @loopsrpm from #v_DealerStatusReport2
					where [COMPANY NAME] = @loopdealer /*and [Invoice Date] is not null*/ and [Shipped Date] <= @today and [Date In Service] is null
					or ([COMPANY NAME] = @loopdealer and [COMPANY NAME] like '%BWS Manufacturing%' and [Invoice Date] is null and [Shipped Date] <= @today and [Date In Service] is null)

					union all select 6 as QueryID, @loopdealer, *, @loopsrpm from #BWSStatusReport
					where [COMPANY NAME] = @loopdealer

					union all select 7 as QueryID, @loopdealer, Slot#, null, null, [Slot Types],
					DATENAME(MONTH, case when [Prod Date 1] is null then dateadd(day, -120, [Prod Date 2]) else dateadd(day, -120, [Prod Date 1]) end) + ' '
										+ cast(DATEPART(day, case when [Prod Date 1] is null then dateadd(day, -120, [Prod Date 2]) else dateadd(day, -120, [Prod Date 1]) end) as nvarchar) + ', '
										+ cast(DATEPART(year, case when [Prod Date 1] is null then dateadd(day, -120, [Prod Date 2]) else dateadd(day, -120, [Prod Date 1]) end) as nvarchar) as SerialNumber,
					null, null, @loopdealer, null, null, null,
					dbo.fn_SlotEstimatedDeliveryDate
					(case when [Prod Date 1] is null then [Prod Date 2] else [Prod Date 1] end) as DeliveryDate ,
					null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, 
					case when [Prod Date 1] > [Prod Date 2] then [Prod Date 2] else [Prod Date 1] end as [Production Date],
					@loopsrpm
					from dtProductionSchedule with (nolock)
					inner join [Production Slots] with (nolock) on dtProductionSchedule.Slot# = [Production Slots].PSlotID#
					inner join Dealers with (nolock) on [Production Slots].Dealer = Dealers.ID
					where dtProductionSchedule.Quote# is null
					and [Slot/Quote] = 1
					and [COMPANY NAME] = @loopdealer
					and (
						dtProductionSchedule.WO# not in (10015030, 10015031, 10015032)
						or dtProductionSchedule.WO# is null
					)
				end
			else
				begin
					if @loopdealer like '%Lewis%' or @loopdealer like '%Stargate%'
						begin
							insert into #DealerStatusReportFinal
							select 1 as QueryID, @loopdealer, *, @loopsrpm from #v_DealerStatusReport2
							where ([Invoice Date] is null or [Invoice Date] > @today)
							and [Date Completed] is null
							and ([Shipped Date] is null or [Shipped Date] > @today)
							and [COMPANY NAME] = @loopdealer

							-- union all select 1 as QueryID, @loopdealer,Slot#, null, null, [Slot Types],
							-- 'Confirm Quote by ' + DATENAME(MONTH, case when [Prod Date 1] is null then dateadd(day, -120, [Prod Date 2]) else dateadd(day, -120, [Prod Date 1]) end) + ' '
							-- 					+ cast(DATEPART(day, case when [Prod Date 1] is null then dateadd(day, -120, [Prod Date 2]) else dateadd(day, -120, [Prod Date 1]) end) as nvarchar) + ', '
							-- 					+ cast(DATEPART(year, case when [Prod Date 1] is null then dateadd(day, -120, [Prod Date 2]) else dateadd(day, -120, [Prod Date 1]) end) as nvarchar) as SerialNumber,
							-- null, null, @loopdealer, null, null, null,
							-- dbo.fn_SlotEstimatedDeliveryDate(case when [Prod Date 1] is null then [Prod Date 2] else [Prod Date 1] end) as DeliveryDate,
							-- null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, @loopsrpm
							-- from dtProductionSchedule with (nolock)
							-- inner join [Production Slots] with (nolock) on dtProductionSchedule.Slot# = [Production Slots].PSlotID#
							-- inner join Dealers with (nolock) on [Production Slots].Dealer = Dealers.ID
							-- where dtProductionSchedule.Quote# is null
							-- and [Slot/Quote] = 1
							-- and [COMPANY NAME] = @loopdealer
							-- and (
							-- 	dtProductionSchedule.WO# not in (10015030, 10015031, 10015032)
							-- 	or dtProductionSchedule.WO# is null
							-- )

							union all select 3 as QueryID, @loopdealer, *, @loopsrpm from #v_DealerStatusReport2
							where ([Date Completed] is not null or [Date Completed] <= @today)
							and ([Shipped Date] is null or [Shipped Date] > @today)
							and [COMPANY NAME] = @loopdealer

							union all select 4 as QueryID, @loopdealer, *, @loopsrpm from #v_DealerStatusReport2
							where ([COMPANY NAME] = @loopdealer /*and [Invoice Date] is not null*/ and [Shipped Date] <= @today and [Date In Service] is null)

							union all select 5 as QueryID, @loopdealer, *, @loopsrpm from #v_DealerStatusReport2
							where [COMPANY NAME] = @loopdealer /*and [Invoice Date] is not null*/ and [Shipped Date] <= @today and [Date In Service] is null

							union all select 6 as QueryID, @loopdealer, *, @loopsrpm from #BWSStatusReport
							where [COMPANY NAME] = @loopdealer

							union all select 7 as QueryID, @loopdealer, Slot#, null, null, [Slot Types],
							DATENAME(MONTH, case when [Prod Date 1] is null then dateadd(day, -120, [Prod Date 2]) else dateadd(day, -120, [Prod Date 1]) end) + ' '
												+ cast(DATEPART(day, case when [Prod Date 1] is null then dateadd(day, -120, [Prod Date 2]) else dateadd(day, -120, [Prod Date 1]) end) as nvarchar) + ', '
												+ cast(DATEPART(year, case when [Prod Date 1] is null then dateadd(day, -120, [Prod Date 2]) else dateadd(day, -120, [Prod Date 1]) end) as nvarchar) as SerialNumber,
							null, null, @loopdealer, null, null, null,
							dbo.fn_SlotEstimatedDeliveryDate
							(case when [Prod Date 1] is null then [Prod Date 2] else [Prod Date 1] end) as DeliveryDate ,
							null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, 
							case when [Prod Date 1] > [Prod Date 2] then [Prod Date 2] else [Prod Date 1] end as [Production Date],
							@loopsrpm
							from dtProductionSchedule with (nolock)
							inner join [Production Slots] with (nolock) on dtProductionSchedule.Slot# = [Production Slots].PSlotID#
							inner join Dealers with (nolock) on [Production Slots].Dealer = Dealers.ID
							where dtProductionSchedule.Quote# is null
							and [Slot/Quote] = 1
							and [COMPANY NAME] = @loopdealer
							and (
								dtProductionSchedule.WO# not in (10015030, 10015031, 10015032)
								or dtProductionSchedule.WO# is null
							)
						end
					else
						begin
							insert into #DealerStatusReportFinal
							select 1 as QueryID, @loopdealer, *, @loopsrpm from #v_DealerStatusReport2
							where ([Invoice Date] is null or [Invoice Date] > @today)
							and [Date Completed] is null
							and ([Shipped Date] is null or [Shipped Date] > @today)
							and [COMPANY NAME] = @loopdealer

							-- union all select 1 as QueryID, @loopdealer,Slot#, null, null, [Slot Types],
							-- 'Confirm Quote by ' + DATENAME(MONTH, case when [Prod Date 1] is null then dateadd(day, -120, [Prod Date 2]) else dateadd(day, -120, [Prod Date 1]) end) + ' '
							-- 					+ cast(DATEPART(day, case when [Prod Date 1] is null then dateadd(day, -120, [Prod Date 2]) else dateadd(day, -120, [Prod Date 1]) end) as nvarchar) + ', '
							-- 					+ cast(DATEPART(year, case when [Prod Date 1] is null then dateadd(day, -120, [Prod Date 2]) else dateadd(day, -120, [Prod Date 1]) end) as nvarchar) as SerialNumber,
							-- null, null, @loopdealer, null, null, null,
							-- dbo.fn_SlotEstimatedDeliveryDate(case when [Prod Date 1] is null then [Prod Date 2] else [Prod Date 1] end) as DeliveryDate,
							-- null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, @loopsrpm
							-- from dtProductionSchedule with (nolock)
							-- inner join [Production Slots] with (nolock) on dtProductionSchedule.Slot# = [Production Slots].PSlotID#
							-- inner join Dealers with (nolock) on [Production Slots].Dealer = Dealers.ID
							-- where dtProductionSchedule.Quote# is null
							-- and [Slot/Quote] = 1
							-- and [COMPANY NAME] = @loopdealer
							-- and (
							-- 	dtProductionSchedule.WO# not in (10015030, 10015031, 10015032)
							-- 	or dtProductionSchedule.WO# is null
							-- )

							union all select 3 as QueryID, @loopdealer, *, @loopsrpm from #v_DealerStatusReport2
							where ([Date Completed] is not null or [Date Completed] <= @today)
							and ([Shipped Date] is null or [Shipped Date] > @today)
							and [COMPANY NAME] = @loopdealer

							union all select 4 as QueryID, @loopdealer, *, @loopsrpm from #v_DealerStatusReport2
							where ([COMPANY NAME] = @loopdealer and [Invoice Date] is not null and [Shipped Date] <= @today and [Date In Service] is null)

							union all select 5 as QueryID, @loopdealer, *, @loopsrpm from #v_DealerStatusReport2
							where [COMPANY NAME] = @loopdealer and [Invoice Date] is not null and [Shipped Date] <= @today and [Date In Service] is null

							union all select 6 as QueryID, @loopdealer, *, @loopsrpm from #BWSStatusReport
							where [COMPANY NAME] = @loopdealer

							union all select 7 as QueryID, @loopdealer, Slot#, null, null, [Slot Types],
							DATENAME(MONTH, case when [Prod Date 1] is null then dateadd(day, -120, [Prod Date 2]) else dateadd(day, -120, [Prod Date 1]) end) + ' '
												+ cast(DATEPART(day, case when [Prod Date 1] is null then dateadd(day, -120, [Prod Date 2]) else dateadd(day, -120, [Prod Date 1]) end) as nvarchar) + ', '
												+ cast(DATEPART(year, case when [Prod Date 1] is null then dateadd(day, -120, [Prod Date 2]) else dateadd(day, -120, [Prod Date 1]) end) as nvarchar) as SerialNumber,
							null, null, @loopdealer, null, null, null,
							dbo.fn_SlotEstimatedDeliveryDate
							(case when [Prod Date 1] is null then [Prod Date 2] else [Prod Date 1] end) as DeliveryDate ,
							null, null, null, null, null, null, null, null, null, null, null, null, null, null, null,
							case when [Prod Date 1] > [Prod Date 2] then [Prod Date 2] else [Prod Date 1] end as [Production Date],
							@loopsrpm
							from dtProductionSchedule with (nolock)
							inner join [Production Slots] with (nolock) on dtProductionSchedule.Slot# = [Production Slots].PSlotID#
							inner join Dealers with (nolock) on [Production Slots].Dealer = Dealers.ID
							where dtProductionSchedule.Quote# is null
							and [Slot/Quote] = 1
							and [COMPANY NAME] = @loopdealer
							and (
								dtProductionSchedule.WO# not in (10015030, 10015031, 10015032)
								or dtProductionSchedule.WO# is null
							)
						end
				end

			select @loopid = @loopid + 1
		end

	--Final select statement
INSERT INTO @t
	SELECT 
		(CASE WHEN [QueryID] = 1 THEN
			'On Order'	
		WHEN [QueryID] = 3 THEN
			'Ready for Shipping'	
		WHEN [QueryID] = 4 THEN
			'Dealer Inventory'	
		WHEN [QueryID] = 5 THEN
			'In Stock'	
		WHEN [QueryID] = 7 THEN
			'Slots Remaining'	
		WHEN [QueryID] = 8 THEN
			'BWS Inventory'	
		ELSE
			NULL
		END) AS [QueryType]
		,*
	FROM
		#DealerStatusReportFinal


SELECT
	*
FROM
	@t

DECLARE @dID AS INT;
DECLARE @dName AS NVARCHAR(100);

SELECT
	@dID = 330  -- RL
;

IF @dID IS NOT NULL BEGIN
	SELECT
		@dName = [COMPANY NAME]
	FROM
		[Dealers]
	WHERE
		[ID] = @dID
END
ELSE IF @dName IS NOT NULL BEGIN
	SELECT
		@dID = [ID]
	FROM
		[Dealers]
	WHERE
		[COMPANY NAME] = @dName
END

SELECT @dName = '';

SELECT
	SUM([Qid]) AS [QueryID],
	[HasShipped],
	[QueryType],
	[ReportDealer],
	SUM([Num]) AS TtlNum,
	SUM([SumOfSelling Price]) AS TtlSellPrice
FROM (
	SELECT 
		0 AS [Qid],
		1 AS [HasShipped],
		dt_DSD_DSR_ACD_BWS.QueryType,
		dt_DSD_DSR_ACD_BWS.ReportDealer,
		COUNT(*) AS [Num],
		Sum(dt_DSD_DSR_ACD_BWS.[Selling Price]) AS [SumOfSelling Price]
	FROM 
		@t AS [dt_DSD_DSR_ACD_BWS]
	WHERE 
		dt_DSD_DSR_ACD_BWS.ReportDealer = @dName
		AND [dt_DSD_DSR_ACD_BWS].[QueryType] NOT IN ('Slots Remaining', 'Dealer Inventory')
		AND [Shipped Date] < GETDATE()
	GROUP BY 
		dt_DSD_DSR_ACD_BWS.QueryType,
		dt_DSD_DSR_ACD_BWS.ReportDealer

	UNION

	SELECT 
		0 AS [Qid],
		0 AS [HasShipped],
		dt_DSD_DSR_ACD_BWS.QueryType,
		dt_DSD_DSR_ACD_BWS.ReportDealer,
		COUNT(*) AS [Num],
		Sum(dt_DSD_DSR_ACD_BWS.[Selling Price]) AS [SumOfSelling Price]
	FROM 
		@t AS [dt_DSD_DSR_ACD_BWS]
	WHERE 
		dt_DSD_DSR_ACD_BWS.ReportDealer = @dName
		AND [dt_DSD_DSR_ACD_BWS].[QueryType] NOT IN ('Slots Remaining', 'Dealer Inventory')
		AND ISNULL([Shipped Date], DATEADD(DAY, 1 , GETDATE())) >= GETDATE()
	GROUP BY 
		dt_DSD_DSR_ACD_BWS.QueryType,
		dt_DSD_DSR_ACD_BWS.ReportDealer

	UNION
	SELECT TOP 1
	1, 0, 'On Order', @dName, 0, 0 
	FROM [Orders]
	UNION
	SELECT TOP 1
	3, 1, 'In Stock', @dName, 0, 0 
	FROM [Orders]
	UNION
	SELECT TOP 1
	2,0, 'Ready for Shipping', @dName, 0, 0 
	FROM [Orders]
) AS [A]
GROUP BY [HasShipped], [QueryType], [ReportDealer]
;
