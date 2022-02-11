USE [Stargatedb]
GO

/****** Object:  View [dbo].[v_Dealer Totals Breakdown By Quote And Date]    Script Date: 2022-02-10 12:04:06 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[v_Dealer Totals Breakdown By Quote And Date]
AS
SELECT        OrderMonth, OrderYear, SGQuote, Initials, 
                         CASE [v_Dealer Listing By Quote And Date].Grouping WHEN '5' THEN 'Proprietary, Direct & Other' WHEN '4' THEN 'American Dealers' WHEN '2' THEN 'Eastern Canadian Dealers' WHEN '1' THEN 'American Dealers' WHEN '3' THEN
                          'Western Canadian Dealers' ELSE '' END AS Label, 
                         CASE [v_Dealer Listing By Quote And Date].Grouping WHEN '5' THEN 'Ttl Dir/Other' WHEN '4' THEN 'Ttl US' WHEN '2' THEN 'Ttl East Cdn.' WHEN '1' THEN 'Ttl US' WHEN '3' THEN 'Ttl West Cdn.' ELSE '' END AS LabelTtl, 
                         CASE [v_Dealer Listing By Quote And Date].Grouping WHEN '5' THEN 'Other' WHEN '3' THEN 'Western' WHEN '1' THEN 'American' WHEN '2' THEN 'Eastern' END AS Section, 
                         CASE [v_Dealer Listing By Quote And Date].Grouping WHEN '5' THEN 'Total Other' WHEN '3' THEN 'Total Western' WHEN '1' THEN 'Total American' WHEN '2' THEN 'Total Eastern' END AS LabelSection, [CDN/US] AS US, 
                         CASE [v_Dealer Listing By Quote And Date].[CDN/US] WHEN 'Canadian' THEN 'Total CDN' WHEN 'American' THEN 'Total US' END AS LabelUS, GROUPING
FROM            dbo.[v_Dealer Listing By Quote And Date]
WHERE        (Initials IS NOT NULL)
GROUP BY OrderMonth, OrderYear, SGQuote, Initials, 
                         CASE [v_Dealer Listing By Quote And Date].Grouping WHEN '5' THEN 'Proprietary, Direct & Other' WHEN '4' THEN 'American Dealers' WHEN '2' THEN 'Eastern Canadian Dealers' WHEN '1' THEN 'American Dealers' WHEN '3' THEN
                          'Western Canadian Dealers' ELSE '' END, 
                         CASE [v_Dealer Listing By Quote And Date].Grouping WHEN '5' THEN 'Ttl Dir/Other' WHEN '4' THEN 'Ttl US' WHEN '2' THEN 'Ttl East Cdn.' WHEN '1' THEN 'Ttl US' WHEN '3' THEN 'Ttl West Cdn.' ELSE '' END, 
                         CASE [v_Dealer Listing By Quote And Date].Grouping WHEN '5' THEN 'Other' WHEN '3' THEN 'Western' WHEN '1' THEN 'American' WHEN '2' THEN 'Eastern' END, 
                         CASE [v_Dealer Listing By Quote And Date].Grouping WHEN '5' THEN 'Total Other' WHEN '3' THEN 'Total Western' WHEN '1' THEN 'Total American' WHEN '2' THEN 'Total Eastern' END, [CDN/US], 
                         CASE [v_Dealer Listing By Quote And Date].[CDN/US] WHEN 'Canadian' THEN 'Total CDN' WHEN 'American' THEN 'Total US' END, GROUPING
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
         Begin Table = "v_Dealer Listing By Quote And Date"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 272
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_Dealer Totals Breakdown By Quote And Date'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_Dealer Totals Breakdown By Quote And Date'
GO


