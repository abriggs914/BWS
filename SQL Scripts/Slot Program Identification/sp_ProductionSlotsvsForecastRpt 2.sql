USE [BWSdb]
GO
/****** Object:  StoredProcedure [dbo].[sp_ProductionSlotsvsForecastRpt 2]    Script Date: 6/29/2021 9:52:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Avery Briggs>
-- Create date: <2021-06-29>
-- Description:	<Generate the Dealer Slots VS Forecast report.>
--=============================================

ALTER PROCEDURE [dbo].[sp_ProductionSlotsvsForecastRpt 2] 
	-- Add the parameters for the stored procedure here
	@sd datetime,
	@ss int = 1
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	CREATE TABLE #T (
		[COMPANY NAME] varchar(50),
		[Slot Type] varchar(50),
		[GROUPING] int,
		[Label] varchar(50),
		[Initials] varchar(10),
		[LabelTtl] varchar(50),
		[Slot Status] int,
		[January] int,
		[February] int,
		[March] int,
		[April] int,
		[May] int,
		[June] int,
		[July] int,
		[August] int,
		[September] int,
		[October] int,
		[November] int,
		[December] int 
	)

	INSERT INTO #T EXEC [dbo].[sp_GetSlotReport] @StartDate = @sd, @SlotStatus = @ss
	

    -- Insert statements for procedure here
	declare @m1 datetime = DATEADD(mm, DATEDIFF(mm, 0, @sd), 0)

	declare @m2 datetime = dateadd(month, 1, @m1),
			@m3 datetime = dateadd(month, 2, @m1),
			@m4 datetime = dateadd(month, 3, @m1),
			@m5 datetime = dateadd(month, 4, @m1),
			@m6 datetime = dateadd(month, 5, @m1),
			@m7 datetime = dateadd(month, 6, @m1),
			@m8 datetime = dateadd(month, 7, @m1),
			@m9 datetime = dateadd(month, 8, @m1),
			@m10 datetime = dateadd(month, 9, @m1),
			@m11 datetime = dateadd(month, 10, @m1),
			@m12 datetime = dateadd(month, 11, @m1)
	
	----Drop and create temp table in tmpdb SQL database for faster processing for fetching Access Quote Hours grouped by WorkCentre
	--IF OBJECT_ID('tempdb..#AccessQuoteHours') IS NOT NULL
	--	DROP TABLE #AccessQuoteHours

	--create table #AccessQuoteHours
	--(
	--	Quote# int,
	--	WorkCentre varchar(30),
	--	NetBudget decimal(9, 2)
	--)

	----INSERT INTO #tab EXEC [sp_GetSlotReport] @StartDate = '2021-06-29'
	
	--insert into #AccessQuoteHours
	--select Quote#, WorkCentre, sum([Hours]) as NetHours
	--			from (select Quote#, 'A' as WorkCentre, sum(Axles) as [Hours]
	--				  from [Order Hours] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'A', sum(Axles * Qty) as [Hours]
	--				  from [Order Options] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'A', sum(Axles * Qty) as [Hours]
	--				  from [Custom Work] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'T', sum([Step 1]) as [Hours]
	--				  from [Order Hours] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'T', sum([Step 1] * Qty) as [Hours]
	--				  from [Order Options] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'T', sum([Step 1] * Qty) as [Hours]
	--				  from [Custom Work] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'T', sum([Step 2]) as [Hours]
	--				  from [Order Hours] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'T', sum([Step 2] * Qty) as [Hours]
	--				  from [Order Options] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'T', sum([Step 2] * Qty) as [Hours]
	--				  from [Custom Work] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'P', sum(Blast) as [Hours]
	--				  from [Order Hours] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'P', sum(Blast * Qty) as [Hours]
	--				  from [Order Options] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'P', sum(Blast * Qty) as [Hours]
	--				  from [Custom Work] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'P', sum(Paint) as [Hours]
	--				  from [Order Hours] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'P', sum(Paint * Qty) as [Hours]
	--				  from [Order Options] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'P', sum(Paint * Qty) as [Hours]
	--				  from [Custom Work] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'F', sum([Finish - GNK]) as [Hours]
	--				  from [Order Hours] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'F', sum([Finish - GNK] * Qty) as [Hours]
	--				  from [Order Options] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'F', sum([Finish - GNK] * Qty) as [Hours]
	--				  from [Custom Work] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'F', sum([Final Assembly]) as [Hours]
	--				  from [Order Hours] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'F', sum([Final Assembly] * Qty) as [Hours]
	--				  from [Order Options] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'F', sum([Final Assembly] * Qty) as [Hours]
	--				  from [Custom Work] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'F', sum([Tire Assembly]) as [Hours]
	--				  from [Order Hours] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'F', sum([Tire Assembly] * Qty) as [Hours]
	--				  from [Order Options] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'F', sum([Tire Assembly] * Qty) as [Hours]
	--				  from [Custom Work] with (nolock)
	--				  group by Quote#) as mainsub
	--			group by Quote#, WorkCentre

	--Final select statement
	select 0 as RptGrouping, 'Production Forecast (Ordered Units) as of ' as RptGroupName, [COMPANY NAME], [GROUPING], Label, Initials, LabelTtl,
	@m1 as Month1Date,
	sum(case when year([Slot Date]) = year(@m1) and month([Slot Date]) = month(@m1) then 1 else 0 end) as Month1Slots,
	@m2 as Month2Date,
	sum(case when year([Slot Date]) = year(@m2) and month([Slot Date]) = month(@m2) then 1 else 0 end) as Month2Slots,
	@m3 as Month3Date,
	sum(case when year([Slot Date]) = year(@m3) and month([Slot Date]) = month(@m3) then 1 else 0 end) as Month3Slots,
	@m4 as Month4Date,
	sum(case when year([Slot Date]) = year(@m4) and month([Slot Date]) = month(@m4) then 1 else 0 end) as Month4Slots,
	@m5 as Month5Date,
	sum(case when year([Slot Date]) = year(@m5) and month([Slot Date]) = month(@m5) then 1 else 0 end) as Month5Slots,
	@m6 as Month6Date,
	sum(case when year([Slot Date]) = year(@m6) and month([Slot Date]) = month(@m6) then 1 else 0 end) as Month6Slots,
	@m7 as Month7Date,
	sum(case when year([Slot Date]) = year(@m7) and month([Slot Date]) = month(@m7) then 1 else 0 end) as Month7Slots,
	@m8 as Month8Date,
	sum(case when year([Slot Date]) = year(@m8) and month([Slot Date]) = month(@m8) then 1 else 0 end) as Month8Slots,
	@m9 as Month9Date,
	sum(case when year([Slot Date]) = year(@m9) and month([Slot Date]) = month(@m9) then 1 else 0 end) as Month9Slots,
	@m10 as Month10Date,
	sum(case when year([Slot Date]) = year(@m10) and month([Slot Date]) = month(@m10) then 1 else 0 end) as Month10Slots,
	@m11 as Month11Date,
	sum(case when year([Slot Date]) = year(@m11) and month([Slot Date]) = month(@m11) then 1 else 0 end) as Month11Slots,
	@m12 as Month12Date,
	sum(case when year([Slot Date]) = year(@m12) and month([Slot Date]) = month(@m12) then 1 else 0 end) as Month12Slots
	
	from #T
	group by [#T].[COMPANY NAME], [#T].[GROUPING], [#T].[Label], [#T].[Initials], [#T].[LabelTtl]

	--from (select Dealers.[COMPANY NAME], [v_Dealer Totals Breakdown By Quote].[GROUPING],
	--	  Label, [v_Dealer Totals Breakdown By Quote].Initials, LabelTtl, [Prod Date] as JobStartDate
	--	  from SysproCompanyA.dbo.WipMaster with (nolock)
	--	  inner join Orders with (nolock) ON cast(Orders.WO# as varchar(20)) = WipMaster.Job
	--	  inner join Production with (nolock) on Orders.Quote# = Production.Quote#
	--	  inner join Dealers with (nolock) on Orders.DealerID = Dealers.ID
	--	  inner join [v_Order Book Detail v2_All] with (nolock) on Orders.Quote# = [v_Order Book Detail v2_All].Quote#
	--	  inner join [v_Dealer Totals Breakdown By Quote] on Orders.Quote# = [v_Dealer Totals Breakdown By Quote].Quote#
	--	  where (Orders.[Po Date] is not null and Orders.[Po Date] <= @sd)
	--	  and ([v_Order Book Detail v2_All].[Invoice Date] is null or [v_Order Book Detail v2_All].[Invoice Date] > @sd)
	--	  and (Orders.[Date Declined] is null or Orders.[Date Declined] > @sd)
	--	  and ActCompleteDate is null
	--	  and Dealers.ID in (select Dealer 
	--						 from [Production Slots] with (nolock)
	--						 group by Dealer)

	--	  union all select Dealers.[COMPANY NAME], [v_Dealer Totals Breakdown By Quote].[GROUPING],
	--	  Label, [v_Dealer Totals Breakdown By Quote].Initials, LabelTtl, [Prod Date]
	--	  from Production with (nolock)
	--	  inner join Orders with (nolock) ON Production.Quote# = Orders.Quote#
	--	  inner join Dealers with (nolock) on Orders.DealerID = Dealers.ID
	--	  inner join [v_Order Book Detail v2_All] with (nolock) on Orders.Quote# = [v_Order Book Detail v2_All].Quote#
	--	  inner join #AccessQuoteHours as subC on Orders.Quote# = subC.Quote#
	--	  inner join [v_Dealer Totals Breakdown By Quote] on Orders.Quote# = [v_Dealer Totals Breakdown By Quote].Quote#
	--	  left outer join SysproCompanyA.dbo.v_CompletedJobInfo with (nolock) on cast(Orders.WO# as varchar(20)) = v_CompletedJobInfo.Job
	--	  where (orders.[Po Date] is not null and orders.[Po Date] <= @sd)
	--	  and ([v_Order Book Detail v2_All].[Invoice Date] is null or [v_Order Book Detail v2_All].[Invoice Date] > @sd)
	--	  and (orders.[Date Declined] is null or orders.[Date Declined] > @sd)
	--	  and ActCompleteDate is null
	--	  and Orders.WO# is null
	--	  and NetBudget <> 0
	--	  and Dealers.ID in (select Dealer 
	--						 from [Production Slots] with (nolock)
	--						 group by Dealer)) as mainsub
	--group by [COMPANY NAME], [GROUPING], Label, Initials, LabelTtl

	--union all select 0 as RptGrouping, 'Production Slots By Dealer as of ' AS [RptGroupName], [COMPANY NAME], [GROUPING], [Label], [Initials], [LabelTtl],
	--@m1 as Month1Date,
	--sum(case when year([Slot Date]) = year(@m1) and month([Slot Date]) = month(@m1) and [Slot Status] = 0 then 1 else 0 end) as Month1Slots,
	--@m2 as Month2Date,
	--sum(case when year([Slot Date]) = year(@m2) and month([Slot Date]) = month(@m2) and [Slot Status] = 0 then 1 else 0 end) as Month2Slots,
	--@m3 as Month3Date,
	--sum(case when year([Slot Date]) = year(@m3) and month([Slot Date]) = month(@m3) and [Slot Status] = 0 then 1 else 0 end) as Month3Slots,
	--@m4 as Month4Date,
	--sum(case when year([Slot Date]) = year(@m4) and month([Slot Date]) = month(@m4) and [Slot Status] = 0 then 1 else 0 end) as Month4Slots,
	--@m5 as Month5Date,
	--sum(case when year([Slot Date]) = year(@m5) and month([Slot Date]) = month(@m5) and [Slot Status] = 0 then 1 else 0 end) as Month5Slots,
	--@m6 as Month6Date,
	--sum(case when year([Slot Date]) = year(@m6) and month([Slot Date]) = month(@m6) and [Slot Status] = 0 then 1 else 0 end) as Month6Slots,
	--@m7 as Month7Date,
	--sum(case when year([Slot Date]) = year(@m7) and month([Slot Date]) = month(@m7) and [Slot Status] = 0 then 1 else 0 end) as Month7Slots,
	--@m8 as Month8Date,
	--sum(case when year([Slot Date]) = year(@m8) and month([Slot Date]) = month(@m8) and [Slot Status] = 0 then 1 else 0 end) as Month8Slots,
	--@m9 as Month9Date,
	--sum(case when year([Slot Date]) = year(@m9) and month([Slot Date]) = month(@m9) and [Slot Status] = 0 then 1 else 0 end) as Month9Slots,
	--@m10 as Month10Date,
	--sum(case when year([Slot Date]) = year(@m10) and month([Slot Date]) = month(@m10) and [Slot Status] = 0 then 1 else 0 end) as Month10Slots,
	--@m11 as Month11Date,
	--sum(case when year([Slot Date]) = year(@m11) and month([Slot Date]) = month(@m11) and [Slot Status] = 0 then 1 else 0 end) as Month11Slots,
	--@m12 as Month12Date,
	--sum(case when year([Slot Date]) = year(@m12) and month([Slot Date]) = month(@m12) and [Slot Status] = 0 then 1 else 0 end) as Month12Slots
	
	--from #T
	--group by [#T].[COMPANY NAME], [#T].[GROUPING], [#T].[Label], [#T].[Initials], [#T].[LabelTtl]
	--from [Production Slots] with (nolock) 
	--inner join Dealers with (nolock) on [Production Slots].Dealer = Dealers.ID
	--inner join [v_Dealer Totals Breakdown] on Dealers.Initials = [v_Dealer Totals Breakdown].Initials
	--group by [COMPANY NAME], [GROUPING], Label, Dealers.Initials, LabelTtl

	--union all select 2 as RptGrouping, 'Budgeted Production Slots as of ' as RptGroupName, [COMPANY NAME], [GROUPING], Label, Initials, LabelTtl,
	--@m1 as Month1Date,
	--sum(case when year([Original Slot Date]) = year(@m1) and month([Original Slot Date]) = month(@m1) then 1 else 0 end) as Month1Slots,
	--@m2 as Month2Date,
	--sum(case when year([Original Slot Date]) = year(@m2) and month([Original Slot Date]) = month(@m2) then 1 else 0 end) as Month2Slots,
	--@m3 as Month3Date,
	--sum(case when year([Original Slot Date]) = year(@m3) and month([Original Slot Date]) = month(@m3) then 1 else 0 end) as Month3Slots,
	--@m4 as Month4Date,
	--sum(case when year([Original Slot Date]) = year(@m4) and month([Original Slot Date]) = month(@m4) then 1 else 0 end) as Month4Slots,
	--@m5 as Month5Date,
	--sum(case when year([Original Slot Date]) = year(@m5) and month([Original Slot Date]) = month(@m5) then 1 else 0 end) as Month5Slots,
	--@m6 as Month6Date,
	--sum(case when year([Original Slot Date]) = year(@m6) and month([Original Slot Date]) = month(@m6) then 1 else 0 end) as Month6Slots,
	--@m7 as Month7Date,
	--sum(case when year([Original Slot Date]) = year(@m7) and month([Original Slot Date]) = month(@m7) then 1 else 0 end) as Month7Slots,
	--@m8 as Month8Date,
	--sum(case when year([Original Slot Date]) = year(@m8) and month([Original Slot Date]) = month(@m8) then 1 else 0 end) as Month8Slots,
	--@m9 as Month9Date,
	--sum(case when year([Original Slot Date]) = year(@m9) and month([Original Slot Date]) = month(@m9) then 1 else 0 end) as Month9Slots,
	--@m10 as Month10Date,
	--sum(case when year([Original Slot Date]) = year(@m10) and month([Original Slot Date]) = month(@m10) then 1 else 0 end) as Month10Slots,
	--@m11 as Month11Date,
	--sum(case when year([Original Slot Date]) = year(@m11) and month([Original Slot Date]) = month(@m11) then 1 else 0 end) as Month11Slots,
	--@m12 as Month12Date,
	--sum(case when year([Original Slot Date]) = year(@m12) and month([Original Slot Date]) = month(@m12) then 1 else 0 end) as Month12Slots
	
	
	--from #T
	--group by [#T].[COMPANY NAME], [#T].[GROUPING], [#T].[Label], [#T].[Initials], [#T].[LabelTtl]

END


-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------

USE [BWSdb]
GO
/****** Object:  StoredProcedure [dbo].[sp_ProductionSlotsvsForecastRpt 2]    Script Date: 6/29/2021 9:52:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Avery Briggs>
-- Create date: <2021-06-29>
-- Description:	<Generate the Dealer Slots VS Forecast report.>
--=============================================

ALTER PROCEDURE [dbo].[sp_ProductionSlotsvsForecastRpt 2] 
	-- Add the parameters for the stored procedure here
	@sd datetime,
	@ss int = 1
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	CREATE TABLE #T (
		[COMPANY NAME] varchar(50),
		[Slot Type] varchar(50),
		[GROUPING] int,
		[Label] varchar(50),
		[Initials] varchar(10),
		[LabelTtl] varchar(50),
		[Slot Status] int,
		[January] int,
		[February] int,
		[March] int,
		[April] int,
		[May] int,
		[June] int,
		[July] int,
		[August] int,
		[September] int,
		[October] int,
		[November] int,
		[December] int 
	)

	INSERT INTO #T EXEC [dbo].[sp_GetSlotReport] @StartDate = @sd, @SlotStatus = @ss
	

    -- Insert statements for procedure here
	declare @m1 datetime = DATEADD(mm, DATEDIFF(mm, 0, @sd), 0)

	declare @m2 datetime = dateadd(month, 1, @m1),
			@m3 datetime = dateadd(month, 2, @m1),
			@m4 datetime = dateadd(month, 3, @m1),
			@m5 datetime = dateadd(month, 4, @m1),
			@m6 datetime = dateadd(month, 5, @m1),
			@m7 datetime = dateadd(month, 6, @m1),
			@m8 datetime = dateadd(month, 7, @m1),
			@m9 datetime = dateadd(month, 8, @m1),
			@m10 datetime = dateadd(month, 9, @m1),
			@m11 datetime = dateadd(month, 10, @m1),
			@m12 datetime = dateadd(month, 11, @m1)
	
	----Drop and create temp table in tmpdb SQL database for faster processing for fetching Access Quote Hours grouped by WorkCentre
	--IF OBJECT_ID('tempdb..#AccessQuoteHours') IS NOT NULL
	--	DROP TABLE #AccessQuoteHours

	--create table #AccessQuoteHours
	--(
	--	Quote# int,
	--	WorkCentre varchar(30),
	--	NetBudget decimal(9, 2)
	--)

	----INSERT INTO #tab EXEC [sp_GetSlotReport] @StartDate = '2021-06-29'
	
	--insert into #AccessQuoteHours
	--select Quote#, WorkCentre, sum([Hours]) as NetHours
	--			from (select Quote#, 'A' as WorkCentre, sum(Axles) as [Hours]
	--				  from [Order Hours] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'A', sum(Axles * Qty) as [Hours]
	--				  from [Order Options] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'A', sum(Axles * Qty) as [Hours]
	--				  from [Custom Work] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'T', sum([Step 1]) as [Hours]
	--				  from [Order Hours] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'T', sum([Step 1] * Qty) as [Hours]
	--				  from [Order Options] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'T', sum([Step 1] * Qty) as [Hours]
	--				  from [Custom Work] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'T', sum([Step 2]) as [Hours]
	--				  from [Order Hours] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'T', sum([Step 2] * Qty) as [Hours]
	--				  from [Order Options] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'T', sum([Step 2] * Qty) as [Hours]
	--				  from [Custom Work] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'P', sum(Blast) as [Hours]
	--				  from [Order Hours] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'P', sum(Blast * Qty) as [Hours]
	--				  from [Order Options] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'P', sum(Blast * Qty) as [Hours]
	--				  from [Custom Work] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'P', sum(Paint) as [Hours]
	--				  from [Order Hours] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'P', sum(Paint * Qty) as [Hours]
	--				  from [Order Options] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'P', sum(Paint * Qty) as [Hours]
	--				  from [Custom Work] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'F', sum([Finish - GNK]) as [Hours]
	--				  from [Order Hours] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'F', sum([Finish - GNK] * Qty) as [Hours]
	--				  from [Order Options] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'F', sum([Finish - GNK] * Qty) as [Hours]
	--				  from [Custom Work] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'F', sum([Final Assembly]) as [Hours]
	--				  from [Order Hours] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'F', sum([Final Assembly] * Qty) as [Hours]
	--				  from [Order Options] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'F', sum([Final Assembly] * Qty) as [Hours]
	--				  from [Custom Work] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'F', sum([Tire Assembly]) as [Hours]
	--				  from [Order Hours] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'F', sum([Tire Assembly] * Qty) as [Hours]
	--				  from [Order Options] with (nolock)
	--				  group by Quote#

	--				  union all select Quote#, 'F', sum([Tire Assembly] * Qty) as [Hours]
	--				  from [Custom Work] with (nolock)
	--				  group by Quote#) as mainsub
	--			group by Quote#, WorkCentre

	--Final select statement
	select 0 as RptGrouping, 'Production Forecast (Ordered Units) as of ' as RptGroupName, [COMPANY NAME], [GROUPING], Label, Initials, LabelTtl,
	@m1 as Month1Date,
	sum(case when [January] LIKE month(@m1) then 1 else 0 end) as Month1Slots,
	@m2 as Month2Date,
	sum(case when [February]) LIKE month(@m2) then 1 else 0 end) as Month2Slots,
	@m3 as Month3Date,
	sum(case when [March] LIKE month(@m3) then 1 else 0 end) as Month3Slots,
	@m4 as Month4Date,
	sum(case when [April] LIKE month(@m4) then 1 else 0 end) as Month4Slots,
	@m5 as Month5Date,
	sum(case when [May] LIKE month(@m5) then 1 else 0 end) as Month5Slots,
	@m6 as Month6Date,
	sum(case when [June] LIKE month(@m6) then 1 else 0 end) as Month6Slots,
	@m7 as Month7Date,
	sum(case when [July] LIKE month(@m7) then 1 else 0 end) as Month7Slots,
	@m8 as Month8Date,
	sum(case when [August] LIKE month(@m8) then 1 else 0 end) as Month8Slots,
	@m9 as Month9Date,
	sum(case when [September] LIKE month(@m9) then 1 else 0 end) as Month9Slots,
	@m10 as Month10Date,
	sum(case when [October] LIKE month(@m10) then 1 else 0 end) as Month10Slots,
	@m11 as Month11Date,
	sum(case when [November] LIKE month(@m11) then 1 else 0 end) as Month11Slots,
	@m12 as Month12Date,
	sum(case when [December] LIKE month(@m12) then 1 else 0 end) as Month12Slots
	
	from #T
	group by [#T].[COMPANY NAME], [#T].[GROUPING], [#T].[Label], [#T].[Initials], [#T].[LabelTtl]

	--from (select Dealers.[COMPANY NAME], [v_Dealer Totals Breakdown By Quote].[GROUPING],
	--	  Label, [v_Dealer Totals Breakdown By Quote].Initials, LabelTtl, [Prod Date] as JobStartDate
	--	  from SysproCompanyA.dbo.WipMaster with (nolock)
	--	  inner join Orders with (nolock) ON cast(Orders.WO# as varchar(20)) = WipMaster.Job
	--	  inner join Production with (nolock) on Orders.Quote# = Production.Quote#
	--	  inner join Dealers with (nolock) on Orders.DealerID = Dealers.ID
	--	  inner join [v_Order Book Detail v2_All] with (nolock) on Orders.Quote# = [v_Order Book Detail v2_All].Quote#
	--	  inner join [v_Dealer Totals Breakdown By Quote] on Orders.Quote# = [v_Dealer Totals Breakdown By Quote].Quote#
	--	  where (Orders.[Po Date] is not null and Orders.[Po Date] <= @sd)
	--	  and ([v_Order Book Detail v2_All].[Invoice Date] is null or [v_Order Book Detail v2_All].[Invoice Date] > @sd)
	--	  and (Orders.[Date Declined] is null or Orders.[Date Declined] > @sd)
	--	  and ActCompleteDate is null
	--	  and Dealers.ID in (select Dealer 
	--						 from [Production Slots] with (nolock)
	--						 group by Dealer)

	--	  union all select Dealers.[COMPANY NAME], [v_Dealer Totals Breakdown By Quote].[GROUPING],
	--	  Label, [v_Dealer Totals Breakdown By Quote].Initials, LabelTtl, [Prod Date]
	--	  from Production with (nolock)
	--	  inner join Orders with (nolock) ON Production.Quote# = Orders.Quote#
	--	  inner join Dealers with (nolock) on Orders.DealerID = Dealers.ID
	--	  inner join [v_Order Book Detail v2_All] with (nolock) on Orders.Quote# = [v_Order Book Detail v2_All].Quote#
	--	  inner join #AccessQuoteHours as subC on Orders.Quote# = subC.Quote#
	--	  inner join [v_Dealer Totals Breakdown By Quote] on Orders.Quote# = [v_Dealer Totals Breakdown By Quote].Quote#
	--	  left outer join SysproCompanyA.dbo.v_CompletedJobInfo with (nolock) on cast(Orders.WO# as varchar(20)) = v_CompletedJobInfo.Job
	--	  where (orders.[Po Date] is not null and orders.[Po Date] <= @sd)
	--	  and ([v_Order Book Detail v2_All].[Invoice Date] is null or [v_Order Book Detail v2_All].[Invoice Date] > @sd)
	--	  and (orders.[Date Declined] is null or orders.[Date Declined] > @sd)
	--	  and ActCompleteDate is null
	--	  and Orders.WO# is null
	--	  and NetBudget <> 0
	--	  and Dealers.ID in (select Dealer 
	--						 from [Production Slots] with (nolock)
	--						 group by Dealer)) as mainsub
	--group by [COMPANY NAME], [GROUPING], Label, Initials, LabelTtl

	--union all select 0 as RptGrouping, 'Production Slots By Dealer as of ' AS [RptGroupName], [COMPANY NAME], [GROUPING], [Label], [Initials], [LabelTtl],
	--@m1 as Month1Date,
	--sum(case when year([Slot Date]) = year(@m1) and month([Slot Date]) = month(@m1) and [Slot Status] = 0 then 1 else 0 end) as Month1Slots,
	--@m2 as Month2Date,
	--sum(case when year([Slot Date]) = year(@m2) and month([Slot Date]) = month(@m2) and [Slot Status] = 0 then 1 else 0 end) as Month2Slots,
	--@m3 as Month3Date,
	--sum(case when year([Slot Date]) = year(@m3) and month([Slot Date]) = month(@m3) and [Slot Status] = 0 then 1 else 0 end) as Month3Slots,
	--@m4 as Month4Date,
	--sum(case when year([Slot Date]) = year(@m4) and month([Slot Date]) = month(@m4) and [Slot Status] = 0 then 1 else 0 end) as Month4Slots,
	--@m5 as Month5Date,
	--sum(case when year([Slot Date]) = year(@m5) and month([Slot Date]) = month(@m5) and [Slot Status] = 0 then 1 else 0 end) as Month5Slots,
	--@m6 as Month6Date,
	--sum(case when year([Slot Date]) = year(@m6) and month([Slot Date]) = month(@m6) and [Slot Status] = 0 then 1 else 0 end) as Month6Slots,
	--@m7 as Month7Date,
	--sum(case when year([Slot Date]) = year(@m7) and month([Slot Date]) = month(@m7) and [Slot Status] = 0 then 1 else 0 end) as Month7Slots,
	--@m8 as Month8Date,
	--sum(case when year([Slot Date]) = year(@m8) and month([Slot Date]) = month(@m8) and [Slot Status] = 0 then 1 else 0 end) as Month8Slots,
	--@m9 as Month9Date,
	--sum(case when year([Slot Date]) = year(@m9) and month([Slot Date]) = month(@m9) and [Slot Status] = 0 then 1 else 0 end) as Month9Slots,
	--@m10 as Month10Date,
	--sum(case when year([Slot Date]) = year(@m10) and month([Slot Date]) = month(@m10) and [Slot Status] = 0 then 1 else 0 end) as Month10Slots,
	--@m11 as Month11Date,
	--sum(case when year([Slot Date]) = year(@m11) and month([Slot Date]) = month(@m11) and [Slot Status] = 0 then 1 else 0 end) as Month11Slots,
	--@m12 as Month12Date,
	--sum(case when year([Slot Date]) = year(@m12) and month([Slot Date]) = month(@m12) and [Slot Status] = 0 then 1 else 0 end) as Month12Slots
	
	--from #T
	--group by [#T].[COMPANY NAME], [#T].[GROUPING], [#T].[Label], [#T].[Initials], [#T].[LabelTtl]
	--from [Production Slots] with (nolock) 
	--inner join Dealers with (nolock) on [Production Slots].Dealer = Dealers.ID
	--inner join [v_Dealer Totals Breakdown] on Dealers.Initials = [v_Dealer Totals Breakdown].Initials
	--group by [COMPANY NAME], [GROUPING], Label, Dealers.Initials, LabelTtl

	--union all select 2 as RptGrouping, 'Budgeted Production Slots as of ' as RptGroupName, [COMPANY NAME], [GROUPING], Label, Initials, LabelTtl,
	--@m1 as Month1Date,
	--sum(case when year([Original Slot Date]) = year(@m1) and month([Original Slot Date]) = month(@m1) then 1 else 0 end) as Month1Slots,
	--@m2 as Month2Date,
	--sum(case when year([Original Slot Date]) = year(@m2) and month([Original Slot Date]) = month(@m2) then 1 else 0 end) as Month2Slots,
	--@m3 as Month3Date,
	--sum(case when year([Original Slot Date]) = year(@m3) and month([Original Slot Date]) = month(@m3) then 1 else 0 end) as Month3Slots,
	--@m4 as Month4Date,
	--sum(case when year([Original Slot Date]) = year(@m4) and month([Original Slot Date]) = month(@m4) then 1 else 0 end) as Month4Slots,
	--@m5 as Month5Date,
	--sum(case when year([Original Slot Date]) = year(@m5) and month([Original Slot Date]) = month(@m5) then 1 else 0 end) as Month5Slots,
	--@m6 as Month6Date,
	--sum(case when year([Original Slot Date]) = year(@m6) and month([Original Slot Date]) = month(@m6) then 1 else 0 end) as Month6Slots,
	--@m7 as Month7Date,
	--sum(case when year([Original Slot Date]) = year(@m7) and month([Original Slot Date]) = month(@m7) then 1 else 0 end) as Month7Slots,
	--@m8 as Month8Date,
	--sum(case when year([Original Slot Date]) = year(@m8) and month([Original Slot Date]) = month(@m8) then 1 else 0 end) as Month8Slots,
	--@m9 as Month9Date,
	--sum(case when year([Original Slot Date]) = year(@m9) and month([Original Slot Date]) = month(@m9) then 1 else 0 end) as Month9Slots,
	--@m10 as Month10Date,
	--sum(case when year([Original Slot Date]) = year(@m10) and month([Original Slot Date]) = month(@m10) then 1 else 0 end) as Month10Slots,
	--@m11 as Month11Date,
	--sum(case when year([Original Slot Date]) = year(@m11) and month([Original Slot Date]) = month(@m11) then 1 else 0 end) as Month11Slots,
	--@m12 as Month12Date,
	--sum(case when year([Original Slot Date]) = year(@m12) and month([Original Slot Date]) = month(@m12) then 1 else 0 end) as Month12Slots
	
	
	--from #T
	--group by [#T].[COMPANY NAME], [#T].[GROUPING], [#T].[Label], [#T].[Initials], [#T].[LabelTtl]

END
