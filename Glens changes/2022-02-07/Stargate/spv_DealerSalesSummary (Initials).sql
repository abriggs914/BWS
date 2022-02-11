USE Stargatedb
GO

ALTER VIEW [dbo].[spv_DealerSalesSummary (Initials)] AS

SELECT        dbo.dtSalesPerformance.[COMPANY NAME], dbo.dtSalesPerformance.[Invoice #], dbo.dtSalesPerformance.WO#, [BWSdb].dbo.OrdersV2.[Date Declined], CASE WHEN [v_Dealer Totals Breakdown].Initials IS NOT NULL 
                         THEN [v_Dealer Totals Breakdown].GROUPING ELSE (CASE WHEN a.GROUPING IS NULL THEN (CASE WHEN ProductsV2.Grouping <> 'Container Chassis' AND b.Initials = 'DCI' THEN 1 ELSE b.GROUPING END) 
                         WHEN ProductsV2.Grouping <> 'Container Chassis' AND a.Initials = 'DCI' THEN 1 ELSE a.GROUPING END) END AS GROUPING, CASE WHEN [v_Dealer Totals Breakdown].Initials IS NOT NULL 
                         THEN [v_Dealer Totals Breakdown].Initials ELSE (CASE WHEN a.Initials IS NULL THEN (CASE WHEN ProductsV2.Grouping <> 'Container Chassis' AND b.Initials = 'DCI' THEN 'DCI-R' ELSE b.Initials END) 
                         WHEN ProductsV2.Grouping <> 'Container Chassis' AND a.Initials = 'DCI' THEN 'DCI-R' ELSE a.Initials END) END AS Initials, CASE WHEN [v_Dealer Totals Breakdown].Initials IS NOT NULL 
                         THEN [v_Dealer Totals Breakdown].Label ELSE (CASE WHEN a.Label IS NULL THEN (CASE WHEN ProductsV2.Grouping <> 'Container Chassis' AND b.Initials = 'DCI' THEN 'American Dealers' ELSE b.Label END) 
                         WHEN ProductsV2.Grouping <> 'Container Chassis' AND a.Initials = 'DCI' THEN 'American Dealers' ELSE a.Label END) END AS Label, CASE WHEN [v_Dealer Totals Breakdown].Initials IS NOT NULL 
                         THEN [v_Dealer Totals Breakdown].LabelTtl ELSE (CASE WHEN a.LabelTtl IS NULL THEN (CASE WHEN ProductsV2.Grouping <> 'Container Chassis' AND b.Initials = 'DCI' THEN 'Ttl US' ELSE b.LabelTtl END) 
                         WHEN ProductsV2.Grouping <> 'Container Chassis' AND a.Initials = 'DCI' THEN 'Ttl US' ELSE a.LabelTtl END) END AS LabelTtl, CASE WHEN [v_Dealer Totals Breakdown].Initials IS NOT NULL 
                         THEN [v_Dealer Totals Breakdown].Section ELSE (CASE WHEN a.Section IS NULL THEN (CASE WHEN ProductsV2.Grouping <> 'Container Chassis' AND b.Initials = 'DCI' THEN 'American' ELSE b.Section END) 
                         WHEN ProductsV2.Grouping <> 'Container Chassis' AND a.Initials = 'DCI' THEN 'American' ELSE a.Section END) END AS Section, CASE WHEN [v_Dealer Totals Breakdown].Initials IS NOT NULL 
                         THEN [v_Dealer Totals Breakdown].LabelSection ELSE (CASE WHEN a.LabelSection IS NULL THEN (CASE WHEN ProductsV2.Grouping <> 'Container Chassis' AND b.Initials = 'DCI' THEN 'Total American' ELSE b.LabelSection END)
                          WHEN ProductsV2.Grouping <> 'Container Chassis' AND a.Initials = 'DCI' THEN 'Total American' ELSE a.LabelSection END) END AS LabelSection, CASE WHEN [v_Dealer Totals Breakdown].Initials IS NOT NULL 
                         THEN [v_Dealer Totals Breakdown].US ELSE (CASE WHEN a.US IS NULL THEN (CASE WHEN ProductsV2.Grouping <> 'Container Chassis' AND b.Initials = 'DCI' THEN 'American' ELSE b.US END) 
                         WHEN ProductsV2.Grouping <> 'Container Chassis' AND a.Initials = 'DCI' THEN 'American' ELSE a.US END) END AS US, CASE WHEN [v_Dealer Totals Breakdown].Initials IS NOT NULL 
                         THEN [v_Dealer Totals Breakdown].LabelUS ELSE (CASE WHEN a.LabelUS IS NULL THEN (CASE WHEN ProductsV2.Grouping <> 'Container Chassis' AND b.Initials = 'DCI' THEN 'Total US' ELSE b.LabelUS END) 
                         WHEN ProductsV2.Grouping <> 'Container Chassis' AND a.Initials = 'DCI' THEN 'Total US' ELSE a.LabelUS END) END AS LabelUS
FROM            dbo.dtSalesPerformance WITH (nolock) INNER JOIN
                         [BWSdb].dbo.OrdersV2 WITH (nolock) ON dbo.dtSalesPerformance.WO# = [BWSdb].dbo.OrdersV2.WO# INNER JOIN
                         [BWSdb].dbo.ProductsV2 WITH (nolock) ON [BWSdb].dbo.OrdersV2.[Model No] = [BWSdb].dbo.ProductsV2.[Model No] LEFT OUTER JOIN
                         dbo.[v_Dealer Totals Breakdown By Quote] AS a ON (CASE WHEN dtSalesPerformance.[COMPANY NAME] LIKE '%Ltd%' THEN LEFT(dbo.fnFirsties(dtSalesPerformance.[COMPANY NAME]), 2) 
                         ELSE LEFT(dbo.fnFirsties(dtSalesPerformance.[COMPANY NAME]), 3) END) = LEFT(a.Initials, 3) AND [BWSdb].dbo.OrdersV2.SGQuote = a.SGQuote LEFT OUTER JOIN
                         [BWSdb].dbo.DealersV2 WITH (nolock) ON [BWSdb].dbo.OrdersV2.DealerID = [BWSdb].dbo.DealersV2.ID LEFT OUTER JOIN
                         dbo.[v_Dealer Totals Breakdown By Quote] AS b ON [BWSdb].dbo.OrdersV2.SGQuote = b.SGQuote LEFT OUTER JOIN
                         SysproCompanyS.dbo.SorMaster WITH (nolock) ON dbo.dtSalesPerformance.SalesOrder COLLATE Latin1_General_BIN = SysproCompanyS.dbo.SorMaster.SalesOrder LEFT OUTER JOIN
                         [BWSdb].dbo.dtSYSPROCustomerInitals WITH (nolock) ON SysproCompanyS.dbo.SorMaster.Customer = dtSYSPROCustomerInitals.SYSPROCustomer COLLATE Latin1_General_BIN LEFT OUTER JOIN
                         dbo.[v_Dealer Totals Breakdown] ON dtSYSPROCustomerInitals.Initials = dbo.[v_Dealer Totals Breakdown].Initials
GROUP BY dbo.dtSalesPerformance.[COMPANY NAME], dbo.dtSalesPerformance.[Invoice #], dbo.dtSalesPerformance.WO#, [BWSdb].dbo.OrdersV2.[Date Declined], dbo.[v_Dealer Totals Breakdown].Initials, a.Initials, 
                         dbo.[v_Dealer Totals Breakdown].GROUPING, [BWSdb].dbo.ProductsV2.Grouping, dbo.[v_Dealer Totals Breakdown].Label, a.Label, dbo.[v_Dealer Totals Breakdown].LabelTtl, a.LabelTtl, dbo.[v_Dealer Totals Breakdown].Section, a.Section, 
                         dbo.[v_Dealer Totals Breakdown].LabelSection, a.LabelSection, dbo.[v_Dealer Totals Breakdown].LabelUS, a.LabelUS, dbo.[v_Dealer Totals Breakdown].US, a.US, a.GROUPING, b.Initials, b.Label, b.LabelTtl, b.Section, 
                         b.LabelSection, b.LabelUS, b.US, b.GROUPING
;