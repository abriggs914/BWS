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
	@ss int = 2
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
		[Month #] int,
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
	select 'Production Slots VS Forecast Report - ' AS [RptGroupName], [COMPANY NAME], [GROUPING], Label, Initials, LabelTtl, [Slot Type],
	@m1 as Month1Date,
	SUM(CASE 
		WHEN [Month #] = month(@m1) then [January]
		WHEN [Month #] = month(@m2) then [February]
		WHEN [Month #] = month(@m3) then [March]
		WHEN [Month #] = month(@m4) then [April]
		WHEN [Month #] = month(@m5) then [May]
		WHEN [Month #] = month(@m6) then [June]
		WHEN [Month #] = month(@m7) then [July]
		WHEN [Month #] = month(@m8) then [August]
		WHEN [Month #] = month(@m9) then [September]
		WHEN [Month #] = month(@m10) then [October]
		WHEN [Month #] = month(@m11) then [November]
		WHEN [Month #] = month(@m12) then [December]
		ELSE 0
	end) as Month1Slots,
	@m2 as Month2Date,
	sum([February]) as Month2Slots,
	@m3 as Month3Date,
	sum([March]) as Month3Slots,
	@m4 as Month4Date,
	sum([April]) as Month4Slots,
	@m5 as Month5Date,
	sum([May]) as Month5Slots,
	@m6 as Month6Date,
	sum([June]) as Month6Slots,
	@m7 as Month7Date,
	sum([July]) as Month7Slots,
	@m8 as Month8Date,
	sum([August]) as Month8Slots,
	@m9 as Month9Date,
	sum([September]) as Month9Slots,
	@m10 as Month10Date,
	sum([October]) as Month10Slots,
	@m11 as Month11Date,
	sum([November]) as Month11Slots,
	@m12 as Month12Date,
	SUM(CASE 
		WHEN [Month #] = month(@m1) then 1
		WHEN [Month #] = month(@m2) then 1
		WHEN [Month #] = month(@m3) then 1
		WHEN [Month #] = month(@m4) then 1
		WHEN [Month #] = month(@m5) then 1
		WHEN [Month #] = month(@m6) then 1
		WHEN [Month #] = month(@m7) then 1
		WHEN [Month #] = month(@m8) then 1
		WHEN [Month #] = month(@m9) then 1
		WHEN [Month #] = month(@m10) then 1
		WHEN [Month #] = month(@m11) then 1
		WHEN [Month #] = month(@m12) then 1
		ELSE 0
	end) as Month12Slots
	
	from #T
	group by [#T].[COMPANY NAME], [#T].[GROUPING], [#T].[Label], [#T].[Initials], [#T].[LabelTtl], [Slot Type]
END
GO


/*
sum(case when [Month #] = month(@m1) then 1 else 0 end) as Month1Slots,
	@m2 as Month2Date,
	sum(case when [Month #] = month(@m2) then 1 else 0 end) as Month2Slots,
	@m3 as Month3Date,
	sum(case when [Month #] = month(@m3) then 1 else 0 end) as Month3Slots,
	@m4 as Month4Date,
	sum(case when [Month #] = month(@m4) then 1 else 0 end) as Month4Slots,
	@m5 as Month5Date,
	sum(case when [Month #] = month(@m5) then 1 else 0 end) as Month5Slots,
	@m6 as Month6Date,
	sum(case when [Month #] = month(@m6) then 1 else 0 end) as Month6Slots,
	@m7 as Month7Date,
	sum(case when [Month #] = month(@m7) then 1 else 0 end) as Month7Slots,
	@m8 as Month8Date,
	sum(case when [Month #] = month(@m8) then 1 else 0 end) as Month8Slots,
	@m9 as Month9Date,
	sum(case when [Month #] = month(@m9) then 1 else 0 end) as Month9Slots,
	@m10 as Month10Date,
	sum(case when [Month #] = month(@m10) then 1 else 0 end) as Month10Slots,
	@m11 as Month11Date,
	sum(case when [Month #] = month(@m11) then 1 else 0 end) as Month11Slots,
	@m12 as Month12Date,
	sum(case when [Month #] = month(@m12) then 1 else 0 end) as Month12Slots
*/

/*

	(CASE 
		WHEN [Month #] = month(@m1) then sum([January])
		WHEN [Month #] = month(@m2) then sum([February])
		WHEN [Month #] = month(@m3) then sum([March])
		WHEN [Month #] = month(@m4) then sum([April])
		WHEN [Month #] = month(@m5) then sum([May])
		WHEN [Month #] = month(@m6) then sum([June])
		WHEN [Month #] = month(@m7) then sum([July])
		WHEN [Month #] = month(@m8) then sum([August])
		WHEN [Month #] = month(@m9) then sum([September])
		WHEN [Month #] = month(@m10) then sum([October])
		WHEN [Month #] = month(@m11) then sum([November])
		WHEN [Month #] = month(@m12) then sum([December])
		ELSE 0
	end) as Month1Slots,
*/

/*
SUM(CASE 
		WHEN [Month #] = month(@m1) then [January]
		WHEN [Month #] = month(@m2) then [February]
		WHEN [Month #] = month(@m3) then [March]
		WHEN [Month #] = month(@m4) then [April]
		WHEN [Month #] = month(@m5) then [May]
		WHEN [Month #] = month(@m6) then [June]
		WHEN [Month #] = month(@m7) then [July]
		WHEN [Month #] = month(@m8) then [August]
		WHEN [Month #] = month(@m9) then [September]
		WHEN [Month #] = month(@m10) then [October]
		WHEN [Month #] = month(@m11) then [November]
		WHEN [Month #] = month(@m12) then [December]
		ELSE 0
	end) as Month1Slots,
*/

/*

	SUM(CASE 
		WHEN [Month #] = month(@m1) then 1
		WHEN [Month #] = month(@m2) then 1
		WHEN [Month #] = month(@m3) then 1
		WHEN [Month #] = month(@m4) then 1
		WHEN [Month #] = month(@m5) then 1
		WHEN [Month #] = month(@m6) then 1
		WHEN [Month #] = month(@m7) then 1
		WHEN [Month #] = month(@m8) then 1
		WHEN [Month #] = month(@m9) then 1
		WHEN [Month #] = month(@m10) then 1
		WHEN [Month #] = month(@m11) then 1
		WHEN [Month #] = month(@m12) then 1
		ELSE 0
	end) as Month1Slots,
*/