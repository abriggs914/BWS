USE [Stargatedb]
GO

/****** Object:  View [dbo].[v_Orders Raw Pricing]    Script Date: 2022-02-10 12:09:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[v_Orders Raw Pricing]
AS
SELECT     [BWSdb].dbo.OrdersV2.SGQuote, [BWSdb].dbo.ProductsV2.[Model No], CONVERT(int, [BWSdb].dbo.OrdersV2.Price) AS Price, 
                      [BWSdb].dbo.OrdersV2.Price + dbo.[v_Orders Raw Pricing Options].Price + dbo.[v_Orders Raw Pricing NPO].Price AS [Gross Price], CONVERT(int, 
                      dbo.[v_Orders Raw Pricing Options].Price) AS [Options Price], CONVERT(int, dbo.[v_Orders Raw Pricing NPO].Price) AS [NPO Price], CONVERT(int, 
                      dbo.[Order Hours].COGS) AS [Base Cost], CONVERT(int, dbo.[v_Orders Raw Pricing NPO].Cost) AS [NPO Cost], CONVERT(int, dbo.[v_Orders Raw Pricing Options].Cost) 
                      AS [Options Cost], CONVERT(int, dbo.[Order Hours].COGS) + CONVERT(int, dbo.[v_Orders Raw Pricing NPO].Cost) + CONVERT(int, 
                      dbo.[v_Orders Raw Pricing Options].Cost) AS [Total Cost], [BWSdb].dbo.ProductsV2.Grouping AS Class, [BWSdb].dbo.DealersV2.Initials, [BWSdb].dbo.DealersV2.[COMPANY NAME], 
                      [BWSdb].dbo.DealersV2.[Eastern Canada], [BWSdb].dbo.DealersV2.[Eastern US], [BWSdb].dbo.DealersV2.[Central Canada], [BWSdb].dbo.DealersV2.[Central US], [BWSdb].dbo.DealersV2.[Western Canada], 
                      [BWSdb].dbo.DealersV2.[Western US], 
                      CASE WHEN [central us] = 1 THEN '1' WHEN [central canada] = 1 THEN '3' WHEN [eastern us] = 1 THEN '1' WHEN [eastern canada] = 1 THEN '2' WHEN [western us] =
                       1 THEN '1' WHEN [western canada] = 1 THEN '3' ELSE 5 END AS Grouping, [BWSdb].dbo.OrdersV2.[Invoice Date], [BWSdb].dbo.OrdersV2.[Date Declined], 
                      dbo.[v_Dealer Totals Breakdown By Quote].Label, dbo.[v_Dealer Totals Breakdown By Quote].LabelTtl, dbo.[v_Dealer Totals Breakdown By Quote].Section, 
                      dbo.[v_Dealer Totals Breakdown By Quote].LabelSection, dbo.[v_Dealer Totals Breakdown By Quote].US, dbo.[v_Dealer Totals Breakdown By Quote].LabelUS, 
                      dbo.[v_Class Totals Breakdown].ClassGroup, dbo.[v_Class Totals Breakdown].ClassSort, [BWSdb].dbo.OrdersV2.[Volume Discount], [BWSdb].dbo.OrdersV2.[Program Discount], 
					  Discount1_Type, Discount1, Discount2_Type, Discount2, Discount3_Type, Discount3,
                      [BWSdb].dbo.ProductsV2.Weight + dbo.[v_Orders Raw Pricing Options].[Ext Wt] + dbo.[v_Orders Raw Pricing NPO].[NPO Wt] AS [Total Weight], [BWSdb].dbo.OrdersV2.WO#, 
                      dbo.[v_Orders Raw Pricing NPO].[# NPOs], 
                      SUM(dbo.[Order Hours].[Machine Shop] + dbo.[Order Hours].Axles + dbo.[Order Hours].[Stakes/Bunks] + dbo.[Order Hours].Beam + dbo.[Order Hours].GNK + dbo.[Order Hours].Parts
                       + dbo.[Order Hours].Line + dbo.[Order Hours].Blast + dbo.[Order Hours].Paint + dbo.[Order Hours].Finish + dbo.[v_Orders Raw Pricing Options].TtlOptHrs + dbo.[v_Orders Raw Pricing NPO].TtlNPOHrs)
                       AS TtlHrs, 
					   CONVERT(decimal(14, 0), 
							case when [Quote Date] is null or [Quote Date] >= 'january 1 2019' 
								 then (((([BWSdb].dbo.[OrdersV2].Price + dbo.[v_Orders Raw Pricing Options].Price + dbo.[v_Orders Raw Pricing NPO].Price) 
										+ (case when Discount1_Type = 'Fixed' then OrdersV2.Discount1 when Discount1_Type = 'Percent' then ([BWSdb].dbo.OrdersV2.Price + dbo.[v_Orders Raw Pricing Options].Price + dbo.[v_Orders Raw Pricing NPO].Price) * ([BWSdb].dbo.OrdersV2.Discount1 * -1) else 0 end)) 
									    + (case when Discount2_Type = 'Fixed' then OrdersV2.Discount2 when Discount2_Type = 'Percent' then (([BWSdb].dbo.OrdersV2.Price + dbo.[v_Orders Raw Pricing Options].Price + dbo.[v_Orders Raw Pricing NPO].Price)
																																		  + (case when Discount1_Type = 'Fixed' then OrdersV2.Discount1 when Discount1_Type = 'Percent' then ([BWSdb].dbo.OrdersV2.Price + dbo.[v_Orders Raw Pricing Options].Price + dbo.[v_Orders Raw Pricing NPO].Price) * (1 - [BWSdb].dbo.OrdersV2.Discount1) end)) * ([BWSdb].dbo.OrdersV2.Discount2 * -1) else 0 end))
										+ (case when Discount3_Type = 'Fixed' then OrdersV2.Discount3 when Discount3_Type = 'Percent' then ((([BWSdb].dbo.OrdersV2.Price + dbo.[v_Orders Raw Pricing Options].Price + dbo.[v_Orders Raw Pricing NPO].Price)
																																		  + (case when Discount1_Type = 'Fixed' then OrdersV2.Discount1 when Discount1_Type = 'Percent' then ([BWSdb].dbo.OrdersV2.Price + dbo.[v_Orders Raw Pricing Options].Price + dbo.[v_Orders Raw Pricing NPO].Price) * (1 - [BWSdb].dbo.OrdersV2.Discount1) end)) 
																																		  + (case when Discount2_Type = 'Fixed' then OrdersV2.Discount2 
																																				  when Discount2_Type = 'Percent' then (case when Discount1_Type = 'Fixed' then OrdersV2.Discount1 when Discount1_Type = 'Percent' then ([BWSdb].dbo.OrdersV2.Price + dbo.[v_Orders Raw Pricing Options].Price + dbo.[v_Orders Raw Pricing NPO].Price) * (1 - [BWSdb].dbo.OrdersV2.Discount1) end)
																																														* (1 - [BWSdb].dbo.OrdersV2.Discount2) end)) * ([BWSdb].dbo.OrdersV2.Discount3 * -1) else 0 end))
								 else (([BWSdb].dbo.[OrdersV2].Price + dbo.[v_Orders Raw Pricing Options].Price + dbo.[v_Orders Raw Pricing NPO].Price) * (1 - [BWSdb].dbo.OrdersV2.[Volume Discount])) * (1 - [BWSdb].dbo.OrdersV2.[Program Discount])
								 end) AS [Selling Price]
FROM         [BWSdb].dbo.[OrdersV2] with (nolock) INNER JOIN
                      [BWSdb].dbo.[ProductsV2] with (nolock) ON [BWSdb].dbo.OrdersV2.[Model No] = [BWSdb].dbo.ProductsV2.[Model No] INNER JOIN
                      [BWSdb].dbo.DealersV2 with (nolock) ON [BWSdb].dbo.OrdersV2.DealerID = [BWSdb].dbo.DealersV2.ID INNER JOIN
                      dbo.[v_Class Totals Breakdown] ON [BWSdb].dbo.ProductsV2.Grouping = dbo.[v_Class Totals Breakdown].Grouping INNER JOIN
                      dbo.[v_Orders Raw Pricing NPO] ON [BWSdb].dbo.OrdersV2.SGQuote = dbo.[v_Orders Raw Pricing NPO].SGQuote INNER JOIN
                      dbo.[v_Orders Raw Pricing Options] ON [BWSdb].dbo.OrdersV2.SGQuote = dbo.[v_Orders Raw Pricing Options].SGQuote INNER JOIN
                      dbo.[Order Hours] with (nolock) ON [BWSdb].dbo.OrdersV2.SGQuote = dbo.[Order Hours].SGQuote LEFT OUTER JOIN
                      dbo.[v_Dealer Totals Breakdown By Quote] ON [BWSdb].dbo.OrdersV2.SGQuote = dbo.[v_Dealer Totals Breakdown By Quote].SGQuote
WHERE     (left([BWSdb].dbo.OrdersV2.WO#, 1) not in ('3', '5')) OR
                      ([BWSdb].dbo.OrdersV2.WO# IS NULL)
GROUP BY [BWSdb].dbo.OrdersV2.SGQuote, [BWSdb].dbo.OrdersV2.[Quote Date], [BWSdb].dbo.OrdersV2.Price, [BWSdb].dbo.ProductsV2.[Model No], [BWSdb].dbo.ProductsV2.Grouping, [BWSdb].dbo.DealersV2.Initials, [BWSdb].dbo.DealersV2.[COMPANY NAME], 
                      [BWSdb].dbo.DealersV2.[Eastern Canada], [BWSdb].dbo.DealersV2.[Eastern US], [BWSdb].dbo.DealersV2.[Central Canada], [BWSdb].dbo.DealersV2.[Central US], [BWSdb].dbo.DealersV2.[Western Canada], 
                      [BWSdb].dbo.DealersV2.[Western US], 
                      CASE WHEN [central us] = 1 THEN '1' WHEN [central canada] = 1 THEN '3' WHEN [eastern us] = 1 THEN '1' WHEN [eastern canada] = 1 THEN '2' WHEN [western us] =
                       1 THEN '1' WHEN [western canada] = 1 THEN '3' ELSE 5 END, [BWSdb].dbo.OrdersV2.[Invoice Date], [BWSdb].dbo.OrdersV2.[Date Declined], dbo.[v_Dealer Totals Breakdown By Quote].Label, 
                      dbo.[v_Dealer Totals Breakdown By Quote].LabelTtl, dbo.[v_Dealer Totals Breakdown By Quote].Section, dbo.[v_Dealer Totals Breakdown By Quote].LabelSection, 
                      dbo.[v_Dealer Totals Breakdown By Quote].US, dbo.[v_Dealer Totals Breakdown By Quote].LabelUS, dbo.[v_Class Totals Breakdown].ClassGroup, 
                      dbo.[v_Class Totals Breakdown].ClassSort, dbo.[v_Orders Raw Pricing Options].Price, 
                      [BWSdb].dbo.OrdersV2.Price + dbo.[v_Orders Raw Pricing Options].Price + dbo.[v_Orders Raw Pricing NPO].Price, dbo.[v_Orders Raw Pricing NPO].Price, 
                      dbo.[v_Orders Raw Pricing NPO].Cost, dbo.[v_Orders Raw Pricing Options].Cost, [BWSdb].dbo.OrdersV2.[Volume Discount], [BWSdb].dbo.OrdersV2.[Program Discount], 
					  Discount1_Type, Discount1, Discount2_Type, Discount2, Discount3_Type, Discount3,
					  CONVERT(int, dbo.[Order Hours].COGS), CONVERT(int, dbo.[Order Hours].COGS) + CONVERT(int, dbo.[v_Orders Raw Pricing NPO].Cost) + CONVERT(int, 
                      dbo.[v_Orders Raw Pricing Options].Cost), [BWSdb].dbo.ProductsV2.Weight + dbo.[v_Orders Raw Pricing Options].[Ext Wt] + dbo.[v_Orders Raw Pricing NPO].[NPO Wt], 
                     [BWSdb].dbo.OrdersV2.WO#, dbo.[v_Orders Raw Pricing NPO].[# NPOs], 
					  CONVERT(decimal(14, 0), 
							case when [Quote Date] is null or [Quote Date] >= 'january 1 2019' 
								 then (((([BWSdb].dbo.OrdersV2.Price + dbo.[v_Orders Raw Pricing Options].Price + dbo.[v_Orders Raw Pricing NPO].Price) 
										+ (case when Discount1_Type = 'Fixed' then OrdersV2.Discount1 when Discount1_Type = 'Percent' then ([BWSdb].dbo.OrdersV2.Price + dbo.[v_Orders Raw Pricing Options].Price + dbo.[v_Orders Raw Pricing NPO].Price) * ([BWSdb].dbo.OrdersV2.Discount1 * -1) else 0 end)) 
									    + (case when Discount2_Type = 'Fixed' then OrdersV2.Discount2 when Discount2_Type = 'Percent' then (([BWSdb].dbo.OrdersV2.Price + dbo.[v_Orders Raw Pricing Options].Price + dbo.[v_Orders Raw Pricing NPO].Price)
																																		  + (case when Discount1_Type = 'Fixed' then OrdersV2.Discount1 when Discount1_Type = 'Percent' then ([BWSdb].dbo.OrdersV2.Price + dbo.[v_Orders Raw Pricing Options].Price + dbo.[v_Orders Raw Pricing NPO].Price) * (1 - [BWSdb].dbo.OrdersV2.Discount1) end)) * ([BWSdb].dbo.OrdersV2.Discount2 * -1) else 0 end))
										+ (case when Discount3_Type = 'Fixed' then OrdersV2.Discount3 when Discount3_Type = 'Percent' then ((([BWSdb].dbo.OrdersV2.Price + dbo.[v_Orders Raw Pricing Options].Price + dbo.[v_Orders Raw Pricing NPO].Price)
																																		  + (case when Discount1_Type = 'Fixed' then OrdersV2.Discount1 when Discount1_Type = 'Percent' then ([BWSdb].dbo.OrdersV2.Price + dbo.[v_Orders Raw Pricing Options].Price + dbo.[v_Orders Raw Pricing NPO].Price) * (1 - [BWSdb].dbo.OrdersV2.Discount1) end)) 
																																		  + (case when Discount2_Type = 'Fixed' then OrdersV2.Discount2 
																																				  when Discount2_Type = 'Percent' then (case when Discount1_Type = 'Fixed' then OrdersV2.Discount1 when Discount1_Type = 'Percent' then ([BWSdb].dbo.OrdersV2.Price + dbo.[v_Orders Raw Pricing Options].Price + dbo.[v_Orders Raw Pricing NPO].Price) * (1 - [BWSdb].dbo.OrdersV2.Discount1) end)
																																														* (1 - [BWSdb].dbo.OrdersV2.Discount2) end)) * ([BWSdb].dbo.OrdersV2.Discount3 * -1) else 0 end))
								 else (([BWSdb].dbo.OrdersV2.Price + dbo.[v_Orders Raw Pricing Options].Price + dbo.[v_Orders Raw Pricing NPO].Price) * (1 - [BWSdb].dbo.OrdersV2.[Volume Discount])) * (1 - [BWSdb].dbo.OrdersV2.[Program Discount])
								 end)





GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[45] 4[28] 2[4] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1[50] 4[25] 3) )"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4[30] 2[40] 3) )"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4[66] 3) )"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Orders"
            Begin Extent = 
               Top = 7
               Left = 631
               Bottom = 313
               Right = 787
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Products"
            Begin Extent = 
               Top = 6
               Left = 251
               Bottom = 114
               Right = 419
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "Dealers"
            Begin Extent = 
               Top = 7
               Left = 818
               Bottom = 246
               Right = 1002
            End
            DisplayFlags = 280
            TopColumn = 10
         End
         Begin Table = "v_Class Totals Breakdown"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 100
               Right = 205
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "v_Orders Raw Pricing NPO"
            Begin Extent = 
               Top = 102
               Left = 38
               Bottom = 211
               Right = 205
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "v_Orders Raw Pricing Options"
            Begin Extent = 
               Top = 114
               Left = 243
               Bottom = 223
               Right = 410
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Order Hours"
            Begin Extent = 
               Top = 216
               Left = 38
               Bottom = 325
               Right =' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_Orders Raw Pricing'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N' 211
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "v_Dealer Totals Breakdown"
            Begin Extent = 
               Top = 228
               Left = 249
               Bottom = 337
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 35
         Width = 284
         Width = 1065
         Width = 795
         Width = 945
         Width = 1245
         Width = 1410
         Width = 1440
         Width = 1260
         Width = 840
         Width = 2235
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1200
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 27270
         Alias = 1650
         Table = 3015
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_Orders Raw Pricing'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_Orders Raw Pricing'
GO


