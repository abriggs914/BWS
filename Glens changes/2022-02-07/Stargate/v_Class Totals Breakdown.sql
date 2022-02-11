USE [Stargatedb]
GO

/****** Object:  View [dbo].[v_Class Totals Breakdown]    Script Date: 2022-02-10 12:10:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER VIEW [dbo].[v_Class Totals Breakdown]
AS
SELECT     Grouping, 
                      CASE [v_Class Listing].Grouping WHEN 'Sander Bodies' THEN 'Proprietary' WHEN 'Nuclear' THEN 'Proprietary' WHEN 'Container Chassis' THEN 'Proprietary' WHEN 'Cable Reels'
                       THEN 'Proprietary' WHEN 'Agriculture' THEN 'Proprietary' ELSE '' END AS ClassGroup, 
                      CASE [v_Class Listing].Grouping WHEN 'Oilfield Floats' THEN '10' WHEN 'Scissor Necks' THEN '10' WHEN 'Ridged Necks' THEN '10' WHEN 'Flip Axles' THEN '09' WHEN
                       'Air Detachables' THEN '08' WHEN 'Hydraulics' THEN '07' WHEN 'Jeeps' THEN '07' WHEN 'Loggers' THEN '07' WHEN 'Double Drops' THEN '06' WHEN 'Stepdecks' THEN
                       '05' WHEN 'Flatbeds' THEN '04' WHEN 'ET Pavers' THEN '03' WHEN 'ETs' THEN '02' WHEN 'Sander Bodies' THEN '01' WHEN 'Nuclear' THEN '01' WHEN 'Container Chassis'
                       THEN '01' WHEN 'Cable Reels' THEN '01' WHEN '27 ft Dumps' THEN '01' WHEN '37 ft Dumps' THEN '01' ELSE '11' END AS ClassSort
FROM         dbo.[v_Class Listing]
WHERE     (Grouping IS NOT NULL)

GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
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
         Begin Table = "v_Class Listing"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 70
               Right = 189
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
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_Class Totals Breakdown'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_Class Totals Breakdown'
GO


