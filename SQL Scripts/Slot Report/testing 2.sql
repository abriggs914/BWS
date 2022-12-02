USE [BWSdb]
GO
--/****** Object:  StoredProcedure [dbo].[sp_ProductionSlotsvsForecastRpt]    Script Date: 2022-12-02 11:11:18 AM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO

----2022-09-28 James Crawford - Added where clause to exclude 3 Half Round Work Orders from reports: 10015030 - 10015032
----IT Request #001197

--ALTER PROCEDURE [dbo].[sp_ProductionSlotsvsForecastRpt] 
--	-- Add the parameters for the stored procedure here
--	@sd datetime
--AS
--BEGIN
--	-- SET NOCOUNT ON added to prevent extra result sets from
--	-- interfering with SELECT statements.
--	SET NOCOUNT ON;

	------------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------

	DECLARE @sd AS DATETIME;
	SELECT @sd = '2022-11-01';

	------------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------


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
	
	--Drop and create temp table in tmpdb SQL database for faster processing for fetching Access Quote Hours grouped by WorkCentre
	IF OBJECT_ID('tempdb..#AccessQuoteHours') IS NOT NULL
		DROP TABLE #AccessQuoteHours

	create table #AccessQuoteHours
	(
		Quote# int,
		WorkCentre varchar(30),
		NetBudget decimal(9, 2)
	)
	
	insert into #AccessQuoteHours
	select Quote#, WorkCentre, sum([Hours]) as NetHours
				from (select Quote#, 'A' as WorkCentre, sum(Axles) as [Hours]
					  from [Order Hours] with (nolock)
					  group by Quote#

					  union all select Quote#, 'A', sum(Axles * Qty) as [Hours]
					  from [Order Options] with (nolock)
					  group by Quote#

					  union all select Quote#, 'A', sum(Axles * Qty) as [Hours]
					  from [Custom Work] with (nolock)
					  group by Quote#

					  union all select Quote#, 'T', sum([Step 1]) as [Hours]
					  from [Order Hours] with (nolock)
					  group by Quote#

					  union all select Quote#, 'T', sum([Step 1] * Qty) as [Hours]
					  from [Order Options] with (nolock)
					  group by Quote#

					  union all select Quote#, 'T', sum([Step 1] * Qty) as [Hours]
					  from [Custom Work] with (nolock)
					  group by Quote#

					  union all select Quote#, 'T', sum([Step 2]) as [Hours]
					  from [Order Hours] with (nolock)
					  group by Quote#

					  union all select Quote#, 'T', sum([Step 2] * Qty) as [Hours]
					  from [Order Options] with (nolock)
					  group by Quote#

					  union all select Quote#, 'T', sum([Step 2] * Qty) as [Hours]
					  from [Custom Work] with (nolock)
					  group by Quote#

					  union all select Quote#, 'P', sum(Blast) as [Hours]
					  from [Order Hours] with (nolock)
					  group by Quote#

					  union all select Quote#, 'P', sum(Blast * Qty) as [Hours]
					  from [Order Options] with (nolock)
					  group by Quote#

					  union all select Quote#, 'P', sum(Blast * Qty) as [Hours]
					  from [Custom Work] with (nolock)
					  group by Quote#

					  union all select Quote#, 'P', sum(Paint) as [Hours]
					  from [Order Hours] with (nolock)
					  group by Quote#

					  union all select Quote#, 'P', sum(Paint * Qty) as [Hours]
					  from [Order Options] with (nolock)
					  group by Quote#

					  union all select Quote#, 'P', sum(Paint * Qty) as [Hours]
					  from [Custom Work] with (nolock)
					  group by Quote#

					  union all select Quote#, 'F', sum([Finish - GNK]) as [Hours]
					  from [Order Hours] with (nolock)
					  group by Quote#

					  union all select Quote#, 'F', sum([Finish - GNK] * Qty) as [Hours]
					  from [Order Options] with (nolock)
					  group by Quote#

					  union all select Quote#, 'F', sum([Finish - GNK] * Qty) as [Hours]
					  from [Custom Work] with (nolock)
					  group by Quote#

					  union all select Quote#, 'F', sum([Final Assembly]) as [Hours]
					  from [Order Hours] with (nolock)
					  group by Quote#

					  union all select Quote#, 'F', sum([Final Assembly] * Qty) as [Hours]
					  from [Order Options] with (nolock)
					  group by Quote#

					  union all select Quote#, 'F', sum([Final Assembly] * Qty) as [Hours]
					  from [Custom Work] with (nolock)
					  group by Quote#

					  union all select Quote#, 'F', sum([Tire Assembly]) as [Hours]
					  from [Order Hours] with (nolock)
					  group by Quote#

					  union all select Quote#, 'F', sum([Tire Assembly] * Qty) as [Hours]
					  from [Order Options] with (nolock)
					  group by Quote#

					  union all select Quote#, 'F', sum([Tire Assembly] * Qty) as [Hours]
					  from [Custom Work] with (nolock)
					  group by Quote#) as mainsub
				where Quote# in (
									select Quote#
									from
										Orders with (nolock)
									where
										Orders.WO# not in (10015030, 10015031, 10015032)
										or Orders.WO# is null
								)
				group by Quote#, WorkCentre
				
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
select
			Dealers.[COMPANY NAME], 
			[v_Dealer Totals Breakdown By Quote].[GROUPING],
			Label,
			[v_Dealer Totals Breakdown By Quote].Initials,
			LabelTtl,
			[Prod Date]
		from 
			Production with (nolock)
		inner join
			Orders with (nolock)
		ON
			Production.Quote# = Orders.Quote#
		inner join 
			Dealers with (nolock)
		on
			Orders.DealerID = Dealers.ID
		inner join
			[v_Order Book Detail v2_All] with (nolock)
		on
			Orders.Quote# = [v_Order Book Detail v2_All].Quote#
		inner join
			#AccessQuoteHours as subC 
		on
			Orders.Quote# = subC.Quote#
		inner join
			[v_Dealer Totals Breakdown By Quote]
		on
			Orders.Quote# = [v_Dealer Totals Breakdown By Quote].Quote#
		left outer join
			SysproCompanyA.dbo.v_CompletedJobInfo with (nolock)
		on
			cast(Orders.WO# as varchar(20)) = v_CompletedJobInfo.Job
		where
			(orders.[Po Date] is not null and orders.[Po Date] <= @sd)
			and (
				[v_Order Book Detail v2_All].[Invoice Date] is null
				or [v_Order Book Detail v2_All].[Invoice Date] > @sd
			)
			and (
				orders.[Date Declined] is null
				or orders.[Date Declined] > @sd
			)
			and ActCompleteDate is null
			and Orders.WO# is null
			and NetBudget <> 0
			and Dealers.ID in (
				select
					Dealer 
				from
					[Production Slots] with (nolock)
				group by
					Dealer
			)
			and (
				Orders.WO# not in (10015030, 10015031, 10015032)
				or Orders.WO# is null
			)
			
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

select
			Dealers.[COMPANY NAME],
			[v_Dealer Totals Breakdown By Quote].[GROUPING],
			Label,
			[v_Dealer Totals Breakdown By Quote].Initials,
			LabelTtl,
			[Prod Date] as JobStartDate
		from
			SysproCompanyA.dbo.WipMaster with (nolock)
		inner join
			Orders with (nolock)
		ON
			cast(Orders.WO# as varchar(20)) = WipMaster.Job
		inner join
			Production with (nolock) 
		on
			Orders.Quote# = Production.Quote#
		inner join
			Dealers with (nolock)
		on
			Orders.DealerID = Dealers.ID
		inner join 
			[v_Order Book Detail v2_All] with (nolock)
		on
			Orders.Quote# = [v_Order Book Detail v2_All].Quote#
		inner join
			[v_Dealer Totals Breakdown By Quote] 
		on
			Orders.Quote# = [v_Dealer Totals Breakdown By Quote].Quote#
		where 
			(Orders.[Po Date] is not null and Orders.[Po Date] <= @sd)
			and (
				[v_Order Book Detail v2_All].[Invoice Date] is null
				or [v_Order Book Detail v2_All].[Invoice Date] > @sd
			)
			and (
				Orders.[Date Declined] is null
				or Orders.[Date Declined] > @sd
			)
			and ActCompleteDate is null
			and Dealers.ID in (select Dealer 
							 from [Production Slots] with (nolock)
							 group by Dealer)
			and (
					Orders.WO# not in (10015030, 10015031, 10015032)
					or Orders.WO# is null
				)

-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

--Final select statement
	select 
		0 as RptGrouping,
		'Production Forecast (Ordered Units) as of ' as RptGroupName,
		[COMPANY NAME],
		[GROUPING],
		Label,
		Initials,
		LabelTtl,
		@m1 as Month1Date,
		sum(case when year(JobStartDate) = year(@m1) and month(JobStartDate) = month(@m1) then 1 else 0 end) as Month1Slots,
		@m2 as Month2Date,
		sum(case when year(JobStartDate) = year(@m2) and month(JobStartDate) = month(@m2) then 1 else 0 end) as Month2Slots,
		@m3 as Month3Date,
		sum(case when year(JobStartDate) = year(@m3) and month(JobStartDate) = month(@m3) then 1 else 0 end) as Month3Slots,
		@m4 as Month4Date,
		sum(case when year(JobStartDate) = year(@m4) and month(JobStartDate) = month(@m4) then 1 else 0 end) as Month4Slots,
		@m5 as Month5Date,
		sum(case when year(JobStartDate) = year(@m5) and month(JobStartDate) = month(@m5) then 1 else 0 end) as Month5Slots,
		@m6 as Month6Date,
		sum(case when year(JobStartDate) = year(@m6) and month(JobStartDate) = month(@m6) then 1 else 0 end) as Month6Slots,
		@m7 as Month7Date,
		sum(case when year(JobStartDate) = year(@m7) and month(JobStartDate) = month(@m7) then 1 else 0 end) as Month7Slots,
		@m8 as Month8Date,
		sum(case when year(JobStartDate) = year(@m8) and month(JobStartDate) = month(@m8) then 1 else 0 end) as Month8Slots,
		@m9 as Month9Date,
		sum(case when year(JobStartDate) = year(@m9) and month(JobStartDate) = month(@m9) then 1 else 0 end) as Month9Slots,
		@m10 as Month10Date,
		sum(case when year(JobStartDate) = year(@m10) and month(JobStartDate) = month(@m10) then 1 else 0 end) as Month10Slots,
		@m11 as Month11Date,
		sum(case when year(JobStartDate) = year(@m11) and month(JobStartDate) = month(@m11) then 1 else 0 end) as Month11Slots,
		@m12 as Month12Date,
		sum(case when year(JobStartDate) = year(@m12) and month(JobStartDate) = month(@m12) then 1 else 0 end) as Month12Slots
	from (
		select
			Dealers.[COMPANY NAME],
			[v_Dealer Totals Breakdown By Quote].[GROUPING],
			Label,
			[v_Dealer Totals Breakdown By Quote].Initials,
			LabelTtl,
			[Prod Date] as JobStartDate
		from
			SysproCompanyA.dbo.WipMaster with (nolock)
		inner join
			Orders with (nolock)
		ON
			cast(Orders.WO# as varchar(20)) = WipMaster.Job
		inner join
			Production with (nolock) 
		on
			Orders.Quote# = Production.Quote#
		inner join
			Dealers with (nolock)
		on
			Orders.DealerID = Dealers.ID
		inner join 
			[v_Order Book Detail v2_All] with (nolock)
		on
			Orders.Quote# = [v_Order Book Detail v2_All].Quote#
		inner join
			[v_Dealer Totals Breakdown By Quote] 
		on
			Orders.Quote# = [v_Dealer Totals Breakdown By Quote].Quote#
		where 
			(Orders.[Po Date] is not null and Orders.[Po Date] <= @sd)
			and (
				[v_Order Book Detail v2_All].[Invoice Date] is null
				or [v_Order Book Detail v2_All].[Invoice Date] > @sd
			)
			and (
				Orders.[Date Declined] is null
				or Orders.[Date Declined] > @sd
			)
			and ActCompleteDate is null
			and Dealers.ID in (select Dealer 
							 from [Production Slots] with (nolock)
							 group by Dealer)
			and (
					Orders.WO# not in (10015030, 10015031, 10015032)
					or Orders.WO# is null
				)

		union all 
		select
			Dealers.[COMPANY NAME], 
			[v_Dealer Totals Breakdown By Quote].[GROUPING],
			Label,
			[v_Dealer Totals Breakdown By Quote].Initials,
			LabelTtl,
			[Prod Date]
		from 
			Production with (nolock)
		inner join
			Orders with (nolock)
		ON
			Production.Quote# = Orders.Quote#
		inner join 
			Dealers with (nolock)
		on
			Orders.DealerID = Dealers.ID
		inner join
			[v_Order Book Detail v2_All] with (nolock)
		on
			Orders.Quote# = [v_Order Book Detail v2_All].Quote#
		inner join
			#AccessQuoteHours as subC 
		on
			Orders.Quote# = subC.Quote#
		inner join
			[v_Dealer Totals Breakdown By Quote]
		on
			Orders.Quote# = [v_Dealer Totals Breakdown By Quote].Quote#
		left outer join
			SysproCompanyA.dbo.v_CompletedJobInfo with (nolock)
		on
			cast(Orders.WO# as varchar(20)) = v_CompletedJobInfo.Job
		where
			(orders.[Po Date] is not null and orders.[Po Date] <= @sd)
			and (
				[v_Order Book Detail v2_All].[Invoice Date] is null
				or [v_Order Book Detail v2_All].[Invoice Date] > @sd
			)
			and (
				orders.[Date Declined] is null
				or orders.[Date Declined] > @sd
			)
			and ActCompleteDate is null
			and Orders.WO# is null
			and NetBudget <> 0
			and Dealers.ID in (
				select
					Dealer 
				from
					[Production Slots] with (nolock)
				group by
					Dealer
			)
			and (
				Orders.WO# not in (10015030, 10015031, 10015032)
				or Orders.WO# is null
			)
	) as mainsub
	group by
		[COMPANY NAME],
		[GROUPING],
		Label,
		Initials, 
		LabelTtl