USE [Stargatedb]
GO



---- Version 2023-09-14 1853


/****** Object:  StoredProcedure [dbo].[sp_PDSProductionSchedule_Slots]    Script Date: 2023-09-13 3:38:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[sp_PDSProductionSchedule_Slots] 
	-- Add the parameters for the stored procedure here
	@sd datetime, @ed datetime, @dayOffset INT
AS
BEGIN
	
	
	--DECLARE @sd DATETIME, @ed DATETIME, @dayOffset INT;
	--SELECT
	--	@sd = '2023-09-01',
	--	@ed = '2023-09-30',
	--	@dayOffset = 1  -- represents [PDS Subs Master].[ID]
	--;

--SELECT
--	*
--FROM
--	[SysproCompanyS].[dbo].[v_CalendarWorkDays]
--WHERE
--	[CalendarDate] BETWEEN @sd AND @ed

--SELECT
--	*
--FROM
--	[PDS Subs Master]
--WHERE
--	[PDS Subs Master].[ID] = @dayOffset AND [PDS Subs Master].[Active] = 1

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--DECLARE @weekendDays AS TABLE ([ID] INT IDENTITY(0, 1), [Name] NVARCHAR(15));
	--INSERT INTO @weekendDays ([Name]) VALUES ('Saturday'), ('Sunday');
	
	--DECLARE @holidaysOffset INT;
	--DECLARE @workDays INT;
	--DECLARE @weekends INT;
	--SELECT
	--	@holidaysOffset = SUM([N_Holidays]),
	--	@workDays = SUM([N_WorkDays]),
	--	@weekends = SUM([N_WeekendDays])
	--FROM (
	--	SELECT 
	--		--@holidaysOffset = SUM(CASE WHEN [WorkDay] = 1 THEN 0 ELSE (CASE WHEN [@weekendDays].[ID] IS NULL THEN 1 ELSE 0 END) END),
	--		--@weekends = SUM(CASE WHEN [WorkDay] = 1 THEN 0 ELSE (CASE WHEN [@weekendDays].[ID] IS NOT NULL THEN 1 ELSE 0 END) END),
	--		--@workDays = SUM(CASE WHEN [WorkDay] = 1 THEN 1 ELSE 0 END)
	--		SUM(CASE WHEN [WorkDay] = 1 THEN 0 ELSE (CASE WHEN [@weekendDays].[ID] IS NULL THEN 1 ELSE 0 END) END) AS [N_Holidays],
	--		SUM(CASE WHEN [WorkDay] = 1 THEN 0 ELSE (CASE WHEN [@weekendDays].[ID] IS NOT NULL THEN 1 ELSE 0 END) END) AS [N_WorkDays],
	--		SUM(CASE WHEN [WorkDay] = 1 THEN 1 ELSE 0 END) AS [N_WeekendDays]
	--		,
	--		[CalendarDate],
	--		[WorkDay]
	--	FROM
	--		[SysproCompanyS].[dbo].[v_CalendarWorkDays]
	--	CROSS JOIN
	--		[PDS Subs Master]
	--	LEFT JOIN
	--		@weekendDays
	--	ON
	--		DATENAME(WEEKDAY, [CalendarDate]) = [@weekendDays].[Name]
	--	WHERE 
	--		(DATEADD(DAY, [DayOffset], [CalendarDate]) BETWEEN @sd AND @ed)
	--		AND [PDS Subs Master].[Active] = 1
	--		AND [PDS Subs Master].[ID] = @dayOffset
	--	GROUP BY
	--		[CalendarDate],
	--		[WorkDay]
	--) AS [Src]
	--LEFT JOIN
	--	[SysproCompanyS].[dbo].[v_CalendarWorkDays] AS [B]
	--ON
	--	[Src].[CalendarDate] <= [B].[CalendarDate]

	--SELECT
	--	@holidaysOffset AS [H],
	--	@workDays AS [W],
	--	@weekends AS [K]

    -- Insert statements for procedure here
	--Add Quotes missing from Production Schedule
	insert into dtProductionScheduleV2 (SGQuote, WO#, JobStartDate, JobFinishDate, InputField1, InputField2)
	select OrdersV2.SGQuote, Job, WipMaster.JobStartDate, JobDeliveryDate, OrdersV2.[Model No], [COMPANY NAME]
	from BWSdb.dbo.OrdersV2 with (nolock)
	left outer join BWSdb.dbo.DealersV2 with (nolock) on OrdersV2.DealerID = DealersV2.ID
														 and OrdersV2.CompanyID = DealersV2.CompanyID
	left outer join SysproCompanyS.dbo.WipMaster with (nolock) on cast(OrdersV2.WO# as varchar(20)) COLLATE Latin1_General_BIN = WipMaster.Job
	left outer join dtProductionScheduleV2 with (nolock) on OrdersV2.SGQuote = dtProductionScheduleV2.SGQuote
	where ActCompleteDate is null
	and dtProductionScheduleV2.SGQuote is null
	and [Date Declined] is null

	--Remove cancelled units
	delete from dtProductionScheduleV2
	from dtProductionScheduleV2
	inner join BWSdb.dbo.OrdersV2 on dtProductionScheduleV2.SGQuote = OrdersV2.SGQuote
	where [Date Declined] is not null

	--Update units that have been linked to WOs
	update dtProductionScheduleV2
	set WO# = WipMaster.Job
	from dtProductionScheduleV2
	inner join BWSdb.dbo.OrdersV2 on dtProductionScheduleV2.SGQuote = OrdersV2.SGQuote
	inner join SysproCompanyS.dbo.WipMaster with (nolock) on cast(OrdersV2.WO# as varchar(20)) COLLATE Latin1_General_BIN = WipMaster.Job
	where dtProductionScheduleV2.WO# is null

	--Drop and create temp table in tmpdb SQL database for faster processing
	IF OBJECT_ID('tempdb..#ProdSched') IS NOT NULL
		DROP TABLE #ProdSched 

	create table #ProdSched
	(
		GroupID int,
		LO int,
		[Prod Line] nvarchar(255),
		[Prod Date] datetime,
		SGQuote varchar(8),
		WO# nvarchar(255),
		InputField1 nvarchar(50),
		InputField2 nvarchar(50),
		[GN WO#] nvarchar(50),
		Other nvarchar(255),
		[Other WO#] int,
		[Beam WO#] nvarchar(50),
		[Steel Kit WO#] nvarchar(50),
		JobStartDate nvarchar(50),
		Reviewed bit,
		NoNPOs int,
		[Stock/Sold] nvarchar(10),
		[Slot/Quote] int default(0),
		[Slot#] int,
		NoDays int default(1),
		HighRiskUnit bit default(0),
		IsGavlanized bit default(0)
	)

	--Adds units with Job Finish Date in date range
	insert into #ProdSched (LO, [Prod Line], [Prod Date], SGQuote, WO#, InputField1, InputField2, [Steel Kit WO#], JobStartDate)
	--select LO, [Prod Lines].[Prod Line], DATEADD(DAY, [DayOffset], [JobFinishDate]), OrdersV2.SGQuote, dtProductionScheduleV2.WO#, InputField1, InputField2, 
	select LO, [Prod Lines].[Prod Line], [Stargatedb].[dbo].[NEXT_BUSINESS_DAY]([JobFinishDate], [DayOffset]), OrdersV2.SGQuote, dtProductionScheduleV2.WO#, InputField1, InputField2, 
	[Steel Kit WO#], RIGHT('00' + cast(day(WipMaster.JobStartDate) as varchar), 2) + '-' + left(datename(mm, WipMaster.JobStartDate), 3)
	from [Prod Lines] with (nolock)
	left outer join dtProductionScheduleV2 with (nolock) on [Prod Lines].[Prod Line] = dtProductionScheduleV2.[JobStartLine]
	left outer join BWSdb.dbo.OrdersV2 with (nolock) on dtProductionScheduleV2.SGQuote = OrdersV2.SGQuote
	left outer join BWSdb.dbo.ProductionV2 with (nolock) on OrdersV2.SGQuote = ProductionV2.SGQuote
	left outer join SysproCompanyS.dbo.WipMaster with (nolock) on cast(ProductionV2.[Steel Kit WO#] as varchar(20)) collate Latin1_General_BIN = WipMaster.Job
	CROSS JOIN [PDS Subs Master]
	--where (DATEADD(DAY, [DayOffset], dtProductionScheduleV2.[JobFinishDate]) between @sd and @ed) AND [PDS Subs Master].[ID] = @dayOffset AND [PDS Subs Master].[Active] = 1
	where ([Stargatedb].[dbo].[NEXT_BUSINESS_DAY](dtProductionScheduleV2.[JobFinishDate], [DayOffset]) between @sd and @ed) AND [PDS Subs Master].[ID] = @dayOffset AND [PDS Subs Master].[Active] = 1
	and [Date Declined] is null

	
	--SELECT 'A', * FROM #ProdSched ORDER BY [GroupID], [Prod Date]

	--Adds missing calendar days to whole schedule based on Syspro's Company Calendar
	insert into #ProdSched ([Prod Date], [Prod Line], LO)
	select CalendarDate, mainsub.[Prod Line], mainsub.LO
	from (select CalendarDate, [Prod Line], LO 
		  from SysproCompanyS.dbo.v_CalendarWorkDays
		  cross join [Prod Lines]
		  where WorkDay = 1) as mainsub
	left outer join #ProdSched as a on mainsub.CalendarDate = a.[Prod Date]
	and mainsub.[Prod Line] = a.[Prod Line]
	where CalendarDate between @sd and @ed
	and [Prod Date] is null

	--SELECT @sd, @ed	
	--SELECT 'B', * FROM #ProdSched ORDER BY [GroupID], [Prod Date]

	--Update GroupID
	update #ProdSched
	set GroupID = LO

	--Update Job Start Date for Steel Kit, Beams, GN and Other WOs with multiple values (i.e. 12345/12346)
	declare @chars int

	select @chars = charindex('/', [Steel Kit WO#]) - 1 from #ProdSched
	where [Steel Kit WO#] like '%/%'

	update #ProdSched
	--set JobStartDate = RIGHT('00' + cast(day(DATEADD(DAY, [DayOffset], b.JobStartDate)) as varchar), 2) + '-' + left(datename(mm, DATEADD(DAY, [DayOffset], b.JobStartDate)), 3)
	set JobStartDate = RIGHT('00' + cast(day([Stargatedb].[dbo].[NEXT_BUSINESS_DAY](b.JobStartDate, [DayOffset])) as varchar), 2) 
	+ '-' + left(datename(mm, [Stargatedb].[dbo].[NEXT_BUSINESS_DAY](b.JobStartDate, [DayOffset])), 3)
	from #ProdSched as a
	inner join SysproCompanyS.dbo.WipMaster as b with (nolock) on left(a.[Steel Kit WO#], @chars) collate Latin1_General_BIN = right(b.Job, @chars)
	CROSS JOIN [PDS Subs Master]
	where left(a.[Steel Kit WO#], @chars) <> '00000'
	and a.[Steel Kit WO#] like '%/%'
	and left(Job, 1) = '2'
	AND [PDS Subs Master].[Active] = 1
	AND [PDS Subs Master].[ID] = @dayOffset

	update #ProdSched
	--set JobStartDate = case when DATEADD(DAY, [DayOffset], a.JobStartDate) is null then RIGHT('00' + cast(day(DATEADD(DAY, [DayOffset], b.JobStartDate)) as varchar), 2) + '-' + left(datename(mm, DATEADD(DAY, [DayOffset], b.JobStartDate)), 3)
	--						else DATEADD(DAY, [DayOffset], a.JobStartDate) + '/' + RIGHT('00' + cast(day(DATEADD(DAY, [DayOffset], b.JobStartDate)) as varchar), 2) + '-' + left(datename(mm, DATEADD(DAY, [DayOffset], b.JobStartDate)), 3) end
	set JobStartDate = case when [Stargatedb].[dbo].[NEXT_BUSINESS_DAY](a.JobStartDate, [DayOffset]) is null then RIGHT('00' + cast(day([Stargatedb].[dbo].[NEXT_BUSINESS_DAY](b.JobStartDate, [DayOffset])) as varchar), 2) + '-' + left(datename(mm, [Stargatedb].[dbo].[NEXT_BUSINESS_DAY](b.JobStartDate, [DayOffset])), 3)
							else [Stargatedb].[dbo].[NEXT_BUSINESS_DAY](a.JobStartDate, [DayOffset]) + '/' + RIGHT('00' + cast(day([Stargatedb].[dbo].[NEXT_BUSINESS_DAY](b.JobStartDate, [DayOffset])) as varchar), 2) + '-' + left(datename(mm, [Stargatedb].[dbo].[NEXT_BUSINESS_DAY](b.JobStartDate, [DayOffset])), 3) end
	from #ProdSched as a
	inner join SysproCompanyS.dbo.WipMaster as b with (nolock) on right(a.[Steel Kit WO#], @chars) collate Latin1_General_BIN = right(b.Job, @chars)
	CROSS JOIN [PDS Subs Master]
	where right(a.[Steel Kit WO#], @chars) <> '00000'
	and a.[Steel Kit WO#] like '%/%'
	and left(Job, 1) = '2'
	AND [PDS Subs Master].[Active] = 1
	AND [PDS Subs Master].[ID] = @dayOffset

	select @chars = charindex('/', [Beam WO#]) - 1 from #ProdSched
	where [Beam WO#] like '%/%'

	update #ProdSched
	--set JobStartDate = RIGHT('00' + cast(day(DATEADD(DAY, [DayOffset], b.JobStartDate)) as varchar), 2) + '-' + left(datename(mm, DATEADD(DAY, [DayOffset], b.JobStartDate)), 3)
	set JobStartDate = RIGHT('00' + cast(day([Stargatedb].[dbo].[NEXT_BUSINESS_DAY](b.JobStartDate, [DayOffset])) as varchar), 2) + '-' + left(datename(mm, [Stargatedb].[dbo].[NEXT_BUSINESS_DAY](b.JobStartDate, [DayOffset])), 3)
	from #ProdSched as a
	inner join SysproCompanyS.dbo.WipMaster as b with (nolock) on left(a.[Beam WO#], @chars) collate Latin1_General_BIN = right(b.Job, @chars)
	CROSS JOIN [PDS Subs Master]
	where left(a.[Beam WO#], @chars) <> '00000'
	and [Beam WO#] like '%/%'
	and left(Job, 1) = '2'
	AND [PDS Subs Master].[Active] = 1 
	AND [PDS Subs Master].[ID] = @dayOffset;

	update #ProdSched
	--set JobStartDate = case when DATEADD(DAY, [DayOffset], a.JobStartDate) is null then RIGHT('00' + cast(day(DATEADD(DAY, [DayOffset], b.JobStartDate)) as varchar), 2) + '-' + left(datename(mm, DATEADD(DAY, [DayOffset], b.JobStartDate)), 3)
	--						else DATEADD(DAY, [DayOffset], a.JobStartDate) + '/' + RIGHT('00' + cast(day(DATEADD(DAY, [DayOffset], b.JobStartDate)) as varchar), 2) + '-' + left(datename(mm, DATEADD(DAY, [DayOffset], b.JobStartDate)), 3) end
	set JobStartDate = case when [Stargatedb].[dbo].[NEXT_BUSINESS_DAY](a.JobStartDate, [DayOffset]) is null then RIGHT('00' + cast(day([Stargatedb].[dbo].[NEXT_BUSINESS_DAY](b.JobStartDate, [DayOffset])) as varchar), 2) + '-' + left(datename(mm, [Stargatedb].[dbo].[NEXT_BUSINESS_DAY](b.JobStartDate, [DayOffset])), 3)
							else [Stargatedb].[dbo].[NEXT_BUSINESS_DAY](a.JobStartDate, [DayOffset]) + '/' + RIGHT('00' + cast(day([Stargatedb].[dbo].[NEXT_BUSINESS_DAY](b.JobStartDate, [DayOffset])) as varchar), 2) + '-' + left(datename(mm, [Stargatedb].[dbo].[NEXT_BUSINESS_DAY](b.JobStartDate, [DayOffset])), 3) end
	from #ProdSched as a
	inner join SysproCompanyS.dbo.WipMaster as b with (nolock) on right(a.[Beam WO#], @chars) collate Latin1_General_BIN = right(b.Job, @chars)
	CROSS JOIN [PDS Subs Master]
	where right(a.[Beam WO#], @chars) <> '00000'
	and [Beam WO#] like '%/%'
	and left(Job, 1) = '2'
	AND [PDS Subs Master].[Active] = 1 
	AND [PDS Subs Master].[ID] = @dayOffset;

	select @chars = charindex('/', [GN WO#]) - 1 from #ProdSched
	where [GN WO#] like '%/%'

	update #ProdSched
	--set JobStartDate = RIGHT('00' + cast(day(DATEADD(DAY, [DayOffset], b.JobStartDate)) as varchar), 2) + '-' + left(datename(mm, DATEADD(DAY, [DayOffset], b.JobStartDate)), 3)
	set JobStartDate = RIGHT('00' + cast(day([Stargatedb].[dbo].[NEXT_BUSINESS_DAY](b.JobStartDate, [DayOffset])) as varchar), 2) + '-' + left(datename(mm, [Stargatedb].[dbo].[NEXT_BUSINESS_DAY](b.JobStartDate, [DayOffset])), 3)
	from #ProdSched as a
	inner join SysproCompanyS.dbo.WipMaster as b with (nolock) on left(a.[GN WO#], @chars) collate Latin1_General_BIN = right(b.Job, @chars)
	CROSS JOIN [PDS Subs Master]
	where left(a.[GN WO#], @chars) <> '00000'
	and [GN WO#] like '%/%'
	and left(Job, 1) = '2'
	AND [PDS Subs Master].[Active] = 1 
	AND [PDS Subs Master].[ID] = @dayOffset;

	update #ProdSched
	--set JobStartDate = case when DATEADD(DAY, [DayOffset], a.JobStartDate) is null then RIGHT('00' + cast(day(DATEADD(DAY, [DayOffset], b.JobStartDate)) as varchar), 2) + '-' + left(datename(mm, DATEADD(DAY, [DayOffset], b.JobStartDate)), 3)
	--						else DATEADD(DAY, [DayOffset], a.JobStartDate) + '/' + RIGHT('00' + cast(day(DATEADD(DAY, [DayOffset], b.JobStartDate)) as varchar), 2) + '-' + left(datename(mm, DATEADD(DAY, [DayOffset], b.JobStartDate)), 3) end
	set JobStartDate = case when [Stargatedb].[dbo].[NEXT_BUSINESS_DAY](a.JobStartDate, [DayOffset]) is null then RIGHT('00' + cast(day([Stargatedb].[dbo].[NEXT_BUSINESS_DAY](b.JobStartDate, [DayOffset])) as varchar), 2) + '-' + left(datename(mm, [Stargatedb].[dbo].[NEXT_BUSINESS_DAY](b.JobStartDate, [DayOffset])), 3)
							else [Stargatedb].[dbo].[NEXT_BUSINESS_DAY](a.JobStartDate, [DayOffset]) + '/' + RIGHT('00' + cast(day([Stargatedb].[dbo].[NEXT_BUSINESS_DAY](b.JobStartDate, [DayOffset])) as varchar), 2) + '-' + left(datename(mm, [Stargatedb].[dbo].[NEXT_BUSINESS_DAY](b.JobStartDate, [DayOffset])), 3) end
	from #ProdSched as a
	inner join SysproCompanyS.dbo.WipMaster as b with (nolock) on right(a.[GN WO#], @chars) collate Latin1_General_BIN = right(b.Job, @chars)
	CROSS JOIN [PDS Subs Master]
	where right(a.[GN WO#], @chars) <> '00000'
	and [GN WO#] like '%/%'
	and left(Job, 1) = '2'
	AND [PDS Subs Master].[Active] = 1 
	AND [PDS Subs Master].[ID] = @dayOffset;

	select @chars = charindex('/', [Other WO#]) - 1 from #ProdSched
	where [Other WO#] like '%/%'

	update #ProdSched
	--set JobStartDate = RIGHT('00' + cast(day(DATEADD(DAY, [DayOffset], b.JobStartDate)) as varchar), 2) + '-' + left(datename(mm, DATEADD(DAY, [DayOffset], b.JobStartDate)), 3)
	set JobStartDate = RIGHT('00' + cast(day([Stargatedb].[dbo].[NEXT_BUSINESS_DAY](b.JobStartDate, [DayOffset])) as varchar), 2) + '-' + left(datename(mm, [Stargatedb].[dbo].[NEXT_BUSINESS_DAY](b.JobStartDate, [DayOffset])), 3)
	from #ProdSched as a
	inner join SysproCompanyS.dbo.WipMaster as b with (nolock) on left(a.[Other WO#], @chars) collate Latin1_General_BIN = right(b.Job, @chars)
	CROSS JOIN [PDS Subs Master]
	where left(a.[Other WO#], @chars) <> '00000'
	and [Other WO#] like '%/%'
	and left(Job, 1) = '2'
	AND [PDS Subs Master].[Active] = 1 
	AND [PDS Subs Master].[ID] = @dayOffset;

	update #ProdSched
	--set JobStartDate = case when DATEADD(DAY, [DayOffset], a.JobStartDate) is null then RIGHT('00' + cast(day(DATEADD(DAY, [DayOffset], b.JobStartDate)) as varchar), 2) + '-' + left(datename(mm, DATEADD(DAY, [DayOffset], b.JobStartDate)), 3)
	--						else DATEADD(DAY, [DayOffset], a.JobStartDate) + '/' + RIGHT('00' + cast(day(DATEADD(DAY, [DayOffset], b.JobStartDate)) as varchar), 2) + '-' + left(datename(mm, DATEADD(DAY, [DayOffset], b.JobStartDate)), 3) end
	set JobStartDate = case when [Stargatedb].[dbo].[NEXT_BUSINESS_DAY](a.JobStartDate, [DayOffset]) is null then RIGHT('00' + cast(day([Stargatedb].[dbo].[NEXT_BUSINESS_DAY](b.JobStartDate, [DayOffset])) as varchar), 2) + '-' + left(datename(mm, [Stargatedb].[dbo].[NEXT_BUSINESS_DAY](b.JobStartDate, [DayOffset])), 3)
							else [Stargatedb].[dbo].[NEXT_BUSINESS_DAY](a.JobStartDate, [DayOffset]) + '/' + RIGHT('00' + cast(day([Stargatedb].[dbo].[NEXT_BUSINESS_DAY](b.JobStartDate, [DayOffset])) as varchar), 2) + '-' + left(datename(mm, [Stargatedb].[dbo].[NEXT_BUSINESS_DAY](b.JobStartDate, [DayOffset])), 3) end
	from #ProdSched as a
	inner join SysproCompanyS.dbo.WipMaster as b with (nolock) on right(a.[Other WO#], @chars) collate Latin1_General_BIN = right(b.Job, @chars)
	CROSS JOIN [PDS Subs Master]
	where right(a.[Other WO#], @chars) <> '00000'
	and [Other WO#] like '%/%'
	and left(Job, 1) = '2'
	AND [PDS Subs Master].[Active] = 1 
	AND [PDS Subs Master].[ID] = @dayOffset;

	--Update null Steel Kit/Beam/GNK/Other WO and associated JobStartDate fields with Dock To Stock Dates
	with cte
	as
	(
		select CalendarDate, ROW_NUMBER() over (order by CalendarDate desc) as RN, WorkDay
		from SysproCompanyS.dbo.v_CalendarWorkDays
		where WorkDay = 1
	)
	
	update #ProdSched
	set JobStartDate = RIGHT('00' + cast(day(DTSDate) as varchar), 2) + '-' + left(datename(mm, DTSDate), 3)
	from #ProdSched as a
	--inner join (select T1.Job, DATEADD(DAY, [DayOffset], T1.PlannedStartDate) AS [PlannedStartDate], 14 as NoDays, DATEADD(DAY, [DayOffset], T2.CalendarDate) as DTSDate
	inner join (select T1.Job, [Stargatedb].[dbo].[NEXT_BUSINESS_DAY](T1.PlannedStartDate, [DayOffset]) AS [PlannedStartDate], 14 as NoDays, [Stargatedb].[dbo].[NEXT_BUSINESS_DAY](T2.CalendarDate, [DayOffset]) as DTSDate
				from cte
				CROSS JOIN [PDS Subs Master]
				--join SysproCompanyS.dbo.WipJobAllLab as T1 with (nolock) on cte.CalendarDate = DATEADD(DAY, [DayOffset], T1.PlannedStartDate)
				join SysproCompanyS.dbo.WipJobAllLab as T1 with (nolock) on cte.CalendarDate = [Stargatedb].[dbo].[NEXT_BUSINESS_DAY](T1.PlannedStartDate, [DayOffset])
				join cte as T2 on T2.RN - cte.RN = 14
				where Operation = 4 AND [PDS Subs Master].[Active] = 1 AND [PDS Subs Master].[ID] = @dayOffset) as b on cast(a.WO# as varchar(20)) COLLATE DATABASE_DEFAULT = b.Job COLLATE DATABASE_DEFAULT
	where JobStartDate is null;

	--Add SGQuote to null WO fields
	update #ProdSched
	set WO# = SGQuote
	where WO# is null

	--Updated Reviewed field based on "WO Reviewed" field in Orders table
	update #ProdSched
	set Reviewed = case when [WO Reviewed] is null then 0 else [WO Reviewed] end
	from #ProdSched
	left outer join BWSdb.dbo.OrdersV2 with (nolock) on #ProdSched.SGQuote = OrdersV2.SGQuote

	--Update NoNPOs field with count of NPOs on each unit (Custom Work table)
	update #ProdSched
	set NoNPOs = case when subA.NoNPOs is null then 0 else subA.NoNPOs end
	from #ProdSched
	left outer join (select SGQuote, count(*) as NoNPOs 
					 from BWSdb.dbo.[Custom WorkV2] with (nolock)
					 where Description not like '%none%'
					 and Description not like '%All WO before July 1, 2011 Please use in conjunction with Excel WO.%'
					 and Description not like '%See NPOs for New Quote%'
					 group by SGQuote) as subA on #ProdSched.SGQuote = subA.SGQuote

	--Update Stock/Sold column based on Customer information
	update #ProdSched
	set [Stock/Sold] = case when Customer is not null and Customer <> 'stock' then 'SOLD' else 'STOCK' end
	from #ProdSched
	left outer join BWSdb.dbo.CustomersV2 with (nolock) on #ProdSched.SGQuote = CustomersV2.SGQuote
	
	--Set the default for Slots as STOCK, until specified
	update #ProdSched
	set [Stock/Sold] = 'STOCK'
	where Slot# is not null

	update #ProdSched
	set [Stock/Sold] = null
	where SGQuote is null
	and Slot# is null

	--Update HighRiskUnit column based on column in Orders table
	update #ProdSched
	set HighRiskUnit = OrdersV2.HighRiskUnit
	from #ProdSched
	inner join BWSdb.dbo.OrdersV2 with (nolock) on #ProdSched.SGQuote = OrdersV2.SGQuote

	--Remove unnecessary lines
	delete from #ProdSched
	where GroupID is null
	
	--UPDATE
	--	#ProdSched
	--SET
	--	[Prod Date] = DATEADD(DAY, [DayOffset], [Prod Date])
	--FROM
	--	#ProdSched
	--CROSS JOIN
	--	[PDS Subs Master]
	--WHERE
	--	[PDS Subs Master].[ID] = @dayOffset
		

	--Final select statement
	select * from #ProdSched
	
	--GROUP BY [GroupID]
	ORDER BY [GroupID], [Prod Date]

	--select * from #ProdSched ORDER BY [Prod Date], [GroupID]

END
