USE [BWSdb]
GO

/****** Object:  View [dbo].[v_Quote Raw Pricing]    Script Date: 2023-10-23 4:50:30 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





ALTER VIEW [dbo].[v_Quote Raw Pricing V2]
AS
SELECT     dbo.[OrdersV2].[SGQuote], dbo.[ProductsV2].[Model No], dbo.[OrdersV2].Width, dbo.[OrdersV2].Spread, CONVERT(int, dbo.[OrdersV2].Price) AS Price, CONVERT(int, 
                      dbo.[OrdersV2].Price + dbo.[v_Orders Raw Pricing Options V2].Price + dbo.[v_Orders Raw Pricing NPO V2].Price) AS [Gross Price], CONVERT(int, 
                      dbo.[v_Orders Raw Pricing Options V2].Price) AS [Options Price], CONVERT(int, dbo.[v_Orders Raw Pricing NPO V2].Price) AS [NPO Price], CONVERT(int, 
                      dbo.[Order HoursV2].COGS) AS [Base Cost], CONVERT(int, dbo.[v_Orders Raw Pricing NPO V2].Cost) AS [NPO Cost], CONVERT(int, dbo.[v_Orders Raw Pricing Options V2].Cost) 
                      AS [Options Cost], CONVERT(int, dbo.[Order HoursV2].COGS) + CONVERT(int, dbo.[v_Orders Raw Pricing NPO V2].Cost) + CONVERT(int, 
                      dbo.[v_Orders Raw Pricing Options V2].Cost) AS [Total Cost], dbo.[ProductsV2].Grouping AS Class, dbo.[DealersV2].Initials, dbo.[DealersV2].[COMPANY NAME], 
                      dbo.[DealersV2].[Eastern Canada], dbo.[DealersV2].[Eastern US], dbo.[DealersV2].[Central Canada], dbo.[DealersV2].[Central US], dbo.[DealersV2].[Western Canada], 
                      dbo.[DealersV2].[Western US], 
                      CASE WHEN [central us] = 1 THEN '1' WHEN [central canada] = 1 THEN '3' WHEN [eastern us] = 1 THEN '1' WHEN [eastern canada] = 1 THEN '2' WHEN [western us] =
                       1 THEN '1' WHEN [western canada] = 1 THEN '3' ELSE 5 END AS Grouping, dbo.[OrdersV2].[Invoice Date], dbo.[OrdersV2].[Date Declined], 
                      dbo.[v_Dealer Totals Breakdown By Quote V2].Label, dbo.[v_Dealer Totals Breakdown By Quote V2].LabelTtl, dbo.[v_Dealer Totals Breakdown By Quote V2].Section, 
                      dbo.[v_Dealer Totals Breakdown By Quote V2].LabelSection, dbo.[v_Dealer Totals Breakdown By Quote V2].US, dbo.[v_Dealer Totals Breakdown By Quote V2].LabelUS, 
                      dbo.[v_Class Totals Breakdown V2].ClassGroup, dbo.[v_Class Totals Breakdown V2].ClassSort, dbo.[OrdersV2].[Volume Discount], dbo.[OrdersV2].[Program Discount], 
                      dbo.[OrdersV2].[Quote Date], 
					  CONVERT(decimal(14, 0), 
							case when [Quote Date] is null or [Quote Date] >= 'january 1 2019' 
								 then ((((dbo.[OrdersV2].Price + dbo.[v_Orders Raw Pricing Options V2].Price + dbo.[v_Orders Raw Pricing NPO V2].Price) 
										+ (case when Discount1_Type = 'Fixed' then [OrdersV2].Discount1 when Discount1_Type = 'Percent' then (dbo.[OrdersV2].Price + dbo.[v_Orders Raw Pricing Options V2].Price + dbo.[v_Orders Raw Pricing NPO V2].Price) * (dbo.[OrdersV2].Discount1 * -1) else 0 end)) 
									    + (case when Discount2_Type = 'Fixed' then [OrdersV2].Discount2 when Discount2_Type = 'Percent' then ((dbo.[OrdersV2].Price + dbo.[v_Orders Raw Pricing Options V2].Price + dbo.[v_Orders Raw Pricing NPO V2].Price)
																																		  + (case when Discount1_Type = 'Fixed' then [OrdersV2].Discount1 when Discount1_Type = 'Percent' then (dbo.[OrdersV2].Price + dbo.[v_Orders Raw Pricing Options V2].Price + dbo.[v_Orders Raw Pricing NPO V2].Price) * (1 - dbo.[OrdersV2].Discount1) end)) * (dbo.[OrdersV2].Discount2 * -1) else 0 end))
										+ (case when Discount3_Type = 'Fixed' then [OrdersV2].Discount3 when Discount3_Type = 'Percent' then (((dbo.[OrdersV2].Price + dbo.[v_Orders Raw Pricing Options V2].Price + dbo.[v_Orders Raw Pricing NPO V2].Price)
																																		  + (case when Discount1_Type = 'Fixed' then [OrdersV2].Discount1 when Discount1_Type = 'Percent' then (dbo.[OrdersV2].Price + dbo.[v_Orders Raw Pricing Options V2].Price + dbo.[v_Orders Raw Pricing NPO V2].Price) * (1 - dbo.[OrdersV2].Discount1) end)) 
																																		  + (case when Discount2_Type = 'Fixed' then [OrdersV2].Discount2 
																																				  when Discount2_Type = 'Percent' then (case when Discount1_Type = 'Fixed' then [OrdersV2].Discount1 when Discount1_Type = 'Percent' then (dbo.[OrdersV2].Price + dbo.[v_Orders Raw Pricing Options V2].Price + dbo.[v_Orders Raw Pricing NPO V2].Price) * (1 - dbo.[OrdersV2].Discount1) end)
																																														* (1 - dbo.[OrdersV2].Discount2) end)) * (dbo.[OrdersV2].Discount3 * -1) else 0 end))
								 else ((dbo.[OrdersV2].Price + dbo.[v_Orders Raw Pricing Options V2].Price + dbo.[v_Orders Raw Pricing NPO V2].Price) * (1 - dbo.[OrdersV2].[Volume Discount])) * (1 - dbo.[OrdersV2].[Program Discount])
								 end) AS [Net Price], 
					  dbo.[v_Orders Raw Pricing NPO V2].[# NPOs], dbo.[OrdersV2].[Delivery Date], 
                      dbo.[OrdersV2].[PO Date], dbo.[OrdersV2].[Order Date], dbo.[OrdersV2].[Special Instructions]
FROM         dbo.[OrdersV2] with (nolock) INNER JOIN
                      dbo.[ProductsV2] with (nolock) ON dbo.[OrdersV2].[Model No] = dbo.[ProductsV2].[Model No] INNER JOIN
                      dbo.[DealersV2] with (nolock) ON dbo.[OrdersV2].DealerID = dbo.[DealersV2].ID INNER JOIN
                      dbo.[v_Class Totals Breakdown V2] ON dbo.[ProductsV2].Grouping = dbo.[v_Class Totals Breakdown V2].Grouping INNER JOIN
                      dbo.[v_Orders Raw Pricing NPO V2]  ON dbo.[OrdersV2].[SGQuote] = dbo.[v_Orders Raw Pricing NPO V2].[SGQuote] INNER JOIN
                      dbo.[v_Orders Raw Pricing Options V2] ON dbo.[OrdersV2].[SGQuote] = dbo.[v_Orders Raw Pricing Options V2].[SGQuote] INNER JOIN
                      dbo.[Order HoursV2] with (nolock) ON dbo.[OrdersV2].[SGQuote] = dbo.[Order HoursV2].[SGQuote] LEFT OUTER JOIN
                      dbo.[v_Dealer Totals Breakdown By Quote V2] ON dbo.[OrdersV2].[SGQuote] = dbo.[v_Dealer Totals Breakdown By Quote V2].[SGQuote]
WHERE     (dbo.[OrdersV2].WO# < 30000000) OR
                      (dbo.[OrdersV2].WO# IS NULL)
GROUP BY dbo.[OrdersV2].[SGQuote], dbo.[OrdersV2].Price, dbo.[ProductsV2].[Model No], dbo.[ProductsV2].Grouping, dbo.[DealersV2].Initials, dbo.[DealersV2].[COMPANY NAME], 
                      dbo.[DealersV2].[Eastern Canada], dbo.[DealersV2].[Eastern US], dbo.[DealersV2].[Central Canada], dbo.[DealersV2].[Central US], dbo.[DealersV2].[Western Canada], 
                      dbo.[DealersV2].[Western US], 
                      CASE WHEN [central us] = 1 THEN '1' WHEN [central canada] = 1 THEN '3' WHEN [eastern us] = 1 THEN '1' WHEN [eastern canada] = 1 THEN '2' WHEN [western us] =
                       1 THEN '1' WHEN [western canada] = 1 THEN '3' ELSE 5 END, dbo.[OrdersV2].[Invoice Date], dbo.[OrdersV2].[Date Declined], dbo.[v_Dealer Totals Breakdown By Quote V2].Label, 
                      dbo.[v_Dealer Totals Breakdown By Quote V2].LabelTtl, dbo.[v_Dealer Totals Breakdown By Quote V2].Section, dbo.[v_Dealer Totals Breakdown By Quote V2].LabelSection, 
                      dbo.[v_Dealer Totals Breakdown By Quote V2].US, dbo.[v_Dealer Totals Breakdown By Quote V2].LabelUS, dbo.[v_Class Totals Breakdown V2].ClassGroup, 
                      dbo.[v_Class Totals Breakdown V2].ClassSort, dbo.[v_Orders Raw Pricing Options V2].Price, 
                      dbo.[OrdersV2].Price + dbo.[v_Orders Raw Pricing Options V2].Price + dbo.[v_Orders Raw Pricing NPO V2].Price, dbo.[v_Orders Raw Pricing NPO V2].Price, 
                      dbo.[v_Orders Raw Pricing NPO V2].Cost, dbo.[v_Orders Raw Pricing Options V2].Cost, dbo.[OrdersV2].[Volume Discount], dbo.[OrdersV2].[Program Discount], CONVERT(int, 
                      dbo.[Order HoursV2].COGS), CONVERT(int, dbo.[Order HoursV2].COGS) + CONVERT(int, dbo.[v_Orders Raw Pricing NPO V2].Cost) + CONVERT(int, 
                      dbo.[v_Orders Raw Pricing Options V2].Cost), dbo.[OrdersV2].[Quote Date], 
					  CONVERT(decimal(14, 0), 
							case when [Quote Date] is null or [Quote Date] >= 'january 1 2019' 
								 then ((((dbo.[OrdersV2].Price + dbo.[v_Orders Raw Pricing Options V2].Price + dbo.[v_Orders Raw Pricing NPO V2].Price) 
										+ (case when Discount1_Type = 'Fixed' then [OrdersV2].Discount1 when Discount1_Type = 'Percent' then (dbo.[OrdersV2].Price + dbo.[v_Orders Raw Pricing Options V2].Price + dbo.[v_Orders Raw Pricing NPO V2].Price) * (dbo.[OrdersV2].Discount1 * -1) else 0 end)) 
									    + (case when Discount2_Type = 'Fixed' then [OrdersV2].Discount2 when Discount2_Type = 'Percent' then ((dbo.[OrdersV2].Price + dbo.[v_Orders Raw Pricing Options V2].Price + dbo.[v_Orders Raw Pricing NPO V2].Price)
																																		  + (case when Discount1_Type = 'Fixed' then [OrdersV2].Discount1 when Discount1_Type = 'Percent' then (dbo.[OrdersV2].Price + dbo.[v_Orders Raw Pricing Options V2].Price + dbo.[v_Orders Raw Pricing NPO V2].Price) * (1 - dbo.[OrdersV2].Discount1) end)) * (dbo.[OrdersV2].Discount2 * -1) else 0 end))
										+ (case when Discount3_Type = 'Fixed' then [OrdersV2].Discount3 when Discount3_Type = 'Percent' then (((dbo.[OrdersV2].Price + dbo.[v_Orders Raw Pricing Options V2].Price + dbo.[v_Orders Raw Pricing NPO V2].Price)
																																		  + (case when Discount1_Type = 'Fixed' then [OrdersV2].Discount1 when Discount1_Type = 'Percent' then (dbo.[OrdersV2].Price + dbo.[v_Orders Raw Pricing Options V2].Price + dbo.[v_Orders Raw Pricing NPO V2].Price) * (1 - dbo.[OrdersV2].Discount1) end)) 
																																		  + (case when Discount2_Type = 'Fixed' then [OrdersV2].Discount2 
																																				  when Discount2_Type = 'Percent' then (case when Discount1_Type = 'Fixed' then [OrdersV2].Discount1 when Discount1_Type = 'Percent' then (dbo.[OrdersV2].Price + dbo.[v_Orders Raw Pricing Options V2].Price + dbo.[v_Orders Raw Pricing NPO V2].Price) * (1 - dbo.[OrdersV2].Discount1) end)
																																														* (1 - dbo.[OrdersV2].Discount2) end)) * (dbo.[OrdersV2].Discount3 * -1) else 0 end))
								 else ((dbo.[OrdersV2].Price + dbo.[v_Orders Raw Pricing Options V2].Price + dbo.[v_Orders Raw Pricing NPO V2].Price) * (1 - dbo.[OrdersV2].[Volume Discount])) * (1 - dbo.[OrdersV2].[Program Discount])
								 end), 
					  CONVERT(int, dbo.[OrdersV2].Price + dbo.[v_Orders Raw Pricing Options V2].Price + dbo.[v_Orders Raw Pricing NPO V2].Price), 
                      dbo.[v_Orders Raw Pricing NPO V2].[# NPOs], dbo.[OrdersV2].[PO Date], dbo.[OrdersV2].Width, dbo.[OrdersV2].Spread, dbo.[OrdersV2].[Delivery Date], dbo.[OrdersV2].[Order Date], 
                      dbo.[OrdersV2].[Special Instructions]

GO


