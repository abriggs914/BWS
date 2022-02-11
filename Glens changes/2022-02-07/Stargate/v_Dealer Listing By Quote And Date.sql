USE [Stargatedb]
GO

/****** Object:  View [dbo].[v_Dealer Listing By Quote And Date]    Script Date: 2022-02-10 12:00:48 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[v_Dealer Listing By Quote And Date]
AS
SELECT        [BWSdb].dbo.OrdersV2.SGQuote, [BWSdb].dbo.DealersV2.[COMPANY NAME], [BWSdb].dbo.DealersV2.Initials,[BWSdb]. dbo.DealersV2.[Eastern Canada], [BWSdb].dbo.DealersV2.American, [BWSdb].dbo.DealersV2.[Central Canada], [BWSdb].dbo.DealersV2.[Western Canada], 
                         [BWSdb].dbo.DealersV2.[Proprietary/Direct/Other], CASE WHEN American = 1 AND 
                         [Proprietary/Direct/Other] = 0 THEN '1' WHEN [central canada] = 1 THEN '3' WHEN [eastern canada] = 1 THEN '2' WHEN [western canada] = 1 THEN '3' WHEN [Proprietary/Direct/Other] = 1 THEN 5 ELSE NULL 
                         END AS GROUPING, 
                         CASE WHEN American = 1 THEN 'American' WHEN [central canada] = 1 THEN 'Canadian' WHEN [eastern canada] = 1 THEN 'Canadian' WHEN [western canada] = 1 THEN 'Canadian' ELSE 'Canadian' END AS [CDN/US], 
                         MONTH(dbo.dtSalesPerformance.[Invoice Date]) AS OrderMonth, YEAR(dbo.dtSalesPerformance.[Invoice Date]) AS OrderYear
FROM            [BWSdb].dbo.DealersV2 WITH (nolock) INNER JOIN
                         [BWSdb].dbo.OrdersV2 WITH (nolock) ON [BWSdb].dbo.DealersV2.ID = [BWSdb].dbo.OrdersV2.DealerID INNER JOIN
                         dbo.dtSalesPerformance WITH (nolock) ON [BWSdb].dbo.OrdersV2.WO# = dbo.dtSalesPerformance.WO#
GROUP BY [BWSdb].dbo.OrdersV2.SGQuote, [BWSdb].dbo.DealersV2.[COMPANY NAME], [BWSdb].dbo.DealersV2.Initials, [BWSdb].dbo.DealersV2.[Eastern Canada], [BWSdb].dbo.DealersV2.American, [BWSdb].dbo.DealersV2.[Central Canada], [BWSdb].dbo.DealersV2.[Western Canada], 
                         [BWSdb].dbo.DealersV2.[Proprietary/Direct/Other], MONTH(dbo.dtSalesPerformance.[Invoice Date]), YEAR(dbo.dtSalesPerformance.[Invoice Date])
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[36] 4[5] 2[22] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
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
         Configuration = "(H (4 [50] 3))"
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
         Begin Table = "Dealers"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 276
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Orders"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 284
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "dtSalesPerformance"
            Begin Extent = 
               Top = 6
               Left = 314
               Bottom = 136
               Right = 515
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
      Begin ColumnWidths = 13
         Width = 284
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
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_Dealer Listing By Quote And Date'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_Dealer Listing By Quote And Date'
GO


