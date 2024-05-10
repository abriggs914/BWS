USE Stargatedb
GO

select Job
    , JobDescription
    , StockCode
    , StockDescription
FROM
    SysproCompanyS.dbo.WipMaster with (nolock)
WHERE
    (
        LOWER(JobDescription) like '%9782%'
        or LOWER(StockCode) like '%9782%'
        or LOWER(StockDescription) like '%9782%'
    )
    and LEFT(Job, 1) = '1'
;

SELECT
	[WAR].[ID] AS [WAR_ID]
	,[OrdersV2_SGQuote]
	,[Src].[Serial Number] AS [OrdersV2_SerialNumber]
	,[WAR].[WO#] AS [WAR_WO]
	,[WAR].[Model No] AS [WAR_ModelNo]
	,[WAR].[Dealer] AS [WAR_Dealer]
	,[WAR].[Dealer V2] AS [WAR_DealerV2]
	,[WAR].[Serial Number] AS [WAR_SerialNumber]
	,[WAR].[S/N] AS [WAR_SN]
	,[WAR].[S/N V2] AS [WAR_SNV2]
	,[WAR].[Claim Number] AS [WAR_ClaimNumber]
	,[WAR].[Claim Date] AS [WAR_ClaimDateOpen]
	,[WAR].[Date Closed] AS [WAR_ClaimDateClose]
	,[WAR].[Issue Number] AS [WAR_IssueNumber]
	,[WAR].[Failure] AS [WAR_Failure]
	,[WAR].[BWS Invoice #] AS [WAR_InvoiceNumber]
	,[WAR].[Auth By] AS [WAR_AuthBy]
	,[WAR].[Reason Denied/Goodwill] AS [WAR_Reason]
	,[WAR].[Location] AS [WAR_Location]
	,[WAR].[Customer] AS [WAR_Customer]
	,[WAR].[Customer V2] AS [WAR_CustomerV2]
	,[WAR].[Parts/Labour] AS [WAR_PartsLabour]
FROM 
	[Stargatedb].[dbo].[Warranty Claims] AS [WAR]
LEFT JOIN (
	SELECT
		B.[ProdSchedV2ID#]
		,[O].[SGQuote] AS [OrdersV2_SGQuote]
		,B.[WO#] AS [OrdersV2_WO#]
		,B.[JobStartDate]
		,B.[JobFinishDate]
		,B.[JobStartLine]
		,B.[InputField1]
		,B.[InputField2]
      
		,A.[ProdSchedID#]
		,A.[SGQuote] AS [dtProductionSchedule_SGQuote]
		,A.[WO#] AS [dt_ProductionSchedule_WO#]
		,A.[Prod Date 1]
		,A.[WO Line 2]
		,A.[Prod Date 2]
		,A.[Slot#]
		,A.[Slot/Quote]
		,A.[Stargate WO#]
          
		,O.[OrderID]
		,O.[SGQuote] AS [dtProductionScheduleV2_SGQuote]
		,O.[Quote Date]
		,O.[Order Date]
		,O.[WO#] AS [dt_ProductionScheduleV2_WO#]
		,O.[Sales Order#]
		,O.[Model No]
		,O.[Width]
		,O.[Spread]
		,O.[DealerID]
		,O.[Sale PersonID]
		,O.[Price]
		,O.[Prom Drawing]
		,O.[Date Declined]
		,O.[Decline/Rejected]
		,O.[Serial Number]
		,O.[Available Date]
		,O.[Delivery Date]
		,O.[Requested Delivery Date]
		,O.[Finish Date]
		,O.[Purchase Order]
		,O.[PO Date]
		,O.[US Sale]
		,O.[Shipped Date]
		,O.[Deck Length]
		,O.[Invoice #]
		,O.[Date Registered]
		,O.[Date In Service]
		,O.[Invoice Date]
		,O.[CompanyID]
		,O.[Customer WO#]
		,[O].[JobAvailableLine]
		,[O].[JobAvailableScheduled]
		,[O].[JobAvailableScheduledBy]
		,(CASE WHEN C.[SGQuote] IS NULL THEN 'N' ELSE 'Y' END) AS [IsGalv]
	FROM
		[BWSdb].[dbo].[OrdersV2] AS [O]
	LEFT JOIN 
		[dtProductionSchedule] AS [A]
	ON
		[A].[SGQuote] = [O].[SGQuote]
	LEFT JOIN 
		[dtProductionScheduleV2] AS [B]
	ON
		[B].[SGQuote] = [O].[SGQuote]
	LEFT JOIN
		[BWSdb].[dbo].[v_GalvanizedStargateOrders] AS [C]
	ON
		[C].[SGQuote] = [O].[SGQuote]
	--ORDER BY
	--	[B].[JobFinishDate]
) AS [Src]
ON
	([Src].[OrdersV2_WO#] = CAST([WAR].[WO#] AS NVARCHAR(MAX)))
	--OR ([Src].[Serial Number] = [WAR].[Serial Number])
WHERE
	[Src].[OrdersV2_WO#] IS NULL
--ORDER BY
--    [B].[JobFinishDate]
;