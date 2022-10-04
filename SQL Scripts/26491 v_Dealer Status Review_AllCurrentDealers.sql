SELECT
  [v_Dealer Status Review_AllCurrentDealers].[COMPANY NAME]
  ,[v_Dealer Status Review_AllCurrentDealers].Quote#
  ,[v_Dealer Status Review_AllCurrentDealers].WO#
  ,[v_Dealer Status Review_AllCurrentDealers].[Model No]
  ,[v_Dealer Status Review_AllCurrentDealers].[Serial Number]
  ,[v_Dealer Status Review_AllCurrentDealers].PO
  ,[v_Dealer Status Review_AllCurrentDealers].Terms
  ,[v_Dealer Status Review_AllCurrentDealers].[PO Date]
  ,[v_Dealer Status Review_AllCurrentDealers].[Order Date]
  ,[v_Dealer Status Review_AllCurrentDealers].[Requested Delivery Date]
  ,[v_Dealer Status Review_AllCurrentDealers].[Date Completed]
  ,[v_Dealer Status Review_AllCurrentDealers].[Shipped Date]
  ,[v_Dealer Status Review_AllCurrentDealers].[Date Declined]
  ,[v_Dealer Status Review_AllCurrentDealers].[Base Price]
  ,[v_Dealer Status Review_AllCurrentDealers].Options
  ,[v_Dealer Status Review_AllCurrentDealers].Custom
  ,[v_Dealer Status Review_AllCurrentDealers].[Gross Price]
  ,[v_Dealer Status Review_AllCurrentDealers].[Volume Discount]
  ,[v_Dealer Status Review_AllCurrentDealers].[Vol Disc]
  ,[v_Dealer Status Review_AllCurrentDealers].[Program Discount]
  ,[v_Dealer Status Review_AllCurrentDealers].[Pro Disc]
  ,[v_Dealer Status Review_AllCurrentDealers].[Net Price]
  ,[v_Dealer Status Review_AllCurrentDealers].[Prod Date]
  ,[v_Dealer Status Review_AllCurrentDealers].Days
  ,[v_Dealer Status Review_AllCurrentDealers].GN1
  ,[v_Dealer Status Review_AllCurrentDealers].Paint
  ,[v_Dealer Status Review_AllCurrentDealers].Fin
  ,[v_Dealer Status Review_AllCurrentDealers].[Prod Days]
  ,[v_Dealer Status Review_AllCurrentDealers].[Finish Date]
  ,[v_Dealer Status Review_AllCurrentDealers].[Available Date]
  ,[v_Dealer Status Review_AllCurrentDealers].[Delivery Date]
FROM
  [v_Dealer Status Review_AllCurrentDealers]
 WHERE [Quote#] IN (26491, 26492, 26941, 26942)

ORDER BY
	[Quote#];