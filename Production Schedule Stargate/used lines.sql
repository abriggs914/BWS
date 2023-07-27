USE BWSdb
GO

SELECT DISTINCT
	[Prod Line]
	, MIN([Order]) AS [OrderB]
FROM (
	SELECT
		'TL' AS [Prod Line]
		, 1 AS [Order]
	UNION ALL
	SELECT 
		'LBL', 2
	UNION ALL
	SELECT 
		'WFL', 3
	UNION ALL
	SELECT 
		'TBL', 4
	UNION ALL
	SELECT 
		'PL', 5
	UNION ALL
	SELECT DISTINCT [Prod Line], [ProductionV2].[Prod#] + 1000 FROM [ProductionV2]
	UNION ALL
	SELECT DISTINCT [Prod Line2], [ProductionV2].[Prod#] + 2000 FROM [ProductionV2]
	UNION ALL	
	SELECT DISTINCT [JobStartLine], [dtProductionScheduleV2].[ProdSchedV2ID#] + 3000 FROM [Stargatedb].[dbo].[dtProductionScheduleV2]

) AS [SubA]
WHERE
	[Prod Line] IS NOT NULL
GROUP BY
	[Prod Line]
ORDER BY
	[OrderB],
	[Prod Line]
;


USE Stargatedb
GO


SELECT
	[JobStartLine],
	COUNT(*) AS [C]
FROM
	[dtProductionScheduleV2]
GROUP BY
	[JobStartLine]
ORDER BY
	[JobStartLine]



SELECT
            B.*
            , A.*
            , O.*
        FROM
            BWSdb.dbo.OrdersV2 AS O
        LEFT JOIN 
            dtProductionSchedule AS A
        ON
            A.SGQuote = O.SGQuote
        LEFT JOIN 
            dtProductionScheduleV2 AS B
        ON
            B.SGQuote = O.SGQuote
        WHERE
            B.JobFinishDate IS NOT NULL
        ORDER BY
            B.JobFinishDate
        ;    


--SELECT
--	[Prod Line]
--FROM (
SELECT
	[LO]
	--, ROW_NUMBER() OVER(
	--	PARTITION BY [Prod Line]
	--	ORDER BY [LO]
	--)
	--AS [Rn]
	, 1 AS [T]
	, [Prod Line]
FROM
	[Prod Lines]
WHERE
	[Active] = 1
GROUP BY
	[LO]
	, [Prod Line]

UNION 

SELECT
	NULL
	, 2
	, [WO Line 1]
FROM
	[dtProductionSchedule]
WHERE
	[WO Line 1] IS NOT NULL
GROUP BY
	[WO Line 1]

UNION 

SELECT
	NULL
	, 3
	, [WO Line 2]
FROM
	[dtProductionSchedule]
WHERE
	[WO Line 2] IS NOT NULL
GROUP BY
	[WO Line 2]

ORDER BY
	[T]
	, [LO]
--) AS [A]



SELECT
            --B.[ProdSchedV2ID#]
            --,B.[SGQuote] AS [dtProductionScheduleV2_SGQuote]
            --,B.[WO#] AS [dtProductionScheduleV2_WO#]
            --,B.[JobStartDate]
            --,B.[JobFinishDate]
            --,B.[dtprodschedv2ts]
            --,
			B.[JobStartLine]
   --         ,B.[HideFromProdInput]
   --         ,B.[InputField1]
   --         ,B.[InputField2]
   --         ,B.[ApplyUpdate]
   --         ,B.[ApplyUpdateUser]

   --         , A.[ProdSchedID#]
   --         ,A.[SGQuote] AS [dtProductionSchedule_SGQuote]
   --         ,A.[WO#] AS [dtProductionSchedule_WO#]
   --         ,A.[InputField1] AS [A_InputField1]
   --         ,A.[InputField2] AS [A_InputField2]
   --         ,A.[Beam Line]
   --         ,A.[Beam Date]
   --         ,A.[GN Line]
   --         ,A.[GN Date]
   --         ,A.[WO Line 1]
   --         ,A.[Prod Date 1]
   --         ,A.[WO Line 2]
   --         ,A.[Prod Date 2]
   --         ,A.[Other]
   --         ,A.[Other Line]
   --         ,A.[Other Date]
   --         ,A.[HideFromProdInput] AS [A_HideFromProdInput]
   --         ,A.[Step1SYSPROBudget]
   --         ,A.[Step2SYSPROBudget]
   --         ,A.[dtprodschedts]
   --         ,A.[ApplyUpdate] AS [A_ApplyUpdate]
   --         ,A.[ApplyUpdateUser] AS [A_ApplyUpdateUser]
   --         ,A.[Slot#]
   --         ,A.[Slot/Quote]
   --         ,A.[Slot Approved]
   --         ,A.[Prod On]
   --         ,A.[Prod On Time]
   --         ,A.[Prod Off]
   --         ,A.[Prod Off Time]
   --         ,A.[Prod PM]
   --         ,A.[Prod Complete]
   --         ,A.[Prod2 On]
   --         ,A.[Prod2 On Time]
   --         ,A.[Prod2 Off]
   --         ,A.[Prod2 Off Time]
   --         ,A.[Prod2 PM]
   --         ,A.[Prod2 Complete]
   --         ,A.[Prod Instructions]
   --         ,A.[Beam On]
   --         ,A.[Beam Off]
   --         ,A.[Beam Complete]
   --         ,A.[Beam PM]
   --         ,A.[Beam Instructions]
   --         ,A.[GN On]
   --         ,A.[GN Off]
   --         ,A.[GN Complete]
   --         ,A.[GN PM]
   --         ,A.[GN Instructions]
   --         ,A.[Axle]
   --         ,A.[Axle On]
   --         ,A.[Axle Off]
   --         ,A.[Axle Complete]
   --         ,A.[Axle PM]
   --         ,A.[Axle Instructions]
   --         ,A.[Other On]
   --         ,A.[Other On Time]
   --         ,A.[Other Off]
   --         ,A.[Other Off Time]
   --         ,A.[Other Complete]
   --         ,A.[Other PM]
   --         ,A.[Other Instructions]
   --         ,A.[Stargate WO#]

   --         , O. [OrderID]
   --         ,O.[SGQuote] AS [OrdersV2_SGQuote]
   --         ,O.[Quote Date]
   --         ,O.[Order Date]
   --         ,O.[WO#] AS [OrdersV2_WO#]
   --         ,O.[Sales Order#]
   --         ,O.[Model No]
   --         ,O.[Width]
   --         ,O.[Spread]
   --         ,O.[DealerID]
   --         ,O.[Sale PersonID]
   --         ,O.[Price]
   --         ,O.[Prom Drawing]
   --         ,O.[Special Instructions]
   --         ,O.[Date Declined]
   --         ,O.[Decline/Rejected]
   --         ,O.[Serial Number]
   --         ,O.[Available Date]
   --         ,O.[Delivery Date]
   --         ,O.[Requested Delivery Date]
   --         ,O.[Finish Date]
   --         ,O.[Purchase Order]
   --         ,O.[PO Date]
   --         ,O.[PayID]
   --         ,O.[Volume Discount]
   --         ,O.[Program Discount]
   --         ,O.[Discount1_Name]
   --         ,O.[Discount1_Type]
   --         ,O.[Discount1]
   --         ,O.[Discount2_Name]
   --         ,O.[Discount2_Type]
   --         ,O.[Discount2]
   --         ,O.[Discount3_Name]
   --         ,O.[Discount3_Type]
   --         ,O.[Discount3]
   --         ,O.[Est Pro Date]
   --         ,O.[Notes]
   --         ,O.[EngNotes]
   --         ,O.[CarrierID]
   --         ,O.[CustID]
   --         ,O.[US Sale]
   --         ,O.[Shipped Date]
   --         ,O.[GL Override Date]
   --         ,O.[FE Rate]
   --         ,O.[PDD]
   --         ,O.[Deck Length]
   --         ,O.[Invoice #]
   --         ,O.[Date Registered]
   --         ,O.[Date In Service]
   --         ,O.[Invoice Date]
   --         ,O.[Date Requested]
   --         ,O.[GVWR]
   --         ,O.[Tare]
   --         ,O.[Selection]
   --         ,O.[Warranty]
   --         ,O.[BWSPaid]
   --         ,O.[BWSPaidDate]
   --         ,O.[CommPaid]
   --         ,O.[CommPaidDate]
   --         ,O.[ts_timestamp]
   --         ,O.[ModifiedBy]
   --         ,O.[Lead Date]
   --         ,O.[Lead Source]
   --         ,O.[LeadID]
   --         ,O.[DealerBranchID]
   --         ,O.[DealerSalesPersonID]
   --         ,O.[DataEntryCheck]
   --         ,O.[DataEntryUser]
   --         ,O.[FinishedGoodsDealerLocID]
   --         ,O.[WO Reviewed]
   --         ,O.[WO Review Date]
   --         ,O.[Follow Up Date]
   --         ,O.[MSOIsDifferent]
   --         ,O.[MSOLocID]
   --         ,O.[EstInvDateOverride]
   --         ,O.[Estimated Invoice Date]
   --         ,O.[AdditionalPricingInfo]
   --         ,O.[Slot#] AS [O_Slot#]
   --         ,O.[TempModel?]
   --         ,O.[HighRiskUnit]
   --         ,O.[EngNotes V2]
   --         ,O.[CompanyID]
   --         ,O.[Customer WO#]
   --         ,O.[PriceSecured]
   --         ,O.[DateSecured]
   --         ,O.[SecuredBy]
			--,(CASE WHEN C.[SGQuote] IS NULL THEN 'N' ELSE 'Y' END) AS [IsGalv]
			--,[COMPANY NAME]
        FROM
            BWSdb.dbo.OrdersV2 AS O
        LEFT JOIN 
            dtProductionSchedule AS A
        ON
            A.SGQuote = O.SGQuote
        LEFT JOIN 
            dtProductionScheduleV2 AS B
        ON
            B.SGQuote = O.SGQuote
        LEFT JOIN
            [BWSdb].[dbo].[v_GalvanizedStargateOrders] AS C
        ON
            C.SGQuote = O.SGQuote
        LEFT JOIN
            [BWSdb].[dbo].[DealersV2] AS D
        ON
            O.[DealerID] = D.[ID] 

		GROUP BY
			[B].[JobStartLine]

        ORDER BY
            [B].[JobStartLine]
        ;            