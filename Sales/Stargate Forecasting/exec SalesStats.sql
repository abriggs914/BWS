DECLARE @d2 DATETIME = GETDATE();
EXEC [sp_SaleStatsV2] '2023-01-01', @d2

SELECT
	DISTINCT [COMPANY NAME]
	,[Initials]
FROM
	[DealersV2]

SELECT 'OrdersV2' AS [T], * FROM [OrdersV2]
SELECT 'v_Quote Raw Pricing V2' AS [T], * FROM [BWSdb].[dbo].[v_Quote Raw Pricing V2]
SELECT 'DealersV2' AS [T], * FROM [BWSdb].[dbo].[DealersV2]
SELECT 'ProductsV2' AS [T], * FROM [BWSdb].[dbo].[ProductsV2]
SELECT 'v_CompletedJobInfo' AS [T], * FROM [SysproCompanyS].[dbo].[v_CompletedJobInfo]
SELECT 'v_Order Book Detail v2_All' AS [T], * FROM [Stargatedb].[dbo].[v_Order Book Detail v2_All]
SELECT 'TblCurrency' AS [T], * FROM [SysproCompanyS].[dbo].[TblCurrency]

select distinct (case
		when [DealersV2].Initials = 'BWS' then 4
		when [DealersV2].[COMPANY NAME] = 'BWS - CDN Direct Sales' then 3
		when [OrdersV2].[US Sale] = 0 then 2
		when [DealersV2].[COMPANY NAME] = 'BWS - US Direct Sales' then 1
		when [OrdersV2].[US Sale] = 1 then 0 end
	) as CountrySort,
	(case
		when [DealersV2].Initials = 'BWS' then 2
		when [DealersV2].[COMPANY NAME] = 'BWS - CDN Direct Sales' or [OrdersV2].[US Sale] = 0 then 1
		when [DealersV2].[COMPANY NAME] = 'BWS - US Direct Sales' or [OrdersV2].[US Sale] = 1 then 0 
	end) as CountryGroup, 
	(case 
		when [DealersV2].Initials = 'BWS' then 'Stock' 
		when [DealersV2].[COMPANY NAME] = 'BWS - CDN Direct Sales' then 'BWS CDN'
		when [OrdersV2].[US Sale] = 0 then 'CDN'
		when [DealersV2].[COMPANY NAME] = 'BWS - US Direct Sales' then 'BWS US' 
		when [OrdersV2].[US Sale] = 1 then 'US'
	end) as Country, 
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

DECLARE 
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