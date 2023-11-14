USE [Stargatedb]
GO

/****** Object:  View [dbo].[v_BWSQuotesorWOsNotComplete]    Script Date: 2023-11-07 3:45:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--2022-09-28 James Crawford - Added where clause to exclude 3 Half Round Work Orders from reports: 10015030 - 10015032
--IT Request #001197

CREATE view [dbo].[v_BWSQuotesorWOsNotComplete] as
select [OrdersV2].[SGQuote], [OrdersV2].[WO#], [OrdersV2].[Model No], [OrdersV2].[PO Date], [COMPANY NAME] as Dealer,
case when [Prod Date 2] < [Prod Date 1] then [Prod Date 2] else [Prod Date 1] end as [Production Date]
from [BWSdb].[dbo].[OrdersV2] with (nolock)
left outer join SysproCompanyS.dbo.WipMaster with (nolock) on cast([OrdersV2].WO# as varchar(20)) = WipMaster.Job
left outer join [Stargatedb].[dbo].[dtProductionSchedule] with (nolock) on [OrdersV2].[SGQuote] = dtProductionSchedule.[SGQuote]
left outer join [BWSdb].[dbo].[DealersV2] with (nolock) on [OrdersV2].DealerID = [DealersV2].ID
where [PO Date] is not null
and (
        (
            left([OrdersV2].[WO#], 1) = '1' and [OrdersV2].[WO#] not in (10015030, 10015031, 10015032)
        ) 
        or [OrdersV2].[WO#] is null
    )
and WipMaster.ActCompleteDate is null
and [Date Declined] is NULL --Make sure you also exclude pre-Syspro units with shipped and invoice dates
and [Shipped Date] is NULL
and [Invoice Date] is null
GO


