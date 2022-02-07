
	USE [SysproCompanyA]
GO

DECLARE 
	@sd datetime, @ed datetime, @sd1 datetime, @ed1 datetime;
	
SET @sd = '2022-01-01';
SET @ed = '2022-01-31';
SET @sd1 = '2022-02-01';
SET @ed1 = '2022-02-28';

    -- Insert statements for procedure here
	--Dealer Sales Summary - Prelim

	declare @sd2 datetime, @ed2 datetime

	select @sd2 = DATEADD(YEAR, -1, @sd1)
	select @ed2 = DATEADD(YEAR, -1, @ed1)

	--Drop and create temp table in tmpdb SQL database for faster processing
	IF OBJECT_ID('tempdb..#tmptable') IS NOT NULL
		DROP TABLE #tmptable 

	create table #tmptable
	(
		[Units Sold] float,
		[Selling Price] float,
		[Actual Margin] float,
		[Actual Hours] float,
		[COMPANY NAME] NVARCHAR(MAX),
		Initials nvarchar(MAX), 
		Grouping int, 
		Label nvarchar(MAX), 
		LabelTtl nvarchar(MAX), 
		Section nvarchar(MAX), 
		LabelSection nvarchar(MAX), 
		US nvarchar(MAX), 
		LabelUS nvarchar(MAX),
		[Units Sold Prior] float,
		[Selling Price Prior] float,
		[Actual Margin Prior] float,
		[Actual Hours Prior] float
	)

	--insert current and prior period, non-cancelled, non-excluded and invoiced units into current tv 
	insert into #tmptable
	select sum([Units Sold]) as [Units Sold], 
	sum([Selling Price]) as [Selling Price], 
	sum([Actual Margin]) as [Actual Margin], 
	sum([Actual Hours]) as [Actual Hours],
	[COMPANY NAME],
	Initials, Grouping, Label, LabelTtl, Section, LabelSection, US, LabelUS,
	sum([Units Sold Prior]) as [Units Sold Prior],
	sum([Selling Price Prior]) as [Selling Price Prior],
	sum([Actual Margin Prior]) as [Actual Margin Prior],
	sum([Actual Hours Prior]) as [Actual Hours Prior]
	from (
		select sum(UnitCount) as [Units Sold],
		sum([Net Cost]) as [Selling Price],
		sum(ActMargin) as [Actual Margin],
		sum(TotalActual) as [Actual Hours],
		[BWSdb].[dbo].[dtSalesPerformance].[COMPANY NAME] AS [COMPANY NAME],
		Initials, Grouping, Label, LabelTtl, Section, LabelSection, US, LabelUS,
		0 as [Units Sold Prior],
		0 as [Selling Price Prior],
		0 as [Actual Margin Prior],
		0 as [Actual Hours Prior] 
		from [BWSdb].[dbo].dtSalesPerformance
		inner join [BWSdb].[dbo].[spv_DealerSalesSummary (Initials)] on dtSalesPerformance.WO# = [spv_DealerSalesSummary (Initials)].WO#
		and dtSalesPerformance.[Invoice #] = [spv_DealerSalesSummary (Initials)].[Invoice #]
		where [Date Declined] is null and dtSalesPerformance.WO# not like '3%'
		and dtSalesPerformance.[Invoice Date] between @sd and @ed
		and UnitExcl = 1
		group by [BWSdb].[dbo].[dtSalesPerformance].[COMPANY NAME], Initials, Grouping, Label, LabelTtl, Section, LabelSection, US, LabelUS
		having (case when Initials = 'BWS' and sum(UnitCount)= 0 then 0 else 1 end) = 1

		union all select 0 as [Units Sold],
		0 as [Selling Price],
		0 as [Actual Margin],
		0 as [Actual Hours],
		[BWSdb].[dbo].[dtSalesPerformance].[COMPANY NAME] AS [COMPANY NAME],
		Initials, Grouping, Label, LabelTtl, Section, LabelSection, US, LabelUS,
		sum(UnitCount) as [Units Sold Prior],
		sum([Net Cost]) as [Selling Price Prior],
		sum(ActMargin) as [Actual Margin Prior],
		sum(TotalActual) as [Actual Hours Prior] 
		from [BWSdb].[dbo].dtSalesPerformance
		inner join [BWSdb].[dbo].[spv_DealerSalesSummary (Initials)] on dtSalesPerformance.WO# = [spv_DealerSalesSummary (Initials)].WO#
		and dtSalesPerformance.[Invoice #] = [spv_DealerSalesSummary (Initials)].[Invoice #]
		where [Date Declined] is null and dtSalesPerformance.WO# not like '3%'
		and dtSalesPerformance.[Invoice Date] between @sd1 and @ed1
		and UnitExcl = 1
		group by [BWSdb].[dbo].dtSalesPerformance.[COMPANY NAME], Initials, Grouping, Label, LabelTtl, Section, LabelSection, US, LabelUS
		having (case when Initials = 'BWS' and sum(UnitCount)= 0 then 0 else 1 end) = 1

		union all select 0, 0, 0, 0, NULL AS [COMPANY NAME],
		[v_Dealer Totals Breakdown].Initials, [GROUPING], Label, LabelTtl, Section, LabelSection, US, LabelUS,
		0, 0, 0, 0 from [BWSdb].[dbo].[v_Dealer Totals Breakdown]

		group by [v_Dealer Totals Breakdown].Initials, [GROUPING], Label, LabelTtl, Section, LabelSection, US, LabelUS
	) as subA
	group by [COMPANY NAME], Initials, Grouping, Label, LabelTtl, Section, LabelSection, US, LabelUS
	;


SELECT * FROM [BWSdb].[dbo].dtSalesPerformance
SELECT * FROM [BWSdb].[dbo].[spv_DealerSalesSummary (Initials)]
SELECT * FROM [BWSdb].[dbo].[v_Dealer Totals Breakdown]