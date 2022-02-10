USE [Stargatedb]
GO

/****** Object:  View [dbo].[v_Order Book Detail v2]    Script Date: 2022-02-10 12:08:33 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[v_Order Book Detail v2]
AS
SELECT     dbo.[v_Orders Raw Pricing].SGQuote, dbo.[v_Orders Raw Pricing].Price, dbo.[v_Orders Raw Pricing].[Base Cost], dbo.[v_Orders Raw Pricing].[NPO Price], 
                      dbo.[v_Orders Raw Pricing].[NPO Cost], dbo.[v_Orders Raw Pricing].[Options Price], dbo.[v_Orders Raw Pricing].[Options Cost], 
                      dbo.[v_Orders Raw Pricing].[Gross Price], 
					  CONVERT(int, dbo.fn_QuoteRptV2_SellingPrice(OrdersV2.SGQuote, [Gross Price], OrdersV2.Discount3_Type, OrdersV2.Discount3, OrdersV2.[Volume Discount], OrdersV2.[Program Discount], OrdersV2.Discount1_Type, OrdersV2.Discount1,
								  OrdersV2.Discount2_Type, OrdersV2.Discount2)/*(dbo.[v_Orders Raw Pricing].[Gross Price] * (1 - case when dbo.Orders.[Volume Discount] is null then 0 else dbo.Orders.[Volume Discount] end)) 
                      * (1 - case when dbo.Orders.[Program Discount] is null then 0 else dbo.Orders.[Program Discount] end)*/) AS [Selling Price], 
					  dbo.[v_Orders Raw Pricing].[Total Cost], 
                      case when 
					  CONVERT(int, dbo.fn_QuoteRptV2_SellingPrice(OrdersV2.SGQuote, [Gross Price], OrdersV2.Discount3_Type, OrdersV2.Discount3, OrdersV2.[Volume Discount], OrdersV2.[Program Discount], OrdersV2.Discount1_Type, OrdersV2.Discount1,
								  OrdersV2.Discount2_Type, OrdersV2.Discount2)) = 0
					  then 0
					  else 
					  ((CONVERT(int, dbo.fn_QuoteRptV2_SellingPrice(OrdersV2.SGQuote, [Gross Price], OrdersV2.Discount3_Type, OrdersV2.Discount3, OrdersV2.[Volume Discount], OrdersV2.[Program Discount], OrdersV2.Discount1_Type, OrdersV2.Discount1,
								  OrdersV2.Discount2_Type, OrdersV2.Discount2)) - dbo.[v_Orders Raw Pricing].[Total Cost]) 
                      / CONVERT(int, dbo.fn_QuoteRptV2_SellingPrice(OrdersV2.SGQuote, [Gross Price], OrdersV2.Discount3_Type, OrdersV2.Discount3, OrdersV2.[Volume Discount], OrdersV2.[Program Discount], OrdersV2.Discount1_Type, OrdersV2.Discount1,
								  OrdersV2.Discount2_Type, OrdersV2.Discount2))) end AS Margin, 
					  case when [BWSdb].dbo.OrdersV2.[Volume Discount] is null then 0 else [BWSdb].dbo.OrdersV2.[Volume Discount] end as [Volume Discount], 
                      case when [BWSdb].dbo.OrdersV2.[Program Discount] is null then 0 else [BWSdb].dbo.OrdersV2.[Program Discount] end as [Program Discount], dbo.[v_Orders Raw Pricing].[Model No], dbo.[v_Orders Raw Pricing].Grouping, CONVERT(int, 
                      dbo.[v_Orders Raw Pricing].[Gross Price] * 1 - case when [BWSdb].dbo.OrdersV2.[Volume Discount] is null then 0 else [BWSdb].dbo.OrdersV2.[Volume Discount] end) AS [Vol Dis], CONVERT(int, 
                      (dbo.[v_Orders Raw Pricing].[Gross Price] * 1 - case when [BWSdb].dbo.OrdersV2.[Volume Discount] is null then 0 else [BWSdb].dbo.OrdersV2.[Volume Discount] end) * (1 - case when [BWSdb].dbo.OrdersV2.[Program Discount] is null then 0 else [BWSdb].dbo.OrdersV2.[Program Discount] end)) AS [Pro Dis], 
                      dbo.[v_Orders Raw Pricing].[COMPANY NAME], [BWSdb].dbo.OrdersV2.[PO Date], [BWSdb].dbo.OrdersV2.[Shipped Date], [BWSdb].dbo.OrdersV2.[Date Declined], 
					  case when [BWSdb].[dbo].OrdersV2.[GL Override Date] is not null then OrdersV2.[GL Override Date]
					       when [BWSdb].dbo.OrdersV2.[Invoice Date] is null then v_CompletedJobInfo.EntInvoiceDate 
					       else OrdersV2.[Invoice Date] end as [Invoice Date], 
                      dbo.[v_Orders Raw Pricing].Initials, dbo.[v_Orders Raw Pricing].Class, dbo.[Payment Terms].[Payment Terms], [BWSdb].dbo.OrdersV2.[US Sale], [BWSdb].dbo.OrdersV2.WO#, 
                      [BWSdb].dbo.OrdersV2.DealerID, [BWSdb].dbo.OrdersV2.[Order Date], dbo.[v_Orders Raw Pricing].[# NPOs], [BWSdb].dbo.OrdersV2.[Special Instructions], dbo.[v_Orders Raw Pricing].TtlHrs
FROM         [BWSdb].dbo.OrdersV2 with (nolock) INNER JOIN
                      dbo.[v_Orders Raw Pricing] ON [BWSdb].dbo.OrdersV2.SGQuote = dbo.[v_Orders Raw Pricing].SGQuote LEFT OUTER JOIN
                      dbo.[Payment Terms] with (nolock) ON [BWSdb].dbo.OrdersV2.PayID = dbo.[Payment Terms].PayID
					  left outer join SysproCompanyA.dbo.v_CompletedJobInfo on CAST([BWSdb].dbo.OrdersV2.WO# AS varchar(20)) = v_CompletedJobInfo.Job
WHERE     (dbo.[v_Orders Raw Pricing].[COMPANY NAME] <> N'BWS Manufacturing Ltd.')








GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[26] 4[38] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1[22] 4[53] 3) )"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[25] 2[34] 3) )"
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
         Begin Table = "Orders"
            Begin Extent = 
               Top = 8
               Left = 65
               Bottom = 116
               Right = 263
            End
            DisplayFlags = 280
            TopColumn = 11
         End
         Begin Table = "v_Orders Raw Pricing"
            Begin Extent = 
               Top = 6
               Left = 301
               Bottom = 115
               Right = 465
            End
            DisplayFlags = 280
            TopColumn = 33
         End
         Begin Table = "Payment Terms"
            Begin Extent = 
               Top = 120
               Left = 38
               Bottom = 199
               Right = 192
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
      Begin ColumnWidths = 32
         Width = 284
         Width = 870
         Width = 570
         Width = 1005
         Width = 990
         Width = 960
         Width = 1230
         Width = 1185
         Width = 1260
         Width = 1455
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
         Width = 2370
         Width = 1995
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
      Begin ColumnWidths = 11
         Column = 12780
         Al' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_Order Book Detail v2'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'ias = 1905
         Table = 3330
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 2415
         Or = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_Order Book Detail v2'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_Order Book Detail v2'
GO


