
DECLARE @dealerid AS INT;
SET @dealerid = 330;

	declare @today datetime = cast(getdate() as date)

	--Grab Company Name for easy referencing
	declare @dealer nvarchar(255)
	select @dealer = [COMPANY NAME] from Dealers with (nolock)
	where ID = @dealerid
	DECLARE @v_DealerStatusReport2 TABLE
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
		[PO Delivery Date] datetime	
	)

	insert into @v_DealerStatusReport2
	select		
	[v_Dealer Status Report 2].[Quote#],
	[WO#],
	[SalesOrder],
	[v_Dealer Status Report 2].[Model No],
	[Serial Number],
	[Purchase Order],
	[Payment Terms], 
	[Company Name], 
	[PO Date],
	[Invoice Date],
	[Available Date],
	(CASE WHEN [Delivery Date] IS NULL THEN [Production Slots].[Slot Date] ELSE [Delivery Date] END) AS [Delivery Date],
	[Date Completed],
	[Shipped Date],
	[Date In Service],
	[Date Registered],
	[US Sale],
	[Selling Price (Pre V2)],
	[Selling Price], [Customer], [DOG], [Class], [DealerID], [Slot#] AS [SlotNo], [LastBOL], [Requested Delivery Date]

	from [v_Dealer Status Report 2]
	LEFT OUTER JOIN
		[Production Slots]
	ON
		[Production Slots].[PSlotID#] = [Slot#]
	where ([COMPANY NAME] = @dealer
		   and [v_Dealer Status Report 2].Quote# in (select distinct Quote# from Orders with (nolock) where FinishedGoodsDealerLocID is null)
		   and [v_Dealer Status Report 2].Quote# <> 24545) --Manually removed from report as it was never given a WO as per Shelley - February 8, 2021
	or [v_Dealer Status Report 2].Quote# in (select distinct Quote# from Orders with (nolock) 
				  inner join Dealers with (nolock) on Orders.FinishedGoodsDealerLocID = Dealers.ID
				  where [COMPANY NAME] = @dealer
				  and DealerID not in (select ID from Dealers with (nolock) where left([COMPANY NAME], 3) = 'BWS')
				  and Quote# <> 24545) --Manually removed from report as it was never given a WO as per Shelley - February 8, 2021


				  

	DECLARE @InventoryValuation TABLE
	(
		Job varchar(20),
		[Invoice Date] datetime,
		[Date Completed] datetime,
		[TotalCostToDate] decimal(14, 2)
	)

	insert into @InventoryValuation
	exec sp_InventoryValuation @today


DECLARE @BWSStatusReport TABLE
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
		[PO Delivery Date] datetime		
	)

	insert into @BWSStatusReport
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
	Products.Class, Orders.DealerID, Orders.Slot#, subBOL.LastBOL, Orders.[Requested Delivery Date]
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
	where cast(Orders.WO# as varchar(20)) in (select distinct Job from @InventoryValuation)
	and (left([v_Orders Raw Pricing].[COMPANY NAME], 3) = 'BWS' or [v_Orders Raw Pricing].[COMPANY NAME] = Dealers.[COMPANY NAME])
	and Orders.Quote# <> 24545 --Manually removed from report as it was never given a WO as per Shelley - February 8, 2021
	

select 1 as QueryID, * from @v_DealerStatusReport2
					where ([Invoice Date] is null or [Invoice Date] > @today)
					and [Date Completed] is null
					and ([Shipped Date] is null or [Shipped Date] > @today)

					union all select 3 as QueryID, * from @v_DealerStatusReport2
					where ([Date Completed] is not null or [Date Completed] <= @today)
					and ([Shipped Date] is null or [Shipped Date] > @today)

					union all select 4 as QueryID, * from @v_DealerStatusReport2
					where /*[Invoice Date] is not null and*/ ([Shipped Date] <= @today and [Date In Service] is null)
					or (left([COMPANY NAME], 3) = 'BWS' and [Company Name] not like '%US Direct%' and [Invoice Date] is null and [Shipped Date] <= @today and [Date In Service] is null)

					union all select 5 as QueryID, * from @v_DealerStatusReport2
					where /*[Invoice Date] is not null and*/ ([Shipped Date] <= @today and [Date In Service] is null)
					or (left([COMPANY NAME], 3) = 'BWS' and [Company Name] not like '%US Direct%' and [Invoice Date] is null and [Shipped Date] <= @today and [Date In Service] is null)

					union all select 6 as QueryID, * from @BWSStatusReport
					where [COMPANY NAME] = @dealer

					union all select 7 as QueryID, Slot#, null, null, [Slot Types],
					DATENAME(MONTH, case when [Prod Date 1] is null then dateadd(day, -120, [Prod Date 2]) else dateadd(day, -120, [Prod Date 1]) end) + ' '
										+ cast(DATEPART(day, case when [Prod Date 1] is null then dateadd(day, -120, [Prod Date 2]) else dateadd(day, -120, [Prod Date 1]) end) as nvarchar) + ', '
										+ cast(DATEPART(year, case when [Prod Date 1] is null then dateadd(day, -120, [Prod Date 2]) else dateadd(day, -120, [Prod Date 1]) end) as nvarchar) as SerialNumber,
					null, null, @dealer, null, null, null,
					dbo.fn_SlotEstimatedDeliveryDate
					(case when [Prod Date 1] is null then [Prod Date 2] else [Prod Date 1] end) as DeliveryDate ,
					null, null, null, null, null, null, null, null, null, null, null, null, null, null
					from dtProductionSchedule with (nolock)
					inner join [Production Slots] with (nolock) on dtProductionSchedule.Slot# = [Production Slots].PSlotID#
					inner join Dealers with (nolock) on [Production Slots].Dealer = Dealers.ID
					where dtProductionSchedule.Quote# is null
					and [Slot/Quote] = 1
					and [COMPANY NAME] = @dealer	